-- Survival mode HUD 2.7
	
Script:LoadScript("scripts/GUI/HudCommon.lua");
Script:LoadScript("scripts/GUI/HudMultiplayer.lua");
Hud.buysign_top = 600;
Hud.PlayerObjectiveAnimTex = System:LoadImage("textures/hud/multiplayer/defender_Logo");
Hud.sio_alarm = Sound:LoadSound("Sounds/objectimpact/metal_girder.wav");
Hud.sio_restore = Sound:LoadSound("Sounds/objectimpact/hardcoverbook.wav");
Hud.su_villagerdown = Sound:LoadSound("Sounds/MENU/dong.wav");
Hud.su_prevmoney = 0;
Hud.su_villagerfollow = {
soundFile = "languages/voicepacks/voiceB/vehicle_in_2_VoiceB.wav",
Volume = 200,
min = 3,
max = 40,
};

Hud.su_villagerstay = {
soundFile = "Languages/voicepacks/voiceA/helicopter_sight_2_VoiceA.wav",
Volume = 200,
min = 3,
max = 40,
};

Hud.su_traderbuy = {
soundFile = "Sounds/Weapons/OICW/oicwG_48.wav",
Volume = 200,
min = 3,
max = 40,
};

Hud.radiomsg={
	{
	soundFile = "languages/voicepacks/voiceB/vehicle_in_1_VoiceB.wav",
	Volume = 200,
	min = 3,
	max = 40,
	txt = "@cis_qv_followme",
	},
	{
	soundFile = "languages/voicepacks/voiceB/searching_generic_3_VoiceB.wav",
	Volume = 200,
	min = 3,
	max = 40,
	txt = "@cis_qv_holdpos",
	},
	{
	soundFile = "languages/voicepacks/voiceB/reinforce_talk_to_4_VoiceB.wav",
	Volume = 200,
	min = 3,
	max = 40,
	txt = "@cis_qv_underattack",
	},
	{
	soundFile = "languages/voicepacks/voiceB/reinforce_talk_to_5_VoiceB.wav",
	Volume = 200,
	min = 3,
	max = 40,
	txt = "@cis_qv_needbackup",
	},
	{
	soundFile = "Languages/voicepacks/voiceB/affirmative_1_VoiceB.wav",
	Volume = 200,
	min = 3,
	max = 40,
	txt = "@cis_qv_affirmative",
	},
	{
	soundFile = "Languages/voicepacks/voiceB/combat_to_alert_alone_5_VoiceB.wav",
	Volume = 200,
	min = 3,
	max = 40,
	txt = "@cis_qv_comeon",
	},
	{
	soundFile = "languages/voicepacks/voiceB/comm_suppress_6_VoiceB.wav",
	Volume = 200,
	min = 3,
	max = 40,
	txt = "@cis_qv_coverme",
	},
	{
	soundFile = "Languages/voicepacks/voiceA/combat_to_alert_group_3_VoiceA.wav",
	Volume = 200,
	min = 3,
	max = 40,
	txt = "@cis_qv_goobj",
	},
	{
	soundFile = "languages/voicepacks/voiceA/searching_Mutants_3_VoiceA.wav",
	Volume = 200,
	min = 3,
	max = 40,
	txt = "@cis_qv_susecure",
	},
	{
	soundFile = "languages/voicepacks/voiceB/comm_retreat_1_VoiceB.wav",
	Volume = 200,
	min = 3,
	max = 40,
	txt = "@cis_qv_pullback",
	},
};

Hud.PlayerObjective=nil;

function Hud:OnInit()
	self:CommonInit();	
	Language:LoadStringTable("MultiplayerHUD.xml");
	Hud.s_sio_r = Game:CreateRenderer();
	Hud.s_sio_i = {
	{129,65,62,62},
	{193,1,62,62},
	{129,1,62,62},
	{65,1,62,62},
	{1,1,62,62},
	{64,65,62,62},
	};
	self:InitTexTableMP(Hud.s_sio_i);
end

function Hud:DrawSIOstatus(x,y,status,r,g,b,a)
	self.s_sio_r:PushQuad(x,y,status.size.w*0.66*Hud.hd_sc_mult,status.size.h*0.66,status,r,g,b,a);
	self.s_sio_r:Draw(self.tx_multiplayerhud);
	if (Hud.sio_objectives) then
		if (Hud.sio_objectives[2]) then
			if (Hud.sio_order==nil) or (Hud.sio_order > 2) then
				Hud.sio_order = 1;
			end
			Hud.radarObjective=Hud.sio_objectives[Hud.sio_order];
			Hud.sio_order = Hud.sio_order + 1;

		else
			Hud.radarObjective=Hud.sio_objectives[1];
		end
	end
end

function Hud:OnUpdate()
	local player=_localplayer;
	local timestff = {x = 45+self.hdadjusty*2,y = 574+self.hdadjusty*0.8};
	if (player) then
		%System:DrawImageColor(self.PlayerObjectiveAnimTex, 732+Hud.hdadjust*0.18, 7, 52*Hud.hd_sc_mult, 52, 4, 0.4, 0.6, 0.9, 1);
		if (player.cnt) and (player.cnt.score) then
			local my_money = player.cnt.score * 12; -- USD
			if (my_money < 0) then my_money = 0; end
			if Hud.su_prevmoney ~= my_money then
				local csh_diff = my_money - Hud.su_prevmoney;
				if (csh_diff == 204) then -- sio fix award
					Sound:PlaySound(ClientStuff.sio_fixed);
					Hud:AddMessage("$1 "..csh_diff.." $$");
				elseif (csh_diff < 0) then -- buy or penalty
					Hud:AddMessage("$3 "..csh_diff.." $$");
				end
				Hud.su_prevmoney = my_money;
			end
			my_money = "$$ "..my_money;
			%System:DrawImageColor(Hud.white_dot, 358, 576, 90, 19, 4, 0, 0, 0, 0.6);
			local nsx,nsy = %Game:GetHudStringSize(my_money, 15, 15);
			nsx = 400-nsx*0.5;
			Game:SetHUDFont("radiosta", "binozoom");
			%Game:WriteHudString(nsx,576,my_money, 0, 1.0, 0.5, 0.5, 15, 15);
		end
		%Game:SetHUDFont("hud", "ammo");
		
		if (Hud.vill_count) then
			%Game:WriteHudString( 752+Hud.hdadjusty*0.8, 15, Hud.vill_count, 1, 1, 1, 1, 33, 33);
		end
		if (Hud.sio1_status) and (Hud.sio1_status~=0) then
			self:DrawSIOstatus(18,15,Hud.s_sio_i[Hud.sio1_status],1,1,1,1);
		end
		if (Hud.sio2_status) and (Hud.sio2_status~=0) then
			self:DrawSIOstatus(18,62,Hud.s_sio_i[Hud.sio2_status],1,1,1,1);
		end
		if (Hud.su_msgs) then
		if (Hud.su_win_msg) then
			local n_sx,n_sy = %Game:GetHudStringSize("@su_youwin", 36, 36);
			Game:WriteHudString( 400-n_sx*0.5, 500, "@su_youwin", 0.6, 1, 0.6, 1, 36, 36);
			if (Hud.su_win_msg < _time) then
				Hud.su_win_msg = nil;
				Hud.su_msgs = nil;
			end
		elseif (Hud.su_lose_msg) then
			local n_sx,n_sy = %Game:GetHudStringSize("@su_youlose", 36, 36);
			Game:WriteHudString( 400-n_sx*0.5, 500, "@su_youlose", 0.6, 1, 0.6, 1, 36, 36);
			if (Hud.su_lose_msg < _time) then
				Hud.su_lose_msg = nil;
				Hud.su_msgs = nil;
			end
		elseif (Hud.su_vdown_msg) then
			local n_sx,n_sy = %Game:GetHudStringSize("@su_villdown", 36, 36);
			Game:WriteHudString( 400-n_sx*0.5, 500, "@su_villdown", 0.6, 1, 0.6, 1, 36, 36);
			if (Hud.su_vdown_msg < _time) then
				Hud.su_vdown_msg = nil;
				Hud.su_msgs = nil;
			end
		elseif (Hud.su_objatt_msg) then
			local n_sx,n_sy = %Game:GetHudStringSize("@su_obj_att", 30, 30);
			Game:WriteHudString( 400-n_sx*0.5, 500, "@su_obj_att", 0.6, 1, 0.6, 1, 30, 30);
			if (Hud.su_objatt_msg < _time) then
				Hud.su_objatt_msg = nil;
				Hud.su_msgs = nil;
			end
		elseif (Hud.su_briefing_def) then
			-- Mixer: moved to scoreboard.lua - show goals feature added
			if (Hud.su_briefing_def < _time) then
				Hud.su_briefing_def = nil;
				Hud.su_msgs = nil;
			end
		end
		end
		if (player.entity_type ~= "spectator") then -- PLAYER
			ClientStuff.vlayers:DrawOverlay();
			if (not ClientStuff.vlayers:IsActive("SmokeBlur") and not ClientStuff.vlayers:IsFading("SmokeBlur")) then							
				-- check damage/hits...
				if(self.hitdamagecounter>0) then
					-- [tiago] testing blury/bloody screen fx
					System:SetScreenFx("ScreenBlur", 1);							
					self.hitdamagecounter=self.hitdamagecounter - _frametime*3.5;
					System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurAmount", self.hitdamagecounter/10.0);
				else
					System:SetScreenFx("ScreenBlur", 0);
					self.hitdamagecounter=0;
				end
			end

			if (cl_display_hud == "0" or self.bHide) then
				return
			end
				
			if (Hud.cis_mpopt) then
				-- let's check if there is a TRADER nearby:
				--local nearnpcs = {};

				if (Hud.cis_mpopt == 0) then
					if (_localplayer.theVehicle==nil) then
						Input:SetActionMap("default");
					end
					Hud.cis_mpopt = nil;
					Hud.npcdialogtimer = nil;
				else
					if (Hud.cis_mpopt ~= 3) then
						Hud.cis_mpopt = 1;
					end
					if (Hud.cis_specop) then -- cis_specop means trader is nearby
						Hud.cis_mpopt = 2;
					end
					if (Hud.cis_mpopt == 2) then
						Hud.cis_mpopt = 3;
						Hud.cis_known_buy = 1;
						Input:SetActionMap("vehicle");
						%System:DrawImageColor(Hud.white_dot, 600, 140, 180, 430, 4,0.1,0.1,0.2,0.8);
						%System:DrawImageColor(Hud.white_dot, 603, 143, 174, 25, 4, 0, 0, 0, 0.6);
						local n_sx,n_sy = %Game:GetHudStringSize("@cis_su_buyhint", 20, 20);
						%Game:WriteHudString(400-n_sx*0.5,10,"@cis_su_buyhint", 1, 1, 1, 1, 20,20);
						Game:WriteHudString(610,145,"@cis_estore", 1, 1, 1, 1, 22, 22);
						local store_str = "";
						if (Mission) and (Mission[Hud.trdname]) then
							local e_store_item = 1;
							while Mission[Hud.trdname][e_store_item] do
								store_str = store_str..e_store_item..". "..Mission[Hud.trdname][e_store_item][1];
								local buycode = Mission[Hud.trdname][e_store_item][2];
								local e_storetmp = 0;
								if (WeaponClassesEx[buycode]) then
									e_storetmp = ceil(tonumber(WeaponClassesEx[buycode].price)/12)*12;
								elseif (buycode == "Armor") then
									e_storetmp = ceil(tonumber(WeaponClassesEx.Hands.armorprice)/12)*12;
								elseif (MaxAmmo[buycode]) and (WeaponClassesEx.Hands[buycode]) then
									e_storetmp = ceil(tonumber(WeaponClassesEx.Hands[buycode][1])/12)*12;
								end
								store_str = store_str.." - $$"..e_storetmp.." \n";
								e_store_item = e_store_item + 1;
							end
						else
							Hud:AddMessage("Store contents were not specified in Mission script!");
							Hud.cis_mpopt = 0;
							return;
						end

						%Game:WriteHudString(616,170,store_str, 0.8, 0.8, 0.3, 1, 15,15);
						if (Hud.cis_lastkey) then
							local np_token = strfind(Hud.cis_lastkey,"numpad");
							if (np_token) then
								Hud.cis_lastkey = strsub(Hud.cis_lastkey,7);
							end
							if (Game.cis_SpOptionKey) and (Game.cis_SpOptionKey==Hud.cis_lastkey) and (not Hud.cis_SkipSpOption) then
								Hud.cis_lastkey = "";
								Hud.cis_SkipSpOption = 1;
							else
								store_str = tonumber(Hud.cis_lastkey);
								if (store_str) and (Mission[Hud.trdname][store_str]) then
									Hud.cis_SkipSpOption = nil;
									local wpncode = "";
									if (player.fireparams) and (Hud.cis_lastwpn) then
										wpncode = " "..Hud.cis_lastwpn;
									end
									-- Cheat-protected now :)
									Client:SendCommand('BUY '..Mission[Hud.trdname][store_str][2]..wpncode);
									Hud.cis_mpopt = 0;
								end
							end
						end
					elseif (Hud.cis_mpopt == 1) then
						Input:SetActionMap("vehicle");
						%System:DrawImageColor(Hud.white_dot, 600, 140, 180, 430, 4,0.1,0.1,0.2,0.8);
						%System:DrawImageColor(Hud.white_dot, 603, 143, 174, 25, 4, 0, 0, 0, 0.6);
						Game:WriteHudString(610,145,"@cis_teamtalk", 1, 1, 1, 1, 22, 22);
						if (Hud.radiomsg) and (Hud.radiomsg[1]) then
							local bp_txt = "";
							local np_token = 1;
							while Hud.radiomsg[np_token] do
								if (Hud.radiomsg[np_token].txt) then
									if (np_token < 10) then
										bp_txt = bp_txt..np_token..". "..Hud.radiomsg[np_token].txt.." \n";
									else
										bp_txt = bp_txt.."0. "..Hud.radiomsg[np_token].txt.." \n";
									end
								end
								np_token = np_token + 1;
							end
							bp_txt = bp_txt.."---\nP. @Gest_InPos \n";
							bp_txt = bp_txt.."K. @Gest_Wait \n";
							bp_txt = bp_txt.."L. @Gest_LeftAdv \n";
							bp_txt = bp_txt.."M. @Gest_Stick \n";

							%Game:WriteHudString(616,170,bp_txt, 0.8, 0.8, 0.3, 1, 15,15);
							if (Hud.cis_lastkey) then
								np_token = strfind(Hud.cis_lastkey,"numpad");
								if (np_token) then
									Hud.cis_lastkey = strsub(Hud.cis_lastkey,7);
								end
								---- gestures
								if (Hud.cis_lastkey=="p") then
									Hud.cis_lastkey = "91";
								elseif (Hud.cis_lastkey=="k") then
									Hud.cis_lastkey = "92";
								elseif (Hud.cis_lastkey=="l") then
									Hud.cis_lastkey = "93";
								elseif (Hud.cis_lastkey=="m") then
									Hud.cis_lastkey = "94";
								end
								----
								if (Game.cis_SpOptionKey) and (Game.cis_SpOptionKey==Hud.cis_lastkey) and (not Hud.cis_SkipSpOption) then
									Hud.cis_lastkey = "";
									Hud.cis_SkipSpOption = 1;
								else
									bp_txt = tonumber(Hud.cis_lastkey);
									if (bp_txt) and (bp_txt == 0) then
										bp_txt = 10;
									end
									if (bp_txt) and (Hud.radiomsg[bp_txt]) and (Hud.radiomsg[bp_txt].txt) then
										Client:SendCommand("VB_GV "..bp_txt);
										Hud.cis_SkipSpOption = nil;
										Hud.cis_mpopt = 0;
									elseif (bp_txt) and (bp_txt > 90) then
										Client:SendCommand("VB_GV "..bp_txt);
										Hud.cis_SkipSpOption = nil;
										Hud.cis_mpopt = 0;
									end
								end
							end
						end
					else
						Hud.cis_mpopt = 0;
					end
				end
			end

			self:DrawCrosshairName(player);
			self:OnUpdateCommonHudElements();
		else -- SPECTATOR
				timestff.x = 740;
				timestff.y = 556;
				if (cl_display_hud == "0" or self.bHide) then
					return
				end
		
				local sFollowName="";
				local entHost;

				if (player and player.cnt) and (player.cnt.GetHost) then
					local idHost=player.cnt:GetHost();
					entHost=System:GetEntity(idHost);
					if(entHost)then
						sFollowName=entHost:GetName();
					end
				end
				--spectator
				if (Hud.cis_known_help) then
					%System:DrawImageColor(Hud.white_dot, 30, 60, 740, 478, 4, 0.1, 0.1, 0.2, 0.8);
					%System:DrawImageColor(Hud.cis_known_help, 30, 60, 740, 24, 4, 1, 1, 1, 1);
					local myhlp = Input:GetXKeyPressedName();
					if (not Hud.cis_helppage) then
						Hud.cis_helppage = 1;
					end
					if (Mission) and (Mission.gamehelp) then
						%Game:WriteHudString(40,68,"\n"..Mission.gamehelp..Hud.cis_helppage,1,1,1,1,21,21);
					else
						local sgametyp = strupper(getglobal("g_GameType"));
						%Game:WriteHudString(40,68,"\n@cis_"..sgametyp.."_help_"..Hud.cis_helppage,1,1,1,1,21,21);
					end
					if (myhlp) and (myhlp~="") then
						local max_pages = 2;
						if (Mission) and (Mission.gamehelp) and (Mission.gamehelp_pages) then
							max_pages = Mission.gamehelp_pages;
						end
						if (myhlp == "left") then
							Hud.cis_helppage = Hud:ClampToRange(Hud.cis_helppage-1,1,max_pages);
							BasicPlayer.PlayInteractSound(_localplayer,"Sounds/items/scope.wav");
						elseif (myhlp == "right") then
							Hud.cis_helppage = Hud:ClampToRange(Hud.cis_helppage+1,1,max_pages);
							BasicPlayer.PlayInteractSound(_localplayer,"Sounds/items/scope.wav");
						else
							Hud.cis_known_help = nil;
							Hud.cis_helppage = nil;
							if (Hud.cis_helpmusic) and Sound:IsPlaying(Hud.cis_helpmusic) then
								Sound:StopSound(Hud.cis_helpmusic);
								Hud.cis_helpmusic = nil;
							end
						end
					end
				end
				%System:DrawImageColor(Hud.white_dot, 0, 540, 800, 60, 4, 0.1, 0.1, 0.2, 0.8);
				if (entHost) and (entHost.Properties.KEYFRAME_TABLE) and (not entHost.Properties.bNoRespawn) then
				%Game:WriteHudString( 10, 546, "@Spectating "..sFollowName,1,0.6,0.6,0.9,28,28);
				%Game:WriteHudString( 10, 546, "@Spectating",1,1,1,1,28,28);
				else
				%Game:WriteHudString( 10, 546, "@Spectating "..sFollowName, 1, 1, 1, 1, 28, 28);
				end
				%Game:WriteHudString( 10, 568, "@OpenMenuAndJoinNonTeam", 1, 1, 1, 1, 20, 20);
				self:DrawCrosshairName(player);
				self:OnUpdateCommonHudElements();
		end
	end

	self:FlushCommon();
	self:MessagesBox();
	ScoreBoardManager:Render();

	local iGameState = Client:GetGameState();
	local fTimeLimit = Hud.fTimeLimit;
	if (iGameState == CGS_INPROGRESS) then
		if (fTimeLimit and (fTimeLimit > 0)) then
			%Game:SetHUDFont("radiosta","binozoom");
			local fTime = floor(fTimeLimit * 60) - (_time - Client:GetGameStartTime());
			%Game:WriteHudString(timestff.x,timestff.y,SecondsToString(max(fTime, 0)),1,1,1,0.8,19,19);
		else
			%Game:SetHUDFont("hud", "ammo");
			Hud:DrawRightAlignedString("@NoTimeLimit","@NoTimeLimit", 20, 20, 1, 1, 1, 1, 60, 5);
		end
	elseif (iGameState == CGS_INTERMISSION) then
		if (Hud.im_spot) and (_localplayer) then
			_localplayer:SetAngles(Hud.im_spot);
			if (_localplayer.cnt) and (_localplayer.cnt.weapon) then
				_localplayer.cnt:DeselectWeapon();
			end
		end
	end
end

function Hud:ShowRepairHints(objpos)
	if (_localplayer.cnt) and (_localplayer.cnt.weapon) and (_localplayer.cnt.weapon.name=="EngineerTool") then
		if (_localplayer.fireparams) and (_localplayer.fireparams.damage_type ~= "building") then
			local vill_dist = _localplayer:GetDistanceFromPoint(objpos);
			if (vill_dist < 2) then
				local namesizex,namesizy = %Game:GetHudStringSize("@su_rep_chm @ToggleZoom", 20, 20);
				namesizex=400-(namesizex*0.5);
				%Game:WriteHudString(namesizex,520,"@su_rep_chm @ToggleZoom", 0.6, 1, 0.6, 1, 20,20);
			end
		end
	else
		local vill_dist = _localplayer:GetDistanceFromPoint(objpos);
		if (vill_dist < 2) then
			local namesizex,namesizy = %Game:GetHudStringSize("@su_rep_draw", 20, 20);
			namesizex=400-(namesizex*0.5);
			%Game:WriteHudString(namesizex,520,"@su_rep_draw", 0.6, 1, 0.6, 1, 20,20);
			if (_localplayer.cnt.use_pressed) then
				Client:SendCommand("VB_GV -1");
			end
		end
	end
end

function Hud:DrawCrosshairName(player)
	if (player.cnt) and (player.cnt.GetViewIntersection) then
	local obj=player.cnt:GetViewIntersection();
	if (obj) and (obj.ent) then
		if obj.ent.entity_type=="player" then
			if BasicPlayer.IsAlive(obj.ent) then
				local name = obj.ent:GetName();
				if (obj.ent.isvillager) then
					if (obj.ent.i_am_atrader) then
						name = "@cis_istrader "..name;
					end
					local vill_dist = player:GetDistanceFromPoint(obj.ent:GetPos());
					if (vill_dist < 2.1) and (player.pressed_v_su==nil) then
						local namesizex,namesizy = %Game:GetHudStringSize("@su_villfmsg", 20, 20);
						namesizex=400-(namesizex*0.5);
						%Game:WriteHudString(namesizex,520,"@su_villfmsg", 0.6, 1, 0.6, 1, 20,20);
						if (player.cnt.use_pressed) then
							player.pressed_v_su = _time + 3;
							Client:SendCommand("SUFM "..obj.ent.id);
						end
					end
					if (player.pressed_v_su) and (player.pressed_v_su < _time) then
						player.pressed_v_su = nil;
					end
					vill_dist = ceil(obj.ent.cnt.health/obj.ent.cnt.max_health*100);
					name = name.." - "..vill_dist.."%";
				elseif (obj.ent.su_turret) then
					Hud:ShowRepairHints({x=obj.x,y=obj.y,z=obj.z});
				end
				local namesizex,namesizy = %Game:GetHudStringSize(name, 20, 20);
				namesizex=400-(namesizex*0.5);
				%Game:WriteHudString(namesizex,507,name , 1, 1, 1, 1, 20,20);
			end
		elseif (obj.ent.ResetBuildpointsOfConnected) and (obj.ent.Properties.max_buildpoints>0) then ---- place buildable object stuff here
			Hud:ShowRepairHints({x=obj.x,y=obj.y,z=obj.z});
		end
	end
	end
end

function Hud:OnShutdown()
end
