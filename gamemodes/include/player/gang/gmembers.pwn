/*
    ============================================================================
    Southside Roleplay - Gang Members System
    ============================================================================
    Author: Spynixx, Niks, Charles
    Description: Gang Members System
    ============================================================================
*/

enum E_GANG_MEMBER_DATA
{
	gmUID,
	gmName[MAX_PLAYER_NAME],
	gmRank,
	gmLastLogin,
	gmTargetID
};
new GangMemberList[MAX_PLAYERS][100][E_GANG_MEMBER_DATA];

forward OnLoadGangMembersDialog(playerid);

stock ShowGangMembersDialog(playerid)
{
	new gangid = PlayerInfo[playerid][pGang];
	if(gangid == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not apart of a gang at the moment.");
	}

	new query[256];
	mysql_format(connectionID, query, sizeof(query), "SELECT uid, username, gangrank, UNIX_TIMESTAMP(lastlogin) AS lastlogin_ts FROM users WHERE gang = %d ORDER BY gangrank DESC, lastlogin DESC", gangid);
	mysql_tquery(connectionID, query, "OnLoadGangMembersDialog", "i", playerid);
	return 1;
}

public OnLoadGangMembersDialog(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;

	new gangid = PlayerInfo[playerid][pGang];
	if(gangid == -1) return 1;

	new rows = cache_num_rows();
	new totalPages = (rows > 0) ? ((rows + 3 + 9) / 10) : 1;
	new caption[64];
	if (totalPages > 1)
	{
		format(caption, sizeof(caption), "Members (%d) | Page 1/%d", rows, totalPages);
	}
	else
	{
		format(caption, sizeof(caption), "Members (%d)", rows);
	}

	AddDialogListitem(playerid, "Status\tUsername\tRank\tLocation");
	AddDialogListitem(playerid, "{FF0000}Filter: None\t\t\t");
	AddDialogListitem(playerid, "{FFFF00}Sort: Online\t\t\t");
	new memberHeader[64];
	format(memberHeader, sizeof(memberHeader), "{00FFFF}-- Members (%d) --\t\t\t", rows);
	AddDialogListitem(playerid, memberHeader);

	if(rows == 0)
	{
		AddDialogListitem(playerid, "{AFAFAF}No members match the current filter.\t\t\t");
	}
	else
	{
		for(new i = 0; i < rows && i < 100; i++)
		{
			new username[MAX_PLAYER_NAME], grank, lastlogin_ts, uid;
			uid = cache_get_field_content_int(i, "uid");
			cache_get_field_content(i, "username", username);
			grank = cache_get_field_content_int(i, "gangrank");
			lastlogin_ts = cache_get_field_content_int(i, "lastlogin_ts");

			new targetid = INVALID_PLAYER_ID;
			new isOnline = IsPlayerOnline(username, targetid);

			GangMemberList[playerid][i][gmUID] = uid;
			format(GangMemberList[playerid][i][gmName], MAX_PLAYER_NAME, "%s", username);
			GangMemberList[playerid][i][gmRank] = grank;
			GangMemberList[playerid][i][gmLastLogin] = lastlogin_ts;
			GangMemberList[playerid][i][gmTargetID] = isOnline ? targetid : -1;

			new statusStr[64], userStr[64], rankStr[64], locStr[64];

			if(isOnline)
			{
				if(PlayerInfo[targetid][pAFK])
				{
					format(statusStr, sizeof(statusStr), "{FF0000}AFK (%ds)", PlayerInfo[targetid][pAFKTime]);
				}
				else
				{
					format(statusStr, sizeof(statusStr), "{00FF00}Online");
				}
				format(locStr, sizeof(locStr), "{FFFFFF}%s", GetPlayerZoneName(targetid));
			}
			else
			{
				format(statusStr, sizeof(statusStr), "{FF0000}Offline / {FFFFFF}%s", formatdate(lastlogin_ts, 2));
				format(locStr, sizeof(locStr), "{FFFFFF}Offline");
			}

			if(grank >= 6)
			{
				format(userStr, sizeof(userStr), "{FFFFFF}%s {FFFF00}(Leader)", username);
			}
			else
			{
				format(userStr, sizeof(userStr), "{FFFFFF}%s", username);
			}

			format(rankStr, sizeof(rankStr), "{FFFFFF}%s", GangRanks[gangid][grank]);

			AddDialogListitem(playerid, "%s\t%s\t%s\t%s", statusStr, userStr, rankStr, locStr);
		}
	}

	new response[e_DIALOG_RESPONSE_INFO];
	task_await_arr(ShowPlayerDialogPages(playerid, DIALOG_STYLE_TABLIST_HEADERS, caption, 10, "Select", "Close", "{FF0606}<< {FFFFFF}Previous Page", "{00FF00}>> {FFFFFF}Next Page"), response);

	if(!response[E_DIALOG_RESPONSE_Response]) return 1;

	new listitem = response[E_DIALOG_RESPONSE_Listitem];
	if(listitem < 3)
	{
		return ShowGangMembersDialog(playerid);
	}

	new index = listitem - 3;
	if(index < 0 || index >= rows || index >= 100) return 1;

	new targetid = GangMemberList[playerid][index][gmTargetID];
	new targetUid = GangMemberList[playerid][index][gmUID];
	new targetName[MAX_PLAYER_NAME];
	format(targetName, sizeof(targetName), "%s", GangMemberList[playerid][index][gmName]);
	new targetRank = GangMemberList[playerid][index][gmRank];
	new targetLastLogin = GangMemberList[playerid][index][gmLastLogin];

	SetPVarInt(playerid, "SelectedGangMember", targetid);
	SetPVarInt(playerid, "SelectedGangMemberUid", targetUid);
	SetPVarString(playerid, "SelectedGangMemberName", targetName);
	SetPVarInt(playerid, "SelectedGangMemberRank", targetRank);

	new dialogStr[512], statusStr[64];
	if(targetid != -1 && IsPlayerConnected(targetid))
	{
		if(PlayerInfo[targetid][pAFK])
		{
			format(statusStr, sizeof(statusStr), "{FF0000}AFK (%ds)", PlayerInfo[targetid][pAFKTime]);
		}
		else
		{
			format(statusStr, sizeof(statusStr), "{00FF00}Online");
		}
	}
	else
	{
		format(statusStr, sizeof(statusStr), "{FF0000}Offline / {FFFFFF}%s", formatdate(targetLastLogin, 2));
	}

	new locStr[64];
	if(targetid != -1 && IsPlayerConnected(targetid))
	{
		format(locStr, sizeof(locStr), "%s", GetPlayerZoneName(targetid));
	}
	else
	{
		format(locStr, sizeof(locStr), "Offline");
	}

	format(dialogStr, sizeof(dialogStr), 
		"{FFFFFF}Username: {FFFFFF}%s {AFAFAF}(DBID %d)\n\
		{FFFFFF}Rank: {FFFFFF}%s\n\
		{FFFFFF}Location: {FFFFFF}%s\n\
		{FFFFFF}Status: %s\n\n\
		{FFFFFF}Remove this player from the group?", 
		targetName, 
		targetUid, 
		GangRanks[PlayerInfo[playerid][pGang]][targetRank], 
		locStr, 
		statusStr
	);

	Dialog_Show(playerid, GangMemberInfo, DIALOG_STYLE_MSGBOX, "Member Info", dialogStr, "Uninvite", "Back");
	return 1;
}

CMD:gmembers(playerid, const params[])
{
	return ShowGangMembersDialog(playerid);
}

Dialog:GangMemberInfo(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		return ShowGangMembersDialog(playerid);
	}

	new targetid = GetPVarInt(playerid, "SelectedGangMember");
	new targetUid = GetPVarInt(playerid, "SelectedGangMemberUid");
	new targetName[MAX_PLAYER_NAME];
	GetPVarString(playerid, "SelectedGangMemberName", targetName, sizeof(targetName));
	new targetRank = GetPVarInt(playerid, "SelectedGangMemberRank");

	if(PlayerInfo[playerid][pGangRank] < 5)
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "You need to be at least rank 5+ to uninvite gang members.");
		return ShowGangMembersDialog(playerid);
	}

	if(targetUid == PlayerInfo[playerid][pID] || targetid == playerid)
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "You cannot uninvite yourself using the member menu.");
		return ShowGangMembersDialog(playerid);
	}

	if(targetRank > PlayerInfo[playerid][pGangRank])
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "That player has a higher rank than you.");
		return ShowGangMembersDialog(playerid);
	}

	Log_Write("log_gang", "%s (uid: %i) kicked %s (uid: %i) from %s (id: %i) as rank %s (%i).", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], targetName, targetUid, GangInfo[PlayerInfo[playerid][pGang]][gName], PlayerInfo[playerid][pGang], GangRanks[PlayerInfo[playerid][pGang]][targetRank], targetRank);

	SendClientMessageEx(playerid, COLOR_LIGHTRED, "You have uninvited %s from the gang.", targetName);
	if(targetid != -1 && IsPlayerConnected(targetid))
	{
		SendClientMessageEx(targetid, COLOR_LIGHTRED, "You have been uninvited from the gang by %s.", GetRPName(playerid));
	}

	if(targetid != -1 && IsPlayerConnected(targetid))
	{
		PlayerInfo[targetid][pGang] = -1;
		PlayerInfo[targetid][pGangRank] = 0;
	}

	new query[128];
	mysql_format(connectionID, query, sizeof(query), "UPDATE users SET gang = -1, gangrank = 0 WHERE uid = %d", targetUid);
	mysql_tquery(connectionID, query);

	return ShowGangMembersDialog(playerid);
}
