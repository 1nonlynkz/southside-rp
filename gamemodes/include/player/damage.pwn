#include <YSI_Coding\y_hooks>

#define BODY_PART_TORSO         (3)
#define BODY_PART_GROIN         (4)
#define BODY_PART_RIGHT_ARM     (5)
#define BODY_PART_LEFT_ARM      (6)
#define BODY_PART_RIGHT_LEG     (7)
#define BODY_PART_LEFT_LEG      (8)
#define BODY_PART_HEAD          (9)
#define MAX_DAMAGES             (100)
#define MAX_DAMAGES_LIST        (20)

enum DAMAGE_ENUM
{
	damageOn,
	damageWeapon,
	damageBodypart,
	Float:damageAmount,
	damageArmour,
	damageTime,
	damageBy[MAX_PLAYER_NAME]
};
new DamageInfo[MAX_PLAYERS][MAX_DAMAGES][DAMAGE_ENUM];

DisplayDamages(toplayer, playerid)
{
	new maxpages = floatround(MAX_DAMAGES/MAX_DAMAGES_LIST,floatround_ceil);
	if(pTemp[toplayer][pDialogList] < 0 || (maxpages < pTemp[toplayer][pDialogList]+1)) return 1;

	new
		title[45],
		start_itter = MAX_DAMAGES_LIST * pTemp[playerid][pDialogList],
		end_itter = (maxpages == pTemp[playerid][pDialogList]+1) ? (MAX_DAMAGES) : (start_itter+MAX_DAMAGES_LIST+1),
		count,
		str[(MAX_PLAYER_NAME + 65) * MAX_DAMAGES_LIST + 71 + 24] = "List of All Damage:\n",
		weaponname[32]
	;

	format(title, sizeof(title), "%s - Received damage (%s)", GetRPName(playerid), ReturnDate());

	if(pTemp[toplayer][pDialogList]) format(str, sizeof(str), "%s Previous Page\n", str);

	for(new i = start_itter; i < end_itter; i++)
	{
	    if(DamageInfo[playerid][i][damageOn] != 1) continue;

		if(gettime()-DamageInfo[playerid][i][damageTime] > 3600) ResetDamage(playerid, i);
		else
		{
			if(count == MAX_DAMAGES_LIST)
			{
				strcat(str, "Next Page");
			}
			else
			{
				new weaponid = DamageInfo[playerid][i][damageWeapon];

				if(weaponid == 0) format(weaponname, sizeof(weaponname), "fist");
				else format(weaponname, sizeof(weaponname), "%s", GetWeaponNameEx(weaponid));

				new stradmin[3 + MAX_PLAYER_NAME] = EOS;
				format(stradmin, sizeof(stradmin), "[%s]", DamageInfo[playerid][i][damageBy]);

				if(DamageInfo[playerid][i][damageWeapon] == 51)
				{
					format(str, sizeof(str), "%s %.0f HP from burn %d by %s\n", str, DamageInfo[playerid][i][damageAmount], gettime()-DamageInfo[playerid][i][damageTime], stradmin);
				}
				else if(!DamageInfo[playerid][i][damageArmour])
				{
					format(str, sizeof(str), "%s %.0f HP %s in %s %d seconds ago by %s\n", str, DamageInfo[playerid][i][damageAmount], weaponname, GetBodyPartName(DamageInfo[playerid][i][damageBodypart]), gettime()-DamageInfo[playerid][i][damageTime], stradmin);
				}
				else
				{
					format(str, sizeof(str), "%s %.0f ARMOR %s in %s %d seconds ago by %s\n", str, DamageInfo[playerid][i][damageAmount], weaponname, GetBodyPartName(DamageInfo[playerid][i][damageBodypart]), gettime()-DamageInfo[playerid][i][damageTime], stradmin);
				}
				count++;
			}
		}
	}
	if(!count) return ShowPlayerDialog(toplayer, 0, DIALOG_STYLE_LIST, title, "There is no damage to display...", ">>>", "");

	SetPVarInt(toplayer, #userid, playerid);
    ShowPlayerDialog(toplayer, DIALOG_DAMAGES, DIALOG_STYLE_TABLIST_HEADERS, title, str, ">>>", "");
	return 1;
}

RecordDamage(userid, playerid, weaponid, bodypart, Float: amount, armour)
{
	for(new i = 0; i != MAX_DAMAGES; i++)
	{
		if(DamageInfo[playerid][i][damageOn] == 1 && gettime()-DamageInfo[playerid][i][damageTime] > 3600) ResetDamage(playerid, i);
	    if(DamageInfo[playerid][i][damageOn] == 1)  continue;
        DamageInfo[playerid][i][damageOn] = 1;

		if(userid != -1) format(DamageInfo[playerid][i][damageBy], MAX_PLAYER_NAME, "%s",  GetPlayerNameEx(userid));
		else 			 format(DamageInfo[playerid][i][damageBy], MAX_PLAYER_NAME, "the fire");

		DamageInfo[playerid][i][damageWeapon] = weaponid;
		DamageInfo[playerid][i][damageBodypart] = bodypart;
		DamageInfo[playerid][i][damageAmount] = amount;
		DamageInfo[playerid][i][damageArmour] = armour;
		DamageInfo[playerid][i][damageTime] = gettime();
		pTemp[playerid][pDamagesCount]++;
		return 1;
    }
    return 1;
}


ResetDamages(playerid)
{
	for(new i = 0; i != MAX_DAMAGES; i++)
	{
	    if (DamageInfo[playerid][i][damageOn] == 0) continue;

		DamageInfo[playerid][i][damageBy] = EOS;
        DamageInfo[playerid][i][damageOn] = 0;
        DamageInfo[playerid][i][damageWeapon] = 0;
        DamageInfo[playerid][i][damageAmount] = 0;
        DamageInfo[playerid][i][damageArmour] = 0;
		DamageInfo[playerid][i][damageTime] = 0;
	}
	pTemp[playerid][pDamagesCount] = 0;
    pTemp[playerid][pInjuredLegTime] = 0;
	return 1;
}

ResetDamage(playerid, i)
{
	if(!DamageInfo[playerid][i][damageOn])	return 1;

	DamageInfo[playerid][i][damageBy] = EOS;
	DamageInfo[playerid][i][damageOn] = 0;
	DamageInfo[playerid][i][damageWeapon] = 0;
	DamageInfo[playerid][i][damageAmount] = 0;
	DamageInfo[playerid][i][damageArmour] = 0;
	DamageInfo[playerid][i][damageTime] = 0;

	return 1;
}

GetBodyPartName(bodypart)
{
	new part[15];
	switch(bodypart)
	{
		case BODY_PART_TORSO: 		part = "BODY";
		case BODY_PART_GROIN: 		part = "SMELL";
		case BODY_PART_LEFT_ARM: 	part = "LEFT HAND";
		case BODY_PART_RIGHT_ARM: 	part = "RIGHT HAND";
		case BODY_PART_LEFT_LEG: 	part = "LEFT FOOT";
		case BODY_PART_RIGHT_LEG: 	part = "RIGHT LEG";
		case BODY_PART_HEAD: 		part = "HEAD";
		default: 					part = "NONE";
	}
	return part;
}


hook OnPlayerDamage(&playerid, &Float:amount, &issuerid, &WEAPON:weapon, &bodypart)
{
    if(bodypart == BODY_PART_TORSO)
    {
		new gunid = WEAPON:GetPlayerWeapon(playerid);
    	if(gunid)
    	{
    		switch(gunid)
	    	{
	    		case 0 .. 9: RecordDamage(issuerid, playerid, gunid, bodypart, amount, 0);
	    		case 22 .. 38: RecordDamage(issuerid, playerid, gunid, bodypart, amount, 1);
	    	}
    	}
    }
    RecordDamage(issuerid, playerid, weapon, bodypart, amount, 0);
    return 1;
}

CMD:damages(playerid, params[])
{
    new userid;

    if(sscanf(params, "u", userid))
        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /damages [playerid]");
    if(!IsPlayerConnected(userid))
        return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid player.");

    if(PlayerInfo[playerid][pAdmin])
    {
        pTemp[playerid][pDialogList] = 0;
	    DisplayDamages(playerid, userid);
    }
    else
    {
        if(!IsPlayerInRangeOfPlayer(playerid, userid, 5.0)) return SendClientMessage(playerid, COLOR_SYNTAX, "You must be closer to that player.");
        pTemp[playerid][pDialogList] = 0;
	    DisplayDamages(playerid, userid);
    }
    return true;
}