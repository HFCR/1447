--Helper functions for GameRules with team support implementation
--created by MartinM, modified by Mixer
--teams: red blue spectators

Script:LoadScript("SCRIPTS/MULTIPLAYER/GameRulesLib.lua");

GameRules.bShowUnitHightlight=1;
GameRules.bIsTeamBased = 1;

GameRules.InitialPlayerStatistics["nTeamKill"]=0;

function GameRules:UpdateTeamScores()
local red_score=Game:GetTeamScore("red");
local blue_score=Game:GetTeamScore("blue");
    for i,flag in self.flags do
    	local state=flag:GetState();
    	if(state=="red")then
    		red_score=red_score+1;
    	elseif (state=="blue")then
    		blue_score=blue_score+1;
    	end
    end
    Server:SetTeamScore("red",red_score);
    Server:SetTeamScore("blue",blue_score);
end

function GameRules:INTERMISSION_BeginState()
	local red_score=Game:GetTeamScore("red");
	local blue_score=Game:GetTeamScore("blue");
	self.intermissionstart = _time;
	if(red_score~=blue_score)then
		if(red_score>blue_score)then
			Server:BroadcastText("["..red_score.."-"..blue_score.."] @TeamRedWon");
		else
			Server:BroadcastText("["..red_score.."-"..blue_score.."] @TeamBlueWon");
		end
	else
		Server:BroadcastText("["..red_score.."-"..blue_score.."] @TeamTie");
	end
end

function GameRules:INTERMISSION_OnUpdate()
	if _time>self.intermissionstart+6 then
   	self:GotoNextMap();
	end
end

function GameRules:PREWAR_Team_OnUpdate()
end

-- modified by Mixer:
function GameRules.ReturnIfPlayerDamagesHimself(target,shooter,hit)
	if (target) and (hit) and (hit.weapon) and (hit.weapon.shooterSSID) then
		local hw_ssid = Server:GetServerSlotBySSId(hit.weapon.shooterSSID);
		if (hw_ssid) then
			if (hw_ssid:GetPlayerId() == target.id) then
				return 1;
			end
		else
			local entlist = System:GetEntities();
			for i, entity in entlist do
				if (entity.vbot_ssid) then
					if (entity.vbot_ssid == hit.weapon.shooterSSID) then
						if (entity.id == target.id) then
							return 1;
						end
					end
				end
			end
		end
	end
	if shooter and target==shooter then
		return 1
	end
end

-- used for friendly fire
-- \param target entity \param shooter entity \param hit hit table (hit.damage has to be there)
-- returns 1 if the damage should be ignored, nil otherwise

function GameRules:IgnoreDamageBetween(target,shooter,hit)
	if (target==nil) then
		return;
	end
	if tonumber(gr_FriendlyFire)~=0 then -- friendly fire is not activated
		return;
	end
	if hit.damage <=0 then -- healing is not affected by friendly fire
		return;
	end
	if self.ReturnIfPlayerDamagesHimself(target,shooter,hit) then
		return;
	end

	local shooterTeam;
	if (hit.weapon) then
	if (hit.weapon.IsVehicle) then
		return;
	end
	if (hit.weapon.shooterSSID) then
	local hw_ssid = Server:GetServerSlotBySSId(hit.weapon.shooterSSID);
		if (hw_ssid) then
			hw_ssid = hw_ssid:GetPlayerId();
			shooterTeam = Game:GetEntityTeam(hw_ssid);
		else
			local entlist = System:GetEntities();
			for i, entity in entlist do
				if (entity.vbot_ssid) then
					if (entity.vbot_ssid == hit.weapon.shooterSSID) then
						shooterTeam = Game:GetEntityTeam(entity.id);
						break;
					end
				end
			end
		end
	elseif (shooter) then
		shooterTeam = Game:GetEntityTeam(shooter.id);
	end
	end
	if shooterTeam==nil then
		return;
	end

	local targetTeam=Game:GetEntityTeam(target.id);
	if targetTeam==shooterTeam then
		return 1;	-- ignore positive damage between team members
	end
end

GameRules.ClientCommandTable["GTK"]=function(String,ServerSlot,TokTable)
	if (count(TokTable) ~= 1) or (SVplayerTrack==nil) then
		return;
	end
        local szReplyString = TokTable[1];
        local judge=toNumberOrZero(SVplayerTrack:GetBySs(ServerSlot, "TKjudge"))
        local criminal=toNumberOrZero(SVplayerTrack:GetBySs(ServerSlot, "TKcriminal"))
        if (judge ~= nil) then
        	szReplyString = szReplyString.." "..judge.." "..criminal;
        end
        ServerSlot:SendCommand(szReplyString);
end

GameRules.ClientCommandTable["VTK"]=function(String,ServerSlot,TokTable)
	if (count(TokTable) ~= 4) then
		return;
	end
	local judge=tonumber(TokTable[2]);
	local criminal=tonumber(TokTable[3]);
	local verdict=tonumber(TokTable[4]);
        SVcommands:TKVerdict(judge,criminal,verdict);
end
