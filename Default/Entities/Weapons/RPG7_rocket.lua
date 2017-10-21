Script:LoadScript("scripts/default/entities/weapons/BaseProjectile.lua");
projectileDefinition = {

	LaunchHelper =  "spitfire",

	Param = {
		mass = 1,
		size = 1.00,
		heading = {},
		flags=1,
		--initial_velocity = 75,
		initial_velocity = 55, --  default 23
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = g_Vectors.v000,
		collider_to_ignore = nil,
	},
	
	ExplosionParams = {
		pos = {},
		damage = 600,
		rmin = 2.5,
		rmax = 10.0, -- default 10.5
		radius = 10.0, -- default 10
		DeafnessRadius = 12.0,
		DeafnessTime = 12.0,
		impulsive_pressure = 3000, -- default 5
		shooter = nil,
		weapon = nil,
		explosion = 1,
		rmin_occlusion=0.5,
		occlusion_res=32,
		occlusion_inflate=2,
	},
	
	Old_Smoke = {
		focus = 0,
		gravity = {x = -5, y = 0.0, z = 2.50},
		rotation = {x = 0.0, y = 0.0, z = 2.0},
		speed = 0.2,
		count = 1,
		size = 0.15, 
		size_speed=0.4,
		lifetime=1.50,
		frames=1,
		color_based_blending = 3,
		tid = System:LoadTexture("textures/guncloud.dds"),
		turbulence_size = 2,
		turbulence_speed = 2.5,
	
	},
	
	SmokeEffectEmitter = "other_effects.smokeeffect.RPGrocket",

	EngineSound = {
		name = "Sounds/Weapons/RPG7/RPG7_rocket.wav",
		minDist = 20,
		maxDist = 75,
	},

	--matEffect = "rpg7_explosion",
	mark_terrain = 1,
	deform_terrain = 1,
	explodeOnContact = 1,
}


--RPG7_rocket = CreateProjectile(projectileDefinition);



-------------------------------------------------pvcf added-----------------------------

projectileDefinition = {
	Param = {
		mass = 1,
		size = 0.15,
		heading = {},
		flags=1,
		--initial_velocity = 75,
		initial_velocity = 60, --  default 23
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = g_Vectors.v000,
		collider_to_ignore = nil,
		AI_Type = AIOBJECT_ATTRIBUTE,
	},
	
	ExplosionParams = {
		pos = {},
		damage = 1000,
		rmin = 1,  --Defines the minimum impulse pressure range
		rmax = 5,  --Defines the maximum impulse pressure range
		radius = 5, --Damage radius where point 0 is max damage. Damage falls off at 1/distance^2
		DeafnessRadius = 8.5,
		DeafnessTime = 8.0,
		impulsive_pressure = 2000, -- default 5
		shooter = nil,
		weapon = nil,
		explosion = 1,
		rmin_occlusion=0.2,
		occlusion_res=32,
		occlusion_inflate=2,
	},
	
	SmokeEffect = "Smoke.Rocket.Trail",
	
	_Old_Smoke = {
		focus = 0,
		gravity = {x = -5, y = 0.0, z = 2.50},
		rotation = {x = 0.0, y = 0.0, z = 2.0},
		speed = 0.2,
		count = 1,
		size = 0.15, 
		size_speed=0.4,
		lifetime=1.50,
		frames=1,
		color_based_blending = 3,
		tid = System:LoadTexture("textures/guncloud.dds"),
		turbulence_size = 2,
		turbulence_speed = 2.5,
	},
	
	EngineSound = {
		name = "Sounds/Weapons/RL/rocketloop3.wav",
		minDist = 5,
		maxDist = 100000,
	},

	deform_terrain = 1,
	mark_terrain = 1,
	explodeOnContact = 1,
	dynamic_light = 3,
}

RPG7_rocket = CreateProjectile(projectileDefinition);
--if (Game:IsMultiplayer()) then
--	Rocket = CreateProjectile(projectileDefinitionMP);
--else
--	Rocket = CreateProjectile(projectileDefinitionSP);
--end
