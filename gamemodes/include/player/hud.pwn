#include <YSI_Coding\y_hooks>

new PlayerText:SpeedoTextdraw[MAX_PLAYERS][27];
new Text:GlobalTimeTextdraw[2];

ptask SpeedoUpdate[200](playerid)
{
	if(PlayerInfo[playerid][pLogged] && !PlayerInfo[playerid][pKicked])
    {
		new string[128], vehicleid = GetPlayerVehicleID(playerid), Float:speed, Float:miles;

		static datestring[16], hourstring[16], date[6], suffix[3];
		getdate(date[2], date[1], date[0]);
		gettime(date[3], date[4], date[5]);

		if(date[3] > 12 && date[3] < 24) {
			suffix = "PM";
		} else if(date[3] == 12) {
			suffix = "AM";
		} else if(date[3] > 0 && date[3] < 12) {
			suffix = "AM";
		} else if(date[3] == 0) {
			suffix = "AM";
		}

		switch(date[1])
		{
			case 1: datestring = "January";
			case 2: datestring = "February";
			case 3: datestring = "March";
			case 4: datestring = "April";
			case 5: datestring = "May";
			case 6: datestring = "June";
			case 7: datestring = "July";
			case 8: datestring = "August";
			case 9: datestring = "September";
			case 10: datestring = "October";
			case 11: datestring = "November";
			case 12: datestring = "December";
		}
		switch(date[3])
		{
			case 0: hourstring = "12";
			case 1: hourstring = "01";
			case 2: hourstring = "02";
			case 3: hourstring = "03";
			case 4: hourstring = "04";
			case 5: hourstring = "05";
			case 6: hourstring = "06";
			case 7: hourstring = "07";
			case 8: hourstring = "08";
			case 9: hourstring = "09";
			case 10: hourstring = "10";
			case 11: hourstring = "11";
			case 12: hourstring = "12";
			case 13: hourstring = "01";
			case 14: hourstring = "02";
			case 15: hourstring = "03";
			case 16: hourstring = "04";
			case 17: hourstring = "05";
			case 18: hourstring = "06";
			case 19: hourstring = "07";
			case 20: hourstring = "08";
			case 21: hourstring = "09";
			case 22: hourstring = "10";
			case 23: hourstring = "11";
		}

		if(PlayerInfo[playerid][pWatchOn])
		{
			format(string, sizeof(string), "%s:%02d:%02d %s", hourstring, date[4], date[5], suffix);
			TextDrawSetString(GlobalTimeTextdraw[0], string);
			TextDrawShowForPlayer(playerid, GlobalTimeTextdraw[0]);
		}

		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{

			speed = GetVehicleSpeedMPH(vehicleid);
			miles = (speed/ 15.0) / 1000;
			
			VehicleInfo[vehicleid][vMileage] += miles;

			// Speed Text (PTD 26)
			format(string, sizeof(string), "%.0f", speed);
			PlayerTextDrawSetString(playerid, SpeedoTextdraw[playerid][26], string);

			// Fuel Text (PTD 18) & Progress Bar (PTD 17)
			format(string, sizeof(string), "FUEL %d", vehicleFuel[vehicleid]);
			PlayerTextDrawSetString(playerid, SpeedoTextdraw[playerid][18], string);

			new Float:fuel_percentage = floatmul(float(vehicleFuel[vehicleid]), 0.57);
			PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][17], fuel_percentage, 3.000);
			PlayerTextDrawHide(playerid, SpeedoTextdraw[playerid][17]);
			PlayerTextDrawShow(playerid, SpeedoTextdraw[playerid][17]);

			// Mileage Text (PTD 2)
			format(string, sizeof(string), "%.3f", VehicleInfo[vehicleid][vMileage]);
			PlayerTextDrawSetString(playerid, SpeedoTextdraw[playerid][2], string);

			// LOCK Indicator (PTD 19)
			if(GetVehicleParams(vehicleid, VEHICLE_DOORS))
			{
				PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][19], 0xE4A3A3FF);
			} else {
				PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][19], -1);
			}
			PlayerTextDrawShow(playerid, SpeedoTextdraw[playerid][19]);

			// ENGINE Indicator (PTD 20)
			if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
			{
				PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][20], -1);
			} else {
				PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][20], 0xE4A3A3FF);
			}
			PlayerTextDrawShow(playerid, SpeedoTextdraw[playerid][20]);

			// LIGHT Indicator (PTD 21)
			if(GetVehicleParams(vehicleid, VEHICLE_LIGHTS))
			{
				PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][21], -1);
			} else {
				PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][21], 0xE4A3A3FF);
			}
			PlayerTextDrawShow(playerid, SpeedoTextdraw[playerid][21]);

			// Save mileage into vehicle tables
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET mileage = '%f' WHERE id = %i", VehicleInfo[vehicleid][vMileage], VehicleInfo[vehicleid][vID]);
			mysql_tquery(connectionID, queryBuffer);
		}
	}
}

CreatePlayerSpeedo(playerid, bool:show)
{
	if(show)
	{
		SpeedoTextdraw[playerid][0] = CreatePlayerTextDraw(playerid, 520.166, 369.665, "particle:lamp_shad_64");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][0], 76.000, 33.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][0], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][0], 673720351);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][0], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][0], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][0], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][0], TEXT_DRAW_FONT_SPRITE_DRAW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][0], false);

		SpeedoTextdraw[playerid][1] = CreatePlayerTextDraw(playerid, 578.806, 349.250, "_");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][1], 69.000, 51.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][1], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][1], 512819199);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][1], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][1], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][1], 0);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][1], TEXT_DRAW_FONT_MODEL_PREVIEW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][1], false);
		PlayerTextDrawSetPreviewModel(playerid, SpeedoTextdraw[playerid][1], 2153);
		PlayerTextDrawSetPreviewRot(playerid, SpeedoTextdraw[playerid][1], 0.000, -15.000, 90.000, 1.000);
		PlayerTextDrawSetPreviewVehicleColours(playerid, SpeedoTextdraw[playerid][1], 0, 0);

		SpeedoTextdraw[playerid][2] = CreatePlayerTextDraw(playerid, 546.973, 387.915, "0.000");
		PlayerTextDrawLetterSize(playerid, SpeedoTextdraw[playerid][2], 0.115, 1.080);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][2], TEXT_DRAW_ALIGN_CENTRE);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][2], -1);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][2], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][2], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][2], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][2], TEXT_DRAW_FONT_2);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][2], true);

		SpeedoTextdraw[playerid][3] = CreatePlayerTextDraw(playerid, 560.065, 345.748, "_");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][3], 67.000, 55.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][3], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][3], 512819199);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][3], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][3], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][3], 0);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][3], TEXT_DRAW_FONT_MODEL_PREVIEW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][3], false);
		PlayerTextDrawSetPreviewModel(playerid, SpeedoTextdraw[playerid][3], 2153);
		PlayerTextDrawSetPreviewRot(playerid, SpeedoTextdraw[playerid][3], 0.000, -15.000, 90.000, 1.000);
		PlayerTextDrawSetPreviewVehicleColours(playerid, SpeedoTextdraw[playerid][3], 0, 0);

		SpeedoTextdraw[playerid][4] = CreatePlayerTextDraw(playerid, 600.361, 346.333, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][4], 24.000, 11.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][4], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][4], 512819199);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][4], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][4], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][4], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][4], TEXT_DRAW_FONT_SPRITE_DRAW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][4], false);

		SpeedoTextdraw[playerid][5] = CreatePlayerTextDraw(playerid, 590.622, 342.833, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][5], 20.000, 20.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][5], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][5], 512819199);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][5], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][5], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][5], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][5], TEXT_DRAW_FONT_SPRITE_DRAW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][5], false);

		SpeedoTextdraw[playerid][6] = CreatePlayerTextDraw(playerid, 597.551, 353.333, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][6], 17.000, 44.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][6], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][6], 512819199);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][6], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][6], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][6], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][6], TEXT_DRAW_FONT_SPRITE_DRAW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][6], false);

		SpeedoTextdraw[playerid][7] = CreatePlayerTextDraw(playerid, 614.517, 342.833, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][7], 20.000, 20.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][7], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][7], 512819199);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][7], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][7], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][7], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][7], TEXT_DRAW_FONT_SPRITE_DRAW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][7], false);

		SpeedoTextdraw[playerid][8] = CreatePlayerTextDraw(playerid, 625.114, 413.083, "particle:lamp_shad_64");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][8], -131.000, -67.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][8], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][8], 673720436);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][8], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][8], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][8], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][8], TEXT_DRAW_FONT_SPRITE_DRAW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][8], false);

		SpeedoTextdraw[playerid][9] = CreatePlayerTextDraw(playerid, 570.007, 366.165, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][9], 15.000, 15.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][9], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][9], 336860415);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][9], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][9], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][9], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][9], TEXT_DRAW_FONT_SPRITE_DRAW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][9], false);

		SpeedoTextdraw[playerid][10] = CreatePlayerTextDraw(playerid, 575.057, 374.333, "_");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][10], 10.000, 9.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][10], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][10], 336860415);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][10], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][10], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][10], 336860160);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][10], TEXT_DRAW_FONT_MODEL_PREVIEW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][10], false);
		PlayerTextDrawSetPreviewModel(playerid, SpeedoTextdraw[playerid][10], 2153);
		PlayerTextDrawSetPreviewRot(playerid, SpeedoTextdraw[playerid][10], 0.000, -15.000, 90.000, 1.000);
		PlayerTextDrawSetPreviewVehicleColours(playerid, SpeedoTextdraw[playerid][10], 0, 0);

		SpeedoTextdraw[playerid][11] = CreatePlayerTextDraw(playerid, 568.132, 373.165, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][11], 15.000, 15.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][11], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][11], 336860415);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][11], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][11], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][11], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][11], TEXT_DRAW_FONT_SPRITE_DRAW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][11], false);

		SpeedoTextdraw[playerid][12] = CreatePlayerTextDraw(playerid, 517.432, 368.500, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][12], 59.000, 17.500);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][12], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][12], 336860415);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][12], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][12], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][12], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][12], TEXT_DRAW_FONT_SPRITE_DRAW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][12], false);

		SpeedoTextdraw[playerid][13] = CreatePlayerTextDraw(playerid, 511.441, 366.165, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][13], 15.000, 15.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][13], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][13], 336860415);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][13], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][13], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][13], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][13], TEXT_DRAW_FONT_SPRITE_DRAW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][13], false);

		SpeedoTextdraw[playerid][14] = CreatePlayerTextDraw(playerid, 519.304, 380.165, "_");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][14], -10.000, -9.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][14], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][14], 336860415);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][14], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][14], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][14], 336860160);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][14], TEXT_DRAW_FONT_MODEL_PREVIEW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][14], false);
		PlayerTextDrawSetPreviewModel(playerid, SpeedoTextdraw[playerid][14], 2153);
		PlayerTextDrawSetPreviewRot(playerid, SpeedoTextdraw[playerid][14], 0.000, -15.000, 90.000, 1.000);
		PlayerTextDrawSetPreviewVehicleColours(playerid, SpeedoTextdraw[playerid][14], 0, 0);

		SpeedoTextdraw[playerid][15] = CreatePlayerTextDraw(playerid, 509.098, 373.165, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][15], 15.000, 15.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][15], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][15], 336860415);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][15], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][15], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][15], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][15], TEXT_DRAW_FONT_SPRITE_DRAW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][15], false);

		SpeedoTextdraw[playerid][16] = CreatePlayerTextDraw(playerid, 518.000, 379.000, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][16], 57.000, 3.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][16], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][16], 341674463);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][16], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][16], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][16], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][16], TEXT_DRAW_FONT_SPRITE_DRAW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][16], false);

		SpeedoTextdraw[playerid][17] = CreatePlayerTextDraw(playerid, 518.000, 379.000, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][17], 57.000, 3.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][17], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][17], 512819199);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][17], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][17], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][17], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][17], TEXT_DRAW_FONT_SPRITE_DRAW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][17], false);

		SpeedoTextdraw[playerid][18] = CreatePlayerTextDraw(playerid, 535.973, 367.915, "FUEL 100");
		PlayerTextDrawLetterSize(playerid, SpeedoTextdraw[playerid][18], 0.115, 1.080);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][18], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][18], -1);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][18], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][18], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][18], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][18], TEXT_DRAW_FONT_2);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][18], true);

		SpeedoTextdraw[playerid][19] = CreatePlayerTextDraw(playerid, 516.000, 351.000, "LOCK");
		PlayerTextDrawLetterSize(playerid, SpeedoTextdraw[playerid][19], 0.180, 1.190);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][19], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][19], -459199745);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][19], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][19], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][19], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][19], TEXT_DRAW_FONT_1);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][19], true);

		SpeedoTextdraw[playerid][20] = CreatePlayerTextDraw(playerid, 538.000, 351.000, "ENGINE");
		PlayerTextDrawLetterSize(playerid, SpeedoTextdraw[playerid][20], 0.180, 1.190);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][20], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][20], -1);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][20], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][20], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][20], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][20], TEXT_DRAW_FONT_1);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][20], true);

		SpeedoTextdraw[playerid][21] = CreatePlayerTextDraw(playerid, 566.000, 351.000, "LIGHT");
		PlayerTextDrawLetterSize(playerid, SpeedoTextdraw[playerid][21], 0.180, 1.190);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][21], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][21], -1);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][21], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][21], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][21], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][21], TEXT_DRAW_FONT_1);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][21], true);

		SpeedoTextdraw[playerid][22] = CreatePlayerTextDraw(playerid, 576.000, 386.500, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][22], 20.000, 20.500);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][22], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][22], 336860415);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][22], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][22], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][22], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][22], TEXT_DRAW_FONT_SPRITE_DRAW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][22], false);

		SpeedoTextdraw[playerid][23] = CreatePlayerTextDraw(playerid, 589.000, 391.000, "KM/H");
		PlayerTextDrawLetterSize(playerid, SpeedoTextdraw[playerid][23], 0.128, 1.156);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][23], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][23], -1);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][23], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][23], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][23], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][23], TEXT_DRAW_FONT_2);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][23], true);

		SpeedoTextdraw[playerid][24] = CreatePlayerTextDraw(playerid, 598.585, 386.583, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][24], 20.000, 20.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][24], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][24], 336860415);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][24], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][24], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][24], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][24], TEXT_DRAW_FONT_SPRITE_DRAW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][24], false);

		SpeedoTextdraw[playerid][25] = CreatePlayerTextDraw(playerid, 586.468, 390.083, "ld_spac:white");
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][25], 23.000, 13.500);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][25], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][25], 336860415);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][25], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][25], 0);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][25], 255);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][25], TEXT_DRAW_FONT_SPRITE_DRAW);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][25], false);

		SpeedoTextdraw[playerid][26] = CreatePlayerTextDraw(playerid, 597.000, 364.000, "0");
		PlayerTextDrawLetterSize(playerid, SpeedoTextdraw[playerid][26], 0.273, 1.500);
		PlayerTextDrawTextSize(playerid, SpeedoTextdraw[playerid][26], -22.000, 0.000);
		PlayerTextDrawAlignment(playerid, SpeedoTextdraw[playerid][26], TEXT_DRAW_ALIGN_LEFT);
		PlayerTextDrawColour(playerid, SpeedoTextdraw[playerid][26], -1);
		PlayerTextDrawSetShadow(playerid, SpeedoTextdraw[playerid][26], 0);
		PlayerTextDrawSetOutline(playerid, SpeedoTextdraw[playerid][26], 1);
		PlayerTextDrawBackgroundColour(playerid, SpeedoTextdraw[playerid][26], 134);
		PlayerTextDrawFont(playerid, SpeedoTextdraw[playerid][26], TEXT_DRAW_FONT_3);
		PlayerTextDrawSetProportional(playerid, SpeedoTextdraw[playerid][26], true);

		for (new i = 0, size = sizeof SpeedoTextdraw[]; i < size; i ++)
		{
			PlayerTextDrawShow(playerid, SpeedoTextdraw[playerid][i]);
		}
	}
	else
	{
		for (new i = 0, size = sizeof SpeedoTextdraw[]; i < size; i ++)
		{
			PlayerTextDrawDestroy(playerid, SpeedoTextdraw[playerid][i]);
		}
	}
}

hook OnGameModeInit(playerid)
{
	GlobalTimeTextdraw[0] = TextDrawCreate(554.000000, 23.000000, "12:00:00 AM");
	TextDrawFont(GlobalTimeTextdraw[0], TEXT_DRAW_FONT:2);
	TextDrawLetterSize(GlobalTimeTextdraw[0], 0.179166, 1.350000);
	TextDrawTextSize(GlobalTimeTextdraw[0], 681.500000, 102.000000);
	TextDrawSetOutline(GlobalTimeTextdraw[0], 1);
	TextDrawSetShadow(GlobalTimeTextdraw[0], 0);
	TextDrawAlignment(GlobalTimeTextdraw[0], TEXT_DRAW_ALIGN:1);
	TextDrawColour(GlobalTimeTextdraw[0], -1);
	TextDrawBackgroundColour(GlobalTimeTextdraw[0], 255);
	TextDrawBoxColour(GlobalTimeTextdraw[0], 50);
	TextDrawUseBox(GlobalTimeTextdraw[0], 0);
	TextDrawSetProportional(GlobalTimeTextdraw[0], 1);
	TextDrawSetSelectable(GlobalTimeTextdraw[0], 0);
	return 1;
}

hook OnPlayerStateChange(playerid, PLAYER_STATE:newstate, PLAYER_STATE:oldstate) 
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
		CreatePlayerSpeedo(playerid, true);
	}
	if(oldstate == PLAYER_STATE_DRIVER)
	{
		CreatePlayerSpeedo(playerid, false);
	}
	return 1;
}