#include <YSI_Coding\y_hooks> 

#define MAX_DYNAMIC_ACTORS (100)
#define MAX_ACTORANIMS     (49)

new gstr[2056];

enum ACTOR_ANIMS
{
	AnimName[64],
	AnimLibrary[64],
	AnimationName[64],
	Float:AnimDelta,
	AnimLoop,
	AnimLockX,
	AnimLockY,
	AnimFreeze,
	AnimTime
};
new AnimData[MAX_ACTORANIMS][ACTOR_ANIMS] =
{
	{"/handsup", "ROB_BANK","SHP_HandsUp_Scr", 4.0, 0, 1, 1, 1, 0},
	{"/crossarms", "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1},
	{"/lay", "BEACH", "bather", 4.0, 1, 0, 0, 0, 0},
	{"/hide", "ped", "cower", 3.0, 1, 0, 0, 0, 0},
	{"/wave", "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0},
	{"/crack",  "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0},
	{"/wounded", "CRACK", "crckidle1", 4.0, 1, 0, 0, 0, 0},
	{"/sleep", "CRACK", "crckidle2", 4.0, 1, 0, 0, 0, 0},
	{"/gro (/groundsit)", "BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0},
	{"/chat", "PED","IDLE_CHAT",4.0,1,0,0,1,1},
	{"/sit", "PED","SEAT_down",4.0,0,0,0,1,0},
	{"/fsit", "SUNBATHE","SBATHE_F_LieB2Sit",4.0,0,0,0,1,0},
	{"/fall", "PED","KO_skid_front",4.0,0,1,1,1,0},
	{"/fall2", "PED", "BIKE_fall_off",4.0,0,1,1,1,0},
	{"/fallback", "PED","FLOOR_hit_f", 4.0, 1, 0, 0, 0, 0},
	{"/injured", "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0},
	{"/exhaust", "FAT","IDLE_tired",3.0,1,0,0,0,0},
	{"/lay2", "SUNBATHE","Lay_Bac_in",3.0,0,1,1,1,0},
	{"/chant", "RIOT","RIOT_CHANT",4.0,1,1,1,1,0},
	{"/dealstance", "DEALER","DEALER_IDLE",4.0,1,0,0,0,0},
	{"/lean 1", "GANGS","leanIDLE",4.0,0,1,1,1,0},
	{"/lean 2", "MISC","Plyrlean_loop",4.0,0,1,1,1,0},
	{"/lean 3", "RYDER","Van_Lean_R",4.0,0,1,1,1,0},
	{"/strip 1", "STRIP", "strip_A", 4.1, 1, 1, 1, 1, 1},
	{"/strip 2", "STRIP", "strip_B", 4.1, 1, 1, 1, 1, 1},
	{"/strip 3", "STRIP", "strip_C", 4.1, 1, 1, 1, 1, 1},
	{"/strip 4", "STRIP", "strip_D", 4.1, 1, 1, 1, 1, 1},
	{"/strip 5", "STRIP", "strip_E", 4.1, 1, 1, 1, 1, 1},
	{"/strip 6", "STRIP", "strip_F", 4.1, 1, 1, 1, 1, 1},
	{"/strip 7", "STRIP", "strip_G", 4.1, 1, 1, 1, 1, 1},
	{"/dance 1", "DANCING", "DAN_Loop_A", 4.1, 1, 1, 1, 1, 1},
	{"/dance 2", "DANCING", "dnce_M_a", 4.1, 1, 1, 1, 1, 1},
	{"/dance 3", "DANCING", "dnce_M_b", 4.1, 1, 1, 1, 1, 1},
	{"/dance 4", "DANCING", "dnce_M_c", 4.1, 1, 1, 1, 1, 1},
	{"/dance 5", "DANCING", "dnce_M_d", 4.1, 1, 1, 1, 1, 1},
	{"/dance 6", "DANCING", "dnce_M_e", 4.1, 1, 1, 1, 1, 1},
	{"/dance 7", "DANCING", "bd_clap1", 4.1, 1, 1, 1, 1, 1},
	{"/relax", "BAR", "BARman_idle", 4.0, 1, 0, 0, 0, 0},
	{"/angry", "RIOT", "RIOT_ANGRY", 4.0, 1, 0, 0, 0, 0},
	{"/cheer", "RIOT", "RIOT_ANGRY_B", 4.0, 1, 0, 0, 0, 0},
	{"/sit 1", "PED", "IDLE_CHAT", 4.1, 1, 1, 1, 1, 1},
	{"/sit 2", "GANGS", "prtial_gngtlkA", 4.1, 1, 1, 1, 1, 1},
	{"/sit 3", "GANGS", "prtial_gngtlkB", 4.1, 1, 1, 1, 1, 1},
	{"/sit 4", "GANGS", "prtial_gngtlkC", 4.1, 1, 1, 1, 1, 1},
	{"/sit 5", "GANGS", "prtial_gngtlkD", 4.1, 1, 1, 1, 1, 1},
	{"/sit 6", "GANGS", "prtial_gngtlkE", 4.1, 1, 1, 1, 1, 1},
	{"/sit 7", "GANGS", "prtial_gngtlkF", 4.1, 1, 1, 1, 1, 1},
	{"/sit 8", "GANGS", "prtial_gngtlkG", 4.1, 1, 1, 1, 1, 1},
	{"/sit 9", "GANGS", "prtial_gngtlkH", 4.1, 1, 1, 1, 1, 1}
};

enum actEnum
{
    actor_ID,
    Text3D:actor_Label,
    actorID,
    actorExists,
    actorName[24],
    actorSkin,
    Float:actorX,
    Float:actorY,
    Float:actorZ,
    Float:actorA,
    actorVW,
    actorAnim
};
new ActorInfo[MAX_DYNAMIC_ACTORS][actEnum];

forward LoadDynamicActor();
public LoadDynamicActor()
{
	new rows = cache_num_rows();
	if(rows) 
	{
		for(new i = 0; i < rows; i++) 
		{
			ActorInfo[i][actorExists] = 1;
            ActorInfo[i][actorID] = cache_get_field_content_int(i, "id");
            cache_get_field_content(i, "name", ActorInfo[i][actorName], connectionID, 24);
            ActorInfo[i][actorSkin] = cache_get_field_content_int(i, "skin");
            ActorInfo[i][actorX] = cache_get_field_content_float(i, "x");
            ActorInfo[i][actorY] = cache_get_field_content_float(i, "y");
            ActorInfo[i][actorZ] = cache_get_field_content_float(i, "z");
            ActorInfo[i][actorA] = cache_get_field_content_float(i, "a");
            ActorInfo[i][actorVW] = cache_get_field_content_int(i, "world");
            ActorInfo[i][actorAnim] = cache_get_field_content_int(i, "anim");
            ReloadActor(i);
		}
	}
	return 1;
}

forward OnAdminCreateActor(playerid, actorid, name[], skin, Float:x, Float:y, Float:z, Float:angle, world, anim);
public OnAdminCreateActor(playerid, actorid, name[], skin, Float:x, Float:y, Float:z, Float:angle, world, anim)
{
	strcpy(ActorInfo[actorid][actorName], name, 24);
	ActorInfo[actorid][actorID] = cache_insert_id(connectionID);
	ActorInfo[actorid][actorSkin] = skin;
	ActorInfo[actorid][actorX] = x;
	ActorInfo[actorid][actorY] = y;
	ActorInfo[actorid][actorZ] = z;
	ActorInfo[actorid][actorA] = angle;
	ActorInfo[actorid][actorVW] = world;
    ActorInfo[actorid][actorAnim] = anim;
	ActorInfo[actorid][actorExists] = 1;

	ReloadActor(actorid);
	
	new message[144];
	format(message, sizeof(message), "{318CE7}[ACTOR SYSTEM]: {FFFFFF}Actor {32CD32}'%s' {FFFFFF}has been created successfully! (Slot ID: {FFD700}%d{FFFFFF})", name, actorid);
	SendClientMessage(playerid, -1, message);
	return 1;
} 

CMD:loadactor(playerid, param[])
{
	if(PlayerInfo[playerid][pAdmin] < 7)
	    return SendClientMessage(playerid, -1, "{FF4C4C}[ERROR]: {FFFFFF}You are not authorized to use this command.");

	for(new i = 0; i < MAX_DYNAMIC_ACTORS; i++)
	{
		if(ActorInfo[i][actorExists])
		{
			ApplyDynamicActorAnim(ActorInfo[i][actor_ID], ActorInfo[i][actorAnim]);
		}
	}
	SendClientMessage(playerid, -1, "{318CE7}[ACTOR SYSTEM]: {FFFFFF}All actor animations have been reloaded.");
	return 1;
}

CMD:createactor(playerid, params[])
{
	new name[24], world = GetPlayerVirtualWorld(playerid), anim = -1, skin, Float:x, Float:y, Float:z, Float:a;

    if(PlayerInfo[playerid][pAdmin] < 7)
	    return SendClientMessage(playerid, -1, "{FF4C4C}[ERROR]: {FFFFFF}You are not authorized to use this command.");

	if(sscanf(params, "s[24]d", name, skin))
		return SendClientMessage(playerid, -1, "{318CE7}[USAGE]: {FFFFFF}/createactor [Name] [Skin ID]");

	if(skin < 0 || skin == 74 || skin > 311)
		return SendClientMessage(playerid, -1, "{FF4C4C}[ERROR]: {FFFFFF}Invalid Skin ID specified.");

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

 	for(new i = 0; i < MAX_DYNAMIC_ACTORS; i++)
	{
	    if(!ActorInfo[i][actorExists])
	    {		
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO actors (name, skin, x, y, z, a, world, anim) VALUES('%e', %d, %f, %f, %f, %f, %d, %d)", name, skin, x, y, z, a, world, anim);
			mysql_tquery(connectionID, queryBuffer, "OnAdminCreateActor", "iisiffffii", playerid, i, name, skin, x, y, z, a, world, anim);
			return 1;
		}
	}

	SendClientMessage(playerid, -1, "{FF4C4C}[ERROR]: {FFFFFF}Actor slots are currently full. Contact management.");
	return 1;
}

CMD:editactor(playerid, params[])
{
	new actorid, option[14], param[64], message[144];

	if(PlayerInfo[playerid][pAdmin] < 7)
	    return SendClientMessage(playerid, -1, "{FF4C4C}[ERROR]: {FFFFFF}You are not authorized to use this command.");

	if(sscanf(params, "is[14]S()[64]", actorid, option, param))
	{
	    SendClientMessage(playerid, -1, "{318CE7}[USAGE]: {FFFFFF}/editactor [Actor ID] [Option]");
	    SendClientMessage(playerid, -1, "{888888}Available Options: {FFFFFF}Name, Skin, Position, World, Animation");
	    return 1;
	}
	if(!(0 <= actorid < MAX_DYNAMIC_ACTORS) || !ActorInfo[actorid][actorExists])
	    return SendClientMessage(playerid, -1, "{FF4C4C}[ERROR]: {FFFFFF}Invalid or non-existent actor slot.");

	if(!strcmp(option, "name", true))
	{
		new name[24];
		if(sscanf(param, "s[24]", name))
			return SendClientMessage(playerid, -1, "{318CE7}[USAGE]: {FFFFFF}/editactor [Actor ID] name [New Name]");

		strcpy(ActorInfo[actorid][actorName], name, 24);

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE actors SET name = '%e' WHERE id = %i", ActorInfo[actorid][actorName], ActorInfo[actorid][actorID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ReloadActor(actorid);
	    
	    format(message, sizeof(message), "{318CE7}[ACTOR SYSTEM]: {FFFFFF}Changed Actor ID {FFD700}%d{FFFFFF}'s name to: {32CD32}%s", actorid, name);
	    SendClientMessage(playerid, -1, message);
	}
	else if(!strcmp(option, "skin", true))
	{
		new skin;
		if(sscanf(param, "d", skin))
			return SendClientMessage(playerid, -1, "{318CE7}[USAGE]: {FFFFFF}/editactor [Actor ID] skin [Skin ID]");
			
		if(skin < 0 || skin == 74 || skin > 311)
			return SendClientMessage(playerid, -1, "{FF4C4C}[ERROR]: {FFFFFF}Invalid Skin ID.");

		ActorInfo[actorid][actorSkin] = skin;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE actors SET skin = %d WHERE id = %i", ActorInfo[actorid][actorSkin], ActorInfo[actorid][actorID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ReloadActor(actorid);
	    
	    format(message, sizeof(message), "{318CE7}[ACTOR SYSTEM]: {FFFFFF}Changed Actor ID {FFD700}%d{FFFFFF}'s skin to ID: {32CD32}%d", actorid, skin);
	    SendClientMessage(playerid, -1, message);
	}
	else if(!strcmp(option, "position", true))
	{
		GetPlayerPos(playerid, ActorInfo[actorid][actorX], ActorInfo[actorid][actorY], ActorInfo[actorid][actorZ]);
		GetPlayerFacingAngle(playerid, ActorInfo[actorid][actorA]);
		ActorInfo[actorid][actorVW] = GetPlayerVirtualWorld(playerid);
		
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE actors SET x = %f, y = %f, z = %f, a = %f, world = %d WHERE id = %i", ActorInfo[actorid][actorX], ActorInfo[actorid][actorY], ActorInfo[actorid][actorZ], ActorInfo[actorid][actorA], ActorInfo[actorid][actorVW], ActorInfo[actorid][actorID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ReloadActor(actorid);
	    
	    format(message, sizeof(message), "{318CE7}[ACTOR SYSTEM]: {FFFFFF}Updated Actor ID {FFD700}%d{FFFFFF}'s position to your location.", actorid);
	    SendClientMessage(playerid, -1, message);
	}
	else if(!strcmp(option, "world", true))
	{
		new world;
		if(sscanf(param, "d", world))
			return SendClientMessage(playerid, -1, "{318CE7}[USAGE]: {FFFFFF}/editactor [Actor ID] world [Virtual World ID]");

		ActorInfo[actorid][actorVW] = world;
		
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE actors SET world = %d WHERE id = %i", ActorInfo[actorid][actorVW], ActorInfo[actorid][actorID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ReloadActor(actorid);
	    
	    format(message, sizeof(message), "{318CE7}[ACTOR SYSTEM]: {FFFFFF}Updated Actor ID {FFD700}%d{FFFFFF}'s virtual world to: {32CD32}%d", actorid, world);
	    SendClientMessage(playerid, -1, message);
	}
	else if(!strcmp(option, "animation", true))
	{
        SetPVarInt(playerid, "EditingActor", actorid);
        new sub[64];
        gstr[0] = EOS;
        strcat(gstr, "{FF4C4C}> Clear Animation\n");
        for(new x = 0; x < MAX_ACTORANIMS; x++)
        {
            format(sub, sizeof(sub), "{FFFFFF}%s\n", AnimData[x][AnimName]);
            strcat(gstr, sub);
        }
        ShowPlayerDialog(playerid, DIALOG_ACTOR, DIALOG_STYLE_LIST, "{318CE7}Select Actor Animation", gstr, "Select", "Cancel");
	}
	return 1;
}

CMD:removeactor(playerid, params[])
{
	new actorid, message[144];

	if(PlayerInfo[playerid][pAdmin] < 7)
	    return SendClientMessage(playerid, -1, "{FF4C4C}[ERROR]: {FFFFFF}You are not authorized to use this command.");

	if(sscanf(params, "i", actorid))
	    return SendClientMessage(playerid, -1, "{318CE7}[USAGE]: {FFFFFF}/removeactor [Actor ID]");

	if(!(0 <= actorid < MAX_DYNAMIC_ACTORS) || !ActorInfo[actorid][actorExists])
	    return SendClientMessage(playerid, -1, "{FF4C4C}[ERROR]: {FFFFFF}Invalid or non-existent actor slot.");

	if(IsValidDynamic3DTextLabel(ActorInfo[actorid][actor_Label])) {
		DestroyDynamic3DTextLabel(ActorInfo[actorid][actor_Label]);
	}
	if(IsValidActor(ActorInfo[actorid][actor_ID])) {
		DestroyActor(ActorInfo[actorid][actor_ID]);
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM actors WHERE id = %i", ActorInfo[actorid][actorID]);
	mysql_tquery(connectionID, queryBuffer);

	ActorInfo[actorid][actorExists] = 0;
	ActorInfo[actorid][actorID] = 0;

	format(message, sizeof(message), "{318CE7}[ACTOR SYSTEM]: {FFFFFF}Successfully removed Actor ID: {FFD700}%i{FFFFFF}.", actorid);
	SendClientMessage(playerid, -1, message);
	return 1;
}

ReloadActor(actorid)
{
	if(ActorInfo[actorid][actorExists])
	{
		new string[160], name[24];
		strcpy(name, ActorInfo[actorid][actorName], 24);
		
		for(new i = 0, l = strlen(name); i < l; i++)
		{
			if(name[i] == '_') name[i] = ' ';
		}		

		if(IsValidActor(ActorInfo[actorid][actor_ID])) {
			DestroyActor(ActorInfo[actorid][actor_ID]);
		}
		if(IsValidDynamic3DTextLabel(ActorInfo[actorid][actor_Label])) {
			DestroyDynamic3DTextLabel(ActorInfo[actorid][actor_Label]);
		}

		ActorInfo[actorid][actor_ID] = CreateActor(ActorInfo[actorid][actorSkin], ActorInfo[actorid][actorX], ActorInfo[actorid][actorY], ActorInfo[actorid][actorZ], ActorInfo[actorid][actorA]);
		SetActorVirtualWorld(ActorInfo[actorid][actor_ID], ActorInfo[actorid][actorVW]);

		format(string, sizeof(string), "{FFD700}[ID: %d]\n{FFFFFF}%s", actorid, name);
		
		ActorInfo[actorid][actor_Label] = CreateDynamic3DTextLabel(
			string, 0xFFFFFFFF, 
			ActorInfo[actorid][actorX], ActorInfo[actorid][actorY], ActorInfo[actorid][actorZ] + 0.95, 
			8.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 
			ActorInfo[actorid][actorVW], -1, -1, 8.0
		);

		ApplyDynamicActorAnim(ActorInfo[actorid][actor_ID], ActorInfo[actorid][actorAnim]);
	}
	return 1;
}

stock ApplyDynamicActorAnim(actorid, animid)
{
	if(animid >= 0 && animid < MAX_ACTORANIMS) 
	{
		ApplyActorAnimation(
			actorid, 
			AnimData[animid][AnimLibrary], 
			AnimData[animid][AnimationName], 
			AnimData[animid][AnimDelta], 
			bool:AnimData[animid][AnimLoop], 
			bool:AnimData[animid][AnimLockX], 
			bool:AnimData[animid][AnimLockY], 
			bool:AnimData[animid][AnimFreeze], 
			AnimData[animid][AnimTime]
		);
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(PlayerInfo[playerid][pKicked]) return 0;
	for(new i = 0, l = strlen(inputtext); i < l; i++) if(inputtext[i] == '%') inputtext[i] = '#';
	
	if(dialogid == DIALOG_ACTOR)
    {
        if(!response) return DeletePVar(playerid, "EditingActor");
        else
        {
            new a = GetPVarInt(playerid, "EditingActor");
            if(listitem == 0)
            {
                ClearActorAnimations(ActorInfo[a][actor_ID]);
                ActorInfo[a][actorAnim] = -1;
            }
            else
            {
                new x = listitem - 1;
                ActorInfo[a][actorAnim] = x;
                ApplyDynamicActorAnim(ActorInfo[a][actor_ID], ActorInfo[a][actorAnim]);
            }

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE actors SET anim = %d WHERE id = %i", ActorInfo[a][actorAnim], ActorInfo[a][actorID]);
            mysql_tquery(connectionID, queryBuffer);

            new message[144];
            format(message, sizeof(message), "{318CE7}[ACTOR SYSTEM]: {FFFFFF}Updated animation for Actor ID: {FFD700}%d{FFFFFF}.", a);
            SendClientMessage(playerid, -1, message);
            
            DeletePVar(playerid, "EditingActor");
            return 1;
        }
    }
	return 1;
}