M79 = {
	-- DESCRIPTION:
	-- Grenade Launcher
	name			= "M79",
	object		= "Objects/Weapons/m79/m79_bind.cgf",
	character	= "Objects/Weapons/m79/m79.cgf",

	-- if the weapon supports zooming then add this...
	ZoomActive = 0,	  -- initially always 0
	MaxZoomSteps = 2,
	ZoomSteps = { 2, 4 },
	---------------------------------------------------
	PlayerSlowDown = 0.8,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/AG36/agweapact.wav",0,150),	-- sound to play when this weapon is selected
	---------------------------------------------------
	ZoomNoSway=1,
	---------------------------------------------------

	MaxZoomSteps =  1,
	ZoomSteps = { 1.2 },
	ZoomActive = 0,
	AimMode=1,
		
	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	ZoomFixedFactor=1,
	ZoomNoSway=1,
	---------------------------------------------------

	FireParams ={						-- describes all supported 	firemodes
	{
		FModeActivationTime=1,
		HasCrosshair=1,
		AmmoType="AG36Grenade",
		projectile_class="AG36Grenade",
		reload_time=3.5,
		fire_rate=1.0,
		fire_activation=FireActivation_OnPress,
		bullet_per_shot=1,
		bullets_per_clip=1,

		FireSounds = {
			"Sounds/Weapons/ag36/FINAL_GRENADE_MONO.wav",
			"Sounds/Weapons/ag36/FINAL_GRENADE_MONO.wav",
			"Sounds/Weapons/ag36/FINAL_GRENADE_MONO.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/ag36/FINAL_GRENADE_STEREO.wav",
			"Sounds/Weapons/ag36/FINAL_GRENADE_STEREO.wav",
			"Sounds/Weapons/ag36/FINAL_GRENADE_STEREO.wav",

		},
		DrySound = "Sounds/Weapons/AG36/DryFire.wav",

		SoundMinMaxVol = { 255, 4, 2600 },

		LightFlash = {
			fRadius = 3.0,
			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			vSpecRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			fLifeTime = 0.1,
		},
	},
	},

		SoundEvents={
		--	animname,	frame,	soundfil{	"reload1",	15,			Sound.LoadSound("Sounds/Weapons/ag36/ag36b_15.wav")},
		{	"reload1",	23,			Sound:LoadSound("Sounds/Weapons/ag36/Ag36b_23.wav",0,150)},
		{	"reload1",	38,			Sound:LoadSound("Sounds/Weapons/ag36/Ag36b_38.wav",0,150)},
		{	"reload1",	54,			Sound:LoadSound("Sounds/Weapons/ag36/Ag36b_54.wav",0,150)},
		{	"reload2",	13,			Sound:LoadSound("Sounds/Weapons/ag36/ag36g_13.wav",0,150)},
		{	"reload2",	37,			Sound:LoadSound("Sounds/Weapons/ag36/ag36g_37.wav",0,150)},
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},

	},
}

CreateBasicWeapon(M79);

---------------------------------------------------------------
--ANIMTABLE
------------------
--GRENADE LAUNCHER
M79.anim_table={}
M79.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	reload={
		"Reload2",
	},
	fidget={
		"fidget11",
	},
	fire={
		"Fire21",
		"Fire11",
	},
	melee={
		"Fire11",
		"Fire21",
	},
	swim={
		"swim"
	},
	activate={
		"Activate1"
	},
}