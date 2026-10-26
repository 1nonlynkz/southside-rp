#include <YSI_Coding\y_hooks>

enum jobEnum
{
	jobName[32],
	jobActor,
	Float:jobX,
	Float:jobY,
	Float:jobZ,
	Float:JobA
};

new const jobLocations[][jobEnum] =
{
	// Job Name			Skin	Pos X		Pos Y	   Pos Z  	  Pos A
	{"Pizzaman", 		155,	2104.7771, 	-1805.1772, 13.5547,  94.5307},
	{"Trucker",     	71,		2214.9797, 	-2661.3469, 13.5468,  2.27},
	{"Fisherman",   	14,		393.2632,  	-2070.5837, 7.8359,   19.1341},
	{"Arms Dealer",  	30,		1366.4503, 	-1274.5061, 13.5468,  131.01},
	{"Taxi Driver",     61,		1748.1373, 	-1863.0981, 13.5755,  1.0},
	{"Drug Dealer",    	29,		2165.3611, 	-1673.0824, 15.0778,  271.98},
	{"Miner",           27,		291.7899,   -682.3915,  5.0114,   180.2309},
	{"Garbage Man",     8,		1580.8385,	-2176.3926,	13.5516,  181.5760}
};

new const jobDescriptions[][] =
{
	"Deliver food pizza to hungry customers around San Andreas.", 
	"Deliver packages and letters around the city using your delivery truck.",  
	"To catch fish and sell them to 24/7 stores",  
	"Buy weapons from the black market and sell them to other players.",  
	"Pick up passengers and drive them to their destination for a fare.",  
	"Sell illegal substances to players and earn fast money — but be careful!",  
	"Mine rocks and minerals to earn money.", 
	"A job where you collect trash from the city streets and dispose of it properly."
};

new const jobHelpTexts[][] =
{
	"Use /getpizza to start the deliver", 
	"Use /loadtruck to pick up and deliver parcels.", 
	"Use /fish to start fishing and Use /sellfish to sell it", 
	"Use /sellgun to handle weapon trades.", 
	"Use /taxi to start your shift and pick up passengers.", 
	"Use /plathelp for more info and Use /getcrate to get the drug crate", 
	"Use /mine at the quarry to collect ores.", 
	"Use /takebag to get the trashbag and Press N to load the trashbag inside the truck"
};

ShowLocateMenu(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_LOCATE, DIALOG_STYLE_LIST, "List of Destination", "Job Locations\nGeneral Locations\nPoints\nTurfs", "Select", "Close");
    return 1;
}

CMD:locate(playerid, params[])
{
    if(!Inventory_Count(playerid, "GPS"))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need a GPS device in your inventory to use /locate.");
    }
    ShowLocateMenu(playerid);
    return 1;
}

// ==========================================
// DIALOG SYSTEM
// ==========================================
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_LOCATE)
	{
		if(response)
        {
           	switch(listitem)
        	{
				case 0:
        	    {
                	ShowPlayerDialog(playerid, DIALOG_LOCATE_LIST1, DIALOG_STYLE_LIST, "Job Locations", "Pizzaman\nTrucker\nFisherman\nArms Dealer\nTaxi Driver\nDrug Dealer\nMiner\nGarbage Man", "Locate", "Close");
        	    }
        	    case 1:
        	    {
					new string[34 * MAX_LOCATION];
					string[0] = '\0'; 
					for(new x = 0; x < MAX_LOCATION; x++) {
						if(LocationInfo[x][lcExists]) {
							strcat(string, LocationInfo[x][lcName]);
							strcat(string, "\n");
						}
					}
					if(strlen(string) > 2) {
						ShowPlayerDialog(playerid, DIALOG_LOCATE_LIST2, DIALOG_STYLE_LIST, "General Locations", string, "Select", "Return");
					} else {
						SendClientMessage(playerid, COLOR_WHITE, "Unable to locate any new locations.");
					}
				}
				case 2:
        	    {
					new string[34 * MAX_POINTS];
					string[0] = '\0';
					for(new x = 0; x < MAX_POINTS; x++) {
						if(PointInfo[x][pExists]) {
							strcat(string, PointInfo[x][pName]);
							strcat(string, "\n");
						}
					}
					if(strlen(string) > 2) {
						ShowPlayerDialog(playerid, DIALOG_LOCATE_LIST3, DIALOG_STYLE_LIST, "Points Locations", string, "Select", "Return");
					} else {
						SendClientMessage(playerid, COLOR_WHITE, "Unable to locate any new locations.");
					}
				}
				case 3:
				{
					new string[34 * MAX_TURFS];
					string[0] = '\0';
					for(new x = 0; x < MAX_TURFS; x++) {
						if(TurfInfo[x][tExists]) 
						{
							strcat(string, TurfInfo[x][tName]);
							strcat(string, "\n");
						}
					}
					if(strlen(string) > 2) {
						ShowPlayerDialog(playerid, DIALOG_LOCATE_LIST4, DIALOG_STYLE_LIST, "Turf Locations", string, "Select", "Return");
					} else {
						SendClientMessage(playerid, COLOR_WHITE, "Unable to locate any new locations.");
					}
				}
			}
		}
		return 1;
	}

	if(dialogid == DIALOG_LOCATE_LIST1)
	{
		if(!response) return ShowLocateMenu(playerid); 
		
		PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
		SetPlayerCheckpoint(playerid, jobLocations[listitem][jobX], jobLocations[listitem][jobY], jobLocations[listitem][jobZ], 3.0);
		SendMessage(playerid, COLOR_WHITE, "Global Position System");
		SendMessage(playerid, COLOR_WHITE, "Name: %s", jobLocations[listitem][jobName]);
		SendMessage(playerid, COLOR_WHITE, "Located at: %s", GetZoneName(jobLocations[listitem][jobX], jobLocations[listitem][jobY], jobLocations[listitem][jobZ]));
		SendMessage(playerid, COLOR_WHITE, "Distance: %.1f meters.", GetPlayerDistanceFromPoint(playerid, jobLocations[listitem][jobX], jobLocations[listitem][jobY], jobLocations[listitem][jobZ]));
		return 1;
	}

	if(dialogid == DIALOG_LOCATE_LIST2)
	{
		if(!response) return ShowLocateMenu(playerid); 
		
		for(new i = 0; i < MAX_LOCATION; i++)
		{
			if(LocationInfo[i][lcExists] && strcmp(LocationInfo[i][lcName], inputtext, true) == 0)
			{
				PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
				SetPlayerCheckpoint(playerid, LocationInfo[i][lcPosX], LocationInfo[i][lcPosY], LocationInfo[i][lcPosZ], 3.0);
				SendMessage(playerid, COLOR_WHITE, "Global Position System");
				SendMessage(playerid, COLOR_WHITE, "Name: %s", LocationInfo[i][lcName]);
				SendMessage(playerid, COLOR_WHITE, "Located at: %s", GetZoneName(LocationInfo[i][lcPosX], LocationInfo[i][lcPosY], LocationInfo[i][lcPosZ]));
				SendMessage(playerid, COLOR_WHITE, "Distance: %.1f meters.", GetPlayerDistanceFromPoint(playerid, LocationInfo[i][lcPosX], LocationInfo[i][lcPosY], LocationInfo[i][lcPosZ]));
				break;
			}
		}
		return 1;
	}

	if(dialogid == DIALOG_LOCATE_LIST3)
	{
		if(!response) return ShowLocateMenu(playerid); 
			
		for(new i = 0; i < MAX_POINTS; i++)
		{
			if(PointInfo[i][pExists] && strcmp(PointInfo[i][pName], inputtext, true) == 0)
			{
                PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
			    SetPlayerCheckpoint(playerid, PointInfo[i][pPointX], PointInfo[i][pPointY], PointInfo[i][pPointZ], 3.0);
				SendMessage(playerid, COLOR_WHITE, "Global Position System");
				SendMessage(playerid, COLOR_WHITE, "Name: %s", PointInfo[i][pName]);
				SendMessage(playerid, COLOR_WHITE, "Located at: %s", GetZoneName(PointInfo[i][pPointX], PointInfo[i][pPointY], PointInfo[i][pPointZ]));
				SendMessage(playerid, COLOR_WHITE, "Distance: %.1f meters.", GetPlayerDistanceFromPoint(playerid, PointInfo[i][pPointX], PointInfo[i][pPointY], PointInfo[i][pPointZ]));
				break;
		    }
		}
		return 1;
	}

	if(dialogid == DIALOG_LOCATE_LIST4)
	{
		if(!response) return ShowLocateMenu(playerid); 
		
	    for(new i = 0; i < MAX_TURFS; i ++)
	    {
	        if(TurfInfo[i][tExists] && strcmp(TurfInfo[i][tName], inputtext, true) == 0)
	        {
		   	 	PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
		    	SetPlayerCheckpoint(playerid, TurfInfo[i][tMinX], TurfInfo[i][tMinY], TurfInfo[i][tHeight], 3.0);
				SendMessage(playerid, COLOR_WHITE, "Global Position System");
				SendMessage(playerid, COLOR_WHITE, "Name: %s", TurfInfo[i][tName]);
				SendMessage(playerid, COLOR_WHITE, "Located at: %s", GetZoneName(TurfInfo[i][tMinX], TurfInfo[i][tMinY], TurfInfo[i][tHeight]));
				SendMessage(playerid, COLOR_WHITE, "Distance: %.1f meters.", GetPlayerDistanceFromPoint(playerid, TurfInfo[i][tMinX], TurfInfo[i][tMinY], TurfInfo[i][tHeight]));
		    	break;
			}
		}
		return 1;
	}
	return 1;
}