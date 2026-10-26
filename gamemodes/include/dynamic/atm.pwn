#include <YSI_Coding\y_hooks>

#define	MAX_ATM      100

enum E_ATM_INFO
{
	atmID,
	atmExists,
	atmModel,
    atmTimestamp,

	Float:atmPosX,
	Float:atmPosY,
	Float:atmPosZ,
	Float:atmPosA,
	atmInterior,
	atmWorld,
	atmObject,
	Text3D:atmTextId
};
new AtmInfo[MAX_ATM][E_ATM_INFO];

stock ShowATM(playerid)
{
	new string[128];
	format(string,sizeof(string), "Total Wealth: %s\nBalance: %s\nWithdraw\nDeposit\nWire Transfer", number_format(PlayerInfo[playerid][pCash] + PlayerInfo[playerid][pBank]), number_format(PlayerInfo[playerid][pBank]));
    ShowPlayerDialog(playerid, DIALOG_ATM, DIALOG_STYLE_LIST, ""GREEN"ATM Machine", string, "Interact", "Closed");
	return 1;
}

stock IsAtATM(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		for(new x; x < MAX_ATM; x++)
		{
			if(AtmInfo[x][atmPosX] != 0)
			{
				if(IsPlayerInRangeOfPoint(playerid, 2.0, AtmInfo[x][atmPosX], AtmInfo[x][atmPosY], AtmInfo[x][atmPosZ]) && GetPlayerInterior(playerid) == AtmInfo[x][atmInterior] && GetPlayerVirtualWorld(playerid) == AtmInfo[x][atmWorld]) return 1;
			}
		}
	}
	return 0;
}

GetNearbyATM(playerid)
{
	for(new x = 0; x < MAX_ATM; x ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, AtmInfo[x][atmPosX], AtmInfo[x][atmPosY], AtmInfo[x][atmPosZ]) && GetPlayerInterior(playerid) == AtmInfo[x][atmInterior] && GetPlayerVirtualWorld(playerid) == AtmInfo[x][atmWorld])
	    {
	        return x;
		}
	}
	return -1;
}

stock ReloadATM(id)
{
	new string[128 * 2];
	DestroyDynamicObject(AtmInfo[id][atmObject]);
	DestroyDynamic3DTextLabel(AtmInfo[id][atmTextId]);
	if(AtmInfo[id][atmPosX] != 0.0)
	{
		format(string,sizeof(string),"ID: %d\nPress 'F' to interact", id);
		AtmInfo[id][atmTextId] = CreateDynamic3DTextLabel(string, COLOR_WHITE, AtmInfo[id][atmPosX], AtmInfo[id][atmPosY], AtmInfo[id][atmPosZ] + 0.4, 10.0, .worldid = AtmInfo[id][atmWorld], .testlos = 0, .streamdistance = 25.0);
		AtmInfo[id][atmObject] = CreateDynamicObject(AtmInfo[id][atmModel], AtmInfo[id][atmPosX], AtmInfo[id][atmPosY], AtmInfo[id][atmPosZ], 0.0, 0.0, AtmInfo[id][atmPosA], AtmInfo[id][atmWorld], AtmInfo[id][atmInterior], .streamdistance = 100.0);
	}
	return 1;
}

forward OnCreateATM(id);
public OnCreateATM(id)
{
	if (id == -1 || !AtmInfo[id][atmExists])
	    return 0;

	AtmInfo[id][atmID] = cache_insert_id(connectionID);
	ATM_Save(id);

	return 1;
}

stock ATM_Create(playerid)
{
	new Float:x, Float:y, Float:z, Float:angle;
	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_ATM; i ++) if (!AtmInfo[i][atmExists])
		{
		    AtmInfo[i][atmExists] = true;
			AtmInfo[i][atmModel] = 19324;

			AtmInfo[i][atmPosX] = x;
			AtmInfo[i][atmPosY] = y;
			AtmInfo[i][atmPosZ] = z;
			AtmInfo[i][atmPosA] = angle;

            AtmInfo[i][atmInterior] = GetPlayerInterior(playerid);
            AtmInfo[i][atmWorld] = GetPlayerVirtualWorld(playerid);

			mysql_tquery(connectionID, "INSERT INTO `atm` (`atmModel`) VALUES(19324)", "OnCreateATM", "d", i);
			Streamer_UpdateEx(playerid, AtmInfo[i][atmPosX], AtmInfo[i][atmPosY], AtmInfo[i][atmPosZ]);
			ReloadATM(i);
			return i;
		}
	}
	return -1;
}

stock ATM_Delete(id)
{
	if (id != -1 && AtmInfo[id][atmExists])
	{
		new query[64];
		format(query, sizeof(query), "DELETE FROM `atm` WHERE `atmID` = '%d'", AtmInfo[id][atmID]);
		mysql_tquery(connectionID, query);

		if (IsValidDynamicObject(AtmInfo[id][atmObject]))
		    DestroyDynamicObject(AtmInfo[id][atmObject]);
		DestroyDynamic3DTextLabel(AtmInfo[id][atmTextId]);

		for (new i = 0; i != MAX_ATM; i ++) if (AtmInfo[i][atmExists] && AtmInfo[id][atmID]) {
		    ATM_Save(i);
		}
	    AtmInfo[id][atmExists] = false;
	    AtmInfo[id][atmID] = 0;
	}
	return 1;
}


stock ATM_Save(id)
{
	new query[768];
	format(query, sizeof(query), "UPDATE `atm` SET `atmModel` = '%d', `atmPosX` = '%f', `atmPosY` = '%f', `atmPosZ` = '%f', `atmInterior` = '%d', `atmWorld` = '%d', `atmPosA` = '%f', `atmTimestamp` = '%i' WHERE `atmID` = '%d'",
	    AtmInfo[id][atmModel],
	    AtmInfo[id][atmPosX],
	    AtmInfo[id][atmPosY],
	    AtmInfo[id][atmPosZ],
	    AtmInfo[id][atmInterior],
	    AtmInfo[id][atmWorld],
	    AtmInfo[id][atmPosA],
		gettime(),
	    AtmInfo[id][atmID]
	);
	return mysql_tquery(connectionID, query);
}

stock ATM_Update(id)
{
	if (id == -1 || !AtmInfo[id][atmExists])
	    return 0;

	ATM_Save(id);
	ReloadATM(id);
	return 1;
}

forward ATM_Load();
public ATM_Load()
{
	new rows = cache_num_rows();
	if(rows) 
	{
		for(new i; i < rows; i++) 
		{
			AtmInfo[i][atmExists] = true;

            AtmInfo[i][atmID] = cache_get_field_content_int(i, "atmID");
            AtmInfo[i][atmModel] = cache_get_field_content_int(i, "atmModel");
            AtmInfo[i][atmTimestamp] = cache_get_field_content_int(i, "atmTimestamp");

            AtmInfo[i][atmInterior] = cache_get_field_content_int(i, "atmInterior");
            AtmInfo[i][atmWorld] = cache_get_field_content_int(i, "atmWorld");
            AtmInfo[i][atmPosA] = cache_get_field_content_int(i, "atmPosA");
            AtmInfo[i][atmPosX] = cache_get_field_content_float(i, "atmPosX");
            AtmInfo[i][atmPosY] = cache_get_field_content_float(i, "atmPosY");
            AtmInfo[i][atmPosZ] = cache_get_field_content_float(i, "atmPosZ");
            ReloadATM(i);
		}
	}
	return 1;
}

CMD:createatm(playerid, params[])
{
	static id = -1;

	if(PlayerInfo[playerid][pAdmin] < 7)
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	id = ATM_Create(playerid);
	if (id == -1)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The server has reached the limit for atm machine.");

	EditDynamicObjectEx(playerid, EDIT_TYPE_ATM, AtmInfo[id][atmObject], id);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has created atm machine [ID: %i]", GetRPName(playerid), id);
	return 1;
}

CMD:removeatm(playerid, params[])
{
	static id = 0;
	if(PlayerInfo[playerid][pAdmin] < 6) 
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /removeatm [atm id]");

	if ((id < 0 || id >= MAX_ATM) || !AtmInfo[id][atmExists])
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid atm machine.");

	ATM_Delete(id);
	SendMessage(playerid, COLOR_WHITE, "You have successfully atm machine [ID: %d]", id);
	return 1;
}

CMD:editatm(playerid, params[])
{
	new id, option[14], param[64];
	if(PlayerInfo[playerid][pAdmin] < 7)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "is[14]S()[64]", id, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editatm [id] [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: position");
	    return 1;
	}
	if ((id < 0 || id >= MAX_ATM) || !AtmInfo[id][atmExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid atm machine.");
	}
	
	EditDynamicObjectEx(playerid, EDIT_TYPE_ATM, AtmInfo[id][atmObject], id);
	SendMessage(playerid, COLOR_WHITE, "You've changed the position of atm machine [ID: %i]", id);
	return 1;
}

hook OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
    if(newkeys & KEY_SECONDARY_ATTACK)
	{
		new id = GetNearbyATM(playerid);
	    if(IsAtATM(playerid))
	    {	
			AtmInfo[id][atmTimestamp] = gettime();
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE `atm` SET `atmTimestamp` = '%i'", gettime());
			mysql_tquery(connectionID, queryBuffer);
			
			ShowATM(playerid);
        }
	}
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_ATM)
    {
        if(response)
        {
            if(listitem == 0) ShowATM(playerid);
			if(listitem == 1) ShowATM(playerid);
			if(listitem == 2)
			{
				if(!IsNumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_ATM_WITHDRAW, DIALOG_STYLE_INPUT, ""GREEN"ATM Machine", "Please input the amount ", "Withdraw", "Cancel");
				ShowPlayerDialog(playerid, DIALOG_ATM_WITHDRAW, DIALOG_STYLE_INPUT, ""GREEN"ATM Machine", "Please input the amount ", "Withdraw", "Cancel");

			}
			if(listitem == 3)
			{
				if(!IsNumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_ATM_DEPOSIT, DIALOG_STYLE_INPUT, ""GREEN"ATM Machine", "Please input the amount", "Withdraw", "Cancel");
				ShowPlayerDialog(playerid, DIALOG_ATM_DEPOSIT, DIALOG_STYLE_INPUT, ""GREEN"ATM Machine", "Please input the amount", "Withdraw", "Cancel");
				
			}
			if(listitem == 4)
			{
				new targetid = strval(inputtext);
				if(!IsNumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_ATM_WIRETRANSFER, DIALOG_STYLE_INPUT, ""GREEN"ATM Machine", "Please Input the ID of the player that you want to send the money:", "Send","Cancel");
				ShowPlayerDialog(playerid, DIALOG_ATM_WIRETRANSFER, DIALOG_STYLE_INPUT, ""GREEN"ATM Machine", "Please Input the ID of the player that you want to send the money:", "Send","Cancel");
				SetPVarInt(playerid, "atm_wiretransfer", targetid);
			}
        }
    }
	if(dialogid == DIALOG_ATM_WITHDRAW)
    {
		if(!response) ShowATM(playerid);
        if(response)
        {
			new amount = strval(inputtext);
			if(amount < 1 || amount > PlayerInfo[playerid][pBank])
			{
				return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			}

			GivePlayerCash(playerid, amount);
			PlayerInfo[playerid][pBank] -= amount;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bank = %i WHERE uid = %i", PlayerInfo[playerid][pBank], PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendMessage(playerid, COLOR_YELLOW, "[ATM Machine]: You have withdrawn $%s from your bank account. Your new balance is $%s.", number_format(amount), number_format(PlayerInfo[playerid][pBank]));
		}
	}
	if(dialogid == DIALOG_ATM_DEPOSIT)
    {
		if(!response) ShowATM(playerid);
        if(response)
        {
			new amount = strval(inputtext);
			if(amount < 1 || amount > PlayerInfo[playerid][pCash])
			{
				return SendClientMessage(playerid, COLOR_SYNTAX, "Insufficient amount.");
			}

			GivePlayerCash(playerid, -amount);
			PlayerInfo[playerid][pBank] += amount;
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bank = %i WHERE uid = %i", PlayerInfo[playerid][pBank], PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendMessage(playerid, COLOR_YELLOW, "[ATM Machine]: You have deposited $%s into your bank account. Your new balance is $%s.", number_format(amount), number_format(PlayerInfo[playerid][pBank]));
		}
	}
	if(dialogid == DIALOG_ATM_WIRETRANSFER)
    {
		if(!response) ShowATM(playerid);
        if(response)
        {
			new string[128], targetid = GetPVarInt(playerid, "atm_wiretransfer");
			format(string, sizeof(string), "Please enter an amount to give %s.", GetRPName(targetid));

			if(!IsNumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_ATM_SENDMONEY, DIALOG_STYLE_INPUT, ""GREEN"ATM Machine", string, "Transfer","Return");
			ShowPlayerDialog(playerid, DIALOG_ATM_SENDMONEY, DIALOG_STYLE_INPUT, ""GREEN"ATM Machine", string, "Transfer","Return");
		}
	}
	if(dialogid == DIALOG_ATM_SENDMONEY)
    {
		if(!response) ShowATM(playerid);
        if(response)
        {
			new string[128], targetid = GetPVarInt(playerid, "atm_wiretransfer"), amount;
			if(sscanf(inputtext, "i", amount))
			{
				format(string, sizeof(string), "Please enter an amount to give %s.", GetRPName(targetid));
				return ShowPlayerDialog(playerid, DIALOG_ATM_WIRETRANSFER, DIALOG_STYLE_INPUT, ""GREEN"ATM Machine", string, "Transfer","Return");
			}
			if(!(1 <= amount <= 200000))
			{
				format(string, sizeof(string), "Don't go below $1, or above $200,000 at once.\n\nPlease enter an amount to give %s.", GetRPName(targetid));
				return ShowPlayerDialog(playerid, DIALOG_ATM_WIRETRANSFER, DIALOG_STYLE_INPUT, ""GREEN"ATM Machine", string, "Transfer","Return");
			}

			PlayerInfo[targetid][pBank] += amount;
			PlayerInfo[playerid][pBank] -= amount;

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bank = %i WHERE uid = %i", PlayerInfo[playerid][pBank], PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bank = %i WHERE uid = %i", PlayerInfo[targetid][pBank], PlayerInfo[targetid][pID]);
			mysql_tquery(connectionID, queryBuffer);

			SendMessage(playerid, COLOR_WHITE, "** You have transferred $%i to %s. Your new balance is $%i.", amount, GetRPName(targetid), PlayerInfo[playerid][pBank]);
			SendMessage(targetid, COLOR_WHITE, "** %s has transferred $%i to your bank account.", GetRPName(playerid), amount);
			Log_Write("log_give", "%s (uid: %i) (IP: %s) transferred $%i to %s (uid: %i) (IP: %s)", GetRPName(playerid), PlayerInfo[playerid][pID], GetPlayerIP(playerid), amount, GetRPName(targetid), PlayerInfo[targetid][pID], GetPlayerIP(targetid));

			if(!strcmp(GetPlayerIP(playerid), GetPlayerIP(targetid)))
			{
				SendAdminMessage(COLOR_RED, "AdmWarning: "YELLOW"%s (IP: %s) has transferred $%i to %s (IP: %s).", GetRPName(playerid), GetPlayerIP(playerid), amount, GetRPName(targetid), GetPlayerIP(targetid));
			}
		}
	}
    return 1;
}