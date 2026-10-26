#include <YSI_Coding\y_hooks>

hook OnGameModeInit()
{
    // Point bounds
	pointboundaries[0] = GangZoneCreate(2545.8984375 ,-2153.3203125, 2707.03125, -2062.5); // FFC
	pointboundaries[1] = GangZoneCreate(1361.328125,-1435.546875,1478.515625,-1236.328125); // MP1
	pointboundaries[2] = GangZoneCreate(2077.1484375, -2361.328125, 2285.15625, -2179.6875); // MF1
	pointboundaries[3] = GangZoneCreate(2298.828125,-2064.453125,2546.875,-1935.546875); // MP2
	pointboundaries[4] = GangZoneCreate(2156.25, -1151.3671875, 2320.3125, -1001.953125); // MF2
	pointboundaries[5] = GangZoneCreate(2581.0546875, -2586.9140625, 2862.3046875, -2329.1015625); // AEC
	pointboundaries[6] = GangZoneCreate(2105.46875,-1753.90625,2177.734375,-1626.953125); // Drug House
	pointboundaries[7] = GangZoneCreate(2304.6875,-1181.640625,2361.328125,-1160.15625); // Crack Lab
	pointboundaries[8] = GangZoneCreate(13.671875,-402.34375,167.96875,-208.984375); // Drug Factory
    return 1;
}