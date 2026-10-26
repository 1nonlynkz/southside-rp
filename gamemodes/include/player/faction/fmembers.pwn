/*
    ============================================================================
    Southside Roleplay - Faction Members System
    ============================================================================
    Author: Spynixx, Niks, Charles
    Description: Faction Members System
    ============================================================================
*/
enum E_FACTION_MEMBER_DATA
{
    fmUID,
    fmName[MAX_PLAYER_NAME],
    fmRank,
    fmDivision,
    fmLastLogin,
    fmTargetID
};
new FactionMemberList[MAX_PLAYERS][100][E_FACTION_MEMBER_DATA];

forward OnLoadFactionMembersDialog(playerid);

stock ShowFactionMembersDialog(playerid)
{
    new factionid = PlayerInfo[playerid][pFaction];
    if(factionid == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not apart of any faction.");
    }

    new searchStr[32], filterQuery[128];
    GetPVarString(playerid, "FMember_Search", searchStr, sizeof(searchStr));

    // If there is an active search filter, add SQL LIKE clause
    if(strlen(searchStr) > 0)
    {
        mysql_format(connectionID, filterQuery, sizeof(filterQuery), " AND username LIKE '%%%e%%'", searchStr);
    }
    else
    {
        filterQuery[0] = '\0';
    }

    // Handle Sort query
    new sortType = GetPVarInt(playerid, "FMember_Sort");
    new sortQuery[128];
    
    switch(sortType)
    {
        case 1: sortQuery = "ORDER BY factionrank DESC, username ASC";
        case 2: sortQuery = "ORDER BY username ASC";
        default: sortQuery = "ORDER BY factionrank DESC, lastlogin DESC";
    }

    new query[384];
    mysql_format(connectionID, query, sizeof(query), 
        "SELECT uid, username, factionrank, division, UNIX_TIMESTAMP(lastlogin) AS lastlogin_ts " \
        "FROM users WHERE faction = %d%s %s", 
        factionid, filterQuery, sortQuery
    );

    mysql_tquery(connectionID, query, "OnLoadFactionMembersDialog", "i", playerid);
    return 1;
}

public OnLoadFactionMembersDialog(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new factionid = PlayerInfo[playerid][pFaction];
    if(factionid == -1) return 1;

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

    new searchStr[32], filterLabel[64];
    GetPVarString(playerid, "FMember_Search", searchStr, sizeof(searchStr));

    if(strlen(searchStr) > 0)
    {
        format(filterLabel, sizeof(filterLabel), "{FF0000}Filter: %s {AFAFAF}(Click to clear/change)\t\t\t", searchStr);
    }
    else
    {
        format(filterLabel, sizeof(filterLabel), "{FF0000}Filter: None {AFAFAF}(Click to search)\t\t\t");
    }

    new sortType = GetPVarInt(playerid, "FMember_Sort");
    new sortLabel[64];
    
    switch(sortType)
    {
        case 1: format(sortLabel, sizeof(sortLabel), "{FFFF00}Sort: Rank (Click to change)\t\t\t");
        case 2: format(sortLabel, sizeof(sortLabel), "{FFFF00}Sort: Name (A-Z) (Click to change)\t\t\t");
        default: format(sortLabel, sizeof(sortLabel), "{FFFF00}Sort: Online / Activity (Click to change)\t\t\t");
    }

    AddDialogListitem(playerid, "Status\tUsername\tRank\tDivision"); // Listitem index 0
    AddDialogListitem(playerid, filterLabel);                      // Listitem index 1
    AddDialogListitem(playerid, sortLabel);                        // Listitem index 2

    new memberHeader[64];
    format(memberHeader, sizeof(memberHeader), "{00FFFF}-- Members (%d) --\t\t\t", rows);
    AddDialogListitem(playerid, memberHeader);                     // Listitem index 3

    if(rows == 0)
    {
        AddDialogListitem(playerid, "{AFAFAF}No members match the current filter.\t\t\t");
    }
    else
    {
        for(new i = 0; i < rows && i < 100; i++)
        {
            new username[MAX_PLAYER_NAME], frank, fdiv, lastlogin_ts, uid;
            uid = cache_get_field_content_int(i, "uid");
            cache_get_field_content(i, "username", username);
            frank = cache_get_field_content_int(i, "factionrank");
            fdiv = cache_get_field_content_int(i, "division");
            lastlogin_ts = cache_get_field_content_int(i, "lastlogin_ts");

            new targetid = INVALID_PLAYER_ID;
            new isOnline = IsPlayerOnline(username, targetid);

            FactionMemberList[playerid][i][fmUID] = uid;
            format(FactionMemberList[playerid][i][fmName], MAX_PLAYER_NAME, "%s", username);
            FactionMemberList[playerid][i][fmRank] = frank;
            FactionMemberList[playerid][i][fmDivision] = fdiv;
            FactionMemberList[playerid][i][fmLastLogin] = lastlogin_ts;
            FactionMemberList[playerid][i][fmTargetID] = isOnline ? targetid : -1;

            new statusStr[64], userStr[64], rankStr[64], divStr[64];

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
            }
            else
            {
                format(statusStr, sizeof(statusStr), "{FF0000}Offline / {FFFFFF}%s", formatdate(lastlogin_ts, 2));
            }

            if(frank >= 5)
            {
                format(userStr, sizeof(userStr), "{FFFFFF}%s {FFFF00}(Leader)", username);
            }
            else
            {
                format(userStr, sizeof(userStr), "{FFFFFF}%s", username);
            }

            format(rankStr, sizeof(rankStr), "{FFFFFF}%s", FactionRanks[factionid][frank]);

            if(fdiv >= 0)
            {
                format(divStr, sizeof(divStr), "{FFFFFF}%s", FactionDivisions[factionid][fdiv]);
            }
            else
            {
                format(divStr, sizeof(divStr), "{FFFFFF}None");
            }

            AddDialogListitem(playerid, "%s\t%s\t%s\t%s", statusStr, userStr, rankStr, divStr);
        }
    }

    new response[e_DIALOG_RESPONSE_INFO];
    task_await_arr(ShowPlayerDialogPages(playerid, DIALOG_STYLE_TABLIST_HEADERS, caption, 10, "Select", "Close", "{FF0606}<< {FFFFFF}Previous Page", "{00FF00}>> {FFFFFF}Next Page"), response);

    if(!response[E_DIALOG_RESPONSE_Response]) return 1;

    new listitem = response[E_DIALOG_RESPONSE_Listitem];

    // Clicked Filter Row (Listitem index 1)
    if(listitem == 0)
    {
        Dialog_Show(playerid, FactionMemberFilterInput, DIALOG_STYLE_INPUT, "Filter Members", "Enter part of a member's name to filter the list:\n\n(Leave empty or click 'Reset' to clear filter)", "Search", "Reset");
        return 1;
    }

    // Clicked Sort Row (Listitem index 2)
    if(listitem == 1)
    {
        new currentSort = GetPVarInt(playerid, "FMember_Sort");
        SetPVarInt(playerid, "FMember_Sort", (currentSort + 1) % 3);
        return ShowFactionMembersDialog(playerid);
    }

    // Clicked Divider Header (Listitem index 3)
    if(listitem == 2)
    {
        return ShowFactionMembersDialog(playerid);
    }

    // Player member selection starts at index 4 (0: Headers, 1: Filter, 2: Sort, 3: Divider)
    new index = listitem - 4;
    if(index < 0 || index >= rows || index >= 100) return 1;

    new targetid = FactionMemberList[playerid][index][fmTargetID];
    new targetUid = FactionMemberList[playerid][index][fmUID];
    new targetName[MAX_PLAYER_NAME];
    format(targetName, sizeof(targetName), "%s", FactionMemberList[playerid][index][fmName]);
    new targetRank = FactionMemberList[playerid][index][fmRank];
    new targetDiv = FactionMemberList[playerid][index][fmDivision];
    new targetLastLogin = FactionMemberList[playerid][index][fmLastLogin];

    SetPVarInt(playerid, "SelectedFactionMember", targetid);
    SetPVarInt(playerid, "SelectedFactionMemberUid", targetUid);
    SetPVarString(playerid, "SelectedFactionMemberName", targetName);
    SetPVarInt(playerid, "SelectedFactionMemberRank", targetRank);

    new dialogStr[512], statusStr[64], divStr[64];
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

    if(targetDiv >= 0)
    {
        format(divStr, sizeof(divStr), "%s", FactionDivisions[PlayerInfo[playerid][pFaction]][targetDiv]);
    }
    else
    {
        format(divStr, sizeof(divStr), "None");
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
        {FFFFFF}Division: {FFFFFF}%s\n\
        {FFFFFF}Location: {FFFFFF}%s\n\
        {FFFFFF}Status: %s\n\n\
        {FFFFFF}Remove this player from the group?", 
        targetName, 
        targetUid, 
        FactionRanks[PlayerInfo[playerid][pFaction]][targetRank], 
        divStr,
        locStr, 
        statusStr
    );

    Dialog_Show(playerid, FactionMemberInfo, DIALOG_STYLE_MSGBOX, "Member Info", dialogStr, "Uninvite", "Back");
    return 1;
}
Dialog:FactionMemberInfo(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        return ShowFactionMembersDialog(playerid);
    }
    return 1;
}
// Dialog input handler for the filter text
Dialog:FactionMemberFilterInput(playerid, response, listitem, inputtext[])
{
    if(!response) // Player clicked 'Reset' or closed dialog
    {
        DeletePVar(playerid, "FMember_Search");
        return ShowFactionMembersDialog(playerid);
    }

    if(isnull(inputtext))
    {
        DeletePVar(playerid, "FMember_Search");
    }
    else
    {
        SetPVarString(playerid, "FMember_Search", inputtext);
    }

    return ShowFactionMembersDialog(playerid);
}

CMD:fmembers(playerid, const params[])
{
    return ShowFactionMembersDialog(playerid);
}