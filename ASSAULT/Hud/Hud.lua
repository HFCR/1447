Script:LoadScript("scripts/Multiplayer/TeamHud.lua");

function Hud:OnInit()
	self:CommonInit();
	Language:LoadStringTable("MultiplayerHUD.xml");
	self.InTDMPROteamlogo=System:LoadImage("textures/hud/multiplayer/TDM_Logo");
end

function Hud:DrawCTFTeamText(x,y,text,color,fontsize)
%Game:SetHUDFont("default", "default");
local namesizex,namesizy = %Game:GetHudStringSize(text, fontsize, fontsize);
%Game:WriteHudString(x,y,text,color[1],color[2],color[3],1,fontsize,fontsize);
end
