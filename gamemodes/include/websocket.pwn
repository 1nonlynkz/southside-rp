#include <websockets>
#include <json>
#include <YSI_Coding\y_hooks>

#define WS_HOST "0.0.0.0"
#define WS_PORT "9847"
#define DISCORD_WS_URL "ws://"WS_HOST":"WS_PORT""

new ws_server:wsServer;
new ws_connection:discordConnection = ws_connection:-1;

enum 
{
    CMD_LOGS = 1,
    ADMIN_LOGS,
    REPORT_LOGS,
    KILL_LOGS,
    AC_LOGS,
    ADM_CHAT_LOGS,
    COMSERV_LOGS,
    BAN_LOGS,
    PRISON_LOGS,
};

// --- WEBSOCKET LIFE CYCLE ---

hook OnGameModeInit()
{
    // Create a server. The three parameters indicate the names of the callbacks
    wsServer = CreateWSServer("onWSConnect", "onWSDisconnect", "onWSMessage");

    new ret = WSServerStartListen(wsServer, WS_HOST, WS_PORT);
    
    if (ret)
    {
        printf("Web socket is running on "DISCORD_WS_URL"");
    }
    else
    {
        printf("Failed to start websocket server");
        SendRconCommand("close");
        return ~0;
    }
    return 1;
}

hook OnGameModeExit()
{
    WSServerStopListen(wsServer);
    DestroyWSServer(wsServer);
    return 1;
}

forward onWSConnect(ws_server:ws, ws_connection:con);
public onWSConnect(ws_server:ws, ws_connection:con)
{
    new ip[16];
    WSServerGetIP(ws, con, ip, sizeof(ip));
    printf("Web socket is connected: Server %d, Connection %d, IP %s", _:ws, _:con, ip);
    
    discordConnection = con;
    return 1;
}

forward onWSFail(ws_client:ws);
public onWSFail(ws_client:ws)
{
    print("Web socket Failed to connect to gateway.");
    return 1;
}

forward onWSDisconnect(ws_server:ws, ws_connection:con);
public onWSDisconnect(ws_server:ws, ws_connection:con)
{
    new ip[16];
    WSServerGetIP(ws, con, ip, sizeof(ip));
    printf("Web socket is disconnected: Server %d, Connection %d, IP %s", _:ws, _:con, ip);

    if (discordConnection == con)
    {
        discordConnection = ws_connection:-1;
    }
    return 1;
}

// --- REALTIME WEB-SOCKET PROCESSING & FORMAT FIX ---

forward onWSMessage(ws_server:ws, ws_connection:con, message[]);
public onWSMessage(ws_server:ws, ws_connection:con, message[])
{
    new Node:json;
    if (JSON_Parse(message, json) != 0)
    {
        printf("Invalid JSON received: %s", message);
        return 0;
    }
    if (JSON_NodeType(json) != JSON_NODE_OBJECT)
    {
        printf("Received data is not a JSON object: %s", message);
        JSON_Cleanup(json);
        return 0;
    }

    new bool:success = true, sender[24], text[256], discordID[56];
    new eventType[32], uid;

    JSON_GetString(json, "eventType", eventType);

    // Discord Chat Link
    if(!strcmp(eventType, "ChatMessage", true)) {
        success &= JSON_GetString(json, "sender", sender, sizeof(sender)) == 0;
        success &= JSON_GetString(json, "message", text, sizeof(text)) == 0;
        
        new chatStr[256];
        format(chatStr, sizeof(chatStr), "[DISCORD] %s: %s", sender, text);
        SendClientMessageToAll(0xFFFFFFFF, chatStr);
    }
    
    // Instant Live Verification Payload
    if(!strcmp(eventType, "Verified", true)) 
    {
        success &= JSON_GetString(json, "message", text, sizeof(text)) == 0;
        success &= JSON_GetInt(json, "uid", uid) == 0;
        success &= JSON_GetString(json, "discordID", discordID, sizeof(discordID)) == 0;
        
        foreach(new i : Player)
        {
            if(PlayerInfo[i][pID] == uid)
            {
                // 1. I-update ang variable sa server memory para hindi na siya isipin ng system na '000'
                format(PlayerInfo[i][pDiscordID], 56, discordID);

                // 2. REAL-TIME UNFREEZE: Makakagalaw na siya agad live kung nandoon siya sa spawn freeze state
                TogglePlayerControllable(i, true);

                // 3. STRING FORMAT FIX: Sinalang muna sa format buffer para maayos ang display text in-game
                new msgStr[256];
                format(msgStr, sizeof(msgStr), "{00B800}DISCORD: {FFFFFF}%s (Discord ID: %s)", text, discordID);
                SendClientMessage(i, 0x47FF66FF, msgStr);
                
                // Optional: Mag-play ng success notification sound sa player
                PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
                break;
            }
        }
    }
    
    printf("Received eventType: %s", eventType);
    if (!success)
    {
        printf("Failed to parse JSON fields: eventType: %s", eventType);
        JSON_Cleanup(json);
        return 0;
    }
    JSON_Cleanup(json);
    return 1;
}

// --- OUTGOING LOGGING LOGIC ---

stock SendDiscordLog(logtype, const message[], const author[], ...)
{
    new str[2048];
    format(str, sizeof str, message, ___(3));

    new Node:json = JSON_Object(
        "sender", JSON_String(author),
        "message", JSON_String(str)
    );
    JSON_ToggleGC(json, false);

    switch(logtype){
        case CMD_LOGS: Websocket_SendMessage("CmdLogs", json);
        case ADMIN_LOGS: Websocket_SendMessage("AdminLogs", json);
        case REPORT_LOGS: Websocket_SendMessage("ReportLogs", json);
        case KILL_LOGS: Websocket_SendMessage("KillLogs", json);
        case AC_LOGS: Websocket_SendMessage("AnticheatLogs", json);
        case ADM_CHAT_LOGS: Websocket_SendMessage("AdminChatLogs", json);
        case COMSERV_LOGS: Websocket_SendMessage("ComservLogs", json);
        case BAN_LOGS: Websocket_SendMessage("BanLogs", json);
        case PRISON_LOGS: Websocket_SendMessage("PrisonLogs", json);
    }
    JSON_ToggleGC(json, true);
    return 1;
}

stock Websocket_SendMessage(const name[], Node:node){
    new Node:a = JSON_Object("name", JSON_String(name));
    new Node:b = JSON_Object("data", node);
    new Node:c = JSON_Append(a, b);
    new buf[2048];
    JSON_Stringify(c, buf);
    WSServerSendToAll(wsServer, buf, strlen(buf));
}
