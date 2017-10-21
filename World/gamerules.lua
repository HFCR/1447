--FAR CRY script file
--FFA GameRules
--Created by Alberto Demichelis
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
--GameRules.InitialPlayerProperties.model="Objects/characters/pmodels/hero/hero.cgf";

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

			if Slot.money_amount then
				self:SetScoreboardEntryXY(ScoreboardTableColumns.iSuicides,ClientId,Slot.money_amount);
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
	---
	GameRules.ModPath = "";
	for i, val in Game:GetModsList() do
		if (val.CurrentMod) then
			GameRules.ModPath = val.Folder.."/";
			break;
		end
	end
	---
end

function GameRules:SavePlayerEquipment(sslt)
	local player_id = sslt:GetPlayerId();
	if (player_id) then
		player_id = System:GetEntity(player_id);
		if (player_id) and (player_id.cnt) and (player_id.classname=="Player") then
			local ufile = openfile(GameRules.ModPath.."/Users/"..sslt.usr_filename..".txt","w");
			if (ufile) then
				if sslt.money_amount then
					write(ufile,"money="..sslt.money_amount.."\n");
				else
					write(ufile,"money=0".."\n");
				end
				
				if (player_id.cnt.weapon) and (player_id.cnt.weapon.name) then
					if (player_id.cnt.lock_weapon or player_id.fireparams.vehicleWeapon) then
						write(ufile,"gunslots=0".."\n");
					else
						write(ufile,"gunslots="..player_id.cnt.weapon.name.."\n");
					end
				else
					write(ufile,"gunslots=0".."\n");
				end
				-----------------------------------------------------------------------------------------
				local LocAmmo = {};
				if player_id.Ammo then
					LocAmmo = new(player_id.Ammo);
				end
				
				
				if player_id.cnt.GetWeaponsSlots then
					local wslots = player_id.cnt:GetWeaponsSlots();
					if (wslots) then
						for i,val in wslots do
							if (val~=0) then
								if (player_id.cnt.weapon) and (player_id.cnt.lock_weapon or player_id.fireparams.vehicleWeapon) and (player_id.cnt.weapon.name==val.name) then
								else
									write(ufile,val.name.."\n");
									------------------------
									player_id.temp_firparamsnum = 1;
									while val.FireParams[player_id.temp_firparamsnum] do
										if (val.FireParams[player_id.temp_firparamsnum].AmmoType) and (LocAmmo[val.FireParams[player_id.temp_firparamsnum].AmmoType]) then
											if (player_id.temp_firparamsnum>1) and (val.FireParams[player_id.temp_firparamsnum-1].AmmoType) and (val.FireParams[player_id.temp_firparamsnum-1].AmmoType==val.FireParams[player_id.temp_firparamsnum].AmmoType) then
											elseif (player_id.cnt.weapon) and (player_id.cnt.weapon.name == val.name) and (player_id.cnt.firemode+1 == player_id.temp_firparamsnum) then
												LocAmmo[val.FireParams[player_id.temp_firparamsnum].AmmoType]=LocAmmo[val.FireParams[player_id.temp_firparamsnum].AmmoType]+player_id.cnt.ammo_in_clip;
											elseif (player_id.WeaponState[WeaponClassesEx[val.name].id]) and (player_id.WeaponState[WeaponClassesEx[val.name].id].AmmoInClip) then
												if (player_id.WeaponState[WeaponClassesEx[val.name].id].AmmoInClip[player_id.temp_firparamsnum]) then
													LocAmmo[val.FireParams[player_id.temp_firparamsnum].AmmoType]=LocAmmo[val.FireParams[player_id.temp_firparamsnum].AmmoType]+player_id.WeaponState[WeaponClassesEx[val.name].id].AmmoInClip[player_id.temp_firparamsnum];
												end
											end
										end
										player_id.temp_firparamsnum = player_id.temp_firparamsnum+1;
									end
									player_id.temp_firparamsnum = nil;
									------------------------
								end
							end
						end
					end
				end

				if LocAmmo.Salo and LocAmmo.Salo > 0 then
					write(ufile,"Salo".."\n");
				end
				if LocAmmo.Vodka and LocAmmo.Vodka > 0 then
					write(ufile,"Vodka".."\n");
				end
				if LocAmmo.Yoghurt and LocAmmo.Yoghurt > 0 then
					write(ufile,"Yoghurt".."\n");
				end
				write(ufile,"set_ammo_slots:".."\n");
				
				if (player_id.cnt.grenadetype) and (GrenadesClasses) and (LocAmmo[GrenadesClasses[player_id.cnt.grenadetype]]) then
					LocAmmo[GrenadesClasses[player_id.cnt.grenadetype]] = player_id.cnt.numofgrenades * 1;
				end
				
				-----------------
				for j,amoamnt in LocAmmo do
					write(ufile,"set_ammo:"..j.."="..amoamnt.."\n");
				end
				-----------------------------
				
				if player_id.cnt.score then
					write(ufile,"score="..player_id.cnt.score.."\n");
				else
					write(ufile,"score=0".."\n");
				end
				
				if player_id.cnt.deaths then
					write(ufile,"deaths="..player_id.cnt.deaths.."\n");
				else
					write(ufile,"deaths=0".."\n");
				end
                                if sslt.MyHouseId then
                                write(ufile, "MyHouseId=" .. sslt.MyHouseId .. "\n");
                                else
                                write(ufile, "MyHouseId=0\n");
                                end
				------------------------------------------------------------------------------------------------
				closefile(ufile);
			end
		end
	end
end

function GameRules:AddMoney(sslot,amount,resetmoney)
	if (sslot.money_amount==nil) or (resetmoney) then
		sslot.money_amount=0;
	end
	sslot.money_amount=sslot.money_amount+amount;
	sslot:SendCommand("GI WS "..sslot.money_amount);
end

function GameRules:LoadPlayerEquipment(sslt)
	local ufile = openfile(GameRules.ModPath.."/Users/"..sslt.usr_filename..".txt","r");
	if (ufile) then
	
		local cfgline = "";
		--while(cfgline) do
			cfgline = read(ufile,"*l");
			if (cfgline) then
				sslt.money_amount = strsub(cfgline,7); -- money=x (7th char starting)
				sslt.money_amount = tonumber(sslt.money_amount);
			end
			cfgline = read(ufile,"*l"); -- reading wpn amount
			if (cfgline) then
				sslt.lastusdwpn_name = strsub(cfgline,10); -- gunslots=x (10th char starting)
				cfgline = read(ufile,"*l");
			end
			
			--if sslt.coop_eqnum > 0 then
				local cwpnslt = 0;
				sslt.coop_equipment = {};
				while (cfgline) and (strfind(cfgline,"set_ammo")==nil) do
					cwpnslt = cwpnslt+1;
					if (cfgline) then
						sslt.coop_equipment[cwpnslt] = { Type="Weapon", Name=cfgline.."", };
						if (sslt.lastusdwpn_name) and (sslt.lastusdwpn_name == cfgline) then
							sslt.coop_equipment[cwpnslt].Primary=1;
						end
					end
					cfgline = read(ufile,"*l"); -- reading wpn
				end
				sslt.lastusdwpn_name = nil;
				sslt.coop_eqnum = cwpnslt*1;
				cwpnslt = 0;
				sslt.coop_equipment.Ammo={};
				while (cwpnslt) do
					cfgline = read(ufile,"*l"); -- reading ammo
					if (cfgline) then
						cwpnslt = strfind(cfgline,"set_ammo:");
						if (cwpnslt) and (cwpnslt == 1) then
							cfgline=strsub(cfgline,10);
							cwpnslt = strfind(cfgline,"=");
							if (cwpnslt) then
								local amname = strsub(cfgline,1,cwpnslt-1);
								local amamnt =  strsub(cfgline,cwpnslt+1);
								sslt.coop_equipment.Ammo[amname]=tonumber(amamnt);
							end
						else
							cwpnslt = strfind(cfgline,"score=");
							if (cwpnslt) and (cwpnslt == 1) then
								sslt.score_amount = strsub(cfgline,7);
								sslt.score_amount = tonumber(sslt.score_amount);
							end
							cwpnslt = nil;
						end
					else
						cwpnslt = nil;
					end
				end
			--end
			cfgline = read(ufile,"*l"); -- reading score/deaths
			if (cfgline) then
				local cwpnslt = strfind(cfgline,"score=");
				if (cwpnslt) and (cwpnslt == 1) then
					sslt.score_amount = strsub(cfgline,7);
					sslt.score_amount = tonumber(sslt.score_amount);
					--------
					cfgline = read(ufile,"*l"); -- reading deaths
					if (cfgline) then
						cwpnslt = strfind(cfgline,"deaths=");
						if (cwpnslt) and (cwpnslt == 1) then
							sslt.death_amount = strsub(cfgline,8);
							sslt.death_amount = tonumber(sslt.death_amount);
						end
					end
					----------
				else
					cwpnslt = strfind(cfgline,"deaths=");
					if (cwpnslt) and (cwpnslt == 1) then
						sslt.death_amount = strsub(cfgline,8);
						sslt.death_amount = tonumber(sslt.death_amount);
					end
				end
			end
	
cfgline = read(ufile,"*l"); -- reading deaths
   if (cfgline) then
    local MyHouseIdx = strfind(cfgline,"MyHouseId=");
    if (MyHouseIdx) and (MyHouseIdx == 1) then
     MyHouseIdx = strsub(cfgline,11);
     sslt.MyHouseId = tonumber(MyHouseIdx);
     if sslt.MyHouseId == 0 then
      sslt.MyHouseId = nil;
     end
     

     System:Log("cfgline: " .. tostring(cfgline));
     System:Log("MyHouseIdx: " .. tostring(MyHouseIdx));
     System:Log("sslt.MyHouseId: " .. tostring(sslt.MyHouseId));
    end
   end





    
    if sslt.MyHouseId then
     write(ufile, "MyHouseId=" .. sslt.MyHouseId .. "\n");
    else
     write(ufile, "MyHouseId=0\n");
    end
			----- reading something more
		--end

		closefile(ufile);
		return 1;
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
			
			if server_slot.coop_equipment  ~= nil then
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
				if (server_slot.score_amount) then
					newent.cnt.score = floor(server_slot.score_amount);
					server_slot.score_amount = nil;
				end
				if (server_slot.death_amount) then
					newent.cnt.deaths = floor(server_slot.death_amount);
					server_slot.death_amount = nil;
				end
			else
				server_slot.coop_equipment = nil;
				server_slot.coop_keys = nil;
				server_slot.coop_explo = nil;
				server_slot.coop_objs = nil;
				server_slot.score_amount = nil;
				server_slot.death_amount = nil;
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
			if (server_slot.money_amount) then
				server_slot:SendCommand("GI WS "..server_slot.money_amount.." 1");
			else
				server_slot:SendCommand("GI WS");
			end
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
    return "WORLD";
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
	if (team=="spectators") then
--		GameRules:SavePlayerEquipment(server_slot);
	end
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
					end
				end
				
				if (hit.exithit==nil) and (theTarget.classname~="Player") then
					local shtrslot = Server:GetServerSlotByEntityId(theShooter.id);
					if (shtrslot) then
						if (theTarget.hedshot) then
							GameRules:AddMoney(shtrslot,100);
						else
							GameRules:AddMoney(shtrslot,30);
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
								targetslot.coop_equipment.Ammo = theTarget.Ammo;
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
								if theTarget.Ammo.Vodka and theTarget.Ammo.Vodka > 0 then
									targetslot.coop_eqnum = targetslot.coop_eqnum + 1;
									targetslot.coop_equipment[targetslot.coop_eqnum] = { Type="Weapon", Name = "Vodka", };
								end
								if theTarget.Ammo.Salo and theTarget.Ammo.Salo > 0 then
									targetslot.coop_eqnum = targetslot.coop_eqnum + 1;
									targetslot.coop_equipment[targetslot.coop_eqnum] = { Type="Weapon", Name = "Salo", };
								end
								if theTarget.Ammo.Yoghurt and theTarget.Ammo.Yoghurt > 0 then
									targetslot.coop_eqnum = targetslot.coop_eqnum + 1;
									targetslot.coop_equipment[targetslot.coop_eqnum] = { Type="Weapon", Name = "Yoghurt", };
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
						-----
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
		if target.cnt.weapon then
			if target.ai then
				BasicWeapon.Server.Drop( target.cnt.weapon, {Player = target, suppressSwitchWeapon = 1} );
			else
				
			end
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

GameRules.ClientCommandTable["BUY"]=function(String,server_slot,toktable)
	local itmid = System:GetEntity(toktable[2]);
	local player_id = server_slot:GetPlayerId();
	if (player_id) then
		player_id = System:GetEntity(player_id);
	end
	if (itmid) and (itmid.classname=="BuyObject") and (player_id) and (player_id.cnt) then
		if (server_slot.money_amount) then
			if (server_slot.money_amount < itmid.Properties.nPrice) then
			else
				local wpns_count=1; -- lets think its weapon
				if (itmid.Properties.sBuyCommand == "Shotgun") and strfind(itmid.Properties.fileModel,"ammo")~=nil then
					wpns_count=0;
				end
				if (itmid.Properties.sBuyCommand == "House") then
					if server_slot.MyHouseId and server_slot.MyHouseId == itmid.id then
					else
						server_slot.MyHouseId = floor(itmid.id);
						GameRules:AddMoney(server_slot,-itmid.Properties.nPrice);
						Server:BroadcastCommand("FX",{x=floor(player_id.id),y=0,z=0},{x=0,y=0,z=0},itmid.id,1);
					        System:Log("MyHouseId: " .. tostring(server_slot.MyHouseId));
					end
				elseif (itmid.Properties.sBuyCommand == "Health") then
					if (player_id.cnt.health < player_id.cnt.max_health) then
						GameRules:AddMoney(server_slot,-itmid.Properties.nPrice);
						player_id.cnt.health = player_id.cnt.max_health*1;
						Server:BroadcastCommand("FX",{x=0,y=0,z=0},{x=0,y=0,z=0},itmid.id,1);
					end
				elseif (itmid.Properties.sBuyCommand == "Armor") then
					if (player_id.cnt.armor < player_id.cnt.max_armor) then
						GameRules:AddMoney(server_slot,-itmid.Properties.nPrice);
						player_id.cnt.armor = player_id.cnt.max_armor*1;
						Server:BroadcastCommand("FX",{x=0,y=0,z=0},{x=0,y=0,z=0},itmid.id,1);
					end
				elseif WeaponClassesEx[itmid.Properties.sBuyCommand] and WeaponClassesEx[itmid.Properties.sBuyCommand].food == nil and player_id.cnt.GetWeaponsSlots and wpns_count > 0 then
					local wsl = player_id.cnt:GetWeaponsSlots();
					if (wsl) then
						local has_this_gun;
						wpns_count=0;
						local has_hands;
						for i,val in wsl do
							if(val~=0) then 
								wpns_count=wpns_count+1;
								if (val.name==itmid.Properties.sBuyCommand) then
									has_this_gun=1;
									return;
								end
								if (val.name=="Hands") then
									wpns_count=wpns_count-1;
									has_hands=9;
								end
							end
						end
						----------------
						if (wpns_count < 4) then
							if (wpns_count == 3) and (has_hands) then
								player_id.cnt:MakeWeaponAvailable(has_hands,0);
							end
							player_id.cnt:MakeWeaponAvailable(WeaponClassesEx[itmid.Properties.sBuyCommand].id);
							GameRules:AddMoney(server_slot,-itmid.Properties.nPrice);
							player_id.cnt:SetCurrWeapon(WeaponClassesEx[itmid.Properties.sBuyCommand].id);
							--wpns_count = Game:GetWeaponClassIDByName(itmid.Properties.sBuyCommand);
							--if (wpns_count) then
							--	server_slot:SendCommand("HUD W "..wpns_count);
							--end
							Server:BroadcastCommand("FX",{x=0,y=0,z=0},{x=0,y=0,z=0},itmid.id,1);
						end

						-----------------------
-----------------------------------------------------------
					end
				elseif (MaxAmmo[itmid.Properties.sBuyCommand]) then
					local curr_amount = player_id:GetAmmoAmount(itmid.Properties.sBuyCommand);
					if (curr_amount) and (curr_amount < MaxAmmo[itmid.Properties.sBuyCommand]) then
						local to_add=itmid.Properties.nAmount*1;
						if (curr_amount+to_add>MaxAmmo[itmid.Properties.sBuyCommand]) then
							to_add=MaxAmmo[itmid.Properties.sBuyCommand]-curr_amount;
						end
						if (to_add > 0) then
							player_id:AddAmmo(itmid.Properties.sBuyCommand, to_add);
							GameRules:AddMoney(server_slot,-itmid.Properties.nPrice);
							server_slot:SendCommand("HUD A "..itmid.Properties.sBuyCommand.." "..to_add);
							Server:BroadcastCommand("FX",{x=0,y=0,z=0},{x=0,y=0,z=0},itmid.id,1);
							if WeaponClassesEx[itmid.Properties.sBuyCommand] and WeaponClassesEx[itmid.Properties.sBuyCommand].food then
								player_id.cnt:MakeWeaponAvailable(WeaponClassesEx[itmid.Properties.sBuyCommand].id);
								player_id.cnt:SetCurrWeapon(WeaponClassesEx[itmid.Properties.sBuyCommand].id);
							end
						end
					end
				end
			end
		end
	end
end;

GameRules.ClientCommandTable["WRLD"]=function(String,server_slot,toktable)
	local slot_name = server_slot:GetName();
	------ let's format user filename
	local usr_filename = ""
	slot_name = slot_name.."_"..toktable[3];
	while slot_name ~= "" do
		local s_char = strsub(slot_name,1,1);
		if (s_char >= "0" and s_char <= "9") or (s_char >= "A" and s_char <= "Z") or (s_char >= "a" and s_char <= "z") or (s_char == "_") then
			usr_filename = usr_filename..s_char;
		end
		slot_name = strsub(slot_name,2);
	end
	
	----------
	if (toktable[2] == "N") then
		local chk_file = openfile(GameRules.ModPath.."/Users/"..usr_filename..".txt","r");
		if (chk_file) then
			closefile(chk_file);
			server_slot:SendCommand("MMD refuse");
		else
			local user_file = openfile(GameRules.ModPath.."/Users/"..usr_filename..".txt","w");
			write(user_file,"money=0");
			closefile(user_file);
			server_slot.usr_filename = usr_filename.."";
			server_slot.MyHouseId = nil;
			server_slot.MyMissionId = nil;
			GameRules:AddMoney(server_slot,0,0);
			GameRules:OnClientJoinTeamRequest(server_slot,"players");
		end
	else
		server_slot.usr_filename = usr_filename.."";
		if (GameRules:LoadPlayerEquipment(server_slot)~=nil) then
			GameRules:OnClientJoinTeamRequest(server_slot,"players");
		end
	end
end;

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
	OnClientDisconnect = function(self,server_slot)
		GameRules:SavePlayerEquipment(server_slot);
	end,
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
