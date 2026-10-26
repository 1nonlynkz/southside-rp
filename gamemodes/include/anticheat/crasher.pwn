#include <YSI_Coding\y_hooks>
stock IsPlayerUsingDetonatorCrasher(playerid)
{
	new bool:player_have_sachel = false, WEAPON:weapons[13][2];
	for (new i = 0; i <= 12; i++)
	{
		GetPlayerWeaponData(playerid, WEAPON_SLOT:i, weapons[i][0], weapons[i][1]);
		
		if(weapons[i][0] == WEAPON_SATCHEL)
			player_have_sachel = true;
			
		if(weapons[i][0] == WEAPON_BOMB && player_have_sachel == false)
		{
			return 1;
		}
	}
	return 0;
}

hook OnPlayerUpdate(playerid)
{
	if(IsPlayerUsingDetonatorCrasher(playerid))
	{
        SendMessageToAll(COLOR_LIGHTRED, "AdmCmd: %s was automatically kick by %s, Reason: Weapon Crasher", GetRPName(playerid), SERVER_ANTICHEAT);
		Kick(playerid);
    }
    return 1;
}