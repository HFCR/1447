-- Helocipter Behaviour SCRIPT
-- Improved by Mixer v1.0
-- FARMER JACK 2 ENHANCEMENT
AIBehaviour.Heli_attack = {
	Name = "Heli_attack",

	strafeDir = -1,

	-- SYSTEM EVENTS			-----
	OnSpawn = function(self,entity )
		System:LogToConsole("Heli_attack RECEIVED ON SPAWN");
	end,
	---
	OnNoTarget = function( self, entity )
		entity.seesPlayer = 0;
		self.advance(self,entity);
		do return end


	end,

	
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
	entity.seesPlayer = 0;	
	self.advance(self,entity);
	do return end
	end,
	---
	OnPlayerSeen = function( self, entity, fDistance )
	entity.seesPlayer = 1;
	if (entity.Properties.bFaceTarget) and (entity.Properties.bFaceTarget == 1) then
	entity:SelectPipe(0,"h_attack_f"); else
	entity:SelectPipe(0,"h_attack"); end
	end,
	---
	OnGrenadeSeen = function( self, entity, fDistance )
	entity:InsertSubpipe(0,"h_grenade_run_away" );	
	end,

	CHANGESTRAFE = function( self,entity, sender )
		if( entity.curStrafeDir<0 ) then
			entity.strafeDir = 3;
			entity:InsertSubpipe(0,"h_strafe_right" );
		else
			entity.strafeDir = -3;
			entity:InsertSubpipe(0,"h_strafe_left" );		
		end			
	
	end,

	
	STARTSTRAFE = function( self,entity, sender )

		entity:SetAICustomFloat( entity.Properties.fAttackAltitude );

		if( entity.strafeDir<0 ) then
			entity.curStrafeDir = -1;
			entity.strafeDir = entity.strafeDir + 2;
			entity:InsertSubpipe(0,"h_strafe_left" );
			else
			entity.curStrafeDir = 1;
			entity.strafeDir = entity.strafeDir - 2;
			entity:InsertSubpipe(0,"h_strafe_right" );
		end

	end,
	
	---
	advance = function( self,entity, sender )
	entity:SelectPipe(0,"h_attack_advance" );
	end,
	---
	NEXTPOINT_ATTACK = function( self,entity, sender )
	entity:SetAICustomFloat( entity.Properties.fAttackAltitude );	
	
	if(entity.seesPlayer == 1) then
	if (entity.Properties.bFaceTarget) and (entity.Properties.bFaceTarget == 1) then
	entity:SelectPipe(0,"h_attack_f"); else
	entity:SelectPipe(0,"h_attack"); end
		else	
		entity:SelectPipe(0,"h_attack_short" );
		end
	end,

	LAUNCH_DECISION = function( self,entity, sender )
	if (entity.TryToLaunchRocket) then
	entity:TryToLaunchRocket(); end
	end,

	LAUNCH_ALLOW = function( self,entity, sender )
	entity.can_launch_rockets = _time + 4;
	end,

	LAUNCH_DENY = function( self,entity, sender )
	entity.can_launch_rockets = nil;
	end,

	---
	REINFORCMENT_OUT = function( self,entity, sender )

		if( entity.Properties.attackrange>0 and entity.gunnerT~=nil and entity.gunnerT.entity~=nil ) then
			entity:Fly();		
			entity:SelectPipe(0,"h_gotoattack", entity.Properties.pointAttack);
		else				
			AI:Signal(0, 1, "GO_2_BASE",entity.id);	
		end	

	end,

	---
	GO_2_BASE = function( self,entity, sender )
		entity:SetAICustomFloat( entity.Properties.fFlightAltitude );	
	
		entity.EventToCall = "";
		entity:SelectPipe(0,"h_goto", entity.Properties.pointBackOff);
		entity:InsertSubpipe(0,"h_attack_stop" );
	end,

	---------------------------------------------
	BRING_REINFORCMENT = function( self,entity, sender )
		entity:SetAICustomFloat( entity.Properties.fFlightAltitude );	
	
		entity:SelectPipe(0,"h_drop", entity.Properties.pointReinforce);
		entity:InsertSubpipe(0,"h_attack_stop" );
		entity.EventToCall = "";
	end,


	---------------------------------------------
	low_health = function( self,entity, sender )
		AI:Signal(0, 1, "GO_PATH",entity.id);
		entity.EventToCall = "NEXTPOINT";
	end,

	---------------------------------------------
	GUNNER_OUT = function( self,entity, sender )
	
		if(entity:HasReinforcement() == 1)then
			AI:Signal(0, 1, "BRING_REINFORCMENT",entity.id);	
		else	
			AI:Signal(0, 1, "GO_2_BASE",entity.id);	
		end	

	end,

	---------------------------------------------
	GunnerLostTarget= function( self,entity, sender )
	
	if(not entity.attacking) then return end
	self:LAUNCH_DECISION(entity);
	entity:SelectPipe(0,"h_attack_advance" );

	end,

	----
	DRIVER_IN = function( self,entity, sender )
		entity:Fly();		
		entity:SelectPipe(0,"h_gotoattack", entity.Properties.pointAttack);
		entity.attacking = 1;

	end,	


	---
}
