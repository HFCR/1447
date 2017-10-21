Mortar = {
	name = "Mortar",
	character	= "Objects/weapons/blaster_figaster/blasterfigaster_base.cgf",
	--fireCanceled = 0,
	
	PlayerSlowDown = 1,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:Load3DSound("Sounds/Weapons/Mortar/mortarweapact.wav"),	-- sound to play when this weapon is selected
	---------------------------------------------------
	ZoomActive = 0,												-- initially always 0
	MaxZoomSteps = 1,
	ZoomSteps = { 10 },
	ZoomForceCrosshair = 1,
	
	FireParams ={													-- describes all supported firemodes
		{
			HasCrosshair=1,
			--vehicleWeapon = 1,
			ammo=50,
			AmmoType="Unlimited",
			min_recoil=0,
			max_recoil=0,
			no_ammo=1,
			projectile_class="MortarShell",
			reload_time= 2.0,
			fire_rate = 2,
			tap_fire_rate = 2,
			bullet_per_shot=1,
			bullets_per_clip=1,
			FModeActivationTime = 2.0,
			fire_activation=FireActivation_OnPress,
			--FireOnRelease = 1,
			FireSounds = {
				"Sounds/Weapons/Mortar/mortarfire1.WAV",
			},
			DrySound = "Sounds/Weapons/Mortar/DryFire.wav",
			
			LightFlash = {
				fRadius = 5.0,
				vDiffRGBA = { r = 1.0, g = 1.0, b = 0.0, a = 1.0, },
				vSpecRGBA = { r = 0.3, g = 0.3, b = 0.3, a = 1.0, },
				fLifeTime = 0.75,
			},
	
			SoundMinMaxVol = { 255, 15, 100000 },
		},
	},
	
	-- remove this if not nedded for current weapon
	MuzzleFlash = {
		geometry_name = "Objects/Weapons/Muzzle_flash/mf_m4_fpv.cgf",
		bone_name = "spitfire",
		lifetime = 0.15,
	},
	MuzzleFlashTPV = {
		geometry_name = "Objects/Weapons/Muzzle_flash/mf_m4_tpv.cgf",
		bone_name = "spitfire",
		lifetime = 0.05,
	},
	SmokeEffect = {
		size = {0.15,0.07,0.035,0.01},
		size_speed = 1.3,
		speed = 9.0,
		focus = 3,
		lifetime = 0.4,
		sprite = System:LoadTexture("textures\\cloud1.dds"),
		stepsoffset = 0.3,
		steps = 4,
		gravity = 1.2,
		AirResistance = 3,
		rotation = 3,
		randomfactor = 50,
	},

	SoundEvents={
		--	animname,	frame,	soundfile												---
		{	"reload1",	33,			Sound:LoadSound("Sounds/Weapons/mortar/mortar_33.wav")},
		{	"reload1",	46,			Sound:LoadSound("Sounds/Weapons/mortar/mortar_46.wav")},
		
	},
	

	TargetHelperImage = System:LoadImage("Textures/hud/crosshair/p90.dds"),
	NoTargetImage = System:LoadImage("Textures/Hud/crosshair/noTarget.dds"),	
	temp_ang={x=0,y=0,z=0},
	temp_pos={x=0,y=0,z=0},
}

function ClampAngle(a)
	if(a.x>180)then a.x=a.x-360;
	elseif(a.x<-180)then a.x=a.x+360; end

	if(a.y>180)then a.y=a.y-360;
	elseif(a.y<-180)then a.y=a.y+360; end

	if(a.z>180)then a.z=a.z-360;
	elseif(a.z<-180)then a.z=a.z+360; end
end

CreateBasicWeapon(Mortar);

function Mortar.Client:OnEnhanceHUD()
	if (_localplayer) and (_localplayer.EquipmentSoundProbability) and (not _localplayer.DisableSway) then
		System:DrawImageColor(self.TargetHelperImage, 385, 285, 30, 30, 4, 0.6,1,0.6,0.8);
		do return end;
	end
	BasicWeapon.Client.OnEnhanceHUD(self);
end

--ANIMTABLE
------------------
--SINGLE FIRE
Mortar.anim_table={}
Mortar.anim_table[1]={
	idle={
		"Idle11",
	},
	reload={
		"Reload1"	
	},
	fire={
		"Fire11",
		"Fire21",
	},
	activate={
		"Activate1"
	},
}