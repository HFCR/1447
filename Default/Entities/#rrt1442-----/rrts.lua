--[[CryTop team scripting]]--
Player = {
	-- CII improved by Mixer 
	painSounds = {
			{"languages/voicepacks/Jack/pain_1.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_2.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_3.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_4.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_5.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_6.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_7.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_8.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_9.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_10.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_11.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_12.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_13.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_14.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_15.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_16.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_17.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_18.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_19.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_20.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_21.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_22.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_23.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_24.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_25.wav",0,175,3,30},
			{"languages/voicepacks/Jack/silence1.wav",0,175,3,30},
			{"languages/voicepacks/Jack/silence2.wav",0,175,3,30},
			{"languages/voicepacks/Jack/silence3.wav",0,175,3,30},
			{"languages/voicepacks/Jack/silence4.wav",0,175,3,30},
			{"languages/voicepacks/Jack/silence5.wav",0,175,3,30},
			
		},

	deathSounds = {
			{"languages/voicepacks/Jack/death_1.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_2.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_3.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_4.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_5.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_6.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_7.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_8.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_9.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_10.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_11.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_12.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_13.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_14.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_15.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_16.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_17.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_18.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_19.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_20.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_21.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_22.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_23.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_24.wav",0,175,3,20},
			
		},
		
	melee_sounds = {
			{"Sounds/Weapons/melee/swish.wav",0,115,3,20},
	},
	EquipmentSounds = {
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle1.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle3.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle5.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle6.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle7.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle8.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle9.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle10.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle11.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle12.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle13.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle14.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle15.wav",SOUND_UNSCALABLE,50,5,30),

	},
	EquipmentSoundProbability=100,
	cis_spawn_effect = 1,

	--other player sounds
	JumpSounds = {
		Sound:Load3DSound("SOUNDS/player/jump.wav",SOUND_UNSCALABLE,175,5,30),
	},
	
	LightExertion = {
		Sound:Load3DSound("SOUNDS/player/prone_up.wav",SOUND_UNSCALABLE,175,5,30),
		Sound:Load3DSound("SOUNDS/player/prone_down.wav",SOUND_UNSCALABLE,175,5,30),
	},
	
	LandHardSounds = {
		{"SOUNDS/player/heavy_fall.wav",0,175,3,30},
	},
	
	BleedSounds = {
		{"Sounds/player/bleed_m_1.wav",0,175,3,30},
		{"Sounds/player/bleed_m_2.wav",0,175,3,30},
		{"Sounds/player/bleed_m_3.wav",0,175,3,30},
		{"Sounds/player/bleed_m_4.wav",0,175,3,30},
	},
	
	DrunkMidSnd = {
		{"Objects/weapons/salo/ik1.wav",0,175,3,30},
		{"Objects/weapons/salo/ik2.wav",0,175,3,30},
	},
	CoughSnd = {
		{"Objects/weapons/salo/cough1.wav",0,175,3,30},
		{"Objects/weapons/salo/cough2.wav",0,175,3,30},
	},
	
	BreathingSounds = {
		--Sound:Load3DSound("SOUNDS/player/heavy_breathing_loop.wav",SOUND_UNSCALABLE,150,5,30),
	},
	
	HealingSounds = {
		Sound:Load3DSound("SOUNDS/player/relief1.wav",SOUND_UNSCALABLE,175,5,30),
	},

	iLastWaterSurfaceParticleSpawnedTime = _time,
	Energy = 100,
	MaxEnergy = 100,
	EnergyIncreaseRate = 1,	-- units per second
	MinRequiredEnergy = 20,	-- minimum energy needed to turn on heat vision
	EnergyChanged = nil,


	vLastPos = { x=0, y=0, z=0 },
	fLastRefractValue = 0,
	bSplashProcessed = nil,
	--iCurVehicle = nil,
	
	BinocularsActive = 0,
	FlashLightActive = 0,

	Ammo = {
		Pistol = 0,
		Assault = 0,
		Sniper = 0,
		Minigun = 0,
		Shotgun = 0,
		MortarShells = 0,
		Grenades = 0,
		HandGrenades = 0,
		Rocket = 0,
		Battery = 0,
	},

	WeaponState = nil,
	soundtimer = 0,

	Properties = {
		bHasArmor = 0,
		bHelmetOnStart = 0,
		eye_height = 2.0,
		species = 0,
		max_health = 255,
		groupid = 0,
		bTrackable=1,
		bIsBot=0,
	},

	
	PhysParams = {
		mass = 83,
		height = 1.84,
		-- Original Eye eyeheight = 1.7,
		eyeheight = 1.7,
		sphereheight = 1.2,
		radius = 0.45,
	},

	--pe_player_dimensions structure
	-- change log
	-- 1.july.02: x,y size changed from 0.6 to 0.4 allow the player to enter a 1meter wide gap
	--            animation looks fine, no wall cliping. Crouch height changed from 1.1 to 1.5
	--            and x,y from 0.6 to 0.45. At height 1.1 the players head was inside a wall. 
	--            Now looks better :] (ray)

	PlayerDimNormal = {
		height = 1.8,
		eye_height = 1.7,
		ellipsoid_height = 1.2,
		x = 0.45,
		y = 0.45,
		z = 0.6,
		head_height = 1.7,
		head_radius = 0.31,
	},
	PlayerDimCrouch = {
		height = 1.5,
		eye_height = 1.0,
		ellipsoid_height = 0.95,
		x = 0.45,
		y = 0.45,
		z = 0.5,
		head_height = 1.1,
		head_radius = 0.35,
	},
	PlayerDimProne = {
		height = 0.4,
		eye_height = 0.4,
		ellipsoid_height = 0.48,
		x = 0.45,
		y = 0.45,
		z = 0.24,
	},
	AniRefSpeeds = {
	-- those are not real scale ceff's - animation will slide, BUT sound for first person should be ok
		WalkFwd = 1.70,--3.5,
		WalkSide = 1.70,--3.5,
		WalkBack = 1.70,--3.5,
		
		XWalkFwd = 1.77,--3.5,
		XWalkSide = 1.73,--3.5, 
		XWalkBack = 1.73,--3.5,
		
		XRunFwd = 4.1,
		XRunSide = 3.0, 
		XRunBack = 3.4,
		
		RunFwd = 4.8,
		RunSide = 4.8,
		RunBack = 4.8,
		
		CrouchFwd = 1.02,
		CrouchSide = 1.02,
		CrouchBack = 1.02,
	},
	
	DeadBodyParams = {
	  max_time_step = 0.025,
	  gravityz = -7.5,
	  sleep_speed = 0.025,
	  damping = 0.3,
	  freefall_gravityz = -9.81,
	  freefall_damping = 0.1,

	  lying_mode_ncolls = 4,
	  lying_gravityz = -5.0,
	  lying_sleep_speed = 0.065,
	  lying_damping = 1.5,
		
		water_damping = 0.1,
		water_resistance = 1000,	
	},
	BulletImpactParams = {
    stiffness_scale = 73,
    max_time_step = 0.02
  },
	
	Params = {}, --used to pass params to the basic player

	keycards={},	-- holds player's keycards
	explosives={},	-- holds player's explosives
	items={},	-- generic items the player can pick up (heat vision goggles, etc..)
	objects={},     -- very mission specific objects the player can pick up

	SwayModifierProning = 0.1,
	SwayModifierCrouching = 0.5,

	GrenadeType = "ProjFlashbangGrenade",
	
	move_params={
		speed_run=3.4,
		speed_walk=1.7,
		speed_swim=2.5,
		speed_crouch=1.6,
		speed_prone=0.6,
		
		speed_run_strafe=3.4,--5.0,
		speed_walk_strafe=1.7,
		speed_swim_strafe=2.4,
		speed_crouch_strafe=1.6,
		speed_prone_strafe=0.6,
		
		speed_run_back=2.6,--5.0,
		speed_walk_back=2.1,
		speed_swim_back=2.0,
		speed_crouch_back=1.6,
		speed_prone_back=0.6,
		
		jump_force=7.3,
		lean_angle=8.7,
		bob_pitch=0.147101101, --0.21
		bob_roll=0.1774178,
		bob_lenght=3.8,
		bob_weapon=0.0147,
		
		
		
		----------------------------
		----------------------------------
		
		
		
		
	},
	
	SoundEvents={
		{"srunfwd",		7  },
		{"srunfwd",		19 },
		{"srunback",		5  },
		{"srunback",		14 },
		{"xwalkfwd", 		2  },
		{"xwalkfwd", 		26 },
		{"xwalkback", 		0  },
		{"xwalkback", 		23 },
		{"swalkback", 		0  },
		{"swalkback", 		16 },
		{"swalkfwd",  		2  },
		{"swalkfwd",  		19 },


		{"cwalkback",		9  },
		{"cwalkback",		33 },
		{"cwalkfwd",		12 },
		{"cwalkfwd",		31 },

    		{"pwalkfwd",		1  },
    		{"pwalkfwd",		20  },
    		{"pwalkback",		1  },
    		{"pwalkback",		20  },

		{"arunback",		6  },
		{"arunback", 		15 },
		{"arunfwd", 		7  },
		{"arunfwd", 		19 },
		{"asprintfwd",		5  },
		{"asprintfwd", 		13 },
		{"asprintback", 	6  },
		{"asprintback", 	15 },
		{"awalkback", 		1  },
		{"awalkback", 		17 },
		{"awalkfwd", 		1  },
		{"awalkfwd", 		20 },
		{"pwalkback",		3  },
	},

	idUnitHighlight=nil,						-- used by the UnitHighlight on the server - this entity is removed on shutdown
}

function Player:OnReset()	
	self:SetScriptUpdateRate(self.UpdateTime);
	if (self.JustLoaded==nil) then	-- [lennert] this is a dirty hack because OnReset is called after OnLoad for not very clear reasons; this should be fixed !
		self.keycards={};
		self.explosives={};
		if (self.items) and (self.items.aliensuit) then
			self.JustLoaded = 2; -- mixer: dirty hack to not forget about having alien suit
		end
		self.items={};
		if (self.JustLoaded == 2) then
			self.items.aliensuit = 1;
		end
		self.objects={}; 
	end
	self.JustLoaded=nil;

	------ Mixer: extended dirty hack (server-side) to prevent incorrect swinging rate of weapon model for first-person player
	if (self.currgamestyle) and (GameStyler) and (tonumber(self.currgamestyle) > 0) and (GameStyler.playermoves[tonumber(self.currgamestyle)]) then
		self.cnt:SetMoveParams(GameStyler.playermoves[tonumber(self.currgamestyle)].move_params);
		if (_localplayer) and (_localplayer.cnt) and (self ~= _localplayer) and (_localplayer.move_params) then
			_localplayer.cnt:SetMoveParams(GameStyler.playermoves[tonumber(self.currgamestyle)].move_params);
		end
	else
		self.cnt:SetMoveParams(self.move_params);
		if (_localplayer) and (_localplayer.cnt) and (self ~= _localplayer) and (_localplayer.move_params) then
			_localplayer.cnt:SetMoveParams(_localplayer.move_params);
		end
	end
	------

	if (not self.wasreset) then
		BasicPlayer.OnReset(self); -- Mixer: bugfix of second reset, should never happen,
	end

	if (self.Properties.bIsBot ~= 0) then
		AI:RegisterWithAI(self.id, AIOBJECT_PUPPET, self.Properties, self.PropertiesInstance);
		---------------
		if (GameRules.mapstart) and (GameRules.mapstart == _time) then
			self:TakeOutCTFflag();
			if (GameRules.attackerTeam) and (GameRules.attackerTeam~="red") then
				self:SetBotStats(1);
			else
				self:SetBotStats();
			end
		end
		if (self.cnt.health <= 0) then
			self:VBotEradicate();
			return;
		end
		-- getting respawn point
		local pickmdl=1;
		if (GameRules.GetTeamRespawnPoint) then
			pickmdl=GameRules:GetTeamRespawnPoint(self.bot_teamname,self);
		else
			pickmdl=nil;
		end
		if (not pickmdl) then
			pickmdl=Server:GetRandomRespawnPoint();
		end
		if (not pickmdl) then
			pickmdl=Server:GetFirstRespawnPoint();
		end
		if (pickmdl) then
			self:SetPos(pickmdl);
			self:SetAngles({z=pickmdl.zA});
			if (self.PhoenixData) then
				self.PhoenixData.pos = pickmdl;
				self.PhoenixData.angles = {x=0,y=0,z=pickmdl.zA};
			end
		end
		self.bAllWeaponsInititalized = nil;
		self.vb_su_goal_subject = nil;
		self.vb_wpntimer = _time + 1;
		self.vb_lastvehicletme = nil;
		self.coop_beacon = nil;
		self.POTSHOTS = 1; -- Mixer: sign of AI-controlled character, also, used for checking of first-time-or-not action inside the bot-update server-side code
		if (Game:IsMultiplayer()) then
			self.hasHelmet = 0;
			self.cnt.health=self.Properties.max_health;
			if (self.bot_armor) then
				self.cnt.armor=self.bot_armor;
			end
			self.EXPRESSIONS_ALLOWED = nil;
			self.bot_killstreak = 0;
			if (not GameRules.SurvivalManager) and (not GameRules.SetCoopMission) then
				-- because of ffa non-survival non-coop nature, make bots unfriendly to each other
				self:ChangeAIParameter(AIPARAM_SPECIES,self.bot_team);
				self:ChangeAIParameter(AIPARAM_GROUPID,self.bot_team);
			end
			if (gr_InvulnerabilityTimer~=nil and toNumberOrZero(gr_InvulnerabilityTimer)>0) then
				self.invulnerabilityTimer=toNumberOrZero(gr_InvulnerabilityTimer)+_time;
				Server:BroadcastCommand("FX", {x=0,y=0,z=0}, {x=0,y=0,z=0},self.id,2);
			else
				self.invulnerabilityTimer = 0;
			end
		end

	else
		self.POTSHOTS = nil;
		AI:RegisterWithAI(self.id, AIOBJECT_PLAYER, self.Properties);
	end

	self:EnableUpdate(1);
	self.cnt:SwitchFlashLight(0);
	
	if (getglobal("gr_gamestyle")~=nil) then
		self.currgamestyle = "0";
	else
		self.currgamestyle = nil;
	end
end

-- Verysoft bot function to get the table of pickup items on the map (all game types) and also get table of buildable/destroyable objects for Assault gametype
-- the table with pickups id's is stored in GameRules.bot_common.bot_pickups
-- the table with buildable/destroyable objects id's is stored in GameRules.bot_common.bot_goals
function Player:GetBotPickups()
	if (not GameRules.soccerball) then
		if (GameRules.bot_common.prev_pickchktime) and (GameRules.bot_common.prev_pickchktime < _time) then
			GameRules.bot_common.prev_pickchktime = _time + 3; -- do not perform it too often, just every x seconds
			local bot_attractget=System:GetEntities();
			GameRules.bot_common.bot_pickups = {};
			GameRules.bot_common.bot_goals = {};
			for i, canpik in bot_attractget do
				if (canpik.Properties) then
					if (canpik.Properties.RespawnTime) and (canpik.Properties.bPlayerOnly) then
						-- add pickup item id to pickups table
						AI:RegisterWithAI(canpik.id,0);
						if (canpik.type=="Armor") then
							AI:RegisterWithAI(canpik.id,AIAnchor.MORPH_HERE);
						elseif (canpik.weapon) then
							AI:RegisterWithAI(canpik.id,AIAnchor.GUN_RACK);
						elseif (canpik.type=="Health") then
							AI:RegisterWithAI(canpik.id,AIAnchor.SNIPER_POTSHOT);
						else
							AI:RegisterWithAI(canpik.id,AIAnchor.AIANCHOR_RAMPAGE);
						end
						tinsert(GameRules.bot_common.bot_pickups, canpik.id*1);
					elseif (GameRules.IsDefender) and (canpik.Properties.max_repairpoints) then
						-- add buildable object id to goals table
						tinsert(GameRules.bot_common.bot_goals, canpik.id*1);
					end
				end
			end -- for cycle
			if (getn(GameRules.bot_common.bot_goals) < 1) then
				GameRules.bot_common.bot_goals=nil;
			end
		elseif (GameRules.bot_common.prev_pickchktime == nil) then
			GameRules.bot_common.prev_pickchktime = _time + 3;
		end
	end
end

-- Players/bots function to became temporarily invisible (invisibility powerup alpha stage yet) and store invisibility holdable in sp missions
function Player:Grab_Invisibility(tme)
	if (not Game:IsMultiplayer()) and (tme >= 0) then
		if (self.items.invis_holdable) then
			self.items.invis_holdable = self.items.invis_holdable + tme;
		else
			self.items.invis_holdable = tme * 1;
			if (Hud) and (_localplayer) and (self == _localplayer) then
				Hud:AddMessage("$1 @cis_holdable_invisibility");
			end
		end
		return;
	elseif (tme < 0) then
		tme = abs(tme);
	end
	self.items.invis_holdable = nil;
	self.items.invis_active = tme * 1;
	Server:BroadcastCommand("FX", {x=tme * 1,y=0,z=0}, {x=0,y=0,z=0},self.id,5);
end

function Player:CheckMeForActivity()
	if (self.LastActivityPos.zlastchk < _time) then
		local la_cpos = new(self:GetAngles());
		if (la_cpos.z == self.LastActivityPos.z) then
			local time_to_idle = tonumber(getglobal("fcam_inactivity_time"));
			if (time_to_idle > 0) then
				if (self.LastActivityTime+(time_to_idle*60) < _time+20) then
					local serverSlot = Server:GetServerSlotByEntityId(self.id);
					if (serverSlot) and (not self.AC_Warning) then
						serverSlot:SendCommand("ACWR");
						serverSlot:SendText("$4Move, or you will be kicked!");
					end
					self.AC_Warning = 1;
					if (self.LastActivityTime+time_to_idle*60 < _time) then
						self.AC_Warning = nil;
						if (time_to_idle < 2) then
							setglobal("fcam_inactivity_time",2);
							System:Warning("$1Inactivity time less than 2 min. Setting now to 2 min.");
							return;
						end
						self.LastActivityTime = _time;
						if (_localplayer) and (serverSlot) then
							local lp_slot = Server:GetServerSlotByEntityId(_localplayer.id);
							if (lp_slot) and (lp_slot == serverSlot) then
								-- listen server player, move to spectators, don't kick!
								Client:JoinTeamRequest("spectators");
								Game:SendMessage("Switch");
								return;
							end
						end
						if (serverSlot) then
							GameRules:KickSlot(serverSlot);
						end
					end
				end
			end
		else
			self.LastActivityPos = la_cpos;
			self.LastActivityTime = _time;
			self.AC_Warning = nil;
		end
		self.LastActivityPos.zlastchk = _time + 3;
	end
end

-- Mixer: Raw feature for grabbing/carrying physical items. It is optimised/improved version of entire Rotator.lua which is deprecated for now. If you want to use this function in your mods, just make sure
-- this function gets executed on every screen update, if player has desired entity id stored in _localplayer.items.gr_item_id variable. The function will do all other work for you completely :)
-- recommended value of max_weight parameter is 80, but feel free to experiment a bit.

function Player:CarryPhysItem(max_weight,item_to_grab)
	if (item_to_grab) then
		self.items.gr_item_id = item_to_grab * 1;
		self.cnt.use_pressed = nil;
		self.items.gr_item_picktime = _time * 1;
		self.items.gr_item_zmax = nil;
		if (_localplayer) and (self == _localplayer) then
			if (not self.grabb_snd_1) then
				self.grabb_snd_1 = Sound:LoadSound("Sounds/items/cis_item_grab.wav");
			end
			if (self.grabb_snd_1) then
				Sound:SetSoundVolume(self.grabb_snd_1,120);
				Sound:PlaySound(self.grabb_snd_1);
			end
		end
		if (Game:IsClient()) then
			self:StartAnimation(0,'aidle_usaim',4);
		end
	end

	local grbb_length = 1;
	local contact = System:GetEntity(self.items.gr_item_id);

	if (contact) then
		local dirv = new(self:GetDirectionVector());
		local p_pos = new(self:GetPos());
		local p_bonepos = self:GetBonePos("Bip01");
		p_pos.z = p_bonepos.z + 0.27;

		local p_ang = new(self:GetAngles());
		local o_pos = new(contact:GetCenterOfMassPos());
		if (o_pos == nil) then
			self.items.gr_item_id = nil;
			return;
		end

		if (not contact.cis_handheldobj) then
			p_ang.x = 0;
			p_ang.y = 0;
			--p_ang.zreal = rad(p_ang.z-90);
			
			if (self.items.gr_item_ang) then
				if (not contact.grb_curr_ang) then
					contact.grb_curr_ang = 0;
				end
				if (contact.grb_curr_ang ~= self.items.gr_item_ang) then
					if (contact.grb_curr_ang >= 270) and (self.items.gr_item_ang < 90) then
						contact.grb_curr_ang = contact.grb_curr_ang + _frametime*240;
						if (contact.grb_curr_ang > 360) then
							contact.grb_curr_ang = 0;
						end
					elseif (contact.grb_curr_ang > self.items.gr_item_ang) then
						contact.grb_curr_ang = contact.grb_curr_ang - _frametime*240;
						if (contact.grb_curr_ang < self.items.gr_item_ang) then
							contact.grb_curr_ang = self.items.gr_item_ang * 1;
						end
					else
						contact.grb_curr_ang = contact.grb_curr_ang + _frametime*240;
						if (contact.grb_curr_ang > self.items.gr_item_ang) then
							contact.grb_curr_ang = self.items.gr_item_ang * 1;
						end
					end
				end
				p_ang.z = p_ang.z - contact.grb_curr_ang;
			end
		else
			if (self.items.gr_item_ang) then
				if (not contact.grb_curr_ang) then
					contact.grb_curr_ang = 0;
				end
				if (contact.grb_curr_ang ~= self.items.gr_item_ang) then
					contact.grb_curr_ang = self.items.gr_item_ang * 1;
					BasicPlayer.PlayerContact(self,contact,3);
				end
			end
		end

		contact:SetAngles(p_ang);
		
		local bbox = new(contact:GetBBox(0));
		local b_max = {
			x = abs(bbox.max.x)-abs(bbox.min.x),
			y = abs(bbox.max.y)-abs(bbox.min.y),
			z = abs(bbox.max.z)-abs(bbox.min.z),
		};

		bbox = b_max.z * 1;

		if (self.items.gr_item_zmax) then
			bbox = self.items.gr_item_zmax.z*1;
			b_max = {x=self.items.gr_item_zmax.x * 1,y=self.items.gr_item_zmax.y * 1,z = self.items.gr_item_zmax.z * 1};
		else
			local c_center_pos = new(contact:GetCenterOfMassPos());
			local c_act_pos = new(contact:GetPos());
			self.items.gr_item_zmax = {x=b_max.x * 1,y=b_max.y * 1,z = b_max.z * 1,offpos = c_center_pos.z-c_act_pos.z};
			if (contact.cis_handheldobj) then
				contact.grab_cl_zoffset = 0.5;
				contact:RenderShadow(1,0);
			end
		end
		
		if ( b_max.x < b_max.y ) then
			b_max = b_max.x;
		else
			b_max = b_max.y;
		end
		
		if (b_max < grbb_length) then
			grbb_length = b_max * 1;
		end

		local p_vel = new(self:GetVelocity());
		p_vel.x = abs(p_vel.x);
		p_vel.y = abs(p_vel.y);
		p_vel.z = abs(p_vel.z);

		--p_pos.x = p_pos.x+grbb_length*cos(p_ang.zreal);
		--p_pos.y = p_pos.y+grbb_length*sin(p_ang.zreal);
		p_pos.x = p_pos.x + grbb_length * dirv.x;
		p_pos.y = p_pos.y + grbb_length * dirv.y;
		p_pos.z = p_pos.z + dirv.z * grbb_length;

		if (p_pos.z < p_bonepos.z) then
			p_pos.z = p_bonepos.z;
		end
		
		local p_pos_edge = { -- pos of the farthest edge of grabbed object
			x = p_pos.x + dirv.x*(b_max*0.5),
			y = p_pos.y + dirv.y*(b_max*0.5),
			z = p_pos.z + dirv.z*(b_max*0.5),
		};

		local hits1 = System:RayWorldIntersection(p_bonepos, p_pos_edge, 1,ent_static+ent_sleeping_rigid+ent_rigid+ent_independent+ent_terrain,self.id,contact.id);
		
		--Particle:SpawnEffect(p_pos_edge,g_Vectors.v001,'misc.sparks.a',1);
		
		if (hits1) and (getn(hits1)>0) then
			p_pos.x = hits1[1].pos.x-dirv.x*(b_max*0.5);
			p_pos.y = hits1[1].pos.y-dirv.y*(b_max*0.5);
			p_pos.z = hits1[1].pos.z-dirv.z*(b_max*0.5);
		end
		
		----bbox bottom contact check

		hits1 = System:RayWorldIntersection(p_pos,{x=p_pos.x,y=p_pos.y,z=p_pos.z-bbox/1.7}, 1,ent_static+ent_sleeping_rigid+ent_rigid+ent_independent+ent_terrain,self.id,contact.id);
		if (hits1) and (getn(hits1)>0) then
			if (self.items.gr_item_zmax) then
				p_pos.z = hits1[1].pos.z+self.items.gr_item_zmax.offpos;
			else
				p_pos.z = hits1[1].pos.z+(bbox/1.7);
			end
		end

		--p_pos_edge = DifferenceVectors(p_pos,o_pos);
		--local c_objdist = LengthSqVector(p_pos_edge);
		
		if (self.cnt) then
			local bDropIt = 0;
			if (Game:IsServer()) then
				if (self.cnt.firing) then
					bDropIt = 2;
				end

				--- DROP IF PLAYER PRESSED USE or flying strangely 
				if (self.cnt.use_pressed) or (p_vel.x+p_vel.y+p_vel.z > 10) or (p_vel.z*0.5 > p_vel.x + p_vel.y) then
					if (self.cnt.use_pressed) and (Game:IsMultiplayer()) then
						if (self.items.gr_item_picktime) and (self.items.gr_item_picktime < _time-0.4) then
							bDropIt = 1;
						end
					else
						bDropIt = 1;
					end
					self.cnt.use_pressed = nil;
				end
				
				if (contact:GetDistanceFromPoint(p_pos) > 3) then
					-- make cutted version of throw anim, to simulate usable item pickup, because it is usually the case of helmet/health pickup
					self.pckanm_do = _time + 0.22;
					bDropIt = 1;
					self.pckanm_do_toofarpos = new(contact:GetPos());
				end

				--- DROP IF PLAYER ENTERS VEHICLE / USES MOUNTED GUN
				if (self.cnt.weapon and self.items.lastslctdwpn) or (self.theVehicle) or (self.current_mounted_weapon) then
					bDropIt = 1;
				end
				
				if (BasicPlayer.IsAlive(self)==nil) then
					bDropIt = 1;
				end
			else
				if (contact.grb_DropNow) then
					contact.grb_DropNow = nil;
					bDropIt = 1;
				end
				contact:EnablePhysics(0);
				contact:EnablePhysics(1);
			end
			
			if (bDropIt > 0) then
				if (not self.current_mounted_weapon) then
					self.cnt.lock_weapon=nil;
				end
				
				local guntoken = 0;

				if (self.items.lastslctdwpn) then

					if (self.ladder) then
						self.cnt:UseLadder(0);
						self.cnt:SetCurrWeapon(self.items.lastslctdwpn);
						self.cnt:UseLadder(1,self.ladder.climbspeed,self.ladder:GetPos());
					else
						self.cis_svgload = 1; -- prevents weapon activation sound playing
						self.cnt.weapon_busy=0.5; -- prevents shooting after throw while weapon is in second firemode
						self.cnt:SetCurrWeapon(self.items.lastslctdwpn);
						if (self.cnt.weapon) and (self.cnt.first_person) then
							-- Perform fake pushing anim
							if (Mission) and (Mission.soccer_center) and (self.cnt.weapon.name == "Hands") then
							else
								self.cnt.weapon:StartAnimation(0,"Grenade11",0,0);
							end
							if (self.fireparams) and (self.fireparams.AmmoType) and (self.fireparams.AmmoType ~= "Unlimited") then
								guntoken = 1;
							end
						end
					end
					self.items.lastslctdwpn = nil;

				elseif (not self.cnt.weapon) then
					self.cnt.speedscale=1;
				end

				self.items.gr_item_id = nil;
				self.items.gr_item_picktime = nil;
				
				self:EnablePhysics(0);

				if (Game:IsClient()) then
					self:StartAnimation(0,"NULL",4);
				end
				
				if (contact.cis_handheldobj) then
					contact:DrawObject(1,0);
					contact:DrawObject(0,1);
					contact:RenderShadow(1);
				end

				contact:EnablePhysics(1);

				--------------------------------
				if (self.pckanm_do_toofarpos) then
					contact:SetPos(self.pckanm_do_toofarpos);
					self.pckanm_do_toofarpos = nil;
				else
					if (self.items.gr_item_zmax) then
						p_pos.z = p_pos.z - self.items.gr_item_zmax.offpos;
					end
					p_pos.x = p_pos.x + dirv.x*(b_max*0.475);
					p_pos.y = p_pos.y + dirv.y*(b_max*0.475);
					p_pos.z = p_pos.z + dirv.z*(b_max*0.475);
					contact:SetPos(p_pos);
				end
				--------------------------------

				if (Game:IsServer()) and (Game:IsMultiplayer()) then
					contact:NetPresent(1);
					Server:BroadcastCommand("CSH "..self.id.." -"..contact.id);
				end

				o_pos = new(contact:GetCenterOfMassPos());
				
				o_pos.z = o_pos.z - 0.02;

				if (bDropIt > 1) then
					if contact.classname=="AICrate" then
						contact:AddImpulse(-1,o_pos,dirv,40);
					else
						contact:AddImpulse(-1,o_pos,dirv,850*0.3);
					end
				else
					contact:AddImpulse(-1,o_pos,{x=0,y=0,z=-1},1);
					if (self.cnt.weapon) and (self.cnt.first_person) then
						self.pckanm_do = _time + 0.2;
					end
				end
				
				self:EnablePhysics(1);
				
				if (_localplayer) and (self == _localplayer) then
					if (guntoken == 1) then
						if (not self.grabb_snd_3) then
							self.grabb_snd_3 = Sound:LoadSound("Sounds/items/cis_item_release_gun.wav");
						end
						if (self.grabb_snd_3) then
							Sound:SetSoundVolume(self.grabb_snd_3,140);
							Sound:PlaySound(self.grabb_snd_3);
						end
					else
						if (not self.grabb_snd_2) then
							self.grabb_snd_2 = Sound:LoadSound("Sounds/items/cis_item_release.wav");
						end
						if (self.grabb_snd_2) then
							Sound:SetSoundVolume(self.grabb_snd_2,140);
							Sound:PlaySound(self.grabb_snd_2);
						end
					end
				end
				if (contact.Event_UnHide) then
					BroadcastEvent(contact,"UnHide");
				end
				return;
			end
			if (self.cnt.weapon) and (not self.items.lastslctdwpn) and (not self.current_mounted_weapon) then
				self.items.lastslctdwpn = self.cnt.weapon.classid * 1;
				self.cnt:SetCurrWeapon();
				self.cnt.speedscale=1-contact.Properties.Physics.Mass/(max_weight*1.4);
				if (self.cnt.speedscale < 0.45) then
					self.cnt.speedscale = 0.45;
				end
			end
		end

		contact:EnablePhysics(0);
		if (contact.cis_handheldobj) then
			contact:DrawObject(0,0);
			contact:DrawObject(1,1);
		end

		if (contact.cis_handheldobj) and (self.GetCameraPosition) then
			p_pos = new(self:GetCameraPosition());
			p_pos.z = p_pos.z + 0.14;
			if (contact.grab_cl_zoffset) then
				if (contact.grab_cl_zoffset < 0) then
					contact.grab_cl_zoffset = nil;
				else
					p_pos.z = p_pos.z - contact.grab_cl_zoffset;
					contact.grab_cl_zoffset = contact.grab_cl_zoffset - _frametime * 1.3;
				end
			end
		elseif (self.items.gr_item_zmax) then
			p_pos.z = p_pos.z - self.items.gr_item_zmax.offpos;
		end
		
		contact:SetPos(p_pos);
		contact.last_hold_time = _time * 1;
		contact.cis_lastgrabberid = self.id * 1;

		if (Hud) and (_localplayer) and (self==_localplayer) then
			if (self.items.gr_item_picktime > _time) then
				self.items.gr_item_picktime = _time * 1;
			end
			Hud.label = "carry_hint";
		end

		if (item_to_grab) then
			if (Game:IsMultiplayer()) then
				if (Game:IsServer()) then
					if (not GameRules.PhysCarriers) then
						GameRules.PhysCarriers = {};
					else
						for i, cid in GameRules.PhysCarriers do
							if (i ~= "n") then
								if (cid == self.id) then
									return;
								end
							end
						end
					end
					tinsert(GameRules.PhysCarriers,self.id*1);
					contact:NetPresent(nil);
					Server:BroadcastCommand("CSH "..self.id.." "..contact.id);
				elseif (ClientStuff) then
					if (not ClientStuff.PhysCarriers) then
						ClientStuff.PhysCarriers = {};
					else
						for i, cid in ClientStuff.PhysCarriers do
							if (i ~= "n") then
								if (cid == self.id) then
									return;
								end
							end
						end
					end
					tinsert(ClientStuff.PhysCarriers,self.id*1);
				end
			end
			if (contact.Event_OnDamage) then
				BroadcastEvent( contact,"OnDamage" );
			end
		end
	end
end

-- Verysoft bots func to maintain scoreboard stats of bots. if noreset is nil, all stuff are resetting to 0, otherwise it just transfers bot stats to scoreboard fields
function Player:SetBotStats(noreset)
	if (not noreset) then
		self.sui=0;
		self.cnt.score=0;
		self.cnt.deaths=0;
		self.assault_score=0;
		self.cap_score=0;
	else
		if (not self.assault_score) then self.assault_score = 0; end
		if (not self.cap_score) then self.cap_score = 0; end
	end
	if (self.bot_classnum) then
		GameRules:SetScoreboardEntryXY(ScoreboardTableColumns.iPlayerScore,self.vbot_ssid,self.cnt.score);
		GameRules:SetScoreboardEntryXY(ScoreboardTableColumns.iTotalScore,self.vbot_ssid,self.cap_score+self.assault_score+self.cnt.score*5);
		GameRules:SetScoreboardEntryXY(ScoreboardTableColumns.iSupportScore,self.vbot_ssid,self.assault_score);
	else
		GameRules:SetScoreboardEntryXY(ScoreboardTableColumns.iScore,self.vbot_ssid,self.cnt.score);
		if (GameRules.IsFlagCarrier) then
			GameRules:SetScoreboardEntryXY(ScoreboardTableColumns.iFlagScores,self.vbot_ssid,self.assault_score+self.cnt.score*5);
		end
	end
	GameRules:SetScoreboardEntryXY(ScoreboardTableColumns.iDeaths,self.vbot_ssid,self.cnt.deaths);
	GameRules:SetScoreboardEntryXY(ScoreboardTableColumns.iSuicides,self.vbot_ssid,self.sui);
end

-- Verysoft bots func to remove this bot on demand, or spawn bot child (bot clone to be respawned after bot is died)
-- memory leak clue is perhaps hidden here
function Player:VBotEradicate()
	-- to make sure it's executed only once!
	if (self.vb_r_terminated) then
		return;
	end
	self.vb_r_terminated = 1;

	if (GameRules.bot_common) and (GameRules.bot_common.redsum) then
		if (GameRules.bIsTeamBased) then
			if self.bot_teamname == "blue" then
				GameRules.bot_common.bluesum=GameRules.bot_common.bluesum-1;
			else
				GameRules.bot_common.redsum=GameRules.bot_common.redsum-1;
			end
		else
			GameRules.bot_common.redsum=GameRules.bot_common.redsum-1;
		end
	end
	if (self.bot_disconnectnow) then
		GameRules:RemovePlayerFromScoreboard(self.vbot_ssid);
		self:TakeOutCTFflag();
		System:LogAlways(date("%H:%M:%S").." -Bot: "..self:GetName().." - "..self.bot_teamname);
	else -- not disconnect, spawn child

		self.Properties.ipotomok = 1;
		self.Properties.my_team = self.bot_team;
		self.Properties.my_score = self.cnt.score;
		self.Properties.my_deaths = self.cnt.deaths;
		self.Properties.my_sui = self.sui;
		self.Properties.my_ssid = self.vbot_ssid;
		if (self.bot_classnum) then
			if self.bot_classnum == 0 then
				self.Properties.my_class = 1;
			elseif self.bot_classnum == 2 then
				self.Properties.my_class = 2;
			else
				self.Properties.my_class = 3;
			end
		end
		if (self.assault_score) and (self.assault_score > 0) then
			self.Properties.my_ascore = self.assault_score;
		end
		if (self.cap_score) and (self.cap_score > 0) then
			self.Properties.my_capscore = self.cap_score;
		end
		local vbot_twin=Server:SpawnEntity({classid=PLAYER_CLASS_ID,model=self.cnt.model,name=self:GetName(),color=self.Properties.my_color,properties=self.Properties});

		-- tuRnst!LL : set the bot properties and sync it on clientside
		if vbot_twin and vbot_twin.type == "Player" then
			if vbot_twin.DynProp then
				vbot_twin.cnt:SetDynamicsProperties(vbot_twin.DynProp);
			end
			if vbot_twin.move_params then
				vbot_twin.cnt:SetMoveParams(vbot_twin.move_params);
			end
			local tPlayerClass={"Grunt", "Sniper", "Support",};
			if vbot_twin.Properties.my_class then
				Server:BroadcastCommand("YCN "..vbot_twin.id.." "..tPlayerClass[vbot_twin.Properties.my_class]);
			else
				Server:BroadcastCommand("YCN "..vbot_twin.id.." DefaultMultiPlayer");
			end
		end
		-- End tuRnst!LL

		if (not vbot_twin) then
			-- just for fail-safe, shouldn't happen.
			MapCycle.vbots_num = MapCycle.vbots_num-1;
		end
	end
	self:TriggerEvent(AIEVENT_AGENTDIED);
	AI:DeCloak(self.id);
	AI:RegisterWithAI(self.id, 0);
	Server:RemoveFromTeam(self.id);
	Server:RemoveEntity(self.id);
	self = nil; -- ? clears used memory for entity table?
end

--- feature to reach goal, (advancing along the tagpoints) for make long-run routes for bots for Survival gametypes
-- for example, place mygoal_1, mygoal_2 etc  tag points and call bot:ReachGoal('mygoal')
function Player:ReachGoal(gname)
	local gps = 1;
	while (Game:GetTagPoint(gname.."_"..gps)~=nil) do
		gps = gps + 1;
	end
	if (gps == 0) then
		System:Warning("NO GOAL TAG POINTS: "..gname.."_x WHERE X ARE 1, 2, etc");
		return;
	else
		gps = gps - 1;
	end
	local lastp_num;
	for i = 1, gps do
		local ggoal = Game:GetTagPoint(gname.."_"..i);
		if (self:GetDistanceFromPoint({x=ggoal.x,y=ggoal.y,z=ggoal.z}) < 120) then
			lastp_num = (i*1);
		end
	end
	if (lastp_num) then
		self:SelectPipe(0,"bot_roam",gname.."_"..lastp_num);
		return 1;
	end
	return nil;
end

-- verysoft bot func to get an idea he sees an enemy or not. returns 1 if he sees an enemy and nil if he doesn't.
function Player:ISeeTarget()
	self.bot_memnpc = AI:GetAttentionTargetOf(self.id);
	if (self.bot_memnpc) and (type(self.bot_memnpc)=="table") then
	return 1; else return nil; end
end

-- function to return player id. some scripts want to get id in such manner.
function Player:GetPlayerId()
	return self.id;
end

-- verysoft bot func for ctf (to take the flag out of bot before removing the bot actually)
function Player:TakeOutCTFflag(isreturn)
	if (GameRules.IsFlagCarrier==nil) then
		return;
	end
	for i,val in GameRules.flags do
		if (GameRules:IsFlagCarrier(self.bot_teamname,self)) then
			if val.Properties.team ~= self.bot_teamname then
				val:DropFlag(self,self.bot_teamname);
				val.iscaptured=0;
				val.cap_frombase=0;
				if (isreturn) then
					val:ReturnFlag();
				end
			end
		end
	end
end

function Player:OnCheckWeapon()
	-- Mixer: the code moved from here, but please leave this function for compatibility with other scripts
end

function Player:Readibility( signal , bSkipGroupCheck)
	if (bSkipGroupCheck==nil) then 
		if (AI:GetGroupCount(self.id) > 1) then
			AI:Signal(SIGNALID_READIBILITY, 1, signal.."_GROUP",self.id);
		else
			AI:Signal(SIGNALID_READIBILITY, 1, signal,self.id);
		end
	else
		AI:Signal(SIGNALID_READIBILITY, 1, signal,self.id);
	end
end

-------------
function Player:RegisterStates()
	self:RegisterState( "Alive" );
	self:RegisterState( "Dead" );
end

function Player:LoadModel()
	if (self.model_loaded==nil) then

		local bLoadStandardModel;

		-- client might not allow user defined models
		if Game:IsMultiplayer() then
			local mp_usermodels = tostring(getglobal("cl_AllowUserModels"));
			if (Mission) and (Mission.alienworld) then
				self.cnt.model = "Objects/characters/workers/coretech/coretech.cgf";
			end
			local bIsAStandardModel;
			
			if mp_usermodels=="0" then
				for key,val in MPModelList do
					if val.model==self.cnt.model then
						bIsAStandardModel=1;
					end
				end
			end
			
			if not bIsAStandardModel then
				bLoadStandardModel=1;
			end
		else
			local mpmodel = getglobal("mp_model");
			for key,val in MPModelList do
				if (val.model==mpmodel) and (val.name) then
					if (val.name ~= "@MPModelJack") then
						self.cnt.model = mpmodel;
					end
					break;
				end
			end 
		end

		if bLoadStandardModel or not self:LoadCharacter(self.cnt.model,0) then
			self:LoadCharacter("objects/characters/pmodels/hero/hero_mp.cgf",0);								-- if this model is not there load the default model
		end
		
		if (strfind(self.cnt.model,"valeri.")) then
			self.hastits = 1;
		else
			self.hastits = nil;
			if (strfind(self.cnt.model,"coretech.cg")) and (not self.items.aliensuit) then
				self.items.aliensuit = 1; -- Mixer: automatically add aliensuit to inventory for this model
			end
		end

		self["model_loaded"]=1;
		if (self.Properties.bHelmetOnStart==1)	then
			self:LoadObject( "objects/characters/mercenaries/accessories/helmet.cgf", 0, 1 );
		end	
	end
end

---------
-- \bInvulnerable 1=, nil
function Player:ApplyTeamColor()
--	System:Log("FX: ApplyTeamColor");
	local color=self.cnt:GetColor();
	
	self:SetShaderFloat( "ColorR", color.x,0,0 );
	self:SetShaderFloat( "ColorG", color.y,0,0 );
	self:SetShaderFloat( "ColorB", color.z,0,0 );
end

function Player:OnPropertyChange()
	self:Server_OnInit();
end

-----
function Player:Server_OnInit()
	-- register as main guy in the AI system
	if (self.Properties.bIsBot ~= 0) then
		---------------------------
		self.PropertiesInstance = {
			sightrange = 110,
			soundrange = 15,
			groupid = 0,
			aibehavior_behaviour = "TestBotIdle",
		};
		if (not AIBehaviour.AVAILABLE.TestBotIdle) then
			AI:CreateGoalPipe("bot_roam");
			AI:PushGoal("bot_roam","run",0,1);
			AI:PushGoal("bot_roam","bodypos",0,0);
			AI:PushGoal("bot_roam","firecmd",0,0);
			AI:PushGoal("bot_roam","pathfind",1,"");
			AI:PushGoal("bot_roam","trace",1,1);
			AI:PushGoal("bot_roam","signal",0,1,"OnVerifyPos",0);

			AI:CreateGoalPipe("bot_combat");
			AI:PushGoal("bot_combat","run",0,1);
			AI:PushGoal("bot_combat","bodypos",0,0);
			AI:PushGoal("bot_combat","firecmd",0,1);
			AI:PushGoal("bot_combat","pathfind",1,"");
			AI:PushGoal("bot_combat","approach",1,1);
			AI:PushGoal("bot_combat","signal",0,1,"OnVerifyPos",0);

			AI:CreateGoalPipe("bot_hide");
			AI:PushGoal("bot_hide","firecmd",1,1);
			AI:PushGoal("bot_hide","hide",1,10,HM_RANDOM);
			AI:PushGoal("bot_hide","timeout",1,3);
			AI:PushGoal("bot_hide","signal",0,1,"TRY_NEXT",0);

			Script:ReloadScript("Scripts/Default/Entities/Player/BotBehavior.lua");
			AIBehaviour.AVAILABLE.TestBotIdle="Scripts/Default/Entities/Player/BotBehavior.lua";
			AICharacter.AVAILABLE.TestBot="Scripts/Default/Entities/Player/BotBehavior.lua";
		end
		
		if (not self.Properties.aggression) then
			self.Properties.special = 0;
			self.Properties.aggression = 0.9;
			self.Properties.commrange = 40.0;
			self.Properties.attackrange = 180;
			self.Properties.horizontal_fov = 120;
		
			self.Properties.forward_speed = 1.7;
			self.Properties.back_speed = 1.7;
			self.Properties.accuracy = 0.8;
			self.Properties.responsiveness = 7;
			
			self.Properties.fSpeciesHostility = 2;
			self.Properties.fGroupHostility = 0;
			self.Properties.fPersistence = 0;
			self.Properties.bSleepOnSpawn = 0;
			
		end

		self.Properties.aicharacter_character = "TestBot";
		self.Properties.fMeleeDistance = 3.0;
		self.bot_born=1;
		self.bot_lastpick=0;
		--------------------------
		if (not GameRules.bot_common) then
			GameRules.bot_common = {};
		end
		----------------------
		local pickmdl;
		local t_bot_bprnd=random(1,3);

		if (self.Properties.ipotomok) then
			self.bot_team = self.Properties.my_team;
			self.cnt.score = self.Properties.my_score;
			self.cnt.deaths = self.Properties.my_deaths;
			self.sui = self.Properties.my_sui;
			self.vbot_ssid = self.Properties.my_ssid;
			if (self.Properties.my_class) then
				t_bot_bprnd = self.Properties.my_class;
			end
			if (self.Properties.my_ascore) then
				self.assault_score = self.Properties.my_ascore;
			end
			if (self.Properties.my_capscore) then
				self.cap_score = self.Properties.my_capscore;
			end
			if (self.Properties.my_Equip) then
				if (self.Properties.my_Ammo) then
					self.Properties.my_Equip.Ammo = self.Properties.my_Ammo;
				end
				EquipPacks["coop_vbot_"..self.vbot_ssid] = self.Properties.my_Equip;
				self.Properties.equipEquipment = "coop_vbot_"..self.vbot_ssid;
			end
			self.bot_child = 1;
		else
			local botqueue = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}; -- 32 empty cells
			local ents = System:GetEntities();
			self.vbot_ssid = 33; -- bot personal id, 33 means first (this num minus 32 real players max) added bot

			-- filling in the cells
			for i, ent in ents do
				if (ent.vbot_ssid) and (ent.Properties.bIsBot) and (ent.Properties.bIsBot==1) then
					botqueue[ent.vbot_ssid-32] = 1;
				end
			end

			-- getting free bot cell
			for i = 1, 32 do
				if (botqueue[i] == 0) then
					self.vbot_ssid = i + 32;
					break;
				end
			end
			if (GameRules.AddPlayerToScoreboard) then
				GameRules:AddPlayerToScoreboard(self.vbot_ssid);
			end
		end
		-- PROP. CACHE
		if (GameRules.MapCheckPoints) then
		--CLASS MP GAME, FORM CLASS PARAMETERS
		local t_bot_bp={};
		local t_bot_class=MultiplayerClassDefiniton.PlayerClasses;

		if (self.Properties.my_class) then
			t_bot_bprnd=self.Properties.my_class;
		end

		if t_bot_bprnd==1 then
			self.sCurrentPlayerClass = "Grunt";
			self.bot_classnum=0; t_bot_class=t_bot_class.Grunt;
		elseif t_bot_bprnd==2 then
			self.sCurrentPlayerClass = "Sniper";
			self.bot_classnum=2; t_bot_class=t_bot_class.Sniper;
		elseif t_bot_bprnd==3 then
			self.sCurrentPlayerClass = "Support";
			self.bot_classnum=1; t_bot_class=t_bot_class.Support;
		end

		self.bot_armor=t_bot_class.armor; self.Properties.max_health=t_bot_class.health;

		t_bot_bprnd=getn(t_bot_class.weapon1);
		if t_bot_bprnd > 0 then t_bot_bprnd=random(1,t_bot_bprnd);
		t_bot_bp[1]={Type="Weapon",Name=t_bot_class.weapon1[t_bot_bprnd]};
		end

		t_bot_bprnd=getn(t_bot_class.weapon2);
		if t_bot_bprnd > 0 then t_bot_bprnd=random(1,t_bot_bprnd);
		if t_bot_class.weapon2[t_bot_bprnd]=="MedicTool" then t_bot_bprnd=2; end
		t_bot_bp[2]={Type="Weapon",Name=t_bot_class.weapon2[t_bot_bprnd]};
		end

		t_bot_bprnd=getn(t_bot_class.weapon3);
		if t_bot_bprnd > 0 then t_bot_bprnd=random(1,t_bot_bprnd);
		if (t_bot_class.weapon3[t_bot_bprnd]=="RL") and (toNumberOrZero(getglobal("gr_norl"))==1) then t_bot_bprnd=1; end
		t_bot_bp[3]={Type="Weapon",Name=t_bot_class.weapon3[t_bot_bprnd]};
		end

		t_bot_bprnd=getn(t_bot_class.weapon4);
		if t_bot_bprnd > 0 then t_bot_bprnd=random(1,t_bot_bprnd);
		t_bot_bp[4]={Type="Weapon",Name=t_bot_class.weapon4[t_bot_bprnd]};
		end

		t_bot_bp.Ammo=t_bot_class.InitialAmmo;
		if self.bot_classnum==0 then 
		t_bot_bp[4].Primary=1;
		elseif self.bot_classnum==1 then
		t_bot_bp[2].Primary=1;
		else t_bot_bp[3].Primary=1; end
		t_bot_bprnd="VBot_ClassBp"..count(EquipPacks);
		EquipPacks[t_bot_bprnd]=t_bot_bp;
		self.currentEquipment=EquipPacks[t_bot_bprnd];
		if (not EquipPacks["bot_emptybp"]) then
		EquipPacks["bot_emptybp"]={}; end
		self.Properties.equipEquipment=t_bot_bprnd;
		self.Properties.equipDropPack="bot_emptybp";
		else
		self.Properties.equipDropPack=MainPlayerEquipPack;

		if (GameRules.InitialPlayerProperties) then
			if (GameRules.InitialPlayerProperties.health) then
			self.Properties.max_health=GameRules.InitialPlayerProperties.health;
			end
			if (GameRules.InitialPlayerProperties.armor) then
			self.bot_armor=GameRules.InitialPlayerProperties.armor;
			end
		end

		end

		if (Game:IsMultiplayer()) then
		if (GameRules.bIsTeamBased) then

		if (not self.bot_team) then
			if (self.Properties.my_color[1]==1) then
			self.bot_team=1; --red
			else
			self.bot_team=2; --blue
			end
		end

		if (self.bot_team==1) then
		self.bot_teamname="red";
		GameRules.bot_common.redsum=GameRules.bot_common.redsum+1;
		else
		self.bot_teamname="blue";
		GameRules.bot_common.bluesum=GameRules.bot_common.bluesum+1;
		end
		if (not self.bot_child) then
			Server:BroadcastText(self:GetName().."$o @HasJoinedTeam "..GameRules.TeamText[self.bot_teamname]);
			System:LogAlways(date("%H:%M:%S").." +Bot: "..self:GetName().." - "..self.bot_teamname);
		end
			if GameRules.bShowUnitHightlight then
				local highlightpos=new(self:GetPos());
				local highlight = Server:SpawnEntity("UnitHighlight",highlightpos);
				self.idUnitHighlight = highlight.id;
				Server:BroadcastCommand("FX "..tonumber(self.id), g_Vectors.v000, g_Vectors.v000,highlight.id,0);
			end
		else -- not team game
		self.bot_team=self.id; --unfriendly players SP
		self.bot_teamname="players";
		GameRules.bot_common.redsum=GameRules.bot_common.redsum+1;
		if (not self.bot_child) then
			Server:BroadcastText(self:GetName().."$o @HasJoinedThe "..GameRules.TeamText["players"]);
			System:LogAlways(date("%H:%M:%S").." +Bot: "..self:GetName());
		end
		end
		self.bot_vbtag=nil;
		self.type = "Player";
		self.classname = "Player";
		Server:AddToTeam(self.bot_teamname,self.id);

		if (GameRules:GetGameState() == CGS_PREWAR) and ((not GameRules.restartbegin) or (GameRules.restartbegin == 0)) then
		setglobal("gr_MinTeamLimit",0); GameRules:Restart(3,1);
		Server:BroadcastText("@GameStartingIn "..(3).." @GameStartingInSeconds", 2); end
		GameRules:SetScoreboardEntryXY(ScoreboardTableColumns.sName,self.vbot_ssid,self:GetName());
		if (GameRules.bIsTeamBased) then
		GameRules:SetScoreboardEntryXY(ScoreboardTableColumns.iPlayerTeam,self.vbot_ssid,self.bot_team);
		else
		GameRules:SetScoreboardEntryXY(ScoreboardTableColumns.iPlayerTeam,self.vbot_ssid,1); end
		if (self.bot_classnum) then
		GameRules:SetScoreboardEntryXY(ScoreboardTableColumns.iPlayerClass,self.vbot_ssid,self.bot_classnum);
		end
		if (self.bot_child) then
			self:SetBotStats(1); -- DON'T reset all values!
		else
			self:SetBotStats();
		end

		--THIRD IS ASSIGN SPECIAL SPAWN PHOENIX TO THE BOT:
		-- Optimized in v1.43
		self.PhoenixData = {};
		end -- MULTIPLAYER ONLY

		-----------
	end
	
	
	
	self:LoadModel();
	BasicPlayer.Server_OnInit( self );
	self:OnReset();
end

----
function Player:Client_OnInit()
	self:LoadModel();
	if (self.hastits) then
		self.deathSounds = {
			{"LANGUAGES/voicepacks/val/death_1.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_2.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_3.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_4.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_6.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_7.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_8.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_9.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_10.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_11.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_12.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_13.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_14.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_15.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_16.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_17.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_18.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_19.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_20.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/death_21.wav",SOUND_UNSCALABLE,190,4,60},
		};
		self.painSounds = {
			{"LANGUAGES/voicepacks/val/pain_10.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/pain_11.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/pain_12.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/pain_13.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/pain_14.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/pain_15.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/pain_16.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/pain_17.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/pain_18.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/pain_19.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/pain_20.wav",SOUND_UNSCALABLE,190,4,60},
			{"LANGUAGES/voicepacks/val/pain_21.wav",SOUND_UNSCALABLE,190,4,60},
		};
		self.LandHardSounds = {
			{"SOUNDS/player/heavy_fall_fem.wav",0,175,3,30},
		};
		self.BleedSounds = {
			{"Sounds/player/bleed_fem_1.wav",0,175,3,30},
			{"Sounds/player/bleed_fem_2.wav",0,175,3,30},
		};
		self.CoughSnd = {
			{"Objects/weapons/salo/fcough1.wav",0,175,3,30},
			{"Objects/weapons/salo/fcough2.wav",0,175,3,30},
		};
	end
	BasicPlayer.Client_OnInit(self);
	------ Mixer: extended dirty hack (client-side) to prevent incorrect swinging rate of weapon model for first-person player
	if (not Game:IsServer()) then
		if (self.currgamestyle) and (GameStyler) and (tonumber(self.currgamestyle) > 0) and (GameStyler.playermoves[tonumber(self.currgamestyle)]) then
			self.cnt:SetMoveParams(GameStyler.playermoves[tonumber(self.currgamestyle)].move_params);
			--if (_localplayer) and (_localplayer.cnt) and (self ~= _localplayer) and (_localplayer.move_params) then
			--	_localplayer.cnt:SetMoveParams(GameStyler.playermoves[tonumber(self.currgamestyle)].move_params);
			--end
		else
			self.cnt:SetMoveParams(self.move_params);
			--if (_localplayer) and (_localplayer.cnt) and (self ~= _localplayer) and (_localplayer.move_params) then
			--	_localplayer.cnt:SetMoveParams(_localplayer.move_params);
			--end
		end
	end
	------
end

----
function Player:PlaySpawnFx(poz)
	if (self.cis_spawn_effect) then
		Particle:SpawnEffect(poz,g_Vectors.v001,'misc.sparks.a',10);
		self.cis_spawn_effect = nil;
	end
end

function Player:Client_OnRemoteEffect(toktable, pos, normal, userbyte)
--	System:Log("_FX: Setting effect: "..tostring(self.id).."("..tostring(userbyte)..")");
	if (userbyte == 0) then
		-- set second shader to none
		BasicPlayer.SecondShader_None(self);		
		--self:PlaySpawnFx(pos);
	elseif (userbyte == 1) then
		-- set second shader to apply team coloring
		BasicPlayer.SecondShader_TeamColoring(self);
		self:PlaySpawnFx(pos);
	elseif (userbyte == 2) then
		-- turn on invulnerability
		BasicPlayer.SecondShader_Invulnerability(self,1,1,1,1);		
		self:PlaySpawnFx(pos);
	elseif (userbyte == 3) then						-- target is alive 
		if (Game:IsMultiplayer()) then
			local hit = {};
			hit.pos = pos;
			hit.normal = normal;
			hit.target_material = Materials["mat_flesh"];
			-- might be invulnerable!!
			if (self.iPlayerEffect ~= 3) then
				ExecuteMaterial_Particles( hit , "bullet_hit");
			end
			
			if(self == _localplayer) then
				Hud:PlayMultiplayerHitSound();
			end
		end
		if(self == _localplayer) then
			Hud.hit=5;
		end
	elseif (userbyte == 4) then
		if (getglobal("gr_gamestyle")~=nil) and (GameStyler) and (Game:IsServer()==nil) then
			self.currgamestyle = getglobal("gr_gamestyle");
			GameStyler:ApplyGameStyle(self,tonumber(self.currgamestyle),self.Properties.bIsBot);
		end
	elseif (userbyte == 5) then -- go invisible
		BasicPlayer.SecondShader_Invisibility(self);
		if (self == _localplayer) then
			BasicPlayer.PlayInteractSound(_localplayer,"Sounds/player/playermovement/gingle3.wav");
		end
		if (Game:IsServer()==nil) then
			self.items.invis_active = _time + pos.x;
		end
	elseif (userbyte == 6) then -- go rage
	elseif (userbyte == 7) then -- update inventory
		if (Game:IsMultiplayer()) then
			pos.x = floor(pos.x);
			pos.y = floor(pos.y);
			pos.z = floor(pos.z);
			if (pos.x == 0) then
				self.keycards = {};
			else
				local k1 = mod(pos.x,10);
				if (k1 > 0) then
					self.keycards[4]=1;
				else
					self.keycards[4]=0;
				end
				k1 = mod(floor(pos.x/10),10);
				if (k1 > 0) then
					self.keycards[3]=1;
				else
					self.keycards[3]=0;
				end
				k1 = mod(floor(pos.x/100),10);
				if (k1 > 0) then
					self.keycards[2]=1;
				else
					self.keycards[2]=0;
				end
				k1 = mod(floor(pos.x/1000),10);
				if (k1 > 0) then
					self.keycards[1]=1;
				else
					self.keycards[1]=0;
				end
			end
			if (pos.y == 0) then
				self.explosives = {};
			else
				if (self.explosives) and (pos.y > 0) then
					local exp_id = 0;
					while exp_id < pos.y do
						exp_id = exp_id + 1;
						self.explosives[exp_id] = 1;
					end
				end
			end
			local k1 = mod(pos.z,10);
			if (k1 > 0) then
				self.cnt:GiveBinoculars(1);
			end
			k1 = mod(floor(pos.z/10),10);
			if (k1 > 0) and (self.items) then
				self.items.heatvisiongoggles = 1;
			end
			k1 = mod(floor(pos.z/100),10);
			if (k1 > 0) then
				self.cnt:GiveFlashLight(1);
			end
		end
	end
end

function Player:ChangeEnergy( Units )
	self.EnergyChanged = 1;
	self.Energy = self.Energy + Units;
	if (self.Energy > self.MaxEnergy) then
		self.Energy = self.MaxEnergy;
	end
	if (self.Energy < 0) then
		self.Energy = 0;
	end
end

--------
function Player:OnLoad(stm)
	self.JustLoaded=1;	-- [lennert] this is a dirty hack because OnReset is called after OnLoad for not very clear reasons; this should be fixed !
	BasicPlayer.OnLoad(self,stm);
	self.keycards=ReadFromStream(stm);
	self.explosives=ReadFromStream(stm);
	self.items=ReadFromStream(stm);
	self.objects=ReadFromStream(stm);
	if (self.items.curr_gs) then
		setglobal("gr_gamestyle",tostring(self.items.curr_gs));
		self.items.curr_gs = nil;
	elseif (self.Properties.bIsBot) and (self.Properties.bIsBot == 0) then
		setglobal("gr_gamestyle",0);
	end
	if (self.items.curr_bl) then
		setglobal("gr_bleeding",self.items.curr_bl);
		self.items.curr_bl = nil;
	end
	self.bDirtyLoadFlag = 1; -- Mixer: this is used to dirty-check if player is loaded to not to update saved first checkpoint saved game creration date in savegame datbase (default/clientstuff.lua)
	self.bDirtyLoadPos = new(self:GetPos());
	--self:SetPos({x=-1000,y=-1000,z=1000});
end

--------------
function Player:OnSave(stm)
	BasicPlayer.OnSave(self,stm);
	WriteToStream(stm,self.keycards);
	WriteToStream(stm,self.explosives);
	local curr_gs = getglobal("gr_gamestyle");
	if (curr_gs) and (self.Properties.bIsBot) and (self.Properties.bIsBot == 0) then
		self.items.curr_gs = tonumber(curr_gs);
	end
	local curr_bl = getglobal("gr_bleeding");
	if (curr_bl) and (self.Properties.bIsBot) and (self.Properties.bIsBot == 0) then
		self.items.curr_bl = tonumber(curr_bl);
	end
	WriteToStream(stm,self.items);
	WriteToStream(stm,self.objects); 
end

----------

function Player:OnSaveOverall(stm)
	BasicPlayer.OnSaveOverall(self, stm);
end

----------

function Player:OnLoadOverall(stm)
	BasicPlayer.OnLoadOverall(self, stm);
end	


------
Player.Server =
{
	OnEvent = BasicPlayer.Server_OnEvent,
	OnInit = Player.Server_OnInit,
	OnShutDown = BasicPlayer.Server_OnShutDown,	
	Alive = {
		OnBeginState = function( self )
			self:NetPresent(1);
		end,
		OnEvent = BasicPlayer.Server_OnEvent,
		OnDamage = function (self, hit)
			if (self.POTSHOTS) then
				if (hit.shooter) then
					AIBehaviour.TestBotIdle:OnKnownDamage(self,hit.shooter);
				else
					AI:Signal(0,1,"OnReceivingDamage",self.id);
				end
			end
			BasicPlayer.Server_OnDamage( self, hit );
		end,
		OnUpdate = function( self )
			if (self.currgamestyle) then
				if (self.currgamestyle ~= getglobal("gr_gamestyle")) or (self.gs_fallscale and self.gs_fallscale ~= self.cnt.fallscale) then
					if (self.GetPos) then -- fix: make sure the player already properly activated (to skip applying at first update)
						self.currgamestyle = getglobal("gr_gamestyle");
						GameStyler:ApplyGameStyle(self,tonumber(self.currgamestyle),self.Properties.bIsBot);
						Server:BroadcastCommand("FX", {x=self.currgamestyle,y=0,z=0}, {x=0,y=0,z=0},self.id,4);
					end
				end
				if (self.regenerateHealthRate) and (self.cnt.health < self.cnt.max_health) then
					if (self.regenerateLastTimer) then
						if (self.regenerateLastTimer < _time) then
							self.regenerateLastTimer = _time + 0.5;
							self.cnt.health=self.cnt.health+self.regenerateHealthRate+1;
							if (self.cnt.health > self.cnt.max_health) then
								self.cnt.health = self.cnt.max_health * 1;
							end
						end
					else
						self.regenerateLastTimer = _time;
					end
					
				end
			end
			if (self.items.invis_active) then
				if (self.items.invis_active <= 0) then
					self.items.invis_active = nil;
					self.lastinvis_tick = nil;
					Server:BroadcastCommand("FX", {x=0,y=0,z=0}, {x=0,y=0,z=0},self.id,1);
					if (not Game:IsMultiplayer()) then
						local tblPlayers = { };
						if (_localplayer.type=="Player" and _localplayer:GetPos()) then
							local LocalPlayerPos=_localplayer:GetPos();						
							Game:GetPlayerEntitiesInRadius(LocalPlayerPos, 999999, tblPlayers, 1);
						else
							local LocalPlayerPos={ x=0, y=0, z=0};
							Game:GetPlayerEntitiesInRadius(LocalPlayerPos, 999999, tblPlayers, 1);
						end		
						if (tblPlayers and type(tblPlayers)=="table") then
							for i, player in tblPlayers do		
								if (tblPlayers[i].pEntity) and (tblPlayers[i].pEntity.ai) then
									tblPlayers[i].pEntity:ChangeAIParameter(AIPARAM_SIGHTRANGE, tblPlayers[i].pEntity.PropertiesInstance.sightrange);
									tblPlayers[i].pEntity:ChangeAIParameter(AIPARAM_SOUNDRANGE, tblPlayers[i].pEntity.PropertiesInstance.soundrange);
									tblPlayers[i].pEntity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,tblPlayers[i].pEntity.Properties.responsiveness);	
								end				
							end											
						end
					end
				else
					if (not self.lastinvis_tick) then
						self.lastinvis_tick = 0;
					end
					
					local invis_mod = mod(self.items.invis_active,1);
					local time_mod = mod(_time,1);
					if (invis_mod > time_mod) then
						self.items.invis_active = floor(self.items.invis_active)-1;
					else
						self.items.invis_active = floor(self.items.invis_active) + time_mod;
					end
					
					if (self.bDirtyLoadFlag) and (self.bDirtyLoadFlag == 1) then -- loaded, no shader updated
						BasicPlayer.SecondShader_Invisibility(self);
						self.bDirtyLoadFlag = 0; -- loaded, and shader updated
					end
					
					if (self.lastinvis_tick < _time) then
						self.lastinvis_tick = _time + 3;
						if (not Game:IsMultiplayer()) then
							local tblPlayers = { };
							if (_localplayer.type=="Player" and _localplayer.GetPos) then
								local LocalPlayerPos=_localplayer:GetPos();
								Game:GetPlayerEntitiesInRadius(LocalPlayerPos, 999999, tblPlayers, 1);
							else
								local LocalPlayerPos={ x=0, y=0, z=0};
								Game:GetPlayerEntitiesInRadius(LocalPlayerPos, 999999, tblPlayers, 1);
							end	
							if(tblPlayers and type(tblPlayers)=="table") then
								for i, player in tblPlayers do			
									if (tblPlayers[i].pEntity) and (tblPlayers[i].pEntity.ai) then
										tblPlayers[i].pEntity:ChangeAIParameter(AIPARAM_SIGHTRANGE, 3);
										tblPlayers[i].pEntity:ChangeAIParameter(AIPARAM_SOUNDRANGE, 10);
										tblPlayers[i].pEntity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,tblPlayers[i].pEntity.Properties.responsiveness*3);
									end
								end
							end
						end
					end
				end
			end
			
			if (self.Properties.bIsBot ~= 0) then
				-- check this only if aready teleported to destination
				if (self:GetPos().z < 0.12) and (self.bot_killstreak) then
					if (self.cnt.health > 0) then
						if (Mission) and (Mission.no_bot_kill_on_zero_height) then
						else
							local hit = {
								dir = {x=0, y=0, z=1},
								damage = 10000,
								target = self,
								shooter = self,
								landed = 1,
								impact_force_mul_final=5,
								impact_force_mul=5,
								damage_type = "normal",
							};
							self:Damage(hit);
						end
					end
				end
				if (self.invulnerabilityTimer) and (self.invulnerabilityTimer<_time) then
					self.invulnerabilityTimer=nil;
					Server:BroadcastCommand("FX", {x=0,y=0,z=0}, {x=0,y=0,z=0},self.id,1);
				end

				if self.vb_wpntimer < _time then
					self.vb_wpntimer = _time + 2.6;

					if (self.theVehicle) then
						-- Mixer: hack for bots to DRIVE the vehicles :)
						self.vb_lastvehicletme = _time + 12.6;
						self:ChangeAIParameter(AIPARAM_SIGHTRANGE,self.PropertiesInstance.sightrange);
						self:ChangeAIParameter(AIPARAM_ATTACKRANGE,self.Properties.attackrange);
						if (self.theVehicle.driverT) then
							if (self.theVehicle.driverT.entity) then
								if (self.theVehicle.driverT.entity == self) then
									if (GameRules.tr_light_state) and (GameRules.tr_light_state ~= 3) then
										-- for RACING gametype, stay on the start point until green (3) state of traffic light
										if (self.ncp == nil) or (self.ncp == 1) then
											return;
										end
									end
									local fVehSpd = self.theVehicle.cnt:GetVehicleVelocity();
									if (fVehSpd) and (fVehSpd < 0.3) and (self.theVehicle.Properties.pathstart) then
										self.theVehicle.curPathStep = self.theVehicle.Properties.pathstart-1;
										VC.AIDriver(self.theVehicle,1);
										AI:Signal(0, 1, "GO_PATH", self.theVehicle.id);
										self.theVehicle.EventToCall = "next_point";
									end
									return;
								end
							else
								-- no driver here. let's get away.
								self.cnt.use_pressed = 1;
							end
						end
					end
					
					if (GameRules.soccerball) then
						AIBehaviour.TestBotIdle:OnSoccerGame(self);
						return;
					end
					
					-- additional anti-stuck code:
					if (not self.cnt.moving) and (self.theVehicle == nil) then
						if (self.Properties.max_health == 1) then
							-- test feature for mappers to check ai passability for areas. bot will follow the player constantly
							self:SelectPipe(0,"val_follow");
						elseif (self.POTSHOTS == 1) then
							AI:Signal(0,1,"OnSpawn",self.id); -- first-time-after-spawn action
							self.POTSHOTS = 0; -- Mixer: please never set it to nil;
						else
							AI:Signal(0,1,"OnNoHidingPlace",self.id);
						end
					end
					
					-- Mixer: weapon checking moved here
					-- weapon switching system
					if (not self.current_mounted_weapon) and (not self.cnt:IsSwimming()) then
						local botequipment = self.cnt:GetWeaponsSlots();
						if (botequipment) then
							local decentselect = "";
							local decentdist = 0;
							for i,val in botequipment do
								if (val~=0) then
									-- get ammo in pocket
									local candidate_ammo = 0;
									if (val.FireParams[1].AmmoType) and (val.FireParams[1].AmmoType ~= "Unlimited") then
										candidate_ammo = self.Ammo[val.FireParams[1].AmmoType];
									else
										candidate_ammo = 1;
									end

									-- get idx (ammo in clip)
									if (self.cnt.weapon) and (self.cnt.weapon.name == val.name) then
										candidate_ammo = self.cnt.ammo + self.cnt.ammo_in_clip;
									else
										if (self.WeaponState[WeaponClassesEx[val.name].id]) and (self.WeaponState[WeaponClassesEx[val.name].id].AmmoInClip) then
											candidate_ammo = candidate_ammo + self.WeaponState[WeaponClassesEx[val.name].id].AmmoInClip[1];
										end
									end

									if (not val.FireParams[1].distance) and (candidate_ammo > 0) and (toNumberOrZero(getglobal("gr_norl"))~=1) then
										self.cnt.aiming = 1;
										self.cnt.aimtimesvr = 5;
										decentdist = 999;
										decentselect = val.name.."";
									elseif (val.FireParams[1].distance) then
										local c_dist = 0;
										if (not self.fireparams) or (not self.fireparams.distance) or (self.cnt.ammo + self.cnt.ammo_in_clip <= 0) then
											-- fixed: force to choose any other gun if current is empty
										else
											c_dist = self.fireparams.distance * 1;
										end
										if (val.FireParams[1].distance > c_dist) and (val.FireParams[1].distance > decentdist) and (candidate_ammo > 0) then
											-- this wpn seems to better then current
											decentdist = val.FireParams[1].distance * 1;
											decentselect = val.name.."";
										end
									end
								end
							end -- for
							if (decentselect~="") and (self.cnt.weapon) and (self.cnt.weapon.name ~= decentselect) then
								self.WeaponState[WeaponClassesEx[self.cnt.weapon.name].id].AmmoInClip[1] = self.cnt.ammo_in_clip*1;
								self.cnt:SetCurrWeapon(WeaponClassesEx[decentselect].id);
							else
								if (self.fireparams) and (self.cnt.ammo + self.cnt.ammo_in_clip > 0) then
									if (self.fireparams.distance) and (self.go2friend == nil) then
										self:ChangeAIParameter(AIPARAM_ATTACKRANGE,self.fireparams.distance);
										if (System:GetFogEnd() < self.fireparams.distance) then
											self:ChangeAIParameter(AIPARAM_SIGHTRANGE,System:GetFogEnd() * 1.3);
										else
											self:ChangeAIParameter(AIPARAM_SIGHTRANGE,self.fireparams.distance * 1.3);
										end
									elseif (self.go2friend == nil) then -- the same for rl-like weapons (without distance param)
										if (System:GetFogEnd() < self.PropertiesInstance.sightrange) then
											self:ChangeAIParameter(AIPARAM_SIGHTRANGE,System:GetFogEnd() * 1.3);
										else
											self:ChangeAIParameter(AIPARAM_SIGHTRANGE,self.PropertiesInstance.sightrange);
										end
										self:ChangeAIParameter(AIPARAM_ATTACKRANGE,self.Properties.attackrange);
									end
								else
									for i,val in botequipment do
										if(val~=0) then
											local candidate_ammo = val.FireParams[1].AmmoType;
											if (candidate_ammo) and (candidate_ammo == "Unlimited") then
												self.cnt:SetCurrWeapon(WeaponClassesEx[val.name].id);
												break;
											end
										end
									end -- for
								end
							end
						end -- if botequipment
					end
				end
			elseif (self.timetodie) then
				self:DrawCharacter(0,0);
				System:ExecuteCommand("kill");
				self.timetodie=nil;
			--Mixer: FCAM JUDGE inactivity check:
			elseif (self.LastActivityTime) then
				self:CheckMeForActivity();
			end
			BasicPlayer.Server_OnTimer(self);
		end,
		
		--pushing stuff
		OnContact = function(self,contact)
			BasicPlayer.PlayerContact(self,contact,1);
		end,
	},
	Dead = {
		OnBeginState = function( self )
			local weapon = self.cnt.weapon;
			if (weapon) then
				self.cnt:DeselectWeapon();
			end
			BasicPlayer.MakeDeadbody(self);
			self:NetPresent(nil);
			if (self.items.invis_active) then
				Server:BroadcastCommand("FX", {x=0,y=0,z=0}, {x=0,y=0,z=0},self.id,1);
				local pickup = self:GetPos();
				pickup.z = pickup.z + 1.05;
				pickup = Server:SpawnEntity("Gear_Invisibility",pickup);
				if (pickup) then
					pickup.Properties.Amount = ceil(self.items.invis_active);
					if (GameRules.GetPickupFadeTime) then
						pickup:SetFadeTime(GameRules:GetPickupFadeTime());
					end
					pickup.autodelete = 1;
					pickup:EnableSave(0);
					pickup:GotoState("Dropped");
				end
				self.items.invis_active = nil;
			end
		end,
		OnEvent = BasicPlayer.Server_OnEventDead,
		OnUpdate = function(self)
			if (self.Properties.bIsBot ~= 0) then
				if (not self.bot_raise_time) then
					if (GameRules.respawnCycle) and (floor(toNumberOrZero(getglobal("gr_RespawnTime")))~=0) then
						self.bot_raise_time = _time+GameRules.respawnCycleTimer;
					else
						self.bot_raise_time = _time+random(3,7);
					end
					if (Game:IsClient()==nil) then self:EnablePhysics(0); end
				elseif (self.bot_raise_time < _time) then
					self.bot_raise_time = nil;
					self:OnReset();
				end
			elseif (self.LastActivityTime) then
				self:CheckMeForActivity();
			end
		end,
		OnEndState = function( self )
		end,
		OnTimer = BasicPlayer.Server_OnTimer,
	},
}

-----
Player.Client =
{
--	OnTimer = BasicPlayer.Client_OnTimer,
	OnInit = Player.Client_OnInit,
	OnRemoteEffect = Player.Client_OnRemoteEffect,
	OnShutDown = function( self )
		local bpos = self:GetBonePos("Bip01 Spine");
		if (not bpos) then
			bpos = self:GetPos();
		end
		Particle:SpawnEffect(bpos,g_Vectors.v001,'misc.sparks.a',10);
		BasicPlayer.Client_OnShutDown(self);
	end,
	Alive = {
		OnUpdate = BasicPlayer.Client_OnTimer,
		OnBeginState = function( self )
			BasicPlayer.OnBeginAliveState(self);
			if ( self== _localplayer) then
				Input:SetActionMap("default");
--				System:LogToConsole("ClientAliveState MY player");
				self.AnimationSystemEnabled = 1;
				self:EnablePhysics(1);
				if (Hud) then
					Hud.deaf_time=nil;
				end
			end
--			System:LogToConsole("ClientAliveState");
		end,
		OnEndState = function( self )
		end,
		OnDamage = BasicPlayer.Client_OnDamage,
		OnEvent = function (self,EventId,Params)
			local EventSwitch=self.EventHandlers[EventId];
			if(EventSwitch)then
				EventSwitch(self,EventId,Params);
			else
				BasicPlayer.Client_OnEvent(self,EventId,Params);
			end
		end,
		
		--pushing stuff
		OnContact = function(self,contact)
			BasicPlayer.PlayerContact(self,contact,0);
		end,
	},
	Dead = {
		OnBeginState = function( self )
			BasicPlayer.OnBeginDeadState(self);
			self.cnt.health=0;		-- server might not send this info
			if self == _localplayer then
				ClientStuff.vlayers:DeactivateAll();
				-- disable the flashbang effect when the player dies
				System:SetScreenFx("FlashBang", 0);
				if not Game:IsServer() and self.items then
					self.items.invis_active = nil;
				end
				if Hud then
					Hud.deaf_time=nil;
				end
				if not Game:IsMultiplayer() then	
					Hud:OnMiscDamage(10000);					
					Hud:SetScreenDamageColor(0.9, 0.8, 0.8);
					
					System:SetScreenFx("ScreenFade",1);
					System:SetScreenFxParamFloat("ScreenFade","ScreenFadeTime",GameRules.TimeRespawn*1.2);
				else
					if ClientStuff.lst_bgmsndid then
						Hud.dtharea_id = {floor(ClientStuff.lst_bgmsndid[1]),ClientStuff.lst_bgmsndid[2]};
						ClientStuff.lst_bgmsndid = nil;
					end
				end
				Input:SetActionMap("default");
			end
			BasicPlayer.MakeDeadbody(self);
			-- stop breathing sound in case it is still playing...
			if self.ExhaustedBreathingSound then
				Sound:StopSound(self.ExhaustedBreathingSound);
			end
			
			self:SetTimer(self.UpdateTime);
			self:SetScriptUpdateRate(0);
		end,
		OnUpdate = BasicPlayer.Client_DeadOnUpdate,
		OnEndState = function( self )
		end,
		OnDamage = BasicPlayer.Server_OnDamageDead,
		OnTimer = BasicPlayer.Client_OnTimerDead,
	},
}

--------------------------------------------------------------------
-- Items switch
Player.ItemActivation={
	-------------------------------
	[0]=function(self)
		if (self ~= _localplayer) then return end
		
		-- no binoculars if using mounted weapon
		if (self.cnt.has_binoculars == 1 and (not self.current_mounted_weapon) and
			  (not self.cnt:IsSwimming()) and not self.cnt.reloading) then
			if(ClientStuff.vlayers:IsActive("Binoculars"))then
				ClientStuff.vlayers:DeactivateLayer("Binoculars");				
				--ClientStuff.vlayers:DeactivateLayer("HeatVision");
			else
				if(ClientStuff.vlayers:IsActive("WeaponScope") or ClientStuff.vlayers:IsFading("WeaponScope"))then
					ClientStuff.vlayers:DeactivateLayer("WeaponScope",1);
				end
				ClientStuff.vlayers:ActivateLayer("Binoculars");
			end
		end
	end,
	-------------------------------
	[1]=function(self)
		if (self ~= _localplayer) then return end
				
		-- todo: handle screen refraction only when finished the fx										
		if (self.items.heatvisiongoggles and (not self.cnt:IsSwimming())) then	
			if (self.cVstate) and (self.cVstate==0) and (ClientStuff.vlayers:IsActive("HeatVision")) then
				GameStyler:GS_crazyState(self,1);
				return;
			end
			if (not self.cVstate) and (ClientStuff.vlayers:IsActive("HeatVision")) then
				ClientStuff.vlayers:DeactivateLayer("HeatVision");				
			else
				if (self.cVstate) and (self.cVstate==1) and (self.Energy > self.MinRequiredEnergy or ClientStuff.vlayers:IsActive("Binoculars")) then
					GameStyler:GS_crazyState(self,0);
					return;
				end
				if (not self.cVstate) and (self.Energy > self.MinRequiredEnergy or ClientStuff.vlayers:IsActive("Binoculars")) then
				  -- activate cryvision
				  ClientStuff.vlayers:ActivateLayer("HeatVision");				  
				end
			end
		end
		
	end,
}
-----------
-- Events switch
Player.EventHandlers={
	-------------------
	[ScriptEvent_ZoomToggle] = function(self,EventId,Params)
		if (self ~= _localplayer) then return end
		local stats = self.cnt;
		local weapon = stats.weapon;				
		if (weapon and (not weapon.NoZoom) and (not stats.reloading)) then
			-----
			if (weapon.ZoomAsAltFire) and (Params==1) then
				if (weapon:ZoomAsAltFire(self) == nil) then
					return;
				end
			end
			----
			local dead_switch = weapon.ZoomDeadSwitch;
			if (stats.first_person and not self.fireparams.no_zoom) then
				if (ClientStuff.vlayers:IsActive("WeaponScope"))then
					if (((Params==0 or Params==2) and (not dead_switch))
						or ( (Params==1 or Params==2) and dead_switch)) then
						ClientStuff.vlayers:DeactivateLayer("WeaponScope");						
					end
				elseif (not stats:IsSwimming()) then
					if(Params==1 and ((not stats.running or self.theVehicle) or weapon.AimMode==1)) then
						if(ClientStuff.vlayers:IsActive("Binoculars"))then
							ClientStuff.vlayers:DeactivateLayer("Binoculars",1);
						end
						if (not ClientStuff.vlayers:IsFading("WeaponScope")) then
							ClientStuff.vlayers:ActivateLayer("WeaponScope");
						end
					end										
				end
			end
		elseif (Params==1) then
			if (self.items) and (self.items.gr_item_id) then
				if (not self.items.gr_item_ang) then
					self.items.gr_item_ang = 90;
				else
					if (self.items.gr_item_ang >= 270) then
						self.items.gr_item_ang = 0;
					else
						self.items.gr_item_ang = self.items.gr_item_ang + 90;
					end
				end
				if (not Game:IsServer()) then
					Client:SendCommand('VB_GV 1 '..self.items.gr_item_ang);
				end
			end
		end
	end, 
	---------------------
	[ScriptEvent_ZoomIn] = function(self,EventId,Params)
		if (self ~= _localplayer) then return end
		ZoomView:ZoomIn();
	end,
	-------------------------------
	[ScriptEvent_ZoomOut] = function(self,EventId,Params)
		if (self ~= _localplayer) then return end
		ZoomView:ZoomOut();
	end,
	-------------------------------
	[ScriptEvent_ItemActivated] = function(self,EventId,Params)
		local ItemSwitch=self.ItemActivation[Params];
		if(ItemSwitch)then
			ItemSwitch(self);
		end
	end,
	-------------------------------
	[ScriptEvent_Deafened] = function(self,EventId,Params)
		if (self==_localplayer and Hud~=nil) then
			if (Hud.deaf_time) then
				if (Hud.deaf_time<Params.fTime) then
					Hud.deaf_time=Params.fTime;
				end
			else
				Hud.deaf_time=Params.fTime;
			end
			Hud.initial_deaftime=Hud.deaf_time;

--			System:LogToConsole("Deafened for "..Hud.deaf_time.." seconds...");
		end
	end,
	[ScriptEvent_SelectWeapon]=function (self,eventid,Params)
		if(Hud and self == _localplayer)then
			Hud.weapons_alpha=1;
			--BasicPlayer.ProcessPlayerEffects(self);
		end
		BasicPlayer.Client_OnEvent(self,EventId,Params);
	end,
}
--------------------------------------------------------------------------------------------------------