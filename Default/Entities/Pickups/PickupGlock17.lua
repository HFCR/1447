Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="Glock17",
	ammotype="Pistol",
	model="Objects/Weapons/Glock17/Glock17_bind.cgf",
	default_amount=32,
	sound="sounds/weapons/DE/deweapact.wav",
}

PickupGlock17=CreateWeaponPickup(params);
