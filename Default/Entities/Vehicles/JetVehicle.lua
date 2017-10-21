-- JET VEHICLE
-- GENERIC AIRCRAFT SCRIPT SP v1.2
-- BY SNIPER_M4 AND SHINING AND TNLGG AND MIXER AND GARBITOS

JetVehicle = {
	IsBoat = 1,
	waterDepth = 1,
	part_time = 0,
	DamageParams = {
		fDmgScaleAIBullet = 0.18,
		fDmgScaleAIExplosion = 0.12,
		fDmgScaleBullet = 0.18,
		fDmgScaleExplosion = 0.19,
		--dmgBulletMP = 1.0,
	},
	fPartUpdateTime = 0,
	fGroundtime = 0,
	dWeapon = 0,
	tpvStateD = 0,
	
	rotorSpeed = 0,  --pvcf
	rotorSpeedMax = 1600, --pvcf
	rotorSpeedUp = 17,	 --pvcf

	entVel = 9,
	userCounter = 0,
	driverWaiting = 1,
	driverDelay = 0,
	passengerLimit = 0,
	curPathStep = 0,
	bDriverInTheVehicle = 0,
	pPreviousDriver=nil,
	bPassengerInTheVehicle = 0,
	pPreviousPassenger=nil,
	IsPhisicalized = 0,

	Damage1Effect = "smoke.vehicle_damage1.a",
	Damage2Effect = "smoke.vehicle_damage2.a",
	ExplosionEffect = "explosions.4WD_explosion.a",
	DeadEffect = "fire.burning_after_explosion.a",
	DeadMaterial = "Vehicles.Gunboat_Screwed",

	PropertiesInstance = {
		sightrange = 220,
		soundrange = 10,
		groupid = 154,
		bUsable = 1,
	},


	Properties = {

		fNUMofRockets = 20,
		fNUMofMGRounds = 800,
		bActive = 1,
		damage_players = 1,
		bLightsOn = 0,

		fAISoundRadius = 30,
		fCeilingHeight = 300,
		AttackParams = {
			sightrange = 220,
			horizontal_fov = -1,
		},

		RocketHUD = {
			fX = 134, fY = 518,
		},

		GunnerParams = {
			responsiveness = 50,
			sightrange = 150,
			attackrange = 350,
			horizontal_fov = 120,
			bDumbRockets = 0,
			fRocketSpeed = 55,
		},

		bSameGroupId = 1,
		bTrackable=0,
		fJet_C_Speed = 1000,
		fJet_C_FlipForce = 40,
		fJet_C_Mass = 100,
		fJet_C_UpDownForce = 50,
		fJet_C_PushUpForce = 4400,
		fileJet_P_Model = "Objects/vehicles/SingleSeatHelicopter/seatheli_pvcf_drivable.cgf",
		fileJet_P_Dead = "Objects/vehicles/SingleSeatHelicopter/seatheli_pvcf_destroyed.cgf",
		sJet_P_GunName = "MG",
		fStartDelay = 2,
		bDrawDriver = 0,
		damping = 0.1,
		fLimitLRAngles = 150,
		fLimitUDMinAngles = -45,
		fLimitUDMaxAngles = 40,
		ExhaustHelper1 = "engine_left",
		ExhaustHelper2 = "",
		ExhaustParticle = "",
		sRLauncherLeft = "rlauncher",
		sRLauncherRight = "",
		sndEngineLoop = "objects/vehicles/police_heli/rotor_loop.wav",
		ExplosionParams = {
			nDamage = 900,
			fRadiusMin = 8.0, -- default 12
			fRadiusMax = 10, -- default 35.5
			fRadius = 10, -- default 17
			fImpulsivePressure = 200, -- default 200
		},

		pointReinforce = "Drop",
		pointBackOff = "Base",
		aggression = 1.0,
		commrange = 100.0,
		cohesion = 5,
		attackrange = 70,
		horizontal_fov = -1,
		vertical_fov =90,
		eye_height = 2.1,
		accuracy = 0.6,
		responsiveness = 7,
		species = 1,
		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,
		pathname = "",
		pathsteps = 0,
		pathstart = 0,
		forward_speed = 1,	-- don't scale down fwd impuls - max speed
		bUsePathfind = 0,	-- pathfind when outdoors
	},

	boat_params={
		Damprot	 	= 1000,	--turning dump
		Dampv		= 20,	--movement dump
		Dampvs		= 100,	--
		Dampvh		= 100,	--
		Dampw		= 40,	--waves dump
		Turn		= 1600,   --30,
		TurnMin		= 600,	--7000
		TurnVelScale	= 6,
		Speedturnmin	= 0,
		WaveM		= 500, --fake waves momentum 500
		TiltSpdA	= 0.03,	--tilt momentum when speeding up (acceleration thrhld) 0.06
		TiltSpdMinV	= 3, --10.0,	--tilt momentum when speeding up (min speed to tilt when not accelerating)10.0
		TiltSpdMinVTilt	= 15, --30.37,	--tilt momentum when speeding up (how much to tilt when not accelerating)0.37		
		DownRate 	= 240,
		BackUpRate 	= 1800, -- was 450
		BackUpSlowDwnRate = 0,
		UpSpeedThrhld 	= 1,
		Flying		= 1,
		gravity		= -2.4,--gravity , used when the boat is jumping
		Stand		= 100,	-- forsing to normal vertical position impuls
		StandInAir	= 4000,	-- forsing to normal vertical position impuls, when in air.
		CameraDist	= 8.5,
		Speedv = 0,
		--TiltTurn = self.Properties.fJet_C_FlipForce * 0.05,
		--TiltSpd = self.Properties.fJet_C_UpDownForce * 0.25,
		--fMass = self.Properties.fJet_C_Mass * 0.25,
	},

	sound_time = 0,
	particles_updatefreq = 0.24, --initial frequency of updating particles
	partDmg_time = 0,

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
	fOnCollideDamage=0.75,
	-- damage inflicted to the vehicle when it collides with terrain (falls off)
	fOnCollideGroundDamage=5.5,
	
	--damage when colliding with another vehicle, this value is multiplied by the hit.impact value.
	fOnCollideVehicleDamage=6.5,


	bGroundVehicle=0,

	-- to smooth speed changes
	timecount=0,
	previousTimes={},

	driverT = {
		type = PVS_DRIVER,
	
		helper = "driver",
		in_helper = "driver_sit_pos",
		sit_anim = "humvee_driver_sit",
		anchor = AIAnchor.AIANCHOR_BOATENTER_SPOT,
		out_ang = -90,
		message = "Press USE to drive this Jet",
		timePast=0,
		HS=0,	-- used for fake jump arch calculatio - arch scale
		HK=0,	-- used for fake jump arch calculatio
		HO=0,	-- used for fake jump arch calculatio	
		HT=0,	-- used for fake jump arch calculatio
		
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

	--seats
	gunnerT = {
		type = PVS_GUNNER,
	
		helper = "gunner",
		in_helper = "gunner_sit_pos",
		sit_anim = "gunboat_gunner_sit",
		anchor = AIAnchor.AIANCHOR_BOATENTER_SPOT,
		out_ang = -90,
		message = "@gunnerboat",
		timePast=0,
		HS=0,	-- used for fake jump arch calculatio - arch scale
		HK=0,	-- used for fake jump arch calculatio
		HO=0,	-- used for fake jump arch calculatio	
		HT=0,	-- used for fake jump arch calculatio
	},
	
	--canbepushed, if player is in contact with some entity and he is pressing use, its checked this function.
	--can return 3 kind of values:
	--	- nil if the entity cant be pushed
	--	- -1 or 0 if the push force to be used is the player standard
	--	- a different value means a custom push force
	CanBePushed = VC.CanBePushed,
	
	pushpower = 7000,
}

VC.CreateVehicle(JetVehicle);

--
function JetVehicle:OnReset()
	VC.OnResetCommon(self);
	self.pwnperiod = _time;
	self.fEngineHealth = 100.0;

	self:NetPresent(1);

	VC.EveryoneOutForce(self);

	self.bExploded=false;
	self.cnt:SetVehicleEngineHealth(self.fEngineHealth);
	self.ammoRL = self.Properties.fNUMofRockets;
	--AI stuff
	AI:RegisterWithAI(self.id, AIOBJECT_BOAT,self.Properties,self.PropertiesInstance);

	if self.Properties.ExhaustParticle ~= "" then
	self.hasexhauster = 1; end

if (self.Properties.fNUMofRockets > 0) then
	self.nextlaunchtime = 0;
	--if (Game:IsMultiplayer()) then
	--	self.rkt_type = "Rocket";
	--else
	self.rkt_type = "MutantRocket";
	--end
end

	VC.AIDriver( self, 0 );	

	self.curPathStep = 0;

	self.fPartUpdateTime = 0;
	self.fGroundtime = 0;

	-- Put physics asleep.
	self:AwakePhysics(0);
	self:SetShaderFloat( "Speed", 0, 1, 1);

	self.cnt:InitLights( "front_light","textures/lights/front_light",
			"front_light_left","front_light_right","humvee_frontlight",
			"back_light_left", "back_light_right","" );

end

function JetVehicle:ExhaustEngineGas()
local pos1;
if (self.second_exhaust) then
pos1 = self:GetHelperPos(self.Properties.ExhaustHelper1,0);
self.second_exhaust = nil; else
pos1 = self:GetHelperPos(self.Properties.ExhaustHelper2,0);
self.second_exhaust = 1; end
local dir = self:GetDirectionVector();
dir.x = dir.x * -1;
dir.y = dir.y * -1;
dir.z = dir.z * -1;
Particle:SpawnEffect(pos1,dir,self.Properties.ExhaustParticle);
end

JetVehicle.Client = {
	OnInit = function(self)
		self:InitClient();
	end,
	OnShutDown = function(self)
		self:OnShutDown();
	end,
	Alive = {
		OnBeginState = function( self )	
			if (self.driverT.entity == nil) then
				VC.InitBoatCommon(self);
			end
			if (not Game:IsServer()) then
				self:Go2normmode();
				--Hud:AddMessage("client norm mode");
			end
		end,
		OnContact = function(self,player)
	 		self:OnContactClient(player);
		end,
		OnUpdate = function(self,dt)
	 		self:UpdateClientAlive(dt);
		end,
		
		OnCollide = function(self,hit)
			if (hit) and (self.driverT.entity) and (self.driverT.entity.cnt) and (self.driverT.entity.cnt.weapon) then
				if (hit.fSpeed and hit.fSpeed>20) or (hit.impactVert and hit.impactVert>4) or (hit.impact and hit.impact>2) then
					if (not Sound:IsPlaying(self.crash_sound)) then
						self.driverT.entity.cnt.weapon:StartAnimation(0, "fire11",0,0);
					end
				end
			end
			VC.OnCollideClient(self,hit);
		end,

		OnBind = VC.OnBind,
		OnUnBind = VC.OnUnBind,
	},

	VMode = {
		OnBeginState = function( self )
			if (not Game:IsServer()) then
				self:Go2vertmode();
				--Hud:AddMessage("client vmode");
			end
		end,
		OnContact = function(self,player)
	 		self:OnContactClient(player);
		end,
		OnUpdate = function(self,dt)
	 		self:UpdateClientAlive(dt);
		end,
		OnCollide = function(self,hit)
			if (hit) and (self.driverT.entity) and (self.driverT.entity.cnt) and (self.driverT.entity.cnt.weapon) then
				if (hit.fSpeed and hit.fSpeed>20) or (hit.impactVert and hit.impactVert>4) or (hit.impact and hit.impact>2) then
					if (not Sound:IsPlaying(self.crash_sound)) then
						self.driverT.entity.cnt.weapon:StartAnimation(0, "fire11",0,0);
					end
				end
			end
			VC.OnCollideClient(self,hit);
		end,
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
			self.IsBoat = 1;
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
JetVehicle.Server = {
	OnInit = function(self)
		self:InitServer();
	end,
	OnShutDown = function(self)
		self:OnShutDown();
	end,
	Alive = {
		OnBeginState = function( self )
			if (self.driverT.entity == nil) then
				VC.InitBoatCommon(self);
			end
			self:Go2normmode();
			--Hud:AddMessage("server norm mode");
		end,
		OnContact = function(self,player)
			if (player.POTSHOTS) then
				-- Mixer: dirty hack to prevent bots from trying to fly :)
				player.vb_lastvehicletme = _time + 1;
			end
	 		self:OnContactServer(player);
		end,
		OnDamage = VC.OnDamageServer,
		OnCollide = VC.OnCollideServer,
		OnUpdate = function(self,dt)
			self:UpdateServer(dt);
			-- insert func to launch rocket with zoom button (client-to-server receiver)
			if (GameRules.ClientCommandTable) and (not GameRules.ClientCommandTable.RK2G) then
				GameRules.ClientCommandTable["RK2G"]=function(String,server_slot,toktable)
					local vleader = System:GetEntity(server_slot:GetPlayerId());
					if (vleader) and (vleader.theVehicle) then
						vleader.theVehicle.rocket2go = 1;
					end
				end
			end
		end,
		OnEvent = function (self, id, params)
			self:OnEventServer( id, params);
		end,
	},
	VMode = {
		OnBeginState = function( self )	
			self:Go2vertmode();
			--Hud:AddMessage("server vert mode");
		end,
		OnContact = function(self,player)
	 		self:OnContactServer(player);
		end,
		OnDamage = VC.OnDamageServer,
		OnCollide = VC.OnCollideServer,
		OnUpdate = function(self,dt)
			self:UpdateServer(dt);
			-- launch rocket with zoom button (client-to-server receiver)
			if (GameRules.ClientCommandTable) and (not GameRules.ClientCommandTable.RK2G) then
				GameRules.ClientCommandTable["RK2G"]=function(String,server_slot,toktable)
					local vleader = System:GetEntity(server_slot:GetPlayerId());
					if (vleader) and (vleader.theVehicle) then
						vleader.theVehicle.rocket2go = 1;
					end
				end
			end
			--if (not AIBehaviour.DEFAULT.PWN_ME) then
			--	AIBehaviour.DEFAULT.PWN_ME = function (self, entity, sender)
			---		if (not sender) and (_localplayer) then
			--			sender = _localplayer;
			--		end
			--		if (sender) and (not entity.theVehicle) and (entity.Properties.species ~= sender.Properties.species) then
			--			entity:InsertSubpipe(0,"practice_shot",sender.id);
			--		end
			--	end;
			--end
			-----------------
		end,
		OnEvent = function (self, id, params)
			self:OnEventServer( id, params);
		end,
	},
	Inactive = {
	},
	Dead = {
		OnBeginState = function( self )
			self.fullpow = nil;
			self.speedup_timer = nil;
			VC.BlowUpServer(self);
			self.IsBoat = 1;
		end,
		OnContact = function(self,player)
	 		VC.OnContactServerDead(self,player);
		end,
	},
}

function JetVehicle:InitClient()
	JetVehicle.InitCommonAircraft(self);
	if (self.Properties.RocketHUD.fY == 518) then
		-- Mixer: quick hack for old map versions,
		-- to reflect hud jetvehicle icon changes
		self.Properties.RocketHUD.fY = 536;
	end
	VC.InitSeats(self, JetVehicle);
	self:RegisterState("VMode");
	self.ExplosionSound=Sound:Load3DSound("sounds\\explosions\\oicw.wav",0,255,150,300);
	if (self.Properties.sndEngineLoop) and (self.Properties.sndEngineLoop~="") then
		self.drive_sound = Sound:Load3DSound(self.Properties.sndEngineLoop,0,255,20,400);
		if (Game:IsMultiplayer()) then
			self.rotorSpeedUp = 120;
		end
	else
		self.drive_sound = Sound:Load3DSound("Sounds\\building\\factory2.wav",0,185,30,150);
		self.rotorSpeedUp = 200;
	end
	self.drive_sound_move = Sound:Load3DSound("Sounds\\building\\highchurn.wav",0,35,10,150);
	self.maxvolume_speed = 25;

	self.accelerate_sound = {
		Sound:Load3DSound("sounds\\vehicle\\rev1.wav",0,0,7,100),
		Sound:Load3DSound("sounds\\vehicle\\rev2.wav",0,0,7,100),
		Sound:Load3DSound("sounds\\vehicle\\rev3.wav",0,0,7,100),
		Sound:Load3DSound("sounds\\vehicle\\rev4.wav",0,0,7,100),
	};
	
	self.engine_start = Sound:Load3DSound("SOUNDS/items/flight.wav",0,185,30,150);
	self.engine_off = Sound:Load3DSound("Sounds\\building\\highchurn.wav",0,185,30,150);
	self.crash_sound = Sound:Load3DSound("sounds\\vehicle\\boat\\gunboathit.wav",0,70,7,100);
	self.land_sound = Sound:Load3DSound("SOUNDS\\Vehicle\\boat\\boatsplash.wav",0,200,7,100);
	self.light_sound = Sound:Load3DSound("SOUNDS/items/flight.wav",SOUND_UNSCALABLE,160,3,30);

	-- init common stuff for client and server
	VC.InitBoatCommon(self);
	self:InitWeapon();
	------------------
	if (self.Properties.fNUMofRockets > 0) then
		self.rlaunchersnd = Sound:Load3DSound("Sounds/Weapons/OICW/oicwMortar1.WAV",SOUND_OUTDOOR + SOUND_RADIUS,255,8,1000);
	end
end
---
function JetVehicle:InitCommonAircraft()
self.szNormalModel= self.Properties.fileJet_P_Model;
self.fileModelDead = self.Properties.fileJet_P_Dead;
self.boat_params.Speedv = 0;
self.boat_params.fMass = self.Properties.fJet_C_Mass;
if (Game:IsMultiplayer()) then
	self.boat_params.TiltTurn = self.Properties.fJet_C_FlipForce * 0;
else
	self.boat_params.TiltTurn = self.Properties.fJet_C_FlipForce * 1;
end
self.boat_params.TiltSpd = self.Properties.fJet_C_UpDownForce;
self.boat_paramsAI=self.boat_params;
--self.boat_paramsAI.Turn = 240;
self.ammoMG = self.Properties.fNUMofMGRounds * 1;
self.ammoRL = self.Properties.fNUMofRockets * 1;
self.PropertiesInstance.aibehavior_behaviour = "Boat_idle";
self.Properties.bSetInvestigate = 0;
self.Properties.bLandOnPlayerLand=0;
self.Properties.aicharacter_character = "BoatGun";
self.Properties.bodypos = 0;
self.Properties.water_damping = 0;
self.Properties.water_sleep_speed = 0.015;
self.Properties.water_resistance = 1000;
self.Properties.max_health = 100;
end
---

function JetVehicle:OnRemoteEffect(toktable, pos, normal, userbyte)
	self.ammoRL = tonumber(pos.x);
end

-------------
function JetVehicle:UpdateClientAlive(dt)

if(self.lifeCounter < 100) then
self.lifeCounter = self.lifeCounter + 1;
end

if (_localplayer) and (_localplayer.theVehicle) then
	if (_localplayer.theVehicle == self) and (Hud) then
		if (self.ammoRL > 0) and (not Hud.cis_gfxmsg) then
			Hud:DrawElement(self.Properties.RocketHUD.fX,self.Properties.RocketHUD.fY,Hud.wicons["rocket"]);
			Hud:DrawNumber(1,3,self.Properties.RocketHUD.fX+19,self.Properties.RocketHUD.fY+4,self.ammoRL);
		end
		local Binding = Input:GetBinding("default", 45); -- get zoom toggle key
		if (Binding[1]) and (Binding[1].key) then
			if (Input:GetXKeyPressedName() == Binding[1].key) then
				-- rkt go
				if (Game:IsMultiplayer()) then
					Client:SendCommand("RK2G");
				else
					_localplayer.theVehicle.rocket2go = 1;
				end
			end
		end
	end
end


--	VC.CreateWaterParticles(self);
	VC.PlayEngineOnOffSounds(self);

	-- create particles and all that 
	VC.ExecuteDamageModel(self, dt);

	-- plays the sounds, using a timestep of 0.04

	-- get vehicle's velocity
	local fCarSpeed = self.cnt:GetVehicleVelocity();

	self.sound_time = self.sound_time + dt;
	if ( self.sound_time > self.particles_updatefreq ) then		

		if (self.fEngineHealth<1) then
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

		if (self.rotorSpeed >= self.rotorSpeedMax ) then
			VC.PlayDrivingSounds(self,fCarSpeed);
		elseif (self.rotorSpeed > 0) and (self.rotorSpeedMax>0) then
			Sound:SetSoundFrequency( self.drive_sound, (self.rotorSpeed/self.rotorSpeedMax)*1000);
			Sound:SetSoundPosition(self.drive_sound,self:GetPos());
			if (Sound:IsPlaying(self.drive_sound) ~=1) then
				Sound:SetSoundLoop(self.drive_sound,1);
				self:PlaySound(self.drive_sound);
			end
		end
		
		--------------------------------------------
		if (self.driverT.entity) then
			if (self.hasexhauster) then
				self:ExhaustEngineGas();
			end

			if (self.rotorSpeed < self.rotorSpeedMax ) then
				self.rotorSpeed = self.rotorSpeed + self.rotorSpeedUp;
				if (self.rotorSpeed > self.rotorSpeedMax ) then
					self.rotorSpeed = self.rotorSpeedMax*1;
				end
				self:SetShaderFloat( "Speed", self.rotorSpeed, 1, 1);
			end
		else
			if (self.rotorSpeed > 0 ) then
				self.rotorSpeed = self.rotorSpeed - self.rotorSpeedUp;
				if (self.rotorSpeed <= 0 ) then
					self.rotorSpeed = 0;
					--if (Sound:IsPlaying(self.drive_sound) ==1) then
					--	self:StopSound(self.drive_sound);
					--end
				end
				self:SetShaderFloat( "Speed", self.rotorSpeed, 1, 1);
				---------
			end
		end
		----------------------------------------------------------
	end
	
	if ( self.gunnerT and self.gunnerT.entity ) then

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

function JetVehicle:OnContactClient( player )
	if( player==_localplayer and self.PropertiesInstance.bUsable==0 ) then return end	
	VC.OnContactClientT(self,player);
end

function JetVehicle:Go2normmode()
	-- vertical mode actually since inverted
	self.boat_params.Damprot = 1000; --stabilize etc.
	self.boat_params.Dampv	= 20; --vertical moves
	self.boat_params.Dampw	= 40; --forward moves
	self.boat_params.Turn = 1600;
	self.boat_params.Stand = 100;
	self.boat_params.StandInAir	= 4000;
	self.boat_params.DownRate = 240;
	self.boat_params.BackUpRate = 1800;
	self.boat_params.gravity = -2.4;
	self.boat_params.Speedv = self.Properties.fJet_C_Speed * 0.01 * floor(self.rotorSpeed/self.rotorSpeedMax);
	if (Game:IsMultiplayer()) then
		self.boat_params.TiltTurn = self.Properties.fJet_C_FlipForce * 0;
	else
		self.boat_params.TiltTurn = self.Properties.fJet_C_FlipForce * 0.05;
	end
	self.boat_params.TiltSpd = self.Properties.fJet_C_UpDownForce * 0.25;
	self.boat_params.fMass = self.Properties.fJet_C_Mass * 0.25;
	self.cnt:SetWaterVehicleParameters(self.boat_params);
end

function JetVehicle:Go2vertmode()
	--EXTENDED stability & siege mode (better aiming)
	self.boat_params.Damprot	= 2500;
	self.boat_params.Dampv	= 60;
	self.boat_params.Dampw	= 5;
	self.boat_params.Turn	= 800;
	self.boat_params.Stand = 50;
	self.boat_params.StandInAir	= 2000;
	self.boat_params.DownRate = 0;
	self.boat_params.BackUpRate = 900;
	self.boat_params.gravity = -4.2;
	self.boat_params.Speedv = self.Properties.fJet_C_Speed * floor(self.rotorSpeed/self.rotorSpeedMax);
	if (Game:IsMultiplayer()) then
		self.boat_params.TiltTurn = self.Properties.fJet_C_FlipForce * 0;
	else
		self.boat_params.TiltTurn = self.Properties.fJet_C_FlipForce * 1;
	end
	self.boat_params.TiltSpd = self.Properties.fJet_C_UpDownForce * 1;
	self.boat_params.fMass = self.Properties.fJet_C_Mass * 1;
	self.cnt:SetWaterVehicleParameters(self.boat_params);
end

function JetVehicle:InitServer()
	JetVehicle.InitCommonAircraft(self);
	VC.InitSeats(self, JetVehicle);
	self:RegisterState("VMode");
	VC.InitBoatCommon(self);
	self:OnReset();
	if (self.Properties.sndEngineLoop) and (self.Properties.sndEngineLoop~="") then
		if (Game:IsMultiplayer()) then
			self.rotorSpeedUp = 120;
		end
	else
		self.rotorSpeedUp = 200;
	end
	self:InitWeapon();
end

-- called on the server when the player collides with the boat
--
function JetVehicle:OnContactServer( player )
	
	if( self.PropertiesInstance.bUsable==0 ) then return end
	VC.OnContactServerT(self,player);
end
--
function JetVehicle:UpdateServer(dt)
	self.cnt.inwater=1;



	--local dhhh = self:GetDirectionVector();
	--Hud:AddMessage("x= "..dhhh.x.." y= "..dhhh.y.." z= "..dhhh.z);
	--- IF Z > -0.2
	
	if (Game:IsClient()==nil) then
		self.sound_time = self.sound_time + dt;
		if ( self.sound_time > self.particles_updatefreq ) then
			if (self.fEngineHealth<1) then
				self.particles_updatefreq=0.4;
			end
			self.sound_time = 0;
			--------------------------------------------
			if (self.driverT.entity) then
				if (self.rotorSpeed < self.rotorSpeedMax ) then
					self.rotorSpeed = self.rotorSpeed + self.rotorSpeedUp;
					if (self.rotorSpeed > self.rotorSpeedMax ) then
						self.rotorSpeed = self.rotorSpeedMax*1;
					end
				end
			else
				if (self.rotorSpeed > 0 ) then
					self.rotorSpeed = self.rotorSpeed - self.rotorSpeedUp;
					if (self.rotorSpeed <= 0 ) then
						self.rotorSpeed = 0;
					end
				end
			end
			----------------------------------------------------------
		end
	end



VC.UpdateEnteringLeaving( self, dt );

if ( self.driverT.entity ) then
self.flipTime = 0;
local pos = self:GetPos();

----JetVehicle.TryToLaunchRocket(self,pos);
------------------------------------------------------------------------------------------------
if (self.rocket2go) then
	self.rocket2go = nil;
	if (not self.launch_on_demand) then
		if (self.gunnerT.entity) and (self.gunnerT.entity.ai) then
			local target_dist = AI:GetAttentionTargetOf(self.gunnerT.entity.id);
			if (target_dist) and (type(target_dist)=="table") then
				if (random(1,20) ~= 1) then
					return
				end
			else
				return
			end
		end

		local int_pt=self.driverT.entity.cnt:GetViewIntersection();
		if (int_pt) and (int_pt.id) and (int_pt.id ~= self.id) then
			self.ac_lockedtarget = System:GetEntity(int_pt.id);
		end
	else
		local int_pt;
		local doairstrike=System:GetEntityByName(Mission.airstriketarget);
		if (doairstrike) then
			if (self.gunnerT.entity) then
				int_pt = self.gunnerT.entity;
			else
				int_pt = self.driverT.entity;
			end
			self.launch_on_demand = doairstrike;
		else
			return
		end
	end

if (self.ammoRL > 0) and (self.nextlaunchtime < _time) then
self.ammoRL = self.ammoRL - 1;
local vpos = self:GetHelperPos(self.Properties.sRLauncherLeft,0);
local vangles = new(self:GetAngles());
local vdir = new(self:GetDirectionVector());
vdir.x = -vdir.x; vdir.y = -vdir.y; vdir.z = -vdir.z;
local vrocket = {
	classid = Game:GetEntityClassIDByClassName(self.rkt_type),
	pos=vpos,
	angles=vangles,
};

vrocket = Server:SpawnEntity(vrocket);

if (self.gunnerT.entity) then
int_pt = self.gunnerT.entity; else
int_pt = self.driverT.entity; end

if (vrocket) then

if (int_pt.Properties.fRocketSpeed) then
int_pt.rsp_temp = int_pt.Properties.fRocketSpeed; end
int_pt.Properties.fRocketSpeed = self.Properties.GunnerParams.fRocketSpeed;
vrocket.go_direct_time = _time + 0.2;
if (self.ac_lockedtarget) then
	vrocket.chasetarget = self.ac_lockedtarget;
end
vrocket:Launch(int_pt.cnt.weapon,int_pt,vpos,vangles,vdir,vpos);

if (self.launch_on_demand) then vrocket.chasetarget = self.launch_on_demand; else
	if (self.Properties.GunnerParams.bDumbRockets == 1) or (Game:IsMultiplayer()) then
		vrocket.Target = nil;
	end
end

self.nextlaunchtime = _time + 1.3;

Server:BroadcastCommand("PLAS "..self.id.." "..self.driverT.entity.id.." "..self.ammoRL);

vpos = self:GetHelperPos(self.Properties.sRLauncherRight,0);
if (vpos ~= nil) and (vpos.z ~= 0) and (vrocket) then
	vrocket = {
		classid = Game:GetEntityClassIDByClassName(self.rkt_type),
		pos=vpos,
		angles=vangles,
	};
	vrocket = Server:SpawnEntity(vrocket);
	if (vrocket) then
		vrocket.go_direct_time = _time + 0.2;
		if (self.ac_lockedtarget) then
			vrocket.chasetarget = self.ac_lockedtarget;
		end
		vrocket:Launch(int_pt.cnt.weapon,int_pt,vpos,vangles,vdir,vpos);
		if (self.rlaunchersnd) then
			Sound:SetSoundPosition(self.rlaunchersnd,vpos);
			Sound:PlaySound(self.rlaunchersnd);
		end
		if (self.launch_on_demand) then
			vrocket.chasetarget = self.launch_on_demand;
		else
			if (self.Properties.GunnerParams.bDumbRockets == 1) or (Game:IsMultiplayer()) then
				vrocket.Target = nil;
			end
		end
	end
end -- vposnotnil
if (int_pt.rsp_temp) then
int_pt.Properties.fRocketSpeed = int_pt.rsp_temp;
int_pt.rsp_temp = nil; else
int_pt.Properties.fRocketSpeed = nil;
end
self.launch_on_demand = nil;
self.ac_lockedtarget = nil;
end -- vrocket

end
end
--------------

if (self.pwnperiod < _time) then
	self.pwnperiod = _time + 4;
	--AI:FreeSignal(1,"PWN_ME",pos,self.PropertiesInstance.sightrange);
	AI:SoundEvent(self.driverT.entity.id,pos,self.PropertiesInstance.sightrange,0,1,self.driverT.entity.id);
end

if pos.z > self.Properties.fCeilingHeight then
	self:SetPos({x=pos.x,y=pos.y,z=self.Properties.fCeilingHeight});
end

local dhhh = self:GetDirectionVector();
------------------------------------

----- >>>>>>>>>>>>>>>>>
--if (self.fullpow) then
--	Hud:AddMessage(dhhh.z.." full");
--else
--	Hud:AddMessage(dhhh.z.." std");
--end

if (self.dhhh_prev) and (self.dhhh_prev > _time) then
else
	if (self.rotorSpeed < self.rotorSpeedMax) then
		self.boat_params.DownRate = 300;
	elseif (dhhh.z < 0) then -- nose looks up
		if (self.fullpow) then
			self.boat_params.DownRate = -820; 
		else
			self.boat_params.DownRate = -300;
		end
		self.cnt:SetWaterVehicleParameters(self.boat_params);
	else --- nose looks down
		if (self.fullpow) then
			self.boat_params.DownRate = self.Properties.fJet_C_PushUpForce * -dhhh.z;
		else
			self.boat_params.DownRate = 300;
		end
		self.cnt:SetWaterVehicleParameters(self.boat_params);
	end
	self.dhhh_prev = _time+0.09;
end
--------- >>>>>>>>>>>>>>>>>>>>>>>
----------------------------------------------

if (self.speedup_timer) and (not self.fullpow) then
	self.fullpow = 1;
	self:GotoState("VMode");
elseif (self.fullpow) and (_time-dt*2 > self.speedup_timer) then
	self.fullpow = nil;
	self.speedup_timer = nil;
	self:GotoState("Alive");
end
----

end

VC.UpdateServerCommonT( self, dt );

if( VC.IsUnderWater( self, dt ) == 1 ) then 
VC.EveryoneOutForce( self );
if (self.inWarterTime > 3) then
VC.KillSelf(self);
end end

end
--
function JetVehicle:OnEventServer( id, params)

	if (id == ScriptEvent_PhysicalizeOnDemand) then
		self:SetPhysicParams( PHYSICPARAM_FLAGS, {flags_mask=pef_pushable_by_players, flags=0} );
	end

end



--
function JetVehicle:OnShutDown()

	VC.EveryoneOutForce(self);
	VC.RemovePieces(self);
end

--
function JetVehicle:OnSave(stm)
self.Ammo["VehicleRocket"] = self.ammoRL;
VC.SaveAmmo( self, stm );
stm:WriteInt(self.fEngineHealth);
end

--
function JetVehicle:OnLoad(stm)
VC.LoadAmmo( self, stm );
self.ammoRL = self.Ammo["VehicleRocket"];
self.fEngineHealth = stm:ReadInt();
end


--
function JetVehicle:OnWrite( stm )
	
end

--
function JetVehicle:OnRead( stm )

end

--
function JetVehicle:Event_Reinforcment( params )

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in
	VC.AIDriver( self, 1 );	
	AI:Signal(0, 1, "BRING_REINFORCMENT", self.id);
	
end	


-------------------
--
function JetVehicle:Event_GoPath( params )

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

	self.curPathStep = self.Properties.pathstart-1;
	VC.AIDriver( self, 1 );	
	AI:Signal(0, 1, "GO_PATH", self.id);

end


-------------------
--
-- to test
function JetVehicle:Event_StopAttack( params )

--System:Log("\001  Event_StopAttack  ");
	self.curPathStep = self.Properties.pathstart-1;
	AI:Signal(0, 1, "PLAYER_LEFT_VEHICLE", self.id);

end



-------------------
--
function JetVehicle:Event_LaunchRKT( params )
self.launch_on_demand = 1;
end



-------------------
--
function JetVehicle:Event_GoAttack( params )

--System:Log("\001  Humvee GoPath  ");

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

	VC.AIDriver( self, 1 );	
	AI:Signal(0, 1, "GO_ATTACK", self.id);

end

-------------------
--
-- to test
function JetVehicle:Event_Load( params )
self:LoadPeople();
end


-------------------
--
-- to test
function JetVehicle:Event_Release( params )

	VC.AIDriver( self, 1 );	
	self:UnloadPeople();

end

-------------------
--
--
function JetVehicle:RadioChatter()
end

-------------------
--
--

-------------------
--
-- 
function JetVehicle:Event_KillTriger( params )


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


-------------------
--
--
function JetVehicle:LoadPeople()

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

	if(self.driverT.entity and self.driverT.entity.ai) then
		AI:Signal(0, 1, "DRIVER_IN", self.id);
	end	

	if( self.Properties.bSameGroupId == 1 ) then
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "wakeup", self.id);	
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "SHARED_ENTER_ME_VEHICLE", self.id);
	else
		AI:Signal(SIGNALFILTER_ANYONEINCOMM, 1, "wakeup", self.id);	
		AI:Signal(SIGNALFILTER_ANYONEINCOMM, 1, "SHARED_ENTER_ME_VEHICLE", self.id);
	end
	self.dropState = 1;
	
end
--
function JetVehicle:UnloadPeople()
VC.DropPeople( self ,1);	
end
--
function JetVehicle:InitEntering( puppet, enterTable, destPos )

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


-------------------------
--
--
function JetVehicle:DoEnter( puppet )

if( puppet == self.driverT.entity ) then		-- driver
VC.AddUserT( self, self.driverT );
VC.InitEnteringJump( self, self.driverT );
elseif( puppet == self.gunnerT.entity ) then		-- gunner
VC.AddUserT( self, self.gunnerT );
VC.InitEnteringJump( self, self.gunnerT );
end
end


-------------------------
--
--
function JetVehicle:AddDriver( puppet )
	if (self.driverT.entity ~= nil) then -- already have a driver
		do return 0 end
	end
	self.driverT.entity = puppet;
	if( VC.InitApproach( self, self.driverT )==0 ) then	
		self:DoEnter( puppet );
	end
	do return 1 end
end

----
--
--
function JetVehicle:AddGunner( puppet )
	return 0
end

-------------------
--
--
function JetVehicle:AddPassenger( player )
	return 0
end
-------------------
--

function JetVehicle:Event_AddPlayer( params )

	if(_localplayer.theVehicle) then return end	-- this player is already in some (this) vehicle
	
	local theTable = VC.GetAvailablePosition(self);
	
	if(theTable == nil) then return end

	_localplayer.cnt.use_pressed = nil;
	theTable.entity = _localplayer;
	VC.AddUserT(self, theTable);	
	

	
end


--



-------------------
--
-- to test
function JetVehicle:Event_TArgetOnLand( params )

	AI:Signal(0, 1, "PLAYER_LEFT_VEHICLE", self.id);

end




-------------------
--
function JetVehicle:Event_DriverIn( params )
	if (Game:IsServer()) and (self.driverT.entity) and (self.Properties.fNUMofRockets > 0) then
		local psl=Server:GetServerSlotByEntityId(self.driverT.entity.id);
		if (psl) then
			psl:SendCommand("FX",{x=self.ammoRL,y=0,z=0},g_Vectors.v000,self.id,0);
		end
	end
	self:Go2normmode();
	BroadcastEvent( self,"DriverIn" );
end	


------------
function JetVehicle:Event_Unhide()

	self:Hide(0);

end


--
function JetVehicle:Event_Hide()

	self:Hide(1);

end
--
function JetVehicle:Event_Activate( params )

	if(self.bExploded == 1) then return end
	
	self:GotoState( "Alive" );
end

-- empty function to get reed of script error - it's called from behavours
function JetVehicle:MakeAlerted()
end

---
-- 
function JetVehicle:InitWeapon()
	if self.Properties.fNUMofMGRounds > 0 then
		self.fileGunModel = self.Properties.fileJet_P_Gun;
		self.cnt:SetWeaponLimits(-40, 50,-45,45); -- STRINGS TO SET MACHINEGUN ANGLE LIMITS!!!
		if (self.Properties.sJet_P_GunName) and (self.Properties.sJet_P_GunName~="") then
			self.cnt:SetWeaponName(self.Properties.sJet_P_GunName, self.Properties.sJet_P_GunName);
		else
			self.cnt:SetWeaponName("MutantMG", "MutantMG");
		end
		VC.InitAutoWeapon( self );
		self.driverShooting = 1;
	end
end

function JetVehicle:OnSaveOverall(stm)
VC.SaveCommon( self, stm );	
end

function JetVehicle:OnLoadOverall(stm)
VC.LoadCommon( self, stm );	
end
