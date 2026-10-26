#define MAX_ARREST_POINT		50

enum ArrestEnum
{
    arID,
	arExists,
	Float:arPosX,
 	Float:arPosY,
 	Float:arPosZ,
 	Float:arPosA,
 	arLabel,
 	Text3D: arTextID,
};
new ArrestData[MAX_ARREST_POINT][ArrestEnum];

ReloadArrestPoint(id)
{
	new string[500];
	if(ArrestData[id][arExists])
	{
	    DestroyDynamic3DTextLabel(ArrestData[id][arTextID]);

	    if(ArrestData[id][arLabel])
	    {
			format(string, sizeof(string), "Arrest Point\n{FFFFFF}Type /arrest to arrest a suspect\n{FFFFFF}ID: %d", id);
			ArrestData[id][arTextID] = CreateDynamic3DTextLabel(string, COLOR_BLUE, ArrestData[id][arPosX], ArrestData[id][arPosY], ArrestData[id][arPosZ]+0.5,5.0);
	    }
	}
}

GetNearbyArrestPoint(playerid)
{
	for(new i = 0; i < MAX_ARREST_POINT; i ++)
	{
	    if(ArrestData[i][arLabel] && IsPlayerInRangeOfPoint(playerid, 3.0, ArrestData[i][arPosX], ArrestData[i][arPosY], ArrestData[i][arPosZ]))
	    {
	        return i;
	    }
	}
	return -1;
}

forward OnAdminCreateArrestPoint(playerid, id, Float:x, Float:y, Float:z, Float:a);
public OnAdminCreateArrestPoint(playerid, id, Float:x, Float:y, Float:z, Float:a)
{
    ArrestData[id][arID] = cache_insert_id(connectionID);
	ArrestData[id][arExists] = 1;
    ArrestData[id][arPosX] = x;
    ArrestData[id][arPosY] = y;
    ArrestData[id][arPosZ] = z;
    ArrestData[id][arPosA] = a;
	ArrestData[id][arTextID] = Text3D:INVALID_3DTEXT_ID;
    ArrestData[id][arLabel] = 1;

	ReloadArrestPoint(id);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has created arrest point at %s.", GetStaffRank(playerid), GetRPName(playerid), GetZoneName(x, y, z));
}

forward LoadArrestPoint();
public LoadArrestPoint()
{
	new rows = cache_get_row_count(connectionID);
	for(new i = 0; i < rows && i < MAX_ARREST_POINT; i ++)
	{
		ArrestData[i][arID] = cache_get_field_content_int(i, "id");
		ArrestData[i][arPosX] = cache_get_field_content_float(i, "pos_x");
		ArrestData[i][arPosY] = cache_get_field_content_float(i, "pos_y");
		ArrestData[i][arPosZ] = cache_get_field_content_float(i, "pos_z");
		ArrestData[i][arPosA] = cache_get_field_content_float(i, "pos_a");
		ArrestData[i][arLabel] = cache_get_field_content_int(i, "label");
		ArrestData[i][arTextID] = Text3D:INVALID_3DTEXT_ID;
		ArrestData[i][arExists] = 1;
		ReloadArrestPoint(i);
	}
}

CMD:createarrestpoint(playerid, params[])
{
    new Float:x, Float:y, Float:z, Float:a;
	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
    GetPlayerPos(playerid, x, y, z);
 	GetPlayerFacingAngle(playerid, a);
    for(new i = 0; i < MAX_ARREST_POINT; i ++)
	{
		if(!ArrestData[i][arExists])
		{
		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO arrest_point (pos_x, pos_y, pos_z, pos_a) VALUES('%f', '%f', '%f', '%f')", x, y, z, a);
		    mysql_tquery(connectionID, queryBuffer, "OnAdminCreateArrestPoint", "iiffff", playerid, i, x, y, z, a);
		    return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "arrest point slots are currently full. Ask developers to increase the internal limit.");
	return 1;
}

CMD:destroyarrespoint(playerid, params[])
{
	new loc;

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", loc))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /destroyarrespoint [ID]");
	}
	if(!(0 <= loc < MAX_ARREST_POINT) || !ArrestData[loc][arExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid arrest point or Static.");
	}
    DestroyDynamic3DTextLabel(ArrestData[loc][arTextID]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM arrest_point WHERE id = %i", ArrestData[loc][arID]);
	mysql_tquery(connectionID, queryBuffer);
	ArrestData[loc][arExists] = false;
	ArrestData[loc][arID] = 0;

	SendMessage(playerid, COLOR_WHITE, "** You have removed arrest point [%i].", loc);
	return 1;
}
