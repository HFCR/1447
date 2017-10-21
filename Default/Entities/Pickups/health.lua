Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self, collider, entering)

--	printf("collider health is %d < %d >  tm< %d >", collider.cnt.health, self.Properties.Amount, self.Properties.RespawnTime);
	local serverSlot = Server:GetServerSlotByEntityId(collider.id);
	if (collider.cnt.health>=collider.cnt.max_health) then
		if (entering == 1) then
			if ((not self.lasttime) or (_time>(self.lasttime+6))) then
			
				-- send health cannot catch
				if (serverSlot) then
					serverSlot:SendCommand("HUD P 2 -1"); -- hud, generic pick, health, not available
				end
				
				--self:NotifyMessage("@medi_pickup_not_possible", collider);
				self.lasttime=_time;
			end
		end
		return nil;
	end
	
	if (self.Properties.Amount>0) and (self.Properties.Amount<25) then
		self.Properties.Amount = 25;
	end

	collider.cnt.health = collider.cnt.health + floor(self.Properties.Amount*(collider.cnt.max_health/100.0));
	if (collider.cnt.health>collider.cnt.max_health) then
		collider.cnt.health=collider.cnt.max_health;
	end
	local bandages = 0;
	if (Mission and Mission.alienworld) or (collider.items and collider.items.aliensuit) then
	elseif (toNumberOrZero(getglobal("gr_bleeding"))~=0) and (collider.Ammo["Bandage"]) then
		if (collider.items) and (collider.items.bleed_range) then
			bandages = 1;
		else
			bandages = 2;
		end
		local bamount = MaxAmmo["Bandage"] - collider:GetAmmoAmount("Bandage");
		if (bamount < bandages) then
			bandages = bamount;
		end
		if (bandages > 0) then
			collider:AddAmmo("Bandage", bandages);	
		end
	end
	if (collider.items) then
		collider.items.bleed_range = nil;
	end

	-- send health catch
	if (serverSlot) then
		if (bandages > 0) then
			serverSlot:SendCommand("HUD P 2 "..self.Properties.Amount.." "..bandages); -- hud, generic pick, health, amount, bandages amount
		else
			serverSlot:SendCommand("HUD P 2 "..self.Properties.Amount); -- hud, generic pick, health, amount
		end
	end

	local colliderSSID;

	-- multiplayer statistics
	if (not collider.ai) and (collider.POTSHOTS) then
		colliderSSID = collider.id * 1;
		if (self.botshooter) and (collider.bot_teamname) and (collider.bot_teamname == self.LaunchedByTeam) then
			if (self.botshooter.assault_score) and (self.botshooter ~= collider) then
				self.botshooter.assault_score = self.botshooter.assault_score + 2;
				local bs_totalscore = self.botshooter.assault_score + self.botshooter.cnt.score * 5;
				GameRules:SetScoreboardEntryXY(ScoreboardTableColumns.iTotalScore,self.botshooter.vbot_ssid,bs_totalscore);
			end
		end
		return 1;
	else
		colliderSSID = (Server:GetServerSlotByEntityId(collider.id)):GetId();
	end
	
	if (self.shooterSSID) and (colliderSSID) and (colliderSSID~=self.shooterSSID) then
		if (self.LaunchedByTeam == Game:GetEntityTeam(collider.id)) then
			MPStatistics:AddStatisticsDataSSId(self.shooterSSID,"nHealed", 1);
		end		
	end
	
	return 1;
end

local params={
	func=funcPick,
	model="Objects/pickups/health/medikit.cgf",
	default_amount=50,
	sound="sounds/items/generic_pickup.wav",
	modelchoosable=nil,
	soundchoosable=nil,
	floating_icon="Objects/Pickups/health/health_icon.cga"
}

Health=CreateCustomPickup(params);


Health._OnInit=Health.Client.OnInit;
function Health.Client:OnInit()
	if (Player) then
		self.soundtbl=Player.HealingSounds;
	else
		self.soundtbl={Sound:Load3DSound("SOUNDS/player/relief1.wav",SOUND_UNSCALABLE,175,5,30),};
	end
	self:_OnInit();
	self:SetViewDistRatio(255);
end


Health.PhysParam = {
	mass = 10,
	size = 0.15,
	heading = {x=0,y=0,z=-1},
	initial_velocity = 6,
	k_air_resistance = 0,
	acc_thrust = 0,
	acc_lift = 0,
	--high friction material
	surface_idx = Game:GetMaterialIDByName("mat_pickup"),
	gravity = {x=0, y=0, z=-9.8 },
	collider_to_ignore = nil,
	flags = bor(particle_constant_orientation,particle_no_path_alignment, particle_no_roll, particle_traceable),
}

function Health:LoadGeometry()
	if (not self.geometry) then
		self.geometry=1;
		local wpn_mode = strupper(getglobal("g_GameType"));
		if (Mission and Mission.alienworld) or (strfind(wpn_mode,"PRO") ~= nil) then
			if (self.Properties.Amount >= 100) then
				self:LoadObject("Objects/Pickups/Health/alien_health_blue.cgf", 0, 1);
			elseif (self.Properties.Amount >= 50) then
				self:LoadObject("Objects/Pickups/Health/alien_health_yellow.cgf", 0, 1);
			else
				self:LoadObject("Objects/Pickups/Health/alien_health_green.cgf", 0, 1);
			end
		else
			self:LoadObject(self.model, 0, 1);
		end
		self:DrawObject( 0, 1 );
	end
	
	if(self.objectangles) then
		self:SetObjectAngles(0, self.objectangles)
	end
	
	if(self.objectpos)then
		self:SetObjectPos(0, self.objectpos)
	elseif(self.rotate90)then
		self:SetObjectPos(0,{x=0,y=0,z=0.1})
	end
end

function Health:Launch( weapon, shooter, pos, angles, dir, target )

	self:SetPhysicParams( PHYSICPARAM_PARTICLE, self.PhysParam );
	self.autodelete = 1;
	self.deleteOnGameReset = 1;
	self:EnableSave(nil);
	self:GotoState("Dropped");
	-- fade away after 15 seconds
	self.Properties.FadeTime = 15;
	self.Properties.Amount = 50;--30

	local direction = g_Vectors.temp_v1;
	local dest = g_Vectors.temp_v2;
		
	CopyVector(direction,dir);
		
	dest.x = pos.x + direction.x * 1.5;
	dest.y = pos.y + direction.y * 1.5;
	dest.z = pos.z + direction.z * 1.5;
		
	local hits = System:RayWorldIntersection(pos,dest,1,ent_terrain+ent_static+ent_rigid+ent_sleeping_rigid,shooter.id);
		
	if (hits and getn(hits)>0) then
			
		local temp = hits[1].pos;
		
		dest.x = temp.x - direction.x * 0.15;
		dest.y = temp.y - direction.y * 0.15;
		dest.z = temp.z - direction.z * 0.15;
	end
	
	shooter:AwakeEnvironment();

	self:SetPos( dest );--pos );
	self:SetAngles( angles );
	self:NetPresent(1);
	
	-- the ID of the server slot who initiated the action
	-- used for statistics
	local serverSlot = Server:GetServerSlotByEntityId(shooter.id);
	
	if (serverSlot) then
		self.shooterSSID = serverSlot:GetId();
	elseif (shooter.bot_born) then
		self.botshooter = shooter;
	end
	
	self.LaunchedByTeam=Game:GetEntityTeam(shooter.id);
end


