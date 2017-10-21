

-- ////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////

-- Fout wheels drive vehicle script
-- created by Kirill Bulatsev

-- model & textures by Unknown, modified by mixer
-- Script edit by xezon for Mercedes 280 SEL, Freestyle Productions, modified by mixer

-- ////////////////////////////////////////////////////////////////


vaz21xx = {

	IsCar = 1,

	DamageParams = {
		fDmgScaleAIBullet = 0.027,
		fDmgScaleAIExplosion = 0.06,
		fDmgScaleBullet = 0.05,
		fDmgScaleExplosion = 0.25,
		dmgBulletMP = 0.6,
	},

	ExplosionParams = {
		nDamage = 1100,
	},

	fileModel="objects/Vehicles/vaz2107/vaz2107_model.cgf",
	fileModelDead = "objects/Vehicles/vaz2107/VAZ_2107_wreckpieces.cgf",
	fileModelPieces = "objects/Vehicles/vaz2107/VAZ_2107_wreckpieces.cgf",

	waterDepth = 0.55,	-- if water is deeper then this value - vehicle can't be used
	IsPhisicalized = 0,
	IdleTime = 0,

	windows2={
		{
			fileName="Objects/vehicles/Mercedes280SE/m280se_window1.cgf",
			helperName="window1",
			entity=nil,
			nDamage=150, --default: 500
			fBreakImpuls=10, --default: 10
		},
	},

	-- if speed is over maximum - don't play exit animation
	MaxSpeed2Exit = 9,
	
	-- previous state on the client before entering the vehicle
	bDriverInTheVehicle = 0,
	-- previous driver on the client before leaving the vehicle
	pPreviousDriver=nil,
	
	dropState = 0,

	userCounter = 0,
	driverWaiting = 1,
	driverDelay = 0,
	passengerLimit=3,

	bIsEnabled = 1,


	-- particle system to display when the vehicle is damaged stage 1
	Damage1Effect = "smoke.vehicle_damage1.a",
	-- particle system to display when the vehicle is damaged stage 2
	Damage2Effect = "smoke.vehicle_damage2.a",
	-- particle system to display when the vehicle explodes
	--ExplosionEffect = "explosions.4WD_explosion.a",
	ExplosionEffect = "explosions.helicopter_explosion.a",
	-- particle system to display when the vehicle is destroyed
	DeadEffect = "fire.burning_after_explosion.a",
	-- material to be used when vehicle is destroyed
	DeadMaterial = "Vehicles.Humvee_Screwed",


--///////////////////////     Speedometer Params     /////////////////////////////////
  Speedo = {
  	bEnabled = 1,
  	fUnitMultiplier = 3.6, --use 2.236936 for mph, 3.6 for km/h, 1.943844 for knots
  	Dial = {
  		fileTexture = "Objects/Vehicles/Mercedes280SE/m280se_kmh.dds", --dds/dxt1, one bit or no transparency only, no mipmaps needed.
  		ColorR = 1, --red color overlay (0-1), use 1 for none
  		ColorG = 1, --green color overlay (0-1), use 1 for none
  		ColorB = 1, --blue color overlay (0-1), use 1 for none
  		Transparency = 1, --(0-1)
  		Blending = 4, --4 for transparency, 0 for opaque...
  		LocationX = 260,--225
  		LocationY = 450,
  		Width = 140,
  		Height = 140,
  	},
  	Needle = {
  		CenterX = 69, --rotation center of the needle, offset from top left origin of dial texture.
  		CenterY = 69,
  		Length = 57, --total length in pixels
  		ColorR = 0.75, --red color component of the needle (0-1)
  		ColorG = 0.60, --green color component of the needle (0-1)
  		ColorB = 0, --blue color component of the needle (0-1)
  		Transparency = 1,
  		fAngleMin = 50, --down is 0°, left 90°, up 180°, right 270°. Increasing clockwise,
  		fAngleMax = 310, --    can turn left or right but never pass 0°.
  		fValueMin = 20, --minimum speed
  		fValueMax = 240, --maximum speed
  	},
  	SpeedDigits = {
  		bShowDigits = 1,
  		DigitFormat = "%03u", --format as printf
  		FontName = "radiosta",
  		FontEffect = "binozoom",
  		Width = 12,
  		Height = 12,
  		LocationX = 55, --top left position, offset from top left origin of dial texture.
  		LocationY = 82,
  		ColorR = 0.75, --red color component of the text (0-1)
  		ColorG = 0.60, --green color component of the text (0-1)
  		ColorB = 0, --blue color component of the text (0-1)
  		Transparency = 1,
  		Scale = 0.6,
  	},
  	TripDigits = {
  		bShowDigits = 1,
  		DigitFormat = "%07u", --format as printf
  		FontName = "default",
  		FontEffect = "default",
  		Width = 15,
  		Height = 12,
  		LocationX = 45, --top left position, offset from top left origin of dial texture.
  		LocationY = 46,
  		ColorR = 0.7, --red color component of the text (0-1)
  		ColorG = 0.7, --green color component of the text (0-1)
  		ColorB = 0.7, --blue color component of the text (0-1)
  		Transparency = 1,
  		Scale = 0.5, --space between characters
  	},
  },
--///////////////////////     Speedometer Params     /////////////////////////////////

--///////////////////////     Revcounter Params      /////////////////////////////////
	Revo = {
		bEnabled = 1,
		Dial = {
			fileTexture = "Objects/Vehicles/Mercedes280SE/m280se_rpm.dds", --dds/dxt1, one bit or no transparency only, no mipmaps needed.
			ColorR = 1, --red color overlay (0-1), use 1 for none
			ColorG = 1, --green color overlay (0-1), use 1 for none
			ColorB = 1, --blue color overlay (0-1), use 1 for none
			Transparency = 1,
			Blending = 4, --4 for transparency, 0 for opaque...
			LocationX=415,--380
			LocationY=470,
			Width=120,
			Height=120,
		},
		Needle = {
			CenterX = 59, --rotation center of the needle, offset from top left origin of dial texture.
			CenterY = 57,
			Length = 45, --total length in pixels
  		ColorR = 0.75, --red color component of the needle (0-1)
  		ColorG = 0.60, --green color component of the needle (0-1)
  		ColorB = 0, --blue color component of the needle (0-1)
			Transparency = 1,
			fAngleMin = 54, --down is 0, left 90, up 180, right 270. Increasing clockwise.
			fAngleMax = 306, --can turn left or right but never pass 0.
			fRevMin = 1000,
			fRevMax = 6000,
			fExp = -1,
			Pos = {
				ang = 0,
				x = 0,
				y = 0,
				x0 = 0,
				y0 = 0,
				x2 = 0,
				y2 = 0,
			},
		},
		Digits = {
			bShowRevDigits = 0,
			DigitFormat = "%03u rpm", --format as printf
			FontName = "default",
			FontEffect = "default",
			Width = 40,
			Height = 40,
			LocationX = 64, --top left position, offset from top left origin of dial texture.
			LocationY = 128,
  		ColorR = 0.7, --red color component of the text (0-1)
  		ColorG = 0.7, --green color component of the text (0-1)
  		ColorB = 0.7, --blue color component of the text (0-1)
			Transparency = 1,
			Scale = 1.0,
		},
	},
--///////////////////////     Revcounter Params      /////////////////////////////////


	CarDef = {

		engine_power = 300000, --60000 --100000 -- default using old mass 150000
		engine_power_back = 50000,--60000 --80000 -- default using old mass 95000
		engine_maxrpm = 2700,
		axle_friction = 300,--300
		max_steer = 22, -- default 30
		stabilizer = 0,

		dyn_friction_ratio = 2.0,

		max_braking_friction = 0.3,
		handbraking_value = 8,-- meter/s/s

		max_braking_friction_nodriver = 1.0, --this friction is applied when there is no driver inside the car
		handbraking_value_nodriver = 3,-- (meter/s / s) , same as above, this value is applied only when the car have no driver

		stabilize_jump = 1500,--this set how much to correct the car angles while it is in air.

		slip_threshold = 0.05,
		brake_torque = 500,

		engine_minRPM = 10,
		engine_idleRPM = 80,
		engine_startRPM = 400,
		engine_shiftupRPM = 1600,
		engine_shiftdownRPM = 750,
		clutch_speed = 1.2,

		gears = { -7,0,4,1.9,1.4,1.2,},
		--gears = { -6,0,8,3,1.4,1.2,1 },
		--gears = { -6, 0, 6, 4.5, 3.6, 3, 2.8 },
		--gears = { -6,0,17,7,5,3,1 },
		--gears = { -6,0,1.9,1 },
		

		gear_dir_switch_RPM = 1500,

		integration_type = 1,
		
		cam_stifness_positive = { x=400,y=400,z=100 },
	  	cam_stifness_negative = { x=400,y=400,z=100 },
	  	cam_limits_positive = { x=0,y=0.5,z=0 },
	  	cam_limits_negative = { x=0,y=0.3,z=0 },
	  	cam_damping = 22,
	  	cam_max_timestep = 0.01,
	  	cam_snap_dist = 0.001,
	  	cam_snap_vel = 0.01,

		pedal_speed = 12.0,--8.0
		
		--steering--
		steer_speed = 6,--(degree/s) steer speed at max velocity (the max speed is about 30 m/s)
		steer_speed_min = 60, --(degree/s) steer speed at min velocity
		
		steer_speed_scale = 1.0,--steering speed scale at top speed
		steer_speed_scale_min = 2.0,--steering speed scale at min speed
		--steer_speed_valScale = 1.0, 
		
		max_steer_v0 = 32.0, --max steer angle
		--max_steer_kv = 0.0,
		
		steer_relaxation_v0 = 720,--(degree/s) steer speed when return to forward direction.
		--steer_relaxation_kv = 15,--15,
		-----------------------------------------------
				
		max_time_step_vehicle = 0.02,
		sleep_speed_vehicle = 0.04,
		damping_vehicle = 0.11,
		
		-- rigid_body_params
		max_time_step = 0.01,
		damping = 0.1,
		sleep_speed = 0.04,
		freefall_damping = 0.03,
		gravityz = -13.81,
		freefall_gravityz = -13.81,

		water_density = 30,

		hull1 = { mass=3000,flags=0,zoffset=-0.35,yoffset=-0.25	}, --mass: 2909-- default mass 4000
		hull2 = { mass=0,flags=1 },
		
		wheel1 = { driving=1,axle=0,can_brake=1,len_max=0.20,stiffness=0,damping=-0.2, surface_id = 69, min_friction=1.0, max_friction=2.0 },
		wheel2 = { driving=1,axle=0,can_brake=1,len_max=0.20,stiffness=0,damping=-0.2, surface_id = 69, min_friction=1.0, max_friction=2.0 },
		wheel3 = { driving=1,axle=1,can_brake=0,len_max=0.20,stiffness=0,damping=-0.2, surface_id = 69, min_friction=1.05, max_friction=2.0 },
		wheel4 = { driving=1,axle=1,can_brake=0,len_max=0.20,stiffness=0,damping=-0.2, surface_id = 69, min_friction=1.05, max_friction=2.0 },
		wheel5 = { driving=1,axle=1,can_brake=0,len_max=0.20,stiffness=0,damping=-0.2, surface_id = 69, min_friction=1.05, max_friction=2.0 },
		
		wheel_num = 5,
	},
		
	tmp = 0,

	
	-- suspention
	-- table used to store some data for suspension sound processing for each wheel
	suspTable = {
		{
			helper = "wheel1_lower",
			suspWheel = 0,			--	last frame suspension compretion ratio
		},
		{
			helper = "wheel2_lower",
			suspWheel = 0,			--	last frame suspension compretion ratio
		},
		{
			helper = "wheel3_lower",
			suspWheel = 0,			--	last frame suspension compretion ratio
		},
		{
			helper = "wheel4_lower",
			suspWheel = 0,			--	last frame suspension compretion ratio
		},
		{
			helper = "wheel5_lower",
			suspWheel = 0,			--	last frame suspension compretion ratio
		},
	},
	
	suspSoundTable = {
		nil,
		nil,
		nil,
		nil,
	},
	
	-- suspension compresion threshold - when to start susp sound
	suspThreshold = .02,
	-- suspension over

	part_time = 0,
	partDmg_time = 0,
	slip_speed = 0,
	particles_updatefreq = 0.1,--0.05, --initial frequency of updating wheel dust particles and 1st damage partcls

	PropertiesInstance = {
		sightrange = 180,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		aibehavior_behaviour = "Car_idle",		
		groupid = 154,
	},

	Properties = {		

		bActive = 1,	-- if vehicle is initially active or needs to be activated 
				-- with Event_Activate first
		
		bEnabled  = 1,
		DisabledMessage = "",
		bLightsOn = 0,

		bLockUser = 0,

		bSetInvestigate = 0,	-- when releasing people - make them to go to Job_Investigate
		bSameGroupId = 1,

		bTrackable=1,
		bDrawDriver = 0,
		fLimitLRAngles = 100,
		fLimitUDMinAngles = -5,
		fLimitUDMaxAngles = 20,
		fStartDelay = 2,


		ExplosionParams = {
			nDamage = 950,
			fRadiusMin = 8.0, -- default 12
			fRadiusMax = 9, -- default 35.5
			fRadius = 9, -- default 18
			fImpulsivePressure = 600, -- default 200
		},


		bUsable = 1,								-- if this vehicle can be used by _localplayer

-- those are AI related properties
		pointReinforce = "Drop",
		pointBackOff = "Base",
		aggression = 1.0,
		commrange = 100.0,
		cohesion = 5,
		attackrange = 70,
		horizontal_fov = -1,
--		vertical_fov =90,
		eye_height = 2.1,
		forward_speed = 2.46,
--		back_speed = 3,
		max_health = 100,
		responsiveness = 7,
		species = 1,
		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,
		aicharacter_character = "FWDVehicle",
		bApproachPlayer = 1,
--		bodypos = 0,
		pathname = "drive",
		pathsteps = 0,
		pathstart = 0,
		pathstartAlter = -1,
		bPathloop = 1,
		ReinforcePoint = "none",
		fApproachDist = 20,
		
		fAttackStickDist = 1,
		
		bUsePathfind = 1,	-- pathfind when outdoors		
		hit_upward_vel = 6,
		damage_players = 1,
		
		bSleeping = 0,
		
--		bEnterImmedeately = 0,	-- put AI in vehicle without approaching/animations

		--filippo: This table is used (if exist) into "VC:AddUserT" , if the driver is an AI we merge this table with the CarDef.
		AICarDef = {
			bAI_use = 1,
				
			steer_speed = 12.0,
			steer_speed_min = 120.0,
			max_steer_v0 = 25,
			steer_relaxation_v0 = 720,
			
			dyn_friction_ratio = 2,
			max_braking_friction = 0.3,
			handbraking_value = 8,
			
			damping_vehicle = 0.03,
		},
	--///////////////////////     Exhaust Particles     /////////////////////////////////
		ExhaustParticles = {
			bEnabled = 1,
		},	
  --///////////////////////     Exhaust Particles     /////////////////////////////////
  
	--///////////////////////     Speedometer     /////////////////////////////////
		Speedometer = {
			bEnabled = 1,
		},	
  --///////////////////////     Speedometer     /////////////////////////////////
	},

	bExploded=false,

	-- engine health, status of the vehicle
	-- default is set to maximum (1.0f)
	fEngineHealth = 100.0,
	
	-- damage inflicted to the vehicle when it collides
	fOnCollideDamage=0,
	-- damage inflicted to the vehicle when it collides with terrain (falls off)
	fOnCollideGroundDamage=0.8,
	
	--damage inflicted when falling , this value is multiplied by the half of the square of the falling speed:
	--for istance: 5 m/s = 12 dmgpoints * fOnFallDamage
	--	      10 m/s = 50 dmgpoints * fOnFallDamage
	--	      20 m/s = 200 dmgpoints * fOnFallDamage
	fOnFallDamage=0.14,
	
	--damage when colliding with another vehicle, this value is multiplied by the hit.impact value.
	fOnCollideVehicleDamage=1.05,

	bGroundVehicle=1,
	
	-- seats
	driverT = {
		type = PVS_DRIVER,

		helper = "driver",
		in_helper = "driver_sit_pos",
		in_anim = "",
		out_anim = "",
		sit_anim = "humvee_driver_sit",
		anchor = AIAnchor.z_CARENTER_DRIVER,
		out_ang = -90,
		message = "use_hint",
		-- invehicle animations 
		animations = {
			"humvee_driver_sit",		-- idle in animation
			"humvee_driver_moving",		-- driving firward
			"humvee_driver_forward_hit",	-- impact / break
			"humvee_driver_leftturn",	-- turning left
			"humvee_driver_rightturn",	-- turning right
			"humvee_driver_reverse",	-- reversing
			"humvee_driver_reverse_hit",	-- reversing impact / break
		},
	},
	passengersTT = {
		{
			type = PVS_PASSENGER,
		
			helper = "passenger1",
			in_helper = "passenger1_sit_pos",
			in_anim = "",
			out_anim = "",
			sit_anim = "humvee_passenger1_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER1,
			out_ang = 90,
			message = "use_hint",
			-- invehicle animations 
			animations = {
				"humvee_passenger1_sit",		-- idle in animation
				"humvee_passenger1_moving",		-- driving firward
				"humvee_passenger1_forward_hit",	-- impact / break
				"humvee_passenger1_leftturn",		-- turning left
				"humvee_passenger1_rightturn",		-- turning right
				"humvee_passenger1_reverse",		-- reversing
				"humvee_passenger1_reverse_hit",	-- reversing impact / break
			},
		},
		{
			type = PVS_PASSENGER,
		
			helper = "passenger2",
			in_helper = "passenger2_sit_pos",
			in_anim = "",
			out_anim = "",
			sit_anim = "buggy_passenger_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER1,
			out_ang = 90,
			message = "use_hint",
			-- invehicle animations 
			animations = {
				"buggy_passenger_sit",		-- idle in animation
				"buggy_passenger_moving",	-- driving firward
				"buggy_passenger_forward_hit",	-- impact / break
				"buggy_passenger_leftturn",	-- turning left
				"buggy_passenger_rightturn",	-- turning right
				"buggy_passenger_reverse",	-- reversing
				"buggy_passenger_reverse_hit",	-- reversing impact / break
			},
		},
		{
			type = PVS_PASSENGER,
		
			helper = "passenger3",
			in_helper = "passenger3_sit_pos",
			in_anim = "",
			out_anim = "",
			sit_anim = "buggy_passenger_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER1,
			out_ang = 90,
			message = "use_hint",
			-- invehicle animations 
			animations = {
				"buggy_passenger_sit",		-- idle in animation
				"buggy_passenger_moving",	-- driving firward
				"buggy_passenger_forward_hit",	-- impact / break
				"buggy_passenger_leftturn",	-- turning left
				"buggy_passenger_rightturn",	-- turning right
				"buggy_passenger_reverse",	-- reversing
				"buggy_passenger_reverse_hit",	-- reversing impact / break
			},
		},
	},

}

VC.CreateVehicle(vaz21xx);

----------------------------------------------------------------------------------------------------------------------------
--
--
vaz21xx.Client = {	
	OnInit = function(self)
		self:InitClient();
	end,
	OnShutDown = function(self)
		self:OnShutDown();
	end,
	Alive = {
		OnBeginState = function( self )	
			VC.InitGroundVehicleCommon(self,self.fileModel);
		end,
		OnContact = function(self,player)
	 		self:OnContactClient(player);
		end,
		OnUpdate = VC.UpdateClientAlive,
		OnCollide = VC.OnCollideClient,
		OnBind = VC.OnBind,
		OnUnBind = VC.OnUnBind,		
	},
	Inactive = {
		OnBeginState = function( self )
--System:Log("\001  inactive begin");
			self:Hide(1);
		end,
		OnEndState = function( self )
--System:Log("\001  inactive end");
--			self:Hide(0);
			self.IsPhisicalized = 0;
		end,
		
	},
	Dead = {
		OnBeginState = function( self )
			VC.BlowUpClient(self);
		end,
		OnContact = function(self,player)
	 		VC.OnContactClientDead(self,player);
		end,
		OnUpdate = VC.UpdateClientDead,
		OnCollide = VC.OnCollideClient,
		OnUnBind = VC.OnUnBind,	
	},
}


------------------------------------------------------
--
--
vaz21xx.Server = {
	OnInit = function(self)
		self:InitServer();
	end,
	OnShutDown = function(self)
		self:OnShutDown();
	end,
	Alive = {
		OnBeginState = function( self )	
			VC.InitGroundVehicleCommon(self,self.fileModel);
		end,
		OnContact = function(self,player)
	 		self:OnContactServer(player);
		end,
		OnBind = VC.OnBind,
		OnDamage = VC.OnDamageServer,
		OnCollide = VC.OnCollideServer,
		OnUpdate = function(self,dt)
			self:UpdateServer(dt);
		end,
		OnEvent = function (self, id, params)
			self:OnEventServer( id, params);
		end,
	},
	Inactive = {
	},
	Dead = {
		OnBeginState = function( self )
			VC.BlowUpServer(self);
		end,
		OnContact = function(self,player)
	 		VC.OnContactServerDead(self,player);
		end,
	},
}


----------------------------------------------------------------------------------------------------------------------------
--
--
function vaz21xx:OnReset()

	self.bIsEnabled = self.Properties.bEnabled;

--	if(self.fEngineHealth < 100.0) then
--	if(self.bExploded == 1) then
--		VC.InitGroundVehicleServer(self,self.fileModel);
--	end	

	VC.OnResetCommon(self);

	self.fEngineHealth = 100.0;

	self:NetPresent(1);
	
--System:Log("\001  vaz21xx RESET------------------------------------------ ");

	VC.EveryoneOutForce( self );

	AI:RegisterWithAI(self.id, AIOBJECT_CAR,self.Properties,self.PropertiesInstance);	
	VC.InitAnchors( self );
	
	
	VC.AIDriver( self, 0 );	

	self.bExploded=false;
	self.cnt:SetVehicleEngineHealth(self.fEngineHealth);

	self.dropState = 0;

	self.step = self.Properties.pathstart - 1;
	
	Sound:StopSound(self.drive_sound);

	VC.InitWindows(self);

	if(self.Properties.bSleeping == 1) then
		self:AwakePhysics(0);
	end

--////////////////////     Gauge Inititalization     //////////////////////////
	self.speedo_texture = System:LoadTexture( self.Speedo.Dial.fileTexture );
	self.revo_texture = System:LoadTexture( self.Revo.Dial.fileTexture );
	-- Hud:EnableCustomHud(1); --turn on global hud updates
	self.last_time = System:GetCurrTime();
	self.distance = 0;
--////////////////////     Gauge Inititalization     //////////////////////////

end


--////////////////////////////////////////////////////////////////////////////////////////
function vaz21xx:InitPhis()
	VC.InitGroundVehiclePhysics(self,self.fileModel);
end	

--////////////////////////////////////////////////////////////////////////////////////////
function vaz21xx:InitClient()
	
	--disable player weapons
	self.cnt:SetWeaponName("none","");

	VC.InitSeats(self, vaz21xx);

	-- PROTO: Load3DSound(szFilename,dwFlags,nVolume(0-255))
--	self.drive_sound = Sound:Load3DSound("sounds\\vehicle\\idle_loop.wav",0,200,7,100000);
	self.drive_sound_move = Sound:Load3DSound("sounds\\vehicle\\tire_rocks2.wav",0,200,13,300);
	self.maxvolume_speed = 35;
	
	self.drive_sound_move_water = Sound:Load3DSound("sounds\\vehicle\\boat\\splashLP.wav",0,0,13,300);
	self.maxvolume_speed_water = 10;
	
	self.ExplosionSound=Sound:Load3DSound("sounds\\explosions\\explosion2.wav",0,200,150,1000);

--	self.accelerate_sound = {
--		Sound:Load3DSound("sounds\\vehicle\\rev1.wav",0,0,7,200),
--		Sound:Load3DSound("sounds\\vehicle\\rev2.wav",0,0,7,200),
--		Sound:Load3DSound("sounds\\vehicle\\rev3.wav",0,0,7,200),
--		Sound:Load3DSound("sounds\\vehicle\\rev4.wav",0,0,7,200),
--	};

	self.break_sound = Sound:Load3DSound("sounds\\vehicle\\break1.wav",0,100,13,300);
	self.engine_start = Sound:Load3DSound("Sounds/Vehicle/vaz21xx/21xx_on.wav",0,250,13,300);
	self.engine_off = Sound:Load3DSound("Sounds/Vehicle/vaz21xx/21xx_off.wav",0,255,13,300);
	self.sliding_sound = Sound:Load3DSound("sounds\\vehicle\\break2.wav",0,150,13,300);
	
	-------------------------------------------------------------------------------------
--	self.gearup_sounds= {	
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvlowspeedgeardown.wav",0,255,7,200), -- reverse up (0-1)		
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvfirstaccel.wav",0,255,7,200), -- (1-2)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvsecondaccel.wav",0,255,7,200), -- (2-3)
--	};
--
--	self.geardn_sounds={		
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvfirstaccel.wav",0,255,7,200), -- reverse down (1-0)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvlowspeedgeardown.wav",0,255,7,200), -- (2-1)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvhighgeardown.wav",0,255,7,200), -- (3-2)
--	};
--
--	self.idle_sounds={				
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvidle.wav",0,255,7,200), -- reverse idle (0)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvidle.wav",0,255,7,200), -- engine idle (1)
--		Sound:Load3DSound("SOUNDS\\Vehicle\\HV\\hvfirstgearspeedidle.wav",0,255,7,200), -- (2)
--		Sound:Load3DSound("SOUNDS\\Vehicle\\HV\\hvsecondgearspeedidle.wav",0,255,7,200), -- (3)
--	};
	
	self.clutch_sound = Sound:Load3DSound("Sounds/Vehicle/vaz21xx/21xx_gear.wav",0,255,13,300);
	
	self.idleengine = Sound:Load3DSound("Sounds/Vehicle/vaz21xx/21xx_idle.wav",0,250,13,300);
	self.idleengine_ratios = {1,1,1.25,1};
	self.clutchengine_frequencies = {1000,900,500,700};
	self.clutchfreqspeed = 12;
	self.enginefreqspeed = 2;

	self.land_sound = Sound:Load3DSound("sounds\\vehicle\\vehicle_efx\\carclunk.wav",0,255,13,300);
	--self.nogroundcontact_sound=Sound:Load3DSound("sounds\\vehicle\\HV\\hvfirstaccel.wav",0,255,7,200);
	-------------------------------------------------------------------------------------
	
--self.compression_sound_test = Sound:Load3DSound("sounds\\vehicle\\break1.wav",0,150,7,200);

--self.suspSoundTable[1] = Sound:Load3DSound("sounds\\vehicle\\break1.wav",0,150,7,200);
	self.suspSoundTable[1] = Sound:Load3DSound("sounds\\vehicle\\comp1.wav",0,150,7,200);
	self.suspSoundTable[2] = Sound:Load3DSound("sounds\\vehicle\\comp2.wav",0,150,7,200);	
	self.suspSoundTable[3] = Sound:Load3DSound("sounds\\vehicle\\comp3.wav",0,150,7,200);	
	self.suspSoundTable[4] = Sound:Load3DSound("sounds\\vehicle\\comp4.wav",0,150,7,200);	

	self.crash_sound = Sound:Load3DSound("sounds\\vehicle\\carcrash.wav",0,200,13,300);
	
	self.light_sound = Sound:Load3DSound("SOUNDS/items/flight.wav",SOUND_UNSCALABLE,160,3,30);

	VC.InitGroundVehicleClient(self,self.fileModel);

--front_light
--fron_light_left front_light_right
--back_light_left back_light_right
--textures/lights/front_light
--textures/Lens/m280se_lichtwurf
	self.cnt:InitLights( "front_light","textures/lights/front_light",
			"front_light_left","front_light_right","humvee_frontlight",
			"back_light_left", "back_light_right","humvee_backlight" );
	
end

--//////////////////////////////////////////
function vaz21xx:InitServer()

	--disable player weapons
	self.cnt:SetWeaponName("none","");

	VC.InitSeats(self, vaz21xx);

	VC.InitGroundVehicleServer(self,self.fileModel);

	self:OnReset();
--	self:EnableUpdate(1);

--	self.EnableSave(0);

end

--////////////////////////////////////////////////////////////////////////////////////////
function vaz21xx:OnContactServer( player )

	if(self.bIsEnabled == 0) then return end
	
		

	if( self.Properties.bUsable==0 ) then return end
	if( VC.IsUnderWater( self ) == 1 ) then return end
	VC.OnContactServerT(self,player);
end

--////////////////////////////////////////////////////////////////////////////////////////
function vaz21xx:OnContactClient( player )
	
	if(self.bIsEnabled == 0) then 
		Hud.label = self.Properties.DisabledMessage;
		return 
	end
	
	if( self.Properties.bUsable==0 ) then return end		
	if( VC.IsUnderWater( self ) == 1 ) then return end
	VC.OnContactClientT(self,player);
end




-------------------------------------------------------------------------------------------------------------
--
--

function vaz21xx:UpdateServer(dt)

	--filippo
	--VC.FunPhysics(self,dt);

	VC.UpdateEnteringLeaving( self, dt );
	VC.UpdateServerCommonT(self,dt);

	VC.UpdateWheelFriction( self );

	if( VC.IsUnderWater( self, dt ) == 1 ) then 
		VC.EveryoneOutForce( self );
	end;
	
	-- added by xezon, acceleration settings

	if ( self.bDriverInTheVehicle == 1 ) then
		local speed_update = self.cnt:GetVehicleVelocity() * 3.6;

		--local speed_update2 = speed_update / 25;

		if ( speed_update < 1 ) then
	  	--self.CarDef.engine_power = 450000 / (1 + (4 - speed_update2));
	  	self.CarDef.dyn_friction_ratio = 1.2;
	  	self.CarDef.engine_power = 120000;
	  	self:SetPhysicParams(PHYSICPARAM_VEHICLE, self.CarDef);


		elseif ( speed_update > 51 ) and ( speed_update < 52 ) then
			self.CarDef.dyn_friction_ratio = 1.6;
			self.CarDef.engine_power = 200000;
			self:SetPhysicParams(PHYSICPARAM_VEHICLE, self.CarDef);
			
		elseif ( speed_update > 50 ) and ( speed_update < 51 ) then
			self.CarDef.dyn_friction_ratio = 1.2;
			self.CarDef.engine_power = 120000;
			self:SetPhysicParams(PHYSICPARAM_VEHICLE, self.CarDef);
			

		elseif ( speed_update > 100 ) and ( speed_update < 101 ) then
			self.CarDef.engine_power = 300000;
			self.CarDef.dyn_friction_ratio = 2.0;
			self:SetPhysicParams(PHYSICPARAM_VEHICLE, self.CarDef);
			
		elseif ( speed_update > 99 ) and ( speed_update < 100 ) then
			self.CarDef.engine_power = 200000;
			self.CarDef.dyn_friction_ratio = 1.6;
			self:SetPhysicParams(PHYSICPARAM_VEHICLE, self.CarDef);


		elseif ( speed_update > 140 ) and ( speed_update < 141 ) then
			self.CarDef.engine_power = 400000;
			self:SetPhysicParams(PHYSICPARAM_VEHICLE, self.CarDef);
			
		elseif ( speed_update > 139 ) and ( speed_update < 140 ) then
			self.CarDef.engine_power = 300000;
			self:SetPhysicParams(PHYSICPARAM_VEHICLE, self.CarDef);
		end;

		--Hud:AddMessage("power: "..self.CarDef.dyn_friction_ratio.."");


		if ( speed_update < 20 ) and (self.Properties.ExhaustParticles.bEnabled == 1) then
		--Basic Particle code by aarbro ;)

			if ( speed_update < 3 ) then
			local Exhaust = {
			
				TimeDelay = 0.01, -- how often particle system is spawned.
				fUpdateRadius=100,
				FadeInTime = 0.5,

				focus = 4,
				start_color = {1,1,1},
				end_color = {1,1,1}, 
				gravity = { x = 0.0, y = 0.0, z = 1.3 },
				rotation = { x = 0.0, y = 0.0, z = 0.0 },
				speed = 1.7,
				count = 1,
				size = 0.05, 
				size_speed = 0.2,
				lifetime = 1,
				tid = System:LoadTexture("Objects/Vehicles/Mercedes280SE/m280se_exhaust_particle.dds"),
				--tid = System:LoadTexture("Objects/m280se_exhaust_particle.dds"),
				frames = 0,
				blend_type = 0,
				tail_length = 0,--.55,
				turbulence_size = 0,
				turbulence_speed = 0,
				bouncyness = 0.5,
				stretch = 0,
			};
			local pos = self:GetHelperPos("m280se_exhaust");	
			--local pos = self:GetPos();
			local dir = self:GetDirectionVector();
			dir.z = -0.4;
			Particle:CreateParticle(pos,dir,Exhaust);
			end;
			if ( speed_update >= 3 ) and ( speed_update < 20 ) then
			local Exhaust = {
			
				TimeDelay = 0.01, -- how often particle system is spawned.
				fUpdateRadius=100,
				FadeInTime = 0.5,

				focus = 2,
				start_color = {1,1,1},
				end_color = {1,1,1}, 
				gravity = { x = 0.0, y = 0.0, z = 1.3 },
				rotation = { x = 0.0, y = 0.0, z = 0.0 },
				speed = 1.7,
				count = 2,
				size = 0.07, 
				size_speed = 0.6,
				lifetime = 1,
				tid = System:LoadTexture("Objects/Vehicles/Mercedes280SE/m280se_exhaust_particle.dds"),
				--tid = System:LoadTexture("Objects/m280se_exhaust_particle.dds"),
				frames = 0,
				blend_type = 0,
				tail_length = 0,--.55,
				turbulence_size = 0,
				turbulence_speed = 0,
				bouncyness = 0.5,
				stretch = 0,
			};
			local pos = self:GetHelperPos("m280se_exhaust");	
			--local pos = self:GetPos();	
			local dir = self:GetDirectionVector();
			dir.z = -0.4;
			--local speed = self.cnt:GetVehicleVelocity();
			--Exhaust.speed = 1.7 - speed;
			Particle:CreateParticle(pos,dir,Exhaust);
			end;
		end;
	end;
end




----------------------------------------------------------------------------------------------------------------------------
--
--

----------------------------------------------------------------------------------------------------------------------------
--
--
function vaz21xx:OnShutDown()

	-- Free resources
--	System:UnloadImage(self.DustParticles.tid);
	--assingning to nil is not really needed
	--if the entity will be destroyed
	self.break_sound=nil;
	self.engine_start=nil;
	self.engine_off=nil;
	self.sliding_sound=nil;
	self.drive_sound=nil;
	self.drive_sound_move=nil;
	self.accelerate_sound=nil;
	
	VC.EveryoneOutForce( self );
	VC.RemovePieces(self);
	VC.RemoveWindows(self);

	if(self.wreck)	then
		Server:RemoveEntity( self.wreck.id, 1 );
	end	
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function vaz21xx:OnSave(stm)
	stm:WriteInt(self.bIsEnabled);
	stm:WriteInt(self.fEngineHealth);
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function vaz21xx:OnLoad(stm)
	self.bIsEnabled = stm:ReadInt();
	self.fEngineHealth = stm:ReadInt();
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function vaz21xx:OnEventServer( id, params)

--	if (id == ScriptEvent_Reset)
--	then		
--		VC.EveryoneOutForce( self );
--		-- make the guy exit the vehicle
--	end

end

-------------------------------------------------------------------------------------------------------------
--
--
function vaz21xx:DoEnter( puppet )

	if( puppet == self.driverT.entity ) then		
		
--System:Log("DoEnter     DRIVER");		
--		local puppet = self.driver;		
		self.driver = nil;
		VC.AddUserT( self, self.driverT );
		VC.InitEntering( self, self.driverT );
	else
		local tbl = VC.FindPassenger( self, puppet );
		if( not tbl ) then return end
--System:Log("DoEnter     passenger");
		VC.AddUserT( self, tbl );
		VC.InitEntering( self, tbl );
	end
end


-------------------------------------------------------------------------------------------------------------
--
--
function vaz21xx:AddDriver( puppet )

--do return 0 end
	if (self.driverT.entity ~= nil)		then	-- already have a driver
		do return 0 end
	end

--System:Log("vaz21xx:AddDriver");

--	self.driver = puppet;
	self.driverT.entity = puppet;

	if( VC.InitApproach( self, self.driverT )==0 ) then	
--System:Log("vaz21xx:AddDriver  1");		
		self:DoEnter( puppet );
	end
	do return 1 end	
end

-------------------------------------------------------------------------------------------------------------
--
--
function vaz21xx:AddGunner( puppet )
	return 0;
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function vaz21xx:AddPassenger( puppet )
--do return 0 end

	local pasTbl = VC.CanAddPassenger( self, 1 );

	if( not pasTbl ) then	return 0 end	-- no more passangers can be added
	
	pasTbl.entity = puppet;
	if( VC.InitApproach( self, pasTbl )==0 ) then
		self:DoEnter( puppet );
	end
	do return 1 end	
end


----------------------------------------------------------------------------------------------------------------------------
--
--

----------------------------------------------------------------------------------------------------------------------------
--
--

function vaz21xx:OnWrite( stm )
	
	
		
--	if(self.driver) then
--		stm:WriteInt(self.driver.id);
--	else	
--		stm:WriteInt(0);
--	end	
--	if(self.passenger) then
--		stm:WriteInt(self.passenger.id);
--	else	
--		stm:WriteInt(0);
--	end	
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function vaz21xx:OnRead( stm )
--local	id=0;	
--
--
--	id = stm:ReadInt();
--	if( id ~= 0 ) then
--		self.driver = System:GetEntity(id);
--	else
----		self.driverP = self.driver;
--		self.driver = nil;
--	end
--	
--	id = stm:ReadInt();
--	if( id ~= 0 ) then
--		self.passenger = System:GetEntity(id);
--	else
--		self.passenger = nil;
--	end
end



----------------------------------------------------------------------------------------------------------------------------
--
--
function vaz21xx:Event_EveryoneOut()

	VC.DropPeople( self );
	
end
	
	
----------------------------------------------------------------------------------------------------------------------------
--
--
function vaz21xx:Event_AIDriverIn()

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

	VC.AIDriver( self, 1);
	
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function vaz21xx:Event_AIDriverOut()

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

	VC.AIDriver( self, 0);

end



----------------------------------------------------------------------------------------------------------------------------
--
--
			
----------------------------------------------------------------------------------------------------------------------------
--
--
function vaz21xx:RadioChatter()
end


----------------------------------------------------------------------------------------------------------------------------
--
--
function vaz21xx:LoadPeople()

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

--	self:AIDriver( 1 );

--System:Log("humvee LoadPeople  ");

	if(self.driverT.entity and self.driverT.entity.ai) then
		
--System:Log("vaz21xx LoadPeople  DRIVER IN ");
		AI:Signal(0, 1, "DRIVER_IN", self.id);
	end	
	
--System:Log("vaz21xx LoadPeople loading");


	if( self.Properties.bSameGroupId == 1 ) then
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "wakeup", self.id);	
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "SHARED_ENTER_ME_VEHICLE", self.id);
	else
		AI:Signal(SIGNALFILTER_ANYONEINCOMM, 1, "wakeup", self.id);	
		AI:Signal(SIGNALFILTER_ANYONEINCOMM, 1, "SHARED_ENTER_ME_VEHICLE", self.id);
	end
	self.dropState = 1;

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function vaz21xx:DropPeople()

	VC.DropPeople( self );

end



----------------------------------------------------------------------------------------------------------------------------
--
--	to test-call reinf
function vaz21xx:Event_Reinforcment( params )

--printf( "signaling BRING_REINFORCMENT " );	

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

	VC.AIDriver( self, 1 );	
	AI:Signal(0, 1, "BRING_REINFORCMENT", self.id);
	
end	


----------------------------------------------------------------------------------------------------------------------------
--
function vaz21xx:Event_GoPatrol( params )

--System:Log("\001  vaz21xx GoPath  ");

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

	VC.AIDriver( self, 1 );	
	AI:Signal(0, 1, "GO_PATROL", self.id);

end


----------------------------------------------------------------------------------------------------------------------------
--
function vaz21xx:Event_GoChase( params )

--System:Log("\001  vaz21xx GoPath  ");

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

	VC.AIDriver( self, 1 );	
	AI:Signal(0, 1, "GO_CHASE", self.id);

end

----------------------------------------------------------------------------------------------------------------------------
--
-- 
function vaz21xx:Event_KillTriger( params )

	self.cnt:SetVehicleEngineHealth(0);
	self:GotoState( "Dead" );
--	self.fEngineHealth = 0;

end

----------------------------------------------------------------------------------------------------------------------------
--
-- to test
function vaz21xx:Event_Grenade( params )

--System:Log("\001  vaz21xx GoPath  ");

	AI:Signal(0, 1, "OnGrenadeSeen", self.id);

end

----------------------------------------------------------------------------------------------------------------------------
--
function vaz21xx:Event_GoPath( params )

--System:Log("\001  vaz21xx GoPath  ");

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

	VC.AIDriver( self, 1 );	
	AI:Signal(0, 1, "GO_PATH", self.id);

end


----------------------------------------------------------------------------------------------------------------------------
--
function vaz21xx:Event_PausePath( params )

--System:Log("\001  vaz21xx PausePath  ");

--	AI:Signal( 0, 1, "EVERYONE_OUT",self.id);
	AI:Signal( 0, 1, "DRIVER_OUT",	self.id);

end


----------------------------------------------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------------------
function vaz21xx:Event_LoadPeople( params )

--	VC.AIDriver( self, 1 );
	self:LoadPeople();
	
end



----------------------------------------------------------------------------------------------------------------------------
--
function vaz21xx:Event_Wakeup( params )

	self:AwakePhysics(1);
	
end
----------------------------------------------------------------------------------------------------------------------------
--
function vaz21xx:Event_Enablevaz21xx( params )

	self.bIsEnabled = 1;
	
end	


----------------------------------------------------------------------------------------------------------------------------
--
function vaz21xx:Event_Disablevaz21xx( params )

	self.bIsEnabled = 0;
	
end	


----------------------------------------------------------------------------------------------------------------------------
--
function vaz21xx:Event_DriverIn( params )
	BroadcastEvent( self,"DriverIn");
end

function vaz21xx:Event_DriverExit(params)
	BroadcastEvent(self,"DriverExit");
end	

----------------------------------------------------------------------------------------------------------------------------
--
function vaz21xx:Event_AIEntered( params )

	BroadcastEvent( self,"AIEntered" );
	
end	

----------------------------------------------------------------------------------------------------------------------------
--
function vaz21xx:Event_PlayerEntered( params )

	BroadcastEvent( self,"PlayerEntered" );
	
end	



----------------------------------------------------------------------------------------------------------------------------
--
function vaz21xx:Event_PathEnd( params )

	BroadcastEvent( self,"PathEnd" );
	
end	


----------------------------------------------------------------------------------------------------------------------------
--
function vaz21xx:Event_Activate( params )

	if(self.bExploded == 1) then return end
	
	self:GotoState( "Alive" );

end	


----------------------------------------------------------------------------------------------------------------------------
--
--function vaz21xx:Event_Hide( params )
--	self:Hide(1);
--end	

----------------------------------------------------------------------------------------------------------------------------
--
function vaz21xx:Event_Unhide( params )
	self:Hide(0);
end	


--------------------------------------------------------------------------------------------------------
-- empty function to get reed of script error - it's called from behavours
function vaz21xx:MakeAlerted()
end


--///////////////////////     Gauges     /////////////////////////////////
	
function vaz21xx:OnUpdateCustomHud()

	if ( not self:IsValidForGauge() ) then
		return
	end
	
	if ( self.Speedo.bEnabled == 1 ) then
		self:DrawSpeedo();
	end
	if ( self.Revo.bEnabled == 1 ) then
		self:DrawRevo();
	end
	
end
-------------------------------------------------------------------------------
function vaz21xx:limit( val, vmin, vmax )
	if ( val < vmin ) then
		return vmin;
	end
	if ( val > vmax ) then
		return vmax;
	end
	return val;
end
-------------------------------------------------------------------------------
function vaz21xx:IsValidForGauge()

	if ( self.Properties.Speedometer.bEnabled == 0 ) then
		return nil
	end

	if ( not _localplayer.theVehicle ) then --player is not in a vehicle
		return nil
	end

	if ( _localplayer.theVehicle:GetName() ~= self:GetName() ) then -- wrong vehicle entered
		return nil
	end

	if ( _localplayer.theVehicle.driverT.entity ~= _localplayer ) then --player is not driving
		return nil
	end
	
	return 1
end
-------------------------------------------------------------------------------
function vaz21xx:DrawSpeedo()
	local speed = _localplayer.theVehicle.cnt:GetVehicleVelocity() * self.Speedo.fUnitMultiplier;

	local time = System:GetCurrTime();
	local timedelta = time - self.last_time;
	local dist = timedelta / 360 * speed; --units (km, mile, nm) x 10
	self.distance = self.distance + dist;
	self.last_time = time;
	
	local amin = self.Speedo.Needle.fAngleMin;
	local amax = self.Speedo.Needle.fAngleMax;
	local vmin = self.Speedo.Needle.fValueMin;
	local vmax = self.Speedo.Needle.fValueMax;
	
	local ang_span = amax-amin;
	local spd_span = vmax-vmin;
	local ang = ( ( (self:limit( speed, vmin, vmax ) - vmin) / spd_span) * ang_span ) + amin;
	
	ang = ( 360 - ang + 270 ) / 180 * PI; --move 0, change direction and convert to radians
	local x = cos( ang ) * self.Speedo.Needle.Length;
	local y = -sin( ang ) * self.Speedo.Needle.Length;
	local x0 = cos( ang + PI / 2 ) * 0.75;
	local y0 = -sin( ang + PI / 2 ) * 0.75;
	local x2 = cos( ang - PI / 2 ) * 0.75;
	local y2 = -sin( ang - PI / 2 ) * 0.75;
	
	local src_x = self.Speedo.Dial.LocationX + self.Speedo.Needle.CenterX;
	local src_y = self.Speedo.Dial.LocationY + self.Speedo.Needle.CenterY;
	local dest_x = self.Speedo.Dial.LocationX + self.Speedo.Needle.CenterX + x;
	local dest_y = self.Speedo.Dial.LocationY + self.Speedo.Needle.CenterY + y;

	
	System:DrawImageColor(
			self.speedo_texture,
			self.Speedo.Dial.LocationX,
			self.Speedo.Dial.LocationY,
			self.Speedo.Dial.Width,
			self.Speedo.Dial.Height,
			self.Speedo.Dial.Blending,
			self.Speedo.Dial.ColorR,
			self.Speedo.Dial.ColorG,
			self.Speedo.Dial.ColorB,
			self.Speedo.Dial.Transparency
		);
	if ( self.Speedo.SpeedDigits.bShowDigits == 1 ) then
  	Game:SetHUDFont( self.Speedo.SpeedDigits.FontName, self.Speedo.SpeedDigits.FontEffect );
  	Game:WriteHudStringFixed( 
  		self.Speedo.SpeedDigits.LocationX + self.Speedo.Dial.LocationX,
  		self.Speedo.SpeedDigits.LocationY + self.Speedo.Dial.LocationY,
  		format( self.Speedo.SpeedDigits.DigitFormat, speed),
  		self.Speedo.SpeedDigits.ColorR,
  		self.Speedo.SpeedDigits.ColorG,
  		self.Speedo.SpeedDigits.ColorB,
  		self.Speedo.SpeedDigits.Transparency,
  		self.Speedo.SpeedDigits.Width,
  		self.Speedo.SpeedDigits.Height,
  		self.Speedo.SpeedDigits.Scale );
  end
	if ( self.Speedo.TripDigits.bShowDigits == 1 ) then
  	Game:SetHUDFont( self.Speedo.TripDigits.FontName, self.Speedo.TripDigits.FontEffect );
  	Game:WriteHudStringFixed( 
  		self.Speedo.TripDigits.LocationX + self.Speedo.Dial.LocationX,
  		self.Speedo.TripDigits.LocationY + self.Speedo.Dial.LocationY,
  		format( self.Speedo.TripDigits.DigitFormat, self.distance),
  		self.Speedo.TripDigits.ColorR,
  		self.Speedo.TripDigits.ColorG,
  		self.Speedo.TripDigits.ColorB,
  		self.Speedo.TripDigits.Transparency,
  		self.Speedo.TripDigits.Width,
  		self.Speedo.TripDigits.Height,
  		self.Speedo.TripDigits.Scale );
  end
	System:Draw2DLine(
			src_x,
			src_y,
			dest_x,
			dest_y,
			self.Speedo.Needle.ColorR,
			self.Speedo.Needle.ColorG,
			self.Speedo.Needle.ColorB,
			self.Speedo.Needle.Transparency
		);
	System:Draw2DLine(
			src_x + x0,
			src_y + y0,
			dest_x,
			dest_y,
			self.Speedo.Needle.ColorR,
			self.Speedo.Needle.ColorG,
			self.Speedo.Needle.ColorB,
			self.Speedo.Needle.Transparency
		);
	System:Draw2DLine(
			src_x + x2,
			src_y + y2,
			dest_x,
			dest_y,
			self.Speedo.Needle.ColorR,
			self.Speedo.Needle.ColorG,
			self.Speedo.Needle.ColorB,
			self.Speedo.Needle.Transparency
		);
end
-------------------------------------------------------------------------------
function vaz21xx:DrawRevo()

	local vstatus = _localplayer.theVehicle.cnt:GetVehicleStatus();
	local rev = vstatus.engineRPM * 0.05;
	
	local amin = self.Revo.Needle.fAngleMin;
	local amax = self.Revo.Needle.fAngleMax;
	local vmin = self.Revo.Needle.fRevMin;
	local vmax = self.Revo.Needle.fRevMax;
	
	local ang_span = amax-amin;
	local rev_span = vmax-vmin;
	self.Revo.Needle.Pos.ang = ( ( (self:limit( rev, vmin, vmax ) - vmin) / rev_span) * ang_span ) + amin;
	
	--ang = ( 360 - ang + 270 ) / 180 * PI; --move 0, change direction and convert to radians

	local speed = _localplayer.theVehicle.cnt:GetVehicleVelocity() * self.Speedo.fUnitMultiplier;
	if not (((speed > 50) and (speed < 52)) or ((speed > 99) and (speed < 101)) or ((speed > 139) and (speed < 141))) then
		self.Revo.Needle.Pos.ang = ( 360 - self.Revo.Needle.Pos.ang + 270 ) / 180 * PI; --move 0, change direction and convert to radians
		self.Revo.Needle.Pos.x = cos( self.Revo.Needle.Pos.ang ) * self.Revo.Needle.Length;
		self.Revo.Needle.Pos.y = -sin( self.Revo.Needle.Pos.ang ) * self.Revo.Needle.Length;
		self.Revo.Needle.Pos.x0 = cos( self.Revo.Needle.Pos.ang + PI / 2 ) * 0.75;
		self.Revo.Needle.Pos.y0 = -sin( self.Revo.Needle.Pos.ang + PI / 2 ) * 0.75;
		self.Revo.Needle.Pos.x2 = cos( self.Revo.Needle.Pos.ang - PI / 2 ) * 0.75;
		self.Revo.Needle.Pos.y2 = -sin( self.Revo.Needle.Pos.ang - PI / 2 ) * 0.75;
	end
	
	--local x = cos( ang ) * self.Revo.Needle.Length;
	--local y = -sin( ang ) * self.Revo.Needle.Length;
	--local x0 = cos( ang + PI / 2 ) * 0.75;
	--local y0 = -sin( ang + PI / 2 ) * 0.75;
	--local x2 = cos( ang - PI / 2 ) * 0.75;
	--local y2 = -sin( ang - PI / 2 ) * 0.75;
	
	local src_x = self.Revo.Dial.LocationX + self.Revo.Needle.CenterX;
	local src_y = self.Revo.Dial.LocationY + self.Revo.Needle.CenterY;
	local dest_x = self.Revo.Dial.LocationX + self.Revo.Needle.CenterX + self.Revo.Needle.Pos.x;
	local dest_y = self.Revo.Dial.LocationY + self.Revo.Needle.CenterY + self.Revo.Needle.Pos.y;

	
	System:DrawImageColor(
			self.revo_texture,
			self.Revo.Dial.LocationX,
			self.Revo.Dial.LocationY,
			self.Revo.Dial.Width,
			self.Revo.Dial.Height,
			self.Revo.Dial.Blending,
			self.Revo.Dial.ColorR,
			self.Revo.Dial.ColorG,
			self.Revo.Dial.ColorB,
			self.Revo.Dial.Transparency
		);


	System:Draw2DLine(
			src_x,
			src_y,
			dest_x,
			dest_y,
			self.Revo.Needle.ColorR,
			self.Revo.Needle.ColorG,
			self.Revo.Needle.ColorB,
			self.Revo.Needle.Transparency
		);
	System:Draw2DLine(
			src_x + self.Revo.Needle.Pos.x0,
			src_y + self.Revo.Needle.Pos.y0,
			dest_x,
			dest_y,
			self.Revo.Needle.ColorR,
			self.Revo.Needle.ColorG,
			self.Revo.Needle.ColorB,
			self.Revo.Needle.Transparency
		);
	System:Draw2DLine(
			src_x + self.Revo.Needle.Pos.x2,
			src_y + self.Revo.Needle.Pos.y2,
			dest_x,
			dest_y,
			self.Revo.Needle.ColorR,
			self.Revo.Needle.ColorG,
			self.Revo.Needle.ColorB,
			self.Revo.Needle.Transparency
		);

	if ( self.Revo.Digits.bShowRevDigits == 1 ) then
  	Game:SetHUDFont( self.Revo.Digits.FontName, self.Revo.Digits.FontEffect );
  	Game:WriteHudStringFixed( 
  		self.Revo.Digits.LocationX + self.Revo.Dial.LocationX,
  		self.Revo.Digits.LocationY + self.Revo.Dial.LocationY,
  		format( self.Revo.Digits.DigitFormat, rev),
  		self.Revo.Digits.ColorR,
  		self.Revo.Digits.ColorG,
  		self.Revo.Digits.ColorB,
  		self.Revo.Digits.Transparency,
  		self.Revo.Digits.Width,
  		self.Revo.Digits.Height,
  		self.Revo.Digits.Scale );
  end

end
--///////////////////////     Gauges     /////////////////////////////////

