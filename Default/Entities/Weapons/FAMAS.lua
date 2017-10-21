
FAMAS = {
	
	name			= "FAMAS",
	object		= "Objects/Weapons/FAMAS/FAMAS_bind.cgf",
	character	= "Objects/Weapons/FAMAS/FAMAS.cgf",
	
	PlayerSlowDown = 0.8,		-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/FAMAS/FAMAS_clipin.wav",0,100),	-- sound to play when this weapon is selected
	---------------------------------------------------
	
	--WEAPON ICON-------------------------------------------------
	--------------------------------------------------------------	

	icon = System:LoadImage("FAMAS/FAMAS_icon.dds"),
	--                width,height
	--iconSize =	{ w = 64,h =  32,},
	
	--------------------------------------------------------------
	--------------------------------------------------------------

	
	silencer="_d_m249",
        ZoomActive = 0,												-- initially always 0
	MaxZoomSteps = 3,
	ZoomSteps = { 2,3,4, },
	ZoomSound=Sound:LoadSound("Sounds/items/scope.wav"),
	ZoomDeadSwitch= 1,	
	DrawFlare=1,
	ZoomNoSway=1, 
	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,			--no sway in zoom mode

	FireParams ={													-- describes all supported firemodes
	{
		AmmoType="Assault",
		reload_time= 2.3,
		fire_rate=0.082,
		distance=700,
		silenced="Sounds/weapons/m4/m4_silent.wav",
		damage=13,
		damage_drop_per_meter=0.008,
		bullet_per_shot=1,
		fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
		bullets_per_clip=25,
		FModeActivationTime = 0,
		iImpactForceMul = 20,
		iImpactForceMulFinal = 45,
		
	

		BulletRejectType=BULLET_REJECT_TYPE_RAPID,
		
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
		
		FireLoop="Sounds/Weapons/FAMAS/FAMAS_fire_auto.wav",
		FireLoopStereo="Sounds/Weapons/FAMAS/FAMAS_fire_auto.wav",
		TrailOff="Sounds/Weapons/FAMAS/FAMAS_fire_tail.wav",
		TrailOffStereo="Sounds/Weapons/FAMAS/FAMAS_fire_tail.wav",
		
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
			lifetime = 0.01,
			
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
			geometry_name = "Objects/Weapons/FAMAS/famas_mf.cgf",
			bone_name = "spitfire",
			lifetime = 0.1,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_m4_tpv.cgf",
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
	--SINGLE SHOT--------------------------------
	{
		
		 ZoomActive = 0,												-- initially always 0
	MaxZoomSteps = 3,
	ZoomSteps = { 2,3,4, },
	ZoomSound=Sound:LoadSound("Sounds/items/scope.wav"),
	ZoomDeadSwitch= 1,	
	DrawFlare=1,
	ZoomNoSway=1, 
	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,			--no sway in zoom mode


		-- more recoil, more power, travels further
		HasCrosshair=1,
		AmmoType="Assault",
		ammo=120,
		reload_time=2.3, 	-- default 2.8
		fire_rate=0.2,
		fire_activation=FireActivation_OnPress,
		distance=450,
		damage=15, 		-- default =7
		damage_drop_per_meter=.008,	-- default .011
		bullet_per_shot=3,
		burst = 3,
		ammo_per_shot=3,
		angle_decay=10,		-- default 25
		paratimes=2,
		bullets_per_clip=25,
		FModeActivationTime = 0,
		iImpactForceMul = 10,
		iImpactForceMulFinal = 45,
		
		BulletRejectType=BULLET_REJECT_TYPE_SINGLE,
		
		-- make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=8,
		whizz_probability=250,	-- 0-1000
		whizz_sound={
			Sound:Load3DSound("Sounds/weapons/bullets/whiz1.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz2.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz3.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz4.wav",SOUND_UNSCALABLE,100,1,8),
		},
		
		-- recoil values
		min_recoil=2,
		max_recoil=2.5, -- more recoil
		
		FireSounds = {"Sounds/Weapons/FAMAS/FAMAS_fire_burst.WAV"},
		FireSoundsStereo = {"Sounds/Weapons/FAMAS/FAMAS_fire_burst.WAV"},
		--TrailOff="Sounds/Weapons/FAMAS/FAMAS_fire_tail.wav",
		
		DrySound = "Sounds/Weapons/DE/dryfire.wav",
		
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
		
		LightFlash = {
			fRadius = 3.0,
			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			vSpecRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			fLifeTime = 0.1,
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
		
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/FAMAS/famas_mf.cgf",
			bone_name = "spitfire",
			lifetime = 0.3,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_m4_tpv.cgf",
			bone_name = "weapon_bone",
			lifetime = 0.05,
		},
		
		-- trace "moving bullet"	
		-- remove this if not nedded for current weapon
		Trace = {
			CGFName = "Objects/Weapons/trail.cgf",
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
			particle_type = 0,
			bouncyness = 0,
		},

		SoundMinMaxVol = { 225, 4, 2600 },
	},
	},
		SoundEvents={
		--	animname,	frame,	soundfile		
		{	"reload",	5,			Sound:LoadSound("Sounds/Weapons/FAMAS/FAMAS_clipout.wav",0,100)},
		{	"reload",	36,			Sound:LoadSound("Sounds/Weapons/FAMAS/FAMAS_clipin.wav",0,100)},
		{	"reload",	55,			Sound:LoadSound("Sounds/Weapons/FAMAS/FAMAS_boltpull.wav",0,100)},
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
	},
}

 function FAMAS:DrawZoomOverlay( ZoomStep )
	if ( ZoomStep ~= self.PrevZoomStep ) then
		if ( FAMAS.ZoomSound ) then
			Sound:StopSound( FAMAS.ZoomSound );
			Sound:PlaySound( FAMAS.ZoomSound );
		end
		self.PrevZoomStep = ZoomStep;
	end
--	System.DrawRectShader("ScreenDistort", 0, 0, 800, 600, 1, 1, 1, 1);

	if ( FAMAS.ZoomBackgroundTID ) then

		-- [tiago] must add crossair..
--		System:Draw2DLine(398-44, 300, 398,  300, 0, 0, 0, 1);
--		System:Draw2DLine(402, 300, 402+45, 300, 0, 0, 0, 1);
--		System:Draw2DLine(400   ,302, 400   ,302+45, 0, 0, 0, 1);

		-- [tiago] must adjust texel coordinates
		local fTexelWidth=1.0/1024.0;
		local fTexelHeight=1.0/1024.0;
		System:DrawImageColorCoords( FAMAS.ZoomBackgroundTID, 0, 0, 800, 600, 4, 1, 1, 1, 1,  fTexelWidth, 1-fTexelHeight, 1-fTexelWidth, fTexelHeight);
--		System:DrawImageColorCoords( RL.ZoomBackgroundTID, 800, 0, -400, 600, 4, 1, 1, 1, 1,  fTexelWidth, 1-fTexelHeight, 1-fTexelWidth, fTexelHeight);

	end

--	if ( RL.ZoomTID ) then
--		System.DrawImage( RL.ZoomTID[ZoomStep], 400, 22, 185, 80, 4 );
--	end
	--Game:SetHUDFont("radiosta", "sniperscope");
--	Game:SetHUDFont("radiosta", "binozoom");
	
	-- Draw distance
--	local myPlayer=_localplayer;
--	if ( myPlayer ) then
--		local int_pt=myPlayer.cnt:GetViewIntersection();
--		if ( int_pt ) then
--			local s=format( "%07.2fm", int_pt.len*1.5);
			--Game:WriteHudStringFixed(366, 350, s, 0, 1.0, 0.5, 0.5, 20, 20, 0.6);
--			Game:WriteHudString(370, 350, s, 0, 1.0, 0.5, 0.5, 15, 15);
--		else
			--Game:WriteHudStringFixed(366, 350, "----.--m", 0, 1.0, 0.5, 0.9, 20, 20, 0.6);
--			Game:WriteHudString(370, 350, "----.--m", 0, 1.0, 0.5, 0.9, 20, 20);
--		end
--	end
end

function FAMAS:ZoomToggle()
	TargetLocker:Activate(self.ZoomActive,"FAMAS");
end

CreateBasicWeapon(FAMAS);

function FAMAS.Client:OnInit()
	local cur_r_TexResolution = tonumber( getglobal( "r_TexResolution" ) );
	if( cur_r_TexResolution >= 1 ) then -- lower res texture for low/med texture quality setting
		FAMAS.ZoomBackgroundTID=System:LoadImage("Textures/Hud/crosshair/famas_scope");
	else
		FAMAS.ZoomBackgroundTID=System:LoadImage("Textures/Hud/crosshair/famas_scope");
	end


	-- RL.ZoomBackgroundTID=System:LoadImage("Textures/Hud/crosshair/RL_scope");
	FAMAS.ScopeBackgroundTID=System:LoadImage("Textures/Crosshair_new"); -- here
	self.ZoomOverlayFunc = FAMAS.DrawZoomOverlay;
	BasicWeapon.Client.OnInit( self );
end

function FAMAS.Client:OnShutDown()
	FAMAS.ZoomBackgroundTID=nil;
end

function FAMAS.Client:OnEnhanceHUD(scale, bHit)
		local fTexelW=1.0/512.0;
		local fTexelH=1.0/512.0;

		System:DrawImageColorCoords( FAMAS.ScopeBackgroundTID, 400, 600, 400+Hud.hdadjust*1.52, -600, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
		System:DrawImageColorCoords( FAMAS.ScopeBackgroundTID, 400, 600, -400-Hud.hdadjust*1.52, -600, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
	end


---------------------------------------------------------------
--ANIMTABLE
------------------
--AUTOMATIC FIRE
FAMAS.anim_table={}
FAMAS.anim_table[1]={
	idle={
		"Idle",
	},
	reload={
		"reload",
	},
					--fidget={
					--	"fidget11",
					--},
	fire={
		"fireauto",
		"fireauto2",
	},
	swim={
		"swim"
	},
	activate={
		"activate"
	},
}
------------------
--SALVE SHOT
FAMAS.anim_table[2]={
	idle={
		"Idle",
	},
	reload={
		"reload",
	},
					--fidget={
					--	"fidget11",
					--},
	fire={
		"firesalve",
	},
	swim={
		"swim"
	},
	activate={
		"activate"
	},
}