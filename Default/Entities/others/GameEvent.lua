GameEvent =
{
    Properties = { 
			nId = 1,
			nAllowedDeaths = 3,
			sUniqueName = "",
			bRespawnAtTagpoint=0,
		},

    Editor = { Model="Objects/Editor/Anchor.cgf", },
}

function GameEvent:OnInit()
end

function GameEvent:OnShutDown()
end

function GameEvent:Event_Save(sender)
	if (Game:IsServer()) then
		if (GameRules) and (Game:IsMultiplayer()) then
			GameRules.coop_checkpoint = self.Properties.nId + 1;
			if (sender) then
				GameRules.coop_spawn_object_id = floor(sender.id);
			else
				GameRules.coop_spawn_object_id = floor(self.id);
			end
			GameRules.coop_spawn_object_angles = new(self:GetAngles());
			if (Mission) and (Mission.OnCoopSave) then
				Mission:OnCoopSave(self.Properties.nId);
			end
			Server:BroadcastCommand("SSP");
			return;
		elseif (not UI) then
			if (Game:IsClient()) and (Hud) then
				if (Hud.checkpointreachedsnd == nil) then
					Hud.checkpointreachedsnd = Sound:LoadStreamSound("sounds/items/cis_sec.ogg");
				end
				if (Hud.checkpointreachedsnd) then
					Sound:SetSoundVolume(Hud.checkpointreachedsnd,200);
					Sound:PlaySound(Hud.checkpointreachedsnd);
				end
				System:Warning("Game saved. Checkpoint id is "..self.Properties.nId);
			end
		end
		self:EnableSave(nil);
		self.bSaveNow = nil;
		self:SetTimer(100);
	end
end

function GameEvent:OnTimer()

	if (_localplayer.timetodie) then return end
	if (self.bSaveNow) then
		self.bSaveNow = nil;
		-- if in the vehicle - can't save at respawnPoint pos/angles  
		if (self.Properties.bRespawnAtTagpoint==1 and _localplayer.theVehicle==nil ) then
			_LastCheckPPos = new (self:GetPos());
			_LastCheckPAngles = new(self:GetAngles());
		else
			_LastCheckPPos = new (_localplayer:GetPos());
			_LastCheckPAngles = new(_localplayer:GetAngles(1));
		end

		self:KillTimer();
		AI:Checkpoint();
	
		if (self.Properties.sUniqueName ~= "") then 
			if (ALLOWED_DEATHS) then 
				if (ALLOWED_DEATHS[self.Properties.sUniqueName]) then
					AI:SetAllowedDeathCount(ALLOWED_DEATHS[self.Properties.sUniqueName].deaths);
				end
			end
		else
			AI:SetAllowedDeathCount(self.Properties.nAllowedDeaths);
		end

		--Game:TouchCheckPoint(self.Properties.nId, _LastCheckPPos, _LastCheckPAngles);
		local cp_savbasename = strlower(Game:GetLevelName());
		if (Mission) and (Mission.save_mission) then
			cp_savbasename = cp_savbasename.."_"..Mission.save_mission;
		else
			if (DEFIANT) then
				for i, Table in DEFIANT do
					if (Table[1] == cp_savbasename) then
						if (Table[2]) and (Table[2] ~= "") then
							cp_savbasename = cp_savbasename.."_"..Table[2];
							self.bMissionDefined_defiant = 1;
							break;
						end
					end
				end
			end
			if (self.bMissionDefined_defiant) then
				self.bMissionDefined_defiant = nil;
			else
				cp_savbasename = cp_savbasename.."_"..Game:GetMapDefaultMission(cp_savbasename);
			end
		end

		cp_savbasename = strlower("checkpoint_"..cp_savbasename.."_"..self.Properties.nId);
		Game:Save(cp_savbasename);
		--- Mixer: make entry in save base ---
		local savbase_date = "";
		for i, val in Game:GetModsList() do
			if (val.CurrentMod) then
				savbase_date = val.Folder.."/";
				break;
			end
		end

		local sav_datetime = date("%Y%m%d%H%M%S")..strlower(Game:GetLevelName());
		if (UI) then
			UI:Ecfg(savbase_date.."Levels/sav_base.ini",cp_savbasename,sav_datetime);
		end

		if (Game.OnAfterSave) then
			Game:OnAfterSave();
		end
	else
		if (Game.OnBeforeSave) then
			Game:OnBeforeSave();
		end

		self.bSaveNow = 1;
		self:SetTimer(1);
	end
end