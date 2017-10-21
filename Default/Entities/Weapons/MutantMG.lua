MutantMG = {
	name = "MutantMG",
	PlayerSlowDown = 1.0,	
	character = "Objects/Vehicles/a_hovercraft/hand_controls.cgf",
	TargetHelperImage = System:LoadImage("Textures/Hud/crosshair/shotgun.dds"),
	ActivateSound = Sound:Load3DSound("Sounds/Weapons/M4/m4weapact.wav"),
	NoZoom=1,

	FireParams ={													-- describes all supported firemodes
	{
		vehicleWeapon = 1,
		HasCrosshair=1,
		AmmoType="VehicleMG",
		min_recoil=0,
		max_recoil=0,
		reload_time=0.9, -- default 2.8
		fire_rate=0.082,
		distance=1600,
		damage=20, -- default =7
		damage_drop_per_meter=.004,
		bullet_per_shot=1,
		bullets_per_clip=500,
		FModeActivationTime = 2.0,
		iImpactForceMul = 50,
		iImpactForceMulFinal = 140,
		
		-- make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=13,
		whizz_probability=200,	-- 0-1000
		whizz_sound={
			Sound:Load3DSound("Sounds/Bullethits/bullet_canvas2.wav",SOUND_UNSCALABLE,200,1,13),
			Sound:Load3DSound("Sounds/Bullethits/bullet_canvas5.wav",SOUND_UNSCALABLE,200,1,13),
		},

		FireLoop="Sounds/Weapons/mounted/FINAL_M249_STEREO_MONO.wav",
		TrailOff="Sounds/Weapons/mounted/FINAL_M249_MONO_TAIL.wav",
		
		DrySound = "Sounds/Weapons/DE/dryfire.wav",
		
		LightFlash = {
			fRadius = 5.0,
			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.0, a = 1.0, },
			vSpecRGBA = { r = 0.3, g = 0.3, b = 0.3, a = 1.0, },
			fLifeTime = 0.75,
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
		
		--------------------
		--particle weaponfx
		SmokeEffect = {
			size = {0.25,0.17,0.135,0.1},
			size_speed = 1.3,
			speed = 20.0,
			focus = 2,
			lifetime = 0.2,
			sprite = System:LoadTexture("textures\\cloud1.dds"),
			stepsoffset = 0.3,
			steps = 4,
			gravity = 1.2,
			AirResistance = 3,
			rotation = 3,
			randomfactor = 50,
		},
		
		MuzzleEffect = {
			size = {0.2},
			size_speed = 5.0,
			speed = 0.0,
			focus = 20,
			lifetime = 0.03,
			sprite = System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle1.dds"),
			stepsoffset = 0.1,
			steps = 1,--10,
			gravity = 0.0,
			AirResistance = 0,
			rotation = 30,
			randomfactor = 25,
			--color = {0.5,0.5,0.5},
		},
		--------------------

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_MG_fpv.cgf",
			bone_name = "spitfire",
			lifetime = 0.15,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_MG_tpv.cgf",
			bone_name = "spitfire",
			lifetime = 0.05,
		},

		-- trace "moving bullet"	
		-- remove this if not nedded for current weapon
		Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail_mounted.cgf"),
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

		SoundMinMaxVol = { 255, 6, 4000 },
	},
	-- special AI firemode follows	
	{
		vehicleWeapon = 1,
		HasCrosshair=1,
		AmmoType="Unlimited",
		min_recoil=0,
		max_recoil=0,
		reload_time=0.1, -- default 2.8
		fire_rate=0.082,
		distance=1600,
		damage=20, -- default =7
		damage_drop_per_meter=.004,
		bullet_per_shot=1,
		bullets_per_clip=500,
		FModeActivationTime = 2.0,
		iImpactForceMul = 50,
		iImpactForceMulFinal = 140,
		
		-- make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=13,
		whizz_probability=200,	-- 0-1000
		whizz_sound={
			Sound:Load3DSound("Sounds/Bullethits/bullet_canvas2.wav",SOUND_UNSCALABLE,200,1,13),
			Sound:Load3DSound("Sounds/Bullethits/bullet_canvas5.wav",SOUND_UNSCALABLE,200,1,13),
		},
		
		FireLoop="Sounds/Weapons/mounted/FINAL_M249_STEREO_MONO.wav",
		TrailOff="Sounds/Weapons/mounted/FINAL_M249_MONO_TAIL.wav",
		
		DrySound = "Sounds/Weapons/DE/dryfire.wav",
		
		LightFlash = {
			fRadius = 5.0,
			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.0, a = 1.0, },
			vSpecRGBA = { r = 0.3, g = 0.3, b = 0.3, a = 1.0, },
			fLifeTime = 0.75,
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
		
		--------------------
		--particle weaponfx
		SmokeEffect = {
			size = {0.25,0.17,0.135,0.1},
			size_speed = 1.3,
			speed = 20.0,
			focus = 2,
			lifetime = 0.2,
			sprite = System:LoadTexture("textures\\cloud1.dds"),
			stepsoffset = 0.3,
			steps = 4,
			gravity = 1.2,
			AirResistance = 3,
			rotation = 3,
			randomfactor = 50,
		},
		
		MuzzleEffect = {
			size = {0.2},
			size_speed = 5.0,
			speed = 0.0,
			focus = 20,
			lifetime = 0.03,
			sprite = System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle1.dds"),
			stepsoffset = 0.1,
			steps = 1,--10,
			gravity = 0.0,
			AirResistance = 0,
			rotation = 30,
			randomfactor = 25,
			--color = {0.5,0.5,0.5},
		},
		--------------------

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_MG_fpv.cgf",
			bone_name = "spitfire",
			lifetime = 0.15,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_MG_tpv.cgf",
			bone_name = "spitfire",
			lifetime = 0.05,
		},

		-- trace "moving bullet"	
		-- remove this if not nedded for current weapon
		Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail_mounted.cgf"),
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

		SoundMinMaxVol = { 255, 6, 4000 },
	},
	},

	SoundEvents={
		-- animname, frame, soundfile
		{"Reload1",1,Sound:LoadSound("Sounds/Weapons/P90/p90_1.wav")},
	},
	
	CrosshairParticles = {
		focus = 0,
		speed = 0.0,
		count = 1,
		size = 0.15, 
		size_speed=0.0,
		gravity={x=0.0,y=0.0,z=-0.0},
		rotation={x=0.0,y=0.0,z=0.0},
		lifetime=0.0,
		tid = System:LoadTexture("textures\\cloud.dds"),
		start_color = {1,.2,.2},
		end_color = {1,.2,.2},
		blend_type = 2,
		frames=0,
		draw_last=1,
	},
	
	cross3D = 1;
}

MutantMG.FireParams[1].FireLoop="Sounds/Weapons/mounted/minimelp.wav";
MutantMG.FireParams[1].FireLoopStereo=nil;
MutantMG.FireParams[1].TrailOff="Sounds/Weapons/mounted/minimetail.wav";
MutantMG.FireParams[1].TrailOffStereo=nil;
MutantMG.FireParams[1].Trace.geometry=System:LoadObject("Objects/Weapons/trail_laser.cgf");
MutantMG.FireParams[1].Trace.speed=185;
MutantMG.FireParams[2].FireLoop="Sounds/Weapons/mounted/minimelp.wav";
MutantMG.FireParams[2].FireLoopStereo=nil;
MutantMG.FireParams[2].TrailOff="Sounds/Weapons/mounted/minimetail.wav";
MutantMG.FireParams[2].TrailOffStereo=nil;
MutantMG.FireParams[2].Trace.geometry=System:LoadObject("Objects/Weapons/trail_laser.cgf");
MutantMG.FireParams[2].Trace.speed=185;

CreateBasicWeapon(MutantMG);

MutantMG.anim_table={};
MutantMG.anim_table[1]={
	idle={
		"idle11",
	},
	fire={
		"idle11",
	},
	activate={
		"Deactivate1",
	},
	reload={
		"Reload1",
	},

}

function MutantMG.Client:OnEnhanceHUD(scale, bHit)
	if (_localplayer.theVehicle) and (_localplayer.theVehicle.InitCommonAircraft) then
		local bAvailable = _localplayer.cnt:GetCrosshairState();
		if (bAvailable) then
			System:DrawImageColor(self.TargetHelperImage, 385, 285, 30, 30, 4, 0.6,1,0.6,0.8);
		else
			System:DrawImageColor(self.TargetHelperImage, 385, 285, 30, 30, 4, 1,0.5,0.5,0.8);
		end
	elseif (_localplayer.theVehicle) then
		BasicWeapon.DoAutoCrosshair( self, scale, bHit);
		_localplayer.cnt.drawfpweapon=nil;
	end
end

function MutantMG.Client:OnActivate(Params)
	BasicWeapon.Client.OnActivate(self,Params);
	if (Params.shooter == _localplayer) then
		if (_localplayer.theVehicle) then
			if (_localplayer.theVehicle.InitCommonAircraft) then
				self:LoadObject("Objects/vehicles/a_hovercraft/alien_controlpad.cgf",2,1);
				self.cap_stuff1 = self:AttachObjectToBone( 2,"Bone04",1 );
			end
		end
	end
end
