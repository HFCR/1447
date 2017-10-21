Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="OC14",
	ammotype="Assault",
	model="Objects/Weapons/OC14/OC14_bind.cgf",
	default_amount=30,
	sound="Sounds/Weapons/MP5/mp5weapact.wav",
}

PickupOC14=CreateWeaponPickup(params);
