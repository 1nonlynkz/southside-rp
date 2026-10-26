
#include <YSI_Coding\y_hooks>

#define MAX_LOCKERS		50

enum E_LOCKER_DATA
{
    lID,
    lExists,
    lFaction,
    Float:lPosX,
    Float:lPosY,
    Float:lPosZ,
    lInterior,
    lWorld,
    lLabel,
    lIcon,
    Text3D:lText,
    lPickup
};
new LockerInfo[MAX_LOCKERS][E_LOCKER_DATA];

RemoveFactionLocker(factionid)
{
    for(new i = 0; i < MAX_LOCKERS; i ++)
    {
        if(LockerInfo[i][lExists] && LockerInfo[i][lFaction] == factionid)
        {
            DestroyDynamic3DTextLabel(LockerInfo[i][lText]);
            DestroyDynamicPickup(LockerInfo[i][lPickup]);
            LockerInfo[i][lExists] = 0;
        }
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM factionlockers WHERE factionid = %i", factionid);
    mysql_tquery(connectionID, queryBuffer);
}

GetNearbyLocker(playerid)
{
    for(new i = 0; i < MAX_LOCKERS; i ++)
    {
        if(LockerInfo[i][lExists] && IsPlayerInRangeOfPoint(playerid, 3.0, LockerInfo[i][lPosX], LockerInfo[i][lPosY], LockerInfo[i][lPosZ]))
        {
            return i;
        }
    }

    return -1;
}

IsPlayerInRangeOfLocker(playerid, factionid)
{
    new lockerid;
    if((lockerid = GetNearbyLocker(playerid)) >= 0)
    {
        if(LockerInfo[lockerid][lFaction] == factionid || FactionInfo[LockerInfo[lockerid][lFaction]][fType] == FactionInfo[factionid][fType])
        {
            return 1;
        }
    }
    return 0;
}

ReloadLockers(factionid)
{
    for(new i = 0; i < MAX_LOCKERS; i ++)
    {
        if(LockerInfo[i][lExists] && LockerInfo[i][lFaction] == factionid)
        {
            ReloadLocker(i);
        }
    }
}

ReloadLocker(lockerid)
{
    new string[128];
    if(LockerInfo[lockerid][lExists])
    {
        if(LockerInfo[lockerid][lText] != Text3D:INVALID_3DTEXT_ID) DestroyDynamic3DTextLabel(LockerInfo[lockerid][lText]);
        if(LockerInfo[lockerid][lPickup] != -1) DestroyDynamicPickup(LockerInfo[lockerid][lPickup]);

        if(LockerInfo[lockerid][lLabel])
        {
            format(string, sizeof(string), "%s\n"WHITE"Press 'Y' to access locker.\nID: %i", FactionInfo[LockerInfo[lockerid][lFaction]][fName], lockerid);
            LockerInfo[lockerid][lText] = CreateDynamic3DTextLabel(string, COLOR_WHITE, LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ], 10.0, .worldid = LockerInfo[lockerid][lWorld], .interiorid = LockerInfo[lockerid][lInterior]);
        }
        LockerInfo[lockerid][lPickup] = CreateDynamicPickup(LockerInfo[lockerid][lIcon], 1, LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ], .worldid = LockerInfo[lockerid][lWorld], .interiorid = LockerInfo[lockerid][lInterior]);
    }
}

forward LoadFactionLocker();
public LoadFactionLocker()
{
    new rows = cache_num_rows();
    for(new i = 0; i < MAX_LOCKERS; i++)
    {
        LockerInfo[i][lExists] = 0;
    }

    if(rows) 
    {
        for(new i = 0; i < rows && i < MAX_LOCKERS; i++) 
        {
            LockerInfo[i][lID] = cache_get_field_content_int(i, "id");
            LockerInfo[i][lFaction] = cache_get_field_content_int(i, "factionid");
            LockerInfo[i][lPosX] = cache_get_field_content_float(i, "pos_x");
            LockerInfo[i][lPosY] = cache_get_field_content_float(i, "pos_y");
            LockerInfo[i][lPosZ] = cache_get_field_content_float(i, "pos_z");
            LockerInfo[i][lInterior] = cache_get_field_content_int(i, "interior");
            LockerInfo[i][lWorld] = cache_get_field_content_int(i, "world");
            LockerInfo[i][lIcon] = cache_get_field_content_int(i, "iconid");
            LockerInfo[i][lLabel] = cache_get_field_content_int(i, "label");

            LockerInfo[i][lText] = Text3D:INVALID_3DTEXT_ID;
            LockerInfo[i][lPickup] = -1;
            LockerInfo[i][lExists] = 1;

            ReloadLocker(i);
        }
    }
}

forward OnAdminCreateLocker(playerid, lockerid, factionid, Float:x, Float:y, Float:z, interior, world);
public OnAdminCreateLocker(playerid, lockerid, factionid, Float:x, Float:y, Float:z, interior, world)
{
    LockerInfo[lockerid][lID] = cache_insert_id(connectionID);
    LockerInfo[lockerid][lExists] = 1;
    LockerInfo[lockerid][lFaction] = factionid;
    LockerInfo[lockerid][lPosX] = x;
    LockerInfo[lockerid][lPosY] = y;
    LockerInfo[lockerid][lPosZ] = z;
    LockerInfo[lockerid][lInterior] = interior;
    LockerInfo[lockerid][lWorld] = world;
    LockerInfo[lockerid][lIcon] = 1239;
    LockerInfo[lockerid][lLabel] = 1;

    LockerInfo[lockerid][lText] = Text3D:INVALID_3DTEXT_ID;
    LockerInfo[lockerid][lPickup] = -1;

    ReloadLocker(lockerid);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has created locker [%s] [ID: %i]", GetRPName(playerid), FactionInfo[factionid][fName], lockerid);
}

CMD:createlocker(playerid, params[])
{
    new factionid, Float:x, Float:y, Float:z;

    if(PlayerInfo[playerid][pAdmin] < 5 && !PlayerInfo[playerid][pFactionMod])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
    }
    if(sscanf(params, "i", factionid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /createlocker [factionid]");
    }
    if(!(0 <= factionid < MAX_FACTIONS) || FactionInfo[factionid][fType] == FACTION_NONE)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid faction.");
    }

    GetPlayerPos(playerid, x, y, z);
    for(new i = 0; i < MAX_LOCKERS; i ++)
    {
        if(!LockerInfo[i][lExists])
        {
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO factionlockers (factionid, pos_x, pos_y, pos_z, interior, world, iconid, label) VALUES(%i, '%f', '%f', '%f', %i, %i, 1239, 1)", factionid, x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
            mysql_tquery(connectionID, queryBuffer, "OnAdminCreateLocker", "iiifffii", playerid, i, factionid, x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
            return 1;
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "Locker slots are currently full. Ask developers to increase the internal limit.");
    return 1;
}

CMD:editlocker(playerid, params[])
{
    new lockerid, option[32], param[32];

    if(PlayerInfo[playerid][pAdmin] < 5 && !PlayerInfo[playerid][pFactionMod])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
    }
    if(sscanf(params, "is[32]S()[32]", lockerid, option, param))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editlocker [lockerid] [option]");
        SendClientMessage(playerid, COLOR_GREY, "OPTIONS: Position, FactionID, Icon, Label");
        return 1;
    }
    if(!(0 <= lockerid < MAX_LOCKERS) || !LockerInfo[lockerid][lExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid locker.");
    }
    if(!strcmp(option, "position", true))
    {
        GetPlayerPos(playerid, LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ]);
        LockerInfo[lockerid][lInterior] = GetPlayerInterior(playerid);
        LockerInfo[lockerid][lWorld] = GetPlayerVirtualWorld(playerid);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET pos_x = '%f', pos_y = '%f', pos_z = '%f', interior = %i, world = %i WHERE id = %i", LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ], LockerInfo[lockerid][lInterior], LockerInfo[lockerid][lWorld], LockerInfo[lockerid][lID]);
        mysql_tquery(connectionID, queryBuffer);

        SendMessage(playerid, COLOR_WHITE, "* You have moved locker %i to your position.", lockerid);
        ReloadLocker(lockerid);
    }
    else if(!strcmp(option, "factionid", true))
    {
        new value;
        if(sscanf(param, "i", value))
        {
            return SendMessage(playerid, COLOR_SYNTAX, "Usage: /editlocker [%i] [%s] [value]", lockerid, option);
        }
        LockerInfo[lockerid][lFaction] = value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET factionid = %i WHERE id = %i", LockerInfo[lockerid][lFaction], LockerInfo[lockerid][lID]);
        mysql_tquery(connectionID, queryBuffer);

        SendMessage(playerid, COLOR_WHITE, "* You set locker %i's faction to %i.", lockerid, value);
        ReloadLocker(lockerid);
    }
    else if(!strcmp(option, "icon", true))
    {
        new iconid;

        if(sscanf(param, "i", iconid))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editlocker [lockerid] [icon] [iconid (19300 = hide)]");
        }
        if(!IsValidModel(iconid))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid model ID.");
        }

        LockerInfo[lockerid][lIcon] = iconid;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET iconid = %i WHERE id = %i", LockerInfo[lockerid][lIcon], LockerInfo[lockerid][lID]);
        mysql_tquery(connectionID, queryBuffer);

        ReloadLocker(lockerid);
        SendMessage(playerid, COLOR_WHITE, "* You've changed the pickup icon model of locker %i to %i.", lockerid, iconid);
    }
    else if(!strcmp(option, "label", true))
    {
        new status;

        if(sscanf(param, "i", status) || !(0 <= status <= 1))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editlocker [lockerid] [label] [0/1]");
        }

        LockerInfo[lockerid][lLabel] = status;

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factionlockers SET label = %i WHERE id = %i", LockerInfo[lockerid][lLabel], LockerInfo[lockerid][lID]);
        mysql_tquery(connectionID, queryBuffer);

        ReloadLocker(lockerid);

        if(status)
            SendMessage(playerid, COLOR_WHITE, "* You've enabled the 3D text label for locker %i.", lockerid);
        else
            SendMessage(playerid, COLOR_WHITE, "* You've disabled the 3D text label for locker %i.", lockerid);
    }
    return 1;
}

CMD:removelocker(playerid, params[])
{
    new lockerid;

    if(PlayerInfo[playerid][pAdmin] < 5 && !PlayerInfo[playerid][pFactionMod])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
    }
    if(sscanf(params, "i", lockerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removelocker [lockerid]");
    }
    if(!(0 <= lockerid < MAX_LOCKERS) || !LockerInfo[lockerid][lExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid locker.");
    }

    DestroyDynamic3DTextLabel(LockerInfo[lockerid][lText]);
    DestroyDynamicPickup(LockerInfo[lockerid][lPickup]);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM factionlockers WHERE id = %i", LockerInfo[lockerid][lID]);
    mysql_tquery(connectionID, queryBuffer);

    LockerInfo[lockerid][lExists] = 0;
    LockerInfo[lockerid][lID] = 0;

    SendMessage(playerid, COLOR_WHITE, "* You have removed locker %i.", lockerid);
    return 1;
}

CMD:gotolocker(playerid, params[])
{
    new lockerid;

    if(PlayerInfo[playerid][pAdmin] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
    }
    if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if(sscanf(params, "i", lockerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /gotolocker [lockerid]");
    }
    if(!(0 <= lockerid < MAX_LOCKERS) || !LockerInfo[lockerid][lExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid locker.");
    }

    GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

    SetPlayerPos(playerid, LockerInfo[lockerid][lPosX], LockerInfo[lockerid][lPosY], LockerInfo[lockerid][lPosZ]);
    SetPlayerInterior(playerid, LockerInfo[lockerid][lInterior]);
    SetPlayerVirtualWorld(playerid, LockerInfo[lockerid][lWorld]);
    SetCameraBehindPlayer(playerid);
    return 1;
}
