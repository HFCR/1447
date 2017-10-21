UI.PageVotePanel=
{
    LevelList={},       -- { missionname1={}, missionname2={}, }
    
    GUI =
    {   
        VotePanelText=
        {
            skin = UI.skins.Label,
            
            left = 200, top = 110,
            width = 122, 
            halign = UIALIGN_LEFT,
            
            text = "Voting Panel";
        },
        
        KickPlayerIDTest=
        {
            skin = UI.skins.Label,
            
            left = 175, top = 236,
            width = 140, height = 24,
            
		fontsize = 12,
            text = "@cis_vote_kick";
        },

        KickPlayerID=
        {       
		skin = UI.skins.ComboBox,
		vscrollbar=
		{
			skin = UI.skins.VScrollBar,
		},
		left = 315, top = 236,
		width = 140, height = 24,
		fontsize = 11,
		tabstop = 13,
        },
	
	BotQuotaTXT=
        {
		skin = UI.skins.Label,
		left = 510, top = 172,
		width = 100, height = 24,
		fontsize = 12,
		text = "@cis_bquota";
        },
	
	BotQuotaN=
	{
		left = 617, top = 172,
		width = 70, height = 24,
		skin = UI.skins.ComboBox,
		tabstop = 33, -- ?

		vscrollbar=
		{
			skin = UI.skins.VScrollBar,
		},

		OnChanged = function(Sender)
		end,
	},
	
	BotDiffTXT=
        {
		skin = UI.skins.Label,
		left = 510, top = 204,
		width = 100, height = 24,
		fontsize = 12,
		text = "@cis_bdiff";
        },
	
	RDiff=
	{
		left = 617, top = 204,
		width = 70, height = 24,
		skin = UI.skins.ComboBox,
		tabstop = 8, -- ?

		vscrollbar=
		{
			skin = UI.skins.VScrollBar,
		},

		OnChanged = function(Sender)
		end,
	},
	
	RGstyle=
	{
		left = 547, top = 236,
		width = 140, height = 24,

		skin = UI.skins.ComboBox,
		tabstop = 260, -- ?
		vscrollbar=
		{
			skin = UI.skins.VScrollBar,
		},

		OnChanged = function( Sender )
			local newgs = tonumber( UI.PageVotePanel.GUI.RGstyle:GetSelectionIndex()) - 1;
			ClientStuff.votum_cis_gsty = newgs;
		end,
	},
	
	RHandi=
	{
		left = 617, top = 268,
		width = 70, height = 24,

		skin = UI.skins.ComboBox,
		tabstop = 1377, -- ?
		vscrollbar=
		{
			skin = UI.skins.VScrollBar,
		},

		OnChanged = function( Sender )
			local newgs = UI.PageVotePanel.GUI.RHandi:GetSelection();
			ClientStuff.votum_cis_suhandicap = newgs;
		end,
	},
	
	RHandiTXT=
        {
		skin = UI.skins.Label,
		left = 510, top = 268,
		width = 100, height = 24,
		fontsize = 12,
		text = "@Su_handicapping";
        },
	
	RHandiOffer=
        {
		skin = UI.skins.BottomMenuButton,
		text = "@cis_offer",

		tabstop = 1378,
		fontsize = 14,

		left = 695, top = 268,
		width = 65, height = 24,

		OnCommand = function(Sender)
			if (Client) and (ClientStuff.votum_cis_suhandicap) then
				Client:CallVote("su_handicap",ClientStuff.votum_cis_suhandicap);
			end
		end,
        },
	
	RGstyleOffer=
        {
		skin = UI.skins.BottomMenuButton,
		text = "@cis_offer",

		tabstop = 261,
		fontsize = 14,

		left = 695, top = 236,
		width = 65, height = 24,

		OnCommand = function(Sender)
			if (Client) and (ClientStuff.votum_cis_gsty) then
				Client:CallVote("gamestyle",ClientStuff.votum_cis_gsty);
			end
		end,
        },
	
	RDiffOffer=
        {
		skin = UI.skins.BottomMenuButton,
		text = "@cis_offer",

		tabstop = 9,
		fontsize = 14,

		left = 695, top = 204,
		width = 65, height = 24,

		OnCommand = function(Sender)
                local bquota = tonumber(UI.PageVotePanel.GUI.RDiff:GetSelectionIndex());
		if (bquota~= nil) then
			if (Client) then
				Client:CallVote("bot_difficulty",bquota);
			end
		end
		end,
        },

	RMatch=
	{
		left = 547, top = 140,
		width = 140, height = 24,

		skin = UI.skins.ComboBox,
		tabstop = 26, -- ?
		vscrollbar=
		{
			skin = UI.skins.VScrollBar,
		},

		OnChanged = function( Sender )
			local newgs = tonumber( UI.PageVotePanel.GUI.RMatch:GetSelectionIndex()) - 1;
			ClientStuff.votum_cis_rail = newgs;
		end,
	},

	BotQuotaBTN=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "@cis_offer",
            
            tabstop = 34,
            fontsize = 14,
            
            left = 695, top = 172,
            width = 65, height = 24,
            
            OnCommand = function(Sender)
                local bquota = tonumber( UI.PageVotePanel.GUI.BotQuotaN:GetSelectionIndex() ) - 1;
		if (bquota~= nil) then
			if (Client) then
				Client:CallVote("bot_quota",bquota);
			end
		end
            end,
        },
	
        KickPlayer=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "@cis_offer",
            
            tabstop = 14,
            fontsize = 14,
            
            left = 460, top = 236,
            width = 75, height = 24,
            
            OnCommand = function(Sender)
                local PlayerToKick = UI.PageVotePanel.GUI.KickPlayerID.player_ids[UI.PageVotePanel.GUI.KickPlayerID:GetSelectionIndex()];
                  if (PlayerToKick~= nil) then
			if (Client) then
				Client:CallVote("kick",PlayerToKick);
			end
			end

                --System:ShowConsole(1);
            end,
        },
        
        ListActivePlayers=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "List Active Players",
            
            tabstop = 12,
            fontsize = 14,
            
            left = 320, top = 280,
            width = 140, height = 24,

            OnCommand = function(Sender)
                System:ExecuteCommand("gr_list");
                System:ShowConsole(1);
            end            
        },

        ListActivePlayersText=
        {
            skin = UI.skins.Label,
            
            left = 320, top = 310,
            width = 230, height = 24,
            
            fontsize = 12,
            text = "Hit the ` or ~ key to toggle from console to menu";
        },
        


        MODListText=
        {
            skin = UI.skins.Label,
            
            left = 170, top = 140,
            width = 140, height = 24,
            
            fontsize = 12,
            text = "@GameType";
        },
        
        MODList=
        {
            skin = UI.skins.ComboBox,
            
            left = 315, top = 140,
            width = 140, height = 24,
            
            buttonsize = 15,
            
            maxitems = 5,
            fontsize = 12, 
            
            tabstop = 333,

            vscrollbar=
            {
                skin = UI.skins.VScrollBar,
            },      
            
            OnChanged = function(Sender)
                UI.PageVotePanel.PopulateMapList();
                
                if (UI.PageVotePanel.GUI.MapList:GetItemCount()) then
                
                    if (getglobal(gr_NextMap)) then
                        UI.PageVotePanel.GUI.MapList:Select(tostring(gr_NextMap));
                        
                        if (not UI.PageVotePanel.GUI.MapList:GetSelection()) then
                            UI.PageVotePanel.GUI.MapList:SelectIndex(1);
                        end
                    else
                        UI.PageVotePanel.GUI.MapList:SelectIndex(1);
                    end
                end
            end,
        },
	MODListLocalized=
        {
            skin = UI.skins.ComboBox,
            
            left = 315, top = 140,
            width = 140, height = 24,
            
            buttonsize = 15,
            
            maxitems = 5,
            fontsize = 12, 
            
            tabstop = 3,

            vscrollbar=
            {
                skin = UI.skins.VScrollBar,
            },      
            
            OnChanged = function(Sender)
			UI.PageVotePanel.GUI.MODList:SelectIndex(tonumber(UI.PageVotePanel.GUI.MODListLocalized:GetSelectionIndex()));
			UI.PageVotePanel.GUI.MODList.OnChanged(UI.PageVotePanel.GUI.MODList);
            end,
        },

	RMatchOffer=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "@cis_offer",
            
            tabstop = 7,
            fontsize = 14,
            
            left = 695, top = 140,
            width = 65, height = 24,
            
            OnCommand = function(Sender)
			if (Client) and (ClientStuff.votum_cis_rail) then
				Client:CallVote("cis_railonly",ClientStuff.votum_cis_rail);
			end
            end
        },
		

        MapListText=
        {
            skin = UI.skins.Label,
            
            left = 170, top = 170,
            width = 140, height = 24,
            
            fontsize = 12,
            text = "@Map";
        },
        
        MapList=
        {
            skin = UI.skins.ComboBox,
            
            left = 315, top = 172,
            width = 140, height = 24,
            
            buttonsize = 15,
            
            maxitems = 5,
            fontsize = 12,
            
            tabstop = 4,
            
            vscrollbar=
            {
                skin = UI.skins.VScrollBar,
            },           
        },

        ChangeMap=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "@cis_offer",
            
            tabstop = 5,
            fontsize = 14,
            
            left = 460, top = 172,
            width = 75, height = 24,
            
            OnCommand = function(Sender)
                local NewMapName = UI.PageVotePanel.GUI.MapList:GetSelection();
                local NewMapType = UI.PageVotePanel.GUI.MODList:GetSelection();
		    NewMapName=NewMapName.." "..NewMapType;
                  if (NewMapName ~= nil) then
			if (Client) then
				Client:CallVote("map",NewMapName);
			end
			end
            end            
        },
        



        RestartMapDelayText=
        {
            skin = UI.skins.Label,
            
            left = 170, top = 204,
            width = 140, height = 24,
            
		fontsize = 12,
            text = "Restart in sec (1-30)";
        },

        RestartMapDelay=
        {       
            skin = UI.skins.EditBox,

            left = 170+145, top = 204,
            width = 25, height = 24,

            fontsize = 11,            
            
            tabstop = 6,
		text="5";
        },

        RestartMap=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "@cis_vote_restartmap",
            
            tabstop = 7,
            fontsize = 14,
            
            left = 170+145+28, top = 204,
            width = 113, height = 24,
            
            OnCommand = function(Sender)
			local delay= tonumber(UI.PageVotePanel.GUI.RestartMapDelay:GetText()); 
			if ((delay == nil) or (delay > 30)) then
				delay=5;
			end
			if (Client) then
				Client:CallVote("restart",delay);
			end
            end            
        },
    
	OnActivate = function(Sender)
		UI.PageVotePanel.GUI.MODList:Clear();
		UI.PageVotePanel.GUI.MODListLocalized:Clear();

		for name, MOD in AvailableMODList do
			UI.PageVotePanel.GUI.MODList:AddItem(name);
			UI.PageVotePanel.GUI.MODListLocalized:AddItem("@gt_"..name);
		end
		UI:HideWidget(UI.PageVotePanel.GUI.MODList);
		UI.PageVotePanel.GUI.RMatch:Clear();
		UI.PageVotePanel.GUI.RMatch:AddItem("@cis_allweap");
		UI.PageVotePanel.GUI.RMatch:AddItem("@RailbowOnly");
		UI.PageVotePanel.GUI.RMatch:AddItem("@InstaGib");
		
		UI.PageVotePanel.GUI.RGstyle:Clear();
		UI.PageVotePanel.GUI.RGstyle:AddItem("@cis_gs_classic");
		UI.PageVotePanel.GUI.RGstyle:AddItem("@cis_gs_hardcore");
		UI.PageVotePanel.GUI.RGstyle:AddItem("@cis_gs_extreme");
		UI.PageVotePanel.GUI.RGstyle:AddItem("@cis_gs_unreal");
		UI.PageVotePanel.GUI.RGstyle:AddItem("@cis_gs_stunt");
		UI.PageVotePanel.GUI.RGstyle:AddItem("@cis_gs_crazy");

		UI.PageVotePanel.GUI.BotQuotaN:Clear();
		local bq_item=0;
		while bq_item < 33 do
			UI.PageVotePanel.GUI.BotQuotaN:AddItem(""..bq_item);
			bq_item=bq_item+1;
		end

		UI.PageVotePanel.GUI.RDiff:Clear();
		UI.PageVotePanel.GUI.RDiff:AddItem("@DifficultyEasy");
		UI.PageVotePanel.GUI.RDiff:AddItem("@DifficultyMedium");
		UI.PageVotePanel.GUI.RDiff:AddItem("@DifficultyHard");
		
		------------------- RHandi -- handicap settings
		bq_item = Game:GetTagPoint("MINIMUM_MONSTERS");
		if (bq_item) then
			bq_item = floor(bq_item.z);
		else
			bq_item = 7;
		end
		local hc_minimum = -bq_item + 1;
		while hc_minimum < bq_item+1 do
			UI.PageVotePanel.GUI.RHandi:AddItem(""..hc_minimum);
			hc_minimum = hc_minimum + 1;
		end
		-------

		UI.PageVotePanel.RefreshLevelList();
		UI.PageVotePanel.RefreshWidgets();
		Client:SendCommand("VB_GV");
        end,

        OnUpdate = function(Sender)
            
        end,
    },
       
    PopulateMapList = function()
        local szMOD = UI.PageVotePanel.GUI.MODList:GetSelection();
        
        UI.PageVotePanel.GUI.MapList:Clear();
        if (szMOD) then
            local szMission = AvailableMODList[strupper(szMOD)].mission;
            
            for i, szLevelName in UI.PageVotePanel.LevelList[szMission] do
		if (ClientStuff) and (ClientStuff.maps_to_vote) and (strfind(ClientStuff.maps_to_vote,strlower(szLevelName))==nil) then
		else
			UI.PageVotePanel.GUI.MapList:AddItem(szLevelName);
		end
            end
        end
        
        UI.PageVotePanel.GUI.MapList:SelectIndex(1);
    end,
    
    RefreshLevelList = function()
        UI.PageVotePanel.LevelList = {};
        
        -- create the tables
        for name, MOD in AvailableMODList do
            local szMission = MOD.mission;
            
            UI.PageVotePanel.LevelList[szMission] = {};
        end

        -- request level list from game 
        local LevelList = Game:GetLevelList();
    
        -- go through all the levels
        for LevelIndex, Level in LevelList do
            -- all mission names
            for MissionIndex, MissionName in Level.MissionList do
                -- get the mission names that are supported, and insert them in the appropriate table
                for name, AvailableMOD in AvailableMODList do
                    local szMission = AvailableMOD.mission;
            
                    if (strlower(MissionName) == strlower(szMission)) then
                        tinsert(UI.PageVotePanel.LevelList[szMission], Level.Name);
                        -- tinsert adds a "n" key, so we just remove it here
                        UI.PageVotePanel.LevelList[szMission].n = nil;
                        break;
                    end
                end
            end
        end
    end,

    RefreshWidgets = function()
        local GUI = UI.PageVotePanel.GUI;

        if (g_GameType and (g_GameType ~= "Default")) then
            GUI.MODList:Select(g_GameType);
	    GUI.MODListLocalized:Select("@gt_"..strupper(g_GameType));
        else
            GUI.MODList:SelectIndex(1);
	    GUI.MODListLocalized:SelectIndex(1);
        end 
        GUI.MODList.OnChanged(GUI.MODList);

	local cur_gs = tonumber(getglobal("cis_railonly"));
	ClientStuff.votum_cis_rail = cur_gs;
	UI.PageVotePanel.GUI.RMatch:SelectIndex(cur_gs + 1);
	
	cur_gs = tonumber(getglobal("gr_gamestyle"));
	ClientStuff.votum_cis_gsty = cur_gs;
	UI.PageVotePanel.GUI.RGstyle:SelectIndex(cur_gs + 1);

        if (getglobal("gr_NextMap")) then
            GUI.MapList:Select(getglobal("gr_NextMap"));
        else
            GUI.MapList:SelectIndex(1);
        end
	---- scan for players:
	UI.PageVotePanel.GUI.KickPlayerID:Clear();
	UI.PageVotePanel.GUI.KickPlayerID.player_ids = {};
	local pl_index = 0;
	local Entity;
	if (ClientStuff) and (ClientStuff.idScoreboard) then
		Entity = System:GetEntity(ClientStuff.idScoreboard).cnt;
	end
	if (Entity) then
		local iY,X;
		local iLines=Entity:GetLineCount();
		local iColumns=Entity:GetColumnCount();
		
		for iY=0,iLines-1 do
			local idThisClient = Entity:GetEntryXY(ScoreboardTableColumns.ClientID,iY)-1;		-- first element is the clientid-1
			
			if idThisClient~=-1 then
				pl_index = pl_index + 1;
				UI.PageVotePanel.GUI.KickPlayerID.player_ids[pl_index] = floor(idThisClient);
				UI.PageVotePanel.GUI.KickPlayerID:AddItem(Entity:GetEntryXY(ScoreboardTableColumns.sName,iY));
			end
		end
		if (_localplayer) and (_localplayer.GetName) then
			UI.PageVotePanel.GUI.KickPlayerID:Select(_localplayer:GetName());
		end
	end
    end,
}

AddUISideMenu(UI.PageVotePanel.GUI,
{
    { "MainMenu", Localize("MainMenu"), "$MainScreen$", 0},
    { "Options", Localize("Options"), "Options", },
});

UI:CreateScreenFromTable("VotePanel", UI.PageVotePanel.GUI);
