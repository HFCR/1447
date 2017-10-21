-- Hands v2.0 by Garcy and Mixer (Soccer Gametype, Developer's hands)

local mdl_char = "Objects/Weapons/hands2/hands.cgf";

if (Mission) then
	if (Mission.offset_testgun) then 
		mdl_char = Mission.offset_testgun;
	end
end

Hands = {
	name		= "Hands",
	object	= "Objects/Editor/invisiblebox.cgf",
	character	= mdl_char,
	PlayerSlowDown = 1.0,	
	NoZoom=1,
	noputdown=1,
	hit_delay=0.1,
	TargetHelperImage = System:LoadImage("Textures/Hud/crosshair/pistol.dds"),
	-- describes all sup. firemodes
	FireParams ={
	{
		AmmoType="Unlimited",
		type=3,
		accuracy=1,
		reload_time=0.01,
		fire_rate=0.2,
		distance=1.2,
		damage=20,
		animatedrun=1,
		bullet_per_shot=1,
		bullets_per_clip=20,
		FModeActivationTime = 0.3,
		iImpactForceMul = 80,
		iImpactForceMulFinal = 80,
		shoot_underwater = 1,
		weapon_viewshake = 8, -- 0.6
		weapon_viewshake_amt = 0.02,
		weapon_shaketime = 0.5,
		fire_activation=bor(FireActivation_OnPress),
		FireSounds = {
		"Sounds/player/playermovement/stancechange4.wav", -- todo
		},
		no_ammo=1,
		SoundMinMaxVol = { 255, 5, 20 },
	},
	},
	SoundEvents={
		{	"throw11", 2, Sound:LoadSound("Sounds/Weapons/melee/swish.wav",0,254)},
	}, 
}

CreateBasicWeapon(Hands);

--ANIMTABLE
--SINGLE FIRE
Hands.anim_table={}
Hands.anim_table[1]={
	idle={
		"idle11",
	},
	fire={
		"leftjab",
		"rightjab",
		"uppercut",
	},
		run={
		"run1",
	},

	swim={
		"swim",
	},
	activate={
		"activate1",
	},
}
-- Melee Improvement
function Hands.Client:OnHit(hit)
	hit.is_punch = 1;
	if (not self.cl_cold_wpn_contact) then
		self.cl_cold_wpn_contact = _time+self.hit_delay;
		self.cl_hitparams = hit;
	end
	if (Game:IsServer()==nil) and (hit.shooter.handStrength) then
		hit.impact_force_mul = hit.impact_force_mul*hit.shooter.handStrength;
		hit.impact_force_mul_final = hit.impact_force_mul_final*hit.shooter.handStrength;
		hit.impact_force_mul_final_torso = hit.impact_force_mul+hit.impact_force_mul_final;
		hit.damage = hit.damage*(hit.shooter.handStrength*0.25);
	end
end

function Hands.Server:OnHit(hit)
	hit.is_punch = 1;
	BasicWeapon.Server.OnHit(self,hit);
	if (hit.shooter.handStrength) then
		hit.impact_force_mul = hit.impact_force_mul*hit.shooter.handStrength;
		hit.impact_force_mul_final = hit.impact_force_mul_final*hit.shooter.handStrength;
		hit.impact_force_mul_final_torso = hit.impact_force_mul+hit.impact_force_mul_final;
		hit.damage = hit.damage*(hit.shooter.handStrength*0.25);
	end
end


function Hands.Client:OnEnhanceHUD(scale, bHit)
	if (Mission) and (Mission.offset_test) then
		System:DrawImageColor(self.TargetHelperImage, 385, 285, 30, 30, 4, 0.6,1,0.6,0.8);	
		BasicWeapon.Client.OnEnhanceHUD(self);
	else
		BasicWeapon.Client.OnEnhanceHUD(self, scale, bHit, 400, 300);
	end
end


function Hands.Client:OnUpdate(delta,shooter)
	BasicWeapon.Client.OnUpdate(self,delta,shooter);
	if (shooter.cnt.first_person) then
		if (Mission) and (Mission.soccer_center) then
			if (Mission.offset_test) then
				self.cnt:SetFirstPersonWeaponPos(Mission.offset_test, g_Vectors.v000);
			end
			if (self.cl_hitparams) and (self.cl_hitparams.target) and (self.cl_hitparams.target.type == "Player") then
				self.cl_hitparams = nil;
			end
		elseif (shooter.theVehicle) and (shooter.theVehicle.driverT) and (shooter.theVehicle.driverT.entity) and (shooter.theVehicle.driverT.entity==shooter) then
			shooter.cnt.drawfpweapon=nil;
		else
			if (shooter.cnt.underwater > 0 and shooter.ai==nil) or (shooter.cnt:IsSwimming()) then
				self.cnt:SetFirstPersonWeaponPos({x=0,y=0,z=0}, {x=0,y=0,z=0});
			else
				local pang = _localplayer:GetAngles();
				if pang.x > 100 then
					pang.x = (360 - pang.x) * -1;
				end
				self.cnt:SetFirstPersonWeaponPos({x=0,y=0,z=-0.09+pang.x*0.001}, {x=0,y=0,z=0});
			end
		end
		if (shooter.thrw_some_m) then
			shooter.thrw_some_m = nil;
			self:StartAnimation(0,"throw11",0,0);
		end
	end
	if (self.cl_cold_wpn_contact) and (self.cl_cold_wpn_contact < _time) then
		self.cl_cold_wpn_contact=nil;
		if (self.cl_hitparams) then
			BasicWeapon.Client.OnHit(self,self.cl_hitparams);
		end
	end
end

function Hands.Server:OnUpdate(delta, shooter)
	if (GameRules.soccerball) and (GameRules.sb_pos) then
		if (not GameRules.special_position) then
			local soccerpos = shooter:GetDistanceFromPoint(GameRules.sb_pos);
			if (soccerpos < 0.8) then
				local sdv = shooter:GetDirectionVector();
				sdv.z = 0;
				GameRules:RegisterSupport(shooter);
				GameRules.last_toucher_id = shooter.id * 1;
				GameRules.soccerball:AddImpulse(-1,{x=GameRules.sb_pos.x,y=GameRules.sb_pos.y,z=GameRules.sb_pos.z-0.04},sdv,14);
				return 1;
			end
		end
	else
		return BasicWeapon.Server.OnUpdate(self,delta, shooter);
	end
end

function Hands.Server:OnFire( params )
if (Mission) and (Mission.soccer_center) then
	if (GameRules.soccerball) and (GameRules.sb_pos) then
		if (not GameRules.special_position) then
			local soccerpos = params.shooter:GetDistanceFromPoint(GameRules.sb_pos);
			if (soccerpos < 1.53) then
				GameRules:RegisterSupport(params.shooter);
				GameRules.last_toucher_id = params.shooter.id * 1;
				GameRules.soccerball:AddImpulse(-1,{x=GameRules.sb_pos.x,y=GameRules.sb_pos.y,z=GameRules.sb_pos.z-0.04},params.shooter:GetDirectionVector(),1350*0.2);
				return nil;
			end
		end
	elseif (not Game:IsMultiplayer()) then
		local sb_edit = System:GetEntityByName('Soccer_Ball_1');
		if (sb_edit) then
			local sb_pos = new(sb_edit:GetPos());
			sb_pos = params.shooter:GetDistanceFromPoint(sb_pos);
			if (sb_pos < 1.53) then
				sb_pos = new(sb_edit:GetPos());
				sb_pos.z = sb_pos.z - 0.04;
				sb_edit:AddImpulse(-1,sb_pos,params.shooter:GetDirectionVector(),1350*0.2);
				return nil;
			end
		end
	end
else
	return BasicWeapon.Server.OnFire( self,params );
end
end

function Hands.Client:OnActivate(Params)
	BasicWeapon.Client.OnActivate(self,Params);
	if (Params.shooter.cnt.first_person) and (Mission) and (Mission.soccer_center) then
		self:LoadObject("Objects/weapons/machete_mod/machete.cgf",2,1);
		self.cap_stuff1 = self:AttachObjectToBone( 2,"Bone04",1 );
	end
end

function Hands.Client:OnFire(params)
if (BasicWeapon.Client.OnFire(self,params)) then
	if (params.shooter.cnt.first_person) then
		local currenthit = random(1,2);
		local pshooter = params.shooter.cnt.weapon;
		local pang = params.shooter:GetAngles();
		if (Mission) and (Mission.soccer_center) then
			pshooter:StartAnimation(0,"Kick11",0,0);
		elseif (pang.x > 90) and (pang.x < 318) then
			pshooter:StartAnimation(0,"Fire21",0,0);
		else
			pshooter:StartAnimation(0,"Fire1"..currenthit,0,0);
		end
	elseif (Mission) and (Mission.soccer_center) then
		if (params.shooter) then
			params.shooter.stop_my_talk = _time + 0.2;
			params.shooter:StartAnimation(0,"asprintback",4);
			return 1;
		end
	end
	return 1;
end
end

function Hands:ZoomAsAltFcl(shtr) -- spare stuff for throwing machete anim
	if (shtr.cnt) and (shtr.cnt.first_person) then
		shtr.thrw_some_m = 1;
	elseif (_localplayer) and (shtr~=_localplayer) then
		shtr.stop_my_talk = _time + 0.3;
		shtr:StartAnimation(0,"aidle_umshoot",4);
	end
end

-- MELEE PATCHES
if (Materials) then
	if (Materials["mat_plastic"]) then
	Materials["mat_plastic"].melee_punch = {
			sounds = {
				{"Sounds/Bullethits/bleaves4.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			},
		};
	end
	if (Materials["mat_plastic_nd"]) then
	Materials["mat_plastic_nd"].melee_punch = {
			sounds = {
				{"Sounds/Bullethits/bleaves4.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			},
		};
	end
	if (Materials["mat_plastic_p"]) then
	Materials["mat_plastic_p"].melee_punch = {
			sounds = {
				{"Sounds/Bullethits/bleaves4.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			},
		};
	end
	if (Materials["mat_sandbag"]) then
	Materials["mat_sandbag"].melee_punch = {
			sounds = {
				{"Sounds/Bullethits/bsand4.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			},
		};
	end
end