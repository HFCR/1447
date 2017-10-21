--[[CryTop team scripting]]--
-- Create by CryTop L.A.G.G.E.R.
-- Based on ClearingVehicleRadio script.
VehicleRadio={
	type="Sound",
	Properties={
		iVolume=255,
		InnerRadius=5,
		OuterRadius=200,
		fFadeValue=1.0,-- for indoor sector sounds
		bLoop=0,	-- Loop sound.
		bPlay=1,	-- Immidiatly start playing on spawn.
		bOnce=0,
		bEnabled=1,
		RadioMinHealth=26,--25 is burning vehicle
		RadioChannels={
			sndChannel01="",
			sndChannel02="",
			sndChannel03="",
			sndChannel04="",
			sndChannel05="",
			sndChannel06="",
			sndChannel07="",
			sndChannel08="",
			sndChannel09="",
			sndChannel10="",
			sndChannel11="",
			sndChannel12="",
			sndChannel13="",
		},  --RadioChannels
	},
	started=0,
	Editor={
		Model="Objects/Editor/Sound.cgf",
	},
	bEnabled=1,
}

function VehicleRadio:OnSave(stm)
	stm:WriteInt(self.started)
	stm:WriteInt(self.bEnabled)
end

function VehicleRadio:OnLoad(stm)
	self.started=stm:ReadInt()
	self.bEnabled=stm:ReadInt()
	if self.started==1 and self.Properties.bOnce==0 then
		self:Event_NextTrack()
	end
end

function VehicleRadio:OnInit()
	self:OnReset()
end

function VehicleRadio:OnReset()
	self.bEnabled=self.Properties.bEnabled
	if self.bEnabled==1 then
		self:EnableUpdate(1)
	else
		self:EnableUpdate(0)
	end
	self.loop=self.Properties.bLoop
	self.VehicleEntity=nil
	self:NetPresent(nil)
	self.Destroyed=nil
	self:StopSound()
	self.PlayingRadio=nil
	self.fDistance=nil
	if self.Properties.bPlay==1 then self:PlaySound() end
end

function VehicleRadio:OnPropertyChange()
	self:OnReset()
end

function VehicleRadio:PlaySound()
	if self.bEnabled~=1 then return end
	if not self.sound then self:LoadSnd() end
	if not self.sound then return end
	if self.Properties.bLoop~=0 then
		Sound:SetSoundLoop(self.sound,1)
	else
		Sound:SetSoundLoop(self.sound,0)
	end
	Sound:SetSoundPosition(self.sound,self:GetPos())
	Sound:SetMinMaxDistance(self.sound,self.Properties.InnerRadius,self.Properties.OuterRadius)
	Sound:PlaySound(self.sound)
	self.started=1
end

function VehicleRadio:StopSound()
	if self.sound then
		Sound:StopSound(self.sound)
		self.sound=nil
	end
	self.started=0
end

function VehicleRadio:SwitchRadio()
	if not self.SwitchSound then self.SwitchSound=Sound:LoadSound("sounds\\items\\WEAPON_FIRE_MODE.wav") end
	Sound:SetSoundVolume(self.SwitchSound,255)
	Sound:PlaySound(self.SwitchSound)
end

function VehicleRadio:SwitchChannel()
	if not self.SwitchChannelSound then self.SwitchChannelSound=Sound:LoadSound("sounds\\items\\tv_static.wav") end
	Sound:SetSoundVolume(self.SwitchChannelSound,145)
	Sound:PlaySound(self.SwitchChannelSound)
end

function VehicleRadio:OnUpdate()
	if self.VehicleEntity and (self.VehicleEntity.fEngineHealth<=self.Properties.RadioMinHealth or self.VehicleEntity.IsBroken==1) then
		self.Destroyed=1
	else
		self.Destroyed=nil
	end
	if _localplayer.theVehicle and _localplayer.theVehicle.AllowRadio then
		local Vehicle=_localplayer.cnt:GetCurVehicle()
		if not Vehicle then return end
		self.VehicleEntity=System:GetEntityByName(Vehicle:GetName())
		if self.Destroyed then return end
		if not self.StartMessage then
			self.StartMessage=1
			Hud:AddMessage("@SwitchR",4)
		end
		local Key=Input:GetXKeyPressedName()
		if Key=="n" then
			if not self.PlayingRadio then
				self.PlayingRadio=1
				self:SwitchRadio()
				Hud:AddMessage("@ron")
			else
				self.PlayingRadio=nil
				self:SwitchRadio()
				Hud:AddMessage("@roff")
			end
		elseif Key=="r" and self.PlayingRadio then
			self:SwitchRadio()
			self:SwitchChannel()
			self:Event_NextTrack()
			Hud:AddMessage("@nch")
		end
	else
		self.StartMessage=nil
	end
	if self.sound then
		if not Sound:IsPlaying(self.sound) and self.PlayingRadio then -- Если трек закончился, то переключиться на другой.
			if self.fDistance and self.fDistance<=self.Properties.OuterRadius then -- При выходе за пределы OuterRadius музыка перестаёт звучать и при возвращении обратно вновь не воспроизводится, поэтому перекючение каналов и в этом помогает.
				self:Event_NextTrack()
			end
		end
		if self.VehicleEntity and self.VehicleEntity.AllowRadio and self.PlayingRadio and not self.Destroyed then
			self.fDistance=_localplayer:GetDistanceFromPoint(self.VehicleEntity:GetPos())
			Sound:SetSoundVolume(self.sound,self.Properties.iVolume) -- Установить указанную в параметрах громкость.
			Sound:SetSoundPosition(self.sound,self.VehicleEntity:GetPos()) -- Устанавливать актуальную позицию только если это действительно необходимо.
		else
			self.fDistance=nil
			Sound:SetSoundVolume(self.sound,0) -- Зачем выключать музыку? Можно просто заглушить.
		end
	end
end

function VehicleRadio:LoadSnd()
	self:StopSound()
	local sndFlags=bor(SOUND_RADIUS)
	-- for i,val in self.Properties.RadioChannels do
		-- if val=="" then val = "sounds\\radiostation\\song"..i..".wav" end
		-- if val=="" then self.Properties.RadioChannels[i] = "sounds\\items\\WEAPON_FIRE_MODE.wav" end -- Чтобы заполнить пустоту. Воспроизводиться не будет, но так-же и не будет ошибки.
		-- -- System:Log(i..": val: "..self.Properties.RadioChannels[i])
	-- end
	local Channels ={ -- Надо что-то придумать, если sndChannel = nil. А то вызывет небольшие лаги.
		Sound:Load3DSound(self.Properties.RadioChannels.sndChannel01,sndFlags),
		Sound:Load3DSound(self.Properties.RadioChannels.sndChannel02,sndFlags),
		Sound:Load3DSound(self.Properties.RadioChannels.sndChannel03,sndFlags),
		Sound:Load3DSound(self.Properties.RadioChannels.sndChannel04,sndFlags),
		Sound:Load3DSound(self.Properties.RadioChannels.sndChannel05,sndFlags),
		Sound:Load3DSound(self.Properties.RadioChannels.sndChannel06,sndFlags),
		Sound:Load3DSound(self.Properties.RadioChannels.sndChannel07,sndFlags),
		Sound:Load3DSound(self.Properties.RadioChannels.sndChannel08,sndFlags),
		Sound:Load3DSound(self.Properties.RadioChannels.sndChannel09,sndFlags),
		Sound:Load3DSound(self.Properties.RadioChannels.sndChannel10,sndFlags),
		Sound:Load3DSound(self.Properties.RadioChannels.sndChannel11,sndFlags),
		Sound:Load3DSound(self.Properties.RadioChannels.sndChannel12,sndFlags),
		Sound:Load3DSound(self.Properties.RadioChannels.sndChannel13,sndFlags),
	}
	local Max=0
	local Channels2={} -- Что-выбирало только те пункты, в которых есть музыка.
	local Number=0
	for i,val in Channels do
		Number=Number+1
		Channels2[Number]=Channels[i]
		Max=Number
		-- System:Log("Channels2: "..Number)
	end
	-- System:Log("val: "..Max)
	self.sound=Channels2[random(1,Max)]
	Sound:SetSoundProperties(self.sound,self.Properties.fFadeValue)
end

function VehicleRadio:Event_NextTrack()
	self:StopSound()
	self:PlaySound()
	BroadcastEvent(self,"NextTrack")
end

function VehicleRadio:Event_Play(sender)
	if self.Properties.bOnce==1 and self.started==1 then return	end
	self:Event_NextTrack()
	BroadcastEvent(self,"Play")
end

function VehicleRadio:Event_Stop(sender)
	self:StopSound()
	BroadcastEvent(self,"Stop")
end

function VehicleRadio:Event_Enable(sender)
	self.bEnabled=1
	BroadcastEvent(self,"Enable")
end

function VehicleRadio:Event_Disable(sender)
	self.bEnabled=0
	BroadcastEvent(self,"Disable")
end

function VehicleRadio:Event_Redirect(sender)
	BroadcastEvent(self,"Redirect")
end