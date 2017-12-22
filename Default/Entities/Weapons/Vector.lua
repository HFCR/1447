
Vector = {
	name			= "Vector",
	object		= "Objects/Weapons/Vector/Vector_bind.cgf",
	character	= "Objects/Weapons/Vector/Vector.cgf",

	---------------------------------------------------
	PlayerSlowDown = 0.88,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/Vector/Vectorweapact.wav",0,100),	-- sound to play when this weapon is selected
	---------------------------------------------------
	MaxZoomSteps =  1,
	ZoomSteps = { 2 },
	--AimMode=1,
	putdown_val = 0.11,
	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	ZoomFixedFactor=1,
        ZoomNoSway=0, 			--no sway in zoom mode 
	ZoomActive = 0,												-- initially always 0
	MaxZoomSteps = 2,
	ZoomSteps = { 2, 4 },	---------------------------------------------------
	DoesFTBSniping = 1,
	DrawFlare=1,
	ZoomDeadSwitch = 1,

	---------------------------------------------------
	FireParams =
	{													-- describes all supported 	firemodes
	{
		HasCrosshair=1,
		AmmoType="Pistol",
		reload_time=2.6,
		fire_rate=0.14,
		distance=400,
		damage=8, -- default = 8
		damage_drop_per_meter=.012,
		bullet_per_shot=1,
		bullets_per_clip=70,
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
			"Sounds/Weapons/Vector/vector_p.wav",
			"Sounds/Weapons/Vector/vector_p.wav",
			"Sounds/Weapons/Vector/vector_p.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/Vector/vector_p.wav",
			"Sounds/Weapons/Vector/vector_p.wav",
			"Sounds/Weapons/Vector/vector_p.wav",
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

		SoundMinMaxVol = { 225, 4, 2600 },
	},	
	{
		HasCrosshair=1,
		AmmoType="Pistol",
		reload_time=2.6,
		fire_rate=0.1,
		distance=400,
		damage=8, -- default = 8
		damage_drop_per_meter=.012,
		bullet_per_shot=1,
		bullets_per_clip=30,
		FModeActivationTime = 1.0,
		iImpactForceMul = 20,
		iImpactForceMulFinal = 45,
		fire_activation=FireActivation_OnPress,
		
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
			"Sounds/Weapons/Vector/vector_p.wav",
			"Sounds/Weapons/Vector/vector_p.wav",
			"Sounds/Weapons/Vector/vector_p.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/Vector/vector_p.wav",
			"Sounds/Weapons/Vector/vector_p.wav",
			"Sounds/Weapons/Vector/vector_p.wav",
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

		SoundMinMaxVol = { 225, 4, 2600 },
	}
	},

		SoundEvents={
		--	animname,	frame,	soundfile
		{	"reload1",	12,			Sound:LoadSound("Sounds/Weapons/vector/out.wav",0,100)},
		{	"reload1",	40,			Sound:LoadSound("Sounds/Weapons/vector/in.wav",0,100)},
		{	"reload1",	53,			Sound:LoadSound("Sounds/Weapons/P99_act.wav",0,100)},
--		{	"swim",		1,				Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
	},
}

function Vector:DrawZoomOverlay( ZoomStep )
	if ( Vector.ZoomBackgroundTID ) then
		-- [tiago] note image inversion, in order to achieve one-one texel to pixel mapping we must correct texture coordinates
		-- also, texture wrap should be set to clamping mode... i hacked texture coordinates a bit to go around incorrect texture wrapping mode...
		local fTexelW=1.0/512.0;
		local fTexelH=1.0/512.0;

		System:DrawImageColorCoords( Vector.ZoomBackgroundTID, 400, 600, 400+Hud.hdadjust*1.52, -600, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
		System:DrawImageColorCoords( Vector.ZoomBackgroundTID, 400, 600, -400-Hud.hdadjust*1.52, -600, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
	--	System:DrawImageColorCoords( Vector.ZoomBackgroundTID, 400, 300, -400+Hud.hdadjust*1.52, 300, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
	--	System:DrawImageColorCoords( Vector.ZoomBackgroundTID, 400, 300, 400-Hud.hdadjust*1.52, 300, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
		if (Hud.hdadjust > 0) then
	--	System:DrawImageColorCoords( Vector.ZoomBackgroundTID, Hud.hdadjust*1.52-700, 300, 700, -300, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
	--	System:DrawImageColorCoords( Vector.ZoomBackgroundTID, Hud.hdadjust*1.52-700, 300, 700, 300, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
	--	System:DrawImageColorCoords( Vector.ZoomBackgroundTID, 1500-Hud.hdadjust*1.52, 300, -700, -300, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
	--	System:DrawImageColorCoords( Vector.ZoomBackgroundTID, 1500-Hud.hdadjust*1.52, 300, -700, 300, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
		end
	end
	%System:Draw2DLine(400,300-0.5,400,300+0.5,0,1,0,1);
	%System:Draw2DLine(400-0.5,300,400+0.5,300,0,1,0,1);
end

CreateBasicWeapon(Vector);


function Vector.Client:OnInit()
	Vector.ZoomBackgroundTID=System:LoadImage("Textures/zoom");
	self.ZoomOverlayFunc = Vector.DrawZoomOverlay;
	BasicWeapon.Client.OnInit(self);
end
---------------------------------------------------------------
--ANIMTABLE
------------------
Vector.anim_table={}
--AUTOMATIC FIRE
Vector.anim_table[1]={
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
		"Fire21",
		"Fire31",
	},

	swim={
		"swim",
	},
	activate={
		"Activate1",
	},
}
Vector.anim_table[2]=Vector.anim_table[1];