-- SURVIVAL MODE BY MIXER rev2.8 (dedicated server fix)
Script:LoadScript("SCRIPTS/FFA/gamerules.lua");
setglobal("gr_InvulnerabilityTimer",1);
GameRules.MonsterHorde = {};
GameRules.SIO_rush_factor = 3; -- default factor to make monsters rush strategically important object
GameRules.bShowUnitHightlight=nil;
GameRules.InitialPlayerProperties.armor=50;
GameRules.InitialPlayerProperties.health=220; -- see also clientstuff.lua for note about this
GameRules.InitialPlayerProperties.model="Objects/characters/mercenaries/indoor_merc/indoor_merc_light.cgf";

function GameRules:ModeDesc() return "SURVIVAL"; end

function GameRules:GetMonstersCount()
local ents = System:GetEntities();
local mc = 0;
if (ents) then
	for i,entity in ents do
		if (entity.isbadmonster) then
			if (entity.cnt) and (entity.cnt.health >0) then
				mc = mc+1;
			elseif (entity.death_timestamp) and (entity.death_timestamp < _time) then
				Server:RemoveFromTeam(entity.id);
				Server:RemoveEntity(entity.id); -- remove now?
				entity = nil;
			end
		elseif (entity.su_turret) and (entity.su_destroyed) then
			Server:RemoveFromTeam(entity.id);
			Server:RemoveEntity(entity.id); -- remove now?
			entity = nil;
		end
	end
end
return mc;
end

--- Mixer: TaskForBot function dictates behavior for bots for particular gametype, so it will override classic look-for-pickups-and-enemies behavior of bot.
function GameRules:TaskForBot(entity)
	local retval;
	if (entity.su_followers == nil) then
		local allvills = System:GetEntities();
		local vill_running = 0;
		for i, vill in allvills do
			if (vill.isvillager) and (vill.cnt.health > 0) then
				if (vill.my_leader==nil) then
					-- approach standing villager.
					entity:ChangeAIParameter(AIPARAM_ATTACKRANGE,0);
					entity.go2friend = 1;
					if (AIBehaviour.TestBotIdle:SMART_GO(entity,vill.id)==nil) then
						-- use DUMB GO METHOD :)
						entity:SelectPipe(0,"bot_roam",vill.id);
					end
					entity.vb_su_goal_subject = vill.id;
					retval = 1;
					break;
				else
					-- count engaged villagers, join escort if all of them are already folllowing someone!
					vill_running = vill_running + 1;
					if (vill_running == GameRules.villagers) then
						if (entity:ReachGoal("BOTGOAL")~=nil) then
							retval = 1;
						elseif (AIBehaviour.TestBotIdle:SMART_GO(entity,"BOTSANESTSPOT")~=nil) then
							retval = 1;
						end
					end
				end
			end
		end
	else
		-- checking my follower status. if he is ok, coutinue leading, if not, forgot about him, go free and try above stuff
		local follower = System:GetEntity(entity.su_followers);
		if (follower) and (follower.cnt) and (follower.cnt.health > 0) then
			if (not follower.my_leader) or (follower.my_leader~=entity.id) then
				entity.su_followers = nil;
			else
				if (entity:ReachGoal("BOTGOAL")~=nil) then retval = 1; end
			end
		else
			entity.su_followers = nil;
		end
	end
	return retval;
end

function GameRules:GetHandicap()
	local m_hc = getglobal("gr_su_handicap");
	if (m_hc) then
		m_hc = tonumber(m_hc);
		if (m_hc) and (self.su_minmonsters) then
			if (m_hc > self.su_minmonsters) then
				m_hc = self.su_minmonsters * 1;
				System:LogAlways("Monsters Handicap cannot be more than "..self.su_minmonsters.." on this map. Setting to "..self.su_minmonsters..": Done.");
				setglobal("gr_su_handicap",m_hc);
			elseif (m_hc < -self.su_minmonsters+1) then
				m_hc = -self.su_minmonsters+1;
				System:LogAlways("Monsters Handicap cannot be less than "..m_hc.." on this map. Setting to "..m_hc..": Done.");
				setglobal("gr_su_handicap",m_hc);
			end
		else
			m_hc = 0;
			setglobal("gr_su_handicap",0);
		end
	else
		m_hc = 0;
		setglobal("gr_su_handicap",0);
	end
	return floor(m_hc);
end

function GameRules:OnAfterSpawnEntity( server_slot )
	local newent=GetSlotPlayer(server_slot);
	if newent.type=="Player" then
		local locInitialPlayerProperties=self:GetInitialPlayerProperties(server_slot);
		if locInitialPlayerProperties then
			newent.cnt.health			= locInitialPlayerProperties.health;
			newent.cnt.max_health			= locInitialPlayerProperties.health;
			newent.cnt.armor			= locInitialPlayerProperties.armor;		
			newent.cnt.fallscale			= locInitialPlayerProperties.fallscale;	

			if locInitialPlayerProperties.StaminaTable then
				newent.cnt:InitStaminaTable( locInitialPlayerProperties.StaminaTable );
			end	
			if locInitialPlayerProperties.DynProp then
				newent.cnt:SetDynamicsProperties( locInitialPlayerProperties.DynProp );
			end

			if locInitialPlayerProperties.move_params then
				newent.cnt:SetMoveParams( locInitialPlayerProperties.move_params );
			end	
			
			newent.Properties.equipEquipment = locInitialPlayerProperties.equipEquipment;
			newent.currentEquipment = new(EquipPacks[newent.Properties.equipEquipment]);
			newent.sCurrentPlayerClass=locInitialPlayerProperties.sPlayerClass;		-- to identify class name
			Server:BroadcastCommand("YCN "..server_slot:GetPlayerId().." DefaultMultiPlayer");

			BasicPlayer.InitAllWeapons(newent,1);
			newent.Ammo["HealthPack"] = 2;
		end

		if (gr_InvulnerabilityTimer~=nil and toNumberOrZero(gr_InvulnerabilityTimer)>0) then
			newent.invulnerabilityTimer=toNumberOrZero(gr_InvulnerabilityTimer);
			Server:BroadcastCommand("FX", g_Vectors.v000, g_Vectors.v000, newent.id, 2);
		end
	
		newent.cnt.alive=1;
		newent:EnablePhysics(1);
		newent:SetViewDistRatio(255);
		
		if (team~="spectators") then
			if self.bShowUnitHightlight then
				local highlightpos=new(newent:GetPos());
				local highlight = Server:SpawnEntity("UnitHighlight",highlightpos);
				newent.idUnitHighlight = highlight.id; -- only done on the server
				-- send "follow this player" command
				Server:BroadcastCommand("FX "..tonumber(newent.id), g_Vectors.v000, g_Vectors.v000,highlight.id,0);
			end
			GameRules:TransferTheStatus(6,server_slot);
			server_slot:SendCommand("GI WS");
		end
		-- reset viewlayers
	end
end

function GameRules:GenerateMonster()
if (not self.mspawncount) then
	self.mspawncount = 1;
	while Game:GetTagPoint("GEN_SPAWN"..self.mspawncount) do
		self.mspawncount=self.mspawncount+1;
	end
	if (self.mspawncount > 1) then
		self.mspawncount = self.mspawncount-1;
	else
		System:Warning("** SURVIVAL ** No GEN_SPAWNx spots where x = 1 2 3 4");
		self.mspawncount = nil;
	end
	if (self.su_minmonsters==nil) then
		self.su_minmonsters = Game:GetTagPoint("MINIMUM_MONSTERS");
		if (self.su_minmonsters) then
			self.su_minmonsters = floor(self.su_minmonsters.z);
		else
			self.su_minmonsters = 7;
			System:Warning("** SURVIVAL ** MINIMUM_MONSTERS tag was not set for this map!");
		end
	end
end
local def_count = GameRules:GetPlayerTeamCount("players");
if (GameRules.bot_common) and (GameRules.bot_common.redsum) then
def_count = def_count + GameRules.bot_common.redsum;
end
def_count = floor(def_count/2); -- balance defenders/monsters out
def_count = def_count + GameRules:GetHandicap();
if (GameRules:GetMonstersCount() >= self.su_minmonsters+def_count) then
self.bakenewbeast = nil;
return;
end

self.bakenewbeast = _time + 3;

local mspawnpos = random(1,self.mspawncount);
mspawnpos = Game:GetTagPoint("GEN_SPAWN"..mspawnpos);
if (mspawnpos) then
	mspawnpos = {x=mspawnpos.x,y=mspawnpos.y,z=mspawnpos.z};
	local rndmonster = random(1,getn(self.su_Beastary));
	local newmonster=Game:GetEntityClassIDByClassName(self.su_Beastary[rndmonster][1]);
	newmonster= Server:SpawnEntity({classid=newmonster,pos=mspawnpos,name=self.su_Beastary[rndmonster][2],model=self.su_Beastary[rndmonster][3],});
	if (newmonster) then
		newmonster.bot_born = 1;
		newmonster.bot_killstreak = 0;
		newmonster.MUTANT = 1;
		newmonster.isbadmonster = 1;
		newmonster.cnt.health = 240;
		newmonster.vbot_ssid = newmonster.id;
		newmonster.PhoenixData = {pos = mspawnpos,angles = g_Vectors.v000,};
		if (newmonster.NEVER_FIRE) then
			newmonster.NEVER_FIRE = nil;
			newmonster.HASCLAWS = 1;
		end
		newmonster:TriggerEvent(AIEVENT_WAKEUP);
		local chooseyourgun;
		if (newmonster.ROCKET_ORIGIN_KEYFRAME) then
			chooseyourgun = random(1,getn(self.weapontable_c));
			chooseyourgun = self.weapontable_c[chooseyourgun];
		elseif (newmonster.HASCLAWS == nil) then
			chooseyourgun = random(1,getn(self.weapontable_g));
			chooseyourgun = self.weapontable_g[chooseyourgun];
		end
		if (chooseyourgun ~= nil) then
			if (chooseyourgun[1]=="RL") and (toNumberOrZero(getglobal("gr_norl"))==1) then
				if (newmonster.ROCKET_ORIGIN_KEYFRAME) then
					newmonster.survival_gun = WeaponClassesEx["MutantShotgun"].id;
				else
					newmonster.survival_gun = WeaponClassesEx["Shotgun"].id;
				end
			else
				newmonster.survival_gun = WeaponClassesEx[chooseyourgun[1]].id;
			end
			newmonster.cnt:MakeWeaponAvailable(newmonster.survival_gun);
			newmonster.cnt:SetCurrWeapon(newmonster.survival_gun);
			if (newmonster.ROCKET_ORIGIN_KEYFRAME) then
				newmonster.cnt:DrawThirdPersonWeapon(0);
			end
			newmonster.cnt.ammo_in_clip = chooseyourgun[2];
			newmonster.cnt.ammo = 999;
		end
		function newmonster:GoRefractive()
		end
		if (newmonster.GoVisible) then
			newmonster:GoVisible();
		end
		function newmonster:GetPlayerId()
			return self.id;
		end
		
		tinsert(GameRules.MonsterHorde,newmonster);
		
		function newmonster:DoSomethingInteresting()
			if (Mission) and (Mission.SU_Monster_Activity) then
				Mission:SU_Monster_Activity(self);
			end
			return 1;
		end
		
		chooseyourgun = toNumberOrZero(getglobal("bot_difficulty"));
		if (chooseyourgun < 1) or (chooseyourgun > 3) then
			chooseyourgun = 2;
			setglobal("bot_difficulty",2);
		end
		if (chooseyourgun == 1) then
			newmonster.Properties.accuracy = newmonster.Properties.accuracy * 0.6;
			newmonster.Properties.aggression = newmonster.Properties.aggression * 0.7;
		elseif (chooseyourgun == 3) then
			newmonster.Properties.accuracy = newmonster.Properties.accuracy * 1.2;
			newmonster.Properties.aggression = newmonster.Properties.aggression * 1.1;
		else
			newmonster.Properties.accuracy = newmonster.Properties.accuracy * 0.9;
			newmonster.Properties.aggression = newmonster.Properties.aggression * 1;
		end
		newmonster:ChangeAIParameter(AIPARAM_AGGRESION, newmonster.Properties.aggression);
		newmonster:ChangeAIParameter(AIPARAM_ACCURACY, newmonster.Properties.accuracy);
	end
end
end

function GameRules:CheckBonusCounter(shtr)
if (shtr.mp_bonuscounter >= 8) then
	local psl=Server:GetServerSlotByEntityId(shtr.id);
	shtr.mp_bonuscounter = shtr.mp_bonuscounter-8;
	if (shtr.Ammo["HealthPack"]) and (shtr.Ammo["HealthPack"]< 2) then
		shtr.Ammo["HealthPack"]=shtr.Ammo["HealthPack"]+1;
		if (psl) then
		psl:SendText("@su_bonus_h");
		end
	elseif (shtr.items.su_binocs == nil) then
		if (psl) then
		GameRules:TransferTheStatus(7,psl);
		shtr.items.su_binocs = 1;
		end
	elseif (shtr.items.su_nightvis == nil) then
		if (psl) then
		GameRules:TransferTheStatus(8,psl);
		shtr.items.su_nightvis = 1;
		end
	end
end
end

-- return 1=if interaction is accepted, otherwise nil
function GameRules:IsInteractionPossible(actor,entity)
	-- prevent a player who is in a vehicle from interacting with the entity
	if actor then
		if (actor.theVehicle) then
			return nil;
		end
		if (actor.ai) then
			return nil;
		end
		-- prevent corpses from interacting with something
		if (actor.cnt and actor.cnt.health and actor.cnt.health < 1) then
			return nil;
		end
		if (entity) and (entity.weapon) and (actor.su_LastRepTime) and (actor.su_LastRepTime > _time) then
			if (entity.Properties) and (entity.Properties.FadeTime) and (entity.Properties.FadeTime > 0) then
				-- actor is repairing something in survival gametype, let him finish his job and wait, preventing self from fade away
				entity:SetTimer(entity.Properties.FadeTime * 1000);
			end
			return nil;
		end
	end
	local iCurstate=self:GetGameState();
	if(iCurstate~=CGS_INPROGRESS)then
		return nil;
	end
	return 1;
end

function GameRules:SimulateMelee(slasher)
if (slasher.cnt.weapon) and (slasher.cnt.weapon.name == "Machete") then
else
	if (GameRules.insta_play) then
		-- protect machete from taking out by RailOnly Rules:
		slasher.cnt.lock_weapon=1;
	end
	slasher.cnt:MakeWeaponAvailable(WeaponClassesEx["Machete"].id);
	slasher.cnt:SetCurrWeapon(WeaponClassesEx["Machete"].id);
end
slasher:ChangeAIParameter(AIPARAM_AGGRESION,1);
slasher:InsertSubpipe(0,"scout_comeout");
end

function GameRules:ProvokeSIOspot(spot_no,atckr)
if (GameRules.sio_spots[spot_no]) then
	local si_dist = GameRules.sio_spots[spot_no]:GetPos();
	local siodist = atckr:GetDistanceFromPoint(si_dist);
	-- attacker must be located in the same environment as attacked object
	if (siodist < GameRules.sio_spots[spot_no].Properties.max_buildpoints) and (System:IsPointIndoors(si_dist) == System:IsPointIndoors(atckr:GetPos())) then
		siodist = GameRules.sio_spots[spot_no]:GetName();
		atckr:SelectPipe(0,"practice_shot",siodist.."_BLOW");
	end
end
end

function GameRules:CheckTheRound()
	if (self.su_roundnum) then
		self.su_roundnum = self.su_roundnum + 1;
		if (self.su_roundnum >= 999) then self.su_roundnum = 1; end
	else
		self.su_roundnum = 1;
	end
	local max_su_rounds = getglobal("gr_su_roundlimit");
	if (max_su_rounds) and (self.su_switchmap == nil) then
		max_su_rounds = floor(tonumber(max_su_rounds));
		if (max_su_rounds > 0) and (self.su_roundnum >= max_su_rounds) then
			self.su_switchmap = _time + 5;
			self.su_switchnow = 1;
			Server:BroadcastText("$1ROUND LIMIT HIT! CHANGING THE MAP...");
		end
	end
end

function GameRules:Srv_SwitchMap()
	if (self.su_switchnow) then
		self.su_switchnow = nil;
		local Map = MapCycle.MapList[MapCycle.iNextMap];
		if (Map) then
			if (SVplayerTrack) then
				GameRules:ChangeMap(Map.szName, Map.szGameType, Map.szTimeLimit, Map.szRespawnTime, Map.szInvulnerabilityTimer, Map.szMaxPlayers, Map.szMinTeamLimit, Map.szMaxTeamLimit);
			else
				GameRules:ChangeMap(Map.szName, Map.szGameType);
			end
		else
			-- restart the same map in SURVIVAL mode
			System:ExecuteCommand("sv_changemap "..getglobal("gr_NextMap").." SURVIVAL");
		end
	end
end

function GameRules:SurvivalManager()
if (GameRules.sm_nextcheck < _time) then
	GameRules.sm_nextcheck = _time + 10;
	-- monster horde check
	for i,ent in GameRules.MonsterHorde do
		if (i ~= "n") and (ent.cnt) and (not ent.cnt.moving) then
			local mytarget = AI:GetAttentionTargetOf(ent.id);
			if (mytarget) and (type(mytarget)=="table") then
			else
				local attract_to_sio = random(1,self.SIO_rush_factor);
				if (not self.badpspots) then
					self.badpspots = 1;
					while Game:GetTagPoint("MONSTER_P"..self.badpspots) do
						self.badpspots=self.badpspots+1;
					end
					if self.badpspots > 1 then
						self.badpspots=self.badpspots-1;
					else
						self.badpspots = 0;
						System:Warning("** SURVIVAL ** MONSTER_Px patrol tags were not set (where x is 1,2,3 etc )!");
					end
				elseif (ent.survival_gun) and (attract_to_sio == 1) and (self.sio_spots[1]) then
					if (self.sio_spots[2]) then
						attract_to_sio = random(1,2);
					end
					if (self.sio_spots[attract_to_sio].health > 0) then
					attract_to_sio = self.sio_spots[attract_to_sio]:GetName();
					ent:SelectPipe(0,"sio_get_in_position",attract_to_sio.."_BLOW");
					end
				elseif (self.badpspots > 0) then
					local rspot = random(1,self.badpspots);
					if (self.m_ppspot) and (self.m_ppspot == rspot) then
						rspot = rspot + 1;
						if (rspot > self.badpspots) then rspot = 1; end
					end
					ent.AI_CanWalk = 1;
					ent:MakeAlerted();
					ent:TriggerEvent(AIEVENT_WAKEUP);
					mytarget = random(1,4); -- 25% of running probability
					if (mytarget == 4) then
					ent:SelectPipe(0,"sio_get_in_position","MONSTER_P"..rspot);
					else
					ent:SelectPipe(0,"patrol_approach_to","MONSTER_P"..rspot);
					end
					AI:MakePuppetIgnorant(ent.id,0);
					self.m_ppspot = rspot;
				end
			end
		end
	end
	-- villagers check
	if (not self.villagers) then
		self.villagers = 0;
		local ents2 = System:GetEntities();
		for i, vill in ents2 do
			if (vill.isvillager) then
				self.villagers = self.villagers + 1;
				if (vill.my_potomok == nil) then
					local villreloc = Game:GetTagPoint(vill:GetName().."_RELOCATE");
					if (villreloc) then
						vill.isvillager.x = villreloc.x;
						vill.isvillager.y = villreloc.y;
						vill.isvillager.z = villreloc.z;
					else
						System:Warning("** SURVIVAL ** "..vill:GetName().."_RELOCATE tag was not found! This will cause dedicated server error!");
						System:Warning("** SURVIVAL ** After setting RELOCATE tag, move your npcs to inaccessible area of map, so they will be teleported from there!");
					end
					--vill:Event_Die();
					vill.cnt.health = 0;
					vill:OnReset();
				end
			elseif (vill.Properties) and (vill.Properties.max_buildpoints) and (vill.Properties.max_buildpoints~=0) then
				if (Game:GetTagPoint(vill:GetName().."_BLOW")~=nil) then
					vill.status = 1;
					vill.health = vill.Properties.max_hitpoints;
					tinsert(self.sio_spots,vill); -- it's a strategically important object!
				end
			end
		end
		GameRules:TransferTheStatus(6);
	end
	-- mission-specific check
	if (Mission) and (Mission.SU_OnCheck) then
		Mission:SU_OnCheck();
	end
end
if (self.sio_spots) and (self.sio_provoketime < _time) then
	if (self.sio_spots[1]) and (self.sio_spots[1].health > 0) then
	AI:FreeSignal(1,"SIO_SPOT_PROVOKING",self.sio_spots[1]:GetPos(),self.sio_spots[1].Properties.max_buildpoints);
	end
	if (self.sio_spots[2]) and (self.sio_spots[2].health > 0) then
	AI:FreeSignal(1,"SIO_SPOT_PROVOKING",self.sio_spots[2]:GetPos(),self.sio_spots[2].Properties.max_buildpoints);
	end
	self.sio_provoketime = _time + 3;
end
end

function GameRules:AddVillain()
	if (self.villains) then
		self.villains = self.villains + 1;
	else
		self.villains = 1;
	end
	GameRules:TransferTheStatus(0);
end

function GameRules:RemoveVillain()
	if (self.villains) then
		self.villains = self.villains - 1;
		if (self.villains <= 0) then
			self.villains = nil;
		end
	end
	GameRules:TransferTheStatus(0);
end

function GameRules:TransferTheStatus(s_flag,svslot)
	if (self.restartnow) then return; end
	local st_string = "TVC";
	if (self.villains) and (self.villains > 0) then
		-- the subjects to eliminate
		st_string = st_string.." -"..self.villains;
	elseif (self.villagers) then
		-- the subjects to rescue
		st_string = st_string.." "..self.villagers;
	else
		st_string = st_string.." n";
	end
	if (self.sio_spots[1]) and (self.sio_spots[1].status) then
		st_string = st_string.." "..self.sio_spots[1].status;
		if (self.sio_spots[1].health == 0) then
			s_flag = 2;
		end
	else
		st_string = st_string.." 0";
	end
	if (self.sio_spots[2]) and (self.sio_spots[2].status) then
		st_string = st_string.." "..self.sio_spots[2].status;
		if (self.sio_spots[2].health == 0) then
			s_flag = 2;
		end
	else
		st_string = st_string.." 0";
	end
	if (s_flag == 1) then
		st_string = st_string.." D"; -- vdead
	elseif (s_flag == 2) then
		st_string = st_string.." L"; --lose
		GameRules:CheckTheRound();
		if (self.su_switchmap == nil) then
			self.restartnow = _time + 6;
		else
			self.restartnow = _time + 5;
		end
	elseif (s_flag == 3) then
		st_string = st_string.." V"; --victory
		self.restartnow = _time + 8;
		GameRules:NewGameState(CGS_INTERMISSION);
	elseif (s_flag == 4) then
		st_string = st_string.." F "..GameRules.talkerid; --follow
	elseif (s_flag == 5) then
		st_string = st_string.." S "..GameRules.talkerid; -- stay here
	elseif (s_flag == 6) then
		st_string = st_string.." B"; -- briefing
	elseif (s_flag == 7) then
		st_string = st_string.." I"; -- binoculars
	elseif (s_flag == 8) then
		st_string = st_string.." N"; -- nv goggles
	end
	if (svslot) then
		svslot:SendCommand(st_string);
	else
		Server:BroadcastCommand(st_string);
	end
end

function GameRules:UsualDamageCalculation(hit)
	local target = hit.target;
	local shooter = hit.shooter;
	local damage = hit.damage;

	if (not shooter) then
		local ss_shooter=Server:GetServerSlotBySSId(hit.shooterSSID);
		if ss_shooter then
			shooter = System:GetEntity(ss_shooter:GetPlayerId());
		end
	end

	if (shooter==nil) then
		shooter=hit.target;
	end

	if (hit.explosion ~= nil) then
		local expl=target:IsAffectedByExplosion();
		if (expl<=0) then return end
		damage = expl * damage;
		hit.exp_stundmg = ceil(damage*0.2);
		BasicPlayer.SetBleeding(target,hit.exp_stundmg,damage,hit.shooterSSID);
		Server:BroadcastCommand("CHI "..shooter.id.." "..target.id.." "..damage);
	end

	if target==nil or target.type ~= "Player" or target.cnt.health<=0 then
		return nil;
	end
	
	local headshot;

	if (hit.target_material) then
	
		if (hit.pos) then ---- test headshot detector
			local hbonpos = target:GetBonePos("hat_bone");
			if (hbonpos) then
				hbonpos = {x = hit.pos.x - hbonpos.x, y = hit.pos.y - hbonpos.y, z = hit.pos.z - hbonpos.z};
				hbonpos = hbonpos.x * hbonpos.x + hbonpos.y * hbonpos.y + hbonpos.z * hbonpos.z;
				if (hbonpos < 0.08) then
					headshot=1;
					if tonumber(getglobal("gr_HeadshotMultiplier"))~= nil then
						damage=damage*tonumber(getglobal("gr_HeadshotMultiplier"));
					end
					hit.damage_type = "healthonly";
				end
			end
		end

		if (headshot) then
		elseif (damage == 300) then
			-- amplify sniper rifle hit for monster bodies. players get full damage even if hit in leg or arm. But armor protected.
			if (target.isbadmonster) and (not shooter.isbadmonster) then
				if (hit.target_material.type~="arm") and (hit.target_material.type~="leg") then
					damage = 405;
				end
			end
		-- players / npcs damage check. Ignore armor if being hit in arm/leg, but suffer less.
		elseif (target.Properties.species == 0) then
			if (hit.target_material.type=="arm") or (hit.target_material.type=="leg") then
				hit.damage_type = "healthonly";
				damage = damage * 0.4;
			end
		end
	end
	
	target.customdmgs = toNumberOrZero(getglobal("gr_customdamagescale"));
	if target.customdmgs > 0 then
		damage = damage * target.customdmgs;
	else
    		damage = damage * tonumber(gr_DamageScale);
    	end

	if (damage > 0) then
		--- apply damage first to armor, if it is present
		if (hit.damage_type ~= "healthonly") then
			if (target.cnt.armor > 0) then
				target.cnt.armor= target.cnt.armor - (damage*0.3);
				-- clamp to zero
				if (target.cnt.armor < 0) then
					damage = -target.cnt.armor;
					target.cnt.armor = 0;
				else
					damage = 0;
				end
			end
		end
	end
	
	target.cnt.health = target.cnt.health - damage;

	if(target.cnt.health>target.cnt.max_health) then
		target.cnt.health=target.cnt.max_health;
	end

	if target.cnt.health <= 0 then
		target.cnt.health = 0;
		if (headshot) then
			target.hedshot = 1;
		end
		target.Properties.equipDropPack = "";
		if (target.isbadmonster) then
			self.bakenewbeast = _time + 3;
			target.death_timestamp = _time + 30;
			target.PhoenixData = nil;
			target.OnReset = nil;
			for i, ent in GameRules.MonsterHorde do
				if (i ~= "n") then
					if (ent == target) then
						tremove(GameRules.MonsterHorde,i);
						break;
					end
				end
			end
			
			if (shooter.su_turretowner) and (shooter.su_turretowner.GetPlayerId) then
				local su_t_owner = System:GetEntity(shooter.su_turretowner:GetPlayerId());
				if (su_t_owner) and (su_t_owner.cnt) and (su_t_owner.cnt.score) then
					su_t_owner.cnt.score = su_t_owner.cnt.score + target.Properties.pathstart;
				end
			end
			
			if (shooter.mp_bonuscounter==nil) then shooter.mp_bonuscounter=1; else
			shooter.mp_bonuscounter = shooter.mp_bonuscounter+1; end
			
			if (headshot) and (shooter.Ammo["OICWGrenade"] < 4) then
				shooter.Ammo["OICWGrenade"] = shooter.Ammo["OICWGrenade"]+1;
			end
			
			if (target.cnt.weapon) then
				if (target.cnt.weapon.name=="Machete") then
					-- take out machete from claw simulation
					if (target.survival_gun) then
						target.cnt:SetCurrWeapon(target.survival_gun);
					else
						target.cnt:DeselectWeapon();
					end
				elseif (target.cnt.weapon.name=="MutantShotgun") and (target.ROCKET_ORIGIN_KEYFRAME) then
					target.cnt:DeselectWeapon();
					local pickup = target:GetPos();
					pickup.z = pickup.z + 1.05;
					pickup = Server:SpawnEntity("Armor",pickup);
					if (pickup) then
						pickup.Properties.Amount = random(25,65);
						if (GameRules.GetPickupFadeTime) then
							pickup:SetFadeTime(GameRules:GetPickupFadeTime());
						end
						pickup.autodelete = 1;
						pickup:EnableSave(0);
						pickup:GotoState("Dropped");
					end
				elseif (target.cnt.weapon.name=="RL") and (target.ROCKET_ORIGIN_KEYFRAME) then
					target.cnt:DeselectWeapon();
					local pickup = target:GetPos();
					pickup.z = pickup.z + 1.05;
					pickup = Server:SpawnEntity("AmmoRocket",pickup);
					if (pickup) then
						pickup.Properties.Amount = random(2,4);
						if (GameRules.GetPickupFadeTime) then
							pickup:SetFadeTime(GameRules:GetPickupFadeTime());
						end
						pickup.autodelete = 1;
						pickup:EnableSave(0);
						pickup:GotoState("Dropped");
					end
				end
			end

			shooter.cnt.score = shooter.cnt.score+target.Properties.pathstart;
			
			if (target.sio_attack_time) and (target.sio_attack_time > _time) then
				shooter.cnt.score = shooter.cnt.score + floor(target.Properties.pathstart*0.4);
				shooter.mp_bonuscounter = shooter.mp_bonuscounter+1;
			end
			GameRules:CheckBonusCounter(shooter);
			if (self.su_monsters_left) then
				self.su_monsters_left = self.su_monsters_left - 1;
				if (self.su_monsters_left <= 0) then
				GameRules:TransferTheStatus(3);
				end
			end
		elseif (target.my_potomok) then -- victim is survivor
			if (self.villagers) and (self.villagers > 0) then
				self.villagers = self.villagers - 1;
				if (self.villagers <= 0 and GameRules.bBypassSurvivors == nil) or (self.su_escortrules~=nil) then
				GameRules:TransferTheStatus(2);
				else
				GameRules:TransferTheStatus(1);
				end
			end
			shooter.cnt.score = shooter.cnt.score - 43;
			shooter.mp_bonuscounter = 0;
			local svvs = System:GetEntities();
			if (svvs) then
				for j,victim in svvs do
					if (victim.smell_factor) and (victim.cnt) and (victim.cnt.health > 0) then
						-- remaining survivors get sweaty, so let's increase smell factor:
						victim.smell_factor = victim.smell_factor + victim.smell_factor*0.16;
					end
				end
			end
		else -- victim is player
			if (shooter.id~=target.id) then
				shooter.cnt.score = shooter.cnt.score - 21;
			end
			if (target.cnt.score) and (target.cnt.score > 24) then
				target.cnt.score = target.cnt.score - 25; -- revival pay-off
			end

			if (target.Ammo["Def_Sentry"]) and (target:GetAmmoAmount("Def_Sentry")>0) then
				local pickup = target:GetPos();
				pickup.z = pickup.z + 1.05;
				pickup = Server:SpawnEntity("PickupADT",pickup);
				if (pickup) then
					pickup:SetFadeTime(90);
					pickup.autodelete = 1;
					pickup.not_for_ai = 1;
					pickup:EnableSave(0);
					pickup:GotoState("Dropped");
				end
			end
		end
		if shooter.id==target.id or shooter.type ~= "Player" then 
			return 2;
		else
			return 1;
		end
	end

	return nil;
end

-- follow me / stay here command
GameRules.ClientCommandTable["SUFM"]=function(String,server_slot,toktable)
	if (count(toktable) > 2) then
		server_slot:SendText("$1YOUR VERSION OF MOD MISMATCHES SERVER VERSION, PLEASE UPDATE!",3);
		return;
	end
	local vnpc = System:GetEntity(toktable[2]);
	local vleader = System:GetEntity(server_slot:GetPlayerId());
	if (vnpc) and (vleader) and (vnpc.cnt.health > 0) then
		-- Additional server-side check, prevents cheating,
		-- because client can modify maximum distance to call villagers from entire map :))
		if (vnpc.isvillager) and (vnpc:GetDistanceFromPoint(vleader:GetPos()) < 2.1) then
			GameRules.talkerid = vleader.id;
			if (vnpc.my_leader) then
				vnpc:JustStayHere();
				GameRules:TransferTheStatus(5);
			else
				vnpc.my_leader = vleader.id;
				GameRules:TransferTheStatus(4);
			end
			GameRules.talkerid = nil;
		end
	end
end

GameRules.states.INPROGRESS={
	OnBeginState=function(self)
		GameRules.sm_nextcheck = _time + 4;
		GameRules:StartGameRulesLibTimer();
		GameRules:ResetMapEntities();
		self.su_minmonsters = nil;
		self.su_monsters_left = nil;
		self.su_escortrules = Game:GetTagPoint("ESCORT_HERE");
		self.sio_provoketime = _time+20;
		self.bakenewbeast = _time + 8;
		self.mapstart = _time;
		self.mspawncount = nil;
		self.restartnow = nil;
		self.badpspots = nil;
		self.villagers = nil;
		self.villains = nil;
		self.sio_spots = {};
		self.su_Beastary = {
			{"MutantMonkey","Small Klaw","Objects/characters/Mutants/Mutant_Aberration3/mutant_aberration3.cgf"},
			{"MutantBezerker","Mutated Klaw","Objects/characters/Mutants/Mutant_Aberration/mutant_aberration.cgf"},
			{"MutantScout","Alien Scout","Objects/characters/Mutants/mutant_fast/mutant_fast.cgf"},
			{"MutantRear", "Alien Rear","Objects/characters/Mutants/mutant_stealth/mutant_stealth_norockets.cgf"},
			{"MercRear", "Alien Demolisher","Objects/characters/Mutants/mutant_stealth/mutant_stealth.cgf"},
			{"MutantCover","Heavy Brute","Objects/characters/mutants/Mutant_big/Mutant_big.cgf"},
		};
		-- Generic weapon table with their starting amount
		self.weapontable_g = {
			{"Chaingun",100},
			{"Shotgun",10},
			{"P90",50},
			{"M4",30},
			{"AK74",30},
			{"M249",80},
			{"G11",40},
			{"SniperRifle",5},
			{"MP5",30},
			{"AG36",30},
			{"OICW",40},
			{"RL",1},
			{"Falcon",8},
		};

		self.weapontable_c = {
			{"Chaingun",100},
			{"RL",2},
			{"MutantShotgun",5},
		};

		if (not GameRules._cisc_suai) then
			GameRules._cisc_suai = 1;
			AI:CreateGoalPipe("sio_get_in_position");
			AI:PushGoal("sio_get_in_position","setup_combat");
			AI:PushGoal("sio_get_in_position","acqtarget",1,"");
			AI:PushGoal("sio_get_in_position","pathfind",1,"");
			AI:PushGoal("sio_get_in_position","trace",1,1);
		end

		if (Game:IsClient()) then
			-- listen srv
			setglobal("game_Accuracy",1);
			setglobal("game_Aggression",1);
		else
			-- dedicated server
			setglobal("game_Accuracy",0.7);
			setglobal("game_Aggression",0.8);
		end
		setglobal("game_Health",1);

		if getglobal("gr_su_handicap") == nil then
			Game:CreateVariable("gr_su_handicap",0);
		else
			Game:CreateVariable("gr_su_handicap",getglobal("gr_su_handicap"));
		end
		
		if getglobal("gr_su_roundlimit") == nil then
			Game:CreateVariable("gr_su_roundlimit",0);
		else
			Game:CreateVariable("gr_su_roundlimit",getglobal("gr_su_roundlimit"));
		end

		if (Mission) then
			if (Mission.SU_Beastarium) then
				-- use mission-specific monster table
				self.su_Beastary = Mission.SU_Beastarium;
			end
			if (Mission.SU_Weaponry_g) then
				-- use mission-specific common weapons set
				self.weapontable_g = Mission.SU_Weaponry_g;
			end
			if (Mission.SU_Weaponry_c) then
				-- use mission-specific cover weapons set
				self.weapontable_c = Mission.SU_Weaponry_c;
			end
			if (Mission.SU_OnReset) then
				Mission:SU_OnReset();
			end
		end

		AIBehaviour.DEFAULT.SIO_SPOT_PROVOKING = function (self,entity,sender)
		if (not entity.isbadmonster) then return end;
		if (entity.HASCLAWS) then return end;
		if (entity.cnt.health > 0) then
			GameRules:ProvokeSIOspot(1,entity);
			GameRules:ProvokeSIOspot(2,entity);
		end
		end;

		local slots = Server:GetServerSlotMap();
		if (not slots) then return end;
		for i, slot in slots do
			local ent = System:GetEntity(slot:GetPlayerId());
			slot:ResetPlayTime();
		end
		GameRules:ScoreboardUpd();
	end,

	OnUpdate=function(self)
		if (MapCycle:IsShowingScores()) then
			return;
		end
		if (self.bakenewbeast) and (self.bakenewbeast < _time) then
			GameRules:GenerateMonster();
		end
		GameRules:SurvivalManager();
		---------------
		if (self.restartnow) then
			if (self.restartnow < _time) then
				if (self.su_switchmap) then
					self:GotoNextMap();
				else
					GameRules:DoRestart();
				end
			elseif (self.su_switchmap) and (self.su_switchmap < _time+2) then
				GameRules:Srv_SwitchMap();
			end
		end
		---------------
		if (self.timelimit) then
			if (tonumber(self.timelimit)>0) then
			if _time>self.mapstart+tonumber(self.timelimit)*60 then
				if (self.su_escortrules) or (GameRules.SU_NegativeTimeout) then
					GameRules:TransferTheStatus(2);
				else
					GameRules:TransferTheStatus(3);
				end
			end
			elseif (not self.su_monsters_left) and (self.su_minmonsters) then
				self.su_monsters_left = self.su_minmonsters+GameRules:GetHandicap();
			end
		end
	end,
	OnTimer=function(self)
		self:DoGameRulesLibTimer();		
	end,
	OnDamage=GameRules.INPROGRESS_OnDamage,
	OnKill=function(self,server_slot)
		local id = server_slot:GetPlayerId();
	    if id ~= 0 then
	        local ent = System:GetEntity(id);
	 		local team = Game:GetEntityTeam(id);
	        if team ~= "spectators" then
	            self:OnDamage({ target = ent, shooter = ent, damage = 1000, ipart = 0 });
	        end
	    end
	end,
}
GameRules.states.INTERMISSION={
	OnBeginState=function(self)
		self.im_spot = nil;
		GameRules:ForceScoreBoard(1);
		local fs_spot = System:GetEntityByName("INTERMISSIONCAMERA");
		if (fs_spot) then
			local slots = Server:GetServerSlotMap();
			if (not slots) then return end;
			for i, slot in slots do
			local ent = System:GetEntity(slot:GetPlayerId());
			if (ent) then
				if (ent.theVehicle) then
					VC.EveryoneOutForce(ent.theVehicle);
				end
				if (ent.cnt) and (ent.cnt.weapon) then
					ent.cnt:DeselectWeapon();
				end
			end
			end
			self.im_spot = new(fs_spot:GetPos());
		end
		GameRules:CheckTheRound();
	end,
	OnUpdate=function(self)
	if (self.im_spot) then
		local slots = Server:GetServerSlotMap();
		if (slots) then
			for i, slot in slots do
				local ent = System:GetEntity(slot:GetPlayerId());
				if (ent) then
					ent:SetPos(self.im_spot);
				end
			end
		end
	end
	if (self.su_switchmap) then
		GameRules:Srv_SwitchMap();
		if (self.su_switchmap < _time) then
			self.su_switchmap = nil;
			self:GotoNextMap();
		end
	elseif (self.restartnow) then
		if (self.restartnow < _time) then
			self.restartnow = nil;
			GameRules:DoRestart();
		end
	else
		self.su_switchmap = _time + 5;
		--Hud:AddMessage("map switching has more priority than victory");
	end
	end,
}
