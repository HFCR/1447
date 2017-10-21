--
	       -- control options menu page
--

UI.PageWaitForKey=
{
	GUI=
	{
		darkeningpane=
		{
			classname="static",
			rect="0 0 800 600",
			color="0 0 0 128",
			zorder=50,
		},
		
		darkerpane=
		{
			classname = "static",
			left = 200, top = 140,
			width = 580, height = 259,
			color = "0 0 0 128",
			zorder = 55,
			
			
			halign=UIALIGN_CENTER, 
			fontsize = 18,
		},
		
		commandtext=
		{
			classname = "static",
			left = 200, top = 140,
			width = 580, height = 259,
			color = "0 0 0 128",
			zorder = 55,
			halign = UIALIGN_CENTER,
			text = Localize("PressAKeyToBind"),
					
			fontsize = 16,
		},

		--------

		OnActivate= function(Sender)
			UI.PageWaitForKey.GUI.commandtext:SetText(Localize("PressAKeyToBind").." "..UI.PageWaitForKey.Action.desc);
		end,
		
		OnUpdate= function(self)
			local PressedKey = Input:GetXKeyPressedName();
			if (PressedKey and (tostring(PressedKey) ~= "esc") and (tostring(PressedKey) ~= System:GetConsoleKeyName()) and (tostring(PressedKey) ~= "pause")) then
				if (UI.PageWaitForKey.Action.weird_id) then
					if (UI.PageWaitForKey.Action.weird_id == "SpecialOption") then
						-- special case for special key (see also control.lua and hudcommon.lua)
						UI:Ecfg("bin32/rc.ini","SpOptionKey",strupper(PressedKey));
						Game.cis_SpOptionKey = strlower(PressedKey);
						Game:AddCommand("cis_special","Hud:SwitchCisSpecial();","cis_special");
						Input:BindCommandToKey("\\cis_special",Game.cis_SpOptionKey,1);
						Input:BindCommandToKey("\\cis_special",strupper(Game.cis_SpOptionKey),1);
					elseif (UI.PageWaitForKey.Action.weird_id == "KnifeMash") then
						-- special case for special key (see also control.lua and hudcommon.lua)
						UI:Ecfg("bin32/rc.ini","KnifeMash",strupper(PressedKey));
						Game.cis_KnifeKey = strlower(PressedKey);
						Game:AddCommand("cl_knifemash","ClientStuff:KnifeMash();","cl_knifemash");
						Input:BindCommandToKey("\\cl_knifemash",Game.cis_KnifeKey,1);
						Input:BindCommandToKey("\\cl_knifemash",strupper(Game.cis_KnifeKey),1);
					end
				else
					Input:BindActionMultipleMaps(UI.PageWaitForKey.Action.name, PressedKey, UI.PageWaitForKey.iBindNumber);
				end
				UI.PageOptionsControl:FillBindList();
				UI:DeactivateScreen(self);
			end
		end,
	},

	------------
	
	Action=nil,				-- stores the Action {desc="", name=""}
}

--------
function UI.PageWaitForKey:SetLabel(Action, iNumber)
	self.Action=Action;
	self.iBindNumber = iNumber;
end

UI:CreateScreenFromTable("BindWaitForKey",UI.PageWaitForKey.GUI);

