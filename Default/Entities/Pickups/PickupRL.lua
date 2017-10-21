Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="RL",
	ammotype="Rocket",
	model="Objects/Weapons/RL/RL_bind.cgf",
	default_amount=4,
	sound="sounds/weapons/Mortar/mortar_33.wav",
};

PickupRL=CreateWeaponPickup(params);

function PickupRL:LoadGeometry()
	if(not self.geometry)then
		self.geometry=1;
		local wpn_mode = strupper(getglobal("g_GameType"));
		if (strfind(wpn_mode,"PRO") ~= nil) then
			self:LoadObject("Objects/weapons/grm_010/grm_010_bind.cgf",0,1);
			self.weapon="COVERRL";
		else
			self:LoadObject(self.model, 0, 1);
		end
			self:DrawObject( 0, 1 );
	end
	
	if(self.objectangles)then
		self:SetObjectAngles(0, self.objectangles)
	end
	
	if(self.objectpos)then
		self:SetObjectPos(0, self.objectpos)
	elseif(self.rotate90)then
		self:SetObjectPos(0,{x=0,y=0,z=0.1})
	end
end 
