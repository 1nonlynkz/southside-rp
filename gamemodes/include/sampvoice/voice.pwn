
#include <YSI_Coding\y_hooks>

// Sampvoice Main Streams
new SV_LSTREAM:lstream[MAX_PLAYERS] = { SV_NULL, ... };
new SV_GSTREAM:f_stream[MAX_PLAYERS] = { SV_NULL, ... }; 
new SV_GSTREAM:d_stream[MAX_PLAYERS] = { SV_NULL, ... }; 

// Effects
new f_effect[MAX_PLAYERS] = { SV_NULL, ... };
new d_effect[MAX_PLAYERS] = { SV_NULL, ... };

// --- Player Configurations ---
new bool:v_LocalMuted[MAX_PLAYERS];
new bool:v_FactionMuted[MAX_PLAYERS];
new bool:v_DeptMuted[MAX_PLAYERS];

new v_FactionVol[MAX_PLAYERS] = { 100, ... };
new v_DeptVol[MAX_PLAYERS] = { 100, ... };

// Dialog IDs
#define DIALOG_VOICE_MAIN     9850
#define DIALOG_VOICE_FAC      9851
#define DIALOG_VOICE_DEPT     9852

// Keys
#define KEY_Z 0x5A
#define KEY_R 0x52
#define KEY_G 0x47

public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid, SV_UINT:keyid) 
{
    if (keyid == KEY_Z && lstream[playerid] && !v_LocalMuted[playerid]) 
    {
        SvAttachSpeakerToStream(lstream[playerid], playerid);
    }
    else if (keyid == KEY_R && f_stream[playerid] && !v_FactionMuted[playerid]) 
    {
        SvAttachSpeakerToStream(f_stream[playerid], playerid);
    }
    else if (keyid == KEY_G && d_stream[playerid] && !v_DeptMuted[playerid]) 
    {
        SvAttachSpeakerToStream(d_stream[playerid], playerid);
    }
}

public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid, SV_UINT:keyid)
{
    if (keyid == KEY_Z && lstream[playerid]) 
    {
        SvDetachSpeakerFromStream(lstream[playerid], playerid);
    }
    else if (keyid == KEY_R && f_stream[playerid]) 
    {
        SvDetachSpeakerFromStream(f_stream[playerid], playerid);
        if(!v_FactionMuted[playerid]) PlayerPlaySound(playerid, 6400, 0.0, 0.0, 0.0); 
    }
    else if (keyid == KEY_G && d_stream[playerid]) 
    {
        SvDetachSpeakerFromStream(d_stream[playerid], playerid);
        if(!v_DeptMuted[playerid]) PlayerPlaySound(playerid, 6400, 0.0, 0.0, 0.0); 
    }
}

hook OnPlayerConnect(playerid)
{
    // Default safe values
    v_LocalMuted[playerid] = false;
    v_FactionMuted[playerid] = false;
    v_DeptMuted[playerid] = false;
    v_FactionVol[playerid] = 100;
    v_DeptVol[playerid] = 100;

    // TIP: For best performance, call this right after the player successfully logs in instead of OnPlayerConnect.
    LoadPlayerVoiceConfig(playerid);

    if (SvGetVersion(playerid) == SV_NULL) return 1;
    if (SvHasMicro(playerid) == SV_FALSE) return 1;

    lstream[playerid] = SvCreateDLStreamAtPlayer(25.0, SV_INFINITY, playerid, 0xff0000ff, "Local");
    f_stream[playerid] = SvCreateGStream(0x00FF00FF, "Faction Radio");
    d_stream[playerid] = SvCreateGStream(0x0000FFFF, "Dept Radio");

    if(lstream[playerid])
    {
        SvAddKey(playerid, KEY_Z);
        SvAddKey(playerid, KEY_R);
        SvAddKey(playerid, KEY_G);

        f_effect[playerid] = SvEffectCreateRadio(f_stream[playerid], 0, 0);
        d_effect[playerid] = SvEffectCreateRadio(d_stream[playerid], 0, 0);
    }
    return 1;
}

hook OnPlayerDisconnect(playerid)
{
    SavePlayerVoiceConfig(playerid);

    if (lstream[playerid]) { SvDeleteStream(lstream[playerid]); lstream[playerid] = SV_NULL; }
    if (f_stream[playerid]) { SvEffectDelete(f_effect[playerid]); SvDeleteStream(f_stream[playerid]); f_stream[playerid] = SV_NULL; }
    if (d_stream[playerid]) { SvEffectDelete(d_effect[playerid]); SvDeleteStream(d_stream[playerid]); d_stream[playerid] = SV_NULL; }
    return 1;
}

// --- SQL INTEGRATION (USERS TABLE) ---

forward OnVoiceConfigLoad(playerid);
public OnVoiceConfigLoad(playerid)
{
    if(cache_num_rows() > 0)
    {
        v_LocalMuted[playerid] = bool:cache_get_field_content_int(0, "local_muted");
        v_FactionMuted[playerid] = bool:cache_get_field_content_int(0, "faction_muted");
        v_DeptMuted[playerid] = bool:cache_get_field_content_int(0, "dept_muted");
        v_FactionVol[playerid] = cache_get_field_content_int(0, "faction_vol");
        v_DeptVol[playerid] = cache_get_field_content_int(0, "dept_vol");
        
        if(f_stream[playerid]) SvVolumeStream(f_stream[playerid], float(v_FactionVol[playerid]) / 100.0);
        if(d_stream[playerid]) SvVolumeStream(d_stream[playerid], float(v_DeptVol[playerid]) / 100.0);
    }
    return 1;
}

stock LoadPlayerVoiceConfig(playerid)
{
    new name[MAX_PLAYER_NAME], query[128];
    GetPlayerName(playerid, name, sizeof(name));
    mysql_format(connectionID, query, sizeof(query), "SELECT `local_muted`, `faction_muted`, `dept_muted`, `faction_vol`, `dept_vol` FROM `users` WHERE `username` = '%e' LIMIT 1", name); 
    mysql_tquery(connectionID, query, "OnVoiceConfigLoad", "d", playerid);
}

stock SavePlayerVoiceConfig(playerid)
{
    new name[MAX_PLAYER_NAME], query[250];
    GetPlayerName(playerid, name, sizeof(name));
    mysql_format(connectionID, query, sizeof(query), "UPDATE `users` SET `local_muted` = %d, `faction_muted` = %d, `dept_muted` = %d, `faction_vol` = %d, `dept_vol` = %d WHERE `username` = '%e'", v_LocalMuted[playerid], v_FactionMuted[playerid], v_DeptMuted[playerid], v_FactionVol[playerid], v_DeptVol[playerid], name);
    mysql_tquery(connectionID, query, "", "");
}

// --- COMMAND ---

CMD:voiceconfig(playerid, params[])
{
    ShowVoiceConfigMainMenu(playerid);
    return 1;
}

// --- DIALOG MENUS ---

stock ShowVoiceConfigMainMenu(playerid)
{
    new szDialog[350];
    format(szDialog, sizeof(szDialog), 
        "{FFFFFF}Stream\t{FFFFFF}Status\t{FFFFFF}Volume\n\
        {FFFF00}Local Microphone\t%s\t{C0C0C0}Fixed\n\
        {00FF00}Faction Radio (R)\t%s\t{FF8000}%d%%\n\
        {0080FF}Department Radio (G)\t%s\t{FF8000}%d%%",
        v_LocalMuted[playerid] ? ("{FF0000}MUTED") : ("{00FF00}ACTIVE"),
        v_FactionMuted[playerid] ? ("{FF0000}MUTED") : ("{00FF00}ACTIVE"), v_FactionVol[playerid],
        v_DeptMuted[playerid] ? ("{FF0000}MUTED") : ("{00FF00}ACTIVE"), v_DeptVol[playerid]
    );
    
    ShowPlayerDialog(playerid, DIALOG_VOICE_MAIN, DIALOG_STYLE_TABLIST_HEADERS, "{00FFFF}» Voice System Configuration", szDialog, "Select", "Close");
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(!response) return 0;

    switch(dialogid)
    {
        case DIALOG_VOICE_MAIN:
        {
            switch(listitem)
            {
                case 0: 
                {
                    v_LocalMuted[playerid] = !v_LocalMuted[playerid];
                    SendClientMessage(playerid, -1, v_LocalMuted[playerid] ? "{FF0000}[Voice] Local microphone is now muted." : "{00FF00}[Voice] Local microphone is now active.");
                    SavePlayerVoiceConfig(playerid); 
                    ShowVoiceConfigMainMenu(playerid); 
                }
                case 1: 
                {
                    new str[150];
                    format(str, sizeof(str), "{FFFFFF}Status: %s\n{FFFFFF}Current Volume: {FF8000}%d%%\n\n{C0C0C0}Enter volume value (0 - 100) or type 'mute':", v_FactionMuted[playerid] ? ("{FF0000}MUTED") : ("{00FF00}ACTIVE"), v_FactionVol[playerid]);
                    ShowPlayerDialog(playerid, DIALOG_VOICE_FAC, DIALOG_STYLE_INPUT, "{00FF00}Faction Radio Settings", str, "Apply", "Back");
                }
                case 2: 
                {
                    new str[150];
                    format(str, sizeof(str), "{FFFFFF}Status: %s\n{FFFFFF}Current Volume: {FF8000}%d%%\n\n{C0C0C0}Enter volume value (0 - 100) or type 'mute':", v_DeptMuted[playerid] ? ("{FF0000}MUTED") : ("{00FF00}ACTIVE"), v_DeptVol[playerid]);
                    ShowPlayerDialog(playerid, DIALOG_VOICE_DEPT, DIALOG_STYLE_INPUT, "{0080FF}Department Radio Settings", str, "Apply", "Back");
                }
            }
        }
        case DIALOG_VOICE_FAC:
        {
            if(!response) return ShowVoiceConfigMainMenu(playerid);
            
            if(strcmp(inputtext, "mute", true) == 0)
            {
                v_FactionMuted[playerid] = !v_FactionMuted[playerid];
                SendClientMessage(playerid, -1, "{00FF00}[Voice] You toggled Faction Radio status.");
            }
            else
            {
                new vol = strval(inputtext);
                if(vol < 0 || vol > 100) return SendClientMessage(playerid, -1, "{FF0000}[Error] Volume level must range between 0 and 100!"), ShowVoiceConfigMainMenu(playerid);
                
                v_FactionVol[playerid] = vol;
                SvVolumeStream(f_stream[playerid], float(vol) / 100.0); 
                SendClientMessage(playerid, -1, "{00FF00}[Voice] Faction Radio volume level successfully updated.");
            }
            SavePlayerVoiceConfig(playerid); 
            ShowVoiceConfigMainMenu(playerid);
        }
        case DIALOG_VOICE_DEPT:
        {
            if(!response) return ShowVoiceConfigMainMenu(playerid);
            
            if(strcmp(inputtext, "mute", true) == 0)
            {
                v_DeptMuted[playerid] = !v_DeptMuted[playerid];
                SendClientMessage(playerid, -1, "{0080FF}[Voice] You toggled Department Radio status.");
            }
            else
            {
                new vol = strval(inputtext);
                if(vol < 0 || vol > 100) return SendClientMessage(playerid, -1, "{FF0000}[Error] Volume level must range between 0 and 100!"), ShowVoiceConfigMainMenu(playerid);
                
                v_DeptVol[playerid] = vol;
                SvVolumeStream(d_stream[playerid], float(vol) / 100.0);
                SendClientMessage(playerid, -1, "{0080FF}[Voice] Department Radio volume level successfully updated.");
            }
            SavePlayerVoiceConfig(playerid); 
            ShowVoiceConfigMainMenu(playerid);
        }
    }
    return 1;
}