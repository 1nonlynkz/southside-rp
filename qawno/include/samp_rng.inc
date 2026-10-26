#if defined _INC_samp_rng
    #undef _INC_samp_rng
#endif

#if defined _samp_rng_included
    #endinput
#endif

native RandomNumber(...);

// native RandomNumberMax(max)
stock RandomNumberMax(max)
{
    return RandomNumber(max);
}

// native RandomNumberMinMax(min, max);
stock RandomNumberMinMax(min, max)
{
    return RandomNumber(min, max);
}

native Float:RandomFloatNumber(Float:...);

// native Float:RandomFloatNumberMax(Float:max);
stock Float:RandomFloatNumberMax(Float:max)
{
    return RandomFloatNumber(max);
}

// native Float:RandomFloatNumberMinMax(Float:min, Float:max);
stock Float:RandomFloatNumberMinMax(Float:min, Float:max)
{
    return RandomFloatNumber(min, max);
}