#include <YSI_Coding\y_hooks>

new const Float:SurgeryPositions[][] =
{
    {209.7969,1895.6194,369.3071,182.5846},
	{211.4852,1902.2710,369.3006,358.9696}
};

IsPlayerInSurgeryArea(playerid)
{
    for(new i = 0; i < sizeof(SurgeryPositions); i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, SurgeryPositions[i][0], SurgeryPositions[i][1], SurgeryPositions[i][2]))
	    {
	    	return 1;
	    }
	}

	return 0;
}

hook OnGameModeInit()
{
    for(new i = 0; i < sizeof(SurgeryPositions); i ++)
	{
		CreateDynamic3DTextLabel(""LIGHTRED"Surgery Room\n\n"WHITE":Type "LIGHTRED"'/surgery' "WHITE"to begin surgery", COLOR_DOCTOR, SurgeryPositions[i][0], SurgeryPositions[i][1], SurgeryPositions[i][2], 5.0);
	}
    return 1;
}

CMD:surgery(playerid, params[])
{
	new targetid;
	if(!IsPlayerInSurgeryArea(playerid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of Surgery Room.");
	}
	if(GetFactionType(playerid) != FACTION_MEDIC)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a medic.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /surgery [playerid]");
	}
	if((gettime() - PlayerInfo[playerid][pLastAM]) < 30)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "Someone's doing an operation.");
	}
    if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
    }
	if(targetid == playerid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command on yourself.");
	}
	if(!PlayerInfo[targetid][pInjured])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is not injured.");
	}
	if( IsPlayerInRangeOfPoint( playerid, 3, 208.8822,1895.3427,370.0293 ) ) {
		SetPlayerPos(targetid, 208.8822,1895.3427,370.0293);
		SetPlayerFacingAngle(targetid, 2.0624);
	}
	if( IsPlayerInRangeOfPoint( playerid, 3, 212.3291,1902.0591,370.0293)){
		SetPlayerPos(targetid, 212.3291,1902.0591,370.0293);
		SetPlayerFacingAngle(targetid, 179.7007);
	} 
	if( IsPlayerInRangeOfPoint( playerid, 3, 1155.8989, -1310.2770, -43.546237)){
		SetPlayerPos(targetid, 1155.8989, -1310.2770, -43.546237);
		SetPlayerFacingAngle(targetid, 181.18);
	} 
	if( IsPlayerInRangeOfPoint( playerid, 3, 1160.3904, -1312.7845, -43.2287)){
		SetPlayerPos(targetid, 1160.3904, -1312.7845, -43.2287);
		SetPlayerFacingAngle(targetid, 268.88);
	}

    new string[32];
    format(string, sizeof(string), "Begin Surgery");
    strcpy(player_progress_title[playerid], string);
    ShowPlayerProgress(playerid, SURGERY_PROGRESS, string);
    SetPVarInt(playerid, "SurgeryTarget", targetid);
	return 1;
}

forward Surgery(playerid, targetid);
public Surgery(playerid, targetid)
{
	PlayerInfo[playerid][pInjured] = 0;
	SetPlayerHealth(playerid, 100.0);
	ClearAnimations(playerid);
	GivePlayerCash(playerid, -1500);
	UpdateDynamic3DTextLabelText(InjuredLabel[targetid], COLOR_DOCTOR, "");
	GameTextForPlayer(playerid, "~w~Discharged~n~~g~-$1,500", 5000, 1);
	SendClientMessage(playerid, COLOR_DOCTOR, "You have been revived by an Doctor/medic!");
	return 1;
}