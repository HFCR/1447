-- SPECIAL CLIENT/SERVER AUTODOOR (NOT IDEAL YET). EXTENDED BY MIXER 2011
AutomaticDoor = {
Properties = {
Direction = {
		X=1,
  		Y=0,
		Z=0,
  		},
  		CloseDelay=1.5,
  		BBOX_Size={
		X=3,
  		Y=3,
		Z=2,
  		},
  		fHitImpulse = 10,
		AISoundEvent = {
		bEnabled = 0,
		fRadius = 10,
		},
  		MovingDistance = 0.9,
  		MovingSpeed = 2,
  		bPlayerBounce = 1,
  		bPlayerOnly = 0,
		fileAnimatedModel= "",
  		fileModel_Left = "Objects/glm/ww2_indust_set1/doors/door_indust_2_left.cgf",
  		fileModel_Right = "Objects/glm/ww2_indust_set1/doors/door_indust_2_right.cgf",
  		fileOpenSound = "Sounds/doors/open.wav",
  		fileCloseSound = "Sounds/doors/close.wav",
		fileUnlockSound = "sounds/items/bombactivate.wav",
  		bAutomatic = 1,
  		bCloseTimer = 1,
  		bEnabled = 1,
  		iNeededKey=-1,
		bUseAnimatedModel=0,
		bUsePortal=1,
		TextInstruction="",
		bAllowRigidBodiesToOpenDoor=1,
  	},
  CurrModel = "Objects/lift/lift.cgf",
  temp_vec={x=0,y=0,z=0},
  Distance = 0,
  EndReached=nil,
  OpeningTime=0,
  bLocked=false,
  bInitialized=nil,
}
function AutomaticDoor:OnPropertyChange()
	self:OnReset();
	if ( self.Properties.fileOpenSound ~= self.CurrOpenSound ) then
		self.CurrOpenSound=self.Properties.fileOpenSound;
		self.OpenSound=Sound:Load3DSound(self.CurrOpenSound);
	end
	if ( self.Properties.fileCloseSound ~= self.CurrCloseSound ) then
		self.CurrCloseSound=self.Properties.fileCloseSound;
		self.CloseSound=Sound:Load3DSound(self.CurrCloseSound);
	end
end

function AutomaticDoor:OnReset()
	self.AI_SIGNAL_GENERATED=nil;
	if (self.Properties.bUseAnimatedModel==0) then
		if (self.Properties.fileModel_Right ~= "") then
			self:LoadObject( self.Properties.fileModel_Right, 0, 0 );
		end
		if (self.Properties.fileModel_Left ~= "") then
			self:LoadObject( self.Properties.fileModel_Left, 1, 0 );
		end
		self:DrawObject( 0, 1 );
		self:DrawObject( 1, 1 );
		self:CreateStaticEntity(100,-1);
	else
		self:LoadCharacter(self.Properties.fileAnimatedModel, 0 ,0);
		self:DrawObject( 0, 1 );
	end

	self.CurrOpenSound=self.Properties.fileOpenSound;
	self.OpenSound=Sound:Load3DSound(self.CurrOpenSound);
	self.CurrCloseSound=self.Properties.fileCloseSound;
	self.CloseSound=Sound:Load3DSound(self.CurrCloseSound);
	self.CurrUnlockSound=self.Properties.fileUnlockSound;
	self.UnlockSound=Sound:Load3DSound(self.CurrUnlockSound);

	self:SetBBox({x=-(self.Properties.BBOX_Size.X*0.5),y=-(self.Properties.BBOX_Size.Y*0.5),z=-(self.Properties.BBOX_Size.Z*0.5)},
	{x=(self.Properties.BBOX_Size.X*0.5),y=(self.Properties.BBOX_Size.Y*0.5),z=(self.Properties.BBOX_Size.Z*0.5)});
	self:RegisterState("Inactive");
	self:RegisterState("Opened");
	self:RegisterState("Closed");

	if (self.Properties.iNeededKey~=-1) then
	self.bLocked=1;
	else
	self.bLocked=0;
	end

	if(self.Properties.bEnabled==1) then
		self:GotoState( "Closed" );
	else
		self:GotoState( "Inactive" );
	end

	if(self.MovingSpeed==0)then
		self.MovingSpeed=0.01;
	end
	self.OpeningTime=self.Properties.MovingDistance/self.Properties.MovingSpeed;
	self.Timer=0;
	
	self:UpdatePortal();
end

function AutomaticDoor:OnSave(stm)
	stm:WriteInt(self.bLocked);
	if (self.originpos) then
		WriteToStream(stm,self.originpos);
	elseif (self.originang) then
		WriteToStream(stm,self.originang);
	end
end

function AutomaticDoor:OnLoad(stm)
	self.bLocked = stm:ReadInt();
	if (self.Properties.fileAnimatedModel == "doomlift") then
		self.originpos = ReadFromStream(stm);
	elseif (self.Properties.fileAnimatedModel == "swingdoor") then
		self.originang = ReadFromStream(stm);
	end
end

function AutomaticDoor:OnInet()
	if (self.Properties.fileAnimatedModel == "doomlift") then
		self.originpos = new(self:GetPos());
	elseif (self.Properties.fileAnimatedModel == "swingdoor") then
		self.originang = new(self:GetAngles());
	end
	self:NetPresent(nil);
	self:EnableUpdate(0);
	self:TrackColliders(1);
	if(self.bInitialized==nil) then
		self.bInitialized=1;
		self:OnReset();		
	end
end

function AutomaticDoor:Event_Open(sender)
	self:GotoState( "Opened" );
	BroadcastEvent(self, "Open");
	self:UpdatePortal();
	if (self.Properties.bUseAnimatedModel==1) then
	self:StartAnimation(0,self.Properties.Animation);
	end


	if (self.Properties.AISoundEvent.bEnabled == 1) then 
	if (sender.type == "Player") then
	Game:SetTimer(self,500,sender);
	elseif (sender.Who) then 
	Game:SetTimer(self,500,sender.Who);
	end
	end
end

function AutomaticDoor:Event_Activate(sender)
	self:GotoState( "Closed" );
	BroadcastEvent(self, "Activate");
end

function AutomaticDoor:Event_Deactivate(sender)
	self:GotoState( "Inactive" );
	BroadcastEvent(self, "Deactivate");
end

function AutomaticDoor:Event_Close(sender)
	self:GotoState( "Closed" );
	BroadcastEvent(self, "Close");
	if (self.Properties.bUseAnimatedModel==1) then
		self:StartAnimation(0,self.Properties.Animation,0,1.5,-1);
	end
end

function AutomaticDoor:Event_Opened(sender)
	BroadcastEvent(self, "Opened");
end
function AutomaticDoor:Event_Closed(sender)
	BroadcastEvent(self, "Closed");
	self:UpdatePortal();
end
function AutomaticDoor:Event_Unlocked(sender)
	self.bLocked=0;
	BroadcastEvent(self, "Unlocked");
	
	self:PlaySound(self.UnlockSound);
end
function AutomaticDoor:Event_ForceClose(sender)
	self.bLocked=1;
	self:GotoState( "Closed" );
	self:Event_Close(self);
end
function AutomaticDoor:IsCollisionFree()
	local colltable = self:CheckCollisions(ent_rigid+ent_sleeping_rigid+ent_living, geom_colltype0);
	if (colltable.contacts and getn(colltable.contacts)>0) then
		local contact = colltable.contacts[1];
		local collider = contact.collider; -- Collder entity.
		if (collider) then
			-- Add some impulse to object that was hit.
			contact.normal.x = -contact.normal.x;
			contact.normal.y = -contact.normal.y;
			contact.normal.z = -contact.normal.z;
			if (self.Properties.fileAnimatedModel ~= "doomlift") then
				collider:AddImpulse( -1,contact.center,contact.normal,self.Properties.fHitImpulse );
			end
		end
		return nil;
	end
  return 1;
end
function AutomaticDoor:OnOpen(self,other,usepressed)

	if ((not other.cnt)) then
		return 0
	end
	
	if (self.bLocked~=0) then

		if (other.keycards and (other.keycards[self.Properties.iNeededKey]==1)) then
			other.keycards[self.Properties.iNeededKey]=0;
			self:Event_Unlocked(self);				
			local slot=Server:GetServerSlotByEntityId(other.id);
			if (slot) then
				slot:SendCommand("GI K -"..self.Properties.iNeededKey);
			end
		else						
			if ((other==_localplayer) and (self.Properties.iNeededKey>=0) and (strlen(self.Properties.TextInstruction)>0)) then
				Hud.label = Localize(self.Properties.TextInstruction);
			end
			self:SetTimer(100);
			return 0
		end
	end
	if(self.Properties.bPlayerOnly==1 and (other.type~="Player"))then
		return
	end	
	if (self.AI_SIGNAL_GENERATED==nil) then 
		if (self.Properties.AISoundEvent.bEnabled == 1) then 
			AI:SoundEvent(self.id,self:GetPos(),self.Properties.AISoundEvent.fRadius, 0, 10, other.id);
			self.AI_SIGNAL_GENERATED=1;
		end
	end

	if ((self.Properties.bAutomatic==1) or ((self.Properties.bAutomatic==0) and (usepressed==1)) and (self.EndReached==nil)) then
		self:Event_Open(self);
		if (usepressed==1) and (Game:IsServer()) then
			local slot=Server:GetServerSlotByEntityId(other.id);
			if (slot) then
				slot:SendCommand('HUD W 8');
			end
		end
		return 1
	end

	return 0
end

function AutomaticDoor:OnUse2(player)
	if ( self.Properties.bAutomatic==0 and (self.Properties.bEnabled==1) and (self.bLocked==0)) then
		return (self:OnOpen(self,player,1));
	end
	return 0
end

function AutomaticDoor:UpdatePortal()
	if (self.Properties.bUsePortal==1) then
	local bOpen = self:GetState() == "Opened";	
	System:ActivatePortal(self:GetPos(),bOpen,self.id);
	end
end
-- CEPBEP
AutomaticDoor["Server"]={
	OnInit = AutomaticDoor.OnInet,
	Inactive = {
		OnBeginState = function(self)
			self:EnableUpdate(0);
			if (self.Properties.fileAnimatedModel == "doomlift") or (self.Properties.fileAnimatedModel == "swingdoor") then
				self:CreateStaticEntity(100,-1);
			end
		end,
	},
	Opened = {
		OnBeginState = function(self)
			if (self.Properties.bCloseTimer==1) then
				self:SetTimer(self.Properties.CloseDelay*1000);
			end
			if (self.Timer~=0) then
				Game:KillTimer(self.Timer);
			end
			self:EnableUpdate(1);
			if (self.Properties.fileAnimatedModel == "doomlift") or (self.Properties.fileAnimatedModel == "swingdoor") then
				self:CreateRigidBody(0, 0, -1);
			end
			self.Timer=Game:SetTimer(self,self.OpeningTime);
			self.EventSent = nil;
			self.movstart = nil;
			self.numupdates=0;
		end,
		OnEndState = function(self)
			Game:KillTimer(self.Timer);
			self.Timer=0;
		end,
		OnUpdate = function(self,dt)
			if (not self.movstart) or (self.cis_paused) then
				self.movstart = _time * 1;
				self.cis_paused = nil;
			end
			self.Distance = self.Distance + (_time-self.movstart)*0.03 * self.Properties.MovingSpeed;
			if ( self.Distance > self.Properties.MovingDistance ) then
				self.Distance = self.Properties.MovingDistance;
				self:EnableUpdate(0);
				if (self.Properties.fileAnimatedModel == "doomlift") or (self.Properties.fileAnimatedModel == "swingdoor") then
					self:CreateStaticEntity(100,-1);
				end
				if ( not self.EventSent ) then
					self.Event_Opened(self);
				end
				self.EventSent = 1;
			end
			if (self.Properties.bUseAnimatedModel==0) then
				self.temp_vec.x = self.Properties.Direction.X * self.Distance;
				self.temp_vec.y = self.Properties.Direction.Y * self.Distance;
				self.temp_vec.z = self.Properties.Direction.Z * self.Distance;
				self:SetObjectPos(0,self.temp_vec);
				self.temp_vec.x = -(self.Properties.Direction.X * self.Distance);
				self.temp_vec.y = -(self.Properties.Direction.Y * self.Distance);
				self.temp_vec.z = -(self.Properties.Direction.Z * self.Distance);
				if (self.originpos) then
					self:SetPos({x=self.originpos.x+self.temp_vec.x, y=self.originpos.y+self.temp_vec.y, z=self.originpos.z+self.temp_vec.z});
				elseif (self.originang) then
					self:SetAngles({x=self.originang.x+self.temp_vec.x, y=self.originang.y+self.temp_vec.y, z=self.originang.z+self.temp_vec.z});
				else
					self:SetObjectPos(1,self.temp_vec);
				end
			end
			if (Game:IsClient()) and ((self.numupdates==5) and (self.OpenSound) and (not Sound:IsPlaying(self.OpenSound))) then
				Sound:SetSoundPosition(self.OpenSound,self:GetPos());
				self:PlaySound(self.OpenSound);
				self.bInitialized=nil;
			end
			self.numupdates=self.numupdates+1;
		end,
		OnContact = function(self,other)
			if (self.Properties.bCloseTimer==1) then
				if (self.Properties.bPlayerOnly==1 and (other.type~="Player")) then
					return
				end
				if (self.Properties.fileAnimatedModel == "doomlift") then
					return
				end
				self:SetTimer(self.Properties.CloseDelay*1000);
			end
		end,
		OnTimer = function(self)
			self:GotoState("Closed");
			self:Event_Close(self);
		end,
		OnEvent = function(self,eid,param)
			if (type(param)=="table") then 
				if (self.AI_SIGNAL_GENERATED==nil) then 
					AI:SoundEvent(self.id,self:GetPos(),self.Properties.AISoundEvent.fRadius, 0, 1, param.id);
					self.AI_SIGNAL_GENERATED=1;
				end
			elseif ((eid==ScriptEvent_OnTimer) and (self.Properties.bUseAnimatedModel==0)) then
				self.temp_vec.x = self.Properties.Direction.X * self.Properties.MovingDistance;
				self.temp_vec.y = self.Properties.Direction.Y * self.Properties.MovingDistance;
				self.temp_vec.z = self.Properties.Direction.Z * self.Properties.MovingDistance;
				self:SetObjectPos(0,self.temp_vec);
				self.temp_vec.x =-(self.Properties.Direction.X * self.Properties.MovingDistance);
				self.temp_vec.y =-(self.Properties.Direction.Y * self.Properties.MovingDistance);
				self.temp_vec.z =-(self.Properties.Direction.Z * self.Properties.MovingDistance);
				if (self.originpos) then
					self:SetPos({x=self.originpos.x+self.temp_vec.x, y=self.originpos.y+self.temp_vec.y, z=self.originpos.z+self.temp_vec.z});
				elseif (self.originang) then
					self:SetAngles({x=self.originang.x+self.temp_vec.x, y=self.originang.y+self.temp_vec.y, z=self.originang.z+self.temp_vec.z});
				else
					self:SetObjectPos(1,self.temp_vec);
				end
			end
		end
	},
	Closed = {
		OnBeginState = function(self)
			if (self.Timer~=0) then
				Game:KillTimer(self.Timer);
			end
			self:EnableUpdate(1);
			if (self.Properties.fileAnimatedModel == "doomlift") or (self.Properties.fileAnimatedModel == "swingdoor") then
				self:CreateRigidBody(0, 0, -1);
			end
			self.Timer=Game:SetTimer(self,self.OpeningTime);
			self.EventSent = nil;
			self.EndReached = nil;
			self.movstart = nil;
		end,
		OnEndState = function(self)
			Game:KillTimer(self.Timer);
			self.Timer=0;
		end,
		OnUpdate = function(self,dt)
			local prevDist = self.Distance;
			if (not self.movstart) or (self.cis_paused) then
				self.movstart = _time * 1;
				self.cis_paused = nil;
			end
			self.Distance = self.Distance - (_time-self.movstart)*0.03 * self.Properties.MovingSpeed;
			if (self.Distance < 0 ) then
				self.Distance = 0;
				self:EnableUpdate(0);
				if (self.Properties.fileAnimatedModel == "doomlift") or (self.Properties.fileAnimatedModel == "swingdoor") then
					self:CreateStaticEntity(100,-1);
				end
				if ( not self.EventSent ) then
					self.Event_Closed(self);
				end
				self.EventSent = 1;
			end
			if (self.Properties.bAllowRigidBodiesToOpenDoor==1) and (self.Distance > 0) then
				if (not self:IsCollisionFree()) and (Game:IsServer()) then
					if (self.collision_updates) then
						self.collision_updates = self.collision_updates + 1;
					else
						self.collision_updates = 1;
					end
					if (self.collision_updates > 3) then
						self:Event_Open(self);
					end
					self.Distance = prevDist;
					return;
				end
			end
			if (self.Properties.bUseAnimatedModel==0) then
				local CurrPos = {};
				self.temp_vec.x = self.Properties.Direction.X * self.Distance;
				self.temp_vec.y = self.Properties.Direction.Y * self.Distance;
				self.temp_vec.z = self.Properties.Direction.Z * self.Distance;
				self:SetObjectPos(0,self.temp_vec);
				self.temp_vec.x = -(self.Properties.Direction.X * self.Distance);
				self.temp_vec.y = -(self.Properties.Direction.Y * self.Distance);
				self.temp_vec.z = -(self.Properties.Direction.Z * self.Distance);
				if (self.originpos) then
					self:SetPos({x=self.originpos.x+self.temp_vec.x, y=self.originpos.y+self.temp_vec.y, z=self.originpos.z+self.temp_vec.z});
				elseif (self.originang) then
					self:SetAngles({x=self.originang.x+self.temp_vec.x, y=self.originang.y+self.temp_vec.y, z=self.originang.z+self.temp_vec.z});
				else
					self:SetObjectPos(1,self.temp_vec);
				end
			end

			if (not self.bInitialized) then 				
				if (Game:IsClient()) and ((self.Distance>0) and (self.CloseSound) and (not Sound:IsPlaying(self.CloseSound))) then
					Sound:SetSoundPosition(self.CloseSound,self:GetPos());
					self:PlaySound(self.CloseSound);
				end
			else
				self.bInitialized=nil;
			end
		end,
		OnContact = function(self, other)
			if ((not other.cnt) or (not other.cnt.health) or (other.cnt.health<=0)) then
				do return end
			end
			if ( ((self.bLocked==0) and self.Properties.bAutomatic==0) and (not other.POTSHOTS)) then
				if (other.cnt) and (other.cnt.use_pressed) then
					 self:OnUse2(other);
				end
				do return end
			end
			self:OnOpen(self,other,0);
		end,
		OnTimer = function( self )
		end,
		OnEvent = function(self,eid)
			if ((eid==ScriptEvent_OnTimer) and (self.Properties.bUseAnimatedModel==0))
			then
				self:SetObjectPos(0, g_Vectors.v000);
				if (self.originpos) then
					self:SetPos({x=self.originpos.x, y=self.originpos.y, z=self.originpos.z});
				elseif (self.originang) then
					self:SetAngles({x=self.originang.x+self.temp_vec.x, y=self.originang.y+self.temp_vec.y, z=self.originang.z+self.temp_vec.z});
				else
					self:SetObjectPos(1, g_Vectors.v000);
				end
			end
		end
	}
}
-- CLIENT
AutomaticDoor["Client"]={
	OnInit = AutomaticDoor.OnInet,
	Inactive = {
		OnBeginState = function(self)
			self:EnableUpdate(0);
			if (self.Properties.fileAnimatedModel == "doomlift") or (self.Properties.fileAnimatedModel == "swingdoor") then
				self:CreateStaticEntity(100,-1);
			end
		end,
	},
	Opened = {
		OnBeginState = function(self)
			self:StartAnimation(0,"default");
			self.movstart = nil;
			self:EnableUpdate(1);
			if (self.Properties.fileAnimatedModel == "doomlift") or (self.Properties.fileAnimatedModel == "swingdoor") then
				self:CreateRigidBody(0, 0, -1);
			end
			self.numupdates=0;
			self:UpdatePortal();			
		end,
		OnEndState = function(self)
		end,
		OnUpdate = AutomaticDoor["Server"].Opened.OnUpdate,
	},
	Closed = {
		OnBeginState = function(self)
			self:StartAnimation(0,"close");
			self.movstart = nil;
			self:EnableUpdate(1);
			if (self.Properties.fileAnimatedModel == "doomlift") or (self.Properties.fileAnimatedModel == "swingdoor") then
				self:CreateRigidBody(0, 0, -1);
			end
			self.collision_updates=0;
		end,
		OnEndState = function(self)
		end,
		OnContact = function(self, other)
			if (_localplayer) and (other==_localplayer) and (self.bLocked==0) and (self.Properties.bAutomatic==0) and (Hud) then
				Hud.label = "use_hint";
			end
		end,
		OnUpdate = AutomaticDoor["Server"].Closed.OnUpdate,
	},
}