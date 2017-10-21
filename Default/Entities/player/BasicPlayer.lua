--Highly Optimized Basicplayer.lua (Mixer)
if (not GameStyler) then
	Script:ReloadScript("Scripts/gamestyler.lua");
	Game:CreateVariable("gr_MpNoFatigue",0);
	Game:CreateVariable("gr_bleeding",0);
end

GoreDecals = { -- used to be projected on walls/objects/terrain
count = 1,
dec1=
{
texture = System:LoadTexture("Languages/Textures/human_bullet_hit_d.DDS"),
scale = 0.4,
random_rotation= 360,
random_scale = 50,
life_time = 15,
grow_time = 0,
},
dec2=
{
texture = System:LoadTexture("Languages/Textures/Decal/flesh_slash.dds"),
scale = 0.5,
random_rotation= 360,
random_scale = 20,
life_time = 15,
grow_time = 0,
},
}

GoreDecalsBld = { -- blood under dead body
count = 1,
dec1=
{
texture = System:LoadTexture("Languages/Textures/blood_pool.DDS"),
scale = 0.7,
random_rotation= 360,
random_scale = 10,
life_time = 30,
grow_time = 30,},
dec2=
{
texture = System:LoadTexture("Languages/Textures/Decal/flesh_slash.dds"),
scale = 1.4,
random_rotation= 360,
random_scale = 20,
life_time = 15,
grow_time = 15,
},
}

-- definition for keyframe identifiers
KEYFRAME_APPLY_MELEE = 1;
KEYFRAME_ALLOW_AI_MOVE = 2;
KEYFRAME_BREATH_SOUND = 3;
KEYFRAME_JOB_ATTACH_MODEL_NOW = 4;
KEYFRAME_HOLD_GUN = 9;
KEYFRAME_HOLSTER_GUN = 10;
KEYFRAME_FIRE_LEFTHAND = 11;
KEYFRAME_FIRE_RIGHTHAND = 12;
KEYFRAME_FIRE_LEFTTOP = 13;
KEYFRAME_FIRE_RIGHTTOP = 14;

BasicPlayer = {
type = "Player",

UpdateTime = 300,
death_time = nil,
decalTime = 0,

proneMinAngle = -32,
proneMaxAngle = 32,

normMinAngle = -85,
normMaxAngle = 85,

isPhysicalized = 0,

holdedWeapon = nil,

BloodTimer = 100000,

aux_vec = {x=0,y=0,z=0},

deathImpuls = {x=0,y=0,z=0},
deathImpulseTorso = 0,
deathPoint = {x=0,y=0,z=0},
deathImpulsePart = 0,

DTExplosion = 0,
DTSingleP = 1,
DTSingle = 2,
DTRapid = 3,

painSound = nil,

isProning = 0,
InWater= 0,
isRefractive = 0,

--[filippo]
lastStanceSound = 0,
hasJumped = 0,
jumpSoundPlayed = 0,
tempvec = {x=0,y=0,z=0},
jumpTime = 0,
nextPush = 0,
nextPush_Client = 0,

--number of updates to move in bush to have max bush sound volume.Time would be UpdateTime*BushSoundScale
BushSoundScale = 10,
--  internal counter of updates
BushInCounter = 0,
--the same for AI
BushSoundScaleAI = 10,
BushInCounterAI = 0,

--in seconds
drown_time=20,

-- falling damage
-- if land speed is greater than FallDmgS damage will be applyed.
-- ammount of damage is (landSpeed - FallDmgS)*FallDmgK
-- speed = sqrt(2*9.8*height)
FallDmgS = 10,
FallDmgK = 22,

-- collision damage coefficient
CollisionDmg = .5, 
-- collision damage coefficient for vehicles (cars)
CollisionDmgCar = 3,

-- protection stuff
hasHelmet = 0,

lightFileShader="",
lightFileTexture="Textures/Lights/gk_spotlight_lg.dds",

AnimationBlendingTimes={
{"srunfwd",.31},
{"srunback",.23},
{"arunfwd",.35},
{"arunback",.33},
{"srunback_utaim",.2},
{"srunback_utshoot",.2},
},

PainAnimations =
{
"pain_head",
"pain_torso",
"pain_larm",
"pain_rarm",
"pain_lleg",
"pain_rleg"
},

--- common data over

soundScale = {
run = 0.8,
walk = 0.6,
crouch = 0.4,
prone = 0.3,
},

soundRadius = {
--[filippo]
run = 6.0,--before was 12
walk = 2.0,-- before was 6
crouch = 1.0,-- 1
prone = 0.5,--before was 1
jump = 3.0,--for jump
sprint = 12.0,--for sprint
},

soundEventRadius = {
run = 0,
jump = 0,-- when landing after jump
walk = 0,
crouch = 0,
prone = 0,
},

DynProp = {
air_control = 0.9, --filippo: was 0.4, default 0.6
gravity = 9.81,--18.81,
jump_gravity = 15.0,-- gravity used when the player jump, if this parameter dont exist normal gravity is used for jump
swimming_gravity = 0.9,
inertia = 10.0,
swimming_inertia = 1.0,
nod_speed = 50.0,--filippo:was 60
min_slide_angle = 46,
max_climb_angle = 55,
min_fall_angle = 70,
max_jump_angle = 50,
},

TpvReloadFX = {
	{"creload_DE_moving", 9, Sound:Load3DSound("Sounds/Weapons/DE/DEclipout_10.wav",SOUND_UNSCALABLE,94,5,60)},
	{"creload_DE_moving", 41, Sound:Load3DSound("Sounds/Weapons/DE/DEclipin_25.wav",SOUND_UNSCALABLE,94,5,60)},
	{"sreload", 7, Sound:Load3DSound("Sounds/Weapons/M4/M4_20.wav",SOUND_UNSCALABLE,96,5,60)},
	{"sreload", 29, Sound:Load3DSound("Sounds/Weapons/AG36/Ag36b_38.wav",SOUND_UNSCALABLE,96,5,60)},
	{"creload", 7, Sound:Load3DSound("Sounds/Weapons/M4/M4_20.wav",SOUND_UNSCALABLE,96,5,60)},
	{"creload", 29, Sound:Load3DSound("Sounds/Weapons/AG36/Ag36b_38.wav",SOUND_UNSCALABLE,96,5,60)},
	{"sreload_DE", 9, Sound:Load3DSound("Sounds/Weapons/DE/DEclipout_10.wav",SOUND_UNSCALABLE,94,5,60)},
	{"sreload_DE", 41, Sound:Load3DSound("Sounds/Weapons/DE/DEclipin_25.wav",SOUND_UNSCALABLE,94,5,60)},
	{"creload_DE", 9, Sound:Load3DSound("Sounds/Weapons/DE/DEclipout_10.wav",SOUND_UNSCALABLE,94,5,60)},
	{"creload_DE", 41, Sound:Load3DSound("Sounds/Weapons/DE/DEclipin_25.wav",SOUND_UNSCALABLE,94,5,60)},
	{"sreload_DE_moving", 9, Sound:Load3DSound("Sounds/Weapons/DE/DEclipout_10.wav",SOUND_UNSCALABLE,94,5,60)},
	{"sreload_DE_moving", 41, Sound:Load3DSound("Sounds/Weapons/DE/DEclipin_25.wav",SOUND_UNSCALABLE,94,5,60)},
	{"sreload_moving", 7, Sound:Load3DSound("Sounds/Weapons/M4/M4_20.wav",SOUND_UNSCALABLE,96,5,60)},
	{"sreload_moving", 29, Sound:Load3DSound("Sounds/Weapons/AG36/Ag36b_38.wav",SOUND_UNSCALABLE,96,5,60)},
},

sndWaterSwim = Sound:LoadSound("sounds/player/water/newswim2lp.wav"),
sndUnderWaterSwim = Sound:LoadSound("sounds/player/water/underwaterswim2.wav"),

sndUnderwaterNoise = Sound:LoadSound("sounds/player/water/underwaterloop.wav"),
sndWaterSplash = Sound:Load3DSound("sounds/player/water/WaterSplash.wav", SOUND_RADIUS, 160, 3, 50),

sndBreathIn = {
Sound:LoadSound("sounds/player/breathin.wav"),
Sound:LoadSound("sounds/player/breathout.wav"),
},

tSndNoAir = 100,

WaterRipples = {
focus = 0.2,
color = {1,1,1},
speed = 0.0,
count = 1,
size = 0.15, size_speed=0.6,
gravity=0,
lifetime=3,
tid = System:LoadTexture("textures\\ripple.dds"),
frames=0,
color_based_blending = 1,
particle_type = 1,
},

WaterSplash = {
focus = 3,
color = {1,1,1},
speed = 10,
count = 140,
size = 0.025, size_speed=0,
gravity=1,
lifetime=0.5,
tid = 0,
frames=0,
color_based_blending = 0

},

fLightSound = Sound:Load3DSound("SOUNDS/items/flight.wav",SOUND_UNSCALABLE,160,3,30),

-- current body heat
fBodyHeat=1.0,

StaminaTable = {
sprintScale= 1.4,
sprintSwimScale = 1.4,
decoyRun= 1.0,
decoyJump= 5,
restoreRun= 1.5,
restoreWalk= 9,
restoreIdle= 12,

breathDecoyUnderwater= 2.0,
breathDecoyAim= 3,
breathRestore= 80,

},

fallscale = 1.0,

expressionsTable = {
"Scripts/Expressions/DeadRandomExpressions.lua",-- Dead
"Scripts/Expressions/DefaultRandomExpressions.lua",-- idle
"Scripts/Expressions/SearchRandomExpressions.lua",-- search
"Scripts/Expressions/CombatRandomExpressions.lua",-- combat
},
};


--
-- \return 1=alive / nil=not alife
function BasicPlayer:IsAlive()
if self.GetState then
return self:GetState()=="Alive";
end
end

--
function BasicPlayer:OnBeginDeadState()

if ((self.SwimSound~=nil) and (Sound:IsPlaying(self.SwimSound)==1)) then
Sound:StopSound(self.SwimSound);
self.SwimSound=nil;
end

self:DoRandomExpressions("Scripts/Expressions/DeadRandomExpressions.lua", 0);
-- make sure that there is no weapon sound playing anymore
if (self.cnt.weapon) then
BasicWeapon.Client.OnStopFiring(self.cnt.weapon,self);
end

-- MIXER: Fix stop rebreath sounds
if (self.rebreath_snd) and (Sound:IsPlaying(self.rebreath_snd)) then
Sound:StopSound(self.rebreath_snd); self.rebreath_snd=nil; end

-- MIXER: Fix don't mess with painsound
if Sound:IsPlaying(self.painSound) then
Sound:StopSound(self.painSound); end

BasicPlayer.PlayOneSound( self, self.deathSounds, 110 );
self:ReleaseLipSync();-- we dont want the corpse to say anything...
end
--
function BasicPlayer:MakeDeadbody()
if (Game:IsClient()==nil) then self:EnablePhysics(0); end
if(self.isDedbody~=1) then
self:KillCharacter(0);
self:SetPhysicParams(PHYSICPARAM_SIMULATION, self.DeadBodyParams);
self:SetPhysicParams(PHYSICPARAM_ARTICULATED, self.DeadBodyParams);
self:SetPhysicParams(PHYSICPARAM_BUOYANCY, self.DeadBodyParams);
self.cnt:StartDie( self.deathImpuls, self.deathPoint, self.deathImpulsePart, self.deathType );
self.isDedbody = 1;
end
end
--
function BasicPlayer:OnBeginAliveState()
self:DoRandomExpressions("Scripts/Expressions/DefaultRandomExpressions.lua", 0);
end
--
function BasicPlayer:OnReset()

merge( self, BasicPlayer );
self["AddAmmo"]=BasicPlayer.AddAmmo;
self["GetAmmoAmount"]=BasicPlayer.GetAmmoAmount;
self.bShowOnRadar=nil;-- dont show on radar by default...
self.bEnemyInCombat=0; -- default radarstate
self.cnt:ResetCamera();

local stats = self.cnt;

local nMaterialID=Game:GetMaterialIDByName("mat_flesh");
self:CreateLivingEntity(self.PhysParams, nMaterialID);
self:PhysicalizeCharacter(self.PhysParams.mass, nMaterialID, self.BulletImpactParams.stiffness_scale, 0);
self:SetCharacterPhysicParams(0,"", PHYSICPARAM_SIMULATION,self.BulletImpactParams);
self.isPhysicalized = 1;

self.LastFootStepTime=0;

local CurWeaponInfo = self.weapon_info;
if (CurWeaponInfo) then
	local tempfiremode = self.cnt.firemode+1;
	local w = self.cnt.weapon;
	if (w) then
		local CurFireParams = w.FireParams[tempfiremode];
		local SoundData = CurWeaponInfo.SndInstances[tempfiremode];
		if (SoundData) then
			BasicWeapon.StopFireLoop(CurWeapon, self, CurFireParams, SoundData);
		end
	end
end

stats:SetCurrWeapon( 0 );

if (Mission) and (Mission.soccer_center) then
	self.PlayerDimNormal.ellipsoid_height = 0.7;
	self.PlayerDimCrouch.ellipsoid_height = 0.65;
else
	self.PlayerDimNormal.ellipsoid_height = 1.2;
	self.PlayerDimCrouch.ellipsoid_height = 0.95;
end
stats:SetDimNormal(self.PlayerDimNormal);
stats:SetDimCrouch(self.PlayerDimCrouch);
stats:SetDimProne(self.PlayerDimProne);

stats:SetMinAngleLimitV( self.normMinAngle );
stats:SetMaxAngleLimitV( self.normMaxAngle );
stats:EnableAngleLimitV( 1 );
stats:EnableAngleLimitH( nil );

if (self.AniRefSpeeds == nil) then
self.AniRefSpeeds = self.Properties.AniRefSpeeds;
end

self.cnt:SetAnimationRefSpeedRun(self.AniRefSpeeds.RunFwd,
self.AniRefSpeeds.RunSide,
self.AniRefSpeeds.RunBack);
self.cnt:SetAnimationRefSpeedWalk(self.AniRefSpeeds.WalkFwd,
self.AniRefSpeeds.WalkSide,
self.AniRefSpeeds.WalkBack);
self.cnt:SetAnimationRefSpeedWalkRelaxed(self.AniRefSpeeds.WalkRelaxedFwd,
self.AniRefSpeeds.WalkRelaxedSide,
self.AniRefSpeeds.WalkRelaxedBack);
self.cnt:SetAnimationRefSpeedXWalk(self.AniRefSpeeds.XWalkFwd,
self.AniRefSpeeds.XWalkSide,
self.AniRefSpeeds.XWalkBack);
if(self.AniRefSpeeds.XRunFwd) then
self.cnt:SetAnimationRefSpeedXRun(self.AniRefSpeeds.XRunFwd,
self.AniRefSpeeds.XRunSide,
self.AniRefSpeeds.XRunBack);
end
self.cnt:SetAnimationRefSpeedCrouch(self.AniRefSpeeds.CrouchFwd,
self.AniRefSpeeds.CrouchSide,
self.AniRefSpeeds.CrouchBack);

stats:SetDynamicsProperties( self.DynProp );
if (Game:IsMultiplayer()) then
	local flags = { flags_mask = lef_push_objects+lef_push_players+lef_snap_velocities, flags = lef_snap_velocities, }
	self:SetPhysicParams(PHYSICPARAM_FLAGS, flags);
end

if self.Properties.max_health>255 then-- 255 is the maximum for players (network protocol limitation)
	self.Properties.max_health=255;
end

stats.health = self.Properties.max_health;

stats.max_health = self.Properties.max_health;
stats.armor = 0;
stats.max_armor = 100;
stats.fallscale = self.fallscale;
stats.has_flashlight = 0;
stats.has_binoculars = 0;
self.FlashLightActive = 0;
self.items = {};

--------------------------
-- Mixer: equip items check has been moved to default/gamerules.lua SpawnPlayer
-------------------------------------

if (self.Properties.fMeleeDistance) then
stats.melee_distance = self.Properties.fMeleeDistance;
else
stats.melee_distance = 2.0;
end

self:EnablePhysics(1);
-- apply alien dimension stuff
-- local because clearing this FX on map change is MUST!
-- so direct changing of normal table is DENIED!
if (Mission) and (Mission.alienworld) then
	self.cnt:InitStaminaTable({sprintScale= 1.4,sprintSwimScale = 1.4,decoyRun= 0,decoyJump= 0,breathDecoyUnderwater= 2.0,breathDecoyAim= 3,breathRestore= 80,});
elseif (Game:IsMultiplayer()) and (toNumberOrZero(getglobal("gr_MpNoFatigue"))>0) then
	local st_copy = new(self.StaminaTable);
	st_copy.decoyRun=0;
	st_copy.decoyJump=0;
	self.cnt:InitStaminaTable(st_copy);
else
	self.cnt:InitStaminaTable(self.StaminaTable);
end

self:DrawCharacter( 0,1 );

if (Game:IsServer()) then
self:GotoState( "Alive" );
end

self.cnt:UseLadder(0);
self.cnt:ResetCamera();
self.ladder = nil;
self.downSound = nil;
self.fBodyHeat=1.0;
self.bleed_timer = nil;
self.bodun_timer = nil;

-- available effects: 1= reset, 2= team color, 3= invulnerable, 4= heatsource, 5= stealth mode, 6= mut. arms
self.iPlayerEffect=1;
self.bPlayerHeatMask=0;
self.fLastBodyHeat=0;
self.iLastWeaponID=0;
self.bUpdatePlayerEffectParams=1;
-- render effects
self.iEffectCount=0;
self.pEffectStack={};
self.pEffectStack[1]=1;
self.jumpSoundPlayed = 0;
self.hasJumped = 0;
self.lastStanceSound = 0;
self.scuba_breath_time = nil;

end

--
function BasicPlayer:Server_OnInit()
-- Only when the player spawns the first time
if (self == _localplayer and _LastCheckPPos == nil) then
_LastCheckPPos = self:GetPos();
end
self:RegisterStates( self );
if (not self.wasreset) then
BasicPlayer.OnReset( self );
self.wasreset=1;
end

BasicPlayer.InitAllWeapons(self);

self.MyInventory = new( Inventory );
Game:CreateVariable("p_max_vert_angle");
p_max_vert_angle=90;

if(self.isPhysicalized == 0) then
local nMaterialID=Game:GetMaterialIDByName("mat_flesh");
self:PhysicalizeCharacter(self.PhysParams.mass, nMaterialID, self.BulletImpactParams.stiffness_scale, 0);
self:SetCharacterPhysicParams(0,"", PHYSICPARAM_SIMULATION,self.BulletImpactParams);
self.isPhysicalized = 1;
end

self.Refractive = nil;
self.fLastRefractValue = 0;

self:SetTimer(self.UpdateTime);
self.fBodyHeat=1.0;

if (Game:IsMultiplayer()) and (not self.POTSHOTS) then
	self.LastActivityTime = _time;
	self.LastActivityPos = {x=0,y=0,z=0};
	self.LastActivityPos.zlastchk = _time + 3;
end

end


--
function BasicPlayer:Client_OnInit()

self:RegisterStates();

if (not self.wasreset) then
BasicPlayer.OnReset( self );
self.wasreset=1;
end

if (self.SoundEvents) then
if (not self.Properties.KEYFRAME_TABLE) or (self.Properties.KEYFRAME_TABLE == "BASE_HUMAN_MODEL") then
	merge(self.SoundEvents,self.TpvReloadFX);
end
for i,event in self.SoundEvents do
self:SetAnimationKeyEvent(event[1],event[2],event[3]);
if(event[4]~=nil)then
Sound:SetSoundVolume(event[3],event[4]);
end
end
end

if(self.AnimationBlendingTimes) then
for k,blends in self.AnimationBlendingTimes do
self.cnt:SetBlendTime(blends[1],blends[2]);
end
end

BasicPlayer.InitAllWeapons(self);

self.Refractive = nil;
self.fLastRefractValue = 0;
if(self.isPhysicalized == 0) then
local nMaterialID=Game:GetMaterialIDByName("mat_flesh");
self:PhysicalizeCharacter(self.PhysParams.mass, nMaterialID, self.BulletImpactParams.stiffness_scale, 0);
self:SetCharacterPhysicParams(0,"", PHYSICPARAM_SIMULATION,self.BulletImpactParams);
self.isPhysicalized = 1;
end

--self:RenderShadow( 1 ); -- enable rendering of player shadow

self.cnt:InitDynamicLight(self.lightFileTexture, self.lightFileShader);
self:SetTimer(self.UpdateTime);

self.fBodyHeat=1.0;

-- available effects: 1= reset, 2= team color, 3= invulnerable, 4= heatsource, 5= stealth mode, 6= mutated arms
self.iPlayerEffect=1;
self.bPlayerHeatMask=0;
self.fLastBodyHeat=0;
self.iLastWeaponID=0;
self.bUpdatePlayerEffectParams=1;
-- render effects
self.iEffectCount=0;
self.pEffectStack={};
self.pEffectStack[1]=1;

end


function BasicPlayer:InitAllWeapons(forceInit)
	-- Everytime AddWeapon() is called every active player entity gets
	-- ScriptInitWeapon() called for the new weapon. The name is also placed in
	-- the global WeaponsLoaded table. So new players need to traverse the list
	-- of recently spawned weapons themself and call ScriptInitWeapon() for each
	-- of them. Also, the player entity needs to call MakeWeaponAvailable() for
	-- each weapon in his weapon pack

	self.bAllWeaponsInititalized = nil;

	if (forceInit) then
		if (Mission) and (Mission.alienworld) then
			self.cnt:InitStaminaTable({sprintScale= 1.4,sprintSwimScale = 1.4,decoyRun= 0,decoyJump= 0,breathDecoyUnderwater= 2.0,breathDecoyAim= 3,breathRestore= 80,});
		elseif (Game:IsMultiplayer()) and (toNumberOrZero(getglobal("gr_MpNoFatigue"))>0) then
			local st_copy = new(self.StaminaTable);
			st_copy.decoyRun=0;
			st_copy.decoyJump=0;
			self.cnt:InitStaminaTable(st_copy);
		end
	end

if (self.DontInitWeapons == nil) then
	-- Let the container initialize the C/C++ strutures for all weapons
	self.cnt:InitWeapons();

	-- Create a new map to map weapon entity class IDs to weapon state information
	if (self.WeaponState == nil) then
		self.WeaponState = new(Map);
	end

	-- Main player doesn't have an equipEquipment property, copy from global table
	if (not Game:IsMultiplayer()) then
		if ((self.Properties.equipEquipment == nil) or (self==_localplayer)) then
			self.Properties.equipEquipment = MainPlayerEquipPack;
		end
	else
		if ((self.Properties.equipEquipment == nil)) then
			self.Properties.equipEquipment = MainPlayerEquipPack;
		end
	end

	self.Ammo={};
	for i,val in MaxAmmo do
		self.Ammo[i]=0;
	end

	local primary_weapon;

	-- Copy initial ammo table from equip pack
	if (self.Properties.equipEquipment) then
		local WeaponPack = EquipPacks[self.Properties.equipEquipment];
		local sv_slot;

		if (Game:IsServer()) then
			sv_slot = Server:GetServerSlotByEntityId(self.id);
		end
		if (WeaponPack) then
			if (self.DontResetAmmo == nil) then
				merge(self.Ammo,WeaponPack.Ammo);
			end
			
			local itms_1 = {x=0,y=0,z=0};
			
			--search if there is a primary weapon
			for i,val in WeaponPack do
				if (val.Primary) then
					primary_weapon=val;
				end
				if (val.Type == "Weapon") then
					BasicPlayer.ScriptInitWeapon(self, val.Name);
				elseif (sv_slot) then
					if (val.Type == "Item") then
						if (val.Name == "PickupBinoculars") then
							itms_1.z = itms_1.z + 1;
							self.cnt.has_binoculars = 1;
							itms_1.got = 1;
						elseif (val.Name == "PickupHeatVisionGoggles" and self.items) then
							itms_1.z = itms_1.z + 10;
							self.items.heatvisiongoggles = 1;
							itms_1.got = 1;
						elseif (val.Name == "PickupFlashlight") then
							itms_1.z = itms_1.z + 100;
							self.cnt.has_flashlight = 1;
							itms_1.got = 1;
						end
					end
				end
			end
			if (sv_slot) then
				if (self.keycards) then
					if (self.keycards[4]) and (self.keycards[4] == 1) then
						itms_1.x = itms_1.x + 1;
						itms_1.got = 1;
					end
					if (self.keycards[3]) and (self.keycards[3] == 1) then
						itms_1.x = itms_1.x + 10;
						itms_1.got = 1;
					end
					if (self.keycards[2]) and (self.keycards[2] == 1) then
						itms_1.x = itms_1.x + 100;
						itms_1.got = 1;
					end
					if (self.keycards[1]) and (self.keycards[1] == 1) then
						itms_1.x = itms_1.x + 1000;
						itms_1.got = 1;
					end
				end
				if (self.explosives) then
					itms_1.y = 0;
					for i,val in self.explosives do
						if (val == 1) then
							itms_1.y = itms_1.y + 1;
							itms_1.got = 1;
						end
					end
				end
				--if (itms_1.got) then
					itms_1.got = nil;
					sv_slot:SendCommand("FX",itms_1,{x=0,y=0,z=0},self.id,7);
				--end
			end
		end
	end

	-- place hands here
	if (not self.ai) and (self.cnt.GetWeaponsSlots) then
		BasicPlayer.AddPlayerHands(self);
	end
	-- place hands

	if (primary_weapon and WeaponClassesEx[primary_weapon.Name]) then
		self.cnt:SetCurrWeapon(WeaponClassesEx[primary_weapon.Name].id);
	else
		-- Make sure we have a weapon active
		self.cnt:SelectFirstWeapon();
	end
	
	if (self.cnt.weapon) and (self.cnt.weapon.PlayerSlowDown) then
		if (WeaponsParams.Falcon.Std[1].promode==nil) then
			self.cnt.speedscale = self.cnt.weapon.PlayerSlowDown * 1;
		end
	end
else
	self.DontInitWeapons = nil;
end

--select granade
--the rock
self.cnt.grenadetype=1;

if (self.Ammo) and (GrenadesClasses) and (GrenadesClasses[2]) then
	for i=2,count(GrenadesClasses) do
		if self.Ammo[GrenadesClasses[i]] and self.Ammo[GrenadesClasses[i]] > 0 then
			self.cnt.grenadetype = i*1;
			self.cnt.numofgrenades = self.Ammo[GrenadesClasses[i]]*1;
		end
	end
end

self.bAllWeaponsInititalized = 1;

end

--
function BasicPlayer:ScriptInitWeapon(wName, bIgnoreLoadClips, bIgnoreEquipment)
-- Add the data structures for the passed weapon to this player and make an instance
-- of the sounds. Give the weapon to the player if it is in his weapon pack

-- make sure that the weapon is loaded
Game:AddWeapon(wName);

-- Create a new map to map weapon entity class IDs to weapon state information
if (self.WeaponState == nil) then
self.WeaponState = new(Map);
end

-- Initializing weapon state info
local WeaponStateTemplate  = {
FireMode,     -- Firemode
AmmoInClip,   -- Amount of ammunition in the current clip
};

local CurWeapon = WeaponClassesEx[wName];

if (CurWeapon == nil) then
System:Log("ERROR: Can't find weapon '"..wName.."' in weapon tables !");
do return end;
end

local CurWeaponClsID = CurWeapon.id;

-- Weapon name and table
local weapontbl = getglobal(wName);

-- Create the state table for this weapon
local NewTable = new(WeaponStateTemplate);
NewTable.FireMode = 0;
NewTable.AmmoInClip = {0};
NewTable.Name = wName;
NewTable.SndInstances = {};

for i2, CurFireParameters in weapontbl.FireParams do
NewTable.AmmoInClip[i2] = 0;
if i2>=1 and bIgnoreLoadClips==nil and self.Ammo[CurFireParameters.AmmoType] and self.Ammo[CurFireParameters.AmmoType]>0 then
	if (i2>1) and (weapontbl.FireParams[i2-1].AmmoType) and (weapontbl.FireParams[i2-1].AmmoType==CurFireParameters.AmmoType) then
	else
		local amount;
		local distributed;
		local bpc=CurFireParameters.bullets_per_clip;

		amount=min(bpc,self.Ammo[CurFireParameters.AmmoType]);
		self.Ammo[CurFireParameters.AmmoType]=self.Ammo[CurFireParameters.AmmoType]-amount;

		NewTable.AmmoInClip[i2]=amount;
	end
end
local flags = bor(SOUND_RELATIVE, SOUND_UNSCALABLE);

-- Marco's NOTE: I'm adding here sound priority for weapon sounds. The last parameter
-- in load3dsound is the sound priority, the range is from 0 to 255, with 255
-- being maximum priority
NewTable.SndInstances[i2] = { };
if (type(CurFireParameters.DrySound) == "string") then
NewTable.SndInstances[i2]["DrySound"] = Sound:Load3DSound(CurFireParameters.DrySound, flags,
CurFireParameters.SoundMinMaxVol[1],
CurFireParameters.SoundMinMaxVol[2], CurFireParameters.SoundMinMaxVol[3],128);
end
if (type(CurFireParameters.FireLoop) == "string") then
NewTable.SndInstances[i2]["FireLoop"] = Sound:Load3DSound(CurFireParameters.FireLoop, flags,
CurFireParameters.SoundMinMaxVol[1],
CurFireParameters.SoundMinMaxVol[2], CurFireParameters.SoundMinMaxVol[3],200);
end
if (type(CurFireParameters.FireLoopStereo) == "string") then
NewTable.SndInstances[i2]["FireLoopStereo"] = Sound:LoadSound(CurFireParameters.FireLoopStereo);
end
if (type(CurFireParameters.TrailOff) == "string") then
NewTable.SndInstances[i2]["TrailOff"] = Sound:Load3DSound(CurFireParameters.TrailOff,flags,
CurFireParameters.SoundMinMaxVol[1],
CurFireParameters.SoundMinMaxVol[2], CurFireParameters.SoundMinMaxVol[3],128);
end
if (type(CurFireParameters.TrailOffStereo) == "string") then
NewTable.SndInstances[i2]["TrailOffStereo"] = Sound:LoadSound(CurFireParameters.TrailOffStereo);
end
-- [mixer] mono sounds
if (CurFireParameters.FireSounds) then
	NewTable.SndInstances[i2]["FireSounds"] = { };
	for iSingleSnd, CurSndFile in CurFireParameters.FireSounds do
		if (type(CurSndFile) == "string") then
			local CurrSound = Sound:Load3DSound(CurSndFile, flags,
			CurFireParameters.SoundMinMaxVol[1],
			CurFireParameters.SoundMinMaxVol[2], CurFireParameters.SoundMinMaxVol[3],200);
			if (CurrSound) then
				Sound:SetSoundPitching(CurrSound, 100);
			end
			NewTable.SndInstances[i2]["FireSounds"][iSingleSnd] = CurrSound;
		end
	end
end

-- [marco] stereo sounds

if (CurFireParameters.FireSoundsStereo) then
	NewTable.SndInstances[i2]["FireSoundsStereo"] = { };
	for iSingleSnd, CurSndFile in CurFireParameters.FireSoundsStereo do
		if (type(CurSndFile) == "string") then
			local CurrSound = Sound:LoadSound(CurSndFile);
			if (CurrSound) then
				Sound:SetSoundPitching(CurrSound, 100);
			end
			NewTable.SndInstances[i2]["FireSoundsStereo"][iSingleSnd] = CurrSound;
		end
	end
end

-- [mixer] outdoor sounds

if (CurFireParameters.FireSoundsOUT) then
	NewTable.SndInstances[i2]["FireSoundsOUT"] = { };
	for iSingleSnd, CurSndFile in CurFireParameters.FireSoundsOUT do
		if (type(CurSndFile) == "string") then
			local CurrSound = Sound:Load3DSound(CurSndFile, flags,
			CurFireParameters.SoundMinMaxVol[1],
			CurFireParameters.SoundMinMaxVol[2], CurFireParameters.SoundMinMaxVol[3],200);
			if (CurrSound) then
				Sound:SetSoundPitching(CurrSound, 100);
			end
			NewTable.SndInstances[i2]["FireSoundsOUT"][iSingleSnd] = CurrSound;
		end
	end
end

-- [mixer] outdoor stereo sounds

if (CurFireParameters.FireSoundsOUTstereo) then
	NewTable.SndInstances[i2]["FireSoundsOUTstereo"] = { };
	for iSingleSnd, CurSndFile in CurFireParameters.FireSoundsOUTstereo do
		if (type(CurSndFile) == "string") then
			local CurrSound = Sound:LoadSound(CurSndFile);
			if (CurrSound) then
				Sound:SetSoundPitching(CurrSound, 100);
			end
			NewTable.SndInstances[i2]["FireSoundsOUTstereo"][iSingleSnd] = CurrSound;
		end
	end
end

end

-- Add to the weapon state of this player
self.WeaponState[CurWeaponClsID]=NewTable;
-- Make the weapons available which belong to the player's weapon pack
local WeaponPackName = self.Properties.equipEquipment;
if (bIgnoreEquipment) then
	self.cnt:MakeWeaponAvailable(CurWeaponClsID, 1);
elseif (WeaponPackName) then
	local PlayerPack = EquipPacks[WeaponPackName];
	if (PlayerPack ~= nil) then
		for iIdx, CurPackWeapon in PlayerPack do
			if (CurPackWeapon.Type == "Weapon" and CurPackWeapon.Name == wName) then
				self.cnt:MakeWeaponAvailable(CurWeaponClsID, 1);
				--System:LogToConsole(" --> Name: "..wName);
			end
		end
	end
end
end

--
function BasicPlayer:HelmetOn()
if(self.PropertiesInstance.bHelmetProtection and self.PropertiesInstance.bHelmetProtection==1) then
self.hasHelmet = 1;
end
end

--
function BasicPlayer:HelmetOff()
self.hasHelmet = 0;

end

--
function BasicPlayer:HelmetHitProceed( direction, impuls )

-- we don't have helmets dropped anymore
do return end

if( random(0,3)>1 ) then
do return end
end

local helmet = Server.SpawnEntity("Helmet");
--self.theHelmet = Server.SpawnEntity("Helmet");

local pos = self:GetBonePos("hat_bone");
--self.theHelmet.
helmet:EnablePhysics( 1 );
helmet:SetPos( pos );

direction.z = direction.z + 5;

helmet:AddImpulseObj(direction, impuls);
--theHelmet.Activate(theHelmet, direction, impuls);
helmet:DrawObject(0,1);

BasicPlayer.HelmetOff( self );
end

function BasicPlayer:AddAmmo(AmmoType, Amount)

if(self.Ammo[AmmoType] == nil) then
System:Log("Unknown ammo type so far, add to WeaponSystem.lua-->AmmoAvailable");
return
end

local wi = self.weapon_info;

if(self.cnt.weapon and wi and self.cnt.weapon.FireParams[wi.FireMode+1].AmmoType==AmmoType)then
self.cnt.ammo=self.cnt.ammo + Amount;
self.Ammo[AmmoType] = self.cnt.ammo;
elseif(GrenadesClasses[self.cnt.grenadetype]==AmmoType)then
self.cnt.numofgrenades=self.cnt.numofgrenades + Amount;
self.Ammo[AmmoType] = self.cnt.numofgrenades;
else
self.Ammo[AmmoType] = self.Ammo[AmmoType] + Amount;
end
--automatically switches grenade type
for i,val in GrenadesClasses do
if(AmmoType==val)then
BasicPlayer.SelectGrenade(self,AmmoType);
end
end
end

-- get ammo from all weapons, which the player currently has
-- AmmoType should be a string, such as "SMG" or "ASSAULT"
function BasicPlayer:GetAmmoAmount(AmmoType)
local stats = self.cnt;
local curr_amount = self.Ammo[AmmoType];
local wi = self.weapon_info;

if (stats.weapon and wi and wi.FireMode and stats.weapon.FireParams[wi.FireMode+1].AmmoType == AmmoType) then
curr_amount = stats.ammo;
elseif((stats.grenadetype~=1) and (GrenadesClasses[stats.grenadetype] == AmmoType)) then
curr_amount = stats.numofgrenades;
end

return curr_amount;
end

function BasicPlayer:Client_OnUpdate( DeltaTime )
end

function BasicPlayer:Client_DeadOnUpdate( DeltaTime )
	self:SetScriptUpdateRate(0);
	local stats = self.cnt;
	-- tiago: added body heat, used in CryVision shader -- mixer - slower now
	-- mixer: also used for realistic in-water bleed decreasing
	self.fBodyHeat=self.fBodyHeat - _frametime*0.01;
	if (not self.fBodyHeat) or (self.fBodyHeat<0.0) then self.fBodyHeat = 0.05; end --fail-safe
	BasicPlayer.ProcessPlayerEffects(self);
	-- Mixer: more optimised body fall effects processing
	if (self.downSound == nil) then
		local CurWeaponInfo = self.weapon_info;
		if (CurWeaponInfo) then
			local tempfiremode = stats.firemode+1;
			local w = stats.weapon;
			if (w) then
				local CurFireParams = w.FireParams[tempfiremode];
				local SoundData = CurWeaponInfo.SndInstances[tempfiremode];
				if (SoundData) then
					BasicWeapon.StopFireLoop(CurWeapon, self, CurFireParams, SoundData);
				end
			end
		end
		self.downSound = {x=0,y=0,z=99999};
	end
	if (self.downSound.c == nil) then
		if (stats:HasCollided() == nil) then
			return;
		end
		self.downSound.c = 1; -- collided at last
	end
	local material = stats:GetTreadedOnMaterial();
	if (material == nil) then
		self.downSound.x = 0;
		return;
	else
		local corpse_pos = self:GetPos();
		if (self.downSound.z > corpse_pos.z + 1) then
			if (self.downSound.x == 0) then
				self.BloodTimer = 0;
				ExecuteMaterial(corpse_pos,{x=0,y=0,z=1},material.player_drop,1);
				self.downSound.x = 1; -- if 0, play body fall sound for any fall velocify for first time
			end
			self.downSound.z=corpse_pos.z*1;
		end
	end
end

function BasicPlayer:Server_OnUpdate( DeltaTime )
end

function BasicPlayer:Server_OnEvent( EventId, Params )
local handler=BasicPlayer.Server_EventHandler[EventId];
if(handler)then
return handler(self,Params)
end
end

----------
function BasicPlayer:Server_OnEventDead( EventId, Params )
local handler=BasicPlayer.Server_EventHandlerDead[EventId];
if(handler)then
return handler(self,Params)
end
end


------------------------------------------------------------------------
function BasicPlayer:Client_OnEvent( EventId, Params)
local handler=BasicPlayer.Client_EventHandler[EventId];
if(handler)then
return handler(self,Params)
end
end

------------------------------------------------------------------------
function BasicPlayer:CalcAttenuation(SoundScale)
if (not SoundScale) then
SoundScale=1;
end
do return SoundScale end

if (self and _localplayer and (self~=_localplayer)) then
merge(BasicPlayer.aux_vec, _localplayer:GetPos());
local Pos=self:GetPos();
if (System:IsPointIndoors(BasicPlayer.aux_vec) and System:IsPointIndoors(Pos)) then
local Hits=System:RayWorldIntersection(Pos, BasicPlayer.aux_vec, 10 , self.id);

local Attenuation=getn(Hits)*(20/100);
SoundScale=SoundScale-Attenuation;

end
end
return SoundScale;
end

--
function BasicPlayer:PlaySoundEx(SoundHandle, SoundScale)
SoundScale=BasicPlayer.CalcAttenuation(self, SoundScale);
if (SoundScale>0) then
self:PlaySound(SoundHandle, SoundScale);
end
end

--
function BasicPlayer:PlayOneSound( soundList, chance)

local randnum=random(1,100);
if( (randnum<chance) and (soundList) ) then

local nsounds=getn(soundList);

if (nsounds<=0) then
return nil;
end

local sounddesc=soundList[random(1,nsounds)]

-- do this to try ro avoid repeating the same sound 
if(sounddesc[6]) then
if( _time - sounddesc[6]<2 ) then
sounddesc=soundList[random(1,nsounds)];
if(sounddesc[6]) then
if( _time - sounddesc[6]<2 ) then
sounddesc=soundList[random(1,nsounds)];
end
end
end
end

self.lastsoundplayed=Sound:Load3DSound(sounddesc[1],sounddesc[2],sounddesc[3],sounddesc[4],sounddesc[5]);

if (self.lastsoundplayed) then
self:PlaySound(self.lastsoundplayed,1);
sounddesc[6] = _time;
end

return self.lastsoundplayed;

--BasicPlayer.PlaySoundEx(self,sound); 

end

end

--
function BasicPlayer:SetDeathImpulse( hit )
	self.deathImpuls.x = hit.dir.x;
	self.deathImpuls.y = hit.dir.y;
	self.deathImpuls.z = hit.dir.z;

	self.headshot=0;
	
	if (hit.impact_force_mul_final) then
		self.deathImpuls.x = self.deathImpuls.x*hit.impact_force_mul_final;
		self.deathImpuls.y = self.deathImpuls.y*hit.impact_force_mul_final;
		self.deathImpuls.z = self.deathImpuls.z*hit.impact_force_mul_final;
		if (hit.target_material) and ((hit.target_material.type=="head") or (hit.target_material.type=="leg")) then  
			self.deathImpulseTorso = 0;
			-- [marco] check if this was an headshot, to reward the player afterwards
			if (hit.target_material.type=="head") then
				self.headshot=1;
			end  
		else
			if (not hit.impact_force_mul_final_torso ) then
				hit.impact_force_mul_final_torso  = 0;
			end
			self.deathImpulseTorso = hit.impact_force_mul_final_torso;
			if (hit.impact_force_mul_final_torso>0) then
				if (hit.impact_force_mul2) then
					self.deathImpuls.mul = hit.impact_force_mul2 * 1;
				else
					self.deathImpuls.mul = 2;
				end
				self.deathImpuls.x = self.deathImpuls.x*self.deathImpuls.mul;
				self.deathImpuls.y = self.deathImpuls.y*self.deathImpuls.mul;
				self.deathImpuls.z = self.deathImpuls.z*self.deathImpuls.mul;
			end
		end
	end

	if (hit.pos)  then-- hit was in some point
		self.deathPoint.x = hit.pos.x;
		self.deathPoint.y = hit.pos.y;
		self.deathPoint.z = hit.pos.z;
		self.deathImpulsePart = hit.ipart;
		self.shooter=hit.shooter;
	else-- just damage (fall)
		self.deathPoint.x = 0;
		self.deathPoint.y = 0;
		self.deathPoint.z = 0;
		self.deathImpulsePart = 0;
		self.shooter=nil;
	end
end

function BasicPlayer:SetBleeding(bmin,bmax,dmgrssid)
	if (tonumber(getglobal("gr_bleeding"))>0) then
		if (self.Properties.fSpeciesHostility) and (self.Properties.fSpeciesHostility == 3) then
		elseif (bmax > 0) then
			if (Mission and Mission.alienworld) or (self.items.aliensuit) or (self.isvillager) then
				bmin = 0;
				bmax = ceil(self.cnt.max_health * 0.08);
			end
			if (self.items.bleed_range) then
				self.items.bleed_range = self.items.bleed_range + random(bmin,bmax);
			else
				self.items.bleed_range = random(bmin,bmax);
			end
			if (dmgrssid) then
				self.items.bleed_dmgr = dmgrssid*1;
			end
		end
	end
end

function BasicPlayer:Server_OnDamage(hit)
	if (hit.damage == 0) then
		return nil;
	end
	BasicPlayer.SetDeathImpulse( self, hit );
	hit.damage = abs(hit.damage);
	if (hit.damage_type == "normal") or (hit.explosion) or (hit.damage_type == "healthonly") then
		GameRules:OnDamage(hit);
	-- don't process building damage done on players at all
	elseif (hit.damage_type == "building") then
		if (self.su_turret) and (self.cnt.health > 0) then
			hit.damage = -hit.damage*0.2;
			if (self.cnt.health - hit.damage <= self.cnt.max_health) then
				GameRules:OnDamage(hit);
				local slot;
				if (hit.shooter) then
					slot=Server:GetServerSlotByEntityId(hit.shooter.id);
					if (slot) then
						local sg_progress = (100*self.cnt.health)/self.cnt.max_health;
						sg_progress=format("%.0f",sg_progress);
						slot:SendCommand("P 2 "..sg_progress);
					end
				end
			end
		end
		return;
	end

	if (self.cnt.health > 0) then
		if (not hit.explosion) then
			if (hit.ipart) then
				local skeleton_impulse_scale = 1;
				if (self.BulletImpactParams.bone_impulse_scale) then
					local bonename = self:GetBoneNameFromTable(hit.ipart);
					for idx=1,getn(self.BulletImpactParams.bone_impulse_scale),2 do 
						if (bonename==self.BulletImpactParams.bone_impulse_scale[idx]) then
							skeleton_impulse_scale = self.BulletImpactParams.bone_impulse_scale[idx+1];
							break;
						end
					end
				end
				if (self.BulletImpactParams and self.BulletImpactParams.impulse_scale) then
					skeleton_impulse_scale = skeleton_impulse_scale*self.BulletImpactParams.impulse_scale;
				end
				self:AddImpulse( hit.ipart, hit.pos, hit.dir, hit.impact_force_mul, skeleton_impulse_scale );
			else
				self:AddImpulse( -1, hit.pos, hit.dir, hit.impact_force_mul );
			end
		end
		if (self.ai) and (not Game:IsClient()) then
			-- make ai pausing it's attack on dedicated server
			self:TriggerEvent(AIEVENT_ONBODYSENSOR,0.5);
		end
	end
end

--
function BasicPlayer:Server_OnDamageDead( hit )
if( Game:IsMultiplayer() ) then return; end
if( hit.ipart and (not hit.explosion)) then
self:AddImpulse( hit.ipart, hit.pos, hit.dir, hit.impact_force_mul );
hit.impact_force_mul = hit.impact_force_mul + 1
else
self:AddImpulse( -1, hit.pos, hit.dir, hit.impact_force_mul );
end
end


--
function BasicPlayer:Client_OnDamage( hit )

-- don't process building damage done on players at all
if (hit.damage_type ~= nil and hit.damage_type == "building") then
return;
end

--dont play client side damage effect if the explosion is not really damaging the player.
if (hit.explosion ~= nil) then

local expl = self:IsAffectedByExplosion();

if (expl<=0) then 
--Hud:AddMessage(self:GetName().." skip pain sounds because not affected by explosion");
return;
end
end

BasicPlayer.SetDeathImpulse( self, hit );

if ( self == _localplayer ) then -- localplayer onscreen fx
	if (not Game:IsServer()) and (hit.e_fx == nil) then
	else
		local ShakeAxis = self.cnt:CalcDmgShakeAxis( hit.dir );
		if ( ShakeAxis ) then
			if ( ShakeAxis.y < -0.5 ) then
				Hud.dmgindicator = bor( Hud.dmgindicator, 1 );
				Hud.dmgind_last = 1;
			end
			if ( ShakeAxis.y > 0.5 ) then
				Hud.dmgindicator = bor( Hud.dmgindicator, 2 );
				Hud.dmgind_last = 2;
			end
			if ( ShakeAxis.x < -0.5 ) then
				Hud.dmgindicator = bor( Hud.dmgindicator, 4 );
				Hud.dmgind_last = 4;
			end
			if ( ShakeAxis.x > 0.5 ) then
				Hud.dmgindicator = bor( Hud.dmgindicator, 8 );
				Hud.dmgind_last = 8;
			end

			-- tiago: i've decreased shake amount to half..
			--local ShakeAmount = hit.damage * .05;

			--filippo: cap shake between 0-13 (0 = 0 damage, 13 = 100 damage)
			local ShakeAmount = min(hit.damage,100.0);
			ShakeAmount = ShakeAmount/100.0*13.0;
			--Hud:AddMessage(hit.damage..","..ShakeAmount);
			if (hit.bodun) then
				ShakeAmount = hit.damage * 6;
				if self.theVehicle then
					
				else
					self.cnt:ShakeCamera( ShakeAxis, ShakeAmount, 2, 5.3);
				end
			else
				if ( ShakeAmount > 45 ) then
					ShakeAmount = 45;
				end
				if(random(1,100)<50) then
					ShakeAmount = -ShakeAmount;
				end
				self.cnt:ShakeCamera( ShakeAxis, ShakeAmount, 2, .33);
			end
		end

		-- [tiago]handle diferent screen damage fx's..
		-- fix, since player continues to get damage after dead make sure no screen fx
		if (hit.damage>0 and self.cnt.health > 0) then
		-- override previous hit damage indicators
			if (hit.bleeding) then
				if (Hud.dmgind_last) then
					Hud.dmgindicator = bor( Hud.dmgindicator, Hud.dmgind_last );
				else
					Hud.dmgindicator = bor( Hud.dmgindicator, 8 );
				end
				Hud.cis_bleed_val = hit.damage*1;
			elseif (hit.falling) then
				Hud.dmgindicator = bor( Hud.dmgindicator, 16 );
				Hud:OnMiscDamage(hit.damage*0.4);
			elseif (hit.bodun) then
				Hud.cis_bodun_val = hit.damage*2;
			elseif (hit.explosion) then
				Hud:OnMiscDamage(hit.damage/5);
				Hud:SetScreenDamageColor(0.25, 0.0, 0);
			elseif (hit.drowning) then
				Hud:OnMiscDamage(hit.damage);
				Hud:SetScreenDamageColor(0.6, 0.7, 0.9);
			elseif (hit.fire) then
				Hud:OnMiscDamage(hit.damage*10);
				Hud:SetScreenDamageColor(0.9, 0.8, 0.8);
			elseif (Hud.meleeDamageType=="MeleeDamageNormal") then
				Hud.meleeDamageType=nil;
				Hud:OnMiscDamage(hit.damage);
				Hud:SetScreenDamageColor(0.9, 0.8, 0.8);
			elseif (Hud.meleeDamageType=="MeleeDamageGas") then
				Hud.meleeDamageType=nil;
				Hud:OnMiscDamage(hit.damage);
				Hud:SetScreenDamageColor(0.0, 0.4, 0.1);
			else
				Hud:OnMiscDamage(hit.damage/30.0);
				Hud:SetScreenDamageColor(0.9, 0.8, 0.8);
			end
		end
		BasicPlayer.PlayPainAnimation( self, hit );
	end
else
	BasicPlayer.PlayPainAnimation( self, hit );
end
end

------
function BasicPlayer:DoStepSound()
local pos=self:GetPos();
local normal = g_Vectors.up;
self.LastMaterial=self.cnt:GetTreadedOnMaterial();

 if(self.LastMaterial ~= nil) then
 if ((_time-self.LastFootStepTime)<0.20) then
 return
 end

 self.LastFootStepTime=_time;

--if its an AI that use a custom step sound return, because we already play the sound into "DoCustomStep" function.
if (self.footstepsounds and BasicAI.DoCustomStep(self,self.LastMaterial,pos)) then
	return;
end

if(not Game:IsPointInWater(pos)) then-- player feet not under water 
 local SoundTable=self.LastMaterial.player_walk;
 local SoundScale=BasicPlayer.soundScale.walk;
local EventScale = BasicPlayer.soundEventRadius.walk;
if( self.cnt.running ) then
--AI.SoundEvent(self.id,pos,BasicPlayer.soundRadius.run,0,1,self.id);
SoundTable=self.LastMaterial.player_run;
SoundScale=BasicPlayer.soundScale.run;
EventScale = BasicPlayer.soundEventRadius.run;
elseif( self.cnt.crouching ) then
--AI.SoundEvent(self.id,pos,BasicPlayer.soundRadius.crouch,0,1,self.id);
SoundTable=self.LastMaterial.player_crouch;
SoundScale=BasicPlayer.soundScale.crouch;
EventScale = BasicPlayer.soundEventRadius.crouch;

elseif( self.cnt.proning ) then
--AI.SoundEvent(self.id,pos,BasicPlayer.soundRadius.prone,0,1,self.id);
SoundTable=self.LastMaterial.player_prone;
SoundScale=BasicPlayer.soundScale.prone;
EventScale = BasicPlayer.soundEventRadius.prone;
else
--AI.SoundEvent(self.id,pos,BasicPlayer.soundRadius.walk,0,1,self.id);
--SoundScale=BasicPlayer.soundScale.walk;
end
if (SoundTable) then
	ExecuteMaterial(pos, normal, SoundTable, 1, nil, nil, self.cnt);
end
--System:LogToConsole("FOOTSTEP");
-- lets play random equipment sounds if available
if (self.EquipmentSoundProbability and self.EquipmentSounds) then
local EquipmentSounds=getn(self.EquipmentSounds);
if ((EquipmentSounds>0) and (random(1,100)<=self.EquipmentSoundProbability)) then
local EquipmentSound=self.EquipmentSounds[random(1, EquipmentSounds)];
--Sound:SetSoundPosition(EquipmentSound, pos);
BasicPlayer.PlaySoundEx(self, EquipmentSound, SoundScale);
end
end
else
if ((self.Diving and self.Diving==0) or (self.Diving==nil)) then
	ExecuteMaterial(pos,normal,self.LastMaterial.player_walk_inwater,1, nil, nil, self.cnt);
end
--System:LogToConsole("\001 WATER FOOTSTEP");
end
else
--System:LogToConsole("BasicPlayer:DoStepSound() nil material");
--if(self.cnt.flying~=nil)then
--System:LogToConsole("\001 BasicPlayer:DoStepSound() nil material");
--end
end

end

-----------------------------------
function BasicPlayer:DoBushSound()

--do return end-- [lennert] this will execute footsteps twice in indoors !
--local pos=self:GetPos();
--local normal = g_Vectors.up;
--local materialSoft=self.cnt:GetTouchedMaterial();

local pos=self:GetPos();
local normal = g_Vectors.up;
local materialSoft=self.cnt:GetTouchedMaterial();

if(materialSoft ~= nil) then
if(self.InWater==0) then
if( self.cnt.running ) then
ExecuteMaterial(pos, normal, materialSoft.player_walk_by, 1, nil, nil, self.cnt);
elseif( self.cnt.crouching ) then
ExecuteMaterial(pos, normal, materialSoft.player_walk_by, 1, nil, nil, self.cnt);
elseif( self.cnt.proning ) then
ExecuteMaterial(pos, normal, materialSoft.player_walk_by, 1, nil, nil, self.cnt);
else
ExecuteMaterial(pos, normal, materialSoft.player_walk_by, 1, nil, nil, self.cnt);
end
end

end
--self.bushSndTime = 0.7;
end


--
function BasicPlayer:DoStepSoundAI()
-- no footstep sound when in stealth mode
if (self.DTSingleP < _time) then

	local material=self.cnt:GetTreadedOnMaterial();
	--[filippo]
	local soundradius=0;

	if(material ~= nil) then
		self.BushInCounterAI = self.BushInCounterAI + 1;
		local soundScale = self.BushInCounterAI/self.BushSoundScaleAI;
		if(soundScale > 1) then
			soundScale = 1;
		end

		local pos=self:GetPos();
		if( self.cnt.running ) then
			if (self.imrunsprinting) then --player is sprinting
				soundradius = BasicPlayer.soundRadius.sprint*soundScale;
				self.DTSingleP = _time + 0.2;
			else
				soundradius = BasicPlayer.soundRadius.run*soundScale;
				self.DTSingleP = _time + 0.3;
			end

		elseif( self.cnt.crouching ) then
			--[filippo]
			soundradius = BasicPlayer.soundRadius.crouch*soundScale;
			self.DTSingleP = _time + 0.6;
		elseif( self.cnt.proning ) then
			--[filippo]
			soundradius = BasicPlayer.soundRadius.prone*soundScale;
			self.DTSingleP = _time + 0.7;
		else
			--[filippo]
			soundradius = BasicPlayer.soundRadius.walk*soundScale;
			self.DTSingleP = _time + 0.5;
		end
		--[filippo]
		AI:SoundEvent(self.id,pos,soundradius,0,1,self.id);
	else
		self.BushInCounterAI = 0;
	end
end
end
--
function BasicPlayer:DoBushSoundAI()
	local stats = self.cnt;
	-- no footstep sound when in stealth mode
	local materialSoft=stats:GetTouchedMaterial();
	if(materialSoft ~= nil) and (self.DTSingle < _time) then
		local pos=self:GetPos();
		if( stats.running ) then
			AI:SoundEvent(self.id,pos,BasicPlayer.soundRadius.run,0,1,self.id);
		elseif( stats.crouching ) then
			AI:SoundEvent(self.id,pos,BasicPlayer.soundRadius.crouch,0,1,self.id);
		elseif( stats.proning ) then
			AI:SoundEvent(self.id,pos,BasicPlayer.soundRadius.prone,0,1,self.id);
		else
			AI:SoundEvent(self.id,pos,BasicPlayer.soundRadius.walk,0,1,self.id);
		end
		self.DTSingle = _time + 0.25;
	end
end

------------
function BasicPlayer:DoLandSound()

--if( self.cnt.doLandSound == 1 ) then
local pos=self:GetPos();
local normal = g_Vectors.up;
local material=self.cnt:GetTreadedOnMaterial();
if(material ~= nil) then
if (Game:IsPointInWater(self:GetPos()) ~= nil) then-- player feet under water
ExecuteMaterial(pos,normal,material.player_walk_inwater,1);
else
ExecuteMaterial(pos,normal,material.player_walk,1);
end
end
if( Game:IsMultiplayer() and (self ~= _localplayer) )then
Game:SoundEvent(pos,BasicPlayer.soundEventRadius.jump,1,self.id);
end
--end
--self.cnt.doLandSound = 0;
end


--
function BasicPlayer:UpdateInWaterSplash()
if (self ~= _localplayer) then
return
end

if (Game:IsPointInWater(self:GetPos()) ~= nil) then-- player feet under water
Sound:SetGroupScale(SOUNDSCALE_UNDERWATER, 1);
local vCamPos = self:GetCameraPosition();
local bIsCameraUnderwater = Game:IsPointInWater(vCamPos);

self.InWater = 1;

-- If player is partialy in water, play swim/splash sounds do particles
if (bIsCameraUnderwater==nil) then-- partially under water

--r_WaterRefractions=0;

-- stop underwater sound
if (self.sndUnderwaterNoise and Sound:IsPlaying(self.sndUnderwaterNoise)) then
Sound:StopSound(self.sndUnderwaterNoise);
end

if (Sound:IsPlaying(self.sndUnderWaterSwim)) then
Sound:StopSound(self.sndUnderWaterSwim);
end

if (self.Diving and self.Diving~=0) then
if (self.cnt.stamina > 0.12) then
self.rebreath_snd=self.sndBreathIn[1]; else
self.rebreath_snd=self.sndBreathIn[2]; end
Sound:PlaySound(self.rebreath_snd);
end

self.Diving=0;
if (not self.cnt.moving) then
return
end
--if (self.LastMaterial==nil) then
if (self.cnt:IsSwimming()) then

--System:Log("\001")

if ((self.SwimSound==nil) or (not Sound:IsPlaying(self.SwimSound))) then
--local iSoundIdx = random(1, getn(BasicPlayer.sndWaterSwim));
--self.SwimSound = BasicPlayer.sndWaterSwim[iSoundIdx];
self.SwimSound = BasicPlayer.sndWaterSwim;
if (self.SwimSound) then
Sound:SetSoundLoop(self.SwimSound, 1);
Sound:PlaySound(self.SwimSound);
end
end
else
if ((self.SwimSound~=nil) and (Sound:IsPlaying(self.SwimSound)==1)) then
Sound:StopSound(self.SwimSound);
self.SwimSound=nil;
end
end
-- Spawn ripples if player enters water
if (iLastWaterSurfaceParticleSpawnedTime == nil) then
self.iLastWaterSurfaceParticleSpawnedTime = _time;
end
if (_time - self.iLastWaterSurfaceParticleSpawnedTime > 0.2) then
local vVec = self:GetPos();
vVec.z = Game:GetWaterHeight() + 0.02;
vVec.x = vVec.x + 0.25 - random(1, 100) / 200;
vVec.y = vVec.y + 0.25 - random(1, 100) / 200;
Particle:CreateParticle( vVec, g_Vectors.up, BasicPlayer.WaterRipples );
self.iLastWaterSurfaceParticleSpawnedTime = _time;
end
else-- fully under water
Sound:SetGroupScale(SOUNDSCALE_UNDERWATER, 0);
self.Diving=1;

-- If player is under water, play random under-water noises and stop
-- the swim/splash sounds
if ((self.SwimSound~=nil) and (Sound:IsPlaying(self.SwimSound)==1)) then
Sound:StopSound(self.SwimSound);
self.SwimSound=nil;
end

-- MIXER: Fix stop rebreath sounds
if (self.rebreath_snd) and (Sound:IsPlaying(self.rebreath_snd)) then
Sound:StopSound(self.rebreath_snd); self.rebreath_snd=nil; end

if ((Sound:IsPlaying(self.sndUnderwaterNoise)~=1)) then
Sound:SetSoundLoop(self.sndUnderwaterNoise, 1);
Sound:PlaySound(self.sndUnderwaterNoise);
end
-- if moving - play underwaterSwim sound
if ( self.cnt.moving ) then
if (not Sound:IsPlaying(self.sndUnderWaterSwim)) then
Sound:SetSoundLoop(self.sndUnderWaterSwim, 1);
Sound:PlaySound(self.sndUnderWaterSwim);
end
elseif (Sound:IsPlaying(self.sndUnderWaterSwim)) then
Sound:StopSound(self.sndUnderWaterSwim);
end
end
else-- not in water at all
Sound:SetGroupScale(SOUNDSCALE_UNDERWATER, 1);
self.InWater = 0;
self.Diving=0;
if ((self.SwimSound~=nil) and (Sound:IsPlaying(self.SwimSound)==1)) then
Sound:StopSound(self.SwimSound);
self.SwimSound=nil;
end
if ((self.sndUnderwaterNoise~=nil) and (Sound:IsPlaying(self.sndUnderwaterNoise)==1)) then
Sound:StopSound(self.sndUnderwaterNoise);
end
if (self.sndUnderWaterSwim~=nil and Sound:IsPlaying(self.sndUnderWaterSwim)) then
Sound:StopSound(self.sndUnderWaterSwim);
end
end
end
------------------------------------------------------------------------
function BasicPlayer:Reload()

local stats = self.cnt;
local CurWeaponInfo = self.weapon_info;
local CurWeapon = stats.weapon;
if(stats.weapon)then

if (self.ai) then 
if (stats.ammo_in_clip > self.fireparams.bullets_per_clip/2) then
do return end
end
end

BasicWeapon.Client.Reload( CurWeapon, self );
BasicWeapon.Server.Reload( CurWeapon, self );
stats.weapon_busy=CurWeapon.FireParams[CurWeaponInfo.FireMode+1].reload_time;
end

end

--------------
function BasicPlayer:OnLoad(stm)
self.cnt.ammo = 0;
self.cnt.ammo_in_clip = 0;

local mutated = stm:ReadBool();
if (mutated) then
self.iPlayerEffect = 6;
end
self.cnt.has_binoculars = stm:ReadBool();
self.cnt.has_flashlight = stm:ReadBool();
self.Energy=stm:ReadInt();
self.MaxEnergy=stm:ReadInt();
self.Refractive=stm:ReadBool();
self.bShowOnRadar=stm:ReadBool();
self.bEnemyInCombat=stm:ReadBool();

-- set Rail-only mode related stuff for SP
if (not self.ai) then
	if (self.bShowOnRadar) and (self.bShowOnRadar == 1) then
		if (self.bEnemyInCombat) and (self.bEnemyInCombat == 1) then
			setglobal("cis_railonly",2);
		else
			setglobal("cis_railonly",1);
		end
		GameRules.insta_play = 1;
	else
		setglobal("cis_railonly",0);
		GameRules.insta_play = nil;
	end
end

if self.MaxEnergy == 0 then
	self.hasHelmet = 0;
	self:DetachObjectToBone("hat_bone");
end
local count=stm:ReadInt();
if (count > 0) then
-- Mixer: next line prevents weapon activation sound from
-- being played after load (see BasicWeapon.lua also)
self.cis_svgload = 1;
end
while(count>0) do
local weaponName = stm:ReadString();
local idx = stm:ReadInt();
System:Log("LOADING "..idx);
local t=ReadFromStream(stm);
local fm=stm:ReadInt();
if(self.WeaponState[idx] == nil) then
-- init the weapon
BasicPlayer.ScriptInitWeapon(self, weaponName);
end

if (self.WeaponState[idx]) then
self.WeaponState[idx].AmmoInClip=t;
self.WeaponState[idx].FireMode=fm;
else
System:Log("WARNING WEAPON STATE NOT FOUND ");
end
count=count-1;
end
self.Ammo=ReadFromStream(stm);

self.fBodyHeat=1.0;
end

------------------------------------------------------------------------
-- this makes sure that all cached ammo values of currently active weapons/grenades are
-- written back to the respective stores (Ammo and AmmoInClip in the weaponstate)
function BasicPlayer:SyncCachedAmmoValues()
if (self.cnt.weapon and (self.fireparams ~= nil)) then
self.Ammo[self.fireparams.AmmoType]=self.cnt.ammo;
local weaponState = GetPlayerWeaponInfo(self);
if (weaponState) then
weaponState.AmmoInClip[self.firemodenum]=self.cnt.ammo_in_clip;
end
end
-- make sure grenade ammo is up-to-date
self.Ammo[GrenadesClasses[self.cnt.grenadetype]]=self.cnt.numofgrenades;
end
-------
function BasicPlayer:OnSave(stm)

BasicPlayer.SyncCachedAmmoValues(self);

-- is the player mutated?
stm:WriteBool(self.iPlayerEffect and self.iPlayerEffect == 6);
stm:WriteBool(self.cnt.has_binoculars);
stm:WriteBool(self.cnt.has_flashlight);
stm:WriteInt(self.Energy);
stm:WriteInt(self.MaxEnergy);
stm:WriteBool(self.Refractive);

-- set Rail-only mode related stuff for SP
if (not self.ai) then
	if (toNumberOrZero(getglobal("cis_railonly")) > 0) then
		self.bShowOnRadar = 1;
		if (toNumberOrZero(getglobal("cis_railonly"))==2) then
			self.bEnemyInCombat=1;
		else
			self.bEnemyInCombat=0;
		end
	else
		self.bShowOnRadar = 0;
	end
end

stm:WriteBool(self.bShowOnRadar);
stm:WriteBool(self.bEnemyInCombat);

local nentries=0;
for i,val in self.WeaponState do
if(type(i)=="number"
and type(val.AmmoInClip)=="table")then nentries=nentries+1; end
end
stm:WriteInt(nentries);
for i,val in self.WeaponState do
if(type(i)=="number"
and type(val.AmmoInClip)=="table")then
--System:Log("SAVING "..i);
stm:WriteString(val.Name);
stm:WriteInt(i);
WriteToStream(stm,val.AmmoInClip);
stm:WriteInt(val.FireMode);
end
end

WriteToStream(stm,self.Ammo);

-- saving camera mode
--if(not self.cnt.first_person) then
--else
--end
--
--if(self.cnt.first_person==nil and self==_localplayer)then
--stm:WriteInt( 1 );
--else
--stm:WriteInt( 0 );
--end
end


----------------------------------------------------------------------
function BasicPlayer:ProcessCommand( Params )
local Sender = System:GetEntity( Params.Sender );
-- SAY
if ( Params.CommandID == CMD_GO ) then
Game:ShowIngameDialog(-1, "", "", 12,"A new command has been received: $4Go to the location marked on your map !", 10);
Game:SetNavPoint("Go", Params.Target);
elseif ( Params.CommandID == CMD_ATTACK ) then
Game:ShowIngameDialog(-1, "", "", 12,"A new command has been received: $4Attack the location marked on your map !", 10);
Game:SetNavPoint("Attack", Params.Target);
elseif ( Params.CommandID == CMD_DEFEND ) then
Game:ShowIngameDialog(-1, "", "", 12,"A new command has been received: $4Defend the location marked on your map !", 10);
Game:SetNavPoint("Defend", Params.Target);
elseif ( Params.CommandID == CMD_COVER ) then
Game:ShowIngameDialog(-1, "", "", 12,"A new command has been received: $4Cover the location marked on your map !", 10);
Game:SetNavPoint("Cover", Params.Target);
elseif ( Params.CommandID == CMD_BARRAGEFIRE ) then
Game:ShowIngameDialog(-1, "", "", 12,"A new command has been received: $4Barrage Fire at the location marked on your map !", 10);
Game:SetNavPoint("Barrage Fire", Params.Target);
end
end

-----------------------------------------
Server_SpawnGrenadeCallback =
{
OnEvent = function( self, event, Params )
local player = Params.player;
if (player.cnt) and (not player.abortGrenadeThrow) then
	if (player.grenade_ready_time) and (player.grenade_ready_time > _time) then return; end
	-- Lets just assume we are supposed to throw a grenade

	player.cnt:GetFirePosAngles(Params.pos, Params.angles, Params.dir);

	--grenade should spawn a bit forward than the player eye pos, this to prevent problems with the leaning for example.
	local testpos = g_Vectors.temp_v1;

	CopyVector(testpos,Params.pos);

	local pos = Params.pos;
	local dir = Params.dir;

	dir.w = 0.5;

	testpos.x = testpos.x + dir.x * dir.w;
	testpos.y = testpos.y + dir.y * dir.w;
	testpos.z = testpos.z + dir.z * dir.w;

	--test the shifted position, if its safe , use it.
	hits = System:RayWorldIntersection(pos, testpos, 1,ent_static+ent_sleeping_rigid+ent_rigid+ent_independent+ent_terrain,self.id,Grenade.id);

	if (getn(hits) == 0) then
		CopyVector(Params.pos,testpos);
	end
	
	local Grenade = Server:SpawnEntity(GrenadesClasses[player.cnt.grenadetype]);

	if (Grenade) then
		if (not (player.cnt.grenadetype == 1))then
			player.cnt.numofgrenades = player.cnt.numofgrenades-1;
		end

		--projectiles (grenades, for ex) should inherit player's velocity
		--it's calculated in C code, here we should get the correct velocity already
		Grenade:Launch(player.cnt.weapon, player, Params.pos, Params.angles, Params.dir, Params.lifetime);
		if Grenade.throw_sound and Grenade.throw_sound~="" then --hfcr2
		local sound = Sound:Load3DSound(Grenade.throw_sound)
		Sound:SetSoundVolume(sound,188) 
		Sound:SetSoundPosition(sound,player:GetPos()) 
		Sound:PlaySound(sound,1) 
	end
	end
	player.grenade_ready_time = _time + 1.3;
end
player.abortGrenadeThrow = nil;
end
}
--
function BasicPlayer:Server_OnFireGrenade(Params)
if (Game:IsMultiplayer()) and (Mission) and (Mission.soccer_center) then
	do return end;
end
local stats = self.cnt;

if ((type(Params)=="table" and Params.underwater) or stats:IsSwimming() or stats.reloading) then return end

if self.abortGrenadeThrow then
self.abortGrenadeThrow = nil
end

if ((stats.grenadetype == 1) or stats.numofgrenades>0) then
stats.weapon_busy=1.5;
else
System:Log("WARNING self.cnt.numofgrenades<0 this shouldn't happen");
end

local ThrowParams = new(Params);
ThrowParams.player = self;
Game:SetTimer( Server_SpawnGrenadeCallback, 12 * (1000/30), ThrowParams);
end
---------
function BasicPlayer:Client_OnFireGrenade(Params) --hfcr1
	if (Game:IsMultiplayer()) and (Mission) and (Mission.soccer_center) then
		do return end;
	end
	local stats = self.cnt;
	if((type(Params)=="table" and Params.underwater) or stats:IsSwimming() or stats.reloading) then return end
	if (not (stats.grenadetype == 1) and not (stats.numofgrenades>0)) then
		do return end;
	end
	if ((_localplayer == self) and (stats.weapon)) then
		if (ClientStuff.vlayers:IsActive("Binoculars")) then
			ClientStuff.vlayers:DeactivateLayer("Binoculars");
		end
		BasicWeapon.Client.OnStopFiring(stats.weapon,self);
		stats.weapon:StartAnimation(0, "Grenade11",0,0);
		if (stats.weapon.name) and (stats.weapon.name=="AK74") then
			self.pckanm_do = _time + 0.9;
		end
	end
	stats.weapon_busy=1.5;
end

function BasicPlayer:IsDrowning()
--filippo, the drowning check didnt count if the player is underwater or not, this caused drowning screen while jumping with low stamina.
if (self.cnt.underwater>0) and (self.cnt.health>0) then
	local stats = self.cnt;
	if (self.items.scubagear) then
		if (self.items.scubagear > 0) then
			if (not self.scuba_breath_time) then
				self.scuba_breath_time = _time + 4;
			else
				if (self.scuba_breath_time < _time) then
					self.scuba_breath_time = _time + 6;
					self.items.scubagear = self.items.scubagear - (100/250); -- means 25 minutes scuba capacity
					if (_localplayer) and (self == _localplayer) then
						BasicPlayer.PlayInteractSound(_localplayer,"Sounds/building/smoke.wav");
					end
				end
			end
			return nil;
		end
	end
	if (stats.stamina>0) then
		return nil;
	end
local dmgScale = _frametime;
-- let's cap it to prevent lots of damage if frame was long (was loading in this frame)
if(dmgScale>0.03) then dmgScale = 0.03 end
return {
dir = g_Vectors.v001,
damage = 230*dmgScale,
target = self,
shooter = self,
landed = 1,
impact_force_mul_final=5,
impact_force_mul=5,
damage_type="healthonly",
drowning=1,
e_fx = "drowning";
};
else
return nil;
end
end

-------------------------------------------------
--
function BasicPlayer:Server_OnTimer()

self:SetScriptUpdateRate(self.UpdateTime);

local stats = self.cnt;

local hit = BasicPlayer.IsDrowning(self);
if hit then self:Damage(hit); end

-- If not in vehicle and not at mounted weapon
-- restrict angles
if ( stats.proning ) then
	if (self.isProning == 0) then
		self.isProning=1;
		stats:SetMinAngleLimitV( self.proneMinAngle );
		stats:SetMaxAngleLimitV( self.proneMaxAngle );
	end
elseif (self.isProning == 1) then
	self.isProning=0;
	stats:SetMinAngleLimitV( self.normMinAngle );
	stats:SetMaxAngleLimitV( self.normMaxAngle );
end

-- Update the energy
if (self.EnergyIncreaseRate) and (self.ChangeEnergy) then
	self:ChangeEnergy(self.EnergyIncreaseRate * self.UpdateTime/1000.0);
end

if (stats.moving) then
	BasicPlayer.DoBushSoundAI(self);
	BasicPlayer.DoStepSoundAI(self);
else
	self.DTSingleP = _time + 0.4;
end

-- Mixer: rail-only mode SETUP:
if (GameRules.insta_play) then
	if (stats.weapon) then
		if (self.fireparams.railed == nil) and (self.fireparams.vehicleWeapon==nil) then
			if (stats.lock_weapon) then return end
			local cw = strfind(stats.weapon.name,"Tool");
			local ws = stats:GetWeaponsSlots();
			local lastw = stats.weapon.classid*1;
			if (ws) then
				for i,wp in ws do
					if (wp~=0) then
						-- not a tool, not railbow, take weapon OUT:
						if (strfind(wp.name,"Tool")==nil) and (wp.name~="Bow") then
							stats:MakeWeaponAvailable(WeaponClassesEx[wp.name].id,0);
						elseif (wp.name=="Bow") and (not self.items.insta_prevweap) then
							self.items.railbow = 1; -- this flag means railbow was present before applying insta_play rules
						end
					end
				end
				if (not self.items.insta_prevweap) then
					self.items.insta_prevweap = lastw;
				end
			end
			if (cw==nil) then
				if (not self.items.railbow) then
					stats:MakeWeaponAvailable(WeaponClassesEx["Bow"].id);
				end
				stats:SetCurrWeapon(WeaponClassesEx["Bow"].id);
				stats.ammo = 40;
			end
		end
	elseif (not self.theVehicle) and (self.cnt.health > 0) then
		if (self.items) and (self.items.gr_item_id) then
		else
			stats:MakeWeaponAvailable(WeaponClassesEx["Bow"].id);
			stats:SetCurrWeapon(WeaponClassesEx["Bow"].id);
			stats.ammo = 40;
		end
	end
elseif (self.items.insta_prevweap) then
	stats:MakeWeaponAvailable(self.items.insta_prevweap);
	stats:SetCurrWeapon(self.items.insta_prevweap);
	if (not self.items.railbow) then
		stats:MakeWeaponAvailable(WeaponClassesEx["Bow"].id,0);
	end
	self.items.insta_prevweap = nil;
elseif (self.items.bleed_range) then
	if (not self.bleed_timer) then
		self.bleed_timer = _time + 3;
	end
	if (self.bleed_timer < _time) then
		self.bleed_timer = _time + 3;
		local bleed_perc = ceil(self.items.bleed_range * 0.2);
		self.items.bleed_range = self.items.bleed_range - bleed_perc;
		local hit = {
			dir = {x=0,y=0,z=-1},
			damage = bleed_perc,
			target = self,
			landed = 1,
			bleeding = 1,
			impact_force_mul_final=1,
			impact_force_mul=1,
			damage_type = "healthonly",
			weapon = {name="Bleed"},
		};
		if (self.items.bleed_dmgr) then
			hit.shooterSSID = self.items.bleed_dmgr;
		else
			hit.shooter = self;
		end
		
		if (self.POTSHOTS) and (self.ai==nil) then
			if (self:GetAmmoAmount("Bandage")>0) then
				self.cnt.grenadetype = 2;
				self:InsertSubpipe(0,"bomb_the_beacon");
			end
		end
		self:Damage(hit);
		if (Game:IsMultiplayer()) then
			Server:BroadcastCommand("CHI "..hit.target.id.." "..hit.target.id.." "..hit.damage.." b");
		else
			BasicPlayer.Client_OnDamage(self,hit);
		end
		if (self.items.bleed_range <= 0) then
			self.items.bleed_range = nil;
			self.bleed_timer = nil;
		end
	end
elseif (self.items.bodun_range) then
	if (not self.bodun_timer) then
		self.bodun_timer = _time + 3;
	end
	if (self.bodun_timer < _time) then
		self.bodun_timer = _time + 3;
		local bleed_perc = self.items.bodun_range * 0.05;
		self.items.bodun_range = self.items.bodun_range - bleed_perc;
		local hit = {
			dir = {x=0,y=0,z=-1},
			damage = bleed_perc*11,
			target = self,
			landed = 1,
			bodun = 1,
			impact_force_mul_final=1,
			impact_force_mul=1,
			damage_type = "healthonly",
			weapon = {name="Suicide"},
		};
		

		if (Game:IsMultiplayer()) then
			Server:BroadcastCommand("CHI "..hit.target.id.." "..hit.target.id.." "..hit.damage.." v");
		else
			BasicPlayer.Client_OnDamage(self,hit);
		end
		
		if hit.damage > 15 then
			hit.damage = (hit.damage - 4)*(self.cnt.max_health*0.015);
			self:Damage(hit);
		end
		
		if (self.items.bodun_range <= 0) then
			self.items.bodun_range = nil;
			self.bodun_timer = nil;
		end
	end
end
-- Be CAREFUL with that piece of code!

-- when in vehicle (boat) - see if collides with sometnig

BasicPlayer.UpdateCollisions(self);
BasicPlayer.PlayerJumped(self);

if self.ai then	self:BasicPlayerTimer()	end -- K0tanski

end

function BasicPlayer:GetDistanceToTarget(att_target) -- K0tanski
	local Attention
	if not att_target then
		att_target = AI:GetAttentionTargetOf(self.id)
		Attention = 1
	end
	local Distance
	-- if att_target and type(att_target)=="table" and att_target.type=="Player" then
	if att_target and (not Attention or (type(att_target)=="table" and att_target.type=="Player")) then
		if self.theVehicle and att_target.GetPos then -- Вот пусть от машины и измеряет, иначе, сидя за пушкой в машине позиция отсчитывается от нулевой точки. (
			Distance = self.theVehicle:GetDistanceFromPoint(att_target:GetPos())
		else
			Distance = self:GetDistanceFromPoint(att_target:GetPos())
		end
		-- System:Log(self:GetName()..": DistanceToTarget: "..Distance)
	end
	return Distance
end


-- IMPROVED DIVING BY MIXER
BasicPlayer.fp_watersplash = {
particleEffects = {
name = "water.water_splash.a",
scale = 0.8,
},
sounds = {
{"Sounds/player/water/underwatersplash_.wav",SOUND_UNSCALABLE,200,5,200},
},
}

function BasicPlayer:OnEnterWater()
-- player has just entered the water, check its velocity
local vel =new(self:GetVelocity());
if ((vel.z < -1.2)) then
local pos=new(self:GetPos());
if self == _localplayer then
ExecuteMaterial(pos, g_Vectors.v001, BasicPlayer.fp_watersplash, 1);
else
ExecuteMaterial(pos, g_Vectors.v001, CommonEffects.water_splash, 1); end;
end
end
-- IMPROVED DIVING ENDS

-- ProcessPlayerEffects: process/handles all shader based character effects
function BasicPlayer.ProcessPlayerEffects(entity,upd)
	if (not entity) then
		return;
	end
	-- only set, when shader changes !
	local iEffectsElementsCount=getn(entity.pEffectStack);
	local iUpdate=upd;
	if (entity.iPlayerEffect>0) and (entity.pEffectStack[iEffectsElementsCount]~=entity.iPlayerEffect) then
		-- remove current effect
		if (entity.iPlayerEffect==1) then
			if (iEffectsElementsCount>1) then 
				tremove(entity.pEffectStack);
				entity.iPlayerEffect=entity.pEffectStack[iEffectsElementsCount-1];
			end
		else
			-- add new effect
			tinsert(entity.pEffectStack,entity.iPlayerEffect);
		end
		iUpdate=1;
		--BasicPlayer.SetPlayerEffect(entity);
	end
	-- cryvision is special case, overlap all other shader effects
	if (entity.bPlayerHeatMask==1 or entity.bPlayerHeatMask==3) then --!optimized!
		if (entity.bPlayerHeatMask==1) or (iUpdate) then
			--reset all
			if (entity==_localplayer) then 
				entity:SetShader("", 4); 
				entity:SetSecondShader( "",4);
				if (entity.items.aliensuit) then
					entity:SetMaterial("");
				end
			else --to be sure no ai is ever affecting my player shader
				entity:SetShader("", 0); 
				entity:SetSecondShader( "",0);
			end
			if (entity==_localplayer) and (entity.items.invis_active) then -- !optimized!
				entity:SetShader( "MutantPredator", 2);
			elseif (entity.items.aliensuit) and (not entity.cryVizStyle) then --pure proMode heat vision !optimized!
				if (entity==_localplayer) then 
					local layer = ClientStuff.vlayers:GetActivateLayer("HeatVision");
					if (layer) then
						layer.EnergyDecreaseRate = 2;
						layer.Amount = 0.35;
						layer.Red = 0.05;
						layer.Green = 0.5;
						layer.Blue = 0.35;
					end
					entity:SetShader( "TemplHologram", 2); 
					entity:SetSecondShader( "CharacterInvulnerability_Plasma", 2);
				else --special heat vision for pure proMode Bots/Ai
					entity:SetShader( "TemplHologram", 0); 
					entity:SetSecondShader( "CharacterInvulnerability_Plasma", 0);
				end
				entity.fLastBodyHeat=entity.fBodyHeat+0.1; --force an update
			elseif (entity.cryVizStyle) then --has received this from heatVision (gamestyler on) !optimized!
				if (entity==_localplayer) and (entity.items.aliensuit) then  --called from gamestyler
					--entity:SetMaterial(""); 
					HeatVision.iUpdate=iUpdate; --so dirty it's clean
				end
				GameStyler:GS_cryVizStyle(entity,2,entity.cryVizStyle,nil,entity.fBodyHeat,entity.items.aliensuit);
				entity.fLastBodyHeat=entity.fBodyHeat+0.1;
			elseif (entity==_localplayer) then --start standard heatvision !optimized!
				--entity:SetShader("", 4);
				entity:SetShader("TemplCryVisionPlayer", 2);
			else
				entity:SetShader("TemplCryVision_Mask", 0);
				entity:SetSecondShader("TemplCryVision", 0);
			end
			entity.bPlayerHeatMask=3;
		end
		if (entity.fLastBodyHeat>entity.fBodyHeat+0.005) or (entity.fLastBodyHeat<entity.fBodyHeat-0.005) then --simplified updates
			local syncArms = (entity.items.aliensuit and entity==_localplayer) or (iUpdate);
			BasicPlayer.UpdatePlayerEffectParams(entity, syncArms); --extended for arm shader handling
			entity.fLastBodyHeat=entity.fBodyHeat;
		end
	elseif (entity.bPlayerHeatMask==2) or (iUpdate) then 	
		entity.bPlayerHeatMask=0;
		-- restore old effects
		BasicPlayer.SetPlayerEffect(entity);
	end
	-- update player effect params
	if (entity.bUpdatePlayerEffectParams==1) then
		BasicPlayer.UpdatePlayerEffectParams(entity,iUpdate);
		entity.bUpdatePlayerEffectParams=0;
	end
end

-- SetPlayerEffect: set current character render effect
-- Notes: any new shader effect for characters, should be handled here to ensure
-- proper SetShader/SetSecondShader functionality, and shaders dependencies (eg: heat source, overcomes all other shaders)
-- available effects are:
-- 1. reset effect
-- 2. character color mask
-- 3. invulnerability
-- 4. heat source
-- 5. stealth
-- 6. mutated (note, should be used only with Jack model/localplayer)
-- 7 invisibility gear

-- Note: SetShader/SetSecondShader changed, now works like SetSecondShader(szShaderName, Mask)
-- where Mask= 0: character only, 1: character+attached, 2: character+arms, 3:character+arms+attached, 4: all

function BasicPlayer.SetPlayerEffect(entity)
	-- get current effect ID
	local iEffectID=entity.pEffectStack[getn(entity.pEffectStack)];
	
	--reset all
	if (entity==_localplayer) then 
		entity:SetShader("", 4); 
		entity:SetSecondShader( "",4);
	else --to be sure no ai is ever affecting my player shader
		entity:SetShader("", 0); 
		entity:SetSecondShader( "",0);
	end
	
	--DIRTIEST HACK STARTS HERE
	if (entity == _localplayer) then
		entity:SetMaterial("");
	elseif (_localplayer) and (_localplayer.items) and (_localplayer.items.invis_active) then
		BasicPlayer.SetPlayerEffect(_localplayer);
	end
	
	if (iEffectID==3) then  -- iEffectID invulnerable ?
		if (entity==_localplayer) then --fail safe for ugly arm shader handling (crytek)
			entity:SetSecondShader( "CharacterInvulnerability_Metal", 2);
		else
			entity:SetSecondShader( "CharacterInvulnerability_Metal", 0);
		end
		entity:RenderShadow(0,1);
	elseif (iEffectID==5) then-- is in stealth ?
		entity:SetShader( "MutantStealth", 4);
	elseif (iEffectID==2) then-- is colored ?
		if (entity.items) then
			entity.items.invis_active = nil;
			entity:RenderShadow(0,1);
		end
		if (strfind(entity.cnt.model,"coretech.cg")) then
			local ent_team=entity.cnt:GetColor();
			if (ent_team) and (ent_team.x) then
				if (ClientStuff) and (ClientStuff.GetInGameMenuName) and (ClientStuff:GetInGameMenuName() ~= 'InGameTeam') then
					ent_team = "players";
				elseif (ent_team.x == 1) then
					ent_team = "red";
				else
					ent_team = "blue";
				end
			end
			if (ent_team) then
				if (entity ~= _localplayer) then
					entity:SetMaterial("level.progamer_"..ent_team);
				elseif (entity.cnt) and (entity.cnt.weapon) then
					if (entity.cnt.weapon.wrong_material_assignment) then
						entity:SetMaterial("level.pro_hand_"..entity.cnt.weapon.name.."_"..ent_team);
						--entity:SetSecondShader("TemplProMode_hand_"..ent_team,2);
					else
						entity:SetMaterial("level.progamer_hand_"..ent_team);
						--entity:SetSecondShader("TemplProMode_hand_"..ent_team,2); --Shader only
					end
					entity:SetSecondShader("TemplProMode_"..ent_team,0);
				else
					entity:SetSecondShader("TemplProMode_"..ent_team,0);
				end
			end
			return;
		elseif (ClientStuff) and (ClientStuff.cl_survival) then
			if (Mission) and (Mission.OnSetPlayer) and (entity == _localplayer) then
				Mission:OnSetPlayer();
			end
			return;
		end
		entity:SetSecondShader( "PlayerMaskModulate", 0);
	elseif (iEffectID==6) then -- mutated arms effect
		entity:SetSecondShader( "TemplMutatedArms", 2);
	elseif (iEffectID==7) then -- invisibility mode
		if (entity==_localplayer) then --fail safe for ugly arm shader handling (crytek)
			entity:SetShader( "MutantPredator", 2);
		else
			entity:SetShader( "MutantPredator", 0);
		end
		entity:RenderShadow(0,0);
	elseif (not Game:IsMultiplayer()) and (entity==_localplayer) then
		if (entity.items.aliensuit) then
			-- Campaign: special case for putting the player into the alien suit :)
			if (entity.items.aliensuit ~= "players") and (entity.items.aliensuit ~= "red") and (entity.items.aliensuit ~= "blue") then
				entity.items.aliensuit = "players";
			end
			if (strfind(entity.cnt.model,"coretech.cg")==nil) then
				_localplayer.cnt.model = "Objects/characters/workers/coretech/coretech.cgf";
				_localplayer:LoadCharacter(_localplayer.cnt.model,0);
				local a_stamina = {
					sprintScale= 1.4,
					sprintSwimScale = 1.4,
					decoyRun= 0,
					decoyJump= 0,
					breathDecoyUnderwater= 2.0,
					breathDecoyAim= 3,
					breathRestore= 80,
				};
				local nMaterialID=Game:GetMaterialIDByName("mat_flesh");
				_localplayer:PhysicalizeCharacter(_localplayer.PhysParams.mass,nMaterialID,_localplayer.BulletImpactParams.stiffness_scale,0);
				if (_localplayer.SoundEvents) then
					for i,event in _localplayer.SoundEvents do
						_localplayer:SetAnimationKeyEvent(event[1],event[2],event[3]);
						if (event[4]~=nil) then
							Sound:SetSoundVolume(event[3],event[4]);
						end
					end
				end
				if (_localplayer.AnimationBlendingTimes) then
					for k,blends in _localplayer.AnimationBlendingTimes do
						_localplayer.cnt:SetBlendTime(blends[1],blends[2]);
					end
				end
				_localplayer.cnt:InitStaminaTable(a_stamina);
				Game:SetThirdPerson(0);
			end
			--------------------
			if (entity.cnt) and (entity.cnt.weapon) then
				if (entity.cnt.weapon.wrong_material_assignment) then
					entity:SetMaterial("level.pro_hand_"..entity.cnt.weapon.name.."_"..entity.items.aliensuit);
				else
					entity:SetMaterial("level.progamer_hand_"..entity.items.aliensuit);
				end
				entity:SetSecondShader("TemplProMode_"..entity.items.aliensuit,0);
			else
				entity:SetSecondShader("TemplProMode_"..entity.items.aliensuit,0);
			end
		elseif (entity==_localplayer) then
			-- garbitos / mixer: apply sp player color:
			local p_color=tonumber(getglobal("p_color"))+1;
			p_color = MultiplayerUtils.ModelColor[p_color];
			if (p_color) then
				entity:SetShaderFloat( "ColorR", p_color[1],0,0 );
				entity:SetShaderFloat( "ColorG", p_color[2],0,0 );
				entity:SetShaderFloat( "ColorB", p_color[3],0,0 );
				entity:SetSecondShader( "PlayerMaskModulate", 0);
			end
		end
	end
end

function BasicPlayer.UpdatePlayerEffectParams(entity,upd)
	-- get current effect ID
	local iEffectID=entity.pEffectStack[getn(entity.pEffectStack)];
	-- cryvision is special case (optimized, garbitos)
	if (entity.bPlayerHeatMask==1 or entity.bPlayerHeatMask==3) or (entity.cryVizStyle) then
		--gamestyler/cryVizStyler shader colors for player/arms
		if (entity.cryVizStyle) then
			local fHeat=entity.fBodyHeat;
			GameStyler:GS_cryVizStyle(entity,0,entity.cryVizStyle,nil,fHeat,entity.items.aliensuit);
			if (entity==_localplayer) and (entity.cnt) and (entity.cnt.weapon) then
				entity.cnt.weapon.fBodyHeat = fHeat; --sync this
				entity.cnt.weapon.cryVizStyle = entity.cryVizStyle;
				entity.cnt.weapon.playerColor = entity.playerColor;
				GameStyler:GS_cryVizStyle(entity.cnt.weapon,0,entity.cnt.weapon.cryVizStyle,nil,fHeat,entity.items.aliensuit);
				--Hud:AddMessage("Shaders Hands - UpdatePlayerEffectsParams");
			end
		else
			--shader colors for player/arms in promode
			if (entity.items.aliensuit) then 
				entity:SetShaderFloat( "PlasmaAmount", 1,0,0 );
				entity:SetShaderFloat( "PlasmaColorR", 0.1,0,0 );
				entity:SetShaderFloat( "PlasmaColorG", 1,0,0 );
				entity:SetShaderFloat( "PlasmaColorB", 0.5,0,0 );
				if (entity==_localplayer) and  (entity.cnt) and (entity.cnt.weapon) then
					entity.cnt.weapon:SetShaderFloat( "PlasmaAmount", 1,0,0 );
					entity.cnt.weapon:SetShaderFloat( "PlasmaColorR", 0.1,0,0 );
					entity.cnt.weapon:SetShaderFloat( "PlasmaColorG", 1,0,0 );
					entity.cnt.weapon:SetShaderFloat( "PlasmaColorB", 0.5,0,0 );
					--Hud:AddMessage("PRO MODE HANDS UPDATE !!!");
				end
			else
				-- default heat vision
				local fHeat=entity.fBodyHeat+1.25*0.5; --flatten out the effect
				if(fHeat>0.85) then fHeat=0.85; end --not so bright!
				entity:SetShaderFloat("BodyHeat", fHeat,0,0);
			end
		end		
		if (entity.fBodyHeat<=0.05) then entity.bPlayerHeatMask=0; end --extreme optimization (garbitos)
		return; --optimize more
	end
	if(iEffectID==3) then  -- iEffectID invulnerable ?
		--some colors so it does not overlap
		entity:SetShaderFloat("MetalAmount", 1,0,0);
		entity:SetShaderFloat("MetalColorR", 1,0,0);
		entity:SetShaderFloat("MetalColorG", 1,0,0);
		entity:SetShaderFloat("MetalColorB", 1,0,0);
	elseif(iEffectID==5) then-- is in stealth ?
		entity:SetShaderFloat("Refraction", entity.refractionValue,0,0);             
	elseif(iEffectID==2) then-- is colored ?
		local color=entity.cnt:GetColor();
		entity.playerColor={color.x,color.y,color.z}; --entity remember it's own color
		entity:SetShaderFloat( "ColorR", color.x,0,0);
		entity:SetShaderFloat( "ColorG", color.y,0,0);
		entity:SetShaderFloat( "ColorB", color.z,0,0);
	elseif(iEffectID==6) then-- mutated arms effect
		-- no params to update
	elseif(iEffectID==7) then -- invisibility effect
		entity:SetShaderFloat("Bump",0.01,0,0);
		entity:SetShaderFloat("PlasmaAmount",1,0,0);
		entity:SetShaderFloat("OpacityAmount",0.01,0,0);
	end
end

--
function BasicPlayer:Client_OnTimer()
BasicPlayer.ProcessPlayerEffects(self);
self:SetScriptUpdateRate(self.UpdateTime);

if (self.Client_OnTimerCustom) then
	self:Client_OnTimerCustom();
end

local hit = BasicPlayer.IsDrowning(self);
if (hit) then BasicPlayer.Client_OnDamage(self, hit); end

local stats = self.cnt;

if (self.ladder) then
	self.ladder:UpdatePlayerSound(self);
	self.cis_sitladdr = 1;
	if (not Game:IsServer()) and (not stats.weapon) and (self.cis_my_lastwpn) then
		stats:SetCurrWeapon(self.cis_my_lastwpn);
	end
elseif (self.cis_sitladdr) then
	-- Mixer: post-ladder weapon restoration
	self.cis_sitladdr = nil;
	--Hud:AddMessage("restore wpn after ladder");
	if (not Game:IsServer()) and (not stats.weapon) and (self.cis_my_lastwpn) then
		stats:SetCurrWeapon(self.cis_my_lastwpn);
	end
end

-- check for local client only

if (self==_localplayer) then
if (Hud) then
	if (not Game:IsServer()) then
		if (self.EnergyIncreaseRate) and (self.ChangeEnergy) then
			self:ChangeEnergy(self.EnergyIncreaseRate * self.UpdateTime/1000.0);
		end
	end

	-- spawn some bubbles when he drows
	if (stats.underwater>0) then
		local Pos=self:GetPos();
		Pos.z=Pos.z+1.5;
		BasicWeapon.UnderwaterBubbles.count=16+random(1,64);
		BasicWeapon.UnderwaterBubbles.fPosRandomOffset=1.5;
		Particle:CreateParticle(Pos, g_Vectors.v001, BasicWeapon.UnderwaterBubbles);
		BasicWeapon.UnderwaterBubbles.count=1;
		BasicWeapon.UnderwaterBubbles.fPosRandomOffset=0;
	end

	Hud.breathlevel=stats.breath;
	Hud.staminalevel=stats.stamina;
end -- hud

if (stats.proning) then
if (self.isProning==0) then
self.isProning=1;
stats:SetMinAngleLimitV( self.proneMinAngle );
stats:SetMaxAngleLimitV( self.proneMaxAngle );
end
else
if (self.isProning==1) then
	self.isProning=0;
	stats:SetMinAngleLimitV( self.normMinAngle );
	stats:SetMaxAngleLimitV( self.normMaxAngle );
end
end

-- set send an sneaking-mood-event if we're crouching or proning
if (self.cnt.crouching) or (self.cnt.proning) then
Sound:AddMusicMoodEvent("Sneaking", MM_SNEAKING_TIMEOUT);
end

if (self.Energy < 1) then
if (self.cVstate) and (self.cVstate==0) then GameStyler:GS_crazyState(self,1); return; elseif (self.cVstate) and (self.cVstate==1) then return; end --crazy
ClientStuff.vlayers:DeactivateActiveLayer("HeatVision");  
end

-- disable some stuff when the player goes swimming
if (self.cnt:IsSwimming()) then
if (self.cVstate) and (self.cVstate==0) then GameStyler:GS_crazyState(self,1); return; elseif (self.cVstate) and (self.cVstate==1) then return; end --crazy
ClientStuff.vlayers:DeactivateActiveLayer("HeatVision");  
ClientStuff.vlayers:DeactivateActiveLayer("WeaponScope");
ClientStuff.vlayers:DeactivateActiveLayer("Binoculars");
end

--when player have 4 weapons ,and is near a weapon to pickup , display the message.
if (self.pickup_ent) then
	local dist = EntitiesDistSq(self,self.pickup_ent);
	if (dist>self.pickup_dist+0.01) then
		self.pickup_ent = nil;
		self.pickup_OnContact = nil;
		self.pickup_dist = 0;
	elseif (self.pickup_OnContact) then
		self.pickup_OnContact(self.pickup_ent,self);
		Hud.labeltime = self.UpdateTime/1000.0;--keep the label message for a while.
	end
end

else
	-- ELSE IF. HERE IS PLACE FOR STUFF FOR EVERYONE EXCEPT PLAYER!
	if (self.stop_my_talk) then
		if (self.stop_my_talk < _time) then
			self.stop_my_talk = nil;
			self:StartAnimation(0,"NULL",4);
			if (self.listening_player) then
				self.listening_player = nil;
				-- perform answer to player's question sound
				Hud.npcdialogtimer = _time;
				Hud.npcdialogent = self.id * 1;
			end
		elseif (self.cnt.moving or self.cnt.running or self.cnt.firing) and (not self.listening_player) then
			self.stop_my_talk = 0;
		end
	end
end

-- FOR ALL PLAYERS FROM HERE
BasicPlayer.UpdateInWaterSplash(self);

if (self.cnt.vel > .001) then
	self:ApplyForceToEnvironment(1.0, self.cnt.vel*0.05);
end

if (stats.moving) then
	BasicPlayer.DoBushSound(self);
end

--until we dont have some dedicated functions for jumping use this to get if player has jumped
BasicPlayer.PlayerJumped(self);
BasicPlayer.PlayJumpSound(self);

if (self.theVehicle) then
BasicPlayer.DoSpecialVehicleAnimation(self);
end

end

--

function BasicPlayer:Client_OnTimerDead()

-- no blood from dead body
if ((g_gore == "0") or (g_gore == "1")) then return end

self:SetTimer(100);

local pos = self:GetBonePos("Bip01 Spine");
if( not pos ) then
pos = self:GetPos();
end
if (Game:IsPointInWater(pos)) then
	pos.z = pos.z - 0.06;
end
if (Game:IsPointInWater(pos)) then
Particle:SpawnEffect(pos, g_Vectors.up, "blood.on_water.a",0.6*self.fBodyHeat);

else

if(self.BloodTimer < 1000) then
self.BloodTimer = self.BloodTimer + 100;
if(self.BloodTimer >= 1000) then
pos.z = pos.z + .5;
self.cnt:GetProjectedBloodPos(pos,g_Vectors.down,"GoreDecalsBld", 4);
end
end
end
end


function BasicPlayer:PhysicalizeOnDemand()
  if(self.cnt.health ~= 0) then
    self:SetCharacterPhysicParams(0,"", PHYSICPARAM_SIMULATION,self.BulletImpactParams);  
  end
end

function BasicPlayer.SecondShader_Invulnerability(entity, amount, r, g, b) 
-- hack: since this is called when player spawned and player not in heatvisionmask list, set flag on
local bHeatLayerPresent=(ClientStuff and ClientStuff.vlayers);
if(bHeatLayerPresent and ClientStuff.vlayers:IsActive("HeatVision")) then  
	if (HeatVision.Style) then entity.cryVizStyle=HeatVision.Style end --gamestyler touch
	entity.bPlayerHeatMask=1;  
	entity.fBodyHeat=1;	
end

-- set invulnerability effect
entity.iPlayerEffect=3;
entity.bUpdatePlayerEffectParams=1;
BasicPlayer.ProcessPlayerEffects(entity);
end

function BasicPlayer.SecondShader_TeamColoring(entity)
-- hack: since this is called when player spawned and player not in heatvisionmask list, set flag on
local bHeatLayerPresent=(ClientStuff and ClientStuff.vlayers);
if(bHeatLayerPresent and ClientStuff.vlayers:IsActive("HeatVision")) then  
	if (HeatVision.Style) then entity.cryVizStyle=HeatVision.Style end --gamestyler touch
	entity.bPlayerHeatMask=1;  
	entity.fBodyHeat=1;
end

-- set team coloring effect
entity.iPlayerEffect=2;
entity.bUpdatePlayerEffectParams=1;
BasicPlayer.ProcessPlayerEffects(entity);
end

function BasicPlayer.SecondShader_Invisibility(entity)
-- hack: since this is called when player spawned and player not in heatvisionmask list, set flag on
local bHeatLayerPresent=(ClientStuff and ClientStuff.vlayers);
if (bHeatLayerPresent and ClientStuff.vlayers:IsActive("HeatVision")) then  
	if (HeatVision.Style) then entity.cryVizStyle=HeatVision.Style end --gamestyler touch
	entity.bPlayerHeatMask=1; 
	entity.fBodyHeat=1;	
end
-- set team coloring effect
entity.iPlayerEffect=7;
entity.bUpdatePlayerEffectParams=1;
BasicPlayer.ProcessPlayerEffects(entity);
end

function BasicPlayer.SecondShader_None(entity) 
-- hack: since this is called when player spawned and player not in heatvisionmask list, set flag on
local bHeatLayerPresent=(ClientStuff and ClientStuff.vlayers);
if(bHeatLayerPresent and ClientStuff.vlayers:IsActive("HeatVision")) then  
	if (HeatVision.Style) then entity.cryVizStyle=HeatVision.Style end --gamestyler touch
	entity.bPlayerHeatMask=1; 
	entity.fBodyHeat=1;	
end

-- reset shader
--entity.iPlayerEffect=1; --redundant
entity.bUpdatePlayerEffectParams=1;
BasicPlayer.ProcessPlayerEffects(entity);
end

----------------

BasicPlayer.Server_EventHandler={
[ScriptEvent_FireModeChange]=function(self, Params)
Params.shooter=self;
return BasicWeapon.Server.OnEvent(self.cnt.weapon, ScriptEvent_FireModeChange, Params);
end,

[ScriptEvent_AnimationKey]=function(self,Params)
if (type(Params) == "table") then
	if (self.ai) and (Params.number) then
		if (Params.number == KEYFRAME_APPLY_MELEE) then
			--System:LogAlways("MELEE DETECTED!!!!!!!!");
			--if (self.cnt.weapon) then
			--	BasicWeapon.Client.OnStopFiring(self.cnt.weapon,self);
			--end
			--if (self.cnt.melee_attack == nil) then
			--	self.cnt.melee_attack = 1;
			--	local target = AI:GetAttentionTargetOf(self.id);
			--	if (type(target) == "table") then
			--		self.cnt.melee_target = target;
			--		if ( (self.Properties.bSingleMeleeKillAI == 1)  and (target.ai~=nil)) then
			--			self.melee_damage = 10000;
			--		else
			--			self.melee_damage = self.Properties.fMeleeDamage;
			--		end
			--	else
			--		self.cnt.melee_target = nil;
			--		self.melee_damage = self.Properties.fMeleeDamage;
			--	end
			--	if (self.ImpulseParameters) then 
			--		self.ImpulseParameters.pos = self:GetPos();
			--		local power = self.ImpulseParameters.impulsive_pressure;
			--		self:ApplyImpulseToEnvironment(self.ImpulseParameters);
			--	end
			--end
		elseif (Params.number == KEYFRAME_JOB_ATTACH_MODEL_NOW) then 
if (self.Behaviour) then 
self.Behaviour:AttachNow(self);
end
elseif (Params.number == KEYFRAME_BREATH_SOUND) then 
if (Sound:IsPlaying(self.breath_sound)==nil) then 
self.breath_sound = BasicPlayer.PlayOneSound( self, self.breathSounds, 110 );
end
elseif (Params.number == KEYFRAME_ALLOW_AI_MOVE) then 
AI:EnablePuppetMovement(self.id,1);
elseif (Params.number == KEYFRAME_HOLD_GUN) then 
self.cnt:HoldGun();
elseif (Params.number == KEYFRAME_HOLSTER_GUN) then 
self.cnt:HolsterGun();
elseif (Params.number > KEYFRAME_HOLSTER_GUN) then
AI:FireOverride(self.id);
self.ROCKET_ORIGIN_KEYFRAME = Params.number;
end
end
end
end,

[ScriptEvent_Use]=function(self,Params)
local entities=self:GetEntitiesInContact();
local used;
if(entities)then
for id,ent in entities do
if(ent.OnUse)then
if (ent:OnUse(self)==1) then
used=1;
end
end
end
end
return used
end,

[ScriptEvent_CycleVehiclePos]=function(self,Params)
	if (self.theVehicle) then
		VC.CyclePosition(self.theVehicle, self);
	end
end,

[ScriptEvent_FireGrenade]=function(self,Params)

--NOTE self.cnt.grenadetype=1 is the ROCK so unlimited ammo
if(self.cnt.grenadetype==1 or (self.cnt.numofgrenades>0))then
return BasicPlayer.Server_OnFireGrenade(self, Params);
else
return
end
end,

[ScriptEvent_Land] = function(self,Params)
	BasicPlayer.HandleLanding(self,1);
	if (self.NoFallDamage) then
		return
	end

	local fallDmg = Params/100;

	if (fallDmg>self.FallDmgS) then
		if (self.cnt.fallscale) then
			fallDmg = (fallDmg - self.FallDmgS)*self.FallDmgK*self.cnt.fallscale;
		else
			fallDmg = (fallDmg - self.FallDmgS)*self.FallDmgK;
		end
		local hit = {
		dir = g_Vectors.v001,
		damage = fallDmg,
		target = self,
		shooter = self,
		landed = 1,
		impact_force_mul_final=5,
		impact_force_mul=5,
		damage_type = "healthonly",
		falling=1,
		};
		-- SET TO PROMODE DAMAGE (promode/alien world damage scaling)
		if (Mission and Mission.alienworld) or (self.items.aliensuit) then
			hit.damage = floor(hit.damage * (0.47 * self.cnt.max_health / 255));
		end
		self:Damage(hit);
		if (Game:IsMultiplayer()) then
			Server:BroadcastCommand("CHI "..hit.shooter.id.." "..hit.target.id.." "..hit.damage.." f");
		else
			BasicPlayer.Client_OnDamage(self,hit);
		end
	end
end,

[ScriptEvent_PhysCollision] = function(self,Params)
	local shooter = self;
	if ((not Params.collider) or (not Params.collider.Properties) or (not Params.collider.Properties.damage_players) or (Params.collider.Properties.damage_players==0)) then
		return
	end

	if (self.items.gr_item_id) and (self.items.gr_item_id == Params.collider.id) then
		return
	end

	local cldDmg = Params.damage*self.CollisionDmg*Params.collider.Properties.damage_players;

	if (Params.collider.IsVehicle == 1) then
		-- just left some vehicle - don't damage by vehicle 
		if (self.outOfVehicleTime and _time-self.outOfVehicleTime<2 ) then return end
		if ( Params.collider.driverT and Params.collider.driverT.entity) then
			-- if this is vehicle drawen by Val - don't damage local player from it
			if (self==_localplayer and Params.collider.driverT.entity.Properties.special == 1) then return end
			shooter = Params.collider.driverT.entity;
		end
		cldDmg = Params.damage*self.CollisionDmgCar;
	end

	if( Params.collider.Properties.damage_scale ) then
		cldDmg = cldDmg*Params.collider.Properties.damage_scale;
	end

	local hit = {
		dir = new(Params.dir),
		ipart = -1,
		damage = cldDmg,
		target = self,
		shooter = shooter,
		landed = 1,
		impact_force_mul_final=5,
		impact_force_mul=5,
		impact_force_mul_final_torso=0,
		target_material={type="arm"},
		damage_type="normal",
		weapon = Params.collider,
	};
	if (Params.collider.cis_lastgrabberid) then
		local grabbr = System:GetEntity(Params.collider.cis_lastgrabberid);
		if (grabbr) then
			hit.shooter = grabbr;
		end
	end

	hit.impact_force_mul_final = 0;
	if (Params.collider_mass >self.PhysParams.mass) then
	  if ((Params.collider) and (Params.collider.Properties) and (Params.collider.Properties.hit_upward_vel)) then
	    hit.dir.x=0; hit.dir.y=0; hit.dir.z=1;
	    hit.impact_force_mul_final_torso = Params.collider.Properties.hit_upward_vel*self.PhysParams.mass;
	  else
	   hit.impact_force_mul_final_torso = 0;--Params.collider_velocity*self.PhysParams.mass*1.3;
	  end  
	end
	self:Damage( hit );
	if (cldDmg > 0) and (Params.collider.CarHitBodySnd) and (Game:IsServer()) then
		Server:BroadcastCommand("PLAS "..Params.collider.id.." "..self.id.." v");
	end
end,

[ScriptEvent_CycleGrenade] = function(self,Params)
local curr=self.cnt.grenadetype;
local gtypecount=count(GrenadesClasses);
local n=0;
local next=curr;

repeat
next=next+1;
n=n+1;
if(next>gtypecount)then
next=1;
end
--next == 1 mean "rock" so always available
until(next==1 or (self.Ammo[GrenadesClasses[next]] and self.Ammo[GrenadesClasses[next]]>0 and not(GrenadesClasses[next] == "FlareGrenade" and not self.ai)) or n>=gtypecount)


self.Ammo[GrenadesClasses[curr]]=self.cnt.numofgrenades;
self.cnt.numofgrenades=self.Ammo[GrenadesClasses[next]];
self.cnt.grenadetype=next;
end,

[ScriptEvent_MeleeAttack]=function(self,Params)
--System:Log("MELEE SERVER");
--self.cnt.weapon_busy=1;
-- move the raycast in C++ and send just a event when an hit occur
--local t=Game:GetMeleeHit(Params);
--if(t)then
--	if (t.target) then
--		if (self.melee_damage) then
--			t.damage=self.melee_damage*1;
--		else
--			t.damage=100;
--		end
--		t.melee=1;
--		t.damage_type = "normal";
		--BasicPlayer.SetBleeding(t.target,0,t.damage);
		--t.target:Damage(t);
--	end
--local MeleeHit=t.target_material.melee_punch;
--if (self.MeleeHitType and t.target_material[self.MeleeHitType]) then
--MeleeHit=t.target_material[self.MeleeHitType];
--System:LogToConsole("player specific melee");
--else
--System:LogToConsole("standard melee");
--end
--ExecuteMaterial(t.pos,t.normal,MeleeHit,1);
--else
--System:Log("MISSED");
--end

end,

[ScriptEvent_PhysicalizeOnDemand]=BasicPlayer.PhysicalizeOnDemand,
[ScriptEvent_AllClear]=function(self,Params)
end,
[ScriptEvent_InVehicleAmmo] = function(self,Params)

--System:Log("\001 ScriptEvent_InVehicleAmmo   "..self:GetName());

if( not self.theVehicle ) then return end

--System:Log("\001 ScriptEvent_InVehicleAmmo  2 >> "..Params);
if( Params == 1 ) then
VC.VehicleAmmoEnter( self.theVehicle, self );
else
VC.VehicleAmmoLeave( self.theVehicle, self );
end
end
};

--

BasicPlayer.Server_EventHandlerDead={
[ScriptEvent_InVehicleAmmo] = function(self,Params)

--System:Log("\001 ScriptEvent_InVehicleAmmo   "..self:GetName());
if( not self.theVehicle ) then return end

--System:Log("\001 ScriptEvent_InVehicleAmmo  2 >> "..Params);
if( Params == 1 ) then
VC.VehicleAmmoEnter( self.theVehicle, self );
else
VC.VehicleAmmoLeave( self.theVehicle, self );
end
end
};


BasicPlayer.Client_EventHandler={
[ScriptEvent_FireModeChange]=function(self,Params)
local WeaponParams =
{
shooter = self;
};
-- Call the weapon so it has the chance to abort any active
-- processes going on for the old firemode
return BasicWeapon.Client.OnEvent(self.cnt.weapon, ScriptEvent_FireModeChange, WeaponParams);
end,
[ScriptEvent_FlashLightSwitch]=function(self,Params)
--System:Log( "--------------- fLight switched" );

if(self.fLightSound == nil) then return end

BasicPlayer.PlaySoundEx(self, self.fLightSound);

--if(self==_localplayer) then
if(self.FlashLightActive==0) then
self.FlashLightActive = 1;
else
self.FlashLightActive = 0;
end
--end

end,
[ScriptEvent_Command]=BasicPlayer.ProcessCommand,
[ScriptEvent_AnimationKey]=function(self,Params)
if( type(Params) == "table" ) then 
if( Params.userdata ) then
if( Params.userdata~=0 ) then
if (not self.cnt.first_person) then
	BasicPlayer.PlaySoundEx(self, Params.userdata);
end
end
else
BasicPlayer.DoStepSound( self );
end
else
BasicPlayer.DoStepSound( self );
end
end,
[ScriptEvent_SelectWeapon]=function(self,Params)
if((self==_localplayer) and ClientStuff.vlayers:IsActive("Binoculars"))then
ClientStuff.vlayers:DeactivateLayer("Binoculars",1);
end
if(not self.current_mounted_weapon) then
self:StartAnimation(0,"weaponswitch",1);
end

--if(self == _localplayer) then --redundant, handled in basicweapon.lua (optimization)
--BasicPlayer.ProcessPlayerEffects(self);
--end

end,
[ScriptEvent_FireGrenade]=function(self,Params)
local gclass=GrenadesClasses[self.cnt.grenadetype]
if(self.cnt.grenadetype==1 or self.cnt.numofgrenades>0) then
return BasicPlayer.Client_OnFireGrenade(self, Params);
end
end,
[ScriptEvent_MeleeAttack]=function(self,Params)
--System:Log("MELEE CLIENT");
--PLAY SOUND

if(self.melee_sounds~=nil) then
--System:Log("BasicPlayer.PlayOneSound( self, self.melee_sounds, 100 )");
BasicPlayer.PlayOneSound( self, self.melee_sounds, 100 );
end

if(self.cnt.first_person)then
if(self.cnt.weapon)then
self.cnt.weapon:StartAnimation( 0, "Melee" , 0.1, 0);
end
else
self:StartAnimation( 0, "amelee" , 0, 0);
end
end,
[ScriptEvent_PhysicalizeOnDemand]=BasicPlayer.PhysicalizeOnDemand,
[ScriptEvent_StanceChange]=function(self,Params)

BasicPlayer.PlayChangeStanceSound(self);

--if (self.StanceChangeSound) then
--Sound:PlaySound(self.StanceChangeSound);
--end
end,
[ScriptEvent_EnterWater]=BasicPlayer.OnEnterWater,
[ScriptEvent_Expression]=function(self,Params)

--System:Log("ScriptEvent_Expression "..Params);

if (self.EXPRESSIONS_ALLOWED) then 
self:DoRandomExpressions(self.expressionsTable[Params+1], 0);
--System:Log("ScriptEvent_Expression >>>> "..self.expressionsTable[Params+1]);
else
self:DoRandomExpressions("Scripts/Expressions/NoRandomExpressions.lua", 0);
--System:Log("ScriptEvent_Expression << not EXPRESSIONS_ALLOWED ");
end

end,
[ScriptEvent_InVehicleAnimation] = function(self,Params)
--System:Log("\001 animationg InVehicle "..Params);
if( not self.theVehicle ) then return end;-- no vehicle - should not get the event

if (self.UsingSpecialVehicleAnimation) then return end --we are playing some special vehicle anim? return.

local inVclTabl = VC.FindUserTable( self.theVehicle, self );
if( not inVclTabl ) then 
System:Warning("ScriptEvent_InVehicleAnimation cant find user in the vehicle "..self.GetName());
return 
end;

if(Params == self.prevInVehicleAnim) then return end

if(self.ai and _time-inVclTabl.entertime < self.vhclATime) then return end

if(inVclTabl.animations and inVclTabl.animations[Params] ) then
--System:Log("\001 animationg InVehicle playeing "..inVclTabl.animations[Params]);

if(Params == 2) then-- hit impact has to be blended in fast
self:StartAnimation(0,inVclTabl.animations[Params],2,.25);
else
self:StartAnimation(0,inVclTabl.animations[Params],2,.5);
end
self.prevInVehicleAnim = Params;
else
end
end,
[ScriptEvent_Land] = function(self,Params)
	BasicPlayer.HandleLanding(self);
	BasicPlayer.DoLandSound( self );
	BasicPlayer.PlayLandDamageSound(self);
end,
[ScriptEvent_Jump]= function(self,Params)
	BasicPlayer.OnPlayerJump(self,Params);
end,
};--

function BasicPlayer:PlayPainAnimation( hit )
	if (BasicPlayer.IsAlive(self)==nil) then return; end

	
	
	--self.painkiller = self.painkiller+1;
	
	
	
	if (hit.damage>0) then
		----
		if (not Sound:IsPlaying(self.painSound)) then
			if (self.rebreath_snd) and (Sound:IsPlaying(self.rebreath_snd)) then
				Sound:StopSound(self.rebreath_snd);
				self.rebreath_snd=nil;
			end

			-- MIXER: Fix stop rebreath sounds
			if (hit.bodun) then
				if (hit.damage > 15) and (self.CoughSnd) then
					self.painSound = BasicPlayer.PlayOneSound( self, self.CoughSnd,90 );
				elseif (hit.damage > 10) and (self.DrunkMidSnd) then
					self.painSound = BasicPlayer.PlayOneSound( self, self.DrunkMidSnd,100 );
				end
			elseif (self.cnt.underwater==0) then
				if (hit.bleeding) then
					if (self.BleedSounds) then
						self.painSound = BasicPlayer.PlayOneSound( self,self.BleedSounds,60 );
					end
					if (g_gore == "0") then
					else
						local hpos1 = self:GetBonePos("Bip01");
						--self.cnt:GetProjectedBloodPos(hpos1,hit.dir, "GoreDecals", 3);
						Particle:SpawnEffect(hpos1, g_Vectors.up, "bullet.hit_flesh_pancor.a",1.0);
					end
				elseif (hit.falling) and (self.LandHardSounds) then
					self.painSound = BasicPlayer.PlayOneSound( self,self.LandHardSounds,101 );
				else
					self.painSound = BasicPlayer.PlayOneSound( self, self.painSounds, 70 );
				end
			elseif (self == _localplayer) then
				local uw_painsnd = random(1,6);
				if uw_painsnd > 4 then
					if uw_painsnd == 5 then
					self.painSound = Sound:LoadSound("sounds/ai/pain/pain3.wav"); else
					self.painSound = Sound:LoadSound("sounds/ai/pain/pain4.wav"); end
					Sound:PlaySound(self.painSound);
				end
			end
		end
	---
	end

	--if(hit.explosion) then return end -- no pain ani for explosions
	if(hit.shooter == self) then return end -- no pain ani for falling/droving damage

	--AI and not a mutant, do pain expression.
	if (self.ai and self.MUTANT==nil) then 

		if (self.lastpainexpression==nil) then self.lastpainexpression = 0; end

		if (self.lastpainexpression<_time) then
			self:StartAnimation(0, "#full_angry_teeth", 0, 0.05, 1.0);
			self.lastpainexpression = _time + 0.1;
		end
	end

	--if(hit.melee) then return end -- no pain ani for melee
	--if(self.theVehicle) then return end -- no pain anim when driving --- ???
	--if(self.cnt.proning) then return end --no pain anim when prone

	local zone = self.cnt:GetBoneHitZone(hit.ipart);
	if (zone == 0) then zone = 1; end

	--if ((zone==5 or zone==6) and (self.cnt.crouching or self.cnt.proning or self.theVehicle)) then return; end

	local aniname = BasicPlayer.PainAnimations[zone];

	local animoffset = 1;

	if (zone==2) then--torso special case
		animoffset = random(1,3);
	end

	self:StartAnimation(0, aniname..animoffset, 4, 0.125, 1.25);
	if (self.ai) then
		local anim_dur = self:GetAnimationLength(aniname..animoffset);
		self:TriggerEvent(AIEVENT_ONBODYSENSOR,anim_dur+0.500);-- account for blending times aswell
	end
end

function BasicPlayer:SelectGrenade(name)
local cyclefunc = self.Server_EventHandler[ScriptEvent_CycleGrenade];
local currgrenade=GrenadesClasses[self.cnt.grenadetype];
local selected;
for i,val in GrenadesClasses do
cyclefunc(self);
if(GrenadesClasses[self.cnt.grenadetype]==name)then
selected=1;
break;
end
end
if(not selected)then
BasicPlayer.SelectGrenade(self,currgrenade);
end
end

-- ARMOR Helpers

function BasicPlayer:HasFullArmor()
local state = self.cnt;
if (state == nil) then
return nil;
end

if(state.armor >= state.max_armor) then
return 1;
else
return nil;
end
end

function BasicPlayer:AddArmor(amount)
local state = self.cnt;
if (state == nil) then
return nil;
end

state.armor = state.armor + amount;

local pickupAmount = amount;
local diff = state.max_armor - state.armor;

if(diff < 0) then
pickupAmount = amount - diff;
state.armor = state.max_armor;
end

return pickupAmount;
end

-- move all ammo in the clips to the ammo stash
function BasicPlayer:EmptyClips(weaponid)
local weaponstate = self.WeaponState;
local ammo = self.Ammo

if (weaponstate ~= nil and ammo ~= nil) then
local state = weaponstate[weaponid];
if (state ~= nil) then
local weapontbl = getglobal(state.Name);

for i, CurFireParameters in weapontbl.FireParams do
if (self.Ammo[CurFireParameters.AmmoType] ~= nil and state.AmmoInClip[i] ~= nil) then
self.Ammo[CurFireParameters.AmmoType] =  self.Ammo[CurFireParameters.AmmoType] + state.AmmoInClip[i];
state.AmmoInClip[i] = 0;
end
end
end
-- also do this for grenades
ammo[GrenadesClasses[self.cnt.grenadetype]]=self.cnt.numofgrenades;
end
end


function BasicPlayer:DoProjectedGore( hit )

if (g_gore == "0") then return
-- not to spawn too many decals
elseif( _time - self.decalTime < 0.5 ) then return end
self.decalTime = _time;
self.cnt:GetProjectedBloodPos(hit.pos,hit.dir, "GoreDecals", 5);

end

function BasicPlayer:Server_OnShutDown( hit )

--System:Log("BasicPlayer:Server_OnShutDown "..tostring(self.id).." "..tostring(self.idUnitHighlight));

-- release vehicle if currently using
if( self.theVehicle ) then
VC.ReleaseUserOnShutdown( self.theVehicle, self );
end
-- release mounted weapon if currently using
if(self.current_mounted_weapon) then
self.current_mounted_weapon:AbortUse();
end

if self.idUnitHighlight then
Server:RemoveEntity(self.idUnitHighlight);
end
end


function BasicPlayer:Client_OnShutDown( hit )

if( self.theVehicle ) then
VC.ReleaseUserOnShutdown( self.theVehicle, self );
end

if ((self.SwimSound~=nil) and (Sound:IsPlaying(self.SwimSound)==1)) then
Sound:StopSound(self.SwimSound);
self.SwimSound=nil;
end
end

--
-- check point and five points around to see if 
-- player can stand there (no obstacles/walls)
function BasicPlayer:CanStandPos( pos )

if( not self.cnt ) then return end

if( not self.cnt:CanStand( pos ) ) then
pos.z = pos.z+.5;
if( not self.cnt:CanStand( pos ) ) then
pos.x = pos.x+.5;
if( not self.cnt:CanStand( pos ) ) then
pos.x = pos.x-1;
if( not self.cnt:CanStand( pos ) ) then
pos.x = pos.x+.5;
pos.y = pos.y+.5;
if( not self.cnt:CanStand( pos ) ) then
pos.y = pos.y-1;
if( not self.cnt:CanStand( pos ) ) then
return nil;
end
end
end
end
end
end
return pos;
end

--filippo
function BasicPlayer:PlayChangeStanceSound()

--if (self.cnt.proning == self.lastProne) then return; end

if (self.lastStanceSound and self.lastStanceSound<_time) then

local lightexertion = self.LightExertion;

if (lightexertion) then
self:PlaySound(lightexertion[random(1, getn(lightexertion))],1);
end

self.lastStanceSound = _time + 0.7;
--self.lastProne = self.cnt.proning;
end
end

function BasicPlayer:PlayJumpSound()

if (self.hasJumped==1 and self.jumpSoundPlayed==0) then

local jumpsounds = self.JumpSounds;

if (jumpsounds) then

self:PlaySound(jumpsounds[random(1, getn(jumpsounds))],1);
end

self.jumpSoundPlayed = 1;
end
end

function BasicPlayer:HandleLanding(serverside)
	--if is server side play AI sound.
	if (serverside and self.hasJumped == 1) then

	local ppos = self:GetPos();
	AI:SoundEvent(self.id,ppos,BasicPlayer.soundRadius.jump,0,1,self.id);
	end

	self.hasJumped = 0;
	self.jumpSoundPlayed = 0;
end

function BasicPlayer:PlayerJumped()
	local pvel = self:GetVelocity();
	if (pvel.z>=1) and (self.cnt.flying~=nil) and (self.hasJumped==0) then
		self.hasJumped = 1;
		self.jumpTime = _time;
	end
	pvel = sqrt(pvel.x*pvel.x+pvel.y*pvel.y+pvel.z*pvel.z);

	if (self.move_params~=nil) then
		if pvel > (self.move_params.speed_run+(self.move_params.speed_run*self.StaminaTable.sprintScale-self.move_params.speed_run)*0.5) * self.cnt.speedscale and self.cnt.moving and self.cnt.aiming==nil and self.cnt.flying==nil then
			if (self.cnt.stamina > 0.043) then
				if (self.cnt.first_person) and (self.imrunsprinting==nil) and (self.cnt.firing==nil) and (self.playingReloadAnimation==nil) and (self.cnt.weapon) then
					if self.fireparams.animatedrun then
						self.cnt.weapon:ResetAnimation(0);
					elseif Hud and Hud.put_wpn_down == nil then
						Hud.put_wpn_down = 0;
					end
				end
				self.imrunsprinting = 1;
			end
		elseif (self.imrunsprinting) then
			self.imrunsprinting = nil;
			if (self.cnt.first_person) and (self.cnt.firing==nil) and (self.playingReloadAnimation==nil) and (self.cnt.weapon) then
				if self.fireparams.animatedrun then
					self.cnt.weapon:ResetAnimation(0);
				end
			end
		end
	end
end

function BasicPlayer:PlayLandDamageSound(onfalldamage)
	if (self.rebreath_snd) and (Sound:IsPlaying(self.rebreath_snd)) then
	else
		local lh_sounds = {
			{"Sounds/player/footsteps/rock/step2.wav",0,175,3,30},
		};
		self.rebreath_snd = BasicPlayer.PlayOneSound(self,lh_sounds,100);
	end
end

-- when in vehicle (boat) - see if collides with sometnig - release if yes
-- do it only for boats - in cars player is inside vehicle geometry
function BasicPlayer:UpdateCollisions()

if( not self.theVehicle ) then return end
if( not self.theVehicle.IsBoat ) then return end

local colliders = self:CheckCollisions(1);
local used;

if(count(colliders.contacts)>0)then
local vehicleTbl = VC.FindUserTable( self.theVehicle, self );
if( vehicleTbl ) then
VC.CanGetOut( self.theVehicle, vehicleTbl )-- need this to find exit point (side or top)
VC.ReleaseUser( self.theVehicle, vehicleTbl );
end
end
do return end
end

function BasicPlayer:AddPlayerHands(strict)
	local wsl = self.cnt:GetWeaponsSlots();
	if (wsl) then
		local wpns_count=0;
		for i,val in wsl do 
			if(val~=0) then 
				wpns_count=wpns_count+1;
				if (val.name=="Hands") or (val.name=="EngineerTool") then
					wpns_count=4;
					break;
				end
			end
		end
		if wpns_count < 4 then
			if (self.items) and (self.items.wrenchtool) and (not strict) then
				self.cnt:MakeWeaponAvailable(27,0);
				--self.cnt:MakeWeaponAvailable(27);
				BasicPlayer.ScriptInitWeapon(self, "EngineerTool",1,1);
			else
				--self.cnt:MakeWeaponAvailable(9);
				BasicPlayer.ScriptInitWeapon(self, "Hands",1,1);
			end
		end
	end
end

function BasicPlayer:PlayInteractSound(sndpath)
	if (Sound.cisinteractsnd) and (Sound:IsPlaying(Sound.cisinteractsnd)) then
		Sound:StopSound(Sound.cisinteractsnd);
	end
	Sound.cisinteractsnd = Sound:LoadSound(sndpath);
	if (Sound.cisinteractsnd) then
		Sound:PlaySound(Sound.cisinteractsnd);
	end
end

function BasicPlayer:PlayerContact(contact,serverside)

if (self == _localplayer) then
	if (contact.Properties) then
		if (contact.Properties.Physics) and (contact.Properties.Physics.Mass) then
			if (contact.Properties.Physics.Mass <= 80) then
				local obj=_localplayer.cnt:GetViewIntersection();
				if (obj) and (obj.id) and (contact.id == obj.id) then
					if (not self.items.gr_item_id) then
						self.grb_candidate = obj.id * 1;
						if (Hud) then
							Hud.npcdialogtimer = _time;
						end
					end
				end
			end
			if (contact.PhysPickTouched) then
				-- Mixer: huge part of code is moved to PickupPhysCommon.lua
				contact:PhysPickTouched(self);
			end
		elseif (contact.ai) and (contact.items.ai_helmet) and (not _localplayer.items.kevlarhelmet) then
			if (contact.Properties.species ~= self.Properties.species) or (contact.cnt.health <= 0) then
				if (Hud) then
					Hud.label = "use_hint";
				end
			end
		end
	end
end

if (GameRules) and (GameRules.soccerball) and (GameRules.soccerball == contact) then
	if (GameRules.last_toucher_id) and (GameRules.last_toucher_id ~= self.id) then
		contact:EnablePhysics(0);
		contact:EnablePhysics(1);
	elseif (not GameRules.last_toucher_id) then
		contact:EnablePhysics(0);
		contact:EnablePhysics(1);
	end
	GameRules.last_toucher_id = self.id * 1;
end

--player is pressing use key?
if (not self.cnt.use_pressed) and (serverside~=3) then return end

--AI dont push
if (self.ai) then return end

--dont push client-side if is not MP
if (serverside==0) then
	if (not Game:IsMultiplayer() or self==_localplayer) then
		return
	end
end

--Mixer: place your usable entities func here!
if (contact.Properties) then
	if (contact.Properties.fAnchorRadius) then
		if (contact.Properties.Animation) and (contact.Properties.Animation.Animation) then
			if (contact.Properties.Animation.Animation == "give_armor") then
				------
				local check_givenarmor = self.cnt.armor * 1;
				if (self.cnt.max_armor < self.cnt.armor+contact.Properties.fAnchorRadius) then
					self.cnt.armor = self.cnt.max_armor * 1;
				else
					self.cnt.armor = self.cnt.armor+contact.Properties.fAnchorRadius;
				end
				------
				if (check_givenarmor ~= self.cnt.armor) or (not self.items.kevlarhelmet) or (contact.Properties.fAnchorRadius == 0) then
					Server:BroadcastCommand("PLAS "..contact.id.." "..self.id);
					if (self.items) and (contact.Properties.fAnchorRadius > 0) then
						self.items.kevlarhelmet = 1;
					end
					BroadcastEvent(contact, "Remove");
					contact:SetPos({x=0.01,y=0.01,z=0.01});
				end
			elseif (contact.Properties.Animation.Animation == "give_health") then
				if (self.cnt.health > 0) then
					local check_givenhealth = self.cnt.health * 1;
					if (self.cnt.max_health < self.cnt.health+contact.Properties.fAnchorRadius) then
						self.cnt.health = self.cnt.max_health * 1;
					else
						self.cnt.health = self.cnt.health+contact.Properties.fAnchorRadius;
					end
					if (check_givenhealth ~= self.cnt.health) then
						Server:BroadcastCommand("PLAS "..contact.id.." "..self.id);
						BroadcastEvent(contact, "Remove");
						contact:SetPos({x=0.01,y=0.01,z=0.01});
					end
				end
			end -- give_ options
		end -- anim based
	elseif (contact.ai) then -- fanchor based
		if (contact.Properties.species ~= self.Properties.species) or (contact.cnt.health <= 0) then
			if (self.items) and (not self.items.kevlarhelmet) then
				if (contact.hasHelmet) and (contact.hasHelmet == 1) and (contact.items.ai_helmet) then
					contact.hasHelmet = 0;
					contact.MaxEnergy = 0;
					contact.items.ai_helmet = nil;
					contact:DetachObjectToBone("hat_bone");
					if (self.items) then
						self.items.kevlarhelmet = 1;
					end
					if (Hud) then Hud.bBlinkArmor=1; end
					if (self.cnt.armor < (self.cnt.max_armor - 10)) then
						self.cnt.armor = self.cnt.armor + 10;
					end
					BasicPlayer.PlayInteractSound(self,"Sounds/player/prone_up.wav");
					if (ClientStuff) and (ClientStuff.PlayPickupAnim) then
						ClientStuff:PlayPickupAnim(self);
					end
					contact:AddImpulseObj({x=0,y=0,z=1},45);
				end
			end
		end --- species
	end -- .ai contact
end -- has properties

--push rate cap
if (serverside==1) then
if (self.nextPush and self.nextPush > _time) then return end
else
if (self.nextPush_Client and self.nextPush_Client > _time) then return end
end

local pushpower = 90;

--if canbepushed exist it can return 3 possible values: nil (cant be pushed), -1 (can be pushed with the player push power), n > 0 (a custom push power, boats use this)
if (contact.CanBePushed) then
local power = contact:CanBePushed();

if (power==nil) then return end

if (power>0) then pushpower = power; end
else
--there is no CanBepushed func, so return; if we want player push everything just comment the "return" or create some CanBepushed function to the entities that can be pushed.
return
end

local ppos = self.tempvec;

merge(ppos,self:GetPos());

ppos.z = ppos.z + 1;

if (not PointInsideBBox(ppos,contact,1.0)) then return end

local impdir = self:GetDirectionVector();
local bias = 0.3;

--if player is looking down use a less push power
if (impdir.z < -bias) then
pushpower = pushpower * (1.0+bias+impdir.z);
end

--in any case push the entity a bit up
if (impdir.z<0.5) then impdir.z = 0.5; end

--FIXME: use a better impulse start position, now its the center of the entity
--contact:AddImpulse( -1,ppos, impdir, pushpower );
contact:AddImpulseObj( impdir, pushpower );

--add a 0.3 sec delay between a push and the next
if (serverside==1) then
self.nextPush = _time + 0.3;
else
self.nextPush_Client = _time + 0.3;
end
end

function BasicPlayer:OnPlayerJump(Params)
	if (self.ai) then 
		BasicAI.DoJump(self,Params);
	end
end

--this function play the "go back" vehicle animation if the player is looking in the opposite direction of the vehicle.
function BasicPlayer:DoSpecialVehicleAnimation()

--ai dont have to deal with this stuff.
if (self.ai) then return end

local dir = self.tempvec;
CopyVector(dir,self:GetDirectionVector(0));
local vdir = self.theVehicle:GetDirectionVector(0);

local dot = dotproduct3d(dir,vdir);

--player is looking back
if (dot > 0.3) then

--6 is the index pos for the "go back" animation in the vehicle table.
local animidx = 6;

if (self.prevInVehicleAnim ~= animidx) then

local inVclTabl = VC.FindUserTable( self.theVehicle, self );

if (inVclTabl==nil) then return end
if (inVclTabl.animations==nil) then return end

local anim = inVclTabl.animations[animidx];

if (anim) then
self:StartAnimation(0,anim,2,0.5);
end

self.prevInVehicleAnim = animidx;
end

self.UsingSpecialVehicleAnimation = 1;
else
self.UsingSpecialVehicleAnimation = nil;
end
end


---

function BasicPlayer:OnSaveOverall(stm)

if(self.current_mounted_weapon) then
stm:WriteInt( self.current_mounted_weapon.id );
else
stm:WriteInt( 0 );
end

if(self.theRope) then
stm:WriteInt( self.theRope.id );
else
stm:WriteInt( 0 );
end
end

---

function BasicPlayer:OnLoadOverall(stm)

local mntWeaponId = stm:ReadInt(  );
self.current_mounted_weapon = System:GetEntity( mntWeaponId );
if(self.current_mounted_weapon and self.current_mounted_weapon.SetGunner) then
self.current_mounted_weapon:SetGunner( self );
end

local theRope = stm:ReadInt(  );

self.theRope = System:GetEntity( theRope );
if(self.theRope) then
self.theRope.state = 0;
self.theRope:GoDown( );
self.theRope:DropTheEntity( self, 1 );
end
end
---

