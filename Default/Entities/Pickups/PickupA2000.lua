Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="A2000",
	ammotype="SMG",
	model="Objects/Weapons/A2000/A2000_bind.cgf",
	default_amount=30,
	sound="Sounds/Weapons/MP5/mp5weapact.wav",
}

PickupA2000=CreateWeaponPickup(params);
