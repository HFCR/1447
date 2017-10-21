Shark = {
---- Modified by Mixer

	MUTANT = nil,
	IsFish = 1,
	PropertiesInstance ={
		sightrange = 112,
		soundrange = 20,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		groupid = 9,
		aibehavior_behaviour = "Job_PatrolPathNoIdle",
		fMinDepth = 12,
		},

	Properties = {
		fMeleeDamage = 100,
		fMeleeDistance = 4,
		KEYFRAME_TABLE = "SHARK",
		SOUND_TABLE = "",
		bAffectSOM = 0,
		suppressedThrhld = 5.5,
		bSleepOnSpawn = 1,
		bHelmetOnStart = 0,
		bHasArmor = 1,
		aggression = 0.3,	-- 0 = passive, 1 = total aggression
		commrange = 30.0,
		attackrange = 110,
		horizontal_fov = 160,
		eye_height = 0.5,
		forward_speed = 3,
		back_speed = 2.5,
		max_health = 70,
		accuracy = 0.6,
		responsiveness = 7,
		species = 100,
		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,
		equipEquipment = "",
		equipDropPack = "",
		AnimPack = "Basic",
		SoundPack = "",
		aicharacter_character = "Screwed",
		pathname = "",
		pathsteps = 0,
		pathstart = 0,
		ReinforcePoint = "",
		fileModel = "Objects/characters/animals/GreatWhiteShark/greatwhiteshark.cgf",
		bTrackable=0,

		speed_scales={
			run			=4.24,
			crouch	=1,
			prone		=1,
			xrun		=1,
			xwalk		=1,
			rrun		=4.24,
			rwalk		=1,
			},
		AniRefSpeeds = {
			WalkFwd = 0.65,
			WalkSide = 0.65,
			WalkBack = 0.65,
			RunFwd = 2.74,
			RunSide = 2.74,
			RunBack = 2.74,
			XWalkFwd = 0.65,
			XWalkSide = 0.65, 
			XWalkBack = 0.65,
			XRunFwd = 4.5,
			XRunSide = 3.5, 
			XRunBack = 4.5,
			CrouchFwd = 0.65,
			CrouchSide = 0.65,
			CrouchBack = 0.65,
		},
	},
	
	PhysParams = {
		mass = 2900,
		height = 1.8,
		eyeheight = 1.7,
		sphereheight = 1.2,
		radius = 0.45,
	},

--pe_player_dimensions structure
	PlayerDimNormal = {
		height = 0.6,
		eye_height = 0.3,
		ellipsoid_height = -0.6,
		x = 2.5,
		y = 1,
		z = 0.5,
	},
	PlayerDimCrouch = {
		height = 0.6,
		eye_height = 0.5,
		ellipsoid_height = .6,
		x = 2.5,
		y = 1,
		z = 1,
	},
	PlayerDimProne = {
		height = 0.6,
		eye_height = 0.5,
		ellipsoid_height = .5,
		x = 2.5,
		y = 1,
		z = 1,
	},
	


	DeadBodyParams = {
		sim_type = 1,
	  max_time_step = 0.025,
	  gravityz = -7.5,
	  sleep_speed = 0.025,
	  damping = 0.3,
	  freefall_gravityz = -9.81,
	  freefall_damping = 0.1,

	  lying_mode_ncolls = 4,
	  lying_gravityz = -5.0,
	  lying_sleep_speed = 0.065,
	  lying_damping = 1.0
	},
	BulletImpactParams = {
    stiffness_scale = 73,
    max_time_step = 0.02
  },

	GrenadeType = "ProjFlashbangGrenade",


}
-------------------------------------------------------------------------------------------------------
function Shark:OnInitCustom(  )

	self.cnt:CounterAdd("SuppressedValue", -2.0 );

end

--------------
function Shark:OnResetCustom()

	self.cnt:CounterSetValue("SuppressedValue", 0.0 );
	self.isSelfCovered = 0;
	self.lastMeleeAttackTime = 0;
	
end

Shark=CreateAI(Shark);

Shark.Server.Alive.OnUpdate = function(self)
	BasicPlayer.Server_OnTimer(self);
	local my_enemy = AI:GetAttentionTargetOf(self.id);
	local my_pos = new(self:GetPos());
	
	if (my_pos.z > self.PropertiesInstance.fMinDepth) then
		my_pos.z = self.PropertiesInstance.fMinDepth;
		self:SetPos(my_pos);
	elseif (my_enemy) and (type(my_enemy)=="table") then
		my_enemy = new(my_enemy:GetPos());
		local depth_diff = my_enemy.z - my_pos.z;
		if (depth_diff > 1) then
			-- push me up
			--self:AddImpulseObj({x=0,y=0,z=1},246);
			my_pos.z = my_pos.z + 0.12;
			self:SetPos(my_pos);
		elseif (depth_diff < 0) then
			-- pull me down
			--self:AddImpulseObj({x=0,y=0,z=-1},242);
			my_pos.z = my_pos.z - 0.12;
			self:SetPos(my_pos);
		end
	end
end
