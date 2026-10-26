CMD:claimfreebies(playerid, params[])
{
    if(PlayerInfo[playerid][pFreebies] == 1)
    {
        return SendClientMessage(playerid, COLOR_GREY2, "You have already claimed your freebies.");
    }
    
    PlayerInfo[playerid][pFreebies] = 1;

    Inventory_Add(playerid, "Gasoline Can", 2902, 3);
    Inventory_Add(playerid, "Vest", 1242, 3);
    Inventory_Add(playerid, "Mobile Phone", 18874, 1);
    Inventory_Add(playerid, "Repair Kit", 2903, 3);

    // 2. Sync legacy variables
    PlayerInfo[playerid][pGasCan] = 3;
    PlayerInfo[playerid][pHasVest] = 3;
    PlayerInfo[playerid][pRepairKit] = 3;
    PlayerInfo[playerid][pPhone] = 1;

    // 3. Vehicle Spawn (BMX)
    new vehicleid = 481, color1 = 0, color2 = 0;
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO vehicles (ownerid, owner, modelid, pos_x, pos_y, pos_z, pos_a, color1, color2) VALUES (%i, '%e', %i, %f, %f, %f, %f, %i, %i)", PlayerInfo[playerid][pID], GetPlayerNameEx(playerid), vehicleid, x + 2.0 * floatsin(-a, degrees), y + 2.0 * floatcos(-a, degrees), z, a, color1, color2);
    mysql_tquery(connectionID, queryBuffer);

    // 4. SQL UPDATE (Tinanggal ang mga VIP columns sa update query)
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), 
        "UPDATE users SET freebies = 1, gascan = %i, hasvest = %i, repairkit = %i, phone = %i WHERE uid = %i", 
        PlayerInfo[playerid][pGasCan], PlayerInfo[playerid][pHasVest], PlayerInfo[playerid][pRepairKit], PlayerInfo[playerid][pPhone], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    // 5. Messages (In-update ang text para hindi na magbanggit ng Materials at VIP)
    SendClientMessage(playerid, -1, "{33CCFF}[SERVER]: {FFFFFF}You have successfully claimed your New Player Freebies!");
    SendClientMessage(playerid, -1, "{33CCFF}[FREEBIES]: {FFFF00}1x {FFFFFF}Free BMX, {FFFF00}1x {FFFFFF}Cellphone.");
    SendClientMessage(playerid, -1, "{33CCFF}[FREEBIES]: {FFFF00}3x {FFFFFF}Gas Cans, {FFFF00}3x {FFFFFF}Kevlar Vests, {FFFF00}3x {FFFFFF}Repair Kits.");        
    SendClientMessage(playerid, COLOR_YELLOW, "Check your inventory via /inventory to manage your items!");
    return 1;
}
