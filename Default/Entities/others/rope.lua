Rope = {
	name = "Rope",
	Properties = {
	dropeName = "Trooper1",
	bRetrieveRope = 1,
	},
	state=0,	-- 0-is up, 1-is down, 2-is going down, 3-is going up, 4-descending, 5-just done descending
	delay = -1,
	dropEntity1 = nil,
	dropEntity2 = nil,	
	dropE1Angle = 0,	
	dropE1DeltaAngle = 0,		
	dropEntity1Delay = 0,
	dropE2Angle = 0,	
	dropE2DeltaAngle = 0,
	dropEntity2Delay = 0,
	AniTable = {
		Down 		= 	"throw",
		Up 			= 	"retrieve",
		Descend	=		"descend",
	},
	
}

function Rope:OnInit()
	self:LoadCharacter("Objects/Vehicles/V-22/Rope/rope.cgf", 0 );	
	self:DrawObject(0,1);
	self:RenderShadow( 0 );
	self:EnableUpdate( 0 );
	self:EnableProp( ENTITYPROP_CASTSHADOWS, 0 );
	self:EnableProp( ENTITYPROP_DONOTCHECKVIS, 1 );
	self:OnReset();
end

function Rope:OnUpdate( dt )
	if( self.delay >= 0 ) then
		self.delay = self.delay - dt;
		if( self.delay < 0 ) then
			self:GoDown();
		end	
		do return end
	end
	if( self.dropEntity1 ) then
		if (self.dropEntity1Delay > 0 ) then
			self.dropEntity1Delay = self.dropEntity1Delay - dt;
			do return end
		end
		if( self.state == 5 or self.dropEntity1.cnt.health <= 0 ) then
			if (self.dropEntity1.cnt.health > 0) then
				self.dropEntity1:StartAnimation(0, "sidle");
				self.dropEntity1:StartAnimation(0, "rope_land");
			end
			AI:Signal(SIGNALFILTER_SUPERGROUP, 10, "ON_GROUND",self.dropEntity1.id);
			self.dropEntity1.cnt.AnimationSystemEnabled = 1;
			self.dropEntity1.theRope = nil;
			self.dropEntity1:ActivatePhysics(1);
			self.dropEntity1:TriggerEvent(AIEVENT_ENABLE);
			AI:Signal(0, 1, "exited_vehicle", self.dropEntity1.id);
			self.dropEntity1 = nil;
			if( self.dropEntity2 ) then
				AI:Signal(SIGNALID_READIBILITY,2,"AI_AGGRESSIVE",self.dropEntity2.id);
				self:Descend();
			else	
				self:Retrieve();
			end
		elseif( self.state == 1 ) then	
			AI:Signal(SIGNALID_READIBILITY,2,"AI_AGGRESSIVE",self.dropEntity1.id);																		-- start bone descend animation
			self:Descend();			
		elseif( self.state == 4 ) then																-- position on bone
			self.dropEntity1:DrawCharacter(0,1);		
			self.dropEntity1:SetPos( self:GetBonePos("player") );
			self.dropE1Angle = self.dropE1Angle + self.dropE1DeltaAngle*dt;
			self.dropEntity1:SetAngles({x=0,y=0,z=self.dropE1Angle});	
		end	
	elseif (self.dropEntity2) then
		if (self.dropEntity2Delay > 0) then
			self.dropEntity2Delay = self.dropEntity2Delay - dt;
			do return end
		end
		if( self.state == 5 or self.dropEntity2.cnt.health == 0 ) then	-- already down or dead
			if(self.dropEntity2.cnt.health > 0) then
				self.dropEntity2:StartAnimation(0, "sidle");				
				self.dropEntity2:StartAnimation(0, "rope_land");
			end	
			AI:Signal(SIGNALFILTER_SUPERGROUP, 10, "ON_GROUND",self.dropEntity2.id);
			self.dropEntity2.cnt.AnimationSystemEnabled = 1;
			self.dropEntity2.theRope = nil;
			self.dropEntity2:ActivatePhysics(1);
			self.dropEntity2:TriggerEvent(AIEVENT_ENABLE);
			AI:Signal(0, 1, "exited_vehicle", self.dropEntity2.id);
			self.dropEntity2 = nil;
			self:Retrieve();
		elseif( self.state == 4 ) then																-- position on bone
			self.dropEntity2:DrawCharacter(0,1);		
			self.dropEntity2:SetPos( self:GetBonePos("player") );
			self.dropE2Angle = self.dropE2Angle + self.dropE2DeltaAngle*dt;
			self.dropEntity2:SetAngles({x=0,y=0,z=self.dropE2Angle});	
		end	
	end
end

function Rope:OnContact( collider )
end

function Rope:Descend()
	self.state = 4;
	self:StartAnimation(0, self.AniTable.Descend, 0, 0  );
	self:SetAnimationEvent( self.id, self.AniTable.Descend );	
end

function Rope:Down( delayTime )
	self.delay = delayTime;
	self:EnableUpdate( 1 );
	if (Game:IsServer()) then
		Server:BroadcastCommand("FX",{x=0,y=self.state,z=self.delay},{x=self.dropEntity1Delay,y=self.dropEntity2Delay,z=0},self.id,2);
	end
end

function Rope:GoDown()
	if( self.state == 1 ) then
		return
	end	
	self.state = 2;
	self:SetAnimationEvent( self.id, self.AniTable.Down );
	self:StartAnimation(0, self.AniTable.Down, 0, 0 );
end

function Rope:OnRemoteEffect(toktable, pos, normal, userbyte)
	if (not Game:IsServer()) then
		if (userbyte == 1) then -- client drop
			local clt = System:GetEntity(pos.x);
			if (clt) then
				self:DropTheEntity(clt);
			end
		elseif (userbyte == 2) then -- client down
				self.state = pos.y;
				self.delay = pos.z;
				self.dropEntity1Delay = normal.x;
				self.dropEntity2Delay = normal.y;
				self:Down(self.delay);
		elseif (userbyte == 0) then -- client reset
			self:OnReset();
		end
	end
end

function Rope:Retrieve()
	if (self.state == 0) then
		return
	end
	if (self.Properties.bRetrieveRope == 0) then
		self.state = 1;
		return
	end
	self.state = 3;
	self:SetAnimationEvent( self.id, self.AniTable.Up );
	self:StartAnimation(0, self.AniTable.Up, 0, 0 );
end

function Rope:OnEvent( id, params)
	if (id == ScriptEvent_EndAnimation)	then
		if( params == self.AniTable.Down  ) then
			self.state = 1;
			self:DisableAnimationEvent( self.id, self.AniTable.Down );
			do return end
		end
		if( params == self.AniTable.Up ) then
			self.state = 0;
			self:DisableAnimationEvent( self.id, self.AniTable.Up );
			self:EnableUpdate( 0 );			
			do return end
		end
		if (params == self.AniTable.Descend) then
			self.state = 5;
			self:DisableAnimationEvent( self.id, self.AniTable.Descend );
			do return end
		end
	end
end

function Rope:DropTheEntity( entity, hide )
	if (entity.cnt.health <= 0) then return end
	if (self.dropEntity1 and self.dropEntity2) then
		return
	end
	if (Game:IsServer()) then
		Server:BroadcastCommand("FX",{x=entity.id,y=self.state,z=self.delay},{x=self.dropEntity1Delay,y=self.dropEntity2Delay,z=0},self.id,1);
	end
	entity:ActivatePhysics(0);	
	entity:TriggerEvent(AIEVENT_DISABLE);
	entity:StartAnimation(0, "rope_descend_loop");
	entity.cnt.AnimationSystemEnabled = 0;
	if (hide) then
		entity:DrawCharacter(0,0);
	end
	if ( self.dropEntity1 == nil ) then
		self.dropEntity1 = entity;
		self.dropEntity1.theRope = self;
		self.dropE1Angle = random(0, 359);
		self.dropE1DeltaAngle = random(0, 200) - 100;
	else
		self.dropEntity2 = entity;
		self.dropEntity2.theRope = self;
		self.dropE2Angle = random(0, 359);
		self.dropE2DeltaAngle = random(0, 200) - 100;
	end
end

function Rope:ReleaseStuff()
	if (self.dropEntity1) then 
		self.dropEntity1:DrawCharacter(0,1);
		self.dropEntity1.cnt.AnimationSystemEnabled = 1;
		self.dropEntity1:ActivatePhysics(1);
		self.dropEntity1:TriggerEvent(AIEVENT_ENABLE);
		AI:Signal(0, 1, "exited_vehicle", self.dropEntity1.id);
		self.dropEntity1 = nil;
	end
	if (self.dropEntity2) then 
		self.dropEntity2:DrawCharacter(0,1);
		self.dropEntity2.cnt.AnimationSystemEnabled = 1;
		self.dropEntity2:ActivatePhysics(1);
		self.dropEntity2:TriggerEvent(AIEVENT_ENABLE);
		AI:Signal(0, 1, "exited_vehicle", self.dropEntity2.id);
		self.dropEntity2 = nil;
	end
end

function Rope:OnShutDown()
	self:ReleaseStuff();
end

function Rope:OnReset()
	self.state = 0;
	self.delay = -1;
	self.dropEntity1 = nil;
	self.dropEntity2 = nil;
	self:DrawObject(0,1);
	self:EnableUpdate( 0 );
	self:SetUpdateType( eUT_Unconditional );
	self:DrawCharacter(0,1);
	self.dropEntity1Delay = 0;
	self.dropEntity2Delay = 0;
	if (Game:IsServer()) then
		Server:BroadcastCommand("FX",{x=0,y=0,z=0},{x=0,y=0,z=0},self.id,0);
	end
end

function Rope:Event_DoDrop( params )
	self:Down(0.0);
	self:DropTheEntity( System:GetEntityByName(self.Properties.dropeName) );
end