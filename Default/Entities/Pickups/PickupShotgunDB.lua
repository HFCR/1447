Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="ShotgunDB",
	ammotype="Shotgun",
	model="Objects/Weapons/Shotgun_db/Shotgun_db_bind.cgf",
	default_amount=2,
	sound="Sounds/Weapons/Mortar/mortar_33.wav",
}


PickupShotgunDB=CreateWeaponPickup(params);
