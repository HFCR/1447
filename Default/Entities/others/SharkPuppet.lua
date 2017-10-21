SharkPuppet = {
	Properties = {
		Animation = "srunfwd",
		fileModel="Objects/characters/animals/GreatWhiteShark/greatwhiteshark.cgf",
		bPlaying=1,
		bAlwaysUpdate=1,
		sSharkReal = "",
		attachmet1={
			boneName="",
			fileObject="",
		},
		nmax_health = 255,
	},
};

function SharkPuppet:Event_StartAnimation(sender)
	self:StartAnimation(0,self.Properties.Animation);
end

function SharkPuppet:Event_RevealPuppet(sender)
	self:ResetAnimation(0);
	if (self.Properties.sSharkReal~="") then
		local sreal = System:GetEntityByName(self.Properties.sSharkReal);
		if (sreal) and (sreal.cnt) and (sreal.cnt.health) and (sreal.cnt.health > 0) then
			--sreal:SetPos(self:GetPos());
			--sreal:SetAngles(self:GetAngles());
			BroadcastEvent( self,"RevealPuppet" );
		end
	end
end

function SharkPuppet:OnReset()
	if (self.Properties.fileModel ~= "") then
		self:LoadCharacter(self.Properties.fileModel,0);
		self:CreateStaticEntity( 200, 0 );
		self:PhysicalizeCharacter(200, 0, 73, 0);
		self:DrawCharacter(0,1);
	end
	self.cis_shark = 1;
	if(self.Properties.attachmet1.fileObject ~= "") then
		self:LoadObject( self.Properties.attachmet1.fileObject, 0, 1);
		self:AttachObjectToBone( 0, self.Properties.attachmet1.boneName );
	end
	-- Physicalize the object and give it an initial velocity to clear player properly
	if (self.Properties.bPlaying == 1) then
		self:StartAnimation(0,self.Properties.Animation);
	else
		self:ResetAnimation(0);
	end
	if (self.Properties.bAlwaysUpdate == 1) then
		self:EnableUpdate(1);
		self:SetUpdateType( eUT_Unconditional );
	else
		self:EnableUpdate(0);
		self:SetUpdateType( eUT_Visible );
	end
	if (self.Properties.nmax_health) then
		self.curr_damage = self.Properties.nmax_health * 1;
	else
		self.curr_damage = 255;
	end
end

function SharkPuppet:Event_HideAttached(sender)
	self:DetachObjectToBone( self.Properties.attachmet1.boneName );	
end

function SharkPuppet:Event_ShowAttached(sender)
	self:AttachObjectToBone( 0, self.Properties.attachmet1.boneName );
end

function SharkPuppet:OnDamage(hit)
	if (self.curr_damage > 0) then
		self.curr_damage=self.curr_damage-hit.damage;
		if (self.curr_damage <= 0) then
			self.curr_damage = 0;
			if (Game:IsServer()) then
				if (self.Properties.sSharkReal~="") then
					local sreal = System:GetEntityByName(self.Properties.sSharkReal);
					if (sreal) then
						sreal:SetPos(self:GetPos());
						sreal:SetAngles(self:GetAngles());
						if (sreal.Event_Die) then
							sreal:Event_Die();
						end
					end
				end
				self:Event_OnDeath();
			end
		end
	end
end

function SharkPuppet:Event_CoopClientHide(sender)
	if (not Game:IsServer()) then
		self:DrawCharacter(0,0);
		self:DestroyPhysics();
		self.coopclienthidden =1;
	end
end

function SharkPuppet:Event_CoopClientShow(sender)
	if (not Game:IsServer()) and (self.coopclienthidden) then
		self:OnReset();
	end
	self.coopclienthidden = nil;
end

function SharkPuppet:OnPropertyChange()
	self:OnReset();
end

function SharkPuppet:Event_OnDeath()
	if (self.Properties.sSharkReal~="") then
		self:DrawCharacter(0,0);
		self:DestroyPhysics();
	else
		
	end
	BroadcastEvent(self, "OnDeath");
end

function SharkPuppet:OnInit()
	self:OnReset();
end

function SharkPuppet:OnShutDown()
end

function SharkPuppet:OnSave(stm)
	stm:WriteInt(self.curr_damage);
end

function SharkPuppet:OnLoad(stm)
	self.curr_damage = stm:ReadInt();
	if (self.curr_damage <=0) then
		self:DrawCharacter(0,0);
		self:DestroyPhysics();
	end
end