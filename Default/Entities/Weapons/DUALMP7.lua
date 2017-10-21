DUALMP7 = {
	name			= "DUALMP7",
	object		= "Objects/Weapons/DUALMP7/dualmp7_bind.cgf",
	character	= "Objects/Weapons/DUALMP7/DUALMP7.cgf",

	---------------------------------------------------
	PlayerSlowDown = 0.9,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/duals_act.wav",0,100),	-- sound to play when this weapon is selected
	---------------------------------------------------

	NoZoom=1,

	---------------------------------------------------
	FireParams =
	{													-- describes all supported 	firemodes
	{
		HasCrosshair=1,
		AmmoType="SMG",
		reload_time=2.6,
		fire_rate=0.1,
		distance=400,
		damage=8, -- default = 8
		damage_drop_per_meter=.012,
		bullet_per_shot=2,
		bullets_per_clip=80,
		FModeActivationTime = 1.0,
		iImpactForceMul = 20,
		iImpactForceMulFinal = 45,
		fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
		
		BulletRejectType=BULLET_REJECT_TYPE_RAPID,
		
		-- make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=8,
		whizz_probability=250,	-- 0-1000
		whizz_sound={
			Sound:Load3DSound("Sounds/weapons/bullets/whiz1.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz2.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz3.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz4.wav",SOUND_UNSCALABLE,100,1,8),
		},
		
		FireLoop="Sounds/Weapons/DualMP7/FINAL_P90_MONO_LOOP.wav",
		FireLoopStereo="Sounds/Weapons/DualMP7/FINAL_P90_STEREO_LOOP.wav",
		TrailOff="Sounds/Weapons/p90/FINAL_P90_STEREO_TAIL.wav",
		TrailOffStereo="Sounds/Weapons/DualMP7/FINAL_P90_STEREO_TAIL.wav",
		DrySound = "Sounds/Weapons/P90/DryFire.wav",
		
		LightFlash = {
			fRadius = 4.0,
			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.75, a = 1.0, },
			vSpecRGBA = { r = 1.0, g = 1.0, b = 0.75, a = 1.0, },
			fLifeTime = 0.17,
		},

		ShellCases = {
			geometry=System:LoadObject("Objects/Weapons/shells/smgshell.cgf"),
			focus = 1.5,
			color = { 1, 1, 1},
			speed = 0.1,
			count = 1,
			size = 2.0, 
			size_speed = 0.0,
			gravity = { x = 0.0, y = 0.0, z = -9.81 },
			lifetime = 5.0,
			frames = 0,
			color_based_blending = 0,
			particle_type = 0,
		},
		ShellCases2 = {
			geometry=System:LoadObject("Objects/Weapons/shells/smgshell.cgf"),
			focus = 1.5,
			color = { 1, 1, 1},
			speed = 0.1,
			count = 1,
			size = 2.0, 
			size_speed = 0.0,
			gravity = { x = 0.0, y = 0.0, z = -9.81 },
			lifetime = 5.0,
			frames = 0,
			color_based_blending = 0,
			particle_type = 0,
		},
		
		SmokeEffect = {
			size = {0.15,0.07,0.035,0.01},
			size_speed = 1.3,
			speed = 9.0,
			focus = 3,
			lifetime = 0.25,
			sprite = System:LoadTexture("textures\\cloud1.dds"),
			stepsoffset = 0.3,
			steps = 4,
			gravity = 1.2,
			AirResistance = 3,
			rotation = 3,
			randomfactor = 50,
		},
		
		MuzzleEffect = {
			size = {0.08,0.007},
			size_speed = 1.3,
			speed = 0.0,
			focus = 20,
			lifetime = 0.03,
			sprite = {
					{
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzleP90.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzleP902.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzleP903.dds"),
					},
					{
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle4.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle5.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle6.dds"),
					},			
				},
					
			stepsoffset = 0.01,
			steps = 2,
			gravity = 0.0,
			AirResistance = 0,
			rotation = 3,
			randomfactor = 10,
			
			color = {0.7,0.9,1.0},
		},

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_P90_fpv.cgf",
			bone_name = "spitfire",
			lifetime = 0.135,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/Plane_von_vok_rofl.cgf",
			bone_name = "weapon_bone",
			lifetime = 0.05,
		},

		-- trace "moving bullet"	
		Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail.cgf"),
			focus = 5000,
			color = { 1, 1, 1},
			speed = 120.0,
			count = 1,
			size = 1.0, 
			size_speed = 0.0,
			gravity = { x = 0.0, y = 0.0, z = 0.0 },
			lifetime = 0.04,
			frames = 0,
			color_based_blending = 3,
			particle_type = 0,
			bouncyness = 0,
		},

		SoundMinMaxVol = { 225, 4, 2600 },
	}	},

		SoundEvents={
		--	animname,	frame,	soundfile
		{	"reload1",	12,			Sound:LoadSound("Sounds/Weapons/DualMP7/duals_clip_out.wav",0,100)},
		{	"reload1",	50,			Sound:LoadSound("Sounds/Weapons/DualMP7/duals_clip_in.wav",0,100)},
		{	"reload1",	79,			Sound:LoadSound("Sounds/Weapons/DualMP7/duals_reload_cock.wav",0,100)},
	},
}

CreateBasicWeapon(DUALMP7);

---------------------------------------------------------------
--ANIMTABLE
------------------
DUALMP7.anim_table={}
--AUTOMATIC FIRE
DUALMP7.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	reload={
		"Reload1",	
	},
	fidget={
		"fidget11",
	},
	fire={
		"Fire11",
		"Fire12",
		"Fire13",
	},
	swim={
		"swim",
	},
	activate={
		"Activate1",
	},
}