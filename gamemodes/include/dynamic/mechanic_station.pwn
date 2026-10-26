#define MAX_MECH_STATION		50

enum MechStationEnum
{
    mechID,
	mechExists,
	Float:mechPosX,
 	Float:mechPosY,
 	Float:mechPosZ,
 	Float:mechPosA,
 	mechLabel,
 	Text3D: mechTextID,
};
new MechStationData[MAX_MECH_STATION][MechStationEnum];

ReloadMechStation(id)
{
	new string[500];
	if(MechStationData[id][mechExists])
	{
	    DestroyDynamic3DTextLabel(MechStationData[id][mechTextID]);

	    if(MechStationData[id][mechLabel])
	    {
			format(string, sizeof(string), "Mechanic Station\nType /upgradecar and /tune\n{FFFFFF}ID: %d", id);
			MechStationData[id][mechTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, MechStationData[id][mechPosX], MechStationData[id][mechPosY], MechStationData[id][mechPosZ]+0.5,30.0);
	    }
	}
}

GetNearbyMechStation(playerid)
{
	for(new i = 0; i < MAX_MECH_STATION; i ++)
	{
	    if(MechStationData[i][mechLabel] && IsPlayerInRangeOfPoint(playerid, 3.0, MechStationData[i][mechPosX], MechStationData[i][mechPosY], MechStationData[i][mechPosZ]))
	    {
	        return i;
	    }
	}
	return -1;
}

forward OnAdminCreateMechStation(playerid, id, Float:x, Float:y, Float:z, Float:a);
public OnAdminCreateMechStation(playerid, id, Float:x, Float:y, Float:z, Float:a)
{
    MechStationData[id][mechID] = cache_insert_id(connectionID);
	MechStationData[id][mechExists] = 1;
    MechStationData[id][mechPosX] = x;
    MechStationData[id][mechPosY] = y;
    MechStationData[id][mechPosZ] = z;
    MechStationData[id][mechPosA] = a;
	MechStationData[id][mechTextID] = Text3D:INVALID_3DTEXT_ID;
    MechStationData[id][mechLabel] = 1;

	ReloadMechStation(id);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has created mechanic station at %s.", GetStaffRank(playerid), GetRPName(playerid), GetZoneName(x, y, z));
}

forward LoadMechStation();
public LoadMechStation()
{
	new rows = cache_get_row_count(connectionID);
	for(new i = 0; i < rows && i < MAX_MECH_STATION; i ++)
	{
		MechStationData[i][mechID] = cache_get_field_content_int(i, "id");
		MechStationData[i][mechPosX] = cache_get_field_content_float(i, "pos_x");
		MechStationData[i][mechPosY] = cache_get_field_content_float(i, "pos_y");
		MechStationData[i][mechPosZ] = cache_get_field_content_float(i, "pos_z");
		MechStationData[i][mechPosA] = cache_get_field_content_float(i, "pos_a");
		MechStationData[i][mechLabel] = cache_get_field_content_int(i, "label");
		MechStationData[i][mechTextID] = Text3D:INVALID_3DTEXT_ID;
		MechStationData[i][mechExists] = 1;
		ReloadMechStation(i);
	}
}

CMD:createmechstation(playerid, params[])
{
    new Float:x, Float:y, Float:z, Float:a;
	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
    GetPlayerPos(playerid, x, y, z);
 	GetPlayerFacingAngle(playerid, a);
    for(new i = 0; i < MAX_MECH_STATION; i ++)
	{
		if(!MechStationData[i][mechExists])
		{
		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO mech_station (pos_x, pos_y, pos_z, pos_a) VALUES('%f', '%f', '%f', '%f')", x, y, z, a);
		    mysql_tquery(connectionID, queryBuffer, "OnAdminCreateMechStation", "iiffff", playerid, i, x, y, z, a);
		    return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "mechanic station slots are currently full. Ask developers to increase the internal limit.");
	return 1;
}

CMD:removemechstation(playerid, params[])
{
	new loc;

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", loc))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removemechstation [ID]");
	}
	if(!(0 <= loc < MAX_MECH_STATION) || !MechStationData[loc][mechExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid mechanic station or Static.");
	}
    DestroyDynamic3DTextLabel(MechStationData[loc][mechTextID]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM mech_station WHERE id = %i", MechStationData[loc][mechID]);
	mysql_tquery(connectionID, queryBuffer);
	MechStationData[loc][mechExists] = false;
	MechStationData[loc][mechID] = 0;

	SendMessage(playerid, COLOR_WHITE, "** You have removed mechanic station [%i].", loc);
	return 1;
}
