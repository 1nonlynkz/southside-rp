#include <YSI_Coding\y_hooks>

DropPlayerItem(playerid, itemid, quantity = 1)
{
	if (itemid == -1 || !InventoryData[playerid][itemid][invExists])
	    return 0;

    new
		Float:x,
  		Float:y,
    	Float:z,
		Float:angle,
		string[128];

	StrCpy(string, InventoryData[playerid][itemid][invItem]);

	// if (InventoryData[playerid][itemid][invQuantity] < 2)
	// {
	// 	if (!strcmp(string, "Colt 45") && PlayerInfo[playerid][pHoldWeapon] == 22)
	// 		HoldWeapon(playerid, 0);

	// 	else if (!strcmp(string, "Desert Eagle") && PlayerInfo[playerid][pHoldWeapon] == 24)
	// 		HoldWeapon(playerid, 0);

	// 	else if (!strcmp(string, "Shotgun") && PlayerInfo[playerid][pHoldWeapon] == 25)
	// 		HoldWeapon(playerid, 0);

	// 	else if (!strcmp(string, "Micro SMG") && PlayerInfo[playerid][pHoldWeapon] == 28)
	// 		HoldWeapon(playerid, 0);

	// 	else if (!strcmp(string, "MP5") && PlayerInfo[playerid][pHoldWeapon] == 29)
	// 		HoldWeapon(playerid, 0);

	// 	else if (!strcmp(string, "Tec-9") && PlayerInfo[playerid][pHoldWeapon] == 32)
	// 		HoldWeapon(playerid, 0);

	// 	else if (!strcmp(string, "AK-47") && PlayerInfo[playerid][pHoldWeapon] == 30)
	// 		HoldWeapon(playerid, 0);

	//  	else if (!strcmp(string, "Rifle") && PlayerInfo[playerid][pHoldWeapon] == 33)
	// 	 	HoldWeapon(playerid, 0);

	// 	else if (!strcmp(string, "Sniper") && PlayerInfo[playerid][pHoldWeapon] == 34)
	// 		HoldWeapon(playerid, 0);
	// }

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	if(CompareStrings("Phone", InventoryData[playerid][itemid][invItem])) {
		DropItem(InventoryData[playerid][itemid][invItem], ReturnPlayerRPName(playerid), InventoryData[playerid][itemid][invModel], InventoryData[playerid][itemid][invQuantity], x, y, z - 0.9, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	} else {
		DropItem(InventoryData[playerid][itemid][invItem], ReturnPlayerRPName(playerid), InventoryData[playerid][itemid][invModel], quantity, x, y, z - 0.9, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	}
	
 	Inventory_RemoveEx(playerid, itemid, quantity);

	ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, false, false, false, false, 0, SYNC_ALL);
 	SendNearbyMessage(playerid, COLOR_PLUM, 20.0, "** %s has dropped a %s to the ground.", ReturnPlayerRPName(playerid), InventoryData[playerid][itemid][invItem]);
	return 1;
}

DropItem(item[], player[], model, quantity, Float:x, Float:y, Float:z, interior, world, weaponid = 0, ammo = 0)
{
	new query[300];

	for (new i = 0; i != MAX_DROPPED_ITEMS; i ++) if (!DroppedItems[i][droppedModel])
	{
	    format(DroppedItems[i][droppedItem], 32, item);
	    format(DroppedItems[i][droppedPlayer], 24, player);

		DroppedItems[i][droppedModel] = model;
		DroppedItems[i][droppedQuantity] = quantity;
		DroppedItems[i][droppedWeapon] = weaponid;
  		DroppedItems[i][droppedAmmo] = ammo;
		DroppedItems[i][droppedPos][0] = x;
		DroppedItems[i][droppedPos][1] = y;
		DroppedItems[i][droppedPos][2] = z;

		DroppedItems[i][droppedInt] = interior;
		DroppedItems[i][droppedWorld] = world;

		if (IsWeaponModel(model)) {
			DroppedItems[i][droppedObject] = CreateDynamicObject(model, x, y, z, 93.7, 120.0, 120.0, world, interior);
		} else {
			DroppedItems[i][droppedObject] = CreateDynamicObject(model, x, y, z, 0.0, 0.0, 0.0, world, interior);
		}
 		DroppedItems[i][droppedText3D] = CreateDynamic3DTextLabel(item, COLOR_WHITE, x, y, z, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, world, interior);

	 	format(query, sizeof(query), "INSERT INTO `dropped` (`itemName`, `itemPlayer`, `itemModel`, `itemQuantity`, `itemWeapon`, `itemAmmo`, `itemX`, `itemY`, `itemZ`, `itemInt`, `itemWorld`) VALUES('%s', '%s', '%d', '%d', '%d', '%d', '%.4f', '%.4f', '%.4f', '%d', '%d')", item, player, model, quantity, weaponid, ammo, x, y, z, interior, world);
		mysql_tquery(connectionID, query, "OnDroppedItem", "d", i);
		return i;
	}
	return -1;
}

stock Item_Nearest(playerid)
{
    for (new i = 0; i != MAX_DROPPED_ITEMS; i ++) if (DroppedItems[i][droppedModel] && IsPlayerInRangeOfPoint(playerid, 1.5, DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2]))
	{
	    if (GetPlayerInterior(playerid) == DroppedItems[i][droppedInt] && GetPlayerVirtualWorld(playerid) == DroppedItems[i][droppedWorld])
	        return i;
	}
	return -1;
}

stock Item_Delete(itemid)
{
    if (itemid != -1 && DroppedItems[itemid][droppedModel])
	{
        DroppedItems[itemid][droppedModel] = 0;
		DroppedItems[itemid][droppedQuantity] = 0;
	    DroppedItems[itemid][droppedPos][0] = 0.0;
	    DroppedItems[itemid][droppedPos][1] = 0.0;
	    DroppedItems[itemid][droppedPos][2] = 0.0;
	    DroppedItems[itemid][droppedInt] = 0;
	    DroppedItems[itemid][droppedWorld] = 0;

	    DestroyDynamicObject(DroppedItems[itemid][droppedObject]);
	    DestroyDynamic3DTextLabel(DroppedItems[itemid][droppedText3D]);

	    mysql_pquery(connectionID, "DELETE FROM `dropped` WHERE `ID` = '%d'", DroppedItems[itemid][droppedID]);
	}
	return 1;
}

stock PickupItem(playerid, itemid)
{
    if (itemid != -1 && DroppedItems[itemid][droppedModel])
    {
        new id = Inventory_Add(playerid, DroppedItems[itemid][droppedItem], DroppedItems[itemid][droppedModel], DroppedItems[itemid][droppedQuantity]);
        
        if (id == -1)
            return SendMessage(playerid, MESSAGE_ERROR, "Inventory slot is currently full.");

        Item_Delete(itemid);
    }
    return 1;
}

hook OnGameModeInit()
{
    mysql_tquery(connectionID, "SELECT * FROM `dropped`", "LoadDroppedItems", "");

    return 1;
}

forward LoadDroppedItems();
public LoadDroppedItems()
{
    new num_rows, num_fields;
    cache_get_data(num_rows, num_fields); // R39 way para makuha ang bilang ng rows
    
    if(!num_rows) return print("MySQL Report: No Dropped Item exist to load in database.");

    for (new i = 0; i < num_rows; i ++) if (i < MAX_DROPPED_ITEMS)
    {
        // R39 Integers (Gamitan ng '=')
        DroppedItems[i][droppedID] = cache_get_field_content_int(i, "ID");
        DroppedItems[i][droppedModel] = cache_get_field_content_int(i, "itemModel");
        DroppedItems[i][droppedQuantity] = cache_get_field_content_int(i, "itemQuantity");
        DroppedItems[i][droppedWeapon] = cache_get_field_content_int(i, "itemWeapon");
        DroppedItems[i][droppedAmmo] = cache_get_field_content_int(i, "itemAmmo");
        DroppedItems[i][droppedInt] = cache_get_field_content_int(i, "itemInt");
        DroppedItems[i][droppedWorld] = cache_get_field_content_int(i, "itemWorld");

        // R39 Floats (Gamitan ng '=')
        DroppedItems[i][droppedPos][0] = cache_get_field_content_float(i, "itemX");
        DroppedItems[i][droppedPos][1] = cache_get_field_content_float(i, "itemY");
        DroppedItems[i][droppedPos][2] = cache_get_field_content_float(i, "itemZ");

        // R39 Strings (Ipasa ang array at size. Pinalitan ko ng 32 at 24 ang size, i-adjust mo kung iba sa enum mo)
        cache_get_field_content(i, "itemName", DroppedItems[i][droppedItem], _, 32);
        cache_get_field_content(i, "itemPlayer", DroppedItems[i][droppedPlayer], _, 24);

        // Paglikha ng Object depende kung armas o hindi
        if (IsWeaponModel(DroppedItems[i][droppedModel])) {
            DroppedItems[i][droppedObject] = CreateDynamicObject(DroppedItems[i][droppedModel], DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2], 93.7, 120.0, 120.0, DroppedItems[i][droppedWorld], DroppedItems[i][droppedInt]);
        } else {
            DroppedItems[i][droppedObject] = CreateDynamicObject(DroppedItems[i][droppedModel], DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2], 0.0, 0.0, 0.0, DroppedItems[i][droppedWorld], DroppedItems[i][droppedInt]);
        }
        
        // Paglikha ng 3D Text Label
        DroppedItems[i][droppedText3D] = CreateDynamic3DTextLabel(DroppedItems[i][droppedItem], COLOR_WHITE, DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, DroppedItems[i][droppedWorld], DroppedItems[i][droppedInt]);
    }
    printf("MySQL Report: Dropped Items Loaded. [%d/%d]", num_rows, MAX_DROPPED_ITEMS);
    return 1;
}

forward OnDroppedItem(itemid);
public OnDroppedItem(itemid)
{
	if (itemid == -1 || !DroppedItems[itemid][droppedModel])
	    return 0;

	DroppedItems[itemid][droppedID] = cache_insert_id();
	return 1;
}