Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="Crowbar",
	ammotype=nil,
	model="Objects/weapons/crowbar/crowbar_2_bind.cgf",
	default_amount=30,
	sound="Sounds/player/playermovement/gingle9.wav",
	objectangles = {x = 75, y = 0, z = 90},
	objectpos = {x = 0, y = 0, z = 0},
}

PickupCrowbar=CreateWeaponPickup(params);
