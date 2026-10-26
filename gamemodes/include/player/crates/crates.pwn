#include <YSI_Coding\y_hooks>

CMD:packagehelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_WHITE, "[PACKAGE HELP] /adpackage, /getpackage, /checkpackage, /loadpackage, /unloadpackage");
	return 1;
}

CMD:createpackage(playerid, params[])
{
	static
	    id = -1;
	if(PlayerInfo[playerid][pAdmin] < 6 && !IsCartel(playerid))
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	
	id = Crate_Create(playerid);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The server has reached the limit for crates packages.");

	SendMessage(playerid, COLOR_WHITE, "You have successfully created a weapon package ID: %d.", id);
	return 1;
}

CMD:removepackage(playerid, params[])
{
	static
	    id = 0;

	if(PlayerInfo[playerid][pAdmin] < 6 && !IsCartel(playerid))
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /removepackage [crate id]");

	if ((id < 0 || id >= MAX_CRATES) || !CrateBox[id][cbExist])
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid crate ID.");

	Crate_Delete(id);
	SendMessage(playerid, COLOR_WHITE, "You have successfully removed Crate ID: %d.", id);
	return 1;
}

CMD:carrypackage(playerid, params[])
{
	new box = GetCrateBox(playerid);
	if(box == -1) 
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You're not near to any crate box!");
	}
	if(CarryCrate[playerid] != -1)
	{
		return SendClientMessage(playerid, COLOR_GRAD2, "you're currently carrying a crate either store or drop it before carrying another!");
	} 
	ApplyAnimation(playerid, "CARRY", "liftup", 4.1, false, false, false, false, false, SYNC_ALL);
	SetTimerEx("PlayerCarryCrate", 1000, false, "iiii", playerid, box, -1, 0);
	return 1;
}

CMD:adpackage(playerid, params[])
{
	new box = GetCrateBox(playerid), option[14], param[32], weaponid = GetScriptWeapon(playerid), gunammo = GetPlayerAmmo(playerid);
	if(sscanf(params, "s[14]S()[32]", option, param))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /adpackage [weaponid]");
	}
	if(box == -1) 
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You're not near to any crate box!");
	}
	if(!weaponid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be holding the weapon you're willing to place inside the crate.");
	}
	if(!(1 <= weaponid <= 46) || PlayerInfo[playerid][pWeapons][weaponSlotIDs[weaponid]] != weaponid)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that weapon. /guninv for a list of your weapons.");
	}

	for(new i = 0; i < 20; i ++)
	{
		if(!CrateBox[box][cbWep][i])
		{
			CrateBox[box][cbWep][i] = weaponid;
			CrateBox[box][cbWep][i] = weaponid;
			CrateBox[box][cbWepAmount][i] = gunammo;
			RemovePlayerWeapon(playerid, WEAPON:weaponid);
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE crates SET Gun%i = %i WHERE id = %i", i + 1, CrateBox[box][cbWep][i], CrateBox[box][cbID]);
			mysql_tquery(connectionID, queryBuffer);
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE crates SET GunAmount%i = %i WHERE id = %i", i + 1, CrateBox[box][cbWepAmount][i], CrateBox[box][cbID]);
			mysql_tquery(connectionID, queryBuffer);
			SendMessage(playerid, COLOR_YELLOW, "** You have stored a %s in slot %i of your crate box.", GetWeaponNameEx(CrateBox[box][cbWep][i]), i + 1);
			return 1;
		}
	}
	SendClientMessage(playerid, COLOR_SYNTAX, "This crate box has no more slots available for weapons.");
	return 1;
}

CMD:getpackage(playerid, params[])
{
	new slots = GetCrateWeaponCapacity(CAPACITY_CRATEWEP);
	new value;
	new boxid = GetCrateBox(playerid);
	if(sscanf(params, "i", value))
	{
		return SendMessage(playerid, COLOR_SYNTAX, "Usage: /getpackage [slot]", slots);
	}
	if(boxid == -1) 
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You're not near to any crate box!");
	}
	if(!(1 <= value <= slots))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid slot, or the slot specified is locked.");
	}
	if(!CrateBox[boxid][cbWep][value-1])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The slot specified contains no weapon which you can take.");
	}

	GivePlayerWeaponEx(playerid, CrateBox[boxid][cbWep][value-1], CrateBox[boxid][cbWepAmount][value-1]);
	SendMessage(playerid, COLOR_YELLOW, "** You have taken a %s from slot %i of your crate package.", GetWeaponNameEx(CrateBox[boxid][cbWep][value-1]), value);

	CrateBox[boxid][cbWep][value-1] = 0;
	CrateBox[boxid][cbWepAmount][value-1] = 0;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE crates SET Gun%i = 0 WHERE id = %i", value, CrateBox[boxid][cbID]);
	mysql_tquery(connectionID, queryBuffer);
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE crates SET GunAmount%i = 0 WHERE id = %i", value, CrateBox[boxid][cbID]);
	mysql_tquery(connectionID, queryBuffer);
	return 1;
}

CMD:checkpackage(playerid, params[])
{
	new count, box = GetCrateBox(playerid);
	if(box == -1) 
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You're not near to any crate box!");
	}
	for(new i = 0; i < 20; i ++)
	{
		if(CrateBox[box][cbWep][i])
		{
			count++;
		}
	}
	if(count > 0)
	{
		SendClientMessage(playerid, SERVER_COLOR, "Crate Weapons:");

		for(new i = 0; i < 20; i ++)
		{
			if(CrateBox[box][cbWep][i])
			{
				SendMessage(playerid, COLOR_GREY, "[SLOT: %i] Weapon: %s Ammo: %d", i + 1, GetWeaponNameEx(CrateBox[box][cbWep][i]), CrateBox[box][cbWepAmount][i]);
			}
		}
	}
	else
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "No weapons loaded in this crate.");
	}
	return 1;
}

CMD:loadpackage(playerid, params[])
{
	new vehicleid = GetNearbyVehicle(playerid), szMiscArray[128];
	new engine, lights, alarm, doors, bonnet ,boot, objective, boxid = GetCrateBox(playerid);	

	#pragma unused boxid
	if((boxid = CarryCrate[playerid]) == -1)
	{
		return SendClientMessageEx(playerid, COLOR_GRAD2, "Your not in possession of any crates that you can store!");
	}
	if(vehicleid == INVALID_VEHICLE_ID)
	{
		return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not near any designated vehicles that can store crates.");
	}
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
	{
		return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't load crates into a vehicle whilst the trunk is closed! - '/trunk' to open it.");
	} 
	CrateBox[boxid][cbInVeh] = vehicleid;
	CrateBox[boxid][cbOnVeh] = vehicleid;
	CrateBox[boxid][cbTransfer] = 0;
	RemovePlayerAttachedObject(playerid, 8);
	PlayerHoldingObject[playerid][8] = 0;
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	CarryCrate[playerid] = -1;
	BeingMoved[boxid] = INVALID_PLAYER_ID;
	//SaveCrate(boxid);
	//UpdateCrateBox(boxid);
	Streamer_Update(playerid);
	format(szMiscArray, sizeof(szMiscArray), "* %s has loaded a crate into the %s.", GetPlayerNameEx(playerid), GetVehicleName(vehicleid));
	ProxDetector(25.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	DestroyDynamicObject(CrateBox[boxid][cbObject]);
	DestroyDynamic3DTextLabel(CrateBox[boxid][cbTextID]);
	return 1;
}

CMD:unloadpackage(playerid, params[])
{
	new vehicleid = GetNearbyVehicle(playerid), szMiscArray[128];
	new engine, lights, alarm, doors, bonnet ,boot, objective;
	if(vehicleid == INVALID_VEHICLE_ID)
	{
		return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not near any designated vehicles that can store crates.");
	}
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
	{
		return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't unload crates into a vehicle whilst the trunk is closed! - '/trunk' to open it.");
	}
	if(!CreateCount(vehicleid))
	{
		return SendClientMessageEx(playerid, COLOR_GRAD2, "There are no crates in the vehicle to take!"); 
	} 
	if(CarryCrate[playerid] == -1) 
	{
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
		{
			return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't unload crates into a vehicle whilst the trunk is closed! - '/trunk' to open it.");
		}
		for(new b = 0; b < MAX_CRATES; b++) 
		{
			if(CrateBox[b][cbInVeh] == vehicleid) 
			{
				CrateBox[b][cbInVeh] = -1;
				CrateBox[b][cbOnVeh] = b;
				SaveCrate(b);
				UpdateCrateBox(b);
				Streamer_Update(playerid);
				format(szMiscArray, sizeof(szMiscArray), "* %s has unloaded a crate from the %s.", GetPlayerNameEx(playerid), GetVehicleName(vehicleid));
				ProxDetector(25.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, false, false, false, false, false, SYNC_ALL);
				SetTimerEx("PlayerCarryCrate", 700, false, "iiii", playerid, b, vehicleid, 2);
				break;
			}
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You're already in possession of a crate!");
	return 1;
}

// Crates Order System
AddCratesOrder(playerid, text[])
{
    for(new i = 0; i < MAX_CRATES_ORDER; i ++)
	{
	    if(!CrateOrder[i][crateOrderExists])
	    {
	        strcpy(CrateOrder[i][crateOrderText], text, 128);

	        CrateOrder[i][crateOrderExists] = 1;
			CrateOrder[i][crateOrderAccepted] = 0;
			CrateOrder[i][crateOrderPlayer] = playerid;
			CrateOrder[i][crateOrderHandleBy] = INVALID_PLAYER_ID;
			CrateOrder[i][crateOrderTime] = 5;

			foreach(new p : Player)
			{
				if(IsCartel(p))
				{
					SendMessage(p, COLOR_RED, "___________________________ [ CARTEL BOX ORDER ] ___________________________");
					SendMessage(p, COLOR_WHITE, "ORDER FROM: %s", GetRPName(playerid));
					SendMessage(p, COLOR_WHITE, "ORDER DESCRIPTION: %s", text);
					SendMessage(p, COLOR_RED, "____________________________________________________________________________");
					PlayerPlaySound(p, 31000,0.0,0.0,0.0);
				}
			}
	        return 1;
		}
	}

	return 0;
}

CMD:ordercrate(playerid, params[])
{
	if(PlayerInfo[playerid][pGang] == -1 && PlayerInfo[playerid][pFaction] == -1)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a gang member.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /ordercrate [playerid (optional)] [text]");
	}
	if(PlayerInfo[playerid][pActiveCrateOrder] >= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have an active order which needs to be closed first. Use /cr to close it.");
	}
	if(!AddCratesOrder(playerid, params))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The order queue is currently full. Please try again later.");
	}
	return 1;
}

CMD:listcrateorders(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 6 && !IsCartel(playerid))
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	SendMessage(playerid, COLOR_RED, "___________________________ [ CARTEL BOX ORDER ] ___________________________");
	for(new i = 0; i < MAX_CRATES_ORDER; i ++)
	{
	    if(CrateOrder[i][crateOrderExists] && !CrateOrder[i][crateOrderAccepted])
	    {
	        SendMessage(playerid, COLOR_WHITE, "(OID: %i) %s Order: %s", i, GetRPName(CrateOrder[i][crateOrderPlayer]), CrateOrder[i][crateOrderText]);
		}
	}
	SendMessage(playerid, COLOR_RED, "____________________________________________________________________________");
	return 1;
}


CMD:acceptcrateorders(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 6 && !IsCartel(playerid))
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	new orderid, chat;
	if(sscanf(params, "iI(1)", orderid, chat))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /acceptcrateorders [orderid]");
	}
	if(!(0 <= orderid < MAX_CRATES_ORDER) || !CrateOrder[orderid][crateOrderExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid order ID.");
	}
	if(CrateOrder[orderid][crateOrderAccepted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The order specified is being handled by another admin.");
	}
	if(PlayerInfo[playerid][pActiveCrateOrder] >= 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have a order active already. Use /cr to close it.");
	}

	SendAdminMessage(COLOR_LIGHTRED, "AdmCMD: %s has accepted order %i from %s.", GetRPName(playerid), orderid, GetRPName(CrateOrder[orderid][crateOrderPlayer]));

	if(chat)
	{
		SendMessage(CrateOrder[orderid][crateOrderPlayer], COLOR_YELLOW, "%s has accepted your crate order and is now reviewing it.", GetRPName(playerid));

		PlayerInfo[playerid][pActiveCrateOrder] = orderid;
		PlayerInfo[CrateOrder[orderid][crateOrderPlayer]][pActiveCrateOrder] = orderid;
		CrateOrder[orderid][crateOrderHandleBy] = playerid;
		CrateOrder[orderid][crateOrderAccepted] = 1;
	}
	else
	{
	    SendMessage(CrateOrder[orderid][crateOrderPlayer], COLOR_YELLOW, "%s has accepted your crate order and is now reviewing it.", GetRPName(playerid));
	    CrateOrder[orderid][crateOrderAccepted] = 0;
	}
	return 1;
}

CMD:deletecrateorders(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 6 && !IsCartel(playerid))
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
		
	new orderid, reason[128];
	if(sscanf(params, "iS(N/A)[128]", orderid, reason))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /deletecrateorders [orderid] [reason (optional)]");
	}
	if(!(0 <= orderid < MAX_CRATES_ORDER) || !CrateOrder[orderid][crateOrderExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid order ID.");
	}
    if(CrateOrder[orderid][crateOrderAccepted])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The order specified is being handled by another admin.");
	}

	SendMessage(CrateOrder[orderid][crateOrderPlayer], COLOR_LIGHTRED, "** %s has delete your order, reason: %s", GetRPName(playerid), reason);
	CrateOrder[orderid][crateOrderAccepted] = 0;
	return 1;
}

CMD:completecrateorders(playerid, params[])
{
    new orderid = PlayerInfo[playerid][pActiveCrateOrder];
	
	if(PlayerInfo[playerid][pAdmin] < 6 && !IsCartel(playerid))
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
		
    if(orderid == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have no active order which you can close.");
	}

	if(CrateOrder[orderid][crateOrderPlayer] == playerid)
	{
	    SendMessage(CrateOrder[orderid][crateOrderHandleBy], COLOR_YELLOW, "** Player %s has closed the order. **", GetRPName(playerid));
	    SendMessage(playerid, COLOR_YELLOW, "You have closed the order and ended your conversation with the admin.");
	}
	else
	{
	    SendMessage(CrateOrder[orderid][crateOrderPlayer], COLOR_YELLOW, "** Administrator %s has closed the order. **", GetRPName(playerid));
	    SendMessage(playerid, COLOR_YELLOW, "You have closed the order and ended your conversation with the orderer.");
	}

	if(CrateOrder[orderid][crateOrderPlayer] != INVALID_PLAYER_ID)
	{
		PlayerInfo[CrateOrder[orderid][crateOrderPlayer]][pActiveCrateOrder] = -1;
	}
	if(CrateOrder[orderid][crateOrderHandleBy] != INVALID_PLAYER_ID)
	{
		PlayerInfo[CrateOrder[orderid][crateOrderHandleBy]][pActiveCrateOrder] = -1;
	}

	CrateOrder[orderid][crateOrderExists] = 0;
	CrateOrder[orderid][crateOrderAccepted] = 0;
	CrateOrder[orderid][crateOrderPlayer] = INVALID_PLAYER_ID;
	CrateOrder[orderid][crateOrderHandleBy] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][pActiveCrateOrder] = -1;

	return 1;
}

hook OnGameModeInit()
{
	for(new c = 0; c < MAX_CRATES; c++) 
	{
		BeingMoved[c] = INVALID_PLAYER_ID;
		CrateBox[c][cbObject] = -1;
		CrateBox[c][cbTextID] = Text3D: -1;
	}
	return 1;
}

hook OnPlayerConnect(playerid)
{
    CarryCrate[playerid] = -1;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(CarryCrate[playerid] != -1) 
	{
		PlayerCarryCrate(playerid, CarryCrate[playerid], -1, 1);
	}
    return 1;
}

hook OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
    if(IsKeyJustDown(KEY_FIRE, newkeys, oldkeys)) 
	{
		if(CarryCrate[playerid] >= 0) 
		{
			if(gettime() - CarryCooldown[playerid] < 5)
	    		return SendMessage(playerid, COLOR_SYNTAX, "You can only use heroin once every 3 seconds. Please wait %i more seconds.", 5 - (gettime() - CarryCooldown[playerid]));

			CarryCooldown[playerid] = gettime();

			ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, false, false, false, false, false, SYNC_ALL);
			SetTimerEx("PlayerCarryCrate", 1000, false, "iiii", playerid, CarryCrate[playerid], -1, 1);
		}
	}
    return 1;
}