-- linear patroling behaviour - 
--Each character will patrol a set of TagPoints in a linear way ie 1 2 3 4 5 4 3 2 1 etc

--The character will approach each TagPoint sequentialy, look in the direction of the current TagPoint, 
--make some idles and look around. After the last TagPoint he will return to his first point and start again.
-- created by Flameknight7
--------------------------

AIBehaviour.Job_PatrolMulti = {
	Name = "Job_PatrolMulti",
	JOB = 1,
	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity )
		entity:InitAIRelaxed();
		entity.AI_PathStep = 0;
		entity.AI_SignIncrement = 1;
		local rname = entity:GetName();
		AI:CreateGoalPipe("JobPatrolPath");
		AI:PushGoal("JobPatrolPath","pathfind",1,rname.."_PATH");
		AI:PushGoal("JobPatrolPath","trace",1,1);
		AI:PushGoal("JobPatrolPath","signal",0,1,"TRY_TO_FIND_IDLE",0);
		AI:CreateGoalPipe("JobPatrolRun");
		AI:PushGoal("JobPatrolRun","run",0,1);
		AI:PushGoal("JobPatrolRun","pathfind",1,rname.."_PATH");
		AI:PushGoal("JobPatrolRun","trace",1,1);
		AI:CreateGoalPipe("JobIdlePath");
		AI:PushGoal("JobIdlePath","pathfind",1,rname.."_PATH");
		AI:PushGoal("JobIdlePath","trace",1,1,1);
		AI:PushGoal("JobIdlePath","signal",0,1,"DO_SOMETHING_IDLE",0);
		AI:PushGoal("JobIdlePath","branch",1,-2);
		local CheckPoint = Game:GetTagPoint(rname.."_RANDOM");
		if (CheckPoint~= nil) then
			local rname = entity:GetName();
			while Game:GetTagPoint(rname.."_P"..entity.AI_PathStep) do
				entity.AI_PathStep=entity.AI_PathStep+1;
			end
		end
		self:PatrolPath(entity);
	end,

	OnJobContinue = function(self,entity )
		entity:InitAIRelaxed();
		self:PatrolPath(entity);
	end,
	---------------------------------------------		
	OnBored = function (self, entity)
		entity:MakeRandomConversation();
	end,
	----------------------------------------------------FUNCTIONS 
	PatrolPath = function (self, entity, sender)
		-- select next tagpoint for patrolling
		local name = entity:GetName();
		local tpname = name.."_P"..entity.AI_PathStep;
		local RandomPoint = Game:GetTagPoint(name.."_RANDOM");
		if (RandomPoint== nil) then
			local PatrolPoint = Game:GetTagPoint(name.."_RUN");
			if (PatrolPoint== nil) then
				local TagPoint = Game:GetTagPoint(name.."_WALKPATH");
				if (TagPoint== nil) then
					local RunPoint = Game:GetTagPoint(name.."_RUNPATH");
					if (RunPoint== nil) then
						entity:SelectPipe(0,"JobPatrolPath");
						entity:InsertSubpipe(0,"setup_idle");
					else
						entity:SelectPipe(0,"JobPatrolRun");
					end
				else
					entity:SelectPipe(0,"JobIdlePath");
					entity:InsertSubpipe(0,"setup_idle");
				end
			else
				entity:SelectPipe(0,"patrol_rush_to",tpname);
				entity.AI_PathStep = entity.AI_PathStep + entity.AI_SignIncrement;
			end
		else
			local rnd=random(0,entity.AI_PathStep);
			if (rnd==self.PreviousSelectedPoint) then
				if (rnd<entity.AI_PathStep) then 
					rnd = rnd+1;
				elseif (rnd>0) then 
					rnd = rnd-1;
				end
			end
			entity:SelectPipe(0,"patrol_approach_to",entity:GetName().."_P"..rnd);
			self.PreviousSelectedPoint = rnd;
		end
	end,
	------------------------------------------------------------------------
	-- GROUP SIGNALS
	------------------------------------------------------------------------
	BREAK_AND_IDLE = function (self, entity, sender)
	end,
	------------------------------------------------------------------------	
}

 