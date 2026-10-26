forward VehicleLockPick(playerid, E_LOCKPICK_STATUS:status);
public VehicleLockPick(playerid, E_LOCKPICK_STATUS:status)
{
	new vehicleid = GetNearbyVehicle(playerid);
	if(PlayerInfo[playerid][pLogged])
	{
		if(status == E_LOCKPICK_SUCCESS)
		{
			if(VehicleInfo[vehicleid][vLocked]) VehicleInfo[vehicleid][vLocked] = 0;

			SetVehicleParams(vehicleid, VEHICLE_DOORS, VehicleInfo[vehicleid][vLocked]);
        	PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

			SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s has successfully lockpicking the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
		}
    	else if(status == E_LOCKPICK_ERROR)
		{
			PlayerInfo[playerid][pToolkit]--;
			SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s has failed lockpicking the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
			SendClientMessage(playerid, COLOR_WHITE, "Your toolkit has been destroyed.");
		}
	}
	return 1;
}

CMD:lockpick(playerid, params[])
{
	new vehicleid = GetNearbyVehicle(playerid), Float:health;
	if(!PlayerInfo[playerid][pToolkit])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must have a toolkit to use this command.");
	}
	if(vehicleid == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vLocked])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle is already unlocked.");
	}
	if(!VehicleHasEngine(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no engine which can be turned on.");
	}

	new
		Float:x,
		Float:y,
		Float:z;

	GetPlayerPos(playerid, x, y, z);

	
	GetVehicleHealth(vehicleid, health);
    if(PlayerInfo[playerid][pEngine]) return SendClientMessage(playerid, COLOR_GREY, "You are already attempting to lockpick this vehicle.");
	if(health < 350.0) return SendClientMessage(playerid, COLOR_GREY, "The vehicle engine won't start. This vehicle engine was wrecked!");

    VehicleInfo[vehicleid][vLocked] = 1;
    SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s starts lockpicking the %s.", GetRPName(playerid), GetVehicleName(vehicleid));

	CreateLockPick(playerid, "VehicleLockPick", 31);

	foreach(new i : Player)
    {
        if(PlayerInfo[i][pLogged] && IsLawEnforcement(i))
        {
			SendClientMessage(i, COLOR_WHITE, "|_______________Alert Message_______________|");
    		SendMessage(i, COLOR_ROYALBLUE, "HQ: The alarm was activated on %s's %s in %s. All units respond immediately (marked on map).", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
			SetPlayerCheckpoint(i, x, y, z, 5.0);
		}
	}
	return 1;
}

forward lockpick(playerid, E_LOCKPICK_STATUS:status);
public lockpick(playerid, E_LOCKPICK_STATUS:status) {

    if(status == E_LOCKPICK_SUCCESS) SendClientMessage(playerid, -1, "LOCKPICK: Success");
    else if(status == E_LOCKPICK_ERROR) SendClientMessage(playerid, -1, "LOCKPICK: Error");
    return 1;
}