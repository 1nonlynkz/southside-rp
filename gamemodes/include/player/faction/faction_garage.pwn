#include <YSI_Coding\y_hooks>

#define MAX_FACTION_GARAGES          100
#define MAX_GARAGE_VEHICLES          50

#define FGARAGE_ACTION_SPAWN          (1)
#define FGARAGE_ACTION_STORE          (2)
#define FGARAGE_ACTION_EDIT           (3)
#define FGARAGE_ACTION_ADD            (4)
#define FGARAGE_ACTION_REMOVE         (5)
#define FGARAGE_ACTION_FORCE_SPAWN    (6)
#define FGARAGE_ACTION_RESET_STOCK    (7)

new GarageDialogSlot[MAX_PLAYERS][MAX_GARAGE_VEHICLES];
new g_FactionGarageMainAction[MAX_PLAYERS][8];

enum E_FACTION_GARAGE_DATA {
    fgID,
    fgExists,
    fgFaction,
    Float:fgPosX,
    Float:fgPosY,
    Float:fgPosZ,
    Float:fgPosA,
    fgInterior,
    fgWorld,
    Float:fgSpawnX,
    Float:fgSpawnY,
    Float:fgSpawnZ,
    Float:fgSpawnA,
    Text3D:fgLabel,
    fgPickup
}
new FactionGarages[MAX_FACTION_GARAGES][E_FACTION_GARAGE_DATA];

enum E_GARAGE_VEHICLE_DATA {
    gvID,
    gvExists,
    gvModel,
    gvName[64],
    gvStockCurrent,
    gvStockMax,
    gvMinRank
}
new GarageVehicles[MAX_FACTION_GARAGES][MAX_GARAGE_VEHICLES][E_GARAGE_VEHICLE_DATA];

forward LoadFactionGarages();
public LoadFactionGarages()
{
    new rows = cache_get_row_count(connectionID);
    for(new i = 0; i < rows && i < MAX_FACTION_GARAGES; i++)
    {
        FactionGarages[i][fgID] = cache_get_field_content_int(i, "id");
        FactionGarages[i][fgFaction] = cache_get_field_content_int(i, "factionid");
        FactionGarages[i][fgPosX] = cache_get_field_content_float(i, "pos_x");
        FactionGarages[i][fgPosY] = cache_get_field_content_float(i, "pos_y");
        FactionGarages[i][fgPosZ] = cache_get_field_content_float(i, "pos_z");
        FactionGarages[i][fgPosA] = cache_get_field_content_float(i, "pos_a");
        FactionGarages[i][fgInterior] = cache_get_field_content_int(i, "interior");
        FactionGarages[i][fgWorld] = cache_get_field_content_int(i, "world");
        FactionGarages[i][fgSpawnX] = cache_get_field_content_float(i, "spawn_x");
        FactionGarages[i][fgSpawnY] = cache_get_field_content_float(i, "spawn_y");
        FactionGarages[i][fgSpawnZ] = cache_get_field_content_float(i, "spawn_z");
        FactionGarages[i][fgSpawnA] = cache_get_field_content_float(i, "spawn_a");
        FactionGarages[i][fgExists] = 1;
        FactionGarages[i][fgLabel] = Text3D:INVALID_3DTEXT_ID;
        FactionGarages[i][fgPickup] = -1;

        ReloadFactionGarageUI(i);
        new query[128];
        mysql_format(connectionID, query, sizeof(query), "SELECT * FROM faction_garage_vehicles WHERE garage_id = %d", FactionGarages[i][fgID]);
        mysql_tquery(connectionID, query, "LoadGarageVehicles", "i", i);
    }
    printf("[Faction Garage] Loaded %d garages from database.", rows);
    return 1;
}

forward LoadGarageVehicles(garage_idx);
public LoadGarageVehicles(garage_idx)
{
    if(garage_idx < 0 || garage_idx >= MAX_FACTION_GARAGES || !FactionGarages[garage_idx][fgExists])
        return 0;

    new rows = cache_get_row_count(connectionID);
    for(new i = 0; i < rows && i < MAX_GARAGE_VEHICLES; i++)
    {
        GarageVehicles[garage_idx][i][gvID] = cache_get_field_content_int(i, "id");
        GarageVehicles[garage_idx][i][gvModel] = cache_get_field_content_int(i, "modelid");
        cache_get_field_content(i, "name", GarageVehicles[garage_idx][i][gvName], connectionID, 64);
        GarageVehicles[garage_idx][i][gvStockCurrent] = cache_get_field_content_int(i, "stock_current");
        GarageVehicles[garage_idx][i][gvStockMax] = cache_get_field_content_int(i, "stock_max");
        GarageVehicles[garage_idx][i][gvMinRank] = cache_get_field_content_int(i, "min_rank");
        GarageVehicles[garage_idx][i][gvExists] = 1;
    }
    return 1;
}

stock ReloadFactionGarageUI(garage_idx)
{
    if(!FactionGarages[garage_idx][fgExists])
        return 0;

    if(FactionGarages[garage_idx][fgLabel] != Text3D:INVALID_3DTEXT_ID)
    {
        DestroyDynamic3DTextLabel(FactionGarages[garage_idx][fgLabel]);
        FactionGarages[garage_idx][fgLabel] = Text3D:INVALID_3DTEXT_ID;
    }
    if(FactionGarages[garage_idx][fgPickup] != -1)
    {
        DestroyDynamicPickup(FactionGarages[garage_idx][fgPickup]);
        FactionGarages[garage_idx][fgPickup] = -1;
    }

    new factionid = FactionGarages[garage_idx][fgFaction];
    new string[256];
    format(string, sizeof(string), "{33CCFF}%s Garage\n{FFFFFF}Press {00AA00}Y{FFFFFF} to open menu or store vehicle.\n{AFAFAF}Garage ID: %d", FactionInfo[factionid][fName], FactionGarages[garage_idx][fgID]);
    FactionGarages[garage_idx][fgLabel] = CreateDynamic3DTextLabel(string, COLOR_WHITE, FactionGarages[garage_idx][fgPosX], FactionGarages[garage_idx][fgPosY], FactionGarages[garage_idx][fgPosZ], 10.0, .worldid = FactionGarages[garage_idx][fgWorld], .interiorid = FactionGarages[garage_idx][fgInterior]);
    FactionGarages[garage_idx][fgPickup] = CreateDynamicPickup(1239, 1, FactionGarages[garage_idx][fgPosX], FactionGarages[garage_idx][fgPosY], FactionGarages[garage_idx][fgPosZ], .worldid = FactionGarages[garage_idx][fgWorld], .interiorid = FactionGarages[garage_idx][fgInterior]);
    return 1;
}

stock GetNearbyFactionGarage(playerid)
{
    for(new i = 0; i < MAX_FACTION_GARAGES; i++)
    {
        if(FactionGarages[i][fgExists])
        {
            if(IsPlayerInRangeOfPoint(playerid, 3.0, FactionGarages[i][fgPosX], FactionGarages[i][fgPosY], FactionGarages[i][fgPosZ]))
            {
                if(GetPlayerVirtualWorld(playerid) == FactionGarages[i][fgWorld] && GetPlayerInterior(playerid) == FactionGarages[i][fgInterior])
                {
                    return i;
                }
            }
        }
    }
    return -1;
}

stock StoreFactionVehicle(playerid)
{
    if(PlayerInfo[playerid][pFaction] == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not in any faction.");
    }

    new vehicleid = GetPlayerVehicleID(playerid);
    if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You must be driving a faction vehicle to store it.");
    }

    new factionid = PlayerInfo[playerid][pFaction];
    new factiontype = FactionInfo[factionid][fType];
    if(VehicleInfo[vehicleid][vFactionType] != factiontype)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle is not your faction's vehicle.");
    }

    new garage_idx = GetNearbyFactionGarage(playerid);
    if(garage_idx == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not near any faction garage.");
    }
    if(FactionGarages[garage_idx][fgFaction] != factionid)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This garage does not belong to your faction.");
    }

    new modelid = GetVehicleModel(vehicleid);
    new found_idx = -1;
    for(new i = 0; i < MAX_GARAGE_VEHICLES; i++)
    {
        if(GarageVehicles[garage_idx][i][gvExists] && GarageVehicles[garage_idx][i][gvModel] == modelid)
        {
            found_idx = i;
            break;
        }
    }

    if(found_idx == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This vehicle model is not configured in this garage.");
    }

    if(GarageVehicles[garage_idx][found_idx][gvStockCurrent] >= GarageVehicles[garage_idx][found_idx][gvStockMax])
    {
        return SendClientMessage(playerid, COLOR_GREY, "The garage is already full for this vehicle.");
    }

    RemovePlayerFromVehicle(playerid);
    DestroyVehicle(vehicleid);

    GarageVehicles[garage_idx][found_idx][gvStockCurrent]++;

    new query[128];
    mysql_format(connectionID, query, sizeof(query), "UPDATE faction_garage_vehicles SET stock_current = %d WHERE id = %d", GarageVehicles[garage_idx][found_idx][gvStockCurrent], GarageVehicles[garage_idx][found_idx][gvID]);
    mysql_tquery(connectionID, query);

    SendClientMessageEx(playerid, COLOR_GREEN, "You stored %s back into %s Garage. Stock: %d/%d.", GarageVehicles[garage_idx][found_idx][gvName], FactionInfo[factionid][fName], GarageVehicles[garage_idx][found_idx][gvStockCurrent], GarageVehicles[garage_idx][found_idx][gvStockMax]);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
    if((newkeys & KEY_YES) && !(oldkeys & KEY_YES))
    {
        new garage_idx = GetNearbyFactionGarage(playerid);
        if(garage_idx == -1) return 1;

        if(PlayerInfo[playerid][pFaction] != -1 && FactionGarages[garage_idx][fgFaction] == PlayerInfo[playerid][pFaction])
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            if(vehicleid && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && VehicleInfo[vehicleid][vFactionType] == FactionInfo[PlayerInfo[playerid][pFaction]][fType])
            {
                return OpenFactionGarageMenu(playerid, garage_idx, false);
            }

            OpenFactionGarageMenu(playerid, garage_idx, false);
            return 1;
        }
        if(PlayerInfo[playerid][pAdmin] >= 3)
        {
            OpenFactionGarageMenu(playerid, garage_idx, true);
            return 1;
        }
    }
    return 1;
}

stock OpenFactionGarageMenu(playerid, garage_idx, bool:admin_only)
{
    new caption[64], options[512];
    new actionIndex = 0;
    new factionid = FactionGarages[garage_idx][fgFaction];

    format(caption, sizeof(caption), "{33CCFF}%s Garage - Main Menu", FactionInfo[factionid][fName]);

    format(options, sizeof(options), "{FFFFFF}Option\t{FFFFFF}Description");

    if(admin_only)
    {
        strcat(options, "\nForce Spawn\tForce spawn all faction vehicles");
        g_FactionGarageMainAction[playerid][actionIndex++] = FGARAGE_ACTION_FORCE_SPAWN;

        strcat(options, "\nReset Stocks\tReset garage vehicle stock limits");
        g_FactionGarageMainAction[playerid][actionIndex++] = FGARAGE_ACTION_RESET_STOCK;
    }
    else
    {
        strcat(options, "\nDraw/Spawn Vehicle\tSpawn a vehicle from the garage");
        g_FactionGarageMainAction[playerid][actionIndex++] = FGARAGE_ACTION_SPAWN;

        strcat(options, "\nStore Current Vehicle\tPark your current vehicle back");
        g_FactionGarageMainAction[playerid][actionIndex++] = FGARAGE_ACTION_STORE;

        if(PlayerInfo[playerid][pFactionRank] >= 5)
        {
            strcat(options, "\nEdit Vehicle\tModify vehicle settings");
            strcat(options, "\nAdd Vehicle\tAdd a new vehicle to the fleet");
            strcat(options, "\nRemove Vehicle\tDelete a vehicle from the garage");

            g_FactionGarageMainAction[playerid][actionIndex++] = FGARAGE_ACTION_EDIT;
            g_FactionGarageMainAction[playerid][actionIndex++] = FGARAGE_ACTION_ADD;
            g_FactionGarageMainAction[playerid][actionIndex++] = FGARAGE_ACTION_REMOVE;
        }

        if(PlayerInfo[playerid][pAdmin] >= 3)
        {
            strcat(options, "\nForce Spawn\tForce spawn all faction vehicles");
            strcat(options, "\nReset Stocks\tReset garage vehicle stock limits");

            g_FactionGarageMainAction[playerid][actionIndex++] = FGARAGE_ACTION_FORCE_SPAWN;
            g_FactionGarageMainAction[playerid][actionIndex++] = FGARAGE_ACTION_RESET_STOCK;
        }
    }

    if(actionIndex < 0) actionIndex = 0;
    SetPVarInt(playerid, "FGActionCount", actionIndex);
    SetPVarInt(playerid, "ActiveFactionGarage", garage_idx);

    ShowPlayerDialog(playerid, DIALOG_FGARAGE_MAIN, DIALOG_STYLE_TABLIST_HEADERS, caption, options, "Select", "Cancel");
    return 1;
}

stock ShowGarageSelectMenu(playerid, garage_idx, action)
{
    new caption[64], dialog_list[2048], count = 0;
    new factionid = FactionGarages[garage_idx][fgFaction];

    format(caption, sizeof(caption), "%s - Select Vehicle", FactionInfo[factionid][fName]);

    for(new i = 0; i < MAX_GARAGE_VEHICLES; i++)
    {
        if(GarageVehicles[garage_idx][i][gvExists])
        {
            format(dialog_list, sizeof(dialog_list), "%s%d\t%s~n~~y~Stock: %d/%d (Rank %d+)\n", dialog_list, GarageVehicles[garage_idx][i][gvModel], GarageVehicles[garage_idx][i][gvName], GarageVehicles[garage_idx][i][gvStockCurrent], GarageVehicles[garage_idx][i][gvStockMax], GarageVehicles[garage_idx][i][gvMinRank]);
            GarageDialogSlot[playerid][count] = i;
            count++;
        }
    }

    if(count == 0)
        return SendClientMessage(playerid, COLOR_GREY, "No vehicles configured in this garage.");

    SetPVarInt(playerid, "ActiveFactionGarage", garage_idx);
    SetPVarInt(playerid, "ActiveFactionGarageAction", action);
    ShowPlayerDialog(playerid, DIALOG_FGARAGE_SELECT, DIALOG_STYLE_PREVIEW_MODEL, caption, dialog_list, "Select", "Back");
    return 1;
}

stock ShowGarageSpawnMenu(playerid, garage_idx, bool:is_admin_force)
{
    new caption[64], dialog_list[2048], count = 0;
    new factionid = FactionGarages[garage_idx][fgFaction];

    format(caption, sizeof(caption), "%s - Spawn Vehicle", FactionInfo[factionid][fName]);

    for(new i = 0; i < MAX_GARAGE_VEHICLES; i++)
    {
        if(GarageVehicles[garage_idx][i][gvExists])
        {
            format(dialog_list, sizeof(dialog_list), "%s%d\t%s~n~~y~Stock: %d/%d (Rank %d+)\n", dialog_list, GarageVehicles[garage_idx][i][gvModel], GarageVehicles[garage_idx][i][gvName], GarageVehicles[garage_idx][i][gvStockCurrent], GarageVehicles[garage_idx][i][gvStockMax], GarageVehicles[garage_idx][i][gvMinRank]);
            GarageDialogSlot[playerid][count] = i;
            count++;
        }
    }

    if(count == 0)
        return SendClientMessage(playerid, COLOR_GREY, "No vehicles configured in this garage.");

    SetPVarInt(playerid, "ActiveFactionGarage", garage_idx);
    SetPVarInt(playerid, "AdminForceSpawn", is_admin_force ? 1 : 0);
    ShowPlayerDialog(playerid, DIALOG_FGARAGE_SPAWN, DIALOG_STYLE_PREVIEW_MODEL, caption, dialog_list, "Spawn", "Back");
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_FGARAGE_MAIN)
    {
        if(!response)
        {
            DeletePVar(playerid, "ActiveFactionGarage");
            return 1;
        }

        new garage_idx = GetPVarInt(playerid, "ActiveFactionGarage");
        if(garage_idx < 0 || garage_idx >= MAX_FACTION_GARAGES || !FactionGarages[garage_idx][fgExists])
        {
            DeletePVar(playerid, "ActiveFactionGarage");
            return SendClientMessage(playerid, COLOR_GREY, "Error: Invalid garage session.");
        }

        new action = g_FactionGarageMainAction[playerid][listitem];
        DeletePVar(playerid, "ActiveFactionGarage");

        switch(action)
        {
            case FGARAGE_ACTION_SPAWN:
            {
                ShowGarageSpawnMenu(playerid, garage_idx, false);
            }
            case FGARAGE_ACTION_STORE:
            {
                StoreFactionVehicle(playerid);
            }
            case FGARAGE_ACTION_EDIT:
            {
                ShowGarageSelectMenu(playerid, garage_idx, FGARAGE_ACTION_EDIT);
            }
            case FGARAGE_ACTION_ADD:
            {
                SetPVarInt(playerid, "ActiveFactionGarage", garage_idx);
                ShowPlayerDialog(playerid, DIALOG_FGARAGE_ADD, DIALOG_STYLE_INPUT, "Add Garage Vehicle", "Enter: modelid max_stock min_rank custom name", "Add", "Cancel");
            }
            case FGARAGE_ACTION_REMOVE:
            {
                ShowGarageSelectMenu(playerid, garage_idx, FGARAGE_ACTION_REMOVE);
            }
            case FGARAGE_ACTION_FORCE_SPAWN:
            {
                ShowGarageSpawnMenu(playerid, garage_idx, true);
            }
            case FGARAGE_ACTION_RESET_STOCK:
            {
                for(new i = 0; i < MAX_GARAGE_VEHICLES; i++)
                {
                    if(GarageVehicles[garage_idx][i][gvExists])
                    {
                        GarageVehicles[garage_idx][i][gvStockCurrent] = GarageVehicles[garage_idx][i][gvStockMax];
                        new query[128];
                        mysql_format(connectionID, query, sizeof(query), "UPDATE faction_garage_vehicles SET stock_current = %d WHERE id = %d", GarageVehicles[garage_idx][i][gvStockMax], GarageVehicles[garage_idx][i][gvID]);
                        mysql_tquery(connectionID, query);
                    }
                }
                SendClientMessage(playerid, COLOR_GREEN, "* Admin: All vehicle stocks in this garage have been fully reset.");

            }
            default:
            {
                SendClientMessage(playerid, COLOR_GREY, "Error: Unknown garage action.");

            }
        }

        return 1;
    }

    if(dialogid == DIALOG_FGARAGE_SELECT)
    {
        if(!response)
        {
            DeletePVar(playerid, "ActiveFactionGarage");
            DeletePVar(playerid, "ActiveFactionGarageAction");
            return 1;
        }

        new garage_idx = GetPVarInt(playerid, "ActiveFactionGarage");
        new action = GetPVarInt(playerid, "ActiveFactionGarageAction");
        if(garage_idx < 0 || garage_idx >= MAX_FACTION_GARAGES || !FactionGarages[garage_idx][fgExists])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid faction garage.");
        }

        new found_idx = GarageDialogSlot[playerid][listitem];

        switch(action)
        {
            case FGARAGE_ACTION_EDIT:
            {
                SetPVarInt(playerid, "ActiveFactionGarageVehicle", found_idx);
                new title[64];
                format(title, sizeof(title), "Edit %s", GarageVehicles[garage_idx][found_idx][gvName]);
                ShowPlayerDialog(playerid, DIALOG_FGARAGE_EDIT, DIALOG_STYLE_INPUT, title, "Enter: current_stock max_stock min_rank", "Save", "Cancel");

            }
            case FGARAGE_ACTION_REMOVE:
            {
                new query[128];
                mysql_format(connectionID, query, sizeof(query), "DELETE FROM faction_garage_vehicles WHERE id = %d", GarageVehicles[garage_idx][found_idx][gvID]);
                mysql_tquery(connectionID, query);
                SendClientMessageEx(playerid, COLOR_GREEN, "* Removed %s from Garage %d.", GarageVehicles[garage_idx][found_idx][gvName], garage_idx);
                GarageVehicles[garage_idx][found_idx][gvExists] = 0;

            }
            default:
            {
                SendClientMessage(playerid, COLOR_GREY, "Error: Invalid action for selected vehicle.");

            }
        }
        return 1;
    }

    if(dialogid == DIALOG_FGARAGE_ADD)
    {
        if(!response)
        {
            DeletePVar(playerid, "ActiveFactionGarage");
            return 1;
        }

        new garage_idx = GetPVarInt(playerid, "ActiveFactionGarage");
        if(garage_idx < 0 || garage_idx >= MAX_FACTION_GARAGES || !FactionGarages[garage_idx][fgExists])
        {
            DeletePVar(playerid, "ActiveFactionGarage");
            return SendClientMessage(playerid, COLOR_GREY, "Invalid faction garage.");
        }

        new modelid, max_stock, min_rank;
        new custom_name[64];
        if(isnull(inputtext) || sscanf(inputtext, "iiiis[64]", modelid, max_stock, min_rank, custom_name))
        {
            ShowPlayerDialog(playerid, DIALOG_FGARAGE_ADD, DIALOG_STYLE_INPUT, "Add Garage Vehicle", "Invalid input. Enter: modelid max_stock min_rank custom name", "Add", "Cancel");
            return 1;
        }

        if(PlayerInfo[playerid][pAdmin] < 5 && PlayerInfo[playerid][pFactionRank] < 5)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to add vehicles to this garage.");
        }

        if(modelid < 400 || modelid > 611)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid Vehicle Model ID (400-611).");
        }

        new vehicle_slot = -1;
        for(new i = 0; i < MAX_GARAGE_VEHICLES; i++)
        {
            if(!GarageVehicles[garage_idx][i][gvExists])
            {
                vehicle_slot = i;

            }
        }

        if(vehicle_slot == -1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "This garage is full (limit is 50 vehicle types).");
        }

        GarageVehicles[garage_idx][vehicle_slot][gvModel] = modelid;
        strcpy(GarageVehicles[garage_idx][vehicle_slot][gvName], custom_name, 64);
        GarageVehicles[garage_idx][vehicle_slot][gvStockCurrent] = max_stock;
        GarageVehicles[garage_idx][vehicle_slot][gvStockMax] = max_stock;
        GarageVehicles[garage_idx][vehicle_slot][gvMinRank] = min_rank;
        GarageVehicles[garage_idx][vehicle_slot][gvExists] = 1;

        new query[256];
        mysql_format(connectionID, query, sizeof(query), "INSERT INTO faction_garage_vehicles (garage_id, modelid, name, stock_current, stock_max, min_rank) VALUES (%d, %d, '%e', %d, %d, %d)", FactionGarages[garage_idx][fgID], modelid, custom_name, max_stock, max_stock, min_rank);
        mysql_tquery(connectionID, query, "OnFactionGarageVehicleAdded", "iii", playerid, garage_idx, vehicle_slot);
        return 1;
    }

    if(dialogid == DIALOG_FGARAGE_EDIT)
    {
        if(!response)
        {
            return 1;
        }

        new garage_idx = GetPVarInt(playerid, "ActiveFactionGarage");
        new found_idx = GetPVarInt(playerid, "ActiveFactionGarageVehicle");
        if(garage_idx < 0 || garage_idx >= MAX_FACTION_GARAGES || !FactionGarages[garage_idx][fgExists])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid faction garage.");
        }

        new current_stock, max_stock, min_rank;
        if(isnull(inputtext) || sscanf(inputtext, "iii", current_stock, max_stock, min_rank))
        {
            ShowPlayerDialog(playerid, DIALOG_FGARAGE_EDIT, DIALOG_STYLE_INPUT, "Edit Vehicle", "Invalid input. Enter: current_stock max_stock min_rank", "Save", "Cancel");
            return 1;
        }

        GarageVehicles[garage_idx][found_idx][gvStockCurrent] = current_stock;
        GarageVehicles[garage_idx][found_idx][gvStockMax] = max_stock;
        GarageVehicles[garage_idx][found_idx][gvMinRank] = min_rank;

        new q[128];
        mysql_format(connectionID, q, sizeof(q), "UPDATE faction_garage_vehicles SET stock_current = %d, stock_max = %d, min_rank = %d WHERE id = %d", current_stock, max_stock, min_rank, GarageVehicles[garage_idx][found_idx][gvID]);
        mysql_tquery(connectionID, q);
        SendClientMessageEx(playerid, COLOR_GREEN, "* Updated %s in Garage %d.", GarageVehicles[garage_idx][found_idx][gvName], garage_idx);
        return 1;
    }

    if(dialogid == DIALOG_FGARAGE_SPAWN)
    {
        if(!response)
        {
            DeletePVar(playerid, "ActiveFactionGarage");
            DeletePVar(playerid, "AdminForceSpawn");
            return 1;
        }

        new garage_idx = GetPVarInt(playerid, "ActiveFactionGarage");
        new is_admin_force = GetPVarInt(playerid, "AdminForceSpawn");

        DeletePVar(playerid, "ActiveFactionGarage");
        DeletePVar(playerid, "AdminForceSpawn");

        if(garage_idx < 0 || garage_idx >= MAX_FACTION_GARAGES || !FactionGarages[garage_idx][fgExists])
            return SendClientMessage(playerid, COLOR_GREY, "Error: Invalid garage session.");

        if(!IsPlayerInRangeOfPoint(playerid, 5.0, FactionGarages[garage_idx][fgPosX], FactionGarages[garage_idx][fgPosY], FactionGarages[garage_idx][fgPosZ]))
            return SendClientMessage(playerid, COLOR_GREY, "You are too far from the faction garage.");

        new found_idx = GarageDialogSlot[playerid][listitem];

        if(!GarageVehicles[garage_idx][found_idx][gvExists])
            return SendClientMessage(playerid, COLOR_GREY, "Error: Selected vehicle not configured for this garage.");

        if(!is_admin_force)
        {
            if(PlayerInfo[playerid][pFactionRank] < GarageVehicles[garage_idx][found_idx][gvMinRank])
                return SendClientMessageEx(playerid, COLOR_GREY, "You need to be at least Rank %d+ to spawn this vehicle.", GarageVehicles[garage_idx][found_idx][gvMinRank]);

            if(GarageVehicles[garage_idx][found_idx][gvStockCurrent] <= 0)
                return SendClientMessage(playerid, COLOR_GREY, "This vehicle is currently out of stock.");
        }

        new Float:x = FactionGarages[garage_idx][fgSpawnX];
        new Float:y = FactionGarages[garage_idx][fgSpawnY];
        new Float:z = FactionGarages[garage_idx][fgSpawnZ];
        new Float:a = FactionGarages[garage_idx][fgSpawnA];
        
        new modelid = GarageVehicles[garage_idx][found_idx][gvModel];
        new factionid = FactionGarages[garage_idx][fgFaction];
        new color1 = 1, color2 = 1;
        switch(FactionInfo[factionid][fType])
        {
            case FACTION_POLICE, FACTION_FEDERAL: { color1 = 0; color2 = 1; }
            case FACTION_GOVERNMENT: { color1 = 0; color2 = 0; }
            case FACTION_NEWS: { color1 = 2; color2 = 1; }
            case FACTION_MEDIC: { color1 = 1; color2 = 3; }
            case FACTION_HITMAN: { color1 = 0; color2 = 0; }
        }

        new carid = CreateVehicle(modelid, x, y, z, a, color1, color2, 600);
        if(carid == INVALID_VEHICLE_ID)
            return SendClientMessage(playerid, COLOR_GREY, "Error: Unable to spawn vehicle (Vehicle limit reached).");

        ResetVehicle(carid);
        VehicleInfo[carid][vModel] = modelid;
        VehicleInfo[carid][vFactionType] = FactionInfo[factionid][fType];
        VehicleInfo[carid][vLocked] = (is_admin_force ? 0 : 1);
        vehicleFuel[carid] = 100;
        format(VehicleInfo[carid][vPlate], 32, "FAC-%d", factionid);
        
        SetVehicleVirtualWorld(carid, FactionGarages[garage_idx][fgWorld]);
        LinkVehicleToInterior(carid, FactionGarages[garage_idx][fgInterior]);
        RemovePlayerFromVehicle(playerid);
        PutPlayerInVehicle(playerid, carid, 0);

        if(!is_admin_force)
        {
            GarageVehicles[garage_idx][found_idx][gvStockCurrent]--;
            new query[128];
            mysql_format(connectionID, query, sizeof(query), "UPDATE faction_garage_vehicles SET stock_current = %d WHERE id = %d", GarageVehicles[garage_idx][found_idx][gvStockCurrent], GarageVehicles[garage_idx][found_idx][gvID]);
            mysql_tquery(connectionID, query);
            SendClientMessageEx(playerid, COLOR_GREEN, "* You have drawn a faction %s (Remaining Stock: %d).", GarageVehicles[garage_idx][found_idx][gvName], GarageVehicles[garage_idx][found_idx][gvStockCurrent]);
        }
        else
        {
            SendClientMessageEx(playerid, COLOR_YELLOW, "* [ADMIN] Force spawned %s (Stock not deducted).", GarageVehicles[garage_idx][found_idx][gvName]);
        }
        return 1;
    }
    return 1;
}

CMD:fgarage(playerid, params[])
{
    if(!isnull(params) && !strcmp(params, "help", true))
    {
        SendClientMessage(playerid, COLOR_GREEN, "Faction Garage Help:");
        SendClientMessage(playerid, COLOR_WHITE, "/fgarage - Open your nearby faction garage menu.");
        SendClientMessage(playerid, COLOR_WHITE, "/fgarage store - Store the faction vehicle you are currently driving.");
        SendClientMessage(playerid, COLOR_WHITE, "/fgarage help - Show this help message.");
        return 1;
    }

    if(!isnull(params) && !strcmp(params, "store", true))
    {
        return StoreFactionVehicle(playerid);
    }

    new garage_idx = GetNearbyFactionGarage(playerid);
    if(garage_idx == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not near any faction garage.");
    }

    if(PlayerInfo[playerid][pFaction] == -1)
    {
        if(PlayerInfo[playerid][pAdmin] >= 3)
        {
            OpenFactionGarageMenu(playerid, garage_idx, true);
            return 1;
        }
        return SendClientMessage(playerid, COLOR_GREY, "You are not in any faction.");
    }

    if(FactionGarages[garage_idx][fgFaction] != PlayerInfo[playerid][pFaction])
    {
        if(PlayerInfo[playerid][pAdmin] >= 3)
        {
            OpenFactionGarageMenu(playerid, garage_idx, true);
            return 1;
        }
        return SendClientMessage(playerid, COLOR_GREY, "This garage does not belong to your faction.");
    }

    OpenFactionGarageMenu(playerid, garage_idx, false);
    return 1;
}

CMD:fgaragestore(playerid, params[])
{
    return StoreFactionVehicle(playerid);
}

CMD:createfgarage(playerid, params[])
{
    new factionid;
    if(PlayerInfo[playerid][pAdmin] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
    }
    if(sscanf(params, "i", factionid))
    {
        SendClientMessage(playerid, COLOR_GREY, "Usage: /createfgarage [factionid]");
        return 1;
    }
    if(factionid < 0 || factionid >= MAX_FACTIONS || FactionInfo[factionid][fType] == FACTION_NONE)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid faction ID.");
    }

    new garage_idx = -1;
    for(new i = 0; i < MAX_FACTION_GARAGES; i++)
    {
        if(!FactionGarages[i][fgExists])
        {
            garage_idx = i;
            break;
        }
    }

    if(garage_idx == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Faction garages limit reached.");
    }

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    FactionGarages[garage_idx][fgFaction] = factionid;
    FactionGarages[garage_idx][fgPosX] = x;
    FactionGarages[garage_idx][fgPosY] = y;
    FactionGarages[garage_idx][fgPosZ] = z;
    FactionGarages[garage_idx][fgPosA] = a;
    FactionGarages[garage_idx][fgInterior] = GetPlayerInterior(playerid);
    FactionGarages[garage_idx][fgWorld] = GetPlayerVirtualWorld(playerid);
    FactionGarages[garage_idx][fgSpawnX] = x;
    FactionGarages[garage_idx][fgSpawnY] = y;
    FactionGarages[garage_idx][fgSpawnZ] = z;
    FactionGarages[garage_idx][fgSpawnA] = a;
    FactionGarages[garage_idx][fgExists] = 1;
    FactionGarages[garage_idx][fgLabel] = Text3D:INVALID_3DTEXT_ID;
    FactionGarages[garage_idx][fgPickup] = -1;

    new query[512];
    mysql_format(connectionID, query, sizeof(query), "INSERT INTO faction_garages (factionid, pos_x, pos_y, pos_z, pos_a, interior, world, spawn_x, spawn_y, spawn_z, spawn_a) VALUES (%d, %f, %f, %f, %f, %d, %d, %f, %f, %f, %f)", factionid, x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), x, y, z, a);
    mysql_tquery(connectionID, query, "OnFactionGarageCreated", "ii", playerid, garage_idx);
    return 1;
}

forward OnFactionGarageCreated(playerid, garage_idx);
public OnFactionGarageCreated(playerid, garage_idx)
{
    FactionGarages[garage_idx][fgID] = cache_insert_id(connectionID);
    ReloadFactionGarageUI(garage_idx);

    new factionid = FactionGarages[garage_idx][fgFaction];
    new faction_type = FactionInfo[factionid][fType];
    AddDefaultGarageVehicles(garage_idx, faction_type);

    SendClientMessageEx(playerid, COLOR_GREEN, "* Faction Garage created successfully (System ID: %d, DB ID: %d).", garage_idx, FactionGarages[garage_idx][fgID]);
    return 1;
}

forward OnDefaultVehiclesInserted(garage_idx);
public OnDefaultVehiclesInserted(garage_idx)
{
    for(new i = 0; i < MAX_GARAGE_VEHICLES; i++)
    {
        GarageVehicles[garage_idx][i][gvExists] = 0;
    }

    new query[128];
    mysql_format(connectionID, query, sizeof(query), "SELECT * FROM faction_garage_vehicles WHERE garage_id = %d", FactionGarages[garage_idx][fgID]);
    mysql_tquery(connectionID, query, "LoadGarageVehicles", "i", garage_idx);
    return 1;
}

stock AddDefaultGarageVehicles(garage_idx, faction_type)
{
    new db_id = FactionGarages[garage_idx][fgID];
    new query[512];

    switch(faction_type)
    {
        case FACTION_POLICE, FACTION_FEDERAL:
        {
            mysql_format(connectionID, query, sizeof(query), "INSERT INTO faction_garage_vehicles (garage_id, modelid, name, stock_current, stock_max, min_rank) VALUES (%d, 596, 'Police Cruiser', 100, 100, 0), (%d, 599, 'Police Ranger', 50, 50, 1), (%d, 490, 'FBI Rancher', 20, 20, 3)", db_id, db_id, db_id);
        }
        case FACTION_MEDIC:
        {
            mysql_format(connectionID, query, sizeof(query), "INSERT INTO faction_garage_vehicles (garage_id, modelid, name, stock_current, stock_max, min_rank) VALUES (%d, 416, 'Ambulance', 100, 100, 0), (%d, 579, 'Paramedic SUV', 50, 50, 1)", db_id, db_id);
        }
        case FACTION_NEWS:
        {
            mysql_format(connectionID, query, sizeof(query), "INSERT INTO faction_garage_vehicles (garage_id, modelid, name, stock_current, stock_max, min_rank) VALUES (%d, 582, 'News Van', 100, 100, 0), (%d, 426, 'News Sedan', 50, 50, 0)", db_id, db_id);
        }
        case FACTION_GOVERNMENT:
        {
            mysql_format(connectionID, query, sizeof(query), "INSERT INTO faction_garage_vehicles (garage_id, modelid, name, stock_current, stock_max, min_rank) VALUES (%d, 405, 'Gov Sedan', 100, 100, 0), (%d, 421, 'Gov Washington', 50, 50, 1), (%d, 409, 'Gov Limousine', 5, 5, 3)", db_id, db_id, db_id);
        }
        case FACTION_HITMAN:
        {
            mysql_format(connectionID, query, sizeof(query), "INSERT INTO faction_garage_vehicles (garage_id, modelid, name, stock_current, stock_max, min_rank) VALUES (%d, 560, 'Agency Sultan', 100, 100, 0), (%d, 405, 'Agency Sentinel', 100, 100, 0)", db_id, db_id);
        }
        default:
        {
            mysql_format(connectionID, query, sizeof(query), "INSERT INTO faction_garage_vehicles (garage_id, modelid, name, stock_current, stock_max, min_rank) VALUES (%d, 405, 'Faction Sentinel', 100, 100, 0)", db_id);
        }
    }

    mysql_tquery(connectionID, query, "OnDefaultVehiclesInserted", "i", garage_idx);
    return 1;
}

CMD:setfgaragespawn(playerid, params[])
{
    new garage_idx;
    if(PlayerInfo[playerid][pAdmin] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
    }
    if(sscanf(params, "i", garage_idx))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Usage: /setfgaragespawn [garage_idx]");
    }
    if(garage_idx < 0 || garage_idx >= MAX_FACTION_GARAGES || !FactionGarages[garage_idx][fgExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid Faction Garage ID.");
    }

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    FactionGarages[garage_idx][fgSpawnX] = x;
    FactionGarages[garage_idx][fgSpawnY] = y;
    FactionGarages[garage_idx][fgSpawnZ] = z;
    FactionGarages[garage_idx][fgSpawnA] = a;

    new query[256];
    mysql_format(connectionID, query, sizeof(query), "UPDATE faction_garages SET spawn_x = %f, spawn_y = %f, spawn_z = %f, spawn_a = %f WHERE id = %d", x, y, z, a, FactionGarages[garage_idx][fgID]);
    mysql_tquery(connectionID, query);
    SendClientMessageEx(playerid, COLOR_GREEN, "* You have updated the vehicle spawn position for Faction Garage ID %d to your location.", garage_idx);
    return 1;
}

CMD:addfgarageveh(playerid, params[])
{
    new garage_idx, modelid, max_stock, min_rank, custom_name[64];
    if(PlayerInfo[playerid][pAdmin] < 5 && PlayerInfo[playerid][pFactionRank] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
    }
    if(sscanf(params, "iiiis[64]", garage_idx, modelid, max_stock, min_rank, custom_name))
    {
        SendClientMessage(playerid, COLOR_GREY, "Usage: /addfgarageveh [garage_idx] [modelid] [max_stock] [min_rank] [custom name]");
        return 1;
    }
    if(garage_idx < 0 || garage_idx >= MAX_FACTION_GARAGES || !FactionGarages[garage_idx][fgExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid Faction Garage ID.");
    }
    if(modelid < 400 || modelid > 611)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid Vehicle Model ID (400-611).");
    }

    new vehicle_slot = -1;
    for(new i = 0; i < MAX_GARAGE_VEHICLES; i++)
    {
        if(!GarageVehicles[garage_idx][i][gvExists])
        {
            vehicle_slot = i;
            break;
        }
    }

    if(vehicle_slot == -1)
    {
        return SendClientMessage(playerid, COLOR_GREY, "This garage is full (limit is 50 vehicle types).");
    }

    GarageVehicles[garage_idx][vehicle_slot][gvModel] = modelid;
    strcpy(GarageVehicles[garage_idx][vehicle_slot][gvName], custom_name, 64);
    GarageVehicles[garage_idx][vehicle_slot][gvStockCurrent] = max_stock;
    GarageVehicles[garage_idx][vehicle_slot][gvStockMax] = max_stock;
    GarageVehicles[garage_idx][vehicle_slot][gvMinRank] = min_rank;
    GarageVehicles[garage_idx][vehicle_slot][gvExists] = 1;

    new query[256];
    mysql_format(connectionID, query, sizeof(query), "INSERT INTO faction_garage_vehicles (garage_id, modelid, name, stock_current, stock_max, min_rank) VALUES (%d, %d, '%e', %d, %d, %d)", FactionGarages[garage_idx][fgID], modelid, custom_name, max_stock, max_stock, min_rank);
    mysql_tquery(connectionID, query, "OnFactionGarageVehicleAdded", "iii", playerid, garage_idx, vehicle_slot);
    return 1;
}

forward OnFactionGarageVehicleAdded(playerid, garage_idx, vehicle_slot);
public OnFactionGarageVehicleAdded(playerid, garage_idx, vehicle_slot)
{
    GarageVehicles[garage_idx][vehicle_slot][gvID] = cache_insert_id(connectionID);
    SendClientMessageEx(playerid, COLOR_GREEN, "* Vehicle %s (Model %d) added to Garage %d successfully.", GarageVehicles[garage_idx][vehicle_slot][gvName], GarageVehicles[garage_idx][vehicle_slot][gvModel], garage_idx);
    return 1;
}

CMD:fgaragestock(playerid, params[])
{
    new garage_idx, slot, amount;
    if(PlayerInfo[playerid][pAdmin] < 5 && PlayerInfo[playerid][pFactionRank] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
    }
    if(sscanf(params, "iii", garage_idx, slot, amount))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Usage: /fgaragestock [garage_idx] [vehicle_slot_id (0-49)] [amount]");
    }
    if(garage_idx < 0 || garage_idx >= MAX_FACTION_GARAGES || !FactionGarages[garage_idx][fgExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid Faction Garage ID.");
    }
    if(slot < 0 || slot >= MAX_GARAGE_VEHICLES || !GarageVehicles[garage_idx][slot][gvExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid Vehicle slot.");
    }

    GarageVehicles[garage_idx][slot][gvStockCurrent] += amount;
    if(GarageVehicles[garage_idx][slot][gvStockCurrent] > GarageVehicles[garage_idx][slot][gvStockMax])
    {
        GarageVehicles[garage_idx][slot][gvStockCurrent] = GarageVehicles[garage_idx][slot][gvStockMax];
    }

    new query[128];
    mysql_format(connectionID, query, sizeof(query), "UPDATE faction_garage_vehicles SET stock_current = %d WHERE id = %d", GarageVehicles[garage_idx][slot][gvStockCurrent], GarageVehicles[garage_idx][slot][gvID]);
    mysql_tquery(connectionID, query);

    SendClientMessageEx(playerid, COLOR_GREEN, "* You restocked %s in Garage %d (New Stock: %d/%d).", GarageVehicles[garage_idx][slot][gvName], garage_idx, GarageVehicles[garage_idx][slot][gvStockCurrent], GarageVehicles[garage_idx][slot][gvStockMax]);
    return 1;
}

CMD:removefgarage(playerid, params[])
{
    new garage_idx;
    if(PlayerInfo[playerid][pAdmin] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
    }
    if(sscanf(params, "i", garage_idx))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Usage: /removefgarage [garage_idx]");
    }
    if(garage_idx < 0 || garage_idx >= MAX_FACTION_GARAGES || !FactionGarages[garage_idx][fgExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid Faction Garage ID.");
    }

    DestroyDynamic3DTextLabel(FactionGarages[garage_idx][fgLabel]);
    DestroyDynamicPickup(FactionGarages[garage_idx][fgPickup]);

    new query[256];
    mysql_format(connectionID, query, sizeof(query), "DELETE FROM faction_garages WHERE id = %d", FactionGarages[garage_idx][fgID]);
    mysql_tquery(connectionID, query);

    mysql_format(connectionID, query, sizeof(query), "DELETE FROM faction_garage_vehicles WHERE garage_id = %d", FactionGarages[garage_idx][fgID]);
    mysql_tquery(connectionID, query);

    FactionGarages[garage_idx][fgExists] = 0;
    for(new i = 0; i < MAX_GARAGE_VEHICLES; i++)
    {
        GarageVehicles[garage_idx][i][gvExists] = 0;
    }

    SendClientMessageEx(playerid, COLOR_GREEN, "* You have successfully removed Faction Garage ID %d.", garage_idx);
    return 1;
}

CMD:gotofgarage(playerid, params[])
{
    new garage_idx;
    if(PlayerInfo[playerid][pAdmin] < 5)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
    }
    if(sscanf(params, "i", garage_idx))
    {
        return SendClientMessage(playerid, COLOR_GREY, "Usage: /gotofgarage [garage_idx]");
    }
    if(garage_idx < 0 || garage_idx >= MAX_FACTION_GARAGES || !FactionGarages[garage_idx][fgExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid Faction Garage ID.");
    }

    SetPlayerPos(playerid, FactionGarages[garage_idx][fgPosX], FactionGarages[garage_idx][fgPosY], FactionGarages[garage_idx][fgPosZ]);
    SetPlayerInterior(playerid, FactionGarages[garage_idx][fgInterior]);
    SetPlayerVirtualWorld(playerid, FactionGarages[garage_idx][fgWorld]);
    SetCameraBehindPlayer(playerid);
    return 1;
}