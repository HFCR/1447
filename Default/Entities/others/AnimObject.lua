AnimObject = {
	Properties = {
		bResting = 0,
		bPhysicalize = 0,
		Animation = "default",
--		fileModel="Objects/characters/mercenaries/new_mercs/merc_m_heavy_a.cgf",
		fileModel="Objects/characters/story_characters/valerie/valeri.cgf",
		bPlaying=0,
		max_time_step = 0.025,
		lying_damping = 1.5,
                bCollidesWithPlayers = 0,
                bPushableByPlayers = 0,
                Mass = 80,
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
		bAlwaysUpdate=0,
		
		PhysParams = {
		mass = 80,
		height = 1.8,
		eyeheight = 1.7,
		sphereheight = 1.2,
		radius = 0.45,
	        },
		
		attachmet1={
			boneName="weapon_bone",
			fileObject="Objects/Weapons/M4/M4_bind.cgf",
		},
		attachmet2={
			boneName="",
			fileObject="",
		},
		attachmet3={
			boneName="",
			fileObject="",
		},
		attachmet4={
			boneName="",
			fileObject="",
		},
--		boneName="weapon_bone",
--		fileAttachment="",
		
	},
	
};

function AnimObject:Event_StartAnimation(sender)
	self:StartAnimation(0,self.Properties.Animation);
end

function AnimObject:Event_StopAnimtion(sender)
	self:ResetAnimation(0);
end


function AnimObject:OnReset()
	if (self.Properties.fileModel ~= "") then
		self:LoadCharacter(self.Properties.fileModel,0);

		if(self.Properties.bPhysicalize == 1) then
			self:CreateStaticEntity( 200, 0 );
			self:PhysicalizeCharacter(200, 0, 73, 0);
		end			
	end
	
	--for idx,piece in self.pieces do
	
	-- Draw object loaded in slot 0 in normal mode
----	self:DrawObject(0, 1);
	if(self.Properties.attachmet1.fileObject ~= "") then
		self:LoadObject( self.Properties.attachmet1.fileObject, 0, 1);
--		self:DrawObject(0, 0);
		self:AttachObjectToBone( 0, self.Properties.attachmet1.boneName );
	end
	if(self.Properties.attachmet2.fileObject ~= "") then
		self:LoadObject( self.Properties.attachmet2.fileObject, 1, 1);
		self:AttachObjectToBone( 1, self.Properties.attachmet2.boneName );
--		self:DrawObject(1, 1);
	end
	if(self.Properties.attachmet3.fileObject ~= "") then
		self:LoadObject( self.Properties.attachmet3.fileObject, 2, 1);
		self:AttachObjectToBone( 2, self.Properties.attachmet3.boneName );
	end
	if(self.Properties.attachmet4.fileObject ~= "") then
		self:LoadObject( self.Properties.attachmet4.fileObject, 3, 1);
		self:AttachObjectToBone( 3, self.Properties.attachmet4.boneName );
	end
	
	
	-- Physicalize the object and give it an initial velocity to clear player properly
	if (self.Properties.bPlaying == 1) then
		self:StartAnimation(0,self.Properties.Animation);
	else
		self:ResetAnimation(0);
	end
	
	if (self.Properties.bAlwaysUpdate == 1) then
		self:EnableUpdate(1);
		self:SetUpdateType( eUT_Unconditional );
	else
		self:EnableUpdate(0);
		self:SetUpdateType( eUT_Visible );
	end
end

function AnimObject:Event_HideAttached(sender)
	self:DetachObjectToBone( self.Properties.attachmet1.boneName );
--	self:DrawObject(0, 0);
--	self:DrawObject(1, 0);
--	self:DrawCharacter(0, 0);
--	self:DrawCharacter(1, 0);
	
end

function AnimObject:Event_ShowAttached(sender)
	self:AttachObjectToBone( 0, self.Properties.attachmet1.boneName );
--	self:DrawObject(0, 1);
--	self:DrawObject(0, 0);
end

-----------------------Hunter_FC
function AnimObject:Server_OnInit()
	if(self.isPhysicalized == 0) then	
		self:SetUpdateType( eUT_Physics );
		AnimObject.OnPropertyChange( self );
		self.isPhysicalized = 1;	
	end

end

function AnimObject:Client_OnInit()
	if(self.isPhysicalized == 0) then	
		self:SetUpdateType( eUT_Physics );
		AnimObject.OnPropertyChange( self );
		self.isPhysicalized = 1;	
	end


	self:SetShaderFloat("HeatIntensity",0,0,0);
end

AnimObject.Client =
{
	OnInit = AnimObject.Client_OnInit,
	OnDamage=AnimObject.Client_OnDamage,
}

function AnimObject:Physicalize()
	self:CreateLivingEntity(self.PhysParams, Game:GetMaterialIDByName("mat_flesh"));
	local nMaterialID=Game:GetMaterialIDByName("mat_meat");
	self:PhysicalizeCharacter(self.PhysParams.mass, nMaterialID, self.BulletImpactParams.stiffness_scale, 0);
	self:SetCharacterPhysicParams(0,"", PHYSICPARAM_SIMULATION,self.BulletImpactParams);
	self:KillCharacter(0);
	if (self.Properties.lying_damping) then
		self.AnimObjectParams.lying_damping = self.Properties.lying_damping;
	end	
  if (self.Properties.lying_gravityz) then
		self.AnimObjectParams.lying_gravityz = self.Properties.lying_gravityz;
	end	
	self:SetPhysicParams(PHYSICPARAM_SIMULATION, self.AnimObjectParams);
	self:SetPhysicParams(PHYSICPARAM_ARTICULATED, self.AnimObjectParams);
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

function AnimObject:Server_OnDamageDead( hit )

	if( hit.ipart ) then
		self:AddImpulse( hit.ipart, hit.pos, hit.dir, hit.impact_force_mul );
	else	
		self:AddImpulse( -1, hit.pos, hit.dir, hit.impact_force_mul );
	end	
end

------------------------Hunter_FC----CryTop

function AnimObject:OnPropertyChange()
	self:OnReset();
end

function AnimObject:OnInit()
	self:OnReset();
end

function AnimObject:OnShutDown()
end

function AnimObject:OnSave(stm)
end

function AnimObject:OnLoad(stm)
end