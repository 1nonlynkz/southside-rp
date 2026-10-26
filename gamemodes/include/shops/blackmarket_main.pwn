#include <YSI_Coding\y_hooks>

new PlayerText:BlackmarketTD[MAX_PLAYERS][60];

#define MAX_BM_ITEMS 16
#define MAX_CART_SLOTS 2
#define MAX_ITEM_QTY 10

#define DIALOG_BM_EDIT_LIST 9845
#define DIALOG_BM_EDIT_VAL  9846

enum eBMData
{
    bmName[32],
    bmPrice,       
    bmMats,        
    bmWeaponID,
    bmAmount,
    bmModel
};

new BMData[MAX_BM_ITEMS][eBMData] =
{
    {"Deagle", 1500, 10, 24, 50, 348},
    {"AK-47", 3000, 20, 30, 150, 355},
    {"Sniper", 5400, 35, 34, 25, 358},
    {"Half Armour", 1200, 5, -1, 50, 1242},

    {"Shotgun", 5000, 25, 25, 50, 349},
    {"MP5", 7000, 30, 29, 150, 353},
    {"M4", 9000, 40, 31, 150, 356},
    {"Tec9", 4000, 15, 32, 200, 372},

    {"Rifle", 6000, 25, 33, 50, 357},
    {"Uzi", 3000, 15, 28, 200, 352},
    {"Grenade", 2000, 10, 16, 5, 342},
    {"Knife", 1000, 2, 4, 1, 335},

    {"Armor+", 8000, 30, -1, 100, 1242},
    {"Health Kit", 5000, 15, -1, 100, 1580},
    {"Molotov", 3000, 12, 18, 5, 344},
    {"Silenced", 4500, 18, 23, 50, 346}
};

enum eWeaponList
{
    wName[32],
    wID
};

new const AllWeapons[][eWeaponList] = {
    {"Brass Knuckles", 1},
    {"Golf Club", 2},
    {"Nightstick", 3},
    {"Knife", 4},
    {"Baseball Bat", 5},
    {"Shovel", 6},
    {"Pool Cue", 7},
    {"Katana", 8},
    {"Chainsaw", 9},
    {"Purple Dildo", 10},
    {"White Dildo", 11},
    {"Long Dildo", 12},
    {"Short Dildo", 13},
    {"Flowers", 14},
    {"Cane", 15},
    {"Grenade", 16},
    {"Teargas", 17},
    {"Molotov Cocktail", 18},
    {"9mm Pistol", 22},
    {"Silenced Pistol", 23},
    {"Desert Eagle", 24},
    {"Shotgun", 25},
    {"Sawnoff Shotgun", 26},
    {"Combat Shotgun", 27},
    {"Micro Uzi (Mac 10)", 28},
    {"MP5", 29},
    {"AK-47", 30},
    {"M4", 31},
    {"Tec-9", 32},
    {"Country Rifle", 33},
    {"Sniper Rifle", 34},
    {"RPG", 35},
    {"HS Rocket Launcher", 36},
    {"Flame Thrower", 37},
    {"Minigun", 38},
    {"Satchel Charge", 39},
    {"Detonator", 40},
    {"Spraycan", 41},
    {"Fire Extinguisher", 42},
    {"Camera", 43},
    {"Nightvision Goggles", 44},
    {"Thermal Goggles", 45},
    {"Parachute", 46}
};

new PlayerBMPage[MAX_PLAYERS];
new EditWepSelected[MAX_PLAYERS]; 

new PlayerCart[MAX_PLAYERS][MAX_CART_SLOTS][2]; 
new BoxBase[8] = {3,8,13,18,23,28,33,38};

hook OnGameModeInit()
{
    // Create table if it doesn't exist yet
    mysql_tquery(connectionID, "CREATE TABLE IF NOT EXISTS `blackmarket` (`item_name` VARCHAR(32) UNIQUE, `price` INT DEFAULT 0, `mats` INT DEFAULT 0)", "OnBlackMarketTableCreated", "");
    return 1;
}

forward OnBlackMarketTableCreated();
public OnBlackMarketTableCreated()
{
    mysql_tquery(connectionID, "SELECT * FROM `blackmarket`", "LoadBlackMarketItems", "");
    return 1;
}

forward LoadBlackMarketItems();
public LoadBlackMarketItems()
{
    new rows, fields;
    cache_get_data(rows, fields, connectionID);

    new query[150];

    if(rows > 0)
    {
        new temp_name[32];
        for(new i = 0; i < rows; i++)
        {
            cache_get_row(i, 0, temp_name, connectionID, sizeof(temp_name)); // column 0: item_name
            
            for(new b = 0; b < MAX_BM_ITEMS; b++)
            {
                if(!strcmp(BMData[b][bmName], temp_name, true))
                {
                    BMData[b][bmPrice] = cache_get_row_int(i, 1, connectionID); // column 1: price
                    BMData[b][bmMats] = cache_get_row_int(i, 2, connectionID);  // column 2: mats
                    break;
                }
            }
        }
    }
    
    for(new b = 0; b < MAX_BM_ITEMS; b++)
    {
        mysql_format(connectionID, query, sizeof(query), "INSERT IGNORE INTO `blackmarket` (`item_name`, `price`, `mats`) VALUES ('%e', %d, %d)", BMData[b][bmName], BMData[b][bmPrice], BMData[b][bmMats]);
        mysql_tquery(connectionID, query);
    }
    
    printf("[Black Market] Loaded %d items from MySQL.", rows);
    return 1;
}

hook OnPlayerConnect(playerid)
{
    ResetPlayerCart(playerid);
    EditWepSelected[playerid] = -1;
    return 1;
}

stock ResetPlayerCart(playerid)
{
    for(new i = 0; i < MAX_CART_SLOTS; i++)
    {
        PlayerCart[playerid][i][0] = -1;
        PlayerCart[playerid][i][1] = 0;
    }
}

stock HideBlackmarketTD(playerid)
{
    for(new i = 0; i < 60; i++)
    {
        if(BlackmarketTD[playerid][i] != PlayerText:INVALID_TEXT_DRAW)
        {
            PlayerTextDrawHide(playerid, BlackmarketTD[playerid][i]);
        }
    }
    CancelSelectTextDraw(playerid); // Tanggalin ang cursor sa screen
    return 1;
}


alias:bm("blackmarket")
CMD:blackmarket(playerid, params[])
{
    if(GetNearbyBlackMarket(playerid) == -1)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of blackmarket.");
    }

    PlayerBMPage[playerid] = 0;
    ShowBlackmarketTD(playerid);
    UpdateBlackmarketTD(playerid);
    return 1;
}

stock ShowBlackmarketTD(playerid)
{
    UpdateBlackmarketTD(playerid);

    for(new i; i < 60; i++)
    {
        if(BlackmarketTD[playerid][i] != PlayerText:INVALID_TEXT_DRAW)
            PlayerTextDrawShow(playerid, BlackmarketTD[playerid][i]);
    }

    SelectTextDraw(playerid, 0xFFFFFFFF);
    return 1;
}

stock UpdateBlackmarketTD(playerid)
{
    new str[64];
    new start = PlayerBMPage[playerid] * 8;

    for(new i = 0; i < 8; i++)
    {
        new item = start + i;
        new base = BoxBase[i];

        if(item < MAX_BM_ITEMS)
        {
            format(str, sizeof(str), "%s", BMData[item][bmName]);
            PlayerTextDrawSetString(playerid, BlackmarketTD[playerid][base], str);

            format(str, sizeof(str), "$%d / %d Mats", BMData[item][bmPrice], BMData[item][bmMats]);
            PlayerTextDrawSetString(playerid, BlackmarketTD[playerid][base + 2], str);

            PlayerTextDrawSetPreviewModel(playerid, BlackmarketTD[playerid][base + 1], BMData[item][bmModel]);
        }
        else
        {
            PlayerTextDrawSetString(playerid, BlackmarketTD[playerid][base], "Empty");
            PlayerTextDrawSetString(playerid, BlackmarketTD[playerid][base + 2], "$0");
        }
    }

    new total_cash = 0;
    new total_mats = 0;

    for(new i; i < MAX_CART_SLOTS; i++)
    {
        new base = (i == 0) ? 46 : 51;

        if(PlayerCart[playerid][i][0] != -1)
        {
            new item = PlayerCart[playerid][i][0];
            new qty = PlayerCart[playerid][i][1];

            format(str, sizeof(str), "%s x%d", BMData[item][bmName], qty);
            PlayerTextDrawSetString(playerid, BlackmarketTD[playerid][base], str);

            new price = BMData[item][bmPrice] * qty;
            new mats = BMData[item][bmMats] * qty;
            total_cash += price;
            total_mats += mats;

            format(str, sizeof(str), "$%d / %dm", price, mats);
            PlayerTextDrawSetString(playerid, BlackmarketTD[playerid][base + 3], str);
        }
        else
        {
            PlayerTextDrawSetString(playerid, BlackmarketTD[playerid][base], "Empty");
            PlayerTextDrawSetString(playerid, BlackmarketTD[playerid][base + 3], "$0");
        }
    }

    format(str, sizeof(str), "TOTAL: $%d & %d Mats", total_cash, total_mats);
    PlayerTextDrawSetString(playerid, BlackmarketTD[playerid][57], str);

    return 1;
}

stock AddToCart(playerid, item)
{
    for(new i; i < MAX_CART_SLOTS; i++)
    {
        if(PlayerCart[playerid][i][0] == item)
        {
            if(PlayerCart[playerid][i][1] >= MAX_ITEM_QTY)
                return SendClientMessage(playerid, -1, "Maximum item limit reached!");

            PlayerCart[playerid][i][1]++;
            UpdateBlackmarketTD(playerid);
            return 1;
        }
    }

    for(new i; i < MAX_CART_SLOTS; i++)
    {
        if(PlayerCart[playerid][i][0] == -1)
        {
            PlayerCart[playerid][i][0] = item;
            PlayerCart[playerid][i][1] = 1;
            UpdateBlackmarketTD(playerid);
            return 1;
        }
    }

    return SendClientMessage(playerid, -1, "Your shopping cart is full!");
}

stock CheckoutBlackmarket(playerid)
{
    new total_cash = 0;
    new total_mats = 0;

    for(new i; i < MAX_CART_SLOTS; i++)
    {
        if(PlayerCart[playerid][i][0] != -1)
        {
            new item = PlayerCart[playerid][i][0];
            new qty = PlayerCart[playerid][i][1];

            total_cash += BMData[item][bmPrice] * qty;
            total_mats += BMData[item][bmMats] * qty;
        }
    }

    if(total_cash <= 0 && total_mats <= 0)
        return SendClientMessage(playerid, -1, "Your cart is empty.");

    if(PlayerInfo[playerid][pCash] < total_cash)
        return SendClientMessage(playerid, -1, "You do not have enough cash.");

    if(PlayerInfo[playerid][pMaterials] < total_mats)
        return SendClientMessage(playerid, -1, "You do not have enough materials.");

    for(new i; i < MAX_CART_SLOTS; i++)
    {
        if(PlayerCart[playerid][i][0] != -1)
        {
            new item = PlayerCart[playerid][i][0];
            new qty = PlayerCart[playerid][i][1];
            new wep = BMData[item][bmWeaponID];

            new msg[64];
            format(msg, sizeof(msg), "Purchased: %s x%d", BMData[item][bmName], qty);
            SendClientMessage(playerid, -1, msg);

            if(wep != -1)
            {
                GivePlayerWeapon(playerid, wep, BMData[item][bmAmount] * qty);
            }
            else
            {
                if(!strcmp(BMData[item][bmName], "Half Armour", true))
                {
                    new Float:a;
                    GetPlayerArmour(playerid, a);
                    SetPlayerArmour(playerid, a + (50.0 * qty));
                }
                else if(!strcmp(BMData[item][bmName], "Armor+", true))
                {
                    new Float:a;
                    GetPlayerArmour(playerid, a);
                    SetPlayerArmour(playerid, a + (100.0 * qty));
                }
                else if(!strcmp(BMData[item][bmName], "Health Kit", true))
                {
                    new Float:h;
                    GetPlayerHealth(playerid, h);
                    SetPlayerHealth(playerid, h + (100.0 * qty));
                }
            }
        }
    }

    PlayerInfo[playerid][pCash] -= total_cash;
    PlayerInfo[playerid][pMaterials] -= total_mats;

    new totalmsg[128];
    format(totalmsg, sizeof(totalmsg), "Payment Successful. Paid: $%d Cash & %d Materials.", total_cash, total_mats);
    SendClientMessage(playerid, -1, totalmsg);

    ResetPlayerCart(playerid);
    UpdateBlackmarketTD(playerid);

    return 1;
}

CMD:editbmitem(playerid, params[])
{
    // Restrict access here if needed: (e.g. if(PlayerInfo[playerid][pAdmin] < 5) ...)
    new list[2048], temp[128];
    list[0] = '\0';

    format(list, sizeof(list), "Weapon Name\tID\tBM Status\n");

    for(new i = 0; i < sizeof(AllWeapons); i++)
    {
        new wepid = AllWeapons[i][wID];
        new bm_index = -1;

        for(new b = 0; b < MAX_BM_ITEMS; b++)
        {
            if(BMData[b][bmWeaponID] == wepid)
            {
                bm_index = b;
                break;
            }
        }

        if(bm_index != -1)
        {
            format(temp, sizeof(temp), "%s\t%d\t{00FF00}Active ($%d / %d Mats)\n", AllWeapons[i][wName], wepid, BMData[bm_index][bmPrice], BMData[bm_index][bmMats]);
        }
        else
        {
            format(temp, sizeof(temp), "%s\t%d\t{CCCCCC}Inactive\n", AllWeapons[i][wName], wepid);
        }
        strcat(list, temp);
    }

    ShowPlayerDialog(playerid, DIALOG_BM_EDIT_LIST, DIALOG_STYLE_TABLIST_HEADERS, "BM Weapon Editor", list, "Select", "Cancel");
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_BM_EDIT_LIST)
    {
        if(!response) return 1;

        EditWepSelected[playerid] = listitem; 

        new wepid = AllWeapons[listitem][wID];
        new cur_cash = 0, cur_mats = 0;
        new bool:active = false;

        for(new b = 0; b < MAX_BM_ITEMS; b++)
        {
            if(BMData[b][bmWeaponID] == wepid)
            {
                cur_cash = BMData[b][bmPrice];
                cur_mats = BMData[b][bmMats];
                active = true;
                break;
            }
        }

        new info_str[300];
        if(active)
        {
            format(info_str, sizeof(info_str), 
                "Weapon: {00FF00}%s (ID: %d){FFFFFF}\nStatus: {00FF00}Active in Black Market\n\nCurrent Price: $%d & %d Mats\n\nEnter new pricing below:\n[Cash Price] [Mats Price]\nExample: 5000 150", 
                AllWeapons[listitem][wName], wepid, cur_cash, cur_mats
            );
        }
        else
        {
            format(info_str, sizeof(info_str), 
                "Weapon: {FFFF00}%s (ID: %d){FFFFFF}\nStatus: {CCCCCC}Not listed in the shop\n\nEnter new pricing below:\n[Cash Price] [Mats Price]\nExample: 5000 150", 
                AllWeapons[listitem][wName], wepid
            );
        }

        ShowPlayerDialog(playerid, DIALOG_BM_EDIT_VAL, DIALOG_STYLE_INPUT, "Modify Pricing", info_str, "Save", "Back");
        return 1;
    }

    if(dialogid == DIALOG_BM_EDIT_VAL)
    {
        if(!response)
        {
            new emptyParams[1];
            emptyParams[0] = '\0';
            EditWepSelected[playerid] = -1;
            callcmd::editbmitem(playerid, emptyParams);
            return 1;
        }

        new idx = EditWepSelected[playerid];
        if(idx < 0 || idx >= sizeof(AllWeapons)) return 1;

        new wepid = AllWeapons[idx][wID];
        new cash_val, mats_val;

        if(sscanf(inputtext, "dd", cash_val, mats_val))
        {
            SendClientMessage(playerid, -1, "Invalid input. Use format: [Cash Price] [Mats Price]");
            
            new info_str[300];
            format(info_str, sizeof(info_str), 
                "{FF0000}Format error. Please retry.{FFFFFF}\n\nWeapon: %s (ID: %d)\nFormat: [Cash] [Mats]\nExample: 5000 150", 
                AllWeapons[idx][wName], wepid
            );
            ShowPlayerDialog(playerid, DIALOG_BM_EDIT_VAL, DIALOG_STYLE_INPUT, "Modify Pricing", info_str, "Save", "Back");
            return 1;
        }

        if(cash_val < 0 || mats_val < 0)
        {
            SendClientMessage(playerid, -1, "Values cannot be negative.");
            return 1;
        }

        new bool:saved = false;
        new query[150];

        for(new b = 0; b < MAX_BM_ITEMS; b++)
        {
            if(BMData[b][bmWeaponID] == wepid)
            {
                BMData[b][bmPrice] = cash_val;
                BMData[b][bmMats] = mats_val;
                saved = true;

                mysql_format(connectionID, query, sizeof(query), "UPDATE `blackmarket` SET `price` = %d, `mats` = %d WHERE `item_name` = '%e'", cash_val, mats_val, BMData[b][bmName]);
                mysql_tquery(connectionID, query);
            }
        }

        new msg[144];
        if(saved)
        {
            format(msg, sizeof(msg), "[BM Editor] Updated %s pricing to $%d Cash & %d Materials. Saved to MySQL Database.", AllWeapons[idx][wName], cash_val, mats_val);
            SendClientMessage(playerid, -1, msg);
        }
        else
        {
            format(msg, sizeof(msg), "[BM Editor] %s modified. Adjusted values globally but weapon is currently inactive.", AllWeapons[idx][wName]);
            SendClientMessage(playerid, -1, msg);
        }

        EditWepSelected[playerid] = -1;
        return 1;
    }
    return 0;
}

hook OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(playertextid == PlayerText:INVALID_TEXT_DRAW)
    {
        HideBlackmarketTD(playerid);
        return 1;
    }

    // ADD TO CART
    for(new i = 0; i < 8; i++)
    {
        new base = 3 + (i * 5);

        if(playertextid == BlackmarketTD[playerid][base + 3])
        {
            new item = (PlayerBMPage[playerid] * 8) + i;
            
            if(item < MAX_BM_ITEMS)
            {
                AddToCart(playerid, item);
            }
            return 1;
        }
    }

    // NEXT PAGE
    if(playertextid == BlackmarketTD[playerid][42])
    {
        new max_pages = (MAX_BM_ITEMS - 1) / 8;
        if(PlayerBMPage[playerid] < max_pages)
        {
            PlayerBMPage[playerid]++;
            UpdateBlackmarketTD(playerid);
        }
        return 1;
    }

    // BACK PAGE
    if(playertextid == BlackmarketTD[playerid][43])
    {
        if(PlayerBMPage[playerid] > 0)
        {
            PlayerBMPage[playerid]--;
            UpdateBlackmarketTD(playerid);
        }
        return 1;
    }

    // REMOVE SLOT 1
    if(playertextid == BlackmarketTD[playerid][47])
    {
        PlayerCart[playerid][0][0] = -1;
        PlayerCart[playerid][0][1] = 0;
        UpdateBlackmarketTD(playerid);
        return 1;
    }

    // REMOVE SLOT 2
    if(playertextid == BlackmarketTD[playerid][52])
    {
        PlayerCart[playerid][1][0] = -1;
        PlayerCart[playerid][1][1] = 0;
        UpdateBlackmarketTD(playerid);
        return 1;
    }

    // CHECKOUT
    if(playertextid == BlackmarketTD[playerid][58])
    {
        CheckoutBlackmarket(playerid);
        return 1;
    }
    return 0;
}