/* Capital Roleplay - Discord verification module */


new ws_server:DiscordVerifyServer;
new ws_connection:DiscordVerifyConnection = ws_connection:-1;

new DiscordVerifyCode[MAX_PLAYERS][16];
new DiscordVerifyExpires[MAX_PLAYERS];
new bool:DiscordVerifyPending[MAX_PLAYERS];
new bool:DiscordVerifyStarted;

forward DiscordVerification_OnConnect(ws_server:server, ws_connection:connection);
forward DiscordVerification_OnDisconnect(ws_server:server, ws_connection:connection);
forward DiscordVerification_OnMessage(ws_server:server, ws_connection:connection, message[]);
forward DiscordVerification_CheckExisting(playerid);

stock DiscordVerification_ResetPlayer(playerid)
{
    DiscordVerifyCode[playerid][0] = EOS;
    DiscordVerifyExpires[playerid] = 0;
    DiscordVerifyPending[playerid] = false;
    return 1;
}

stock DiscordVerification_Init()
{
    if (!g_ConfigDiscordVerification || DiscordVerifyStarted)
        return 1;
    DiscordVerifyServer = CreateWSServer("DiscordVerification_OnConnect", "DiscordVerification_OnDisconnect", "DiscordVerification_OnMessage");

    if (!WSServerStartListen(DiscordVerifyServer, DISCORD_VERIFY_HOST, DISCORD_VERIFY_PORT))
    {
        DestroyWSServer(DiscordVerifyServer);
        DiscordVerifyServer = ws_server:-1;
        print("[Discord Verification] Failed to start WebSocket server.");
        return 0;
    }

    DiscordVerifyStarted = true;
    printf("[Discord Verification] Listening on port %s.", DISCORD_VERIFY_PORT);
    return 1;
}

stock DiscordVerification_Exit()
{
    if (!DiscordVerifyStarted)
        return 1;
    WSServerStopListen(DiscordVerifyServer);
    DestroyWSServer(DiscordVerifyServer);
    DiscordVerifyServer = ws_server:-1;
    DiscordVerifyConnection = ws_connection:-1;
    DiscordVerifyStarted = false;
    return 1;
}

stock DiscordVerification_IsVerified(playerid)
{
    if (!IsPlayerConnected(playerid))
        return 0;

    if (!SQL_IsLogged(playerid))
        return 0;

    return PlayerData[playerid][pDiscordID][0] != EOS;
}

CMD:verify(playerid, params[])
{
    if (!g_ConfigDiscordVerification)
        return SendErrorMessage(playerid, "Discord verification is currently disabled.");
    #pragma unused params

    if (!SQL_IsLogged(playerid))
        return SendErrorMessage(playerid, "You must be logged in to use /verify.");

    if (DiscordVerifyPending[playerid] && DiscordVerifyExpires[playerid] > gettime())
    {
        new remaining = DiscordVerifyExpires[playerid] - gettime();
        SendServerMessage(playerid, "You already have an active verification code: %s", DiscordVerifyCode[playerid]);
        SendServerMessage(playerid, "That code expires in %d second%s.", remaining, remaining == 1 ? "" : "s");
        return 1;
    }

    new query[256];
    mysql_format(g_iHandle, query, sizeof(query), "SELECT `discordID` FROM `discord_verifications` WHERE `characterID` = '%d' AND `discordID` IS NOT NULL AND `discordID` <> '' LIMIT 1", PlayerData[playerid][pID]);
    mysql_tquery(g_iHandle, query, "DiscordVerification_CheckExisting", "d", playerid);
    return 1;
}

public DiscordVerification_CheckExisting(playerid)
{
    if (!IsPlayerConnected(playerid) || !SQL_IsLogged(playerid))
        return 0;

    new rows;
    cache_get_row_count(rows);

    if (rows)
        return SendErrorMessage(playerid, "Your character is already linked to a Discord account.");

    static const alphabet[] = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    new code[16], query[512];

    format(code, sizeof(code), "CRP-%c%c%c%c%c%c", alphabet[random(sizeof(alphabet) - 1)], alphabet[random(sizeof(alphabet) - 1)], alphabet[random(sizeof(alphabet) - 1)], alphabet[random(sizeof(alphabet) - 1)], alphabet[random(sizeof(alphabet) - 1)], alphabet[random(sizeof(alphabet) - 1)]);

    DiscordVerifyPending[playerid] = true;
    DiscordVerifyExpires[playerid] = gettime() + DISCORD_VERIFY_EXPIRE;
    format(DiscordVerifyCode[playerid], 16, "%s", code);

    mysql_format(g_iHandle, query, sizeof(query), "INSERT INTO `discord_verifications` (`characterID`, `code`, `expiresAt`, `discordID`, `verifiedAt`, `used`) VALUES ('%d', '%e', '%d', NULL, 0, 0) ON DUPLICATE KEY UPDATE `code` = VALUES(`code`), `expiresAt` = VALUES(`expiresAt`), `discordID` = NULL, `verifiedAt` = 0, `used` = 0", PlayerData[playerid][pID], code, DiscordVerifyExpires[playerid]);
    mysql_tquery(g_iHandle, query);

    SendServerMessage(playerid, "Discord verification code: {FFFFFF}%s", code);
    SendClientMessage(playerid, COLOR_GREY, "Use this code in the Capital Roleplay Discord verification panel.");
    SendClientMessage(playerid, COLOR_GREY, "The code expires in 5 minutes and can only be used once.");
    return 1;
}

public DiscordVerification_OnConnect(ws_server:server, ws_connection:connection)
{
    new address[46];
    WSServerGetIP(server, connection, address, sizeof(address));

    if (DiscordVerifyConnection != ws_connection:-1)
        return 1;

    DiscordVerifyConnection = connection;
    printf("[Discord Verification] Bot connected: %s", address);
    return 1;
}

public DiscordVerification_OnDisconnect(ws_server:server, ws_connection:connection)
{
    #pragma unused server

    if (DiscordVerifyConnection == connection)
        DiscordVerifyConnection = ws_connection:-1;

    printf("[Discord Verification] Bot disconnected.");
    return 1;
}

public DiscordVerification_OnMessage(ws_server:server, ws_connection:connection, message[])
{
    #pragma unused server

    new Node:json;

    if (JSON_Parse(message, json) != 0)
        return 1;

    if (JSON_NodeType(json) != JSON_NODE_OBJECT)
    {
        JSON_Cleanup(json);
        return 1;
    }

    new event[32];
    if (JSON_GetString(json, "eventType", event, sizeof(event)) != 0)
    {
        JSON_Cleanup(json);
        return 1;
    }

    if (!strcmp(event, "EmailVerificationSent", true))
    {
        new token[128], email[128], uid;
        if (JSON_GetString(json, "token", token, sizeof(token)) != 0 || strcmp(token, DISCORD_VERIFY_TOKEN, false) != 0 || JSON_GetInt(json, "uid", uid) != 0 || JSON_GetString(json, "email", email, sizeof(email)) != 0)
        {
            JSON_Cleanup(json);
            return 1;
        }
        EmailVerification_OnSent(uid, email);
    }
    else if (!strcmp(event, "EmailVerificationFailed", true))
    {
        new token[128], reason[256], uid;
        if (JSON_GetString(json, "token", token, sizeof(token)) != 0 || strcmp(token, DISCORD_VERIFY_TOKEN, false) != 0 || JSON_GetInt(json, "uid", uid) != 0 || JSON_GetString(json, "reason", reason, sizeof(reason)) != 0)
        {
            JSON_Cleanup(json);
            return 1;
        }
        EmailVerification_OnFailed(uid, reason);
    }
    else if (!strcmp(event, "EmailVerified", true))
    {
        new token[128], email[128], uid;
        if (JSON_GetString(json, "token", token, sizeof(token)) != 0 || strcmp(token, DISCORD_VERIFY_TOKEN, false) != 0 || JSON_GetInt(json, "uid", uid) != 0 || JSON_GetString(json, "email", email, sizeof(email)) != 0)
        {
            JSON_Cleanup(json);
            return 1;
        }
        EmailVerification_OnVerified(uid, email);
    }
    else if (!strcmp(event, "Verified", true))
    {
        new token[128];

        if (JSON_GetString(json, "token", token, sizeof(token)) != 0 || strcmp(token, DISCORD_VERIFY_TOKEN, false) != 0)
        {
            JSON_Cleanup(json);
            return 1;
        }

        new uid;
        new discordID[32];
        new messageText[256];

        if (JSON_GetInt(json, "uid", uid) != 0 || JSON_GetString(json, "discordID", discordID, sizeof(discordID)) != 0)
        {
            JSON_Cleanup(json);
            return 1;
        }

        if (JSON_GetString(json, "message", messageText, sizeof(messageText)) != 0)
            format(messageText, sizeof(messageText), "Your Discord account has been successfully verified.");

        DiscordVerification_Complete(uid, discordID, messageText);
    }

    JSON_Cleanup(json);
    return 1;
}

stock DiscordVerification_Complete(uid, const discordID[], const messageText[])
{
    foreach (new playerid : Player)
    {
        if (PlayerData[playerid][pID] != uid)
            continue;

        new query[512];
        format(PlayerData[playerid][pDiscordID], 32, "%s", discordID);

        mysql_format(g_iHandle, query, sizeof(query), "UPDATE `users` SET `DiscordID` = '%e' WHERE `ID` = '%d'", discordID, uid);
        mysql_tquery(g_iHandle, query);

        mysql_format(g_iHandle, query, sizeof(query), "UPDATE `discord_verifications` SET `discordID` = '%e', `verifiedAt` = '%d', `used` = 1 WHERE `characterID` = '%d'", discordID, gettime(), uid);
        mysql_tquery(g_iHandle, query);

        DiscordVerifyPending[playerid] = false;
        DiscordVerifyExpires[playerid] = 0;
        DiscordVerifyCode[playerid][0] = EOS;

        SendServerMessage(playerid, "%s", messageText);
        return 1;
    }

    return 0;
}