Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	ammotype="HandMga",
	model="Objects/weapons/x850/grenade_pickup.cgf",
	default_amount=1,
	sound="sounds/items/grenade_pickup.wav"
}


AmmoHandMga=CreateAmmoPickup(params);