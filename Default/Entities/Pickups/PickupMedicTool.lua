--scripted by Flameknight7 for coop
Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");
local params={
	weapon="MedicTool",
	ammotype="HealthPack",
	model="Objects/pickups/health/medikit.cgf",
	default_amount=1,
	sound="sounds/items/generic_pickup.wav",
	floating_icon="Objects/Pickups/health/health_icon.cga"
}
PickupMedicTool=CreateWeaponPickup(params);