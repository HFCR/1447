-- HIGHLY OPTIMIZED BASICAI 1.672vc_su_pp BY MIXER www.verysoft.narod.ru/fctweaks.htm
Script:ReloadScript("Scripts/Default/Entities/AI/AISounds/sound_tables.lua");
Script:ReloadScript("Scripts/Default/Entities/AI/AISounds/keyframes.lua");
Script:ReloadScript("Scripts/Default/Entities/AI/AISounds/jumps.lua");

-- Mixer: restoring some goal pipes missed in original far Cry:
AI:CreateGoalPipe("rear_interesting_sound");
AI:PushGoal("rear_interesting_sound","rear_interested");
AI:CreateGoalPipe("standfire");
AI:PushGoal("standfire","firecmd",0,1);
AI:PushGoal("standfire","bodypos",0,0);
AI:PushGoal("standfire","timeout",1,5);

BasicAI = {
ai=1,
NextChatterSound = 0,
lastMeleeAttackTime = 0,
iLastWaterSurfaceParticleSpawnedTime = _time,
Energy = 50,
MaxEnergy = 100,
EnergyChanged = nil,

sound_jump = 0,
sound_death = 0,
sound_land = 0,
sound_pain = 0,

vLastPos = { x=0, y=0, z=0 },
fLastRefractValue = 0,
bSplashProcessed = nil,


WeaponState = nil,

-- Reloading related

C_Reloading = nil,-- Just to check when ammo = 0 if we already started cl side FX
C_LastReloadTriggered = 0,

-- More complex server variables to keep reload procedure running for the right amount of time
S_LastReloadTriggered = 0,
S_Reloaded = 0,
S_Reloading = nil,

S_FireModeChangeSeqTriggered = 0,
C_FireModeChangeSeqTriggered = 0,

S_WeaponActivated = 0,
C_WeaponActivated = 0,

S_LastGrenadeThrow = 0,
C_LastGrenadeThrow = 0,

soundtimer = 0,

Behaviour = {},

temp_ModelName = "",

}

function BasicAI:OnPropertyChange()
	if (self.Properties.fileModel ~= self.temp_ModelName) then
		if (self.cnt.model~="") and (strsub(self.cnt.model, strlen(self.cnt.model)-1)=="al") then
			-- Mixer: coop model loading
			self.Properties.fileModel = self.cnt.model.."";
		end
		if (strsub(self.Properties.fileModel, strlen(self.Properties.fileModel)-13, strlen(self.Properties.fileModel)-3)=="utant_fast.") then
			self.Properties.fileModel = "Objects/characters/mutants/mutant_gree/mutant_fast.cgf";
		end
		self.temp_ModelName = self.Properties.fileModel.."";
		self:LoadCharacter(self.Properties.fileModel,0);
		local nMaterialID=Game:GetMaterialIDByName("mat_meat");
		self:PhysicalizeCharacter(self.PhysParams.mass, nMaterialID, self.BulletImpactParams.stiffness_scale, 0);
		self:SetCharacterPhysicParams(0,"", PHYSICPARAM_SIMULATION,self.BulletImpactParams);
	end
end

function BasicAI:StopConversation()

if (self.CurrentConversation) then
self.CurrentConversation:Stop(self);
self:StopDialog();
self.CurrentConversation = nil;
end
end

function BasicAI:PutHelmetOn(helmet_cgf)
	if (helmet_cgf ~= "") then
		self:LoadObject(helmet_cgf,0,0);
		if (self.Properties.AttachHelmetToBone) then
			self:AttachObjectToBone( 0, self.Properties.AttachHelmetToBone, 0, 1  );
		else
			self:AttachObjectToBone( 0, "hat_bone", 0, 1  );
		end
		if (self.hasHelmet) and (self.hasHelmet ~= 0) then
			self.items.ai_helmet = 1;
		end
	end
end

function BasicAI:GoToMountedGun()
local mounted = AI:FindObjectOfType(self.id,30,AIAnchor.USE_THIS_MOUNTED_WEAPON);
if (mounted) then
if (AI:GetGroupCount(self.id)>1) then 
AI:Signal(SIGNALFILTER_NEARESTGROUP,1,"SWITCH_TO_MORTARGUY",self.id);
else AI:Signal(0,1,"SWITCH_TO_MORTARGUY",self.id); return 1; end end
return nil;
end

function BasicAI:Set_Ai_Firemode(fmde)
	if (self.fireparams) then
		local ai_parms = {
		shooter = self,
		firemode = fmde,
		};
		BasicWeapon.Client.OnStopFiring(self.cnt.weapon, self);
		self.cnt.firemode = fmde * 1;
		BasicWeapon.Server.FireModeChange(self.cnt.weapon,ai_parms);
		BasicWeapon.Client.FireModeChange(self.cnt.weapon,ai_parms);
	end
end

function BasicAI:OnReset()

self.Enemy_Hidden = 2; -- Mixer: 2 means unhidden with "save/load items too" flag, to maintain old savegames compatibility

self:NetPresent(1);
self.PLAYER_ALREADY_SEEN = nil;
self.DODGING_ALREADY  = nil;
self.POTSHOTS = 0;
self.EXPRESSIONS_ALLOWED = 1;
self:SetScriptUpdateRate(self.UpdateTime);

self.AI_PlayerEngaged = nil;
self.AI_ALARMNAME = nil;

if (AI_ANIM_KEYFRAMES[self.Properties.KEYFRAME_TABLE]) then 
self.SoundEvents = AI_ANIM_KEYFRAMES[self.Properties.KEYFRAME_TABLE].SoundEvents;
end

if (self.Properties.JUMP_TABLE) then
if (AI_JUMP_KEYFRAMES[self.Properties.JUMP_TABLE]) then
self.JumpSelectionTable = AI_JUMP_KEYFRAMES[self.Properties.JUMP_TABLE];
end
end

if( self.OnResetCustom ) then
self:OnResetCustom();
end 

self:StopConversation();

if (self.Properties.ImpulseParameters) then 
for name,value in self.Properties.ImpulseParameters do
self.ImpulseParameters[name] = value;
end
end



BasicPlayer.OnReset(self);

if (self.AI_DynProp) then
if ((self.Properties.bPushPlayers~=nil) and (self.Properties.bPushedByPlayers~=nil)) then 
self.AI_DynProp.push_players = self.Properties.bPushPlayers;
self.AI_DynProp.pushable_by_players = self.Properties.bPushedByPlayers;
end

self.cnt:SetDynamicsProperties( self.AI_DynProp );
end

self.CurrentConversation = nil;

self.cnt:CounterSetValue("Boredom", 0 );

self.lastMeleeAttackTime = 0;

self.cnt:SetAISpeedMult( self.Properties.speed_scales );

--randomize only if the AI is using a voicepack.
if (self.Properties.SoundPack and self.Properties.SoundPack~="") then
	self.Properties.SoundPack = SPRandomizer:GetHumanPack(self.PropertiesInstance.groupid,self.Properties.SoundPack);
end 

AI:RegisterWithAI(self.id, AIOBJECT_PUPPET, self.Properties, self.PropertiesInstance);
self.cnt.health = self.Properties.max_health * getglobal("game_Health");

BasicPlayer.InitAllWeapons(self);

if (self.survival_gun) then -- workaround for survival mode
	self.cnt:MakeWeaponAvailable(self.survival_gun);
	self.cnt:SetCurrWeapon(self.survival_gun);
	self:MakeIdle();
end

if (self.Properties.bSleepOnSpawn == 1) then
self:TriggerEvent(AIEVENT_SLEEP);
end

BasicPlayer.HelmetOff(self);

if (self.PropertiesInstance.bHelmetOnStart) then
	if(self.PropertiesInstance.bHelmetOnStart == 1) then
		BasicPlayer.HelmetOn(self);
		self:PutHelmetOn(self.PropertiesInstance.fileHelmetModel);
	end
else
	if(self.Properties.bHelmetOnStart == 1) then
		BasicPlayer.HelmetOn(self);
		self:PutHelmetOn(self.Properties.fileHelmetModel);
	end
end

if (self.PropertiesInstance.bHasLight==1) then
self.cnt:GiveFlashLight(1);
self.cnt:SwitchFlashLight(1);
else
self.cnt:SwitchFlashLight(0);
end

if (self.Properties.bHasShield) and (self.Properties.bHasShield==1) then
self:LoadObject( "Objects/characters/mercenaries/accessories/shield.cgf",1,1);
self:AttachObjectToBone(1,"Bip01 L Hand");
end

if (self.Behaviour["OnSpawn"]) then
	self.Behaviour:OnSpawn(self);
else
	if (AIBehaviour[self.DefaultBehaviour]) then 
		if (AIBehaviour[self.DefaultBehaviour].OnSpawn) then 
			AIBehaviour[self.DefaultBehaviour]:OnSpawn(self);
		end
	end
end

self.groupid = self.PropertiesInstance.groupid;

self:SetAIName(self:GetName().." ");

self.melee_damage = self.Properties.fMeleeDamage;

if (self.Properties.fPersistence) and (self.Properties.fPersistence > 100) then
	self:Set_Ai_Firemode(self.Properties.fPersistence-100);
end

if (AI_SOUND_TABLES[self.Properties.SOUND_TABLE]) then
	self.painSounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].painSounds;
	self.deathSounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].deathSounds;
	self.chattersounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].chattersounds;
	self.breathSounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].breathSounds;
	--jump&land sounds
	self.jumpsounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].jumpsounds;
	self.landsounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].landsounds;
	--custom footstep sounds
	self.footstepsounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].footstepsounds;
	if (self.footstepsounds) then
		self.footsteparray = {0,0,0};
		self.footstepcount = 1;
	end
elseif (not Game:IsMultiplayer()) then
	-- Mixer: this prevents silent alien monsters with merccover class from emiting human sounds
	self.painSounds = nil;
	self.deathSounds = nil;
end

AI:DeCloak(self.id);

-- count melee animations and special fire animations for this enemy - if applicable
self.MELEE_ANIM_COUNT = self:DiscoverAnimationCount("attack_melee",1,1);
self.SPECIAL_FIRE_COUNT = self:DiscoverAnimationCount("fire_special",2,0);
self.COMBAT_IDLE_COUNT = self:DiscoverAnimationCount("combat_idle",2,0);
self.BLINDED_ANIM_COUNT = self:DiscoverAnimationCount("blind",2,0);
self.DRAW_GUN_ANIM_COUNT = self:DiscoverAnimationCount("draw",2,1);
self.HOLSTER_GUN_ANIM_COUNT = self:DiscoverAnimationCount("holster",2,1);

self.Properties.LEADING_COUNT = -1;
self.LEADING = nil;

-- now the same for special fire animations

BasicAI.SetSmoothMovement(self);

self.NextChatterSound = 0;

self.LastJumpSound = nil;
self.LastLandSound = nil;
end

function BasicAI:DiscoverAnimationCount( base_name, num_digits, start_value)

local formatstring = base_name.."%0"..num_digits.."d";

local num_found = 0;
local count = start_value;
local formatted_name = format(formatstring,count);
while (self:GetAnimationLength(formatted_name)~=0) do
num_found = num_found + 1;
count = count+1;
formatted_name = format(formatstring,count);
end

if (num_found>0) then
return num_found
else
return nil
end
end

function BasicAI:DoChatter()
-- Mixer: MOVED TO HUGE IMPROVE PERFORMANCE
end

function BasicAI:Event_OnAttempt()
	-- L_A_G_G_E_R
	-- Hud:AddMessage(self:GetName()..": Event_OnAttempt")
	BroadcastEvent(self, "OnAttempt");
end

function BasicAI:Event_Activate( params )
if (self.cnt.health > 0) then
	self:EnableUpdate(1);
	self:TriggerEvent(AIEVENT_WAKEUP);
	self.items.activ = 1;
	if (self.bAllWeaponsInititalized < 2) then
		self.bAllWeaponsInititalized = 2;
		self:InitAIRelaxed();
	end
end
if (self.Behaviour.OnActivate) then
self.Behaviour:OnActivate(self);
elseif (self.DefaultBehaviour and AIBehaviour[self.DefaultBehaviour].OnActivate) then
AIBehaviour[self.DefaultBehaviour]:OnActivate(self);
end

BroadcastEvent(self, "Activate");
end

function BasicAI:Event_Die(params)
if (self.cnt.health > 0) then 
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
BroadcastEvent(self, "Die");
end

function BasicAI:Event_Ressurect(params)
if (self.cnt.health <= 0) then 
self.wasreset = nil;
self.bAllWeaponsInititalized = nil;
self:OnReset();
self:TriggerEvent(AIEVENT_WAKEUP);
self:TriggerEvent(AIEVENT_ENABLE);
end
BroadcastEvent(self, "Ressurect");
end

function BasicAI:Event_Follow(params)
self:RestoreDynamicProperties();
AI:MakePuppetIgnorant(self.id,0);
AI:Signal(0,0,"SPECIAL_FOLLOW",self.id)
BroadcastEvent(self, "Follow");
end

function BasicAI:Event_StopSpecial(params)
self:RestoreDynamicProperties();
AI:MakePuppetIgnorant(self.id,0);
AI:Signal(0,0,"SPECIAL_STOPALL",self.id)
BroadcastEvent(self, "StopSpecial");
end

function BasicAI:Event_DisablePhysics(params)
self:EnablePhysics(0);
BroadcastEvent(self, "DisablePhysics");
end

function BasicAI:Event_EnablePhysics(params)
self:EnablePhysics(1);
BroadcastEvent(self, "EnablePhysics");
end

function BasicAI:Event_SPECIAL_ANIM_START(params)
BroadcastEvent(self, "SPECIAL_ANIM_START");
end

function BasicAI:Event_Hide(params)
self.Enemy_Hidden = 3;
self:DrawCharacter(0,0);
self.Properties.bAffectSOM = 0;
self:TriggerEvent(AIEVENT_WAKEUP);
self:TriggerEvent(AIEVENT_DISABLE);
self:EnablePhysics(0);
BroadcastEvent(self, "Hide");
end

function BasicAI:Event_UnHide(params)
self.Enemy_Hidden = 2;
self:DrawCharacter(0,1);
self.Properties.bAffectSOM = 1;
self:TriggerEvent(AIEVENT_ENABLE);
self:EnablePhysics(1);
BroadcastEvent(self, "UnHide");
end

function BasicAI:Event_HoldSpot(params)
self:RestoreDynamicProperties();
AI:MakePuppetIgnorant(self.id,0);
AI:Signal(0,0,"SPECIAL_HOLD",self.id)
BroadcastEvent(self, "HoldSpot");
end

function BasicAI:Event_Lead(params)
self:RestoreDynamicProperties();
AI:MakePuppetIgnorant(self.id,0);
AI:Signal(0,0,"SPECIAL_LEAD",self.id)
BroadcastEvent(self, "Lead");
end

function BasicAI:Event_GoDumb(params)
AI:MakePuppetIgnorant(self.id,0);
AI:Signal(0,0,"SPECIAL_GODUMB",self.id)
BroadcastEvent(self, "GoDumb");
end

function BasicAI:RestoreDynamicProperties()
if (self.AI_DynProp) then
if ((self.Properties.bPushPlayers~=nil) and (self.Properties.bPushedByPlayers~=nil)) then 
self.AI_DynProp.push_players = self.Properties.bPushPlayers;
self.AI_DynProp.pushable_by_players = self.Properties.bPushedByPlayers;
end
self.cnt:SetDynamicsProperties( self.AI_DynProp );
end
end

function BasicAI:Event_HalfHealthLeft(params)
BroadcastEvent(self, "HalfHealthLeft");
end

function BasicAI:Event_Relocate(params)
local point = Game:GetTagPoint(self:GetName().."_RELOCATE");
if (point) then 
self:SetPos({x=point.x,y=point.y,z=point.z});
else
System:Warning( "Entity "..self:GetName().." got a Relocate event but has no "..self:GetName().."_RELOCATE tagpoint");
end
BroadcastEvent(self, "Relocate");
end

function BasicAI:Event_DeActivate(params)
	if (self.Behaviour.OnDeactivate) then
		self.Behaviour:OnDeactivate(self);
	elseif (AIBehaviour[self.DefaultBehaviour].OnDeactivate) then
		AIBehaviour[self.DefaultBehaviour]:OnDeactivate(self);
	end
	self:TriggerEvent(AIEVENT_SLEEP);
	self.items.activ = nil;
	BroadcastEvent(self, "DeActivate");
end

----
function BasicAI:Event_OnDeath( params )
BroadcastEvent(self, "OnDeath");
end

----
function BasicAI:Event_MakeVulnerable( params )
self.Properties.bInvulnerable = 0;
BroadcastEvent(self, "MakeVulnerable");
end

----
function BasicAI:Event_LastGroupMemberDied( params )
BroadcastEvent(self, "LastGroupMemberDied");
end

----
function BasicAI:Event_AcceptSound( sender )
if (sender) then 
if (sender.type == "SoundSpot") then

self.ACCEPTED_SOUND = {};
self.ACCEPTED_SOUND.soundFile = sender.Properties.sndSource;
self.ACCEPTED_SOUND.Volume = sender.Properties.iVolume;
self.ACCEPTED_SOUND.min = sender.Properties.InnerRadius;
self.ACCEPTED_SOUND.max = sender.Properties.OuterRadius;

self:Say(self.ACCEPTED_SOUND);
else
end
end
BroadcastEvent(self, "AcceptSound");
end

------
function BasicAI:RegisterStates()
self:RegisterState( "Alive" );
self:RegisterState( "Dead" );
end

------
function BasicAI:Server_OnInit()
	if (self.OnInitCustom) then
		self:OnInitCustom();
	end
	
	if (self.cnt.model~="") and (strsub(self.cnt.model, strlen(self.cnt.model)-1)=="al") then
		-- Mixer: coop model loading
		self.Properties.fileModel = self.cnt.model.."";
	end
		
	if (strsub(self.Properties.fileModel, strlen(self.Properties.fileModel)-13, strlen(self.Properties.fileModel)-3)=="utant_fast.") then
		self.Properties.fileModel = "Objects/characters/mutants/mutant_gree/mutant_fast.cgf";
	end
		
	self.temp_ModelName = self.Properties.fileModel.."";
	self:LoadCharacter(self.Properties.fileModel,0);
	
	BasicPlayer.Server_OnInit( self );
	self:OnReset();
	self.cnt:CounterAdd("Boredom", .1 );
	self.cnt:CounterSetEvent("Boredom", 1, "OnBored" );
end

--
function BasicAI:Client_OnInit()
	if (self.cnt.model~="") and (strsub(self.cnt.model, strlen(self.cnt.model)-1)=="al") then
		-- Mixer: coop model loading
		self.Properties.fileModel = self.cnt.model.."";
	end
		
	if (strsub(self.Properties.fileModel, strlen(self.Properties.fileModel)-13, strlen(self.Properties.fileModel)-3)=="utant_fast.") then
		self.Properties.fileModel = "Objects/characters/mutants/mutant_gree/mutant_fast.cgf";
		self.it_is_vedroid = 1;
	end
		
	self.temp_ModelName = self.Properties.fileModel.."";
	if (Game:IsServer()==nil) then
		self:LoadCharacter(self.Properties.fileModel,0);
	end
	
	if (Mission) and (Mission.bVedroids) and (Mission.bVedroids == 1) then
		if (self.it_is_vedroid) and (self:GetMaterial()==nil) then
			self:SetMaterial('Level.Mutants.cis_vedroid_slave');
		end
	end

	self.it_is_vedroid = nil;
	
	BasicPlayer.Client_OnInit( self );
	if (self.Properties.bHasLight==1) then
		self.cnt.light = 1;
	end
end
------
function BasicAI:Client_OnShutDown()
	BasicPlayer.OnShutDown( self );
	-- Free resources
end
----

function BasicAI:OnSaveOverall(stm)
BasicPlayer.OnSaveOverall(self, stm);
end

----

function BasicAI:OnLoadOverall(stm)
BasicPlayer.OnLoadOverall(self, stm);
end
--
function BasicAI:OnLoad(stm)
	BasicPlayer.OnLoad(self,stm);
	self.Properties.LEADING_COUNT = stm:ReadInt();

	-- by request of Sten, special AI are regenerated when loaded
	if (self.Properties.special == 1) then
		self.cnt.health = self.Properties.max_health;
	end

	local special_behaviour = stm:ReadString();

	if (special_behaviour ~= "NA" ) then
		self.AI_SpecialBehaviour = special_behaviour;
		self:TriggerEvent(AIEVENT_CLEARSOUNDEVENTS);
		AI:Signal(0,1,self.AI_SpecialBehaviour,self.id);
	end

	BasicAI.SetSmoothMovement(self);

	self.Enemy_Hidden = stm:ReadInt();
	if (self.Enemy_Hidden == 1) or (self.Enemy_Hidden == 3) then
		self:Event_Hide();
	end
	if (self.Enemy_Hidden > 1) then
		self.items=ReadFromStream(stm);
	elseif (self.Enemy_Hidden == 0) then
		self.Enemy_Hidden = 2;
	end

	if (self.items.spwn_id) then
		self.isbadmonster = self.items.spwn_id * 1;
		self.items.spwn_id = nil;
		function self:Event_OnDeath()
			local p_ent = System:GetEntity(self.isbadmonster);
			if (p_ent) then
				if (p_ent.Properties.nSpawnlimit > 0) then
					p_ent.deathrow = p_ent.deathrow + 1;
					if (p_ent.deathrow >= p_ent.Properties.nSpawnlimit) then
						p_ent:Event_EveryoneDestroyed();
					end
				end
			end
			self.fcsu_deathtime = _time + 25;
		end
	end
	if (self.items.activ) then
		self:EnableUpdate(1);
		self:TriggerEvent(AIEVENT_WAKEUP);
	end
end
--
function BasicAI:OnLoadRELEASE(stm)
BasicPlayer.OnLoad(self,stm);
self.Properties.LEADING_COUNT = stm:ReadInt();
-- by request of Sten, special AI are regenerated when loaded
if (self.Properties.special == 1) then 
self.cnt.health = self.Properties.max_health;
end

local special_behaviour = stm:ReadString();

if (special_behaviour ~= "NA" ) then
self.AI_SpecialBehaviour = special_behaviour;
self:TriggerEvent(AIEVENT_CLEARSOUNDEVENTS);
AI:Signal(0,1,self.AI_SpecialBehaviour,self.id);
end

BasicAI.SetSmoothMovement(self);
end
--
function BasicAI:OnSave(stm)
	if (self.AI_GunOut == nil) then
		self.items.holdgun = nil;
	else
		self.items.holdgun = 1;
	end
	if (self.isbadmonster) then
		self.items.spwn_id = self.isbadmonster;
	end
	BasicPlayer.OnSave(self,stm);
	if (self.Properties.LEADING_COUNT) then
		stm:WriteInt(self.Properties.LEADING_COUNT);
	end
	if (self.AI_SpecialBehaviour) then
		stm:WriteString(self.AI_SpecialBehaviour);
	else
		stm:WriteString("NA");
	end
	stm:WriteInt(self.Enemy_Hidden);
	WriteToStream(stm,self.items);
end

function BasicAI:CheckFlashLight()

if (self.Properties.special == 1) then 
do return end
end

local name = AI:FindObjectOfType(self.id,2,AIAnchor.AIANCHOR_FLASHLIGHT);

if (name) then 
self:InsertSubpipe(0,"flashlight_investigate",name);
end
end


function BasicAI:MakeMissionConversation()

if (self.Properties.special == 1) then 
do return end
end

local name = AI:FindObjectOfType(self.id,3,AIAnchor.AIANCHOR_MISSION_TALK);

if (name) then
if (self.CurrentConversation == nil) then
self.CurrentConversation = AI_ConvManager:GetRandomCriticalConversation(name);
if (self.CurrentConversation) then
self.CurrentConversation:Join(self);
AI:Signal(SIGNALFILTER_NEARESTGROUP,0,"CONVERSATION_REQUEST",self.id);
return 1
end
end
end

name = AI:FindObjectOfType(self.id,3,AIAnchor.MISSION_TALK_INPLACE);

if (name) then
if (self.CurrentConversation == nil) then
self.CurrentConversation = AI_ConvManager:GetRandomCriticalConversation(name,1);
if (self.CurrentConversation) then
self.CurrentConversation:Join(self);
AI:Signal(SIGNALFILTER_NEARESTGROUP,0,"CONVERSATION_REQUEST_INPLACE",self.id);
return 1
end
end
end

return nil
end

function BasicAI:MakeRandomConversation()

if (self.Properties.special == 1) then 
do return end
end

local name = AI:FindObjectOfType(self.id,2,AIAnchor.AIANCHOR_RANDOM_TALK);

if (name) then
if (self.CurrentConversation == nil) then
self.CurrentConversation = AI_ConvManager:GetRandomIdleConversation();
if (self.CurrentConversation) then
self.CurrentConversation:Join(self);
AI:Signal(SIGNALFILTER_NEARESTGROUP,1,"CONVERSATION_REQUEST",self.id);
return 1
end
end
end
return nil

end

function BasicAI:RushTactic( probability)

if (self.Properties.fRushPercentage) then 
if (self.Properties.fRushPercentage>0) then
local percent = self.cnt.health / self.Properties.max_health;
if (percent<self.Properties.fRushPercentage) then
local rnd=random(1,10);
if (rnd>probability) then
AI:Signal(SIGNALFILTER_SUPERGROUP,1,"RUSH_TARGET",self.id);
AI:Signal(SIGNALID_READIBILITY, 1, "LO_RUSH_TACTIC",self.id);
end
end
end
end
end

--
BasicAI.Server =
{
OnInit = BasicAI.Server_OnInit,
OnShutdown = function( self )
end,
Alive = {
OnUpdate = function(self)
	if (self.AntiStuck) then
		self:AntiStuck();
	end
	if self.sim_melee_hit and self.sim_melee_hit < _time then
		self.sim_melee_hit = nil;
		local poss = self:GetPos();
		poss.z = poss.z + self.PlayerDimNormal.ellipsoid_height;
		poss = {
			pos = poss,
			dir = self:GetDirectionVector(),
			shooter = self,
			distance = self.cnt.melee_distance,
		};
		local hits = Game:GetMeleeHit(poss); --we throw the ray
		if hits and hits.objtype then
			local hit =	{
				dir = poss.dir,
				normal = hits.normal,
				damage = self.melee_damage*1,
				shooter = self,
				landed = 1,
				clpredictedhit = 1,
				e_fx = "melee_slash",
				ipart = hits.ipart,
				impact_force_mul_final = 20*1,
				impact_force_mul = 20*1,
				damage_type="normal",
				play_mat_sound = 1,
				pos = hits.pos,
				target_material = hits.target_material,
				weapon = {name="Claws"},
			};
					
			if hits.target then
				hit.target = hits.target;
				hit.target_id = hits.target.id;
				if hits.target.machete_hittimr then
					hit.pos2 = hit.target:GetPos();
					hit.dir2 = hit.target:GetDirectionVector();
					hit.dir2 = { x=hit.pos2.x+hit.dir2.x*0.5, y=hit.pos2.y+hit.dir2.y*0.5, z=hit.pos2.z+hit.dir2.z*0.5};
					hit.pos2 = hit.shooter:GetDistanceFromPoint(hit.pos2);
					hit.dir2 = hit.shooter:GetDistanceFromPoint(hit.dir2);
					if hit.dir2 < hit.pos2 then
						--hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_rock"));
						--shooter.fireparams.mat_effect = "melee_clash";
						hit.damage = 0;
					end
				end
			end

			if Game:IsServer() then
				if hits.target then
					if hits.target.machete_hittimr and hit.damage == 0 then
						hits.target.machete_hittimr = nil;
					else
						hits.target:Damage( hit );
						if Game:IsMultiplayer() then
							Server:BroadcastCommand("CHI "..hit.shooter.id.." "..hit.target.id.." -"..hit.damage);
						end
						BasicPlayer.SetBleeding(hit.target,0,hit.damage);
					end
				end
				if Game:IsClient() then
					ExecuteMaterial2(hit,hit.e_fx);
				end
			end
		end
	end
	BasicPlayer.Server_OnTimer(self);
end,
OnBeginState = function( self )
end,
OnEndState = function( self )
	self:Event_OnDeath();
end,
OnEvent = BasicPlayer.Server_OnEvent,
OnDamage = function (self, hit)

--if (hit.ipart) then
--	Hud:AddMessage("ipart = "..hit.ipart);
--end

if (self.Properties.fDamageMultiplier) then 
	hit.damage = hit.damage * self.Properties.fDamageMultiplier;
end

if (self.Properties.bInvulnerable~=nil) then
	if (self.Properties.bInvulnerable~=1) then
		BasicPlayer.Server_OnDamage( self, hit);
	end
else
	BasicPlayer.Server_OnDamage( self, hit);
end

if (hit.bleeding == nil) then
	if (self.Behaviour.OnKnownDamage and hit.shooter~=nil) then
		self.Behaviour:OnKnownDamage(self,hit.shooter);
	else
		AI:Signal(0,1,"OnReceivingDamage",self.id);
	end
end

if (self.LastDamageDoneByPlayer) then
	if (hit.damage_type == "normal" and hit.explosion == nil and hit.fire == nil and hit.drowning == nil) then 
		AI:RegisterPlayerHit();
	end
end

local dmg_percent = self.cnt.health / self.Properties.max_health; 
if (dmg_percent<0.5) then
self:Event_HalfHealthLeft();
end

self:RushTactic(5);

end,
},
Dead = {
OnBeginState = function( self )
self:StopConversation();

local dir = self.deathImpuls;
NormalizeVector(dir);
if ((dir.z<0.15) and (dir.z>-0.2)) then
dir.z = 0.15;
end
self:AddImpulse(1,{0,0,0},dir,self.deathImpulseTorso);

-- used for Autobalancing
if (self.LastDamageDoneByPlayer) then
self:TriggerEvent(AIEVENT_DROPBEACON);
self:TriggerEvent(AIEVENT_AGENTDIED,1);
else
self:TriggerEvent(AIEVENT_AGENTDIED);
end

self.LAST_SHOOTER = nil;

if (Game:IsClient()==nil) then self:EnablePhysics(0); end

if (AI:FindObjectOfType(self.id,40,AIAnchor.RETREAT_WHEN_HALVED)) then
AI:Signal(SIGNALFILTER_HALFOFGROUP,1,"RETREAT_NOW",self.id);
end


-- call the behaviour one last time :(
if (self.Behaviour.OnDeath) then
self.Behaviour:OnDeath(self);
else
if (AIBehaviour[self.DefaultBehaviour]) then
if (AIBehaviour[self.DefaultBehaviour].OnDeath) then
AIBehaviour[self.DefaultBehaviour]:OnDeath(self);
else
AIBehaviour.DEFAULT:OnDeath(self);
end
end
end


AI:DeCloak(self.id);

if (self.AI_ParticleHandle) then
Particle:Detach(self.id,self.AI_ParticleHandle);
end

if (AI:GetGroupCount(self.id) == 0) then
self:Event_LastGroupMemberDied();
end

self:RushTactic(8);


BasicAI.Drop(self, self.Properties.equipDropPack);
self:SetTimer(self.UpdateTime);
self:NetPresent(nil);
end,
OnEvent = BasicPlayer.Server_OnEventDead,
OnDamage = function (self, hit)
BasicPlayer.Server_OnDamageDead( self, hit);
end,
OnEndState = function( self )
end,
},
}

BasicAI.Client =
{
OnInit = BasicAI.Client_OnInit,
Alive = {
OnUpdate = function(self)
	BasicPlayer.Client_OnTimer(self);
	if (self.chattersounds) then
		if (self.NextChatterSound > _time) then return; end
		self.NextChatterSound = _time + random(100,200)*0.01;

		if (self.chattering_on) and (not Sound:IsPlaying(self.chattering_on)) then
			self.chattering_on = nil;
		end

		if (self.chattering_on==nil) then
			self.chattering_on = BasicPlayer.PlayOneSound(self,self.chattersounds,50);
		end
	end
end,

OnBeginState = function( self )
self.AnimationSystemEnabled = 1;
self:EnablePhysics(1);
BasicPlayer.OnBeginAliveState(self);
end,

OnEndState = function( self )
end,

OnDamage = function (self, hit)
if( self.OnDamageCustom ) then
self:OnDamageCustom();
end
 BasicPlayer.Client_OnDamage(self, hit);
end,
OnEvent = BasicPlayer.Client_OnEvent,
},
Dead = {
OnBeginState = function( self )
self.cnt.health=0;-- server might not send this info
-- MIXER'S DEVELOPMENT HACK 2007
--stop chatter/jump/land sounds when die
BasicAI.StopSounds(self);

-- stop any readibility
self:StopDialog();

-- setup local stuff on client
BasicPlayer.OnBeginDeadState(self);

if( self.OnDamageCustom ) then
self:OnDamageCustom();
end

-- Release trigger when dying
local Weapon = self.cnt.weapon;
if (Weapon) then
local WeaponStateData = GetPlayerWeaponInfo(self);
local FireModeNum = WeaponStateData.FireMode;
local CurFireParams = Weapon.FireParams[FireModeNum];
if (CurFireParams) and (CurFireParams.FireOnRelease) then
local Params =  {};
Params["shooter"] = self;
Params["fire_event_type"] = 2;
BasicWeapon.Client_OnFire(Weapon, Params);
end
end

if (self.cnt.health < 1) then
local CurWeaponInfo = self.weapon_info;
if (CurWeaponInfo) then
local CurFireMode = CurWeaponInfo.FireMode;
local CurWeapon = self.cnt.weapon;
local CurFireParams;
if (CurWeapon) then
CurFireParams = CurWeapon.FireParams[CurFireMode];
end
local SoundData = CurWeaponInfo.SndInstances[CurFireMode];
BasicWeapon.StopFireLoop(CurWeapon, self, CurFireParams, SoundData);
end
end
self:SetTimer(self.UpdateTime);
BasicPlayer.MakeDeadbody(self);
self.isDedbody = 0;
self:SetScriptUpdateRate(0);
end,
OnUpdate = BasicPlayer.Client_DeadOnUpdate,
OnEndState = function( self )
end,
OnTimer = BasicPlayer.Client_OnTimerDead,

-- [marco] only event to be updated when the AI is dead is the
-- eventonwater, as the dead AI can slide and fall into water
OnEvent = function (self,EventId,Params)
--System:Log("Event called");
if (EventId==ScriptEvent_EnterWater) then
--System:Log("Event enter water detected");
BasicPlayer.OnEnterWater(self,Params);
end
end

},
}

function BasicAI:Drop(packname)

-- spawn pickups
-- They are always spawned at different positions. Otherwise they collide immediately with each
-- other and don't fall down anymore.

if (self.POTSHOTS == -1) or (self.ai==nil) then return end
self.POTSHOTS = -1; -- Mixer: to make sure it's works ONCE

local deadguy_pos = self:GetPos();
-- Mixer: Friends stuck fix
AI:FreeSignal(1,"RESUME_SPECIAL_BEHAVIOUR",deadguy_pos,999);
-- drop armor
if (self.Properties.dropArmor ~= nil) and (self.Properties.dropArmor > 0) then
	local newentity = Server:SpawnEntity("Armor",{x=deadguy_pos.x,y=deadguy_pos.y,z=deadguy_pos.z+0.11});
	if (newentity) then
		newentity.Properties.Amount = self.Properties.dropArmor;
		newentity:SetAngles({x=0,y=0,z=self:GetAngles().z});
		newentity:EnableSave(0);
		newentity:Physicalize(self);
	end
end
-- drop items
deadguy_pos.z = deadguy_pos.z + 1.2; -- arms level
local packtable = EquipPacks[packname];
if (packtable) then
	local dropOffset=0.2;
	local wdrop_pos = self:GetBonePos("Bip01 L Clavicle");
	if (not wdrop_pos) then wdrop_pos = deadguy_pos; end
	for i,value in packtable do
		if (value.Type == "Item") then
			if (Game:GetEntityClassIDByClassName(value.Name.."_p")~=nil) and (Game:IsMultiplayer()==nil) and (GameRules.insta_play==nil) then
				local newentity = Server:SpawnEntity(value.Name.."_p",wdrop_pos);
				if (newentity) and (newentity.physpickup) then
					newentity:SetAngles({x=0,y=40,z=self:GetAngles().z+90});
					newentity:SetViewDistRatio(255);
					if (newentity.Properties.Animation.fAmmo_Primary) then
					if (newentity.Properties.Animation.fAmmo_Primary > 0) then
						newentity.Properties.Animation.fAmmo_Primary = random(1,newentity.Properties.Animation.fAmmo_Primary);
					end
					if (newentity.Properties.Animation.fAmmo_Secondary > 0) then
						newentity.Properties.Animation.fAmmo_Secondary = random(1,newentity.Properties.Animation.fAmmo_Secondary);
					end
					end
				end
			else
				-- raise position
				deadguy_pos.z = deadguy_pos.z - dropOffset;
				local newentity = Server:SpawnEntity(value.Name,deadguy_pos);
				if (newentity) then
					if (value.Name=="AmmoRocket") then
						newentity:SetStatObjScale(0.6);
					end
					newentity:Physicalize(self);
				else
					System:Log("Failure dropping the entity:"..value.Name);
				end
			end

		end
	end
end
end -- basicai:drop

function BasicAI:MakeAlerted()
self:StopConversation();
-- Make this guy alerted
self:ChangeAIParameter(AIPARAM_SIGHTRANGE,self.PropertiesInstance.sightrange*2);-- add 100% to sight range
self:ChangeAIParameter(AIPARAM_SOUNDRANGE,self.PropertiesInstance.soundrange+10);-- add 10 m to sound range
self:ChangeAIParameter(AIPARAM_FOV,self.Properties.horizontal_fov+20);-- focus attention
self:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10);-- focus attention

if (self.AI_GunOut==nil) then 
if (self.DRAW_GUN_ANIM_COUNT) then 
local rnd=random(1,self.DRAW_GUN_ANIM_COUNT);
local anim_name = format("draw%02d",rnd);
self:StartAnimation(0,anim_name,2);
local anim_dur = self:GetAnimationLength(anim_name);
self:TriggerEvent(AIEVENT_ONBODYSENSOR,anim_dur);
AI:EnablePuppetMovement(self.id,0,anim_dur);
self.AI_GunOut = 1;
end
end

end

function BasicAI:MakeIdle()
-- Make this guy idle
self:ChangeAIParameter(AIPARAM_SIGHTRANGE,self.PropertiesInstance.sightrange);
self:ChangeAIParameter(AIPARAM_SOUNDRANGE,self.PropertiesInstance.soundrange);
self:ChangeAIParameter(AIPARAM_FOV,self.Properties.horizontal_fov);
self:ChangeAIParameter(AIPARAM_RESPONSIVENESS,self.Properties.responsiveness);-- focus attention
end


function BasicAI:InsertMeleePipe( anim_name )

local anim_time = self:GetAnimationLength(anim_name);
anim_time = anim_time / 2;

AI:CreateGoalPipe("melee_animation_delay");
AI:PushGoal("melee_animation_delay","firecmd",0,0);
AI:PushGoal("melee_animation_delay","timeout",1,anim_time);
AI:PushGoal("melee_animation_delay","signal",1,1,"APPLY_MELEE_DAMAGE",0);
--AI:PushGoal("melee_animation_delay","timeout",1,anim_time);
AI:PushGoal("melee_animation_delay","signal",1,1,"RESET_MELEE_DAMAGE",0);

if (self:InsertSubpipe(0,"melee_animation_delay")) then 
self:StartAnimation(0,anim_name,4);
end


end

function BasicAI:InsertAnimationPipe( anim_name , layer_override, signal_at_end, fBlendTime, multiplier)

if (fBlendTime==nil) then
fBlendTime = 0.33;
end

if (multiplier==nil) then 
multiplier = 1;
end


AI:CreateGoalPipe("temp_animation_delay");
AI:PushGoal("temp_animation_delay","timeout",1,self:GetAnimationLength(anim_name)*multiplier);
if (signal_at_end) then
AI:PushGoal("temp_animation_delay","signal",1,-1,signal_at_end,0);
end

if (self:InsertSubpipe(0,"temp_animation_delay")) then
if (layer_override) then
self:StartAnimation(0,anim_name,layer_override,fBlendTime);
else
self:StartAnimation(0,anim_name,4,fBlendTime);
end
end

end

function BasicAI:MakeRandomIdleAnimation()
-- pick random idle animation
local MyAnim = IdleManager:GetIdleAnimation( self );
if (MyAnim) then
self:InsertAnimationPipe(MyAnim.Name);
else
System:Warning( "[AI] [ART ERROR][DESIGN ERRoR] Model "..self.Properties.fileModel.." used, assigned a job BUT HAS NO idleXX animations.");
end
end

function BasicAI:DoSomethingInteresting()

if ((self.Properties.bAffectSOM==0) and (self.Properties.special == 0)) then 
do return end
end

local specialTextAnchor = AI:FindObjectOfType(self.id,5,AIAnchor.DO_SOMETHING_SPECIAL);

local boredAnchor = AI_BoredManager:FindSomethingToDO(self,10);
if (boredAnchor) then
AI:Signal(0,1, boredAnchor.signal,self.id);
self.EventToCall = "OnSpawn";
return 1
end
end


function BasicAI:NotifyGroup()

if (self.Properties.special == 1) then 
do return end
end


local anch = AI:FindObjectOfType(self.id,30,AIAnchor.AIANCHOR_NOTIFY_GROUP_DELAY);
if (anch) then
self:InsertSubpipe(0,"delay_headsup",anch);
return 1
end

return nil

end

function BasicAI:GettingAlerted()

if (self.Properties.special == 1) then 
do return end
end

if self:GoToMountedGun() == nil then
if (self.cnt:GetCurrWeapon() == nil) then -- if has no weapon
local gunrack = AI:FindObjectOfType(self:GetPos(),30,AIAnchor.GUN_RACK);
if (gunrack) then 
self:InsertSubpipe(0,"get_gun",gunrack);
end
else
self:InsertSubpipe(0,"DRAW_GUN");
end
end
end

function BasicAI:Blind_RunToAlarm()

if (self.Properties.special == 1) then 
do return end
end

self.AI_ALARMNAME = AI:FindObjectOfType(self.id,30,AIAnchor.BLIND_ALARM);
if (self.AI_ALARMNAME) then
AI:Signal(0, 2, "GOING_TO_TRIGGER",self.id);
end

end

function BasicAI:RunToAlarm()

if (self.Properties.special == 1) then 
do return end
end

if self:GoToMountedGun() == nil then

local flare_name = AI:FindObjectOfType(self.id,10,AIAnchor.AIANCHOR_THROW_FLARE);
if (flare_name) then

AI:Signal(0, 2, "THROW_FLARE",self.id);
BasicPlayer.SelectGrenade(self,"FlareGrenade");
end

self.AI_ALARMNAME = AI:FindObjectOfType(self.id,30,AIAnchor.AIANCHOR_PUSH_ALARM);
if (self.AI_ALARMNAME) then
AI:Signal(0, 2, "GOING_TO_TRIGGER",self.id);
end
end
end

function BasicAI:BasicPlayerTimer() -- E1LOCK
	self:SetAccuracy()
end

function BasicAI:GetDistanceToTarget(att_target) -- E1LOCK
	return BasicPlayer.GetDistanceToTarget(self,att_target)
end

function BasicAI:SetAccuracy() -- E1LOCK
	local FogStart = System:GetFogStart()
	local FogEnd = System:GetFogEnd()
	local MediumFog = FogEnd+10
	-- System:Log(self:GetName()..": FogStart: "..FogStart..", FogEnd: "..FogEnd..", MediumFog: "..MediumFog)
	if self.AI_AtWeapon then
		self:ChangeAIParameter(AIPARAM_ACCURACY,.3)
		self:ChangeAIParameter(AIPARAM_AGGRESION,0)
		-- Hud:AddMessage(self:GetName()..": self.AI_AtWeapon")
		-- System:Log(self:GetName()..": self.AI_AtWeapon")
		return
	end
	if self.PracticleFireMan then self:ChangeAIParameter(AIPARAM_ACCURACY,1) self:ChangeAIParameter(AIPARAM_ATTACKRANGE,10000) return end -- Добавить: разрешить ему стрелять по старому, а то в одну точку бьёт. AIPARAM_ATTACKRANGE не убирать.
	local Weapon = self.cnt.weapon
	if not Weapon then self:ChangeAIParameter(AIPARAM_ATTACKRANGE,self.Properties.attackrange) end
	local fDistance = self:GetDistanceToTarget()
	if fDistance and not self.bEnemyInCombat~=1 then self.bEnemyInCombat=1 end -- Чтоб хоть как-то здесь проверять то человек уже воевал с кем-то. Это переменная в бинокле, она сохраняется как булево значение.
	if not fDistance then self:ChangeAIParameter(AIPARAM_ATTACKRANGE,self.Properties.attackrange) end
	if not self.CurrentSightRange then if self.PropertiesInstance.sightrange then self.CurrentSightRange=self.PropertiesInstance.sightrange end end
	if not self.CurrentSightRange then return end
	local Current_Distance  -- Максимальная дистанция стрельбы.
	if self.fireparams then
		Current_Distance = self.fireparams.distance
	end
	-- local MaxRange = self.CurrentSightRange
	-- if MaxRange > MediumFog then MaxRange = MediumFog  end
	local MaxRange = 80  -- Максимальная дистанция, докуда достреливает оружие.
	local MaxAttackRange = 10000 -- 350
	if Current_Distance then
		MaxRange = Current_Distance -- Для рассчёта агрессии.
		if self.fireparams and self.fireparams.fire_mode_type~=FireMode_Melee then
			if Weapon and Weapon.name~="RL" then
				MaxAttackRange = Current_Distance+random(0,50)
			end
		else
			MaxAttackRange = Current_Distance+3 -- 3, чтоб с разбегу ка-ак за-аехать...
		end
	end

	self:ChangeAIParameter(AIPARAM_ATTACKRANGE,MaxAttackRange)  -- Чтобы не тратили зря патроны, пули всё-равно не долетают.
	-- if not fDistance then fDistance="nil" end
	-- System:Log(self:GetName()..": Current_Distance: "..Current_Distance..", MaxAttackRange: "..MaxAttackRange..", fDistance: "..fDistance)
	-- if fDistance=="nil" then	fDistance=nil end

	local NewParam = 1
	local NewAggresion = 1
	local NewAccuracy = 1
	-- local inversion
	if fDistance then
		NewParam = fDistance/MaxRange
		if NewParam > 1 then NewParam = 1 end
		NewAccuracy = NewParam
		NewAggresion = NewParam
		-- f (Weapon.name=="Falcon" and self.fireparams.fire_mode_type~=FireMode_Melee) or Weapon.name=="Shotgun" or Weapon.name=="MutantShotgun" or Weapon.name=="SniperRifle" or Weapon.name=="RL" then
		if self.fireparams
		and (self.fireparams.fire_mode_type==FireMode_Melee or self.fireparams.fire_mode_type==FireMode_Projectile
		or self.fireparams.BulletRejectType==BULLET_REJECT_TYPE_SINGLE) then
			-- Hud:AddMessage(self:GetName()..": +NewAggresion: "..NewAggresion)
			-- System:Log(self:GetName()..": +NewAggresion: "..NewAggresion)
			NewAggresion = 1.4-NewAggresion  -- Часто нажимать на курок в ближнем бою с данным видом оружия.
			-- -- inversion=1
			-- Hud:AddMessage(self:GetName()..": -NewAggresion: "..NewAggresion)
			-- System:Log(self:GetName()..": -NewAggresion: "..NewAggresion)
		else
			if NewAggresion > .7 and self.fireparams and self.fireparams.fire_mode_type~=FireMode_Melee then NewAggresion = .7 end
		end
	end
	local NewSightRange = 110 -- Болванка.
	-- local NewSightRange = self.CurrentSightRange
	local MinNewSightRange = 50 -- Это и ещё две для спокойного состояния.
	local AddNewSightRange = random(0,100) -- 50+0,60 = 50,110;
	local MaxNewSightRange = MinNewSightRange+AddNewSightRange
	if self.bEnemyInCombat==1 then
		if fDistance then
			NewSightRange = 275
		else
			NewSightRange = 110+random(0,165)
		end
		if Weapon and (Weapon.name=="SniperRifle" or Weapon.name=="RL") then
			if fDistance then
				NewSightRange = 550
			else
				NewSightRange = 110+random(0,440)
			end
		elseif Weapon and (Weapon.name=="AG36" or Weapon.name=="OICW") then
			if fDistance then
				NewSightRange = 385
			else
				NewSightRange = 110+random(0,275)
			end
		end
		MaxNewSightRange = nil
	else
		NewSightRange = MaxNewSightRange
	end
	if NewAccuracy < .2 then NewAccuracy = .2 end
	if not AI:IsMoving(self.id) and Weapon then -- Если не двигается, то можно повысить меткость.
		if Weapon.name=="OICW" or Weapon.name=="AG36" then
			NewAccuracy=NewAccuracy*.1 -- Чтобы люди с этим оружием стреляли более метко. NewAccuracy*коэффициент = при максимуме, 1==коэффициент
			-- NewAggresion=1-NewAggresion
		elseif Weapon.name=="SniperRifle" or Weapon.name=="RL" then
			NewAccuracy=NewAccuracy*.5
		-- else
			-- NewAccuracy=NewAccuracy*.7
		end
	end
	if not self.fireparams or self.fireparams.fire_mode_type==FireMode_Melee then -- not - для мутантов.
		NewAccuracy = 0
		NewAggresion = 1
	end
	if Weapon and Weapon.name=="RL" then
		NewAggresion = 1
	end
	if self.AI_AtWeapon then
		NewAccuracy = .3
		NewAggresion = 0
	end
	-- NewAccuracy = 0
	if NewAccuracy < 0 then NewAccuracy = 0  end
	if NewAccuracy > 1 then NewAccuracy = 1  end
	self:ChangeAIParameter(AIPARAM_ACCURACY,NewAccuracy)  -- 0 - абсолютная точность, 1 - часто промахивается, т. е. чем больше значение, тем больше мажет.
	if NewAggresion then
		if NewAggresion < 0 then NewAggresion = 0 end
		if NewAggresion > 1 then NewAggresion = 1 end
		self:ChangeAIParameter(AIPARAM_AGGRESION,NewAggresion)  -- 0, .1 - длинные очереди с долгими паузами между стрельбой, .9, 1 - короткие очереди с недолгими паузами. Второе подходит для стрельбы из автоматического оружия на дальние дистанции.
		-- self:ChangeAIParameter(AIPARAM_AGGRESION,.9)  -- Тест анимации после стрельбы.
		-- Hud:AddMessage(self:GetName()..": NewAggresion: "..NewAggresion)
		-- System:Log(self:GetName()..": NewAggresion: "..NewAggresion)
	end
	-- Hud:AddMessage(self:GetName()..": Weapon: "..Weapon.name..", NewParam: "..NewParam..", NewAccuracy: "..NewAccuracy..", NewAggresion: "..NewAggresion)
	-- System:Log(self:GetName()..": Weapon: "..Weapon.name..", NewParam: "..NewParam..", NewAccuracy: "..NewAccuracy..", NewAggresion: "..NewAggresion)
	-- self:ChangeAIParameter(AIPARAM_ACCURACY,self.PropertiesInstance.accuracy)  -- Возвращает исходное значение точности.
	-- self:ChangeAIParameter(AIPARAM_AGGRESION,self.PropertiesInstance.aggresion)  -- Возвращает исходное значение агрессии.
	if NewSightRange>MediumFog then
		NewSightRange=MediumFog
	end
	-- if NewSightRange<110 and MediumFog>=110 then
		-- NewSightRange=110
	-- end
	if self.NewSightRangeMultiplier then -- function Mission:Event_SightRange_1_Set()
		NewSightRange=NewSightRange*self.NewSightRangeMultiplier
		if MaxNewSightRange then -- Оно бывает когда наёмник спокоен и целиком присваивается в NewSightRange.
			NewSightRange=NewSightRange*1.8 -- Было слишком мало для спокойного состояния.
		end
		-- System:Log(self:GetName()..": BAI, NewSightRangeMultiplier: "..self.NewSightRangeMultiplier)		
	else
		if MaxNewSightRange then
			if NewSightRange<MaxNewSightRange and MediumFog>=MaxNewSightRange then
				NewSightRange=MaxNewSightRange
			end
		else
			if NewSightRange<110 and MediumFog>=110 then
				NewSightRange=110
			end
		end
	end
	-- Hud:AddMessage(self:GetName()..": NewSightRange: "..NewSightRange)
	-- System:Log(self:GetName()..": NewSightRange: "..NewSightRange)
	if self.CurrentSightRange~=NewSightRange then
		self.CurrentSightRange=NewSightRange
		--self:ChangeAIParameter(AIPARAM_SIGHTRANGE,NewSightRange)
	end
end

function BasicAI:MutantJump( AnchorType, fDistance, flags )
	if (AnchorType == nil) then 
	AnchorType = AIAnchor.MUTANT_JUMP_TARGET;
	end

	if (fDistance == nil) then 
	fDistance = 30;
	end

	if (self.cnt.flying) then
	do return end
	end

	if (self.AI_SpecialPoints==nil) then
	self.AI_SpecialPoints = 0;
	end

	local jmp_name = self:GetName().."_JUMP"..self.AI_SpecialPoints;
	local TagPoint = Game:GetTagPoint(jmp_name);
	if (TagPoint~=nil) then 

	AI:CreateGoalPipe("jump_to");
	AI:PushGoal("jump_to","ignoreall",0,1); 
	AI:PushGoal("jump_to","clear",0); 
	AI:PushGoal("jump_to","firecmd",0,0); 
	AI:PushGoal("jump_to","jump",1,0,0,0,self.Properties.fJumpAngle); -- actual jump executed here
	AI:PushGoal("jump_to","ignoreall",0,0); 

	AI:Signal(0,1,"JUMP_ALLOWED",self.id);
	self:SelectPipe(0,"jump_wrapper");
	self:InsertSubpipe(0,"jump_to",jmp_name);
	self.AI_SpecialPoints=self.AI_SpecialPoints+1;
	
	if (Game:IsMultiplayer()) and (self.JumpSelectionTable) then
		-- can be seen in client of survival dedicated server
		Server:BroadcastCommand("PLAA "..self.id.." "..self.JumpSelectionTable[2][1][1]);
	end

	return 1;
end

local jmp_point=nil;
if (AnchorType==AIAnchor.MUTANT_JUMP_TARGET) then 
 jmp_point = AI:FindObjectOfType(self.id,fDistance,AIAnchor.MUTANT_JUMP_TARGET_WALKING,flags);
end
if (jmp_point == nil) then
jmp_point = AI:FindObjectOfType( self.id, fDistance, AnchorType,flags);
if (jmp_point) then
self.AI_CanWalk = nil;
end
else
self.AI_CanWalk = 1;
end

if (jmp_point) then 

AI:CreateGoalPipe("jump_to");
AI:PushGoal("jump_to","ignoreall",0,1); 
AI:PushGoal("jump_to","clear",0); 
AI:PushGoal("jump_to","firecmd",0,0); 
AI:PushGoal("jump_to","jump",1,0,0,0,self.Properties.fJumpAngle); -- actual jump executed here
AI:PushGoal("jump_to","ignoreall",0,0); 



AI:Signal(0,1,"JUMP_ALLOWED",self.id);
self:SelectPipe(0,"jump_wrapper");
self:InsertSubpipe(0,"jump_to",jmp_point);
return 1;
end

return nil;
end


function BasicAI:PushStuff()

local push_point = AI:GetAnchor(self.id,AIAnchor.PUSH_THIS_WAY,10);
if (push_point) then 
self:InsertSubpipe(0,"mutant_push_stuff_at",push_point);
end

end


function BasicAI:InitAIRelaxed()
if (self.fireparams) then
if (self.fireparams.type) and (self.fireparams.type==2) then
	self.PropertiesInstance.bGunReady=1;
end end  -- pistols are always ready

if (self.PropertiesInstance.bGunReady) and (self.PropertiesInstance.bGunReady == 0) and (self.items) and (not self.items.holdgun) then
	self.cnt:HolsterGun();
	self.AI_GunOut = nil;
else
	self.cnt:HoldGun();
	self.AI_GunOut = 1;
	self.items.holdgun = 1;
end
self.RunToTrigger = nil;
end

function BasicAI:InitAICombat()
	self.cnt:HoldGun();
	self.AI_GunOut = 1;
	self.RunToTrigger = nil;
end

function BasicAI:Say( phrase, AIConvTable )
	if (phrase) then
		self:SayDialog(phrase.soundFile, phrase.Volume, phrase.min, phrase.max, SOUND_RADIUS,AIConvTable);
	end
end

function BasicAI:Readibility( signal , bSkipGroupCheck)
	if (self.Properties.SoundPack) and (self.Properties.SoundPack~="") and (SOUNDPACK) then
		if (SOUNDPACK[self.Properties.SoundPack]) then
			if (bSkipGroupCheck==nil) then 
				if (AI:GetGroupCount(self.id) > 1) then
					signal = signal.."_GROUP";
				end
			end
			local sgnl = SOUNDPACK[self.Properties.SoundPack][signal];
			if (sgnl) then
				local rsgnl = random(1,getn(sgnl));
				if (sgnl[rsgnl]) and (sgnl[rsgnl].PROBABILITY) then
					if (random(0,280) < sgnl[rsgnl].PROBABILITY) then
						if (Game:IsClient()) then
							self:Say(sgnl[rsgnl]);
						end
						if (GameRules) and (GameRules.SetCoopMission) then
							local sndfile = strsub(sgnl[rsgnl].soundFile, 1, strlen(sgnl[rsgnl].soundFile)-4);
							Server:BroadcastCommand("RDB "..self.id.." "..sndfile.." "..sgnl[rsgnl].min.." "..sgnl[rsgnl].max.." "..sgnl[rsgnl].Volume);
						end
					end
				end
			end
		end
	end
end

function BasicAI:StopSounds()

Sound:StopSound(self.chattering_on);
Sound:StopSound(self.LastLandSound);
Sound:StopSound(self.LastJumpSound);

if (self.footsteparray) then
for i,footstep in self.footsteparray do
Sound:StopSound(footstep);
end
end
end

--
function BasicAI:DoJump(Params)

if (Params==1) then
if (Sound:IsPlaying(self.LastLandSound)==nil) then
self.LastLandSound = nil;
end

if (self.landsounds and self.LastLandSound==nil) then
self.LastLandSound = BasicPlayer.PlayOneSound(self,self.landsounds,100);
end
else
if (Sound:IsPlaying(self.LastJumpSound)==nil) then
self.LastJumpSound = nil;
end

if (self.jumpsounds and self.LastJumpSound==nil) then
self.LastJumpSound = BasicPlayer.PlayOneSound(self,self.jumpsounds,100);
end
end
end

--
function BasicAI:DoCustomStep(material,pos)

if (self.footstepsounds==nil) then return nil; end

if (LengthSqVector(self:GetVelocity())<1) then return nil; end

if(not Game:IsPointInWater(pos)) then

local footstepcount = self.footstepcount;

--stop the previous sound if exist.
Sound:StopSound(self.footsteparray[footstepcount]); 

self.footsteparray[footstepcount] = BasicPlayer.PlayOneSound(self,self.footstepsounds,100);

footstepcount = footstepcount + 1;

--loop cycle through the foot step array
if (footstepcount > count(self.footsteparray)) then footstepcount = 1; end

self.footstepcount = footstepcount;

--System:Log(sprintf("foot step iterator : %i",self.footstepcount));

return 1;
end

return nil;
end

function BasicAI:SetSmoothMovement()
-- smooth AI movement input (acceleration,deceleration,indoor_acceleration,indoor_deceleration)
self.cnt:SetSmoothInput(3,15,5,15);
end

--
function CreateAI(child)


local newt={}
mergef(newt,BasicAI,1);
mergef(newt,child,1);

newt.PropertiesInstance.bHelmetProtection = 1;

return newt;
end
