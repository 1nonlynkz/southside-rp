//CAR FACTORY JOB
#include <YSI_Coding\y_hooks>

new af_player_cptype[MAX_PLAYERS];
new af_player_detailcount[MAX_PLAYERS];
new af_player_obj[MAX_PLAYERS];
new af_player_details[MAX_PLAYERS];
new af_player_carmodel[MAX_PLAYERS];
new cargo_driver[MAX_VEHICLES] = {-1,...};
new af_cpnum[MAX_PLAYERS];
new bool: af_player_status[MAX_PLAYERS];
new af_orig_truck[2];
new af_objcar[MAX_VEHICLES][5];
new bool:af_player_lootstatus[MAX_PLAYERS];
new bool: af_load[MAX_PLAYERS];
new Text3D: af_tmp_text[MAX_PLAYERS];
new af_hprem[MAX_PLAYERS];
new af_carID[MAX_PLAYERS];
new af_carList[MAX_PLAYERS];
new bool: af_player_loadready[MAX_PLAYERS];

ptask CarFactoryUpdate[1000](i)
{
    if(PlayerInfo[i][pLogged] && !PlayerInfo[i][pKicked])
    {
        if(GetPlayerVehicleID(i) == af_carID[i] && 
            GetPlayerState(i) == PLAYER_STATE_DRIVER && 
            af_load[i]) {

            switch(af_cpnum[i]) {
                case 1: SetPlayerCheckpoint(i, 549.4506,-1288.6519,17.2482, 5);
                case 2: SetPlayerCheckpoint(i, 2126.1289,-1124.1933,25.4615, 5);
                case 3: SetPlayerCheckpoint(i, 1337.8837,-869.5786,39.3045, 5);
            }
        }
    }
}
stock CreateTruckBody(vehicleid) {
    AttachDynamicObjectToVehicle(CreateDynamicObject(2909,0.0,0.0,-1000.0,0.0,0.0,0.0), vehicleid, 1.391, -1.911, 1.030, 0.000, 0.000, 0.000);
    AttachDynamicObjectToVehicle(CreateDynamicObject(2909,0.0,0.0,-1000.0,0.0,0.0,0.0), vehicleid, -1.382, -1.901, 1.070, 0.000, 0.000, 0.000);
    AttachDynamicObjectToVehicle(CreateDynamicObject(2909,0.0,0.0,-1000.0,0.0,0.0,0.0), vehicleid, -0.017, -1.919, 2.310, 0.000, 90.799, 0.000);
    AttachDynamicObjectToVehicle(CreateDynamicObject(2904,0.0,0.0,-1000.0,0.0,0.0,0.0), vehicleid, 0.000, -6.033, 0.930, 0.000, 0.000, 0.000);
}

LoadCarFactory()
{
    new tmpveh[20]; // make it an array to store all truck IDs
	new index = 0;

	af_orig_truck[0] = CreateVehicle(578, 2248.9758, -2242.3655, 14.1731, 44.9295, 1, 1, 360); // 1
	CreateTruckBody(af_orig_truck[0]);

	tmpveh[index++] = CreateVehicle(578, 2241.8613, -2249.6189, 14.1722, 44.1467, 1, 1, 360); // 2
	CreateTruckBody(tmpveh[index - 1]);
	tmpveh[index++] = CreateVehicle(578, 2234.8230, -2256.7407, 14.1782, 43.1500, 1, 1, 360); // 3
	CreateTruckBody(tmpveh[index - 1]);
	tmpveh[index++] = CreateVehicle(578, 2227.6055, -2263.9524, 14.1816, 45.9869, 1, 1, 360); // 4
	CreateTruckBody(tmpveh[index - 1]);
	tmpveh[index++] = CreateVehicle(578, 2212.0391, -2280.2217, 14.1813, 45.7099, 1, 1, 360); // 5
	CreateTruckBody(tmpveh[index - 1]);
	tmpveh[index++] = CreateVehicle(578, 2208.7568, -2283.3406, 14.1798, 45.4458, 1, 1, 360); // 6
	CreateTruckBody(tmpveh[index - 1]);
	tmpveh[index++] = CreateVehicle(578, 2205.4792, -2286.7327, 14.1757, 46.7885, 1, 1, 360); // 7
	CreateTruckBody(tmpveh[index - 1]);
	tmpveh[index++] = CreateVehicle(578, 2202.1709, -2290.0400, 14.1722, 46.0170, 1, 1, 360); // 8
	CreateTruckBody(tmpveh[index - 1]);
	tmpveh[index++] = CreateVehicle(578, 2198.7114, -2293.6797, 14.1714, 46.6026, 1, 1, 360); // 9
	CreateTruckBody(tmpveh[index - 1]);
	tmpveh[index++] = CreateVehicle(578, 2195.1714, -2297.4751, 14.1717, 44.9319, 1, 1, 360); // 10
	CreateTruckBody(tmpveh[index - 1]);
	tmpveh[index++] = CreateVehicle(578, 2191.6055, -2301.3247, 14.1722, 45.4955, 1, 1, 360); // 11
	CreateTruckBody(tmpveh[index - 1]);
	tmpveh[index++] = CreateVehicle(578, 2180.4058, -2295.7715, 14.1789, 313.3638, 1, 1, 360); // 12
	CreateTruckBody(tmpveh[index - 1]);
	af_orig_truck[1] = CreateVehicle(578, 2176.3206, -2291.4778, 14.1098, 313.2157, 1, 1, 360); // 13
	CreateTruckBody(af_orig_truck[1]);

	// Set properties for all created vehicles
	for (new i = 0; i < index; i++)
	{
		SetVehicleParamsEx(tmpveh[i], 0, 0, 0, 0, 0, 0, 0);
		vehicleFuel[tmpveh[i]] = 100;
	}
	vehicleFuel[af_orig_truck[0]] = 100;
	vehicleFuel[af_orig_truck[1]] = 100;
}

stock RemoveCarFromTruckBody(playerid)
{
	if(!af_load[playerid]) return 1;

	for(new i = 0; i < 5; i ++) DestroyDynamicObject(af_objcar[af_carID[playerid]][i]);
	DisablePlayerCheckpoint(playerid);
	TogglePlayerAllDynamicCPs(playerid, 1);
	
	af_hprem[playerid] = 0;
	af_load[playerid] = false;
	return 1;
}

//cmds
CMD:assemblecar(playerid)
{
    if(!PlayerHasJob(playerid, JOB_CARFACTORY))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of car factory worker.");
	}

    new string[300];
    format(string, 300, "Flash\nSultan\nBullet\nCheetah\nTurismo\nElegy\nBuffalo\nZR-350\nSuper GT\nUranus\nHuntley\nStratum\nJester\nBanshee\nComet\nInfernus");
	ShowPlayerDialog(playerid, DIALOG_ASSEMBLECAR,DIALOG_STYLE_LIST,"Choose a car", string, "Choose", "Cancel");
    return 1;
}

CMD:loadcar(playerid) {

    if(!PlayerHasJob(playerid, JOB_CARFACTORY))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of car factory worker.");
	}
    
	if(GetPlayerVehicleID(playerid) != af_carID[playerid] || 
		GetPlayerState(playerid) != PLAYER_STATE_DRIVER || 
		af_load[playerid]) 
		return SendClientMessage(playerid,-1,"This feature is not available to you at the moment.");
	if(!IsPlayerInRangeOfPoint(playerid, 8, 2195.0046,-2239.5566,13.5469) && 
		!IsPlayerInRangeOfPoint(playerid, 8, 2211.3887,-2223.7554,13.5469)) return SendClientMessage(playerid,-1,"You need to be near the loading area");

	new Float: posx,Float: posy,Float: posz;
	if(IsPlayerInRangeOfPoint(playerid, 8, 2211.3887,-2223.7554,13.5469)) {
		posx = 2214.4915;
		posy = -2227.8118;
		posz = 14.1732;
	}
	else {
		posx = 2198.8621;
		posy = -2243.4385;
		posz = 14.1723;
	}

	new vehicleid = af_carID[playerid];

    SetVehiclePos(vehicleid, posx,posy,posz);
	SetVehicleZAngle(vehicleid, 45);

	new color;

	switch(random(5)) {
		case 0: color = 0xFFFFFFFF;
		case 1: color = 0xFFBB0000;
		case 2: color = 0xFF66CC66;
		case 3: color = 0xFFFF9900;
		case 4: color = 0xFF3399FF;
	}

	af_objcar[vehicleid][0] = CreateDynamicObject(3594,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
	SetDynamicObjectMaterial(af_objcar[vehicleid][0], 0, -1, "none", "none", color);
	SetDynamicObjectMaterial(af_objcar[vehicleid][0], 1, -1, "none", "none", color);
	SetDynamicObjectMaterial(af_objcar[vehicleid][0], 2, -1, "none", "none", color);
	SetDynamicObjectMaterial(af_objcar[vehicleid][0], 3, -1, "none", "none", color);
	SetDynamicObjectMaterial(af_objcar[vehicleid][0], 4, -1, "none", "none", color);
    AttachDynamicObjectToVehicle(af_objcar[vehicleid][0], vehicleid, 0.067, -1.369, 0.720, 0.000, 0.000, -177.100);

    af_objcar[vehicleid][1] = CreateDynamicObject(1084,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
    AttachDynamicObjectToVehicle(af_objcar[vehicleid][1], vehicleid, 0.990, 0.880, 0.210, 0.000, 0.000, 0.000);
    af_objcar[vehicleid][2] = CreateDynamicObject(1084,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
    AttachDynamicObjectToVehicle(af_objcar[vehicleid][2], vehicleid, -1.000, 0.840, 0.210, 0.000, 0.000, 0.000);
    af_objcar[vehicleid][3] = CreateDynamicObject(1084,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
    AttachDynamicObjectToVehicle(af_objcar[vehicleid][3], vehicleid, -1.000, -3.170, 0.200, 0.000, 0.000, 0.000);
    af_objcar[vehicleid][4] = CreateDynamicObject(1084,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
    AttachDynamicObjectToVehicle(af_objcar[vehicleid][4], vehicleid, 1.140, -3.150, 0.190, 0.000, 0.000, 0.000);

    af_load[playerid] = true;

	//SetPlayerCheckpoint(playerid, 1337.7284,-919.1735,35.9311, 5);
	
	switch(random(3)) {
		case 0: {
			SetPlayerCheckpoint(playerid, 549.4506,-1288.6519,17.2482, 5); //grotti
			af_cpnum[playerid]=1;
		}
		case 1: {
			SetPlayerCheckpoint(playerid, 2126.3069, -1117.6901, 25.3495, 5); //jefferson
			af_cpnum[playerid]=2;
		}
		case 2: {
			SetPlayerCheckpoint(playerid, 2322.0474,-2058.7209,13.5469, 5); //vinewood
			af_cpnum[playerid]=3;
		}
	}
	TogglePlayerAllDynamicCPs(playerid, 0);
	SendClientMessage(playerid, -1,"Vehicle loaded successfully.");
	SendClientMessage(playerid, -1,"Take it to the Car Dealership, location is marked on your GPS");
	return SendClientMessage(playerid,0xFF4400FF,"Try not to exceed a speed of more than 60 km/h, as your car may be damaged.");
}

CMD:startassemble(playerid)
{
    if(!PlayerHasJob(playerid, JOB_CARFACTORY))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of car factory worker.");
	}
    if(af_player_lootstatus[playerid]) return SendClientMessage(playerid,COLOR_SYNTAX,"You have already started assembling the car");
	if(!af_player_status[playerid]) return SendClientMessage(playerid,COLOR_SYNTAX,"To start assembling, got to the main point and select a car that you want to assemble.");
	if(!IsPlayerInRangeOfPoint(playerid, 5, 2157.0752,-2252.6182,14.2094)) return SendClientMessage(playerid,COLOR_SYNTAX,"Get closer to the conveyor");
	af_player_lootstatus[playerid] = true;
	af_player_detailcount[playerid] = 0;
	af_player_loadready[playerid] = false;
	DisablePlayerCheckpoint(playerid);
	af_show_random_cp(playerid);
	SendClientMessage(playerid, COLOR_SYNTAX,"Vehicle assembly started");
	return SendClientMessage(playerid, COLOR_SYNTAX,"Approach the marked point and take the car part");
}
stock af_show_random_cp(playerid) {
	new rand_int = random(6);
	af_player_cptype[playerid] = rand_int;
	switch(rand_int) {
		case 0: SetPlayerCheckpoint(playerid, 2155.5266,-2269.7776,13.3032, 2);
		case 1: SetPlayerCheckpoint(playerid, 2164.8806,-2262.0322,13.3038, 2);
		case 2: SetPlayerCheckpoint(playerid, 2151.1147,-2247.7026,13.2990, 2);
		case 3: SetPlayerCheckpoint(playerid, 2151.1328,-2251.3228,13.2954, 2);
		case 4: SetPlayerCheckpoint(playerid, 2149.4338,-2273.2698,13.3047, 2);
		case 5: SetPlayerCheckpoint(playerid, 2138.1147,-2254.1345,13.3078, 2);
	}
}

public OnPlayerEnterCheckpoint(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid, 5, 549.4506,-1288.6519,17.2482) || 
		IsPlayerInRangeOfPoint(playerid, 5, 2126.1289,-1124.1933,25.4615) || 
		IsPlayerInRangeOfPoint(playerid, 5, 1337.8837,-869.5786,39.3045)) {
		DisablePlayerCheckpoint(playerid);
		if(GetPlayerVehicleID(playerid) != af_carID[playerid] || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
			return 1;
		new rem=af_hprem[playerid];
		RemoveCarFromTruckBody(playerid);
		af_player_lootstatus[playerid] = false;
		af_player_status[playerid] = false;
		new amount;
		switch(af_carList[playerid]) {
			case 0: amount = 190;
			case 1: amount = 230;
			case 2: amount = 230;
			case 3: amount = 230;
			case 4: amount = 230;
			case 5: amount = 280;
			case 6: amount = 280;
			case 7: amount = 310;
			case 8: amount = 330;
			case 9: amount = 140;
			case 10: amount = 160;
			case 11: amount = 250;
			case 12: amount = 450;
			case 13: amount = 160;
			case 14: amount = 160;
			case 15: amount = 360;
		}
		
		SendMessage(playerid, COLOR_SYNTAX, "Assymble Labor: %s", FormatNumber(amount, 1));
		///SendMessage(playerid, COLOR_SYNTAX, "Manufactor: %s", FormatNumber(ServerInfo[sv_JobSalary][3], 1));
		//amount = ServerInfo[sv_JobSalary][3] + amount;

		new remmoney;
		if(rem >= 300) remmoney = 2000;
		if(rem >= 200) remmoney = 1000;
		if(rem >= 100) remmoney = 500;
		if(rem >= 50) remmoney = 300;
		if(rem >= 20) remmoney = 200;
		if(rem > 0) remmoney = 100;

		SendMessage(playerid, COLOR_SYNTAX, "Damage deduct: %s", FormatNumber(remmoney, 1));

        if(PlayerInfo[playerid][pLaborUpgrade] > 0)
        {
            amount += percent(amount, PlayerInfo[playerid][pLaborUpgrade]);
        }

		new salary;
		salary = 8500 + random(6001) + random(500);
		AddToPaycheck(playerid, salary);

		new Float:expFloat = 0.20;
		if((gDoubleXP) || PlayerInfo[playerid][pDoubleXP] > 0)
		{
            PlayerInfo[playerid][pEXP] += expFloat * 2;
		}
		else
		{
            PlayerInfo[playerid][pEXP] += expFloat;
		}
		SendMessage(playerid, COLOR_YELLOW, "EXP Gained:"WHITE" %.2f", expFloat);

		SendMessage(playerid, COLOR_YELLOW, "[Legal Job] You've earned "GREEN"%s"YELLOW" for your legal work, This will be added to your Paycheck! (%s Paycheck)", FormatNumber(amount), FormatNumber(PlayerInfo[playerid][pPaycheck]));

		//TODO: CAR BUSINESS
        //mysql_format(mysql_Handle, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET products = %i WHERE id = %i", BusinessInfo[businessid][bProducts], BusinessInfo[businessid][bID]);
	    //mysql_tquery(mysql_Handle, queryBuffer);

		SendClientMessage(playerid, COLOR_GREEN,"The car was successfully delivered to the car dealership. Go to the factory to load a new one");
		//SendMessage(playerid,COLOR_MAIN,"You received "CYELLOW"$%d",money);
		if(rem>0) SendMessage(playerid,-1,"For car repairs it was fined "RED"$%d",remmoney);
		af_hprem[playerid]=0;
	}
	
	if(af_player_lootstatus[playerid] && !af_player_loadready[playerid]) {
		if(!IsPlayerInAnyVehicle(playerid))
		{
			if(!IsPlayerInRangeOfPoint(playerid, 2, 2163.5369,-2246.1614,13.2902)) {
				SetPVarInt(playerid,"af_detail_upped",1);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION:25);
				SetPlayerCheckpoint(playerid, 2163.5369,-2246.1614,13.2902, 2);
				switch(af_player_cptype[playerid]) {
					case 0: SetPlayerAttachedObject(playerid, 2, 1135, 6, 0.050999, 0.178999, -0.019000, 64.199996, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
					case 1: SetPlayerAttachedObject(playerid, 2, 1130, 6, 1.020000, -0.698999, -0.531000, 61.500011, -162.900009, -173.700012, 1.000000, 1.000000, 1.000000, 0, 0);
					case 2, 3: SetPlayerAttachedObject(playerid, 2, 1152, 6, 0.263000, -0.694999, -0.960999, -25.500005, 88.200019, 12.700004, 1.000000, 1.000000, 1.000000, 0, 0);
					case 4: SetPlayerAttachedObject(playerid, 2, 1003, 6, 0.090999, -0.144999, -0.193000, -117.999969, -23.499986, -100.700019, 1.000000, 1.000000, 1.000000, 0, 0);
					case 5: SetPlayerAttachedObject(playerid, 2, 1083, 6, -0.056000, 0.427000, -0.301999, 63.400051, 0.000000, 25.300006, 1.000000, 1.000000, 1.000000, 0, 0);
				}
			}
			else {
				DeletePVar(playerid,"af_detail_upped");
				switch(af_player_cptype[playerid]) {
					case 0: af_player_obj[playerid] = CreateDynamicObject(1135, 2163.089111, -2246.921142, 13.167163, -3.199999, 0.000000, -44.299983);
					case 1: af_player_obj[playerid] = CreateDynamicObject(1130, 2161.927001, -2247.788574, 12.463508, -14.099997, 0.000000, -45.300018);
					case 2, 3: af_player_obj[playerid] = CreateDynamicObject(1152, 2161.082763, -2248.155273, 13.598916, 0.000000, 0.000000, -134.399993);
					case 4: af_player_obj[playerid] = CreateDynamicObject(1003, 2162.341796, -2247.517333, 13.180105, 8.499998, 0.000000, -134.999938);
					case 5: af_player_obj[playerid] = CreateDynamicObject(1083, 2162.969482, -2247.027832, 13.677923, 0.000000, 0.000000, -45.199958);
				}
				SetTimerEx("afmoveObj", 500, false, "ii", af_player_obj[playerid],af_player_cptype[playerid]);
				SetTimerEx("afRemoveObj", 5000, false, "i", af_player_obj[playerid]);
				RemovePlayerAttachedObject(playerid, 2);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION:0);
				af_player_detailcount[playerid] ++;

				SendMessage(playerid,-1,"The part is delivered to the conveyor. Delivered: {cccc00}%d of %d",af_player_detailcount[playerid],af_player_details[playerid]);
				
				if(af_player_detailcount[playerid] >= af_player_details[playerid]) {
					DisablePlayerCheckpoint(playerid);
					SendClientMessage(playerid,-1,"You have collected the required number of parts");
					SendClientMessage(playerid,-1,"Go outside and rent a cargo truck");
					af_player_loadready[playerid] = true;
				}
				else af_show_random_cp(playerid);
			}
		}
		
		return 1;
	}
    //to /startassemble
    if(IsPlayerInRangeOfPoint(playerid, 3, 2159.2666,-2253.6729,13.3026)) {
		DisablePlayerCheckpoint(playerid);
		return SendClientMessage(playerid,-1,"Enter {ff9945}/startassemble "WHITE"to start assembling the car");
	}


    #if defined CARF_OnPlayerEnterCheckpoint
		return CARF_OnPlayerEnterCheckpoint(playerid);
	#else
		return 1;
	#endif
}


#if defined _ALS_OnPlayerEnterCheckpoint
    #undef OnPlayerEnterCheckpoint
#else
    #define _ALS_OnPlayerEnterCheckpoint
#endif
#define OnPlayerEnterCheckpoint CARF_OnPlayerEnterCheckpoint
#if defined CARF_OnPlayerEnterCheckpoint
    forward CARF_OnPlayerEnterCheckpoint(playerid);
#endif

forward destroy_af_text(playerid);
public destroy_af_text(playerid)
{
	return DestroyDynamic3DTextLabel(af_tmp_text[playerid]);
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid) {

	if(vehicleid == af_carID[playerid] && random(2) == 0 && af_load[playerid]) {
		if(GetPVarInt(playerid, "af_delay_damage") > gettime()) return 1;
		new hpcount = Random(20, 80);
		af_hprem[playerid] += hpcount;
		new Float:vx,Float:vy,Float:vz;
		GetVehiclePos(vehicleid, vx, vy, vz);
		new str[25];
		format(str,sizeof(str),"-%d HP", hpcount);
		af_tmp_text[playerid] = CreateDynamic3DTextLabel(str, 0xFF2300FF, vx+0.067, vy-1.369, vz+1.5, 30, INVALID_PLAYER_ID, vehicleid);
		SetTimerEx("destroy_af_text", 3000, false, "i", playerid);
		SetPVarInt(playerid, "af_delay_damage", gettime() + 5);
	}

	return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid)
{
	if(PlayerInfo[playerid][pJob] == JOB_CARFACTORY && vehicleid >= af_orig_truck[0] && vehicleid <= af_orig_truck[1]) 
	{
		SetPVarInt(playerid, "time_cargoexit", 30);
        af_carID[playerid] = vehicleid;
		SendClientMessage(playerid, COLOR_RED, "You have "RED"30 "WHITE"seconds to get back on your cargo truck");
	}
    return 1;
}

hook OnGameModeInit()
{
    LoadCarFactory();
    return 1;
}

hook OnPlayerConnect(playerid)
{
    af_hprem[playerid] = 0;
	af_carID[playerid] = 0;
	af_player_loadready[playerid] = false;
	af_player_lootstatus[playerid]=false;
	af_player_status[playerid] = false;
	SetPVarInt(playerid, "veh_rent", -1);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    new veh_for_check;
	if(GetPVarInt(playerid, "veh_rent") != -1) {
		for(new i = 0; i < MAX_VEHICLES; i++) {
			if(cargo_driver[i] != playerid) continue;
			veh_for_check = i;
			if(i == af_carID[playerid] && af_load[playerid]) 
				RemoveCarFromTruckBody(playerid);
			if(i >= af_orig_truck[0] && i <= af_orig_truck[1]) 
				SetVehicleToRespawn(i);
			else DestroyVehicle(i);
			break;
		}
		if(!IsValidVehicle(veh_for_check)) {
			cargo_driver[GetPVarInt(playerid, "veh_rent")] = -1;
			SetPVarInt(playerid, "veh_rent", -1);
		}
	}   
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_ASSEMBLECAR: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					af_player_carmodel[playerid] = 565;
					af_player_details[playerid] = 10;
				}
				case 1: {
					af_player_carmodel[playerid] = 560;
					af_player_details[playerid] = 10;
				}
				case 2: {
					af_player_carmodel[playerid] = 541;
					af_player_details[playerid] = 10;
				}
				case 3: {
					af_player_carmodel[playerid] = 415;
					af_player_details[playerid] = 8;
				}
				case 4: {
					af_player_carmodel[playerid] = 451;
					af_player_details[playerid] = 6;
				}
				case 5: {
					af_player_carmodel[playerid] = 562;
					af_player_details[playerid] = 8;
				}
				case 6: {
					af_player_carmodel[playerid] = 402;
					af_player_details[playerid] = 8;
				}
				case 7: {
					af_player_carmodel[playerid] = 477;
					af_player_details[playerid] = 8;
				}
				case 8: {
					af_player_carmodel[playerid] = 506;
					af_player_details[playerid] = 8;
				}
				case 9: {
					af_player_carmodel[playerid] = 558;
					af_player_details[playerid] = 8;
				}
				case 10: {
					af_player_carmodel[playerid] = 579;
					af_player_details[playerid] = 6;
				}
				case 11: {
					af_player_carmodel[playerid] = 561;
					af_player_details[playerid] = 8;
				}
				case 12: {
					af_player_carmodel[playerid] = 559;
					af_player_details[playerid] = 8;
				}
				case 13: {
					af_player_carmodel[playerid] = 429;
					af_player_details[playerid] = 6;
				}
				case 14: {
					af_player_carmodel[playerid] = 480;
					af_player_details[playerid] = 4;
				}
				case 15: {
					af_player_carmodel[playerid] = 411;
					af_player_details[playerid] = 15;
				}
			}
			af_carList[playerid]=listitem;
			//af_player_fueltype[playerid] = af_fuel_types_num[listitem];
			//if(af_player_fueltype[playerid] == 2) af_player_details[playerid] += 2;
			PlayerPlaySound(playerid, 17000, 0.0, 0.0, 0.0);
			af_player_status[playerid] = true;
			SetPlayerCheckpoint(playerid, 2159.2666,-2253.6729,13.3026, 3);
			SendMessage(playerid, -1, "You choosed %s to assemble.", vehicleNames[af_player_carmodel[playerid] - 400]);
			SendClientMessage(playerid, -1, "Go to the 'work zone' and start assembling near the conveyor. ( follow the red marker )");
		}
    }
    return 1;
}

hook OnPlayerStateChange(playerid, PLAYER_STATE:newstate, PLAYER_STATE:oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER)
	{
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid >= af_orig_truck[0] && vehicleid <= af_orig_truck[1]) 
        {
			if(!PlayerHasJob(playerid, JOB_CARFACTORY))
			{
				RemovePlayerFromVehicle(playerid);
				return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't apart of car factory worker.");
			}
			if(GetPVarInt(playerid,"time_cargoexit") && af_carID[playerid] > 0)
			{
            	af_carID[playerid] = GetPlayerVehicleID(playerid);
				DeletePVar(playerid, "time_cargoexit");
				return 1;
			}
			if(GetPVarInt(playerid, "veh_rent") != vehicleid) {
				if(!af_player_loadready[playerid] || af_carID[playerid] > 0) {
					RemovePlayerFromVehicle(playerid);
					return SendClientMessage(playerid, -1, "You can't rent this vehicle as you haven't assembled a vehicle at the factory.");
				}
				TogglePlayerControllable(playerid, 1);

				new veh = GetPlayerVehicleID(playerid);
				af_carID[playerid] = veh;
				cargo_driver[veh] = playerid;
				SetPVarInt(playerid, "veh_rent", veh);
				SendClientMessage(playerid,COLOR_YELLOW,"Drive up to one of the loading areas and load the vehicle. Use "GREEN"/loadcar");
			}
		}
    }
    return 1;
}

hook OnVehicleSpawn(vehicleid)
{
    if(cargo_driver[vehicleid] != -1) {
		cargo_driver[vehicleid] = -1;
		if(vehicleid >= af_orig_truck[0] && vehicleid <= af_orig_truck[1]) {
			foreach(new i:Player) {
				if(GetPVarInt(i, "veh_rent") != vehicleid) continue;
				SetPVarInt(i, "veh_rent", -1);
				af_player_loadready[i] = false;
				af_player_lootstatus[i]=false;
				RemoveCarFromTruckBody(i);
				af_player_status[i] = false;
				af_carID[i] = 0;
				break;
			}
		}
		else {
			foreach(new i:Player) {
				if(GetPVarInt(i, "veh_rent") != vehicleid) continue;
				SetPVarInt(i, "veh_rent", -1);
				break;
			}
			DestroyVehicle(vehicleid);
		}
	}
    return 1;
}