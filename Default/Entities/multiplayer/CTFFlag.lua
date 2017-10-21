-- CTF mod
-- CTF Flag
-- Created by TheCounter
-- Modified by James-Ryan and Mushroom
-- Improved by Mixer v2.0 client fix

Script:LoadScript("scripts/default/entities/multiplayer/CTFFlag_base.lua");

CTFFlag={
	Properties={
		team="red",
	},
	CTE_Flag=1,
	FlagCarrier={

	},
	health=100,
	carrier_health=0,
	Flag = nil,
	iscaptured=0,
	cap_frombase=0,
	
};

function CTFFlag:LoadGeometry()
	if(not self.geometry_loaded)then
		self.geometry_loaded=1
		if (self.Properties.team=="red") then
			self:LoadObject("objects/multiplayer/FlagRed/flag_red_stationary.cgf",0,2);
		elseif (self.Properties.team=="blue") then
			self:LoadObject("objects/multiplayer/FlagBlue/flag_blue_stationary.cgf",0,2);
		else
			System:Error( "Unknown Flag team, unable to load CTE Flag model.  Specify blue or red in editor");
		end
	end
	
end

function CTFFlag:RegisterStates()
	self:RegisterState("AtHome");
	self:RegisterState("Captured");
	self:RegisterState("Dropped");
end

function CTFFlag:OnReset()
	self:GotoState("AtHome");
end

function CTFFlag:CaptureFlag(team,carrier,Flag)
	GameRules:SetCapture(team,carrier);
	self.carrier_health=carrier.cnt.health;
	
	self.iscaptured=1;
	self.FlagCarrier=carrier;
	Flag:GotoState("Captured");
	
end

function CTFFlag:ReturnFlag()
	
	if(self.original_pos)then
		self:SetPos(self.original_pos);
		self:SetAngles(self.original_angles);
		self.iscaptured=0;
		self.health=100;
	end
end

function CTFFlag:Server_Dropped_OnContact(collider)
	if((GameRules:GetState()=="INPROGRESS") and (collider.type=="Player") and (collider.cnt.health>0)) then
		local team=Game:GetEntityTeam(collider.id);
		if((team~=self.Properties.team))then
			--Flag CAPTURED
			self:CaptureFlag(team,collider,self);
		else
		if self.Properties.team == "blue" then
		Server:BroadcastCommand("CFR B "..collider.id); else
		Server:BroadcastCommand("CFR R "..collider.id); end
		self:ReturnFlag();
		self:GotoState("AtHome");
		end
		self.iscaptured=0;
		self.cap_frombase=0;
	end
end

function CTFFlag:OnPlayerDie(carrier)
	local team=Game:GetEntityTeam(carrier.id);
	if(team~=self.Properties.team and GameRules:IsFlagCarrier(team,carrier))then

		self:DropFlag(carrier, team);
		self.iscaptured=0;
		self.cap_frombase=0;
		carrier.idECHighlight=nil;
	else
		
	end
end

function CTFFlag:DropFlag(carrier,team)
	self:SetPos(carrier:GetPos());
	self:SetAngles(self.original_angles);
	GameRules:ResetCapture(team,carrier);
	Server:BroadcastText(team.." @FlagLost");
	self:GotoState("Dropped");
	self.iscaptured=0;
	
	carrier.idECHighlight=nil;
end

function CTFFlag:DetachFlagFromCarrier()

end
	
----------------------------------------------------
--SERVER
----------------------------------------------------
CTFFlag.Server={
	OnInit=function(self)
		CTFFlag.Flag = self;
		self:LoadGeometry();
		self:RegisterStates();
		self:OnReset();
		self:NetPresent(1);
		self:EnableUpdate(1);
		if getglobal("gr_ctf_revert_time") == nil then
			Game:CreateVariable("gr_ctf_revert_time",30);
		else
			Game:CreateVariable("gr_ctf_revert_time",getglobal("gr_ctf_revert_time"));
		end
		if (GameRules.RegisterFlag)then
			GameRules:RegisterFlag(self);
		end
	end,
-------------------------------------
	AtHome={
		OnBeginState=function(self)
			self.original_pos=new(self:GetPos());
			self.original_angles=new(self:GetAngles());
			local p=self.original_pos;
			self.health=100;

		end,
		
	},
-------------------------------------
	Captured={
		OnBeginState=function(self)
						
		end,
		OnUpdate=function(self)
				
		end,
		
	},
-------------------------------------
	Dropped={
		-- Jeppa's improvement:
		OnBeginState=function(self)
			local reverttimer = toNumberOrZero(getglobal("gr_ctf_revert_time"));
			if (reverttimer > 0) then
				self:SetTimer(reverttimer*1000);
			end
		end,
		OnContact=CTFFlag.Server_Dropped_OnContact,
		OnTimer=function(self)
			self:ReturnFlag();
			self:GotoState("AtHome");
			self.iscaptured=0;
			self.cap_frombase=0;
			Server:BroadcastCommand("CFR");
		end, 
	},
}

----------------------------------------------------
--CLIENT
----------------------------------------------------
CTFFlag.Client={
	OnInit=function(self)
		CTFFlag.Flag = self;
		self:LoadGeometry();
		self:RegisterStates();
		self:OnReset();
		self:EnableUpdate(1);
		
		local Flags = getglobal("ctf_flags");
		
		if(Flags~=nil) then
			for i, Flag in Flags do
				if(Flag==self) then
					return;
				end
			end
			Flags[self]=self;
			setglobal("ctf_flags",Flags);
		else
			Flags={};
			Flags[self]=self;
			setglobal("ctf_flags",Flags);
		end
			
	end,
-------------------------------------
	AtHome={
		OnBeginState=function(self)
			
			self:DrawObject(0,1);
			
			self:DetachFlagFromCarrier();	
			self:DrawCharacter(0,0);
			
		end,
	},
-------------------------------------
	Captured={
		OnBeginState=function(self)
			
			self:DrawObject(0,0);
			self:DrawCharacter(0,0);	
					
		end,
	},
-------------------------------------
	Dropped={
		OnBeginState=function(self)
			
			self:DrawObject(0,1);	
			self:DrawCharacter(0,0);		
			self:DetachFlagFromCarrier();
			
		end,
	},
}