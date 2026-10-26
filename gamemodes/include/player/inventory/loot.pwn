#include <YSI_Coding\y_hooks>

new lootPlayerID[MAX_PLAYERS],
    lootPlayerTimer[MAX_PLAYERS],
    lootPlayerTimerStatus[MAX_PLAYERS] = 0;

ptask OnPlayerAttemptToLoot[1000](i) 
{
    new string[128], Float:status, userid = lootPlayerID[i];
    if(PlayerInfo[i][pLogged] && !PlayerInfo[i][pKicked])
    {
        if(lootPlayerTimer[i] == 1) 
        {
            status = Random(5);  
            lootPlayerTimerStatus[i] += status;

            format(string, sizeof(string), "~w~Checking Items~n~~r~%.2f ~w~Complete", lootPlayerTimerStatus[i]);
            GameTextForPlayer(i, string, 1000, 4);

			ApplyAnimationEx(i, "BOMBER", "BOM_Plant_In", 4.0999, false, true, true, true, 0, SYNC_ALL);
			SendProximityMessage(i, 20.0, COLOR_PURPLE, "*{C2A2DA} %s checking for items on %s (%d percent).", GetRPName(i), GetRPName(userid), lootPlayerTimerStatus[i]);
 
            if(lootPlayerTimerStatus[i] > 99)
            {
                format(string, sizeof(string), "~w~Start To Loot~n~~g~100.0 ~w~Complete");
                GameTextForPlayer(i, string, 1000, 4);
                ClearAnimations(i);

                Inventory_Loot(i, userid);

				lootPlayerTimer[i] = 0;
                lootPlayerTimerStatus[i] = 0;

				SendProximityMessage(i, 20.0, COLOR_PURPLE, "*{C2A2DA} %s searches for items on %s.", GetRPName(i), GetRPName(userid));
            }
        }
    }
}

stock Inventory_Loot(playerid, userid = INVALID_PLAYER_ID)
{
    if (!IsPlayerConnected(playerid) && PlayerInfo[playerid][pInjured] && !PlayerInfo[playerid][pID])
        return 0;

    new header[128],name[128], str[(1024 * 2)];
    PlayerInfo[userid][pStorageSelect] = 0;

    new count = 0;
    for (new i = 0, j; i < MAX_INVENTORY && i < PlayerInfo[userid][pCapacity]; i ++)
    {
        if (InventoryData[userid][i][invExists])
        {
            strunpack(name, InventoryData[userid][i][invItem]);

            g_ListedItems[userid][j] = i;
            format(header, sizeof(header), "%s's ~y~Inventory ~w~(%d/%d)", GetRPName(userid), j+1, PlayerInfo[userid][pCapacity]);
            format(str, sizeof str, "%s%i\t%s~n~~y~(%i)\n", str, InventoryData[userid][i][invModel], InventoryData[userid][i][invItem], InventoryData[userid][i][invQuantity]);
            j++;
            count++;
        }
    }

    if(count == 0) return SendClientMessage(playerid, -1, "There's nothing in player inventory");
    return ShowPlayerDialog(playerid, DIALOG_INVENTORY_LOOT, DIALOG_STYLE_PREVIEW_MODEL, header, str, "Select", "Cancel");
}

hook OnPlayerDisconect(playerid, reason)
{
    if(lootPlayerTimer[playerid])
    {
        new userid = lootPlayerID[playerid];
        lootPlayerID[playerid] = 0;
        lootPlayerTimer[userid] = 0;
        lootPlayerTimerStatus[userid] = 0;
        SendProximityMessage(playerid, 20.0, COLOR_YELLOW, "The person who looting has disconnected");
    }
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == DIALOG_INVENTORY_LOOT && InventoryData[playerid][g_ListedItems[playerid][listitem]][invExists])
    {
        if(response)
        {
            new itemid = g_ListedItems[playerid][listitem], name[48];

            strunpack(name, InventoryData[playerid][itemid][invItem]);
            PlayerInfo[playerid][pInventoryItem] = itemid;

			format(name, sizeof(name), "%s ("YGREEN"%d"WHITE" Quantity)", name, InventoryData[playerid][itemid][invQuantity]);
            Dialog_Show(playerid, Inventory_Loot_Quantity, DIALOG_STYLE_INPUT, name, "Please specify how much of this item you wish to loot:", "Yes", "Back");
		}
    }
    return 1;
}

Dialog:Inventory_Loot_Quantity(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if (response && lootPlayerID[playerid] != INVALID_PLAYER_ID)
        {
            new
                userid = lootPlayerID[playerid],
                itemid = PlayerInfo[playerid][pInventoryItem],
                name[128],
                string[128];

            strunpack(string, InventoryData[playerid][itemid][invItem]);
            format(name, sizeof(name), "%s ("YGREEN"%d"WHITE" Quantity)", name, InventoryData[playerid][itemid][invQuantity]);

            if (isnull(inputtext))
                return Dialog_Show(playerid, Inventory_Loot_Quantity, DIALOG_STYLE_INPUT, name, "Please specify how much of this item you wish to loot:", "Yes", "Back");

            if (strval(inputtext) < 1 || strval(inputtext) > InventoryData[userid][itemid][invQuantity])
                return Dialog_Show(playerid, Inventory_Loot_Quantity, DIALOG_STYLE_INPUT, name, "Error: That player don't have much.\n\nPlease specify how much of this item you wish to loot:", "Yes", "Back");

            Inventory_Remove(userid, string, strval(inputtext));

            new id = Inventory_Add(playerid, string, InventoryData[playerid][itemid][invModel], strval(inputtext));
            if (id == -1) return SendClientMessage(playerid, COLOR_SYNTAX, "Your inventory has full.");

            Inventory_Loot(playerid, userid);
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "*{C2A2DA} %s loots %s from %s's inventory.", GetRPName(playerid), InventoryData[userid][itemid][invItem], GetRPName(userid));
        
        }
    }
    return 1;
}

CMD:loot(playerid, const params[])
{
    new userid;   
	if(sscanf(params, "u", userid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /stretcher [playerid]");
	}
	if(!IsPlayerConnected(userid) || !IsPlayerInRangeOfPlayer(playerid, userid, 15.0))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
	}
	if(userid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on yourself.");
	}
	if(!PlayerInfo[userid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not injured.");
	}

	lootPlayerTimer[playerid] = 1;
    lootPlayerID[playerid] = userid;
    SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "*{C2A2DA} %s checking for items on %s.", GetRPName(playerid), GetRPName(userid));
    return 1;
}