// =============================================================================
// GLOBAL SYSTEM CONFIGURATION
// =============================================================================

static const SE_RankingMonths[][] = {
    "January", "February", "March", "April", "May", "June", 
    "July", "August", "September", "October", "November", "December"
};

// =============================================================================
// RE-WRITTEN RETURNUSEREX (Zero Crash & Optimized)
// =============================================================================
ReturnUserEx(const text[]) 
{
    if(isnull(text)) return INVALID_PLAYER_ID;
    
    // Auto-detect kung Player ID ang isinulat (Pawang numero lang)
    new bool:isnum = true, idx = 0;
    while(text[idx]) {
        if(!('0' <= text[idx] <= '9')) {
            isnum = false;
            break;
        }
        idx++;
    }
    
    if(isnum) 
    {
        new returnID = strval(text);
        if(IsPlayerConnected(returnID)) return returnID;
    }
    else // Kung pangalan naman, ihahambing sa mga online players
    {
        #if defined foreach
            foreach(new p : Player) 
            {
                if(!strcmp(PlayerInfo[p][pUsername], text, true)) return p;
            }
        #else
            for(new p = 0; p < MAX_PLAYERS; p++)
            {
                if(!IsPlayerConnected(p)) continue;
                if(!strcmp(PlayerInfo[p][pUsername], text, true)) return p;
            }
        #endif
    }
    return INVALID_PLAYER_ID;
}

// =============================================================================
// CALLBACK: TOP PLAYING HOURS
// =============================================================================
forward OnPlayerListRankings(playerid);
public OnPlayerListRankings(playerid)
{
    new rows = cache_num_rows(connectionID);
    if(!rows)
    {
        return ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, 
            "{FFFF00}Top 10 Playtime", "{FFFFFF}There are no recorded playing hours for this period yet.", "Close", "");
    }

    new szDialog[2048], username[MAX_PLAYER_NAME], hours, giveplayerid, len = 0;

    // Elegant Header Line
    len = format(szDialog, sizeof(szDialog), "Rank\tPlayer Name\tPlaytime\tStatus\n");

    for(new i = 0; i < rows; i++)
    {
        // Nilagyan ng explicit size at connectionID para sa standard MySQL plugin compatibility
        cache_get_field_content(i, "Name", username, connectionID, sizeof(username));
        hours = cache_get_field_content_int(i, "hours", connectionID);
        giveplayerid = ReturnUserEx(username);

        new rankColor[8];
        if(i == 0) format(rankColor, sizeof(rankColor), "{FFD700}");      // 1st - Gold
        else if(i == 1) format(rankColor, sizeof(rankColor), "{C0C0C0}"); // 2nd - Silver
        else if(i == 2) format(rankColor, sizeof(rankColor), "{CD7F32}"); // 3rd - Bronze
        else format(rankColor, sizeof(rankColor), "{FFFF00}");            // Standard Yellow Rank

        len += format(szDialog[len], sizeof(szDialog) - len, "%s#%d\t{FFFFFF}%s\t{00FFFF}%d hours\t%s\n", 
            rankColor, (i + 1), username, hours, (giveplayerid == INVALID_PLAYER_ID) ? ("{FF3333}[Offline]") : ("{33FF33}[Online]"));
    }

    new year, month, day, szTitle[64];
    getdate(year, month, day);
    format(szTitle, sizeof(szTitle), "Top 10 Active Players (%s %d)", SE_RankingMonths[month - 1], year);
    
    ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szDialog, "Close", "");
    return 1;
}

// =============================================================================
// CALLBACK: FAMILY / GANG OF THE MONTH
// =============================================================================
forward OnGangListRankings(playerid);
public OnGangListRankings(playerid)
{
    new rows = cache_num_rows(connectionID);
    if(!rows)
    {
        return ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, 
            "{FF9900}Family of the Month", "{FFFFFF}No families or gangs have secured turf points yet.", "Close", "");
    }

    new szDialog[2048], gangName[32], points, len = 0;

    // Esports-Inspired Tablist Headers
    len = format(szDialog, sizeof(szDialog), "Rank\tFamily/Gang Name\tTurf Score\n");

    for(new i = 0; i < rows; i++)
    {
        // Swak sa column names mo: `name` at `points`
        cache_get_field_content(i, "name", gangName, connectionID, sizeof(gangName));
        points = cache_get_field_content_int(i, "points", connectionID); 
        
        // TANDAAN: Kung nais mong 'turftokens' ang ibilang sa halip na 'points', 
        // palitan lang ang `"points"` sa itaas ng `"turftokens"`.

        new rankColor[8];
        if(i == 0) format(rankColor, sizeof(rankColor), "{FFD700}");      // Gold Medal
        else if(i == 1) format(rankColor, sizeof(rankColor), "{C0C0C0}"); // Silver Medal
        else if(i == 2) format(rankColor, sizeof(rankColor), "{CD7F32}"); // Bronze Medal
        else format(rankColor, sizeof(rankColor), "{FFFFFF}");            // White Text

        len += format(szDialog[len], sizeof(szDialog) - len, "%s#%d\t{FFFFFF}%s\t{00FF00}%d points\n", 
            rankColor, (i + 1), gangName, points);
    }

    new year, month, day, szTitle[64];
    getdate(year, month, day);
    format(szTitle, sizeof(szTitle), "Family of the Month (%s %d)", SE_RankingMonths[month - 1], year);

    ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szDialog, "Close", "");
    return 1;
}

// =============================================================================
// SEPARATE PLAYER COMMANDS
// =============================================================================

CMD:topplayers(playerid, params[])
{  
    mysql_tquery(connectionID, "SELECT * FROM `rankings` ORDER BY `hours` DESC LIMIT 10", "OnPlayerListRankings", "d", playerid);
    return 1;
}

CMD:topgangs(playerid, params[])
{  
    // Naka-ORDER BY `points` DESC para makuha ang mga pinakamataas ang score
    mysql_tquery(connectionID, "SELECT `name`, `points` FROM `gangs` ORDER BY `points` DESC LIMIT 10", "OnGangListRankings", "d", playerid);
    return 1;
}

// =============================================================================
// ADMIN MANAGEMENT COMMAND (Monthly Reset)
// =============================================================================

CMD:resetleaderboards(playerid, params[])
{  
    if(PlayerInfo[playerid][pAdmin] < 6)
    {
        return SendClientMessage(playerid, COLOR_GREY, "System: You are not authorized to use this command (Executive Admin+).");
    }
    
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has wiped the Monthly Leaderboards (Player Hours & Gang Turf Points).", GetPlayerNameEx(playerid));
    
    // Burahin ang active player standings 
    mysql_tquery(connectionID, "TRUNCATE TABLE `rankings`");
    
    // Ibalik sa 0 ang gang points para sa bagong buwan (Ligtas ang weapons, cash, at drugs ng mga gang!)
    mysql_tquery(connectionID, "UPDATE `gangs` SET `points` = 0"); 
    // Kung 'turftokens' ang pinili mo, magdagdag lang dito ng: mysql_tquery(connectionID, "UPDATE `gangs` SET `turftokens` = 0");
    
    return 1;
}
