--    Created By: Petar
-- modified by mixer

AIBehaviour.MorphAttack = {
	Name = "MorphAttack",
	OnKnownDamage = function ( self, entity, sender)
		local mytarget = AI:GetAttentionTargetOf(entity.id);
		if (mytarget) then 
			if (type(mytarget)=="table") then 
				if ((mytarget ~= sender) and (sender==_localplayer)) then 
					entity:SelectPipe(0,"retaliate_damage",sender.id);
				end
			end
		end
	end,
	OnPlayerSeen = function( self, entity, fDistance )
		entity:SelectPipe(0,"morpher_attack_wrapper");
		entity:InsertSubpipe(0,"DropBeaconAt");
	end,

	OnPlayerLookingAway =  function( self, entity, fDistance )
		entity:GoRefractive();
		entity:SelectPipe(0,"morpher_invisible_attack");
	end,


	OnEnemyMemory = function( self, entity )
	end,

	OnInterestingSoundHeard = function( self, entity )
	end,

	OnThreateningSoundHeard = function( self, entity )
	end,

	OnReload = function( self, entity )
	end,

	OnGroupMemberDied = function( self, entity )
	end,

	OnNoHidingPlace = function( self, entity, sender )
		entity:InsertSubpipe(0,"mutant_run_towards_target");
	end,	

	OnReceivingDamage = function ( self, entity, sender)
		entity:MutantJump(AIAnchor.MUTANT_AIRDUCT);
	end,

	OnBulletRain = function ( self, entity, sender)
		local mytarget = AI:GetAttentionTargetOf(entity.id);
		if (mytarget) and (type(mytarget)=="table") then
		else
			local rd=random(2,3);
			entity:InsertSubpipe(0,"crowe_dodge_"..rd);
		end
	end,

	OnCloseContact = function ( self, entity, sender)
		if (entity.GoVisible) then
			entity:GoVisible();
		end
		--------------------
		if entity.sim_melee_hit == nil then
			if entity.lastMeleeAttackTime < _time then
				entity:SelectPipe(0,"morpher_attack_wrapper");
				if (entity.MELEE_ANIM_COUNT) then
					local rnd = random(1,entity.MELEE_ANIM_COUNT);
					rnd = format("attack_melee%01d",rnd);
					--Hud:AddMessage("hit "..rnd);
					--entity:StartAnimation(0,rnd,4);
					entity:InsertAnimationPipe(rnd,nil,nil,0);
					if Game:IsMultiplayer() then
						Server:BroadcastCommand("PLAA "..entity.id.." "..rnd);
					end
					rnd = entity:GetAnimationLength(rnd);
					entity.lastMeleeAttackTime = _time + random(1,2)-1+0.1+rnd;
					entity.sim_melee_hit = _time + rnd*0.5;
				end
			end
		end
		----------------------------
		--if (entity.survival_gun or entity.HASCLAWS) and (GameRules.SimulateMelee) then
		--	GameRules:SimulateMelee(entity);
		--else
		--	entity:SelectPipe(0,"morpher_attack_wrapper");
		--	if (entity.MELEE_ANIM_COUNT) then
		--		local rnd = random(1,entity.MELEE_ANIM_COUNT);
		--		local melee_anim_name = format("attack_melee%01d",rnd);
		--		entity:InsertAnimationPipe(melee_anim_name,3);
		--	end
		--end
	end,
	
	SELECT_MORPH_ATTACK = function ( self, entity, sender)
		local rnd=random(1,3);
		if (rnd==1) then 
			entity:InsertSubpipe(0,"morpher_attack_left");
		elseif (rnd==2) then 
			entity:InsertSubpipe(0,"morpher_attack_right");
		else
			entity:InsertSubpipe(0,"morpher_attack_retreat");
		end
	end,
}
