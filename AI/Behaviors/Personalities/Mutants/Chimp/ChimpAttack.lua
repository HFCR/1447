--    Created By: Petar

AIBehaviour.ChimpAttack = {
	Name = "ChimpAttack",

	OnNoTarget = function( self, entity )
		AI:Signal(0,1,"ANY_MORE_TO_RELEASE",entity.id);
	end,

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

		entity:SelectPipe(0,"abberation_attack");

		if (entity.TEMP_RESULT == nil) then 
			entity:InsertSubpipe(0,"jump_decision");
		else
			entity.TEMP_RESULT = nil;
		end
		entity:InsertSubpipe(0,"DropBeaconAt");
	
	end,

	OnEnemyMemory = function( self, entity )

	end,

	OnInterestingSoundHeard = function( self, entity )

		entity:InsertSubpipe(0,"DropBeaconAt");
	end,

	OnThreateningSoundHeard = function( self, entity )

		entity:InsertSubpipe(0,"DropBeaconAt");
	end,

	OnReload = function( self, entity )

	end,

	OnGroupMemberDied = function( self, entity )

	end,

	OnNoHidingPlace = function( self, entity, sender )

	end,	

	OnReceivingDamage = function ( self, entity, sender)
		entity:InsertSubpipe(0,"chimp_hurt");
	end,

	OnBulletRain = function ( self, entity, sender)
	end,

	OnCloseContact = function ( self, entity, sender)
		--Hud:AddMessage("closecontact");
		if entity.sim_melee_hit == nil then
			if entity.lastMeleeAttackTime < _time then
				if (entity.MELEE_ANIM_COUNT) then
					local rnd = random(1,entity.MELEE_ANIM_COUNT);
					rnd = format("attack_melee%01d",rnd);
					--Hud:AddMessage("hit "..rnd);
					--entity:StartAnimation(0,rnd,4);
					entity:InsertSubpipe(0,"jump_decision");
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
		
		--------
		
		
		--if (entity.HASCLAWS) then
		--	GameRules:SimulateMelee(entity);
		--elseif (entity.MELEE_ANIM_COUNT) then
		--	local rnd = random(1,entity.MELEE_ANIM_COUNT);
		--	local melee_anim_name = format("attack_melee%01d",rnd);
		--	entity:InsertSubpipe(0,"jump_decision");
		--	entity:InsertAnimationPipe(melee_anim_name,3,nil,0);
		--end
	end,

	SWITCH_TO_ABBERATION_ATTACK = function ( self, entity, sender)
		entity:SelectPipe(0,"abberation_attack");
	end,

}