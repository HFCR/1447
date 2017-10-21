
UI.PageCreateServer=
{
	LevelList={},
	GUI =
	{
		CreateUBIServerText=
		{
			skin = UI.skins.Label,
			
			left = 200, top = 110,
			width = 122, 
			halign = UIALIGN_LEFT,
						
			text = Localize("CreateUBIServer");
		},
		
		ClipImage=
		{
			skin = UI.skins.MenuBorder,
			left = 436, top = 338,
			width = 125, height = 107,
			zorder = -49,
			color = "255 255 255 255",
			texture = System:LoadImage("textures/gui/admin_glclips"),
		},


		CreateLANServerText=
		{
			skin = UI.skins.Label,
			
			left = 200, top = 110,
			width = 122, 
			halign = UIALIGN_LEFT,
			
			text = Localize("CreateLANServer");
		},

		ConnectionText=
		{
			skin = UI.skins.Label,
			
			left = 200, top = 110,
			width = 485, 
			
			halign = UIALIGN_RIGHT,
						
			text = Localize("ConnectionSettings");
		},
		
		Connection=
		{
			skin = UI.skins.ComboBox,
			left = 690, top = 110,
			width = 90, height = 25,
			
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
		},
		
		RightTopStatic=
		{
			skin = UI.skins.MenuBorder,
			
			left = 600, top = 141,
			width = 180, height = 130,
			bordersides = "l",
			
			zorder = -50,
		},
		
		PunkBusterText=
		{
			skin = UI.skins.Label,
			left =600, top = 422,
			width = 134,
			
			text = Localize("cis_bleeding"),
		},
		
		PunkBuster=
		{
			skin = UI.skins.CheckBox,
			left = 742, top = 422,
			
			tabstop = 21,
			
			OnChanged = function(self)
				if(self:GetChecked()) then
					setglobal("gr_bleeding", 1);
					--setglobal("cl_punkbuster", 1);
				else
					setglobal("gr_bleeding", 0);
					--setglobal("cl_punkbuster", 0);
				end
			end,
		},
		
		GrNoRltxt=
		{
			skin = UI.skins.Label,
			left =470, top = 343,
			width = 134,
			halign = UIALIGN_LEFT,
			text = Localize("cis_norl");
		},
		
		GrNoRl=
		{
			skin = UI.skins.CheckBox,
			left = 440, top = 343,
			tabstop = 221,
			
			OnChanged = function(self)
				if(self:GetChecked()) then
					setglobal("gr_norl", 1);
				else
					setglobal("gr_norl", 0);
				end
			end,
		},
		
		GrNoBots=
		{
			skin = UI.skins.CheckBox,
			left = 560, top = 192,
			tabstop = 222,
			height = 25,
			OnChanged = function(self)
				if (self:GetChecked()) then
					setglobal("bot_enable",0);
				else
					setglobal("bot_enable",1);
				end
			end,
		},
		
		clip_ag36=
		{
			skin = UI.skins.ComboBox,
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
			left = 440, top = 412,
			width = 55, height = 28,
			tabstop = 360,
			OnChanged = function(Sender)
				local newgs = tonumber( UI.PageCreateServer.GUI.clip_ag36:GetSelectionIndex() ) - 1;
				setglobal( "gr_clip_ag36_gl", newgs );
			end,
		},
		
		clip_oicw=
		{
			skin = UI.skins.ComboBox,
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
			left = 502, top = 412,
			width = 55, height = 28,
			tabstop = 361,
			OnChanged = function(Sender)
				local newgs = tonumber( UI.PageCreateServer.GUI.clip_oicw:GetSelectionIndex() ) - 1;
				setglobal( "gr_clip_oicw_gl", newgs );
			end,
		},

		RightBottomStatic=
		{
			skin = UI.skins.MenuBorder,
			
			left = 600, top = 270,
			width = 180, height = 93,
			
			zorder = -50,
		},

		BottomStatic=
		{
			skin = UI.skins.MenuBorder,
			
			left = 200, top = 362,
			width = 580, height = 97,
			
			zorder = -50,
		},
		
		MODCombo=
		{
			skin = UI.skins.ComboBox,
			
			left = 610, top = 280,
			width = 160, height = 32,
			
			tabstop = 22,
			
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},		
			
			OnChanged = function(Sender)
				UI.PageCreateServer.PopulateLevelCombo();
				
				if (UI.PageCreateServer.GUI.LevelCombo:GetItemCount()) then
				
					if (UI.PageCreateServer.szLastMap) then
						UI.PageCreateServer.GUI.LevelCombo:Select(UI.PageCreateServer.szLastMap);
					elseif (getglobal(gr_NextMap)) then
						UI.PageCreateServer.GUI.LevelCombo:Select(tostring(gr_NextMap));
					end

					if (not UI.PageCreateServer.GUI.LevelCombo:GetSelection()) then
						UI.PageCreateServer.GUI.LevelCombo:SelectIndex(1);
					end
				end
				
				local szMOD = UI.PageCreateServer.GUI.MODCombo:GetSelection();
				
				if szMOD and AvailableMODList[strupper(szMOD)].team==0 then
					UI:HideWidget(UI.PageCreateServer.GUI.FriendlyFireText);
					UI:HideWidget(UI.PageCreateServer.GUI.FriendlyFire);
					UI:HideWidget(UI.PageCreateServer.GUI.MinTeamPlayers);
					UI:HideWidget(UI.PageCreateServer.GUI.MaxTeamPlayers);
					UI:HideWidget(UI.PageCreateServer.GUI.MinTeamPlayersText);
					UI:HideWidget(UI.PageCreateServer.GUI.MaxTeamPlayersText);
				else
					UI:ShowWidget(UI.PageCreateServer.GUI.FriendlyFireText);
					UI:ShowWidget(UI.PageCreateServer.GUI.FriendlyFire);
					UI:ShowWidget(UI.PageCreateServer.GUI.MinTeamPlayers);
					UI:ShowWidget(UI.PageCreateServer.GUI.MaxTeamPlayers);
					UI:ShowWidget(UI.PageCreateServer.GUI.MinTeamPlayersText);
					UI:ShowWidget(UI.PageCreateServer.GUI.MaxTeamPlayersText);
				end
				
				if szMOD and AvailableMODList[strupper(szMOD)].coop then
					UI:ShowWidget(UI.PageCreateServer.GUI.AmmoMult);
					UI:ShowWidget(UI.PageCreateServer.GUI.AmmoMultText);
					UI:ShowWidget(UI.PageCreateServer.GUI.ItemResp);
					UI:ShowWidget(UI.PageCreateServer.GUI.ItemRespText);
					UI:HideWidget(UI.PageCreateServer.GUI.TimeLimit2);
					UI:ShowWidget(UI.PageCreateServer.GUI.TimeLimitJunk);
				else
					UI:HideWidget(UI.PageCreateServer.GUI.AmmoMult);
					UI:HideWidget(UI.PageCreateServer.GUI.AmmoMultText);
					UI:HideWidget(UI.PageCreateServer.GUI.ItemResp);
					UI:HideWidget(UI.PageCreateServer.GUI.ItemRespText);
					UI:HideWidget(UI.PageCreateServer.GUI.TimeLimitJunk);
					UI:ShowWidget(UI.PageCreateServer.GUI.TimeLimit2);
				end
				
				if szMOD and AvailableMODList[strupper(szMOD)].respawntime==1 then
					UI:ShowWidget(UI.PageCreateServer.GUI.RespawnTimeText);
					UI:ShowWidget(UI.PageCreateServer.GUI.RespawnTime);
				else
					UI:HideWidget(UI.PageCreateServer.GUI.RespawnTimeText);
					UI:HideWidget(UI.PageCreateServer.GUI.RespawnTime);
				end
				if (szMOD) and (AvailableMODList[strupper(szMOD)].waitforheli) then
					UI:ShowWidget(UI.PageCreateServer.GUI.TimeLimitT_SU);
					UI:ShowWidget(UI.PageCreateServer.GUI.SU_Handicap);
					UI:ShowWidget(UI.PageCreateServer.GUI.SU_HandicapTxt);
					UI:ShowWidget(UI.PageCreateServer.GUI.SU_Roundlimit);
					UI:ShowWidget(UI.PageCreateServer.GUI.SU_RoundlimitTXT);
					UI:HideWidget(UI.PageCreateServer.GUI.TimeLimitText);
					UI:HideWidget(UI.PageCreateServer.GUI.ScoreLimitText);
					UI:HideWidget(UI.PageCreateServer.GUI.ScoreLimit);
					UI:HideWidget(UI.PageCreateServer.GUI.SU_RoundlimitTXTR);
				else
					UI:HideWidget(UI.PageCreateServer.GUI.TimeLimitT_SU);
					UI:HideWidget(UI.PageCreateServer.GUI.SU_Handicap);
					UI:HideWidget(UI.PageCreateServer.GUI.SU_HandicapTxt);
					UI:HideWidget(UI.PageCreateServer.GUI.SU_Roundlimit);
					UI:HideWidget(UI.PageCreateServer.GUI.SU_RoundlimitTXT);
					UI:HideWidget(UI.PageCreateServer.GUI.SU_RoundlimitTXTR);
					UI:ShowWidget(UI.PageCreateServer.GUI.TimeLimitText);
					UI:ShowWidget(UI.PageCreateServer.GUI.ScoreLimitText);
					UI:ShowWidget(UI.PageCreateServer.GUI.ScoreLimit);
					if (szMOD) and (AvailableMODList[strupper(szMOD)].racing) then
						UI:HideWidget(UI.PageCreateServer.GUI.ScoreLimitText);
						UI:HideWidget(UI.PageCreateServer.GUI.ScoreLimit);
						UI:ShowWidget(UI.PageCreateServer.GUI.SU_Roundlimit);
						UI:ShowWidget(UI.PageCreateServer.GUI.SU_RoundlimitTXTR);
					end
				end
			end
		},
		MODComboLocalized=
		{
			skin = UI.skins.ComboBox,
			
			left = 610, top = 280,
			width = 160, height = 32,
			
			tabstop = 22,
			
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},		
			
			OnChanged = function(Sender)
				UI.PageCreateServer.GUI.MODCombo:SelectIndex(tonumber(UI.PageCreateServer.GUI.MODComboLocalized:GetSelectionIndex()));
				UI.PageCreateServer.GUI.MODCombo.OnChanged(UI.PageCreateServer.GUI.MODCombo);
			end
		},
		
		LevelCombo=
		{
			skin = UI.skins.ComboBox,
			
			left = 610, top = 320,
			width = 160, height = 32,
			
			tabstop = 23,
			
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
		},

		SV_Mcycle=
		{
			skin = UI.skins.ComboBox,
			tabstop = 932,
			left = 210, top = 304,
			width = 153,
			zorder = 78,
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
		},
		
		ServerNameText=
		{
			skin = UI.skins.Label,
			left = 180, top = 152,
			width = 122, 
			text = Localize("ServerName");
		},
		
		ServerName=
		{
			skin = UI.skins.EditBox,
			left = 310, top = 152,
			width = 235,
			tabstop = 24,
			fontsize = 12,
			maxlength = 50,
		},

		ServerPasswordText=
		{
			skin = UI.skins.Label,
			left = 180, top = 192,
			width = 122,
			text = Localize("ServerPassword"),
		},
		
		ServerPassword=
		{
			skin = UI.skins.EditBox,
			
			left = 310, top = 192,
			width = 235,
			height = 25,
			fontsize = 12,
			tabstop = 25,
			maxlength = 28,
		},
		
		BOT_Pquota=
		{
			skin = UI.skins.ComboBox,
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
			left = 610, top = 192,
			width = 55, height = 25,
			tabstop = 36,
			OnChanged = function(Sender)
				local newgs = tonumber( UI.PageCreateServer.GUI.BOT_Pquota:GetSelectionIndex() ) - 1;
				setglobal( "bot_quota", newgs );
			end,
		},
		
		BOT_PquotaTXT=
		{
			skin = UI.skins.Label,
			left = 610, top = 152,
			width = 167,
			halign = UIALIGN_LEFT,
			text = "@botpresence",
		},
		
		BOT_DenyTXT=
		{
			skin = UI.skins.Label,
			left = 554, top = 152,
			width = 97,
			halign = UIALIGN_LEFT,
			text = "@cis_nobots",
		},
		
		BOT_Diff=
		{
			skin = UI.skins.ComboBox,
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
			left = 670, top = 192,
			width = 100, height = 25,
			tabstop = 36,
			OnChanged = function(Sender)
				local newgs = tonumber(UI.PageCreateServer.GUI.BOT_Diff:GetSelectionIndex());
				setglobal("bot_difficulty",newgs);
			end,
		},

		MinTeamPlayersText=
		{
			skin = UI.skins.Label,
			
			left = 235, top = 228,
			width = 264,
			text = Localize("MinTeamPlayers");
		},
		
		MinTeamPlayers=
		{
			skin = UI.skins.EditBox,
			
			halign = UIALIGN_CENTER,
			maxlength = 2,
			numeric = 1,
			disallow = ".",
			zorder = -52,
			tabstop = 26,
		
			left = 507, top = 228,
			width = 38,
		},

		MaxTeamPlayersText=
		{
			skin = UI.skins.Label,
			
			left = 235, top = 266,
			width = 264, 
			
			text = Localize("MaxTeamPlayers");
		},

		MaxTeamPlayers=
		{
			skin = UI.skins.EditBox,
			halign = UIALIGN_CENTER,
			maxlength = 2,
			numeric = 1,
			disallow = ".",
			zorder = -50,
			tabstop = 27,
			left = 507, top = 266,
			width = 38,
		},
		
		----------------------
		ItemRespText=
		{
			skin = UI.skins.Label,
			
			left = 235, top = 228,
			width = 264,
			text = Localize("cis_itemresptime");
		},

		AmmoMultText=
		{
			skin = UI.skins.Label,
			
			left = 235, top = 266,
			width = 264, 
			
			text = Localize("cis_coopammomult");
		},
		ItemResp=
		{
			skin = UI.skins.ComboBox,
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
			left = 507, top = 228,
			width = 55, height = 28,
			tabstop = 360,
			OnChanged = function(Sender)
				local newgs = tonumber( UI.PageCreateServer.GUI.ItemResp:GetSelection() );
				setglobal( "gr_coop_item_respawn_time", newgs);
			end,
		},
		
		AmmoMult=
		{
			skin = UI.skins.ComboBox,
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
			left = 507, top = 266,
			width = 55, height = 28,
			tabstop = 361,
			OnChanged = function(Sender)
				local newgs = tonumber( UI.PageCreateServer.GUI.AmmoMult:GetSelection());
				setglobal( "gr_coop_ammo_mult",newgs);
			end,
		}, 
		---------------------------------

		MaxServerPlayersText=
		{
			skin = UI.skins.Label,
			
			left = 235, top = 304,
			width = 264, 
			
			text = Localize("MaxServerPlayers");
		},

		MaxServerPlayers=
		{
			skin = UI.skins.EditBox,
			
			halign = UIALIGN_CENTER,
			maxlength = 2,
			numeric = 1,
			disallow = ".",
			zorder = -51,
			left = 507, top = 304,
			width = 38,
			
			tabstop = 28,
		},
		
		SV_Ptype=
		{
			skin = UI.skins.ComboBox,
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
			left = 210, top = 266,
			width = 100, height = 25,
			tabstop = 931,
			zorder = 81,
			OnChanged = function(Sender)
				local newgs = tonumber(UI.PageCreateServer.GUI.SV_Ptype:GetSelectionIndex());
				if (newgs == 1) then
					setglobal("sv_ServerType","LAN");
					UI:HideWidget(UI.PageCreateServer.GUI.CreateUBIServerText);
					UI:ShowWidget(UI.PageCreateServer.GUI.CreateLANServerText);
				else
					setglobal("sv_ServerType","UBI");
					UI:ShowWidget(UI.PageCreateServer.GUI.CreateUBIServerText);
					UI:HideWidget(UI.PageCreateServer.GUI.CreateLANServerText);
				end
			end,
		},
		
		SV_Gstyle=
		{
			skin = UI.skins.ComboBox,
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
			left = 210, top = 228,
			width = 125, height = 25,
			tabstop = 931,
			zorder = 82,
			OnChanged = function(Sender)
				local newgs = tonumber(UI.PageCreateServer.GUI.SV_Gstyle:GetSelectionIndex())-1;
				if (newgs) then
					setglobal("gr_gamestyle",newgs);
				end
			end,
		},
		
		FriendlyFireText=
		{
			skin = UI.skins.Label,
			
			left = 540, top = 388,
			width = 194,		
			text = Localize("FriendlyFire"),
		},
		
		
		
		FriendlyFire=
		{
			skin = UI.skins.CheckBox,
			
			left = 742, top = 388,
			width = 28,
			
			tabstop = 29,
		},
		
		NoFatigueText=
		{
			skin = UI.skins.Label,
			
			left = 540, top = 354,
			width = 194,		
			text = Localize("NoFatigue"),
		},
		
		NoFatigue=
		{
			skin = UI.skins.CheckBox,
			
			left = 742, top = 354,
			width = 28,
			tabstop = 571,
			OnChanged = function(self)
				if(self:GetChecked()) then
					setglobal("gr_MpNoFatigue", 1);
				else
					setglobal("gr_MpNoFatigue", 0);
				end
			end,
		},
	
		LoadProfile=
		{
			skin = UI.skins.BottomMenuButton,
			
			text = Localize("LoadServerProfile"),
			
			left = 208,
			width = 147,
			
			tabstop = 30,
			
			OnCommand = function()
				GotoPage("ServerLoadProfile");
			end
		},
		
		SaveProfile=
		{
			skin = UI.skins.BottomMenuButton,
			
			text = Localize("SaveServerProfile"),
			
			tabstop = 31,
			
			left = 363,
			width = 147,
			
			OnCommand = function(Sender)
				UI.InputBoxEx(Localize("SaveServerProfile"), Localize("AskServerProfileName"), g_serverprofile, 0, 1, 0, 0, 28, UI.PageCreateServer.SaveServerProfileOk);
			end
		},
		
		RespawnTimeText=
		{
			skin = UI.skins.Label,
			
			left = 200, top = 343,
			width = 180,
			
			text = Localize("RespawnTime"),
		},
		
		RespawnTime=
		{
			skin = UI.skins.EditBox,
			
			left = 388, top = 343,
			width = 42,
			
			halign = UIALIGN_CENTER,
			maxlength = 3,
			numeric = 1,
			disallow = ".",
			
			tabstop = 32,
		},

		TimeLimitT_SU=
		{
			skin = UI.skins.Label,
			
			left = 200, top = 412,
			width = 180,
			
			text = "@HeliTime",
		},
		TimeLimitText=
		{
			skin = UI.skins.Label,
			
			left = 200, top = 412,
			width = 180,
			
			text = "@TimeLimit",
		},
		TimeLimitJunk= -- strange glitchy field
		{
			skin = UI.skins.EditBox,
			
			left = 388, top = 412,
			width = 42,
			
			halign = UIALIGN_CENTER,
			maxlength = 3,
			numeric = 1,
			tabstop = 40,
		},
		TimeLimit2=
		{
			skin = UI.skins.EditBox,
			
			left = 388, top = 412,
			width = 42,
			
			halign = UIALIGN_CENTER,
			maxlength = 3,
			numeric = 1,
			tabstop = 40,	
		},
		ScoreLimitText=
		{
			skin = UI.skins.Label,
			left = 200, top = 378,
			width = 180,
			text = "@cis_scorelimit1",
		},
		ScoreLimit=
		{
			skin = UI.skins.EditBox,
			
			left = 388, top = 378,
			width = 42,
			
			halign = UIALIGN_CENTER,
			maxlength = 3,
			numeric = 1,
			
			tabstop = 34,		
		},

		SU_RoundlimitTXT=
		{
			skin = UI.skins.Label,
			left = 200, top = 378,
			width = 180,
			text = "@su_ui_roundlimit",
		},
		SU_RoundlimitTXTR=
		{
			skin = UI.skins.Label,
			left = 200, top = 378,
			width = 180,
			text = "@su_racing_roundlimit",
		},
		SU_Roundlimit=
		{
			skin = UI.skins.EditBox,
			left = 388, top = 378,
			width = 42,
			halign = UIALIGN_CENTER,
			maxlength = 3,
			numeric = 1,
			tabstop = 35,		
		},
		-- survival
		SU_Handicap=
		{
			skin = UI.skins.EditBox,
			
			left = 388, top = 343,
			width = 42,
			disallow = ".",
			halign = UIALIGN_CENTER,
			maxlength = 3,
			tabstop = 37,	
		},
		SU_HandicapTxt=
		{
			skin = UI.skins.Label,
			left = 200, top = 343,
			width = 180,
			text = Localize("Su_handicapping"),
		},
		----
		RMatch=
		{
			left = 610, top = 230,
			width = 160, height = 32,

			skin = UI.skins.ComboBox,

			tabstop = 38, -- ?
			
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},

			OnChanged = function( Sender )
				local newgs = tonumber( UI.PageCreateServer.GUI.RMatch:GetSelectionIndex() ) - 1;
				setglobal( "cis_railonly", newgs );
			end,
		},
		----

		Launch=
		{
			skin = UI.skins.BottomMenuButton,
			
			left = 780-180,
			tabstop = 39,
			text = Localize("Launch"),
			
			OnCommand = function(Sender)
				local GUI = UI.PageCreateServer.GUI;
				local modfolder = "";
				local szLevel = GUI.LevelCombo:GetSelection();
				local szName = GUI.ServerName:GetText();
				local iMaxServerPlayers = tonumber(GUI.MaxServerPlayers:GetText());
				local stest_mc = UI.PageCreateServer.GUI.SV_Mcycle:GetSelection();
				if (stest_mc) and (stest_mc~="") then
					for i, val in Game:GetModsList() do
						if (val.CurrentMod) then
							modfolder = val.Folder.."/";
							break;
						end
					end

					stest_mc = openfile(modfolder..stest_mc,"r");
					if (stest_mc) then
						closefile(stest_mc); stest_mc = nil;
						if (MapCycle) then
							MapCycle:Reload();
						end
					else
						UI.MessageBox("@Error", "@cis_nomaplist \n"..UI.PageCreateServer.GUI.SV_Mcycle:GetSelection());
						return
					end
				end

				if (szLevel == nil) then
					UI.MessageBox("@Error", "@CreateServerSelectMap");
					return
				end

				if (not szName or strlen(szName) < 1) then
					UI.MessageBox("@Error", "@CreateServerTypeName");
					return
				end
			
				if (not iMaxServerPlayers or iMaxServerPlayers > 32) then
					UI.MessageBox("@Error", "@CreateServerMaxPlayers");
					return
				end			
				
				local bOk = 1;
				
				local szText = GUI.MinTeamPlayers:GetText();
				if (UI:IsWidgetVisible(GUI.MinTeamPlayers) and (not szText or (strlen(szText) < 1))) then bOk = 0;	end
							
				szText = GUI.MaxTeamPlayers:GetText();
				if (UI:IsWidgetVisible(GUI.MaxTeamPlayers) and (not szText or (strlen(szText) < 1))) then bOk = 0;	end

				szText = GUI.MaxServerPlayers:GetText();
				if (UI:IsWidgetVisible(GUI.MaxServerPlayers) and (not szText or (strlen(szText) < 1))) then bOk = 0;	end

				szText = GUI.RespawnTime:GetText();
				if (UI:IsWidgetVisible(GUI.RespawnTime) and (not szText or (strlen(szText) < 1))) then bOk = 0; end
				
				szText = GUI.SU_Handicap:GetText();
				if (UI:IsWidgetVisible(GUI.SU_Handicap)) then
					if (not szText) or (strlen(szText) < 1) then
						bOk = 0;
					elseif (tonumber(szText) > 10) then
						bOk = 0;
						UI.MessageBox("@Error","@su_morethanten");
						return
					end
				end

				szText = GUI.TimeLimit2:GetText();
				if (UI:IsWidgetVisible(GUI.TimeLimit2) and (not szText or (strlen(szText) < 1))) then bOk = 0; end
				
				szText = GUI.ScoreLimit:GetText();
				if (UI:IsWidgetVisible(GUI.ScoreLimit) and (not szText or (strlen(szText) < 1))) then bOk = 0; end
				
				if (not bOk or (bOk == 0)) then
					UI.MessageBox("@Error", "@CreateServerFieldEmpty");
					return
				end

				local iMinTeamPlayers = tonumber(GUI.MinTeamPlayers:GetText());
				local iMaxTeamPlayers = tonumber(GUI.MaxTeamPlayers:GetText());
				local iMaxServerSlots = tonumber(GUI.MaxServerPlayers:GetText());
				
				if (UI:IsWidgetVisible(GUI.MaxTeamPlayers)) then
					if (iMaxTeamPlayers > iMaxServerSlots) then
						UI.MessageBox("@Error", "@MaxPlayersTooHigh");
						return
					end
				end
				
				if (UI:IsWidgetVisible(GUI.MinTeamPlayers)) then
					if (iMinTeamPlayers > iMaxTeamPlayers) then
						UI.MessageBox("@Error", "@MinPlayersTooHigh");
					
						return
					end
					
					if (iMinTeamPlayers > floor(iMaxServerPlayers*0.5)) then
						UI.MessageBox("@Error", "@MinPlayersTooHigh2");
					
						return					
					end
				end
				
				setglobal("g_LastServerName", szName);
				
				UI.PageCreateServer.RefreshVars();			
				UI.PageCreateServer.szGameMessage = "StartLevel "..szLevel.." listen";
				UI.PageCreateServer.szLastMap = szLevel;
				UI:Ecfg("bin32/rc.ini","LastPlayedMap",szLevel);
				UI:Ecfg("bin32/rc.ini","LastPlayedGameType",GUI.MODCombo:GetSelectionIndex());
				UI.PageCreateServer.LaunchServer();
			end
		},

		OnActivate = function(Sender)

			UI.PageCreateServer.bCreatingNETServer = nil;
			UI.PageCreateServer.szGameMessage = nil;

			UI.PageCreateServer.GUI.RMatch:Clear();
			UI.PageCreateServer.GUI.RMatch:AddItem("@cis_allweap");
			UI.PageCreateServer.GUI.RMatch:AddItem("@RailbowOnly");
			UI.PageCreateServer.GUI.RMatch:AddItem("@InstaGib");

			UI.PageCreateServer.GUI.SV_Gstyle:Clear();
			UI.PageCreateServer.GUI.SV_Gstyle:AddItem("@cis_gs_classic");
			UI.PageCreateServer.GUI.SV_Gstyle:AddItem("@cis_gs_hardcore");
			UI.PageCreateServer.GUI.SV_Gstyle:AddItem("@cis_gs_extreme");
			UI.PageCreateServer.GUI.SV_Gstyle:AddItem("@cis_gs_unreal");
			UI.PageCreateServer.GUI.SV_Gstyle:AddItem("@cis_gs_stunt");
			UI.PageCreateServer.GUI.SV_Gstyle:AddItem("@cis_gs_crazy");
			
			UI.PageCreateServer.GUI.SV_Ptype:Clear();
			UI.PageCreateServer.GUI.SV_Ptype:AddItem("@cis_local");
			UI.PageCreateServer.GUI.SV_Ptype:AddItem("@cis_global");

			UI.PageCreateServer.GUI.BOT_Diff:Clear();
			UI.PageCreateServer.GUI.BOT_Diff:AddItem("@DifficultyEasy");
			UI.PageCreateServer.GUI.BOT_Diff:AddItem("@DifficultyMedium");
			UI.PageCreateServer.GUI.BOT_Diff:AddItem("@DifficultyHard");

			UI.PageCreateServer.GUI.BOT_Pquota:Clear();
			local bq_item = 0;
			while bq_item < 33 do
				UI.PageCreateServer.GUI.BOT_Pquota:AddItem(""..bq_item);
				bq_item=bq_item+1;
			end
			
			UI.PageCreateServer.GUI.clip_oicw:Clear();
			bq_item = 0;
			while bq_item < 5 do
				UI.PageCreateServer.GUI.clip_oicw:AddItem(""..bq_item);
				bq_item=bq_item+1;
			end
			
			UI.PageCreateServer.GUI.clip_ag36:Clear();
			UI.PageCreateServer.GUI.clip_ag36:AddItem("0");
			UI.PageCreateServer.GUI.clip_ag36:AddItem("1");
			
			UI.PageCreateServer.GUI.ItemResp:Clear();
			UI.PageCreateServer.GUI.ItemResp:AddItem("5");
			UI.PageCreateServer.GUI.ItemResp:AddItem("10");
			UI.PageCreateServer.GUI.ItemResp:AddItem("15");
			UI.PageCreateServer.GUI.ItemResp:AddItem("20");
			UI.PageCreateServer.GUI.ItemResp:AddItem("25");
			UI.PageCreateServer.GUI.ItemResp:AddItem("30");
			
			UI.PageCreateServer.GUI.AmmoMult:Clear();
			bq_item = 1;
			while bq_item < 21 do
				UI.PageCreateServer.GUI.AmmoMult:AddItem(""..bq_item);
				bq_item=bq_item+1;
			end

			--bq_item = System:LoadImage("textures/gui/admin_glclips");
			--UI.PageCreateServer.GUI.ClipImage:SetTexture(bq_item);
			-- Connection
			
			UI.PageCreateServer.GUI.SV_Mcycle:Clear();
			local modfolder = "";
			for i, val in Game:GetModsList() do
				if (val.CurrentMod) then
					modfolder = val.Folder.."";
					break;
				end
			end
			local svg_files = System:ScanDirectory(modfolder, SCANDIR_FILES);
			if (svg_files and getn(svg_files) > 0) then
				for i,filename in svg_files do
					filename = strlower(filename);
					if (strfind(filename,".txt") ~= nil) then
						if (filename~="moddesc.txt") and (filename~="readme.txt") then
							UI.PageCreateServer.GUI.SV_Mcycle:AddItem(filename);
						end
					end
				end
			end 


			
			Sender.Connection:Clear();
			
			for i=1,count(UI.PageCreateServer.ConnectionSettings) do
				Sender.Connection:AddItem(UI.PageCreateServer.ConnectionSettings[i].name);
			end		
	
			local szSelection = UI.PageCreateServer:GetConnection();
			
			if szSelection then
				Sender.Connection:Select(szSelection);
			end
	
			--	
							
			if (UI.PageCreateServer.bDoNotRefreshList) then
				UI.PageCreateServer.bDoNotRefreshList = nil;
			else
				UI.PageCreateServer.GUI.MODCombo:Clear();
				UI.PageCreateServer.GUI.MODComboLocalized:Clear();
				

				for name, MOD in AvailableMODList do
					UI.PageCreateServer.GUI.MODCombo:AddItem(name);
					UI.PageCreateServer.GUI.MODComboLocalized:AddItem("@gt_"..name);
				end

				UI.PageCreateServer.RefreshLevelList();
			end
			
			UI.PageCreateServer.szLastMap = UI:Ecfg("bin32/rc.ini","LastPlayedMap",szLevel);

			UI.PageCreateServer.RefreshWidgets();
		end
	},
			
	LaunchServer = function()
	
		if(UI.PageCreateServer.GUI.PunkBuster:GetChecked()) then
			setglobal("gr_bleeding", 1);
		else
			setglobal("gr_bleeding", 0);
		end
				
		Game:SendMessage(UI.PageCreateServer.szGameMessage);

		UI.PageCreateServer.szGameMessage = nil;
	end,
	
	
	RefreshLevelList = function()
		UI.PageCreateServer.LevelList = {};
		
		-- create the tables
		for name, MOD in AvailableMODList do
			local szMission = MOD.mission;
			
			UI.PageCreateServer.LevelList[szMission] = {};
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
						tinsert(UI.PageCreateServer.LevelList[szMission], Level.Name);
						-- tinsert adds a "n" key, so we just remove it here
						UI.PageCreateServer.LevelList[szMission].n = nil;
						break;
					end
				end
			end
		end
	end,
	
	PopulateLevelCombo = function()
		local szMOD = UI.PageCreateServer.GUI.MODCombo:GetSelection();
		
		UI.PageCreateServer.GUI.LevelCombo:Clear();
		if (szMOD) then
			local szMission = AvailableMODList[strupper(szMOD)].mission;
			
			for i, szLevelName in UI.PageCreateServer.LevelList[szMission] do
				UI.PageCreateServer.GUI.LevelCombo:AddItem(szLevelName);
			end
		end
		
		UI.PageCreateServer.GUI.LevelCombo:SelectIndex(1);
	end,
	
	IsUBIOrLAN = function()
		if (getglobal("sv_ServerType")=="UBI") then
			return 1;
		end
	end,
	
	RefreshWidgets = function()
		local GUI = UI.PageCreateServer.GUI;
		UI:HideWidget(GUI.MODCombo);
		
		if getglobal("gr_coop_ammo_mult") == nil then
			Game:CreateVariable("gr_coop_ammo_mult",2);
		else
			Game:CreateVariable("gr_coop_ammo_mult",getglobal("gr_coop_ammo_mult"));
		end
		if getglobal("gr_coop_item_respawn_time") == nil then
			Game:CreateVariable("gr_coop_item_respawn_time",20);
		else
			Game:CreateVariable("gr_coop_item_respawn_time",getglobal("gr_coop_item_respawn_time"));
		end
		if getglobal("gr_coop_timelimit") == nil then
			Game:CreateVariable("gr_coop_timelimit",0);
		else
			Game:CreateVariable("gr_coop_timelimit",getglobal("gr_coop_timelimit"));
		end
		
		GUI.MinTeamPlayers:SetText(floor(tonumber(getglobal("gr_MinTeamLimit"))));
		GUI.MaxTeamPlayers:SetText(floor(tonumber(getglobal("gr_MaxTeamLimit"))));
		GUI.MaxServerPlayers:SetText(floor(getglobal("sv_maxplayers")));
		
		GUI.TimeLimitJunk:SetText(floor(getglobal("gr_coop_timelimit")));
		GUI.TimeLimit2:SetText(floor(getglobal("gr_TimeLimit")));

		GUI.ScoreLimit:SetText(floor(getglobal("gr_ScoreLimit")));

		if getglobal("bot_quota") == nil then
			Game:CreateVariable("bot_quota",0);
		else
			Game:CreateVariable("bot_quota",getglobal("bot_quota"));
		end
		if getglobal("bot_difficulty") == nil then
			Game:CreateVariable("bot_difficulty",2);
		else
			Game:CreateVariable("bot_difficulty",getglobal("bot_difficulty"));
		end

		if getglobal("bot_enable") == nil then
			Game:CreateVariable("bot_enable",1);
		else
			Game:CreateVariable("bot_enable",getglobal("bot_enable"));
		end
		if getglobal("cis_mapcycle") == nil then
			local modfolder = "";
			Game:CreateVariable("cis_mapcycle","fc-vanilla-maplist.txt");
			for i, val in Game:GetModsList() do
				if (val.CurrentMod) then
					modfolder = val.Folder.."";
					break;
				end
			end
			-- check for presence of CII campaign (map pack)
			local svg_files = System:ScanDirectory(modfolder, SCANDIR_FILES);
			if (svg_files and getn(svg_files) > 0) then
				for i,filename in svg_files do
					filename = strlower(filename);
					if (strfind(filename,"maps.pak") ~= nil) then
						setglobal("cis_mapcycle","contestisle-maplist.txt");
						break;
					end
				end
			end 
		else
			Game:CreateVariable("cis_mapcycle",getglobal("cis_mapcycle"));
		end
		---
		if getglobal("gr_su_roundlimit") == nil then
			Game:CreateVariable("gr_su_roundlimit",0);
		else
			Game:CreateVariable("gr_su_roundlimit",getglobal("gr_su_roundlimit"));
		end
		if getglobal("gr_su_handicap") == nil then
			Game:CreateVariable("gr_su_handicap",0);
		else
			Game:CreateVariable("gr_su_handicap",getglobal("gr_su_handicap"));
		end
		GUI.SV_Mcycle:Select(getglobal("cis_mapcycle"));
		------

		GUI.SU_Handicap:SetText(floor(getglobal("gr_su_handicap")));
		GUI.SU_Roundlimit:SetText(floor(getglobal("gr_su_roundlimit")));
		if (not getglobal("sv_name") or (strlen(getglobal("sv_name")) < 1)) or (strlower(getglobal("sv_name"))==strlower(" "..System.this_mod_version)) then
			setglobal("sv_name", "Far Cry Return Server");
		end
		
		-- Mixer: cut out server version, if was added during server run
		local tmodsvname = getglobal("sv_name");
		local tmodversion = strfind(tmodsvname,System.this_mod_version);
		if (tmodversion) then
			setglobal("sv_name",strsub(tmodsvname,1,tmodversion-2));
		end

		GUI.ServerName:SetText(sv_name);	

		if (sv_password) then
			GUI.ServerPassword:SetText(sv_password);
		end

		if UI.PageCreateServer.IsUBIOrLAN() then
			UI:ShowWidget(UI.PageCreateServer.GUI.CreateUBIServerText);
			UI:HideWidget(UI.PageCreateServer.GUI.CreateLANServerText);
		else
			UI:HideWidget(UI.PageCreateServer.GUI.CreateUBIServerText);
			UI:ShowWidget(UI.PageCreateServer.GUI.CreateLANServerText);
		end

		if (gr_FriendlyFire and (tonumber(gr_FriendlyFire) ~= 0)) then
			GUI.FriendlyFire:SetChecked(1);
		else
			GUI.FriendlyFire:SetChecked(0);
		end
		
		if (toNumberOrZero(getglobal("gr_norl"))==1) then
			GUI.GrNoRl:SetChecked(1);
		else
			GUI.GrNoRl:SetChecked(0);
		end
		
		if (toNumberOrZero(getglobal("bot_enable"))==0) then
			GUI.GrNoBots:SetChecked(1);
		else
			GUI.GrNoBots:SetChecked(0);
		end

		if (toNumberOrZero(getglobal("gr_bleeding"))~=0) then
			GUI.PunkBuster:SetChecked(1);
		else
			GUI.PunkBuster:SetChecked(0);
		end
		
		if (toNumberOrZero(getglobal("gr_MpNoFatigue"))>0) then
			GUI.NoFatigue:SetChecked(1);
		else
			GUI.NoFatigue:SetChecked(0);
		end

		GUI.RespawnTime:SetText(floor(getglobal("gr_RespawnTime")));

		if (g_GameType and (g_GameType ~= "Default")) then
			GUI.MODCombo:Select(g_GameType);
			GUI.MODComboLocalized:Select("@gt_"..strupper(g_GameType));
		else
			local savd_id = UI:Ecfg("bin32/rc.ini","LastPlayedGameType");
			if (savd_id) then
				GUI.MODCombo:SelectIndex(savd_id);
				GUI.MODComboLocalized:SelectIndex(savd_id);
			else
				GUI.MODCombo:Select("FFA");
				GUI.MODComboLocalized:Select("@gt_FFA");
			end
		end

		GUI.MODCombo.OnChanged(GUI.MODCombo);
		
		local cur_gs = tonumber( getglobal( "cis_railonly" ) );
		UI.PageCreateServer.GUI.RMatch:SelectIndex( cur_gs + 1 );
		
		local cur_qu = tonumber( getglobal( "bot_quota" ) );
		UI.PageCreateServer.GUI.BOT_Pquota:SelectIndex( cur_qu + 1 );
		
		local cur_diff = tonumber(getglobal("bot_difficulty"));
		UI.PageCreateServer.GUI.BOT_Diff:SelectIndex(cur_diff);
		
		local cur_clip = tonumber(getglobal("gr_clip_oicw_gl"));
		UI.PageCreateServer.GUI.clip_oicw:SelectIndex(cur_clip + 1);
		cur_clip = tonumber(getglobal("gr_clip_ag36_gl"));
		UI.PageCreateServer.GUI.clip_ag36:SelectIndex(cur_clip + 1);
		
		local cur_ps = getglobal("sv_ServerType");
		if (cur_ps == "LAN") then
			UI.PageCreateServer.GUI.SV_Ptype:SelectIndex(1);
		else
			UI.PageCreateServer.GUI.SV_Ptype:SelectIndex(2);
		end
		
		cur_gs = tonumber( getglobal( "gr_gamestyle" ) );
		UI.PageCreateServer.GUI.SV_Gstyle:SelectIndex( cur_gs + 1 );
		
		cur_gs = tonumber( getglobal( "gr_coop_item_respawn_time" ) );
		UI.PageCreateServer.GUI.ItemResp:Select(floor(cur_gs));
		cur_gs = tonumber( getglobal( "gr_coop_ammo_mult" ) );
		UI.PageCreateServer.GUI.AmmoMult:Select(floor(cur_gs));

		if (UI.PageCreateServer.szLastMap) then
			GUI.LevelCombo:Select(UI.PageCreateServer.szLastMap);
		elseif (getglobal("gr_NextMap")) then
			GUI.LevelCombo:Select(tostring(gr_NextMap));
		end

		if (not UI.PageCreateServer.GUI.LevelCombo:GetSelection()) then
			UI.PageCreateServer.GUI.LevelCombo:SelectIndex(1);
		end				
	end,

	RefreshVars = function()
		local GUI = UI.PageCreateServer.GUI;
		
		local szMOD = GUI.MODCombo:GetSelection();
		local szServerName = GUI.ServerName:GetText();
		local szServerPassword = GUI.ServerPassword:GetText();
		local szNextMap = GUI.LevelCombo:GetSelection()
		local iMinTeamPlayers = GUI.MinTeamPlayers:GetText();
		local iMaxTeamPlayers = GUI.MaxTeamPlayers:GetText();
		local iMaxServerPlayers = GUI.MaxServerPlayers:GetText();
		local iRespawnTime = GUI.RespawnTime:GetText();
		local iTimeLimit = GUI.TimeLimit2:GetText();
		local iTimeLimitJunk = GUI.TimeLimitJunk:GetText();
		local iScoreLimit = GUI.ScoreLimit:GetText();
		local iSuhandicap = GUI.SU_Handicap:GetText();
		local iSuroundlimit = GUI.SU_Roundlimit:GetText();
		local szServerType = getglobal("sv_ServerType");
		local szMcfile = GUI.SV_Mcycle:GetSelection();
		local iFriendlyFire = 0;
		local iPunkBuster = 0;

		UI.PageCreateServer.ApplyConnection();
		
		if GUI.FriendlyFire:GetChecked() then	
			iFriendlyFire = 1; 
		end

		if GUI.PunkBuster:GetChecked() then	
			iPunkBuster = 1; 
		end
		
		if szMOD and AvailableMODList[strupper(szMOD)].team==0 then
			iFriendlyFire = 0; 
		end
						
		UI.PageCreateServer.DOVarI("gr_MinTeamLimit", iMinTeamPlayers);
		UI.PageCreateServer.DOVarI("gr_MaxTeamLimit", iMaxTeamPlayers);
		UI.PageCreateServer.DOVarI("sv_maxplayers", iMaxServerPlayers);
		UI.PageCreateServer.DOVarI("gr_RespawnTime", iRespawnTime);
		UI.PageCreateServer.DOVarI("gr_coop_timelimit",iTimeLimitJunk);
		UI.PageCreateServer.DOVarI("gr_TimeLimit",iTimeLimit);
		UI.PageCreateServer.DOVarI("gr_ScoreLimit",iScoreLimit);
		UI.PageCreateServer.DOVarI("gr_su_handicap", iSuhandicap);
		UI.PageCreateServer.DOVarI("gr_su_roundlimit", iSuroundlimit);
		UI.PageCreateServer.DOVarS("gr_NextMap", szNextMap);
		UI.PageCreateServer.DOVarS("sv_ServerType", szServerType);
		UI.PageCreateServer.DOVarS("cis_mapcycle",szMcfile);
		UI.PageCreateServer.DOVarB("gr_FriendlyFire", iFriendlyFire);
		UI.PageCreateServer.DOVarB("gr_bleeding", iPunkBuster);
		UI.PageCreateServer.DOVarS("sv_name", szServerName);
		UI.PageCreateServer.DOVarS("g_LastServerName", szServerName);
		UI.PageCreateServer.DOVarS("sv_password", szServerPassword);
		if (szMOD) then
			UI.PageCreateServer.DOVarS("g_GameType", strupper(szMOD));	
		end
	end,
	
	DOVarS = function (szVarName, szValue)
		if (szValue and (strlen(szValue))) then
			setglobal(szVarName,szValue);
		else
			setglobal(szVarName, "");
		end
	end,
	
	DOVarB = function (szVarName, bValue)
		if (bValue and (bValue ~= 0)) then
			Game:SetVariable(szVarName, 1);
		else
			Game:SetVariable(szVarName, 0);
		end
	end,
	
	DOVarI = function (szVarName, iValue)
		if (iValue) then
			local iVal=tonumber(iValue);
			if not iVal then
				iVal=0;
			end
			Game:SetVariable(szVarName, iVal);
		else
			Game:SetVariable(szVarName, 0);
		end
	end,
	
	SaveServerProfileOk = function(ProfileName)	
		
		if ProfileName then
			UI.PageCreateServer.szSaveFileName = "profiles/server/"..ProfileName.."_server.cfg";
			UI.PageCreateServer.szProfileName = ProfileName;
			
			-- check if the file exists
			local hFile = openfile (UI.PageCreateServer.szSaveFileName, "r");
			
			if (hFile) then
				closefile(hFile);
				
				UI.YesNoBox(Localize("OverwriteConfirmation"), Localize("SProfileOverwrite"), UI.PageCreateServer.SaveProfile);
			else
				UI.PageCreateServer.SaveProfile();
			end
		end
					
		return 1;
	end,
	
	WriteVarsToScript = function(hFile, VarNameList)
		local iNameMaxLen = 0;
		local iNameLen = 0;

		-- find the maximum length of varname
		-- to output a pretty aligned file
		for i, szVarName in VarNameList do
			iNameLen = strlen(szVarName);
			if (iNameLen > iNameMaxLen) then
				iNameMaxLen = iNameLen;
			end
		end
		
		for i, szVarName in VarNameList do
			local szValue = Game:GetVariable(szVarName);
			
			if (szValue == nil) then
				szValue = "nil";
			else
				szValue = tostring(szValue);
			end
			write(hFile, szVarName..strrep(" ", iNameMaxLen + 1 - strlen(szVarName)).."= "..format('%q', szValue).."\n");
		end
	end,	
	
	SaveProfile = function()
	
		UI.PageCreateServer.RefreshVars();
		
		if (UI.PageCreateServer.szSaveFileName) then
			hFile = openfile(UI.PageCreateServer.szSaveFileName, "w");
			
			if (hFile) then
			
				local VarsToSave =
				{
				"g_GameType",
				"gr_FriendlyFire",
				"gr_MinTeamLimit",
				"gr_MaxTeamLimit",
				"sv_maxplayers",
				"cis_mapcycle",
				"gr_NextMap",
				"sv_ServerType",
				"sv_password",
				"sv_name",
				"gr_RespawnTime",
				"gr_su_handicap",
				"cis_railonly",
				"bot_quota",
				"bot_difficulty",
				"bot_enable",
				"gr_su_roundlimit",
				"gr_TimeLimit",
				"gr_ScoreLimit",
				"gr_bleeding",
				"gr_norl",
				"gr_clip_ag36_gl",
				"gr_clip_oicw_gl",
				"gr_gamestyle",
				"gr_MpNoFatigue",
				"gr_coop_ammo_mult",
				"gr_coop_item_respawn_time",
				"gr_coop_timelimit",
				};
				
				if UI.PageCreateServer.IsUBIOrLAN() then
					VarsToSave[count(VarsToSave)+1]="sv_maxrate";				-- bitspersecond per player for internet
				else
					VarsToSave[count(VarsToSave)+1]="sv_maxrate_lan";		-- bitspersecond per player for lan
				end
			
				UI.PageCreateServer.WriteVarsToScript(hFile,VarsToSave);
				
				closefile(hFile);
			end
			
			Game:SetVariable("g_serverprofile", UI.PageCreateServer.szProfileName);

			UI.PageCreateServer.szSaveFileName = nil;
			UI.PageCreateServer.szProfileName = nil;
		end
	end,
	
	LoadDefaultProfile = function()
		if (g_serverprofile and (strlen(g_serverprofile) > 0)) then
			System:Log("serverprofile: "..tostring(g_serverprofile));
			UI.PageCreateServer.szLoadFileName = "profiles/server/"..g_serverprofile.."_server.cfg";
			UI.PageCreateServer.LoadProfile();
		end
	end,
	
	LoadProfile = function()
		System:Log("loading "..tostring(UI.PageCreateServer.szLoadFileName));
		if (UI.PageCreateServer.szLoadFileName) then
		
			local hfile = openfile(UI.PageCreateServer.szLoadFileName, "r");

			if (hfile) then
				closefile(hfile);
			
				Script:LoadScript(UI.PageCreateServer.szLoadFileName, 1);
			
				if (UI.PageCreateServer.szProfileName) then			
					Game:SetVariable("g_serverprofile", UI.PageCreateServer.szProfileName);
				end
			end			
			
			UI.PageCreateServer.RefreshWidgets();
			UI.PageCreateServer.bDoNotRefreshList = 1;
			UI.PageCreateServer.szProfileName = nil;
			
			--if (gr_bleeding and tonumber(gr_bleeding) ~= 0) then
			--	setglobal("cl_punkbuster", 1);
			--else
				--setglobal("cl_punkbuster", 0);
			--end
		end
	end,
	
	ConnectionSettings=
	{
		{ name="10Kb/s",bits=10000, },
		{ name="11Kb/s",bits=11000, },
		{ name="12Kb/s",bits=12000, },
		{ name="13Kb/s",bits=13000, },
		{ name="14Kb/s",bits=14000, },
		{ name="15Kb/s",bits=15000, },
		{ name="16Kb/s",bits=16000, },
		{ name="17Kb/s",bits=17000, },
		{ name="18Kb/s",bits=18000, },
		{ name="19Kb/s",bits=19000, },
		{ name="20Kb/s",bits=20000, },
		{ name="21Kb/s",bits=21000, },
		{ name="22Kb/s",bits=22000, },
		{ name="23Kb/s",bits=23000, },
		{ name="24Kb/s",bits=24000, },
		{ name="25Kb/s",bits=25000, },
		{ name="26Kb/s",bits=26000, },
		{ name="27Kb/s",bits=27000, },
		{ name="28Kb/s",bits=28000, },
		{ name="29Kb/s",bits=29000, },
		{ name="30Kb/s",bits=30000, },
		{ name="31Kb/s",bits=31000, },
		{ name="32Kb/s",bits=32000, },
		{ name="33Kb/s",bits=33000, },
		{ name="34Kb/s",bits=34000, },
		{ name="35Kb/s",bits=35000, },
		{ name="36Kb/s",bits=36000, },
		{ name="37Kb/s",bits=37000, },
		{ name="38Kb/s",bits=38000, },
		{ name="39Kb/s",bits=39000, },
		{ name="40Kb/s",bits=40000, },
		{ name="41Kb/s",bits=41000, },
		{ name="42Kb/s",bits=42000, },
		{ name="43Kb/s",bits=43000, },
		{ name="44Kb/s",bits=44000, },
		{ name="45Kb/s",bits=45000, },
		{ name="46Kb/s",bits=46000, },
		{ name="47Kb/s",bits=47000, },
		{ name="48Kb/s",bits=48000, },
		{ name="49Kb/s",bits=49000, },
		{ name="50Kb/s",bits=50000, },
		{ name="60Kb/s",bits=60000, },
		{ name="70Kb/s",bits=70000, },
		{ name="80Kb/s",bits=80000, },
		{ name="90Kb/s",bits=90000, },
		{ name="100Kb/s",bits=100000, },
	},
	
	-- this is where you apply your connection settings
	-- this is called right after the user changes the combobox
	ApplyConnection = function()

		local szConnection = UI.PageCreateServer.GUI.Connection:GetSelection();
		
		if szConnection then  -- not user settings

			System:Log("Applying Network Connection Settings for: "..tostring(szConnection));
			
			for i=1,count(UI.PageCreateServer.ConnectionSettings) do
				if UI.PageCreateServer.ConnectionSettings[i].name==szConnection then

					if UI.PageCreateServer.IsUBIOrLAN() then
						setglobal("sv_maxrate",UI.PageCreateServer.ConnectionSettings[i].bits); 		-- bitspersecond per player for internet
					else
						setglobal("sv_maxrate_lan",UI.PageCreateServer.ConnectionSettings[i].bits);	-- bitspersecond per player for lan
					end
					
					return;
				end
			end
		end
	end,

	-- this func must be implemented,
	-- and it should return the connection string that best represents the current setting
	-- or nil, for custom settings
	GetConnection = function()
	
		local bits;
	
		if UI.PageCreateServer.IsUBIOrLAN() then
			bits=tonumber(getglobal("sv_maxrate")); 		-- bitspersecond per player for internet
		else
			bits=tonumber(getglobal("sv_maxrate_lan"));	-- bitspersecond per player for lan
		end
		
		for i=1,count(UI.PageCreateServer.ConnectionSettings) do
			if UI.PageCreateServer.ConnectionSettings[i].bits==bits then
				return UI.PageCreateServer.ConnectionSettings[i].name;
			end
		end		
		
		return nil;			-- user settings
	end,
}

UI.PageServerLoadProfile=
{
	GUI=
	{
		ProfileList= 
		{
			skin = UI.skins.ListView,
			left = 200, top = 141,
			width = 580, height = 318,
			
			vscrollbar =
			{
				skin = UI.skins.VScrollBar,
			},
			
			hscrollbar =
			{
				skin = UI.skins.VScrollBar,
			},
			
			OnChanged = function(self)
				if (self:GetSelection(0)) then
					UI:EnableWidget(UI.PageServerLoadProfile.GUI.RemoveProfile);
					UI:EnableWidget(UI.PageServerLoadProfile.GUI.LoadProfile);
				else
					UI:DisableWidget(UI.PageServerLoadProfile.GUI.RemoveProfile);
					UI:DisableWidget(UI.PageServerLoadProfile.GUI.LoadProfile);				
				end
			end
		},
		
		LoadProfile=
		{
			skin = UI.skins.BottomMenuButton,	
			left = 780-180,
			
			text = Localize("LoadServerProfile"),
			
			OnCommand = function(Sender)
				local sel=UI.PageServerLoadProfile.GUI.ProfileList:GetSelection(0);
				if sel then
					local ProfileName = UI.PageServerLoadProfile.GUI.ProfileList:GetItem(sel);
					if (ProfileName) then
						UI.PageCreateServer.szLoadFileName = "profiles/server/"..ProfileName.."_server.cfg";
						UI.PageCreateServer.szProfileName = ProfileName;
						UI.PageCreateServer.LoadProfile();
	
						GotoPage("CreateServer");
					end
				end
			end
		},

		RemoveProfile=
		{
			skin = UI.skins.BottomMenuButton,	
			left = 780-180-178,
			
			text = Localize("RemoveServerProfile"),
			
			OnCommand = function(Sender)
				local sel=UI.PageServerLoadProfile.GUI.ProfileList:GetSelection(0);
				if sel then
					local ProfileName = UI.PageServerLoadProfile.GUI.ProfileList:GetItem(sel);
					if (ProfileName) then
						UI.YesNoBox(Localize("RemoveProfile"), Localize("RemoveProfileConfirmation"), UI.PageServerLoadProfile.OnRemoveYes);
					end
				end
			end
		},
		
		OnActivate = function(Sender)
			UI.PageServerLoadProfile.RefreshProfileList();
			UI.PageServerLoadProfile.GUI.ProfileList.OnCommand = UI.PageServerLoadProfile.GUI.LoadProfile.OnCommand;
		end,	
	},
	
	OnRemoveYes = function()
		local sel=UI.PageServerLoadProfile.GUI.ProfileList:GetSelection(0);

		if sel then
			local ProfileName = UI.PageServerLoadProfile.GUI.ProfileList:GetItem(sel);
			local szFileName = "profiles/server/"..ProfileName.."_server.cfg";
					
			remove(szFileName);
			
			setglobal("g_serverprofile", "");
			
			UI.PageServerLoadProfile.RefreshProfileList();
		end
	end,
	
	RefreshProfileList = function()
		local ProfileTable = System:ScanDirectory("Profiles/server", SCANDIR_FILES);
		
		UI.PageServerLoadProfile.GUI.ProfileList:Clear();
		
		local iSelection = 0;

		for i, ProfileName in ProfileTable do
			local szPattern = "_server.cfg";
			local iPatternLen = strlen(szPattern);
			if (strsub(ProfileName, -iPatternLen) == szPattern) then
				local szProfileName = strsub(ProfileName, 1, strlen(ProfileName)-iPatternLen);
				
				local iID = UI.PageServerLoadProfile.GUI.ProfileList:AddItem(szProfileName);
				
				if (strlower(szProfileName) == strlower(getglobal("g_serverprofile"))) then
					iSelection = iID;
				end
			end
		end
		
		if (iSelection and iSelection > 0) then
			UI.PageServerLoadProfile.GUI.ProfileList:SelectIndex(iSelection);
		end
		
		UI.PageServerLoadProfile.GUI.ProfileList:OnChanged();
	end,	
}

AddUISideMenu(UI.PageServerLoadProfile.GUI,
{
	{ "MainMenu", Localize("MainMenu"), "$MainScreen$", 0},
	{ "Options", Localize("Options"), "Options", },
	{ "Back", Localize("Back"), "CreateServer", },
});

AddUISideMenu(UI.PageCreateServer.GUI,
{
	{ "MainMenu", Localize("MainMenu"), "$MainScreen$", 0},
	{ "Options", Localize("Options"), "Options", },
	{ "Back", Localize("Back"), "Multiplayer", },
});

UI:CreateScreenFromTable("ServerLoadProfile", UI.PageServerLoadProfile.GUI);
UI:CreateScreenFromTable("CreateServer", UI.PageCreateServer.GUI);
