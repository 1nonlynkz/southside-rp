#include <YSI_Coding\y_hooks>

#define	MAX_VENDOR      100

enum vendorData
{
	vendorID,
	vendorExists,
	vendorModel,

	// Start of Vendor Ownership
	vendorOwnerID,
	vendorOwner[MAX_PLAYER_NAME],
	vendorTimestamp,
	vendorPrice,
	vendorStock,
	vendorFee,
	vendorBalance,
	// End of Vendor Ownership

	Float:vendorPosX,
	Float:vendorPosY,
	Float:vendorPosZ,
	Float:vendorAngle,
	vendorInterior,
	vendorWorld,
	vendorObject,
	Text3D: vendorTextId
};
new VendorData[MAX_VENDOR][vendorData];

SetVendorOwner(vendorid, playerid)
{
	if(playerid == INVALID_PLAYER_ID)
	{
	    strcpy(VendorData[vendorid][vendorOwner], "Nobody", MAX_PLAYER_NAME);
	    VendorData[vendorid][vendorOwnerID] = 0;
	}
	else
	{
     	GetPlayerName(playerid, VendorData[vendorid][vendorOwner], MAX_PLAYER_NAME);
	    VendorData[vendorid][vendorOwnerID] = PlayerInfo[playerid][pID];
	}
	VendorData[vendorid][vendorTimestamp] = gettime();
	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE `vendors` SET `vendorTimestamp` = '%i', `vendorOwnerID` = '%i', `vendorOwner` = '%s' WHERE `vendorID` = '%d'", VendorData[vendorid][vendorTimestamp], VendorData[vendorid][vendorOwnerID], VendorData[vendorid][vendorOwner], VendorData[vendorid][vendorID]);
	mysql_tquery(connectionID, queryBuffer);
	RenderVendor(vendorid);
}

IsVendorOwner(playerid, vendorid)
{
	return (VendorData[vendorid][vendorOwnerID] == PlayerInfo[playerid][pID]) || (VendorData[vendorid][vendorOwnerID] > 0 && PlayerInfo[playerid][pAdminDuty]);
}

stock IsAtVendor(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		for(new x; x < MAX_VENDOR; x++)
		{
			if(VendorData[x][vendorPosX] != 0)
			{
				if(IsPlayerInRangeOfPoint(playerid, 2.0, VendorData[x][vendorPosX], VendorData[x][vendorPosY], VendorData[x][vendorPosZ]) && GetPlayerInterior(playerid) == VendorData[x][vendorInterior] && GetPlayerVirtualWorld(playerid) == VendorData[x][vendorWorld]) return 1;
			}
		}
	}
	return 0;
}

GetNearbyVendor(playerid)
{
	for(new x = 0; x < MAX_VENDOR; x ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, VendorData[x][vendorPosX], VendorData[x][vendorPosY], VendorData[x][vendorPosZ]) && GetPlayerInterior(playerid) == VendorData[x][vendorInterior] && GetPlayerVirtualWorld(playerid) == VendorData[x][vendorWorld])
	    {
	        return x;
		}
	}
	return -1;
}

stock RenderVendor(id)
{
	new string[128 * 2];
	DestroyDynamicObject(VendorData[id][vendorObject]);
	DestroyDynamic3DTextLabel(VendorData[id][vendorTextId]);
	if(VendorData[id][vendorPosX] != 0.0)
	{
		if(VendorData[id][vendorOwnerID] == 0)
		{
			format(string,sizeof(string),"[Machine ID: %d]\n\nTo buy this business contact an Administrator\n"YELLOW"Stock: "WHITE"%d\n"YELLOW"Fee: "WHITE"%d\nPress 'F' to insert coin", id, VendorData[id][vendorStock], VendorData[id][vendorFee]);
		}
		else
		{
			format(string,sizeof(string),"[Machine ID: %d]\n\n"YELLOW"Owner: "WHITE"%s\n"YELLOW"Stock: "WHITE"%d\n"YELLOW"Fee: "WHITE"%d\nPress 'F' to insert coin", id, VendorData[id][vendorOwner], VendorData[id][vendorStock], VendorData[id][vendorFee]);
		}
		VendorData[id][vendorTextId] = CreateDynamic3DTextLabel(string, COLOR_WHITE, VendorData[id][vendorPosX], VendorData[id][vendorPosY], VendorData[id][vendorPosZ] + 0.4, 10.0, .worldid = VendorData[id][vendorWorld], .testlos = 0, .streamdistance = 25.0);
		VendorData[id][vendorObject] = CreateDynamicObject(VendorData[id][vendorModel], VendorData[id][vendorPosX], VendorData[id][vendorPosY], VendorData[id][vendorPosZ], 0.0, 0.0, VendorData[id][vendorAngle], VendorData[id][vendorWorld], VendorData[id][vendorInterior], .streamdistance = 100.0);
	}
	return 1;
}

forward OnVendorCreated(vendorid);
public OnVendorCreated(vendorid)
{
	if (vendorid == -1 || !VendorData[vendorid][vendorExists])
	    return 0;

	VendorData[vendorid][vendorID] = cache_insert_id(connectionID);
	Vendor_Save(vendorid);

	return 1;
}

stock Vendor_Create(playerid)
{
	new Float:x, Float:y, Float:z, Float:angle;
	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_VENDOR; i ++) if (!VendorData[i][vendorExists])
		{
			strcpy(VendorData[i][vendorOwner], "Nobody", MAX_PLAYER_NAME);
			VendorData[i][vendorOwnerID] = 0;
			VendorData[i][vendorStock] = 100;
			VendorData[i][vendorFee] = 150;
			VendorData[i][vendorPrice] = 99999999;

		    VendorData[i][vendorExists] = true;
			VendorData[i][vendorModel] = 1776;

			VendorData[i][vendorPosX] = x;
			VendorData[i][vendorPosY] = y;
			VendorData[i][vendorPosZ] = z - 0.10;
			VendorData[i][vendorAngle] = angle;

            VendorData[i][vendorInterior] = GetPlayerInterior(playerid);
            VendorData[i][vendorWorld] = GetPlayerVirtualWorld(playerid);

			mysql_tquery(connectionID, "INSERT INTO `vendors` (`vendorModel`) VALUES(1776)", "OnVendorCreated", "d", i);
			Streamer_UpdateEx(playerid, VendorData[i][vendorPosX], VendorData[i][vendorPosY], VendorData[i][vendorPosZ]);
			RenderVendor(i);
			return i;
		}
	}
	return -1;
}

stock Vendor_Delete(vendorid)
{
	if (vendorid != -1 && VendorData[vendorid][vendorExists])
	{
		new query[64];
		format(query, sizeof(query), "DELETE FROM `vendors` WHERE `vendorID` = '%d'", VendorData[vendorid][vendorID]);
		mysql_tquery(connectionID, query);

		if (IsValidDynamicObject(VendorData[vendorid][vendorObject]))
		    DestroyDynamicObject(VendorData[vendorid][vendorObject]);
		DestroyDynamic3DTextLabel(VendorData[vendorid][vendorTextId]);

		for (new i = 0; i != MAX_VENDOR; i ++) if (VendorData[i][vendorExists] && VendorData[vendorid][vendorID]) {
		    Vendor_Save(i);
		}
	    VendorData[vendorid][vendorExists] = false;
	    VendorData[vendorid][vendorID] = 0;
	}
	return 1;
}


stock Vendor_Save(vendorid)
{
	new query[768];
	format(query, sizeof(query), "UPDATE `vendors` SET `vendorModel` = '%d', `vendorPosX` = '%f', `vendorPosY` = '%f', `vendorPosZ` = '%f', `vendorInterior` = '%d', `vendorWorld` = '%d', `vendorAngle` = '%f', `vendorTimestamp` = '%i', `vendorBalance` = '%i', `vendorStock` = '%i' WHERE `vendorID` = '%d'",
	    VendorData[vendorid][vendorModel],
	    VendorData[vendorid][vendorPosX],
	    VendorData[vendorid][vendorPosY],
	    VendorData[vendorid][vendorPosZ],
	    VendorData[vendorid][vendorInterior],
	    VendorData[vendorid][vendorWorld],
	    VendorData[vendorid][vendorAngle],
		gettime(), 
		VendorData[vendorid][vendorBalance], 
		VendorData[vendorid][vendorStock],
	    VendorData[vendorid][vendorID]
	);
	return mysql_tquery(connectionID, query);
}

forward Vendor_Load();
public Vendor_Load()
{
    new rows = cache_num_rows();
	if(rows) 
	{
		for(new i; i < rows; i++) 
		{
			if (i >= MAX_VENDOR) break;
			 
			VendorData[i][vendorExists] = true;

			VendorData[i][vendorID] = cache_get_field_content_int(i, "vendorID");
			VendorData[i][vendorModel] = cache_get_field_content_int(i, "vendorModel");

			// Start of Vendor Ownership
			cache_get_field_content(i, "vendorOwner", VendorData[i][vendorOwner], connectionID, MAX_PLAYER_NAME);
			VendorData[i][vendorOwnerID] = cache_get_field_content_int(i, "vendorOwnerID");
			VendorData[i][vendorTimestamp] = cache_get_field_content_int(i, "vendorTimeStamp");
			VendorData[i][vendorPrice] = cache_get_field_content_int(i, "vendorPrice");
			VendorData[i][vendorStock] = cache_get_field_content_int(i, "vendorStock");
			VendorData[i][vendorFee] = cache_get_field_content_int(i, "vendorFee");
			VendorData[i][vendorBalance] = cache_get_field_content_int(i, "vendorBalance");
			// End of Vendor Ownership

			VendorData[i][vendorInterior] = cache_get_field_content_int(i, "vendorInterior");
			VendorData[i][vendorWorld] = cache_get_field_content_int(i, "vendorWorld");
			VendorData[i][vendorAngle] = cache_get_field_content_int(i, "vendorAngle");
			VendorData[i][vendorPosX] = cache_get_field_content_float(i, "vendorPosX");
			VendorData[i][vendorPosY] = cache_get_field_content_float(i, "vendorPosY");
			VendorData[i][vendorPosZ] = cache_get_field_content_float(i, "vendorPosZ");
			RenderVendor(i);
		}
	}
	return 1;
}


CMD:createvendor(playerid, params[])
{
	static id = -1;

	if(PlayerInfo[playerid][pAdmin] < 7)
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	id = Vendor_Create(playerid);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The server has reached the limit for gates.");

	SendMessage(playerid, COLOR_WHITE, "You have successfully created machine vendor [ID: %d]", id);
	return 1;
}

CMD:removevendor(playerid, params[])
{
	static id = 0;
	if(PlayerInfo[playerid][pAdmin] < 6) 
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "Usage: /removevendor [stall id]");

	if ((id < 0 || id >= MAX_VENDOR) || !VendorData[id][vendorExists])
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid machine vendor.");

	Vendor_Delete(id);
	SendMessage(playerid, COLOR_WHITE, "You have successfully machine vendor [ID: %d]", id);
	return 1;
}

CMD:editvendor(playerid, params[])
{
	new id, option[14], param[64];
	if(PlayerInfo[playerid][pAdmin] < 7)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "is[14]S()[64]", id, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvendor [id] [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: position, stock, price");
	    return 1;
	}
	if ((id < 0 || id >= MAX_VENDOR) || !VendorData[id][vendorExists])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You have specified an invalid machine vendor.");
	}
	if(!strcmp(option, "position", true))
	{
	    GetPlayerPos(playerid, VendorData[id][vendorPosX], VendorData[id][vendorPosY], VendorData[id][vendorPosZ]);
		GetPlayerFacingAngle(playerid, VendorData[id][vendorAngle]);
		
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE `vendors` SET `vendorPosX` = '%f', `vendorPosY` = '%f', `vendorPosZ` = '%f', `vendorAngle` = '%f' WHERE `vendorID` = '%d'", VendorData[id][vendorPosX], VendorData[id][vendorPosY], VendorData[id][vendorPosZ], VendorData[id][vendorAngle], VendorData[id][vendorID]);
	    mysql_tquery(connectionID, queryBuffer);

		RenderVendor(id);
	    SendMessage(playerid, COLOR_WHITE, "You've changed the position of machine vendor [ID: %i]", id);
	}
	else if(!strcmp(option, "stock", true))
	{
		new vstock;
	    if(sscanf(param, "i", vstock))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvendor [id] [stock] [value]");
		}

		VendorData[id][vendorStock] = vstock;
		Vendor_Save(id);
		RenderVendor(id);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE `vendors` SET `vendorStock` = '%d' WHERE `vendorID` = '%d'", VendorData[id][vendorStock], VendorData[id][vendorID]);
		mysql_tquery(connectionID, queryBuffer);

		SendMessage(playerid, COLOR_WHITE, "You've changed the stock of machine vendor [ID: %i] [Value: %d]", id, vstock);
	}
	else if(!strcmp(option, "price", true))
	{
		new vstock;
	    if(sscanf(param, "i", vstock))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvendor [id] [price] [value]");
		}

		VendorData[id][vendorPrice] = vstock;
		Vendor_Save(id);
		RenderVendor(id);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE `vendors` SET `vendorPrice` = '%d' WHERE `vendorID` = '%d'", VendorData[id][vendorPrice], VendorData[id][vendorID]);
		mysql_tquery(connectionID, queryBuffer);

		SendMessage(playerid, COLOR_WHITE, "You've changed the price of the machine vendor [ID: %i] [Value: %d]", id, vstock);
	}
	return 1;
}

CMD:vendorhelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_LIGHTORANGE, "Vendor Help: /buyvendor, /sellvendor, /vendor");
	return 1;
}

CMD:vendor(playerid, params[])
{
	new vendorid = GetNearbyVendor(playerid);
	new option[14], param[64];	
	if(vendorid == -1 || !IsVendorOwner(playerid, vendorid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You're not near any vendor machine that you own.");
	}
	if(sscanf(params, "s[14]S()[64]", option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vendor [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: fee, balance, withdraw");
	    return 1;
	}
	if(!strcmp(option, "fee", true))
	{
		new vfee;
	    if(sscanf(param, "i", vfee))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vendor [fee] [value]");
		}
		if(vfee > 50000 || vfee < 0)
		{
			return SendClientMessage(playerid, COLOR_SYNTAX, "You are only allowed to put up a price from 0 - 5,000 only");
		}

		VendorData[vendorid][vendorFee] = vfee;
		Vendor_Save(vendorid);
		RenderVendor(vendorid);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE `vendors` SET `vendorFee` = '%i' WHERE `vendorID` = '%d'", VendorData[vendorid][vendorFee], VendorData[vendorid][vendorID]);
		mysql_tquery(connectionID, queryBuffer);

		SendMessage(playerid, COLOR_WHITE, "You've changed the fee of your machine vendor [ID: %i] [Value: %d]", vendorid, vfee);
	}
	if(!strcmp(option, "balance", true))
	{
		new vbalance = VendorData[vendorid][vendorBalance];
		
		SendMessage(playerid, COLOR_LIGHTBLUE, "You have $%i in this vending machine.", vbalance);
	}
	if(!strcmp(option, "withdraw", true))
	{
		new vwd, vb = VendorData[vendorid][vendorBalance];
	    if(sscanf(param, "i", vwd))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /vendor [withdraw] [value]");
		}
		if(vwd > vb)
		{
			return SendMessage(playerid, COLOR_SYNTAX, "Your vending machine balance is not enough. [$%i] only", vb);
		}
		GivePlayerCash(playerid, vwd);
		VendorData[vendorid][vendorBalance] -= vwd;
		Vendor_Save(vendorid);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE `vendors` SET `vendorBalance` = '%i' WHERE `vendorID` = '%d'", VendorData[vendorid][vendorBalance], VendorData[vendorid][vendorID]);
		mysql_tquery(connectionID, queryBuffer);

		SendMessage(playerid, COLOR_WHITE, "You've withdrawed $%i from your vending machine, New Balance: $%i.", vwd, VendorData[vendorid][vendorBalance]);
	}
	return 1;
}

CMD:abuyvendor(playerid, params[])
{
	new vendorid;
	if((vendorid = GetNearbyVendor(playerid)) == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "There is no vendor in range. You must be near a vendor.");
	}
	if(PlayerInfo[playerid][pCash] < VendorData[vendorid][vendorPrice])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this vendor (Cost: 99,999,999)");
	}
	if(strcmp(params, "confirm", true) != 0)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /buyvendor [confirm]");
	}
	if(VendorData[vendorid][vendorOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vendor already has an owner.");
	}
	if(PlayerInfo[playerid][pCash] < VendorData[vendorid][vendorPrice])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't afford to purchase this business.");
	}

	SetVendorOwner(vendorid, playerid);
	GivePlayerCash(playerid, -VendorData[vendorid][vendorPrice]);

	SendMessage(playerid, COLOR_YELLOW, "You paid $%i for this venodr machine. /vendorhelp for a list of commands.", VendorData[vendorid][vendorPrice]);
	return 1;
}

hook OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
    if(newkeys & KEY_SECONDARY_ATTACK)
	{
		new vendorid = GetNearbyVendor(playerid);

	    if(IsAtVendor(playerid))
	    {	
			if(VendorData[vendorid][vendorStock] > 0)
			{
				new price = VendorData[vendorid][vendorFee];
				if(PlayerInfo[playerid][pCash] < price)
				{
					return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have enough money. You can't buy this.");
				}
				
				new hunger = Random(5, 15);
				new thirst = Random(5, 15);
				GivePlayerHunger(playerid, hunger);
				GivePlayerThirst(playerid, thirst);
				GivePlayerCash(playerid, -price);

				VendorData[vendorid][vendorTimestamp] = gettime();
				VendorData[vendorid][vendorBalance] += price;
				VendorData[vendorid][vendorStock]--;

				Vendor_Save(vendorid);
				RenderVendor(vendorid);

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE `vendors` SET `vendorTimestamp` = '%i', `vendorBalance` = '%i', `vendorStock` = '%i' WHERE `vendorID` = '%d'", gettime(), VendorData[vendorid][vendorBalance], VendorData[vendorid][vendorStock], VendorData[vendorid][vendorID]);
				mysql_tquery(connectionID, queryBuffer);

				ApplyAnimationEx(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				SendMessage(playerid, COLOR_LIGHTBLUE, "You have bought foods from vendor machine cost of %d", price);
			}
			else
			{
				SendClientMessage(playerid, COLOR_SYNTAX, "This vendor has no more stocks, contact the owner to let him/her refill it.");
			}
	    }
	}
    return 1;
}