/*

    Lumberjack Job
        Developed By: Rootcause
        Rework By: Kai
*/

#include <YSI_Coding\y_hooks>

#define     MAX_TREES       (100)   // tree limit
#define     MAX_LOGS        (300)   // dropped log limit
 
#define     CUTTING_TIME    (8)     // required seconds to cut a tree down (Default: 8)
#define     LOG_LIMIT       (10)    // how many logs a player can load to a bobcat (if you change this, don't forget to modify LogAttachOffsets array) (Default: 10)
#define     ATTACH_INDEX    (7)     // for setplayerattachedobject (Default: 7)
#define     TREE_RESPAWN    (300)   // required seconds to respawn a tree (Default: 300)
#define     LOG_LIFETIME    (120)   // life time of a dropped log, in seconds (Default: 120)
#define     LOG_PRICE       (150)

enum    E_TREE
{
    treeID,
    treeExists,
    Float: treeX,
    Float: treeY,
    Float: treeZ,
    Float: treeRX,
    Float: treeRY,
    Float: treeRZ,
    treeInterior,
    treeWorld,
    treeLogs,

    treeSeconds,
    bool: treeGettingCut,
    treeObjID,
    Text3D: treeLabel,
    treeTimer
}
 
enum E_LOG
{
    logDroppedBy[MAX_PLAYER_NAME],
    logSeconds,
    logObjID,
    logTimer,
    Text3D: logLabel
}
 
new
    TreeData[MAX_TREES][E_TREE],
    LogData[MAX_LOGS][E_LOG];
    
new
    Iterator: Trees<MAX_TREES>,
    Iterator: Logs<MAX_LOGS>;
 
new
    LogObjects[MAX_VEHICLES][LOG_LIMIT];
    
new
    CuttingTreeID[MAX_PLAYERS] = {-1, ...},
    CuttingTimer[MAX_PLAYERS] = {-1, ...},
    PlayerBar: CuttingBar[MAX_PLAYERS] = {INVALID_PLAYER_BAR_ID, ...},
    bool: CarryingLog[MAX_PLAYERS],
    EditingTreeID[MAX_PLAYERS] = {-1, ...};
 
new
    Float: LogAttachOffsets[LOG_LIMIT][4] = {
        {-0.223, -1.089, -0.230, -90.399},
        {-0.056, -1.091, -0.230, 90.399},
        {0.116, -1.092, -0.230, -90.399},
        {0.293, -1.088, -0.230, 90.399},
        {-0.123, -1.089, -0.099, -90.399},
        {0.043, -1.090, -0.099, 90.399},
        {0.216, -1.092, -0.099, -90.399},
        {-0.033, -1.090, 0.029, -90.399},
        {0.153, -1.089, 0.029, 90.399},
        {0.066, -1.091, 0.150, -90.399}
    };
 
enum E_LUMBER_ACTOR
{
	lumberActor,
	Float:lumberActorX,
	Float:lumberActorY,
	Float:lumberActorZ,
	Float:lumberActorA
};
new const g_lumberActor[][E_LUMBER_ACTOR] =
{
	// Skin	    Pos X		Pos Y	   Pos Z  	  Pos A
	{  1,	    2369.03, 	-657.991,  128.194,   0.315 }
};

new const Float:LumberVehicleSpawn[][] =
{
	{2393.1187,-666.5900,128.0459,197.0495},
	{2393.6521,-641.6736,127.0249,320.1907}
};

SetPlayerLookAt(playerid, Float:x, Float:y)
{
    // somewhere on samp forums, couldn't find the source
    new Float:Px, Float:Py, Float: Pa;
    GetPlayerPos(playerid, Px, Py, Pa);
    Pa = floatabs(atan((y-Py)/(x-Px)));
    if (x <= Px && y >= Py) Pa = floatsub(180, Pa);
    else if (x < Px && y < Py) Pa = floatadd(Pa, 180);
    else if (x >= Px && y <= Py) Pa = floatsub(360.0, Pa);
    Pa = floatsub(Pa, 90.0);
    if (Pa >= 360.0) Pa = floatsub(Pa, 360.0);
    SetPlayerFacingAngle(playerid, Pa);
}

IsPlayerNearALogBuyer(playerid)
{
    for(new i = 0; i < sizeof(g_lumberActor); i ++)
	{
        if(IsPlayerInRangeOfPoint(playerid, 3.0, g_lumberActor[playerid][lumberActorX], g_lumberActor[playerid][lumberActorY], g_lumberActor[playerid][lumberActorZ])) {
            return 1;
        }
	} 
	return 0;
}
 
ConvertToMinutes(time)
{
    // http://forum.sa-mp.com/showpost.php?p=3223897&postcount=11
    new string[15];//-2000000000:00 could happen, so make the string 15 chars to avoid any errors
    format(string, sizeof(string), "%02d:%02d", time / 60, time % 60);
    return string;
}

GetClosestTree(playerid, Float: range = 2.0)
{
    new id = -1, Float: dist = range, Float: tempdist;
    foreach(new i : Trees)
    {
        if(TreeData[i][treeExists])
        {
            tempdist = GetPlayerDistanceFromPoint(playerid, TreeData[i][treeX], TreeData[i][treeY], TreeData[i][treeZ]);
    
            if(tempdist > range) continue;
            if(tempdist <= dist)
            {
                dist = tempdist;
                id = i;
            }
        }
    }
 
    return id;
}
 
GetClosestLog(playerid, Float: range = 2.0)
{
    new id = -1, Float: dist = range, Float: tempdist, Float: pos[3];
    foreach(new i : Logs)
    {
        GetDynamicObjectPos(LogData[i][logObjID], pos[0], pos[1], pos[2]);
        tempdist = GetPlayerDistanceFromPoint(playerid, pos[0], pos[1], pos[2]);
 
        if(tempdist > range) continue;
        if(tempdist <= dist)
        {
            dist = tempdist;
            id = i;
        }
    }
 
    return id;
}
 
Player_Init(playerid)
{
    CuttingTreeID[playerid] = -1;
    CuttingTimer[playerid] = -1;
    CarryingLog[playerid] = false;
    EditingTreeID[playerid] = -1;
    
    CuttingBar[playerid] = CreatePlayerProgressBar(playerid, 498.0, 104.0, 113.0, 6.2, 0x61381BFF, CUTTING_TIME, progressbar_direction:0);
    return 1;
}
 
Player_ResetCutting(playerid)
{
    if(!IsPlayerConnected(playerid) || CuttingTreeID[playerid] == -1) return 0;
    new id = CuttingTreeID[playerid];
    TreeData[id][treeGettingCut] = false;
    if(TreeData[id][treeSeconds] < 1) Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[id][treeLabel], E_STREAMER_COLOR, 0x2ECC71FF);
    
    ClearAnimations(playerid);
    TogglePlayerControllable(playerid, 1);
    CuttingTreeID[playerid] = -1;
    
    if(CuttingTimer[playerid] != -1)
    {
        KillTimer(CuttingTimer[playerid]);
        CuttingTimer[playerid] = -1;
    }
    
    SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
    HidePlayerProgressBar(playerid, CuttingBar[playerid]);
    return 1;
}
 
Player_GiveLog(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    CarryingLog[playerid] = true;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    SetPlayerAttachedObject(playerid, ATTACH_INDEX, 19793, 6, 0.077999, 0.043999, -0.170999, -13.799953, 79.70, 0.0);
    
    SendClientMessage(playerid, COLOR_WHITE, "You can press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to drop your log.");
    return 1;
}
 
Player_DropLog(playerid, death_drop = 0)
{
    if(!IsPlayerConnected(playerid) || !CarryingLog[playerid]) return 0;
    new id = Iter_Free(Logs);
    if(id != -1)
    {
        new Float: x, Float: y, Float: z, Float: a, label[128];
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);
        GetPlayerName(playerid, LogData[id][logDroppedBy], MAX_PLAYER_NAME);
 
        if(!death_drop)
        {
            x += (1.0 * floatsin(-a, degrees));
            y += (1.0 * floatcos(-a, degrees));
            
            ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, false, true, true, false, 0, SYNC_ALL);
        }
 
        LogData[id][logSeconds] = LOG_LIFETIME;
        LogData[id][logObjID] = CreateDynamicObject(19793, x, y, z - 0.9, 0.0, 0.0, a);
        
        format(label, sizeof(label), "Log (%d)\n\n{FFFFFF}Dropped By {F1C40F}%s\n{FFFFFF}%s\nUse {F1C40F}/log take {FFFFFF}to take it.", id, LogData[id][logDroppedBy], ConvertToMinutes(LOG_LIFETIME));
        LogData[id][logLabel] = CreateDynamic3DTextLabel(label, 0xF1C40FFF, x, y, z - 0.7, 5.0, .testlos = 1);
        
        LogData[id][logTimer] = SetTimerEx("RemoveLog", 1000, true, "i", id);
        Iter_Add(Logs, id);
    }
    
    Player_RemoveLog(playerid);
    return 1;
}
 
Player_RemoveLog(playerid)
{
    if(!IsPlayerConnected(playerid) || !CarryingLog[playerid]) return 0;
    RemovePlayerAttachedObject(playerid, ATTACH_INDEX);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    CarryingLog[playerid] = false;
    return 1;
}
 
Vehicle_LogCount(vehicleid)
{
    if(GetVehicleModel(vehicleid) == 0) return 0;
    new count;
    for(new i; i < LOG_LIMIT; i++) if(IsValidDynamicObject(LogObjects[vehicleid][i])) count++;
    return count;
}
 
Vehicle_RemoveLogs(vehicleid)
{
    if(GetVehicleModel(vehicleid) == 0) return 0;
    for(new i; i < LOG_LIMIT; i++)
    {
        if(IsValidDynamicObject(LogObjects[vehicleid][i]))
        {
            DestroyDynamicObject(LogObjects[vehicleid][i]);
            LogObjects[vehicleid][i] = -1;
        }
    }
    
    return 1;
}
 
Tree_BeingEdited(id)
{
    if(!Iter_Contains(Trees, id)) return 0;
    foreach(new i : Player) if(EditingTreeID[i] == id) return 1;
    return 0;
}
 
Tree_UpdateLogLabel(id)
{
    if(!Iter_Contains(Trees, id)) return 0;
    new label[96];
    
    if(TreeData[id][treeLogs] > 0) {
        format(label, sizeof(label), "Tree [ID: %d]\n{FFFFFF}Logs: %d\nUse /log takefromtree to take a log.", id, TreeData[id][treeLogs]);
        UpdateDynamic3DTextLabelText(TreeData[id][treeLabel], 0xE74C3CFF, label);
    }else{
        TreeData[id][treeTimer] = SetTimerEx("RespawnTree", 1000, true, "i", id);
        
        format(label, sizeof(label), "Tree [ID: %d]\n{FFFFFF}%s", id, ConvertToMinutes(TreeData[id][treeSeconds]));
        UpdateDynamic3DTextLabelText(TreeData[id][treeLabel], 0xE74C3CFF, label);
    }
    
    return 1;
}

Tree_Refresh(id)
{
    new label[128];
    if(TreeData[id][treeExists])
    {
        TreeData[id][treeObjID] = CreateDynamicObject(657, TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ], TreeData[id][treeRX], TreeData[id][treeRY], TreeData[id][treeRZ]);
    
        format(label, sizeof(label), "Tree [ID: %d]\n{FFFFFF}Press ~k~~CONVERSATION_NO~ to cut down.", id);
        TreeData[id][treeLabel] = CreateDynamic3DTextLabel(label, COLOR_WHITE, TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ] + 1.5, 5.0);
    }
}

Tree_Save(id)
{
	new query[768];
	format(query, sizeof(query), "UPDATE `job_lumberjack` SET `treeObject` = '%d', `treePosX` = '%f', `treePosY` = '%f', `treePosZ` = '%f', `treeRotateX` = '%f', `treeRotateY` = '%f', `treeRotateZ` = '%f', `treeInterior` = '%d', `treeWorld` = '%d', `treeLogs` = '%d' WHERE `treeID` = '%d'",
	    TreeData[id][treeObjID],
	    TreeData[id][treeX],
	    TreeData[id][treeY],
	    TreeData[id][treeZ],
	    TreeData[id][treeRX],
	    TreeData[id][treeRY],
	    TreeData[id][treeRZ],
	    TreeData[id][treeInterior],
	    TreeData[id][treeWorld],
	    TreeData[id][treeLogs],
	    TreeData[id][treeID]
	);
	return mysql_tquery(connectionID, query);
}

forward Tree_Load(id);
public Tree_Load(id)
{
    new rows = cache_num_rows();
	if(rows) 
	{
		for(new i; i < rows; i++) 
		{
			if (i >= MAX_TREES) break;

			TreeData[i][treeExists] = true;
			TreeData[i][treeID] = cache_get_field_content_int(i, "treeID");
			TreeData[i][treeObjID] = cache_get_field_content_int(i, "treeObject");

			TreeData[i][treeX] = cache_get_field_content_float(i, "treePosX");
			TreeData[i][treeY] = cache_get_field_content_float(i, "treePosY");
			TreeData[i][treeZ] = cache_get_field_content_float(i, "treePosZ");
			TreeData[i][treeRX] = cache_get_field_content_float(i, "treeRotateX");
			TreeData[i][treeRY] = cache_get_field_content_float(i, "treeRotateY");
			TreeData[i][treeRZ] = cache_get_field_content_float(i, "treeRotateZ");
			TreeData[i][treeInterior] = cache_get_field_content_int(i, "treeInterior");
			TreeData[i][treeWorld] = cache_get_field_content_int(i, "treeWorld");
			TreeData[i][treeWorld] = cache_get_field_content_int(i, "treeLogs");
			Iter_Add(Trees, i);

            Tree_Refresh(i);
        }
    }
}

forward Tree_Create(playerid, id, Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz);
public Tree_Create(playerid, id, Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz)
{
    TreeData[id][treeID] = cache_insert_id(connectionID);
    TreeData[id][treeExists] = 1;
    TreeData[id][treeObjID] = 657;
    TreeData[id][treeLogs] = 5;

    TreeData[id][treeX] = x;
    TreeData[id][treeY] = y;
    TreeData[id][treeZ] = z;
    TreeData[id][treeRX] = rx;
    TreeData[id][treeRY] = ry ;
    TreeData[id][treeRZ] = rz;
    TreeData[id][treeInterior] = GetPlayerInterior(playerid);
    TreeData[id][treeWorld] = GetPlayerVirtualWorld(playerid);
	TreeData[id][treeLabel] = Text3D:INVALID_3DTEXT_ID;
    Iter_Add(Trees, id);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE job_lumberjack SET treeWorld = %i WHERE treeID = %i", TreeData[id][treeWorld], TreeData[id][treeID]);
	mysql_tquery(connectionID, queryBuffer);

	SendMessage(playerid, SERVER_COLOR, "** Lumberjack Tree %i created successfully.", id);
}

hook OnGameModeInit()
{
    new string[128];
    for(new i; i < MAX_TREES; i++)
    {
        TreeData[i][treeObjID] = TreeData[i][treeTimer] = -1;
        TreeData[i][treeLabel] = Text3D: -1;
    }
    
    for(new i; i < MAX_LOGS; i++)
    {
        LogData[i][logObjID] = LogData[i][logTimer] = -1;
        LogData[i][logLabel] = Text3D: -1;
    }
    
    for(new i; i < MAX_VEHICLES; i++) for(new x; x < LOG_LIMIT; x++) 
    {
        LogObjects[i][x] = -1;
    }
    
    
    for(new i = 0; i < sizeof(g_lumberActor); i ++)
    {
        format(string, sizeof string, "Log Buyer\n{FFFFFF}Use {F1C40F}/log sell {FFFFFF}to sell a log for {2ECC71}$%d.", LOG_PRICE);
        CreateDynamic3DTextLabel(string, COLOR_WHITE, g_lumberActor[i][lumberActorX], g_lumberActor[i][lumberActorY], g_lumberActor[i][lumberActorZ] + 1.0, 5.0, .testlos = 1);
        CreateActor(g_lumberActor[i][lumberActor], g_lumberActor[i][lumberActorX], g_lumberActor[i][lumberActorY], g_lumberActor[i][lumberActorZ], g_lumberActor[i][lumberActorA]);
    }

    CreateActor(1, 2355.5896,-657.3329,128.0547,292.8720);
    CreateDynamic3DTextLabel("Lumber Rent Truck\n"WHITE"Press 'N' To spawn vehicle", COLOR_GREY, 2355.5896,-657.3329,128.0547 + 1.0, 5.0, .testlos = 1);
    return 1;
}
 
hook OnPlayerConnect(playerid)
{
    Player_Init(playerid);
    return 1;
}
 
hook OnPlayerDisconnect(playerid, REASON:reason)
{
    Player_ResetCutting(playerid);
    Player_RemoveLog(playerid);
    
    EditingTreeID[playerid] = -1;
    return 1;
}
 
hook OnVehicleSpawn(vehicleid)
{
    Vehicle_RemoveLogs(vehicleid);
    return 1;
}
 
hook OnVehicleDeath(vehicleid, killerid)
{
    Vehicle_RemoveLogs(vehicleid);
    return 1;
}
 
hook OnPlayerDeath(playerid, killerid, REASON:reason)
{
    Player_ResetCutting(playerid);
    Player_DropLog(playerid, 1);
    return 1;
}
 
hook OnPlayerStateChange(playerid, PLAYER_STATE:newstate, PLAYER_STATE:oldstate)
{
    if(newstate != PLAYER_STATE_WASTED)
    {
        Player_ResetCutting(playerid);
        Player_RemoveLog(playerid);
    }
    
    return 1;
}
 
hook OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
    new string[256];
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (newkeys & KEY_NO))
    {
        if(CarryingLog[playerid]) return Player_DropLog(playerid);
        
        if(GetPlayerWeapon(playerid) == WEAPON_CHAINSAW && CuttingTreeID[playerid] == -1 && !CarryingLog[playerid])
        {
            new id = GetClosestTree(playerid);
 
            if(id != -1)
            {
                if(!Tree_BeingEdited(id) && !TreeData[id][treeGettingCut] && TreeData[id][treeSeconds] < 1)
                {
                    SetPlayerLookAt(playerid, TreeData[id][treeX], TreeData[id][treeY]);
 
                    Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[id][treeLabel], E_STREAMER_COLOR, 0xE74C3CFF);
                    CuttingTimer[playerid] = SetTimerEx("CutTree", 1000, true, "i", playerid);
                    CuttingTreeID[playerid] = id;
                    SetPlayerProgressBarValue(playerid, CuttingBar[playerid], 0.0);
                    ShowPlayerProgressBar(playerid, CuttingBar[playerid]);
                    TogglePlayerControllable(playerid, 0);
                    SetPlayerArmedWeapon(playerid, WEAPON_CHAINSAW);
                    ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.1, true, false, false, true, 0, SYNC_ALL);
 
                    TreeData[id][treeGettingCut] = true;
                }
            }
        }
    }
    if(newkeys & KEY_NO)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0, 2355.5896,-657.3329,128.0547))
		{
			if(PlayerHasJob(playerid, JOB_LUMBER))
			{
				if(gettime() - PlayerInfo[playerid][pLastSpawnCar] < 10)
				{
					return SendMessage(playerid, COLOR_GREY, "Please wait more %d before you spawn a vehicle", 10 - (gettime() - PlayerInfo[playerid][pLastSpawnCar]));
				}

                if(PlayerInfo[playerid][pSpawnCar] > 1)
				{
					DestroyVehicle(PlayerInfo[playerid][pSpawnCar]);
					PlayerInfo[playerid][pSpawnCar] = -1;
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET spawncar = -1 WHERE uid = %i", PlayerInfo[playerid][pID]);
					mysql_tquery(connectionID, queryBuffer);
				}

				new rand = random(sizeof(LumberVehicleSpawn));
				
				SetPlayerCheckpoint(playerid, LumberVehicleSpawn[rand][0], LumberVehicleSpawn[rand][1], LumberVehicleSpawn[rand][2], 5.0);
				PlayerInfo[playerid][pSpawnCar] = CreateVehicle(422, LumberVehicleSpawn[rand][0], LumberVehicleSpawn[rand][1], LumberVehicleSpawn[rand][2], LumberVehicleSpawn[rand][3], 57, 57, -1);
                vehicleFuel[PlayerInfo[playerid][pSpawnCar]] = 1000;
				jobVehicle{PlayerInfo[playerid][pSpawnCar]} = true;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET spawncar = %i WHERE uid = %i", PlayerInfo[playerid][pSpawnCar], PlayerInfo[playerid][pID]);
				mysql_tquery(connectionID, queryBuffer);

				format(string, sizeof(string), "PLAYERID %d", playerid);
				SetVehicleNumberPlate(PlayerInfo[playerid][pSpawnCar], string);
				PlayerInfo[playerid][pLastSpawnCar] = gettime();
			}
            else
            {
	            return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a lumberman.");
            }
		}
	}
    return 1;
}

hook OnPlayerEditDynamicObject(playerid, objectid, EDIT_RESPONSE:response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if(EditingTreeID[playerid] != -1 && Iter_Contains(Trees, EditingTreeID[playerid]))
    {
        if(response == EDIT_RESPONSE_FINAL)
        {
            new id = EditingTreeID[playerid];
            TreeData[id][treeX] = x;
            TreeData[id][treeY] = y;
            TreeData[id][treeZ] = z;
            TreeData[id][treeRX] = rx;
            TreeData[id][treeRY] = ry;
            TreeData[id][treeRZ] = rz;
 
            SetDynamicObjectPos(objectid, TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ]);
            SetDynamicObjectRot(objectid, TreeData[id][treeRX], TreeData[id][treeRY], TreeData[id][treeRZ]);
 
            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[id][treeLabel], E_STREAMER_X, TreeData[id][treeX]);
            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[id][treeLabel], E_STREAMER_Y, TreeData[id][treeY]);
            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[id][treeLabel], E_STREAMER_Z, TreeData[id][treeZ] + 1.5);
 
            EditingTreeID[playerid] = -1;
            Tree_Save(id);
        }
 
        if(response == EDIT_RESPONSE_CANCEL)
        {
            new id = EditingTreeID[playerid];
            SetDynamicObjectPos(objectid, TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ]);
            SetDynamicObjectRot(objectid, TreeData[id][treeRX], TreeData[id][treeRY], TreeData[id][treeRZ]);
            EditingTreeID[playerid] = -1;
        }
    }
 
    return 1;
}
 
forward CutTree(playerid);
public CutTree(playerid)
{
    if(CuttingTreeID[playerid] != -1)
    {
        new id = CuttingTreeID[playerid], Float: value = GetPlayerProgressBarValue(playerid, CuttingBar[playerid]) + 1.0;
        
        if(value >= CUTTING_TIME) {
            Player_ResetCutting(playerid);
            MoveDynamicObject(TreeData[id][treeObjID], TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ] + 0.03, 0.025, TreeData[id][treeRX], TreeData[id][treeRY] - 80.0, TreeData[id][treeRZ]);
 
            TreeData[id][treeLogs] = 5;
            TreeData[id][treeSeconds] = TREE_RESPAWN;
            Tree_UpdateLogLabel(id);
        }else{
            SetPlayerProgressBarValue(playerid, CuttingBar[playerid], value);
        }
    }
 
    return 1;
}
 
forward RespawnTree(id);
public RespawnTree(id)
{
    new label[96];
    if(TreeData[id][treeSeconds] > 1) {
        TreeData[id][treeSeconds]--;
        
        format(label, sizeof(label), "Tree [ID: %d]\n{FFFFFF}%s", id, ConvertToMinutes(TreeData[id][treeSeconds]));
        UpdateDynamic3DTextLabelText(TreeData[id][treeLabel], 0xE74C3CFF, label);
    }else if(TreeData[id][treeSeconds] == 1) {
        KillTimer(TreeData[id][treeTimer]);
 
        TreeData[id][treeLogs] = 0;
        TreeData[id][treeSeconds] = 0;
        TreeData[id][treeTimer] = -1;
        
        SetDynamicObjectPos(TreeData[id][treeObjID], TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ]);
        SetDynamicObjectRot(TreeData[id][treeObjID], TreeData[id][treeRX], TreeData[id][treeRY], TreeData[id][treeRZ]);
        
        format(label, sizeof(label), "Tree [ID: %d]\n{FFFFFF}Press ~k~~CONVERSATION_NO~ to cut down.", id);
        UpdateDynamic3DTextLabelText(TreeData[id][treeLabel], 0x2ECC71FF, label);
    }
    
    return 1;
}
 
forward RemoveLog(id);
public RemoveLog(id)
{
    if(!Iter_Count(Logs, id)) return 1;
    
    if(LogData[id][logSeconds] > 1) {
        LogData[id][logSeconds]--;
 
        new label[128];
        format(label, sizeof(label), "Log (%d)\n\n{FFFFFF}Dropped By {F1C40F}%s\n{FFFFFF}%s\nUse {F1C40F}/log take {FFFFFF}to take it.", id, LogData[id][logDroppedBy], ConvertToMinutes(LogData[id][logSeconds]));
        UpdateDynamic3DTextLabelText(LogData[id][logLabel], 0xF1C40FFF, label);
    }else if(LogData[id][logSeconds] == 1) {
        KillTimer(LogData[id][logTimer]);
        DestroyDynamicObject(LogData[id][logObjID]);
        DestroyDynamic3DTextLabel(LogData[id][logLabel]);
        
        LogData[id][logTimer] = -1;
        LogData[id][logObjID] = -1;
        LogData[id][logLabel] = Text3D: -1;
 
        Iter_Remove(Logs, id);
    }
    
    return 1;
}
 
CMD:log(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command in a vehicle.");
    if(isnull(params)) return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: {FFFFFF}/log [ load / take / takefromcar / takefromtree / sell]");
    
    if(!strcmp(params, "load", true)) {
        // loading to a bobcat
        if(!CarryingLog[playerid]) return SendClientMessage(playerid, COLOR_SYNTAX, "You're not carrying a log.");
        new id = GetNearbyVehicle(playerid);
        if(GetVehicleModel(id) != 422) return SendClientMessage(playerid, COLOR_SYNTAX, "You're not near a Bobcat.");
        new Float: x, Float: y, Float: z;
        GetVehicleBoot(id, x, y, z);
        if(!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) return SendClientMessage(playerid, COLOR_SYNTAX, "You're not near a Bobcat's back.");
        if(Vehicle_LogCount(id) >= LOG_LIMIT) return SendClientMessage(playerid, COLOR_SYNTAX, "You can't load any more logs to this vehicle.");
        for(new i; i < LOG_LIMIT; i++)
        {
            if(!IsValidDynamicObject(LogObjects[id][i]))
            {
                LogObjects[id][i] = CreateDynamicObject(19793, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                AttachDynamicObjectToVehicle(LogObjects[id][i], id, LogAttachOffsets[i][0], LogAttachOffsets[i][1], LogAttachOffsets[i][2], 0.0, 0.0, LogAttachOffsets[i][3]);
                break;
            }
        }
        
        Streamer_Update(playerid);
        Player_RemoveLog(playerid);
        SendClientMessage(playerid, 0x3498DBFF, "You've been successfully loaded a log.");
        // done
    }else if(!strcmp(params, "take")) {
        // taking from ground
        if(CarryingLog[playerid]) return SendClientMessage(playerid, COLOR_SYNTAX, "You're already carrying a log.");
        new id = GetClosestLog(playerid);
        if(id == -1) return SendClientMessage(playerid, COLOR_SYNTAX, "You're not near a log.");
        LogData[id][logSeconds] = 1;
        RemoveLog(id);
        
        Player_GiveLog(playerid);
        SendClientMessage(playerid, 0x3498DBFF, "You've taken a log from ground.");
        // done
    }else if(!strcmp(params, "takefromcar")) {
        // taking from a bobcat
        if(CarryingLog[playerid]) return SendClientMessage(playerid, COLOR_SYNTAX, "You're already carrying a log.");
        new id = GetNearbyVehicle(playerid);
        if(GetVehicleModel(id) != 422) return SendClientMessage(playerid, COLOR_SYNTAX, "You're not near a Bobcat.");
        new Float: x, Float: y, Float: z;
        GetVehicleBoot(id, x, y, z);
        if(!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) return SendClientMessage(playerid, COLOR_SYNTAX, "You're not near a Bobcat's back.");
        if(Vehicle_LogCount(id) < 1) return SendClientMessage(playerid, COLOR_SYNTAX, "This Bobcat doesn't have any logs.");
        for(new i = (LOG_LIMIT - 1); i >= 0; i--)
        {
            if(IsValidDynamicObject(LogObjects[id][i]))
            {
                DestroyDynamicObject(LogObjects[id][i]);
                LogObjects[id][i] = -1;
                break;
            }
        }
 
        Streamer_Update(playerid);
        Player_GiveLog(playerid);
        SendClientMessage(playerid, 0x3498DBFF, "You've taken a log from the Bobcat.");
        // done
    }else if(!strcmp(params, "takefromtree")) {
        // taking from a cut tree
        if(CarryingLog[playerid]) return SendClientMessage(playerid, COLOR_SYNTAX, "You're already carrying a log.");
        new id = GetClosestTree(playerid);
        if(id == -1) return SendClientMessage(playerid, COLOR_SYNTAX, "You're not near a tree.");
        if(TreeData[id][treeSeconds] < 1) return SendClientMessage(playerid, COLOR_SYNTAX, "This tree isn't cut.");
        if(TreeData[id][treeLogs] < 1) return SendClientMessage(playerid, COLOR_SYNTAX, "This tree doesn't have any logs.");
        TreeData[id][treeLogs]--;
        Tree_UpdateLogLabel(id);
        Tree_Save(id);
        
        Player_GiveLog(playerid);
        SendClientMessage(playerid, 0x3498DBFF, "You've taken a log from the cut tree.");
        // done
    }else if(!strcmp(params, "sell")) {
        // selling a log
        if(!CarryingLog[playerid]) return SendClientMessage(playerid, COLOR_SYNTAX, "You're not carrying a log.");
        if(!IsPlayerNearALogBuyer(playerid)) return SendClientMessage(playerid, COLOR_SYNTAX, "You're not near a Log Buyer.");
        Player_RemoveLog(playerid);
        GivePlayerCash(playerid, LOG_PRICE);
        
        new string[64];
        format(string, sizeof(string), "Sold a log for {2ECC71}$%d.", LOG_PRICE);
        SendClientMessage(playerid, 0x3498DBFF, string);
        // done
    }
 
    return 1;
}
 
// Admin Commands - Trees
CMD:createtree(playerid, params[])
{
    new id = Iter_Free(Trees);
    if(id == -1) return SendClientMessage(playerid, COLOR_SYNTAX, "Can't add any more trees.");
    new Float: x, Float: y, Float: z, Float: a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    x += (3.0 * floatsin(-a, degrees));
    y += (3.0 * floatcos(-a, degrees));
    z -= 1.0;
    
    TreeData[id][treeX] = x;
    TreeData[id][treeY] = y;
    TreeData[id][treeZ] = z;
    TreeData[id][treeRX] = TreeData[id][treeRY] = TreeData[id][treeRZ] = 0.0;
    
    TreeData[id][treeObjID] = CreateDynamicObject(657, TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ], TreeData[id][treeRX], TreeData[id][treeRY], TreeData[id][treeRZ]);
 
    new label[96];
    format(label, sizeof(label), "Tree (%d)\n{FFFFFF}Press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to cut down.", id);
    TreeData[id][treeLabel] = CreateDynamic3DTextLabel(label, 0x2ECC71FF, TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ] + 1.5, 5.0);
    Iter_Add(Trees, id);

    EditingTreeID[playerid] = id;
    EditDynamicObject(playerid, TreeData[id][treeObjID]);
    
    SendClientMessage(playerid, 0x3498DBFF, "Tree created.");
    SendClientMessage(playerid, 0x3498DBFF, "You can edit it right now, or cancel editing and edit it some other time.");

    for(new i = 0; i < MAX_TREES; i ++)
    {
        if(!TreeData[i][treeExists])
        {
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO job_lumberjack (treePosX, treePosY, treePosZ, treeRotateX, treeRotateY, treeRotateZ) VALUES('%f', '%f', '%f', '%f', '%f', '%f')", x, y, z, 0.0, 0.0, 0.0);
            mysql_tquery(connectionID, queryBuffer, "Tree_Create", "iiffffff", playerid, i, x, y, z, 0.0, 0.0, 0.0);
            return 1;
        }
    }
    return 1;
}
 
CMD:edittree(playerid, params[])
{
    new id, option[14], param[64];
    if(EditingTreeID[playerid] != -1) 
        return SendClientMessage(playerid, COLOR_SYNTAX, "You're already editing a tree.");

    if(!Iter_Contains(Trees, id)) 
        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid ID.");

    if(TreeData[id][treeGettingCut]) 
        return SendClientMessage(playerid, COLOR_SYNTAX, "Can't edit specified tree because its getting cut down.");

    if(!IsPlayerInRangeOfPoint(playerid, 30.0, TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ])) 
        return SendClientMessage(playerid, COLOR_SYNTAX, "You're not near the tree you want to edit.");
    
    if(sscanf(params, "is[14]S()[64]", id, option, param))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /edittree [id] [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: position, object");
	    return 1;
	}

    if(!strcmp(option, "position", true))
	{
        EditingTreeID[playerid] = id;
        EditDynamicObject(playerid, TreeData[id][treeObjID]);
	}
	else if(!strcmp(option, "object", true))
	{
		new objid;
	    if(sscanf(param, "i", objid))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editvendor [id] [object] [id]");
		}

        TreeData[id][treeObjID] = objid;
        Tree_Save(id);
        Tree_Refresh(id);
	}
    return 1;
}
 
CMD:removetree(playerid, params[])
{
    new id;
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removetree [tree id]");
    if(!Iter_Contains(Trees, id)) return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid ID.");
    if(TreeData[id][treeGettingCut]) return SendClientMessage(playerid, COLOR_SYNTAX, "Can't remove specified tree because its getting cut down.");
    if(Tree_BeingEdited(id)) return SendClientMessage(playerid, COLOR_SYNTAX, "Can't remove specified tree because its being edited.");
    DestroyDynamicObject(TreeData[id][treeObjID]);
    DestroyDynamic3DTextLabel(TreeData[id][treeLabel]);
    if(TreeData[id][treeTimer] != -1) KillTimer(TreeData[id][treeTimer]);
    
    TreeData[id][treeLogs] = TreeData[id][treeSeconds] = 0;
    TreeData[id][treeObjID] = TreeData[id][treeTimer] = -1;
    TreeData[id][treeLabel] = Text3D: -1;
    Iter_Remove(Trees, id);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM job_lumberjack WHERE id = %i", TreeData[id][treeID]);
	mysql_tquery(connectionID, queryBuffer);
	TreeData[id][treeExists] = 0;
	TreeData[id][treeID] = 0;
    
    SendClientMessage(playerid, 0x3498DBFF, "Tree removed.");
    return 1;
}