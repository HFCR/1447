--[[CryTop team scripting]]--
-- v2.0 HD
Script:LoadScript("scripts/default/hud/viewlayersmgr.lua")

ClientStuff={
	temp_layers={},
	temp_layers_save={},
	cl_promode = nil,
}

function ClientStuff:ShowScoreBoard(bShow)
	if (ScoreBoardManager) then
		ScoreBoardManager.SetVisible(bShow);
	end
end

function ClientStuff:ResetScores()
	if (ScoreBoardManager) then
		ScoreBoardManager.ClearScores();
	end
end

function ClientStuff:SetPlayerScore(Stream)
end

ClientStuff.ServerCommandTable={};

function ClientStuff:OnInit()
	self.vlayers=ViewLayersMgr:new(),
	Script:LoadScript("scripts/default/hud/zoomview.lua");
	--Script:LoadScript("scripts/default/hud/nightvision.lua"); --inactive
	Script:LoadScript("scripts/default/hud/binoculars.lua");
	Script:LoadScript("scripts/default/hud/heatvision.lua");
	Script:LoadScript("scripts/default/hud/weaponscope.lua");
	Script:LoadScript("scripts/default/hud/motracklayer.lua");
	Script:LoadScript("scripts/default/hud/smokeblur.lua");
	if (not UI) then
		Script:LoadScript("devgame.lua");
	end
	Binoculars:OnInit();
	--NightVision:OnInit(); --inactive
	MoTrackLayer:OnInit();
	SmokeBlur:OnInit();
	HeatVision:OnInit();
	self.vlayers:AddLayer("HeatVision",HeatVision);
	--self.vlayers:AddLayer("NightVision",NightVision); --inactive
	self.vlayers:AddLayer("MoTrack",MoTrackLayer);
	self.vlayers:AddLayer("Binoculars",Binoculars);
	self.vlayers:AddLayer("WeaponScope",WeaponScope);
	self.vlayers:AddLayer("SmokeBlur",SmokeBlur);
end

function ClientStuff:PlayPickupAnim(player)
	if (_localplayer.cnt) and (_localplayer.cnt.weapon) and (_localplayer.cnt.first_person) and (_localplayer.cnt.weapon_busy<=0) then
		_localplayer.cnt.weapon:StartAnimation(0,"Grenade11",0,0);
		if (_localplayer.fireparams) and (_localplayer.fireparams.pickup_timer) then
			_localplayer.pckanm_do = _time + _localplayer.fireparams.pickup_timer;
		else
			_localplayer.pckanm_do = _time + 0.2;
		end
	end
end

function ClientStuff:KnifeMash()
	if Game:IsMultiplayer() then
		Client:SendCommand("KNF");
	elseif (_localplayer) and (_localplayer.cnt) then
		GameRules:KnifeMash(_localplayer);
	end
end

function ClientStuff:OnSave(stm)
	if(self.temp_layers==nil) then
		stm:WriteBool(0);
	else
		stm:WriteBool(1);

		-- only save required/important viewlayers
		self.temp_layers.HeatVision=self.vlayers:IsActive("HeatVision");
		self.temp_layers.Binoculars=self.vlayers:IsActive("Binoculars");
		self.temp_layers.SmokeBlur=self.vlayers:IsActive("SmokeBlur");
		WriteToStream(stm, self.temp_layers);

		if (not HeatVision) then
			stm:WriteBool(0);
		else
			stm:WriteBool(1);
			local pHeatVisionTbl=HeatVision;
			WriteToStream(stm, pHeatVisionTbl);
		end

		if(not Binoculars) then
			stm:WriteBool(0);
		else
			stm:WriteBool(1);
			local pBinocularsTbl=Binoculars;
			WriteToStream(stm, pBinocularsTbl);
		end

		if(not SmokeBlur) then
			stm:WriteBool(0);
		else
			stm:WriteBool(1);
			local pSmokeBlurTbl=SmokeBlur;
			WriteToStream(stm, pSmokeBlurTbl);
		end
	end
end

----
function ClientStuff:OnLoad(stm)
	local bObj=stm:ReadBool();
	if(bObj) then
		self.vlayers:DeactivateAll();
		self.temp_layers_save=ReadFromStream(stm);

		bObj=stm:ReadBool();
		if(HeatVision and bObj) then
			local pHeatVisionTbl={};
			pHeatVisionTbl=ReadFromStream(stm);
			HeatVision:OnRestore(pHeatVisionTbl);
		end

		bObj=stm:ReadBool();
		if(Binoculars and bObj) then
			local pBinocularsTbl={};
			pBinocularsTbl=ReadFromStream(stm);
			Binoculars:OnRestore(pBinocularsTbl);
		end

		bObj=stm:ReadBool();
		if(SmokeBlur and bObj) then
			local pSmokeBlurTbl={};
			pSmokeBlurTbl=ReadFromStream(stm);
			SmokeBlur:OnRestore(pSmokeBlurTbl);
		end
		self.bLoaded=1;
	end
end

function ClientStuff:OnReset()
	--self.vlayers:DeactivateAll();

	--garbitos, deactivate only the ones we want
	for i,val in self.temp_layers do
		self.vlayers:DeactivateLayer(i);
	end

	self.temp_layers={};
	if(not self.bLoaded or self.bLoaded==0) then
		Hud:ResetDamage();
	end
end

function ClientStuff:RestoreAIranges()
	if (not Game:IsMultiplayer()) then
		local entities=System:GetEntities();
		for i, entity in entities do
			if (entity.MakeIdle) then
			entity:MakeIdle();
			entity:InitAIRelaxed();
			end
		end
	end
end
---
function ClientStuff:OnSetPlayer()
	self:OnReset();
	-- MIXER: MODIFIED FROM HERE CIS-n-FAR CRY friendship:
	if (Mission) then
		if (Mission.OnSetPlayer) then
			Mission:OnSetPlayer();
		end
		self:RestoreAIranges();
		if (not UI) and (Mission.OnInit) then
			Mission:OnInit();
		end
	else
		self:RestoreAIranges();
	end -- if (Mission)
	if (not _localplayer.theVehicle) then
		Input:SetActionMap("default");
	end
	-- viewdist restoring:
	if (not ClientStuff.originalviewdist) then
		ClientStuff.originalviewdist = System:ViewDistanceGet();
	else
		System:ViewDistanceSet(ClientStuff.originalviewdist);
	end
	Hud.hd_width = 0;
	if (_localplayer.bDirtyLoadPos) then
		_localplayer:SetPos(_localplayer.bDirtyLoadPos);
		_localplayer.bDirtyLoadPos = nil;
	end
end
----
function ClientStuff:OnPauseGame()
	if (_localplayer) then
		if (not _localplayer.cVstate) then
			self.temp_layers.HeatVision=self.vlayers:IsActive("HeatVision");
		end
		--self.temp_layers.NightVision=self.vlayers:IsActive("NightVision"); --inactive
		self.temp_layers.MoTrack=self.vlayers:IsActive("MoTrack");
		self.temp_layers.Binoculars=self.vlayers:IsActive("Binoculars");
		self.temp_layers.WeaponScope=self.vlayers:IsActive("WeaponScope");
		self.temp_layers.SmokeBlur=self.vlayers:IsActive("SmokeBlur");

		if _localplayer.cnt and _localplayer.cnt.SwitchFlashLight then
			_localplayer.cnt:SwitchFlashLight(0);
		end
	end
	--self.vlayers:DeactivateAll();

	--garbitos, deactivate only the ones we want
	for i,val in self.temp_layers_save do
		self.vlayers:DeactivateLayer(i);
	end

	local ents=System:GetEntities();
	for i, entity in ents do
		if (entity.type == "Player" and entity.cnt and entity.cnt.weapon) then
			BasicWeapon.Client.OnStopFiring(entity.cnt.weapon, entity);
		elseif (not Game:IsMultiplayer()) then
			-- Mixer: hack for proper moving distance of improved doors and elevators
			entity.cis_paused = 1;
		end
	end
end
-----
function ClientStuff:OnResumeGame()
	for i,val in self.temp_layers do
		self.vlayers:ActivateLayer(i);
	end
end
------
function ClientStuff:OnUpdate()
	if (self.bLoaded) and (self.bLoaded==1) then
		self.temp_layers=self.temp_layers_save;
		for i,val in self.temp_layers do
			self.vlayers:ActivateLayer(i);
		end
		self.bLoaded=nil;
	end
	self.vlayers:Update();
end

------
-- is called when map changes in MP or on disconnect
function ClientStuff:OnShutdown()
	self:OnReset();
end

------
-- This is called whenever an entity is spawned on the client

function ClientStuff:OnSpawnEntity(entity)
end

------
function ClientStuff:OnMapChange()
	self:OnReset();
	g_MapChanged=1;
end

---------
function ClientStuff:OnMenuEnter()
	local stats = _localplayer.cnt;

	if (stats.weapon and stats.weapon.AimMode==1) then
		if(ClientStuff.vlayers:IsActive("WeaponScope"))then
			ClientStuff.vlayers:DeactivateLayer("WeaponScope",1);
		end
	end
end

---------
-- callback for getting the in game menu
function ClientStuff:GetInGameMenuName()
	return "InGameSingle";
end

-------
-- callback for getting the in game menu video state
function ClientStuff:GetInGameMenuVideoOn()
	return 0;
end
-------
--
function ClientStuff:OnServerCmd(cmd,pos,normal,entityid,userbyte)

	local toktable=tokenize(cmd);

	if toktable~={} then
		local sCommand=toktable[1];

		local Function=self.ServerCommandTable[sCommand];

		if Function then
			Function(cmd,toktable,pos,normal,entityid,userbyte);
		end
	end
end

---------------------------------------------------------------------------------
-- show percentage for engineer tool
-- e.g. "P 1 55" for progress or "P" for no progress
-- /param 1=building, 2=repairing
-- /param precentage 0..100
ClientStuff.ServerCommandTable["P"]=function(String,toktable)
	if count(toktable)==2 then
		-- no progress (construction area is blocked)
		if toktable[2]=="1" then
			Hud:SetProgressIndicator("Player","@BuildProgress");
		elseif toktable[2]=="2" then
			Hud:SetProgressIndicator("Player","@RepairProgress");
		end
	elseif count(toktable)==3 then
		-- building or repairing
		if toktable[2]=="1" then
			Hud:SetProgressIndicator("Player","@BuildProgress",tonumber(toktable[3]));
		elseif toktable[2]=="2" then
			Hud:SetProgressIndicator("Player","@RepairProgress",tonumber(toktable[3]));
		end
	end
end;

ClientStuff.ServerCommandTable["UDD"]=function(String,toktable) -- UseDelayed -- Для индикатора использования чего-либо. -- K0tanski
	Hud:SetProgressIndicator("Player","@UsingProgress",tonumber(toktable[2]));
	-- local LabelTimerString = sprintf("%i",tostring(toktable[2])+1) -- Плавающее, переведённое в целое, переведённое в текстовое, и записанное в названии шкалы.
	-- if LabelTimerString == "100" then LabelTimerString = "$4"..LabelTimerString end
	-- Hud:SetProgressIndicator("Player","@UsingProgress: "..LabelTimerString,toktable[2]);
end;


------
-- show percentage for game
-- e.g. "P2 1 3"
-- /param checkpointno
-- /param [0..GameRules:GetCaptureStepCount()]
ClientStuff.ServerCommandTable["P2"]=function(String,toktable)
	if count(toktable)==4 then
		Hud:SetProgressIndicator("AssaultState","",tonumber(toktable[2]),tonumber(toktable[3]),tonumber(toktable[4]));
	end
end;

-- remote console printout (verbosity 1)
ClientStuff.ServerCommandTable["RCP"]=function(String,toktable)
	local sText=strsub(String,5,strlen(String));

	System:LogAlways(sText);
end;

ClientStuff.ServerCommandTable["PMUS"]=function(String,toktable)
	if (ClientStuff.pmus_snd) and (Sound:IsPlaying(ClientStuff.pmus_snd)) then
		Sound:StopSound(ClientStuff.pmus_snd);
	end
	ClientStuff.pmus_snd = Sound:LoadStreamSound(toktable[2]);
	if (ClientStuff.pmus_snd) then
		if (toktable[3]) then
			Sound:SetSoundVolume(ClientStuff.pmus_snd, tonumber(toktable[3]));
		else
			Sound:SetSoundVolume(ClientStuff.pmus_snd, getglobal("s_MusicVolume") * 255);
		end
		Sound:PlaySound(ClientStuff.pmus_snd);
	end
end;

-- play serverside feedback/physpickup message
ClientStuff.ServerCommandTable["PLAS"]=function(String,toktable)
	if count(toktable) < 3 then
		local plas_snd = "sounds/feedback/"..toktable[2];
		if (getglobal("g_language")) == "russian" then
			plas_snd = plas_snd.."_ru.ogg";
		else
			plas_snd = plas_snd.."_en.ogg";
		end
		plas_snd = Sound:LoadStreamSound(plas_snd);
		if (not plas_snd) then
			plas_snd = Sound:LoadStreamSound("sounds/feedback/"..toktable[2]..".ogg");
		end
		Sound:PlaySound(plas_snd);
	else
		local p_ent = System:GetEntity(toktable[2]);
		local p_pla = System:GetEntity(toktable[3]);
		if (p_ent) and (p_pla) then
			local p_entsnd = 0;
			local p_entpos = new(p_ent:GetPos());
			local p_plapos = new(p_pla:GetPos());
			if (p_ent.id == p_pla.id) then
				if (p_ent.cnt) and (p_ent.cnt.weapon) and (p_ent.cnt.weapon.ZoomAsAltFcl) then
					p_ent.cnt.weapon:ZoomAsAltFcl(p_ent);
					return;
				end
			elseif (p_ent.MoveVisitorTo) then
				p_entsnd = "Sounds/promode/p_spawn_1.wav";
				if (p_pla == _localplayer) then
					System:ProjectToScreen(p_plapos);
					System:SetScreenFx("FlashBang", 1);
					System:SetScreenFxParamFloat("FlashBang", "FlashBangFlashPosX", p_plapos.x);
					System:SetScreenFxParamFloat("FlashBang", "FlashBangFlashPosY", p_plapos.y);
					System:SetScreenFxParamFloat("FlashBang", "FlashBangTimeScale", 1);
					BasicPlayer.PlayInteractSound(_localplayer,"Sounds/promode/p_spawn_1.wav");
				else
					-- let's play teleport snd on both sides of teleport
					if (not p_ent.p_entsd2) then
						p_ent.p_entsd2 = Sound:Load3DSound(p_entsnd,SOUND_UNSCALABLE,255,3,40);
					end
					if (p_ent.p_entsd2) then
						Sound:SetSoundPosition(p_ent.p_entsd2,p_entpos);
						Sound:PlaySound(p_ent.p_entsd2);
					end
				end
				Particle:SpawnEffect( p_entpos,g_Vectors.v001,'misc.sparks.a',10);
				Particle:SpawnEffect( p_plapos,g_Vectors.v001,'misc.sparks.a',10);
			elseif (p_ent.Properties.ImpulseFadeInTime) then
				p_entsnd = "Sounds/promode/cis_jumppad.wav";
			elseif (toktable[4]) and (toktable[4] == "v") then
				if (p_ent.CarHitBodySnd) then
					Sound:SetSoundPosition(p_ent.CarHitBodySnd,p_pla:GetPos());
					Sound:PlaySound(p_ent.CarHitBodySnd);
				end
			elseif (p_ent.InitCommonAircraft) then
				local vpos = p_ent:GetHelperPos(p_ent.Properties.sRLauncherLeft,0);
				if (vpos) and (p_ent.rlaunchersnd) then
					Sound:SetSoundPosition(p_ent.rlaunchersnd,vpos);
					Sound:PlaySound(p_ent.rlaunchersnd);
					if (p_pla.cnt.first_person) then
						p_pla.cnt.weapon:StartAnimation(0, "idle11",0,0);
					end
					if (toktable[4]) then
						p_ent.ammoRL = tonumber(toktable[4]);
					end
					return;
				end
			elseif (p_ent.Properties.Animation.Animation == "give_health") then
				if (p_ent.Properties.sndAnimStart) and (p_ent.Properties.sndAnimStart~="") then
					p_entsnd = p_ent.Properties.sndAnimStart.."";
				else
					p_entsnd = "Sounds/objectimpact/magazine.wav";
				end
				ClientStuff:PlayPickupAnim(player);
				if (not Game:IsServer()) then
					p_ent:SetPos({x=0.01,y=0.01,z=0.01});
				end
			else
				if (p_ent.Properties.sndAnimStart) and (p_ent.Properties.sndAnimStart~="") then
					p_entsnd = p_ent.Properties.sndAnimStart.."";
				else
					p_entsnd = "Sounds/player/prone_up.wav";
				end
				if (p_pla == _localplayer) then
					Hud.bBlinkArmor=1;
				end
				ClientStuff:PlayPickupAnim(player);
				if (not Game:IsServer()) then
					p_ent:SetPos({x=0.01,y=0.01,z=0.01});
				end
			end
			if (not p_ent.p_entsd) then
				p_ent.p_entsd = Sound:Load3DSound(p_entsnd,SOUND_UNSCALABLE,255,3,40);
			end
			if (p_ent.p_entsd) then
				Sound:SetSoundPosition(p_ent.p_entsd,p_plapos);
				Sound:PlaySound(p_ent.p_entsd);
			end
		end
	end
end;

ClientStuff.ServerCommandTable["FX"] = function(String,toktable,pos,normal,entityid,userbyte)
	if (entityid == nil or entityid == -1) then	return end

	local entity = System:GetEntity(entityid);

	if (entity == nil) then
		System:Warning("OnRemoteEffect id="..tostring(entityid).." does not exist");
		return
	end

	local client = entity.Client;
	-- check if we have a handler available
	if (client and client.OnRemoteEffect) then
		client.OnRemoteEffect(entity, toktable, pos, normal, userbyte);
	elseif (entity.OnRemoteEffect) then
		entity.OnRemoteEffect(entity, toktable, pos, normal, userbyte);
	end
end

-----
ClientStuff.ServerCommandTable["GI"] = function(String,toktable)
	local player=_localplayer;

	if (player and player.type ~= "spectator" and count(toktable)>=2) then
		-- binoculars
		if (toktable[2] == "B") then
			if (player.cnt) then
				if (not player.cnt.has_binoculars) then
					player.cnt:GiveBinoculars(1);
					Hud:AddPickup(14, 1);
				else
					Hud:AddPickup(14, 1);
				end
			end
		elseif (toktable[2] == "C") then -- cryvision
			if(player.items) then	-- to prevent script error
				player:ChangeEnergy(player.MaxEnergy);
				player.items.heatvisiongoggles = 1;
				Hud:AddPickup(12, 1);
			end
		elseif (toktable[2] == "F") then -- flashlight
			if (player.cnt) then
				if(not player.cnt.has_flashlight) then
					player.cnt:GiveFlashLight(1);
					Hud:AddPickup(16, 1);
				else
					Hud:AddPickup(16, 1);
				end
			end
		elseif (toktable[2] == "K") then -- keycard add/rem
			local kc_num = tonumber(toktable[3]);
			if (kc_num) then
				if (player.keycards) then
					if (kc_num > 0) then
						player.keycards[kc_num] = 1;
					else
						player.keycards[abs(kc_num)] = 0;
					end
				end
			end
		elseif (toktable[2] == "E") then -- explos count
			local ex_num = tonumber(toktable[3]);
			if (ex_num) and (player.explosives) and (ex_num>0) then
				player.explosives = {};
				local exp_id = 0;
				while exp_id < ex_num do
					exp_id = exp_id + 1;
					player.explosives[exp_id] = 1;
				end
			else
				player.explosives = {};
			end
		elseif (toktable[2] == "WS") then -- reset viewlayers

			if (toktable[3]) and (Hud) then
				Hud.cl_money_amount = floor(toktable[3]);
				if (toktable[4]) then
					ClientStuff:OnReset();
				end
			else
				ClientStuff:OnReset();
			end

			if Hud.dtharea_id then
				if ClientStuff.lst_bgmsndid and ClientStuff.lst_bgmsndid[1] == Hud.dtharea_id[1] then
				else
					local sndidd = System:GetEntity(Hud.dtharea_id[1]);
					if sndidd then
						sndidd:Client_Active_OnLeaveArea( player,Hud.dtharea_id[2] );
					end
				end
				Hud.dtharea_id = nil;
			end
		end

		-- play pickup anim
		if (toktable[2] ~= "WS") then
			ClientStuff:PlayPickupAnim(player);
		end
	end
end
-------
ClientStuff.ServerCommandTable["HUD"] = function(String,toktable)
	local player=_localplayer;

	if (player and player.type ~= "spectator") then

		-- is weapon ? then activate weapons display
		if (count(toktable)==3 and toktable[2]=="W") then
			Hud.weapons_alpha=1;
			Hud.new_weapon=tonumber(toktable[3]);
		end

		if (count(toktable)>=4) then
			-- generic pick
			if(toktable[2]=="P") then
				Hud:AddPickup(Hud:GenericPickupsConversion(tonumber(toktable[3])), tonumber(toktable[4]));
				if (toktable[5]) then
					Hud:AddPickup(Hud:AmmoPickupsConversion("Bandage"), tonumber(toktable[5]));
				end
			end

			-- ammo pickup
			if(toktable[2]=="A") then
				Hud:AddPickup(Hud:AmmoPickupsConversion(toktable[3]), tonumber(toktable[4]));
			end
		end

		if (toktable[4]) and (tonumber(toktable[4]) == -1) then
			-- don't play pickup anim (can't pickup)
		else
			ClientStuff:PlayPickupAnim(player);
		end
	end


	if(player) then
		if(count(toktable)==2 and toktable[2]=="RR") then
			Hud:ResetRadar(_localplayer);
		end
	end

end