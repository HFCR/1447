BuyObject = {
	Properties = {
		fileModel="Objects/weapons/de/de_bind.cgf",
		bActive=1,
		nAmount=1,
		nPrice=120,
		sBuyCommand="Falcon",
		sndBuySound="Sounds/Weapons/Mortar/mortar_46.wav",
	},
};

function BuyObject:OnInit()
	self:RegisterState("Active");
	self:RegisterState("Hidden");
	self:LoadObject( self.Properties.fileModel, 0,1 );
	self:CreateStaticEntity( 80,-1 );
	self:OnReset();
end

function BuyObject:OnReset()
	self.bActive=self.Properties.bActive*1;
	if self.bActive==1 then
		self:GotoState( "Active" );
	else
		self:GotoState( "Hidden" );
	end
end

function BuyObject:Event_Hide()
	self.bActive=0;
	self:GotoState( "Hidden" );
end

function BuyObject:Event_Activate()
	self.bActive=1;
	self:GotoState( "Active" );
end

function BuyObject:Event_Buy()
	BroadcastEvent(self, "Buy");
	if (Game:IsClient()) then
		if self.buysnd==nil then
			self.buysnd= Sound:Load3DSound(self.Properties.sndBuySound,SOUND_UNSCALABLE,255,5,32);
		end
		if self.buysnd then
			local ppos = self:GetPos();
			Particle:SpawnEffect(ppos,g_Vectors.v001,'bullet.hit_bullseye_pancor.a',1);
			Sound:SetSoundPosition(self.buysnd,ppos);
			Sound:PlaySound(self.buysnd);
		end
	end
end

function BuyObject:OnRemoteEffect(toktable, pos, normal, userbyte)
	if (userbyte == 1) then -- client play
		self:Event_Buy();
	end
end

BuyObject.Active={
	OnBeginState=function(self)
		self:DrawObject(0,1);
		self:EnablePhysics( 1 );
	end,
}

BuyObject.Hidden={
	OnBeginState=function(self)
		self:DrawObject(0,0);
		self:EnablePhysics( 0 );
	end,
}