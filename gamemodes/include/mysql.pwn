#define SERVER_NAME     	"Southside Roleplay"
#define SERVER_DIALOG   	""SERVER_NAME" - "SERVER_VERSION""
#define SERVER_ANTICHEAT 	"Server"
#define SERVER_GAMEMODE 	"S:RP"
#define SERVER_VERSION      "v0.6.0(af)"
#define SERVER_URL       	"southsideroleplay.com"

#define SERVER_MYSQL 2
#if SERVER_MYSQL == 1
	#define SQL_HOSTNAME        "localhost"
    #define SQL_DATABASE        "capital-master"
    #define SQL_USERNAME        "root"
    #define SQL_PASSWORD        ""
#endif

#if SERVER_MYSQL == 2
	#define SQL_HOSTNAME        "51.79.222.103"
    #define SQL_DATABASE        "s2_soutside"
    #define SQL_USERNAME        "u2_vDdEworPmM"
    #define SQL_PASSWORD        "Fr=REhqcjb=2YiCU66uo^Qcw"
#endif

new connectionID;
new radioConnectionID;
new queryBuffer[1024];