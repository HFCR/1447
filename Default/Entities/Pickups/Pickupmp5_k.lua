Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="mp5_k",
	ammotype="SMG",
	model="Objects/Weapons/mp5_k/mp5_k_pickup.cgf",
	default_amount=30,
	sound="Sounds/Weapons/P90/P90weapact.wav",
}

Pickupmp5_k=CreateWeaponPickup(params);
