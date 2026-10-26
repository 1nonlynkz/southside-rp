#include <YSI_Coding\y_hooks>

#define PEF_DEBUG

new PlayerText:g_tdGreenBackground, PlayerText:g_tdBlackBackground, PlayerText:g_tdContent;

hook OnPlayerConnect(playerid)
{
    g_tdBlackBackground = CreatePlayerTextDraw(playerid, 642.000000, 119.000000, "_");
	PlayerTextDrawFont(playerid, g_tdBlackBackground, 1);
	PlayerTextDrawLetterSize(playerid, g_tdBlackBackground, 0.587499, 3.899997);
	PlayerTextDrawTextSize(playerid, g_tdBlackBackground, 638.000000, 46.500000);
	PlayerTextDrawSetOutline(playerid, g_tdBlackBackground, 1);
	PlayerTextDrawSetShadow(playerid, g_tdBlackBackground, 0);
	PlayerTextDrawAlignment(playerid, g_tdBlackBackground, 1);
	PlayerTextDrawColor(playerid, g_tdBlackBackground, -1);
	PlayerTextDrawBackgroundColor(playerid, g_tdBlackBackground, 255);
	PlayerTextDrawBoxColor(playerid, g_tdBlackBackground, 135);
	PlayerTextDrawUseBox(playerid, g_tdBlackBackground, 1);
	PlayerTextDrawSetProportional(playerid, g_tdBlackBackground, 1);
	PlayerTextDrawSetSelectable(playerid, g_tdBlackBackground, 0);

	g_tdGreenBackground = CreatePlayerTextDraw(playerid, 642.000000, 119.000000, "_");
	PlayerTextDrawFont(playerid, g_tdGreenBackground, 1);
	PlayerTextDrawLetterSize(playerid, g_tdGreenBackground, 0.587499, 3.899997);
	PlayerTextDrawTextSize(playerid, g_tdGreenBackground, 638.500000, 46.500000);
	PlayerTextDrawSetOutline(playerid, g_tdGreenBackground, 3);
	PlayerTextDrawSetShadow(playerid, g_tdGreenBackground, 0);
	PlayerTextDrawAlignment(playerid, g_tdGreenBackground, 1);
	PlayerTextDrawColor(playerid, g_tdGreenBackground, 9109759);
	PlayerTextDrawBackgroundColor(playerid, g_tdGreenBackground, 255);
	PlayerTextDrawBoxColor(playerid, g_tdGreenBackground, 16711935);
	PlayerTextDrawUseBox(playerid, g_tdGreenBackground, 1);
	PlayerTextDrawSetProportional(playerid, g_tdGreenBackground, 1);
	PlayerTextDrawSetSelectable(playerid, g_tdGreenBackground, 0);

	g_tdContent = CreatePlayerTextDraw(playerid, 542.000000, 124.000000, "Thank you for joining on our server, You will receive 3 Types of freebies!");
	PlayerTextDrawFont(playerid, g_tdContent, 1);
	PlayerTextDrawLetterSize(playerid, g_tdContent, 0.125000, 0.750000);
	PlayerTextDrawTextSize(playerid, g_tdContent, 645.000000, 182.000000);
	PlayerTextDrawSetOutline(playerid, g_tdContent, 0);
	PlayerTextDrawSetShadow(playerid, g_tdContent, 0);
	PlayerTextDrawAlignment(playerid, g_tdContent, 1);
	PlayerTextDrawColor(playerid, g_tdContent, -1);
	PlayerTextDrawBackgroundColor(playerid, g_tdContent, 255);
	PlayerTextDrawBoxColor(playerid, g_tdContent, 50);
	PlayerTextDrawUseBox(playerid, g_tdContent, 0);
	PlayerTextDrawSetProportional(playerid, g_tdContent, 1);
	PlayerTextDrawSetSelectable(playerid, g_tdContent, 0);
	return 1;
}

forward AnimationEntryPhases(playerid, phase);
public AnimationEntryPhases(playerid, phase)
{
    switch(phase)
    {
        case 0: PlayerText_MoveTextSize(playerid, g_tdBlackBackground, 498.0, 500, EASE_OUT_QUART);
        case 1:
        {
            PlayerText_PlaceOnTop(playerid, g_tdContent);
            PlayerText_InterpolateColor(playerid, g_tdContent, 0xFFFFFFFF, 250, EASE_OUT_QUAD);
            SetTimerEx("AnimationExitPhases", 2000, false, "ii", playerid, 0);
        }
    }
}

forward AnimationExitPhases(playerid, phase);
public AnimationExitPhases(playerid, phase)
{
    switch(phase)
    {
        case 0:
        {
            PlayerText_InterpolateColor(playerid, g_tdContent, 0xFFFFFF00, 250, EASE_OUT_QUAD);
            SetTimerEx("AnimationExitPhases", 300, false, "ii", playerid, 1);
            SetTimerEx("AnimationExitPhases", 500, false, "ii", playerid, 2);
        }
        case 1: PlayerText_MoveTextSize(playerid, g_tdBlackBackground, 640.0, 500, EASE_OUT_QUART);
        case 2: PlayerText_MoveTextSize(playerid, g_tdGreenBackground, 640.0, 500, EASE_OUT_QUART);
    }
}

CMD:geforce(playerid, params[])
{
    PlayerText_MoveTextSize(playerid, g_tdGreenBackground, 495.0, 500, EASE_OUT_QUINT);
    SetTimerEx("AnimationEntryPhases", 300, false, "ii", playerid, 0);
    SetTimerEx("AnimationEntryPhases", 1000, false, "ii", playerid, 1);
    return 1;
}