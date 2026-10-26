#define	MAX_CRAFTING_TABLE      100

/*new craftingStatus[MAX_PLAYERS],
    craftingWeapon[MAX_PLAYERS],
    Float:craftingTimer[MAX_PLAYERS];
*/
enum E_CRAFTING_DATA
{
	tableID,
	tableExists,
	tableModel,
    tableTimeStamp,

	Float:tablePosX,
	Float:tablePosY,
	Float:tablePosZ,
	Float:tablePosA,
	tableInterior,
	tableWorld,
	tableObject,
	Text3D:tableText
};
new craftingTable[MAX_CRAFTING_TABLE][E_CRAFTING_DATA];

stock IsACraftingTable(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		for(new x; x < MAX_CRAFTING_TABLE; x++)
		{
			if(craftingTable[x][tablePosX] != 0)
			{
				if(IsPlayerInRangeOfPoint(playerid, 2.0, craftingTable[x][tablePosX], craftingTable[x][tablePosY], craftingTable[x][tablePosZ]) && GetPlayerInterior(playerid) == craftingTable[x][tableInterior] && GetPlayerVirtualWorld(playerid) == craftingTable[x][tableWorld]) return 1;
			}
		}
	}
	return 0;
}

stock ReloadCraftingTable(id)
{
	new string[128 * 2];
	DestroyDynamicObject(craftingTable[id][tableObject]);
	DestroyDynamic3DTextLabel(craftingTable[id][tableText]);
	if(craftingTable[id][tablePosX] != 0.0)
	{
		format(string,sizeof(string),""YGREEN"[ID: %d]\n"WHITE"Type '/craftweapon' to craft weapon", id);
		craftingTable[id][tableText] = CreateDynamic3DTextLabel(string, COLOR_WHITE, craftingTable[id][tablePosX], craftingTable[id][tablePosY], craftingTable[id][tablePosZ] + 1.5, 10.0, .worldid = craftingTable[id][tableWorld], .testlos = 0, .streamdistance = 25.0);
		craftingTable[id][tableObject] = CreateDynamicObject(craftingTable[id][tableModel], craftingTable[id][tablePosX], craftingTable[id][tablePosY], craftingTable[id][tablePosZ], 0.0, 0.0, craftingTable[id][tablePosA], craftingTable[id][tableWorld], craftingTable[id][tableInterior], .streamdistance = 100.0);
	}
	return 1;
}

forward OnCreateCraftingTable(id);
public OnCreateCraftingTable(id)
{
	if (id == -1 || !craftingTable[id][tableExists])
	    return 0;

	craftingTable[id][tableID] = cache_insert_id(connectionID);
	CraftingTable_Save(id);

	return 1;
}

stock CraftingTable_Create(playerid)
{
	new Float:x, Float:y, Float:z, Float:angle;
	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_CRAFTING_TABLE; i ++) if (!craftingTable[i][tableExists])
		{
		    craftingTable[i][tableExists] = true;
			craftingTable[i][tableModel] = 3383;

			craftingTable[i][tablePosX] = x;
			craftingTable[i][tablePosY] = y;
			craftingTable[i][tablePosZ] = z;
			craftingTable[i][tablePosA] = angle;

            craftingTable[i][tableInterior] = GetPlayerInterior(playerid);
            craftingTable[i][tableWorld] = GetPlayerVirtualWorld(playerid);

			mysql_tquery(connectionID, "INSERT INTO `craftingtable` (`tableModel`) VALUES(3383)", "OnCreateCraftingTable", "d", i);
			Streamer_UpdateEx(playerid, craftingTable[i][tablePosX], craftingTable[i][tablePosY], craftingTable[i][tablePosZ]);
			ReloadCraftingTable(i);
			return i;
		}
	}
	return -1;
}

stock CraftingTable_Delete(id)
{
	if (id != -1 && craftingTable[id][tableExists])
	{
		new query[64];
		format(query, sizeof(query), "DELETE FROM `craftingtable` WHERE `tableID` = '%d'", craftingTable[id][tableID]);
		mysql_tquery(connectionID, query);

		if (IsValidDynamicObject(craftingTable[id][tableObject]))
		    DestroyDynamicObject(craftingTable[id][tableObject]);
		DestroyDynamic3DTextLabel(craftingTable[id][tableText]);

		for (new i = 0; i != MAX_CRAFTING_TABLE; i ++) if (craftingTable[i][tableExists] && craftingTable[id][tableID]) {
		    CraftingTable_Save(i);
		}
	    craftingTable[id][tableExists] = false;
	    craftingTable[id][tableID] = 0;
	}
	return 1;
}


stock CraftingTable_Save(id)
{
	new query[768];
	format(query, sizeof(query), "UPDATE `craftingtable` SET `tableModel` = '%d', `tablePosX` = '%f', `tablePosY` = '%f', `tablePosZ` = '%f', `tableInterior` = '%d', `tableWorld` = '%d', `tablePosA` = '%f', `tableTimeStamp` = '%i' WHERE `tableID` = '%d'",
	    craftingTable[id][tableModel],
	    craftingTable[id][tablePosX],
	    craftingTable[id][tablePosY],
	    craftingTable[id][tablePosZ],
	    craftingTable[id][tableInterior],
	    craftingTable[id][tableWorld],
	    craftingTable[id][tablePosA],
		gettime(),
	    craftingTable[id][tableID]
	);
	return mysql_tquery(connectionID, query);
}

stock CraftingTable_Update(id)
{
	if (id == -1 || !craftingTable[id][tableExists])
	    return 0;

	CraftingTable_Save(id);
	ReloadCraftingTable(id);
	return 1;
}

forward CraftingTable_Load();
public CraftingTable_Load()
{
	new rows = cache_num_rows();
	if(rows) 
	{
		for(new i; i < rows; i++) 
		{
			craftingTable[i][tableExists] = true;

            craftingTable[i][tableID] = cache_get_field_content_int(i, "tableID");
            craftingTable[i][tableModel] = cache_get_field_content_int(i, "tableModel");
            craftingTable[i][tableTimeStamp] = cache_get_field_content_int(i, "tableTimestamp");

            craftingTable[i][tableInterior] = cache_get_field_content_int(i, "tableInterior");
            craftingTable[i][tableWorld] = cache_get_field_content_int(i, "tableWorld");
            craftingTable[i][tablePosA] = cache_get_field_content_float(i, "tablePosA");
            craftingTable[i][tablePosX] = cache_get_field_content_float(i, "tablePosX");
            craftingTable[i][tablePosY] = cache_get_field_content_float(i, "tablePosY");
            craftingTable[i][tablePosZ] = cache_get_field_content_float(i, "tablePosZ");
            ReloadCraftingTable(i);
		}
	}
	return 1;
}

/*ptask OnPlayerCraftingWeapon[1000](i) 
{
    new string[128], Float:status;
    if(PlayerInfo[i][pLogged] && !PlayerInfo[i][pKicked])
    {
        if(craftingStatus[i] == 1) 
        {
            status = RandomFloat(10.00);  
            craftingTimer[i] += status;

            format(string, sizeof(string), "~w~Crafting Weapon~n~~r~%.2f ~w~Complete", craftingTimer[i]);
            GameTextForPlayer(i, string, 1000, 4);

            if(craftingTimer[i] > 99.0)
            {
                format(string, sizeof(string), "~w~Crafting Weapon~n~~g~100.0 ~w~Complete");
                GameTextForPlayer(i, string, 1000, 4);

                craftingStatus[i] = 0;
                craftingTimer[i] = 0;
                ClearAnimations(i);
                
                SendMessage(i, COLOR_WHITE, ""YGREEN"[CRAFTING] "WHITE"You've been successfully craft this weapon. you can now transfer into crate package using "YGREEN"/adpackage");
                switch(craftingWeapon[i])
                {
                    case 1: GivePlayerWeaponEx(i, 22, 350); // 9mm
                    case 2: GivePlayerWeaponEx(i, 23, 350); // sdpistol
                    case 3: GivePlayerWeaponEx(i, 24, 350); // deagle
                    case 4: GivePlayerWeaponEx(i, 25, 350); // shotgun
                    case 5: GivePlayerWeaponEx(i, 27, 350); // spas
                    case 6: GivePlayerWeaponEx(i, 29, 350); // mp5
                    case 7: GivePlayerWeaponEx(i, 30, 350); // ak
                    case 8: GivePlayerWeaponEx(i, 31, 350); // m4
                    case 9: GivePlayerWeaponEx(i, 33, 350); // cuntgun
                }
            }
        }
    }
}*/

CMD:craftweapon(playerid, params[])
{
    new option[24];

	if(!IsACraftingTable(playerid))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not range in crafting table");
	}
    if(sscanf(params, "s[24]", option))
    {
        SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /craftweapon [weapon]");
        SendClientMessageEx(playerid, COLOR_GREY, "Available weapon: 9mm, sdpistol, deagle, shotgun, spas, mp5, ak, m4, cuntgun");
        return 1;
    }
    if(!strcmp(option, "9mm", true))
    {
		new string[32];
		format(string, sizeof(string), "Crafting Weapon");
		strcpy(player_progress_title[playerid], string);
		ShowPlayerProgress(playerid, CRAFTING_PROGRESS, string);

        SetPVarInt(playerid, "craftingWeapon", 1);
    }
    else if(!strcmp(option, "sdpistol", true))
    {
		new string[32];
		format(string, sizeof(string), "Crafting Weapon");
		strcpy(player_progress_title[playerid], string);
		ShowPlayerProgress(playerid, CRAFTING_PROGRESS, string);

        SetPVarInt(playerid, "craftingWeapon", 2);
    }
    else if(!strcmp(option, "deagle", true))
    {
		new string[32];
		format(string, sizeof(string), "Crafting Weapon");
		strcpy(player_progress_title[playerid], string);
		ShowPlayerProgress(playerid, CRAFTING_PROGRESS, string);

        SetPVarInt(playerid, "craftingWeapon", 3);
    }
    else if(!strcmp(option, "shotgun", true))
    {
		new string[32];
		format(string, sizeof(string), "Crafting Weapon");
		strcpy(player_progress_title[playerid], string);
		ShowPlayerProgress(playerid, CRAFTING_PROGRESS, string);

        SetPVarInt(playerid, "craftingWeapon", 4);
    }
    else if(!strcmp(option, "spas", true))
    {
		new string[32];
		format(string, sizeof(string), "Crafting Weapon");
		strcpy(player_progress_title[playerid], string);
		ShowPlayerProgress(playerid, CRAFTING_PROGRESS, string);

        SetPVarInt(playerid, "craftingWeapon", 5);
    }
    else if(!strcmp(option, "mp5", true))
    {
		new string[32];
		format(string, sizeof(string), "Crafting Weapon");
		strcpy(player_progress_title[playerid], string);
		ShowPlayerProgress(playerid, CRAFTING_PROGRESS, string);

        SetPVarInt(playerid, "craftingWeapon", 6);
    }
    else if(!strcmp(option, "ak", true))
    {
		new string[32];
		format(string, sizeof(string), "Crafting Weapon");
		strcpy(player_progress_title[playerid], string);
		ShowPlayerProgress(playerid, CRAFTING_PROGRESS, string);

        SetPVarInt(playerid, "craftingWeapon", 7);
    }
    else if(!strcmp(option, "m4", true))
    {
		new string[32];
		format(string, sizeof(string), "Crafting Weapon");
		strcpy(player_progress_title[playerid], string);
		ShowPlayerProgress(playerid, CRAFTING_PROGRESS, string);

        SetPVarInt(playerid, "craftingWeapon", 8);
    }
    else if(!strcmp(option, "cuntgun", true))
    {
		new string[32];
		format(string, sizeof(string), "Crafting Weapon");
		strcpy(player_progress_title[playerid], string);
		ShowPlayerProgress(playerid, CRAFTING_PROGRESS, string);

        SetPVarInt(playerid, "craftingWeapon", 9);
    }
    return 1;
}

CMD:createcraftingtable(playerid, params[])
{
	static id = -1;

	if(PlayerInfo[playerid][pAdmin] < 7)
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	id = CraftingTable_Create(playerid);
	if (id == -1)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The server has reached the limit for crafting table.");

	EditDynamicObjectEx(playerid, EDIT_TYPE_CRAFTING_TABLE, craftingTable[id][tableObject], id);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has created crafting table [ID: %i]", GetRPName(playerid), id);
	return 1;
}

CMD:removecraftingtable(playerid, params[])
{
	static id = 0;
	if(PlayerInfo[playerid][pAdmin] < 6) 
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /removecraftingtable [id]");

	if ((id < 0 || id >= MAX_CRAFTING_TABLE) || !craftingTable[id][tableExists])
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid crafting table.");

	CraftingTable_Delete(id);
	SendMessage(playerid, COLOR_WHITE, "You have successfully crafting table [ID: %d]", id);
	return 1;
}

CMD:editcraftingtable(playerid, params[])
{
	new id, option[14], param[64];
	if(PlayerInfo[playerid][pAdmin] < 7)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "is[14]S()[64]", id, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editcraftingtable [id] [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: position");
	    return 1;
	}
	if ((id < 0 || id >= MAX_CRAFTING_TABLE) || !craftingTable[id][tableExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid crafting table.");
	}
	
	EditDynamicObjectEx(playerid, EDIT_TYPE_CRAFTING_TABLE, craftingTable[id][tableObject], id);
	SendMessage(playerid, COLOR_WHITE, "You've changed the position of crafting table [ID: %i]", id);
	return 1;
}