-- Created By: Flameknight7
AIBehaviour.ZombieAttack = {
	Name = "ZombieAttack",
	OnNoTarget = function( self, entity )
		AI:Signal(0,1,"ANY_MORE_TO_RELEASE",entity.id);
	end,
--	OnKnownDamage = function ( self, entity, sender)
--		local mytarget = AI:GetAttentionTargetOf(entity.id);
--		if (mytarget) then 
--			if (type(mytarget)=="table") then 
--				if ((mytarget ~= sender) and (sender==_localplayer)) then 
--					entity:SelectPipe(0,"retaliate_damage",sender.id);
--				end
--			end
--		end
--	end,
	OnPlayerSeen = function( self, entity, fDistance )
		entity:SelectPipe(0,"Attacker_run_and_shoot");
		entity:InsertSubpipe(0,"DropBeaconAt");
	end,
	OnEnemySeen = function( self, entity, fDistance )
		entity:SelectPipe(0,"Attacker_run_and_shoot");
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
	end,
	OnBulletRain = function ( self, entity, sender)
	end,
	OnCloseContact = function ( self, entity, sender)
		if (entity.MELEE_ANIM_COUNT) then
			local rnd = random(1,entity.MELEE_ANIM_COUNT);
			local melee_anim_name = format("attack_melee%01d",rnd);
			entity:InsertAnimationPipe(melee_anim_name,3,nil,0);
		else
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================");
			Hud:AddMessage("Entity "..entity:GetName().." made melee attack but has no melee animations.");
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================");
		end
		entity:InsertSubpipe(0,"Attacker_shoot");
	end,
	SWITCH_TO_ATTACK = function ( self, entity, sender)
		entity:SelectPipe(0,"Attacker_run_and_shoot");
	end,
}