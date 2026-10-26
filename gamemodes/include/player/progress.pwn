#include <YSI_Coding\y_hooks>

// progress
new Text:progress_bar_TD[3];
new PlayerText:progress_bar_PTD[MAX_PLAYERS][3];
new player_progress_type[MAX_PLAYERS];
new player_progress_step[MAX_PLAYERS]; // 15 step
new player_progress_title[MAX_PLAYERS][32];
new progress_key[MAX_PLAYERS];
new bool: is_progress_show[MAX_PLAYERS];
new random_position_progress[MAX_PLAYERS];
new progress_timer[MAX_PLAYERS] = {-1, ...};
new Float: current_position_progress[MAX_PLAYERS] = {0.0, ...};

/* -----------------------------------------------------------------------------------------------*/

hook OnGameModeInit() {
    progress_bar_TD[0] = TextDrawCreate(233.3332, 359.8148, "LD_SPAC:white"); // �����
    TextDrawTextSize(progress_bar_TD[0], 160.0000, 37.0000);
    TextDrawAlignment(progress_bar_TD[0], TEXT_DRAW_ALIGN:1);
    TextDrawColour(progress_bar_TD[0], 623191551);
    TextDrawBackgroundColour(progress_bar_TD[0], 255);
    TextDrawFont(progress_bar_TD[0], TEXT_DRAW_FONT:4);
    TextDrawSetProportional(progress_bar_TD[0], 0);
    TextDrawSetShadow(progress_bar_TD[0], 0);

    progress_bar_TD[1] = TextDrawCreate(238.3333, 362.6667, "PROGRESS_BAR"); // �����
    TextDrawLetterSize(progress_bar_TD[1], 0.1675, 1.0296);
    TextDrawAlignment(progress_bar_TD[1], TEXT_DRAW_ALIGN:1);
    TextDrawColour(progress_bar_TD[1], -1);
    TextDrawBackgroundColour(progress_bar_TD[1], 255);
    TextDrawFont(progress_bar_TD[1], TEXT_DRAW_FONT:2);
    TextDrawSetProportional(progress_bar_TD[1], 1);
    TextDrawSetShadow(progress_bar_TD[1], 0);

    progress_bar_TD[2] = TextDrawCreate(238.3333, 374.8517, "LD_SPAC:white"); // �����
    TextDrawTextSize(progress_bar_TD[2], 150.0000, 13.0000);
    TextDrawAlignment(progress_bar_TD[2], TEXT_DRAW_ALIGN:1);
    TextDrawColour(progress_bar_TD[2], 1296911666);
    TextDrawBackgroundColour(progress_bar_TD[2], 255);
    TextDrawFont(progress_bar_TD[2], TEXT_DRAW_FONT:4);
    TextDrawSetProportional(progress_bar_TD[2], 0);
    TextDrawSetShadow(progress_bar_TD[2], 0);
    return 1;
}

/* -----------------------------------------------------------------------------------------------*/

hook OnPlayerConnect(playerid) {
    player_progress_step[playerid] = 0;
    player_progress_type[playerid] = 0;
    is_progress_show[playerid] = false;
    progress_key[playerid] = 0; 
    progress_timer[playerid] = -1;
    current_position_progress[playerid] = 0.0;

    progress_bar_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 238.3333, 374.8517, "LD_SPAC:white"); // �����
    PlayerTextDrawTextSize(playerid, progress_bar_PTD[playerid][0], 0.0000, 13.0000);
    PlayerTextDrawAlignment(playerid, progress_bar_PTD[playerid][0], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, progress_bar_PTD[playerid][0], 0xFFA500FF);
    PlayerTextDrawBackgroundColour(playerid, progress_bar_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, progress_bar_PTD[playerid][0], TEXT_DRAW_FONT:4);
    PlayerTextDrawSetProportional(playerid, progress_bar_PTD[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, progress_bar_PTD[playerid][0], 0);

    progress_bar_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 272.9165, 377.1852, "Press_(Y)_on_the_bar_to_proceed"); // �����
    PlayerTextDrawLetterSize(playerid, progress_bar_PTD[playerid][1], 0.1200, 0.8533);
    PlayerTextDrawAlignment(playerid, progress_bar_PTD[playerid][1], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, progress_bar_PTD[playerid][1], -1);
    PlayerTextDrawBackgroundColour(playerid, progress_bar_PTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, progress_bar_PTD[playerid][1], TEXT_DRAW_FONT:2);
    PlayerTextDrawSetProportional(playerid, progress_bar_PTD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, progress_bar_PTD[playerid][1], 0);

    progress_bar_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 238.3333, 374.8517, "LD_SPAC:white"); // �����
    PlayerTextDrawTextSize(playerid, progress_bar_PTD[playerid][2], 0.0000, 13.0000);
    PlayerTextDrawAlignment(playerid, progress_bar_PTD[playerid][2], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, progress_bar_PTD[playerid][2], 0xFFA500FF);
    PlayerTextDrawBackgroundColour(playerid, progress_bar_PTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, progress_bar_PTD[playerid][2], TEXT_DRAW_FONT:4);
    PlayerTextDrawSetProportional(playerid, progress_bar_PTD[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, progress_bar_PTD[playerid][2], 0);
    return 1;
}

/* -----------------------------------------------------------------------------------------------*/

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {	
    if(newkeys == 65536) 
    {
        if(progress_key[playerid] == 1) {
            new Float: current_position = current_position_progress[playerid];
            new success_position = random_position_progress[playerid] - 240;

            if(floatround(current_position) >= success_position && current_position <= success_position + 15)
            {
                KillTimer(progress_timer[playerid]);
                player_progress_step[playerid] ++;
                current_position_progress[playerid] = 0.0;
                progress_timer[playerid] = SetTimerEx("updateProgress", 50, true, "i", playerid);
                ShowPlayerProgress(playerid, player_progress_type[playerid], player_progress_title[playerid]);

                switch(player_progress_type[playerid])
                {
                    case CRAFTING_PROGRESS, SURGERY_PROGRESS:
                    {
                        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.0, true, false, false, false, SYNC_ALL);
                    }
                }
            }
            else // if click the error box
            {
                switch(player_progress_type[playerid])
                {
                    case CRAFTING_PROGRESS:
                    {
                        SendClientMessage(playerid, COLOR_SYNTAX, "You have made a mistake that's why you have failed to crafting.");
                        return HideProgress(playerid);
                    }
                    case SURGERY_PROGRESS:
                    {
                        SendClientMessage(playerid, COLOR_SYNTAX, "You have made a mistake that's why you have failed to crafting.");
                        return HideProgress(playerid);
                    }
                }
            }
        }
    }

    if(newkeys == 131072) 
    {
        if(progress_key[playerid] == 2) {
            new Float: current_position = current_position_progress[playerid];
            new success_position = random_position_progress[playerid] - 240;

            if(floatround(current_position) >= success_position && current_position <= success_position + 15)
            {
                KillTimer(progress_timer[playerid]);
                current_position_progress[playerid] = 0.0;
                player_progress_step[playerid] ++;
                progress_timer[playerid] = SetTimerEx("updateProgress", 50, true, "i", playerid);                
                ShowPlayerProgress(playerid, player_progress_type[playerid], player_progress_title[playerid]);

                switch(player_progress_type[playerid])
                {
                    case CRAFTING_PROGRESS, SURGERY_PROGRESS:
                    {
                        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.0, true, false, false, false, SYNC_ALL);
                    }
                }
            }
            else 
            {
                switch(player_progress_type[playerid])
                {
                    case CRAFTING_PROGRESS:
                    {
                        SendClientMessage(playerid, COLOR_SYNTAX, "You have made a mistake that's why you have failed to continue.");
                        return HideProgress(playerid);
                    }
                    case SURGERY_PROGRESS:
                    {
                        SendClientMessage(playerid, COLOR_SYNTAX, "You have made a mistake that's why you have failed to crafting.");
                        return HideProgress(playerid);
                    }
                }
            }
        }
    }
    return 1;
}

stock ShowPlayerProgress(playerid, progress_type, const title[])
{   
    if(!is_progress_show[playerid])
    {
        for(new i; i < sizeof progress_bar_TD; i++) TextDrawShowForPlayer(playerid, progress_bar_TD[i]);
        for(new j; j < 3; j++) PlayerTextDrawShow(playerid, progress_bar_PTD[playerid][j]);

        TogglePlayerControllable(playerid, false);
        is_progress_show[playerid] = true;
        player_progress_step[playerid] = 0;
        player_progress_type[playerid] = progress_type;        
        progress_key[playerid] = 0;
        current_position_progress[playerid] = 0.0;

        progress_timer[playerid] = SetTimerEx("updateProgress", 50, true, "i", playerid);
    }
    if(player_progress_step[playerid] >= 3)
    {
        switch(progress_type)
        {
            case CRAFTING_PROGRESS: // Success clicking the progress box
            {
                switch(GetPVarInt(playerid, "craftingWeapon"))
                {
                    case 1: GivePlayerWeaponEx(playerid, 22, 350); // 9mm
                    case 2: GivePlayerWeaponEx(playerid, 23, 350); // sdpistol
                    case 3: GivePlayerWeaponEx(playerid, 24, 350); // deagle
                    case 4: GivePlayerWeaponEx(playerid, 25, 350); // shotgun
                    case 5: GivePlayerWeaponEx(playerid, 27, 350); // spas
                    case 6: GivePlayerWeaponEx(playerid, 29, 350); // mp5
                    case 7: GivePlayerWeaponEx(playerid, 30, 350); // ak
                    case 8: GivePlayerWeaponEx(playerid, 31, 350); // m4
                    case 9: GivePlayerWeaponEx(playerid, 33, 350); // cuntgun
                }
            }
            case SURGERY_PROGRESS: // Success clicking the progress box
            {
                new cpr, targetid = GetPVarInt(playerid, "SurgeryTarget");
                DeletePVar(playerid, "SurgeryTarget");
                
                cpr = 15000 + random(15000);
                AddToPaycheck(playerid, cpr);
                SendMessage(targetid, COLOR_DOCTOR, "You have been paid $%i from the government added to your paycheck", cpr);
                PlayerInfo[playerid][pLastAM] = gettime();
                PlayerInfo[playerid][pTotalPatients]++;
                ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 15000);
                SetTimerEx("Surgery", 15000, false, "i", targetid);
                SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s begins the surgery.", GetRPName(playerid));
            }
        }

        HideProgress(playerid);
        return 1;
    }
    new random_key = random(6), progress_key_name[2][2] = {"Y", "N"};
    random_position_progress[playerid] = 260 + (random(12) * 10);
    PlayerTextDrawDestroy(playerid, progress_bar_PTD[playerid][2]);
    
    progress_bar_PTD[playerid][2] = CreatePlayerTextDraw(playerid, random_position_progress[playerid], 374.8517, "LD_SPAC:white"); // �����
    PlayerTextDrawTextSize(playerid, progress_bar_PTD[playerid][2], 10.0000, 13.0000);
    PlayerTextDrawAlignment(playerid, progress_bar_PTD[playerid][2], TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColour(playerid, progress_bar_PTD[playerid][2], -155);
    PlayerTextDrawBackgroundColour(playerid, progress_bar_PTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, progress_bar_PTD[playerid][2], TEXT_DRAW_FONT:4);
    PlayerTextDrawSetProportional(playerid, progress_bar_PTD[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, progress_bar_PTD[playerid][2], 0);

    PlayerTextDrawShow(playerid, progress_bar_PTD[playerid][2]);

    switch(random_key) 
    {
        case 0, 2, 4: progress_key[playerid] = 1;
        case 1, 3, 5: progress_key[playerid] = 2;
        default: progress_key[playerid] = 1; 
    }
    new string[90];
    format(string, sizeof string, "Press (%s) on the bar to proceed", progress_key_name[progress_key[playerid] - 1]);
    PlayerTextDrawSetString(playerid, progress_bar_PTD[playerid][1], string);

    TextDrawSetString(progress_bar_TD[1], title);
    
    return 1;
}

forward updateProgress(playerid);
public updateProgress(playerid)
{
    // if click the error box
    if(current_position_progress[playerid] >= 150.0) {
        switch(player_progress_type[playerid])
        {
            case CRAFTING_PROGRESS, SURGERY_PROGRESS:
            {
                SendClientMessage(playerid, COLOR_SYNTAX, "The progress has reached at the max length therefore, you have to failed to continue.");
            }
        }
        TogglePlayerControllable(playerid, true);
        is_progress_show[playerid] = false;
        player_progress_step[playerid] = 0;
        player_progress_type[playerid] = 0;    
        progress_key[playerid] = 0;
        KillTimer(progress_timer[playerid]);
        for(new i; i < sizeof progress_bar_TD; i++) TextDrawHideForPlayer(playerid, progress_bar_TD[i]);
        for(new i; i < 3; i++) PlayerTextDrawHide(playerid, progress_bar_PTD[playerid][i]);

        return 1;
    }
    switch(player_progress_type[playerid])
    {
        case CRAFTING_PROGRESS, SURGERY_PROGRESS:
        {
            current_position_progress[playerid] = current_position_progress[playerid] + 0.5;
            PlayerTextDrawTextSize(playerid, progress_bar_PTD[playerid][0], current_position_progress[playerid], 13.000);
            PlayerTextDrawHide(playerid, progress_bar_PTD[playerid][0]);
            PlayerTextDrawShow(playerid, progress_bar_PTD[playerid][0]);
        }
    }
    return 1;
}

stock HideProgress(playerid)
{
    for(new i; i < sizeof progress_bar_TD; i++) TextDrawHideForPlayer(playerid, progress_bar_TD[i]);
    for(new i; i < 3; i++) PlayerTextDrawHide(playerid, progress_bar_PTD[playerid][i]);

    TogglePlayerControllable(playerid, true);
    is_progress_show[playerid] = false;
    player_progress_step[playerid] = 0;
    player_progress_type[playerid] = 0;    
    progress_key[playerid] = 0;
    current_position_progress[playerid] = 0.0;
    KillTimer(progress_timer[playerid]); 
    return 1;
}

CMD:progress(playerid)
{
    new string[32];
    format(string, sizeof(string), "TEST");
    strcpy(player_progress_title[playerid], string);
    ShowPlayerProgress(playerid, 1, string);
    return 1;
}