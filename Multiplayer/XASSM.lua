--
-- Created by Garbitos
--
if (not XASSM) then
	XASSM = {
		ssm_status = "pass",
		ssm_rate = nil,
	};
end
--
function ssm(quiet,force) --check local game for ssm availability (is multiplayer game host?), also refresh needed functions and vars
	System:Log("SSM CHECK...");
	if (not force) then
		if (not getglobal("gr_ssm_status")) or (tostring(getglobal("gr_ssm_status"))=="off") then
			if (not quiet) then 
				System:LogAlways("Server-Side Mod is disabled... Multiplayer: ["..toNumberOrZero(Game:IsMultiplayer()).."] Client: ["..toNumberOrZero(Game:IsClient()).."] Server: ["..toNumberOrZero(Game:IsServer()).."] ");
				setglobal("gr_ssm_status","off");
				XASSM = nil; --hand-in-face
				Gamestyler = nil; --talk-to-the-hand
			end
			System:Log("...DISABLED BY USER");
			return nil;
		end
		if (UI) then
			if (Game:IsMultiplayer() and not Game:IsServer()) then 
				if (not quiet) then 
					System:LogAlways("Server-Side Mod inactive for clients... Multiplayer: ["..toNumberOrZero(Game:IsMultiplayer()).."] Client: ["..toNumberOrZero(Game:IsClient()).."] Server: ["..toNumberOrZero(Game:IsServer()).."] ");
					setglobal("gr_ssm_status","pass");
					XASSM = nil; --hand-in-face
					Gamestyler = nil; --talk-to-the-hand
				end
				System:Log("...NOT AVAILABLE AS CLIENT");
				return 0;
			elseif (not Game:IsMultiplayer()) then 
				if (not quiet) then 
					System:LogAlways("Server-Side Mod inactive in singleplayer... Multiplayer: ["..toNumberOrZero(Game:IsMultiplayer()).."] Client: ["..toNumberOrZero(Game:IsClient()).."] Server: ["..toNumberOrZero(Game:IsServer()).."] ");
					setglobal("gr_ssm_status","pass");
					--Gamestyler = nil;
					--XASSM = nil;
				end
				System:Log("...NOT AVAILABLE IN SINGLEPLAYER");
				return 0;
			end
		end
	end
	if (Game:IsServer()) or (not UI) or (force==1) then
		if (not quiet) then
			System:LogAlways("Server-Side Mod is enabled... Multiplayer: ["..toNumberOrZero(Game:IsMultiplayer()).."] Client: ["..toNumberOrZero(Game:IsClient()).."] Force: ["..tostring(force).."] ");
			if (not UI) then
				if getglobal("gr_DedicatedServer")==nil then Game:CreateVariable("gr_DedicatedServer",0); else Game:CreateVariable("gr_DedicatedServer",getglobal("gr_DedicatedServer")); end
			end
			System:Log("XASSM.ssm: Loading/Refreshing SSM...");
			if (not getglobal("gr_ssm_version")) then System:Log("XASSM.ssm: Loading XASSM vars/commands..."); XASSM:Init(); end
			Script:ReloadScript("scripts/Multiplayer/MultiplayerUtils.lua"); --conatins basicplayer override stuff
			if (not Gamestyler) then System:Log("XASSM.ssm: Loading Gamestyler..."); Script:ReloadScript("scripts/multiplayer/Gamestyler.lua"); Gamestyler:Init(); end
			if (not MapCycle.MapList) or (not MapCycle.VoteList) then MapCycle:Reload(); end
			setglobal("gr_ssm_status","on");
			XASSM.ssm_status=getglobal("gr_ssm_status");
			setglobal("gr_checkfirststart",2);
			--
			System:Log("XASSM.ssm: Reloading associated lua's...");
			if (BasicWeapon) then
				Gamestyler:MPsetWeaponSpeedScale(1); --pure patch weapon speeds
				--needed for kit restrictions
				Script:ReloadScript("scripts/default/entities/weapons/OICWgrenade.lua");
				Script:ReloadScript("scripts/default/entities/weapons/VehicleMountedRocketMG.lua");
				Script:ReloadScript("scripts/default/entities/weapons/Rocket.lua");
				Script:ReloadScript("scripts/default/entities/weapons/VehicleRocket.lua");
			end
			--reload important lua's
			Script:ReloadScript("scripts/multiplayer/MultiplayerClassDefiniton.lua");
			Script:ReloadScript("scripts/default/entities/weapons/WeaponsParams.lua");
		end
		System:Log("...SSM ACTIVE");
		return 1;
	elseif (UI) and (BasicWeapon) then
		Gamestyler:MPsetWeaponSpeedScale(); --pure patch weapon speeds
	end
	System:Log("SSM CHECK...NOTHING TO REPORT");
end
--
function XASSM:Init()
	System:Log("XASSM.Init: Declare XASSM vars/commands");
	Script:ReloadScript("scripts/multiplayer/CreateVariables.lua");
	--XASSM server/admin commands
	Game:AddCommand("sv_autotune","XASSM:autoTune(%1);","sv_autotune [players]"); --run autotune once, optional with forced player amount
	Game:AddCommand("sv_team_balance","XASSM:autoBalance();","sv_team_balance"); --run team auto-balance routine, moves random player to the free team
	Game:AddCommand("sv_reboot","XASSM:rebootTimer(%1);","sv_reboot [countdown]"); --reboots the server after entered 3 times (garbitos clean)
	--XASSM map commands
	Game:AddCommand("sv_hardrestart","XASSM:RestartMap();","sv_hardrestart"); --full/hard restart of current map (garbitos fix!)
	--XASSM server messages from task.txt
	Game:AddCommand("gr_ss_nowplaying","XASSM:serverSayNowPlaying();","gr_ss_nowplaying"); -- sends "Game Play" message to all players
	Game:AddCommand("gr_ss_ssmsettings","XASSM:serverSaySSMsettings();","gr_ss_ssmsettings"); -- sends "Game Play" message to all players
	Game:AddCommand("gr_ss_ssmversion","XASSM:serverSaySSMversion();","gr_ss_ssmversion"); -- sends "SSM Version" message to all players
	Game:AddCommand("gr_ss_nextmap","XASSM:serverSayNextMap();","gr_ss_nextmap"); -- sends "Next Map" message to all players
	Game:AddCommand("gr_ss_welcometo","XASSM:serverSayWelcomeTo();","gr_ss_welcometo"); -- sends "Welcome To Server name" message to all players
	Game:AddCommand("gr_ss_mapchange","XASSM:serverSayMapChange();","gr_ss_mapchange"); -- sends "Map will change when" message to all players
	Game:AddCommand("gr_ss_norockets","XASSM:serverSayNoRockets();","gr_ss_norockets"); -- sends "Weapon Restriction" message to all players
	Game:AddCommand("gr_ss_novehiclerockets","XASSM:serverSayNoVehicleRockets();","gr_ss_novehiclerockets"); -- sends "Weapon Restriction" message to all players
	Game:AddCommand("gr_ss_noAG36nades","XASSM:serverSayNoAG36nades();","gr_ss_noAG36nades"); -- sends "Weapon Restriction" message to all players
	Game:AddCommand("gr_ss_noOICWnades","XASSM:serverSayNoOICWnades();","gr_ss_noOICWnades"); -- sends "Weapon Restriction" message to all players
	Game:AddCommand("gr_ss_nosnipers","XASSM:serverSayNoSniperRifle();","gr_ss_nosnipers"); -- sends "Weapon Restriction" message to all players
	Game:AddCommand("gr_ss_headshotdamage","XASSM:serverSayHeadshotDamage();","gr_ss_headshotdamage"); -- sends "Headshot Damage" message to all players
	--Verysoft vars
	Game:CreateVariable("bot_quota",0);
	Game:CreateVariable("bot_difficulty",2);
	Game:CreateVariable("bot_always",0);
	Game:CreateVariable("bot_tag","FCR");
	Game:CreateVariable("bot_show",0);
	Game:CreateVariable("bot_spec",0);
	Game:CreateVariable("gr_allow_free_spectator",1);
	Game:CreateVariable("gr_flag_capturemessage_num",3);
	Game:CreateVariable("gr_map_finish_delay",6);
	Game:CreateVariable("gr_teamsign",1);
	Game:CreateVariable("gr_ssm_sid", "$3Far Cry 1.4");
        Game:CreateVariable("gr_inactivity_time",3);
	--XASSM Server-Defined variables (placeholder variables, do not change use server profile instead!)
	Game:CreateVariable("gr_forcerespawn",0);
	Game:CreateVariable("gr_moreskins",0);
	Game:CreateVariable("gr_autotune",0);
	Game:CreateVariable("gr_scoreboard_p",0);
	Game:CreateVariable("gr_altTeamColors",0);
	Game:CreateVariable("gr_extend_assault_classes",0);
	Game:CreateVariable("gr_team_balance",0);
	Game:CreateVariable("gr_spectator_vote",1);
	Game:CreateVariable("gr_vote_repeat",10);
	Game:CreateVariable("gr_tc1","$o"); --off-white (default)
	Game:CreateVariable("gr_tc2","$1"); --white (highlite)
	Game:CreateVariable("gr_tc3","$6"); --yellow (emphasize)
	Game:CreateVariable("gr_admin_id", "$1[$0Elite_$33top$1]");
	Game:CreateVariable("gr_server_id", "$o[$0server $11.4$o]");
	Game:CreateVariable("gr_admin_tag", "");
	Game:CreateVariable("gr_server_tag", "");
	Game:CreateVariable("gr_stats_export",0); --1.4
	Game:CreateVariable("gr_stats_file","profiles/server/stats.log");
	Game:CreateVariable("gr_stats_console",0); --Do not change this! (internal)
	Game:CreateVariable("gr_stats_finish",0); --Do not change this! (internal)
	Game:CreateVariable("gr_kills_export",0);
	Game:CreateVariable("gr_kills_file","profiles/server/kills.log");
	Game:CreateVariable("gr_chat_export",0);
	Game:CreateVariable("gr_chat_file","profiles/server/chat.log");
	Game:CreateVariable("gr_vslog_stamp",8);
	Game:CreateVariable("gr_vslog_export",2);
	Game:CreateVariable("gr_vslog_file","vslog.log");
	Game:CreateVariable("gr_speedlimit",0);
	setglobal("gr_mapcycle_ffa", "profiles/server/mapcycle_FFA.txt");
	setglobal("gr_mapcycle_tdm", "profiles/server/mapcycle_TDM.txt");
	setglobal("gr_mapcycle_assault", "profiles/server/mapcycle_ASSAULT.txt");
	Game:CreateVariable("gr_server_clock", 0); -- internal clock, adds up round times for reboot timer (do not alter)
	Game:CreateVariable("gr_server_reboot", 0);	-- enable/disable the shutdown/reboot routine
	Game:CreateVariable("gr_server_reboot_time", 72); -- time in hours until the server will shutdown and reboot
end
--
function XASSM:sayHi()
	if tostring(getglobal("gr_server_id")) == "" then setglobal("gr_server_tag","") else setglobal("gr_server_tag", tostring(getglobal("gr_server_id")).." ") end
	if tostring(getglobal("gr_admin_id")) == "" then setglobal("gr_admin_tag","") else setglobal("gr_admin_tag", tostring(getglobal("gr_admin_id")).." ") end
	if (toNumberOrZero(getglobal("gr_vslog_export"))>0) then
		System:LogAlways(self:vs_q_b3(9));
		XASSM:Logger("Server-side mod in use? ["..toNumberOrZero(ssm(1)).."] Gathering extended multiplayer settings from location '/profiles/server'...",1);
		XASSM:Logger(tostring(getglobal("gr_ssm_lid")).." "..tostring(getglobal("gr_ssm_version")).." ("..tostring(getglobal("gr_ssm_url"))..")",1);
		XASSM:Logger("Server Version ["..Gamestyler.native_version.."]",1);
		if toNumberOrZero(getglobal("gr_DedicatedServer")==1) and (not UI) then
			XASSM:Logger("dedicated server detected? ["..toNumberOrZero(getglobal("gr_DedicatedServer")).."] dedicatedmaxrate: ["..toNumberOrZero(getglobal("sv_DedicatedMaxRate")).."]",1); 
			if (toNumberOrZero(getglobal("sv_dll_netsynchro"))>0) then
				XASSM:Logger("dll netsynchro support activated, send rate? ["..toNumberOrZero(getglobal("sv_dll_cvar_freq")).."]",1);
			else
				XASSM:Logger("dll netsynchro support inactive",1);
			end		
			if (toNumberOrZero(getglobal("sv_dll_badcvar"))>0) then
				XASSM:Logger("dll badcvar support activated, send rate? ["..toNumberOrZero(getglobal("sv_dll_cvar_freq")).."]",1);
			else
				XASSM:Logger("dll badcvar support inactive",1);
			end
			if (toNumberOrZero(getglobal("sv_dll_admin"))>0) then
				XASSM:Logger("dll admin auto-login support activated (Admins.txt)",1);
			else
				XASSM:Logger("dll admin auto-login support inactive",1);
			end
			if (toNumberOrZero(getglobal("sv_dll_globalid"))>0) then
				XASSM:Logger("dll globalid log support activated, print colors? ["..toNumberOrZero(getglobal("sv_dll_globalid_color")).."] print logWinSV? ["..toNumberOrZero(getglobal("sv_dll_bbb")).."]",1);
			else
				XASSM:Logger("dll globalid log support inactive",1);
			end
			if (toNumberOrZero(getglobal("sv_dll_badname"))>0) then
				XASSM:Logger("dll badname filter support activated (BadNames.txt)",1);
			else
				XASSM:Logger("dll badname filter support inactive",1);
			end		
		else
			XASSM:Logger("in-game (GUI) server host detected",1); 
		end
		XASSM:Logger("extended server-event log activated (logWinSV.txt)",1);
		if (toNumberOrZero(getglobal("bot_enable"))>0) then
			XASSM:Logger("verysoft bots enabled",1);
		else
			XASSM:Logger("verysoft bots disabled",1);
		end
		if (Gamestyler) and Gamestyler.printNativeVersion then
			XASSM:Logger("current pure-patch setting ["..Gamestyler:printNativeVersion().."]",1);
		end			
		if (getglobal("gr_ssm_gamestyle")) and (Gamestyler) then
			XASSM:Logger("gameplay style selected ["..Gamestyler:sayHi(getglobal("gr_ssm_gamestyle")).."]",1);
		elseif (getglobal("gr_ssm_gamestyle"))  then
			XASSM:Logger("gameplay style selected ["..tonumber(getglobal("gr_ssm_gamestyle")).."]",1);
		else
			XASSM:Logger("no gameplay style selected",1);
		end
		if (getglobal("gr_ssm_weaponstyle")) and (Gamestyler) then
			XASSM:Logger("weapon style selected ["..Gamestyler:sayHi(nil,getglobal("gr_ssm_weaponstyle")).."]",1);
		elseif (getglobal("gr_ssm_weaponstyle"))  then
			XASSM:Logger("weapon style selected ["..tonumber(getglobal("gr_ssm_weaponstyle")).."]",1);
		else
			XASSM:Logger("no weapon style selected",1);
		end
	else
		System:LogAlways("ssm is turned off or extended logging support inactive, bye bye");
	end
	if (UI) then
		Game:CreateVariable("sv_dll_admin",0);
		Game:CreateVariable("sv_dll_badname",0);
		Game:CreateVariable("sv_dll_netsynchro",0);
		Game:CreateVariable("sv_dll_badcvar",0);
		Game:CreateVariable("sv_dll_cvar_freq",0);
		Game:CreateVariable("sv_dll_globalid",0);
		Game:CreateVariable("sv_dll_globalid_color",0);
		System:LogAlways("In-Game server host detected disabling custom crygame dependencies");
	end
	if (Gamestyler) then Gamestyler:record_kits(1); end
	setglobal("gr_checkfirststart",1);
end
--
function XASSM:autoTune(ents)
	if (self.ssm_rate == nil) then 
		if (UI) then self.ssm_rate = tonumber(getglobal("sv_maxupdaterate")); else self.ssm_rate = tonumber(getglobal("sv_DedicatedMaxRate"))*0.8; end 
	end
	if (toNumberOrZero(ents)==0) then
		local SlotMap = Server:GetServerSlotMap();
		local j = 0;
		for i, Slot in SlotMap do
			j = j + 1;
		end
		ents = j;
	end
	ents = tonumber(ents); --!important
	local ratemod = self.ssm_rate*(ents/tonumber(getglobal("sv_maxplayers"))*0.5);
	if ratemod>=120 then
		ratemod = 120;
		if (UI) then
			setglobal("cl_cmdrate",floor(ratemod*0.67));
			setglobal("cl_updaterate",floor(ratemod*0.5));
			--setglobal("cl_maxrate",floor(ratemod*600));
		else
			setglobal("sv_DedicatedMaxRate",floor(ratemod*0.375));
			GameRules:UpdateTimeLimit("nil",floor(ratemod*0.67),floor(ratemod*0.5));
		end
		setglobal("sv_maxcmdrate",floor(ratemod*0.67));
		setglobal("sv_maxupdaterate",floor(ratemod*0.5));
		--setglobal("sv_maxrate",floor(ratemod*600));
	elseif ratemod>=90 then
		ratemod = 100;
		if (UI) then
			setglobal("cl_cmdrate",floor(ratemod));
			setglobal("cl_updaterate",floor(ratemod*0.7));
			--setglobal("cl_maxrate",floor(ratemod*550));
		else
			setglobal("sv_DedicatedMaxRate",floor(ratemod*0.6));
			GameRules:UpdateTimeLimit("nil",floor(ratemod),floor(ratemod*0.7));
		end
		setglobal("sv_maxcmdrate",floor(ratemod));
		setglobal("sv_maxupdaterate",floor(ratemod*0.7));
		--setglobal("sv_maxrate",floor(ratemod*550));
	elseif ratemod>60 then
		ratemod = 75;
		if (UI) then
			setglobal("cl_cmdrate",floor(ratemod*1.4));
			setglobal("cl_updaterate",floor(ratemod*0.8));
			--setglobal("cl_maxrate",floor(ratemod*525));
		else
			setglobal("sv_DedicatedMaxRate",floor(ratemod));
			GameRules:UpdateTimeLimit("nil",floor(ratemod*1.4),floor(ratemod*0.8));
		end
		setglobal("sv_maxcmdrate",floor(ratemod*1.4));
		setglobal("sv_maxupdaterate",floor(ratemod*0.8));
		--setglobal("sv_maxrate",floor(ratemod*525));
	else
		ratemod=60;
		if (UI) then
			setglobal("cl_cmdrate",floor(ratemod*2));
			setglobal("cl_updaterate",floor(ratemod));
			--setglobal("cl_maxrate",floor(ratemod*500));
		else
			setglobal("sv_DedicatedMaxRate",floor(ratemod*1.6));
			GameRules:UpdateTimeLimit("nil",floor(ratemod*2),floor(ratemod));
		end
		setglobal("sv_maxcmdrate",floor(ratemod*2));
		setglobal("sv_maxupdaterate",floor(ratemod));
		--setglobal("sv_maxrate",floor(ratemod*500));
	end
	if (not UI) then
		XASSM:Logger("Rates: cmdrate/maxcmdrate ["..toNumberOrZero(getglobal("sv_maxcmdrate")).."] updaterate/maxupdaterate ["..toNumberOrZero(getglobal("sv_maxupdaterate")).."]");
	else
		XASSM:Logger("Rates: dedmaxrate ["..toNumberOrZero(getglobal("sv_DedicatedMaxRate")).."] maxcmdrate ["..toNumberOrZero(getglobal("sv_maxcmdrate")).."] maxupdaterate ["..toNumberOrZero(getglobal("sv_maxupdaterate")).."]");
	end
end
--
function XASSM:vs_q_b3(opt,short,long)
	local mess = " ";
	if (not opt) then opt = getglobal("gr_vslog_stamp"); end
	if (not short) then short=date("%H:%M:%S"); end
	if (not long) then long=date("%d.%m.%Y"); end
	opt=toNumberOrZero(opt);
	if     (opt==3) then mess=tostring(" [verysoft "..short.."] ");
	elseif (opt==4) then mess=tostring(" [verysoft "..long.."-"..short.."] ");
	elseif (opt==5) then mess=tostring(" [b3] ");
	elseif (opt==6) then mess=tostring(" [b3] ["..short.."] ");
	elseif (opt==7) then mess=tostring(" [b3] ["..long.."|"..short.."] ");
	elseif (opt==8) then mess=tostring(" ["..tostring(getglobal("gr_ssm_sid")).." "..short.."] ");
	elseif (opt==9) then mess=tostring(" ["..tostring(getglobal("gr_ssm_sid")).." "..long.." "..short.."] ");
	elseif (opt==10) then mess=tostring(" ["..short.."] ");
	elseif (opt==11) then mess=tostring(" ["..long.." "..short.."] ");
	elseif (opt==12) then mess=tostring(" ["..tostring(getglobal("gr_server_id")).." "..long.." "..short.."] ");
	elseif (opt==1) then mess=tostring(" "..short.." ");
	elseif (opt==2) then mess=tostring(" "..long.." "..short.." ");
	elseif strlen(getglobal("gr_vslog_stamp"))>0 and strlower(getglobal("gr_vslog_stamp"))~="nil" and tostring(getglobal("gr_vslog_stamp"))~="" then mess=tostring(getglobal("gr_vslog_stamp"));
	end
	return mess;
end
--
function XASSM:Logger(pf,wsv)
	if strfind(pf,"%$") then
		local iEqual;
		local pfx;
		local pfz;
		while strfind(pf,"%$") do --$ is a magic character so you need to protect it
			iEqual = strfind(pf,"%$");--$ is a magic character so you need to protect it
			if (iEqual) then
				pfx = strsub(pf,1,iEqual-1); --strsub works this way: strsub(string, start pos, end pos)
				pfz = strsub(pf,iEqual+2,strlen(pf)); --strsub works this way: strsub(string, start pos, end pos)
			end
			if (pfx) and (pfz) then
				pf = pfx..pfz;
			end
		end
	end
	if (toNumberOrZero(getglobal("gr_vslog_export"))>0) then
		if (toNumberOrZero(getglobal("gr_vslog_export"))<=2) then
			XASSM:WriteVSLog(self:vs_q_b3()..pf); --print in "gr_vslog_file"
			if (wsv) then System:LogAlways(self:vs_q_b3()..pf); end
		else
			System:LogAlways(self:vs_q_b3()..pf); --print in LogWinSV
		end
	end 
end
--
function XASSM:WriteVSLog(pf)
	local VSLogName = "profiles/server/"..tostring(getglobal("gr_vslog_file"));
	if (toNumberOrZero(getglobal("gr_vslog_export"))>1) then VSLogName = "profiles/server/"..date("%y").."-"..date("%m").."-"..date("%d").."_"..tostring(getglobal("gr_vslog_file")); end
	local VSLog = openfile(VSLogName, "a");
	if (VSLog) then
		write(VSLog,pf.."\n");
		closefile(VSLog);
	else
		System:LogAlways("Error: VerySoft Log does not exist at location "..tostring(getglobal("gr_vslog_file")));
	end
end
--
function XASSM:RestartMap()
	--if (SVplayerTrack) then
		--SVplayerTrack:Init(); --redundant
		if toNumberOrZero(getglobal("gr_keep_lock"))==0 then
			SVcommands:SVunlockall();
		end
		if(MapCycle.MapList[MapCycle.iNextMap])then MapCycle.iNextMap = MapCycle.iNextMap-1; end
		local szName = getglobal("g_LevelName");
		local szGameType = getglobal("g_GameType");
		local szTimeLimit = getglobal("gr_TimeLimit");
		local szScoreLimit = getglobal("gr_ScoreLimit");
		local szGamestyle = getglobal("gr_ssm_gamestyle");
		local szWeaponstyle = getglobal("gr_ssm_weaponstyle");
		local szRespawnTime = getglobal("gr_RespawnTime");
		local szInvulnerabilityTimer = getglobal("gr_InvulnerabilityTimer");
		local szMaxPlayers = getglobal("sv_maxplayers");
		local szMinTeamLimit = getglobal("gr_MinTeamLimit");
		local szMaxTeamLimit = getglobal("gr_MaxTeamLimit");
		GameRules:ChangeMap(szName, szGameType, szTimeLimit, szScoreLimit, szGamestyle, szWeaponstyle, szRespawnTime, szInvulnerabilityTimer, szMaxPlayers, szMinTeamLimit, szMaxTeamLimit);
		--System:Log("XASSM.RestartMap: Request "..szName.." GAMETYPE("..tostring(szGameType)..")".." TIMELIMIT("..tostring(szTimeLimit)..")".." SCORELIMIT("..tostring(szScoreLimit)..")".." RESPAWNTIMER("..tostring(szRespawnTime)..")".." INVULNERABLETIMER("..tostring(szInvulnerabilityTimer)..")".." MAXPLAYERS("..tostring(szMaxPlayers)..")".." MINTEAM("..tostring(szMinTeamLimit)..")".." MAXTEAM("..tostring(szMaxTeamLimit)..")");  --debug
		local pf = "MapRestart: "..szName.." ("..tostring(szGameType)..") TimeLimit:"..tostring(szTimeLimit).." ScoreLimit:"..tostring(szScoreLimit).." RespawnTimer:"..tostring(szRespawnTime).." InvulnerabilityTimer:"..tostring(szInvulnerabilityTimer).." MaxPlayers:"..tostring(szMaxPlayers).." MinTeamLimi:"..tostring(szMinTeamLimit).." MaxTeamLimit: "..tostring(szMaxTeamLimit)..")";
		XASSM:Logger(pf);
	--end
end
--
function XASSM:autoBalance()
	if (GameRules) and GameRules.bIsTeamBased then
		local tnow = _time;
		if (not self.start_time) then self.start_time = tnow; end
		if (tnow-self.start_time) > 30 then
			local iTeam01Count = GameRules:GetTeamMemberCountRL("red");
			local iTeam02Count = GameRules:GetTeamMemberCountRL("blue");
			local stack_team;
			local free_team;
			if iTeam01Count + iTeam02Count < 2 then return end
			if GameRules.attackerTeam then
				if GameRules.attackerTeam == "red" then 
					iTeam01Count = iTeam01Count + 1; 
				else  
					iTeam02Count = iTeam02Count + 1; 
				end
			end
			if iTeam01Count > (iTeam02Count+1) then
				stack_team = "red";
				free_team = "blue";
			elseif iTeam02Count > (iTeam01Count+1) then
				stack_team = "blue";
				free_team = "red";
			end
			if (stack_team) then
				local mySlots = Server:GetServerSlotMap();
				local nslots = 0;
				local cslot;
				local team;
				for i,ServerSlot in mySlots do
					nslots = nslots + 1;
				end
				while tonumber(nslots) > 0 do
					cslot = Server:GetServerSlotBySSId(random(1,nslots));
					if (cslot) then
						team =  Game:GetEntityTeam(cslot:GetPlayerId());
						if (team) and (team == stack_team) then 
							SVcommands:movePlayerToTeam(tostring(cslot:GetId()).." "..free_team.." 0 0 Auto-Balance");
							nslots = 0;
						end
					end
				end
			end
		end
	end
end
--
function XASSM:rebootTimer(now,doclk)
	local ttime;
	if (now) then self.reboot = now; end
	if (doclk) then --on mapchange event, store clock time
		if (self.sum_time) then 
			setglobal("gr_server_clock",toNumberOrZero(getglobal("gr_server_clock"))+self.sum_time);
			ttime = getglobal("gr_server_clock");
			local thours=floor(ttime/(60*60));
			local tminutes=floor(ttime/(60))-tonumber(thours)*60;
			local tseconds=floor(ttime)-tonumber(thours)*60*60-tonumber(tminutes)*60;
			XASSM:Logger("Uptime: "..thours..":"..tminutes..":"..tseconds.." Sustained? ["..getglobal("gr_server_reboot").."] NextReboot: "..floor(toNumberOrZero(getglobal("gr_server_reboot_time"))-thours).."hrs");
			return
		end
	end
	if (self.reboot) then
		if (self.reboot < 3) then 
			local sid = tostring(getglobal("gr_server_tag"));
			local tc1 = tostring(getglobal("gr_tc1"));
			local tc2 = tostring(getglobal("gr_tc2"));
			local tc3 = tostring(getglobal("gr_tc3"));
			Server:BroadcastText(sid..tc3.."<<<"..tc2.." This server will"..tc1.." REBOOT"..tc2.." in a few seconds!"..tc3.." >>>",3);
			Server:BroadcastText(sid..tc3.."<<<"..tc2.." This server will"..tc1.." REBOOT"..tc2.." in a few seconds!"..tc3.." >>>",3);
			Server:BroadcastText(sid..tc3.."<<<"..tc2.." This server will"..tc1.." REBOOT"..tc2.." in a few seconds!"..tc3.." >>>",3);
		else
			SVcommands:PlaceRestartFile();  -- do the reboot after delay and server message (friendlier)
			return
		end
	end
	local tnow = _time;
	if (not self.start_time) then
		self.start_time = tnow;
		self.sum_time = 0;
		self.reboot = nil;
	else
		self.sum_time = toNumberOrZero(tnow-self.start_time);
	end
	ttime = getglobal("gr_server_clock")+self.sum_time;
	if (toNumberOrZero(getglobal("gr_server_reboot"))>0) and floor(ttime/(60*60))>=toNumberOrZero(getglobal("gr_server_reboot_time")) then
		self.reboot = toNumberOrZero(self.reboot) + 1;
	end
end
--
function XASSM:deadAFKcheck() 
	local toke2 = tonumber(getglobal("gr_inactivity_time"));
	local slots = Server:GetServerSlotMap();
	for i, slot in slots do
		local ent=System:GetEntity(slot:GetPlayerId());
		if (ent and ent.type=="Player") then
			if (ent.death_time) then
				if (toke2) and (ent.death_time+(toke2*60) <= _time) then --inactive player, move to spectators
					SVcommands:movePlayerToTeam(tostring(slot:GetId()).." spectators 0 0 Afk too long");  --force to spectators
				end
			end
		end
	end
end
--jeppa
function XASSM:round(num, idp)
	local mult = 10^(idp or 0);
	return floor(num*mult+0.5)/mult;
end
--
function XASSM:serverSaySSMversion()
	local tc1 = tostring(getglobal("gr_tc1"));
	local tc2 = tostring(getglobal("gr_tc2"));
	local tc3 = tostring(getglobal("gr_tc3"));
	Server:BroadcastText(sid..tc1.."Server-Side Mod in use "..tc2..tostring(getglobal("gr_ssm_sid")).." "..tc3..tostring(getglobal("gr_ssm_version"))..tc1.." ("..tc3..tostring(getglobal("gr_ssm_url"))..tc1..")",3);
end
--
function XASSM:serverSayNowPlaying()
	local sid = tostring(getglobal("gr_server_tag"));
	local tc1 = tostring(getglobal("gr_tc1"));
	local tc2 = tostring(getglobal("gr_tc2"));
	local tc3 = tostring(getglobal("gr_tc3"));
	Server:BroadcastText(sid..tc1.."Now Playing: "..tc3..tostring(getglobal("g_LevelName"))..tc1.." ("..tc3..tostring(getglobal("g_GameType"))..tc1..") Timelimit: "..tc2..XASSM:round(getglobal("gr_TimeLimit"))..tc1.." Scorelimit: "..tc2..XASSM:round(getglobal("gr_ScoreLimit"))..tc1.." Gamestyle: "..tc2..Gamestyler:sayHi(getglobal("gr_ssm_gamestyle"),nil,1)..tc1.." Weaponstyle: "..tc2..Gamestyler:sayHi(nil,getglobal("gr_ssm_weaponstyle"),1),3);
end
--
function XASSM:serverSaySSMsettings()
	local sid = tostring(getglobal("gr_server_tag"));
	local tc1 = tostring(getglobal("gr_tc1"));
	local tc2 = tostring(getglobal("gr_tc2"));
	local tc3 = tostring(getglobal("gr_tc3"));
	Server:BroadcastText(sid..tc1.."Patch: "..tc2..Gamestyler:printNativeVersion()..tc1.." Gamestyle: "..tc2..Gamestyler:sayHi(getglobal("gr_ssm_gamestyle"),nil,1)..tc1.." Weaponstyle: "..tc2..Gamestyler:sayHi(nil,getglobal("gr_ssm_weaponstyle"),1),3);
end
--
function XASSM:serverSayWelcomeTo()
	local sid = tostring(getglobal("gr_server_tag"));
	local tc1 = tostring(getglobal("gr_tc1"));
	local tc2 = tostring(getglobal("gr_tc2"));
	Server:BroadcastText(sid..tc1.."Welcome to the "..tc2..tostring(getglobal("sv_name"))..tc1.." server",3);
end
--
function XASSM:serverSayMapChange()
	local sid = tostring(getglobal("gr_server_tag"));
	local tc1 = tostring(getglobal("gr_tc1"));
	local tc2 = tostring(getglobal("gr_tc2"));
	local tc3 = tostring(getglobal("gr_tc3"));
	local toke = "Team";
	local toka = "Points";
	if (g_GameType~="ASSAULT") then
		if (g_GameType=="FFA") then
			toke = "Player"; 
			toka = "Kills"; 
		end
		if (toNumberOrZero(getglobal("gr_ScoreLimit"))>0) and (toNumberOrZero(getglobal("gr_TimeLimit"))>0) then
			Server:BroadcastText(sid..tc1.."Map will change when a "..tc2..tostring(toke)..tc1.." reaches "..tc3..tonumber(getglobal("gr_ScoreLimit")).." "..tc2..tostring(toka)..tc1.." or when time runs out",3);
		elseif (tonumber(getglobal("gr_ScoreLimit"))>0) then
			Server:BroadcastText(sid..tc1.."Map will change when a "..tc2..tostring(toke)..tc1.." reaches "..tc3..tonumber(getglobal("gr_ScoreLimit")).." "..tc2..tostring(toka),3);
		elseif (tonumber(getglobal("gr_TimeLimit"))>0) then
			Server:BroadcastText(sid..tc1.."Map will change when time runs out",3);
		else
			Server:BroadcastText(sid..tc1.."There is no"..tc2.." Time"..tc1.."/"..tc2.."Score"..tc1.." limit",3);
		end
	end
end
--
function XASSM:serverSayNextMap()
	local sid = tostring(getglobal("gr_server_tag"));
	local tc1 = tostring(getglobal("gr_tc1"));
	local tc2 = tostring(getglobal("gr_tc2"));
	local tc3 = tostring(getglobal("gr_tc3"));
	local m = MapCycle.MapList[MapCycle.iNextMap];
	if (m) and (Gamestyler) then 
		Server:BroadcastText(sid..tc2.."Next Map: "..tc3..m.szName..tc2.." ("..tc3..tostring(m.szGameType)..tc2..") Timelimit: "..tc3..XASSM:round(m.szTimeLimit)..tc2.." Scorelimit: "..tc3..XASSM:round(m.szScoreLimit)..tc2.." Gamestyle: "..tc3..Gamestyler:sayHi(m.szGamestyle,nil,1)..tc2.." Weaponstyle: "..tc3..Gamestyler:sayHi(nil,m.szWeaponstyle,1),3);
	else
		Server:BroadcastText(sid..tc2.."Next Map: "..tc3..tostring(getglobal("gr_NextMap")),3);
	end
end
--
function XASSM:serverSayHeadshotDamage()
	local sid = tostring(getglobal("gr_server_tag"));
	local tc1 = tostring(getglobal("gr_tc1"));
	local tc2 = tostring(getglobal("gr_tc2"));
	local tc3 = tostring(getglobal("gr_tc3"));
	if toNumberOrZero(getglobal("gr_realistic_headshot"))>0 or toNumberOrZero(getglobal("gr_ssm_weaponstyle"))==1 then 
		Server:BroadcastText(sid..tc2.."Realistic Headshot"..tc1.." is "..tc3.."Enabled",3);
	else
		local def = "";
		if toNumberOrZero(getglobal("gr_HeadshotMultiplier"))==2 then def = tc1.." ("..tc2.."default"..tc1..")"; end
		Server:BroadcastText(sid..tc2.."Headshot"..tc1.." damage is set at "..tc3..XASSM:round(getglobal("gr_HeadshotMultiplier")*100,1).."%"..def,3);
	end
end
--
function XASSM:serverSayNoRockets()
	local sid = tostring(getglobal("gr_server_tag"));
	local tc1 = tostring(getglobal("gr_tc1"));
	local tc2 = tostring(getglobal("gr_tc2"));
	local tc3 = tostring(getglobal("gr_tc3"));
	if (toNumberOrZero(getglobal("gr_norl"))>0) then
		Server:BroadcastText(sid..tc2.."Rocket Launchers"..tc1.." are"..tc3.." Disabled",3);
	else
		Server:BroadcastText(sid..tc2.."Rocket"..tc1.." damage is set at "..tc3..XASSM:round(getglobal("gr_rocket_damage_factor")*100,1).."%"..tc1.." of default",3);
	end
end
--
function XASSM:serverSayNoVehicleRockets()
	local sid = tostring(getglobal("gr_server_tag"));
	local tc1 = tostring(getglobal("gr_tc1"));
	local tc2 = tostring(getglobal("gr_tc2"));
	local tc3 = tostring(getglobal("gr_tc3"));
	if (toNumberOrZero(getglobal("gr_novr"))>0) then
		Server:BroadcastText(sid..tc2.."Vehicle Rockets"..tc1.." are"..tc3.." Disabled",3);
	else
		Server:BroadcastText(sid..tc2.."Vehicle Rocket"..tc1.." damage is set at "..tc3..XASSM:round(getglobal("gr_vehicleRocketDamage")*100,1).."%"..tc1.." of default",3);
	end
end
--
function XASSM:serverSayNoAG36nades()
	local sid = tostring(getglobal("gr_server_tag"));
	local tc1 = tostring(getglobal("gr_tc1"));
	local tc2 = tostring(getglobal("gr_tc2"));
	local tc3 = tostring(getglobal("gr_tc3"));
	if (toNumberOrZero(getglobal("gr_nogl"))>0) then
		Server:BroadcastText(sid..tc2.."AG36 Grenade Launchers"..tc1.." are"..tc3.." Disabled",3);
	else
		Server:BroadcastText(sid..tc2.."AG36 Grenade"..tc1.." damage is set at "..tc3..XASSM:round(getglobal("gr_ag36_nade_damage_factor")*100,1).."%"..tc1.." of default",3);
	end
end
--
function XASSM:serverSayNoOICWnades()
	local sid = tostring(getglobal("gr_server_tag"));
	local tc1 = tostring(getglobal("gr_tc1"));
	local tc2 = tostring(getglobal("gr_tc2"));
	local tc3 = tostring(getglobal("gr_tc3"));
	if (toNumberOrZero(getglobal("gr_nogl"))>0) then
		Server:BroadcastText(sid..tc2.."OICW Grenade Launchers"..tc1.." are"..tc3.." Disabled",3);
	else
		Server:BroadcastText(sid..tc2.."OICW Grenade"..tc1.." damage is set at "..tc3..XASSM:round(getglobal("gr_oicw_nade_damage_factor")*100,1).."%"..tc1.." of default",3);
	end
end
--
function XASSM:serverSayNoSniperRifle()
	local sid = tostring(getglobal("gr_server_tag"));
	local tc1 = tostring(getglobal("gr_tc1"));
	local tc2 = tostring(getglobal("gr_tc2"));
	local tc3 = tostring(getglobal("gr_tc3"));
	if (toNumberOrZero(getglobal("gr_nosr"))>0) then
		Server:BroadcastText(sid..tc2.."Sniper Rifles"..tc1.." are"..tc3.." Disabled",3);
	else
		Server:BroadcastText(sid..tc2.."Sniper Rifle"..tc1.." damage is set at "..tc3..XASSM:round(getglobal("gr_sniper_damage_factor")*100,1).."%"..tc1.." of default",3);
	end
end