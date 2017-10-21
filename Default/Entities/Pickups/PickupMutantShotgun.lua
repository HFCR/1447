Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="MutantShotgun",
	ammotype="Shotgun",
	model="Objects/Weapons/pow_pow/ashotgun_bind.cgf",
	default_amount = 6,
	sound="sounds/weapons/Mortar/mortar_33.wav",
}

PickupMutantShotgun=CreateWeaponPickup(params);
