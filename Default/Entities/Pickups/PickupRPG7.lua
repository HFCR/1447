Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="RPG7",
	ammotype="RPG7",
	model="Objects/Weapons/RPG7/RPG7_pickup.cgf",
	default_amount=3,
	sound="Sounds/Weapons/FN_SCAR_light/FN_SCAR_light_wact.wav",
}

PickupRPG7=CreateWeaponPickup(params);
