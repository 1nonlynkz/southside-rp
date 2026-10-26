new LSPDButton;
new LSPDButton2;
new LSPDFirstDoor, LSPDFirstDoor2;
new LSPDSecondDoor,LSPDSecondDoor2;

// Door buttons
forward LSPDDoorOpen(playerid);
public LSPDDoorOpen(playerid)
{
	MoveDynamicObject(LSPDFirstDoor, 253.26450, 109.84320, 1002.19379, 3.5000);
	MoveDynamicObject(LSPDFirstDoor2, 253.26450, 108.34320, 1002.19379, 3.5000);
  	return 1;
}

forward LSPDDoorClose(playerid);
public LSPDDoorClose(playerid)
{
	MoveDynamicObject(LSPDFirstDoor, 253.26450, 109.06320, 1002.19379, 3.5000);
	MoveDynamicObject(LSPDFirstDoor2, 253.26450, 109.08320, 1002.19379, 3.5000);
  	return 1;
}

forward LSPDDoorOpen2(playerid);
public LSPDDoorOpen2(playerid)
{
	MoveDynamicObject(LSPDSecondDoor, 239.53050, 118.32530, 1002.19379, 3.5000);
	MoveDynamicObject(LSPDSecondDoor2, 239.53050, 116.82530, 1002.19379, 3.5000);
  	return 1;
}

forward LSPDDoorClose2(playerid);
public LSPDDoorClose2(playerid)
{
	MoveDynamicObject(LSPDSecondDoor, 239.53050, 117.60530, 1002.19379, 3.5000);
	MoveDynamicObject(LSPDSecondDoor2, 239.53040, 117.62530, 1002.19379, 3.5000);
  	return 1;
}

public OnGameModeInit()
{
    LSPDButton = CreateButton(253.01860, 110.42731, 1003.64648, 92.0);
    LSPDButton2 = CreateButton(239.74831, 116.24050, 1003.64648, 3.0);
	CreateDynamicObject(2886, 239.74831, 116.24050, 1003.64648,0.00000, 0.00000, 90.00000); // Door Button
	CreateDynamicObject(2886, 253.01860, 110.42731, 1003.64648,0.00000, 0.00000, -90.00000); // Door Button 2
	LSPDFirstDoor = CreateDynamicObject(1569, 253.26450, 109.06320, 1002.19379,   0.00000, 0.00000, 90.00000);
	LSPDFirstDoor2 = CreateDynamicObject(1569, 253.26450, 109.08320, 1002.19379,   0.00000, 0.00000, 270.00000);
	LSPDSecondDoor = CreateDynamicObject(1569, 239.53050, 117.60530, 1002.19379,   0.00000, 0.00000, 90.00000);
	LSPDSecondDoor2 = CreateDynamicObject(1569, 239.53040, 117.62530, 1002.19379,   0.00000, 0.00000, -90.00000);
	#if defined Door_OnGameModeInit
		return Door_OnGameModeInit();
	#else
		return 1;
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Door_OnGameModeInit
#if defined Door_OnGameModeInit
	forward Door_OnGameModeInit();
#endif

public OnPlayerPressButton(playerid, buttonid)
{
	if(buttonid == LSPDButton)
    {
	    if(IsLawEnforcement(playerid))
		{
			LSPDDoorOpen(playerid);
			SetTimer("LSPDDoorClose", 2000, 0);
		}
		else
		{
			return SendClientMessage(playerid, COLOR_GREY, "Access Denied");
		}
	}
   	if(buttonid == LSPDButton2)
    {
	    if(IsLawEnforcement(playerid))
		{
			LSPDDoorOpen2(playerid);
			SetTimer("LSPDDoorClose2", 2000, 0);
		}
		else
		{
			return SendClientMessage(playerid, COLOR_GREY, "Access Denied");
		}
	}
	return 1;
}