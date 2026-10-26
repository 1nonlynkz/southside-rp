#include <YSI_Coding\y_hooks>

new PlayerText:NoticeTD[MAX_PLAYERS][6];

CMD:whitelist(playerid, params[])
{
    new username[MAX_PLAYER_NAME];

    if(PlayerInfo[playerid][pAdmin] < 4)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
    }
    if(sscanf(params, "s[24]", username))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /whitelist [username]");
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT locked FROM users WHERE username = '%e'", username);
    mysql_tquery(connectionID, queryBuffer, "OnAdminUnlockAccount", "is", playerid, username);
    return 1;
}

CMD:blacklist(playerid, params[])
{
    new username[MAX_PLAYER_NAME];

    if(PlayerInfo[playerid][pAdmin] < 4)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
    }
    if(sscanf(params, "s[24]", username))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /blacklist [username]");
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT uid FROM users WHERE username = '%e' AND locked = 1", username);
    mysql_tquery(connectionID, queryBuffer, "OnAdminLockAccount", "is", playerid, username);
    return 1;
}


forward OnAdminLockAccount(playerid, username[]);
public OnAdminLockAccount(playerid, username[])
{
	if(!cache_get_row_count(connectionID))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The player specified doesn't exist, or their account is not locked.");
	}
	else
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET locked = 0 WHERE username = '%e'", username);
	    mysql_tquery(connectionID, queryBuffer);

	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has unwhitelist %s's account.", GetRPName(playerid), username);
	    Log_Write("log_admin", "%s (uid: %i) unwhitelist %s's account.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], username);
	}
}

forward OnAdminUnlockAccount(playerid, username[]);
public OnAdminUnlockAccount(playerid, username[])
{
 	if(!cache_get_row_count(connectionID))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "The player specified doesn't exist.");
	}
	else
	{
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET locked = 1 WHERE username = '%e'", username);
	    mysql_tquery(connectionID, queryBuffer);

	    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has whitelist %s's account.", GetRPName(playerid), username);
	    Log_Write("log_admin", "%s (uid: %i) whitelist %s's account.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], username);
	}
}

hook OnPlayerConnect(playerid)
{
    new namestring[1028], datestring[1028];
    format(namestring, sizeof(namestring), "%s", GetPlayerNameEx(playerid));
    format(datestring, sizeof(datestring), "%s", ReturnDate());

    NoticeTD[playerid][0] = CreatePlayerTextDraw(playerid, 327.000000, 169.000000, "_");
    PlayerTextDrawFont(playerid, NoticeTD[playerid][0], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, NoticeTD[playerid][0], 0.483333, 14.400018);
    PlayerTextDrawTextSize(playerid, NoticeTD[playerid][0], 298.500000, 254.500000);
    PlayerTextDrawSetOutline(playerid, NoticeTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, NoticeTD[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, NoticeTD[playerid][0], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, NoticeTD[playerid][0], -1);
    PlayerTextDrawBackgroundColour(playerid, NoticeTD[playerid][0], 255);
    PlayerTextDrawBoxColour(playerid, NoticeTD[playerid][0], 135);
    PlayerTextDrawUseBox(playerid, NoticeTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, NoticeTD[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, NoticeTD[playerid][0], 0);

    NoticeTD[playerid][1] = CreatePlayerTextDraw(playerid, 329.000000, 174.000000, "Notice!!!");
    PlayerTextDrawFont(playerid, NoticeTD[playerid][1], TEXT_DRAW_FONT:2);
    PlayerTextDrawLetterSize(playerid, NoticeTD[playerid][1], 0.250000, 1.700000);
    PlayerTextDrawTextSize(playerid, NoticeTD[playerid][1], 400.000000, 230.500000);
    PlayerTextDrawSetOutline(playerid, NoticeTD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, NoticeTD[playerid][1], 0);
    PlayerTextDrawAlignment(playerid, NoticeTD[playerid][1], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, NoticeTD[playerid][1], -1);
    PlayerTextDrawBackgroundColour(playerid, NoticeTD[playerid][1], 255);
    PlayerTextDrawBoxColour(playerid, NoticeTD[playerid][1], 50);
    PlayerTextDrawUseBox(playerid, NoticeTD[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, NoticeTD[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, NoticeTD[playerid][1], 0);

    NoticeTD[playerid][2] = CreatePlayerTextDraw(playerid, 326.000000, 211.000000, "Your account is not whitelisted on our discord server");
    PlayerTextDrawFont(playerid, NoticeTD[playerid][2], TEXT_DRAW_FONT:2);
    PlayerTextDrawLetterSize(playerid, NoticeTD[playerid][2], 0.141667, 0.950000);
    PlayerTextDrawTextSize(playerid, NoticeTD[playerid][2], 400.000000, 230.500000);
    PlayerTextDrawSetOutline(playerid, NoticeTD[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, NoticeTD[playerid][2], 0);
    PlayerTextDrawAlignment(playerid, NoticeTD[playerid][2], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, NoticeTD[playerid][2], -1);
    PlayerTextDrawBackgroundColour(playerid, NoticeTD[playerid][2], 255);
    PlayerTextDrawBoxColour(playerid, NoticeTD[playerid][2], 50);
    PlayerTextDrawUseBox(playerid, NoticeTD[playerid][2], 0);
    PlayerTextDrawSetProportional(playerid, NoticeTD[playerid][2], 1);
    PlayerTextDrawSetSelectable(playerid, NoticeTD[playerid][2], 0);

    NoticeTD[playerid][3] = CreatePlayerTextDraw(playerid, 330.000000, 225.000000, "You can screenshot this message, and submit it to discord and create a form for whitelisting your account");
    PlayerTextDrawFont(playerid, NoticeTD[playerid][3], TEXT_DRAW_FONT:2);
    PlayerTextDrawLetterSize(playerid, NoticeTD[playerid][3], 0.141667, 0.950000);
    PlayerTextDrawTextSize(playerid, NoticeTD[playerid][3], 400.000000, 230.500000);
    PlayerTextDrawSetOutline(playerid, NoticeTD[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, NoticeTD[playerid][3], 0);
    PlayerTextDrawAlignment(playerid, NoticeTD[playerid][3], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, NoticeTD[playerid][3], -1);
    PlayerTextDrawBackgroundColour(playerid, NoticeTD[playerid][3], 255);
    PlayerTextDrawBoxColour(playerid, NoticeTD[playerid][3], 50);
    PlayerTextDrawUseBox(playerid, NoticeTD[playerid][3], 0);
    PlayerTextDrawSetProportional(playerid, NoticeTD[playerid][3], 1);
    PlayerTextDrawSetSelectable(playerid, NoticeTD[playerid][3], 0);

    NoticeTD[playerid][4] = CreatePlayerTextDraw(playerid, 326.000000, 260.000000, namestring);
    PlayerTextDrawFont(playerid, NoticeTD[playerid][4], TEXT_DRAW_FONT:2);
    PlayerTextDrawLetterSize(playerid, NoticeTD[playerid][4], 0.141667, 0.950000);
    PlayerTextDrawTextSize(playerid, NoticeTD[playerid][4], 400.000000, 230.500000);
    PlayerTextDrawSetOutline(playerid, NoticeTD[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, NoticeTD[playerid][4], 0);
    PlayerTextDrawAlignment(playerid, NoticeTD[playerid][4], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, NoticeTD[playerid][4], -1);
    PlayerTextDrawBackgroundColour(playerid, NoticeTD[playerid][4], 255);
    PlayerTextDrawBoxColour(playerid, NoticeTD[playerid][4], 50);
    PlayerTextDrawUseBox(playerid, NoticeTD[playerid][4], 0);
    PlayerTextDrawSetProportional(playerid, NoticeTD[playerid][4], 1);
    PlayerTextDrawSetSelectable(playerid, NoticeTD[playerid][4], 0);

    NoticeTD[playerid][5] = CreatePlayerTextDraw(playerid, 326.000000, 271.000000, datestring);
    PlayerTextDrawFont(playerid, NoticeTD[playerid][5], TEXT_DRAW_FONT:2);
    PlayerTextDrawLetterSize(playerid, NoticeTD[playerid][5], 0.141667, 0.950000);
    PlayerTextDrawTextSize(playerid, NoticeTD[playerid][5], 400.000000, 230.500000);
    PlayerTextDrawSetOutline(playerid, NoticeTD[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, NoticeTD[playerid][5], 0);
    PlayerTextDrawAlignment(playerid, NoticeTD[playerid][5], TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColour(playerid, NoticeTD[playerid][5], -1);
    PlayerTextDrawBackgroundColour(playerid, NoticeTD[playerid][5], 255);
    PlayerTextDrawBoxColour(playerid, NoticeTD[playerid][5], 50);
    PlayerTextDrawUseBox(playerid, NoticeTD[playerid][5], 0);
    PlayerTextDrawSetProportional(playerid, NoticeTD[playerid][5], 1);
    PlayerTextDrawSetSelectable(playerid, NoticeTD[playerid][5], 0);
    return 1;
}


