--Rotator Entity (former PickMeUp) 
--by aarbro [aarbro@hotmail.com]
--modified by Mixer [verysoft@yandex.ru] v1.1 (saveable damage parameter)

Rotator = {

Properties = {
fForceDampenScale = 0.6,
fForceHoldScale = 0.5,
fHoldHeight = 0.3, --from model head
ThrowPower = 850, --max impulse
fMaxObjMass = 90, --heaviest object allowed
fMaxObjLength = 2, --longest dimension of an object, in m
fMaxPickupDist = 1.5,
bGravityTest = 0,--experimental
bOnlyFor_give_me = 0,
fGravityForceScale = 10,
bEnabled = 1,
},

Editor={
Model="objects/multiplayer/boxes/grey.cgf",
},

}

---
function Rotator:OnPropertyChange()
self:OnReset();
end
---

function Rotator:OnInit()
self:RegisterState("Idle");
self:RegisterState("Carry");
self:OnReset();
end

---
function Rotator:OnShutDown()
end

---
function Rotator:OnSave(stm)
	stm:WriteBool(self.Properties.bEnabled);
	if (self.entity) then
		stm:WriteBool(1);
		stm:WriteInt(self.entity.id);
		stm:WriteInt(self.grabbedmass);
		if (self.lastselected) then
			stm:WriteBool(1);
			stm:WriteInt(self.lastselected);
		else
			stm:WriteBool(0);
		end
		if (self.grabbeddmgs) then
			stm:WriteBool(1);
			stm:WriteInt(self.grabbeddmgs);
		else
			stm:WriteBool(0);
		end
	else
		stm:WriteBool(0);
	end
end

---
function Rotator:OnLoad(stm)
self.Properties.bEnabled=stm:ReadBool();
if (not self.Properties.bEnabled) then
self.Properties.bEnabled = 0; end
if (stm:ReadBool()==1) then
self.entity_id=stm:ReadInt();
self.grabbedmass=stm:ReadInt();
if (stm:ReadBool()==1) then
self.lastselected=stm:ReadInt();
end
if (stm:ReadBool()==1) then
self.grabbeddmgs=stm:ReadInt();
end end
self:EnableUpdate(self.Properties.bEnabled);
end
---
function Rotator:OnReset()
self:EnableUpdate(self.Properties.bEnabled);
self:SetUpdateType( eUT_Always );
self.kpress_use = nil;
if (not self.entity_id) then
self:GotoState( "Idle" ); end
end

---
function Rotator:OnUpdate()
end

---
function Rotator:Event_Enable()
self:EnableUpdate(1);
self.Properties.bEnabled = 1;
BroadcastEvent(self,"Enable");
end
---
function Rotator:Event_Disable()
self:EnableUpdate(0);
self:GotoState("Idle");
self.Properties.bEnabled = 0;
BroadcastEvent(self,"Disable");
end

--State machine begin

Rotator.Idle =
{
---
OnBeginState = function( self )
self.lastselected = nil;
self.grabbeddmgs = nil;
self.grabbedmass = nil;
self.entity = nil;
end,
---
OnEndState = function( self )
end,
---
OnUpdate = function(self)
	if (_localplayer) and (not _localplayer.theVehicle) then
		if (_localplayer.ladder) then return end
		if (_localplayer.cnt.lock_weapon) then return end
		local int_pt = _localplayer.cnt:GetViewIntersection(); --get object the crosshair is aiming at
		if (int_pt) and (int_pt.id) then --it's an entity
			int_pt = System:GetEntity( int_pt.id );
			if (int_pt) and (int_pt.Properties) then
				if (self.Properties.bOnlyFor_give_me) and (self.Properties.bOnlyFor_give_me ~= 0) then
					if (not int_pt.cis_pickable_prop) then
						return;
					end
				end
				local mass_center = int_pt:GetCenterOfMassPos();
				local dist = _localplayer:GetDistanceFromPoint(mass_center);
				if (dist < self.Properties.fMaxPickupDist) then
					local mass = 100;
					if ( int_pt.Properties.Physics ) then
						mass = int_pt.Properties.Physics.Mass *1;
					end
					if (mass < self.Properties.fMaxObjMass) and (self:MaxDimension(int_pt) < self.Properties.fMaxObjLength) then
						Hud.label = "@press_and_pickup";
						if (_localplayer.cnt.use_pressed) then
							if (self.kpress_use) then
								return
							else
								self.kpress_use = 1;
								self.entity = int_pt;
								self.grabbedmass = mass *1;
								if (self.entity.Properties) and (self.entity.Properties.damage_players) then
									self.grabbeddmgs = self.entity.Properties.damage_players * 1;
									self.entity.Properties.damage_players = 0;
								end
								self:GotoState("Carry");
								if (self.entity.Event_OnDamage) then
									BroadcastEvent( self.entity,"OnDamage" );
								end
								return
							end
						else
							self.kpress_use = nil;
						end
					end
				end
			end
		end
	end
end,
}

Rotator.Carry =
{
---
OnBeginState = function(self)
if (_localplayer) then
	self.lastselected = _localplayer.cnt:GetCurrWeaponId();
	_localplayer.cnt:SetCurrWeapon();
	_localplayer.cnt.lock_weapon=1;
	_localplayer.cnt.speedscale=1-self.grabbedmass/self.Properties.fMaxObjMass;
end
if (not self.entity_id) then
	self.oldPos = new(self.entity:GetPos());
end
end,
---
OnEndState = function( self )
if (not _localplayer.current_mounted_weapon) then
_localplayer.cnt.lock_weapon=nil; end
if (self.lastselected) then
if (_localplayer.ladder) then
	_localplayer.cnt:UseLadder(0);
	_localplayer.cnt:SetCurrWeapon(self.lastselected);
	_localplayer.cnt:UseLadder(1,_localplayer.ladder.climbspeed,_localplayer.ladder:GetPos());
else
	_localplayer.cis_svgload = 1; -- prevents weapon activation sound playing
	_localplayer.cnt:SetCurrWeapon(self.lastselected);
	if (_localplayer.cnt.weapon) then
		_localplayer.cnt.weapon:StartAnimation(0,"Grenade11",0,0);
	end
end
else
	_localplayer.cnt.speedscale=1;
end
if (self.entity) and (self.grabbeddmgs) then
	self.entity.Properties.damage_players = self.grabbeddmgs * 1; end
end,
---
OnUpdate = function( self, dt )
if (self.entity) then
--- DROP IF PLAYER PRESSED USE
if (_localplayer.cnt.use_pressed) then
if (self.kpress_use) then return else
self.kpress_use = 1;
self:GotoState("Idle");
return end
else self.kpress_use = nil; end
--- DROP IF PLAYER ENTERS VEHICLE / USES MOUNTED GUN
if (_localplayer.cnt.weapon) or (_localplayer.theVehicle) or (_localplayer.current_mounted_weapon) or (_localplayer.cnt.flying and _localplayer.cnt:IsSwimming()==nil) then
	self:GotoState("Idle");
	return
end
local throw_center=self.entity:GetCenterOfMassPos();
if (_localplayer:GetPos().z > throw_center.z) then
	self:GotoState("Idle");
	return
end
--- THROW IF PLAYER PRESSED FIRE
if (_localplayer.cnt.firing) then
	throw_center.z = throw_center.z+0.01;
	self.entity:EnablePhysics(0);
	self.entity:EnablePhysics(1);
	self.entity:AddImpulse(-1,throw_center,_localplayer:GetDirectionVector(),self.Properties.ThrowPower*0.3);
	self:GotoState("Idle");
	return
end
--- CARRY HANDLING
local aimPos = new(_localplayer:GetBonePos("Bip01"));
local dir = new(_localplayer:GetDirectionVector());
local armlength = self:MaxDimension(self.entity);
armlength = 1.15;
--Hud:AddMessage(armlength);
ScaleVectorInPlace(dir,armlength);
FastSumVectors(aimPos,aimPos,dir); --by adding the pos to the direction vector the object is always in front of the camera
aimPos.z = aimPos.z + self.Properties.fHoldHeight; --set arm distance from eyes;

local objPos = new(self.entity:GetPos());
local aimVec = new(DifferenceVectors(aimPos,objPos));
NormalizeVector( aimVec ); --this is the direction vector from the object to the aimpoint
local dist = self.entity:GetDistanceFromPoint(aimPos);
local currentDiff = new(DifferenceVectors(objPos,self.oldPos));
local currentDist = sqrt(LengthSqVector(currentDiff)); --distance moved since last update
local currentSpeed = currentDist / dt;--average speed since last update
self.oldPos = objPos;

dt = 0.02; --override dt in force calcs in this test version...

if ( self.Properties.bGravityTest == 1 ) then
	local gravDir = {};
	gravDir.x = 0;
	gravDir.y = 0;
	gravDir.z = -1;
	self.entity:AddImpulseObj(gravDir,self.grabbedmass*dt*self.Properties.fGravityForceScale);
end

--set max speed of an object toward the player
if dist > self.Properties.fMaxPickupDist * 1.7 then
	self:GotoState("Idle");
	return
end

local forceF = _localplayer:GetAngles();
self.entity:SetAngles({x=0,y=0,z=forceF.z});

forceF = dist*dt*self.grabbedmass*200*self.Properties.fForceHoldScale;
self.entity:AddImpulse( -1,self.entity:GetCenterOfMassPos(),aimVec,forceF); --forward

ScaleVectorInPlace(currentDiff,-1); --create brake direction away from current path
local forceB = currentSpeed*dt*self.grabbedmass*20*self.Properties.fForceDampenScale;
self.entity:AddImpulse( -1,self.entity:GetCenterOfMassPos(),currentDiff,forceB); --brake
--_localplayer:AddImpulse( -1,aimPos,diff,dist*dt*1000); --player momentum effect test

else

if (self.entity_id) then
self.entity=System:GetEntity(self.entity_id);
if (self.entity) then self.entity_id = nil;
self.oldPos = new(self.entity:GetPos()); end
else self:GotoState("Idle"); end

end
end,
}
-------------------------------------------------------------------------------
--State machine end
-------------------------------------------------------------------------------

function Rotator:MaxDimension( entity )
local bbox = entity:GetBBox(0);
local bbmax = bbox.max;
local bbmin = bbox.min;

local maxx = abs(bbmax.x)-abs(bbmin.x);
local maxy = abs(bbmax.y)-abs(bbmin.y);
local maxz = abs(bbmax.z)-abs(bbmin.z);

if ( maxx > maxy and maxx > maxz ) then return maxx; end
if ( maxy > maxx and maxy > maxz ) then return maxy; end
return maxz;
end

---

--TO DO
--
--Slow player down depending on mass of the object. [Mixer] - DONE
--Remove weapon //partly done, need to remove actual firing too, see binocular mode... [Mixer] - DONE
--Momentum //finished, need tweaking.
--Speed optimization:
--*Sum all impulse vectors and apply just one AddImpulse.
--*Create constant object props (mass, center, ..) in variables at pickup time. [Mixer] - DONE
--*Avoid vectors as params, use fast functions...
--...
--Rotation of object held. [Mixer] - DONE
--Reach out arms, affect throw length, endurance? ...

--hit subtables:
---------------
--vPos      
--impactVert
--fSpeed    
--vVel      
--matId     


