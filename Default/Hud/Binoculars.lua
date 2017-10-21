---
-- Binobug fix by Clivey and fix of Binobug fix by Mixer v2.22
-- X-Isle Script File
-- Description: Defines the binoculars
-- Created by Lennert Schneider
---
Binoculars = {
	IsActive = 0,
	ZoomActive = 0,
	LastZoom = 1,
	--old = 1; -- *** MIXER: SELECT BETWEEN OLD AND NEW BINOCULARS. TO USE NEW ONE, JUST COMMENT THIS LINE OUT ***
}

----
function Binoculars:OnInit()
	Binoculars.ZoomLevelChangeSound=Sound:LoadSound("Sounds/Items/BinoZoomChange.wav");
	Binoculars.StaticNoise=Sound:LoadSound("Sounds/radiovoices/aistatic.wav");
	local cur_r_TexResolution = tonumber( getglobal( "r_TexResolution" ) );
	if (self.old) then
	Binoculars.TID_Background=System:LoadImage("Textures/Hud/Binocular/binoculars");
	else
	if( cur_r_TexResolution >= 2 ) then
		Binoculars.TID_Background=System:LoadImage("Textures/Hud/Binocular/binoculars_low.tga");
	else
		Binoculars.TID_Background=System:LoadImage("Textures/Hud/Binocular/binoculars_new.tga");
	end
	end

	if( cur_r_TexResolution >= 1 ) then
		Binoculars.TID_Compass=System:LoadImage("Textures/Hud/Binocular/binoculars_compass_low.tga");
	else
		Binoculars.TID_Compass=System:LoadImage("Textures/Hud/Binocular/binoculars_compass.tga");
	end

	--Binoculars.TID_Power=System:LoadImage("Textures/Hud/Binocular/binoculars_battery");
	--Binoculars.TID_PowerGauge=System:LoadImage("Textures/Hud/Binocular/binoculars_energy");
	Binoculars.TID_Transition=System:LoadImage("Textures/Hud/Binocular/binoculars_transition");
	Binoculars.Zoom={};
	Binoculars.Zoom[1]={};
	Binoculars.Zoom[1].Factor=2.0;
	Binoculars.Zoom[1].TID=System:LoadImage("Textures/Hud/Binocular/binoculars_zoom_2");
	Binoculars.Zoom[2]={};
	Binoculars.Zoom[2].Factor=4.0;
	Binoculars.Zoom[2].TID=System:LoadImage("Textures/Hud/Binocular/binoculars_zoom_4");
	Binoculars.Zoom[3]={};
	Binoculars.Zoom[3].Factor=6.0;
	Binoculars.Zoom[3].TID=System:LoadImage("Textures/Hud/Binocular/binoculars_zoom_6");
	Binoculars.Zoom[4]={};
	Binoculars.Zoom[4].Factor=8.0;
	Binoculars.Zoom[4].TID=System:LoadImage("Textures/Hud/Binocular/binoculars_zoom_8");
	Binoculars.Zoom[5]={};
	Binoculars.Zoom[5].Factor=10.0;
	Binoculars.Zoom[5].TID=System:LoadImage("Textures/Hud/Binocular/binoculars_zoom_10");
	Binoculars.Zoom[6]={};
	Binoculars.Zoom[6].Factor=12.0;
	Binoculars.Zoom[6].TID=System:LoadImage("Textures/Hud/Binocular/binoculars_zoom_12");
	Binoculars.Zoom[7]={};
	Binoculars.Zoom[7].Factor=24.0;
	Binoculars.Zoom[7].TID=System:LoadImage("Textures/Hud/Binocular/binoculars_zoom_24");
	Binoculars.CurrZoom=2;
end

function Binoculars:AntiCheat()
local ang = _localplayer:GetAngles();
if (ang) then
local bin_rnd = random(1,11)-6;
if (bin_rnd == 0) then
	if (random(1,2)==2) then
		bin_rnd = -1;
	else
		bin_rnd = 1;
	end
end
ang.x = ang.x+bin_rnd;
_localplayer:SetAngles(ang);
end
end

-----
function Binoculars:OnShutdown()
-- Clivey Added
--	ang=_localplayer:GetAngles();
--	ang.z=ang.z+3;
--	_localplayer:SetAngles(ang);
--	ang =_localplayer:GetAngles();
--	ang.y=ang.y+3;
--	_localplayer:SetAngles(ang);
---	ang =_localplayer:GetAngles();
--	ang.x=ang.x+3;
--	_localplayer:SetAngles(ang);
--	_localplayer.cnt:ShakeCameraL(0.06, 0.075, 0.06);  --Clivey
-- End of Clivey add

-- Mixer added
Binoculars.AntiCheat(self);
-- END of Mixer add

Binoculars.TID_Background=nil;
Binoculars.TID_Compass=nil;
Binoculars.TID_Equalizer=nil;
Binoculars.ZoomLevelChangeSound=nil;
Binoculars.Zoom=nil;
end

------
function Binoculars:OnActivate()



	-- make sure that the player is in first person mode
	Game:SetThirdPerson(0);

	if (Binoculars.StaticNoise) then
		Sound:SetSoundLoop(Binoculars.StaticNoise, 1);
		Sound:SetSoundVolume(Binoculars.StaticNoise, 25);
		Sound:PlaySound(Binoculars.StaticNoise);
	end
	
	ZoomView.Zoomable = 1;
	
	-- Hack:Only reset zoom data if binoculars deactivated. Else they are active already (after quickload)
	if(Binoculars.IsActive==0) then
		ZoomView.CurrZoomStep = Binoculars.LastZoom;
	else
		ZoomView.CurrZoomStep = self.LastZoomStep;
	end
	
	ZoomView.MaxZoomSteps = 7;
	ZoomView.ZoomSteps={
		Binoculars.Zoom[1].Factor,
		Binoculars.Zoom[2].Factor,
		Binoculars.Zoom[3].Factor,
		Binoculars.Zoom[4].Factor,
		Binoculars.Zoom[5].Factor,
		Binoculars.Zoom[6].Factor,
		Binoculars.Zoom[7].Factor,  
  };
	 	 
	-- Hack:Only reset zoom data if binoculars deactivated. Else they are active already (after quickload)
	if(Binoculars.IsActive==0) then
		Binoculars.LastZoomStep = -1;
		Binoculars.LastChangeTime = 0;
	end
	
	_localplayer.cnt.drawfpweapon=nil;
	ZoomView:Activate("binozoom", nil);
	_localplayer.DisableSway = 1;
	ClientStuff.vlayers:ActivateLayer("MoTrack");
	
	Binoculars.IsActive=1;
end

----
function Binoculars:OnDeactivate()

	local MyPlayer = _localplayer;	
				
	if (Binoculars.StaticNoise) then
		Sound:StopSound(Binoculars.StaticNoise);
	end
	
	Sound:SetDirectionalAttenuation(MyPlayer:GetPos(), MyPlayer:GetAngles(), 0);
	Binoculars.IsActive=0;
	self.outOfScopeTimeB = nil;

	if (_localplayer.makezoomstep) then
		_localplayer.makezoomstep = nil;
		if (Hud.cis_my_dtx) then
			setglobal("e_detail_texture_min_fov",Hud.cis_my_dtx);
		end
	end

-- Clivey Added
--	ang=_localplayer:GetAngles();
--	ang.z=ang.z+3;
--	_localplayer:SetAngles(ang);
--	ang =_localplayer:GetAngles();
--	ang.y=ang.y+3;
--	_localplayer:SetAngles(ang);
--	ang =_localplayer:GetAngles();
--	ang.x=ang.x+3;
--	_localplayer:SetAngles(ang);
--	_localplayer.cnt:ShakeCameraL(0.06, 0.075, 0.06);  --Clivey

-- End of Clivey add

-- Mixer added
if (not MyPlayer.theVehicle) then
Binoculars.AntiCheat(self); end
-- END of Mixer add

	ZoomView:Deactivate();
	MyPlayer.DisableSway = nil;
	ClientStuff.vlayers:DeactivateLayer("MoTrack");
	MyPlayer.cnt.drawfpweapon=1;
	-- Mixer: weapon drawing simulation, after binoculars' use.
	if (MyPlayer.cnt.weapon) and (_localplayer.cnt.weapon.anim_table) and (_localplayer.cnt.weapon.anim_table[_localplayer.weapon_info.FireMode+1].activate) then
		_localplayer.cnt.weapon:StartAnimation(0,_localplayer.cnt.weapon.anim_table[_localplayer.weapon_info.FireMode+1].activate[1],0,0);
	end
end

---
function Binoculars:DrawOverlay()
	-- if we're using the binoculars send an OBSERVE-mood-event
	if (Binoculars.IsActive~=0) then
	Sound:AddMusicMoodEvent("Observe", MM_OBSERVE_TIMEOUT);
	-- Mixer: deactivate if flying/jumping/sprinting
	Sound:SetDirectionalAttenuation(_localplayer:GetPos(), _localplayer:GetAngles(), Game:GetCameraFov());

	if (_localplayer.cnt) then
		if (_localplayer.cnt.moving or _localplayer.cnt.running) and (not _localplayer.theVehicle) and (not _localplayer.cnt.lock_weapon) then
			if (self.outOfScopeTimeB) then
				if (_time > self.outOfScopeTimeB) then
					ClientStuff.vlayers:DeactivateLayer("Binoculars");
				end
			else
				-- schedule time to go out of binocs
			self.outOfScopeTimeB = _time + 0.48;
			end
		elseif (_localplayer.cnt.flying) then
			ClientStuff.vlayers:DeactivateLayer("Binoculars");
			self.outOfScopeTimeB = nil;
		else
			self.outOfScopeTimeB = nil;
		end
	end
	end

	ZoomStep=ZoomView.CurrZoomStep;
	if ( ZoomStep~=Binoculars.LastZoomStep ) then
		local ZoomTxtDetail = {0.55,0.392,0.261,0.196,0.157,0.13,0.065};
		if (ZoomTxtDetail[ZoomStep]) then
			_localplayer.makezoomstep = ZoomTxtDetail[ZoomStep] * 1;
		end
		Sound:PlaySound(Binoculars.ZoomLevelChangeSound);
		Binoculars.LastZoomStep = ZoomStep;
		Binoculars.LastChangeTime = _time;
	end
	if (_localplayer.makezoomstep) and (_localplayer.makezoomstep ~= 0) then
		if (not Hud.cis_my_dtx) then
			Hud.cis_my_dtx = getglobal("e_detail_texture_min_fov");
		end
		if (Hud.cis_my_dtx) and (tonumber(Hud.cis_my_dtx) < 1) then -- don't apply for maps with customised value of e_detail_texture_min_fov
			--setglobal("e_detail_texture_min_fov",_localplayer.makezoomstep);
		end
		_localplayer.makezoomstep = 0;
	end

	local StaticFactor=(_time-Binoculars.LastChangeTime)/0.3;
	if ( StaticFactor<1 ) then
		local v=StaticFactor*2;
		System:DrawImageColorCoords( Binoculars.TID_Transition, 0, 0, 800, 600, 4, 1, 1, 1, 1.0-StaticFactor*StaticFactor, 0, 0.9+v, 1, v );
	end
	local myPlayer=_localplayer;
	local u=(-myPlayer:GetAngles().z+217)/360+0.27;
	local bin_dist = {x=400,y=232};
	Game:SetHUDFont("radiosta", "binozoom");
	-- lets add some random value so the equalizer looks like it would really equalize something :p
	local EqLength=Sound:GetDirectionalAttenuationMaxScale()*0.9+random(0,10)*0.01;

	if (self.old) then
	-- MIXER: OLD BINOCULAR STUFF IS HERE
	System:DrawImage( Binoculars.TID_Background, 400, 0, 400, 600, 4);
	System:DrawImage( Binoculars.TID_Background, 400, 0, -400, 600, 4);
	System:DrawImageColorCoords( Binoculars.TID_Compass, 370, 146, 60, 16, 4, 1, 1, 1, 1, u-0.04, 1, u+0.04, 0 );
	System:DrawImageColorCoords(Hud.white_dot, 374, 303, 52, 1, 4, 0, 0, 0, 0.4, 0, 1, 72, 0);
	System:DrawImage( Binoculars.Zoom[ZoomStep].TID, 34, 210, 20, 180, 4 );
	bin_dist.x = 369; bin_dist.y = 190;
	-- OLD BINOCULAR ENDS
	-- Mixer: OLD EQUALIZER
	System:DrawImageColorCoords(Hud.white_dot, 363, 419, 72, 5, 4, 0.3, 0.3, 0.3, 0.85, 0, 1, 72, 0);
	System:DrawImageColorCoords(Hud.white_dot, 399-((10+EqLength*60)/2), 420, 10+EqLength*60, 3, 4, 0, 0.8, 0, 1, 0, 1, EqLength, 0);
	-- EQUALIZER STUFF ENDS
	else
	-- MIXER: NEW BINOCULAR STUFF
	System:DrawImage( Binoculars.TID_Background, 0, 0, 800, 600, 4);
	System:DrawImageColorCoords( Binoculars.TID_Compass, 401, 185, 60, 16, 4, 1, 1, 1, 1, u-0.04, 1, u+0.04, 0 );
	Game:WriteHudString(50, 292, format( "%02dX",(Binoculars.Zoom[ZoomView.CurrZoomStep].Factor)),  0.0, 1, 0.9, 0.5, 15, 15);
	-- NEW BINOCULAR END
	-- Mixer: NEW EQUALIZER
	System:DrawImageColorCoords(Hud.white_dot, 390, 401, 72, 5, 4, 0, 0, 0, 0.7, 0, 1, 72, 0);
	System:DrawImageColorCoords(Hud.white_dot, 426-((10+EqLength*60)/2), 402, 10+EqLength*60, 3, 4, 0, 0.8, 0, 1, 0, 1, EqLength, 0);
	-- EQUALIZER STUFF ENDS
	end

	--System:DrawImage( Binoculars.TID_Power, 675, 415, 24, 50, 4 );
	--System:DrawImageColorCoords( Binoculars.TID_PowerGauge, 678, 435, 22, 30, 4, 1, 1, 1, 1, 0, 1, 1, 0 );
	--	System:DrawImageColorCoords( Binoculars.TID_PowerGauge, 679, 430, 16, 35, 4, 1, 1, 1, 1, 0, 1, 1, 0 );
	-- Draw distance
	local int_pt=myPlayer.cnt:GetViewIntersection();

	if ( int_pt ) then
		local s=format( "%07.2fm", int_pt.len*1.5);
		Game:WriteHudString(bin_dist.x, bin_dist.y, s, 0.0, 1, 0.9, 0.5, 15, 15);					
	else
		Game:WriteHudString(bin_dist.x, bin_dist.y, "----.--m", 0.0, 1, 0.9, 0.5, 15, 15);
	end
end

-----
-- Restore binoculars data
function Binoculars:OnRestore(pRestoreTbl)
	self.IsActive = pRestoreTbl.IsActive;
	self.ZoomActive = pRestoreTbl.ZoomActive;
	self.LastZoom = pRestoreTbl.LastZoom;
	self.LastZoomStep = pRestoreTbl.LastZoomStep;
	self.LastChangeTime = pRestoreTbl.LastChangeTime;	
	self.CurrZoom = pRestoreTbl.CurrZoom;		
	self.Zoom = pRestoreTbl.Zoom;			
-- Clivey Added
--	ang=_localplayer:GetAngles();
--	ang.z=ang.z+3;
--	_localplayer:SetAngles(ang);
--	ang =_localplayer:GetAngles();
--	ang.y=ang.y+3;
--	_localplayer:SetAngles(ang);
--	ang =_localplayer:GetAngles();
--	ang.x=ang.x+3;
--	_localplayer:SetAngles(ang);
--	_localplayer.cnt:ShakeCameraL(0.06, 0.075, 0.06);  --Clivey
-- End of Clivey add

	-- Mixer added
	Binoculars.AntiCheat(self);
	-- END of Mixer add
	-- make sure motion tracker disabled
	if(ClientStuff and ClientStuff.vlayers) then
		ClientStuff.vlayers:DeactivateLayer("MoTrack");
	end
end
