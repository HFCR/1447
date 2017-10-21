-- fixed by Jeppa (and Mixer)
Script:LoadScript("scripts/Multiplayer/ClientStuffClassLib.lua");							-- derive functionality
Script:LoadScript("scripts/ASSAULT/shared.lua");

ClientStuff.SndIdAvertCapture=Sound:LoadSound("Sounds/Items/seek.wav");				-- sound id, for a Multiplayer hit, cannot be local because of garbage collector	


function ClientStuff:ModeDesc()
	return "Assault";
end



--------------------------------------------
function ClientStuff:UpdateScoreboard()
	if not ClientStuff.idScoreboard then
		System:Log("Error: ASSAULT idScoreboard is nil");
		return;
	end

	if ScoreBoardManager:IsVisible()==0 then
		return;
	end
	
	ScoreBoardManager.ClearScores();

	-- set score board fields
	self.scoreFields={ 		
		[0]="@ScoreBoardClass",	
		[1]="@ScoreBoardKills",
		[2]="@ScoreBoardSupport",
		[3]="@ScoreBoardScore",
		[4]="@ScoreBoardPing",
	};		
	ScoreBoardManager:SetBoardFields(self.scoreFields);
	
	local SBEntityEnt = System:GetEntity(ClientStuff.idScoreboard);
	if (SBEntityEnt) and (SBEntityEnt.cnt) then
	local SBEntity = SBEntityEnt.cnt;

	local iY,X;
	local iLines=SBEntity:GetLineCount();
	local iColumns=SBEntity:GetColumnCount();
	
	for iY=0,iLines-1 do
		local idThisClient = tonumber(SBEntity:GetEntryXY(ScoreboardTableColumns.ClientID,iY));
		if (idThisClient) and (idThisClient ~= 0) then
			local iPlayerScore=SBEntity:GetEntryFloatXY(ScoreboardTableColumns.iPlayerScore,iY);
			local iSupportScore=SBEntity:GetEntryFloatXY(ScoreboardTableColumns.iSupportScore,iY);
			local iTotalScore=SBEntity:GetEntryFloatXY(ScoreboardTableColumns.iTotalScore,iY);
			local iPlayerClass=SBEntity:GetEntryFloatXY(ScoreboardTableColumns.iPlayerClass,iY);
			local iPlayerTeam=SBEntity:GetEntryFloatXY(ScoreboardTableColumns.iPlayerTeam,iY);
			local szName=SBEntity:GetEntryXY(ScoreboardTableColumns.sName,iY);
			local iPing=SBEntityEnt.PingTable[idThisClient-1];
	
			if not iPing then
				iPing="BOT";
			end
				
			local sTeam="spectators";
			local sType="Player";
			
			if iPlayerTeam==0 then
				sType="Spectator";
			elseif iPlayerTeam==1 then
				sTeam="red";
			elseif iPlayerTeam==2 then
				sTeam="blue";
			end

			-- set player score table
			local playerScore={ 
				[1]= { iVal=iPlayerScore, iSort=1 }, -- kills core, sort by bigger
				[2]= { iVal=iSupportScore, iSort=1 }, --
				[3]= { iVal=iTotalScore, iSort=1 }, --
				[4]= { iVal=iPing, iSort=0 },  -- ping, sort by smaller
				sortby= { [1]=3, [2]=1, [3]=2}, -- set sort order fields
				class=iPlayerClass,
				team=sTeam,
				type=sType,
				name=szName,
				ready=1,
			};
			ScoreBoardManager:SetPlayerScore(playerScore);		
		end
	end
	end
end

---------------------------------------------------------------------------------
-- Avert Caprture sound playback
-- e.g. "AVC" 
ClientStuff.ServerCommandTable["AVC"]=function(String,toktable)
	Sound:PlaySound(ClientStuff.SndIdAvertCapture);
end;