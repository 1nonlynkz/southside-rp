#include <YSI_Coding\y_hooks>

#define DIALOG_CHARGE_LIST        (15420)
#define DIALOG_ADMIN_CHARGES      (15421)
#define DIALOG_ADMIN_EDIT_CHARGE  (15422)

enum e_CRIME_DATA {
    cName[64],
    cFine,
    cJailTime
};

new CrimeData[][e_CRIME_DATA] = {
    {"Aggravated assault",                     3500,  8},
    {"Aiding and abetting / Accessory",        2500,  5},
    {"Arson",                                  5000, 10},
    {"Assault / Battery",                      2000,  5},
    {"Attempted Crime",                        1500,  4},
    {"Bribery",                                5000, 10},
    {"Burglary",                               3000,  6},
    {"Child abandonment",                      4000,  8},
    {"Child abuse",                            6000, 12},
    {"Child neglect",                          3000,  6},
    {"Child pornography",                     15000, 25},
    {"Computer crime",                         2500,  5},
    {"Conspiracy",                             3000,  6},
    {"Counterfeiting",                         4000,  8},
    {"Credit / Debit card fraud",              2500,  5},
    {"Criminal contempt of court",             1500,  4},
    {"Cyberbullying",                          1000,  3},
    {"Disorderly conduct",                      800,  2},
    {"Disturbing the peace",                    500,  1},
    {"Domestic violence",                      3500,  7},
    {"Drug manufacturing and cultivation",    10000, 18},
    {"Drug possession",                        1500,  4},
    {"Drug trafficking / Distribution",        8000, 15},
    {"DUI / DWI",                              1200,  3},
    {"Embezzlement",                           6000, 10},
    {"Extortion",                              4000,  8},
    {"Forgery",                                2500,  5},
    {"Fraud",                                  3000,  6},
    {"Harassment",                             1200,  3},
    {"Hate crimes",                            5000, 10},
    {"Homicide",                               20000, 30},
    {"Identity theft",                         3000,  6},
    {"Insurance fraud",                        4000,  8},
    {"Kidnapping",                             8000, 15},
    {"Manslaughter: Involuntary",             10000, 18},
    {"Manslaughter: Voluntary",               15000, 22},
    {"Medical Marijuana Violation",            1000,  2},
    {"MIP: Minor in possession",                800,  2},
    {"Money laundering",                      10000, 15},
    {"Murder: First-degree",                  25000, 35},
    {"Murder: Second-degree",                 18000, 28},
    {"Obstruction of justice",                 2000,  5},
    {"Open container (of alcohol)",             300,  0},
    {"Parole violation",                       2500,  6},
    {"Perjury",                                3000,  6},
    {"Probation violation",                    2000,  5},
    {"Prostitution",                           1000,  3},
    {"Public intoxication",                     500,  1},
    {"Pyramid schemes",                        7500, 12},
    {"Racketeering / RICO",                   12000, 20},
    {"Rape",                                  20000, 30},
    {"Robbery",                                5000, 10},
    {"Securities fraud",                       8000, 12},
    {"Sexual assault",                        15000, 25},
    {"Shoplifting",                            1000,  2},
    {"Solicitation",                           1200,  3},
    {"Stalking",                               2000,  5},
    {"Statutory rape",                        15000, 25},
    {"Tax evasion / Fraud",                    6000, 10},
    {"Telemarketing fraud",                    3000,  5},
    {"Theft",                                  1500,  4},
    {"Vandalism",                              1200,  3},
    {"White collar crimes",                    8000, 12},
    {"Wire fraud",                             5000,  8}
};

static 
    pChargeTarget[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...},
    pAdminCrimeEdit[MAX_PLAYERS] = {-1, ...};

CMD:charge(playerid, const params[])
{
    if(!IsLawEnforcement(playerid))
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of law enforcement.");

    if(PlayerInfo[playerid][pDuty] == 0)
        return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /charge [playerid]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");

    if(PlayerInfo[targetid][pWantedLevel] >= 6)
        return SendClientMessage(playerid, COLOR_SYNTAX, "This player is already at the maximum wanted level (6).");

    pChargeTarget[playerid] = targetid;

    new query[128];
    mysql_format(connectionID, query, sizeof(query), "SELECT reason, COUNT(*) AS total FROM charges WHERE uid = %d GROUP BY reason", PlayerInfo[targetid][pID]);
    mysql_tquery(connectionID, query, "OnPlayerChargeLoad", "i", playerid);
    return 1;
}

CMD:editcharge(playerid, const params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4)
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

    new string[3000];
    strcat(string, "Crime Name\tFine\tJail Time\n");

    for(new i = 0; i < sizeof(CrimeData); i++)
    {
        format(string, sizeof(string), "%s%s\t$%d\t%d mins\n", string, CrimeData[i][cName], CrimeData[i][cFine], CrimeData[i][cJailTime]);
    }

    ShowPlayerDialog(playerid, DIALOG_ADMIN_CHARGES, DIALOG_STYLE_TABLIST_HEADERS, "Edit Charge Settings", string, "Select", "Cancel");
    return 1;
}

forward OnPlayerChargeLoad(playerid);
public OnPlayerChargeLoad(playerid)
{
    new targetid = pChargeTarget[playerid];
    if(!IsPlayerConnected(targetid))
        return 1;

    new counts[sizeof(CrimeData)];
    new rows = cache_num_rows();

    if(rows > 0)
    {
        new reason[64], count;
        for(new i = 0; i < rows; i++)
        {
            cache_get_field_content(i, "reason", reason, connectionID, sizeof(reason));
            count = cache_get_field_content_int(i, "total", connectionID);

            for(new c = 0; c < sizeof(CrimeData); c++)
            {
                if(!strcmp(reason, CrimeData[c][cName], true))
                {
                    counts[c] = count;
                    break;
                }
            }
        }
    }

    new string[4096], title[64];
    format(title, sizeof(title), "Select Charge for %s", GetRPName(targetid));
    strcat(string, "Crime\tFine\tJail Time\tTimes Charged\n");

    for(new i = 0; i < sizeof(CrimeData); i++)
    {
        if(counts[i] > 0)
        {
            format(string, sizeof(string), "%s%s\t$%d\t%d mins\t{FF3333}%d times\n", 
                string, CrimeData[i][cName], CrimeData[i][cFine], CrimeData[i][cJailTime], counts[i]);
        }
        else
        {
            format(string, sizeof(string), "%s%s\t$%d\t%d mins\t{808080}0 times\n", 
                string, CrimeData[i][cName], CrimeData[i][cFine], CrimeData[i][cJailTime]);
        }
    }

    ShowPlayerDialog(playerid, DIALOG_CHARGE_LIST, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Select", "Close");
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_CHARGE_LIST:
        {
            if(!response)
            {
                pChargeTarget[playerid] = INVALID_PLAYER_ID;
                return 1;
            }

            new targetid = pChargeTarget[playerid];
            if(!IsPlayerConnected(targetid))
            {
                SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is no longer connected.");
                pChargeTarget[playerid] = INVALID_PLAYER_ID;
                return 1;
            }

            if(PlayerInfo[targetid][pWantedLevel] >= 6)
            {
                SendClientMessage(playerid, COLOR_SYNTAX, "This player is already at the maximum wanted level (6).");
                pChargeTarget[playerid] = INVALID_PLAYER_ID;
                return 1;
            }

            new reason[64];
            format(reason, sizeof(reason), "%s", CrimeData[listitem][cName]);

            PlayerInfo[targetid][pWantedLevel]++;
            PlayerInfo[targetid][pCrimes]++;

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET wantedlevel = %d, crimes = %d WHERE uid = %d", PlayerInfo[targetid][pWantedLevel], PlayerInfo[targetid][pCrimes], PlayerInfo[targetid][pID]);
            mysql_tquery(connectionID, queryBuffer);

            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO charges (uid, officer, date, reason) VALUES (%d, '%e', NOW(), '%e')", PlayerInfo[targetid][pID], GetPlayerNameEx(playerid), reason);
            mysql_tquery(connectionID, queryBuffer);

            SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_ROYALBLUE, "HQ: %s %s has charged %s with "SVRCLR"%s{9999FF}.", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetRPName(playerid), GetRPName(targetid), reason);
            SendMessage(targetid, COLOR_LIGHTRED, "** Officer %s has charged you with %s.", GetRPName(playerid), reason);
            Log_Write("log_faction", "%s (uid: %d) has charged %s (uid: %d) with %s", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], reason);

            pChargeTarget[playerid] = INVALID_PLAYER_ID;
            return 1;
        }

        case DIALOG_ADMIN_CHARGES:
        {
            if(!response)
                return 1;

            pAdminCrimeEdit[playerid] = listitem;

            new string[256];
            format(string, sizeof(string), "{FFFFFF}Editing: {00FF00}%s\n\n{FFFFFF}Enter fine & jail time (minutes) separated by space:\nUsage: [Fine] [Jail Minutes]\nCurrent: Fine: $%d | Jail: %d mins", 
                CrimeData[listitem][cName], CrimeData[listitem][cFine], CrimeData[listitem][cJailTime]);

            ShowPlayerDialog(playerid, DIALOG_ADMIN_EDIT_CHARGE, DIALOG_STYLE_INPUT, "Edit Charge Values", string, "Save", "Cancel");
            return 1;
        }

        case DIALOG_ADMIN_EDIT_CHARGE:
        {
            if(!response)
            {
                pAdminCrimeEdit[playerid] = -1;
                return 1;
            }

            new index = pAdminCrimeEdit[playerid];
            if(index == -1)
                return 1;

            new fine, jail;
            if(sscanf(inputtext, "dd", fine, jail))
            {
                SendClientMessage(playerid, COLOR_SYNTAX, "Usage: [Fine] [Jail Minutes]");
                pAdminCrimeEdit[playerid] = -1;
                return 1;
            }

            CrimeData[index][cFine] = fine;
            CrimeData[index][cJailTime] = jail;

            new string[128];
            format(string, sizeof(string), "[Admin] Updated %s charge: Fine $%d | Jail %d mins.", CrimeData[index][cName], fine, jail);
            SendClientMessage(playerid, COLOR_LIGHTGREEN, string);

            pAdminCrimeEdit[playerid] = -1;
            return 1;
        }
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    pChargeTarget[playerid] = INVALID_PLAYER_ID;
    pAdminCrimeEdit[playerid] = -1;
    return 1;
}