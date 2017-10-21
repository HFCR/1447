-- Mounted weapons Base. Modified by Mixer v2.0 to support standalone objects as rotating cover for turret
MountedWeapon=
{
	weaponid=0,
	fireOn = 0,
	Properties = {
		angHLimit = 0,
		angVLimitMin = -20,	-- up direction default  -50
		angVLimitMax = 10,	-- down direction default 20
		
		mountHeight = 1.1,
		mountRadius = 0.8,
		mountHandle = 0.6,
		CAP_EntityName = "",
		bUserPhys = 0,
		bHidden = 0,
	},
	
	theUser = nil,
	direction = {x=0,y=0,z=0},
	clientPhysics = 0,

	-- if the weapon supports zooming then add this...
	ZoomActive = 0,												-- initially always 0
	MaxZoomSteps = 4,
	ZoomSteps = { 2, 3, 4, 8, },
	
	---------------------------------------------------
	timeout =2,
	lastusetime=0,
}

-----------
function MountedWeapon:OnPropertyChange()
	self:UpdateMyCap();
	if (self.Properties.bHidden ~= 0) then
		self:GotoState("Hidden");
	else
		self:GotoState("Idle");
	end
end

-- Mixer: update func for cap maintenance.
function MountedWeapon:UpdateMyCap()
if (not self.cap_ent) and (self.Properties.CAP_EntityName) and (self.Properties.CAP_EntityName~="") then
	self.cap_ent = System:GetEntityByName(self.Properties.CAP_EntityName);
end
if (self.cap_ent) then
	if (not self.cap_ent.SetAngles) then
		-- it's a wrong entity info, let's recreate...
		self.cap_ent = nil;
		return;
	end
	local myang = new(self:GetAngles());
	self.cap_ent:SetAngles({x=0,y=0,z=myang.z});
end
end

--------
function MountedWeapon:OnReset()

	self:AbortUse();
	self:UpdateMyCap();
	if (self.Properties.bHidden ~= 0) then
		self:GotoState("Hidden");
	else
		self:GotoState("Idle");
	end

	AI:RegisterWithAI(self.id, AIOBJECT_MOUNTEDWEAPON);
end

-------------------------------------------------------------------------------------
function MountedWeapon:OnShutDown()

	if( self.isBound ) then
		self.isBound:ReleaseMountedWeapon( 1 );
	end
	self:AbortUse();

end


-------------------------------------------------------------------------------------
function MountedWeapon:Physicalize()
	if(not self.IsPhisicalized) then
		self:LoadCharacter(self.fileGunModel, 0);
		self:ResetAnimation( 0 );
		self.IsPhisicalized = 1;
		self:EnablePhysics(0);
		
		if (self.Properties.bHidden ~= 0) then
			self:DrawCharacter(0,0); -- Hide Character.
		else
			self:DrawCharacter(0,1); -- Show Character.
		end
	end
end
-------------------------------------------------------------------------------------
function MountedWeapon:RegisterStates()
	self:RegisterState( "Idle" );
	self:RegisterState( "Used" );
	self:RegisterState( "Hidden" );
	
	self.fireOn = 0;
end
-------------------------------------------------------------------------------------
function MountedWeapon:Client_OnInit()

	self:NetPresent(0);
	Game:AddWeapon(self.weapon);

	self.initialAngle = new(self:GetAngles(1));
	
	self:RegisterStates();
	self:Physicalize();
	self:DrawObject( 0, 1 );
	self:RenderShadow( 1 );
	self:SetTimer(500);
end
-------------------------------------------------------------------------------------
function MountedWeapon:Server_OnInit()

	self:NetPresent(0);
	if(self.Properties.gunCGF)then
		self.Properties.fileGunCGF=self.Properties.gunCGF;
		self.Properties.gunCGF=nil;
	end

	self.initialAngle = new(self:GetAngles(1));

	self:OnReset();


	for i,val in WeaponClassesEx do
		if(i == self.weapon)then
			self.weaponid=val.id;
			break
		end
	end
	self:RegisterStates();
	self:Physicalize();
	
	if (self.Properties.bHidden ~= 0) then
		self:GotoState("Hidden");
	else
		self:GotoState("Idle");
	end
end
-------------------------------------------------------------------------------------
function MountedWeapon:Client_Idle_OnContact(collider)

	if(self.isBound ~= nil) then return end		-- it's mounted on vehicle - gunner added by vehicle
	if(self.user) then return end
	if( collider == _localplayer ) then
		
		-- see if close to handle
		if(self:IsClose(collider:GetPos())==0) then return end
		Hud.label = self.message;--"Press USE KEY to use this weapon...";
	end	
end
-----------
function MountedWeapon:OnBind(player, par)
  
  self.lastselected = player.cnt:GetCurrWeaponId();
  
  	player.current_mounted_weapon = self;
	player.cnt.lock_weapon=1;

	player.cnt:MakeWeaponAvailable(self.weaponid,1);
	player.cnt:SetCurrWeapon(self.weaponid, self.id );

	self.user=player;
	player.cnt:SetAngleLimitBase( self.initialAngle ); 
	if(self.Properties.angHLimit > 0) then
		player.cnt:SetMinAngleLimitH( -self.Properties.angHLimit );
		player.cnt:SetMaxAngleLimitH( self.Properties.angHLimit );
		player.cnt:EnableAngleLimitH( 1 );
	else
		player.cnt:EnableAngleLimitH( 0 );
	end
	player.cnt:SetMinAngleLimitV( self.Properties.angVLimitMin );
	player.cnt:SetMaxAngleLimitV( self.Properties.angVLimitMax );

  player.cnt:RedirectInputTo(self.id);
	
	if(self.isBound == nil) then 
		player:StartAnimation(0,"sidle");
	end	
	player.cnt.AnimationSystemEnabled = 0;
	----------------------	
	if (player.Properties.CAP_EntityName) and (player.Properties.CAP_EntityName~="") then
		self.Properties.CAP_EntityName = player.Properties.CAP_EntityName;
	end

	
	
	if( self.Properties.bUserPhys == 0 ) then
		player:ActivatePhysics(0);
	end	
	self.user=player;
	
--	self:ActivatePhysics(0);	-- not to hit it with bullets
	self:EnablePhysics(0);
	self:NetPresent(1);
	self:GotoState( "Used" );	
	self:UpdateUser(0);
	
	if(player == _localplayer) then
		self:Event_PlayerIn();
	end	
	
end
	
-------------------------------------------------------------------------------------
function MountedWeapon:ReleaseUser( )
--  System:Log("MountedWeapon:StopUsing");

	-- fixme - 
	-- not good, should never happen
	if (not self.user ) then return end
	if (self.user) and (self.user.GetPos == nil) then
		return
	end
	
	self.user.cnt:EnableAngleLimitH( nil );
	self.user.cnt:SetMinAngleLimitV( self.user.normMinAngle );
	self.user.cnt:SetMaxAngleLimitV( self.user.normMaxAngle );
	
	self.user.cnt:RedirectInputTo( 0 );
	--------------

	-- stop fireing animation
	self.fireOn = 0;
	self:ResetAnimation( 0 );
	
	self.user.cnt.lock_weapon=nil;
	self.user.current_mounted_weapon = nil;
	
	self.user:ActivatePhysics(1);
	self.user.cnt.AnimationSystemEnabled = 1;
	self.user:SetAngles( self:GetAngles(1));

	self.user.cnt:ResetRotateHead();
--	user:SetAngles( {x=0,y=0,z=100});
	
	-- make sure that the player is still alive
	if (self.user.cnt.health > 0) then
		if(self.lastselected)then
			self.user.cnt:SetCurrWeapon(self.lastselected);	-- select prev weapon
			self.user.lastselected=nil;
		else
			self.user.cnt:SetCurrWeapon();	-- just deselect mounted weapon
		end
		self.user.cnt:MakeWeaponAvailable(self.weaponid,0);
	end

	
	if(self.user == _localplayer) then
		self:Event_PlayerOut();	
	end	
	
	--set last safe angles
	local ang=self:GetAngles(1);
	ang.z = self.user.cnt.SafeMntAngZ;
	self:SetAngles( ang );
	
	self.timeout = 2;
	self.user=nil;
	
end

-------------------------------------------------------------------------------------
function MountedWeapon:Server_Idle_OnContact(collider)

--System:Log(" MountedWeapon:Server_Idle_OnContact ");

	if (self.isBound ~= nil) then return end		-- it's mounted on vehicle - gunner added by vehicle

	if (self.user) then return end

	if (collider.type ~= "Player") then return end

	
	------ bot_thing_to_grab
	
	
	if (collider.cnt.health>0) and (collider.cnt.use_pressed or (collider.bot_thing_to_grab and collider.bot_thing_to_grab == self.id)) then
		-- here we check if the positin at mounted weapon is available - 
		-- player is not colliding with something when use it
		local dir=self:GetDirectionVector();
		dir.z=0;
		NormalizeVector(dir);
		local userPos = self:GetPos();
		userPos.x = userPos.x - dir.x*self.Properties.mountRadius;
		userPos.y = userPos.y - dir.y*self.Properties.mountRadius;
		userPos.z = userPos.z-self.Properties.mountHeight;
		-- if cant stand there - can't use it
		local distAround = .2;
		if( not collider.cnt:CanStand( userPos )) then 
			userPos.x = userPos.x + distAround;
			if( not collider.cnt:CanStand( userPos )) then 
				userPos.x = userPos.x - distAround*2;
				if( not collider.cnt:CanStand( userPos )) then 
					userPos.x = userPos.x + distAround;
					userPos.y = userPos.y + distAround;
					if( not collider.cnt:CanStand( userPos )) then 
						userPos.y = userPos.y - distAround*2;
						if( not collider.cnt:CanStand( userPos )) then return end
					end
				end
			end
		end			
--		if( not collider.cnt:CanStand( userPos )) then return end		

		-- see if close to handle
		if( self:IsClose(collider:GetPos())==0 ) then return end
		collider.bot_thing_to_grab = nil;
		collider.cnt.use_pressed = nil;
		self:SetGunner( collider );
	end
end
-------------------------------------------------------------------------------------
function MountedWeapon:SetGunner(player)
--System:Log("MountedWeapon:SetGunner()")

	-- deactivate binoculars
	if(player == _localplayer and ClientStuff.vlayers:IsActive("Binoculars"))then
		ClientStuff.vlayers:DeactivateLayer("Binoculars");				
	end

	self:OnBind(player);
end


-------------------------------------------------------------------------------------
function MountedWeapon:AbortUse( )
	if( not self.user ) then return end

	self:ReleaseUser( );--------------
	self:DrawObject( 0, 1 );
	self:DrawCharacter(0,1);
	self:GotoState( "Idle" );
	self:NetPresent(0);
end

---------
function MountedWeapon:UpdateUser(dt)
  if (self.user) and (self.user.cnt) then
    local dir=self:GetDirectionVector();
	local handlerPos = self:GetBonePos("hands");
	if (handlerPos) then	-- use halper if available
		self.user:SetHandsIKTarget( handlerPos );
	else	
		handlerPos = self:GetPos(); 
		handlerPos.x = handlerPos.x - dir.x*self.Properties.mountHandle;
		handlerPos.y = handlerPos.y - dir.y*self.Properties.mountHandle;
		handlerPos.z = handlerPos.z - dir.z*self.Properties.mountHandle;
	end
	
	if( self.isBound == nil ) then
		dir.z=0;
		NormalizeVector(dir);
		local userPos = self:GetPos();
		userPos.x = userPos.x - dir.x*self.Properties.mountRadius;
		userPos.y = userPos.y - dir.y*self.Properties.mountRadius;
		
		userPos.z = userPos.z-self.Properties.mountHeight;
		self.user:SetPos( userPos );
	end	
	-- we don't want to notify physics - not to tilt the cilinder
	self.user:SetAngles( self:GetAngles(1), 1 );
  end
end
-------------------------------------------------------------------------------------
function MountedWeapon:Client_Used_OnUpdate(dt)
	self:UpdateUser(dt);
end
-------------------------------------------------------------------------------------
function MountedWeapon:Server_Used_OnUpdate(dt)

	if (self.user) and (self.user.cnt) then
		if (self.user.cnt.health<=0) or (self.user.cnt.use_pressed and self.isBound==nil) then
			
			if (_time-self.lastusetime<1) then
				do return end
			end
			self.lastusetime=_time;
			self.user.cnt.use_pressed = nil;
			self:AbortUse( );
		else
		  self:UpdateUser(dt);
		  self:UpdateMyCap();
		end
	end
end

-------------------------------------------------------------------------------------
function MountedWeapon:Client_Used_OnEvent( event, par )

	if(event == ScriptEvent_Fire) then
		if( par == 0 ) then
			self.fireOn = 0;
			self:ResetAnimation( 0 );
		else
			if(self.fireOn == 0) then
				self:StartAnimation(0,"default");
				self.fireOn = 1;
			end	
		end	
	end	
end	

-------------------------------------------------------------------------------------
function MountedWeapon:IsClose( pos )

local handlerPos = self:GetBonePos("hands");
	
	if(handlerPos)then
		FastDifferenceVectors( handlerPos, handlerPos, pos );
		handlerPos.z = 0;
		local dist = LengthSqVector( handlerPos );
		if( dist<.8 ) then return 1 end
		return 0
	else
		return 1
	end	
end

-------------------------------------------------------------------------------------
-- Events.
-------------------------------------------------------------------------------------
function MountedWeapon:Event_Activate( sender )
	self:EnableUpdate(1);
	self:GotoState( "Idle" );
end

function MountedWeapon:Event_Hide( sender )
	self:GotoState( "Hidden" );
end

function MountedWeapon:Event_Unhide( sender )
	if (self:GetState() == "Hidden") then
		self:GotoState( "Idle" );
	end
end

----------------------------------------------------------------------------------------------------------------------------
--
function MountedWeapon:Event_PlayerIn( params )

	BroadcastEvent( self,"PlayerIn" );
	
end	

----------------------------------------------------------------------------------------------------------------------------
--
function MountedWeapon:Event_PlayerOut( params )

	BroadcastEvent( self,"PlayerOut" );
	
end	

-------------------------------------------------------------------------------------
MountedWeapon.Client={
	OnInit=MountedWeapon.Client_OnInit,
	Idle={
		OnBeginState = function (self)
			self:DrawCharacter(0,1); -- Show it 
			self.user = nil;
			self:ResetAnimation( 0 );
		end,
		OnContact=MountedWeapon.Client_Idle_OnContact,
		OnBind=MountedWeapon.OnBind,
	},
	Used={
		OnBeginState = function (self)
			self:DrawCharacter(0,1); -- Show it 
		end,
		OnUpdate=MountedWeapon.Client_Used_OnUpdate,
		OnBind=MountedWeapon.OnBind,
		OnEvent=MountedWeapon.Client_Used_OnEvent,
		OnEndState = function (self)
			self:ReleaseUser();
		end,		
	},
	Hidden = {
		OnBeginState = function (self)
			self:ReleaseUser( );			
			--self:DrawObject( 0,0 ); -- Hide object.
			self:DrawCharacter(0,0); -- Hide Character.
		end,
		OnEndState = function (self)
			self:DrawCharacter(0,1); -- Draw Character.
		end,
	},
}
-------------------------------------------------------------------------------------
MountedWeapon.Server={
	OnInit=MountedWeapon.Server_OnInit,
	OnShutDown=MountedWeapon.OnShutDown,
	Idle={
		OnBeginState = function (self)
		if (self.cap_ent) then
			local my_pos = self:GetPos();
			self.cap_ent:SetPos(my_pos);
		end
		end,
		OnContact=MountedWeapon.Server_Idle_OnContact,
	},
	Used={
		OnBeginState = function (self)
		end,
		OnUpdate=MountedWeapon.Server_Used_OnUpdate,
	},
	Hidden = {
		OnBeginState = function (self)
			self:ReleaseUser( );
			if (self.cap_ent) then
				self.cap_ent:SetPos({x=0.01,y=0.01,z=0.01});
			end
		end,
	},
}


----------------------------------------------------------------------------------------------------------------------------
--
--
function MountedWeapon:OnSave(stm)

	stm:WriteFloat( self.initialAngle.x );
	stm:WriteFloat( self.initialAngle.y );	
	stm:WriteFloat( self.initialAngle.z );	
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function MountedWeapon:OnLoad(stm)
	self.initialAngle.x = stm:ReadFloat();
	self.initialAngle.y = stm:ReadFloat();	
	self.initialAngle.z = stm:ReadFloat();	
end




----------------------------------------------------------------------------------
function CreateMountedWeapon(child)

	--System:Log( "\001 CreateMountedWeapon --------------------------------------------------");

	local newt={}
	mergef(newt,MountedWeapon,1);
	mergef(newt,child,1);
	return newt;
end


