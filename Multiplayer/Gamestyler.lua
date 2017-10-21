-- XASSM (eXtremeArenaVerySoft) Server-Side Mod v2.6
--
-- Created by Garbitos
--
if (not Gamestyler) then
	Gamestyler={
		curr_gamestyle = nil,
		curr_weaponstyle = nil,
		wasloaded = 0,
		native_version = tostring("v"..Game:GetVersion("%d.%d%d")),
	};
end
--
function Gamestyler:Init()
	System:Log("Gamestyler.Init: Declare gamestyler vars...");
	--"pure" patch variables
	if getglobal("gr_useClassicPlayerDef")==nil then Game:CreateVariable("gr_useClassicPlayerDef",0,"NetSynch"); end -- use 1.33 pure player parameters?
	if getglobal("gr_useClassicWeaponsParams")==nil then Game:CreateVariable("gr_useClassicWeaponsParams",0,"NetSynch"); end -- use 1.33 pure weapon parameters?
	if self.native_version ~= "v1.40" then setglobal("gr_useClassicPlayerDef",1); setglobal("gr_useClassicWeaponsParams",1); end -- "pure" patch selection
	--Server variables
	Game:CreateVariable("gr_ssm_gamestyle",0); -- gamestyle select: 0 = DEFAULT (Pure), 1 = HARDCORE, 2 = EXTREME, 3 = STUNT, 4 = CRAZYCRY, 5 = CUSTOM (uses gr_custom_gamestyle) (new)
	Game:CreateVariable("gr_ssm_weaponstyle",0); -- weaponstyle select0 = DEFAULT (Pure), 1 = HARDCORE, 2 = EXTREME, 3 = STUNT, 4 = CRAZYCRY, 5 = CUSTOM (uses gr_custom_gamestyle) (new)
	Game:CreateVariable("gr_custom_gamestyle","custom_gamestyle.txt"); --name of text file containing the proper CUSTOM variables
	Game:CreateVariable("gr_custom_weaponstyle","custom_weaponstyle.txt"); --name of text file containing the proper CUSTOM variables
	--self.curr_gamestyle = 0;
	--self.curr_weaponstyle = 0;
	--Server commands
	Game:AddCommand("gr_gamestyle","Gamestyler:xa_gs(%1,%2,%3);","gr_gamestyle [gamestyle] [weaponstyle] [restart]");
	Game:AddCommand("gr_weaponstyle","Gamestyler:xa_ex(%1,%2,%3,%4,%5,%6);","gr_weaponstyle [weaponstyle] [norl] [novr] [nogl] [nosr] [restart]");
	Game:AddCommand("gr_kit_restrict","Gamestyler:xa_kit(%1,%2,%3,%4,%5);","gr_kit_restrict [norl] [novr] [nogl] [nosr] [restart]");
	Game:AddCommand("gr_use_classic","Gamestyler:xa_classic(%1,%2,%3);","gr_use_classic [player] [weapons] [restart]");
	--Gamestyler variables
	Game:CreateVariable("gr_customdamagescale","1.00");
	Game:CreateVariable("gr_customstaminascale","1.00");
	Game:CreateVariable("gr_customspeedscale","1.00");
	Game:CreateVariable("gr_customfallscale","1.00");
	Game:CreateVariable("gr_realistic_headshot",0);
	Game:CreateVariable("gr_spawn_health_ffa",130);
	Game:CreateVariable("gr_spawn_armor_ffa",0);
	Game:CreateVariable("gr_max_armor_ffa",100);
	Game:CreateVariable("gr_player_air_control",1);
	Game:CreateVariable("gr_player_gravity",1);
	Game:CreateVariable("gr_player_jump_gravity",1);
	Game:CreateVariable("gr_player_inertia",1);
	Game:CreateVariable("gr_player_sprint_scale",1);
	Game:CreateVariable("gr_stamina_use_jump",1);
	Game:CreateVariable("gr_player_restore_mult",1);
	Game:CreateVariable("gr_player_fall_scale_mult",1);
	Game:CreateVariable("gr_minSlideAngle",46);
	Game:CreateVariable("gr_minFallAngle",70);
	Game:CreateVariable("gr_maxClimbAngle",55);
	Game:CreateVariable("gr_maxJumpAngle",50);
	Game:CreateVariable("gr_boatSpeed",1);
	Game:CreateVariable("gr_boatTurn",1);
	Game:CreateVariable("gr_boatTurnDamper",1);
	Game:CreateVariable("gr_boatTilt",1);
	Game:CreateVariable("gr_boatMass",1);
	Game:CreateVariable("gr_boatGravity",1);
	Game:CreateVariable("gr_boatCollideDamage",1);
	Game:CreateVariable("gr_boatPushPower",1);
	Game:CreateVariable("gr_boatEject",1);
	Game:CreateVariable("gr_boatUprightImpulse",1);
	Game:CreateVariable("gr_dingySpeed",1);
	Game:CreateVariable("gr_dingyTurn",1);
	Game:CreateVariable("gr_dingyTurnDamper",1);
	Game:CreateVariable("gr_dingyTilt",1);
	Game:CreateVariable("gr_dingyMass",1);
	Game:CreateVariable("gr_dingyGravity",1);
	Game:CreateVariable("gr_dingyCollideDamage",1);
	Game:CreateVariable("gr_dingyPushPower",1);
	Game:CreateVariable("gr_buggyWaterDepth",1);
	Game:CreateVariable("gr_buggyCollideDamage",1);
	Game:CreateVariable("gr_humveeWaterDepth",1);
	Game:CreateVariable("gr_humveeCollideDamage",1);
	Game:CreateVariable("gr_forkliftWaterDepth",1);
	Game:CreateVariable("gr_bigtrackWaterDepth",1);
	--Weaponstyler variables
	Game:CreateVariable("gr_initial_smoke_grenades",1);
	Game:CreateVariable("gr_pickup_smoke_grenades",1);
	Game:CreateVariable("gr_droppickup_smoke_grenades",0);
	Game:CreateVariable("gr_max_smoke_grenades",2);	
	Game:CreateVariable("gr_initial_hand_grenades",5);
	Game:CreateVariable("gr_pickup_hand_grenades",2);
	Game:CreateVariable("gr_droppickup_hand_grenades",0);
	Game:CreateVariable("gr_max_hand_grenades",5);
	if (self.native_version~="v1.40") or (toNumberOrZero(getglobal("gr_useClassicWeaponsParams"))>=1) then Game:CreateVariable("gr_max_pistol_ammo_ffa",150); else Game:CreateVariable("gr_max_pistol_ammo_ffa",54); end
	Game:CreateVariable("gr_max_shotgun_ammo_ffa",60);
	if (self.native_version~="v1.40") or (toNumberOrZero(getglobal("gr_useClassicWeaponsParams"))>=1) then Game:CreateVariable("gr_max_smg_ammo_ffa",300); else Game:CreateVariable("gr_max_smg_ammo_ffa",250); end
	Game:CreateVariable("gr_max_assault_ammo_ffa",300);
	Game:CreateVariable("gr_max_hand_grenades_ffa",6);
	Game:CreateVariable("gr_max_flash_bang_grenades_ffa",6);
	Game:CreateVariable("gr_max_smoke_grenades_ffa",6);
	Game:CreateVariable("gr_max_sniper_ammo_ffa",30);
	Game:CreateVariable("gr_sniper_ammo_per_clip",5); --DO NOT CHANGE! Will break reload animation for clients on your server.
	Game:CreateVariable("gr_ag36_nades_per_clip",1); --DO NOT CHANGE! Will break reload animation for clients on your server.
	Game:CreateVariable("gr_oicw_nades_per_clip",2); --DO NOT CHANGE! Will break reload animation for clients on your server.
	Game:CreateVariable("gr_rockets_per_clip",1); --DO NOT CHANGE! Will break reload animation for clients on your server.
	Game:CreateVariable("gr_rocketSpeedMP",1);
	Game:CreateVariable("gr_rocketDamageMP",1);
	Game:CreateVariable("gr_vehicleRocketSpeed",1);
	Game:CreateVariable("gr_vehicleRocketDamage",1);
	Game:CreateVariable("gr_ag36_nade_damage_factor",1);
	Game:CreateVariable("gr_oicw_nade_damage_factor",1);
	Game:CreateVariable("gr_rocket_damage_factor",1);
	Game:CreateVariable("gr_hand_grenade_damage_factor",1);
	Game:CreateVariable("gr_flash_bang_grenade_stun_factor",1);
	Game:CreateVariable("gr_shocker_damage_factor",1);
	Game:CreateVariable("gr_wrench_damage_factor",1);
	Game:CreateVariable("gr_machete_damage_factor",1);
	Game:CreateVariable("gr_pistol_damage_factor",1);
	Game:CreateVariable("gr_mp5_damage_factor",1);
	Game:CreateVariable("gr_p90_damage_factor",1);
	Game:CreateVariable("gr_m4_damage_factor",1);
	Game:CreateVariable("gr_ag36_damage_factor",1);
	Game:CreateVariable("gr_oicw_damage_factor",1);
	Game:CreateVariable("gr_m249_damage_factor",1);
	Game:CreateVariable("gr_shotgun_damage_factor",1);
	Game:CreateVariable("gr_sniper_damage_factor",1);
	Game:CreateVariable("gr_realVehixDamage",0);
	Game:CreateVariable("gr_vehixScaleExplosion",1);
	Game:CreateVariable("gr_boatMGammo",500);
	Game:CreateVariable("gr_boatRLammo",30);
	Game:CreateVariable("gr_boatBulletDamage",1);
	Game:CreateVariable("gr_dingyBulletDamage",1);
	Game:CreateVariable("gr_buggyMGammo",500);
	Game:CreateVariable("gr_buggyBulletDamage",1);
	Game:CreateVariable("gr_humveeMGammo",700);
	Game:CreateVariable("gr_humveeRLammo",30);
	Game:CreateVariable("gr_humveeBulletDamage",1);
	Game:CreateVariable("gr_norl",0);
	Game:CreateVariable("gr_novr",0);
	Game:CreateVariable("gr_nogl",0);
	Game:CreateVariable("gr_nosr",0);
	Game:CreateVariable("gr_ag36_speed", 1.035);
	Game:CreateVariable("gr_falcon_speed", 1);
	Game:CreateVariable("gr_m4_speed", 1.044);
	Game:CreateVariable("gr_m249_speed", 1);
	Game:CreateVariable("gr_machete_speed", 1);
	Game:CreateVariable("gr_mp5_speed", 1);
	Game:CreateVariable("gr_oicw_speed", 1.072);
	Game:CreateVariable("gr_p90_speed", 1);
	Game:CreateVariable("gr_rl_speed", 1);
	Game:CreateVariable("gr_shocker_speed", 1);
	Game:CreateVariable("gr_shotgun_speed", 1);
	Game:CreateVariable("gr_sniperrifle_speed", 1.200);
	Game:CreateVariable("gr_wrench_speed", 1);
	System:Log("Gamestyler.Init: current gs [ "..getglobal("gr_ssm_gamestyle").." "..self:sayHi(getglobal("gr_ssm_weaponstyle")).." ]".." current ws [ "..getglobal("gr_ssm_weaponstyle").." "..self:sayHi(nil,getglobal("gr_ssm_weaponstyle")).." ]");
	self.wasloaded = 0;
end
--
function Gamestyler:printNativeVersion()
	local vtext = self.native_version;
	local gtext = tonumber(getglobal("gr_useClassicPlayerDef"));
	local wtext = tonumber(getglobal("gr_useClassicWeaponsParams"));
	if (vtext == "v1.40") then
		if (not gtext) or (gtext==0) then gtext = vtext; elseif (gtext==1) then gtext = "v1.33"; end
		if (not wtext) or (wtext==0) then wtext = vtext; elseif (wtext==1) then wtext = "v1.33"; elseif (wtext==2) then wtext = "v1.33+"; end
	else
		if (not gtext) or (gtext==1) then gtext = vtext; elseif (gtext==0) then gtext = "v1.40"; end
		if (not wtext) or (wtext==1) then wtext = vtext; elseif (wtext==0) then wtext = "v1.40"; end
	end
	if (vtext==gtext) and (gtext==wtext) then
	 vtext = vtext.." (pure)";
	elseif (gtext==wtext) then 
	 vtext = vtext.." ("..gtext.." style)";
	elseif (gtext~=wtext) and (vtext==gtext) then 
	 vtext = vtext.." ("..wtext.." weapons)";
	elseif (gtext~=wtext) and (vtext==wtext) then 
	 vtext = vtext.." ("..gtext.." player)";
	end
	return tostring(vtext);
end
--
function Gamestyler:sayHi(g,w,c)
	if (not g) and (not w) then g = getglobal("gr_ssm_gamestyle"); end
	local gs;
	local gl;
	local p = "NONE";
	if (g) then gs = g; elseif (w) then gs = w; end
	gs=toNumberOrZero(gs);
	if (gs==1) then
		gl = "$3";
		p = "HARDCORE";
	elseif (gs==2) then
		gl = "$4";
		p = "EXTREME";
	elseif (gs==3) then
		gl = "$5";
		p = "STUNT";
	elseif (gs==4) then
		gl = "$7";
		p = "CRAZYCRY";
	elseif (gs==5) then
		gl = "$0";
		p = "CUSTOM";
	elseif (gs==0) then
		gl = "$1";
		p = "PURE";
	end
	if (not c) then c = ""; else c = gl; end
	p = tostring(c..p);
	return p;
end
--
function Gamestyler:defineCustom(g,w)
	if (w) and (not g) then g = getglobal("gr_custom_weaponstyle"); else g = getglobal("gr_custom_gamestyle"); end
	local cfilename = tostring("profiles/server/"..g);
	local cfile = openfile(cfilename, "a");
	if(cfile) then
		XASSM:Logger("Loading CUSTOM gamestyle/weaponstyle vars...");
		--System:LogAlways("*** CFILE EXISTS"); --debug
		local vara;
		local strga;
		local strgb;
		local iEqual;
		local uEqual;
		local lines = ReadTableFromFile(cfilename, 1);
		for i, line in lines do
			--System:LogAlways("*** CFILE FOUND A LINE"); --debug
			if (strlen(line)>0) then
			--if (strlen(line)>0) and strfind(line, "gr_", 1, 4) then
				toktable = tokenize(line);
				toktable[1] = tostring(toktable[1]);
				if strfind(toktable[1], "gr_", 1, 3) then
					vara = toktable[1];
					if toktable[3] then 
						strga = tostring(toktable[3]);
						if (strlen(strga) > 0) then
							iEqual = strfind(strga, '"', 1, 1);
							if (iEqual) then
								strga = strsub(strga, iEqual+1, -1);
								if (strlen(strga) > 0) then
									uEqual = strfind(strga, '"', 1, 1);
									if (uEqual) then
										strga = strsub(strga, 1, uEqual-1);
									end
								end
							end
						end
						if (vara) and (strga) then
							--System:LogAlways("*** VARA: "..vara.." STRGA: "..strga); --debug
							--setglobal('"'..vara..'"',strga);
							System:Log(vara.." = "..'"'..strga..'"'); --debug
							setglobal(tostring(vara),tonumber(strga));
							tremove(toktable, 1);
							tremove(toktable, 1);
							tremove(toktable, 1);
							strgb = untokenize(toktable);
							--System:LogAlways("*** TOKTABLE3: "..tostring(untokenize(toktable))); --debug
						end
					end
				end
			end
		end
		closefile(cfile);
	else
		XASSM:Logger("Custom gamestyle/weaponstyle file does not exist at location: "..cfilename);
	end
end
--
function Gamestyler:doStyle(mtab,mstr)
	if (type(mtab) == "table") and (type(mstr) == "string") then	
		local cnt = 1;
		mstr = tokenize(mstr);
		while mtab[cnt] and mstr[cnt] do
			setglobal(tostring(mtab[cnt]),tonumber(mstr[cnt]));
			System:Log(tostring(mtab[cnt]).." = "..'"'..tonumber(mstr[cnt])..'"'); --debug
			cnt = cnt + 1;
		end
	end
end
--
function Gamestyler:MPsetWeaponSpeedScale(force)
	local spdc = {
		"gr_ag36_speed",
		"gr_falcon_speed",
		"gr_m4_speed",
		"gr_m249_speed",
		"gr_machete_speed",
		"gr_mp5_speed",
		"gr_oicw_speed",
		"gr_p90_speed",
		"gr_rl_speed",
		"gr_shocker_speed",
		"gr_shotgun_speed",
		"gr_sniperrifle_speed",
		"gr_wrench_speed",
	};
	local spdv;
	if (self.native_version ~= "v1.40") or (toNumberOrZero(getglobal("gr_useClassicWeaponsParams"))==2) then
		XASSM:Logger("Loading 1.33 Weapon Speeds...");
		spdv = "1.066 1 0.888 1 1 1.058 1 1.022 1 1 1.066 1.400 1";
	else 
		XASSM:Logger("Loading 1.40 Weapon Speeds...");
		spdv = "1.035 1 1 1.044 1 1 1.072 1 1 1 1 1.200 1";
	end
	self:doStyle(spdc,spdv);
	if (force) and (BasicWeapon) then
		--reload these for proper weapon speeds
		Script:ReloadScript("scripts/default/entities/weapons/AG36.lua");
		Script:ReloadScript("scripts/default/entities/weapons/EngineerTool.lua");
		Script:ReloadScript("scripts/default/entities/weapons/Falcon.lua");
		Script:ReloadScript("scripts/default/entities/weapons/M249.lua");
		Script:ReloadScript("scripts/default/entities/weapons/M4.lua");
		Script:ReloadScript("scripts/default/entities/weapons/Machete.lua");
		Script:ReloadScript("scripts/default/entities/weapons/MP5.lua");
		Script:ReloadScript("scripts/default/entities/weapons/OICW.lua");
		Script:ReloadScript("scripts/default/entities/weapons/P90.lua");
		Script:ReloadScript("scripts/default/entities/weapons/RL.lua");
		Script:ReloadScript("scripts/default/entities/weapons/Rock.lua");
		Script:ReloadScript("scripts/default/entities/weapons/Shocker.lua");
		Script:ReloadScript("scripts/default/entities/weapons/Shotgun.lua");
		Script:ReloadScript("scripts/default/entities/weapons/Sniperrifle.lua");
		Script:ReloadScript("scripts/default/entities/weapons/Wrench.lua");
	end
end
--
function Gamestyler:ApplySSM_gstyle(gs,ws,restart)
	local okprnt = toNumberOrZero(getglobal("gr_checkfirststart"));
	gs = tonumber(gs);
	ws = tonumber(ws);
	if (gs ~= self.curr_gamestyle) then
		local gsc = {
			"gr_runspeed_factor",
			"gr_stamina_use_run",
			"gr_walkspeed_factor",
			"gr_swimspeed_factor",
			"gr_crouchspeed_factor",
			"gr_pronespeed_factor",
			"gr_jumpforce_factor",
			"gr_spawn_health_ffa",
			"gr_spawn_armor_ffa",
			"gr_max_armor_ffa",
			"gr_player_air_control",
			"gr_player_gravity",
			"gr_player_jump_gravity",
			"gr_player_inertia",
			"gr_player_sprint_scale",
			"gr_stamina_use_jump",
			"gr_player_restore_mult",
			"gr_player_fall_scale_mult",
			"gr_minSlideAngle",
			"gr_minFallAngle",
			"gr_maxClimbAngle",
			"gr_maxJumpAngle",
			"gr_boatSpeed",
			"gr_boatTurn",
			"gr_boatTurnDamper",
			"gr_boatTilt",
			"gr_boatMass",
			"gr_boatGravity",
			"gr_boatCollideDamage",
			"gr_boatPushPower",
			"gr_boatEject",
			"gr_boatUprightImpulse",
			"gr_dingySpeed",
			"gr_dingyTurn",
			"gr_dingyTurnDamper",
			"gr_dingyTilt",
			"gr_dingyMass",
			"gr_dingyGravity",
			"gr_dingyCollideDamage",
			"gr_dingyPushPower",
			"gr_buggyWaterDepth",
			"gr_buggyCollideDamage",
			"gr_humveeWaterDepth",
			"gr_humveeCollideDamage",
			"gr_forkliftWaterDepth",
			"gr_bigtrackWaterDepth",
		};
		local gsv;
		if (gs==1) then
			if okprnt>0 then XASSM:Logger("Loading HARDCORE gamestyle..."); end
			gsv = "1.025 0.475 1.025 1.22 0.975 1.05 1.025 130 0 100 0.925 1.015 1.015 1.035 0.975 0.575 1.135 0.785 45 69 56 51 1.825 1.15 0.95 1.25 0.825 0.875 0.85 1.125 1 0.9 1.625 1.15 0.75 1.15 0.975 0.875 0.85 1.125 1.25 0.95 1.25 0.95 1.25 1.25";
			self:doStyle(gsc,gsv);
		elseif (gs==2) then
			if okprnt>0 then XASSM:Logger("Loading EXTREME gamestyle..."); end
			gsv = "1.025 0.425 1.025 1.44 1.1 1.2 1.1 130 10 100 1 0.98 0.95 1.025 1 0.525 1.25 0.35 46 70 57 52 2.325 1.25 0.65 1.85 0.95 0.77 0.65 1.5 1 0.6 2.125 1.5 0.5 1.25 0.95 0.77 0.75 1.25 2 0.75 2 0.75 2 2";
			self:doStyle(gsc,gsv);
		elseif (gs==3) then
			if okprnt>0 then XASSM:Logger("Loading STUNT gamestyle..."); end
			gsv = "1.025 0.325 1.025 2.22 1.2 1.4 1.2 130 25 100 1.09 0.95 0.92 1.015 1.01 0.425 1.5 0.1 66 80 67 62 3.25 1.25 0.75 1.85 0.87 0.42 0.25 2.15 0 0.4 3.45 1.5 0.5 1.25 0.87 0.42 0.25 1.5 16 0.35 16 0.35 16 16";
			self:doStyle(gsc,gsv);
		elseif (gs==4) then
			if okprnt>0 then XASSM:Logger("Loading CRAZYCRY gamestyle..."); end
			gsv = "1.15 0.225 1.15 4.20 1.25 1.35 16 130 50 100 1.66 0.42 0.37 1 1.25 0.325 2.25 0.01 90 90 90 90 3.625 1.25 0.75 1.85 0.77 0.38 0.25 3 0 0.3 3.425 1.5 0.5 1.25 0.77 0.38 0.25 4 255 0.35 255 0.35 255 255";
			self:doStyle(gsc,gsv);
		elseif (gs==5) then
			if okprnt>0 then XASSM:Logger("Loading CUSTOM gameplay settings from '"..tostring(getglobal("gr_custom_gamestyle"))..".txt'"); end
			self:defineCustom(1,nil);
		elseif (gs==0) then
			if okprnt>0 then XASSM:Logger("Loading DEFAULT gamestyle..."); end
			gsv = "1 1 1 1 1 1 1 130 0 100 1 1 1 1 1 1 1 1 46 70 55 50 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1";
			self:doStyle(gsc,gsv);
		else
			if okprnt>0 then XASSM:Logger("No gamestyle selected, using server profile settings..."); end
			gs=nil;
		end
	else
		if okprnt>0 then XASSM:Logger("Gamestyle has not changed, continue..."); end
	end
	self.curr_gamestyle = gs;
	setglobal("gr_ssm_gamestyle",gs);
	if (ws) then 
		local wkit;
		if toNumberOrZero(restart)~=0 then wkit = restart; restart=restart+1; end 
		self:ApplySSM_wstyle(ws,wkit,restart); 
	end
	self.wasloaded = 0;
end
--
function Gamestyler:ApplySSM_wstyle(ws,wkit,restart)
	local okprnt = toNumberOrZero(getglobal("gr_checkfirststart"));
	ws = tonumber(ws);
	wkit = toNumberOrZero(wkit);
	if (ws ~= self.curr_weaponstyle) then
		local wsc = {
			"gr_DamageScale",
			"gr_HeadshotMultiplier",
			"gr_rocketSpeedMP",
			"gr_rocketDamageMP",
			"gr_vehicleRocketSpeed",
			"gr_vehicleRocketDamage",
			"gr_ag36_nade_damage_factor",
			"gr_oicw_nade_damage_factor",
			"gr_rocket_damage_factor",
			"gr_hand_grenade_damage_factor",
			"gr_flash_bang_grenade_stun_factor",
			"gr_shocker_damage_factor",
			"gr_wrench_damage_factor",
			"gr_machete_damage_factor",
			"gr_pistol_damage_factor",
			"gr_mp5_damage_factor",
			"gr_p90_damage_factor",
			"gr_m4_damage_factor",
			"gr_ag36_damage_factor",
			"gr_oicw_damage_factor",
			"gr_m249_damage_factor",
			"gr_shotgun_damage_factor",
			"gr_sniper_damage_factor",
			"gr_realVehixDamage",
			"gr_vehixScaleExplosion",
			"gr_boatMGammo",
			"gr_boatRLammo",
			"gr_boatBulletDamage",
			"gr_dingyBulletDamage",
			"gr_buggyMGammo",
			"gr_buggyBulletDamage",
			"gr_humveeMGammo",
			"gr_humveeRLammo",
			"gr_humveeBulletDamage",
			"gr_ag36_speed",
			"gr_falcon_speed",
			"gr_m4_speed",
			"gr_m249_speed",
			"gr_machete_speed",
			"gr_mp5_speed",
			"gr_oicw_speed",
			"gr_p90_speed",
			"gr_rl_speed",
			"gr_shocker_speed",
			"gr_shotgun_speed",
			"gr_sniperrifle_speed",
			"gr_wrench_speed",
		};
		local wsv;
		if (ws==1) then
			if okprnt>0 then XASSM:Logger ("Loading HARDCORE weaponstyle..."); end
			wsv = "1 2 1 1 1 1 1 1 1 0.9 0.5 1.020 1.005 1.010 1.020 1.040 1.060 0.950 1.005 1.015 1.070 0.930 1 1 0.85 300 5 0.75 0.95 300 0.8 500 10 0.7 1.033 1 0.922 1.166 1 1.018 1.088 1.008 1 1 1.018 1.222 1";
			self:doStyle(wsc,wsv);
		elseif (ws==2) then
			if okprnt>0 then XASSM:Logger ("Loading EXTREME weaponstyle..."); end
			wsv = "1 2 1.85 0.8 1.85 0.8 1 1 0.8 1 0.5 1.015 1.005 1 1 1.030 1.050 0.960 1 1.005 1.060 0.940 1 1 0.65 300 10 0.7 0.9 300 0.75 500 20 0.65 1.033 1 0.922 1.166 1 1.018 1.088 1.008 1 1 1.018 1.222 1";
			self:doStyle(wsc,wsv);
		elseif (ws==3) then
			if okprnt>0 then XASSM:Logger("Loading STUNT weaponstyle..."); end
			wsv = "1 2 2.25 0.65 2.25 0.65 1 1 0.75 1 0.5 1.015 1.005 1 1 1.030 1.050 0.960 1 1.005 1.060 0.940 0.9 1 0.45 500 20 0.65 0.85 500 0.7 700 30 0.6 1.033 1 0.922 1.166 1.1 1.018 1.088 1.008 1 1.1 1.018 1.222 1.1";
			self:doStyle(wsc,wsv);
		elseif (ws==4) then
			if okprnt>0 then XASSM:Logger("Loading CRAZYCRY weaponstyle..."); end
			wsv = "0.75 1.50 2.25 0.65 2.25 0.65 1.1 1.1 0.85 1.1 0.5 1.115 1.105 1.1 1.1 1.130 1.150 1.040 1.1 1.105 1.060 1.060 1.1 1 0.35 666 99 0.75 0.85 666 0.7 666 99 0.6 1.083 1.05 0.972 1.216 1.3 1.068 1.138 1.058 1.05 1.3 1.068 1.333 1.3";
			self:doStyle(wsc,wsv);
		elseif (ws==5) then
			if okprnt>0 then XASSM:Logger("Loading CUSTOM weapon settings from '"..tostring(getglobal("gr_custom_weaponstyle"))..".txt'"); end
			self:defineCustom(nil,1);
		elseif (ws==0) then
			wsc = {
				"gr_DamageScale",
				"gr_HeadshotMultiplier",
				"gr_rocketSpeedMP",
				"gr_rocketDamageMP",
				"gr_vehicleRocketSpeed",
				"gr_vehicleRocketDamage",
				"gr_ag36_nade_damage_factor",
				"gr_oicw_nade_damage_factor",
				"gr_rocket_damage_factor",
				"gr_hand_grenade_damage_factor",
				"gr_flash_bang_grenade_stun_factor",
				"gr_shocker_damage_factor",
				"gr_wrench_damage_factor",
				"gr_machete_damage_factor",
				"gr_pistol_damage_factor",
				"gr_mp5_damage_factor",
				"gr_p90_damage_factor",
				"gr_m4_damage_factor",
				"gr_ag36_damage_factor",
				"gr_oicw_damage_factor",
				"gr_m249_damage_factor",
				"gr_shotgun_damage_factor",
				"gr_sniper_damage_factor",
				"gr_realVehixDamage",
				"gr_vehixScaleExplosion",
				"gr_boatMGammo",
				"gr_boatRLammo",
				"gr_boatBulletDamage",
				"gr_dingyBulletDamage",
				"gr_buggyMGammo",
				"gr_buggyBulletDamage",
				"gr_humveeMGammo",
				"gr_humveeRLammo",
				"gr_humveeBulletDamage",
			};
			if okprnt>0 then XASSM:Logger("Loading DEFAULT weaponstyle..."); end
			wsv = "1 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 300 30 1 1 200 1 500 30 1";
			self:doStyle(wsc,wsv);
			self:MPsetWeaponSpeedScale(); --pure patch weapon speeds
		else
			if okprnt>0 then XASSM:Logger("No gamestyle selected, using server profile settings..."); end
			ws=nil;
		end
	else
		XASSM:Logger("Weaponstyle has not changed, continue...");
	end
	if (wkit~=0) then self:xa_kit(getglobal("gr_norl"),getglobal("gr_novr"),getglobal("gr_nogl"),getglobal("gr_nosr"),restart); end
	self.curr_weaponstyle = ws;
	setglobal("gr_ssm_weaponstyle",ws);
	self.wasloaded = 0;
end
--
function Gamestyler:xa_gs(gs,ws,restart)
	if (not gs) then gs = toNumberOrZero(getglobal("gr_ssm_gamestyle")); end
	if (not ws) then ws = toNumberOrZero(getglobal("gr_ssm_weaponstyle")); end
	if (restart) and (restart~=0) then Server:BroadcastText(tostring(getglobal("gr_server_tag"))..tostring(getglobal("gr_tc2")).."Loading Gamestyle: "..tostring(getglobal("gr_tc3"))..self:sayHi(toNumberOrZero(gs),nil,1)..tostring(getglobal("gr_tc2")).." Loading Weaponstyle: "..tostring(getglobal("gr_tc3"))..self:sayHi(nil,toNumberOrZero(ws),1),3); end
	--XASSM:Logger("Requesting Gamestyle: ["..toNumberOrZero(gs).."] Weaponstyle: ["..toNumberOrZero(ws).."]...");
	self:ApplySSM_gstyle(gs,ws,restart);
end
--
function Gamestyler:xa_ex(ws,rl,vr,gl,sr,restart)
	local wkit;
	if (not ws) then ws = toNumberOrZero(getglobal("gr_ssm_weaponstyle")); end
	if (restart) and (restart~=0) then Server:BroadcastText(tostring(getglobal("gr_server_tag"))..tostring(getglobal("gr_tc2")).."Loading Weaponstyle: "..tostring(getglobal("gr_tc3"))..self:sayHi(nil,toNumberOrZero(ws)),3); end
	--XASSM:Logger("Requesting Weaponstyle: ["..toNumberOrZero(ws).."]...");
	if (rl) then setglobal("gr_norl",rl); wkit = 1; end
	if (vr) then setglobal("gr_novr",vr); wkit = 1; end
	if (gl) then setglobal("gr_nogl",gl); wkit = 1; end
	if (sr) then setglobal("gr_nosr",sr); wkit = 1; end
	self:ApplySSM_wstyle(ws,wkit,restart);
end
--
function Gamestyler:xa_classic(ptype,wtype,restart)
	if tonumber(ptype) >= 1 then
		setglobal("gr_useClassicPlayerDef",1);
		if (restart) and (restart~=0) then Server:BroadcastText(tostring(getglobal("gr_server_tag"))..tostring(getglobal("gr_tc2")).."Loading Classic Weapons Params ("..tostring(getglobal("gr_tc1")).."v1.33 style"..tostring(getglobal("gr_tc2"))..")",3); end
	else
		setglobal("gr_useClassicPlayerDef",0);
		if (restart) and (restart~=0) then Server:BroadcastText(tostring(getglobal("gr_server_tag"))..tostring(getglobal("gr_tc2")).."Loading Modern Weapons Params ("..tostring(getglobal("gr_tc1")).."v1.40 style"..tostring(getglobal("gr_tc2"))..")",3); end
	end
	if tonumber(wtype) == 1 then
		setglobal("gr_useClassicWeaponsParams",1);
		if (restart) and (restart~=0) then Server:BroadcastText(tostring(getglobal("gr_server_tag"))..tostring(getglobal("gr_tc2")).."Loading Classic Weapons Params ("..tostring(getglobal("gr_tc1")).."v1.33 style"..tostring(getglobal("gr_tc2"))..")",3); end
	elseif tonumber(wtype) >= 2 then
		setglobal("gr_useClassicWeaponsParams",2);
		if (restart) and (restart~=0) then Server:BroadcastText(tostring(getglobal("gr_server_tag"))..tostring(getglobal("gr_tc2")).."Loading Classic Weapons Params ("..tostring(getglobal("gr_tc1")).."v1.33 style + Weapon Speeds"..tostring(getglobal("gr_tc2"))..")",3); end
	else
		setglobal("gr_useClassicWeaponsParams",0);
		if (restart) and (restart~=0) then Server:BroadcastText(tostring(getglobal("gr_server_tag"))..tostring(getglobal("gr_tc2")).."Loading Modern Weapons Params ("..tostring(getglobal("gr_tc1")).."v1.40 style"..tostring(getglobal("gr_tc2"))..")",3); end
	end
	self:xa_gs(nil,nil,restart);
end
--
function Gamestyler:record_kits(force)
	--if (Game:IsMultiplayer()) then --make sure this doesnt run too early
		if (not self.curr_rl) or (force==1) then
			self.curr_rl = {
				getglobal("gr_norl"),
				getglobal("gr_rockets_per_clip"),
				getglobal("gr_max_rockets_ffa"),
				getglobal("gr_initial_rockets"),
				getglobal("gr_pickup_rockets"),
				getglobal("gr_droppickup_rockets"),
				getglobal("gr_max_rockets"),
			};
		end
		if (not self.curr_vr) or (force==1) then
			self.curr_vr = {
				getglobal("gr_novr"),
				getglobal("gr_humveeRLammo"),
				getglobal("gr_boatRLammo"),
			};
		end
		if (not self.curr_gl) or (force==1) then
			self.curr_gl = {
				getglobal("gr_nogl"),
				getglobal("gr_ag36_nades_per_clip"),
				getglobal("gr_oicw_nades_per_clip"),
				getglobal("gr_max_ag36_nades_ffa"),
				getglobal("gr_max_oicw_nades_ffa"),
				getglobal("gr_initial_ag36_nades"),
				getglobal("gr_pickup_ag36_nades"),
				getglobal("gr_droppickup_ag36_nades"),
				getglobal("gr_max_ag36_nades"),
				getglobal("gr_initial_oicw_nades"),
				getglobal("gr_pickup_oicw_nades"),
				getglobal("gr_droppickup_oicw_nades"),
				getglobal("gr_max_oicw_nades"),
			};
		end
		if (not self.curr_sr) or (force==1) then
			self.curr_sr = {
				getglobal("gr_nosr"),
				getglobal("gr_sniper_ammo_per_clip"),
				getglobal("gr_max_sniper_ammo_ffa"),
				getglobal("gr_initial_sniper_ammo"),
				getglobal("gr_pickup_sniper_ammo"),
				getglobal("gr_droppickup_sniper_ammo"),
				getglobal("gr_max_sniper_ammo"),
			};
		end
	--end
end
--
function Gamestyler:xa_kit(nor,nov,nog,nos,restart)
	local okprnt = toNumberOrZero(getglobal("gr_checkfirststart"));
	self:record_kits();
	--Rocketlaunchers
	if (not nor) then nor = getglobal("gr_norl"); end
	nor = toNumberOrZero(nor);
	 if nor~=self.curr_rl[1] then
		if nor>=1 then
			self.curr_rl[1] = 1;
			setglobal("gr_rockets_per_clip",0);
			setglobal("gr_max_rockets_ffa",0);
			setglobal("gr_initial_rockets",0);
			setglobal("gr_pickup_rockets",0);
			setglobal("gr_droppickup_rockets",0);
			setglobal("gr_max_rockets",0);
			if (restart) and (restart~=0) then Server:BroadcastText(tostring(getglobal("gr_server_tag"))..tostring(getglobal("gr_tc2")).."ROCKET LAUNCHERS are Disabled",3); end
			if okprnt>0 then XASSM:Logger("ROCKETS are Disabled"); end
		else
			setglobal("gr_rockets_per_clip",self.curr_rl[2]);
			setglobal("gr_max_rockets_ffa",self.curr_rl[3]);
			setglobal("gr_initial_rockets",self.curr_rl[4]);
			setglobal("gr_pickup_rockets",self.curr_rl[5]);
			setglobal("gr_droppickup_rockets",self.curr_rl[6]);
			setglobal("gr_max_rockets",self.curr_rl[7]);
			self.curr_rl[1] = 0;
			if (restart) and (restart~=0) then Server:BroadcastText(tostring(getglobal("gr_server_tag"))..tostring(getglobal("gr_tc2")).."ROCKET LAUNCHERS are Enabled",3); end
			if okprnt>0 then XASSM:Logger("ROCKET LAUNCHERS are Enabled"); end
		end
	end
	setglobal("gr_norl",self.curr_rl[1]);
	--VehicleRockets
	if (not nov) then nov = getglobal("gr_novr"); end
	nov = toNumberOrZero(nov);
	 if nov~=self.curr_vr[1] then
		if nov>=1 then
			self.curr_vr[1] = 1;
			setglobal("gr_humveeRLammo",0);
			setglobal("gr_boatRLammo",0);
			if (restart) and (restart~=0) then Server:BroadcastText(tostring(getglobal("gr_server_tag"))..tostring(getglobal("gr_tc2")).."VEHICLE ROCKETS are Disabled",3); end
			if okprnt>0 then XASSM:Logger("VEHICLE ROCKETS are Disabled"); end
		else
			setglobal("gr_humveeRLammo",self.curr_vr[2]);
			setglobal("gr_boatRLammo",self.curr_vr[3]);
			self.curr_vr[1] = 0;
			if (restart) and (restart~=0) then Server:BroadcastText(tostring(getglobal("gr_server_tag"))..tostring(getglobal("gr_tc2")).."VEHICLE ROCKETS are Enabled",3); end
			if okprnt>0 then XASSM:Logger("VEHICLE ROCKETS are Enabled"); end
		end
	end
	setglobal("gr_novr",self.curr_vr[1]);
	--GrenadeLaunchers
	if (not nog) then nog=getglobal("gr_nogl"); end
	nog = toNumberOrZero(nog);
	if nog~=self.curr_gl[1] then
		if nog>=1 then
			self.curr_gl[1] = 1;
			setglobal("gr_ag36_nades_per_clip",0);
			setglobal("gr_oicw_nades_per_clip",0);
			setglobal("gr_max_ag36_nades_ffa",0);
			setglobal("gr_max_oicw_nades_ffa",0);
			setglobal("gr_initial_ag36_nades",0);
			setglobal("gr_pickup_ag36_nades",0);
			setglobal("gr_droppickup_ag36_nades",0);
			setglobal("gr_max_ag36_nades",0);
			setglobal("gr_initial_oicw_nades",0);
			setglobal("gr_pickup_oicw_nades",0);
			setglobal("gr_droppickup_oicw_nades",0);
			setglobal("gr_max_oicw_nades",0);
			if (restart) and (restart~=0) then Server:BroadcastText(tostring(getglobal("gr_server_tag"))..tostring(getglobal("gr_tc2")).."GRENADE LAUNCHERS are Disabled",3); end
			if okprnt>0 then XASSM:Logger("GRENADE LAUNCHERS are Disabled"); end
		else
			setglobal("gr_ag36_nades_per_clip",self.curr_gl[2]);
			setglobal("gr_oicw_nades_per_clip",self.curr_gl[3]);
			setglobal("gr_max_ag36_nades_ffa",self.curr_gl[4]);
			setglobal("gr_max_oicw_nades_ffa",self.curr_gl[5]);
			setglobal("gr_initial_ag36_nades",self.curr_gl[6]);
			setglobal("gr_pickup_ag36_nades",self.curr_gl[7]);
			setglobal("gr_droppickup_ag36_nades",self.curr_gl[8]);
			setglobal("gr_max_ag36_nades",self.curr_gl[9]);
			setglobal("gr_initial_oicw_nades",self.curr_gl[10]);
			setglobal("gr_pickup_oicw_nades",self.curr_gl[11]);
			setglobal("gr_droppickup_oicw_nades",self.curr_gl[12]);
			setglobal("gr_max_oicw_nades",self.curr_gl[13]);
			self.curr_gl[1] = 0;
			if (restart) and (restart~=0) then Server:BroadcastText(tostring(getglobal("gr_server_tag"))..tostring(getglobal("gr_tc2")).."GRENADE LAUNCHERS are Enabled",3); end
			if okprnt>0 then XASSM:Logger("GRENADE LAUNCHERS are Enabled"); end
		end
	end
	setglobal("gr_nogl",self.curr_gl[1]);
	--SniperRifle
	if (not nos) then nos=getglobal("gr_nosr"); end
	nos = toNumberOrZero(nos);
	if nos~=self.curr_sr[1] then
		if  nos>=1  then
			self.curr_sr[1] = 1;
			setglobal("gr_sniper_ammo_per_clip",0);
			setglobal("gr_max_sniper_ammo_ffa",0);
			setglobal("gr_initial_sniper_ammo",0);
			setglobal("gr_pickup_sniper_ammo",0);
			setglobal("gr_droppickup_sniper_ammo",0);
			setglobal("gr_max_sniper_ammo",0);
			if (restart) and (restart~=0) then Server:BroadcastText(tostring(getglobal("gr_server_tag"))..tostring(getglobal("gr_tc2")).."SNIPER RIFLES are Disabled",3); end
			if okprnt>0 then XASSM:Logger("SNIPER RIFLES are Disabled"); end
		else
			setglobal("gr_sniper_ammo_per_clip",self.curr_sr[2]);
			setglobal("gr_max_sniper_ammo_ffa",self.curr_sr[3]);
			setglobal("gr_initial_sniper_ammo",self.curr_sr[4]);
			setglobal("gr_pickup_sniper_ammo",self.curr_sr[5]);
			setglobal("gr_droppickup_sniper_ammo",self.curr_sr[6]);
			setglobal("gr_max_sniper_ammo",self.curr_sr[7]);
			self.curr_sr[1] = 0;
			if (restart) and (restart~=0) then Server:BroadcastText(tostring(getglobal("gr_server_tag"))..tostring(getglobal("gr_tc2")).."SNIPER RIFLES are Enabled",3); end
			if okprnt>0 then XASSM:Logger("SNIPER RIFLES are Enabled"); end
		end
	end
	setglobal("gr_nosr",self.curr_sr[1]);
	--
	restart = toNumberOrZero(restart);
	if (XASSM) and (restart) and (restart~=0) then
		XASSM:RestartMap();
		self.wasloaded = 1;
		if (toNumberOrZero(restart)>1) then
			Script:ReloadScript("scripts/default/entities/vehicles/bigtrack.lua");
			Script:ReloadScript("scripts/default/entities/vehicles/forklift.lua");
			Script:ReloadScript("scripts/default/entities/vehicles/inflatableboat.lua");
			Script:ReloadScript("scripts/multiplayer/MultiplayerClassDefiniton.lua");
		end
		Script:ReloadScript("scripts/default/entities/weapons/WeaponsParams.lua");
		Script:ReloadScript("scripts/default/entities/vehicles/fwdvehicle.lua");
		Script:ReloadScript("scripts/default/entities/vehicles/boat.lua");
		Script:ReloadScript("scripts/default/entities/vehicles/buggy.lua");
		Script:ReloadScript("scripts/default/entities/weapons/flashbanggrenade.lua");
		Script:ReloadScript("scripts/default/entities/weapons/handgrenade.lua");
		Script:ReloadScript("scripts/default/entities/weapons/vehiclerocket.lua");
		Script:ReloadScript("scripts/default/entities/weapons/OICWgrenade.lua");
		Script:ReloadScript("scripts/default/entities/weapons/Rocket.lua");
		Script:ReloadScript("scripts/default/entities/weapons/AG36Grenade.lua");
	end
	self.wasloaded = 0;
end
--
function purePatch()
	return tostring(Gamestyler.native_version);
end