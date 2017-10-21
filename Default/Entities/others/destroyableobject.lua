-- Super-optimized by Mixer (v3.0 mp compatible/fixed completely physicable now)
Script:ReloadScript( "Scripts/Default/Entities/Others/BasicEntity.lua" );

DestroyableObject={
	Properties = {
		object_Model="Objects/Indoor/boxes/crates/barrel1.cgf",
		object_ModelDestroyed="",
		nDamage=100,
		nExplosionRadius=5,
		bExplosion=1,
		ExplosionTable="explosions.rocket_indoors.a",
		bTriggeredOnlyByExplosion=0,
		impulsivePressure=2000, -- physics params
		rmin = 2.0, -- physics params
		rmax = 20.5, -- physics params
		timer=-1,
		bPlayerOnly = 0,
		bHidden=0,
		bAllowMeleeDamage=1,
		damage_players = 0, -- Damage from physical collision.
		
		AliveSoundLoop={
			sndFilename="",
			InnerRadius=1,
			OuterRadius=10,
			nVolume=255,
		},
		DeadSoundLoop={
			sndFilename="",
			InnerRadius=1,
			OuterRadius=10,
			nVolume=255,
		},
		DyingSound={
			sndFilename="",
			InnerRadius=1,
			OuterRadius=10,
			nVolume=255,
		},

		AISoundEvent = {
			bGenerateAISoundEvent = 1,
			fRadius = 30,
		},

		nPlayerDamage=100,
		nPlayerDamageRadius=3,
		Physics = {
			bRigidBody=0, -- True if rigid body.
			bRigidBodyAfterDeath=1, -- True if same rigid body after death too.
			bRigidBodyActive = 1, -- If rigid body is originally created (1) OR will be created only on OnActivate (0).
			bActivateOnDamage = 0, -- Activate when a rocket hit the entity.
			bResting = 0, -- If rigid body is originally in resting state.
			Density = -1,
			Mass = 100,
			vector_Impulse = {x=0,y=0,z=0}, -- Impulse to apply at event.
			max_time_step = 0.01,
			sleep_speed = 0.04,
			damping = 0,
			water_damping = 0,
			water_resistance = 1000,	
			water_density = 1000,
			Type="",
			bFixedDamping = 0,
			HitDamageScale = 0,
		},

	},
	--PHYSICS PARAMS
	explosion_params = {
		pos = nil,
		damage = 100,
		rmin = 2.0,
		rmax = 20.5,
		radius = 3,
		impulsive_pressure = 2000,
		shooter = nil,
		weapon=nil,
	},

	bNeedsReloadInEditor=0,	
	CurrModel = "",
	CurrDestroyedModel = "",

	-- Reassign physics related methods to basic entity.

	StopLastPhysicsSounds = BasicEntity.StopLastPhysicsSounds,
	OnStopRollSlideContact = BasicEntity.OnStopRollSlideContact,
}

function DestroyableObject:OnInit()
	self.hitPos = {x=0,y=0,z=0};
	self:EnableUpdate(0);
	self:RegisterState("Active");
	self:RegisterState("Dead");
	----
	if (self.Properties.Physics.bRigidBody == 1) then
		self:NetPresent(1);
		if (Game:IsMultiplayer()) then
			self.Properties.Physics.bResting = 0;
			if (Game:IsServer()) then
				self.MpRigidBody = 1;
				if (not self.PhoenixData) then
					self.PhoenixData = {};
					self.PhoenixData.pos = new(self:GetPos());
					self.PhoenixData.pos.z = self.PhoenixData.pos.z + 0.07;
					self.PhoenixData.angles = new(self:GetAngles());
					self.PhoenixData.ready = 1;
				elseif (not self.PhoenixData.ready) then
					self.PhoenixData.pos.z = self.PhoenixData.pos.z + 0.07;
					self.PhoenixData.ready = 1;
				end
			end
		end
	else
		self:NetPresent(nil);
	end
	----
	self:OnReset();
end

function DestroyableObject:OnPropertyChange()
	self:OnReset();
end

function DestroyableObject:OnShutDown()

end

function DestroyableObject:Event_Reset( sender )
	self:OnReset();
end

function DestroyableObject:Event_UnHide( sender )
	self:CreateStaticEntity( 10,-1,0 );
	self:DrawObject(0,1);
end

function DestroyableObject:Event_Explode( sender )

	if self:GetState()=="Dead" then return end

	if (self.Delay > 0) then
		self:SetTimer(self.Delay*1000);
		self.Delay = -1;
		do return end
	end

	self:Explode();
	BroadcastEvent( self,"Explode" );
end

function DestroyableObject:Explode()
	if(self.explosion) then
		self.explosion_params.pos = self:GetPos();
	end

	if (self.Properties.AISoundEvent.bGenerateAISoundEvent == 1) then
		if (self.shooter_detroyer == nil) and (_localplayer) then
			self.shooter_detroyer = _localplayer;
		end
		if (self.shooter_detroyer) then
			AI:SoundEvent(self.id,self:GetPos(),self.Properties.AISoundEvent.fRadius, 0, 1, self.shooter_detroyer.id);
		end
	end

	self:GoDead();
	
	if (self.explosion) then
		self.explosion_params.damage=self.Properties.nPlayerDamage;
		self.explosion_params.radius=self.Properties.nPlayerDamageRadius;
		self.explosion_params.impulsive_pressure=self.Properties.impulsivePressure;		
		self.explosion_params.rmin=self.Properties.rmin;
		self.explosion_params.rmax=self.Properties.rmax;
		Game:CreateExplosion(self.explosion_params);
	end
end

function DestroyableObject:OnReset()
	if self:GetState()=="Active" then
		self.bRigidBodyActive = self.Properties.Physics.bRigidBodyActive;
		self:SetPhysicsProperties(0);
	else
		self:GoAlive();
	end
	if (self.Properties.Physics.bRigidBody == 1) then
		self:NetPresent(1);
		if (self.MpRigidBody) and (GameRules) then
			if (GameRules.mapstart) and (GameRules.mapstart == _time) then
				Server:BroadcastCommand("FX",{x=self.PhoenixData.pos.x, y=self.PhoenixData.pos.y, z=self.PhoenixData.pos.z-0.07},self.PhoenixData.angles,self.id,2);
			end
		end
	end
end

function DestroyableObject:Event_Collision()
end

---------------------------------------------------
function DestroyableObject:StopLastPhysicsSounds()
	self:OnStopRollSlideContact("roll");
	self:OnStopRollSlideContact("slide");
end

-----------------------------------------------------
function DestroyableObject:OnStopRollSlideContact(ContactType)
	if (self.LastPhysicsSounds) then
		if (ContactType=="roll") then 
			Sound:StopSound(self.LastPhysicsSounds.Roll);
		end
		if (ContactType=="slide") then
			Sound:StopSound(self.LastPhysicsSounds.Slide);
		end
	end
end

function DestroyableObject:GoAlive()
	self:GotoState( "Active" );
end

function DestroyableObject:GoDead()
	self:GotoState( "Dead" );
	Server:BroadcastCommand("FX",{x=0,y=0,z=0},{x=0,y=0,z=0},self.id,1);
end

-- Set Physics parameters.

function DestroyableObject:SetPhysicsProperties( nObjectSlot )
	if (self.Properties.Physics.bRigidBody ~= 1) then
		return;
	end
	
	self:SetUpdateType( eUT_Physics );

 	local Mass    = self.Properties.Physics.Mass; 
 	local Density = self.Properties.Physics.Density;

	-- Make Rigid body.
	self:CreateRigidBody( Density,Mass,-1,g_Vectors.v000,nObjectSlot ); -- Density,Mass,surfaceId,InitialVelocity,Slot
	
	if (self.bCharacter == 1) then
		self:PhysicalizeCharacter( Mass,0,0,0);
	end

		local SimParams = {
			max_time_step = self.Properties.Physics.max_time_step,
			sleep_speed = self.Properties.Physics.sleep_speed,
			damping = self.Properties.Physics.damping,
			water_damping = self.Properties.Physics.water_damping,
			water_resistance = self.Properties.Physics.water_resistance,
			water_density = self.Properties.Physics.water_density,
			mass = Mass,
			density = Density,
		};

		if (self.bRigidBodyActive ~= 1) then
			-- If rigid body should not be activated, it must have 0 mass.
			SimParams.mass = 0;
			SimParams.density = 0;
		end

		local Flags = { flags_mask=pef_fixed_damping, flags=0 };
		if (self.Properties.Physics.bFixedDamping~=0) then
			Flags.flags = pef_fixed_damping;
		end
		
		self:SetPhysicParams(PHYSICPARAM_SIMULATION, SimParams );
		self:SetPhysicParams(PHYSICPARAM_BUOYANCY, self.Properties.Physics );
		self:SetPhysicParams(PHYSICPARAM_FLAGS, Flags );
		
		if (self.Properties.Physics.bResting == 0) then
			self:EnableUpdate(1);
			self:AwakePhysics(1);
		else
			self:EnableUpdate(0);
			self:AwakePhysics(0);
		end
		
	
	-- physics-sounds
	if (PhysicsSoundsTable) then
		local SoundDesc;
		-- load soft contact sounds
		self.ContactSounds_Soft={};
		if (PhysicsSoundsTable.Soft and PhysicsSoundsTable.Soft[self.Properties.Physics.Type]) then
			SoundDesc=PhysicsSoundsTable.Soft[self.Properties.Physics.Type].Impact;
			if (SoundDesc) then
				self.ContactSounds_Soft.Impact=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5]);
				self.ContactSounds_Soft.ImpactVolume=SoundDesc[3];
			end
			SoundDesc=PhysicsSoundsTable.Soft[self.Properties.Physics.Type].Roll;
			if (SoundDesc) then
				self.ContactSounds_Soft.Roll=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5]);
				self.ContactSounds_Soft.RollVolume=SoundDesc[3];
			end
			SoundDesc=PhysicsSoundsTable.Soft[self.Properties.Physics.Type].Slide;
			if (SoundDesc) then
				self.ContactSounds_Soft.Slide=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5]);
				self.ContactSounds_Soft.SlideVolume=SoundDesc[3];
			end
		else
			--System:Log("[BasicEntity] Warning: Table *PhysicsSoundsTable.Soft* or *PhysicsSoundsTable.Soft["..self.Properties.Physics.Type.."]* no found !");
		end
		-- load hard contact sounds
		self.ContactSounds_Hard={};
		if (PhysicsSoundsTable.Hard and PhysicsSoundsTable.Hard[self.Properties.Physics.Type]) then
			SoundDesc=PhysicsSoundsTable.Hard[self.Properties.Physics.Type].Impact;
			if (SoundDesc) then
				self.ContactSounds_Hard.Impact=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5]);
				self.ContactSounds_Hard.ImpactVolume=SoundDesc[3];
			end
			SoundDesc=PhysicsSoundsTable.Hard[self.Properties.Physics.Type].Roll;
			if (SoundDesc) then
				self.ContactSounds_Hard.Roll=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5]);
				self.ContactSounds_Hard.RollVolume=SoundDesc[3];
			end
			SoundDesc=PhysicsSoundsTable.Hard[self.Properties.Physics.Type].Slide;
			if (SoundDesc) then
				self.ContactSounds_Hard.Slide=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5]);
				self.ContactSounds_Hard.SlideVolume=SoundDesc[3];
			end
		end
	end
end

function DestroyableObject:OnDamage(hit)
	if (self.bDead == 1) then return end;
	
	self:AwakePhysics(1);

	local shooter = hit.shooter;

	if (self.Properties.bPlayerOnly == 1) then
		-- Mixer: FIXED/IMPROVED: even player projectiles can trigger this without error now!
		if (shooter==nil and hit.shooterSSID==nil) or (shooter and shooter.ai) then
			do return end;
		end
	end

	-- [marco] if told so, don't allow melee weapons to damage the destroyable object
	-- Mixer: optimized
	if (self.Properties.bAllowMeleeDamage==0) then
		if (shooter and shooter.fireparams and (shooter.fireparams.fire_mode_type == FireMode_Melee)) then
			do return end;
		end
	end

	if (self.Properties.bTriggeredOnlyByExplosion==1) and (not hit.explosion) then
		return
	end;
	
	if (hit.pos) then
		self.LastHitPos = hit.pos; -- Mixer: to know hit pos to be able to do something with through Mission script
	end
	
	self:Event_OnDamage();
			
	self.curr_damage=self.curr_damage-hit.damage;
		
	if (self.curr_damage<=0) and (Game:IsServer()) then
		self.bDead = 1;
		if (hit.shooter) and (hit.shooter.cnt) and (hit.shooter.cnt.weapon) and (hit.shooter.cnt.weapon.hit_delay) then
			self:SetTimer(hit.shooter.cnt.weapon.hit_delay*1000);
		else
			self:SetTimer(1);
		end
		self.hitPos.x = hit.pos.x;
		self.hitPos.y = hit.pos.y;
		self.hitPos.z = hit.pos.z;
		
		self.explosion_params.shooterSSID = nil;
		
		if (hit.shooterSSID) then
			local ssshtr=Server:GetServerSlotBySSId(hit.shooterSSID);
			if (ssshtr) then
				self.shooter_detroyer = System:GetEntity(ssshtr:GetPlayerId());
			end
			self.explosion_params.shooterSSID = hit.shooterSSID * 1;
		elseif (hit.shooter) and (hit.shooter.id) then
			self.shooter_detroyer = hit.shooter;
			local slot=Server:GetServerSlotByEntityId(hit.shooter.id);
			if (slot) then
				self.explosion_params.shooterSSID = slot:GetId();
			end
		end
	end
	if( hit.ipart and hit.ipart>=0 ) then
		self:AddImpulse( hit.ipart, hit.pos, hit.dir, hit.impact_force_mul );
	end
end;

DestroyableObject.Active={
	OnBeginState=function(self)
		self.Delay = self.Properties.timer * 1;
		self.bDead = 0;
		self:StopLastPhysicsSounds();
		
		if (self.bNeedsReloadInEditor==1) then
			-- [marco] in editor mode, if the object exploded, we might have
			-- physicalized a different object, must be reset back now
			self:DestroyPhysics();
		end
		
		if (self.Properties.object_Model ~= self.CurrModel) or (self.bNeedsReloadInEditor==1) then
			self.CurrModel = self.Properties.object_Model;
			if (self.Properties.object_Model ~= "") then
				self:LoadObject(self.Properties.object_Model,0,1);
			end
		end

		self.bNeedsReloadInEditor=0;

		if ((self.Properties.object_ModelDestroyed ~="") and (self.Properties.object_ModelDestroyed ~= self.CurrDestroyedModel)) then
			self.CurrDestroyedModel = self.Properties.object_ModelDestroyed;
			self:LoadObject(self.Properties.object_ModelDestroyed,1,1);
		end

		self.explosion_params.impulsive_pressure=self.Properties.impulsivePressure;	
		self.curr_damage=self.Properties.nDamage;
		self.explosion_params.radius=self.Properties.nExplosionRadius;
		self.explosion_params.rmin=self.Properties.rmin;
		self.explosion_params.rmax=self.Properties.rmax;

		if (self.Properties.bExplosion==1) then
			self.explosion=1;
		end
		
		if (self.Properties.bHidden~=1) then
			self:CreateStaticEntity( 10,-1,0 );
		end
	
		-- Set physics.
		self.bRigidBodyActive = self.Properties.Physics.bRigidBodyActive;
		
		self:SetPhysicsProperties(0);

		if (Game:IsClient()) then
			-- stop old sounds
			if (self.DyingSoundLoop and Sound:IsPlaying(self.DyingSound)) then
				Sound:StopSound(self.DyingSound);
			end
			if (self.DeadSoundLoop and Sound:IsPlaying(self.DeadSoundLoop)) then
				Sound:StopSound(self.DeadSoundLoop);
			end
			if (self.AliveSoundLoop and Sound:IsPlaying(self.AliveSoundLoop)) then
				Sound:StopSound(self.AliveSoundLoop);
			end
			-- load sounds
			local SndTbl;
			SndTbl=self.Properties.AliveSoundLoop;
			if (SndTbl.sndFilename~="") then
				self.AliveSoundLoop=Sound:Load3DSound(SndTbl.sndFilename, 0);
				if (self.AliveSoundLoop) then
					Sound:SetSoundPosition(self.AliveSoundLoop, self:GetPos());
					Sound:SetSoundLoop(self.AliveSoundLoop, 1);
					Sound:SetSoundVolume(self.AliveSoundLoop, SndTbl.nVolume);
					Sound:SetMinMaxDistance(self.AliveSoundLoop, SndTbl.InnerRadius, SndTbl.OuterRadius);
				end
			else
				self.AliveSoundLoop=nil;
			end
			SndTbl=self.Properties.DeadSoundLoop;
			if (SndTbl.sndFilename~="") then
				self.DeadSoundLoop=Sound:Load3DSound(SndTbl.sndFilename, 0);
				if (self.DeadSoundLoop) then
					Sound:SetSoundLoop(self.DeadSoundLoop, 1);
					Sound:SetSoundVolume(self.DeadSoundLoop, SndTbl.nVolume);
					Sound:SetMinMaxDistance(self.DeadSoundLoop, SndTbl.InnerRadius, SndTbl.OuterRadius);
				end
			else
				self.DeadSoundLoop=nil;
			end
			SndTbl=self.Properties.DyingSound;
			if (SndTbl.sndFilename~="") then
				self.DyingSound=Sound:Load3DSound(SndTbl.sndFilename, 0);
				if (self.DyingSound) then
					Sound:SetSoundVolume(self.DyingSound, SndTbl.nVolume);
					Sound:SetMinMaxDistance(self.DyingSound, SndTbl.InnerRadius, SndTbl.OuterRadius);
				end
			else
				self.DyingSound=nil;
			end
		
			if (self.Properties.bHidden==1) then
				self:DrawObject(0,0);
			else
				self:DrawObject(0,1);
			end
			self:DrawObject(1,0);
			if (self.DeadSoundLoop) then
				Sound:StopSound(self.DeadSoundLoop);
			end
			if (self.AliveSoundLoop and (not Sound:IsPlaying(self.AliveSoundLoop))) then
				Sound:PlaySound(self.AliveSoundLoop);
			end
		end
		self:EnablePhysics(1);
	end,
	OnDamage = DestroyableObject.OnDamage,
	OnTimer = function(self)
		self:Event_Explode();
	end,
	OnMove = function(self)
		if (self.AliveSoundLoop ~= nil) then
			Sound:SetSoundPosition( self.AliveSoundLoop,self:GetPos() );			
		end;
	end,
	OnCollide = function(self,hit)
		BasicEntity.OnCollide(self,hit);
		if (Game:IsServer()) then
			BroadcastEvent(self, "Collision");
		end
	end,
}

DestroyableObject.Dead={
	OnBeginState=function(self)
		self.bDead = 1;
		self:SetTimer(1);
	end,

	OnTimer=function(self)
		self.bNeedsReloadInEditor=1; -- [marco] recreate physics in editor next time
		self:DrawObject(0,0);
		self:RemoveDecals();
		if (self.Properties.Physics.bRigidBody == 1) and (self.Properties.Physics.bRigidBodyAfterDeath == 1) then
			if(self.Properties.object_ModelDestroyed~="") then
				self:SetPhysicsProperties(1);
				self:DrawObject(1,1);
				self:EnableUpdate(1);
				self:AwakePhysics(1);
			end
		else
			self:DestroyPhysics();
			if (self.Properties.object_ModelDestroyed~="") then
				self:DrawObject(1,1);
				self:CreateStaticEntity( 10,-1,1 );
			end
		end
		
		if (Game:IsClient()) then
			if (self.AliveSoundLoop) and (Sound:IsPlaying(self.AliveSoundLoop)) then
				Sound:StopSound(self.AliveSoundLoop);
			end
			if (self.DeadSoundLoop and (not Sound:IsPlaying(self.DeadSoundLoop))) then
				Sound:SetSoundPosition(self.DeadSoundLoop, self:GetPos());
				Sound:PlaySound(self.DeadSoundLoop);
			end
		end
	end,
	OnDamage = function(self,hit)
		self:AwakePhysics(1);
		if( hit.ipart and hit.ipart>=0 ) then
			self:AddImpulse( hit.ipart, hit.pos, hit.dir, hit.impact_force_mul );
		end
	end,
	OnCollide = BasicEntity.OnCollide,
}

function DestroyableObject:Event_OnDamage( sender )

	if self:GetState()=="Dead" then return end
	BroadcastEvent( self,"OnDamage" );
end

function DestroyableObject:OnRemoteEffect(toktable, pos, normal, userbyte)
	if (not Game:IsServer()) then
		if (userbyte == 2) then -- client updatepos
			self:SetPos(pos);
			self:SetAngles(normal);
		end
	end
	if (userbyte == 1) then
		local obj_pos = self:GetPos();
		Particle:SpawnEffect(obj_pos, {x=0,y=0,z=1}, self.Properties.ExplosionTable ,1.0);
		CreateEntityLight( self, 7, 1, 1, 0.7, 0.5, obj_pos);
		if (self.DyingSound and (not Sound:IsPlaying(self.DyingSound))) then
			Sound:SetSoundPosition(self.DyingSound, obj_pos);
			Sound:PlaySound(self.DyingSound);
		end
	end
end

-- Input events

function DestroyableObject:Event_AddImpulse(sender)
  local len = sqrt(LengthSqVector(self.Properties.Physics.vector_Impulse));
  if (len>0) then
    local rlen = 1.0/len;
	  self.temp_vec={x=0,y=0,z=0};
	  self.temp_vec.x=self.Properties.Physics.vector_Impulse.x*rlen;
	  self.temp_vec.y=self.Properties.Physics.vector_Impulse.y*rlen;
	  self.temp_vec.z=self.Properties.Physics.vector_Impulse.z*rlen;
	  self:AddImpulse(0,nil,self.temp_vec,len);
	end
end

function DestroyableObject:Event_Activate(sender)
	--create rigid body 
	if (self.bRigidBodyActive ~= 1) then
		self.bRigidBodyActive = 1;
		self:SetPhysicsProperties(0);
		if (self.Properties.Physics.bResting==0) then
			self:EnableUpdate(1);
			self:AwakePhysics(1);
		end
	end
end

--------
-- Events to switch material Applied to object.
-----
function DestroyableObject:CommonSwitchToMaterial( numStr )
	if (not self.sOriginalMaterial) then
		self.sOriginalMaterial = self:GetMaterial();
	end
	
	if (self.sOriginalMaterial) then
		System:Log( "Material: "..self.sOriginalMaterial..numStr );
		self:SetMaterial( self.sOriginalMaterial..numStr );
	end
end

------------------------------------------------------------------------------------------------------
function DestroyableObject:Event_SwitchToMaterialOriginal(sender)
	self:CommonSwitchToMaterial( "" );
end

------------------------------------------------------------------------------------------------------
function DestroyableObject:Event_SwitchToMaterial1(sender)
	self:CommonSwitchToMaterial( "1" );
end
------------------------------------------------------------------------------------------------------
function DestroyableObject:Event_SwitchToMaterial2(sender)
	self:CommonSwitchToMaterial( "2" );
end