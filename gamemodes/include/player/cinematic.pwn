

#include <YSI_Coding\y_hooks>
new PlayerText:CinematicTD[MAX_PLAYERS][14];
new PlayerText:CinematicTD2[MAX_PLAYERS][2];

new loadingstage[MAX_PLAYERS] = 0;
new loadinganim[MAX_PLAYERS] = 0;
new loadingstagefinish[MAX_PLAYERS];

forward Crashing(playerid);
public Crashing(playerid)
{
	ApplyAnimationEx(playerid, "MISC", "Seat_talk_01", 4.0, 1, 0, 0, 1, 1);
    SetPlayerDrunkLevel(playerid, 30000);
    SetTimerEx("StopCinematic", 10000, false, "i", playerid);
    return 1;
}

forward StopCinematic(playerid);
public StopCinematic(playerid)
{
    ShowCinematic(playerid, false);
    ShowBlackscreen(playerid, true);
	SetPVarInt(playerid, "Loading", 1);
	SetPlayerDrunkLevel(playerid, 0);
	loadingstagefinish[playerid] = Random(25, 50);
    return 1;
}

ptask LoadingScreen[500](playerid)
{
	if(GetPVarInt(playerid, "Loading"))
	{
		loadinganim[playerid]++;
		switch(loadinganim[playerid])
		{
			case 1:
			{
				PlayerTextDrawShow(playerid, CinematicTD[playerid][1]);
			}
			case 2:
			{
				PlayerTextDrawShow(playerid, CinematicTD[playerid][2]);
			}
			case 3:
			{
				PlayerTextDrawShow(playerid, CinematicTD[playerid][3]);
			}
			case 4:
			{
				PlayerTextDrawShow(playerid, CinematicTD[playerid][4]);
			}
			case 5:
			{
				PlayerTextDrawShow(playerid, CinematicTD[playerid][5]);
			}
			case 6:
			{
				PlayerTextDrawShow(playerid, CinematicTD[playerid][6]);
			}
			case 7:
			{
				PlayerTextDrawShow(playerid, CinematicTD[playerid][8]);
			}
			case 8:
			{
				PlayerTextDrawShow(playerid, CinematicTD[playerid][7]);
			}
			case 9:
			{
				loadinganim[playerid] = 0;
				PlayerTextDrawHide(playerid, CinematicTD[playerid][1]);
				PlayerTextDrawHide(playerid, CinematicTD[playerid][2]);
				PlayerTextDrawHide(playerid, CinematicTD[playerid][3]);
				PlayerTextDrawHide(playerid, CinematicTD[playerid][4]);
				PlayerTextDrawHide(playerid, CinematicTD[playerid][5]);
				PlayerTextDrawHide(playerid, CinematicTD[playerid][6]);
				PlayerTextDrawHide(playerid, CinematicTD[playerid][7]);
				PlayerTextDrawHide(playerid, CinematicTD[playerid][8]);
			}
		}
		loadingstage[playerid] = loadingstage[playerid] + 1;
		if(loadingstage[playerid] >= loadingstagefinish[playerid])
		{
			loadingstage[playerid] = 0;
			DeletePVar(playerid, "Loading");
			ShowBlackscreen(playerid, false);
			StandingUp(playerid);
		}
	}
}

forward StandingUp(playerid);
public StandingUp(playerid)
{
	SetPlayerPos(playerid, 837.7527, -21.8436, 63.1868);
	SetPlayerFacingAngle(playerid, 239.7919);
	SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);

	ApplyAnimationEx(playerid, "WUZI", "CS_Dead_Guy", 4.0, 0, 0, 0, 1, 1);

	SetPlayerCameraPos(playerid,836.892883,-22.403640,64.486724);
	SetPlayerCameraLookAt(playerid,837.732238,-21.843627,62.576786);
	InterpolateCameraLookAt(playerid,837.732238,-21.843627,62.576786,843.203063,-27.313632,63.126773,10000,CAMERA_MOVE);
	SetTimerEx("StoodUp", 6000, false, "i", playerid);
	return 1;
}

forward StoodUp(playerid);
public StoodUp(playerid)
{	
	ApplyAnimationEx(playerid, "PED", "SEAT_up", 4.0, false, false, true, true, 0);
	SetCameraBehindPlayer(playerid);
	PlayerRegistered(playerid);
	return 1;
}

PlayerRegistered(playerid) {
	
    ClearChat(playerid);
    InsideTut[playerid] = 0;
    PlayerInfo[playerid][pTutorial] = 0;
    PlayerInfo[playerid][pSetup] = 0;

    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
    SetCameraBehindPlayer(playerid);
    StopAudioStreamForPlayer(playerid);
    TogglePlayerControllable(playerid, 1);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET setup = 0, gender = %i, age = %i, skin = %i WHERE uid = %i", PlayerInfo[playerid][pGender], PlayerInfo[playerid][pAge], PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
	return 1;
}

LoadCinematic(playerid)
{
    CinematicTD2[playerid][0] = CreatePlayerTextDraw(playerid, 0.000000, -1.000000, "ld_dual:black");
	PlayerTextDrawFont(playerid, CinematicTD2[playerid][0], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, CinematicTD2[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CinematicTD2[playerid][0], 640.500000, 141.000000);
	PlayerTextDrawSetOutline(playerid, CinematicTD2[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, CinematicTD2[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, CinematicTD2[playerid][0], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColor(playerid, CinematicTD2[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, CinematicTD2[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, CinematicTD2[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, CinematicTD2[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, CinematicTD2[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, CinematicTD2[playerid][0], 0);

	CinematicTD2[playerid][1] = CreatePlayerTextDraw(playerid, 0.000000, 307.000000, "ld_dual:black");
	PlayerTextDrawFont(playerid, CinematicTD2[playerid][1], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, CinematicTD2[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CinematicTD2[playerid][1], 640.500000, 141.000000);
	PlayerTextDrawSetOutline(playerid, CinematicTD2[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, CinematicTD2[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, CinematicTD2[playerid][1], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColor(playerid, CinematicTD2[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, CinematicTD2[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, CinematicTD2[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, CinematicTD2[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, CinematicTD2[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, CinematicTD2[playerid][1], 0);
    return 1;
}

LoadBlackscreen(playerid)
{
    CinematicTD[playerid][0] = CreatePlayerTextDraw(playerid, -1.000000, 0.000000, "ld_dual:black");
	PlayerTextDrawFont(playerid, CinematicTD[playerid][0], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, CinematicTD[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CinematicTD[playerid][0], 640.000000, 448.000000);
	PlayerTextDrawSetOutline(playerid, CinematicTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, CinematicTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, CinematicTD[playerid][0], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColor(playerid, CinematicTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, CinematicTD[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, CinematicTD[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, CinematicTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, CinematicTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, CinematicTD[playerid][0], 0);

	CinematicTD[playerid][1] = CreatePlayerTextDraw(playerid, 469.000000, 392.000000, "ld_beat:cring");
	PlayerTextDrawFont(playerid, CinematicTD[playerid][1], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, CinematicTD[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CinematicTD[playerid][1], 10.500000, 11.000000);
	PlayerTextDrawSetOutline(playerid, CinematicTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, CinematicTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, CinematicTD[playerid][1], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColor(playerid, CinematicTD[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, CinematicTD[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, CinematicTD[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, CinematicTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, CinematicTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, CinematicTD[playerid][1], 0);

	CinematicTD[playerid][2] = CreatePlayerTextDraw(playerid, 469.000000, 400.000000, "ld_beat:cring");
	PlayerTextDrawFont(playerid, CinematicTD[playerid][2], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, CinematicTD[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CinematicTD[playerid][2], 10.500000, 11.000000);
	PlayerTextDrawSetOutline(playerid, CinematicTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, CinematicTD[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, CinematicTD[playerid][2], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColor(playerid, CinematicTD[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, CinematicTD[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, CinematicTD[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, CinematicTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, CinematicTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, CinematicTD[playerid][2], 0);

	CinematicTD[playerid][3] = CreatePlayerTextDraw(playerid, 469.000000, 408.000000, "ld_beat:cring");
	PlayerTextDrawFont(playerid, CinematicTD[playerid][3], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, CinematicTD[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CinematicTD[playerid][3], 10.500000, 11.000000);
	PlayerTextDrawSetOutline(playerid, CinematicTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, CinematicTD[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, CinematicTD[playerid][3], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColor(playerid, CinematicTD[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, CinematicTD[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, CinematicTD[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, CinematicTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, CinematicTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, CinematicTD[playerid][3], 0);

	CinematicTD[playerid][4] = CreatePlayerTextDraw(playerid, 476.000000, 408.000000, "ld_beat:cring");
	PlayerTextDrawFont(playerid, CinematicTD[playerid][4], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, CinematicTD[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CinematicTD[playerid][4], 10.500000, 11.000000);
	PlayerTextDrawSetOutline(playerid, CinematicTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, CinematicTD[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, CinematicTD[playerid][4], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColor(playerid, CinematicTD[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, CinematicTD[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, CinematicTD[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, CinematicTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, CinematicTD[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, CinematicTD[playerid][4], 0);

	CinematicTD[playerid][5] = CreatePlayerTextDraw(playerid, 483.000000, 408.000000, "ld_beat:cring");
	PlayerTextDrawFont(playerid, CinematicTD[playerid][5], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, CinematicTD[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CinematicTD[playerid][5], 10.500000, 11.000000);
	PlayerTextDrawSetOutline(playerid, CinematicTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, CinematicTD[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, CinematicTD[playerid][5], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColor(playerid, CinematicTD[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, CinematicTD[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, CinematicTD[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, CinematicTD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, CinematicTD[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, CinematicTD[playerid][5], 0);

	CinematicTD[playerid][6] = CreatePlayerTextDraw(playerid, 483.000000, 400.000000, "ld_beat:cring");
	PlayerTextDrawFont(playerid, CinematicTD[playerid][6], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, CinematicTD[playerid][6], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CinematicTD[playerid][6], 10.500000, 11.000000);
	PlayerTextDrawSetOutline(playerid, CinematicTD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, CinematicTD[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, CinematicTD[playerid][6], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColor(playerid, CinematicTD[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, CinematicTD[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, CinematicTD[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, CinematicTD[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, CinematicTD[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, CinematicTD[playerid][6], 0);

	CinematicTD[playerid][7] = CreatePlayerTextDraw(playerid, 476.000000, 392.000000, "ld_beat:cring");
	PlayerTextDrawFont(playerid, CinematicTD[playerid][7], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, CinematicTD[playerid][7], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CinematicTD[playerid][7], 10.500000, 11.000000);
	PlayerTextDrawSetOutline(playerid, CinematicTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, CinematicTD[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, CinematicTD[playerid][7], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColor(playerid, CinematicTD[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, CinematicTD[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, CinematicTD[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, CinematicTD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, CinematicTD[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, CinematicTD[playerid][7], 0);

	CinematicTD[playerid][8] = CreatePlayerTextDraw(playerid, 483.000000, 392.000000, "ld_beat:cring");
	PlayerTextDrawFont(playerid, CinematicTD[playerid][8], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, CinematicTD[playerid][8], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CinematicTD[playerid][8], 10.500000, 11.000000);
	PlayerTextDrawSetOutline(playerid, CinematicTD[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, CinematicTD[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, CinematicTD[playerid][8], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColor(playerid, CinematicTD[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, CinematicTD[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, CinematicTD[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, CinematicTD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, CinematicTD[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, CinematicTD[playerid][8], 0);

	CinematicTD[playerid][9] = CreatePlayerTextDraw(playerid, 467.000000, 390.000000, "HUD:siterocket");
	PlayerTextDrawFont(playerid, CinematicTD[playerid][9], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, CinematicTD[playerid][9], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CinematicTD[playerid][9], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, CinematicTD[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, CinematicTD[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, CinematicTD[playerid][9], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColor(playerid, CinematicTD[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, CinematicTD[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, CinematicTD[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, CinematicTD[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, CinematicTD[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, CinematicTD[playerid][9], 0);

	CinematicTD[playerid][10] = CreatePlayerTextDraw(playerid, 467.000000, 421.000000, "HUD:siterocket");
	PlayerTextDrawFont(playerid, CinematicTD[playerid][10], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, CinematicTD[playerid][10], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CinematicTD[playerid][10], 17.000000, -18.000000);
	PlayerTextDrawSetOutline(playerid, CinematicTD[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, CinematicTD[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, CinematicTD[playerid][10], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColor(playerid, CinematicTD[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, CinematicTD[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, CinematicTD[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, CinematicTD[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, CinematicTD[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, CinematicTD[playerid][10], 0);

	CinematicTD[playerid][11] = CreatePlayerTextDraw(playerid, 496.000000, 421.000000, "HUD:siterocket");
	PlayerTextDrawFont(playerid, CinematicTD[playerid][11], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, CinematicTD[playerid][11], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CinematicTD[playerid][11], -20.000000, -18.000000);
	PlayerTextDrawSetOutline(playerid, CinematicTD[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, CinematicTD[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, CinematicTD[playerid][11], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColor(playerid, CinematicTD[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, CinematicTD[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, CinematicTD[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, CinematicTD[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, CinematicTD[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, CinematicTD[playerid][11], 0);

	CinematicTD[playerid][12] = CreatePlayerTextDraw(playerid, 496.000000, 390.000000, "HUD:siterocket");
	PlayerTextDrawFont(playerid, CinematicTD[playerid][12], TEXT_DRAW_FONT:4);
	PlayerTextDrawLetterSize(playerid, CinematicTD[playerid][12], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CinematicTD[playerid][12], -22.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, CinematicTD[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, CinematicTD[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, CinematicTD[playerid][12], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColor(playerid, CinematicTD[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, CinematicTD[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, CinematicTD[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, CinematicTD[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, CinematicTD[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, CinematicTD[playerid][12], 0);

	CinematicTD[playerid][13] = CreatePlayerTextDraw(playerid, 497.000000, 399.000000, "LOADING...");
	PlayerTextDrawFont(playerid, CinematicTD[playerid][13], TEXT_DRAW_FONT:2);
	PlayerTextDrawLetterSize(playerid, CinematicTD[playerid][13], 0.341666, 1.200000);
	PlayerTextDrawTextSize(playerid, CinematicTD[playerid][13], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, CinematicTD[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, CinematicTD[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, CinematicTD[playerid][13], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColor(playerid, CinematicTD[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, CinematicTD[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, CinematicTD[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, CinematicTD[playerid][13], 0);
	PlayerTextDrawSetProportional(playerid, CinematicTD[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, CinematicTD[playerid][13], 0);
    return 1;
}

ShowCinematic(playerid, bool:show)
{
	if (show)
	{
		LoadCinematic(playerid);
		for (new i = 0, size = sizeof CinematicTD2[]; i < size; i ++)
		{
			PlayerTextDrawShow(playerid, CinematicTD2[playerid][i]);
		}
		ClearChat(playerid);
	}
	else
	{
		for (new i = 0, size = sizeof CinematicTD2[]; i < size; i ++)
		{
			PlayerTextDrawDestroy(playerid, CinematicTD2[playerid][i]);
		}
	}
    return 1;
}

ShowBlackscreen(playerid, bool:show)
{
	if (show)
	{
		LoadBlackscreen(playerid);
		PlayerTextDrawShow(playerid, CinematicTD[playerid][0]);
		PlayerTextDrawShow(playerid, CinematicTD[playerid][1]);
		PlayerTextDrawShow(playerid, CinematicTD[playerid][2]);
		PlayerTextDrawShow(playerid, CinematicTD[playerid][3]);
		PlayerTextDrawShow(playerid, CinematicTD[playerid][4]);
		PlayerTextDrawShow(playerid, CinematicTD[playerid][5]);
		PlayerTextDrawShow(playerid, CinematicTD[playerid][6]);
		PlayerTextDrawShow(playerid, CinematicTD[playerid][7]);
		PlayerTextDrawShow(playerid, CinematicTD[playerid][8]);
		PlayerTextDrawShow(playerid, CinematicTD[playerid][9]);
		PlayerTextDrawShow(playerid, CinematicTD[playerid][10]);
		PlayerTextDrawShow(playerid, CinematicTD[playerid][11]);
		PlayerTextDrawShow(playerid, CinematicTD[playerid][12]);
		PlayerTextDrawShow(playerid, CinematicTD[playerid][13]);
		ClearChat(playerid);
	}
	else
	{
		for (new i = 0, size = sizeof CinematicTD[]; i < size; i ++)
		{
			PlayerTextDrawDestroy(playerid, CinematicTD[playerid][i]);
		}
	}
    return 1;
}