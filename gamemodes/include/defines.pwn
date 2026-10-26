//--------------------------------------------------------------
// Model Selection
#define MODEL_SELECTION_CLOTHING            1
#define MODEL_SELECTION_FURNITURE 	        2
#define MODEL_SELECTION_LANDOBJECTS         3
#define MODEL_SELECTION_CLOTHES             4
#define MODEL_SELECTION_VEH                 5
#define MODEL_SELECTION_RARE_VEH            6
#define MODEL_SELECTION_RESTRICTED_VEH      7
//--------------------------------------------------------------
#define MAX_LISTED_NUMBERS          50
#define MAX_LISTED_OBJECTS          100
#define MAX_LISTED_STATIONS         50
#define MAX_SPLIT_LENGTH            70
#define SENDDATA_THREAD             2
//--------------------------------------------------------------
#define MAX_REPORTS         		50
#define MAX_HOUSES          		1500
#define MAX_CCTVS 					100
#define MAX_CCTVMENUS 				10  // This number should be MAX_CCTVS divided by 10
#define MAX_GARAGES         		1000
#define MAX_BUSINESSES      		500
#define MAX_ENTRANCES       		500
#define MAX_SPEED_CAMERAS           50
#define MAX_GATES					500
#define MAX_MAPOBJECTS				1000
#define MAX_PLAYER_CLOTHING     	10
#define MAX_ANTICHEAT_WARNINGS   	5
#define MAX_OOB_WARNINGS   	        3
#define MAX_FACTIONS                20
#define MAX_FACTION_RANKS           20
#define MAX_FACTION_SKINS           15
#define MAX_FACTION_DIVISIONS       5
#define MAX_DEPLOYABLES             50
#define MAX_FIRES                   100
#define MAX_LANDS                   100
#define MAX_GANGS                   20
#define MAX_GANG_SKINS              10
#define MAX_POINTS                  15
#define MAX_TURFS                   150
#define MAX_BANK_ROBBERS            7
#define MAX_GRAFFITI_POINTS         200
#define MAX_PROPERTIES_TIMESTAMP    2592000 // Convert into 30 Days
#define MAX_REDEEM_CODES             	                         5
#define MAX_DROPPED_ITEMS (5000)
#define AMMO_NORMAL                 1
#define AMMO_DEFAULT                 200
#define AMMO_DEAGLE                 150
#define AMMO_SHOTGUN                100
#define AMMO_SMG                    200
#define AMMO_RIFLE                  350
#define AMMO_SNIPER                 150

// Dealership
#define INVALID_BUSINESS_ID 	-1
#define MAX_BUSINESS_DEALERSHIP_VEHICLES	10
//--------------------------------------------------------------
#define SERVER_MUSIC_URL ""SERVER_URL"/music"
#define SERVER_FETCH_URL ""SERVER_URL"/music"
#define SOUND_MUSIC3                140
#define RED_TEAM    0
#define BLUE_TEAM   1
//--------------------------------------------------------------
#define percent(%0,%1)  floatround((float((%0)) / 100) * (%1))
#define GetPlayerCash(%0) PlayerInfo[%0][pCash]
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0) (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define HOLDING(%0) ((newkeys & (%0)) == (%0))
#define SendErrorMessage(%0,%1)  SendClientMessage((%0), COLOR_WHITE, ""%1)
#define SendSyntaxMessage(%0,%1) SendClientMessage((%0), COLOR_GREY, "{FF6347}Usage:{ffffff} "%1)
#define SendAdminAction(%0,%1) \
    SendClientMessageEx(%0, COLOR_LIGHTBLUE, "[ADMIN]: "%1) // COLORLOW
#undef SSCANF_Join
#undef SSCANF_Leave
#define Create
#define Object
//--------------------------------------------------------------
// Tune system
new pvehicleid[MAX_PLAYERS];
new pmodelid[MAX_PLAYERS];
#define DIALOG_TYPE_MAIN 14400
#define DIALOG_TYPE_EXHAUSTS 14700
#define DIALOG_TYPE_FBUMPS 14800
#define DIALOG_TYPE_RBUMPS 14900
#define DIALOG_TYPE_ROOFS 15000
#define DIALOG_TYPE_SPOILERS 15100
#define DIALOG_TYPE_SIDESKIRTS 15200
#define DIALOG_TYPE_BULLBARS 15300
#define DIALOG_TYPE_WHEELS 15400
#define DIALOG_TYPE_CSTEREO 15500
#define DIALOG_TYPE_HYDRAULICS 15600
#define DIALOG_TYPE_NITRO 15700
#define DIALOG_TYPE_LIGHTS 15800
#define DIALOG_TYPE_HOODS 15900
#define DIALOG_TYPE_VENTS 16000