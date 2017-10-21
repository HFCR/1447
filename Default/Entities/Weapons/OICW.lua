-- oicw fixed
function GetScopeTex()
	local cur_r_TexResolution = tonumber( getglobal( "r_TexResolution" ) );
	if( cur_r_TexResolution >= 2 ) then 
		return System:LoadImage("Textures/Hud/crosshair/OICW_Scope_low.dds");
	else
		return System:LoadImage("Textures/Hud/crosshair/OICW_Scope.dds");
	end
end

OICWSP = {
	name			= "OICW",
	object		= "Objects/Weapons/oicw/oicw_bind.cgf",
	character	= "Objects/Weapons/oicw_mod/oicw.cgf",
	silencer = "_c",
	silencer_off_timer = 0.64,
	silencer_on_timer = 0.64,
	-- if the weapon supports zooming then add this...
	ZoomActive = 0,												-- initially always 0
	MaxZoomSteps = 1,
	ZoomSteps = { 3 },
	DoesFTBSniping = 1,
	---------------------------------------------------
	PlayerSlowDown = 0.8,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/oicw/oicwact.wav",0,155),	-- sound to play when this weapon is selected
	Sway=2,
	---------------------------------------------------
	DrawFlare=1,
	---------------------------------------------------
	FireParams ={													-- describes all supported firemodes
	{
		FModeActivationTime=1,
		HasCrosshair=1,
		AmmoType="Assault",
		reload_time=2.02, -- default 2.55
		fire_rate=0.05,
		distance=1600,
		damage=15, -- Default = 9
		silenced = 1,
		damage_drop_per_meter=.007,
		bullet_per_shot=1,
		bullets_per_clip=40,
		iImpactForceMul = 20,
		iImpactForceMulFinal = 100,
		fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),

		-- recoil values
		min_recoil=0,
		max_recoil=0.8,	-- its only a small recoil as more people seem to like it that way

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


		FireSounds = {
			"Sounds/weapons/oicw/OICWsingle.wav",
			"Sounds/weapons/oicw/OICWsingle.wav",
		},
		FireSoundsStereo = {
			"Sounds/weapons/oicw/OICWsingle.wav",
			"Sounds/weapons/oicw/OICWsingle.wav",
		},

		DrySound = "Sounds/Weapons/oicw/DryFire.wav",

		ScopeTexId = GetScopeTex(),

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

			size = {0.175},
			size_speed = 4.3,
			speed = 0.0,
			focus = 20,
			lifetime = 0.03,

			sprite = {
					{
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzleoicw.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzleoicw2.dds")
					}
				},

			stepsoffset = 0.05,
			steps = 1,
			gravity = 0.0,
			AirResistance = 0,
			rotation = 3,
			randomfactor = 20,
			color = {0.9,0.9,0.9},
		},

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_OICW_fpv.cgf",
			bone_name = "spitfire",
			lifetime = 0.125,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_OICW_tpv.cgf",
			bone_name = "weapon_bone",
			lifetime = 0.05,
		},

		-- trace "moving bullet"
		-- remove this if not nedded for current weapon
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

		SoundMinMaxVol = { 255, 4, 2600 },
	},
	{
		--no_zoom = 1,
		FModeActivationTime=1,
		HasCrosshair=1,
		AmmoType="OICWGrenade",
		projectile_class="OICWGrenade",
		ammo=500,
		reload_time=2.5,
		fire_rate=1.0,
		fire_activation=FireActivation_OnPress,
		bullet_per_shot=1,
		shoot_underwater = 1,
		bullets_per_clip=4,
		ScopeTexId = GetScopeTex(),
		
		FireSounds = {
			"Sounds/Weapons/oicw_vod/oicw_vodolaz_gl_mo_in.wav",
			"Sounds/Weapons/oicw_vod/oicw_vodolaz_gl_mo_in.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/oicw_vod/oicw_vodolaz_gl_st_in.wav",
			"Sounds/Weapons/oicw_vod/oicw_vodolaz_gl_st_in.wav",
		},
		FireSoundsOUT = {
			"Sounds/Weapons/oicw_vod/oicw_vodolaz_gl_mo.wav",
			"Sounds/Weapons/oicw_vod/oicw_vodolaz_gl_mo.wav",
		},
		FireSoundsOUTstereo = {
			"Sounds/Weapons/oicw_vod/oicw_vodolaz_gl_st.wav",
			"Sounds/Weapons/oicw_vod/oicw_vodolaz_gl_st.wav",
		},

		DrySound = "Sounds/Weapons/AG36/DryFire.wav",

		LightFlash = {
			fRadius = 3.0,
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

		SoundMinMaxVol = { 255, 5, 2600 },
	}

	},

		SoundEvents={
		--	animname,	frame,	soundfile												---
		{	"reload1",	14,			Sound:LoadSound("Sounds/Weapons/OICW/oicwB_14.wav",0,155)},
		{	"reload1",	32,			Sound:LoadSound("Sounds/Weapons/OICW/oicwB_32.wav",0,155)},
		{	"reload2",	32,			Sound:LoadSound("Sounds/Weapons/OICW/oicwG_32.wav",0,155)},
		{	"reload2",	48,			Sound:LoadSound("Sounds/Weapons/OICW/oicwG_48.wav",0,155)},
--		{	"swim",		1,				Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},

	},
}

OICWMP = {
	name			= "OICW",
	object		= "Objects/Weapons/oicw/oicw_bind.cgf",
	character	= "Objects/Weapons/oicw_mod/oicw.cgf",

	fireCanceled = 0,

	-- if the weapon supports zooming then add this...
	ZoomActive = 0,												-- initially always 0
	MaxZoomSteps = 1,
	ZoomSteps = { 3 },
	DoesFTBSniping = 1,

	---------------------------------------------------
	PlayerSlowDown = 0.7,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/oicw/oicwact.wav",0,155),	-- sound to play when this weapon is selected
	ZoomNoSway=1,
	---------------------------------------------------
	DrawFlare=1,
	---------------------------------------------------
	FireParams ={													-- describes all supported firemodes
	{
		FModeActivationTime=1,
		HasCrosshair=1,
		AmmoType="Assault",
		reload_time=2.02, -- default 2.55
		fire_rate=0.05,
		distance=1600,
		damage=15, -- Default = 9
		damage_drop_per_meter=.007,
		bullet_per_shot=1,
		bullets_per_clip=40,
		iImpactForceMul = 20,
		iImpactForceMulFinal = 100,
		fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),

		-- recoil values
		min_recoil=0,
		max_recoil=0.8,	-- its only a small recoil as more people seem to like it that way

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

		DrySound = "Sounds/Weapons/oicw/DryFire.wav",
		FireSounds = {
			"Sounds/weapons/oicw/OICWsingle.wav",
			"Sounds/weapons/oicw/OICWsingle.wav",
		},
		FireSoundsStereo = {
			"Sounds/weapons/oicw/OICWsingle.wav",
			"Sounds/weapons/oicw/OICWsingle.wav",
		}, 

		ScopeTexId = GetScopeTex(),

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

			size = {0.175},
			size_speed = 4.3,
			speed = 0.0,
			focus = 20,
			lifetime = 0.03,

			sprite = {
					{
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzleoicw.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzleoicw2.dds")
					}
				},

			stepsoffset = 0.05,
			steps = 1,
			gravity = 0.0,
			AirResistance = 0,
			rotation = 3,
			randomfactor = 20,
			color = {0.9,0.9,0.9},
		},

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_OICW_fpv.cgf",
			bone_name = "spitfire",
			lifetime = 0.125,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_OICW_tpv.cgf",
			bone_name = "weapon_bone",
			lifetime = 0.05,
		},

		-- trace "moving bullet"
		-- remove this if not nedded for current weapon
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

		SoundMinMaxVol = { 255, 4, 2600 },
	},
	{
			AmmoType="OICWGrenade",
			min_recoil=4,
			max_recoil=4,		
			projectile_class="OICWGrenade",
			reload_time= 2.5,
			fire_rate= 1.5,
			bullet_per_shot=1,
			bullets_per_clip=4,
			shoot_underwater = 1,
			fire_activation=FireActivation_OnPress,
			ScopeTexId = GetScopeTex(),

		FireSounds = {
			"Sounds/Weapons/oicw_vod/oicw_vodolaz_gl_mo_in.wav",
			"Sounds/Weapons/oicw_vod/oicw_vodolaz_gl_mo_in.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/oicw_vod/oicw_vodolaz_gl_st_in.wav",
			"Sounds/Weapons/oicw_vod/oicw_vodolaz_gl_st_in.wav",
		},
		FireSoundsOUT = {
			"Sounds/Weapons/oicw_vod/oicw_vodolaz_gl_mo.wav",
			"Sounds/Weapons/oicw_vod/oicw_vodolaz_gl_mo.wav",
		},
		FireSoundsOUTstereo = {
			"Sounds/Weapons/oicw_vod/oicw_vodolaz_gl_st.wav",
			"Sounds/Weapons/oicw_vod/oicw_vodolaz_gl_st.wav",
		},

			DrySound = "Sounds/Weapons/AG36/DryFire.wav",

			
			LightFlash = {
				fRadius = 3.0,
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
	
		SoundMinMaxVol = { 255, 8, 3200 },
	}

	},




	SoundEvents={
		--	animname,	frame,	soundfile												---
		{	"reload1",	14,			Sound:LoadSound("Sounds/Weapons/OICW/oicwB_14.wav",0,155)},
		{	"reload1",	32,			Sound:LoadSound("Sounds/Weapons/OICW/oicwB_32.wav",0,155)},
		{	"reload2",	32,			Sound:LoadSound("Sounds/Weapons/OICW/oicwG_32.wav",0,155)},
		{	"reload2",	48,			Sound:LoadSound("Sounds/Weapons/OICW/oicwG_48.wav",0,155)},
--		{	"swim",		1,				Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},

	},

	TargetHelperImage = System:LoadImage("Textures/hud/crosshair/rl.dds"),
	NoTargetImage = System:LoadImage("Textures/Hud/crosshair/noTarget.dds"),	
	temp_ang={x=0,y=0,z=0},
	temp_pos={x=0,y=0,z=0},
	minaimtime = 0.45,
	initdist = 0,
	initangle = 0,
	maxdist = 15,
	maxangle = 45,
	queuetime={0,0,0,0,0,0,0,0,0,0,0,0},
	queueid={0,0,0,0,0,0,0,0,0,0,0},
	queuesize=1,
}

function ClampAngle(a)
	if(a.x>180)then a.x=a.x-360;
	elseif(a.x<-180)then a.x=a.x+360; end

	if(a.y>180)then a.y=a.y-360;
	elseif(a.y<-180)then a.y=a.y+360; end

	if(a.z>180)then a.z=a.z-360;
	elseif(a.z<-180)then a.z=a.z+360; end
end

OICW = OICWSP;

if (Game:IsMultiplayer()) then
	OICW= OICWMP;
end

CreateBasicWeapon(OICW);

function OICW:ScopeToScreen(zoomdiff)
	if (zoomdiff > 1) then
		zoomdiff = 1;
	end
	self.cnt:SetFirstPersonWeaponPos({x=0.175*zoomdiff,y=0.24*zoomdiff,z=0.055*zoomdiff},g_Vectors.v000);
end

if (Game:IsMultiplayer()) then
	function OICW.Server:OnUpdate(delta, shooter)
		if (shooter.fireparams.projectile_class) then
			local maxclip = tonumber(getglobal("gr_clip_oicw_gl"));
			if (maxclip) then
				if (shooter.cnt.ammo_in_clip > maxclip) then
					shooter.cnt.ammo_in_clip = maxclip * 1;
				end
				shooter.fireparams.bullets_per_clip = maxclip;
				if (maxclip == 0) then
					shooter.cnt.ammo = 0;
				end
			end
		end
		return BasicWeapon.Server.OnUpdate(self,delta, shooter);
	end
end

--ANIMTABLE
------------------
OICW.anim_table={}
--AUTOMATIC FIRE
OICW.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	reload={
		"Reload1",
	},
	fire={
		"Fire11",
		"Fire21",
	},
	modeactivate={
		"Fire22",
	},
	melee={
		"Fire23",
	},
	swim={
		"swim",
	},
	silencer_off={
		"Activate1",
	},
	silencer_on={
		"Activate1",
	},
		run={
		"run1",
		"run2",
	},

	activate={
		"Activate1",
	},
}

--AUTOMATIC FIRE
OICW.anim_table[2]={
	idle={
		"Idle21",
		"Idle22",
	},
	reload={
		"Reload2",
	},
	fire={
		"Fire12",
	},
	modeactivate={
		"Fire22",
	},
	melee={
		"Fire23",
	},
	swim={
		"swim",
	},
	silencer_off={
		"Activate1",
	},
	silencer_on={
		"Activate1",
	},
		run={
		"run1",
		"run2",
	},

	activate={
		"Activate1",
	},
}