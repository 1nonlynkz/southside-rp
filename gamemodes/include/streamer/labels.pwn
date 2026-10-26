#include <YSI_Coding\y_hooks>

hook OnGameModeInit()
{
	new string[128];
    CreateDynamic3DTextLabel("Allsaints General Insurance\n\nType "LIGHTRED"'/buyinsurance'"WHITE" to spawn here\nType "LIGHTRED"'/confine'"WHITE" to confine injured player\nCost: $5,000", COLOR_WHITE, 1400.3687,1614.5447,10.8303, 10.0);
	CreateDynamicPickup(1240, 1, 1400.3687,1614.5447,10.8303);

	CreateDynamic3DTextLabel("County General Insurance\n\nType "LIGHTRED"'/buyinsurance'"WHITE" to spawn here\nType "LIGHTRED"'/confine'"WHITE" to confine injured player\nCost: $5,000", COLOR_WHITE, 1152.1943,-1304.8781,1019.4307, 10.0);
	CreateDynamicPickup(1240, 1, 1152.1943,-1304.8781,1019.4307);

    CreateDynamic3DTextLabel("Paintball arena\n/enter to play paintball!", COLOR_YELLOW, 68.6118, 180.5298, 1507.2141, 10.0);
	CreateDynamicPickup(1254, 1, 68.6118, 180.5298, 1507.2141);

	CreateDynamic3DTextLabel("Butcher\nGet some meat here.\nType '/meat' to trigger.", COLOR_YELLOW, 959.3203,2136.8330,1011.0234, 5.0); // 2
	CreateDynamicPickup(1239, 1, 959.3203,2136.8330,1011.0234);

	CreateDynamic3DTextLabel("Butcher\nProcess the meat.", COLOR_YELLOW, 944.1274,2127.6245,1011.0234, 5.0); // 2
	CreateDynamicPickup(1239, 1, 944.1274,2127.6245,1011.0234);

	CreateDynamic3DTextLabel("Butcher\nDrop the meat.", COLOR_YELLOW, 960.8361,2118.1741,1011.0303, 5.0); // 2
	CreateDynamicPickup(1239, 1, 960.8361,2118.1741,1011.0303);

    // Materials Pickup 1
	CreateDynamic3DTextLabel("Materials\nCost: $75\n"SVRCLR"(( Type '/getmats' to begin. ))", COLOR_GREY, 1421.6913, -1318.4719, 13.5547, 10.0);
	CreateDynamicPickup(1575, 1, 1421.6913, -1318.4719, 13.5547);
	CreateDynamic3DTextLabel("Materials\nCost: $75\n"SVRCLR"(( Type '/getmats' to begin. ))", COLOR_GREY, 2393.4885, -2008.5726, 13.3467, 10.0);
	CreateDynamicPickup(1575, 1, 2393.4885, -2008.5726, 13.3467); // Materials Pickup 2

	CreateDynamic3DTextLabel("Loading Dock\n"SVRCLR"(( Type '/loadtruck' and pick a load to begin delivery. ))", COLOR_GREY, 2460.9790,-2119.2590,13.5530, 10.0);
	CreateDynamicPickup(1239, 1, 2460.9790,-2119.2590,13.5530);

	CreateDynamic3DTextLabel("Drivers Test\nCost: $100\n"SVRCLR"(( Type '/taketest' to begin. ))", COLOR_GREY, -2039.2168, -123.6363, -50.9141, 10.0);
	CreateDynamicPickup(1239, 1, -2039.2168, -123.6363, -50.9141);

	/*CreateDynamic3DTextLabel("Grotti Dealership\n"SVRCLR"(( Type '/buyvehicle' to view catalog. ))", COLOR_GREY, 542.0433, -1293.5909, 17.2422, 10.0);
	CreateDynamicPickup(1274, 1, 542.0433, -1293.5909, 17.2422);*/

	CreateDynamic3DTextLabel("Boat Dealership\n"SVRCLR"(( Type '/buyvehicle' to view catalog. ))", COLOR_GREY, 154.2223, -1946.3030, 5.1920, 10.0);
	CreateDynamicPickup(1274, 1, 154.2223, -1946.3030, 5.1920);

	CreateDynamic3DTextLabel("Aircraft Dealership\n"RED"Temporary Disabled", COLOR_GREY, 1892.6315, -2328.6721, 13.5469, 10.0);
	CreateDynamicPickup(1274, 1, 1892.6315, -2328.6721, 13.5469);

	CreateDynamic3DTextLabel("Name Changes\nCost: $15,000 per level", COLOR_GREY, -1449.515014, 1452.621215, 11.375673, 10.0);
    CreateDynamicPickup(1239, 1, -1449.515014, 1452.621215, 11.375673);

	CreateDynamic3DTextLabel("Microphone\n"SVRCLR"(( Type '/mic' to use this microphone. ))", COLOR_GREY, 1082.1001,-1740.0272,14.1402, 10.0);
	CreateDynamicPickup(1239, 1, 1082.1001,-1740.0272,14.1402);

	CreateDynamicPickup(1239, 1, 2316.5469, -1403.3070, 21.8769); // els
	CreateDynamic3DTextLabel("Dirty Money\n"SVRCLR"(( Type /washmoney to wash the money. ))", COLOR_GREY, 2316.5469, -1403.3070, 21.8769, 10.0);

	CreateDynamicPickup(1239, 1, 1477.8975, -1639.1193, 14.1484); // ps
	CreateDynamic3DTextLabel("Dirty Money\n"SVRCLR"(( Type /washmoney to wash the money. ))", COLOR_GREY, 1477.8975, -1639.1193, 14.1484, 10.0);

	CreateDynamicPickup(1239, 1, 1971.9369,-1201.2697,17.4500); // gp
	CreateDynamic3DTextLabel("Dirty Money\n"SVRCLR"(( Type /washmoney to wash the money. ))", COLOR_GREY, 1971.9369,-1201.2697,17.4500, 10.0);

	CreateDynamicPickup(1239, 1, 882.8823,-1721.1710,12.9217); // vb
	CreateDynamic3DTextLabel("Dirty Money\n"SVRCLR"(( Type /washmoney to wash the money. ))", COLOR_GREY, 882.8823,-1721.1710,12.9217, 10.0);

	CreateDynamicPickup(1239, 1, 897.0015,-1101.4503,23.2969); // cemetery
	CreateDynamic3DTextLabel("Dirty Money\n"SVRCLR"(( Type /washmoney to wash the money. ))", COLOR_GREY, 897.0015,-1101.4503,23.2969, 10.0);

	CreateDynamic3DTextLabel("Drug Smuggling\nCost: $75\n"SVRCLR"(( Type '/getcrate' to begin smuggling. ))", COLOR_GREY, 415.5813,-1726.8542,9.0025, 10.0);
	CreateDynamicPickup(1279, 1, 415.5813,-1726.8542,9.0025);

	CreateDynamic3DTextLabel("Meth Cookoff\n> Requires Ephedrine <\n"SVRCLR"(( Type '/cookmeth' to begin cooking. ))", COLOR_GREY, 333.5727, 1121.8536, 1083.8903, 10.0);
	CreateDynamicPickup(1577, 1, 333.5727, 1121.8536, 1083.8903);
	
	CreateDynamic3DTextLabel("Bank\n"SVRCLR"(( Type '/bankhelp' for more help. ))", COLOR_GREY, 1503.6335, 1340.8419, 10.9900, 10.0);
    CreateDynamicPickup(1239, 1, 1503.6335, 1340.8419, 10.9900);

	gSeedsStockText = CreateDynamic3DTextLabel("Marijuana Seeds\nStock: 100\n"SVRCLR"(( Type '/getdrug seeds [amount]' ))", COLOR_GREY, 323.7289, 1117.4187, 1083.8828, 10.0);
	CreateDynamicPickup(1578, 1, 323.7289, 1117.4187, 1083.8828);

	gEphedrineStockText = CreateDynamic3DTextLabel("Raw Ephedrine\nStock: 100\n"SVRCLR"(( '/getdrug ephedrine [amount]' ))", COLOR_GREY, 321.6007, 1117.3717, 1083.8828, 10.0);
	CreateDynamicPickup(1577, 1, 321.6007, 1117.3717, 1083.8828);

	gCrackText = CreateDynamic3DTextLabel("Crack\nStock: 100\n"SVRCLR"(( Type '/getdrug Crack [amount]' ))", COLOR_GREY, 2345.8250,-1185.5159,1031.9766, 10.0);
    CreateDynamicPickup(1575, 1, 2345.8250,-1185.5159,1031.9766);
    
    CreateDynamic3DTextLabel("BLACKMARKET\n{FFFFFF}/blackmarket to purchase illegal.", COLOR_YELLOW, 162.2012, -178.4594, 1.5836, 10.0);

	// - PLATE REGISTRATION CENTER
	CreateDynamicPickup(1581, 1, 2501.0352, -1946.1055, 13.4937);
	CreateDynamic3DTextLabel("(( Type '/registercar' to get a plate number for your vehicle. ))", SERVER_COLOR, 2501.0352, -1946.1055, 13.4937 + 0.4, 15.0);
 
    CreateDynamic3DTextLabel("Chop Car\nType '/chopcar' to chop this vehicle", COLOR_GREY, -52.6129,-1141.9277,1.0781, 5.0);

	// Vip Lounge
    CreateDynamic3DTextLabel("Vip Locker\nType /viplocker to access donator info", COLOR_GREY, 2556.2119, 1403.9261, 7699.5844, 10.0);

    gParachutes[0] = CreateDynamicPickup(371, 1, 1542.9038, -1353.0352, 329.4744); // Star tower
	gParachutes[1] = CreateDynamicPickup(371, 1, 315.9415, 1010.6052, 1953.0031); // Andromada interior
	
	/*for(new i = 0; i < sizeof(comservpoint); i ++)
	{
		//CreateDynamicPickup(19132, 1, comservpoint[i][0], comservpoint[i][1], comservpoint[i][2]);
		CreateDynamic3DTextLabel("Community Service\n"SVRCLR"(( Type '/clean' to start cleaning. ))", COLOR_GREY, comservpoint[i][0], comservpoint[i][1], comservpoint[i][2], 10.0);
	}*/
	
	for(new i = 0; i < sizeof(farmingPositions); i ++)
	{
	    CreateDynamic3DTextLabel("(( Press 'N' to begin farming. ))", COLOR_YELLOW, farmingPositions[i][0], farmingPositions[i][1], farmingPositions[i][2], 25.0);
	}
	
	for(new i = 0; i < sizeof(minerPositions); i ++)
	{
	    CreateDynamic3DTextLabel("(( Press 'N' to begin mining rocks. ))", COLOR_YELLOW, minerPositions[i][0], minerPositions[i][1], minerPositions[i][2], 25.0);
	}

	for(new i = 0; i < sizeof(jobLocations); i ++)
    {
        format(string, sizeof string, "%s\n"WHITE"Press 'N' to interact", jobLocations[i][jobName]);
        CreateDynamic3DTextLabel(string, COLOR_WHITE, jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ], 10.0, .testlos = 1, .streamdistance = 10.0);
        CreateActor(jobLocations[i][jobActor], jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ], jobLocations[i][JobA]);
    }

	for(new i = 0; i < sizeof(FuelStation); i ++)
	{
		CreateDynamicPickup(1650, 1, FuelStation[i][FuelX], FuelStation[i][FuelY], FuelStation[i][FuelZ]);
	    CreateDynamic3DTextLabel("Fuel Station\n"SVRCLR"(( Type '/refuel' to refill. ))", COLOR_GREY, FuelStation[i][FuelX], FuelStation[i][FuelY], FuelStation[i][FuelZ] + 0.4, 12.0);
	}

	CreateDynamic3DTextLabel("Before you enter you need "GREEN"$500"GREY" to pass this gate\n"SVRCLR"(( Type '/pass' to open the toll gate. ))",COLOR_GREY, 52.789,-1538.231,5.003,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
	CreateDynamic3DTextLabel("Before you enter you need "GREEN"$500"GREY" to pass this gate\n"SVRCLR"(( Type '/pass' to open the toll gate. ))",COLOR_GREY, 56.351,-1526.141,4.884,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
	CreateDynamic3DTextLabel("Before you enter you need "GREEN"$500"GREY" to pass this gate\n"SVRCLR"(( Type '/pass' to open the toll gate. ))",COLOR_GREY, 1809.4454,811.5417,10.8997,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
	CreateDynamic3DTextLabel("Before you enter you need "GREEN"$500"GREY" to pass this gate\n"SVRCLR"(( Type '/pass' to open the toll gate. ))",COLOR_GREY, 1783.6510,803.8441,11.0599,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
	CreateDynamic3DTextLabel("Before you enter you need "GREEN"$500"GREY" to pass this gate\n"SVRCLR"(( Type '/pass' to open the toll gate. ))",COLOR_GREY, 50.1882,-1282.9015,14.0709,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
	CreateDynamic3DTextLabel("Before you enter you need "GREEN"$500"GREY" to pass this gate\n"SVRCLR"(( Type '/pass' to open the toll gate. ))",COLOR_GREY, 68.1923,-1304.1959,12.4487,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
	CreateDynamic3DTextLabel("Before you enter you need "GREEN"$500"GREY" to pass this gate\n"SVRCLR"(( Type '/pass' to open the toll gate. ))",COLOR_GREY, 517.2233,472.0292,18.9297,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
	CreateDynamic3DTextLabel("Before you enter you need "GREEN"$500"GREY" to pass this gate\n"SVRCLR"(( Type '/pass' to open the toll gate. ))",COLOR_GREY, 523.5045,473.5910,18.9297,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
	CreateDynamic3DTextLabel("Before you enter you need "GREEN"$500"GREY" to pass this gate\n"SVRCLR"(( Type '/pass' to open the toll gate. ))",COLOR_GREY, -169.2154,374.7297,12.0781,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
	CreateDynamic3DTextLabel("Before you enter you need "GREEN"$500"GREY" to pass this gate\n"SVRCLR"(( Type '/pass' to open the toll gate. ))",COLOR_GREY, -163.9199,370.8330,12.0781,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
    return 1;
}