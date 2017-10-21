Script:LoadScript("SCRIPTS/GUI/ScoreBoardLib.lua");
function ScoreBoardManager:Render()
self:RenderDMGame();
	-- Mixer: 2.8 update: show GOALS
	if (ScoreBoardManager.visible==1) or (Hud.su_briefing_def) then
		if (Mission) and (Mission.su_briefing) then
			Game:WriteHudString( 58, -10, "\n "..Mission.su_briefing, 1, 1, 1, 1, 20, 20);
		elseif (Game:GetTagPoint("ESCORT_HERE")~=nil) then
			Game:WriteHudString( 58, -10, "\n @su_brief_esc", 1, 1, 1, 1, 20, 20);
		else
			Game:WriteHudString( 58, -10, "\n @su_brief_def", 1, 1, 1, 1, 20, 20);
		end
	end
end