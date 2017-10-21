-----------operation clearing-----------------pvcf-mod-------------

-- Description :		Delayed Mission and SubMission trigger
--
--
--added no vehicle option
--can run outside of devkid (but with no big advert)
--debugged: mark solved can now only one time called
--added: reacts now on demand to different difficulty levels
--debugged: Activate MIssion broadcast was 2 times called


ClearingMissionTrigger = {
	type = "MissionTrigger",
	bWasCountedAsMainMission = 0,        --used only temprary in tabscreen in tourist mode
	bWasCountedAsSubMission = 0,    	  --used only temprary in tabscreen in tourist mode
	update = 0,
	messagetimer = nil,

	Properties = {
		DimX = 5,
		DimY = 5,
		DimZ = 5,
		bEnabled=1,
		EnterDelay=0,
		ExitDelay=0,
		bOnlyPlayer=1,
		bNoVehicle= 1,
		bOnlyMyPlayer=1,
		bOnlyAI = 0,
		bOnlySpecialAI = 0,
		bTriggerOnce=1,
		ScriptCommand="",
		PlaySequence="",
		SpecificObjectName="",
		aianchorAIAction = "",
		TextInstruction= "",
		bActivateWithUseButton=0,
		bInVehicleOnly=0,               --pvcf
	
	DifficultyAvailibility = {
		bDifficultyLvl_1 = 1,
		bDifficultyLvl_2 = 1,
		bDifficultyLvl_3 = 1,
		bDifficultyLvl_4 = 1,
		bDifficultyLvl_5 = 1,
		bDifficultyLvl_6 = 1,
		DifficultyNotFitMessage = "Mission not availible in this Difficulty Level.",	
		},       --Availibility


    Mission = {
		bIsMainMission = 1,      -- 0 means SubMission
		MissionBoxText = "MissionBoxtextfromMissionscreen",
		MissionTagPoint = "tagpointxx",
		bClearTagPointOnMissionSolved = 1,
		--textureRadarObjective = "Textures/hud/RadarPlayer.dds", --dont work
		
		MessageText1 = "",
		MessageText2 = "",
		MessageText3 = "",
		MessageText4 = "",
		
		SubTitleText1 = "",
		SubTitleText2 = "",
		SubTitleText3 = "",
		SubTitleText4 = "",
		SubTitleShowTime = 15,
		
		bAdvertising = 1,
		AdvertisingOnScreenText = "NewMissionAdded",
		AdvertisingOnScreenSize = 0.9,
		nAdvertisingOnScreenX = 200,
		nAdvertisingOnScreenY = 160,
		soundAdvertSound = "",
		nAdvertSoundVolume = 250,
		
		bFinishedAdvert = 1,
		FinishedAdvertOnScreenText = "Mission Completed",
		FinishedAdvertOnScreenSize = 0.9,
		nFinishedAdvertOnScreenX = 200,
		nFinishedAdvertOnScreenY = 160,		
		soundFinishedSound = "",
		nFinishedSoundVolume = 250,
		
		}, --Mission


	}, --properties
	
	Editor={
	Model="Objects/Editor/opcl_mission.cgf",
	},
}

function ClearingMissionTrigger:OnPropertyChange()
	self:OnReset();
end

function ClearingMissionTrigger:OnInit()
	self:EnableUpdate(0);
	self:SetUpdateType( eUT_Physics );
	self:TrackColliders(1);

	self.Who = nil;
	self.Entered = 0;
	self.bLocked = 0;
	self.bTriggered = 0;

	self:RegisterState("Inactive");
	self:RegisterState("Empty");
	self:RegisterState("Occupied");
	self:RegisterState("OccupiedUse");
	self:OnReset();
end

function ClearingMissionTrigger:OnShutDown()
end

function ClearingMissionTrigger:OnSave(stm)

	stm:WriteInt(self.bTriggered);
	stm:WriteInt(self.update);
	if (self.Who) then 
		if (self.Who == _localplayer) then 
			stm:WriteInt(0);
		else
			stm:WriteInt(self.Who.id);
		end
	else
		stm:WriteInt(-1);
	end
end


function ClearingMissionTrigger:OnLoad(stm)

	self.bTriggered=stm:ReadInt();
	self.update=stm:ReadInt();
	-- this complication is there to support loading.saving
	self.WhoID = stm:ReadInt();
	if (self.WhoID<0) then 
		self.WhoID = nil;
	elseif (self.WhoID==0) then 
		self.WhoID = 0;
	end
end

function ClearingMissionTrigger:OnLoadRELEASE(stm)

	self.bTriggered=stm:ReadInt();
end


function ClearingMissionTrigger:OnReset()
	self.bWasCountedAsMainMission = 0;        --used only temprary in tabscreen in tourist mode
	self.bWasCountedAsSubMission = 0;   	  --used only temprary in tabscreen in tourist mode
	self:KillTimer();
	self.bTriggered = 0;
	self.messagetimer = nil;
	local Min = { x=-self.Properties.DimX/2, y=-self.Properties.DimY/2, z=-self.Properties.DimZ/2 };
	local Max = { x=self.Properties.DimX/2, y=self.Properties.DimY/2, z=self.Properties.DimZ/2 };
	self:SetBBox( Min, Max );
	self.Who = nil;
	self.UpdateCounter = 0;
	self.Entered = 0;
	if(self.Properties.bEnabled==1)then
		self:GotoState( "Empty" );
	else
		self:GotoState( "Inactive" );
	end
	self.update = 0;

end





function ClearingMissionTrigger:Event_ActivateMission( sender )    --pvcf
	BroadcastEvent( self,"ActivateMission" );
	--Hud:AddMessage("$6 tried to send ACTIVATE MISSION event" ,4);	
	self:Event_Enter(sender);
	
	
end

function ClearingMissionTrigger:Event_MarkMissionSolved( sender )  --pvcf
	if (self:GetState( ) == "Inactive") then 
		--Hud:AddMessage("$6tried to markmissionsolved but i'm inactive" ,4);	
		return 
	end
	self.update = 0;
	if _localplayer and _localplayer.cnt and _localplayer.cnt.health < 1 then return; end
	
	BroadcastEvent( self,"MarkMissionSolved" );
	if self.Properties.Mission.bIsMainMission == 1 then 		
		Hud:CompleteObjective(self.Properties.Mission.MissionBoxText);		
	else	
		if opcl_ET_hudstyle then  --we ask if its a devkid game
			Hud:CompleteSubObjective(self.Properties.Mission.MissionBoxText);
		end
	end	

--Hud:AddMessage("$6 boing1" ,4);	

	if self.Properties.Mission.bFinishedAdvert == 1 then
		--Hud:AddMessage("$6 boing2" ,4);	
			if self.Properties.Mission.AdvertisingOnScreenText ~= "" then
				--Hud:AddMessage("$6 boing3" ,4);	
				opcl_automaticmissionadvert = 2; -- switch it off because we do it here manual  --0 off, 1 on, 2= off but on after advertising
				local text = self.Properties.Mission.FinishedAdvertOnScreenText ;
				local posx = self.Properties.Mission.nFinishedAdvertOnScreenX;
				local posy = self.Properties.Mission.nFinishedAdvertOnScreenY;				
				local size = self.Properties.Mission.FinishedAdvertOnScreenSize;
				if opcl_ET_hudstyle then --we ask if its a devkid game
					Hud:ShowMainMissionAdvertising(posx,posy,text,size);	
					--Hud:AddMessage("$6 boiung" ,4);				
				end
			else
				if opcl_ET_hudstyle then  --we ask if its a devkid game
					Hud:ShowMainMissionAdvertising();				
				end
			end
	end

	if self.Properties.Mission.soundFinishedSound ~= "" and opcl_ET_hudstyle then
		--Hud:AddMessage("$6 boing finished sound" ,4);				
		local volume = self.Properties.Mission.nFinishedSoundVolume;
		local wavname = self.Properties.Mission.soundFinishedSound;
		local posentityname = _localplayer;
		Hud:PlayInfoSound(wavname,radiusscale,posentityname,volume);
	end	


	if self.Properties.Mission.bClearTagPointOnMissionSolved == 1 then
		self:Event_DeActivateTagPoint();
	end
	if(self.Properties.bTriggerOnce==1)then
		self:GotoState("Inactive");
	end
	self:Event_Disable( sender );

end

function ClearingMissionTrigger:Event_DeleteAllMissionsFromList( sender )  --pvcf
	BroadcastEvent( self,"DeleteAllMissionsFromList" );
	Hud:FlashObjectives()  
end

function ClearingMissionTrigger:Event_DeleteAllSubMissionsFromList( sender )  --pvcf
	BroadcastEvent( self,"DeleteAllSubMissionsFromList" );
	if opcl_ET_hudstyle then  --we ask if its a devkid game
		Hud:FlashSubObjectives()  
	end
end

function ClearingMissionTrigger:Event_DeActivateTagPoint( sender )  --pvcf
	BroadcastEvent( self,"DeActivateTagPoint" );
	Hud:SetRadarObjective();
	Hud.radarObjective=nil;
end


function ClearingMissionTrigger:Event_Enter(sender)
	
	--System:Log( "Player "..sender:GetName().." Enter ClearingMissionTrigger "..self:GetName() );
	-- to make it not trigger when event sent to inactive tringger
	if (self:GetState( ) == "Inactive") then return end



	
	
	if self.Properties.DifficultyAvailibility.bDifficultyLvl_1 ~= 1 and tonumber(game_DifficultyLevel) == 0 then 
		if self.Properties.DifficultyAvailibility.DifficultyNotFitMessage ~= "" then
			Hud:AddMessage("$6"..self.Properties.DifficultyAvailibility.DifficultyNotFitMessage ,4);			
		end
		self.bTriggered = 0;
		self.Entered = 0;
		self:OnReset();
		return; 	
	end		
	if self.Properties.DifficultyAvailibility.bDifficultyLvl_2 ~= 1 and tonumber(game_DifficultyLevel) == 1 then 
		if self.Properties.DifficultyAvailibility.DifficultyNotFitMessage ~= "" then
			Hud:AddMessage("$6"..self.Properties.DifficultyAvailibility.DifficultyNotFitMessage ,4);			
		end
		self.bTriggered = 0;
		self.Entered = 0;		
		self:OnReset();
		return; 	
	end		
	if self.Properties.DifficultyAvailibility.bDifficultyLvl_3 ~= 1 and tonumber(game_DifficultyLevel) == 2 then
		if self.Properties.DifficultyAvailibility.DifficultyNotFitMessage ~= "" then
			Hud:AddMessage("$6"..self.Properties.DifficultyAvailibility.DifficultyNotFitMessage ,4);			
		end
		self.bTriggered = 0;
		self.Entered = 0;		
		self:OnReset();
		return; 	
	end		
	if self.Properties.DifficultyAvailibility.bDifficultyLvl_4 ~= 1 and tonumber(game_DifficultyLevel) == 3 then
		if self.Properties.DifficultyAvailibility.DifficultyNotFitMessage ~= "" then
			Hud:AddMessage("$6"..self.Properties.DifficultyAvailibility.DifficultyNotFitMessage ,4);			
		end
		self.bTriggered = 0;
		self.Entered = 0;		
		self:OnReset();
		return; 	
	end		
	if self.Properties.DifficultyAvailibility.bDifficultyLvl_5 ~= 1 and tonumber(game_DifficultyLevel) == 4 then
		if self.Properties.DifficultyAvailibility.DifficultyNotFitMessage ~= "" then
			Hud:AddMessage("$6"..self.Properties.DifficultyAvailibility.DifficultyNotFitMessage ,4);			
		end
		self.bTriggered = 0;
		self.Entered = 0;		
		self:OnReset();
		return; 	
	end		
	if self.Properties.DifficultyAvailibility.bDifficultyLvl_6 ~= 1 and tonumber(game_DifficultyLevel) == 5 then
		if self.Properties.DifficultyAvailibility.DifficultyNotFitMessage ~= "" then
			Hud:AddMessage("$6"..self.Properties.DifficultyAvailibility.DifficultyNotFitMessage ,4);			
		end
		self.bTriggered = 0;
		self.Entered = 0;		
		self:OnReset();
		return; 	
	end		

	if ((self.Entered ~= 0)) then
		return
	end

	if (self.Properties.bTriggerOnce == 1 and self.bTriggered == 1) then
		return
	end
		
	self.bTriggered = 1;
	self.Entered = 1;
	self.update = 1;
	-- Trigger script command on enter.
	if(self.Properties.ScriptCommand and self.Properties.ScriptCommand~="")then
		--self:Log( "Executing: "..self.Properties.ScriptCommand);
		dostring(self.Properties.ScriptCommand);
	end
	if(self.Properties.PlaySequence~="")then
		Movie:PlaySequence( self.Properties.PlaySequence );
	end

	BroadcastEvent( self,"Enter" );
	AI:RegisterWithAI(self.id, 0);
	--
	
	
	
	if self.Properties.Mission.bAdvertising == 1 then
		
	
			if self.Properties.Mission.AdvertisingOnScreenText ~= "" then
				opcl_automaticmissionadvert = 2; -- switch it off because we do it here manual  --0 off, 1 on, 2= off but on after advertising
				local text = self.Properties.Mission.AdvertisingOnScreenText ;
				local posx = self.Properties.Mission.nAdvertisingOnScreenX;
				local posy = self.Properties.Mission.nAdvertisingOnScreenY;				
				local size = self.Properties.Mission.AdvertisingOnScreenSize;
				if opcl_ET_hudstyle then --we ask if its a devkid game
					Hud:ShowMainMissionAdvertising(posx,posy,text,size);				
				end
			else
				if opcl_ET_hudstyle then  --we ask if its a devkid game
					Hud:ShowMainMissionAdvertising();				
				end
			end
	
		
	end
	--BroadcastEvent( self,"ActivateMission" );
	--self:Event_ActivateMission();
	if self.Properties.Mission.soundAdvertSound ~= "" and opcl_ET_hudstyle then
		--Hud:AddMessage("$6 boing sound" ,4);				
		local volume = self.Properties.Mission.nAdvertSoundVolume;
		local wavname = self.Properties.Mission.soundAdvertSound;
		local posentityname = _localplayer;
		Hud:PlayInfoSound(wavname,radiusscale,posentityname,volume);
	end	
	
	if self.Properties.Mission.bIsMainMission == 1 then 		
		Hud:PushObjective({},self.Properties.Mission.MissionBoxText);		
		--opcl_automaticmissionadvert = 1; -- switch it on because the own event is over which was evnetually called
	else	
		if opcl_ET_hudstyle then  --we ask if its a devkid game
			Hud:PushSubObjective({},self.Properties.Mission.MissionBoxText);
		end
		--opcl_automaticmissionadvert = 1; -- switch it on because the own event is over which was evnetually called
	end	

	 
	 if self.Properties.Mission.MissionTagPoint ~= "" then
	 	Hud:SetRadarObjective(self.Properties.Mission.MissionTagPoint);
	end
	 	

	
	if self.Properties.Mission.textureRadarObjective and self.Properties.Mission.textureRadarObjective ~= "" then
			
		Hud.RadarObjectiveIcon = nil;
			
		opcl_RadarObjectiveIcon=System:LoadImage("Textures/hud/RadarPlayer.dds");
		Hud.RadarObjectiveIcon=opcl_RadarObjectiveIcon;
		--Hud:AddMessage(" changed objective icon",10);			
	end
	
	
	
	
	--self:Log( "Player "..sender:GetName().." Enter ClearingMissionTrigger "..self:GetName() );
end






function ClearingMissionTrigger:OnUpdate()



								------------------------------------------------------reduces the update per frame amount-------------------------
					if(not self.messagetimer)then self.messagetimer=System:GetCurrTime(); end				
					if(System:GetCurrTime()-self.messagetimer>5) then
								------------------------------------------------------reduces the update per frame amount-------------------------

	if self.Properties.Mission.MessageText1 ~= "" then 
		Hud:AddMessage(self.Properties.Mission.MessageText1);	
	end
	if self.Properties.Mission.MessageText2 ~= "" then 
		Hud:AddMessage(self.Properties.Mission.MessageText2);	
	end
	if self.Properties.Mission.MessageText3 ~= "" then 
		Hud:AddMessage(self.Properties.Mission.MessageText3);	
	end
	if self.Properties.Mission.MessageText4 ~= "" then 
		Hud:AddMessage(self.Properties.Mission.MessageText4);	
	end			
	if self.Properties.Mission.SubTitleText1 ~= "" then 
		Hud:AddSubtitle(self.Properties.Mission.SubTitleText1,self.Properties.Mission.SubTitleShowTime);	
	end
	if self.Properties.Mission.SubTitleText2 ~= "" then 
		Hud:AddSubtitle(self.Properties.Mission.SubTitleText2,self.Properties.Mission.SubTitleShowTime);	
	end
	if self.Properties.Mission.SubTitleText3 ~= "" then 
		Hud:AddSubtitle(self.Properties.Mission.SubTitleText3,self.Properties.Mission.SubTitleShowTime);	
	end
	if self.Properties.Mission.SubTitleText4 ~= "" then 
		Hud:AddSubtitle(self.Properties.Mission.SubTitleText4,self.Properties.Mission.SubTitleShowTime);	
	end											
								self.update = 0;
								
								------------------------------------------------------reduces the update per frame amount-------------------------								
					self.messagetimer=nil;
					end 	 	
								------------------------------------------------------reduces the update per frame amount-------------------------			


end



function ClearingMissionTrigger:Event_Leave( sender )
	if (self.Entered == 0) then
		return
	end
	self.Entered = 0;
	BroadcastEvent( self,"Leave" );

	--System:Log( "Player "..sender:GetName().." Leave ClearingMissionTrigger "..self:GetName() );
	

end

function ClearingMissionTrigger:Event_Enable( sender )
	self:GotoState("Empty")
	BroadcastEvent( self,"Enable" );
end

function ClearingMissionTrigger:Event_Disable( sender )
	--System:Log( "Player "..sender:GetName().." Disable ClearingMissionTrigger "..self:GetName() );
	self:GotoState( "Inactive" );
	AI:RegisterWithAI(self.id, 0);
	BroadcastEvent( self,"Disable" );
	self.update = 0;
end

-- Check if source entity is valid for triggering.
function ClearingMissionTrigger:IsValidSource( entity )

	if (self.Properties.SpecificObjectName) and (self.Properties.SpecificObjectName ~= "") then
 		if (self.Properties.SpecificObjectName == entity:GetName()) then
 			return 1; else
 			return 0;
 		end
	end
	
	if self.Properties.bNoVehicle == 1 and entity.theVehicle then
		return 0;
	end

	if (self.Properties.bOnlyPlayer ~= 0 and entity.type ~= "Player") then
		return 0;
	end

	if (self.Properties.bOnlySpecialAI ~= 0 and entity.ai ~= nil and entity.Properties.special==0) then 
		return 0;
	end

	-- if Only for AI, then check
	if (self.Properties.bOnlyAI ~=0 and entity.ai == nil) then
		return 0;
	end

		-- Ignore if not my player.
	if (self.Properties.bOnlyMyPlayer ~= 0 and entity ~= _localplayer) then
		return 0;
	end

	-- if only in vehicle - check if collider is in vehicle
	if (self.Properties.bInVehicleOnly ~= 0 and not entity.theVehicle) then
		return 0;
	end





	-----------pvcfmod-------------
	--if (entity.cnt.health <= 0) then 
	
	if entity.cnt and entity.cnt.health <= 0 then 
	-----------pvcfmod-------------
		return 0;
	end


	return 1;
end

-- Inactive State ---

ClearingMissionTrigger.Inactive =
{
	OnBeginState = function( self )
		AI:RegisterWithAI(self.id, 0);
	end,
	OnEndState = function( self )
	end,
}
-------------------------------------------------------------------------------
-- Empty State ----------------------------------------------------------------
-------------------------------------------------------------------------------
ClearingMissionTrigger.Empty =
{
	-------------------------------------------------------------------------------
	OnBeginState = function( self )
		self.Who = nil;
		self.UpdateCounter = 0;
		self.Entered = 0;
		if (self.Properties.aianchorAIAction~="") then
		AI:RegisterWithAI(self.id, AIAnchor[self.Properties.aianchorAIAction]);
		end
	end,

	OnTimer = function( self )
	self:GotoState( "Occupied" );
	end,

	-------------------------------------------------------------------------------
	OnEnterArea = function( self,entity,areaId )


		if (self:IsValidSource(entity) == 0) then
			return
		end
		

		
		if (entity.ai==nil) then
			if (self.Properties.bActivateWithUseButton~=0) then
				self.Who = entity;
				self:GotoState( "OccupiedUse" );
				do return end;
			end
		end
		
		if (self.Properties.EnterDelay > 0) then
			if (self.Who == nil) then
				-- Not yet triggered.
				self.Who = entity;
				self:SetTimer( self.Properties.EnterDelay*1000 );
			end
		else
			self.Who = entity;
			self:GotoState( "Occupied" );
		end
	end,


}

-------------------------------------------------------------------------------
-- Occupied State ----------------------------------------------------------------
-------------------------------------------------------------------------------
ClearingMissionTrigger.Occupied =
{
	-------------------------------------------------------------------------------
	OnBeginState = function( self )
	self:Event_Enter(self.Who);
	

	end,

	-------------------------------------------------------------------------------
	OnTimer = function( self )
		--self:Log("Sending on leave");
		self:Event_Leave( self,self.Who );
		if(self.Properties.bTriggerOnce~=1)then
			self:GotoState("Empty");
		end
	end,

	-------------------------------------------------------------------------------
	OnLeaveArea = function( self,entity,areaId )
		-- Ignore if disabled.
		--add a very small delay(so is immediate)
		if (self:IsValidSource(entity) == 0) then
			return
		end
		
		if(self.Properties.ExitDelay==0) then
			self.Properties.ExitDelay=0.01;
		end
		self:SetTimer(self.Properties.ExitDelay*1000);
	end,
}

-------------------------------------------------------------------------------
-- OccupiedText State ---------------------------------------------------------
-------------------------------------------------------------------------------
ClearingMissionTrigger.OccupiedUse =
{
	-------------------------------------------------------------------------------
	OnBeginState = function( self )
		self:EnableUpdate(1);
	end,
	-------------------------------------------------------------------------------
	OnEndState = function( self )
		self:EnableUpdate(0);
	end,
	-------------------------------------------------------------------------------
	OnUpdate = function( self )

		if (self.WhoID) then 
			if (self.WhoID == 0) then 
				self.Who = _localplayer;
			else
				self.Who = System:GetEntity(self.WhoID);
			end
			self.WhoID = nil;
		end

		if (self.Who.cnt) then			
			if (not self.Who.cnt.use_pressed) then			
				if (strlen(self.Properties.TextInstruction)>0) then
					Hud.label = self.Properties.TextInstruction;
				end
				do return end;
			end
		end

		if (self.Properties.EnterDelay > 0) then
			self:SetTimer( self.Properties.EnterDelay*1000 );
		else
			self:GotoState( "Occupied" );
		end
	end,
	
	
	
	-------------------------------------------------------------------------------
	OnTimer = function( self )
		self:GotoState( "Occupied" );
	end,

	-------------------------------------------------------------------------------
	OnLeaveArea = function( self,entity,areaId )
		if (self.Who == entity) then
			self:GotoState( "Empty" );
		end
	end,
}