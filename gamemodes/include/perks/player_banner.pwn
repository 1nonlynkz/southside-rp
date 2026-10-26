
#include <YSI_Coding\y_hooks>
#include <pef> 

enum e_WELCOME_BANNER_DATA {
    bool:b_HasBanner,
    b_CustomName[MAX_PLAYER_NAME],
    b_TXDSprite[64],
    bool:b_PlayMusic,
    b_MusicURL[128],
    b_AnimationStyle,
    b_Expiration[32]
}
new PlayerBanner[MAX_PLAYERS][e_WELCOME_BANNER_DATA];
new AdminEditingTarget[MAX_PLAYERS][MAX_PLAYER_NAME];

new PlayerText:WelcomeBannerGlobalTD[MAX_PLAYERS][5];

new const PresetSpriteNames[][32] = {
    "Loading Scene Aspect 1",  
    "Loading Scene Aspect 4",  
    "Loading Scene Aspect 3",  
    "Graffiti Sky Palette",   
    "Dual Screen Background"
};

new const PresetSpritePaths[][32] = {
    "loadsc1:loadsc1",
    "loadsc4:loadsc4",
    "loadsc3:loadsc3",
    "ld_grav:sky",
    "ld_dual:backgrnd"
};

new const AnimationStyleNames[][] = {
    "Geforce Stretch & Slide",
    "Smooth Fade In & Out",
    "Drop Down & Bounce",
    "Left-to-Right Fly-in",
    "Scale Zoom Pop",
    "Diagonal Corner Slide",
    "Elastic Snap Reveal",
    "Cinematic Curtain Reveal",
    "Smooth Rise Up"
};

stock SetBannerBasePositions(playerid, Float:offX = 0.0, Float:offY = 0.0)
{
    for(new i = 0; i < 5; i++) {
        if(WelcomeBannerGlobalTD[playerid][i] != INVALID_PLAYER_TEXT_DRAW) {
            PlayerTextDrawDestroy(playerid, WelcomeBannerGlobalTD[playerid][i]);
        }
    }

    WelcomeBannerGlobalTD[playerid][0] = CreatePlayerTextDraw(playerid, 572.000000 + offX, 325.000000 + offY, "_");
    PlayerTextDrawFont(playerid, WelcomeBannerGlobalTD[playerid][0], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, WelcomeBannerGlobalTD[playerid][0], 0.600000, 9.099998);
    PlayerTextDrawTextSize(playerid, WelcomeBannerGlobalTD[playerid][0], 296.000000, 118.500000); 
    PlayerTextDrawSetOutline(playerid, WelcomeBannerGlobalTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, WelcomeBannerGlobalTD[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, WelcomeBannerGlobalTD[playerid][0], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColor(playerid, WelcomeBannerGlobalTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, WelcomeBannerGlobalTD[playerid][0], 255);
    PlayerTextDrawBoxColor(playerid, WelcomeBannerGlobalTD[playerid][0], 255);
    PlayerTextDrawUseBox(playerid, WelcomeBannerGlobalTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, WelcomeBannerGlobalTD[playerid][0], 1);

    WelcomeBannerGlobalTD[playerid][1] = CreatePlayerTextDraw(playerid, 512.000000 + offX, 334.000000 + offY, "loadsc8:loadsc8");
    PlayerTextDrawFont(playerid, WelcomeBannerGlobalTD[playerid][1], TEXT_DRAW_FONT_SPRITE);
    PlayerTextDrawLetterSize(playerid, WelcomeBannerGlobalTD[playerid][1], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, WelcomeBannerGlobalTD[playerid][1], 120.000000, 64.500000);
    PlayerTextDrawSetOutline(playerid, WelcomeBannerGlobalTD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, WelcomeBannerGlobalTD[playerid][1], 0);
    PlayerTextDrawAlignment(playerid, WelcomeBannerGlobalTD[playerid][1], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, WelcomeBannerGlobalTD[playerid][1], 0xFFFFFFFF); 
    PlayerTextDrawBackgroundColor(playerid, WelcomeBannerGlobalTD[playerid][1], 255);
    PlayerTextDrawBoxColor(playerid, WelcomeBannerGlobalTD[playerid][1], 50);
    PlayerTextDrawUseBox(playerid, WelcomeBannerGlobalTD[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, WelcomeBannerGlobalTD[playerid][1], 1);

    WelcomeBannerGlobalTD[playerid][2] = CreatePlayerTextDraw(playerid, 537.000000 + offX, 323.000000 + offY, "WELCOME TO");
    PlayerTextDrawFont(playerid, WelcomeBannerGlobalTD[playerid][2], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, WelcomeBannerGlobalTD[playerid][2], 0.166666, 1.149999);
    PlayerTextDrawTextSize(playerid, WelcomeBannerGlobalTD[playerid][2], 425.000000, 107.000000);
    PlayerTextDrawSetOutline(playerid, WelcomeBannerGlobalTD[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, WelcomeBannerGlobalTD[playerid][2], 1);
    PlayerTextDrawAlignment(playerid, WelcomeBannerGlobalTD[playerid][2], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColor(playerid, WelcomeBannerGlobalTD[playerid][2], 0xFFFFFFFF); 
    PlayerTextDrawBackgroundColor(playerid, WelcomeBannerGlobalTD[playerid][2], 255);

    WelcomeBannerGlobalTD[playerid][3] = CreatePlayerTextDraw(playerid, 595.000000 + offX, 323.000000 + offY, "CAPITAL ROLEPLAY!");
    PlayerTextDrawFont(playerid, WelcomeBannerGlobalTD[playerid][3], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, WelcomeBannerGlobalTD[playerid][3], 0.166666, 1.149999);
    PlayerTextDrawTextSize(playerid, WelcomeBannerGlobalTD[playerid][3], 425.000000, 107.000000);
    PlayerTextDrawSetOutline(playerid, WelcomeBannerGlobalTD[playerid][3], 0);
    PlayerTextDrawSetShadow(playerid, WelcomeBannerGlobalTD[playerid][3], 1);
    PlayerTextDrawAlignment(playerid, WelcomeBannerGlobalTD[playerid][3], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColor(playerid, WelcomeBannerGlobalTD[playerid][3], 0xFFFFFFFF); 
    PlayerTextDrawBackgroundColor(playerid, WelcomeBannerGlobalTD[playerid][3], 255);

    WelcomeBannerGlobalTD[playerid][4] = CreatePlayerTextDraw(playerid, 574.000000 + offX, 397.500000 + offY, "FAJARDO");
    PlayerTextDrawFont(playerid, WelcomeBannerGlobalTD[playerid][4], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, WelcomeBannerGlobalTD[playerid][4], 0.166666, 1.149999);
    PlayerTextDrawTextSize(playerid, WelcomeBannerGlobalTD[playerid][4], 425.000000, 107.000000);
    PlayerTextDrawSetOutline(playerid, WelcomeBannerGlobalTD[playerid][4], 0);
    PlayerTextDrawSetShadow(playerid, WelcomeBannerGlobalTD[playerid][4], 1);
    PlayerTextDrawAlignment(playerid, WelcomeBannerGlobalTD[playerid][4], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColor(playerid, WelcomeBannerGlobalTD[playerid][4], 0xFFFFFFFF); 
    PlayerTextDrawBackgroundColor(playerid, WelcomeBannerGlobalTD[playerid][4], 255);
    return 1;
}

hook OnPlayerConnect(playerid)
{
    for(new i = 0; i < 5; i++) {
        WelcomeBannerGlobalTD[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
    }

    new queryStr[256], currentName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, currentName, sizeof(currentName));
    
    mysql_format(connectionID, queryStr, sizeof(queryStr), "SELECT *, IF(NOW() > `expire_date`, 1, 0) as `is_expired` FROM `player_banners` WHERE `username` = '%e' LIMIT 1", currentName);
    mysql_tquery(connectionID, queryStr, "OnLoadPlayerBanner", "i", playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(WelcomeBannerGlobalTD[playerid][0] != INVALID_PLAYER_TEXT_DRAW) {
        for(new i = 0; i < 5; i++) {
            PlayerTextDrawDestroy(playerid, WelcomeBannerGlobalTD[playerid][i]);
            WelcomeBannerGlobalTD[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
    }
    return 1;
}

stock ShowAnimatedWelcomeBanner(playerid, const customName[], const spriteAsset[], const audioURL[], bool:playMusic, animType)
{
    switch(animType)
    {
        case 0: // Geforce Style
        {
            SetBannerBasePositions(playerid, 0.0, 0.0);
            PlayerTextDrawTextSize(playerid, WelcomeBannerGlobalTD[playerid][0], 0.000000, 118.500000);
            for(new i = 1; i <= 4; i++) PlayerTextDrawColor(playerid, WelcomeBannerGlobalTD[playerid][i], 0xFFFFFF00);
        }
        case 1: // Fade In & Out
        {
            SetBannerBasePositions(playerid, 0.0, 0.0);
            for(new i = 0; i <= 4; i++) PlayerTextDrawColor(playerid, WelcomeBannerGlobalTD[playerid][i], 0xFFFFFF00);
        }
        case 2: SetBannerBasePositions(playerid, 0.0, -420.0); // Drop Down
        case 3: SetBannerBasePositions(playerid, -650.0, 0.0); // Left Fly-in
        case 4: // Scale Zoom Pop
        {
            SetBannerBasePositions(playerid, 0.0, 0.0);
            PlayerTextDrawTextSize(playerid, WelcomeBannerGlobalTD[playerid][0], 0.000000, 0.000000);
            for(new i = 0; i <= 4; i++) PlayerTextDrawColor(playerid, WelcomeBannerGlobalTD[playerid][i], 0xFFFFFF00);
        }
        case 5: SetBannerBasePositions(playerid, 400.0, -400.0); // Diagonal
        case 6: SetBannerBasePositions(playerid, 650.0, 0.0); // Elastic Snap Right
        case 7: // Curtain Reveal
        {
            SetBannerBasePositions(playerid, 0.0, 0.0);
            PlayerTextDrawTextSize(playerid, WelcomeBannerGlobalTD[playerid][0], 0.000000, 118.500000);
            for(new i = 1; i <= 4; i++) PlayerTextDrawColor(playerid, WelcomeBannerGlobalTD[playerid][i], 0xFFFFFF00);
        }
        case 8: SetBannerBasePositions(playerid, 0.0, 250.0); // Smooth Rise Up
    }

    PlayerTextDrawSetString(playerid, WelcomeBannerGlobalTD[playerid][4], customName);
    PlayerTextDrawSetString(playerid, WelcomeBannerGlobalTD[playerid][1], spriteAsset);

    for(new i = 0; i < 5; i++) PlayerTextDrawShow(playerid, WelcomeBannerGlobalTD[playerid][i]);

    if(animType == 0 || animType == 7) {
        PlayerText_MoveTextSize(playerid, WelcomeBannerGlobalTD[playerid][0], 296.000000, 500, EASE_OUT_QUART);
        SetTimerEx("AnimationEntryPhases", 500, false, "iii", playerid, 1, animType);
    } else {
        SetTimerEx("AnimationEntryPhases", 30, false, "iii", playerid, 0, animType);
    }

    if(playMusic && strlen(audioURL) > 4) PlayAudioStreamForPlayer(playerid, audioURL);
    return 1;
}

forward AnimationEntryPhases(playerid, phase, animType);
public AnimationEntryPhases(playerid, phase, animType)
{
    switch(animType)
    {
        case 0, 7: 
        {
            for(new i = 1; i <= 4; i++) {
                PlayerText_PlaceOnTop(playerid, WelcomeBannerGlobalTD[playerid][i]);
                PlayerText_InterpolateColor(playerid, WelcomeBannerGlobalTD[playerid][i], 0xFFFFFFFF, 300, EASE_OUT_QUAD);
            }
            SetTimerEx("AnimationExitPhases", 2500, false, "iii", playerid, 0, animType);
        }
        case 1: 
        {
            for(new i = 0; i <= 4; i++) PlayerText_InterpolateColor(playerid, WelcomeBannerGlobalTD[playerid][i], 0xFFFFFFFF, 500, EASE_OUT_QUAD);
            SetTimerEx("AnimationExitPhases", 2500, false, "iii", playerid, 0, animType);
        }
        case 2: 
        {
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][0], 572.000000, 325.000000, 700, EASE_OUT_BOUNCE);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][1], 512.000000, 334.000000, 700, EASE_OUT_BOUNCE);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][2], 537.000000, 323.000000, 700, EASE_OUT_BOUNCE);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][3], 595.000000, 323.000000, 700, EASE_OUT_BOUNCE);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][4], 574.000000, 397.500000, 700, EASE_OUT_BOUNCE);
            SetTimerEx("AnimationExitPhases", 2500, false, "iii", playerid, 0, animType);
        }
        case 3: 
        {
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][0], 572.000000, 325.000000, 600, EASE_OUT_BACK);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][1], 512.000000, 334.000000, 600, EASE_OUT_BACK);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][2], 537.000000, 323.000000, 600, EASE_OUT_BACK);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][3], 595.000000, 323.000000, 600, EASE_OUT_BACK);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][4], 574.000000, 397.500000, 600, EASE_OUT_BACK);
            SetTimerEx("AnimationExitPhases", 2500, false, "iii", playerid, 0, animType);
        }
        case 4: 
        {
            PlayerText_MoveTextSize(playerid, WelcomeBannerGlobalTD[playerid][0], 296.000000, 450, EASE_OUT_BACK);
            for(new i = 0; i <= 4; i++) PlayerText_InterpolateColor(playerid, WelcomeBannerGlobalTD[playerid][i], 0xFFFFFFFF, 350, EASE_OUT_QUAD);
            SetTimerEx("AnimationExitPhases", 2500, false, "iii", playerid, 0, animType);
        }
        case 5: 
        {
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][0], 572.000000, 325.000000, 650, EASE_OUT_CUBIC);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][1], 512.000000, 334.000000, 650, EASE_OUT_CUBIC);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][2], 537.000000, 323.000000, 650, EASE_OUT_CUBIC);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][3], 595.000000, 323.000000, 650, EASE_OUT_CUBIC);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][4], 574.000000, 397.500000, 650, EASE_OUT_CUBIC);
            SetTimerEx("AnimationExitPhases", 2500, false, "iii", playerid, 0, animType);
        }
        case 6: 
        {
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][0], 572.000000, 325.000000, 800, EASE_OUT_ELASTIC);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][1], 512.000000, 334.000000, 800, EASE_OUT_ELASTIC);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][2], 537.000000, 323.000000, 800, EASE_OUT_ELASTIC);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][3], 595.000000, 323.000000, 800, EASE_OUT_ELASTIC);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][4], 574.000000, 397.500000, 800, EASE_OUT_ELASTIC);
            SetTimerEx("AnimationExitPhases", 2500, false, "iii", playerid, 0, animType);
        }
        case 8: 
        {
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][0], 572.000000, 325.000000, 600, EASE_OUT_QUINT);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][1], 512.000000, 334.000000, 600, EASE_OUT_QUINT);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][2], 537.000000, 323.000000, 600, EASE_OUT_QUINT);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][3], 595.000000, 323.000000, 600, EASE_OUT_QUINT);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][4], 574.000000, 397.500000, 600, EASE_OUT_QUINT);
            SetTimerEx("AnimationExitPhases", 2500, false, "iii", playerid, 0, animType);
        }
    }
    return 1;
}

forward AnimationExitPhases(playerid, phase, animType);
public AnimationExitPhases(playerid, phase, animType)
{
    switch(animType)
    {
        case 0, 7: 
        {
            if(phase == 0) {
                for(new i = 1; i <= 4; i++) PlayerText_InterpolateColor(playerid, WelcomeBannerGlobalTD[playerid][i], 0xFFFFFF00, 250, EASE_OUT_QUAD);
                SetTimerEx("AnimationExitPhases", 300, false, "iii", playerid, 1, animType);
            } else if(phase == 1) {
                PlayerText_MoveTextSize(playerid, WelcomeBannerGlobalTD[playerid][0], 0.000000, 450, EASE_OUT_QUART);
                SetTimerEx("Banner_Cleanup", 500, false, "i", playerid);
            }
        }
        case 1: 
        {
            for(new i = 0; i <= 4; i++) PlayerText_InterpolateColor(playerid, WelcomeBannerGlobalTD[playerid][i], 0xFFFFFF00, 500, EASE_OUT_QUAD);
            SetTimerEx("Banner_Cleanup", 550, false, "i", playerid);
        }
        case 2: 
        {
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][0], 572.000000, -420.000000, 500, EASE_IN_BACK);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][1], 512.000000, -411.000000, 500, EASE_IN_BACK);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][2], 537.000000, -422.000000, 500, EASE_IN_BACK);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][3], 595.000000, -422.000000, 500, EASE_IN_BACK);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][4], 574.000000, -347.500000, 500, EASE_IN_BACK);
            SetTimerEx("Banner_Cleanup", 550, false, "i", playerid);
        }
        case 3: 
        {
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][0], -650.000000, 325.000000, 500, EASE_IN_QUAD);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][1], -710.000000, 334.000000, 500, EASE_IN_QUAD);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][2], -685.000000, 323.000000, 500, EASE_IN_QUAD);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][3], -627.000000, 323.000000, 500, EASE_IN_QUAD);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][4], -648.000000, 397.500000, 500, EASE_IN_QUAD);
            SetTimerEx("Banner_Cleanup", 550, false, "i", playerid);
        }
        case 4: 
        {
            PlayerText_MoveTextSize(playerid, WelcomeBannerGlobalTD[playerid][0], 0.000000, 400, EASE_IN_BACK);
            for(new i = 0; i <= 4; i++) PlayerText_InterpolateColor(playerid, WelcomeBannerGlobalTD[playerid][i], 0xFFFFFF00, 350, EASE_OUT_QUAD);
            SetTimerEx("Banner_Cleanup", 450, false, "i", playerid);
        }
        case 5: 
        {
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][0], 400.000000, -400.000000, 500, EASE_IN_CUBIC);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][1], 340.000000, -391.000000, 500, EASE_IN_CUBIC);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][2], 365.000000, -402.000000, 500, EASE_IN_CUBIC);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][3], 423.000000, -402.000000, 500, EASE_IN_CUBIC);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][4], 402.000000, -327.500000, 500, EASE_IN_CUBIC);
            SetTimerEx("Banner_Cleanup", 550, false, "i", playerid);
        }
        case 6: 
        {
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][0], 650.000000, 325.000000, 450, EASE_IN_BACK);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][1], 590.000000, 334.000000, 450, EASE_IN_BACK);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][2], 615.000000, 323.000000, 450, EASE_IN_BACK);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][3], 673.000000, 323.000000, 450, EASE_IN_BACK);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][4], 652.000000, 397.500000, 450, EASE_IN_BACK);
            SetTimerEx("Banner_Cleanup", 500, false, "i", playerid);
        }
        case 8: 
        {
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][0], 572.000000, -300.000000, 500, EASE_IN_QUAD);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][1], 512.000000, -291.000000, 500, EASE_IN_QUAD);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][2], 537.000000, -302.000000, 500, EASE_IN_QUAD);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][3], 595.000000, -302.000000, 500, EASE_IN_QUAD);
            PlayerText_MoveTo(playerid, WelcomeBannerGlobalTD[playerid][4], 574.000000, -227.500000, 500, EASE_IN_QUAD);
            SetTimerEx("Banner_Cleanup", 550, false, "i", playerid);
        }
    }
    return 1;
}

forward Banner_Cleanup(playerid);
public Banner_Cleanup(playerid)
{
    for(new i = 0; i < 5; i++) {
        PlayerTextDrawHide(playerid, WelcomeBannerGlobalTD[playerid][i]);
    }
    StopAudioStreamForPlayer(playerid);
    return 1;
}

forward OnLoadPlayerBanner(playerid);
public OnLoadPlayerBanner(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields, connectionID);
    
    if(rows > 0)
    {
        new isExpired = cache_get_field_content_int(0, "is_expired", connectionID);
        if(isExpired == 1) {
            PlayerBanner[playerid][b_HasBanner] = false;
            return 1;
        }

        PlayerBanner[playerid][b_HasBanner] = true;
        cache_get_field_content(0, "custom_name", PlayerBanner[playerid][b_CustomName], connectionID, MAX_PLAYER_NAME);
        cache_get_field_content(0, "txd_sprite", PlayerBanner[playerid][b_TXDSprite], connectionID, 64);
        cache_get_field_content(0, "music_url", PlayerBanner[playerid][b_MusicURL], connectionID, 128);
        PlayerBanner[playerid][b_AnimationStyle] = cache_get_field_content_int(0, "animation_style", connectionID);
        
        new musicStr[4];
        cache_get_field_content(0, "play_music", musicStr, connectionID, sizeof(musicStr));
        PlayerBanner[playerid][b_PlayMusic] = (strval(musicStr) == 1) ? true : false;
        cache_get_field_content(0, "expire_date", PlayerBanner[playerid][b_Expiration], connectionID, 32);
    }
    else PlayerBanner[playerid][b_HasBanner] = false;
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    if(PlayerBanner[playerid][b_HasBanner])
    {
        ShowAnimatedWelcomeBanner(
            playerid,
            PlayerBanner[playerid][b_CustomName], 
            PlayerBanner[playerid][b_TXDSprite], 
            PlayerBanner[playerid][b_MusicURL], 
            PlayerBanner[playerid][b_PlayMusic],
            PlayerBanner[playerid][b_AnimationStyle]
        );
    }
    return 1;
}

forward OpenAdminConfigMenu(playerid, const targetName[]);
public OpenAdminConfigMenu(playerid, const targetName[])
{
    format(AdminEditingTarget[playerid], MAX_PLAYER_NAME, "%s", targetName);

    new queryStr[128];
    mysql_format(connectionID, queryStr, sizeof(queryStr), "SELECT * FROM `player_banners` WHERE `username` = '%e' LIMIT 1", targetName);
    mysql_tquery(connectionID, queryStr, "OnAdminConfigLoaded", "d", playerid);
    return 1;
}

forward OnAdminConfigLoaded(playerid);
public OnAdminConfigLoaded(playerid)
{
    if(!cache_get_row_count()) 
        return SendClientMessage(playerid, COLOR_LIGHTRED, "AdmCmd: Target account banner not found.");

    new adminCustomName[MAX_PLAYER_NAME], sprite[64], mURL[128], exp[32], pMusic, animType;
    
    cache_get_field_content(0, "custom_name", adminCustomName, connectionID, sizeof(adminCustomName));
    cache_get_field_content(0, "txd_sprite", sprite, connectionID, sizeof(sprite));
    cache_get_field_content(0, "music_url", mURL, connectionID, sizeof(mURL));
    cache_get_field_content(0, "expire_date", exp, connectionID, sizeof(exp));
    
    pMusic = cache_get_field_content_int(0, "play_music", connectionID);
    animType = cache_get_field_content_int(0, "animation_style", connectionID);

    new dialogStr[512];
    format(dialogStr, sizeof(dialogStr), 
        "Setting\tValue\n\
        {FFFFFF}Account\t{9ACD32}%s\n\
        {FFFFFF}Custom Name\t{9ACD32}%s\n\
        {FFFFFF}Sprite Icon\t{9ACD32}%s\n\
        {FFFFFF}Animation\t{9ACD32}%s\n\
        {FFFFFF}Audio Status\t{9ACD32}%s\n\
        {FFFFFF}Audio Link\t{9ACD32}Change URL\n\
        {FFFFFF}Expiration\t{9ACD32}%s\n\
        {FFFFFF}Test Preview\t{9ACD32}Play Banner",
        AdminEditingTarget[playerid], adminCustomName, sprite, AnimationStyleNames[animType], (pMusic == 1) ? ("Enabled") : ("Disabled"), exp
    );

    ShowPlayerDialog(playerid, DIALOG_BANNER_MAIN, DIALOG_STYLE_TABLIST_HEADERS, "Banner Settings", dialogStr, "Select", "Cancel");
    return 1;
}

CMD:editbanner(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 5) 
        return SendClientMessage(playerid, COLOR_LIGHTRED, "AdmCmd: Unauthorized access.");

    new target;
    if(sscanf(params, "u", target)) 
        return SendClientMessage(playerid, COLOR_GREY, "[USAGE]: /editbanner [playerid/name]");

    if(!IsPlayerConnected(target)) 
        return SendClientMessage(playerid, COLOR_LIGHTRED, "AdmCmd: Invalid player ID or name.");

    new targetName[MAX_PLAYER_NAME];
    GetPlayerName(target, targetName, sizeof(targetName));

    OpenAdminConfigMenu(playerid, targetName);
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_BANNER_MAIN)
    {
        if(!response) return 1; 
        switch(listitem)
        {
            case 1: ShowPlayerDialog(playerid, DIALOG_BANNER_NAME, DIALOG_STYLE_INPUT, "Modify Custom Text Line", "Enter target custom phrase:", "Save", "Back");
            case 2: { 
                new spriteMenu[512]; format(spriteMenu, sizeof(spriteMenu), "Asset Name\tSystem Code Reference\n");
                for(new i = 0; i < sizeof(PresetSpritePaths); i++) {
                    format(spriteMenu, sizeof(spriteMenu), "%s%s\t%s\n", spriteMenu, PresetSpriteNames[i], PresetSpritePaths[i]);
                }
                ShowPlayerDialog(playerid, DIALOG_BANNER_SPRITE, DIALOG_STYLE_TABLIST_HEADERS, "Select Preset Emblem Asset", spriteMenu, "Select", "Back");
            }
            case 3: { 
                new animMenu[800];
                format(animMenu, sizeof(animMenu), "ID\tAnimation Style Engine\n");
                for(new i = 0; i < sizeof(AnimationStyleNames); i++) {
                    format(animMenu, sizeof(animMenu), "%s%d.\t%s\n", animMenu, i, AnimationStyleNames[i]);
                }
                ShowPlayerDialog(playerid, DIALOG_BANNER_ANIM, DIALOG_STYLE_TABLIST_HEADERS, "Select Animation Motion", animMenu, "Select", "Back");
            }
            case 4: {
                new q[256];
                mysql_format(connectionID, q, sizeof(q), "UPDATE `player_banners` SET `play_music` = 1 - `play_music` WHERE `username` = '%e'", AdminEditingTarget[playerid]);
                mysql_query(connectionID, q);
                SendClientMessage(playerid, COLOR_YGREEN, "AdmCmd: Audio status updated.");
                OpenAdminConfigMenu(playerid, AdminEditingTarget[playerid]); 
            }
            case 5: ShowPlayerDialog(playerid, DIALOG_BANNER_URL, DIALOG_STYLE_INPUT, "Modify Link URL", "Enter direct audio stream path URL:", "Save", "Back");
            case 7: { 
                new q[256], previewCustomName[MAX_PLAYER_NAME], sprite[64], mURL[128], pMusic, animType;
                mysql_format(connectionID, q, sizeof(q), "SELECT * FROM `player_banners` WHERE `username` = '%e' LIMIT 1", AdminEditingTarget[playerid]);
                new Cache:check = mysql_query(connectionID, q);
                if(cache_get_row_count() > 0) {
                    cache_get_field_content(0, "custom_name", previewCustomName, connectionID, MAX_PLAYER_NAME);
                    cache_get_field_content(0, "txd_sprite", sprite, connectionID, 64);
                    cache_get_field_content(0, "music_url", mURL, connectionID, 128);
                    pMusic = cache_get_field_content_int(0, "play_music", connectionID);
                    animType = cache_get_field_content_int(0, "animation_style", connectionID);
                    
                    ShowAnimatedWelcomeBanner(playerid, previewCustomName, sprite, mURL, (pMusic == 1) ? true : false, animType);
                    SendClientMessage(playerid, COLOR_YGREEN, "AdmCmd: Local test animation executed.");
                }
                cache_delete(check);
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_BANNER_ANIM)
    {
        if(!response) return OpenAdminConfigMenu(playerid, AdminEditingTarget[playerid]);
        new q[256];
        mysql_format(connectionID, q, sizeof(q), "UPDATE `player_banners` SET `animation_style` = %d WHERE `username` = '%e'", listitem, AdminEditingTarget[playerid]);
        mysql_tquery(connectionID, q);
        SendClientMessage(playerid, COLOR_YGREEN, "AdmCmd: Animation style updated.");
        OpenAdminConfigMenu(playerid, AdminEditingTarget[playerid]);
        return 1;
    }
    return 0;
}
