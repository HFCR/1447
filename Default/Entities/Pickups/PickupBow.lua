Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="Bow",
	ammotype="Arrows",
	model="Objects/Weapons/Bow/Bow_bind.cgf",
	default_amount=40,
	sound="Sounds/Weapons/Bow/Bow_act.wav",
}

PickupBow=CreateWeaponPickup(params);