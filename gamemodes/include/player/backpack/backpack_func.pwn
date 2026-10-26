GivePlayerBackpack(playerid, uid)
{
	PlayerInfo[playerid][pBackpack] = uid;
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET backpack = %i WHERE uid = %i", PlayerInfo[playerid][pBackpack], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadBackpack(playerid);
	return 0;
}

ReloadBackpack(playerid) 
{
	if(PlayerInfo[playerid][pBackpack] == 1) SetPlayerAttachedObject(playerid, 6, 3026,1,-0.064000,-0.104000,0.000000,0.000000,0.000000,0.000000,0.870999,0.748000,0.828999);
	else if(PlayerInfo[playerid][pBackpack] == 2) SetPlayerAttachedObject(playerid, 6, 3026,1,-0.064000,-0.104000,0.000000,0.000000,0.000000,0.000000,0.870999,0.748000,0.828999);
	else if(PlayerInfo[playerid][pBackpack] == 3) SetPlayerAttachedObject(playerid, 6, 3026,1,-0.064000,-0.104000,0.000000,0.000000,0.000000,0.000000,0.870999,0.748000,0.828999);
	else if(IsPlayerAttachedObjectSlotUsed(playerid, 6)) RemovePlayerAttachedObject(playerid, 6);
}

ResetBackpack(playerid)
{
	if(PlayerInfo[playerid][pLogged] && !PlayerInfo[playerid][pAdminDuty])
	{
		PlayerInfo[playerid][pBackpack] = 0;
		PlayerInfo[playerid][bpCash] = 0;
		PlayerInfo[playerid][bpMaterials] = 0;
		PlayerInfo[playerid][bpPot] = 0;
		PlayerInfo[playerid][bpCrack] = 0;
		PlayerInfo[playerid][bpMeth] = 0;
		PlayerInfo[playerid][bpPainkillers] = 0;
		PlayerInfo[playerid][bpWeapons][0] = 0;
		PlayerInfo[playerid][bpWeapons][1] = 0;
		PlayerInfo[playerid][bpWeapons][2] = 0;
		PlayerInfo[playerid][bpWeapons][3] = 0;
		PlayerInfo[playerid][bpWeapons][4] = 0;
		PlayerInfo[playerid][bpWeapons][5] = 0;
		PlayerInfo[playerid][bpWeapons][6] = 0;
		PlayerInfo[playerid][bpWeapons][7] = 0;
		PlayerInfo[playerid][bpHPAmmo] = 0;
		PlayerInfo[playerid][bpPoisonAmmo] = 0;
		PlayerInfo[playerid][bpFMJAmmo] = 0;
	}
	SavePlayerVariables(playerid);
}

SavePlayerBackpack(playerid)
{
	// Items
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpcash = %i, bpmaterials = %i, bppot = %i, bpcrack = %i, bpmeth = %i, bppainkillers = %i, bphpammo = %i, bppoisonammo = %i, bpfmjammo = %i, totalpatients = %i, totalfires = %i, rarecooldown = %i WHERE uid = %i", PlayerInfo[playerid][bpCash], PlayerInfo[playerid][bpMaterials], PlayerInfo[playerid][bpPot], PlayerInfo[playerid][bpCrack], PlayerInfo[playerid][bpMeth],
        PlayerInfo[playerid][bpPainkillers], PlayerInfo[playerid][bpHPAmmo], PlayerInfo[playerid][bpPoisonAmmo], PlayerInfo[playerid][bpFMJAmmo], PlayerInfo[playerid][pTotalPatients], PlayerInfo[playerid][pTotalFires], PlayerInfo[playerid][pRareTime], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    
	// Weapons 
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_0 = %i, bpweapon_1 = %i, bpweapon_2 = %i, bpweapon_3 = %i, bpweapon_4 = %i, bpweapon_5 = %i, bpweapon_6 = %i, bpweapon_7 = %i WHERE uid = %i", PlayerInfo[playerid][bpWeapons][0], PlayerInfo[playerid][bpWeapons][1], PlayerInfo[playerid][bpWeapons][2], PlayerInfo[playerid][bpWeapons][3],
        PlayerInfo[playerid][bpWeapons][4], PlayerInfo[playerid][bpWeapons][5], PlayerInfo[playerid][bpWeapons][6], PlayerInfo[playerid][bpWeapons][7], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

	// Ammo
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpammo_0 = %i, bpammo_1 = %i, bpammo_2 = %i, bpammo_3 = %i, bpammo_4 = %i, bpammo_5 = %i, bpammo_6 = %i, bpammo_7 = %i WHERE uid = %i", PlayerInfo[playerid][bpAmmo][0], PlayerInfo[playerid][bpAmmo][1], PlayerInfo[playerid][bpAmmo][2], PlayerInfo[playerid][bpAmmo][3],
        PlayerInfo[playerid][bpAmmo][4], PlayerInfo[playerid][bpAmmo][5], PlayerInfo[playerid][bpAmmo][6], PlayerInfo[playerid][bpAmmo][7], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
}

GetBackpackCapacity(playerid, item)
{
	static const stashCapacities[][] = {
		// Cash    Mats     W     C    M    P   HP   PT   FMJ  WEP
	    {1000000,  100000,  25,   25,  10,  5,  80,  60,  50,  4}, // Small
	    {2500000,  250000,  50,   50,  25,  10, 100, 80,  60,  8}, // Medium
	    {5000000,  500000,  100,  75,  50,  20, 125, 100, 70,  12} // Large
	};

	if(PlayerInfo[playerid][pBackpack] > 0)
	{
		return stashCapacities[PlayerInfo[playerid][pBackpack] - 1][item];
	}

	return 0;
}


stock CheckWeaponSlot(weaponid)
{
	switch( weaponid )
	{
		case 0, 1:
		{
			return 0;
		}
		case 2, 3, 4, 5, 6, 7, 8, 9:
		{
			return 1;
		}
		case 22, 23, 24:
		{
			return 2;
		}
		case 25, 26, 27:
		{
			return 3;
		}
		case 28, 29, 32:
		{
			return 4;
		}
		case 30, 31:
		{
			return 5;
		}
		case 33, 34:
		{
			return 6;
		}
		case 35, 36, 37, 38:
		{
			return 7;
		}
		case 16, 17, 18, 39, 40:
		{
			return 8;
		}
		case 41, 42, 43:
		{
			return 9;
		}
		case 10, 11, 12, 13, 14, 15:
		{
			return 10;
		}
		case 44, 45, 46:
		{
			return 11;
		}
	}
	return -1;
}

GetPlayerBackPackType(type)
{
	new string[30];

	switch(type)
	{
	    case 0: string = "None";
	    case 1: string = "Small Backpack";
	    case 2: string = "Medium Backpack";
	    case 3: string = "Large Backpack";
	}
	return string;
}

stock AttachAndDetachBackPack(playerid)
{
	new string[128];
	if(PlayerInfo[playerid][pJoinedEvent])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}
	
	if(!PlayerInfo[playerid][bpWearing])
	{
		new colorVal;
		switch(PlayerInfo[playerid][pBackpackColor])
		{
			case 1: colorVal = -16764007; // Midnight / Royal Blue
			case 2: colorVal = -5505024;  // Premium Velvet Red
			case 3: colorVal = -16744320; // Emerald Green
			default: colorVal = -16764007; // Default Blue
		}

		if(PlayerInfo[playerid][pBackpack] == 1)
		{
			format(string, sizeof(string), "wears his small backpack on his back.");
			callcmd::me(playerid, string);

			SetPlayerAttachedObject(playerid, 6, 3026, 1, -0.064000, -0.104000, 0.000000, 0.000000, 0.000000, 0.000000, 0.870999, 0.748000, 0.828999);
			SetPlayerAttachedObjectMaterial(playerid, 6, 0, 10375, "subshops_sfs", "ws_white_wall1", colorVal);
			PlayerInfo[playerid][bpWearing] = 1;
		}
		else if(PlayerInfo[playerid][pBackpack] == 2)
		{
			format(string, sizeof(string), "wears his medium backpack on his back.");
			callcmd::me(playerid, string);

			SetPlayerAttachedObject(playerid, 6, 3026, 1, -0.064000, -0.104000, 0.000000, 0.000000, 0.000000, 0.000000, 0.870999, 0.748000, 0.828999);
			SetPlayerAttachedObjectMaterial(playerid, 6, 0, 10375, "subshops_sfs", "ws_white_wall1", colorVal);
			PlayerInfo[playerid][bpWearing] = 1;
		}
		else if(PlayerInfo[playerid][pBackpack] == 3)
		{
			format(string, sizeof(string), "wears his large backpack on his back.");
			callcmd::me(playerid, string);

			SetPlayerAttachedObject(playerid, 6, 3026, 1, -0.064000, -0.104000, 0.000000, 0.000000, 0.000000, 0.000000, 0.870999, 0.748000, 0.828999);
			SetPlayerAttachedObjectMaterial(playerid, 6, 0, 10375, "subshops_sfs", "ws_white_wall1", colorVal);
			PlayerInfo[playerid][bpWearing] = 1;
		}
	}
	else
	{
		if(PlayerInfo[playerid][pBackpack] >= 1)
		{
			format(string, sizeof(string), "takes off his backpack from his back.");
			callcmd::me(playerid, string);

			PlayerInfo[playerid][bpWearing] = 0;
			RemovePlayerAttachedObject(playerid, 6);
		}
	}	
	return 1;
}

stock ShowBackPackCategory(playerid)
{
	switch(GetPVarInt(playerid, "Listitem_Backpack")) {
		case 0: ShowPlayerDialog(playerid, DIALOG_BP_CATEGORY, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Cash in my Backpack\nTake Cash in my Backpack", "Choose", "Return");
		case 1: ShowPlayerDialog(playerid, DIALOG_BP_CATEGORY, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Pot in my Backpack\nTake Pot in my Backpack", "Choose", "Return");
		case 2: ShowPlayerDialog(playerid, DIALOG_BP_CATEGORY, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Crack in my Backpack\nTake Crack in my Backpack", "Choose", "Return");
		case 3: ShowPlayerDialog(playerid, DIALOG_BP_CATEGORY, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Materials in my Backpack\nTake Materials in my Backpack", "Choose", "Return");
		case 4: ShowPlayerDialog(playerid, DIALOG_BP_CATEGORY, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Weapons 1 in my Backpack\nTake Weapons 1 in my Backpack", "Choose", "Return");
		case 5: ShowPlayerDialog(playerid, DIALOG_BP_CATEGORY, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Weapons 2 in my Backpack\nTake Weapons 2 in my Backpack", "Choose", "Return");
		case 6: ShowPlayerDialog(playerid, DIALOG_BP_CATEGORY, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Weapons 3 in my Backpack\nTake Weapons 3 in my Backpack", "Choose", "Return");
		case 7: ShowPlayerDialog(playerid, DIALOG_BP_CATEGORY, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Weapons 4 in my Backpack\nTake Weapons 4 in my Backpack", "Choose", "Return");
		case 8: ShowPlayerDialog(playerid, DIALOG_BP_CATEGORY, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Weapons 5 in my Backpack\nTake Weapons 5 in my Backpack", "Choose", "Return");
		case 9: ShowPlayerDialog(playerid, DIALOG_BP_CATEGORY, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Weapons 6 in my Backpack\nTake Weapons 6 in my Backpack", "Choose", "Return");
		case 10: ShowPlayerDialog(playerid, DIALOG_BP_CATEGORY, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Weapons 7 in my Backpack\nTake Weapons 7 in my Backpack", "Choose", "Return");
		case 11: ShowPlayerDialog(playerid, DIALOG_BP_CATEGORY, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Weapons 8 in my Backpack\nTake Weapons 8 in my Backpack", "Choose", "Return");
	}
	return 1;
}