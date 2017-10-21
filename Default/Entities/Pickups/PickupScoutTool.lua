--scripted by Flameknight7 for coop
Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");
local params={
	weapon="ScoutTool",
	ammotype="StickyExplosive",
	model="Objects/Pickups/explosive/explosive_nocount2.cgf",
	default_amount=1,
	sound="sounds/items/generic_pickup.wav",
	floating_icon="Objects/Pickups/misc/special_icon.cga"
}
PickupScoutTool=CreateWeaponPickup(params);