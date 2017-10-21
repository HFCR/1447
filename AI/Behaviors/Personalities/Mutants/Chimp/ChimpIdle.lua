-- Mad Chimp modified by Mixer 2
AIBehaviour.ChimpIdle = {
	Name = "ChimpIdle",

	OnPlayerSeen = function( self, entity, fDistance )
		entity:SelectPipe(0,"abberation_attack");

		if (AI:GetGroupCount(entity.id) > 1) then	
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_SEEN, "FIRST_HOSTILE_CONTACT_GROUP",entity.id);	
			AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "HEADS_UP_GUYS",entity.id);
			AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "wakeup",entity.id);
		else
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_SEEN, "FIRST_HOSTILE_CONTACT",entity.id);	
		end

		local SetAngle = entity.Properties.fJumpAngle;
		entity.Properties.fJumpAngle = 38;
		entity.TEMP_RESULT = entity:MutantJump(AIAnchor.MUTANT_JUMP_SMALL,20);
		entity.Properties.fJumpAngle=SetAngle;
		
		-- bellow and howl
		if (entity.TEMP_RESULT == nil) then
			entity:InsertSubpipe(0,"jump_decision");
		end
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
		entity:SelectPipe(0,"abberation_attack");
		entity:InsertSubpipe(0,"DropBeaconAt");
	end,

	OnReload = function( self, entity )
	end,

	OnGroupMemberDied = function( self, entity )
	end,

	OnNoHidingPlace = function( self, entity, sender )
	end,	

	OnReceivingDamage = function ( self, entity, sender)
		entity:SelectPipe(0,"abberation_scared");
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
			local SetAngle = entity.Properties.fJumpAngle;
			entity.Properties.fJumpAngle = 45;
			entity:MutantJump(AIAnchor.MUTANT_JUMP_SMALL,20);
			entity.Properties.fJumpAngle=SetAngle;
		end
		entity.EventToCall = "OnPlayerSeen";
	end,

	MAKE_COMBAT_BREAK_ANIM = function ( self, entity, sender)
		
		if (entity.COMBAT_IDLE_COUNT) then
			local rnd = random(0,entity.COMBAT_IDLE_COUNT);
			local idle_anim_name = format("combat_idle%02d",rnd);
			entity:InsertAnimationPipe(idle_anim_name,3);
		end

	end,

	SEEK_JUMP_ANCHOR = function ( self, entity, sender)
		local att_target = AI:GetAttentionTargetOf(entity.id);
		if (att_target) then 
			if (type(att_target) == "table") then
				local jmp_dist = 13;
				if (att_target.POTSHOTS) then
					jmp_dist = 11;
				end
				-- Mixer: fix: correct jumping at chosen prey
				if (entity:GetDistanceFromPoint(att_target:GetPos())<=jmp_dist) then
					entity.AI_CanWalk = nil;
					if (not GameRules._cisc_chiai) then
						AI:CreateGoalPipe("jump_to");
						AI:PushGoal("jump_to","ignoreall",0,1); 
						AI:PushGoal("jump_to","clear",0); 
						AI:PushGoal("jump_to","firecmd",0,0); 
						AI:PushGoal("jump_to","jump",1,0,0,0,entity.Properties.fJumpAngle);
						AI:PushGoal("jump_to","ignoreall",0,0);
						if (Game:IsMultiplayer()) then
							GameRules._cisc_chiai = 1;
						end
					end
					AI:Signal(0,1,"JUMP_ALLOWED",entity.id);
					entity:SelectPipe(0,"jump_wrapper");
					entity:InsertSubpipe(0,"jump_to",att_target.id);
					if (Game:IsMultiplayer()) then
						Server:BroadcastCommand("PLAA "..entity.id.." jump_forward"..random(1,4));
					end
				end
			end
		end
	end,

	JUMP_FINISHED = function ( self, entity, sender)
		entity:SelectPipe(0,"abberation_attack");
	end,

	SWITCH_TO_ATTACK = function ( self, entity, sender)
		entity:SelectPipe(0,"abberation_attack");
	end,

	ANY_MORE_TO_RELEASE = function ( self, entity, sender)
		local release_friends = AI:FindObjectOfType(entity.id,50,AIAnchor.MUTANT_LOCK);
		if (release_friends) then 
			entity:SelectPipe(0,"bust_lock_at",release_friends);			
		else
			entity:SelectPipe(0,"abberation_attack");
		end
	end,
}