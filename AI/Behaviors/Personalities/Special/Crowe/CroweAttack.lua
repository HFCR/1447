--    Created By: Petar
-- improved by Mixer 2.0

AIBehaviour.CroweAttack = {
	Name = "CroweAttack",

	DESTROY_THE_BEACON = function ( self, entity, sender)
	end,

	TRY_NEXT = function( self, entity )
		-- called when enemy receives an activate event (from a trigger, for example)
		entity.DODGING_ALREADY = nil;
		entity:SelectPipe(0,"crowe_coordinating");
	end,

	OnPlayerAiming = function ( self, entity, sender)
		if (entity.DODGING_ALREADY==nil) then
			local rd=random(1,4);
			entity:SelectPipe(0,"crowe_dodge_"..rd);
			entity.DODGING_ALREADY = 1;
			if rd == 4 then
				if (entity.Properties.SoundPack=="Crowe") and (not entity.crowehurtinsult) then
					if (entity.cnt.health / entity.Properties.max_health) < 0.5 then
						entity:Readibility("HURT_INSULT",1);
						entity.crowehurtinsult = 1;
					else
						entity:Readibility("DESTROY_HIM",1);
					end
				end
			end
		end
		entity:TriggerEvent(AIEVENT_DROPBEACON);
		AI:Signal(SIGNALFILTER_SUPERGROUP,1,"DESTROY_THE_BEACON",entity.id);
	end,
	---------------------------------------------
	OnNoTarget = function( self, entity )
		-- called when the enemy stops having an attention target
	end,
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
	end,
	---------------------------------------------
	OnGrenadeSeen = function( self, entity, fDistance )
		entity:InsertSubpipe(0,"setup_combat");
		entity:InsertSubpipe(0,"mutant_cover_backoffattack");
	end,

	OnEnemySeen = function( self, entity )

	end,
	---------------------------------------------
	OnSomethingSeen = function( self, entity )

	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
	end,

	OnInterestingSoundHeard = function( self, entity )
		if (not entity.cnt.moving) and (not entity.my_leader) then
			entity:InsertSubpipe(0,"DropBeaconAt");
		end
	end,

	-- COOL MELEE DODGE TACTICS (VS MUTANT/MELEE AI)
	OnCloseContact = function (self,entity,sender)
	if (sender.MUTANT) then
		entity:InsertSubpipe(0,"setup_combat");
		entity:InsertSubpipe(0,"mutant_cover_backoffattack");
	end
	end,
	
	OnThreateningSoundHeard = function( self, entity )
		local thr_t = AI:GetAttentionTargetOf(entity.id);
		if (thr_t) and (type(thr_t) == "table") then
		elseif (not entity.my_leader) then
			entity:InsertSubpipe(0,"DropBeaconAt");
		end
	end,

	OnReload = function( self, entity )
	end,
	---------------------------------------------
	OnGroupMemberDied = function( self, entity )
	end,
	---------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
	end,	
	--------------------------------------------------
	OnNoFormationPoint = function ( self, entity, sender)
	end,
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		local rd=random(1,4);
		entity:SelectPipe(0,"crowe_dodge_"..rd);
	end,
	---------------------------------------------
	OnCoverRequested = function ( self, entity, sender)
		-- called when the enemy is damaged
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
	end,
	--------------------------------------------------

	-- GROUP SIGNALS
	---------------------------------------------	
	KEEP_FORMATION = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
	end,
	---------------------------------------------	
	BREAK_FORMATION = function (self, entity, sender)
		-- the team can split
	end,
	---------------------------------------------	
	SINGLE_GO = function (self, entity, sender)
		-- the team leader has instructed this group member to approach the enemy
	end,
	---------------------------------------------	
	GROUP_COVER = function (self, entity, sender)
		-- the team leader has instructed this group member to cover his friends
	end,
	---------------------------------------------	
	IN_POSITION = function (self, entity, sender)
		-- some member of the group is safely in position
	end,
	---------------------------------------------	
	GROUP_SPLIT = function (self, entity, sender)
		-- team leader instructs group to split
	end,
	---------------------------------------------	
	PHASE_RED_ATTACK = function (self, entity, sender)
		-- team leader instructs red team to attack
	end,
	---------------------------------------------	
	PHASE_BLACK_ATTACK = function (self, entity, sender)
		-- team leader instructs black team to attack
	end,
	---------------------------------------------	
	GROUP_MERGE = function (self, entity, sender)
		-- team leader instructs groups to merge into a team again
	end,
	---------------------------------------------	
	CLOSE_IN_PHASE = function (self, entity, sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
	---------------------------------------------	
	ASSAULT_PHASE = function (self, entity, sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
	---------------------------------------------	
	GROUP_NEUTRALISED = function (self, entity, sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
}