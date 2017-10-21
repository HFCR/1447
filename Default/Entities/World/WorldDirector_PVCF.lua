--------------------------pvcfmod---------------------(enabled all sender)
--is started automaticly at levelstart
--can randomly start 9 different weather triggers
--can start daynight trigger after a time in seconds at first levelstart
--can stop a daynight trigger after a time in seconds after daynight triggerstart
--added the option "press use key to start game" picture at start/reset of the game
--added 		nStartWeaponslotAmount 
--added		nStartDollarAmount
--added		nPercentHealth 
--added		nPercentWellFed   --need correct given clearingdaynight trigger name
--added     globaldaytime for start, needed for bugtesting the fog.lua which now reacts on day night change
--added  food percentage now dont need a clearingdaynight trigger name, it can also work "offline" (for debug purposes)
--debugged load "play" behaviour for startmoney
--added trainfitness factor 
--added function to change player arm and weapon shader
--can now control if vegetation reacts on physic
--can now set player cam direction at start to fixed values, even in editor after reset
--can switch game to racing game 
--added for dynamic FPS distance range system min and max viewingrange
--can switch on off the standart crytec sun
--can switch on off shadow maps
--added flashlight battery scale factor
--removed the detach to weaponbone command on reset because it have removed the weaponshadow first time
--added map radar texture
--added radar texture
--added choosable map texture
--added 	ShowMedicDebugMessage and ShowCivilianDebugMessage
--added switch for player reachable by a medic (if player can be healed by a medic)
--added sun can be switched on after reset in editor mode, so that the map can be better edited
--added flashlight battery drain

Script:LoadScript("scripts/GUI/HudCommon.lua");
Script:LoadScript("scripts/GUI/Map.lua");

ClearingWorldDirector = {
	type = "Sound",
	rain = nil,
	daynight = nil,
	daynightstopped = 0,
	daynightstarted = 0,
	ballowstart=0,
	Iwasloaded=0,
	started=0,
	resettest = 0,
	

		
	Properties = {

		bAutomaticPlay=1,	-- Immidiatly start playing on spawn.
		bOnce=0,
		bEnabled=1,
		bShowStatus=0,
		bShowWorldTime=0,
		bWaitKeyOnStart = 0,
		bShowImageOnkeyStart = 1,
		texture_Image = "Textures\\gui\\pressusekey.dds",
		bClearMessageAtReset = 0,

		
--		colour_r = 0.02,    --temporarly used in hudcommon to find good colors for foodbar
--		colour_g = 0.02,  --search for self.cdw = System:GetEntityByName("ClearingWorldDirector1");
--		colour_b = 0.02,


	ClearingWorld = {
		iGlobalWorldTime = 12,	
		--bStartAboveWaterLevel = 1,
		bIsRacingGame = 0,
		bUseRaceSpeedScale = 0,
		RacingSavePosIntervall = 3,  --in seconds		
		SpeedChangeSwellSpeed = 22,		
		TrafficSpeedScale = 0.5,
		VhcleGrndVertFrictnScale = 3,		
		bCrytecSun = 0,
		bKeepMinViewRange = 0,
		KeepedMinViewRange = 256,
		KeepedMaxViewRange = 1024,
		bShadowMap = 1,
		ShadowMapViewDistRatio = 7,
		bShowMedicDebugMessage = 0,
		bShowCivilianDebugMessage = 0,
		--xSkyStart = 100,
		--xSkyEnd = 500,
		}, 
	

	
	
	MiniMap = {
		bShowAlways = 0,   --shows always the minimap
		LevelHeightmapSizeX = 2048,
		bMinimapToRadar = 0, 
		bEnableRadar = 1,
		texture_RadarTexture = "",    --use a choosed texture as radartexture
		texture_MapTexture = "",       --use a choosed texture for map
		}, 
		
			
	PlayerArmShader = {
		bInitOnStart = 0,
		weaponshader = "TemplBumpDiffuse",
		weaponshadernum = 4,		
		}, 
		
	ClearingPlayer = {
		bReachableByAMedic = 1,
		FlashLightDrain=0.5,  --   0.5     2.5  7.5 = very fast    --consumption speed of batteries from flashlight    --battery speed 
		nStartWeaponslotAmount = 3,
		nStartDollarAmount =0,
		nPercentHealth = 100,
		nPercentWellFed = 100,  --need correct given clearingdaynight trigger name
		nCamX = 0,
		nCamY = 0,
		nCamZ = 0,
		--nRockDamage = 22,
		}, 
	     	
	ClearingVegetation = {	
		bPhysicVegetationForce = 1,
         fVegetationReactRadius = 1.3,	-- range is 0-50          -- trees bending from  1,4 and above, below only bushes
	     fVegetationBendForce = 1,		-- range is 0-1       -- trees bending         				
		}, 

	RPGsimulation = {
		bTrainFitness = 1,
		Trainfactor = 4, --0.1 for fast testing
		}, 


    	   DayNight = {
    	   	StartAfter = -1, -- -1immediately		
		DayNightEntityName = "ClearingdaynightTrigger1",
		StopAtoClock = -1, -- -1 no stop  , valid numbers 1- 24
		bEnabledStart = 1, --needed for editor
		bActivateSunOnReset = 0,   --if reset the sun entitiy can be switched on for better level editing
		}, 

    	   Weather1 = {
    	   	nChance = 10,
		ChanceCheckEvery = 20,
		RainEntityName = "ClearingRain1",
		}, 
    	   Weather2 = {
    	   	nChance = 10,
		ChanceCheckEvery = 20,
		RainEntityName = "",
		}, 
    	   Weather3 = {
    	   	nChance = 10,
		ChanceCheckEvery = 20,
		RainEntityName = "",
		}, 
    	   Weather4 = {
    	   	nChance = 10,
		ChanceCheckEvery = 20,
		RainEntityName = "",
		}, 
    	   Weather5 = {
    	   	nChance = 10,
		ChanceCheckEvery = 20,
		RainEntityName = "",
		}, 
    	   Weather6 = {
    	   	nChance = 10,
		ChanceCheckEvery = 20,
		RainEntityName = "",
		}, 
    	   Weather7 = {
    	   	nChance = 10,
		ChanceCheckEvery = 20,
		RainEntityName = "",
		}, 
    	   Weather8 = {
    	   	nChance = 10,
		ChanceCheckEvery = 20,
		RainEntityName = "",
		}, 
    	   Weather9 = {
    	   	nChance = 10,
		ChanceCheckEvery = 20,
		RainEntityName = "",
		}, 






	},
	started=0,
	Editor={
		Model="Objects/Editor/opcl_world.cgf",
	},
	bEnabled=1,
	update=1,
	
}

function ClearingWorldDirector:OnSave(stm)
	WriteToStream(stm,self.Properties);
	stm:WriteInt(self.started);
	stm:WriteInt(self.bEnabled);
	stm:WriteInt(self.daynightstarted);
	stm:WriteInt(self.daynightstopped);
	if not opcl_DZL_upgrade then opcl_DZL_upgrade = 0; end	
	stm:WriteInt(opcl_DZL_upgrade);
	--stm:WriteString(self.irgendwas);
	
end

function ClearingWorldDirector:OnLoad(stm)
	self.Properties=ReadFromStream(stm);
	self.started = stm:ReadInt();
	self.bEnabled = stm:ReadInt();	
	self.daynightstarted = stm:ReadInt();
	self.daynightstopped = stm:ReadInt();
	opcl_DZL_upgrade = stm:ReadInt();
	--self.irgendwas = stm:ReadString();

	if ((_localplayer) and (_localplayer.cnt)) then
		local vehicle=_localplayer.cnt:GetCurVehicle(); 
		if(not vehicle) then
			self.ballowstart = 0;
		else
			self.ballowstart = 1;  --dont react ???
		end
	end
	
	self.Iwasloaded = 1;
--	self:OnReset();	
end


----------------------------------------------------------------------------------------
function ClearingWorldDirector:OnPropertyChange()
	
	self:OnReset();

	
end

----------------------------------------------------------------------------------------
function ClearingWorldDirector:OnInit()
	self:OnReset();
	self.ballowstart = 0;
	self.Iwasloaded = 0;
					self.drawnearstore = r_NoDrawNear;
					self.crosshairstore = hud_crosshair;
					self.ignoreaistore = ai_ignoreplayer;
					self.soundpreceptionstore = ai_soundperception;				
					self.walkspeedstore = p_speed_walk;
					self.runspeedstore = p_speed_run;			
end


function ClearingWorldDirector:OnReset()
	
	
	opcl_DZL_upgrade = 0;

	r_NoDrawNear = self.drawnearstore;
	hud_crosshair = self.crosshairstore;
	ai_ignoreplayer = self.ignoreaistore;
	ai_soundperception = self.soundpreceptionstore;				
	p_speed_walk = self.walkspeedstore;
	p_speed_run = self.runspeedstore;		
	
	self:NetPresent(nil);
    self.bEnabled=self.Properties.bEnabled;

	self.ballowstart = 0;
	self.Client:OnMove();
	self.RunMeHereONlyONeTIme2 = nil;
	self.started = 0;

	if self.Properties.RPGsimulation.bTrainFitness == 1 then       
		 opcl_RPGSimulation = "1";
	else
		 opcl_RPGSimulation = "0";
	end
	opcltestfactor = self.Properties.RPGsimulation.Trainfactor;	
	
		if self.Properties.PlayerArmShader.bInitOnStart == 1 then
			_localplayer:SetShader("", 4);	--reset
			--Hud:AddMessage("clearing world directore shader changed for localplayer ",4);		
			BasicWeapon.weaponshaderchangeallowed = 1;
			BasicWeapon.weaponshader = self.Properties.PlayerArmShader.weaponshader;
			BasicWeapon.weaponshadernum = self.Properties.PlayerArmShader.weaponshadernum;
		end
		
	if self.Properties.ClearingVegetation.bPhysicVegetationForce == 1 then
		opcl_environmentforce = "1";
	     Hud.fBendRadius = self.Properties.ClearingVegetation.fVegetationReactRadius;
	     Hud.fBendForce = self.Properties.ClearingVegetation.fVegetationBendForce;
	  else
	   	opcl_environmentforce ="0";	   	
	end

	self.resettest = 1;
	--opclrockdamage = self.Properties.ClearingPlayer.nRockDamage;

--	if opcl_environmentforce then
--		Hud:AddMessage("$1clearing world director ON RESET  opcl_environmentforce"..opcl_environmentforce,4);
--	else
--		Hud:AddSubtitle("$1clearing world director ON RESET, no vegetation force",4);
--	end
	--Hud:AddSubtitle("$1clearing world director ON RESET,",4);
	Hud:OnReset();
	Map:OnReset();
	
end
----------------------------------------------------------------------------------------
ClearingWorldDirector["Server"] = {
	OnInit= function (self)
		self:EnableUpdate(0);

	end,
	OnShutDown= function (self)
	end,
}

----------------------------------------------------------------------------------------
ClearingWorldDirector["Client"] = {
	----------------------------------------------------------------------------------------
	OnInit = function(self)
		self:EnableUpdate(0);
		--System:LogToConsole("OnInit");


		--if (self.Properties.bPlay==1) then
		--	self:Event_Play( sender );
		--end
		self.Client:OnMove();
	end,
	----------------------------------------------------------------------------------------
	OnShutDown = function(self)
		
	end,

	----------------------------------------------------------------------------------------
	OnMove = function(self)
	end,
	----------------------------------------------------------------------------------------
}






function ClearingWorldDirector:RandomTrueSucess()

	if (self.bEnabled == 0 ) then 
		do return end;
	end

	self.started = 0;
end

----------------------------------------------------------------------------------------





----------------------------------------------------------------------------------------
--------------------------pvcfmod---------------------
function ClearingWorldDirector:Event_Play( sender )

	--System:SetSystemShaderRenderFlags(DLD_DETAIL_OBJECTS, "DrawDetailObjects",1);
	--System:SetSystemShaderRenderFlags(CGRCTerrain_4Layers_Only, "TerrainDetailLayers",1);	
	
	--System:SetSkyFade( self.Properties.ClearingWorld.xSkyStart, self.Properties.ClearingWorldxSkyEnd );	

	--special injecting properties so that a medic can heal the player 
	_localplayer.Properties.Clearing.bReachableByAMedic =	self.Properties.ClearingPlayer.bReachableByAMedic;


	if _localplayer and _localplayer.cnt then 
		if self.Properties.ClearingPlayer.nCamX ~= 0 and self.Properties.ClearingPlayer.nCamY ~= 0 and self.Properties.ClearingPlayer.nCamZ ~= 0 then
			_localplayer:SetAngles({x=self.Properties.ClearingPlayer.nCamX,y=self.Properties.ClearingPlayer.nCamY,z=self.Properties.ClearingPlayer.nCamZ});
			--Hud:AddMessage(" localplayer angle set to given values",1);
		end		
	end	

	if self.Properties.MiniMap.texture_MapTexture then
		--opcl_maptexture=System:LoadImage("Levels/"..Game:GetLevelName().."/radarmap.dds");
		opcl_maptexture=System:LoadImage(self.Properties.MiniMap.texture_MapTexture);
	end

	if self.Properties.DayNight.bActivateSunOnReset == 1 then
 			if 	(self.Properties.DayNight.DayNightEntityName ~= "")  then
 				local _dayentityname =self.Properties.DayNight.DayNightEntityName;
 				if _dayentityname ~= nil then
						self.daynight = System:GetEntityByName(_dayentityname); 
						if self.daynight then
							self.daynight:Event_SwitchSunOn( sender );							
						end	
				end
			end
	end
	
	opcl_TrafficSpeedScale = self.Properties.ClearingWorld.TrafficSpeedScale;
	
	if self.Properties.ClearingWorld.bCrytecSun == 1 then
		--e_sun = 1;
		e_sun = "1";
		--Hud:AddMessage("sun switched on");
	else
		--e_sun = 0;
		e_sun = "0";
		--Hud:AddMessage("sun switched off");
	end


	opcl_ShowMedicDebugMessage =	self.Properties.ClearingWorld.bShowMedicDebugMessage;
	opcl_ShowCivilianDebugMessage = self.Properties.ClearingWorld.bShowCivilianDebugMessage;
	
	if self.Properties.ClearingWorld.bShadowMap == 1 then
		e_shadow_maps = 1;	
	else
		e_shadow_maps = 0;	
	end
		
	--ist also done in FPS scaler depending on global setting opcl_fps_scalerlimitshadowviewdist
	if self.Properties.ClearingWorld.ShadowMapViewDistRatio >= 0 then					
		if opcl_fps_scalerlimitshadowviewdist and opcl_fps_scalerlimitshadowviewdist == "0" then
			e_shadow_maps_view_dist_ratio =  self.Properties.ClearingWorld.ShadowMapViewDistRatio;
		end
	else
		e_shadow_maps_view_dist_ratio = 0;
	end
		
	if not Hud.playerindoor then 
		Hud.playerindoor = "Outdoor";	
	end
	if self.Properties.ClearingWorld.bKeepMinViewRange == 1 and Hud.playerindoor == "Outdoor" then		
		opcl_minviewrange = self.Properties.ClearingWorld.KeepedMinViewRange;
		opcl_maxviewrange = self.Properties.ClearingWorld.KeepedMaxViewRange;
--	else
--		opcl_minviewrange = 250;
--		opcl_maxviewrange = 1024;	
	end
		

	if self.Properties.ClearingWorld.bIsRacingGame == 1 then
		opcl_IsRacingGame = "1";		
	else
		opcl_IsRacingGame = "0";
	end
	
	if self.Properties.ClearingWorld.VhcleGrndVertFrictnScale > 0.01 then
		opcl_verticalfrictionscale = self.Properties.ClearingWorld.VhcleGrndVertFrictnScale;
	end
	
	if self.Properties.ClearingWorld.bUseRaceSpeedScale == 1 then
		opcl_RacingSpeedScale = "1";
		if self.Properties.ClearingWorld.SpeedChangeSwellSpeed < 4 then opcl_speedchangeswellvalue = 4; end
		if self.Properties.ClearingWorld.SpeedChangeSwellSpeed > 60 then opcl_speedchangeswellvalue = 60; end
		opcl_speedchangeswellvalue = self.Properties.ClearingWorld.SpeedChangeSwellSpeed;		
	else
		opcl_RacingSpeedScale = "0";
	end
	
	if self.Properties.MiniMap.bEnableRadar == 1 then
		hud_disableradar = "0";
	else
		hud_disableradar = "1";
	end

	
	if self.Properties.MiniMap.texture_RadarTexture and self.Properties.MiniMap.texture_RadarTexture ~= "" then
		--Hud:AddMessage("radartexture changed",1);
		Hud.Radar=System:LoadImage(self.Properties.MiniMap.texture_RadarTexture);
		--self.NoRadar=System:LoadImage(self.Properties.MiniMap.texture_RadarTexture); --its the alpha overlay for multiicons
	else
		Hud.Radar=System:LoadImage("Textures/hud/compass_small.dds");		
	end


	if self.Properties.MiniMap.bShowAlways == 1 then
		opcl_mapMinimapActive = "1";
	else
		opcl_mapMinimapActive = "0";
	end	
	
	if self.Properties.MiniMap.bMinimapToRadar == 1 then	
		opcl_mapMinimapToRadar = "1";
	else
		opcl_mapMinimapToRadar = "0";
	end	
		
	if 	self.Properties.MiniMap.LevelHeightmapSizeX ~= "" then
		Map.mapImageProps.w =	self.Properties.MiniMap.LevelHeightmapSizeX;
		Map.mapImageProps.Y =	self.Properties.MiniMap.LevelHeightmapSizeX;	
	end
		
		
		
	opcl_RacingSavePosIntervall = self.Properties.ClearingWorld.RacingSavePosIntervall;
	if opcl_RacingSavePosIntervall < 1 then opcl_RacingSavePosIntervall = 1; end
	
	if(self.Properties.bOnce~=0 and self.started~=0) then
		return
	end
	--self.update=1;
	--self:PlaySound();
	BroadcastEvent( self,"Play" );
--	if BasePickup._kneedowntimer then
--		BasePickup._kneedowntimer = nil;  --cause error in racing game ???
--	end

	-----the following things will be done if the level is started the first time-----------------------

	--first we clear the message line
	if self.Properties.bClearMessageAtReset == 1 then
						Hud:AddMessage("",1);
						Hud:AddMessage("",1);
						Hud:AddMessage("",1);
						Hud:AddMessage("",1);
	end
	----------set the globaldaytime 
	clearingtime = nil;
		if self.Properties.ClearingWorld.iGlobalWorldTime >0 and self.Properties.ClearingWorld.iGlobalWorldTime <25 and self.Iwasloaded ~= 1 then
			--globaldaytime    --0=night   1=evening   2=midday
			if self.Properties.ClearingWorld.iGlobalWorldTime >= 0 and 
				self.Properties.ClearingWorld.iGlobalWorldTime <= 6 then
				globaldaytime = 0;
			end
			if self.Properties.ClearingWorld.iGlobalWorldTime >= 7 and self.Properties.ClearingWorld.iGlobalWorldTime <= 20 then
				globaldaytime = 2;
			end			
			if self.Properties.ClearingWorld.iGlobalWorldTime >= 21 and self.Properties.ClearingWorld.iGlobalWorldTime <= 25 then
				globaldaytime = 1;
			end			
			
		end
	
	--if self.Properties.ClearingWorld.bStartAboveWaterLevel == 1 then
	--	BasicPlayer.Diving =0;
	--end
	
	if self.Properties.ClearingPlayer.FlashLightDrain > 0 then 
		--Hud.flashLightDrain=7.5,  --   0.5     2.5  7.5 = very fast    --consumption speed of batteries from flashlight    --battery speed 
		Hud.flashLightDrain = self.Properties.ClearingPlayer.FlashLightDrain;
	end
	
	-----------start with weaponslotamount--------------------------
	if self.Iwasloaded ~= 1 then
		if self.Properties.ClearingPlayer.nStartWeaponslotAmount >=0 and self.Properties.ClearingPlayer.nStartWeaponslotAmount <9 then
			opcl_maxweaponslots = tostring(self.Properties.ClearingPlayer.nStartWeaponslotAmount); --pvcfmod	 
		else
			opcl_maxweaponslots = "5"; --default in operation clearing
		end
	end
	-------------start with  dollar amount-----------------------	
	if self.Properties.ClearingPlayer.nStartDollarAmount >0 and self.Iwasloaded ~= 1 then
		storestartmoney = self.Properties.ClearingPlayer.nStartDollarAmount;
		if _localplayermoney == 0 then		
			_localplayermoney = self.Properties.ClearingPlayer.nStartDollarAmount;
		else
			_localplayermoney = _localplayermoney + self.Properties.ClearingPlayer.nStartDollarAmount;			
		end
		globalearneddollars = _localplayermoney;
	end

	-------------start with  health percentage-----------------------	
	if self.Properties.ClearingPlayer.nPercentHealth >0 and self.Iwasloaded ~= 1 then	
		if self.Properties.ClearingPlayer.nPercentHealth >100 then
			_localplayer.cnt.health = 255;
		else
			_localplayer.cnt.health = floor(self.Properties.ClearingPlayer.nPercentHealth * 255 / 100);
		end
	end


	--------detach all things----------------------------------------------------

 	--Hud:AddMessage("RESET detach objects",6);
 	self:Event_DetachAll( sender );   --this cause the first (!) weaponshadow to dissapear 
 	
 	--self.irgendwas = "blubbalblauaa";
 	--Hud:AddMessage("check if its run one times",1);
	
	
	
 					--start with food percentage-----------------------------------------
					if self.Properties.ClearingPlayer.nPercentWellFed >=-1 and self.Iwasloaded ~= 1 then
						local temp_localplayerfood =255;
						if self.Properties.ClearingPlayer.nPercentWellFed >100 then
							temp_localplayerfood = 255;
						else
							if self.Properties.ClearingPlayer.nPercentWellFed >0 then
								temp_localplayerfood = floor(self.Properties.ClearingPlayer.nPercentWellFed * 255 / 100);
							else
								temp_localplayerfood = 0;
							end
						end		
								_localplayer.cnt.food = temp_localplayerfood;
					end	--if self.Properties.ClearingPlayer.nPercentWellFed >=-1 then	
					--start with food percentage-----------------------------------------	
	
	
	
	
	
	
	
end


function ClearingWorldDirector:Event_DetachAll( sender )
	
	
	if self.Iwasloaded == 1 then return; end
	if (self.Properties.bShowStatus == 1 ) then
		Hud:AddSubtitle("i am clearing world director and detach all objects at all slots on _dummy and _localplayer",10);
	end
	
	--Hud:AddMessage("detach all objets from player",1);
	--BasePickup.kneedownstarted=0;
	_dummy = System:GetEntityByName("dummy");	
	if _dummy then
	_dummy:DetachObjectToBone("_hs_Head");
	_dummy:DetachObjectToBone("Bip01"); 	
	_dummy:DetachObjectToBone("Bip01 Head"); 	
 	_dummy:DetachObjectToBone("Bip01 L Calf"); 	
 	_dummy:DetachObjectToBone("Bip01 L Clavicle"); 	
 	_dummy:DetachObjectToBone("Bip01 L Finger0"); 	 	 	
 	_dummy:DetachObjectToBone("Bip01 L Finger01"); 	 	 	 	
 	_dummy:DetachObjectToBone("Bip01 L Finger1"); 	 	 	 	
 	_dummy:DetachObjectToBone("Bip01 L Finger11"); 	 	 	
 	_dummy:DetachObjectToBone("Bip01 L Finger2"); 	 	 	
 	_dummy:DetachObjectToBone("Bip01 L Finger21"); 	 	 	 	 	 	
 	_dummy:DetachObjectToBone("Bip01 L Foot");
 	_dummy:DetachObjectToBone("Bip01 L Forearm");
 	_dummy:DetachObjectToBone("Bip01 L Hand");
 	_dummy:DetachObjectToBone("Bip01 L Thigh");
 	_dummy:DetachObjectToBone("Bip01 L Toe0");
 	_dummy:DetachObjectToBone("Bip01 L UpperArm"); 	 	
 	_dummy:DetachObjectToBone("Bip01 Neck");
 	_dummy:DetachObjectToBone("Bip01 Pelvis");
 	_dummy:DetachObjectToBone("Bip01 R Calf"); 	
 	_dummy:DetachObjectToBone("Bip01 R Clavicle"); 	
 	_dummy:DetachObjectToBone("Bip01 R Finger0"); 	 	 	
 	_dummy:DetachObjectToBone("Bip01 R Finger01"); 	 	 	 	
 	_dummy:DetachObjectToBone("Bip01 R Finger1"); 	 	 	 	
 	_dummy:DetachObjectToBone("Bip01 R Finger11"); 	 	 	
 	_dummy:DetachObjectToBone("Bip01 R Finger2"); 	 	 	
 	_dummy:DetachObjectToBone("Bip01 R Finger21"); 	 	 	 	 	 	
 	_dummy:DetachObjectToBone("Bip01 R Foot");
 	_dummy:DetachObjectToBone("Bip01 R Forearm");
 	_dummy:DetachObjectToBone("Bip01 R Hand");
 	_dummy:DetachObjectToBone("Bip01 R Thigh");
 	_dummy:DetachObjectToBone("Bip01 R Toe0");
 	_dummy:DetachObjectToBone("Bip01 R UpperArm"); 	 	
 	_dummy:DetachObjectToBone("Bip01 Spine"); 	
 	_dummy:DetachObjectToBone("Bip01 Spine1"); 	
 	_dummy:DetachObjectToBone("Bip01 Spine2"); 	
 	_dummy:DetachObjectToBone("hat_bone"); 	
  	_dummy:DetachObjectToBone("m4"); 	
 	_dummy:DetachObjectToBone("weapon_bone");	
 	_dummy:DetachObjectToBone("weapon_bone02"); 	
	end --if _dummy then
 	_localplayer:DetachObjectToBone("_hs_Head");
	_localplayer:DetachObjectToBone("Bip01"); 	
	_localplayer:DetachObjectToBone("Bip01 Head"); 	
 	_localplayer:DetachObjectToBone("Bip01 L Calf"); 	
 	_localplayer:DetachObjectToBone("Bip01 L Clavicle"); 	
 	_localplayer:DetachObjectToBone("Bip01 L Finger0"); 	 	 	
 	_localplayer:DetachObjectToBone("Bip01 L Finger01"); 	 	 	 	
 	_localplayer:DetachObjectToBone("Bip01 L Finger1"); 	 	 	 	
 	_localplayer:DetachObjectToBone("Bip01 L Finger11"); 	 	 	
 	_localplayer:DetachObjectToBone("Bip01 L Finger2"); 	 	 	
 	_localplayer:DetachObjectToBone("Bip01 L Finger21"); 	 	 	 	 	 	
 	_localplayer:DetachObjectToBone("Bip01 L Foot");
 	_localplayer:DetachObjectToBone("Bip01 L Forearm");
 	_localplayer:DetachObjectToBone("Bip01 L Hand");
 	_localplayer:DetachObjectToBone("Bip01 L Thigh");
 	_localplayer:DetachObjectToBone("Bip01 L Toe0");
 	_localplayer:DetachObjectToBone("Bip01 L UpperArm"); 	 	
 	_localplayer:DetachObjectToBone("Bip01 Neck");
 	_localplayer:DetachObjectToBone("Bip01 Pelvis");
 	_localplayer:DetachObjectToBone("Bip01 R Calf"); 	
 	_localplayer:DetachObjectToBone("Bip01 R Clavicle"); 	
 	_localplayer:DetachObjectToBone("Bip01 R Finger0"); 	 	 	
 	_localplayer:DetachObjectToBone("Bip01 R Finger01"); 	 	 	 	
 	_localplayer:DetachObjectToBone("Bip01 R Finger1"); 	 	 	 	
 	_localplayer:DetachObjectToBone("Bip01 R Finger11"); 	 	 	
 	_localplayer:DetachObjectToBone("Bip01 R Finger2"); 	 	 	
 	_localplayer:DetachObjectToBone("Bip01 R Finger21"); 	 	 	 	 	 	
 	_localplayer:DetachObjectToBone("Bip01 R Foot");
 	_localplayer:DetachObjectToBone("Bip01 R Forearm");
 	_localplayer:DetachObjectToBone("Bip01 R Hand");
 	_localplayer:DetachObjectToBone("Bip01 R Thigh");
 	_localplayer:DetachObjectToBone("Bip01 R Toe0");
 	_localplayer:DetachObjectToBone("Bip01 R UpperArm"); 	 	
 	_localplayer:DetachObjectToBone("Bip01 Spine"); 	
 	_localplayer:DetachObjectToBone("Bip01 Spine1"); 	
 	_localplayer:DetachObjectToBone("Bip01 Spine2"); 	
 	_localplayer:DetachObjectToBone("hat_bone"); 	
  	_localplayer:DetachObjectToBone("m4"); 	
 	--_localplayer:DetachObjectToBone("weapon_bone");	    --this cause the first (!) weaponshadow to dissapear 
 	_localplayer:DetachObjectToBone("weapon_bone02"); 		
 
 		
end


-------------------------------------------------------------------------------
-- Stop Event
-------------------------------------------------------------------------------
function ClearingWorldDirector:Event_ConditionTrue( sender )
	self:RandomTrueSucess();
	BroadcastEvent( self,"ConditionTrue" );
end




function ClearingWorldDirector:Event_Enable( sender )
	self.bEnabled = 1;
	BroadcastEvent( self,"Enable" );
end

function ClearingWorldDirector:Event_Disable( sender )
	self.bEnabled = 0;
	BroadcastEvent( self,"Disable" );
end




function ClearingWorldDirector:OnPrepareStart()		

 			-----day break trigger ----------------------------------------------------------------------------------------------------------------------		
 			if 	(self.Properties.DayNight.DayNightEntityName ~= "")  then
 				local _dayentityname =self.Properties.DayNight.DayNightEntityName;
 				--local _dayentityname = System:GetEntityByName(self.Properties.DayNight.DayNightEntityName);
 				if _dayentityname ~= nil then
						--Hud:AddMessage("inside day prepare break routine",6);
    						if (self.Properties.bShowStatus == 1 ) then	Hud:AddMessage("daynight trigger start prepared",5);	end
						if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("daynight entity ".._dayentityname.." found ! ",5);	end
						self.daynight = System:GetEntityByName(_dayentityname); 
						if self.daynight then
							self.daynight.update=0;
						end
				
			else --if _dayentityname ~= nil then
				if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("daynight entity not found! ",5);	end
			end  --if _dayentityname ~= nil then
		end	--(self.Properties.DayNight.DayNightEntityName ~= "")  then
		-----day break trigger ----------------------------------------------------------------------------------------------------------------------		

end

function ClearingWorldDirector:OnReactivateStart()		

 			-----day break trigger ----------------------------------------------------------------------------------------------------------------------		
 			if 	(self.Properties.DayNight.DayNightEntityName ~= "")  then
 				local _dayentityname =self.Properties.DayNight.DayNightEntityName;
 				--local _dayentityname = System:GetEntityByName(self.Properties.DayNight.DayNightEntityName);
 				if _dayentityname ~= nil then
						--Hud:AddMessage("inside dayreactivate routine",6);
    						if (self.Properties.bShowStatus == 1 ) then	Hud:AddMessage("daynight trigger start prepared",5);	end
						if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("daynight entity ".._dayentityname.." found ! ",5);	end
						self.daynight = System:GetEntityByName(_dayentityname); 
						if self.daynight then
							self.daynight.update=1;
						end
				
			else --if _dayentityname ~= nil then
				if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("daynight entity not found! ",5);	end
			end  --if _dayentityname ~= nil then
		end	--	(self.Properties.DayNight.DayNightEntityName ~= "")  then
		-----day break trigger ----------------------------------------------------------------------------------------------------------------------		

end
---------------------------------------------------------------------------------------------------------------------------------------------



			
			
function ClearingWorldDirector:OnUpdate()		
--		if not opcl_environmentforce then
--			Hud:AddSubtitle("$6 world director ONRESET $1inside do bush sound but not $4 opcl_environmentforce $1 is set!",2);
--		end	

	if self.resettest == 0 then
		self:OnReset();	
	end



	if not opcl_mapMiniMap_max then opcl_mapMiniMap_max = "0"; end
	if opcl_mapMiniMap_max == "0" then
		Map:minimize();
	else
		Map:maximize();
	end
		
		
		
		
		
		
	--Hud.label="clearing world onupdate";
	--Hud:AddSubtitle("clearing world onupdate",6);
		if ((self.Properties.bAutomaticPlay == 1) and (self.Properties.bWaitKeyOnStart == 0)) then
			self.ballowstart = 1;
			if not self.RunMeHereONlyONeTIme2	then 
				self.RunMeHereONlyONeTIme2=1;
				self.daynightstarted = 0; --strange hack 
				self:Event_Play( sender ); 
				--Hud.label="automatic running";
				if (self.Properties.bShowStatus == 1 ) then
					Hud:AddMessage("automatic running" ,1)  ;		
				else
					--Hud:AddMessage("" ,1)  ;		
					--Hud:AddMessage("" ,1)  ;		
					--Hud:AddMessage("" ,1)  ;		
					--Hud:AddMessage("" ,1)  ;		
				end
			end
		end

		if ((self.Properties.bWaitKeyOnStart == 1) and (self.ballowstart == 0)) then 
				if not self.RunMeHereONlyONeTIme	then 
					self.RunMeHereONlyONeTIme=1; 
					--self.startpos = _localplayer:GetPos();
					self.drawnearstore = r_NoDrawNear;
					self.crosshairstore = hud_crosshair;
					self.ignoreaistore = ai_ignoreplayer;
					self.soundpreceptionstore = ai_soundperception;				
					self.walkspeedstore = p_speed_walk;
					self.runspeedstore = p_speed_run;					
				end
				local PressedKey = Input:GetXKeyPressedName();
				local Key=(use);				
				if (self.Properties.bShowImageOnkeyStart == 1) then
					if ((not self.startpicture) and (self.Properties.texture_Image ~= "")) then self.startpicture=System:LoadImage(self.Properties.texture_Image); end
					if self.startpicture then
						%System:DrawImageColor(self.startpicture, 0, 0, 800, 600, 0, 1, 1, 4, 1);  
					else
						Hud.label="Press USE to start Game";
					end
				end
				_localplayer:EnablePhysics(0);
				--_localplayer:SetPos(self.startpos);
				self:OnPrepareStart();
				_localplayer:SetAngles({x=1,y=1,z=1});
				hud_crosshair = "0";
				r_NoDrawNear = "1";
				ai_ignoreplayer = "1";
				ai_soundperception = "0";
				p_speed_walk=0;
				p_speed_run=0;
				--Hud.label="inside press use to startkey routine";
				--Hud:AddMessage("inside press use to startkey routine",6);
				--if ( PressedKey == Key )	then	
				if (_localplayer.cnt.use_pressed) then							
					_localplayer:EnablePhysics(1);
					self.RunMeHereONlyONeTIme=nil; 
					self.startpos = nil;
					self.ballowstart = 1;
					self:OnReactivateStart();
					hud_crosshair = self.crosshairstore; self.crosshairstore = nil;
					r_NoDrawNear = self.drawnearstore; self.drawnearstore = nil;
					ai_ignoreplayer = self.ignoreaistore; self.ignoreaistore = nil;
					ai_soundperception = self.soundpreceptionstore; self.soundpreceptionstore = nil;
					p_speed_walk = self.walkspeedstore;
					p_speed_run = self.runspeedstore;					
				end
				PressedKey = nil;
		end
	
	if ((self.Properties.bEnabled== 1) and (self.ballowstart == 1))  then 			
		
		
	--local _playerenergy = _localplayer.cnt.stamina;  --1.0  is max	
	--local _playerenergy2 = _localplayer.cnt.breath;  --1.0  is max	
	--_localplayer.cnt.breath =_playerenergy;
	--Hud:AddMessage("player stamina= $5".._playerenergy.."$1 breath =$5".._playerenergy2,6);
	--Hud.label="player stamina= $5".._playerenergy.."$1 breath =$5".._playerenergy2;
		
		
	-------debug me so that only at every start resettet
	--if self.Properties.PlayerStartWithWeaponslotAmount >0 and self.Properties.PlayerStartWithWeaponslotAmount <= 8 then
	--	opcl_maxweaponslots = tostring(self.Properties.PlayerStartWithWeaponslotAmount);
	--end	
		
		
		
		if (self.Properties.bShowStatus == 1 ) then 
			if clearingtime ~= nil then 				
				Hud.label="$5 randomizer on update, clearingtime:"..clearingtime.." o Clock  globaldaytime "..globaldaytime;  
			else
				Hud.label="$5 randomizer on update, self.daynightstarted "..self.daynightstarted.."       self.daynightstopped "..self.daynightstopped.." globaldaytime "..globaldaytime; 
			end
			
		end
 					
		if (self.Properties.bShowWorldTime == 1 ) then 
			if clearingtime ~= nil then 				
				Hud.label="$5 randomizer on update, clearingtime:"..clearingtime.."$1 o Clock  globaldaytime "..globaldaytime;  
			else
				clearingtime = "$4no active clearingdaynighttrigger found which can set the clearing time";
			end
		end

 			-----day start trigger ----------------------------------------------------------------------------------------------------------------------		
 			if 	((self.Properties.DayNight.DayNightEntityName ~= "") and (self.daynightstopped == 0 ) and (self.daynightstarted == 0)) then
 				local _dayentityname =self.Properties.DayNight.DayNightEntityName;
 				--local _dayentityname = System:GetEntityByName(self.Properties.DayNight.DayNightEntityName);
 				if _dayentityname ~= nil then
 					
 					--start with food percentage-----------------------------------------
					if self.Properties.ClearingPlayer.nPercentWellFed >=-1 then
						local temp_localplayerfood =255;
						if self.Properties.ClearingPlayer.nPercentWellFed >100 then
							temp_localplayerfood = 255;
						else
							if self.Properties.ClearingPlayer.nPercentWellFed >0 then
								temp_localplayerfood = floor(self.Properties.ClearingPlayer.nPercentWellFed * 255 / 100);
							else
								temp_localplayerfood = 0;
							end
						end		
						 if 	(self.Properties.DayNight.DayNightEntityName ~= "")  then 			
				 			local _dayentitynamefood = System:GetEntityByName(self.Properties.DayNight.DayNightEntityName);
							if not _dayentitynamefood then 
								--nothing to code here....
								--_localplayer.cnt.food = temp_localplayerfood;
							else
								_dayentitynamefood.Properties.startfood = temp_localplayerfood;						
							end
						end		
					end	--if self.Properties.ClearingPlayer.nPercentWellFed >=-1 then	
					--start with food percentage-----------------------------------------
							
 								------------------------------------------------------reduces the update per frame amount-------------------------
					if(not self._daysrtarttimer)then self._daysrtarttimer=System:GetCurrTime(); end				
					if(System:GetCurrTime()-self._daysrtarttimer > self.Properties.DayNight.StartAfter) then
								------------------------------------------------------reduces the update per frame amount-------------------------    						
    						
    						if (self.Properties.bShowStatus == 1 ) then	Hud:AddMessage("daynight trigger start prepared",5);	end
    						
							if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("daynight entity ".._dayentityname.." found ! ",5);	end
							self.daynight = System:GetEntityByName(_dayentityname); 
							if self.daynight then
								if self.Properties.DayNight.bEnabledStart == 1 then
									self.daynight:Event_StartDayNightChange( sender );		
									self.daynightstarted = 1;
								end
								self.daynightstopped = 0;
							end
								------------------------------------------------------reduces the update per frame amount-------------------------
					self._daysrtarttimer=nil;
					end 	 	
								------------------------------------------------------reduces the update per frame amount-------------------------							
			else --if _dayentityname ~= nil then
				if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("daynight entity not found! ",5);	end
			end  --if _dayentityname ~= nil then
		end	--((self.Properties.DayNight.DayNightEntityName ~= "") and (self.daynightstopped == 0 ) and (self.daynightstarted == 0)) then
		-----day start trigger ----------------------------------------------------------------------------------------------------------------------					

		
		-----day stop trigger ----------------------------------------------------------------------------------------------------------------------	
		if ((self.daynight 	~= nil) and (self.daynightstarted == 1 ) and (self.daynightstopped == 0)) then
 			if	(self.Properties.DayNight.StopAtoClock >= 1) and (self.Properties.DayNight.StopAtoClock <= 24) then
 				if ((clearingtime ~= nil) and (clearingtime ==	self.Properties.DayNight.StopAtoClock)) then
 					if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("daynight entity stopped ",5);	end
 					self.daynight:Event_Break( sender );
 					self.daynightstopped = 1;
 				end	-- if ((clearingtime ~= nil) and (clearingtime ==	self.Properties.DayNight.StopAtoClock)) then
 			end		--if	self.Properties.DayNight.StopAtoClock >= 1 or <= 24 then
		end 					--if ((self.daynight 	~= nil) and (daynightstarted == 1 )) then
		-----day stop trigger ----------------------------------------------------------------------------------------------------------------------	 					
 					
 					
 			-----Weather1 random trigger ----------------------------------------------------------------------------------------------------------------------		
 			if 	self.Properties.Weather1.RainEntityName ~= "" then
 				local _rainentityname =self.Properties.Weather1.RainEntityName;
 				local _rainentity = System:GetEntityByName(self.Properties.Weather1.RainEntityName);
 				if _rainentity ~= nil then
 								------------------------------------------------------reduces the update per frame amount-------------------------
					if(not self._rainchancetimer1)then self._rainchancetimer1=System:GetCurrTime(); end				
					if(System:GetCurrTime()-self._rainchancetimer1 > self.Properties.Weather1.ChanceCheckEvery) then
								------------------------------------------------------reduces the update per frame amount-------------------------    						
    						local zufall = random(0,100);
    						if (self.Properties.bShowStatus == 1 ) then	Hud:AddMessage("rain chancechecker"..zufall,5);	end
    						if zufall <= self.Properties.Weather1.nChance then
							if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("weather1 rain ".._rainentityname.." found ! ",5);	end
							self.rain = System:GetEntityByName(self.Properties.Weather1.RainEntityName); 
							if self.rain then
								self:StartWeather();							
							else
								if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("weather1 rain entity not found! ",5);	end
							end
						end
								------------------------------------------------------reduces the update per frame amount-------------------------
					self._rainchancetimer1=nil;
					end 	 	
								------------------------------------------------------reduces the update per frame amount-------------------------							
			else --if _rainentityname ~= nil then
				if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("weather1 rain entity not found! ",5);	end
			end  --if _rainentityname ~= nil then
		end	--if 	self.Properties.Weather1.RainEntityName1 ~= "" then
		-----Weather1 random trigger ----------------------------------------------------------------------------------------------------------------------					
					

			-----Weather2 random trigger ----------------------------------------------------------------------------------------------------------------------		
 			if 	self.Properties.Weather2.RainEntityName ~= "" then
 				local _rainentityname =self.Properties.Weather2.RainEntityName;
 				local _rainentity = System:GetEntityByName(self.Properties.Weather2.RainEntityName);
 				if _rainentity ~= nil then
 								------------------------------------------------------reduces the update per frame amount-------------------------
					if(not self._rainchancetimer1)then self._rainchancetimer1=System:GetCurrTime(); end				
					if(System:GetCurrTime()-self._rainchancetimer1 > self.Properties.Weather2.ChanceCheckEvery) then
								------------------------------------------------------reduces the update per frame amount-------------------------    						
    						local zufall = random(0,100);
    						if (self.Properties.bShowStatus == 1 ) then	Hud:AddMessage("rain chancechecker"..zufall,5);	end
    						if zufall <= self.Properties.Weather2.nChance then
							if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather2 rain ".._rainentityname.." found ! ",5);	end
							self.rain = System:GetEntityByName(self.Properties.Weather2.RainEntityName); 
							if self.rain then
								self:StartWeather();							
							else
								if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather2 rain entity not found! ",5);	end
							end
						end
								------------------------------------------------------reduces the update per frame amount-------------------------
					self._rainchancetimer1=nil;
					end 	 	
								------------------------------------------------------reduces the update per frame amount-------------------------							
			else --if _rainentityname ~= nil then
				if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather2 rain entity not found! ",5);	end
			end  --if _rainentityname ~= nil then
		end	--if 	self.Properties.Weather2.RainEntityName1 ~= "" then
		-----Weather2 random trigger ----------------------------------------------------------------------------------------------------------------------			

					
					
 			-----Weather3 random trigger ----------------------------------------------------------------------------------------------------------------------		
 			if 	self.Properties.Weather3.RainEntityName ~= "" then
 				local _rainentityname =self.Properties.Weather3.RainEntityName;
 				local _rainentity = System:GetEntityByName(self.Properties.Weather3.RainEntityName);
 				if _rainentity ~= nil then
 								------------------------------------------------------reduces the update per frame amount-------------------------
					if(not self._rainchancetimer1)then self._rainchancetimer1=System:GetCurrTime(); end				
					if(System:GetCurrTime()-self._rainchancetimer1 > self.Properties.Weather3.ChanceCheckEvery) then
								------------------------------------------------------reduces the update per frame amount-------------------------    						
    						local zufall = random(0,100);
    						if (self.Properties.bShowStatus == 1 ) then	Hud:AddMessage("rain chancechecker"..zufall,5);	end
    						if zufall <= self.Properties.Weather3.nChance then
							if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather3 rain ".._rainentityname.." found ! ",5);	end
							self.rain = System:GetEntityByName(self.Properties.Weather3.RainEntityName); 
							if self.rain then
								self:StartWeather();							
							else
								if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather3 rain entity not found! ",5);	end
							end
						end
								------------------------------------------------------reduces the update per frame amount-------------------------
					self._rainchancetimer1=nil;
					end 	 	
								------------------------------------------------------reduces the update per frame amount-------------------------							
			else --if _rainentityname ~= nil then
				if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather3 rain entity not found! ",5);	end
			end  --if _rainentityname ~= nil then
		end	--if 	self.Properties.Weather3.RainEntityName1 ~= "" then
		-----Weather3 random trigger ----------------------------------------------------------------------------------------------------------------------					
	
	
	-----Weather4 random trigger ----------------------------------------------------------------------------------------------------------------------		
 			if 	self.Properties.Weather4.RainEntityName ~= "" then
 				local _rainentityname =self.Properties.Weather4.RainEntityName;
 				local _rainentity = System:GetEntityByName(self.Properties.Weather4.RainEntityName);
 				if _rainentity ~= nil then
 								------------------------------------------------------reduces the update per frame amount-------------------------
					if(not self._rainchancetimer1)then self._rainchancetimer1=System:GetCurrTime(); end				
					if(System:GetCurrTime()-self._rainchancetimer1 > self.Properties.Weather4.ChanceCheckEvery) then
								------------------------------------------------------reduces the update per frame amount-------------------------    						
    						local zufall = random(0,100);
    						if (self.Properties.bShowStatus == 1 ) then	Hud:AddMessage("rain chancechecker"..zufall,5);	end
    						if zufall <= self.Properties.Weather4.nChance then
							if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather4 rain ".._rainentityname.." found ! ",5);	end
							self.rain = System:GetEntityByName(self.Properties.Weather4.RainEntityName); 
							if self.rain then
								self:StartWeather();							
							else
								if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather4 rain entity not found! ",5);	end
							end
						end
								------------------------------------------------------reduces the update per frame amount-------------------------
					self._rainchancetimer1=nil;
					end 	 	
								------------------------------------------------------reduces the update per frame amount-------------------------							
			else --if _rainentityname ~= nil then
				if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather4 rain entity not found! ",5);	end
			end  --if _rainentityname ~= nil then
		end	--if 	self.Properties.Weather4.RainEntityName1 ~= "" then
		-----Weather4 random trigger ----------------------------------------------------------------------------------------------------------------------					
					
	
	
	
	
	-----Weather5 random trigger ----------------------------------------------------------------------------------------------------------------------		
 			if 	self.Properties.Weather5.RainEntityName ~= "" then
 				local _rainentityname =self.Properties.Weather5.RainEntityName;
 				local _rainentity = System:GetEntityByName(self.Properties.Weather5.RainEntityName);
 				if _rainentity ~= nil then
 								------------------------------------------------------reduces the update per frame amount-------------------------
					if(not self._rainchancetimer1)then self._rainchancetimer1=System:GetCurrTime(); end				
					if(System:GetCurrTime()-self._rainchancetimer1 > self.Properties.Weather5.ChanceCheckEvery) then
								------------------------------------------------------reduces the update per frame amount-------------------------    						
    						local zufall = random(0,100);
    						if (self.Properties.bShowStatus == 1 ) then	Hud:AddMessage("rain chancechecker"..zufall,5);	end
    						if zufall <= self.Properties.Weather5.nChance then
							if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather5 rain ".._rainentityname.." found ! ",5);	end
							self.rain = System:GetEntityByName(self.Properties.Weather5.RainEntityName); 
							if self.rain then
								self:StartWeather();							
							else
								if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather5 rain entity not found! ",5);	end
							end
						end
								------------------------------------------------------reduces the update per frame amount-------------------------
					self._rainchancetimer1=nil;
					end 	 	
								------------------------------------------------------reduces the update per frame amount-------------------------							
			else --if _rainentityname ~= nil then
				if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather5 rain entity not found! ",5);	end
			end  --if _rainentityname ~= nil then
		end	--if 	self.Properties.Weather5.RainEntityName1 ~= "" then
		-----Weather5 random trigger ----------------------------------------------------------------------------------------------------------------------		
		
		
		
		
		
		-----Weather6 random trigger ----------------------------------------------------------------------------------------------------------------------		
 			if 	self.Properties.Weather6.RainEntityName ~= "" then
 				local _rainentityname =self.Properties.Weather6.RainEntityName;
 				local _rainentity = System:GetEntityByName(self.Properties.Weather6.RainEntityName);
 				if _rainentity ~= nil then
 								------------------------------------------------------reduces the update per frame amount-------------------------
					if(not self._rainchancetimer1)then self._rainchancetimer1=System:GetCurrTime(); end				
					if(System:GetCurrTime()-self._rainchancetimer1 > self.Properties.Weather6.ChanceCheckEvery) then
								------------------------------------------------------reduces the update per frame amount-------------------------    						
    						local zufall = random(0,100);
    						if (self.Properties.bShowStatus == 1 ) then	Hud:AddMessage("rain chancechecker"..zufall,5);	end
    						if zufall <= self.Properties.Weather6.nChance then
							if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather6 rain ".._rainentityname.." found ! ",5);	end
							self.rain = System:GetEntityByName(self.Properties.Weather6.RainEntityName); 
							if self.rain then
								self:StartWeather();							
							else
								if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather6 rain entity not found! ",5);	end
							end
						end
								------------------------------------------------------reduces the update per frame amount-------------------------
					self._rainchancetimer1=nil;
					end 	 	
								------------------------------------------------------reduces the update per frame amount-------------------------							
			else --if _rainentityname ~= nil then
				if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather6 rain entity not found! ",5);	end
			end  --if _rainentityname ~= nil then
		end	--if 	self.Properties.Weather6.RainEntityName1 ~= "" then
		-----Weather6 random trigger ----------------------------------------------------------------------------------------------------------------------		





	-----Weather7 random trigger ----------------------------------------------------------------------------------------------------------------------		
 			if 	self.Properties.Weather7.RainEntityName ~= "" then
 				local _rainentityname =self.Properties.Weather7.RainEntityName;
 				local _rainentity = System:GetEntityByName(self.Properties.Weather7.RainEntityName);
 				if _rainentity ~= nil then
 								------------------------------------------------------reduces the update per frame amount-------------------------
					if(not self._rainchancetimer1)then self._rainchancetimer1=System:GetCurrTime(); end				
					if(System:GetCurrTime()-self._rainchancetimer1 > self.Properties.Weather7.ChanceCheckEvery) then
								------------------------------------------------------reduces the update per frame amount-------------------------    						
    						local zufall = random(0,100);
    						if (self.Properties.bShowStatus == 1 ) then	Hud:AddMessage("rain chancechecker"..zufall,5);	end
    						if zufall <= self.Properties.Weather7.nChance then
							if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather7 rain ".._rainentityname.." found ! ",5);	end
							self.rain = System:GetEntityByName(self.Properties.Weather7.RainEntityName); 
							if self.rain then
								self:StartWeather();							
							else
								if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather7 rain entity not found! ",5);	end
							end
						end
								------------------------------------------------------reduces the update per frame amount-------------------------
					self._rainchancetimer1=nil;
					end 	 	
								------------------------------------------------------reduces the update per frame amount-------------------------							
			else --if _rainentityname ~= nil then
				if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather7 rain entity not found! ",5);	end
			end  --if _rainentityname ~= nil then
		end	--if 	self.Properties.Weather7.RainEntityName1 ~= "" then
		-----Weather7 random trigger ----------------------------------------------------------------------------------------------------------------------		


 		-----Weather8 random trigger ----------------------------------------------------------------------------------------------------------------------		
 			if 	self.Properties.Weather8.RainEntityName ~= "" then
 				local _rainentityname =self.Properties.Weather8.RainEntityName;
 				local _rainentity = System:GetEntityByName(self.Properties.Weather8.RainEntityName);
 				if _rainentity ~= nil then
 								------------------------------------------------------reduces the update per frame amount-------------------------
					if(not self._rainchancetimer1)then self._rainchancetimer1=System:GetCurrTime(); end				
					if(System:GetCurrTime()-self._rainchancetimer1 > self.Properties.Weather8.ChanceCheckEvery) then
								------------------------------------------------------reduces the update per frame amount-------------------------    						
    						local zufall = random(0,100);
    						if (self.Properties.bShowStatus == 1 ) then	Hud:AddMessage("rain chancechecker"..zufall,5);	end
    						if zufall <= self.Properties.Weather8.nChance then
							if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather8 rain ".._rainentityname.." found ! ",5);	end
							self.rain = System:GetEntityByName(self.Properties.Weather8.RainEntityName); 
							if self.rain then
								self:StartWeather();							
							else
								if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather8 rain entity not found! ",5);	end
							end
						end
								------------------------------------------------------reduces the update per frame amount-------------------------
					self._rainchancetimer1=nil;
					end 	 	
								------------------------------------------------------reduces the update per frame amount-------------------------							
			else --if _rainentityname ~= nil then
				if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather8 rain entity not found! ",5);	end
			end  --if _rainentityname ~= nil then
		end	--if 	self.Properties.Weather8.RainEntityName1 ~= "" then
		-----Weather8 random trigger ----------------------------------------------------------------------------------------------------------------------		


 		-----Weather9 random trigger ----------------------------------------------------------------------------------------------------------------------		
 			if 	self.Properties.Weather9.RainEntityName ~= "" then
 				local _rainentityname =self.Properties.Weather9.RainEntityName;
 				local _rainentity = System:GetEntityByName(self.Properties.Weather9.RainEntityName);
 				if _rainentity ~= nil then
 								------------------------------------------------------reduces the update per frame amount-------------------------
					if(not self._rainchancetimer1)then self._rainchancetimer1=System:GetCurrTime(); end				
					if(System:GetCurrTime()-self._rainchancetimer1 > self.Properties.Weather9.ChanceCheckEvery) then
								------------------------------------------------------reduces the update per frame amount-------------------------    						
    						local zufall = random(0,100);
    						if (self.Properties.bShowStatus == 1 ) then	Hud:AddMessage("rain chancechecker"..zufall,5);	end
    						if zufall <= self.Properties.Weather9.nChance then
							if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather9 rain ".._rainentityname.." found ! ",5);	end
							self.rain = System:GetEntityByName(self.Properties.Weather9.RainEntityName); 
							if self.rain then
								self:StartWeather();							
							else
								if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather9 rain entity not found! ",5);	end
							end
						end
								------------------------------------------------------reduces the update per frame amount-------------------------
					self._rainchancetimer1=nil;
					end 	 	
								------------------------------------------------------reduces the update per frame amount-------------------------							
			else --if _rainentityname ~= nil then
				if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("Weather9 rain entity not found! ",5);	end
			end  --if _rainentityname ~= nil then
		end	--if 	self.Properties.Weather9.RainEntityName1 ~= "" then
		-----Weather9 random trigger ----------------------------------------------------------------------------------------------------------------------		
					
					
					
	end --if (self.Properties.bEnabled== 1 ) then 			
	
end			
			
function ClearingWorldDirector:StartWeather()			
	if (self.Properties.bShowStatus == 1 ) then	Hud:AddSubtitle("rain started",5);	end
	self.rain:Event_BeginRain( sender );
	self:Event_StartWeather( sender );
end


function ClearingWorldDirector:Event_StartWeather( sender )			
		BroadcastEvent( self,"StartWeather" );
end