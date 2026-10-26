enum crateInfo
{
	cbID,
	cbObject,
	cbExist,
	Text3D: cbTextID,
	cbFacility,
	cbGroup,
	Float:cbPos[3],
	cbInVeh,
	cbOnVeh,
	cbInt,
	cbVw,
	cbWep[20],
	cbWepAmount[20],
	cbPlacedBy[MAX_PLAYER_NAME],
	cbLifespan,
	cbTransfer,
	cbDoor,
	cbDoorType,
	cbPrice,
	cbPaid,
	cbActive
}

enum crateOrders
{
	crateOrderExists,
	crateOrderPlayer,
	crateOrderAccepted,
	crateOrderHandleBy,
	crateOrderText[128],
	crateOrderTime
};
new CrateBox[MAX_CRATES][crateInfo];
new CrateOrder[MAX_CRATES_ORDER][crateOrders];

new BeingMoved[MAX_CRATES];
new CarryCrate[MAX_PLAYERS];
new CarryCooldown[MAX_PLAYERS];
new PlayerHoldingObject[MAX_PLAYERS][10];