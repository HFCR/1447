-----
--   Created By: Petar
--   Description: Cover goes into this behaviour when there is no more cover, so he holds his ground
--   modified Mixer 17-06-2008 improved close combat encounters
-----

AIBehaviour.CoverHold = {
	Name = "CoverHold",


	---------------------------------------------
	OnKnownDamage = function ( self, entity, sender)
		-- called when the enemy is damaged
		entity:InsertSubpipe(0,"not_so_random_hide_from",sender.id);
	end,

	---------------------------------------------
	KEEP_FORMATION = function (self, entity, sender)
		entity:SelectPipe(0,"cover_hideform");
	end,


	---------------------------------------------
	OnNoTarget = function( self, entity )
		entity:SelectPipe(0,"confirm_targetloss");
	end,
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		entity:Event_OnAttempt()
		-- drop beacon and shoot like crazy
		local rnd = random(1,10);
		if (rnd < 2) then 
			NOCOVER:SelectAttack(entity);
		else
			entity:SelectPipe(0,"just_shoot");
			entity:TriggerEvent(AIEVENT_DROPBEACON);
		end
	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity, fDistance )
		-- try to re-establish contact
		entity:SelectPipe(0,"seek_target");
		entity:InsertSubpipe(0,"reload");

		if (fDistance > 10) then 
			entity:InsertSubpipe(0,"do_it_running");
		else
			entity:InsertSubpipe(0,"do_it_walking");
		end
				
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		entity:SelectPipe(0,"seek_target");
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		-- ignore this
	end,
	---------------------------------------------
	OnReload = function( self, entity )

	end,
	---------------------------------------------
	OnGroupMemberDied = function( self, entity )
	end,
	--------------------------------------------------
	OnGroupMemberDiedNearest = function ( self, entity, sender)
		
		AIBehaviour.DEFAULT:OnGroupMemberDiedNearest(entity,sender);	
	
		-- PETAR : Cover in attack should not care who died or not. He is too busy 
		-- watching over his own ass :)
	
	end,
	---------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
		-- he is not trying to hide in this behaviour
	end,	
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		-- called when the enemy is damaged
		AIBehaviour.DEFAULT:OnReceivingDamage(entity,sender);

		entity:SelectPipe(0,"cover_scramble");
		entity:InsertSubpipe(0,"pause_shooting");
	end,
	OnCloseContact = function (self,entity,sender)
	-- COOL MELEE DODGE TACTICS (VS MUTANT/MELEE AI)
	if (sender.MUTANT) then
	entity:SelectPipe(0,"mutant_cover_backoffattack");
	entity:InsertSubpipe(0,"setup_combat"); end
	end,
	---------------------------------------------
	OnCoverRequested = function ( self, entity, sender)
		-- called when the enemy is damaged
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
	if (sender.Properties.species ~= entity.Properties.species) then
	local dist = entity:GetDistanceFromPoint(sender:GetPos());
	if dist > 15 then
		entity:InsertSubpipe(0,"setup_prone");
	else
		entity:InsertSubpipe(0,"setup_crouch");
	end
	end
	end,
	--------------------------------------------------
	OnClipNearlyEmpty = function ( self, entity, sender)
		entity:SelectPipe(0,"cover_scramble");
		entity:InsertSubpipe(0,"take_cover");
	end,
	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------
	COVER_NORMALATTACK = function (self, entity, sender)
		entity:SelectPipe(0,"cover_pindown");
	end,
	---------------------------------------------
	MUTANT_NORMAL_ATTACK = function ( self, entity, sender)
		entity:SelectPipe(0,"cover_scramble");
		entity:InsertSubpipe(0,"reload");
	end,
	HEADS_UP_GUYS = function (self, entity, sender)
		-- do nothing on this signal
		entity.RunToTrigger = 1;
	end,
	---------------------------------------------
	INCOMING_FIRE = function (self, entity, sender)
		-- do nothing on this signal
	end,
	---------------------------------------------
	LOOK_FOR_TARGET = function (self, entity, sender)
		-- do nothing on this signal
		entity:SelectPipe(0,"look_around");
	end,	

	---------------------------------------------	
	PHASE_BLACK_ATTACK = function (self, entity, sender)
		-- team leader instructs black team to attack
		entity.Covering = nil;
		entity:SelectPipe(0,"black_cover_pindown");
	end,

	---------------------------------------------	
	PHASE_RED_ATTACK = function (self, entity, sender)
		-- team leader instructs red team to attack
		entity.Covering = nil;
		entity:SelectPipe(0,"red_cover_pindown");
	end,

}