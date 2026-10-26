#include <YSI_Coding\y_hooks>

new MechanicActor[1];

CMD:buyrepairkit(playerid, params[])
{
	if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0)
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");

	if(!IsPlayerInRangeOfPoint(playerid, 3, 2481.0833, -1540.0714, 24.2277))
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the mechanic mechanic.");

	GivePlayerCash(playerid, -5000);
	PlayerInfo[playerid][pRepairKit]++;
	SendMessage(playerid, COLOR_LIGHTBLUE, "[MANAGER]: Thank you for buying 1x repair kit (All your repairkit tools: %s)", number_format(PlayerInfo[playerid][pRepairKit]));

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET repairkit = %i WHERE uid = %i", PlayerInfo[playerid][pRepairKit], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
	return 1;
}

CMD:use(playerid, params[])
{
	if(isnull(params))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /use [repairkit]");
	}
	if(!strcmp(params, "repairkit", true))
	{
		if(PlayerInfo[playerid][pRepairKit] < 1)
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have repair kit");

		if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0)
			return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");

		if(!IsPlayerInAnyVehicle(playerid))
			return SendClientMessage(playerid, COLOR_SYNTAX, "You can't fix a vehicle if you're not sitting in one.");

		PlayerInfo[playerid][pRepairKit]--;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET repairkit = %i WHERE uid = %i", PlayerInfo[playerid][pRepairKit], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);

		SetTimerEx("OnVehicleRepair", 10000, false, "i", playerid);
		SendClientMessage(playerid, COLOR_YELLOW, "Wait 10 seconds to fix your vehicle");
	}
	return 1;
}

forward OnVehicleRepair(playerid);
public OnVehicleRepair(playerid)
{
	RepairVehicle(GetPlayerVehicleID(playerid));
	SendClientMessage(playerid, COLOR_YELLOW, "Your vehicle has been repaired.");
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s repairs the vehicle.", GetRPName(playerid));
	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	return 1;
}

hook OnGameModeInit()
{
	MechanicActor[0] = CreateActor(50, 2481.0833, -1540.0714, 24.2277, 267.4181);
    ApplyActorAnimation(MechanicActor[0], "PED", "IDLE_CHAT", 4.1, true, true, true, true, 1);
  	SetActorInvulnerable(MechanicActor[0], true);

	CreateDynamic3DTextLabel(""YELLOW"Mechanic Manager\n\n"WHITE"Cost: $5,000\nType /buyrepairkit to buy repair kit", COLOR_WHITE, 2481.0833, -1540.0714, 24.2277, 10.0);


	return 1;
}