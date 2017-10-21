--[[CryTop team scripting]]--
RPG7 = {
	-- DESCRIPTION
	-- Default weapon, loud and does not travel far but does the job
	name			= "RPG7",
	object		= "Objects/Weapons/RPG7/RPG7_bind.cgf",
	character	= "Objects/Weapons/RPG7/RPG7.cgf",

	--PlayerSlowDown = 1,  --new eightsystem
	--PlayerSlowDown = 0.6,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/FN_SCAR_light/FN_SCAR_light_wact.wav",0,100),	-- sound to play when this weapon is selected
	---------------------------------------------------

	MaxZoomSteps =  1,
	ZoomSteps = { 1.4 },
	ZoomActive = 0,
	AimMode=1,
		
	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	ZoomFixedFactor=1,
	ZoomNoSway=1, 			--no sway in zoom mode

	FireParams ={													-- describes all supported firemodes
	{
		type = 0,					-- used for choosing animation - is pistol 
		min_recoil=2,
		max_recoil=2.5,
		HasCrosshair=1,
		AmmoType="RPG7",
		reload_time= 4.00,
		fire_rate= 3.0,
		projectile_class="RPG7_rocket",
		distance= 2000,
		damage= 100,
		damage_drop_per_meter= 0.008,
		bullet_per_shot= 1,
		bullets_per_clip=1,
		iImpactForceMul = 10,
		FModeActivationTime = 0.0,
				
		BulletRejectType=BULLET_REJECT_TYPE_SINGLE,
		
		-- make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=8,
		whizz_probability=350,	-- 0-1000
		whizz_sound={
			Sound:Load3DSound("Sounds/TD_bullets/whisbys/whisbys_01.wav",SOUND_UNSCALABLE,100,1,10),
			Sound:Load3DSound("Sounds/TD_bullets/whisbys/whisbys_02.wav",SOUND_UNSCALABLE,100,1,10),			Sound:Load3DSound("Sounds/weapons/bullets/whiz2.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/TD_bullets/whisbys/whisbys_03.wav",SOUND_UNSCALABLE,100,1,10),			Sound:Load3DSound("Sounds/weapons/bullets/whiz3.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/TD_bullets/whisbys/whisbys_04.wav",SOUND_UNSCALABLE,100,1,10),			Sound:Load3DSound("Sounds/weapons/bullets/whiz4.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/TD_bullets/whisbys/whisbys_05.wav",SOUND_UNSCALABLE,100,1,10),
			Sound:Load3DSound("Sounds/TD_bullets/whisbys/whisbys_06.wav",SOUND_UNSCALABLE,100,1,10),			Sound:Load3DSound("Sounds/weapons/bullets/whiz2.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/TD_bullets/whisbys/whisbys_07.wav",SOUND_UNSCALABLE,100,1,10),			Sound:Load3DSound("Sounds/weapons/bullets/whiz3.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/TD_bullets/whisbys/whisbys_08.wav",SOUND_UNSCALABLE,100,1,10),	
			Sound:Load3DSound("Sounds/TD_bullets/whisbys/whisbys_09.wav",SOUND_UNSCALABLE,100,1,10),
		},
		
		FireSounds = {
			"Sounds/Weapons/RPG7/RPG7_fire.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/RPG7/RPG7_fire.wav",
		},

		DrySound = "Sounds/Weapons/HK_USP45C/HK_USP45C_leer.wav",
		
		ShellCases = {
			geometry=System:LoadObject("Objects\\Weapons\\shells\\smgshell.cgf"),
			focus = 1.5,
			color = { 1, 1, 1},
			speed = 0.1,
			count = 1,
			size = 20.0, 
			size_speed = 0.0,
			gravity = { x = 0.0, y = 0.0, z = -9.81 },
			lifetime = 250.0,
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
--		MuzzleFlash = {
--			geometry_name = "Objects/Weapons/SIGSAUER_P226_SD/SIGSAUER_P226_SD_mf.cgf",
--			bone_name = "spitfire",
--			lifetime = 0.07,
--		},
--		MuzzleFlashTPV = {
--			geometry_name = "Objects/Weapons/SIGSAUER_P226_SD/SIGSAUER_P226_SD_mf.cgf",
--			bone_name = "weapon_bone",
--			lifetime = 0.05,
--		},
		
		-- trace "moving bullet"	
		-- remove this if not nedded for current weapon
		
		SoundMinMaxVol = { 200, 8, 2600 },
		
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
		{	"reload",	45,			Sound:LoadSound("Sounds/Weapons/RPG7/RPG7_magin.wav",0,100)},
		{	"activate",	22,			Sound:LoadSound("Sounds/Weapons/RPG7/RPG7_anim1.wav",0,100)},
	},
}

CreateBasicWeapon(RPG7);

--function RPG7.Server:OnUpdate(delta, shooter)

	
--	local statsammocount = _localplayer.cnt.ammo + _localplayer.cnt.ammo_in_clip;
--	if statsammocount == 0 then 
--		self:DetachObjectToBone("spitfire",Projectiles.Rocket.RPG7_rocket);		
		--self:DetachObjectToBone("spitfire",Rocket);
		--self:DetachObjectToBone( "spitfire" );
--		self:DetachObjectToBone( "shells",Projectiles.Rocket.RPG7_rocket);
--		self:DetachObjectToBone( "shellsroot",Projectiles.Rocket.RPG7_rocket);
		--Hud:AddMessage("detach rocket",2);
		--nothing is working 
--	end
	
	--_localplayer.cnt.speedscale = braker;
	--_localplayer.cnt.speedscale = braker - weight;
	--Hud:AddMessage("$2 speed is masse".._localplayer.cnt.speedscale.." ",2);
--end 

---------------------------------------------------------------
--ANIMTABLE
------------------
RPG7.anim_table={}
--SINGLE SHOT
RPG7.anim_table[1]={
	idle={
		"idle",
	},
	reload={
		"reload",
	},
	fire={
		"fire",
	},
	swim={
		"swim"
	},
	activate={
		"activate"
	},
}
