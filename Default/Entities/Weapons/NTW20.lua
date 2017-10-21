NTW20 = {
	name			= "NTW20",
	object		= "Objects/Weapons/NTW20/ntw20_bind3.cgf",
	character	= "Objects/Weapons/NTW20/NTW200.cgf",
	
	-- if the weapon supports zooming then add this...
	ZoomActive = 0,												-- initially always 0
	MaxZoomSteps = 5,
	ZoomSteps = { 3, 6, 12, 18, 24 },
	ZoomSound=Sound:LoadSound("Sounds/items/scope.wav"),
	ZoomDeadSwitch= 1,
	Sway = 2,

	---------------------------------------------------
	PlayerSlowDown = 0.5,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/AW50/aw50weapact.wav",0,100),	-- sound to play when this weapon is selected
	---------------------------------------------------
	DoesFTBSniping = 1,
	---------------------------------------------------
	DrawFlare=1,

	FireParams ={													-- describes all supported firemodes
	{
                                        HasCrosshair=1,
		AmmoType="Sniper",
		reload_time= 3.8,
		fire_rate= 0.70,
		fire_activation=FireActivation_OnPress,
		damage= 600, -- the aidamage multipler makes this an instant death but does not kill the player
		damage_drop_per_meter= 0.005,
		bullet_per_shot= 1,
		bullets_per_clip=5,
		FModeActivationTime=1.0,
		iImpactForceMul = 200,
		iImpactForceMulFinal = 300,

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

		FireSounds = {
			"Sounds/Weapons/NTW20/fire_mono.wav",
			"Sounds/Weapons/NTW20/fire_mono.wav",
			"Sounds/Weapons/NTW20/fire_mono.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/NTW20/fire_stereo.wav",
			"Sounds/Weapons/NTW20/fire_stereo.wav",
			"Sounds/Weapons/NTW20/fire_stereo.wav",
		},
		DrySound = "Sounds/Weapons/OICW/DryFire.wav",

		LightFlash = {
			fRadius = 3.0,
			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			vSpecRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			fLifeTime = 0.1,
		},

		ShellCases = {
			geometry=System:LoadObject("Objects/Weapons/shells/snipershell.cgf"),
			focus = 1.5,
			color = { 1, 1, 1},
			speed = 0.1,
			count = 1,
			size = 3.0,
			size_speed = 0.0,
			gravity = { x = 0.0, y = 0.0, z = -9.81 },
			lifetime = 10.0,
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
			size = {0.3,0.01,0.03,0.015},--0.15,0.25,0.35,0.3,0.2},
			size_speed = 3.3,
			speed = 0.0,
			focus = 20,
			lifetime = 0.03,
			sprite = {
					{
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzlehoriz.dds")
					}
					,
					{
						--System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle4.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle5.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle6.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle7.dds"),
					}
				},
			stepsoffset = 0.1,
			steps = 2,
			gravity = 0.0,
			AirResistance = 0,
			rotation = 3,
			randomfactor = 30,
			color = {0.9,0.9,0.9},
		},

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/AS50/mf_AS50_fpv.cgf",
			bone_name = "spitfire",
			lifetime = 0.05,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_AW50_tpv.cgf",
			bone_name = "weapon_bone",
			lifetime = 0.05,
		},

		ExitEffect = "bullet.sniper_trail",

		SoundMinMaxVol = { 200, 4, 2600 },
	},
	{
		AmmoType="Sniper",
		reload_time= 3.5,
		fire_rate= 0.85,
		fire_activation=FireActivation_OnPress,
		damage= 80, -- the aidamage multipler makes this an instant death but does not kill the player
		damage_drop_per_meter= 0.005,
		bullet_per_shot= 1,
		bullets_per_clip=5,
		FModeActivationTime=1.0,
		iImpactForceMul = 20,
		iImpactForceMulFinal = 120,

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

		FireSounds = {
			"Sounds/Weapons/NTW20/fire_mono.wav",
			"Sounds/Weapons/NTW20/fire_mono.wav",
			"Sounds/Weapons/NTW20/fire_mono.wav",
		},
		DrySound = "Sounds/Weapons/AW50/DryFire.wav",

		LightFlash = {
			fRadius = 5.0,
			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			vSpecRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			fLifeTime = 0.1,
		},

		ShellCases = {
			geometry=System:LoadObject("Objects/Weapons/shells/snipershell.cgf"),
			focus = 1.5,
			color = { 1, 1, 1},
			speed = 0.1,
			count = 1,
			size = 3.0,
			size_speed = 0.0,
			gravity = { x = 0.0, y = 0.0, z = -9.81 },
			lifetime = 10.0,
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
			size = {0.3,0.01,0.03,0.015},--0.15,0.25,0.35,0.3,0.2},
			size_speed = 3.3,
			speed = 0.0,
			focus = 20,
			lifetime = 0.03,
			sprite = {
					{
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzlehoriz.dds")
					}
					,
					{
						--System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle4.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle5.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle6.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle7.dds"),
					}
				},
			stepsoffset = 0.1,
			steps = 2,
			gravity = 0.0,
			AirResistance = 0,
			rotation = 3,
			randomfactor = 30,
			color = {0.9,0.9,0.9},
		},

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/AS50/mf_AS50_fpv.cgf",
			bone_name = "spitfire",
			lifetime = 0.05,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_AW50_tpv.cgf",
			bone_name = "weapon_bone",
			lifetime = 0.05,
		},

		ExitEffect = "bullet.sniper_trail",

		SoundMinMaxVol = { 200, 200, 2600 },
	},
	},
		SoundEvents={
		--	animname,	frame,	soundfile												---
		{	"reload1",	21,	Sound:LoadSound("Sounds/Weapons/NTW20/clipout.wav",0,100)},
		{	"reload1",	36,	Sound:LoadSound("Sounds/Weapons/NTW20/clipin.wav",0,100)},
		{	"reload1",	48,	Sound:LoadSound("Sounds/Weapons/NTW20/magtap.wav",0,100)},
		{	"reload1",	92,	Sound:LoadSound("Sounds/Weapons/NTW20/NTW20_bolt.wav",0,200)},
                {	"reload1",	96,	Sound:LoadSound("Sounds/Weapons/NTW20/bullet_fall.wav",0,200)}, 


		{	"fire11",	20,	Sound:LoadSound("Sounds/Weapons/NTW20/NTW20_bolt.wav",0,100)},
		{	"fire12",	20,	Sound:LoadSound("Sounds/Weapons/NTW20/NTW20_bolt.wav",0,100)},
                {	"fire11",	30,	Sound:LoadSound("Sounds/Weapons/NTW20/bullet_fall.wav",0,100)},
                {	"fire12",	30,	Sound:LoadSound("Sounds/Weapons/NTW20/bullet_fall.wav",0,100)},












--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},

	},
}

function NTW20:ZoomZoggle( Active )
	if ( Active==0 ) then
		if ( NTW20.ZoomSound ) then
			Sound.StopSound( NTW20.ZoomSound );
		end
	end
end

function NTW20:DrawZoomOverlay( ZoomStep )
	-- if we're in the sniper-scope send an SNIPER-mood-event
	Sound:AddMusicMoodEvent("Sniper", MM_SNIPER_TIMEOUT);
	if ( ZoomStep ~= self.PrevZoomStep ) then
		if ( NTW20.ZoomSound ) then
			Sound:StopSound( NTW20.ZoomSound );
			Sound:PlaySound( NTW20.ZoomSound );
		end
		self.PrevZoomStep = ZoomStep;
	end

	if ( NTW20.ZoomBackgroundTID ) then
		-- [tiago] note image inversion, in order to achieve one-one texel to pixel mapping we must correct texture coordinates
		-- also, texture wrap should be set to clamping mode... i hacked texture coordinates a bit to go around incorrect texture wrapping mode...
		local fTexelW=1.0/512.0;
		local fTexelH=1.0/512.0;

		System:DrawImageColorCoords( NTW20.ZoomBackgroundTID, 400, 300, -400, -300, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
		System:DrawImageColorCoords( NTW20.ZoomBackgroundTID, 400, 300, 400, -300, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
		System:DrawImageColorCoords( NTW20.ZoomBackgroundTID, 400, 300, -400, 300, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
		System:DrawImageColorCoords( NTW20.ZoomBackgroundTID, 400, 300, 400, 300, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
	end

	if ( NTW20.ZoomTID ) then
		local zs=NTW20.ZoomTID[ZoomStep];
		System:DrawImage( zs[1], zs[2], zs[3], 100, 200, 4);
	end

--	Game:SetHUDFont("radiosta", "sniperscope");
	Game:SetHUDFont("radiosta", "binozoom");
	
	-- Draw distance
	local myPlayer=_localplayer;
	if ( myPlayer ) then
		local int_pt=myPlayer.cnt:GetViewIntersection();
		if ( int_pt ) then
			local s=format( "%07.2fm", int_pt.len*1.5);
			--Game:WriteHudStringFixed(585, 280, s, 1, 1, 1, 0.25, 20, 20, 0.6);
			Game:WriteHudString(582, 280, s, 1, 1, 1, 0.25, 15, 15);
		else
			--Game:WriteHudStringFixed(585, 280, "----.--m", 1, 1, 1, 0.25, 20, 20, 0.6);
			Game:WriteHudString(582, 280, "----.--m", 1, 1, 1, 0.25, 15, 15);
		end
	end
end

CreateBasicWeapon(NTW20);

-- override functions
function NTW20.Client:OnInit()
	System:LoadFont("radiosta");

	NTW20.ZoomBackgroundTID=System:LoadImage("Textures/Hud/sniperscope/Snipe_Scope");
	NTW20.ZoomTID={};

	local cur_r_TexResolution = tonumber( getglobal( "r_TexResolution" ) );
	if( cur_r_TexResolution >= 2 ) then -- lower res texture for low texture quality setting
		NTW20.ZoomTID[1]={System:LoadImage("Textures/Hud/sniperscope/3_low.tga"),161,115};
		NTW20.ZoomTID[2]={System:LoadImage("Textures/Hud/sniperscope/6_low.tga"),161,159};
		NTW20.ZoomTID[3]={System:LoadImage("Textures/Hud/sniperscope/12_low.tga"),161,245};
		NTW20.ZoomTID[4]={System:LoadImage("Textures/Hud/sniperscope/18_low.tga"),161,286};
	else
		NTW20.ZoomTID[1]={System:LoadImage("Textures/Hud/sniperscope/3.tga"),161,115};
		NTW20.ZoomTID[2]={System:LoadImage("Textures/Hud/sniperscope/6.tga"),161,159};
		NTW20.ZoomTID[3]={System:LoadImage("Textures/Hud/sniperscope/12.tga"),161,245};
		NTW20.ZoomTID[4]={System:LoadImage("Textures/Hud/sniperscope/18.tga"),161,286};
	end

	self.ZoomOverlayFunc = NTW20.DrawZoomOverlay;
	BasicWeapon.Client.OnInit(self);
end

---------------------------------------------------------------
--ANIMTABLE
------------------
NTW20.anim_table={}
--AUTOMATIC FIRE
NTW20.anim_table[1]={
	idle={
		"Idle11",
		"Idle12",
	},
	reload={
		"reload1",
	},
	fidget={
		"fidget11",
	},
	fire={
		"fire11",
		"fire12",
	},
	swim={
		"swim"
	},
	activate={
		"activate1"
	},
}
