#include <YSI_Coding\y_hooks>

enum {
    LICENSE_CAR = 0,  
    LICENSE_WEAPON,  
    LICENSE_JOB      
};

new PlayerText:NationalTD[MAX_PLAYERS][33];
new ID_Timer[MAX_PLAYERS] = { -1, ... };
new ShowingToTarget[MAX_PLAYERS] = { INVALID_PLAYER_ID, ... };

hook OnPlayerConnect(playerid) 
{
    for(new i = 0; i != MAX_CONTACTS; i ++) 
    {
	    ContactData[playerid][i][contactExists] = false;
	    ContactData[playerid][i][contactID] = 0;
	    ContactData[playerid][i][contactNumber] = 0;
	    ListedContacts[playerid][i] = -1;
	}
	
    ID_Timer[playerid] = -1;
    ShowingToTarget[playerid] = INVALID_PLAYER_ID;

    InitNationalTD(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) 
{
    if (ID_Timer[playerid] != -1) 
    {
        KillTimer(ID_Timer[playerid]);
        ID_Timer[playerid] = -1;
    }

    SavePlayerLicenses(playerid);
    return 1;
}

stock LoadPlayerLicenses(playerid) {
    new query[128];
    mysql_format(connectionID, query, sizeof(query), "SELECT CarLic, WeaponLic, JobLic FROM users WHERE uid = %d LIMIT 1", PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, query, "OnLoadPlayerLicenses", "i", playerid);
}

forward OnLoadPlayerLicenses(playerid);
public OnLoadPlayerLicenses(playerid) 
{
    if (cache_num_rows() > 0) 
    {
        PlayerInfo[playerid][pCarLic] = cache_get_field_content_int(0, "CarLic", connectionID);
        PlayerInfo[playerid][pWeaponLic] = cache_get_field_content_int(0, "WeaponLic", connectionID);
        PlayerInfo[playerid][pJobLic] = cache_get_field_content_int(0, "JobLic", connectionID);
    }
    return 1;
}

stock SavePlayerLicenses(playerid) {
    new query[256];
    mysql_format(connectionID, query, sizeof(query), "UPDATE users SET CarLic = %d, WeaponLic = %d, JobLic = %d WHERE uid = %d", PlayerInfo[playerid][pCarLic], PlayerInfo[playerid][pWeaponLic], PlayerInfo[playerid][pJobLic], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, query);
    return 1;
}

CMD:buylicense(playerid, params[]) {
    new string[500];
    strcat(string, "License Name\tPrice\tStatus\n");
    format(string, sizeof(string), "%s{00FF00}Driver's License\t$500\t%s\n", string, (PlayerInfo[playerid][pCarLic]) ? ("{00FF00}Owned") : ("{FF0000}Not Owned"));
    format(string, sizeof(string), "%s{FF0000}Weapon License\t$2,500\t%s\n", string, (PlayerInfo[playerid][pWeaponLic]) ? ("{00FF00}Owned") : ("{FF0000}Not Owned"));
    format(string, sizeof(string), "%s{00FFFF}Job License\t$1,000\t%s", string, (PlayerInfo[playerid][pJobLic]) ? ("{00FF00}Owned") : ("{FF0000}Not Owned"));

    ShowPlayerDialog(playerid, DIALOG_BUY_LICENSE, DIALOG_STYLE_TABLIST_HEADERS, "City Hall - License Application", string, "Buy", "Cancel");
    return 1;
}

CMD:showid(playerid, params[]) {
    new targetid;
    if(sscanf(params, "u", targetid)) {
        return SendClientMessage(playerid, COLOR_GREY, "USAGE: /showid [playerid]");
    }
    if(!IsPlayerConnected(targetid)) {
        return SendClientMessage(playerid, COLOR_GREY, "ERROR: Player is not connected.");
    }

    ShowingToTarget[playerid] = targetid;

    new string[300];
    strcat(string, "License Type\tStatus\n");
    format(string, sizeof(string), "%sDriver's License\t%s\n", string, (PlayerInfo[playerid][pCarLic]) ? ("{00FF00}Available") : ("{FF0000}N/A"));
    format(string, sizeof(string), "%sWeapon License\t%s\n", string, (PlayerInfo[playerid][pWeaponLic]) ? ("{00FF00}Available") : ("{FF0000}N/A"));
    format(string, sizeof(string), "%sJob License\t%s", string, (PlayerInfo[playerid][pJobLic]) ? ("{00FF00}Available") : ("{FF0000}N/A"));

    ShowPlayerDialog(playerid, DIALOG_SHOW_LICENSE, DIALOG_STYLE_TABLIST_HEADERS, "Select License to Show", string, "Show", "Cancel");
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid == DIALOG_BUY_LICENSE) {
        if(!response) return 1;

        switch(listitem) {
            case 0: { // Driver's License
                if(PlayerInfo[playerid][pCarLic]) return SendClientMessage(playerid, COLOR_GREY, "ERROR: You already have this license.");
                if(GetPlayerMoney(playerid) < 500) return SendClientMessage(playerid, COLOR_GREY, "ERROR: You need $500.");
                
                GivePlayerMoney(playerid, -500);
                PlayerInfo[playerid][pCarLic] = 1;
                SavePlayerLicenses(playerid);
                
                SendClientMessage(playerid, COLOR_GREEN, "SUCCESS: Purchased Driver's License!");
                ShowNationalID(playerid, playerid, LICENSE_CAR);
            }
            case 1: { // Weapon License
                if(PlayerInfo[playerid][pWeaponLic]) return SendClientMessage(playerid, COLOR_GREY, "ERROR: You already have this license.");
                if(GetPlayerMoney(playerid) < 2500) return SendClientMessage(playerid, COLOR_GREY, "ERROR: You need $2,500.");
                
                GivePlayerMoney(playerid, -2500);
                PlayerInfo[playerid][pWeaponLic] = 1;
                SavePlayerLicenses(playerid);
                
                SendClientMessage(playerid, COLOR_GREEN, "SUCCESS: Purchased Weapon License!");
                ShowNationalID(playerid, playerid, LICENSE_WEAPON);
            }
            case 2: { // Job License
                if(PlayerInfo[playerid][pJobLic]) return SendClientMessage(playerid, COLOR_GREY, "ERROR: You already have this license.");
                if(GetPlayerMoney(playerid) < 1000) return SendClientMessage(playerid, COLOR_GREY, "ERROR: You need $1,000.");
                
                GivePlayerMoney(playerid, -1000);
                PlayerInfo[playerid][pJobLic] = 1;
                SavePlayerLicenses(playerid);
                
                SendClientMessage(playerid, COLOR_GREEN, "SUCCESS: Purchased Job License!");
                ShowNationalID(playerid, playerid, LICENSE_JOB);
            }
        }
        return 1;
    }
    
    if(dialogid == DIALOG_SHOW_LICENSE) {
        if(!response) return 1;

        new targetid = ShowingToTarget[playerid];
        if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "ERROR: Target player left.");

        switch(listitem) {
            case 0: {
                if(!PlayerInfo[playerid][pCarLic]) return SendClientMessage(playerid, COLOR_GREY, "ERROR: You don't have a Driver's License.");
                ShowNationalID(playerid, targetid, LICENSE_CAR);
            }
            case 1: {
                if(!PlayerInfo[playerid][pWeaponLic]) return SendClientMessage(playerid, COLOR_GREY, "ERROR: You don't have a Weapon License.");
                ShowNationalID(playerid, targetid, LICENSE_WEAPON);
            }
            case 2: {
                if(!PlayerInfo[playerid][pJobLic]) return SendClientMessage(playerid, COLOR_GREY, "ERROR: You don't have a Job License.");
                ShowNationalID(playerid, targetid, LICENSE_JOB);
            }
        }
        return 1;
    }
    return 0;
}

ShowNationalID(ownerid, viewerid, license_type = LICENSE_CAR) {
    new age[16], idn[16], border_color, box_color;
    
    if(ID_Timer[viewerid] != -1) {
        KillTimer(ID_Timer[viewerid]);
        ID_Timer[viewerid] = -1;
    }

    switch(license_type) {
        case LICENSE_WEAPON: {
            border_color = 0xFF0000FF; // Red
            box_color = 0xAA0000FF;    
        }
        case LICENSE_JOB: {
            border_color = 0x00FF00FF; // Green
            box_color = 0x00AA00FF;    
        }
        default: {
            border_color = 1677787135; // Default Blue/Grey
            box_color = -1094795726;
        }
    }

    PlayerTextDrawColor(viewerid, NationalTD[viewerid][6], border_color);
    PlayerTextDrawColor(viewerid, NationalTD[viewerid][7], border_color);
    PlayerTextDrawColor(viewerid, NationalTD[viewerid][11], border_color);
    PlayerTextDrawColor(viewerid, NationalTD[viewerid][12], border_color);
    PlayerTextDrawColor(viewerid, NationalTD[viewerid][14], border_color);
    PlayerTextDrawColor(viewerid, NationalTD[viewerid][15], border_color);
    PlayerTextDrawColor(viewerid, NationalTD[viewerid][16], border_color);
    PlayerTextDrawBoxColor(viewerid, NationalTD[viewerid][0], box_color);

    format(age, sizeof(age), "%i Years Old", PlayerInfo[ownerid][pAge]);
    PlayerTextDrawSetString(viewerid, NationalTD[viewerid][28], age);

    PlayerTextDrawSetPreviewModel(viewerid, NationalTD[viewerid][17], PlayerInfo[ownerid][pSkin]);
    PlayerTextDrawSetString(viewerid, NationalTD[viewerid][26], ReturnPlayerRPName(ownerid));
    PlayerTextDrawSetString(viewerid, NationalTD[viewerid][29], "San Andreas");

    format(idn, sizeof(idn), "NID%i", PlayerInfo[ownerid][pNationalIDN]);
    PlayerTextDrawSetString(viewerid, NationalTD[viewerid][31], idn);
    PlayerTextDrawSetString(viewerid, NationalTD[viewerid][27], GetPlayerGender(ownerid));

    for(new i = 0; i < 33; i++) {
        PlayerTextDrawShow(viewerid, NationalTD[viewerid][i]);
    }

    ID_Timer[viewerid] = SetTimerEx("HideNationalTD", 5000, false, "i", viewerid);
    return 1;
}

forward HideNationalTD(playerid);
public HideNationalTD(playerid) {
    ID_Timer[playerid] = -1;
    for(new i = 0; i < 33; i++) {
        PlayerTextDrawHide(playerid, NationalTD[playerid][i]);
    }
    return 1;
}

stock GetPlayerGender(playerid) {
    new gender[12];
    if(PlayerInfo[playerid][pGender] == 1) gender = "Male";
    else if(PlayerInfo[playerid][pGender] == 2) gender = "Female";
    else gender = "Unknown";
    return gender;
}

InitNationalTD(playerid) {
    NationalTD[playerid][0] = CreatePlayerTextDraw(playerid, 491.000000, 198.000000, "ld_dual:white");
    PlayerTextDrawFont(playerid, NationalTD[playerid][0], TEXT_DRAW_FONT_SPRITE_DRAW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][0], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][0], 136.500000, 102.500000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][0], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][0], -1061109505);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][0], -1094795726);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][0], 0);

    NationalTD[playerid][1] = CreatePlayerTextDraw(playerid, 484.000000, 196.000000, "ld_beat:chit");
    PlayerTextDrawFont(playerid, NationalTD[playerid][1], TEXT_DRAW_FONT_SPRITE_DRAW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][1], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][1], 12.000000, 14.000000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][1], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][1], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][1], 255);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][1], 50);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][1], 0);

    NationalTD[playerid][2] = CreatePlayerTextDraw(playerid, 556.000000, 308.500000, "I");
    PlayerTextDrawFont(playerid, NationalTD[playerid][2], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][2], 7.204154, -10.600000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][2], 603.500000, 45.500000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][2], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][2], TEXT_DRAW_ALIGN_RIGHT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][2], 100);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][2], 90);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][2], 210);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][2], 0);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][2], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][2], 0);

    NationalTD[playerid][3] = CreatePlayerTextDraw(playerid, 486.000000, 203.000000, "ld_dual:white");
    PlayerTextDrawFont(playerid, NationalTD[playerid][3], TEXT_DRAW_FONT_SPRITE_DRAW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][3], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][3], 5.500000, 94.000000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][3], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][3], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][3], 255);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][3], 50);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][3], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][3], 0);

    NationalTD[playerid][4] = CreatePlayerTextDraw(playerid, 621.000000, 196.000000, "ld_beat:chit");
    PlayerTextDrawFont(playerid, NationalTD[playerid][4], TEXT_DRAW_FONT_SPRITE_DRAW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][4], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][4], 12.000000, 14.000000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][4], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][4], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][4], -1);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][4], 255);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][4], 50);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][4], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][4], 0);

    NationalTD[playerid][5] = CreatePlayerTextDraw(playerid, 626.000000, 203.000000, "ld_dual:white");
    PlayerTextDrawFont(playerid, NationalTD[playerid][5], TEXT_DRAW_FONT_SPRITE_DRAW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][5], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][5], 5.500000, 94.000000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][5], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][5], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][5], 255);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][5], 50);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][5], 1);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][5], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][5], 0);

    NationalTD[playerid][6] = CreatePlayerTextDraw(playerid, 484.000000, 289.000000, "ld_beat:chit");
    PlayerTextDrawFont(playerid, NationalTD[playerid][6], TEXT_DRAW_FONT_SPRITE_DRAW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][6], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][6], 12.000000, 14.000000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][6], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][6], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][6], 1677787135);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][6], 255);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][6], 50);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][6], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][6], 0);

    NationalTD[playerid][7] = CreatePlayerTextDraw(playerid, 621.000000, 289.000000, "ld_beat:chit");
    PlayerTextDrawFont(playerid, NationalTD[playerid][7], TEXT_DRAW_FONT_SPRITE_DRAW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][7], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][7], 12.500000, 14.000000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][7], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][7], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][7], 1677787135);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][7], 255);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][7], 50);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][7], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][7], 0);

    NationalTD[playerid][8] = CreatePlayerTextDraw(playerid, 496.000000, 203.000000, "ld_dual:white");
    PlayerTextDrawFont(playerid, NationalTD[playerid][8], TEXT_DRAW_FONT_SPRITE_DRAW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][8], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][8], 38.000000, 80.500000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][8], 3);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][8], 3);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][8], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][8], -1094795521);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][8], 1296911871);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][8], -1094795726);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][8], 1);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][8], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][8], 0);

    NationalTD[playerid][9] = CreatePlayerTextDraw(playerid, 526.000000, 200.000000, "Preview_Model");
    PlayerTextDrawFont(playerid, NationalTD[playerid][9], TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][9], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][9], 42.500000, 55.000000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][9], 0);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][9], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][9], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][9], 35839);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][9], 0);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][9], 255);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][9], 0);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][9], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][9], 0);
    PlayerTextDrawSetPreviewModel(playerid, NationalTD[playerid][9], 1614);
    PlayerTextDrawSetPreviewRot(playerid, NationalTD[playerid][9], -10.000000, 49.000000, -277.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, NationalTD[playerid][9], 1, 1);

    NationalTD[playerid][10] = CreatePlayerTextDraw(playerid, 497.000000, 206.500000, "ld_dual:white");
    PlayerTextDrawFont(playerid, NationalTD[playerid][10], TEXT_DRAW_FONT_SPRITE_DRAW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][10], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][10], 36.000000, 75.900001);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][10], 3);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][10], 3);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][10], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][10], -741092353);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][10], 1296911871);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][10], -1094795726);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][10], 1);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][10], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][10], 0);

    NationalTD[playerid][11] = CreatePlayerTextDraw(playerid, 486.000000, 203.000000, "ld_dual:white");
    PlayerTextDrawFont(playerid, NationalTD[playerid][11], TEXT_DRAW_FONT_SPRITE_DRAW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][11], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][11], 145.500000, 17.800003);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][11], 3);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][11], 3);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][11], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][11], 1677787135);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][11], 1296911871);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][11], -1094795726);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][11], 1);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][11], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][11], 0);

    NationalTD[playerid][12] = CreatePlayerTextDraw(playerid, 486.000000, 210.000000, "ld_dual:white");
    PlayerTextDrawFont(playerid, NationalTD[playerid][12], TEXT_DRAW_FONT_SPRITE_DRAW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][12], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][12], 58.500000, 17.800003);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][12], 3);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][12], 3);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][12], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][12], 1677787135);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][12], 1296911871);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][12], -1094795726);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][12], 1);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][12], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][12], 0);

    NationalTD[playerid][13] = CreatePlayerTextDraw(playerid, 581.000000, 259.000000, "Preview_Model");
    PlayerTextDrawFont(playerid, NationalTD[playerid][13], TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][13], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][13], 57.500000, 80.000000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][13], 0);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][13], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][13], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][13], 255);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][13], 0);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][13], 255);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][13], 0);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][13], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][13], 0);
    PlayerTextDrawSetPreviewModel(playerid, NationalTD[playerid][13], 1614);
    PlayerTextDrawSetPreviewRot(playerid, NationalTD[playerid][13], -10.000000, -115.000000, -277.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, NationalTD[playerid][13], 1, 1);

    NationalTD[playerid][14] = CreatePlayerTextDraw(playerid, 491.000000, 291.000000, "ld_dual:white");
    PlayerTextDrawFont(playerid, NationalTD[playerid][14], TEXT_DRAW_FONT_SPRITE_DRAW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][14], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][14], 136.500000, 10.000000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][14], 1);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][14], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][14], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][14], 1677787135);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][14], -1061109505);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][14], -1094795726);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][14], 1);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][14], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][14], 0);

    NationalTD[playerid][15] = CreatePlayerTextDraw(playerid, 486.000000, 291.000000, "ld_dual:white");
    PlayerTextDrawFont(playerid, NationalTD[playerid][15], TEXT_DRAW_FONT_SPRITE_DRAW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][15], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][15], 81.500000, 5.000000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][15], 1);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][15], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][15], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][15], 1677787135);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][15], -1061109505);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][15], -1094795726);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][15], 1);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][15], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][15], 0);

    NationalTD[playerid][16] = CreatePlayerTextDraw(playerid, 606.340026, 296.500000, "ld_dual:white");
    PlayerTextDrawFont(playerid, NationalTD[playerid][16], TEXT_DRAW_FONT_SPRITE_DRAW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][16], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][16], 25.000000, -28.000000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][16], 1);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][16], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][16], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][16], 1677787135);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][16], -1061109505);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][16], -1094795726);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][16], 1);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][16], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][16], 0);

    NationalTD[playerid][17] = CreatePlayerTextDraw(playerid, 467.000000, 206.000000, "Preview_Model");
    PlayerTextDrawFont(playerid, NationalTD[playerid][17], TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][17], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][17], 95.500000, 91.000000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][17], 0);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][17], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][17], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][17], -1);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][17], 0);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][17], 255);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][17], 0);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][17], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][17], 0);
    PlayerTextDrawSetPreviewModel(playerid, NationalTD[playerid][17], 0);
    PlayerTextDrawSetPreviewRot(playerid, NationalTD[playerid][17], -10.000000, 0.000000, -20.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, NationalTD[playerid][17], 1, 1);

    NationalTD[playerid][18] = CreatePlayerTextDraw(playerid, 629.000000, 204.500000, "Identification Card");
    PlayerTextDrawFont(playerid, NationalTD[playerid][18], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][18], 0.183329, 1.399999);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][18], 603.500000, 45.500000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][18], 0);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][18], 1);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][18], TEXT_DRAW_ALIGN_RIGHT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][18], -1);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][18], 90);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][18], 210);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][18], 0);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][18], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][18], 0);

    NationalTD[playerid][19] = CreatePlayerTextDraw(playerid, 489.000000, 205.000000, "ld_beat:square");
    PlayerTextDrawFont(playerid, NationalTD[playerid][19], TEXT_DRAW_FONT_SPRITE_DRAW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][19], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][19], 12.000000, 14.000000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][19], 1);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][19], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][19], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][19], 105);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][19], 0);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][19], 50);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][19], 1);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][19], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][19], 0);

    NationalTD[playerid][20] = CreatePlayerTextDraw(playerid, 538.000000, 206.500000, "City of Los Santos");
    PlayerTextDrawFont(playerid, NationalTD[playerid][20], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][20], 0.100000, 0.600000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][20], 603.500000, 45.500000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][20], 0);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][20], 1);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][20], TEXT_DRAW_ALIGN_RIGHT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][20], -1);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][20], 90);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][20], 210);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][20], 0);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][20], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][20], 0);

    NationalTD[playerid][21] = CreatePlayerTextDraw(playerid, 565.000000, 225.500000, "NAME:");
    PlayerTextDrawFont(playerid, NationalTD[playerid][21], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][21], 0.120833, 0.899999);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][21], 603.500000, 45.500000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][21], 0);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][21], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][21], TEXT_DRAW_ALIGN_RIGHT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][21], 255);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][21], 90);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][21], 210);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][21], 0);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][21], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][21], 0);

    NationalTD[playerid][22] = CreatePlayerTextDraw(playerid, 565.000000, 233.500000, "GENDER:");
    PlayerTextDrawFont(playerid, NationalTD[playerid][22], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][22], 0.120833, 0.899999);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][22], 603.500000, 45.500000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][22], 0);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][22], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][22], TEXT_DRAW_ALIGN_RIGHT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][22], 255);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][22], 90);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][22], 210);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][22], 0);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][22], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][22], 0);

    NationalTD[playerid][23] = CreatePlayerTextDraw(playerid, 565.000000, 241.500000, "AGE:");
    PlayerTextDrawFont(playerid, NationalTD[playerid][23], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][23], 0.120833, 0.899999);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][23], 603.500000, 45.500000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][23], 0);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][23], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][23], TEXT_DRAW_ALIGN_RIGHT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][23], 255);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][23], 90);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][23], 210);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][23], 0);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][23], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][23], 0);

    NationalTD[playerid][24] = CreatePlayerTextDraw(playerid, 565.000000, 249.500000, "ADDRESS:");
    PlayerTextDrawFont(playerid, NationalTD[playerid][24], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][24], 0.120833, 0.899999);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][24], 603.500000, 45.500000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][24], 0);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][24], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][24], TEXT_DRAW_ALIGN_RIGHT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][24], 255);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][24], 90);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][24], 210);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][24], 0);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][24], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][24], 0);

    NationalTD[playerid][25] = CreatePlayerTextDraw(playerid, 565.000000, 266.500000, "ID NUMBER:");
    PlayerTextDrawFont(playerid, NationalTD[playerid][25], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][25], 0.120833, 0.899999);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][25], 603.500000, 45.500000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][25], 0);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][25], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][25], TEXT_DRAW_ALIGN_RIGHT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][25], 255);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][25], 90);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][25], 210);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][25], 0);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][25], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][25], 0);

    NationalTD[playerid][26] = CreatePlayerTextDraw(playerid, 567.000000, 225.500000, "AINSLEY VARIOS");
    PlayerTextDrawFont(playerid, NationalTD[playerid][26], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][26], 0.120833, 0.899999);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][26], 626.500000, 45.500000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][26], 0);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][26], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][26], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][26], 35839);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][26], 90);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][26], 210);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][26], 0);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][26], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][26], 0);

    NationalTD[playerid][27] = CreatePlayerTextDraw(playerid, 567.000000, 233.500000, "FEMALE");
    PlayerTextDrawFont(playerid, NationalTD[playerid][27], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][27], 0.120833, 0.899999);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][27], 603.500000, 45.500000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][27], 0);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][27], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][27], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][27], 35839);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][27], 90);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][27], 210);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][27], 0);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][27], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][27], 0);

    NationalTD[playerid][28] = CreatePlayerTextDraw(playerid, 567.000000, 241.500000, "DECEMBER 15 2001");
    PlayerTextDrawFont(playerid, NationalTD[playerid][28], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][28], 0.120833, 0.899999);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][28], 626.500000, 45.500000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][28], 0);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][28], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][28], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][28], 35839);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][28], 90);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][28], 210);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][28], 0);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][28], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][28], 0);

    NationalTD[playerid][29] = CreatePlayerTextDraw(playerid, 567.000000, 249.500000, "MARKET, LOS SANTOS");
    PlayerTextDrawFont(playerid, NationalTD[playerid][29], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][29], 0.120833, 0.899999);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][29], 626.500000, 45.500000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][29], 0);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][29], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][29], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][29], 35839);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][29], 90);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][29], 210);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][29], 0);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][29], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][29], 0);

    NationalTD[playerid][30] = CreatePlayerTextDraw(playerid, 674.000000, 319.500000, "I");
    PlayerTextDrawFont(playerid, NationalTD[playerid][30], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][30], 18.704174, -14.600000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][30], 603.500000, 45.500000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][30], 0);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][30], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][30], TEXT_DRAW_ALIGN_RIGHT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][30], 40);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][30], 90);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][30], 210);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][30], 0);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][30], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][30], 0);

    NationalTD[playerid][31] = CreatePlayerTextDraw(playerid, 567.000000, 266.500000, "ICN0000001");
    PlayerTextDrawFont(playerid, NationalTD[playerid][31], TEXT_DRAW_FONT_2);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][31], 0.120833, 0.899999);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][31], 603.500000, 45.500000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][31], 0);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][31], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][31], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][31], 35839);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][31], 90);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][31], 210);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][31], 0);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][31], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][31], 0);

    NationalTD[playerid][32] = CreatePlayerTextDraw(playerid, 489.000000, 205.000000, "ld_beat:cring");
    PlayerTextDrawFont(playerid, NationalTD[playerid][32], TEXT_DRAW_FONT_SPRITE_DRAW);
    PlayerTextDrawLetterSize(playerid, NationalTD[playerid][32], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, NationalTD[playerid][32], 12.000000, 14.000000);
    PlayerTextDrawSetOutline(playerid, NationalTD[playerid][32], 1);
    PlayerTextDrawSetShadow(playerid, NationalTD[playerid][32], 0);
    PlayerTextDrawAlignment(playerid, NationalTD[playerid][32], TEXT_DRAW_ALIGN_LEFT);
    PlayerTextDrawColor(playerid, NationalTD[playerid][32], 105);
    PlayerTextDrawBackgroundColor(playerid, NationalTD[playerid][32], 0);
    PlayerTextDrawBoxColor(playerid, NationalTD[playerid][32], 50);
    PlayerTextDrawUseBox(playerid, NationalTD[playerid][32], 1);
    PlayerTextDrawSetProportional(playerid, NationalTD[playerid][32], 1);
    PlayerTextDrawSetSelectable(playerid, NationalTD[playerid][32], 0);
    return 1;
}