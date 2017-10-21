Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="G11",
	ammotype="Caseless47",
	model="Objects/weapons/hk_g11/hkg11_bind.cgf",
	default_amount = 45,
	sound="Sounds/Weapons/M4/m4weapact.wav",
}

PickupG11=CreateWeaponPickup(params);
