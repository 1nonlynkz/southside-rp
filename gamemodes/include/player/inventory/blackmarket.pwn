#include    <YSI_Coding\y_hooks>

#define     MAX_BLACKMARKET_ITEMS          (7)

enum E_BLACKMARKET_INFO
{
    itemName[128],
    itemObject,
    itemPrice
};

new const BlackmarketItems[MAX_BLACKMARKET_ITEMS][E_BLACKMARKET_INFO] = 
{
	{"Medkit", 11738, 250},
	{"Vest", 1242, 300},
	{"9MM", 346, 200},
	{"Silenced 9MM", 347, 250},
	{"Deagle", 348, 1400},
	{"Shotgun", 349, 4000},
	{"MP5", 353, 1000},
	{"Uzi", 352, 1000},
	{"Tec9", 372, 1000},
	{"Rifle", 357, 1000},
	{"Sniper", 358, 1000},
	{"AK47", 355, 1000},
	{"M4", 356, 1000},
	{"SPAS12", 351, 1000}
};
    
new bmActor[3];

GetInsideBlackmarket(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid, 3.0, -720.1449,1462.9044,-90.5046) && GetPlayerInterior(playerid) == 1 && GetPlayerVirtualWorld(playerid) == 0) 
    {
        return 1;
    }
    return 0;
}

hook OnGameModeInit()
{
    CreateDynamic3DTextLabel("O.G", COLOR_WHITE, -720.1449,1462.9044,-90.5046 + 1.3, 5.0);
    bmActor[0] = CreateActor(21, -720.1449,1462.9044,-90.5046,178.5437);

    CreateDynamic3DTextLabel("STAFF", COLOR_WHITE, -717.7847,1456.5078,-90.5046 + 1.3, 5.0);
    bmActor[1] = CreateActor(29, -717.7847,1456.5078,-90.5046,91.9805);

    CreateDynamic3DTextLabel("STAFF", COLOR_WHITE, -727.6509,1446.4381,-90.5046 + 1.3, 5.0);
    bmActor[2] = CreateActor(2, -727.6509,1446.4381,-90.5046,2.9536);

    for(new i = 0; i < 3; i ++) SetDynamicActorVirtualWorld(bmActor[i], 1), SetActorInvulnerable(bmActor[i], true);
    return 1;
}

stock Blackmarket_Shop(playerid)
{
    if (!IsPlayerConnected(playerid) && PlayerInfo[playerid][pInjured] && !PlayerInfo[playerid][pID])
        return 0;

    new header[128],name[128], str[(1024 * 2)];

    PlayerInfo[playerid][pStorageSelect] = 0;

    for (new i = 0, j; i < MAX_BLACKMARKET_ITEMS && i <  MAX_INVENTORY; i ++)
    {
        strunpack(name, BlackmarketItems[i][itemName]);

        g_ListedItems[playerid][j] = i;
        format(header, sizeof(header), "Blackmarket Item's");
        format(str, sizeof str, "%s%i\t%s~n~~y~(%i)\n", str, BlackmarketItems[i][itemObject], BlackmarketItems[i][itemName], BlackmarketItems[i][itemPrice]);
        j++;
    }
    return ShowPlayerDialog(playerid, DIALOG_BLACKMARKET, DIALOG_STYLE_PREVIEW_MODEL, header, str, "Select", "Cancel");
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == DIALOG_BLACKMARKET)
    {
        if(response)
        {
            new itemid = g_ListedItems[playerid][listitem], name[48];

            if(PlayerInfo[playerid][pCash] < BlackmarketItems[itemid][itemPrice]) return SendMessage(playerid, COLOR_SYNTAX, "You don't have enough money to buy this item.");

            strunpack(name, BlackmarketItems[itemid][itemName]);

			// Set playerid inventory
            new id = Inventory_Add(playerid, name, BlackmarketItems[itemid][itemObject]);
            if (id == -1) return SendClientMessage(playerid, COLOR_SYNTAX, "Your inventory has full.");

            SendMessage(playerid, COLOR_SYNTAX, "You have purchased %s for $%i.", BlackmarketItems[itemid][itemName], BlackmarketItems[itemid][itemPrice]);
            SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s paid $%i and received a %s.", GetRPName(playerid), BlackmarketItems[itemid][itemPrice], BlackmarketItems[itemid][itemName]);
        }
	}
    return 1;
}

CMD:blackmarket(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, -720.1449,1462.9044,-90.5046))
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of blackmarket.");

    Blackmarket_Shop(playerid);
    return 1;
}