-- Sniper Bullet (Mixer) v0.01,      pvcf v0.02 mixer v0.05

--additions by pvcf 
-->damage is taken from current  sniper weapon fireparams
-->distance check with damage_drop_per_meter code, takes also setting from current sniper weapon
-->adaptive damage drop per meter depending on difficulty level if operation clearing or its devkid as modbase is detected

-- additions by mixer
--> bullet velocity with bullet_velocity code, takes also setting from current sniper weapon
--> bullet gravity with bullet_gravity code, takes also setting from current sniper weapon
--> impact force multipliers with impact_force_mul and impact_force_mul_final code, takes also setting from current sniper weapon
--> bullet decay modifier (correctnessfactor) with bullet_decay code, takes also setting from current sniper weapon
--> decals angles fixed, dynamic decals on moving objects fixed

Script:LoadScript("scripts/default/entities/weapons/BaseProjectile.lua");
projectileDefinitionSP = {
	Param = {
		mass = 1,
		size = 0.15,
		heading = {},
		flags=1,
		initial_velocity = 99, --pvcf (slowed) --499
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = {x=0,y=0,z=-0.3},    --pvcf z value from -3 to -0.3 because of very slow bullet
		collider_to_ignore = nil,
		AI_Type = AIOBJECT_ATTRIBUTE,
	},
	
	ExplosionParams = {
		--damage = 350,            --pvcf, not used anymore, its asked from the current sniper weapon
		damage = 350,  -- Mixer: these are fail-safe values, to avoid errors if not have been overriden by weapon's settings
		damage_drop_per_meter = 0, -- Mixer: these are fail-safe values, to avoid errors if not have been overriden by weapon's settings
		effect = "bullet_hit",
		shooter = nil,
		weapon = nil,
		impact_force_mul_final=25,
		impact_force_mul=15,
	},
	
	EngineSound = {
		name = "Sounds/Weapons/bullets/whiz1.wav",
		minDist = 0.1,   --pvcf  --1
		maxDist = 1,  --pvcf --50000
	},
	projectileObject = "Objects/Weapons/trail.cgf",
	projectileObjectScale = 1,
	explodeOnContact = 1,
	lifetime = 4000,
}

SniperBullet = CreateProjectile(projectileDefinitionSP);

function SniperBullet:Server_OnUpdate(dt)
	self.isExploding = 1;
	local status=GetParticleCollisionStatus(self);
	local poss=self:GetPos();
		---------pvcf-----------
		--Hud.label="bullet flying";
		---------pvcf------------
	if (status) then
		local shooter = self.shooter;
		if (self.shooterSSID) then
			local player_slot=Server:GetServerSlotBySSId(self.shooterSSID);
			if (player_slot) then
				shooter = player_slot:GetPlayerId();
				if (shooter) then
					shooter = System:GetEntity(shooter);
				end
			else
				local entlist = System:GetEntities();
				for i, entity in entlist do
					if (entity.vbot_ssid) then
						if (entity.vbot_ssid == self.shooterSSID) then
						shooter = entity;
						break;
						end
					end
				end
			end
		end
		
		if (not shooter) and (status.target) then
			shooter = status.target;
		end
		
		local hit =	{
			dir = status.normal,
			normal = status.normal,
			e_fx = self.ExplosionParams.effect.."",
			shooter = shooter,
			landed = 1,
			impact_force_mul_final = self.ExplosionParams.impact_force_mul_final,
			impact_force_mul = self.ExplosionParams.impact_force_mul,
			damage_type="normal",
			pos = status.pos,
			target_material = status.target_material,
			play_mat_sound = 1,
		};

		
		if (status.target) and (status.target.Damage) then
			---------pvcf---------------------------------------------------------------------------------------------------------
			--------- Mixer: the target entity is stored in status.target
			--------- so we may use this:
				---- local shooterpos = shooter:GetPos();
				---- local dist = floor(status.target:GetDistanceFromPoint(shooterpos));
			--------- but because we already got hit pos as poss, we don't need to get player pos, it is much easier to use this way you defined:

			local dist = floor(shooter:GetDistanceFromPoint(hit.pos));
			local correctnessfactor = 70;
			if (self.ExplosionParams.bullet_decay) then
				correctnessfactor = self.ExplosionParams.bullet_decay;
			end
			if opcl_ET_hudstyle and opcl_ET_hudstyle == "0" then  --operation clearing detected
				--------------we do here adaptive damage -distance-correctnessfactor depending on opcl difficultlevel
				----------------------------difficulty level------------------------------------------------------------------------------
				local difficulty = tonumber(getglobal("game_DifficultyLevel"));
				if difficulty == 0 then correctnessfactor = 40;     end-- Tourist
				if difficulty == 1 then correctnessfactor = 60;     end-- NoVisa
				if difficulty == 2 then correctnessfactor = 70;     end-- Soldier
				if difficulty == 3 then correctnessfactor = 83;     end-- Simulation
				--if difficulty == 4 then                                      ;     end    --this should be a impossible setting in opcl
			end          --if opcl_ET_hudstyle and opcl_ET_hudstyle == "0" then  --operation clearing detected
			
			-- Mixer: weapon shows its distance meter as actual distance multiplied by 1.5, so, to get dist value equal to distance showed in scope, we
			-- need to multiply it by 1.5 too!
			
			-- if you need a proof, let's find the following in sniperrifle.lua :
			
			-- Draw distance
			--local myPlayer=_localplayer;
			--if ( myPlayer ) then
			--	local int_pt=myPlayer.cnt:GetViewIntersection();
			--	if ( int_pt ) then
			--		local s=format( "%07.2fm", int_pt.len*1.5); ------------------ <<<<<<<<<<<<<<<<<< MIXER: HERE IT IS!!!!!!

			
			dist = dist *1.5;

			local damagedrop = floor(dist * self.ExplosionParams.damage_drop_per_meter * correctnessfactor);
			hit.damage = self.ExplosionParams.damage - damagedrop;				--pvcf
			hit.target = status.target;
			hit.target_id = hit.target.id;
			if (self.ExplosionParams.wpn) then
				hit.weapon = self.ExplosionParams.wpn;
			else
				hit.weapon = self.ExplosionParams.weapon;
			end

			if (hit.damage > 0) then
				--Hud:AddMessage(hit.target_material.type.." damage: "..hit.damage.." Distance "..dist.."m "..hit.target:GetName().." shooter: "..hit.shooter:GetName());
				status.target:Damage(hit);
				if (Game:IsMultiplayer()) then
					Server:BroadcastCommand("CHI "..hit.shooter.id.." "..hit.target.id.." "..hit.damage);
				end
			end
		end

		if (Game:IsClient()) then
			ExecuteMaterial2( hit ,hit.e_fx);
		end
		
		if (hit.target_material.AI) and (hit.shooter~=nil) then
			AI:FreeSignal(1,"OnBulletRain",hit.pos, hit.target_material.AI.fImpactRadius,hit.shooter.id);
		end

		self.isExploding = 1;
		self:SetTimer(1);
	elseif (System:IsValidMapPos(poss) ~= 1) then
		self.isExploding = 1;
		self:SetTimer(1);
	end
end

function BaseProjectile:Client_OnUpdate(dt)
	if (self.isTerminating) then
		return
	end

	local pos = self:GetPos();

	if (self.theweirdxpos) then
		if (self.theweirdxpos~=pos.x) then
			self:DrawObject( 0, 1 );
			-- Initialize Smoke trail particles.
			if (self.SmokeEffectEmitter) then
				self:CreateParticleEmitterEffect( 0,self.SmokeEffectEmitter,1000,g_Vectors.v000,g_Vectors.v010,1 );
			end
		else
			return
		end
		self.theweirdxpos = nil;
	end

	if (Materials["mat_water"] and Materials["mat_water"].bullet_hit) then
		if (not self.was_underwater) then
			if (Game:IsPointInWater(pos)) then
				self.was_underwater=1;
				ExecuteMaterial(pos, g_Vectors.v001, Materials.mat_water.bullet_hit,1);
			end
		end
	end
	
	if (not Game:IsServer()) then
		local status=GetParticleCollisionStatus(self);
		if (status) then
			local hit = {
				dir = status.normal,
				normal = status.normal,
				e_fx = self.ExplosionParams.effect.."",
				shooter = shooter,
				landed = 1,
				impact_force_mul_final = self.ExplosionParams.impact_force_mul_final,
				impact_force_mul = self.ExplosionParams.impact_force_mul,
				damage_type="normal",
				pos = status.pos,
				target_material = status.target_material,
				play_mat_sound = 1,
			};
			if (status.target) and (status.target.Damage) then
				hit.target = status.target;
				hit.target_id = hit.target.id;
			end
			ExecuteMaterial2( hit ,hit.e_fx);
		end
	end
end

function SniperBullet:Launch( weapon, shooter, pos, angles, dir, target )
	self.Param.heading = dir;
	self.Param.collider_to_ignore = shooter;
	self.shooter = shooter;
	local projectilepos = g_Vectors.temp_v1;
	CopyVector(projectilepos,pos);
	self.ExplosionParams.shooterid = shooter.id;

	if (shooter) and (shooter.fireparams) then
		self.ExplosionParams.weapon = shooter.cnt.weapon.name.."";
		self.ExplosionParams.wpn = {name = self.ExplosionParams.weapon,};
		if (shooter.fireparams.damage) then
			self.ExplosionParams.damage = shooter.fireparams.damage*1; -- *1 used to break the posssible link between self.ExplosionParams.damage and shooter.fireparams.damage variables
		end
		if (shooter.fireparams.damage_drop_per_meter) then
			self.ExplosionParams.damage_drop_per_meter = shooter.fireparams.damage_drop_per_meter*1;
		end
		if (shooter.fireparams.impact_force_mul) then
			self.ExplosionParams.impact_force_mul = shooter.fireparams.impact_force_mul*1;
		end
		if (shooter.fireparams.impact_force_mul_final) then
			self.ExplosionParams.impact_force_mul_final = shooter.fireparams.impact_force_mul_final*1;
		end
		if (shooter.fireparams.bullet_velocity) then
			self.Param.initial_velocity = shooter.fireparams.bullet_velocity*1;
		end
		if (shooter.fireparams.bullet_gravity) then
			self.Param.gravity.z = -shooter.fireparams.bullet_gravity;
		end
		if (shooter.fireparams.bullet_decay) then
			self.ExplosionParams.bullet_decay = -shooter.fireparams.bullet_decay*1;
		end
	else
		self.ExplosionParams.weapon = self;
	end

	self.LaunchedByTeam=Game:GetEntityTeam(shooter.id);
	self.isExploding = nil;

	local serverSlot = Server:GetServerSlotByEntityId(shooter.id);

	if (serverSlot) then
		self.shooterSSID = serverSlot:GetId();
		self.ExplosionParams.shooterSSID = self.shooterSSID;
	elseif (shooter.vbot_ssid) then
		self.shooterSSID = shooter.vbot_ssid;
		self.ExplosionParams.shooterSSID = shooter.vbot_ssid;
	end

	self:SetPhysicParams( PHYSICPARAM_PARTICLE, self.Param );
	self:SetViewDistRatio(255);
	self:SetPos( projectilepos );
	self:SetAngles( angles );
end

SniperBullet.Server.OnUpdate = SniperBullet.Server_OnUpdate;