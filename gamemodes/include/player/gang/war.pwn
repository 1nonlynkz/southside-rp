#include <YSI_Coding\y_hooks>

#define MAX_WARS            100
#define WAR_PENALTY         500     
#define KILL_REWARD         550     
#define STREAK_BONUS        200
#define WAR_MAX_TIME        3600 

#define DIALOG_WAR_LIST     9001
#define DIALOG_WAR_PANEL    9002
#define DIALOG_WAR_REWARD   9003
#define DIALOG_WAR_ZONE     9004

new GangCash[MAX_GANGS];
new GangNames[MAX_GANGS][32];

new Float:GangHQ[MAX_GANGS][3];
new bool:HasHQ[MAX_GANGS];

enum eWar
{
    wID,
    wFrom,
    wTo,
    wReason[128],
    wStatus,
    wKillsFrom,
    wKillsTo,
    wReward,
    wLocation
};

new WarData[MAX_WARS][eWar];
new WarCount;

new bool:ActiveWar;
new ActiveWarID = -1;
new WarA, WarB;
new WarZone = -1;
new WarDurationTimer = -1;
new WarElapsedSeconds = 0;
new WarBoundaryTimer = -1;

new WarRespawnCooldown[MAX_PLAYERS];
new bool:InWarRespawn[MAX_PLAYERS];
new PlayerWarTimer[MAX_PLAYERS] = {-1, ...}; 
new PlayerKillStreak[MAX_PLAYERS];
new bool:SpawnProtected[MAX_PLAYERS];
new SpawnProtectTimer[MAX_PLAYERS] = {-1, ...};
new OutOfBoundsTime[MAX_PLAYERS];
new bool:FlaggedForWarReconnect[MAX_PLAYERS]; 

stock SendWarMessage(const text[])
{
    new str[144];
    format(str, sizeof(str), "{E74C3C}[WAR SYSTEM]{FFFFFF} %s", text);
    SendClientMessageToAll(-1, str);
}

stock GetGangName(gangid)
{
    new name[32];
    if(gangid >= 0 && gangid < MAX_GANGS && !isnull(GangNames[gangid]))
    {
        format(name, sizeof(name), "%s", GangNames[gangid]);
    }
    else
    {
        format(name, sizeof(name), "Gang ID %d", gangid); 
    }
    return name;
}

stock IsPlayerInWarZone(playerid)
{
    if(WarZone == -1) return 0;
    new loc = WarData[ActiveWarID][wLocation];
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);
    
    if(px >= (jobLocations[loc][jobX] - 120.0) && px <= (jobLocations[loc][jobX] + 120.0) &&
       py >= (jobLocations[loc][jobY] - 120.0) && py <= (jobLocations[loc][jobY] + 120.0))
    {
        return 1;
    }
    return 0;
}

hook OnGameModeInit()
{
    print("[WAR SYSTEM] Initializing and fetching gang profiles from MySQL...");
    mysql_tquery(connectionID, "SELECT * FROM `gang_data`", "OnLoadGangData", "");
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(ActiveWar)
    {
        new gang = PlayerInfo[playerid][pGang];
        if(gang == WarA || gang == WarB)
        {
            FlaggedForWarReconnect[playerid] = true;
        }
    }
    
    if(PlayerWarTimer[playerid] != -1) KillTimer(PlayerWarTimer[playerid]);
    if(SpawnProtectTimer[playerid] != -1) KillTimer(SpawnProtectTimer[playerid]);
    return 1;
}

forward OnLoadGangData();
public OnLoadGangData()
{
    new rows = cache_num_rows();
    if(rows)
    {
        for(new i = 0; i < rows; i++)
        {
            new gangid = cache_get_row_int(i, 0);
            if(gangid >= 0 && gangid < MAX_GANGS)
            {
                GangHQ[gangid][0] = cache_get_row_float(i, 1);
                GangHQ[gangid][1] = cache_get_row_float(i, 2);
                GangHQ[gangid][2] = cache_get_row_float(i, 3);
                GangCash[gangid]  = cache_get_row_int(i, 4);
                cache_get_field_content(i, "name", GangNames[gangid], connectionID, 32);

                if(GangHQ[gangid][0] != 0.0 && GangHQ[gangid][1] != 0.0) HasHQ[gangid] = true;
            }
        }
        printf("[WAR SYSTEM] Successfully cached %d gang data sheets.", rows);
    }
    return 1;
}

stock SaveGangDatabaseEntry(gangid)
{
    new query[256];
    mysql_format(connectionID, query, sizeof(query), 
        "INSERT INTO `gang_data` (`gangid`, `hq_x`, `hq_y`, `hq_z`, `cash`) VALUES (%d, %f, %f, %f, %d) \
        ON DUPLICATE KEY UPDATE `hq_x` = %f, `hq_y` = %f, `hq_z` = %f, `cash` = %d",
        gangid, GangHQ[gangid][0], GangHQ[gangid][1], GangHQ[gangid][2], GangCash[gangid],
        GangHQ[gangid][0], GangHQ[gangid][1], GangHQ[gangid][2], GangCash[gangid]
    );
    mysql_tquery(connectionID, query);
}

CMD:sethq(playerid, params[])
{
    new gangid;
    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, -1, "Error: You do not have permission to use this command.");
    if(sscanf(params, "d", gangid)) return SendClientMessage(playerid, -1, "Usage: /sethq [gangid]");
    if(gangid < 0 || gangid >= MAX_GANGS) return SendClientMessage(playerid, -1, "Error: Invalid gang ID.");

    GetPlayerPos(playerid, GangHQ[gangid][0], GangHQ[gangid][1], GangHQ[gangid][2]);
    HasHQ[gangid] = true;
    SaveGangDatabaseEntry(gangid);
    SendClientMessage(playerid, -1, "Success: Gang HQ location updated and saved.");
    return 1;
}

CMD:warrequest(playerid, params[])
{
    new target, reason[128];
    if(PlayerInfo[playerid][pGangRank] < 6) return SendClientMessage(playerid, -1, "Error: Only gang leaders can request a war.");
    if(sscanf(params, "ds[128]", target, reason)) return SendClientMessage(playerid, -1, "Usage: /warrequest [gangid] [reason]");
    if(target < 0 || target >= MAX_GANGS) return SendClientMessage(playerid, -1, "Error: Target gang ID does not exist.");

    new id = WarCount;
    WarData[id][wID] = id;
    WarData[id][wFrom] = PlayerInfo[playerid][pGang];
    WarData[id][wTo] = target;
    WarData[id][wStatus] = 0;
    WarData[id][wReward] = 100000;
    format(WarData[id][wReason], 128, "%s", reason);
    WarCount++;

    SendClientMessage(playerid, -1, "Success: War request sent to admins for review.");
    return 1;
}

CMD:warpanel(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, -1, "Error: You do not have permission to use this command.");
    new list[1024]; list[0] = '\0';

    for(new i = 0; i < WarCount; i++)
    {
        new line[164];
        format(line, sizeof(line), "ID %d | %s vs %s | Prize: $%d\n", i, GetGangName(WarData[i][wFrom]), GetGangName(WarData[i][wTo]), WarData[i][wReward]);
        strcat(list, line);
    }
    if(isnull(list)) return SendClientMessage(playerid, -1, "Notification: There are no pending war requests.");
    ShowPlayerDialog(playerid, DIALOG_WAR_LIST, DIALOG_STYLE_LIST, "WAR MANAGEMENT PANEL", list, "Select", "Close");
    return 1;
}

CMD:surrender(playerid, params[])
{
    if(!ActiveWar) return SendClientMessage(playerid, -1, "Error: There is no active gang war right now.");
    if(PlayerInfo[playerid][pGangRank] < 6) return SendClientMessage(playerid, -1, "Error: Only gang leaders (Rank 6) can surrender.");

    new gang = PlayerInfo[playerid][pGang];
    if(gang != WarA && gang != WarB) return SendClientMessage(playerid, -1, "Error: Your gang is not in this war.");

    new winner = (gang == WarA) ? WarB : WarA;
    SendWarMessage("=============================================");
    new msg[144];
    format(msg, sizeof(msg), "The gang %s has surrendered from the fight!", GetGangName(gang));
    SendWarMessage(msg);
    
    EndWar(winner);
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_WAR_LIST)
    {
        if(!response) return 1;
        SetPVarInt(playerid, "WarID", listitem);
        ShowPlayerDialog(playerid, DIALOG_WAR_PANEL, DIALOG_STYLE_LIST, "War Management Settings", "Approve Request & Teleport Players\nDeny Request\nModify Reward Bounty\nSet Active Combat Zone", "Select", "Back");
        return 1;
    }

    if(dialogid == DIALOG_WAR_PANEL)
    {
        new id = GetPVarInt(playerid, "WarID");
        if(!response) return 1;

        switch(listitem)
        {
            case 0: 
            {
                if(WarZone == -1) return SendClientMessage(playerid, -1, "{FF0000}Error:{FFFFFF} You must set a combat zone before approving the war.");

                ActiveWar = true;
                ActiveWarID = id;
                WarA = WarData[id][wFrom];
                WarB = WarData[id][wTo];
                WarData[id][wKillsFrom] = 0;
                WarData[id][wKillsTo] = 0;
                WarElapsedSeconds = 0;

                new loc = WarData[id][wLocation];
                GangZoneShowForAll(WarZone, 0xFF0000AA); 
                GangZoneFlashForAll(WarZone, 0xFFFFFFBB); 

                for(new i = 0; i < MAX_PLAYERS; i++)
                {
                    if(IsPlayerConnected(i))
                    {
                        FlaggedForWarReconnect[i] = false;
                        new playerGang = PlayerInfo[i][pGang];
                        if(playerGang == WarA || playerGang == WarB)
                        {
                            SetPlayerPos(i, jobLocations[loc][jobX], jobLocations[loc][jobY], jobLocations[loc][jobZ] + 1.5);
                            
                            ResetPlayerWeapons(i);
                            GivePlayerWeapon(i, 24, 200); 
                            GivePlayerWeapon(i, 31, 500); 
                            SendClientMessage(i, -1, "{00FF00}[WAR]{FFFFFF} Your gang war has started! You have been teleported and given weapons.");
                        }
                    }
                }

                SendWarMessage("=============================================");
                SendWarMessage("GLOBAL ANNOUNCEMENT: UNLIMITED GANG WAR STARTED!");
                new msg[164];
                format(msg, sizeof(msg), "%s vs %s has begun! This war is UNLIMITED until someone uses /surrender!", GetGangName(WarA), GetGangName(WarB));
                SendWarMessage(msg);
                SendWarMessage("=============================================");

                if(WarDurationTimer != -1) KillTimer(WarDurationTimer);
                WarDurationTimer = SetTimer("GlobalWarClock", 1000, true);

                if(WarBoundaryTimer != -1) KillTimer(WarBoundaryTimer);
                WarBoundaryTimer = SetTimer("BoundaryCheckTimer", 5000, true);
            }
            case 1:
            {
                WarData[id][wStatus] = 2;
                SendWarMessage("A pending war request was denied by an admin.");
            }
            case 2: ShowPlayerDialog(playerid, DIALOG_WAR_REWARD, DIALOG_STYLE_INPUT, "Prize Settings", "Enter the total cash reward below:", "Save", "Back");
            case 3:
            {
                new list[512]; list[0] = '\0';
                for(new i = 0; i < sizeof(jobLocations); i++)
                {
                    new line[64]; format(line, sizeof(line), "%s\n", jobLocations[i][jobName]);
                    strcat(list, line);
                }
                ShowPlayerDialog(playerid, DIALOG_WAR_ZONE, DIALOG_STYLE_LIST, "Select Active Combat Area", list, "Select", "Back");
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_WAR_REWARD)
    {
        if(!response) return 1;
        new id = GetPVarInt(playerid, "WarID");
        WarData[id][wReward] = strval(inputtext);
        SendClientMessage(playerid, -1, "Success: The cash reward prize has been updated.");
        return 1;
    }

    if(dialogid == DIALOG_WAR_ZONE)
    {
        if(!response) return 1;
        new id = GetPVarInt(playerid, "WarID");
        WarData[id][wLocation] = listitem;
        new loc = listitem;

        if(WarZone != -1) GangZoneDestroy(WarZone);
        WarZone = GangZoneCreate(
            jobLocations[loc][jobX] - 120.0, jobLocations[loc][jobY] - 120.0,
            jobLocations[loc][jobX] + 120.0, jobLocations[loc][jobX] + 120.0
        );
        SendClientMessage(playerid, -1, "Success: Combat area set. Map radar will update once the war starts.");
        return 1;
    }
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if(!ActiveWar) return 1;

    new gang = PlayerInfo[playerid][pGang];
    if(gang != WarA && gang != WarB) return 1; 

    GivePlayerMoney(playerid, -WAR_PENALTY);
    SendClientMessage(playerid, -1, "{E74C3C}[WAR]{FFFFFF} You died in war and lost $500.");
    PlayerKillStreak[playerid] = 0; 

    if(killerid != INVALID_PLAYER_ID)
    {
        new killerGang = PlayerInfo[killerid][pGang];
        if(killerGang == WarA || killerGang == WarB)
        {
            GivePlayerMoney(killerid, KILL_REWARD);
            PlayerKillStreak[killerid]++;
            PlayerPlaySound(killerid, 1058, 0.0, 0.0, 0.0); 

            new killMsg[128];
            format(killMsg, sizeof(killMsg), "{00FF00}[WAR]{FFFFFF} You killed an enemy! You received $%d. (Streak: %d)", KILL_REWARD, PlayerKillStreak[killerid]);
            SendClientMessage(killerid, -1, killMsg);

            if(PlayerKillStreak[killerid] >= 3)
            {
                GivePlayerMoney(killerid, STREAK_BONUS);
                new streakStr[144];
                format(streakStr, sizeof(streakStr), "[WAR STREAK] %s is on a Rampage! (%d Kills inside the zone!)", PlayerInfo[killerid][pUsername], PlayerKillStreak[killerid]);
                SendWarMessage(streakStr);
            }
        }
    }

    if(gang == WarA) WarData[ActiveWarID][wKillsTo]++;
    else if(gang == WarB) WarData[ActiveWarID][wKillsFrom]++;

    InWarRespawn[playerid] = true;
    WarRespawnCooldown[playerid] = 30;

    if(PlayerWarTimer[playerid] != -1) KillTimer(PlayerWarTimer[playerid]);
    PlayerWarTimer[playerid] = SetTimerEx("WarTimer", 1000, true, "i", playerid);
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    if(ActiveWar)
    {
        new gang = PlayerInfo[playerid][pGang];
        if(gang == WarA || gang == WarB)
        {
            if(FlaggedForWarReconnect[playerid])
            {
                FlaggedForWarReconnect[playerid] = false;
                new loc = WarData[ActiveWarID][wLocation];
                
                SetPlayerPos(playerid, jobLocations[loc][jobX], jobLocations[loc][jobY], jobLocations[loc][jobZ] + 1.5);
                ResetPlayerWeapons(playerid);
                GivePlayerWeapon(playerid, 24, 200); 
                GivePlayerWeapon(playerid, 31, 500); 
                
                SendClientMessage(playerid, -1, "{FF0000}[WAR ANTI-LOG]{FFFFFF} You left during an active war! Teleported back to the battlefield.");
                return 1;
            }

            if(InWarRespawn[playerid] && HasHQ[gang])
            {
                SetPlayerPos(playerid, GangHQ[gang][0], GangHQ[gang][1], GangHQ[gang][2]);
                
                SpawnProtected[playerid] = true;
                SetPlayerHealth(playerid, 999999.0); 
                SendClientMessage(playerid, -1, "{E74C3C}[WAR]{FFFFFF} Spawned at HQ. Cooldown active. You have 5 seconds of Spawn Protection!");
                
                if(SpawnProtectTimer[playerid] != -1) KillTimer(SpawnProtectTimer[playerid]);
                SpawnProtectTimer[playerid] = SetTimerEx("DisableSpawnProtection", 5000, false, "i", playerid);
                return 1;
            }
        }
    }
    return 1;
}

forward DisableSpawnProtection(playerid);
public DisableSpawnProtection(playerid)
{
    SpawnProtected[playerid] = false;
    SetPlayerHealth(playerid, 100.0);
    SendClientMessage(playerid, -1, "{E74C3C}[WAR]{FFFFFF} Spawn protection has expired! You can now take damage.");
    SpawnProtectTimer[playerid] = -1;
    return 1;
}

forward WarTimer(playerid);
public WarTimer(playerid)
{
    if(!InWarRespawn[playerid]) 
    {
        KillTimer(PlayerWarTimer[playerid]);
        PlayerWarTimer[playerid] = -1;
        return 0;
    }

    WarRespawnCooldown[playerid]--;
    
    new screenMsg[32];
    format(screenMsg, sizeof(screenMsg), "~r~Respawn in %ds", WarRespawnCooldown[playerid]);
    GameTextForPlayer(playerid, screenMsg, 1000, 3);

    if(WarRespawnCooldown[playerid] <= 0)
    {
        InWarRespawn[playerid] = false;
        SendClientMessage(playerid, -1, "Notification: Your cooldown is over. Rejoin the war zone!");
        GameTextForPlayer(playerid, "~g~GO GO GO!", 1500, 3);
        
        ResetPlayerWeapons(playerid);
        GivePlayerWeaponEx(playerid, 24, 200); 
        GivePlayerWeaponEx(playerid, 31, 500); 

        KillTimer(PlayerWarTimer[playerid]);
        PlayerWarTimer[playerid] = -1;
        return 0;
    }
    return 1;
}

forward GlobalWarClock();
public GlobalWarClock()
{
    if(!ActiveWar)
    {
        KillTimer(WarDurationTimer);
        WarDurationTimer = -1;
        return 0;
    }

    WarElapsedSeconds++;
    
    if(WarElapsedSeconds >= WAR_MAX_TIME)
    {
        SendWarMessage("=============================================");
        SendWarMessage("[TIME OUT] The 1-hour unlimited war limit expired! Calculating winner by total kills...");
        
        new winner;
        if(WarData[ActiveWarID][wKillsFrom] > WarData[ActiveWarID][wKillsTo]) winner = WarA;
        else if(WarData[ActiveWarID][wKillsTo] > WarData[ActiveWarID][wKillsFrom]) winner = WarB;
        else winner = -1; 
        
        if(winner != -1) EndWar(winner);
        else 
        {
            ActiveWar = false;
            if(WarZone != -1) { GangZoneDestroy(WarZone); WarZone = -1; }
            SendWarMessage("The match ended in an absolute tie draw! No rewards allocated.");
            ActiveWarID = -1;
        }
        KillTimer(WarDurationTimer);
        WarDurationTimer = -1;
    }
    return 1;
}

forward BoundaryCheckTimer();
public BoundaryCheckTimer()
{
    if(!ActiveWar)
    {
        KillTimer(WarBoundaryTimer);
        WarBoundaryTimer = -1;
        return 0;
    }

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && !InWarRespawn[i])
        {
            new gang = PlayerInfo[i][pGang];
            if(gang == WarA || gang == WarB)
            {
                if(!IsPlayerInWarZone(i))
                {
                    OutOfBoundsTime[i]++;
                    
                    // Simple screen warning telling them to return
                    new warning[64];
                    format(warning, sizeof(warning), "~r~OUT OF WAR ZONE!~n~~w~Return in %d seconds!", 15 - (OutOfBoundsTime[i] * 5));
                    GameTextForPlayer(i, warning, 3000, 3);
                    
                    if(OutOfBoundsTime[i] >= 3) 
                    {
                        OutOfBoundsTime[i] = 0;
                        GivePlayerMoney(i, -WAR_PENALTY);
                        SetPlayerHealth(i, 0.0); 
                        SendClientMessage(i, -1, "{FF0000}[WAR BOUNDARY]{FFFFFF} You were executed and fined $500 for running away from the combat zone!");
                    }
                }
                else
                {
                    OutOfBoundsTime[i] = 0;
                }
            }
        }
    }
    return 1;
}

stock EndWar(winner)
{
    ActiveWar = false;
    
    new finalReward = WarData[ActiveWarID][wReward];
    if(WarData[ActiveWarID][wLocation] >= 0 && WarData[ActiveWarID][wLocation] < sizeof(jobLocations))
    {
        finalReward *= 2; 
        SendWarMessage("{00FF00}[BONUS]{FFFFFF} War took place at a Job Location! Winning gang gets x2 prize money!");
    }

    GangCash[winner] += finalReward;
    SaveGangDatabaseEntry(winner); 

    if(WarZone != -1)
    {
        GangZoneStopFlashForAll(WarZone);
        GangZoneHideForAll(WarZone);
        GangZoneDestroy(WarZone);
        WarZone = -1;
    }

    new msg[144];
    format(msg, sizeof(msg), "The gang war is over! %s won the match and got $%d.", GetGangName(winner), finalReward);
    SendWarMessage(msg);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            InWarRespawn[i] = false;
            WarRespawnCooldown[i] = 0;
            PlayerKillStreak[i] = 0;
            SpawnProtected[i] = false;
            OutOfBoundsTime[i] = 0;
            FlaggedForWarReconnect[i] = false;
            
            if(PlayerWarTimer[i] != -1) { KillTimer(PlayerWarTimer[i]); PlayerWarTimer[i] = -1; }
            if(SpawnProtectTimer[i] != -1) { KillTimer(SpawnProtectTimer[i]); SpawnProtectTimer[i] = -1; }
        }
    }

    ActiveWarID = -1;
    return 1;
}