DeadBody = {
  	type = "DeadBody",
	isPhysicalized = 0,
	temp_ModelName ="",
	
	DeadBodyParams = {
	  max_time_step = 0.025,
	  gravityz = -7.5,
	  sleep_speed = 0.025,
	  damping = 0.3,
	  freefall_gravityz = -9.81,
	  freefall_damping = 0.1,

	  lying_mode_ncolls = 4,
	  lying_gravityz = -5.0,
	  lying_sleep_speed = 0.065,
	  lying_damping = 1.5,
	  sim_type = 1,
		lying_simtype = 1,
	},

	PhysParams = {
		mass = 80,
		height = 1.8,
		eyeheight = 1.7,
		sphereheight = 1.2,
		radius = 0.45,
	},

  BulletImpactParams = {
    stiffness_scale = 73,
    max_time_step = 0.01
  },

	Properties = {
		bResting = 1,
		fileModel = "Objects/characters/mercenaries/Merc_rear/merc_rear.cgf",
		lying_gravityz = -5.0,
		lying_damping = 1.5,
		bCollidesWithPlayers = 0,
		bPushableByPlayers = 0,
		Mass = 80,
	},
}

function DeadBody:OnReset()
	self.dhit = nil;
	if (strsub(self.Properties.fileModel, strlen(self.Properties.fileModel)-13, strlen(self.Properties.fileModel)-3)=="utant_fast.") then
		self.Properties.fileModel = "Objects/characters/mutants/mutant_gree/mutant_fast.cgf";
		self.iamavedroid = 1;
	end
	self:LoadCharacter(self.Properties.fileModel,0);
	self:StartAnimation( 0,"cidle" );
	self:Physicalize();
end

function DeadBody:Server_OnInit()
	if(self.isPhysicalized == 0) then	
		self:SetUpdateType( eUT_Physics );
		DeadBody.OnPropertyChange( self );
		self.isPhysicalized = 1;	
	end

end

function DeadBody:Client_OnInit()
	if(self.isPhysicalized == 0) then	
		self:SetUpdateType( eUT_Physics );
		DeadBody.OnPropertyChange( self );
		self.isPhysicalized = 1;	
	end
	self:SetShaderFloat("HeatIntensity",0,0,0);
end

function DeadBody:Server_OnDamageDead( hit )
	--if (hit.target_material) then
	--	Hud:AddMessage(hit.target_material.type);
	--	return;
	--end
	if (hit.shooter) and (hit.shooter.cnt) and (hit.shooter.cnt.weapon) and (hit.shooter.cnt.weapon.hit_delay) then
		self.dhit = hit;
		self:SetTimer(hit.shooter.cnt.weapon.hit_delay*1000);
		return;
	end
	if (hit.ipart) then
		self:AddImpulse( hit.ipart, hit.pos, hit.dir, hit.impact_force_mul );
	else	
		self:AddImpulse( -1, hit.pos, hit.dir, hit.impact_force_mul );
	end	
end

function DeadBody:OnPropertyChange()
	self.PhysParams.mass = self.Properties.Mass;
	if (self.Properties.fileModel ~= self.temp_ModelName) then
		if (strsub(self.Properties.fileModel, strlen(self.Properties.fileModel)-13, strlen(self.Properties.fileModel)-3)=="utant_fast.") then
			self.Properties.fileModel = "Objects/characters/mutants/mutant_gree/mutant_fast.cgf";
			self.iamavedroid = 1;
		end
		self.temp_ModelName = self.Properties.fileModel;
		self:LoadCharacter(self.Properties.fileModel,0);
	end
	self:Physicalize();
end

function DeadBody:Physicalize()
	if (self.iamavedroid) and (Mission) and (Mission.bVedroids) and (Mission.bVedroids == 1) and (self:GetMaterial()==nil) then
		self:SetMaterial('Level.Mutants.cis_vedroid_slave');
	end
	self.iamavedroid = nil;
	self:CreateLivingEntity(self.PhysParams, Game:GetMaterialIDByName("mat_flesh"));
	local nMaterialID=Game:GetMaterialIDByName("mat_meat");
	self:PhysicalizeCharacter(self.PhysParams.mass, nMaterialID, self.BulletImpactParams.stiffness_scale, 0);
	self:SetCharacterPhysicParams(0,"", PHYSICPARAM_SIMULATION,self.BulletImpactParams);
	self:KillCharacter(0);
	if (self.Properties.lying_damping) then
		self.DeadBodyParams.lying_damping = self.Properties.lying_damping;
	end	
	if (self.Properties.lying_gravityz) then
		self.DeadBodyParams.lying_gravityz = self.Properties.lying_gravityz;
	end	
	self:SetPhysicParams(PHYSICPARAM_SIMULATION, self.DeadBodyParams);
	self:SetPhysicParams(PHYSICPARAM_ARTICULATED, self.DeadBodyParams);
	local flagstab = { flags_mask=geom_colltype_player, flags=geom_colltype_player*self.Properties.bCollidesWithPlayers };
	self:SetPhysicParams(PHYSICPARAM_PART_FLAGS, flagstab);
	flagstab.flags_mask = pef_pushable_by_players;
	flagstab.flags = pef_pushable_by_players*self.Properties.bPushableByPlayers;
	self:SetPhysicParams(PHYSICPARAM_FLAGS, flagstab);
	self:EnablePhysics(1);
	if (self.Properties.bResting == 1) then
		self:AwakePhysics(0);
	else
		self:AwakePhysics(1);
	end
end

function DeadBody:Event_Awake()
	self:AwakePhysics(1);
	if Game:IsMultiplayer() then
		self:AddImpulse( -1, self:GetBonePos("Bip01"), {x=0,y=0,z=1}, 8 );
	else
		self:AddImpulseObj({x=0,y=0,z=1},8);
	end
end

DeadBody.Server =
{
	OnInit = DeadBody.Server_OnInit,
	OnDamage = DeadBody.Server_OnDamageDead,
	OnTimer = function(self)
		if (self.dhit) and (self.dhit.ipart) then
			self:AddImpulse( self.dhit.ipart, self.dhit.pos, self.dhit.dir, self.dhit.impact_force_mul );
		elseif (self.dhit) then
			self:AddImpulse( -1, self.dhit.pos, self.dhit.dir, self.dhit.impact_force_mul );
		end
		self.dhit = nil;
	end,  
}

DeadBody.Client =
{
	OnInit = DeadBody.Client_OnInit,
	OnDamage=DeadBody.Client_OnDamage,
}
