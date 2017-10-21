Steyr = {
	-- DESCRIPTION:
	-- Single shot is powerful, with a more recoil
	-- Auto is not as powerful, less recoil and does not travel as far
	-- Its a louder than the MP-5 but also more powerful
	-- good all round gun

	name			= "Steyr",
	object		= "Objects/Weapons/Steyr/Steyr_bind.cgf",
	character	= "Objects/Weapons/Steyr/Steyr.cgf",
	
	DoesFTBSniping = 1,
	bSteyr = 1,
	MaxZoomSteps =  1,
	ZoomSteps = { 2.5 },
	ZoomActive = 0,
	
	PlayerSlowDown = 0.8,		-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/steyr_act.wav",0,100),	-- sound to play when this weapon is selected
	silencer = "_c_aug",
	silencer_off_timer = 0.64,
	silencer_on_timer = 0.64,
	---------------------------------------------------
	MaxZoomSteps =  1,
	ZoomSteps = { 2.5 },
	ZoomActive = 0,
--	AimMode=0,
	putdown_val = 0.15,
--	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
--	ZoomFixedFactor=1,
	ZoomNoSway=0, 	--Matto=0 vorher 1		--no sway in zoom mode

	FireParams ={													-- describes all supported firemodes
	{
		AmmoType="Assault",
		HasCrosshair=1,
		reload_time= 2.3,
		fire_rate=0.092,  --0.082 M4
		distance=700,
		damage=13,
		silenced="sounds/weapons/steyr/steyr_silent.wav",
		damage_drop_per_meter=0.008,
		bullet_per_shot=1,
		fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
		bullets_per_clip=30,
		FModeActivationTime = 0.3,
		iImpactForceMul = 20,
		iImpactForceMulFinal = 45,
		
--		ScopeTexId = GetScopeTex(),

--		BulletRejectType=BULLET_REJECT_TYPE_RAPID,
		
		-- make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=8,
		whizz_probability=350,	-- 0-1000
		whizz_sound={
			Sound:Load3DSound("Sounds/weapons/bullets/whiz1.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz2.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz3.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz4.wav",SOUND_UNSCALABLE,100,1,8),
		},
		
		-- recoil values
		min_recoil=0,
		max_recoil=0.9,	-- its only a small recoil as more people seem to like it that way
		
		--FireLoop="Sounds/Weapons/Steyr/FINAL_M4_MONO_LOOP.wav",
		--FireLoopStereo="Sounds/Weapons/Steyr/FINAL_M4_STEREO_LOOP.wav", --FINAL_M4_STEREO_LOOP.wav
		--TrailOff="Sounds/Weapons/Steyr/FINAL_M4_MONO_TAIL.wav",
		--TrailOffStereo="Sounds/Weapons/Steyr/FINAL_M4_STEREO_TAIL.wav",
		
		FireSounds = {
			"Sounds/Weapons/steyr/Steyr_Singefire_hfcr.wav",
			"Sounds/Weapons/steyr/Steyr_Singefire_hfcr.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/steyr/Steyr_Singefire_hfcr.wav",
			"Sounds/Weapons/steyr/Steyr_Singefire_hfcr.wav",
		},


		DrySound = "Sounds/Weapons/DE/dryfire.wav",
		
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
			size = 3.0, 
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
					
			size = {0.125,0.0015},--0.15,0.25,0.35,0.3,0.2},
			size_speed = 4.3,
			speed = 0.0,
			focus = 20,
			lifetime = 0.03,
			
			sprite = {
					{
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzlesix3.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzlesix4.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzlesix5.dds"),
					}
					,
					{
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle4.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle5.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle6.dds"),
					}
				},
				
			stepsoffset = 0.05,
			steps = 2,
			gravity = 0.0,
			AirResistance = 0,
			rotation = 3,
			randomfactor = 10,
			color = {0.9,0.9,0.9},
		},

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_OICW_fpv.cgf",
			bone_name = "spitfire",
			lifetime = 0.1,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Steyr/mf_steyr_tpv.cgf",
			bone_name = "weapon_bone",
			lifetime = 0.05,
		},
		

		-- trace "moving bullet"	
		-- remove this if not nedded for current weapon
		Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail.cgf"),
			focus = 5000,
			color = { 1, 1, 1},
			speed = 130.0,
			count = 1,
			size = 1.0, 
			size_speed = 0.0,
			gravity = { x = 0.0, y = 0.0, z = 0.0 },
			lifetime = 0.04,
			frames = 0,
			color_based_blending = 3,
			particle_type = bor(8,32),
			bouncyness = 0,
		},

		SoundMinMaxVol = { 225, 4, 2600 },
	},

},
		SoundEvents={
		--	animname,	frame,	soundfile		
		{	"reload1",	4,			Sound:LoadSound("Sounds/Weapons/Steyr/steyr_reload.wav",0,200)},
	},
}


function Steyr:ZoomZoggle( Active )
	if ( Active==0 ) then
		if ( Steyr.ZoomSound ) then
			Sound.StopSound( Steyr.ZoomSound );
		end
	end
end

function Steyr:DrawZoomOverlay( ZoomStep )
	-- if we're in the sniper-scope send an SNIPER-mood-event
	if ( ZoomStep ~= self.PrevZoomStep ) then
		if ( Steyr.ZoomSound ) then
			Sound:StopSound( Steyr.ZoomSound );
			Sound:PlaySound( Steyr.ZoomSound );
		end
		self.PrevZoomStep = ZoomStep;
	end

	if ( Steyr.ZoomBackgroundTID ) then
		-- [tiago] note image inversion, in order to achieve one-one texel to pixel mapping we must correct texture coordinates
		-- also, texture wrap should be set to clamping mode... i hacked texture coordinates a bit to go around incorrect texture wrapping mode...
		local fTexelW=1.0/512.0;
		local fTexelH=1.0/1024.0;

		System:DrawImageColorCoords( Steyr.ZoomBackgroundTID, 400, 600, -400, -600, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
		System:DrawImageColorCoords( Steyr.ZoomBackgroundTID, 400, 600, 400, -600, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
	end

	if ( Steyr.ZoomDirtID ) then
		local fTexelW=1.0/512.0;
		local fTexelH=1.0/512.0;
		System:DrawImageColorCoords( Steyr.ZoomDirtID, 250, 150, 300, 300, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);

	end
end

CreateBasicWeapon(Steyr);


function Steyr.Client:OnInit()
	Steyr.ZoomBackgroundTID=System:LoadImage("Textures/zoom.dds");
	Steyr.ZoomDirtID=System:LoadImage("Textures/zoomDirt.dds");
	self.ZoomOverlayFunc = Steyr.DrawZoomOverlay;
	BasicWeapon.Client.OnInit(self);
end
------------------
--ANIMTABLE
------------------
--AUTOMATIC FIRE
Steyr.anim_table={}
Steyr.anim_table[1]={
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
		"Fire12",
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
}