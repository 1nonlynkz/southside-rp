new Drones[MAX_PLAYERS];
 
CMD:drone(playerid, params[])
{
    new str[128];
    if(GetFactionType(playerid) != FACTION_HITMAN && IsLawEnforcement(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you're not a hitman.");
	}
    if( sscanf( params, "s", str ) ) return SendClientMessage( playerid, COLOR_SYNTAX, "Usage: /drone [spawn | detonate | remove]" );
    if( strcmp( str, "spawn" ) == 0 ) {
        if( GetPVarInt( playerid, "DroneSpawned" ) == 0 ) {
            new Float:Health;
            GetPlayerHealth( playerid, Health );
 
            if(Health != 0) {
                new Float:PosX, Float:PosY, Float:PosZ;
                GetPlayerPos( playerid, PosX, PosY, PosZ );
                SetPVarFloat( playerid, "OldPosX", PosX );
                SetPVarFloat( playerid, "OldPosY", PosY );
                SetPVarFloat( playerid, "OldPosZ", PosZ );
                SetPVarInt( playerid, "DroneSpawned", 1 );
                SendClientMessage( playerid, COLOR_GREEN, "You have successfully spawned a drone. You have 2 minutes before the drone is destroyed" );
                Drones[playerid] = CreateVehicle(465, PosX, PosY, PosZ + 20, 0, 0, 0, -1);
                PutPlayerInVehicle( playerid, Drones[playerid], 0 );

                SetTimerEx("DroneDestroy", 120000, false, "i", playerid);
            }
        } else {
            SendClientMessage( playerid, COLOR_RED, "You already have a drone spawned in!" );
        }
    } else {
        if( strcmp( str, "detonate" ) == 0 ) {
            if( GetPVarInt( playerid, "DroneSpawned" ) == 1 ) {
                new Float:PosX, Float:PosY, Float:PosZ;
                GetVehiclePos( Drones[playerid], PosX, PosY, PosZ );
 
                SetPVarInt( playerid, "DroneSpawned", 0 );
                SendClientMessage( playerid, COLOR_GREEN, "Drone successfully detonated." );
                DestroyVehicle( Drones[playerid] );
 
                CreateExplosion( PosX, PosY, PosZ, 7, 25 );
 
                SetPlayerPos(playerid, GetPVarFloat( playerid, "OldPosX" ), GetPVarFloat( playerid, "OldPosY" ), GetPVarFloat( playerid, "OldPosZ" ));
            } else {
                SendClientMessage( playerid, COLOR_RED, "You need to have a drone spawned in!" );
            }
        } else {
            if( strcmp( str, "remove" ) == 0 ) {
                if( GetPVarInt( playerid, "DroneSpawned" ) == 1 ) {
                    SetPVarInt( playerid, "DroneSpawned", 0 );
                    SendClientMessage( playerid, COLOR_GREEN, "You have shut your drone down." );
                    DestroyVehicle( Drones[playerid] );
 
                    SetPlayerPos(playerid, GetPVarFloat( playerid, "OldPosX" ), GetPVarFloat( playerid, "OldPosY" ), GetPVarFloat( playerid, "OldPosZ" ));
                } else {
                    SendClientMessage( playerid, COLOR_RED, "You need to have a drone spawned in!" );
                }
            }
        }
    }
    return 1;
}

forward DroneDestroy(playerid);
public DroneDestroy(playerid)
{
    if( GetPVarInt( playerid, "DroneSpawned" ) == 1 ) 
    {
        new Float:PosX, Float:PosY, Float:PosZ;
        GetVehiclePos( Drones[playerid], PosX, PosY, PosZ );

        SetPVarInt( playerid, "DroneSpawned", 0 );
        SendClientMessage( playerid, COLOR_GREEN, "Drone successfully detonated." );
        DestroyVehicle( Drones[playerid] );

        CreateExplosion( PosX, PosY, PosZ, 7, 25 );

        SetPlayerPos(playerid, GetPVarFloat( playerid, "OldPosX" ), GetPVarFloat( playerid, "OldPosY" ), GetPVarFloat( playerid, "OldPosZ" ));
    } else {
        SendClientMessage( playerid, COLOR_RED, "You need to have a drone spawned in!" );
    }
    return 1;
}