Katana = {
	name			= "Katana",
	object		= "Objects/weapons/Katana/Katana_static.cgf",
	character	= "objects/weapons/katana/katana_cb.cgf",
	
	-- factor to slow down the player when he holds that weapon
	PlayerSlowDown = 0.89,	
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("sounds/weapons/machete/machete_pickup.wav",0,120),	-- sound to play when this weapon is selected
	---------------------------------------------------
	NoZoom=1,
	---------------------------------------------------
	-- describes all supported firemodes
	FireParams ={													
	{
		type = 3,			-- used for choosing animation - is a melee weapon 	
		AmmoType="Unlimited",
		HasCrosshair=1,
		reload_time=0.01,
		fire_rate=0.6,
		distance=1.4,
		animatedrun=1,
		damage=60,
		bullet_per_shot=1,
		bullets_per_clip=20,
		FModeActivationTime = 2.0,
		iImpactForceMul = 80,
		iImpactForceMulFinal = 80,
		fire_activation=bor(FireActivation_OnPress),
		FireSounds = {
			"sounds/weapons/machete/fire1.wav",
			"sounds/weapons/machete/fire2.wav",
			"sounds/weapons/machete/fire3.wav",
		},
		
		no_ammo=1,
		SoundMinMaxVol = { 205, 1, 20 },
	},
    },
}

CreateBasicWeapon(Katana);
--[[katana remizZ studios]]--
function Katana.Client:OnActivate(Params)
 BasicWeapon.Client.OnActivate(self,Params);
 if (Params.shooter == _localplayer) then
  self:LoadObject("Objects/weapons/Katana/Katana_static.cgf",2,1);
  self.cap_stuff1 = self:AttachObjectToBone( 2,"Bone05",1 );
 end
end

---------------------------------------------------------------
--ANIMTABLE
------------------
--SINGLE FIRE
Katana.anim_table={}
Katana.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	fidget={
		"fidget11",
		"fidget21",
	},
	run={
		"run1",
		"run2",
	},
	fire={
		"Fire21",
	},
	swim={
		"swim"
	},
	activate={
		"Activate1"
	},
}