Script:LoadScript("scripts/GUI/HudCommon.lua");

Hud.objectives={};

function Hud:PushObjective(pos,text)
	for i,val in self.objectives do
		if(val.text==text)then 
			return
		end
	end
	self.objectives[getn(self.objectives)+1]={pos=new(pos),text=text,completed=nil}
end
----------
function Hud:FlashObjectives()
	self.objectives={}
end

-- [marco] remove it based on objective name
--------------
function Hud:CompleteObjective(text)
	for i,val in self.objectives do
		if(val.text==text)then
			val.completed=1;
			-- break --in editormode,there can be more than 1 wth the same name
		end
	end
end


------------
function Hud:OnInit()
	self:CommonInit();
end

function Hud:SecretArea(sec_total)
	if (_localplayer) and (_localplayer.items) then
		local locsec = Game:GetLevelName().."_cek";
		if (not _localplayer.items[locsec]) then
			_localplayer.items[locsec] = 0;
		end
		_localplayer.items.cis_secretar = nil;
		_localplayer.items[locsec] = _localplayer.items[locsec] + 1;
		Hud.cis_totalsec = "@cek ".."(".._localplayer.items[locsec].."/"..sec_total..")";
		Hud.cis_secretmsg = _time + 3;
		local ssnd = Sound:LoadStreamSound("sounds/items/cis_sec.ogg");
		if (ssnd) then
			Sound:SetSoundVolume(ssnd,200);
			Sound:PlaySound(ssnd);
		end
	end
end

function Hud:ManageSpOptions()
if (_localplayer.cnt) and (BasicPlayer.IsAlive(_localplayer)) then
	if (Hud.cis_spopt) and (Hud.cis_spopt == 0) then
		if (_localplayer.theVehicle==nil) then
			Input:SetActionMap("default");
		end
		if (_localplayer.items.phone) then
			_localplayer.items.phone = 0;
		end
		Hud.cis_spopt = nil;
		Hud.npcdialogtimer = nil;
	else
		Input:SetActionMap("vehicle");
		%System:DrawImageColor(Hud.white_dot, 600, 140, 180, 405, 4,0.1,0.1,0.2,0.8);
		%System:DrawImageColor(Hud.white_dot, 603, 140, 1, 405, 4,0,0.4,0,0.86);
		%System:DrawImageColor(Hud.white_dot, 603, 143, 174, 25, 4, 0, 0, 0, 0.6);
		Hud:DrawElement(603, 139,Hud.pickups[16],1,1,1,1);
		local store_str = {};
		if (_localplayer.items.phone) and (_localplayer.items.phone > 0) then
			Game:WriteHudString(636,145,"@cis_phone", 1, 1, 1, 1, 19, 19);
			if (Mission.squad) and (_localplayer.items.squad_go) then
				tinsert(store_str,"@cis_qv_followme");
				tinsert(store_str,"@cis_qv_holdpos");
				local snum = getn(Mission.squad);
				local sid = 1;
				local s_liv = 0;
				Mission.squad_living = {};
				while sid <= snum do
					local m_ent = System:GetEntityByName(Mission.squad[sid]);
					if (m_ent) and (m_ent.cnt) and (m_ent.cnt.health > 0) then
						tinsert(store_str,"@cis_send @"..Mission.squad[sid]);
						s_liv = s_liv+1;
						Mission.squad_living[s_liv] = Mission.squad[sid].."";
					end
					sid = sid + 1;
				end
			end
			tinsert(store_str,"@cis_radio_back");
		else
			if (_localplayer.items.aliensuit) then
				Game:WriteHudString(636,145,"@cis_aliensuit", 1, 1, 1, 1, 19, 19);
			else
				Game:WriteHudString(636,143,"@cis_backpack", 1, 1, 1, 1, 22, 22);
			end
			if (Mission) and (Mission.quick_save_name) then
				tinsert(store_str,"@cis_quicksave");
			elseif (Mission) then
				Mission.quick_save_name = "checkpoint_"..Game:GetLevelName().."_quicksave";
			end
			if (_localplayer.items.phone) then
				tinsert(store_str,"@cis_phone");
			end
			if (_localplayer.items.silencer_a) then
				tinsert(store_str,"@cis_sil_onoff");
			end
			if (_localplayer.items.m_medpak) then
				tinsert(store_str,"@cis_medpack");
			end
			if (_localplayer.items.wrenchtool) then
				tinsert(store_str,"@cis_wrtool");
			end
			if (_localplayer.items.scubagear) and (_localplayer.items.scubagear > 0) then
				tinsert(store_str,"@cis_scuba");
			end
			if (_localplayer.items.m_fuse) then
				tinsert(store_str,"@cis2_nopow");
			end
			if (_localplayer.items.cis3diary) then
				tinsert(store_str,"@ReadHdiary1");
			end
			if (_localplayer.items.m_jcan) then
				tinsert(store_str,"@cis5_jcan");
			end
			if (_localplayer.items.creditcard) then
				tinsert(store_str,"@cis_creditcard");
			end
			if (_localplayer.items.conekey) then
				tinsert(store_str,"@cis_conekeystuff");
			end
			if (_localplayer.items.gl_pass) then
				tinsert(store_str,"@cis6_grimpass");
			end
			if (_localplayer.items.invis_holdable) then
				tinsert(store_str,"@cis_holdable_invis_use");
			end
			if (_localplayer.items.crystal_gem) then
				tinsert(store_str,"@cis_crystal");
			end
			-------
		end
		-------------
		if (getn(store_str)>0) then
			local bp_txt = "";
			local np_token = 1;
			while store_str[np_token] do
				local nptk = mod(np_token,10);
				bp_txt = bp_txt..nptk..". "..store_str[np_token].." \n";
				np_token = np_token + 1;
			end
			%Game:WriteHudString(616,170,bp_txt, 0.8, 0.8, 0.3, 1, 15,15);
			if (Hud.cis_lastkey) then
				np_token = strfind(Hud.cis_lastkey,"numpad");
				if (np_token) then
					Hud.cis_lastkey = strsub(Hud.cis_lastkey,7);
				end
				bp_txt = tonumber(Hud.cis_lastkey);
				if (bp_txt) and (bp_txt == 0) then
					bp_txt = 10;
				end
				if (bp_txt) and (store_str[bp_txt]) then
					Hud.cis_spopt = 0;
					if (Game.cis_SpOptionKey) and (Game.cis_SpOptionKey==Hud.cis_lastkey) and (not Hud.cis_SkipSpOption) then
						Hud.cis_SkipSpOption = 1;
						Hud.cis_lastkey = "";
						Hud.cis_spopt = 1; -- to not close menu
						return;
					else
						Hud.cis_SkipSpOption = nil;
					end
					if (store_str[bp_txt] == "@cis_quicksave") then
						Game:Save(Mission.quick_save_name);
						--- Mixer: make entry in save base ---
						local savbase_date = "";
						for i, val in Game:GetModsList() do
							if (val.CurrentMod) then
								savbase_date = val.Folder.."/";
								break;
							end
						end

						local sav_datetime = date("%Y%m%d%H%M%S")..strlower(Game:GetLevelName());
						if (UI) then
							UI:Ecfg(savbase_date.."Levels/sav_base.ini",strlower(Mission.quick_save_name),sav_datetime);
						end
						Hud.cis_secretmsg = _time + 4;
						Hud.cis_csmsg = "@Gamesaved";
						BasicPlayer.PlayInteractSound(_localplayer,"Sounds/Weapons/itemdrop/dropgundirt.wav");
					elseif (store_str[bp_txt] == "@cis_sil_onoff") and (_localplayer.cnt.weapon) then
						_localplayer.cnt.weapon.manage_sil = 1;
					elseif (store_str[bp_txt] == "@cis_wrtool") then
						_localplayer.cnt:MakeWeaponAvailable(27);
						_localplayer.cnt:SetCurrWeapon(27);
					elseif (store_str[bp_txt] == "@cis_holdable_invis_use") then
						_localplayer:Grab_Invisibility(-_localplayer.items.invis_holdable);
					elseif (store_str[bp_txt] == "@cis_phone") then
						_localplayer.items.phone = 1; -- using cell phone
						Hud.cis_SkipSpOption = 1;
						Hud.cis_spopt = 1; -- to not close menu
					elseif (store_str[bp_txt] == "@cis_medpack") then
						if (_localplayer.items.m_medpak > 48) and (_localplayer.cnt.health < _localplayer.cnt.max_health) then
							_localplayer.items.m_medpak = _localplayer.items.m_medpak - 1;
							_localplayer.cnt.health = _localplayer.cnt.max_health;
							BasicPlayer.PlayInteractSound(_localplayer,"Sounds/items/health.wav");
						end
					elseif (store_str[bp_txt] == "@cis_qv_followme") then
						Mission:SquadFollow();
					elseif (store_str[bp_txt] == "@cis_qv_holdpos") then
						Mission:SquadStop();
					elseif (store_str[bp_txt] == "@cis_radio_back") then
						_localplayer.items.phone = 0;
					elseif (_localplayer.items.phone) and (_localplayer.items.phone > 0) then
						if (Mission.squad_living) and (Mission.squad_living[bp_txt-2]) and (_localplayer.cnt) and (_localplayer.cnt.GetViewIntersection) then
							--- send there
							local pos_send = _localplayer.cnt:GetViewIntersection();
							if (pos_send) then
								local send_marker = System:GetEntityByName('squad_unit_destination1');
								if (send_marker) then
									send_marker:SetPos(pos_send);
									AI:RegisterWithAI(send_marker.id, AIAnchor.AIANCHOR_PROTECT_THIS_POINT);
									local send_ent = System:GetEntityByName(Mission.squad_living[bp_txt-2]);
									if (send_ent) and (send_ent.POTSHOTS) and (send_ent.cnt) and (send_ent.cnt.health > 0) then
										send_ent:InsertSubpipe(0,"val_lead_to",send_marker.id); -- go
										pos_send = random(1,6);
										BasicPlayer.PlayInteractSound(_localplayer,"languages/voicepacks/VoiceC/comm_suppress_"..pos_send.."_VoiceC.wav");
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
end
-------------
function Hud:OnUpdate()
	local player=_localplayer;

	-- Update Dynamic music.
	self:UpdateDynamicMusic();

	-- SECRET MSG/CUTSCENE TEXTS
	if (Hud.cis_secretmsg) then
		%Game:SetHUDFont("hud", "ammo");
		local alphaval = Hud.cis_secretmsg - _time + 1;
		alphaval = Hud:ClampToRange(alphaval, 0, 1);
		if (Hud.cis_totalsec) then
			local strszex,strszey = Game:GetHudStringSize(Hud.cis_totalsec, 21, 21);
			Game:WriteHudString( 400-(strszex/2), 500, Hud.cis_totalsec, 1, 1, 1, alphaval, 21, 21);
		elseif (Hud.cis_gfxmsg) then
			%System:DrawImageColor(Hud.cis_gfxmsg.src, Hud.cis_gfxmsg.x, Hud.cis_gfxmsg.y, Hud.cis_gfxmsg.width, Hud.cis_gfxmsg.height, 4,1,1,1,alphaval);
		elseif (Hud.cis_csmsg) then
			local strszex,strszey = Game:GetHudStringSize(Hud.cis_csmsg, 28, 26);
			Game:WriteHudString( 400-(strszex*0.5), 420-(strszey*0.5), Hud.cis_csmsg, 1, 1, 1, alphaval, 28, 26);
		end
		if (Hud.cis_secretmsg < _time-1) then
			Hud.cis_secretmsg = nil;
			Hud.cis_totalsec = nil;
			Hud.cis_csmsg = nil;
			Hud.cis_gfxmsg = nil;
		end
	end

	-- [marco] The environment can be affected by lightning, which blinds any player 
	-- using Night Vision for a brief period. In case of the night vision
	-- is done in the above call.
	if(tonumber(cl_display_hud)~=0 and not self.bHide) then
		if (player and player.classname=="Player") then
		
			ClientStuff.vlayers:DrawOverlay();
										
			
		      -- Display on screen damage fx                                     
		    if(hud_screendamagefx == "1" and g_gore ~= "0") then
		      if (not ClientStuff.vlayers:IsActive("SmokeBlur") and not ClientStuff.vlayers:IsFading("SmokeBlur")) then                                              
		        -- check damage/hits...
		        if(self.hitdamagecounter>0) then

							local fTime=_frametime;	
							-- something is wrong with frametime. Clamp it.
							if(fTime<0.002) then
								fTime=0.002;
							elseif(fTime>0.5) then 
								fTime=0.5;	
							end

		          System:SetScreenFx("ScreenBlur", 1);                            
		          self.hitdamagecounter=self.hitdamagecounter - fTime*3.5;
		          System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurAmount", self.hitdamagecounter/10.0);
		        else
		          System:SetScreenFx("ScreenBlur", 0);
		          self.hitdamagecounter=0;
		        end                                              
		      end
		    end

	
			-- [lennert] When a loud noise occurs (grenade etc.), the player will be deafened. Client-effect only...
			if (self.deaf_time) then
				--System:LogToConsole("deafened:"..self.deaf_time);

				local fSoundScale=1;

				if (self.deaf_time<(self.initial_deaftime-0.4)) then

					if (self.deaf_time<self.deafness_fadeout_time) then
						fSoundScale=self.deaf_time/self.deafness_fadeout_time;
					end
					Sound:SetGroupScale(SOUNDSCALE_DEAFNESS, 1-fSoundScale);
					if (not Sound:IsPlaying(self.EarRinging)) then
						--System:Log("start ear ringing");
						Sound:PlaySound(self.EarRinging);
					end
					Sound:SetSoundVolume(self.EarRinging, fSoundScale*255);
				end

				self.deaf_time=self.deaf_time-_frametime;
				if (self.deaf_time<=0) then
					self.deaf_time=nil;
					Sound:StopSound(self.EarRinging);
					Sound:SetGroupScale(SOUNDSCALE_DEAFNESS, 1);
				end
			end

			-- display items
			self:DrawItems(player);			
			-- display stealth meter
			self:DrawStealthMeter(0,567);
			%Game:SetHUDFont("radiosta","binozoom");
			%Game:WriteHudString(45+self.hdadjusty*2,574+self.hdadjusty*0.8,date("%H:%M"),1,1,1,0.8,19,19);
			-- update hud
			%Game:SetHUDFont("hud", "ammo");
			self:OnUpdateCommonHudElements();
				
			-- display mission box
			ScoreBoardManager:Render();			
			
			-- display messages			
			self:MessagesBox();

		end		
	end	
	
	
	if(player and player.classname=="Player") then	
		-- only player gets 'panoramic'.. (there's some bug in renderer, i have to set ONE ZERO blending mode, since blending is not reseted for some reason)
	 	if (hud_panoramic=="1") then							
			%System:DrawImageColorCoords(self.black_dot, 0, 0, 800, tonumber(hud_panoramic_height), 9, 0, 0, 0, 0.5, 0, 0, 1, 1);	
			%System:DrawImageColorCoords(self.black_dot, 0, 600-tonumber(hud_panoramic_height), 800, tonumber(hud_panoramic_height), 9, 0, 0, 0, 0.5, 0, 0, 1, 1);		
		end		
				
		-- display subtitles when required	
		self:SubtitlesBox();
	end
end

-------------------------------------------------------------------------------
-- Available DynamicMusic mood events.
-------------------------------------------------------------------------------
DynamicMusicMoodEvents = {
	Alert = { mood = "Alert",timeout = MM_ALERT_TIMEOUT },
	Suspense = { mood = "Suspense",timeout = MM_SUSPENSE_TIMEOUT },
	NearSuspense = { mood = "NearSuspense",timeout = MM_NEARSUSPENSE_TIMEOUT },
	Combat = { mood = "Combat",timeout = 0 },
	Victory = { mood = "Victory",timeout = 0 }
};

-------------------------------------------------------------------------------
-- Controls moods in dynamic music.
-------------------------------------------------------------------------------
function Hud:UpdateDynamicMusic()
	Hud.cis_sneakval = AI:GetPerception();
	local moodEvent = nil;
	
	if (Hud.cis_sneakval > 110) then
		-- if the AI starts attacking we send a COMBAT-mood event
		moodEvent = DynamicMusicMoodEvents.Combat;
	elseif (self.EnemyAlerted ~= 0) or (Hud.cis_sneakval > 0 and Hud.cis_sneakval <= 110) then
		-- if the AI starts attacking we send a COMBAT-mood event
		moodEvent = DynamicMusicMoodEvents.Alert;
	elseif (self.EnemyInNearSuspense~=0) then
		-- if the AI is very near we send a NEAR-mood event
		moodEvent = DynamicMusicMoodEvents.NearSuspense;
	elseif (self.EnemyInSuspense~=0) then
		-- if the AI is near we send a SUSPENSE-mood event
		moodEvent = DynamicMusicMoodEvents.Suspense;
	end
	
	if (self.PrevSneakValue) then
		if (self.PrevSneakValue>50) and (Hud.cis_sneakval==0) and (Sound:IsInMusicMood("Combat") and (self.EnemyAlerted==0)) then
			-- if the sneak value drops instantly from combat to 0 we killed the last guy, so we send a VICTORY-mood event
			moodEvent = DynamicMusicMoodEvents.Victory;
		end
	end
	
	if (moodEvent) then
		Sound:AddMusicMoodEvent( moodEvent.mood,moodEvent.timeout );
	end
	
	self.PrevSneakValue = Hud.cis_sneakval * 1;
end


--------
function Hud:OnShutdown()
	%System:Log("Hud:OnShutdown()");
	self.EarRinging=nil;
	
end
-----


