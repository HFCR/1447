ShotgunDB = {
	name		= "ShotgunDB",
	object	= "Objects/Weapons/Shotgun_db/Shotgun_db_bind.cgf",
	character	= "Objects/Weapons/Shotgun_db/Shotgun_db.cgf",
	
	PlayerSlowDown = 0.86,									-- factor to slow down the player when he holds that weapon

	ActivateSound = Sound:LoadSound("Sounds/Weapons/COFS_Rifle/Rifle_Activate.wav",0,100),	-- sound to play when this weapon is selected


	MaxZoomSteps =  1,
	ZoomSteps = { 1.4 },
	ZoomActive = 0,
	AimMode=1,
	ZoomNoSway=1, 			--no sway in zoom mode
	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,

	------------------

	FireParams ={
	{
		HasCrosshair=1,
		AmmoType="Shotgun",
		animatedrun=1,
		reload_time=2.2, -- default 3.25
		fire_rate= 1.35,
		tap_fire_rate=0.1,
		fire_activation=FireActivation_OnPress,
		distance=150,
		damage=20, -- default 30
		damage_drop_per_meter=.080,
		bullet_per_shot=1,
		bullets_per_clip=1,
		FModeActivationTime = 1.0,
		iImpactForceMul = 25, -- 5 bullets divided by 10
		iImpactForceMulFinal = 100, -- 5 bullets divided by 10	
		aim_offset={x=0.156,y=-0.04,z=0.06},
		--BulletRejectType=BULLET_REJECT_TYPE_SINGLE,
		
		-- make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=8,

		whizz_probability=350,	-- 0-1000
		whizz_sound={
			Sound:Load3DSound("Sounds/weapons/bullets/whiz1.wav",SOUND_UNSCALABLE,55,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz2.wav",SOUND_UNSCALABLE,55,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz3.wav",SOUND_UNSCALABLE,55,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz4.wav",SOUND_UNSCALABLE,55,1,8),
		},
		
		FireSounds = {
			"Sounds/Weapons/COFS_Rifle/Rifle_Fire.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/COFS_Rifle/Rifle_Fire.wav",
		},
		DrySound = "Sounds/Weapons/Pancor/DryFire.wav",
		ReloadSound = "Sounds/Weapons/COFS_Rifle/Rifle_Reload.wav",

		LightFlash = {
			fRadius = 5.0,
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
		
		MuzzleEffect = {
			size = {0.175},
			size_speed = 3.3,
			speed = 0.0,
			focus = 20,
			lifetime = 0.03,
			sprite = System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle1.dds"),
			stepsoffset = 0.05,
			steps = 1,
			gravity = 0.0,
			AirResistance = 0,
			rotation = 30,
			randomfactor = 10,
		},
		
		SoundMinMaxVol = { 225, 8, 2600 },
	},
	},

		SoundEvents={
		--	animname,	frame,	soundfile
		{	"reload1",	8,			Sound:LoadSound("Sounds/Weapons/COFS_Rifle/Rifle_Reload.wav",0,100)},
	},
}

CreateBasicWeapon(ShotgunDB);

ShotgunDB.anim_table={}
--AUTOMATIC FIRE
ShotgunDB.anim_table[1]={
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
	melee={
		"Fire23",
	},
	run={
		"run",
		"run2",
	},

	swim={
		"swim",
	},
	activate={
		"Activate1",
	},
	--modeactivate={},
}
function ShotgunDB.Client:OnActivate(Params)
	BasicWeapon.Client.OnActivate(self,Params);
	if (Params.shooter == _localplayer) then
		self:LoadObject("Objects/Weapons/Shotgun_db/dbarrel.cgf",2,1);
		self.cap_stuff1 = self:AttachObjectToBone( 2,"spitfire",1 );
	end
end

function ShotgunDB.Server:OnFire( params )
	if (AIWeaponProperties) then
		if (not AIWeaponProperties.ShotgunDB) then
			AIWeaponProperties.ShotgunDB = {
				VolumeRadius = 200,
				fThreat = 1,
				fInterest = 0.5,
			};
		end
	end
	return BasicWeapon.Server.OnFire(self,params);
end 

function ShotgunDB.Client:OnFire( Params )
	if (Params.shooter.cnt.first_person==nil) then
		self.bw_mf_for_scope = 1;
	end
	if (BasicWeapon.Client.OnFire( self,Params )~=nil) then
		if (Params.shooter.cnt.first_person) then
			local fpos = new(self.cnt:GetBonePos("spitfire"));
			local fdir = Params.shooter:GetDirectionVector();
			BasicWeapon:HandleParticleEffect(Params.shooter.fireparams.SmokeEffect,fpos,fdir,1,3);
			BasicWeapon:HandleParticleEffect(Params.shooter.fireparams.MuzzleEffect,fpos,fdir,1,3);
		end
		return 1;
	else
		return nil;
	end
end

function ShotgunDB.Client:OnUpdate(delta,shooter)
	BasicWeapon.Client.OnUpdate(self,delta,shooter);
	if (shooter.cnt.first_person) then
		if (shooter.cnt.reloading) then
			local move_specs = {1.3,-0.1,0.5};
			if (not shooter.fakereloadplay) then
				shooter.fakereloadplay = 0;
			end
			shooter.fakereloadplay = shooter.fakereloadplay - _frametime * move_specs[3];
			if (shooter.fakereloadplay < move_specs[2]) then
				shooter.fakereloadplay = move_specs[2]*1;
			end
			self.cnt:SetFirstPersonWeaponPos({x=-shooter.fakereloadplay*move_specs[1],y=0,z=shooter.fakereloadplay}, g_Vectors.v000);
		elseif (shooter.fakereloadplay) then
			local move_specs = {1.3,-0.1,0.5};
			shooter.fakereloadplay = shooter.fakereloadplay + _frametime * 1;
			if (shooter.fakereloadplay > 0) then
				shooter.fakereloadplay = 0;
			end
			self.cnt:SetFirstPersonWeaponPos({x=-shooter.fakereloadplay*move_specs[1],y=0,z=shooter.fakereloadplay}, g_Vectors.v000);
			if (shooter.fakereloadplay == 0) then
				shooter.fakereloadplay = nil;
			end
		end
	end
end
