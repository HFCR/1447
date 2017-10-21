--- MERCSNIPER (TWEAKED BY MIXER 2007) ---
MercSniper_x = {

	PropertiesInstance = {
		sightrange = 140,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		aibehavior_behaviour = "Job_StandIdle",
		groupid = 154,
		fileHelmetModel = "",
		bHelmetOnStart = 0,
		specialInfo= "",
		bHasLight = 0,
		attackrange = 500,
		aggression = 0.9,
		accuracy = 0.4,
		bGunReady = 0,
	},


	Properties = {
			equipEquipment = "SniperRifle",
			equipDropPack = "SniperRifle",
			special = 0,
			bInvulnerable = 0,
			KEYFRAME_TABLE = "BASE_HUMAN_MODEL",
			SOUND_TABLE = "MERC_COVER",
			suppressedThrhld = 5.5,
			bAffectSOM = 1,
			bSleepOnSpawn = 1,
			bSmartMelee = 0,
			
			bHasArmor = 1,
			dropArmor = 0,

			horizontal_fov = 130,
			eye_height = 2.1,
			forward_speed = 1.27,
			back_speed = 1.27,
			responsiveness = 7.5,
			species = 1,
			fSpeciesHostility = 2,
			fGroupHostility = 0,
			fPersistence = 0.5,
			AnimPack = "Basic",
			SoundPack = "VoiceC",

			aicharacter_character = "Sniper",
			fileModel = "Objects/characters/mercenaries/Merc_sniper/merc_sniper.cgf",
			max_health = 150,
			pathname = "",
			pathsteps = 0,
			pathstart = 0,
			ReinforcePoint = "",
			special = 0,





		commrange = 30.0,

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

	GrenadeType = "ProjFlashbangGrenade",

}