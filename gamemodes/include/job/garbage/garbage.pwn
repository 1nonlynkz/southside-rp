#include <YSI_Coding\y_hooks>

task GarbageTimer[60000]()
{
    for (new i = 0; i < MAX_GARBAGE_BINS; i ++)
    {
        if(GarbageData[i][garbageCapacity] < 10)
        {
            GarbageData[i][garbageCapacity] = 20;
        }
    }
}

hook OnPlayerConnect(playerid)
{
	PlayerInfo[playerid][pCarryTrash] = 0;
	return 1;
}

hook OnGameModeInit()
{
	CreateDynamic3DTextLabel("Dump Garabge\n"WHITE"Type '/dumpgarbage' to dump trash.", COLOR_GREY, 1628.3929,-2144.1221,13.5547, 25.0);
	CreateDynamicPickup(1239, 1, 1628.3929,-2144.1221,13.5547);
    return 1;
}

hook OnPlayerStateChange(playerid, PLAYER_STATE:newstate, PLAYER_STATE:oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
		if((garbageVehicles[0] <= vehicleid <= garbageVehicles[7]) && !PlayerHasJob(playerid, JOB_GARBAGE))
	    {
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "HINT: Type /takebag to collect the trashbag and Press N to load the garbage inside your truck");
		}
	}	
	return 1;
}

hook OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
    new string[128];
	if(newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if(PlayerInfo[playerid][pCarryTrash])
		{
			for (new i = 1; i != MAX_VEHICLES; i ++) if(IsLoadableTrashmaster(i) && IsPlayerNearBoot(playerid, i))
			{
			    if(VehicleInfo[i][vTrash] >= 20)
			        return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle cannot hold anymore trash (limit: 20).");

				VehicleInfo[i][vTrash]++;
				RemovePlayerAttachedObject(playerid, 4);
				SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s has loaded a trash bag into the Trashmaster.", GetRPName(playerid));

				format(string, sizeof(string), "Trash Capacity\n%d/20", VehicleInfo[i][vTrash]);
				UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_VIP, string);

				switch(VehicleInfo[i][vTrash])
				{
					case 1: GarbageTruckCallSign[i] = CreateDynamic3DTextLabel("Trash Capacity\n1/20", COLOR_VIP, 0.0, -3.0, 0.0, 10.0, .attachedvehicle = i);
					case 2: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_VIP, "Trash Capacity\n2/20");	
					case 3: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_VIP, "Trash Capacity\n3/20");	
					case 4: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_VIP, "Trash Capacity\n4/20");	
					case 5: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_GREEN, "Trash Capacity\n5/20");	
					case 6: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_GREEN, "Trash Capacity\n6/20");	
					case 7: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_GREEN, "Trash Capacity\n7/20");	
					case 8: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_GREEN, "Trash Capacity\n8/20");	
					case 9: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_GREEN, "Trash Capacity\n9/20");	
					case 10: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_GREEN, "Trash Capacity\n10/20");	
					case 11: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_GREEN, "Trash Capacity\n11/20");	
					case 12: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_GREEN, "Trash Capacity\n12/20");	
					case 13: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_YELLOW, "Trash Capacity\n13/20");	
					case 14: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_YELLOW, "Trash Capacity\n14/20");	
					case 15: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_YELLOW, "Trash Capacity\n15/20");	
					case 16: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_YELLOW, "Trash Capacity\n16/20");	
					case 17: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_YELLOW, "Trash Capacity\n17/20");	
					case 18: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_YELLOW, "Trash Capacity\n18/20");	
					case 19: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], COLOR_YELLOW, "Trash Capacity\n19/20");	
					case 20: UpdateDynamic3DTextLabelText(GarbageTruckCallSign[i], 0xFF0606FF, "Trash Capacity\nFULL");	
				}
                
                ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, false, false, false, false, 400, SYNC_ALL);
				PlayerInfo[playerid][pCarryTrash] = 0;
				break;
			}
		}
	}
    return 1;
}


CMD:creategarbage(playerid, params[])
{
	static
	    id = -1,
		type;

    if(PlayerInfo[playerid][pAdmin] < 7)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");

	if(sscanf(params, "d", type))
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "Usage:  "WHITE"/creategarbage [type]");
	    SendClientMessage(playerid, COLOR_ORANGE, "[TYPES]: "WHITE"(1) Dumpster (2) Trash Can");
		return 1;
	}
	if(type < 1 || type > 2)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The specified type can't be below 1 or above 2.");

	id = Garbage_Create(playerid, type);

	if(id == -1)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The server has reached the limit for garbage bins.");

	SendMessage(playerid, SERVER_COLOR, "[Garbage System]: "WHITE"You have successfully created garbage bin ID: %d.", id);
	return 1;
}

CMD:destroygarbage(playerid, params[])
{
	static
	    id = 0;

    if(PlayerInfo[playerid][pAdmin] < 7)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");

	if(sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "Usage:  "WHITE"/destroygarbage [garbage id]");

	if((id < 0 || id >= MAX_GARBAGE_BINS) || !GarbageData[id][garbageExists])
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid garbage ID.");

	Garbage_Delete(id);
	SendMessage(playerid, SERVER_COLOR, "[Garbage System]: "WHITE"You have successfully destroyed garbage bin ID: %d.", id);
	return 1;
}

CMD:editgarbage(playerid, params[])
{
	static
	    id = 0;

    if(PlayerInfo[playerid][pAdmin] < 7)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");

	if(sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "Usage:  "WHITE"/editgarbage [garbage id]");

	if((id < 0 || id >= MAX_GARBAGE_BINS) || !GarbageData[id][garbageExists])
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid garbage ID.");

	EditDynamicObjectEx(playerid, EDIT_TYPE_GARBAGE, GarbageData[id][garbageObject], id);
	SendMessage(playerid, COLOR_WHITE, "You've changed the position of garbage bin [ID: %i]", id);
	return 1;
}

CMD:takebag(playerid, params[])
{
	new
		id = Garbage_Nearest(playerid);

	if(!PlayerHasJob(playerid, JOB_GARBAGE))
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have the appropriate job.");

	if(id == -1)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any garbage bin.");

	if(GarbageData[id][garbageCapacity] == 0)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This garbage bin is empty.");

	if(PlayerInfo[playerid][pCarryTrash])
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are already carrying a garbage bag.");

    GarbageData[id][garbageCapacity]--;
   	Garbage_Save(id);

	PlayerInfo[playerid][pCarryTrash] = 1;
	SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s takes a trash bag from the garbage bin.", GetRPName(playerid));

	Garbage_Refresh(id);

  	SetPlayerAttachedObject(playerid, 4, 1264, 6, 0.000000, 0.000000, 0.000000, 0.000000, 270.000000, 90.000000, 0.500000, 0.500000, 0.500000);
	GameTextForPlayer(playerid, "~w~Press ~y~'N' ~w~to load the garbage bag.", 5000, 3);

	return 1;
}

CMD:setgarbage(playerid, params[])
{
	static
	    id = 0,
		amount;

    if(PlayerInfo[playerid][pAdmin] < 7)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");

	if(sscanf(params, "dd", id, amount))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "Usage:  "WHITE"/setgarbage [garbage id] [trash amount]");

	if((id < 0 || id >= MAX_GARBAGE_BINS) || !GarbageData[id][garbageExists])
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid garbage ID.");

	GarbageData[id][garbageCapacity] = amount;

	Garbage_Refresh(id);
	Garbage_Save(id);

	SendMessage(playerid, COLOR_WHITE, "You have set the trash to %d for garbage bin ID: %d.", amount, id);
	return 1;
}

CMD:setgarbageall(playerid, params[])
{
	static
		amount;

    if(PlayerInfo[playerid][pAdmin] < 7)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have permission to use this command.");

	if(sscanf(params, "d", amount))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "Usage:  "WHITE"/setgarbageall [trash amount]");

	if(!(1 <= amount <= 20))
        return SendMessage(playerid, COLOR_SYNTAX, "Don't go below 1 or above 20 at once.");

	for(new id = 0; id < MAX_GARBAGE_BINS; id ++)
	{
		GarbageData[id][garbageCapacity] = amount;
		Garbage_Refresh(id);
		Garbage_Save(id);
	}

	SendMessage(playerid, COLOR_WHITE, "You have set the trash to all garbage bin");
	return 1;
}

CMD:dumpgarbage(playerid, params[])
{
	new
		vehicleid = GetPlayerVehicleID(playerid);

	if(!PlayerHasJob(playerid, JOB_GARBAGE))
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have the appropriate job.");

	if(!IsLoadableTrashmaster(vehicleid))
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be driving a garbage truck.");

	if(!IsPlayerInRangeOfPoint(playerid, 6.0, 1628.3929, -2144.1221, 13.5547))
	{
		SetPlayerCheckpoint(playerid, 1628.3929, -2144.1221, 13.5547, 4.0);
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not at the trash dump! A checkpoint has been set at the correct location.");
	}
    
	if(VehicleInfo[vehicleid][vTrash] < 1)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is no trash loaded in this vehicle.");

	GameTextForPlayer(playerid, "~r~You have delivered the garbage!", 5000, 3);

	new salary;
	salary = VehicleInfo[vehicleid][vTrash] * Random(385, 564) + Random(200, 839);
    AddToPaycheck(playerid, salary);

	SendMessage(playerid, COLOR_LIGHTBLUE, "You've earned %s for your legal work, This will be added to your Paycheck! (%s Paycheck)", FormatNumber(salary), FormatNumber(PlayerInfo[playerid][pPaycheck]));

	VehicleInfo[vehicleid][vTrash] = 0;
	DestroyDynamic3DTextLabel(GarbageTruckCallSign[vehicleid]);	
	return 1;
}