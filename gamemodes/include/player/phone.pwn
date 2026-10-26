#include <YSI_Coding\y_hooks>

forward SavePhoneVariables(playerid);
public SavePhoneVariables(playerid)
{
    // Pinagsama ang 6 na magkakahiwalay na queries sa ISANG single query para iwas lag!
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), 
        "UPDATE users SET phonebattery = %i, phonebrand = %i, phoneload = %i, phoneexpired = %i, phonecharger = %i, phonesim = %i WHERE uid = %i", 
        PlayerInfo[playerid][pPhoneBattery], PlayerInfo[playerid][pPhoneBrand], PlayerInfo[playerid][pPhoneLoad], 
        PlayerInfo[playerid][pPhoneExpired], PlayerInfo[playerid][pPhoneCharger], PlayerInfo[playerid][pPhoneSim], 
        PlayerInfo[playerid][pID]
    );
    mysql_tquery(connectionID, queryBuffer);
}

forward ResetPhoneVariables(playerid);
public ResetPhoneVariables(playerid)
{
    PlayerInfo[playerid][pPhoneLoad] = 0;
    PlayerInfo[playerid][pPhoneSim] = 0;
    PlayerInfo[playerid][pPhoneBrand] = 0;
    PlayerInfo[playerid][pPhoneBattery] = 0;
    PlayerInfo[playerid][pPhoneCharger] = 0;
    PlayerInfo[playerid][pPhoneExpired] = 0;
    SavePhoneVariables(playerid);
}

// Inayos ang string return para maging safe sa memory
GetCellphoneBrand(brand_id)
{
    new brand_name[32];
    switch(brand_id)
    {
        case 0: brand_name = "None";
        case 1: brand_name = "Samsung Galaxy";
        case 2: brand_name = "Oppo";
        case 3: brand_name = "Vivo";
        case 4: brand_name = "Realme";
        case 5: brand_name = "IPhone";
        default: brand_name = "None";
    }
    return brand_name;
}

// Inayos ang string return para maging safe sa memory
GetCellphoneSim(sim_id)
{
    new sim_name[32];
    switch(sim_id)
    {
        case 0: sim_name = "None";
        case 1: sim_name = "Dito";
        case 2: sim_name = "Globe";
        case 3: sim_name = "TM";
        case 4: sim_name = "Smart";
        case 5: sim_name = "Tnt";
        default: sim_name = "None";
    }
    return sim_name;
}

CMD:buyphone(playerid, params[])
{
    if(PlayerInfo[playerid][pPhoneBrand])
        return SendClientMessage(playerid, COLOR_SYNTAX, "You already have a cellphone. Wait for it to expire to buy again.");
        
    new string[512], header[64];
    format(header, sizeof(header), "Cellphone Brand Shop");
    
    strcat(string, "Cellphone Brand:\tPrice:\tExpiration:\n");
    strcat(string, "{FFFFFF}Samsung Galaxy\t$15,000\t15 Days\n");
    strcat(string, "{FFFFFF}Oppo\t$25,000\t18 Days\n");
    strcat(string, "{FFFFFF}Vivo\t$35,000\t20 Days\n");
    strcat(string, "{FFFFFF}Realme\t$85,000\t25 Days\n");
    strcat(string, "{FFFFFF}Iphone\t$100,000\t30 Days");
    
    ShowPlayerDialog(playerid, DIALOG_BUY_PHONE, DIALOG_STYLE_TABLIST_HEADERS, header, string, "Buy", "Cancel");
    return 1;
}

CMD:buyload(playerid, params[])
{
    if(!PlayerInfo[playerid][pPhoneBrand])
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have any brand of cellphone.");
    
    if(!PlayerInfo[playerid][pPhoneSim])
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have a sim card.");
        
    new string[512], header[64];
    format(header, sizeof(header), "Cellphone Load Shop");
    
    strcat(string, "Load List:\tPrice:\n");
    strcat(string, "{FFFFFF}20 Load Text & Call\t$500\n");
    strcat(string, "{FFFFFF}25 Load Text & Call\t$750\n");
    strcat(string, "{FFFFFF}35 Load Text & Call\t$900\n");
    strcat(string, "{FFFFFF}40 Load Text & Call\t$1,000\n");
    strcat(string, "{FFFFFF}50 Load Text & Call\t$5,000");
    
    ShowPlayerDialog(playerid, DIALOG_LOAD_PHONE, DIALOG_STYLE_TABLIST_HEADERS, header, string, "Buy", "Cancel");
    return 1;
}

CMD:buysimcard(playerid, params[])
{
    if(!PlayerInfo[playerid][pPhoneBrand])
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have any brand of cellphone.");
        
    new string[512], header[64];
    format(header, sizeof(header), "Simcard Shop");
    
    strcat(string, "Simcard:\tPrice:\n");
    strcat(string, "{FFFFFF}Dito\t$10,000\n");
    strcat(string, "{FFFFFF}Globe\t$8,000\n");
    strcat(string, "{FFFFFF}TM\t$5,000\n");
    strcat(string, "{FFFFFF}Smart\t$3,000\n");
    strcat(string, "{FFFFFF}Tnt\t$1,000");
    
    ShowPlayerDialog(playerid, DIALOG_SIM_PHONE, DIALOG_STYLE_TABLIST_HEADERS, header, string, "Buy", "Cancel");
    return 1;
}

CMD:myphone(playerid, params[])
{
    if(!PlayerInfo[playerid][pPhoneBrand])
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have any brand of cellphone.");
        
    new string[512], header[64], expiration[32];
    expiration = formatdate(PlayerInfo[playerid][pPhoneExpired], 4);

    format(header, sizeof(header), "Cellphone Brand: %s", GetCellphoneBrand(PlayerInfo[playerid][pPhoneBrand]));
    
    strcat(string, "List:\tInfo:\n");
    format(string, sizeof(string), "%s{FFFFFF}Expiration\t{FDE364}%s\n", string, expiration);
    format(string, sizeof(string), "%s{FFFFFF}Number\t{FDE364}%d\n", string, PlayerInfo[playerid][pPhone]);
    format(string, sizeof(string), "%s{FFFFFF}Battery\t{FDE364}%d%%\n", string, PlayerInfo[playerid][pPhoneBattery]);
    format(string, sizeof(string), "%s{FFFFFF}Load\t{FDE364}%d\n", string, PlayerInfo[playerid][pPhoneLoad]);
    format(string, sizeof(string), "%s{FFFFFF}Sim Card\t{FDE364}%s", string, GetCellphoneSim(PlayerInfo[playerid][pPhoneSim]));
    
    ShowPlayerDialog(playerid, DIALOG_MAIN_PHONE, DIALOG_STYLE_TABLIST_HEADERS, header, string, "Close", "");
    return 1;
}

CMD:resetphone(playerid, params[])
{
    ResetPhoneVariables(playerid);
    SendClientMessage(playerid, COLOR_YELLOW, "Your phone variables have been reset.");
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_BUY_PHONE)
    {
        if(response) 
        {
            PlayerInfo[playerid][pPhone] = random(100000) + 899999;
            PlayerInfo[playerid][pPhoneBattery] = 100;
            
            switch(listitem)
            {
                case 0:
                {
                    PlayerInfo[playerid][pPhoneBrand] = 1;
                    PlayerInfo[playerid][pPhoneExpired] = gettime() + (15 * 86400);
                    SendClientMessage(playerid, COLOR_YELLOW, "Thank you for buying Samsung Galaxy Brand!");
                }
                case 1:
                {
                    PlayerInfo[playerid][pPhoneBrand] = 2;
                    PlayerInfo[playerid][pPhoneExpired] = gettime() + (18 * 86400);
                    SendClientMessage(playerid, COLOR_YELLOW, "Thank you for buying Oppo Brand!");
                }
                case 2:
                {
                    PlayerInfo[playerid][pPhoneBrand] = 3;
                    PlayerInfo[playerid][pPhoneExpired] = gettime() + (20 * 86400);
                    SendClientMessage(playerid, COLOR_YELLOW, "Thank you for buying Vivo Brand!");
                }
                case 3:
                {
                    PlayerInfo[playerid][pPhoneBrand] = 4;
                    PlayerInfo[playerid][pPhoneExpired] = gettime() + (25 * 86400);
                    SendClientMessage(playerid, COLOR_YELLOW, "Thank you for buying Realme Brand!");
                }
                case 4:
                {
                    PlayerInfo[playerid][pPhoneBrand] = 5;
                    PlayerInfo[playerid][pPhoneExpired] = gettime() + (30 * 86400);
                    SendClientMessage(playerid, COLOR_YELLOW, "Thank you for buying IPhone Brand!");
                }
            }
            SavePhoneVariables(playerid);
            
            // In-update rin ang phone number sa users table
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phone = %i WHERE uid = %i", PlayerInfo[playerid][pPhone], PlayerInfo[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);
            
            SendClientMessage(playerid, COLOR_SYNTAX, "Your new phone number is %i.", PlayerInfo[playerid][pPhone]);
        }
        return 1;
    }
    if(dialogid == DIALOG_LOAD_PHONE)
    {
        if(response) 
        {
            switch(listitem)
            {
                case 0: { PlayerInfo[playerid][pPhoneLoad] = 20; SendClientMessage(playerid, COLOR_YELLOW, "Thank you for buying 20x text and call load!"); }
                case 1: { PlayerInfo[playerid][pPhoneLoad] = 25; SendClientMessage(playerid, COLOR_YELLOW, "Thank you for buying 25x text and call load!"); }
                case 2: { PlayerInfo[playerid][pPhoneLoad] = 35; SendClientMessage(playerid, COLOR_YELLOW, "Thank you for buying 35x text and call load!"); }
                case 3: { PlayerInfo[playerid][pPhoneLoad] = 40; SendClientMessage(playerid, COLOR_YELLOW, "Thank you for buying 40x text and call load!"); }
                case 4: { PlayerInfo[playerid][pPhoneLoad] = 50; SendClientMessage(playerid, COLOR_YELLOW, "Thank you for buying 50x text and call load!"); }
            }
            SavePhoneVariables(playerid);
        }
        return 1;
    }
    if(dialogid == DIALOG_SIM_PHONE)
    {
        if(response) 
        {
            switch(listitem)
            {
                case 0: { PlayerInfo[playerid][pPhoneSim] = 1; SendClientMessage(playerid, COLOR_YELLOW, "Thank you for buying DITO sim card"); }
                case 1: { PlayerInfo[playerid][pPhoneSim] = 2; SendClientMessage(playerid, COLOR_YELLOW, "Thank you for buying Globe sim card"); }
                case 2: { PlayerInfo[playerid][pPhoneSim] = 3; SendClientMessage(playerid, COLOR_YELLOW, "Thank you for buying TM sim card"); }
                case 3: { PlayerInfo[playerid][pPhoneSim] = 4; SendClientMessage(playerid, COLOR_YELLOW, "Thank you for buying Smart sim card"); }
                case 4: { PlayerInfo[playerid][pPhoneSim] = 5; SendClientMessage(playerid, COLOR_YELLOW, "Thank you for buying Tnt sim card"); }
            }
            SavePhoneVariables(playerid);
        }
        return 1;
    }
    return 0;
}
