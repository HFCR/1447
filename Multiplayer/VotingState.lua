--Voting code for MP By Alberto based on Wouter's code

VotingState={
	timeout = 0,
	command = "",
	arg1 = "",
	votes = {},
	lastvoter = "",
	numvotes = 0,
	firstvotetime = 0,
}

function VotingState:OnCallVote(server_slot, command, arg1)
	if _time<self.timeout then
		server_slot:SendText("@VoteInProgress");
		return
	end
	
	local CmdStruct=GameCommands[command];
	
	if CmdStruct==nil then
		server_slot:SendText("@VoteUnknCommand");
		local coms = "";
		for name, impl in GameCommands do
		    coms = coms.." "..name;
		end
		server_slot:SendText("@ListOfVoteCmd "..coms);
		return
	end

	-- \return nil=call is not possible, otherwise the vote has started
	if( not CmdStruct.OnCallVote(CmdStruct,server_slot,arg1) )then
		return;
	end
	
	-- check for vote spamming ----- ripped out by Mixer, because CIS players like to vote often for various gamestyles
	-- the variables below are saved to keep compatibility
	self.lastvoter = server_slot:GetName();
	self.numvotes = 1;
	self.firstvotetime = _time;
	--------

	-- initiate vote
	self.inprogress = 1;
	self.command = command;
	self.arg1 = arg1;
	self.timeout = _time+60;   -- vote lasts 1 minute?
	setglobal("gr_votetime",self.timeout);
	self.votes = {};

	Server:BroadcastCommand("VOT "..ceil(self.timeout-_time).." "..command.." "..arg1.." 1 0");
	Server:BroadcastText("@VoteWasCalld2 "..self.lastvoter);

	-- player that does callvote automatically does "vote yes"
	self:OnVote(server_slot, 1);
end

function VotingState:OnVote(server_slot, vote)
	local svote = "yes";
	if vote==0 then
		svote = "no"
	end

	local id = server_slot:GetId();

	if _time>self.timeout then
		server_slot:SendText("@NoVoteInProgress");
		return
	end

	-- cast the vote
	self.votes[id] = vote;

	local infavor = 0;
	local rejected = 0;
	local total = count(Server:GetServerSlotMap());

	if total==0 then
		System:LogToConsole("vote: no players?");
		return
	end

	-- count the votes
	for pid, pvote in self.votes do
		if pvote==1 then
			infavor = infavor+1;
		else
			rejected = rejected+1;
		end
	end

	if infavor/total > 0.5 then
		--Server:BroadcastText("@VotePassed "..self.command.." with "..infavor.."/"..total.." votes");
		Server:BroadcastCommand("VOT -3 "..self.command.." "..self.arg1.." "..infavor.." "..rejected);
		self.timeout = 0;
	        infavor = 0;
		rejected = 0;
		self.numvotes = 0;
		self.firstvotetime = 0;
		setglobal("gr_votetime",self.timeout);
		local fun = GameCommands[self.command].OnExecute;
		fun(GameCommands[self.command]);
	elseif (infavor+rejected >= total) then
		Server:BroadcastCommand("VOT");
		self.timeout = 0;
	        infavor = 0;
		rejected = 0;
		self.numvotes = 0;
		self.firstvotetime = 0;
		setglobal("gr_votetime",self.timeout);
	else
		Server:BroadcastCommand("VOT "..ceil(self.timeout-_time).." "..self.command.." "..self.arg1.." "..infavor.." "..rejected);
	end
end

function VotingState:new()
	return new(VotingState);
end