--------------------------------------------------
--    Created By: Amanda
--   Description: Attack behaviour for the Scientist personality
--   Modified by Mixer
--------------------------
--

AIBehaviour.ScientistAttack = {
	Name = "ScientistThreatened",
	Direction = 0,

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSelected = function( self, entity )	
	end,
	---------------------------------------------
	OnSpawn = function( self, entity )
		self:OnGoToHome(entity);
	end,
	---------------------------------------------
	OnActivate = function( self, entity )

	end,
	---------------------------------------------
	OnNoTarget = function( self, entity )
		self:OnGoToHome(entity);
	end,
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		entity.b_threatened = 1;
		AI:Signal(SIGNALID_READIBILITY, 2, "THREATEN_GROUP",entity.id);
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "HEADS_UP_GUYS",entity.id);
		entity:SelectPipe(0,"protect_spot",entity.Properties.ReinforcePoint);
		if (entity.cnt.weapon) then
			entity:InsertSubpipe(0,"setup_combat");
			entity:InsertSubpipe(0,"rear_weaponAttack");
		else
			local gunrack = AI:FindObjectOfType(entity:GetPos(),60,AIAnchor.GUN_RACK);
			if (gunrack) then 
				entity:InsertSubpipe(0,"get_gun",gunrack);
			else
			self:OnRunToHome(entity);
			end
		end

	end,
	---------------------------------------------
	OnEnemySeen = function( self, entity )
		-- called when the enemy sees a foe which is not a living player
	end,
	---------------------------------------------
	OnFriendSeen = function( self, entity )
		-- called when the enemy sees a friendly target
	end,
	---------------------------------------------
	OnDeadBodySeen = function( self, entity )
		-- called when the enemy a dead body
	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		entity:SelectPipe(0,"scout_comeout");
		entity:InsertSubpipe(0,"setup_combat");
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
	 	--entity:SelectPipe(0,"scout_comeout");
		--entity:InsertSubpipe(0,"cover_neutral_form");
	 	entity:InsertSubpipe(0,"DropBeaconAt");
		--entity:InsertSubpipe(0,"setup_idle");
	 	--entity:InsertSubpipe(0,"DRAW_GUN");

	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		if (not entity.b_threatened) then
		entity.b_threatened = 1;
		entity:SelectPipe(0,"scout_comeout");
		entity:InsertSubpipe(0,"basic_lookingaround");
		entity:InsertSubpipe(0,"setup_combat");
		entity:InsertSubpipe(0,"DropBeaconAt");
		end
	end,
	---------------------------------------------
	OnReload = function( self, entity )
		self:OnRunToHome(entity);
	end,
	---------------------------------------------
	OnClipNearlyEmpty = function(self,entity)
		--entity:SelectPipe(0,"scientist_hideNow");
		--self:OnRunForYourLife(entity);
	end,
	---------------------------------------------
	OnGroupMemberDied = function( self, entity )
		-- dont handle this
	end,
	---------------------------------------------
	OnGroupMemberDiedNearest = function( self, entity )
		-- dont handle this
	end,
	---------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
		-- called when no hiding place can be found with the specified parameters
		--AI:Signal(0,1,"REAR_NORMALATTACK",entity.id);
		self:OnRunToHome(entity);
	end,
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		--AI:Signal(SIGNALID_READIBILITY, 1, "GETTING_SHOT_AT",entity.id);
		self:OnRunForYourLife(entity);
		entity:InsertSubpipe(0,"basic_lookingaround");
	end,
	--------------------------------------------------
	OnBulletRain = function (self,entity, sender)
	self:OnRunToHome(entity);
	entity:InsertSubpipe(0,"setup_combat");
	entity:InsertSubpipe(0,"DropBeaconAt");
	entity:InsertSubpipe(0,"scout_quickhide");
	end,
	---------------------------------------------
	OnCoverRequested = function ( self, entity, sender)
		-- called when the enemy is damaged
	end,
	---------------------------------------------------------
	REAR_NORMALATTACK = function (self, entity, sender)

		entity:SelectPipe(0,"scout_comeout");
	end,

	SCOUT_NORMALATTACK = function (self, entity, sender)
		if (entity.b_threatened) then
			entity.b_threatened = nil;
		end
		self:OnGoToHome(entity);
	end,

	OnGoToHome = function( self, entity )
		--entity:InsertSubpipe(0,"setup_idle");
		entity:SelectPipe(0,"patrol_approach_to",entity.Properties.ReinforcePoint);	
	end,
	OnRunToHome = function( self, entity )
		--entity:InsertSubpipe(0,"setup_idle");
		entity:SelectPipe(0,"run_to_trigger",entity.Properties.ReinforcePoint);
	end,
	OnRunForYourLife = function( self, entity )
		entity:InsertSubpipe(0,"setup_combat");
		entity:SelectPipe(0,"run_to_trigger",entity.Properties.pathname);	
	end,
	PatrolPath = function( self, entity )
		if (entity.b_threatened) then
			entity.b_threatened = nil;
		end
	end,
	EXIT_RUNTOALARM = function( self, entity )
		AI:Signal(0,1,"REAR_NORMALATTACK",entity.id);
	end,
	---------------------------------------------
	HEADS_UP_GUYS = function (self, entity, sender)
	
	end,
}