-- All changes from FarCry v1.31 code are
-- Copyright (c) 2005 by Greg Parent and Alan Sullivan, All rights Reserved.
-- Use in products other than Obsidian Edge without written permission from
-- the authors is expressly forbidden.

Sopmod = {
	-- DESCRIPTION:
	-- Single shot is more powerful, with a more recoil
	-- Auto is not as powerful, less recoil and does not travel as far
	-- It is louder than the silenced MP-5 but also more powerful
	-- good quiet gun

	name			= "Sopmod",
	object		= "Objects/Weapons/SOPMOD/SOPMOD_bind.cgf",
	character	= "Objects/Weapons/SOPMOD/SOPMOD.cgf",
	putdown_val = 0.16,
	PlayerSlowDown = 0.8,		-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/M4/m4weapact.wav",0,100),	-- sound to play when this weapon is selected
	---------------------------------------------------

	MaxZoomSteps =  1,
	ZoomSteps = { 2.5 },
	ZoomActive = 0,

	ZoomNoSway=1, 			--no sway in zoom mode

	---------------------------------------------------
	DrawFlare=1,
	---------------------------------------------------
	FireParams ={													-- describes all supported firemodes
	{
		HasCrosshair=1,
		AmmoType="Assault",
		reload_time= 2.3,
		fire_rate=0.082,
		distance=700,
		damage=13,
		damage_drop_per_meter=0.008,
		bullet_per_shot=1,
		fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
		bullets_per_clip=30,
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
		
		FireSounds = {"Sounds/Weapons/mp5/FINAL_MP5_STEREO_SINGLE.wav"},
		FireSoundsStereo = {"Sounds/Weapons/mp5/FINAL_MP5_STEREO_SINGLE.wav"},
		TrailOff="Sounds/Weapons/Sopmod/FINAL_SOPMOD_MONO_TAIL.wav",
		TrailOffStereo="Sounds/Weapons/Sopmod/FINAL_SOPMOD_STEREO_TAIL.wav",
		
		DrySound = "Sounds/Weapons/DE/dryfire.wav",
		
--		LightFlash = {
--			fRadius = 3.0,
--			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
--			vSpecRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
--			fLifeTime = 0.1,
--		},
	
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
--		MuzzleFlash = {
--			geometry_name = "Objects/Weapons/Muzzle_flash/mf_m4_fpv.cgf",
--			bone_name = "spitfire",
--			lifetime = 0.1,
--		},
--		MuzzleFlashTPV = {
--			geometry_name = "Objects/Weapons/Muzzle_flash/mf_m4_tpv.cgf",
--			bone_name = "weapon_bone",
--			lifetime = 0.05,
--		},
		

		-- trace "moving bullet"	
		-- remove this if not nedded for current weapon
--		Trace = {
--			geometry=System:LoadObject("Objects/Weapons/trail.cgf"),
--			focus = 5000,
--			color = { 1, 1, 1},
--			speed = 130.0,
--			count = 1,
--			size = 0.50, -- was 1.0
--			size_speed = 0.0,
--			gravity = { x = 0.0, y = 0.0, z = 0.0 },
--			lifetime = 0.04,
--			frames = 0,
--			color_based_blending = 3,
--			particle_type = bor(8,32),
--			bouncyness = 0,
--		},

		SoundMinMaxVol = { 225, 4, 2600 },
	},
	--SINGLE SHOT--------------------------------
	{
		-- more recoil, more power, travels further
		HasCrosshair=1,
		AmmoType="Assault",
		ammo=120,
		reload_time=2.3, 	-- default 2.8
		fire_rate=0.1,
		fire_activation=FireActivation_OnPress,
		distance=450,
		damage=15, 		-- default =7
		damage_drop_per_meter=.008,	-- default .011
		bullet_per_shot=1,
		angle_decay=10,		-- default 25
		paratimes=2,
		bullets_per_clip=30,
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
		min_recoil=0,
		max_recoil=0.9, -- more recoil
		
		FireSounds = {"Sounds/Weapons/mp5/FINAL_MP5_STEREO_SINGLE.wav"},
		FireSoundsStereo = {"Sounds/Weapons/mp5/FINAL_MP5_STEREO_SINGLE.wav"},		--TrailOff="Sounds/Weapons/m4/m4tail.wav",
		
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
		
--		LightFlash = {
--			fRadius = 3.0,
--			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
--			vSpecRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
--			fLifeTime = 0.1,
--		},
		
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
		
--		MuzzleFlash = {
--			geometry_name = "Objects/Weapons/Muzzle_flash/mf_m4_fpv.cgf",
--			bone_name = "spitfire",
--			lifetime = 0.1,
--		},
--		MuzzleFlashTPV = {
--			geometry_name = "Objects/Weapons/Muzzle_flash/mf_m4_tpv.cgf",
--			bone_name = "weapon_bone",
--			lifetime = 0.05,
--		},
		
		-- trace "moving bullet"	
		-- remove this if not nedded for current weapon
--		Trace = {
--			CGFName = "Objects/Weapons/trail.cgf",
--			focus = 5000,
--			color = { 1, 1, 1},
--			speed = 130.0,
--			count = 1,
--			size = 0.50, -- was 1.0
--			size_speed = 0.0,
--			gravity = { x = 0.0, y = 0.0, z = 0.0 },
--			lifetime = 0.04,
--			frames = 0,
--			color_based_blending = 3,
--			particle_type = 0,
--			bouncyness = 0,
--		},

		SoundMinMaxVol = { 225, 4, 2600 },
	},
	},
		SoundEvents={
		--	animname,	frame,	soundfile		
		{	"reload1",	5,			Sound:LoadSound("Sounds/Weapons/Sopmod/sopmod_reload_enhanced.wav",0,100)},
--		{	"reload1",	33,			Sound:LoadSound("Sounds/Weapons/M4/M4_33.wav",0,100)},
--		{	"reload1",	58,			Sound:LoadSound("Sounds/Weapons/M4/M4_47.wav",0,100)},
--		{	"reload2",	20,			Sound:LoadSound("Sounds/Weapons/M4/M4_20.wav",0,100)},
--		{	"reload2",	33,			Sound:LoadSound("Sounds/Weapons/M4/M4_33.wav",0,100)},
--		{	"reload2",	47,			Sound:LoadSound("Sounds/Weapons/M4/M4_47.wav",0,100)},
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
	},
}


function Sopmod:ZoomZoggle( Active )
	if ( Active==0 ) then
		if ( Sopmod.ZoomSound ) then
			Sound.StopSound( Sopmod.ZoomSound );
		end
	end
end

function Sopmod:DrawZoomOverlay( ZoomStep )
	-- if we're in the sniper-scope send an SNIPER-mood-event
--	Sound:AddMusicMoodEvent("Sniper", MM_SNIPER_TIMEOUT);
	if ( ZoomStep ~= self.PrevZoomStep ) then
		if ( Sopmod.ZoomSound ) then
			Sound:StopSound( Sopmod.ZoomSound );
			Sound:PlaySound( Sopmod.ZoomSound );
		end
		self.PrevZoomStep = ZoomStep;
	end

	if ( Sopmod.ZoomBackgroundTID ) then
		-- [tiago] note image inversion, in order to achieve one-one texel to pixel mapping we must correct texture coordinates
		-- also, texture wrap should be set to clamping mode... i hacked texture coordinates a bit to go around incorrect texture wrapping mode...
		local fTexelW=1.0/512.0;
		local fTexelH=1.0/512.0;

		System:DrawImageColorCoords( Sopmod.ZoomBackgroundTID,   0, 0,  400, 600, 4, 1, 1, 1, 1, fTexelW, 1-fTexelH, 1-fTexelW, fTexelH);
		System:DrawImageColorCoords( Sopmod.ZoomBackgroundTID, 800, 0, -400, 600, 4, 1, 1, 1, 1, fTexelW, 1-fTexelH, 1-fTexelW, fTexelH);
--		System:DrawImageColorCoords( Sopmod.ZoomBackgroundTID, 400, 300, -400, 300, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
--		System:DrawImageColorCoords( Sopmod.ZoomBackgroundTID, 400, 300, 400, 300, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
	end

--	Game:SetHUDFont("radiosta", "binozoom");
	
	-- Draw distance
--	local myPlayer=_localplayer;
--	if ( myPlayer ) then
--		local int_pt=myPlayer.cnt:GetViewIntersection();
--		if ( int_pt ) then
--			local s=format( "%07.2fm", int_pt.len*1.5);
			--Game:WriteHudStringFixed(585, 280, s, 1, 1, 1, 0.25, 20, 20, 0.6);
--			Game:WriteHudString(582, 280, s, 1, 1, 1, 0.25, 15, 15);
--		else
			--Game:WriteHudStringFixed(585, 280, "----.--m", 1, 1, 1, 0.25, 20, 20, 0.6);
--			Game:WriteHudString(582, 280, "----.--m", 1, 1, 1, 0.25, 15, 15);
--		end
--	end
end

CreateBasicWeapon(Sopmod);

-- override functions
function Sopmod.Client:OnInit()
	System:LoadFont("radiosta");

	Sopmod.ZoomBackgroundTID=System:LoadImage("Textures/Hud/crosshair/Sopmod_scope");
	Sopmod.ZoomTID={};

--	local cur_r_TexResolution = tonumber( getglobal( "r_TexResolution" ) );
--	if( cur_r_TexResolution >= 2 ) then -- lower res texture for low texture quality setting
--		SniperRifle.ZoomTID[1]={System:LoadImage("Textures/Hud/sniperscope/3_low.tga"),161,115};
--		SniperRifle.ZoomTID[2]={System:LoadImage("Textures/Hud/sniperscope/6_low.tga"),161,159};
--		SniperRifle.ZoomTID[3]={System:LoadImage("Textures/Hud/sniperscope/12_low.tga"),161,245};
--		SniperRifle.ZoomTID[4]={System:LoadImage("Textures/Hud/sniperscope/18_low.tga"),161,286};
--	else
--		SniperRifle.ZoomTID[1]={System:LoadImage("Textures/Hud/sniperscope/3.tga"),161,115};
--		SniperRifle.ZoomTID[2]={System:LoadImage("Textures/Hud/sniperscope/6.tga"),161,159};
--		SniperRifle.ZoomTID[3]={System:LoadImage("Textures/Hud/sniperscope/12.tga"),161,245};
--		SniperRifle.ZoomTID[4]={System:LoadImage("Textures/Hud/sniperscope/18.tga"),161,286};
--	end

	self.ZoomOverlayFunc = Sopmod.DrawZoomOverlay;
	BasicWeapon.Client.OnInit(self);
end

---------------------------------------------------------------
--ANIMTABLE
------------------
--AUTOMATIC FIRE
Sopmod.anim_table={}
Sopmod.anim_table[1]={
	idle={
		"Idle11",
		"Idle12",
	},
	reload={
		"Reload1",
--		"Reload2",
	},
	--fidget={
	--	"fidget11",
	--},
	fire={
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
------------------
--SINGLE SHOT
Sopmod.anim_table[2]=Sopmod.anim_table[1];