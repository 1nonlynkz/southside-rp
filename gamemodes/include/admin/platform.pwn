#include <YSI_Coding\y_hooks>

#define IsPlayerAndroid(%0) !GetPVarInt(%0, "NotAndroid")

GetPlayerPlatform(playerid)
{
    new platform[128];
    if(IsPlayerAndroid(playerid)) {
        platform = "Mobile";
    } else {
        platform = "PC";
    }
    return platform;
}

public OnClientCheckResponse(playerid, actionid, memaddr, retndata)
{
    switch(actionid)
    {
        case 0x48:
        {
            SetPVarInt(playerid, "NotAndroid", 1);
        }
    }
    return 1;
}

hook OnPlayerConnect(playerid)
{
    SendClientCheck(playerid, 0x48, 0, 0, 2);
    return 1;
}