M1911 = {
-- Modified by Mixer 2009 - more CS-like (realistic trigger behavior) + indoor/outdoor sounds improvement
name			= "M1911",
object		= "Objects/weapons/1911/1911_bind.cgf",
character	= "Objects/weapons/1911/1911.cgf",

PlayerSlowDown = 1.0,
ActivateSound = Sound:LoadSound("Sounds/Weapons/DE/deweapact.wav",0,120),
MaxZoomSteps =  1,
ZoomSteps = { 1.2 },
ZoomActive = 0,
AimMode=1,	
ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
ZoomFixedFactor=1,
ZoomNoSway=1,
silencer="_m1911",
silencer_off_timer = 0.64,
silencer_on_timer = 0.64,

	FireParams ={													-- describes all supported firemodes
	{
		HasCrosshair=1,
		type = 2,					-- used for choosing animation - is pistol 
		min_recoil=2,
		max_recoil=1.5,
		AmmoType="Pistol",
		reload_time= 1.62,
		fire_rate= 0.2,
		tap_fire_rate=0.1,
		distance= 500,
		damage= 11,
		damage_drop_per_meter= 0.008,
		bullet_per_shot= 1,
		bullets_per_clip=7,
		fire_activation=bor(FireActivation_OnPress),
		FModeActivationTime = 2.0,
		iImpactForceMul = 20,
		iImpactForceMulFinal = 65.02,
		silenced="Sounds/Weapons/1911/1911_silent.wav",
		BulletRejectType=BULLET_REJECT_TYPE_SINGLE,
		aim_offset={x=0.13,y=0.08,z=-0.02},
		-- make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=8,
		whizz_probability=350,	-- 0-1000
		whizz_sound={
			Sound:Load3DSound("Sounds/weapons/bullets/whiz1.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz2.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz3.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz4.wav",SOUND_UNSCALABLE,100,1,8),
		},
		FireSounds = {
			"Sounds/Weapons/1911/1911_fire.wav",
			"Sounds/Weapons/1911/1911_fire.wav",
			"Sounds/Weapons/1911/1911_fire.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/1911/1911_fire.wav",
			"Sounds/Weapons/1911/1911_fire.wav",
			"Sounds/Weapons/1911/1911_fire.wav",
		},

		DrySound = "Sounds/Weapons/DE/dryfire.wav",
		
		ShellCases = {
			geometry=System:LoadObject("Objects/Weapons/shells/smgshell.cgf"),
			focus = 1.5,
			color = { 1, 1, 1},
			speed = 0.1,
			count = 1,
			size = 4.0, 
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
			lifetime = 0.5,
			sprite = System:LoadTexture("textures\\cloud1.dds"),
			stepsoffset = 0.3,
			steps = 4,
			gravity = 1.2,
			AirResistance = 3,
			rotation = 3,
			randomfactor = 50,
		},
		
		MuzzleEffect = {
			size = {0.1},--0.15,0.25,0.35,0.3,0.2},
			size_speed = 4.3,
			speed = 0.0,
			focus = 20,
			lifetime = 0.03,
			sprite = System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle1.dds"),
			stepsoffset = 0.15,
			steps = 1,
			gravity = 0.0,
			AirResistance = 0,
			rotation = 30,
			randomfactor = 10,
		},

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_DE_fpv.cgf",
			bone_name = "spitfire",
			lifetime = 0.07,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_DE_tpv.cgf",
			bone_name = "weapon_bone",
			lifetime = 0.05,
		},

		Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail.cgf"),
			focus = 5000,
			color = { 1, 1, 1},
			speed = 110.0,
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

		SoundMinMaxVol = { 200, 4, 2600 },
		
		LightFlash = {
			fRadius = 3.0,
			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			vSpecRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			fLifeTime = 0.1,
		},
	},
	},
	
	SoundEvents={
		--	animname,	frame,	soundfile												---
		{	"reload1",	10,			Sound:LoadSound("Sounds/Weapons/DE/DEclipout_10.wav",0,100)},
		{	"reload1",	25,			Sound:LoadSound("Sounds/Weapons/DE/DEclipin_25.wav",0,100)},
		{	"reload1",	38,			Sound:LoadSound("Sounds/Weapons/DE/DEclipslap_38.wav",0,100)},
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
	},
}

CreateBasicWeapon(M1911);
--ANIMTABLE
M1911.anim_table={}
--SINGLE SHOT
M1911.anim_table[1]={
	idle={
		"Idle11",
	},
	reload={
		"Reload1",
	},
	fidget={
		"fidget11",
		"fidget21",
	},
	fire={
		"Fire11",
	},
	melee={
		"Melee"
	},
	silencer_off={
		"Activate1",
	},
	silencer_on={
		"Activate1",
	},
	swim={
		"swim"
	},
	activate={
		"Activate1"
	},
};

