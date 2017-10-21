-- MORE REALISTIC MACHETE (IMPROVED BY MIXER)
Machete = {
	name			= "Machete",
	object		= "objects/weapons/machete/machete_bind.cgf",
	character	= "objects/weapons/machete_mod/machete.cgf",
	PlayerSlowDown = 1.0,
	ActivateSound = Sound:LoadSound("sounds/weapons/machete/machete_pickup.wav",0,120),

	hit_delay=0.2,
	FireParams ={													
	{
		type = 3,
		AmmoType="Unlimited",
		reload_time=0.01,
		fire_rate=0.3,
		distance=1.4,
		damage=20,
		animatedrun=1,
		bullet_per_shot=1,
		bullets_per_clip=1,
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

CreateBasicWeapon(Machete);


--SINGLE FIRE
Machete.anim_table={}
Machete.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	fidget={
		"fidget11",
		"fidget21",
	},
	fire={
		"Fire11",
		"Fire21",
		"Fire12",
	},
	run={
		"run1",
		"run2",
	},

	swim={
		"swim"
	},
	activate={
		"Activate1"
	},
}

function Machete.Client:OnEnhanceHUD(scale, bHit)
	_localplayer.cnt.weapon:SetFirstPersonWeaponPos({x=0.0,y=0.13,z=0.01}, g_Vectors.v000);
	---- x=0.18,y=-0.21,z=-0.04
end

function Machete.Client:OnHit(hit)
	if hit.clpredictedhit then
		if (Game:IsServer()==nil) and (hit.shooter.handStrength) then
			hit.impact_force_mul = hit.impact_force_mul*hit.shooter.handStrength;
			hit.impact_force_mul_final = hit.impact_force_mul_final*hit.shooter.handStrength;
			hit.impact_force_mul_final_torso = hit.impact_force_mul+hit.impact_force_mul_final;
			hit.damage = hit.damage*(hit.shooter.handStrength*0.25);
		end
		if hit.shooter then
			hit.shooter.pckanm_do = _time+self.hit_delay;
		end
		return BasicWeapon.Client.OnHit(self,hit);
	else
		hit.damage = 0;
		hit.damage_type = "building";
		if hit.targetStat then
			hit.shooter.tmp_targetStat = hit.targetStat;
		end
	end
end

function Machete.Server:OnHit(hit)
	if hit.clpredictedhit then
		if hit.shooter.handStrength then
			hit.impact_force_mul = hit.impact_force_mul*hit.shooter.handStrength;
			hit.impact_force_mul_final = hit.impact_force_mul_final*hit.shooter.handStrength;
			hit.impact_force_mul_final_torso = hit.impact_force_mul+hit.impact_force_mul_final;
			hit.damage = hit.damage*(hit.shooter.handStrength*0.25);
		end
		return BasicWeapon.Server.OnHit(self,hit);
	else
		hit.damage = 0;
	end
end

function Machete.Server:OnFire( params )
	if params.shooter then
		if params.shooter.POTSHOTS or (_localplayer and params.shooter == _localplayer) then
			params.shooter.machete_hittimr = _time+self.hit_delay;
		end
	end
	return BasicWeapon.Server.OnFire( self,params );
end

function Machete.Server:OnUpdate(delta, shooter)

	if shooter.machete_hittimr and shooter.machete_hittimr < _time then
		shooter.machete_hittimr = nil;
		local poss = shooter:GetPos();
		if (shooter.cnt.crouching) then
			poss.z = poss.z + 1;
		elseif (shooter.cnt.proning) then
			poss.z = poss.z + 0.4;
		else
			poss.z = poss.z + 1.7;
		end
		poss = {
			pos = poss,
			dir = shooter:GetDirectionVector(),
			shooter = shooter,
			distance = shooter.fireparams.distance,
		};
		
		--local hits = {};

		--if shooter.POTSHOTS then
		--	hits = Game:GetInstantHit(poss); --we throw the ray
		--else
		local hits = Game:GetMeleeHit(poss); --we throw the ray
		--end
		
		if hits and hits.objtype then
			local hit =	{
				dir = poss.dir,
				normal = hits.normal,
				damage = shooter.fireparams.damage*1,
				shooter = shooter,
				landed = 1,
				clpredictedhit = 1,
				e_fx = "melee_slash",
				ipart = hits.ipart,
				impact_force_mul_final = shooter.fireparams.iImpactForceMulFinal*1,
				impact_force_mul = shooter.fireparams.iImpactForceMul*1,
				damage_type="normal",
				play_mat_sound = 1,
				pos = hits.pos,
				target_material = hits.target_material,
				weapon = self,
			};
			
			--if hits.targetStat then
			--	Hud:AddMessage("tstat");
			--end
			
			if hits.target then
				hit.target = hits.target;
				hit.target_id = hits.target.id;
				if hits.target.machete_hittimr then
					hit.pos2 = hit.target:GetPos();
					hit.dir2 = hit.target:GetDirectionVector();
					hit.dir2 = { x=hit.pos2.x+hit.dir2.x*0.5, y=hit.pos2.y+hit.dir2.y*0.5, z=hit.pos2.z+hit.dir2.z*0.5};
					hit.pos2 = hit.shooter:GetDistanceFromPoint(hit.pos2);
					hit.dir2 = hit.shooter:GetDistanceFromPoint(hit.dir2);
					if hit.dir2 < hit.pos2 then
						hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_rock"));
						shooter.fireparams.mat_effect = "melee_clash";
						hit.damage = 0;
					end
				end
			elseif (shooter.tmp_targetStat) then
				 hit.targetStat = shooter.tmp_targetStat;
			end

			if Game:IsServer() then
				self.Server.OnHit(self,hit);
				if hits.target then
					if hits.target.machete_hittimr and hit.damage == 0 then
						hits.target.machete_hittimr = nil;
					else
						hits.target:Damage( hit );
					end
				end
			end
			if Game:IsClient() then
				self.Client.OnHit(self,hit);
			end
			shooter.fireparams.mat_effect = "melee_slash";
		end
	end
end

function Machete.Client:OnFire( Params )
	if (BasicWeapon.Client.OnFire( self,Params )~=nil) then
		if (Params.shooter) then
			if (Params.shooter.cnt) and (Params.shooter.cnt.first_person) then
				Params.shooter.playingReloadAnimation = 1;
			else
				Params.shooter.stop_my_talk = _time + Params.shooter:GetAnimationLength("aidle_umshoot");
			end
			if not Game:IsServer() then
				Params.shooter.machete_hittimr = _time+self.hit_delay;
			end
		end
		return 1;
	end
end

function Machete.Client:OnUpdate(delta, shooter)
	BasicWeapon.Client.OnUpdate(self,delta,shooter);
	if shooter.machete_hittimr and shooter.machete_hittimr < _time then
		Machete.Server.OnUpdate(self, delta, shooter);
	end
end

function Machete:ZoomAsAltFire(shtr)
	if (shtr) then
		if (shtr.asg_nextshot) and (shtr.asg_nextshot > _time) then
		else
			shtr.asg_nextshot = _time + 1.1;
			if (Game:IsServer()) then
				--BasicWeapon.Server.Drop( self, {Player = shtr, throw_this=1, } );
					--

				local pos = SumVectors(shtr:GetPos(),{x=0.0,y=0.0,z=1.5});
				local ang = new(shtr:GetAngles());
				ang.z = ang.z-90;

				-- adjust spawn height based on player stance
				if (shtr.cnt.crouching) then
					pos = SumVectors(pos, {x=0.0,y=0.0,z=-0.5});
				elseif (shtr.cnt.proning) then
					pos = SumVectors(pos, {x=0.0,y=0.0,z=-1.0});
				end

				local dir = BasicWeapon.temp_v1;
				local dest = BasicWeapon.temp_v2;
				----------- temp 2
				CopyVector(dir,shtr:GetDirectionVector());

				dest.x = pos.x + dir.x * 1.5;
				dest.y = pos.y + dir.y * 1.5;
				dest.z = pos.z + dir.z * 1.5;

				local hits = System:RayWorldIntersection(pos,dest,1,ent_terrain+ent_static+ent_rigid+ent_sleeping_rigid,shtr.id);

				if (hits and getn(hits)>0) then
					local temp = hits[1].pos;
					dest.x = temp.x - dir.x * 0.15;
					dest.y = temp.y - dir.y * 0.15;
					dest.z = temp.z - dir.z * 0.15;
				end 
				--
				local jdummy = Game:GetEntityClassIDByClassName("ThrowMachete");
				if (jdummy) then
					jdummy = {
						classid=jdummy*1,
						pos=pos,
						angles=ang,
					};
					
					local jdummy = Server:SpawnEntity(jdummy);
					if (jdummy) then
						jdummy:Launch(shtr.cnt.weapon, shtr, pos, ang, dir, 10000);
						Server:BroadcastCommand("PLAS "..shtr.id.." "..shtr.id);
						shtr.cnt:MakeWeaponAvailable(self.classid,0);
						if (BasicPlayer.AddPlayerHands) then
							BasicPlayer.AddPlayerHands(shtr,1);
						end
						shtr.cnt:SetCurrWeapon(9);
					end
				end
			else
				Client:SendCommand("VB_GV 0");
			end
		end
	end
end

function Machete:ZoomAsAltFcl(shtr)
	if (shtr.cnt) and (shtr.cnt.first_person) then
		shtr.thrw_some_m = 1;
	elseif (_localplayer) and (shtr~=_localplayer) then
		shtr.stop_my_talk = _time + 0.3;
		shtr:StartAnimation(0,"aidle_umshoot",4);
	end
end

