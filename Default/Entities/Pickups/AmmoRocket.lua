Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	ammotype="Rocket",
	model="Objects/pickups/ammo/rockets.cgf",
	default_amount=2,
	sound="sounds/weapons/Mortar/mortar_33.wav"
}

AmmoRocket=CreateAmmoPickup(params);

