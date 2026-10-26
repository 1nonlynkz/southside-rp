task FuelTimer[75000]()
{
    foreach(new i: Vehicle)
    {
        if(VehicleHasEngine(i) && GetVehicleParams(i, VEHICLE_ENGINE))
        {
            if(vehicleFuel[i] > 0)
            {
                vehicleFuel[i] -= (1 + random(3)); 

                if(vehicleFuel[i] < 0) vehicleFuel[i] = 0;

                switch(vehicleFuel[i])
                {
                    case 17, 15, 10, 7, 5:
                    {
                        SendClientMessage(GetVehicleDriver(i), COLOR_YELLOW, "* This vehicle is running low on fuel. Visit the nearest gas station to fill up. (/refuel)");
                    }
                }
            }
            
            if(vehicleFuel[i] <= 0)
            {
                SetVehicleParams(i, VEHICLE_ENGINE, false);
            }
        }
    }
}

ptask InjuredTimer[5000](playerid)
{
	if(PlayerInfo[playerid][pLogged] && PlayerInfo[playerid][pInjured] && GetVehicleModel(GetPlayerVehicleID(playerid)) != 416)
	{
		new Float:health;
		GetPlayerHealth(playerid, health);
		SetPlayerHealth(playerid, health - 1.0);
	}
}

ptask RandomFire[3600000](check)
{
	new count, index, announced, rand = random(10);

	if(!IsFireActive())
	{
	    if(check)
	    {
			foreach(new i : Player)
			{
			    if(GetFactionType(i) == FACTION_MEDIC)
		    	{
		        	count++;
	        	}
	    	}
	    }
	    else
	    {
	        count = 3;
	    }

	    if(count >= 3)
	    {
	        for(new i = 0; i < sizeof(randomFireSpawns); i ++)
	        {
	            if(randomFireSpawns[i][fireIndex] == rand)
	            {
	                if(!announced)
	                {
	                    foreach(new x : Player)
	                    {
	                        if(IsPlayerInRangeOfPoint(x, 30.0, randomFireSpawns[i][fireX], randomFireSpawns[i][fireY], randomFireSpawns[i][fireZ]))
	                        {
	                            SendClientMessage(x, COLOR_PURPLE, "** An explosion can be heard. Smoke is rising from a building nearby.");
	                        }
	                        if(GetFactionType(x) == FACTION_MEDIC)
	                        {
	                            PlayerInfo[x][pCP] = CHECKPOINT_MISC;
	                            SetPlayerCheckpoint(x, randomFireSpawns[i][fireX], randomFireSpawns[i][fireY], randomFireSpawns[i][fireZ], 3.0);
	                            SendMessage(x, COLOR_DOCTOR, "** All units, a fire has been reported in %s. Please head to the beacon on your map. **", GetZoneName(randomFireSpawns[i][fireX], randomFireSpawns[i][fireY], randomFireSpawns[i][fireZ]));
							}
	                    }

						announced = 1;
					}

	                gFireObjects[index] = CreateDynamicObject(18691, randomFireSpawns[i][fireX], randomFireSpawns[i][fireY], randomFireSpawns[i][fireZ], 0.0, 0.0, randomFireSpawns[i][fireA], .streamdistance = 50.0);
	                gFireHealth[index++] = 50.0;
	            }
	        }

	        gFires = index;
	    }
	}
}

// TickRate: 1 Second
task MiscTimer[1000]()
{
	for(new i = 0; i < MAX_ACTORS; i ++)
	{
	    if(IsValidActor(i))
	    {
	        new Float:x, Float:y, Float:z;

	        GetActorPos(i, x, y, z);
	        SetActorPos(i, x, y, z);
	    }
	}

    new string[128];
    if(IsValidDynamic3DTextLabel(gSeedsStockText))
	{
	    format(string, sizeof(string), "Marijuana Point\nStock: %i/500 Seeds\nType /getdrug seeds [amount]", gSeedsStock);
	    UpdateDynamic3DTextLabelText(gSeedsStockText, COLOR_WHITE, string);
	}
	
	if(IsValidDynamic3DTextLabel(gEphedrineStockText))
	{
	    format(string, sizeof(string), "Ephedrine Point\nStock: %i/500 Grams\nType /getdrug ephedrine [amount]", gEphedrineStock);
	    UpdateDynamic3DTextLabelText(gEphedrineStockText, COLOR_WHITE, string);
	}
	
	if(IsValidDynamic3DTextLabel(gCrackText))
	{
	    format(string, sizeof(string), "Crack Point\nStock: %i/500 Grams\nType /getdrug crack [amount]", gCrackStock);
	    UpdateDynamic3DTextLabelText(gCrackText, COLOR_WHITE, string);
	}


	if(Iter_Count(Player) > gPlayerRecord)
	{
		gPlayerRecord = Iter_Count(Player);
		gRecordDate = GetDate();
		SaveServerInfo();
	}
}

ptask SecondTimer[1000](i) 
{
	new boomboxid, string[128 * 2];
	if(PlayerInfo[i][pLogged] && !PlayerInfo[i][pKicked])
    {
		if(PlayerInfo[i][pLoadShipment] > 1) {
            format(string, sizeof(string), "~g~Loading Shipment...~n~~w~Complete in %d seconds...", PlayerInfo[i][pLoadShipment]);
            GameTextForPlayer(i, string, 1000, 4);
            PlayerInfo[i][pLoadShipment] --;
        }
		if(PlayerInfo[i][pLogged] && !PlayerInfo[i][pKicked])
		{
		    AFKCheck(i);
			AntiCarSurf(i);
			SavePlayerWeapons(i);
			ComServ(i);

			/*if(!PlayerInfo[i][pSetup])
			{
				if(strcmp(PlayerInfo[i][pDiscord], "None", true) == 0)
				{
					SetPlayerVirtualWorld(i, 0);
					if(!IsPlayerInRangeOfPoint(i, 5.0, 1449.8221,-2287.0125,13.5469))
					{
						SetPlayerPos(i, 1449.8221,-2287.0125,13.5469);
					}
				}
			}*/


			if(PlayerInfo[i][pLogged] && PlayerInfo[i][pAFKTime] < 900)
			{
				PlayerInfo[i][pPlayingTime]++; // Count the player time
			}
		    
            new Float:vhp;
			for(new vehicleid; vehicleid<MAX_VEHICLES;vehicleid++)
			{
				if(GetVehicleModel(vehicleid) == 0) continue;
				GetVehicleHealth(vehicleid,vhp);
				if(vhp < 300.0) {
					SetVehicleParams(vehicleid, VEHICLE_ENGINE, false);
					SetVehicleHealth(vehicleid, 251.0);
				}
			}
	    	if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
			{ 
				new vehicleid = GetPlayerVehicleID(i);
				if(GetPlayerState(i) == PLAYER_STATE_DRIVER && VehicleHasEngine(vehicleid))
			    {
					for(new x = 0; x < MAX_DEPLOYABLES; x++)
					{
					    if(DeployInfo[x][dExists] && DeployInfo[x][dType] == DEPLOY_SPIKESTRIP && IsPlayerInRangeOfPoint(x, 3.0, DeployInfo[x][dPosX], DeployInfo[x][dPosY], DeployInfo[x][dPosZ]))
				        {
				            new
				                VEHICLE_PANEL_STATUS:panels,
				                VEHICLE_DOOR_STATUS:doors,
				                VEHICLE_LIGHT_STATUS:lights,
				                VEHICLE_TYRE_STATUS:tires;

				            GetVehicleDamageStatus(vehicleid, panels, doors, lights, VEHICLE_TYRE_STATUS:tires);
				            UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, VEHICLE_TYRE_STATUS:15);
				        }
					}
				}
			}
			
	        if(PlayerInfo[i][pCapturingPoint] >= 0)
			{
				PlayerInfo[i][pCaptureTime]--;

				if(PlayerInfo[i][pCaptureTime] <= 0)
				{
					new Float:x, Float:y, Float:z;
					GetPlayerPos(i, x, y, z);

					if(PointInfo[PlayerInfo[i][pCapturingPoint]][pTime] == 0 && PlayerInfo[i][pPointX] == x && PlayerInfo[i][pPointY] == y && PlayerInfo[i][pPointZ] == z)
					{
						SendMessageToAll(COLOR_GREEN, "%s attempted to capture %s for %s. It will be theirs in 10 minutes.", GetRPName(i), PointInfo[PlayerInfo[i][pCapturingPoint]][pName], GangInfo[PlayerInfo[i][pGang]][gName]);

						PointInfo[PlayerInfo[i][pCapturingPoint]][pCaptureTime] = 10;
						PointInfo[PlayerInfo[i][pCapturingPoint]][pCapturer] = i;
					}
					else
					{
						SendClientMessage(i, COLOR_SYNTAX, "You moved from your position and therefore failed to capture.");
					}

					PlayerInfo[i][pCapturingPoint] = -1;
					PlayerInfo[i][pCaptureTime] = 0;
				}
			}
			if(PlayerInfo[i][pAdminDuty])
			{
				SetPlayerSpecialTag(i, TAG_ADMIN);
			}
			else
			{
				SetPlayerSpecialTag(i, TAG_NORMAL);
			}
			if(PlayerInfo[i][pLoopAnim] && !PlayerInfo[i][pToggleTextdraws])
			{
				TextDrawShowForPlayer(i, AnimationTD);
		    }
			else
			{
		        TextDrawHideForPlayer(i, AnimationTD);
		    }
			if (PlayerInfo[i][pSpeedTime] > 0)
			{
			    PlayerInfo[i][pSpeedTime]--;
			}
		    if(PlayerInfo[i][pShipment] >= 0)
			{
				if((GetPlayerState(i) == PLAYER_STATE_DRIVER) && (GetVehicleModel(GetPlayerVehicleID(i)) != 414 && GetVehicleModel(GetPlayerVehicleID(i)) != 456))
				{
			    	PlayerInfo[i][pShipment] = -1;
			    	SendClientMessage(i, COLOR_SYNTAX, "Shipment cancelled. You went into another vehicle.");
				}
		    }

		    if(PlayerInfo[i][pPizzas] > 0 && GetPlayerState(i) == PLAYER_STATE_DRIVER)
			{
				if(GetVehicleModel(GetPlayerVehicleID(i)) == 448)
				{
				    if(PlayerInfo[i][pPizzaTime] < 90)
					{
						PlayerInfo[i][pPizzaTime]++;
					}
				}
				else
				{
				    PlayerInfo[i][pPizzas] = 0;
				    PlayerInfo[i][pCP] = 0;

				    DisablePlayerCheckpoint(i);
				    SendClientMessage(i, COLOR_SYNTAX, "Pizza delivery cancelled. You went into another vehicle.");
				}
			}

			if (!PlayerInfo[i][pToggleTextdraws]) 
			{
			    if (PlayerInfo[i][pGPSOn])
			    {
			        if (GetPlayerState(i) == PLAYER_STATE_SPECTATING)
			        {
			            HideGPSTextdraw(i);
			        }
			        else 
			        {
			            new Float:rz;
			            if (IsPlayerInAnyVehicle(i)) 
			            {
			                GetVehicleZAngle(GetPlayerVehicleID(i), rz);
			            }
			            else 
			            {
			                GetPlayerFacingAngle(i, rz);
			            }
			
			            // REAL-TIME ZONE UPDATER
			            new gpsstr[128];
			            format(gpsstr, sizeof(gpsstr), "%s", GetPlayerZoneName(i));
			            PlayerTextDrawSetString(i, GPS[i][0], gpsstr);
			        }
			    }
			}

		
		    // DESYNC PACKET LOSS CHECK
		    if(Float:NetStats_PacketLossPercent(i) > 20.0 && (gettime() - PlayerInfo[i][pLastDesync]) > 120)
		    {
		        SendClientMessage(i, 0xAAC4E5FF, "You are desynced. You are advised to relog once you see this message.");
		        PlayerInfo[i][pLastDesync] = gettime();
		    }
		

		    if(PlayerInfo[i][pSpectating] != INVALID_PLAYER_ID)
		    {
		        if(GetPlayerInterior(i) != GetPlayerInterior(PlayerInfo[i][pSpectating])) SetPlayerInterior(i, GetPlayerInterior(PlayerInfo[i][pSpectating]));
		        if(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(PlayerInfo[i][pSpectating])) SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(PlayerInfo[i][pSpectating]));
		    }
		    if(PlayerInfo[i][pTutorial])
		    {
		        TogglePlayerControllable(i, 0);
		    }
			if(PlayerInfo[i][pDraggedBy] != INVALID_PLAYER_ID)
			{
	    		TeleportToPlayer(i, PlayerInfo[i][pDraggedBy]);
			}
			if(PlayerInfo[i][pVIPPackage] > 0 && gettime() > PlayerInfo[i][pVIPTime])
			{
			    PlayerInfo[i][pVIPPackage] = 0;
			    PlayerInfo[i][pVIPTime] = 0;
			    PlayerInfo[i][pSecondJob] = -1;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = 0, viptime = 0, secondjob = -1 WHERE uid = %i", PlayerInfo[i][pID]);
			    mysql_tquery(connectionID, queryBuffer);
			}
			if(PlayerInfo[i][pVIPPackage] < 1 && PlayerInfo[i][pSecondJob] != JOB_NONE)
			{
			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET secondjob = -1 WHERE uid = %i", PlayerInfo[i][pID]);
			    mysql_tquery(connectionID, queryBuffer);

			    PlayerInfo[i][pSecondJob] = JOB_NONE;
			    SendClientMessage(i, COLOR_LIGHTRED, "Your second job has been removed as you don't have a Donator subscription.");
			}

			if(PlayerInfo[i][pCarLicense] > 0 && gettime() > PlayerInfo[i][pCarLicenseDate])
			{
			    PlayerInfo[i][pCarLicense] = 0;
			    PlayerInfo[i][pCarLicenseDate] = 0;
			    PlayerInfo[i][pCarLicenseCode] = 0;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carlicense = 0, carlicensedate = 0, carlicensecode = 0 WHERE uid = %i", PlayerInfo[i][pID]);
			    mysql_tquery(connectionID, queryBuffer);
			}
			if(PlayerInfo[i][pWeaponLicense] > 0 && gettime() > PlayerInfo[i][pWeaponLicenseDate])
			{
			    PlayerInfo[i][pWeaponLicense] = 0;
			    PlayerInfo[i][pWeaponLicenseDate] = 0;
			    PlayerInfo[i][pWeaponLicenseCode] = 0;

			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET gunlicense = 0, gunlicensedate = 0, gunlicensecode = 0 WHERE uid = %i", PlayerInfo[i][pID]);
			    mysql_tquery(connectionID, queryBuffer);
			}

			if(PlayerInfo[i][pFirstAid])
			{
				new
				    Float:health;

				GetPlayerHealth(i, health);

				if((health + 1.0) > 100.0)
				{
				    SetPlayerHealth(i, 100.0);
				    PlayerInfo[i][pFirstAid] = 0;
				}
				else
				{
				    SetPlayerHealth(i, health + 1.0);
				}
			}
			if(PlayerInfo[i][pTazedTime] > 0)
			{
			    PlayerInfo[i][pTazedTime]--;

			    if(!PlayerInfo[i][pTazedTime])
			    {
			        ClearAnimations(i);
			        TogglePlayerControllable(i, 1);
			    }
			}
			if(PlayerInfo[i][pHurt] > 0)
			{
				PlayerInfo[i][pHurt]--;
			}
			if(PlayerInfo[i][pFishTime] > 0)
			{
			    PlayerInfo[i][pFishTime]--;

				if(!IsPlayerAtFishingPlace(i))
				{
				    ClearAnimations(i);
				    RemovePlayerAttachedObject(i, 9);
				    PlayerInfo[i][pFishTime] = 0;
				}
			    else if(PlayerInfo[i][pFishTime] <= 0 && IsPlayerAtFishingPlace(i))
			    {
	          		new rand = Random(1, 100);

					if(1 <= rand <= 20)
	    			{
	 	   				SendClientMessage(i, COLOR_SYNTAX, "You reeled in your line and caught nothing...");
					}
					else if(21 <= rand <= 30)
					{
	    				new amount = 10 + random(50);

		    			SendMessage(i, COLOR_WHITE, "You reeled in your line and caught a used wallet with $%i inside.", amount);
						GivePlayerCash(i, amount);
					}
					else if(98 <= rand <= 99)
					{
					    new amount = random(10) + 100;

					    SendMessage(i, COLOR_WHITE, "You reeled in your line and caught a rare 18th century coin valued at $%i!", amount);
						GivePlayerCash(i, amount);
					}
					else
					{
					    new weight;

					    if(PlayerInfo[i][pUsedBait])
						{
							weight = random(15);
					    }
						else
						{
					        weight = random(10);
	    		        }

	    		        SendMessage(i, COLOR_WHITE, "You reeled in your line and caught a fish weighing %i kg!", weight);
						PlayerInfo[i][pFishWeight] += weight;

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET fishweight = %i WHERE uid = %i", PlayerInfo[i][pFishWeight], PlayerInfo[i][pID]);
						mysql_tquery(connectionID, queryBuffer);

						IncreaseJobSkill(i, JOB_FISHERMAN);

	    				if(GetJobLevel(i, JOB_FISHERMAN) < 5)
	    				{
	        				if(PlayerInfo[i][pFishingSkill] < 50) {
	        					SendMessage(i, COLOR_YELLOW, "You need to catch %i more fish in order to level up.", 50 - PlayerInfo[i][pFishingSkill]);
	        				} else if(PlayerInfo[i][pFishingSkill] < 100) {
	        					SendMessage(i, COLOR_YELLOW, "You need to catch %i more fish in order to level up.", 100 - PlayerInfo[i][pFishingSkill]);
	        				} else if(PlayerInfo[i][pFishingSkill] < 200) {
	        					SendMessage(i, COLOR_YELLOW, "You need to catch %i more fish in order to level up.", 200 - PlayerInfo[i][pFishingSkill]);
            				} else if(PlayerInfo[i][pFishingSkill] < 350) {
	        					SendMessage(i, COLOR_YELLOW, "You need to catch %i more fish in order to level up.", 350 - PlayerInfo[i][pFishingSkill]);
							}
						}
						else
						{
							//
						}

						if(GetJobLevel(i, JOB_FISHERMAN) == 1)
						{
							if(PlayerInfo[i][pFishWeight] >= 50)
		    		        {
		    		            SendClientMessage(i, COLOR_YELLOW, "You have too much fish. You can continue fishing once you sell your load.");
		    		        }
						}
						if(GetJobLevel(i, JOB_FISHERMAN) == 2)
						{
							if(PlayerInfo[i][pFishWeight] >= 100)
		    		        {
		    		            SendClientMessage(i, COLOR_YELLOW, "You have too much fish. You can continue fishing once you sell your load.");
		    		        }
						}
						if(GetJobLevel(i, JOB_FISHERMAN) == 3)
						{
							if(PlayerInfo[i][pFishWeight] >= 150)
		    		        {
		    		            SendClientMessage(i, COLOR_YELLOW, "You have too much fish. You can continue fishing once you sell your load.");
		    		        }
						}
						if(GetJobLevel(i, JOB_FISHERMAN) == 4)
						{
							if(PlayerInfo[i][pFishWeight] >= 200)
		    		        {
		    		            SendClientMessage(i, COLOR_YELLOW, "You have too much fish. You can continue fishing once you sell your load.");
		    		        }
						}
						if(GetJobLevel(i, JOB_FISHERMAN) == 5)
						{
							if(PlayerInfo[i][pFishWeight] >= 250)
		    		        {
		    		            SendClientMessage(i, COLOR_YELLOW, "You have too much fish. You can continue fishing once you sell your load.");
		    		        }
						}
					}

					ClearAnimations(i);
					RemovePlayerAttachedObject(i, 9);
			    }
			}
			if(PlayerInfo[i][pJailType] > 0)
			{
			    PlayerInfo[i][pJailTime]--;

			    if(PlayerInfo[i][pJailTime] <= 0)
			    {
			        ResetPlayerWeaponsEx(i);

			        SendClientMessage(i, COLOR_GREY, "Your jail sentence has expired.");
			        SetPlayerPos(i, 1544.4407, -1675.5522, 13.5584);
					SetPlayerFacingAngle(i, 90.0000);
					SetPlayerInterior(i, 0);
					SetPlayerVirtualWorld(i, 0);
					SetCameraBehindPlayer(i);

					PlayerInfo[i][pJailType] = 0;
			        PlayerInfo[i][pJailTime] = 0;
				}
			}
		
			if(PlayerInfo[i][pInjured])
			{
			    if(PlayerInfo[i][pRespawnTimer] >= 1) PlayerInfo[i][pRespawnTimer] --;
			    
			    format(string, sizeof(string), "Respawn available in ~g~%s~n~~w~Press ~r~Y~w~ to signal a distress ~g~and~w~ Press ~y~N~w~ to accept death", TimeConvert(PlayerInfo[i][pRespawnTimer]));
			    PlayerTextDrawSetString(i, InjuredTD[i], string);
			    PlayerTextDrawShow(i, InjuredTD[i]);
			}
			
			if(PlayerInfo[i][pHospital] && PlayerInfo[i][pHospitalTime])
			{
				format(string, sizeof(string), "~p~Hospital Bed~n~~w~You will respawn in ~r~%s.", TimeConvert(PlayerInfo[i][pHospitalTime]));
				PlayerTextDrawSetString(i, RecoverTD[i], string);
				PlayerTextDrawShow(i, RecoverTD[i]);
			}
			if(PlayerInfo[i][pHospital] && PlayerInfo[i][pHospitalTime])
			{
			    PlayerInfo[i][pHospitalTime]--;
			    ApplyAnimation(i, "SWAT", "gnstwall_injurd", 4.0, true, false, false, false, 0, SYNC_ALL);
			
			    if(PlayerInfo[i][pHospitalTime] == 0)
			    {
			        if(PlayerInfo[i][pDelivered])
			        {
			            GivePlayerCash(i, -150);
			            SendClientMessage(i, COLOR_DOCTOR, "You have been billed $150 for your stay. Your items are safe!");
			            PlayerInfo[i][pDelivered] = 0;
			        }
			        else
			        {
			            GivePlayerCash(i, -250);
			        }
			       
			        PlayerTextDrawHide(i, RecoverTD[i]);
			        PlayerTextDrawHide(i, InjuredTD[i]);
			        UpdateDynamic3DTextLabelText(InjuredLabel[i], COLOR_DOCTOR, "");
			        ClearAnimations(i);
			        ResetDamages(i);
			        TogglePlayerControllable(i, true); // I-unfreeze ang player pagkalabas ng ospital
			
			        switch(PlayerInfo[i][pHospitalType])
			        {
			            case HOSPITAL_ALLSAINTS: 
			            {
			                SendClientMessage(i, COLOR_LIGHTRED, "Allsaints General: "WHITE"You have been billed $250 for your stay. Your illegal items have been confiscated by staff.");
			                SendClientMessage(i, COLOR_WHITE, "You have lost 30 minutes of your memory.");
			
			                SetPlayerInterior(i, 0);
			                SetPlayerVirtualWorld(i, 0);
			                SetPlayerPos(i, 1177.3486, -1323.8340, 14.1168);
			                SetCameraBehindPlayer(i);
			            }
			            case HOSPITAL_COUNTY: 
			            {
			                SendClientMessage(i, COLOR_LIGHTRED, "County General: "WHITE"You have been billed $250 for your stay. Your illegal items have been confiscated by staff.");
			                SendClientMessage(i, COLOR_WHITE, "You have lost 30 minutes of your memory.");
			
			                SetPlayerInterior(i, 0);
			                SetPlayerVirtualWorld(i, 0);
			                SetPlayerPos(i, 2033.4258, -1413.4354, 16.9922); 
			                SetCameraBehindPlayer(i);
			            }
			            default:
			            {
			                SetPlayerInterior(i, 0);
			                SetPlayerVirtualWorld(i, 0);
			                SetPlayerToSpawn(i);
			            }
			        }
			
			        if(PlayerInfo[i][pVIPPackage] == 0)
			        {
			            SetPlayerHealth(i, PlayerInfo[i][pSpawnHealth]);
			            SetScriptArmour(i, PlayerInfo[i][pSpawnArmor]);
			        }
			        else
			        {
			            SetPlayerHealth(i, 100.0);
			        }
			
			        PlayerInfo[i][pHospital] = 0;
			        PlayerInfo[i][pHospitalTime] = 0;
			        PlayerInfo[i][pInjured] = 0;
			    }
			}

			if(PlayerInfo[i][pTaxiPassenger] != INVALID_PLAYER_ID)
			{
			    if((GetVehicleModel(GetPlayerVehicleID(i)) != 420 && GetVehicleModel(GetPlayerVehicleID(i)) != 438) || !IsPlayerInVehicle(PlayerInfo[i][pTaxiPassenger], GetPlayerVehicleID(i)) || PlayerInfo[i][pTaxiFare] == 0 || PlayerInfo[PlayerInfo[i][pTaxiPassenger]][pCash] < PlayerInfo[i][pTaxiBill])
			    {
			        CancelTaxiRide(i);
			    }
			    else
			    {
			        PlayerInfo[i][pTaxiTime]++;

			        if(PlayerInfo[i][pTaxiTime] >= 15)
			        {
			            PlayerInfo[i][pTaxiTime] = 0;
			            PlayerInfo[i][pTaxiBill] += PlayerInfo[i][pTaxiFare];
					}

					format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~g~Taxi Meter:~w~ $%i", PlayerInfo[i][pTaxiBill]);
					GameTextForPlayer(i, string, 3000, 3);
			    }
			}
			if(PlayerInfo[i][pMuted] > 0)
			{
			    PlayerInfo[i][pMuted]--;

			    if(PlayerInfo[i][pMuted] <= 0)
			    {
			        SendClientMessage(i, SERVER_COLOR, "**"WHITE" You are no longer muted.");
				}
			}
			if(PlayerInfo[i][pSpamTime] > 0)
			{
			    PlayerInfo[i][pSpamTime]--;
			}
			if(PlayerInfo[i][pVehicleCount] > 0)
			{
			    PlayerInfo[i][pVehicleCount]--;
			}
			if(PlayerInfo[i][pMechanicCall] > 0)
			{
			    PlayerInfo[i][pMechanicCall]--;
			}
			if(PlayerInfo[i][pTaxiCall] > 0)
			{
			    PlayerInfo[i][pTaxiCall]--;
			}
			if(PlayerInfo[i][pEmergencyCall] > 0)
			{
			    PlayerInfo[i][pEmergencyCall]--;
			}
			if(PlayerInfo[i][pCourierCooldown] > 0)
			{
			    PlayerInfo[i][pCourierCooldown]--;
			}
   			if(PlayerInfo[i][pPizzaCooldown] > 0)
			{
       			PlayerInfo[i][pPizzaCooldown]--;
			}
			if(PlayerInfo[i][pRareTime] > 0)
			{
		    	PlayerInfo[i][pRareTime]--;
			}
			if(PlayerInfo[i][pVipTimes] > 0)
			{
		    	PlayerInfo[i][pVipTimes]--;
			}
   			if(PlayerInfo[i][pDeathCooldown] > 0)
			{
       			PlayerInfo[i][pDeathCooldown]--;
			}
			if(PlayerInfo[i][pDetectiveCooldown] > 0)
			{
       			PlayerInfo[i][pDetectiveCooldown]--;
			}
			if(PlayerInfo[i][pLootTime] > 0)
			{
			    PlayerInfo[i][pLootTime]--;

			    if(IsPlayerInBankRobbery(i) && PlayerInfo[i][pLootTime] <= 0)
			    {
			        new amount = random(10000) + 1000;

			        ClearAnimations(i);

			        PlayerInfo[i][pRobCash] += amount;
			        PlayerInfo[i][pCP] = CHECKPOINT_ROBBERY;
			        PlayerInfo[i][pLastLoad] = gettime();

					format(string, sizeof(string), "~g~+$%i", amount);
					GameTextForPlayer(i, string, 5000, 1);

			        SendMessage(i, COLOR_WHITE, "You have looted $%i and now have $%i. You can keep looting or deliver the cash to the "SVRCLR"marker"WHITE".", amount, PlayerInfo[i][pRobCash]);
					SetPlayerCheckpoint(i, 1465.1348, -1010.5063, 26.8438, 3.0);
			    }
			}
			if(PlayerInfo[i][pFindTime] > 0)
			{
			    PlayerInfo[i][pFindTime]--;

			    if(PlayerInfo[i][pFindTime] == 0)
			    {
			        SetPlayerMarkerForPlayer(i, PlayerInfo[i][pFindPlayer], GetPlayerColor(PlayerInfo[i][pFindPlayer]));
					PlayerInfo[i][pFindPlayer] = INVALID_PLAYER_ID;
				}
			}
			if((PlayerInfo[i][pToggleMusic]) || (PlayerInfo[i][pBoomboxListen] != INVALID_PLAYER_ID && GetNearbyBoombox(i) != PlayerInfo[i][pBoomboxListen]))
			{
				PlayerInfo[i][pBoomboxListen] = INVALID_PLAYER_ID;

				if(PlayerInfo[i][pStreamType] == MUSIC_BOOMBOX)
				{
				    StopAudioStreamForPlayer(i);
				    PlayerInfo[i][pStreamType] = MUSIC_NONE;
				}
			}
			if((!PlayerInfo[i][pToggleMusic]) && ((boomboxid = GetNearbyBoombox(i)) != INVALID_PLAYER_ID && PlayerInfo[i][pBoomboxListen] != boomboxid))
			{
			    PlayerInfo[i][pBoomboxListen] = boomboxid;

			    if(PlayerInfo[i][pStreamType] == MUSIC_NONE)
			    {
			        PlayAudioStreamForPlayer(i, PlayerInfo[boomboxid][pBoomboxURL]);
			        PlayerInfo[i][pStreamType] = MUSIC_BOOMBOX;
			    }
			}
            if(PlayerInfo[i][pPickPlant] != INVALID_PLAYER_ID)
            {
                PlayerInfo[i][pPickTime]--;

                if(PlayerInfo[i][pPickTime] <= 0)
                {
                    new planterid = PlayerInfo[i][pPickPlant];

                    if(!IsPlayerConnected(planterid) || !PlayerInfo[planterid][pLogged] || !PlayerInfo[planterid][pPotPlanted])
                    {
                        SendClientMessage(i, COLOR_SYNTAX, "This plant is no longer available to pick.");
					}
					else if(!IsPlayerInRangeOfPoint(i, 3.0, PlayerInfo[planterid][pPotX], PlayerInfo[planterid][pPotY], PlayerInfo[planterid][pPotZ]))
					{
					    SendClientMessage(i, COLOR_SYNTAX, "Picking failed. You left the area of the plant.");
					}
					else if(GetPlayerSpecialAction(i) != SPECIAL_ACTION_DUCK)
					{
					    SendClientMessage(i, COLOR_SYNTAX, "Picking failed. You must stay crouched when picking a plant.");
					}
					else
					{
					    PlayerInfo[i][pPot] += PlayerInfo[planterid][pPotGrams];

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET pot = %i WHERE uid = %i", PlayerInfo[i][pPot], PlayerInfo[i][pID]);
						mysql_tquery(connectionID, queryBuffer);

						SendMessage(i, COLOR_WHITE, "You have harvested %i grams of pot from this plant.", PlayerInfo[planterid][pPotGrams]);
					    DestroyPotPlant(planterid);
					}

					PlayerInfo[i][pPickPlant] = INVALID_PLAYER_ID;
					PlayerInfo[i][pPickTime] = 0;
				}
			}
			if(PlayerInfo[i][pCookMeth] > 0)
			{
                PlayerInfo[i][pCookTime]--;

                if(PlayerInfo[i][pCookTime] <= 0)
                {
                    if(!IsPlayerInRangeOfPoint(i, 10.0, 333.5727, 1121.8536, 1083.8903))
                    {
                        SendClientMessage(i, COLOR_SYNTAX, "Cooking failed. You have left the cooking spot.");
                        ResetCooking(i);
                    }
                    else if(PlayerInfo[i][pEphedrine] <= 0)
                    {
                        SendClientMessage(i, COLOR_SYNTAX, "Cooking failed. You have ran out of ephedrine.");
                        ResetCooking(i);
					}
                    else if(PlayerInfo[i][pBakingSoda] <= 0)
                    {
                        SendClientMessage(i, COLOR_SYNTAX, "Cooking failed. You have ran out of baking soda.");
                        ResetCooking(i);
					}
					else if(PlayerInfo[i][pMeth] + 2 > GetPlayerCapacity(i, CAPACITY_METH))
                    {
                        SendClientMessage(i, COLOR_SYNTAX, "Cooking failed. You have ran out of inventory space for meth.");
                        ResetCooking(i);
					}
					else
					{
						SendClientMessage(i, COLOR_YELLOW, "+2 grams of meth!");

						PlayerInfo[i][pEphedrine] -= 1;
						PlayerInfo[i][pMeth] += 2;
						PlayerInfo[i][pCookGrams] += 2;

						if((PlayerInfo[i][pCookGrams] % 4) == 0)
						{
						    PlayerInfo[i][pMuriaticAcid]--;
						    PlayerInfo[i][pBakingSoda]--;
						}

						mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET ephedrine = %i, meth = %i, muriaticacid = %i, bakingsoda = %i WHERE uid = %i", PlayerInfo[i][pEphedrine], PlayerInfo[i][pMeth], PlayerInfo[i][pMuriaticAcid], PlayerInfo[i][pBakingSoda], PlayerInfo[i][pID]);
						mysql_tquery(connectionID, queryBuffer);

						if(!PlayerInfo[i][pEphedrine])
						{
						    SendMessage(i, COLOR_LIGHTRED, "You ran out of ephedrine therefore ending your cookoff. You made %i grams of meth from %i grams of ephedrine.", PlayerInfo[i][pCookGrams], PlayerInfo[i][pCookGrams] / 2);
							ResetCooking(i);
					    }
					    else if(!PlayerInfo[i][pMuriaticAcid])
						{
						    SendMessage(i, COLOR_LIGHTRED, "You ran out of muriatic acid therefore ending your cookoff. You made %i grams of meth from %i grams of ephedrine.", PlayerInfo[i][pCookGrams], PlayerInfo[i][pCookGrams] / 2);
							ResetCooking(i);
					    }
       					else if(!PlayerInfo[i][pBakingSoda])
						{
						    SendMessage(i, COLOR_LIGHTRED, "You ran out of baking soda therefore ending your cookoff. You made %i grams of meth from %i grams of ephedrine.", PlayerInfo[i][pCookGrams], PlayerInfo[i][pCookGrams] / 2);
							ResetCooking(i);
					    }
					    else if(PlayerInfo[i][pMeth] >= GetPlayerCapacity(i, CAPACITY_METH))
	                    {
	                        SendMessage(i, COLOR_LIGHTRED, "You ran out of inventory space for meth therefore ending your cookoff. You made %i grams of meth from %i grams of ephedrine.", PlayerInfo[i][pCookGrams], PlayerInfo[i][pCookGrams] / 2);
							ResetCooking(i);
					    }
					    else
					    {
					        PlayerInfo[i][pCookTime] = 15;
						}
                    }
                }
			}
			if(PlayerInfo[i][pDrugsUsed] >= 4)
			{
				PlayerInfo[i][pDrugsTime]--;
				if(PlayerInfo[i][pDrugsTime] <= 0)
				{
					PlayerInfo[i][pDrugsUsed] = 0;
					PlayerInfo[i][pDrugsTime] = 0;
					SendClientMessage(i, COLOR_SYNTAX, "You are no longer stoned.");
					SetPlayerDrunkLevel(i, 0);
				}
				else
				{
					SetPlayerDrunkLevel(i, 40000);
				}
			}
			if(PlayerInfo[i][pPoisonTime] > 0)
			{
			    new
			        Float:health;
			    GetPlayerHealth(i, health);
			    SetPlayerHealth(i, health - 3.0 < 1.0 ? 1.0 : health - 3.0);
			    PlayerInfo[i][pPoisonTime]--;
			}

            if(PlayerInfo[i][pLogged] && PlayerInfo[i][pAdmin] > 0 && !PlayerInfo[i][pAdminDuty])
            {
                if(gettime() - gAdminDutyLastWarning[i] >= 60)
                {
                    gAdminDutyLastWarning[i] = gettime();
                    gAdminDutyWarningCount[i]++;
                    SendClientMessage(i, COLOR_LIGHTRED, "Staff duty warning: use /attendance then /aduty. You will be kicked after 5 warnings if you remain off-duty.");
                    SendAdminMessage(COLOR_LIGHTRED, "[STAFF DUTY] %s is off-duty (warning %d/5).", GetRPName(i), gAdminDutyWarningCount[i]);
                    if(gAdminDutyWarningCount[i] >= 5)
                    {
                        SendAdminMessage(COLOR_LIGHTRED, "[STAFF DUTY] %s was kicked for remaining off-duty after 5 warnings.", GetRPName(i));
                        Kick(i);
                    }
                }
            }
            else if(PlayerInfo[i][pAdminDuty])
            {
                gAdminDutyWarningCount[i] = 0;
                gAdminDutyLastWarning[i] = gettime();
            }

			AnticheatCheck(i);

			//GetPlayerHealth(i, PlayerInfo[i][pHealth]);

			if(PlayerInfo[i][pGang] >= 0 && !PlayerInfo[i][pBandana])
			{
				new id;
				if((id = GetNearbyTurf(i)) >= 0 && TurfInfo[id][tTime] == 0 && TurfInfo[id][tCapturer] != INVALID_PLAYER_ID)
				{
					/*format(string, sizeof(string), "{%06x}%s", color >>> 8, GangInfo[gang][gName]);
					UpdateDynamic3DTextLabelText(PlayerLabel[i], COLOR_WHITE, string);

					format(string, sizeof(string), "{%06x}[%s] %s (%d)", color >>> 8, GangInfo[gang][gTag], GetPlayerNameEx(i), i);
		        	UpdateDynamic3DTextLabelText(CustomNametag[i], COLOR_WHITE, string);*/

					SetPlayerColor(i, GangInfo[PlayerInfo[i][pGang]][gColor] & ~0xff);

					PlayerInfo[i][pBandana] = 1;
					SendClientMessage(i, COLOR_WHITE, "Your bandana was enabled automatically as you entered a turf in an active war.");
				}
				if((id = GetNearbyPoint(i, 30.0)) >= 0 && PointInfo[id][pTime] == 0 && PointInfo[id][pCapturer] != INVALID_PLAYER_ID)
				{
					/*format(string, sizeof(string), "{%06x}%s", color >>> 8, GangInfo[gang][gName]);
					UpdateDynamic3DTextLabelText(PlayerLabel[i], COLOR_WHITE, string);

					format(string, sizeof(string), "{%06x}[%s] %s (%d)", color >>> 8, GangInfo[gang][gTag], GetPlayerNameEx(i), i);
		        	UpdateDynamic3DTextLabelText(CustomNametag[i], COLOR_WHITE, string);*/

					SetPlayerColor(i, GangInfo[PlayerInfo[i][pGang]][gColor] * 256);

					PlayerInfo[i][pBandana] = 1;
					SendClientMessage(i, COLOR_WHITE, "Your bandana was enabled automatically as you are in range of an active point.");
				}
			}
			if(!PlayerInfo[i][pBackup] && !IsPlayerBeingFound(i))
			{
				// Nametag colors gang colors bandana badge
				if(PlayerInfo[i][pJoinedEvent] && EventInfo[eType] == 2)
				{
				    SetPlayerColor(i, (PlayerInfo[i][pEventTeam] == RED_TEAM) ? (0xFF000000) : (0x0000FF00));
				}
				else if(PlayerInfo[i][pJailType] == 2)
				{
				    SetPlayerColor(i, 0xF4A41900);
				}
				else if(PlayerHasJob(i, JOB_TAXIDRIVER) && PlayerInfo[i][pTaxiFare] > 0)
				{
				    SetPlayerColor(i, 0xFFD70000);
				}
				else if(PlayerInfo[i][pFaction] >= 0 && PlayerInfo[i][pDuty] && FactionInfo[PlayerInfo[i][pFaction]][fType] != FACTION_HITMAN)
				{
					SetPlayerColor(i, FactionInfo[PlayerInfo[i][pFaction]][fColor] & ~0xff);
				}
				else if(PlayerInfo[i][pGang] >= 0 && PlayerInfo[i][pBandana])
				{
				    SetPlayerColor(i, GangInfo[PlayerInfo[i][pGang]][gColor] & ~0xff);
				}
				else if(PlayerInfo[i][pVIPPackage] > 0 && PlayerInfo[i][pVIPColor])
				{
				    SetPlayerColor(i, 0xC2A2DA00);
				}
				else
				{
				    SetPlayerColor(i, 0xFFFFFF00);
				    SetPlayerSpecialTag(i, TAG_NORMAL);
				}
			}
		}
	}
}

task MinuteTimer[60000]() // Global Timer
{
	new hour, suffix[3];

	gettime(.hour = hour);
	RefreshTime();

	/*// Philippine Time
	gettime(.hour = hour);
	RefreshTime();
	hour += 8;
	FixHour(hour);
	hour = shifthour;*/

	if(hour > 12 && hour < 24)
	{
		suffix = "PM";
	} else if(hour == 12) {
		suffix = "AM";
	} else if(hour > 0 && hour < 12) {
		suffix = "AM";
	} else if(hour == 0) {
		suffix = "AM";
	}

	if(gHour != hour)
	{
	    SendMessageToAll(COLOR_WHITE, "The server time is now: %02d:00 %s.", hour, suffix);
    	foreach(new i : Player)
	    {
	        if(PlayerInfo[i][pLogged] && !PlayerInfo[i][pKicked])
	        {
		        if(PlayerInfo[i][pAFK] && PlayerInfo[i][pAFKTime] > 900)
		        {
		            // SendClientMessage(i, COLOR_LIGHTRED, "You didn't receive a paycheck this hour as you were AFK for more than 15 minutes.");
		        }
				else
		        {
		            // 
				}
				if(PlayerInfo[i][pReportMuted])
				{
					PlayerInfo[i][pReportMuted]--;

					if(PlayerInfo[i][pReportMuted] <= 0)
					{
					    PlayerInfo[i][pReportMuted] = 0;
					    PlayerInfo[i][pReportWarns] = 0;

					    SendClientMessage(i, COLOR_YELLOW, "Your report mute has automatically been lifted.");
				    }
				}
			}
	    }

	    new point_count = 0, turf_count = 0;
	    for(new i = 0; i < MAX_POINTS; i ++)
	    {
	        if(PointInfo[i][pExists])
	        {
	            if(PointInfo[i][pTime] > 0)
	            {
	                PointInfo[i][pTime]--;
	                ReloadPoint(i);
				}
				if(!PointInfo[i][pTime])
				{
				    //SendMessageToAll(COLOR_GREEN, "%s is now available to capture.", PointInfo[i][pName]);
					point_count++;
				    PointInfo[i][pCapturedGang] = -1;
	            }

	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET time = %i, capturedgang = %i WHERE id = %i", PointInfo[i][pTime], PointInfo[i][pCapturedGang], i);
             	mysql_tquery(connectionID, queryBuffer);
	        }
		}

		for(new i = 0; i < MAX_TURFS; i ++)
	    {
	        if(TurfInfo[i][tExists])
	        {
	            if(TurfInfo[i][tTime] > 0)
	            {
	                TurfInfo[i][tTime]--;
	                ReloadTurf(i);
				}
				if(!TurfInfo[i][tTime] && TurfInfo[i][tType] != 8)
				{
					turf_count++;
				    //SendTurfMessage(i, COLOR_GREEN, "%s is now available to capture.", TurfInfo[i][tName]);
	            }

	            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET time = %i WHERE id = %i", TurfInfo[i][tTime], i);
             	mysql_tquery(connectionID, queryBuffer);
	        }
		}

		if(point_count >= 1)
        {
            foreach(new x : Player)
            {
                if(PlayerInfo[x][pGang])
                {
                    SendMessage(x, COLOR_GREEN, "Point Wars: %i points has become available for capture.", point_count);
                }
            }
        }
        if(turf_count >= 1)
        {
            foreach(new x : Player)
            {
                if(PlayerInfo[x][pGang] || PlayerInfo[x][pFaction])
                {
                    SendMessage(x, COLOR_GREEN, "Turf Wars: %i turfs has become available for claim.", turf_count);
                }
            }
        }

		switch(hour)
		{
		    case 0, 6, 12, 18:
		    {
		        for(new i = 0; i < MAX_GANGS; i ++)
		        {
		            if(GangInfo[i][gSetup] && GangInfo[i][gTurfTokens] < 10)
		            {
		                GangInfo[i][gTurfTokens]++;

		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET turftokens = turftokens + 1 WHERE id = %i", i);
		                mysql_tquery(connectionID, queryBuffer);
		            }
		        }

		        for(new i = 0; i < MAX_FACTIONS; i ++)
		        {
		            if(FactionInfo[i][fType] == FACTION_POLICE && FactionInfo[i][fTurfTokens] < 3)
		            {
		                FactionInfo[i][fTurfTokens]++;

		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET turftokens = turftokens + 1 WHERE id = %i", i);
		                mysql_tquery(connectionID, queryBuffer);
		            }
		        }
		        for(new i = 0; i < MAX_FACTIONS; i ++)
		        {
		            if(FactionInfo[i][fType] == FACTION_FEDERAL && FactionInfo[i][fTurfTokens] < 3)
		            {
		                FactionInfo[i][fTurfTokens]++;

		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET turftokens = turftokens + 1 WHERE id = %i", i);
		                mysql_tquery(connectionID, queryBuffer);
		            }
		        }
		        for(new i = 0; i < MAX_FACTIONS; i ++)
		        {
		            if(FactionInfo[i][fType] == FACTION_ARMY && FactionInfo[i][fTurfTokens] < 3)
		            {
		                FactionInfo[i][fTurfTokens]++;

		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET turftokens = turftokens + 1 WHERE id = %i", i);
		                mysql_tquery(connectionID, queryBuffer);
		            }
		        }
			}
		}

		if(RobberyInfo[rTime] > 0)
		{
		    RobberyInfo[rTime]--;
		}

		for(new i = 0; i < MAX_BUSINESSES; i ++)
		{
			if(BusinessInfo[i][bRobbed] > 0)
			{
				BusinessInfo[i][bRobbed]--;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE businesses SET robbed = %i WHERE id = %i", BusinessInfo[i][bRobbed], BusinessInfo[i][bID]);
				mysql_tquery(connectionID, queryBuffer);

			}
		}
		for(new i = 0; i < MAX_HOUSES; i ++)
		{
			if(HouseInfo[i][hRobbed] > 0)
			{
				HouseInfo[i][hRobbed]--;

				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE houses SET robbed = %i WHERE id = %i", HouseInfo[i][hRobbed], HouseInfo[i][hID]);
				mysql_tquery(connectionID, queryBuffer);

			}
		}

	    SetWorldTime(hour);
		gWorldTime = hour;
	    gHour = hour;

	    gCharityHealth = 0;
	    gCharityArmor = 0;
	}
	else
	{
	    foreach(new i : Player)
		{
		    if(PlayerInfo[i][pPotPlanted] && PlayerInfo[i][pPotTime] > 0)
		    {
		        PlayerInfo[i][pPotTime]--;

		        if((PlayerInfo[i][pPotTime] % 2) == 0)
		        {
		            PlayerInfo[i][pPotGrams]++;
		        }
		    }

			if(PlayerInfo[i][pLogged] && PlayerInfo[i][pAFKTime] < 900)
			{
			    // Kung may nakabinbing paycheck na hindi pa kini-claim
			    if(PlayerInfo[i][pPaycheckClaim])
			    {
			        PlayerInfo[i][pPaycheckTime]++; // Dito, nagsisilbi itong expiration timer (1-5 mins)
			        
			        if(PlayerInfo[i][pPaycheckTime] == 3)
			        {
			            GameTextForPlayer(i, "~w~Type /signcheck", 2500, 1);
			            SendClientMessage(i, COLOR_WHITE, "You have 2 minutes left before your paycheck code expires. Please type /signcheck to get your paycheck.");
			        }
			        else if(PlayerInfo[i][pPaycheckTime] >= 5)
			        {
			            PlayerInfo[i][pPaycheckCode] = 0;
			            PlayerInfo[i][pPaycheckClaim] = 0;
			            PlayerInfo[i][pPaycheckTime] = 0; // I-reset sa 0 para magsimula ulit ang 60-minute cycle
			            SendClientMessage(i, COLOR_WHITE, "Your paycheck code expired. Please remember to use /signcheck next time.");
			        }
			    }
			    else // Kung wala pang paycheck, magdadagdag para sa 60-minute cycle
			    {
			        PlayerInfo[i][pPaycheckTime]++;
			        
			        if(PlayerInfo[i][pPaycheckTime] >= 60)
			        {
			            new code = Random(100000, 999999);
			            PlayerInfo[i][pPaycheckCode] = code;
			            PlayerInfo[i][pPaycheckTime] = 0; // I-reset sa 0 para magsilbing simula ng 5-minute claim timer
			            PlayerInfo[i][pPaycheckClaim] = 1;
			
			            SendClientMessage(i, COLOR_GREY,"_______________________________________________________________");
			            SendClientMessage(i, COLOR_WHITE,"Information on paychecks: /payhelp or /taxhelp");
			            SendClientMessage(i, COLOR_GREY,"_______________________________________________________________");
			            SendClientMessage(i, COLOR_WHITE,"Sign the check to receive your paycheck.");
			            SendClientMessage(i, COLOR_WHITE,"Type /signcheck, to receive your paycheck.");
			            SendClientMessage(i, COLOR_WHITE,"You have 5 minutes to sign the check before it becomes invalid.");
			            SendClientMessage(i, COLOR_GREY,"_______________________________________________________________");
			
			            GameTextForPlayer(i, "~w~Type /signcheck", 2500, 1);
			        }
			    }
			}
		}

		for(new i = 0; i < MAX_POINTS; i ++)
	    {
	        if(PointInfo[i][pExists] && PointInfo[i][pCapturer] != INVALID_PLAYER_ID && PointInfo[i][pCaptureTime] > 0)
	        {
	            if(PlayerInfo[PointInfo[i][pCapturer]][pGang] == -1)// || PlayerInfo[PointInfo[i][pCapturer]][pGangRank] < 5)
	            {
	                PointInfo[i][pCapturer] = INVALID_PLAYER_ID;
	                PointInfo[i][pCaptureTime] = 0;
	            }
	            else
	            {
		            PointInfo[i][pCaptureTime]--;

		            if(PointInfo[i][pCaptureTime] <= 0)
		            {
		                GiveGangPoints(PlayerInfo[PointInfo[i][pCapturer]][pGang], 50);
		                GetPlayerName(PointInfo[i][pCapturer], PointInfo[i][pCapturedBy], MAX_PLAYER_NAME);
						
					    PointInfo[i][pCapturedGang] = PlayerInfo[PointInfo[i][pCapturer]][pGang];
						GangInfo[PointInfo[i][pCapturedGang]][gCash] += PointInfo[i][pProfits];

						SendMessageToAll(COLOR_GREEN, "{%06x}%s has successfully captured %s for %s.", GangInfo[PointInfo[i][pCapturedGang]][gColor] >>> 8, GetRPName(PointInfo[i][pCapturer]), PointInfo[i][pName], GangInfo[PointInfo[i][pCapturedGang]][gName]);
						SendGangMessage(PointInfo[i][pCapturedGang], COLOR_YELLOW, "Your gang has earned $%i and 50 GP for successfully capturing this point.", PointInfo[i][pProfits]);

					    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET cash = %i WHERE id = %i", GangInfo[PointInfo[i][pCapturedGang]][gCash], PointInfo[i][pCapturedGang]);
					    mysql_tquery(connectionID, queryBuffer);

					    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE points SET capturedby = '%s', capturedgang = %i, profits = 0, time = 20 WHERE id = %i", PointInfo[i][pCapturedBy], PointInfo[i][pCapturedGang], i);
					    mysql_tquery(connectionID, queryBuffer);

	                    PointInfo[i][pCapturer] = INVALID_PLAYER_ID;
		                PointInfo[i][pCaptureTime] = 0;
		                PointInfo[i][pProfits] = 0;
		                PointInfo[i][pTime] = 10;
		                ReloadPoint(i);
					}
				}
			}
		}

		for(new i = 0; i < MAX_TURFS; i ++)
		{
		    if(TurfInfo[i][tExists] && TurfInfo[i][tCapturer] != INVALID_PLAYER_ID && TurfInfo[i][tCaptureTime] > 0)
		    {
		        if(!IsLawEnforcement(TurfInfo[i][tCapturer]) && (PlayerInfo[TurfInfo[i][tCapturer]][pGang] == -1))
		        {
		            TurfInfo[i][tCapturer] = INVALID_PLAYER_ID;
		            TurfInfo[i][tCaptureTime] = 0;
		            ReloadTurf(i);
		        }
		        else
		        {
		            TurfInfo[i][tCaptureTime]--;
		
		            if(TurfInfo[i][tCaptureTime] <= 0)
		            {
		                GetPlayerName(TurfInfo[i][tCapturer], TurfInfo[i][tCapturedBy], MAX_PLAYER_NAME);
		
		                if(IsLawEnforcement(TurfInfo[i][tCapturer]))
		                {
		                    TurfInfo[i][tCapturedGang] = -1;
		                    SendMessageToAll(COLOR_GREEN, "[Turf Notice]: "WHITE"%s has been successfully claimed back as a civilian turf by Officer %s.", TurfInfo[i][tName], GetRPName(TurfInfo[i][tCapturer]));
		                }
		                else
		                {
		                    new gangid = PlayerInfo[TurfInfo[i][tCapturer]][pGang];
		                    TurfInfo[i][tCapturedGang] = gangid;
		
		                    SendMessageToAll(COLOR_GREEN, "[Turf Notice]: "WHITE"%s has been successfully claimed by %s for %s.", TurfInfo[i][tName], GetRPName(TurfInfo[i][tCapturer]), GangInfo[gangid][gName]);
		
		                    switch(TurfInfo[i][tType])
		                    {
		                        case 1:
		                        {
		                            GangInfo[gangid][gHPAmmo] = GangInfo[gangid][gHPAmmo] + 80 > GetGangStashCapacity(gangid, STASH_CAPACITY_HPAMMO) ? GetGangStashCapacity(gangid, STASH_CAPACITY_HPAMMO) : GangInfo[gangid][gHPAmmo] + 80;
		                            SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned 80 rounds of hollow point ammo in its stash for capturing this turf!");
		
		                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET hpammo = %i WHERE id = %i", GangInfo[gangid][gHPAmmo], gangid);
		                            mysql_tquery(connectionID, queryBuffer);
		                        }
		                        case 2:
		                        {
		                            GangInfo[gangid][gPoisonAmmo] = GangInfo[gangid][gPoisonAmmo] + 60 > GetGangStashCapacity(gangid, STASH_CAPACITY_POISONAMMO) ? GetGangStashCapacity(gangid, STASH_CAPACITY_POISONAMMO) : GangInfo[gangid][gPoisonAmmo] + 60;
		                            SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned 60 rounds of poison tip ammo in its stash for capturing this turf!");
		
		                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET poisonammo = %i WHERE id = %i", GangInfo[gangid][gPoisonAmmo], gangid);
		                            mysql_tquery(connectionID, queryBuffer);
		                        }
		                        case 3:
		                        {
		                            GangInfo[gangid][gFMJAmmo] = GangInfo[gangid][gFMJAmmo] + 30 > GetGangStashCapacity(gangid, STASH_CAPACITY_FMJAMMO) ? GetGangStashCapacity(gangid, STASH_CAPACITY_FMJAMMO) : GangInfo[gangid][gFMJAmmo] + 30;
		                            SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned 30 rounds of full metal jacket ammo in its stash for capturing this turf!");
		
		                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET fmjammo = %i WHERE id = %i", GangInfo[gangid][gFMJAmmo], gangid);
		                            mysql_tquery(connectionID, queryBuffer);
		                        }
		                        case 4:
		                        {
		                            new amount = 10000;
		                            GangInfo[gangid][gMaterials] = GangInfo[gangid][gMaterials] + amount > GetGangStashCapacity(gangid, STASH_CAPACITY_MATERIALS) ? GetGangStashCapacity(gangid, STASH_CAPACITY_MATERIALS) : GangInfo[gangid][gMaterials] + 10000;
		                            SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned %i materials in the stash for capturing this turf!", amount);
		
		                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET materials = %i WHERE id = %i", GangInfo[gangid][gMaterials], gangid);
		                            mysql_tquery(connectionID, queryBuffer);
		                        }
		                        case 5:
		                        {
		                            GangInfo[gangid][gPot] = GangInfo[gangid][gPot] + 100 > GetGangStashCapacity(gangid, STASH_CAPACITY_WEED) ? GetGangStashCapacity(gangid, STASH_CAPACITY_WEED) : GangInfo[gangid][gPot] + 100;
		                            GangInfo[gangid][gMeth] = GangInfo[gangid][gMeth] + 100 > GetGangStashCapacity(gangid, STASH_CAPACITY_METH) ? GetGangStashCapacity(gangid, STASH_CAPACITY_METH) : GangInfo[gangid][gMeth] + 100;
		                            SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned 100 grams of pot & 100 grams crack in the stash for capturing this turf!");
		
		                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET pot = %i, meth = %i WHERE id = %i", GangInfo[gangid][gPot], GangInfo[gangid][gMeth], gangid);
		                            mysql_tquery(connectionID, queryBuffer);
		                        }
		                        case 6:
		                        {
		                            GangInfo[gangid][gCrack] = GangInfo[gangid][gCrack] + 100 > GetGangStashCapacity(gangid, STASH_CAPACITY_COCAINE) ? GetGangStashCapacity(gangid, STASH_CAPACITY_COCAINE) : GangInfo[gangid][gCrack] + 100;
		                            SendGangMessage(gangid, COLOR_YELLOW, "Your gang earned 100 grams of Crack in the stash for capturing this turf!");
		
		                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET crack = %i WHERE id = %i", GangInfo[gangid][gCrack], gangid);
		                            mysql_tquery(connectionID, queryBuffer);
		                        }
		                        case 7:
		                        {
		                            SendGangMessage(gangid, COLOR_YELLOW, "Your gang will now receive 10 percents of all sales in this turf.");
		                        }
		                        case 8:
		                        {
		                            GangInfo[gangid][gWeapons][GANGWEAPON_9MM] += 3;
		                            GangInfo[gangid][gWeapons][GANGWEAPON_SDPISTOL] += 3;
		                            GangInfo[gangid][gWeapons][GANGWEAPON_SHOTGUN] += 3;
		
		                            SendGangMessage(gangid, COLOR_YELLOW, "Your gang has earned 9mm(3), Shotgun(3) in its stash for capturing this turf!");
		
		                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_9mm = %i, weapon_sdpistol = %i, weapon_shotgun = %i WHERE id = %i", GangInfo[gangid][gWeapons][GANGWEAPON_9MM], GangInfo[gangid][gWeapons][GANGWEAPON_SDPISTOL], GangInfo[gangid][gWeapons][GANGWEAPON_SHOTGUN], gangid);
		                            mysql_tquery(connectionID, queryBuffer);
		                        }
		                        case 9:
		                        {
		                            GangInfo[gangid][gWeapons][GANGWEAPON_MP5] += 5;
		                            GangInfo[gangid][gWeapons][GANGWEAPON_RIFLE] += 5;
		                            SendGangMessage(gangid, COLOR_YELLOW, "Your gang has earned MP5(5), Cuntgun(5), Tec-9(5), Uzi(5) in its stash for capturing this turf!");
		
		                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_mp5 = %i, weapon_rifle = %i, weapon_tec9 = %i, weapon_uzi = %i WHERE id = %i", GangInfo[gangid][gWeapons][GANGWEAPON_MP5], GangInfo[gangid][gWeapons][GANGWEAPON_RIFLE], gangid);
		                            mysql_tquery(connectionID, queryBuffer);
		                        }
		                        case 10:
		                        {
		                            GangInfo[gangid][gWeapons][GANGWEAPON_DEAGLE] += 5;
		                            GangInfo[gangid][gWeapons][GANGWEAPON_AK47] += 5;
		                            SendGangMessage(gangid, COLOR_YELLOW, "Your gang has earned Deagle(3), AK47(5) in its stash for capturing this turf!");
		
		                            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE gangs SET weapon_ak47 = %i, weapon_deagle = %i WHERE id = %i", GangInfo[gangid][gWeapons][GANGWEAPON_AK47], GangInfo[gangid][gWeapons][GANGWEAPON_DEAGLE], gangid);
		                            mysql_tquery(connectionID, queryBuffer);
		                        }
		                    }
		                }	                
	
		                TurfInfo[i][tTime] = 24; 
		
		                switch(TurfInfo[i][tType])
		                {
		                    case 4: { TurfInfo[i][tTime] = 5; }
		                    case 5: { TurfInfo[i][tTime] = 8; }
		                    case 6: { TurfInfo[i][tTime] = 12; }
		                }
	
		                mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE turfs SET capturedby = '%s', capturedgang = %i, time = %i WHERE id = %i", TurfInfo[i][tCapturedBy], TurfInfo[i][tCapturedGang], TurfInfo[i][tTime], i);
		                mysql_tquery(connectionID, queryBuffer);
		
		                // 4. I-reset ang capturer variables
		                TurfInfo[i][tCapturer] = INVALID_PLAYER_ID;
		                TurfInfo[i][tCaptureTime] = 0;
		
		                ReloadTurf(i);
		            }
		        }
		    }
		}

		for(new i = 0; i < MAX_REPORTS; i ++)
		{
		    if(ReportInfo[i][rExists] && ReportInfo[i][rTime] > 0)
		    {
		        ReportInfo[i][rTime]--;

		        if(ReportInfo[i][rTime] <= 0)
		        {
		            SendClientMessage(ReportInfo[i][rReporter], COLOR_SYNTAX, "Your report has expired. You can make an admin request on discord if you still need help.");
		            ReportInfo[i][rExists] = 0;
		        }
			}
		}
	}
}