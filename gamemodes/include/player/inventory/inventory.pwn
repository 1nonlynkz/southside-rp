#include <YSI_Coding\y_hooks>

// Inventory V2
#define MAX_INVENTORY 		20
#define COL_WHITE                   "{FFFFFF}"
#define COLOR_PLUM                  0xDDA0DDFF
#define DIALOG_INV_AMOUNT 9462
#define DIALOG_INV_PREVIEW 9463
#define DIALOG_INV_VIEWER 9465
#define DIALOG_INV_ACTION 9464

new InventoryDialogTarget[MAX_PLAYERS];
new InventoryDialogItem[MAX_PLAYERS];
new bool:InventoryDialogReadOnly[MAX_PLAYERS];
new InventoryPendingAction[MAX_PLAYERS];



new PlayerInventoryCooldown[MAX_PLAYERS];

new NearestID[MAX_PLAYERS];
new NearestItems[MAX_PLAYERS][20];

new selectedItem[MAX_PLAYERS];
new selectedItem2[MAX_PLAYERS];
new ShowingInventory[MAX_PLAYERS];
new AmountPlaced[MAX_PLAYERS];

new LootMode[MAX_PLAYERS];
new PickupMode[MAX_PLAYERS];
new PlayerIsInStore[MAX_PLAYERS];

enum inventoryData {
	invExists,
	invID,
	invItem[128],
	invModel,
	invQuantity
};
new InventoryData[MAX_PLAYERS][MAX_INVENTORY][inventoryData];

enum e_InventoryItems {
	e_InventoryItem[128],
	e_InventoryModel
};

SendNearbyMessage(playerid, color, Float:range, const fmat[], va_args<>){
    static message[244], Float:x, Float:y, Float:z;
    va_format(message, 244, fmat, va_start<4>);

	GetPlayerPos(playerid, x, y, z);

	foreach(new i : Player){
		if(IsPlayerInRangeOfPoint(i, range, x, y, z) && GetPlayerInterior(i) == GetPlayerInterior(playerid) && GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid)){
			SendClientMessage(i, color, message);
		}
	}
    return 1;
}


new const g_aInventoryItems[][e_InventoryItems] = {
	{"Marijuana", 1578},
	// Weapons
	{"Brass Knuckles", 331},
	{"Golf Club", 333},
	{"Nitestick", 334},
	{"Knife", 335},
	{"Bat", 336},
	{"Shovel", 337},
	{"Pool Cue", 338},
	{"Katana", 339},
	{"Chainsaw", 341},
	{"Dildo", 321},
	{"Vibrator", 323},
	{"Flowers", 325},
	{"Cane", 326},
	{"Deagle", 348},
	{"Colt45", 346},
	{"Shotgun", 349},
	{"SPAS12", 351},
	{"MP5", 353},
	{"AK47", 355},
	{"M4", 356},
	{"Rifle", 357},
	{"Sniper", 358},
	{"Spraycan", 365},
	{"Fire Extinguisher", 366},
	{"Camera", 367},
	{"Tazer", 347},
	{"Tec9", 372},
	{"Uzi", 352},
	// End of Weapons
	// 24/7 1650
	{"Jerry Can", 1650},
	{"Rope", 19088},
	{"Screwdriver", 18644},
	// End of 24/7
	{"Cellphone", 18868},
	{"Walkie Talkie", 19942},
	{"Boombox", 2226},
	{"Copper Rock", 905},
	{"Amethyst Rock", 905},
	{"Emerald Rock", 905},
	{"Ruby Rock", 905},
	{"Sapphire Rock", 905},
	{"Gold Rock", 905},
	{"Copper Ingot", 19941},
	{"Amethyst Ingot", 19941},
	{"Emerald Ingot", 19941},
	{"Ruby Ingot", 19941},
	{"Sapphire Ingot", 19941},
	{"Gold Ingot", 19941},
	{"Tacos", 2769},
	{"Water Bottle", 1484},
	// Ammo
	{".50 AE", 2041},
	{"5.56x45mm NATO", 2041},
	{"9mm", 2041},
	{"12-gauge", 2041},
	{"7.62x39mm", 2041},
	// Drugs
	{"Pot", 1580},
	{"Crack", 1575},
	{"Meth", 1579},
	{"Heroin", 1576}
};

forward LoadPlayerInventory(playerid);
public LoadPlayerInventory(playerid)
{
    new num_rows, num_fields;
    cache_get_data(num_rows, num_fields);
    
    if(!num_rows) return print("MySQL Report: No Player Inventory data exist to load in database.");

    for(new i = 0; i < num_rows && i < MAX_INVENTORY; i ++)
    {
        new id;
        id = cache_get_field_content_int(i, "slot");
        
        InventoryData[playerid][id][invExists] = true;
        InventoryData[playerid][id][invID] = cache_get_field_content_int(i, "invID");
        InventoryData[playerid][id][invModel] = cache_get_field_content_int(i, "invModel");
        InventoryData[playerid][id][invQuantity] = cache_get_field_content_int(i, "invQuantity");
        
        cache_get_field_content(i, "invItem", InventoryData[playerid][id][invItem], _, 32);
    }
    printf("MySQL Report: %s Inventory Loaded. [%d/%d]", ReturnPlayerRPName(playerid), num_rows, MAX_INVENTORY);
    return 1;
}


hook LoadPlayerStats(playerid)
{
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM `inventory` WHERE `ownerID` = '%d'", PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, queryBuffer, "LoadPlayerInventory", "d", playerid);
	return continue(playerid);
}

hook OnPlayerDisconnect(playerid)
{
	ShowingInventory[playerid] = 0;
	selectedItem[playerid] = -1;
	InventoryDialogItem[playerid] = -1;
	InventoryDialogTarget[playerid] = INVALID_PLAYER_ID;
	InventoryDialogReadOnly[playerid] = false;
}

stock Inventory_Clear(playerid)
{
	static
	    string[64];

	for (new i = 0; i < MAX_INVENTORY; i ++)
	{
	    if (InventoryData[playerid][i][invExists])
	    {
	        InventoryData[playerid][i][invExists] = 0;
	        InventoryData[playerid][i][invModel] = 0;
	        InventoryData[playerid][i][invQuantity] = 0;

		}
	}
	format(string, sizeof(string), "DELETE FROM `inventory` WHERE `ownerID` = '%d'", PlayerInfo[playerid][pID]);
	return mysql_tquery(connectionID, string);
}

CMD:clearinventory(playerid, params[])
{
    new targetid;
    if(PlayerInfo[playerid][pAdmin] < 2)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
    }
    
    if (sscanf(params, "u", targetid))  return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /clearinventory [playerid/name]");

    new string[144];
    format(string, sizeof(string), "ADMCMD: "COL_WHITE"%s removed all the inventory items of %s.", ReturnPlayerRPName(playerid), ReturnPlayerRPName(targetid));
    SendAdminMessage(COLOR_RED, string);

    if(playerid != targetid)
    {
        format(string, sizeof(string), "%s removed all your items in the inventory.", ReturnPlayerRPName(playerid));
        SendClientMessage(targetid, COLOR_SYNTAX, string);
    }
    else
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "You have cleared your own inventory.");
    }

    Inventory_Clear(targetid);
    return 1;
}


stock Inventory_Set(playerid, const item[], model, amount)
{
	new itemid = Inventory_GetItemID(playerid, item);

	if (itemid == -1 && amount > 0)
		Inventory_Add(playerid, item, model, amount);

	else if (amount > 0 && itemid != -1)
	    Inventory_SetQuantityEx(playerid, item, amount);

	else if (amount < 1 && itemid != -1)
	    Inventory_Remove(playerid, item, -1);

	return 1;
}

stock Inventory_GetItemID(playerid, const item[])
{
	for (new i = 0; i < MAX_INVENTORY; i ++)
	{
	    if (!InventoryData[playerid][i][invExists])
	        continue;

		if (!strcmp(InventoryData[playerid][i][invItem], item)) return i;
	}
	return -1;
}

stock Inventory_GetItemIDEx(playerid, const item[])
{
    for (new i = 0; i < MAX_INVENTORY; i++)
    {
        if (!InventoryData[playerid][i][invExists])
            continue;

        if (!strcmp(InventoryData[playerid][i][invItem], item))
        {
            return i;
        }
    }
    return -1;
}

stock Inventory_GetFreeID(playerid)
{
	if (Inventory_Items(playerid) >= 20)
		return -1;

	for (new i = 0; i < MAX_INVENTORY; i ++)
	{
	    if (!InventoryData[playerid][i][invExists])
	        return i;
	}
	return -1;
}

stock Inventory_Items(playerid)
{
    new count;

    for (new i = 0; i != MAX_INVENTORY; i ++) if (InventoryData[playerid][i][invExists]) {
        count++;
	}
	return count;
}

stock Inventory_Count(playerid, const item[])
{
	new itemid = Inventory_GetItemID(playerid, item);

	if (itemid != -1)
	    return InventoryData[playerid][itemid][invQuantity];

	return 0;
}

stock Inventory_HasItem(playerid, const item[])
{
	return (Inventory_GetItemID(playerid, item) != -1);
}

stock Inventory_SetQuantity(playerid, const item[], quantity)
{
	new
	    itemid = Inventory_GetItemID(playerid, item),
	    string[128];

	if (itemid != -1)
	{
	    format(string, sizeof(string), "UPDATE `inventory` SET `invQuantity` = %d WHERE `ownerID` = '%d' AND `invID` = '%d'", quantity, PlayerInfo[playerid][pID], InventoryData[playerid][itemid][invID]);
	    mysql_tquery(connectionID, string);

	    InventoryData[playerid][itemid][invQuantity] = quantity;
	}
	return 1;
}

stock Inventory_SetQuantityEx(playerid, const item[], quantity)
{
	new
	    itemid = Inventory_GetItemID(playerid, item);

	if (itemid != -1)
	{
		InventoryData[playerid][itemid][invQuantity] += quantity;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE `inventory` SET `invQuantity` = %d WHERE `ownerID` = '%d' AND `invID` = '%d'", InventoryData[playerid][itemid][invQuantity], PlayerInfo[playerid][pID], InventoryData[playerid][itemid][invID]);
	    mysql_tquery(connectionID, queryBuffer);
	}
	return 1;
}

stock Inventory_Add(playerid, const item[], model, quantity = 1)
{
	new itemid = Inventory_GetFreeID(playerid);

    if (itemid != -1)
    {
        InventoryData[playerid][itemid][invExists] = true;
        InventoryData[playerid][itemid][invModel] = model;
        InventoryData[playerid][itemid][invQuantity] = quantity;

        StrCpy(InventoryData[playerid][itemid][invItem], item, 128);
        //strpack(InventoryData[playerid][itemid][invItem], item, 32 char);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO `inventory` (ownerID, invItem, invModel, invQuantity, slot) VALUES(%d, '%e', %d, %d, %d)", PlayerInfo[playerid][pID], InventoryData[playerid][itemid][invItem], model, quantity, itemid);
        mysql_tquery(connectionID, queryBuffer, "OnInventoryAdd", "dd", playerid, itemid);
		return 1;
    }
	else if(itemid == -1)
	{
		return SendMessage(playerid, COLOR_GREEN, "Your Inventory is full");
	}
	return 1;
}

stock Inventory_AddEx(playerid, const item[], model, quantity, itemid)
{
	InventoryData[playerid][itemid][invExists] = true;
	InventoryData[playerid][itemid][invModel] = model;
	InventoryData[playerid][itemid][invQuantity] = quantity;

	//strpack(InventoryData[playerid][itemid][invItem], item, 32 char);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO inventory (ownerID, invItem, invModel, invQuantity, slot) VALUES(%d, '%e', %d, %d, %d)", PlayerInfo[playerid][pID], item, model, quantity, itemid);
	mysql_tquery(connectionID, queryBuffer, "OnInventoryAdd", "dd", playerid, itemid);

	return 1;
}

stock Inventory_Remove(playerid, const item[], quantity = 1)
{
	new
		itemid = Inventory_GetItemID(playerid, item),
		string[128];

	if (itemid != -1)
	{
	    if (InventoryData[playerid][itemid][invQuantity] > 0)
	    {
	        InventoryData[playerid][itemid][invQuantity] -= quantity;
		}
		if (quantity == -1 || InventoryData[playerid][itemid][invQuantity] < 1)
		{
		    InventoryData[playerid][itemid][invExists] = false;
		    InventoryData[playerid][itemid][invModel] = 0;
		    InventoryData[playerid][itemid][invQuantity] = 0;

		    format(string, sizeof(string), "DELETE FROM `inventory` WHERE `ownerID` = '%d' AND `invID` = '%d'", PlayerInfo[playerid][pID], InventoryData[playerid][itemid][invID]);
	        mysql_tquery(connectionID, string);
		}
		else if (quantity != -1 && InventoryData[playerid][itemid][invQuantity] > 0)
		{
			format(string, sizeof(string), "UPDATE `inventory` SET `invQuantity` = `invQuantity` - %d WHERE `ownerID` = '%d' AND `invID` = '%d'", quantity, PlayerInfo[playerid][pID], InventoryData[playerid][itemid][invID]);
            mysql_tquery(connectionID, string);
		}
		return 1;
	}
	return 0;
}

stock Inventory_RemoveEx(playerid, itemid, quantity)
{
	new string[128];
	// InventoryData[playerid][itemid][invExists] = false;
	// InventoryData[playerid][itemid][invModel] = 0;
	// InventoryData[playerid][itemid][invQuantity] = 0;
	// StrCpy(InventoryData[playerid][itemid][invItem], "");

	// format(string, sizeof(string), "DELETE FROM `inventory` WHERE `ownerID` = '%d' AND `invID` = '%d'", PlayerInfo[playerid][pID], InventoryData[playerid][itemid][invID]);
	// mysql_tquery(connectionID, string);

	if (InventoryData[playerid][itemid][invQuantity] > 0)
	{
		InventoryData[playerid][itemid][invQuantity] -= quantity;
	}
	if (quantity == -1 || InventoryData[playerid][itemid][invQuantity] < 1)
	{
		InventoryData[playerid][itemid][invExists] = false;
		InventoryData[playerid][itemid][invModel] = 0;
		InventoryData[playerid][itemid][invQuantity] = 0;

		format(string, sizeof(string), "DELETE FROM `inventory` WHERE `ownerID` = '%d' AND `invID` = '%d'", PlayerInfo[playerid][pID], InventoryData[playerid][itemid][invID]);
		mysql_tquery(connectionID, string);
	}
	else if (quantity != -1 && InventoryData[playerid][itemid][invQuantity] > 0)
	{
		format(string, sizeof(string), "UPDATE `inventory` SET `invQuantity` = `invQuantity` - %d WHERE `ownerID` = '%d' AND `invID` = '%d'", quantity, PlayerInfo[playerid][pID], InventoryData[playerid][itemid][invID]);
		mysql_tquery(connectionID, string);
	}
	return 1;
}

hook OnPlayerConnect(playerid)
{
	InventoryDialogTarget[playerid] = playerid;
	InventoryDialogItem[playerid] = -1;
	InventoryDialogReadOnly[playerid] = false;
    InventoryPendingAction[playerid] = 0;
    selectedItem[playerid] = -1;
	selectedItem2[playerid] = -1;
	PlayerInventoryCooldown[playerid] = 0;
	ShowingInventory[playerid] = 0;
	AmountPlaced[playerid] = 0;
	NearestID[playerid] = 0;
	LootMode[playerid] = -1;
	PickupMode[playerid] = 0;
    for (new i = 0; i != MAX_INVENTORY; i ++) {
	    InventoryData[playerid][i][invExists] = false;
	    InventoryData[playerid][i][invModel] = 0;
	    InventoryData[playerid][i][invQuantity] = 0;
	}
	for (new i = 0; i < MAX_INVENTORY; i ++) {
	    NearestItems[playerid][i] = -1;
	}

    return Y_HOOKS_CONTINUE_RETURN_1;
}

forward OnPlayerUseItem(playerid, const item[], itemid, amount);
public OnPlayerUseItem(playerid, const item[], itemid, amount)
{
    new empty_params[1];
    empty_params[0] = '\0';

    // --- MEDICAL & CONSUMABLES ---
    if(CompareStrings("First Aid", item)) 
    {
        callcmd::usefirstaid(playerid, empty_params);
    }
    else if(CompareStrings("Painkillers", item)) 
    {
        callcmd::usepainkillers(playerid, empty_params);
    }
    else if(CompareStrings("Cigar", item) || CompareStrings("Cigars", item))
    {
        if(Inventory_Count(playerid, "Cigars") < 1) return 1;
        callcmd::usecigar(playerid, empty_params);
    }
    else if(CompareStrings("Vest", item)) 
    {
        callcmd::usevest(playerid, empty_params);
    }

    else if(CompareStrings("Bottled Water", item))
    {
        if(Inventory_Count(playerid, "Bottled Water") < 1) return 1;
        
        GivePlayerThirst(playerid, 25);
        GivePlayerHealth(playerid, 10.0);
        Inventory_Remove(playerid, "Bottled Water", 1);
        
        ApplyAnimation(playerid, "VEND", "VEND_Drink2_P", 4.1, false, false, false, false, 0);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s opens a bottled water and takes a drink.", GetRPName(playerid));
    }
    else if(CompareStrings("Sprunk Can", item))
    {
        if(Inventory_Count(playerid, "Sprunk Can") < 1) return 1;
        
        GivePlayerThirst(playerid, 20);
        GivePlayerHealth(playerid, 15.0);
        Inventory_Remove(playerid, "Sprunk Can", 1);
        
        ApplyAnimation(playerid, "VEND", "VEND_Drink2_P", 4.1, false, false, false, false, 0);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s cracks open a can of Sprunk and drinks it.", GetRPName(playerid));
    }
    else if(CompareStrings("Water Can", item))
    {
        if(Inventory_Count(playerid, "Water Can") < 1) return 1;
        
        GivePlayerThirst(playerid, 30); 
        GivePlayerHealth(playerid, 10.0); 
        Inventory_Remove(playerid, "Water Can", 1);
        
        ApplyAnimation(playerid, "VEND", "VEND_Drink2_P", 4.1, false, false, false, false, 0);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s opens a water can and takes a big drink.", GetRPName(playerid));
    }
    else if(CompareStrings("Kid's Meal", item))
    {
        if(Inventory_Count(playerid, "Kid's Meal") < 1) return 1;
        
        GivePlayerHunger(playerid, 20);
        GivePlayerHealth(playerid, 20.0);
        Inventory_Remove(playerid, "Kid's Meal", 1);
        
        ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s eats a kid's meal.", GetRPName(playerid));
    }
    else if(CompareStrings("Medium Meal", item))
    {
        if(Inventory_Count(playerid, "Medium Meal") < 1) return 1;
        
        GivePlayerHunger(playerid, 30);
        GivePlayerHealth(playerid, 25.0);
        Inventory_Remove(playerid, "Medium Meal", 1);
        
        ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s eats a medium meal.", GetRPName(playerid));
    }
    else if(CompareStrings("Big Meal", item))
    {
        if(Inventory_Count(playerid, "Big Meal") < 1) return 1;
        
        GivePlayerHunger(playerid, 50);
        GivePlayerHealth(playerid, 30.0);
        Inventory_Remove(playerid, "Big Meal", 1);
        
        ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, false, false, false, false, 0);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s eats a heavy big meal.", GetRPName(playerid));
    }

    // --- UTILITIES ---
    else if(CompareStrings("Gasoline Can", item))
    {
        callcmd::gascan(playerid, empty_params); 
    }
    else if(CompareStrings("GPS", item))
    {
        if(Inventory_Count(playerid, "GPS") < 1) return 1;
        callcmd::locate(playerid, empty_params); 
    }
    else if(CompareStrings("Mobile Phone", item))
    {
        if(Inventory_Count(playerid, "Mobile Phone") < 1) return 1;     
    }
    else if(CompareStrings("Tazer", item)) 
    {
        callcmd::tazer(playerid, empty_params);
    }
    else if(CompareStrings("Mask", item))
    {
        if(Inventory_Count(playerid, "Mask") < 1) return 1;
        
        if(Maskara[playerid] == 0)
        {
            Inventory_Remove(playerid, "Mask", 1);
        }    
        callcmd::mask(playerid, empty_params);
    }

    else if(CompareStrings("Portable Radio", item))
    {
        SendClientMessage(playerid, COLOR_YELLOW, "(( Use /channel to set your frequency and /pr to speak. ))");
    }

    // --- ILLEGAL / DRUGS ---
    else if(CompareStrings("Meth", item)) {
        new drug_param[5];
        format(drug_param, sizeof(drug_param), "meth");
        callcmd::usedrug(playerid, drug_param);
    }
    else if(CompareStrings("Pot", item)) {
        new drug_param[4];
        format(drug_param, sizeof(drug_param), "pot");
        callcmd::usedrug(playerid, drug_param);
    }
    else if(CompareStrings("Crack", item)) {
        new drug_param[6];
        format(drug_param, sizeof(drug_param), "crack");
        callcmd::usedrug(playerid, drug_param);
    }
    else if(CompareStrings("Heroin", item)) {
        new drug_param[7];
        format(drug_param, sizeof(drug_param), "heroin");
        callcmd::usedrug(playerid, drug_param);
    }

    // --- WEAPONS ---
    else if(CompareStrings("Camera", item)) {
        if(Inventory_Count(playerid, "Camera") < 1) return 1;
        GivePlayerWeaponEx(playerid, 43, 36); 
        Inventory_Remove(playerid, "Camera", 1);
        SendClientMessage(playerid, COLOR_WHITE, "(( You have equipped a Camera from your inventory. ))");
    }
    else if(CompareStrings("9mm Pistol", item)) {
        if(Inventory_Count(playerid, "9mm Pistol") < 1) return 1;
        GivePlayerWeaponEx(playerid, 22, AMMO_DEFAULT); 
        Inventory_Remove(playerid, item, 1);
    }
    else if(CompareStrings("Silenced 9mm", item)) {
        if(Inventory_Count(playerid, "Silenced 9mm") < 1) return 1;
        GivePlayerWeaponEx(playerid, 23, AMMO_DEFAULT);
        Inventory_Remove(playerid, item, 1);
    }
    else if(CompareStrings("Desert Eagle", item) || CompareStrings("Deagle", item)) {
        if(Inventory_Count(playerid, "Desert Eagle") < 1 && Inventory_Count(playerid, "Deagle") < 1) return 1;
        GivePlayerWeaponEx(playerid, 24, AMMO_DEAGLE); 
        Inventory_Remove(playerid, item, 1);
    }
    else if(CompareStrings("Shotgun", item)) {
        if(Inventory_Count(playerid, "Shotgun") < 1) return 1;
        GivePlayerWeaponEx(playerid, 25, AMMO_SHOTGUN); 
        Inventory_Remove(playerid, item, 1);
    }
    else if(CompareStrings("Combat Shotgun", item)) {
        if(Inventory_Count(playerid, "Combat Shotgun") < 1) return 1;
        GivePlayerWeaponEx(playerid, 27, AMMO_SHOTGUN); 
        Inventory_Remove(playerid, item, 1);
    }
    else if(CompareStrings("Micro SMG", item)) {
        if(Inventory_Count(playerid, "Micro SMG") < 1) return 1;
        GivePlayerWeaponEx(playerid, 28, AMMO_SMG); 
        Inventory_Remove(playerid, item, 1);
    }
    else if(CompareStrings("MP5", item)) {
        if(Inventory_Count(playerid, "MP5") < 1) return 1;
        GivePlayerWeaponEx(playerid, 29, AMMO_SMG);
        Inventory_Remove(playerid, item, 1);
    }
    else if(CompareStrings("AK-47", item)) {
        if(Inventory_Count(playerid, "AK-47") < 1) return 1;
        GivePlayerWeaponEx(playerid, 30, AMMO_RIFLE);
        Inventory_Remove(playerid, item, 1);
    }
    else if(CompareStrings("Tec-9", item)) {
        if(Inventory_Count(playerid, "Tec-9") < 1) return 1;
        GivePlayerWeaponEx(playerid, 32, AMMO_SMG);
        Inventory_Remove(playerid, item, 1);
    }
    else if(CompareStrings("Country Rifle", item) || CompareStrings("Rifle", item)) {
        if(Inventory_Count(playerid, "Country Rifle") < 1 && Inventory_Count(playerid, "Rifle") < 1) return 1;
        GivePlayerWeaponEx(playerid, 33, AMMO_RIFLE);
        Inventory_Remove(playerid, item, 1);
    }
    else if(CompareStrings("Sniper Rifle", item)) {
        if(Inventory_Count(playerid, "Sniper Rifle") < 1) return 1;
        GivePlayerWeaponEx(playerid, 34, AMMO_SNIPER);
        Inventory_Remove(playerid, item, 1);
    }
    else if(CompareStrings("Assault Rifle", item)) {
        if(Inventory_Count(playerid, "Assault Rifle") < 1) return 1;
        GivePlayerWeaponEx(playerid, 30, AMMO_RIFLE);
        Inventory_Remove(playerid, item, 1);
    }
    
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == DIALOG_INV_PREVIEW)
    {
        if (!response)
        {
            HidePlayerInventory(playerid);
            return 1;
        }
        new targetid = InventoryDialogTarget[playerid];
        if (!IsPlayerConnected(targetid)) return 1;
        new itemid = -1, seen = 0;
        for (new i = 0; i < MAX_INVENTORY; i++)
        {
            if (!InventoryData[targetid][i][invExists] || InventoryData[targetid][i][invModel] <= 0) continue;
            if (seen++ == listitem) { itemid = i; break; }
        }
        if (itemid == -1) return ShowInventoryPreview(playerid, targetid, InventoryDialogReadOnly[playerid]);
        InventoryDialogItem[playerid] = itemid;
        if (InventoryDialogReadOnly[playerid])
        {
            new detail[160];
            format(detail, sizeof(detail), "Item: %s\nQuantity: %d", InventoryData[targetid][itemid][invItem], InventoryData[targetid][itemid][invQuantity]);
            ShowPlayerDialog(playerid, DIALOG_INV_VIEWER, DIALOG_STYLE_MSGBOX, "Inventory Item", detail, "Back", "Close");
            return 1;
        }
        new actions[160];
        format(actions, sizeof(actions), "%s\nUse item\nDrop item\nGive item\nBack", InventoryData[playerid][itemid][invItem]);
        ShowPlayerDialog(playerid, DIALOG_INV_ACTION, DIALOG_STYLE_LIST, "Inventory Actions", actions, "Select", "Close");
        return 1;
    }
    if (dialogid == DIALOG_INV_ACTION)
    {
        if (!response) { HidePlayerInventory(playerid); return 1; }
        new itemid = InventoryDialogItem[playerid];
        if (itemid < 0 || itemid >= MAX_INVENTORY || !InventoryData[playerid][itemid][invExists])
            return ShowInventoryPreview(playerid, playerid, false);
        if (listitem == 0)
        {
            new detail[160];
            format(detail, sizeof(detail), "Item: %s\nQuantity: %d", InventoryData[playerid][itemid][invItem], InventoryData[playerid][itemid][invQuantity]);
            ShowPlayerDialog(playerid, DIALOG_INV_VIEWER, DIALOG_STYLE_MSGBOX, "Inventory Item", detail, "Back", "Close");
            return 1;
        }
        if (listitem == 1)
        {
            if (IsWeaponModel(InventoryData[playerid][itemid][invModel]) && PlayerInfo[playerid][pHoldWeapon])
                return SendClientMessage(playerid, COLOR_SYNTAX, "You are already using a weapon.");
            OnPlayerUseItem(playerid, InventoryData[playerid][itemid][invItem], itemid, InventoryData[playerid][itemid][invQuantity]);
            if (InventoryData[playerid][itemid][invExists]) return ShowInventoryPreview(playerid, playerid, false);
            HidePlayerInventory(playerid);
            return 1;
        }
        if (listitem == 2)
        {
            InventoryPendingAction[playerid] = 1;
            if (IsWeaponModel(InventoryData[playerid][itemid][invModel]) || CompareStrings("Phone", InventoryData[playerid][itemid][invItem]))
            {
                DropPlayerItem(playerid, itemid, InventoryData[playerid][itemid][invQuantity]);
                return ShowInventoryPreview(playerid, playerid, false);
            }
            return ShowInventoryAmount(playerid);
        }
        if (listitem == 3)
        {
            if (GetNearbyPlayer(playerid, 5.0) == -1)
                return SendClientMessage(playerid, COLOR_SYNTAX, "There is no player nearby.");
            InventoryPendingAction[playerid] = 2;
            if (IsWeaponModel(InventoryData[playerid][itemid][invModel]))
            {
                new targetid = GetNearbyPlayer(playerid, 5.0);
                Inventory_Add(targetid, InventoryData[playerid][itemid][invItem], InventoryData[playerid][itemid][invModel], InventoryData[playerid][itemid][invQuantity]);
                Inventory_RemoveEx(playerid, itemid, InventoryData[playerid][itemid][invQuantity]);
                return ShowInventoryPreview(playerid, playerid, false);
            }
            return ShowInventoryAmount(playerid);
        }
        return ShowInventoryPreview(playerid, playerid, false);
    }
    if (dialogid == DIALOG_INV_VIEWER)
    {
        if (response) return ShowInventoryPreview(playerid, InventoryDialogTarget[playerid], InventoryDialogReadOnly[playerid]);
        HidePlayerInventory(playerid);
        return 1;
    }
    if (dialogid == DIALOG_INV_AMOUNT)
    {
        if (!response)
        {
            InventoryPendingAction[playerid] = 0;
            return ShowInventoryPreview(playerid, playerid, false);
        }
        if (isnull(inputtext) || !IsNumeric(inputtext) || strval(inputtext) < 1)
            return ShowInventoryAmount(playerid);
        new itemid = InventoryDialogItem[playerid];
        new amount = strval(inputtext);
        if (itemid < 0 || itemid >= MAX_INVENTORY || !InventoryData[playerid][itemid][invExists]) return 1;
        if (amount > InventoryData[playerid][itemid][invQuantity])
            return SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have that quantity.");
        if (InventoryPendingAction[playerid] == 1)
        {
            DropPlayerItem(playerid, itemid, amount);
        }
        else if (InventoryPendingAction[playerid] == 2)
        {
            new targetid = GetNearbyPlayer(playerid, 5.0);
            if (targetid == -1) return SendClientMessage(playerid, COLOR_SYNTAX, "There is no player nearby.");
            Inventory_Add(targetid, InventoryData[playerid][itemid][invItem], InventoryData[playerid][itemid][invModel], amount);
            Inventory_RemoveEx(playerid, itemid, amount);
        }
        InventoryPendingAction[playerid] = 0;
        return ShowInventoryPreview(playerid, playerid, false);
    }
    return 0;
}

stock ShowInventoryAmount(playerid)
{
    new dialog[128];
    format(dialog, sizeof(dialog), "Please input or specify the amount that you want to drop or give:");
    
    ShowPlayerDialog(playerid, DIALOG_INV_AMOUNT, DIALOG_STYLE_INPUT, "Inventory Amount", dialog, "Confirm", "Close");
    return 1;
}

stock StackItems(playerid, item1, item2)
{
    if (item1 < 0 || item1 >= MAX_INVENTORY || item2 < 0 || item2 >= MAX_INVENTORY) return 0;
    if (!InventoryData[playerid][item1][invExists] || !InventoryData[playerid][item2][invExists]) return 0;
    if (item1 == item2) return 0;

    InventoryData[playerid][item2][invQuantity] += InventoryData[playerid][item1][invQuantity];
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE `inventory` SET `invQuantity` = %d WHERE `ownerID` = %d AND `invID` = %d", InventoryData[playerid][item2][invQuantity], PlayerInfo[playerid][pID], InventoryData[playerid][item2][invID]);
    mysql_tquery(connectionID, queryBuffer);
    Inventory_RemoveEx(playerid, item1, -1);
    return 1;
}

stock MoveItemToSelectedSlot(playerid, item1, item2)
{
    new string[160];
    new item1Model, item1Quantity, item1ID, item1Name[128];

    if (item1 < 0 || item1 >= MAX_INVENTORY || item2 < 0 || item2 >= MAX_INVENTORY || item1 == item2) return 0;
    if (!InventoryData[playerid][item1][invExists]) return 0;

    item1Model = InventoryData[playerid][item1][invModel];
    item1Quantity = InventoryData[playerid][item1][invQuantity];
    item1ID = InventoryData[playerid][item1][invID];
    StrCpy(item1Name, InventoryData[playerid][item1][invItem], sizeof(item1Name));

    if (!InventoryData[playerid][item2][invExists])
    {
        InventoryData[playerid][item2][invExists] = true;
        InventoryData[playerid][item2][invModel] = item1Model;
        InventoryData[playerid][item2][invQuantity] = item1Quantity;
        InventoryData[playerid][item2][invID] = item1ID;
        StrCpy(InventoryData[playerid][item2][invItem], item1Name, 128);

        InventoryData[playerid][item1][invExists] = false;
        InventoryData[playerid][item1][invModel] = 0;
        InventoryData[playerid][item1][invQuantity] = 0;
        InventoryData[playerid][item1][invID] = 0;
        InventoryData[playerid][item1][invItem][0] = '\0';

        mysql_format(connectionID, string, sizeof(string), "UPDATE `inventory` SET `slot` = %d WHERE `ownerID` = %d AND `invID` = %d", item2, PlayerInfo[playerid][pID], item1ID);
        mysql_tquery(connectionID, string);
    }
    else
    {
        new item2Model = InventoryData[playerid][item2][invModel];
        new item2Quantity = InventoryData[playerid][item2][invQuantity];
        new item2ID = InventoryData[playerid][item2][invID];
        new item2Name[128];
        StrCpy(item2Name, InventoryData[playerid][item2][invItem], sizeof(item2Name));

        InventoryData[playerid][item1][invModel] = item2Model;
        InventoryData[playerid][item1][invQuantity] = item2Quantity;
        InventoryData[playerid][item1][invID] = item2ID;
        StrCpy(InventoryData[playerid][item1][invItem], item2Name, 128);

        InventoryData[playerid][item2][invModel] = item1Model;
        InventoryData[playerid][item2][invQuantity] = item1Quantity;
        InventoryData[playerid][item2][invID] = item1ID;
        StrCpy(InventoryData[playerid][item2][invItem], item1Name, 128);

        mysql_format(connectionID, string, sizeof(string), "UPDATE `inventory` SET `slot` = CASE WHEN `invID` = %d THEN %d WHEN `invID` = %d THEN %d END WHERE `ownerID` = %d AND (`invID` = %d OR `invID` = %d)", item1ID, item2, item2ID, item1, PlayerInfo[playerid][pID], item1ID, item2ID);
        mysql_tquery(connectionID, string);
    }
    return 1;
}

stock GetNearbyPlayerID(playerid, Float:range)
{
	new closestid = -1;
	foreach(new i : Player)
	{
		if(IsPlayerInRangeOfPlayer(i, playerid, range))
		{
		    if(PlayerInfo[i][pInjured] == 1)
		    {
				if(i == playerid) {
					closestid = -1;
					return closestid;
				} 
			    closestid = i;
			}
		}
	}
	return closestid;
}

stock GetNearbyPlayer(playerid, Float:range)
{
	new closestid = -1;
	foreach(new i : Player)
	{
		if(IsPlayerInRangeOfPlayer(i, playerid, range))
		{
			if(i == playerid) {
				closestid = -1;
				return closestid;
			} 
			closestid = i;
		}
	}
	return closestid;
}

forward OnInventoryAdd(playerid, itemid);
public OnInventoryAdd(playerid, itemid)
{
	InventoryData[playerid][itemid][invID] = cache_insert_id();
	return 1;
}

stock ShowInventoryPreview(playerid, targetid = INVALID_PLAYER_ID, bool:readOnly = false)
{
	new dialogList[2048], caption[96], count = 0;

	if (targetid == INVALID_PLAYER_ID) targetid = playerid;
	if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not connected.");

	dialogList[0] = '\0';
	for (new i = 0; i < MAX_INVENTORY; i++)
	{
		if (!InventoryData[targetid][i][invExists] || InventoryData[targetid][i][invModel] <= 0) continue;
		format(dialogList, sizeof(dialogList), "%s%d\t%s~n~~y~(%d)\n", dialogList, InventoryData[targetid][i][invModel], InventoryData[targetid][i][invItem], InventoryData[targetid][i][invQuantity]);
		count++;
	}

	if (count == 0) return SendClientMessage(playerid, COLOR_GREY, "There are no items to display.");

	InventoryDialogTarget[playerid] = targetid;
	InventoryDialogReadOnly[playerid] = readOnly;
	InventoryDialogItem[playerid] = -1;
	ShowingInventory[playerid] = 1;
	format(caption, sizeof(caption), "%s's Inventory (%d/%d)", ReturnPlayerRPName(targetid), count, MAX_INVENTORY);
	ShowPlayerDialog(playerid, DIALOG_INV_PREVIEW, DIALOG_STYLE_PREVIEW_MODEL, caption, dialogList, "Select", "Close");
	return 1;
}

stock ShowInventoryItems(playerid)
{
	return ShowInventoryPreview(playerid, playerid, false);
}

stock HidePlayerInventory(playerid)
{
	selectedItem[playerid] = -1;
	ShowingInventory[playerid] = 0;
	if (LootMode[playerid] != -1) LootMode[playerid] = -1;
	if (PickupMode[playerid]) PickupMode[playerid] = 0;
	if (PlayerIsInStore[playerid] != -1) PlayerIsInStore[playerid] = -1;
	return 1;
}

CMD:inv(playerid, params[])
{
	if (ShowingInventory[playerid])
	{
		HidePlayerInventory(playerid);
		return 1;
	}
	return ShowInventoryPreview(playerid, playerid, false);
}

CMD:checkinv(playerid, params[])
{
	new targetid;
	if (PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	if (sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /checkinv [playerid/name]");
	if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_SYNTAX, "That player is not connected.");
	return ShowInventoryPreview(playerid, targetid, true);
}

CMD:setitem(playerid, params[])
{
    new userid, item[128], amount;

    if(PlayerInfo[playerid][pAdmin] < 4) 
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
    }

    if (sscanf(params, "uds[128]", userid, amount, item)) return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /setitem [playerid/name] [amount] [item name]");

    for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if (!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
    {
        Inventory_Set(userid, g_aInventoryItems[i][e_InventoryItem], g_aInventoryItems[i][e_InventoryModel], amount);
        
        new string[144];
        format(string, sizeof(string), "You have set %s's \"%s\" to %d.", ReturnPlayerRPName(userid), item, amount);
        return SendClientMessage(playerid, COLOR_SYNTAX, string);
    }
    SendClientMessage(playerid, COLOR_SYNTAX, "ERROR: Invalid item name (use /itemlist for a list).");
    return 1;
}
