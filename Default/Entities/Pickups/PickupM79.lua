Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="M79",
	ammotype="AG36Grenade",
	model="Objects/Weapons/M79/M79_bind.cgf",
	default_amount=5,
        default_amount2=5,	
	sound="sounds/weapons/AK47/ak47weapact.wav"
}

PickupM79=CreateWeaponPickup(params);
