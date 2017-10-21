Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	ammotype="HandGrenade",
	model="Objects/pickups/grenade/grenade_frag_pickup.cgf",
	default_amount=1,
	sound="sounds/items/grenade_pickup.wav"
}


AmmoHandGrenades=CreateAmmoPickup(params);


function AmmoHandGrenades:LoadGeometry()
	if (not self.geometry) then
		self.geometry=1;
		if (Mission and Mission.alienworld) then
			self:LoadObject("Objects/Pickups/Grenades/plasm_ball_pickup.cgf",0,1);
		else
			self:LoadObject(self.model, 0, 1);
		end
		self:DrawObject( 0, 1 );
	end
	
	if (self.objectangles) then
		self:SetObjectAngles(0, self.objectangles);
	end
	
	if (self.objectpos) then
		self:SetObjectPos(0, self.objectpos);
	elseif (self.rotate90) then
		self:SetObjectPos(0,{x=0,y=0,z=0.1});
	end
end 
