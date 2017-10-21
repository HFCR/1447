Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="FAMAS",
	ammotype="SMG",
	model="Objects/Weapons/FAMAS/FAMAS_bind.cgf",
	default_amount=10,
	sound="Sounds/Weapons/FAMAS/FAMAS_boltpull.wav",
}

PickupFAMAS=CreateWeaponPickup(params);
