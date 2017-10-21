Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="Sopmod",
	ammotype="Assault",
	model="Objects/Weapons/M4/M4_bind.cgf",
	default_amount=30,
	sound="Sounds/Weapons/M4/m4weapact.wav",
}

PickupSopmod=CreateWeaponPickup(params);
