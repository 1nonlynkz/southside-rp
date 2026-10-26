hook OnPlayerSpawn(playerid)
{
    if(strcmp(PlayerInfo[playerid][pDiscordID], "000", true) == 0)
    {
        TogglePlayerControllable(playerid, false); // <--- This locks them in place
        
        SendClientMessage(playerid, COLOR_GREEN, "[Verification] Your account is currently locked. Please verify via Discord.");
        SendClientMessage(playerid, COLOR_WHITE, "Use the command {FFFF00}/getcode {FFFFFF}to get your unique verification token.");
    }
    return 1;
}

CMD:getcode(playerid, params[])
{
    if(strcmp(PlayerInfo[playerid][pDiscordID], "000", true) != 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This account has already been verified in the database.");
    }

    DiscordGenerateCode(playerid);
    return 1;
}

stock DiscordGenerateCode(playerid)
{
    new code = 100000 + random(900000);
    
    new codeStr[128];
    format(codeStr, sizeof(codeStr), "Your verification code is: %i", code);
    SendClientMessage(playerid, COLOR_GREY, codeStr);
    
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET discordCode = %i WHERE uid = %i", code, PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    return 1;
}

