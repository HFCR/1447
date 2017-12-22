--[[CryTop team scripting]]--

GameRules = {
	InitialPlayerProperties = {
		health		= 255, 			-- range: 0=dead .. 255=full health

		-- we do not have armor in FarCry right now
		-- [marco] we do,initially is set to 0 though
		armor		= 0,
	},

	m_nMusicId=0,

	-- damage modifier tables { head, heart, body, arm, leg, explosion }
	ai_to_player_damage = { 1, 1, 1, 0.5, 0.5, 0.5 },
	player_to_ai_damage  = { 10, 2.0, 1, 0.5, 0.5, 1 },
	ai_to_ai_damage   = { 0.5, 0.4, 0.4, 0.15, 0.15, 0.5 },
	
	-- head, heart, body, arm, leg, explosion
	-- голова, сердце, тело, рука, нога, взрыв
	common_damage = {10,10,5,.8,1,.8}, -- K0tanski

	player_to_player_damage = { 3, 1, 1, 0.5, 0.5, 0.5 },

	Arm2BodyDamage = .75,
	Leg2BodyDamage = 1,
	god_mode_count=0,

	player_death_pos = { x=0, y=0, z=0, xA=0, yA=0, zA=0 },

	TimeRespawn=10,
	TimeDied=0,
	bShowUnitHightlight=nil,			-- 1/nil (show a 3d object on top of every friendly unit)
	fBullseyeDamageLevel =  20,		-- amount of damage until the
	fBullseyeDamageDecay = 0.5,		-- X units of damage lost per second
}

-- If someone in script needs to know if we are running multiplayer or single player game.
GameRules.bMultiplayer = nil;
GameRules.bSingleplayer = 1;


function GameRules:GetPlayerScoreInfo(ServerSlot, Stream)
end

function GameRules:OnInit()
	Server:AddTeam("dm");
	--Initialize the debug tag point thingy
	--DebugTagPointsMgr:Init(g_LevelName);
	_LastCheckPPos=nil;
	self.god_mode_count=0; -- must be reset when switching to game mode in editor
end

function GameRules:KnifeMash(shtr)
	if (shtr.cnt.health > 0) then
		if (shtr.cnt.weapon) and (shtr.cnt.weapon.name~="KnifeDummy") then
			shtr.holster_to_draw_knife = floor(shtr.cnt.weapon.classid);
			BasicPlayer.ScriptInitWeapon(shtr, "KnifeDummy",1,1);
			shtr.cnt:SetCurrWeapon(WeaponClassesEx.KnifeDummy.id);
			--------------------
			shtr.cnt.weapon.sv_cold_wpn_contact = _time+shtr.cnt.weapon.hit_delay;
		end
	end
end

function GameRules:TravelTo(mapstr,tagstr,fade)
	if (not _localplayer) then
		return;
	end
	if (not _localplayer.items.visitedmaps) then
		_localplayer.items.visitedmaps = {};
	end
	local map2save = strlower(Game:GetLevelName());
	if (not _localplayer.items.visitedmaps[map2save]) then
		_localplayer.items.visitedmaps[map2save] = 1;
	end
	Game._cis_cstatus = {
		p_armor = _localplayer.cnt.armor,
		p_health = _localplayer.cnt.health,
		p_items = _localplayer.items,
		p_ammo = _localplayer.Ammo,
		p_keys = _localplayer.keycards,
		p_bombs = _localplayer.explosives,
		p_objs = _localplayer.objects,
		p_gren = _localplayer.cnt.grenadetype,
		p_grenn = _localplayer.cnt.numofgrenades,
		p_binocs = _localplayer.cnt.has_binoculars,
		p_flashl = _localplayer.cnt.has_flashlight,
	};

	Game._cis_cstatus.w = {};
	if (_localplayer.cnt.weapon) then
		Game._cis_cstatus.w_act = _localplayer.cnt.weapon.classid*1;
		Game._cis_cstatus.w_cammo = _localplayer.cnt.ammo*1;
	end
	local wnum = 0;
	local idx = _localplayer.cnt:GetWeaponsSlots();
	if (idx) then
		for i,wp in idx do
			if (wp~=0) then
				wnum = wnum + 1;
				Game._cis_cstatus.w[wnum] = {
					id = wp.classid*1,
					name = wp.name,
				};
				if (_localplayer.WeaponState) and (_localplayer.WeaponState[wp.classid]) then
					if (_localplayer.WeaponState[wp.classid].AmmoInClip) then
						Game._cis_cstatus.w[wnum].aic = _localplayer.WeaponState[wp.classid].AmmoInClip;
					end
					if (_localplayer.WeaponState[wp.classid].FireMode) then
						Game._cis_cstatus.w[wnum].fm = _localplayer.WeaponState[wp.classid].FireMode;
					end
				end
			end
		end
	end

	if (tagstr) then
		Game._cis_postag = tagstr;
	end
	------
	Game:Save("svg_"..map2save);
	_localplayer.cnt:SavePlayerElements();

	local map2load = strlower(mapstr);

	if (_localplayer.items.visitedmaps[map2load]) then
		Game._cis_cstatus.load = "svg_"..map2load;
		_localplayer:EnablePhysics(0);
		Game:SendMessage('StartLevelFade nil_map'); -- let the game exit current level and load a new one when message about non-existing level will appear
	else
		if (fade) and (fade~=0) then
			Game:SendMessage('StartLevelFade '..map2load);
		else
			Game:SendMessage('StartLevel '..map2load);
		end
	end
	-------------
end

function GameRules:OnUpdate( DeltaTime )
if (_localplayer) then
	if (Game._cis_postag) then
		local cpostag = System:GetEntityByName(Game._cis_postag);
		if (cpostag) and (cpostag.GetPos) then
			if (Game._cis_cstatus) then
				_localplayer.cnt.armor = Game._cis_cstatus.p_armor*1;
				_localplayer.cnt.health = Game._cis_cstatus.p_health*1;
				_localplayer.items = Game._cis_cstatus.p_items;
				_localplayer.keycards=Game._cis_cstatus.p_keys;
				_localplayer.explosives=Game._cis_cstatus.p_bombs;
				_localplayer.objects=Game._cis_cstatus.p_objs;
				_localplayer.cnt.grenadetype = Game._cis_cstatus.p_gren;
				_localplayer.cnt.numofgrenades = Game._cis_cstatus.p_grenn;
				_localplayer.cnt.has_binoculars = Game._cis_cstatus.p_binocs;
				_localplayer.cnt.has_flashlight = Game._cis_cstatus.p_flashl;
				local count = getn(Game._cis_cstatus.w);
				if (count > 0) then
					_localplayer.cnt:SetCurrWeapon();
					_localplayer.cis_svgload = 1;
					local idx = _localplayer.cnt:GetWeaponsSlots();
					if (idx) then
						for i,wp in idx do
							if (wp~=0) then
								_localplayer.cnt:MakeWeaponAvailable(WeaponClassesEx[wp.name].id,0);
							end
						end
					end
					idx = 1;
					_localplayer.WeaponState = nil;
					while (idx<=count) do
						BasicPlayer.ScriptInitWeapon(_localplayer, Game._cis_cstatus.w[idx].name);
						_localplayer.cnt:MakeWeaponAvailable(Game._cis_cstatus.w[idx].id);
						if (_localplayer.WeaponState[Game._cis_cstatus.w[idx].id]) then
							if (Game._cis_cstatus.w[idx].aic) then
								_localplayer.WeaponState[Game._cis_cstatus.w[idx].id].AmmoInClip=Game._cis_cstatus.w[idx].aic;
							end
							if (Game._cis_cstatus.w[idx].fm) then
								_localplayer.WeaponState[Game._cis_cstatus.w[idx].id].FireMode=Game._cis_cstatus.w[idx].fm;
							end
						end
						idx = idx + 1;
					end
					if (Game._cis_cstatus.w_act) then
						_localplayer.cnt:SetCurrWeapon(Game._cis_cstatus.w_act);
						_localplayer.cnt.ammo = Game._cis_cstatus.w_cammo*1;
					end
				end
				_localplayer.Ammo=Game._cis_cstatus.p_ammo;
			end
			_localplayer:SetPos(new(cpostag:GetPos()));
			_localplayer:SetAngles(new(cpostag:GetAngles()));
			local c_map = strlower(Game:GetLevelName());
			if (cpostag.Event_Save) and (_localplayer.items.visitedmaps) and (_localplayer.items.visitedmaps[c_map]) then
				Movie:StopAllSequences();
				BroadcastEvent(cpostag, "Save");
				cpostag.bSaveNow = nil;
				cpostag:SetTimer(200);
			end
		end
		Game._cis_postag = nil;
		Game._cis_cstatus = nil;
	else
		-- Mixer: Dirty hack addition to register saving first checkpoint (C++ code featured save), when starting level and it has respawn point named "Respawn0"
		-- really annoying stuff, but to get it work in more elegant way, it is needed to edit CryGame.dll and i'm trying to avoid it.
		if (Game:GetTagPoint("Respawn0") ~= nil) then
			if (not GameRules.firstsave_dirtyhack) then
				GameRules.firstsave_dirtyhack = 0;
			end
			if (GameRules.firstsave_dirtyhack < 3) then
				GameRules.firstsave_dirtyhack = GameRules.firstsave_dirtyhack + 1;
				return;
			else
				GameRules.firstsave_dirtyhack = nil;
			end
			if (_localplayer.bDirtyLoadFlag) then -- skip doing this if loaded from previously saved game
			else
				--- Mixer: make entry in save base ---
				local cp_savbasename = strlower(Game:GetLevelName());
				if (Mission) and (Mission.save_mission) then
					cp_savbasename = cp_savbasename.."_"..Mission.save_mission;
				else
					if (DEFIANT) then
						for i, Table in DEFIANT do
							if (Table[1] == cp_savbasename) then
								if (Table[2]) and (Table[2] ~= "") then
									cp_savbasename = cp_savbasename.."_"..Table[2];
									GameRules.bMissionDefined_defiant = 1;
									break;
								end
							end
						end
					end
					if (GameRules.bMissionDefined_defiant) then
						GameRules.bMissionDefined_defiant = nil;
					else
						cp_savbasename = cp_savbasename.."_"..Game:GetMapDefaultMission(cp_savbasename);
					end
				end
				cp_savbasename = strlower("checkpoint_"..cp_savbasename.."_1");
				local savbase_date = "";
				for i, val in Game:GetModsList() do
					if (val.CurrentMod) then
						savbase_date = val.Folder.."/";
						break;
					end
				end
				local sav_datetime = date("%Y%m%d%H%M%S")..strlower(Game:GetLevelName());
				if (UI) then
					UI:Ecfg(savbase_date.."Levels/sav_base.ini",cp_savbasename,sav_datetime);
				end
			end
		end
		---
		function GameRules:OnUpdate( DeltaTime )
			-- Mixer: Instagib Rules check:
			if tonumber(getglobal("cis_railonly"))~=0 then
				GameRules.insta_play = 1;
			else
				GameRules.insta_play = nil;
			end
			if (_localplayer) and (_localplayer.items.gr_item_id) then
				_localplayer:CarryPhysItem(80);
			end
		end
	end
end
end

function GameRules:OnShutdown()
end

function GameRules:OnMapChange()
    _LastCheckPPos = nil
    _LastCheckPAngles = nil
end

function GameRules:ApplyDamage( target, damage, damage_type )
	self.OldHealth = target.cnt.health -- K0tnaski
	self.OldArmor = target.cnt.armor

	if (damage > 0) then
		-- apply damage first to armor, if it is present
		-- Mixer: more random factor, armor is a bit more tough, but
		-- don't protects the arms/legs/head more!
		if (damage_type ~= "healthonly") then
			if (target.cnt.armor > 0) then
				target.cnt.armor= target.cnt.armor - (damage*0.4);
				-- clamp to zero
				if (target.cnt.armor < 0) then
					damage = -target.cnt.armor+damage*0.1;
					target.cnt.armor = 0;
				else
					damage = damage*0.1;
				end
			end
		end
	end
	target.cnt.health = target.cnt.health - damage;

	-- negative damage (medic tool) is is bounded to max_health
	if(target.cnt.health>target.cnt.max_health) then
		target.cnt.health=target.cnt.max_health;
	end

	if ( target.cnt.health < 1 ) then

		if (god) and (target==_localplayer) then
			GameRules.god_mode_count=GameRules.god_mode_count+1;
			target.cnt.health = self.InitialPlayerProperties.health;
		else
			target.cnt.health = 0;
			local angles=target:GetAngles();
			local	place = target:GetPos();
			GameRules.player_death_pos.x=place.x;
			GameRules.player_death_pos.y=place.y;
			GameRules.player_death_pos.z=place.z;
			GameRules.player_death_pos.xA=angles.x;
			--GameRules.player_death_pos.yA=angles.y;
			--no roll needed!!!!!
			GameRules.player_death_pos.yA=0;
			GameRules.player_death_pos.zA=angles.z;

			if (target==_localplayer) then
				self.TimeDied=_time;
			end

			target:GotoState( "Dead" );
		end
	end
end

---
function GameRules:OnDamage( hit )
    local theTarget = hit.target;
    local theShooter = hit.shooter;
    -- theTarget.theShooter = theShooter;
    -- if theShooter==_localplayer and theShooter.Properties.species == theTarget.Properties.species then
		-- Hud:AddMessage("@dfire")
	-- end

    --System.LogToConsole("--> GameRules:OnDamage shooter == "..hit.shooter.GetID());

	--mat_head
	--mat_heart
	--mat_arm
	--mat_leg
	--mat_flesh
	--mat_armor
	--mat_helmet

	if (theTarget) then
		if (theTarget.type == "Player" ) then
			if (hit.shooterSSID) then
				theShooter = Server:GetServerSlotBySSId(hit.shooterSSID);
				if (theShooter) then
					theShooter = theShooter:GetPlayerId();
					if (theShooter) then
						theShooter = System:GetEntity(theShooter);
					end
				end
			end
			theTarget.LastDamageDoneByPlayer=nil;
			local difficulty = tonumber(getglobal("game_DifficultyLevel"));
			-- local	dmgTable;

			if (difficulty and difficulty == 4) then
				-- dmgTable = GameRules.player_to_ai_damage;
			else
				-- determine correct damage modifier table
				if (theTarget.ai) then
					if (theShooter) and (theShooter.ai) then
						-- dmgTable=GameRules.ai_to_ai_damage;
					else
						-- dmgTable=GameRules.player_to_ai_damage;
						-- used for Autobalancing
						theTarget.LastDamageDoneByPlayer=1;
						if (theTarget.Properties.species == 0) and (theShooter) then
							if (not theTarget.items.ff_tolerance) then
								theTarget.items.ff_tolerance = 1;
							elseif (theTarget.items.ff_tolerance < 2) then
								theTarget.items.ff_tolerance = theTarget.items.ff_tolerance+1;
							else
								AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"RUSH_TARGET",theTarget.id);
							end
						end
					end
				else
					-- dmgTable = GameRules.ai_to_player_damage;
				end
			end
			local dmgTable = GameRules.common_damage -- K0tanski
			if (hit.explosion ~= nil ) then
				local expl=theTarget:IsAffectedByExplosion();
				if (expl<=0) then return end
				hit.damage= expl * hit.damage * dmgTable[6];
				hit.damage_type = "normal";
				hit.exp_stundmg = ceil(hit.damage*0.45);
				BasicPlayer.SetBleeding(theTarget,hit.exp_stundmg,hit.damage);
			end
			if (hit.target_material ~= nil ) then
				local	targetMatType = hit.target_material.type;
				local dmgf =1;
				--System.LogToConsole("onDamage mat: "..targetMatType);

				-- proceed protection gear
				if (targetMatType=="helmet") then
					if(theTarget.hasHelmet == 0) then
						hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_head"));
						targetMatType = hit.target_material.type;
					else
						BasicPlayer.HelmetHitProceed(theTarget, hit.dir, hit.damage);
						dmgf = 0.01;
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
					bullseyeDamage = bullseyeDamage + hit.damage * dmgTable[3];

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
					dmgf = dmgTable[4];
					hit.damage_type = "healthonly";
					theTarget.cnt.armhealth = theTarget.cnt.armhealth - hit.damage*dmgf;
					if( theTarget.cnt.armhealth<0 ) then
						theTarget.cnt.armhealth = 0;
					end
					dmgf = dmgf * GameRules.Arm2BodyDamage;
					dmgPrc = theTarget.cnt:GetArmDamage();
					--System.LogToConsole( "Arm HIT "..dmgPrc );
					if( dmgPrc>50 ) then
						theTarget.cnt.dmgFireAccuracy = 100 - (dmgPrc-50)/2;
					end
				elseif (targetMatType=="leg") then
					dmgf = dmgTable[5];
					hit.damage_type = "healthonly";
					theTarget.cnt.leghealth = theTarget.cnt.leghealth - hit.damage*dmgf;
					if ( theTarget.cnt.leghealth<0 ) then
						theTarget.cnt.leghealth = 0;
					end
					dmgf = dmgf * GameRules.Leg2BodyDamage;
				elseif (targetMatType=="head") then
					dmgf = dmgTable[1];
					if (theTarget.items) and (theTarget.items.kevlarhelmet) then
						if (theTarget.cnt.armor == 0) then
							theTarget.items.kevlarhelmet = nil;
							hit.damage_type = "healthonly";
						end
					else
						hit.damage_type = "healthonly";
					end
				elseif (targetMatType=="flesh") then
					dmgf = dmgTable[3];
				elseif (targetMatType=="heart") then
					dmgf = dmgTable[2];
					hit.damage_type = "healthonly";
				end
				if theShooter then -- K0tasnki
				-- if theShooter and theShooter==_localplayer then
					if not self.OldArmor then self.OldArmor = "nil" end
					if not self.OldHealth then self.OldHealth = "nil" end
					local dist = floor(theShooter:GetDistanceFromPoint(theTarget.pos))
					local text = "$9SHOOTER: $4"..theShooter:GetName()..", $9TARGET: $4"..theTarget:GetName()..", $8MATERIAL: "..targetMatType..", DIST: "..dist..", HEALTH: "..theTarget.cnt.health..", ARMOR:"..theTarget.cnt.armor..",\n DmgF: "..dmgf.."$8, DAMAGE: "..hit.damage.."$8, DAMAGE*DmgF: "..hit.damage*dmgf..", OldHealth: "..self.OldHealth..", OldArmor: "..self.OldArmor
					-- Hud:AddMessage(text)
					-- System:Log(text)
				end
				GameRules:ApplyDamage( theTarget, hit.damage*dmgf, hit.damage_type )
			else
				if (hit.landed == 1) then
					GameRules:ApplyDamage( theTarget, hit.damage, hit.damage_type )
				end
			end
		end
	end
end

function GameRules:RespawnPlayer(server_slot,player)

	if (player.type=="Player") then
		--set the default stats
		player.cnt.max_health=self.InitialPlayerProperties.health;
		player.cnt.health=self.InitialPlayerProperties.health;
		player.cnt.armor=self.InitialPlayerProperties.armor;
		player.cnt.alive=1;
		player:EnablePhysics(1);

		if (player.Properties.equipEquipment) then
			local WeaponPack = EquipPacks[player.Properties.equipEquipment];
			if (WeaponPack) then
				for i,val in WeaponPack do
					if (val.Type == "Item") then
						if (val.Name == "PickupFlashlight") then
							player.cnt:GiveFlashLight(1);
						elseif (val.Name == "PickupBinoculars") then
							player.cnt:GiveBinoculars(1);
						elseif (val.Name == "PickupHeatVisionGoggles") then
							player.items.heatvisiongoggles = 1;
						end
					end
				end
			end -- wp
		end -- eq

		-- [marco] make certain player elements persistent between levels
		-- here it's ok because in multiplayer we never save between levels,
		-- so this function will do nothing, and this is the final place where
		-- player stats are set before starting the game

		if (tonumber(getglobal("g_LevelStated")) == 0) then
			player.cnt:LoadPlayerElements();
		end

		-- [marco] set global EAX preset
		Sound:SetEaxEnvironment(EAXPresetDB["noreflectmoistair"],SOUND_OUTDOOR);
	end

	player:SetName(server_slot:GetName());

	if (_LastCheckPPos) then
		player:SetPos(_LastCheckPPos);
		player:SetAngles(_LastCheckPAngles);
	else
		local RespawnPoint = Server:GetFirstRespawnPoint();
		-- FIXME ... this is a bit ugly, but somehow we don't have a spawn point
		if (not RespawnPoint) then
			RespawnPoint = {x=0,y=0,z=0,xA=0,yA=0,zA=0};
		end
		player:SetPos({x = RespawnPoint.x, y = RespawnPoint.y, z = RespawnPoint.z});
		player:SetAngles({x = RespawnPoint.xA, y = RespawnPoint.yA, z = RespawnPoint.zA});
	end

end

function GameRules:OnClientConnect( server_slot, requested_classid )
	--create a new player entity
--	local RespawnPoint = Server:GetRandomRespawnPoint();
	local RespawnPoint = Server:GetFirstRespawnPoint();
	-- FIXME ... this is a bit ugly, but somehow we don't have a spawn point
	if (not RespawnPoint) then
		RespawnPoint = {x=0,y=0,z=0,xA=0,yA=0,zA=0};
	end

	local dir = {x = RespawnPoint.xA, y = RespawnPoint.yA, z = RespawnPoint.zA};
	local newPlayer=Server:SpawnEntity({classid=requested_classid,pos=RespawnPoint,angles=dir});

	System:Log("FirstRespawnPoint player pos x="..RespawnPoint.x.." y="..RespawnPoint.y.." z="..RespawnPoint.z);
	System:Log("FirstRespawnPoint player angles x="..dir.x.." y="..dir.y.." z="..dir.z);

	--delete the old player entity
	if(server_slot:GetPlayerId()~=0)then
		Server:RemoveEntity(server_slot.GetPlayerId());
	end

	--bind the new created player to the serverslot
	server_slot:SetPlayerId(newPlayer.id);

	--inform player about current game state (TODO: put in proper state & time)
	server_slot:SetGameState(0, 0);

	--set the player at the respawn point and set the starting health and stuff
	GameRules:RespawnPlayer(server_slot,newPlayer);
	Game:ForceScoreBoard(newPlayer.id, nil);
	server_slot.first_request=nil;
end

function GameRules:OnClientDisconnect( server_slot )
	--remove the player from the team
	--remove the entity
	if(server_slot:GetPlayerId()~=0)then
		Server:RemoveEntity(server_slot:GetPlayerId());
		server_slot:SetPlayerId(0); -- set an invalid player id
	end

end

function GameRules:OnClientRequestRespawn( server_slot, requested_classid )

	--System:LogToConsole("Clicked!");
	--System:LogToConsole("time=".._time-self.TimeDied);
	if self.TimeRespawn==0 or (_time-self.TimeDied<self.TimeRespawn) then -- От текущего времени (внутриигровой таймер в секундах, допустим 73; оно постоянно увеличивается) отнимается время когда игрок умер (на 69 секунде) и пока результат между ними (4 секунды, который увеличивается) будет меньше фиксированной цифры (10 секунд, это было указано в начале файла), будет выполняться всё, что внутри условия.
		local intensity = (_time-self.TimeDied)*.1 -- Вот так вот таймер, многократно помогает плавно что-нибудь увеличивать/уменьшать.
		Sound:SetGroupScale(SOUNDSCALE_DEAFNESS,1-intensity) -- Постепенно оглушить игрока, все звуки становятся тихими.
		Hud:OnMiscDamage(1) -- Незначительное нанесение урона. Видимо, я оставлял для того чтобы эта хрень на следующей строчке вообще работала.
		Hud:SetScreenDamageColor(intensity,0,0) -- Постепенно залить красным (RGB палитра же).
		-- System:Log("intensity="..intensity..", time=".._time)
		-- System:Log("time=".._time-self.TimeDied)
		return -- Это не позволяет выполняться коду, что находится ниже.
	end
	Hud:OnMiscDamage(10000) -- Постоянно наносит урон и оставляет экран затемнённым.
	Hud:SetScreenDamageColor(0,0,0) -- Чёрный.

	-- be sure this is removed when the client connects or the
	-- save menu appears
	--System:SetScreenFx("ScreenFade",0);

	--hack to slow down the respawn (should this be inside the if-then below?)
	if(Game:ShowSaveGameMenu())then
		--System:Log('Game:ToggleMenu()')
		Game:SendMessage("Switch");

		return
	else
		System:Log("Game:ShowSaveGameMenu() returned nil")
	end
	
	-- Авто возрожение убрал потому, что если игрок сохранится через консоль командой /save_game и погибнет, то он возродится на той же, но уже зачищенной от врагов локации с полным боекомплектом.
	do return end -- Не возрождаться.	
	
	if (server_slot.first_request) then

		local player;
		--for now I don't respawn the entity
		--create a new player entity
		local RespawnPoint = Server:GetRandomRespawnPoint();
		if(tonumber(gr_RespawnAtDeathPos)==1)then
			if(GameRules.player_death_pos)then
				RespawnPoint=GameRules.player_death_pos;
			end
		end
		local dir = {x = RespawnPoint.xA, y = RespawnPoint.yA, z = RespawnPoint.zA};
		local newPlayer=Server:SpawnEntity({classid=requested_classid,pos=RespawnPoint,angles=dir});

		System:Log("player pos x="..RespawnPoint.x.." y="..RespawnPoint.y.." z="..RespawnPoint.z);
		System:Log("player angles x="..dir.x.." y="..dir.y.." z="..dir.z);


		if(server_slot:GetPlayerId()~=0)then
			Server:RemoveEntity(server_slot:GetPlayerId());
		end


		GameRules:RespawnPlayer(server_slot,newPlayer);
		server_slot:SetPlayerId(newPlayer.id)
		Game:ForceScoreBoard(newPlayer.id, nil);
	else
		server_slot.first_request=1;
	end
end

-- player requests to be killed (typed in the "kill" console command)
function GameRules:OnKill(server_slot)
    local id = server_slot:GetPlayerId();

    if id ~= 0 then
        local ent = System:GetEntity(id);
        self:OnDamage({ target = ent, shooter = ent, damage = 1000, ipart = 0,target_material=Materials.mat_default });
    end
end

-------
function GameRules:OnClientJoinTeamRequest(server_slot,team_name)
		if(server_slot:GetPlayerId()~=0)then

			local requested_classid=1;
			local player=System:GetEntity(server_slot:GetPlayerId());

			if(team_name~=player:GetTeam())then

				if(team_name=="spectators")then
					requested_classid=SPECTATOR_CLASS_ID;
				end
				local newEntity=Server:SpawnEntity({classid=requested_classid});

				Server:RemoveEntity(player.id);
				server_slot:SetPlayerId(newEntity.id);
				newEntity:SetTeam(team_name);

			end
		end
end

---------------------

function GameRules:OnCallVote(server_slot, command, arg1)
	System:LogToConsole("vote called: "..command.." "..arg1);
	-- TODO: clone voting system from ffa rules.
end





-------------------------------------------------------
-------------------------------------------------------
-- return 1=if interaction is accepted, otherwise nil
function GameRules:IsInteractionPossible(actor,entity)
	-- prevent a player who is in a vehicle from interacting with the entity
	if (actor.theVehicle) then
		return nil;
	end

	-- prevent ai from using entities that are marked for player only use
	--if(entity.Properties.bPlayerOnly and entity.Properties.bPlayerOnly==1 and actor.ai~=nil)then
	--	return nil;
	--end
	-- prevent all ai from picking up things
	if(actor.ai~=nil)then
		return nil;
	end


	-- prevent corpses from interacting with something
	if(actor.cnt and (actor.cnt.health == nil or actor.cnt.health < 1))then
		return nil;
	end

	return 1;
end
