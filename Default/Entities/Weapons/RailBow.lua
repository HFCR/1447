RailBow = {
	-- Far Cry Railgun version by Mixer

	name			= "RailBow",
	object		= "Objects/Weapons/railbow/railbow_bind.cgf",
	character	= "Objects/Weapons/railbow/railbow.cgf",
	PlayerSlowDown = 0.92,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	TargetHelperImage = System:LoadImage("Textures/Hud/crosshair/pistol.dds"),
	ActivateSound = Sound:LoadSound("Sounds/Weapons/Mortar/mortarweapact.wav",0,100),	-- sound to play when this weapon is selected
	---------------------------------------------------
	MaxZoomSteps =  1,
	ZoomSteps = { 1.4 },
	ZoomActive = 0,
	AimMode=1,
	
	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	ZoomFixedFactor=1,
	ZoomNoSway=1, 			--no sway in zoom mode 

	------


	FireParams ={													-- describes all supported firemodes
	{
		AmmoType="RailStick",
		reload_time= 1.2,
		fire_rate= 1.4,
		fire_activation=FireActivation_OnPress,
		railed=1,
		pickup_timer=0.14,
		damage= 350,
		damage_drop_per_meter= 0.005,
		bullet_per_shot= 1,
		bullets_per_clip=9,
		FModeActivationTime=1.0,
		sprint_penalty = 0,
		iImpactForceMul = 180,
		iImpactForceMulFinal = 200,
		iImpactForceMulFinalTorso = 700,
		aim_offset={x=0,y=0,z=0},
		-- make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=11,
		whizz_probability=1000,
		whizz_sound={
			Sound:Load3DSound("Sounds/Weapons/mounted/minimetail.wav",SOUND_UNSCALABLE,100,1,11),
		},

		FireSounds = {
			"Sounds/Weapons/railbow/railbow_fire_in.wav",
		},
		
		FireSoundsStereo = {
			"Sounds/Weapons/railbow/railbow_fire_in.wav",
		},
		
		FireSoundsOUT = {
			"Sounds/Weapons/railbow/railbow_fire.wav",
		},
		FireSoundsOUTstereo = {
			"Sounds/Weapons/railbow/railbow_fire.wav",
		},

		DrySound = "Sounds/items/button1.wav",

		LightFlash = {
			fRadius = 3.0,
			vDiffRGBA = { r = 0.4, g = 1.0, b = 0.4, a = 1.0, },
			vSpecRGBA = { r = 0.4, g = 1.0, b = 0.4, a = 1.0, },
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

		ExitEffect = "bullet.sniper_trail",

		SoundMinMaxVol = { 200, 4, 2600 },
	},
	},
	SoundEvents={
		--	animname,	frame,	soundfile												---
		{	"reload1",	12,			Sound:LoadSound("Sounds/Weapons/Mortar/mortarweapact.wav",0,100)},
		{	"reload1",	40,			Sound:LoadSound("Sounds/Weapons/Mortar/mortar_46.wav",0,100)},
		{	"reload1",	49,			Sound:LoadSound("Sounds/Weapons/OICW/oicwB_32.wav",0,100)},
		{	"fire11",	3,	Sound:LoadSound("Sounds/items/seek.wav",0,100)},
		{	"fire21",	3,	Sound:LoadSound("Sounds/items/seek.wav",0,100)}, 

	},
}

CreateBasicWeapon(RailBow);

function RailBow.Client:OnEnhanceHUD(scale, bHit)
	if (_localplayer) and (_localplayer.EquipmentSoundProbability) and (not _localplayer.DisableSway) then
		System:DrawImageColor(self.TargetHelperImage, 385, 285, 30, 30, 4, 0.6,1,0.6,0.8);
		if (toNumberOrZero(getglobal("cis_railonly")) > 0) then
			_localplayer.fireparams.railed = 2;
		else
			_localplayer.fireparams.railed = 1;
		end
	end
end

function RailBow.Server:OnFire( params )
	if (GameRules.insta_play) then
		-- top up clip always, if in RAIL ONLY mode
		params.shooter.cnt.ammo_in_clip = params.shooter.fireparams.bullets_per_clip+1;
	end
	return BasicWeapon.Server.OnFire(self,params);
end

function RailBow.Server:OnHit(hit)
	BasicWeapon.Server.OnHit(self,hit);
	if (GameRules.insta_play) then
		if (hit.target) and (hit.target.Properties) and (not GameRules.SurvivalManager) then
			if toNumberOrZero(getglobal("cis_railonly"))==2 then
				hit.damage = 99999;
				hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_flesh"));
			elseif (hit.target.Properties.fDamageMultiplier) and (hit.target.Properties.fDamageMultiplier<1) then
				hit.damage = hit.damage * 1.5;
			end
		end
	end
end

function RailBow.Client:OnFire( Params )
if (BasicWeapon.Client.OnFire( self,Params )~=nil) then
	local fpos = {x=0,y=0,z=0};
	local fdir = Params.shooter:GetDirectionVector();
	if (Params.shooter.cnt.first_person) then
		fpos = self.cnt:GetBonePos("spitfire");
	else
		fpos = Params.shooter:GetBonePos("weapon_bone");
		fpos.x = fpos.x + fdir.x*0.68;
		fpos.y = fpos.y + fdir.y*0.68;
		fpos.z = fpos.z + fdir.z*0.68;
	end
	Particle:SpawnEffect(fpos, fdir, "bullet.hit_bullseye.a", 1.0);
	return 1;
else
	return nil;
end
end

function RailBow.Client:OnActivate(Params)
	BasicWeapon.Client.OnActivate(self,Params);
	if (Params.shooter == _localplayer) then
		self:LoadObject("Objects/weapons/railbow/railbow_cap.cgf",2,1);
		self.cap_stuff1 = self:AttachObjectToBone( 2,"spitfire",1 );
	end
end

--ANIMTABLE
------------------
--SINGLE FIRE
RailBow.anim_table={};
RailBow.anim_table[1]={
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
	},
	swim={
		"swim"
	},
	activate={
		"Activate1"
	},
}
