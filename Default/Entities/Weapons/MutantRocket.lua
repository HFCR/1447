-- IMPROVED BY MIXER v1.38c
-- rocket guidance sys.
-- rocket auto aiming system

MutantRocket = {
	type = "Projectile",
	tid_cloud = System:LoadTexture("textures/cloud.jpg"),
	decal_tid = System:LoadTexture("textures/decal/explo_decal.dds"),

	lockTarget = nil,
	
	Param = {
		mass = 1,
		size = 0.15,
		heading = {},
		flags=1,
		initial_velocity = 10,
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = {x=0, y=0, z=0 },
		collider_to_ignore = nil,
	},
	
	ExplosionParams = {
		pos = {},
		damage = 200,
		rmin = 0.8,
		rmax = 3.5, 
		radius = 3.5,--5.5
		shake_factor = 0.20,
		DeafnessRadius = 2.5,
		DeafnessTime = 3.0,
		impulsive_pressure = 950,
		shooter = nil,
		weapon = nil,
		explosion = 1,
		rmin_occlusion=0.2,
		occlusion_res=32,
		occlusion_inflate=2,
	},
	
	SmokeWhite = {
		focus = 9,--90,
		start_color = {1,1,1},
		end_color = {0.3,0.3,0.3},
		speed = 3.0,--0.0,
		count = 1,
		size = 0.05, 
		size_speed=0.7,
		rotation = { x=0,y=0,z=0},
		bLinearSizeSpeed=1,
		lifetime=1.0,
		frames=1,
		tid = System:LoadTexture("textures/clouda.dds"),
		draw_last=1,
		
		turbulence_size = 2,
		turbulence_speed = 2.5,
	},
	SmokeBlack = {
		color_start = {0.6,0.6,0.6},
		color_end = {0.1,0.1,0.1},
		focus = 9,--0,
		speed = 3.0,--0.0,
		count = 1,
		size = 0.1, 
		size_speed=0.9,--0.0,
		rotation = { x=0,y=0,z=0},
		bLinearSizeSpeed=1,
		lifetime=0.5,
		frames=1,
		tid = System:LoadTexture("textures/cloud_black1.dds"),
		
		turbulence_size = 2,
		turbulence_speed = 2.5,
	},
	
	RocketEngineLoop = nil,

	ExplosionTimer = 0,	
	bPhysicalized = nil,
	was_underwater=nil,
	water_normal={x=0,y=0,z=1},

	bStatesRegistered = nil,
	--------------------------------------
	second_explosion_delay=0.5, -- default 0.75
}

function MutantRocket:Server_OnInit()

	if (self.part_time == nil) then
		self:RegisterState("Flying");
		self:RegisterState("Exploding");
		self:RegisterState("Exploding2");
		self:CreateParticlePhys( 2, 10, 0 );
	end

	self:GotoState( "Flying" );
	self:SetPos({x=-1000,y=-1000,z=-1000});

	self.part_time = 0;
	self:EnableUpdate(1);
end

function MutantRocket:Client_OnInit()

	self.RocketEngineLoop = Sound:Load3DSound("Sounds/Weapons/RL/rocketloop3.wav",512);

	if (self.part_time == nil) then
		self:RegisterState("Flying");
		self:RegisterState("Exploding");
		self:RegisterState("Exploding2");
		self:CreateParticlePhys( 2, 10 );
	end
	self.Param.heading = self:GetDirectionVector();
	self:SetPhysicParams(PHYSICPARAM_PARTICLE,self.Param);
	self.part_time = 0;
	self:EnableUpdate(1);
	self:LoadObject( "objects/weapons/Rockets/rocket.cgf",0,0.5);
	self:DrawObject(0,1);
	self:SetViewDistRatio(255);
	
	if (self.RocketEngineLoop) then
	Sound:SetMinMaxDistance(self.RocketEngineLoop, 5, 100000);
	self:PlaySound(self.RocketEngineLoop);
	Sound:SetSoundLoop(self.RocketEngineLoop, 1);	
	end
end

function MutantRocket:RktEngineShutoff()
if (self.RocketEngineLoop) then
if (Sound:IsPlaying(self.RocketEngineLoop)) then
Sound:StopSound(self.RocketEngineLoop); end
self.RocketEngineLoop = nil; end end


function MutantRocket:Server_Flying_OnUpdate(dt)

	local status=GetParticleCollisionStatus(self);
	local pos=self:GetPos();
	
	if (status ~= nil) then
		local material=status.target_material;
		if(IsMaterialUnpierceble(status.target_material))then
			self["status"]=status;
			self:GotoState("Exploding");
		else
				self["status"]=status;
				self:GotoState("Exploding");
		end
	elseif (System:IsValidMapPos(pos) ~= 1) then
		self:GotoState("Exploding");
	end
	
--TRACKING

--MIXER: Player-side/AI side missile guide
if (self.Target) and (self.pl_shooter) and (self.pl_shooter.cnt) then
if (self.go_direct_time) then
	if (self.go_direct_time > _time) then
		return;
	else
		self.go_direct_time = nil;
	end
end
if (self.pl_shooter.cnt.weapon) and (self.ExplosionParams.weapon == self.pl_shooter.cnt.weapon) then
if (self.chasetarget) then
	local pos_aimpos = {};
	if (self.chasetarget.GetCenterOfMassPos) then
		pos_aimpos = new(self.chasetarget:GetCenterOfMassPos());
	else
		pos_aimpos = new(self.chasetarget:GetPos());
	end
	if (pos_aimpos) then
		self:DoHam(pos_aimpos);
		return;
	end
end
if (self.pl_shooter.ai) then
	local pos_aimpos = AI:GetAttentionTargetOf(self.pl_shooter.id);
	if (pos_aimpos) and (type(pos_aimpos) == "table") then
		if (pos_aimpos.GetCenterOfMassPos) then
			pos_aimpos = pos_aimpos:GetCenterOfMassPos();
		else
			pos_aimpos = pos_aimpos:GetPos();
		end
		if (pos_aimpos) then
			self.go_direct_time = _time + 0.15;
			self:DoHam(pos_aimpos);
		end
	end
else
	local pos_aimpos = {};
	local pos_to_aim = self.pl_shooter.cnt:GetViewIntersection();
	if (pos_to_aim) then
		if (pos_to_aim.id) and (self.Param.collider_to_ignore) then
			if (System:GetEntity(pos_to_aim.id) == self.Param.collider_to_ignore) then
				-- nobody wants rocket flying back home :)
				return;
			end
		end
		pos_aimpos.x = pos_to_aim.x;
		pos_aimpos.y = pos_to_aim.y;
		pos_aimpos.z = pos_to_aim.z;
	else
	-- direction vector testing
		pos_to_aim=self.pl_shooter:GetDirectionVector();
		pos_aimpos=self.pl_shooter:GetBonePos('Bip01 Spine');
		pos_aimpos.x = pos_aimpos.x + pos_to_aim.x * 120;
		pos_aimpos.y = pos_aimpos.y + pos_to_aim.y * 120;
		pos_aimpos.z = pos_aimpos.z + pos_to_aim.z * 120;
	end
	self:DoHam(pos_aimpos);
end
end
end
--MIXER: Guide ends

end

function MutantRocket:Client_Flying_OnUpdate(dt)
	local pos = self:GetPos();
	self.part_time = self.part_time + dt*1.0;
	if (self.part_time>0.03) then
		local dir = self:GetDirectionVector(0);
		if (self.SHOOTER) and (self.SHOOTER.Properties) and (self.SHOOTER.Properties.customParticle) then
			if (self.SHOOTER.Properties.customParticle~="none") and (self.SHOOTER.Properties.customParticle~="") then
				Particle:SpawnEffect(pos,dir,self.SHOOTER.Properties.customParticle);
				dir = nil;
			end
		end
		if (dir) then
			self.SmokeWhite.rotation.z = random(-300,300)*0.01;			
			Particle:CreateParticle( pos,dir,self.SmokeWhite );
			if (tonumber(getglobal("sys_spec")) ~= 0) then
				self.SmokeBlack.rotation.z = random(-300,300)*0.01;
				Particle:CreateParticle( pos,dir,self.SmokeBlack );
			end
		end
		self.part_time=0;
	end

	if(Materials["mat_water"] and Materials["mat_water"].projectile_hit)then
		if(self.was_underwater==nil)then
			if(Game:IsPointInWater(pos)) then
				self.was_underwater=1;
				ExecuteMaterial(pos, self.water_normal, Materials.mat_water.projectile_hit, 1 )
			end
		end
	end
	
	-- HACK: Marco, why do I have to call PlaySound all the time, no looping ?
	--	 Alberto, why doesn't self.PlaySound() move the sound and I have to do that manually ?
	if (self.RocketEngineLoop and (Sound:IsPlaying(self.RocketEngineLoop) == nil)) then
		Sound:SetMinMaxDistance(self.RocketEngineLoop, 5, 100000);
		self:PlaySound(self.RocketEngineLoop);
	end
	Sound:SetSoundPosition(self.RocketEngineLoop,pos);

	-- vPos, fRadius, DiffR, DiffG, DiffB, DiffA, SpecR, SpecG, SpecB, SpecA, fLifeTime
	-- Commented out dynamic light for a framerate test - tig
	self:AddDynamicLight(pos, 5, 1, 1, 0.3, 1, 1, 1, 0.3, 1, 0);
end

function MutantRocket:Client_Exploding_OnUpdate(dt)
	self.part_time = self.part_time + dt*2;
	self:SetStatObjScale((_time - self.ExplosionTimer) * 35);
	MutantRocket.RktEngineShutoff(self);
end

function MutantRocket:Launch( weapon, shooter, pos, angles, dir, target )

	-- register with the AI system 
	if (Game:IsMultiplayer()) then
		self.Target = nil;
	else
		self.Target = 1;
	end
	self.pl_shooter = shooter;

	if (self.pl_shooter.crl_lockedtarget) then
		self.chasetarget = System:GetEntity(self.pl_shooter.crl_lockedtarget.id);
		self.pl_shooter.crl_lockedtarget = nil;
	end

	self.Param.initial_velocity = 28;

	if (not shooter.ai) then
	else
		if (shooter.ROCKET_ORIGIN_KEYFRAME) then 
			if (shooter.ROCKET_ORIGIN_KEYFRAME == KEYFRAME_FIRE_LEFTHAND) then 
			pos = shooter:GetBonePos("Bip01 L Hand");
			elseif (shooter.ROCKET_ORIGIN_KEYFRAME == KEYFRAME_FIRE_RIGHTHAND) then 
			pos = shooter:GetBonePos("Bip01 R Hand");
			elseif (shooter.ROCKET_ORIGIN_KEYFRAME == KEYFRAME_FIRE_FIRE_LEFTTOP) then 
			pos = shooter:GetBonePos("RL_left01");
			elseif (shooter.ROCKET_ORIGIN_KEYFRAME == KEYFRAME_FIRE_FIRE_RIGHTTOP) then 
			pos = shooter:GetBonePos("RL_right01");
			end
			if (shooter.Properties.fPersistence) and (shooter.Properties.fPersistence > 1) then
				shooter.Properties.fRocketSpeed = shooter.Properties.fPersistence;
			else
				shooter.Properties.fRocketSpeed = 10;
			end
		end
	end  -- shooter ai or not

	if (shooter.Properties.fRocketSpeed~=nil) then
		self.Param.initial_velocity = shooter.Properties.fRocketSpeed;
	end

	self.SHOOTER = shooter;
	self.Param.collider_to_ignore = shooter;
	self.Param.heading = dir;
	if (target ~= nil) then
	if (shooter.theVehicle) then
	self.ExplosionParams.damage = 450;
	self.Param.collider_to_ignore = shooter.theVehicle; end
	self:SetPos(target); else
	self:SetPos( pos ); end

	if (shooter.Properties.fRocketDamageOverride) then
	if (shooter.Properties.fRocketDamageOverride>0) then
	self.ExplosionParams.damage = shooter.Properties.fRocketDamageOverride;
	end
	end

	self:SetPhysicParams(PHYSICPARAM_PARTICLE,self.Param);
	self:SetAngles( angles );
	self.ExplosionParams.shooterid = shooter.id;
	self.ExplosionParams.shooter = shooter;
	self.ExplosionParams.weapon = weapon;
	
	local serverSlot = Server:GetServerSlotByEntityId(shooter.id);
	if (serverSlot) then
		self.shooterSSID = serverSlot:GetId();
		self.ExplosionParams.shooterSSID = self.shooterSSID;
	elseif (shooter.vbot_ssid) then
		self.shooterSSID = shooter.vbot_ssid;
		self.ExplosionParams.shooterSSID = shooter.vbot_ssid;
	end

	if (shooter.Properties.bDumbRockets~=nil) then
	if (shooter.Properties.bDumbRockets==0) then
	if(self.Target~=nil) then
	self:ResetHam( );
	end

	if (shooter.Properties.bShootSmartRocketsForward==0) then
	dir.x = 0;
	dir.y = 0;
	dir.z = 1;
	end

	else
	self.Target = nil;
	end
	end
end

---
function MutantRocket:Server_OnCollision( hit )
	if ( hit.target ) then
		if ( hit.target == self.ExplosionParams.shooter ) then
			return
		end
	end

	-- First-time explosion effects
	self.ExplosionParams.pos = hit.pos;
	Game:CreateExplosion( self.ExplosionParams );

--	System:DeformTerrain( hit.pos, 5, self.decal_tid );
end

function MutantRocket:Client_OnCollision()

	-- First-time explosion effects

	local pos = self:GetPos();

	self.status=GetParticleCollisionStatus(self);
	local hit=self.status;
	
	
	self.ExplosionParams.pos = pos;
	Game:CreateExplosion( self.ExplosionParams );
	
	-- raduis, r, g, b, lifetime, pos
	CreateEntityLight( self, 7, 1, 1, 0.7, 0.5);
	
	--objtype 2 mean "the terrain"
	if(hit)then
		if (hit.objtype==2) then
--			System:DeformTerrain( pos, 4, self.decal_tid );
		end
	end
	
	MutantRocket.RktEngineShutoff(self);

	self.ExplosionTimer = _time;

	if (hit ~= nil) then
		if (hit.target_material ~= nil) then
			if(Game:IsPointInWater(hit.pos))then
				local h=Game:GetWaterHeight()-hit.pos.z;
				if(h>2)then
					do return end
				end
			end
			ExecuteMaterial(hit.pos,hit.normal,hit.target_material.projectile_hit, 1 );
		else
			System:LogToConsole("hit.target_material is nil");
		end
	else
		ExecuteMaterial(pos,normal,Materials.mat_default.projectile_hit,1);
		System:LogToConsole("hit is nil");
	end

	Game:SoundEvent(pos, 200, 1, 0);	
end

MutantRocket.Server = {
	OnInit = MutantRocket.Server_OnInit,
	OnCollision = MutantRocket.Server_OnCollision,
	Flying = {
		OnBeginState = function(self)
			--after 16 sec the rocket will explode in any case
			self:SetTimer(16000);
		end,
		OnTimer = function(self)
			self:GotoState("Exploding");
		end,
		OnUpdate = MutantRocket.Server_Flying_OnUpdate,
	},
	Exploding = {
		OnBeginState = function(self)
			self:SetTimer(1); --delay the explosion to the next update thi help the multiplayer
		end,
		OnUpdate =MutantRocket.Server_Flying_OnUpdate,
		OnTimer = function(self)
			self:GotoState("Exploding2");
		end
	},
	Exploding2 = {
		OnBeginState = function(self)
			self:SetTimer(3000); --delay the explosion to the next update thi help the multiplayer
			self.ExplosionParams.pos = self:GetPos();
			Game:CreateExplosion( self.ExplosionParams );
		end,
		OnTimer = function(self)
			Server:RemoveEntity(self.id);
		end
	}
}

MutantRocket.Client = {
	OnInit = MutantRocket.Client_OnInit,
	OnCollision = MutantRocket.Client_OnCollision,
	Flying = {
		
		OnUpdate = MutantRocket.Client_Flying_OnUpdate,
	},
	Exploding = {
		OnBeginState=function(self)
			self:DrawObject(0,0);
			self.hit=GetParticleCollisionStatus(self);
			self:AddDynamicLight(self:GetPos(), 8, 1, 1, 0.7, 1, 1, 1, 0.3, 1, 0);
		end
	},
	Exploding2 = {
		OnBeginState = function(self)
			local hit=self.hit;
			local normal;
			local pos;
			if(not hit)then
				pos=self:GetPos();
				normal={x=0,y=0,z=1};
			else
				normal=hit.normal;
				pos=hit.pos;
			end
			
			Game:SoundEvent(pos, 200, 1, 0);
			
			self:DrawObject(0,0);
			--no explosion if is in deep water
			if(Game:IsPointInWater(pos))then
				local h=Game:GetWaterHeight()-pos.z;
				if(h>2)then
					do return end
				end
			end
			if(hit)then
				if (hit.objtype==2) then
--					System:DeformTerrain( pos, 4, self.decal_tid );
				end
			end
	
			if(hit)then
				ExecuteMaterial(hit.pos,hit.normal,hit.target_material.projectile_hit, 1 );
			else
				ExecuteMaterial(pos,normal,Materials.mat_concrete.projectile_hit,1);
			end
			MutantRocket.RktEngineShutoff(self);
		end,
	}
}