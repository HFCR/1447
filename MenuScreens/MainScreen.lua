-- cis main scren modified by mixer 2.0
UI.PageMainScreen =
{	
	GUI=
	{
	OnUpdate = function(self)
		if ((self.fActivateTime) and (System:GetCurrAsyncTime() - self.fActivateTime > 0.125)) then
			self.fActivateTime = nil;
			UI:EnableSwitch(1);
		end
		---
		end
	},
	
	SetMyPassport = function()
			local pname = getglobal("p_name").."";
			if (pname) then
				local pcfgname = UI:Ecfg("bin32/rc.ini","name");
				if (pcfgname) then
					if (pname == "$3Thomas $1") then
						setglobal("p_name",pcfgname);
					elseif (pcfgname ~= pname) then
						UI:Ecfg("bin32/rc.ini","name",pname);
					end
				else
					UI:Ecfg("bin32/rc.ini","name",pname);
				end
			end
			pname = getglobal("mp_model").."";
			if (pname) then
				local pcfgname = UI:Ecfg("bin32/rc.ini","look");
				if (pcfgname) then
					if (pname == "objects/characters/pmodels/hero/hero_mp.cgf") then
						setglobal("mp_model",pcfgname);
					elseif (pcfgname ~= pname) then
						UI:Ecfg("bin32/rc.ini","look",pname);
					end
				else
					UI:Ecfg("bin32/rc.ini","look",pname);
				end
			end
			pname = getglobal("p_color").."";
			if (pname) then
				local pcfgname = UI:Ecfg("bin32/rc.ini","look2");
				if (pcfgname) then
					if (pname == "4") then
						setglobal("p_color",pcfgname);
					elseif (pcfgname ~= pname) then
						UI:Ecfg("bin32/rc.ini","look2",pname);
					end
				else
					UI:Ecfg("bin32/rc.ini","look2",pname);
				end
			end
	end,

	ShowConfirmation = function()
		UI.PageMainScreen.SetMyPassport();
		Game:SendMessage("Quit-Yes");
	end,
	
	OnActivate = function(self)
		self.fActivateTime = System:GetCurrAsyncTime();
		UI.PageMainScreen.SetMyPassport();
	end,
}

AddUISideMenu(UI.PageMainScreen.GUI,
{
{ "-", "-", "-", },
{ "-", "-", "-", },
{ "Campaign", Localize("Campaign"), "Campaign", },
{ "Multiplayer", Localize("Multiplayer"), "Multiplayer", }, --demooff
{ "Options", Localize("Options"), "Options", },
{ "Profiles", Localize("Profiles"), "Profiles", },
{ "Mods", Localize("Mods"), "Mods", },
{ "Credits", Localize("Credits"), "Credits", 0},	
{ "Quit", Localize("Quit"), UI.PageMainScreen.ShowConfirmation, },
});

UI:CreateScreenFromTable("MainScreen", UI.PageMainScreen.GUI);

----
UI.PageMainScreenInGame =
{
	GUI=
	{
		OnActivate = function(self)
			self.fActivateTime = System:GetCurrAsyncTime();
		end,

		OnUpdate = function(self)
			if ((self.fActivateTime) and (System:GetCurrAsyncTime() - self.fActivateTime > 0.125)) then
				self.fActivateTime = nil;
				UI:EnableSwitch(1);
			end
		end
	},
	
	QuitYes = function()
	Game:SendMessage("Quit-Yes");
	end,

	ShowConfirmation = function()
	UI.YesNoBox(Localize("Quit"), Localize("QuitConfirmation"), UI.PageMainScreen.QuitYes);
	end,
}

AddUISideMenu(UI.PageMainScreenInGame.GUI,
{
{ "-", "-", "-", },
{ "Return", Localize("ReturnToGame"), "$Return$", },
{ "-", "-", "-", },	-- separator
{ "Campaign", Localize("Campaign"), "Campaign", },
{ "Multiplayer", Localize("Multiplayer"), "Multiplayer", },
{ "Options", Localize("Options"), "Options", },
{ "Profiles", Localize("Profiles"), "Profiles", },
{ "Mods", Localize("Mods"), "Mods", },
{ "Credits", Localize("Credits"), "Credits", 0},
{ "Quit", Localize("Quit"), UI.PageMainScreen.ShowConfirmation, },
});

UI:CreateScreenFromTable("MainScreenInGame", UI.PageMainScreenInGame.GUI);