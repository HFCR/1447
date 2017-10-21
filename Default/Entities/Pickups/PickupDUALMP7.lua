Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="DUALMP7",
	ammotype="SMG",
	model="Objects/Weapons/DUALMP7/dualmp7_pickup.cgf",
	default_amount=80,
	sound="Sounds/Weapons/duals_act.wav",
}

PickupDUALMP7=CreateWeaponPickup(params);
