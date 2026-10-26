#define MAX_BLACKMARKET		50

enum E_BLACKMARKET_DATA
{
    bmID,
    bmExists,
    Float:bmPosX,
    Float:bmPosY,
    Float:bmPosZ,
    Float:bmPosA,
    bmSkin,           
    bmLabel,
    Text3D: bmTextID,
    bmActorID           
};
new BlackmarketData[MAX_BLACKMARKET][E_BLACKMARKET_DATA];

ReloadBlackMarket(id)
{
    new string[500];
    if(BlackmarketData[id][bmExists])
    {
        if(IsValidDynamic3DTextLabel(BlackmarketData[id][bmTextID]))
        {
            DestroyDynamic3DTextLabel(BlackmarketData[id][bmTextID]);
            BlackmarketData[id][bmTextID] = Text3D:INVALID_3DTEXT_ID;
        }

        if(IsValidDynamicActor(BlackmarketData[id][bmActorID]))
        {
            DestroyDynamicActor(BlackmarketData[id][bmActorID]);
            BlackmarketData[id][bmActorID] = INVALID_STREAMER_ID;
        }

        BlackmarketData[id][bmActorID] = CreateDynamicActor(
            BlackmarketData[id][bmSkin], 
            BlackmarketData[id][bmPosX], 
            BlackmarketData[id][bmPosY], 
            BlackmarketData[id][bmPosZ], 
            BlackmarketData[id][bmPosA]
        );

        if(BlackmarketData[id][bmLabel])
        {
            format(string, sizeof(string), "Black Market\nType /blackmarket to purchase weapon\nID: %d", id);
            BlackmarketData[id][bmTextID] = CreateDynamic3DTextLabel(
                string, 
                COLOR_YELLOW, 
                BlackmarketData[id][bmPosX], 
                BlackmarketData[id][bmPosY], 
                BlackmarketData[id][bmPosZ] + 1.0, 
                30.0
            );
        }
    }
}

GetNearbyBlackMarket(playerid)
{
    for(new i = 0; i < MAX_BLACKMARKET; i ++)
    {
        if(BlackmarketData[i][bmExists] && IsPlayerInRangeOfPoint(playerid, 3.0, BlackmarketData[i][bmPosX], BlackmarketData[i][bmPosY], BlackmarketData[i][bmPosZ]))
        {
            return i;
        }
    }
    return -1;
}

forward OnAdminCreateBlackMarket(playerid, id, Float:x, Float:y, Float:z, Float:a, skin);
public OnAdminCreateBlackMarket(playerid, id, Float:x, Float:y, Float:z, Float:a, skin)
{
    BlackmarketData[id][bmID] = cache_insert_id(connectionID);
    BlackmarketData[id][bmExists] = 1;
    BlackmarketData[id][bmPosX] = x;
    BlackmarketData[id][bmPosY] = y;
    BlackmarketData[id][bmPosZ] = z;
    BlackmarketData[id][bmPosA] = a;
    BlackmarketData[id][bmSkin] = skin;
    BlackmarketData[id][bmTextID] = Text3D:INVALID_3DTEXT_ID;
    BlackmarketData[id][bmActorID] = INVALID_STREAMER_ID;
    BlackmarketData[id][bmLabel] = 1;

    ReloadBlackMarket(id);
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has created black market (Actor Skin: %d) at %s.", GetStaffRank(playerid), GetRPName(playerid), skin, GetZoneName(x, y, z));
}

forward LoadBlackMarket();
public LoadBlackMarket()
{
    new rows = cache_get_row_count(connectionID);
    for(new i = 0; i < rows && i < MAX_BLACKMARKET; i ++)
    {
        BlackmarketData[i][bmID] = cache_get_field_content_int(i, "id");
        BlackmarketData[i][bmPosX] = cache_get_field_content_float(i, "pos_x");
        BlackmarketData[i][bmPosY] = cache_get_field_content_float(i, "pos_y");
        BlackmarketData[i][bmPosZ] = cache_get_field_content_float(i, "pos_z");
        BlackmarketData[i][bmPosA] = cache_get_field_content_float(i, "pos_a");
        BlackmarketData[i][bmSkin] = cache_get_field_content_int(i, "skin");
        BlackmarketData[i][bmLabel] = cache_get_field_content_int(i, "label");
        BlackmarketData[i][bmTextID] = Text3D:INVALID_3DTEXT_ID;
        BlackmarketData[i][bmActorID] = INVALID_STREAMER_ID;
        BlackmarketData[i][bmExists] = 1;
        ReloadBlackMarket(i);
    }
}

CMD:createblackmarket(playerid, params[])
{
    new Float:x, Float:y, Float:z, Float:a, skin;
    if(PlayerInfo[playerid][pAdmin] < 6)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
    }
    
    if(sscanf(params, "i", skin))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /createblackmarket [Skin ID]");
    }
    
    if(skin < 0 || skin > 311)
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid Skin ID! (0 - 311).");
    }

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    for(new i = 0; i < MAX_BLACKMARKET; i ++)
    {
        if(!BlackmarketData[i][bmExists])
        {
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO blackmarket (pos_x, pos_y, pos_z, pos_a, skin) VALUES('%f', '%f', '%f', '%f', '%d')", x, y, z, a, skin);
            mysql_tquery(connectionID, queryBuffer, "OnAdminCreateBlackMarket", "iiffffi", playerid, i, x, y, z, a, skin);
            return 1;
        }
    }

    SendClientMessage(playerid, COLOR_GREY, "Black Market slots are currently full. Ask developers to increase the internal limit.");
    return 1;
}

CMD:removeblackmarket(playerid, params[])
{
    new loc;

    if(PlayerInfo[playerid][pAdmin] < 6)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
    }
    if(sscanf(params, "i", loc))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /removeblackmarket [ID]");
    }
    if(!(0 <= loc < MAX_BLACKMARKET) || !BlackmarketData[loc][bmExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid Black Market or Static.");
    }

    if(IsValidDynamic3DTextLabel(BlackmarketData[loc][bmTextID]))
    {
        DestroyDynamic3DTextLabel(BlackmarketData[loc][bmTextID]);
    }
    if(IsValidDynamicActor(BlackmarketData[loc][bmActorID]))
    {
        DestroyDynamicActor(BlackmarketData[loc][bmActorID]);
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM blackmarket WHERE id = %i", BlackmarketData[loc][bmID]);
    mysql_tquery(connectionID, queryBuffer);

    BlackmarketData[loc][bmExists] = false;
    BlackmarketData[loc][bmID] = 0;
    BlackmarketData[loc][bmSkin] = 0;

    SendMessage(playerid, COLOR_WHITE, "** You have removed Black Market [%i].", loc);
    return 1;
}
