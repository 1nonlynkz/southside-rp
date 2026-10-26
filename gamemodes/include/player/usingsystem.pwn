// using system
#include <YSI_Coding\y_hooks>
new PlayerBar:UsingBar[MAX_PLAYERS][1];
new PlayerText:UsingTD[MAX_PLAYERS][2];
new UsingPoints[MAX_PLAYERS] = 0;
new UsingType[MAX_PLAYERS];
new UsingCooldown[MAX_PLAYERS];

ptask UsingTrigger[50](playerid)
{
    if(GetPVarInt(playerid, "CurrentlyUsingBar"))
    {
        switch(UsingType[playerid])
        {
            case USING_TYPE_MINING:
            {
                if(!IsPlayerInMiningArea(playerid) || GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || PlayerInfo[playerid][pTazedTime] || PlayerInfo[playerid][pCuffed])
                {
                    DeletePVar(playerid, "CurrentlyUsingBar");
                    DeletePVar(playerid, "CurrentlyUsingText");
                    UsingType[playerid] = -1;
                    UsingPoints[playerid] = 0;
                    PlayerInfo[playerid][pMiningTime] = 0;
                    RemovePlayerAttachedObject(playerid, 9);
                    ClearAnimations(playerid);
                    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
                    UsingTextDrawHide(playerid);
                    TogglePlayerControllable(playerid, 1);
                    SendClientMessage(playerid, COLOR_RED, "Mining cancelled. Stay inside the mining area and remain on foot.");
                    return 1;
                }
                UsingPoints[playerid]++;
                UsingCooldown[playerid] = 5;
                SetPlayerProgressBarValue(playerid, UsingBar[playerid][0], UsingPoints[playerid]);
                ShowPlayerProgressBar(playerid, UsingBar[playerid][0]);
                if(UsingPoints[playerid] >= 100)
                {

                    PlayerInfo[playerid][pCP] = CHECKPOINT_MINING;
                    PlayerInfo[playerid][pMiningTime]--;
                    if(PlayerInfo[playerid][pMiningTime] <= 0)
                    {
                        if(IsPlayerInMiningArea(playerid) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !PlayerInfo[playerid][pTazedTime] && !PlayerInfo[playerid][pCuffed])
                        {
                            SetPlayerAttachedObject(playerid, 9, 3930, 1, 0.242999, 0.324000, 0.012000, -17.200078, 20.699993, 9.800034, 0.579999, 0.617999, 0.676999);
                            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
                            ApplyAnimation(playerid, "CARRY", "liftup", 4.1, false, false, false, false, 1, SYNC_ALL);
                            PlayerInfo[playerid][pStone] = 1;
                            SendClientMessage(playerid, COLOR_WHITE, "Type /loadstone near the pickup to load the stone.");

                        }
                        else
                        {
                            RemovePlayerAttachedObject(playerid, 9);
                            ClearAnimations(playerid);
                        }
                    }
                
                    DeletePVar(playerid, "CurrentlyUsingBar");
                    DeletePVar(playerid, "CurrentlyUsingText");
                    UsingType[playerid] = -1;
                    UsingPoints[playerid] = 0;
                    UsingTextDrawHide(playerid);
                    PlayerInfo[playerid][pLoopAnim] = 1;
                    TogglePlayerControllable(playerid, 1);
                }
            }
        }
    }
    return 1;
}

stock UsingTextDrawHide(playerid)
{
    PlayerTextDrawHide(playerid, UsingTD[playerid][0]);
    PlayerTextDrawHide(playerid, UsingTD[playerid][1]);
    HidePlayerProgressBar(playerid, UsingBar[playerid][0]);
}

hook OnPlayerConnect(playerid)
{
    UsingTD[playerid][0] = CreatePlayerTextDraw(playerid, 322.000000, 349.000000, "_");
	PlayerTextDrawFont(playerid, UsingTD[playerid][0], TEXT_DRAW_FONT:1);
	PlayerTextDrawLetterSize(playerid, UsingTD[playerid][0], 0.641666, 0.900002);
	PlayerTextDrawTextSize(playerid, UsingTD[playerid][0], 299.000000, 64.000000);
	PlayerTextDrawSetOutline(playerid, UsingTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, UsingTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, UsingTD[playerid][0], TEXT_DRAW_ALIGN:2);
	PlayerTextDrawColour(playerid, UsingTD[playerid][0], -1);
	PlayerTextDrawBackgroundColour(playerid, UsingTD[playerid][0], 255);
	PlayerTextDrawBoxColour(playerid, UsingTD[playerid][0], 135);
	PlayerTextDrawUseBox(playerid, UsingTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, UsingTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, UsingTD[playerid][0], 0);

    UsingTD[playerid][1] = CreatePlayerTextDraw(playerid, 297.000000, 349.000000, "Using Painkillers");
	PlayerTextDrawFont(playerid, UsingTD[playerid][1], TEXT_DRAW_FONT:2);
	PlayerTextDrawLetterSize(playerid, UsingTD[playerid][1], 0.129166, 0.899999);
	PlayerTextDrawTextSize(playerid, UsingTD[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, UsingTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, UsingTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, UsingTD[playerid][1], TEXT_DRAW_ALIGN:1);
	PlayerTextDrawColour(playerid, UsingTD[playerid][1], -1);
	PlayerTextDrawBackgroundColour(playerid, UsingTD[playerid][1], 255);
	PlayerTextDrawBoxColour(playerid, UsingTD[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, UsingTD[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, UsingTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, UsingTD[playerid][1], 0);

	//UsingBar[playerid][0] = CreatePlayerProgressBar(playerid, 269.000000, 403.000000, 100.500000, 9.000000, 1687547391, 100.000000, BAR_DIRECTION_RIGHT);
    UsingBar[playerid][0] = CreatePlayerProgressBar(playerid, 290.000000, 361.000000, 68.000000, 8.000000, 1687547278, 100.000000, BAR_DIRECTION_RIGHT);
	SetPlayerProgressBarValue(playerid, UsingBar[playerid][0], 50.000000);
    HidePlayerProgressBar(playerid, UsingBar[playerid][0]);

    UsingPoints[playerid] = 0;
    return 1;
}

hook OnPlayerDisconnect(playerid)
{
	PlayerTextDrawDestroy(playerid, UsingTD[playerid][0]);
	PlayerTextDrawDestroy(playerid, UsingTD[playerid][1]);
	DestroyPlayerProgressBar(playerid, UsingBar[playerid][0]);
	return 1;
}