Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="M1911",
	ammotype="Pistol",
	model="Objects/Weapons/1911/1911_bind.cgf",
	default_amount=7,
	sound="Sounds/Weapons/M4/m4weapact.wav",
}

PickupM1911=CreateWeaponPickup(params);
