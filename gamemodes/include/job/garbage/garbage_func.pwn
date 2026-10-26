stock IsLoadableTrashmaster(vehicleid) {
    new modelid = GetVehicleModel(vehicleid);

    if (GetVehicleTrailer(vehicleid))
        modelid = GetVehicleModel(GetVehicleTrailer(vehicleid));

    switch (modelid) {
        case 408: return 1;
    }
    return 0;
}

forward OnGarbageCreated(garbageid);
public OnGarbageCreated(garbageid)
{
	if(garbageid == -1 || !GarbageData[garbageid][garbageExists])
	    return 0;

	GarbageData[garbageid][garbageID] = cache_insert_id(connectionID);
	Garbage_Save(garbageid);

	return 1;
}

stock Garbage_Create(playerid, type)
{
	new Float:x, Float:y, Float:z, Float:angle;
	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i != MAX_GARBAGE_BINS; i ++) if(!GarbageData[i][garbageExists])
		{
			switch (type) 
			{
				case 1: 
				{
					GarbageData[i][garbageModel] = 1236;
					GarbageData[i][garbagePos][0] = x;
					GarbageData[i][garbagePos][1] = y;
					GarbageData[i][garbagePos][2] = z -0.4;
					GarbageData[i][garbagePos][3] = angle;
				}
				case 2: 
				{
					GarbageData[i][garbageModel] = 1300;
					GarbageData[i][garbagePos][0] = x;
					GarbageData[i][garbagePos][1] = y;
					GarbageData[i][garbagePos][2] = z -0.6;
					GarbageData[i][garbagePos][3] = angle;
				}
			}

			GarbageData[i][garbageExists] = true;
			GarbageData[i][garbageCapacity] = 20;

			GarbageData[i][garbageInterior] = GetPlayerInterior(playerid);
			GarbageData[i][garbageWorld] = GetPlayerVirtualWorld(playerid);

			Garbage_Refresh(i);
			mysql_tquery(connectionID, "INSERT INTO `job_garbage` (`garbageCapacity`) VALUES(0)", "OnGarbageCreated", "d", i);
			return i;
		}
	}
	return -1;
}

stock Garbage_Delete(garbageid)
{
	if(garbageid != -1 && GarbageData[garbageid][garbageExists])
	{
	    new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `job_garbage` WHERE `garbageID` = '%d'", GarbageData[garbageid][garbageID]);
		mysql_tquery(connectionID, string);

        if(IsValidDynamic3DTextLabel(GarbageData[garbageid][garbageText3D]))
	        DestroyDynamic3DTextLabel(GarbageData[garbageid][garbageText3D]);

		if(IsValidDynamicObject(GarbageData[garbageid][garbageObject]))
		    DestroyDynamicObject(GarbageData[garbageid][garbageObject]);

	    GarbageData[garbageid][garbageExists] = false;
	    GarbageData[garbageid][garbageCapacity] = 0;
	    GarbageData[garbageid][garbageID] = 0;
	}
	return 1;
}

stock Garbage_Update(id)
{
	if (id == -1 || !GarbageData[id][garbageExists])
	    return 0;

	Garbage_Save(id);
	Garbage_Refresh(id);
	return 1;
}

Garbage_Nearest(playerid)
{
    for (new i = 0; i != MAX_GARBAGE_BINS; i ++) if(GarbageData[i][garbageExists] && IsPlayerInRangeOfPoint(playerid, 3.0, GarbageData[i][garbagePos][0], GarbageData[i][garbagePos][1], GarbageData[i][garbagePos][2]))
	{
		if(GetPlayerInterior(playerid) == GarbageData[i][garbageInterior] && GetPlayerVirtualWorld(playerid) == GarbageData[i][garbageWorld])
			return i;
	}
	return -1;
}

stock Garbage_Refresh(garbageid)
{
	if(garbageid != -1 && GarbageData[garbageid][garbageExists])
	{
	    if(IsValidDynamic3DTextLabel(GarbageData[garbageid][garbageText3D]))
	        DestroyDynamic3DTextLabel(GarbageData[garbageid][garbageText3D]);

		if(IsValidDynamicObject(GarbageData[garbageid][garbageObject]))
		    DestroyDynamicObject(GarbageData[garbageid][garbageObject]);

		new
			string[256];

		format(string, sizeof(string), ""WHITE"[ID: %d]\n%d/20", garbageid, GarbageData[garbageid][garbageCapacity]);

		GarbageData[garbageid][garbageText3D] = CreateDynamic3DTextLabel(string, COLOR_YGREEN, GarbageData[garbageid][garbagePos][0], GarbageData[garbageid][garbagePos][1], GarbageData[garbageid][garbagePos][2] + 1.0, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, GarbageData[garbageid][garbageWorld], GarbageData[garbageid][garbageInterior]);
		GarbageData[garbageid][garbageObject] = CreateDynamicObject(GarbageData[garbageid][garbageModel], GarbageData[garbageid][garbagePos][0], GarbageData[garbageid][garbagePos][1], GarbageData[garbageid][garbagePos][2], 0.0, 0.0, GarbageData[garbageid][garbagePos][3], GarbageData[garbageid][garbageWorld], GarbageData[garbageid][garbageInterior]);
	}
	return 1;
}

stock Garbage_Save(garbageid)
{
	new
	    query[300];

	format(query, sizeof(query), "UPDATE `job_garbage` SET `garbageModel` = '%d', `garbageCapacity` = '%d', `garbageX` = '%.4f', `garbageY` = '%.4f', `garbageZ` = '%.4f', `garbageA` = '%.4f', `garbageInterior` = '%d', `garbageWorld` = '%d' WHERE `garbageID` = '%d'",
        GarbageData[garbageid][garbageModel],
        GarbageData[garbageid][garbageCapacity],
        GarbageData[garbageid][garbagePos][0],
        GarbageData[garbageid][garbagePos][1],
        GarbageData[garbageid][garbagePos][2],
        GarbageData[garbageid][garbagePos][3],
        GarbageData[garbageid][garbageInterior],
        GarbageData[garbageid][garbageWorld],
        GarbageData[garbageid][garbageID]
	);
	return mysql_tquery(connectionID, query);
}

forward Garbage_Load();
public Garbage_Load()
{
    static
	    rows,
	    fields;

	cache_get_data(rows, fields, connectionID);

	for (new i = 0; i < rows; i ++) if(i < MAX_GARBAGE_BINS)
	{
	    GarbageData[i][garbageExists] = true;
	    GarbageData[i][garbageID] = cache_get_field_content_int(i, "garbageID");
	    GarbageData[i][garbageModel] = cache_get_field_content_int(i, "garbageModel");
	    GarbageData[i][garbageCapacity] = cache_get_field_content_int(i, "garbageCapacity");
	    GarbageData[i][garbagePos][0] = cache_get_field_content_float(i, "garbageX");
        GarbageData[i][garbagePos][1] = cache_get_field_content_float(i, "garbageY");
        GarbageData[i][garbagePos][2] = cache_get_field_content_float(i, "garbageZ");
        GarbageData[i][garbagePos][3] = cache_get_field_content_float(i, "garbageA");
        GarbageData[i][garbageInterior] = cache_get_field_content_int(i, "garbageInterior");
		GarbageData[i][garbageWorld] = cache_get_field_content_int(i, "garbageWorld");

		Garbage_Refresh(i);
	}
	return 1;
}