Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	ammotype="RailStick",
	model="Objects/weapons/railbow/railbow_shell.cgf",
	default_amount=9,
	sound="Sounds/Weapons/railbow/railbow_stkpick.wav",
}

AmmoRailStick=CreateAmmoPickup(params);

