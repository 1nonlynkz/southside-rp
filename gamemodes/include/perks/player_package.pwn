
#include <YSI_Coding\y_hooks> 


#define DIALOG_MYBOXES      9995
#define DIALOG_BOX_DETAILS  9996

// Global tracking variable for dialog navigation
new PlayerSelectedBox[MAX_PLAYERS];

forward OnPackageGiven(targetid, tier);
forward ShowPlayerBoxesList(playerid);
forward ShowBoxDetails(playerid);
forward OnProcessBoxClaim(playerid, boxtype);

CMD:givepackage(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 5)
    {
        return SendClientMessage(playerid, -1, "{FF0000}[ERROR]: {FFFFFF}You are not authorized to use this administration command.");
    }

    new targetid, tier;
    if(sscanf(params, "ui", targetid, tier)) return SendClientMessage(playerid, -1, "{FFFF00}Usage: {FFFFFF}/givepackage [PlayerID/Name] [Tier (1-4)]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "{FF0000}Error: {FFFFFF}The specified player is offline.");
    if(tier < 1 || tier > 4) return SendClientMessage(playerid, -1, "{FF0000}Error: {FFFFFF}Invalid package tier. Choose between 1 and 4.");

    new name[MAX_PLAYER_NAME], query[256];
    GetPlayerName(targetid, name, sizeof(name));

    new low_w = 0, high_w = 0, drug_b = 0, util_b = 0;
    
    switch(tier) 
    {
        case 1: { low_w = 1; util_b = 1; }
        case 2: { low_w = 2; drug_b = 1; util_b = 1; }
        case 3: { low_w = 2; high_w = 1; drug_b = 2; util_b = 2; }
        case 4: { low_w = 3; high_w = 3; drug_b = 4; util_b = 4; }
    }

    mysql_format(connectionID, query, sizeof(query), 
        "UPDATE users SET low_weapon = low_weapon + %d, high_weapon = high_weapon + %d, drugs_box = drugs_box + %d, utility_box = utility_box + %d WHERE username = '%e'",
        low_w, high_w, drug_b, util_b, name);
    
    mysql_tquery(connectionID, query, "OnPackageGiven", "dd", targetid, tier);
    return 1;
}

public OnPackageGiven(targetid, tier)
{
    if(!IsPlayerConnected(targetid)) return 1;
    new msg[128];
    format(msg, sizeof(msg), "{00FF00}[Donation]{FFFFFF} Your Tier %d Box Package has been credited! Type {FFFF00}/myboxes {FFFFFF}to open.", tier);
    SendClientMessage(targetid, -1, msg);
    return 1;
}

CMD:myboxes(playerid, params[])
{
    new name[MAX_PLAYER_NAME], query[128];
    GetPlayerName(playerid, name, sizeof(name));

    mysql_format(connectionID, query, sizeof(query), "SELECT low_weapon, high_weapon, drugs_box, utility_box FROM users WHERE username = '%e'", name);
    mysql_tquery(connectionID, query, "ShowPlayerBoxesList", "d", playerid);
    return 1;
}

public ShowPlayerBoxesList(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new rows = cache_num_rows();
    new low_w = 0, high_w = 0, drug_b = 0, util_b = 0;

    if(rows)
    {
        // Fixed: Swapped to backwards-compatible legacy MySQL R39 cache functions
        low_w = cache_get_field_content_int(0, "low_weapon", connectionID);
        high_w = cache_get_field_content_int(0, "high_weapon", connectionID);
        drug_b = cache_get_field_content_int(0, "drugs_box", connectionID);
        util_b = cache_get_field_content_int(0, "utility_box", connectionID);
    }

    new listStr[512];
    format(listStr, sizeof(listStr), 
        "Box Type\tAvailable Quantity\n\
        {FFFFFF}C:RP Low-Grade Weapon Box\t{FFFF00}%d pcs\n\
        {FFFFFF}C:RP High-Grade Weapon Box\t{FFFF00}%d pcs\n\
        {FFFFFF}C:RP Drugs Box\t{FFFF00}%d pcs\n\
        {FFFFFF}C:RP Utility Box\t{FFFF00}%d pcs", 
        low_w, high_w, drug_b, util_b);
        
    ShowPlayerDialog(playerid, DIALOG_MYBOXES, DIALOG_STYLE_TABLIST_HEADERS, "My Donator Boxes", listStr, "Select", "Close");
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_MYBOXES)
    {
        if(!response) return 1; 

        PlayerSelectedBox[playerid] = listitem + 1; 

        new name[MAX_PLAYER_NAME], query[128];
        GetPlayerName(playerid, name, sizeof(name));

        mysql_format(connectionID, query, sizeof(query), "SELECT low_weapon, high_weapon, drugs_box, utility_box FROM users WHERE username = '%e'", name);
        mysql_tquery(connectionID, query, "ShowBoxDetails", "d", playerid);
        return ~1;
    }
    
    if(dialogid == DIALOG_BOX_DETAILS)
    {
        if(!response) 
        {
            new empty_params[1];
            empty_params[0] = '\0';
            
            callcmd::myboxes(playerid, empty_params);
            return ~1;
        }

        new boxtype = PlayerSelectedBox[playerid];
        new name[MAX_PLAYER_NAME], query[128];
        GetPlayerName(playerid, name, sizeof(name));

        mysql_format(connectionID, query, sizeof(query), "SELECT low_weapon, high_weapon, drugs_box, utility_box FROM users WHERE username = '%e'", name);
        mysql_tquery(connectionID, query, "OnProcessBoxClaim", "dd", playerid, boxtype);
        return ~1; 
    }
   
    return 1;
}

public ShowBoxDetails(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new low_w = 0, high_w = 0, drug_b = 0, util_b = 0;
    if(cache_num_rows())
    {
        low_w = cache_get_field_content_int(0, "low_weapon", connectionID);
        high_w = cache_get_field_content_int(0, "high_weapon", connectionID);
        drug_b = cache_get_field_content_int(0, "drugs_box", connectionID);
        util_b = cache_get_field_content_int(0, "utility_box", connectionID);
    }

    new boxtype = PlayerSelectedBox[playerid];
    new descStr[512], title[64];

    switch(boxtype)
    {
        case 1: {
            format(title, sizeof(title), "Low-Grade Weapon Box (Stock: %d)", low_w);
            format(descStr, sizeof(descStr), 
                "{FFFFFF}Would you like to unbox this now?\n\n\
                {00FFFF}C:RP Box Guaranteed Contents:\n\
                {FFFFFF}- Desert Eagle (120 Ammo)\n\
                - Shotgun (150 Ammo)\n\
                - MP5 (250 Ammo)\n\
                - Rifle (100 Ammo)");
        }
        case 2: {
            format(title, sizeof(title), "High-Grade Weapon Box (Stock: %d)", high_w);
            format(descStr, sizeof(descStr), 
                "{FFFFFF}Would you like to unbox this now?\n\n\
                {00FFFF}C:RP Box Guaranteed Contents:\n\
                {FFFFFF}- SPAS-12 (300 Ammo)\n\
                - AK-47 (300 Ammo)\n\
                - Sniper Rifle (120 Ammo)");
        }
        case 3: {
            format(title, sizeof(title), "Drugs Box (Stock: %d)", drug_b);
            format(descStr, sizeof(descStr), 
                "{FFFFFF}Would you like to unbox this now?\n\n\
                {00FFFF}C:RP Box Guaranteed Contents:\n\
                {FFFFFF}- 10x Pot\n\
                - 10x Crack\n\
                - 5x Heroin");
        }
        case 4: {
            format(title, sizeof(title), "Utility Box (Stock: %d)", util_b);
            format(descStr, sizeof(descStr), 
                "{FFFFFF}Would you like to unbox this now?\n\n\
                {00FFFF}C:RP Box Guaranteed Contents:\n\
                {FFFFFF}- 3x Medkit & 3x Armour Vest\n\
                - 2x Repair Kit & 2x Gas Can\n\
                - 5x Syringe\n\
                - 10,000x Materials\n\
                - $50,000 Ingame Cash");
        }
    }
    ShowPlayerDialog(playerid, DIALOG_BOX_DETAILS, DIALOG_STYLE_MSGBOX, title, descStr, "Claim", "Back");
    return 1;
}

public OnProcessBoxClaim(playerid, boxtype)
{
    if(!cache_num_rows()) return SendClientMessage(playerid, -1, "{FF0000}Error: {FFFFFF}Database error profile missing.");

    new low_w, high_w, drug_b, util_b;
    low_w = cache_get_field_content_int(0, "low_weapon", connectionID);
    high_w = cache_get_field_content_int(0, "high_weapon", connectionID);
    drug_b = cache_get_field_content_int(0, "drugs_box", connectionID);
    util_b = cache_get_field_content_int(0, "utility_box", connectionID);

    new name[MAX_PLAYER_NAME], query[128];
    GetPlayerName(playerid, name, sizeof(name));

    switch(boxtype)
	{
	    case 1: {
	        if(low_w < 1) return SendClientMessage(playerid, -1, "{FF0000}Error: {FFFFFF}You don't own any Low-Grade Weapon Boxes.");
	        mysql_format(connectionID, query, sizeof(query), "UPDATE users SET low_weapon = low_weapon - 1 WHERE username = '%e'", name);
	        mysql_tquery(connectionID, query);
	        
	        Inventory_Add(playerid, "Desert Eagle", 348, 1);
	        Inventory_Add(playerid, "Shotgun", 349, 1);
	        Inventory_Add(playerid, "MP5", 353, 1);
	        Inventory_Add(playerid, "Country Rifle", 357, 1);
	
	        SendClientMessage(playerid, -1, "{00FF00}[Box]{FFFFFF} You have opened 1x Low-Grade Weapon Box successfully! Use weapons via /inventory.");
	    }
	    case 2: {
	        if(high_w < 1) return SendClientMessage(playerid, -1, "{FF0000}Error: {FFFFFF}You don't own any High-Grade Weapon Boxes.");
	        mysql_format(connectionID, query, sizeof(query), "UPDATE users SET high_weapon = high_weapon - 1 WHERE username = '%e'", name);
	        mysql_tquery(connectionID, query);
	        
	        Inventory_Add(playerid, "Combat Shotgun", 351, 1);
	        Inventory_Add(playerid, "AK-47", 355, 1);
	        Inventory_Add(playerid, "Sniper Rifle", 358, 1);
	
	        SendClientMessage(playerid, -1, "{00FF00}[Box]{FFFFFF} You have opened 1x High-Grade Weapon Box successfully! Use weapons via /inventory.");
	    }
	    case 3: {
	        if(drug_b < 1) return SendClientMessage(playerid, -1, "{FF0000}Error: {FFFFFF}You don't own any Drugs Boxes.");
	        mysql_format(connectionID, query, sizeof(query), "UPDATE users SET drugs_box = drugs_box - 1 WHERE username = '%e'", name);
	        mysql_tquery(connectionID, query);
	        
	        Inventory_Add(playerid, "Pot", 1210, 10);
	        Inventory_Add(playerid, "Crack", 1575, 10);
	        Inventory_Add(playerid, "Heroin", 1576, 5);
	
	        SendClientMessage(playerid, -1, "{00FF00}[Box]{FFFFFF} You have opened 1x Drugs Box successfully! Check your /inventory.");
	    }
	    case 4: {
	        if(util_b < 1) return SendClientMessage(playerid, -1, "{FF0000}Error: {FFFFFF}You don't own any Utility Boxes.");
	        mysql_format(connectionID, query, sizeof(query), "UPDATE users SET utility_box = utility_box - 1 WHERE username = '%e'", name);
	        mysql_tquery(connectionID, query);
	        
	        Inventory_Add(playerid, "Medkit", 1580, 3);
	        Inventory_Add(playerid, "Vest", 1242, 3);
	        Inventory_Add(playerid, "Materials", 1580, 10000); 
	        Inventory_Add(playerid, "Water Can", 2902, 2);      
	        Inventory_Add(playerid, "Syringe", 1578, 5);
	        
	        PlayerInfo[playerid][pHasVest] += 3;
	        PlayerInfo[playerid][pGasCan] += 2;
	
	        GivePlayerMoney(playerid, 50000);
	        SendClientMessage(playerid, -1, "{00FF00}[Box]{FFFFFF} You have opened 1x Utility Box successfully! Check your /inventory.");
	    }
	}

    return 1;
}