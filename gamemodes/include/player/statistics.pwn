stock ReturnDate()
{
	new sendString[90], MonthStr[40], month, day, year;
	
	getdate(year, month, day);
	switch(month)
	{
	    case 1:  MonthStr = "January";
	    case 2:  MonthStr = "February";
	    case 3:  MonthStr = "March";
	    case 4:  MonthStr = "April";
	    case 5:  MonthStr = "May";
	    case 6:  MonthStr = "June";
	    case 7:  MonthStr = "July";
	    case 8:  MonthStr = "August";
	    case 9:  MonthStr = "September";
	    case 10: MonthStr = "October";
	    case 11: MonthStr = "November";
	    case 12: MonthStr = "December";
	}
	
	format(sendString, 90, "%s %d, %d", MonthStr, day, year);
	return sendString;
}

CMD:ocheck(playerid, const params[])
{
	new name[24];

	if(PlayerInfo[playerid][pAdmin] < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "s[24]", name))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /ocheck [username]");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM users WHERE username = '%e'", name);
	mysql_tquery(connectionID, queryBuffer, "OnAdminOfflineCheck", "is", playerid, name);
	return 1;
}

CMD:check(playerid, params[])
{
	new targetid;
	if(PlayerInfo[playerid][pAdmin] < 3)
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	if(sscanf(params, "u", targetid))
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /check [playerid]");
	
	if(!IsPlayerConnected(targetid))
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	
	if(!PlayerInfo[targetid][pLogged])
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	
	DisplayStats(playerid, targetid);
	return 1;
}

CMD:stats(playerid, params[])
{
	if(!PlayerInfo[playerid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	DisplayStats(playerid);
	return 1;
}

DisplayStats(playerid, targetid = INVALID_PLAYER_ID)
{
    if(targetid == INVALID_PLAYER_ID) targetid = playerid;

    // Nilakihan ng konti ang dialog buffer para iwas sa bitin na text (truncation)
    new str[256], dialog[3000], title[128], gender[16], faction[64], facrank[64], division[64], gang[64], gangrank[64];

    // Gender
    if(PlayerInfo[targetid][pGender] == 1) format(gender, sizeof(gender), "Male");
    else if(PlayerInfo[targetid][pGender] == 2) format(gender, sizeof(gender), "Female");
    else format(gender, sizeof(gender), "Unknown");

    // Faction
    if(PlayerInfo[targetid][pFaction] >= 0)
    {
        format(faction, sizeof(faction), "%s", FactionInfo[PlayerInfo[targetid][pFaction]][fName]);
        format(facrank, sizeof(facrank), "%s (%d)", FactionRanks[PlayerInfo[targetid][pFaction]][PlayerInfo[targetid][pFactionRank]], PlayerInfo[targetid][pFactionRank]);

        if(PlayerInfo[targetid][pDivision] >= 0)
            format(division, sizeof(division), "%s", FactionDivisions[PlayerInfo[targetid][pFaction]][PlayerInfo[targetid][pDivision]]);
        else format(division, sizeof(division), "None");
    }
    else
    {
        format(faction, sizeof(faction), "None");
        format(facrank, sizeof(facrank), "None");
        format(division, sizeof(division), "None");
    }

    // Gang - INAYOS ANG INDEX DITO
    if(PlayerInfo[targetid][pGang] >= 0)
    {
        format(gang, sizeof(gang), "%s", GangInfo[PlayerInfo[targetid][pGang]][gName]);
        format(gangrank, sizeof(gangrank), "%s (%d)", GangRanks[PlayerInfo[targetid][pGang]][PlayerInfo[targetid][pGangRank]], PlayerInfo[targetid][pGangRank]);
    }
    else
    {
        format(gang, sizeof(gang), "None");
        format(gangrank, sizeof(gangrank), "None");
    }

    format(title, sizeof(title), "{F39C12}*** Stats: %s (%s) ***", GetPlayerNameEx(targetid), ReturnDate());

    // --- BASIC INFO ---
    dialog[0] = '\0'; // Siguraduhing malinis ang dialog buffer bago mag-strcat
    strcat(dialog, "{F39C12}[Basic Information]\n");
    format(str, sizeof(str), "{FFFFFF}Level: {FFFF00}%d  {FFFFFF}|  Playing Hours: {FFFF00}%d\n", PlayerInfo[targetid][pLevel], PlayerInfo[targetid][pHours]); strcat(dialog, str);
    format(str, sizeof(str), "{FFFFFF}Gender: {FFFF00}%s  {FFFFFF}|  Age: {FFFF00}%d\n", gender, PlayerInfo[targetid][pAge]); strcat(dialog, str);
    format(str, sizeof(str), "{FFFFFF}Married To: {FFFF00}%s\n", PlayerInfo[targetid][pMarriedName]); strcat(dialog, str);

    // --- CHARACTER STATUS ---
    strcat(dialog, "\n{F39C12}[Character Status]\n"); 
    format(str, sizeof(str), "{FFFFFF}Health: {FF0000}%d%%  {FFFFFF}|  Armor: {33CCFF}%d%%\n", GetHealth(targetid), GetArmor(targetid)); strcat(dialog, str);
    format(str, sizeof(str), "{FFFFFF}Hunger: {FFFF00}%.1f%%  {FFFFFF}|  Stress: {FFFF00}%.1f%%\n", PlayerInfo[targetid][pHunger], PlayerInfo[targetid][pStress]); strcat(dialog, str);
    format(str, sizeof(str), "{FFFFFF}Inventory Slots: {FFFF00}%d/5  {FFFFFF}|  Addiction Level: {FFFF00}%d/3\n", PlayerInfo[targetid][pInventoryUpgrade], PlayerInfo[targetid][pAddictUpgrade]); strcat(dialog, str);

    // --- FINANCIALS & INVENTORY ITEMS ---
    strcat(dialog, "\n{F39C12}[Financial & Items Status]\n");
    format(str, sizeof(str), "{FFFFFF}Cash On Hand: {2ECC71}$%s  {FFFFFF}|  Bank Balance: {2ECC71}$%s\n", FormatNumber(PlayerInfo[targetid][pCash]), FormatNumber(PlayerInfo[targetid][pBank])); strcat(dialog, str);
    format(str, sizeof(str), "{FFFFFF}Next Paycheck: {2ECC71}$%s  {FFFFFF}|  Total Net Worth: {2ECC71}$%s\n", FormatNumber(PlayerInfo[targetid][pPaycheck]), FormatNumber(PlayerInfo[targetid][pCash] + PlayerInfo[targetid][pBank])); strcat(dialog, str);
    format(str, sizeof(str), "{FFFFFF}Materials: {E67E22}%s pcs\n", FormatNumber(PlayerInfo[targetid][pMaterials])); strcat(dialog, str); 

    // --- ORGANIZATIONS ---
    strcat(dialog, "\n{F39C12}[Employment & Organizations]\n");
    format(str, sizeof(str), "{FFFFFF}Faction Group: {33CCFF}%s  {FFFFFF}|  Rank/Div: {33CCFF}%s / %s\n", faction, facrank, division); strcat(dialog, str);
    format(str, sizeof(str), "{FFFFFF}Gang/Family: {9B59B6}%s  {FFFFFF}|  Gang Rank: {9B59B6}%s\n", gang, gangrank); strcat(dialog, str);
    format(str, sizeof(str), "{FFFFFF}Primary Job: {FFFF00}%s  {FFFFFF}|  Secondary Job: {FFFF00}%s\n", GetJobName(PlayerInfo[targetid][pJob]), GetJobName(PlayerInfo[targetid][pSecondJob])); strcat(dialog, str);

    // --- CRIMINAL & ADMINISTRATIVE RECORDS ---
    strcat(dialog, "\n{F39C12}[Criminal & Admin Records]\n");
    format(str, sizeof(str), "{FFFFFF}Wanted Level: {FF0000}[%d/3]  {FFFFFF}|  Jail Time Left: {FFFF00}%d sec\n", PlayerInfo[targetid][pWantedLevel], PlayerInfo[targetid][pJailTime]); strcat(dialog, str);
    format(str, sizeof(str), "{FFFFFF}Total Crimes: {FFFF00}%d  {FFFFFF}|  Times Arrested: {FFFF00}%d\n", PlayerInfo[targetid][pCrimes], PlayerInfo[targetid][pArrested]); strcat(dialog, str);
    format(str, sizeof(str), "{FFFFFF}DM Warnings: {FF0000}[%d/5]  {FFFFFF}|  Report Warnings: {FF0000}[%d/3]\n", PlayerInfo[targetid][pDMWarnings], PlayerInfo[targetid][pReportWarns]); strcat(dialog, str);

    Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, title, dialog, "Close", "");
    return 1;
}
