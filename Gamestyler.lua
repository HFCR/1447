--Gamestyler CIS edition v1.2 (Garbitos and Mixer)

--Gamestyler Tweakers
Game:CreateVariable("gr_boatstyle",0,"NetSynch");
--Gamestyler Vars
Game:CreateVariable("gr_gamestyle",0,"NetSynch");

GameStyler = {
	playermoves = {
		{ -- 1 hardcore
			move_params={
				speed_run=4.9,
				speed_walk=2.8,
				speed_swim=3.0,
				speed_crouch=1.6,
				speed_prone=0.6,
				
				speed_run_strafe=4.6,
				speed_walk_strafe=2.8,
				speed_swim_strafe=3.0,
				speed_crouch_strafe=1.6,
				speed_prone_strafe=0.6,
				
				speed_run_back=4.3,
				speed_walk_back=2.8,
				speed_swim_back=3.0,
				speed_crouch_back=1.6,
				speed_prone_back=0.6,
				
		lean_angle=14.0,
		bob_pitch=0.0991,
		bob_roll=0.059,
		bob_lenght=5.5,
		bob_weapon=0.0071,
				
				jump_force=4.3,
				jump_run_d=4.5,
				jump_run_h=2.1,
				jump_run_time=0.8,
				jump_walk_d=2.5,
				jump_walk_h=2.0,
				jump_walk_time=0.4,
			},
			DynProp = {
				air_control = 0.9,
				gravity = 9.81,
				jump_gravity = 15.0,
				swimming_gravity = -1.0,
				inertia = 11,
				swimming_inertia = 1.0,
				nod_speed = 50.0,
				min_slide_angle = 46,
				max_climb_angle = 55,
				min_fall_angle = 70,
				max_jump_angle = 50,
			},
			StaminaTable = {
				sprintScale	= 1.3,
				sprintSwimScale = 1.4,
				decoyRun	= 5,
				decoyJump	= 5,
				restoreRun	= 1.75,
				restoreWalk	= 10,
				restoreIdle	= 15,

				breathDecoyUnderwater	= 1,
				breathDecoyAim		= 1,
				breathRestore		= 120,
			},
			fallscale = 0.75, -- it is important to have different fallscale for every gamestyle, because it is used to check / apply gamestyle
			jstyle = 0,
			handStrength = 1.25,
			boatstyle = 1,
			screenAmount = 0.5,
			screenColor = {0.1,0.75,0.1},
			GS_shaderSelect = nil,
			cryVizStyle = 0,
			crazyState = nil,
			name = "@cis_gs_hardcore",
		},
		{ -- 2 extreme
			move_params={
				speed_run=5.5,
				speed_walk=3.65,
				speed_swim=3.6,
				speed_crouch=1.68,
				speed_prone=0.63,
				
				speed_run_strafe=5.2,
				speed_walk_strafe=3.65,
				speed_swim_strafe=3.5,
				speed_crouch_strafe=1.68,
				speed_prone_strafe=0.63,
				
				speed_run_back=4.9,
				speed_walk_back=3.65,
				speed_swim_back=3.5,
				speed_crouch_back=1.68,
				speed_prone_back=0.63,
				
		lean_angle=14.0,
		bob_pitch=0.0991,
		bob_roll=0.059,
		bob_lenght=5.5,
		bob_weapon=0.0071,

				
				jump_force=4.87,
				jump_run_d=4.95,
				jump_run_h=2.415,
				jump_run_time=0.92,
				jump_walk_d=2.75,
				jump_walk_h=2.3,
				jump_walk_time=0.44, 
			},
			DynProp = {
				air_control = 0.95,
				gravity = 9.81,
				jump_gravity = 14,
				swimming_gravity = -1.0,
				inertia = 10.0,
				swimming_inertia = 1.0,
				nod_speed = 50.0,
				min_slide_angle = 51,
				max_climb_angle = 60,
				min_fall_angle = 75,
				max_jump_angle = 65, 
			},
			StaminaTable = {
				sprintScale	= 1.44,
				sprintSwimScale = 1.44,
				decoyRun	= 3.5,
				decoyJump	= 3.5,
				restoreRun	= 2.25,
				restoreWalk	= 12,
				restoreIdle	= 17.5,

				breathDecoyUnderwater	= 1,
				breathDecoyAim		= 1,
				breathRestore		= 120,
			},
			fallscale = 0.5,
			jstyle = 1,
			jsuit = 2,
			jsuitGoogles = 3.5,
			handStrength = 1.5,
			health_regen = 1.1,
			boatstyle = 2,
			screenAmount = 0.5,
			screenColor = {0.8,0.4,0.1},
			GS_shaderSelect = nil,
			cryVizStyle = 1,
			crazyState = nil,
			name = "@cis_gs_extreme",
		},
		{ -- 3 unreal
			move_params={
				speed_run=6,
				speed_walk=3.85,
				speed_swim=4.6,
				speed_crouch=1.76,
				speed_prone=0.66,
				
				speed_run_strafe=5.7,
				speed_walk_strafe=3.85,
				speed_swim_strafe=4.2,
				speed_crouch_strafe=1.76,
				speed_prone_strafe=0.66,
				
				speed_run_back=5.4,
				speed_walk_back=3.85,
				speed_swim_back=4.2,
				speed_crouch_back=1.76,
				speed_prone_back=0.66,
				
		lean_angle=14.0,
		bob_pitch=0.0991,
		bob_roll=0.059,
		bob_lenght=5.5,
		bob_weapon=0.0071,

				
				jump_force=5.16,
				jump_run_d=4.95,
				jump_run_h=2.415,
				jump_run_time=0.92,
				jump_walk_d=2.75,
				jump_walk_h=2.3,
				jump_walk_time=0.44, 
			},
			DynProp = {
				air_control = 0.99,
				gravity = 9.77,
				jump_gravity = 13.95,
				swimming_gravity = -1.0,
				inertia = 9.9,
				swimming_inertia = 0.99,
				nod_speed = 50.0,
				min_slide_angle = 51,
				max_climb_angle = 60,
				min_fall_angle = 75,
				max_jump_angle = 65, 
			},
			StaminaTable = {
				sprintScale	= 1.54,
				sprintSwimScale = 1.54,
				decoyRun	= 1.5,
				decoyJump	= 1.5,
				restoreRun	= 3,
				restoreWalk	= 16,
				restoreIdle	= 25,

				breathDecoyUnderwater	= 1,
				breathDecoyAim		= 1,
				breathRestore		= 120,
			},
			fallscale = 0.25,
			jstyle = 1,
			jsuit = 2,
			jsuitGoogles = 2.5,
			handStrength = 3,
			health_regen = 1.4,
			boatstyle = 2,
			screenAmount = 0.5,
			screenColor = {0.1,0.1,0.75},
			GS_shaderSelect = nil,
			cryVizStyle = 2,
			crazyState = nil,
			name = "@cis_gs_unreal",
		},
		{ -- 4 stunt
			move_params={
				speed_run=6.25,
				speed_walk=4.025,
				speed_swim=5,
				speed_crouch=1.84,
				speed_prone=0.69,
				
				speed_run_strafe=5.95,
				speed_walk_strafe=4.025,
				speed_swim_strafe=4.5,
				speed_crouch_strafe=1.84,
				speed_prone_strafe=0.69,
				
				speed_run_back=5.65,
				speed_walk_back=4.025,
				speed_swim_back=4.5,
				speed_crouch_back=1.84,
				speed_prone_back=0.69,
				
		lean_angle=14.0,
		bob_pitch=0.0991,
		bob_roll=0.059,
		bob_lenght=5.5,
		bob_weapon=0.0071,

				
				jump_force=6.45,
				jump_run_d=5.175,
				jump_run_h=2.73,
				jump_run_time=1.08,
				jump_walk_d=2.875,
				jump_walk_h=2.6,
				jump_walk_time=0.5,
			},
			DynProp = {
				air_control =1.035,
				gravity = 9.72,
				jump_gravity = 13.05,
				swimming_gravity = -1.0,
				inertia = 9.5,
				swimming_inertia = 0.95,
				nod_speed = 50.0,
				min_slide_angle = 59,
				max_climb_angle = 68,
				min_fall_angle = 83,
				max_jump_angle = 73,
			},
			StaminaTable = {
				sprintScale	= 1.61,
				sprintSwimScale = 1.755,
				decoyRun	= 1,
				decoyJump	= 1,
				restoreRun	= 4.5,
				restoreWalk	= 24,
				restoreIdle	= 35,

				breathDecoyUnderwater	= 0.5,
				breathDecoyAim		= 0.5,
				breathRestore		= 240,
			},
			fallscale = 0.1,
			jstyle = 2,
			jsuit = 1,
			handStrength = 5,
			health_regen = 1.7,
			boatstyle = 3,
			screenAmount = 0.5,
			screenColor = {0.1,0.75,0.75},
			GS_shaderSelect = nil,
			cryVizStyle = 3,
			crazyState = nil,
			name = "@cis_gs_stunt",
		},
		{ -- 5 crazy
			move_params={
				speed_run=6.25,
				speed_walk=4.025,
				speed_swim=5.5,
				speed_crouch=1.84,
				speed_prone=0.69,
				
				speed_run_strafe=5.95,
				speed_walk_strafe=4.025,
				speed_swim_strafe=5,
				speed_crouch_strafe=1.84,
				speed_prone_strafe=0.69,
				
				speed_run_back=5.65,
				speed_walk_back=4.025,
				speed_swim_back=5,
				speed_crouch_back=1.84,
				speed_prone_back=0.69,
				
		lean_angle=14.0,
		bob_pitch=0.0991,
		bob_roll=0.059,
		bob_lenght=5.5,
		bob_weapon=0.0071,

				
				jump_force=8.6,
				jump_run_d=5.65,
				jump_run_h=6.3,
				jump_run_time=1.27,
				jump_walk_d=2.875,
				jump_walk_h=3,
				jump_walk_time=0.72,
			},
			DynProp = {
				air_control = 1.125,
				gravity = 6.44,
				jump_gravity = 4.95,
				swimming_gravity = -1.0,
				inertia = 9.3,
				swimming_inertia = 0.93,
				nod_speed = 50.0,
				min_slide_angle = 59,
				max_climb_angle = 68,
				min_fall_angle = 83,
				max_jump_angle = 73,
			},
			StaminaTable = {
				sprintScale	= 1.75,
				sprintSwimScale = 1.82,
				decoyRun	= 0.5,
				decoyJump	= 0.5,
				restoreRun	= 4.5,
				restoreWalk	= 24,
				restoreIdle	= 35,

				breathDecoyUnderwater	= 0.5,
				breathDecoyAim		= 0.5,
				breathRestore		= 240,
			},
			fallscale = 0.001,
			jstyle = 2,
			jsuit = 1,
			handStrength = 10,
			health_regen = 3,
			boatstyle = 3,
			screenAmount = 0.5,
			screenColor = {0.75,0.1,0.75},
			GS_shaderSelect = nil,
			cryVizStyle = 3,
			crazyState = 1,
			name = "@cis_gs_crazy",
		},
	},
	playerpowerups = {
		{ -- 1 speed mode
			move_params={
				speed_run=5.0*1.5,
				speed_walk=3.5*1.5,
				speed_swim=3.0*2,
				speed_crouch=1.6*1.5,
				speed_prone=0.6*1.5,
				
				speed_run_strafe=4.5*1.5,
				speed_walk_strafe=3.5*1.5,
				speed_swim_strafe=3.0*2,
				speed_crouch_strafe=1.6*1.5,
				speed_prone_strafe=0.6*1.5,
				
				speed_run_back=4.5*1.5,
				speed_walk_back=3.5*1.5,
				speed_swim_back=3.0*3,
				speed_crouch_back=1.6*1.5,
				speed_prone_back=0.6*1.5,
				
		lean_angle=14.0,
		bob_pitch=0.0991*1.5,
		bob_roll=0.059*1.5,
		bob_lenght=5.5*1.5,
		bob_weapon=0.0071*1.5,
				
				jump_force=4.3*1.1,
				jump_run_d=4.5*1.25,

				jump_run_h=2.1*1.1,
				jump_run_time=0.8*1.1,
				jump_walk_d=2.5*1.15,

				jump_walk_h=2.0*1.1,
				jump_walk_time=0.4*1.05,
			},
			DynProp = {
				air_control = 0.9*1.05,
				gravity = 9.81,

				jump_gravity = 15.0*0.97,
				swimming_gravity = -1.0,
				inertia = 10.0*0.87,
				swimming_inertia = 1.0*0.87,
				nod_speed = 50.0*1.1,
				min_slide_angle = 51,
				max_climb_angle = 60,
				min_fall_angle = 75,
				max_jump_angle = 65, 
			},
			StaminaTable = {
				sprintScale	= 1.4*1.5,
				sprintSwimScale = 1.4*1.5,
				decoyRun	= 10*0.35,
				decoyJump	= 10*0.35,
				restoreRun	= 1.5*1.15,
				restoreWalk	= 8*1.15,
				restoreIdle	= 10*1.5,

				breathDecoyUnderwater	= 2.0*0.9,
				breathDecoyAim		= 3*0.9,
				breathRestore		= 80*1.25,
			}, 
		},
		{ -- 2 strength mode
			move_params={
				speed_run=5.0*1.05,
				speed_walk=3.5*1.05,
				speed_swim=3.0*1.05,
				speed_crouch=1.6*1.05,
				speed_prone=0.6*1.05,
				
				speed_run_strafe=4.5*1.05,
				speed_walk_strafe=3.5*1.05,
				speed_swim_strafe=3.0*1.05,

				speed_crouch_strafe=1.6*1.05,
				speed_prone_strafe=0.6*1.05,
				
				speed_run_back=4.5*1.05,
				speed_walk_back=3.5*1.05,
				speed_swim_back=3.0*1.05,
				speed_crouch_back=1.6*1.05,
				speed_prone_back=0.6*1.05,
				
		lean_angle=14.0,
		bob_pitch=0.0991*1.05,
		bob_roll=0.059*1.05,
		bob_lenght=5.5*1.05,
		bob_weapon=0.0071*1.05,
				
				jump_force=4.3*2,
				jump_run_d=4.5*1.25,
				jump_run_h=2.1*3,

				jump_run_time=0.8*1.25,
				jump_walk_d=2.5*1.15,
				jump_walk_h=2.0*1.5,
				jump_walk_time=0.4*1.15,

			},
			DynProp = {
				air_control = 0.9*1.05,
				gravity = 9.81*0.98,
				jump_gravity = 15.0*0.87,
				swimming_gravity = -1.0,
				inertia = 10.0*0.95,
				swimming_inertia = 1.0,
				nod_speed = 50.0,
				min_slide_angle = 59,
				max_climb_angle = 68,
				min_fall_angle = 83,
				max_jump_angle = 73,
			},
			StaminaTable = {
				sprintScale	= 1.4*1.05,
				sprintSwimScale = 1.4*1.05,
				decoyRun	= 10*0.35,
				decoyJump	= 10*0.35,
				restoreRun	= 1.5*1.15,
				restoreWalk	= 8*1.15,
				restoreIdle	= 10*1.5,

				breathDecoyUnderwater	= 2.0*0.9,
				breathDecoyAim		= 3*0.9,
				breathRestore		= 80*1.25,
			},
		},
	},
boatmoves = {
		boat = {
			{ --hardcore
				ammoMG = 500,
				ammoRL = 30,
				bDrawDriver = 1, --hardcore cannot shoot and drive
				--bHasRockets = 1,
				damageBulletMP = 1.0, --this is unrealistic damage, if "nil" then realistic damage "fDmgScale" (below) is used
				fDmgScaleBullet = 0.25,
				fDmgScaleAIBullet = 0.1,
				fDmgScaleExplosion = 0.25,
				fDmgScaleAIExplosion = 0.335,
				nDamage = 900,
				fRadius = 10,
				fRadiusMin = 8.0,
				fRadiusMax = 10,
				fImpulsivePressure = 200,
				Speedv	= 175000,
				Turn = 42000,
				Damprot = 50000,
				TiltSpd = 3500,
				fMass = 15000,
				gravity = -9.81,
				StandInAir = 10000, 
				fOnCollideDamage = 0.75,
				fOnCollideGroundDamage = 0.75,
				fOnCollideVehicleDamage = 3.5,
				pushpower = 7000,
				eject = 1,
			},
			{ --extreme
				ammoMG = 500,
				ammoRL = 30,
				bDrawDriver = 0,
				--bHasRockets = 1,
				damageBulletMP = nil,
				fDmgScaleBullet = 0.25,
				fDmgScaleAIBullet = 0.1,
				fDmgScaleExplosion = 0.25,
				fDmgScaleAIExplosion = 0.335,
				nDamage = 650,
				fRadius = 6,
				fRadiusMin = 4,
				fRadiusMax = 6,
				fImpulsivePressure = 150,
				Speedv	= 350000,
				Turn = 52500,
				Damprot = 37500,
				TiltSpd = 6475,
				fMass = 14000,
				gravity = -6.66,
				StandInAir = 6000, 
				fOnCollideDamage = 0.56,
				fOnCollideGroundDamage = 0.56,
				fOnCollideVehicleDamage = 2.62,
				pushpower = 9000,
				eject = 0,
			},
			{ --stunt
				ammoMG = 500,
				ammoRL = 30,
				bDrawDriver = 0,
				--bHasRockets = 1,
				damageBulletMP = nil,
				fDmgScaleBullet = 0.25,
				fDmgScaleAIBullet = 0.1,
				fDmgScaleExplosion = 0.25,
				fDmgScaleAIExplosion = 0.335,
				nDamage = 450,
				fRadius = 4.5,
				fRadiusMin = 3.6,
				fRadiusMax = 4.5,
				fImpulsivePressure = 90,
				Speedv	= 565000,
				Turn = 52500,
				Damprot = 37500,
				TiltSpd = 6475,
				fMass = 13050,
				gravity = -4.2,
				StandInAir = 4000, 
				fOnCollideDamage = 0.56,
				fOnCollideGroundDamage = 0.56,
				fOnCollideVehicleDamage = 2.62,
				pushpower = 14000,
				eject = 0,
			},
		},
		dingy = {
			{ --hardcore
				damageBulletMP = nil,
				fDmgScaleBullet = 0.2,
				fDmgScaleAIBullet = 0.1,
				fDmgScaleExplosion = 0.25,
				fDmgScaleAIExplosion = 0.1,
				nDamage = 100,
				fRadius = 7,
				fRadiusMin = 2.0,
				fRadiusMax = 7,
				fImpulsivePressure = 200,
				Speedv	= 7000,
				Turn = 400,
				Damprot = 1000,
				TiltSpd = 80,
				fMass = 400,
				gravity = -6.66,
				StandInAir = 250, 
				fOnCollideDamage = 0.25,
				fOnCollideGroundDamage = 0.25,
				fOnCollideVehicleDamage = 5,
				pushpower = 500,
			},
			{ --extreme
				damageBulletMP = nil,
				fDmgScaleBullet = 0.2,
				fDmgScaleAIBullet = 0.1,
				fDmgScaleExplosion = 0.25,
				fDmgScaleAIExplosion = 0.1,
				nDamage = 75,
				fRadius = 5,
				fRadiusMin = 2,
				fRadiusMax = 5,
				fImpulsivePressure = 100,
				Speedv	= 17250,
				Turn = 500,
				Damprot = 750,
				TiltSpd = 100,
				fMass = 400,
				gravity = -6.66,
				StandInAir = 250, 
				fOnCollideDamage = 0.1,
				fOnCollideGroundDamage = 0.1,
				fOnCollideVehicleDamage = 2.5,
				pushpower = 650,
			},
			{ --stunt
				damageBulletMP = nil,
				fDmgScaleBullet = 0.2,
				fDmgScaleAIBullet = 0.1,
				fDmgScaleExplosion = 0.25,
				fDmgScaleAIExplosion = 0.1,
				nDamage = 75,
				fRadius = 5,
				fRadiusMin = 2,
				fRadiusMax = 5,
				fImpulsivePressure = 75,
				Speedv	= 17250,
				Turn = 600,
				Damprot = 500,
				TiltSpd = 125,
				fMass = 350,
				gravity = -4.2,
				StandInAir = 160, 
				fOnCollideDamage = 0.062,
				fOnCollideGroundDamage = 0.062,
				fOnCollideVehicleDamage = 1.5,
				pushpower = 750,
			},
		},
	},	
};

function GameStyler:ApplyGameStyle(pl,style,bIsBot)
	if (pl.cnt) and (pl.cnt.speedscale) and (pl.cnt.speedscale < 1) then
		pl.cnt.speedscale = 1;
	end
	if (style > 0) and (GameStyler.playermoves[style]) then
		if (not pl.move_prms_bkup) then
			pl.move_prms_bkup = new(pl.move_params);
		end
		pl.move_params = GameStyler.playermoves[style].move_params;
		pl.cnt:SetMoveParams(pl.move_params);
		if (_localplayer) and (_localplayer.cnt) and (pl ~= _localplayer) and (_localplayer.move_params) then
			_localplayer.cnt:SetMoveParams(pl.move_params);
		end

		if (bIsBot == 0) then
			if (not pl.dynprop_bkup) then
				pl.dynprop_bkup = new(pl.DynProp);
			end
			pl.DynProp = GameStyler.playermoves[style].DynProp;
			pl.cnt:SetDynamicsProperties(pl.DynProp);
		end
		if (not pl.staminatbl_bkup) then
			pl.staminatbl_bkup = new(pl.StaminaTable);
		end
		pl.StaminaTable = GameStyler.playermoves[style].StaminaTable;

		if (Game:IsMultiplayer()) and (toNumberOrZero(getglobal("gr_MpNoFatigue"))>0) then
			local st_copy = new(pl.StaminaTable);
			st_copy.decoyRun=0;
			st_copy.decoyJump=0;
			pl.cnt:InitStaminaTable(st_copy);
		else
			pl.cnt:InitStaminaTable(pl.StaminaTable);
		end

		pl.jstyle = GameStyler.playermoves[style].jstyle * 1;
		pl.resetGravity = pl.DynProp.gravity * 1;
		if (GameStyler.playermoves[style].jsuit) then
			pl.jackSuitMode = GameStyler.playermoves[style].jsuit * 1;
		else
			pl.jackSuitMode = nil;
		end
		if (GameStyler.playermoves[style].jsuitGoogles) then
			pl.jackSuitGoogles = GameStyler.playermoves[style].jsuitGoogles * 1;
		else
			pl.jackSuitGoogles = nil;
		end
		pl.handStrength = GameStyler.playermoves[style].handStrength * 1;
		if (GameStyler.playermoves[style].health_regen) then
			pl.regenerateHealthRate = GameStyler.playermoves[style].health_regen * 1;
		else
			pl.regenerateHealthRate = nil;
		end
		if (bIsBot == 0) then
			if (Game:IsServer()) then setglobal("gr_boatstyle",GameStyler.playermoves[style].boatstyle); end
			pl.screenAmount = GameStyler.playermoves[style].screenAmount;
			pl.screenColor = GameStyler.playermoves[style].screenColor;
			pl.cryVizStyle = GameStyler.playermoves[style].cryVizStyle;
			pl.prev_cryVizStyle = pl.cryVizStyle;
		end
		GameStyler:GS_shaderSelect(pl,GameStyler.playermoves[style].GS_shaderSelect,GameStyler.playermoves[style].crazyState);
		pl.cnt.fallscale = GameStyler.playermoves[style].fallscale * 1;
		pl.gs_fallscale = GameStyler.playermoves[style].fallscale * 1;
	else
		pl.gs_fallscale = nil;
		if (pl.move_prms_bkup) then
			pl.move_params = new(pl.move_prms_bkup);
			pl.cnt:SetMoveParams(pl.move_params);
			if (_localplayer) and (_localplayer.cnt) and (pl ~= _localplayer) and (_localplayer.move_params) then
				_localplayer.cnt:SetMoveParams(pl.move_params);
			end

			pl.move_prms_bkup = nil;
		end
		if (bIsBot == 0) then
			if (pl.dynprop_bkup) then
				pl.DynProp = new(pl.dynprop_bkup);
				pl.cnt:SetDynamicsProperties(pl.DynProp);
				pl.dynprop_bkup = nil;
			end
		end
		if (pl.staminatbl_bkup) then
			pl.StaminaTable = new(pl.staminatbl_bkup);
			if (Game:IsMultiplayer()) and (toNumberOrZero(getglobal("gr_MpNoFatigue"))>0) then
				local st_copy = new(pl.StaminaTable);
				st_copy.decoyRun=0;
				st_copy.decoyJump=0;
				pl.cnt:InitStaminaTable(st_copy);
			else
				pl.cnt:InitStaminaTable(pl.StaminaTable);
			end
			pl.staminatbl_bkup = nil;
		end
		pl.jstyle = nil;
		pl.resetGravity = nil;
		pl.jackSuitMode = nil;
		pl.jackSuitGoogles = nil;
		pl.handStrength = nil;
		pl.regenerateHealthRate = nil;
		if (bIsBot == 0) then
			if (Game:IsServer()) then setglobal("gr_boatstyle",0); end
			pl.screenAmount = 0.5; --!important
			pl.screenColor = {1,1,1}; --White for Hud blur
			pl.cryVizStyle = nil;
			pl.prev_cryVizStyle = nil;
		end
		GameStyler:GS_shaderSelect(pl,nil);
		pl.cnt.fallscale = 1;
	end
	if (pl.cnt) and (pl.cnt.weapon) and (pl.cnt.weapon.PlayerSlowDown) and (WeaponsParams.Falcon.Std[1].promode==nil) then
		pl.cnt.speedscale = pl.cnt.weapon.PlayerSlowDown * 1;
	end
end

function GameStyler:ApplyBoatStyle(bt,style,name)
	if (style > 0) and (GameStyler.boatmoves.boat[style]) then
		if (tostring(name)=="boat") then
			if (not bt.boat_prms_bkup_tbl) then
				bt.boat_prms_bkup_tbl = {
					ammoMG = bt.ammoMG,
					ammoRL = bt.ammoRL,
					bDrawDriver = bt.Properties.bDrawDriver,
					--bHasRockets = bt.Properties.bHasRockets,
					dmgBulletMP = bt.DamageParams.dmgBulletMP,
					fDmgScaleBullet = bt.DamageParams.fDmgScaleBullet,
					fDmgScaleAIBullet = bt.DamageParams.fDmgScaleAIBullet,
					fDmgScaleExplosion = bt.DamageParams.fDmgScaleExplosion,
					fDmgScaleAIExplosion = bt.DamageParams.fDmgScaleAIExplosion,
					nDamage = bt.Properties.ExplosionParams.nDamage,
					fRadiusMax = bt.Properties.ExplosionParams.fRadiusMax,
					fRadiusMin = bt.Properties.ExplosionParams.fRadiusMin,
					fRadius = bt.Properties.ExplosionParams.fRadius,
					fImpulsivePressure = bt.Properties.ExplosionParams.fImpulsivePressure,
					Speedv = bt.boat_params.Speedv,
					Turn = bt.boat_params.Turn,
					Damprot = bt.boat_params.Damprot,
					TiltSpd = bt.boat_params.TiltSpd,
					fMass = bt.boat_params.fMass,
					gravity = bt.boat_params.gravity,
					StandInAir = bt.boat_params.StandInAir,
					fOnCollideDamage = bt.fOnCollideDamage,
					fOnCollideGroundDamage = bt.fOnCollideGroundDamage,
					fOnCollideVehicleDamage = bt.fOnCollideVehicleDamage,
					pushpower = bt.pushpower,
					eject = bt.eject,
				};
			end
			bt.ammoMG = GameStyler.boatmoves.boat[style].ammoMG;
			bt.ammoRL = GameStyler.boatmoves.boat[style].ammoRL;
			bt.Properties.bDrawDriver = GameStyler.boatmoves.boat[style].bDrawDriver;
			--bt.Properties.bHasRockets = GameStyler.boatmoves.boat[style].bHasRockets;
			bt.DamageParams.dmgBulletMP = GameStyler.boatmoves.boat[style].dmgBulletMP;
			bt.DamageParams.fDmgScaleBullet = GameStyler.boatmoves.boat[style].fDmgScaleBullet;
			bt.DamageParams.fDmgScaleAIBullet = GameStyler.boatmoves.boat[style].fDmgScaleAIBullet;
			bt.DamageParams.fDmgScaleExplosion = GameStyler.boatmoves.boat[style].fDmgScaleExplosion;
			bt.DamageParams.fDmgScaleAIExplosion = GameStyler.boatmoves.boat[style].fDmgScaleAIExplosion;
			bt.Properties.ExplosionParams.nDamage = GameStyler.boatmoves.boat[style].nDamage;
			bt.Properties.ExplosionParams.fRadiusMax = GameStyler.boatmoves.boat[style].fRadiusMax;
			bt.Properties.ExplosionParams.fRadiusMin = GameStyler.boatmoves.boat[style].fRadiusMin;
			bt.Properties.ExplosionParams.fRadius = GameStyler.boatmoves.boat[style].fRadius;
			bt.Properties.ExplosionParams.fImpulsivePressure = GameStyler.boatmoves.boat[style].fImpulsivePressure;
			bt.boat_params.Speedv	= GameStyler.boatmoves.boat[style].Speedv;
			bt.boat_params.Turn = GameStyler.boatmoves.boat[style].Turn;
			bt.boat_params.Damprot = GameStyler.boatmoves.boat[style].Damprot;
			bt.boat_params.TiltSpd = GameStyler.boatmoves.boat[style].TiltSpd;
			bt.boat_params.fMass = GameStyler.boatmoves.boat[style].fMass;
			bt.boat_params.gravity = GameStyler.boatmoves.boat[style].gravity;
			bt.boat_params.StandInAir = GameStyler.boatmoves.boat[style].StandInAir;
			bt.fOnCollideDamage = GameStyler.boatmoves.boat[style].fOnCollideDamage;
			bt.fOnCollideGroundDamage = GameStyler.boatmoves.boat[style].fOnCollideGroundDamage;
			bt.fOnCollideVehicleDamage = GameStyler.boatmoves.boat[style].fOnCollideVehicleDamage;
			bt.pushpower = GameStyler.boatmoves.boat[style].pushpower;
			bt.eject = GameStyler.boatmoves.boat[style].eject;
		elseif (tostring(name)=="dingy") then
			if (not bt.dingy_prms_bkup_tbl) then
				bt.dingy_prms_bkup_tbl = {
					dmgBulletMP = bt.DamageParams.dmgBulletMP,
					fDmgScaleBullet = bt.DamageParams.fDmgScaleBullet,
					fDmgScaleAIBullet = bt.DamageParams.fDmgScaleAIBullet,
					fDmgScaleExplosion = bt.DamageParams.fDmgScaleExplosion,
					fDmgScaleAIExplosion = bt.DamageParams.fDmgScaleAIExplosion,
					nDamage = bt.Properties.ExplosionParams.nDamage,
					fRadiusMax = bt.Properties.ExplosionParams.fRadiusMax,
					fRadiusMin = bt.Properties.ExplosionParams.fRadiusMin,
					fRadius = bt.Properties.ExplosionParams.fRadius,
					fImpulsivePressure = bt.Properties.ExplosionParams.fImpulsivePressure,
					Speedv = bt.boat_params.Speedv,
					Turn = bt.boat_params.Turn,
					Damprot = bt.boat_params.Damprot,
					TiltSpd = bt.boat_params.TiltSpd,
					fMass = bt.boat_params.fMass,
					gravity = bt.boat_params.gravity,
					StandInAir = bt.boat_params.StandInAir,
					fOnCollideDamage = bt.fOnCollideDamage,
					fOnCollideGroundDamage = bt.fOnCollideGroundDamage,
					fOnCollideVehicleDamage = bt.fOnCollideVehicleDamage,
					pushpower = bt.pushpower,
				};
			end
			bt.DamageParams.dmgBulletMP = GameStyler.boatmoves.dingy[style].dmgBulletMP;
			bt.DamageParams.fDmgScaleBullet = GameStyler.boatmoves.dingy[style].fDmgScaleBullet;
			bt.DamageParams.fDmgScaleAIBullet = GameStyler.boatmoves.dingy[style].fDmgScaleAIBullet;
			bt.DamageParams.fDmgScaleExplosion = GameStyler.boatmoves.dingy[style].fDmgScaleExplosion;
			bt.DamageParams.fDmgScaleAIExplosion = GameStyler.boatmoves.dingy[style].fDmgScaleAIExplosion;
			bt.Properties.ExplosionParams.nDamage = GameStyler.boatmoves.dingy[style].nDamage;
			bt.Properties.ExplosionParams.fRadiusMax = GameStyler.boatmoves.dingy[style].fRadiusMax;
			bt.Properties.ExplosionParams.fRadiusMin = GameStyler.boatmoves.dingy[style].fRadiusMin;
			bt.Properties.ExplosionParams.fRadius = GameStyler.boatmoves.dingy[style].fRadius;
			bt.Properties.ExplosionParams.fImpulsivePressure = GameStyler.boatmoves.dingy[style].fImpulsivePressure;
			bt.boat_params.Speedv	= GameStyler.boatmoves.dingy[style].Speedv;
			bt.boat_params.Turn = GameStyler.boatmoves.dingy[style].Turn;
			bt.boat_params.Damprot = GameStyler.boatmoves.dingy[style].Damprot;
			bt.boat_params.TiltSpd = GameStyler.boatmoves.dingy[style].TiltSpd;
			bt.boat_params.fMass = GameStyler.boatmoves.dingy[style].fMass;
			bt.boat_params.gravity = GameStyler.boatmoves.dingy[style].gravity;
			bt.boat_params.StandInAir = GameStyler.boatmoves.dingy[style].StandInAir;
			bt.fOnCollideDamage = GameStyler.boatmoves.dingy[style].fOnCollideDamage;
			bt.fOnCollideGroundDamage = GameStyler.boatmoves.dingy[style].fOnCollideGroundDamage;
			bt.fOnCollideVehicleDamage = GameStyler.boatmoves.dingy[style].fOnCollideVehicleDamage;
			bt.pushpower = GameStyler.boatmoves.dingy[style].pushpower;
		end
	else
		if (tostring(name)=="boat") and (bt.boat_prms_bkup_tbl)then
			bt.ammoMG = bt.boat_prms_bkup_tbl.ammoMG;
			bt.ammoRL = bt.boat_prms_bkup_tbl.ammoRL;
			bt.Properties.bDrawDriver = bt.boat_prms_bkup_tbl.bDrawDriver;
			--bt.Properties.bHasRockets = bt.boat_prms_bkup_tbl.bHasRockets;
			bt.DamageParams.dmgBulletMP = bt.boat_prms_bkup_tbl.dmgBulletMP;
			bt.DamageParams.fDmgScaleBullet = bt.boat_prms_bkup_tbl.fDmgScaleBullet;
			bt.DamageParams.fDmgScaleAIBullet = bt.boat_prms_bkup_tbl.fDmgScaleAIBullet;
			bt.DamageParams.fDmgScaleExplosion = bt.boat_prms_bkup_tbl.fDmgScaleExplosion;
			bt.DamageParams.fDmgScaleAIExplosion = bt.boat_prms_bkup_tbl.fDmgScaleAIExplosion;
			bt.Properties.ExplosionParams.nDamage = bt.boat_prms_bkup_tbl.nDamage;
			bt.Properties.ExplosionParams.fRadiusMax = bt.boat_prms_bkup_tbl.fRadiusMax;
			bt.Properties.ExplosionParams.fRadiusMin = bt.boat_prms_bkup_tbl.fRadiusMin;
			bt.Properties.ExplosionParams.fRadius = bt.boat_prms_bkup_tbl.fRadius;
			bt.Properties.ExplosionParams.fImpulsivePressure = bt.boat_prms_bkup_tbl.fImpulsivePressure;
			bt.boat_params.Speedv	= bt.boat_prms_bkup_tbl.Speedv;
			bt.boat_params.Turn = bt.boat_prms_bkup_tbl.Turn;
			bt.boat_params.Damprot = bt.boat_prms_bkup_tbl.Damprot;
			bt.boat_params.TiltSpd = bt.boat_prms_bkup_tbl.TiltSpd;
			bt.boat_params.fMass = bt.boat_prms_bkup_tbl.fMass;
			bt.boat_params.gravity = bt.boat_prms_bkup_tbl.gravity;
			bt.boat_params.StandInAir = bt.boat_prms_bkup_tbl.StandInAir;
			bt.fOnCollideDamage = bt.boat_prms_bkup_tbl.fOnCollideDamage;
			bt.fOnCollideGroundDamage = bt.boat_prms_bkup_tbl.fOnCollideGroundDamage;
			bt.fOnCollideVehicleDamage = bt.boat_prms_bkup_tbl.fOnCollideVehicleDamage;
			bt.pushpower = bt.boat_prms_bkup_tbl.pushpower;
			bt.eject = bt.boat_prms_bkup_tbl.eject;
		elseif (tostring(name)=="dingy") and (bt.dingy_prms_bkup_tbl)then
			bt.DamageParams.dmgBulletMP = bt.dingy_prms_bkup_tbl.dmgBulletMP;
			bt.DamageParams.fDmgScaleBullet = bt.dingy_prms_bkup_tbl.fDmgScaleBullet;
			bt.DamageParams.fDmgScaleAIBullet = bt.dingy_prms_bkup_tbl.fDmgScaleAIBullet;
			bt.DamageParams.fDmgScaleExplosion = bt.dingy_prms_bkup_tbl.fDmgScaleExplosion;
			bt.DamageParams.fDmgScaleAIExplosion = bt.dingy_prms_bkup_tbl.fDmgScaleAIExplosion;
			bt.Properties.ExplosionParams.nDamage = bt.dingy_prms_bkup_tbl.nDamage;
			bt.Properties.ExplosionParams.fRadiusMax = bt.dingy_prms_bkup_tbl.fRadiusMax;
			bt.Properties.ExplosionParams.fRadiusMin = bt.dingy_prms_bkup_tbl.fRadiusMin;
			bt.Properties.ExplosionParams.fRadius = bt.dingy_prms_bkup_tbl.fRadius;
			bt.Properties.ExplosionParams.fImpulsivePressure = bt.dingy_prms_bkup_tbl.fImpulsivePressure;
			bt.boat_params.Speedv	= bt.dingy_prms_bkup_tbl.Speedv;
			bt.boat_params.Turn = bt.dingy_prms_bkup_tbl.Turn;
			bt.boat_params.Damprot = bt.dingy_prms_bkup_tbl.Damprot;
			bt.boat_params.TiltSpd = bt.dingy_prms_bkup_tbl.TiltSpd;
			bt.boat_params.fMass = bt.dingy_prms_bkup_tbl.fMass;
			bt.boat_params.gravity = bt.dingy_prms_bkup_tbl.gravity;
			bt.boat_params.StandInAir = bt.dingy_prms_bkup_tbl.StandInAir;
			bt.fOnCollideDamage = bt.dingy_prms_bkup_tbl.fOnCollideDamage;
			bt.fOnCollideGroundDamage = bt.dingy_prms_bkup_tbl.fOnCollideGroundDamage;
			bt.fOnCollideVehicleDamage = bt.dingy_prms_bkup_tbl.fOnCollideVehicleDamage;
			bt.pushpower = bt.dingy_prms_bkup_tbl.pushpower;
		end
	end
end

function GameStyler:GS_shaderSelect(p_ent,shader,crazy)
	--Get Player/Bot current colors
	if (Game:IsMultiplayer()) then
		local colr=p_ent.cnt:GetColor();
		p_ent.playerColor={colr.x,colr.y,colr.z};
	else
		local colr=tonumber(getglobal("p_color"))+1;
		colr = MultiplayerUtils.ModelColor[colr];
		p_ent.playerColor={colr[1],colr[2],colr[3]};
	end
	--Hud:AddMessage("$1  Player Screen/Gamestyler Colors "..p_ent.screenColor[1].." "..p_ent.screenColor[2].." "..p_ent.screenColor[3]);
	--Hud:AddMessage("$1  Player Shirt/Shader Colors "..p_ent.playerColor[1].." "..p_ent.playerColor[2].." "..p_ent.playerColor[3]);
	--finally enable the persistent CryVision if its requested by gamestyle, also screen blur (localplayer only)
	if (_localplayer) and (p_ent==_localplayer) then 
		Hud:GS_speedBlur(p_ent.screenAmount,p_ent.screenColor[1],p_ent.screenColor[2],p_ent.screenColor[3],0.3,0.2,0.5);
		GameStyler:GS_crazyState(p_ent,crazy,nil);
	end
end

function GameStyler:GS_cryVizStyle(p_ent,key,style,colr,amt,pro)
	local doColor = nil; --color update switch
	if (key and key==0) then doColor = 2; end --do colors only
	if (not style) or (style<0) then style = 2; elseif (pro) and (style<2) then style=2; elseif (style>3) then style = 3; end --fail-safe checks
	if (key and key~=0) then --do shaders, colors if key = 2
		if (p_ent==_localplayer) then
			if (style==0) then -- Night Vision
				--p_ent:SetShader("", 4);
				p_ent:SetSecondShader("TemplBumpGlitter_PS20", 2);
			elseif (style==1) then -- Feral/Extreme Vision
				--p_ent:SetShader("", 4);
				p_ent:SetSecondShader("CharacterInvulnerability_Plasma", 2);
				doColor = key;
			elseif (style==2) then --Holo/Unreal Vision
				p_ent:SetShader( "TemplHologram", 2); 
				p_ent:SetSecondShader( "CharacterInvulnerability_Plasma", 2);	
				doColor = key;
			elseif (style==3) then --Stunt/Crazy Vision
				p_ent:SetShader( "CharacterInvulnerability_Metal", 2);
				p_ent:SetSecondShader( "CharacterInvulnerability_Plasma", 2);
				doColor = key;
			end
		else
			if (style==0) then -- Night Vision
				--p_ent:SetShader("", 0);
				p_ent:SetSecondShader("TemplBumpGlitter_PS20", 0);
			elseif (style==1) then -- Feral/Extreme Vision
				--p_ent:SetShader("", 0);
				p_ent:SetSecondShader("CharacterInvulnerability_Plasma", 0);
				doColor = key;
			elseif (style==2) then --Holo/Unreal Vision
				p_ent:SetShader( "TemplHologram", 0); 
				p_ent:SetSecondShader( "CharacterInvulnerability_Plasma", 0);	
				doColor = key;
			elseif (style==3) then --Stunt/Crazy Vision
				p_ent:SetShader( "CharacterInvulnerability_Metal", 0);
				p_ent:SetSecondShader( "CharacterInvulnerability_Plasma", 0);
				doColor = key;
			end
		end
		--Hud:AddMessage("$5 cry viz shaders "..style);
	end
	if (doColor==2) then
		if (not colr) or (colr==nil) then --color-safe checks and balances
			if (p_ent.playerColor) then --entity has color info already
				colr = p_ent.playerColor;
			elseif (Game:IsMultiplayer()) then --mp colors
				local color=p_ent.cnt:GetColor();
				colr = {color.x,color.y,color.z};
			elseif (p_ent.ai) then --entity is ai and has not received color info
				local rcolr = random(1,getn(MultiplayerUtils.ModelColor));
				colr = MultiplayerUtils.ModelColor[rcolr];
			elseif (_localplayer) and (_localplayer.screenColor) then  --arms get player's color
				colr = _localplayer.screenColor; 
			else
				colr = {0.5,0.1,0.75};  --purple (fail safe)
			end
			p_ent.playerColor = colr;
		end
		if (colr[1]==0) and (colr[2]==0) and (colr[3]==0) then
			--Hud:AddMessage("$3  fixing colors "..colr[1].." "..colr[2].." "..colr[3].." "..amt);
			colr = {0.5,0.5,0.5}; --fail safe color, no pure white/black
		end
		--make sure we have min/max amount of heat (fail safe)
		if (amt>1) then  amt = 0.95; elseif (not amt) or (amt<0.1) then amt = 0.1; end
		if (style==0) then -- Feral/Extreme/Holo/Unreal Vision
			p_ent:SetShaderFloat( "SpecularExp", 64,0,0);
			p_ent:SetShaderFloat( "GlitterStrength", 9,0,0);
			p_ent:SetShaderFloat( "GlitterSize", 18,0,0);
		elseif (style==1) then -- Feral/Extreme/Holo/Unreal Vision
			p_ent:SetShaderFloat( "PlasmaAmount", amt,0,0);
			p_ent:SetShaderFloat( "PlasmaColorR", colr[1]*amt,0,0);
			p_ent:SetShaderFloat( "PlasmaColorG", colr[2]*amt,0,0);
			p_ent:SetShaderFloat( "PlasmaColorB", colr[3]*amt,0,0);
		elseif (style==2) then -- Holo/Unreal Vision
			p_ent:SetShaderFloat( "OverlayAmount", amt,0,0);
			p_ent:SetShaderFloat( "Opacity", amt,0,0);
			p_ent:SetShaderFloat( "PlasmaAmount", amt,0,0);
			p_ent:SetShaderFloat( "PlasmaColorR", colr[1]*amt,0,0);
			p_ent:SetShaderFloat( "PlasmaColorG", colr[2]*amt,0,0);
			p_ent:SetShaderFloat( "PlasmaColorB", colr[3]*amt,0,0);
		elseif (style==3) then --Stunt/Crazy Vision
			p_ent:SetShaderFloat( "MetalAmount", amt+1*0.5,0,0 ); --use "amt" here for jelly-bean corpses
			p_ent:SetShaderFloat( "MetalBumpAmountX", amt,0,0 );
			p_ent:SetShaderFloat( "MetalBumpAmountY", amt,0,0 );
			p_ent:SetShaderFloat("MetalColorR", colr[1]*amt,0,0);
			p_ent:SetShaderFloat("MetalColorG", colr[2]*amt,0,0);
			p_ent:SetShaderFloat("MetalColorB", colr[3]*amt,0,0);
			p_ent:SetShaderFloat( "PlasmaAmount", amt,0,0);
			p_ent:SetShaderFloat( "PlasmaColorR", colr[3]*amt,0,0);
			p_ent:SetShaderFloat( "PlasmaColorG", colr[1]*amt,0,0);
			p_ent:SetShaderFloat( "PlasmaColorB", colr[2]*amt,0,0);
		end
		doColor = nil;
		--Hud:AddMessage("$3  cry viz colors "..colr[1].." "..colr[2].." "..colr[3].." "..amt);
	end
end

-- persistent cryvision effect for CrazyCry
function GameStyler:GS_crazyState(pl,key,style,colr,pro)
	if (not colr) or (colr==nil) or (tostring(colr)=="random") then --color-safe checks and balances
		if (pl.screenColor) then
			colr = pl.screenColor;
		elseif (tostring(colr)=="random") then
			local rcolr = random(1,getn(MultiplayerUtils.ModelColor));
			colr = MultiplayerUtils.ModelColor[rcolr];
		else
			local colr=tonumber(getglobal("p_color"))+1;
			colr = MultiplayerUtils.ModelColor[colr];
		end
	end
	if (colr[1]==0) and (colr[2]==0) and (colr[3]==0) then
		--Hud:AddMessage("$3  fixing colors "..colr[1].." "..colr[2].." "..colr[3].." "..amt);
		colr = {0.5,0.5,0.5}; --fail safe color, no pure white/black
	end
	if (ClientStuff.vlayers:IsActive("HeatVision")) then HeatVision:OnDeactivate(); end
	if (key and key>=2) then key=0; end
	if (key and key==1) then
		pl.cVstate = key;
		ClientStuff.vlayers:ActivateLayer("HeatVision");
		local layer = ClientStuff.vlayers:GetActivateLayer("HeatVision");
		if (layer) then
			layer.EnergyDecreaseRate = nil;
			self.Style = pl.cryVizStyle;
			self.Strict = key;
			layer.Amount = 0.25;
			layer.Red = colr[1];
			layer.Green = colr[2];
			layer.Blue = colr[3];
		end
	elseif (key and key==0) then
		if (pl.Energy>pl.MinRequiredEnergy) then
			pl.cVstate=key;
			if (style) then
				pl.cryVizStyle=style;
			elseif (pl.cryVizStyle) then
				pl.cryVizStyle=pl.cryVizStyle-1; --uses the next lowest style as alternate crazy state
				if (pl.cryVizStyle<0) then pl.cryVizStyle=nil; end
			else
				pl.cryVizStyle=2; --holo/unreal viz
			end
			ClientStuff.vlayers:ActivateLayer("HeatVision");
			local layer = ClientStuff.vlayers:GetActivateLayer("HeatVision");
			if (layer) then
				layer.EnergyDecreaseRate = key+2;
				self.Style = pl.cryVizStyle-1;
				self.Strict = key;
				layer.Amount = pl.screenAmount;
				layer.Red = pl.playerColor[1];
				layer.Green = pl.playerColor[2];
				layer.Blue = pl.playerColor[3];
			end
		end
	else
		pl.cVstate = nil;
		if (ClientStuff.vlayers:IsActive("HeatVision")) then ClientStuff.vlayers:DeactivateLayer("HeatVision"); end
	end
end