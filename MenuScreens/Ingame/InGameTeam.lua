Script:LoadScript("Scripts/Multiplayer/SVcommands.lua");
--
-- options menu page
--


UI.PageInGameTeam=
{	
	GUI=
	{
		JoinRed=
		{
			skin = UI.skins.TopMenuButton,
			left = 400, top = 158,
			width = 180, height = 28,
			bordersides = "lrbt",
			
			tabstop = 1,

			text=Localize("JoinRedTeam"),

			OnCommand=function(Sender)
				Client:JoinTeamRequest("red")
				Game:SendMessage("Switch");
			end,
		},
		
		JoinBlue=
		{
			skin = UI.skins.TopMenuButton,
			left = 400, top = 194,
			width = 180, height = 28,
			bordersides = "lrbt",
			
			tabstop = 2,

			text=Localize("JoinBlueTeam"),


			OnCommand=function(Sender)
				Client:JoinTeamRequest("blue")
				Game:SendMessage("Switch");
			end,
		},
		
		JoinSpectators=
		{
			skin = UI.skins.TopMenuButton,
			left = 400, top = 230,
			width = 180, height = 28,
			bordersides = "lrbt",
			
			tabstop = 3,
			
			text=Localize("JoinSpectatorsTeam"),

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
		Suicide =
		{
			skin = UI.skins.TopMenuButton,
			left = 400, top = 266,
			width = 180, height = 28,
			bordersides = "lrbt",
			
			tabstop = 4,
			
			text = Localize("DoSuicide"),
			
			OnCommand = function(Sender)
				if (Mission) and (Mission.soccer_center) then
					Hud:AddMessage("$1 @cis_soccerhint");
				else
					Client:Kill();
				end
				Game:SendMessage("Switch");
			end,
		},
		VoteYes =
		{
			skin = UI.skins.BottomMenuButton,
			left = 620-160-160,
			width = 100,

			text = "@cis_vote_yes",		
			
			OnCommand = function(Sender)
				if (Client) then
					Client:Vote("yes");
        		UI:HideWidget("VoteYes", "InGameTeam");
			UI:HideWidget("VoteNo", "InGameTeam");
				end
			end
		},

		VoteNo =
		{
			skin = UI.skins.BottomMenuButton,
			left = 620-160-160-100,
			width = 100,

			text = "@cis_vote_no",		
			
			OnCommand = function(Sender)
				if (Client) then
					Client:Vote("no");
        		UI:HideWidget("VoteYes", "InGameTeam");
			UI:HideWidget("VoteNo", "InGameTeam");
				end
			end
		},
		PunishYes =
		{
			skin = UI.skins.BottomMenuButton,
			left = 620-160-160,
			width = 100,
			top = 465+30,

			text = "TK Punish",		
			
			OnCommand = function(Sender)
				if (Client) then
				        local judge=Hud["szSelfJudge"];
				        local criminal=Hud["szSelfCriminal"];
				        if (judge) then
				                Client:SendCommand("VTK "..judge.." "..criminal.." "..1);
                                        --UI.PageInGameTeam.GUI:UpdatePunish();
        		UI:HideWidget("PunishYes", "InGameTeam");
			UI:HideWidget("PunishNo", "InGameTeam");
                                end
				end
			end
		},

		PunishNo =
		{
			skin = UI.skins.BottomMenuButton,
			left = 620-160-160-100,
			width = 100,
			top = 465+30,

			text = "TK Forgive",		
			
			OnCommand = function(Sender)
				if (Client) then
				        local judge=Hud["szSelfJudge"];
				        local criminal=Hud["szSelfCriminal"];
				        if (judge) then
				                Client:SendCommand("VTK "..judge.." "..criminal.." "..0);
						UI:HideWidget("PunishYes", "InGameTeam");
						UI:HideWidget("PunishNo", "InGameTeam");
					end
				end
			end
		},
		
		OnActivate = function(Sender)
			Sender:PopulateChatTarget();
			UI:HideWidget("PunishYes", "InGameTeam");
			UI:HideWidget("PunishNo", "InGameTeam");
			UI.PageInGameTeam.GUI.MissionName:SetText(g_LevelName);
			UI.cis_ui_acttimer = _time;
			
			
			if (ClientStuff) then
				if ClientStuff:ModeDesc() == "HUNT" then
					UI.PageInGameTeam.GUI.JoinRed:SetText("Join Mercenaries");
					UI.PageInGameTeam.GUI.JoinBlue:SetText("Join Mutants");
				end
			end
			
			
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
				UI.PageInGameTeam.GUI.IPName:SetText("$1IP: "..ipAddr.." ");
				ipAddr = tostring(getglobal("g_LastServerName"));
				UI.PageInGameTeam.GUI.ServerName:SetText(ipAddr);
			end

			if (Client) then
		           Client:SendCommand("GTK");
		      end
		
			if getglobal("gr_votetime") then
				if _time>tonumber(getglobal("gr_votetime")) then
					UI:HideWidget("VoteYes", "InGameTeam");
					UI:HideWidget("VoteNo", "InGameTeam");
				else
					UI:ShowWidget("VoteYes", "InGameTeam");
					UI:ShowWidget("VoteNo", "InGameTeam");
				end
			else 
					UI:HideWidget("VoteYes", "InGameTeam");
					UI:HideWidget("VoteNo", "InGameTeam");
			end
	
			local judge=Hud.szSelfJudge;
			if (judge ~= nil) then
		        	if (judge ~= 0) then
					UI:ShowWidget("PunishYes", "InGameTeam");
					UI:ShowWidget("PunishNo", "InGameTeam");
				else
		        		UI:HideWidget("PunishYes", "InGameTeam");
					UI:HideWidget("PunishNo", "InGameTeam");
				end
			else
					UI:HideWidget("PunishYes", "InGameTeam");
					UI:HideWidget("PunishNo", "InGameTeam");
			end

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
			if (_localplayer) then
				if (_localplayer.entity_type ~= "spectator") then
					UI:EnableWidget(Sender.Suicide);
				else
					if (Mission) and (Mission.soccer_center) then
						UI:EnableWidget(Sender.Suicide);
					else
						UI:DisableWidget(Sender.Suicide);
					end
				end
				UI:EnableWidget(Sender.JoinSpectators);
				UI:EnableWidget(Sender.JoinBlue);
				UI:EnableWidget(Sender.JoinRed);
			else
				UI:DisableWidget(Sender.Suicide);
				UI:DisableWidget(Sender.JoinSpectators);
				UI:DisableWidget(Sender.JoinBlue);
				UI:DisableWidget(Sender.JoinRed);
				-- Mixer: autodisconnect on-crash feature
				if (_time > UI.cis_ui_acttimer+5.8) then
					System:ExecuteCommand("disconnect");
				end
			end
			
			if (Hud.iTeam01Count) then
				%System:DrawImageColor(Hud.white_dot, 365,158, 30, 28, 4, 1, 0, 0, 1);
				%System:DrawImageColor(Hud.white_dot, 365,194, 30, 28, 4, 0, 0, 1, 1);
				%System:DrawImageColor(Hud.white_dot, 365,230, 30, 28, 4, 0, 0.7, 0, 1);
				local sisix,sisiy = Game:GetHudStringSize(Hud.iTeam01Count, 15, 15);
				sisix = 380 - sisix * 0.5;
				Game:WriteHudString(sisix, 162, Hud.iTeam01Count, 1, 1, 1, 1, 15, 15);
				sisix,sisiy = Game:GetHudStringSize(Hud.iTeam02Count, 15, 15);
				sisix = 380 - sisix * 0.5;
				Game:WriteHudString(sisix, 198, Hud.iTeam02Count, 1, 1, 1, 1, 15, 15);
				sisix,sisiy = Game:GetHudStringSize(Hud.iTeam03Count, 15, 15);
				sisix = 380 - sisix * 0.5;
				Game:WriteHudString(sisix, 234, Hud.iTeam03Count, 1, 1, 1, 1, 15, 15);
				
				if (Hud.iTeamSpecCount < _time) then
					sisix = System:GetEntities();
					local redc = 0;
					local bluec = 0;
					local spec_s = 0;
					for i, ent in sisix do
						if ent.type == "Player" then
							sisiy = Game:GetEntityTeam(ent.id);
							if (sisiy) then
								if sisiy == "red" then
									redc = redc + 1;
								elseif sisiy == "blue" then
									bluec = bluec + 1;
								end
							end
						elseif ent.type == "spectator" then
							spec_s = spec_s + 1;
						end
					end
					Hud.iTeam01Count = redc;
					Hud.iTeam02Count = bluec;
					Hud.iTeam03Count = spec_s;
					Hud.iTeamSpecCount = _time + 1.2;
				end
			else
				if (not Hud.iTeamSpecCount) then
					Hud.iTeamSpecCount = _time + 1.2;
					-----
					if (Mission) and (Mission.soccer_center) then
						UI.PageInGameTeam.GUI.Suicide:SetText("@cis_game_help");
					else
						UI.PageInGameTeam.GUI.Suicide:SetText("@DoSuicide");
					end
					-----
				elseif (Hud.iTeamSpecCount < _time) then
					Hud.iTeam01Count = 0;
					Hud.iTeam02Count = 0;
					Hud.iTeam03Count = 0;
				end
			end
			
			if (UI.MusicId) and (Sound:IsPlaying(UI.MusicId)) then
				UI:StopMusic();
			end

			if (Client) then
		           Client:SendCommand("GTK");
			end

			local judge=Hud.szSelfJudge;
			if (judge ~= nil) then
		        	if (judge ~= 0) then
					UI:ShowWidget("PunishYes", "InGameTeam");
					UI:ShowWidget("PunishNo", "InGameTeam");
				else
		        		UI:HideWidget("PunishYes", "InGameTeam");
					UI:HideWidget("PunishNo", "InGameTeam");
				end
			else
					UI:HideWidget("PunishYes", "InGameTeam");
					UI:HideWidget("PunishNo", "InGameTeam");
			end
	
			Sender:PopulateChatTarget(1);
			if (not UI.cis_banner) then
				UI.cis_banner = System:LoadImage("textures/gui/cis_banner");
			else
				%System:DrawImageColor(UI.cis_banner, 0,0, 800, 80, 4,1,1,1, 0.95);
			end
		end,	
	},
};

UI:AddChatbox(UI.PageInGameTeam.GUI, 200, 312, 580, 144, 24, 1);

AddUISideMenu(UI.PageInGameTeam.GUI,
{
	{ "Disconnect", Localize("Disconnect"), "$Disconnect$", 0},
	{ "Options", Localize("Options"), "Options", },
	{ "ServerAdmin", "Server Admin", "ServerAdmin",},
	{ "VotePanel", "@VotePan", "VotePanel",},

	{ "-", "-", "-", },	-- separator
	{ "Quit", "@Quit", UI.PageMainScreen.ShowConfirmation, },	
});

UI:CreateScreenFromTable("InGameTeam",UI.PageInGameTeam.GUI);