Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="M3",
	ammotype="Shotgun",
	model="Objects/Weapons/M3/M3_bind.cgf",
	default_amount=10,
	sound="Sounds/Weapons/m3_act.wav",
}


PickupM3=CreateWeaponPickup(params);
