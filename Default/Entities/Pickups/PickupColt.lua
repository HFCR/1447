Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="Colt",
	ammotype="Pistol",
	model="Objects/Weapons/1911_orig/1911_bind.cgf",
	default_amount=7,
	sound="Sounds/Weapons/M4/m4weapact.wav",
}

PickupColt=CreateWeaponPickup(params);
