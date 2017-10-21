--------------------------pvcfmod------operaton clearing      www.reflex-studio.com -------------
--
--radio entity which plays random musictracks
--ask for destroyed vehicle state and teleports the sound away
-- ask for damaged vehicle   and play static if damage is to big
--added the radio is now a little bit more quiet if player is outside of vehicle but radio is playing
--debugged behaviour for parachute
--tell now the system if radio is activ and playing (clearingradioisactive    clearingradioisactiveANDplaying)
--added: designer now can select own radiochannels
--added shows a picture on screen if radio is playing
--added shows animated equalizer in radio image if radio is playing

--TODO
--channelswitch animations are only working if vehicle have a speed of 0km/h ... ???
--check what happens after save/load 
--exploded vehicle have (now) radio on this spot ??


ClearingVehicleRadio = {
	type = "Sound",
	bindtodestroyedvehicle=0,
	
	Properties = {

		iVolume=255,
		InnerRadius=8,
		OuterRadius=300,
		fFadeValue=1.0, -- for indoor sector sounds
		bLoop=0,	-- Loop sound.
		bPlay=1,	-- Immidiatly start playing on spawn.
		bOnce=0,
		bEnabled=1,
		bRadioMode = 1,
		bEnableDoppler=1,
		DopplerValue =0.4,
		offAddition = 1,
		RadioMinHealth = 26, --25 is burning vehicle
		PlaySwitchAnimation ="cidle_umshoot", --experimental, seems not to work 
		bShowRadioImage = 1,     --done in hudcommon!

	RadioChannels = {
		sndChannel01 = "sounds\\radiostation\\song1.wav",
		sndChannel02 = "sounds\\radiostation\\song2.wav",
		sndChannel03 = "sounds\\radiostation\\song3.wav",				
		sndChannel04 = "sounds\\radiostation\\song4.wav",
		sndChannel05 = "sounds\\radiostation\\song5.wav",
		sndChannel06 = "sounds\\radiostation\\song6.wav",
		sndChannel07 = "sounds\\radiostation\\song7.wav",
		sndChannel08 = "sounds\\radiostation\\song8.wav",				
		sndChannel09 = "sounds\\radiostation\\song9.wav",
		sndChannel10 = "sounds\\radiostation\\song10.wav",
		sndChannel11 = "sounds\\radiostation\\song11.wav",
		sndChannel12 = "sounds\\radiostation\\song12.wav",				
		sndChannel13 = "sounds\\radiostation\\song13.wav",		
	},   --RadioChannels
		
		RadioImage = {
						EQFallDownTimer = 0.1,
						EQTimer = 0.15,
						EQhigh = 1,
						EQspace = 3,
						EQspaceY = 1.48,						
						EQwidh = 7,
												
						textureImage = "Textures\\gui\\vehicleradio2_8.dds",
						alpha  = 75,
						high = 40,
						layer = 4,
						widh = 100,						
						x = 2,
						xEQoffset = 36, 
						
						y = 10,								
						yEQoffset = 28,
						
						TextXoffset = -20,
						TextYoffset = 12,
						TextsizeX = 1,  --its a multiplicator
						TextsizeY = 1, --its a multiplicator
						
						
						
						
						
						
				},		
		
		
	},
	started=0,
	Editor={
		Model="Objects/Editor/Sound.cgf",
	},
	bEnabled=1,
	--soundparticlestate =0,
	update=1,
	
}

function ClearingVehicleRadio:OnSave(stm)
	--WriteToStream(stm,self.Properties);
	stm:WriteInt(self.started);
	stm:WriteInt(self.bEnabled);
end

function ClearingVehicleRadio:OnLoad(stm)
	--self.Properties=ReadFromStream(stm);
	--self:OnReset();
	self.started = stm:ReadInt();
	self.bEnabled = stm:ReadInt();
	if ((self.started==1) and (self.Properties.bOnce~=1)) then
	    self:PlaySound();
	end	
end

function ClearingVehicleRadio:OnNextTrack()

	BroadcastEvent( self,"NextTrack" );
	self.sound = nil;
	self:OnReset();
end
----------------------------------------------------------------------------------------
function ClearingVehicleRadio:OnPropertyChange()
	if (self.sound == nil or self.Properties.bLoop ~= self.loop) then
		if (self.started==1) then
			self:PlaySound();
			--Hud:AddMessage("$4 client starts again (OnPropertyChange",4);
		end
		self.loop = self.Properties.bLoop;
	end
	self:OnReset();
	if (self.sound ~= nil) then
		if (self.Properties.bLoop~=0) then
			Sound:SetSoundLoop(self.sound,1);
		else
			Sound:SetSoundLoop(self.sound,0);
		end;
		Sound:SetMinMaxDistance(self.sound,self.Properties.InnerRadius,self.Properties.OuterRadius);
		Sound:SetSoundVolume(self.sound,self.Properties.iVolume);
		Sound:SetSoundProperties(self.sound,self.Properties.fFadeValue);			
	end;
end

----------------------------------------------------------------------------------------
function ClearingVehicleRadio:OnReset()
	s_DopplerEnable = 0;
	s_DopplerValue = 1;
	self.radioimage = nil;
	self.radioimage=System:LoadImage(self.Properties.RadioImage.textureImage);
	self._vehiclename = nil;   
	self:NetPresent(nil);
    self.bEnabled=self.Properties.bEnabled;
	--self._vehiclename = nil;
	if (self.Properties.bPlay == 0 and self.sound ~= nil) then
		self:StopSound();
	end

	if (self.Properties.bPlay~=0 and self.started == 0) then
		self:PlaySound();
		--Hud:AddSubtitle("$4 client starts again (OnReset",4);
	end
	self.Client:OnMove();

	self.bindtodestroyedvehicle = 0;
	--Hud:AddSubtitle("seto to 0 in 109  self.bindtodestroyedvehicle = "..self.bindtodestroyedvehicle,4);							
	self.started = 0; --
	
	s_DopplerEnable = self.Properties.bEnableDoppler;
	s_DopplerValue = self.Properties.DopplerValue;	
	--self:Event_Stop( sender );     --??  caus big performancedrops ??? 
end

----------------------------------------------------------------------------------------
function ClearingVehicleRadio:PlaySound()
	--Hud:AddSubtitle("soundspot :play sound triggered",4);
		
			if (self.bEnabled == 0 ) then 
				do return end;
			end

			if (self.sound == nil) then
				self:LoadSnd();
				if (self.sound == nil) then
					return;
				end;
			end;

			if (self.Properties.bLoop~=0) then
				Sound:SetSoundLoop(self.sound,1);
			else
				Sound:SetSoundLoop(self.sound,0);
			end;

			
					--if (not self.vehicleradio) then self.vehicleradio = Sound:Load3DSound("sounds\\radiostation\\song13.wav",0,255,9,500); end
					--Hud:AddSubtitle("self.vehicleradio created ",5);
			--Hud:AddMessage("Radio Wave started, Press R to switch Radio Off",4);	


			Sound:SetSoundPosition(self.sound,self:GetPos());
			Sound:SetMinMaxDistance(self.sound,self.Properties.InnerRadius,self.Properties.OuterRadius);
			Sound:SetSoundVolume(self.sound,self.Properties.iVolume);

			if( Sound:IsPlaying(self.sound) )then
				Sound:StopSound(self.sound);
				--self.sound =self._sound[random(1, 13)];
				--self:LoadSnd();				
				self:Event_NextTrack(sender );
				--Hud:AddMessage("$1 next track inside jumped",4);		--is never here
			end
			--self.sound =self._sound[random(1, 13)];
			--self:LoadSnd();
			--Hud:AddMessage("radiotrack changed",4);	
			Sound:PlaySound(self.sound);
			--Hud:AddMessage("$4 client starts again (Play sound",4);
			--_StopLoopAfterTimer = self.Properties.StopLoopAfter; 
			--System:LogToConsole( "Play Sound" );
			self.started = 1;


	
	
end

----------------------------------------------------------------------------------------
function ClearingVehicleRadio:Event_NextTrack( sender )
	if (self.Properties.bPlay == 0 and self.sound ~= nil) then
		self:StopSound();
	end
	self:StopSound();
	BroadcastEvent( self,"NextTrack" );
	self.sound = nil;
	self:OnReset();
end
---------------------------------------------------------------------------------------
function ClearingVehicleRadio:PlaySoundNight()

	if (self.bEnabled == 0 ) then 
		do return end;
	end

		self:LoadSnd();
		if (self.sound == nil) then
			return;
		end;
	

	if (self.Properties.bLoop~=0) then
		Sound:SetSoundLoop(self.sound,1);
	else
		Sound:SetSoundLoop(self.sound,0);
	end;


	Sound:SetSoundPosition(self.sound,self:GetPos());
	Sound:SetMinMaxDistance(self.sound,self.Properties.InnerRadius,self.Properties.OuterRadius);
	Sound:SetSoundVolume(self.sound,self.Properties.iVolume);

	if( Sound:IsPlaying(self.sound) )then
		Sound:StopSound(self.sound);
	end
	Sound:PlaySoundNight(self.sound);
	--System:LogToConsole( "Play Sound" );
	self.started = 1;
end

----------------------------------------------------------------------------------------





function ClearingVehicleRadio:StopSound()

	if (self.bEnabled == 0 ) then 
		do return end;
	end

--	if (self.sound ~= nil and Sound:IsPlaying(self.sound) ) then
	if (self.sound ~= nil ) then
		Sound:StopSound(self.sound);
		--System:LogToConsole( "Stop Sound" );
		--Hud:AddMessage("$1 stopped",4);		

		
			
		self.sound = nil;
	end
	self.started = 0;

	
end

----------------------------------------------------------------------------------------
function ClearingVehicleRadio:LoadSnd()
	if (self.sound ~= nil) then
		self:StopSound();
	end
	
	--Hud:AddSubtitle("load sound routine  self.bindtodestroyedvehicle = "..self.bindtodestroyedvehicle,4);	

		--if (self.Properties.sndSource ~= "") then	
		--	local sndFlags = bor(SOUND_RADIUS,SOUND_OCCLUSION);
		--	self.sound = Sound:Load3DSound(self.Properties.sndSource,sndFlags);
		--	Sound:SetSoundProperties(self.sound,self.Properties.fFadeValue);			
		--end
		--self.soundName = self.Properties.sndSource;


			local sndFlags = bor(SOUND_RADIUS,SOUND_OCCLUSION);
----------------> fixme, after 3 seconds destroyed radio state it loads again a valid track ----------------------
--		if self._vehiclename and self._vehiclename.fEngineHealth >= self.Properties.RadioMinHealth then
			if self.Properties.RadioChannels.sndChannel01 == "" then	self.Properties.RadioChannels.sndChannel01	= "sounds\\radiostation\\song1.wav"; end	
			if self.Properties.RadioChannels.sndChannel02 == "" then	self.Properties.RadioChannels.sndChannel02	= "sounds\\radiostation\\song1.wav"; end
			if self.Properties.RadioChannels.sndChannel03 == "" then	self.Properties.RadioChannels.sndChannel03	= "sounds\\radiostation\\song1.wav"; end
			if self.Properties.RadioChannels.sndChannel04 == "" then	self.Properties.RadioChannels.sndChannel04	= "sounds\\radiostation\\song1.wav"; end
			if self.Properties.RadioChannels.sndChannel05 == "" then	self.Properties.RadioChannels.sndChannel05	= "sounds\\radiostation\\song1.wav"; end
			if self.Properties.RadioChannels.sndChannel06 == "" then	self.Properties.RadioChannels.sndChannel06	= "sounds\\radiostation\\song1.wav"; end
			if self.Properties.RadioChannels.sndChannel07 == "" then	self.Properties.RadioChannels.sndChannel07	= "sounds\\radiostation\\song1.wav"; end
			if self.Properties.RadioChannels.sndChannel08 == "" then	self.Properties.RadioChannels.sndChannel08	= "sounds\\radiostation\\song1.wav"; end
			if self.Properties.RadioChannels.sndChannel09 == "" then	self.Properties.RadioChannels.sndChannel09	= "sounds\\radiostation\\song1.wav"; end
			if self.Properties.RadioChannels.sndChannel10 == "" then	self.Properties.RadioChannels.sndChannel10	= "sounds\\radiostation\\song1.wav"; end
			if self.Properties.RadioChannels.sndChannel11 == "" then	self.Properties.RadioChannels.sndChannel11	= "sounds\\radiostation\\song1.wav"; end
			if self.Properties.RadioChannels.sndChannel12 == "" then	self.Properties.RadioChannels.sndChannel12	= "sounds\\radiostation\\song1.wav"; end
			if self.Properties.RadioChannels.sndChannel13 == "" then	self.Properties.RadioChannels.sndChannel13	= "sounds\\radiostation\\song1.wav"; end			
			
			self._sound = {
				

				Sound:Load3DSound(self.Properties.RadioChannels.sndChannel01,sndFlags),
				Sound:Load3DSound(self.Properties.RadioChannels.sndChannel02,sndFlags),
				Sound:Load3DSound(self.Properties.RadioChannels.sndChannel03,sndFlags),
				Sound:Load3DSound(self.Properties.RadioChannels.sndChannel04,sndFlags),
				Sound:Load3DSound(self.Properties.RadioChannels.sndChannel05,sndFlags),
				Sound:Load3DSound(self.Properties.RadioChannels.sndChannel06,sndFlags),
				Sound:Load3DSound(self.Properties.RadioChannels.sndChannel07,sndFlags),
				Sound:Load3DSound(self.Properties.RadioChannels.sndChannel08,sndFlags),
				Sound:Load3DSound(self.Properties.RadioChannels.sndChannel09,sndFlags),
				Sound:Load3DSound(self.Properties.RadioChannels.sndChannel10,sndFlags),
				Sound:Load3DSound(self.Properties.RadioChannels.sndChannel11,sndFlags),
				Sound:Load3DSound(self.Properties.RadioChannels.sndChannel12,sndFlags),
				Sound:Load3DSound(self.Properties.RadioChannels.sndChannel13,sndFlags),
			}					
--			Hud:AddSubtitle("valid song loaded",4);	
--		else
--				self.destroyedsound = Sound:Load3DSound("Sounds\\radiovoices\\aistatic.wav",sndFlags);	
--				self.sound =self.destroyedsound;
--		end




			
		self.destroyedsound = Sound:Load3DSound("Sounds\\radiovoices\\aistatic.wav",sndFlags);	

		if not self.startmeonetime then  --means have never played
			self.sound =self._sound[random(1, 13)];
		end

		if self.startmeonetime == 2 then  --means is already  playing and makes channelswitch without radiomessage
			self.sound =self._sound[random(1, 13)];
		end

			

		if self.startmeonetime == 0 then  --means is already  playing but  muted
			self.sound =self._sound[random(1, 13)];
			if not self.storesoundname then self.storesoundname =self.sound; end
		else
			--self.sound = self.storesoundname;
			--Hud:AddMessage("stored songname written back",4);		
			self.sound =self._sound[random(1, 13)];
		end			
		if  (self.bindtodestroyedvehicle == 0) then 
			self.onemessageisenough = nil;
		end
		
		if  (self.bindtodestroyedvehicle == 1) then 
			self.destroyedsound = Sound:Load3DSound("Sounds\\radiovoices\\aistatic.wav",sndFlags);	
			self.sound =self.destroyedsound;
		end
			Sound:SetSoundProperties(self.sound,self.Properties.fFadeValue);			
			--self.sound =self._sound[random(1, 4)];   --delete me
			self.soundName = self.sound;
			--Hud:AddMessage("radio is playing",4);		
	
end

----------------------------------------------------------------------------------------
--------------------------pvcfmod---------------------
function ClearingVehicleRadio:Event_Play( sender )


	if(self.Properties.bOnce~=0 and self.started~=0) then
		return
	end
	--self.update=1;
	self:PlaySound();
	--Hud:AddMessage("$4 client starts again (eventplay sound",4);
	BroadcastEvent( self,"Play" );
end

-------------------------------------------------------------------------------
-- Stop Event
-------------------------------------------------------------------------------
function ClearingVehicleRadio:Event_Stop( sender )
	self:StopSound();
	BroadcastEvent( self,"Stop" );
end

function ClearingVehicleRadio:Event_Enable( sender )
	self.bEnabled = 1;
	BroadcastEvent( self,"Enable" );
end

function ClearingVehicleRadio:Event_Disable( sender )
	self.bEnabled = 0;
	BroadcastEvent( self,"Disable" );
	
end


function ClearingVehicleRadio:Event_Redirect( sender )
	BroadcastEvent( self,"Redirect" );
end

---------------------------------------------------------------------------------------------------------------------------------------------
function ClearingVehicleRadio:SwitchRadio()		
	if not self.switchsound then self.switchsound=Sound:LoadSound("sounds\\items\\WEAPON_FIRE_MODE.wav");   end
	Sound:SetSoundVolume(self.switchsound,255);
	Sound:PlaySound(self.switchsound);			
end

function ClearingVehicleRadio:SwitchChannel()		
	if not self.switchchannelsound then self.switchchannelsound=Sound:LoadSound("sounds\\items\\tv_static.wav");   end
	Sound:SetSoundVolume(self.switchchannelsound,145);
	Sound:PlaySound(self.switchchannelsound);			
	
end

			
function ClearingVehicleRadio:OnUpdate()		
	
	--if (_localplayer.theVehicle) then
	--	Hud:AddMessage("player is in a vehicle",4);
	--end
	
	
	if (self.Properties.bEnabled~= 0 ) then 			
		--local _time = System:GetCurrTime();
		--_time = floor(_time);
		--Hud.label="System:GetCurrTime...".._time;
		--Hud.label="Playing Radio";

			if (Sound:IsPlaying(self.sound)) then			
				--Hud:AddMessage("is playing in on update detected",4);	
					--local vehicle=_localplayer.cnt:GetCurVehicle(); 
					--if(vehicle) then					
						--self:SetSoundPosition( self.sound,vehicle:GetPos() );		
					--	self:SetPos(vehicle:GetPos());
					--Hud.label="Player in Vehicle detected, radio is waiting commands and working";
					--	s_DopplerEnable = "0";  --is switched on in vehicle common after leave
					--end 
				clearingradioisactive = 1;
			else
				if (self.Properties.bRadioMode == 1)  then
					--self:Event_NextTrack( sender );			
					BroadcastEvent( self,"NextTrack" );
					self.sound = nil;
					self:OnReset();
				end	
			end
		
		 if not self.radiostopped then self.radiostopped =1; end		
		if (_localplayer.theVehicle) then  --all types of vehicle, even boat, paraglider, parachute
				local vehicle=_localplayer.cnt:GetCurVehicle();
				if not vehicle then return; end   --emergency break routine if player cannot enter vehicle for some reasons
				self._vehiclename = System:GetEntityByName(vehicle:GetName());
				 --self._vehiclename = vehicle:GetName();
				--Hud:AddMessage( "vehicle detected    ".._vehiclename );
				if  vehicle.bnoRadio == 1 then 
					self.radiostopped = 1;
					--return --we dont want radio in inflatable and paraglider --make problems
				end 
				
				if not self.startmeonetime or self.startmeonetime == 0   and vehicle.bnoRadio ~= 1 then 
					if opcl_messagelevel == "1" then  -- 1=GTA hud style , 0=more decent hud style 			
						Hud:AddMessage("$1R to switch Radio $4On $1/$4Off        $1N to switch $4Channel",4);
					end																			
					self.startmeonetime = 1;
					if self.Properties.bEnableDoppler == 0 then	
						s_DopplerEnable = "0"; --switching sounds baaaaaaaad
					else
						s_DopplerEnable = "1";
					end
				end		
				
				
				
				
				--Hud.label="radio bind to vehicle";
				--local key=Input:GetXKeyDownName();   --detects realtime keypressing
				local key=Input:GetXKeyPressedName();  --detects only one keypress
				--------------------------------radio OFF----------------------------------------
				if (key == "r") and self.radiostopped ==0  and vehicle.bnoRadio ~= 1 then				
					--Sound:StopSound(self.vehicleradio);		--i dont stop the sound, instead i teleport away the soundspot
					self:SwitchRadio();
					self.radiostopped = 1;
					if opcl_messagelevel == "1" then  -- 1=GTA hud style , 0=more decent hud style 			
						Hud:AddMessage( "$1Radio $4 OFF" );
					end
					key = nil;
				end
				------------------------nexttrack----------------------------------------------------
				if (key == "n") and self.radiostopped ==0  and vehicle.bnoRadio ~= 1  then
				  self:SwitchRadio();
				  self.startmeonetime = 2;
				  --self.sound = nil;
				  --self:LoadSnd();
				  self:Event_NextTrack( sender );
				  if opcl_messagelevel == "1" then  -- 1=GTA hud style , 0=more decent hud style 			
					  --Hud:AddMessage( "" );
					  Hud:AddMessage( "$1Next Channel ..." );
					  Hud:AddMessage( "" );
				  end
				  self:SwitchChannel();				  
				  if self.Properties.PlaySwitchAnimation ~= ""   and vehicle.bnoRadio ~= 1 then
				  	_localplayer:StartAnimation(0,self.Properties.PlaySwitchAnimation,0,0.5,1,0);	
				  	vehicle.cnt:AnimateUsers( 3 );       --cnt:AnimateUsers( 7 ); 
				  end
				end
				--------------------------------radio ON----------------------------------------
				if (key == "r") and self.radiostopped ==1  and vehicle.bnoRadio ~= 1  then				
					if not self.startmeonetime then 
						self:SwitchRadio();		
						--self.vehicleradio =self.rndradiotracks[random(1, 13)];						
						Sound:PlaySound(self.vehicleradio);
						--Hud:AddMessage( "play sound triggered" );
						self.startmeonetime = 1;
					end
					self:SwitchRadio();
					self.radiostopped = 0;
					if opcl_messagelevel == "1" then  -- 1=GTA hud style , 0=more decent hud style 			
						Hud:AddMessage( "$1Radio $4 ON" );
					end
					if self.bindtodestroyedvehicle == 1 and vehicle.bnoRadio ~= 1 then
						if opcl_messagelevel == "1" then  -- 1=GTA hud style , 0=more decent hud style 			
							Hud:AddMessage( "$1Radio damaged, need a Repair !" );
						end
					end
					key = nil;
				end
				-------------------------bind radio to vehicle-----------------------------
				if self.radiostopped == 0 then      --player is in vehicle and radio is playing
					--Sound:SetSoundPosition(self.vehicleradio,self:GetPos());
					--local vehicle=_localplayer.cnt:GetCurVehicle();
						self:SetPos(vehicle:GetPos());
						clearingradioisactiveANDplaying = 1;
						
				--------------///////////////////////////////////////////////////////////Radio image and Equalizer/////////////////////////////////////////////////////////////-------------------------


					if self.Properties.bShowRadioImage == 1 and self.Properties.RadioImage.textureImage ~= "" then
		
	if not self.switchtoimage then self.switchtoimage = 0; end

		if self.switchtoimage == 0 then
			------------------------------------------------------reduces the update per frame amount-------------------------
			if(not self.imagetextswitcher1)then self.imagetextswitcher1=System:GetCurrTime(); end				
			if(System:GetCurrTime()-self.imagetextswitcher1>3) then
			------------------------------------------------------reduces the update per frame amount-------------------------
							self.switchtoimage = 1;
			------------------------------------------------------reduces the update per frame amount-------------------------								
			self.imagetextswitcher1=nil;
			end 	 	
			------------------------------------------------------reduces the update per frame amount-------------------------		
		end
		
		
		if self.switchtoimage == 1 then
			------------------------------------------------------reduces the update per frame amount-------------------------
			if(not self.imagetextswitcher2)then self.imagetextswitcher2=System:GetCurrTime(); end				
			if(System:GetCurrTime()-self.imagetextswitcher2>3) then
			------------------------------------------------------reduces the update per frame amount-------------------------
							self.switchtoimage = 0;
			------------------------------------------------------reduces the update per frame amount-------------------------								
			self.imagetextswitcher2=nil;
			end 	 	
			------------------------------------------------------reduces the update per frame amount-------------------------		
		end

	end    --if self.Properties.bShowRadioImage == 1 and self.Properties.RadioImage.textureImage ~= "" then

						---------------------show radiotext------------------------------------------------------
		if self.Properties.bShowRadioImage == 1 and self.Properties.RadioImage.textureImage ~= "" and self.switchtoimage == 0 then	

			local layer = self.Properties.RadioImage.layer; 
  			local alpha = self.Properties.RadioImage.alpha;
  			local widh = self.Properties.RadioImage.widh; 
  			local high = self.Properties.RadioImage.high;
        		local x = self.Properties.RadioImage.x; 
        		local y = self.Properties.RadioImage.y; 
  			if not self.radioimagetext then
      			self.radioimagetext=System:LoadImage("Textures\\gui\\vehicleradio2_8_alpha.dds");
  			end	
			%System:DrawImageColor(self.radioimagetext, x, y, widh, high, layer, 1, 1, 4, alpha); 



        		local x = self.Properties.RadioImage.x + self.Properties.RadioImage.TextXoffset; 
        		local y = self.Properties.RadioImage.y + self.Properties.RadioImage.TextYoffset; 			
			local alpha = 1;
			local element = Hud.txi.radiochannel1;
			local masklenght = 0;
			
			if not self.posoffset then self.posoffset = 90; end	
			
				
			

								------------------------------------------------------reduces the update per frame amount-------------------------
					if(not self.scrolltimer)then self.scrolltimer=System:GetCurrTime(); end				
					if(System:GetCurrTime()-self.scrolltimer>0.1) then
								------------------------------------------------------reduces the update per frame amount-------------------------
								if self.posoffset > masklenght then
									self.posoffset = self.posoffset - 3;
									--x = self.Properties.RadioImage.x + self.posoffset;
								else
									self.posoffset = 90;
								end
								
								------------------------------------------------------reduces the update per frame amount-------------------------								
					self.scrolltimer=nil;
					end 	 	
								------------------------------------------------------reduces the update per frame amount-------------------------				

			x = self.Properties.RadioImage.x + self.Properties.RadioImage.TextXoffset + self.posoffset/2 ;
			Hud:DrawGauge(x, y, self.posoffset, 100, element, 1, 1, 1, alpha, 0, 0);			







--			 self.textradiochannel = "RadioChannel";
--			%Game:SetHUDFont("default","default");
-- 			%Game:WriteHudString(  			
--  				   self.Properties.RadioImage.x + self.Properties.RadioImage.TextXoffset,    --x pos  
--                       self.Properties.RadioImage.y + self.Properties.RadioImage.TextYoffset,    --y pos   
--                       self.textradiochannel,
--                       200,  -- r 
--                       200,  -- g
--                       200,  -- b
--                       50,    	 --a
--                       self.Properties.RadioImage.TextsizeX,  -- x width  --20
--                       self.Properties.RadioImage.TextsizeY   --y hight  --20
--                       );		
                       --Hud.label=self.textradiochannel.."    at  textpos x"..self.Properties.RadioImage.x + self.Properties.RadioImage.TextXoffset.."     y "..self.Properties.RadioImage.y + self.Properties.RadioImage.TextYoffset;
                       
			end --if self.Properties.bShowRadioImage == 1 and self.Properties.RadioImage.textureImage ~= "" and self.switchtoimage == 0 then	
				---------------------show radiotext end------------------------------------------------------





				---------------------show image and equalizer------------------------------------------------------
					if self.Properties.bShowRadioImage == 1 and self.Properties.RadioImage.textureImage ~= "" and self.switchtoimage == 1 then						
	
							local layer = self.Properties.RadioImage.layer; 
  							local alpha = self.Properties.RadioImage.alpha;
  							local widh = self.Properties.RadioImage.widh; 
  							local high = self.Properties.RadioImage.high;
        						local x = self.Properties.RadioImage.x; 
        						local y = self.Properties.RadioImage.y; 
  							if not self.radioimage then
      							self.radioimage=System:LoadImage(self.Properties.RadioImage.textureImage);
  							end	
							%System:DrawImageColor(self.radioimage, x, y, widh, high, layer, 1, 1, 4, alpha); 
		
		
		
							
							-------equalizer      1-----------------------------------------
  							if not self.radioimageEQ then
      							self.radioimageEQ=System:LoadImage("Textures\\gui\\radioeq2.dds");
  							end
  							local yEQoffset = self.Properties.RadioImage.yEQoffset;
  							local xEQoffset = self.Properties.RadioImage.xEQoffset;
  							if not self.eqhigh1 then self.eqhigh1 = random(1,5); end
								------------------------------------------------------reduces the update per frame amount-------------------------
					if(not self.eqtimer1)then self.eqtimer1=System:GetCurrTime(); end				
					if(System:GetCurrTime()-self.eqtimer1>self.Properties.RadioImage.EQTimer) then
								------------------------------------------------------reduces the update per frame amount-------------------------
								self.eqhigh1 = random(0,4);
								self.eqhigh2 = random(1,4);
								self.eqhigh3 = random(1,5);
								self.eqhigh4 = random(1,5);
								------------------------------------------------------reduces the update per frame amount-------------------------								
					self.eqtimer1=nil;
					end 	 	
								------------------------------------------------------reduces the update per frame amount-------------------------					  							
  							
  							
							local yhighoffset = self.Properties.RadioImage.EQspaceY;
							local alpha = 1;
							local EQwidh = self.Properties.RadioImage.EQwidh;
							local EQhigh = self.Properties.RadioImage.EQhigh;
							--Hud.label="eq random"..self.eqhigh;
							if self.eqhigh1 == 0 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 
							elseif self.eqhigh1 == 1 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
							elseif self.eqhigh1 == 1 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);
							elseif self.eqhigh1 == 2 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);
							elseif self.eqhigh1 == 3 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 3*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);																
							elseif self.eqhigh1 == 4 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 3*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 4*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);																	
							elseif self.eqhigh1 == 5 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 3*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 4*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 5*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);
							elseif self.eqhigh1 == 6 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 3*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 4*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 5*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 6*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);
							end
							
							
							

					-------------equalizer      2-----------------------------------------

  							local yEQoffset = self.Properties.RadioImage.yEQoffset;
  							local xEQoffset = self.Properties.RadioImage.xEQoffset + 1*self.Properties.RadioImage.EQwidh + 1*self.Properties.RadioImage.EQspace;
  							if not self.eqhigh2 then self.eqhigh2 = random(1,5); end
			  							
  							  							
							local yhighoffset = self.Properties.RadioImage.EQspaceY;
							local alpha = 1;
							local EQwidh = self.Properties.RadioImage.EQwidh;
							local EQhigh = self.Properties.RadioImage.EQhigh;
							--Hud.label="eq random"..self.eqhigh2;
							if self.eqhigh2 == 1 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
							elseif self.eqhigh2 == 1 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);
							elseif self.eqhigh2 == 2 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);
							elseif self.eqhigh2 == 3 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 3*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);																
							elseif self.eqhigh2 == 4 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 3*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 4*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);																	
							elseif self.eqhigh2 == 5 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 3*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 4*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 5*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);
							elseif self.eqhigh2 == 6 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 3*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 4*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 5*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 6*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);
							end							
							
							








					-------------equalizer      3-----------------------------------------

  							local yEQoffset = self.Properties.RadioImage.yEQoffset;
  							local xEQoffset = self.Properties.RadioImage.xEQoffset + 2*self.Properties.RadioImage.EQwidh + 2*self.Properties.RadioImage.EQspace;
  							if not self.eqhigh3 then self.eqhigh3 = random(1,5); end
			  							
  							  							
							local yhighoffset = self.Properties.RadioImage.EQspaceY;
							local alpha = 1;
							local EQwidh = self.Properties.RadioImage.EQwidh;
							local EQhigh = self.Properties.RadioImage.EQhigh;
							--Hud.label="eq random"..self.eqhigh3;
							if self.eqhigh3 == 1 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
							elseif self.eqhigh3 == 1 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);
							elseif self.eqhigh3 == 2 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);
							elseif self.eqhigh3 == 3 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 3*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);																
							elseif self.eqhigh3 == 4 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 3*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 4*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);																	
							elseif self.eqhigh3 == 5 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 3*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 4*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 5*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);
							elseif self.eqhigh3 == 6 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 3*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 4*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 5*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 6*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);
							end							





					-------------equalizer      4-----------------------------------------

  							local yEQoffset = self.Properties.RadioImage.yEQoffset;
  							local xEQoffset = self.Properties.RadioImage.xEQoffset + 3*self.Properties.RadioImage.EQwidh + 3*self.Properties.RadioImage.EQspace;
  							if not self.eqhigh4 then self.eqhigh4 = random(1,5); end
			  							
  							  							
							local yhighoffset = self.Properties.RadioImage.EQspaceY;
							local alpha = 1;
							local EQwidh = self.Properties.RadioImage.EQwidh;
							local EQhigh = self.Properties.RadioImage.EQhigh;
							--Hud.label="eq random"..self.eqhigh4;
							if self.eqhigh4 == 1 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
							elseif self.eqhigh4 == 1 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);
							elseif self.eqhigh4 == 2 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);
							elseif self.eqhigh4 == 3 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 3*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);																
							elseif self.eqhigh4 == 4 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 3*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 4*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);																	
							elseif self.eqhigh4 == 5 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 3*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 4*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 5*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);
							elseif self.eqhigh4 == 6 then
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 0*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha); 							
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 1*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 2*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 3*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 4*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);									
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 5*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);								
								%System:DrawImageColor(self.radioimageEQ, xEQoffset, yEQoffset - 6*yhighoffset, EQwidh, EQhigh, layer, 1, 1, 4, alpha);
							end			


							
							--------eq fall down-----------------
								------------------------------------------------------reduces the update per frame amount-------------------------
					if(not self.eqtimerfalldown)then self.eqtimerfalldown=System:GetCurrTime(); end				
					if(System:GetCurrTime()-self.eqtimerfalldown>self.Properties.RadioImage.EQFallDownTimer ) then
								------------------------------------------------------reduces the update per frame amount-------------------------
							if self.eqhigh1 > 0 then self.eqhigh1 = self.eqhigh1 - 1; end
							if self.eqhigh2 > 1 then self.eqhigh2 = self.eqhigh2 - 1; end
							if self.eqhigh3 > 1 then self.eqhigh2 = self.eqhigh3 - 1; end
							if self.eqhigh4 > 1 then self.eqhigh2 = self.eqhigh4 - 1; end								------------------------------------------------------reduces the update per frame amount-------------------------								
					self.eqtimerfalldown=nil;
					end 	 	
								------------------------------------------------------reduces the update per frame amount-------------------------									


									
							
							
							-------equalizer-----------------------------------------
						end --if self.Properties.bShowRadioImage == 1 and self.Properties.RadioImage.textureImage ~= "" and self.switchtoimage == 1 then
		--------------///////////////////////////////////////////////////////////Radio image and Equalizer end/////////////////////////////////////////////////////////////-------------------------						
						
						
				else
					clearingradioisactiveANDplaying = 0;    --player is in vehicle but radio is not playing
					local tempPosPlayer = {x=0, y=0,z=0}							
    					tempPosPlayer.x = self:GetPos().x
     				tempPosPlayer.y = self:GetPos().y
     				tempPosPlayer.z = self:GetPos().z
					--Sound:SetSoundPosition(self.vehicleradio,{x=tempPosPlayer.x,y=tempPosPlayer.y,z=tempPosPlayer.z +89});
					self:SetPos({x=tempPosPlayer.x,y=tempPosPlayer.y,z=tempPosPlayer.z + (self.Properties.offAddition) });
					
				end
				
				if self._vehiclename and self._vehiclename.fEngineHealth <= self.Properties.RadioMinHealth and vehicle.bnoRadio ~= 1 then
					self.bindtodestroyedvehicle = 1; -- change to destroyed radiostate
				------------------------------------------------------reduces the update per frame amount-------------------------
					if(not self._brokenradiotimer)then self._brokenradiotimer=System:GetCurrTime(); end				
					if(System:GetCurrTime()-self._brokenradiotimer>1) then
				------------------------------------------------------reduces the update per frame amount-------------------------
					self:Event_NextTrack( sender );
					if not self.onemessageisenough then 
					self.onemessageisenough = 1;
					if opcl_messagelevel == "1" then  -- 1=GTA hud style , 0=more decent hud style 			 					
						Hud:AddMessage( "$1Radio damaged, need a Repair !" );
					end
					end 					
				------------------------------------------------------reduces the update per frame amount-------------------------					
					self._brokenradiotimer=nil;
					end 	 	
				------------------------------------------------------reduces the update per frame amount-------------------------					
				else					
					if self.bindtodestroyedvehicle == 1 then 
						self.bindtodestroyedvehicle = 0; 
						--Hud:AddSubtitle("seto to 0 in 505  self.bindtodestroyedvehicle = "..self.bindtodestroyedvehicle,4);	
						self:LoadSnd();
					end
				end

		else   --player is now outside a vehicle
			self.startmeonetime = 0;
					if (self._vehiclename) and self._vehiclename.fEngineHealth and (self._vehiclename.fEngineHealth <= self.Properties.RadioMinHealth) then
					self.bindtodestroyedvehicle = 1; -- change to destroyed radiostate
				------------------------------------------------------reduces the update per frame amount-------------------------
					if(not self._brokenradiotimeroutside)then self._brokenradiotimeroutside=System:GetCurrTime(); end				
					if(System:GetCurrTime()-self._brokenradiotimeroutside>1) then
				------------------------------------------------------reduces the update per frame amount-------------------------
					self:Event_NextTrack( sender );
					if not self.onemessageisenough then 
					self.onemessageisenough = 1; 					
						--Hud:AddMessage( "Radio damaged, need a Repair !" );
					end 					
				------------------------------------------------------reduces the update per frame amount-------------------------					
					self._brokenradiotimeroutside=nil;
					end 	 	
				------------------------------------------------------reduces the update per frame amount-------------------------					
				else					
					if self.bindtodestroyedvehicle == 1 then 
						self.bindtodestroyedvehicle = 0; 
						--Hud:AddSubtitle("seto to 0 in 530  self.bindtodestroyedvehicle = "..self.bindtodestroyedvehicle,4);							
						self:LoadSnd();
					end
				end

				------------player is outside of vehicle----------------------------------------------------------						
		
					if (self._vehiclename) and (self.radiostopped == 0) then  --we bind radio to moving vehicle if player is outside too						
						if  self._vehiclename.bnoRadio == 1 then return end --we dont want radio in inflatable and paraglider
						local tempPosPlayer = {x=0, y=0,z=0}							
    						tempPosPlayer.x = self._vehiclename:GetPos().x
     					tempPosPlayer.y = self._vehiclename:GetPos().y
     					tempPosPlayer.z = self._vehiclename:GetPos().z
						self:SetPos({x=tempPosPlayer.x,y=tempPosPlayer.y,z=tempPosPlayer.z + 12 });  -- + 10z try to make radio outside of vehicle more quiet
						--Hud:AddMessage( "player outside from vehicle, radio is in working state and switched on" );
					end	
					if (self._vehiclename) and (self.radiostopped == 1) then --we bind muted radio to moving vehicle
						local tempPosPlayer = {x=0, y=0,z=0}							
    						local user = _localplayer;  --self
    						if not _localplayer then user = self; end  --fallbackroutine
    						tempPosPlayer.x = user:GetPos().x
     					tempPosPlayer.y = user:GetPos().y
     					tempPosPlayer.z = user:GetPos().z
						self:SetPos({x=tempPosPlayer.x,y=tempPosPlayer.y,z=tempPosPlayer.z + (self.Properties.InnerRadius*30) });					
					end
					if (self._vehiclename) and (self._vehiclename.IsBroken == 1) then  --we mute the radio and bind to the player
					  --Hud:AddMessage( "vehicle broken detected" );
						local tempPosPlayer = {x=0, y=0,z=0}							
    						local user = self;
    						tempPosPlayer.x = user:GetPos().x
     					tempPosPlayer.y = user:GetPos().y
     					tempPosPlayer.z = user:GetPos().z
						self:SetPos({x=tempPosPlayer.x,y=tempPosPlayer.y,z=tempPosPlayer.z + (self.Properties.InnerRadius*30) });
					end
			
		end --if (_localplayer.theVehicle) then
		
		
		
		
		
		
		
		
		
		
		
	end  --if (self.Properties.bEnabled~= 0 ) then 			
	
end			
			
----------------------------------------------------------------------------------------
ClearingVehicleRadio["Server"] = {
	OnInit= function (self)
		self:EnableUpdate(0);
		self.started = 0;
	end,
	OnShutDown= function (self)
	end,
}

----------------------------------------------------------------------------------------
ClearingVehicleRadio["Client"] = {
	----------------------------------------------------------------------------------------
	OnInit = function(self)
		self:EnableUpdate(0);
		--System:LogToConsole("OnInit");
		self.started = 0;
		self.loop = self.Properties.bLoop;
		self.soundName = "";

		if (self.Properties.bPlay==1) then
			self:PlaySound();
			--Hud:AddMessage("$4 client starts again",4);		--nope
			--System:LogToConsole("Play sound"..self.Properties.sndSource);
		end
		self.Client:OnMove();
	end,
	----------------------------------------------------------------------------------------
	OnShutDown = function(self)
		self:StopSound();
	end,

	----------------------------------------------------------------------------------------
	OnMove = function(self)
		if (self.sound ~= nil) then
			Sound:SetSoundPosition( self.sound,self:GetPos() );		
				--Hud:AddMessage("$4 client OnMove set pos triggered",4);		--nope
		end;

	end,
	----------------------------------------------------------------------------------------
}
