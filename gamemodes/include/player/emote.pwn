#include <YSI_Coding\y_hooks>

CMD:emote(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_EMOTE, DIALOG_STYLE_LIST, "Emote", "Heart\nSkull\nCash\nAlert\nDrugs", "Select", "Back");
    return 1;
}

hook OnPlayerConnect(playerid)
{
    PlayerInfo[playerid][pEmote] = 0;
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_EMOTE:
        {
            if(response)
            {
                switch(listitem)
                {
                    case 0:
                    {
                        SetPlayerAttachedObject(playerid, 4, 1240, 2, 0.468, 0, 0, 0, 89.3, 0, 1, 1, 1);
                    }
                    case 1:
                    {
                        SetPlayerAttachedObject(playerid, 4, 1254, 2, 0.468, 0, 0, 0, 89.3, 0, 1, 1, 1);
                    }
                    case 2:
                    {
                        SetPlayerAttachedObject(playerid, 4, 1212, 2, 0.468, 0, 0, 0, 89.3, 0, 1, 1, 1);
                    }
                    case 3:
                    {
                        SetPlayerAttachedObject(playerid, 4, 1239, 2, 0.468, 0, 0, 0, 89.3, 0, 1, 1, 1);
                    }
                    case 4:
                    {
                        SetPlayerAttachedObject(playerid, 4, 1575, 2, 0.468, 0, 0, 0, 89.3, 0, 1, 1, 1);
                    }
                }
            }
            SetTimerEx("EmoteSystem", 5000, false, "i", playerid);
        }
    }
    return 1;
}

forward EmoteSystem(playerid);
public EmoteSystem(playerid)
{
	if(IsPlayerAttachedObjectSlotUsed(playerid, 4)) RemovePlayerAttachedObject(playerid, 4);
	return 1;
}