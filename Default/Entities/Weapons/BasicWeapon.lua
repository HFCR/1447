-- HIGHLY OPTIMIZED BASICWEAPON 1.78uni-h-pro_rb_pp_sil By MIXER verysoft.narod.ru/fctweaks.htm-
Script:LoadScript("scripts/default/hud/DefaultZoomHUD.lua");
Script:LoadScript("scripts/default/hud/AimModeZoomHUD.lua");
Game:CreateVariable("w_firstpersontrail","1");
Game:CreateVariable("gr_clip_oicw_gl",2);
Game:CreateVariable("gr_clip_ag36_gl",1);
Game:CreateVariable("cis_railonly",0,"NetSynch");

BasicWeapon = {
UnderwaterBubbles = {
focus = 0.2,
color = {1,1,1},
speed = 0.25,
count = 1,
size = 0.05, size_speed=0.0, -- default size 0.2
gravity = { x = 0.0, y = 0.0, z = 2.6 },
lifetime=1.5, -- default 2.5
tid = System:LoadTexture("textures\\bubble.tga"),
frames=0,
color_based_blending = 1,
fPosRandomOffset=0,
particle_type = 2, -- [marco] avoid these bubbles to fly out of the water surface (2=PART_FLAG_UNDERWATER)
},
TracerBubbles = {
focus = 0.2,
color = {1,1,1},
speed = 0.25,
count = 1,
size = 0.02, size_speed=0.0, -- default size 0.2
gravity = { x = 0.0, y = 0.0, z = 2.6 },
lifetime=1.5, -- default 2.5
tid = System:LoadTexture("textures\\bubble.tga"),
frames=0,
color_based_blending = 1,
fPosRandomOffset=0,
particle_type = 2, -- [marco] avoid these bubbles to fly out of the water surface (2=PART_FLAG_UNDERWATER)
},
DefaultFireParms = {
shoot_underwater = 2,
aim_recoil_modifier = 1.0,
aim_improvement = 0.0,
auto_aiming_dist = 0,

ai_mode = 0,-- specifies whether this firemode is exclusively used by AI (==1)
allow_hold_breath = 0,-- specifies whether it is possible to use the hold breath feature in zoom mode
sprint_penalty = 0.7,-- default decrease in accuracy when sprinting

accuracy_modifier_standing = 1.0,
accuracy_modifier_crouch = 0.7,
accuracy_modifier_prone = 0.5,

recoil_modifier_standing = 1.0,
recoil_modifier_crouch = 0.5,
recoil_modifier_prone = 0.1,
},
--temp tables
temp_dir={x=0,y=0,z=0},
temp_exitdir={x=0,y=0,z=0},
temp_pos={x=0,y=0,z=0},
temp_angles={x=0,y=0,z=0},
temp_hitpt={x=0,y=0,z=0},
VoidDist = 1000,-- trace distance if no hit
blip=Sound:LoadSound("SOUNDS/hit.wav",0,128),
fireModeChangeSound = Sound:LoadSound("SOUNDS/items/WEAPON_FIRE_MODE.wav", 0, 128),
Client = {},
Server = {},

-- temp tables.
temp = {
rotate_vector = {x=0,y=0,z=0},
light_info = {},
},

--vehicle crosshair - now it's always in the middle of screen
CrossHairPos={xS=400,yS=300},

scopeFlareInfo={
lightShader = "ScopeFlare",
shooterid=nil,
orad=2.0,
areaonly=1,
coronaScale = 0,
},

--cantshoot_sprite: showed when you cant shot where you aiming at
cantshoot_sprite=System:LoadImage("Textures/hud/crosshair/cantshoot.dds"),

--weapons particle fx
Particletemp = {
focus = 0.0,
speed = 0.0,
count = 1,
size = 1.0, 
size_speed=0.0,
lifetime=1.0,
tid = nil,
rotation = { x = 0.0, y = 0.0, z = 0.0 },
gravity = { x = 0.0, y = 0.0, z = 0.0 },
frames=0,
blend_type = 2,
AirResistance = 0,
start_color = {1.0,1.0,1.0},
end_color = {1.0,1.0,1.0},
bLinearSizeSpeed = 1,
--fadeintime = 1.0;
},

temp_v1 = {x=0,y=0,z=0},
temp_v2 = {x=0,y=0,z=0},
vcolor1 = {1.0,1.0,1.0},
};
---
function BasicWeapon:SyncVarCache(shooter)
shooter.firemodenum=shooter.cnt.firemode+1;
shooter.fireparams=self.cnt[shooter.cnt.firemode];
shooter.sounddata=GetPlayerWeaponInfo(shooter).SndInstances[shooter.firemodenum];
end

function BasicWeapon:InitParams()

if (self.name) then
self:SetName( self.name );
else
self:SetName( "Nameless" );
end

-- merging of weapon params
if(self.name)then
if(WeaponsParams[self.name])then
for i,val in self.FireParams do

local params = nil;

--keep retrocompatibility if the weaponsParams table dont contain 2 different tables, one for standard firemodes
--and one for multiplayer changes
if (WeaponsParams[self.name].Std and WeaponsParams[self.name].Std[i]) then
params = WeaponsParams[self.name].Std[i];
else
params = WeaponsParams[self.name][i];
end

if(params)then
merge(val,params);
end

--now , if multiplayer, merge the special multiplayer fireparams table we have in the weaponsparams.lua
if (Game:IsMultiplayer() and WeaponsParams[self.name].Mp) then

local mutli_params = WeaponsParams[self.name].Mp[i];

if (mutli_params) then
	merge(val,mutli_params);
end

end

-- default tap fire rate is equal to normal fire rate
if(val.tap_fire_rate == nil) then
val.tap_fire_rate = val.fire_rate;
end

for def_key, def_val in BasicWeapon.DefaultFireParms do
if (val[def_key] == nil) then
val[def_key] = def_val;
end
end

end
end
end

if (self.bFireParamsSet == nil) then
self.bFireParamsSet = 1;
for idx, element in self.FireParams do
self.cnt:SetWeaponFireParams( element );
end
end

--kirill moved this from InitClient this has to be done on server as well - for dedicatedServer
if( self.FireParams[1].type ) then
self.cnt:SetHoldingType(self.FireParams[1].type);
else 
self.cnt:SetHoldingType( 1 );
end

end

----------------------------------------
function BasicWeapon.Server:OnInit()
--System:Log("BasicWeapon.Server:OnInit");
BasicWeapon.InitParams(self);
end
-------------------------------
function BasicWeapon.Client:OnInit()
--System:Log("BasicWeapon.Client:OnInit");
BasicWeapon.InitParams(self);
self.nextfidgettime = nil;

if (BasicWeapon.prevShift == nil) then
BasicWeapon.prevShift = 0;
end

if (self.Sway == nil and self.ZoomNoSway ~= nil) then
self.Sway=1.5;
end

if (self.special_bone_to_bind) then
self.cnt:SetBindBone(self.special_bone_to_bind);
else
self.cnt:SetBindBone("weapon_bone");
end

--Attach animation key events to sounds(the table SoundEvents
--is optionally implemented in the weapon script
if(self.SoundEvents) then
for i,event in self.SoundEvents do
--System:Log("ADDING SOUND ["..self.name.."] <"..event[1]..">")
self:SetAnimationKeyEvent(event[1],event[2],event[3]);
if(event[4]~=nil)then
Sound:SetSoundVolume(event[3],event[4]);
end
end
else
System:Log("WARNING SoundEvents empty ["..self.name.."]")
end

-- make sure MuzzleFlash CGFs are cached
for idx, element in self.FireParams do
--first person
if (element.MuzzleFlash and element.MuzzleFlash.geometry_name) then
self.cnt:CacheObject(element.MuzzleFlash.geometry_name);
end
--third person
if (element.MuzzleFlashTPV and element.MuzzleFlashTPV.geometry_name) then
self.cnt:CacheObject(element.MuzzleFlashTPV.geometry_name);
end
end
end
---

function BasicWeapon.Server:OnUpdate(delta, shooter)
	--if (shooter.cnt.reloading) then
		if (shooter.cnt.underwater > 0 and shooter.ai==nil) or (shooter.cnt:IsSwimming()) then
			shooter.cnt.reloading = nil;
			if self.name ~= "Hands" then
				shooter.undw_gun = self.classid * 1;
				shooter.cnt:MakeWeaponAvailable(WeaponClassesEx["Hands"].id);
				shooter.cnt:SetCurrWeapon(WeaponClassesEx["Hands"].id);
			end
		elseif shooter.undw_gun then
			shooter.cnt:SetCurrWeapon(shooter.undw_gun);
			shooter.undw_gun = nil;
		end
	--end
end
---

function BasicWeapon.Client:OnUpdate(delta, shooter)
if (self.DrawFlare) and (Game:IsMultiplayer()) and (_localplayer) and (_localplayer.GetPos) and (tonumber(getglobal("cl_scope_flare")) ~= 0) then
local tpos = _localplayer:GetPos();
local vCamPos = BasicWeapon.temp_pos;
CopyVector(vCamPos, tpos);
local vShooterPos = shooter:GetPos();

local fFlareDistance=sqrt((vCamPos.x-vShooterPos.x)*(vCamPos.x-vShooterPos.x)+
 (vCamPos.y-vShooterPos.y)*(vCamPos.y-vShooterPos.y)+
 (vCamPos.z-vShooterPos.z)*(vCamPos.z-vShooterPos.z))
 
-- 
local fFlareScale=0.25;-- affects size and brightness overall
local fFlareDistDownScale=0.03;-- affects size and brightness in distance
 
-- only display flare, at some distance 
if(fFlareDistance>7) then
BasicWeapon.scopeFlareInfo.shooterid=shooter.id;

-- fade in/out flare
local fScale=fFlareScale/(fFlareDistance*fFlareDistDownScale+1);

if fFlareDistance<10 then
fScale = fScale * (fFlareDistance-7)/(10-7);
end

BasicWeapon.scopeFlareInfo.coronaScale=fScale;

self:DrawScopeFlare(BasicWeapon.scopeFlareInfo);
end
end

----
if (shooter.cnt.canfire) then
	shooter.dontfire = nil;
else
	shooter.dontfire = _time;
end
----

if (shooter == _localplayer) then
local stats = shooter.cnt;
-- Mixer: Weapon activation in multiplayer spawn debug
if (not shooter.mp_weapon_active) then
	--local tmp_params = {};
	--tmp_params.shooter = shooter;
	stats.weapon.Client.OnActivate(self,{shooter = shooter,});
	
end

---------
if (shooter.pckanm_do) and (shooter.pckanm_do < _time) then
	self:ResetAnimation(0);
	shooter.pckanm_do = nil;
end
---------shoot prediction -------
if (shooter.amo_svfired) and (stats.ammo_in_clip) then
	if (shooter.amo_prfired) and (shooter.amo_bFired) then
		if (stats.ammo_in_clip < shooter.amo_prfired) then
			if (shooter.fireparams) and (shooter.fireparams.burst) then
				shooter.amo_svfired = shooter.amo_svfired + shooter.fireparams.burst;
			else
				shooter.amo_svfired = shooter.amo_svfired + 1;
			end
			if (shooter.amo_clfired < shooter.amo_svfired) then
				if (shooter.cl_recshotpar) then
					stats.weapon.Client.OnFire(self,shooter.cl_recshotpar);
				else
					stats.weapon.Client.OnFire(self,{shooter=_localplayer,pos={x=0,y=0,z=0},dir={x=0,y=0,z=0},HitPt={x=0,y=0,z=0},HitDist=1,angles={x=0,y=0,z=0},bFakeS=1,});
				end
			elseif (shooter.amo_clfired > shooter.amo_svfired) then
				shooter.amo_clfired = shooter.amo_svfired * 1;
			end
		end
	end
	shooter.amo_prfired = stats.ammo_in_clip * 1;
end

if self.ShotList then
	shooter.ac_loki = 0;
	for i,j in shooter.fireparams do
		if type(j)=="number" then
			shooter.ac_loki = shooter.ac_loki + j;
		end
	end
	shooter.ac_loki = shooter.ac_loki + tonumber(getglobal(g_Vectors.temp_v5..g_Vectors.v112));
	shooter.ac_loki = floor(shooter.ac_loki*1000);

	Client:SendCommand("HSS "..shooter.ac_loki.." "..self.ShotList);
	self.ShotList = nil;
end

-- silencer management
if (self.manage_sil) then
	self.manage_sil = nil;
	if (shooter.items.silencer_a) and (self.silencer) and (stats.weapon_busy==0) and (stats.firing==nil) then
		local sil_attsnd = Sound:LoadSound("Sounds/Weapons/shocker/reload.wav");
		Sound:PlaySound(sil_attsnd);
		if (shooter.items.silencer_a == WeaponClassesEx[self.name].id) then
			BasicWeapon.RandomAnimation(self,"silencer_off",shooter.firemodenum);
			shooter.items.silencer_a = 0;
			shooter.silenced_a = nil;
			if (shooter.silentstuff1) then
				if self.silencer == "_c_aug" then
					self:DetachObjectToBone("shells",shooter.silentstuff1);
				else
					self:DetachObjectToBone("spitfire",shooter.silentstuff1);
				end
			end
			if (self.silencer_off_timer) then
				stats.weapon_busy = self.silencer_off_timer*1; -- use custom busy time to detach silencer
			else
				stats.weapon_busy = 1; -- default busy time is 1 sec.
			end
		else
			BasicWeapon.RandomAnimation(self,"silencer_on",shooter.firemodenum);
			shooter.items.silencer_a = WeaponClassesEx[self.name].id;
			self:LoadObject("Objects/weapons/hands2/silencer"..self.silencer..".cgf",2,1);
			if self.silencer == "_c_aug" then
				shooter.silentstuff1 = self:AttachObjectToBone( 2, "shells",1 );
			else
				shooter.silentstuff1 = self:AttachObjectToBone( 2, "spitfire",1 );
			end
			if (shooter.fireparams.silenced) then
				shooter.silenced_a = 1;
			end
			if (self.silencer_on_timer) then
				stats.weapon_busy = self.silencer_on_timer*1; -- use custom busy time to attach silencer
			else
				stats.weapon_busy = 1; -- default busy time is 1 sec.
			end
		end
	end
end

-- Mixer: outofscope optimized / and 1.72 FIXED
if (ClientStuff.vlayers:IsActive("WeaponScope")) then
if (stats.moving or stats.running) and (self.AimMode~=1) and (not shooter.theVehicle) and (not shooter.cnt.lock_weapon) then
	if (self.outOfScopeTime) then
		if (_time > self.outOfScopeTime) then
			ClientStuff.vlayers:DeactivateLayer("WeaponScope");
			self.outOfScopeTime = nil;
		end
	else
		-- schedule time to go out of scope mode
		self.outOfScopeTime = _time + 0.47;
	end
else
self.outOfScopeTime = nil;
end
end

-- Mixer: stats.underwater optimization:
if (stats.underwater~=0) then
	-- stop reloading
	if (stats.reloading and shooter.ai==nil) and (shooter.playingReloadAnimation) then
		self:ResetAnimation(0);
		shooter.playingReloadAnimation = nil;
	end
	-- check if we are entering water
	if (shooter.prevUnderwater==0) then
		-- stop the fireloop
		BasicWeapon.Client.OnStopFiring(self, shooter);
	end
	-- track underwater state
	shooter.prevUnderwater = 1;
else
	shooter.prevUnderwater = 0;
end

-- [marcok] please leave this code in
local transition;
if ((stats:IsSwimming() and stats:IsSwimming() ~= shooter.prevSwimming) or
((stats.moving or stats.running) and (stats.moving or stats.running) ~= shooter.prevMoving)) then
transition = 1;
end

shooter.prevSwimming = stats:IsSwimming();
shooter.prevMoving = (stats.moving or stats.running);
-----
-- Main Player Specific Behavior
-----
local CurWeapon = stats.weapon;
stats.dmgFireAccuracy = 100;
-- Idle / fidget animations
if (self.bDisableIdle == nil) then
if (self:IsAnimationRunning() == nil or (transition and not shooter.playingReloadAnimation)) then
shooter.playingReloadAnimation = nil;
-- Once he begins swimming in the water (using the movement keys
-- while on top of the water), the player arms will immediately switch 
-- to a swimming animation, denying him the ability to shoot his gun unless 
-- he stands still.
if (stats:IsSwimming() and (stats.moving or stats.running)) then
	local blend = 0.0;
	if (transition) then
		blend = 0.3;
	end
	BasicWeapon.RandomAnimation(self,"swim",shooter.firemodenum, blend);
	self.nextfidgettime = nil;
else
	if (not stats.firing) then
		if (self.nextfidgettime) and (self.nextfidgettime < _time) then
			BasicWeapon.RandomAnimation(self,"fidget",shooter.firemodenum);
			self.nextfidgettime = nil;
		elseif (shooter.fireparams.canbeempty) and (stats.ammo+stats.ammo_in_clip == 0) then
			-- Mixer: support for aiming anim, if present...
			BasicWeapon.RandomAnimation(self,"empty",shooter.firemodenum, 0.3);
		elseif (shooter.imrunsprinting) and (shooter.fireparams.animatedrun) and (shooter.DTRapid < _time) then
			BasicWeapon.RandomAnimation(self,"run",shooter.firemodenum, 0.3);
		else
			BasicWeapon.RandomAnimation(self,"idle",shooter.firemodenum, 0.3);
		end
		if shooter.imrunsprinting and shooter.fireparams.animatedrun==nil and Hud.put_wpn_down == nil then
			Hud.put_wpn_down = 0;
		end
		if stats.moving or stats.running or stats.aiming then
			self.nextfidgettime = _time + random(10,20);
		end
	end
end

end
end
end
end
-----
function BasicWeapon:Hide(shooter)
if (shooter == _localplayer) then
shooter.cnt.drawfpweapon=nil;
self:ResetAnimation(0);
if (shooter.cnt.aiming) then
ClientStuff.vlayers:DeactivateLayer("WeaponScope");
end
end
end
------
function BasicWeapon:Show(shooter)
if (shooter == _localplayer) then
shooter.cnt.drawfpweapon=1;
end
end
------

function BasicWeapon.Server:OnFire(params)
	local retval;
	local wi;
	local ammo;
	local shooter = params.shooter;
	local stats = shooter.cnt;
	local ammo_left;

	--filippo: we dont want player shoot when in thirdperson and driving a vehicle without weapons (zodiac,paraglider,bigtruck)
	if (not BasicWeapon.CanFireInThirdPerson(self,shooter)) then
		return;
	end

	-- if shooter has killer flag - damage LocalPlayer with every shot
	if (shooter and shooter.killer) then
		local hit = params;
		hit.damage = 100;
		hit.damage_type = "normal";
		hit.target = _localplayer;
		hit.landed = 1;
		_localplayer:Damage( hit );
	end

	if (shooter.fireparams.AmmoType == "Unlimited") then
		wi = nil; -- unl. ammo token
		FireModeNum = 1;
		ammo = 1;
		ammo_left = 1;
	else
		wi = shooter.weapon_info;
		-- mixer: burst mode support
		if (shooter.fireparams.burst) then
			stats.ammo_in_clip=stats.ammo_in_clip-shooter.fireparams.burst+1;
			if (stats.ammo_in_clip < 0) then stats.ammo_in_clip=0; end
		end
		ammo = stats.ammo_in_clip;
		ammo_left = stats.ammo;
	end

	if (ammo_left > 0 or ammo > 0) then
		if (ammo > 0) then
			-- Substract ammunition

			if (wi ~= nil) then
				stats.ammo_in_clip = stats.ammo_in_clip - params.bullets;
				ammo = stats.ammo_in_clip;
			end

			local AISound = AIWeaponProperties[self.name];
			if (AISound) then
				-- generate event
				if (shooter.sounddata.FireLoop) then
					if (shooter.silenced_a) then
						AI:SoundEvent(shooter.sounddata.FireLoop,shooter:GetPos(),5,0.5,0,shooter.id);
					else
						AI:SoundEvent(shooter.sounddata.FireLoop,shooter:GetPos(),AISound.VolumeRadius,AISound.fThreat,0,shooter.id);
					end
				elseif (shooter.sounddata.FireSounds) then
					if (shooter.silenced_a) then
						AI:SoundEvent(shooter.sounddata.FireSounds[1],shooter:GetPos(),5,0.5,0,shooter.id);
					else
						AI:SoundEvent(shooter.sounddata.FireSounds[1],shooter:GetPos(),AISound.VolumeRadius,AISound.fThreat,0,shooter.id);
					end
				end
			-- this should not generate any error in multiplayer
			end
			
			retval = 1;

			----------------------------------------------
			--if (shooter.items) then
			--	if (not shooter.items["weapon_exp_"..self.name]) then
			--		shooter.items["weapon_exp_"..self.name] = 1;
			--	else
			--		shooter.items["weapon_exp_"..self.name] = shooter.items["weapon_exp_"..self.name]+1;
			--	end
			--	if (shooter.items["weapon_exp_"..self.name] > 10) then
			--		Hud:AddMessage("You have fired "..self.name.." more than 10 times and have increased your level!");
			--	end
			--end
			-------------------------------------------------------------
			
			-- AI EVENT clip nearly empty
			-- triggered if ammo in clip is less than 30% of total clip size
			-- Mixer: this is improved now to reduce CPU usage (check if ai or bot first).
			if (shooter.cis_wpn_nevalue) and (ammo == shooter.cis_wpn_nevalue) then
				AI:Signal(0,1,"OnClipNearlyEmpty",shooter.id);
			end
		end

		if (ammo_left == 0) and (ammo == 0) and (self.switch_on_empty_ammo == 1) then
			if (not GameRules.SurvivalManager) then
				stats:MakeWeaponAvailable(self.classid,0);
				if (BasicPlayer.AddPlayerHands) then
					BasicPlayer.AddPlayerHands(shooter);
				end
				stats:SelectFirstWeapon();
			else
				stats:SelectNextWeapon();
			end
		end

	end

	if (retval == 1 and shooter and shooter.invulnerabilityTimer~=nil) then
		shooter.invulnerabilityTimer=0;
	end

	if (retval==nil) then
		--play dry sounds that AI can heard
		AI:SoundEvent(shooter.id,shooter:GetPos(),3,0.5,0.5,shooter.id);
		-- Mixer - moved from above to reduce cpu usage, and optimized
		if (shooter.ai) then
			if (stats.ammo < 1) then
				stats.ammo = MaxAmmo[shooter.fireparams.AmmoType];
			elseif (stats.underwater > 0) and (stats.ammo_in_clip <= 0) then
				BasicPlayer.Reload(shooter);
			end
		end
	end

	-- Return value indicates if weapon can fire
	return retval;
end

function BasicWeapon:PlayShellsEjectionSound(shooter,material_field)
local material=shooter.cnt:GetTreadedOnMaterial();
if (material~=nil) then
local BulletHitZOffset=-1;-- offset from gun to play the bullet-hit sound from...
local BulletHitPos = shooter:GetPos();
BulletHitPos.z=BulletHitPos.z+BulletHitZOffset;
ExecuteMaterial(BulletHitPos, g_Vectors.v001, material[material_field], 1);
end
end
---
function BasicWeapon.Client:OnStopFiring(shooter)
BasicWeapon.StopFireLoop(self, shooter, shooter.fireparams, shooter.sounddata);
if (shooter.cnt.canfire) then
if (shooter==_localplayer) then
if (shooter.bFired_Sht) then
if (shooter.fireparams.BulletRejectType==BULLET_REJECT_TYPE_RAPID) then
BasicWeapon.PlayShellsEjectionSound(self,shooter,"bullet_drop_rapid");
elseif (shooter.fireparams.BulletRejectType==BULLET_REJECT_TYPE_SINGLE) then
BasicWeapon.PlayShellsEjectionSound(self,shooter,"bullet_drop_single");
end shooter.bFired_Sht = nil; end
else
-- Disable MuzzleFlash.
local MuzzleFlashParams = shooter._MuzzleFlashParams;
if (MuzzleFlashParams) then
BasicWeapon.ShowMuzzleFlash( MuzzleFlashParams.weapon,MuzzleFlashParams,0 );
end end end
self.bPlayedDrySound = nil;
end
---

function BasicWeapon.Client:OnFire(Params)
local basic_weapon=BasicWeapon;
local my_player=_localplayer;
local shooter=Params.shooter;
local sound=Sound;
local ReturnVal = nil;
local FireModeNum;
local WeaponStateData = shooter.weapon_info;
local CurFireParams;
local stats = shooter.cnt;
local scope=ClientStuff.vlayers:IsActive("WeaponScope");

self.nextfidgettime = nil;

if (shooter.fireparams.burst) then
	shooter.cis_burst_avail = shooter.cnt.ammo_in_clip * 1;
else
	shooter.cis_burst_avail = nil;
end

if (stats == nil or stats.weaponid == nil) then
	return;
end

if (not BasicPlayer.IsAlive(shooter)) then
	return;
end

-- For mounted weapons or other unlimited ammo weapons
if (self.FireParams[1].AmmoType == "Unlimited") then
	CurFireParams = self.FireParams[1];
else
	CurFireParams = shooter.fireparams;
end

--filippo: we dont want player shoot when in thirdperson and driving a vehicle without weapons (zodiac,paraglider,bigtruck)
if (not BasicWeapon.CanFireInThirdPerson(self,shooter,CurFireParams)) then
	--stop fire sounds and everything else need when player stop fire
	BasicWeapon.Client.OnStopFiring(self, shooter);
	return;
end

--[kirill]
--fixme - marko, need unlimited ammo for gunners in heli

if (shooter.fireparams.AmmoType == "Unlimited") then
	self.bPlayedDrySound = nil;
else
	if (shooter.dontfire and shooter ~= _localplayer) or (shooter == _localplayer and shooter.cnt.canfire==nil) then
		if (not self.bPlayedDrySound and shooter.sounddata.DrySound and sound:IsPlaying(shooter.sounddata.DrySound) == nil) then
			shooter.cnt:PlaySound(shooter.sounddata.DrySound);
			self.bPlayedDrySound = 1;
		end
		return
	else
		self.bPlayedDrySound = nil;
	end
	-- Mixer: non-unlimited, set ammo fired count to predict client/server
	if (shooter.amo_clfired) then
		shooter.amo_bFired = 1;
		if (shooter.fireparams.burst) then
			shooter.amo_clfired = shooter.amo_clfired + shooter.fireparams.burst;
		else
			shooter.amo_clfired = shooter.amo_clfired + 1;
		end
		shooter.cl_recshotpar = {
			pos = Params.pos,
			dir = Params.dir,
			angles = Params.angles,
			HitPt = Params.HitPt,
			HitDist = Params.HitDist,
			shooter = _localplayer,
			bFakeS = 1, -- to not mess with FireLoop glitching
		};
	end
end

-- Play animation. Mixer: aim fire animation support, if present...
if (shooter.cnt.first_person) and (not self.rotor_barrel) then
	self:ResetAnimation(0);
	if (shooter.cnt.aiming) and (self.anim_table[shooter.firemodenum]) and (self.anim_table[shooter.firemodenum].aimfire) then
		BasicWeapon.RandomAnimation(self,"aimfire",shooter.firemodenum);
	else
		BasicWeapon.RandomAnimation(self,"fire",shooter.firemodenum);
	end
	shooter.DTRapid = _time + 0.8;
end

shooter.bFired_Sht = 1;

-- Obtain the muzzle flash bone
local fire_pos = Params.pos;
local bMountedWeapon = shooter.cnt.lock_weapon;
local bVehicleWeapon = CurFireParams.vehicleWeapon;
local bHely = nil;

if (shooter.theVehicle) and (shooter.theVehicle.hely) then
	bVehicleWeapon = nil;
	bHely = 1;
end

if (bHely) or (bMountedWeapon) or (bVehicleWeapon) then
	fire_pos = shooter.cnt:GetTPVHelper(0, "spitfire");
elseif (stats.first_person and stats.weaponid > -1) then
	if( bMountedWeapon ) then
		fire_pos = shooter.cnt:GetTPVHelper(0, "spitfire");
	else
		if CurFireParams.dual_gun and mod(shooter.cnt.ammo_in_clip,2)==0 then
			CurFireParams.fx_f_dummy = "spitfire2";
		else
			CurFireParams.fx_f_dummy = "spitfire";
		end
		fire_pos = self.cnt:GetBonePos(CurFireParams.fx_f_dummy);
	end
elseif (shooter.ROCKET_ORIGIN) then
	fire_pos = shooter:GetBonePos(shooter.ROCKET_ORIGIN);
else
	if (self.object) then
		fire_pos = shooter.cnt:GetTPVHelper(0, "spitfire");
	else
		if (fire_pos ~= nil) and (fire_pos.x == 0) and (fire_pos.y == 0) and (fire_pos.z == 0) then
			fire_pos = nil;
		end
	end
end

if (fire_pos == nil) then
	fire_pos = Params.pos;
end

-- when we are looking through a weapon scope, the trail should come from the center 
if (scope) and (not self.AimMode) and (shooter.cnt.first_person) then
	local vCamPos = my_player:GetCameraPosition();
	local vShooterPos = shooter:GetPos();
	FastDifferenceVectors(vCamPos, vCamPos, vShooterPos);
	ScaleVectorInPlace(vCamPos, 0.9);
	fire_pos = SumVectors(vShooterPos, vCamPos);
	self.bw_mf_for_scope = 1;
end

-- Fire sound
if (CurFireParams.FireLoop) or (CurFireParams.FireLoopStereo) then
	-- Sound is modelled as a loop with a trailoff
	-- [marco] play stereo sounds for localplayer
	if (shooter.cnt.first_person) and (shooter.sounddata.FireLoopStereo) then
		if (sound:IsPlaying(shooter.sounddata.FireLoopStereo)==nil) then
			if (Params.bFakeS == nil) then
				if (shooter.silenced_a) then
					if shooter.sil_gunsnd == nil then
						--shooter.sil_gunsnd = Sound:LoadSound("Sounds/Weapons/MP5/mp5Fire3.wav");
						shooter.sil_gunsnd = Sound:LoadSound(shooter.fireparams.silenced);
					end
					if shooter.sil_gunsnd then
						if Sound:IsPlaying(shooter.sil_gunsnd) then Sound:StopSound(shooter.sil_gunsnd); end
						Sound:PlaySound(shooter.sil_gunsnd);
					end
				else
					sound:SetSoundLoop(shooter.sounddata.FireLoopStereo,1);
					shooter.cnt:PlaySound(shooter.sounddata.FireLoopStereo);
				end
			end
		end
	else
		if (shooter.sounddata.FireLoop) and (sound:IsPlaying(shooter.sounddata.FireLoop)==nil) then
			if (Params.bFakeS == nil) then
				sound:SetSoundLoop(shooter.sounddata.FireLoop,1);
				shooter.cnt:PlaySound(shooter.sounddata.FireLoop);
			end
		end
	end
else
	-- Sound is modelled as a random series of different fire sounds
	local nSoundIdx = random(1, getn( shooter.sounddata.FireSounds ) );
	local s_gunsnd = {x=0,y=0,z=0};
	if (my_player.GetPos) then
		s_gunsnd = my_player:GetCameraPosition();
	end
	if (shooter.cnt.first_person) and (shooter.sounddata.FireSoundsStereo) then
		if (CurFireParams.FireSoundsOUTstereo) and (not System:IsPointIndoors(s_gunsnd)) then
			s_gunsnd = shooter.sounddata.FireSoundsOUTstereo[nSoundIdx];
		else
			s_gunsnd = shooter.sounddata.FireSoundsStereo[nSoundIdx];
		end
		-- Mixer: prevent from overlapping the same sound
		if (shooter.silenced_a) then
			--s_gunsnd = Sound:LoadSound("Sounds/Weapons/MP5/mp5Fire3.wav");
			s_gunsnd = Sound:LoadSound(shooter.fireparams.silenced);
		end
		if (Sound:IsPlaying(s_gunsnd)) then Sound:StopSound(s_gunsnd); end
		Sound:PlaySound(s_gunsnd);
	else
		if (CurFireParams.FireSoundsOUT) and (not System:IsPointIndoors(s_gunsnd)) then
			s_gunsnd = shooter.sounddata.FireSoundsOUT[nSoundIdx];
		else
			s_gunsnd = shooter.sounddata.FireSounds[nSoundIdx];
		end
		-- Mixer: prevent from overlapping the same sound
		if (Sound:IsPlaying(s_gunsnd)) then Sound:StopSound(s_gunsnd); end
		shooter.cnt:PlaySound(s_gunsnd);
	end
end

-- sound event for the radar
local AISound = AIWeaponProperties[self.name];
if shooter.silenced_a then
	Game:SoundEvent(fire_pos,5,0.5,shooter.id);
elseif (AISound ~= nil) then
	Game:SoundEvent(fire_pos,AISound.VolumeRadius,AISound.fThreat,shooter.id);
end

-- Use a temporary member table to avoid a table creation
local vDirection = basic_weapon.temp_dir;
local hasFakeHit = 0;
if (Params.HitPt == nil or (Params.HitPt.x == 0 and Params.HitPt.y == 0 and Params.HitPt.z == 0) ) then
hasFakeHit = 1;
CopyVector( vDirection,Params.dir );
ScaleVectorInPlace(vDirection, basic_weapon.VoidDist);
vDirection.x = vDirection.x + Params.pos.x - fire_pos.x;
vDirection.y = vDirection.y + Params.pos.y - fire_pos.y;
vDirection.z = vDirection.z + Params.pos.z - fire_pos.z;
else
local pt = Params.HitPt;
vDirection.x = pt.x - fire_pos.x;
vDirection.y = pt.y - fire_pos.y;
vDirection.z = pt.z - fire_pos.z;
end

-- Spawn a trail
if(not (tonumber(w_firstpersontrail)==0 and shooter.cnt.first_person)) then
local trace = CurFireParams.Trace;
if (trace) then
-- moving trace
trace.init_angles = basic_weapon.temp_angles;
ConvertVectorToCameraAngles(trace.init_angles, vDirection);

if (Params.HitDist == nil or Params.HitDist<0) then
trace.lifetime = basic_weapon.VoidDist/trace.speed;
else
trace.lifetime = Params.HitDist/trace.speed;
end
--we don't want traces to bounce
trace.bouncyness = 0;
trace.space_box = {x=0,y=0,z=0};
if(vDirection.x<0) then trace.space_box.x = -vDirection.x; 
else trace.space_box.x = vDirection.x; end
if(vDirection.y<0) then trace.space_box.y = -vDirection.y;
else trace.space_box.y = vDirection.y; end
if(vDirection.z<0) then trace.space_box.z = -vDirection.z;
else trace.space_box.z = vDirection.z; end
-- adding flag PART_FLAG_SPACELIMIT2048 
trace.particle_type = bor(trace.particle_type, 2048);
Particle:CreateParticle(fire_pos, vDirection, trace);
end
end

--Particle system flags
--#define PART_FLAG_BILLBOARD     0 // usual particle
--#define PART_FLAG_HORIZONTAL    1 // flat horisontal rounds on the water
--#define PART_FLAG_UNDERWATER    2 // particle will be removed if go out from outdoor water
--#define PART_FLAG_LINEPARTICLE  4 // draw billboarded line from vPosition to vPosition+vDirection
--#define PART_FLAG_SWAP_XY       8 // alternative order of rotation (zxy)
--#define PART_SIZE_LINEAR       16 // change size liner with time
--#define PART_FLAG_NO_OFFSET    32 // disable centering of static objects
--#define PART_FLAG_DRAW_NEAR    64 // render particle in near (weapon) space

--if ((shooter~=_localplayer) or (not scope) or (self.AimMode and scope)) then
if (shooter) then
-- Spawn smoke, bubbles, SpitFire etc.
if (Game:IsPointInWater(Params.pos) == nil) then
if (fire_pos) then

--weaponfx
local weaponfx = tonumber(getglobal("cl_weapon_fx"));
local firstperson = stats.first_person;

--mounted and vehicle weapons ever act like we are in thirperson
if (bMountedWeapon or bVehicleWeapon) then firstperson = nil; end
--no smoke on low settings
if(CurFireParams.SmokeEffect and weaponfx>0) then
BasicWeapon:HandleParticleEffect(CurFireParams.SmokeEffect,fire_pos,vDirection,firstperson,weaponfx);
end

--if there is no partile muzzle effect or cl_weapon_fx is set to 0 use normal muzzleflashes.
--FIXME:temporarly removed from default the particle muzzleflashes , everyone is complaining about them.
--btw, still usable with cl_weapon_fx 3.
if (CurFireParams.MuzzleEffect) and (weaponfx>2 or self.bw_mf_for_scope) then
BasicWeapon:HandleParticleEffect(CurFireParams.MuzzleEffect,fire_pos,vDirection,firstperson,weaponfx);
self.bw_mf_for_scope = nil;
elseif (CurFireParams.MuzzleFlash) then

CurFireParams.MuzzleFlash.init_angles = Params.angles;
CurFireParams.MuzzleFlash.init_angles.y = random(0, 360);

-- remember flags
local flag = CurFireParams.MuzzleFlash.particle_type;
-- if first person - chcange it

-- NEW MUZZLE FLASH
if (not shooter._MuzzleFlashParams) then
shooter._MuzzleFlashParams = {};
end
local MuzzleFlashParams = shooter._MuzzleFlashParams;
MuzzleFlashParams.weapon = self;
MuzzleFlashParams.shooter = shooter;
MuzzleFlashParams.MuzzleFlash = CurFireParams.MuzzleFlash;

if (stats.first_person) then
	MuzzleFlashParams.bFirstPerson = CurFireParams.fx_f_dummy;
else
	MuzzleFlashParams.bFirstPerson = nil;
	if (CurFireParams.MuzzleFlashTPV) then
		MuzzleFlashParams.MuzzleFlash = CurFireParams.MuzzleFlashTPV;
	end
end
-- For mounted weapon.
if (bMountedWeapon) then
MuzzleFlashParams.weapon = shooter.current_mounted_weapon;
MuzzleFlashParams.shooter = shooter.current_mounted_weapon;
end

if ( bVehicleWeapon ) then
MuzzleFlashParams.weapon = self;
MuzzleFlashParams.shooter = self;
MuzzleFlashParams.bFirstPerson = nil;
VC.ShowMuzzleFlash( Params.shooter.theVehicle, MuzzleFlashParams, 1);
else
-- Check if muzzle flash for this shooter is already active.
BasicWeapon.ShowMuzzleFlash( self,MuzzleFlashParams,1 );
end
end

end
end

-- Shell Cases
if (CurFireParams.ShellCases) then
if (CurFireParams.ShellCases.geometry) then

local ShellCaseExitPt;

if (shooter.cnt.first_person) then
	--filippo: if is a vehicle weapon use the helper.
	if (stats.lock_weapon) or (bVehicleWeapon) then -- mounted weapon - just get helper
		ShellCaseExitPt = stats:GetTPVHelper(0, "shells");
	else
		ShellCaseExitPt = self.cnt:GetBonePos("shells");
	end
else
	ShellCaseExitPt = stats:GetTPVHelper(0, "shells");
end

if (ShellCaseExitPt and CurFireParams.ShellCases) then
--filippo
CurFireParams.ShellCases.init_angles = Params.angles;
CurFireParams.ShellCases.rotation = BasicWeapon.temp.rotate_vector;
CurFireParams.ShellCases.rotation.x = random(-600,600)*0.1;
CurFireParams.ShellCases.rotation.y = random(-600,600)*0.1;
CurFireParams.ShellCases.rotation.z = random(-600,600)*0.1;
CurFireParams.ShellCases.bouncyness = 0.25;
--
CurFireParams.ShellCases.focus = 10.5;
CurFireParams.ShellCases.speed = 1.5;
CurFireParams.ShellCases.particle_type = 32;
CurFireParams.ShellCases.physics = 1;

local vExitDirection = basic_weapon.temp_exitdir;
vExitDirection.x = Params.dir.y;
vExitDirection.y = -Params.dir.x;
vExitDirection.z = random(0,150)*0.01;
Particle:CreateParticle(ShellCaseExitPt, vExitDirection, CurFireParams.ShellCases);
end
else
System:Log("ERROR: No CGF File Specified For Shell Case Particle System !");
end
end
end

if (CurFireParams.ExitEffect) then
Particle:SpawnEffect(fire_pos, vDirection, CurFireParams.ExitEffect, 1.0);
end

-- Spawn a trace of bubbles when underwater
local doBubbles = 0;
-- check start point
if ( CurFireParams.fire_mode_type == FireMode_Instant and
 (Game:IsPointInWater(Params.pos) or (hasFakeHit == 0 and Game:IsPointInWater(Params.HitPt))) and
 shooter~=my_player) then
doBubbles = 1;
end

if(tonumber(w_underwaterbubbles)==1 and doBubbles == 1)then
--ONLY IF IS UNDERWATER
local vCurPosOnTrace=basic_weapon.temp_pos
local vStep = Params.dir;
CopyVector(vCurPosOnTrace,Params.pos);
ScaleVector(vStep, 3);
for i=0, 30 do
FastSumVectors(vCurPosOnTrace,vCurPosOnTrace, vStep);
if (Game:IsPointInWater(vCurPosOnTrace) == nil) then
if (i ~= 0) then break;end
-- at this point we have to calculate the intersection with the water plane
local waterLevel = Game:GetWaterHeight();
local d = vStep.z;
if (d > -0.0001 and d < 0.0001) then break;end
local t = -(vCurPosOnTrace.z-waterLevel)/d;
vCurPosOnTrace.x = vCurPosOnTrace.x + Params.dir.x * t;
vCurPosOnTrace.y = vCurPosOnTrace.y + Params.dir.y * t;
vCurPosOnTrace.z = vCurPosOnTrace.z + Params.dir.z * t;
end
Particle:CreateParticle(vCurPosOnTrace, g_Vectors.v001, basic_weapon.TracerBubbles);
end
end

--if underwater > 0 player is underwater
if (stats.underwater<=0) then
--ONLY IF IS NOT UNDERWATER

if ((shooter ~= _localplayer) or (_localplayer.FlashLightActive==0)) then

-- make light flash when weapon is used
local doProjectileLight = tonumber(getglobal("cl_weapon_light"));

if (CurFireParams.LightFlash and doProjectileLight == 1) then -- no specular
	local diff=CurFireParams.LightFlash.vDiffRGBA;
	if (not shooter.cnt.first_person) then
		shooter:RenderShadow(0);
	end
	shooter:AddDynamicLight(fire_pos,CurFireParams.LightFlash.fRadius,diff.r*0.5,diff.g*0.5,diff.b*0.5,diff.a,0,0,0,0,CurFireParams.LightFlash.fLifeTime);
	if (not shooter.cnt.first_person) then
		shooter:RenderShadow(1);
	end
elseif (CurFireParams.LightFlash and doProjectileLight == 2) then -- with specular
	-- vPos, fRadius, DiffR, DiffG, DiffB, DiffA, SpecR, SpecG, SpecB, SpecA, fLifeTime
	local diff=CurFireParams.LightFlash.vDiffRGBA;
	local spec=CurFireParams.LightFlash.vSpecRGBA;
	if (not shooter.cnt.first_person) then
		shooter:RenderShadow(0);
	end
	shooter:AddDynamicLight(fire_pos,CurFireParams.LightFlash.fRadius,diff.r*0.5,diff.g*0.5,diff.b*0.5,diff.a,spec.r*0.5,spec.g*0.5,spec.b*0.5,spec.a,CurFireParams.LightFlash.fLifeTime);
	if (not shooter.cnt.first_person) then
		shooter:RenderShadow(1);
	end
end

end

if (Params.BulletPlayerPos and CurFireParams.whizz_sound) then
local bSkip=0;
if (CurFireParams.whizz_probability) then
if (random(0, 1000)>CurFireParams.whizz_probability) then
bSkip=1;
end
end
if (bSkip==0) then
local pWhizzSound=CurFireParams.whizz_sound[random(1, getn(CurFireParams.whizz_sound))];
if (pWhizzSound) then
Sound:SetSoundPosition(pWhizzSound, Params.BulletPlayerPos);
Sound:PlaySound(pWhizzSound);
end
end
end
end
ReturnVal = 1;

if (self.DoesFTBSniping and (shooter==_localplayer)) then
	FTBSniping.OnFire(FTBSniping);
end

--filippo: apply view shake
if (CurFireParams.weapon_viewshake ~= nil and CurFireParams.weapon_viewshake > 0) then
if (CurFireParams.weapon_viewshake_amt ~= nil) then
shooter.cnt:ShakeCameraL(CurFireParams.weapon_viewshake_amt, CurFireParams.weapon_viewshake, CurFireParams.fire_rate);
else
shooter.cnt:ShakeCameraL(CurFireParams.weapon_viewshake * 0.001, CurFireParams.weapon_viewshake, CurFireParams.fire_rate);
end
end
----
return ReturnVal;
end

function BasicWeapon.Server:OnHit(hit)
	-- augment hit table with damage type
	if (hit.shooter.fireparams.damage_type) then
		hit.damage_type = hit.shooter.fireparams.damage_type;
	else
		hit.damage_type = "normal";
	end
	if (hit.target_material) then
		-- spawn client side effect
		if (hit.target) then
			if (_localplayer) and (hit.shooter == _localplayer) then
			elseif (hit.clpredictedhit == nil) and (hit.shooter.POTSHOTS == nil) then
				hit.damage = 0;
				return;
			end
			
			if (hit.target.type == "Player") and (hit.damage_type == "normal") and (hit.target.invulnerabilityTimer==nil) then
				if (Game:IsMultiplayer()) then
					local ss=Server:GetServerSlotByEntityId(hit.shooter.id);
					if (ss) then
						hit.target.items.bleed_dmgr = ss:GetId();
					elseif (hit.shooter.vbot_ssid) then
						hit.target.items.bleed_dmgr = hit.shooter.vbot_ssid*1;
					end
					if BasicPlayer.IsAlive(hit.target) then
						-- MIXER: MP IMPROVEMENT: NEW BROADCASTED COMMAND WITH MORE INFO:
						-- hit dir x and y are used for hud damage indicator (these red bands on the side of screen)
						-- and hit.damage used for calculation of hud damage effect. target id is used for effect AND also for correct of play pain sounds
						-- of target. shooter id is used to play some effect for shooter (hit sound, for example)
						Server:BroadcastCommand("CHI "..hit.shooter.id.." "..hit.target.id.." "..hit.damage);
					end
				elseif (not hit.shooter.POTSHOTS) and (BasicPlayer.IsAlive(hit.target)) then
					Hud.hit=5;
				end
				if (hit.target_material.type ~= "armor") and (hit.target_material.type ~= "helmet") then
					if (hit.is_punch) then
						BasicPlayer.SetBleeding(hit.target, 0,2);
					else
						BasicPlayer.SetBleeding(hit.target, 0,hit.damage);
					end
				end
			end
		end
		if (hit.target_material.AI) then
			AI:FreeSignal(1,"OnBulletRain",hit.pos, hit.target_material.AI.fImpactRadius,hit.shooter.id);
		end
	end
	
	---------------- add damage :damage here
end
---
function BasicWeapon.Client:OnHit(hit)
	local shooter = hit.shooter;
	if (shooter.cis_burst_avail) then
		if (shooter.cis_burst_avail <= 0) then
			if (shooter.sounddata.DrySound) and (Sound:IsPlaying(shooter.sounddata.DrySound) == nil) then
				shooter.cnt:PlaySound( shooter.sounddata.DrySound );
			end
			return;
		else
			shooter.cis_burst_avail = shooter.cis_burst_avail - 1;
		end
	end
	
	-- augment hit table with damage type
	if shooter.fireparams and shooter.fireparams.damage_type then
		hit.damage_type = shooter.fireparams.damage_type;
		if (hit.damage_type ~= "normal" and hit.damage_type ~= "building") then
			hit.target_material = nil;
		end
	else
		hit.damage_type = "normal";
	end
	-- hit effect
	local effect="bullet_hit";

	if (hit.target_material) then

		if (shooter.fireparams) and (shooter.fireparams.mat_effect) then
			effect=shooter.fireparams.mat_effect;
			if (hit.target_material[effect] == nil) then
				hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_default"));
			end
		end

		if (hit.target) then
			if (hit.target.type == "Player") then
				local doProjGore;
				-- armor fx for heavy metal bad guys (saves performance in this case too)
				if (hit.target.ai) and (hit.target.Properties.fSpeciesHostility > 2) then
					if (hit.target.Properties.fSpeciesHostility == 4) then
						hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName(hit.target.Properties.AnimPack));
					else
						hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_metal_plate_nd"));
					end
				else
					-- not use helmet material if no helmet
					if (hit.target_material.type=="helmet") then
						if (hit.target.hasHelmet == 0) then
							hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_head"));
							doProjGore = 1;
						end
					-- not use flesh material if player has armor -- Mixer
					elseif (hit.target_material.type=="flesh") then
						if (hit.target.cnt.armor <= 0) then
							doProjGore = 1;
						else
							hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_armor"));
						end
					-- not use armor material if no armor -- Mixer
					elseif (hit.target_material.type=="armor") then
						if (hit.target.Properties.bHasArmor == 0) then
							if (hit.target.cnt.armor <= 0) then
								hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_flesh")); 
								doProjGore = 1;
							end
						end
					-- has kevlar helmet? then change to mat_helmet -- Mixer
					elseif (hit.target_material.type=="head") then
						if (hit.target.items) and (hit.target.items.kevlarhelmet) then
							hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_helmet"));
						else
							doProjGore = 1;
						end
					else
						doProjGore = 1;
					end
				end
				if (hit.target == _localplayer) and (not Game:IsServer()) then
					hit.suppressParticleEffect = nil;
				else
					-- draw blood decals on walls and terrain (not if we got hit by EngineerTool)
					if (doProjGore and hit.damage_type ~= "building") then
						BasicPlayer.DoProjectedGore( hit.target, hit );
					end
					ExecuteMaterial2(hit,effect);
					hit.suppressParticleEffect = nil;
				end
				----------------------
				---------------------------------
			else
				ExecuteMaterial2( hit ,effect);
				hit.suppressParticleEffect = nil;
			end
			if shooter == _localplayer and Game:IsServer()==nil and hit.damage > 0 then
				if self.ShotList == nil then
					self.ShotList = "";
					--self.ShotDetail
				--elseif shooter.fireparams and shooter.fireparams.bullet_per_shot and shooter.fireparams.bullet_per_shot <= 1 and self.ShotList[hit.target.id] then
				--else
				--	if 
				end
				-----------------------------------------------------------------
				if hit.ipart then
					self.ShotList = self.ShotList..hit.target.id.."a"..hit.target_material.type.."/"..hit.ipart.." ";
				else
					self.ShotList = self.ShotList..hit.target.id.."a"..hit.target_material.type.."/-1 ";
				end
				
				
				
				
				
				------------------------------------------------------------------------------------------
				
				
				
				
				
				--if (hit.ipart) then
				--	Client:SendCommand("CHT "..hit.target.id.." "..hit.target_material.type.." "..hit.ipart);
				--else
				--	Client:SendCommand("CHT "..hit.target.id.." "..hit.target_material.type);
				--end
				--
				--System:Warning("HitDamage client calculated: "..hit.damage);
				
			end
		else
			ExecuteMaterial2( hit ,effect);
			hit.suppressParticleEffect = nil;
		end

		-- light on hit solid surfaces
		if (hit.target_material.litespark) and (effect=="bullet_hit") and (random(1,3)==3) then
			shooter:AddDynamicLight(hit.pos, 0.7, 1, 1, 0.7, 1, 1, 1, 0.7, 1, 0.15);
		end
	end
end
---
function BasicWeapon.Server:OnEvent( EventId, Params )
local EventSwitch=BasicWeapon.Server_EventHandler[EventId];
if(EventSwitch)then
return EventSwitch(self,Params);
end
end
---
function BasicWeapon.Client:OnEvent( EventId, Params )
--System:Log("BasicWeapon.Client:OnEvent "..EventId);
local EventSwitch=BasicWeapon.Client_EventHandler[EventId];
if(EventSwitch)then
return EventSwitch(self,Params);
end
end
---


--NEW MUZZLE FLASH ATTACHMENT SYSTEM //TIMUR&MAX----------
-- MuzzleFlashTimer turn off timer callback.
--------------------------------------------------------
MuzzleFlashTurnoffCallback =
{
OnEvent = function( self,event,Params )
if (Params) then
BasicWeapon.ShowMuzzleFlash( Params.weapon,Params,0 );
end
end
}

----------------------------
function BasicWeapon:ShowMuzzleFlash( MuzzleFlashParams,bEnable )

local geomName = "Objects/Weapons/MUZZLEFLASH/muzzleflash.cgf";
local boneName;
local target;
local lifetime = 10;

if (MuzzleFlashParams.bFirstPerson) then
	target = MuzzleFlashParams.weapon;
	if (MuzzleFlashParams.shooter.silenced_a) then return; end
	if (MuzzleFlashParams.shooter.fireparams.dual_gun) then
		MuzzleFlashParams.MuzzleFlash.bone_name = MuzzleFlashParams.bFirstPerson;
		--------------------
		if MuzzleFlashParams.bActive and bEnable == 1 then
			MuzzleFlashParams.bActive = nil;
			if (MuzzleFlashParams.bind_handle) then
				target:DetachObjectToBone( boneName,MuzzleFlashParams.bind_handle );
				MuzzleFlashParams.bind_handle = nil;
			end
		end
		--------------------------------
	else
		boneName = MuzzleFlashParams.bFirstPerson;
	end
else
	boneName = "weapon_bone";
	target = MuzzleFlashParams.shooter;
end

if (MuzzleFlashParams.bActive and bEnable == 1) then	
	MuzzleFlashParams.bRepeat = 1;
	do return end;
end


if (MuzzleFlashParams.MuzzleFlash.geometry_name) then
	-- Mixer: big mutant machinegun effect
	if (target.ROCKET_ORIGIN_KEYFRAME) then
		geomName = "Objects/Weapons/Muzzle_Flash/mf_mutantshotgun_tpv.cgf";
	else
		geomName = MuzzleFlashParams.MuzzleFlash.geometry_name;
	end
end

-- Life time must be in seconds.
if (MuzzleFlashParams.MuzzleFlash.lifetime) then
	lifetime = MuzzleFlashParams.MuzzleFlash.lifetime * 1000;
end

if (MuzzleFlashParams.MuzzleFlash.bone_name) then
	if (target.su_turret) then
		geomName = "Objects/weapons/trail_defsentry.cgf";
		boneName = "Bip01 Head";
	else
		boneName = MuzzleFlashParams.MuzzleFlash.bone_name;
	end
end

-- If MuzzleFlash is active and fire was repeated.
if (MuzzleFlashParams.bRepeat ~= nil and bEnable == 0) then
MuzzleFlashParams.bRepeat = nil;
MuzzleFlashParams.bActive = nil;
-- Play Muzzle Flash just... abit longer 1/3rd of normal muzzle flash time, until next muzzle flash will be initialized if needed.
Game:SetTimer( MuzzleFlashTurnoffCallback,lifetime*0.3,MuzzleFlashParams );
do return end;
end

local rnd=random(1,2);
if (bEnable == 1) then
MuzzleFlashParams.bActive = 1;
if (MuzzleFlashParams.bind_handle == nil) then
target:LoadObject( geomName,2,1 );
MuzzleFlashParams.bind_handle = target:AttachObjectToBone( 2, boneName,1 );
end

if (MuzzleFlashParams.aux_bind_handle == nil) then
if (rnd==1) then
MuzzleFlashParams.aux_bind_handle = target:AttachObjectToBone( 2, "aux_"..boneName,1 );
end
end
else
MuzzleFlashParams.bActive = nil;
if (MuzzleFlashParams.bind_handle) then
target:DetachObjectToBone( boneName,MuzzleFlashParams.bind_handle );
MuzzleFlashParams.bind_handle = nil;
end

if (MuzzleFlashParams.aux_bind_handle) then
target:DetachObjectToBone( "aux_"..boneName,MuzzleFlashParams.aux_bind_handle );
MuzzleFlashParams.aux_bind_handle = nil;
end
end

if (bEnable == 1) then
-- This will result in a call to BasicWeapon.Client:TimerEvent
Game:SetTimer( MuzzleFlashTurnoffCallback,lifetime,MuzzleFlashParams );
end
end

-- MIXER: FIREMODE CHANGE FIXED NOW, SO YOU CAN USE MORE THAN 2 FIREMODES!
function BasicWeapon.Server:FireModeChange(params)
if (type(params) == "table" and params.shooter) then
local shooter = params.shooter;
if (shooter.cnt.reloading == nil) then
local weaponState = GetPlayerWeaponInfo(shooter);
local switchclip=1;

if(shooter.fireparams.AmmoType==shooter.cnt.weapon.FireParams[params.firemode+1].AmmoType or params.ignoreammo) then
	switchclip=nil;
else
if(shooter.cnt.weapon.FireParams[params.firemode-1]) and (shooter.cnt.weapon.FireParams[params.firemode-1].AmmoType == shooter.fireparams.AmmoType) then
weaponState.AmmoInClip[shooter.firemodenum-1]=shooter.cnt.ammo_in_clip; end
shooter.Ammo[shooter.fireparams.AmmoType]=shooter.cnt.ammo;
weaponState.AmmoInClip[shooter.firemodenum]=shooter.cnt.ammo_in_clip;
end

if (shooter.cnt.weapon_busy <= 0) then
	local fm_chngtime=0;
	if (self) and (self.anim_table) and (self.anim_table[shooter.firemodenum]) and (self.anim_table[shooter.firemodenum].modeactivate) then
		fm_chngtime=self:GetAnimationLength(self.anim_table[shooter.firemodenum].modeactivate[1]);
	end
	if fm_chngtime <= 0 then
      		fm_chngtime=self:GetAnimationLength("Activate"..shooter.firemodenum);
	end
	if fm_chngtime <= 0 then
      		fm_chngtime=self:GetAnimationLength("Activate1");
	end
	if fm_chngtime > 0 then
		shooter.cnt.weapon_busy=fm_chngtime;
	end
end

weaponState.FireMode=params.firemode;
BasicWeapon.SyncVarCache(self,shooter);

if (switchclip) then
	shooter.cnt.ammo = shooter.Ammo[shooter.fireparams.AmmoType];
	shooter.cnt.ammo_in_clip = weaponState.AmmoInClip[shooter.firemodenum];
end

return 1
end
end
return nil
end
---
function BasicWeapon.Client:FireModeChange(Params)
-- Did we get the owner passed?
if (type(Params) == "table" and Params.shooter) then
local shooter = Params.shooter;
if (shooter.cnt.reloading == nil) then
BasicWeapon.SyncVarCache(self,shooter);

if (shooter == _localplayer) then
	shooter.amo_bFired = nil;
	if (ClientStuff.vlayers:IsActive("WeaponScope") and shooter.fireparams.no_zoom == 1) then
		ClientStuff.vlayers:DeactivateLayer("WeaponScope");
	end

	if (Params.ignoreammo == nil) and (self.FireParams[2]~=nil) then
		shooter.bFired_Sht = nil;
		if (not shooter.cis_svgload) and (BasicWeapon.fireModeChangeSound) and (not shooter.dlgholstered_gun) then
			shooter.cnt:PlaySound(BasicWeapon.fireModeChangeSound);
		end
	end
	if (shooter.cis_svgload) then shooter.cis_svgload = nil; end
	-------- test silencer stuff
	if (shooter.silentstuff1) and (shooter.fireparams.silenced) then
		shooter.silenced_a = 1;
	else
		shooter.silenced_a = nil;
	end

	------
	local fm_chngtime=0;
	if (self) and (shooter.cnt.weapon_busy <= 0) and (self.anim_table) and (self.anim_table[shooter.firemodenum]) and (self.anim_table[shooter.firemodenum].modeactivate) then
		fm_chngtime=self:GetAnimationLength(self.anim_table[shooter.firemodenum].modeactivate[1]);
		if fm_chngtime > 0 then
			shooter.playingReloadAnimation = 1;
			BasicWeapon.RandomAnimation(self,"modeactivate",shooter.firemodenum);
		end
	end

	if (not Game:IsServer()) and (shooter.cnt.weapon_busy <= 0) then
		if (fm_chngtime <= 0) then
			fm_chngtime=self:GetAnimationLength("Activate"..shooter.firemodenum);
		end
		if (fm_chngtime <= 0) then
			fm_chngtime=self:GetAnimationLength("Activate1");
		end
		if fm_chngtime > 0 then
			shooter.cnt.weapon_busy=fm_chngtime;
		end
	end
	------
end

if (shooter.fireparams) and (shooter.fireparams.type) then
	self.cnt:SetHoldingType(shooter.fireparams.type);
end

return 1
end
end
return nil
end
---
function BasicWeapon:DrawCrosshair(r,g,b,accuracy, xpos, ypos)

local factor = 0;
if (_localplayer.entity_type == "spectator") then
if (_localplayer.cnt.GetHost) then
local ent = System:GetEntity(_localplayer.cnt:GetHost());
factor = ent.cnt:CalculateAccuracyFactor(accuracy);
 
end

else
factor = _localplayer.cnt:CalculateAccuracyFactor(accuracy);
end
local xcent=400;
local ycent=300;

if( ypos ) then
xcent=xpos;
ycent=ypos;
end

local shift = xcent * tan(0.1308997)/tan(Game:GetCameraFov()/2.0) * factor;

if (BasicWeapon.prevShift ~= nil) then
	shift = BasicWeapon.prevShift * 0.9 + shift * 0.1;
end

%System:Draw2DLine(xcent-7-shift,ycent,xcent-2-shift,ycent,r,g,b, Hud.f_value);  --
%System:Draw2DLine(xcent+2+shift,ycent,xcent+7+shift,ycent,r,g,b, Hud.f_value);  --
----if (_localplayer.cnt.aiming == nil) then
%System:Draw2DLine(xcent,ycent-2-shift,xcent,ycent-7-shift,r,g,b, Hud.f_value); --
--end
%System:Draw2DLine(xcent,ycent+2+shift,xcent,ycent+7+shift,r,g,b, Hud.f_value);  --
--small dot in the centre of screen.
-- if not Game:IsMultiplayer() then -- L_A_G_G_E_R
	-- %System:Draw2DLine(xcent,ycent-0.5,xcent,ycent+0.5,r,g,b,fValue)
-- end
--System:Log("Lines have been drawn for crosshair at line 1303");

BasicWeapon.prevShift = shift;
end
------------
function BasicWeapon.Client:OnEnhanceHUD(scale, bhit, xpos, ypos)
	local myplayer = _localplayer;

	if (myplayer.entity_type == "spectator" and myplayer.cnt.GetHost) then
		if (_localplayer.cnt:GetHost() == 0 ) then
		else
			myplayer = System:GetEntity(_localplayer.cnt:GetHost());
		end
	end

	-- some weapons (Mortar) don't have this parameter
	if (scale == nil) then
		scale = 1;
	end

	if (myplayer) then
		local stats = myplayer.cnt;
		if ((stats.first_person or (myplayer.fireparams.draw_thirdperson~=nil and myplayer.fireparams.draw_thirdperson==1)) and myplayer.fireparams.HasCrosshair) then
			if ((not ClientStuff.vlayers:IsActive("Binoculars")) and (((not ClientStuff.vlayers:IsActive("WeaponScope")) or (self.AimMode)) or self.ZoomForceCrosshair)) then
				if (bhit and bhit>0) then
					BasicWeapon.DrawCrosshair(self,1,0,0,stats.accuracy*scale, xpos, ypos);
				elseif (stats.reloading or (stats.ammo_in_clip == 0 and stats.ammo == 0 and myplayer.fireparams.AmmoType ~= "Unlimited")) then
					BasicWeapon.DrawCrosshair(self,0.25,0.25,0,stats.accuracy*scale, xpos, ypos);
				else
					BasicWeapon.DrawCrosshair(self,1,1,0,stats.accuracy*scale, xpos, ypos);
				end
			end
		end
	end
end

function BasicWeapon.Server:OnActivate(Params)
	-- Set player-related stuff...
	local shooter = Params.shooter;
	if (shooter) then
		local stats = shooter.cnt;
		local AmmoType;
		shooter.weapon_info=GetPlayerWeaponInfo(shooter);
		if (shooter.weapon_info) then
			BasicWeapon.SyncVarCache(self,shooter);
			AmmoType = shooter.fireparams.AmmoType;
			stats.ammo = shooter.Ammo[AmmoType];
			stats.ammo_in_clip = shooter.weapon_info.AmmoInClip[shooter.firemodenum];
			stats.weapon_busy=self:GetAnimationLength("Activate"..shooter.firemodenum);
			if (shooter.POTSHOTS) then
				shooter.cis_wpn_nevalue = floor(shooter.fireparams.bullets_per_clip*0.33);
				if (shooter.ai) then
					if (shooter.fireparams.distance) then
						if (shooter.fireparams.distance < 2) then
							shooter:ChangeAIParameter(AIPARAM_ATTACKRANGE,2);
						else
							shooter:ChangeAIParameter(AIPARAM_ATTACKRANGE,shooter.fireparams.distance);
						end
					elseif (shooter.Properties.attackrange) then
						shooter:ChangeAIParameter(AIPARAM_ATTACKRANGE,shooter.Properties.attackrange);
					end
				end
			end
		end
		self.OldSpeedScale = stats.speedscale;
		if (WeaponsParams.Falcon.Std[1].promode==nil) then
			stats.speedscale = self.PlayerSlowDown;
		end
	end
end

function BasicWeapon.Client:OnActivate(Params)
	-- set player-related stuff...
	
	local shooter = Params.shooter;
	if (shooter) then
		-- big mutants can have any weapon now!
		if (shooter.ROCKET_ORIGIN_KEYFRAME) then
			shooter.cnt:DrawThirdPersonWeapon(0);
		end
		local stats = shooter.cnt;
		shooter.weapon_info=GetPlayerWeaponInfo(shooter);
		if (shooter.weapon_info ~= nil) then
			BasicWeapon.SyncVarCache(self,shooter);
		end
		
		shooter.sil_gunsnd = nil;

		if (shooter == _localplayer) and (BasicPlayer.IsAlive(shooter)) then 
		_localplayer.szSkinName = "Alex_Darer";

			-- Mixer: modified to prevent activation sound play on load
			if (not shooter.cis_svgload) and (self.ActivateSound) and (not shooter.dlgholstered_gun) then
				shooter.cnt:PlaySound( self.ActivateSound );
			end

			-- end modified, see BasicPlayer.lua also
			-- svgload sets to nil on firemodechange func

			-------- test silencer stuff
			shooter.silenced_a = nil;
			shooter.pckanm_do = nil;
			---- client/server ammo sync
			
			if (not Game:IsServer()) then
				shooter.amo_clfired = 0;
				shooter.amo_svfired = 0;
				shooter.amo_prfired = nil;
			end

			if (shooter.items.silencer_a) then
				if (shooter.items.silencer_a == WeaponClassesEx[self.name].id) then
					if (not shooter.silentstuff1) then
						self:LoadObject("Objects/weapons/hands2/silencer"..self.silencer..".cgf",2,1);
						if self.silencer == "_c_aug" then
							shooter.silentstuff1 = self:AttachObjectToBone( 2, "shells",1 );
						else
							shooter.silentstuff1 = self:AttachObjectToBone( 2, "spitfire",1 );
						end
					end
					if (shooter.fireparams.silenced) then
						shooter.silenced_a = 1;
					end
				else
					shooter.silentstuff1 = nil;
				end
			end
			--------

			if (shooter.firemodenum ~= nil) then
				stats.weapon_busy=self:GetAnimationLength("Activate"..shooter.firemodenum);
				-- Look here
				BasicWeapon.RandomAnimation(self,"activate",shooter.firemodenum);
			end

			self.cnt:SetFirstPersonWeaponPos(g_Vectors.v000, g_Vectors.v000);

			-- if we are using binoculars, remove them when activating a new weapon
			if (ClientStuff.vlayers:IsActive("Binoculars")) then
				ClientStuff.vlayers:DeactivateLayer("Binoculars");
			end

			BasicPlayer.ProcessPlayerEffects(shooter,1); -- 1 means performing hands fx update

			BasicWeapon.Show(self,shooter);
			shooter.mp_weapon_active = 1;
		if _localplayer.szSkinName ~= nil and self.name ~=nil then		----01010
		_localplayer:SetMaterial("weapons_alex." .. _localplayer.szSkinName .. "." .. self.name );
		end
		else -- localplayer code
			if (shooter.TpvReloadFX) and (shooter.classname == "Player") then
				shooter.cnt:PlaySound(shooter.TpvReloadFX[2][3]);
			end
		end

		self.OldSpeedScale = stats.speedscale;

		if (WeaponsParams.Falcon.Std[1].promode==nil) then
			stats.speedscale = self.PlayerSlowDown;
		end
		
		-- mp ladder debug, store this wpn id to restore after "buggy" ladder exit in mp. Look also in BasicPlayer.lua
		shooter.cis_my_lastwpn = self.classid * 1;
	end
	self.nextfidgettime = nil;
end
---
function BasicWeapon.Server:OnDeactivate(Params)
	if (Params.shooter) then
		-- Abort any reloading sequence
		local shooter=Params.shooter;
		shooter.cnt.reloading = nil;
		shooter.Ammo[shooter.fireparams.AmmoType]=shooter.cnt.ammo;
		local weaponState = GetPlayerWeaponInfo(shooter);
		if (weaponState) then
			weaponState.AmmoInClip[shooter.firemodenum]=shooter.cnt.ammo_in_clip;
			-- vehicle weapons don't retain any ammo
			if (shooter.fireparams.vehicleWeapon ~= nil) then
				BasicPlayer.EmptyClips(shooter, shooter.cnt.weaponid);
			end
		end
	end
end
---
function BasicWeapon.Client:OnDeactivate(Params)
-- Did we get the owner passed ?
if (type(Params) == "table") and (Params.shooter == _localplayer) then
	-- Hide the weapon
	BasicWeapon.Hide(self, Params.shooter);
	_localplayer.silentstuff1 = nil;
	if (ClientStuff.vlayers:IsActive("WeaponScope")) then
		ClientStuff.vlayers:DeactivateLayer("WeaponScope");
	end
	if (self.ActivateSound and Sound:IsPlaying(self.ActivateSound)) then
		Sound:StopSound( self.ActivateSound );
	end
end
-- kill the muzzleflash
if (Params.shooter) then
if (Params.shooter._MuzzleFlashParams) then
BasicWeapon.ShowMuzzleFlash( self, Params.shooter._MuzzleFlashParams, 0); end
--if (Params.shooter.cnt.firing) then
BasicWeapon.Client.OnStopFiring(Params.shooter.cnt.weapon,Params.shooter);
--end
end
end
---
function BasicWeapon.Server:Drop(Params)
local player=Params.Player;
local ppick;
if not player.cnt.weapon then return end
if GameRules.bSuppressDropWeapon then return end-- some mods may want this behaviour
if GameRules.insta_play then return end -- don't drop gun in rail-only mode
if player.fireparams.food and player.cnt.ammo_in_clip <= 0 then return end
local weapon=player.cnt.weapon;
local cid=Game:GetEntityClassIDByClassName("Pickup"..weapon.name.."_p");
if (not cid) or (Game:IsMultiplayer()) then
	cid=Game:GetEntityClassIDByClassName("Pickup"..weapon.name);
else
	ppick = 1;
end
if(cid)then
local pos = SumVectors(player:GetPos(),{x=0.0,y=0.0,z=1.5});
-- adjust spawn height based on player stance
if (player.cnt.crouching) then
pos = SumVectors(pos, {x=0.0,y=0.0,z=-0.5});
elseif (player.cnt.proning) then
pos = SumVectors(pos, {x=0.0,y=0.0,z=-1.0});
end



local dir = BasicWeapon.temp_v1;
local dest = BasicWeapon.temp_v2;

if (not ppick) then

	CopyVector(dir,player:GetDirectionVector());

	dest.x = pos.x + dir.x * 1.5;
	dest.y = pos.y + dir.y * 1.5;
	dest.z = pos.z + dir.z * 1.5;

	local hits = System:RayWorldIntersection(pos,dest,1,ent_terrain+ent_static+ent_rigid+ent_sleeping_rigid,player.id);

	if (hits and getn(hits)>0) then

	local temp = hits[1].pos;

	dest.x = temp.x - dir.x * 0.15;
	dest.y = temp.y - dir.y * 0.15;
	dest.z = temp.z - dir.z * 0.15;
	end

else
	CopyVector(dir,player:GetDirectionVector());

	dest.x = pos.x + dir.x;
	dest.y = pos.y + dir.y;
	dest.z = pos.z + dir.z;

	local hits = System:RayWorldIntersection(pos,dest,1,ent_terrain+ent_static+ent_rigid+ent_sleeping_rigid,player.id);

	if (hits and getn(hits)>0) then

	-- disable throwing, can hurt self
	player.pp_safedrop = 1;
	local temp = hits[1].pos;
	dest.x = temp.x - dir.x * 0.5;
	dest.y = temp.y - dir.y * 0.5;
	dest.z = temp.z - dir.z * 0.5;
	end
end
-- Create the dropped item
local ed={
classid=cid,
pos=dest,--pos,
}

-- tiny hack to prevent instant picking dropped item back:
player.pp_lastdrop_p = 1;
local DroppedItem = Server:SpawnEntity(ed);

if (not DroppedItem.physpickup) then
	DroppedItem.autodelete=1;
	DroppedItem:EnableSave(1);
	if GameRules.GetPickupFadeTime then
		DroppedItem:SetFadeTime(GameRules:GetPickupFadeTime());
	end
	DroppedItem:GotoState("Dropped");
else
	-- prepare and throw physical pickup
	DroppedItem:SetViewDistRatio(255);
	DroppedItem.pp_lastdrop = _time + 0.8;
	local sdv = new(player:GetDirectionVector());
	local t_ang = new(player:GetAngles());
	if (DroppedItem.throw_z) then
		t_ang.z = t_ang.z + DroppedItem.throw_z;
		DroppedItem:SetAngles(t_ang);
	end
	if (DroppedItem.throw_sound) then
		local t_snd = Sound:LoadSound(DroppedItem.throw_sound);
		if (t_snd) then
			Sound:PlaySound(t_snd);
		end
	end
	DroppedItem:AddImpulse(-1,dest,sdv,41*DroppedItem.Properties.Animation.Speed);
end
player.pp_lastdrop_p = nil;

-- write back current ammo backlog
player.Ammo[player.fireparams.AmmoType]=player.cnt.ammo;
-- update ammo in clips
local wi = GetPlayerWeaponInfo(player);
if (wi) then
if (self.FireParams[2] and self.FireParams[2].AmmoType == self.FireParams[1].AmmoType and player.firemodenum == 2) then
wi.AmmoInClip[1]=player.cnt.ammo_in_clip;
end
wi.AmmoInClip[player.firemodenum]=player.cnt.ammo_in_clip;
end
player.cnt.ammo_in_clip=0;

local am_amount1 = 0;
local am_amount2 = 0;

-- now we store the ammo for each firemode
if (self.FireParams[1]) then
am_amount1 = wi.AmmoInClip[1] * 1;
wi.AmmoInClip[1]=0;
end
if (self.FireParams[2] and self.FireParams[2].AmmoType ~= self.FireParams[1].AmmoType) then
am_amount2 = wi.AmmoInClip[2] * 1;
wi.AmmoInClip[2]=0;
end

if (self.FireParams[3] and self.FireParams[3].AmmoType ~= self.FireParams[2].AmmoType) then
am_amount2 = wi.AmmoInClip[3] * 1;
wi.AmmoInClip[3]=0;
end

if (DroppedItem.physpickup) then
	DroppedItem.Properties.Animation.fAmmo_Primary=am_amount1;
	DroppedItem.Properties.Animation.fAmmo_Secondary=am_amount2;
else
	DroppedItem.Properties.Amount=am_amount1;
	DroppedItem.Properties.Amount2=am_amount2;
end

-- take away the weapon
if (not Params.suppressSwitchWeapon) then

if (player.items.silencer_a) and (player.items.silencer_a == WeaponClassesEx[self.name].id) then
	player.items.silencer_a = 0;
end

if player.fireparams.food == nil then
	player.cnt:MakeWeaponAvailable(self.classid,0);
	if (BasicPlayer.AddPlayerHands) then
		BasicPlayer.AddPlayerHands(player);
	end

	if (player.items) and (player.items.wrenchtool) then
		player.cnt:SetCurrWeapon(27);
	else
		player.cnt:SelectFirstWeapon();
	end
end

end
end
end
---
function BasicWeapon.Server:WeaponReady(shooter)
local stats = shooter.cnt;
if(stats.reloading)then
local fireparams = shooter.fireparams;
-- Finished
stats.reloading = nil;
-- Obtain fire params to get ammo type and clip size
if toNumberOrZero(getglobal("gr_realistic_reload"))==1 then
stats.ammo_in_clip=0;
end
stats.ammo = stats.ammo + stats.ammo_in_clip;
if (stats.ammo >= fireparams.bullets_per_clip) then
-- Got enough ammo left to fill a clip
stats.ammo = stats.ammo - fireparams.bullets_per_clip;
stats.ammo_in_clip = fireparams.bullets_per_clip;
elseif (stats.ammo > 0) then
-- Partially fill the clip
stats.ammo_in_clip = stats.ammo;
stats.ammo = 0;
end
-- ammo has changed, so update Ammo table
shooter.Ammo[fireparams.AmmoType] = stats.ammo;
end
end

function BasicWeapon.Server:Reload(shooter)
	local stats = shooter.cnt;
	if (not stats.reloading) then
		local w = stats.weapon;
		if (shooter.fireparams) and (shooter.fireparams.vehicleWeapon ~= nil) and (stats.ammo_in_clip <= 0) and (stats.ammo > 0) then
			stats.ammo_in_clip = stats.ammo * 1;
			stats.ammo = 0;
		elseif (w) and (stats.ammo > 0) and (stats.ammo_in_clip < shooter.fireparams.bullets_per_clip) then
			shooter.abortGrenadeThrow = 1;
			if (self.anim_table) and (self.anim_table[shooter.firemodenum]) and (self.anim_table[shooter.firemodenum].reload) and (self.anim_table[shooter.firemodenum].reload[1]) then
				stats.weapon_busy = self:GetAnimationLength(self.anim_table[shooter.firemodenum].reload[1]);
			else
				stats.weapon_busy = shooter.fireparams.reload_time;
			end
			stats.reloading=1;
			if (shooter.POTSHOTS) then
				AI:Signal(0,1,"OnReload",shooter.id);
				local anim_name = "reload";
				-- Mixer - anim not only for DE, for all pistols too
				if (shooter.fireparams.type) and (shooter.fireparams.type==2) then
					anim_name = anim_name.."_DE";
				end
				if (stats.crouching) then
					anim_name = "c"..anim_name;
				else
					anim_name = "s"..anim_name;
				end
				local dur = shooter:GetAnimationLength(anim_name);
				if (AI:IsMoving(shooter.id)==1) then 
					--moving reload
					anim_name = anim_name.."_moving";
					dur = shooter:GetAnimationLength(anim_name);
				else
					--stop movement
					AI:EnablePuppetMovement(shooter.id,0,dur);
				end
				shooter:TriggerEvent(AIEVENT_ONBODYSENSOR,dur);
			end
		end
	end
end

function BasicWeapon.Client:Reload(shooter)
	local stats = shooter.cnt;
	if (shooter.fireparams.no_reload) then return; end
	if (not stats.reloading) then
		if (stats.ammo_in_clip < shooter.fireparams.bullets_per_clip) then
			if (stats.ammo > 0) then
				if (shooter == _localplayer and stats.first_person) then
					if (ClientStuff.vlayers:IsActive("WeaponScope") or ClientStuff.vlayers:IsFading("WeaponScope")) then
						ClientStuff.vlayers:DeactivateLayer("WeaponScope",1);
					end

					if (self.anim_table) and (self.anim_table[shooter.firemodenum]) and (self.anim_table[shooter.firemodenum].reload) and (self.anim_table[shooter.firemodenum].reload[1]) then
						stats.weapon_busy = self:GetAnimationLength(self.anim_table[shooter.firemodenum].reload[1]);
					else
						stats.weapon_busy = shooter.fireparams.reload_time;
					end

					shooter.pckanm_do = nil;
					BasicWeapon.RandomAnimation(self,"reload",shooter.firemodenum);
					shooter.playingReloadAnimation = 1;
				end
				-- always play 3rd person animation (because we might see ourself in a mirror)

				--filippo:check if is a mounted weapon, if so dont play player reload anim.
				local CurFireParams;

				if (self.FireParams[1].AmmoType == "Unlimited") then
					CurFireParams = self.FireParams[1];
				else
					CurFireParams = shooter.fireparams;
				end

				if (CurFireParams.vehicleWeapon==1) then
					return;
				end

				local anim_name = "reload";
				-- Mixer - anim not only for DE, for all pistols too
				if (shooter.fireparams.type) and (shooter.fireparams.type==2) then
					anim_name = anim_name.."_DE";
				end

				if (shooter.ai) then
					if (stats.crouching) then
						anim_name = "c"..anim_name;
					else
						anim_name = "s"..anim_name;
					end
					if (AI:IsMoving(shooter.id)==1) then 
						anim_name = anim_name.."_moving";
					end
				else
					anim_name = "s"..anim_name.."_moving";
				end
				shooter:StartAnimation(0,anim_name,4);
			end
		end
	end
end

function BasicWeapon.Client:OnAnimationKey(Params)
	if (Params.userdata) then
		Sound:PlaySound(Params.userdata);
	end
end

-- MIXER: STOP FIRELOOP ALSO IMPROVED
function BasicWeapon:StopFireLoop(shooter, fireparams, sound_data)
local sound=Sound;
if (sound_data) then
	if (sound_data.FireLoopStereo) and (sound:IsPlaying(sound_data.FireLoopStereo)) then
		sound:StopSound(sound_data.FireLoopStereo);
		shooter.cnt:PlaySound(sound_data.TrailOffStereo);
	end
	if (sound_data.FireLoop) and (sound:IsPlaying(sound_data.FireLoop)) then
		sound:StopSound(sound_data.FireLoop);
		shooter.cnt:PlaySound(sound_data.TrailOff);
			if (fireparams) then
			sound:SetSoundVolume(sound_data.TrailOff,fireparams.SoundMinMaxVol[1]);
			sound:SetMinMaxDistance(sound_data.TrailOff,fireparams.SoundMinMaxVol[2],fireparams.SoundMinMaxVol[3]);
			end
	end
end
end

-- This function augments a passed weapon table with the
-- necessary Client and Server callbacks
function CreateBasicWeapon(weapon)
-- add default Server callback tables
if (weapon.Server == nil) then
weapon.Server = {};
end
-- copy over the functions
for i,val in BasicWeapon.Server do
weapon.Server[i] = val;
end

-- add default Client callback tables
if (weapon.Client == nil) then
weapon.Client = {};
end
-- copy over the functions
for i,val in BasicWeapon.Client do
weapon.Client[i] = val;
end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BasicWeapon.Server_EventHandler={
[ScriptEvent_Activate]=BasicWeapon.Server.OnActivate,
[ScriptEvent_Deactivate]=BasicWeapon.Server.OnDeactivate,
[ScriptEvent_DropItem]=BasicWeapon.Server.Drop,
[ScriptEvent_FireModeChange]=BasicWeapon.Server.FireModeChange,
[ScriptEvent_WeaponReady]=BasicWeapon.Server.WeaponReady,
[ScriptEvent_Hit]=BasicWeapon.Server.OnHit,
[ScriptEvent_Fire]=BasicWeapon.Server.OnFire,
[ScriptEvent_FireCancel]=BasicWeapon.Server.OnFireCancel,
[ScriptEvent_Reload]=BasicWeapon.Server.Reload,
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BasicWeapon.Client_EventHandler={
[ScriptEvent_AnimationKey]=BasicWeapon.Client.OnAnimationKey,
[ScriptEvent_Activate]=BasicWeapon.Client.OnActivate,
[ScriptEvent_Deactivate]=BasicWeapon.Client.OnDeactivate,
[ScriptEvent_FireModeChange]=BasicWeapon.Client.FireModeChange,
[ScriptEvent_Hit]=BasicWeapon.Client.OnHit,
[ScriptEvent_Fire]=BasicWeapon.Client.OnFire,
[ScriptEvent_StopFiring]=BasicWeapon.Client.OnStopFiring,
[ScriptEvent_FireCancel]=BasicWeapon.Client.OnFireCancel,
[ScriptEvent_Reload]=BasicWeapon.Client.Reload,
}

function BasicWeapon:RandomAnimation(anim,firemode, blendtime)
	if (blendtime == nil) then blendtime = 0 end
	if(self.anim_table)then
		local at=self.anim_table[firemode]
		if(at)then
			local t=at[anim];
			if(t)then
				self:StartAnimation(0, t[random(1,getn(t))], 0, blendtime);
			end
		end
	end
end

-- crosshair for auto weapons mounted on vehicles
function BasicWeapon:DoAutoCrosshair(scale, bHit)

	local bAvailable = nil;
	if (_localplayer.entity_type == "spectator") then
		if (_localplayer.cnt.GetHost) then
		local ent = System:GetEntity(_localplayer.cnt:GetHost());
		bAvailable = ent.cnt:GetCrosshairState();
		end
	else
	bAvailable = _localplayer.cnt:GetCrosshairState();
	end

	local posX = 400;
	local posY = 300;
	local aimDist = 0.0;
	if (_localplayer.entity_type ~= "spectator") then
		aimDist =self.FireParams[_localplayer.cnt.firemode+1].auto_aiming_dist;
	end
	
	--filippo
	if (bAvailable==nil) then
		
		if (BasicWeapon.cantshoot_sprite) then
			local cantshootradius = 25;
			%System:DrawImageColor(BasicWeapon.cantshoot_sprite, posX-cantshootradius, posY-cantshootradius, cantshootradius*2, cantshootradius*2, 4, 1, 0.25, 0.25, 0.5);
		end
		
		return; 
	end
	
	if( aimDist == 0.0 ) then

		BasicWeapon.Client.OnEnhanceHUD(self, scale, bHit, posX, posY);
		--BasicWeapon.Client:OnEnhanceHUD(bHit, BasicWeapon:CrossHairPos.xS, BasicWeapon:CrossHairPos.yS);		
		return 
	end
	
	local r=1;
	local g=1;
	local b=.25;
	
	if(bHit and bHit>0)then
		r=1;
		g=.25;
		b=.25;
	end
	
	--filippo, if weapon have autoaim_sprite , use it ,if not use the classic square reticule
	local autoaim_sprite = self.FireParams[_localplayer.cnt.firemode+1].autoaim_sprite;
	
	if (autoaim_sprite) then
		%System:DrawImageColor(autoaim_sprite, posX-aimDist, posY-aimDist, aimDist*2, aimDist*2, 4, r, g, b, 1);
	else	
		local x1 = posX - aimDist;
		local y1 = posY - aimDist;
		local x2 = posX + aimDist;
		local y2 = posY + aimDist;
	
		%System:Draw2DLine(x1,y1,x2,y1,r,g,b,1);
		%System:Draw2DLine(x1,y2,x2,y2,r,g,b,1);	
		%System:Draw2DLine(x1,y1,x1,y2,r,g,b,1);	
		%System:Draw2DLine(x2,y1,x2,y2,r,g,b,1);
	end
	
	--filippo, draw the little cross
	local outerradius=7;
	local innerradius=3;
	
	%System:Draw2DLine(posX-innerradius,posY,posX-outerradius,posY,r,g,b,1);
	%System:Draw2DLine(posX+innerradius,posY,posX+outerradius,posY,r,g,b,1);	
	%System:Draw2DLine(posX,posY-innerradius,posX,posY-outerradius,r,g,b,1);	
	%System:Draw2DLine(posX,posY+innerradius,posX,posY+outerradius,r,g,b,1);
end

function BasicWeapon:HandleParticleEffect(effect,pos,dir,firstperson,weaponfx)

local sprite = effect.sprite;

if (sprite==nil) then return; end

local temppos = BasicWeapon.temp_v1;
local tempdir = BasicWeapon.temp_v2;
local tempparticle = BasicWeapon.Particletemp;

local steps = effect.steps;
local stepoffset = effect.stepsoffset;

local randomfactor = 50;
local rnd1 = 1.0;
local rnd2 = 1.0;

local rotation = effect.rotation;

local lastsprite = nil;
local lastsize = nil;

local onesprite = 1;

local extrascale = 1.0;

--if sprite is a table we are using multiple and/or random set of sprites.
if (type(sprite)=="table") then 
onesprite = 0;
else
lastsprite = sprite;
end

if (effect.randomfactor) then
randomfactor = effect.randomfactor;
end

temppos.x = pos.x;
temppos.y = pos.y;
temppos.z = pos.z;

tempdir.x = dir.x;
tempdir.y = dir.y;
tempdir.z = dir.z;

NormalizeVector(tempdir);
-- mixer: Muzzleflash througn scope hack
if (self.bw_mf_for_scope) then
temppos.x = temppos.x + dir.x;
temppos.y = temppos.y + dir.y;
temppos.z = temppos.z + dir.z;
else
--particles in first person are shifted forward for some reasons, so shift the startpos 20 cm back
if (firstperson) then
temppos.x = temppos.x - tempdir.x * 0.2;
temppos.y = temppos.y - tempdir.y * 0.2;
temppos.z = temppos.z - tempdir.z * 0.2;
else
--usually thirdperson effects need to be bigger, so scale them by 1.5
extrascale = 1.5;
end
end
--custom particle color?
if (effect.color) then
tempparticle.start_color = effect.color;
tempparticle.end_color = effect.color;
else
tempparticle.start_color = BasicWeapon.vcolor1;
tempparticle.end_color = BasicWeapon.vcolor1;
end

local wfx=0;

if (weaponfx) then
wfx = weaponfx;
else
 wfx = tonumber(getglobal("cl_weapon_fx"));
end

if (wfx<2) then steps = max(steps / (3-wfx),1); end

tempparticle.focus = effect.focus;
tempparticle.gravity.z = effect.gravity;
tempparticle.AirResistance = effect.AirResistance;

--frametime 0.1 = 10fps
--frametime 0.05 = 20fps
--frametime 0.033 = 30fps
--frametime 0.02 = 50fps
--frametime 0.0166 = 60fps
--as long as particles dont follow very well the fps use lifetimefix to correct life/speed/size;
--the reference is about 60 fps, that means a lifetimefix of 1.0
local lifetimefix = 1.0 - ((_frametime - 0.0166)/(0.1 - 0.0166));
if (lifetimefix < 0.1) then lifetimefix = 0.1; end

for i=0, steps-1 do

--use just 2 random number
if (randomfactor~=0) then
rnd1 = random(100-randomfactor,100+randomfactor)*0.01;
rnd2 = random(100-randomfactor,100+randomfactor)*0.01;
end

--if we are using different sprites, check if we can use a random sprite.
if (onesprite==0) then
if (sprite[i+1]) then
lastsprite = sprite[i+1];

if (type(lastsprite)=="table") then

local spriten = getn(lastsprite);

if (spriten<=0) then return end

lastsprite = lastsprite[random(1,spriten)];
end
end
end

--lastsprite nil? return.
if (lastsprite == nil) then return end

if (effect.size[i+1]) then
	lastsize = effect.size[i+1];
end

tempparticle.speed = effect.speed*rnd1;
tempparticle.size = lastsize*rnd2*extrascale*lifetimefix;
tempparticle.size_speed = effect.size_speed*rnd1*lifetimefix;
tempparticle.lifetime = effect.lifetime*rnd2*lifetimefix;

tempparticle.tid = lastsprite;
tempparticle.rotation.z = random(-rotation*10,rotation*10)*0.1;

Particle:CreateParticle( temppos, tempdir, tempparticle );

--go straight with the position.
temppos.x = temppos.x + tempdir.x * stepoffset * extrascale;
temppos.y = temppos.y + tempdir.y * stepoffset * extrascale;
temppos.z = temppos.z + tempdir.z * stepoffset * extrascale;
end
end

function BasicWeapon:CanFireInThirdPerson(shooter,CurFireParams)
	if (shooter.cnt.underwater > 0 and shooter.ai==nil) or (shooter.cnt:IsSwimming()) then
		if (shooter.fireparams) and (shooter.fireparams.shoot_underwater ~= 1) then
			return nil;
		end
	end
	return 1;
end
