/*
Troll detection
By Jelly23
*/
#include <a_samp>

/*Vars*/
static VehID[MAX_PLAYERS];

/*Callbacks*/
forward OnPlayerTroll(playerid);
forward A_TrollDetection();

/*Functions (not to be used in the gamemode)*/
stock A_PutPlayerInVehicle(playerid, vehicleid, seatid)
{
	if(PutPlayerInVehicle(playerid, vehicleid, seatid))
	{
		VehID[playerid] = vehicleid;
		return 1;
	}
	return 0;
}
public A_TrollDetection()
{
    for(new i = 0, j = MAX_PLAYERS; i < j; i++)
    {
		if(IsPlayerConnected(i))
		{
		    if(IsPlayerInAnyVehicle(i))
		    {
		        if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
		        {
			        if(VehID[i] != GetPlayerVehicleID(i))
			        {
			            CallLocalFunction("OnPlayerTroll", "i", i);
			        }
		        }
		    }
		}
    }
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
        VehID[playerid] = GetPlayerVehicleID(playerid);
    }
    if(oldstate == PLAYER_STATE_PASSENGER && newstate == PLAYER_STATE_DRIVER)
    {
        CallLocalFunction("OnPlayerTroll", "i", playerid);
    }
	#if defined A_OnPlayerStateChange
	    return A_OnPlayerStateChange(playerid, newstate, oldstate);
	#else
	    return 1;
	#endif
}

public OnGameModeInit()
{
	SetTimer("A_TrollDetection", 1000, true);
	#if defined A_OnGameModeInit
	    return A_OnGameModeInit();
	#else
	    return 1;
	#endif
}


#if defined _ALS_PutPlayerInVehicle
	#undef PutPlayerInVehicle
#else
	#define _ALS_PutPlayerInVehicle
#endif
#define PutPlayerInVehicle  A_PutPlayerInVehicle

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit  A_OnGameModeInit

#if defined _ALS_OnPlayerStateChange
	#undef OnPlayerStateChange
#else
	#define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange A_OnPlayerStateChange

#if defined A_OnGameModeInit
	forward A_OnGameModeInit();
#endif

#if defined A_OnPlayerStateChange
	forward A_OnPlayerStateChange(playerid, newstate, oldstate);
#endif
