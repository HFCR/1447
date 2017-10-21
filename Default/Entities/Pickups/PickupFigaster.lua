Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="Figaster",
	ammotype="Pistol",
	model="Objects/weapons/blaster_figaster/blasterfigaster_bind.cgf",
	default_amount = 10,
	sound="sounds/weapons/DE/deweapact.wav",
}

PickupFigaster=CreateWeaponPickup(params);
