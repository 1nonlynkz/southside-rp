#include <YSI_Coding\y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_BP_MAIN)
    {
        if(response)
        {
            SetPVarInt(playerid, "Listitem_Backpack", listitem);
            ShowBackPackCategory(playerid);
        }
        else
        {

        }
    }
    if(dialogid == DIALOG_BP_CATEGORY)
    {
        if(response)
        {
            new bpstring[230], titlestring[64], rpstring[128];
            switch(listitem)
            {
                case 0: 
                { // Put Items into Backpack
                    if(GetPVarInt(playerid, "Listitem_Backpack") >= 4) if(PlayerInfo[playerid][pHours] < 2 || PlayerInfo[playerid][pWeaponRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You are currently weapon restricted!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                    if(GetPVarInt(playerid, "Listitem_Backpack") >= 4) if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You're not allowed to store weapons while in vehicle");
                    switch(GetPVarInt(playerid, "Listitem_Backpack")) 
                    {
                        case 0: 
                        {
                            format(titlestring, sizeof(titlestring), "Put Cash in your %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            format(bpstring, sizeof(bpstring),"Input the amount of Cash that you will put in your %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                            SetPVarInt(playerid, "Type_Action", 1);
                        }
                        case 1: 
                        {
                            format(titlestring, sizeof(titlestring), "Put Pot in your %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            format(bpstring, sizeof(bpstring),"Input the amount of Pot that you will put in your %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                            SetPVarInt(playerid, "Type_Action", 1);
                        }
                        case 2: 
                        {
                            format(titlestring, sizeof(titlestring), "Put Crack in your %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            format(bpstring, sizeof(bpstring),"Input the amount of Crack that you will put in your %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                            SetPVarInt(playerid, "Type_Action", 1);
                        }
                        case 3: 
                        {
                            format(titlestring, sizeof(titlestring), "Put Materials in your %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            format(bpstring, sizeof(bpstring),"Input the amount of Materials that you will put in your %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                            SetPVarInt(playerid, "Type_Action", 1);
                        }
                        case 4: 
                        {
                            new gunid = GetPlayerWeapon(playerid), ammoid = GetPlayerAmmo(playerid);
                            if(!gunid) return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any Gun Equipped"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            if(PlayerInfo[playerid][bpWeapons][0] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "There is already weapon in this Slot!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            
                            format(rpstring, sizeof(rpstring), "Put his %s into their %s", GetWeaponNameEx(gunid), GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);
                            ShowActionObject(playerid);

                            PlayerInfo[playerid][bpWeapons][0] = gunid;
                            PlayerInfo[playerid][bpAmmo][0] = ammoid;
                            RemovePlayerWeapon(playerid, WEAPON:gunid);

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_0 = %i, bpammo_0 = %d WHERE uid = %i", PlayerInfo[playerid][bpWeapons][0], PlayerInfo[playerid][bpAmmo][0], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

                            SavePlayerBackpack(playerid);
                            return ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                        }
                        case 5: 
                        {
                            new gunid = GetPlayerWeapon(playerid), ammoid = GetPlayerAmmo(playerid);
                            if(!gunid) return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any Gun Equipped"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            if(PlayerInfo[playerid][bpWeapons][1] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "There is already weapon in this Slot!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            
                            format(rpstring, sizeof(rpstring), "Put his %s into their %s", GetWeaponNameEx(gunid), GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);
                            ShowActionObject(playerid);

                            PlayerInfo[playerid][bpWeapons][1] = gunid;
                            PlayerInfo[playerid][bpAmmo][1] = ammoid;
                            RemovePlayerWeapon(playerid, WEAPON:gunid);

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_1 = %i, bpammo_1 = %d WHERE uid = %i", PlayerInfo[playerid][bpWeapons][1], PlayerInfo[playerid][bpAmmo][1], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

                            SavePlayerBackpack(playerid);
                            return ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                        }
                        case 6: 
                        {
                            new gunid = GetPlayerWeapon(playerid), ammoid = GetPlayerAmmo(playerid);
                            if(!gunid) return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any Gun Equipped"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            if(PlayerInfo[playerid][bpWeapons][2] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "There is already weapon in this Slot!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            
                            format(rpstring, sizeof(rpstring), "Put his %s into their %s", GetWeaponNameEx(gunid), GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);
                            ShowActionObject(playerid);

                            PlayerInfo[playerid][bpWeapons][2] = gunid;
                            PlayerInfo[playerid][bpAmmo][2] = ammoid;
                            RemovePlayerWeapon(playerid, WEAPON:gunid);

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_2 = %i, bpammo_2 = %d WHERE uid = %i", PlayerInfo[playerid][bpWeapons][2], PlayerInfo[playerid][bpAmmo][2], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

                            SavePlayerBackpack(playerid);
                            return ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                        }
                        case 7: 
                        {
                            new gunid = GetPlayerWeapon(playerid), ammoid = GetPlayerAmmo(playerid);
                            if(!gunid) return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any Gun Equipped"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            if(PlayerInfo[playerid][bpWeapons][3] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "There is already weapon in this Slot!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            
                            format(rpstring, sizeof(rpstring), "Put his %s into their %s", GetWeaponNameEx(gunid), GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);
                            ShowActionObject(playerid);

                            PlayerInfo[playerid][bpWeapons][3] = gunid;
                            PlayerInfo[playerid][bpAmmo][3] = ammoid;
                            RemovePlayerWeapon(playerid, WEAPON:gunid);

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_3 = %i, bpammo_3 = %d WHERE uid = %i", PlayerInfo[playerid][bpWeapons][3], PlayerInfo[playerid][bpAmmo][3], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

                            SavePlayerBackpack(playerid);
                            return ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                        }
                        case 8: 
                        {
                            new gunid = GetPlayerWeapon(playerid), ammoid = GetPlayerAmmo(playerid);
                            if(!gunid) return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any Gun Equipped"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            if(PlayerInfo[playerid][bpWeapons][4] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "There is already weapon in this Slot!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            
                            format(rpstring, sizeof(rpstring), "Put his %s into their %s", GetWeaponNameEx(gunid), GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);
                            ShowActionObject(playerid);

                            PlayerInfo[playerid][bpWeapons][4] = gunid;
                            PlayerInfo[playerid][bpAmmo][4] = ammoid;
                            RemovePlayerWeapon(playerid, WEAPON:gunid);

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_4 = %i, bpammo_4 = %d WHERE uid = %i", PlayerInfo[playerid][bpWeapons][4], PlayerInfo[playerid][bpAmmo][4], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

                            SavePlayerBackpack(playerid);
                            return ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                        }
                        case 9: 
                        {
                            new gunid = GetPlayerWeapon(playerid), ammoid = GetPlayerAmmo(playerid);
                            if(!gunid) return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any Gun Equipped"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            if(PlayerInfo[playerid][bpWeapons][5] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "There is already weapon in this Slot!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            
                            format(rpstring, sizeof(rpstring), "Put his %s into their %s", GetWeaponNameEx(gunid), GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);
                            ShowActionObject(playerid);

                            PlayerInfo[playerid][bpWeapons][5] = gunid;
                            PlayerInfo[playerid][bpAmmo][5] = ammoid;
                            RemovePlayerWeapon(playerid, WEAPON:gunid);

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_5 = %i, bpammo_5 = %d WHERE uid = %i", PlayerInfo[playerid][bpWeapons][5], PlayerInfo[playerid][bpAmmo][5], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);
                            
                            SavePlayerBackpack(playerid);
                            return ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                        }
                        case 10: 
                        {
                            new gunid = GetPlayerWeapon(playerid), ammoid = GetPlayerAmmo(playerid);
                            if(!gunid) return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any Gun Equipped"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            if(PlayerInfo[playerid][bpWeapons][6] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "There is already weapon in this Slot!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            
                            format(rpstring, sizeof(rpstring), "Put his %s into their %s", GetWeaponNameEx(gunid), GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);
                            ShowActionObject(playerid);

                            PlayerInfo[playerid][bpWeapons][6] = gunid;
                            PlayerInfo[playerid][bpAmmo][6] = ammoid;
                            RemovePlayerWeapon(playerid, WEAPON:gunid);

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_6 = %i, bpammo_6 = %d WHERE uid = %i", PlayerInfo[playerid][bpWeapons][6], PlayerInfo[playerid][bpAmmo][6], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

                            SavePlayerBackpack(playerid);
                            return ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                        }
                        case 11: 
                        {
                            new gunid = GetPlayerWeapon(playerid), ammoid = GetPlayerAmmo(playerid);
                            if(!gunid) return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any Gun Equipped"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            if(PlayerInfo[playerid][bpWeapons][7] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "There is already weapon in this Slot!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            
                            format(rpstring, sizeof(rpstring), "Put his %s into their %s", GetWeaponNameEx(gunid), GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);
                            ShowActionObject(playerid);

                            PlayerInfo[playerid][bpWeapons][7] = gunid;
                            PlayerInfo[playerid][bpAmmo][7] = ammoid;
                            RemovePlayerWeapon(playerid, WEAPON:gunid);

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_7 = %i, bpammo_7 = %d WHERE uid = %i", PlayerInfo[playerid][bpWeapons][7], PlayerInfo[playerid][bpAmmo][7], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

                            SavePlayerBackpack(playerid);
                            return ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                        }
                    }
                }
                case 1: 
                { // Take Items into Backpack
                    switch(GetPVarInt(playerid, "Listitem_Backpack")) 
                    {
                        case 0: 
                        {
                            format(titlestring, sizeof(titlestring), "Take Cash in your %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            format(bpstring, sizeof(bpstring),"Input the amount of Cash that you will take in your %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Take", "Back");
                            SetPVarInt(playerid, "Type_Action", 2);
                        }
                        case 1: 
                        {
                            format(titlestring, sizeof(titlestring), "Take Pot in your %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            format(bpstring, sizeof(bpstring),"Input the amount of Pot that you will take in your %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Take", "Back");
                            SetPVarInt(playerid, "Type_Action", 2);
                        }
                        case 2: 
                        {
                            format(titlestring, sizeof(titlestring), "Take Crack in your %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            format(bpstring, sizeof(bpstring),"Input the amount of Crack that you will take in your %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Take", "Back");
                            SetPVarInt(playerid, "Type_Action", 2);
                        }
                        case 3: 
                        {
                            format(titlestring, sizeof(titlestring), "Take Materials in your %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            format(bpstring, sizeof(bpstring),"Input the amount of Materials that you will take in your %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Take", "Back");
                            SetPVarInt(playerid, "Type_Action", 2);
                        }
                        case 4: 
                        {
                            new gunid = PlayerInfo[playerid][bpWeapons][0];
                            new ammoid = PlayerInfo[playerid][bpAmmo][0];
                            if(!gunid) return SendClientMessageEx(playerid, COLOR_GREY, "You dont have any Weapon in this Slot!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            if(PlayerInfo[playerid][pWeapons][CheckWeaponSlot(gunid)] == gunid) return  SendClientMessageEx(playerid, COLOR_GREY, "You already have this weapon in your hand!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            
                            format(rpstring, sizeof(rpstring), "Take his %s from their %s", GetWeaponNameEx(gunid), GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);
                            ShowActionObject(playerid);

                            GivePlayerWeaponEx(playerid, gunid, ammoid);
                            PlayerInfo[playerid][bpWeapons][0] = 0;
                            PlayerInfo[playerid][bpAmmo][0] = 0;

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_0 = 0 WHERE uid = %i", PlayerInfo[playerid][bpWeapons][0], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

                            SavePlayerBackpack(playerid);
                            ShowPlayerBackPack(playerid);
                            DeletePVar(playerid, "Listitem_Backpack");
                            return 1;
                        }
                        case 5: 
                        {
                            new gunid = PlayerInfo[playerid][bpWeapons][1];
                            new ammoid = PlayerInfo[playerid][bpAmmo][1];
                            if(!gunid) return SendClientMessageEx(playerid, COLOR_GREY, "You dont have any Weapon in this Slot!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            if(PlayerInfo[playerid][pWeapons][CheckWeaponSlot(gunid)] == gunid) return  SendClientMessageEx(playerid, COLOR_GREY, "You already have this weapon in your hand!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            
                            format(rpstring, sizeof(rpstring), "Take his %s from their %s", GetWeaponNameEx(gunid), GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);
                            ShowActionObject(playerid);

                            GivePlayerWeaponEx(playerid, gunid, ammoid);
                            PlayerInfo[playerid][bpWeapons][1] = 0;
                            PlayerInfo[playerid][bpAmmo][1] = 0;

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_1 = 0 WHERE uid = %i", PlayerInfo[playerid][bpWeapons][1], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

                            SavePlayerBackpack(playerid);
                            ShowPlayerBackPack(playerid);
                            DeletePVar(playerid, "Listitem_Backpack");
                            return 1;
                        }
                        case 6: 
                        {
                            new gunid = PlayerInfo[playerid][bpWeapons][2];
                            new ammoid = PlayerInfo[playerid][bpAmmo][2];
                            if(!gunid) return SendClientMessageEx(playerid, COLOR_GREY, "You dont have any Weapon in this Slot!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            if(PlayerInfo[playerid][pWeapons][CheckWeaponSlot(gunid)] == gunid) return  SendClientMessageEx(playerid, COLOR_GREY, "You already have this weapon in your hand!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            
                            format(rpstring, sizeof(rpstring), "Take his %s from their %s", GetWeaponNameEx(gunid), GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);
                            ShowActionObject(playerid);

                            GivePlayerWeaponEx(playerid, gunid, ammoid);
                            PlayerInfo[playerid][bpWeapons][2] = 0;
                            PlayerInfo[playerid][bpAmmo][2] = 0;

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_2 = 0 WHERE uid = %i", PlayerInfo[playerid][bpWeapons][2], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

                            SavePlayerBackpack(playerid);
                            ShowPlayerBackPack(playerid);
                            DeletePVar(playerid, "Listitem_Backpack");
                            return 1;
                        }
                        case 7: 
                        {
                            new gunid = PlayerInfo[playerid][bpWeapons][3];
                            new ammoid = PlayerInfo[playerid][bpAmmo][3];
                            if(!gunid) return SendClientMessageEx(playerid, COLOR_GREY, "You dont have any Weapon in this Slot!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            if(PlayerInfo[playerid][pWeapons][CheckWeaponSlot(gunid)] == gunid) return  SendClientMessageEx(playerid, COLOR_GREY, "You already have this weapon in your hand!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            
                            format(rpstring, sizeof(rpstring), "Take his %s from their %s", GetWeaponNameEx(gunid), GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);
                            ShowActionObject(playerid);

                            GivePlayerWeaponEx(playerid, gunid, ammoid);
                            PlayerInfo[playerid][bpWeapons][3] = 0;
                            PlayerInfo[playerid][bpAmmo][3] = 0;

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_3 = 0 WHERE uid = %i", PlayerInfo[playerid][bpWeapons][3], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

                            SavePlayerBackpack(playerid);
                            ShowPlayerBackPack(playerid);
                            DeletePVar(playerid, "Listitem_Backpack");
                            return 1;
                        }
                        case 8: 
                        {
                            new gunid = PlayerInfo[playerid][bpWeapons][4];
                            new ammoid = PlayerInfo[playerid][bpAmmo][4];
                            if(!gunid) return SendClientMessageEx(playerid, COLOR_GREY, "You dont have any Weapon in this Slot!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            if(PlayerInfo[playerid][pWeapons][CheckWeaponSlot(gunid)] == gunid) return  SendClientMessageEx(playerid, COLOR_GREY, "You already have this weapon in your hand!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            
                            format(rpstring, sizeof(rpstring), "Take his %s from their %s", GetWeaponNameEx(gunid), GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);
                            ShowActionObject(playerid);

                            GivePlayerWeaponEx(playerid, gunid, ammoid);
                            PlayerInfo[playerid][bpWeapons][4] = 0;
                            PlayerInfo[playerid][bpAmmo][4] = 0;

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_4 = 0 WHERE uid = %i", PlayerInfo[playerid][bpWeapons][4], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

                            SavePlayerBackpack(playerid);
                            ShowPlayerBackPack(playerid);
                            DeletePVar(playerid, "Listitem_Backpack");
                            return 1;
                        }
                        case 9: 
                        {
                            new gunid = PlayerInfo[playerid][bpWeapons][5];
                            new ammoid = PlayerInfo[playerid][bpAmmo][5];
                            if(!gunid) return SendClientMessageEx(playerid, COLOR_GREY, "You dont have any Weapon in this Slot!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            if(PlayerInfo[playerid][pWeapons][CheckWeaponSlot(gunid)] == gunid) return  SendClientMessageEx(playerid, COLOR_GREY, "You already have this weapon in your hand!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            
                            format(rpstring, sizeof(rpstring), "Take his %s from their %s", GetWeaponNameEx(gunid), GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);
                            ShowActionObject(playerid);

                            GivePlayerWeaponEx(playerid, gunid, ammoid);
                            PlayerInfo[playerid][bpWeapons][5] = 0;
                            PlayerInfo[playerid][bpAmmo][5] = 0;

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_5 = 0 WHERE uid = %i", PlayerInfo[playerid][bpWeapons][5], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

                            SavePlayerBackpack(playerid);
                            ShowPlayerBackPack(playerid);
                            DeletePVar(playerid, "Listitem_Backpack");
                            return 1;
                        }
                        case 10: 
                        {
                            new gunid = PlayerInfo[playerid][bpWeapons][6];
                            new ammoid = PlayerInfo[playerid][bpAmmo][6];
                            if(!gunid) return SendClientMessageEx(playerid, COLOR_GREY, "You dont have any Weapon in this Slot!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            if(PlayerInfo[playerid][pWeapons][CheckWeaponSlot(gunid)] == gunid) return  SendClientMessageEx(playerid, COLOR_GREY, "You already have this weapon in your hand!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            
                            format(rpstring, sizeof(rpstring), "Take his %s from their %s", GetWeaponNameEx(gunid), GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);
                            ShowActionObject(playerid);

                            GivePlayerWeaponEx(playerid, gunid, ammoid);
                            PlayerInfo[playerid][bpWeapons][6] = 0;
                            PlayerInfo[playerid][bpAmmo][6] = 0;

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_6 = 0 WHERE uid = %i", PlayerInfo[playerid][bpWeapons][6], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

                            SavePlayerBackpack(playerid);
                            ShowPlayerBackPack(playerid);
                            DeletePVar(playerid, "Listitem_Backpack");
                            return 1;
                        }
                        case 11: 
                        {
                            new gunid = PlayerInfo[playerid][bpWeapons][7];
                            new ammoid = PlayerInfo[playerid][bpAmmo][7];
                            if(!gunid) return SendClientMessageEx(playerid, COLOR_GREY, "You dont have any Weapon in this Slot!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            if(PlayerInfo[playerid][pWeapons][CheckWeaponSlot(gunid)] == gunid) return  SendClientMessageEx(playerid, COLOR_GREY, "You already have this weapon in your hand!"), ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack");
                            
                            format(rpstring, sizeof(rpstring), "Take his %s from their %s", GetWeaponNameEx(gunid), GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);
                            ShowActionObject(playerid);

                            GivePlayerWeaponEx(playerid, gunid, ammoid);
                            PlayerInfo[playerid][bpWeapons][7] = 0;
                            PlayerInfo[playerid][bpAmmo][7] = 0;

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET bpweapon_7 = 0 WHERE uid = %i", PlayerInfo[playerid][bpWeapons][7], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);

                            SavePlayerBackpack(playerid);
                            ShowPlayerBackPack(playerid);
                            DeletePVar(playerid, "Listitem_Backpack");
                            return 1;
                        }
                    }
                }
            }
        }   
    }
    if(dialogid == DIALOG_PUT_TAKE)
    {
        if(response)
        {
            new bpstring[300], titlestring[64], rpstring[128];
            if(!GetPVarType(playerid, "Type_Action")) return SendClientMessageEx(playerid, COLOR_GREY, "An Error Occur during the Action Taking/Putting Items");
            if(isnull(inputtext)) return ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack"), DeletePVar(playerid, "Type_Action");
            switch(GetPVarInt(playerid, "Type_Action"))
            {
                case 1: // Put Items
                {
                    switch(GetPVarInt(playerid, "Listitem_Backpack"))
                    {
                        case 0: 
                        {
                            if(!IsNumeric(inputtext))
                            {
                                format(titlestring, sizeof(titlestring), "Put Cash in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: That's not a number\nInput the amount of Cash that you will put in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                                return 1;
                            }
                            new cash = strval(inputtext);
                            if(cash < 1 || cash > PlayerInfo[playerid][pCash])
                            {
                                format(titlestring, sizeof(titlestring), "Put Cash in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: You don't have enough cash\nInput the amount of Cash that you will put in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                                return 1;
                            }
                            if(GetPlayerCash(playerid) < cash)
                            {
                                format(titlestring, sizeof(titlestring), "Put Cash in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: Must not be 0 or a Negative value!\nInput the amount of Cash that you will put in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                                return 1;
                            }
                            if(PlayerInfo[playerid][bpCash] + cash > GetBackpackCapacity(playerid, STASH_CAPACITY_CASH))
                            {
                                format(titlestring, sizeof(titlestring), "Put Cash in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: Your backpack can only hold up to %i cash at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_CASH));
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                                return 1;
                            }

                            format(rpstring, sizeof(rpstring), "Take's out some cash and put it in his %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);

                            GivePlayerCash(playerid, -cash);
                            PlayerInfo[playerid][bpCash] +=cash;

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cash = %i WHERE uid = %i", PlayerInfo[playerid][pCash], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);
                            SavePlayerVariables(playerid);
                            SavePlayerBackpack(playerid);

                            return ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack"), DeletePVar(playerid, "Type_Action");
                        }
                        case 1:
                        {
                            if(!IsNumeric(inputtext))
                            {
                                format(titlestring, sizeof(titlestring), "Put Pots in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: That's not a number\nInput the amount of Pots that you will put in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                                return 1;
                            }
                            new pots = strval(inputtext);
                            if(pots < 1 || pots > PlayerInfo[playerid][pPot])
                            {
                                format(titlestring, sizeof(titlestring), "Put Pots in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: You don't have enough pots\nInput the amount of pots that you will put in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                                return 1;
                            }
                            if(PlayerInfo[playerid][pPot] < pots)
                            {
                                format(titlestring, sizeof(titlestring), "Put Pots in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: Must not be 0 or a Negative value!\nInput the amount of Pots that you will put in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                                return 1;
                            }
                            if(PlayerInfo[playerid][bpPot] + pots > GetBackpackCapacity(playerid, STASH_CAPACITY_WEED))
                            {
                                format(titlestring, sizeof(titlestring), "Put Pots in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: Your backpack can only hold up to %i pot at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_WEED));
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                                return 1;
                            }

                            format(rpstring, sizeof(rpstring), "Take's out some pot and put it in his %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);

                            PlayerInfo[playerid][pPot] -= pots;
                            PlayerInfo[playerid][bpPot] +=pots;

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);
                            SavePlayerVariables(playerid);
                            SavePlayerBackpack(playerid);
                            
                            return ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack"), DeletePVar(playerid, "Type_Action");
                        }
                        case 2:
                        {
                            if(!IsNumeric(inputtext))
                            {
                                format(titlestring, sizeof(titlestring), "Put Crack in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: That's not a number\nInput the amount of Crack that you will put in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                                return 1;
                            }
                            new cracks = strval(inputtext);
                            if(cracks < 1 || cracks > PlayerInfo[playerid][pCrack])
                            {
                                format(titlestring, sizeof(titlestring), "Put Crack in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: You don't have enough crack\nInput the amount of crack that you will put in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                                return 1;
                            }
                            if(PlayerInfo[playerid][pCrack] < cracks)
                            {
                                format(titlestring, sizeof(titlestring), "Put Crack in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: Must not be 0 or a Negative value!\nInput the amount of Crack that you will put in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                                return 1;
                            }
                            if(PlayerInfo[playerid][bpCrack] + cracks > GetBackpackCapacity(playerid, STASH_CAPACITY_COCAINE))
                            {
                                format(titlestring, sizeof(titlestring), "Put Crack in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: Your backpack can only hold up to %i crack at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_COCAINE));
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                                return 1;
                            }

                            format(rpstring, sizeof(rpstring), "Take's out some cracks and put it in his %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);

                            PlayerInfo[playerid][pCrack] -= cracks;
                            PlayerInfo[playerid][bpCrack] +=cracks;

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);
                            SavePlayerVariables(playerid);
                            SavePlayerBackpack(playerid);

                            return ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack"), DeletePVar(playerid, "Type_Action");
                        }
                        case 3:
                        {
                            if(!IsNumeric(inputtext))
                            {
                                format(titlestring, sizeof(titlestring), "Put Materials in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: That's not a number\nInput the amount of Materials that you will put in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                                return 1;
                            }
                            new mats = strval(inputtext);
                            if(mats < 1 || mats > PlayerInfo[playerid][pMaterials])
                            {
                                format(titlestring, sizeof(titlestring), "Put Materials in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: You don't have enough Materials\nInput the amount of Materials that you will put in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                                return 1;
                            }
                            if(PlayerInfo[playerid][pMaterials] < mats)
                            {
                                format(titlestring, sizeof(titlestring), "Put Materials in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: Must not be 0 or a Negative value!\nInput the amount of Materials that you will put in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                                return 1;
                            }
                            if(PlayerInfo[playerid][bpMaterials] + mats > GetBackpackCapacity(playerid, STASH_CAPACITY_MATERIALS))
                            {
                                format(titlestring, sizeof(titlestring), "Put Materials in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: Your backpack can only hold up to %i materials at its level.", GetBackpackCapacity(playerid, STASH_CAPACITY_MATERIALS));
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                                return 1;
                            }

                            format(rpstring, sizeof(rpstring), "Take's out some materials and put it in his %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);
                            PlayerInfo[playerid][pMaterials] -= mats;
                            PlayerInfo[playerid][bpMaterials] +=mats;

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);
                            SavePlayerVariables(playerid);
                            SavePlayerBackpack(playerid);

                            return ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack"), DeletePVar(playerid, "Type_Action");
                        }
                    }
                }
                case 2: // Take Items
                {
                    switch(GetPVarInt(playerid, "Listitem_Backpack"))
                    {
                        case 0: 
                        {
                            if(!IsNumeric(inputtext))
                            {
                                format(titlestring, sizeof(titlestring), "Take Cash in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: That's not a number\nInput the amount of Cash that you will take in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Take", "Back");
                                return 1;
                            }
                            new amount = strval(inputtext);
                            if(amount < 1 || amount > PlayerInfo[playerid][bpCash])
                            {
                                format(titlestring, sizeof(titlestring), "Take Cash in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: You don't have enough cash\nInput the amount of cash that you will put in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Put", "Back");
                                return 1;
                            }

                            format(rpstring, sizeof(rpstring), "Take's out some cash from his %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);

                            GivePlayerCash(playerid, amount);
                            PlayerInfo[playerid][bpCash] -=amount;

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cash = %i WHERE uid = %i", PlayerInfo[playerid][pCash], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);
                            SavePlayerVariables(playerid);
                            SavePlayerBackpack(playerid);

                            return ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack"), DeletePVar(playerid, "Type_Action");
                        }
                        case 1:
                        {
                            if(!IsNumeric(inputtext))
                            {
                                format(titlestring, sizeof(titlestring), "Take Pots in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: That's not a number\nInput the amount of Pots that you will take in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Take", "Back");
                                return 1;
                            }
                            new pots = strval(inputtext);
                            if(pots < 1 || pots > PlayerInfo[playerid][bpPot])
                            {
                                format(titlestring, sizeof(titlestring), "Take Pots in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: You don't have enough Pots\nInput the amount of Pots that you will take in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Take", "Back");
                                return 1;
                            }

                            format(rpstring, sizeof(rpstring), "Take's out some Pots from his %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);

                            PlayerInfo[playerid][pPot] +=pots;
                            PlayerInfo[playerid][bpPot] -=pots;

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[playerid][pPot], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);
                            SavePlayerVariables(playerid);
                            SavePlayerBackpack(playerid);

                            return ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack"), DeletePVar(playerid, "Type_Action");
                        }
                        case 2:
                        {
                            if(!IsNumeric(inputtext))
                            {
                                format(titlestring, sizeof(titlestring), "Take Crack in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: That's not a number\nInput the amount of Crack that you will take in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Take", "Back");
                                return 1;
                            }
                            new cracks = strval(inputtext);
                            if(cracks < 1 || cracks > PlayerInfo[playerid][bpCrack])
                            {
                                format(titlestring, sizeof(titlestring), "Take Crack in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: You don't have enough Crack\nInput the amount of Crack that you will take in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Take", "Back");
                                return 1;
                            }

                            format(rpstring, sizeof(rpstring), "Take's out some Crack from his %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);

                            PlayerInfo[playerid][pCrack] +=cracks;
                            PlayerInfo[playerid][bpCrack] -=cracks;

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET crack = %i WHERE uid = %i", PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);
                            SavePlayerVariables(playerid);
                            SavePlayerBackpack(playerid);

                            return ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack"), DeletePVar(playerid, "Type_Action");
                        }
                        case 3:
                        {
                            if(!IsNumeric(inputtext))
                            {
                                format(titlestring, sizeof(titlestring), "Take Materials in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: That's not a number\nInput the amount of Materials that you will take in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Take", "Back");
                                return 1;
                            }
                            new mats = strval(inputtext);
                            if(mats < 1 || mats > PlayerInfo[playerid][bpMaterials])
                            {
                                format(titlestring, sizeof(titlestring), "Take Materials in your Backpack");
                                format(bpstring, sizeof(bpstring),"ERROR: You don't have enough Materials\nInput the amount of Materials that you will take in your Backpack");
                                ShowPlayerDialog(playerid, DIALOG_PUT_TAKE, DIALOG_STYLE_INPUT, titlestring, bpstring, "Take", "Back");
                                return 1;
                            }

                            format(rpstring, sizeof(rpstring), "Take's out some Materials from his %s", GetPlayerBackPackType(PlayerInfo[playerid][pBackpack]));
                            callcmd::me(playerid, rpstring);

                            PlayerInfo[playerid][pMaterials] +=mats;
                            PlayerInfo[playerid][bpMaterials] -=mats;

                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET materials = %i WHERE uid = %i", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]);
                            mysql_tquery(connectionID, queryBuffer);
                            SavePlayerVariables(playerid);
                            SavePlayerBackpack(playerid);
                            
                            return ShowPlayerBackPack(playerid), DeletePVar(playerid, "Listitem_Backpack"), DeletePVar(playerid, "Type_Action");
                        }
                    }
                }
            }
        }
    }
    return 1;
}