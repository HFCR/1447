----
-- Far Cry User Interface System Configuration CIS

UI.szUbiCreateAccountURL = "https://secure.ubi.com/Login/US/NewUser.htm?skin_id=&nrcs_nexturl=http%3A%2F%2Fwww%2Eubi%2Ecom%2FUS%2F";
UI.szBannerCfgURL = "http://www.crytek.com/farcry/banner/banner.cfg";
UI.szBannerCfgPath = "scripts/banner.cfg";
UI.szSkinPath = "scripts/menuscreens/skin.lua";
UI.szMouseCursor = "textures/GUI/mousecursor";
UI.szMenuMusic = "Music/MenuMusic_shortvetsion.ogg";
UI.szCreditsMusic = "Music/Expedition.mp3";
UI.iSideMenuTop = 120;
UI.iSideMenuLeft = 30;
UI.iSideMenuSpacing = 0;
UI.szFocusColor = "255 255 153 255"; -- act. yellow
UI.szBorderColor = "255 255 120 200"; -- border blue
UI.szListViewOddColor = "113 142 121 255";
UI.szListViewEvenColor = "162 194 170 255";
UI.szSelectionColor = "162 194 170 168"; --
UI.szMessageBoxColor = "0 0 0 164"; -- 
UI.szMessageBoxScreenColor = "0 0 0 128"; --
UI.szTabAdditiveColor = "2 2 100 92"; ----------------------
UI.szLocalizedCutSceneFolder = "languages/movies/&language&/";
UI.szCutSceneFolder = "Mods/"..Game:GetCurrentModName().."/";
UI.fCanSkipTime = 0.45;

function UI:Ecfg(fname,key,value) -- Mixer: external configuration management
	local level_profile = openfile(fname,"r");
	System.cis_tmpt = {};
	local hasval = 0;
	if (level_profile) then
		local cfgline = "";
		while(cfgline) do
			cfgline = read(level_profile,"*l");
			if (cfgline) then
				tinsert(System.cis_tmpt,cfgline);
			end
		end
		closefile(level_profile);
		if (getn(System.cis_tmpt)>0) then
			local t_idx = 1;
			key = key..""; -- convert to string
			while(System.cis_tmpt[t_idx]) do
				local cfgpos = strfind(System.cis_tmpt[t_idx],"=");
				if (cfgpos) then
					local cfgline2 = strsub(System.cis_tmpt[t_idx],cfgpos+1);
					if (cfgline2) and (cfgline2~="") then
						local cfgline1 = strsub(System.cis_tmpt[t_idx],1,cfgpos-1);
						if (cfgline1) and (cfgline1 == key) then
							if (not value) then
								System.cis_tmpt = nil;
								return cfgline2;
							elseif (value~="") then
								hasval = 1;
								System.cis_tmpt[t_idx] = cfgline1.."="..value;
							end
						end
					end
				end
				t_idx = t_idx + 1;
			end
		end
	end
	if (value) and (value~="") then
		level_profile = openfile(fname,"w");
		if (level_profile) then
			if (getn(System.cis_tmpt) > 0) then
				for i,val in System.cis_tmpt do
					if (strfind(val,"=")~=nil) then
						write(level_profile,val.."\n");
					end
				end
				if (hasval ~= 1) then
					write(level_profile,key.."="..value.."\n");
				end
			else
				write(level_profile,key.."="..value.."\n");
			end
			closefile(level_profile);
		end
	end
	System.cis_tmpt = nil;
	return nil;
end
