#define AC_TABLE_SETTINGS "anticheat_settings"
#define AC_TABLE_FIELD_CODE "ac_code"
#define AC_TABLE_FIELD_TRIGGER "ac_code_trigger_type"
#define AC_MAX_CODES 53
#define AC_MAX_CODE_LENGTH (3 + 1)
#define AC_MAX_CODE_NAME_LENGTH (33 + 1)
#define AC_MAX_TRIGGER_TYPES 3
#define AC_MAX_TRIGGER_TYPE_NAME_LENGTH (8 + 1)
#define AC_GLOBAL_TRIGGER_TYPE_PLAYER 0
#define AC_GLOBAL_TRIGGER_TYPE_IP 1
#define AC_CODE_TRIGGER_TYPE_DISABLED 0 
#define AC_CODE_TRIGGER_TYPE_WARNING 1 
#define AC_CODE_TRIGGER_TYPE_KICK 2 
#define AC_TRIGGER_ANTIFLOOD_TIME 20 
#define AC_MAX_CODES_ON_PAGE 15 
#define AC_DIALOG_NEXT_PAGE_TEXT ">>>" 
#define AC_DIALOG_PREVIOUS_PAGE_TEXT "<<<" 

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
    "052"
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
    {"Lagcomp-spoof"},
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
    {"Sandbox"},
    {"Invalid version"},
    {"Rcon hack"},
    {"Tuning crasher"},
    {"Invalid seat crasher"},
    {"Dialog crasher"},
    {"Attached object crasher"},
    {"Weapon Crasher"},
    {"Connects to one slot"},
    {"Flood callback functions"},
    {"Flood change seat"},
    {"DDos"},
    {"NOP's"}
};

new AC_TRIGGER_TYPE_NAME[AC_MAX_TRIGGER_TYPES][AC_MAX_TRIGGER_TYPE_NAME_LENGTH] =
{
    {"Disabled"},
    {"Warning"},
    {"Kick"}
};

new
    AC_CODE_TRIGGER_TYPE[AC_MAX_CODES],
    AC_CODE_TRIGGERED_COUNT[AC_MAX_CODES] = {0, ...};

new
    pAntiCheatLastCodeTriggerTime[MAX_PLAYERS][AC_MAX_CODES],
    pAntiCheatSettingsPage[MAX_PLAYERS char],
    pAntiCheatSettingsMenuListData[MAX_PLAYERS][AC_MAX_CODES_ON_PAGE],
    pAntiCheatSettingsEditCodeId[MAX_PLAYERS];

stock UploadAntiCheatSettings()
{
    mysql_function_query(connectionID, "SELECT * FROM `anticheat_settings`", true, "UploadAntiCheat", "");
}

forward UploadAntiCheat();
public UploadAntiCheat()
{
    new rows = cache_num_rows();

	if (!rows)
	{
        print("[MySQL] Anti-cheat settings were not found in the database. Loading of the mod stopped - configure anti-cheat. ");
        return GameModeExit();
    }

    for(new i = 0; i < AC_MAX_CODES; i++)
    {
        AC_CODE_TRIGGER_TYPE[i] = cache_get_field_content_int(i, "ac_code_trigger_type");

        if (AC_CODE_TRIGGER_TYPE[i] == AC_CODE_TRIGGER_TYPE_DISABLED) {
            EnableAntiCheat(i, 0);
        }
    }

    new mes[128];
    format(mes, sizeof(mes), "[MySQL] %i Anticheat loaded", rows);
    print(mes);

    return 1;
}

forward OnCheatDetected(playerid, ip_address[], type, code);
public OnCheatDetected(playerid, ip_address[], type, code)
{
    if (type == AC_GLOBAL_TRIGGER_TYPE_PLAYER)
    {
        switch(code)
        {
            case 5, 6, 11, 22:
            {
                return 1;
            }
            case 32:
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

                if((gAnticheat) && PlayerInfo[playerid][pAdmin] < 7 && !PlayerInfo[playerid][pAdminDuty] && !PlayerInfo[playerid][pKicked])
	            {
                    switch(trigger_type)
                    {
                        case AC_CODE_TRIGGER_TYPE_DISABLED: return 1;
                        case AC_CODE_TRIGGER_TYPE_WARNING:
                        {
                            SendAdminMessage(COLOR_RED, "AdmWarning: "YELLOW"%s[%d] suspected of using cheat programs: %s", GetRPName(playerid), playerid, AC_CODE_NAME[code]);
                        }
                        case AC_CODE_TRIGGER_TYPE_KICK:
                        {
                            AntiCheatKickWithDesync(playerid, code);
                            SendAdminMessage(COLOR_RED,"AdmWarning: "YELLOW"%s[%d] was kicked on suspicion of using cheat programs: %s", GetRPName(playerid), playerid, AC_CODE_NAME[code]);
                            SendMessageToAll(COLOR_LIGHTRED, "AdmCmd: %s was auto-kicked by %s, reason: %s", GetRPName(playerid), SERVER_ANTICHEAT, AC_CODE_NAME[code]);
                        }
                    }
                }
            }
        }
    }
    else
    {
        AC_CODE_TRIGGERED_COUNT[code]++;
        new str[128];
        format(str, sizeof(str),"<AC-BAN-IP> IP address %s was blocked: %s [code: %03d].", ip_address, AC_CODE_NAME[code], code);
        SendAdminMessage(COLOR_RED, str);
        BlockIpAddress(ip_address, 0);
    }
    return 1;
}

stock ShowPlayer_AntiCheatSettings(playerid)
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

    return ShowPlayerDialog(playerid, ANTICHEAT_SETTINGS, DIALOG_STYLE_TABLIST_HEADERS, ""SERVER_NAME"'s Anti Cheat System", dialog_string, "Select", "Cancel");
}

stock ShowPlayer_AntiCheatEditCode(playerid, code)
{
    new
        dialog_header[22 - 4 + AC_MAX_CODE_LENGTH + AC_MAX_CODE_NAME_LENGTH],
        dialog_string[AC_MAX_TRIGGER_TYPE_NAME_LENGTH*AC_MAX_TRIGGER_TYPES];

    format(dialog_header, sizeof(dialog_header), "Code: %s | Name: %s", AC_CODE[code], AC_CODE_NAME[code]);

    for(new i = 0; i < AC_MAX_TRIGGER_TYPES; i++)
    {
        strcat(dialog_string, AC_TRIGGER_TYPE_NAME[i]);

        if (i + 1 != AC_MAX_TRIGGER_TYPES)
            strcat(dialog_string, "\n");
    }

    return ShowPlayerDialog(playerid, ANTICHEAT_EDIT_CODE, DIALOG_STYLE_LIST, dialog_header, dialog_string, "Select", "Return");
}

public OnPlayerConnect(playerid)
{
    for(new i = 0; i < AC_MAX_CODES; i++)
    {
        pAntiCheatLastCodeTriggerTime[playerid][i] = -1;
    }
    pAntiCheatSettingsPage{playerid} = 0;
    pAntiCheatSettingsEditCodeId[playerid] = -1;
    #if defined NexAC_OnPlayerConnect
		return NexAC_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect NexAC_OnPlayerConnect
#if defined NexAC_OnPlayerConnect
	forward NexAC_OnPlayerConnect(playerid);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == ANTICHEAT_SETTINGS)
	{
		if(!response)
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

	    new
	        sql_query[101 - 4 + 1 + 2];

	    format(sql_query, sizeof(sql_query), "UPDATE "AC_TABLE_SETTINGS" SET `"AC_TABLE_FIELD_TRIGGER"` = '%d' WHERE `"AC_TABLE_FIELD_CODE"` = '%d'",
	        listitem,
	        item);

	    mysql_function_query(connectionID, sql_query, false, "", "");
	    return ShowPlayer_AntiCheatSettings(playerid);
	}
    #if defined NexAC_OnDialogResponse
		return NexAC_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnDialogResponse
	#undef OnDialogResponse
#else
	#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse NexAC_OnDialogResponse
#if defined NexAC_OnDialogResponse
	forward NexAC_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

CMD:acsettings(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 7)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "SERVER: You are not authorized to use this command.");
	}
    pAntiCheatSettingsPage{playerid} = 1;
    return ShowPlayer_AntiCheatSettings(playerid);
}