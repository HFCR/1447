Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self,collider)
	if ((not self.lasttime) or (_time>(self.lasttime+6))) then
		-- set energy to max
		if (collider.items) then
			if collider.items.silencer_a then
				return nil;
			else
				collider.items.silencer_a = "-1";
				local serverSlot = Server:GetServerSlotByEntityId(collider.id);
				if (serverSlot) then
					serverSlot:SendCommand("HUD P 11 1");
				end
				self.lasttime=_time;
				return 1;
			end
		end
	end
end

local params={
	func=funcPick,
	model="Objects/weapons/hands2/silencer_a.cgf",
	default_amount=1,
	sound="sounds/items/generic_pickup.wav",
	modelchoosable=nil,
	soundchoosable=nil,
	floating_icon="",
	objectpos = {x=0, y=0, z=-0.08},
}

PickupSilencer=CreateCustomPickup(params);
