#include <YSI_Coding\y_hooks>

/*
    Database related settings (MySQL)
*/
#define AC_TABLE_SETTINGS "anticheat_settings" // Name of the table in the database with cheat settings
#define AC_TABLE_FIELD_CODE "ac_code" // Name of the field with the cheat code in the table
#define AC_TABLE_FIELD_TRIGGER "ac_code_trigger_type" // Name of the field with the value of the cheat code trigger in the table

/*
    General cheat settings
*/
#define AC_MAX_CODES 54 // The number of cheat codes (currently there are 53)
#define AC_MAX_CODE_LENGTH (3 + 1) // Maximum Characters in the cheat "code" (001/002/003, etc.)
#define AC_MAX_CODE_NAME_LENGTH (64) // Maximum Characters in the full name of the cheat, for which any code is responsible
    
#define AC_MAX_TRIGGER_TYPES 4 // The number of cheat trigger (punishment) types. As you add types of triggers (punishments), increase this value.
#define AC_MAX_TRIGGER_TYPE_NAME_LENGTH (8 + 1) // Maximum Characters in the name of the cheat trigger (punishment) type

#define AC_GLOBAL_TRIGGER_TYPE_PLAYER 0
#define AC_GLOBAL_TRIGGER_TYPE_IP 1

// Types of triggers are declared by macros to make it easier to navigate in OnCheatDetected.
#define AC_CODE_TRIGGER_TYPE_DISABLED 0 // AC_CODE_TRIGGER_TYPE_DISABLED - Punishment type: Disabled
#define AC_CODE_TRIGGER_TYPE_WARNING 1 // AC_CODE_TRIGGER_TYPE_WARNING - Punishment type: Warning
#define AC_CODE_TRIGGER_TYPE_KICK 2 // AC_CODE_TRIGGER_TYPE_KICK - Punishment type: Kick
#define AC_CODE_TRIGGER_TYPE_BAN 3 // AC_CODE_TRIGGER_TYPE_BAN - Punishment type: Ban

#define AC_TRIGGER_ANTIFLOOD_TIME 5 // Time for flood triggers (in seconds)

/*
    Settings of the visual part of the system (dialogs)
*/
#define AC_MAX_CODES_ON_PAGE 15 // Maximum number of items on the cheat settings page
#define AC_DIALOG_NEXT_PAGE_TEXT ">>> Next page" // Text of the button that will display the next page of the list
#define AC_DIALOG_PREVIOUS_PAGE_TEXT "<<< Previous page" // Text of the button that will display the previous page of the list

new AC_CODE[AC_MAX_CODES][AC_MAX_CODE_LENGTH] =  
{ 
    "000", 
    "001", 
    "002", 
    "003", 
    "004", 
    "005", 
    "006", 
    "007", 
    "008", 
    "009", 
    "010", 
    "011", 
    "012", 
    "013", 
    "014", 
    "015", 
    "016", 
    "017", 
    "018", 
    "019", 
    "020", 
    "021", 
    "022", 
    "023", 
    "024", 
    "025", 
    "026", 
    "027", 
    "028", 
    "029", 
    "030", 
    "031", 
    "032", 
    "033", 
    "034", 
    "035", 
    "036", 
    "037", 
    "038", 
    "039", 
    "040", 
    "041", 
    "042", 
    "043", 
    "044", 
    "045", 
    "046", 
    "047", 
    "048", 
    "049", 
    "050", 
    "051", 
    "052",
    "053"
};

new AC_CODE_NAME[AC_MAX_CODES][AC_MAX_CODE_NAME_LENGTH] =  
{ 
    {"AirBreak (onfoot)"},
    {"AirBreak (in vehicle)"},
    {"Teleport (onfoot)"},
    {"Teleport (in vehicle)"},
    {"Teleport (into/between vehicles)"},
    {"Teleport (vehicle to player)"},
    {"Teleport (pickups)"},
    {"FlyHack (onfoot)"},
    {"FlyHack (in vehicle)"},
    {"SpeedHack (onfoot)"},
    {"SpeedHack (in vehicle)"},
    {"Health hack (in vehicle)"},
    {"Health hack (onfoot)"},
    {"Armour hack"}, 
    {"Money hack"}, 
    {"Weapon hack"}, 
    {"Ammo hack (add)"},
    {"Ammo hack (infinite)"},
    {"Special actions hack"},
    {"GodMode from bullets (onfoot)"},
    {"GodMode from bullets (in vehicle)"},
    {"Invisible hack"}, 
    {"lagcomp-spoof"}, 
    {"Tuning hack"}, 
    {"Parkour mod"}, 
    {"Quick turn"}, 
    {"Rapid fire"}, 
    {"FakeSpawn"}, 
    {"FakeKill"}, 
    {"Pro Aim"}, 
    {"CJ run"}, 
    {"CarShot"}, 
    {"CarJack"}, 
    {"UnFreeze"}, 
    {"AFK Ghost"}, 
    {"Full Aiming"}, 
    {"Fake NPC"}, 
    {"Reconnect"}, 
    {"High ping"}, 
    {"Dialog hack"}, 
    {"Protection from sandbox"}, 
    {"Protection from invalid version"}, 
    {"Rcon hack"}, 
    {"Tuning crasher"}, 
    {"Invalid seat crasher"}, 
    {"Dialog crasher"}, 
    {"Attached object crasher"}, 
    {"Weapon Crasher"}, 
    {"Protection from connection flood in one slot"}, 
    {"callback functions flood"}, 
    {"flood by seat changing"}, 
    {"DoS"}, 
    {"NOPs"}, 
    {"Fast movement"}
};

new AC_TRIGGER_TYPE_NAME[AC_MAX_TRIGGER_TYPES][AC_MAX_TRIGGER_TYPE_NAME_LENGTH] =  
{ 
    {"None"}, 
    {"Warning"}, 
    {"Kick"},
    {"Ban"} 
}; 

new 
    AC_CODE_TRIGGER_TYPE[AC_MAX_CODES],
    AC_CODE_TRIGGERED_COUNT[AC_MAX_CODES] = {0, ...};

new 
    pAntiCheatLastCodeTriggerTime[MAX_PLAYERS][AC_MAX_CODES],
    pAntiCheatSettingsPage[MAX_PLAYERS char],
    pAntiCheatSettingsMenuListData[MAX_PLAYERS][AC_MAX_CODES_ON_PAGE],
    pAntiCheatSettingsEditCodeId[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    for(new i = 0; i < AC_MAX_CODES; i++) {
        pAntiCheatLastCodeTriggerTime[playerid][i] = -1;
    } 
    pAntiCheatSettingsPage{playerid} = 0;
    pAntiCheatSettingsEditCodeId[playerid] = -1;
    return 1;
}

stock UploadAntiCheatSettings()
{
    mysql_function_query(connectionID, "SELECT * FROM `anticheat_settings`", true, "UploadAntiCheat", "");
}

forward UploadAntiCheat();
public UploadAntiCheat()
{
    new rows = cache_num_rows();

	if (!rows) {  
        print("MySQL Report: Anti Cheat failed to load there's nohing in the database. ");
    }  

    for(new i = 0; i < AC_MAX_CODES; i++)
    {
        AC_CODE_TRIGGER_TYPE[i] = AC_CODE_TRIGGER_TYPE_DISABLED;
    }
    for(new row = 0; row < rows; row++)
    {
        new code = cache_get_field_content_int(row, "ac_code");
        if(code < 0 || code >= AC_MAX_CODES) continue;
        AC_CODE_TRIGGER_TYPE[code] = cache_get_field_content_int(row, "ac_code_trigger_type");
        if(AC_CODE_TRIGGER_TYPE[code] == AC_CODE_TRIGGER_TYPE_DISABLED)
        {
            EnableAntiCheat(code, 0);
        }
    }


    return 1;  
}

forward OnCheatDetected(playerid, const ip_address[], type, code, code2);
public OnCheatDetected(playerid, const ip_address[], type, code, code2)
{
    if (type == AC_GLOBAL_TRIGGER_TYPE_PLAYER) // rex
    {
        switch(code)
        {
            case 5, 6, 11, 22: 
            {
                return 1;
            }
            case 15:{
                ResetPlayerWeapons(playerid);
                SetPlayerWeapons(playerid);
                //return AntiCheatKickWithDesync(playerid, code);
            }
            case 32: // CarJack
            {
                new 
                    Float:x, 
                    Float:y, 
                    Float:z;

                AntiCheatGetPos(playerid, x, y, z);
                return SetPlayerPos(playerid, x, y, z);
            }
            default:
            {
                if (gettime() - pAntiCheatLastCodeTriggerTime[playerid][code] < AC_TRIGGER_ANTIFLOOD_TIME)
                    return 1;

                pAntiCheatLastCodeTriggerTime[playerid][code] = gettime();
                AC_CODE_TRIGGERED_COUNT[code]++;

                new trigger_type = AC_CODE_TRIGGER_TYPE[code];

                switch(trigger_type)
                {
                    case AC_CODE_TRIGGER_TYPE_DISABLED: return 1;
                    case AC_CODE_TRIGGER_TYPE_WARNING:
                    {
                        if(PlayerInfo[playerid][pAdmin] && code != 47) return 1;
                        //if(PlayerInfo[playerid][pAdmin]) return 1;
                        SendAdminMessage(COLOR_LIGHTRED, "{AA3333}AdmWarning: {FFFF00}%s[%d] was warning of using: %s", GetRPName(playerid), playerid, AC_CODE_NAME[code]);
                        SendMessage(playerid, COLOR_LIGHTRED, "AdmCmd: You have been warned for using %s", AC_CODE_NAME[code]);
                    }  
                    case AC_CODE_TRIGGER_TYPE_KICK: 
                    {
                        if(PlayerInfo[playerid][pAdmin] && code != 47) return 1;
                        AntiCheatKickWithDesync(playerid, code);
                        SendAdminMessage(COLOR_LIGHTRED,"{AA3333}AdmWarning: {FFFF00}%s[%d] was kicked of using: %s", GetRPName(playerid), playerid, AC_CODE_NAME[code]);
                        SendMessageToAll(COLOR_LIGHTRED, "AdmCmd: %s was auto-kicked by %s, reason: %s", GetRPName(playerid), SERVER_ANTICHEAT, AC_CODE_NAME[code]);

                        SendDiscordLog(AC_LOGS, "AdmCmd: %s was kicked of using: %s", GetRPName(playerid), playerid, AC_CODE_NAME[code]);
                    }
                } 
            }
        }
    }
    else // AC_GLOBAL_TRIGGER_TYPE_IP
    {
        AC_CODE_TRIGGERED_COUNT[code]++;
        SendAdminMessage(COLOR_LIGHTRED, "{AA3333}AdmWarning: {FFFF00}IP address %s was blocked: %s [code: %03d].", ip_address, AC_CODE_NAME[code], code);
        BlockIpAddress(ip_address, 0);
    }
    return 1;
} 

ShowPlayer_AntiCheatSettings(playerid)
{
    static
        dialog_string[42 + 19 - 8 + (AC_MAX_CODE_LENGTH + AC_MAX_CODE_NAME_LENGTH + AC_MAX_TRIGGER_TYPE_NAME_LENGTH + 10)*AC_MAX_CODES_ON_PAGE] = EOS;

    new
        page = pAntiCheatSettingsPage{playerid},
        next = 0,
        index = 0;

    dialog_string = "Name\tPunishment\n";

    for(new i = 0; i < AC_MAX_CODES; i++)
    {
        if (i >= (page * AC_MAX_CODES_ON_PAGE) && i < (page * AC_MAX_CODES_ON_PAGE) + AC_MAX_CODES_ON_PAGE)
            next++;

        if (i >= (page - 1) * AC_MAX_CODES_ON_PAGE && i < ((page - 1) * AC_MAX_CODES_ON_PAGE) + AC_MAX_CODES_ON_PAGE)
        {

            format(dialog_string, sizeof(dialog_string), "%s%s\t%s\n",
                dialog_string,
                AC_CODE_NAME[i],
                AC_TRIGGER_TYPE_NAME[AC_CODE_TRIGGER_TYPE[i]]);

            pAntiCheatSettingsMenuListData[playerid][index++] = i;
        }
    }

    if (next) 
        strcat(dialog_string, ""AC_DIALOG_NEXT_PAGE_TEXT"\n");

    if (page > 1) 
        strcat(dialog_string, AC_DIALOG_PREVIOUS_PAGE_TEXT);

    return ShowPlayerDialog(playerid, ANTICHEAT_SETTINGS, DIALOG_STYLE_TABLIST_HEADERS, "cheat settings", dialog_string, "Select", "Cancel");
}

ShowPlayer_AntiCheatEditCode(playerid, code)
{
    new
        dialog_header[128],
        dialog_string[128];

    format(dialog_header, sizeof(dialog_header), "Code: %s | Name: %s", AC_CODE[code], AC_CODE_NAME[code]); //��������

    for(new i = 0; i < AC_MAX_TRIGGER_TYPES; i++)
    {
        strcat(dialog_string, AC_TRIGGER_TYPE_NAME[i]);

        if (i + 1 != AC_MAX_TRIGGER_TYPES)
            strcat(dialog_string, "\n");
    }
    return ShowPlayerDialog(playerid, ANTICHEAT_EDIT_CODE, DIALOG_STYLE_LIST, dialog_header, dialog_string, "Select", "Cancel");
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == ANTICHEAT_SETTINGS)
    {
        if (!response)
        { 
            pAntiCheatSettingsPage{playerid} = 0; 
            return 1; 
        } 

        if (!strcmp(inputtext, AC_DIALOG_NEXT_PAGE_TEXT)) 
        { 
            pAntiCheatSettingsPage{playerid}++; 
        } 
        else if (!strcmp(inputtext, AC_DIALOG_PREVIOUS_PAGE_TEXT)) 
        { 
            pAntiCheatSettingsPage{playerid}--; 
        } 
        else
        { 
            pAntiCheatSettingsEditCodeId[playerid] = pAntiCheatSettingsMenuListData[playerid][listitem]; 
            return ShowPlayer_AntiCheatEditCode(playerid, pAntiCheatSettingsEditCodeId[playerid]); 
        } 
        return ShowPlayer_AntiCheatSettings(playerid);
    }
    if(dialogid == ANTICHEAT_EDIT_CODE)
    {
        if (!response)
        { 
            pAntiCheatSettingsEditCodeId[playerid] = -1;
            return ShowPlayer_AntiCheatSettings(playerid); 
        } 

        new
            item = pAntiCheatSettingsEditCodeId[playerid];

        if (AC_CODE_TRIGGER_TYPE[item] == listitem)
            return ShowPlayer_AntiCheatSettings(playerid);

        if (AC_CODE_TRIGGER_TYPE[item] == AC_CODE_TRIGGER_TYPE_DISABLED && listitem != AC_CODE_TRIGGER_TYPE_DISABLED)
            EnableAntiCheat(item, 1);

        AC_CODE_TRIGGER_TYPE[item] = listitem;


        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE "AC_TABLE_SETTINGS" SET `"AC_TABLE_FIELD_TRIGGER"` = '%d' WHERE `"AC_TABLE_FIELD_CODE"` = '%d'", listitem, item); 
        mysql_tquery(connectionID, queryBuffer);
        return ShowPlayer_AntiCheatSettings(playerid);
    }
    return 1;
}

CMD:configanticheat(playerid, const params[])
{
    pAntiCheatSettingsPage{playerid} = 1;
    return ShowPlayer_AntiCheatSettings(playerid);
}