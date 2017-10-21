move_params-- Improved by Mixer 1.21
Script:LoadScript("scripts/Default/ClientStuff.lua");
Script:LoadScript("SCRIPTS/MULTIPLAYER/MultiplayerClassDefiniton.lua");
ClientStuff.idScoreboard=nil;

function ClientStuff:OnSpawnEntity(entity)
	entity:EnableUpdate(1);
	
	if (entity.type == "Player") then
		entity:SetViewDistRatio(255);
		entity:RenderShadow(1);
		BasicPlayer.SecondShader_TeamColoring(entity);
		Hud:ResetRadar(entity);
	end

	if (entity.type == "Synched2DTable") then
		ClientStuff.idScoreboard=entity.id;
	end
end

function ClientStuff:SetPlayerScore(Stream)
	local iClientID = Stream:ReadByte();
	local iPing = Stream:ReadShort();
	local SBEntityEnt = System:GetEntity(ClientStuff.idScoreboard);
	if SBEntityEnt and SBEntityEnt.PingTable then
		SBEntityEnt.PingTable[iClientID]=iPing;
	end
end

function ClientStuff:ShowScoreBoard(bShow)
	if (ScoreBoardManager) then
		ScoreBoardManager.SetVisible(bShow);
	end
end

function ClientStuff:ResetScores()
end

function ClientStuff:SayToNPC(p_ent,saytable)
	if (saytable.soundFileFem) and (p_ent.hastits) then
		saytable.saynow = saytable.soundFileFem.."";
	else
		saytable.saynow = saytable.soundFile.."";
		if p_ent.hastits then
			saytable.pitchup = 1;
		else
			saytable.pitchup = nil;
		end
	end
	if (_localplayer) and (p_ent == _localplayer) then
		------------BasicPlayer.PlayInteractSound(_localplayer,saytable.saynow);
		if p_ent.chatsnd and Sound:IsPlaying(p_ent.chatsnd) then
			Sound:StopSound(p_ent.chatsnd);
		end
		p_ent.chatsndd = Sound:LoadSound(saytable.saynow);
		if (p_ent.chatsndd) then
			Sound:PlaySound(p_ent.chatsndd);
			if saytable.pitchup then
				Sound:SetSoundFrequency(p_ent.chatsndd,1400);
			end
		end
		if (saytable.txt) then
			Hud:AddMessage(p_ent:GetName()..": $1 "..saytable.txt);
		end
	else
		local pentteam = Game:GetEntityTeam(p_ent.id);
		if (pentteam) and (pentteam == Game:GetEntityTeam(_localplayer.id)) and (saytable.txt) and (Hud.chess_lefthud==nil) then
			local acw_radio=Sound:LoadSound("Sounds/items/MP_squelch.wav");
			if (acw_radio) then
				Sound:PlaySound(acw_radio);
			end
			--------BasicPlayer.PlayInteractSound(_localplayer,saytable.saynow);
			if p_ent.chatsnd and Sound:IsPlaying(p_ent.chatsnd) then
				Sound:StopSound(p_ent.chatsnd);
			end
			p_ent.chatsndd = Sound:LoadSound(saytable.saynow);
			if (p_ent.chatsndd) then
				Sound:PlaySound(p_ent.chatsndd);
				if saytable.pitchup then
					Sound:SetSoundFrequency(p_ent.chatsndd,1400);
				end
			end

			Hud.cis_mp_talker = {
				pos = new(p_ent:GetPos()),
				p_id = p_ent.id * 1,
				tme = _time + 3,
			};
			Hud:AddMessage(p_ent:GetName()..": $1 "..saytable.txt);
			if (not p_ent.cnt.proning) and (not p_ent.theVehicle) then
				p_ent:StartAnimation(0,"radiocall2",4);
				p_ent.stop_my_talk = _time + 2.5;
			end
			return;
		elseif (Hud.chess_lefthud) and (saytable.txt) then
			Hud:AddMessage(p_ent:GetName()..": $1 "..saytable.txt);
			if (not p_ent.cnt.proning) and (not p_ent.theVehicle) then
				local rnum = random(1,3);
				p_ent:StartAnimation(0,"_talk0"..rnum,4);
				p_ent.stop_my_talk = _time + 1;
			end
		end
		local p_entpos = new(p_ent:GetPos());
		p_entpos.z = p_entpos.z + 1.64;
		local p_entsnd = Sound:Load3DSound(saytable.saynow,0,saytable.Volume,saytable.min,saytable.max);
		if (p_entsnd) then
			Sound:SetSoundPosition(p_entsnd,p_entpos);
			Sound:PlaySound(p_entsnd);
			if saytable.pitchup then
				Sound:SetSoundFrequency(p_entsnd,1400);
			end
		end
	end
end

function ClientStuff:CalcEfficiency(score, deaths, suicides)
	if (not score or not deaths or not suicides) then
		return 0;
	end
	if (score <= 0) then
		return 0;
	end
	return floor(max(100 * score / (score + deaths + suicides) + 0.5, 0));
end

-- change player objective
ClientStuff.ServerCommandTable["CPO"]=function(String,toktable)

	local tokcount=count(toktable);

	local newobjective;
		
	if tokcount>=2 then
		newobjective=toktable[2];
	end
		
	Hud.PlayerObjective = newobjective;
	
	if newobjective then
		Hud.PlayerObjectiveAnim = 1;	-- 1 is the pop up
		Hud.PlayerObjectiveAnimStart = _time;
		Hud.PlayerObjectiveCISS = newobjective;
		
		if newobjective == "POAtt" then
			Hud.PlayerObjectiveAnimTex = System:LoadImage("textures/hud/multiplayer/attacker_logo");
		else
			Hud.PlayerObjectiveAnimTex = System:LoadImage("textures/hud/multiplayer/defender_logo");
		end
	else
		Hud.PlayerObjectiveAnim=nil;
	end
end;

-- respawn timer reset
ClientStuff.ServerCommandTable["RTR"]=function(String,toktable)

	if count(toktable)==2 then
		local iRCL = tonumber(toktable[2]);
		
		if (iRCL) then
			Hud.iRespawnCycleLength = iRCL;
			Hud.iRespawnCycleStart = _time;
		end
	else
		Hud.iRespawnCycleLength = nil;
		Hud.iRespawnCycleStart = nil;
	end
end;

-- your class is now <MultiplayerClassDefiniton.PlayerClasses>
-- needed to synchroize the player speed
ClientStuff.ServerCommandTable["YCN"]=function(String,toktable)
	if count(toktable)==3 then
		local idPlayer=toktable[2];
		local classname=toktable[3];
		local myclass=MultiplayerClassDefiniton.PlayerClasses[classname];
		
		if not myclass then				-- e.g. DefaultMultiPlayer
			myclass=MultiplayerClassDefiniton[classname];
		end
		
		if myclass then
			local player=System:GetEntity(idPlayer);
			if player and player.cnt then
				player.move_params = myclass.move_params;
				if (ClientStuff.cl_promode) then
					player.cnt.max_health=200; -- that damn stuff is not netsynched with GameRules, causing client health hud mismatch without this one
				elseif (ClientStuff.cl_survival) then
					if (ClientStuff.cl_survival == 2) then -- coop settings
						player.move_params = {
						speed_run=4,
						speed_walk=1.5,
						speed_swim=2.6,
						speed_crouch=1.5,
						speed_prone=0.6,
						
						speed_run_strafe=4.3,--5.0,
						speed_walk_strafe=1.6,
						speed_swim_strafe=2.55,
						speed_crouch_strafe=1.5,
						speed_prone_strafe=0.6,
						
						speed_run_back=2.9,--5.0,
						speed_walk_back=1.8,
						speed_swim_back=2.2,
						speed_crouch_back=1.6,
						speed_prone_back=0.6,
						
						jump_force=7.3,
		
		lean_angle=9.0,
		bob_pitch=0.14,
		bob_roll=0.0,
		bob_lenght=3.9,
		bob_weapon=0.014,

						};
						player.cnt:SetMoveParams(player.move_params);
						return;
					end
					player.cnt.max_health=220; -- that damn stuff is not netsynched with GameRules, causing client health hud mismatch without this one
				else
					player.cnt.max_health=myclass.health;						-- is not netsynced
				end
				player.cnt.max_armor=myclass.max_armor;					-- is not netsynced
				player.cnt:SetMoveParams(myclass.move_params);
			else
				System:Error("ServerCommandTable YCN failed - internal network error");
			end
		end
	end
end;

-- receive player count IMPROVED/OPTIMISED BY MIXER
ClientStuff.ServerCommandTable["RPC"] = function(String,TokTable)

	if not Hud then
		return;
	end
	
	local allents = System:GetEntities();
	local team1_cnt = 0;
	local team2_cnt = 0;
	for i, pl in allents do
		if pl.type=="Player" then
			local tm =  Game:GetEntityTeam(pl.id);
			if (tm) then
				if tm == "red" then
					team1_cnt = team1_cnt + 1;
				elseif tm == "blue" then
					team2_cnt = team2_cnt + 1;
				elseif tm == "players" then
					team1_cnt = team1_cnt + 1;
				end
			end
		end
	end

	Hud.iTeam01Count = team1_cnt;
	Hud.iTeam02Count = team2_cnt;
	Hud.iTeamSpecCount = tonumber(TokTable[2+4+4]);
	
	Hud.Team01ClassCount = {};
	Hud.Team02ClassCount = {};

	local iClassIndex = 1;
	for iClassIndex=1, 3 do
		Hud.Team01ClassCount[iClassIndex] = tonumber(TokTable[2 + iClassIndex]);
	end
	for iClassIndex=1, 3 do
		Hud.Team02ClassCount[iClassIndex] = tonumber(TokTable[2 + 4 + iClassIndex]);
	end

	Hud.bReceivedPlayerCount = 1;
end

ClientStuff.ServerCommandTable["GPC"] = function(String,TokTable)

	if not Hud then
		return;
	end

	Hud.iSelfWeapon1 = nil;
	Hud.iSelfWeapon2 = nil;
	Hud.iSelfWeapon3 = nil;
	Hud.iSelfWeapon4 = nil;

	Hud.szSelfTeam = tostring(TokTable[2]);
	Hud.szSelfClass = tostring(TokTable[3]);
	
	for i=1, 4 do
		if (TokTable[2 + i]) then
			Hud["iSelfWeapon"..i] = tonumber(TokTable[3 + i]);
		end
	end

	Hud.bReceivedSelfStat = 1;
end

ClientStuff.ServerCommandTable["GTK"] = function(String,TokTable)
	if not Hud then
		return;
	end
        if (count(TokTable)==3) then
        	Hud.szSelfJudge = tonumber(TokTable[2]);
        	Hud.szSelfCriminal = tonumber(TokTable[3]);
        else
        	Hud.szSelfJudge = 0;
        	Hud.szSelfCriminal = 0;
        end
end

ClientStuff.ServerCommandTable["WTF"] = function(String,TokTable)
	Client:SendCommand("FTW "..System.this_mod_version);
end

ClientStuff.ServerCommandTable["UTL"] = function(String,TokTable)
	if (Hud) then
		Hud.fTimeLimit = tonumber(TokTable[2]);
	end
end

function ClientStuff:GetInGameMenuVideoOn()
	return 0;
end

function ClientStuff:RetrieveTeamId(ent)
	local e_team = Game:GetEntityTeam(ent.id);
	if (e_team) then
		if e_team == "blue" then
			return 2;
		elseif e_team == "red" then
			return 1;
		end
	end
	return 0;
end

function ClientStuff:GetInGameMenuName()
	return "InGameNonTeam";
end

MessageTracker = {};

ClientStuff.ServerCommandTable["ACWR"]=function(String,toktable)
	if count(toktable)==3 then
		local customr = System:GetEntity(toktable[2]);
		local rmsgid = tonumber(toktable[3]);
		if (customr) and (Hud.radiomsg) then
			if (Hud.radiomsg[rmsgid]) then
				ClientStuff:SayToNPC(customr,Hud.radiomsg[rmsgid]);
			else
				local gesture = "";
				if (rmsgid == 91) then
					gesture = "signal_inposition";
				elseif (rmsgid == 92) then
					gesture = "signal_wait";
				elseif (rmsgid == 93) then
					gesture = "signal_teamleftadvance";
				elseif (rmsgid == 94) then
					gesture = "signal_formation";
				end
				-----
				if (gesture~="") and (not customr.cnt.proning) and (not customr.theVehicle) then
					customr:StartAnimation(0,gesture,4);
					customr.stop_my_talk = _time + 1.2;
				end
				------
			end
		end
	else
		local acw_radio=Sound:LoadSound("Sounds/items/MP_squelch.wav");
		local acw_warning=Sound:LoadSound("Languages/voicepacks/voiceB/vehicle_in_6_VoiceB.wav");
		if (acw_radio) and (acw_warning) then
			Sound:PlaySound(acw_radio);
			Sound:PlaySound(acw_warning);
		end
	end
end;

function ClientStuff:OnTextMessage(command, sendername, text)

 local bCanPrintMessage = 1; -- use as toggle

	if (MessageTracker.sendername == nil )then   -- no messages are stored for this sender. Store message then continue normally
		local MessageTime = _time; 
		local Repeats = 0;
		MessageTracker.sendername = {command,text,MessageTime,Repeats};
	else
			if (MessageTracker.sendername[2] == text ) then
			MessageTracker.sendername[4] = MessageTracker.sendername[4] + 1;
			else
			MessageTracker.sendername[2] = text;
			MessageTracker.sendername[4] = 0;
			end

			if (MessageTracker.sendername[4] > toNumberOrZero(getglobal("cl_message_repeat")) - 1) then
			bCanPrintMessage = 0;
			end

        end

	local InGameMenu = ClientStuff:GetInGameMenuName();

	if (not InGameMenu) then
		return
	end

	local ChatBox = UI:GetWidget("ChatBox", InGameMenu);
	
	if (not ChatBox) then
		return
	end
	
	if (text == nil) then
		return;
	end

	if (bCanPrintMessage == 1) then
		if (sendername ~= nil ) then	
			if (command == "sayone") then
				ChatBox:AddLine(sendername.." @MPChatPrivate ".."$9"..text);
				Hud:AddMessage("$4["..sendername.."$4]$9 "..text);
			elseif (command == "sayteam") then
				ChatBox:AddLine(sendername.." $1@MPChatTeam ".."$3"..text);
				Hud:AddMessage("$4["..sendername.."$4]$3 "..text);
			elseif (command == "say") then
				ChatBox:AddLine(sendername.."$1: "..text);
				Hud:AddMessage("$4["..sendername.."$4]$1 "..text);
			else
				Hud:AddMessage(text);
				return;
			end
			if (_localplayer) then
				BasicPlayer.PlayInteractSound(_localplayer,"Sounds/feedback/chat_msg.wav");
			end
		else
			Hud:AddMessage(text);
		end
	end
end

ClientStuff.ServerCommandTable["PLAA"]=function(String,toktable)
	local ent=System:GetEntity(toktable[2]);
	if (ent) and (Game:IsServer()==nil) then
	ent:StartAnimation(0,toktable[3],4);
	end
end

-- Mixer: Improved server-to-client side hit simulation:
ClientStuff.ServerCommandTable["CHI"] = function(String,toktable)
	local shter = System:GetEntity(toktable[2]);
	if (shter == _localplayer) and (toktable[2]~=toktable[3]) then
		Hud:PlayMultiplayerHitSound();
		Hud.hit=5;
	end
	if (Game:IsServer()) and (not toktable[5]) then return end
	local victim = System:GetEntity(toktable[3]);
	if (victim) then
		local htx = {};
		htx.damage = tonumber(toktable[4]);
		if (toktable[5]) and (toktable[5] == "f") then
			htx.pos = victim:GetPos();
			htx.e_fx = "butthurt";
			htx.dir = {x=0,y=0,z=1};
			htx.normal = htx.dir;
			htx.damage_type = "healthonly";
			htx.impact_force_mul_final=5;
			htx.impact_force_mul=5;
			htx.landed = 1;
			htx.falling=1;
		elseif (toktable[5]) and (toktable[5] == "b") then
			htx.pos = victim:GetPos();
			htx.e_fx = "bleeding";
			htx.dir = {x=0,y=0,z=-1};
			htx.normal = htx.dir;
			htx.damage_type = "healthonly";
			htx.impact_force_mul_final=1;
			htx.impact_force_mul=1;
			htx.landed = 1;
			htx.bleeding=1;
		elseif (toktable[5]) and (toktable[5] == "v") then
			htx.pos = {x=0,y=0,z=1};
			htx.e_fx = "bodun";
			htx.dir = {x=0,y=0,z=-1};
			htx.normal = htx.dir;
			htx.damage_type = "healthonly";
			htx.impact_force_mul_final=1;
			htx.impact_force_mul=1;
			htx.landed = 1;
			htx.bodun=1;
		else
			htx.pos = victim:GetBonePos("Bip01");
			htx.ipart = victim.deathImpulsePart;
			htx.e_fx = "bullet_hit";
			htx.dir = shter:GetDirectionVector();
			htx.normal = htx.dir;
			htx.damage_type = "normal";
			if (shter.fireparams) then
				if (shter.fireparams.iImpactForceMulFinal) then
					htx.impact_force_mul_final = shter.fireparams.iImpactForceMulFinal;
				end
				if (shter.fireparams.iImpactForceMulFinalTorso) then
					htx.impact_force_mul_final_torso = shter.fireparams.iImpactForceMulFinalTorso;
				end
				if (shter.fireparams.mat_effect) and (victim ~= shter) then
					htx.e_fx = shter.fireparams.mat_effect.."";
				end
			end
			if htx.damage < 0 then -- melee hit
				htx.damage = -htx.damage;
				htx.e_fx = "melee_slash";
			end
		end
		htx.shooter = shter;
		htx.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_flesh"));
		BasicPlayer.Client_OnDamage(victim,htx);
		if (victim == _localplayer) then
			if (htx.bodun) then
				victim.bodun_timer = _time + 3;
			else
				htx.play_mat_sound = 1;
				htx.target_id = victim.id;
				ExecuteMaterial2(htx,htx.e_fx);
				if (htx.bleeding) then
					victim.bleed_timer = _time + 3;
				end
			end
		end
	end
end;

-- Mixer: clientside update earned money / update grab item state
ClientStuff.ServerCommandTable["CSH"] = function(String,toktable)
	if (toktable[3]) then
		if (not Game:IsServer()) then
			local tt2 = tonumber(toktable[2]);
			if (tt2 < 0) then
				local grbr = System:GetEntity(abs(tt2));
				if (grbr) and (grbr.items) then
					grbr.items.gr_item_ang = tonumber(toktable[3]);
				end
			else
				local grbr = System:GetEntity(toktable[2]);
				if (grbr) then
					local gritm = tonumber(toktable[3]);
					if (gritm) then
						if (gritm < 0) then
							gritm = System:GetEntity(-floor(gritm));
							if (gritm) then
								gritm.grb_DropNow = 1;
							end
						else
							grbr:CarryPhysItem(80,floor(gritm));
						end
					end
				end
			end
		end
	elseif (_localplayer) then
		_localplayer.items.money = tonumber(toktable[2]);
	end
end;

-- kill message improved to retrieve team names coloring (like CS)
ClientStuff.ServerCommandTable["PKP"]=function(String,toktable)
	local size=count(toktable);

	if size==5 then
		local target=System:GetEntity(toktable[2]);
		local shooter=System:GetEntity(toktable[3]);
		local situation=toktable[4];
		local weapon=toktable[5];

		if target and situation then
			local killmsg = {};
			
			killmsg.situation = situation;
			killmsg.weapon = weapon;
			
			if situation=="1" then
				killmsg.target = target:GetName();
				killmsg.t_teamid = ClientStuff:RetrieveTeamId(target);
			else
				if not shooter then
					return;
				end
				killmsg.shooter = shooter:GetName();
				killmsg.target = target:GetName();
				killmsg.t_teamid = ClientStuff:RetrieveTeamId(target);
				killmsg.s_teamid = ClientStuff:RetrieveTeamId(shooter);
			end

			-- add kill message
			Hud:AddMessage(killmsg, 7.5, 0, 1);
		end
	end
end;

ClientStuff.ServerCommandTable["VB_SST"] = function(String,toktable)
	if (_localplayer) and (UI) and (UI.PageVotePanel) then
		local sst_value = 0;
		if (toktable[2]) then
			sst_value = tonumber(toktable[2]);
			if (sst_value) then
				UI.PageVotePanel.GUI.BotQuotaN:SelectIndex(sst_value + 1);
			end
		end
		if (toktable[3]) then
			sst_value = tonumber(toktable[3]);
			if (sst_value) then
				UI.PageVotePanel.GUI.RDiff:SelectIndex(sst_value);
			end
		end
		if (toktable[4]) then
			local tt4 = tonumber(toktable[4]);
			if (tt4) then
				UI.PageVotePanel.GUI.RHandi:Select(floor(tt4));
			end
		end
		if (toktable[5]) then
			ClientStuff.maps_to_vote = "";
				local map_num = 1;
			while (toktable[4+map_num]) do
				ClientStuff.maps_to_vote = ClientStuff.maps_to_vote..toktable[4+map_num].." ";
				map_num = map_num+1;
			end
			--System:LogAlways("map list: "..ClientStuff.maps_to_vote);
			UI.PageVotePanel.PopulateMapList();
		else
			ClientStuff.maps_to_vote = nil;
		end
	end
end

ClientStuff.ServerCommandTable["VOT"] = function(String,toktable)
	if (toktable[2]) then
		if (not ClientStuff.votenow) then
			if (not ClientStuff.vote_pop_snd) then
				ClientStuff.vote_pop_snd = Sound:LoadSound("Sounds/feedback/cis_vote_now.wav");
			end
			if (ClientStuff.vote_pop_snd) then
				Sound:PlaySound(ClientStuff.vote_pop_snd);
			end
		end
		ClientStuff.votenow = {
			time = _time+tonumber(toktable[2]),
			param1 = "@VotePan - ",
			par2 = 5,
			desc = "@cis_vote_hint",
		};
		if (ClientStuff.votenow.time < _time) then
			ClientStuff.votenow.time = _time + 5;
			ClientStuff.votenow.param1 = "@VotePassed -$3 ";
			ClientStuff.votenow.desc = nil;
		end
		if (toktable[3]) then
			if (toktable[3] == "gamestyle") then
				if (GameStyler) and (GameStyler.playermoves) then
					if (GameStyler.playermoves[tonumber(toktable[4])]) then
						ClientStuff.votenow.param1 = ClientStuff.votenow.param1..GameStyler.playermoves[tonumber(toktable[4])].name;
					else
						ClientStuff.votenow.param1 = ClientStuff.votenow.param1..GameStyler.playermoves[1].name;
					end
				end
			elseif (toktable[3] == "map") then
				if (toktable[7]) then
					ClientStuff.votenow.par2 = 6;
					ClientStuff.votenow.param1 = ClientStuff.votenow.param1.."@Map "..toktable[4].." @gt_"..toktable[5];
				else
					ClientStuff.votenow.param1 = ClientStuff.votenow.param1.."@Map "..toktable[4];
				end
			elseif (toktable[3] == "restart") then
				ClientStuff.votenow.param1 = ClientStuff.votenow.param1.."@cis_vote_restartmap in "..toktable[4];
			elseif (toktable[3] == "bot_quota") then
				ClientStuff.votenow.param1 = ClientStuff.votenow.param1.."@cis_bquota "..toktable[4];
			elseif (toktable[3] == "bot_difficulty") then
				local t4 = tonumber(toktable[4]);
				local difftbl = {"@DifficultyEasy","@DifficultyMedium","@DifficultyHard"};
				if (t4) and (difftbl[t4]) then
					ClientStuff.votenow.param1 = ClientStuff.votenow.param1.."@cis_bdiff "..difftbl[t4];
				else
					ClientStuff.votenow.param1 = ClientStuff.votenow.param1.."@cis_bdiff "..toktable[4];
				end
			elseif (toktable[3] == "kick") then
				local t4 = tonumber(toktable[4]);
				local Entity;
				if (ClientStuff) and (ClientStuff.idScoreboard) then
					Entity = System:GetEntity(ClientStuff.idScoreboard).cnt;
				end
				if (Entity) then
					local iY,X;
					local iLines=Entity:GetLineCount();
					local iColumns=Entity:GetColumnCount();
					
					for iY=0,iLines-1 do
						local idThisClient = Entity:GetEntryXY(ScoreboardTableColumns.ClientID,iY)-1;		-- first element is the clientid-1
						
						if idThisClient~=-1 then
							if floor(idThisClient) == t4 then
								t4 = -999;
								ClientStuff.votenow.param1 = ClientStuff.votenow.param1.."@cis_vote_kick "..Entity:GetEntryXY(ScoreboardTableColumns.sName,iY);
							end
						end
					end
				
				end 
				if (t4 ~= -999) then
					if (ClientStuff.votenow_lastkickname) then
						ClientStuff.votenow.param1 = ClientStuff.votenow.param1.."@cis_vote_kick "..ClientStuff.votenow_lastkickname;
					else
						ClientStuff.votenow.param1 = ClientStuff.votenow.param1.."@cis_vote_kick "..toktable[4];
					end
				end
			elseif (toktable[3] == "cis_railonly") then
				local t4 = tonumber(toktable[4]);
				local difftbl = {"@cis_allweap","@RailbowOnly","@InstaGib"};
				if (t4) and (difftbl[t4+1]) then
					ClientStuff.votenow.param1 = ClientStuff.votenow.param1..difftbl[t4+1];
				else
					ClientStuff.votenow.param1 = ClientStuff.votenow.param1..toktable[3].." "..toktable[4];
				end
			else
				ClientStuff.votenow.param1 = ClientStuff.votenow.param1..toktable[3].." "..toktable[4];
			end
		end
		if (toktable[ClientStuff.votenow.par2]) and (toktable[ClientStuff.votenow.par2+1]) then
			ClientStuff.votenow.param1 = ClientStuff.votenow.param1.." $1* @cis_voted_yes "..toktable[ClientStuff.votenow.par2].." @cis_voted_no "..toktable[ClientStuff.votenow.par2+1];
		end
	else
		ClientStuff.votenow = nil;
	end
end

function ClientStuff:OnUpdate()				
	self.vlayers:Update();
	self:UpdateScoreboard();
	-- Mixer: Physical Item Carriers Management:
	if (ClientStuff.PhysCarriers) then
		for i, cid in ClientStuff.PhysCarriers do
			if (i ~= "n") then
				local c_ent = System:GetEntity(floor(cid));
				if (c_ent) and (c_ent.items) and (c_ent.items.gr_item_id) then
					c_ent:CarryPhysItem(80);
				else
					tremove(ClientStuff.PhysCarriers,i);
				end
			end
		end
	end
end