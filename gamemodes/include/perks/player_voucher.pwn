#include <YSI_Coding\y_hooks>

CMD:myvouchers(playerid, params[])
{
    if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0 || PlayerInfo[playerid][pPaintball])
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");

    ShowPlayerVoucher(playerid, playerid);
    return 1;
}

ShowPlayerVoucher(playerid, targetid)
{
    new string[1028], header[128];

    strcat(string, "Vouchers\tAmount");
    format(header, sizeof(header), "Player '%s' Vouchers | %s", GetRPName(targetid),ReturnDate());
    format(string, sizeof(string), "%s\n\
    {AFAFAF}Car Vouchers:\t{FFFFFF}%d\n\
    {AFAFAF}Rare Car Vouchers:\t{FFFFFF}%d\n\
    {AFAFAF}Restricted Car Vouchers:\t{FFFFFF}%d\n\
    {AFAFAF}7 Days BVIP Vouchers\t{FFFFFF}%d\n\
    {AFAFAF}7 Days SVIP Vouchers\t{FFFFFF}%d\n\
    {AFAFAF}7 Days GVIP Vouchers\t{FFFFFF}%d\n\
    {AFAFAF}7 Days PVIP Vouchers\t{FFFFFF}%d\n\
    {AFAFAF}1 Month BVIP Vouchers\t{FFFFFF}%d\n\
    {AFAFAF}1 Month SVIP Vouchers\t{FFFFFF}%d\n\
    {AFAFAF}1 Month GVIP Vouchers\t{FFFFFF}%d\n\
    {AFAFAF}1 Month PVIP Vouchers\t{FFFFFF}%d", string,
    PlayerInfo[targetid][pCarVoucher][0],
    PlayerInfo[targetid][pCarVoucher][1],
    PlayerInfo[targetid][pCarVoucher][2],
    PlayerInfo[targetid][pVIPVoucher][0],
    PlayerInfo[targetid][pVIPVoucher][1],
    PlayerInfo[targetid][pVIPVoucher][2],
    PlayerInfo[targetid][pVIPVoucher][3],
    PlayerInfo[targetid][pVIPVoucher][4],
    PlayerInfo[targetid][pVIPVoucher][5],
    PlayerInfo[targetid][pVIPVoucher][6],
    PlayerInfo[targetid][pVIPVoucher][7]);
    ShowPlayerDialog(playerid, DIALOG_VOUCHER, DIALOG_STYLE_TABLIST_HEADERS, header, string, "Select", "Close");
    return 1;
}

CMD:checkvoucher(playerid, params[])
{
	new targetid;
	if(PlayerInfo[playerid][pAdmin] < 3)
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	if(sscanf(params, "u", targetid))
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /checkvoucher [playerid]");
	
	if(!IsPlayerConnected(targetid))
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	
	if(!PlayerInfo[targetid][pLogged])
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	
	ShowPlayerVoucher(targetid, targetid);
	return 1;
}

CMD:setvoucher(playerid, params[])
{
    new targetid, string[128], option[24], param[32], value;

    if(PlayerInfo[playerid][pAdmin] < 7)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[24]S()[32]", targetid, option, param))
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setvoucher [playerid] [option]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: CarVoucher, RareCarVoucher, RestrictedCarVoucher, 7DBVIP, 7DSVIP, 7DGVIP, 7DPVIP, BVIP, SVIP, GVIP, PVIP");
		return 1;
	}
    if(!strcmp(option, "carvoucher", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [carvoucher] [value]");
		}

        PlayerInfo[targetid][pCarVoucher][0] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_0 = %i WHERE uid = %i", PlayerInfo[targetid][pCarVoucher][0], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx car voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "rarecarvoucher", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [rarecarvoucher] [value]");
		}

        PlayerInfo[targetid][pCarVoucher][1] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_1 = %i WHERE uid = %i", PlayerInfo[targetid][pCarVoucher][1], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx rare car voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "restrictedcarvoucher", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [restrictedcarvoucher] [value]");
		}

        PlayerInfo[targetid][pCarVoucher][2] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_2 = %i WHERE uid = %i", PlayerInfo[targetid][pCarVoucher][2], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx restricted car voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dbvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [7dbvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][0] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_0 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][0], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days bvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dsvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [7dsvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][1] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_1 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][1], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days svip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dgvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [7dgvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][2] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_2 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][2], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days gvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dpvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [7dpvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][3] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_3 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][3], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days gvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "bvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [bvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][4] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_4 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][4], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month bvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "svip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [svip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][5] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_5 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][5], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month svip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "gvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [gvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][6] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_6 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][6], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month gvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "pvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [pvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][7] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_7 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][7], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month pvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    return 1;
}

CMD:removevoucher(playerid, params[])
{
    new targetid, string[128], option[24], param[32], value;

    if(PlayerInfo[playerid][pAdmin] < 7)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "us[24]S()[32]", targetid, option, param))
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /removevoucher [playerid] [option]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: CarVoucher, RareCarVoucher, RestrictedCarVoucher, 7DBVIP, 7DSVIP, 7DGVIP, 7DPVIP, BVIP, SVIP, GVIP, PVIP");
		return 1;
	}
    if(!strcmp(option, "carvoucher", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [carvoucher] [value]");
		}

        PlayerInfo[targetid][pCarVoucher][0] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_0 = %i WHERE uid = %i", PlayerInfo[targetid][pCarVoucher][0], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx car voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "rarecarvoucher", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [rarecarvoucher] [value]");
		}

        PlayerInfo[targetid][pCarVoucher][1] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_1 = %i WHERE uid = %i", PlayerInfo[targetid][pCarVoucher][1], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx rare car voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "restrictedcarvoucher", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [restrictedcarvoucher] [value]");
		}

        PlayerInfo[targetid][pCarVoucher][2] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_2 = %i WHERE uid = %i", PlayerInfo[targetid][pCarVoucher][2], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx restricted car voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dbvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [7dbvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][0] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_0 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][0], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days bvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dsvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [7dsvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][1] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_1 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][1], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days svip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dgvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [7dgvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][2] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_2 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][2], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days gvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dpvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [7dpvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][3] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_3 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][3], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days gvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "bvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [bvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][4] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_4 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][4], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month bvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "svip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [svip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][5] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_5 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][5], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month svip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "gvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [gvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][6] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_6 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][6], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month gvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "pvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [pvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][7] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_7 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][7], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month pvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    return 1;
}

CMD:givevoucher(playerid, params[])
{
    new targetid, string[128], option[24], param[32], amount;
	if(sscanf(params, "us[24]S()[32]", targetid, option, param))
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /givevoucher [playerid] [option]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: CarVoucher, RareCarVoucher, RestrictedCarVoucher, 7DBVIP, 7DSVIP, 7DGVIP, 7DPVIP, BVIP, SVIP, GVIP, PVIP");
		return 1;
	}
    if(!strcmp(option, "carvoucher", true))
	{
        if(sscanf(param, "i", amount))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givevoucher [playerid] [carvoucher] [amount]");
		}

        if(PlayerInfo[playerid][pCarVoucher][0]<= 0) 
            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a Car Voucher.");

        PlayerInfo[targetid][pCarVoucher][0] += amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_0 = %i WHERE uid = %i", PlayerInfo[targetid][pCarVoucher][0], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        PlayerInfo[playerid][pCarVoucher][0] -= amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_0 = %i WHERE uid = %i", PlayerInfo[playerid][pCarVoucher][0], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx car voucher by %s", amount, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "rarecarvoucher", true))
	{
        if(sscanf(param, "i", amount))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givevoucher [playerid] [rarecarvoucher] [amount]");
		}

        if(PlayerInfo[playerid][pCarVoucher][1]<= 0) 
            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a Rare Car Voucher.");

        PlayerInfo[targetid][pCarVoucher][1] += amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_1 = %i WHERE uid = %i", PlayerInfo[targetid][pCarVoucher][1], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        PlayerInfo[playerid][pCarVoucher][1] -= amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_1 = %i WHERE uid = %i", PlayerInfo[playerid][pCarVoucher][1], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx rare car voucher by %s", amount, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "restrictedcarvoucher", true))
	{
        if(sscanf(param, "i", amount))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givevoucher [playerid] [restrictedcarvoucher] [amount]");
		}

        if(PlayerInfo[playerid][pCarVoucher][2]<= 0) 
            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a Restricted Car Voucher.");

        PlayerInfo[targetid][pCarVoucher][2] += amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_2 = %i WHERE uid = %i", PlayerInfo[targetid][pCarVoucher][2], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        PlayerInfo[playerid][pCarVoucher][2] -= amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_2 = %i WHERE uid = %i", PlayerInfo[playerid][pCarVoucher][2], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx restricted car voucher by %s", amount, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dbvip", true))
	{
        if(sscanf(param, "i", amount))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givevoucher [playerid] [7dbvip] [amount]");
		}

        if(PlayerInfo[playerid][pVIPVoucher][0]<= 0) 
            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7D BVIP Voucher.");

        PlayerInfo[targetid][pVIPVoucher][0] += amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_0 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][0], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        PlayerInfo[playerid][pVIPVoucher][0] -= amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_0 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][0], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days bvip voucher by %s", amount, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dsvip", true))
	{
        if(sscanf(param, "i", amount))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givevoucher [playerid] [7dsvip] [amount]");
		}

        if(PlayerInfo[playerid][pVIPVoucher][1]<= 0) 
            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7D SVIP Voucher.");

        PlayerInfo[targetid][pVIPVoucher][1] += amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_1 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][1], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        PlayerInfo[playerid][pVIPVoucher][1] -= amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_1 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][1], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days svip voucher by %s", amount, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dgvip", true))
	{
        if(sscanf(param, "i", amount))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givevoucher [playerid] [7dgvip] [amount]");
		}

        if(PlayerInfo[playerid][pVIPVoucher][2]<= 0) 
            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7D GVIP Voucher.");

        PlayerInfo[targetid][pVIPVoucher][2] += amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_2 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][2], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        PlayerInfo[playerid][pVIPVoucher][2] -= amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_2 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][2], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days gvip voucher by %s", amount, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dpvip", true))
	{
        if(sscanf(param, "i", amount))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givevoucher [playerid] [7dpvip] [amount]");
		}

        if(PlayerInfo[playerid][pVIPVoucher][3]<= 0) 
            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7D PVIP Voucher.");

        PlayerInfo[targetid][pVIPVoucher][3] += amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_3 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][3], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        PlayerInfo[playerid][pVIPVoucher][3] -= amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_3 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][3], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days gvip voucher by %s", amount, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "bvip", true))
	{
        if(sscanf(param, "i", amount))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givevoucher [playerid] [bvip] [amount]");
		}

        if(PlayerInfo[playerid][pVIPVoucher][4]<= 0) 
            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 1 Month BVIP Voucher.");

        PlayerInfo[targetid][pVIPVoucher][4] += amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_4 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][4], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        PlayerInfo[playerid][pVIPVoucher][4] -= amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_4 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][4], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month bvip voucher by %s", amount, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "svip", true))
	{
        if(sscanf(param, "i", amount))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givevoucher [playerid] [svip] [amount]");
		}

        if(PlayerInfo[playerid][pVIPVoucher][5]<= 0) 
            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 1 Month SVIP Voucher.");

        PlayerInfo[targetid][pVIPVoucher][5] += amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_5 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][5], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        PlayerInfo[playerid][pVIPVoucher][5] -= amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_5 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][5], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month svip voucher by %s", amount, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "gvip", true))
	{
        if(sscanf(param, "i", amount))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givevoucher [playerid] [gvip] [amount]");
		}

        if(PlayerInfo[playerid][pVIPVoucher][6]<= 0) 
            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 1 Month GVIP Voucher.");

        PlayerInfo[targetid][pVIPVoucher][6] += amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_6 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][6], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        PlayerInfo[playerid][pVIPVoucher][6] -= amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_6 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][6], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month gvip voucher by %s", amount, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "pvip", true))
	{
        if(sscanf(param, "i", amount))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givevoucher [playerid] [pvip] [amount]");
		}

        if(PlayerInfo[playerid][pVIPVoucher][7]<= 0) 
            return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 1 Month PVIP Voucher.");

        PlayerInfo[targetid][pVIPVoucher][7] += amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_7 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][7], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        PlayerInfo[playerid][pVIPVoucher][7] -= amount;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_7 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][7], PlayerInfo[playerid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month pvip voucher by %s", amount, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    return 1;
}


CMD:sellvoucher(playerid, params[])
{
    new targetid, option[24], param[24], amount, price;
	if(sscanf(params, "us[14]S()[32]", targetid, option, param))
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sellvoucher [playerid] [option]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: CarVoucher, RareCarVoucher, RestrictedCarVoucher, 7DayBVIP, 7DaySVIP, 7DayGVIP, BronzeVIP, SilverVIP, GoldVIP");
		return 1;
	}
    if(!strcmp(option, "carvoucher", true))
	{
        if(sscanf(param, "ii", amount, price))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellvoucher [playerid] [carvoucher] [amount] [price]");
		}
        if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
        }
        if(targetid == playerid)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot sell your voucher yourself");
        }
        if(!(1 <= price <= 10000000))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "You must specify a price greater than $1 or less than $10,000,000.");
        }
        if(PlayerInfo[playerid][pCarVoucher][0] < amount)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much car voucher.");
		}

        PlayerInfo[targetid][pVoucherOffer] = playerid;
	    PlayerInfo[targetid][pVoucherType] = 1;
        PlayerInfo[targetid][pVoucherPrice] = price;
        PlayerInfo[targetid][pVoucherAmount] = amount;

		SendMessage(playerid, COLOR_LIGHTBLUE, "You have offered %s %d car voucher(s) for $%s, please wait until he accept the offer.", GetRPName(targetid), amount, number_format(price));
        SendMessage(targetid, COLOR_LIGHTBLUE, "%s has offered to sell you %d car voucher(s) for $%s - Type /acceptvoucher.", GetRPName(playerid), amount, number_format(price));
	}
    else if(!strcmp(option, "rarecarvoucher", true))
	{
        if(sscanf(param, "ii", amount, price))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellvoucher [playerid] [rarecarvoucher] [amount] [price]");
		}
        if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
        }
        if(targetid == playerid)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot sell your voucher yourself");
        }
        if(!(1 <= price <= 10000000))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "You must specify a price greater than $1 or less than $10,000,000.");
        }
        if(PlayerInfo[playerid][pCarVoucher][1] < amount)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much rare car voucher.");
		}

        PlayerInfo[targetid][pVoucherOffer] = playerid;
	    PlayerInfo[targetid][pVoucherType] = 2;
        PlayerInfo[targetid][pVoucherPrice] = price;
        PlayerInfo[targetid][pVoucherAmount] = amount;

        SendMessage(playerid, COLOR_LIGHTBLUE, "You have offered %s %d rare car voucher(s) for $%s, please wait until he accept the offer.", GetRPName(targetid), amount, number_format(price));
        SendMessage(targetid, COLOR_LIGHTBLUE, "%s has offered to sell you %d rare car voucher(s) for $%s - Type /acceptvoucher.", GetRPName(playerid), amount, number_format(price));
	}
    else if(!strcmp(option, "restrictedcarvoucher", true))
	{
        if(sscanf(param, "ii", amount, price))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellvoucher [playerid] [restrictedcarvoucher] [amount] [price]");
		}
        if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
        }
        if(targetid == playerid)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot sell your voucher yourself");
        }
        if(!(1 <= price <= 10000000))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "You must specify a price greater than $1 or less than $10,000,000.");
        }
        if(PlayerInfo[playerid][pCarVoucher][2] < amount)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much restricted car voucher.");
		}

        PlayerInfo[targetid][pVoucherOffer] = playerid;
	    PlayerInfo[targetid][pVoucherType] = 3;
        PlayerInfo[targetid][pVoucherPrice] = price;
        PlayerInfo[targetid][pVoucherAmount] = amount;

        SendMessage(playerid, COLOR_LIGHTBLUE, "You have offered %s %d restricted car voucher(s) for $%s, please wait until he accept the offer.", GetRPName(targetid), amount, number_format(price));
        SendMessage(targetid, COLOR_LIGHTBLUE, "%s has offered to sell you %d restricted car voucher(s) for $%s - Type /acceptvoucher.", GetRPName(playerid), amount, number_format(price));
	}
    else if(!strcmp(option, "7daybvip", true))
	{
        if(sscanf(param, "ii", amount, price))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellvoucher [playerid] [7daybvip] [amount] [price]");
		}
        if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
        }
        if(targetid == playerid)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot sell your voucher yourself");
        }
        if(!(1 <= price <= 10000000))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "You must specify a price greater than $1 or less than $10,000,000.");
        }
        if(PlayerInfo[playerid][pVIPVoucher][0] < amount)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much 7daybvip.");
		}

        PlayerInfo[targetid][pVoucherOffer] = playerid;
	    PlayerInfo[targetid][pVoucherType] = 4;
        PlayerInfo[targetid][pVoucherPrice] = price;
        PlayerInfo[targetid][pVoucherAmount] = amount;

        SendMessage(playerid, COLOR_LIGHTBLUE, "You have offered %s %d 7Day BVIP Voucher(s) for $%s, please wait until he accept the offer.", GetRPName(targetid), amount, number_format(price));
        SendMessage(targetid, COLOR_LIGHTBLUE, "%s has offered to sell you %d 7Day BVIP Voucher(s) for $%s - Type /acceptvoucher.", GetRPName(playerid), amount, number_format(price));
	}
    else if(!strcmp(option, "7daysvip", true))
	{
        if(sscanf(param, "ii", amount, price))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellvoucher [playerid] [7daysvip] [amount] [price]");
		}
        if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
        }
        if(targetid == playerid)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot sell your voucher yourself");
        }
        if(!(1 <= price <= 10000000))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "You must specify a price greater than $1 or less than $10,000,000.");
        }
        if(PlayerInfo[playerid][pVIPVoucher][1] < amount)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much 7daysvip.");
		}

        PlayerInfo[targetid][pVoucherOffer] = playerid;
	    PlayerInfo[targetid][pVoucherType] = 5;
        PlayerInfo[targetid][pVoucherPrice] = price;
        PlayerInfo[targetid][pVoucherAmount] = amount;

        SendMessage(playerid, COLOR_LIGHTBLUE, "You have offered %s %d 7Day SVIP Voucher(s) for $%s, please wait until he accept the offer.", GetRPName(targetid), amount, number_format(price));
        SendMessage(targetid, COLOR_LIGHTBLUE, "%s has offered to sell you %d 7Day SVIP Voucher(s) for $%s - Type /acceptvoucher.", GetRPName(playerid), amount, number_format(price));
	}
    else if(!strcmp(option, "7daygvip", true))
	{
        if(sscanf(param, "ii", amount, price))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellvoucher [playerid] [7daygvip] [amount] [price]");
		}
        if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
        }
        if(targetid == playerid)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot sell your voucher yourself");
        }
        if(!(1 <= price <= 10000000))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "You must specify a price greater than $1 or less than $10,000,000.");
        }
        if(PlayerInfo[playerid][pVIPVoucher][2] < amount)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much 7daygvip.");
		}

        PlayerInfo[targetid][pVoucherOffer] = playerid;
	    PlayerInfo[targetid][pVoucherType] = 6;
        PlayerInfo[targetid][pVoucherPrice] = price;
        PlayerInfo[targetid][pVoucherAmount] = amount;

        SendMessage(playerid, COLOR_LIGHTBLUE, "You have offered %s %d 7Day GVIP Voucher(s) for $%s, please wait until he accept the offer.", GetRPName(targetid), amount, number_format(price));
        SendMessage(targetid, COLOR_LIGHTBLUE, "%s has offered to sell you %d 7Day GVIP Voucher(s) for $%s - Type /acceptvoucher.", GetRPName(playerid), amount, number_format(price));
	}
    else if(!strcmp(option, "7daypvip", true))
	{
        if(sscanf(param, "ii", amount, price))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellvoucher [playerid] [7daypvip] [amount] [price]");
		}
        if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
        }
        if(targetid == playerid)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot sell your voucher yourself");
        }
        if(!(1 <= price <= 10000000))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "You must specify a price greater than $1 or less than $10,000,000.");
        }
        if(PlayerInfo[playerid][pVIPVoucher][3] < amount)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much 7daypvip.");
		}

        PlayerInfo[targetid][pVoucherOffer] = playerid;
	    PlayerInfo[targetid][pVoucherType] = 7;
        PlayerInfo[targetid][pVoucherPrice] = price;
        PlayerInfo[targetid][pVoucherAmount] = amount;

        SendMessage(playerid, COLOR_LIGHTBLUE, "You have offered %s %d 7Day PVIP Voucher(s) for $%s, please wait until he accept the offer.", GetRPName(targetid), amount, number_format(price));
        SendMessage(targetid, COLOR_LIGHTBLUE, "%s has offered to sell you %d 7Day PVIP Voucher(s) for $%s - Type /acceptvoucher.", GetRPName(playerid), amount, number_format(price));
	}
    else if(!strcmp(option, "bronzevip", true))
	{
        if(sscanf(param, "ii", amount, price))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellvoucher [playerid] [bronzevip] [amount] [price]");
		}
        if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
        }
        if(targetid == playerid)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot sell your voucher yourself");
        }
        if(!(1 <= price <= 10000000))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "You must specify a price greater than $1 or less than $10,000,000.");
        }
        if(PlayerInfo[playerid][pVIPVoucher][4] < amount)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much bronzevip.");
		}

        PlayerInfo[targetid][pVoucherOffer] = playerid;
	    PlayerInfo[targetid][pVoucherType] = 8;
        PlayerInfo[targetid][pVoucherPrice] = price;
        PlayerInfo[targetid][pVoucherAmount] = amount;

        SendMessage(playerid, COLOR_LIGHTBLUE, "You have offered %s %d 1 Month BVIP Voucher(s) for $%s, please wait until he accept the offer.", GetRPName(targetid), amount, number_format(price));
        SendMessage(targetid, COLOR_LIGHTBLUE, "%s has offered to sell you %d 1 Month BVIP Voucher(s) for $%s - Type /acceptvoucher.", GetRPName(playerid), amount, number_format(price));
	}
    else if(!strcmp(option, "silvervip", true))
	{
        if(sscanf(param, "ii", amount, price))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellvoucher [playerid] [silvervip] [amount] [price]");
		}
        if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
        }
        if(targetid == playerid)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot sell your voucher yourself");
        }
        if(!(1 <= price <= 10000000))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "You must specify a price greater than $1 or less than $10,000,000.");
        }
        if(PlayerInfo[playerid][pVIPVoucher][5] < amount)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much silvervip.");
		}

        PlayerInfo[targetid][pVoucherOffer] = playerid;
	    PlayerInfo[targetid][pVoucherType] = 9;
        PlayerInfo[targetid][pVoucherPrice] = price;
        PlayerInfo[targetid][pVoucherAmount] = amount;
        
        SendMessage(playerid, COLOR_LIGHTBLUE, "You have offered %s %d 1 Month SVIP Voucher(s) for $%s, please wait until he accept the offer.", GetRPName(targetid), amount, number_format(price));
        SendMessage(targetid, COLOR_LIGHTBLUE, "%s has offered to sell you %d 1 Month SVIP Voucher(s) for $%s - Type /acceptvoucher.", GetRPName(playerid), amount, number_format(price));
	}
    else if(!strcmp(option, "goldvip", true))
	{
        if(sscanf(param, "ii", amount, price))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellvoucher [playerid] [goldvip] [amount] [price]");
		}
        if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
        }
        if(targetid == playerid)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot sell your voucher yourself");
        }
        if(!(1 <= price <= 10000000))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "You must specify a price greater than $1 or less than $10,000,000.");
        }
        if(PlayerInfo[playerid][pVIPVoucher][6] < amount)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much goldvip.");
		}

        PlayerInfo[targetid][pVoucherOffer] = playerid;
	    PlayerInfo[targetid][pVoucherType] = 10;
        PlayerInfo[targetid][pVoucherPrice] = price;
        PlayerInfo[targetid][pVoucherAmount] = amount;

        SendMessage(playerid, COLOR_LIGHTBLUE, "You have offered %s %d 1 Month GVIP Voucher(s) for $%s, please wait until he accept the offer.", GetRPName(targetid), amount, number_format(price));
        SendMessage(targetid, COLOR_LIGHTBLUE, "%s has offered to sell you %d 1 Month GVIP Voucher(s) for $%s - Type /acceptvoucher.", GetRPName(playerid), amount, number_format(price));
	}
    else if(!strcmp(option, "platinumvip", true))
	{
        if(sscanf(param, "ii", amount, price))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /sellvoucher [playerid] [platinumvip] [amount] [price]");
		}
        if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
        }
        if(targetid == playerid)
        {
            return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot sell your voucher yourself");
        }
        if(!(1 <= price <= 10000000))
        {
            return SendClientMessageEx(playerid, COLOR_SYNTAX, "You must specify a price greater than $1 or less than $10,000,000.");
        }
        if(PlayerInfo[playerid][pVIPVoucher][7] < amount)
		{
		    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have that much platinumvip.");
		}

        PlayerInfo[targetid][pVoucherOffer] = playerid;
	    PlayerInfo[targetid][pVoucherType] = 11;
        PlayerInfo[targetid][pVoucherPrice] = price;
        PlayerInfo[targetid][pVoucherAmount] = amount;

        SendMessage(playerid, COLOR_LIGHTBLUE, "You have offered %s %d 1 Month PVIP Voucher(s) for $%s, please wait until he accept the offer.", GetRPName(targetid), amount, number_format(price));
        SendMessage(targetid, COLOR_LIGHTBLUE, "%s has offered to sell you %d 1 Month PVIP Voucher(s) for $%s - Type /acceptvoucher.", GetRPName(playerid), amount, number_format(price));
	}
    return 1;
}

CMD:acceptvoucher(playerid, params[])
{   
    new szMessage[128],
        offeredby = PlayerInfo[playerid][pVoucherOffer],
        amount = PlayerInfo[playerid][pVoucherAmount],
        price = PlayerInfo[playerid][pVoucherPrice],
        type = PlayerInfo[playerid][pVoucherType];

    if(offeredby == INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You haven't received any invitations to a bank heist.");
    }
    if(!IsPlayerInRangeOfPlayer(playerid, offeredby, 5.0))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "The player who initiated the offer is out of range.");
    }

    switch(type)
    {
        case 1:
        {
            if(PlayerInfo[offeredby][pCarVoucher][0] < amount) 
            {
                return SendClientMessageEx(playerid, COLOR_SYNTAX, "The seller does not have that many anymore.");
            }

            format(szMessage, sizeof(szMessage), "* You have bought %d Car Voucher(s) for $%s from %s.", amount, number_format(price), GetRPName(offeredby));
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

            format(szMessage, sizeof(szMessage), "* %s has bought %d Car Voucher(s) from you, $%s was added to your money.", GetRPName(playerid), amount, number_format(price));
            SendClientMessageEx(offeredby, COLOR_LIGHTBLUE, szMessage);

            GivePlayerCash(offeredby, price);
            GivePlayerCash(playerid, -price);

            PlayerInfo[playerid][pCarVoucher][0] += amount;
            PlayerInfo[offeredby][pCarVoucher][0] -= amount;
        }
        case 2:
        {
            if(PlayerInfo[offeredby][pCarVoucher][1] < amount) 
            {
                return SendClientMessageEx(playerid, COLOR_SYNTAX, "The seller does not have that many anymore.");
            }

            format(szMessage, sizeof(szMessage), "* You have bought %d Rare Car Voucher(s) for $%s from %s.", amount, number_format(price), GetRPName(offeredby));
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

            format(szMessage, sizeof(szMessage), "* %s has bought %d Rare Car Voucher(s) from you, $%s was added to your money.", GetRPName(playerid), amount, number_format(price));
            SendClientMessageEx(offeredby, COLOR_LIGHTBLUE, szMessage);

            GivePlayerCash(offeredby, price);
            GivePlayerCash(playerid, -price);

            PlayerInfo[playerid][pCarVoucher][1] += amount;
            PlayerInfo[offeredby][pCarVoucher][1] -= amount;
        }
        case 3:
        {
            if(PlayerInfo[offeredby][pCarVoucher][2] < amount) 
            {
                return SendClientMessageEx(playerid, COLOR_SYNTAX, "The seller does not have that many anymore.");
            }

            format(szMessage, sizeof(szMessage), "* You have bought %d Restricted Car Voucher(s) for $%s from %s.", amount, number_format(price), GetRPName(offeredby));
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

            format(szMessage, sizeof(szMessage), "* %s has bought %d Restricted Car Voucher(s) from you, $%s was added to your money.", GetRPName(playerid), amount, number_format(price));
            SendClientMessageEx(offeredby, COLOR_LIGHTBLUE, szMessage);

            GivePlayerCash(offeredby, price);
            GivePlayerCash(playerid, -price);

            PlayerInfo[playerid][pCarVoucher][2] += amount;
            PlayerInfo[offeredby][pCarVoucher][2] -= amount;
        }
        case 4:
        {
            if(PlayerInfo[offeredby][pVIPVoucher][0] < amount) 
            {
                return SendClientMessageEx(playerid, COLOR_SYNTAX, "The seller does not have that many anymore.");
            }

            format(szMessage, sizeof(szMessage), "* You have bought %d 7Day BVIP Voucher(s) for $%s from %s.", amount, number_format(price), GetRPName(offeredby));
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

            format(szMessage, sizeof(szMessage), "* %s has bought %d 7Day BVIP Voucher(s) from you, $%s was added to your money.", GetRPName(playerid), amount, number_format(price));
            SendClientMessageEx(offeredby, COLOR_LIGHTBLUE, szMessage);

            GivePlayerCash(offeredby, price);
            GivePlayerCash(playerid, -price);

            PlayerInfo[playerid][pVIPVoucher][0] += amount;
            PlayerInfo[offeredby][pVIPVoucher][0] -= amount;
        }
        case 5:
        {
            if(PlayerInfo[offeredby][pVIPVoucher][1] < amount) 
            {
                return SendClientMessageEx(playerid, COLOR_SYNTAX, "The seller does not have that many anymore.");
            }

            format(szMessage, sizeof(szMessage), "* You have bought %d 7Day SVIP Voucher(s) for $%s from %s.", amount, number_format(price), GetRPName(offeredby));
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

            format(szMessage, sizeof(szMessage), "* %s has bought %d 7Day SVIP Voucher(s) from you, $%s was added to your money.", GetRPName(playerid), amount, number_format(price));
            SendClientMessageEx(offeredby, COLOR_LIGHTBLUE, szMessage);

            GivePlayerCash(offeredby, price);
            GivePlayerCash(playerid, -price);

            PlayerInfo[playerid][pVIPVoucher][1] += amount;
            PlayerInfo[offeredby][pVIPVoucher][1] -= amount;
        }
        case 6:
        {
            if(PlayerInfo[offeredby][pVIPVoucher][2] < amount) 
            {
                return SendClientMessageEx(playerid, COLOR_SYNTAX, "The seller does not have that many anymore.");
            }

            format(szMessage, sizeof(szMessage), "* You have bought %d 7Day GVIP Voucher(s) for $%s from %s.", amount, number_format(price), GetRPName(offeredby));
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

            format(szMessage, sizeof(szMessage), "* %s has bought %d 7Day GVIP Voucher(s) from you, $%s was added to your money.", GetRPName(playerid), amount, number_format(price));
            SendClientMessageEx(offeredby, COLOR_LIGHTBLUE, szMessage);

            GivePlayerCash(offeredby, price);
            GivePlayerCash(playerid, -price);

            PlayerInfo[playerid][pVIPVoucher][2] += amount;
            PlayerInfo[offeredby][pVIPVoucher][2] -= amount;
        }
        case 7:
        {
            if(PlayerInfo[offeredby][pVIPVoucher][3] < amount) 
            {
                return SendClientMessageEx(playerid, COLOR_SYNTAX, "The seller does not have that many anymore.");
            }

            format(szMessage, sizeof(szMessage), "* You have bought %d 7Day PVIP Voucher(s) for $%s from %s.", amount, number_format(price), GetRPName(offeredby));
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

            format(szMessage, sizeof(szMessage), "* %s has bought %d 7Day PVIP Voucher(s) from you, $%s was added to your money.", GetRPName(playerid), amount, number_format(price));
            SendClientMessageEx(offeredby, COLOR_LIGHTBLUE, szMessage);

            GivePlayerCash(offeredby, price);
            GivePlayerCash(playerid, -price);

            PlayerInfo[playerid][pVIPVoucher][3] += amount;
            PlayerInfo[offeredby][pVIPVoucher][3] -= amount;
        }
        case 8:
        {
            if(PlayerInfo[offeredby][pVIPVoucher][4] < amount) 
            {
                return SendClientMessageEx(playerid, COLOR_SYNTAX, "The seller does not have that many anymore.");
            }

            format(szMessage, sizeof(szMessage), "* You have bought %d 1 Month BVIP Voucher(s) for $%s from %s.", amount, number_format(price), GetRPName(offeredby));
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

            format(szMessage, sizeof(szMessage), "* %s has bought %d 1 Month BVIP Voucher(s) from you, $%s was added to your money.", GetRPName(playerid), amount, number_format(price));
            SendClientMessageEx(offeredby, COLOR_LIGHTBLUE, szMessage);

            GivePlayerCash(offeredby, price);
            GivePlayerCash(playerid, -price);

            PlayerInfo[playerid][pVIPVoucher][4] += amount;
            PlayerInfo[offeredby][pVIPVoucher][4] -= amount;
        }
        case 9:
        {
            if(PlayerInfo[offeredby][pVIPVoucher][5] < amount) 
            {
                return SendClientMessageEx(playerid, COLOR_SYNTAX, "The seller does not have that many anymore.");
            }

            format(szMessage, sizeof(szMessage), "* You have bought %d 1 Month SVIP Voucher(s) for $%s from %s.", amount, number_format(price), GetRPName(offeredby));
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

            format(szMessage, sizeof(szMessage), "* %s has bought %d 1 Month SVIP Voucher(s) from you, $%s was added to your money.", GetRPName(playerid), amount, number_format(price));
            SendClientMessageEx(offeredby, COLOR_LIGHTBLUE, szMessage);

            GivePlayerCash(offeredby, price);
            GivePlayerCash(playerid, -price);

            PlayerInfo[playerid][pVIPVoucher][5] += amount;
            PlayerInfo[offeredby][pVIPVoucher][5] -= amount;
        }
        case 10:
        {
            if(PlayerInfo[offeredby][pVIPVoucher][6] < amount) 
            {
                return SendClientMessageEx(playerid, COLOR_SYNTAX, "The seller does not have that many anymore.");
            }

            format(szMessage, sizeof(szMessage), "* You have bought %d 1 Month GVIP Voucher(s) for $%s from %s.", amount, number_format(price), GetRPName(offeredby));
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

            format(szMessage, sizeof(szMessage), "* %s has bought %d 1 Month GVIP Voucher(s) from you, $%s was added to your money.", GetRPName(playerid), amount, number_format(price));
            SendClientMessageEx(offeredby, COLOR_LIGHTBLUE, szMessage);

            GivePlayerCash(offeredby, price);
            GivePlayerCash(playerid, -price);

            PlayerInfo[playerid][pVIPVoucher][6] += amount;
            PlayerInfo[offeredby][pVIPVoucher][6] -= amount;
        }
        case 11:
        {
            if(PlayerInfo[offeredby][pVIPVoucher][7] < amount) 
            {
                return SendClientMessageEx(playerid, COLOR_SYNTAX, "The seller does not have that many anymore.");
            }

            format(szMessage, sizeof(szMessage), "* You have bought %d 1 Month PVIP Voucher(s) for $%s from %s.", amount, number_format(price), GetRPName(offeredby));
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

            format(szMessage, sizeof(szMessage), "* %s has bought %d 1 Month PVIP Voucher(s) from you, $%s was added to your money.", GetRPName(playerid), amount, number_format(price));
            SendClientMessageEx(offeredby, COLOR_LIGHTBLUE, szMessage);

            GivePlayerCash(offeredby, price);
            GivePlayerCash(playerid, -price);

            PlayerInfo[playerid][pVIPVoucher][7] += amount;
            PlayerInfo[offeredby][pVIPVoucher][7] -= amount;
        }
    }
    PlayerInfo[playerid][pVoucherOffer] = INVALID_PLAYER_ID;
    return 1;
}

new const RestrictedVehicleVoucher[] = {
    431, 437, 438, 420, 416, 433, 427, 490,
    528, 407, 544, 523, 470, 596, 598, 599,
    597, 601, 428, 568, 556, 557, 471, 495, 
    548, 425, 488, 497, 563, 447, 469
};

new const RareVehicleVoucher[] = {
    536, 575, 534, 567, 535, 576, 412, 562,
    565, 411, 559, 561, 560, 506, 451, 558,
    555, 
};

new const VehicleVoucher[] = {
	602, 496, 401, 518, 527, 589, 419, 587,
    533, 526, 474, 545, 517, 410, 600, 436,
    439, 549, 491, 445, 604, 507, 585, 466,
    492, 546, 551, 516, 467, 426, 547, 405,
    580, 409, 550, 566, 540, 421, 529, 542,
    579, 400, 404, 489, 505, 479, 442, 458,
    581, 509, 481, 462, 521, 463, 510, 461,
    466, 586, 475, 402, 603, 429, 541, 415,
    480, 477
};

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_VOUCHER:
        {
            if(response) 
			{
				switch(listitem) 
				{
                    case 0:
                    {
                        SetPVarInt(playerid, "voucherdialog", 1);
                        return ShowPlayerDialog(playerid, DIALOG_CAR_VOUCHER, DIALOG_STYLE_MSGBOX, "Car Voucher System", "Are you sure you want to use your car voucher?", "Yes", "Return");
                    }
                    case 1:
                    {
                        SetPVarInt(playerid, "voucherdialog", 2);
                        return ShowPlayerDialog(playerid, DIALOG_CAR_VOUCHER, DIALOG_STYLE_MSGBOX, "Rare Car Voucher System", "Are you sure you want to use your rare car voucher?", "Yes", "Return");
                    }
                    case 2:
                    {
                        SetPVarInt(playerid, "voucherdialog", 3);
                        return ShowPlayerDialog(playerid, DIALOG_CAR_VOUCHER, DIALOG_STYLE_MSGBOX, "Restricted Car Voucher System", "Are you sure you want to use your restricted car voucher?", "Yes", "Return");
                    }
                    case 3:
                    {
                        SetPVarInt(playerid, "voucherdialog", 4);
                        return ShowPlayerDialog(playerid, DIALOG_NEXT_VOUCHER, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 7 Days BVIP Voucher?", "Yes", "Return");
                    }
                    case 4:
                    {
                        SetPVarInt(playerid, "voucherdialog", 5);
                        return ShowPlayerDialog(playerid, DIALOG_NEXT_VOUCHER, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 7 Days SVIP Voucher?", "Yes", "Return");
                    }
                    case 5:
                    {
                        SetPVarInt(playerid, "voucherdialog", 6);
                        return ShowPlayerDialog(playerid, DIALOG_NEXT_VOUCHER, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 7 Days GVIP Voucher?", "Yes", "Return");
                    }
                    case 6:
                    {
                        SetPVarInt(playerid, "voucherdialog", 7);
                        return ShowPlayerDialog(playerid, DIALOG_NEXT_VOUCHER, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 7 Days PVIP Voucher?", "Yes", "Return");
                    }
                    case 7:
                    {
                        SetPVarInt(playerid, "voucherdialog", 8);
                        return ShowPlayerDialog(playerid, DIALOG_NEXT_VOUCHER, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 1 Month BVIP Voucher?", "Yes", "Return");
                    }
                    case 8:
                    {
                        SetPVarInt(playerid, "voucherdialog", 9);
                        return ShowPlayerDialog(playerid, DIALOG_NEXT_VOUCHER, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 1 Month SVIP Voucher?", "Yes", "Return");
                    }
                    case 9:
                    {
                        SetPVarInt(playerid, "voucherdialog", 10);
                        return ShowPlayerDialog(playerid, DIALOG_NEXT_VOUCHER, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 1 Month GVIP Voucher?", "Yes", "Return");
                    }
                    case 10:
                    {
                        SetPVarInt(playerid, "voucherdialog", 11);
                        return ShowPlayerDialog(playerid, DIALOG_NEXT_VOUCHER, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 1 Month PVIP Voucher?", "Yes", "Return");
                    }
                }
            }        
        }
        case DIALOG_CAR_VOUCHER:
        {
            if(response)
            {
                if(GetPVarInt(playerid, "voucherdialog") == 1)
                {
                    if(PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pCuffed] > 0)
                    {
                        DeletePVar(playerid, "voucherdialog");
                    }
                    if(GetPlayerInterior(playerid) != 0)
                    {
                        DeletePVar(playerid, "voucherdialog");
                        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this while being inside an interior.");
                    }
                    else
                    {
                        ShowPlayerSelectionMenu(playerid, MODEL_SELECTION_VEH, "Car Voucher Selection", VehicleVoucher, sizeof(VehicleVoucher));
                    }
                }
                if(GetPVarInt(playerid, "voucherdialog") == 2)
                {
                    if(PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pCuffed] > 0)
                    {
                        DeletePVar(playerid, "voucherdialog");
                    }
                    if(GetPlayerInterior(playerid) != 0)
                    {
                        DeletePVar(playerid, "voucherdialog");
                        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this while being inside an interior.");
                    }
                    else
                    {
                        ShowPlayerSelectionMenu(playerid, MODEL_SELECTION_RARE_VEH, "Rare Car Voucher Selection", RareVehicleVoucher, sizeof(RareVehicleVoucher));
                    }
                }
                if(GetPVarInt(playerid, "voucherdialog") == 3)
                {
                    if(PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pCuffed] > 0)
                    {
                        DeletePVar(playerid, "voucherdialog");
                    }
                    if(GetPlayerInterior(playerid) != 0)
                    {
                        DeletePVar(playerid, "voucherdialog");
                        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this while being inside an interior.");
                    }
                    else
                    {
                        ShowPlayerSelectionMenu(playerid, MODEL_SELECTION_RESTRICTED_VEH, "Restricted Car Voucher Selection", RestrictedVehicleVoucher, sizeof(RestrictedVehicleVoucher));
                    }
                }
            }
        }
        case DIALOG_NEXT_VOUCHER:
		{
            if(!response) ShowPlayerVoucher(playerid, playerid);
			if(response)
			{
                if(GetPVarInt(playerid, "voucherdialog") == 4) // 7 Days BVIP
                {
                    if(PlayerInfo[playerid][pVIPVoucher][0]<= 0) return DeletePVar(playerid, "voucherdialog"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7D BVIP Voucher.");
                    
                    PlayerInfo[playerid][pVIPVoucher][0]--;
                    PlayerInfo[playerid][pVIPPackage] = 1;
                    PlayerInfo[playerid][pVIPTime] = gettime() + 604800;

                    SendMessage(playerid, COLOR_YELLOW, "You have successfully used one of your 7D BVIP voucher(s), you have %d 7D BVIP voucher(s) left.", PlayerInfo[playerid][pVIPVoucher][0]);
					SendClientMessage(playerid, COLOR_GREY, "** Note: Your Bronze VIP will expire in 7 days.");

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_0 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][0], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                }
                if(GetPVarInt(playerid, "voucherdialog") == 5) // 7 Days SVIP
                {
                    if(PlayerInfo[playerid][pVIPVoucher][1]<= 0) return DeletePVar(playerid, "voucherdialog"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7D SVIP Voucher.");
                    
                    PlayerInfo[playerid][pVIPVoucher][1]--;
                    PlayerInfo[playerid][pVIPPackage] = 2;
                    PlayerInfo[playerid][pVIPTime] = gettime() + 604800;

                    SendMessage(playerid, COLOR_YELLOW, "You have successfully used one of your 7D SVIP voucher(s), you have %d 7D SVIP voucher(s) left.", PlayerInfo[playerid][pVIPVoucher][1]);
					SendClientMessage(playerid, COLOR_GREY, "** Note: Your Silver VIP will expire in 7 days.");

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_1 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][1], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                }
                if(GetPVarInt(playerid, "voucherdialog") == 6) // 7 Days GVIP
                {
                    if(PlayerInfo[playerid][pVIPVoucher][2]<= 0) return DeletePVar(playerid, "voucherdialog"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7D GVIP Voucher.");
                    
                    PlayerInfo[playerid][pVIPVoucher][2]--;
                    PlayerInfo[playerid][pVIPPackage] = 3;
                    PlayerInfo[playerid][pVIPTime] = gettime() + 604800;

                    SendMessage(playerid, COLOR_YELLOW, "You have successfully used one of your 7D GVIP voucher(s), you have %d 7D GVIP voucher(s) left.", PlayerInfo[playerid][pVIPVoucher][2]);
					SendClientMessage(playerid, COLOR_GREY, "** Note: Your Gold VIP will expire in 7 days.");

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_2 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][2], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                }
                if(GetPVarInt(playerid, "voucherdialog") == 7) // 7 Days PVIP
                {
                    if(PlayerInfo[playerid][pVIPVoucher][3]<= 0) return DeletePVar(playerid, "voucherdialog"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7D GVIP Voucher.");
                    
                    PlayerInfo[playerid][pVIPVoucher][3]--;
                    PlayerInfo[playerid][pVIPPackage] = 4;
                    PlayerInfo[playerid][pVIPTime] = gettime() + 604800;

                    SendMessage(playerid, COLOR_YELLOW, "You have successfully used one of your 7D PVIP voucher(s), you have %d 7D PVIP voucher(s) left.", PlayerInfo[playerid][pVIPVoucher][3]);
					SendClientMessage(playerid, COLOR_GREY, "** Note: Your Platinum VIP will expire in 7 days.");

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_3 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][3], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                }
                if(GetPVarInt(playerid, "voucherdialog") == 8) // 1 Month BVIP
                {
                    if(PlayerInfo[playerid][pVIPVoucher][4]<= 0) return DeletePVar(playerid, "voucherdialog"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7 Month BVIP Voucher.");
                    
                    PlayerInfo[playerid][pVIPVoucher][4]--;
                    PlayerInfo[playerid][pVIPPackage] = 1;
                    PlayerInfo[playerid][pVIPTime] = gettime() + 2592000;

                    SendMessage(playerid, COLOR_YELLOW, "You have successfully used one of your 1 Month BVIP voucher(s), you have %d 1 Month BVIP voucher(s) left.", PlayerInfo[playerid][pVIPVoucher][4]);
					SendClientMessage(playerid, COLOR_GREY, "** Note: Your Bronze VIP will expire in 1 Month.");

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_4 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][4], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                }
                if(GetPVarInt(playerid, "voucherdialog") == 9) // 1 Month SVIP
                {
                    if(PlayerInfo[playerid][pVIPVoucher][5]<= 0) return DeletePVar(playerid, "voucherdialog"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7 Month SVIP Voucher.");
                    
                    PlayerInfo[playerid][pVIPVoucher][5]--;
                    PlayerInfo[playerid][pVIPPackage] = 2;
                    PlayerInfo[playerid][pVIPTime] = gettime() + 2592000;

                    SendMessage(playerid, COLOR_YELLOW, "You have successfully used one of your 1 Month SVIP voucher(s), you have %d 1 Month SVIP voucher(s) left.", PlayerInfo[playerid][pVIPVoucher][5]);
					SendClientMessage(playerid, COLOR_GREY, "** Note: Your Silver VIP will expire in 1 Month.");

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_5 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][5], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                }
                if(GetPVarInt(playerid, "voucherdialog") == 10) // 1 Month GVIP
                {
                    if(PlayerInfo[playerid][pVIPVoucher][6]<= 0) return DeletePVar(playerid, "voucherdialog"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7 Month GVIP Voucher.");
                    
                    PlayerInfo[playerid][pVIPVoucher][6]--;
                    PlayerInfo[playerid][pVIPPackage] = 3;
                    PlayerInfo[playerid][pVIPTime] = gettime() + 2592000;

                    SendMessage(playerid, COLOR_YELLOW, "You have successfully used one of your 1 Month voucher(s), you have %d 1 Month voucher(s) left.", PlayerInfo[playerid][pVIPVoucher][6]);
					SendClientMessage(playerid, COLOR_GREY, "** Note: Your Gold VIP will expire in 1 Month.");

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_6 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][6], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                }
                if(GetPVarInt(playerid, "voucherdialog") == 11) // 1 Month PVIP
                {
                    if(PlayerInfo[playerid][pVIPVoucher][7]<= 0) return DeletePVar(playerid, "voucherdialog"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7 Month GVIP Voucher.");
                    
                    PlayerInfo[playerid][pVIPVoucher][7]--;
                    PlayerInfo[playerid][pVIPPackage] = 4;
                    PlayerInfo[playerid][pVIPTime] = gettime() + 2592000;

                    SendMessage(playerid, COLOR_YELLOW, "You have successfully used one of your 1 Month voucher(s), you have %d 1 Month voucher(s) left.", PlayerInfo[playerid][pVIPVoucher][7]);
					SendClientMessage(playerid, COLOR_GREY, "** Note: Your Platinum VIP will expire in 1 Month.");

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_7 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][7], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                }
            }
        }
    }
    return 1;
}