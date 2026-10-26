#include <YSI_Coding\y_hooks>

hook OnGameModeInit()
{
    NoticeTxtdraw[0] = TextDrawCreate(174.000000, 181.000000, "Box");
	TextDrawBackgroundColour(NoticeTxtdraw[0], TEXT_DRAW_ALIGN:0);
	TextDrawFont(NoticeTxtdraw[0], TEXT_DRAW_FONT:1);
	TextDrawLetterSize(NoticeTxtdraw[0], 1.590000, 7.700005);
	TextDrawColour(NoticeTxtdraw[0], 0);
	TextDrawSetOutline(NoticeTxtdraw[0], 0);
	TextDrawSetProportional(NoticeTxtdraw[0], 1);
	TextDrawSetShadow(NoticeTxtdraw[0], 1);
	TextDrawUseBox(NoticeTxtdraw[0], 1);
	TextDrawBoxColour(NoticeTxtdraw[0], 100);
	TextDrawTextSize(NoticeTxtdraw[0], 454.000000, 18.000000);
	
	NoticeTxtdraw[1] = TextDrawCreate(313.000000, 193.000000, "Loading...");
	TextDrawAlignment(NoticeTxtdraw[1], TEXT_DRAW_ALIGN:2);
	TextDrawBackgroundColour(NoticeTxtdraw[1], 255);
	TextDrawFont(NoticeTxtdraw[1], TEXT_DRAW_FONT:2);
	TextDrawLetterSize(NoticeTxtdraw[1], 0.629999, 3.000000);
	TextDrawColour(NoticeTxtdraw[1], -1);
	TextDrawSetOutline(NoticeTxtdraw[1], 1);
	TextDrawSetProportional(NoticeTxtdraw[1], 1);

	NoticeTxtdraw[2] = TextDrawCreate(309.000000, 222.000000, "Looking up your account, Please Wait!");
	TextDrawAlignment(NoticeTxtdraw[2], TEXT_DRAW_ALIGN:2);
	TextDrawBackgroundColour(NoticeTxtdraw[2], 255);
	TextDrawFont(NoticeTxtdraw[2], TEXT_DRAW_FONT:2);
	TextDrawLetterSize(NoticeTxtdraw[2], 0.189999, 1.200000);
	TextDrawColour(NoticeTxtdraw[2], -1);
	TextDrawSetOutline(NoticeTxtdraw[2], 1);
	TextDrawSetProportional(NoticeTxtdraw[2], 1);

	NoticeTxtdraw[3] = TextDrawCreate(309.000000, 222.000000, "Comparing passwords with database, Please Wait!");
	TextDrawAlignment(NoticeTxtdraw[3], TEXT_DRAW_ALIGN:2);
	TextDrawBackgroundColour(NoticeTxtdraw[3], 255);
	TextDrawFont(NoticeTxtdraw[3], TEXT_DRAW_FONT:2);
	TextDrawLetterSize(NoticeTxtdraw[3], 0.189999, 1.200000);
	TextDrawColour(NoticeTxtdraw[3], -1);
	TextDrawSetOutline(NoticeTxtdraw[3], 1);
	TextDrawSetProportional(NoticeTxtdraw[3], 1);

	NoticeTxtdraw[4] = TextDrawCreate(309.000000, 222.000000, "Fetching & Loading your account, Please Wait!");
	TextDrawAlignment(NoticeTxtdraw[4], TEXT_DRAW_ALIGN:2);
	TextDrawBackgroundColour(NoticeTxtdraw[4], 255);
	TextDrawFont(NoticeTxtdraw[4], TEXT_DRAW_FONT:2);
	TextDrawLetterSize(NoticeTxtdraw[4], 0.189999, 1.200000);
	TextDrawColour(NoticeTxtdraw[4], -1);
	TextDrawSetOutline(NoticeTxtdraw[4], 1);
	TextDrawSetProportional(NoticeTxtdraw[4], 1);

	NoticeTxtdraw[5] = TextDrawCreate(309.000000, 222.000000, "Streaming Objects within area, Please Wait!");
	TextDrawAlignment(NoticeTxtdraw[5], TEXT_DRAW_ALIGN:2);
	TextDrawBackgroundColour(NoticeTxtdraw[5], 255);
	TextDrawFont(NoticeTxtdraw[5], TEXT_DRAW_FONT:2);
	TextDrawLetterSize(NoticeTxtdraw[5], 0.189999, 1.200000);
	TextDrawColour(NoticeTxtdraw[5], -1);
	TextDrawSetOutline(NoticeTxtdraw[5], 1);
	TextDrawSetProportional(NoticeTxtdraw[5], 1);

	NoticeTxtdraw[6] = TextDrawCreate(309.000000, 222.000000, "MySQL server is currently busy, Please Wait!");
	TextDrawAlignment(NoticeTxtdraw[6], TEXT_DRAW_ALIGN:2);
	TextDrawBackgroundColour(NoticeTxtdraw[6], 255);
	TextDrawFont(NoticeTxtdraw[6], TEXT_DRAW_FONT:2);
	TextDrawLetterSize(NoticeTxtdraw[6], 0.189999, 1.200000);
	TextDrawColour(NoticeTxtdraw[6], -1);
	TextDrawSetOutline(NoticeTxtdraw[6], 1);
	TextDrawSetProportional(NoticeTxtdraw[6], 1);

	NoticeTxtdraw[7] = TextDrawCreate(309.000000, 222.000000, "Loading, Please Wait!");
	TextDrawAlignment(NoticeTxtdraw[7], TEXT_DRAW_ALIGN:2);
	TextDrawBackgroundColour(NoticeTxtdraw[7], 255);
	TextDrawFont(NoticeTxtdraw[7], TEXT_DRAW_FONT:2);
	TextDrawLetterSize(NoticeTxtdraw[7], 0.189999, 1.200000);
	TextDrawColour(NoticeTxtdraw[7], -1);
	TextDrawSetOutline(NoticeTxtdraw[7], 1);
	TextDrawSetProportional(NoticeTxtdraw[7], 1);
    
    // Blindfold - Ez Jeck
	Blind = TextDrawCreate(641.199951, 1.500000, "usebox");
	TextDrawLetterSize(Blind, 0.000000, 49.378147);
	TextDrawTextSize(Blind, -2.000000, 0.000000);
	TextDrawAlignment(Blind, TEXT_DRAW_ALIGN:3);
	TextDrawColour(Blind, -1);
	TextDrawUseBox(Blind, true);
	TextDrawBoxColour(Blind, 255);
	TextDrawSetShadow(Blind, 0);
	TextDrawSetOutline(Blind, 0);
	TextDrawBackgroundColour(Blind, 255);
	TextDrawFont(Blind, TEXT_DRAW_FONT:1);

	PlayerCountTD[0] = TextDrawCreate(321.000000, 427.000000, "The player record count is ~g~0~w~, achieved on n/a.");
	TextDrawAlignment(PlayerCountTD[0], TEXT_DRAW_ALIGN:2);
	TextDrawBackgroundColour(PlayerCountTD[0], 255);
	TextDrawFont(PlayerCountTD[0], TEXT_DRAW_FONT:1);
	TextDrawLetterSize(PlayerCountTD[0], 0.210000, 1.000000);
	TextDrawColour(PlayerCountTD[0], -1);
	TextDrawSetOutline(PlayerCountTD[0], 1);
	TextDrawSetProportional(PlayerCountTD[0], 1);

	TimeTD = TextDrawCreate(87.000000, 345.000000, "12:34");
	TextDrawAlignment(TimeTD, TEXT_DRAW_ALIGN:2);
	TextDrawBackgroundColour(TimeTD, 255);
	TextDrawFont(TimeTD, TEXT_DRAW_FONT:2);
	TextDrawLetterSize(TimeTD, 0.140000, 1.200000);
	TextDrawColour(TimeTD, 0xfffffffff);
	TextDrawSetOutline(TimeTD, 0);
	TextDrawSetProportional(TimeTD, 1);
	TextDrawSetShadow(TimeTD, 1);
	TextDrawUseBox(TimeTD, 1);
	TextDrawBoxColour(TimeTD, 135);
	TextDrawTextSize(TimeTD, 0.000000, 19.000000);
	
	// Animation textdraw
	AnimationTD = TextDrawCreate(630.000000, 418.000000, "~b~~k~~PED_SPRINT~ ~w~to stop the animation");
	TextDrawAlignment(AnimationTD, TEXT_DRAW_ALIGN:3);
	TextDrawBackgroundColour(AnimationTD, 255);
	TextDrawFont(AnimationTD, TEXT_DRAW_FONT:2);
	TextDrawLetterSize(AnimationTD, 0.500000, 1.000000);
	TextDrawColour(AnimationTD, -1);
	TextDrawSetOutline(AnimationTD, 1);
	TextDrawSetProportional(AnimationTD, 1);
	TextDrawSetSelectable(AnimationTD, 0);

	// Blood Effects
    Blood[0] = TextDrawCreate(86.666648, 121.814811, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[0], 0.000000, 0.000000);
    TextDrawTextSize(Blood[0], 24.000000, 34.000000);
    TextDrawAlignment(Blood[0], TEXT_DRAW_ALIGN:1);
    TextDrawColour(Blood[0], -1);
    TextDrawSetShadow(Blood[0], 0);
    TextDrawSetOutline(Blood[0], 0);
    TextDrawBackgroundColour(Blood[0], 255);
    TextDrawFont(Blood[0], TEXT_DRAW_FONT:4);
    TextDrawSetProportional(Blood[0], 0);
    TextDrawSetShadow(Blood[0], 0);

    Blood[1] = TextDrawCreate(477.333312, 246.674102, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[1], 0.000000, 0.000000);
    TextDrawTextSize(Blood[1], 36.000000, 41.000000);
    TextDrawAlignment(Blood[1], TEXT_DRAW_ALIGN:1);
    TextDrawColour(Blood[1], -1);
    TextDrawSetShadow(Blood[1], 0);
    TextDrawSetOutline(Blood[1], 0);
    TextDrawBackgroundColour(Blood[1], 255);
    TextDrawFont(Blood[1], TEXT_DRAW_FONT:4);
    TextDrawSetProportional(Blood[1], 0);
    TextDrawSetShadow(Blood[1], 0);

    Blood[2] = TextDrawCreate(24.000041, 249.992660, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[2], 0.000000, 0.000000);
    TextDrawTextSize(Blood[2], 70.000000, 57.000000);
    TextDrawAlignment(Blood[2], TEXT_DRAW_ALIGN:1);
    TextDrawColour(Blood[2], -1);
    TextDrawSetShadow(Blood[2], 0);
    TextDrawSetOutline(Blood[2], 0);
    TextDrawBackgroundColour(Blood[2], 255);
    TextDrawFont(Blood[2], TEXT_DRAW_FONT:4);
    TextDrawSetProportional(Blood[2], 0);
    TextDrawSetShadow(Blood[2], 0);

    Blood[3] = TextDrawCreate(546.333374, 323.414916, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[3], 0.000000, 0.000000);
    TextDrawTextSize(Blood[3], 70.000000, 57.000000);
    TextDrawAlignment(Blood[3], TEXT_DRAW_ALIGN:1);
    TextDrawColour(Blood[3], -1);
    TextDrawSetShadow(Blood[3], 0);
    TextDrawSetOutline(Blood[3], 0);
    TextDrawBackgroundColour(Blood[3], 255);
    TextDrawFont(Blood[3], TEXT_DRAW_FONT:4);
    TextDrawSetProportional(Blood[3], 0);
    TextDrawSetShadow(Blood[3], 0);

    Blood[4] = TextDrawCreate(276.666717, 340.007568, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[4], 0.000000, 0.000000);
    TextDrawTextSize(Blood[4], 70.000000, 57.000000);
    TextDrawAlignment(Blood[4], TEXT_DRAW_ALIGN:1);
    TextDrawColour(Blood[4], -1);
    TextDrawSetShadow(Blood[4], 0);
    TextDrawSetOutline(Blood[4], 0);
    TextDrawBackgroundColour(Blood[4], 255);
    TextDrawFont(Blood[4], TEXT_DRAW_FONT:4);
    TextDrawSetProportional(Blood[4], 0);
    TextDrawSetShadow(Blood[4], 0);

    Blood[5] = TextDrawCreate(442.666748, 12.718672, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[5], 0.000000, 0.000000);
    TextDrawTextSize(Blood[5], 17.000000, 25.000000);
    TextDrawAlignment(Blood[5], TEXT_DRAW_ALIGN:1);
    TextDrawColour(Blood[5], -1);
    TextDrawSetShadow(Blood[5], 0);
    TextDrawSetOutline(Blood[5], 0);
    TextDrawBackgroundColour(Blood[5], 255);
    TextDrawFont(Blood[5], TEXT_DRAW_FONT:4);
    TextDrawSetProportional(Blood[5], 0);
    TextDrawSetShadow(Blood[5], 0);

    Blood[6] = TextDrawCreate(201.666732, 16.866807, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[6], 0.000000, 0.000000);
    TextDrawTextSize(Blood[6], 48.000000, 49.000000);
    TextDrawAlignment(Blood[6], TEXT_DRAW_ALIGN:1);
    TextDrawColour(Blood[6], -1);
    TextDrawSetShadow(Blood[6], 0);
    TextDrawSetOutline(Blood[6], 0);
    TextDrawBackgroundColour(Blood[6], 255);
    TextDrawFont(Blood[6], TEXT_DRAW_FONT:4);
    TextDrawSetProportional(Blood[6], 0);
    TextDrawSetShadow(Blood[6], 0);

    Blood[7] = TextDrawCreate(117.000106, 148.777893, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[7], 0.000000, 0.000000);
    TextDrawTextSize(Blood[7], 127.000000, 70.000000);
    TextDrawAlignment(Blood[7], TEXT_DRAW_ALIGN:1);
    TextDrawColour(Blood[7], -1);
    TextDrawSetShadow(Blood[7], 0);
    TextDrawSetOutline(Blood[7], 0);
    TextDrawBackgroundColour(Blood[7], 255);
    TextDrawFont(Blood[7], TEXT_DRAW_FONT:4);
    TextDrawSetProportional(Blood[7], 0);
    TextDrawSetShadow(Blood[7], 0);

    Blood[8] = TextDrawCreate(428.666717, 118.911254, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[8], 0.000000, 0.000000);
    TextDrawTextSize(Blood[8], 59.000000, 50.000000);
    TextDrawAlignment(Blood[8], TEXT_DRAW_ALIGN:1);
    TextDrawColour(Blood[8], -1);
    TextDrawSetShadow(Blood[8], 0);
    TextDrawSetOutline(Blood[8], 0);
    TextDrawBackgroundColour(Blood[8], 255);
    TextDrawFont(Blood[8], TEXT_DRAW_FONT:4);
    TextDrawSetProportional(Blood[8], 0);
    TextDrawSetShadow(Blood[8], 0);
    return 1;
}

stock ShowLoginTextDraw(playerid, bool:show)
{
    if(show)
    {
        for (new i = 0; i < 11; i++) 
        {
            PlayerTextDrawShow(playerid, LoginTextdraw[playerid][i]);
        }
    }
    else
    {
        for (new i = 0; i < 11; i++) 
        {
            PlayerTextDrawHide(playerid, LoginTextdraw[playerid][i]);
        }
    }
    return 1;
}


hook OnPlayerConnect(playerid)
{
    InjuredTD[playerid] = CreatePlayerTextDraw(playerid, 142.000000, 369.000000, "Respawn available in ~g~~n~~w~Press ~r~Y~w~ to signal a distress ~g~and~w~ Press ~y~N~w~ to respawn");
	PlayerTextDrawFont(playerid, InjuredTD[playerid], TEXT_DRAW_FONT:2);
	PlayerTextDrawLetterSize(playerid, InjuredTD[playerid], 0.187500, 1.250000);
	PlayerTextDrawTextSize(playerid, InjuredTD[playerid], 376.500000, 697.500000);
	PlayerTextDrawSetOutline(playerid, InjuredTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, InjuredTD[playerid], 0);
	PlayerTextDrawAlignment(playerid, InjuredTD[playerid], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, InjuredTD[playerid], -1);
	PlayerTextDrawBackgroundColour(playerid, InjuredTD[playerid], 255);
	PlayerTextDrawBoxColour(playerid, InjuredTD[playerid], 50);
	PlayerTextDrawUseBox(playerid, InjuredTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, InjuredTD[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, InjuredTD[playerid], 0);

	RecoverTD[playerid] = CreatePlayerTextDraw(playerid, 142.000000, 369.000000, "Respawn available in ~g~~n~~w~Press ~r~Y~w~ to signal a distress ~g~and~w~ Press ~y~N~w~ to respawn");
	PlayerTextDrawFont(playerid, RecoverTD[playerid], TEXT_DRAW_FONT:2);
	PlayerTextDrawLetterSize(playerid, RecoverTD[playerid], 0.187500, 1.250000);
	PlayerTextDrawTextSize(playerid, RecoverTD[playerid], 376.500000, 697.500000);
	PlayerTextDrawSetOutline(playerid, RecoverTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, RecoverTD[playerid], 0);
	PlayerTextDrawAlignment(playerid, RecoverTD[playerid], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, RecoverTD[playerid], -1);
	PlayerTextDrawBackgroundColour(playerid, RecoverTD[playerid], 255);
	PlayerTextDrawBoxColour(playerid, RecoverTD[playerid], 50);
	PlayerTextDrawUseBox(playerid, RecoverTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, RecoverTD[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, RecoverTD[playerid], 0);

	LoginTextdraw[playerid][0] = CreatePlayerTextDraw(playerid, 305.000000, 334.000000, "_");
	PlayerTextDrawFont(playerid, LoginTextdraw[playerid][0], TEXT_DRAW_FONT_1);
	PlayerTextDrawLetterSize(playerid, LoginTextdraw[playerid][0], 0.600000, 13.149992);
	PlayerTextDrawTextSize(playerid, LoginTextdraw[playerid][0], 298.500000, 680.000000);
	PlayerTextDrawSetOutline(playerid, LoginTextdraw[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, LoginTextdraw[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, LoginTextdraw[playerid][0], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColor(playerid, LoginTextdraw[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, LoginTextdraw[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, LoginTextdraw[playerid][0], 255);
	PlayerTextDrawUseBox(playerid, LoginTextdraw[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, LoginTextdraw[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, LoginTextdraw[playerid][0], 0);

	LoginTextdraw[playerid][1] = CreatePlayerTextDraw(playerid, 305.000000, -5.000000, "_");
	PlayerTextDrawFont(playerid, LoginTextdraw[playerid][1], TEXT_DRAW_FONT_1);
	PlayerTextDrawLetterSize(playerid, LoginTextdraw[playerid][1], 0.600000, 13.149992);
	PlayerTextDrawTextSize(playerid, LoginTextdraw[playerid][1], 298.500000, 680.000000);
	PlayerTextDrawSetOutline(playerid, LoginTextdraw[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, LoginTextdraw[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, LoginTextdraw[playerid][1], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColor(playerid, LoginTextdraw[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, LoginTextdraw[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, LoginTextdraw[playerid][1], 255);
	PlayerTextDrawUseBox(playerid, LoginTextdraw[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, LoginTextdraw[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, LoginTextdraw[playerid][1], 0);

	LoginTextdraw[playerid][2] = CreatePlayerTextDraw(playerid, 305.000000, 116.000000, "_");
	PlayerTextDrawFont(playerid, LoginTextdraw[playerid][2], TEXT_DRAW_FONT_1);
	PlayerTextDrawLetterSize(playerid, LoginTextdraw[playerid][2], 0.600000, -0.100000);
	PlayerTextDrawTextSize(playerid, LoginTextdraw[playerid][2], 298.500000, 680.000000);
	PlayerTextDrawSetOutline(playerid, LoginTextdraw[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, LoginTextdraw[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, LoginTextdraw[playerid][2], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColor(playerid, LoginTextdraw[playerid][2], 35839);
	PlayerTextDrawBackgroundColor(playerid, LoginTextdraw[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, LoginTextdraw[playerid][2], 1687547391);
	PlayerTextDrawUseBox(playerid, LoginTextdraw[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, LoginTextdraw[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, LoginTextdraw[playerid][2], 0);

	LoginTextdraw[playerid][3] = CreatePlayerTextDraw(playerid, 305.000000, 332.000000, "_");
	PlayerTextDrawFont(playerid, LoginTextdraw[playerid][3], TEXT_DRAW_FONT_1);
	PlayerTextDrawLetterSize(playerid, LoginTextdraw[playerid][3], 0.600000, -0.100000);
	PlayerTextDrawTextSize(playerid, LoginTextdraw[playerid][3], 298.500000, 680.000000);
	PlayerTextDrawSetOutline(playerid, LoginTextdraw[playerid][3], 4);
	PlayerTextDrawSetShadow(playerid, LoginTextdraw[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, LoginTextdraw[playerid][3], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColor(playerid, LoginTextdraw[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, LoginTextdraw[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, LoginTextdraw[playerid][3], 1687547391);
	PlayerTextDrawUseBox(playerid, LoginTextdraw[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, LoginTextdraw[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, LoginTextdraw[playerid][3], 0);

	LoginTextdraw[playerid][4] = CreatePlayerTextDraw(playerid, 198.000000, 68.000000, "ld_beat:chit");
	PlayerTextDrawFont(playerid, LoginTextdraw[playerid][4], TEXT_DRAW_FONT_SPRITE);
	PlayerTextDrawLetterSize(playerid, LoginTextdraw[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, LoginTextdraw[playerid][4], 237.500000, 3.500000);
	PlayerTextDrawSetOutline(playerid, LoginTextdraw[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, LoginTextdraw[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, LoginTextdraw[playerid][4], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, LoginTextdraw[playerid][4], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, LoginTextdraw[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, LoginTextdraw[playerid][4], 35634);
	PlayerTextDrawUseBox(playerid, LoginTextdraw[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, LoginTextdraw[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, LoginTextdraw[playerid][4], 0);

	LoginTextdraw[playerid][5] = CreatePlayerTextDraw(playerid, 318.000000, 46.000000, "Southside Roleplay V1.20.5");
	PlayerTextDrawFont(playerid, LoginTextdraw[playerid][5], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, LoginTextdraw[playerid][5], 0.358332, 2.599997);
	PlayerTextDrawTextSize(playerid, LoginTextdraw[playerid][5], 400.000000, 247.000000);
	PlayerTextDrawSetOutline(playerid, LoginTextdraw[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, LoginTextdraw[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, LoginTextdraw[playerid][5], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColor(playerid, LoginTextdraw[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, LoginTextdraw[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, LoginTextdraw[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, LoginTextdraw[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, LoginTextdraw[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, LoginTextdraw[playerid][5], 0);

	LoginTextdraw[playerid][6] = CreatePlayerTextDraw(playerid, 318.000000, 71.000000, "ESTABLISHED:2026");
	PlayerTextDrawFont(playerid, LoginTextdraw[playerid][6], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, LoginTextdraw[playerid][6], 0.133331, 1.100000);
	PlayerTextDrawSetOutline(playerid, LoginTextdraw[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, LoginTextdraw[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, LoginTextdraw[playerid][6], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColor(playerid, LoginTextdraw[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, LoginTextdraw[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, LoginTextdraw[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, LoginTextdraw[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, LoginTextdraw[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, LoginTextdraw[playerid][6], 0);

	LoginTextdraw[playerid][7] = CreatePlayerTextDraw(playerid, 318.000000, 350.000000, "TAKE NOTE:");
	PlayerTextDrawFont(playerid, LoginTextdraw[playerid][7], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, LoginTextdraw[playerid][7], 0.241666, 1.799998);
	PlayerTextDrawTextSize(playerid, LoginTextdraw[playerid][7], 400.000000, 108.000000);
	PlayerTextDrawSetOutline(playerid, LoginTextdraw[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, LoginTextdraw[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, LoginTextdraw[playerid][7], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColor(playerid, LoginTextdraw[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, LoginTextdraw[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, LoginTextdraw[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, LoginTextdraw[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, LoginTextdraw[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, LoginTextdraw[playerid][7], 0);

	LoginTextdraw[playerid][8] = CreatePlayerTextDraw(playerid, 318.000000, 368.000000, "PLEASE ALWAYS SHOW RESPECT FOR OTHER PLAYERS AND CONTROL YOUR OUT OF CHARACTER EMOTIONS");
	PlayerTextDrawFont(playerid, LoginTextdraw[playerid][8], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, LoginTextdraw[playerid][8], 0.129166, 1.500002);
	PlayerTextDrawTextSize(playerid, LoginTextdraw[playerid][8], 415.000000, 607.000000);
	PlayerTextDrawSetOutline(playerid, LoginTextdraw[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, LoginTextdraw[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, LoginTextdraw[playerid][8], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColor(playerid, LoginTextdraw[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, LoginTextdraw[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, LoginTextdraw[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, LoginTextdraw[playerid][8], 0);
	PlayerTextDrawSetProportional(playerid, LoginTextdraw[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, LoginTextdraw[playerid][8], 0);

	LoginTextdraw[playerid][9] = CreatePlayerTextDraw(playerid, 318.000000, 378.000000, "Southside Roleplay IS A SERVER THAT PROHIBITS CHEATER AND TOXIC");
	PlayerTextDrawFont(playerid, LoginTextdraw[playerid][9], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, LoginTextdraw[playerid][9], 0.129166, 1.500002);
	PlayerTextDrawTextSize(playerid, LoginTextdraw[playerid][9], 415.000000, 607.000000);
	PlayerTextDrawSetOutline(playerid, LoginTextdraw[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, LoginTextdraw[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, LoginTextdraw[playerid][9], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColor(playerid, LoginTextdraw[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, LoginTextdraw[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, LoginTextdraw[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, LoginTextdraw[playerid][9], 0);
	PlayerTextDrawSetProportional(playerid, LoginTextdraw[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, LoginTextdraw[playerid][9], 0);

	LoginTextdraw[playerid][10] = CreatePlayerTextDraw(playerid, 318.000000, 388.000000, "PLAYERS AND KINDLY HELP THE COMMUNITY GROW WITH YOU.");
	PlayerTextDrawFont(playerid, LoginTextdraw[playerid][10], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, LoginTextdraw[playerid][10], 0.129166, 1.500002);
	PlayerTextDrawTextSize(playerid, LoginTextdraw[playerid][10], 415.000000, 607.000000);
	PlayerTextDrawSetOutline(playerid, LoginTextdraw[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, LoginTextdraw[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, LoginTextdraw[playerid][10], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColor(playerid, LoginTextdraw[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, LoginTextdraw[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, LoginTextdraw[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, LoginTextdraw[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid, LoginTextdraw[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, LoginTextdraw[playerid][10], 0);
	
	GPS[playerid][0] = CreatePlayerTextDraw(playerid, 88.000000, 322.000000, "Loading...");
    PlayerTextDrawFont(playerid, GPS[playerid][0], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, GPS[playerid][0], 0.212500, 0.999999);
    PlayerTextDrawTextSize(playerid, GPS[playerid][0], 393.000000, 252.000000);
    PlayerTextDrawSetOutline(playerid, GPS[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, GPS[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, GPS[playerid][0], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColor(playerid, GPS[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, GPS[playerid][0], 255);
    PlayerTextDrawBoxColor(playerid, GPS[playerid][0], 50);
    PlayerTextDrawUseBox(playerid, GPS[playerid][0], 0);
    PlayerTextDrawSetProportional(playerid, GPS[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, GPS[playerid][0], 0);
	
	DateTD[playerid][0] = CreatePlayerTextDraw(playerid, 587.000000, 414.500000, "20:16");
    PlayerTextDrawFont(playerid, DateTD[playerid][0], TEXT_DRAW_FONT_3);
    PlayerTextDrawLetterSize(playerid, DateTD[playerid][0], 0.429165, 1.749997);
    PlayerTextDrawTextSize(playerid, DateTD[playerid][0], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, DateTD[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, DateTD[playerid][0], 1);
    PlayerTextDrawAlignment(playerid, DateTD[playerid][0], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, DateTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, DateTD[playerid][0], 255);
    PlayerTextDrawBoxColor(playerid, DateTD[playerid][0], 50);
    PlayerTextDrawUseBox(playerid, DateTD[playerid][0], 0);
    PlayerTextDrawSetProportional(playerid, DateTD[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, DateTD[playerid][0], 0);

    DateTD[playerid][1] = CreatePlayerTextDraw(playerid, 589.000000, 408.000000, "06/21/2026");
    PlayerTextDrawFont(playerid, DateTD[playerid][1], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, DateTD[playerid][1], 0.141664, 0.899999);
    PlayerTextDrawTextSize(playerid, DateTD[playerid][1], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, DateTD[playerid][1], 0);
    PlayerTextDrawSetShadow(playerid, DateTD[playerid][1], 1);
    PlayerTextDrawAlignment(playerid, DateTD[playerid][1], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, DateTD[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, DateTD[playerid][1], 255);
    PlayerTextDrawBoxColor(playerid, DateTD[playerid][1], 50);
    PlayerTextDrawUseBox(playerid, DateTD[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, DateTD[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, DateTD[playerid][1], 0);

    DateTD[playerid][2] = CreatePlayerTextDraw(playerid, 589.000000, 429.000000, "PING:");
    PlayerTextDrawFont(playerid, DateTD[playerid][2], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, DateTD[playerid][2], 0.141664, 0.899999);
    PlayerTextDrawTextSize(playerid, DateTD[playerid][2], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, DateTD[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, DateTD[playerid][2], 1);
    PlayerTextDrawAlignment(playerid, DateTD[playerid][2], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, DateTD[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, DateTD[playerid][2], 255);
    PlayerTextDrawBoxColor(playerid, DateTD[playerid][2], 50);
    PlayerTextDrawUseBox(playerid, DateTD[playerid][2], 0);
    PlayerTextDrawSetProportional(playerid, DateTD[playerid][2], 1);
    PlayerTextDrawSetSelectable(playerid, DateTD[playerid][2], 0);

    DateTD[playerid][3] = CreatePlayerTextDraw(playerid, 605.000000, 429.000000, "300MS");
    PlayerTextDrawFont(playerid, DateTD[playerid][3], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, DateTD[playerid][3], 0.141664, 0.899999);
    PlayerTextDrawTextSize(playerid, DateTD[playerid][3], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, DateTD[playerid][3], 0);
    PlayerTextDrawSetShadow(playerid, DateTD[playerid][3], 1);
    PlayerTextDrawAlignment(playerid, DateTD[playerid][3], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, DateTD[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, DateTD[playerid][3], 255);
    PlayerTextDrawBoxColor(playerid, DateTD[playerid][3], 50);
    PlayerTextDrawUseBox(playerid, DateTD[playerid][3], 0);
    PlayerTextDrawSetProportional(playerid, DateTD[playerid][3], 1);
    PlayerTextDrawSetSelectable(playerid, DateTD[playerid][3], 0);
    
    BlackmarketTD[playerid][0] = CreatePlayerTextDraw(playerid, 320.000000, 167.000000, "_");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][0], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][0], 0.600000, 19.399982);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][0], 298.500000, 312.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][0], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][0], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][0], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][0], 6750207);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][0], 0);

    BlackmarketTD[playerid][1] = CreatePlayerTextDraw(playerid, 320.000000, 168.000000, "_");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][1], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][1], 0.600000, 19.199985);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][1], 298.500000, 311.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][1], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][1], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][1], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][1], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][1], 387389439);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][1], 0);

    // Item Slot 1 (Top Left)
    BlackmarketTD[playerid][2] = CreatePlayerTextDraw(playerid, 191.000000, 182.000000, "_");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][2], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][2], 0.600000, 7.599997);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][2], 295.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][2], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][2], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][2], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][2], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][2], 471604479);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][2], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][2], 0);

    BlackmarketTD[playerid][3] = CreatePlayerTextDraw(playerid, 191.000000, 183.000000, "thermite");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][3], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][3], 0.133330, 0.649998);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][3], 400.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][3], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][3], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][3], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][3], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][3], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][3], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][3], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][3], 0);

    BlackmarketTD[playerid][4] = CreatePlayerTextDraw(playerid, 141.000000, 135.000000, "Preview_Model");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][4], TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][4], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][4], 112.500000, 150.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][4], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][4], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][4], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][4], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][4], 0);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][4], 255);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][4], 0);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][4], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][4], 0);
    PlayerTextDrawSetPreviewModel(playerid, BlackmarketTD[playerid][4], 353);
    PlayerTextDrawSetPreviewRot(playerid, BlackmarketTD[playerid][4], -17.000000, 0.000000, 9.000000, 4.730013);
    PlayerTextDrawSetPreviewVehicleColours(playerid, BlackmarketTD[playerid][4], 1, 1);

    BlackmarketTD[playerid][5] = CreatePlayerTextDraw(playerid, 191.000000, 230.000000, "1,000,000,000$");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][5], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][5], 0.108331, 0.799997);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][5], 394.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][5], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][5], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][5], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][5], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][5], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][5], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][5], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][5], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][5], 0);

    BlackmarketTD[playerid][6] = CreatePlayerTextDraw(playerid, 191.000000, 242.000000, "add cart");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][6], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][6], 0.120830, 0.699998);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][6], 8.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][6], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][6], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][6], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][6], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][6], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][6], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][6], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][6], 1);

    // Item Slot 2
    BlackmarketTD[playerid][7] = CreatePlayerTextDraw(playerid, 242.000000, 182.000000, "_");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][7], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][7], 0.600000, 7.599997);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][7], 295.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][7], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][7], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][7], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][7], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][7], 471604479);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][7], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][7], 0);

    BlackmarketTD[playerid][8] = CreatePlayerTextDraw(playerid, 242.000000, 183.000000, "thermite");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][8], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][8], 0.133330, 0.649998);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][8], 400.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][8], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][8], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][8], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][8], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][8], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][8], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][8], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][8], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][8], 0);

    BlackmarketTD[playerid][9] = CreatePlayerTextDraw(playerid, 192.000000, 135.000000, "Preview_Model");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][9], TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][9], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][9], 112.500000, 150.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][9], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][9], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][9], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][9], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][9], 0);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][9], 255);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][9], 0);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][9], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][9], 0);
    PlayerTextDrawSetPreviewModel(playerid, BlackmarketTD[playerid][9], 353);
    PlayerTextDrawSetPreviewRot(playerid, BlackmarketTD[playerid][9], -17.000000, 0.000000, 9.000000, 4.730013);
    PlayerTextDrawSetPreviewVehicleColours(playerid, BlackmarketTD[playerid][9], 1, 1);

    BlackmarketTD[playerid][10] = CreatePlayerTextDraw(playerid, 242.000000, 230.000000, "1,000,000,000$");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][10], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][10], 0.108331, 0.799997);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][10], 394.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][10], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][10], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][10], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][10], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][10], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][10], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][10], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][10], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][10], 0);

    BlackmarketTD[playerid][11] = CreatePlayerTextDraw(playerid, 242.000000, 242.000000, "add cart");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][11], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][11], 0.120830, 0.699998);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][11], 8.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][11], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][11], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][11], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][11], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][11], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][11], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][11], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][11], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][11], 1);

    // Item Slot 3
    BlackmarketTD[playerid][12] = CreatePlayerTextDraw(playerid, 293.000000, 182.000000, "_");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][12], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][12], 0.600000, 7.599997);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][12], 295.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][12], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][12], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][12], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][12], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][12], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][12], 471604479);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][12], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][12], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][12], 0);

    BlackmarketTD[playerid][13] = CreatePlayerTextDraw(playerid, 293.000000, 183.000000, "thermite");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][13], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][13], 0.133330, 0.649998);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][13], 400.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][13], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][13], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][13], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][13], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][13], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][13], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][13], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][13], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][13], 0);

    BlackmarketTD[playerid][14] = CreatePlayerTextDraw(playerid, 243.000000, 135.000000, "Preview_Model");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][14], TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][14], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][14], 112.500000, 150.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][14], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][14], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][14], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][14], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][14], 0);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][14], 255);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][14], 0);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][14], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][14], 0);
    PlayerTextDrawSetPreviewModel(playerid, BlackmarketTD[playerid][14], 353);
    PlayerTextDrawSetPreviewRot(playerid, BlackmarketTD[playerid][14], -17.000000, 0.000000, 9.000000, 4.730013);
    PlayerTextDrawSetPreviewVehicleColours(playerid, BlackmarketTD[playerid][14], 1, 1);

    BlackmarketTD[playerid][15] = CreatePlayerTextDraw(playerid, 293.000000, 230.000000, "1,000,000,000$");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][15], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][15], 0.108331, 0.799997);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][15], 394.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][15], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][15], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][15], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][15], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][15], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][15], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][15], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][15], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][15], 0);

    BlackmarketTD[playerid][16] = CreatePlayerTextDraw(playerid, 293.000000, 242.000000, "add cart");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][16], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][16], 0.120830, 0.699998);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][16], 8.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][16], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][16], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][16], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][16], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][16], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][16], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][16], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][16], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][16], 1);

    // Item Slot 4
    BlackmarketTD[playerid][17] = CreatePlayerTextDraw(playerid, 344.000000, 182.000000, "_");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][17], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][17], 0.600000, 7.599997);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][17], 295.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][17], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][17], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][17], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][17], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][17], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][17], 471604479);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][17], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][17], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][17], 0);

    BlackmarketTD[playerid][18] = CreatePlayerTextDraw(playerid, 344.000000, 183.000000, "thermite");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][18], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][18], 0.133330, 0.649998);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][18], 400.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][18], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][18], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][18], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][18], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][18], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][18], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][18], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][18], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][18], 0);

    BlackmarketTD[playerid][19] = CreatePlayerTextDraw(playerid, 294.000000, 135.000000, "Preview_Model");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][19], TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][19], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][19], 112.500000, 150.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][19], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][19], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][19], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][19], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][19], 0);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][19], 255);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][19], 0);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][19], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][19], 0);
    PlayerTextDrawSetPreviewModel(playerid, BlackmarketTD[playerid][19], 353);
    PlayerTextDrawSetPreviewRot(playerid, BlackmarketTD[playerid][19], -17.000000, 0.000000, 9.000000, 4.730013);
    PlayerTextDrawSetPreviewVehicleColours(playerid, BlackmarketTD[playerid][19], 1, 1);

    BlackmarketTD[playerid][20] = CreatePlayerTextDraw(playerid, 344.000000, 230.000000, "1,000,000,000$");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][20], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][20], 0.108331, 0.799997);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][20], 394.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][20], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][20], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][20], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][20], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][20], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][20], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][20], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][20], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][20], 0);

    BlackmarketTD[playerid][21] = CreatePlayerTextDraw(playerid, 344.000000, 242.000000, "add cart");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][21], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][21], 0.120830, 0.699998);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][21], 8.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][21], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][21], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][21], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][21], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][21], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][21], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][21], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][21], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][21], 1);

    // Item Slot 5 (Bottom Row)
    BlackmarketTD[playerid][22] = CreatePlayerTextDraw(playerid, 191.000000, 256.000000, "_");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][22], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][22], 0.600000, 7.599997);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][22], 295.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][22], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][22], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][22], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][22], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][22], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][22], 471604479);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][22], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][22], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][22], 0);

    BlackmarketTD[playerid][23] = CreatePlayerTextDraw(playerid, 191.000000, 258.000000, "thermite");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][23], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][23], 0.133330, 0.649998);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][23], 400.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][23], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][23], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][23], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][23], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][23], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][23], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][23], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][23], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][23], 0);

    BlackmarketTD[playerid][24] = CreatePlayerTextDraw(playerid, 141.000000, 209.000000, "Preview_Model");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][24], TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][24], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][24], 112.500000, 150.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][24], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][24], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][24], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][24], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][24], 0);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][24], 255);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][24], 0);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][24], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][24], 0);
    PlayerTextDrawSetPreviewModel(playerid, BlackmarketTD[playerid][24], 353);
    PlayerTextDrawSetPreviewRot(playerid, BlackmarketTD[playerid][24], -17.000000, 0.000000, 9.000000, 4.730013);
    PlayerTextDrawSetPreviewVehicleColours(playerid, BlackmarketTD[playerid][24], 1, 1);

    BlackmarketTD[playerid][25] = CreatePlayerTextDraw(playerid, 191.000000, 305.000000, "1,000,000,000$");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][25], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][25], 0.108331, 0.799997);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][25], 394.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][25], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][25], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][25], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][25], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][25], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][25], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][25], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][25], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][25], 0);

    BlackmarketTD[playerid][26] = CreatePlayerTextDraw(playerid, 191.000000, 317.000000, "add cart");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][26], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][26], 0.120830, 0.699998);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][26], 8.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][26], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][26], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][26], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][26], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][26], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][26], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][26], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][26], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][26], 1);

    // Item Slot 6
    BlackmarketTD[playerid][27] = CreatePlayerTextDraw(playerid, 242.000000, 256.000000, "_");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][27], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][27], 0.600000, 7.599997);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][27], 295.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][27], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][27], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][27], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][27], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][27], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][27], 471604479);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][27], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][27], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][27], 0);

    BlackmarketTD[playerid][28] = CreatePlayerTextDraw(playerid, 242.000000, 258.000000, "thermite");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][28], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][28], 0.133330, 0.649998);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][28], 400.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][28], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][28], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][28], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][28], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][28], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][28], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][28], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][28], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][28], 0);

    BlackmarketTD[playerid][29] = CreatePlayerTextDraw(playerid, 193.000000, 209.000000, "Preview_Model");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][29], TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][29], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][29], 112.500000, 150.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][29], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][29], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][29], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][29], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][29], 0);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][29], 255);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][29], 0);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][29], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][29], 0);
    PlayerTextDrawSetPreviewModel(playerid, BlackmarketTD[playerid][29], 353);
    PlayerTextDrawSetPreviewRot(playerid, BlackmarketTD[playerid][29], -17.000000, 0.000000, 9.000000, 4.730013);
    PlayerTextDrawSetPreviewVehicleColours(playerid, BlackmarketTD[playerid][29], 1, 1);

    BlackmarketTD[playerid][30] = CreatePlayerTextDraw(playerid, 242.000000, 305.000000, "1,000,000,000$");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][30], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][30], 0.108331, 0.799997);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][30], 394.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][30], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][30], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][30], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][30], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][30], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][30], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][30], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][30], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][30], 0);

    BlackmarketTD[playerid][31] = CreatePlayerTextDraw(playerid, 242.000000, 317.000000, "add cart");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][31], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][31], 0.120830, 0.699998);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][31], 8.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][31], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][31], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][31], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][31], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][31], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][31], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][31], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][31], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][31], 1);

    // Item Slot 7
    BlackmarketTD[playerid][32] = CreatePlayerTextDraw(playerid, 293.000000, 256.000000, "_");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][32], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][32], 0.600000, 7.599997);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][32], 295.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][32], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][32], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][32], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][32], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][32], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][32], 471604479);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][32], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][32], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][32], 0);
    
    BlackmarketTD[playerid][33] = CreatePlayerTextDraw(playerid, 293.000000, 258.000000, "thermite");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][33], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][33], 0.133330, 0.649998);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][33], 400.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][33], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][33], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][33], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][33], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][33], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][33], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][33], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][33], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][33], 0);

    BlackmarketTD[playerid][34] = CreatePlayerTextDraw(playerid, 242.000000, 209.000000, "Preview_Model");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][34], TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][34], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][34], 112.500000, 150.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][34], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][34], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][34], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][34], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][34], 0);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][34], 255);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][34], 0);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][34], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][34], 0);
    PlayerTextDrawSetPreviewModel(playerid, BlackmarketTD[playerid][34], 353);
    PlayerTextDrawSetPreviewRot(playerid, BlackmarketTD[playerid][34], -17.000000, 0.000000, 9.000000, 4.730013);
    PlayerTextDrawSetPreviewVehicleColours(playerid, BlackmarketTD[playerid][34], 1, 1);

    BlackmarketTD[playerid][35] = CreatePlayerTextDraw(playerid, 293.000000, 305.000000, "1,000,000,000$");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][35], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][35], 0.108331, 0.799997);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][35], 394.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][35], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][35], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][35], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][35], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][35], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][35], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][35], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][35], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][35], 0);

    BlackmarketTD[playerid][36] = CreatePlayerTextDraw(playerid, 293.000000, 317.000000, "add cart");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][36], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][36], 0.120830, 0.699998);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][36], 8.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][36], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][36], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][36], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][36], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][36], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][36], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][36], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][36], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][36], 1);

    // Item Slot 8
    BlackmarketTD[playerid][37] = CreatePlayerTextDraw(playerid, 344.000000, 256.000000, "_");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][37], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][37], 0.600000, 7.599997);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][37], 295.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][37], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][37], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][37], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][37], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][37], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][37], 471604479);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][37], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][37], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][37], 0);

    BlackmarketTD[playerid][38] = CreatePlayerTextDraw(playerid, 344.000000, 258.000000, "thermite");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][38], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][38], 0.133330, 0.649998);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][38], 400.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][38], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][38], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][38], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][38], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][38], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][38], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][38], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][38], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][38], 0);

    BlackmarketTD[playerid][39] = CreatePlayerTextDraw(playerid, 294.000000, 209.000000, "Preview_Model");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][39], TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][39], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][39], 112.500000, 150.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][39], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][39], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][39], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][39], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][39], 0);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][39], 255);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][39], 0);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][39], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][39], 0);
    PlayerTextDrawSetPreviewModel(playerid, BlackmarketTD[playerid][39], 353);
    PlayerTextDrawSetPreviewRot(playerid, BlackmarketTD[playerid][39], -17.000000, 0.000000, 9.000000, 4.730013);
    PlayerTextDrawSetPreviewVehicleColours(playerid, BlackmarketTD[playerid][39], 1, 1);

    BlackmarketTD[playerid][40] = CreatePlayerTextDraw(playerid, 344.000000, 305.000000, "1,000,000,000$");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][40], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][40], 0.108331, 0.799997);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][40], 394.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][40], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][40], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][40], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][40], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][40], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][40], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][40], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][40], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][40], 0);

    BlackmarketTD[playerid][41] = CreatePlayerTextDraw(playerid, 344.000000, 317.000000, "add cart");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][41], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][41], 0.120830, 0.699998);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][41], 8.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][41], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][41], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][41], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][41], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][41], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][41], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][41], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][41], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][41], 1);

    // Navigation & Shopping Cart
    BlackmarketTD[playerid][42] = CreatePlayerTextDraw(playerid, 425.000000, 196.000000, "_");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][42], TEXT_DRAW_FONT_1);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][42], 0.600000, -0.300002);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][42], 295.000000, 81.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][42], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][42], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][42], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][42], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][42], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][42], -1061109505);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][42], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][42], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][42], 0);

    BlackmarketTD[playerid][43] = CreatePlayerTextDraw(playerid, 234.000000, 331.000000, "ld_beat:left");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][43], TEXT_DRAW_FONT_SPRITE);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][43], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][43], 11.500000, 10.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][43], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][43], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][43], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][43], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][43], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][43], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][43], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][43], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][43], 1);

    BlackmarketTD[playerid][44] = CreatePlayerTextDraw(playerid, 290.000000, 331.000000, "ld_beat:right");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][44], TEXT_DRAW_FONT_SPRITE);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][44], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][44], 11.500000, 10.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][44], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][44], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][44], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][44], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][44], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][44], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][44], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][44], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][44], 1);

    BlackmarketTD[playerid][45] = CreatePlayerTextDraw(playerid, 426.000000, 182.000000, "shopping carts");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][45], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][45], 0.150000, 0.949999);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][45], 400.000000, 117.500000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][45], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][45], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][45], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][45], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][45], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][45], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][45], 0);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][45], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][45], 0);

    // Cart Items Section
    BlackmarketTD[playerid][46] = CreatePlayerTextDraw(playerid, 384.500000, 199.000000, "thermite");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][46], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][46], 0.150000, 0.699999);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][46], 426.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][46], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][46], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][46], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][46], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][46], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][46], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][46], 0);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][46], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][46], 0);

    BlackmarketTD[playerid][47] = CreatePlayerTextDraw(playerid, 398.500000, 206.000000, "remove");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][47], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][47], 0.104166, 0.600000);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][47], 7.500000, 16.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][47], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][47], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][47], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][47], -16776961);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][47], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][47], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][47], 0);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][47], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][47], 1);

    BlackmarketTD[playerid][48] = CreatePlayerTextDraw(playerid, 424.000000, 205.000000, "ld_beat:left");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][48], TEXT_DRAW_FONT_SPRITE);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][48], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][48], 8.000000, 7.500000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][48], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][48], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][48], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][48], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][48], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][48], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][48], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][48], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][48], 1);

    BlackmarketTD[playerid][49] = CreatePlayerTextDraw(playerid, 444.500000, 205.000000, "100");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][49], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][49], 0.150000, 0.699999);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][49], 426.000000, 20.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][49], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][49], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][49], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][49], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][49], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][49], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][49], 0);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][49], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][49], 0);

    BlackmarketTD[playerid][50] = CreatePlayerTextDraw(playerid, 457.000000, 205.000000, "ld_beat:right");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][50], TEXT_DRAW_FONT_SPRITE);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][50], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][50], 8.000000, 7.500000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][50], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][50], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][50], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][50], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][50], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][50], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][50], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][50], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][50], 1);

    BlackmarketTD[playerid][51] = CreatePlayerTextDraw(playerid, 384.500000, 221.000000, "thermite");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][51], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][51], 0.150000, 0.699999);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][51], 426.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][51], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][51], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][51], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][51], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][51], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][51], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][51], 0);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][51], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][51], 0);

    BlackmarketTD[playerid][52] = CreatePlayerTextDraw(playerid, 398.500000, 228.000000, "remove");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][52], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][52], 0.104166, 0.600000);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][52], 7.500000, 16.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][52], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][52], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][52], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][52], -16776961);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][52], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][52], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][52], 0);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][52], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][52], 1);

    BlackmarketTD[playerid][53] = CreatePlayerTextDraw(playerid, 424.000000, 228.000000, "ld_beat:left");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][53], TEXT_DRAW_FONT_SPRITE);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][53], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][53], 8.000000, 7.500000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][53], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][53], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][53], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][53], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][53], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][53], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][53], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][53], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][53], 1);

    BlackmarketTD[playerid][54] = CreatePlayerTextDraw(playerid, 444.500000, 228.000000, "100");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][54], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][54], 0.150000, 0.699999);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][54], 426.000000, 20.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][54], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][54], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][54], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][54], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][54], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][54], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][54], 0);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][54], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][54], 0);

    BlackmarketTD[playerid][55] = CreatePlayerTextDraw(playerid, 457.000000, 228.000000, "ld_beat:right");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][55], TEXT_DRAW_FONT_SPRITE);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][55], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][55], 8.000000, 7.500000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][55], 1);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][55], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][55], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][55], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][55], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][55], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][55], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][55], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][55], 1);

    // Total & Checkout
    BlackmarketTD[playerid][56] = CreatePlayerTextDraw(playerid, 384.500000, 316.000000, "total");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][56], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][56], 0.150000, 0.699999);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][56], 426.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][56], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][56], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][56], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][56], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][56], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][56], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][56], 0);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][56], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][56], 0);

    BlackmarketTD[playerid][57] = CreatePlayerTextDraw(playerid, 443.000000, 315.000000, "1,000,000,000$");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][57], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][57], 0.108331, 0.799997);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][57], 394.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][57], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][57], 0);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][57], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][57], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][57], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][57], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][57], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][57], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][57], 0);

    BlackmarketTD[playerid][58] = CreatePlayerTextDraw(playerid, 443.000000, 329.000000, "check out");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][58], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][58], 0.120830, 0.699998);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][58], 8.000000, 46.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][58], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][58], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][58], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][58], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][58], 255);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][58], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][58], 1);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][58], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][58], 1);

    // Title Header
    BlackmarketTD[playerid][59] = CreatePlayerTextDraw(playerid, 261.000000, 169.000000, "Southside Black Market");
    PlayerTextDrawFont(playerid, BlackmarketTD[playerid][59], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, BlackmarketTD[playerid][59], 0.170833, 0.900000);
    PlayerTextDrawTextSize(playerid, BlackmarketTD[playerid][59], 400.000000, 132.000000);
    PlayerTextDrawSetOutline(playerid, BlackmarketTD[playerid][59], 0);
    PlayerTextDrawSetShadow(playerid, BlackmarketTD[playerid][59], 1);
    PlayerTextDrawAlignment(playerid, BlackmarketTD[playerid][59], TEXT_DRAW_ALIGN_CENTER);
    PlayerTextDrawColour(playerid, BlackmarketTD[playerid][59], -1);
    PlayerTextDrawBackgroundColour(playerid, BlackmarketTD[playerid][59], 6750207);
    PlayerTextDrawBoxColour(playerid, BlackmarketTD[playerid][59], 50);
    PlayerTextDrawUseBox(playerid, BlackmarketTD[playerid][59], 0);
    PlayerTextDrawSetProportional(playerid, BlackmarketTD[playerid][59], 1);
    PlayerTextDrawSetSelectable(playerid, BlackmarketTD[playerid][59], 0);
    return 1;
}

forward UpdatePlayerHUD(playerid);
public UpdatePlayerHUD(playerid)
{
    if(!IsPlayerConnected(playerid))
        return 0;

    new year, month, day;
    new hour, minute, second;

    // Kukunin nito ang eksaktong oras at petsa ng server host mo
    getdate(year, month, day);
    gettime(hour, minute, second);

    // --- TIME TEXTDRAW (DateTD[playerid][0]) ---
    new timeStr[12];
    new displayHour = hour;

    // Format: "12:00 PM"
    format(timeStr, sizeof(timeStr), "%02d:%02d", displayHour, minute);
    PlayerTextDrawSetString(playerid, DateTD[playerid][0], timeStr);

    new dateStr[16];
    format(dateStr, sizeof(dateStr), "%02d/%02d/%d", month, day, year);
    PlayerTextDrawSetString(playerid, DateTD[playerid][1], dateStr);

    // --- PING TEXTDRAW (DateTD[playerid][3]) ---
    new pingStr[10];
    format(pingStr, sizeof(pingStr), "%dMS", GetPlayerPing(playerid));
    PlayerTextDrawSetString(playerid, DateTD[playerid][3], pingStr);

    // I-show muli ang textdraws para mag-update ang visual sa screen ng player
    PlayerTextDrawShow(playerid, DateTD[playerid][0]);
    PlayerTextDrawShow(playerid, DateTD[playerid][1]);
    PlayerTextDrawShow(playerid, DateTD[playerid][3]);

    return 1;
}

stock ShowPlayerHUD(playerid, bool:show)
{
    for(new i = 0; i < 4; i++) {
        if(show) PlayerTextDrawShow(playerid, DateTD[playerid][i]);
        else PlayerTextDrawHide(playerid, DateTD[playerid][i]);
    }
}

hook OnPlayerSpawn(playerid) 
{
    ShowPlayerHUD(playerid, true);
    UpdatePlayerHUD(playerid);  
    
    if(DateTimer[playerid] != -1) KillTimer(DateTimer[playerid]);
    DateTimer[playerid] = SetTimerEx("UpdatePlayerHUD", 60000, true, "i", playerid);
    
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(DateTimer[playerid] != -1) {
        KillTimer(DateTimer[playerid]);
        DateTimer[playerid] = -1;
    }
    return 1;
}