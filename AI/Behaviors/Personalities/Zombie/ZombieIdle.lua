-- Created By: Flameknight7
AIBehaviour.ZombieIdle = {
	Name = "ZombieIdle",
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
		entity:Readibility("IDLE_TO_INTERESTED");
		entity:SelectPipe(0,"mutant_walk_to_target");
	end,
	OnThreateningSoundHeard = function( self, entity )
		entity:Readibility("IDLE_TO_THREATENED",1);
		entity:SelectPipe(0,"Attacker_run_and_shoot");
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
	MAKE_BELLOW_HOWL_ANIMATION = function ( self, entity, sender)
		entity:InsertAnimationPipe("idle05");
	end,
	OnDeath = function ( self, entity, sender)
		AI:Signal(SIGNALFILTER_NEARESTGROUP,1,"SWITCH_TO_ATTACK",entity.id);
	end,
	HEADS_UP_GUYS = function ( self, entity, sender)
		if (entity.id ~= sender.id) then
			entity:SelectPipe(0,"run_to_beacon");
		end
		entity.EventToCall = "OnPlayerSeen";
	end,
	MAKE_COMBAT_BREAK_ANIM = function ( self, entity, sender)
		if (entity.COMBAT_IDLE_COUNT) then
			local rnd = random(0,entity.COMBAT_IDLE_COUNT);
			local idle_anim_name = format("combat_idle%02d",rnd);
			entity:InsertAnimationPipe(idle_anim_name,3);
		else
			Hud:AddMessage("============ UNACCEPTABLE ERROR ===================");
			Hud:AddMessage("[ASSETERROR] No combat idles for "..entity:GetName());
			Hud:AddMessage("============ UNACCEPTABLE ERROR ===================");
		end

	end,
	SWITCH_TO_ATTACK = function ( self, entity, sender)
		entity:SelectPipe(0,"Attacker_run_and_shoot");
	end,
	ANY_MORE_TO_RELEASE = function ( self, entity, sender)
		local release_friends = AI:FindObjectOfType(entity.id,50,AIAnchor.MUTANT_LOCK);
		if (release_friends) then 
			entity:SelectPipe(0,"bust_lock_at",release_friends);			
		else
			entity:SelectPipe(0,"Attacker_run_and_shoot");
		end
	end,
}