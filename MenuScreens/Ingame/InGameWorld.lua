--
-- options menu page
--

UI.PageInGameWorld=
{	
	GUI=
	{	
		--JoinPlayers=
		RegisterNewbie=
		{
			skin = UI.skins.CheckBox,
			left = 588, top = 232,
			width = 27, height = 27,
			
			tabstop = 1,

			--text = Localize("world_register"),

			OnChanged = function(self)
				if(self:GetChecked()) then
					UI.PageInGameWorld.GUI.RegisterNewbie.newentry = 1;
					UI.PageInGameWorld.GUI.ContinueOrJoin:SetText("@world_beginadventure");
					UI.PageInGameWorld.GUI.BackpackPassTxt2:SetText(getglobal("p_name")..", @world_backpackpass_new");
				else
					UI.PageInGameWorld.GUI.ContinueOrJoin:SetText("@world_continueadventure");
					UI.PageInGameWorld.GUI.BackpackPassTxt2:SetText(getglobal("p_name")..", @world_backpackpass");
					UI.PageInGameWorld.GUI.RegisterNewbie.newentry = nil;
				end
			end,
		},
		RegisterNewbieTxt=
		{
			skin = UI.skins.Label,
			left =622, top = 232,
			width = 134,
			halign = UIALIGN_LEFT,
			text = Localize("world_register");
		},
		BackpackPassTxt2=
		{
			skin = UI.skins.Label,
			left =200, top = 153,
			width = 575,
			halign = UIALIGN_CENTER,
			fontsize = 23,
			text = Localize("world_backpackpass");
		},

		
		ContinueOrJoin=
		{
			skin = UI.skins.TopMenuButton,
			left = 400, top = 232,
			width = 180, height = 30,
			
			bordersides = "lrbt",
			
			tabstop = 1,

			text = Localize("world_continueadventure"),

			OnCommand=function(Sender)
				--Client:JoinTeamRequest("players")
				--Game:SendMessage("Switch");
				if UI.PageInGameWorld.GUI.RegisterNewbie.newentry == 1 then
					Client:SendCommand("WRLD N "..UI.PageInGameWorld.GUI.BackPackPassword:GetText());
				else
					Client:SendCommand("WRLD C "..UI.PageInGameWorld.GUI.BackPackPassword:GetText());
				end
			end,
		},
		
		JoinSpectators=
		{
			skin = UI.skins.TopMenuButton,
			left = 400, top = 272,
			width = 180, height = 30,
			bordersides = "lrbt",
			
			tabstop = 2,
			
			text = Localize("JoinSpectatorsTeam"),
			
			OnCommand=function(Sender)
				Client:JoinTeamRequest("spectators")
				Game:SendMessage("Switch");
			end,
		},
		MissionName =
		{
			skin = UI.skins.MenuBorder,
			left = 200, top = 110,
			width = 580, height = 25,
		},
		ServerName =
		{
			skin = UI.skins.MenuBorder,
			left = 200, top = 110,
			width = 580, height = 25,
			halign = UIALIGN_CENTER,
		},
		IPName =
		{
			skin = UI.skins.MenuBorder,
			left = 200, top = 110,
			width = 580, height = 25,
			halign = UIALIGN_RIGHT,
		},
		--GameHelp =
		--{
		--	skin = UI.skins.TopMenuButton,
		--	left = 400, top = 232,
		--	width = 180, height = 30,
		--	bordersides = "lrbt",
		--	
		--	tabstop = 3,
			
		--	text = "@cis_game_help",
			
		--	OnCommand=function(Sender)
		--		Client:JoinTeamRequest("spectators")
		--		Game:SendMessage("Switch");
		--		if (getglobal("g_language")) == "russian" then
		--			Hud.cis_known_help = System:LoadImage("Textures/gui/cis_help_footer_ru");
		--		else
		--			Hud.cis_known_help = System:LoadImage("Textures/gui/cis_help_footer_en");
		--		end
		--		if (Hud.cis_known_help) then
		--			Hud.cis_helpmusic = Sound:LoadStreamSound("Music/install/Installer_Music(%L2).ogg", SOUND_MUSIC+SOUND_UNSCALABLE);
		--			if (Hud.cis_helpmusic) and (tostring(getglobal("s_MusicEnable")) == "1") then
		--				Sound:SetSoundVolume(Hud.cis_helpmusic, getglobal("s_MusicVolume") * 255.0);
		--				Sound:PlaySound(Hud.cis_helpmusic);
		--			end
		--		end
		--	end,
		--},
		BackPackPassword =
		{
			skin = UI.skins.EditBox,

			left = 400, top = 192,
			width = 180, height = 30,
			fontsize = 16,
			maxlength = 11,
			
			tabstop = 22,
			
			
			
			OnCommand=function(Sender)
				Client:JoinTeamRequest("spectators")
				Game:SendMessage("Switch");
			end,
		},
		VoteYes =
		{
			skin = UI.skins.BottomMenuButton,
			left = 620-160-160,
			width = 100,

			text = "@cis_vote_yes",	
			tabstop = 4,	
			
			OnCommand = function(Sender)
				if (Client) then
					Client:Vote("yes");
        		UI:HideWidget("VoteYes", "InGameWorld");
			UI:HideWidget("VoteNo", "InGameWorld");
				end
			end
		},

		VoteNo =
		{
			skin = UI.skins.BottomMenuButton,
			left = 620-160-160-100,
			width = 100,

			text = "@cis_vote_no",	

			tabstop = 5,	
			
			OnCommand = function(Sender)
				if (Client) then
					Client:Vote("no");
        		UI:HideWidget("VoteYes", "InGameWorld");
			UI:HideWidget("VoteNo", "InGameWorld");
				end
			end
		},

		
		OnActivate = function(Sender)
			Sender:PopulateChatTarget();
			UI.PageInGameWorld.GUI.MissionName:SetText(g_LevelName);
			UI.cis_ui_acttimer = _time;
			-- Mixer: draw server name and ip (moved to here)
			local ipAddr;
			if (Game:IsServer()) and (Game.GetServerIP) then
				ipAddr = Game:GetServerIP();
				local iColon = strfind(ipAddr, ':');
				if (not iColon) then
					ipAddr = ipAddr..":"..getglobal("sv_port");
				end
			else
				ipAddr = getglobal("g_LastIP");
				if (ipAddr) then ipAddr = ipAddr..":"..getglobal("g_LastPort"); end
			end
			if (ipAddr) then
				UI.PageInGameWorld.GUI.IPName:SetText("$1IP: "..ipAddr.." ");
				ipAddr = tostring(getglobal("g_LastServerName"));
				UI.PageInGameWorld.GUI.ServerName:SetText(ipAddr);
			end

			if getglobal("gr_votetime") then
				if _time>tonumber(getglobal("gr_votetime")) then
					UI:HideWidget("VoteYes", "InGameWorld");
					UI:HideWidget("VoteNo", "InGameWorld");
				else
					UI:ShowWidget("VoteYes", "InGameWorld");
					UI:ShowWidget("VoteNo", "InGameWorld");
				end
			else 
					UI:HideWidget("VoteYes", "InGameWorld");
					UI:HideWidget("VoteNo", "InGameWorld");
			end
			UI.PageInGameWorld.GUI.RegisterNewbie:SetChecked(0);
			UI.PageInGameWorld.GUI.RegisterNewbie:OnChanged();
			if (_localplayer) and (_localplayer.entity_type) then
				UI.PageInGameWorld.GUI.RegisterNewbie.entity_type = _localplayer.entity_type.."";
			else
				UI.PageInGameWorld.GUI.RegisterNewbie.entity_type = "spectator";
			end

			if (Hud) then
				Hud.bHide = 1;
			end	


		end,
		
		OnDeactivate = function(Sender)		
			if (Hud) then
				Hud.cis_mpopt = 0;
				Hud.bHide = nil;
			end
		end,
		
		OnUpdate = function(Sender)
			if (_localplayer) then
				--if (_localplayer.entity_type ~= "spectator") then
				--else
					--UI:DisableWidget(Sender.Suicide);
				--end
				--UI:EnableWidget(Sender.JoinSpectators);
				--UI:EnableWidget(Sender.ContinueOrJoin);
				if (_localplayer.entity_type) then
					if (_localplayer.entity_type ~= UI.PageInGameWorld.GUI.RegisterNewbie.entity_type) then
						UI.PageInGameWorld.GUI.RegisterNewbie.entity_type = _localplayer.entity_type.."";
						Game:SendMessage("Switch");
					end
				end
			else
				--UI:DisableWidget(Sender.Suicide);
				--UI:DisableWidget(Sender.JoinSpectators);
				--UI:DisableWidget(Sender.JoinPlayers);
				-- Mixer: autodisconnect on-crash feature
				if (_time > UI.cis_ui_acttimer+5.8) then
					System:ExecuteCommand("disconnect");
				end
			end
			
			if (Hud.iTeam01Count) then
				%System:DrawImageColor(Hud.white_dot, 365,232, 30, 29, 4, 0, 0.7, 0, 1);
				%System:DrawImageColor(Hud.white_dot, 365,272, 30, 29, 4, 0, 0, 0, 1);
				local sisix,sisiy = Game:GetHudStringSize(Hud.iTeam01Count, 15, 15);
				sisix = 380 - sisix * 0.5;
				Game:WriteHudString(sisix, 236, Hud.iTeam01Count, 1, 1, 1, 1, 15, 15);
				sisix, sisiy = Game:GetHudStringSize(Hud.iTeam02Count, 15, 15);
				sisix = 380 - sisix * 0.5;
				Game:WriteHudString(sisix, 276, Hud.iTeam02Count, 1, 1, 1, 1, 15, 15);
				if (Hud.iTeamSpecCount < _time) then
					sisix = System:GetEntities();
					local redc = 0;
					local bluec = 0;
					for i, ent in sisix do
						if ent.type == "Player" then
							sisiy = Game:GetEntityTeam(ent.id);
							if (sisiy) and (sisiy == "players") then
								redc = redc + 1;
							end
						elseif ent.type == "spectator" then
							bluec = bluec + 1;
						end
					end
					Hud.iTeam01Count = redc;
					Hud.iTeam02Count = bluec;
					Hud.iTeamSpecCount = _time + 1.2;
				end
			else
				if (not Hud.iTeamSpecCount) then
					Hud.iTeamSpecCount = _time + 1.2;
					-- L_A_G_G_E_R
					if UI.PageInGameWorld.GUI.JoinPlayers then
						if (ClientStuff.cl_survival) and (ClientStuff.cl_survival == 1) then
							UI.PageInGameWorld.GUI.JoinPlayers:SetText("@cis_becomedefender");
						else
							UI.PageInGameWorld.GUI.JoinPlayers:SetText("@JoinPlayersTeam");
						end
					end
				elseif (Hud.iTeamSpecCount < _time) then
					Hud.iTeam01Count = 0;
					Hud.iTeam02Count = 0;
				end
			end

			if (UI.MusicId) and (Sound:IsPlaying(UI.MusicId)) then
				UI:StopMusic();
			end
			if (not UI.cis_banner) then
				UI.cis_banner = System:LoadImage("textures/gui/cis_banner");
			else
				%System:DrawImageColor(UI.cis_banner, 0,0, 800, 80, 4,1,1,1, 0.95);
			end
			Sender:PopulateChatTarget(1);
		end,
	},
};

UI:AddChatbox(UI.PageInGameWorld.GUI, 200, 308, 580, 148, 24);

AddUISideMenu(UI.PageInGameWorld.GUI,
{
	{ "Disconnect", Localize("Disconnect"), "$Disconnect$", 0},
	{ "Options", Localize("Options"), "Options",},
      { "ServerAdmin", "Server Admin", "ServerAdmin",},
      { "VotePanel", "@VotePan", "VotePanel",},

	{ "-", "-", "-", },	-- separator
	{ "Quit", "@Quit", UI.PageMainScreen.ShowConfirmation, },	
});

UI:CreateScreenFromTable("InGameWorld",UI.PageInGameWorld.GUI);