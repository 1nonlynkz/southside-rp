#define MAX_IMPOUND_LOTS		50

enum impoundInfo
{
    imID,
	imExists,
	Float:imPosX,
 	Float:imPosY,
 	Float:imPosZ,
 	Float:imPosA,
 	imLabel,
 	Text3D: imTextID,
};
new ImpoundData[MAX_IMPOUND_LOTS][impoundInfo];

ReloadImpound(imid)
{
	new string[500];
	if(ImpoundData[imid][imExists])
	{
	    DestroyDynamic3DTextLabel(ImpoundData[imid][imTextID]);

	    if(ImpoundData[imid][imLabel])
	    {
			format(string, sizeof(string), "Impound Yard \nType /impound to impound a vehicle\nID: %d", imid);
			ImpoundData[imid][imTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, ImpoundData[imid][imPosX], ImpoundData[imid][imPosY], ImpoundData[imid][imPosZ]+0.5,30.0);
	    }
	}
}

GetNearbyImpound(playerid)
{
	for(new i = 0; i < MAX_IMPOUND_LOTS; i ++)
	{
	    if(ImpoundData[i][imLabel] && IsPlayerInRangeOfPoint(playerid, 3.0, ImpoundData[i][imPosX], ImpoundData[i][imPosY], ImpoundData[i][imPosZ]))
	    {
	        return i;
	    }
	}
	return -1;
}

forward OnAdminCreateImpound(playerid, imid, Float:x, Float:y, Float:z, Float:a);
public OnAdminCreateImpound(playerid, imid, Float:x, Float:y, Float:z, Float:a)
{
    ImpoundData[imid][imID] = cache_insert_id(connectionID);
	ImpoundData[imid][imExists] = 1;
    ImpoundData[imid][imPosX] = x;
    ImpoundData[imid][imPosY] = y;
    ImpoundData[imid][imPosZ] = z;
    ImpoundData[imid][imPosA] = a;
	ImpoundData[imid][imTextID] = Text3D:INVALID_3DTEXT_ID;
    ImpoundData[imid][imLabel] = 1;

	ReloadImpound(imid);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has created impound at %s.", GetStaffRank(playerid), GetRPName(playerid), GetZoneName(x, y, z));
}

forward LoadImpound();
public LoadImpound()
{
	new rows = cache_get_row_count(connectionID);
	for(new i = 0; i < rows && i < MAX_IMPOUND_LOTS; i ++)
	{
		ImpoundData[i][imID] = cache_get_field_content_int(i, "id");
		ImpoundData[i][imPosX] = cache_get_field_content_float(i, "pos_x");
		ImpoundData[i][imPosY] = cache_get_field_content_float(i, "pos_y");
		ImpoundData[i][imPosZ] = cache_get_field_content_float(i, "pos_z");
		ImpoundData[i][imPosA] = cache_get_field_content_float(i, "pos_r");
		ImpoundData[i][imLabel] = cache_get_field_content_int(i, "label");
		ImpoundData[i][imTextID] = Text3D:INVALID_3DTEXT_ID;
		ImpoundData[i][imExists] = 1;
		ReloadImpound(i);
	}
}

CMD:createimpound(playerid, params[])
{
    new Float:x, Float:y, Float:z, Float:a;
	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
    GetPlayerPos(playerid, x, y, z);
 	GetPlayerFacingAngle(playerid, a);
    for(new i = 0; i < MAX_IMPOUND_LOTS; i ++)
	{
		if(!ImpoundData[i][imExists])
		{
		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO impound (pos_x, pos_y, pos_z, pos_r) VALUES('%f', '%f', '%f', '%f')", x, y, z, a);
		    mysql_tquery(connectionID, queryBuffer, "OnAdminCreateImpound", "iiffff", playerid, i, x, y, z, a);
		    return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "impound slots are currently full. Ask developers to increase the internal limit.");
	return 1;
}

CMD:destroyimpound(playerid, params[])
{
	new loc;

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", loc))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /destroyimpound [ID] (/nearest)");
	}
	if(!(0 <= loc < MAX_IMPOUND_LOTS) || !ImpoundData[loc][imExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid impound or Static.");
	}
    DestroyDynamic3DTextLabel(ImpoundData[loc][imTextID]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM impound WHERE id = %i", ImpoundData[loc][imID]);
	mysql_tquery(connectionID, queryBuffer);
	ImpoundData[loc][imExists] = false;
	ImpoundData[loc][imID] = 0;

	SendMessage(playerid, COLOR_WHITE, "** You have removed impound [%i].", loc);
	return 1;
}
