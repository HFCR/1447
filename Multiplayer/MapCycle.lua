-- make sure the table is loaded once
-- modified by Mixer to handle the Verysoft bots v1.52cis+fcam judge 1.0 (v2.5)

if (not MapCycle) then
	MapCycle =
	{
		iNextMap = 0, -- this is the servercreation map
	};
end

function MapCycle:Init()
	self.iNextMap = 0; -- this is the server-creation map
	self.fRestartTimer = nil;
	self.vbots_num = 0;
	self.vbots_nextcheck = 4;
	if getglobal("bot_quota") == nil then
		Game:CreateVariable("bot_quota",0);
	else
		Game:CreateVariable("bot_quota",getglobal("bot_quota"));
	end
	if getglobal("bot_difficulty") == nil then
		Game:CreateVariable("bot_difficulty",2);
	else
		Game:CreateVariable("bot_difficulty",getglobal("bot_difficulty"));
	end
	if getglobal("bot_enable") == nil then
		Game:CreateVariable("bot_enable",1);
	else
		Game:CreateVariable("bot_enable",getglobal("bot_enable"));
	end
	if getglobal("bot_always") == nil then
		Game:CreateVariable("bot_always",0);
	else
		Game:CreateVariable("bot_always",getglobal("bot_always"));
	end
	if getglobal("gr_su_handicap") == nil then
		Game:CreateVariable("gr_su_handicap",0);
	else
		Game:CreateVariable("gr_su_handicap",getglobal("gr_su_handicap"));
	end 
	if getglobal("cis_mapcycle") == nil then
		local modfolder = "";
		Game:CreateVariable("cis_mapcycle","fc-vanilla-maplist.txt");
		for i, val in Game:GetModsList() do
			if (val.CurrentMod) then
				modfolder = val.Folder.."";
				break;
			end
		end
		
		-- check for presence of CII campaign (map pack)
		local svg_files = System:ScanDirectory(modfolder, SCANDIR_FILES);
		if (svg_files and getn(svg_files) > 0) then
			for i,filename in svg_files do
				filename = strlower(filename);
				if (strfind(filename,"maps.pak") ~= nil) then
					setglobal("cis_mapcycle","contestisle-maplist.txt");
					break;
				end
			end
		end
	else
		Game:CreateVariable("cis_mapcycle",getglobal("cis_mapcycle"));
	end
	if getglobal("bot_tag") == nil then
		Game:CreateVariable("bot_tag","FCR");
	else
		Game:CreateVariable("bot_tag",getglobal("bot_tag"));
	end
	if getglobal("fcam_teamsign") == nil then
		Game:CreateVariable("fcam_teamsign",0);
	else
		Game:CreateVariable("fcam_teamsign",getglobal("fcam_teamsign"));
	end
	if getglobal("fcam_inactivity_time") == nil then
		Game:CreateVariable("fcam_inactivity_time",3);
	else
		Game:CreateVariable("fcam_inactivity_time",getglobal("fcam_inactivity_time"));
	end
	local modsvname = getglobal("sv_name");
	if (modsvname) and (System.this_mod_version) then
		if (strfind(modsvname,System.this_mod_version) == nil) then
			setglobal("sv_name",modsvname.." "..System.this_mod_version);
		end
	end
end

function MapCycle:LoadFromFile(szFilename)
	if (getglobal("cis_mapcycle")) then
		for i, val in Game:GetModsList() do
			if (val.CurrentMod) then
				szFilename = val.Folder.."/"..getglobal("cis_mapcycle");
				break;
			end
		end
	end
	self.MapList = {};
	self.iNextMap = 0;
	local Lines = ReadTableFromFile(szFilename, 1);
	if (Lines) then
		if (not UI) then
			self.iNextMap = 1; -- Mixer: if mapcycle is present, dedicated server starts from first mapcycle map, instead of using server-creation map
		end
		local iSpace;
		local szMapName;
		local szGameType;
		local szTimeLimit = getglobal("gr_TimeLimit");
		local szRespawntime = getglobal("gr_RespawnTime");
		local szInvulnerabilityTimer = getglobal("gr_InvulnerabilityTimer");
		local szMaxPlayers = getglobal("gr_MaxPlayers");
		local szMinTeamLimit = getglobal("gr_MinTeamLimit");
		local szMaxTeamLimit = getglobal("gr_MaxTeamLimit");
		local szRoundlimit = getglobal("gr_su_roundlimit");
		
		for i, szLine in Lines do
			if (strlen(szLine) > 0) then
				local Map = {};

				local paramstr = tokenize(szLine);
				
				if paramstr[1] then 
					szMapName = paramstr[1];
				end
				if paramstr[2] then
					szGameType = paramstr[2];
				end
				
				if paramstr[3] then
					szTimeLimit = paramstr[3];
				end
				
				if paramstr[4] then
					-- Mixer: special case for SURVIVAL/RACING GAMETYPE
					if (paramstr[2]) and (strupper(paramstr[2])=="SURVIVAL" or strupper(paramstr[2])=="RACING") then
						if (szRoundlimit == nil) then
							Game:CreateVariable("gr_su_roundlimit",toNumberOrZero(paramstr[4]));
						end
						szRoundlimit = toNumberOrZero(paramstr[4]);
					else
						szRespawnTime = paramstr[4];
					end
				end
				
				if paramstr[5] then 
					szInvulnerabilityTimer = paramstr[5];
				end
				
				if paramstr[6] then
					szMaxPlayers = paramstr[6];
				end
			
				if paramstr[7] then
					szMinTeamLimit = paramstr[7];
				end
				
				if paramstr[8] then
					szMaxTeamLimit = paramstr[8];
				end
				
				Map.szTimeLimit = szTimeLimit;
				Map.szRespawnTime = szRespawnTime;
				Map.szInvulnerabilityTimer = szInvulnerabilityTimer;
				Map.szMaxPlayers = szMaxPlayers;
				Map.szMinTeamLimit = szMinTeamLimit;
				Map.szMaxTeamLimit = szMaxTeamLimit;
				Map.szName = szMapName;
				Map.szGameType = szGameType;
				if (szRoundlimit) then
					Map.szRoundlimit = szRoundlimit * 1;
				end
				tinsert(self.MapList, Map);
			end
		end
		
		self.MapList.n = nil;
	end
end

function MapCycle:nextmap()
if (SVplayerTrack) then
SVplayerTrack:Init();
if toNumberOrZero(getglobal("gr_keep_lock"))==0 then
SVcommands:SVunlockall();
end
MPStatistics:Print();
MPStatistics:Init();
local m = self.MapList[self.iNextMap];
if (m) then
GameRules:ChangeMap(m.szName, m.szGameType, m.szTimeLimit, m.szRespawnTime, m.szInvulnerabilityTimer, m.szMaxPlayers, m.szMinTeamLimit, m.szMaxTeamLimit);
end
end
end

function MapCycle:OnMapChanged()
MPStatistics:Init();
-- v0.982 BOT RELATED STUFF
if (self.vbots_num) and (self.vbots_num > 0) then
local botcount_red = 0;
local botcount_blue = 0;
local entlist = System:GetEntities();
for i, entity in entlist do
	if (entity.bot_team) then
		if (entity.bot_team==2) then
		botcount_blue = botcount_blue + 1;
		else
		botcount_red = botcount_red + 1;
		end
	end
end
if (GameRules.bot_common) then
	GameRules.bot_common.redsum=botcount_red;
	GameRules.bot_common.bluesum=botcount_blue;
end
self.vbots_nextcheck = _time + 5;
self.vbots_num = botcount_blue + botcount_red;
end
if tonumber(getglobal("fcam_teamsign")) == 0 then
	GameRules.bShowUnitHightlight=nil;
elseif (GameRules.bIsTeamBased) then
	GameRules.bShowUnitHightlight=1;
end
-- v0.92 BOT RELATED STUFF ENDS -- HACKS NOW

-- 1a add mod version to server name, if not present
local modsvname = getglobal("sv_name");
if (modsvname) and (System.this_mod_version) then
	if (strfind(modsvname,System.this_mod_version) == nil) then
		setglobal("sv_name",modsvname.." "..System.this_mod_version);
	end
end

-- 1b ADD IMPROVED MAP VOTE
GameCommands.map=
{
	OnCallVote=function(self,serverslot,arg)
		local toktable=tokenize(arg);
		if toktable[1]~=nil then
			self.nextmap=toktable[1];
		else
			self.nextmap=arg;
		end
		--------
		local is_absent = 1;
		local map_lwr = strlower(self.nextmap);
		if (MapCycle.MapList) and (getn(MapCycle.MapList)>0) then
			for key,val in MapCycle.MapList do
				if (val.szName) and (strlower(val.szName) == map_lwr) then
					is_absent = nil;
					break;
				end
			end
			if (is_absent) then
				Server:BroadcastText("$1CIS Judge: "..self.nextmap.." - @cis_unlistedmap");
				is_absent = nil;
				return nil;
			end
		end
		--------
		if toktable[2]~=nil then
			self.nexttype=toktable[2];
		end

		return 1;
	end,

	OnExecute=function(self)
		GameRules:ChangeMap(self.nextmap,self.nexttype);
	end,

	-- arguments
	nextmap=nil,
	nexttype=nil,
};

GameCommands.kick=
{
	-- \return nil=call is not possible, otherwise the vote has started
	OnCallVote=function(self,serverslot,arg)
		local KickSlot=Server:GetServerSlotBySSId(arg);
		
		if (ClientStuff) then
			ClientStuff.votenow_lastkickname = nil;
		end
			
		if (not KickSlot) then
			local entlist = System:GetEntities();
			self.PlayerSSID=nil;
			for i, entity in entlist do
				if (entity.vbot_ssid) and (entity.vbot_ssid==tonumber(arg)) and (entity.classname=="Player") then
					self.PlayerSSID=entity.vbot_ssid*1;
					if (ClientStuff) then
						ClientStuff.votenow_lastkickname = entity:GetName();
					end
					break;
				end
			end
			if (self.PlayerSSID) then
				return 1;
			end
		end
			
		if (not KickSlot) then
			System:Log("GameCommands.kick: Slot of '"..arg.."' not found");
			serverslot:SendText("@VoteUnknCommand",3);
			return;
		end
			
		if (_localplayer and KickSlot==Server:GetServerSlotByEntityId(_localplayer.id)) then
			System:LogAlways("GameCommands.kick: don't kick the server");
			serverslot:SendText("@VoteUnknCommand",3);
			return;
		end
			
		self.PlayerSSID=KickSlot:GetId();
		return 1;
	end,

	OnExecute=function(self)
		local pb = tonumber(getglobal("sv_punkbuster")); 
		local server_slot = Server:GetServerSlotBySSId(self.PlayerSSID);						-- id was specified
		if (server_slot) then
			if(pb and pb==1) then 
				local ntime = tonumber(getglobal("gr_teamkill_kick_time")); 
				System:ExecuteCommand("pb_sv_kick \""..server_slot:GetName().."\" "..ntime.." Voted off the server"); 
			else 
				GameRules:KickSlot(server_slot) 
			end
		else
			local entlist = System:GetEntities();
			for i, entity in entlist do
				if (entity.vbot_ssid) and (entity.vbot_ssid == self.PlayerSSID) then
					if (entity.classname=="Player") and (MapCycle.vbots_num) then
						entity.bot_disconnectnow = 1;
						entity:VBotEradicate();
						MapCycle.vbots_num = MapCycle.vbots_num - 1;
						break;
					end
				end
			end
		end
	end,

	-- arguments
	PlayerSSID=nil,
}

-- 1c) ADD BOT QUOTA VOTE:

GameCommands.bot_quota=
{
	OnCallVote=function(self,serverslot,arg)
		if arg~=nil then
			GameRules.bot_quota_vote=arg;
		else
			GameRules.bot_quota_vote=nil;
		end
		return 1;
	end,
	OnExecute=function(self)
		if (GameRules.bot_quota_vote) then
			if (tonumber(getglobal("bot_enable"))> 0) then
				setglobal("bot_quota",GameRules.bot_quota_vote);
				Server:BroadcastCommand("PLAS cis_f_bquo");
			else
				Server:BroadcastText("$1CIS Judge: $4Verysoft bots are DISABLED on this server!");
				setglobal("bot_quota",0);
			end
			GameRules.bot_quota_vote = nil;
		end
	end,
};

-- 2) ADD BOT DIFFICULTY VOTE

GameCommands.bot_difficulty=
{
	OnCallVote=function(self,serverslot,arg)
		if arg~=nil then
			GameRules.bot_difficulty_vote=tonumber(arg);
		else
			GameRules.bot_difficulty_vote=nil;
		end
		return 1;
	end,
	OnExecute=function(self)
		if (GameRules.bot_difficulty_vote) then
			----------------
			if (GameRules.bot_difficulty_vote < 1) or (GameRules.bot_difficulty_vote > 3) then
				GameRules.bot_difficulty_vote = 2;
			end
			setglobal("bot_difficulty",GameRules.bot_difficulty_vote);
			local upbots = System:GetEntities();
			for i, bt in upbots do
				if (bt.POTSHOTS) then
					if (GameRules.bot_difficulty_vote == 1) then
						bt.Properties.accuracy = 0.3;
						bt.Properties.aggression = 0.5;
					elseif (GameRules.bot_difficulty_vote == 3) then
						bt.Properties.accuracy = 0.9;
						bt.Properties.aggression = 0.9;
					else
						bt.Properties.accuracy = 0.6;
						bt.Properties.aggression = 0.7;
					end
					bt:ChangeAIParameter(AIPARAM_AGGRESION, bt.Properties.aggression);
					bt:ChangeAIParameter(AIPARAM_ACCURACY, bt.Properties.accuracy);
				end
			end
			GameRules.bot_difficulty_vote = nil;
		end
	end,
};

-- 3) ADD RAIL ONLY MODE VOTE

GameCommands.cis_railonly=
{
	OnCallVote=function(self,serverslot,arg)
		if arg~=nil then
			GameRules.cis_railonly_vote=arg;
		else
			GameRules.cis_railonly_vote=nil;
		end
		return 1;
	end,
	OnExecute=function(self)
		if (GameRules.cis_railonly_vote) then
			setglobal("cis_railonly",GameRules.cis_railonly_vote);
			Server:BroadcastCommand("PLAS cis_f_armsch");
		end
	end,
};

GameCommands.gamestyle=
{
	OnCallVote=function(self,serverslot,arg)
		if arg~=nil then
			GameRules.cis_gstyle_vote=arg;
		else
			GameRules.cis_gstyle_vote=nil;
		end
		return 1;
	end,
	OnExecute=function(self)
		if (GameRules.cis_gstyle_vote) then
			setglobal("gr_gamestyle",GameRules.cis_gstyle_vote);
			--Server:BroadcastCommand("PLAS cis_f_armsch");
		end
	end,
};

GameCommands.su_handicap=
{
	OnCallVote=function(self,serverslot,arg)
		if arg~=nil then
			GameRules.cis_suhand_vote=arg;
		else
			GameRules.cis_suhand_vote=nil;
		end
		return 1;
	end,
	OnExecute=function(self)
		if (GameRules.cis_suhand_vote) then
			setglobal("gr_su_handicap",GameRules.cis_suhand_vote);
			GameRules.bakenewbeast = _time + 3;
		end
	end,
};

function GameRules:OnSpectatorSwitchModeRequest(spect)
	if toNumberOrZero(getglobal("gr_allow_spectators"))==0 then
		return;
	end
	local curhost=spect.cnt:GetHost();
	local firstpawn=0;
	local players={};
	local slots=System:GetEntities();
	for i, slot in slots do
		if (slot.type=="Player") and (slot.death_timestamp==nil) then
			players[slot.id]=slot;
		end
	end
	if(count(players)==0) then
		return 
	end;

	for id,ent in players do
		if (firstpawn == 0) then
			-- remember first player of list
			firstpawn = id*1;
		end
		if (curhost==0) then
			spect.cnt:SetHost(id);
			return
		else
			if (curhost==id) then
				curhost=0;
			end
		end
	end
	
	-- player list checked, last player in list was spectated previously,
	-- so let's spectate first player of list again
	if (firstpawn ~= 0) then
		spect.cnt:SetHost(firstpawn);
	else
		spect.cnt:SetHost(0);
	end
end

if (not GameRules.ScoreboardUpdate) then
	function GameRules:ScoreboardUpdate()
		-- Mixer: empty stuff to get rid of error reporting
	end
end

---
if (GameRules.ClientCommandTable.RPC) then
GameRules.ClientCommandTable["RPC"]=function(String,ServerSlot,TokTable)

	if (count(TokTable) ~= 1) then
		return;
	end

	local szReplyString = TokTable[1];
	
	-- Retrieve the number of players in each class
	-- Should be tracked during player join/part
	local ServerSlotMap = System:GetEntities();
	local TeamName = {"red", "blue",};

	for Team=1, 2 do
	
		szReplyString = szReplyString.." 0";
		
		for szClassName, ClassTable in MultiplayerClassDefiniton.PlayerClasses do
		
			local iClassCount = 0;

			for iSlotIndex, Slot in ServerSlotMap do
				if Slot.type=="Player" then
					local PlayerTeam = Game:GetEntityTeam(Slot.id);
					if (PlayerTeam == TeamName[Team]) then
						if PlayerTeam ~= "spectators" then
							local sCurrentClass = Slot.sCurrentPlayerClass;
							if (sCurrentClass and (strlower(sCurrentClass) == strlower(szClassName))) then
								iClassCount = iClassCount + 1;
							end
						end
					end
				end
			end
				
			szReplyString = szReplyString.." "..tostring(iClassCount);
		end
	end

	szReplyString = szReplyString.." "..tostring(GameRules:GetTeamMemberCountRL("spectators"));

	ServerSlot:SendCommand(szReplyString);
end
end
---

local wpn_mode = strupper(getglobal("g_GameType"));
if (strfind(wpn_mode,"PRO") == nil) and (wpn_mode~="SURVIVAL") and (wpn_mode~="WORLD") then
	function GameRules:UsualDamageCalculation(hit)
		local target = hit.target;
		local shooter = hit.shooter;
		local damage = hit.damage;
		if self.IgnoreDamageBetween and self:IgnoreDamageBetween(target,shooter,hit)==1 then 
			return 
		end
		
		if not shooter then																								-- explosive damage (entity id might be reassigned)
			local ss_shooter=Server:GetServerSlotBySSId(hit.shooterSSID);
			if ss_shooter then
				shooter = System:GetEntity(ss_shooter:GetPlayerId());
			end
		end

		if(shooter==nil)then
			shooter=hit.target; 
		end

		if (hit.explosion ~= nil) then
			local expl=target:IsAffectedByExplosion();
			if (expl<=0) then return end
			damage = expl * damage;
			hit.exp_stundmg = ceil(damage*0.45);
			BasicPlayer.SetBleeding(target,hit.exp_stundmg,damage,hit.shooterSSID);
			Server:BroadcastCommand("CHI "..shooter.id.." "..target.id.." "..damage);
		end

		if target==nil or target.type ~= "Player" or target.cnt.health<=0 then
			return nil;
		end

		local zone = target.cnt:GetBoneHitZone( hit.ipart);
		if zone==0 then zone = 2 end;
		local headshot;
		---
		if (target.hastits) and (hit.ipart) and (hit.ipart == 9) then ---- test headshot detector
			hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_head"));
		end
		if (hit.target_material) and (hit.target_material.type=="head") then
			headshot=1;
			if tonumber(getglobal("gr_HeadshotMultiplier"))~= nil then
				damage=damage*tonumber(getglobal("gr_HeadshotMultiplier"));
			end
			hit.damage_type = "healthonly";
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
					target.cnt.armor= target.cnt.armor - (damage*0.5);
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

		if (target.cnt.health>target.cnt.max_health) then
			target.cnt.health=target.cnt.max_health;
		end

		if target.cnt.health <= 0 then

			local shooterTeam = self.ReturnTeamThatDoesDamage(shooter,hit);

			target.cnt.health = 0;
			if (headshot) then
				target.hedshot = 1;
			end
			if shooter.id == target.id or shooter.type ~= "Player" then 
				return 2; -- shoot self or by neutral entity
			elseif Game:GetEntityTeam(target.id) == shooterTeam then
				return 3; -- player was killed by a team member
			else
				return 1; -- player was killed by enemy
			end
		end
		
		return nil;	-- player is still living
	end
end
	function GameRules:AddPlayerToScoreboard( idClient )
		--Fixed by Jeppa
		if idClient then
			local sslot = Server:GetServerSlotBySSId(idClient);
			if (sslot) then
				sslot.v_modversion = nil;
				System:LogAlways(date("%H:%M:%S").." Visitor: "..sslot:GetName());
				if (GameRules.SetCoopMission) then
					if (GameRules.coop_mission) then
						GameRules:SetCoopMission(GameRules.coop_mission*1,sslot);
					else
						GameRules:SetCoopMission(1,sslot);
					end
				elseif (GameRules.TransferTheStatus) then
					GameRules:TransferTheStatus(0,sslot);
				end
				local ents1 = System:GetEntities();
				-- Mixer: collect the status of survivors
				for i, ent in ents1 do
					if (ent.isvillager) then
						if (ent.cnt) and (ent.cnt.health>0) then
							sslot:SendCommand("SPS "..ent.id.." "..ent.cnt.health.." "..ent.cnt.max_health);
						end
					elseif (ent.MpRigidBody) then
						--------
						local ent_pos = new(ent:GetPos());
						local ent_ang = new(ent:GetAngles());
						sslot:SendCommand("FX",ent_pos,ent_ang,ent.id,2);
						----------
					elseif (ent.classname == "Gunship") then
						if (ent.damage>ent.Properties.max_health) then
							local pieces6 = {0,0,0,0,0,0,1};
							while ent.piecesId[pieces6[7]] do
								pieces6[pieces6[7]] = ent.piecesId[pieces6[7]]*1;
								pieces6[7] = pieces6[7]+1;
							end
							sslot:SendCommand("FX",{x=pieces6[1],y=pieces6[2],z=pieces6[3]},{x=pieces6[4],y=pieces6[5],z=pieces6[6]},ent.id,3);
						elseif (ent.rotorOn == 1) then
							sslot:SendCommand("FX",{x=ent.mountedWeaponId,y=0,z=0},{x=0,y=0,z=0},ent.id,1);
						end
					end
				end
				sslot:SendCommand("WTF");
			end
			local Entity = System:GetEntity(GameRules.idScoreboard).cnt;
			if not Entity then
				return;
			end
			local iY;
			local iLines=Entity:GetLineCount();
			for iY=0,iLines-1 do
				local idThisClient = toNumberOrZero(Entity:GetEntryXY(ScoreboardTableColumns.ClientID,iY))-1; -- first element is the clientid-1
				if idThisClient==-1 then
					Entity:SetEntryXY(ScoreboardTableColumns.ClientID,iY,idClient+1);
					if (GameRules.ScoreboardUpd) then
						GameRules:ScoreboardUpd();
					end
					return;
				end
			end
			Entity:SetEntryXY(ScoreboardTableColumns.ClientID,iLines,idClient+1);
		end
		if (GameRules.ScoreboardUpd) then
			GameRules:ScoreboardUpd();
		end
	end

function GetPlayerFromSSId(ssid)
local Slot = Server:GetServerSlotBySSId(ssid);
if (Slot) then
	return System:GetEntity(Slot:GetPlayerId());
else
	return System:GetEntity(ssid);
end
end

GameRules.ClientCommandTable["VBSPE"]=function(String,server_slot,toktable) -- get keypad passcode check/get server pawn for spectator / get powerup fx on connect
	if (toktable[3]) then
		local kpadtrgg = System:GetEntity(toktable[2]);
		if (kpadtrgg) and (kpadtrgg.Properties) and (kpadtrgg.ProcessKeyPadCode) then
			kpadtrgg:ProcessKeyPadCode(toktable[3]);
		end
	elseif (toktable[2]) then
		local spectatr = System:GetEntity(server_slot:GetPlayerId());
		local newpawn = System:GetEntity(toktable[2]);
		if (spectatr) and (spectatr.cnt) and (spectatr.cnt.SetHost) then
			if (newpawn) then
				local spcteam = Game:GetEntityTeam(spectatr.id);
				if (spcteam) and (spcteam == "spectators") then
					spectatr.cnt:SetHost(toktable[2]);
				end
			else
				-- just release spectator from following someone to go free roam
				spectatr.cnt:SetHost(0);
			end
		end
	else
		local allbots = System:GetEntities();
		if (allbots) then
			for i,vbot in allbots do
				if (vbot.bot_team) then
					local botinvtime = 0;
					if (vbot.invulnerabilityTimer) and (vbot.invulnerabilityTimer-_time > 0) then
						botinvtime = vbot.invulnerabilityTimer-_time;
					end
					server_slot:SendCommand("FX", {x=vbot.Properties.my_color[1],y=vbot.Properties.my_color[2],z=vbot.Properties.my_color[3]}, {x=botinvtime,y=0,z=0},vbot.id,0);
					if vbot.idUnitHighlight then
						server_slot:SendCommand("FX "..tonumber(vbot.id), g_Vectors.v000, g_Vectors.v000,vbot.idUnitHighlight,0);
					end
				end
			end
		end
	end
end

GameRules.ClientCommandTable["FTW"]=function(String,server_slot,toktable)
	if (toktable[2]) then
		server_slot.v_modversion = toktable[2];
	end
end

GameRules.ClientCommandTable["VB_GV"]=function(String,server_slot,toktable) -- get server votable/alt fire server stuff/gesture/draw wrench in survival
	if (toktable[3]) then
		local grb_guy = System:GetEntity(server_slot:GetPlayerId());
		if (grb_guy) then
			local op_id = tonumber(toktable[3]);
			local op_num = tonumber(toktable[2]);
			if (op_num) and (op_num == 1) then
				op_id = floor(op_id);
				grb_guy.items.gr_item_ang = op_id*1;
				Server:BroadcastCommand("CSH -"..grb_guy.id.." "..op_id);
			else
				if (op_id) then
					grb_guy:CarryPhysItem(80,floor(op_id));
				end
			end
		end
	elseif (toktable[2]) then
		local sht_guy = System:GetEntity(server_slot:GetPlayerId());
		if (sht_guy) then
			local op_id = tonumber(toktable[2]);
			if (op_id > 0) then
				if (sht_guy.cnt) and (sht_guy.cnt.health > 0) then
					if (op_id > 100) and (sht_guy.is_mutatd_sv) then
						if GameRules:ModeDesc() == "HUNT" then
							if (op_id == 101) then
								if (sht_guy.Grab_Invisibility) then
									sht_guy:Grab_Invisibility(900);
								end
							elseif (op_id == 102) then
								if (sht_guy.Grab_Invisibility) then
									sht_guy.items.invis_active = 0;
								end
							end
						end
						do return end
					end
					Server:BroadcastCommand("ACWR "..sht_guy.id.." "..toktable[2]);
				end
			elseif (op_id < 0) then
				if (sht_guy.cnt) and (sht_guy.cnt.GetWeaponsSlots) then
					local ws = sht_guy.cnt:GetWeaponsSlots();
					if (ws) then
						local haswrench = 0;
						for i,val in ws do
							if (val~=0) then
								if (val.name == "EngineerTool") then
									haswrench = 1;
									break;
								end
							end
						end
						if (haswrench == 1) then
							sht_guy.cnt:SetCurrWeapon(27);
						else
							if (sht_guy.cnt.weapon) and (sht_guy.cnt.weapon.name~="EngineerTool") then
								if (sht_guy.cnt.weapon.name=="MedicTool") then
									sht_guy.cnt:SelectNextWeapon();
								end
								sht_guy.su_LastRepTime = _time + 2.2;
								BasicWeapon.Server.Drop(sht_guy.cnt.weapon, {Player = sht_guy});
							end
						end
					end
				end
			elseif (sht_guy.cnt) and (sht_guy.cnt.weapon) and (sht_guy.cnt.weapon.ZoomAsAltFire) then
				sht_guy.cnt.weapon:ZoomAsAltFire(sht_guy);			
			end
		end
	else
		-------- Mixer: sending current state of various votable gameplay settings, to vote for
		local v_settings = "";
		v_settings = v_settings..getglobal("bot_quota").." ";
		v_settings = v_settings..getglobal("bot_difficulty").." ";
		v_settings = v_settings..getglobal("gr_su_handicap"); -- < -- last parameter of table goes without .." "
		if (MapCycle.MapList) and (getn(MapCycle.MapList)>0) then
			for key,val in MapCycle.MapList do
				local maplowr = strlower(val.szName);
				if (val.szName) and (strfind(v_settings," "..maplowr.." ")==nil) then
					v_settings = v_settings.." "..maplowr;
				end
			end
		end
		--------------------------
		server_slot:SendCommand("VB_SST "..v_settings);
	end
end

------
function GameRules:ChangeTeam(server_slot, new_team, force)
	if toNumberOrZero(getglobal("gr_allow_spectators"))==0 then
		if new_team=="spectators" then
			server_slot:SendText("Spectating is not allowed in this game");
			return;	
		end
	end

	local player_id = server_slot:GetPlayerId();
	local requested_classid = PLAYER_CLASS_ID;
	
	if player_id ~= 0 then
		local player = System:GetEntity(player_id);
		local old_team = Game:GetEntityTeam(player_id);
					
		if force or new_team ~= old_team then
			---------- client/server mod version check -----
			if (server_slot.v_modversion) and (server_slot.v_modversion == System.this_mod_version) then
			else
				local cl_vers = "Before "..System.this_mod_version;
				if (server_slot.v_modversion) then
					cl_vers = server_slot.v_modversion.."";
				end
				System:LogAlways(date("%H:%M:%S").." Quit: "..server_slot:GetName().." - mod version "..cl_vers);
				server_slot.v_modversion = nil;
				server_slot:Disconnect("@GameVersionError \nYour mod: "..cl_vers.." \nOur mod: "..System.this_mod_version);
				return;
			end
			------------
			if new_team=="spectators" then
				requested_classid=SPECTATOR_CLASS_ID;
				if (self.respawnList) then
					self.respawnList[server_slot] = nil;
				end
				local newEntity=self:SpawnPlayer(server_slot,requested_classid,new_team);
				Server:AddToTeam("spectators",newEntity.id);
				System:LogAlways(date("%H:%M:%S").." Team: "..server_slot:GetName().." - "..new_team);
				if (GameRules.ScoreboardUpd) then
					GameRules:ScoreboardUpd();
				end
				return;
			end

			if (self.respawnList and  (self:GetGameState() ~= CGS_PREWAR)) then
				self.respawnList[server_slot] = {classid = requested_classid, team = new_team,};
			else
				local newEntity=self:SpawnPlayer(server_slot,requested_classid,new_team);
				Server:AddToTeam(new_team, newEntity.id);
				
				if (self.SetTeamObjectivesOnePlayer) then
					self:SetTeamObjectivesOnePlayer(server_slot);
				elseif (GameRules.ScoreboardUpd) then
					GameRules:ScoreboardUpd();
				end
					
				if (self.UpdateCaptureProgressOnePlayer) then
					self:UpdateCaptureProgressOnePlayer(server_slot);
				end
			end
			System:LogAlways(date("%H:%M:%S").." Team: "..server_slot:GetName().." - "..new_team);
		end
        end
end
--------

function GameRules:UsualScoreCalculation( hit, damage_ret )
	
	if damage_ret==nil then													
	return
	end
	
	local target = hit.target;
	local shooter = hit.shooter;
	local situation = 0;
	local delta = 1;

	target:GotoState("Dead");		

	local ss_target=Server:GetServerSlotByEntityId(target.id);
	if (target.bot_born) then
	ss_target=target; end
	local ss_shooter;

	if shooter then -- non explosive damage
		ss_shooter=Server:GetServerSlotByEntityId(shooter.id);
		if (shooter.bot_born) then
			ss_shooter=shooter;
		end
	else -- explosive damage (entity id might be reassigned)
		ss_shooter=Server:GetServerSlotBySSId(hit.shooterSSID);
       		if ss_shooter then -- might be nil e.g. vehicle destroyes itself
    			shooter = System:GetEntity(ss_shooter:GetPlayerId());
    		elseif (hit.shooterSSID) then
			local entlist = System:GetEntities();
			for i, entity in entlist do
				if (entity.vbot_ssid) then
					if (entity.vbot_ssid == hit.shooterSSID) then
					shooter = entity;
					ss_shooter = entity;
					if (damage_ret==2) and (target.id~=shooter.id) then
						damage_ret=1;
					end
					break;
					end
				end
			end
		end
  	end
	local weapon = "World";
	
	if (hit.weapon) then
		if (hit.weapon.IsBoat) then
			weapon="Boat";
		elseif (hit.weapon.IsVehicle) then
			weapon="Vehicle";
		elseif (hit.weapon.name) then
			weapon = new(hit.weapon.name);
		else
			weapon = new(hit.weapon.classname);
		end
		if (shooter) then
			if (shooter.theVehicle) and (shooter.theVehicle.InitCommonAircraft) then
				weapon = "HoverMG";
			elseif (shooter.su_turret) then
				weapon = "ADT10";
			elseif (shooter.classname == weapon) then
				weapon = "COVERRL";
			end
		end
	elseif (shooter) and (target) and (shooter ~= target) then
		weapon = "Claws";
	end
	local minstreak;
	local targetstreak;
	local killstreak;
	if (SVplayerTrack) then
	minstreak=toNumberOrZero(getglobal("gr_killing_spree"));
	if (not target.bot_born) then
	targetstreak = SVplayerTrack:GetBySs(ss_target, "killstreak");
	if (SVcommands:TKActive(ss_target:GetId())==1) then
		SVcommands:TKVerdict(ss_target:GetId(),0,-1);
	end
	else
		if (not target.bot_killstreak) then
			target.bot_killstreak = 0;
		end
		targetstreak = target.bot_killstreak;
	end
	end

	if damage_ret==2 then			-- shoot self or by neutral entity
		situation = 1;
		delta = -1;
		if (not target.bot_born) then
		MPStatistics:AddStatisticsDataEntity(target,"nSelfKill",1);

		if (SVplayerTrack) then
		SVplayerTrack:SetBySs(ss_target, "selfkills", 1, 1);
		SVplayerTrack:SetBySs(ss_target, "deaths", 1, 1);
		SVplayerTrack:SetStaticSpawn(ss_target);

		if (minstreak~=0) and (targetstreak>=minstreak) then
			if (weapon=="Boat") then
				Server:BroadcastText("$6Killing spree of $4"..targetstreak.." KILLS $6("..ss_target:GetName().."$6) was $4ended$6 by a BOAT",2);
			elseif (weapon=="Vehicle") then 
				Server:BroadcastText("$6Killing spree of $4"..targetstreak.." KILLS $6("..ss_target:GetName().."$6) was $4ended$6 by a CAR",2);
			else
				Server:BroadcastText(ss_target:GetName().."$4 ended $6his own killing spree of $4"..targetstreak.." KILLS",2);
			end
			
		end

		end -- svpltrk
		end -- isn't bot
	else
if (hit.target.hedshot) then -- HEAD SHOT
	hit.target.hedshot = nil; -- clear .hedshot to prevent accidental repeat
	if (weapon=="Shocker") then
	else
	situation = 3; -- Mixer: new headshot announcement
	if (not ss_shooter.bot_born) and (damage_ret~=3) then
		MPStatistics:AddStatisticsDataSSId(ss_shooter:GetId(),"nHeadshot",1); -- successfully killed by headshot
		if (SVplayerTrack) then SVplayerTrack:SetBySs(ss_shooter,"headshots", 1, 1); end
	end
	end
end
if damage_ret==1 then -- player was killed by enemy
if (ss_shooter.bot_born) then
if (not ss_shooter.bot_killstreak) then
	ss_shooter.bot_killstreak = 0;
end
ss_shooter.bot_killstreak = ss_shooter.bot_killstreak + 1;
killstreak=ss_shooter.bot_killstreak;
else
MPStatistics:AddStatisticsDataSSId(ss_shooter:GetId(),"nKill",1);

			if (SVplayerTrack) then
			SVplayerTrack:SetWeaponKill(ss_shooter, weapon);
			if (not ss_target.bot_born) then
			SVplayerTrack:SetBySs(ss_target, "deaths", 1, 1);
			SVplayerTrack:SetStaticSpawn(ss_target);
			end
			local iCurrState=tonumber(GameRules.CurrentProgressStep);
			if iCurrState then
				if (iCurrState > 1) then
					SVplayerTrack:SetBySs(ss_shooter, "flagactkills", 1, 1);  --kill when flag was activated
				end
			end
			SVplayerTrack:SetBySs(ss_shooter, "kills", 1, 1);
			if toNumberOrZero(getglobal("gr_rm_needed_kills"))>0 then
				SVplayerTrack:RMAddKill(ss_shooter);
			end
			SVplayerTrack:SetBySs(ss_shooter, "killstreak", 1, 1);
			killstreak=SVplayerTrack:GetBySs(ss_shooter,"killstreak");
			if (killstreak>SVplayerTrack:GetBySs(ss_shooter,"hkillstreak")) then
				SVplayerTrack:SetBySs(ss_shooter,"hkillstreak",killstreak,0);
			end
			end -- svplayertrk
end
			if (minstreak~=nil) and (minstreak~=0) and (killstreak>=minstreak) then
				if toNumberOrZero(getglobal("gr_killing_spree_display")) == 0 then  --display message at each kill
					local wpnname = new(weapon);
					if (wpnname == "HandGrenade") then wpnname = "Hand Grenade";
					elseif wpnname == "SniperRifle" then wpnname = "Sniper Rifle"; end
					Server:BroadcastText(ss_shooter:GetName().."$6 is on a killing spree! ($4"..killstreak.." KILLS$6) (last kill with $4"..wpnname.."$6)",2);
				end
			end
			if (targetstreak) and (minstreak~=0) and (targetstreak>=minstreak) then
				Server:BroadcastText("$6Killing spree of $4"..targetstreak.." KILLS $6("..ss_target:GetName().."$6) was $4ended$6 by $o"..ss_shooter:GetName(),2);
			end
elseif damage_ret==3 then -- player was killed by a team member
if (situation~=3) then
	situation = 2;
end
delta = -1;
if (not ss_shooter.bot_born) then
MPStatistics:AddStatisticsDataSSId(ss_shooter:GetId(),"nTeamKill",1);
if (SVplayerTrack) then
if (not ss_target.bot_born) then
delta = 0;
SVcommands:TKJudge(ss_target:GetId(),ss_shooter:GetId());
ss_target:SendText("Press ESC to judge your team killer.");
SVplayerTrack:SetBySs(ss_target, "deaths", 1, 1);
SVplayerTrack:SetStaticSpawn(ss_target);
end

if (targetstreak) and (minstreak~=0) and (targetstreak>=minstreak) then
Server:BroadcastText("$6Killing spree of $4"..targetstreak.."$6 ("..ss_target:GetName().."$6) was $4ended$6 by his TEAMMATE $o"..ss_shooter:GetName(),2);
end

end -- svplayertrk
end -- ifnotbot
end
end
	-- score changes?
	if ((shooter and shooter.type == "Player") or (damage_ret == 2)) then
	if (not shooter) then
	target.cnt.score=target.cnt.score+delta;
	else
		shooter.cnt.score=shooter.cnt.score+delta;
		if (shooter.bot_team) then shooter:SetBotStats(1); end
		if (situation == 3) then
			System:LogAlways(date("%H:%M:%S").." Headshot: "..shooter:GetName().." ("..weapon..") "..target:GetName());
		else
			System:LogAlways(date("%H:%M:%S").." Kill: "..shooter:GetName().." ("..weapon..") "..target:GetName());
		end
	end
	end

	if (target.type == "Player") then
		target.cnt.deaths=target.cnt.deaths+1;
		if (target.bot_team) then target:SetBotStats(1); end
		if (SVplayerTrack) and (not ss_target.bot_born) then
		target.death_time = _time;
		if toNumberOrZero(getglobal("gr_rm_needed_kills"))>0 then
			SVplayerTrack:RMResetOne(ss_target);
		end
		end
	end
	
	-- send hud text message to all clients
	if ss_shooter then
		Server:BroadcastCommand("PKP "..target.id.." "..ss_shooter:GetPlayerId().." "..situation.." "..weapon);
	else
		Server:BroadcastCommand("PKP "..target.id.." 0 "..situation.." "..weapon);
	end

	if ss_target then
	ss_target.last_death=_time;
	end

	Game:ForceScoreBoard(target.id, 1);
	return delta;
end
-- HACKS END
	System:LogAlways(date("%H:%M:%S").." Playing now: MAP - "..Game:GetLevelName()..", CONTEST - "..getglobal("g_GameType"));
	--
	if (SVplayerTrack) then
	if toNumberOrZero(getglobal("gr_keep_lock"))==0 then
	SVcommands:SVunlockall();
	end
	SVplayerTrack:Init();
	end
	if (not self:IsOk()) then
	return
	end

	self.iNextMap = self.iNextMap + 1;
	
	if (not self.MapList[self.iNextMap]) then
		self.iNextMap = 1;
	end
	
	setglobal("gr_NextMap", self.MapList[self.iNextMap].szName);

	System:Log("  set gr_NextMap to "..tostring(getglobal("gr_NextMap")));
	System:Log("  set iNextMap to "..self.iNextMap);
end

-- call this to know if a map cycling is possible or no
function MapCycle:IsOk()
	if (self.MapList and (count(self.MapList) > 0)) then
		return 1;
	end
	
	return nil;
end

-- call this to know if the scores are being shown, as a result of map finished
function MapCycle:IsShowingScores()
	if (self.fFinishedTimer or self.fRestartTimer) then
		return 1;
	end
	
	return nil;
end

-- call this when the map is finished
-- this function should load nextmap, and update self
function MapCycle:OnMapFinished(quiet)

	if (not quiet) then
		MPStatistics:Print();
	end
	
	if (SVplayerTrack) and (toNumberOrZero(getglobal("gr_stats_export"))==1) then
	SVplayerTrack:ExportStats();
	end

	GameRules:ForceScoreBoard(1);
	self.fFinishedTimer = _time + 2;
end

-- call this function every frame
-- prolly from GameRules:OnUpdate()
function MapCycle:Update()
	if (self.fFinishedTimer) and (_time > self.fFinishedTimer) then

		self.fFinishedTimer = nil;

		if (not self:IsOk()) then
			self.fRestartTimer = _time + 5;
			Server:BroadcastText("@GameRestartIn $35$o @GameStartingInSeconds", 1);
			return
		end
		
		local Map = self.MapList[self.iNextMap];
		
		if (Map) then
			if (Map.szRoundlimit) then
				setglobal("gr_su_roundlimit",Map.szRoundlimit);
			end
			if (SVplayerTrack) then
				GameRules:ChangeMap(Map.szName, Map.szGameType, Map.szTimeLimit, Map.szRespawnTime, Map.szInvulnerabilityTimer, Map.szMaxPlayers, Map.szMinTeamLimit, Map.szMaxTeamLimit);
			else
				GameRules:ChangeMap(Map.szName, Map.szGameType);
			end
		end
	elseif (self.fRestartTimer) then		

		if (_time > self.fRestartTimer) then

			self.fRestartTimer = nil;
			
			if tostring(getglobal("gr_PrewarOn"))~="0" then
				self:NewGameState(CGS_PREWAR);
			else
				GameRules:DoRestart();
			end
		end
	end

-- Mixer: RailMatch Rules check:
if tonumber(getglobal("cis_railonly"))~=0 then
	-- not soccer and not chess
	if (GameRules.soccerball==nil) and (GameRules.cell_names==nil) then
		GameRules.insta_play = 1;
	end
else
	GameRules.insta_play = nil;
end

-- Mixer: Physical Item Carriers Management:
if (GameRules.PhysCarriers) then
	for i, cid in GameRules.PhysCarriers do
		if (i ~= "n") then
			local c_ent = System:GetEntity(floor(cid));
			if (c_ent) and (c_ent.items) and (c_ent.items.gr_item_id) then
				c_ent:CarryPhysItem(80);
			else
				tremove(GameRules.PhysCarriers,i);
			end
		end
	end
end

-- VERYSOFT BOTS HANDLER
local bots_quota = tonumber(getglobal("bot_quota"));
if (bots_quota == 0) and (self.vbots_num <= 0) then
	return; -- do nothing
end

local players_qu=0;
local players_max=0;

if (GameRules.bIsTeamBased) then
	local slots = Server:GetServerSlotMap();
	local b_red = 0;
	local b_blu = 0;
	if (GameRules.bot_common) then
		b_red = GameRules.bot_common.redsum * 1;
		b_blu = GameRules.bot_common.bluesum * 1;
	end
	for i, slot in slots do
		local player_id=slot:GetPlayerId();
		player_id = Game:GetEntityTeam(player_id);
		if (player_id=="blue") then
			players_qu=players_qu+1;
			b_blu = b_blu + 1;
		elseif (player_id=="red") then
			players_qu=players_qu+1;
			b_red = b_red + 1;
		end
	end
	
	if abs(b_red - b_blu) > 1 then
		-- perform team autobalance (only if no team locks are set)
		if (toNumberOrZero(getglobal("gr_forcebluejoin")) +  toNumberOrZero(getglobal("gr_forceredjoin")) == 0) then
			players_qu = players_qu + 1;
		end
	end
else
	players_qu=GameRules:GetPlayerTeamCount("players");
end

if (tonumber(getglobal("bot_always")) < 1) then
	if (GameRules:GetPlayerTeamCount("spectators") + players_qu <= 0) then
		-- get rid of bots if no humans are present on the server
		bots_quota = 0;
	end
end

if (bots_quota ~= self.vbots_num+players_qu) then
	if (tonumber(getglobal("bot_enable"))< 1) then
		setglobal("bot_quota",0);
		Server:BroadcastText("$1CIS Judge: $4Verysoft bots are DISABLED on this server!");
		if (self.vbots_num <= 0) then
			return;
		end
	end

	players_max=tonumber(getglobal("sv_maxplayers"));
	if (bots_quota > players_max) then
		System:LogAlways("Verysoft Bots Quota incorrect, setting now to "..tostring(players_max).." bot(s)");
		setglobal("bot_quota",players_max);
		bots_quota = players_max;
	elseif (bots_quota) < 0 then
		System:LogAlways("Verysoft Bots Quota incorrect, setting now to 0 (NO) bots");
		setglobal("bot_quota",0);
		bots_quota = 0;
	end

if (self.vbots_nextcheck < _time) then
if (bots_quota > self.vbots_num+players_qu) then
local vbot_new=0;
local vbot_preset = random(1,3);
local vb_pickname= random(1,NameGenerator.HumanNameCount);
local vb_color = random(1,getn(MultiplayerUtils.ModelColor));
vb_color = MultiplayerUtils.ModelColor[vb_color];

if (not GameRules.bot_common) then
	GameRules.bot_common={};
	GameRules.bot_common.bluesum=0;
	GameRules.bot_common.redsum=0;
end
if (not GameRules.bot_commonprops) then
GameRules.bot_commonprops = {
KEYFRAME_TABLE = "BASE_HUMAN_MODEL",
SOUND_TABLE = "",
bNoRespawn = 0,
bInvulnerable = 0,
bSleepOnSpawn = 0,
bHasArmor = 0,
special = 0,
bIsBot=1,
aggression = 0.9,
commrange = 30.0,
attackrange = 180,
horizontal_fov = 120,
eye_height = 2.1,
forward_speed = 1.27,
back_speed = 1.27,
max_health = 255,
accuracy = 0.6,
responsiveness = 7,
species = 0,
fSpeciesHostility = 2,
fGroupHostility = 0,
fPersistence = 0,
AnimPack = "Basic",
SoundPack = "",
pathname = "",
ReinforcePoint = "",
CustomGunAI = "",
fileCustomModel = "",
bTrackable=1,
};
if (Game:IsClient()) then
	-- listen srv
	setglobal("game_Accuracy",1);
	setglobal("game_Aggression",1);
else
	-- dedicated server
	setglobal("game_Accuracy",0.7);
	setglobal("game_Aggression",0.8);
end
end

local vbot_name = toNumberOrZero(getglobal("bot_difficulty"));
if (vbot_name < 1) or (vbot_name > 3) then
	vbot_name = 2;
	setglobal("bot_difficulty",2);
end
if (vbot_name == 1) then
	GameRules.bot_commonprops.accuracy = 0.3;
	GameRules.bot_commonprops.aggression = 0.5;
elseif (vbot_name == 3) then
	GameRules.bot_commonprops.accuracy = 0.9;
	GameRules.bot_commonprops.aggression = 0.9;
else
	GameRules.bot_commonprops.accuracy = 0.6;
	GameRules.bot_commonprops.aggression = 0.7;
end

vbot_name = NameGenerator.HumanTable[vb_pickname][1];

if (GameRules.bIsTeamBased) then
	local tmpbluesum=GameRules:GetPlayerTeamCount("blue");
	local tmpredsum=GameRules:GetPlayerTeamCount("red");
	local isblueforced = toNumberOrZero(getglobal("gr_forcebluejoin"));
	local isredforced= toNumberOrZero(getglobal("gr_forceredjoin"));
	
	if (isblueforced > 0) then
		tmpbluesum = -99999;
	elseif (isredforced > 0) then
		tmpbluesum = 99999;
	end
	
	if (tmpbluesum+GameRules.bot_common.bluesum)>(tmpredsum+GameRules.bot_common.redsum) then
		vb_color={1,0,0}; -- bot goes to red team
		if (getglobal("bot_tag") ~= "none") then
			vbot_name = "$4["..getglobal("bot_tag").."] $1"..vbot_name;
		end
	else
		vb_color={0,0,1}; -- bot goes to blue team
		if (getglobal("bot_tag") ~= "none") then
			vbot_name = "$2["..getglobal("bot_tag").."] $1"..vbot_name;
		end
	end
else
	if (getglobal("bot_tag") ~= "none") then
		vbot_name = "$3["..getglobal("bot_tag").."] $1"..vbot_name;
	end
end

if (GameRules.IsDefender) then -- Assault gametype
	---
	-- let's define the classes count
	local c_botprops = {0,0,0,0,0,0}; -- [blue 1 2 3] grunts, snipers, support, [red 4 5 6] grunts, snipers, support
	local c_ents = System:GetEntities();
	local offset = 0;

	for j,ent in c_ents do
		if (ent.type == "Player") and (ent.sCurrentPlayerClass) then
			if Game:GetEntityTeam(ent.id) == "red" then
				offset=3; -- shortcut to put record in team-accordingly cell (red grunts amount will go to 1+3 = 4 cell, while blue grunts will go to 1+0=1 cell)
			else
				offset=0;
			end
			if ent.sCurrentPlayerClass == "Grunt" then
				c_botprops[1+offset] = c_botprops[1+offset]+1;
			elseif ent.sCurrentPlayerClass == "Sniper" then
				c_botprops[2+offset] = c_botprops[2+offset]+1;
			elseif ent.sCurrentPlayerClass == "Support" then
				c_botprops[3+offset] = c_botprops[3+offset]+1;
			end
		end
	end

	if vb_color[1] == 1 then -- decision for red team
		offset=3;
	else
		offset=0;
	end
	-- now we know how many each classes of each team are present, let's decide which class will take the bot being added
	if (vbot_preset == 1) and (tonumber(getglobal("gr_max_grunts")) <= c_botprops[1+offset]) then -- no space for grunts
		if (tonumber(getglobal("gr_max_engineers")) > c_botprops[3+offset]) then -- spare space for engineers
			vbot_preset = 3; -- ok, let's try to become an engineer
		else
			vbot_preset = 2; -- ok, let's try to become a sniper
		end
	elseif (vbot_preset == 3) and (tonumber(getglobal("gr_max_engineers")) <= c_botprops[3+offset]) then -- no space for engineers
		if (tonumber(getglobal("gr_max_snipers")) > c_botprops[2+offset]) then -- spare space for snipers
			vbot_preset = 2; -- ok, let's try to become a sniper
		else
			vbot_preset = 1; -- ok, let's try to become a grunt
		end
	elseif (vbot_preset == 2) and (tonumber(getglobal("gr_max_snipers")) <= c_botprops[2+offset]) then -- no space for snipers
		if (tonumber(getglobal("gr_max_engineers")) > c_botprops[3+offset]) then -- spare space for engineers
			vbot_preset = 3; -- ok, let's try to become an engineer
		else
			vbot_preset = 1; -- ok, let's try to become a grunt
		end
	end
	---

	if vbot_preset == 1 then
		vbot_new = MultiplayerClassDefiniton.PlayerClasses.Grunt.model;
	elseif vbot_preset == 2 then
		vbot_new = MultiplayerClassDefiniton.PlayerClasses.Sniper.model;
	else
		vbot_new = MultiplayerClassDefiniton.PlayerClasses.Support.model;
	end
	c_botprops = new(GameRules.bot_commonprops);
	c_botprops.my_color = vb_color;
	c_botprops.my_class = vbot_preset;
	vbot_new=Server:SpawnEntity({classid=PLAYER_CLASS_ID,name=vbot_name,model=vbot_new,color=vb_color,properties=c_botprops});
else
	-- pick model
	if (GameRules.InitialPlayerProperties) and (GameRules.InitialPlayerProperties.model) then
		vbot_new = GameRules.InitialPlayerProperties.model;
	else
		vbot_preset = 0;
		for mcount,val in MPModelList do
			if (val.name) then
				vbot_preset = vbot_preset+1;
			end
		end
		vbot_preset=random(1,vbot_preset);
		vbot_new=MPModelList[vbot_preset].model;
	end
	-- pick model
	local c_botprops = new(GameRules.bot_commonprops);
	c_botprops.my_color = vb_color;
	vbot_new=Server:SpawnEntity({classid=PLAYER_CLASS_ID,name=vbot_name,model=vbot_new,color=vb_color,properties=c_botprops});
end

-- tuRnst!LL : set the bot properties and sync it on clientside
if vbot_new and vbot_new.type=="Player" then
	if vbot_new.DynProp then
		vbot_new.cnt:SetDynamicsProperties(vbot_new.DynProp);
	end
	if vbot_new.move_params then
		vbot_new.cnt:SetMoveParams(vbot_new.move_params);
	end
	local tPlayerClass={"Grunt", "Sniper", "Support",};
	if vbot_new.Properties.my_class then
		Server:BroadcastCommand("YCN "..vbot_new.id.." "..tPlayerClass[vbot_new.Properties.my_class]);
	else
		Server:BroadcastCommand("YCN "..vbot_new.id.." DefaultMultiPlayer");
	end
end
-- End tuRnst!LL

if (vbot_new) then
	self.vbots_num = self.vbots_num + 1;
end
self.vbots_nextcheck = _time + 2;

elseif (bots_quota < self.vbots_num+players_qu) then
local kick_candidate;
local entities=System:GetEntities();
for i, entity in entities do
	if (entity.bot_team) then
		kick_candidate = entity;
		if (GameRules.bIsTeamBased) then
			local red_cnt = GameRules.bot_common.redsum+GameRules:GetPlayerTeamCount("red");
			local blue_cnt = GameRules.bot_common.bluesum+GameRules:GetPlayerTeamCount("blue");
			if (red_cnt > blue_cnt) and (entity.bot_teamname=="red") then break;
			elseif (blue_cnt > red_cnt) and (entity.bot_teamname=="blue") then break; end
		else
			break; -- kick first encountered bot if isn't team game
		end
	end
end
if (kick_candidate) then
	kick_candidate.bot_disconnectnow = 1;
	kick_candidate:VBotEradicate();
	self.vbots_num = self.vbots_num - 1;
	self.vbots_nextcheck = _time + 2;
end
end

end -- time to check
else
self.vbots_nextcheck = _time + 4;
end -- botcheck

end

-- load the map cycle file
function MapCycle:Reload()
	local modsvname = getglobal("sv_name");
	if (modsvname) and (System.this_mod_version) then
		if (strfind(modsvname,System.this_mod_version) == nil) then
			setglobal("sv_name",modsvname.." "..System.this_mod_version);
		end
	end
	if (getglobal("sv_mapcyclefile")) then
		MapCycle:LoadFromFile(getglobal("sv_mapcyclefile"));
	end
	self.iNextMap = 1;
end

MapCycle:Reload();
