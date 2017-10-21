-- Description :		number proxymity trigger
--
-- Create by Alberto :	03 March 2002
-- Modified by SHINING. v2.0
-- Modified by Mixer. 2.5

ProximityNumberTrigger = {
	type = "Trigger",

	Properties = {
		DimX = 1,
		DimY = 1,
		DimZ = 1,
		bEnabled=1,
		EnterDelay=0,
		ExitDelay=0,
		bOnlyPlayer=1,
		bOnlyMyPlayer=1,
		bOnlyAI = 0,
		bOnlySpecialAI = 0,
		ScriptCommand="",
		PlaySequence="",
		sNumberSequence="2004",
		aianchorAIAction = "",
		TextInstruction= "use_hint",
		bInVehicleOnly=0,
		nZAngle=0,
		sndTypingSound = "Sounds/items/button1type.wav",
		sndPassedSound = "Sounds/items/edoorlock.wav",
		sndDeniedSound = "Sounds/items/button1type.wav",
	},
	
	Editor={
	Model="Objects/Editor/T.cgf",
	},
}

function ProximityNumberTrigger:OnPropertyChange()
	self:OnReset();
end

function ProximityNumberTrigger:OnInit()
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
	
	if Game:IsClient() then
		self.TypingSound = Sound:Load3DSound(self.Properties.sndTypingSound,SOUND_RADIUS,255,5,32);
		self.PassedSound = Sound:Load3DSound(self.Properties.sndPassedSound,SOUND_RADIUS,255,5,32);
		self.DeniedSound = Sound:Load3DSound(self.Properties.sndDeniedSound,SOUND_RADIUS,255,5,32);
	end
	
	self:OnReset();
end

function ProximityNumberTrigger:ProcessKeyPadCode(kpadcode)
	if tostring(kpadcode) == tostring(self.Properties.sNumberSequence) then
		self:Event_Enter();
		self:GotoState( "Inactive" );
		AI:RegisterWithAI(self.id, 0);
		Server:BroadcastCommand("FX",{x=0,y=0,z=0},{x=0,y=0,z=0},self.id,2);
	elseif (strlen(kpadcode) < self.maxsymbols) then
		Server:BroadcastCommand("FX",{x=0,y=0,z=0},{x=0,y=0,z=0},self.id,4);
	else
		Server:BroadcastCommand("FX",{x=0,y=0,z=0},{x=0,y=0,z=0},self.id,3);
	end
end

function ProximityNumberTrigger:OnShutDown()
end

function ProximityNumberTrigger:OnRemoteEffect(toktable, pos, normal, userbyte)
	if (userbyte == 1) then -- get typer
		if (not Game:IsServer()) then
			self.lasttyperid = floor(pos.x);
			self.maxsymbols = floor(pos.y);
		end
	elseif (userbyte == 2) then -- get passed
		Sound:SetSoundPosition(self.PassedSound,self:GetPos());
		Sound:PlaySound(self.PassedSound);
		if (not Game:IsServer()) then
			BroadcastEvent( self,"Enter" );
		end
	elseif (userbyte == 3) then -- get denied
		Sound:SetSoundPosition(self.DeniedSound,self:GetPos());
		Sound:PlaySound(self.DeniedSound);
		self.typingcode = "";
	else -- just play typing sound
		Sound:SetSoundPosition(self.TypingSound,self:GetPos());
		Sound:PlaySound(self.TypingSound);
	end
end

function ProximityNumberTrigger:OnSave(stm)

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


function ProximityNumberTrigger:OnLoad(stm)

	self.bTriggered=stm:ReadInt();

	-- this complication is there to support loading.saving
	self.WhoID = stm:ReadInt();
	if (self.WhoID<0) then 
		self.WhoID = nil;
	elseif (self.WhoID==0) then 
		self.WhoID = 0;
	end
end

function ProximityNumberTrigger:OnLoadRELEASE(stm)

	self.bTriggered=stm:ReadInt();
end


function ProximityNumberTrigger:OnReset()
	self:KillTimer();
	self.bTriggered = 0;

	local Min = { x=-self.Properties.DimX/2, y=-self.Properties.DimY/2, z=-self.Properties.DimZ/2 };
	local Max = { x=self.Properties.DimX/2, y=self.Properties.DimY/2, z=self.Properties.DimZ/2 };
	self:SetBBox( Min, Max );
	self.Who = nil;
	self.UpdateCounter = 0;
	self.Entered = 0;
	if(self.Properties.bEnabled==1) then
		self:GotoState( "Empty" );
	else
		self:GotoState( "Inactive" );
	end
	self.triggrname = "@"..self:GetName();

end

function ProximityNumberTrigger:Event_Enter( sender )

	-- to make it not trigger when event sent to inactive tringger
	if (self:GetState( ) == "Inactive") then return end

	--if ((self.Entered ~= 0)) then
	--	return
	--end
	--if (self.Properties.bTriggerOnce == 1 and self.bTriggered == 1) then
	--	return
	--end
	
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

	BroadcastEvent( self,"Enter" );
	--AI:RegisterWithAI(self.id, 0);
end

function ProximityNumberTrigger:Event_Leave( sender )
	if (self.Entered == 0) then
		return
	end
	self.Entered = 0;
	BroadcastEvent( self,"Leave" );
	
	if (self.Who) and (self.Who.stancetoggle_d) then
		self.Who.stancetoggle_d = nil;
		self.Who:InsertSubpipe(0,'setup_combat');
	end
	
	--if (self.Properties.bTriggerOnce==1) then
	--	self:GotoState("Inactive");
	--end
end

function ProximityNumberTrigger:Event_Enable( sender )
	self:GotoState("Empty")
	BroadcastEvent( self,"Enable" );
end

function ProximityNumberTrigger:Event_Disable( sender )
	self:GotoState( "Inactive" );
	AI:RegisterWithAI(self.id, 0);
	BroadcastEvent( self,"Disable" );
end

-- Check if source entity is valid for triggering.
function ProximityNumberTrigger:IsValidSource( entity )

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

ProximityNumberTrigger.Inactive =
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
ProximityNumberTrigger.Empty =
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
			self.Who = entity;
			self:GotoState( "OccupiedUse" );
			do return end;
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
ProximityNumberTrigger.Occupied =
{
	-----------
	OnBeginState = function( self )
		--self:Event_Enter(self.Who);
		self:EnableUpdate(1);
		self.typingcode = "";
		if (Game:IsServer()) then
			self.maxsymbols = strlen(self.Properties.sNumberSequence);
		end
	end,

	--------
	OnTimer = function( self )
		--self:Log("Sending on leave");
		self:Event_Leave( self,self.Who );
		--if(self.Properties.bTriggerOnce~=1)then
			self:GotoState("Empty");
		--end
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
	OnEndState = function(self)
		self:EnableUpdate(0);
	end,
	OnUpdate = function( self )
		if (self.Who) and (self.Who.cnt) then
			if (self.Who.cnt.use_pressed) then
				self.Who.cnt.use_pressed = nil;
				if (not Game:IsServer()) then
					do return end;
				end
				self:GotoState( "OccupiedUse" );
			end
		end
		if (self.lasttyperid) and (_localplayer) then
			local typerent = System:GetEntity(self.lasttyperid);
			if (typerent) and (typerent == _localplayer) then
				if (self.Properties.nZAngle ~= 0) then
					local viewerangles = _localplayer:GetAngles();
					if (viewerangles.z > self.Properties.nZAngle + 25) or (viewerangles.z < self.Properties.nZAngle - 25) then
						return
					end
				end
				
				-----------
				if (Hud.cis_lastkey) then
					if (Hud.prvious_pressd_key) and (Hud.prvious_pressd_key == Hud.cis_lastkey) then
						Hud.prvious_pressd_key = nil;
						return;
					end
					local np_token = strfind(Hud.cis_lastkey,"numpad");
					if (np_token) then
						Hud.cis_lastkey = strsub(Hud.cis_lastkey,7);
					end
					if tonumber(Hud.cis_lastkey) then
						if (strlen(self.typingcode)<self.maxsymbols) then
							self.typingcode = self.typingcode..Hud.cis_lastkey;
						end
						Hud.prvious_pressd_key = Hud.cis_lastkey.."";
						if Game:IsServer()==nil then
							Client:SendCommand("VBSPE "..self.id.." "..self.typingcode);
						else
							self:ProcessKeyPadCode(self.typingcode);
						end
					end
				else
					Hud.prvious_pressd_key = nil;
				end
				-----------------------------------------------
				if (not _localplayer.fakeactionmapvehicle) then
					_localplayer.fakeactionmapvehicle = 1;
					Input:SetActionMap("vehicle");
				end
				if (Hud) then
					Hud.npcdialogdata = {};
					Hud.npcdialogdata.typingcode = self.typingcode.."";
					Hud.npcdialogdata.triggrname = self.triggrname.."";
					Hud.npcdialogtimer = _time;
				end
			end
		end
	end
}

-------------------
-- OccupiedText State ------
-------------------------
ProximityNumberTrigger.OccupiedUse =
{
	-------------------
	OnBeginState = function( self )
		self:EnableUpdate(1);
	end,
	-----------------
	OnEndState = function( self )
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
			if (not self.Who.cnt.use_pressed) then
				if (self.Properties.TextInstruction ~= "") and (Hud) then
					Hud.label = self.Properties.TextInstruction;
				end
				do return end;
			end
			
			self.Who.cnt.use_pressed = nil;
			
			if (not Game:IsServer()) then
				do return end;
			end

			self.lasttyperid = floor(self.Who.id);
			Server:BroadcastCommand("FX",{x=self.lasttyperid,y=strlen(self.Properties.sNumberSequence),z=0},{x=0,y=0,z=0},self.id,1);

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
		else
			self:GotoState( "Occupied" );
		end
	end,
	
	-----------------------------------------------
	OnTimer = function( self )
		self:GotoState( "Occupied" );
	end,

	------------------------------------------------
	OnLeaveArea = function( self,entity,areaId )
		if (self.Who == entity) then
			self:GotoState( "Empty" );
		end
	end,
}