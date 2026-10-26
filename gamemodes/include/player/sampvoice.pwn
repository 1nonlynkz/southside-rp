#include <open.mp>
#include <YSI_Coding\y_hooks>
#include <sampvoice>

#define KEY_R 0x52
#define KEY_Z 0x5A
#define KEY_B 0x42

#define CHAN_ALLDEPT 0
#define CHAN_PNP     1
#define CHAN_EMS     2
#define CHAN_GOV     3
#define CHAN_AFP     4

#define DIALOG_VOICE_MAIN        9850
#define DIALOG_VOICE_VOL         9851
#define DIALOG_VOICE_RANGE       9852
#define DIALOG_VOICE_HUD_POS     9853
#define DIALOG_VOICE_PLAYER_LIST 9854
#define DIALOG_VOICE_PLAYER_SET  9855

#define RANGE_WHISPER 3.0
#define RANGE_NORMAL  10.0
#define RANGE_SHOUT   25.0

new SV_GSTREAM:dept_stream[5] = { SV_NULL, ... };
new SV_GSTREAM:wt_stream[MAX_PLAYERS] = { SV_NULL, ... };
new SV_DLSTREAM:lstream[MAX_PLAYERS] = { SV_NULL, ... };

new bool:is_pressing_wt[MAX_PLAYERS] = { false, ... };
new bool:is_pressing_local[MAX_PLAYERS] = { false, ... };

new bool:v_RadioMuted[MAX_PLAYERS];
new v_RadioVol[MAX_PLAYERS] = { 100, ... };

new v_VoiceRange[MAX_PLAYERS] = { 2, ... };
new bool:v_SelfMuted[MAX_PLAYERS] = { false, ... };
new bool:v_Deafened[MAX_PLAYERS] = { false, ... };
new bool:v_RadioFX[MAX_PLAYERS] = { true, ... };
new v_HUDPos[MAX_PLAYERS] = { 0, ... };

new p_VoiceVolume[MAX_PLAYERS][MAX_PLAYERS];
new g_SelectedPlayer[MAX_PLAYERS] = { INVALID_PLAYER_ID, ... };

new PlayerText:RadioTD[MAX_PLAYERS][4];
new bool:has_radio_td[MAX_PLAYERS] = { false, ... };

stock CreatePlayerRadioTD(playerid)
{
    new Float:base_x = 557.0, Float:base_y = 195.0;

    if(v_HUDPos[playerid] == 1) { base_x = 557.0; base_y = 360.0; }
    else if(v_HUDPos[playerid] == 2) { base_x = 20.0; base_y = 195.0; }

    RadioTD[playerid][0] = CreatePlayerTextDraw(playerid, base_x, base_y, "Radio:");
    PlayerTextDrawFont(playerid, RadioTD[playerid][0], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, RadioTD[playerid][0], 0.224999, 1.000000);
    PlayerTextDrawTextSize(playerid, RadioTD[playerid][0], 400.000000, 1017.000000);
    PlayerTextDrawSetOutline(playerid, RadioTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, RadioTD[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, RadioTD[playerid][0], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, RadioTD[playerid][0], 1302790143);
    PlayerTextDrawBackgroundColor(playerid, RadioTD[playerid][0], 255);
    PlayerTextDrawBoxColor(playerid, RadioTD[playerid][0], 50);
    PlayerTextDrawUseBox(playerid, RadioTD[playerid][0], 0);
    PlayerTextDrawSetProportional(playerid, RadioTD[playerid][0], 1);

    RadioTD[playerid][1] = CreatePlayerTextDraw(playerid, base_x + 27.0, base_y, "00");
    PlayerTextDrawFont(playerid, RadioTD[playerid][1], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, RadioTD[playerid][1], 0.224999, 1.000000);
    PlayerTextDrawTextSize(playerid, RadioTD[playerid][1], 400.000000, 1017.000000);
    PlayerTextDrawSetOutline(playerid, RadioTD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, RadioTD[playerid][1], 0);
    PlayerTextDrawAlignment(playerid, RadioTD[playerid][1], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, RadioTD[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, RadioTD[playerid][1], 255);
    PlayerTextDrawBoxColor(playerid, RadioTD[playerid][1], 50);
    PlayerTextDrawUseBox(playerid, RadioTD[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, RadioTD[playerid][1], 1);

    RadioTD[playerid][2] = CreatePlayerTextDraw(playerid, base_x + 40.0, base_y, "Connected");
    PlayerTextDrawFont(playerid, RadioTD[playerid][2], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, RadioTD[playerid][2], 0.224999, 1.000000);
    PlayerTextDrawTextSize(playerid, RadioTD[playerid][2], 400.000000, 1017.000000);
    PlayerTextDrawSetOutline(playerid, RadioTD[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, RadioTD[playerid][2], 0);
    PlayerTextDrawAlignment(playerid, RadioTD[playerid][2], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, RadioTD[playerid][2], 1442797055);
    PlayerTextDrawBackgroundColor(playerid, RadioTD[playerid][2], 255);
    PlayerTextDrawBoxColor(playerid, RadioTD[playerid][2], 50);
    PlayerTextDrawUseBox(playerid, RadioTD[playerid][2], 0);
    PlayerTextDrawSetProportional(playerid, RadioTD[playerid][2], 1);

    RadioTD[playerid][3] = CreatePlayerTextDraw(playerid, base_x + 52.0, base_y + 10.0, "No one is talking...");
    PlayerTextDrawFont(playerid, RadioTD[playerid][3], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, RadioTD[playerid][3], 0.179166, 0.800000);
    PlayerTextDrawTextSize(playerid, RadioTD[playerid][3], 394.500000, 1017.000000);
    PlayerTextDrawSetOutline(playerid, RadioTD[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, RadioTD[playerid][3], 0);
    PlayerTextDrawAlignment(playerid, RadioTD[playerid][3], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColor(playerid, RadioTD[playerid][3], -522133249);
    PlayerTextDrawBackgroundColor(playerid, RadioTD[playerid][3], 255);
    PlayerTextDrawBoxColor(playerid, RadioTD[playerid][3], 50);
    PlayerTextDrawUseBox(playerid, RadioTD[playerid][3], 0);
    PlayerTextDrawSetProportional(playerid, RadioTD[playerid][3], 1);

    has_radio_td[playerid] = true;
}

stock DestroyPlayerRadioTD(playerid)
{
    if(!has_radio_td[playerid]) return;
    for(new i = 0; i < 4; i++)
    {
        PlayerTextDrawDestroy(playerid, RadioTD[playerid][i]);
    }
    has_radio_td[playerid] = false;
}

stock ReloadRadioTDPosition(playerid)
{
    new bool:was_showing = has_radio_td[playerid];
    DestroyPlayerRadioTD(playerid);
    CreatePlayerRadioTD(playerid);
    if(was_showing) RefreshPlayerRadioStream(playerid);
}

stock ShowPlayerRadioTD(playerid)
{
    if(!has_radio_td[playerid]) return;
    for(new i = 0; i < 4; i++) PlayerTextDrawShow(playerid, RadioTD[playerid][i]);
}

stock HidePlayerRadioTD(playerid)
{
    if(!has_radio_td[playerid]) return;
    for(new i = 0; i < 4; i++) PlayerTextDrawHide(playerid, RadioTD[playerid][i]);
}

stock UpdateRadioTDDisplay(playerid, const speaker[] = "No one is talking...")
{
    if(!has_radio_td[playerid]) return;

    new szChan[16];
    format(szChan, sizeof(szChan), "%02d", PlayerInfo[playerid][pChannel]);
    PlayerTextDrawSetString(playerid, RadioTD[playerid][1], szChan);

    if(v_RadioMuted[playerid] || v_Deafened[playerid])
    {
        PlayerTextDrawSetString(playerid, RadioTD[playerid][2], v_Deafened[playerid] ? ("Deafened") : ("Muted"));
        PlayerTextDrawColor(playerid, RadioTD[playerid][2], 0xFF0000FF);
    }
    else
    {
        PlayerTextDrawSetString(playerid, RadioTD[playerid][2], "Connected");
        PlayerTextDrawColor(playerid, RadioTD[playerid][2], 1442797055);
    }

    PlayerTextDrawSetString(playerid, RadioTD[playerid][3], speaker);
    ShowPlayerRadioTD(playerid);
}

public OnGameModeInit()
{
    dept_stream[CHAN_ALLDEPT] = SvCreateGStream(0xFFFFFFFF, "All Departments"); 
    dept_stream[CHAN_PNP]     = SvCreateGStream(0x0000FFFF, "PNP Radio");       
    dept_stream[CHAN_EMS]     = SvCreateGStream(0xFF0000FF, "EMS Radio");       
    dept_stream[CHAN_GOV]     = SvCreateGStream(0xFFD700FF, "GOV Radio");       
    dept_stream[CHAN_AFP]     = SvCreateGStream(0x00FF00FF, "AFP Radio");       

    #if defined SV_OnGameModeInit
        return SV_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit SV_OnGameModeInit
forward SV_OnGameModeInit();

forward OnVoiceConfigLoad(playerid);
public OnVoiceConfigLoad(playerid)
{
    if(cache_num_rows() > 0)
    {
        v_RadioMuted[playerid]  = bool:cache_get_field_content_int(0, "radio_muted");
        v_RadioVol[playerid]    = cache_get_field_content_int(0, "radio_vol");
        v_VoiceRange[playerid]  = cache_get_field_content_int(0, "voice_range");
        v_SelfMuted[playerid]   = bool:cache_get_field_content_int(0, "voice_self_muted");
        v_Deafened[playerid]    = bool:cache_get_field_content_int(0, "voice_deafened");
        v_RadioFX[playerid]     = bool:cache_get_field_content_int(0, "radio_fx");
        v_HUDPos[playerid]      = cache_get_field_content_int(0, "radio_hud_pos");
    }
    
    ReloadRadioTDPosition(playerid);
    UpdatePlayerVoiceRange(playerid);
    RefreshPlayerRadioStream(playerid);
    return 1;
}

stock LoadPlayerVoiceConfig(playerid)
{
    new name[MAX_PLAYER_NAME], query[200];
    GetPlayerName(playerid, name, sizeof(name));
    mysql_format(connectionID, query, sizeof(query), "SELECT `radio_muted`, `radio_vol`, `voice_range`, `voice_self_muted`, `voice_deafened`, `radio_fx`, `radio_hud_pos` FROM `users` WHERE `username` = '%e' LIMIT 1", name); 
    mysql_tquery(connectionID, query, "OnVoiceConfigLoad", "d", playerid);
}

stock SavePlayerVoiceConfig(playerid)
{
    new name[MAX_PLAYER_NAME], query[300];
    GetPlayerName(playerid, name, sizeof(name));
    mysql_format(connectionID, query, sizeof(query), "UPDATE `users` SET `radio_muted` = %d, `radio_vol` = %d, `voice_range` = %d, `voice_self_muted` = %d, `voice_deafened` = %d, `radio_fx` = %d, `radio_hud_pos` = %d WHERE `username` = '%e'", v_RadioMuted[playerid], v_RadioVol[playerid], v_VoiceRange[playerid], v_SelfMuted[playerid], v_Deafened[playerid], v_RadioFX[playerid], v_HUDPos[playerid], name);
    mysql_tquery(connectionID, query, "", "");
}

stock UpdatePlayerVoiceRange(playerid)
{
    if(lstream[playerid] != SV_NULL)
    {
        SvDeleteStream(lstream[playerid]);
        lstream[playerid] = SV_NULL;
    }

    new Float:range_dist = RANGE_NORMAL;
    if(v_VoiceRange[playerid] == 1) range_dist = RANGE_WHISPER;
    else if(v_VoiceRange[playerid] == 3) range_dist = RANGE_SHOUT;

    lstream[playerid] = SvCreateDLStreamAtPlayer(range_dist, SV_INFINITY, playerid, 0xFF0000FF, "Local");
    return 1;
}

forward RefreshPlayerRadioStream(playerid);
public RefreshPlayerRadioStream(playerid)
{
    for(new i = 0; i <= 4; i++)
    {
        if(dept_stream[i] != SV_NULL) SvDetachListenerFromStream(dept_stream[i], playerid);
    }
    
    if (wt_stream[playerid] != SV_NULL)
    {
        SvDetachListenerFromStream(wt_stream[playerid], playerid);
        
        new bool:stream_in_use = false;
        foreach(new i : Player)
        {
            if(i != playerid && wt_stream[i] == wt_stream[playerid]) 
            { 
                stream_in_use = true; 
                break; 
            }
        }
        if(!stream_in_use) SvDeleteStream(wt_stream[playerid]);
        wt_stream[playerid] = SV_NULL;
    }

    if(Inventory_Count(playerid, "Portable Radio") < 1 || PlayerInfo[playerid][pToggleWT] || v_RadioMuted[playerid] || v_Deafened[playerid]) 
    {
        HidePlayerRadioTD(playerid);
        return 1;
    }

    new faction = PlayerInfo[playerid][pFaction]; 
    new bool:is_gov = (faction >= 1 && faction <= 4); 
    new freq = PlayerInfo[playerid][pChannel];

    if(is_gov)
    {
        if(dept_stream[CHAN_ALLDEPT]) SvAttachListenerToStream(dept_stream[CHAN_ALLDEPT], playerid);
        if(faction == 1 && dept_stream[CHAN_PNP]) SvAttachListenerToStream(dept_stream[CHAN_PNP], playerid); 
        if(faction == 2 && dept_stream[CHAN_EMS]) SvAttachListenerToStream(dept_stream[CHAN_EMS], playerid); 
        if(faction == 3 && dept_stream[CHAN_GOV]) SvAttachListenerToStream(dept_stream[CHAN_GOV], playerid); 
        if(faction == 4 && dept_stream[CHAN_AFP]) SvAttachListenerToStream(dept_stream[CHAN_AFP], playerid); 
    }

    if(0 <= freq <= 4)
    {
        if(!is_gov)
        {
            SendClientMessage(playerid, -1, "Inalis ka sa channel dahil ito ay nakareserba lamang sa mga Otoridad.");
            PlayerInfo[playerid][pChannel] = 5; 
            freq = 5;
        }
        else wt_stream[playerid] = SV_NULL; 
    }

    if(freq >= 5)
    {
        new SV_GSTREAM:target_stream = SV_NULL;
        foreach(new i : Player)
        {
            if(i != playerid && PlayerInfo[i][pChannel] == freq && wt_stream[i] != SV_NULL && PlayerInfo[i][pChannel] >= 5)
            {
                target_stream = wt_stream[i];
                break;
            }
        }

        if(target_stream == SV_NULL)
        {
            new stream_name[32];
            format(stream_name, sizeof(stream_name), "Radio: %i MHz", freq);
            target_stream = SvCreateGStream(0x6DFB6DFF, stream_name);
        }

        if(target_stream)
        {
            wt_stream[playerid] = target_stream;
            SvAttachListenerToStream(target_stream, playerid);
        }
    }
    
    new Float:f_vol = float(v_RadioVol[playerid]) / 100.0;
    if(0 <= freq <= 4 && dept_stream[freq] != SV_NULL) SvStreamParameterSet(dept_stream[freq], SV_PARAMETER_VOLUME, f_vol);
    else if(freq >= 5 && wt_stream[playerid] != SV_NULL) SvStreamParameterSet(wt_stream[playerid], SV_PARAMETER_VOLUME, f_vol);

    UpdateRadioTDDisplay(playerid);
    return 1;
}

stock BroadcastRadioSpeakerName(playerid, bool:speaking)
{
    new freq = PlayerInfo[playerid][pChannel];
    new text_str[64];

    if(speaking) 
    {
        format(text_str, sizeof(text_str), "%s is talking...", GetRPName(playerid));
        SetPlayerBubbleText(playerid, 5.0, 0x6DFB6DFF, "(Radio Voice) *Talking...*");
    }
    else 
    {
        format(text_str, sizeof(text_str), "No one is talking...");
    }

    foreach(new i : Player)
    {
        if(Inventory_Count(i, "Portable Radio") < 1 || PlayerInfo[i][pToggleWT]) continue;

        new bool:can_see = false;
        if(freq == 0 && (1 <= PlayerInfo[i][pFaction] <= 4)) can_see = true;
        else if(freq == 1 && PlayerInfo[i][pFaction] == 1) can_see = true;
        else if(freq == 2 && PlayerInfo[i][pFaction] == 2) can_see = true;
        else if(freq == 3 && PlayerInfo[i][pFaction] == 3) can_see = true;
        else if(freq == 4 && PlayerInfo[i][pFaction] == 4) can_see = true;
        else if(freq >= 5 && PlayerInfo[i][pChannel] == freq) can_see = true;

        if(can_see) UpdateRadioTDDisplay(i, text_str);
    }
}

stock ProcessRadioPress(playerid)
{
    if(is_pressing_wt[playerid] || v_SelfMuted[playerid]) return 1;
    if(Inventory_Count(playerid, "Portable Radio") < 1 || PlayerInfo[playerid][pToggleWT]) return 0;
    if(PlayerInfo[playerid][pInjured] || PlayerInfo[playerid][pCuffed] || PlayerInfo[playerid][pTied]) return 0;

    new freq = PlayerInfo[playerid][pChannel];

    if(0 <= freq <= 4)
    {
        if(dept_stream[freq] != SV_NULL)
        {
            SvAttachSpeakerToStream(dept_stream[freq], playerid);
            is_pressing_wt[playerid] = true;
            SetPlayerBubbleText(playerid, 5.0, 0x6DFB6DFF, "(Radio Voice) *Click*");
            BroadcastRadioSpeakerName(playerid, true);
        }
    }
    else if(freq >= 5)
    {
        if(wt_stream[playerid] != SV_NULL)
        {
            SvAttachSpeakerToStream(wt_stream[playerid], playerid);
            is_pressing_wt[playerid] = true;
            SetPlayerBubbleText(playerid, 5.0, 0x6DFB6DFF, "(Radio Voice) *Click*");
            BroadcastRadioSpeakerName(playerid, true);
        }
    }
    return 1;
}

stock ProcessRadioRelease(playerid)
{
    if(!is_pressing_wt[playerid]) return 1;

    new freq = PlayerInfo[playerid][pChannel];

    if(0 <= freq <= 4)
    {
        if(dept_stream[freq] != SV_NULL) SvDetachSpeakerFromStream(dept_stream[freq], playerid);
    }
    else if(freq >= 5)
    {
        if(wt_stream[playerid] != SV_NULL) SvDetachSpeakerFromStream(wt_stream[playerid], playerid);
    }

    is_pressing_wt[playerid] = false;
    SetPlayerBubbleText(playerid, 5.0, 0x6DFB6DFF, "(Radio Voice) *Static*");
    BroadcastRadioSpeakerName(playerid, false);
    
    if(v_RadioFX[playerid]) PlayerPlaySound(playerid, 6400, 0.0, 0.0, 0.0);
    return 1;
}

public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid, SV_UINT:keyid) 
{
    if (keyid == KEY_R) ProcessRadioPress(playerid);

    if ((keyid == KEY_Z || keyid == KEY_B) && lstream[playerid] && !v_SelfMuted[playerid])
    {
        SvAttachSpeakerToStream(lstream[playerid], playerid);
        is_pressing_local[playerid] = true;
    }
}

public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid, SV_UINT:keyid)
{
    if (keyid == KEY_R) ProcessRadioRelease(playerid);

    if ((keyid == KEY_Z || keyid == KEY_B) && lstream[playerid])
    {
        SvDetachSpeakerFromStream(lstream[playerid], playerid);
        is_pressing_local[playerid] = false;
    }
}

forward OnPlayerStreamSpeakerAttach(SV_STREAM:stream, playerid);
public OnPlayerStreamSpeakerAttach(SV_STREAM:stream, playerid)
{
    new bool:is_radio_stream = false;
    for(new i = 0; i <= 4; i++)
    {
        if(SV_GSTREAM:stream == dept_stream[i]) { is_radio_stream = true; break; }
    }
    if(!is_radio_stream && SV_GSTREAM:stream == wt_stream[playerid])
    {
        is_radio_stream = true;
    }

    if(is_radio_stream)
    {
        BroadcastRadioSpeakerName(playerid, true);
    }
}

forward OnPlayerStreamSpeakerDetach(SV_STREAM:stream, playerid);
public OnPlayerStreamSpeakerDetach(SV_STREAM:stream, playerid)
{
    new bool:is_radio_stream = false;
    for(new i = 0; i <= 4; i++)
    {
        if(SV_GSTREAM:stream == dept_stream[i]) { is_radio_stream = true; break; }
    }
    if(!is_radio_stream && SV_GSTREAM:stream == wt_stream[playerid])
    {
        is_radio_stream = true;
    }

    if(is_radio_stream)
    {
        BroadcastRadioSpeakerName(playerid, false);
    }
}

hook OnPlayerConnect(playerid)
{
    v_RadioMuted[playerid] = false;
    v_RadioVol[playerid]   = 100;
    v_VoiceRange[playerid] = 2;
    v_SelfMuted[playerid]  = false;
    v_Deafened[playerid]   = false;
    v_RadioFX[playerid]    = true;
    v_HUDPos[playerid]     = 0;

    for(new i = 0; i < MAX_PLAYERS; i++) p_VoiceVolume[playerid][i] = 100;

    wt_stream[playerid] = SV_NULL;
    lstream[playerid] = SV_NULL;
    is_pressing_wt[playerid] = false;
    is_pressing_local[playerid] = false;

    CreatePlayerRadioTD(playerid);

    if (SvGetVersion(playerid) == SV_NULL)
    {
        SendClientMessage(playerid, -1, "Could not find plugin sampvoice.");
    }
    else if (SvHasMicro(playerid) == SV_FALSE)
    {
        SendClientMessage(playerid, -1, "The microphone could not be found.");
    }
    else
    {
        SendClientMessage(playerid, -1, "Press Z or B to talk to other players.");
        
        SvAddKey(playerid, KEY_R);
        SvAddKey(playerid, KEY_Z);
        SvAddKey(playerid, KEY_B);
    }

    LoadPlayerVoiceConfig(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid)
{
    ProcessRadioRelease(playerid);
    if(is_pressing_local[playerid] && lstream[playerid] != SV_NULL) SvDetachSpeakerFromStream(lstream[playerid], playerid);
    SavePlayerVoiceConfig(playerid);
    DestroyPlayerRadioTD(playerid);
    
    if(lstream[playerid] != SV_NULL)
    {
        SvDeleteStream(lstream[playerid]);
        lstream[playerid] = SV_NULL;
    }

    PlayerInfo[playerid][pChannel] = 0;
    RefreshPlayerRadioStream(playerid);
    is_pressing_wt[playerid] = false;
    is_pressing_local[playerid] = false;
    return 1;
}


CMD:voicestatus(playerid, const params[])
{
    new rangeName[16], micName[8], radioName[8], audioName[10];
    if(v_VoiceRange[playerid] == 1) rangeName = "Whisper";
    else if(v_VoiceRange[playerid] == 3) rangeName = "Shout";
    else rangeName = "Normal";
    format(micName, sizeof(micName), "%s", v_SelfMuted[playerid] ? ("Muted") : ("Active"));
    format(radioName, sizeof(radioName), "%s", v_RadioMuted[playerid] ? ("Muted") : ("Active"));
    format(audioName, sizeof(audioName), "%s", v_Deafened[playerid] ? ("Deafened") : ("Active"));
    SendClientMessage(playerid, -1, "{6CB4EE}[Voice] {FFFFFF}Status");
    SendMessage(playerid, -1, "{FFFFFF}Microphone: %s | Voice range: %s", micName, rangeName);
    SendMessage(playerid, -1, "{FFFFFF}Radio: %s | Audio: %s", radioName, audioName);
    SendClientMessage(playerid, -1, "{FFFFFF}Mobile radio talk: use /radiotalk to start/stop transmitting.");
    return 1;
}

CMD:voicemute(playerid, const params[])
{
    v_SelfMuted[playerid] = true;
    if(is_pressing_local[playerid])
    {
        if(lstream[playerid] != SV_NULL) SvDetachSpeakerFromStream(lstream[playerid], playerid);
        is_pressing_local[playerid] = false;
    }
    ProcessRadioRelease(playerid);
    SavePlayerVoiceConfig(playerid);
    SendClientMessage(playerid, -1, "{FF5555}[Voice] Your microphone is muted.");
    return 1;
}

CMD:voiceunmute(playerid, const params[])
{
    v_SelfMuted[playerid] = false;
    SavePlayerVoiceConfig(playerid);
    SendClientMessage(playerid, -1, "{77DD77}[Voice] Your microphone is active.");
    return 1;
}

CMD:radiotalk(playerid, const params[])
{
    if(Inventory_Count(playerid, "Portable Radio") < 1)
        return SendClientMessage(playerid, -1, "You need a Portable Radio to transmit.");
    if(PlayerInfo[playerid][pToggleWT] || v_RadioMuted[playerid] || v_Deafened[playerid])
        return SendClientMessage(playerid, -1, "Your radio is disabled or muted.");
    if(v_SelfMuted[playerid])
        return SendClientMessage(playerid, -1, "Your microphone is muted. Use /voiceunmute first.");
    if(is_pressing_wt[playerid])
    {
        ProcessRadioRelease(playerid);
        SendClientMessage(playerid, -1, "{6CB4EE}[Radio] {FFFFFF}Transmission stopped.");
    }
    else
    {
        if(!ProcessRadioPress(playerid))
            return SendClientMessage(playerid, -1, "Unable to transmit. Check your radio channel and status.");
        if(!is_pressing_wt[playerid])
            return SendClientMessage(playerid, -1, "Unable to transmit on this channel.");
        SendClientMessage(playerid, -1, "{6CB4EE}[Radio] {FFFFFF}Transmitting. Use /radiotalk again to stop.");
    }
    return 1;
}

CMD:voiceconfig(playerid, const params[])
{
    ShowVoiceConfigMainMenu(playerid);
    return 1;
}

CMD:vrange(playerid, const params[])
{
    v_VoiceRange[playerid] = (v_VoiceRange[playerid] % 3) + 1;
    UpdatePlayerVoiceRange(playerid);
    SavePlayerVoiceConfig(playerid);

    if(v_VoiceRange[playerid] == 1) SendClientMessage(playerid, 0xFFFF00FF, "[Voice] Speak Range set to: Whisper (3 Meters)");
    else if(v_VoiceRange[playerid] == 2) SendClientMessage(playerid, 0x00FF00FF, "[Voice] Speak Range set to: Normal (10 Meters)");
    else SendClientMessage(playerid, 0xFF0000FF, "[Voice] Speak Range set to: Shout (25 Meters)");

    return 1;
}


CMD:vmute(playerid, const params[])
{
    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, "Usage: /vmute [playerid/name]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "{FF0000}[Error] Player is not connected.");

    p_VoiceVolume[playerid][targetid] = (p_VoiceVolume[playerid][targetid] == 0) ? 100 : 0;

    if(p_VoiceVolume[playerid][targetid] == 0) SendClientMessage(playerid, -1, "{FF0000}[Voice] You have muted player %s.", GetRPName(targetid));
    else SendClientMessage(playerid, -1, "{00FF00}[Voice] You have unmuted player %s.", GetRPName(targetid));

    return 1;
}

CMD:vvol(playerid, const params[])
{
    new targetid, vol;
    if(sscanf(params, "ui", targetid, vol)) return SendClientMessage(playerid, -1, "Usage: /vvol [playerid/name] [volume 0-100]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "{FF0000}[Error] Player is not connected.");
    if(vol < 0 || vol > 100) return SendClientMessage(playerid, -1, "{FF0000}[Error] Volume level must range between 0 and 100!");

    p_VoiceVolume[playerid][targetid] = vol;

    SendClientMessage(playerid, -1, "{00FF00}[Voice] Set player %s voice volume to %d%%.", GetRPName(targetid), vol);

    return 1;
}

stock ShowVoiceConfigMainMenu(playerid)
{
    new szDialog[600];
    new range_str[16];
    if(v_VoiceRange[playerid] == 1) range_str = "Whisper (3m)";
    else if(v_VoiceRange[playerid] == 2) range_str = "Normal (10m)";
    else range_str = "Shout (25m)";

    new pos_str[20];
    if(v_HUDPos[playerid] == 0) pos_str = "Top-Right";
    else if(v_HUDPos[playerid] == 1) pos_str = "Bottom-Right";
    else pos_str = "Top-Left";

    format(szDialog, sizeof(szDialog), 
        "Option\tStatus/Setting\n\
        1. Proximity Voice Range\t{00FFFF}%s\n\
        2. Microphone Self-Mute\t%s\n\
        3. Deafen (Mute All Audio)\t%s\n\
        4. Radio Sound Channel\t%s\n\
        5. Radio Master Volume\t{FF8000}%d%%\n\
        6. Radio Click Sound FX\t%s\n\
        7. Radio HUD Position\t{FFFF00}%s\n\
        8. Per-Player Volume Adjustment\t{C0C0C0}Configure >>",
        range_str,
        v_SelfMuted[playerid] ? ("{FF0000}MUTED") : ("{00FF00}ACTIVE"),
        v_Deafened[playerid] ? ("{FF0000}DEAFENED") : ("{00FF00}ACTIVE"),
        v_RadioMuted[playerid] ? ("{FF0000}MUTED") : ("{00FF00}ACTIVE"),
        v_RadioVol[playerid],
        v_RadioFX[playerid] ? ("{00FF00}ENABLED") : ("{FF0000}DISABLED"),
        pos_str
    );

    ShowPlayerDialog(playerid, DIALOG_VOICE_MAIN, DIALOG_STYLE_TABLIST_HEADERS, "{00FFFF}» Voice & Radio Configuration", szDialog, "Select", "Close");
    return 1;
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
                    ShowPlayerDialog(playerid, DIALOG_VOICE_RANGE, DIALOG_STYLE_LIST, "Select Proximity Voice Distance", "Whisper (3 Meters)\nNormal (10 Meters)\nShout (25 Meters)", "Apply", "Back");
                }
                case 1:
                {
                    v_SelfMuted[playerid] = !v_SelfMuted[playerid];
                    SendClientMessage(playerid, -1, v_SelfMuted[playerid] ? "{FF0000}[Voice] Microphone is now Muted." : "{00FF00}[Voice] Microphone is now Active.");
                    SavePlayerVoiceConfig(playerid);
                    ShowVoiceConfigMainMenu(playerid);
                }
                case 2:
                {
                    v_Deafened[playerid] = !v_Deafened[playerid];
                    SendClientMessage(playerid, -1, v_Deafened[playerid] ? "{FF0000}[Voice] Audio Deafen Activated." : "{00FF00}[Voice] Audio Deafen Deactivated.");
                    RefreshPlayerRadioStream(playerid);
                    SavePlayerVoiceConfig(playerid);
                    ShowVoiceConfigMainMenu(playerid);
                }
                case 3:
                {
                    v_RadioMuted[playerid] = !v_RadioMuted[playerid];
                    SendClientMessage(playerid, -1, v_RadioMuted[playerid] ? "{FF0000}[Voice] Radio channel muted." : "{00FF00}[Voice] Radio channel active.");
                    RefreshPlayerRadioStream(playerid);
                    SavePlayerVoiceConfig(playerid);
                    ShowVoiceConfigMainMenu(playerid);
                }
                case 4:
                {
                    new str[160];
                    format(str, sizeof(str), "{FFFFFF}Current Master Radio Volume: {FF8000}%d%%\n\n{C0C0C0}Enter a new volume level (0 - 100):", v_RadioVol[playerid]);
                    ShowPlayerDialog(playerid, DIALOG_VOICE_VOL, DIALOG_STYLE_INPUT, "Radio Master Volume", str, "Apply", "Back");
                }
                case 5:
                {
                    v_RadioFX[playerid] = !v_RadioFX[playerid];
                    SendClientMessage(playerid, -1, v_RadioFX[playerid] ? "{00FF00}[Voice] Radio Squelch Click sound effect Enabled." : "{FF0000}[Voice] Radio Squelch Click sound effect Disabled.");
                    SavePlayerVoiceConfig(playerid);
                    ShowVoiceConfigMainMenu(playerid);
                }
                case 6:
                {
                    ShowPlayerDialog(playerid, DIALOG_VOICE_HUD_POS, DIALOG_STYLE_LIST, "Select Radio HUD Position", "Top-Right (Default)\nBottom-Right (Mobile Friendly)\nTop-Left", "Apply", "Back");
                }
                case 7:
                {
                    new list_str[1000];
                    format(list_str, sizeof(list_str), "Player ID\tName\tCustom Volume\n");

                    foreach(new i : Player)
                    {
                        if(i == playerid) continue;
                        format(list_str, sizeof(list_str), "%s%d\t%s\t%d%%\n", list_str, i, GetRPName(i), p_VoiceVolume[playerid][i]);
                    }

                    ShowPlayerDialog(playerid, DIALOG_VOICE_PLAYER_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Player Volume Controls", list_str, "Adjust", "Back");
                }
            }
        }
        case DIALOG_VOICE_RANGE:
        {
            if(!response) return ShowVoiceConfigMainMenu(playerid);
            v_VoiceRange[playerid] = listitem + 1;
            UpdatePlayerVoiceRange(playerid);
            SavePlayerVoiceConfig(playerid);
            ShowVoiceConfigMainMenu(playerid);
        }
        case DIALOG_VOICE_VOL:
        {
            if(!response) return ShowVoiceConfigMainMenu(playerid);
            new vol = strval(inputtext);
            if(vol < 0 || vol > 100) return SendClientMessage(playerid, -1, "{FF0000}[Error] Volume must range between 0 and 100!"), ShowVoiceConfigMainMenu(playerid);

            v_RadioVol[playerid] = vol;
            v_RadioMuted[playerid] = false; 
            RefreshPlayerRadioStream(playerid);
            SavePlayerVoiceConfig(playerid);
            ShowVoiceConfigMainMenu(playerid);
        }
        case DIALOG_VOICE_HUD_POS:
        {
            if(!response) return ShowVoiceConfigMainMenu(playerid);
            v_HUDPos[playerid] = listitem;
            ReloadRadioTDPosition(playerid);
            SavePlayerVoiceConfig(playerid);
            ShowVoiceConfigMainMenu(playerid);
        }
        case DIALOG_VOICE_PLAYER_LIST:
        {
            if(!response) return ShowVoiceConfigMainMenu(playerid);
            
            new targetid = strval(inputtext);
            if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "{FF0000}[Error] Selected player disconnected."), ShowVoiceConfigMainMenu(playerid);

            g_SelectedPlayer[playerid] = targetid;
            
            new str[180];
            format(str, sizeof(str), "{FFFFFF}Adjusting Voice Volume for: {00FFFF}%s (ID: %d)\n{FFFFFF}Current Setting: {FF8000}%d%%\n\n{C0C0C0}Enter a volume value (0 - 100) or '0' to Mute:", GetRPName(targetid), targetid, p_VoiceVolume[playerid][targetid]);
            ShowPlayerDialog(playerid, DIALOG_VOICE_PLAYER_SET, DIALOG_STYLE_INPUT, "Per-Player Volume", str, "Apply", "Back");
        }
        case DIALOG_VOICE_PLAYER_SET:
        {
            if(!response) return ShowVoiceConfigMainMenu(playerid);
            new targetid = g_SelectedPlayer[playerid];
            
            if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "{FF0000}[Error] Selected player disconnected."), ShowVoiceConfigMainMenu(playerid);

            new vol = strval(inputtext);
            if(vol < 0 || vol > 100) return SendClientMessage(playerid, -1, "{FF0000}[Error] Volume must range between 0 and 100!"), ShowVoiceConfigMainMenu(playerid);

            p_VoiceVolume[playerid][targetid] = vol;
            
            SendClientMessage(playerid, -1, "{00FF00}[Voice] Volume setting for %s updated to %d%%.", GetRPName(targetid), vol);
            
            ShowVoiceConfigMainMenu(playerid);
        }
    }
    return 1;
}

CMD:channel(playerid, const params[])
{
	new channel;
	if(Inventory_Count(playerid, "Portable Radio") < 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a Portable Radio.");
	}
	if(sscanf(params, "i", channel))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /channel [freq]");
	}
	if(!(0 <= channel <= 9999999))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The channel must range from 0 to 9999999.");
	}

	new faction = PlayerInfo[playerid][pFaction];
	if(0 <= channel <= 4)
	{
		if(faction < 1 || faction > 4) 
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "Channels 0 to 4 are restricted to Government Departments only.");
		}
	}

	PlayerInfo[playerid][pChannel] = channel;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET channel = %i WHERE uid = %i", channel, PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer);

	RefreshPlayerRadioStream(playerid);

	if(channel == 0) SendMessage(playerid, COLOR_WHITE, "** Tuned into Channel 0 (All Departments Frequency).");
	else if(channel == 1) SendMessage(playerid, COLOR_WHITE, "** Tuned into Channel 1 (PNP Emergency Frequency).");
	else if(channel == 2) SendMessage(playerid, COLOR_WHITE, "** Tuned into Channel 2 (EMS Emergency Frequency).");
	else if(channel == 3) SendMessage(playerid, COLOR_WHITE, "** Tuned into Channel 3 (GOV Government Frequency).");
	else if(channel == 4) SendMessage(playerid, COLOR_WHITE, "** Tuned into Channel 4 (AFP Military Frequency).");
	else SendMessage(playerid, COLOR_WHITE, "** Channel set to %i, use /pr or hold [R] to broadcast over this channel.", channel);

	return 1;
}

CMD:pr(playerid, const params[])
{
    if(Inventory_Count(playerid, "Portable Radio") < 1) return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a Portable Radio.");
	if(isnull(params)) return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /pr [text]");
    if(PlayerInfo[playerid][pToggleWT]) return SendClientMessage(playerid, COLOR_SYNTAX, "You can't speak in your Portable Radio as you have it toggled.");
	if(PlayerInfo[playerid][pInjured] || PlayerInfo[playerid][pCuffed] || PlayerInfo[playerid][pTied]) return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use this command right now.");

	new freq = PlayerInfo[playerid][pChannel];

	foreach(new i : Player)
	{
		if(Inventory_Count(i, "Portable Radio") < 1 || PlayerInfo[i][pToggleWT]) continue;

		new bool:can_hear = false;

		if(freq == 0 && (1 <= PlayerInfo[i][pFaction] <= 4)) can_hear = true;
		else if(freq == 1 && PlayerInfo[i][pFaction] == 1) can_hear = true;
		else if(freq == 2 && PlayerInfo[i][pFaction] == 2) can_hear = true;
		else if(freq == 3 && PlayerInfo[i][pFaction] == 3) can_hear = true;
		else if(freq == 4 && PlayerInfo[i][pFaction] == 4) can_hear = true;
		else if(freq >= 5 && PlayerInfo[i][pChannel] == freq) can_hear = true;

		if(can_hear)
		{
		    if(strlen(params) > MAX_SPLIT_LENGTH)
		    {
				SendMessage(i, 0x6DFB6DFF, "** Radio (%i mhz) ** %s: %.*s...", freq, GetRPName(playerid), MAX_SPLIT_LENGTH, params);
				SendMessage(i, 0x6DFB6DFF, "** Radio (%i mhz) ** %s: ...%s", freq, GetRPName(playerid), params[MAX_SPLIT_LENGTH]);
			}
			else
			{
			    SendMessage(i, 0x6DFB6DFF, "** Radio (%i mhz) ** %s: %s", freq, GetRPName(playerid), params);
			}
		}
	}

    SetPlayerBubbleText(playerid, 5.0, 0x6DFB6DFF, "(Radio) %s", params);
	return 1;
}