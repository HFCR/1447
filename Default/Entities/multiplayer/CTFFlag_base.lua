-- CTF BASE
-- FIXED BY MIXER 1.1
CTFFlag_base={
	Properties={
		team = "red",
		model = "Objects/multiplayer/flagbase/flagbase_active.cgf",
		BBOX_Size={
		X=4,
  		Y=4,
		Z=18,
  		},
	},
};

function CTFFlag_base:LoadGeometry()
	if(not self.geometry_loaded)then
		self.geometry_loaded=1
		self:LoadObject(self.Properties.model,0,1);
		self:DrawObject(0,1);
		self:CreateStaticEntity( 700,-1 );
		
		--<<FIXME>> put the right modela
		--self:LoadCharacter("Objects/multiplayer/flagbase/flagbase_active.cgf",0);
	end
end

function CTFFlag_base:RegisterStates()
	self:RegisterState("AtHome");
end

function CTFFlag_base:OnReset()
	self:GotoState("AtHome");
	if (not self.Properties.BBOX_Size) then
		self.Properties.BBOX_Size={
		X=4,
  		Y=4,
		Z=18,
  		};
	end
	self:SetBBox({x=-(self.Properties.BBOX_Size.X*0.5),y=-(self.Properties.BBOX_Size.Y*0.5),z=0},
	{x=(self.Properties.BBOX_Size.X*0.5),y=(self.Properties.BBOX_Size.Y*0.5),z=(self.Properties.BBOX_Size.Z*1)});
end

function CTFFlag_base:Server_AtHome_OnContact(collider)
	if (GameRules.TeamCapture) and (GameRules:GetState()=="INPROGRESS") and (collider.type=="Player") and (collider.cnt.health>0) then
		local team=Game:GetEntityTeam(collider.id);
		local carrier=GameRules:IsFlagCarrier(team,collider);
		if ((team~=self.Properties.team)) then
		local flag = GameRules:GetTeamFlag(self.Properties.team);
		--MIXER: WAS FIXED BELOW (CAN CAPTURE ONLY IF FLAG IS HANGING ON THE BASE!)
		if (flag:GetState()=="AtHome") then
		flag:CaptureFlag(team,collider,flag);
		end
		else
		--IF IS THE CARRIER OF THE FLAG ..SCORE
		if (carrier ~= nil) then
		--SCORE!!!!
		local flag = GameRules:GetTeamFlag(team);
		local other_flag=GameRules:GetOtherFlag(flag);
		other_flag:ReturnFlag();
		GameRules:TeamCapture(team,collider);
		other_flag:GotoState("AtHome");	
		end
		end
	elseif (not Game:IsMultiplayer()) then
		Hud:DrawElement(603, 139,Hud.pickups[16],1,1,1,1);
		Game:WriteHudString(636,143,"FLAG TOUCHED", 1, 1, 1, 1, 22, 22);
	end
end
	
--SERVER

CTFFlag_base.Server={
	OnInit=function(self)
		self:LoadGeometry();
		self:OnReset();
		--the entity will not move so only the state change is sycronized over the net
		self:NetPresent(1);
		self:EnableUpdate(1);
		--if(GameRules.RegisterFlag)then
		--	GameRules:RegisterFlag(self);
		--end
	end,
	AtHome={
		OnBeginState=function(self)
		end,
		OnContact=CTFFlag_base.Server_AtHome_OnContact,
	},
}

----------------------------------------------------
--CLIENT
----------------------------------------------------
CTFFlag_base.Client={
	OnInit=function(self)
		self:LoadGeometry();
		self:RegisterStates();
		self:OnReset();
		self:EnableUpdate(1);
	end,
	AtHome={
		OnBeginState=function(self)
		end,
		--OnContact=CTFFlag_base.Server_AtHome_OnContact,
	},
}