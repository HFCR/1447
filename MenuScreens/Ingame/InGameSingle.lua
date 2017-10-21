-- CIS


UI.PageInGameSingle=
{
	CheckpointName = {},

	GUI=
	{
		thumbnail=
		{
			skin = UI.skins.MenuBorder,
			left = 222, top = 204,
			width = 256, height = 192,
			
			color = "255 255 255 255",
		},	

		CheckpointLabel=
		{
			skin = UI.skins.MenuBorder,
			left = 496, top = 151,
			width = 275, height = 28,
			bordersides = "tlr",
			
			halign = UIALIGN_CENTER,
			
			text = Localize("Checkpoint"),
		},	

		CheckpointList=
		{
			skin = UI.skins.ListView,
			left = 496, top = 178,
			width = 275, height = 270,
			
			fontsize = 12,
			
			zorder = 10,
			
			tabstop = 1,
			
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
			hscrollbar=
			{
				skin = UI.skins.HScrollBar,
			},
			
			OnChanged = function(Sender)
				UI.PageInGameSingle:SetPicture();
			end,
		},

		LoadGame=
		{
			text = Localize("Load_SaveGame"),
			left = 600,
			skin = UI.skins.BottomMenuButton,
			
			tabstop = 2,
			
			OnCommand = function(Sender)
			
				local iSelection = UI.PageInGameSingle.GUI.CheckpointList:GetSelection(0);
				
				if not iSelection then
					return
				end
				
				printf(iSelection);

				local szFilename = UI.PageInGameSingle.CheckpointName[iSelection];
				
				printf(szFilename);
				
				if (szFilename) then
					UI.PageInGameSingle.LoadGame(szFilename);
				end
			end,
		},

		OnActivate = function(Sender)
		
			Sender.CheckpointList.OnCommand = Sender.LoadGame.OnCommand;
			
			local szCurrentLevel = getglobal("g_LevelName");
			local szProfileName = getglobal("g_playerprofile");
		
			if ((not szProfileName) or (strlen(szProfileName) < 1)) then
				szProfileName = "default";
				g_playerprofile = "default";
			end
			
			--------local SaveList = Game:GetSaveGameList(szProfileName);
			-------- Mixer: new databasefile-based load/save system (included in campaign.lua, ingamesingle.lua, gameevent.lua, and also common UI:Ecfg func is stored in UISystemCfg.lua)
			local test_touch = openfile("Profiles/player/"..szProfileName.."/savegames/savegames_placeholder.txt","r");
			if (test_touch) then
				closefile(test_touch);
			else
				local test_touch2 = openfile("Profiles/player/"..szProfileName.."/savegames/savegames_placeholder.txt","w");
				if (test_touch2) then
					closefile(test_touch2);
				end
			end
			local svg_files = System:ScanDirectory("Profiles/player/"..szProfileName.."/savegames", SCANDIR_FILES);
			local SaveList = {};
			if (svg_files) and (getn(svg_files) > 0) then
				------------------
				local svg_modbase = "";
				for i, val in Game:GetModsList() do
					if (val.CurrentMod) then
						svg_modbase = val.Folder.."/";
						break;
					end
				end
				-----------------------
				for i,filename in svg_files do
					filename = strlower(filename);
					if (strfind(filename,".sav") ~= nil) then
						local isav_entry = {}; -- preparing savegame entry table
						isav_entry.szFileName = strsub(filename, 1, strlen(filename)-strlen(".sav"));
						--------- Mixer: retrieving savegame entry from savegames database file
						savbase_entry = UI:Ecfg(svg_modbase.."Levels/sav_base.ini",isav_entry.szFileName);
						if (savbase_entry) then
							isav_entry.Year = tonumber(strsub(savbase_entry,1,4));
							isav_entry.Month = tonumber(strsub(savbase_entry,5,6));
							isav_entry.Day = tonumber(strsub(savbase_entry,7,8));
							isav_entry.Hour = tonumber(strsub(savbase_entry,9,10));
							isav_entry.Minute = tonumber(strsub(savbase_entry,11,12));
							isav_entry.Second = tonumber(strsub(savbase_entry,13,14));
							isav_entry.Filename = filename;
							isav_entry.Level = strsub(savbase_entry,15);
							if (isav_entry.Level) then
								tinsert(SaveList, isav_entry);
								SaveList.n = nil;
							end
						end
						--------------
					end
				end
				
			end
			-------- Mixer: new databasefile-based load/save system code END


			local iCPCount = 0;
			local CheckpointList = {};
			
			for x, SaveGame in SaveList do
				if (strlower(tostring(SaveGame.Level)) == strlower(tostring(szCurrentLevel))) then
					iCPCount = iCPCount + 1;
					CheckpointList[iCPCount] = SaveGame;
				end
			end
			
			local iLastCheckpoint;
			Sender.CheckpointList:Clear();
			
			
			--- Mixer: sort checkpoints by save time:
			if (iCPCount > 1) then
				--- do bubble-sorting
				local bIsSwapped = 1;
				while (bIsSwapped == 1) do
					bIsSwapped = 0;
					for i=1,iCPCount-1 do
						local checkpoint_i_age = "%.2d%.2d%.2d%.2d%.2d";
						checkpoint_i_age = format(checkpoint_i_age, CheckpointList[i].Month, CheckpointList[i].Day, CheckpointList[i].Hour, CheckpointList[i].Minute, CheckpointList[i].Second);
						checkpoint_i_age = "1."..CheckpointList[i].Year..checkpoint_i_age;
						local checkpoint_i2_age = "%.2d%.2d%.2d%.2d%.2d";
						checkpoint_i2_age = format(checkpoint_i2_age, CheckpointList[i+1].Month, CheckpointList[i+1].Day, CheckpointList[i+1].Hour, CheckpointList[i+1].Minute, CheckpointList[i+1].Second);
						checkpoint_i2_age = "1."..CheckpointList[i+1].Year..checkpoint_i2_age;
						if (checkpoint_i_age) and (checkpoint_i2_age) and (checkpoint_i_age > checkpoint_i2_age) then 
							local tempsavetbl = new(CheckpointList[i]);
							CheckpointList[i] = new(CheckpointList[i+1]);
							CheckpointList[i+1] = tempsavetbl;
							bIsSwapped = 1;
						end
					end
				end
				---
			end

			for i=1, iCPCount do
				local SaveGame = CheckpointList[i];
				local szFileName = strsub(SaveGame.Filename, 1, strlen(SaveGame.Filename)-strlen(".sav"));	
				local szCheckpointName;			
				local iCheckpoint;
					
				local szDate = "%.2d/%.2d/%.2d";
					
				szDate = format(szDate, SaveGame.Day, SaveGame.Month, SaveGame.Year);
				szFileName = strlower(szFileName);
					
				if (i == iCPCount) then
					szCheckpointName = format(szDate.." [%.2d:%.2d:%.2d] @CheckpointLast", SaveGame.Hour, SaveGame.Minute, SaveGame.Second);
					iCheckpoint = UI.PageInGameSingle.GUI.CheckpointList:InsertItem(0, szCheckpointName);
					iLastCheckpoint = iCheckpoint;
				elseif (strfind(szFileName,'_quicksave')~=nil) or (strfind(szFileName,'_campaign_777')~=nil) then
					szCheckpointName = format(szDate.." [%.2d:%.2d:%.2d] Quick Save", SaveGame.Hour, SaveGame.Minute, SaveGame.Second);
					iCheckpoint = UI.PageInGameSingle.GUI.CheckpointList:InsertItem(0, szCheckpointName);
				else
					szCheckpointName = format(szDate.." [%.2d:%.2d:%.2d]", SaveGame.Hour, SaveGame.Minute, SaveGame.Second);
					iCheckpoint = UI.PageInGameSingle.GUI.CheckpointList:InsertItem(0, szCheckpointName);
				end

				UI.PageInGameSingle.CheckpointName[iCheckpoint] = szFileName;
			end
			
			if (iLastCheckpoint) then
				UI:SetFocus(UI.PageInGameSingle.GUI.CheckpointList);
				UI.PageInGameSingle.GUI.CheckpointList:SelectIndex(iLastCheckpoint);
			end
			
			UI.PageInGameSingle:SetPicture();
		
			if (Hud) then
				Hud.bHide = 1;
			end
			
		end,
		
		OnDeactivate = function(Sender)
			if (Hud) then
				Hud.bHide = nil;
			end	
		end,
		
		OnUpdate = function(Sender)
			if (not UI.cis_banner) then
				UI.cis_banner = System:LoadImage("textures/gui/cis_banner");
			else
				%System:DrawImageColor(UI.cis_banner, 0,0, 800, 80, 4,1,1,1, 0.95);
			end
		end,
	},
	

	LoadGame = function(szFilename)
		if (szFilename) then

			setglobal("g_GameType","Default");
			
--			UI.PageCampaign.SetAIDifficulty(UI.PageInGameSingle.iDifficultyLevel);

			Game:SendMessage("LoadGame "..szFilename);
		end
	end,
	
	SetPicture = function()
		local iSelection = UI.PageInGameSingle.GUI.CheckpointList:GetSelection(0);

		if iSelection then
		
			local szFileName = UI.PageInGameSingle.CheckpointName[iSelection];
			
			if (szFileName and strlen(szFileName) > 1) then
			
				--szFileName = "profiles/player/"..getglobal("g_playerprofile").."/savegames/"..szFileName;
				szFileName = "textures/checkpoints/"..szFileName;
			
				local iTexture = System:LoadImage(szFileName);
				
				if (not iTexture) then
					iTexture = System:LoadImage("textures/checkpoints/checkpoint_generic_quicksave");
				end
	
				if (iTexture) then
					UI.PageInGameSingle.GUI.thumbnail:SetColor("255 255 255 255");
					UI.PageInGameSingle.GUI.thumbnail:SetTexture(iTexture);
	
					return;
				end
			end
		end

		UI.PageInGameSingle.GUI.thumbnail:SetColor("0 0 0 64");
		UI.PageInGameSingle.GUI.thumbnail:SetTexture(nil);
	end,

};

AddUISideMenu(UI.PageInGameSingle.GUI,
{
	{ "Return", Localize("ReturnToGame"), "$Return$", },
	{ "-", "-", "-", },	-- separator
	{ "MainMenu", Localize("MainMenu"), "$MainScreen$", 0},
	{ "Options", Localize("Options"), "Options", },
	{ "-", "-", "-", },	-- separator
	{ "Disconnect", Localize("Disconnect"), "$Disconnect$", 0},
	{ "Quit", "@Quit", UI.PageMainScreen.ShowConfirmation, },	
});
	
UI:CreateScreenFromTable("InGameSingle",UI.PageInGameSingle.GUI);


UI.PageInGameSingleSaving=
{
	GUI=
	{
		backpane=
		{
			classname = "static",
			left = 0, top = 0,
			width = 800, height = 600,
			
			color = UI.szMessageBoxColor,
			
			valign = UIALIGN_MIDDLE,
			halign = UIALIGN_CENTER,
			style = UISTYLE_TRANSPARENT,
			
			fontsize = 24,
					
			text = "@SavingGame",
		},
	},
}

UI:CreateScreenFromTable("InGameSingleSaving",UI.PageInGameSingleSaving.GUI);

function Game:OnBeforeSave()

	UI:HideBackground();
	UI:HideMouseCursor();

	UI:DeactivateAllScreens();	
	UI:ActivateScreen("InGameSingleSaving");
	
	Game:EnableUIOverlay(1, 1);

end

function Game:OnAfterSave()
	
	UI:ShowMouseCursor();
	UI:DeactivateAllScreens();
	
	Game:EnableUIOverlay(0, 0);
	
end