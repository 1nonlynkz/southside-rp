#define MAX_DELIVER_PATIENT		50

enum dpTEnum
{
    dpID,
	dpExists,
	Float:dpPosX,
 	Float:dpPosY,
 	Float:dpPosZ,
 	Float:dpPosA,
 	dpLabel,
 	Text3D: dpTextID,
};
new DeliverPatientData[MAX_DELIVER_PATIENT][dpTEnum];

ReloadDeliverPatient(id)
{
	new string[500];
	if(DeliverPatientData[id][dpExists])
	{
	    DestroyDynamic3DTextLabel(DeliverPatientData[id][dpTextID]);

	    if(DeliverPatientData[id][dpLabel])
	    {
			format(string, sizeof(string), "/deliverpatient\nto drop off a patient.\n{FFFFFF}ID: %d", id);
			DeliverPatientData[id][dpTextID] = CreateDynamic3DTextLabel(string, COLOR_DOCTOR, DeliverPatientData[id][dpPosX], DeliverPatientData[id][dpPosY], DeliverPatientData[id][dpPosZ]+0.5,5.0);
	    }
	}
}

GetNearbyDeliverPatient(playerid)
{
	for(new i = 0; i < MAX_DELIVER_PATIENT; i ++)
	{
	    if(DeliverPatientData[i][dpLabel] && IsPlayerInRangeOfPoint(playerid, 3.0, DeliverPatientData[i][dpPosX], DeliverPatientData[i][dpPosY], DeliverPatientData[i][dpPosZ]))
	    {
	        return i;
	    }
	}
	return -1;
}

forward OnAdminCreateDeliverPatient(playerid, id, Float:x, Float:y, Float:z, Float:a);
public OnAdminCreateDeliverPatient(playerid, id, Float:x, Float:y, Float:z, Float:a)
{
    DeliverPatientData[id][dpID] = cache_insert_id(connectionID);
	DeliverPatientData[id][dpExists] = 1;
    DeliverPatientData[id][dpPosX] = x;
    DeliverPatientData[id][dpPosY] = y;
    DeliverPatientData[id][dpPosZ] = z;
    DeliverPatientData[id][dpPosA] = a;
	DeliverPatientData[id][dpTextID] = Text3D:INVALID_3DTEXT_ID;
    DeliverPatientData[id][dpLabel] = 1;

	ReloadDeliverPatient(id);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has created deliver patient at %s.", GetStaffRank(playerid), GetRPName(playerid), GetZoneName(x, y, z));
}

forward LoadDeliverPatient();
public LoadDeliverPatient()
{
	new rows = cache_get_row_count(connectionID);
	for(new i = 0; i < rows && i < MAX_DELIVER_PATIENT; i ++)
	{
		DeliverPatientData[i][dpID] = cache_get_field_content_int(i, "id");
		DeliverPatientData[i][dpPosX] = cache_get_field_content_float(i, "pos_x");
		DeliverPatientData[i][dpPosY] = cache_get_field_content_float(i, "pos_y");
		DeliverPatientData[i][dpPosZ] = cache_get_field_content_float(i, "pos_z");
		DeliverPatientData[i][dpPosA] = cache_get_field_content_float(i, "pos_a");
		DeliverPatientData[i][dpLabel] = cache_get_field_content_int(i, "label");
		DeliverPatientData[i][dpTextID] = Text3D:INVALID_3DTEXT_ID;
		DeliverPatientData[i][dpExists] = 1;
		ReloadDeliverPatient(i);
	}
}

CMD:createdeliverpt(playerid, params[])
{
    new Float:x, Float:y, Float:z, Float:a;
	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
    GetPlayerPos(playerid, x, y, z);
 	GetPlayerFacingAngle(playerid, a);
    for(new i = 0; i < MAX_DELIVER_PATIENT; i ++)
	{
		if(!DeliverPatientData[i][dpExists])
		{
		    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO deliver_patient (pos_x, pos_y, pos_z, pos_a) VALUES('%f', '%f', '%f', '%f')", x, y, z, a);
		    mysql_tquery(connectionID, queryBuffer, "OnAdminCreateDeliverPatient", "iiffff", playerid, i, x, y, z, a);
		    return 1;
		}
	}

	SendClientMessage(playerid, COLOR_GREY, "deliver patient slots are currently full. Ask developers to increase the internal limit.");
	return 1;
}

CMD:destroydeliverpt(playerid, params[])
{
	new loc;

	if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "i", loc))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /destroydeliverpt [ID]");
	}
	if(!(0 <= loc < MAX_DELIVER_PATIENT) || !DeliverPatientData[loc][dpExists])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Invalid deliver patient or Static.");
	}
    DestroyDynamic3DTextLabel(DeliverPatientData[loc][dpTextID]);

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM deliver_patient WHERE id = %i", DeliverPatientData[loc][dpID]);
	mysql_tquery(connectionID, queryBuffer);
	DeliverPatientData[loc][dpExists] = false;
	DeliverPatientData[loc][dpID] = 0;

	SendMessage(playerid, COLOR_WHITE, "** You have removed deliver patient [%i].", loc);
	return 1;
}
