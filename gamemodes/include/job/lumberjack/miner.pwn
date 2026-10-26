#include <YSI_Coding\y_hooks>

#define STONE_LIMIT   (10)

new StoneObjects[MAX_VEHICLES][STONE_LIMIT];
new PlayerVehicle[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};
new VehicleOwner[MAX_VEHICLES] = {INVALID_PLAYER_ID, ...};

new const Float:minerPositions[][] =
{
    {330.9373, -640.2238, 9.5915},
    {323.8630, -643.7653, 10.1915},
    {332.6073, -648.5865, 10.9464}
};

// Offsets para sa 10 Stones sa likod ng Walton (Model 478)
new Float: StoneAttachOffsets[STONE_LIMIT][4] =
{
    {0.611, -2.159, 0.549, 0.000},
    {0.000, -2.181, 0.560, 0.000},
    {-0.710, -2.229, 0.559, 0.000},
    {-0.300, -1.570, 0.500, 0.000},
    {0.280, -1.601, 0.500, 0.000},
    {0.500, -2.000, 0.800, 0.000},
    {0.000, -2.000, 0.800, 0.000},
    {-0.500, -2.000, 0.800, 0.000},
    {-0.200, -1.700, 0.750, 0.000},
    {0.200, -1.700, 0.750, 0.000}
};

hook OnGameModeInit()
{
    CreateDynamic3DTextLabel("{00FF00}[ MINER WORK VEHICLE ]\n{FFFFFF}Type {FFFF00}/minerveh {FFFFFF}to spawn your Walton truck.", 0xFFFFFFFF, 295.2820, -699.2307, 5.8, 20.0);
    CreateDynamicPickup(19132, 23, 295.2820, -699.2307, 5.1734, -1, -1, -1, 100.0);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(PlayerVehicle[playerid] != INVALID_VEHICLE_ID)
    {
        DestroyJobVehicle(PlayerVehicle[playerid]);
        PlayerVehicle[playerid] = INVALID_VEHICLE_ID;
    }
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid)
{
    if(vehicleid < 1 || vehicleid >= MAX_VEHICLES) return 1;
    new ownerid = VehicleOwner[vehicleid];
    if(ownerid >= 0 && ownerid < MAX_PLAYERS && PlayerVehicle[ownerid] == vehicleid)
    {
        if(IsPlayerConnected(ownerid))
        {
            SendClientMessage(ownerid, COLOR_RED, "Your mining vehicle was destroyed. Use /minerveh to spawn another one.");
            PlayerVehicle[ownerid] = INVALID_VEHICLE_ID;
        }
        DestroyJobVehicle(vehicleid);
    }
    return 1;
}

hook OnPlayerStateChange(playerid, PLAYER_STATE:newstate, PLAYER_STATE:oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(GetVehicleModel(vehicleid) == 478)
        {
            if(PlayerInfo[playerid][pJob] != JOB_MINER)
            {
                RemovePlayerFromVehicle(playerid);
                return SendClientMessage(playerid, COLOR_RED, "You are not a Miner! You cannot ride this vehicle.");
            }
            
            if(VehicleOwner[vehicleid] != INVALID_PLAYER_ID && VehicleOwner[vehicleid] != playerid)
            {
                RemovePlayerFromVehicle(playerid);
                return SendClientMessage(playerid, COLOR_RED, "This Walton belongs to another Miner. You cannot use it!");
            }
        }
    }
    return 1;
}

stock DestroyJobVehicle(vehicleid)
{
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid < 1 || vehicleid >= MAX_VEHICLES) return 0;

    new ownerid = VehicleOwner[vehicleid];
    if(ownerid != INVALID_PLAYER_ID && ownerid >= 0 && ownerid < MAX_PLAYERS && PlayerVehicle[ownerid] == vehicleid)
    {
        PlayerVehicle[ownerid] = INVALID_VEHICLE_ID;
    }
    for(new i = 0; i < STONE_LIMIT; i++)
    {
        if(IsValidDynamicObject(StoneObjects[vehicleid][i]))
        {
            DestroyDynamicObject(StoneObjects[vehicleid][i]);
            StoneObjects[vehicleid][i] = -1;
        }
    }
    VehicleOwner[vehicleid] = INVALID_PLAYER_ID;
    DestroyVehicle(vehicleid);
    return 1;
}

stock IsPlayerInMiningArea(playerid)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 0;
    for(new i = 0; i < sizeof(minerPositions); i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 12.0, minerPositions[i][0], minerPositions[i][1], minerPositions[i][2]))
        {
            return 1;
        }
    }
    return 0;
}

Vehicle_StoneCount(vehicleid)
{
    if(GetVehicleModel(vehicleid) == 0) return 0;
    new count;
    for(new i; i < STONE_LIMIT; i++) if(IsValidDynamicObject(StoneObjects[vehicleid][i])) count++;
    return count;
}

CMD:minerveh(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] != JOB_MINER)  
    {  
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a Miner.");  
    }  
    if(!IsPlayerInRangeOfPoint(playerid, 6.0, 295.2820, -699.2307, 5.1734))
    {
        return SendClientMessage(playerid, COLOR_RED, "You must be standing on the pickup icon to spawn a truck.");
    }
    if(PlayerVehicle[playerid] != INVALID_VEHICLE_ID)
    {
        return SendClientMessage(playerid, COLOR_RED, "You already have an active work vehicle. Destroy it or use it first.");
    }

    // Saktong bagsak ng Walton sa pwesto mo sa screenshot
    new carid = CreateVehicle(478, 295.2820, -699.2307, 5.8, 333.22, 1, 1, 60);
    if(carid == INVALID_VEHICLE_ID || carid < 1 || carid >= MAX_VEHICLES)
    {
        return SendClientMessage(playerid, COLOR_RED, "Unable to spawn your mining vehicle right now. Please try again.");
    }

    for(new i = 0; i < STONE_LIMIT; i++) StoneObjects[carid][i] = -1;
    PlayerVehicle[playerid] = carid;
    VehicleOwner[carid] = playerid;
    SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid));
    LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
    PutPlayerInVehicle(playerid, carid, 0);
    SendClientMessage(playerid, COLOR_GREEN, "Work Vehicle Spawned! Only you can drive and load stones into this Walton.");
    return 1;
}

CMD:destroyminerveh(playerid, params[])
{
    if(PlayerVehicle[playerid] == INVALID_VEHICLE_ID)
    {
        return SendClientMessage(playerid, COLOR_RED, "You don't have any spawned work vehicle.");
    }
    
    DestroyJobVehicle(PlayerVehicle[playerid]);
    PlayerVehicle[playerid] = INVALID_VEHICLE_ID;
    SendClientMessage(playerid, COLOR_YELLOW, "Your work vehicle has been successfully unspawned.");
    return 1;
}

hook OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
    if((newkeys & KEY_NO) && !(oldkeys & KEY_NO)) 
    {
        if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
        {
            if(IsPlayerInMiningArea(playerid))
            {
                if(PlayerInfo[playerid][pJob] == JOB_MINER)
                {
                    if(PlayerInfo[playerid][pMiningTime] > 0 || GetPVarInt(playerid, "CurrentlyUsingBar")) return 1;
                    new title[32];
                    strcat(title, "Digging Stone");
                    SetPVarString(playerid, "CurrentlyUsingText", title);
                    PlayerTextDrawSetString(playerid, UsingTD[playerid][1], title);
                    PlayerTextDrawShow(playerid, UsingTD[playerid][0]);
                    PlayerTextDrawShow(playerid, UsingTD[playerid][1]);

                    UsingType[playerid] = USING_TYPE_MINING;
                    UsingPoints[playerid] = 0;
                    SetPlayerProgressBarValue(playerid, UsingBar[playerid][0], 0.0);
                    SetPVarInt(playerid, "CurrentlyUsingBar", 1);  
                    ApplyAnimation(playerid, "BASEBALL", "BAT_4", 4.1, true, false, false, false, 0, SYNC_ALL);  

                    DisablePlayerCheckpoint(playerid);  
                    SetPlayerAttachedObject(playerid, 9, 337, 6);  
                }  
                else
                {
                    SendClientMessage(playerid, COLOR_RED, "You are not a Miner. You cannot mine here.");
                }
            }  
        }  
    }  
    return 1;
}

IsNearTrunk(vehicle, playerid, Float: dist = 5.0)
{
    new Float: x, Float: y, Float: z;
    GetVehicleBoot(vehicle, x, y, z);
    if (GetPlayerDistanceFromPoint(playerid, x, y, z) > dist) return 0;  
    return 1;
}

CMD:loadstone(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] != JOB_MINER)  
    {  
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a Miner.");  
    }  
    
    new vehicle = GetNearbyVehicle(playerid);
    if(vehicle == INVALID_VEHICLE_ID || vehicle < 1 || vehicle >= MAX_VEHICLES || !IsValidVehicle(vehicle))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of your mining Walton.");
    }
    if(PlayerInfo[playerid][pStone] == 0)  
    {  
        return SendClientMessage(playerid, COLOR_SYNTAX, "You need to get a stone first before you load it to the truck.");  
    }  
    if(GetVehicleModel(vehicle) != 478)  
    {  
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any Walton.");  
    }  
    if(VehicleOwner[vehicle] != playerid)
    {
        return SendClientMessage(playerid, COLOR_RED, "You cannot load stones into another player's vehicle!");
    }
    if(Vehicle_StoneCount(vehicle) >= STONE_LIMIT)
    {
        return SendClientMessage(playerid, COLOR_RED, "This Walton trunk is already full! Drive to the delivery point.");
    }
    if (!IsNearTrunk(vehicle, playerid, 2.0))  
        return SendClientMessage(playerid, COLOR_GRAD1, "You are not near the trunk!");  

    new engine, lights, alarm, doors, bonnet, boot, objective;  
    GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);  

    if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)  
    {  
        return SendClientMessage(playerid, COLOR_SYNTAX, "You need to open the trunk before you load the stone.");  
    }  

    for(new i = 0; i < STONE_LIMIT; i++)  
    {  
        if(!IsValidDynamicObject(StoneObjects[vehicle][i]))  
        {  
            StoneObjects[vehicle][i] = CreateDynamicObject(3930, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);  
            AttachDynamicObjectToVehicle(StoneObjects[vehicle][i], vehicle, StoneAttachOffsets[i][0], StoneAttachOffsets[i][1], StoneAttachOffsets[i][2], 0.0, 0.0, StoneAttachOffsets[i][3]);  
            
            new currentStones = Vehicle_StoneCount(vehicle);
            new msg[128];
            format(msg, sizeof(msg), "Stone loaded into the trunk! (%d/%d)", currentStones, STONE_LIMIT);
            SendClientMessage(playerid, COLOR_YELLOW, msg);

            if(currentStones == STONE_LIMIT)
            {
                SetPlayerCheckpoint(playerid, 1044.134277, -323.786926, 74.047599, 4.0);
                PlayerInfo[playerid][pCP] = CHECKPOINT_MINING;
                SendClientMessage(playerid, COLOR_GREEN, "The Walton is now FULL (10/10)! The delivery point has been marked on your map.");
            }
            break;  
        }  
    }  
  
    RemovePlayerAttachedObject(playerid, 9);  
    ClearAnimations(playerid);  
    PlayerInfo[playerid][pStone] = 0;  
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);  
    return 1;
}

CMD:unloadstone(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] != JOB_MINER)  
    {  
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a Miner.");  
    }  

    new vehicle = GetNearbyVehicle(playerid);
    if(vehicle == INVALID_VEHICLE_ID || vehicle < 1 || vehicle >= MAX_VEHICLES || !IsValidVehicle(vehicle) || GetVehicleModel(vehicle) != 478)  
    {  
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any Walton.");  
    }  
    if(VehicleOwner[vehicle] != playerid)
    {
        return SendClientMessage(playerid, COLOR_RED, "You can only unload your own work vehicle!");
    }
    if(!IsPlayerInRangeOfPoint(playerid, 8.0, 1044.134277, -323.786926, 74.047599))
    {
        return SendClientMessage(playerid, COLOR_RED, "You can only unload stones at the designated delivery point.");
    }
    if(Vehicle_StoneCount(vehicle) < 1)  
        return SendClientMessage(playerid, COLOR_RED, "This Walton doesn't have any stones left.");  

    if (!IsNearTrunk(vehicle, playerid, 2.0))  
        return SendClientMessage(playerid, COLOR_GRAD1, "You are not near the trunk!"); 

    new engine, lights, alarm, doors, bonnet, boot, objective;  
    GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);  
    if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)  
    {  
        return SendClientMessage(playerid, COLOR_GRAD2, "You need to open the trunk first before you unload.");  
    }  

    ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, false, false, false, false, 0, SYNC_ALL);  

    new salary = 8000 + random(7001); // $8,000 to $15,000 payout
    AddToPaycheck(playerid, salary);  

    new Float:expFloat = 0.9;  
    if(gDoubleXP || PlayerInfo[playerid][pDoubleXP] > 0)  
    {  
        PlayerInfo[playerid][pEXP] += expFloat * 2;  
    }  
    else  
    {  
        PlayerInfo[playerid][pEXP] += expFloat;  
    }  
    
    SendMessage(playerid, COLOR_YELLOW, "EXP Gained:"WHITE" %.2f", expFloat);  
    SendMessage(playerid, COLOR_YELLOW, "You've successfully delivered the cargo and earned "GREEN"$%s"YELLOW"! (Added to Paycheck)", FormatNumber(salary));  

    DestroyJobVehicle(vehicle);
    PlayerVehicle[playerid] = INVALID_VEHICLE_ID;

    PlayerInfo[playerid][pStone] = 0;  
    PlayerInfo[playerid][pCP] = CHECKPOINT_NONE;  
    DisablePlayerCheckpoint(playerid);  
    return 1;
}

CMD:mine(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] != JOB_MINER)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a Miner.");
    }
    if(PlayerInfo[playerid][pMiningTime] > 0)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are mining already. Wait until you are done.");
    }
    if(!IsPlayerInMiningArea(playerid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the mining area.");
    }
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be onfoot in order to use this command.");
    }

    new title[32];  
    strcat(title, "Digging Stone");  
    SetPVarString(playerid, "CurrentlyUsingText", title);  
    PlayerTextDrawSetString(playerid, UsingTD[playerid][1], title);  
    PlayerTextDrawShow(playerid, UsingTD[playerid][0]);  
    PlayerTextDrawShow(playerid, UsingTD[playerid][1]);  
  
    UsingType[playerid] = USING_TYPE_MINING;  
    SetPVarInt(playerid, "CurrentlyUsingBar", 1);  
    ApplyAnimation(playerid, "BASEBALL", "BAT_4", 4.1, true, false, false, false, 0, SYNC_ALL);  
    return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    switch (PlayerInfo[playerid][pCP])
    {
        case CHECKPOINT_MINING:
        {
            if(PlayerInfo[playerid][pJob] == JOB_MINER)
            {
                SendClientMessage(playerid, COLOR_YELLOW, "You have reached the delivery dock! Type "WHITE"/unloadstone"YELLOW" near the trunk to complete the job.");
            }
        }  
    }  
    return 1;
}