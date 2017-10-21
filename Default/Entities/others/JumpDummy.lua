

JumpDummy = {
	type = "Projectile",
	lockTarget = nil,
	bPhysicalized = nil,
	was_underwater=nil,
	water_normal={x=0,y=0,z=1},
	bStatesRegistered = nil,
}

function JumpDummy:Server_OnInit()

	if (self.part_time == nil) then
		self:RegisterState("Flying");
		self:CreateParticlePhys( 2, 10, 0 );
	end

	self:GotoState( "Flying" );
	self:SetPos({x=-1000,y=-1000,z=-1000});

	self.part_time = 0;
	self:EnableUpdate(1);
end

function JumpDummy:Client_OnInit()

	if (self.part_time == nil) then
		self:RegisterState("Flying");
		self:CreateParticlePhys( 2, 10 );
	end

	--self:SetPhysicParams(PHYSICPARAM_PARTICLE,self.Param);
	self.part_time = 0;
	self:EnableUpdate(1);
	self:LoadObject( "Objects/Editor/Arrow.cgf",0,0.5);

end

function JumpDummy:Server_Flying_OnUpdate(dt)

	local status=GetParticleCollisionStatus(self);
	local pos=new(self:GetPos());

	--System:Warning("x="..pos.x.." y="..pos.y.." z="..pos.z);
	if (self.Param) and (self.Param.collider_to_ignore) and (self.Param.collider_to_ignore.cnt) then
		self.Param.collider_to_ignore:SetPos(pos);
	end

	if (status ~= nil) then
		local material=status.target_material;
		self["status"]=status;
		self:SetTimer(1);
	elseif (System:IsValidMapPos(pos) ~= 1) then
		self:SetTimer(1);
	end
end

function JumpDummy:OnRemoteEffect(toktable, pos, normal, userbyte)
	if (not Game:IsServer()) then
		self.j_flyer = System:GetEntity(pos.x);
		if (_localplayer) and (self.j_flyer) and (self.j_flyer == _localplayer) then
			self.j_flyer:EnablePhysics(0);
		end
	end
end

function JumpDummy:Client_Flying_OnUpdate(dt)
	if (self.j_flyer) then
		if (BasicPlayer.IsAlive(self.j_flyer)) then
			local pos=new(self:GetPos());
			self.j_flyer:SetPos(pos);
		else
			self.j_flyer = nil;
		end
	end
end

function JumpDummy:Launch(weapon, shooter, pos, angles, dir, target)

	-- register with the AI system
	self.Param = {
		mass = shooter.PhysParams.mass * 1,
		size = 0.15,
		heading = dir,
		flags=1,
		initial_velocity = 30,
		k_air_resistance = 0.5,
		acc_thrust = weapon,
		acc_lift = 0,
		surface_idx = -1,
		gravity = {x=0, y=0, z=angles.z },
		collider_to_ignore = shooter,
	};

	if (target ~= nil) then
		self:DrawObject(0,1);
		self:SetViewDistRatio(255);
	end
	self:SetPos( pos );

	self:SetPhysicParams(PHYSICPARAM_PARTICLE,self.Param);
	Server:BroadcastCommand("FX", {x=shooter.id,y=0,z=0}, {x=0,y=0,z=0}, self.id, 1);

	--self:Bind(self.jumper);
	self.flytime = 0;

end

---
function JumpDummy:Server_OnCollision( hit )
end

JumpDummy.Server = {
	OnInit = JumpDummy.Server_OnInit,
	OnCollision = JumpDummy.Server_OnCollision,
	Flying = {
		OnBeginState = function(self)
		end,
		OnTimer = function(self)
			Server:RemoveEntity(self.id);
		end,
		OnUpdate = JumpDummy.Server_Flying_OnUpdate,
	},
}

JumpDummy.Client = {
	OnInit = JumpDummy.Client_OnInit,
	OnCollision = JumpDummy.Client_OnCollision,
	Flying = {
		OnUpdate = JumpDummy.Client_Flying_OnUpdate,
	},
	OnShutDown =function(self)
		if (self.j_flyer) and (_localplayer) and (self.j_flyer == _localplayer) then
			self.j_flyer:EnablePhysics(1);
			self.j_flyer = nil;
		end
	end,
}