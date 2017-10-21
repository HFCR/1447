--   Created By: Petar
--   Description: ai following player behavior
--   modified by Mixer v2.0 + survival mode

AIBehaviour.SpecialFollow = {
	Name = "SpecialFollow",

	OnSelected = function( self, entity )	
	end,

	OnSpawn = function( self, entity )
		entity:Event_Follow();
	end,

	OnActivate = function( self, entity )
	end,

	OnNoTarget = function( self, entity )
		entity:Event_Follow();
	end,

	OnPlayerSeen = function( self, entity, fDistance )
		entity:TriggerEvent(AIEVENT_CLEAR);
		entity:TriggerEvent(AIEVENT_DROPBEACON);
		if (entity.isbadmonster) then
			entity:Event_StopSpecial();
			entity.AI_SpecialBehaviour = "SPECIAL_FOLLOW";
			entity.AI_CanWalk = 1;
			entity:InsertSubpipe(0,"rear_weaponAttack");
		else
			AI:Signal(SIGNALID_READIBILITY, 1, "WE_HAVE_BEEN_DISCOVERED",entity.id);
		end
	end,

	OnGrenadeSeen = function( self, entity, fDistance )
		entity:Readibility("GRENADE_SEEN",1);
		entity:InsertSubpipe(0,"cover_grenade_run_away");
	end,

	OnEnemyMemory = function( self, entity )
	end,
	
	OnCloseContact = function( self, entity, sender)
		if (entity.items) and (entity.items.pissed_by_player) and (_localplayer) then
			AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"RUSH_TARGET",entity.id);
		end
	end,

	OnInterestingSoundHeard = function( self, entity )
		entity:SelectPipe(0,"rear_interested");
		entity:InsertSubpipe(0,"DropBeaconAt");
	end,

	OnThreateningSoundHeard = function( self, entity )
		AI:Signal(SIGNALID_READIBILITY, 1, "WE_HAVE_BEEN_DISCOVERED",entity.id);
		entity:InsertSubpipe(0,"cover_investigate_threat");
	end,

	OnReload = function( self, entity )
	end,

	OnGroupMemberDied = function( self, entity )
	end,

	OnNoHidingPlace = function( self, entity, sender )
	end,	

	OnNoFormationPoint = function ( self, entity, sender)
	end,

	OnReceivingDamage = function ( self, entity, sender)
		entity:TriggerEvent(AIEVENT_CLEAR);
		if (_localplayer) and (sender == _localplayer) then
			AI:Signal(SIGNALID_READIBILITY, 1, "GETTING_SHOT_AT",entity.id);
		else
			entity:InsertSubpipe(0,"look_around");
		end
	end,

	OnBulletRain = function ( self, entity, sender)
		if (entity.isbadmonster) then
			entity:MakeAlerted();
			return;
		end
		if (_localplayer) then
			local lplayerang=_localplayer:GetAngles();
			entity:SetAngles(lplayerang);
		end
	end,

	KEEP_FORMATION = function (self, entity, sender)
	end,

	BREAK_FORMATION = function (self, entity, sender)
	end,

	SINGLE_GO = function (self, entity, sender)
	end,

	GROUP_COVER = function (self, entity, sender)
	end,

	IN_POSITION = function (self, entity, sender)
	end,

	GROUP_SPLIT = function (self, entity, sender)
	end,

	PHASE_RED_ATTACK = function (self, entity, sender)
	end,

	PHASE_BLACK_ATTACK = function (self, entity, sender)
	end,

	GROUP_MERGE = function (self, entity, sender)
	end,

	CLOSE_IN_PHASE = function (self, entity, sender)
	end,

	ASSAULT_PHASE = function (self, entity, sender)
	end,

	GROUP_NEUTRALISED = function (self, entity, sender)
	end,
}
