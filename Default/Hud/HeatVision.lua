--CryVision Extended Overkill Edition v1.2.1 (Garbitos and Mixer)
-- Originator, Tiago Sousa 

HeatVision = {	
	EnergyDecreaseRate = 3,		
	ActivateSnd=Sound:LoadSound("sounds/items/nvisionactivate.wav"),
	DeactivateSnd=Sound:LoadSound("sounds/items/lock.wav"),
	PrevAmbientColor=nil,	
	IsActive=0,
	Amount = 0.5,
	Red = 0.1,
	reen = 0.45,
	Blue = 0.65,
	Style=nil,
	Strict=1,
	iUpdate=nil,
	blurAmount = 0.0,
	fadeInRate = 1.0,
	fadeInScale = 1.0,
	fadeOutRate = 0.1,
	--pTable = nil;
}

function HeatVision:OnInit()	
	HeatVision.IsActive=0;
	HeatVision.blurAmount = 0.0;
	HeatVision.iNumActive=0;
	HeatVision.fadeInRate = 1.0;
	HeatVision.fadeInScale = 1.0;
	HeatVision.fadeOutRate = 0.1;
	--pTable = {};
end

function HeatVision:OnActivate()
	if (HeatVision.IsActive==0) then		
		HeatVision.blurAmount = 0.0;
		HeatVision.fadeInScale = 1.0;
	end
	self.lastTime = _time;
	if (ClientStuff.vlayers:IsActive("SmokeBlur")) then
		local layer = ClientStuff.vlayers:GetActivateLayer("SmokeBlur");
		if (layer) then --take some values from smoke blur if its active on startup
			self.blurAmount=layer.blurAmount;
			self.fadeInRate=layer.fadeInRate;
			self.fadeOutRate=layer.fadeOutRate;
			self.fadeInScale=layer.fadeInScale;
		end
		ClientStuff.vlayers:DeactivateLayer("SmokeBlur");
	end
	if(_localplayer) then
		local p_ent = _localplayer;
		--Gamestyler only check also make strictness decision (ambient adjustment)
		if (p_ent.cryVizStyle) then	
			self.Amount = p_ent.screenAmount;
			self.Red = p_ent.screenColor[1];
			self.Green = p_ent.screenColor[2];
			self.Blue = p_ent.screenColor[3];
			self.blurAmount = 1.0; --some extra blur
			if (p_ent.cVstate) then 
				if (p_ent.cVstate==1) then
					self.Amount = 0.25;
					self.EnergyDecreaseRate = nil; --no sounds, no googles
				else
					self.Strict=nil; --no ambient and no screen effect
					--p_ent.cryVizStyle = p_ent.cVstate+2; --special case select cryVizStyle 2
					self.Red = p_ent.playerColor[1];
					self.Green = p_ent.playerColor[2];
					self.Blue = p_ent.playerColor[3];
				end
			end
			self.Style = p_ent.cryVizStyle;
			if (self.Style==3) then self.Strict=nil; end
		else --default colors
			self.Amount = 0.5;
			self.Red = 0.1;
			self.Green = 0.65;
			self.Blue = 0.45;
		end	 
		-- get all entities nearby and set cryvision effect on them
		local tblPlayers = { };		
		if (p_ent.GetPos) then
			local LocalPlayerPos=p_ent:GetPos();						
			Game:GetPlayerEntitiesInRadius(LocalPlayerPos, 999999, tblPlayers, 1);			
		else
			-- invalid player position? hack it..
			local LocalPlayerPos={ x=0, y=0, z=0};
			Game:GetPlayerEntitiesInRadius(LocalPlayerPos, 999999, tblPlayers, 1);			
		end		
		if(tblPlayers and type(tblPlayers)=="table") then
			for i, player in tblPlayers do		
				if(tblPlayers[i].pEntity and tblPlayers[i].pEntity.iPlayerEffect) then
					tblPlayers[i].pEntity.bPlayerHeatMask=1;
					if (self.Style) and (tblPlayers[i].pEntity~=p_ent) then  --pass on gamestyle specific effects
						tblPlayers[i].pEntity.cryVizStyle = self.Style; --apply player's style to entity so gamestyler can touch them
					end
					tblPlayers[i].pEntity.bUpdatePlayerEffectParams=1;
					BasicPlayer.ProcessPlayerEffects(tblPlayers[i].pEntity);
				end				
			end
			--self.pTable = tblPlayers; --Mixer, this has possibilites for crazy alien weapons
			self.iUpdate = 1; --do the arm shaders/colors
		end	
	end
	-- Hack: Only activate sound, if its first time active. If its already active its due to reloading.
	if (HeatVision.IsActive==0) and (self.EnergyDecreaseRate) then
		Sound:PlaySound(HeatVision.ActivateSnd);			  		  					
	end
	if (self.Strict) then
		System:SetScreenFx("NightVision", 1);
		self.PrevAmbientColor=new(System:GetWorldColor());
		local CurrAmbientColor=new(self.PrevAmbientColor);
		CurrAmbientColor[1]=CurrAmbientColor[1]+6.0; 
		CurrAmbientColor[2]=CurrAmbientColor[2]+4.0; 
		CurrAmbientColor[3]=CurrAmbientColor[3]+3.0;
		System:SetWorldColor(CurrAmbientColor);	
	end
	System:SetScreenFx("ScreenBlur", 1);
	System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurAmount", self.Amount);
	System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorRed", self.Red);
	System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorGreen", self.Green);
	System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorBlue", self.Blue);
	HeatVision.IsActive=1;
end

function HeatVision:OnDeactivate()
	-- get all entities nearby and reset current effect on them (cryvision)
	if (_localplayer) then
		local p_ent = _localplayer;
		local tblPlayers = { };
		if (p_ent.GetPos) then
			local LocalPlayerPos=p_ent:GetPos();						
			Game:GetPlayerEntitiesInRadius(LocalPlayerPos, 999999, tblPlayers, 1);			
		else
			-- invalid player position? hack it..
			local LocalPlayerPos={ x=0, y=0, z=0};
			Game:GetPlayerEntitiesInRadius(LocalPlayerPos, 999999, tblPlayers, 1);			
		end
		if (tblPlayers and type(tblPlayers)=="table") then
			for i, player in tblPlayers do		
				if(tblPlayers[i].pEntity and tblPlayers[i].pEntity.iPlayerEffect) then						
					tblPlayers[i].pEntity.bPlayerHeatMask=2;
					if (self.Style) and (tblPlayers[i].pEntity~=p_ent) then
						tblPlayers[i].pEntity.cryVizStyle = nil; --restore
					end
					tblPlayers[i].pEntity.bUpdatePlayerEffectParams=1;
					BasicPlayer.ProcessPlayerEffects(tblPlayers[i].pEntity);
				end				
			end	
			--self.pTable = {};
			--restore local player
			if (p_ent.prev_cryVizStyle) then p_ent.cryVizStyle = p_ent.prev_cryVizStyle; else p_ent.cryVizStyle = nil; end
			self.iUpdate = 1;
		end
	end
	if (not self.PrevAmbientColor) then
		self.PrevAmbientColor=new(System:GetWorldColor());
	end
	if (HeatVision.IsActive==1) and (self.EnergyDecreaseRate) then 
		Sound:StopSound(HeatVision.ActivateSnd);
		Sound:PlaySound(self.DeactivateSnd); 
	end
	if (self.Strict) then
		System:SetScreenFx("NightVision", 0);
		System:SetWorldColor(self.PrevAmbientColor);
	end
	self.IsActive = 0;
	self.Amount = 0.5;
	self.Red = 0.1;
	self.Green = 0.45;
	self.Blue = 0.65;
	self.Style = nil;
	self.Strict = 1;
	self.PrevAmbientColor=nil;
	self.EnergyDecreaseRate=3;
	self.blurAmount = 0.0;
	self.iUpdate = nil;
end

function HeatVision:OnUpdate()	
	if (_localplayer) and (_localplayer.type=="Player") then
		local p_ent = _localplayer;
		if (ClientStuff.vlayers:IsActive("SmokeBlur")) then
			local layer = ClientStuff.vlayers:GetActivateLayer("SmokeBlur");
			if (layer) then --take some values from smoke blur if its active on startup
				self.blurAmount=layer.blurAmount;
			self.fadeInRate=layer.fadeInRate;
				self.fadeOutRate=layer.fadeOutRate;
				self.fadeInScale=layer.fadeInScale;
			end
			ClientStuff.vlayers:DeactivateLayer("SmokeBlur");
		end
		-- add color
		if (self.Amount) then
			if (self.blurAmount>0) then
				local dt = _time - self.lastTime;
				self.blurAmount = self.blurAmount + dt * (self.fadeInRate * self.fadeInScale - self.fadeOutRate);
				if (self.blurAmount < 0.0) then self.blurAmount = 0.0;	end
			end
			local amt = (self.Amount + self.blurAmount);
			if (amt > 1.0) then amt = 1; end
			System:SetScreenFx("ScreenBlur", 1);
			System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurAmount", amt);
			System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorRed", self.Red+self.blurAmount);
			System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorGreen", self.Green+self.blurAmount);
			System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorBlue", self.Blue+self.blurAmount);
		else
			System:SetScreenFx("ScreenBlur", 0);
		end
		if (p_ent.screenAmount) then p_ent.screenAmount = self.Amount; end --remember this in case of refresh layer
		--sync player arms (the right way) cheers mixer
		local uWep = (p_ent.cnt and p_ent.cnt.weapon) and (self.iUpdate);
		if (not p_ent.items.invis_active) then
			if (p_ent.cryVizStyle) and (uWep) then
				p_ent.cnt.weapon.fBodyHeat = p_ent.fBodyHeat; --sync this
				GameStyler:GS_cryVizStyle(p_ent,2,p_ent.cryVizStyle,nil,p_ent.fBodyHeat,p_ent.items.aliensuit);
				p_ent.cnt.weapon.cryVizStyle = p_ent.cryVizStyle;
				GameStyler:GS_cryVizStyle(p_ent.cnt.weapon,0,p_ent.cnt.weapon.cryVizStyle,nil,p_ent.fBodyHeat,p_ent.items.aliensuit);
				p_ent.iLastWeaponID = p_ent.cnt.weaponid;
				self.iUpdate=nil;
			end
		end
		--subtract energy only if we are using 'pure' heatvision
		if (not ClientStuff.vlayers:IsActive("Binoculars")) and (self.EnergyDecreaseRate) then
			p_ent.ChangeEnergy( p_ent, _frametime * -self.EnergyDecreaseRate );
		end
	end
	self.lastTime = _time;
	self.fadeInScale = 0;
end

function HeatVision:OnFadeOut()
	local dt = _time - self.lastTime;
	self.lastTime = _time;
	self.blurAmount = self.blurAmount - dt * self.fadeOutRate;
	if (self.blurAmount>=0.0) then
		System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurAmount", self.Amount+self.blurAmount);
		System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorRed", self.Red+self.blurAmount);
		System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorGreen", self.Green+self.blurAmount);
		System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorBlue", self.Blue+self.blurAmount);
	else
		HeatVision:OnDeactivate();
		return 1;
	end

end

function HeatVision:OnShutdown()	
	--HeatVision.IsActive=0;
	--HeatVision.Red=nil;
	--HeatVision.Green=nil;
	--HeatVision.Blue=nil;
	--HeatVision.Style=nil;
	--HeatVision.Amount=nil;
	--HeatVision.Strict=nil;
	--HeatVision.EnergyDecreaseRate=nil;
	--HeatVision.PrevAmbientColor=nil;
	--HeatVision.blurAmount = nil;
	--HeatVision.iUpdate=nil;				
	--HeatVision.pTable = {};
end

function HeatVision:OnRestore(pRestoreTbl)
	HeatVision.IsActive=pRestoreTbl.IsActive;
	HeatVision.IsActive=pRestoreTbl.IsActive;
	HeatVision.Style=pRestoreTbl.Style;
	HeatVision.Amount=pRestoreTbl.Amount;
	HeatVision.Strict=pRestoreTbl.Strict;
	HeatVision.EnergyDecreaseRate=pRestoreTbl.EnergyDecreaseRate;
	HeatVision.blurAmount= pRestoreTbl.blurAmount;
	HeatVision.fadeInRate= pRestoreTbl.fadeInRate;
	HeatVision.fadeInScale= pRestoreTbl.fadeInScale;
	HeatVision.fadeOutRate= pRestoreTbl.fadeOutRate;
	--HeatVision.pTable = {};	
end

