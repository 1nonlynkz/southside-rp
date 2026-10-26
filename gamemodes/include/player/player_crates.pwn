#include <YSI_Coding\y_hooks>

#define INVALID_TIMER_ID        (-1)

#define CRATE_TIMER_TICKS           (20)
#define CRATE_STORAGE_LIMIT         (999)
#define MAX_REWARDS_PER_CRATE       (9)

#define DIALOG_BUY_CRATES           (5001)
#define DIALOG_BUY_CRATES_AMOUNT    (5002)
#define DIALOG_SELECT_CRATE         (5003)

// Crate Types
#define CRATE_SILVER                (0)
#define CRATE_GOLD                  (1)
#define CRATE_PLATINUM              (2)
#define MAX_CRATE_TYPES             (3)

// Reward Types
#define REWARD_MONEY                (0)
#define REWARD_PREMIUM_POINTS       (1) 
#define REWARD_RESPECT_POINTS       (2) 
#define REWARD_ROB_POINTS           (3) 
#define REWARD_PREMIUM_DAYS         (4) 
#define REWARD_ITEM                 (5)
#define REWARD_WEAPON               (6)
#define REWARD_VEHICLE              (7)

// Crate Opening States
#define CRATE_STATE_NONE            (0)
#define CRATE_STATE_SELECTED        (1)
#define CRATE_STATE_OPENING         (2)
#define CRATE_STATE_REVEAL          (3)
#define CRATE_STATE_COMPLETED       (4)

// TextDraw Indices
#define CRATE_TD_BG                 (0)
#define CRATE_TD_HEADER_LEFT_BEAT   (1)
#define CRATE_TD_HEADER_RIGHT_BEAT  (2)
#define CRATE_TD_TITLE              (3)
#define CRATE_TD_LEFT_BORDER        (4)
#define CRATE_TD_RIGHT_BORDER       (5)
#define CRATE_TD_BOTTOM_LEFT_BEAT   (6)
#define CRATE_TD_BOTTOM_RIGHT_BEAT  (7)
#define CRATE_TD_HEADER_DECOR_LEFT  (8)
#define CRATE_TD_HEADER_DECOR_RIGHT (9)
#define CRATE_TD_OPEN_BUTTON        (10)
#define CRATE_TD_BUTTON_DECOR_LEFT  (11)
#define CRATE_TD_BUTTON_DECOR_RIGHT (12)
#define CRATE_TD_REWARD_PREVIEW     (13)
#define CRATE_TD_REWARD_INFO        (14)
#define TOTAL_CRATE_TEXTDRAWS       (15)

enum E_CRATE_INFO {
    cratePrice,
    crateName[32],
    crateColor[12]
};

enum E_CRATE_REWARD {
    rewardType,            
    rewardWeight,           
    rewardMinAmount,
    rewardMaxAmount,
    rewardModel,
    rewardName[32]
};

enum E_PLAYER_CRATE_DATA {
    pCrateState,
    pCrateSelectedType,
    pCrateTimer,
    pCrateTimeRemaining,
    pCrateRewardIndex,
    pCrateRewardAmount
};

new const CrateData[MAX_CRATE_TYPES][E_CRATE_INFO] = {
    {500,  "Silver Crate",   "045AB6"}, // CRATE_SILVER
    {1000, "Gold Crate",     "F09E05"}, // CRATE_GOLD
    {1500, "Platinum Crate", "610F7D"}  // CRATE_PLATINUM
};

new const CrateRewards[MAX_CRATE_TYPES][MAX_REWARDS_PER_CRATE][E_CRATE_REWARD] = 
{
    // Silver Crate Reward
    {
        { REWARD_WEAPON,  17, 22,  150, 348, "9mm Pistol" },      // 9mm, 150 ammo
        { REWARD_MONEY,   17, 3000, 3000, 1274, "Cash" },          // $3,000
        { REWARD_VEHICLE, 17, 466, 0,    466, "Glendale" },        // Glendale
        { REWARD_WEAPON,  17, 25,  50,   349, "Shotgun" },         // Shotgun, 50 ammo
        { REWARD_MONEY,   16, 1000, 1000, 1274, "Cash" },          // $1,000
        { REWARD_MONEY,   16, 5000, 5000, 1274, "Cash" },          // $5,000
        { REWARD_MONEY,   0, 0,    0,    1274, "" },               // pad
        { REWARD_MONEY,   0, 0,    0,    1274, "" },               // pad
        { REWARD_MONEY,   0, 0,    0,    1274, "" }                // pad
    },
    // Gold Crate Rewards
    {
        { REWARD_MONEY,   11, 10000, 10000, 1274, "Cash" },        // $10,000
        { REWARD_WEAPON,  11, 28,  200,  352, "Uzi" },             // Uzi, 200 ammo
        { REWARD_VEHICLE, 11, 549, 0,    549, "Tampa" },           // Tampa
        { REWARD_VEHICLE, 11, 462, 0,    462, "Faggio" },          // Faggio
        { REWARD_MONEY,   11, 15000, 15000, 1274, "Cash" },        // $15,000
        { REWARD_MONEY,   12, 20000, 20000, 1274, "Cash" },        // $20,000
        { REWARD_VEHICLE, 11, 463, 0,    463, "Freeway" },         // Freeway
        { REWARD_WEAPON,  11, 8,   1,    339, "Katana" },          // Katana
        { REWARD_WEAPON,  11, 24,  100,  348, "Desert Eagle" }     // Deagle, 100 ammo
    },
    // Platinum Crate Rewards
    {
        { REWARD_MONEY,   11, 20000, 20000, 1274, "Cash" },        // $20,000
        { REWARD_VEHICLE, 11, 489, 0,    489, "Rancher" },         // Rancher
        { REWARD_MONEY,   11, 50000, 50000, 1274, "Cash" },        // $50,000
        { REWARD_VEHICLE, 11, 471, 0,    471, "Quad" },            // Quad
        { REWARD_VEHICLE, 11, 581, 0,    581, "BF-400" },          // BF-400
        { REWARD_WEAPON,  12, 26,  50,   349, "Sawn-Off Shotgun" },// Sawn-Off, 50 ammo
        { REWARD_WEAPON,  11, 30,  200,  355, "AK-47" },           // AK-47, 200 ammo
        { REWARD_WEAPON,  11, 32,  200,  372, "Tec-9" },           // Tec-9, 200 ammo
        { REWARD_WEAPON,  11, 22,  150,  348, "9mm Pistol" }       // 9mm, 150 ammo
    }
};

new PlayerCrateData[MAX_PLAYERS][E_PLAYER_CRATE_DATA];
new PlayerText:PlayerCrateTD[MAX_PLAYERS][TOTAL_CRATE_TEXTDRAWS];
new playerSelectedCrateType[MAX_PLAYERS] = {-1, ...};

new crateOpening[MAX_PLAYERS] = {-1, ...};
new crateTime[MAX_PLAYERS];
new playerCrateTimer[MAX_PLAYERS] = {INVALID_TIMER_ID, ...};
new PlayerText:cratesTD[MAX_PLAYERS][TOTAL_CRATE_TEXTDRAWS];

forward Crate_ProcessOpening(playerid);

stock GetTotalPlayerCrates(playerid) {
    if(!IsPlayerConnected(playerid)) return 0;
    return PlayerInfo[playerid][pCrates][CRATE_SILVER] + PlayerInfo[playerid][pCrates][CRATE_GOLD] + PlayerInfo[playerid][pCrates][CRATE_PLATINUM];
}

stock Crate_SaveInventory(playerid) {
    if(!IsPlayerConnected(playerid)) return 0;

    new query[256];
    mysql_format(connectionID, query, sizeof(query), "UPDATE `users` SET `playerCrate1`='%d', `playerCrate2`='%d', `playerCrate3`='%d' WHERE uid = %i", PlayerInfo[playerid][pCrates][CRATE_SILVER], PlayerInfo[playerid][pCrates][CRATE_GOLD], PlayerInfo[playerid][pCrates][CRATE_PLATINUM], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, query, "", "");
    return 1;
}

stock SaveCratesData(playerid) {
    return Crate_SaveInventory(playerid);
}

stock Crate_SaveRewardData(playerid, rType) {
    if(!IsPlayerConnected(playerid)) return 0;

    new query[256];
    switch(rType) {
        case REWARD_PREMIUM_POINTS: {
            mysql_format(connectionID, query, sizeof(query), "UPDATE `users` SET `playerSpecialPoints`='%d' WHERE uid = %i", PlayerInfo[playerid][pSpecialPoints], PlayerInfo[playerid][pID]);
            mysql_tquery(connectionID, query, "", "");
        }
        case REWARD_RESPECT_POINTS: {
            mysql_format(connectionID, query, sizeof(query), "UPDATE `users` SET `playerRP`='%d' WHERE uid = %i", PlayerInfo[playerid][pRP], PlayerInfo[playerid][pID]);
            mysql_tquery(connectionID, query, "", "");
        }
        case REWARD_ROB_POINTS: {
            mysql_format(connectionID, query, sizeof(query), "UPDATE `users` SET `playerRob`='%d' WHERE uid = %i", PlayerInfo[playerid][pRob], PlayerInfo[playerid][pID]);
            mysql_tquery(connectionID, query, "", "");
        }
        case REWARD_PREMIUM_DAYS: {
            mysql_format(connectionID, query, sizeof(query), "UPDATE `users` SET `viptime`='%d' WHERE uid = %i", PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
            mysql_tquery(connectionID, query, "", "");
        }
        default: {}
    }
    return 1;
}

stock Crate_StopTimer(playerid) {
    if(PlayerCrateData[playerid][pCrateTimer] != INVALID_TIMER_ID) {
        KillTimer(PlayerCrateData[playerid][pCrateTimer]);
        PlayerCrateData[playerid][pCrateTimer] = INVALID_TIMER_ID;
    }
    if(playerCrateTimer[playerid] != INVALID_TIMER_ID) {
        KillTimer(playerCrateTimer[playerid]);
        playerCrateTimer[playerid] = INVALID_TIMER_ID;
    }
}

stock StopCrateTimer(playerid) {
    Crate_StopTimer(playerid);
    return 1;
}

stock Crate_ResetPlayerState(playerid) {
    Crate_StopTimer(playerid);
    PlayerCrateData[playerid][pCrateState] = CRATE_STATE_NONE;
    PlayerCrateData[playerid][pCrateSelectedType] = -1;
    PlayerCrateData[playerid][pCrateTimeRemaining] = 0;
    PlayerCrateData[playerid][pCrateRewardIndex] = -1;
    PlayerCrateData[playerid][pCrateRewardAmount] = 0;

    crateOpening[playerid] = -1;
    crateTime[playerid] = 0;
}

stock Crate_ShowUI(playerid) {
    if(!IsPlayerConnected(playerid)) return 0;
    for(new i = 0; i < TOTAL_CRATE_TEXTDRAWS; i++) {
        if(PlayerCrateTD[playerid][i] != PlayerText:INVALID_TEXT_DRAW) {
            PlayerTextDrawShow(playerid, PlayerCrateTD[playerid][i]);
        }
    }
    SelectTextDraw(playerid, 0x15D4EDFF);
    return 1;
}

stock Crate_HideUI(playerid) {
    if(!IsPlayerConnected(playerid)) return 0;
    for(new i = 0; i < TOTAL_CRATE_TEXTDRAWS; i++) {
        if(PlayerCrateTD[playerid][i] != PlayerText:INVALID_TEXT_DRAW) {
            PlayerTextDrawHide(playerid, PlayerCrateTD[playerid][i]);
        }
    }
    CancelSelectTextDraw(playerid);
    return 1;
}

stock HideCrateTextDraws(playerid) {
    return Crate_HideUI(playerid);
}

stock Crate_UpdateRewardPreview(playerid, model, const text[]) {
    if(!IsPlayerConnected(playerid)) return 0;
    PlayerTextDrawSetPreviewModel(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_PREVIEW], model);
    PlayerTextDrawShow(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_PREVIEW]);
    PlayerTextDrawSetString(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_INFO], text);
    return 1;
}

stock Crate_SetOpenButtonState(playerid, bool:enabled) {
    if(!IsPlayerConnected(playerid)) return 0;
    if(enabled) {
        PlayerTextDrawShow(playerid, PlayerCrateTD[playerid][CRATE_TD_OPEN_BUTTON]);
        PlayerTextDrawSetSelectable(playerid, PlayerCrateTD[playerid][CRATE_TD_OPEN_BUTTON], true);
    } else {
        PlayerTextDrawHide(playerid, PlayerCrateTD[playerid][CRATE_TD_OPEN_BUTTON]);
        PlayerTextDrawSetSelectable(playerid, PlayerCrateTD[playerid][CRATE_TD_OPEN_BUTTON], false);
    }
    return 1;
}

stock Crate_CleanupTextDraws(playerid) {
    for(new i = 0; i < TOTAL_CRATE_TEXTDRAWS; i++) {
        if(PlayerCrateTD[playerid][i] != PlayerText:INVALID_TEXT_DRAW) {
            PlayerTextDrawDestroy(playerid, PlayerCrateTD[playerid][i]);
            PlayerCrateTD[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
        }
        cratesTD[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
    }
    return 1;
}

stock Crate_SelectReward(playerid, crateType, &rewardIndex, &rewardAmount) {
    #pragma unused playerid
    if(crateType < 0 || crateType >= MAX_CRATE_TYPES) return 0;

    new totalWeight = 0;
    for(new i = 0; i < MAX_REWARDS_PER_CRATE; i++) {
        totalWeight += CrateRewards[crateType][i][rewardWeight];
    }

    if(totalWeight <= 0) return 0;

    new roll = random(totalWeight);
    new currentWeight = 0;
    rewardIndex = 0;

    for(new i = 0; i < MAX_REWARDS_PER_CRATE; i++) {
        currentWeight += CrateRewards[crateType][i][rewardWeight];
        if(roll < currentWeight) {
            rewardIndex = i;
            break;
        }
    }

    new minAmt = CrateRewards[crateType][rewardIndex][rewardMinAmount];
    new maxAmt = CrateRewards[crateType][rewardIndex][rewardMaxAmount];
    
    if(maxAmt > minAmt) {
        rewardAmount = minAmt + random(maxAmt - minAmt + 1);
    } else {
        rewardAmount = minAmt;
    }
    return 1;
}

stock Crate_GiveReward(playerid, crateType, rewardIndex, amount) {
    if(!IsPlayerConnected(playerid)) return 0;
    if(crateType < 0 || crateType >= MAX_CRATE_TYPES) return 0;
    if(rewardIndex < 0 || rewardIndex >= MAX_REWARDS_PER_CRATE) return 0;

    new rType      = CrateRewards[crateType][rewardIndex][rewardType];
    new rMinAmount = CrateRewards[crateType][rewardIndex][rewardMinAmount];
    new rMaxAmount = CrateRewards[crateType][rewardIndex][rewardMaxAmount];
    new rName[32];
    format(rName, sizeof(rName), "%s", CrateRewards[crateType][rewardIndex][rewardName]);

    new crateColorStr[12], crateNameStr[32];
    format(crateColorStr, sizeof(crateColorStr), "%s", CrateData[crateType][crateColor]);
    format(crateNameStr, sizeof(crateNameStr), "%s", CrateData[crateType][crateName]);

    switch(rType) {
        case REWARD_MONEY: {
            // amount is the actual cash value for money rewards
            GivePlayerMoney(playerid, amount);
            SendMessageToAll(-1, "(( {%s}%s {A9C4E4}- %s won {50DB6F}$%s{A9C4E4}! ))",
                crateColorStr, crateNameStr, GetRPName(playerid), FormatNumber(amount));
        }
        case REWARD_WEAPON: {
            // rMinAmount = weapon ID, rMaxAmount = ammo count
            new weaponId = rMinAmount;
            new ammoAmt  = rMaxAmount;
            GivePlayerWeaponEx(playerid, weaponId, ammoAmt);
            SendMessageToAll(-1, "(( {%s}%s {A9C4E4}- %s won a {50DB6F}%s{A9C4E4}! ))", crateColorStr, crateNameStr, GetRPName(playerid), rName);
        }
        case REWARD_VEHICLE: {
            // rMinAmount = vehicle model ID
            new modelid = rMinAmount;
            new Float:x, Float:y, Float:z, Float:a;
            GetPlayerPos(playerid, x, y, z);
            GetPlayerFacingAngle(playerid, a);
            // Spawn offset slightly beside the player
            new Float:spawnX = x + 2.5 * floatsin(-a, degrees);
            new Float:spawnY = y + 2.5 * floatcos(-a, degrees);
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO vehicles (ownerid, owner, modelid, pos_x, pos_y, pos_z, pos_a, color1, color2) VALUES (%i, '%e', %i, %f, %f, %f, %f, 0, 0)", PlayerInfo[playerid][pID], GetPlayerNameEx(playerid), modelid, spawnX, spawnY, z, a);
            mysql_tquery(connectionID, queryBuffer);
            SendMessageToAll(-1, "(( {%s}%s {A9C4E4}- %s won a {50DB6F}%s{A9C4E4}! ))", crateColorStr, crateNameStr, GetRPName(playerid), rName);
            SendClientMessageEx(playerid, COLOR_GREEN, "[CRATE] Your %s has been added to your vehicles. Use /v to access it.", rName);
        }
    }
    return 1;
}

public Crate_ProcessOpening(playerid) {
    // Validate player connection & opening state
    if(!IsPlayerConnected(playerid) || PlayerCrateData[playerid][pCrateState] != CRATE_STATE_OPENING) {
        Crate_StopTimer(playerid);
        return 0;
    }

    PlayerCrateData[playerid][pCrateTimeRemaining]--;
    new crateType = PlayerCrateData[playerid][pCrateSelectedType];

    // Tick rolling animation: Display random teaser reward models until time reaches 0
    if(PlayerCrateData[playerid][pCrateTimeRemaining] > 0) {
        // Pick a random slot that has actual weight (skip zero-weight pads)
        new displayIndex = random(MAX_REWARDS_PER_CRATE);
        // Make sure we don't show a padded slot — find a valid one
        for(new attempt = 0; attempt < MAX_REWARDS_PER_CRATE; attempt++) {
            if(CrateRewards[crateType][displayIndex][rewardWeight] > 0) break;
            displayIndex = (displayIndex + 1) % MAX_REWARDS_PER_CRATE;
        }

        new model       = CrateRewards[crateType][displayIndex][rewardModel];
        new displayType = CrateRewards[crateType][displayIndex][rewardType];
        new tickerText[128];
        new rName[32];
        format(rName, sizeof(rName), "%s", CrateRewards[crateType][displayIndex][rewardName]);

        switch(displayType) {
            case REWARD_MONEY: {
                new randomMoney = CrateRewards[crateType][displayIndex][rewardMinAmount];
                format(tickerText, sizeof(tickerText), "~w~Rolling...~n~~g~+$%s", FormatNumber(randomMoney));
            }
            case REWARD_WEAPON: {
                format(tickerText, sizeof(tickerText), "~w~Rolling...~n~~y~%s", rName);
            }
            case REWARD_VEHICLE: {
                format(tickerText, sizeof(tickerText), "~w~Rolling...~n~~b~%s", rName);
            }
            default: {
                format(tickerText, sizeof(tickerText), "~w~Rolling...~n~~w~%s", rName);
            }
        }

        Crate_UpdateRewardPreview(playerid, model, tickerText);
        return 1;
    }

    // Timer Finished: Reveal and commit exact pre-determined reward
    Crate_StopTimer(playerid);
    PlayerCrateData[playerid][pCrateState] = CRATE_STATE_REVEAL;

    new winningIdx = PlayerCrateData[playerid][pCrateRewardIndex];
    new winningAmt = PlayerCrateData[playerid][pCrateRewardAmount];
    new finalModel = CrateRewards[crateType][winningIdx][rewardModel];
    new finalType = CrateRewards[crateType][winningIdx][rewardType];
    new finalText[128];

    new finalName[32];
    format(finalName, sizeof(finalName), "%s", CrateRewards[crateType][winningIdx][rewardName]);

    switch(finalType) {
        case REWARD_MONEY: {
            format(finalText, sizeof(finalText), "~g~WON!~n~~w~$%s Cash", FormatNumber(winningAmt));
        }
        case REWARD_WEAPON: {
            format(finalText, sizeof(finalText), "~y~WON!~n~~w~%s", finalName);
        }
        case REWARD_VEHICLE: {
            format(finalText, sizeof(finalText), "~b~WON!~n~~w~%s", finalName);
        }
        default: {
            format(finalText, sizeof(finalText), "~w~WON!~n~~w~%s", finalName);
        }
    }

    Crate_UpdateRewardPreview(playerid, finalModel, finalText);
    Crate_GiveReward(playerid, crateType, winningIdx, winningAmt);

    PlayerCrateData[playerid][pCrateState] = CRATE_STATE_COMPLETED;
    
    // Clean reset after completion
    Crate_ResetPlayerState(playerid);
    Crate_HideUI(playerid);
    return 1;
}

forward giveCratePrize(playerid);
public giveCratePrize(playerid) {
    return Crate_ProcessOpening(playerid);
}

hook OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) {
    if(playertextid == PlayerCrateTD[playerid][CRATE_TD_OPEN_BUTTON] || playertextid == cratesTD[playerid][CRATE_TD_OPEN_BUTTON]) {
        // Validate state safety
        if(PlayerCrateData[playerid][pCrateState] != CRATE_STATE_SELECTED && crateOpening[playerid] == -1) {
            SendErrorMessage(playerid, "You cannot open a crate at this time.");
            return 1;
        }

        new crateType = PlayerCrateData[playerid][pCrateSelectedType];
        if(crateType == -1) crateType = crateOpening[playerid];

        if(crateType < 0 || crateType >= MAX_CRATE_TYPES) {
            SendErrorMessage(playerid, "Invalid crate selection.");
            Crate_ResetPlayerState(playerid);
            Crate_HideUI(playerid);
            return 1;
        }

        // Validate crate ownership
        if(PlayerInfo[playerid][pCrates][crateType] < 1) {
            SendErrorMessage(playerid, "You don't have any %s crates left to open.", CrateData[crateType][crateName]);
            Crate_ResetPlayerState(playerid);
            Crate_HideUI(playerid);
            return 1;
        }

        // Safe Transaction: Deduct item immediately to prevent dupe exploits
        PlayerInfo[playerid][pCrates][crateType]--;
        Crate_SaveInventory(playerid);

        // Pre-determine final reward ONCE at start of transaction
        new winningIndex, winningAmount;
        Crate_SelectReward(playerid, crateType, winningIndex, winningAmount);
        
        PlayerCrateData[playerid][pCrateRewardIndex] = winningIndex;
        PlayerCrateData[playerid][pCrateRewardAmount] = winningAmount;
        PlayerCrateData[playerid][pCrateSelectedType] = crateType;

        // Lock opening state and disable button
        PlayerCrateData[playerid][pCrateState] = CRATE_STATE_OPENING;
        PlayerCrateData[playerid][pCrateTimeRemaining] = CRATE_TIMER_TICKS;
        crateOpening[playerid] = crateType;
        crateTime[playerid] = CRATE_TIMER_TICKS;

        Crate_SetOpenButtonState(playerid, false);

        // Start processing timer
        Crate_StopTimer(playerid);
        PlayerCrateData[playerid][pCrateTimer] = SetTimerEx("Crate_ProcessOpening", 250, true, "i", playerid);
        playerCrateTimer[playerid] = PlayerCrateData[playerid][pCrateTimer];
        return 1;
    }
    return 0;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) 
{
    switch(dialogid) 
    {
        case DIALOG_SELECT_CRATE: 
        {
            if(!response) {
                Crate_ResetPlayerState(playerid);
                return 1;
            }

            if(listitem < 0 || listitem >= MAX_CRATE_TYPES) {
                SendErrorMessage(playerid, "Invalid crate selection.");
                return 1;
            }

            if(PlayerInfo[playerid][pCrates][listitem] < 1) {
                return SendErrorMessage(playerid, "You do not own any %s crates.", CrateData[listitem][crateName]);
            }
            PlayerCrateData[playerid][pCrateState] = CRATE_STATE_SELECTED;
            PlayerCrateData[playerid][pCrateSelectedType] = listitem;
            crateOpening[playerid] = listitem;

            new infoStr[128];
            format(infoStr, sizeof(infoStr), "~y~%s~n~~w~Ready to open.~n~Click ~g~Start Opening", CrateData[listitem][crateName]);
            
            Crate_ShowUI(playerid);
            Crate_SetOpenButtonState(playerid, true);
            Crate_UpdateRewardPreview(playerid, CrateRewards[listitem][0][rewardModel], infoStr);
            return 1;
        }

        case DIALOG_BUY_CRATES: {
            if(!response) {
                playerSelectedCrateType[playerid] = -1;
                return 1;
            }

            if(listitem < 0 || listitem >= MAX_CRATE_TYPES) {
                SendErrorMessage(playerid, "Invalid crate selection.");
                return 1;
            }

            playerSelectedCrateType[playerid] = listitem;

            new dialogText[256];
            format(dialogText, sizeof(dialogText), "{FFFFFF}Select amount of {%s}%s{FFFFFF} to purchase.\nCost per unit: {00FF00}$%s\n\nEnter desired quantity:", CrateData[listitem][crateColor], CrateData[listitem][crateName], FormatNumber(CrateData[listitem][cratePrice]));

            ShowPlayerDialog(playerid, DIALOG_BUY_CRATES_AMOUNT, DIALOG_STYLE_INPUT, "Purchase Crates - Amount", dialogText, "Buy", "Cancel");
            return 1;
        }

        case DIALOG_BUY_CRATES_AMOUNT: {
            if(!response) {
                playerSelectedCrateType[playerid] = -1;
                return 1;
            }

            new amount = strval(inputtext);
            new crateTypeId = playerSelectedCrateType[playerid];

            if(crateTypeId < 0 || crateTypeId >= MAX_CRATE_TYPES) {
                playerSelectedCrateType[playerid] = -1;
                return SendErrorMessage(playerid, "Invalid crate selection.");
            }

            if(amount < 1 || amount > 100) {
                playerSelectedCrateType[playerid] = -1;
                return SendErrorMessage(playerid, "Invalid quantity specified (Range: 1 - 100).");
            }

            // Storage capacity check
            if(GetTotalPlayerCrates(playerid) + amount > CRATE_STORAGE_LIMIT) {
                playerSelectedCrateType[playerid] = -1;
                return SendErrorMessage(playerid, "You cannot carry this many crates! Limit: %d crates.", CRATE_STORAGE_LIMIT);
            }

            // Price calculation & overflow safety
            new unitPrice = CrateData[crateTypeId][cratePrice];
            new totalCost = unitPrice * amount;

            if(totalCost < 0 || (amount > 0 && totalCost / amount != unitPrice)) {
                playerSelectedCrateType[playerid] = -1;
                return SendErrorMessage(playerid, "Invalid purchase amount (Calculation overflow).");
            }

            if(GetPlayerMoney(playerid) < totalCost) {
                playerSelectedCrateType[playerid] = -1;
                return SendErrorMessage(playerid, "Insufficient funds. Total cost: $%s", FormatNumber(totalCost));
            }
            GivePlayerMoney(playerid, -totalCost);
            PlayerInfo[playerid][pCrates][crateTypeId] += amount;
            Crate_SaveInventory(playerid);

            //Inventory_Add(playerid, "Crates", 1930, amount);
            SendClientMessageEx(playerid, COLOR_GREEN, "Purchased %d %s crate(s) for $%s.", amount, CrateData[crateTypeId][crateName], FormatNumber(totalCost));

            playerSelectedCrateType[playerid] = -1;
            return 1;
        }
    }
    return 0;
}

CMD:opencrates(playerid, params[]) {
    if(PlayerCrateData[playerid][pCrateState] == CRATE_STATE_OPENING || crateTime[playerid] > 0) {
        return SendErrorMessage(playerid, "You are currently opening a crate.");
    }

    if(GetTotalPlayerCrates(playerid) < 1) {
        return SendErrorMessage(playerid, "You don't have any crates in your inventory.");
    }

    new dialogStr[512];
    // Modernized headers with muted colors for contrast
    format(dialogStr, sizeof(dialogStr), "{AFAFAF}Crate Type\t{AFAFAF}In Stock\n");
    for(new i = 0; i < MAX_CRATE_TYPES; i++) {
        new temp[128], count = PlayerInfo[playerid][pCrates][i];
        if(count > 0) {
            // Bright green status for available items
            format(temp, sizeof(temp), "{%s}%s\t{2ECC71}%d Available\n", CrateData[i][crateColor], CrateData[i][crateName], count);
        } else {
            // Dimmed out items for zero stock
            format(temp, sizeof(temp), "{%s}%s\t{888888}0 Owned\n", CrateData[i][crateColor], CrateData[i][crateName]);
        }
        strcat(dialogStr, temp);
    }

    ShowPlayerDialog(playerid, DIALOG_SELECT_CRATE, DIALOG_STYLE_TABLIST_HEADERS, "{FF9900}>> {FFFFFF}Select Crate", dialogStr, "Open", "Close");
    return 1;
}

CMD:buycrates(playerid, params[]) {
    new totalCrates = GetTotalPlayerCrates(playerid);
    if(totalCrates >= CRATE_STORAGE_LIMIT) {
        return SendErrorMessage(playerid, "Your crate storage is full (%d/%d).", totalCrates, CRATE_STORAGE_LIMIT);
    }

    new dialogText[600];
    format(dialogText, sizeof(dialogText), "{AFAFAF}Crate Item\t{AFAFAF}Price per Crate\n");

    for(new i = 0; i < MAX_CRATE_TYPES; i++) {
        new temp[128];
        format(temp, sizeof(temp), "{%s}%s\t{2ECC71}$%s\n", CrateData[i][crateColor], CrateData[i][crateName], FormatNumber(CrateData[i][cratePrice]));
        strcat(dialogText, temp);
    }

    new dialogTitle[64];
    format(dialogTitle, sizeof(dialogTitle), "{00E5FF}Crate Store {AAAAAA}(Storage: %d/%d)", totalCrates, CRATE_STORAGE_LIMIT);
    ShowPlayerDialog(playerid, DIALOG_BUY_CRATES, DIALOG_STYLE_TABLIST_HEADERS, dialogTitle, dialogText, "Purchase", "Cancel");
    return 1;
}
CMD:givecrates(playerid, const params[])
{
	new targetid, amount, crateType;

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "uii", targetid, amount, crateType))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givecrates [playerid] [amount] [type(0=Silver, 1=Gold, 2=Platinum)]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}
    if(crateType < 0 || crateType > 2)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid crate type. Use 0 for Silver, 1 for Gold, 2 for Platinum.");
    }
    if(amount < 1 || amount > 100)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid amount. Use between 1 and 100.");
    }

	PlayerInfo[targetid][pCrates][crateType] += amount;
    SaveCratesData(targetid);
    
    new crateNameStr[32];
    switch(crateType)
    {
        case 0: format(crateNameStr, sizeof(crateNameStr), "Silver");
        case 1: format(crateNameStr, sizeof(crateNameStr), "Gold");
        case 2: format(crateNameStr, sizeof(crateNameStr), "Platinum");
    }

	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %i %s crate(s) to %s.", GetRPName(playerid), amount, crateNameStr, GetRPName(targetid));
	Log_Write("log_admin", "%s (uid: %i) has used /givecrates to give %i %s crate(s) to %s (uid: %i).", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], amount, crateNameStr, GetPlayerNameEx(targetid), PlayerInfo[targetid][pID]);
    SendClientMessageEx(targetid, COLOR_GREEN, "Admin %s has given you %i %s crate(s).", GetRPName(playerid), amount, crateNameStr);

	return 1;
}

CMD:givecratesall(playerid, const params[])
{
	new amount, crateType;

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "ii", amount, crateType))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /givecratesall [amount] [type(0=Silver, 1=Gold, 2=Platinum)]");
	}
    if(crateType < 0 || crateType > 2)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid crate type. Use 0 for Silver, 1 for Gold, 2 for Platinum.");
    }
    if(amount < 1 || amount > 100)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Invalid amount. Use between 1 and 100.");
    }
    new crateNameStr[32];
    switch(crateType)
    {
        case 0: format(crateNameStr, sizeof(crateNameStr), "Silver");
        case 1: format(crateNameStr, sizeof(crateNameStr), "Gold");
        case 2: format(crateNameStr, sizeof(crateNameStr), "Platinum");
    }
    foreach(new i : Player)
    {
        if(PlayerInfo[i][pLogged])
        {
            PlayerInfo[i][pCrates][crateType] += amount;
            SaveCratesData(i);
            SendClientMessageEx(i, COLOR_GREEN, "Admin %s has given everyone %i %s crate(s).", GetRPName(playerid), amount, crateNameStr);
        }
    }
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has given %i %s crate(s) to all online players.", GetRPName(playerid), amount, crateNameStr);
	Log_Write("log_admin", "%s (uid: %i) has used /givecratesall to give %i %s crate(s) to all players.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], amount, crateNameStr);
	return 1;
}

CMD:checkcrates(playerid, const params[])
{
    new targetid;

    if(PlayerInfo[playerid][pAdmin] < 3)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
    }
    if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
    }
    if(sscanf(params, "u", targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /checkcrates [playerid]");
    }
    if(!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
    }
    if(!PlayerInfo[targetid][pLogged])
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
    }
    new dialogStr[512], dialogTitle[64];
    format(dialogStr, sizeof(dialogStr), "{AFAFAF}Crate Type\t{AFAFAF}Quantity\n");
    for(new i = 0; i < MAX_CRATE_TYPES; i++) 
    {
        new temp[128], count = PlayerInfo[targetid][pCrates][i];
        if(count > 0) {
            format(temp, sizeof(temp), "{%s}%s\t{2ECC71}%d Units\n", CrateData[i][crateColor], CrateData[i][crateName], count);
        } 
        else {
            format(temp, sizeof(temp), "{%s}%s\t{888888}0 Units\n", CrateData[i][crateColor], CrateData[i][crateName]);
        }
        strcat(dialogStr, temp);
    }
    format(dialogTitle, sizeof(dialogTitle), "{FF9900}Admin: {FFFFFF}%s's Crates (ID: %d)", GetRPName(targetid), targetid);
    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, dialogTitle, dialogStr, "Close", "");
    return 1;
}

CMD:clearcrates(playerid, const params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 5)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /clearcrates [playerid]");
	}
	if(!IsPlayerConnected(targetid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	}
	if(!PlayerInfo[targetid][pLogged])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	}

    PlayerInfo[targetid][pCrates][0] = 0;
    PlayerInfo[targetid][pCrates][1] = 0;
    PlayerInfo[targetid][pCrates][2] = 0;
    SaveCratesData(targetid);
    
	SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s has cleared all crates from %s.", GetRPName(playerid), GetRPName(targetid));
	Log_Write("log_admin", "%s (uid: %i) has used /clearcrates to clear %s's (uid: %i) crates.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID]);
    SendClientMessageEx(targetid, COLOR_YELLOW, "Admin %s has cleared all your crates.", GetRPName(playerid));
	return 1;
}
hook OnPlayerDisconnect(playerid, reason) 
{
    Crate_SaveInventory(playerid);
    Crate_ResetPlayerState(playerid);
    playerSelectedCrateType[playerid] = -1;
    Crate_CleanupTextDraws(playerid);
    return 1;
}


hook OnPlayerConnect(playerid) {
    Crate_ResetPlayerState(playerid);
    playerSelectedCrateType[playerid] = -1;

    // Allocate & initialize player TextDraw components preserving visual layout
    PlayerCrateTD[playerid][CRATE_TD_BG] = CreatePlayerTextDraw(playerid, 263.000030, 162.504272, "box");
    PlayerTextDrawLetterSize(playerid, PlayerCrateTD[playerid][CRATE_TD_BG], 0.000000, 16.900501);
    PlayerTextDrawTextSize(playerid, PlayerCrateTD[playerid][CRATE_TD_BG], 381.500030, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerCrateTD[playerid][CRATE_TD_BG], t_TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColor(playerid, PlayerCrateTD[playerid][CRATE_TD_BG], -1);
    PlayerTextDrawUseBox(playerid, PlayerCrateTD[playerid][CRATE_TD_BG], 1);
    PlayerTextDrawBoxColor(playerid, PlayerCrateTD[playerid][CRATE_TD_BG], 505290440);
    PlayerTextDrawSetShadow(playerid, PlayerCrateTD[playerid][CRATE_TD_BG], 0);
    PlayerTextDrawSetOutline(playerid, PlayerCrateTD[playerid][CRATE_TD_BG], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerCrateTD[playerid][CRATE_TD_BG], 255);
    PlayerTextDrawFont(playerid, PlayerCrateTD[playerid][CRATE_TD_BG], t_TEXT_DRAW_FONT:1);
    PlayerTextDrawSetProportional(playerid, PlayerCrateTD[playerid][CRATE_TD_BG], 1);

    PlayerCrateTD[playerid][CRATE_TD_HEADER_LEFT_BEAT] = CreatePlayerTextDraw(playerid, 255.500213, 158.782180, "ld_beat:chit");
    PlayerTextDrawLetterSize(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_LEFT_BEAT], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_LEFT_BEAT], 12.000000, 12.000000);
    PlayerTextDrawAlignment(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_LEFT_BEAT], t_TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColor(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_LEFT_BEAT], 505290440);
    PlayerTextDrawBackgroundColor(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_LEFT_BEAT], 255);
    PlayerTextDrawFont(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_LEFT_BEAT], t_TEXT_DRAW_FONT:4);

    PlayerCrateTD[playerid][CRATE_TD_HEADER_RIGHT_BEAT] = CreatePlayerTextDraw(playerid, 376.807647, 158.482162, "ld_beat:chit");
    PlayerTextDrawLetterSize(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_RIGHT_BEAT], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_RIGHT_BEAT], 12.000000, 12.000000);
    PlayerTextDrawAlignment(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_RIGHT_BEAT], t_TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColor(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_RIGHT_BEAT], 505290440);
    PlayerTextDrawBackgroundColor(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_RIGHT_BEAT], 255);
    PlayerTextDrawFont(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_RIGHT_BEAT], t_TEXT_DRAW_FONT:4);

    PlayerCrateTD[playerid][CRATE_TD_TITLE] = CreatePlayerTextDraw(playerid, 320.000061, 153.968948, "Crates");
    PlayerTextDrawLetterSize(playerid, PlayerCrateTD[playerid][CRATE_TD_TITLE], 0.393999, 1.281419);
    PlayerTextDrawTextSize(playerid, PlayerCrateTD[playerid][CRATE_TD_TITLE], 10.000000, 40.000000);
    PlayerTextDrawAlignment(playerid, PlayerCrateTD[playerid][CRATE_TD_TITLE], t_TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColor(playerid, PlayerCrateTD[playerid][CRATE_TD_TITLE], -1);
    PlayerTextDrawUseBox(playerid, PlayerCrateTD[playerid][CRATE_TD_TITLE], 1);
    PlayerTextDrawBoxColor(playerid, PlayerCrateTD[playerid][CRATE_TD_TITLE], 255);
    PlayerTextDrawBackgroundColor(playerid, PlayerCrateTD[playerid][CRATE_TD_TITLE], 255);
    PlayerTextDrawFont(playerid, PlayerCrateTD[playerid][CRATE_TD_TITLE], t_TEXT_DRAW_FONT:3);
    PlayerTextDrawSetProportional(playerid, PlayerCrateTD[playerid][CRATE_TD_TITLE], 1);

    PlayerCrateTD[playerid][CRATE_TD_LEFT_BORDER] = CreatePlayerTextDraw(playerid, 259.100280, 167.995559, "box");
    PlayerTextDrawLetterSize(playerid, PlayerCrateTD[playerid][CRATE_TD_LEFT_BORDER], 0.000000, 15.839994);
    PlayerTextDrawTextSize(playerid, PlayerCrateTD[playerid][CRATE_TD_LEFT_BORDER], 259.838684, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerCrateTD[playerid][CRATE_TD_LEFT_BORDER], t_TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColor(playerid, PlayerCrateTD[playerid][CRATE_TD_LEFT_BORDER], -1);
    PlayerTextDrawUseBox(playerid, PlayerCrateTD[playerid][CRATE_TD_LEFT_BORDER], 1);
    PlayerTextDrawBoxColor(playerid, PlayerCrateTD[playerid][CRATE_TD_LEFT_BORDER], 505290440);
    PlayerTextDrawBackgroundColor(playerid, PlayerCrateTD[playerid][CRATE_TD_LEFT_BORDER], 255);
    PlayerTextDrawFont(playerid, PlayerCrateTD[playerid][CRATE_TD_LEFT_BORDER], t_TEXT_DRAW_FONT:1);

    PlayerCrateTD[playerid][CRATE_TD_RIGHT_BORDER] = CreatePlayerTextDraw(playerid, 384.500244, 167.497787, "box");
    PlayerTextDrawLetterSize(playerid, PlayerCrateTD[playerid][CRATE_TD_RIGHT_BORDER], 0.000000, 15.919994);
    PlayerTextDrawTextSize(playerid, PlayerCrateTD[playerid][CRATE_TD_RIGHT_BORDER], 385.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerCrateTD[playerid][CRATE_TD_RIGHT_BORDER], t_TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColor(playerid, PlayerCrateTD[playerid][CRATE_TD_RIGHT_BORDER], -1);
    PlayerTextDrawUseBox(playerid, PlayerCrateTD[playerid][CRATE_TD_RIGHT_BORDER], 1);
    PlayerTextDrawBoxColor(playerid, PlayerCrateTD[playerid][CRATE_TD_RIGHT_BORDER], 505290440);
    PlayerTextDrawBackgroundColor(playerid, PlayerCrateTD[playerid][CRATE_TD_RIGHT_BORDER], 255);
    PlayerTextDrawFont(playerid, PlayerCrateTD[playerid][CRATE_TD_RIGHT_BORDER], t_TEXT_DRAW_FONT:1);

    PlayerCrateTD[playerid][CRATE_TD_BOTTOM_LEFT_BEAT] = CreatePlayerTextDraw(playerid, 255.500061, 306.622131, "ld_beat:chit");
    PlayerTextDrawLetterSize(playerid, PlayerCrateTD[playerid][CRATE_TD_BOTTOM_LEFT_BEAT], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, PlayerCrateTD[playerid][CRATE_TD_BOTTOM_LEFT_BEAT], 12.000000, 12.000000);
    PlayerTextDrawAlignment(playerid, PlayerCrateTD[playerid][CRATE_TD_BOTTOM_LEFT_BEAT], t_TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColor(playerid, PlayerCrateTD[playerid][CRATE_TD_BOTTOM_LEFT_BEAT], 505290440);
    PlayerTextDrawBackgroundColor(playerid, PlayerCrateTD[playerid][CRATE_TD_BOTTOM_LEFT_BEAT], 255);
    PlayerTextDrawFont(playerid, PlayerCrateTD[playerid][CRATE_TD_BOTTOM_LEFT_BEAT], t_TEXT_DRAW_FONT:4);

    PlayerCrateTD[playerid][CRATE_TD_BOTTOM_RIGHT_BEAT] = CreatePlayerTextDraw(playerid, 376.700103, 307.024261, "ld_beat:chit");
    PlayerTextDrawLetterSize(playerid, PlayerCrateTD[playerid][CRATE_TD_BOTTOM_RIGHT_BEAT], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, PlayerCrateTD[playerid][CRATE_TD_BOTTOM_RIGHT_BEAT], 12.000000, 12.000000);
    PlayerTextDrawAlignment(playerid, PlayerCrateTD[playerid][CRATE_TD_BOTTOM_RIGHT_BEAT], t_TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColor(playerid, PlayerCrateTD[playerid][CRATE_TD_BOTTOM_RIGHT_BEAT], 505290440);
    PlayerTextDrawBackgroundColor(playerid, PlayerCrateTD[playerid][CRATE_TD_BOTTOM_RIGHT_BEAT], 255);
    PlayerTextDrawFont(playerid, PlayerCrateTD[playerid][CRATE_TD_BOTTOM_RIGHT_BEAT], t_TEXT_DRAW_FONT:4);

    PlayerCrateTD[playerid][CRATE_TD_HEADER_DECOR_LEFT] = CreatePlayerTextDraw(playerid, 286.399932, 148.326675, "ld_beat:chit");
    PlayerTextDrawLetterSize(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_DECOR_LEFT], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_DECOR_LEFT], 23.000000, 23.000000);
    PlayerTextDrawAlignment(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_DECOR_LEFT], t_TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColor(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_DECOR_LEFT], 255);
    PlayerTextDrawBackgroundColor(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_DECOR_LEFT], 255);
    PlayerTextDrawFont(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_DECOR_LEFT], t_TEXT_DRAW_FONT:4);

    PlayerCrateTD[playerid][CRATE_TD_HEADER_DECOR_RIGHT] = CreatePlayerTextDraw(playerid, 330.902648, 148.326675, "ld_beat:chit");
    PlayerTextDrawLetterSize(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_DECOR_RIGHT], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_DECOR_RIGHT], 23.000000, 23.000000);
    PlayerTextDrawAlignment(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_DECOR_RIGHT], t_TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColor(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_DECOR_RIGHT], 255);
    PlayerTextDrawBackgroundColor(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_DECOR_RIGHT], 255);
    PlayerTextDrawFont(playerid, PlayerCrateTD[playerid][CRATE_TD_HEADER_DECOR_RIGHT], t_TEXT_DRAW_FONT:4);

    PlayerCrateTD[playerid][CRATE_TD_OPEN_BUTTON] = CreatePlayerTextDraw(playerid, 322.800018, 312.053375, "start opening");
    PlayerTextDrawLetterSize(playerid, PlayerCrateTD[playerid][CRATE_TD_OPEN_BUTTON], 0.328866, 1.020916);
    PlayerTextDrawTextSize(playerid, PlayerCrateTD[playerid][CRATE_TD_OPEN_BUTTON], 10.000000, 78.000000);
    PlayerTextDrawAlignment(playerid, PlayerCrateTD[playerid][CRATE_TD_OPEN_BUTTON], t_TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColor(playerid, PlayerCrateTD[playerid][CRATE_TD_OPEN_BUTTON], -1);
    PlayerTextDrawUseBox(playerid, PlayerCrateTD[playerid][CRATE_TD_OPEN_BUTTON], 1);
    PlayerTextDrawBoxColor(playerid, PlayerCrateTD[playerid][CRATE_TD_OPEN_BUTTON], 8388863);
    PlayerTextDrawBackgroundColor(playerid, PlayerCrateTD[playerid][CRATE_TD_OPEN_BUTTON], 255);
    PlayerTextDrawFont(playerid, PlayerCrateTD[playerid][CRATE_TD_OPEN_BUTTON], t_TEXT_DRAW_FONT:3);
    PlayerTextDrawSetProportional(playerid, PlayerCrateTD[playerid][CRATE_TD_OPEN_BUTTON], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerCrateTD[playerid][CRATE_TD_OPEN_BUTTON], true);

    PlayerCrateTD[playerid][CRATE_TD_BUTTON_DECOR_LEFT] = CreatePlayerTextDraw(playerid, 273.800018, 306.617675, "ld_beat:chit");
    PlayerTextDrawLetterSize(playerid, PlayerCrateTD[playerid][CRATE_TD_BUTTON_DECOR_LEFT], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, PlayerCrateTD[playerid][CRATE_TD_BUTTON_DECOR_LEFT], 19.000000, 19.869997);
    PlayerTextDrawAlignment(playerid, PlayerCrateTD[playerid][CRATE_TD_BUTTON_DECOR_LEFT], t_TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColor(playerid, PlayerCrateTD[playerid][CRATE_TD_BUTTON_DECOR_LEFT], 8388863);
    PlayerTextDrawBackgroundColor(playerid, PlayerCrateTD[playerid][CRATE_TD_BUTTON_DECOR_LEFT], 255);
    PlayerTextDrawFont(playerid, PlayerCrateTD[playerid][CRATE_TD_BUTTON_DECOR_LEFT], t_TEXT_DRAW_FONT:4);

    PlayerCrateTD[playerid][CRATE_TD_BUTTON_DECOR_RIGHT] = CreatePlayerTextDraw(playerid, 352.899963, 306.620025, "ld_beat:chit");
    PlayerTextDrawLetterSize(playerid, PlayerCrateTD[playerid][CRATE_TD_BUTTON_DECOR_RIGHT], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, PlayerCrateTD[playerid][CRATE_TD_BUTTON_DECOR_RIGHT], 19.000000, 19.869997);
    PlayerTextDrawAlignment(playerid, PlayerCrateTD[playerid][CRATE_TD_BUTTON_DECOR_RIGHT], t_TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColor(playerid, PlayerCrateTD[playerid][CRATE_TD_BUTTON_DECOR_RIGHT], 8388863);
    PlayerTextDrawBackgroundColor(playerid, PlayerCrateTD[playerid][CRATE_TD_BUTTON_DECOR_RIGHT], 255);
    PlayerTextDrawFont(playerid, PlayerCrateTD[playerid][CRATE_TD_BUTTON_DECOR_RIGHT], t_TEXT_DRAW_FONT:4);

    PlayerCrateTD[playerid][CRATE_TD_REWARD_PREVIEW] = CreatePlayerTextDraw(playerid, 260.600067, 168.937713, "");
    PlayerTextDrawLetterSize(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_PREVIEW], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_PREVIEW], 123.000000, 92.000000);
    PlayerTextDrawAlignment(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_PREVIEW], t_TEXT_DRAW_ALIGN:1);
    PlayerTextDrawColor(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_PREVIEW], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_PREVIEW], 168430335);
    PlayerTextDrawFont(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_PREVIEW], t_TEXT_DRAW_FONT:5);
    PlayerTextDrawSetPreviewModel(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_PREVIEW], 1274);
    PlayerTextDrawSetPreviewRot(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_PREVIEW], -20.000000, 0.000000, 0.000000, 1.000000);

    PlayerCrateTD[playerid][CRATE_TD_REWARD_INFO] = CreatePlayerTextDraw(playerid, 321.600006, 271.826446, "you selected a crate");
    PlayerTextDrawLetterSize(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_INFO], 0.307998, 1.122132);
    PlayerTextDrawAlignment(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_INFO], t_TEXT_DRAW_ALIGN:2);
    PlayerTextDrawColor(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_INFO], -1);
    PlayerTextDrawSetOutline(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_INFO], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_INFO], 255);
    PlayerTextDrawFont(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_INFO], t_TEXT_DRAW_FONT:3);
    PlayerTextDrawSetProportional(playerid, PlayerCrateTD[playerid][CRATE_TD_REWARD_INFO], 1);

    // Sync legacy textdraw array references
    for(new i = 0; i < TOTAL_CRATE_TEXTDRAWS; i++) {
        cratesTD[playerid][i] = PlayerCrateTD[playerid][i];
    }
    return 1;
}