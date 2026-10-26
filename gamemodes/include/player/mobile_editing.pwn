#include <YSI_Coding\y_hooks>

new PlayerText:MobileClothingTD[MAX_PLAYERS][31];

LoadClothingTextdraws(playerid)
{
	MobileClothingTD[playerid][0] = CreatePlayerTextDraw(playerid, 213.000000, 196.000000, "POSITION");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][0], TEXT_DRAW_FONT:2);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][0], 0.383332, 1.350000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][0], 400.000000, 117.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][0], TEXT_DRAW_ALIGN:2);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][0], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][0], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][0], 0);

	MobileClothingTD[playerid][1] = CreatePlayerTextDraw(playerid, 235.000000, 218.000000, "ld_beat:right");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][1], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][1], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][1], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][1], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][1], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][1], 1);

	MobileClothingTD[playerid][2] = CreatePlayerTextDraw(playerid, 212.000000, 245.000000, "Y");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][2], TEXT_DRAW_FONT:2);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][2], 0.508333, 1.850000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][2], 400.000000, 117.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][2], TEXT_DRAW_ALIGN:2);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][2], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][2], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][2], 0);

	MobileClothingTD[playerid][3] = CreatePlayerTextDraw(playerid, 235.000000, 246.000000, "ld_beat:right");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][3], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][3], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][3], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][3], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][3], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][3], 1);

	MobileClothingTD[playerid][4] = CreatePlayerTextDraw(playerid, 173.000000, 218.000000, "ld_beat:left");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][4], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][4], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][4], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][4], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][4], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][4], 1);

	MobileClothingTD[playerid][5] = CreatePlayerTextDraw(playerid, 212.000000, 217.000000, "X");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][5], TEXT_DRAW_FONT:2);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][5], 0.508333, 1.850000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][5], 400.000000, 117.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][5], TEXT_DRAW_ALIGN:2);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][5], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][5], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][5], 0);

	MobileClothingTD[playerid][6] = CreatePlayerTextDraw(playerid, 212.000000, 272.000000, "Z");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][6], TEXT_DRAW_FONT:2);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][6], 0.508333, 1.850000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][6], 400.000000, 117.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][6], TEXT_DRAW_ALIGN:2);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][6], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][6], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][6], 0);

	MobileClothingTD[playerid][7] = CreatePlayerTextDraw(playerid, 173.000000, 246.000000, "ld_beat:left");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][7], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][7], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][7], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][7], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][7], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][7], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][7], 1);

	MobileClothingTD[playerid][8] = CreatePlayerTextDraw(playerid, 173.000000, 273.000000, "ld_beat:left");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][8], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][8], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][8], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][8], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][8], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][8], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][8], 1);

	MobileClothingTD[playerid][9] = CreatePlayerTextDraw(playerid, 235.000000, 273.000000, "ld_beat:right");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][9], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][9], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][9], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][9], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][9], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][9], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][9], 1);

	MobileClothingTD[playerid][10] = CreatePlayerTextDraw(playerid, 437.000000, 196.000000, "ROTATION");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][10], TEXT_DRAW_FONT:2);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][10], 0.383332, 1.350000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][10], 400.000000, 117.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][10], TEXT_DRAW_ALIGN:2);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][10], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][10], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][10], 0);

	MobileClothingTD[playerid][11] = CreatePlayerTextDraw(playerid, 438.000000, 217.000000, "X");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][11], TEXT_DRAW_FONT:2);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][11], 0.508333, 1.850000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][11], 400.000000, 117.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][11], TEXT_DRAW_ALIGN:2);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][11], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][11], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][11], 0);

	MobileClothingTD[playerid][12] = CreatePlayerTextDraw(playerid, 458.000000, 218.000000, "ld_beat:right");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][12], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][12], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][12], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][12], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][12], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][12], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][12], 1);

	MobileClothingTD[playerid][13] = CreatePlayerTextDraw(playerid, 438.000000, 245.000000, "Y");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][13], TEXT_DRAW_FONT:2);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][13], 0.508333, 1.850000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][13], 400.000000, 117.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][13], TEXT_DRAW_ALIGN:2);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][13], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][13], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][13], 0);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][13], 0);

	MobileClothingTD[playerid][14] = CreatePlayerTextDraw(playerid, 439.000000, 272.000000, "Z");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][14], TEXT_DRAW_FONT:2);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][14], 0.508333, 1.850000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][14], 400.000000, 117.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][14], TEXT_DRAW_ALIGN:2);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][14], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][14], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][14], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][14], 0);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][14], 0);

	MobileClothingTD[playerid][15] = CreatePlayerTextDraw(playerid, 400.000000, 218.000000, "ld_beat:left");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][15], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][15], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][15], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][15], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][15], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][15], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][15], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][15], 1);

	MobileClothingTD[playerid][16] = CreatePlayerTextDraw(playerid, 437.000000, 322.000000, "SCALE");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][16], TEXT_DRAW_FONT:2);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][16], 0.383332, 1.350000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][16], 400.000000, 117.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][16], 0);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][16], TEXT_DRAW_ALIGN:2);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][16], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][16], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][16], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][16], 0);

	MobileClothingTD[playerid][17] = CreatePlayerTextDraw(playerid, 458.000000, 246.000000, "ld_beat:right");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][17], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][17], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][17], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][17], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][17], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][17], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][17], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][17], 1);

	MobileClothingTD[playerid][18] = CreatePlayerTextDraw(playerid, 459.000000, 273.000000, "ld_beat:right");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][18], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][18], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][18], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][18], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][18], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][18], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][18], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][18], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][18], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][18], 1);

	MobileClothingTD[playerid][19] = CreatePlayerTextDraw(playerid, 400.000000, 246.000000, "ld_beat:left");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][19], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][19], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][19], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][19], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][19], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][19], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][19], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][19], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][19], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][19], 1);

	MobileClothingTD[playerid][20] = CreatePlayerTextDraw(playerid, 399.000000, 273.000000, "ld_beat:left");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][20], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][20], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][20], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][20], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][20], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][20], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][20], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][20], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][20], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][20], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][20], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][20], 1);

	MobileClothingTD[playerid][21] = CreatePlayerTextDraw(playerid, 438.000000, 344.000000, "X");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][21], TEXT_DRAW_FONT:2);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][21], 0.508333, 1.850000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][21], 400.000000, 117.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][21], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][21], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][21], TEXT_DRAW_ALIGN:2);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][21], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][21], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][21], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][21], 0);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][21], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][21], 0);

	MobileClothingTD[playerid][22] = CreatePlayerTextDraw(playerid, 438.000000, 374.000000, "Y");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][22], TEXT_DRAW_FONT:2);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][22], 0.508333, 1.850000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][22], 400.000000, 117.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][22], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][22], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][22], TEXT_DRAW_ALIGN:2);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][22], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][22], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][22], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][22], 0);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][22], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][22], 0);

	MobileClothingTD[playerid][23] = CreatePlayerTextDraw(playerid, 439.000000, 401.000000, "Z");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][23], TEXT_DRAW_FONT:2);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][23], 0.508333, 1.850000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][23], 400.000000, 117.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][23], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][23], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][23], TEXT_DRAW_ALIGN:2);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][23], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][23], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][23], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][23], 0);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][23], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][23], 0);

	MobileClothingTD[playerid][24] = CreatePlayerTextDraw(playerid, 400.000000, 344.000000, "ld_beat:left");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][24], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][24], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][24], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][24], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][24], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][24], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][24], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][24], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][24], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][24], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][24], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][24], 1);

	MobileClothingTD[playerid][25] = CreatePlayerTextDraw(playerid, 400.000000, 374.000000, "ld_beat:left");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][25], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][25], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][25], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][25], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][25], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][25], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][25], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][25], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][25], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][25], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][25], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][25], 1);

	MobileClothingTD[playerid][26] = CreatePlayerTextDraw(playerid, 400.000000, 401.000000, "ld_beat:left");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][26], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][26], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][26], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][26], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][26], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][26], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][26], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][26], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][26], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][26], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][26], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][26], 1);

	MobileClothingTD[playerid][27] = CreatePlayerTextDraw(playerid, 459.000000, 344.000000, "ld_beat:right");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][27], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][27], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][27], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][27], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][27], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][27], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][27], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][27], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][27], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][27], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][27], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][27], 1);

	MobileClothingTD[playerid][28] = CreatePlayerTextDraw(playerid, 459.000000, 374.000000, "ld_beat:right");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][28], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][28], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][28], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][28], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][28], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][28], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][28], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][28], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][28], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][28], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][28], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][28], 1);

	MobileClothingTD[playerid][29] = CreatePlayerTextDraw(playerid, 459.000000, 401.000000, "ld_beat:right");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][29], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][29], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][29], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][29], 1);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][29], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][29], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][29], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][29], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][29], 50);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][29], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][29], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][29], 1);

	MobileClothingTD[playerid][30] = CreatePlayerTextDraw(playerid, 215.000000, 374.000000, "FINISH");
	PlayerTextDrawFont(playerid, MobileClothingTD[playerid][30], TEXT_DRAW_FONT:2);
	PlayerTextDrawLetterSize(playerid, MobileClothingTD[playerid][30], 0.399998, 1.549999);
	PlayerTextDrawTextSize(playerid, MobileClothingTD[playerid][30], 12.500000, 115.500000);
	PlayerTextDrawSetOutline(playerid, MobileClothingTD[playerid][30], 0);
	PlayerTextDrawSetShadow(playerid, MobileClothingTD[playerid][30], 0);
	PlayerTextDrawAlignment(playerid, MobileClothingTD[playerid][30], TEXT_DRAW_ALIGN:2);
	PlayerTextDrawColour(playerid, MobileClothingTD[playerid][30], -1);
	PlayerTextDrawBackgroundColour(playerid, MobileClothingTD[playerid][30], 255);
	PlayerTextDrawBoxColour(playerid, MobileClothingTD[playerid][30], -1962934222);
	PlayerTextDrawUseBox(playerid, MobileClothingTD[playerid][30], 1);
	PlayerTextDrawSetProportional(playerid, MobileClothingTD[playerid][30], 1);
	PlayerTextDrawSetSelectable(playerid, MobileClothingTD[playerid][30], 1);
    return 1;
}

stock ShowMobileClothing(playerid, bool:show)
{
	if(show == true)
	{
        for(new idx = 0; idx < 31; idx++) PlayerTextDrawShow(playerid, MobileClothingTD[playerid][idx]);
        SelectTextDraw(playerid, COLOR_GREEN);
		SendClientMessage(playerid, COLOR_RED, "HINT: "YELLOW"Position your camera differently to better see where your editing");
        SendClientMessage(playerid, COLOR_YELLOW, "Type /cursor to get back your cursor active.");
    }
	else if(show == false)
	{
        for(new idx = 0; idx < 31; idx++) PlayerTextDrawHide(playerid, MobileClothingTD[playerid][idx]);
        CancelSelectTextDraw(playerid);
    }
}

CMD:cursor(playerid, params[])
{
	SelectTextDraw(playerid, COLOR_GREEN);
	return 1;
}

hook OnPlayerConnect(playerid)
{
    LoadClothingTextdraws(playerid);
    return 1;
}

hook OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	new clothingid = PlayerInfo[playerid][pSelected];
	//POSITION 
	if(playertextid == MobileClothingTD[playerid][4]) // X LEFT    
	{
		new Float:fOffsetX = 0.01;
		ClothingInfo[playerid][clothingid][cPosX] += fOffsetX;
		ClothingInfo[playerid][clothingid][cAttached] = 1;

		RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET pos_x = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cPosX], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	if(playertextid == MobileClothingTD[playerid][1]) // X RIGHT    
	{
		new Float:fOffsetX = -0.01;

		ClothingInfo[playerid][clothingid][cPosX] += fOffsetX;
		ClothingInfo[playerid][clothingid][cAttached] = 1;

		RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET pos_x = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cPosX], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);
	}        
	if(playertextid == MobileClothingTD[playerid][7]) // Y LEFT    
	{
		new Float:fOffsetY = 0.01;

		ClothingInfo[playerid][clothingid][cPosY] += fOffsetY;
		ClothingInfo[playerid][clothingid][cAttached] = 1;
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);
		//SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX]);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET pos_y = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cPosY], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	if(playertextid == MobileClothingTD[playerid][3]) // Y RIGHT    
	{
		
		new Float:fOffsetY = -0.01;

		ClothingInfo[playerid][clothingid][cPosY] += fOffsetY;
		ClothingInfo[playerid][clothingid][cAttached] = 1;

		RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);
		//SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX]);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET pos_y = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cPosY], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);
	}   
	if(playertextid == MobileClothingTD[playerid][8]) // Z LEFT    
	{
		
		new Float:fOffsetZ = 0.01;

		ClothingInfo[playerid][clothingid][cPosZ] += fOffsetZ;
		ClothingInfo[playerid][clothingid][cAttached] = 1;

		RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);
		//SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX]);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET pos_Z = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cPosZ], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	if(playertextid == MobileClothingTD[playerid][9]) // Z RIGHT    
	{
		new Float:fOffsetZ = -0.01;

		ClothingInfo[playerid][clothingid][cPosZ] += fOffsetZ;
		ClothingInfo[playerid][clothingid][cAttached] = 1;

		RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);
		//SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX]);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET pos_Z = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cPosZ], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);
	}   
	//ROTATION
	if(playertextid == MobileClothingTD[playerid][15]) // X LEFT    
	{
		new Float:fRotX = 2.5;

		ClothingInfo[playerid][clothingid][cRotX] += fRotX;
		ClothingInfo[playerid][clothingid][cAttached] = 1;

		RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);
		//SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX]);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET rot_x = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cRotX], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	if(playertextid == MobileClothingTD[playerid][12]) // X RIGHT    
	{
		new Float:fRotX = -2.5;

		ClothingInfo[playerid][clothingid][cRotX] += fRotX;
		ClothingInfo[playerid][clothingid][cAttached] = 1;

		RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);
		//SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX]);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET rot_x = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cRotX], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);
	}        
	if(playertextid == MobileClothingTD[playerid][19]) // Y LEFT    
	{
		new Float:fRotY = 2.5;

		ClothingInfo[playerid][clothingid][cRotY] += fRotY;
		ClothingInfo[playerid][clothingid][cAttached] = 1;

		RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);
		//SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX]);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET rot_y = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cRotY], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	if(playertextid == MobileClothingTD[playerid][17]) // Y RIGHT    
	{
		new Float:fRotY = -2.5;

		ClothingInfo[playerid][clothingid][cRotY] += fRotY;
		ClothingInfo[playerid][clothingid][cAttached] = 1;

		RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);
		//SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX]);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET rot_y = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cRotY], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);
	}   
	if(playertextid == MobileClothingTD[playerid][20]) // Z LEFT    
	{
		new Float:fRotZ = 2.5;

		ClothingInfo[playerid][clothingid][cRotZ] += fRotZ;
		ClothingInfo[playerid][clothingid][cAttached] = 1;

		RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);
		//SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX]);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET rot_z = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cRotZ], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	if(playertextid == MobileClothingTD[playerid][18]) // Z RIGHT    
	{
		new Float:fRotZ = -2.5;

		ClothingInfo[playerid][clothingid][cRotZ] += fRotZ;
		ClothingInfo[playerid][clothingid][cAttached] = 1;

		RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);
		//SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX]);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET rot_z = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cRotZ], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);
	}           
	//SCALE
	if(playertextid == MobileClothingTD[playerid][24]) // X LEFT    
	{
		new Float:fScaleX = 0.1;

		ClothingInfo[playerid][clothingid][cScaleX] += fScaleX;
		ClothingInfo[playerid][clothingid][cAttached] = 1;

		RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);
		//SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX]);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET scale_x = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cScaleX], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	if(playertextid == MobileClothingTD[playerid][27]) // X RIGHT    
	{
		new Float:fScaleX = -0.1;

		ClothingInfo[playerid][clothingid][cScaleX] += fScaleX;
		ClothingInfo[playerid][clothingid][cAttached] = 1;

		RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);
		//SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX]);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET scale_x = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cScaleX], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);
	}        
	if(playertextid == MobileClothingTD[playerid][25]) // Y LEFT    
	{
		new Float:fScaleY = 0.1;

		ClothingInfo[playerid][clothingid][cScaleY] += fScaleY;
		ClothingInfo[playerid][clothingid][cAttached] = 1;

		RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);
		//SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX]);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET scale_y = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cScaleY], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	if(playertextid == MobileClothingTD[playerid][28]) // Y RIGHT    
	{
		
		new Float:fScaleY = -0.1;

		ClothingInfo[playerid][clothingid][cScaleY] += fScaleY;
		ClothingInfo[playerid][clothingid][cAttached] = 1;

		RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);
		//SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX]);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET scale_y = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cScaleY], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);

	}   
	if(playertextid == MobileClothingTD[playerid][26]) // Z LEFT    
	{
		new Float:fScaleZ = 0.1;

		ClothingInfo[playerid][clothingid][cScaleZ] += fScaleZ;
		ClothingInfo[playerid][clothingid][cAttached] = 1;

		RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);
		
		//SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX]);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET scale_z = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cScaleZ], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	if(playertextid == MobileClothingTD[playerid][29]) // Z RIGHT    
	{
		new Float:fScaleZ = -0.1;

		ClothingInfo[playerid][clothingid][cScaleZ] += fScaleZ;
		ClothingInfo[playerid][clothingid][cAttached] = 1;

		RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex]);
		SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cPosZ],
				ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerInfo[playerid][pSelected]][cScaleZ]);
		
		//SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX]);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE clothing SET scale_z = '%f' WHERE id = %i", ClothingInfo[playerid][clothingid][cScaleZ], ClothingInfo[playerid][clothingid][cID]);
		mysql_tquery(connectionID, queryBuffer);
	}         
	// FINISH
	if(playertextid == MobileClothingTD[playerid][30]) // FINISH
	{
		ShowMobileClothing(playerid, false);
	}     
	return 1;
}