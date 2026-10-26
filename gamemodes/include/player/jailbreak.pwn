stock Jailbreak(playerid)
{
	switch(random(5))
	{
		case 0:
		{
		    PlayerInfo[playerid][pLoopAnim] = 0; 
        	ClearAnimations(playerid, 1);
	        TextDrawHideForPlayer(playerid, AnimationTD); 
	
			SetPlayerPos(playerid, 1764.8630, -1568.7178, 1742.4944);
			SendClientMessage(playerid, COLOR_ORANGE, "[Prison Exit]: {FFFFFF}Find a place where it is safe and beware of law enforcement");
			
			PlayerInfo[playerid][pTool]--;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET tool = %i WHERE uid = %i", PlayerInfo[playerid][pTool], PlayerInfo[playerid][pID]);
	        mysql_tquery(connectionID, queryBuffer);
		}
        case 1:
		{
		    PlayerInfo[playerid][pLoopAnim] = 0;
        	ClearAnimations(playerid, 1);
	        TextDrawHideForPlayer(playerid, AnimationTD);
	
			SetPlayerPos(playerid, 1757.9783,-1578.1486,1738.7173);
			SendClientMessage(playerid, COLOR_ORANGE, "[Prison Exit]: {FFFFFF}Find a place where it is safe and beware of law enforcement");
			
			PlayerInfo[playerid][pTool]--;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET tool = %i WHERE uid = %i", PlayerInfo[playerid][pTool], PlayerInfo[playerid][pID]);
	        mysql_tquery(connectionID, queryBuffer);
		}
        case 2:
		{
		    PlayerInfo[playerid][pLoopAnim] = 0;
        	ClearAnimations(playerid, 1);
	        TextDrawHideForPlayer(playerid, AnimationTD);
	
			SetPlayerPos(playerid, 1778.8473,-1567.7915,1734.9430);
			SendClientMessage(playerid, COLOR_ORANGE, "[Prison Exit]: {FFFFFF}Find a place where it is safe and beware of law enforcement");
			
			PlayerInfo[playerid][pTool]--;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET tool = %i WHERE uid = %i", PlayerInfo[playerid][pTool], PlayerInfo[playerid][pID]);
	        mysql_tquery(connectionID, queryBuffer);
		}
        case 3:
		{
		    PlayerInfo[playerid][pLoopAnim] = 0;
        	ClearAnimations(playerid, 1);
	        TextDrawHideForPlayer(playerid, AnimationTD);
	
			SetPlayerPos(playerid, -1614.0031,720.2267,909.8140);
			SendClientMessage(playerid, COLOR_ORANGE, "[Prison Exit]: {FFFFFF}Find a place where it is safe and beware of law enforcement");
			
			PlayerInfo[playerid][pTool]--;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET tool = %i WHERE uid = %i", PlayerInfo[playerid][pTool], PlayerInfo[playerid][pID]);
	        mysql_tquery(connectionID, queryBuffer);
		}
        case 4:
		{
		    PlayerInfo[playerid][pLoopAnim] = 0;
        	ClearAnimations(playerid, 1);
	        TextDrawHideForPlayer(playerid, AnimationTD);
	
			SetPlayerPos(playerid, -1612.9209,716.7339,909.8140);
			SendClientMessage(playerid, COLOR_ORANGE, "[Prison Exit]: {FFFFFF}Find a place where it is safe and beware of law enforcement");
			
			PlayerInfo[playerid][pTool]--;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET tool = %i WHERE uid = %i", PlayerInfo[playerid][pTool], PlayerInfo[playerid][pID]);
	        mysql_tquery(connectionID, queryBuffer);
		}
        case 5:
		{
		    PlayerInfo[playerid][pLoopAnim] = 0;
        	ClearAnimations(playerid, 1);
	        TextDrawHideForPlayer(playerid, AnimationTD);
	
			SetPlayerPos(playerid, -1613.2610,737.6939,910.4169);
			SendClientMessage(playerid, COLOR_ORANGE, "[Prison Exit]: {FFFFFF}Find a place where it is safe and beware of law enforcement");
			
			PlayerInfo[playerid][pTool]--;
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET tool = %i WHERE uid = %i", PlayerInfo[playerid][pTool], PlayerInfo[playerid][pID]);
	        mysql_tquery(connectionID, queryBuffer);
		}
	}
    PlayerInfo[playerid][pJailBreak] = 1;
    PlayerInfo[playerid][pJailTime] = 1;
    
    foreach(new i : Player)
	{
		if(IsLawEnforcement(i))
		{
			SendMessage(i, COLOR_ROYALBLUE, "** HQ: The prison %s escaped from prison, Located at %s", GetRPName(playerid), GetZoneName(PlayerInfo[playerid][pPosX],PlayerInfo[playerid][pPosY],PlayerInfo[playerid][pPosZ]));
			SetPlayerCheckpoint(i, PlayerInfo[playerid][pPosX],PlayerInfo[playerid][pPosY],PlayerInfo[playerid][pPosZ], 3.0);
		}
	}
    
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO charges VALUES(null, %i, 'The State', NOW(), 'Jail Break')", PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET wantedlevel = 6, crimes = crimes + 1 WHERE uid = %i", PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
    return 1;
}

forward JailBreakTimers(playerid, timer);
public JailBreakTimers(playerid, timer)
{
    if(PlayerInfo[playerid][pJailTime])
    {
        switch(timer)
        {
            case 21: GameTextForPlayer(playerid, "20", 3000, 3); 
            case 20: GameTextForPlayer(playerid, "19", 3000, 3);
            case 19: GameTextForPlayer(playerid, "18", 3000, 3); 
            case 18: GameTextForPlayer(playerid, "17", 3000, 3); 
            case 17: GameTextForPlayer(playerid, "16", 3000, 3); 
            case 16: GameTextForPlayer(playerid, "15", 3000, 3); 
            case 15: GameTextForPlayer(playerid, "14", 3000, 3); 
            case 14: GameTextForPlayer(playerid, "13", 3000, 3); 
            case 13: GameTextForPlayer(playerid, "12", 3000, 3); 
            case 12: GameTextForPlayer(playerid, "11", 3000, 3); 
            case 11: GameTextForPlayer(playerid, "10", 3000, 3); 
            case 10: GameTextForPlayer(playerid, "9", 3000, 3); 
            case 9: GameTextForPlayer(playerid, "8", 3000, 3);
            case 8: GameTextForPlayer(playerid, "7", 3000, 3);
            case 7: GameTextForPlayer(playerid, "6", 3000, 3);
            case 6: GameTextForPlayer(playerid, "5", 3000, 3);
            case 5: GameTextForPlayer(playerid, "4", 3000, 3);
            case 4: GameTextForPlayer(playerid, "3", 3000, 3);
			case 3: GameTextForPlayer(playerid, "2", 3000, 3);
			case 2: GameTextForPlayer(playerid, "1", 3000, 3);
			case 1: GameTextForPlayer(playerid, "Door Unlocked", 3000, 3);
			case 0: Jailbreak(playerid);
		}
	}
	timer--;
	if(timer >= 0)
	{
 		SetTimerEx("JailBreakTimers", 1000, false, "ii", playerid, timer);
	}
}

CMD:buytool(playerid, params[])
{
    if(PlayerInfo[playerid][pJailTime] < 0)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are unable to use this command at the moment.");
	}
    else
    {
	    PlayerInfo[playerid][pTool]++;
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET tool = %i WHERE uid = %i", PlayerInfo[playerid][pTool], PlayerInfo[playerid][pID]);
	    mysql_tquery(connectionID, queryBuffer);
	    
	    SendMessage(playerid, COLOR_YELLOW, "You have received %i tool kit", PlayerInfo[playerid][pTool]);
	}
	return 1;
}

CMD:breakjail(playerid, params[])
{
	if(PlayerInfo[playerid][pTool] < 1)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have the tool(s) that is needed to jailbreak.");
	}
	if(PlayerInfo[playerid][pJailTime] < 1)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are currently not jailed.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 4.0, 1824.999145, -1717.684448, 5202.585937))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of the prison door.");
	}
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 0, 1, 1, 1, 0, 1);
	SetTimerEx("JailBreakTimers", 1000, false, "ii", playerid, 21);
	SendClientMessage(playerid, COLOR_ORANGE, "[Prison Door]: {FFFFFF}Wait 20 seconds to escape the jail");
	return 1;
}