MutantShotgun = {
	name		= "MutantShotgun",
	object	= "Objects/Weapons/pow_pow/ashotgun_bind.cgf",
	character	= "Objects/Weapons/pow_pow/pow_pow.cgf",
	
	PlayerSlowDown = 0.81,		-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/Pancor/jackwaepact.wav",0,100),	-- sound to play when this weapon is selected
	AltFireSnd =  Sound:Load3DSound("Sounds/weapons/pow_pow/cis_ashot_pl.wav",SOUND_UNSCALABLE,254,5,60),
	---------------------------------------------------
	al_gren_sup = 83, -- alternate fire projectile speed
	---------------------------------------------------
	FireParams ={													-- describes all supported firemodes
	{
		HasCrosshair=1,
		AmmoType="Shotgun",
		ammo=40,
		reload_time=2.4, -- default 3.25
		fire_rate=0.7,
		fire_activation=FireActivation_OnPress,
		distance=100,
		damage=20, -- default 30
		damage_drop_per_meter=.080,
		bullet_per_shot=5,
		bullets_per_clip=6,
		tap_fire_rate=0.8,
		FModeActivationTime = 1.0,
		iImpactForceMul = 25, -- 5 bullets divided by 10
		iImpactForceMulFinal = 100, -- 5 bullets divided by 10	
		
		BulletRejectType=BULLET_REJECT_TYPE_SINGLE,
		
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
			"Sounds/Weapons/Pancor/jackfire2.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/Pancor/jackfire3.wav",
		},
		DrySound = "Sounds/Weapons/Pancor/DryFire.wav",
		ReloadSound = "Sounds/Weapons/Pancor/jackrload.wav",

		LightFlash = {
			fRadius = 5.0,
			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.0, a = 1.0, },
			vSpecRGBA = { r = 0.3, g = 0.3, b = 0.3, a = 1.0, },
			fLifeTime = 0.75,
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
		
		AltEffect = {
			size = {0.175},
			size_speed = 3.3,
			speed = 0.0,
			focus = 20,
			lifetime = 0.03,
			sprite = System:LoadTexture("Textures\\water_bubbles3.dds"),
			stepsoffset = 0.05,
			steps = 1,
			gravity = 0.0,
			AirResistance = 0,
			rotation = 30,
			randomfactor = 10,
		},

		MuzzleEffect = {
			size = {0.175,0.01,0.02,0.03,0.015},--0.15,0.25,0.35,0.3,0.2},
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
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle5.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle6.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle7.dds"),
					}
				},
			stepsoffset = 0.1,
			steps = 5,
			gravity = 0.0,
			AirResistance = 0,
			rotation = 3,
			randomfactor = 60,
			color = {0.5,0.5,0.5},
		},

		SoundMinMaxVol = { 225, 5, 2600 },
	},
	},

		SoundEvents={
		{	"reload1",	29,			Sound:LoadSound("Sounds/Weapons/Pancor/pancor_29.wav",0,100)},
		{	"reload1",	45,			Sound:LoadSound("Sounds/Weapons/Pancor/pancor_49.wav",0,100)},
		
	},
}

CreateBasicWeapon(MutantShotgun);

function MutantShotgun.Client:OnActivate(Params)
	BasicWeapon.Client.OnActivate(self,Params);
	if (Params.shooter == _localplayer) then
		self:LoadObject("Objects/Weapons/pow_pow/ashotgun.cgf",2,1);
		self.cap_stuff1 = self:AttachObjectToBone( 2,"spitfire",1 );
	end
end

function MutantShotgun.Client:OnHit(hit)
	hit.impact_force_mul2 = 6;
	BasicWeapon.Client.OnHit(self,hit);
end

function MutantShotgun.Client:OnFire( Params )
	if (Params.shooter.cnt.first_person==nil) then
		self.bw_mf_for_scope = 1;
	end
	if (BasicWeapon.Client.OnFire( self,Params )~=nil) then
		if (Params.shooter.cnt.first_person) then
			local fpos = self.cnt:GetBonePos("spitfire");
			local fdir = Params.shooter:GetDirectionVector();
			BasicWeapon:HandleParticleEffect(Params.shooter.fireparams.SmokeEffect,fpos,fdir,1,3);
			BasicWeapon:HandleParticleEffect(Params.shooter.fireparams.MuzzleEffect,fpos,fdir,1,3);
		end
		return 1;
	else
		return nil;
	end
end

function MutantShotgun:ZoomAsAltFire(shtr)
	if (shtr) then
		if (shtr.asg_nextshot) and (shtr.asg_nextshot > _time) then
		else
			shtr.asg_nextshot = _time + 1.1;
			if (Game:IsServer()) then
				if (shtr:GetAmmoAmount("HandGrenade") > 0) then
					local gren = Server:SpawnEntity("Plasmaball");
					if (gren) then
						local s_pos = shtr:GetPos();
						if (shtr.cnt.crouching) then
							s_pos.z = s_pos.z + 0.98;
						elseif (shtr.cnt.proning) then
							s_pos.z = s_pos.z + 0.38;
						else
							s_pos.z = s_pos.z + 1.68;
						end
						local s_angles = shtr:GetAngles();
						local s_dir = shtr:GetDirectionVector();
						if (s_pos) then
							gren:Launch(shtr.cnt.weapon, shtr, s_pos, s_angles, s_dir, 1900);
							shtr:AddAmmo("HandGrenade", -1);
							Server:BroadcastCommand("PLAS "..shtr.id.." "..shtr.id);
						end
					end
				elseif (Game:IsClient()) and (shtr.sounddata) and (shtr.sounddata.DrySound) then
					shtr.cnt:PlaySound(shtr.sounddata.DrySound);
				end
			else
				Client:SendCommand("VB_GV 0");
			end
		end
	end
end

function MutantShotgun:ZoomAsAltFcl(shtr)
	local s_dir = shtr:GetDirectionVector();
	local fpos = 0;
	if (shtr.cnt.first_person) then
		self:StartAnimation(0, "fire23",0,0);
		fpos = self.cnt:GetBonePos("spitfire");
	else
		fpos = shtr:GetBonePos("weapon_bone");
		if (_localplayer) and (shtr ~= _localplayer) then
			shtr.stop_my_talk = _time + 0.2;
			shtr:StartAnimation(0,"aidle_utshoot",4);
		end
	end
	BasicWeapon:HandleParticleEffect(shtr.fireparams.SmokeEffect,fpos,s_dir,1,3);
	BasicWeapon:HandleParticleEffect(shtr.fireparams.AltEffect,fpos,s_dir,1,3);
	if (self.AltFireSnd) then
		Sound:SetSoundPosition(self.AltFireSnd,fpos);
		Sound:PlaySound(self.AltFireSnd);
	end
end

------------------
--ANIMTABLE
------------------
MutantShotgun.anim_table={}
--AUTOMATIC FIRE
MutantShotgun.anim_table[1]={
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
	melee={
		"Fire23",
	},
	swim={
		"swim",
	},
	activate={
		"Activate1",
	},
}