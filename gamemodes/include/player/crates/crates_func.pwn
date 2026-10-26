GetCrateBox(playerid)
{
	for (new i = 0; i < MAX_CRATES; i ++) if (CrateBox[i][cbExist] && BeingMoved[i] == INVALID_PLAYER_ID && IsPlayerInRangeOfPoint(playerid, 3.0, CrateBox[i][cbPos][0], CrateBox[i][cbPos][1], CrateBox[i][cbPos][2]))
	    return i;

	return -1;
}

GetCrateWeaponCapacity(item)
{
	switch(item)
	{
	    case CAPACITY_CRATEWEP:
	    {
	        return 50;
		}
	}
	return 0;
}

stock RenderCrate(id)
{
	if(IsValidDynamicObject(CrateBox[id][cbObject])) DestroyDynamicObject(CrateBox[id][cbObject]), CrateBox[id][cbObject] = -1;
	if(IsValidDynamic3DTextLabel(CrateBox[id][cbTextID])) DestroyDynamic3DTextLabel(CrateBox[id][cbTextID]), CrateBox[id][cbTextID] = Text3D: -1;

	if(CrateBox[id][cbExist])
	{
		new string[128];
		format(string, sizeof(string), "[ID :%d]\nOwner: %s\nPlaced By: %s\n\nType '/packagehelp' to see info", id, CrateBox[id][cbPlacedBy], CrateBox[id][cbPlacedBy]);
		CrateBox[id][cbTextID] = CreateDynamic3DTextLabel(string, COLOR_GREY, CrateBox[id][cbPos][0], CrateBox[id][cbPos][1], CrateBox[id][cbPos][2]+1.5, 20.0, .testlos = 1, .worldid = CrateBox[id][cbVw], .interiorid = CrateBox[id][cbInt], .streamdistance = 20.0);
		CrateBox[id][cbObject] = CreateDynamicObject(964, CrateBox[id][cbPos][0], CrateBox[id][cbPos][1], CrateBox[id][cbPos][2], 0.00000000, 0.00000000, 0.00000000, CrateBox[id][cbVw], CrateBox[id][cbInt]);
	}
	return 1;
}

stock SaveCrate(i) {
	new query[2048], wep[16];

	format(query, 2048, "UPDATE `crates` SET ");
	SaveInteger(query, "crates", i+1, "Facility", CrateBox[i][cbFacility]);
	SaveInteger(query, "crates", i+1, "Group", CrateBox[i][cbGroup]);
	SaveFloat(query, "crates", i+1, "CrateX", CrateBox[i][cbPos][0]);
	SaveFloat(query, "crates", i+1, "CrateY", CrateBox[i][cbPos][1]);
	SaveFloat(query, "crates", i+1, "CrateZ", CrateBox[i][cbPos][2]);
	SaveInteger(query, "crates", i+1, "Int", CrateBox[i][cbInt]);
	SaveInteger(query, "crates", i+1, "InVehicle", CrateBox[i][cbInVeh]);
	SaveInteger(query, "crates", i+1, "OnVehicle", CrateBox[i][cbOnVeh]);
	SaveInteger(query, "crates", i+1, "VW", CrateBox[i][cbVw]);
    
	for(new w = 0; w < 20; w++) {
		format(wep, sizeof(wep), "Gun%d", w+1);
		SaveInteger(query, "crates", i+1, wep, CrateBox[i][cbWep][w]);
		format(wep, sizeof(wep), "GunAmount%d", w+1);
		SaveInteger(query, "crates", i+1, wep, CrateBox[i][cbWepAmount][w]);
	}
    
	SaveString(query, "crates", i+1, "PlacedBy", CrateBox[i][cbPlacedBy]);
	SaveInteger(query, "crates", i+1, "Lifespan", CrateBox[i][cbLifespan]);
	SaveInteger(query, "crates", i+1, "Transfer", CrateBox[i][cbTransfer]);
	SaveInteger(query, "crates", i+1, "DoorID", CrateBox[i][cbDoor]);
	SaveInteger(query, "crates", i+1, "DoorType", CrateBox[i][cbDoorType]);
	SaveInteger(query, "crates", i+1, "Price", CrateBox[i][cbPrice]);
	SaveInteger(query, "crates", i+1, "Paid", CrateBox[i][cbPaid]);
	SaveInteger(query, "crates", i+1, "Active", CrateBox[i][cbActive]);
	SQLUpdateFinish(query, "crates", i+1);
	return 1;
}


stock UpdateCrateBox(id)
{
	new string[256];
	if(IsValidDynamicObject(CrateBox[id][cbObject])) DestroyDynamicObject(CrateBox[id][cbObject]), CrateBox[id][cbObject] = -1;
	if(IsValidDynamic3DTextLabel(CrateBox[id][cbTextID])) DestroyDynamic3DTextLabel(CrateBox[id][cbTextID]), CrateBox[id][cbTextID] = Text3D: -1;

	if(!CrateBox[id][cbActive]) return 1;

	if(BeingMoved[id] != INVALID_PLAYER_ID) return 1;

	if(CrateBox[id][cbOnVeh] != -1) 
	{
		DestroyDynamicObject(CrateBox[id][cbObject]);
		DestroyDynamic3DTextLabel(CrateBox[id][cbTextID]);
	}

	if(CrateBox[id][cbGroup] == -1) {
		format(string, sizeof(string), "[ID: %d]\nTime Remaining: 00:00:00\nPlaced By: %s\n\nType '/packagehelp' to see info", id, CrateBox[id][cbPlacedBy]);
	} else {
		format(string, sizeof(string), "[ID: %d]\nGun Package Owner: %s\n\nType '/packagehelp' to see info", id, CrateBox[id][cbPlacedBy]);
	}
	CrateBox[id][cbTextID] = CreateDynamic3DTextLabel(string, COLOR_GREY, CrateBox[id][cbPos][0], CrateBox[id][cbPos][1], CrateBox[id][cbPos][2]+1.5, 20.0, .testlos = 1, .worldid = CrateBox[id][cbVw], .interiorid = CrateBox[id][cbInt], .streamdistance = 20.0);
	CrateBox[id][cbObject] = CreateDynamicObject(964, CrateBox[id][cbPos][0], CrateBox[id][cbPos][1], CrateBox[id][cbPos][2], 0.00000000, 0.00000000, 0.00000000, CrateBox[id][cbVw], CrateBox[id][cbInt]);
	
	return 1;
}

forward OnCrateCreated(box);
public OnCrateCreated(box)
{
	if (box == -1 || !CrateBox[box][cbExist])
	    return 0;

	CrateBox[box][cbID] = cache_insert_id(connectionID);
	SaveCrate(box);

	return 1;
}

stock Crate_Delete(boxid)
{
	if (boxid != -1 && CrateBox[boxid][cbExist])
	{
		new query[64];

		format(query, sizeof(query), "DELETE FROM `crates` WHERE `id` = '%d'", CrateBox[boxid][cbID]);
		mysql_tquery(connectionID, query);

		if (IsValidDynamicObject(CrateBox[boxid][cbObject]))
		    DestroyDynamicObject(CrateBox[boxid][cbObject]);
		DestroyDynamic3DTextLabel(CrateBox[boxid][cbTextID]);
		for (new i = 0; i != MAX_CRATES; i ++) if (CrateBox[i][cbExist] && CrateBox[boxid][cbID]) {
		    SaveCrate(i);
		}
	    CrateBox[boxid][cbExist] = false;
	    CrateBox[boxid][cbID] = 0;
	}
	return 1;
}

stock Crate_Create(playerid)
{
	new Float:x, Float:y, Float:z;

	if (GetPlayerPos(playerid, x, y, z))
	{
		for (new i = 0; i < MAX_CRATES; i ++) if (!CrateBox[i][cbExist])
		{
		    CrateBox[i][cbExist] = true;
			CrateBox[i][cbObject] = 964;
			CrateBox[i][cbOnVeh] = -1;
			CrateBox[i][cbInVeh] = -1;
			CrateBox[i][cbActive] = 1;
			CrateBox[i][cbPos][0] = x;
			CrateBox[i][cbPos][1] = y;
			CrateBox[i][cbPos][2] = z -1.00;
            CrateBox[i][cbInt] = GetPlayerInterior(playerid);
            CrateBox[i][cbVw] = GetPlayerVirtualWorld(playerid);
            CrateBox[i][cbPlacedBy] = GetRPName(playerid);

            //VendorData[i][vendorObject] = CreateDynamicObject(GateData[i][gateModel], GateData[i][gatePos][0], GateData[i][gatePos][1], GateData[i][gatePos][2], GateData[i][gatePos][3], GateData[i][gatePos][4], GateData[i][gatePos][5], GateData[i][gateWorld], GateData[i][gateInterior]);
            new string[128];
            format(string, sizeof(string), "[ID: %d]\nOwner: %s\nPlaced By: %s\n\nType '/packagehelp' to see info", i, PlayerInfo[playerid][pUsername], PlayerInfo[playerid][pUsername]);
            CrateBox[i][cbTextID] = CreateDynamic3DTextLabel(string, COLOR_GREY, CrateBox[i][cbPos][0], CrateBox[i][cbPos][1], CrateBox[i][cbPos][2]+1.5, 20.0, .testlos = 1, .worldid = CrateBox[i][cbVw], .interiorid = CrateBox[i][cbInt], .streamdistance = 20.0);
		    CrateBox[i][cbObject] = CreateDynamicObject(964, CrateBox[i][cbPos][0], CrateBox[i][cbPos][1], CrateBox[i][cbPos][2], 0.00000000, 0.00000000, 0.00000000, CrateBox[i][cbVw], CrateBox[i][cbInt]);
			mysql_tquery(connectionID, "INSERT INTO `crates` (`cbObject`) VALUES(964)", "OnCrateCreated", "d", i);
			Streamer_UpdateEx(playerid, CrateBox[i][cbPos][0], CrateBox[i][cbPos][1], CrateBox[i][cbPos][2]);
			SaveCrate(i);
			return i;
		}
	}
	return -1;
}

forward OnLoadCrateBoxes();
public OnLoadCrateBoxes()
{
    static
	    rows,
	    fields;

	cache_get_data(rows, fields, connectionID);
	new number[16];
	for (new i = 0; i < rows; i ++) if (i < MAX_CRATES)
	{
	    CrateBox[i][cbExist] = true;

	    CrateBox[i][cbID] = cache_get_field_content_int(i, "id");
	    CrateBox[i][cbObject] = cache_get_field_content_int(i, "cbObject");
	    CrateBox[i][cbInt] = cache_get_field_content_int(i, "Int");
	    CrateBox[i][cbVw] = cache_get_field_content_int(i, "VW");

	    CrateBox[i][cbPos][0] = cache_get_field_content_float(i, "CrateX");
	    CrateBox[i][cbPos][1] = cache_get_field_content_float(i, "CrateY");
	    CrateBox[i][cbPos][2] = cache_get_field_content_float(i, "CrateZ");
		
	    cache_get_field_content(0, "PlacedBy", CrateBox[i][cbPlacedBy], connectionID, MAX_PLAYER_NAME);
	    for(new w = 0; w < 20; w++) 
		{
			format(number, sizeof(number), "Gun%d", w+1);
			CrateBox[i][cbWep][w] = cache_get_field_content_int(i, number);
			format(number, sizeof(number), "GunAmount%d", w+1);
			CrateBox[i][cbWepAmount][w] = cache_get_field_content_int(i, number);
		}

	    new string[128];
	    format(string, sizeof(string), "[ID :%d]\nOwner: %s\nPlaced By: %s\n\nType '/packagehelp' to see info", i, CrateBox[i][cbPlacedBy], CrateBox[i][cbPlacedBy]);
	    CrateBox[i][cbTextID] = CreateDynamic3DTextLabel(string, COLOR_GREY, CrateBox[i][cbPos][0], CrateBox[i][cbPos][1], CrateBox[i][cbPos][2]+1.5, 20.0, .testlos = 1, .worldid = CrateBox[i][cbVw], .interiorid = CrateBox[i][cbInt], .streamdistance = 20.0);
	    CrateBox[i][cbObject] = CreateDynamicObject(964, CrateBox[i][cbPos][0], CrateBox[i][cbPos][1], CrateBox[i][cbPos][2], 0.00000000, 0.00000000, 0.00000000, CrateBox[i][cbVw], CrateBox[i][cbInt]);
	    RenderCrate(i);
	}
	return 1;
}

stock CreateCount(veh) 
{
	new amount = 0;
	for(new c = 0; c < MAX_CRATES; c++) {
		if(CrateBox[c][cbInVeh] == veh) {
			++amount;
		}
	}
	return amount;
}

forward PlayerCarryCrate(playerid, boxid, vehid, action) ;
public PlayerCarryCrate(playerid, boxid, vehid, action) 
{
	/*
	--- Action ---
	0 - Pickup from floor
	1 - Put on floor
	2 - Take from vehicle
	3 - Put in vehicle
	4-5 - Player went to busy mode (Events, Prison, Death etc..)
	*/
	new vehicleid = GetNearbyVehicle(playerid), szMiscArray[128];
	if(action == 0) {
		SendClientMessage(playerid, COLOR_WHITE, "Press the '{FFFF00}FIRE{FFFFFF}' button to place the crate on the floor");
		SendClientMessage(playerid, COLOR_WHITE, "or you can use '{FFFF00}/loadpackage{FFFFFF}' to place it into the designated vehicle.");
		if(PlayerHoldingObject[playerid][8] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, 8))
			RemovePlayerAttachedObject(playerid, 8), PlayerHoldingObject[playerid][8] = 0;
		SetPlayerAttachedObject(playerid, 8, 964, 1, -0.071, 0.536, -0.026999, -2.19999, 87.1999, 0.699999, 0.479999, 0.538999, 0.419999);
		if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_CARRY) SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		CarryCrate[playerid] = boxid;
		BeingMoved[boxid] = playerid;
		UpdateCrateBox(boxid);
		Streamer_Update(playerid);
	}
	if(action == 1) 
	{
		new Float: pcbPos[3];
		GetPlayerPos(playerid, pcbPos[0], pcbPos[1], pcbPos[2]);
		GetXYInFrontOfPlayer(playerid, pcbPos[0], pcbPos[1], 1);
		CrateBox[boxid][cbPos][0] = pcbPos[0];
		CrateBox[boxid][cbPos][1] = pcbPos[1];
		CrateBox[boxid][cbPos][2] = pcbPos[2]-1.0;
		CrateBox[boxid][cbInt] = GetPlayerInterior(playerid);
		CrateBox[boxid][cbVw] = GetPlayerVirtualWorld(playerid);
		CrateBox[boxid][cbPlacedBy] = GetPlayerNameEx(playerid);
		RemovePlayerAttachedObject(playerid, 8);
		PlayerHoldingObject[playerid][8] = 0;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		CarryCrate[playerid] = -1;
		BeingMoved[boxid] = INVALID_PLAYER_ID;
		SaveCrate(boxid);
		UpdateCrateBox(boxid);
		Streamer_Update(playerid);
		RenderCrate(boxid);
	}
	if(action == 2) {
		SendClientMessage(playerid, COLOR_WHITE, "Press the '{FFFF00}FIRE{FFFFFF}' button to place the crate on the floor");
		SendClientMessage(playerid, COLOR_WHITE, "or you can use '{FFFF00}/loadpackage{FFFFFF}' to place it into the designated vehicle.");
		if(PlayerHoldingObject[playerid][8] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, 8))
			RemovePlayerAttachedObject(playerid, 8), PlayerHoldingObject[playerid][8] = 0;
		SetPlayerAttachedObject(playerid, 8, 964, 1, -0.071, 0.536, -0.026999, -2.19999, 87.1999, 0.699999, 0.479999, 0.538999, 0.419999);
		if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_CARRY) SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		CrateBox[boxid][cbInVeh] = -1;
		CarryCrate[playerid] = boxid;
		BeingMoved[boxid] = playerid;
		format(szMiscArray, sizeof(szMiscArray), "* %s has unloaded a crate from the %s.", GetPlayerNameEx(playerid), GetVehicleName(vehicleid));
		ProxDetector(25.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	if(action == 3) {
		CrateBox[boxid][cbInVeh] = vehid;
		RemovePlayerAttachedObject(playerid, 8);
		PlayerHoldingObject[playerid][8] = 0;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		CarryCrate[playerid] = -1;
		BeingMoved[boxid] = INVALID_PLAYER_ID;
		SaveCrate(boxid);
		UpdateCrateBox(boxid);
		Streamer_Update(playerid);
		format(szMiscArray, sizeof(szMiscArray), "* %s has loaded a crate into the %s.", GetPlayerNameEx(playerid), GetVehicleName(vehicleid));
		ProxDetector(25.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	if(action == 4 || action == 5) {
		if(action == 4) SendClientMessage(playerid, COLOR_YELLOW, "What do you think your doing?! I'll take that box from you as you seem busy to finish the job!, Sender: Unknown");
		if(action == 5) {
			SendClientMessage(playerid, COLOR_YELLOW, "You were prevented from carrying the crate it has been dropped!, Sender: Unknown");
			new Float: pcbPos[3];
			GetPlayerPos(playerid, pcbPos[0], pcbPos[1], pcbPos[2]);
			GetXYInFrontOfPlayer(playerid, pcbPos[0], pcbPos[1], 1);
			CrateBox[boxid][cbPos][0] = pcbPos[0];
			CrateBox[boxid][cbPos][1] = pcbPos[1];
			CrateBox[boxid][cbPos][2] = pcbPos[2]-1.0;
			CrateBox[boxid][cbInt] = GetPlayerInterior(playerid);
			CrateBox[boxid][cbVw] = GetPlayerVirtualWorld(playerid);
			CrateBox[boxid][cbPlacedBy] = GetPlayerNameEx(playerid);
			SaveCrate(boxid);
			UpdateCrateBox(boxid);
			Streamer_Update(playerid);
		}
		RemovePlayerAttachedObject(playerid, 8);
		PlayerHoldingObject[playerid][8] = 0;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		CarryCrate[playerid] = -1;
		BeingMoved[boxid] = INVALID_PLAYER_ID;
	}
	return 1;
}