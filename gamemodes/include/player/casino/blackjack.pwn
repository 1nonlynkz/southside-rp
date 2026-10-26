#include                             <YSI_Coding\y_hooks>

#define COLOR_GOLD                  0xFFD700FF
#define COL_YELLOW                  "{FFFF00}"
#define COL_GOLD                    "{FFD700}"
#define COL_WHITE                   "{FFFFFF}"

#define MAX_BLACKJACK_TABLES        ( 34 )
#define MAX_BLACKJACK_CARDS         ( 5 )
#define MAX_BLACKJACK_PLAYERS        ( 3 )
#define BLACKJACK_DEALER_WAIT        ( 500 )
#define BLACKJACK_PLAYER_WAIT        ( 10 )

#define BLACKJACK_STATE_NONE        ( 0 )
#define BLACKJACK_STATE_TURN        ( 1 )
#define BLACKJACK_STATE_BUST        ( 2 )
#define BLACKJACK_STATE_STAND       ( 3 )
#define BLACKJACK_STATE_WIN         ( 4 )

#define DIALOG_BLACKJACK_SETUP      ( 1054 )
#define DIALOG_BLACKJACK_INPUT      ( 1055 )

stock const g_cardTextdrawData[ ] [ ] = {
    "LD_CARD:cd1c",  // A Clubs - 0
    "LD_CARD:cd2c",  // 2 Clubs - 1
    "LD_CARD:cd3c",  // 3 Clubs - 2
    "LD_CARD:cd4c",  // 4 Clubs - 3
    "LD_CARD:cd5c",  // 5 Clubs - 4
    "LD_CARD:cd6c",  // 6 Clubs - 5
    "LD_CARD:cd7c",  // 7 Clubs - 6
    "LD_CARD:cd8c",  // 8 Clubs - 7
    "LD_CARD:cd9c",  // 9 Clubs - 8
    "LD_CARD:cd10c", // 10 Clubs - 9
    "LD_CARD:cd11c", // J Clubs - 10
    "LD_CARD:cd12c", // Q Clubs - 11
    "LD_CARD:cd13s"  // K Spades - 12
};

enum E_BLACKJACK_DATA
{
    E_ID, 
    bool: E_GAME_STARTED,   E_CARDS_DRAWN,          E_GAME_TIMER,
    E_PAYOUT,               E_WORLD,                E_RESET_TIMER,
    E_DRAW_CARD_TIMER,

    E_OBJECT,               E_ACTOR,

    Float: E_X,             Float: E_Y,             Float: E_Z,
    Float: E_ROTATION,

    Text3D: E_DEALER_LABEL, Text3D: E_PLAYER_LABEL[ MAX_BLACKJACK_PLAYERS ]
};

new
    g_blackjackData 				[ MAX_BLACKJACK_TABLES ] [ E_BLACKJACK_DATA ],
    Text: g_blackjackTurnTD			[ MAX_BLACKJACK_TABLES ] = { Text: INVALID_TEXT_DRAW, ... },
    Text: g_blackjackPlayerCards	[ MAX_BLACKJACK_TABLES ] [ MAX_BLACKJACK_CARDS ] [ MAX_BLACKJACK_PLAYERS ],
    Text: g_blackjackDealerCards	[ MAX_BLACKJACK_TABLES ] [ MAX_BLACKJACK_CARDS ],
    g_blackjackDealerCardIndex		[ MAX_BLACKJACK_TABLES ] [ MAX_BLACKJACK_CARDS ],
    g_blackjackPlayerCardIndex		[ MAX_BLACKJACK_TABLES ] [ MAX_BLACKJACK_CARDS ] [ MAX_BLACKJACK_PLAYERS ],
    g_blackjackPlayerState			[ MAX_BLACKJACK_TABLES ] [ MAX_BLACKJACK_PLAYERS ],
    g_blackjackSlotData				[ MAX_BLACKJACK_TABLES ] [ MAX_BLACKJACK_PLAYERS ],
    g_blackjackPlayerBet            [ MAX_BLACKJACK_TABLES ] [ MAX_BLACKJACK_PLAYERS ],
    p_blackjackTable				[ MAX_PLAYERS ] = { -1, ... },
    g_bjSetupChoice                 [ MAX_PLAYERS ] = { -1, ... },
    Iterator: blackjacktables 		< MAX_BLACKJACK_TABLES >
;

hook OnScriptInit()
{
    mysql_tquery(connectionID, "SELECT * FROM blackjack_tables", "LoadBlackjackTables");
	return 1;
}

forward LoadBlackjackTables();
public LoadBlackjackTables()
{
    new rows, fields;
    cache_get_data(rows, fields); 

    if(rows > 0)
    {
        new id, payout, world;
        new Float:x, Float:y, Float:z, Float:a;
        for(new i = 0; i < rows; i++)
        {
            id      = cache_get_field_content_int(i, "id");
            payout  = cache_get_field_content_int(i, "payout");
            x       = cache_get_field_content_float(i, "pos_x");
            y       = cache_get_field_content_float(i, "pos_y");
            z       = cache_get_field_content_float(i, "pos_z");
            a       = cache_get_field_content_float(i, "pos_a");
            world   = cache_get_field_content_int(i, "world");

            CreateBlackjackTable(payout, x, y, z, a, world, id);
        }
        printf("[BLACKJACK] Loaded %d blackjack tables from database.", rows);
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	RemovePlayerFromBlackjack(playerid);
	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	RemovePlayerFromBlackjack(playerid);
	return 1;
}

hook OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
    new Float: X, Float: Y, Float: Z;
    new Float: table_distance = 99999.99;
    new table = Blackjack_GetClosestTable(playerid, table_distance);

    if (table != -1 && table_distance < 2.5)
    {
        new blackjack_table = p_blackjackTable[playerid];

        if (blackjack_table != -1)
        {
            new player_index = GetBlackjackPlayerIndex(blackjack_table, playerid);

            if (player_index == -1)
            {
                return SendMessage(playerid, COLOR_LIGHTRED, "You don't seem to be playing any blackjack table.");
            }

            if (PRESSED(KEY_CTRL_BACK))
            {
                if (!g_blackjackData[blackjack_table][E_CARDS_DRAWN] && g_blackjackData[blackjack_table][E_GAME_TIMER] == -1)
                {
                    ShowBlackjackSetupDialog(playerid, blackjack_table);
                    return 1;
                }
                else {
                    return SendClientMessageToBlackjack(blackjack_table, COLOR_GREY, "[BLACKJACK]" COL_WHITE " The game is already started.");
                }
            }

            if (PRESSED(KEY_YES))
            {
                if (!g_blackjackData[blackjack_table][E_CARDS_DRAWN] && g_blackjackData[blackjack_table][E_GAME_TIMER] == -1)
                {
                    ShowBlackjackSetupDialog(playerid, blackjack_table);
                    return 1;
                }

                if (g_blackjackPlayerState[blackjack_table][player_index] == BLACKJACK_STATE_TURN)
                {
                    g_blackjackPlayerState[blackjack_table][player_index] = BLACKJACK_STATE_STAND;
                    SendClientMessageToBlackjack(blackjack_table, COLOR_GREY, "[BLACKJACK]" COL_WHITE " %s(%d) has decided to stand.", ReturnPlayerRPName(playerid), playerid);
                    return 1;
                }
                return 1;
            }

            if (PRESSED(KEY_NO))
            {
                if (g_blackjackPlayerState[blackjack_table][player_index] != BLACKJACK_STATE_TURN)
                {
                    return SendMessage(playerid, COLOR_LIGHTRED, "It's not your turn to hit. Please wait!");
                }
                SendClientMessageToBlackjack(blackjack_table, COLOR_GREY, "[BLACKJACK]" COL_WHITE " %s(%d) has decided to hit.", ReturnPlayerRPName(playerid), playerid);
                DrawPlayerBlackjackCard(blackjack_table, player_index);
                CheckForBlackjack(blackjack_table);
                return 1;
            }
        }
 
        if (PRESSED(KEY_SECONDARY_ATTACK))
        {
            if (p_blackjackTable[playerid] != -1)
            {
                if (g_blackjackData[blackjack_table][E_CARDS_DRAWN])
                {
                    return SendMessage(playerid, COLOR_LIGHTRED, "You cannot exit while you are playing your blackjack hand.");
                }
                return RemovePlayerFromBlackjack(playerid, .reset_cam = 1);
            }

            foreach(new id : blackjacktables)
            {
                if (GetPlayerVirtualWorld(playerid) == g_blackjackData[id][E_WORLD])
                {
                    if (IsPlayerInRangeOfPoint(playerid, 3.0, g_blackjackData[id][E_X], g_blackjackData[id][E_Y], g_blackjackData[id][E_Z]))
                    {
                        new player_index;

                        for (; player_index < MAX_BLACKJACK_PLAYERS; player_index++)
                        {
                            if (g_blackjackSlotData[id][player_index] == -1)
                            {
                                break;
                            }
                        }

                        if (player_index >= MAX_BLACKJACK_PLAYERS || g_blackjackSlotData[id][player_index] != -1)
                        {
                            return SendMessage(playerid, COLOR_LIGHTRED, "There are no more vacant slots for this table.");
                        }

                        if (PlayerInfo[playerid][pCash] < g_blackjackData[id][E_PAYOUT])
                        {
                            return SendMessage(playerid, COLOR_LIGHTRED, "You don't have any money to wager.");
                        }

                        new Float: lookatX, Float: lookatY, Float: lookatZ, Float: tmpX, Float: tmpY, Float: tmpZ;

                        GetPlayerCameraPos(playerid, X, Y, Z);
                        GetPlayerCameraFrontVector(playerid, lookatX, lookatY, lookatZ);

                        tmpX = g_blackjackData[id][E_X] - 1.3 * floatcos(g_blackjackData[id][E_ROTATION] + 90.0, degrees);
                        tmpY = g_blackjackData[id][E_Y] - 1.3 * floatsin(g_blackjackData[id][E_ROTATION] + 90.0, degrees);
                        tmpZ = g_blackjackData[id][E_Z] + 1.7;

                        InterpolateCameraPos(playerid, X, Y, Z, tmpX, tmpY, tmpZ, 1000, CAMERA_MOVE);

                        X += floatmul(lookatX, 20.0);
                        Y += floatmul(lookatY, 20.0);
                        Z += floatmul(lookatZ, 20.0);

                        InterpolateCameraLookAt(playerid, X, Y, Z, g_blackjackData[id][E_X], g_blackjackData[id][E_Y], g_blackjackData[id][E_Z] - 1.0, 1000, CAMERA_MOVE);

                        p_blackjackTable[playerid] = id;
                        g_blackjackSlotData[id][player_index] = playerid;
                        g_blackjackPlayerBet[id][player_index] = g_blackjackData[id][E_PAYOUT];

                        for (new c = 0; c < MAX_BLACKJACK_CARDS; c++)
                        {
                            g_blackjackPlayerCardIndex[id][c][player_index] = -1;
                        }

                        SetBlackjackPlayerLabelValue(id, player_index, 0);

                        for (new player = 0; player < MAX_BLACKJACK_PLAYERS; player++)
                        {
                            new gamerid = g_blackjackSlotData[id][player];

                            for (new c = 0; c < MAX_BLACKJACK_CARDS; c++)
                            {
                                TextDrawShowForPlayer(gamerid, g_blackjackDealerCards[id][c]);

                                if (c >= 2)
                                {
                                    continue;
                                }

                                for (new p = 0; p < GetBlackjackPlayers(id); p++)
                                {
                                    TextDrawShowForPlayer(gamerid, g_blackjackPlayerCards[id][c][p]);
                                }
                            }
                        }

                        SendMessage(playerid, COLOR_GREEN, "Press H / Y to Setup Table. Y to Stand, N to Hit.");
                        SendClientMessage(playerid, -1, "You have entered the %s hand blackjack table.", cash_format(g_blackjackData[id][E_PAYOUT]));
                        ApplyAnimation(playerid, "DEALER", "DEALER_IDLE", 4.1, true, true, true, true, 0);
                        
                        ShowBlackjackSetupDialog(playerid, id);
                        return 1;
                    }
                }
            }
        }
    }
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == DIALOG_BLACKJACK_SETUP)
    {
        if (!response) return 1;

        new tableid = p_blackjackTable[playerid];
        if (tableid == -1) return 1;

        switch (listitem)
        {
            case 0: // Bet Amount
            {
                g_bjSetupChoice[playerid] = 0;
                ShowPlayerDialog(playerid, DIALOG_BLACKJACK_INPUT, DIALOG_STYLE_INPUT, "Blackjack Setup - Bet Amount", "Enter the wager amount for this game:", "Set", "Back");
            }
            case 1: // Turn Timer
            {
                SendClientMessage(playerid, COLOR_GREY, "[BLACKJACK] Default turn timer is fixed to 10 seconds.");
                ShowBlackjackSetupDialog(playerid, tableid);
            }
            case 2: // Start Game
            {
                if (!g_blackjackData[tableid][E_CARDS_DRAWN] && g_blackjackData[tableid][E_GAME_TIMER] == -1)
                {
                    g_blackjackData[tableid][E_GAME_TIMER] = SetTimerEx("BeginBlackJackTurn", BLACKJACK_DEALER_WAIT, false, "d", tableid);
                    SendClientMessageToBlackjack(tableid, COLOR_GREEN, "[BLACKJACK] The game has started!");
                }
                else
                {
                    SendClientMessage(playerid, COLOR_LIGHTRED, "The game has already started on this table.");
                }
            }
        }
        return 1;
    }

    if (dialogid == DIALOG_BLACKJACK_INPUT)
    {
        new tableid = p_blackjackTable[playerid];
        if (!response)
        {
            if (tableid != -1) ShowBlackjackSetupDialog(playerid, tableid);
            return 1;
        }

        if (tableid == -1) return 1;

        if (g_bjSetupChoice[playerid] == 0)
        {
            new amount = strval(inputtext);
            if (amount <= 0 || amount < g_blackjackData[tableid][E_PAYOUT])
            {
                SendClientMessage(playerid, COLOR_LIGHTRED, "The bet amount is below the table's minimum wager.");
                return ShowBlackjackSetupDialog(playerid, tableid);
            }
            if (PlayerInfo[playerid][pCash] < amount)
            {
                SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have enough cash for that wager.");
                return ShowBlackjackSetupDialog(playerid, tableid);
            }

            new p_idx = GetBlackjackPlayerIndex(tableid, playerid);
            if (p_idx != -1)
            {
                g_blackjackPlayerBet[tableid][p_idx] = amount;
                SetBlackjackPlayerLabelValue(tableid, p_idx, 0);
                SendClientMessage(playerid, COLOR_GREEN, "[BLACKJACK] Your wager has been updated.");
            }
            ShowBlackjackSetupDialog(playerid, tableid);
        }
        return 1;
    }
    return 0;
}


stock ShowBlackjackSetupDialog(playerid, tableid)
{
    new p_idx = GetBlackjackPlayerIndex(tableid, playerid);
    new current_bet = (p_idx != -1) ? g_blackjackPlayerBet[tableid][p_idx] : g_blackjackData[tableid][E_PAYOUT];

    new string[512];
    format(string, sizeof(string),
        "Setting\tValue\n\
        Bet Amount\t" COL_GREEN "%s\n\
        Turn Timer\t" COL_YELLOW "%d seconds\n\
        Start Game\t" COL_GOLD "> Click to Start <",
        cash_format(current_bet),
        BLACKJACK_PLAYER_WAIT
    );

    ShowPlayerDialog(playerid, DIALOG_BLACKJACK_SETUP, DIALOG_STYLE_TABLIST_HEADERS, "Casino Games - (Setup Blackjack Table)", string, "Select", "Cancel");
    return 1;
}

stock Blackjack_GetClosestTable(playerid, &Float: dis = 99999.99)
{
    new bjtable = -1;
    new player_world = GetPlayerVirtualWorld(playerid);

    foreach (new i : blackjacktables)
    {
        if (g_blackjackData[i][E_WORLD] == player_world)
        {
            new Float: dis2 = GetPlayerDistanceFromPoint(playerid, g_blackjackData[i][E_X], g_blackjackData[i][E_Y], g_blackjackData[i][E_Z]);

            if (dis2 < dis && dis2 != -1.00)
            {
                dis = dis2;
                bjtable = i;
            }
        }
    }
    return bjtable;
}

stock CreateBlackjackTable(payout, Float: X, Float: Y, Float: Z, Float: Angle, world, db_id = 0)
{
    new id = Iter_Free(blackjacktables), string[128];

    if (id != ITER_NONE)
    {
        g_blackjackData[id][E_ID] = db_id;
        g_blackjackData[id][E_X] = X;
        g_blackjackData[id][E_Y] = Y;
        g_blackjackData[id][E_Z] = Z;
        g_blackjackData[id][E_ROTATION] = Angle;
        g_blackjackData[id][E_WORLD] = world;

        g_blackjackData[id][E_DRAW_CARD_TIMER] = -1;
        g_blackjackData[id][E_RESET_TIMER] = -1;
        g_blackjackData[id][E_GAME_TIMER] = -1;
        g_blackjackData[id][E_PAYOUT] = payout;
        g_blackjackData[id][E_OBJECT] = CreateDynamicObject(2188, X, Y, Z, 0.00000, 0.00000, Angle, .worldid = world, .priority = 9999);
        g_blackjackData[id][E_ACTOR] = CreateDynamicActor(171, X - 0.4 * floatcos(Angle - 90.0, degrees), Y - 0.4 * floatsin(Angle - 90.0, degrees), Z, Angle + 180.0, .worldid = world);
        format(string, sizeof(string), "Press ENTER To Play Blackjack\n" COL_WHITE "%s Minimum", cash_format(payout));
        g_blackjackData[id][E_DEALER_LABEL] = CreateDynamic3DTextLabel(string, COLOR_GREY, X, Y, Z + 0.25, 15.0, .testlos = 0, .worldid = world);

        g_blackjackData[id][E_PLAYER_LABEL][0] = CreateDynamic3DTextLabel("Player 0", 0, X + 0.7 * floatcos(Angle - 90.0, degrees), Y + 0.7 * floatsin(Angle - 90.0, degrees), Z + 0.05, 15.0, .testlos = 0, .worldid = world);
        g_blackjackData[id][E_PLAYER_LABEL][1] = CreateDynamic3DTextLabel("Player 1", 0, X + 0.7 * floatcos(Angle - 90.0 - 22.5, degrees), Y + 0.7 * floatsin(Angle - 90.0 - 22.5, degrees), Z + 0.05, 15.0, .testlos = 0, .worldid = world);
        g_blackjackData[id][E_PLAYER_LABEL][2] = CreateDynamic3DTextLabel("Player 2", 0, X + 0.7 * floatcos(Angle - 90.0 + 22.5, degrees), Y + 0.7 * floatsin(Angle - 90.0 + 22.5, degrees), Z + 0.05, 15.0, .testlos = 0, .worldid = world);

        SetDynamicActorInvulnerable(g_blackjackData[id][E_ACTOR], true);
        SetDynamicActorVirtualWorld(g_blackjackData[id][E_ACTOR], world);

        for (new x = 0; x < MAX_BLACKJACK_CARDS; x++)
        {
            g_blackjackDealerCards[id][x] = Text: INVALID_TEXT_DRAW;

            for (new p = 0; p < MAX_BLACKJACK_PLAYERS; p++)
            {
                g_blackjackPlayerCards[id][x][p] = Text: INVALID_TEXT_DRAW;
                g_blackjackSlotData[id][p] = -1;
            }
        }

        InitializeBlackjackTextdraws(id);
        ResetBlackjackTable(id);
        Iter_Add(blackjacktables, id);

        if(db_id == 0)
        {
            new query[256];
            mysql_format(connectionID, query, sizeof(query), "INSERT INTO blackjack_tables (payout, pos_x, pos_y, pos_z, pos_a, world) VALUES (%d, %f, %f, %f, %f, %d)", payout, X, Y, Z, Angle, world);
            mysql_tquery(connectionID, query, "OnBlackjackTableInsert", "d", id);
        }
    }
    else
    {
        static overflow;
        printf("[BLACKJACK ERROR] Reached limit of %d blackjack tables, increase to %d to fix.", MAX_BLACKJACK_TABLES, MAX_BLACKJACK_TABLES + (++overflow));
    }
    return 1;
}

forward OnBlackjackTableInsert(table_slot);
public OnBlackjackTableInsert(table_slot)
{
    g_blackjackData[table_slot][E_ID] = cache_insert_id(); 
    printf("[DATABASE] Blackjack Table spawned and saved with Database ID: %d", g_blackjackData[table_slot][E_ID]);
    return 1;
}

forward DrawPlayerBlackjackCard(tableid, player_index);
public DrawPlayerBlackjackCard(tableid, player_index)
{
    if (tableid < 0 || tableid >= MAX_BLACKJACK_TABLES || player_index < 0 || player_index >= MAX_BLACKJACK_PLAYERS)
        return 0;
    if (g_blackjackSlotData[tableid][player_index] == -1 || g_blackjackData[tableid][E_CARDS_DRAWN] == 0)
        return 0;

    new randomCard = random(sizeof(g_cardTextdrawData));

    for (new cardid = 0; cardid < MAX_BLACKJACK_CARDS; cardid++)
    {
        if (g_blackjackPlayerCardIndex[tableid][cardid][player_index] == -1)
        {
            TextDrawSetString(g_blackjackPlayerCards[tableid][cardid][player_index], g_cardTextdrawData[randomCard]);
            foreach (new gamerid : Player)
            {
                if (p_blackjackTable[gamerid] == tableid)
                {
                    TextDrawShowForPlayer(gamerid, g_blackjackPlayerCards[tableid][cardid][player_index]);
                    PlayerPlaySound(gamerid, 1145, 0.0, 0.0, 0.0);
                }
            }
            g_blackjackPlayerCardIndex[tableid][cardid][player_index] = randomCard;
            SetBlackjackPlayerLabelValue(tableid, player_index, CalculatePlayerHand(tableid, player_index));
            break;
        }
    }
    return randomCard;
}

forward BeginBlackJackTurn(tableid);
public BeginBlackJackTurn(tableid)
{
    new cardid = g_blackjackData[tableid][E_CARDS_DRAWN]++;

    if (cardid >= MAX_BLACKJACK_CARDS)
    {
        ResetBlackjackTable(tableid);
        return;
    }

    new randomCard = random(sizeof(g_cardTextdrawData));

    ApplyDynamicActorAnimation(g_blackjackData[tableid][E_ACTOR], "CASINO", "dealone", 4.1, 0, 0, 0, 0, 0);
    ApplyDynamicActorAnimation(g_blackjackData[tableid][E_ACTOR], "CASINO", "dealone", 4.1, 0, 0, 0, 0, 0);
    TextDrawSetString(g_blackjackDealerCards[tableid][cardid], g_cardTextdrawData[randomCard]);
    g_blackjackDealerCardIndex[tableid][cardid] = randomCard;
    SetBlackjackDealerLabelValue(tableid, CalculateDealerHand(tableid));

    foreach (new gamerid : Player)
    {
        if (p_blackjackTable[gamerid] != -1)
        {
            PlayerPlaySound(gamerid, 1145, 0.0, 0.0, 0.0);
        }
    }

    if (cardid == 0)
    {
        new blackjack_players = GetBlackjackPlayers(tableid);
        new bet_amount = 0;

        for (new player_index = 0; player_index < MAX_BLACKJACK_PLAYERS; player_index++)
        {
            if (g_blackjackSlotData[tableid][player_index] != -1)
            {
                new gamerid = g_blackjackSlotData[tableid][player_index];

                if(g_blackjackPlayerBet[tableid][player_index] <= 0) {
                    g_blackjackPlayerBet[tableid][player_index] = g_blackjackData[tableid][E_PAYOUT];
                }

                new current_user_bet = g_blackjackPlayerBet[tableid][player_index];

                if (PlayerInfo[gamerid][pCash] < current_user_bet)
                {
                    SendMessage(gamerid, COLOR_LIGHTRED, "You don't have any money to wager.");
                    RemovePlayerFromBlackjack(gamerid, .reset_cam = 1);
                    if (blackjack_players - 1 <= 0)
                        return; 
                    continue;
                }

                bet_amount += current_user_bet;
                GivePlayerCash(gamerid, -current_user_bet);
                DrawPlayerBlackjackCard(tableid, player_index);
                DrawPlayerBlackjackCard(tableid, player_index);
            }
        }

        new first_player = GetNextAvailableBlackjackPlayer(tableid);
        new first_player_index = GetBlackjackPlayerIndex(tableid, first_player);

        if (first_player_index != -1)
            g_blackjackPlayerState[tableid][first_player_index] = BLACKJACK_STATE_TURN;

        g_blackjackData[tableid][E_GAME_TIMER] = SetTimerEx("BlackjackPlayerTurn", BLACKJACK_DEALER_WAIT + 500, false, "ddd", tableid, first_player, BLACKJACK_PLAYER_WAIT);
    }

    new dealer_score = CheckForBlackjack(tableid);

    if (cardid >= 1 && dealer_score < 17)
        g_blackjackData[tableid][E_GAME_TIMER] = SetTimerEx("BeginBlackJackTurn", BLACKJACK_DEALER_WAIT, false, "d", tableid);

    if (dealer_score >= 17)
    {
        if (g_blackjackData[tableid][E_GAME_TIMER] != -1)
        {
            KillTimer(g_blackjackData[tableid][E_GAME_TIMER]);
            g_blackjackData[tableid][E_GAME_TIMER] = -1;
        }
        SendClientMessageToBlackjack(tableid, COLOR_GREY, "[BLACKJACK]" COL_WHITE " Round finished. Table will reset in 5 seconds.");
        if (g_blackjackData[tableid][E_RESET_TIMER] != -1)
            KillTimer(g_blackjackData[tableid][E_RESET_TIMER]);
        g_blackjackData[tableid][E_RESET_TIMER] = SetTimerEx("ResetBlackjackTable", 5000, false, "d", tableid);
    }
}

stock GetNextAvailableBlackjackPlayer(tableid, exclude = INVALID_PLAYER_ID)
{
    new playerid = INVALID_PLAYER_ID;

    for (new player_index = 0; player_index < MAX_BLACKJACK_PLAYERS; player_index++)
    {
        if (g_blackjackSlotData[tableid][player_index] != -1 
            && g_blackjackPlayerState[tableid][player_index] == BLACKJACK_STATE_NONE 
            && exclude != g_blackjackSlotData[tableid][player_index] 
            && g_blackjackPlayerCardIndex[tableid][0][player_index] != -1)
        {
            playerid = g_blackjackSlotData[tableid][player_index];
            break;
        }
    }
    return playerid;
}

forward BlackjackPlayerTurn(tableid, playerid, seconds_left);
public BlackjackPlayerTurn(tableid, playerid, seconds_left)
{
    new player_index = GetBlackjackPlayerIndex(tableid, playerid), string[128];

    if (IsPlayerConnected(playerid) 
        && player_index != -1 
        && seconds_left >= 0 
        && g_blackjackPlayerState[tableid][player_index] == BLACKJACK_STATE_TURN)
    {
        format(string, sizeof(string), "%s has %d seconds left", ReturnPlayerRPName(playerid), seconds_left);

        for (new gamerid = 0; gamerid < MAX_PLAYERS; gamerid++)
        {
            if (IsPlayerConnected(gamerid) && p_blackjackTable[gamerid] == tableid)
            {
                TextDrawHideForPlayer(gamerid, g_blackjackTurnTD[tableid]);
                TextDrawSetString(g_blackjackTurnTD[tableid], string);
                TextDrawShowForPlayer(gamerid, g_blackjackTurnTD[tableid]);
            }
        }
        g_blackjackData[tableid][E_GAME_TIMER] = SetTimerEx("BlackjackPlayerTurn", 960, false, "ddd", tableid, playerid, seconds_left - 1);
    }
    else
    {
        new next_player = GetNextAvailableBlackjackPlayer(tableid, playerid);

        if (next_player == INVALID_PLAYER_ID)
        {
            for (new gamerid = 0; gamerid < MAX_PLAYERS; gamerid++)
            {
                if (IsPlayerConnected(gamerid) && p_blackjackTable[gamerid] == tableid)
                {
                    TextDrawHideForPlayer(gamerid, g_blackjackTurnTD[tableid]);
                }
            }
            g_blackjackData[tableid][E_GAME_TIMER] = SetTimerEx("BeginBlackJackTurn", BLACKJACK_DEALER_WAIT, false, "d", tableid);
        }
        else
        {
            new next_player_index = GetBlackjackPlayerIndex(tableid, next_player);

            if (player_index != -1 
                && g_blackjackPlayerState[tableid][player_index] != BLACKJACK_STATE_WIN 
                && g_blackjackPlayerState[tableid][player_index] != BLACKJACK_STATE_BUST)
            {
                g_blackjackPlayerState[tableid][player_index] = BLACKJACK_STATE_STAND;
            }

            g_blackjackPlayerState[tableid][next_player_index] = BLACKJACK_STATE_TURN;
            g_blackjackData[tableid][E_GAME_TIMER] = SetTimerEx("BlackjackPlayerTurn", 960, false, "ddd", tableid, next_player, BLACKJACK_PLAYER_WAIT);
        }
    }
    return 1;
}

forward ResetBlackjackTable(tableid);
public ResetBlackjackTable(tableid)
{
    if (tableid == -1)
        return 0;

    if (tableid < 0 || tableid >= MAX_BLACKJACK_TABLES)
        return 0;

    if (g_blackjackData[tableid][E_RESET_TIMER] != -1)
        KillTimer(g_blackjackData[tableid][E_RESET_TIMER]);
    if (g_blackjackData[tableid][E_GAME_TIMER] != -1)
        KillTimer(g_blackjackData[tableid][E_GAME_TIMER]);
    if (g_blackjackData[tableid][E_DRAW_CARD_TIMER] != -1)
        KillTimer(g_blackjackData[tableid][E_DRAW_CARD_TIMER]);

    g_blackjackData[tableid][E_RESET_TIMER] = -1;
    g_blackjackData[tableid][E_GAME_TIMER] = -1;
    g_blackjackData[tableid][E_DRAW_CARD_TIMER] = -1;
    g_blackjackData[tableid][E_CARDS_DRAWN] = 0;
    SetBlackjackDealerLabelValue(tableid, -1);
    TextDrawHideForAll(g_blackjackTurnTD[tableid]);

    for (new c = 0; c < MAX_BLACKJACK_CARDS; c++)
    {
        g_blackjackDealerCardIndex[tableid][c] = -1;
        TextDrawSetString(g_blackjackDealerCards[tableid][c], "ld_card:cdback");

        for (new p = 0; p < MAX_BLACKJACK_PLAYERS; p++)
        {
            g_blackjackPlayerState[tableid][p] = BLACKJACK_STATE_NONE;
            g_blackjackPlayerCardIndex[tableid][c][p] = -1;
            TextDrawSetString(g_blackjackPlayerCards[tableid][c][p], "ld_card:cdback");
            if (c > 1)
                TextDrawHideForAll(g_blackjackPlayerCards[tableid][c][p]);
        }
    }

    for (new player_index = 0; player_index < MAX_BLACKJACK_PLAYERS; player_index++)
    {
        if (g_blackjackSlotData[tableid][player_index] != -1)
        {
            new gamerid = g_blackjackSlotData[tableid][player_index];
            SetBlackjackPlayerLabelValue(tableid, player_index, 0);

            for (new c = 0; c < MAX_BLACKJACK_CARDS; c++)
            {
                TextDrawShowForPlayer(gamerid, g_blackjackDealerCards[tableid][c]);
                for (new p = 0; p < MAX_BLACKJACK_PLAYERS; p++)
                {
                    if (g_blackjackSlotData[tableid][p] != -1 && c < 2)
                        TextDrawShowForPlayer(gamerid, g_blackjackPlayerCards[tableid][c][p]);
                    else
                        TextDrawHideForPlayer(gamerid, g_blackjackPlayerCards[tableid][c][p]);
                }
            }
        }
        else
        {
            SetBlackjackPlayerLabelValue(tableid, player_index, -1);
        }
    }
    return 1;
}

stock CheckForBlackjack( tableid )
{
    new dealer_score = CalculateDealerHand( tableid );
    SetBlackjackDealerLabelValue( tableid, dealer_score );

    for ( new player_index = 0; player_index < MAX_BLACKJACK_PLAYERS; player_index ++ ) if ( g_blackjackSlotData[ tableid ] [ player_index ] != -1 && g_blackjackPlayerCardIndex[ tableid ] [ 0 ] [ player_index ] != -1 )
    {
        new playerid = g_blackjackSlotData[ tableid ] [ player_index ];
        new player_score = CalculatePlayerHand( tableid, player_index );

        SetBlackjackPlayerLabelValue( tableid, player_index, player_score );

        if (dealer_score < 17 && player_score <= 21)
            continue;

        if ( g_blackjackPlayerState[ tableid ] [ player_index ] != BLACKJACK_STATE_BUST && g_blackjackPlayerState[ tableid ] [ player_index ] != BLACKJACK_STATE_WIN  )
        {
            new player_bet = g_blackjackPlayerBet[ tableid ] [ player_index ];
            new payout = floatround( float( player_bet ) * 2.0 ), string[128];

       		if ( dealer_score == player_score && dealer_score >= 17 ) {
       			payout = player_bet;
                g_blackjackPlayerState[ tableid ] [ player_index ] = BLACKJACK_STATE_WIN;
                SendClientMessageToBlackjack( tableid, COLOR_GREY, "[BLACKJACK]"COL_WHITE" %s(%d) has been returned %s due to a push.", ReturnPlayerRPName( playerid ), playerid, cash_format( payout ) );
		 		format(string, sizeof(string), "~n~~n~~y~%s returned!", cash_format( payout ));
                GameTextForPlayer( playerid, string, 4000, 3 );
                
                GivePlayerCash( playerid, payout );
            }
            else if ( player_score == 21 ) {
                g_blackjackPlayerState[ tableid ] [ player_index ] = BLACKJACK_STATE_WIN;
                if ( IsPlayerHandBlackjack( tableid, player_index, player_score ) ) {
	                payout = floatround( float( player_bet ) * 2.5 );
	                SendClientMessageToBlackjack( tableid, COLOR_GREY, "[BLACKJACK]"COL_WHITE" Blackjack! %s(%d) has won %s!", ReturnPlayerRPName( playerid ), playerid, cash_format( payout ) );
                } else {
	                SendClientMessageToBlackjack( tableid, COLOR_GREY, "[BLACKJACK]"COL_WHITE" %s(%d) has won %s due to a card count of 21!", ReturnPlayerRPName( playerid ), playerid, cash_format( payout ) );
                }
                format(string, sizeof(string), "~n~~n~~g~%s won!", cash_format( payout ));
		 		GameTextForPlayer( playerid, string, 4000, 3 );
                
                GivePlayerCash( playerid, payout );
            }
            else if ( dealer_score == 21 ) {
                g_blackjackPlayerState[ tableid ] [ player_index ] = BLACKJACK_STATE_BUST;
                SendClientMessageToBlackjack( tableid, COLOR_GREY, "[BLACKJACK]"COL_WHITE" %s(%d) has lost %s due to a dealer %s.", ReturnPlayerRPName( playerid ), playerid, cash_format( player_bet ), IsDealerHandBlackjack( tableid, dealer_score ) ? ( "blackjack" ) : ( "21" ) );
		 		GameTextForPlayer( playerid, "~n~~n~~r~No win!", 4000, 3 );
            }
            else if ( player_score > 21 ) {
                g_blackjackPlayerState[ tableid ] [ player_index ] = BLACKJACK_STATE_BUST;
                SendClientMessageToBlackjack( tableid, COLOR_GREY, "[BLACKJACK]"COL_WHITE" %s(%d) has lost %s due to a bust.", ReturnPlayerRPName( playerid ), playerid, cash_format( player_bet ) );
		 		GameTextForPlayer( playerid, "~n~~n~~r~No win!", 4000, 3 );
            }
            else if ( dealer_score > 21 ) {
                g_blackjackPlayerState[ tableid ] [ player_index ] = BLACKJACK_STATE_WIN;
                SendClientMessageToBlackjack( tableid, COLOR_GREY, "[BLACKJACK]"COL_WHITE" %s(%d) has won %s due to a dealer bust.", ReturnPlayerRPName( playerid ), playerid, cash_format( payout ) );
		 		format(string, sizeof(string), "~n~~n~~g~%s won!", cash_format( payout ));
		 		GameTextForPlayer( playerid, string, 4000, 3 );
                
                GivePlayerCash( playerid, payout );
            }
            else if ( player_score < dealer_score && dealer_score >= 17 ) {
                g_blackjackPlayerState[ tableid ] [ player_index ] = BLACKJACK_STATE_BUST;
                SendClientMessageToBlackjack( tableid, COLOR_GREY, "[BLACKJACK]"COL_WHITE" %s(%d) has lost %s due to a dealer hand.", ReturnPlayerRPName( playerid ), playerid, cash_format( player_bet ) );
		 		GameTextForPlayer( playerid, "~n~~n~~r~No win!", 4000, 3 );
            }
            else if ( player_score > dealer_score && dealer_score >= 17 ) {
                g_blackjackPlayerState[ tableid ] [ player_index ] = BLACKJACK_STATE_WIN;
                SendClientMessageToBlackjack( tableid, COLOR_GREY, "[BLACKJACK]"COL_WHITE" %s(%d) has won %s due to a higher card count.", ReturnPlayerRPName( playerid ), playerid, cash_format( payout ) );
		 		format(string, sizeof(string), "~n~~n~~g~%s won!", cash_format( payout ));
		 		GameTextForPlayer( playerid, string, 4000, 3 );
                
                GivePlayerCash( playerid, payout );
            }
        }
    }
    return dealer_score;
}

stock RemovePlayerFromBlackjack(playerid, reset_cam = 0)
{
    if (!(0 <= playerid < MAX_PLAYERS))
        return 0;

    new blackjack_table = p_blackjackTable[playerid];

    if (blackjack_table == -1)
        return 0;

    for (new c = 0; c < MAX_BLACKJACK_CARDS; c++)
    {
        TextDrawHideForPlayer(playerid, g_blackjackDealerCards[blackjack_table][c]);

        for (new p = 0; p < MAX_BLACKJACK_PLAYERS; p++)
        {
            TextDrawHideForPlayer(playerid, g_blackjackPlayerCards[blackjack_table][c][p]);
        }
    }
    TextDrawHideForPlayer(playerid, g_blackjackTurnTD[blackjack_table]);

    new player_index = GetBlackjackPlayerIndex(blackjack_table, playerid);

    if (player_index != -1)
    {
        foreach (new i : Player)
        {
            if (p_blackjackTable[i] == blackjack_table)
            {
                for (new c = 0; c < MAX_BLACKJACK_CARDS; c++)
                {
                    g_blackjackPlayerCardIndex[blackjack_table][c][player_index] = -1;
                    g_blackjackPlayerState[blackjack_table][player_index] = BLACKJACK_STATE_NONE;
                    TextDrawSetString(g_blackjackPlayerCards[blackjack_table][c][player_index], "ld_card:cdback");
                    TextDrawHideForPlayer(i, g_blackjackPlayerCards[blackjack_table][c][player_index]);
                }
            }
        }
        g_blackjackPlayerBet[blackjack_table][player_index] = 0;
        g_blackjackSlotData[blackjack_table][player_index] = -1;
        SetBlackjackPlayerLabelValue(blackjack_table, player_index, -1);
    }

    if (reset_cam)
    {
        TogglePlayerControllable(playerid, true);
        ClearAnimations(playerid, SYNC_ALL);
        SetCameraBehindPlayer(playerid);
    }

    p_blackjackTable[playerid] = -1;
    g_bjSetupChoice[playerid] = -1;

    if (GetBlackjackPlayers(blackjack_table) <= 0)
        ResetBlackjackTable(blackjack_table);

    return 1;
}

stock SendClientMessageToBlackjack(tableid, colour, const format[], va_args<>)
{
    static out[144];
    va_format(out, sizeof(out), format, va_start<3>);

    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (p_blackjackTable[i] == tableid)
        {
            SendClientMessage(i, colour, out);
        }
    }
    return 1;
}

stock InitializeBlackjackTextdraws(id)
{
    g_blackjackTurnTD[id] = TextDrawCreate(330.000000, 204.000000, " Blackjack has 5 seconds");
    TextDrawAlignment(g_blackjackTurnTD[id], TEXT_DRAW_ALIGN_CENTER);
    TextDrawBackgroundColour(g_blackjackTurnTD[id], 255);
    TextDrawFont(g_blackjackTurnTD[id], TEXT_DRAW_FONT_2);
    TextDrawLetterSize(g_blackjackTurnTD[id], 0.260000, 1.200000);
    TextDrawColor(g_blackjackTurnTD[id], 16711935);
    TextDrawSetOutline(g_blackjackTurnTD[id], 1);
    TextDrawSetProportional(g_blackjackTurnTD[id], 1);

    for (new c = 0; c < MAX_BLACKJACK_CARDS; c++)
    {
        g_blackjackDealerCards[id][c] = TextDrawCreate(243.000000 + 35.0 * float(c), 138.000000, "ld_card:cdback");
        TextDrawBackgroundColour(g_blackjackDealerCards[id][c], 255);
        TextDrawFont(g_blackjackDealerCards[id][c], TEXT_DRAW_FONT_SPRITE_DRAW);
        TextDrawLetterSize(g_blackjackDealerCards[id][c], 0.500000, 1.000000);
        TextDrawUseBox(g_blackjackDealerCards[id][c], 1);
        TextDrawBoxColor(g_blackjackDealerCards[id][c], 255);
        TextDrawTextSize(g_blackjackDealerCards[id][c], 30.000000, 51.000000);
    }

    new Float: g_blackjackPlayerPosition[MAX_BLACKJACK_PLAYERS][2] = {{295.0, 334.0}, {205.0, 319.0}, {390.0, 329.0}};

    for (new c = 0; c < MAX_BLACKJACK_CARDS; c++)
    {
        for (new p = 0; p < MAX_BLACKJACK_PLAYERS; p++)
        {
            g_blackjackPlayerCards[id][c][p] = TextDrawCreate(g_blackjackPlayerPosition[p][0] + 10.0 * float(c), g_blackjackPlayerPosition[p][1] - 16.0 * float(c), "ld_card:cdback");
            TextDrawBackgroundColour(g_blackjackPlayerCards[id][c][p], 255);
            TextDrawFont(g_blackjackPlayerCards[id][c][p], TEXT_DRAW_FONT_SPRITE_DRAW);
            TextDrawLetterSize(g_blackjackPlayerCards[id][c][p], 0.5, 0.7);
            TextDrawUseBox(g_blackjackPlayerCards[id][c][p], 1);
            TextDrawBoxColor(g_blackjackPlayerCards[id][c][p], 255);
            TextDrawTextSize(g_blackjackPlayerCards[id][c][p], 22.000000, 37.000000);
        }
    }
}

stock IsPlayerHandBlackjack(tableid, player_index, card_count)
{
    if (card_count != 21)
        return false;

    new first = g_blackjackPlayerCardIndex[tableid][0][player_index];
    new second = g_blackjackPlayerCardIndex[tableid][1][player_index];
    if (first == -1 || second == -1)
        return false;

    new first_rank = first % 13;
    new second_rank = second % 13;
    return ((first_rank == 0 && second_rank >= 9) || (second_rank == 0 && first_rank >= 9));
}

stock IsDealerHandBlackjack(tableid, card_count)
{
    if (card_count != 21)
        return false;

    new first = g_blackjackDealerCardIndex[tableid][0];
    new second = g_blackjackDealerCardIndex[tableid][1];
    if (first == -1 || second == -1)
        return false;

    new first_rank = first % 13;
    new second_rank = second % 13;
    return ((first_rank == 0 && second_rank >= 9) || (second_rank == 0 && first_rank >= 9));
}

stock GetBlackjackCardValue(card_index)
{
    new rank = card_index % 13;
    switch (rank)
    {
        case 0: return 1;          // Ace
        case 1..8: return rank + 1; // 2 - 9
        case 9..12: return 10;      // 10, J, Q, K
    }
    return 0;
}

stock GetBlackjackPlayerIndex(tableid, playerid)
{
    for (new player_index = 0; player_index < MAX_BLACKJACK_PLAYERS; player_index++)
    {
        if (playerid == g_blackjackSlotData[tableid][player_index])
        {
            return player_index;
        }
    }
    return -1;
}

stock GetBlackjackPlayers(tableid)
{
    new count = 0;
    for (new p = 0; p < MAX_BLACKJACK_PLAYERS; p++)
    {
        if (g_blackjackSlotData[tableid][p] != -1)
            count++;
    }
    return count;
}

stock SetBlackjackPlayerLabelValue(tableid, player_index, score)
{
    new string[128];
    if (score != -1)
    {
        new playerid = g_blackjackSlotData[tableid][player_index];
        
        format(string, sizeof(string), "%s\n" COL_GREY "Score:" COL_WHITE " %d\nBet: " COL_GOLD "%s", ReturnPlayerRPName(playerid), score, cash_format(g_blackjackPlayerBet[tableid][player_index]));
        
        UpdateDynamic3DTextLabelText(g_blackjackData[tableid][E_PLAYER_LABEL][player_index], COLOR_GOLD, string);
    }
    else
    {
        format(string, sizeof(string), "Player %d", player_index);
        UpdateDynamic3DTextLabelText(g_blackjackData[tableid][E_PLAYER_LABEL][player_index], 0xFFFFFFFF, string);
    }
    return 1;
}

stock SetBlackjackDealerLabelValue(tableid, score)
{
    new string[128];
    if (score != -1)
    {
        format(string, sizeof(string), "Dealer\nScore:" COL_WHITE " %d", score);
        UpdateDynamic3DTextLabelText(g_blackjackData[tableid][E_DEALER_LABEL], COLOR_GREY, string);
    }
    else
    {
        format(string, sizeof(string),"Press ENTER To Play Blackjack\n" COL_WHITE "%s Minimum", cash_format(g_blackjackData[tableid][E_PAYOUT]));
        UpdateDynamic3DTextLabelText(g_blackjackData[tableid][E_DEALER_LABEL], COLOR_WHITE, string);
    }
}

stock CalculatePlayerHand(tableid, player_index)
{
    new player_score = 0;
    for (new c = 0; c < MAX_BLACKJACK_CARDS; c++)
    {
        if (g_blackjackPlayerCardIndex[tableid][c][player_index] != -1)
        {
            player_score += GetBlackjackCardValue(g_blackjackPlayerCardIndex[tableid][c][player_index]);
        }
    }
    for (new a = 0; a < MAX_BLACKJACK_CARDS; a++)
    {
        if (g_blackjackPlayerCardIndex[tableid][a][player_index] != -1 && GetBlackjackCardValue(g_blackjackPlayerCardIndex[tableid][a][player_index]) == 1)
        {
            if (player_score + 10 <= 21)
                player_score += 10;
            break;
        }
    }
    return player_score;
}

stock CalculateDealerHand(tableid)
{
    new dealer_score = 0;
    for (new c = 0; c < MAX_BLACKJACK_CARDS; c++)
    {
        if (g_blackjackDealerCardIndex[tableid][c] != -1)
        {
            dealer_score += GetBlackjackCardValue(g_blackjackDealerCardIndex[tableid][c]);
        }
    }
    for (new a = 0; a < MAX_BLACKJACK_CARDS; a++)
    {
        if (g_blackjackDealerCardIndex[tableid][a] != -1 && GetBlackjackCardValue(g_blackjackDealerCardIndex[tableid][a]) == 1)
        {
            if (dealer_score + 10 <= 21)
                dealer_score += 10;
            break;
        }
    }
    return dealer_score;
}

CMD:bjbet(playerid, params[])
{
    new blackjack_table = p_blackjackTable[playerid];
    if (blackjack_table == -1)
    {
        return SendClientMessage(playerid, -1, "{FF0000}[ERROR]{FFFFFF} You must be seated at a Blackjack table to use this command.");
    }

    if (g_blackjackData[blackjack_table][E_CARDS_DRAWN] > 0 || g_blackjackData[blackjack_table][E_GAME_TIMER] != -1)
    {
        return SendClientMessage(playerid, -1, "{FF0000}[ERROR]{FFFFFF} The game is already in progress, you cannot change your bet now.");
    }

    new amount;
    if (sscanf(params, "i", amount))
    {
        return SendClientMessage(playerid, -1, "{00FFFF}USAGE:{FFFFFF} /bjbet [amount]");
    }

    if (amount < g_blackjackData[blackjack_table][E_PAYOUT])
    {
        new errmsg[128];
        format(errmsg, sizeof(errmsg), "{FF0000}[ERROR]{FFFFFF} The minimum wager for this table is %s.", cash_format(g_blackjackData[blackjack_table][E_PAYOUT]));
        return SendClientMessage(playerid, -1, errmsg);
    }

    if (PlayerInfo[playerid][pCash] < amount)
    {
        return SendClientMessage(playerid, -1, "{FF0000}[ERROR]{FFFFFF} You do not have enough cash for that amount.");
    }

    new player_index = GetBlackjackPlayerIndex(blackjack_table, playerid);
    if (player_index != -1)
    {
        g_blackjackPlayerBet[blackjack_table][player_index] = amount;
        SetBlackjackPlayerLabelValue(blackjack_table, player_index, 0);
        
        new msg[128];
        format(msg, sizeof(msg), "{00FF00}[BLACKJACK]{FFFFFF} You have adjusted your bet to %s for this round.", cash_format(amount));
        SendClientMessage(playerid, -1, msg);
    }
    return 1;
}

CMD:giveblackjacktable(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 5)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
    }

    new targetid, payout;
    if(sscanf(params, "ui", targetid, payout)) {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /giveblackjacktable [playerid/Name] [payout]");
    }   

    if(!IsPlayerConnected(targetid)) {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Target player is not connected.");
    }

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(targetid, x, y, z);
    GetPlayerFacingAngle(targetid, a);

    x += 1.5 * floatsin(-a, degrees);
    y += 1.5 * floatcos(-a, degrees);

    CreateBlackjackTable(payout, x, y, z, a, GetPlayerVirtualWorld(targetid), 0);

    new string[144];
    format(string, sizeof(string), "ADMCMD: %s created a blackjack table in front of %s(%d).", ReturnPlayerRPName(playerid), ReturnPlayerRPName(targetid), targetid);
    SendAdminMessage(COLOR_RED, string);
    
    SendClientMessage(targetid, -1, "{00FF00}[BLACKJACK]{FFFFFF} An admin has spawned a blackjack table in front of you.");
    return 1;
}

CMD:destroyblackjack(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 5)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
    }

    new Float:table_distance = 99999.99;
    new table = Blackjack_GetClosestTable(playerid, table_distance);

    if (table == -1 || table_distance > 3.5)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not close enough to any blackjack table.");
    }

    for(new i = 0; i < MAX_BLACKJACK_PLAYERS; i++)
    {
        if(g_blackjackSlotData[table][i] != -1)
        {
            RemovePlayerFromBlackjack(g_blackjackSlotData[table][i], .reset_cam = 1);
        }
    }

    new query[128];
    mysql_format(connectionID, query, sizeof(query), "DELETE FROM blackjack_tables WHERE id = %d", g_blackjackData[table][E_ID]);
    mysql_tquery(connectionID, query);

    DestroyDynamicObject(g_blackjackData[table][E_OBJECT]);
    DestroyDynamicActor(g_blackjackData[table][E_ACTOR]);
    DestroyDynamic3DTextLabel(g_blackjackData[table][E_DEALER_LABEL]);
    
    for(new i = 0; i < MAX_BLACKJACK_PLAYERS; i++)
    {
        DestroyDynamic3DTextLabel(g_blackjackData[table][E_PLAYER_LABEL][i]);
    }

    TextDrawDestroy(g_blackjackTurnTD[table]);
    for (new c = 0; c < MAX_BLACKJACK_CARDS; c++)
    {
        TextDrawDestroy(g_blackjackDealerCards[table][c]);
        for (new p = 0; p < MAX_BLACKJACK_PLAYERS; p++)
        {
            TextDrawDestroy(g_blackjackPlayerCards[table][c][p]);
        }
    }

    Iter_Remove(blackjacktables, table);
    SendClientMessage(playerid, -1, "{FF0000}[BLACKJACK]{FFFFFF} Blackjack table has been destroyed and permanently deleted from database.");
    return 1;
}