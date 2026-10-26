forward SetVehicleEngineHotwire(vehicleid, playerid);
public SetVehicleEngineHotwire(vehicleid, playerid)
{
	if(PlayerInfo[playerid][pLogged])
	{	
		if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "You must be driving a vehicle to use this command.");
		switch(random(3)) {
			case 1:
			{
				PlayerInfo[playerid][pToolkit] = 0;
				SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s has failed hotwired the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
				SendClientMessage(playerid, COLOR_WHITE, "Your toolkit has been destroyed.");
			} 
			default: {
				PlayerInfo[playerid][pEngine] = 0;
				SetVehicleParams(vehicleid, VEHICLE_ENGINE, true);
				SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s has successfully hotwired the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
				ReloadVehicleNeon(vehicleid);
			}
		}
	}
	return 1;
}

CMD:hotwire(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), Float:health;

	if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must be driving a vehicle to use this command.");
	}
	if(!PlayerInfo[playerid][pToolkit])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You must have a toolkit to use this command.");
	}
	if(!VehicleHasEngine(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no engine which can be turned on.");
	}
	if(vehicleFuel[vehicleid] <= 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There is no fuel left in this vehicle.");
	}

	new
		Float:x,
		Float:y,
		Float:z;

	GetPlayerPos(playerid, x, y, z);

	if(!GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		GetVehicleHealth(vehicleid, health);
	    if(PlayerInfo[playerid][pEngine]) return SendClientMessage(playerid, COLOR_GREY, "You are already attempting to hotwire this vehicle.");
		if(health < 350.0) return SendClientMessage(playerid, COLOR_GREY, "The vehicle engine won't start. This vehicle engine was wrecked!");

	    PlayerInfo[playerid][pEngine] = 1;
		SetTimerEx("SetVehicleEngineHotwire", 30000, false, "dd",  vehicleid, playerid);
  		SendClientMessage(playerid,COLOR_WHITE,"You are currently hotwiring this vehicle.");
		GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Hotwiring...~n~~w~please wait 30 seconds!", 30000, 3);
  		SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s starts hotwiring the %s.", GetRPName(playerid), GetVehicleName(vehicleid));
	
		foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged] && IsLawEnforcement(i))
	        {
				SendClientMessage(i, COLOR_WHITE, "|_______________Alert Message_______________|");
	    		SendMessage(i, COLOR_ROYALBLUE, "HQ: The alarm was activated on %s's %s in %s. All units respond immediately (marked on map).", VehicleInfo[vehicleid][vOwner], GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
				SetPlayerCheckpoint(i, x, y, z, 5.0);
			}
		}
	}
	else
	{
		return SendClientMessage(playerid, COLOR_GREY, "This vehicle's engine is already on.");
	}
	return 1;
}