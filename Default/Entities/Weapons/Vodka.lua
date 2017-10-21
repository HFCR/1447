--[[CryTop team scripting]]--
Vodka = {
	name			= "Vodka",
	object		= "objects/weapons/salo/vodka_pickup.cgf",
	character	= "objects/weapons/salo/meat.cgf",
	
	PlayerSlowDown = 1.0,	
		-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	AimMode=1,
	--NoZoom=1,
	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	
	MaxZoomSteps =  1,
	ZoomSteps = { 1.2},
	-- normal crosshair-size
	---------------------------------------------------
	--ActivateSound = Sound.Load3DSound("Sounds/Weapons/Machete/Macheteweapact.wav"),	
	-- sound to play when this weapon is selected
	---------------------------------------------------
	switch_on_empty_ammo = 1,
	---------------------------------------------------
	NoZoom=1,
	
	--special_bone_to_bind = "Bip01 L Hand", --usually the weapon model is attached to "weapon_bone" bone, 
					       --but some weapons should need a different bone, like this one.
					       --if "special_bone_to_bind" doesnt exist "weapon_bone" will be taken.
	
	FireParams ={													
		-- describes all supported firemodes
	{
		--no_reload = 1,--dont play player reload animation
		HasCrosshair=nil,
		type = 5,	
		AmmoType="Vodka",
		food=1,
		--projectile_class="SalaShmat",
		bullets_per_clip=1,
		FModeActivationTime = 2.0,
		fire_activation=bor(FireActivation_OnPress),
		FireSounds = {
			"objects/weapons/salo/vodka_drink.wav",
			--"objects/weapons/salo/vodka_drink.wav",
			},


		no_ammo=1,
		SoundMinMaxVol = { 255, 5, 20 },
		---------------
		fire_mode_type = FireMode_Instant,
		damage_type = "normal",
		aim_improvement=0.2,
		accuracy_decay_on_run=0.8,
		min_accuracy=0.75,
		max_accuracy=0.75,
		reload_time=0.5,
		fire_rate=3,
		tap_fire_rate=3,
		distance=0,
		damage=0,--50 								-- negative damage to heal
		bullet_per_shot=1,
		min_recoil=0.7,
		max_recoil=1.0,
		iImpactForceMul = 25, 
		iImpactForceMulFinal = 40, 	
		iImpactForceMulFinalTorso = 130, 
		hud_icon="single",
		------------------------
	},
	
	},

--	SoundEvents={
		--	animname,	frame,	soundfile
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
--	},

	Recoil = 1,
}

CreateBasicWeapon(Vodka);


--ANIMTABLE
------------------
--SINGLE FIRE
Vodka.anim_table={}
Vodka.anim_table[1]={
	idle={
		"idle",
	},
	fire={
		"fire1",
	},
	activate={
		"activate"
	},
	reload={
		"activate"
	},
}



function Vodka.Server:OnFire( params )
	if (params.shooter) then
		params.shooter.eatfoodtime = _time + params.shooter.fireparams.fire_rate * 0.4;
	end
	return 1;
end

function Vodka.Server:OnActivate(Params)
	if Params.shooter then
		Params.shooter.eatfoodtime = nil;
	end
	return BasicWeapon.Server.OnActivate(self,Params);
end

function Vodka.Client:OnActivate(Params)
	BasicWeapon.Client.OnActivate(self,Params);
	if (Params.shooter == _localplayer) then
		self:LoadObject("Objects/weapons/salo/vodka_hand.cgf",2,1);
		self.cap_stuff1 = self:AttachObjectToBone( 2,"Bone05",1 );
		--self.bw_mf_for_scope = 1;
	end
end

function Vodka.Server:OnUpdate(delta, shooter)	
	if (shooter.cnt.ammo == 0) and (shooter.cnt.ammo_in_clip == 0) then
		shooter.eatfoodtime = nil;
		shooter.cnt:MakeWeaponAvailable(self.classid,0);
		if (BasicPlayer.AddPlayerHands) then
			BasicPlayer.AddPlayerHands(shooter);
		end
		shooter.cnt:SelectFirstWeapon();
	end
	if shooter.eatfoodtime and shooter.eatfoodtime < _time and shooter.cnt.ammo_in_clip > 0 then
		shooter.eatfoodtime = nil;
		local health_up = shooter.cnt.max_health*0.25;
		if shooter.cnt.health + health_up > shooter.cnt.max_health then
			shooter.cnt.health = shooter.cnt.max_health*1;
		else
			shooter.cnt.health = shooter.cnt.health + health_up;
		end
		shooter.cnt.ammo_in_clip = shooter.cnt.ammo_in_clip - 1;
	end
end