#include <YSI_Coding\y_hooks>

new PlayerText:HungerTD[MAX_PLAYERS][6]; 
new PlayerText:hunger_100[MAX_PLAYERS];
new PlayerText:thrist_100[MAX_PLAYERS];
new PlayerText:stress_100[MAX_PLAYERS];

ptask UpdatePlayerHunger[1000](i)
{
    if(IsPlayerConnected(i) && PlayerInfo[i][pLogged] && !PlayerInfo[i][pKicked])
    {
        PlayerInfo[i][pHungerTimer]++;
        if(PlayerInfo[i][pHungerTimer] >= 600)
        {
            PlayerInfo[i][pHungerTimer] = 0;
            
            if(PlayerInfo[i][pHunger] > 0)
            {
                GivePlayerHunger(i, -6);
            }
        }
        
        if(PlayerInfo[i][pHunger] <= 5)
        {
            GivePlayerHealth(i, -1.0);
            SendMessage(i, COLOR_LIGHTBLUE, "You hear your stomach rumble, you need to eat. You can die due to starvation!");
        }

        PlayerInfo[i][pThirstTimer]++;
        if(PlayerInfo[i][pThirstTimer] >= 600) 
        {
            PlayerInfo[i][pThirstTimer] = 0;
            
            if(PlayerInfo[i][pThirst] > 0) 
            {
                GivePlayerThirst(i, -6);
            }
        }
        
        if(PlayerInfo[i][pThirst] <= 5) 
        {
            GivePlayerHealth(i, -1.0);
            SendMessage(i, COLOR_LIGHTBLUE, "You are thirsty, you need to drink. You can die due to thirst!");
        }

        PlayerInfo[i][pStressTimer]++;
        if(PlayerInfo[i][pStressTimer] >= 600) 
        {
            PlayerInfo[i][pStressTimer] = 0;
            
            if(PlayerInfo[i][pStress] > 0) 
            {
                GivePlayerStress(i, -6);
            }
        }
        
        if(PlayerInfo[i][pStress] <= 5) 
        {
            GivePlayerHealth(i, -1.0);
            SendMessage(i, COLOR_LIGHTBLUE, "You are stressed, you need to smoke or use drugs!");
        }

        new str[50];
        format(str, sizeof(str), "%d%%", PlayerInfo[i][pHunger]);
        PlayerTextDrawSetString(i, hunger_100[i], str);

        format(str, sizeof(str), "%d%%", PlayerInfo[i][pThirst]);
        PlayerTextDrawSetString(i, thrist_100[i], str);

        format(str, sizeof(str), "%d%%", PlayerInfo[i][pStress]);
        PlayerTextDrawSetString(i, stress_100[i], str);
    }
}


hook OnPlayerSpawn(playerid)
{
    for(new td = 0; td < 6; td++)
    {
        PlayerTextDrawShow(playerid, HungerTD[playerid][td]);
    }

    PlayerTextDrawShow(playerid, hunger_100[playerid]);
    PlayerTextDrawShow(playerid, thrist_100[playerid]);
    PlayerTextDrawShow(playerid, stress_100[playerid]);

    return 1;
}

hook OnPlayerConnect(playerid)
{
    HungerTD[playerid][0] = CreatePlayerTextDraw(playerid, 77.000000, 431.000000, "Thirst:");
    PlayerTextDrawFont(playerid, HungerTD[playerid][0], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, HungerTD[playerid][0], 0.137500, 1.100000);
    PlayerTextDrawTextSize(playerid, HungerTD[playerid][0], 398.500000, 17.000000);
    PlayerTextDrawSetOutline(playerid, HungerTD[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, HungerTD[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, HungerTD[playerid][0], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, HungerTD[playerid][0], -1061109505);
    PlayerTextDrawBackgroundColor(playerid, HungerTD[playerid][0], 255);
    PlayerTextDrawBoxColor(playerid, HungerTD[playerid][0], 50);
    PlayerTextDrawUseBox(playerid, HungerTD[playerid][0], 0);
    PlayerTextDrawSetProportional(playerid, HungerTD[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, HungerTD[playerid][0], 0);

    HungerTD[playerid][1] = CreatePlayerTextDraw(playerid, 26.000000, 431.000000, "hunger:");
    PlayerTextDrawFont(playerid, HungerTD[playerid][1], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, HungerTD[playerid][1], 0.137500, 1.100000);
    PlayerTextDrawTextSize(playerid, HungerTD[playerid][1], 398.500000, 17.000000);
    PlayerTextDrawSetOutline(playerid, HungerTD[playerid][1], 0);
    PlayerTextDrawSetShadow(playerid, HungerTD[playerid][1], 0);
    PlayerTextDrawAlignment(playerid, HungerTD[playerid][1], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, HungerTD[playerid][1], -1061109505);
    PlayerTextDrawBackgroundColor(playerid, HungerTD[playerid][1], -1);
    PlayerTextDrawBoxColor(playerid, HungerTD[playerid][1], 50);
    PlayerTextDrawUseBox(playerid, HungerTD[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, HungerTD[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, HungerTD[playerid][1], 0);

    hunger_100[playerid] = CreatePlayerTextDraw(playerid, 51.000000, 431.000000, "100%");
    PlayerTextDrawFont(playerid, hunger_100[playerid], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, hunger_100[playerid], 0.137500, 1.100000);
    PlayerTextDrawTextSize(playerid, hunger_100[playerid], 398.500000, 17.000000);
    PlayerTextDrawSetOutline(playerid, hunger_100[playerid], 0);
    PlayerTextDrawSetShadow(playerid, hunger_100[playerid], 0);
    PlayerTextDrawAlignment(playerid, hunger_100[playerid], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, hunger_100[playerid], -26113);
    PlayerTextDrawBackgroundColor(playerid, hunger_100[playerid], -1);
    PlayerTextDrawBoxColor(playerid, hunger_100[playerid], 50);
    PlayerTextDrawUseBox(playerid, hunger_100[playerid], 0);
    PlayerTextDrawSetProportional(playerid, hunger_100[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, hunger_100[playerid], 0);

    HungerTD[playerid][2] = CreatePlayerTextDraw(playerid, 62.000000, 428.000000, "Preview_Model");
    PlayerTextDrawFont(playerid, HungerTD[playerid][2], TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawLetterSize(playerid, HungerTD[playerid][2], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, HungerTD[playerid][2], 20.500000, 16.500000);
    PlayerTextDrawSetOutline(playerid, HungerTD[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, HungerTD[playerid][2], 0);
    PlayerTextDrawAlignment(playerid, HungerTD[playerid][2], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, HungerTD[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, HungerTD[playerid][2], 0);
    PlayerTextDrawBoxColor(playerid, HungerTD[playerid][2], 255);
    PlayerTextDrawUseBox(playerid, HungerTD[playerid][2], 0);
    PlayerTextDrawSetProportional(playerid, HungerTD[playerid][2], 1);
    PlayerTextDrawSetSelectable(playerid, HungerTD[playerid][2], 0);
    PlayerTextDrawSetPreviewModel(playerid, HungerTD[playerid][2], 19835);
    PlayerTextDrawSetPreviewRot(playerid, HungerTD[playerid][2], -10.000000, 0.000000, -61.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, HungerTD[playerid][2], 1, 1);

    thrist_100[playerid] = CreatePlayerTextDraw(playerid, 99.000000, 431.000000, "100%");
    PlayerTextDrawFont(playerid, thrist_100[playerid], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, thrist_100[playerid], 0.137500, 1.100000);
    PlayerTextDrawTextSize(playerid, thrist_100[playerid], 398.500000, 17.000000);
    PlayerTextDrawSetOutline(playerid, thrist_100[playerid], 0);
    PlayerTextDrawSetShadow(playerid, thrist_100[playerid], 0);
    PlayerTextDrawAlignment(playerid, thrist_100[playerid], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, thrist_100[playerid], 1858535423);
    PlayerTextDrawBackgroundColor(playerid, thrist_100[playerid], -1);
    PlayerTextDrawBoxColor(playerid, thrist_100[playerid], 50);
    PlayerTextDrawUseBox(playerid, thrist_100[playerid], 0);
    PlayerTextDrawSetProportional(playerid, thrist_100[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, thrist_100[playerid], 0);

    stress_100[playerid] = CreatePlayerTextDraw(playerid, 150.000000, 431.000000, "100%");
    PlayerTextDrawFont(playerid, stress_100[playerid], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, stress_100[playerid], 0.137500, 1.100000);
    PlayerTextDrawTextSize(playerid, stress_100[playerid], 398.500000, 17.000000);
    PlayerTextDrawSetOutline(playerid, stress_100[playerid], 0);
    PlayerTextDrawSetShadow(playerid, stress_100[playerid], 0);
    PlayerTextDrawAlignment(playerid, stress_100[playerid], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, stress_100[playerid], -9737267);
    PlayerTextDrawBackgroundColor(playerid, stress_100[playerid], -1);
    PlayerTextDrawBoxColor(playerid, stress_100[playerid], 50);
    PlayerTextDrawUseBox(playerid, stress_100[playerid], 0);
    PlayerTextDrawSetProportional(playerid, stress_100[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, stress_100[playerid], 0);

    HungerTD[playerid][3] = CreatePlayerTextDraw(playerid, 13.000000, 425.000000, "Preview_Model");
    PlayerTextDrawFont(playerid, HungerTD[playerid][3], TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawLetterSize(playerid, HungerTD[playerid][3], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, HungerTD[playerid][3], 15.000000, 20.000000);
    PlayerTextDrawSetOutline(playerid, HungerTD[playerid][3], 0);
    PlayerTextDrawSetShadow(playerid, HungerTD[playerid][3], 0);
    PlayerTextDrawAlignment(playerid, HungerTD[playerid][3], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, HungerTD[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, HungerTD[playerid][3], 0);
    PlayerTextDrawBoxColor(playerid, HungerTD[playerid][3], 255);
    PlayerTextDrawUseBox(playerid, HungerTD[playerid][3], 0);
    PlayerTextDrawSetProportional(playerid, HungerTD[playerid][3], 1);
    PlayerTextDrawSetSelectable(playerid, HungerTD[playerid][3], 0);
    PlayerTextDrawSetPreviewModel(playerid, HungerTD[playerid][3], 2703);
    PlayerTextDrawSetPreviewRot(playerid, HungerTD[playerid][3], -87.000000, -11.000000, -13.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, HungerTD[playerid][3], 1, 1);

    HungerTD[playerid][4] = CreatePlayerTextDraw(playerid, 108.000000, 424.000000, "Preview_Model");
    PlayerTextDrawFont(playerid, HungerTD[playerid][4], TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawLetterSize(playerid, HungerTD[playerid][4], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, HungerTD[playerid][4], 24.000000, 21.000000);
    PlayerTextDrawSetOutline(playerid, HungerTD[playerid][4], 0);
    PlayerTextDrawSetShadow(playerid, HungerTD[playerid][4], 0);
    PlayerTextDrawAlignment(playerid, HungerTD[playerid][4], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, HungerTD[playerid][4], -1);
    PlayerTextDrawBackgroundColor(playerid, HungerTD[playerid][4], 0);
    PlayerTextDrawBoxColor(playerid, HungerTD[playerid][4], 255);
    PlayerTextDrawUseBox(playerid, HungerTD[playerid][4], 0);
    PlayerTextDrawSetProportional(playerid, HungerTD[playerid][4], 1);
    PlayerTextDrawSetSelectable(playerid, HungerTD[playerid][4], 0);
    PlayerTextDrawSetPreviewModel(playerid, HungerTD[playerid][4], 2908);
    PlayerTextDrawSetPreviewRot(playerid, HungerTD[playerid][4], -80.000000, -269.000000, -3.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, HungerTD[playerid][4], 1, 1);

    HungerTD[playerid][5] = CreatePlayerTextDraw(playerid, 126.000000, 431.000000, "stress:");
    PlayerTextDrawFont(playerid, HungerTD[playerid][5], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, HungerTD[playerid][5], 0.137500, 1.100000);
    PlayerTextDrawTextSize(playerid, HungerTD[playerid][5], 398.500000, 17.000000);
    PlayerTextDrawSetOutline(playerid, HungerTD[playerid][5], 0);
    PlayerTextDrawSetShadow(playerid, HungerTD[playerid][5], 0);
    PlayerTextDrawAlignment(playerid, HungerTD[playerid][5], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, HungerTD[playerid][5], -1061109505);
    PlayerTextDrawBackgroundColor(playerid, HungerTD[playerid][5], 255);
    PlayerTextDrawBoxColor(playerid, HungerTD[playerid][5], 50);
    PlayerTextDrawUseBox(playerid, HungerTD[playerid][5], 0);
    PlayerTextDrawSetProportional(playerid, HungerTD[playerid][5], 1);
    PlayerTextDrawSetSelectable(playerid, HungerTD[playerid][5], 0);
    return 1;
}