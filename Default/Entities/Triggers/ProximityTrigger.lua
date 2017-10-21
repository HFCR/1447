-- Description :		Delayed proxymity trigger
--
-- Create by Alberto :	03 March 2002
-- Modified by SHINING. v2.0
-- Modified by Mixer. 2.5

ProximityTrigger = {
	type = "Trigger",

	Properties = {
		DimX = 1,
		DimY = 1,
		DimZ = 1,
		bEnabled=1,
		EnterDelay=0,
		ExitDelay=0,
		bOnlyPlayer=1,
		bOnlyMyPlayer=0,
		bOnlyAI = 0,
		bOnlySpecialAI = 0,
		bTriggerOnce=0,
		ScriptCommand="",
		PlaySequence="",
		SpecificObjectName="",
		aianchorAIAction = "",
		TextInstruction = "",
		bActivateWithUseButton=0,
		bInVehicleOnly=0,
		UsingParams = {
			bHoldTheButtonToUseIt=0, -- K0tanski
			HoldTime=0, -- K0tanski
			Sound = {
				bUseSound=0,
				sndSource = "Sounds/items/button1type.wav",
				-- sndSource = "Sounds/items/bombcount.wav",
				iVolume=255,
				InnerRadius=5,
				OuterRadius=32,
				-- fFadeValue=1, -- for indoor sector sounds
				-- bLoop=1,	-- Loop sound.
				-- bPlay=0,	-- Immidiatly start playing on spawn.
				-- bOnce=0,
				-- bEnabled=1,
			},
		},
	},

	Editor={
	Model="Objects/Editor/T.cgf",
	},
}

function ProximityTrigger:OnPropertyChange()
	self:OnReset();
end

function ProximityTrigger:OnInit()
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

function ProximityTrigger:OnShutDown()
end

function ProximityTrigger:OnSave(stm)

	stm:WriteInt(self.bTriggered);
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


function ProximityTrigger:OnLoad(stm)

	self.bTriggered=stm:ReadInt();

	-- this complication is there to support loading.saving
	self.WhoID = stm:ReadInt();
	if (self.WhoID<0) then
		self.WhoID = nil;
	elseif (self.WhoID==0) then
		self.WhoID = 0;
	end
end

function ProximityTrigger:OnRemoteEffect(toktable, pos, normal, userbyte)
	if userbyte == 1 then
		if not Game:IsServer() then
			self.WhoID = floor(pos.x);
		end
	elseif userbyte == 2 then
		if self.TypingSound then
			if not Sound:IsPlaying(self.TypingSound) then
				Sound:SetSoundPosition(self.TypingSound,self:GetPos());
				Sound:PlaySound(self.TypingSound);
			end
		end
	elseif userbyte == 3 then
		if self.TypingSound then
			if Sound:IsPlaying(self.TypingSound) then
				Sound:StopSound(self.TypingSound)
			end
		end
	end
end

function ProximityTrigger:OnLoadRELEASE(stm)

	self.bTriggered=stm:ReadInt();
end

function ProximityTrigger:LoadSound() -- K0tanski
	if self.Properties.bActivateWithUseButton==1 and self.Properties.UsingParams.bHoldTheButtonToUseIt==1 and self.Properties.UsingParams.HoldTime>0
	and self.Properties.UsingParams.Sound.bUseSound==1 and self.Properties.UsingParams.Sound.sndSource~="" then
			self.TypingSound=nil
			self.TypingSound = Sound:Load3DSound(self.Properties.UsingParams.Sound.sndSource,SOUND_RADIUS,self.Properties.UsingParams.Sound.iVolume,
			self.Properties.UsingParams.Sound.InnerRadius,self.Properties.UsingParams.Sound.OuterRadius); -- Триггеры иногда воруют звуки друг у друга, точнее, новые, поставленнные в редакторе, перебивают параметры звука у тех, которые уже стоят и приходится вручную перезагружать скрипты. Пока не знаю в чём дело.
			-- Hud:AddMessage(self:GetName()..": LoadSound")
	elseif self.TypingSound then self.TypingSound=nil end
end


function ProximityTrigger:OnReset()
	self:KillTimer();
	self.bTriggered = 0;

	local Min = { x=-self.Properties.DimX/2, y=-self.Properties.DimY/2, z=-self.Properties.DimZ/2 };
	local Max = { x=self.Properties.DimX/2, y=self.Properties.DimY/2, z=self.Properties.DimZ/2 };
	self:SetBBox( Min, Max );
	self.Who = nil;
	self.UpdateCounter = 0;
	self.Entered = 0;
	if self.Properties.bEnabled==1 then
		self:LoadSound()
		self:GotoState( "Empty" );
	else
		if self.TypingSound then self.TypingSound=nil end
		self:GotoState( "Inactive" );
	end


end

function ProximityTrigger:Event_Enter( sender )

	-- to make it not trigger when event sent to inactive tringger
	if (self:GetState( ) == "Inactive") then return end

	if ((self.Entered ~= 0)) then
		return
	end
	if (self.Properties.bTriggerOnce == 1 and self.bTriggered == 1) then
		return
	end

	self.bTriggered = 1;
	self.Entered = 1;
	-- Trigger script command on enter.

	if (self.Properties.ScriptCommand) and (self.Properties.ScriptCommand~="") then
		if (Game:IsServer()) then
			dostring(self.Properties.ScriptCommand);
		end
	end
	if (self.Properties.PlaySequence~="") then
		Movie:PlaySequence( self.Properties.PlaySequence );
	end

	if (self.Who) and (self.Who.POTSHOTS) and (Game:IsServer()) then
		if self.Properties.TextInstruction == "goprone" then
			self.Who:InsertSubpipe(0,'setup_prone');
			self.Who.stancetoggle_d = 1;
		elseif self.Properties.TextInstruction == "gocrouch" then
			self.Who:InsertSubpipe(0,'setup_crouch');
			self.Who.stancetoggle_d = 1;
		end
	end

	BroadcastEvent( self,"Enter" );
	AI:RegisterWithAI(self.id, 0);

end


function ProximityTrigger:Event_Leave( sender )
	if (self.Entered == 0) then
		return
	end
	self.Entered = 0;
	BroadcastEvent( self,"Leave" );

	if (self.Who) and (self.Who.stancetoggle_d) then
		self.Who.stancetoggle_d = nil;
		self.Who:InsertSubpipe(0,'setup_combat');
	end

	if (self.Properties.bTriggerOnce==1) then
		self:GotoState("Inactive");
	end
end

-- new service function to use the trigger as smart teleport
function ProximityTrigger:MoveVisitorTo(new_pos)
	if (self.Who) then
		if type(new_pos)=="table" then
			local whopos = new(self.Who:GetPos());
			local my_pos = new(self:GetPos());
			if (whopos.z < my_pos.z) then
				self.Who:SetPos(new_pos);
			end
		else
			local np = System:GetEntityByName(new_pos);
			if (np) then
				self.np_pos = np:GetPos();
				self.np_ang = np:GetAngles();
				self.Who:SetPos(self.np_pos);
				self.Who:SetAngles(self.np_ang);
				if (Game:IsServer()) then
					self.Who:EnablePhysics(0);
					self.Who:EnablePhysics(1);
					if (self.Who.POTSHOTS) then
						self.Who:TriggerEvent(AIEVENT_CLEAR);
						AI:EnablePuppetMovement(self.Who.id,0,1);
					end
				end
				self.np_pos = nil; self.np_ang = nil;
				if (Game:IsServer()) then
					Server:BroadcastCommand("PLAS "..self.id.." "..self.Who.id);
				end
			end
		end
	end
end

function ProximityTrigger:Event_Enable( sender )
	self:GotoState("Empty")
	BroadcastEvent( self,"Enable" );
end

function ProximityTrigger:Event_Disable( sender )
	self:GotoState( "Inactive" );
	AI:RegisterWithAI(self.id, 0);
	BroadcastEvent( self,"Disable" );
end

-- Check if source entity is valid for triggering.
function ProximityTrigger:IsValidSource( entity )

if (self.Properties.SpecificObjectName) and (self.Properties.SpecificObjectName ~= "") then
 if (self.Properties.SpecificObjectName == entity:GetName()) then
 return 1; else
 return 0;
 end
end

	if (self.Properties.bOnlyPlayer ~= 0 and entity.type ~= "Player") then
		return 0;
	end

	if (self.Properties.bOnlySpecialAI ~= 0 and entity.ai ~= nil and entity.Properties.special==0) then
	return 0;
	end

	-- if Only for AI, then check
	if (self.Properties.bOnlyAI ~=0 and entity.POTSHOTS == nil) then
	return 0;
	end

	-- Ignore if not my player.
	if (self.Properties.bOnlyMyPlayer ~= 0 and entity.classname ~= "Player") then
		return 0;
	end

	-- if only in vehicle - check if collider is in vehicle
	if (self.Properties.bInVehicleOnly ~= 0 and not entity.theVehicle) then
		return 0;
	end

	if (entity.cnt) and (entity.cnt.health <= 0) then
		return 0;
	end

	return 1;
end

-- Inactive State ---

ProximityTrigger.Inactive =
{
	OnBeginState = function( self )
		AI:RegisterWithAI(self.id, 0);
	end,
	OnEndState = function( self )
	end,
}
-----
-- Empty State ---------
-----
ProximityTrigger.Empty =
{
	------------
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

	----------
	OnEnterArea = function( self,entity,areaId )
		if (self:IsValidSource(entity) == 0) then
			return
		end

		if (entity.POTSHOTS == nil) then
			if (self.Properties.bActivateWithUseButton~=0) then
				self.Who = entity;
				if (GameRules) then
					if (GameRules.coop_mission) and (GameRules.coop_mission~=99) and (self.Properties.TextInstruction == "@cis_coop_goto") then
						GameRules:SetCoopMission(99);
						Server:BroadcastCommand("SSP "..self.Who.id);
					end
					self:GotoState( "OccupiedUse" );
					Server:BroadcastCommand("FX",{x=self.Who.id,y=0,z=0},{x=0,y=0,z=0},self.id,1);
				end
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

---------------
-- Occupied State -------
-------------
ProximityTrigger.Occupied =
{
	-----------
	OnBeginState = function( self )
	self:Event_Enter(self.Who);
	end,

	--------
	OnTimer = function( self )
		--self:Log("Sending on leave");
		self:Event_Leave( self,self.Who );
		if(self.Properties.bTriggerOnce~=1)then
			self:GotoState("Empty");
		end
	end,

	---------
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

-------------------
-- OccupiedText State ------
-------------------------
ProximityTrigger.OccupiedUse =
{
	-------------------
	OnBeginState = function( self )
		self:EnableUpdate(1);
		self.KeyPressed = nil
		self.HoldTimerStart = nil
	end,
	-----------------
	OnEndState = function( self )
		self.KeyPressed = nil
		self.HoldTimerStart = nil
		Server:BroadcastCommand("FX",{x=0,y=0,z=0},{x=0,y=0,z=0},self.id,3)
		self:EnableUpdate(0);
	end,
	---------------
	OnUpdate = function( self )

		if (self.WhoID) then
			if (self.WhoID == 0) then
				self.Who = _localplayer;
			else
				self.Who = System:GetEntity(self.WhoID);
			end
			self.WhoID = nil;
		end

		if (self.Who) and (self.Who.cnt) then
			if (not self.Who.cnt.use_pressed and not self.KeyPressed) then
				if Hud then
					if self.Properties.TextInstruction~="" then
						if (self.Properties.TextInstruction == "@cis_coop_goto") then
							Hud.label = self.Properties.TextInstruction.." $1 @Level"..self:GetName();
						else
							Hud.label = self.Properties.TextInstruction;
						end
					elseif self.Properties.UsingParams.bHoldTheButtonToUseIt==1 and self.Properties.UsingParams.HoldTime>0 then -- K0tanski
						Hud.label = "@HoldTheButtonToUseIt"
						-- Hud.label = "@HoldTheButtonToUseIt"..", @HoldTime: "..self.Properties.UsingParams.HoldTime
						-- Hud.label = "@HoldTheButtonToUseIt"..": "..self.Properties.UsingParams.HoldTime
					end
				end
				do return end;
			end
			if (not Game:IsServer()) then
				do return end;
			end
			if (self.Properties.ExitDelay == 1) then
				-- Mixer: perform fake pushing anim
				local sslt = Server:GetServerSlotByEntityId(self.Who.id);
				if (sslt) then
					sslt:SendCommand('HUD W 8');
				end
			end
		end

		if (self.Properties.EnterDelay > 0) then
			self:SetTimer( self.Properties.EnterDelay*1000 );
		elseif self.Properties.UsingParams.bHoldTheButtonToUseIt==1 and self.Properties.UsingParams.HoldTime>0 then -- Держать кнопку чтобы использовать это. -- K0tanski
			if self.Properties.UsingParams.HoldTime and self.Properties.UsingParams.HoldTime>0 then
				local szKeyName = Input:GetXKeyDownName()
				self.KeyPressed = nil
				local KeyId = {10}
				for j,val in KeyId do
					local Binding = Input:GetBinding("default",val)
					for k,val2 in Binding do
						if val2 and szKeyName==val2.key then
							self.KeyPressed = 1
							-- Hud:AddMessage(self:GetName()..": self.KeyPressed = 1")
						end
					end
				end
				if not self.KeyPressed and self.HoldTimerStart then
					self.HoldTimerStart=nil
					Server:BroadcastCommand("FX",{x=0,y=0,z=0},{x=0,y=0,z=0},self.id,3)
				else
					if not self.HoldTimerStart then self.HoldTimerStart=_time end
					if _time>self.HoldTimerStart+self.Properties.UsingParams.HoldTime then
						self:GotoState("Occupied");
						-- Hud:AddMessage(self:GetName()..": $4BOOM!!!")
						-- System:Log(self:GetName()..": $4BOOM!!!")
					else
						local Timer = self.Properties.UsingParams.HoldTime-(_time-self.HoldTimerStart) -- Обратный отсчёт.
						-- local LabelTimer = sprintf("%i",Timer) -- Перевод в целое(то есть, чтобы не было дробных, без которых отображаются только секунды).
						local LabelTimer = Timer -- Без перевода, шкала плавно заполняется.
						-- Hud.label = "@DelayForUse: "..LabelTimer; -- Обычный таймер на экране.
						local slot;
						slot=Server:GetServerSlotByEntityId(self.Who.id)
						local PerPercent=100;
						local max = self.Properties.UsingParams.HoldTime
						if max>0 then
							PerPercent=100-(100*LabelTimer)/max -- 0..100
						end
						-- local str=format("%.0f",PerPercent) -- Зачем это нужно (format)?
						local str=PerPercent
						slot:SendCommand("UDD".." "..str); -- Как с ключём. -- ClientStuff.lua/ClientStuff.ServerCommandTable["UDD"]=function(String,toktable)
						Server:BroadcastCommand("FX",{x=0,y=0,z=0},{x=0,y=0,z=0},self.id,2) -- Для звука. Вызывается местный OnRemoteEffect.
					end
				end
			end
		else
			self:GotoState( "Occupied" );
		end
	end,

	-----------------------------------------------
	OnTimer = function( self )
		self.KeyPressed = nil
		self.HoldTimerStart = nil
		self:GotoState( "Occupied" );
	end,

	------------------------------------------------
	OnLeaveArea = function( self,entity,areaId )
		if (self.Who == entity) then
			self.KeyPressed = nil
			self.HoldTimerStart = nil
			Server:BroadcastCommand("FX",{x=0,y=0,z=0},{x=0,y=0,z=0},self.id,3)
			self:GotoState( "Empty" );
		end
	end,
}