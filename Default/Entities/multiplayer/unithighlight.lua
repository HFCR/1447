-- used to highlight friendly units in team muliplayer
-- optimized by Mixer
UnitHighlight = {
	idPlayerEntityId=nil,
	idPlayerTeam="",
}
-----
function UnitHighlight:OnInit()
	self:LoadObject( "Objects/multiplayer/teamSign/teamsign.cgf", 0, 1 );
	self:SetViewDistUnlimited();
	self:NetPresent(nil);
end
-----
function UnitHighlight:OnShutDown()
	if Server and self.idPlayerEntityId then
		Server:RemoveEntity(self.idUnitHighlight);
			
		local player = System:GetEntity(self.idPlayerEntityId);
		
		if player then
			player.idUnitHighlight=nil;
		end
		
		self.idPlayerEntityId=nil;
	end
end
-----
function UnitHighlight:OnUpdate( DeltaTime )
	if (self.idPlayer) then
		if (_localplayer) then
			if _localplayer.id==self.idPlayer.id then
				self:DrawObject( 0, 0 );
				return
			elseif Game:GetEntityTeam(_localplayer.id)~=self.idPlayerTeam then
				self:DrawObject( 0, 0 );
				return
			end
		local pos=new(self.idPlayer:GetPos());
		pos.z = pos.z + 2.5;
		self:SetPos(pos);
		self:DrawObject( 0, 1 );
		end
	end
end
--------
function UnitHighlight:OnRemoteEffect(toktable, pos, normal, userbyte)
	if count(toktable)==2 then
	 	self.idPlayerEntityId=tonumber(toktable[2]);
		self.idPlayerTeam=Game:GetEntityTeam(self.idPlayerEntityId);
		self.idPlayer=System:GetEntity(self.idPlayerEntityId);
	end
end