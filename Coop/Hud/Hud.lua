-- Improved by Mixer
Script:LoadScript("scripts/Multiplayer/Hud.lua");

function Hud:OnInit()
	self:CommonInit();	
	Language:LoadStringTable("MultiplayerHUD.xml");
	self.InTDMPROteamlogo=System:LoadImage("textures/hud/multiplayer/Attacker_Logo");
	if (Sound.LoadStreamSound) then
		Hud.checkpointreachedsnd = Sound:LoadStreamSound("sounds/items/cis_sec.ogg");
	end
end

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

function Hud:OnUpdate()
	%Game:SetHUDFont("hud", "ammo");
	local player=_localplayer;
	local timestff = {x = 45+self.hdadjusty*2,y = 574+self.hdadjusty*0.8};
	if (player) then
		if (player.entity_type~="spectator") and (player.cnt ~= nil) then
			
				--overlay
				ClientStuff.vlayers:DrawOverlay();
		
				-- [tiago] display onscreen fx, when player gets damage	(only when smokeblur layer not active)
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

				--moved panoramic display before hud visibility check because we need panoramic in cut-scenes and dont anything else
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
								---
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

				--DRAW DM SCORE
					
				self:DrawCrosshairName(player);		
				
				--infos
				%Game:SetHUDFont("hud", "ammo");
				
				self:OnUpdateCommonHudElements();
				self:DrawItems(player);
		end -- non for the spectator
			if (player.entity_type=="spectator") then
		
				if(cl_display_hud == "0" or self.bHide)then
					return
				end
				
				timestff.x = 740;
				timestff.y = 556;
		
				local sFollowName="";
				-- changed
		
				if (player and player.cnt) then
					if (player.cnt.GetHost) then
						local idHost=player.cnt:GetHost();
						local entHost=System:GetEntity(idHost);
			
						if(entHost)then
							sFollowName=entHost:GetName();
						end
					end
				end
				--spectator
				%Game:SetHUDFont("hud", "ammo");
				%System:DrawImageColor(Hud.white_dot, 0, 540, 800, 60, 4, 0.1, 0.1, 0.2, 0.8);
				%Game:WriteHudString(10,546,"@Spectating "..sFollowName,1,1,1,1,28,28);
				%Game:WriteHudString( 10, 568, "@OpenMenuAndJoinNonTeam", 1, 1, 1, 1, 20, 20);

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
						local max_pages = 1;
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

				self:DrawCrosshairName(player);
				self:OnUpdateCommonHudElements();
				
			end
	end
	self:FlushCommon();
	------------------------------------------
	
	self:MessagesBox();
	%Game:SetHUDFont("hud", "ammo");
	
	if(self.centermessage)then
		self:CenterMessage();
	end
	ScoreBoardManager:Render();
	
						
	%Game:SetHUDFont("hud", "ammo");
	
	if (cl_display_hud ~= "0" and not self.bHide) then
		local iGameState = Client:GetGameState();
		local fTimeLimit = Hud.fTimeLimit;
	
		if (iGameState == CGS_INPROGRESS) then
		
			if (fTimeLimit and (fTimeLimit > 0)) then
				%Game:SetHUDFont("radiosta","binozoom");
				local fTime = floor(fTimeLimit * 60) - (_time - Client:GetGameStartTime());
				%Game:WriteHudString(timestff.x,timestff.y,SecondsToString(max(fTime, 0)),1,1,1,0.8,19,19);
				%Game:SetHUDFont("hud", "ammo");
			else
				%Game:SetHUDFont("radiosta","binozoom");
				%Game:WriteHudString(timestff.x,timestff.y,date("%H:%M"),1,1,1,0.8,19,19);
				%Game:SetHUDFont("hud", "ammo");
			end
	
		elseif (iGameState ~= CGS_INTERMISSION) then
			local nsx,nsy = %Game:GetHudStringSize("@CIS_PREWAR",30,30);
			nsx = 400-nsx*0.5;
			Game:WriteHudString(nsx,15, "@CIS_PREWAR", 1, 1, 1, 1, 30, 30);
		end
	end		
end

function Hud:DrawCrosshairName(player)
if (player.cnt) and (player.cnt.GetViewIntersection) then
	%Game:SetHUDFont("default", "default");
	if (self.InTDMPROteamlogo) then
		%System:DrawImageColor(self.InTDMPROteamlogo,705,1,60*self.hd_sc_mult,60,4,0,1,0,0.4);
		if (player.cnt.score) then
			local namesizex,namesizy = %Game:GetHudStringSize(player.cnt.score, 32, 32);
			namesizex = namesizex * 0.5;
			%Game:WriteHudString(735-self.hdadjust*0.1-namesizex,16,player.cnt.score,1,1,1,1,32,32);
		end
	end
	local obj=player.cnt:GetViewIntersection();
	if obj and obj.ent and obj.ent.entity_type=="player" then
		if BasicPlayer.IsAlive(obj.ent) then
			local curCrossName=toNumberOrZero(getglobal("gr_CrossName"));
			if (curCrossName==1) then
				local color="$1";
				if self.teamcolors then
					color=self.teamcolors[Game:GetEntityTeam(obj.ent.id)];
				end
				if color then
					local dist = _localplayer:GetDistanceFromPoint(obj.ent:GetPos());
					if (dist < 14) then
						local name = obj.ent:GetName();
						local strsizex,strsizey = Game:GetHudStringSize(name, 16, 16);
						Game:WriteHudString(400-(strsizex/2),316,name, 1, 1, 1,1-(dist/14), 16, 16);
					end
				end
			end
		end
	end
end
end
