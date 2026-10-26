#include <YSI_Coding\y_hooks>

new Text:PlayerStatus;
new gPriority = 1, 
    gPriorityCD = 60;

task PriorityStatus[1000]()
{
    new string[128];
    if(gPriority == 1) 
    {
        if(gPriorityCD <= 0) 
        {
            format(string, sizeof(string), "~w~Illegal Activity: ~r~Open For Heist");
        }
        else 
        {
            format(string, sizeof(string), "~w~Illegal Activity: ~r~%i~w~ %s", gPriorityCD, (gPriorityCD == 1) ? ("Minute") : ("Minutes"));
        }
        TextDrawSetString(PlayerStatus, string);
    }
}

task PriorityCooldown[60000]()
{
    if(gPriority == 1) 
    {
        if(gPriorityCD > 0) 
        {
            gPriorityCD--;
            if(gPriorityCD < 0) 
            {
                gPriorityCD = 0;
            }
        }
    }
}

hook OnGameModeInit()
{
    PlayerStatus = TextDrawCreate(632.000000, 7.000000, "~w~Illegal Activity: Loading...");
    TextDrawFont(PlayerStatus, TEXT_DRAW_FONT:1);
    TextDrawLetterSize(PlayerStatus, 0.204166, 1.199999);
    TextDrawTextSize(PlayerStatus, 122.000000, 94.500000);
    TextDrawSetOutline(PlayerStatus, 1);
    TextDrawSetShadow(PlayerStatus, 0);
    TextDrawAlignment(PlayerStatus, TEXT_DRAW_ALIGN:3);
    TextDrawColour(PlayerStatus, -1);
    TextDrawBackgroundColour(PlayerStatus, 100);
    TextDrawBoxColour(PlayerStatus, -206);
    TextDrawUseBox(PlayerStatus, 0);
    TextDrawSetProportional(PlayerStatus, 1);
    TextDrawSetSelectable(PlayerStatus, 0);
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    TextDrawShowForPlayer(playerid, PlayerStatus);
    return 1;
}

stock UpdatePriorityProgress(priority, type = ROB_RESET)
{
    switch(priority)
    {
        case 1: // End
        {
            gPriority = 1;
            gPriorityCD = 60;
        }
        case 2: // Robbing
        {
            gPriority = 2;

            new string[64];
            if(type == ROB_BANK) string = "~w~Illegal Activity: ~g~Bank Heist In Progress";
            else if(type == ROB_STORE) string = "~w~Illegal Activity: ~g~Store Heist In Progress";
            else if(type == ROB_HOUSE) string = "~w~Illegal Activity: ~g~House Heist In Progress";
            TextDrawSetString(PlayerStatus, string);
        }
        case 3: // Hold
        {
            gPriority = 3;
            TextDrawSetString(PlayerStatus, "~w~Illegal Activity: ~y~Heists Are On Hold");
        }
        case 4: // Reset
        {
            gPriority = 1;
            gPriorityCD = 0;
        }
    }
    return 1;
}

CMD:priority(playerid, const params[])
{
    if(!IsLawEnforcement(playerid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not a part of law enforcement.");
    }
    if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 1)
    {
        return SendMessage(playerid, COLOR_GREY, "You need to be at least rank %i to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 1);
    }

    new string[256];
    string = "Action\tDescription\n";
    format(string, sizeof(string), "%sHold\tTo hold the priority cooldown\n", string);
    format(string, sizeof(string), "%sEnd\tTo end the priority cooldown (60m CD)\n", string);
    format(string, sizeof(string), "%sReset\tTo reset the priority cooldown", string);

    Dialog_Show(playerid, Priority_Setup, DIALOG_STYLE_TABLIST_HEADERS, "Priority Cooldown Menu", string, "Select", "Cancel");
    return 1;
}

Dialog:Priority_Setup(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        switch(listitem)
        {
            case 0: // Hold
            {
                SetPVarInt(playerid, "PrioritySetup", 1);
                Dialog_Show(playerid, Priority_Setup_Message, DIALOG_STYLE_INPUT, "Priority Hold Reason", "Please enter the reason for putting priority on hold:", "Enter", "Cancel");
            }
            case 1: // End
            {
                SetPVarInt(playerid, "PrioritySetup", 2);
                Dialog_Show(playerid, Priority_Setup_Message, DIALOG_STYLE_INPUT, "Priority End Reason", "Please enter the reason for ending the priority call:", "Enter", "Cancel");
            }
            case 2: // Reset
            {
                SetPVarInt(playerid, "PrioritySetup", 3);
                Dialog_Show(playerid, Priority_Setup_Message, DIALOG_STYLE_INPUT, "Priority Reset Reason", "Please enter the reason for resetting the priority cooldown:", "Enter", "Cancel");
            }
        }
    }
    return 1;
}

Dialog:Priority_Setup_Message(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(isnull(inputtext))
        {
            return Dialog_Show(playerid, Priority_Setup_Message, DIALOG_STYLE_INPUT, "Error: Reason Required", "Reason cannot be blank! Please enter a valid statement:", "Enter", "Cancel");
        }

        switch(GetPVarInt(playerid, "PrioritySetup"))
        {
            case 1:
            {
                UpdatePriorityProgress(3);
                SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_ROYALBLUE, "HQ: %s has put priority on hold. Reason: %s", GetRPName(playerid), inputtext);
            }
            case 2:
            {
                UpdatePriorityProgress(1);
                SendMessageToAll(0xff80b9ff, "Warning: A priority call was concluded. All civilians must wait 60 minutes before conducting another priority operation.");
                SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_ROYALBLUE, "HQ: %s has ended the priority. Reason: %s", GetRPName(playerid), inputtext);
            }
            case 3:
            {
                UpdatePriorityProgress(4);
                SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_ROYALBLUE, "HQ: %s has reset the priority. Reason: %s", GetRPName(playerid), inputtext);
            }
        }
        DeletePVar(playerid, "PrioritySetup");
    }
    return 1;
}