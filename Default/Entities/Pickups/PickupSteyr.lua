Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="Steyr",
	ammotype="Assault",
	model="Objects/Weapons/Steyr/Steyr_bind.cgf",
	default_amount=30,
	sound="Sounds/Weapons/steyr_act.wav",
}

PickupSteyr=CreateWeaponPickup(params);
