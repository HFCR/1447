--FAR CRY script file
--FFA GameRules
--Created by Alberto Demichelis
--modified by MartinM
--modified by MarcoK
--modified by MarcioM
--Modified/optimised By Mixer

Script:LoadScript("SCRIPTS/MULTIPLAYER/VotingState.lua");
Script:LoadScript("SCRIPTS/MULTIPLAYER/MultiplayerClassDefiniton.lua");		-- global MultiplayerClassDefiniton
Script:LoadScript("scripts/FFA/shared.lua");

GameRules={
	InitialPlayerProperties = MultiplayerClassDefiniton.DefaultMultiPlayer,
	respawndelay = 3,
	timelimit=getglobal("gr_TimeLimit"),			-- might be a string/number or nil/0 when not used
	states={},
	player_to_player_damage = { 3, 1, 1, 0.5, 0.5, 0.5 },
	Arm2BodyDamage = .75,
	Leg2BodyDamage = 1,
	fBullseyeDamageLevel =  20,		-- amount of damage until the 
	fBullseyeDamageDecay = 0.5,		-- X units of damage lost per second
}
setglobal("gr_InvulnerabilityTimer",1);
GameRules.bShowUnitHightlight=nil;
GameRules.InitialPlayerProperties.armor=0;
GameRules.InitialPlayerProperties.health=220;
GameRules.InitialPlayerProperties.model="Objects/characters/pmodels/hero/hero.cgf";

Script:LoadScript("SCRIPTS/MULTIPLAYER/GameRulesLib.lua");	-- derive from class bases game rules

function GameRules:ScoreboardUpd()
	local SlotMap=Server:GetServerSlotMap();
	
	for i, Slot in SlotMap do
		local Player = GetSlotPlayer(Slot);
		
		if Player and Player.cnt then
			local ClientId = Slot:GetId();
			
			if (Player.cnt.score) then
				self:SetScoreboardEntryXY(ScoreboardTableColumns.iScore,ClientId,Player.cnt.score);
			else
				self:SetScoreboardEntryXY(ScoreboardTableColumns.iScore,ClientId,0);
			end
			
			if (Player.cnt.deaths) then
				self:SetScoreboardEntryXY(ScoreboardTableColumns.iDeaths,ClientId,Player.cnt.deaths);
			else
				self:SetScoreboardEntryXY(ScoreboardTableColumns.iDeaths,ClientId,0);
			end

			local iTemp=Game:GetEntityTeam(Player.id);

			if (iTemp) then
				if iTemp== "spectators" then
					iTemp = 0;
				elseif iTemp== "players" then
					iTemp = 1;
				end
				self:SetScoreboardEntryXY(ScoreboardTableColumns.iPlayerTeam,ClientId,iTemp);
			end

			if Slot.Statistics and Slot.Statistics["nSelfKills"] then
				self:SetScoreboardEntryXY(ScoreboardTableColumns.iSuicides,ClientId,Slot.Statistics["nSelfKills"]);
			else
				self:SetScoreboardEntryXY(ScoreboardTableColumns.iSuicides,ClientId,0);
			end
			
			iTemp = Slot:GetName();
			self:SetScoreboardEntryXY(ScoreboardTableColumns.sName,ClientId,iTemp);
		end
	end
end

function GameRules:OnInit()
	System:Log("$5GameRules Init: "..self:ModeDesc());
	MessageTrack = {};
	Server:RemoveTeam("players");
	e_deformable_terrain=0;
	self.mapstart = _time;
	Server:AddTeam("players");
	CreateStateMachine(self);
	self.voting_state=VotingState:new();
	if (tostring(getglobal("gr_PrewarOn"))=="1") then
		setglobal("gr_PrewarOn","0");
	end
end

function GameRules:SetCoopMission(mId,slot)
	local tstring = mId * 1;
	GameRules.coop_mission = mId * 1;
	
	if (Mission) and (Mission.OnCoopSetMission) then
		tstring = Mission:OnCoopSetMission(mId);
	end
	if (tstring) then
		if (slot) then
			slot:SendCommand("TCS "..tstring);
		else
			Server:BroadcastCommand("TCS "..tstring);
		end
	end
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
			
			if (server_slot.coop_equipment) and (GameRules.mapstart+3 < _time) then
				local packid = server_slot:GetId();
				EquipPacks["coop_player_"..packid] = server_slot.coop_equipment;
				newent.Properties.equipEquipment = "coop_player_"..packid;
				if (server_slot.coop_keys) then
					newent.keycards = server_slot.coop_keys;
				end
				if (server_slot.coop_explo) then
					newent.explosives = server_slot.coop_explo;
				end
				if (server_slot.coop_objs) then
					newent.objects = server_slot.coop_objs;
				end
			else
				server_slot.coop_equipment = nil;
				server_slot.coop_keys = nil;
				server_slot.coop_explo = nil;
				server_slot.coop_objs = nil;
				newent.Properties.equipEquipment = locInitialPlayerProperties.equipEquipment;
			end

			newent.sCurrentPlayerClass=locInitialPlayerProperties.sPlayerClass;		-- to identify class name
			Server:BroadcastCommand("YCN "..server_slot:GetPlayerId().." DefaultMultiPlayer");
			BasicPlayer.InitAllWeapons(newent,1);
		end

		if (gr_InvulnerabilityTimer~=nil and toNumberOrZero(gr_InvulnerabilityTimer)>0) then
			newent.invulnerabilityTimer=toNumberOrZero(gr_InvulnerabilityTimer);
			Server:BroadcastCommand("FX", g_Vectors.v000, g_Vectors.v000, newent.id, 2);
		end
	
		newent.cnt.alive=1;
		newent:EnablePhysics(1);
		newent:SetViewDistRatio(255);
		
		if (team ~= "spectators") then
			if self.bShowUnitHightlight then
				local highlightpos=new(newent:GetPos());
				local highlight = Server:SpawnEntity("UnitHighlight",highlightpos);
				newent.idUnitHighlight = highlight.id; -- only done on the server
				-- send "follow this player" command
				Server:BroadcastCommand("FX "..tonumber(newent.id), g_Vectors.v000, g_Vectors.v000,highlight.id,0);
			end
			if (GameRules.coop_mission) then
				GameRules:SetCoopMission(GameRules.coop_mission*1,server_slot);
			else
				GameRules:SetCoopMission(1,server_slot);
			end
			server_slot:SendCommand("GI WS");
		end
	end
end

-- For Server Browsers
-- Refer to GetPlayerStats in QueryHandler.lua for more info

function GameRules:GetPlayerStats()
	local SlotMap = Server:GetServerSlotMap();
	local Stats = {};
	local j = 1; -- to make it 1..n because SlotMap is 0..n-1
	
	for i, Slot in SlotMap do
		Stats[j] = {};
		local PlayerEnt = System:GetEntity(Slot:GetPlayerId());
		Stats[j].Name = Slot:GetName();
		Stats[j].Team = Game:GetEntityTeam(Slot:GetPlayerId());
		Stats[j].Skin = "";
		if (PlayerEnt and PlayerEnt.cnt) then
			Stats[j].Score = PlayerEnt.cnt.score * 1;
		else
			Stats[j].Score = 0;
		end
		Stats[j].Ping = Slot:GetPing();
		Stats[j].Time = floor(Slot:GetPlayTime() / 60).."m";
		j = j + 1;
	end
	
	-- Mixer: do the same for bots (test) :D
	SlotMap = System:GetEntities();
	for i, slot in SlotMap do
		if (slot.type=="Player") and (slot.death_timestamp==nil) then
			Stats[j] = {};
			Stats[j].Name = slot:GetName();
			Stats[j].Team = Game:GetEntityTeam(slot.id);
			Stats[j].Skin = "";
			if (slot.cnt) and (slot.cnt.score) then
				Stats[j].Score = slot.cnt.score * 1;
			else
				Stats[j].Score = 0;
			end
			Stats[j].Ping = "BOT";
			Stats[j].Time = "0m";
			j = j + 1;
		end
	end

	return Stats;
end

function GameRules:OnAfterLoad()
	self:ResetMapEntities();	
end

-- This function is called whenever the server needs to return a packet containing
-- a description of the current Game: since a "mod" can contain multiple modes, this
-- should be taken into account here. the string should be relatively short.
function GameRules:ModeDesc()
    return "COOP";
end


function GameRules:DoRestart()

	self.restartbegin = nil;
	self.restartend = nil;
	self.mapstart=_time;

	GameRules.coop_checktimer = _time + 3;
	GameRules.coop_moodtimer = _time + 3;
	GameRules.coop_mission = nil;
	GameRules.coop_mission_all = nil;
	GameRules.coop_spawn_object_id = nil;
	GameRules.coop_checkpoint = nil;

	self:ResetPlayerScores(0, 0);
	self:NewGameState(CGS_INPROGRESS);								-- is calling self:ResetMapEntities()
	-- UpdateTimeLimit has to be after NewGameState because this is reseting the leveltime
	self:UpdateTimeLimit(getglobal("gr_coop_timelimit"));
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
		slasher:ChangeAIParameter(AIPARAM_AGGRESION,1);
		slasher:InsertSubpipe(0,"scout_comeout");
	end
end

-- stats for respawning
function GameRules:GetInitialPlayerProperties(server_slot)
	return self.InitialPlayerProperties;
end

-- callback for when the player uses the "team" console command
function GameRules:OnClientJoinTeamRequest(server_slot,team)
	GameRules:HandleJoinTeamRequest(server_slot,team);
end

-- callback for the "vote" console command, which casts an actual vote
-- if this vote causes a majority on "yes", execute the "game command"
-- that was voted on
function GameRules:OnVote(server_slot, vote)
	self.voting_state:OnVote(server_slot, vote);
end

function GameRules:CoopBeam(tpdest)
	local tp1 = Game:GetTagPoint(tpdest);
	if (tp1) then
		local ents = System:GetEntities()
		for i,ent in ents do
			if (ent.cnt) and (ent.type) and (ent.type=="Player") and (ent.cnt.health > 0) and (not ent.ai) then
				ent:SetPos(tp1);
			end
		end
	end
end

function GameRules:TaskForBot(entity)
	if (entity.coop_beacon) then
		if (AIBehaviour.TestBotIdle:SMART_GO(entity,entity.coop_beacon)==nil) then
			-- use DUMB GO METHOD :)
			entity:SelectPipe(0,"bot_roam",entity.coop_beacon);
		end
		return 3;
	end
	local retval = random(1,4);
	if (retval>=3) then
		-- Mixer: make paths for bots named
		-- coop_path_start (for start respawn spot)
		-- coop_path_x (where x is gameevent's id)
		-- as well as tag point with same name in the end of each path
		-- every path should trace bot from the respawn spot to the next respawn spot

		local pathid = "start";
		if (GameRules.coop_checkpoint) then
			pathid = GameRules.coop_checkpoint - 1;
		end
		
		if (retval == 3) then
			if (AIBehaviour.TestBotIdle:SMART_GO(entity,"coop_path_"..pathid)==nil) then
				-- use DUMB GO METHOD :)
				entity:SelectPipe(0,"bot_roam","coop_path_"..pathid);
			end
		else
			AI:CreateGoalPipe("coop_path");
			AI:PushGoal("coop_path","pathfind",1,"coop_path_"..pathid);
			AI:PushGoal("coop_path","trace",1,1);
			entity:SelectPipe(0,"coop_path");
			entity:InsertSubpipe(0,"setup_combat");
		end
	end
	return retval;
end

function GameRules:UsualDamageCalculation(hit)
    local theTarget = hit.target;
    local theShooter = hit.shooter;

	if (theTarget) then
		if (theTarget.type == "Player" ) then
			theTarget.hedshot=nil;
			theTarget.LastDamageDoneByPlayer=nil;
			if (hit.shooterSSID) then
				theShooter = Server:GetServerSlotBySSId(hit.shooterSSID);
				if (theShooter) then
					theShooter = theShooter:GetPlayerId();
					if (theShooter) then
						theShooter = System:GetEntity(theShooter);
					end
				end
			end
			if (not theShooter) then
				theShooter = theTarget;
			end
			-- determine correct damage modifier table
			if (theTarget.ai) then
				--GameRules.player_to_player_damage;
				-- used for Autobalancing
				theTarget.LastDamageDoneByPlayer=1;
			end

			if (hit.explosion ~= nil ) then
				local expl=theTarget:IsAffectedByExplosion();
				if (expl<=0) then return end
				hit.damage= expl * hit.damage * GameRules.player_to_player_damage[6];
				hit.damage_type = "normal";
				hit.exp_stundmg = ceil(hit.damage*0.45);
				BasicPlayer.SetBleeding(theTarget,hit.exp_stundmg,hit.damage,hit.shooterSSID);
				Server:BroadcastCommand("CHI "..theTarget.id.." "..theTarget.id.." "..hit.damage);
			end
			local dmgf = 1;
			if (hit.target_material ~= nil ) then
				local	targetMatType = hit.target_material.type;
				-- proceed protection gear
				if (targetMatType=="helmet") then
					if (theTarget.hasHelmet == 0) then
						hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_head"));
						targetMatType = hit.target_material.type;
					else
						BasicPlayer.HelmetHitProceed(theTarget, hit.dir, hit.damage);
						dmgf = 0.05;
					end
				elseif (targetMatType=="armor") then
					if(theTarget.Properties.bHasArmor == 0) then
						hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_flesh"));
						targetMatType = hit.target_material.type;
					else
						dmgf = 0.0;
					end
				elseif (targetMatType=="bullseye") then
					dmgf = 0.0;
					-- do damage decay stuff
					if (theTarget.bullseyeTime == nil) then
						theTarget.bullseyeTime = _time;
					end
					
					-- calculate the amount of time passed
					local timeSpan = _time - theTarget.bullseyeTime;
					local bullseyeDamage = 0;
					
					if (theTarget.bullseyeDamage ~= nil) then
						bullseyeDamage = theTarget.bullseyeDamage;
					end
					
					-- subtract the damage decay
					bullseyeDamage = bullseyeDamage - GameRules.fBullseyeDamageDecay * timeSpan;
					
					-- clamp to 0
					if (bullseyeDamage < 0) then
						bullseyeDamage = 0;
					end
					
					-- add current damage (use flesh damage factor -> dmgTable[3])
					bullseyeDamage = bullseyeDamage + hit.damage * GameRules.player_to_player_damage[3];
					
					-- decide if damagelevel is high enough
					if (bullseyeDamage > GameRules.fBullseyeDamageLevel) then
						theTarget.bullseyeDamage = nil;
						theTarget.bullseyeTime = nil;
						AI:Signal(0,1,"HIT_THE_SPOT",theTarget.id);
					else
						theTarget.bullseyeDamage = bullseyeDamage;
						theTarget.bullseyeTime = _time;
					end
				end
				
				if (theTarget.hastits) and (hit.ipart) and (hit.ipart == 9) then ---- test headshot detector
					hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_head"));
				end

				if (targetMatType=="arm") then
					dmgf = GameRules.player_to_player_damage[4];
					hit.damage_type = "healthonly";
					dmgf = dmgf * GameRules.Arm2BodyDamage;
				elseif (targetMatType=="leg") then
					dmgf = GameRules.player_to_player_damage[5];
					hit.damage_type = "healthonly";
					dmgf = dmgf * GameRules.Leg2BodyDamage;
				elseif (targetMatType=="head") then
					dmgf = GameRules.player_to_player_damage[1];
					if (theTarget.items) and (theTarget.items.kevlarhelmet) then
						if (theTarget.cnt.armor == 0) then
							theTarget.items.kevlarhelmet = nil;
							hit.damage_type = "healthonly";
						end
					else
						hit.damage_type = "healthonly";
					end
					theTarget.hedshot = 1;
				elseif (targetMatType=="flesh") then
					dmgf = GameRules.player_to_player_damage[3];
				elseif (targetMatType=="heart") then
					dmgf = GameRules.player_to_player_damage[2];
					hit.damage_type = "healthonly";
				end
			else
				if (hit.landed) and (hit.landed == 1) then
				else
					dmgf = 0;
				end
			end
			-------GameRules:ApplyDamage(theTarget, hit.damage*dmgf, hit.damage_type);
			hit.damage = hit.damage * dmgf;
			
			-----------
			if (hit.damage > 0) then
				-- apply damage first to armor, if it is present
				-- Mixer: more random factor, armor is a bit more tough, but
				-- don't protects the arms/legs/head more!
				if (hit.damage_type ~= "healthonly") then
					if (theTarget.cnt.armor > 0) then
						theTarget.cnt.armor = theTarget.cnt.armor - (hit.damage * 0.4);
						-- clamp to zero
						if (theTarget.cnt.armor < 0) then
							hit.damage = -theTarget.cnt.armor+hit.damage*0.1;
							theTarget.cnt.armor = 0;
						else
							hit.damage = hit.damage*0.1;
						end
					end
				end
			end
			theTarget.cnt.health = theTarget.cnt.health - hit.damage;

			-- negative damage (medic tool) is is bounded to max_health
			if (theTarget.cnt.health>theTarget.cnt.max_health) then
				theTarget.cnt.health=theTarget.cnt.max_health;
			end

			if (theTarget.cnt.health <= 0) then
				theTarget.cnt.health = 0;
				if (theTarget.cnt.weapon) then
					if (theTarget.Properties.KEYFRAME_TABLE) and (theTarget.Properties.KEYFRAME_TABLE == "MUTANT_BIG") then
						theTarget.cnt:DeselectWeapon();
					elseif (theTarget.cnt.weapon.name == "Machete") then
						-- take out machete from claw simulation
						if (theTarget.survival_gun) then
							theTarget.cnt:SetCurrWeapon(theTarget.survival_gun);
						else
							theTarget.cnt:DeselectWeapon();
						end
					end
				end
				if (theTarget.ai == nil) then
					local targetslot = Server:GetServerSlotByEntityId(theTarget.id);
					local amomult = tonumber(getglobal("gr_coop_ammo_mult"));
					if (amomult < 1) then
						amomult = 1;
					else
						amomult = floor(amomult);
					end
					if (targetslot) then
						if (theTarget.cnt) and (theTarget.cnt.GetWeaponsSlots) then
							local wslots = theTarget.cnt:GetWeaponsSlots();
							if (wslots) then
								targetslot.coop_equipment = {};
								targetslot.coop_eqnum = 0;
								for i,val in wslots do
									if (val~=0) then
										if (theTarget.cnt.weapon) and (theTarget.cnt.lock_weapon or theTarget.fireparams.vehicleWeapon) and (theTarget.cnt.weapon.name==val.name) then
											-- Mixer: don't add mounted weapons to the weapons list :)
											-- or player will respawn with unlimited MG for example XD
										else
											targetslot.coop_eqnum = targetslot.coop_eqnum + 1;
											targetslot.coop_equipment[targetslot.coop_eqnum] = { Type="Weapon", Name=val.name.."", };
											if (theTarget.cnt.weapon) and (theTarget.cnt.weapon.name==val.name) then
												targetslot.coop_equipment[targetslot.coop_eqnum].Primary = 1;
											end
										end
									end
								end
								targetslot.coop_equipment.Ammo={
									Battery=0,
									Pistol=24 * amomult,
									SMG=50 * amomult,
									Assault=40 * amomult,
									Sniper=5 * amomult,
									Minigun=0,
									Shotgun=10 * amomult,
									Caseless47=45 * amomult,
									Grenades=0,
									HandGrenade=0,
									Rock=0,
									FlashbangGrenade=0,
									GlowStick=0,
									SmokeGrenade=0,
									FlareGrenade=0,
									Rocket=0,
									OICWGrenade=0,
									AG36Grenade=0,
									StickyExplosive=0,
									HealthPack=0,
									VehicleMG=0,
									VehicleRocket=0,
									RailStick=8 * amomult,
									Def_Sentry=0,
								};
								if (toNumberOrZero(getglobal("gr_bleeding"))~=0) then
									targetslot.coop_equipment.Ammo.Bandage=1;
								end
								if (theTarget.items.heatvisiongoggles) then
									targetslot.coop_eqnum = targetslot.coop_eqnum + 1;
									targetslot.coop_equipment[targetslot.coop_eqnum] = { Type="Item", Name = "PickupHeatVisionGoggles", };
								end
								if (theTarget.cnt.has_binoculars) and (theTarget.cnt.has_binoculars == 1) then
									targetslot.coop_eqnum = targetslot.coop_eqnum + 1;
									targetslot.coop_equipment[targetslot.coop_eqnum] = { Type="Item", Name = "PickupBinoculars", };
								end
								if (theTarget.cnt.has_flashlight) and (theTarget.cnt.has_flashlight == 1) then
									targetslot.coop_eqnum = targetslot.coop_eqnum + 1;
									targetslot.coop_equipment[targetslot.coop_eqnum] = { Type="Item", Name = "PickupFlashlight", };
								end
								
								targetslot.coop_keys = nil;
								targetslot.coop_explo = nil;
								targetslot.coop_objs = nil;
								
								if (theTarget.keycards) then
									targetslot.coop_keys = theTarget.keycards;
									-- Mixer: let's add keycards for clients (see initallweapons in basicplayer.lua)
								end
								if (theTarget.explosives) then
									targetslot.coop_explo = theTarget.explosives;
									-- Mixer: let's add explocount for clients (see initallweapons in basicplayer.lua)
								end
								if (theTarget.objects) then
									targetslot.coop_objs = theTarget.objects;
								end
							end
						end
					elseif (theTarget.POTSHOTS) then
						theTarget.Properties.my_Ammo={
							Battery=0,
							Pistol=24 * amomult,
							SMG=50 * amomult,
							Assault=40 * amomult,
							Sniper=5 * amomult,
							Minigun=0,
							Shotgun=10 * amomult,
							Caseless47=45 * amomult,
							Grenades=0,
							HandGrenade=0,
							Rock=0,
							FlashbangGrenade=0,
							GlowStick=0,
							SmokeGrenade=0,
							FlareGrenade=0,
							Rocket=0,
							OICWGrenade=0,
							AG36Grenade=0,
							StickyExplosive=0,
							HealthPack=0,
							VehicleMG=0,
							VehicleRocket=0,
							RailStick=8 * amomult,
							Def_Sentry=0,
						};
						if (toNumberOrZero(getglobal("gr_bleeding"))~=0) then
							theTarget.Properties.my_Ammo.Bandage=1;
						end
						theTarget.Properties.my_Eqnum = 0;
						theTarget.Properties.my_Equip = {};
						local wslots = theTarget.cnt:GetWeaponsSlots();
						if (wslots) then
							for i,val in wslots do
								if (val~=0) then
									if (theTarget.cnt.weapon) and (theTarget.cnt.lock_weapon or theTarget.fireparams.vehicleWeapon) and (theTarget.cnt.weapon.name==val.name) then
										-- Mixer: don't add mounted weapons to the weapons list :)
										-- or player will respawn with unlimited MG for example XD
									else
										theTarget.Properties.my_Eqnum = theTarget.Properties.my_Eqnum + 1;
										theTarget.Properties.my_Equip[theTarget.Properties.my_Eqnum] = { Type="Weapon", Name=val.name.."", };
										if (theTarget.cnt.weapon) and (theTarget.cnt.weapon.name==val.name) then
											theTarget.Properties.my_Equip[theTarget.Properties.my_Eqnum].Primary = 1;
										end
									end
								end
							end
						end
					end
				end
				if (theShooter == theTarget) or (theShooter.type ~= "Player") then
					return 2; -- player shot self
				elseif (theShooter.ai == nil) and (theTarget.ai == nil) then
					return 3; -- player shot teammate
				else
					return 1; -- player was killed by enemy
				end
			end
		end
	end
end

function GameRules:INPROGRESS_OnDamage(hit)
	-- fixed/improved by Jeppa, improved by Mixer
	local damage_ret=self:UsualDamageCalculation(hit);
	if damage_ret then
		local target = hit.target;
		local shooter = hit.shooter;
		-- we have a kill, so drop the guys weapon
		local weapon = target.cnt.weapon;
		if (weapon) then
			BasicWeapon.Server.Drop( weapon, {Player = target, suppressSwitchWeapon = 1} );
		end
		damage_ret = self:UsualScoreCalculation(hit,damage_ret);
		GameRules:ScoreboardUpd();
		-- Mixer: check for winner if score limit is defined
		if (damage_ret) and (damage_ret > 0) then
			local gscorelim = tonumber(getglobal("gr_ScoreLimit"));
			if (gscorelim) and (gscorelim > 0) then
				if (not hit.shooter) and (hit.shooterSSID) then
					local ss_shooter=Server:GetServerSlotBySSId(hit.shooterSSID);
					if (ss_shooter) then
						hit.shooter = System:GetEntity(ss_shooter:GetPlayerId());
					else
						ss_shooter = System:GetEntities();
						for i, entity in ss_shooter do
							if (entity.vbot_ssid) then
								if (entity.vbot_ssid == hit.shooterSSID) then
									hit.shooter = entity;
									break;
								end
							end
						end 
					end
				end
				if (hit.shooter) then
					if (hit.shooter.cnt) and (hit.shooter.cnt.score) and (hit.shooter.cnt.score >= gscorelim) then
						Server:BroadcastText(hit.shooter:GetName().." @PlyReachedScore");
						MapCycle:OnMapFinished();
					end
				end
			end
		end
	end
end

function GameRules:GetTeamRespawnPoint(team,entityToIgnore)
	local pt;
	if (GameRules.coop_spawn_object_id) then
		local spawnobject = System:GetEntity(GameRules.coop_spawn_object_id);
		if (spawnobject) then
			local objpos = spawnobject:GetPos();
			if (GameRules.coop_spawn_object_angles) then
				objpos.zA = GameRules.coop_spawn_object_angles.z * 1;
			end
			return objpos;
		end
	end
	pt = Server:GetRandomRespawnPoint("Respawn0");
	if (pt) then
		return pt;
	end
	System:Error("No possible respawn points!");
end

-- return 1=if interaction is accepted, otherwise nil 
function GameRules:IsInteractionPossible(actor,entity)
	-- prevent all ai from picking up things
	if (actor.ai) then
		return nil;
	end
	-- prevent corpses from interacting with something
	if (actor.cnt and (actor.cnt.health == nil or actor.cnt.health <= 0)) then
		return nil;
	end
	return 1;
end

--PREWAR

function GameRules:CoopEndAndGo(lvlname)
	local modfolder = "";
	for i, val in Game:GetModsList() do
		if (val.CurrentMod) then
			modfolder = val.Folder.."";
			break;
		end
	end
	modfolder = modfolder.."/Levels/"..lvlname;
	local svg_files = System:ScanDirectory(modfolder, SCANDIR_FILES);
	if (svg_files and getn(svg_files) > 0) then
		for i,filename in svg_files do
			filename = strlower(filename);
			if (strfind(filename,"coop.bai") ~= nil) then
				modfolder = "f";
				break;
			end
		end
	end
	if (modfolder == "f") then
		GameRules:ChangeMap(lvlname,'COOP');
	else
		GameRules:ChangeMap('Catacombs','COOP');
	end
end

GameRules.states.PREWAR={
	OnBeginState=function (self)
		self:ResetReadyState(nil);
	end,
	OnClientJoinTeamRequest=GameRules.HandleJoinTeamRequest,
}

--INPROGRESS

GameRules.states.INPROGRESS={
	OnBeginState=function(self)
		if getglobal("gr_coop_ammo_mult") == nil then
			Game:CreateVariable("gr_coop_ammo_mult",2);
		else
			Game:CreateVariable("gr_coop_ammo_mult",getglobal("gr_coop_ammo_mult"));
		end
		if getglobal("gr_coop_item_respawn_time") == nil then
			Game:CreateVariable("gr_coop_item_respawn_time",20);
		else
			Game:CreateVariable("gr_coop_item_respawn_time",getglobal("gr_coop_item_respawn_time"));
		end
		if getglobal("gr_coop_timelimit") == nil then
			Game:CreateVariable("gr_coop_timelimit",0);
			GameRules.timelimit = 0;
		else
			Game:CreateVariable("gr_coop_timelimit",getglobal("gr_coop_timelimit"));
			GameRules.timelimit = tonumber(getglobal("gr_coop_timelimit"));
		end
		
		GameRules.cooppicks = {};

		GameRules:StartGameRulesLibTimer();
		GameRules:ResetMapEntities();
		self.mapstart = _time;
		
		GameRules.coop_checktimer = _time + 3;
		GameRules.coop_moodtimer = _time + 3;
		GameRules.coop_mission = nil;
		GameRules.coop_mission_all = nil;
		GameRules.coop_spawn_object_id = nil;
		GameRules.coop_checkpoint = nil;
		
		local slots = Server:GetServerSlotMap();
		for i, slot in slots do
			local ent = System:GetEntity(slot:GetPlayerId());
			slot:ResetPlayTime();
		end
		local ents = System:GetEntities();
		local respwnt = tonumber(getglobal("gr_coop_item_respawn_time"));
		if (respwnt < 5) then
			respwnt = 5;
		end
		for i, ent in ents do
			if (ent.AttemptPick) and (ent.Properties.RespawnTime) and (ent:GetName()~="") then
				ent.Properties.RespawnTime = respwnt;
			end
			if (ent.cnt) and (ent.ai) and (ent.type=="Player") and (ent.cnt.health > 0) then
				Server:RemoveEntity(ent.id);
			end
		end
		GameRules:ScoreboardUpd();
	end,
	OnUpdate=function(self)
		if (MapCycle:IsShowingScores()) then
			return;
		end
		
		if (GameRules.coop_checktimer < _time) then
			-- Mixer: Physical Item Carriers Management:
			if (GameRules.DeadBods) then
				for i, cid in GameRules.DeadBods do
					if (i ~= "n") then
						local c_ent = System:GetEntity(floor(cid));
						if (c_ent) and (c_ent.cnt) and (c_ent.cnt.health <= 0) then
							if (c_ent.fcsu_deathtime) and (c_ent.fcsu_deathtime < _time) then
								Server:RemoveEntity(c_ent.id);
								tremove(GameRules.DeadBods,i);
							end
						else
							tremove(GameRules.DeadBods,i);
						end
					end
				end
			end
			if (not GameRules.coop_mission_all) then
				GameRules.coop_mission_all = 1;
				GameRules:SetCoopMission(1);
			end
			GameRules.coop_checktimer = _time + 12;
		end
		if (GameRules.coop_moodtimer < _time) then
			GameRules.coop_moodtimer = _time + 4;
			local ai_rel = AI:GetPerception();
			if (ai_rel > 110) then
				if (not GameRules.bCombatMood) then
					GameRules.bCombatMood = 1;
					Server:BroadcastCommand("MMD 1");
				end
			elseif (ai_rel < 5) then
				if (GameRules.bCombatMood) then
					GameRules.bCombatMood = nil;
					Server:BroadcastCommand("MMD 0");
				end
			end
		end

		if (self.timelimit and tonumber(self.timelimit)>0) then
			if _time>self.mapstart+tonumber(self.timelimit)*60 then
				Server:BroadcastText("@TimeIsUp");
				MapCycle:OnMapFinished();
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
	            self:OnDamage({ target = ent, shooter = ent, landed = 1, damage = 1999, ipart = 0 });
	        end
	    end
	end,
}

GameRules.states.INTERMISSION={
	OnBeginState=function (self)
		self.intermissionstart = _time;
	end,
	OnUpdate=function(self)
		if _time>self.intermissionstart+6 then
			self:GotoNextMap();
		end
	end
}
