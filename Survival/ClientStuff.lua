-- survival 2.8
Script:LoadScript("scripts/FFA/ClientStuff.lua");
ClientStuff.cl_survival = 1;
ClientStuff.sio1_psta = 99;
ClientStuff.sio2_psta = 99;
ClientStuff.su_youlose = Sound:LoadStreamSound("Sounds/MENU/Output_no_crytek_voice.wav");
ClientStuff.su_youwin = Sound:LoadStreamSound("Music/MUSIC_CUES/CarrierObjective_01.ogg");
ClientStuff.sio_fixed = Sound:LoadStreamSound("Sounds/feedback/sio_full_fix.ogg");

function ClientStuff:ModeDesc()
	return "SURVIVAL";
end

function ClientStuff:OnSpawnEntity(entity)
	entity:EnableUpdate(1);
	if (entity.type == "Player") then
		entity:SetViewDistRatio(255);
		entity:RenderShadow( 1 );
		BasicPlayer.SecondShader_TeamColoring(entity);
		Hud:ResetRadar(entity);
		if (not entity.Properties.KEYFRAME_TABLE) or (entity.Properties.bNoRespawn) then
		if (not entity.isvillager) then
			-- L_A_G_G_E_R: А вот и рандомные шляпы, выдумывать ничего не нужно. Просто, добавить рандом.
			local rnd=random(1,7) -- "7" - максимальное случайное значение, которое попадёт в "rnd". Ставишь больше, будет больше.
			if rnd==1 then
				entity:LoadObject("Objects/characters/mercenaries/accessories/helmet.cgf",0,0);
				entity.hasHelmet=1 -- Оставить, если нужно что бы меделька шлема защищала голову.
			elseif rnd==2 then
				entity:LoadObject("Objects/characters/mercenaries/accessories/helmet_indoor.cgf",0,0);
				entity.hasHelmet=1
			elseif rnd==3 then
				entity:LoadObject("Objects/characters/mercenaries/accessories/helmet_indoor_haki.cgf",0,0);
				entity.hasHelmet=1
			elseif rnd==4 then
				entity:LoadObject("Objects/characters/mercenaries/accessories/helmet_army_camo.cgf",0,0);
				entity.hasHelmet=1
			elseif rnd==5 then
				entity:LoadObject("Objects/characters/mercenaries/accessories/helmet_army_black.cgf",0,0);
				entity.hasHelmet=1
			elseif rnd==6 then
				entity:LoadObject("Objects/characters/mercenaries/accessories/helmet_white.cgf",0,0);
				entity.hasHelmet=1
			else -- Если нужно больше моделек, то просто заменяешь "else" на "elseif rnd==6 then" и копирушешь по аналогии со строками выше.
				entity:LoadObject("Objects/characters/mercenaries/accessories/helmet_army_black.cgf",0,0);
				entity.hasHelmet=1
			end
			entity:AttachObjectToBone( 0, "hat_bone", 0, 1  );
			entity.bShowOnRadar=1;
		end
		end
	elseif (entity.type == "Synched2DTable") then
		ClientStuff.idScoreboard=entity.id;
	end
end

function ClientStuff:UpdateScoreboard()
	if not ClientStuff.idScoreboard then
		System:Log("Error: ASSAULT idScoreboard is nil");
		return;
	end

	if ScoreBoardManager:IsVisible()==0 then
		return;
	end
	
	ScoreBoardManager.ClearScores();

	-- set score board fields
	self.scoreFields={ 		
		[1]="@cis_earned",
		[2]="@ScoreBoardDeaths",
		[3]="@ScoreBoardEfficiency",
		[4]="@ScoreBoardPing",
	};		
	ScoreBoardManager:SetBoardFields(self.scoreFields);
	
	local SBEntityEnt = System:GetEntity(ClientStuff.idScoreboard);
	if (SBEntityEnt) and (SBEntityEnt.cnt) then
	local SBEntity = SBEntityEnt.cnt;

	local iY,X;
	local iLines=SBEntity:GetLineCount();
	local iColumns=SBEntity:GetColumnCount();
	
	for iY=0,iLines-1 do
		local idThisClient = tonumber(SBEntity:GetEntryXY(ScoreboardTableColumns.ClientID,iY));
		
		if (idThisClient) and (idThisClient ~= 0) then
			local iScore=SBEntity:GetEntryFloatXY(ScoreboardTableColumns.iScore,iY);
			local iDeaths=SBEntity:GetEntryFloatXY(ScoreboardTableColumns.iDeaths,iY);
			local iPlayerTeam=SBEntity:GetEntryFloatXY(ScoreboardTableColumns.iPlayerTeam,iY);
			local iSuicides=SBEntity:GetEntryFloatXY(ScoreboardTableColumns.iSuicides,iY);
			local szName=SBEntity:GetEntryXY(ScoreboardTableColumns.sName,iY);
			local iPing=SBEntityEnt.PingTable[idThisClient-1];

			if not iPing then
				iPing="BOT";
			end
			
			local sType="Player";
		
			if iPlayerTeam==0 then
				sType="Spectator";
			end
			
			local iEfficiency=self:CalcEfficiency(iScore,iDeaths,iSuicides);

			-- set player score table
			local playerScore={ 
				[1]= { iVal=iScore*12, iSort=1 }, -- kills score, sort by bigger
				[2]= { iVal=iDeaths, iSort=0 }, -- deaths score, sort by smaller
				[3]= { iVal=iEfficiency, iSort=1 }, -- effiency score, sort by bigger
				[4]= { iVal=iPing, iSort=0 }, -- ping, sort by smaller
				sortby= { [1]=1, [2]=2, [3]=3 }, -- set sort order fields
				type=sType,
				name=szName,
				ready=1,
			};
			ScoreBoardManager:SetPlayerScore(playerScore);		
		end	
	end
	end
end

ClientStuff.ServerCommandTable["SUBY"]=function(String,toktable) -- SUrvival BuY
	local customr = System:GetEntity(toktable[2]);
	if (customr) then
		ClientStuff:SayToNPC(customr,Hud.su_traderbuy);
		if (_localplayer) and (customr == _localplayer) then
			Hud.buysign_top = 600;
		elseif (not customr.cnt.proning) and (not customr.theVehicle) then
			customr:StartAnimation(0,"weaponswitch",4);
			customr.stop_my_talk = _time + 0.5;
		end
	end
end;

ClientStuff.ServerCommandTable["SPS"]=function(String,toktable) -- SUrvival Player Status
	local plr = System:GetEntity(toktable[2]);
	if (plr) then
		local c_hlth = tonumber(toktable[3]);
		local m_hlth = tonumber(toktable[4]);
		if (not Game:IsServer()) then
			plr.cnt.health = c_hlth * 1;
			plr.cnt.max_health = m_hlth * 1;
		end
		if (plr.isvillager) then
			if (plr.scream_rebreath) and (plr.scream_rebreath < _time) then
				plr.scream_rebreath = nil;
			end
			if (not plr.cl_prvhelth) then
				plr.cl_prvhelth = m_hlth * 1;
			end
			if (m_hlth > 0) and (not plr.scream_rebreath) then
				if (c_hlth / m_hlth < 0.8) and (plr.cl_prvhelth > c_hlth) then
					local r_scream = random(1,2);
					if (plr.call_4_help_messages[r_scream]) then
						if (plr.call_4_help_messages[r_scream].sound) then
							Sound:PlaySound(plr.call_4_help_messages[r_scream].sound);
						end
						if (Hud) and (plr.call_4_help_messages[r_scream].text) then
							Hud:AddMessage(plr:GetName()..": $1 "..plr.call_4_help_messages[r_scream].text);
						end
					end
					if (Hud) then
						Hud.cis_mp_talker = {
							pos = new(plr:GetPos()),
							p_id = plr.id * 1,
							tme = _time + 3.5,
						};
					end
					plr.scream_rebreath = _time + 9;
				end
			end
			plr.cl_prvhelth = c_hlth * 1;
		end
	end
end;

ClientStuff.ServerCommandTable["TVC"]=function(String,toktable)
	if (_localplayer) then
		Hud:ResetRadar(_localplayer);
	end
	local tokcount=count(toktable);
	if tokcount>=5 then
		if (toktable[5] == "L") then
		Hud.im_spot = System:GetEntityByName("INTERMISSIONCAMERA");
		if (Hud.im_spot) then
		Hud.im_spot = new(Hud.im_spot:GetAngles());
		end
		Sound:PlaySound(ClientStuff.su_youlose);
		Sound:AddMusicMoodEvent("Sneaking",6);
		Hud.su_msgs = 1;
		Hud.su_lose_msg = _time + 6;
		elseif (toktable[5] == "D") then
		Sound:PlaySound(Hud.su_villagerdown);
		Hud.su_msgs = 1;
		Hud.su_vdown_msg = _time + 3;
		elseif (toktable[5] == "V") then
		Hud.im_spot = System:GetEntityByName("INTERMISSIONCAMERA");
		if (Hud.im_spot) then
		Hud.im_spot = new(Hud.im_spot:GetAngles());
		end
		Sound:PlaySound(ClientStuff.su_youwin);
		Hud.su_msgs = 1;
		Hud.su_win_msg = _time + 6;
		Sound:AddMusicMoodEvent("Sneaking",6);
		elseif (toktable[5] == "F") then
			local talker = System:GetEntity(toktable[6]);
			if (talker) then
				ClientStuff:SayToNPC(talker,Hud.su_villagerfollow);
			end
		elseif (toktable[5] == "S") then
			local talker = System:GetEntity(toktable[6]);
			if (talker) then
				ClientStuff:SayToNPC(talker,Hud.su_villagerstay);
			end
		elseif (toktable[5] == "B") then
			Hud.su_msgs = 1;
			Hud.su_briefing_def = _time + 8;
		elseif (toktable[5] == "I") then
			if (_localplayer.cnt) and (not _localplayer.cnt.has_binoculars) then
				_localplayer.cnt:GiveBinoculars(1);
				Hud:AddPickup(14,1);
				_localplayer.cnt.has_binoculars = 1;
				Hud:AddMessage("@su_bonus_b");
			end
		elseif (toktable[5] == "N") then
			if (_localplayer.items) then
				_localplayer:ChangeEnergy(_localplayer.MaxEnergy);
				_localplayer.items.heatvisiongoggles = 1;
				Hud:AddPickup(12,1);
			end
		end
	end
	if (toktable[2]~="n") then
		local vents = tonumber(toktable[2]);
		if (vents < 0) then
			if (not ClientStuff.su_atkicn) then
				ClientStuff.su_atkicn = 1;
				Hud.PlayerObjectiveAnimTex = System:LoadImage("textures/hud/multiplayer/attacker_Logo");
			end
		elseif (ClientStuff.su_atkicn) then
			ClientStuff.su_atkicn = nil;
			Hud.PlayerObjectiveAnimTex = System:LoadImage("textures/hud/multiplayer/defender_Logo");
		end
		Hud.vill_count=abs(vents);
		vents = System:GetEntities();
		local sios = {};
		if (vents) then
			for i,ven in vents do
				if (ven.isvillager) then
					ven.bShowOnRadar=1;
				elseif (ven.Properties) and (ven.Properties.max_buildpoints) and (ven.Properties.max_buildpoints>0) then
					if (ven.Properties.object_Model_built~="") then
						tinsert(sios,new(ven:GetPos()));
						Hud.sio_objectives = sios;
					end
				end
			end
		end
	end
	local eh_tp = Game:GetTagPoint("ESCORT_HERE");
	if (eh_tp~=nil) then
	Hud:SetRadarObjectivePos(eh_tp);
	Hud.bBlinkObjective=1;
	Hud.sio_objectives = nil;
	end
	Hud.sio1_status=tonumber(toktable[3]);
	if (Hud.sio1_status ~= 0) then
	if (ClientStuff.sio1_psta > Hud.sio1_status) then
	Sound:PlaySound(Hud.sio_restore);
	elseif (ClientStuff.sio1_psta < Hud.sio1_status) then
		Sound:PlaySound(Hud.sio_alarm);
		if (Hud.sio1_status == 2) then
			Hud.su_objatt_msg = _time + 3.5;
			Hud.su_msgs = 1;
		end
		Hud.bBlinkObjective=1;
	end
	ClientStuff.sio1_psta = Hud.sio1_status;
	end
	Hud.sio2_status=tonumber(toktable[4]);
	if (Hud.sio2_status ~= 0) then
	if (ClientStuff.sio2_psta > Hud.sio2_status) then
	Sound:PlaySound(Hud.sio_restore);
	elseif (ClientStuff.sio2_psta < Hud.sio2_status) then
	Sound:PlaySound(Hud.sio_alarm);
	end
	ClientStuff.sio2_psta = Hud.sio2_status;
	end
end;
-- survival pkp
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
				if (target.Properties.KEYFRAME_TABLE) and (not target.Properties.bNoRespawn) then
				killmsg.t_teamid = 1;
				else
				killmsg.t_teamid = 2;
				end
			else
				if not shooter then
					return;
				end
				killmsg.shooter = shooter:GetName();
				killmsg.target = target:GetName();
				if (target.Properties.KEYFRAME_TABLE) and (not target.Properties.bNoRespawn) then
				killmsg.t_teamid = 1;
				elseif (target.isvillager) then
				killmsg.t_teamid = 3;
				else
				killmsg.t_teamid = 2;
				end
				if (shooter.Properties.KEYFRAME_TABLE) and (not shooter.Properties.bNoRespawn) then
				killmsg.s_teamid = 1;
				elseif (shooter.isvillager) then
				killmsg.s_teamid = 3;
				else
				killmsg.s_teamid = 2;
				end
			end

			-- add kill message
			Hud:AddMessage(killmsg, 7.5, 0, 1);
		end
	end
end;
