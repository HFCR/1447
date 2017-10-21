-- Modified: Rocket with ballistic trajectory (Mixer)
Script:LoadScript("scripts/default/entities/weapons/BaseProjectile.lua");
projectileDefinitionSP = {
	Param = {
		mass = 1,
		size = 0.15,
		heading = {},
		flags=1,
		initial_velocity = 37,
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = {x=0,y=0,z=-0.21},
		collider_to_ignore = nil,
		AI_Type = AIOBJECT_ATTRIBUTE,
	},
	
	ExplosionParams = {
		pos = {},
		damage = 400,
		rmin = 1,  --Defines the minimum impulse pressure range
		rmax = 8,  --Defines the maximum impulse pressure range
		radius = 8, --Damage radius where point 0 is max damage. Damage falls off at 1/distance^2
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
		gravity = {x = -44, y = 0.0, z = 2.45},
		rotation = {x = 0.0, y = 0.0, z = 1.8},
		speed = 0.14,
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
	alienmodel="Objects/Weapons/asphere.cgf",
	deform_terrain = 1,
	mark_terrain = 1,
	explodeOnContact = 1,
	dynamic_light = 3,
}

Rocket = CreateProjectile(projectileDefinitionSP);
