CMD:donatorhelp(playerid) return callcmd::viphelp(playerid);
CMD:viphelp(playerid)
{
	if(!PlayerInfo[playerid][pVIPPackage])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you don't have a donator subscription.");
	}
	SendClientMessage(playerid, COLOR_VIP, "** Donator: /(v)ip, /vipinfo, /vipinvite, /vipnumber");
	SendClientMessage(playerid, COLOR_VIP, "** Donator: /sellgun, /vcode, /vipmenu(soon)");
	return 1;
}

CMD:viplocker(playerid, params[]) return callcmd::donatorlocker(playerid, params);
CMD:donatorlocker(playerid, params[])
{
	if(PlayerInfo[playerid][pWeaponRestricted] > 0)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are either weapon restricted or you played less than two playing hours.");
    }
    if(!PlayerInfo[playerid][pVIPPackage])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you don't have a VIP subscription.");
	}
    if(IsPlayerInRangeOfPoint(playerid, 5.0, 2556.2119, 1403.9261, 7699.5844))
    {
		ShowPlayerDialog(playerid, DIALOG_VIPLOCKER, DIALOG_STYLE_LIST, "Vip Lounge", "Firstaid\nKevlar Vest\nWeapons (Legendary VIP Only)", "Ok", "");
	}
    else 
	{
		return SendClientMessage(playerid, COLOR_WHITE, "You're not in the VIP Lounge.");
	}
    return 1;
}

CMD:v(playerid, params[])
{
	return callcmd::vip(playerid, params);
}

CMD:vip(playerid, params[])
{
	if(!PlayerInfo[playerid][pVIPPackage])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you don't have a VIP subscription.");
	}
	if(!enabledVip)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The VIP Chat is disabled by an administrator.");
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /(v)ip [vip chat]");
	}
    if(PlayerInfo[playerid][pToggleVIP])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't speak in the VIP chat as you have it toggled.");
	}

	foreach(new i : Player)
	{
	    if(PlayerInfo[i][pVIPPackage] > 0 && !PlayerInfo[i][pToggleVIP])
	    {
			SendMessage(i, COLOR_VIP, "** %s %s: %s **", GetDonatorRank(PlayerInfo[playerid][pVIPPackage]), GetRPName(playerid), params);
		}
	}

	return 1;
}

CMD:loyalbadge(playerid, params[])
{
	if(PlayerInfo[playerid][pHours] < 50)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot have this loyal badge as you didn't play atleast 50 hours yet.");
	}
	else
	{
	    PlayerInfo[playerid][pCustomTColor] = 0xAFAFAFFF;
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET customcolor = %i, customtitle = 'NW Loyal' WHERE uid = %i", PlayerInfo[playerid][pCustomTColor], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
        SendClientMessage(playerid, SERVER_COLOR, "NOTE:"WHITE" You got kicked to apply the changes with your badge, Please Reconnect...");
		KickPlayer(playerid);
	}
	return 1;
 }
 
 CMD:vipcolor(playerid, params[])
{
    if(!PlayerInfo[playerid][pVIPPackage])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you don't have a VIP subscription.");
	}

	if(!PlayerInfo[playerid][pVIPColor])
	{
        PlayerInfo[playerid][pVIPColor] = 1;
	    SendClientMessage(playerid, COLOR_WHITE, "** You have enabled the VIP nametag.");
	}
	else
	{

	    PlayerInfo[playerid][pVIPColor] = 0;
	    SendClientMessage(playerid, COLOR_WHITE, "** You have disabled the VIP nametag.");
	}

	return 1;
}

CMD:vipinvite(playerid, params[])
{
	new targetid;

	if(!PlayerInfo[playerid][pVIPPackage])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you don't have a VIP subscription.");
	}
	if((PlayerInfo[playerid][pVIPTime] - gettime()) < 259200)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Your VIP subscription expires in less than 3 days. You can't do this now.");
	}

	if(sscanf(params, "u", targetid))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vipinvite [playerid]");
	    SendClientMessage(playerid, COLOR_WHITE, "This command grants a temporary VIP subscription which lasts one hour to a player of your choice.");

	    if(PlayerInfo[playerid][pVIPCooldown] > gettime()) {
			SendMessage(playerid, COLOR_WHITE, "You can only use this command once every 24 hours. You have %i hours left until you can use it again.", (PlayerInfo[playerid][pVIPCooldown] - gettime()) / 3600);
		} else {
		    SendClientMessage(playerid, COLOR_WHITE, "You can only use this command once every 24 hours. You currently have no cooldown for this command.");
		}

		return 1;
	}
	if(PlayerInfo[playerid][pVIPCooldown] > gettime())
	{
	    return SendMessage(playerid, COLOR_SYNTAX, "You have already used this command today. Please wait another %i hours.", (PlayerInfo[playerid][pVIPCooldown] - gettime()) / 3600);
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
	if(PlayerInfo[targetid][pVIPPackage])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player already has a VIP subscription.");
	}

	PlayerInfo[targetid][pVIPPackage] = 1;
	PlayerInfo[targetid][pVIPTime] = gettime() + 3600;
	PlayerInfo[playerid][pVIPCooldown] = gettime() + 86400;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = 1, viptime = 3600 WHERE uid = %i", PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipcooldown = %i WHERE uid = %i", PlayerInfo[playerid][pVIPCooldown], PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	SendMessage(targetid, COLOR_WHITE, "** %s has given you a temporary one hour donator package.", GetRPName(playerid));
	SendMessage(playerid, COLOR_WHITE, "** You have given %s a temporary one hour donator package.", GetRPName(targetid));

	Log_Write("log_vip", "%s Donator %s (uid: %i) has given %s (uid: %i) a temporary one hour package.", GetDonatorRank(PlayerInfo[playerid][pVIPPackage]), GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID]);
	return 1;
}

CMD:vipinfo(playerid, params[])
{
	new time = PlayerInfo[playerid][pVIPTime] - gettime(), cooldown[24] = "{33CC33}No cooldown", string[32];

	if(!PlayerInfo[playerid][pVIPPackage])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you don't have a VIP subscription.");
	}

	SendClientMessage(playerid, COLOR_LIGHTORANGE, "My Package:");

	if(1 <= time <= 3599)
	{
		format(string, sizeof(string), "{AA3333}%i minutes", time / 60);
	}
	else if(3600 <= time <= 86399)
	{
	    format(string, sizeof(string), ""SVRCLR"%i hours", time / 3600);
	}
	else
	{
	    if(time / 86400 <= 7)
		{
	        format(string, sizeof(string), "{FFD700}%i days", time / 86400);
	    }
		else
		{
		    format(string, sizeof(string), "{33CC33}%i days", time / 86400);
		}
	}

	if(PlayerInfo[playerid][pVIPCooldown] > gettime())
	{
	    time = PlayerInfo[playerid][pVIPCooldown] - gettime();

	    if(time > 3600) {
	        format(cooldown, sizeof(cooldown), "{F7A763}%i hours", time / 3600);
		} else {
			format(cooldown, sizeof(cooldown), "{F7A763}%i minutes", time / 60);
	    }
	}

	SendMessage(playerid, COLOR_WHITE, "Package: {C2A2DA}%s Donator", GetDonatorRank(PlayerInfo[playerid][pVIPPackage]));
	SendMessage(playerid, COLOR_WHITE, "Expires In: %s", string);
	SendMessage(playerid, COLOR_WHITE, "Next Invite: %s", cooldown);
	return 1;
}
CMD:vipnumber(playerid, params[])
{
	new number;

	if(!PlayerInfo[playerid][pVIPPackage])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you don't have a VIP subscription.");
	}
	if(sscanf(params, "i", number))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vipnumber [phone number]");
	    SendClientMessage(playerid, COLOR_WHITE, "This command costs $100,000 and changes your phone number to your chosen one.");
	    return 1;
	}
	if(PlayerInfo[playerid][pCash] < 100000)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You need at least $100,000 for pay for this.");
	}
	if(number == 0 || number == 911 || number == 6397 || number == 6324 || number == 8294)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid number.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM users WHERE phone = %i", number);
	mysql_tquery(connectionID, queryBuffer, "OnPlayerBuyPhoneNumber", "ii", playerid, number);
	return 1;
}
CMD:vcode(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!PlayerInfo[playerid][pVIPPackage])
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you don't have a VIP subscription.");
	}
	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
	}
	if(isnull(params) || strlen(params) > 64)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vcode [text ('none' to reset)]");
	}

	if(IsValidDynamic3DTextLabel(DonatorCallSign[vehicleid]))
	{
	    DestroyDynamic3DTextLabel(DonatorCallSign[vehicleid]);
		DonatorCallSign[vehicleid] = Text3D:INVALID_3DTEXT_ID;

		if(!strcmp(params, "none", true))
		{
			SendClientMessage(playerid, COLOR_WHITE, "** Car text removed from the vehicle.");
		}
	}

	if(strcmp(params, "none", true) != 0)
	{
		DonatorCallSign[vehicleid] = CreateDynamic3DTextLabel(params, COLOR_VIP, 0.0, -3.0, 0.0, 10.0, .attachedvehicle = vehicleid);
 		SendClientMessage(playerid, COLOR_WHITE, "** Car text attached. '/vcode none' to detach the Car text.");
	}

	return 1;
}