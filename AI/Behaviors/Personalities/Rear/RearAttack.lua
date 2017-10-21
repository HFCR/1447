--   Created By: Petar
--   Description: Rear Combat Behavior
-- modified by Mixer

AIBehaviour.RearAttack = {
	Name = "RearAttack",

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

	OnNoTarget = function( self, entity )
		if (AI:GetGroupCount(entity.id) > 1) then	
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_LOST, "ENEMY_TARGET_LOST_GROUP",entity.id);	
		else
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_LOST, "ENEMY_TARGET_LOST",entity.id);	
		end	

	end,

	OnPlayerSeen = function( self, entity, fDistance )
		
		entity:SelectPipe(0,"protect_spot",entity:GetName().."_PROTECT");


		if (fDistance>8 and fDistance<30 and entity.cnt.numofgrenades>0) then 
			local rnd = random(1,10);
			if (rnd<3) then
				entity:InsertSubpipe(0,"rear_weaponAttack");
			else
				entity:InsertSubpipe(0,"rear_grenadeAttack");
				if (Game:IsMultiplayer()) then
				-- can be seen in client of survival dedicated server
				Server:BroadcastCommand("PLAA "..entity.id.." grenade");
				end
			end
		else
			entity:InsertSubpipe(0,"rear_weaponAttack");
		end


	end,

	OnEnemyMemory = function( self, entity )
	end,

	OnInterestingSoundHeard = function( self, entity )
		entity:SelectPipe(0,"rear_scramble");
	end,

	OnThreateningSoundHeard = function( self, entity )
		entity:SelectPipe(0,"rear_scramble");
	end,

	OnClipNearlyEmpty = function( self, entity )
		entity:SelectPipe(0,"rear_scramble");
	end,

	OnReload = function ( self, entity, sender)

	end,

	OnGroupMemberDied = function( self, entity )

	end,

	OnNoHidingPlace = function( self, entity, sender )
	end,	

	OnReceivingDamage = function ( self, entity, sender)
		if (entity.DROP_GRENADE==nil) then
			entity:SelectPipe(0,"rear_scramble");
		else
			entity:InsertSubpipe(0,"take_cover");
		end
		
	end,

	OnBulletRain = function ( self, entity, sender)
	end,

	OnCoverRequested = function ( self, entity, sender)
	end,

	OnDeath = function ( self, entity, sender)
		AIBehaviour.DEFAULT:OnDeath(entity,sender);

		if entity.DROP_GRENADE and entity.GrenadeType then
			if entity.Ammo[entity.GrenadeType] then
				local gnd = Server:SpawnEntity(entity.GrenadeType);
				if (gnd) then
					gnd:Launch(nil,entity,entity:GetPos(),{x=0,y=0,z=0},{x=0,y=0,z=-0.001});
				end
			end
		end
	end,

	OnGrenadeSeen = function( self, entity, fDistance )

		AI:Signal(SIGNALID_READIBILITY, 1, "GRENADE_SEEN",entity.id);
		entity:InsertSubpipe(0,"grenade_run_hide");
	end,

	EXCHANGE_AMMO = function (self, entity,sender)
		entity:StartAnimation(0,"sgrenade",1);
	end,

	GRANADE_OUT = function (self, entity, sender)
		entity.DROP_GRENADE = nil;
	end,

	REAR_NORMALATTACK = function (self, entity, sender)
		entity:SelectPipe(0,"rear_comeout");
		entity.DROP_GRENADE = nil;
	end,
	
	MUTANT_NORMAL_ATTACK = function ( self, entity, sender)
		entity:SelectPipe(0,"rear_comeout");
		entity.DROP_GRENADE = nil;
	end,

	REAR_SELECTATTACK = function (self, entity, sender)
	end,

	HEADS_UP_GUYS = function (self, entity, sender)
		entity.RunToTrigger = 1;
	end,

	OnGroupMemberDied = function( self, entity, sender)
	end,

	OnGroupMemberDiedNearest = function ( self, entity, sender)
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

	OnCloseContact = function (self,entity,sender)
	-- COOL MELEE DODGE TACTICS (VS MUTANT/MELEE AI)
	if (sender.MUTANT) then
	entity:SelectPipe(0,"mutant_cover_backoffattack");
	entity:InsertSubpipe(0,"setup_combat"); end
	end,

	ASSAULT_PHASE = function (self, entity, sender)
	end,

	GROUP_NEUTRALISED = function (self, entity, sender)
	end,
}
