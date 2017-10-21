-- team hud voice gestures Mixer/garbitos/garcy

Script:LoadScript("scripts/GUI/HudCommon.lua");
Script:LoadScript("scripts/GUI/HudMultiplayer.lua");

Hud.teamcolors={
		red="$4",
		blue="$5",
	}
	
Hud.teamrgb={
		red={1,0,0},
		blue={0.8,0.8,1},
	}
	
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
	soundFile = "languages/voicepacks/voiceB/comm_flank_left_1_VoiceB.wav",
	Volume = 200,
	min = 3,
	max = 40,
	txt = "@cis_qv_goleft",
	},
	{
	soundFile = "languages/voicepacks/voiceB/comm_flank_right_1_VoiceB.wav",
	Volume = 200,
	min = 3,
	max = 40,
	txt = "@cis_qv_goright",
	},
	{
	soundFile = "languages/voicepacks/voiceB/comm_retreat_1_VoiceB.wav",
	Volume = 200,
	min = 3,
	max = 40,
	txt = "@cis_qv_pullback",
	},
};
	
Hud.PlayerObjective=nil;			-- sycronized string for HUD

function Hud:OnInit()
	self:CommonInit();
	Language:LoadStringTable("MultiplayerHUD.xml");
end

function Hud:DrawTeams(player)
	if (player) then
		if (Hud.PlayerObjectiveAnim==nil) then
			local team=Game:GetEntityTeam(player.id);
			if (Hud.PlayerObjectiveCISS) then -- spectator info for watching assault player goal
				if (Hud.PlayerObjectiveCISS == "POAtt" and team == "red") then
					Hud.PlayerObjective = "POAtt";
				else
					Hud.PlayerObjective = "PODef";
				end
			end
			if (team=="blue") then
				%System:DrawImageColor(self.InTDMPROteamlogo,705,1,60*self.hd_sc_mult,60,4,0,0,1,0.4);
			else
				%System:DrawImageColor(self.InTDMPROteamlogo,705,1,60*self.hd_sc_mult,60,4,1,0,0,0.4);
			end
		end
	else
		Hud.PlayerObjective = "POAtt";
		%System:DrawImageColor(self.InTDMPROteamlogo,705,1,60*self.hd_sc_mult,60,4,1,1,1,0.5);
	end
	local red_score=Game:GetTeamScore("red");
	local blue_score=Game:GetTeamScore("blue");
	self:DrawCTFTeamText(721-self.hdadjust*0.11,17," : ",{1,1,1,1},24);
	if blue_score < 99 then
		self:DrawCTFTeamText(702+self.hdadjust*0.1,17,blue_score,self.teamrgb["blue"],24);
	else
		self:DrawCTFTeamText(700+self.hdadjust*0.1,20,blue_score,self.teamrgb["blue"],20);
	end
	if red_score < 10 then
		self:DrawCTFTeamText(756-self.hdadjust*0.1,17,red_score,self.teamrgb["red"],24);
	elseif red_score < 19 then
		self:DrawCTFTeamText(750-self.hdadjust*0.1,17,red_score,self.teamrgb["red"],24);
	elseif red_score < 99 then
		self:DrawCTFTeamText(748-self.hdadjust*0.1,17,red_score,self.teamrgb["red"],24);
	else
		self:DrawCTFTeamText(745-self.hdadjust*0.1,20,red_score,self.teamrgb["red"],20);
	end
end

function Hud:OnUpdate()
	%Game:SetHUDFont("hud", "ammo");
	local player=_localplayer;
	local timestff = {x = 45+self.hdadjusty*2,y = 574+self.hdadjusty*0.8};
	self:DrawProgressIndicator("AssaultState");

	if (player and player.entity_type~="spectator") then
		--overlay
		ClientStuff.vlayers:DrawOverlay();
		
		-- [tiago] display onscreen fx, when player gets damage	(only when smokeblur layer not active)
		if (not ClientStuff.vlayers:IsActive("SmokeBlur") and not ClientStuff.vlayers:IsFading("SmokeBlur")) then							
			-- check damage/hits...
			if (self.hitdamagecounter>0) then
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
		
		---- team talk
		if (Hud.cis_mpopt) then
			if (Hud.cis_mpopt == 0) then
				if (_localplayer.theVehicle==nil) then
					Input:SetActionMap("default");
				end
				Hud.cis_mpopt = nil;
				Hud.npcdialogtimer = nil;
			else
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
					--bp_txt = bp_txt.."N. @Gest_Pullback \n";
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
			end
		end
		
		self:DrawTeams(player);
		self:DrawCrosshairName(player);
		
		--infos
		%Game:SetHUDFont("hud", "ammo");
		self:OnUpdateCommonHudElements();

	else -- LocalIsASpectator
		
		if(cl_display_hud == "0" or self.bHide)then
			return
		end

		timestff.x = 740;
		timestff.y = 556;
		--spectator
		local head_string="@Spectating";
		Hud.PlayerObjectiveAnim = nil;
		for key,value in self.Progress do
			self:DrawProgressIndicator(key);
		end
		
		if (player) then
			local hostid=player.cnt:GetHost();
			if (hostid and hostid~=0)then
				local host=System:GetEntity(hostid);
				if (host) then
					head_string=head_string.." "..host:GetName();
					self:DrawTeams(host);
				end
			else
				self:DrawTeams();
			end
			self:OnUpdateCommonHudElements();
		end
		%Game:SetHUDFont("hud", "ammo");
		%System:DrawImageColor(Hud.white_dot, 0, 540, 800, 60, 4, 0.1, 0.1, 0.2, 0.8);
		%Game:WriteHudString(10,546,head_string,1,1,1,1,28,28);
		%Game:WriteHudString( 10, 568, "@OpenMenuAndJoinTeam", 1, 1, 1, 1, 20, 20);
	end
	
	local fadeduration = 0.75; -- 2 second to fade	
	local stayduration = 1.75; -- stay two second on screen with full alpha
	local translateduration = 0.65; -- 1.5 seconds to translate to the left
	
	local startwidth = 128;
	local startheight = 128;
	local startx = 400 - startwidth * 0.5; -- centered
	local starty = 300 - startheight * 0.5; -- centered
			
	local targetwidth = 52; 
	local targetheight = 52;
	local targetx = 710;
	local targety = 5;
	
	local LocalPlayerTeam;
	
	if player then
		if (self.idShowMissionObject) then
			local ent=System:GetEntity(Hud.idShowMissionObject);
			if (ent) then
				ent:Render();
			end
		end
		LocalPlayerTeam=Game:GetEntityTeam(player.id);
	end
	
	-- default is red team
	local teamR, teamG, teamB=1, 0, 0;
	if(LocalPlayerTeam=="blue") then
		teamR=0; 
		teamB=1;
	end

	if (self.PlayerObjectiveAnim) then
		if (self.PlayerObjectiveAnim == 1) then	-- 1 is fade
			
			local curralpha = ((_time - self.PlayerObjectiveAnimStart) / fadeduration);
			
			if (curralpha >= 1.0) then
				curralpha = 1.0;			
				self.PlayerObjectiveAnim = 2;
				self.PlayerObjectiveAnimStart = _time;
			end
			
			%System:DrawImageColor(self.PlayerObjectiveAnimTex, startx, starty, startwidth, startheight, 4, teamR, teamG, teamB, curralpha);
		elseif (self.PlayerObjectiveAnim == 2) then -- 2 is stay on screen

			%System:DrawImageColor(self.PlayerObjectiveAnimTex, startx, starty, startwidth, startheight, 4, teamR, teamG, teamB, 1);
			
			if (_time >= self.PlayerObjectiveAnimStart + stayduration) then
				self.PlayerObjectiveAnim = 3;
				self.PlayerObjectiveAnimStart = _time;
			end
		elseif (self.PlayerObjectiveAnim == 3) then -- 3 is translate to the left
					
			local t = ((_time - self.PlayerObjectiveAnimStart) / translateduration);
			
			if (t >= 1.0) then
				t = 1.0;

				self.PlayerObjectiveAnim = 4;
				self.PlayerObjectiveAnimStart = _time;
			end			
			
			-- interpolate the values
			local currwidth = (startwidth + (targetwidth - startwidth) * t);
			local currheight = (startheight + (targetheight - startheight) * t);
			local currx = (startx + (targetx - startx) * t);
			local curry = (starty + (targety - starty) * t);
			
			%System:DrawImageColor(self.PlayerObjectiveAnimTex, currx, curry, currwidth, currheight, 4, teamR, teamG, teamB, 1);					
			
		elseif (self.PlayerObjectiveAnim == 4) then -- 4 is the final position

			%System:DrawImageColor(self.PlayerObjectiveAnimTex, targetx, targety, targetwidth, targetheight, 4, teamR, teamG, teamB, 1);						
		end
	end
	
	self:FlushCommon();

	self:MessagesBox();	
	%Game:SetHUDFont("hud", "ammo");
	
	if (self.centermessage) then
		self:CenterMessage();
	end
	
	ScoreBoardManager:Render();
	
	%Game:SetHUDFont("hud", "ammo");
	if(cl_display_hud ~= "0" and ClientStuff and not self.bHide)then
		local iGameState = Client:GetGameState();
		local fTimeLimit = Hud.fTimeLimit;
		
		if (iGameState == CGS_INPROGRESS) then
			
			if (fTimeLimit and (fTimeLimit > 0)) then
				%Game:SetHUDFont("radiosta","binozoom");
				local fTime = floor(fTimeLimit * 60) - (_time - Client:GetGameStartTime());
				%Game:WriteHudString(timestff.x,timestff.y,SecondsToString(max(fTime, 0)),1,1,1,0.8,19,19);
				%Game:SetHUDFont("hud", "ammo");
			end
			
			

			-- if we have a respawn cycle
			if ((self.iRespawnCycleStart ~= nil) and (self.iRespawnCycleStart ~= nil)) then
				local fTime = ceil(self.iRespawnCycleLength - (_time - self.iRespawnCycleStart));
				Hud:DrawRightAlignedString("@Reinforcements 99","@Reinforcements "..tostring(max(fTime, 0)), 20, 20, 1, 1, 1, 1, 58, 8.5);
			end
	
		elseif (iGameState ~= CGS_INTERMISSION) then
			local nsx,nsy = %Game:GetHudStringSize("@CIS_PREWAR",30,30);
			nsx = 400-nsx*0.5;
			Game:WriteHudString(nsx,15, "@CIS_PREWAR", 1, 1, 1, 1, 30, 30);
		end
	end	
end

function Hud:OnShutdown()
	%System:Log("Hud:OnShutdown()");
end