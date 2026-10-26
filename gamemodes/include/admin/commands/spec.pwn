#include <YSI_Coding\y_hooks> 

new PlayerText:SpecTD[MAX_PLAYERS][31];

stock CreateSpecTextDraws(playerid)
{
	SpecTD[playerid][0] = CreatePlayerTextDraw(playerid, 324.000000, 319.000000, "_");
	PlayerTextDrawFont(playerid, SpecTD[playerid][0], TEXT_DRAW_FONT_1);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][0], 0.600000, 10.300003);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][0], 294.000000, 159.500000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][0], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColor(playerid, SpecTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][0], -16776961);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][0], 0);

	SpecTD[playerid][1] = CreatePlayerTextDraw(playerid, 324.000000, 320.000000, "_");
	PlayerTextDrawFont(playerid, SpecTD[playerid][1], TEXT_DRAW_FONT_1);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][1], 0.600000, 10.100006);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][1], 298.500000, 158.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][1], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColor(playerid, SpecTD[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][1], 387389439);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][1], 0);

	SpecTD[playerid][2] = CreatePlayerTextDraw(playerid, 264.000000, 324.000000, "_");
	PlayerTextDrawFont(playerid, SpecTD[playerid][2], TEXT_DRAW_FONT_1);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][2], 0.600000, 4.299983);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][2], 298.500000, 30.500000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][2], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColor(playerid, SpecTD[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][2], 471604479);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][2], 0);

	SpecTD[playerid][3] = CreatePlayerTextDraw(playerid, 227.000000, 311.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, SpecTD[playerid][3], TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][3], 73.000000, 60.500000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][3], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][3], 0);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][3], 255);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][3], 0);
	PlayerTextDrawSetPreviewModel(playerid, SpecTD[playerid][3], 0);
	PlayerTextDrawSetPreviewRot(playerid, SpecTD[playerid][3], -1.000000, 0.000000, -5.000000, 1.519999);
	PlayerTextDrawSetPreviewVehCol(playerid, SpecTD[playerid][3], 1, 1);

	SpecTD[playerid][4] = CreatePlayerTextDraw(playerid, 284.000000, 322.000000, "spectating -");
	PlayerTextDrawFont(playerid, SpecTD[playerid][4], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][4], 0.104166, 0.550000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][4], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][4], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][4], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][4], 0);

	SpecTD[playerid][5] = CreatePlayerTextDraw(playerid, 284.000000, 329.000000, "spynixxx_s._santo");
	PlayerTextDrawFont(playerid, SpecTD[playerid][5], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][5], 0.133331, 0.699998);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][5], 340.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][5], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][5], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][5], -764862721);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][5], 0);

	SpecTD[playerid][6] = CreatePlayerTextDraw(playerid, 284.000000, 336.000000, "id: 10");
	PlayerTextDrawFont(playerid, SpecTD[playerid][6], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][6], 0.112498, 0.600000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][6], 328.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][6], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][6], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][6], 0);

	SpecTD[playerid][7] = CreatePlayerTextDraw(playerid, 284.000000, 348.000000, "weapon:");
	PlayerTextDrawFont(playerid, SpecTD[playerid][7], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][7], 0.104166, 0.550000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][7], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][7], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][7], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][7], 0);

	SpecTD[playerid][8] = CreatePlayerTextDraw(playerid, 309.000000, 348.000000, "m4 (10000)");
	PlayerTextDrawFont(playerid, SpecTD[playerid][8], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][8], 0.104166, 0.550000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][8], 346.000000, 57.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][8], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][8], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][8], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][8], 0);

	SpecTD[playerid][9] = CreatePlayerTextDraw(playerid, 284.000000, 355.000000, "money:");
	PlayerTextDrawFont(playerid, SpecTD[playerid][9], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][9], 0.104166, 0.550000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][9], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][9], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][9], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][9], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][9], 0);

	SpecTD[playerid][10] = CreatePlayerTextDraw(playerid, 309.000000, 355.000000, "~g~$~w~1,000,000,000");
	PlayerTextDrawFont(playerid, SpecTD[playerid][10], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][10], 0.104166, 0.550000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][10], 349.500000, 57.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][10], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][10], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][10], 0);

	SpecTD[playerid][11] = CreatePlayerTextDraw(playerid, 284.000000, 362.000000, "speed:");
	PlayerTextDrawFont(playerid, SpecTD[playerid][11], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][11], 0.104166, 0.550000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][11], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][11], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][11], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][11], 0);

	SpecTD[playerid][12] = CreatePlayerTextDraw(playerid, 309.000000, 362.000000, "1.2 mps");
	PlayerTextDrawFont(playerid, SpecTD[playerid][12], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][12], 0.104166, 0.550000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][12], 347.500000, 57.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][12], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][12], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][12], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][12], 0);

	SpecTD[playerid][13] = CreatePlayerTextDraw(playerid, 369.000000, 341.000000, "health: ~r~100");
	PlayerTextDrawFont(playerid, SpecTD[playerid][13], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][13], 0.104166, 0.550000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][13], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][13], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][13], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][13], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][13], 0);

	SpecTD[playerid][14] = CreatePlayerTextDraw(playerid, 359.000000, 349.000000, "ld_bum:blkdot");
	PlayerTextDrawFont(playerid, SpecTD[playerid][14], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][14], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][14], 43.500000, 3.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][14], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][14], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][14], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][14], 471604479);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][14], 0);

	SpecTD[playerid][15] = CreatePlayerTextDraw(playerid, 359.000000, 349.000000, "ld_bum:blkdot");
	PlayerTextDrawFont(playerid, SpecTD[playerid][15], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][15], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][15], 32.500000, 3.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][15], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][15], -1962934017);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][15], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][15], 471604479);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][15], 0);

	SpecTD[playerid][16] = CreatePlayerTextDraw(playerid, 370.000000, 355.000000, "armor: ~b~100");
	PlayerTextDrawFont(playerid, SpecTD[playerid][16], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][16], 0.104166, 0.550000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][16], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][16], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][16], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][16], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][16], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][16], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][16], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][16], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][16], 0);

	SpecTD[playerid][17] = CreatePlayerTextDraw(playerid, 359.000000, 363.000000, "ld_bum:blkdot");
	PlayerTextDrawFont(playerid, SpecTD[playerid][17], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][17], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][17], 43.500000, 3.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][17], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][17], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][17], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][17], 471604479);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][17], 0);

	SpecTD[playerid][18] = CreatePlayerTextDraw(playerid, 359.000000, 363.000000, "ld_bum:blkdot");
	PlayerTextDrawFont(playerid, SpecTD[playerid][18], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][18], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][18], 32.500000, 3.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][18], 0);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][18], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][18], 35839);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][18], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][18], 471604479);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][18], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][18], 0);

	SpecTD[playerid][19] = CreatePlayerTextDraw(playerid, 393.000000, 321.000000, "100");
	PlayerTextDrawFont(playerid, SpecTD[playerid][19], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][19], 0.112498, 0.600000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][19], 328.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][19], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][19], 0);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][19], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][19], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][19], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][19], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][19], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][19], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][19], 0);

	SpecTD[playerid][20] = CreatePlayerTextDraw(playerid, 264.000000, 368.000000, "_");
	PlayerTextDrawFont(playerid, SpecTD[playerid][20], TEXT_DRAW_FONT_1);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][20], 0.600000, 4.299983);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][20], 298.500000, 30.500000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][20], 1);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][20], 0);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][20], TEXT_DRAW_ALIGN_CENTER);
	PlayerTextDrawColor(playerid, SpecTD[playerid][20], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][20], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][20], 471604479);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][20], 1);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][20], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][20], 0);
	
	SpecTD[playerid][21] = CreatePlayerTextDraw(playerid, 227.000000, 356.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, SpecTD[playerid][21], TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][21], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][21], 73.000000, 60.500000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][21], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][21], 0);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][21], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][21], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][21], 0);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][21], 255);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][21], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][21], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][21], 0);
	PlayerTextDrawSetPreviewModel(playerid, SpecTD[playerid][21], 445);
	PlayerTextDrawSetPreviewRot(playerid, SpecTD[playerid][21], -2.000000, 0.000000, -49.000000, 1.909999);
	PlayerTextDrawSetPreviewVehCol(playerid, SpecTD[playerid][21], 1, 1);

	SpecTD[playerid][22] = CreatePlayerTextDraw(playerid, 284.000000, 378.000000, "vehicle info:");
	PlayerTextDrawFont(playerid, SpecTD[playerid][22], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][22], 0.104166, 0.550000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][22], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][22], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][22], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][22], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][22], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][22], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][22], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][22], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][22], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][22], 0);

	SpecTD[playerid][23] = CreatePlayerTextDraw(playerid, 284.000000, 388.000000, "sultan");
	PlayerTextDrawFont(playerid, SpecTD[playerid][23], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][23], 0.133331, 0.699998);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][23], 314.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][23], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][23], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][23], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][23], -764862721);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][23], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][23], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][23], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][23], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][23], 0);

	SpecTD[playerid][24] = CreatePlayerTextDraw(playerid, 284.000000, 395.000000, "model: 445");
	PlayerTextDrawFont(playerid, SpecTD[playerid][24], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][24], 0.112498, 0.600000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][24], 328.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][24], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][24], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][24], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][24], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][24], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][24], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][24], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][24], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][24], 0);

	SpecTD[playerid][25] = CreatePlayerTextDraw(playerid, 319.000000, 388.000000, "speed:");
	PlayerTextDrawFont(playerid, SpecTD[playerid][25], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][25], 0.104166, 0.550000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][25], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][25], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][25], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][25], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][25], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][25], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][25], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][25], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][25], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][25], 0);

	SpecTD[playerid][26] = CreatePlayerTextDraw(playerid, 337.000000, 388.000000, "1000 kps");
	PlayerTextDrawFont(playerid, SpecTD[playerid][26], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][26], 0.104166, 0.550000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][26], 368.000000, 57.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][26], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][26], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][26], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][26], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][26], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][26], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][26], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][26], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][26], 0);

	SpecTD[playerid][27] = CreatePlayerTextDraw(playerid, 319.000000, 395.000000, "health:");
	PlayerTextDrawFont(playerid, SpecTD[playerid][27], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][27], 0.104166, 0.550000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][27], 400.000000, 57.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][27], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][27], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][27], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][27], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][27], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][27], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][27], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][27], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][27], 0);

	SpecTD[playerid][28] = CreatePlayerTextDraw(playerid, 339.000000, 395.000000, "10000000");
	PlayerTextDrawFont(playerid, SpecTD[playerid][28], TEXT_DRAW_FONT_2);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][28], 0.104166, 0.550000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][28], 368.000000, 57.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][28], 0);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][28], 1);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][28], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][28], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][28], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][28], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][28], 0);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][28], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][28], 0);

	SpecTD[playerid][29] = CreatePlayerTextDraw(playerid, 375.000000, 397.000000, "ld_beat:left");
	PlayerTextDrawFont(playerid, SpecTD[playerid][29], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][29], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][29], 9.000000, 11.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][29], 1);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][29], 0);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][29], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][29], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][29], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][29], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][29], 1);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][29], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][29], 1);

	SpecTD[playerid][30] = CreatePlayerTextDraw(playerid, 392.000000, 397.000000, "ld_beat:right");
	PlayerTextDrawFont(playerid, SpecTD[playerid][30], TEXT_DRAW_FONT_SPRITE_DRAW);
	PlayerTextDrawLetterSize(playerid, SpecTD[playerid][30], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, SpecTD[playerid][30], 9.000000, 11.000000);
	PlayerTextDrawSetOutline(playerid, SpecTD[playerid][30], 1);
	PlayerTextDrawSetShadow(playerid, SpecTD[playerid][30], 0);
	PlayerTextDrawAlignment(playerid, SpecTD[playerid][30], TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawColor(playerid, SpecTD[playerid][30], -1);
	PlayerTextDrawBackgroundColor(playerid, SpecTD[playerid][30], 255);
	PlayerTextDrawBoxColor(playerid, SpecTD[playerid][30], 50);
	PlayerTextDrawUseBox(playerid, SpecTD[playerid][30], 1);
	PlayerTextDrawSetProportional(playerid, SpecTD[playerid][30], 1);
	PlayerTextDrawSetSelectable(playerid, SpecTD[playerid][30], 1);
}

stock FormatMoney(amount)
{
    new str[32];
    format(str, sizeof(str), "%d", amount);
    for (new i = strlen(str) - 3; i > 0; i -= 3)
    {
        strins(str, ",", i);
    }
    return str;
}

stock ShowPlayerSpecTD(playerid, targetid)
{
    if(!IsPlayerConnected(targetid)) return 0;

    new szName[MAX_PLAYER_NAME], szBuffer[128];
    GetPlayerName(targetid, szName, sizeof(szName));
   
    // Player Name & ID
    PlayerTextDrawSetString(playerid, SpecTD[playerid][5], szName);
    format(szBuffer, sizeof(szBuffer), "id: %d", targetid);
    PlayerTextDrawSetString(playerid, SpecTD[playerid][6], szBuffer);

    // Weapon & Ammo 
    new weaponid = GetPlayerWeapon(targetid);
    new ammo = GetPlayerAmmo(targetid);
    new weaponName[32];
    
    format(weaponName, sizeof(weaponName), "%s", GetWeaponNameEx(weaponid));
    
    if(weaponid > _:WEAPON_FIST) format(szBuffer, sizeof(szBuffer), "%s (%d)", weaponName, ammo);
    else format(szBuffer, sizeof(szBuffer), "Fist");
    PlayerTextDrawSetString(playerid, SpecTD[playerid][8], szBuffer);

    // Money
    format(szBuffer, sizeof(szBuffer), "~g~$~w~%s", FormatMoney(GetPlayerMoney(targetid)));
    PlayerTextDrawSetString(playerid, SpecTD[playerid][10], szBuffer);

    // Speed
    new Float:vx, Float:vy, Float:vz;
    GetPlayerVelocity(targetid, vx, vy, vz);
    new Float:speed = floatsqroot(vx*vx + vy*vy + vz*vz) * 100.0;
    format(szBuffer, sizeof(szBuffer), "%.1f mps", speed);
    PlayerTextDrawSetString(playerid, SpecTD[playerid][12], szBuffer);

    // Health & Armor
    new Float:hp, Float:arm;
    GetPlayerHealth(targetid, hp);
    GetPlayerArmour(targetid, arm);

    format(szBuffer, sizeof(szBuffer), "health: ~r~%.0f", hp);
    PlayerTextDrawSetString(playerid, SpecTD[playerid][13], szBuffer);

    format(szBuffer, sizeof(szBuffer), "armor: ~b~%.0f", arm);
    PlayerTextDrawSetString(playerid, SpecTD[playerid][16], szBuffer);

    // Skin Preview
    PlayerTextDrawSetPreviewModel(playerid, SpecTD[playerid][3], GetPlayerSkin(targetid));

    // Vehicle Section
    if(IsPlayerInAnyVehicle(targetid))
    {   
        new vehicleid = GetPlayerVehicleID(targetid);
        
        new model = _:GetVehicleModel(vehicleid);
        
        new Float:specVehHealth;
        GetVehicleHealth(vehicleid, specVehHealth);

        PlayerTextDrawSetString(playerid, SpecTD[playerid][23], "Vehicle"); 
        
        format(szBuffer, sizeof(szBuffer), "model: %d", model);
        PlayerTextDrawSetString(playerid, SpecTD[playerid][24], szBuffer);

        format(szBuffer, sizeof(szBuffer), "%.0f", specVehHealth);
        PlayerTextDrawSetString(playerid, SpecTD[playerid][28], szBuffer);

        PlayerTextDrawSetPreviewModel(playerid, SpecTD[playerid][21], model);

        for(new i = 20; i <= 30; i++)
        {
            PlayerTextDrawShow(playerid, SpecTD[playerid][i]);
        }
    }
    else
    {
        for(new i = 20; i <= 30; i++)
        {
            PlayerTextDrawHide(playerid, SpecTD[playerid][i]);
        }
    }

    for(new i = 0; i <= 19; i++)
    {
        PlayerTextDrawShow(playerid, SpecTD[playerid][i]);
    }

    SelectTextDraw(playerid, 0xA3B4C5FF);
    return 1;
}

stock HidePlayerSpecTD(playerid)
{
    for(new i = 0; i < 31; i++)
    {
        PlayerTextDrawHide(playerid, SpecTD[playerid][i]);
    }
    CancelSelectTextDraw(playerid);
    return 1;
}

hook OnPlayerConnect(playerid)
{
    CreateSpecTextDraws(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    for(new i = 0; i < 31; i++)
    {
        if(SpecTD[playerid][i] != PlayerText:INVALID_TEXT_DRAW)
        {
            PlayerTextDrawDestroy(playerid, SpecTD[playerid][i]);
            SpecTD[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
        }
    }
    return 1;
}

CMD:spec(playerid, const params[])
{
    new targetid;

    if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 7)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(!strcmp(params, "off", true) && GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
	    SendMessage(playerid, COLOR_ORANGE, "You are no longer spectating %s (ID %i).", GetRPName(PlayerInfo[playerid][pSpectating]), PlayerInfo[playerid][pSpectating]);
	    SendAdminMessage(COLOR_RED, "%s stops spectating %s (ID:%i).", GetRPName(playerid), GetRPName(PlayerInfo[playerid][pSpectating]), PlayerInfo[playerid][pSpectating]);
	    
	    HidePlayerSpecTD(playerid);
	    
	    PlayerInfo[playerid][pSpectating] = INVALID_PLAYER_ID;
	    TogglePlayerSpectating(playerid, 0);
	    SetPlayerToSpawn(playerid);
	    return 1;
 	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /spec [playerid/off]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't spectate yourself.");
	}
	if(!IsPlayerSpawned(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is either not spawned, or spectating.");
	}
	if(PowerSpec[targetid] == 1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot spectate Alfredo or Elizabeth as they'll be doing their RP.");
	}
	if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified has a higher admin level than you. They cannot be spectate.");
	}

	SavePlayerVariables(playerid);
	TogglePlayerSpectating(playerid, 1);

	SetPlayerInterior(playerid, GetPlayerInterior(targetid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));

	if(IsPlayerInAnyVehicle(targetid))
	{
	    PlayerSpectateVehicle(playerid, GetPlayerVehicleID(targetid));
	}
	else
	{
	    PlayerSpectatePlayer(playerid, targetid);
	}

	PlayerInfo[playerid][pSpectating] = targetid;

	ShowPlayerSpecTD(playerid, targetid);

	SendMessage(playerid, COLOR_ORANGE, "You are now spectating %s (ID %i).", GetRPName(PlayerInfo[playerid][pSpectating]), PlayerInfo[playerid][pSpectating]);
	SendAdminMessage(COLOR_RED, "%s is now spectating to %s (ID:%i).", GetRPName(playerid), GetRPName(PlayerInfo[playerid][pSpectating]), PlayerInfo[playerid][pSpectating]);
	return 1;
}