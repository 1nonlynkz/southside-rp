#include <YSI_Coding\y_hooks>

#define COLOR_HEX_BRAND        "{00E5FF}" // Electric Cyan
#define COLOR_HEX_PRIMARY      "{FFFFFF}" // Bright White
#define COLOR_HEX_SECONDARY    "{A0AAB8}" // Slate Grey
#define COLOR_HEX_SUCCESS      "{00E676}" // Mint / Emerald Green
#define COLOR_HEX_WARNING      "{FFD600}" // Amber Gold
#define COLOR_HEX_DANGER       "{FF1744}" // Crimson Red
#define COLOR_HEX_ACCENT       "{7C4DFF}" // Deep Purple/Violet

static const g_aCharset[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

// ==========================================
// COMMANDS
// ==========================================

CMD:redeem(playerid, const params[])
{
	ShowPlayerDialog(playerid, DIALOG_REDEEM, DIALOG_STYLE_INPUT, "{0080FF}Redeem System {FFFFFF}| Code Redemption", "{FFFFFF}Enter your valid redeem code below to claim your rewards:\n\n{FFA500}Note: Codes are case-insensitive and single-use unless specified.", "Redeem", "Cancel");
	return 1;
}

CMD:redeemmenu(playerid, const params[])
{
	if(PlayerInfo[playerid][pAdmin] < 7)
		return SendErrorMessage(playerid, "You are not authorized to use this management menu.");

	ShowRedeemEdit(playerid, 0);
	return 1;
}

CMD:givecoin(playerid, const params[])
{
	new targetid, amount;

	if(PlayerInfo[playerid][pAdmin] < 7)
		return SendErrorMessage(playerid, "You are not authorized to use this command.");

	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 6)
		return SendErrorMessage(playerid, "You must be on admin duty (/aduty) to use this command.");

	if(sscanf(params, "ui", targetid, amount))
		return SendSyntaxMessage(playerid, "/givecoin [playerid/Name] [amount]");

	if(!IsPlayerConnected(targetid))
		return SendErrorMessage(playerid, "The specified player is not connected.");

	if(!PlayerInfo[targetid][pLogged])
		return SendErrorMessage(playerid, "That player has not logged in yet.");

	GivePlayerCoins(targetid, amount);
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %s coin(s) to %s.", GetRPName(playerid), number_format(amount), GetRPName(targetid));
	SendAdminAction(targetid, "You have received %s coin(s) from Admin %s.", number_format(amount), GetRPName(playerid));
	return 1;
}

forward SQL_InsertRedeemCode(playerid, codeid, code[]);
public SQL_InsertRedeemCode(playerid, codeid, code[])
{
	RedeemInfo[codeid][redeemID] = cache_insert_id(connectionID);

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s created redeem code ID %d ('%s').", GetRPName(playerid), codeid, code);
	SendClientMessage(playerid, COLOR_YELLOW, "[REDEEM]: Code created successfully! Configure its rewards via the menu.");

	SetPVarInt(playerid, "redeem_edit", codeid);
	ShowRedeemEdit(playerid, 2);
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_REDEEM:
		{
			if(!response) return 1;

			if(!(1 <= strlen(inputtext) <= 15))
			{
				SendClientMessage(playerid, COLOR_RED, "[REDEEM]: Code length must be between 1 and 15 characters.");
				return ShowPlayerDialog(playerid, DIALOG_REDEEM, DIALOG_STYLE_INPUT, "{0080FF}Redeem System {FFFFFF}| Code Redemption", "{FFFFFF}Enter your valid redeem code below to claim your rewards:", "Redeem", "Cancel");
			}

			new bool:found = false;
			static string[320];

			for(new idx = 0; idx < MAX_REDEEM_CODES; idx++)
			{
				if(!RedeemInfo[idx][redeemID]) continue;

				if(!strcmp(RedeemInfo[idx][redeemCode], inputtext, true)) // Case-insensitive matching
				{
					found = true;

					// Expiration Check
					if(!RedeemInfo[idx][redeemExpiry])
					{
						format(string, sizeof(string), "{FF0000}Error:{FFFFFF} Code '{0080FF}%s{FFFFFF}' is currently unconfigured or disabled by Management.", inputtext);
						ShowPlayerDialog(playerid, DIALOG_REDEEM, DIALOG_STYLE_INPUT, "{0080FF}Redeem System {FFFFFF}| Status", string, "Retry", "Close");
						return 1;
					}

					if(gettime() > RedeemInfo[idx][redeemExpiry])
					{
						format(string, sizeof(string), "{FF0000}Error:{FFFFFF} The code '{0080FF}%s{FFFFFF}' has already expired.", inputtext);
						ShowPlayerDialog(playerid, DIALOG_REDEEM, DIALOG_STYLE_INPUT, "{0080FF}Redeem System {FFFFFF}| Status", string, "Retry", "Close");
						return 1;
					}

					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT redeem_timestamp FROM redeem_players WHERE ID = %d AND CODE_ID = %d LIMIT 1;", PlayerInfo[playerid][pID], RedeemInfo[idx][redeemID]);
					new Cache:result = mysql_query(connectionID, queryBuffer);

					if(cache_num_rows(connectionID))
					{
						static year, month, day, hour, minute, second;
						TimestampToDate(cache_get_field_content_int(0, "redeem_timestamp"), year, month, day, hour, minute, second, 8);
						format(string, sizeof(string), "{FF0000}Notice:{FFFFFF} You already redeemed '{0080FF}%s{FFFFFF}' on %02d/%02d/%d at %02d:%02d.", inputtext, day, month, year, hour, minute);
						ShowPlayerDialog(playerid, DIALOG_REDEEM, DIALOG_STYLE_INPUT, "{0080FF}Redeem System {FFFFFF}| Already Claimed", string, "Retry", "Close");
					}
					else
					{
						RedeemPrizeFromCodeForPlayer(playerid, idx);
					}

					cache_delete(result);
					break;
				}
			}

			if(!found)
			{
				format(string, sizeof(string), "{FF0000}Error:{FFFFFF} '{0080FF}%s{FFFFFF}' is not a valid or active redeem code.", inputtext);
				ShowPlayerDialog(playerid, DIALOG_REDEEM, DIALOG_STYLE_INPUT, "{0080FF}Redeem System {FFFFFF}| Invalid Code", string, "Retry", "Close");
			}
			return 1;
		}

		case DIALOG_REDEEM_MENU:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0: ShowPlayerDialog(playerid, DIALOG_REDEEM_CREATE, DIALOG_STYLE_LIST, "{0080FF}Redeem Manager {FFFFFF}| Creation Type", "1. Random Generated Code (e.g. A9x2Vz)\n2. Custom Code Keyword (e.g. WELCOME2026)", "Select", "Back");
				case 1: ShowRedeemEdit(playerid, 1);
			}
			return 1;
		}

		case DIALOG_REDEEM_CREATE:
		{
			if(!response) return ShowRedeemEdit(playerid, 0);

			switch(listitem)
			{
				case 0: // Random
				{
					new codeid = GetRedeemCodeNextID();
					if(codeid == -1)
					{
						SendClientMessage(playerid, COLOR_RED, "[REDEEM]: Code storage is full. Delete existing codes first.");
						return ShowRedeemEdit(playerid, 0);
					}

					strcpy(RedeemInfo[codeid][redeemCode], GenerateRandomCode(8));
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO redeem_codes (code) VALUES('%e')", RedeemInfo[codeid][redeemCode]);
					mysql_tquery(connectionID, queryBuffer, "SQL_InsertRedeemCode", "dds", playerid, codeid, RedeemInfo[codeid][redeemCode]);
				}
				case 1: // Custom
				{
					ShowPlayerDialog(playerid, DIALOG_REDEEM_CREATE2, DIALOG_STYLE_INPUT, "{0080FF}Redeem Manager {FFFFFF}| Custom Keyword", "{FFFFFF}Enter custom redeem code string:\n\n{FFA500}Requirements: 3-15 alphanumeric characters.", "Create", "Back");
				}
			}
			return 1;
		}

		case DIALOG_REDEEM_CREATE2:
		{
			if(!response) return ShowPlayerDialog(playerid, DIALOG_REDEEM_CREATE, DIALOG_STYLE_LIST, "{0080FF}Redeem Manager {FFFFFF}| Creation Type", "1. Random Generated Code\n2. Custom Code Keyword", "Select", "Back");

			if(!(3 <= strlen(inputtext) <= 15))
			{
				SendClientMessage(playerid, COLOR_RED, "[REDEEM]: Custom code must be between 3 and 15 characters.");
				return ShowPlayerDialog(playerid, DIALOG_REDEEM_CREATE2, DIALOG_STYLE_INPUT, "{0080FF}Redeem Manager {FFFFFF}| Custom Keyword", "{FFFFFF}Enter custom redeem code string:\n\n{FFA500}Requirements: 3-15 alphanumeric characters.", "Create", "Back");
			}

			new codeid = GetRedeemCodeNextID();
			if(codeid == -1)
			{
				SendClientMessage(playerid, COLOR_RED, "[REDEEM]: Code storage is full. Delete existing codes first.");
				return ShowRedeemEdit(playerid, 0);
			}

			strcpy(RedeemInfo[codeid][redeemCode], inputtext);
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO redeem_codes (code) VALUES('%e')", inputtext);
			mysql_tquery(connectionID, queryBuffer, "SQL_InsertRedeemCode", "dds", playerid, codeid, inputtext);
			return 1;
		}

		case DIALOG_REDEEM_LIST:
		{
			if(!response) return ShowRedeemEdit(playerid, 0);

			if(gListedItems[playerid][0] == -1)
			{
				SendClientMessage(playerid, COLOR_RED, "[REDEEM]: No valid redeem codes available.");
				return ShowRedeemEdit(playerid, 0);
			}

			SetPVarInt(playerid, "redeem_edit", gListedItems[playerid][listitem]);
			ShowRedeemInfo(playerid, gListedItems[playerid][listitem]);
			return 1;
		}

		case DIALOG_REDEEM_INFO:
		{
			if(!response)
			{
				DeletePVar(playerid, "redeem_edit");
				ShowRedeemEdit(playerid, 1);
			}
			else
			{
				ShowRedeemEdit(playerid, 2);
			}
			return 1;
		}

		case DIALOG_REDEEM_EDIT:
		{
			if(!response)
			{
				DeletePVar(playerid, "redeem_edit");
				return ShowRedeemEdit(playerid, 1);
			}

			new codeid = GetPVarInt(playerid, "redeem_edit");

			switch(listitem)
			{
				case 0: // Expiration
				{
					static string[512];
					string[0] = EOS;
					for(new i = 1; i <= 30; i++) format(string, sizeof(string), "%s%d Day(s)\n", string, i);
					ShowPlayerDialog(playerid, DIALOG_REDEEM_DAYS, DIALOG_STYLE_LIST, "{0080FF}Configure {FFFFFF}| Set Expiration", string, "Set", "Back");
				}
				case 1: // Limited Use Toggle
				{
					RedeemInfo[codeid][redeemLimited] = !RedeemInfo[codeid][redeemLimited];
					SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s changed Code ID %d limit mode to %s.", GetRPName(playerid), codeid, RedeemInfo[codeid][redeemLimited] ? ("LIMITED") : ("UNLIMITED"));

					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE redeem_codes SET code_limited = %d WHERE code_id = %d", RedeemInfo[codeid][redeemLimited], RedeemInfo[codeid][redeemID]);
					mysql_tquery(connectionID, queryBuffer);

					ShowRedeemEdit(playerid, 2);
				}
				case 2: // Max Uses
				{
					if(!RedeemInfo[codeid][redeemLimited])
					{
						SendClientMessage(playerid, COLOR_LIGHTRED, "[REDEEM]: Enable 'Usage Limit' first before setting usage count.");
						return ShowRedeemEdit(playerid, 2);
					}
					ShowPlayerDialog(playerid, DIALOG_REDEEM_USE, DIALOG_STYLE_INPUT, "{0080FF}Configure {FFFFFF}| Max Claims", "Specify maximum global redemptions allowed (1 - 500):", "Set", "Back");
				}
				case 3: ShowPlayerDialog(playerid, DIALOG_REDEEM_GOLDBAR, DIALOG_STYLE_INPUT, "{0080FF}Configure {FFFFFF}| Coins Reward", "Enter amount of Coins reward (0 to disable):", "Set", "Back");
				case 4: ShowPlayerDialog(playerid, DIALOG_REDEEM_CAR_VOUCHER, DIALOG_STYLE_INPUT, "{0080FF}Configure {FFFFFF}| Car Vouchers", "Enter amount of Car Vouchers (0 to disable):", "Set", "Back");
				case 5: ShowPlayerDialog(playerid, DIALOG_REDEEM_CASH, DIALOG_STYLE_INPUT, "{0080FF}Configure {FFFFFF}| Cash Reward", "Enter cash reward amount ($0 to disable):", "Set", "Back");
				case 6: // Gate
				{
					RedeemInfo[codeid][redeemGate] = !RedeemInfo[codeid][redeemGate];
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE redeem_codes SET code_gate = %d WHERE code_id = %d", RedeemInfo[codeid][redeemGate], RedeemInfo[codeid][redeemID]);
					mysql_tquery(connectionID, queryBuffer);
					ShowRedeemEdit(playerid, 2);
				}
				case 7: // Max Job Level
				{
					RedeemInfo[codeid][redeemJob] = !RedeemInfo[codeid][redeemJob];
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE redeem_codes SET code_job = %d WHERE code_id = %d", RedeemInfo[codeid][redeemJob], RedeemInfo[codeid][redeemID]);
					mysql_tquery(connectionID, queryBuffer);
					ShowRedeemEdit(playerid, 2);
				}
				case 8: // Dynamic Door
				{
					RedeemInfo[codeid][redeemDoor] = !RedeemInfo[codeid][redeemDoor];
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE redeem_codes SET code_door = %d WHERE code_id = %d", RedeemInfo[codeid][redeemDoor], RedeemInfo[codeid][redeemID]);
					mysql_tquery(connectionID, queryBuffer);
					ShowRedeemEdit(playerid, 2);
				}
				case 9: // Exotic Vehicle
				{
					RedeemInfo[codeid][redeemExotic] = !RedeemInfo[codeid][redeemExotic];
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE redeem_codes SET code_exotic = %d WHERE code_id = %d", RedeemInfo[codeid][redeemExotic], RedeemInfo[codeid][redeemID]);
					mysql_tquery(connectionID, queryBuffer);
					ShowRedeemEdit(playerid, 2);
				}
				case 10: // House
				{
					RedeemInfo[codeid][redeemHouse] = !RedeemInfo[codeid][redeemHouse];
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE redeem_codes SET code_house = %d WHERE code_id = %d", RedeemInfo[codeid][redeemHouse], RedeemInfo[codeid][redeemID]);
					mysql_tquery(connectionID, queryBuffer);
					ShowRedeemEdit(playerid, 2);
				}
				case 11: // Business
				{
					RedeemInfo[codeid][redeemBiz] = !RedeemInfo[codeid][redeemBiz];
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE redeem_codes SET code_biz = %d WHERE code_id = %d", RedeemInfo[codeid][redeemBiz], RedeemInfo[codeid][redeemID]);
					mysql_tquery(connectionID, queryBuffer);
					ShowRedeemEdit(playerid, 2);
				}
				case 12: ShowPlayerDialog(playerid, DIALOG_REDEEM_VIP, DIALOG_STYLE_LIST, "{0080FF}Configure {FFFFFF}| VIP Status", "None\nSilver VIP Package\nGold VIP Package\nPlatinum VIP Package", "Select", "Back");
				case 13: // VIP Days
				{
					if(!RedeemInfo[codeid][redeemVIP])
					{
						SendClientMessage(playerid, COLOR_RED, "[REDEEM]: Set a VIP Package status first!");
						return ShowRedeemEdit(playerid, 2);
					}
					static string[512];
					string[0] = EOS;
					for(new idx = 1; idx <= 30; idx++) format(string, sizeof(string), "%s%d Day(s)\n", string, idx);
					ShowPlayerDialog(playerid, DIALOG_REDEEM_VIPDAYS, DIALOG_STYLE_LIST, "{0080FF}Configure {FFFFFF}| VIP Duration", string, "Select", "Back");
				}
				case 14: ShowPlayerDialog(playerid, DIALOG_REDEEM_GIFTCARD, DIALOG_STYLE_INPUT, "{0080FF}Configure {FFFFFF}| Store Giftcard", "Enter donation giftcard PHP value (0 to disable):", "Set", "Back");
				case 15: // Delete
				{
					SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has permanently deleted redeem code ID %d ('%s').", GetRPName(playerid), codeid, RedeemInfo[codeid][redeemCode]);

					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM redeem_codes WHERE code_id = %d", RedeemInfo[codeid][redeemID]);
					mysql_tquery(connectionID, queryBuffer);

					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM redeem_players WHERE CODE_ID = %d", RedeemInfo[codeid][redeemID]);
					mysql_tquery(connectionID, queryBuffer);

					// Reset Struct
					RedeemInfo[codeid][redeemID] = 0;
					RedeemInfo[codeid][redeemCode][0] = EOS;
					RedeemInfo[codeid][redeemLimited] = 0;
					RedeemInfo[codeid][redeemTimesUsed] = 0;
					RedeemInfo[codeid][redeemExpiry] = 0;
					RedeemInfo[codeid][redeemGoldBar] = 0;
					RedeemInfo[codeid][redeemCarVoucher] = 0;
					RedeemInfo[codeid][redeemCash] = 0;
					RedeemInfo[codeid][redeemGate] = 0;
					RedeemInfo[codeid][redeemJob] = 0;
					RedeemInfo[codeid][redeemDoor] = 0;
					RedeemInfo[codeid][redeemExotic] = 0;
					RedeemInfo[codeid][redeemHouse] = 0;
					RedeemInfo[codeid][redeemBiz] = 0;
					RedeemInfo[codeid][redeemVIP] = 0;
					RedeemInfo[codeid][redeemVIPDays] = 0;
					RedeemInfo[codeid][redeemGiftcard] = 0;

					ShowRedeemEdit(playerid, 1);
				}
			}
			return 1;
		}
	}
	return 1;
}

stock GivePlayerCoins(playerid, amount)
{
	if(PlayerInfo[playerid][pLogged])
	{
		PlayerInfo[playerid][pEcoin] += amount;

		if(!PlayerInfo[playerid][pAdminDuty])
		{
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET coins = coins + %i WHERE uid = %i", amount, PlayerInfo[playerid][pID]);
			mysql_tquery(connectionID, queryBuffer);
		}
	}
}

stock ShowRedeemInfo(playerid, codeid)
{
	if(RedeemInfo[codeid][redeemID] <= 0) return 1;

	static string[1024], header[128], usageStr[64], expiryStr[64];
	string[0] = EOS;

	static year, month, day, hour, minute, second;
	if(RedeemInfo[codeid][redeemExpiry]) 
	{
		TimestampToDate(RedeemInfo[codeid][redeemExpiry], year, month, day, hour, minute, second, 8);
		format(expiryStr, sizeof(expiryStr), COLOR_HEX_PRIMARY "%02d/%02d/%d", day, month, year);
	}
	else 
	{
		format(expiryStr, sizeof(expiryStr), COLOR_HEX_DANGER "No Expiry (Disabled)");
	}

	if(RedeemInfo[codeid][redeemLimited])
	{
		format(usageStr, sizeof(usageStr), COLOR_HEX_WARNING "Limited (%d remaining)", RedeemInfo[codeid][redeemTimesUsed]);
	}
	else
	{
		format(usageStr, sizeof(usageStr), COLOR_HEX_SUCCESS "Unlimited");
	}

	format(header, sizeof(header), COLOR_HEX_BRAND "CODE DETAILS " COLOR_HEX_SECONDARY "| " COLOR_HEX_PRIMARY "%s " COLOR_HEX_SECONDARY "(ID: %d)", RedeemInfo[codeid][redeemCode], codeid);

	format(string, sizeof(string),
		COLOR_HEX_SECONDARY "Property\t" COLOR_HEX_SECONDARY "Value Status\n" \
		COLOR_HEX_PRIMARY "Code Key\t" COLOR_HEX_BRAND "%s\n" \
		COLOR_HEX_PRIMARY "Usage Type\t%s\n" \
		COLOR_HEX_PRIMARY "Expiration Date\t%s\n\n" \
		COLOR_HEX_BRAND "ATTACHED REWARDS PACKAGE:\n" \
		COLOR_HEX_PRIMARY " * Coins Reward\t" COLOR_HEX_SUCCESS "%s Coins\n" \
		COLOR_HEX_PRIMARY " * In-Game Cash\t" COLOR_HEX_SUCCESS "$%s\n" \
		COLOR_HEX_PRIMARY " * Car Vouchers\t" COLOR_HEX_SUCCESS "%s Vouchers\n" \
		COLOR_HEX_PRIMARY " * Donator Status\t" COLOR_HEX_SUCCESS "%s " COLOR_HEX_SECONDARY "(%d Days)\n" \
		COLOR_HEX_PRIMARY " * Webstore Giftcard\t" COLOR_HEX_SUCCESS "%s PHP\n" \
		COLOR_HEX_PRIMARY " * Special Privileges\t" COLOR_HEX_ACCENT "%s%s%s%s%s%s",
		RedeemInfo[codeid][redeemCode],
		usageStr,
		expiryStr,
		number_format(RedeemInfo[codeid][redeemGoldBar]),
		number_format(RedeemInfo[codeid][redeemCash]),
		number_format(RedeemInfo[codeid][redeemCarVoucher]),
		RedeemInfo[codeid][redeemVIP] ? GetDonatorRank(RedeemInfo[codeid][redeemVIP]) : "None",
		RedeemInfo[codeid][redeemVIPDays],
		number_format(RedeemInfo[codeid][redeemGiftcard]),
		RedeemInfo[codeid][redeemGate] ? "Gate " : "",
		RedeemInfo[codeid][redeemJob] ? "MaxJob " : "",
		RedeemInfo[codeid][redeemDoor] ? "Door " : "",
		RedeemInfo[codeid][redeemExotic] ? "Exotic " : "",
		RedeemInfo[codeid][redeemHouse] ? "House " : "",
		RedeemInfo[codeid][redeemBiz] ? "Business" : ""
	);

	ShowPlayerDialog(playerid, DIALOG_REDEEM_INFO, DIALOG_STYLE_TABLIST_HEADERS, header, string, "Edit Config", "Back");
	return 1;
}

stock ShowRedeemEdit(playerid, menu = 0)
{
	static string[1200];
	string[0] = EOS;

	switch(menu)
	{
		case 0: // Main Management
		{
			new activeCount = 0;
			for(new j = 0; j < MAX_REDEEM_CODES; j++) if(RedeemInfo[j][redeemID] > 0) activeCount++;

			format(string, sizeof(string), 
				"Action\tStatus / Details\n" \
				"{00E5FF}[+] Create New Redeem Code\t{A0AAB8}Active Slots: {FFD600}%d/%d\n" \
				"{FFFFFF}[*] Manage Existing Codes\t{A0AAB8}View, Edit, or Delete codes", 
				activeCount, MAX_REDEEM_CODES
			);

			ShowPlayerDialog(playerid, DIALOG_REDEEM_MENU, DIALOG_STYLE_TABLIST_HEADERS, 
				"{00E5FF}REDEEM MANAGER {A0AAB8}| {FFFFFF}Control Panel", 
				string, "Select", "Close");
		}
		case 1: // List of Active Codes
		{
			new idx = 0;
			gListedItems[playerid][0] = -1;

			format(string, sizeof(string), "{A0AAB8}Code Key\t{A0AAB8}Usage Limit\t{A0AAB8}Status\n");

			for(new j = 0; j < MAX_REDEEM_CODES; j++) 
			{
				if(RedeemInfo[j][redeemID] > 0)
				{
					new limitStr[64];
					if(RedeemInfo[j][redeemLimited]) {
						format(limitStr, sizeof(limitStr), "{FFD600}%d Uses Left", RedeemInfo[j][redeemTimesUsed]);
					} else {
						format(limitStr, sizeof(limitStr), "{00E676}Unlimited");
					}

					format(string, sizeof(string), "%s{FFFFFF}%s\t%s\t%s\n",
						string,
						RedeemInfo[j][redeemCode],
						limitStr,
						RedeemInfo[j][redeemExpiry] ? "{00E676}Active" : "{FF1744}No Expiry Set"
					);
					gListedItems[playerid][idx++] = j;
				}
			}

			if(!idx)
			{
				ShowPlayerDialog(playerid, DIALOG_REDEEM_LIST, DIALOG_STYLE_MSGBOX, 
					"{00E5FF}REDEEM MANAGER {A0AAB8}| {FFFFFF}Code List", 
					"{FF1744}Walang nahanap na active redeem codes sa database.", "Create", "Back");
			}
			else
			{
				ShowPlayerDialog(playerid, DIALOG_REDEEM_LIST, DIALOG_STYLE_TABLIST_HEADERS, 
					"{00E5FF}REDEEM MANAGER {A0AAB8}| {FFFFFF}Active Codes", 
					string, "Configure", "Back");
			}
		}
		case 2: // Detailed Code Editor
		{
			new codeid = GetPVarInt(playerid, "redeem_edit");

			static dateStr[32];
			if(RedeemInfo[codeid][redeemExpiry])
			{
				static year, month, day, hour, minute, second;
				TimestampToDate(RedeemInfo[codeid][redeemExpiry], year, month, day, hour, minute, second, 8);
				format(dateStr, sizeof(dateStr), "%02d/%02d/%d", day, month, year);
			}	
			else dateStr = "Unset (No Expiry)";

			format(string, sizeof(string),
				"{A0AAB8}Option Parameter\t{A0AAB8}Configured Value\n" \
				"{FFFFFF}Expiration Date\t{FFD600}%s\n" \
				"{FFFFFF}Usage Restriction\t%s\n" \
				"{FFFFFF}Allowed Redemptions\t{FFFFFF}%d Claims\n" \
				"{FFFFFF}Coins Reward\t{00E676}%s Coins\n" \
				"{FFFFFF}Car Vouchers\t{00E676}%s Vouchers\n" \
				"{FFFFFF}Cash Reward\t{00E676}$%s\n" \
				"{FFFFFF}Gate Voucher\t%s\n" \
				"{FFFFFF}Max Job Voucher\t%s\n" \
				"{FFFFFF}Dynamic Door Voucher\t%s\n" \
				"{FFFFFF}Exotic Vehicle Voucher\t%s\n" \
				"{FFFFFF}House Voucher\t%s\n" \
				"{FFFFFF}Business Voucher\t%s\n" \
				"{FFFFFF}VIP Rank\t{00E676}%s\n" \
				"{FFFFFF}VIP Duration\t{00E676}%d Days\n" \
				"{FFFFFF}Donation Giftcard\t{00E676}%s PHP\n" \
				"{FF1744}[!] Delete Code Permanently\t{FF1744}[Permanent Removal]",
				dateStr,
				RedeemInfo[codeid][redeemLimited] ? "{FFD600}Limited" : "{00E676}Unlimited",
				RedeemInfo[codeid][redeemTimesUsed],
				number_format(RedeemInfo[codeid][redeemGoldBar]),
				number_format(RedeemInfo[codeid][redeemCarVoucher]),
				number_format(RedeemInfo[codeid][redeemCash]),
				RedeemInfo[codeid][redeemGate] ? "{00E676}ENABLED" : "{FF1744}DISABLED",
				RedeemInfo[codeid][redeemJob] ? "{00E676}ENABLED" : "{FF1744}DISABLED",
				RedeemInfo[codeid][redeemDoor] ? "{00E676}ENABLED" : "{FF1744}DISABLED",
				RedeemInfo[codeid][redeemExotic] ? "{00E676}ENABLED" : "{FF1744}DISABLED",
				RedeemInfo[codeid][redeemHouse] ? "{00E676}ENABLED" : "{FF1744}DISABLED",
				RedeemInfo[codeid][redeemBiz] ? "{00E676}ENABLED" : "{FF1744}DISABLED",
				RedeemInfo[codeid][redeemVIP] ? GetDonatorRank(RedeemInfo[codeid][redeemVIP]) : "Disabled",
				RedeemInfo[codeid][redeemVIPDays],
				number_format(RedeemInfo[codeid][redeemGiftcard])
			);

			static dialogTitle[128];
			format(dialogTitle, sizeof(dialogTitle), "{00E5FF}EDIT CODE {A0AAB8}| {FFFFFF}%s", RedeemInfo[codeid][redeemCode]);

			ShowPlayerDialog(playerid, DIALOG_REDEEM_EDIT, DIALOG_STYLE_TABLIST_HEADERS, dialogTitle, string, "Modify", "Back");
		}
	}
	return 1;
}

stock GetRedeemCodeNextID()
{
	for(new j = 0; j < MAX_REDEEM_CODES; j++)
	{
		if(!RedeemInfo[j][redeemID]) return j;
	}
	return -1;
}

stock RedeemPrizeFromCodeForPlayer(playerid, codeid)
{
	if(RedeemInfo[codeid][redeemID] <= 0) return 0;

	new received = 0;

	SendClientMessageEx(playerid, COLOR_GREEN, "[REDEEM SUCCESS]: You have redeemed code '{0080FF}%s{FFFFFF}'!", RedeemInfo[codeid][redeemCode]);

	if(RedeemInfo[codeid][redeemGoldBar])
	{
		GivePlayerCoins(playerid, RedeemInfo[codeid][redeemGoldBar]);
		SendClientMessageEx(playerid, COLOR_YELLOW, "  » Received: {FFFFFF}%s Coin(s)", number_format(RedeemInfo[codeid][redeemGoldBar]));
		received++;
	}
	if(RedeemInfo[codeid][redeemCarVoucher])
	{
		PlayerInfo[playerid][pCarVoucher] += RedeemInfo[codeid][redeemCarVoucher]; // Fixed index bug
		SendClientMessageEx(playerid, COLOR_YELLOW, "  » Received: {FFFFFF}%dx Car Voucher(s)", RedeemInfo[codeid][redeemCarVoucher]);
		SavePlayerVariables(playerid);
		received++;
	}
	if(RedeemInfo[codeid][redeemCash])
	{
		GivePlayerCash(playerid, RedeemInfo[codeid][redeemCash]);
		SendClientMessageEx(playerid, COLOR_YELLOW, "  » Received: {FFFFFF}$%s Cash", number_format(RedeemInfo[codeid][redeemCash]));
		received++;
	}
	if(RedeemInfo[codeid][redeemGate])
	{
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Server', NOW(), 'Free Gate (Redeem Code: %e)')", PlayerInfo[playerid][pID], RedeemInfo[codeid][redeemCode]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessage(playerid, COLOR_YELLOW, "  » Received: {FFFFFF}Free Custom Gate (Admin Flagged)");
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s redeemed Free Gate from code '%s' (/listflags %d)", GetRPName(playerid), RedeemInfo[codeid][redeemCode], playerid);
		received++;
	}
	if(RedeemInfo[codeid][redeemJob])
	{
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Server', NOW(), 'Free Maximum Job Level Upgrade (Redeem Code: %e)')", PlayerInfo[playerid][pID], RedeemInfo[codeid][redeemCode]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessage(playerid, COLOR_YELLOW, "  » Received: {FFFFFF}Free Max Job Level Upgrade (Admin Flagged)");
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s redeemed Max Job Upgrade from code '%s' (/listflags %d)", GetRPName(playerid), RedeemInfo[codeid][redeemCode], playerid);
		received++;
	}
	if(RedeemInfo[codeid][redeemDoor])
	{
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Server', NOW(), 'Free Dynamic Entrance (Redeem Code: %e)')", PlayerInfo[playerid][pID], RedeemInfo[codeid][redeemCode]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessage(playerid, COLOR_YELLOW, "  » Received: {FFFFFF}Free Dynamic Entrance (Admin Flagged)");
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s redeemed Dynamic Door from code '%s' (/listflags %d)", GetRPName(playerid), RedeemInfo[codeid][redeemCode], playerid);
		received++;
	}
	if(RedeemInfo[codeid][redeemExotic])
	{
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Server', NOW(), 'Free Exotic Vehicle (Redeem Code: %e)')", PlayerInfo[playerid][pID], RedeemInfo[codeid][redeemCode]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessage(playerid, COLOR_YELLOW, "  » Received: {FFFFFF}Free Exotic Vehicle (Admin Flagged)");
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s redeemed Exotic Vehicle from code '%s' (/listflags %d)", GetRPName(playerid), RedeemInfo[codeid][redeemCode], playerid);
		received++;
	}
	if(RedeemInfo[codeid][redeemHouse])
	{
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Server', NOW(), 'Free House (Redeem Code: %e)')", PlayerInfo[playerid][pID], RedeemInfo[codeid][redeemCode]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessage(playerid, COLOR_YELLOW, "  » Received: {FFFFFF}Free House Voucher (Admin Flagged)");
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s redeemed House Voucher from code '%s' (/listflags %d)", GetRPName(playerid), RedeemInfo[codeid][redeemCode], playerid);
		received++;
	}
	if(RedeemInfo[codeid][redeemBiz])
	{
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Server', NOW(), 'Free Business (Redeem Code: %e)')", PlayerInfo[playerid][pID], RedeemInfo[codeid][redeemCode]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessage(playerid, COLOR_YELLOW, "  » Received: {FFFFFF}Free Business Voucher (Admin Flagged)");
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s redeemed Business Voucher from code '%s' (/listflags %d)", GetRPName(playerid), RedeemInfo[codeid][redeemCode], playerid);
		received++;
	}
	if(RedeemInfo[codeid][redeemVIP])
	{
		if(RedeemInfo[codeid][redeemVIPDays])
		{
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Server', NOW(), 'Received %d day(s) %e (Redeem Code: %e)')", PlayerInfo[playerid][pID], RedeemInfo[codeid][redeemVIPDays], GetDonatorRank(RedeemInfo[codeid][redeemVIP]), RedeemInfo[codeid][redeemCode]);
			mysql_tquery(connectionID, queryBuffer);

			SendClientMessageEx(playerid, COLOR_YELLOW, "  » Received: {FFFFFF}%s status for %d day(s)", GetDonatorRank(RedeemInfo[codeid][redeemVIP]), RedeemInfo[codeid][redeemVIPDays]);
			SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s received %s (%d days) from code '%s' (/listflags %d)", GetRPName(playerid), GetDonatorRank(RedeemInfo[codeid][redeemVIP]), RedeemInfo[codeid][redeemVIPDays], RedeemInfo[codeid][redeemCode], playerid);
			received++;
		}
	}
	if(RedeemInfo[codeid][redeemGiftcard])
	{
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO flags VALUES(null, %i, 'Server', NOW(), 'Donation Giftcard Worth of %ephp (Redeem Code: %e)')", PlayerInfo[playerid][pID], number_format(RedeemInfo[codeid][redeemGiftcard]), RedeemInfo[codeid][redeemCode]);
		mysql_tquery(connectionID, queryBuffer);

		SendClientMessageEx(playerid, COLOR_YELLOW, "  » Received: {FFFFFF}%s PHP Donation Store Giftcard", number_format(RedeemInfo[codeid][redeemGiftcard]));
		SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s received %s PHP Giftcard from code '%s' (/listflags %d)", GetRPName(playerid), number_format(RedeemInfo[codeid][redeemGiftcard]), RedeemInfo[codeid][redeemCode], playerid);
		received++;
	}

	// Usage tracking logic
	if(RedeemInfo[codeid][redeemTimesUsed] > 0)
	{
		RedeemInfo[codeid][redeemTimesUsed]--;

		if(RedeemInfo[codeid][redeemTimesUsed] < 1 && RedeemInfo[codeid][redeemLimited])
		{
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM redeem_players WHERE CODE_ID = %d", RedeemInfo[codeid][redeemID]);
			mysql_tquery(connectionID, queryBuffer);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM redeem_codes WHERE code_id = %d", RedeemInfo[codeid][redeemID]);
			mysql_tquery(connectionID, queryBuffer);

			RedeemInfo[codeid][redeemID] = 0;
		}
		else
		{
			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE redeem_codes SET times_used = %d WHERE code_id = %d", RedeemInfo[codeid][redeemTimesUsed], RedeemInfo[codeid][redeemID]);
			mysql_tquery(connectionID, queryBuffer);

			mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO redeem_players (redeem_timestamp, ID, CODE_ID) VALUES(%d, %d, %d)", gettime(), PlayerInfo[playerid][pID], RedeemInfo[codeid][redeemID]);
			mysql_tquery(connectionID, queryBuffer);
		}
	}
	else
	{
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO redeem_players (redeem_timestamp, ID, CODE_ID) VALUES(%d, %d, %d)", gettime(), PlayerInfo[playerid][pID], RedeemInfo[codeid][redeemID]);
		mysql_tquery(connectionID, queryBuffer);
	}

	if(!received)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "[REDEEM WARNING]: This code contains no active rewards. Contact an administrator.");
	}

	SendAdminMessage(COLOR_LIGHTRED, "AdmWarn: %s used redeem code '%s' (ID: %d).", GetRPName(playerid), RedeemInfo[codeid][redeemCode], codeid);
	return 1;
}

stock GenerateRandomCode(length = 8)
{
	static str[16];
	str[0] = EOS;

	if(length > sizeof(str) - 1) length = sizeof(str) - 1;

	for(new j = 0; j < length; j++)
	{
		str[j] = g_aCharset[random(sizeof(g_aCharset) - 1)];
	}
	str[length] = EOS;

	return str;
}