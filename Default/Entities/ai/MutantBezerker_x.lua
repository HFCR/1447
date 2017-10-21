--- MutantBezerker (TWEAKED BY MIXER 2007) ---
MutantBezerker_x = {

	NoFallDamage = 1,
	MeleeHitType="melee_slash",
	MUTANT = 1,
	NEVER_FIRE = 1,
	isSelfCovered = 0,
	lastMeleeAttackTime = 0,
	footsteparray = {0,0,0},
	footstepcount = 1,

	PropertiesInstance = {
		sightrange = 35,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		groupid = 153,
		aibehavior_behaviour = "Job_PatrolPathNoIdle",
		},

	Properties = {
		special = 0,
		fJumpAngle = 20,
		gravity_multiplier = 3,
		bSingleMeleeKillAI = 0,
		fDamageMultiplier = 1,
		JUMP_TABLE = "BIG_ABBERATION",
		KEYFRAME_TABLE = "MUTANT_MONKEY",
		SOUND_TABLE = "MUTANT_STEALTH",
		fMeleeDamage = 200,
		fMeleeDistance = 1.5,
		suppressedThrhld = 5.5,
		bAffectSOM = 1,
		bSleepOnSpawn = 0,
		bHelmetOnStart = 0,
		bHasArmor = 1,
		fileHelmetModel = "",
		aggression = 0.7,	-- 0 = passive, 1 = total aggression
		commrange = 30.0,
		attackrange = 3,
		horizontal_fov = 160,
		eye_height = 1.1,
		forward_speed = 1.59,
		back_speed = 1.59,
		max_health = 250,
		accuracy = 0.6,
		responsiveness = 7,
		species = 100,
		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,
		equipEquipment = "",
		equipDropPack = "",
		AnimPack = "Basic",
		SoundPack = "mutant_ab2",
		aicharacter_character = "Chimp",
		pathname = "monstersway",
		pathsteps = 0,
		pathstart = 13,
		ReinforcePoint = "",
		fileModel = "Objects/characters/Mutants/Mutant_Aberration/mutant_aberration.cgf",				
		bTrackable=1,
		ImpulseParameters = {
			rmin = 2,
			rmax = 3,
			impulsive_pressure = 100,
			rmin_occlusion =0,
			occlusion_res =0,
			occlusion_inflate = 0,
		},

		speed_scales={
			run	=3.29,
			crouch	=1,
			prone	=1,
			xrun	=3.29,
			xwalk	=1,
			rrun	=3.29,
			rwalk	=3,
			},
		AniRefSpeeds = {
			RunFwd = 5.23,
			RunBack = 5.23,
			RunSide = 5.23,
			WalkFwd = 1.59,
			WalkBack = 1.59,
			WalkSide = 1.59,
			WalkRelaxedFwd = 1.59,
			WalkRelaxedSide = 1.59,
			WalkRelaxedBack = 1.59,
			XWalkFwd = 1.59,
			XWalkSide = 1.59, 
			XWalkBack = 1.59,
			XRunFwd = 4.5,
			XRunSide = 3.5, 
			XRunBack = 4.5,
			CrouchFwd = 1.59,
			CrouchSide = 1.59,
			CrouchBack = 1.59,
		},
	},
	
	PhysParams = {
		mass = 80,
		height = 2.8,
		eyeheight = 2.7,
		sphereheight = 1.2,
		radius = 0.45,
	},


--pe_player_dimensions structure
	PlayerDimNormal = {
		height = 1,
		eye_height = .9,
		ellipsoid_height = .875,
--		x = 0.5,
		x = 0.45,
		y = 0.10,
		z = 0.35,
	},
	PlayerDimCrouch = {
		height = 1,
		eye_height = .9,
		ellipsoid_height = .9,
--		x = .5,
		x = .45,	
		y = 0.10,
		z = 0.7,
	},
	PlayerDimProne = {
		height = 0.4,
		eye_height = 0.5,
		ellipsoid_height = 0.35,
		x = 0.45,
		y = 0.45,
		z = 4.2,
	},
	


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
	  lying_damping = 1.0,
	},
	BulletImpactParams = {
    stiffness_scale = 73,
    max_time_step = 0.02
  },
		SoundEvents={
			{"srunfwd",	0,			},
			{"srunfwd",	10,			},
			{"srunfwd",	20,			},
			{"srunback",	5,			},
			{"srunback",	13,			},
			
			{"swalkback",   2,			},
			{"swalkback",   18,		},
			{"swalkfwd",     3,		},
			{"swalkfwd",    20,		},
			
			{"arunfwd",	0,			},
			{"arunfwd",	10,			},
			{"arunfwd",	20,			},
			{"arunback",	5,			},
			{"arunback",	13,			},
			
			{"awalkback",   2,			},
			{"awalkback",   18,		},
			{"awalkfwd",     3,		},
			{"awalkfwd",    20,		},

			{"attack_melee1", 9, Sound:Load3DSound("SOUNDS/weapons/machete/fire1.wav",SOUND_UNSCALABLE,255,5,60)},
			{"attack_melee2", 12, Sound:Load3DSound("SOUNDS/weapons/machete/fire1.wav",SOUND_UNSCALABLE,255,5,60)},
			{"attack_melee3", 7, Sound:Load3DSound("SOUNDS/weapons/machete/fire1.wav",SOUND_UNSCALABLE,255,5,60)},
			{"attack_melee4", 9, Sound:Load3DSound("SOUNDS/weapons/machete/fire1.wav",SOUND_UNSCALABLE,255,5,60)},
			{"attack_melee4", 18, Sound:Load3DSound("SOUNDS/weapons/machete/fire1.wav",SOUND_UNSCALABLE,255,5,60)},
			{"idle00", 1, Sound:Load3DSound("SOUNDS/mutants/ab1/abidle3.wav",SOUND_UNSCALABLE,255,5,190)},
			{"idle01", 1, Sound:Load3DSound("SOUNDS/mutants/ab1/abidle1.wav",SOUND_UNSCALABLE,255,5,190)},
			{"idle03", 1, Sound:Load3DSound("SOUNDS/mutants/ab1/abidle2.wav",SOUND_UNSCALABLE,255,5,190)},
		},
	painSounds = {
			{"SOUNDS/mutants/ab1/pain.wav",SOUND_UNSCALABLE,255,5,200},
		},

	deathSounds = {
			{"SOUNDS/mutants/ab1/death1.wav",SOUND_UNSCALABLE,255,5,200},
		},

	chattersounds = {
			{"SOUNDS/mutants/ab1/abidle1.wav",SOUND_UNSCALABLE,175,5,90},
			{"SOUNDS/mutants/ab1/abidle2.wav",SOUND_UNSCALABLE,175,5,90},
			{"SOUNDS/mutants/ab1/abidle3.wav",SOUND_UNSCALABLE,175,5,90},
			{"SOUNDS/mutants/ab1/abidle4.wav",SOUND_UNSCALABLE,175,5,90},
		},
	
	--jump sounds
	jumpsounds = {
			{"SOUNDS/mutants/ab1/melee1.wav",SOUND_UNSCALABLE,255,5,190},
			{"SOUNDS/mutants/ab1/melee2.wav",SOUND_UNSCALABLE,255,5,190},
			{"SOUNDS/mutants/ab1/melee3.wav",SOUND_UNSCALABLE,255,5,190},			
		},
		
	--jump sounds
	landsounds = {
			{"SOUNDS/ai/bodyfall/bodyfalldirt1.wav",SOUND_UNSCALABLE,150,5,90},
			{"SOUNDS/ai/bodyfall/bodyfalldirt2.wav",SOUND_UNSCALABLE,150,5,90},
			{"SOUNDS/ai/bodyfall/bodyfalldirt3.wav",SOUND_UNSCALABLE,150,5,90},
		},
	footstepsounds = {
			{"SOUNDS/player/footsteps/pebble/step1.wav",SOUND_UNSCALABLE,200,10,90},
			{"SOUNDS/player/footsteps/pebble/step2.wav",SOUND_UNSCALABLE,200,10,90},
			{"SOUNDS/player/footsteps/pebble/step3.wav",SOUND_UNSCALABLE,200,10,90},
			{"SOUNDS/player/footsteps/pebble/step4.wav",SOUND_UNSCALABLE,200,10,90},
	},


	GrenadeType = "ProjFlashbangGrenade",

	AI_DynProp = {
		air_control = 0.4,  -- default 0.6
		gravity = 3*9.81,
		swimming_gravity = -1.0,
		inertia = 10.0,
		swimming_inertia = 1.0,
		nod_speed = 60.0,
		min_slide_angle = 46,
		max_climb_angle = 60,
		min_fall_angle = 70,
		max_jump_angle = 55,
	},


	ImpulseParameters = {
		rmin = 1,
		rmax = 1,
		impulsive_pressure = 200,
		rmin_occlusion =0,
		occlusion_res =0,
		occlusion_inflate = 0,
	},



}

-------------------------------------------------------------------------------------------------------
function MutantBezerker_x:OnInitCustom(  )


System:Log("MutantBezerker_x onInitCustom ");

	self.cnt:CounterAdd("SuppressedValue", -2.0 );

end

---------------------------------------------------------------------------------------------------------
function MutantBezerker_x:OnResetCustom()

System:Log("MutantBezerker_x onResetCustom ");

	self.cnt:CounterSetValue("SuppressedValue", 0.0 );
	self.isSelfCovered = 0;
	self.lastMeleeAttackTime = 0;
	
end
---------------------------------------------------------------------------------------------------------

