Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self, collider, entering)

	--self:NotifyMessage("collider.cnt.armor="..collider.cnt.armor..", collider.cnt.max_armor="..collider.cnt.max_armor);	

	if (collider.Grab_Invisibility) then
		collider:Grab_Invisibility(self.Properties.Amount);
		-- send armor catch 
		local serverSlot = Server:GetServerSlotByEntityId(collider.id);
		if (serverSlot) then	
			serverSlot:SendCommand("HUD P 1 "..self.Properties.Amount); -- hud, generic pick, armor, amount
		end

		return 1;
	end
	return nil;
end

local params={
	func=funcPick,
	model="Objects/Pickups/grim_gear_invisibility.cgf",
	default_amount=20,
	sound="sounds/player/zipper.wav",
	modelchoosable=nil,
	soundchoosable=nil,
}

Gear_Invisibility=CreateCustomPickup(params);

function Gear_Invisibility:OnReset()
	self.geometry = nil;
	self.physicalized = nil;
	self:LoadGeometry();
	self:Physicalize();
	if (GameRules) and (Game:IsMultiplayer()) and (GameRules.sv_promode==nil) and (self.Properties.Amount2) and (tonumber(self.Properties.Amount2)==0) then
		self.Properties.RespawnTime = 0;
		self:GotoState("Picked");
	else
		self:GotoState("Active");
	end
end