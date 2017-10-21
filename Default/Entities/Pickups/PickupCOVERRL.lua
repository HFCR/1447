Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="COVERRL",
	ammotype="Rocket",
	model="Objects/weapons/grm_010/grm_010_bind.cgf",
	default_amount = 4,
	sound="sounds/weapons/Mortar/mortar_33.wav",
}

PickupCOVERRL=CreateWeaponPickup(params);
