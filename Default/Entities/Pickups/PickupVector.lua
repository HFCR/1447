Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="Vector",
	ammotype="Pistol",
	model="Objects/Weapons/Vector/Vector_bind.cgf",
	default_amount=30,
	sound="Sounds/Weapons/MP5/mp5weapact.wav",
}

PickupVector=CreateWeaponPickup(params);
