// Define
#define MAX_CONTACTS 20

CMD:phone(playerid)
{
    new title[32];
	if(!PlayerInfo[playerid][pPhone])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You don't have a cellphone and therefore can't use this command.");
	}
	if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are unable to use your cellphone at the moment.");
	}
    format(title, sizeof(title), "My Phone (#%i)", PlayerInfo[playerid][pPhone]);
    Dialog_Show(playerid, Phone, DIALOG_STYLE_TABLIST, title, "Dial Number\nMy Contacts\nUnread Text Messages\n%s", "Select", "Close", (PlayerInfo[playerid][pTogglePhone]== 1) ? (""GREEN"Turn on Phone") : (""RED"Turn off Phone"));
	return 1;
}

Dialog:Phone(playerid, response, listitem, inputtext[]) 
{
	if(!response) return 1;
    switch(listitem)
    {
        case 0: // Dial Number
        {
            if(PlayerInfo[playerid][pTogglePhone])
            {
                SendClientMessage(playerid, COLOR_GREY, "You can't use your mobile phone right now as you have it toggled.");
                return callcmd::phone(playerid);
            }
            Dialog_Show(playerid, Phone_DialNumber, DIALOG_STYLE_INPUT, "Phone - Dial Number", "Special numbers: 911 = Emergency hotline, 6397 = News, 6324 = Mechanic, 8294 = Taxi\nPlease enter the number that you wish to dial below:", "Call", "Back");
        }
        case 1: // My Contacts
        {
            if(PlayerInfo[playerid][pTogglePhone])
            {
                SendClientMessage(playerid, COLOR_GREY, "You can't use your mobile phone right now as you have it toggled.");
                return callcmd::phone(playerid);
            }
            if(!PlayerInfo[playerid][pPhonebook])
            {
                SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you don't have a phonebook.");
                return callcmd::phone(playerid);
            }
            ShowContacts(playerid);
        }
        case 2: // Unread Text Messages
        {
            if(PlayerInfo[playerid][pTogglePhone])
            {
                SendClientMessage(playerid, COLOR_GREY, "You can't use your mobile phone right now as you have it toggled.");
                return callcmd::phone(playerid);
            }
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM texts WHERE recipient_number = %i ORDER BY date DESC", PlayerInfo[playerid][pPhone]);
            mysql_tquery(connectionID, queryBuffer, "OnQueryFinished", "ii", THREAD_VIEW_TEXTS, playerid);
        }
        case 3: // Turn Off/On Phone
        {
            if(!PlayerInfo[playerid][pTogglePhone])
            {
                if(PlayerInfo[playerid][pCallLine] != INVALID_PLAYER_ID)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't do this while in a call.");
                }
                PlayerInfo[playerid][pTogglePhone] = 1;
                SendClientMessage(playerid, COLOR_LIGHTBLUE, "Phone toggled. You will no longer receive calls or texts.");
            }
            else
            {
                PlayerInfo[playerid][pTogglePhone] = 0;
                SendClientMessage(playerid, COLOR_LIGHTBLUE, "Phone enabled. You can now receive calls and texts again.");
            }
            callcmd::phone(playerid);
        }
    }
    return 1;
}

Dialog:Phone_DialNumber(playerid, response, listitem, inputtext[]) 
{
    if(response) 
    {
        new number = strval(inputtext);
        if(number == 0 || number == PlayerInfo[playerid][pPhone])
        {
            return Dialog_Show(playerid, Phone_DialNumber, DIALOG_STYLE_INPUT, "Phone - Dial Number", "Invalid number!\n\nSpecial numbers: 911 = Emergency hotline, 6397 = News, 6324 = Mechanic, 8294 = Taxi\nPlease enter the number that you wish to dial below:", "Call", "Back");
        }
        CallNumber(playerid, number);
    }
    else
    {
        callcmd::phone(playerid);
    }
    return 1;
}

stock CallNumber(playerid, number)
{
    if(PlayerInfo[playerid][pCallLine] != INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have a call in session. /(h)angup to end that call.");
    }
    if(number == 911)
    {
        PlayerInfo[playerid][pCallLine] = playerid;
        PlayerInfo[playerid][pCallStage] = 911;

        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s dials a number on their keypad and begins a call.", GetRPName(playerid));
        SendClientMessage(playerid, COLOR_DISPATCH, "911, what is your emergency? Enter 'police' or 'medic'.");
        return 1;
    }
    else if(number == 6397)
    {
        PlayerInfo[playerid][pCallLine] = playerid;
        PlayerInfo[playerid][pCallStage] = 6397;

        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s dials a number on their keypad and begins a call.", GetRPName(playerid));
        SendClientMessage(playerid, COLOR_DISPATCH, "This is SANews here. Leave a message and we'll get back to you! *BEEP*");
        return 1;
    }
    else if(number == 6324)
    {
        PlayerInfo[playerid][pCallLine] = playerid;
        PlayerInfo[playerid][pCallStage] = 6324;

        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s dials a number on their keypad and begins a call.", GetRPName(playerid));
        SendClientMessage(playerid, COLOR_DISPATCH, "This is the mechanic hotline. Please explain your situation to us.");
        return 1;
    }
    else if(number == 8294)
    {
        PlayerInfo[playerid][pCallLine] = playerid;
        PlayerInfo[playerid][pCallStage] = 8294;

        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s dials a number on their keypad and begins a call.", GetRPName(playerid));
        SendClientMessage(playerid, COLOR_DISPATCH, "This is the cab company. Please state your location and destination.");
        return 1;
    }
    else if(number == 666)
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s dials a number on their keypad and begins a call.", GetRPName(playerid));
        SendClientMessage(playerid, COLOR_WHITE, "* They hung up their phone and ended the call.");
        return 1;
    }

    foreach(new i : Player)
    {
        if(PlayerInfo[i][pPhone] == number)
        {
            if(PlayerInfo[i][pJailType] > 0)
            {
                return SendClientMessage(playerid, COLOR_GREY, "That player is currently imprisoned and cannot use their phone.");
            }
            if(PlayerInfo[i][pCallLine] != INVALID_PLAYER_ID)
            {
                return SendClientMessage(playerid, COLOR_GREY, "This player is currently in a call. Wait until they hang up.");
            }
            if(PlayerInfo[i][pTogglePhone])
            {
                return SendClientMessage(playerid, COLOR_GREY, "That player has their mobile phone switched off.");
            }
            if(PlayerInfo[i][pLiveBroadcast] != INVALID_PLAYER_ID)
            {
                return SendClientMessage(playerid, COLOR_GREY, "That player is currently in a live interview and can't talk on the phone.");
            }
            if(PlayerInfo[playerid][pInjured] > 0)
            {
                return SendClientMessage(playerid, COLOR_GREY, "You are unable to use your cellphone at the moment.");
            }

            PlayerInfo[playerid][pCallLine] = i;
            PlayerInfo[playerid][pCallStage] = 0;

            PlayerInfo[i][pCallLine] = playerid;
            PlayerInfo[i][pCallStage] = 1;

            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "* %s dials a number on their keypad and begins a call.", GetRPName(playerid));
            SendProximityMessage(i, 20.0, COLOR_PURPLE, "* %s's mobile phone begins to ring.", GetRPName(i));

            SendMessage(playerid, COLOR_YELLOW, "* You've placed a call to number: %i. Please wait for your call to be answered.", number);
            SendMessage(i, COLOR_YELLOW, "* Incoming call from #%i. Use /pickup to take this call.", PlayerInfo[playerid][pPhone]);
            return 1;
        }
    }
    SendClientMessage(playerid, COLOR_GREY, "That number is either not in service or the owner is offline.");
    return 1;
}

//
enum contactData 
{
	contactID,
	contactExists,
	contactName[32],
	contactNumber
};

new ContactData[MAX_PLAYERS][MAX_CONTACTS][contactData];
new ListedContacts[MAX_PLAYERS][MAX_CONTACTS];

stock ShowContacts(playerid)
{
	new
	    string[32 * MAX_CONTACTS],
		count = 0;

	string = "Add Contact\n";

	for (new i = 0; i != MAX_CONTACTS; i ++) if (ContactData[playerid][i][contactExists]) {
	    format(string, sizeof(string), "%s%s - #%d\n", string, ContactData[playerid][i][contactName], ContactData[playerid][i][contactNumber]);

		ListedContacts[playerid][count++] = i;
	}
	Dialog_Show(playerid, Contacts, DIALOG_STYLE_LIST, "Phone - My Contacts", string, "Select", "Back");
	return 1;
}

stock ShowContactInfo(playerid)
{
    new title[64];
    format(title, sizeof(title), "Phone - %s (#%i)", ContactData[playerid][PlayerInfo[playerid][pSelected]][contactName], ContactData[playerid][PlayerInfo[playerid][pSelected]][contactNumber]);
    Dialog_Show(playerid, ContactInfo, DIALOG_STYLE_LIST, title, "Call Contact\nDelete Contact", "Select", "Back");
    return 1;
}

Dialog:Contacts(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (!listitem) {
	        Dialog_Show(playerid, NewContact, DIALOG_STYLE_INPUT, "Phone - New Contact", "Please enter the name of the contact below:", "Submit", "Back");
	    }
	    else 
        {
		    PlayerInfo[playerid][pSelected] = ListedContacts[playerid][listitem - 1];
            ShowContactInfo(playerid);
	    }
	}
	else 
    {
		callcmd::phone(playerid);
	}
	for (new i = 0; i != MAX_CONTACTS; i ++) {
	    ListedContacts[playerid][i] = -1;
	}
	return 1;
}

Dialog:NewContact(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (isnull(inputtext))
			return Dialog_Show(playerid, NewContact, DIALOG_STYLE_INPUT, "Phone - New Contact", "Error: Please enter a contact name.\n\nPlease enter the name of the contact below:", "Submit", "Back");

	    if (strlen(inputtext) > 32)
	        return Dialog_Show(playerid, NewContact, DIALOG_STYLE_INPUT, "Phone - New Contact", "Error: The contact name can't exceed 32 characters.\n\nPlease enter the name of the contact below:", "Submit", "Back");

        SetPVarString(playerid, "Edit_Contact", inputtext);

	    Dialog_Show(playerid, EnterNumber, DIALOG_STYLE_INPUT, "Phone - Contact Number", "Contact name: %s\n\nPlease enter the phone number for this contact:", "Submit", "Back", inputtext);
	}
	else {
		ShowContacts(playerid);
	}
	return 1;
}

Dialog:ContactInfo(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new id = PlayerInfo[playerid][pSelected];
		switch (listitem)
		{
		    case 0:
		    {
                foreach(new i : Player)
                {
                    if(PlayerInfo[i][pPhone] == ContactData[playerid][id][contactNumber])
                    {
                        CallNumber(playerid, ContactData[playerid][id][contactNumber]);
                        return 1;
                    }
                }
                SendClientMessage(playerid, COLOR_GREY, "That number is either not in service or the owner is offline.");
                ShowContactInfo(playerid);
		    }
		    case 1:
		    {
                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM `contacts` WHERE `ID` = '%i' AND `contactID` = '%i'", PlayerInfo[playerid][pID], ContactData[playerid][id][contactID]);
                mysql_tquery(connectionID, queryBuffer);

                SendMessage(playerid, COLOR_YELLOW, "You have deleted %s from your contacts.", ContactData[playerid][id][contactName]);

		        ContactData[playerid][id][contactExists] = false;
		        ContactData[playerid][id][contactNumber] = 0;
		        ContactData[playerid][id][contactID] = 0;
		        ShowContacts(playerid);
		    }
		}
	}
	else 
    {
	    ShowContacts(playerid);
	}
	return 1;
}

Dialog:EnterNumber(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new name[32], number = strval(inputtext);

        GetPVarString(playerid, "Edit_Contact", name, sizeof(name));

	    if(isnull(inputtext) || !IsNumeric(inputtext) || number == 0 || number == PlayerInfo[playerid][pPhone])
	        return Dialog_Show(playerid, EnterNumber, DIALOG_STYLE_INPUT, "Phone - Contact Number", "Invalid number!\n\nContact name: %s\nPlease enter the phone number for this contact:", "Submit", "Back", name);
        
		for (new i = 0; i != MAX_CONTACTS; i ++)
		{
			if (!ContactData[playerid][i][contactExists])
			{
            	ContactData[playerid][i][contactExists] = true;
            	ContactData[playerid][i][contactNumber] = strval(inputtext);

				format(ContactData[playerid][i][contactName], 32, name);

                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO `contacts` (`ID`, `contactName`, `contactNumber`) VALUES('%i', '%s', '%i')", PlayerInfo[playerid][pID], SQL_ReturnEscaped(name), ContactData[playerid][i][contactNumber]);
                mysql_tquery(connectionID, queryBuffer, "OnContactAdd", "ii", playerid, i);

                SendMessage(playerid, COLOR_YELLOW, "You have added %s to your contacts.", name);
                ShowContacts(playerid);
                return 1;
			}
	    }
        SendClientMessage(playerid, COLOR_GREY, "There is no room left for anymore contacts.");
        ShowContacts(playerid);
	}
	else {
		ShowContacts(playerid);
	}
	return 1;
}

forward OnContactAdd(playerid, id);
public OnContactAdd(playerid, id)
{
	ContactData[playerid][id][contactID] = cache_insert_id(connectionID);
	return 1;
}