--- MUTANTSCREW SCRIPT (BY MIXER 2009) ---
MutantScrew = {
	NoFallDamage = 1,
	MeleeHitType="melee_slash",
	MUTANT = 1,
	NEVER_FIRE = 1,
	isSelfCovered = 0,
	footsteparray = {0,0,0},
	footstepcount = 1,
	lastMeleeAttackTime = 0,

	PropertiesInstance = {
		sightrange = 105,
		soundrange = 9,	
		groupid = 154,
		aibehavior_behaviour = "MutantJob_Idling",
		},

	Properties = {
		bSingleMeleeKillAI = 0,
		fDamageMultiplier = 0.074, -- boss 0.043
		fJumpAngle = 20,
		gravity_multiplier = 3,
		SOUND_TABLE = "MUTANT_SCREW",
		KEYFRAME_TABLE = "MUTANT_SCREW",
		JUMP_TABLE = "SMALL_ABBERATION",
		fMeleeDamage = 300,
		bAffectSOM = 1,	
		suppressedThrhld = 5.5,
		fMeleeDistance = 2,	
		bSleepOnSpawn = 0,
		bHelmetOnStart = 0,
		bHasArmor = 1,
		fileHelmetModel = "",
		aggression = 0.6,	-- 0 = passive, 1 = total aggression
		commrange = 30.0,
		attackrange = 70,
		horizontal_fov = 160,
		eye_height = 2.1,
		forward_speed = 1.83,
		back_speed = 1.83,
		max_health = 255,	
		accuracy = 0.6,
		responsiveness = 7,
		species = 100,
		special = 0,

		fSpeciesHostility = 4,
		fGroupHostility = 0,
		fPersistence = 0,
		equipEquipment = "",
		equipDropPack = "",
		AnimPack = "mat_water",
		SoundPack = "",

		aicharacter_character = "Chimp",
		pathname = "",
		pathsteps = 0,
		pathstart = 35,
		ReinforcePoint = "",
		fileModel = "Objects/characters/mutants/Mutant_screwed/Mutant_screwed.cgf",
		bTrackable=1,

		speed_scales={
			run	=2.52,
			crouch	=.8,
			prone	=.5,
			xrun	=1.5,
			xwalk	=.81,
			rrun	=2.52,
			rwalk	=.94,
			},

		AniRefSpeeds = {
			WalkFwd = 1.83,
			WalkSide = 1.83,
			WalkBack = 1.83,
			WalkRelaxedFwd = 1.83,
			WalkRelaxedSide = 1.83,
			WalkRelaxedBack = 1.83,
			XWalkFwd = 1.83,
			XWalkSide = 1.83, 
			XWalkBack = 1.83,
			XRunFwd = 4.5,
			XRunSide = 3.5, 
			XRunBack = 4.5,
			RunFwd = 3.36,
			RunSide = 3.36,
			RunBack = 3.36,
			CrouchFwd = 1.83,
			CrouchSide = 1.83,
			CrouchBack = 1.83,
		},
	},

	PhysParams = {
		mass = 400,
		height = 2.8,
		eyeheight = 2.7,
		sphereheight = 1.2,
		radius = 3.45,
	},


--pe_player_dimensions structure
	PlayerDimNormal = {
		height = 2.2,
		eye_height = 2.1,
		ellipsoid_height = 1.7,
		x = 0.710,
		y = 0.10,
		z = 0.7,
	},
	PlayerDimCrouch = {
		height = 2.2,
		eye_height = 2.1,
		ellipsoid_height = 1.9,
		x = .710,
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
	  lying_damping = 1.0,

    water_damping = 0.5,
    water_resistance = 1000,
	},
	BulletImpactParams = {
    stiffness_scale = 40,
    impulse_scale = 5,
    max_time_step = 0.02
  },
	
	  		SoundEvents={
			{"srunfwd",	3,			},
			{"srunfwd",	17,			},
			{"srunback",	9,			},
			{"srunback",	22,			},
			
			{"swalkback",   2,			},
			{"swalkback",   22,			},
			{"swalkfwd",     3,			},
			{"swalkfwd",    23,			},
			
			{"arunfwd",	3,			},
			{"arunfwd",	17,			},
			{"arunback",	9,			},
			{"arunback",	22,			},
			
			{"awalkback",   2,			},
			{"awalkback",   22,			},
			{"awalkfwd",     3,			},
			{"awalkfwd",    23,			},
			{"attack_melee1",	10,		KEYFRAME_APPLY_MELEE},
			{"attack_melee2",	16,		KEYFRAME_APPLY_MELEE},
			{"attack_melee3",	16,		KEYFRAME_APPLY_MELEE},
			{"attack_melee4",	12,		KEYFRAME_APPLY_MELEE},
			{"attack_melee5",	14,	KEYFRAME_APPLY_MELEE},
			{"jump_forward1", 23, KEYFRAME_APPLY_MELEE},
			{"jump_forward2", 23, KEYFRAME_APPLY_MELEE},
			{"jump_forward3", 24, KEYFRAME_APPLY_MELEE},
			{"jump_forward4", 22, KEYFRAME_APPLY_MELEE},
			{"attack_melee1",	4,	Sound:Load3DSound("Sounds/mutants/Mswipe3.wav",SOUND_UNSCALABLE,175,2,60)},
			{"attack_melee1",	1,	Sound:Load3DSound("Sounds/mutants/Mthreaten1.wav",SOUND_UNSCALABLE,255,2,200)},
			{"attack_melee2",	13,	Sound:Load3DSound("SOUNDS/mutants/cover/cover_melee2swipeF13.wav",SOUND_UNSCALABLE,175,2,60)},
			{"attack_melee2",	1,	Sound:Load3DSound("Sounds/mutants/Mthreaten2.wav",SOUND_UNSCALABLE,255,2,200)},
			{"attack_melee3",	10,	Sound:Load3DSound("SOUNDS/mutants/cover/cover_melee3swipeF10.wav",SOUND_UNSCALABLE,175,2,60)},
			{"attack_melee3",	1,	Sound:Load3DSound("Sounds/mutants/Mthreaten1.wav",SOUND_UNSCALABLE,255,2,200)},
			{"attack_melee4",	10,	Sound:Load3DSound("SOUNDS/mutants/cover/cover_melee4swipeF10.wav",SOUND_UNSCALABLE,175,2,60)},
			{"attack_melee4",	1,	Sound:Load3DSound("Sounds/mutants/Mthreaten3.wav",SOUND_UNSCALABLE,255,2,200)},
			{"attack_melee5",	2,	Sound:Load3DSound("Sounds/mutants/Mswipe1.wav",SOUND_UNSCALABLE,255,2,200)},
			{"idle00",	7,	KEYFRAME_BREATH_SOUND},
			{"idle01",	1,	Sound:Load3DSound("Sounds/mutants/Mthreaten4.wav",SOUND_UNSCALABLE,255,8,200)},
			{"idle02",	1,	Sound:Load3DSound("Sounds/mutants/Mthreaten5.wav",SOUND_UNSCALABLE,255,8,200)},
			{"idle03",	1,	Sound:Load3DSound("Sounds/mutants/Mthreaten6.wav",SOUND_UNSCALABLE,255,8,200)},
			{"idle04",	1,	Sound:Load3DSound("Sounds/mutants/Mthreaten5.wav",SOUND_UNSCALABLE,255,8,200)},
			{"idle05",	7,	KEYFRAME_BREATH_SOUND},
		},
	painSounds = {
			{"Sounds/mutants/ab3/idle1.wav",SOUND_UNSCALABLE,255,2,220},
			{"Sounds/mutants/ab3/idle2.wav",SOUND_UNSCALABLE,255,2,220},
			{"Sounds/mutants/ab3/idle3.wav",SOUND_UNSCALABLE,255,2,220},
			{"Sounds/mutants/ab3/idle4.wav",SOUND_UNSCALABLE,255,2,220},
			{"Sounds/mutants/ab3/idle5.wav",SOUND_UNSCALABLE,255,2,220},
		},

	deathSounds = {
			{"Sounds/mutants/ab3/idle3.wav",SOUND_UNSCALABLE,255,6,200},
			{"Sounds/mutants/ab3/idle4.wav",SOUND_UNSCALABLE,255,6,200},
			{"Sounds/mutants/ab3/idle2.wav",SOUND_UNSCALABLE,255,6,200},			
		},

	chattersounds = {
			{"Sounds/mutants/ab3/idle1.wav",SOUND_UNSCALABLE,255,6,220},
			{"Sounds/mutants/ab3/idle2.wav",SOUND_UNSCALABLE,255,6,220},
			{"Sounds/mutants/ab3/idle3.wav",SOUND_UNSCALABLE,255,6,220},
			{"Sounds/mutants/ab3/idle4.wav",SOUND_UNSCALABLE,255,6,220},
			{"Sounds/mutants/ab3/idle5.wav",SOUND_UNSCALABLE,255,6,220},
		},
	
	footstepsounds = {
			{"Sounds/player/footsteps/rock/run1.wav",SOUND_UNSCALABLE,199,10,100},
			{"Sounds/player/footsteps/rock/run2.wav",SOUND_UNSCALABLE,199,10,100},
			{"Sounds/player/footsteps/rock/run4.wav",SOUND_UNSCALABLE,199,10,100},
		},
		
		jumpsounds = {
			{"Sounds/mutants/cover/exert_5.wav",SOUND_UNSCALABLE,255,5,190},		
		},
		
	--jump sounds
	landsounds = {
			{"Sounds/mutants/cover/cover_groundsmash1F0.wav",SOUND_UNSCALABLE,255,7,130},
		}, 

	GrenadeType = "ProjFlashbangGrenade",

	ImpulseParameters = {
		rmin = 1,
		rmax = 1,
		impulsive_pressure = 300,
		rmin_occlusion =0,
		occlusion_res =0,
		occlusion_inflate = 0,
	},


}

-------------
function MutantScrew:OnInitCustom(  )

	self.cnt:CounterAdd("SuppressedValue", -2.0 );

end

------------
function MutantScrew:OnResetCustom()

	self.cnt:CounterSetValue("SuppressedValue", 0.0 );
	self.isSelfCovered = 0;
	self.lastMeleeAttackTime = 0;
	if (self.Properties.equipEquipment ~= "") then
		self.NEVER_FIRE = nil;
	end
end
-------------
MutantScrew=CreateAI(MutantScrew)