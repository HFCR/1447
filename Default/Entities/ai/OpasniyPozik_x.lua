
OpasniyPozik_x = {

	PropertiesInstance = {
		sightrange = 110,
		soundrange = 10,
		aibehavior_behaviour = "Job_StandIdle",
		groupid = 154,
		fileHelmetModel = "Objects/characters/story_characters/op/op_cap.cgf",
		bHelmetOnStart = 1,
		bHasLight = 0,
		bGunReady = 0,
	},


	Properties = {
			fMeleeDistance = 0,
			fDamageMultiplier = 1,
			fRushPercentage=-1,
			customParticle = "",
			fRocketSpeed = 40,
			fRocketDamageOverride = -1,
			bShootSmartRocketsForward = 1,
			bDumbRockets = 0,
			bSmartMelee = 0,
			bHasShield = 0,
			special = 0,
			bInvulnerable = 0,
			KEYFRAME_TABLE = "BASE_HUMAN_MODEL",
			SOUND_TABLE = "",
			suppressedThrhld = 5.5,
			bAffectSOM = 1,
			bSleepOnSpawn = 1,
			
		
			bHasArmor = 1,
			dropArmor = 0,

			horizontal_fov = 130,
			eye_height = 2.1,
			forward_speed = 1.81,
			back_speed = 1.5,
			responsiveness = 7.5,
			species = 1,
			fSpeciesHostility = 2,
			fGroupHostility = 0,
			fPersistence = 0.5,
			AnimPack = "Basic",
			SoundPack = "",

			aicharacter_character = "Morph",
			fileModel = "Objects/characters/mercenaries/Merc_cover/merc_cover.cgf",
			max_health = 170,
			pathname = "",
			pathsteps = 0,
			pathstart = 0,
			ReinforcePoint = "",
			bPushPlayers = 1,
			bPushedByPlayers = 1,

			AttachHelmetToBone = "hat_bone",

		aggression = 1,	-- 0 = passive, 1 = total aggression


		commrange = 30.0,
		attackrange = 150,
		accuracy = 0.5,

		equipEquipment = "Machete",
		equipDropPack =  "",
		bTrackable=1,
		speed_scales={
			run	=3.5,
			crouch	=.8,
			prone	=.5,
			xrun	=1.5,
			xwalk	=.81,
			rrun	=3.63,
			rwalk	=.94,
			},
		AniRefSpeeds = {
			WalkFwd = 1.27,
			WalkSide = 1.22,
			WalkBack = 1.29,
			WalkRelaxedFwd = 1.0487,
			WalkRelaxedSide = 1.22,
			WalkRelaxedBack = 1.04,
			XWalkFwd = 1.2,
			XWalkSide = 1.0, 
			XWalkBack = 0.94,
			XRunFwd = 4.5,
			XRunSide = 3.5, 
			XRunBack = 4.5,
			RunFwd = 4.62,
			RunSide = 3.57,
			RunBack = 4.62,
			CrouchFwd = 1.02,
			CrouchSide = 1.02,
			CrouchBack = 1.04,
	},
	},

	PhysParams = {
		mass = 80,
		height = 1.8,
		eyeheight = 1.7,
		sphereheight = 1.2,
		radius = 0.45,
	},

--pe_player_dimensions structure
	PlayerDimNormal = {
		height = 1.8,
		eye_height = 1.7,
		ellipsoid_height = 1.2,
		x = 0.45,
		y = 0.45,
		z = 0.6,
	},
	PlayerDimCrouch = {
		height = 1.5,
		eye_height = 1.0,
		ellipsoid_height = 0.95,
		x = 0.45,
		y = 0.45,
		z = 0.5,
	},
	PlayerDimProne = {
		height = 0.4,
		eye_height = 0.5,
		ellipsoid_height = 0.35,
		x = 0.45,
		y = 0.45,
		z = 0.2,
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
		
	  water_damping = 0.1,
	  water_resistance = 1000,
	},
	BulletImpactParams = {
    stiffness_scale = 73,
    max_time_step = 0.02
  },


	-- Reloading related

	AI_DynProp = {
		air_control = 0.9, --filippo:was 0.4  -- default 0.6
		gravity = 9.81,--18.81,
		jump_gravity = 15.0,--gravity used when the player jump, if this parameter dont exist normal gravity is used also for jump.
		swimming_gravity = -1.0,
		inertia = 10.0,
		swimming_inertia = 1.0,
		nod_speed = 50.0,--filippo:was 60
		min_slide_angle = 46,
		max_climb_angle = 55,
		min_fall_angle = 70,
		max_jump_angle = 50,
	},

	GrenadeType = "ProjFlashbangGrenade",
	
	
	SoundEvents={
						{"srunfwd",		7  },
						{"srunfwd",		19 },
						{"srunback",		5  },
						{"srunback",		14 },

						{"swalkback", 		0  },
						{"swalkback", 		16 },
						{"swalkfwd",  		2  },
						{"swalkfwd",  		19 },

						{"xwalkfwd", 		2  },
						{"xwalkfwd", 		26 },
						{"xwalkback", 		0  },
						{"xwalkback", 		23 },

						{"cwalkback",		9  },
						{"cwalkback",		33 },
						{"cwalkfwd",		12 },
						{"cwalkfwd",		31 },

						{"pwalkfwd",		3  },
						{"pwalkback",		3  },

						{"arunback",		6  },
						{"arunback", 		15 },
						{"arunfwd", 		7  },
						{"arunfwd", 		19 },
							
						{"awalkback", 		1  },
						{"awalkback", 		17 },
						{"awalkfwd", 		1  },
						{"awalkfwd", 		20 },
							
						{"draw01", 		14, KEYFRAME_HOLD_GUN },
						{"draw02", 		9, KEYFRAME_HOLD_GUN },
						{"draw03", 		12, KEYFRAME_HOLD_GUN },
						{"draw04", 		14, KEYFRAME_HOLD_GUN },
						{"holster01", 		25, KEYFRAME_HOLSTER_GUN },
						{"holster02", 		35, KEYFRAME_HOLSTER_GUN },
						{"_fixfence_loop",	8,	Sound:Load3DSound("SOUNDS/items/ratchet.wav",SOUND_UNSCALABLE,100,5,30)},
					},

	
	
	painSounds = {
		{"Sounds/mutants/op/op_pain1.wav",SOUND_UNSCALABLE,255,5,100},
		{"Sounds/mutants/op/op_pain2.wav",SOUND_UNSCALABLE,255,5,100},
	},

	deathSounds = {
		{"Sounds/mutants/op/op_death1.wav",SOUND_UNSCALABLE,255,5,150},
	},

	chattersounds_c = {
		{"Sounds/mutants/op/op_w1.wav",SOUND_UNSCALABLE,255,5,95},
		{"Sounds/mutants/op/op_w2.wav",SOUND_UNSCALABLE,255,5,95},
		{"Sounds/mutants/op/op_w3.wav",SOUND_UNSCALABLE,255,5,95},
		{"Sounds/mutants/op/op_w4.wav",SOUND_UNSCALABLE,255,5,95},
		{"Sounds/mutants/op/op_w5.wav",SOUND_UNSCALABLE,255,5,95},
	},
}
