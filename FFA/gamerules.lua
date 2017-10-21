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
	states={}
}

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
    return "FFA";
end


function GameRules:DoRestart()

	self.restartbegin = nil;
	self.restartend = nil;
	
	self.mapstart=_time

	self:ResetPlayerScores(0, 0);
	self:NewGameState(CGS_INPROGRESS);								-- is calling self:ResetMapEntities()
	-- UpdateTimeLimit has to be after NewGameState because this is reseting the leveltime
	self:UpdateTimeLimit(getglobal("gr_TimeLimit"));
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

function GameRules:INPROGRESS_OnDamage(hit)
	-- fixed/improved by Jeppa, improved by Mixer
	local damage_ret=self:UsualDamageCalculation(hit);
	if damage_ret then
		local target = hit.target;
		local shooter = hit.shooter;
		if damage_ret==3 then
			damage_ret=1;		-- there is no team kill
		end		
		-- we have a kill, so drop the guys weapon
		local weapon = target.cnt.weapon;
		if weapon then
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
	
	pt = self:GetFreeTeamRespawnPoint("players",entityToIgnore);
	if (pt) then
		return pt;
	end

	System:Error("No possible respawn points ('players')");
end

--PREWAR

GameRules.states.PREWAR={
	OnBeginState=function (self)
		self:ResetReadyState(nil);
	end,
	OnClientJoinTeamRequest=GameRules.HandleJoinTeamRequest,
}

--INPROGRESS

GameRules.states.INPROGRESS={
	OnBeginState=function(self)
		GameRules:StartGameRulesLibTimer();
		GameRules:ResetMapEntities();
		self.mapstart = _time;
		local slots = Server:GetServerSlotMap();
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
	            self:OnDamage({ target = ent, shooter = ent, damage = 1000, ipart = 0 });
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
