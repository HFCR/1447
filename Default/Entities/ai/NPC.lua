NPC = {
	-- To make npc a trader, create a tag point named npcname_TRADE somewhere on your map
	-- Place this NPC in inaccessible spot of the SURVIVAL map
	-- To relocate from there, use npcname_RELOCATE tag point, by placing it in the desired location, so NPC will be relocated by request of SURVIVAL gamerules :)
	isvillager = {x=0.01,y=0.01,z=0.01},
	assault_score = 0,
	bot_born = 74,
	PropertiesInstance = {
		sightrange = 50,
		soundrange = 8,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		groupid = 0,
		aibehavior_behaviour = "Job_PatrolPathNoIdle",
		bHelmetOnStart = 0,
		fileHelmetModel = "",
		bGunReady = 0,
		},

	Properties = {
		bInvulnerable = 0,
		KEYFRAME_TABLE = "BASE_HUMAN_MODEL",
		SOUND_TABLE = "villager",
		fStart_armor = 0,
		bSleepOnSpawn = 1,
		bHasArmor = 1,
		special = 0,
		aggression = 0.9,	-- 0 = passive, 1 = total aggression
		commrange = 26.0,
		attackrange = 93,
		horizontal_fov = 160,
		forward_speed = 1.27,
		back_speed = 1.27,
		max_health = 243,
		accuracy = 0.9,
		species = 0,
		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,
		equipEquipment = "",
		equipDropPack = MainPlayerEquipPack,
		AnimPack = "Basic",
		SoundPack = "Crowe",
		aicharacter_character = "Crowe",
		pathname = "",
		pathsteps = 0,
		pathstart = 0,
		ReinforcePoint = "",
		fileModel = "Objects/characters/mercenaries/Merc_sniper/merc_sniper.cgf",
		bTrackable=1,
speed_scales={
run	=3.8,
crouch	=.8,
prone	=.5,
xrun	=3.8,
xwalk	=2.8,
rrun	=3.8,
rwalk	=2.8,
},
AniRefSpeeds = {
WalkFwd = 1.5,
WalkSide = 1.5,
WalkBack = 1.5,
XWalkFwd = 1.5,
XWalkSide = 1.5,
XWalkBack = 1.5,	
XRunFwd = 4.5,
XRunSide = 3.5, 
XRunBack = 4.5,		
RunFwd = 4.8,
RunSide = 4.8,
RunBack = 4.8,
CrouchFwd = 1.02,
CrouchSide = 1.02,
CrouchBack = 1.02,
},
},
	painSounds = {
		{"SOUNDS/e3ai/pain/pain1.wav",SOUND_UNSCALABLE,160,3,30},
		{"SOUNDS/e3ai/pain/pain2.wav",SOUND_UNSCALABLE,160,3,30},
		{"SOUNDS/e3ai/pain/pain3.wav",SOUND_UNSCALABLE,160,3,30},
		{"SOUNDS/e3ai/pain/pain4.wav",SOUND_UNSCALABLE,160,3,30},
		{"SOUNDS/e3ai/pain/pain5.wav",SOUND_UNSCALABLE,160,3,30},
	},
	deathSounds = {
		{"SOUNDS/e3ai/death/ahhhggg.wav",SOUND_UNSCALABLE,160,4,30},
		{"SOUNDS/e3ai/death/arg.wav",SOUND_UNSCALABLE,160,4,30},
		{"SOUNDS/e3ai/death/ohhhh.wav",SOUND_UNSCALABLE,160,4,30},
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
PhysParams = {
mass = 80,
height = 1.8,
eyeheight = 1.6,
sphereheight = 1.2,
radius = 0.45,
},
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
}

function NPC:OnInitCustom()
	self.isvillager = new(self:GetPos());
	self.Properties.bAffectSOM = 1;
	self.smell_factor = self.Properties.commrange*1;
	self.Properties.responsiveness = 7;
	self.Properties.eye_height = 2.1;
	if (GameRules.vnpc_child) then
		self.Properties.fileModel = self.cnt.model;
		GameRules.vnpc_child = nil;
	else
		self.cnt.model = self.Properties.fileModel.."";
	end
end

function NPC:GetPlayerId()
	return self.id;
end

function NPC:MakeRandomIdleAnimation()
end

function NPC:MakeMissionConversation()
	return 1;
end

-- This function is called by pickup items and used by bots
function NPC:OnPickSomething()
	if (self.cnt) and (self.cnt.GetWeaponsSlots) then
		local ws = self.cnt:GetWeaponsSlots();
		if (ws) then
			for i,val in ws do
				if (val~=0) then
					if (val.FireParams) and (val.FireParams[1]) and (self.fireparams) and (self.fireparams.bullets_per_clip) and (val.FireParams[1].bullets_per_clip) then
						if (self.fireparams.bullets_per_clip < val.FireParams[1].bullets_per_clip) then
							self.cnt:SetCurrWeapon(WeaponClassesEx[val.name].id);
							break;
						end
					end
				end
			end
		end
	end
end

function NPC:JustStayHere()
	if (self.theVehicle) then
		if (self.my_leader) then
			-- change my leader to driver
			if (self.theVehicle.driverT.entity) and (self.theVehicle.driverT.entity.id ~= self.id) then
				self.my_leader = self.theVehicle.driverT.entity.id;
				return;
			-- change my leader to gunner
			elseif (self.theVehicle.gunnerT) and (self.theVehicle.gunnerT.entity) and (self.theVehicle.gunnerT.entity.id ~= self.id) then
				self.my_leader = self.theVehicle.gunnerT.entity.id;
				return;
			end
			-- get out of here
			VC.DropPeople(self.theVehicle);
		end
	end
	self.my_leader = nil;
	self:SelectPipe(0,"observe_direction");
	self:TriggerEvent(AIEVENT_CLEAR);
	self:ChangeAIParameter(AIPARAM_ATTACKRANGE,self.Properties.attackrange);
	self:ChangeAIParameter(AIPARAM_FWDSPEED,0);
end

function NPC:OnReset()
if (Game:IsMultiplayer()) then
self.PhoenixData = {pos = self.isvillager,angles = g_Vectors.v000,};
if (self.cnt.health <= 0) then
	GameRules.vnpc_child = 1;
	self.Properties.bTrackable=1;
	local myclone=Server:SpawnEntity({classid=self.bot_born,pos=self.isvillager,name=self:GetName(),model=self.Properties.fileModel,properties=self.Properties});
	if (myclone) then
	myclone.my_potomok = 1;
	if (self.Properties.equipEquipment~="") then
		myclone.Properties.equipEquipment = self.Properties.equipEquipment;
		myclone.cnt:MakeWeaponAvailable(WeaponClassesEx[myclone.Properties.equipEquipment].id);
		myclone.cnt:SetCurrWeapon(WeaponClassesEx[myclone.Properties.equipEquipment].id);
	end
	end
	Server:RemoveEntity(self.id,1);
	self = nil;
	return;
end
end
BasicAI.OnReset(self);
self.ai = nil;
self.my_leader = nil;
self.bot_killstreak = 0;
self.istrader = nil;
self:Event_Activate();
self.smell_factor = self.Properties.commrange*1;
self.cnt.health = self.Properties.max_health;
self.cnt.max_health = self.Properties.max_health;
self.cnt.max_armor = 100;

if (self.Properties.fStart_armor < 100) then
	self.cnt.armor = self.Properties.fStart_armor;
else
	self.cnt.armor = 100;
end

if (Mission) and (Mission[self:GetName()]~=nil) then
	local tr_npc_dt = System:GetEntityByName("_NPC_STORE");
	if (tr_npc_dt) and (tr_npc_dt.AddBuyServerStuff) then
		tr_npc_dt:AddBuyServerStuff();
		self.istrader = 1;
	end
end

self.vnpc_s_timer = _time + 8;
self.vnpc_f_timer = 0;
self.vnpc_d_timer = _time + 1;
self.vnpc_health = -1;

if (self.Properties.equipEquipment~="") and (WeaponClassesEx[self.Properties.equipEquipment]) then
	self.cnt:MakeWeaponAvailable(WeaponClassesEx[self.Properties.equipEquipment].id);
	self.cnt:SetCurrWeapon(WeaponClassesEx[self.Properties.equipEquipment].id);
	if (self.fireparams) and (self.fireparams.bullets_per_clip) then
		self.cnt.ammo_in_clip = self.fireparams.bullets_per_clip;
	end
end
end

NPC=CreateAI(NPC);
NPC.Client.OnInit = function(self)
	self:LoadCharacter(self.cnt.model,0);
	BasicPlayer.Client_OnInit( self );
	--------------------
	self.ai = nil;
	self.Properties.bNoRespawn = 0;
	local lng_prefix = "_en";
	if (getglobal("g_language")) == "russian" then
		lng_prefix = "_ru";
	end
	if (strfind(self.cnt.model,"valeri.")) then
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
		self.call_4_help_messages = {
			{
				text = "@su_call_help1",
				sound = Sound:LoadStreamSound("Sounds/feedback/su_help_female_1"..lng_prefix..".ogg"),
			},
			{
				text = "@su_call_help3",
				sound = Sound:LoadStreamSound("Sounds/feedback/su_help_female_2"..lng_prefix..".ogg"),
			},
		};
	else
		self.call_4_help_messages = {
			{
				text = "@su_call_help1",
				sound = Sound:LoadStreamSound("Sounds/feedback/su_help_male_1"..lng_prefix..".ogg"),
			},
			{
				text = "@su_call_help2",
				sound = Sound:LoadStreamSound("Sounds/feedback/su_help_male_2"..lng_prefix..".ogg"),
			},
		};
	end
	if (Mission) and (Mission[self:GetName()]~=nil) then
		self.i_am_atrader = 1;
	else
		self.i_am_atrader = nil;
	end
end
NPC.Server.Alive.OnUpdate = function(self)
	BasicPlayer.Server_OnTimer(self);
	if (self.my_leader) and (self.vnpc_f_timer < _time) then
		self.vnpc_f_timer = _time + 3;
		local myleader = System:GetEntity(self.my_leader);
		local mytarget = AI:GetAttentionTargetOf(self.id);
		if (mytarget) and (type(mytarget)=="table") and (mytarget.isbadmonster) then
			self:ChangeAIParameter(AIPARAM_ATTACKRANGE,self.Properties.attackrange);
			self:ChangeAIParameter(AIPARAM_FWDSPEED,self.Properties.forward_speed);
		elseif (myleader) and (myleader.cnt) and (myleader.cnt.health > 0) then
			if (myleader.theVehicle) and (myleader.theVehicle.AddPassenger) and (not self.theVehicle) then
				local d_b_us = myleader:GetPos();
				d_b_us = self:GetDistanceFromPoint(d_b_us);
				local theTable = VC.GetAvailablePosition(myleader.theVehicle);
				if (d_b_us <= 3.2) and (theTable) then
					theTable.entity = self;
					VC.AddUserT(myleader.theVehicle, theTable);
				else
					self:ChangeAIParameter(AIPARAM_ATTACKRANGE,0);
					self:ChangeAIParameter(AIPARAM_FWDSPEED,self.Properties.forward_speed);
					self:SelectPipe(0,"sio_get_in_position",self.my_leader);
				end
			elseif (self.theVehicle) then
				if (myleader.theVehicle == nil or myleader.theVehicle ~= self.theVehicle) then
				VC.DropPeople(self.theVehicle);
				end
			else
				self:ChangeAIParameter(AIPARAM_ATTACKRANGE,0);
				self:ChangeAIParameter(AIPARAM_FWDSPEED,self.Properties.forward_speed);
				self:SelectPipe(0,"sio_get_in_position",self.my_leader);
			end
		elseif (not self.cnt.moving) then
			self:JustStayHere();
		end
	elseif (self.vnpc_s_timer < _time) then
		AI:SoundEvent(self.id,self:GetPos(),self.smell_factor,0,1,self.id);
		self.vnpc_s_timer = _time + 8;
		self.cnt.ammo = 300; -- ??? replenish ammo
	end
	if (self.vnpc_health ~= self.cnt.health) and (self.vnpc_d_timer < _time) then
		-- transfer health amount of npc to clients (to show status of NPC)
		self.vnpc_d_timer = _time + 1;
		self.vnpc_health = self.cnt.health * 1;
		Server:BroadcastCommand("SPS "..self.id.." "..self.cnt.health.." "..self.cnt.max_health);
	end
end
