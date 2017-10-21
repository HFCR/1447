Script:ReloadScript( "SCRIPTS/Default/Entities/AI/OpasniyPozik_x.lua");

OpasniyPozik=CreateAI(OpasniyPozik_x)

function OpasniyPozik:Client_OnTimerCustom()
	if self.cnt and self.cnt.firing then
		self.op_pozik_phrasetime = _time + 6;
		if self.chattersounds == nil then
			self.chattersounds = new(self.chattersounds_c);
		end
	end
	if self.op_pozik_phrasetime and self.op_pozik_phrasetime > _time then
	else
		self.chattersounds = nil;
	end
end

OpasniyPozik.Client.OnInit = function(self)
	BasicAI.Client_OnInit(self);
	if self:GetMaterial()==nil then
		self:SetMaterial('Level.opasniy_pozik');
	end
	if Game:IsServer() == nil then
		self:PutHelmetOn(self.PropertiesInstance.fileHelmetModel);
	end
end

