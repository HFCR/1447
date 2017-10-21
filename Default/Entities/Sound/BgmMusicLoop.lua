-- BgmMusicLoop (Background Music MUsic Loop) by Mixer v2.5
BgmMusicLoop = {
	Editor = {
		Model="Objects/Editor/S.cgf",
	},
	Properties = {
		sndBgmMusic="",
		bLoop=1,
		bEnabled=1,
	},
	my_lastfade = 0,
	InsideArray = 	{0,0,0,0,0,0,0,0,0,0},
};

function BgmMusicLoop:OnPropertyChange()
	self:LoadSounds();
	self.turnoffwithfade = nil;
	self.turnonwithfade = nil;
end

function BgmMusicLoop:CliSrv_OnInit()
	self:EnableUpdate(0);	
	self.turnoffwithfade = nil;
	self.turnonwithfade = nil;
	if (self.Initialized) then
		return
	end
	
	self:RegisterState("Inactive");
	self:RegisterState("Active");
	self:GotoState("Inactive");
	self["Initialized"]=1;
end

function BgmMusicLoop:Event_TurnOn()
	self.Properties.bEnabled = 1;
end

function BgmMusicLoop:Event_TurnOff()
	self.Properties.bEnabled = 0;
end

function BgmMusicLoop:Event_Fade()
end

function BgmMusicLoop:Event_TurnOffWithFadeOut()
	self.Properties.bEnabled = 0;
	self.turnoffwithfade = 1;
	self:SetTimer(3);
end

function BgmMusicLoop:Event_TurnOnWithFadeIn()
	self.Properties.bEnabled = 1;
	self.turnonwithfade = 1;
	self.my_lastfade = 0;
	self:LoadSounds();
	self:GotoState("Active");
	self:SetTimer(3);
	--System:LogAlways(self:GetName().." turn on with fade in");
end

function BgmMusicLoop:OnSave(stm)
	if (self.Properties.bEnabled ~= 1) then
		self.my_lastfade = -10;
	end
	stm:WriteInt(self.my_lastfade);
end

function BgmMusicLoop:OnLoad(stm)
	self.my_lastfade = stm:ReadInt();
	if (self.my_lastfade == -10) then
		self.my_lastfade = 0;
		self.Properties.bEnabled = 0;
	end
	if (self.my_lastfade > 0) then
		self:LoadSounds();
		if (self.mybgm) then
			Sound:PlaySound(self.mybgm);
		end
	end
end

function BgmMusicLoop:LoadSounds()
	if (self.Properties.sndBgmMusic ~= "") then
		--
		if (not self.mybgm) and (tostring(getglobal("s_MusicEnable")) == "1") then
			self.mybgm = Sound:LoadStreamSound(self.Properties.sndBgmMusic, SOUND_MUSIC+SOUND_UNSCALABLE);
		end
		if (self.mybgm) then
			if (self.Properties.bLoop ~= 0) then
				Sound:SetSoundVolume(self.mybgm, getglobal("s_MusicVolume") * 255.0 * self.my_lastfade);
			else
				Sound:SetSoundVolume(self.mybgm, getglobal("s_MusicVolume") * 255);
			end
			Sound:SetSoundLoop(self.mybgm,self.Properties.bLoop);
		else
			self.mybgm = nil;
		end
	end
end

function BgmMusicLoop:Client_Active_OnTimer()
	if (self.turnoffwithfade) then
		self:SetTimer(3);
		self.my_lastfade = self.my_lastfade - 0.012;
		if (self.my_lastfade < 0) then
			self.my_lastfade = 0;
			self.turnoffwithfade = nil;
		end
		if (self.mybgm) then
			Sound:SetSoundVolume(self.mybgm, getglobal("s_MusicVolume") * 255.0 * self.my_lastfade);
			if (self.my_lastfade == 0) and (Sound:IsPlaying(self.mybgm)) then
				Sound:StopSound(self.mybgm);
			end
		end
	elseif (self.turnonwithfade) then
		self:SetTimer(3);
		self.my_lastfade = self.my_lastfade + 0.012;
		if (self.my_lastfade > 1) then
			self.my_lastfade = 1;
			self.turnonwithfade = nil;
		end
		if (self.mybgm) then
			Sound:SetSoundVolume(self.mybgm, getglobal("s_MusicVolume") * 255.0 * self.my_lastfade);
			if (not Sound:IsPlaying(self.mybgm)) then
				Sound:PlaySound(self.mybgm);
			end
		end
	end
end

function BgmMusicLoop:OnShutDown()
end

function BgmMusicLoop:Client_Inactive_OnEnterArea( player,areaId )
	self:LoadSounds();
	self.InsideArray[areaId] = 1;
	------
	if (self.mybgm) and (self.Properties.bEnabled==1) then
		Sound:PlaySound(self.mybgm);
		ClientStuff.lst_bgmsndid = {self.id,areaid};
	end
	self:GotoState("Active");
end

function BgmMusicLoop:Client_Active_OnEnterArea( player,areaId )
	self.InsideArray[areaId] = 1;
	-------
	if (self.mybgm) and (self.Properties.bEnabled==1) then
		Sound:PlaySound(self.mybgm);
		ClientStuff.lst_bgmsndid = {self.id,areaid};
	end
end

function BgmMusicLoop:Client_Active_OnLeaveArea( player,areaId )
	if self.InsideArray and self.InsideArray[areaId] then
		self.InsideArray[areaId] = 0;
	end
	self.my_lastfade = 0;
	if (self.mybgm) and (Sound:IsPlaying(self.mybgm)) and (self.Properties.bLoop ~= 0) then
		Sound:StopSound(self.mybgm);
	end
	if( areaId == 1 )	then	-- got out of outside area
		self:GotoState("Inactive");
	end
	if (self.Properties.bEnabled==1) then
		BroadcastEvent(self,"Fade");
	end
end

function BgmMusicLoop:Client_Active_OnProceedFadeArea( player,areaId,fadeCoeff )
	self.my_lastfade = fadeCoeff * 1;
	if (self.mybgm) then
		if (self.Properties.bLoop ~= 0) then
			Sound:SetSoundVolume(self.mybgm, getglobal("s_MusicVolume") * 255.0 * self.my_lastfade);
		end
	end
	if (self.Properties.bEnabled==1) then
		BroadcastEvent(self,"Fade");
	end
end

BgmMusicLoop.Server={
	OnInit=function(self)
		self:CliSrv_OnInit()
	end,
	OnShutDown=function(self)
	end,
	Inactive={
	},
	Active={
	},
}

BgmMusicLoop.Client={
	OnInit=function(self)
		self:CliSrv_OnInit()
	end,
	OnShutDown=function(self)
	end,
	Inactive={
		OnEnterArea=BgmMusicLoop.Client_Inactive_OnEnterArea,
	},
	Active={
		OnBeginState=function(self)
			self:SetTimer(200);
		end,
		OnTimer=BgmMusicLoop.Client_Active_OnTimer,
		OnProceedFadeArea=BgmMusicLoop.Client_Active_OnProceedFadeArea,
		OnEnterArea=BgmMusicLoop.Client_Active_OnEnterArea,		
		OnLeaveArea=BgmMusicLoop.Client_Active_OnLeaveArea,
		OnEndState=function(self)
			self:KillTimer();
		end,
	},
}
