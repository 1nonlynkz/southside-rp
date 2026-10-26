stock ShowActionObject(playerid)
{
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, false, false, false, false, 0, SYNC_ALL);
	SetTimerEx("ResetActionObject", 3000, false, "i", playerid);
	return 1;
}

forward ResetActionObject(playerid);
public ResetActionObject(playerid)
{
	ClearAnimations(playerid);
	RemovePlayerAttachedObject(playerid, 20);
	return 1;
}

stock ShowPlayerBackPack(playerid)
{
	new string[1028], header[1028];
	format(header, sizeof(header), "Backpack Menu - Owned By: %s", GetRPName(playerid));
	format(string, sizeof(string),
		"Items:\tInformation:\n\
		Cash:\t%s\n\
		Pots:\t%sg\n\
		Cracks:\t%sg\n\
		Materials:\t%s\n",
		number_format(PlayerInfo[playerid][bpCash]),
		number_format(PlayerInfo[playerid][bpPot]),
		number_format(PlayerInfo[playerid][bpCrack]),
		number_format(PlayerInfo[playerid][bpMaterials]));
	if(PlayerInfo[playerid][pBackpack] == 1) {
		format(string, sizeof(string),
			"%s\
			Weapon:\t%s (Ammo: %d)\n\
			Weapon:\t%s (Ammo: %d)\n\
			Weapon:\t%s (Ammo: %d)",
			string,
			GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][0]), PlayerInfo[playerid][bpAmmo][0],
			GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][1]), PlayerInfo[playerid][bpAmmo][1],
			GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][2]), PlayerInfo[playerid][bpAmmo][2]);
	}
	else if(PlayerInfo[playerid][pBackpack] == 2) {
		format(string, sizeof(string),
			"%s\
			Weapon:\t%s (Ammo: %d)\n\
			Weapon:\t%s (Ammo: %d)\n\
			Weapon:\t%s (Ammo: %d)\n\
			Weapon:\t%s (Ammo: %d)\n\
			Weapon:\t%s (Ammo: %d)",
			string,
			GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][0]), PlayerInfo[playerid][bpAmmo][0],
			GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][1]), PlayerInfo[playerid][bpAmmo][1],
			GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][2]), PlayerInfo[playerid][bpAmmo][2],
			GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][3]), PlayerInfo[playerid][bpAmmo][3],
			GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][4]), PlayerInfo[playerid][bpAmmo][4]);
	}
	else if(PlayerInfo[playerid][pBackpack] == 3) {
		format(string, sizeof(string),
			"%s\
			Weapon:\t%s (Ammo: %d)\n\
			Weapon:\t%s (Ammo: %d)\n\
			Weapon:\t%s (Ammo: %d)\n\
			Weapon:\t%s (Ammo: %d)\n\
			Weapon:\t%s (Ammo: %d)\n\
			Weapon:\t%s (Ammo: %d)\n\
			Weapon:\t%s (Ammo: %d)\n\
			Weapon:\t%s (Ammo: %d)",
			string,
			GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][0]), PlayerInfo[playerid][bpAmmo][0],
			GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][1]), PlayerInfo[playerid][bpAmmo][1],
			GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][2]), PlayerInfo[playerid][bpAmmo][2],
			GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][3]), PlayerInfo[playerid][bpAmmo][3],
			GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][4]), PlayerInfo[playerid][bpAmmo][4],
			GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][5]), PlayerInfo[playerid][bpAmmo][5],
			GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][6]), PlayerInfo[playerid][bpAmmo][6],
			GetWeaponNameEx(PlayerInfo[playerid][bpWeapons][7]), PlayerInfo[playerid][bpAmmo][7]);
	}
	ShowPlayerDialog(playerid, DIALOG_BP_MAIN, DIALOG_STYLE_TABLIST_HEADERS, header, string, "Select", "Cancel");
	return 1;
}

CMD:backpackhelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_WHITE, "Available Commands");
	SendClientMessage(playerid, COLOR_SYNTAX, "Commands: /bopen, /bwear, /bunwear");
	return 1;
}

CMD:bopen(playerid, params[])
{
	if(PlayerInfo[playerid][bpWearing] == 0)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You must be wearing your backpack to use this command"); 
	}
	if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0 || PlayerInfo[playerid][pDueling] != INVALID_PLAYER_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}
	if(PlayerInfo[playerid][pPaintball] > 0)
	{
	    return SendClientMessageEx(playerid, COLOR_WHITE, "You are currently playing in paintball arena. Use /exit instead.");
	}
	if(GetHealth(playerid) < 60)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't drop weapons if your health is below 60.");
	}

	new string[128];
	format(string, sizeof(string), "lays down and opens a backpack.");
	callcmd::me(playerid, string);

	ShowPlayerBackPack(playerid);
	ShowActionObject(playerid);
    return 1;
}

CMD:bwear(playerid, params[])
{
	new string[128];
	if(PlayerInfo[playerid][pJoinedEvent])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}
	if(!PlayerInfo[playerid][bpWearing])
	{
		if(PlayerInfo[playerid][pBackpack] == 1)
		{
			format(string, sizeof(string), "Wears his small backpack on his back.");
			callcmd::me(playerid, string);

			ReloadBackpack(playerid);
		}
		else if(PlayerInfo[playerid][pBackpack] == 2)
		{
			format(string, sizeof(string), "Wears his medium backpack on his back.");
			callcmd::me(playerid, string);

			ReloadBackpack(playerid);
		}
		else if(PlayerInfo[playerid][pBackpack] == 3)
		{
			format(string, sizeof(string), "Wears his large backpack on his back.");
			callcmd::me(playerid, string);

			ReloadBackpack(playerid);
		}
		PlayerInfo[playerid][bpWearing] = 1;
	}
    return 1;
}

CMD:bunwear(playerid, params[])
{
	new string[128];
	if(PlayerInfo[playerid][pJoinedEvent])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}
	if(PlayerInfo[playerid][pBackpack] == 1)
	{
		format(string, sizeof(string), "takes off his small backpack from his back.");
		callcmd::me(playerid, string);

		PlayerInfo[playerid][bpWearing] = 0;
		RemovePlayerAttachedObject(playerid, 6);
	}
	else if(PlayerInfo[playerid][pBackpack] == 2)
	{
		format(string, sizeof(string), "takes off his medium backpack from his back.");
		callcmd::me(playerid, string);
		
		PlayerInfo[playerid][bpWearing] = 0;
		RemovePlayerAttachedObject(playerid, 6);
	}
	else if(PlayerInfo[playerid][pBackpack] == 3)
	{
		format(string, sizeof(string), "takes off his large backpack from his back.");
		callcmd::me(playerid, string);
		
		PlayerInfo[playerid][bpWearing] = 0;
		RemovePlayerAttachedObject(playerid, 6);
	}
	return 1;
}

// Admin Commands
CMD:givebackpack(playerid, params[])
{
	new targetid, size[10], color[10];
	if(PlayerInfo[playerid][pAdmin] < 7)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[10]s[10]", targetid, size, color))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givebackpack [playerid] [size] [color]");
		SendClientMessage(playerid, COLOR_WHITE, "Sizes:   Small, Medium, Large");
		SendClientMessage(playerid, COLOR_WHITE, "Colors:  Blue, Red, Green");
		return 1;
	}
	if(!IsPlayerConnected(targetid))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}

	new colorid = 0;
	if(!strcmp(color, "blue", true)) colorid = 1;
	else if(!strcmp(color, "red", true)) colorid = 2;
	else if(!strcmp(color, "green", true)) colorid = 3;
	else return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid color! Available: Blue, Red, Green");

	if(!strcmp(size, "small", true))
	{
		GivePlayerBackpack(targetid, 1);
		PlayerInfo[targetid][pBackpackColor] = colorid;
		SendMessage(targetid, COLOR_WHITE, "* %s has given you a small (%s) backpack.", GetRPName(playerid), color);
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s a small (%s) backpack.", GetRPName(playerid), GetRPName(targetid), color);
	}
	else if(!strcmp(size, "medium", true))
	{
		GivePlayerBackpack(targetid, 2);
		PlayerInfo[targetid][pBackpackColor] = colorid;
		SendMessage(targetid, COLOR_WHITE, "* %s has given you a medium (%s) backpack.", GetRPName(playerid), color);
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s a medium (%s) backpack.", GetRPName(playerid), GetRPName(targetid), color);
	}
	else if(!strcmp(size, "large", true))
	{
		GivePlayerBackpack(targetid, 3);
		PlayerInfo[targetid][pBackpackColor] = colorid;
		SendMessage(targetid, COLOR_WHITE, "* %s has given you a large (%s) backpack.", GetRPName(playerid), color);
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s a large (%s) backpack.", GetRPName(playerid), GetRPName(targetid), color);
	}
	return 1;
}

CMD:resetbackpack(playerid, params[])
{
	new targetid;
	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /resetbackpack [playerid]");
	    SendClientMessage(playerid, COLOR_SYNTAX, "* This command removes the player's backpack and all items inside it.");
	    return 1;
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	ResetBackpack(targetid);
	SendMessage(targetid, COLOR_LIGHTRED, "Administrator %s has reset your backpack and all its items.", GetRPName(playerid));
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has reset %s's backpack and all its items.", GetRPName(playerid), GetRPName(targetid));
	return 1;
}