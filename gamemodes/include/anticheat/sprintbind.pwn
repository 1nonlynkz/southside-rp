#include <YSI_Coding\y_hooks>

#if !defined PRESSED
    #define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#endif

new SprintBind[MAX_PLAYERS];
new FastResponse[MAX_PLAYERS];
new FastResponseTimer[MAX_PLAYERS]; // Idinagdag para maiwasan ang timer stacking

forward DelayKick(playerid);
public DelayKick(playerid)
{
    if(IsPlayerConnected(playerid))
    {
        Kick(playerid);
    }
    return 1;
}

hook OnPlayerConnect(playerid)
{
    SprintBind[playerid] = 0;
    FastResponse[playerid] = 0;
    FastResponseTimer[playerid] = -1;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(FastResponseTimer[playerid] != -1)
    {
        KillTimer(FastResponseTimer[playerid]);
        FastResponseTimer[playerid] = -1;
    }
    return 1;
}

forward ResetFastResponse(playerid);
public ResetFastResponse(playerid)
{
    FastResponse[playerid] = 0;
    FastResponseTimer[playerid] = -1;
    return 1;
}

forward ResetJumping(playerid);
public ResetJumping(playerid)
{
    SetPVarInt(playerid, "Jumping", 0);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
    if(PRESSED(KEY_JUMP) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
        SetPVarInt(playerid, "Jumping", 1);
        SetTimerEx("ResetJumping", 3500, false, "i", playerid); 
    }
    
    if(PRESSED(KEY_SPRINT))
    {    
        if(FastResponseTimer[playerid] != -1)
        {
            KillTimer(FastResponseTimer[playerid]);
        }
        
        FastResponse[playerid]++;
        FastResponseTimer[playerid] = SetTimerEx("ResetFastResponse", 300, false, "i", playerid); 

        if((gAnticheat) && PlayerInfo[playerid][pAdmin] < 1 && !PlayerInfo[playerid][pAdminDuty] && !PlayerInfo[playerid][pKicked])
        {
            if(FastResponse[playerid] > 6)
            {
                SprintBind[playerid]++;
                FastResponse[playerid] = 0;

                SendClientMessageEx(playerid, COLOR_LIGHTRED, "You have been warned for having Sprint Bind or Sprint Key Spam (%d/3)", SprintBind[playerid]);

                if(SprintBind[playerid] >= 3)
                {
                    SendMessageToAll(COLOR_LIGHTRED, "%s has been kicked, Sprintbind detected (%i/3)", GetRPName(playerid), SprintBind[playerid]);
                    SendMessage(playerid, COLOR_LIGHTRED, "You have been kicked for having Sprint Bind or Sprint Key Spam (%d/3)", SprintBind[playerid]);
                    
                    SetTimerEx("DelayKick", 1000, false, "i", playerid);
                }
            }
        }
    }
    return 1;
}
