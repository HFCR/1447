Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	ammotype="Minigun",
	model="Objects/Pickups/universal_ammo/universal_ammo.cgf",
	default_amount=300,
	sound="Sounds/Weapons/M4/M4_33.wav"
}

AmmoChaingun=CreateAmmoPickup(params);

