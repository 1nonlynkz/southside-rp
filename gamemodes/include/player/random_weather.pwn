// Weather system
#define WEATHER_TIME  1// 1 hr
new gCurrentWeather;

// Weather system
forward ChangeWeather();
public ChangeWeather()
{
	new gRandomWeather, gWeatherString[120];
	gRandomWeather = random(20);

	SetWeather(gRandomWeather);
	gCurrentWeather = gRandomWeather;

	format(gWeatherString, sizeof(gWeatherString), "Weather Report: Today's weather will be %s.", GetWeatherName(gRandomWeather));
	SendClientMessageToAll(COLOR_YELLOW, gWeatherString);
    return 1;
}

// Weather system
stock GetWeatherName(weatherid)
{
	new gWeatherString[100];

	switch(weatherid)
	{
		case 0: format(gWeatherString, sizeof(gWeatherString), "Extra Sunny with high visibility and moderate clouds");
		case 1: format(gWeatherString, sizeof(gWeatherString), "Sunny with high visibility and moderate clouds");
		case 2: format(gWeatherString, sizeof(gWeatherString), "Extra Sunny with high visibility and moderate clouds");
		case 3: format(gWeatherString, sizeof(gWeatherString), "Extra Sunny with high visibility and moderate clouds");
		case 4: format(gWeatherString, sizeof(gWeatherString), "Extra Sunny with high visibility and moderate clouds");
		case 5: format(gWeatherString, sizeof(gWeatherString), "Extra Sunny with high visibility and moderate clouds");
		case 6: format(gWeatherString, sizeof(gWeatherString), "Extra Sunny with high visibility and moderate clouds");
		case 7: format(gWeatherString, sizeof(gWeatherString), "Extra Sunny with high visibility and moderate clouds");
		case 8: format(gWeatherString, sizeof(gWeatherString), "Wet and Rainy with medium visibility and heavy clouds");
		case 9: format(gWeatherString, sizeof(gWeatherString), "Thick Foggy with low visibility and heavy clouds");
		case 10: format(gWeatherString, sizeof(gWeatherString), "Sunny with high visibility and moderate clouds");
		case 11: format(gWeatherString, sizeof(gWeatherString), "HeatWave with high visibility and moderate clouds");
		case 12: format(gWeatherString, sizeof(gWeatherString), "Hazy/Dull with moderate visibility and high clouds");
		case 13: format(gWeatherString, sizeof(gWeatherString), "Hazy/Dull with moderate visibility and high clouds");
		case 14: format(gWeatherString, sizeof(gWeatherString), "Hazy/Dull with moderate visibility and high clouds");
		case 15: format(gWeatherString, sizeof(gWeatherString), "Heavy RainStorm with low visibility and very thick clouds");
		case 16: format(gWeatherString, sizeof(gWeatherString), "Wet and Rainy with medium visibility and heavy clouds");
		case 17: format(gWeatherString, sizeof(gWeatherString), "Scorching Hot Bright with high visibility and low clouds");
		case 18: format(gWeatherString, sizeof(gWeatherString), "Scorching Hot Bright with high visibility and low clouds");
		case 19: format(gWeatherString, sizeof(gWeatherString), "Sand Storm with very low visibility and high clouds");
		case 20: format(gWeatherString, sizeof(gWeatherString), "Toxic Green Smog with low visibility and high clouds");
	}
	return gWeatherString;
}

public OnGameModeInit()
{
    // Weather system
    SetTimer("ChangeWeather", WEATHER_TIME * 60000 * 30, 1);
    
    #if defined Weather_OnGameModeInit
		return Weather_OnGameModeInit();
	#else
		return 1;
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Weather_OnGameModeInit
#if defined Weather_OnGameModeInit
	forward Weather_OnGameModeInit();
#endif

public OnPlayerSpawn(playerid)
{
    // Weather system
    SetPlayerWeather(playerid, gCurrentWeather);
    
	#if defined Weather_OnPlayerSpawn
		return Weather_OnPlayerSpawn(playerid);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn Weather_OnPlayerSpawn
#if defined Weather_OnPlayerSpawn
	forward Weather_OnPlayerSpawn(playerid);
#endif