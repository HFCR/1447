Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	ammotype="RPG7",
	model="Objects/Weapons/RPG7/RPG7_ammo.cgf",
	default_amount=1,
	sound="Sounds/Weapons/FN_SCAR_light/FN_SCAR_light_wact.wav"
}


AmmoRPG7=CreateAmmoPickup(params);

