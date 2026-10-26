CMD:listplatformuser(playerid, params[])
{
    if(isnull(params))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /listplatformuser [option]");
        SendClientMessage(playerid, COLOR_SYNTAX, "Options: Mobile, Destop");
        return 1;
    }
    
    new string[(1024 * 2)], header[(1024 * 2)], count;
    string[0] = EOS;
    if(!strcmp(params, "mobile", true))
    {
        foreach(new i : Player)
        {
            if(IsPlayerAndroid(i))
            {
                count ++;
                format(header, sizeof(header), "There are %d mobile users online.", count);
                format(string, sizeof(string), "%s[ID: %d] %s\n", string, i, GetRPName(i));
            }
        }
        
        if(!string[0]) format(string, sizeof(string), "No Mobile Users Online.");
        ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, header, string, "Close", "");
    }
    else if(!strcmp(params, "desktop", true))
    {
        foreach(new i : Player)
        {
            if(!IsPlayerAndroid(i))
            {
                count ++;
                format(header, sizeof(header), "There are %d desktop users online.", count);
                format(string, sizeof(string), "%s[ID: %d] %s\n", string, i, GetRPName(i));count ++;
            }
        }
        if(!string[0]) format(string, sizeof(string), "No Desktop Users Online.");
        ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, header, string, "Close", "");
    }
    return 1;
}