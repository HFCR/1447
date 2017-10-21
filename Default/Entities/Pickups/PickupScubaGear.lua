Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self,collider)
	if ((not self.lasttime) or (_time>(self.lasttime+6))) then
		collider.items.scubagear = 100;
		
		local serverSlot = Server:GetServerSlotByEntityId(collider.id);
		if (serverSlot) then
			serverSlot:SendCommand("HUD P 9 1"); -- hud, generic pick (scuba)
			if (collider.cnt.has_flashlight) and (collider.cnt.has_flashlight == 1) then
			else
				serverSlot:SendCommand("GI F");
			end
		end
		
		self.lasttime=_time;
	end		
	
	return 1;		
end

local params={
	func=funcPick,
	model="Objects/Pickups/cis_scuba_gear_sudak1.cgf",
	default_amount=1,
	sound="Sounds/items/generic_pickup.wav",
	modelchoosable=nil,
	soundchoosable=nil,
	floating_icon="",
	objectpos = {x=0, y=0, z=0.28},
}

PickupScubaGear=CreateCustomPickup(params);

function PickupScubaGear:AttemptPick(collider, entering)
	if (collider.type == "Player") and (collider.cnt.health>0) then
	if (collider.theVehicle) then return end
	if (GameRules:IsInteractionPossible(collider,self)==nil) then return end
	if (collider.items) and (collider.items.aliensuit) then return end -- can't pick it if in aliensuit
	
	local picked = self:Pick(collider, entering, self.ammo_type, self.Properties.Amount);

	if (picked) or (self.ammopicked) then
		if (picked or self.Properties.RespawnTime>0) then
			self.ammopicked = nil;
		end
		if (not self.doesnt_expire) then
			-- CHUNK OF NEW CODE HERE:
			if (collider.OnPickSomething) then
				collider:OnPickSomething();
			end
			---
			self:GotoState("Picked");
		end
	end
	end
end