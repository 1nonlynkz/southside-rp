enum
{
    MESSAGE_ERROR,
    MESSAGE_SERVER,
	MESSAGE_USAGE,
	MESSAGE_INFO,
	MESSAGE_NORMAL
};

stock TimeConvert(time)
{
    new day = time / 86400; time %= 86400;
    new hour = time / 3600; time %= 3600;
    new minute = time / 60; time %= 60;
    new second = time;

    new string[128];
    if(day > 0)
    {
        format(string, sizeof(string), "%02d day(s) %02d hour(s) %02d minute(s) %02d second(s)", day, hour, minute, second);
        return string;
    }
    else if(hour > 0)
    {
        format(string, sizeof(string), "%02d hour(s) %02d minute(s) %02d second(s)", hour, minute, second);
        return string;
    }
    else if(minute > 0)
    {
        format(string, sizeof(string), "%02d minute(s) %02d second(s)", minute, second);
        return string;
    }
    else if(second > 0)
    {
        format(string, sizeof(string), "%02d second(s)", second);
        return string;
    }
    return string;
}

stock ConvertTime(time)
{
    new day = time / 86400; time %= 86400;
    new hour = time / 3600; time %= 3600;
    new minute = time / 60; time %= 60;
    new second = time;

    new string[128];
    if(day > 0)
    {
        format(string, sizeof(string), "%02d:%02d:%02d:%02d Day(s)", day, hour, minute, second);
        return string;
    }
    else if(hour > 0)
    {
        format(string, sizeof(string), "%02d:%02d:%02d Hours(s)", hour, minute, second);
        return string;
    }
    else if(minute > 0)
    {
        format(string, sizeof(string), "%02d:%02d Minute(s)", minute, second);
        return string;
    }
    else if(second > 0)
    {
        format(string, sizeof(string), "%02d Second(s)", second);
        return string;
    }
    return string;
}

Float:GetVehicleSpeedMPH(vehicleid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	if(GetVehicleVelocity(vehicleid, x, y, z))
	{
		return floatsqroot((x * x) + (y * y) + (z * z)) * 100;
	}

	return 0.0;
}

stock IsPlayerNearBoot(playerid, vehicleid)
{
    static
        Float:fX,
        Float:fY,
        Float:fZ;

    GetVehicleBoot(vehicleid, fX, fY, fZ);

    return (GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehicleid)) && IsPlayerInRangeOfPoint(playerid, 3.5, fX, fY, fZ);
}

GetVehicleCranePrice(vehicleid, bool:extras = true)
{
	new amount;
	if((VehicleInfo[vehicleid][vID] > 0) && (VehicleInfo[vehicleid][vFactionType] > 0 || VehicleInfo[vehicleid][vGang] >= 0 && VehicleInfo[vehicleid][vJob] >= 0))
		return 0;

	switch(GetVehicleModel(vehicleid))
	{
	    case 481, 509, 510: // Bicycles.
	        amount = 2500;

	    case 448, 462, 463, 468, 471: // Mid bikes.
	        amount = 2750;

		case 461, 521, 522, 581: // High bikes.
		    amount = 3000;

		case 402, 429, 475, 477, 494, 496, 502..504, 558..562, 565, 587, 589, 602, 603: // Muscle cars and mid sports cars.
		    amount = 3500;

		case 411, 415, 451, 506, 541: // High sports cars.
		    amount = 5000;

		case 403, 408, 414, 443, 455, 456, 498, 499, 514, 515, 524, 578, 609: // Boxed trucks and trucks.
		    amount = 4000;

		case 413, 418, 422, 440, 459, 478, 482, 543, 552, 554, 582, 600, 605: // Pickup trucks and vans.
		    amount = 4000;

		case 400, 424, 444, 470, 489, 495, 500, 505, 556, 557, 568, 573, 579: // Offroad vehicles
		    amount = 4000;

		case 412, 534..536, 566, 567, 575, 576: // Lowriders
		    amount = 5000;

		case 401, 404, 405, 410, 419, 421, 426, 436, 445, 458, 466, 467, 474, 479, 491, 492, 516..518, 526, 527, 529, 540, 542, 546, 547, 549..551, 580, 585, 604: // Saloon cars & station wagons.
		    amount = 5000;
 	}

 	if((extras && amount > 0) && VehicleInfo[vehicleid][vOwnerID] > 0)
 	{
 	    if(VehicleInfo[vehicleid][vNeon] != 0)
		 	amount += 1000; // $1k extra for neon.
 	    if(VehicleInfo[vehicleid][vTrunk] != 0)
 	        amount += VehicleInfo[vehicleid][vTrunk] * 250; // Extra $250 per trunk level.
		if(strcmp(VehicleInfo[vehicleid][vPlate], "None") != 0)
		    amount += 750; // Extra $750 for a custom plate.
 	}
 	return amount;
}

EditDynamicObjectEx(playerid, type, objectid, extraid = -1)
{
	PlayerInfo[playerid][pEdit] = type;
	PlayerInfo[playerid][pEditID] = extraid;

	return EditDynamicObject(playerid, objectid);
}


GetPlayerAccent(playerid)
{
    new accent[128];
    switch(PlayerInfo[playerid][pAccent])
    {
		case 1: accent = "British accent";
		case 2: accent = "Japanese accent";
		case 3: accent = "Chinese accent";
		case 4: accent = "Korean accent";
		case 5: accent = "Scottish accent";
		case 6: accent = "Irish accent";
		case 7: accent = "Russian accent";
		case 8: accent = "American accent";
		case 9: accent = "Spanish accent";
		case 10: accent = "Southern accent";
		case 11: accent = "Italian accent";
		case 12: accent = "Gangster accent";
		case 13: accent = "Australian accent";
		case 14: accent = "Arabic accent";
		case 15: accent = "Balkan accent";
		case 16: accent = "Canadian accent";
		case 17: accent = "Jamaican accent";
		case 18: accent = "Israeli accent";
		case 19: accent = "Dutch accent";
		case 20: accent = "Brazilian accent";
		case 21: accent = "German accent";
		case 22: accent = "Turkish accent";
		case 23: accent = "Kiwi accent";
		case 24: accent = "French accent";
		case 25: accent = "Korean accent";
		case 26: accent = "Thai accent";
    }
    return accent;
}

CompareStrings(const string[], const string2[])
{
	return (!strcmp(string, string2, true))?(1):(0);
}


IsWeaponModel(model) {
    new const g_aWeaponModels[] = {
		0, 331, 333, 334, 335, 336, 337, 338, 339, 341, 321, 322, 323, 324,
		325, 326, 342, 343, 344, 0, 0, 0, 346, 347, 348, 349, 350, 351, 352,
		353, 355, 356, 372, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366,
		367, 368, 368, 371
    };
    for (new i = 0; i < sizeof(g_aWeaponModels); i ++) if (g_aWeaponModels[i] == model) {
        return 1;
	}
	return 0;
}

stock IsPlayerNearPlayer(playerid, targetid, Float:radius)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(targetid, x, y, z);
	if(IsPlayerInRangeOfPoint(playerid, radius ,x, y, z))
	{
	    return 1;
	}
	return 0;
}

GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);
    if (GetPlayerVehicleID(playerid))
    {
      GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }
    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
}

stock GetXYInFrontOfPlayerEx(playerid, &Float:X, &Float:Y, &Float:Z, Float:distance)
{
	new Float:A;
	GetPlayerPos(playerid, X, Y, Z);

	if (GetPlayerVehicleID(playerid))	GetVehicleZAngle(GetPlayerVehicleID(playerid), A);
	else								GetPlayerFacingAngle(playerid, A);

	X += (distance * floatsin(-A, degrees));
	Y += (distance * floatcos(-A, degrees));
}


stock IsKeyJustDown(key, newkeys, oldkeys)
{
	if((newkeys & key) && !(oldkeys & key)) return 1;
	return 0;
}

stock ShowNoticeGUIFrame(playerid, frame)
{
	HideNoticeGUIFrame(playerid);

	TextDrawShowForPlayer(playerid, NoticeTxtdraw[0]);
	TextDrawShowForPlayer(playerid, NoticeTxtdraw[1]);

	switch(frame)
	{
		case 1: // Looking up account
		{
			TextDrawShowForPlayer(playerid, NoticeTxtdraw[2]);
		}
		case 2: // Fetching & Comparing Password
		{
			TextDrawShowForPlayer(playerid, NoticeTxtdraw[3]);
		}
		case 3: // Fetching & Loading Account
		{
			TextDrawShowForPlayer(playerid, NoticeTxtdraw[4]);
		}
		case 4: // Streaming Objects
		{
			TextDrawShowForPlayer(playerid, NoticeTxtdraw[5]);
		}
		case 5: // Login Queue
		{
			TextDrawShowForPlayer(playerid, NoticeTxtdraw[6]);
		}
		case 6: // General loading
		{
		    TextDrawShowForPlayer(playerid, NoticeTxtdraw[7]);
		}
	}
}

stock HideNoticeGUIFrame(playerid)
{
	for(new i = 0; i < 8; i++)
	{
		TextDrawHideForPlayer(playerid, NoticeTxtdraw[i]);
	}
}