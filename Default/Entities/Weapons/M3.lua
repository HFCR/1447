M3 = {
	name			= "M3",
	object		= "Objects/Weapons/M3/M3_bind.cgf",
	character	= "Objects/Weapons/M3/M3.cgf",
	
	PlayerSlowDown = 0.75,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/m3_act.wav",0,100),	-- sound to play when this weapon is selected
	---------------------------------------------------

	MaxZoomSteps =  1,
	ZoomSteps = { 1.3 },
	ZoomActive = 0,
	AimMode=1,
	putdown_val = 0.16,
	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,

	---------------------------------------------------

	FireParams ={													-- describes all supported firemodes
	{
		HasCrosshair=1,		
		type = 6,
		AmmoType="Shotgun",
		reload_time=1.334, -- default 3.25
		fire_rate=1.334,
		fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
		distance=100, --100
		damage=40, -- default 30 --20
		silenced="Sounds/weapons/m4/m4_silent.wav",
		damage_drop_per_meter=.08, --0.08
		bullet_per_shot=7,
		bullets_per_clip=8,
		FModeActivationTime = 1.0,
		iImpactForceMul = 25, -- 5 bullets divided by 10
		iImpactForceMulFinal = 100, -- 5 bullets divided by 10
		
		BulletRejectType=BULLET_REJECT_TYPE_SINGLE,
		
		-- make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=8,
		whizz_probability=350,	-- 0-1000
		whizz_sound={
			Sound:Load3DSound("Sounds/weapons/bullets/whiz1.wav",SOUND_UNSCALABLE,55,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz2.wav",SOUND_UNSCALABLE,55,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz3.wav",SOUND_UNSCALABLE,55,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz4.wav",SOUND_UNSCALABLE,55,1,8),
		},
		
		FireSounds = {
			"Sounds/Weapons/M3/M3_FIRE_MONO.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/M3/M3_FIRE_STEREO.wav",
		},
		DrySound = "Sounds/Weapons/Pancor/DryFire.wav",
		ReloadSound = "Sounds/Weapons/Pancor/jackrload.wav",

		LightFlash = {
			fRadius = 5.0,
			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			vSpecRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			fLifeTime = 0.1,
		},
		
		SmokeEffect = {
			size = {0.6,0.3,0.15,0.07,0.035,0.035},
			size_speed = 0.7,
			speed = 9.0,
			focus = 3,
			lifetime = 0.9,
			sprite = System:LoadTexture("textures\\cloud1.dds"),
			stepsoffset = 0.3,
			steps = 6,
			gravity = 0.6,
			AirResistance = 2,
			rotation = 3,
			randomfactor = 50,
		},
		
		MuzzleEffect = {
			size = {0.175},
			size_speed = 3.3,
			speed = 0.0,
			focus = 20,
			lifetime = 0.03,
			sprite = System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle1.dds"),
			stepsoffset = 0.05,
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
			lifetime = 0.12,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/M3/mf_m3_tpv.cgf",
			bone_name = "weapon_bone",
			lifetime = 0.05,
		},
		
		SoundMinMaxVol = { 225, 4, 2600 },
	},
	},

		SoundEvents={
		--	animname,	frame,	soundfile												---
		{	"Fire11",	11,			Sound:LoadSound("Sounds/Weapons/M3/pump.wav",0,100)},

		{	"Fire12",	12,			Sound:LoadSound("Sounds/Weapons/M3/pump.wav",0,100)},

		{	"Fire13",	15,			Sound:LoadSound("Sounds/Weapons/M3/pump.wav",0,100)},

		{	"reload1",	19,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload1",	42,			Sound:LoadSound("Sounds/Weapons/M3/pump.wav",0,100)},

		{	"reload2",	19,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload2",	48,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload2",	61,			Sound:LoadSound("Sounds/Weapons/M3/pump.wav",0,100)},


		{	"reload3",	21,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload3",	45,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload3",	65,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload3",	84,			Sound:LoadSound("Sounds/Weapons/M3/pump.wav",0,100)},

		{	"reload4",	19,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload4",	48,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload4",	74,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload4",	103,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload4",	113,			Sound:LoadSound("Sounds/Weapons/M3/pump.wav",0,100)},

		{	"reload5",	21,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload5",	44,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload5",	65,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload5",	83,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload5",	107,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload5",	127,			Sound:LoadSound("Sounds/Weapons/M3/pump.wav",0,100)},

		{	"reload6",	21,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload6",	45,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload6",	65,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload6",	83,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload6",	107,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload6",	127,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload6",	147,			Sound:LoadSound("Sounds/Weapons/M3/pump.wav",0,100)},

		{	"reload7",	21,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload7",	45,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload7",	65,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload7",	83,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload7",	107,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload7",	127,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload7",	149,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload7",	175,			Sound:LoadSound("Sounds/Weapons/M3/pump.wav",0,100)},

		{	"reload8",	19,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload8",	48,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload8",	74,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload8",	100,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload8",	129,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload8",	155,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload8",	182,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload8",	212,			Sound:LoadSound("Sounds/Weapons/M3/shell_in.wav",0,100)},
		{	"reload8",	223,			Sound:LoadSound("Sounds/Weapons/M3/pump.wav",0,100)},
	},
}

CreateBasicWeapon(M3);



function M3.Client:OnUpdate(delta, shooter)
	if shooter.cnt then
		self.m3toload = shooter.fireparams.bullets_per_clip - shooter.cnt.ammo_in_clip;
		if shooter.cnt.ammo < self.m3toload then
			self.m3toload = shooter.cnt.ammo * 1;
		end
		self.anim_table[shooter.firemodenum].reload[1] = "reload"..self.m3toload;
	end
	return BasicWeapon.Client.OnUpdate(self,delta,shooter);
end

function M3.Server:OnUpdate(delta, shooter)
	if shooter.cnt then
		self.m3toload = shooter.fireparams.bullets_per_clip - shooter.cnt.ammo_in_clip;
		if shooter.cnt.ammo < self.m3toload then
			self.m3toload = shooter.cnt.ammo * 1;
		end
		self.anim_table[shooter.firemodenum].reload[1] = "reload"..self.m3toload;
	end
	return BasicWeapon.Server.OnUpdate(self,delta, shooter);
end
---------------------------------------------------------------
--ANIMTABLE
------------------
M3.anim_table={}
--AUTOMATIC FIRE
M3.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
		"fidget21",
		"Idle21",
                "Idle11",
		"Idle21",
                "Idle11",
		"Idle21",
                "Idle11",
	},
	reload={
		"reload1",	
	},
	fidget={
		"fidget11",
		"fidget21",
	},
	fire={
		"Fire11",
		"Fire11",
		"Fire13",
		"Fire11",
	},
	melee={
		"fire13",
	},
	swim={
		"swim",
	},
	activate={
		"Activate1",
	},
	--modeactivate={},
}