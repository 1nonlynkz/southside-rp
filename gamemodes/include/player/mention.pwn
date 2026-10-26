#include <mentiones> 

public OnPlayerMentioned(playerid, targetid)
{
	new string[1028], type[1028];
	if(GetPVarInt(playerid, "MentionType") == 1)
	{
		type = "Global Chat (/g)";
	}
	else if(GetPVarInt(playerid, "MentionType") == 2)
	{
		type = "Newbie Chat (/newb)";
	}
	else if(GetPVarInt(playerid, "MentionType") == 3)
	{
		type = "VIP Chat (/v)";
	}
	else if(GetPVarInt(playerid, "MentionType") == 4)
	{
		type = "OOC Chat (/o)";
	}
	format(string, sizeof(string), "%s~w~ mentioned you from the ~g~%s", GetRPName(playerid), type);
    Alert(targetid, string);
    return 1;
}