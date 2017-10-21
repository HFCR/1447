Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self,collider)
	if (collider.cnt.has_binoculars == 1) then
		return nil;
	end
	local serverSlot = Server:GetServerSlotByEntityId(collider.id);
	if (serverSlot) then
		serverSlot:SendCommand("GI B");
	end
	collider.cnt.has_binoculars = 1;
	return 1;		
end

local params={
	func=funcPick,
	model="Objects/pickups/binoculars/binocular.cgf",
	default_amount=1,
	sound="sounds/items/generic_pickup.wav",
	modelchoosable=nil,
	soundchoosable=nil,
	floating_icon="Objects/Pickups/binoculars/binocular_icon.cga",
	objectpos = {x=0, y=0, z=-0.07},
}

PickupBinoculars=CreateCustomPickup(params);
