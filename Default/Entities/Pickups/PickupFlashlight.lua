Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self,collider)
	if (collider.cnt.has_flashlight == 1) then
		return nil;
	end
	local serverSlot = Server:GetServerSlotByEntityId(collider.id);
	if (serverSlot) then
		serverSlot:SendCommand("GI F");
	end
	collider.cnt.has_flashlight = 1;
	return 1;
end

local params={
	func=funcPick,
	model="Objects/pickups/flashlight/flashlight.cgf",
	default_amount=1,
	sound="sounds/items/flight.wav",
	modelchoosable=nil,
	soundchoosable=nil,
	floating_icon="Objects/Pickups/flashlight/flashlight_icon.cga"
}

PickupFlashlight=CreateCustomPickup(params);
