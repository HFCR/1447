Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="Meat",
	ammotype="Meat",
	model="Objects/Weapons/Meat/meat_pickup.cgf",
	default_amount=2,
	sound="sounds/weapons/Machete/MACHETE_PICKUP.wav",
	objectangles = {x = 75, y = 0, z = 90},
	objectpos = {x = 0, y = 0, z = 0.2},
}

PickupMeat=CreateWeaponPickup(params);
