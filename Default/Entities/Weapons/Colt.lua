Colt = {
	-- DESCRIPTION
	-- Default weapon, loud and does not travel far but does the job
	name			= "Colt",
	object		= "Objects/Weapons/1911_orig/1911_bind.cgf",
	character	= "Objects/Weapons/1911_orig/1911.cgf",

	silencer="_m1911",
	silencer_off_timer = 0.5,
	silencer_on_timer = 0.5,	
	putdown_val = 0.17,
	PlayerSlowDown = 1.0,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/DE/deweapact.wav",0,120),	-- sound to play when this weapon is selected
	AltFireSnd =  Sound:Load3DSound("Sounds/Weapons/melee/swish.wav",SOUND_UNSCALABLE,254,5,60),
	hit_delay=0.12,

	MaxZoomSteps =  1,
	ZoomSteps = { 1.2 },
	ZoomActive = 0,
	AimMode=1,
		
	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	ZoomFixedFactor=1,
	ZoomNoSway=1,

	FireParams ={													-- describes all supported firemodes
	{
		type = 2,					-- used for choosing animation - is pistol 
		min_recoil=2,
		max_recoil=2.5,
		HasCrosshair=1,
		AmmoType="Pistol",
		reload_time= 1.62,
		fire_rate= 0.2,
		tap_fire_rate=0.1,
		distance= 500,
		damage= 11,
		damage_drop_per_meter= 0.008,
		bullet_per_shot= 1,
		bullets_per_clip=7,
		fire_activation=bor(FireActivation_OnPress),
		FModeActivationTime = 2.0,
		iImpactForceMul = 20,
		iImpactForceMulFinal = 65.02,
		silenced="Sounds/Weapons/1911/1911_silent.wav",
		BulletRejectType=BULLET_REJECT_TYPE_SINGLE,
		aim_offset={x=0.13,y=0.08,z=0.02},
		-- make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=8,
		whizz_probability=350,	-- 0-1000
		whizz_sound={
			Sound:Load3DSound("Sounds/weapons/bullets/whiz1.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz2.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz3.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz4.wav",SOUND_UNSCALABLE,100,1,8),
		},
		
		FireSounds = {
			"Sounds/Weapons/DE/FINAL_MONO_DEFIRE1.wav",
			"Sounds/Weapons/DE/FINAL_MONO_DEFIRE2.wav",
			"Sounds/Weapons/DE/FINAL_MONO_DEFIRE3.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/DE/FINAL_STEREO_DEFIRE1.wav",
			"Sounds/Weapons/DE/FINAL_STEREO_DEFIRE2.wav",
			"Sounds/Weapons/DE/FINAL_STEREO_DEFIRE3.wav",
		},

		DrySound = "Sounds/Weapons/DE/dryfire.wav",
		
		ShellCases = {
			geometry=System:LoadObject("Objects/Weapons/shells/smgshell.cgf"),
			focus = 1.5,
			color = { 1, 1, 1},
			speed = 0.1,
			count = 1,
			size = 4.0, 
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
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_DE_fpv.cgf",
			bone_name = "spitfire",
			lifetime = 0.07,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_DE_tpv.cgf",
			bone_name = "weapon_bone",
			lifetime = 0.05,
		},
		
		-- trace "moving bullet"	
		-- remove this if not nedded for current weapon
		Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail.cgf"),
			focus = 5000,
			color = { 1, 1, 1},
			speed = 110.0,
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

		SoundMinMaxVol = { 200, 4, 2600 },
		
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
		{	"reload1",	10,			Sound:LoadSound("Sounds/Weapons/DE/DEclipout_10.wav",0,100)},
		{	"reload1",	25,			Sound:LoadSound("Sounds/Weapons/DE/DEclipin_25.wav",0,100)},
		{	"reload1",	38,			Sound:LoadSound("Sounds/Weapons/DE/DEclipslap_38.wav",0,100)},
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
	},
}

CreateBasicWeapon(Colt);

function Colt.Client:OnInit()
	Colt.ZoomBackgroundTID=System:LoadImage("Textures/Crosshair_new");
	self.ZoomOverlayFunc = Colt.DrawZoomOverlay;
	BasicWeapon.Client.OnInit(self);
end

function Colt.Client:OnEnhanceHUD(scale, bHit)
		local fTexelW=1.0/512.0;
		local fTexelH=1.0/512.0;

		System:DrawImageColorCoords( Colt.ZoomBackgroundTID, 400, 600, 400+Hud.hdadjust*1.52, -600, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
		System:DrawImageColorCoords( Colt.ZoomBackgroundTID, 400, 600, -400-Hud.hdadjust*1.52, -600, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
	end

function Colt.Client:OnUpdate(scale, bHit)
	_localplayer.cnt.weapon:SetFirstPersonWeaponPos({x=0.0,y=-0.007,z=0.002}, g_Vectors.v000);
	end


--function M1911:ZoomAsAltFire(shtr)
--	if (shtr) then
--		if (shtr.asg_nextshot) and (shtr.asg_nextshot > _time) then
--		else
--			local poss = SumVectors(shtr:GetPos(),{x=0.0,y=0.0,z=1.5});
--			if (shtr.cnt.crouching) then
--				poss = SumVectors(poss, {x=0.0,y=0.0,z=-0.5});
--			elseif (shtr.cnt.proning) then
--				poss = SumVectors(poss, {x=0.0,y=0.0,z=-1.0});
--			end 
--			local miscparams = {
--				pos = poss,
--				dir = shtr:GetDirectionVector(),
--				shooter = shtr,
--				distance = WeaponsParams.Hands.Std[1].distance*1,
--			};
--			local hits = Game:GetInstantHit(miscparams); --we throw the ray
--			if (not hits) then
--				hits = {
--					pos = poss,
--				};
--			end
--			
--			hits.busy_time = self:GetAnimationLength("Melee");
--			if (not hits.busy_time) then
--				hits.busy_time = 1;
--				if (Hud) then
--					Hud:AddMessage("Error: no Melee animation for this weapon.");
--				end
--			end
--			shtr.asg_nextshot = _time + hits.busy_time;
--
--			self.cl_hitparams = {
--				pos = hits.pos,
--				dir = miscparams.dir,
--				normal = miscparams.dir,
--				e_fx = "melee_slash",
--				shooter = shtr,
--				landed = 1,
--				impact_force_mul_final=25,
--				impact_force_mul=15,
--				damage_type="normal",
--				play_mat_sound = 1,
--				target_material = hits.target_material,
--			};
--			
--			if (Game:IsServer()) then
--
--				if (hits) and (hits.objtype) then
--					if (hits.target) then
--						local hit =	{
--							dir = miscparams.dir,
--							normal = miscparams.dir,
--							damage = 100,
--							target = hits.target,
--							shooter = shtr,
--							landed = 1,
--							ipart=0,
--							impact_force_mul_final=25,
--							impact_force_mul=15,
--							damage_type="normal",
--							pos = hits.pos,
--							target_material = hits.target_material,
--						};
--						hits.target:Damage( hit );
--						AI:SoundEvent(shtr.id,hits.pos,10,0,1,shtr.id);
--						shtr.cnt.weapon_busy = hits.busy_time*1;
--						Server:BroadcastCommand("PLAS "..shtr.id.." "..shtr.id);
--						self.cl_hitparams.target = hits.target;
--						return nil;
--					end
--				end
--			else
--				if (hits) and (hits.objtype) then
--					if (hits.target) then
--						Client:SendCommand("VB_GV 0");
--						self.cl_hitparams.target = hits.target;
--						return nil;
--					end
--				end
--			end
--
--			return 1;
--		end
--	end
--end

--function M1911:ZoomAsAltFcl(shtr)

--	if (shtr.cnt.first_person) then
--		shtr.playingReloadAnimation = 1;
--		self:StartAnimation(0, "melee",0,0);
--		self.cl_coldfakehit=nil;
--	elseif (_localplayer) and (shtr~=_localplayer) then
--		shtr.stop_my_talk = _time + 0.3;
--		shtr:StartAnimation(0,"aidle_umshoot",4);
--	end
--	if (self.AltFireSnd) then
--		local fpos = shtr:GetBonePos("weapon_bone");
--		Sound:SetSoundPosition(self.AltFireSnd,fpos);
--		Sound:PlaySound(self.AltFireSnd);
--	end
--	self.cl_cold_wpn_contact = _time+self.hit_delay;
	-----------
	
	------------------
--end

--function M1911.Client:OnUpdate(delta, shooter)
--	BasicWeapon.Client.OnUpdate(self,delta,shooter);
--	if (self.cl_cold_wpn_contact) and (self.cl_cold_wpn_contact < _time) and (self.cl_hitparams) then
--		self.cl_cold_wpn_contact=nil;
--		ExecuteMaterial2( self.cl_hitparams ,self.cl_hitparams.e_fx);
--		self.cl_coldfakehit = _time+self.hit_delay;
--	elseif (shooter.cnt) and (shooter.cnt.first_person) then
--		if (self.cl_coldfakehit) and (self.cl_coldfakehit < _time) then
--			self.cl_coldfakehit=nil;
--			BasicWeapon.RandomAnimation(self,"idle",shooter.firemodenum, 0.3);
--		end
--	end
--end

---------------------------------------------------------------
--ANIMTABLE
------------------
Colt.anim_table={}
--SINGLE SHOT
Colt.anim_table[1]={
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
	},
	melee={
		"Melee"
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
