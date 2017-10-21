-- script by Zortech, Aarbro, Freestyle Pdc.
-- Model & Textures by zortech, Freestyle Pdc.

--change "fileModelDead","szNormalModel","fileName"

--#Script.ReloadScript("SCRIPTS/Default/Entities/Vehicles/Kawasaki_Ultra150.lua")
	Kawasaki_Ultra150_std = {
--	type = "Vehicle",
	IsBoat = 1,

	DamageParams = {
		fDmgScaleAIBullet = 0.1,
		fDmgScaleAIExplosion = 0.335,--patch2:vehicles must explode with 1 missile --before was 0.4,  
		fDmgScaleBullet = 0.25,
		fDmgScaleExplosion = 0.25,--patch2:vehicles must explode with 1 missile --before was 1,  
		
		dmgBulletMP = 10.0,--if this value exist in multiplayer will be used this damage for every bullet , 
				  --so for instance, no difference between a sniper rifle and a desert eagle.
				  --Vehicles have 100 points of health.
				  --in this case 100 bullets are needed to destroy the vehicle.
	},

	--model to be used for destroyed vehicle
	fileModelDead = "objects/Vehicles/Kawasaki_Ultra150/Kawasaki-Ultra150Wreck.cgf",
--	fileGunModel = "Objects/Vehicles/Mounted_gun/mounted_gun_with_RL.cga",		
	
	fPartUpdateTime = 0,
	fGroundtime = 0,
	dWeapon = 0,
	tpvStateD = 0,

	--entering fake_jump/blending staff
	entVel = 9,

	userCounter = 0,
	driverWaiting = 1,
	driverDelay = 0,
	passengerLimit = 0,

	curPathStep = 0,
	
	-- previous state on the client before entering the vehicle
	bDriverInTheVehicle = 0,
	-- previous driver on the client before leaving the vehicle
	pPreviousDriver=nil,
	-- previous passenger state on the client before entering the vehicle
	bPassengerInTheVehicle = 0,
	-- previous passenger on the client before leaving the vehicle
	pPreviousPassenger=nil,

	IsPhisicalized = 0,	
		
	
--/////////////////////////////////////////////////////////////////////////
-- damage stuff
	-- particle system to display when the vehicle is damaged stage 1
	Damage1Effect = "smoke.vehicle_damage1.a",
	-- particle system to display when the vehicle is damaged stage 2
	Damage2Effect = "smoke.vehicle_damage2.a",
	-- particle system to display when the vehicle explodes
	ExplosionEffect = "explosions.4WD_explosion.a",
	-- particle system to display when the vehicle is destroyed
	DeadEffect = "fire.burning_after_explosion.a",
	-- material to be used when vehicle is destroyed
	DeadMaterial = "Vehicles.Gunboat_Screwed",


	szNormalModel="objects/Vehicles/Kawasaki_Ultra150/Kawasaki_Ultra150.cgf",
	-- szNormalModel="objects/Vehicles/gunboat/gunboat.cgf",
	-- szNormalModel="objects/Vehicles/patrolboat/patrolboat_hull.cgf",

	PropertiesInstance = {
		sightrange = 220,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		aibehavior_behaviour = "Boat_idle",		
		groupid = 154,
		bUsable = 1,		-- if this boat can be used by _localplayer
	},


	Properties = {

		bActive = 1,	-- if vehicle is initially active or needs to be activated 
				-- with Event_Activate first
		bUseRL = 0,	-- weapon for gunner is RocketLauncher
		bUseRLguided = 0,	-- weapon for gunner is COVERRL	
		damage_players = 1,

		sDriverName = "",
--		bHasMWeapon = 1,
	
		bLightsOn = 0,

		fAISoundRadius = 30,

		AttackParams = {
			sightrange = 220,
			horizontal_fov = -1,
		},
	
--		GunnerParams = {
--			responsiveness = 50,
--			sightrange = 150,
--			attackrange = 350,
--			horizontal_fov = -1,
--			aggression = 1,
--			accuracy = 1,
--		},
		
		bSetInvestigate = 0,
		bSameGroupId = 1,		-- send signals withing same group
		
		bLandOnPlayerLand=0,
		bTrackable=1,

		fileName = "objects/Vehicles/Kawasaki_Ultra150/Kawasaki_Ultra150.cgf",
		--fileName = "objects/Vehicles/gunboat/gunboat.cgf",
		--fileName = "objects/Vehicles/gunboat/gunboat.cgf",
		fStartDelay = 2,
		
		bDrawDriver = 0,
		damping = 0.1,
		water_damping = 0,
		water_sleep_speed = 0.015,
		water_resistance = 1000,
		fLimitLRAngles = 150,
		fLimitUDMinAngles = -45,
		fLimitUDMaxAngles = 40,
		
		ExplosionParams = {
			nDamage = 900,
			fRadiusMin = 8.0, -- default 12
			fRadiusMax = 10, -- default 35.5
			fRadius = 10, -- default 17
			fImpulsivePressure = 200, -- default 200
		},
-- those are AI related properties
		pointReinforce = "Drop",
		pointBackOff = "Base",
		aggression = 1.0,
		commrange = 100.0,
		cohesion = 5,
		attackrange = 70,
		horizontal_fov = -1,
		vertical_fov =90,
		eye_height = 2.1,
		max_health = 70,
		accuracy = 0.6,
		responsiveness = 7,
		species = 1,
		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,
		aicharacter_character = "BoatGun",
		bodypos = 0,
		pathname = "none",
		pathsteps = 0,
		pathstart = 0,
		forward_speed = 1,	-- don't scale down fwd impuls - max speed
		
		
		bUsePathfind = 0,	-- pathfind when outdoors
	},

	
--	boat_params={
--		Dumprot	 	= 6000,
--		Dumpv		= 700,
----		Dumprot	 	= 12000,
----		Dumpv		= 1400,
--		Dumpvh		= 10000,
--		Dumpw		= 2000,	--waves dump
--		Turn		= 12000,
--		Speedv		= 20000,
--		Speedturnmin	= 3,
--		Stand		= 10000,	-- forsing to normal vertical position impuls
--		WaveM		= 200,	--fake waves momentum
--		TiltTurn	= 130,	--tilt momentum when turning
--		fMass 		= 800,
--		Flying		= 0,
--	},

--UBI changes - new boat settings


	boat_paramsAI={
		Damprot	 	= 50000, --8000,
		Dampv		= 10500, --3500,
		Dampvs		= 33500, --3500,
		Dampvh		= 100000,
--		Dampw		= 30000,	--waves dump
		Dampw		= .18,	--waves damp
		Turn		= 200000,	--200000
		Speedv		= 600000,--115000,
		Speedturnmin	= .5,
		Stand		= 100000,	-- forsing to normal vertical position impuls
		WaveM		= 100,	--fake waves momentum
		TiltTurn	= 1570,	--tilt momentum when turning
		TiltSpd		= 100,	--tilt momentum when speeding up
		TiltSpdA	= 0.06,	--tilt momentum when speeding up (acceleration thrhld)
		TiltSpdMinV	= 10.0,	--tilt momentum when speeding up (min speed to tilt when not accelerating)
		TiltSpdMinVTilt	= 0.37,	--tilt momentum when speeding up (how much to tilt when not accelerating)
		fMass 		= 15000,
		Flying		= 0,
		
		StandInAir	= 10000,	-- forsing to normal vertical position impuls, when in air.
		gravity		= -9.81,--gravity , used whe the boat is jumping
	},

---------------------------- HERE

	boat_params={
		Damprot	 	= 50000, --8000,
		Dampv		= 4500, --3500,
		Dampvs		= 33500, --3500,
		Dampvh		= 100000,
--		Dampw		= 300000,	--waves dump
		Dampw		= 0.18,	--waves damp	.3			
		Turn		= 92000,	--42000
		TurnMin		= 98000,	--38000
		TurnVelScale	= 10,
		Speedv		= 175000,--175000,
		Speedturnmin	= 3,
		Stand		= 350000,	-- forsing to normal vertical position impuls
		WaveM		= 10000,	--fake waves momentum
		TiltTurn	= 2770,	--tilt momentum when turning
		TiltSpd		= 3500,	--tilt momentum when speeding up
		TiltSpdA	= 0.05,	--tilt momentum when speeding up (acceleration thrhld)
		TiltSpdMinV	= 10.0,	--tilt momentum when speeding up (min speed to tilt when not accelerating)
		TiltSpdMinVTilt	= 0.17,	--tilt momentum when speeding up (how much to tilt when not accelerating)
		fMass 		= 15000,
		Flying		= 0,
		
		StandInAir	= 10000,	-- forsing to normal vertical position impuls, when in air.
		gravity		= -9.81,--gravity , used whe the boat is jumping
		
		CameraDist	= 8.5, --8.5
	
		


--		Damprot	 	= 50000, --8000,
--		Dampv		= 4500, --3500,
--		Dampvs		= 33500, --3500,
--		Dampvh		= 100000,
--		Dampw		= 300000,	--waves dump
--		Turn		= 42000,	--7000
--		TurnMin		= 38000,	--7000
--		TurnVelScale	= 10,
--		Speedv		= 175000,--115000,
--		Speedturnmin	= 3,
--		Stand		= 350000,	-- forsing to normal vertical position impuls
--		WaveM		= 10000,	--fake waves momentum
--		TiltTurn	= 2770,	--tilt momentum when turning
--		TiltSpd		= 3500,	--tilt momentum when speeding up
--		TiltSpdA	= 0.05,	--tilt momentum when speeding up (acceleration thrhld)
--		TiltSpdMinV	= 10.0,	--tilt momentum when speeding up (min speed to tilt when not accelerating)
--		TiltSpdMinVTilt	= 0.17,	--tilt momentum when speeding up (how much to tilt when not accelerating)
--		fMass 		= 15000,
--		Flying		= 0,
	},
	
	
--UBI changes - over
	
--	b_speedv = 1200,  -- controls boat speed (movement forward/backward impulse) 
--	b_turn = 100,  -- controls how fast boat turns (turning left/right impulse)
--	fMass = 2500,

	sound_time = 0,

	particles_updatefreq = 0.24, --initial frequency of updating particles

	partDmg_time = 0,


--// particles definitions
--////////////////////////////////////////////////////////////////////////////////////////

	WaterParticle = {--boat engines affecting the water (splashes behind the boat)
		focus = 20,
		speed = 2.0,
		count = 7,
		size = 1.8, 
		size_speed=0.01,
		gravity={x=0,y=0,z=-3.4},
		rotation={x=1,y=1,z=2},
		lifetime= 1.2,
		tid = System:LoadTexture("textures\\water_splash"),
		start_color = {1,1,1},
		end_color = {1,1,1},
		blend_type = 0,
		frames=0,
		draw_last=1,
			},

	WaterFogTrail=  {
				focus = 50,
				start_color = {1,1,1},
				end_color = {1,1,1}, 
				gravity = {x = 0.0,y = 0.0,z = -6.5}, --default z = -6.5
				rotation = {x = 0.0, y = 0.0, z = 2},
				speed = 12, -- default 12
				count = 6,
				size = 1, 
				size_speed=2.50, --default = 15
				lifetime= 1.0, --default = 3.5
				tid = System:LoadTexture("textures\\dirt2"),---clouda2.dds
				frames=1,
				blend_type = 0
			},
	WaterSplashes=
			{ --boat engines affecting the water (trail thats left behind the boat)
				focus = 60.0,
				start_color = {1,1,1},
				end_color = {1,1,1},
				gravity = {x = 0.0,y = 0.0,z = 0.0},
				rotation = {x = 0.0, y = 0.0, z = 0.5},
				speed = 2,
				count = 2,
				size = 5.0,
				size_speed=20,
				lifetime= 9.0,
				tid = System:LoadTexture("textures\\water_splash"),
				frames=1,
				blend_type = 0,
				particle_type=1
			},

	PropellerWake=
			{ --PropellerWake
				focus = 20.0,
				start_color = {1,1,1},
				end_color = {1,1,1},
				gravity = {x = 0.0,y = 0.0,z = 0.0}, 
				rotation = {x = 0.0, y = 0.0, z = 0.1}, 
				speed = 6,
				count = 2,
				size = 4.0,
				size_speed=4.0,
				lifetime= 6.0,
				tid = System:LoadTexture("textures\\water_splash"),
				frames=1,
				blend_type = 0,
				particle_type=1
			},

	bExploded=false,

	-- engine health, status of the vehicle
	-- default is set to maximum (1.0f)
	fEngineHealth = 100.0,

	-- damage inflicted to the vehicle when it collides
	fOnCollideDamage=0.25,
	-- damage inflicted to the vehicle when it collides with terrain (falls off)
	fOnCollideGroundDamage=0.25,
	
	--damage when colliding with another vehicle, this value is multiplied by the hit.impact value.
	fOnCollideVehicleDamage=3.5,


	bGroundVehicle=0,

	-- to smooth speed changes
	timecount=0,
	previousTimes={},

	driverT = {
		type = PVS_DRIVER,
	
		helper = "driver",
		in_helper = "driver_sit_pos",
		sit_anim = "jetski_driver_sit",
		anchor = AIAnchor.AIANCHOR_BOATENTER_SPOT,
		out_ang = -90,
		message = "Press Use to drive",
		timePast=0,
		HS=0,	-- used for fake jump arch calculatio - arch scale
		HK=0,	-- used for fake jump arch calculatio
		HO=0,	-- used for fake jump arch calculatio	
		HT=0,	-- used for fake jump arch calculatio
		
		animations = {

		"jetski_driver_sit", -- idle in animation
		"jetski_driver_moving", -- driving firward
		"jetski_driver_forward_hit", -- impact / break
		"jetski_driver_leftturn", -- turning left
		"jetski_driver_rightturn", -- turning right
		"jetski_driver_reverse", -- reversing
		"jetski_driver_reverse_hit", -- reversing impact / break

		},
	},

	--seats
--	gunnerT = {
--		type = PVS_GUNNER,
	
--		helper = "gunner",
--		in_helper = "gunner_sit_pos",
--		sit_anim = "gunboat_gunner_sit",
--		anchor = AIAnchor.AIANCHOR_BOATENTER_SPOT,
--		out_ang = -90,
--		message = "@gunnerboat",
--		timePast=0,
--		HS=0,	-- used for fake jump arch calculatio - arch scale
--		HK=0,	-- used for fake jump arch calculatio
--		HO=0,	-- used for fake jump arch calculatio	
--		HT=0,	-- used for fake jump arch calculatio
--	},
	
	--canbepushed, if player is in contact with some entity and he is pressing use, its checked this function.
	--can return 3 kind of values:
	--	- nil if the entity cant be pushed
	--	- -1 or 0 if the push force to be used is the player standard
	--	- a different value means a custom push force
	CanBePushed = VC.CanBePushed,
	
	pushpower = 20000,
}

VC.CreateVehicle(Kawasaki_Ultra150_std);

--////////////////////////////////////////////////////////////////////////////////////////
function Kawasaki_Ultra150_std:OnReset()
	VC.OnResetCommon(self);

	self.fEngineHealth = 100.0;

	self:NetPresent(1);

	VC.EveryoneOutForce(self);

	self.bExploded=false;
	self.cnt:SetVehicleEngineHealth(self.fEngineHealth);

	--AI stuff
--	self:RegisterWithAI(AIOBJECT_BOAT,self.Properties);
	AI:RegisterWithAI(self.id, AIOBJECT_BOAT,self.Properties,self.PropertiesInstance);
--	AI_HandlersDefault:InitCharacter( self );
	VC.AIDriver( self, 0 );	

	self.curPathStep = 0;

	self.fPartUpdateTime = 0;
	self.fGroundtime = 0;

	
	-- Put physics asleep.
	self:AwakePhysics(0);
	
--front_light
--fron_light_left front_light_right
--back_light_left back_light_right
--textures/lights/front_light
	self.cnt:InitLights( "front_light","textures/lights/front_light",
			"front_light_left","front_light_right","humvee_frontlight",
			"back_light_left", "back_light_right","" );

end


--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////
--// CLIENT functions definitions
--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////
Kawasaki_Ultra150_std.Client = {
	OnInit = function(self)
		self:InitClient();
	end,
	OnShutDown = function(self)
		self:OnShutDown();
	end,
	Alive = {
		OnBeginState = function( self )	
			VC.InitBoatCommon(self);
		end,
		OnContact = function(self,player)
	 		self:OnContactClient(player);
		end,
		OnUpdate = function(self,dt)
	 		self:UpdateClientAlive(dt);
		end,
		OnCollide = VC.OnCollideClient,
		OnBind = VC.OnBind,
		OnUnBind = VC.OnUnBind,
	},
	Inactive = {
		OnBeginState = function( self )
			self:Hide(1);
		end,
		OnEndState = function( self )
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
--- server stuff
Kawasaki_Ultra150_std.Server = {
	OnInit = function(self)
		self:InitServer();
	end,
	OnShutDown = function(self)
		self:OnShutDown();
	end,
	Alive = {
		OnBeginState = function( self )	
			VC.InitBoatCommon(self);
		end,
		OnContact = function(self,player)
	 		self:OnContactServer(player);
		end,
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

--////////////////////////////////////////////////////////////////////////////////////////
function Kawasaki_Ultra150_std:InitClient()

	VC.InitSeats(self, Kawasaki_Ultra150_std);

	--// load sounds on the client
	--////////////////////////////////////////////////////////////////////////////////////////
	
	self.ExplosionSound=Sound:Load3DSound("sounds\\explosions\\explosion2.wav",0,255,150,300);

	--self.drive_sound = Sound:Load3DSound("sounds\\vehicle\\boat\\gunboat_idle.wav",0,185,50,300);
	self.drive_sound = Sound:Load3DSound("Sounds\\building\\airrattle.wav",0,185,30,150);
	self.drive_sound_move = Sound:Load3DSound("sounds\\vehicle\\boat\\splashLP.wav",0,35,10,150);
	self.maxvolume_speed = 25;

	self.accelerate_sound = {
		Sound:Load3DSound("sounds\\vehicle\\rev1.wav",0,0,7,100),
		Sound:Load3DSound("sounds\\vehicle\\rev2.wav",0,0,7,100),
		Sound:Load3DSound("sounds\\vehicle\\rev3.wav",0,0,7,100),
		Sound:Load3DSound("sounds\\vehicle\\rev4.wav",0,0,7,100),
	};
	
	self.engine_start = Sound:Load3DSound("sounds\\vehicle\\quad\\start.wav",0,185,30,150);
	self.engine_off = Sound:Load3DSound("sounds\\vehicle\\quad\\off.wav",0,185,30,150);
	self.crash_sound = Sound:Load3DSound("sounds\\vehicle\\boat\\gunboathit.wav",0,70,7,100);
	self.land_sound = Sound:Load3DSound("SOUNDS\\Vehicle\\boat\\boatsplash.wav",0,200,7,100);
	self.light_sound = Sound:Load3DSound("SOUNDS/items/flight.wav",SOUND_UNSCALABLE,160,3,30);
	--self.break_sound = Sound:Load3DSound("sounds\\vehicle\\break1.wav",0,0,7,100);
	--self.sliding_sound = Sound:Load3DSound("sounds\\vehicle\\break2.wav",0,0,7,100);

	-- init common stuff for client and server
	VC.InitBoatCommon(self);
	self.cnt:SetWeaponName("none","");
end

--////////////////////////////////////////////////////////////////////////////////////////
function Kawasaki_Ultra150_std:UpdateClientAlive(dt)

	if(self.lifeCounter < 100) then
		self.lifeCounter = self.lifeCounter + 1;
	end	

	VC.CreateWaterParticles(self);
	VC.PlayEngineOnOffSounds(self);

	-- create particles and all that 
	VC.ExecuteDamageModel(self, dt);

	-- plays the sounds, using a timestep of 0.04 		

	-- get vehicle's velocity
	local fCarSpeed = self.cnt:GetVehicleVelocity();

	self.sound_time = self.sound_time + dt;
	if ( self.sound_time > self.particles_updatefreq ) then		

		if(self.fEngineHealth<1)then
			self.particles_updatefreq=0.4;
		end

		-- reset timer
		self.sound_time = 0;

		-- average the last 4 speed frames together to smooth changes out a bit
		-- especially for water vehicles
		self.previousTimes[band(self.timecount,3)]=fCarSpeed;
		self.timecount=self.timecount+1;

		local total=0;	
		for idx, element in self.previousTimes do
			total=total+element;
		end

		if (total<=0.1) then
			total=1;
		end

		fCarSpeed=total/4.0;

				
		VC.PlayDrivingSounds(self,fCarSpeed);
	end
	
	if( self.gunnerT and self.gunnerT.entity ) then
		
		local offsDir=self.gunnerT.entity:GetDirectionVector();
		local handlerPos = self:GetHelperPos("gun",0);

		handlerPos.x = handlerPos.x + offsDir.x*.83;
		handlerPos.y = handlerPos.y + offsDir.y*.83;
		handlerPos.z = handlerPos.z + offsDir.z*.83;
		self.gunnerT.entity:SetHandsIKTarget( handlerPos );
	end	
	
	VC.UpdateUsersAnimations(self,dt);
	
	VC.PlayMiscSounds(self,fCarSpeed,dt);
end


--////////////////////////////////////////////////////////////////////////////////////////
function Kawasaki_Ultra150_std:OnContactClient( player )
	
	if( player==_localplayer and self.PropertiesInstance.bUsable==0 ) then return end	
	VC.OnContactClientT(self,player);
end


--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////
--// SERVER functions definitions
--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////

--////////////////////////////////////////////////////////////////////////////////////////
function Kawasaki_Ultra150_std:InitServer()

	VC.InitSeats(self, Kawasaki_Ultra150_std);
	-- init common stuff for client and server
	VC.InitBoatCommon(self);
	self:OnReset();
	self.cnt:SetWeaponName("none","");
end

-- called on the server when the player collides with the boat
--////////////////////////////////////////////////////////////////////////////////////////
function Kawasaki_Ultra150_std:OnContactServer( player )
	
	if( self.PropertiesInstance.bUsable==0 ) then return end
	VC.OnContactServerT(self,player);

end


--////////////////////////////////////////////////////////////////////////////////////////
function Kawasaki_Ultra150_std:UpdateServer(dt)

	VC.UpdateEnteringLeaving( self, dt );
	VC.UpdateServerCommonT( self, dt );

	if(self.cnt.inwater==1) then
		self.fGroundtime = 0;
	else	
		-- LUC eject the pilot and/or the gunner if the boat is flipping upside down
		
		
		self.fGroundtime = self.fGroundtime + dt;
		if(self.fGroundtime > 5.5) then
			AI:Signal(0, 1, "ON_GROUND", self.id);
		end	
	end
	
	
	
	
end


--////////////////////////////////////////////////////////////////////////////////////////
function Kawasaki_Ultra150_std:OnEventServer( id, params)
	if (id == ScriptEvent_PhysicalizeOnDemand) then
		self:SetPhysicParams( PHYSICPARAM_FLAGS, {flags_mask=pef_pushable_by_players, flags=0} );
	end
end

--////////////////////////////////////////////////////////////////////////////////////////
function Kawasaki_Ultra150_std:OnShutDown()
	VC.EveryoneOutForce(self);
	VC.RemovePieces(self);
end

--////////////////////////////////////////////////////////////////////////////////////////
function Kawasaki_Ultra150_std:OnSave(stm)
	stm:WriteInt(self.fEngineHealth);
end

--////////////////////////////////////////////////////////////////////////////////////////
function Kawasaki_Ultra150_std:OnLoad(stm)
	self.fEngineHealth = stm:ReadInt();
end


--////////////////////////////////////////////////////////////////////////////////////////
function Kawasaki_Ultra150_std:OnWrite( stm )
	
end

--////////////////////////////////////////////////////////////////////////////////////////
function Kawasaki_Ultra150_std:OnRead( stm )

end

--////////////////////////////////////////////////////////////////////////////////////////

----------------------------------------------------------------------------------------------------------------------------
--
--	to test-call reinf
function Kawasaki_Ultra150_std:Event_Reinforcment( params )

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in
--printf( "signaling BRING_REINFORCMENT " );	

	VC.AIDriver( self, 1 );	
	AI:Signal(0, 1, "BRING_REINFORCMENT", self.id);
	
end	


----------------------------------------------------------------------------------------------------------------------------
--
function Kawasaki_Ultra150_std:Event_GoPath( params )

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in
--System:Log("\001  Humvee GoPath  ");

	self.curPathStep = self.Properties.pathstart-1;
	VC.AIDriver( self, 1 );	
	AI:Signal(0, 1, "GO_PATH", self.id);

end


----------------------------------------------------------------------------------------------------------------------------
--
-- to test
function Kawasaki_Ultra150_std:Event_StopAttack( params )

--System:Log("\001  Event_StopAttack  ");
	self.curPathStep = self.Properties.pathstart-1;
	AI:Signal(0, 1, "PLAYER_LEFT_VEHICLE", self.id);

end



----------------------------------------------------------------------------------------------------------------------------
--
function Kawasaki_Ultra150_std:Event_GoPatrol( params )

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in
	self.curPathStep = self.Properties.pathstart-1;
	VC.AIDriver( self, 1 );	
	AI:Signal(0, 1, "GO_PATROL", self.id);

end



----------------------------------------------------------------------------------------------------------------------------
--
function Kawasaki_Ultra150_std:Event_GoAttack( params )

--System:Log("\001  Humvee GoPath  ");

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

	VC.AIDriver( self, 1 );	
	AI:Signal(0, 1, "GO_ATTACK", self.id);

end

----------------------------------------------------------------------------------------------------------------------------
--
-- to test
function Kawasaki_Ultra150_std:Event_Load( params )

--	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

--	VC.AIDriver( self, 1 );	
	self:LoadPeople();

end


----------------------------------------------------------------------------------------------------------------------------
--
-- to test
function Kawasaki_Ultra150_std:Event_Release( params )

	VC.AIDriver( self, 1 );	
	self:UnloadPeople();

end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Kawasaki_Ultra150_std:RadioChatter()
end

----------------------------------------------------------------------------------------------------------------------------
--
--

----------------------------------------------------------------------------------------------------------------------------
--
-- 
function Kawasaki_Ultra150_std:Event_KillTriger( params )


	if (self.driverT.entity and _localplayer) then 
		if (self.driverT.entity ~= _localplayer) then 
			self.cnt:SetVehicleEngineHealth(0);
			self:GotoState( "Dead" );
		end
	else
		self.cnt:SetVehicleEngineHealth(0);
		self:GotoState( "Dead" );
	end
	
--	self.fEngineHealth = 0;
--	VC.OnDamageServer(self,hit);	

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function Kawasaki_Ultra150_std:LoadPeople()

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

System:Log("Kawasaki_Ultra150_std LoadPeople  ");

	if(self.driverT.entity and self.driverT.entity.ai) then
System:Log("Kawasaki_Ultra150_std LoadPeople  +++++ DRIVER IS IN ");
		AI:Signal(0, 1, "DRIVER_IN", self.id);
	end	

	if( self.Properties.bSameGroupId == 1 ) then
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "wakeup", self.id);	
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "SHARED_ENTER_ME_VEHICLE", self.id);
	else
		AI:Signal(SIGNALFILTER_ANYONEINCOMM, 1, "wakeup", self.id);	
		AI:Signal(SIGNALFILTER_ANYONEINCOMM, 1, "SHARED_ENTER_ME_VEHICLE", self.id);
	end

	
--	AI:Signal(SIGNALFILTER_GROUPONLY, 1, "wakeup", self.id);
--	AI:Signal(SIGNALFILTER_GROUPONLY, 1, "SHARED_ENTER_ME_VEHICLE", self.id);
	self.dropState = 1;
	
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Kawasaki_Ultra150_std:UnloadPeople()

	VC.DropPeople( self ,1);
--	VC.ReleaseGunner(self);	--, 1);
--	VC.ReleaseDriver(self);	--, 1);
	
--	self:RemoveAIGunner( );	
--	self:DriverOut( );
	
end

-------------------------------------------------------------------------------------------------------------
--
--
function Kawasaki_Ultra150_std:InitEntering( puppet, enterTable, destPos )

	local dir = DifferenceVectors( destPos, puppet:GetPos() );
	local dist = sqrt(LengthSqVector(dir));
	local angl = self:GetAngles(); 
	
	ConvertVectorToCameraAngles(angl, dir);
	puppet:SetAngles( angl );

	enterTable.Time = dist/self.entVel;
	enterTable.HT = enterTable.Time*.5;
	enterTable.HK = dir.z/enterTable.Time;
	enterTable.HO = puppet:GetPos().z;
	enterTable.HS = 10/enterTable.Time;
		
	puppet:ActivatePhysics(0);

	puppet.cnt.AnimationSystemEnabled = 0;
	enterTable.TimePast = 0;
	puppet:StartAnimation(0,"jump_air");		-- to have this as previous animation
	puppet:StartAnimation(0,"jump_start");

end


-------------------------------------------------------------------------------------------------------------
--
--
function Kawasaki_Ultra150_std:DoEnter( puppet )

	if( puppet == self.driverT.entity ) then		-- driver
		VC.AddUserT( self, self.driverT );
		VC.InitEnteringJump( self, self.driverT );
--	elseif( puppet == self.gunnerT.entity ) then		-- gunner
--		VC.AddUserT( self, self.gunnerT );
--		VC.InitEnteringJump( self, self.gunnerT );
	end
end


-------------------------------------------------------------------------------------------------------------
--
--
function Kawasaki_Ultra150_std:AddDriver( puppet )

	if (self.driverT.entity ~= nil)		then	-- already have a driver
		do return 0 end
	end

	if(self.Properties.sDriverName ~= "" and self.Properties.sDriverName ~= puppet:GetName()) then return 0 end
	
	self.driverT.entity = puppet;
	if( VC.InitApproach( self, self.driverT )==0 ) then	
		self:DoEnter( puppet );
	end	
	do return 1 end	
end

-------------------------------------------------------------------------------------------------------------
--
--
function Kawasaki_Ultra150_std:AddGunner( puppet )
	return 0	
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Kawasaki_Ultra150_std:AddPassenger( player )
	return 0
end




----------------------------------------------------------------------------------------------------------------------------
--

function Kawasaki_Ultra150_std:Event_AddPlayer( params )

	if(_localplayer.theVehicle) then return end	-- this player is already in some (this) vehicle
	
	local theTable = VC.GetAvailablePosition(self);
	
	if(theTable == nil) then return end

	_localplayer.cnt.use_pressed = nil;
	theTable.entity = _localplayer;
	VC.AddUserT(self, theTable);	
	

	
end	


--////////////////////////////////////////////////////////////////////////////////////////



----------------------------------------------------------------------------------------------------------------------------
--
-- to test
function Kawasaki_Ultra150_std:Event_TArgetOnLand( params )

	AI:Signal(0, 1, "PLAYER_LEFT_VEHICLE", self.id);

end

----------------------------------------------------------------------------------------------------------------------------
--
-- to test
--function Kawasaki_Ultra150_std:Event_GunnerOut( params )
--
--	AI:Signal(0, 1, "GUNNER_OUT", self.id);
--
--end


----------------------------------------------------------------------------------------------------------------------------
--
function Kawasaki_Ultra150_std:Event_DriverIn( params )

	BroadcastEvent( self,"DriverIn" );
	
end	


------------------------------------------------------
function Kawasaki_Ultra150_std:Event_Unhide()

	self:Hide(0);

end


------------------------------------------------------
function Kawasaki_Ultra150_std:Event_Hide()

	self:Hide(1);

end

function Kawasaki_Ultra150_std:Event_Activate( params )
	if(self.bExploded == 1) then return end	
	self:GotoState( "Alive" );
end

-- empty function to get reed of script error - it's called from behavours
function Kawasaki_Ultra150_std:MakeAlerted()
end

function Kawasaki_Ultra150_std:CreateParticles()

	local EngineSpray=  {
				particle_type = 0,
				focus = 100,
				start_color = {1,1,1},
				end_color = {0,0,1}, 
				gravity = { x = 0.0, y = 0.0, z = -4.0 },
				rotation = { x = 0.0, y = 0.0, z = 0.0 },
				speed = 5,
				count = 1,
				size = 0.10, 
				size_speed = 0,
				lifetime = 3,
				tid = System:LoadTexture("Textures/water_splash3.dds"),
				frames = 0,
				blend_type = 0,
				tail_length = 0.0,--.55,
				turbulence_size = 0,
				turbulence_speed = 0,
				bouncyness = 0.0,
				--stretch = 0,
				--SpeedVar = 0,
				--not_underwater = 1,
				--bLinearSizeSpeed = 0,
			};

	local BowSpray=  {
				particle_type = 0,
				focus = 8,
				start_color = {1,1,1},
				end_color = {1,1,1}, 
				gravity = { x = 0.0, y = 0.0, z = -8.0 },
				rotation = { x = 0.0, y = 0.0, z = 0.0 },
				speed = 10,
				count = 1,
				size = 0.1, 
				size_speed = 1.25,
				lifetime = 1.0,
				tid = System:LoadTexture("Textures/water_splash3.dds"),
				frames = 0,
				blend_type = 0,
				tail_length = 0.00,--.55,
				turbulence_size = 0,
				turbulence_speed = 0,
				bouncyness = 0.0,
			};

	local pos_eng = self:GetHelperPos("part_eng");	
	local pos_bowleft = self:GetHelperPos("part_bowleft");	
	local pos_bowright = self:GetHelperPos("part_bowright");	
	--local pos_eng = self:GetPos();	
	--local pos_bowleft = self:GetPos();	
	--local pos_bowright = self:GetPos();	
	
	local dir_eng = new(self:GetDirectionVector());
	local dir_bow1 = new(self:GetDirectionVector(1));
	local dir_bow2 = new(self:GetDirectionVector(1));
	dir_eng.z = 2;
	dir_bow1.z = 0.25;
	dir_bow2.z = 0.25;
	
	local ang = -25;
	self:RotateVectorXY( dir_bow1, ang );
	self:RotateVectorXY( dir_bow2, 180-ang );
	
	local speed = self.cnt:GetVehicleVelocity();
	EngineSpray.speed = speed + 2;
	if ( speed > 3 ) then
		BowSpray.speed = speed;
		Particle:CreateParticle(pos_bowleft,dir_bow1,BowSpray);
		Particle:CreateParticle(pos_bowright,dir_bow2,BowSpray);
	end
	
	Particle:CreateParticle(pos_eng,dir_eng,EngineSpray);
	--Particle:SpawnEffect(pos,dir,"MyPart.Particle",1);
	--self:CreateParticleEmitter(WaterSpray,5);
	--self:CreateParticleEmitterEffect(0,WaterSpray,5,pos,dir,1);



end


function Kawasaki_Ultra150_std:RotateVectorXY( vector, angle )
	local degrees = acos(vector.x) / PI * 180;
	if ( vector.y < 0 ) then
		degrees = 360 - degrees;
	end
	degrees = 360 - degrees;
	
	degrees = degrees + angle;
	if ( degrees > 360 ) then degrees = degrees - 360; end
	if ( degrees < 0 ) then degrees = degrees + 360; end

	degrees = degrees / 180 * PI;
	vector.x = cos( degrees );
	vector.y = -sin( degrees );
	--Hud:AddMessage( ang, 5 );
end