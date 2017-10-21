--   Test bot v2.6 - behavior
--   by Mixer, 2009,
AIBehaviour.TestBotIdle = {
	Name = "TestBotIdle",
	OnSpawn = function ( self, entity, sender)
		--System:LogAlways(entity:GetName().." OnSpawn");
		-- i need to know, what pickups are placed on this map:
		entity:GetBotPickups();

		-- i'm looking for nearest weapon. if i've just lost some baddy, i'm carefully approching
		-- the pickup, if not, i'm just running for pickup. if pickup can't be found, then go to on no target tactic.
		local nearestgun=AI:FindObjectOfType(entity.id,110,AIAnchor.GUN_RACK);
		if (nearestgun) then
			nearestgun = System:GetEntityByName(nearestgun);
			if (nearestgun) and (nearestgun.GetState) and (nearestgun:GetState() == "Active") then
				if (entity.lose_target) then
					entity.lose_target=nil;
					entity:SelectPipe(0,"bot_combat",nearestgun.id);
				else
					entity:SelectPipe(0,"bot_roam",nearestgun.id);
				end
				return;
			end
		end
		self:TRY_NEXT(entity);
	end,

	OnNoHidingPlace = function (self,entity,sender)
		--System:LogAlways(entity:GetName().." OnNoHidingPlace");
		-- i can't find where to hide, so i need to do something special
		if (entity:ISeeTarget()) and (entity.bot_engaging) then
		-- Wow, i'm still see my enemy...
			local rd=random(1,5);
			if (entity.fireparams) and (entity.fireparams.distance) then
			-- i have a gun? what is it?
				if (entity.fireparams.distance>900) and (entity.fireparams.railed == nil) then
					-- something like sniper rifle! let's go crouch and try to split apart some brains
					entity:SelectPipe(0,"setup_crouch");
					return
				end
			end
			if (rd == 5) and (entity.bot_memnpc.GetDistanceFromPoint) then
				-- case 5 of 5? how long my enemy (entity.bot_memnpc) from me?
				rd = entity.bot_memnpc:GetDistanceFromPoint(entity:GetPos());
				if (rd > 19) and (not entity.cnt.flying) then
					-- enemy is long enough and i'm standing, so i want to lay down
					entity:SelectPipe(0,"setup_prone");
				else
					-- enemy is close, it's bad idea to lay down, so i want to crouch
					entity:SelectPipe(0,"setup_crouch");
				end
				return
			end
		end
		-- case 1-4? let's strafing a bit
		rd=random(1,4);
		entity:SelectPipe(0,"crowe_dodge_"..rd);
	end,
	
	-- Verysoft bots func for assault actions (blowing/repairing buildables). To blow some buildable, bot looks for tag point buildablename_BLOW located nearby the buildable and shoots it/throws a grenade
	-- requires GameRules.bot_common.bot_goals table. To get it, please run bot:GetBotPickups() func (see above)
	HaveSomeFun = function (self,entity)
		--System:LogAlways(entity:GetName().." HaveSomeFun");
		if (GameRules.bot_common.bot_goals == nil) then
			return;
		end
		local im_free = 1;
		for i, goal in GameRules.bot_common.bot_goals do
			local goalent = System:GetEntity(goal);
			if (goalent) then
				local obj_name = goalent:GetName().."_BLOW";
				local goal_pos = Game:GetTagPoint(obj_name);
				if (goal_pos == nil) then
					obj_name = goalent:GetName().."_BUILD";
					goal_pos = Game:GetTagPoint(obj_name);
				end
				if (goal_pos) then
					goal_pos = entity:GetDistanceFromPoint(goal_pos);
					if (GameRules:IsDefender(entity) == nil) and (goal_pos < 12) and (goalent:GetState()=="built") and (goalent.Properties.max_hitpoints > 0) then
						-- I'M CLOSE TO SOME BUILDABLE OBJECT >:E
						if (im_free) then
							-- Damn Stupid action of Engineer:
							if (entity.bot_classnum==1) then
								entity.cnt:SetCurrWeapon(30);
								entity:SelectPipe(0,"practice_shot",obj_name);
								im_free = nil;
							-- How Grunt works:
							elseif (entity.bot_classnum==0) and (entity.cnt.numofgrenades>0) then
								entity:SelectPipe(0,"unconditional_grenade");
								entity:InsertSubpipe(0,"DropBeaconAt",obj_name);
								im_free = nil;
							-- How Sniper works:
							elseif (entity.cnt.weapon) and (entity.cnt.weapon.name=="RL" or entity.cnt.weapon.name=="RailBow") then
								entity:SelectPipe(0,"practice_shot",obj_name);
								im_free = nil;
							end
						end
					elseif (GameRules:IsDefender(entity)~=nil) and (entity.bot_classnum==1) then
						if (goal_pos < 50) then
							local gentsta = goalent:GetState();
							if (gentsta~="built") and (im_free) then
								if (goalent.Properties.max_buildpoints <= 0) and (gentsta=="unbuilt" or gentsta=="building") then
									-- engineer mustn't try to build unbuilt objects, which should be constructed from standalone kits
								elseif (goalent.vbot_toucher) and (goalent.vbot_toucher.id ~= entity.id) and (_time-3 < goalent.vbot_toucher.tme) then
									-- another bot engineer already get busy with this, dont disturb
								elseif (goalent:IsCollisionFree() == nil) then
									-- object is obstructed by someone, skip it for now
								elseif (goal_pos < WeaponsParams.EngineerTool.Std[1].distance) then
									-- object is within the range of engineer tool, let's try to build/repair it
									entity.bot_buildr = {tme = _time*1,ob_id = goalent.id * 1};
									entity.cnt:SetCurrWeapon(27);
									goalent.vbot_toucher = { id = entity.id*1, tme = _time*1};
									im_free = nil;
									return 1;
									-- busy. don't bother with other nearby buildables if 'for' cycle finds them!
								else
									-- let's get close to the chosen object to repair/build it
									entity.bot_buildr = nil;
									entity.bot_engaging = nil;
									entity:SelectPipe(0,"bot_roam",obj_name);
									im_free = nil;
									-- busy. don't bother with other nearby buildables if 'for' cycle finds them!
								end
							end
						end
					end
				end
			end
		end
	end,

	OnClipNearlyEmpty = function(self,entity,sender)
		--System:LogAlways(entity:GetName().." OnClipNearlyEmpty");
		-- Damn, my gun is about to dry! Let's hide!
		entity:SelectPipe(0,"bot_hide");
	end,

	OnNoTarget = function(self,entity)
		--System:LogAlways(entity:GetName().." OnNoTarget");
		-- I just lost my enemy, so forgot about it
		if (entity.bot_memnpc) then
			entity.bot_memnpc=nil;
			entity:TriggerEvent(AIEVENT_CLEAR); -- prevents stack overflow if bot sees many other bots at once (?)
			--System:LogAlways(entity:GetName().." !! CLEAR EVENT !!");
		end
		
		if (entity.current_mounted_weapon) then
			-- What? I'm operating a mounted gun? let's abort it:
			entity.current_mounted_weapon:AbortUse();
		end
		
		-- let's remember, if some armor is present nearby:
		local armorpick=AI:FindObjectOfType(entity.id,120,AIAnchor.MORPH_HERE);
		-- let's remember, if some health is present nearby:
		local healthpick=AI:FindObjectOfType(entity.id,120,AIAnchor.SNIPER_POTSHOT);
		if (healthpick) and (entity.cnt.health < (entity.cnt.max_health/3.3)) then
		-- i needed it :) i want to be healthy and beautiful!
			entity:SelectPipe(0,"bot_roam",healthpick);
		elseif (armorpick) and (entity.cnt.armor < (entity.cnt.max_armor/2)) then
		-- wow, it is and i have less than half or my maximum available armor! let's run to get it!
			entity:SelectPipe(0,"bot_roam",armorpick);
		else
			self:TRY_NEXT(entity);
		end
		if (entity.bot_lastchattime) and (entity.bot_lastchattime > _time) then
		else
			local msg = random(1,10);
			Server:BroadcastCommand("ACWR "..entity.id.." "..msg);
			entity.bot_lastchattime = _time + 20;
		end
	end,

	OnLowHideSpot = function( self, entity, sender)
	--System:LogAlways(entity:GetName().." OnLowHideSpot");
		-- haha! i found a low hide spot, maybe even a mounted gun nearby?
		if (self:LOOKFORMOUNTEDGUN(entity,3) == 1) then return; end
		-- let's crouch
		entity:SelectPipe(0,"crouchfire");
	end,

	TRY_NEXT = function(self,entity)
		-- it's my generic function, to resume my action after previous ones
		--System:LogAlways(entity:GetName().." TRY_NEXT");
		-- update info about available pickups:
		entity:GetBotPickups();
		
		if (self:OnAssaultGame(entity)~=nil) then
			-- i'm playing Assault game? Let's blow up something :E
			self:HaveSomeFun(entity);
			return;
		end
		
		if (GameRules.TaskForBot) and (GameRules:TaskForBot(entity)~=nil) then
			-- i'm performing specific task dictated by gametype
			return;
		end

		local ctfstatus = self:OnCTFGame(entity);
		-- i'm playing CTF game?
		if (ctfstatus) then
			return;
		end
		
		if (not GameRules.bot_common.bot_pickups) then
			return;
		end

		local botitm = getn(GameRules.bot_common.bot_pickups);
		
		if (botitm < 1) then
			-- no pickups? do nothing
			return
		end;
		
		botitm=random(1,botitm);
		-- avoid repeating of currently selected pickup
		if entity.bot_lastpick == GameRules.bot_common.bot_pickups[botitm] then
			if botitm < getn(GameRules.bot_common.bot_pickups) then
				botitm=botitm+1;
			else
				botitm=1;
			end
		end
		entity.bot_lastpick= GameRules.bot_common.bot_pickups[botitm] * 1;
		
		if (entity:ISeeTarget()) then
		-- i see an enemy
			if (entity.fireparams) and (entity.fireparams.type) and (entity.fireparams.type > 1) then
			-- i have bad gun, i want to get better one
				local nearestgun = AI:FindObjectOfType(entity.id,20,AIAnchor.GUN_RACK);
				if (nearestgun) then
					nearestgun = System:GetEntityByName(nearestgun); 
					if (nearestgun) and (nearestgun.GetState) and (nearestgun:GetState() == "Active") then
						-- carefully approaching gun, don't turning away from my enemy
						entity.bot_engaging = nil;
						entity:SelectPipe(0,"bot_combat",nearestgun.id);
						entity.bot_lastpick = nearestgun.id * 1;
						return;
					end
				end
			end
			-- i have decent gun, then just go to any pickup, don't turning away from my enemy
			entity:SelectPipe(0,"bot_combat",GameRules.bot_common.bot_pickups[botitm]);
		else
			-- everything is ok. just trying to get ANY pickup
			entity:SelectPipe(0,"bot_roam",GameRules.bot_common.bot_pickups[botitm]);
		end
	end,

	OnPlayerSeen = function( self, entity, fDistance )
		--System:LogAlways(entity:GetName().." OnPlayerSeen");
		-- i see an enemy!
		if (entity:ISeeTarget()) then
			if (GameRules.bIsTeamBased) then
			-- it's team based game
				if (entity.bot_memnpc.bot_teamname==nil) then
					-- i see hostile player, and it is not bot like me!
					if (Game:GetEntityTeam(entity.bot_memnpc.id)==entity.bot_teamname) then
						-- hey, he is from my team! let's make him my friend!
						entity.bot_memnpc.Properties.groupid=entity.bot_team;
						entity.bot_memnpc.Properties.species=entity.bot_team;
						AI:RegisterWithAI(entity.bot_memnpc.id,AIOBJECT_PLAYER,entity.bot_memnpc.Properties);
						-------------
						--Server:BroadcastCommand("ACWR "..entity.id.." "..random(1,8));
						--------------
						-- return species back to avoid lost of players on radar!
						entity.bot_memnpc.Properties.species=0;
						return
					end
				end
			end
		end -- i see target
		
		if (entity.ladder) or (entity.cnt:IsSwimming()) then
			return;
		end
	
		-- let's restore attack range, if was set to 0 on approaching some survivor
		if (entity.go2friend) then
			entity:ChangeAIParameter(AIPARAM_ATTACKRANGE,entity.Properties.attackrange);
			entity.go2friend = nil;
		end
		
		entity.bot_buildr = nil;
		
		if (entity.current_mounted_weapon) then return end;

		-- is there a mounted gun at some distance? let's approach/grab it!
		if (self:LOOKFORMOUNTEDGUN(entity,(fDistance / 3)) == 1) then return; end
		
		------------------------------------------------ TST TS T TST
		if (entity.fireparams) and (entity.fireparams.type) and (entity.fireparams.type > 1) then
		-- i have bad gun, i want to get better one
			local nearestgun = AI:FindObjectOfType(entity.id,fDistance/2,AIAnchor.GUN_RACK);
			if (nearestgun) then
				nearestgun = System:GetEntityByName(nearestgun);
				if (nearestgun) and (nearestgun.GetState) and (nearestgun:GetState() == "Active") then
					-- carefully approaching gun, don't turning away from my enemy
					entity.bot_engaging = nil;
					entity:SelectPipe(0,"bot_combat",nearestgun.id);
					entity.bot_lastpick = nearestgun.id * 1;
					return;
				end
			end
		end
		----------------------------------------------------------------------------

		entity.bot_engaging = 1;

		if (entity.fireparams) and (entity.fireparams.bullet_per_shot) and (entity.fireparams.bullet_per_shot > 1) then
			-- i have something like shotgun. so try to approch my enemy
			entity:SelectPipe(0,"hide_forward");
		else
			-- randomly hide
			if (entity.fireparams) and (entity.fireparams.distance) and (entity.fireparams.distance < fDistance * 0.9) then
				entity:SelectPipe(0,"scout_comeout");
			else
				entity:SelectPipe(0,"bot_hide");
			end
		end

		if (entity.cnt.grenadetype>1) and (entity.cnt.numofgrenades>0) then
			-- i have some frag grenades
			local gonnathrow=random(1,3);
			if (gonnathrow==2) and (fDistance>10 and fDistance<20) then
				if (GameRules.vblastgren == nil) then
					GameRules.vblastgren = 0;
				end

				if (GameRules.vblastgren < _time) then
					-- let's throw a grenade toward my enemy
					entity:SelectPipe(0,"bomb_the_beacon");
					if (Game:IsMultiplayer()) then
						-- can be seen in client of survival dedicated server
						Server:BroadcastCommand("PLAA "..entity.id.." grenade");
					end
					GameRules.vblastgren = _time + 1;
					return;
				end

			end
		end

		if (entity.fireparams) and (entity.fireparams.AmmoType=="Unlimited") then
			-- enemy spotted, but i have no decent weapon, so go to crazy attack
			entity:SelectPipe(0,"scout_comeout");
			if (not entity.fireparams.railed) then
				entity.bot_engaging = nil;
			end
		end
	end,

	OnGrenadeSeen = function( self, entity, fDistance )
	--System:LogAlways(entity:GetName().." OnGrenadeSeen");	
		if (entity.current_mounted_weapon) then
			entity.current_mounted_weapon:AbortUse();
		end
		entity:SelectPipe(0,"mutant_cover_backoffattack");
	end,

	OnEnemySeen = function( self, entity )
		--System:LogAlways(entity:GetName().." OnEnemyseen");	
	end,

	OnSomethingSeen = function( self, entity )
		--System:LogAlways(entity:GetName().." OnSomethingseen");	
	end,

	OnEnemyMemory = function( self, entity )
		--System:LogAlways(entity:GetName().." OnEnemyMemory");
		if (entity.bot_memnpc) then
			entity.bot_memnpc=nil;
			entity:TriggerEvent(AIEVENT_CLEAR); -- prevents stack overflow if bot sees many other bots at once (?)
			--System:LogAlways(entity:GetName().." !! CLEAR EVENT !!");

			entity.lose_target=1;
			-- DECISION TO RUSH TO FLAG

			if (GameRules.IsFlagCarrier) then
				if (GameRules:IsFlagCarrier(entity.bot_teamname,entity)) then
					-- i'm carrying an enemy flag!
					self:OnCTFGame(entity);
					return;
				end
			end
			
			-- If running with machete, then don't try to resume visual contact.
			if (entity.bot_engaging == nil) then return; end

			if (entity.fireparams) and (entity.fireparams.type) and (entity.fireparams.type > 1) then
				AI:Signal(0,1,"TRY_NEXT",entity.id);
			else 
				entity:SelectPipe(0,"scout_comeout");
			end
		end
	end,

	OnInterestingSoundHeard = function(self,entity,fDistance)
		--System:LogAlways(entity:GetName().." OnInterestingsoundheard");	
		if (entity:ISeeTarget()) then return; end
		if (entity.bot_engaging == nil) then return; end
		if (entity.ladder) then return end
		if (fDistance>15) and (entity.fireparams) and (entity.fireparams.type) and (entity.fireparams.type > 1) then
			AI:Signal(0,1,"TRY_NEXT",entity.id);
		else
			-- NOTE TEST READY GUN
			if (fDistance<10) then
				entity:SelectPipe(0,"bot_hide");
			else
				entity:SelectPipe(0,"cover_beacon_pindown");
			end
			--entity:SelectPipe(0,"DropBeaconAt");
		end
	end,
	----
	--FINISH_RUN_TO_FRIEND = function ( self, entity, sender)
	--	self:OnNoTarget(entity);
	--end,
	--SCOUT_NORMALATTACK = function ( self, entity, sender)
		--AI:Signal(0,1,"TRY_NEXT",entity.id);
	--end,
	
	MUTANT_NORMAL_ATTACK = function ( self, entity, sender)
		--System:LogAlways(entity:GetName().." MUTANT_NORMAL_ATTACK");
		self:OnNoTarget(entity);
	end,

	OnThreateningSoundHeard = function(self,entity,fDistance)
		--System:LogAlways(entity:GetName().." ONTHreateningsoundheard");	
		if (entity:ISeeTarget()) then return; end
		if (entity.bot_engaging == nil) then return; end
		if (entity.ladder) then return end
		if (entity.fireparams) and (entity.fireparams.type)  and (entity.fireparams.type > 1) then
			AI:Signal(0,1,"TRY_NEXT",entity.id);
		else
			-- NOTE TEST READY GUN
			if (fDistance<12) then
				entity:SelectPipe(0,"bot_hide");
				--entity:SelectPipe(0,"DropBeaconAt");
			else
				if (self:OnAssaultGame(entity)==nil) then
					if (GameRules.IsFlagCarrier) then
						if (GameRules:IsFlagCarrier(entity.bot_teamname,entity)) then
							-- i'm carrying an enemy flag!
							self:OnCTFGame(entity);
							return;
						end
					end
					if (self:LOOKFORMOUNTEDGUN(entity,(fDistance / 3)) == 1) then return; end
					entity:SelectPipe(0,"scout_comeout");
				end
			end
		end
	end,
	
	OnReload = function( self, entity )
		--System:LogAlways(entity:GetName().." Onreload");	
		if (entity:ISeeTarget()) then
			entity:SelectPipe(0,"bot_hide");
		end
	end,

	OnGroupMemberDied = function( self, entity )
	end,

	OnNoFormationPoint = function ( self, entity, sender)
	end,
	
	OnKnownDamage = function ( self, entity, sender)
		if (entity.ladder) then return end
		if (entity.current_mounted_weapon) then
			if (entity.cnt.health < (entity.Properties.max_health / 2)) then
				entity.current_mounted_weapon:AbortUse();
			end
		end
		if (sender) and (random(1,2)==2) then
			entity:SelectPipe(0,"bot_hide");
			entity:InsertSubpipe(0,"DropBeaconAt",sender.id);
		end
	end,

	OnReceivingDamage = function ( self, entity, sender)
		if (entity.ladder) then return end
		if (entity.current_mounted_weapon) then 
			if (entity.cnt.health < (entity.Properties.max_health / 2)) then
				entity.current_mounted_weapon:AbortUse();
			end
		end
		entity:SelectPipe(0,"bot_hide");
		entity:InsertSubpipe(0,"look_around");
	end,

	OnCoverRequested = function ( self, entity, sender)
	end,

	OnCloseContact = function (self,entity,sender)
		--System:LogAlways(entity:GetName().." Onclosecontact");
		if (GameRules.soccerball) then
			return
		end
		if (sender) then
			-- IF RL THEN SWITCH IT OFF - IS DANGEROUS
			if (entity.fireparams) and (not entity.fireparams.distance) and (not entity.cnt:IsSwimming()) then
				entity.cnt:SelectNextWeapon();
			end
			local s_team = Game:GetEntityTeam(sender.id);
			if (s_team) then
				if (s_team == entity.bot_teamname) and (GameRules.bIsTeamBased or GameRules.SurvivalManager or GameRules.SetCoopMission) then
					return;
				end
			end
			-- COOL MELEE DODGE TACTICS (BOT VS MUTANT/MELEE AI)
			if (sender.MUTANT) or (sender.fireparams and sender.fireparams.type and sender.fireparams.type > 2) then
				entity:SelectPipe(0,"setup_combat");
				entity:SelectPipe(0,"mutant_cover_backoffattack");
			end
		end
	end,
	-----
	OnBulletRain = function ( self, entity, sender)
	--System:LogAlways(entity:GetName().." Onbulletrain");	
		if (entity:ISeeTarget()==nil) and (entity.bot_engaging) then
			entity:SelectPipe(0,"bot_hide");
		end
	end,

	OnAssaultGame = function(self,entity)
	if (not GameRules.MapCheckPoints) then return; end
	--System:LogAlways(entity:GetName().." Onassaultgame");	
	local ascpstate;
	local botitm;
	for i,cp in GameRules.MapCheckPoints do
	if (cp.Properties.bVisible == 1) then
		ascpstate=cp:GetState();
		if (ascpstate=="Untouched") or (ascpstate=="Warmup") or (ascpstate=="Capturing") then
			AI:RegisterWithAI(cp.id,AIAnchor.HOLD_THIS_POSITION);
				if (self:SMART_GO(entity,cp.id)==nil) then
					-- use DUMB GO METHOD :)
					entity:SelectPipe(0,"bot_roam",cp.id);
					GameRules.vb_ass_dest = cp.id * 1;
				end
				if ascpstate=="Capturing" then
					entity.bot_engaging = nil;
					if (GameRules:IsDefender(entity)) then
						entity.cnt.speedscale = 1.7;
						entity:SelectPipe(0,"run_to_trigger",cp.id);
					end
				elseif (entity.cnt.speedscale > 1) then
					entity.cnt.speedscale = 1;
				end
				return 1;
		else
			AI:RegisterWithAI(cp.id, 0);
		end --appropriate cp
	end --actual cp
	end --for cycle
	return nil;
	end,
	
	SMART_GO = function(self,entity,goal)
	--System:LogAlways(entity:GetName().." smartgo");	
		local g_pos = 0;
		local g_tp = Game:GetTagPoint(goal);
		-- retrieve the destination (tag point or entity);
		if (g_tp) then
			g_pos = {x=g_tp.x,y=g_tp.y,z=g_tp.z};
		else
			g_tp = System:GetEntity(goal);
			if (g_tp) then
				g_pos = new(g_tp:GetPos());
			else
				g_pos = nil;
			end
		end
		if (g_pos) then
			local desireddist = entity:GetDistanceFromPoint(g_pos);
			if (desireddist < 110) then
				-- it's nearby! go 4 it!
				entity:SelectPipe(0,"bot_roam",goal);
				return 1;
			else
				local desiredspot = 0;

				if (GameRules.bot_common.bot_pickups) and (getn(GameRules.bot_common.bot_pickups) > 0) then
					for i = getn(GameRules.bot_common.bot_pickups), 1, -1 do
						local ipick = System:GetEntity(GameRules.bot_common.bot_pickups[i]);
						if (ipick) then
							local ipick_mydist = new(ipick:GetPos());
							ipick_mydist = entity:GetDistanceFromPoint(ipick_mydist);
							if (ipick_mydist < 110) then
								ipick_mydist = ipick:GetDistanceFromPoint(g_pos);
								if (ipick_mydist < desireddist) then
									desireddist = ipick_mydist * 1;
									desiredspot = floor(ipick.id);
								end
							end
						end
					end
				end
				
				if (desiredspot ~= 0) then
					entity:SelectPipe(0,"bot_roam",desiredspot);
					return 1;
				end
			end
		end
		return nil;
	end,

	OnCTFGame = function(self,entity)
		if (not GameRules.IsFlagCarrier) then return; end
		local gotohomeflag = 0;
		local homeflag;
		local enemyflg;
		for i,val in GameRules.flags do
		-- register flags
		AI:RegisterWithAI(val.id,AIAnchor.HOLD_THIS_POSITION);
		
		if (val.Properties.team==entity.bot_teamname) then
		-- get my homeflag, and think about return it to home if it has been dropped
		homeflag = val.id * 1;
		if (val:GetState()=="Dropped") then
		gotohomeflag = 1;
		end
		else
		-- it's opponents' flag, if it has been captured, then i can go to home
		enemyflg = val.id * 1;
		if (val:GetState()=="Captured") then
		gotohomeflag = 2;
		end
		end
		end -- cycle
		
		if (gotohomeflag > 0) then
			gotohomeflag = self:SMART_GO(entity,homeflag);
		else
			gotohomeflag = self:SMART_GO(entity,enemyflg);
		end
		return gotohomeflag;
	end,
	
	OnSoccerGame = function(self,entity)
			if (GameRules.soccerball) then
				if (entity:GetDistanceFromPoint(GameRules.sb_pos) < 1.53) then
					-- bot football kick
					local myteam = Game:GetEntityTeam(entity.id);
					entity:SelectPipe(0,"practice_shot","botgoalspot_"..myteam);
					myteam = Game:GetTagPoint("botgoalspot_"..myteam);
					local destdir = new(entity:GetPos());
					destdir = DifferenceVectors(myteam,destdir);
					local angl = ({x=0,y=0,z=0});
					ConvertVectorToCameraAngles(angl,destdir);
					entity:SetAngles(angl);
					GameRules:RegisterSupport(entity);
					GameRules.last_toucher_id = entity.id * 1;
					if (GameRules.special_position) then
						GameRules.soccerball.cis_lastgrabberid = entity.id * 1;
						GameRules.soccerball.last_hold_time = _time * 1;
					end

					GameRules.soccerball:AddImpulse(-1,{x=GameRules.sb_pos.x,y=GameRules.sb_pos.y,z=GameRules.sb_pos.z-0.04},destdir,1350*0.2);
					entity.stop_my_talk = _time + 0.2;
					entity:StartAnimation(0,"asprintback",4);
				elseif (GameRules.hold_state==nil) then
					---------
					--- add goalkeeper check!
					------------
					entity:ChangeAIParameter(AIPARAM_ATTACKRANGE,0);
					entity:ChangeAIParameter(AIPARAM_SIGHTRANGE,0);
					entity:ChangeAIParameter(AIPARAM_SOUNDRANGE,0);
					entity:SelectPipe(0,"bot_dribble",GameRules.soccerball.id);
					--------------------------------------------
				end
				return 1;
			end
			return nil;
	end,
	

	OnVerifyPos = function(self,entity)
	--System:LogAlways(entity:GetName().." Onverifypos");	
	-- service function to avoid getting stuck somewhere + villagers calling in survival mode
	
	if (self:OnSoccerGame(entity)~=nil) then
		return;
	end
	
	if (self:HaveSomeFun(entity)~=nil) then
		return;
	end

	local vbotnewpos=entity:GetPos();
	
	-- if is villager nearby then call (engage) him forth to follow
	if (entity.vb_su_goal_subject) then
	local subject_g = System:GetEntity(entity.vb_su_goal_subject);
		if (subject_g) and (subject_g.cnt.health > 0) and (subject_g.my_leader==nil) then
			local subj_dist = new(subject_g:GetPos());
			subj_dist = entity:GetDistanceFromPoint(subj_dist);
			if (subj_dist < 1.8) then
				subject_g.my_leader = entity.id;
				entity.su_followers = subject_g.id;
				GameRules.talkerid = entity.id;
				GameRules:TransferTheStatus(4);
				GameRules.talkerid = nil;
				entity.vb_su_goal_subject = nil;
				self:TRY_NEXT(entity);
				return;
			end
		end
		entity.vb_su_goal_subject = nil;
	end

	if (entity.bot_lastposxy) and (vbotnewpos.x==entity.bot_lastposxy.x) and (vbotnewpos.y==entity.bot_lastposxy.y) then
		------ ladder anti-stuck
		if (entity.ladder) then
			entity:AddImpulseObj({x=0,y=0,z=1},650);
		elseif (not entity.cnt.flying) then
			entity:AddImpulseObj({x=0,y=0,z=1},140);
			entity:SelectPipe(0,"bot_hide");
		end
	else
		local nearestgun = AI:FindObjectOfType(entity.id,20,AIAnchor.GUN_RACK);
		if (nearestgun) then
			nearestgun = System:GetEntityByName(nearestgun);
			if (nearestgun) and (nearestgun.GetState) and (nearestgun:GetState() == "Active") then
				-- carefully approaching gun, don't turning away from my enemy
				entity:SelectPipe(0,"bot_combat",nearestgun.id);
				entity.bot_lastpick = nearestgun.id * 1;
			else
				AI:Signal(0,1,"TRY_NEXT",entity.id);
			end
		end
	end
	entity.bot_lastposxy=vbotnewpos;
	end,

	START_SWIMMING = function ( self, entity, sender)
		entity.bot_engaging = nil;
		local botequipment = entity.cnt:GetWeaponsSlots();
		if (botequipment) then
			for i,val in botequipment do
				if(val~=0) then
					local candidate_ammo = val.FireParams[1].AmmoType;
					if (candidate_ammo) and (candidate_ammo == "Unlimited") and (val.FireParams[1].shoot_underwater) then
						entity.cnt:SetCurrWeapon(WeaponClassesEx[val.name].id);
						if (val.FireParams[1].distance) then
							entity:ChangeAIParameter(AIPARAM_SIGHTRANGE,val.FireParams[1].distance * 1.3);
						else
							entity:ChangeAIParameter(AIPARAM_ATTACKRANGE,1);
							entity:ChangeAIParameter(AIPARAM_SIGHTRANGE,1.3);
						end
						return;
					end
				end
			end -- for
		end
		-- keeping stack clear :) prevent the swimming bot from see/attack anything
		entity:ChangeAIParameter(AIPARAM_ATTACKRANGE,0);
		entity:ChangeAIParameter(AIPARAM_SIGHTRANGE,0);
	end,

	STOP_SWIMMING = function ( self, entity, sender)
	end,

	-- GROUP SIGNALS

	KEEP_FORMATION = function (self, entity, sender)
	--System:LogAlways(entity:GetName().." keep_formation");	
	if (not entity.bot_memnpc) and (sender~=entity) then
	entity:Readibility("ORDER_RECEIVED",1);
	entity:SelectPipe(0,"cover_beacon_pindown");
	--entity:SelectPipe("DropBeaconAt",sender.id);
	end end,
	------------------
	BREAK_FORMATION = function (self, entity, sender)
		-- the team can split
	end,
	--------------
	SINGLE_GO = function (self, entity, sender)
		self:OnCTFGame(entity);
	end,

	GROUP_COVER = function (self, entity, sender)
		--System:LogAlways(entity:GetName().." group_cover");	
		if (GameRules.vb_ass_dest) and (GameRules:IsDefender(entity)) and (GameRules.vb_ass_go==nil) then
			entity.cnt.speedscale = 1.7;
			entity:SelectPipe(0,"run_to_trigger",GameRules.vb_ass_dest);
			GameRules.vb_ass_go = 1;
		else
			GameRules.vb_ass_go = nil;
		end
	end,

	IN_POSITION = function (self, entity, sender)
		-- some member of the group is safely in position
	end,

	GROUP_SPLIT = function (self, entity, sender)
	end,

	PHASE_RED_ATTACK = function (self, entity, sender)
		-- team leader instructs red team to attack
	end,

	PHASE_BLACK_ATTACK = function (self, entity, sender)
		-- team leader instructs black team to attack
	end,

	GROUP_MERGE = function (self, entity, sender)
	end,

	-------
	LOOKFORMOUNTEDGUN = function (self, entity, fdist)
		local guntogo = AI:FindObjectOfType(entity.id,fdist,AIOBJECT_MOUNTEDWEAPON);
		if (guntogo) then
			local guntogo_ent = System:GetEntityByName(guntogo);
			if (guntogo_ent) and (not guntogo_ent.user) then
				entity.bot_engaging = nil;
				entity.bot_thing_to_grab = guntogo_ent.id * 1;
				entity:SelectPipe(0,"bot_roam",guntogo_ent.id);
				return 1;
			end
		end
	end,
	-------
}
AICharacter.TestBot = {
TestBotIdle = {
OnPlayerSeen = "TestBotIdle",
START_SWIMMING = "TestBotIdle",
},
}