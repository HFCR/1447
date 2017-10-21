AK74 = {
	name			= "AK74",
	object		= "Objects/Weapons/AK74/ak74_bind.cgf",
	character	= "Objects/Weapons/AK74/ak74.cgf",

	---------------------------------------------------
	PlayerSlowDown = 0.88,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/P416/Vectorweapact.wav",0,100),	-- sound to play when this weapon is selected
	---------------------------------------------------
	silencer_off_timer = 0.64,
	silencer_on_timer = 0.64,
	noputdown = 1,
	silencer="_ak",
	MaxZoomSteps =  1,
	ZoomSteps = { 1.8 },
	ZoomActive = 0,
	ZoomSound=Sound:LoadSound("Sounds/items/scope_all.wav"),
	AimMode=1,
	putdown_val = 0.17,	
	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	ZoomFixedFactor=1,
	ZoomNoSway=1, 			--no sway in zoom mode

	---------------------------------------------------
	FireParams =
	{													-- describes all supported 	firemodes
	{
		HasCrosshair=1,
		animatedrun=1,
		AmmoType="Assault",
		reload_time=2.6,
		fire_rate=0.1,
		silenced="Sounds/weapons/m4/m4_silent.wav",
		aim_offset={x=-0.134,y=0,z=-0.02},
		distance=400,
		damage=8, -- default = 8
		damage_drop_per_meter=.012,
		damage=13,
		bullet_per_shot=1,
		bullets_per_clip=30,
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
		
		--FireLoop="Sounds/Weapons/p90/FINAL_Vector_MONO_LOOP.wav",
		--FireLoopStereo="Sounds/Weapons/p90/FINAL_Vector_STEREO_LOOP.wav",
		--TrailOff="Sounds/Weapons/p90/FINAL_Vector_MONO_TAIL.wav",
		--TrailOffStereo="Sounds/Weapons/p90/FINAL_Vector_STEREO_TAIL.wav",
		
		FireSounds = {
			"Sounds/Weapons/vector/SingleFire_Mono.wav",
			"Sounds/Weapons/vector/SingleFire_Mono.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/vector/SingleFire_Mono.wav",
			"Sounds/Weapons/vector/SingleFire_Mono.wav",
			"Sounds/Weapons/vector/SingleFire_Mono.wav",
		},

		
		
		DrySound = "Sounds/Weapons/P90/DryFire.wav",
		
		LightFlash = {
			fRadius = 3.0,
			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			vSpecRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			fLifeTime = 0.1,
		},

		ShellCases = {
			geometry=System:LoadObject("Objects/Weapons/shells/rifleshell.cgf"),
			focus = 1.5,
			color = { 1, 1, 1},
			speed = 0.1,
			count = 1,
			size = 2.0, 
			size_speed = 0.0,
			gravity = { x = 0.0, y = 0.0, z = 0.0 },
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
	--	MuzzleFlash = {
	--		geometry_name = "Objects/Weapons/Muzzle_flash/mf_P90_fpv.cgf",
	--		bone_name = "spitfire",
	--		lifetime = 0.135,
	--	},
	--	MuzzleFlashTPV = {
	--		geometry_name = "Objects/Weapons/Muzzle_flash/mf_p90_tpv.cgf",
	--		bone_name = "weapon_bone",
	--		lifetime = 0.05,
	--	},

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

		MuzzleFlash = { 
		geometry_name = "Objects/Weapons/Muzzle_flash/mf_ag36_fpv.cgf", 
		bone_name = "spitfire", 
		lifetime = 0.15, 
		size = 1.0,
},
		SoundMinMaxVol = { 225, 4, 2600 },
	},	
	},
                SoundEvents={
		--	animname,	frame,	soundfile
		{	"reload1",	14,			Sound:LoadSound("Sounds/Weapons/New/clipout.wav",0,166)},
		{	"reload1",	52,			Sound:LoadSound("Sounds/Weapons/New/clipin.wav",0,141)},
		{	"reload1",	60,			Sound:LoadSound("Sounds/Weapons/New/ak47_32.wav",0,150)},
		{	"activate1",21,			Sound:LoadSound("Sounds/Weapons/New/ak47_32.wav",0,150)},
	},

}




CreateBasicWeapon(AK74);

--function P416.Client:OnUpdate(delta,shooter)
--_localplayer.cnt.weapon:SetFirstPersonWeaponPos({x=0.134*_localplayer.fireparams.aim_offset.x,y=0*_localplayer.fireparams.aim_offset.y,z=0.02*_localplayer.fireparams.aim_offset.z}, g_Vectors.v000);
--_localplayer.cnt.weapon:SetFirstPersonWeaponPos({x=0.134,y=0,z=0.02}, g_Vectors.v000);
--_localplayer.cnt.weapon:SetFirstPersonWeaponPos({x=0.134*_localplayer.fireparams.aim_offset.x,y=0*_localplayer.fireparams.aim_offset.y,z=0.02*_localplayer.fireparams.aim_offset.z}, g_Vectors.v000);
--BasicWeapon.Client.OnUpdate(self,delta,shooter);
--end



---------------------------------------------------------------
--ANIMTABLE
------------------
AK74.anim_table={}
--AUTOMATIC FIRE
AK74.anim_table[1]={
	idle={
		"idle11",
		"idle12",
	},
	reload={
		"reload1",
	},
	fire={
		"fire11",
		"fire21",
	},
	run={
		"run1",
	},
	swim={
		"swim"
	},
	activate={
		"activate1"
	},
}
--P416.anim_table[2]=P416.anim_table[1];