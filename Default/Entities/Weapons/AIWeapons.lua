AIWeaponProperties = {

	P99 = {
		VolumeRadius = 7, -- default 13
		fThreat = .5, -- default 1
		fInterest = 0.5,
	},

	walther = {
		VolumeRadius = 50, -- 60=desert
		fThreat = .5, -- default 1
		fInterest = 0.5,
	},

	MP5 = {
		VolumeRadius = 5, -- default 13
		fThreat = .5, -- default 1
		fInterest = 0.5,
	},
	Vector = {
		VolumeRadius = 6, -- default 13
		fThreat = .5, -- default 1
		fInterest = 0.5,
	},

	mp5_k = {
		VolumeRadius = 60, -- default 13
		fThreat = .6, -- default 1
		fInterest = 0.4,
	},

	DUALMP7 = {
		VolumeRadius = 60, -- default 20 --allow for AI hearing too
		fThreat = 0.9, -- default 1
		fInterest = 0.2,	
	},

	Sopmod = {
		VolumeRadius = 15, -- default 13
		fThreat = .5, -- default 1
		fInterest = 0.5,	
	},

	M4 = {
		VolumeRadius = 120, -- default 20 --allow for AI hearing too
		fThreat = 1, -- default 1
		fInterest = 0,	
	},

	Steyr = {
		VolumeRadius = 120, -- default 20 --allow for AI hearing too
		fThreat = 1, -- default 1
		fInterest = 0,	
	},

	M249 = {
		VolumeRadius = 150, -- default 13
		fThreat = 0.8, -- default 1
		fInterest = 0.5,
	},
	
	SniperRifle = {
		VolumeRadius = 300, -- default 13
		fThreat = 1, -- default 1
		fInterest = 0.5,
	},

	OICW = {
		VolumeRadius = 135, -- default 13
		fThreat = 1, -- default 1
		fInterest = 0.5,
	},

	AG36 = {
		VolumeRadius = 135, -- default 13
		fThreat = 0.7, -- default 1
		fInterest = 0.5,
	},

	Barett = {
		VolumeRadius = 300, -- default 13
		fThreat = 1, -- default 1
		fInterest = 0.5,
	},

	Falcon = {
		VolumeRadius = 60, -- default 13
		fThreat = .5, -- default 1
		fInterest = 0.0,
	},

	Glock17 = {
		VolumeRadius = 40, -- default 13
		fThreat = .5, -- default 1
		fInterest = 0.0,
	},

	P90 = {
		VolumeRadius = 60, -- default 13
		fThreat = .5, -- default 1
		fInterest = 0.5,
	},
	
	A2000 = {
		VolumeRadius = 55, -- default 13
		fThreat = .5, -- default 1
		fInterest = 0.5,
	},

	Shotgun = {
		VolumeRadius = 150, -- default 13
		fThreat = 1, -- default 1
		fInterest = 0.5,
	},

	M3 = {
		VolumeRadius = 150, -- default 13
		fThreat = 1, -- default 1
		fInterest = 0.5,
	},

	RL = {
		VolumeRadius = 120, -- default 13
		fThreat = 1, -- default 1
		fInterest = 0.5,
	},

	Shocker = {
		VolumeRadius = 5, -- default 13
		fThreat = 1, -- default 1
		fInterest = 0.5,
	},
	
	Machete = {
		VolumeRadius = 1, -- default 13
		fThreat = 1, -- default 1
		fInterest = 0.5,
	},
	
	MG = {
		VolumeRadius = 150, -- default 13
		fThreat = .8, -- default 1
		fInterest = 0.0,
	},
	
	Mortar = {
		VolumeRadius = 80, -- default 13
		fThreat = .8, -- default 1
		fInterest = 0.0,
	},
	
	MedicTool = {
		VolumeRadius = 2, -- default 13
		fThreat = .2, -- default 1
		fInterest = 0.0,
	},
	
	ScoutTool = {
		VolumeRadius = 2, -- default 13
		fThreat = .2, -- default 1
		fInterest = 0.0,
	},
	
	EngineerTool = {
		VolumeRadius = 20, -- default 13
		fThreat = .5, -- default 1
		fInterest = 0.0,
	},
	
	Wrench = {
		VolumeRadius = 1, -- default 13
		fThreat = 1, -- default 1
		fInterest = 0.5,
	},
	
	-- Don't know if this is necessary, but it should be here and not in COVERRL.lua
	COVERRL = {
		VolumeRadius = 250,
		fThreat = 1,
		fInterest = 0,
	},

	-- vehicle weapon sound events
	VehicleMountedMG = {
		VolumeRadius = 150, -- default 13
		fThreat = 0.8, -- default 1
		fInterest = 0.5,
	},

	VehicleMountedRocketMG = {
		VolumeRadius = 150, -- default 13
		fThreat = 0.8, -- default 1
		fInterest = 0.5,
	},

	VehicleMountedRocket = {
		VolumeRadius = 150, -- default 13
		fThreat = 0.8, -- default 1
		fInterest = 0.5,
	},

	VehicleMountedAutoMG = {
		VolumeRadius = 150, -- default 13
		fThreat = 0.8, -- default 1
		fInterest = 0.5,
	},
		
	----- Grenades and the like -----
	Grenade = {
		VolumeRadius = 200, -- default 250
		fThreat = 1, -- default 1
		fInterest = 0,
	},
	
	GrenadeBounce = {
		VolumeRadius = 50, -- default 250
		fThreat = 1, -- default 1
		fInterest = 0,
	},
	
	HandGrenade = {
		VolumeRadius = 200, -- default 13
		fThreat = 1, -- default 1
		fInterest = 0.0,
	},

	FlashbangGrenade = {
		VolumeRadius = 150, -- default 13
		fThreat = 1, -- default 1
		fInterest = 0.0,
	},

	Rock = {
		VolumeRadius = 50, -- default 13
		fThreat = 0.0, -- default 1
		fInterest = 1.0,
	},

	SmokeGrenade = {
		VolumeRadius = 150, -- default 13
		fThreat = 0.5, -- default 1
		fInterest = 0.0,
	},
}

