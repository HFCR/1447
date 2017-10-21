MissionHint = {
	type = "Sound",

	Properties = {
		Hints = {
			sndHint1="",
			sndHint2="",
			sndHint3="",
			sndHint4="",
			sndHint5="",
			sndHint6="",
			sndHint7="",
			sndHint8="",
			sndHint9="",
			sndHint10="",
		},
		sndSkipAcknowledge="",
		iAllowedToSkip=3,
		iVolume=255,
		bLoop=0,	-- Loop sound.
		bOnce=0,
		bEnabled=1,
		bScaleDownVolumes=1,

	},
	skipped=0,
	HintCount = 1,
	SkipCount = 0,
	Editor={
		Model="Objects/Editor/Sound.cgf",
	},	
}

function MissionHint:OnSave(stm)
	stm:WriteInt(self.HintCount);
end

function MissionHint:OnLoad(stm)
	self:OnReset();
	self.HintCount = stm:ReadInt();
end

function MissionHint:OnPropertyChange()
	if (self.soundName ~= self.Properties.sndSource or self.sound == nil or self.Properties.bLoop ~= self.loop) then
		self.loop = self.Properties.bLoop;
	end
	self:OnReset();
	if (self.sound ~= nil) then
		if (self.Properties.bLoop~=0) then
			Sound:SetSoundLoop(self.sound,1);
		else
			Sound:SetSoundLoop(self.sound,0);
		end;

		Sound:SetSoundVolume(self.sound,self.Properties.iVolume);			
	end;
end

function MissionHint:OnReset()
	self:NetPresent(nil);
	self.SkipCount = 0;
	self.HintCount = 1;
	self.skipped = 0;
	self:StopSound();
	self.sound = nil;
	Sound:SetGroupScale(SOUNDSCALE_MISSIONHINT, 1.0);
end

MissionHint["Server"] = {
	OnInit= function (self)
		self:EnableUpdate(0);
		self.started = 0;
	end,
	OnShutDown= function (self)
	end,
}

MissionHint["Client"] = {
	OnInit = function(self)
		self:EnableUpdate(0);
		self.started = 0;
		self.loop = self.Properties.bLoop;
		self.soundName = "";
		if (self.Properties.bPlay==1) then
			self:Play();
		end
	end,
	OnTimer= function(self)
		if ((not Sound:IsPlaying(self.sound)) or (_localplayer.cnt.health<1)) then
			--System:Log("sound stopped - sound scale to normal");
			Sound:StopSound(self.sound)
			self.sound = nil;
			Sound:SetGroupScale(SOUNDSCALE_MISSIONHINT, 1.0);
		else
			-- Sound still playing.
			-- set another timer.
			self:SetTimer(1000);
		end
	end,

	OnShutDown = function(self)
		self:StopSound();
	end,
}

function MissionHint:Play()

	if ((self.Properties.bEnabled == 0 ) or (self.skipped == 1) ) then 
		do return end;
	end

	if( Sound:IsPlaying(self.sound) )then
		Sound:StopSound(self.sound);
		Sound:SetGroupScale(SOUNDSCALE_MISSIONHINT, 1.0);
		self.SkipCount = self.SkipCount+1;
	end

	self.sound = nil;

	if (self.SkipCount > self.Properties.iAllowedToSkip) then 
		if (sndSkipAcknowledge ~= "") then
			self.skipped = 1;
			self.sound = Sound:LoadSound(self.Properties.sndSkipAcknowledge);
			self.soundName = self.Properties.sndSkipAcknowledge;
		end
	else
		if (self.sound == nil) then
			self:LoadSnd();
			if (self.sound == nil) then
				return;
			end;
		end
	end


	if (self.Properties.bLoop~=0) then
		Sound:SetSoundLoop(self.sound,1);
	else
		Sound:SetSoundLoop(self.sound,0);
	end;

	Sound:SetSoundVolume(self.sound,self.Properties.iVolume);

	self:SetTimer( 1000 );
	
	if (self.Properties.bScaleDownVolumes==1) then
		Sound:SetGroupScale(SOUNDSCALE_MISSIONHINT, SOUND_VOLUMESCALEMISSIONHINT);
	end

	-- Mixer: coop/mp improvement for use with several players
	local nearby_players = {};
	local maxdist = 3600;
	self.playcandidate = nil;
	Game:GetPlayerEntitiesInRadius(self:GetPos(), maxdist, nearby_players );
	if (getn(nearby_players) > 0) then
		for i, Player in Hud.tblPlayers do
			if (Player.pEntity and Player.pEntity.id) then
				local pEntity=System:GetEntity(Player.pEntity.id);
				if (pEntity) and (pEntity.classname == "Player") then
					if (Player.fDistance2 < maxdist) then
						maxdist = Player.fDistance2 * 1;
						self.playcandidate = Player.pEntity.id * 1; 
					end
				end	
			end
		end
		if (self.playcandidate) then
			local plcand_ent = System:GetEntity(self.playcandidate);
			if (plcand_ent) and (plcand_ent ~= _localplayer) then
				if (plcand_ent.painSound) and (Sound:IsPlaying(plcand_ent.painSound)) then
				else
					local coopsaid = {
						{self.soundName,SOUND_RADIUS,self.Properties.iVolume,6,36},
					};
					plcand_ent.painSound = BasicPlayer.PlayOneSound(plcand_ent,coopsaid,101);
				end
				return;
			end
		end
	end
	Game:PlaySubtitle(self.sound);
	--Sound:PlaySoundFadeUnderwater(self.sound)
end

function MissionHint:StopSound()

	if (self.Properties.bEnabled == 0 ) then 
		do return end;
	end

	if (self.sound ~= nil ) then
		Sound:StopSound(self.sound);
		self.sound = nil;
	end
	self.started = 0;
end

function MissionHint:LoadSnd()
	if (self.Properties.Hints["sndHint"..self.HintCount] ~= "") then
		self.sound = Sound:LoadSound(self.Properties.Hints["sndHint"..self.HintCount]);
		self.HintCount = self.HintCount + 1;
	end
	self.soundName = self.Properties.Hints["sndHint"..self.HintCount];
end

function MissionHint:OnRemoteEffect(toktable, pos, normal, userbyte)
	if (not Game:IsServer()) then
		self.SkipCount = floor(pos.x);
		self.HintCount = floor(pos.y);
		self.skipped = floor(pos.z);
		if (userbyte == 1) then -- client play
			self:Event_Play();
		elseif (userbyte == 0) then -- client stop
			self:Event_Stop();
		end
	end
end

function MissionHint:Event_Play(sender)
	if (Game:IsServer()) then
		Server:BroadcastCommand("FX",{x=self.SkipCount,y=self.HintCount,z=self.skipped},{x=0,y=0,z=0},self.id,1);
	end
	if (self.started~=0) then
		return
	end
	self:Play();
end

function MissionHint:Event_Stop( sender )
	if (Game:IsServer()) then
		Server:BroadcastCommand("FX",{x=self.SkipCount,y=self.HintCount,z=self.skipped},{x=0,y=0,z=0},self.id,0);
	end
	self:StopSound();
end

function MissionHint:Event_Enable( sender )
	self.Properties.bEnabled = 1;
end

function MissionHint:Event_Disable( sender )
	self.Properties.bEnabled = 0;
end

function MissionHint:OnWrite( stm )
end

function MissionHint:OnRead( stm )
end