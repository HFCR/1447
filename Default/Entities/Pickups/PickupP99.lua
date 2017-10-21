Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="P99",
	ammotype="Pistol",
	model="Objects/Weapons/P99/P99_bind.cgf",
	default_amount=11,
	sound="sounds/weapons/DE/deweapact.wav",
}

PickupP99=CreateWeaponPickup(params);
