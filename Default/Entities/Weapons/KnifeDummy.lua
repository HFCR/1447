-- All changes from FarCry v1.31 code are
-- Copyright (c) 2005 by Greg Parent and Alan Sullivan, All rights Reserved.
-- Use in products other than Obsidian Edge without written permission from
-- the authors is expressly forbidden.

KnifeDummy = {
	name			= "KnifeDummy",
	object		= "objects/weapons/MacheteDumme/machete_bind.cgf",
	character	= "objects/weapons/MacheteDumme/machete.cgf",
	hit_delay=0.11,
	noputdown=1,
	-- factor to slow down the player when he holds that weapon
	PlayerSlowDown = 1.0,	
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("sounds/weapons/machete_fire.mp3",0,255),	-- sound to play when this weapon is selected
	---------------------------------------------------
	NoZoom=1,
	---------------------------------------------------
	-- describes all supported firemodes
	FireParams ={													
	{
		type = 3,			-- used for choosing animation - is a melee weapon 	
		AmmoType="Unlimited",
		reload_time=0.01,
		fire_rate=0.2,
		distance=1.6,
		damage=100,
		bullet_per_shot=1,
		bullets_per_clip=20,
		FModeActivationTime = 3.0,
		iImpactForceMul = 80,
		iImpactForceMulFinal = 80,
		mat_effect="melee_slash",
		fire_activation=bor(FireActivation_OnPress),
		weapon_viewshake = 8, -- 0.6
		weapon_viewshake_amt = 0.02,
		weapon_shaketime = 0.5,
		FireSounds = {
			"sounds/weapons/machete_fire.mp3",
			"sounds/weapons/machete_fire.mp3",
			"sounds/weapons/machete_fire.mp3",
		},
		
		no_ammo=1,
		SoundMinMaxVol = { 205, 3, 20 },
	},
	},
}

CreateBasicWeapon(KnifeDummy);

function KnifeDummy.Server:OnUpdate(delta, shooter)
	
	if (shooter.cnt) and (shooter.cnt.weapon_busy <= 0) then
		shooter.cnt:MakeWeaponAvailable(45,0);
		if (shooter.holster_to_draw_knife) then
			shooter.cnt:SetCurrWeapon(shooter.holster_to_draw_knife);
			shooter.holster_to_draw_knife = nil;
		else
			shooter.cnt:SelectFirstWeapon();
		end
		do return; end
	elseif (self.sv_cold_wpn_contact) and (self.sv_cold_wpn_contact < _time) and (shooter.cnt) then
		-------------------------------
				----
		self.sv_cold_wpn_contact = nil;
		
		local poss = shooter:GetPos();
			if (shooter.cnt.crouching) then
				poss.z = poss.z + 1;
			elseif (shooter.cnt.proning) then
				poss.z = poss.z + 0.4;
			else
				poss.z = poss.z + 1.7;
			end
			local miscparams = {
				pos = poss,
				dir = shooter:GetDirectionVector(),
				shooter = shooter,
				distance = 1.5,
			};
			local hits = Game:GetInstantHit(miscparams); --we throw the ray
			if (not hits) then
				hits = {
					pos = poss,
				};
			end

			shooter.cnt.weapon.cl_hitparams = {
				pos = hits.pos,
				dir = miscparams.dir,
				normal = hits.normal,
				e_fx = "melee_slash",
				shooter = shooter,
				landed = 1,
				impact_force_mul_final=50,
				impact_force_mul=32,
				damage_type="normal",
				play_mat_sound = 1,
				target_material = hits.target_material,
			};
			
		--	if (Game:IsServer()) then

				if (hits) and (hits.objtype) then
					if (hits.target) then
						local hit =	{
							dir = miscparams.dir,
							normal = hits.normal,
							damage = 202,
							target = hits.target,
							shooter = shooter,
							landed = 1,
							ipart=0,
							impact_force_mul_final=50,
							impact_force_mul=32,
							damage_type="normal",
							pos = hits.pos,
							target_material = hits.target_material,
						};
						hits.target:Damage( hit );
						AI:SoundEvent(shooter.id,hits.pos,10,0,1,shooter.id);
						--
						--Server:BroadcastCommand("PLAS "..shtr.id.." "..shtr.id);
						shooter.cnt.weapon.cl_hitparams.target = hits.target;
						shooter.cnt.weapon.cl_hitparams.target_id = hits.target.id;
						--return nil;
					end
					self.cl_cold_wpn_contact = 0;
				end
		--	end
		-----
			-----------------------------
		---------------------------------------
	end
	return BasicWeapon.Server.OnUpdate(self,delta, shooter);
end

function KnifeDummy.Client:OnActivate(Params)
	BasicWeapon.Client.OnActivate(self,Params);
	if (Params.shooter) then
		if (Params.shooter.cnt) and (Params.shooter.cnt.first_person == nil) then
			if (_localplayer) and (Params.shooter~=_localplayer) then
				Params.shooter.stop_my_talk = _time + 0.3;
				Params.shooter:StartAnimation(0,"aidle_umshoot",4);
			end
		else
		weapon_viewshake = 8; -- 0.6
		weapon_viewshake_amt = 0.02;
		weapon_shaketime = 0.5;
			Params.shooter.playingReloadAnimation = 1;
		end
	end
end

function KnifeDummy.Client:OnUpdate(delta, shooter)
	BasicWeapon.Client.OnUpdate(self,delta,shooter);
	if (self.cl_cold_wpn_contact) and (self.cl_cold_wpn_contact < _time) and (self.cl_hitparams) then
		self.cl_cold_wpn_contact=nil;
		--ExecuteMaterial2( self.cl_hitparams ,self.cl_hitparams.e_fx);
		weapon_viewshake = 8; -- 0.6
		weapon_viewshake_amt = 0.02;
		weapon_shaketime = 0.5;
		BasicWeapon.Client.OnHit( self,self.cl_hitparams );
		self.cl_coldfakehit = _time+self.hit_delay;
	elseif (shooter.cnt) and (shooter.cnt.first_person) then
		if (self.cl_coldfakehit) and (self.cl_coldfakehit < _time) then
			self.cl_coldfakehit=nil;
			--BasicWeapon.RandomAnimation(self,"idle",shooter.firemodenum, 0.3);
		end
	end
end

----------------
--ANIMTABLE
------------------
--SINGLE FIRE
KnifeDummy.anim_table={}
KnifeDummy.anim_table[1]={
	idle={
		"Idle11",
	},
	fidget={
	},
	fire={
		"Fire12"
	},
	swim={
		"swim"
	},
	activate={
		"Fire11"
	},
}