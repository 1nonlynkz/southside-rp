CMD:chopcar(playerid, params[])
{
	new count, vehicleid = GetPlayerVehicleID(playerid);

	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -52.6129,-1141.9277,1.0781))
	{
	    return SendMessage(playerid, COLOR_GREY, "You are not in range of %s.", GetZoneName(-52.6129,-1141.9277,1.0781));
	}
	if(gettime() - PlayerInfo[playerid][pLastChopCar] < 300)
	{
		return SendMessage(playerid, COLOR_GREY, "** You can only use this command every 5 Minutes. Please wait %i more seconds.", 300 - (gettime() - PlayerInfo[playerid][pLastChopCar]));
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
		return SendClientMessage(playerid, COLOR_GREY, "You are not driving any vehicle.");
	}
	if(!IsValidVehicle(vehicleid) || !VehicleInfo[vehicleid][vID])
	{
		return SendClientMessage(playerid, COLOR_GREY, "The vehicle specified is invalid or a static vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
		return SendClientMessage(playerid, COLOR_GREY, "You can only destroy player's owned vehicles.");
	}
	if(VehicleInfo[vehicleid][vLocked]) return SendClientMessage(playerid, COLOR_GREY, "This vehicle is locked.");

	foreach(new i : Player)
	{
	    if(IsLawEnforcement(i) && PlayerInfo[i][pDuty] == 1)
	    {
	        count++;
		}
	}

	if(count < 4)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "There needs to be at least 4+ LEO on-duty in order to rob the bank.");
	}

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	SetTimerEx("ChoppngVehicle", 30000, false, "dd",  vehicleid, playerid);
	SendClientMessage(playerid,COLOR_WHITE,"You are currently chopping this vehicle.");
	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Chopping...~n~~w~please wait 30 seconds!", 30000, 3);
	SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s starts chopping the %s.", GetRPName(playerid), GetVehicleName(vehicleid));

	foreach(new i : Player)
	{
		if(PlayerInfo[i][pLogged] && IsLawEnforcement(i))
		{
			SendClientMessage(i, COLOR_WHITE, "|_______________Alert Message_______________|");
			SendMessage(i, COLOR_ROYALBLUE, "HQ: The alarm was activated on %s's %s in %s. All units respond immediately (marked on map).", GetRPName(playerid), GetVehicleName(vehicleid), GetVehicleZoneName(vehicleid));
			SetPlayerCheckpoint(i, x, y, z, 5.0);
		}
	}
	return 1;
}

forward ChoppngVehicle(vehicleid, playerid);
public ChoppngVehicle(vehicleid, playerid)
{
	if(PlayerInfo[playerid][pLogged])
	{	
		if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "You must be driving a vehicle to use this command.");

	}
	
	new price = GetVehicleCranePrice(vehicleid);
	GivePlayerCash(playerid, price);

	SendMessage(playerid, COLOR_YELLOW, "You are successfully chopped the vehicle and earned %s.", FormatNumber(price));

	VehicleInfo[vehicleid][vTickets] = price;
	VehicleInfo[vehicleid][vPosX] = 0.0;
	VehicleInfo[vehicleid][vPosY] = 0.0;
	VehicleInfo[vehicleid][vPosZ] = 0.0;
	VehicleInfo[vehicleid][vWorld] = vehicleid;
	VehicleInfo[vehicleid][vInterior] = vehicleid;
	PlayerInfo[playerid][pLastChopCar] = gettime();

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_a = '%f', interior = %i, world = %i, impounded = 1, tickets = %i WHERE id = %i", VehicleInfo[vehicleid][vPosX], VehicleInfo[vehicleid][vPosY], VehicleInfo[vehicleid][vPosZ], VehicleInfo[vehicleid][vPosA], VehicleInfo[vehicleid][vInterior], VehicleInfo[vehicleid][vWorld], VehicleInfo[vehicleid][vTickets], VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);

	DespawnVehicle(vehicleid);
	return 1;
}