--5 diffeerent states
--Can be build and repaired
-- survival suppport (fixed by Mixer)

BuildableObject={
	Properties={
		object_Model_unbuilt = "",
		object_Model_building = "",
		object_Model_built = "Objects/multiplayer/buildables/bunkerbig_smallslits_built.cgf",
		object_Model_repair = "",
		object_Model_damaged = "",
		max_buildpoints=0,	
		max_repairpoints=0,
		max_hitpoints=0,	
		iInitalState=1,					-- -1=hidden, 0=unbuilt, 1=built, 2=damaged
	},

	health=0,
}

function BuildableObject:RegisterStates()
	self:RegisterState("hidden");
	self:RegisterState("unbuilt");
	self:RegisterState("building");
	self:RegisterState("built");
	self:RegisterState("repair");
	self:RegisterState("damaged");
end


function BuildableObject:LoadGeometry()
	if(self.Properties.object_Model_unbuilt~="")then
		self:LoadObject(self.Properties.object_Model_unbuilt,0,1);	-- unbuilt
		self:CreateStaticEntity(2,-1,0);
	end
	if(self.Properties.object_Model_building~="")then
		self:LoadObject(self.Properties.object_Model_building,1,1);	-- building
		self:CreateStaticEntity(2,-1,1);
	end
	if(self.Properties.object_Model_built~="")then
		self:LoadObject(self.Properties.object_Model_built,2,1);	-- built
		self:CreateStaticEntity(2,-1,2);
	end
	if(self.Properties.object_Model_repair~="")then
		self:LoadObject(self.Properties.object_Model_repair,3,1);	-- repair
		self:CreateStaticEntity(2,-1,3);
	end
	if(self.Properties.object_Model_damaged~="")then
		self:LoadObject(self.Properties.object_Model_damaged,4,1);	-- damaged
		self:CreateStaticEntity(2,-1,4);
	end
end

function BuildableObject:OnReset()
	if self.Properties.iInitalState==-1 then		-- hidden
		self:Event_hidden();
	elseif self.Properties.iInitalState==0 then		-- unbuilt
		self:Event_unbuilt();
	elseif self.Properties.iInitalState==1 then		-- built
		self:Event_built();
	else						--   2				-- damaged
		self:Event_damaged();
	end
	self.vbot_toucher = nil;
end

function BuildableObject:OnMultiplayerReset()
	self:OnReset();
end

function BuildableObject:OnPropertyChange()
	self:LoadGeometry();
	self:OnReset();
end

-- check for the netity itself and the buildable object which are connected to it (recursivly - beware circular endless loop is possible)
function BuildableObject:IsCollisionFree()
	-- check this entity
  local colltable = self:CheckCollisions(ent_rigid+ent_sleeping_rigid+ent_living, geom_colltype_player);
  
  if (colltable and colltable.contacts and getn(colltable.contacts)>0) then
    return nil;
  end
   
  -- check connected objects
	local sender=self;
	
  -- Check if Event Target for this input event exists.
	if (sender.Events) then
		for Event,eventTargets in sender.Events do
			if (eventTargets) then
				for i, target in eventTargets do
					local TargetId = target[1];
					local TargetEvent = target[2];
	
					if (TargetId ~= 0) then
						-- If TargetId refere to Entity.  - otherwise it would be to the global Mission tabls
						local entity = System:GetEntity(TargetId);					
						if (entity ~= nil) then

							-- check connected entities
							local colltable = entity:CheckCollisions(ent_rigid+ent_sleeping_rigid+ent_living, geom_colltype_player);
							  
							if (colltable and colltable.contacts and getn(colltable.contacts)>0) then
								return nil;		-- collision with an connected entity
							end
						end
					end
				end
 			end
 		end
 	end
    
	return 1;	-- collision free
end

-- used to make remote building (e.g. a crate and a bunker) of objects more consistant
-- (you cannot finish a BuildableObject that was created remotely by itself)
function BuildableObject:ResetBuildpointsOfConnected(ssid, team)
  -- check connected objects
	local sender=self;
	
  -- Check if Event Target for this input event exists.
	if (sender.Events) then
		for Event,eventTargets in sender.Events do
			if (eventTargets) then
				for i, target in eventTargets do
					local TargetId = target[1];
					local TargetEvent = target[2];
	
					if (TargetId ~= 0) then
						-- If TargetId refere to Entity.  - otherwise it would be to the global Mission tabls
						local entity = System:GetEntity(TargetId);					
						if (entity and (entity.classname == "BuildableObject")) then
							entity.Properties.max_buildpoints = 0;
						end
					end
				end
 			end
 		end
 	end
end

function BuildableObject:UpdateOwner(ssid, team)

	if (self.classname == "BuildableObject") then
		self.szBuiltByTeam = team;
		self.iBuiltBySSID = ssid;
	else
		return;
	end
  
  -- check connected objects
	local sender=self;
	
  -- Check if Event Target for this input event exists.
	if (sender.Events) then
		for Event,eventTargets in sender.Events do
			if (eventTargets) then
				for i, target in eventTargets do
					local TargetId = target[1];
					local TargetEvent = target[2];
	
					if (TargetId ~= 0) then
						-- If TargetId refere to Entity.  - otherwise it would be to the global Mission tabls
						local entity = System:GetEntity(TargetId);					
						if (entity and (entity.classname == "BuildableObject")) then
							entity.szBuiltByTeam = team;
							entity.iBuiltBySSID = ssid;
						end
					end
				end
 			end
 		end
 	end
end

-- change state
function BuildableObject:ModifyStateCommon(name)
	self:GotoState(name);
	self:ResetBuildpointsOfConnected();
	BroadcastEvent(self, name);						-- beware circular endless loop is possible	
end


function BuildableObject:Event_hidden()
	self:ModifyStateCommon("hidden");
end
function BuildableObject:Event_unbuilt()
	self:ModifyStateCommon("unbuilt");
end
function BuildableObject:Event_building()
	self:ModifyStateCommon("building");
end
function BuildableObject:Event_built()
	self:ModifyStateCommon("built");
end
function BuildableObject:Event_repair()
	self:ModifyStateCommon("repair");
end
function BuildableObject:Event_damaged()
	self:ModifyStateCommon("damaged");
end

-- when construction area is blocked
function BuildableObject:SendNoProgress(shooter,type)
	if shooter then
		local slot;
		
		slot=Server:GetServerSlotByEntityId(shooter.id);
		if slot then
			slot:SendCommand("P "..tostring(type));		-- "progress 2=repair"
		end
	end
end

-- /param type "1"=building, "2"=repair
-- /param shooter
-- /param curr
-- /param max
function BuildableObject:SendProgress(shooter,type,curr,max)
	if shooter then
		local slot;
		
		slot=Server:GetServerSlotByEntityId(shooter.id);
		if slot then
			local PerPercent=100;
			
			if max>0 then
				PerPercent=100-(100*curr)/max;			-- 0..100
			end
			
			local str=format("%.0f",PerPercent);
			
			slot:SendCommand("P "..tostring(type).." "..str);		-- "progress 2=repair 0..100"
		end
	end
end

function BuildableObject:ProcessDamage(hit)
if (GameRules.GetGameState) and (GameRules:GetGameState()~=CGS_INPROGRESS) then
else
	self.health=self.health-hit.damage;
	if self.health<=0 then
		self.health=0;
	end
	-- survival extension
	if (GameRules.SurvivalManager) then
	if (hit.damage_type == "building") and (self.health < self.Properties.max_hitpoints) then
		self.health = self.health + hit.damage * 1.8;
		if (hit.shooter) and (hit.shooter.fireparams) then
			-- Mixer: special timer for survival game mode, to prevent person which is repairing the object,
			-- from picking up dropped gun (see GameRules:IsInteractionPossible in SURVIVAL/Gamerules.lua)
			-- this thing also updates dropped gun's fade away time to prevent the gun from disappearing.
			hit.shooter.su_LastRepTime = _time + hit.shooter.fireparams.fire_rate * 1.2;
			local workerslot = Server:GetServerSlotByEntityId(hit.shooter.id);
			if (workerslot) then
				if (self.Properties.max_hitpoints) then
					self.percent = (100*self.health)/self.Properties.max_hitpoints;
				else
					self.percent = 100;
				end
				self.percent = format("%.0f",self.percent);
				workerslot:SendCommand("P 2 "..self.percent);
			end
		end
		if (self.health >= self.Properties.max_hitpoints) then
			self.health = self.Properties.max_hitpoints;
			if (hit.shooter) and (self.sio_enemydmg) and (self.su_award) then
				self.sio_enemydmg = nil;
				self.su_award = nil;
				hit.shooter.cnt.score = hit.shooter.cnt.score + 17;
				if (not hit.shooter.mp_bonuscounter) then hit.shooter.mp_bonuscounter = 0; end
				hit.shooter.mp_bonuscounter = hit.shooter.mp_bonuscounter + 3;
				GameRules:CheckBonusCounter(hit.shooter);
				GameRules:ScoreboardUpd();
			end
		end
	elseif (hit.shooter) then
		if (hit.shooter.isbadmonster) then self.sio_enemydmg=1; end
		hit.shooter.sio_attack_time = _time + 5;
	end
		if (not self.prev_sta) then
			self.prev_sta = 0;
		end
		local c_sta = self.health/self.Properties.max_hitpoints;
		if (c_sta > 0.8) then
		c_sta = 1; -- *
		elseif (c_sta > 0.6) then -- ||||
		c_sta = 2;
		elseif (c_sta > 0.4) then -- |||
		self.su_award = 1;
		c_sta = 3;
		elseif (c_sta > 0.2) then -- ||
		c_sta = 4;
		elseif (c_sta > 0) then -- |
		c_sta = 5;
		else -- X
		c_sta = 6;
		GameRules.sm_nextcheck = _time + 2;
		end
		if (c_sta ~= self.prev_sta) then
			self.status = c_sta;
			self.prev_sta = c_sta;
			GameRules:TransferTheStatus(0);
		end
	end
end -- interaction
end

--SERVER

BuildableObject.Server={
	OnInit=function(self)
		self:RegisterStates();
		self:OnReset();
		self:LoadGeometry();		-- call after state was set
		self:NetPresent(nil);
		self:EnableUpdate(0);
		self:UpdatePhysicsMesh();
	end,

	hidden={
		OnBeginState=function(self)
			self:UpdatePhysicsMesh();
		end,
	},

	unbuilt={
		OnBeginState=function(self)
			self.health=self.Properties.max_buildpoints;
			self:UpdatePhysicsMesh();
		end,
		OnDamage = function(self,hit)
			if not GameRules:IsInteractionPossible(hit.shooter,self) then return end;
			if(hit.damage_type~="building")then return end;					-- only building damage is allowed
			if(self.Properties.max_buildpoints<=0)then return end;		-- only if it can be built

		  if(not self:IsCollisionFree())then
--		    System:Log("BuildableObject: cannot build due to foreign objects in the build area");
		    self:SendNoProgress(hit.shooter,"1");
		    return;
		  end

			self:SendProgress(hit.shooter,"1",self.health,self.Properties.max_buildpoints);
			self:Event_building();
		end,
	},

	building={
		OnBeginState=function(self)
			self.health=self.Properties.max_buildpoints;
			self:UpdatePhysicsMesh();
		end,
		OnDamage = function(self,hit)
			if(hit.damage_type~="building")then return end;					-- only building damage is allowed
			if(self.Properties.max_buildpoints<=0)then return end;		-- only if it can be built

		  if(not self:IsCollisionFree())then
--		    System:Log("BuildableObject: cannot build due to foreign objects in the build area");
		    self:SendNoProgress(hit.shooter,"1");
		    return;
		  end
	
			self:ProcessDamage(hit);
			self:SendProgress(hit.shooter,"1",self.health,self.Properties.max_buildpoints);

			if self.health<=0 then
				self:Event_built();			-- you built it
				
				local Slot = Server:GetServerSlotByEntityId(hit.shooter.id);
				
				if (Slot) then
					self:UpdateOwner(Slot:GetId(), Game:GetEntityTeam(hit.shooter.id));
					MPStatistics:AddStatisticsDataEntity(hit.shooter,"nBuildingBuilt",1);
					if (GameRules.ScoreboardUpd) then
						GameRules:ScoreboardUpd();
					end
				elseif (GameRules.IsDefender) and (hit.shooter.vbot_ssid) then
					self:SetVBotScore(hit.shooter.vbot_ssid,5,Game:GetEntityTeam(hit.shooter.id));
				end
			end
		end,
	},

	built={
		OnBeginState=function(self)
			self.health=self.Properties.max_hitpoints;
			self:UpdatePhysicsMesh();
		end,
		OnDamage = function(self,hit)
			if (not hit.explosion) then
			if (GameRules.SurvivalManager) then
				hit.damage = hit.damage * 0.7;
			elseif (GameRules.insta_play) then
				hit.damage = hit.damage * 0.84;
			else
				return;
			end
			end
			if self.Properties.max_hitpoints==0 then return end;	-- cannot be destroyed
			self:ProcessDamage(hit);
			if self.health <=0 then
				self:Event_damaged();
				local Slot = Server:GetServerSlotBySSId(hit.shooterSSID);
				if (Slot) then
					local Player = System:GetEntity(Slot:GetPlayerId());
					if (Player and (self.szBuiltByTeam ~= Game:GetEntityTeam(Player.id))) then
						MPStatistics:AddStatisticsDataSSId(hit.shooterSSID,"nBuildingDestroyed", 1);
					else
						MPStatistics:AddStatisticsDataSSId(hit.shooterSSID,"nBuildingDestroyed", -1);
					end
					if (GameRules.ScoreboardUpd) then
						GameRules:ScoreboardUpd();
					end
				elseif (GameRules.IsDefender) then
					self:SetVBotScore(hit.shooterSSID,5,self.szBuiltByTeam);
				end
			end
		end,
	},

	repair={
		OnBeginState=function(self)
			self.health=self.Properties.max_repairpoints;
			self:UpdatePhysicsMesh();
		end,
		OnDamage = function(self,hit)
			if hit.damage_type ~= "building" then return end;		-- only building damage is allowed
			
		  if(not self:IsCollisionFree())then
		    self:SendNoProgress(hit.shooter,"2");
		    return;
		  end

			self:ProcessDamage(hit);
			self:SendProgress(hit.shooter,"2",self.health,self.Properties.max_repairpoints);
			
			if self.health<=0 then			-- you fixed it
				self:Event_built();

				local Slot = Server:GetServerSlotByEntityId(hit.shooter.id);
				
				if (Slot) then
					self:UpdateOwner(Slot:GetId(), Game:GetEntityTeam(hit.shooter.id));
					MPStatistics:AddStatisticsDataEntity(hit.shooter,"nBuildingRepaired",1);
					if (GameRules.ScoreboardUpd) then
						GameRules:ScoreboardUpd();
					end
				elseif (GameRules.IsDefender) and (hit.shooter.vbot_ssid) then
					self:SetVBotScore(hit.shooter.vbot_ssid,5,Game:GetEntityTeam(hit.shooter.id));
				end
			end
		end,
	},

	damaged={
		OnBeginState=function(self)
			self.health=self.Properties.max_repairpoints;
			self:UpdatePhysicsMesh();
		end,
		OnDamage = function(self,hit)
			if not GameRules:IsInteractionPossible(hit.shooter,self) then return end;
			if hit.damage_type ~= "building" then return end;		-- only building damage is allowed
			if self.Properties.max_repairpoints==0 then return end;	-- cannot be repaired	

		  if(not self:IsCollisionFree())then
--		    System:Log("BuildableObject: cannot build due to foreign objects in the build area");
		    self:SendNoProgress(hit.shooter,"2");
		    return;
		  end

			self:SendProgress(hit.shooter,"2",self.health,self.Properties.max_repairpoints);
			self:Event_repair();
		end,
	},
}

function BuildableObject:UpdateRendermesh()
	if self:GetState()=="unbuilt" then
		self:DrawObject(0,1);
	else
		self:DrawObject(0,0);
	end
	
	if self:GetState()=="building" then 
		self:DrawObject(1,1);
	else
		self:DrawObject(1,0);
	end
	
	if self:GetState()=="built" then 
		self:DrawObject(2,1);
	else
		self:DrawObject(2,0);
	end
	
	if self:GetState()=="repair" then 
		self:DrawObject(3,1);
	else
		self:DrawObject(3,0);
	end
	
	if self:GetState()=="damaged" then 
		self:DrawObject(4,1);
	else
		self:DrawObject(4,0);
	end
	
	self:RemoveDecals();
end

function BuildableObject:SetVBotScore(shooter_id,points,builders_team)
	local entlist = System:GetEntities();
	local v_bot;
	local v_botid;
	for i, entity in entlist do
		if (entity.vbot_ssid) then
			if (entity.vbot_ssid == shooter_id) then
			v_bot = entity;
			v_botid = entity.id;
			break;
			end
		end
	end

	if (v_bot) and (v_bot.assault_score) then
		if (not builders_team) or (builders_team ~= Game:GetEntityTeam(v_botid)) then
			v_bot.assault_score = v_bot.assault_score + points;
		else
			v_bot.assault_score = v_bot.assault_score - points;
		end
		v_bot:SetBotStats(1);
	end
end

function BuildableObject:UpdatePhysicsMesh()
	-- make sure all the physics stuff in our surroundings gets updated
	self:AwakeEnvironment();
	
	if self:GetState()=="hidden" then
		self:DestroyPhysics();
	elseif self:GetState()=="unbuilt" then
		self:CreateStaticEntity(2,-1,0);
	elseif self:GetState()=="building" then
		self:CreateStaticEntity(2,-1,1);
	elseif self:GetState()=="built" then
		self:CreateStaticEntity(2,-1,2);
	elseif self:GetState()=="repair" then
		self:CreateStaticEntity(2,-1,3);
	elseif self:GetState()=="damaged" then
		self:CreateStaticEntity(2,-1,4);
	end
end

--CLIENT

BuildableObject.Client={
	OnInit=function(self)
		self:RegisterStates();
		self:LoadGeometry();		-- call after state was set
		self:EnableUpdate(0);

		local stat=self.Client[self:GetState()];
		if stat then
			stat.OnBeginState(self);
		end
	end,

	hidden={
		OnBeginState=function(self)
			self:UpdateRendermesh();
			self:UpdatePhysicsMesh();
		end,
	},

	unbuilt={
		OnBeginState=function(self)
			self:UpdateRendermesh();
			self:UpdatePhysicsMesh();
		end,
	},

	building={
		OnBeginState=function(self)
			self:UpdateRendermesh();
			self:UpdatePhysicsMesh();
		end,
	},

	built={
		OnBeginState=function(self)
			self:UpdateRendermesh();
			self:UpdatePhysicsMesh();
		end,
	},

	repair={
		OnBeginState=function(self)
			self:UpdateRendermesh();
			self:UpdatePhysicsMesh();
		end,
	},

	damaged={
		OnBeginState=function(self)
			self:UpdateRendermesh();
			self:UpdatePhysicsMesh();
		end,
	},
}