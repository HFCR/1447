--[[CryTop team scripting]]--
MaxAmmo = 
{
	Battery=100,
	Pistol=250,
	SMG=540,
	Assault=600,
	Sniper=50,
	Minigun=100,
	Shotgun=120,
	MortarShells=10,
	Grenades=10,
	HandGrenade=8,
	Rock=6,
	FlashbangGrenade=8,
	GlowStick=6,
	SmokeGrenade=8,
	FlareGrenade=8,
	Rocket=30,
	OICWGrenade=10,
	AG36Grenade=10,
	StickyExplosive=5,
	HealthPack=8,
	VehicleMG=500,
	VehicleRocket=20,
	Stamina=9999999,
	Def_Sentry=1,
	Bandage=4,
	Arrows=40,
	X850=9999,
	X850Grenade=10,
	Salo=6,
	Vodka=4,
	Yoghurt=4,
}

--aim_recoil_modifier=mulitplier applied to recoil ... 0 = no recoil, 1 = original recoil, >1 more than original recoil
--min_accuracy=the worst the gun ever gets: 1 = good, 0 = bad, (ending)
--max_accuracy=the best the gun ever gets: 1 = good, 0 = bad, (starting)
--reload_time=
--fire_rate= seconds between rounds (pretty good now)
--distance= distance the shot travels
--damage= units of damage at end of first paratime 
--damage_drop_per_meter=begns at beginning of second paratime,
--bullet_per_shot=1,
--min_recoil= The best it gets 
--max_recoil= The worst it gets 
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

WeaponsParams={
----------------------------------------------------------------------
-- (Pistol/small cannon)
----------------------------------------------------------------------
	Falcon={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement = 0.084,
				aim_recoil_modifier = 0.444,
				accuracy_decay_on_run = 0.5715507,
				min_accuracy = 0.71,
				max_accuracy = 0.93,
				reload_time = 1.62,
				fire_rate = 0.61,
				tap_fire_rate=0.16,
				distance = 90,
				damage = 38, 
				damage_drop_per_meter = .1,
				bullet_per_shot = 1,
				min_recoil = 1.378,
				max_recoil = 1.5,
				iImpactForceMul = 90, 
				iImpactForceMulFinal = 40, 	
				iImpactForceMulFinalTorso = 130, 
				hud_icon = "single",
				accuracy_modifier_prone = 0.3,
				accuracy_modifier_crouch = 0.5,		 
				recoil_modifier_standing = 1.0,
			},

		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
	},
	
	
	
	Steyr={
		--standard weapon params
		Std=
		{
			--AUTOMATIC FIRE----------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.08, --0.04 --0.03 org matto
				aim_recoil_modifier = 0.7, --0.6 --0.7
				accuracy_decay_on_run=0.44, --0.5
				min_accuracy=0.5, --0.65
				max_accuracy=0.9, --0.9
				reload_time=3.93334,
				fire_rate=0.1, --0.08
				distance=300, --200
				damage=38, --40 
				damage_drop_per_meter=.03, --.02
				bullet_per_shot=1,
				min_recoil=0.33, --0.3
				max_recoil=0.7, --0.6
				iImpactForceMul = 40, --25 
				iImpactForceMulFinal = 40, --40	
				iImpactForceMulFinalTorso = 170, --130
				hud_icon="auto",
				accuracy_modifier_prone = 0.5, --0.5
				accuracy_modifier_crouch = 0.7,--0.7	 
			        recoil_modifier_standing = 1.0, --1.0
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				weapon_viewshake = 5.5, --6
				weapon_viewshake_amt = 0.01, --0.01
			},
			{
				ai_mode = 1,
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.03, --0.04
				aim_recoil_modifier = 0.7, --0.6 --0.7
				accuracy_decay_on_run=0.4, --0.5
				min_accuracy=0.6, --0.65
				max_accuracy=0.95, --0.9
				reload_time=3.93334,
				fire_rate=0.11, --0.08
				distance=300, --200
				damage=43, --36 org, for boris it is 42
				damage_drop_per_meter=.03, --.02
				bullet_per_shot=1,
				min_recoil=0.3, --0.3
				max_recoil=0.6, --0.6
				iImpactForceMul = 40, --25 
				iImpactForceMulFinal = 40, --40	
				iImpactForceMulFinalTorso = 170, --130
				hud_icon="auto",
				accuracy_modifier_prone = 0.5, --0.5
				accuracy_modifier_crouch = 0.7,--0.7	 
			        recoil_modifier_standing = 1.0, --1.0
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				weapon_viewshake = 5.5, --6
				weapon_viewshake_amt = 0.01, --0.01
			},




		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp = 
		{
			--AUTOMATIC FIRE----------------------------------------------
			{
				accuracy_modifier_standing = 0.75,
			},
		},
	},
	
	
	Sopmod={
		--standard weapon params
		Std=
		{
			--AUTOMATIC FIRE----------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.03,
				aim_recoil_modifier = 0.6,
				accuracy_decay_on_run=0.5,
				min_accuracy=0.65,
				max_accuracy=0.93,
				reload_time=2.3,
				fire_rate=0.08,
				distance=250,
				damage=37, 
				damage_drop_per_meter=.02,
				bullet_per_shot=1,
				min_recoil=0.3,
				max_recoil=0.6,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 40,	
				iImpactForceMulFinalTorso = 130, 
				hud_icon="auto",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
			        recoil_modifier_standing = 1.0,
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				--weapon_viewshake = 2,
				--weapon_viewshake_amt = 0.01,
			},
			--SINGLE SHOT-------------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.03,
				aim_recoil_modifier = 0.5,
				accuracy_decay_on_run=0.6,
				min_accuracy=0.8,
				max_accuracy=0.97,
				reload_time=2.3,
				fire_rate=0.15,
				distance=250,
				damage=39, 
				damage_drop_per_meter=.03,
				bullet_per_shot=1,
				min_recoil=0.3,
				max_recoil=0.6,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 40, 
				iImpactForceMulFinalTorso = 130, 
				hud_icon="single",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
			        recoil_modifier_standing = 1.0,
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp = 
		{
			--AUTOMATIC FIRE----------------------------------------------
			{
				accuracy_modifier_standing = 0.75,
			},
			--SINGLE SHOT-------------------------------------------------
			{
				accuracy_modifier_standing = 0.75,
			},
		},
	},
	-----DE GOLD BY CRYTOP MEDIA (JUST TEXTURE WITH SHADER)-----

	AK74={
		Std=
		{
			--AUTOMATIC FIRE----------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.04,
				aim_recoil_modifier = 0.6,
				accuracy_decay_on_run=0.5,
				min_accuracy=0.65,
				max_accuracy=0.95,
				reload_time=2.3,
				fire_rate=0.08,
				distance=200,
				damage=55,
				damage_drop_per_meter=.02,
				bullet_per_shot=1,
				min_recoil=0.3,
				max_recoil=0.6,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 40,	
				iImpactForceMulFinalTorso = 130, 
				hud_icon="auto",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
			        recoil_modifier_standing = 1.0,
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				fBendRadius = 2.3,	-- range is 0-50
				fBendForce = 1,		-- range is 0-1
			},
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.05,
				aim_recoil_modifier = 0.5,
				accuracy_decay_on_run=0.8,
				min_accuracy=0.8,
				max_accuracy=0.96,
				reload_time=2.3,
				fire_rate=0.2,
				distance=200,
				damage=63, 
				damage_drop_per_meter=.04,	
				bullet_per_shot=1,
				min_recoil=0.25,
				max_recoil=0.7, 
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 15, 
				iImpactForceMulFinalTorso = 75, 
				hud_icon="single",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
			        recoil_modifier_standing = 1.0,
		        },
		},
	},
	
	M1911={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement = 0.03,
				aim_recoil_modifier = 0.5,
				accuracy_decay_on_run = 0.8,
				min_accuracy = 0.83,
				max_accuracy = 0.92,
				reload_time = 1.62,
				fire_rate = 0.3,
				tap_fire_rate=0.1,
				distance = 60,
				damage = 43, 
				damage_drop_per_meter = .1,
				bullet_per_shot = 1,
				min_recoil = 1.0,
				max_recoil = 1.5,
				iImpactForceMul = 60, 
				iImpactForceMulFinal = 45, 	
				iImpactForceMulFinalTorso = 45, 
				hud_icon = "single",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
				recoil_modifier_standing = 1.0,
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=
		{
			{
				accuracy_modifier_standing = 0.75,
				tap_fire_rate=0.1,
			},
		},
	},
----------------------------------------------------------------------
	Vector={
		Std=
		{
		--AUTOMATIC FIRE----------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.05,
				aim_recoil_modifier = 0.6,
				accuracy_decay_on_run=0.5,
				min_accuracy=0.6,
				max_accuracy=0.92,
				reload_time=2.5,
				fire_rate=0.07058823529, --realistic
				distance=157,
				damage=40, 
				damage_drop_per_meter=.01,
				bullet_per_shot=1,
				min_recoil=0.06,
				max_recoil=0.083,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 15, 	
				iImpactForceMulFinalTorso = 75,
				hud_icon="auto",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
			        recoil_modifier_standing = 1.0,
			        
			        --view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
			},
		--Single FIRE----------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.05,
				aim_recoil_modifier = 0.6,
				accuracy_decay_on_run=0.5,
				min_accuracy=0.6,
				max_accuracy=0.92,
				reload_time=2.5,
				fire_rate=0.08,
				aim_offset={x=0.17,y=0.28,z=0.05},
				tap_fire_rate=0.08,
				distance=250,
				damage=43, 
				damage_drop_per_meter=.008,
				bullet_per_shot=1,
				min_recoil=0.04,
				max_recoil=0.04,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 15, 	
				iImpactForceMulFinalTorso = 75,
				hud_icon="single",
				accuracy_modifier_prone = 0.4,
				accuracy_modifier_crouch = 0.6,		 
			        recoil_modifier_standing = 1.0,
			        
			        --view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
			},

		},
	},
	
	
	-- DUALMP7={
		-- Std=
		-- {
			-- --AUTOMATIC FIRE----------------------------------------------
			-- {
				-- fire_mode_type = FireMode_Instant,
				-- damage_type = "normal",
				-- accuracy_decay_on_run=0.4,
				-- min_accuracy=0.65,
				-- max_accuracy=0.85,
				-- reload_time=4.3334,
				-- fire_rate=0.05,
				-- distance=100,
				-- damage=30, 
				-- damage_drop_per_meter=.02,
				-- bullet_per_shot=2,
				-- min_recoil=0.4,
				-- max_recoil=0.9,
				-- iImpactForceMul = 25, 
				-- iImpactForceMulFinal = 15, 	
				-- iImpactForceMulFinalTorso = 75, 
				-- hud_icon="auto",
				-- accuracy_modifier_prone = 0.5,
				-- accuracy_modifier_crouch = 0.7,		 
			        -- recoil_modifier_standing = 1.0,
				
				-- --view shaking: weapon_viewshake is the frequency of the shake, 
				-- --		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				-- weapon_viewshake = 5,
				-- weapon_viewshake_amt = 0.01,
			-- },
		-- },
		
		-- --In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		-- Mp=
		-- {
			-- --AUTOMATIC FIRE----------------------------------------------
			-- {	
				-- distance=75,
				-- damage=27, 	
				-- accuracy_modifier_standing = 0.75,
			-- },
		-- },	
	-- },
	
	
	P99={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				allow_hold_breath = 1,
				aim_improvement = 0.3,
				aim_recoil_modifier = 0.5,
				accuracy_decay_on_run = 0.8,
				min_accuracy = 0.82,
				max_accuracy = 0.90,
				reload_time = 2.5,
				fire_rate = 0.5,
				tap_fire_rate=0.2,
				distance = 100,
				damage = 36, 
				damage_drop_per_meter = .1,
				bullet_per_shot = 1,
				min_recoil = 0.5,
				max_recoil = 0.8,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 15, 	
				iImpactForceMulFinalTorso = 75, 
				hud_icon = "single",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
				recoil_modifier_standing = 1.0,
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=
		{
			{
				accuracy_modifier_standing = 0.75,
			},
		},
	},

	Hands={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Melee,
				damage_type = "normal",
				min_accuracy=1,
				max_accuracy=1.4,
				reload_time=0.13,
				fire_rate=0.20,
				distance=1.1,
				damage=18,
				min_recoil=0.1,
				max_recoil=0.4,
				no_ammo=1,
				mat_effect="melee_punch",
				iImpactForceMul = 29, 
				iImpactForceMulFinal = 27, 	
				iImpactForceMulFinalTorso = 80, 
			},
		},
	},
----------------------------------------------------------------------
--Glock17 (Pistol/small cannon) (By Matto and Vok.ani)
----------------------------------------------------------------------
	Glock17={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.03,
				aim_recoil_modifier = 0.2,
				accuracy_decay_on_run=0.5,
				min_accuracy=0.80,
				max_accuracy=0.85,
				reload_time=2.3,
				fire_rate=0.12,
				distance=115,
				damage=31,
				damage_drop_per_meter=.02,
				bullet_per_shot=1,
				min_recoil=0.131,
				max_recoil=0.311,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 40,	
				iImpactForceMulFinalTorso = 130, 
				hud_icon="auto",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
			        recoil_modifier_standing = 1.0,
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=
		{
			{
				accuracy_modifier_standing = 0.75,
			},
		},
	},
----------------------------------------------------------------------
--M4 (Assault rifle)
----------------------------------------------------------------------
	M4={
		--standard weapon params
		Std=
		{
			--AUTOMATIC FIRE----------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.12,
				aim_recoil_modifier = 0.65,
				accuracy_decay_on_run=0.5,
				min_accuracy=0.5,
				max_accuracy=0.81,
				reload_time=2.3,
				fire_rate=0.08,
				distance=244,
				damage=38, 
				damage_drop_per_meter=.02,
				bullet_per_shot=1,
				min_recoil=0.3,
				max_recoil=0.6,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 40,	
				iImpactForceMulFinalTorso = 130, 
				hud_icon="auto",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.64,		 
				recoil_modifier_standing = 1.17,
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				weapon_viewshake = 5.0,
				weapon_viewshake_amt = 0.01,
			},
			--SINGLE SHOT-------------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.127,
				aim_recoil_modifier = 0.5,
				accuracy_decay_on_run=0.6,
				min_accuracy=0.6,
				max_accuracy=0.84,
				reload_time=2.3,
				fire_rate=0.275,
				distance=260,
				damage=41, 
				damage_drop_per_meter=.03,
				bullet_per_shot=1,
				min_recoil=0.7,
				max_recoil=1.3,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 40, 
				iImpactForceMulFinalTorso = 130, 
				hud_icon="single",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
			        recoil_modifier_standing = 1.4,
			},
			
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
	},

----------------------------------------------------------------------
--AG36 (Assault rifle with grenade launcher)
----------------------------------------------------------------------
	AG36={
		Std=
		{
			--AUTOMATIC FIRE----------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.06,
				aim_recoil_modifier = 0.6,
				accuracy_decay_on_run=0.7,
				min_accuracy=0.44,
				max_accuracy=1,
				reload_time=2.6,
				fire_rate=0.07,
				distance=280,
				damage=45, 
				damage_drop_per_meter=.01,
				bullet_per_shot=1,
				min_recoil=0.3,
				max_recoil=0.9,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 40, 
				iImpactForceMulFinalTorso = 130, 
				hud_icon="auto",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
			        recoil_modifier_standing = 1.0,
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				weapon_viewshake = 6.5,
				weapon_viewshake_amt = 0.01,
			},
			--GRENADE-----------------------------------------------------
			{
				fire_mode_type = FireMode_Projectile,
				damage_type = "normal",
				reload_time=2.4,
				fire_rate=1.0,
				bullet_per_shot=1,
				hud_icon="grenade",
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=
		{
--AUTOMATIC FIRE----------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.07,
				accuracy_decay_on_run=0.5,
				min_accuracy=0.62,
				max_accuracy=0.95,
				reload_time=2.5,
				fire_rate=0.075,
				distance=350,
				damage=46.61140140001, 
				damage_drop_per_meter=.05,
				bullet_per_shot=1,
				aim_recoil_modifier = 0.6,
				min_recoil=0.3,
				max_recoil=0.8,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 40, 
				iImpactForceMulFinalTorso = 130, 
				hud_icon="auto",
				accuracy_modifier_prone = 0.6,
				accuracy_modifier_crouch = 0.65,		 
			        recoil_modifier_standing = 1.0,
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				weapon_viewshake = 6.5,
				weapon_viewshake_amt = 0.01,
				accuracy_modifier_standing = 0.75,
			},
			--GRENADE-----------------------------------------------------
			{
				fire_mode_type = FireMode_Projectile,
				damage_type = "normal",
				reload_time=2.5,
				fire_rate=1.0,
				bullet_per_shot=1,
				hud_icon="grenade",
				min_recoil=0.7,
				max_recoil=1,

			},
		},
	},
----------------------------------------------------------------------
--OICW (Assault rifle with 20mm secondary fire)
----------------------------------------------------------------------
	OICW={
		Std=
		{
			--AUTOMATIC FIRE----------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.06,	
				aim_recoil_modifier = 0.6,
				accuracy_decay_on_run=0.35,
				min_accuracy=0.5,
				max_accuracy=0.95,
				reload_time=2.4,
				fire_rate=0.08,
				distance=350,
				damage=47, 
				damage_drop_per_meter=.03,
				bullet_per_shot=1,
				min_recoil=0.2,
				max_recoil=0.3,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 40, 
				iImpactForceMulFinalTorso = 130, 
				hud_icon="auto",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
			        recoil_modifier_standing = 1.0,
				
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				weapon_viewshake = 6.0,
				weapon_viewshake_amt = 0.01,
			},
			--grenade (not 20MM)-----------------------------------------------------
			{
				fire_mode_type = FireMode_Projectile,
				damage_type = "normal",
				accuracy_decay_on_run=0.8,
				min_accuracy=0.65,
				max_accuracy=0.99,
				reload_time=2.5,
				fire_rate=0.8,
				distance=120,
				damage=130, 
				damage_drop_per_meter=.06,	
				bullet_per_shot=1,
				min_recoil=0.5,
				max_recoil=1.2,
				hud_icon="grenade",
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		 Mp = 
		 {
-- --AUTOMATIC FIRE----------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.068,	
				accuracy_decay_on_run=0.35,
				min_accuracy=0.6,
				max_accuracy=0.95,
				reload_time=2.5,
				fire_rate=0.08,
				distance=380,
				damage=43, 
				damage_drop_per_meter=.03,
				bullet_per_shot=1,
				aim_recoil_modifier = 0.6,
				min_recoil=0.2,
				max_recoil=0.6,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 40, 
				iImpactForceMulFinalTorso = 130, 
				hud_icon="auto",
				accuracy_modifier_prone = 0.53,
				accuracy_modifier_crouch = 0.65,		 
			        recoil_modifier_standing = 1.0,
				
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				weapon_viewshake = 7.0,
				weapon_viewshake_amt = 0.01,
				accuracy_modifier_standing = 0.75,
			},
			--grenade (not 20MM)-----------------------------------------------------
			{
				bullets_per_clip=2,

				fire_mode_type = FireMode_Projectile,
				damage_type = "normal",
				min_accuracy=0.20,
				max_accuracy=0.25,
				reload_time=2.5,
				fire_rate=1,
				distance=70,
				damage=130, 
				damage_drop_per_meter=.2,
				bullet_per_shot=1,
				min_recoil=10,
				max_recoil=10,
				hud_icon="grenade",


			},
		},
	},

----------------------------------------------------------------------
--MP5 (Sub machine gun)
----------------------------------------------------------------------
	MP5={
		
		--standard weapon params
		Std=
		{
		--AUTOMATIC FIRE----------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.05,
				aim_recoil_modifier = 0.6,
				accuracy_decay_on_run=0.5,
				min_accuracy=0.67,
				max_accuracy=0.91073,
				reload_time=2.5,
				fire_rate=0.1,
				distance=150,
				damage=24, 
				damage_drop_per_meter=.01,
				bullet_per_shot=1,
				min_recoil=0.3,
				max_recoil=0.8,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 15, 	
				iImpactForceMulFinalTorso = 75,
				hud_icon="auto",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
			        recoil_modifier_standing = 1.0,
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				--weapon_viewshake = 2,
				--weapon_viewshake_amt = 0.01,
			},
			--SINGLE SHOT-------------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.05,
				aim_recoil_modifier = 0.5,
				accuracy_decay_on_run=0.8,
				min_accuracy=0.8,
				max_accuracy=0.95,
				reload_time=2.3,
				fire_rate=0.2,
				distance=210,
				damage=18, 
				damage_drop_per_meter=.04,	
				bullet_per_shot=1,
				min_recoil=0.25,
				max_recoil=0.7, 
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 15, 
				iImpactForceMulFinalTorso = 75, 
				hud_icon="single",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
			        recoil_modifier_standing = 1.0,
			},
		},
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
	},
	
----------------------------------------------------------------------
	A2000={
		
		--standard weapon params
		Std=
		{
		--AUTOMATIC FIRE----------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.05,
				aim_recoil_modifier = 0.6,
				accuracy_decay_on_run=0.5,
				min_accuracy=0.7,
				max_accuracy=0.88,
				reload_time=2.53,
				fire_rate=0.08,
				distance=150,
				damage=31, 
				damage_drop_per_meter=.01,
				bullet_per_shot=1,
				min_recoil=0.5,
				max_recoil=0.8,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 15, 	
				iImpactForceMulFinalTorso = 75,
				hud_icon="auto",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
			        recoil_modifier_standing = 1.0,
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				--weapon_viewshake = 2,
				--weapon_viewshake_amt = 0.01,
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=
		{
		--AUTOMATIC FIRE----------------------------------------------
			{	
				damage=31,	
				accuracy_modifier_standing = 0.75,
			},
		},
	},
--P90 (Sub machine gun)
----------------------------------------------------------------------
	P90={
		Std=
		{
			--AUTOMATIC FIRE----------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.054,
				aim_recoil_modifier = 0.52,
				accuracy_decay_on_run=0.3,
				min_accuracy=0.5,
				max_accuracy=0.9,
				reload_time=2.3,
				fire_rate=0.06,
				distance=131.7156,
				damage=27, 
				damage_drop_per_meter=.02,
				bullet_per_shot=1,
				min_recoil=0.30,
				max_recoil=0.53,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 30, 	
				iImpactForceMulFinalTorso = 100, 
				hud_icon="auto",
				accuracy_modifier_prone = 0.6,
				accuracy_modifier_crouch = 0.71,		 
			        recoil_modifier_standing = 1.0,
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				weapon_viewshake = 5,
				weapon_viewshake_amt = 0.01,
			},
		},
	},



----------------------------------------------------------------------
--SniperRifle (Sniper rifle/camping device)
----------------------------------------------------------------------
	SniperRifle={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				allow_hold_breath = 1,
				damage_type = "normal",
				aim_improvement=0.9,
				aim_recoil_modifier = 0.5,
				accuracy_decay_on_run=0.4,
				min_accuracy=0.70,
				max_accuracy=0.75,
				reload_time=2.83,
				fire_rate=1.25,
				distance=1000,
				damage=350, 
				damage_drop_per_meter=.03,
				bullet_per_shot=1,
				min_recoil=2.3,
				max_recoil=2.4,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 15, 	
				iImpactForceMulFinalTorso = 300, 
				hud_icon="single",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
			        recoil_modifier_standing = 1.0,
			},
			--AI SINGLE FIRE-------------------------------------------------
			{
				ai_mode = 1,
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.9,
				aim_recoil_modifier = 0.5,
				accuracy_decay_on_run=0.1,
				min_accuracy=0.8,
				max_accuracy=0.99,
				reload_time=2.83,
				fire_rate=2.5,
				distance=1000,
				damage=300, 
				damage_drop_per_meter=.03,
				bullet_per_shot=1,
				min_recoil=5.6,
				max_recoil=5.8,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 15, 	
				iImpactForceMulFinalTorso = 300, 
				hud_icon="single",
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=
		{
			--SINGLE FIRE----------------------------------------------
			{	
				accuracy_modifier_standing = 0.75,
			},
		},	
	},

	
	ShotgunDB={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.04,
				aim_recoil_modifier = 0.5, --0.5
				accuracy_decay_on_run=1,
				min_accuracy=0.70,
				max_accuracy=0.78,
				reload_time=1.333,
				fire_rate=1.333,
				distance=1000, --90
				damage=75, --14 --17 org matto
				damage_drop_per_meter=0.3, --0.3
				bullet_per_shot=17, --14
				min_recoil=4, --3.5
				max_recoil=4.4, --3.5
				iImpactForceMul = 16, 
				iImpactForceMulFinal = 16, 	
				iImpactForceMulFinalTorso = 24,
				hud_icon="auto",
				mat_effect="pancor_bullet_hit",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
			        recoil_modifier_standing = 1.0,
			},
		},	
	},
	
	ShotgunDBN={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.04,
				aim_recoil_modifier = 0.5, --0.5
				accuracy_decay_on_run=1,
				min_accuracy=0.750,
				max_accuracy=0.88,
				reload_time=1.333,
				fire_rate=1.333,
				distance=3000, --90
				damage=85, --14 --17 org matto
				damage_drop_per_meter=0.3, --0.3
				bullet_per_shot=17, --14
				min_recoil=4, --3.5
				max_recoil=4.3, --3.5
				iImpactForceMul = 16, 
				iImpactForceMulFinal = 16, 	
				iImpactForceMulFinalTorso = 24,
				hud_icon="auto",
				mat_effect="pancor_bullet_hit",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
			        recoil_modifier_standing = 1.0,
			},
		},	
	},
	
----------------------------------------------------------------------
--Shotgun (Semi automatic shotgun)
----------------------------------------------------------------------
	Shotgun={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.1,
				aim_recoil_modifier = 0.5,
				accuracy_decay_on_run=1,
				min_accuracy=0.65,
				max_accuracy=0.65,
				reload_time=3,
				fire_rate=0.35,
				distance=90,
				damage=14,
				damage_drop_per_meter=.3,
				bullet_per_shot=14,
				min_recoil=3,
				max_recoil=3,
				iImpactForceMul = 16, 
				iImpactForceMulFinal = 16, 	
				iImpactForceMulFinalTorso = 24, 
				hud_icon="auto",
				mat_effect="pancor_bullet_hit",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
			        recoil_modifier_standing = 1.0,
			        
			        --view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				weapon_viewshake = 5.0,
				weapon_viewshake_amt = 0.02,
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=
		{
			--SINGLE FIRE----------------------------------------------
			{	
				min_accuracy=0.7,
				max_accuracy=0.7,
				accuracy_modifier_standing = 0.75,
			},
		},	
	},
----------------------------------------------------------------------
--M3 Shotgun (Damn fucking cool shotgun! If you read this, message me over ICQ: 123661266)
----------------------------------------------------------------------
	M3={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.04,
				aim_recoil_modifier = 0.5, --0.5
				accuracy_decay_on_run=1,
				min_accuracy=0.70,
				max_accuracy=0.70,
				reload_time=1.333,
				fire_rate=1.333,
				distance=90, --90
				damage=30, --14 --17 org matto
				damage_drop_per_meter=0.3, --0.3
				bullet_per_shot=17, --14
				min_recoil=5, --3.5
				max_recoil=5, --3.5
				iImpactForceMul = 16, 
				iImpactForceMulFinal = 16, 	
				iImpactForceMulFinalTorso = 24,
				hud_icon="auto",
				mat_effect="pancor_bullet_hit",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
			        recoil_modifier_standing = 1.0,
				aim_offset={x=0.17111,y=0,z=-0.02},
			        
			        --view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
			--	weapon_viewshake = 2, --5 --4.5 stringed evil.. to hard and long
			--	weapon_viewshake_amt = 0.02,
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=
		{
			--SINGLE FIRE----------------------------------------------
			{	
				min_accuracy=0.7,
				max_accuracy=0.7,
				accuracy_modifier_standing = 0.87,
			},
		},	
	},

----------------------------------------------------------------------
--M249 (Heavy machine gun)
----------------------------------------------------------------------
	M249={
		Std=
		{
			--AUTOMATIC FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.04,
				aim_recoil_modifier = 0.9,
				accuracy_decay_on_run=0.8,
				min_accuracy=0.4,
				max_accuracy=0.84,
				reload_time=4,
				fire_rate=0.087,
				distance=290,
				damage=66, 
				damage_drop_per_meter=.1,
				bullet_per_shot=1,
				min_recoil=0.2,
				max_recoil=0.7,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 30, 
				iImpactForceMulFinalTorso = 100, 
				hud_icon="auto",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
				recoil_modifier_standing = 0.8,
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				weapon_viewshake = 7.0,
				weapon_viewshake_amt = 0.01,
			},
			
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
	},
----------------------------------------------------------------------
--Shocker (Purse weapon/women's self defence weapon)
----------------------------------------------------------------------
	Shocker={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Melee,
				damage_type = "normal",
				min_accuracy=1,
				max_accuracy=1,
				reload_time=0.1,
				fire_rate=0.1,
				distance=2.2,
				damage=15,
				--damage_drop_per_meter [doesn't apply]
				min_recoil=0,
				max_recoil=0,
				no_ammo=1,
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=nil,
	},
----------------------------------------------------------------------
--Machete (Bucher weapon)
----------------------------------------------------------------------
	Machete={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Melee,
				damage_type = "normal",
				shoot_underwater = 1,
				min_accuracy=1,
				max_accuracy=1,
				reload_time=0.1,
				fire_rate=0.43,
				distance=1.6,
				damage=88,
				--damage_drop_per_meter [doesn't apply]
				min_recoil=0,
				max_recoil=0,
				no_ammo=1,
				mat_effect="melee_slash",
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=nil,
	},
	
	Katana={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Melee,
				damage_type = "normal",
				shoot_underwater = 1,
				min_accuracy=0.61,
				max_accuracy=1,
				reload_time=0.1,
				fire_rate=0.6,
				distance=1.84401,
				damage=140,
				--damage_drop_per_meter [doesn't apply]
				min_recoil=0.4,
				max_recoil=0.4,
				no_ammo=1,
				mat_effect="melee_slash",
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=nil,
	},
----------------------------------------------------------------------

----------------------------------------------------------------------
	RL={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Projectile,
				damage_type = "normal",
				--accuracy [doesn't apply]
				reload_time=44,
				fire_rate=0.43,
				--distance [doesn't apply]
				--damage [doesn't apply]
				--damage_drop_per_meter [doesn't apply]
				--min_recoil [doesn't apply]
				--max_recoil [doesn't apply]
				hud_icon="rocket",
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=
		{
			{
				bullets_per_clip=1,
			},
		},
	},
----------------------------------------------------------------------
--COVERRL (Rocket Launcher used by AI)
----------------------------------------------------------------------
	COVERRL={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Projectile,
				damage_type = "normal",
				--accuracy [doesn't apply]
				reload_time=0.3,
				fire_rate=1.0,
				--distance [doesn't apply]
				--damage [doesn't apply]
				--damage_drop_per_meter [doesn't apply]
				--min_recoil [doesn't apply]
				--max_recoil [doesn't apply]
				--hud_icon="rocket",
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=nil,
	},
----------------------------------------------------------------------
--MG (Mounted Machine Gun)
----------------------------------------------------------------------
	MG={
		Std=
		{
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.3,
				aim_recoil_modifier = 0.5,
				--accuracy_decay_on_run=0.8,
				min_accuracy=0.85,
				max_accuracy=0.95,
				--reload_time=2.3,
				fire_rate=0.042,
				distance=140,
				damage=50, 
				damage_drop_per_meter=.2,
				bullet_per_shot=1,
				min_recoil=0.2,
				max_recoil=0.3,
	      		iImpactForceMul = 25, -- 5 bullets divided by 10
				iImpactForceMulFinal = 40, 	
				iImpactForceMulFinalTorso = 130, 
				hud_icon="auto",
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				weapon_viewshake = 10.0,
				weapon_viewshake_amt = 0.01,
			--
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=
		{
			--AUTOMATIC FIRE----------------------------------------------
			{	
				damage=65, 	
			},
		},
	},
-- MC1 Mobile Chaingun

----------------------------------------------------------------------
--Mortar (Mounted Grenade Launcher)
----------------------------------------------------------------------
	Mortar={
		Std=
		{
			{
				fire_mode_type = FireMode_Projectile,
				damage_type = "normal",
				--accuracy_decay_on_run=0.8,
				min_accuracy=0.75,
				max_accuracy=0.95,
				--reload_time=2.3,
				fire_rate=4,
				distance=70,
				damage=3000, 
				damage_drop_per_meter=.2,
				bullet_per_shot=1,
				min_recoil=0,
				max_recoil=0,
				hud_icon="rocket",
			--
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=nil
	},
----------------------------------------------------------------------
--Mutant Shotgun (used by Mutant Big)
----------------------------------------------------------------------
	MutantShotgun={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.1,
				aim_recoil_modifier = 0.5,
				accuracy_decay_on_run=0,
				min_accuracy=0.8,
				max_accuracy=0.8,
				reload_time=0.3,
				fire_rate=2,
				distance=180,
				damage=50,
				damage_drop_per_meter=0.2,
				bullet_per_shot=4,
				min_recoil=0.1,
				max_recoil=0.15,
				iImpactForceMul = 300, 
				iImpactForceMulFinal = 300, 	
				iImpactForceMulFinalTorso = 300, 
				hud_icon="single",
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=nil,
	},

	
----------------------------------------------------------------------
--Engineer Tool
----------------------------------------------------------------------
	EngineerTool={
		Std=
		{
			--BUILDING -------------------------------------------------
			{
				fire_mode_type = FireMode_Melee,
				damage_type = "building",
				min_accuracy=1,
				max_accuracy=1,
				reload_time=0.1,
				fire_rate=0.6,
				distance=1.6,		-- used to detect work range
				damage=160,
				min_recoil=0,
				max_recoil=0,
				no_ammo=1,
				mat_effect="building",
			},
		},

		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=
		{
			--BUILDING -------------------------------------------------
			{
				fire_mode_type = FireMode_Melee,
				damage_type = "building",
				min_accuracy=1,
				max_accuracy=1,
				reload_time=0.1,
				fire_rate=0.6,
				distance=1.6,		-- used to detect work range
				damage=160,
				min_recoil=0,
				max_recoil=0,
				no_ammo=1,
				mat_effect="building",
			},
			--SWING WRENCH-------------------------------------------------
			{
				fire_mode_type = FireMode_Melee,
				damage_type = "building",
				min_accuracy=1,
				max_accuracy=1,
				reload_time=0.1,
				fire_rate=0.6,
				distance=1.6,		-- used to detect work range
				damage=160,
				min_recoil=0,
				max_recoil=0,
				no_ammo=1,
				mat_effect="building",
			},
		},
	},
----------------------------------------------------------------------
--Medic Tool
----------------------------------------------------------------------
	MedicTool={
		Std=
		{
			--DISTANCE-------------------------------------------------
			{
				fire_mode_type = FireMode_Projectile,
				damage_type = "normal",
				aim_improvement=0.2,
				accuracy_decay_on_run=0.8,
				min_accuracy=0.75,
				max_accuracy=0.75,
				reload_time=0.5,
				fire_rate=0.5,
				distance=160,
				damage=-75,--50 								-- negative damage to heal
				bullet_per_shot=1,
				min_recoil=0.7,
				max_recoil=1.0,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 40, 	
				iImpactForceMulFinalTorso = 130, 
				hud_icon="single",
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=nil,
	},
---------------------------------------------------------------------
-- Wrench = Engineer Tool in melee attack
----------------------------------------------------------------------
	Wrench={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Melee,
				damage_type = "normal",
				min_accuracy=1,
				max_accuracy=1,
				reload_time=0.1,
				fire_rate=1.0,		-- less than Machete
				distance=1.6,
				damage=50,			-- more than Machete
				--damage_drop_per_meter [doesn't apply]
				min_recoil=0,
				max_recoil=0,
				no_ammo=1,
				mat_effect="melee_slash",
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=nil,
	},
----------------------------------------------------------------------
--ScoutTool
----------------------------------------------------------------------
	ScoutTool={
		Std=
		{
			--place sticky explosive-----------------------------------------------------
			{
				fire_mode_type = FireMode_Projectile,
				damage_type = "normal",
				accuracy_decay_on_run=0.8,
				min_accuracy=0.65,
				max_accuracy=0.99,
				reload_time=0.5,
				fire_rate=0.5,
				distance=120,
				damage=800, 
				damage_drop_per_meter=.06,	
				bullet_per_shot=1,
				min_recoil=0.5,
				max_recoil=1.2,
				hud_icon="grenade",
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=nil,
	},
----------------------------------------------------------------------
--VehicleMountedMG (Mounted Machine Gun on vehicle)
----------------------------------------------------------------------
	VehicleMountedMG={
		Std=
		{
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				auto_aiming_dist = 0,
				aim_improvement=0.3,
				aim_recoil_modifier = 0.5,
				--accuracy_decay_on_run=0.8,
				min_accuracy=0.85,
				max_accuracy=0.95,
				--reload_time=2.3,
				fire_rate=0.082,
				distance=140,
				damage=50, 
				damage_drop_per_meter=.2,
				bullet_per_shot=1,
				min_recoil=0.0,
				max_recoil=0.0,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 40, 	
				iImpactForceMulFinalTorso = 130, 
				hud_icon="auto",
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				weapon_viewshake = 5.0,
				weapon_viewshake_amt = 0.01,
			--
			},
			{
				fire_mode_type = FireMode_Projectile,
				damage_type = "normal",
				--accuracy [doesn't apply]
				reload_time=0.01,
				fire_rate=3,
				--distance [doesn't apply]
				--damage [doesn't apply]
				--damage_drop_per_meter [doesn't apply]
				--min_recoil [doesn't apply]
				--max_recoil [doesn't apply]
				hud_icon="rocket",
			},
			-- special AI firemode follows
			{
				ai_mode = 1,
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				auto_aiming_dist = 0,
				aim_improvement=0.3,
				aim_recoil_modifier = 0.5,
				--accuracy_decay_on_run=0.8,
				min_accuracy=0.85,
				max_accuracy=0.95,
				--reload_time=2.3,
				fire_rate=0.082,
				distance=140,
				damage=50, 
				damage_drop_per_meter=.2,
				bullet_per_shot=1,
				min_recoil=0.0,
				max_recoil=0.0,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 40, 	
				iImpactForceMulFinalTorso = 130, 
				hud_icon="auto",
			--
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=
		{
			--AUTOMATIC FIRE----------------------------------------------
			{	
				damage=65, 	
			},
		},
	},
----------------------------------------------------------------------
--VehicleMountedAutoMG (Mounted Machine Gun on vehicle with auto aiming)
----------------------------------------------------------------------
	VehicleMountedAutoMG={
		Std=
		{
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				auto_aiming_dist = 25,--filippo: before was 50
				aim_improvement=0.3,
				aim_recoil_modifier = 0.5,
				--accuracy_decay_on_run=0.8,
				min_accuracy=0.85,
				max_accuracy=0.95,
				--reload_time=2.3,
				fire_rate=0.082,
				distance=140,
				damage=50, 
				damage_drop_per_meter=.2,
				bullet_per_shot=1,
				min_recoil=0.0,
				max_recoil=0.0,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 40, 	
				iImpactForceMulFinalTorso = 130, 
				hud_icon="auto",
							
				--filippo, its the autoaim reticule sprite, if this is not present will be used the classic square reticule.
				autoaim_sprite=System:LoadImage("Textures/hud/crosshair/roundcross.dds"),
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				weapon_viewshake = 5.0,
				weapon_viewshake_amt = 0.01,
			},
			-- special AI firemode follows
			{
				ai_mode = 1,
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				auto_aiming_dist = 25,--filippo: before was 50
				aim_improvement=0.3,
				aim_recoil_modifier = 0.5,
				--accuracy_decay_on_run=0.8,
				min_accuracy=0.85,
				max_accuracy=0.95,
				--reload_time=2.3,
				fire_rate=0.082,
				distance=140,
				damage=50, 
				damage_drop_per_meter=.2,
				bullet_per_shot=1,
				min_recoil=0.0,
				max_recoil=0.0,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 40, 	
				iImpactForceMulFinalTorso = 130, 
				hud_icon="auto",
							
				--filippo, its the autoaim reticule sprite, if this is not present will be used the classic square reticule.
				autoaim_sprite=System:LoadImage("Textures/hud/crosshair/roundcross.dds"),
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=
		{
			--AUTOMATIC FIRE----------------------------------------------
			{	
				damage=65, 	
			},
		},
	},
----------------------------------------------------------------------
--VehicleMountedRocketMG (Mounted Machine Gun with a RocketLauncher firemode on vehicle)
----------------------------------------------------------------------
	VehicleMountedRocketMG={
		Std=
		{
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				auto_aiming_dist = 25,--filippo: before was 50
				aim_improvement=0.3,
				aim_recoil_modifier = 0.5,
				--accuracy_decay_on_run=0.8,
				min_accuracy=0.85,
				max_accuracy=0.95,
				--reload_time=2.3,
				fire_rate=0.082,
				distance=140,
				damage=50, 
				damage_drop_per_meter=.2,
				bullet_per_shot=1,
				min_recoil=0.0,
				max_recoil=0.0,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 40, 
				iImpactForceMulFinalTorso = 130, 
				hud_icon="auto",
				
				--filippo, its the autoaim reticule sprite, if this is not present will be used the classic square reticule.
				autoaim_sprite=System:LoadImage("Textures/hud/crosshair/roundcross.dds"),
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				weapon_viewshake = 5.0,
				weapon_viewshake_amt = 0.01,
			--
			},
			{
				fire_mode_type = FireMode_Projectile,
				damage_type = "normal",
				--accuracy [doesn't apply]
				reload_time=0.01,
				fire_rate=3,
				--distance [doesn't apply]
				--damage [doesn't apply]
				--damage_drop_per_meter [doesn't apply]
				--min_recoil [doesn't apply]
				--max_recoil [doesn't apply]
				hud_icon="rocket",
			},
			-- special AI firemode follows
			{
				ai_mode = 1,
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				auto_aiming_dist = 25,--filippo: before was 50
				aim_improvement=0.3,
				aim_recoil_modifier = 0.5,
				--accuracy_decay_on_run=0.8,
				min_accuracy=0.85,
				max_accuracy=0.95,
				--reload_time=2.3,
				fire_rate=0.082,
				distance=140,
				damage=50, 
				damage_drop_per_meter=.2,
				bullet_per_shot=1,
				min_recoil=0.0,
				max_recoil=0.0,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 40, 
				iImpactForceMulFinalTorso = 130, 
				hud_icon="auto",
				
				--filippo, its the autoaim reticule sprite, if this is not present will be used the classic square reticule.
				autoaim_sprite=System:LoadImage("Textures/hud/crosshair/roundcross.dds"),
			--
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=
		{
			--AUTOMATIC FIRE----------------------------------------------
			{	
				damage=65, 	
			},
		},
	},
	M79={
		--SINGLE FIRE-------------------------------------------------
		{
			fire_mode_type = FireMode_Projectile,
			damage_type = "normal",
			--accuracy [desn't apply]
			reload_time=3.5,
			fire_rate=1.0,
			-- distance [desn't apply]
			-- damage [desn't apply]
			-- damage_drop_per_meter [doesn't apply]
			bullet_per_shot=1,
			-- min_recoil [doesn't apply]
			-- max_recoil [doesn't apply]
			aim_offset={x=0.25,y=0,z=-0.0171},
			hud_icon="grenade",
		},
	},
----------------------------------------------------------------------
--VehicleMountedRocket (Mounted dumb fire rockets on vehicle)
----------------------------------------------------------------------
	VehicleMountedRocket={
		Std=
		{
			{
				fire_mode_type = FireMode_Projectile,
				damage_type = "normal",
				--accuracy [doesn't apply]
				reload_time=0.01,
				fire_rate=3,
				--distance [doesn't apply]
				--damage [doesn't apply]
				--damage_drop_per_meter [doesn't apply]
				--min_recoil [doesn't apply]
				--max_recoil [doesn't apply]
				hud_icon="rocket",
			},
			-- special AI firemode follows
			{
				ai_mode = 1,
				fire_mode_type = FireMode_Projectile,
				damage_type = "normal",
				--accuracy [doesn't apply]
				reload_time=2,
				fire_rate=3,
				--distance [doesn't apply]
				--damage [doesn't apply]
				--damage_drop_per_meter [doesn't apply]
				--min_recoil [doesn't apply]
				--max_recoil [doesn't apply]
				hud_icon="rocket",
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=nil,
	},
----------------------------------------------------------------------
--PLATINUMGOLD RPG7 rocketlauncher
----------------------------------------------------------------------
	
	RPG7={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Projectile,
				damage_type = "normal",
				aim_improvement = 0.03,
				aim_recoil_modifier = 0.5,
				accuracy_decay_on_run = 0.8,
				min_accuracy = 0.75,
				max_accuracy = 0.90,
				reload_time = 4.00,
				fire_rate = 3.00,
				--tap_fire_rate=0.2,
				distance = 2000,
				damage = 100, 
				damage_drop_per_meter = .1,
				bullet_per_shot = 1,
				min_recoil = 5.0,
				max_recoil = 7.0,
				--iImpactForceMul = 100, 
				--iImpactForceMulFinal = 40, 	
				--iImpactForceMulFinalTorso = 130, 
				hud_icon="rocket",
				--accuracy_modifier_prone = 1.0,
				--accuracy_modifier_crouch = 1.0,		 
				--recoil_modifier_standing = 1.0,
			        aim_offset={x=0.15,y=0,z=-0.0271},
			},

		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=nil,
	},
----------------------------------------------------------------------
--Meat (Meat _pvcfmod
----------------------------------------------------------------------
	Meat={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement = 0.03,
				aim_recoil_modifier = 0.5,
				accuracy_decay_on_run = 0.8,
				min_accuracy = 0.75,
				max_accuracy = 0.90,
				reload_time = 1.62,
				fire_rate = 0.5,
				tap_fire_rate=0.2,
				distance = 1,
				damage = -70, 
				damage_drop_per_meter = .1,
				bullet_per_shot = 1,
				min_recoil = 1.0,
				max_recoil = 2.0,
				iImpactForceMul = 100, 
				iImpactForceMulFinal = 40, 	
				iImpactForceMulFinalTorso = 130, 
				hud_icon = "single",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
				recoil_modifier_standing = 1.0,
			},

		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=
		{
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement = 0.04,
				aim_recoil_modifier = 0.5,
				accuracy_decay_on_run = 0.8,
				min_accuracy = 0.7,
				max_accuracy = 0.90,
				reload_time = 1.62,
				fire_rate = 0.5,
				tap_fire_rate=0.2,
				distance = 70,
				damage = 73, 
				damage_drop_per_meter = .10,
				bullet_per_shot = 1,
				min_recoil = 1.0,
				max_recoil = 2.0,
				iImpactForceMul = 100, 
				iImpactForceMulFinal = 40, 	
				iImpactForceMulFinalTorso = 130, 
				hud_icon = "single",
				accuracy_modifier_prone = 0.65,
				accuracy_modifier_crouch = 0.7,		 
				recoil_modifier_standing = 1.0,
				accuracy_modifier_standing = 0.75,
			},
		},
	
	},

	-- Colt={
		-- Std=
		-- {
			-- --SINGLE FIRE-------------------------------------------------
			-- {
				-- fire_mode_type = FireMode_Instant,
				-- damage_type = "normal",
				-- aim_improvement = 0.03,
				-- aim_recoil_modifier = 0.5,
				-- accuracy_decay_on_run = 0.8,
				-- min_accuracy = 0.75,
				-- max_accuracy = 0.90,
				-- reload_time = 1.62,
				-- fire_rate = 0.5,
				-- tap_fire_rate=0.1,
				-- distance = 60,
				-- damage = 70, 
				-- damage_drop_per_meter = .1,
				-- bullet_per_shot = 1,
				-- min_recoil = 1.0,
				-- max_recoil = 1.3,
				-- iImpactForceMul = 100, 
				-- iImpactForceMulFinal = 40, 	
				-- iImpactForceMulFinalTorso = 130, 
				-- hud_icon = "single",
				-- accuracy_modifier_prone = 0.5,
				-- accuracy_modifier_crouch = 0.7,		 
				-- recoil_modifier_standing = 0.7,
			-- },
		-- },
		
		-- --In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		-- Mp=
		-- {
			-- {
				-- accuracy_modifier_standing = 0.75,
				-- tap_fire_rate=0.1,
			-- },
		-- },
	-- },
	
----------------------------------------------------------------------
-- Special 'invisible' weapon for mutant big
----------------------------------------------------------------------
	MutantMG={
		Std=
		{
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.02,
				aim_recoil_modifier = 0.8,
				accuracy_decay_on_run=0.7,
				min_accuracy=0.75,
				max_accuracy=0.85,
				reload_time=4,
				fire_rate=0.08,
				distance=280,
				damage=60, 
				damage_drop_per_meter=.1,
				bullet_per_shot=1,
				min_recoil=0.2,
				max_recoil=0.3,
				iImpactForceMul = 25, 
				iImpactForceMulFinal = 30, 
				iImpactForceMulFinalTorso = 100, 
				hud_icon="auto",
				accuracy_modifier_prone = 0.5,
				accuracy_modifier_crouch = 0.7,		 
	      		recoil_modifier_standing = 1.0,
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				weapon_viewshake = 8.0,
				weapon_viewshake_amt = 0.01,
			},
		},
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp=nil,
	},
----------------------------------------------------------------------
--FAMAS (FPDC Addon) animations by PlatinumGold, model by LoneWolf
----------------------------------------------------------------------
	FAMAS={
		--standard weapon params
		Std=
		{
			--AUTOMATIC FIRE----------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.04,
				aim_recoil_modifier = 0.8,
				accuracy_decay_on_run=0.3,
				min_accuracy=0.6,
				max_accuracy=0.9,
				reload_time=2.3,
				fire_rate=0.083,
				distance=250,
				damage=50, 
				damage_drop_per_meter=.02,
				bullet_per_shot=1,
				min_recoil=0.2,
				max_recoil=0.5,
				iImpactForceMul = 50,		
				iImpactForceMulFinal = 80,
				iImpactForceMulFinalTorso = 230,
				hud_icon="auto",
				accuracy_modifier_prone = 0.25,	
				accuracy_modifier_crouch = 0.4,	
			        recoil_modifier_standing = 0.9,
				
				--view shaking: weapon_viewshake is the frequency of the shake, 
				--		weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*0.001)
				weapon_viewshake = 6.0,
				weapon_viewshake_amt = 0.01,
			},
			--BURST FIREMODE-------------------------------------------------
			{
				fire_mode_type = FireMode_Instant,
				damage_type = "normal",
				aim_improvement=0.03,
				aim_recoil_modifier = 0.6,
				accuracy_decay_on_run=0.3,
				min_accuracy=0.7,
				max_accuracy=0.9,
				reload_time=2.3,
				fire_rate=0.4,
				distance=250,
				damage=50, 
				damage_drop_per_meter=.03,
				bullet_per_shot=3,
				ammo_per_shot=3,
				min_recoil=0.3,
				max_recoil=0.6,
				iImpactForceMul = 50, 			
				iImpactForceMulFinal = 80, 		
				iImpactForceMulFinalTorso = 230, 	
				hud_icon="single",
				accuracy_modifier_prone = 0.25,		
				accuracy_modifier_crouch = 0.4,		
			        recoil_modifier_standing = 0.9,		
			},
		},
		
		--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
		Mp = 
		{
			--AUTOMATIC FIRE----------------------------------------------
			{
				accuracy_modifier_standing = 0.75,
			},
			--SINGLE SHOT-------------------------------------------------
			{
				accuracy_modifier_standing = 0.75,
			},
		},
	},

--[[----------------------------------.....UPDATING.....-------------------------------------]]

}

//pleasure