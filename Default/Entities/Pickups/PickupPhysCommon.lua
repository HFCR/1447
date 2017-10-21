Script:ReloadScript( "Scripts/Default/Entities/Others/BasicEntity.lua" );

function BasicEntity:PhysPickTopPocketAndClips(guy, pick_type, ammo_type, add_amount, max_ammo, pick_id, wpns_count)
		local addvalue = add_amount * 1;
		local temp_amount = add_amount * 1;
		if (addvalue > 0) then
			local serverSlot = Server:GetServerSlotByEntityId(guy.id);
			if (pick_id == 1) then
			-- top up weapon clips:
				local weaponInfo = guy.WeaponState;
				weaponInfo = weaponInfo[WeaponClassesEx[pick_type].id];
				if (weaponInfo ~= nil) then
					local weaponTable = getglobal(weaponInfo.Name);
					local distributed = nil;
			
					-- now we find the fire mode of the weapon, which uses this ammo type
					for i, fireMode in weaponTable.FireParams do
						if (fireMode.AmmoType == ammo_type and fireMode.ai_mode==0 and not distributed) then
							local bpc = fireMode.bullets_per_clip - weaponInfo.AmmoInClip[i];
							local to_add = min(bpc, addvalue);
							addvalue = addvalue - to_add;
							weaponInfo.AmmoInClip[i] = weaponInfo.AmmoInClip[i] + to_add;
							distributed = 1;
							temp_amount = addvalue * 1;
							if (addvalue <= 0) and (serverSlot) then
								serverSlot:SendCommand("HUD A "..ammo_type.." "..to_add);
								return temp_amount;
							end
						end
					end
				end
			end -- pickid
		
			local c_ammo = guy:GetAmmoAmount(ammo_type);
			if (c_ammo >= max_ammo) or (addvalue <= 0) then return temp_amount; end

			if (c_ammo + addvalue > max_ammo) then
				addvalue = addvalue - ((c_ammo + addvalue) - max_ammo);
			end
			guy:AddAmmo(ammo_type,addvalue);
			temp_amount = temp_amount - addvalue;
			if (serverSlot) then
				serverSlot:SendCommand("HUD A "..ammo_type.." "..addvalue);
			end
		end
		return temp_amount;
end

function BasicEntity:PhysPickTouched(guy)
-----------------------------------------------------------
	if (not guy.ai) and (not guy.theVehicle) then
		if (guy.pp_lastdrop_p) then return end
		if (self.pp_lastdrop) and (self.pp_lastdrop > _time) then return end
		if (self.is_health) then
			if (guy.cnt.health < guy.cnt.max_health) and (self.Properties.Animation.fAmount > 0) then
				local actual_heal = floor((guy.cnt.max_health/100) * self.Properties.Animation.fAmount);
				if (guy.cnt.health + actual_heal > guy.cnt.max_health) then
					actual_heal = guy.cnt.max_health - guy.cnt.health;
				end
				guy.cnt.health = guy.cnt.health + actual_heal;
				actual_heal = floor(actual_heal/guy.cnt.max_health * 100);
				self:SetPos({x=0.01,y=0.01,z=0.01});
				BroadcastEvent(self, "Remove");
				local bandages = 0;
				if (Mission and Mission.alienworld) or (guy.items and guy.items.aliensuit) then
				elseif (toNumberOrZero(getglobal("gr_bleeding"))~=0) and (guy.Ammo["Bandage"]) then
					if (guy.items) and (guy.items.bleed_range) then
						bandages = 1;
					else
						bandages = 2;
					end
					local bamount = MaxAmmo["Bandage"] - guy:GetAmmoAmount("Bandage");
					if (bamount < bandages) then
						bandages = bamount;
					end
					if (bandages > 0) then
						guy:AddAmmo("Bandage", bandages);	
					end
				end
				if (guy.items) then
					guy.items.bleed_range = nil;
				end
				local serverSlot = Server:GetServerSlotByEntityId(guy.id);
				if (serverSlot) then
					if (bandages > 0) then
						serverSlot:SendCommand("HUD P 2 "..self.Properties.Animation.fAmount.." "..bandages);
					else
						serverSlot:SendCommand("HUD P 2 "..self.Properties.Animation.fAmount);
					end
				end
				self.Properties.Animation.fAmount = 0;
				-- play pickup sound
				if (self.pp_sound) then
					local ppsound = Sound:Load3DSound(self.pp_sound);
					if (ppsound) then
						Sound:SetSoundVolume(ppsound,242);
						local pppos = guy:GetPos();
						pppos.z = pppos.z + 0.8;
						Sound:SetSoundPosition(ppsound,pppos);
						Sound:PlaySound(ppsound,1);
					end
				end
				Server:RemoveEntity(self.id,1);
				self = nil;
			end
			return
		end
	local pick_id = 0;
	local serverSlot = {};
	local pick_type = strfind(self.Properties.Animation.Animation,"weapon_");
	if (pick_type) then
		pick_type = strsub(self.Properties.Animation.Animation,pick_type+7);
		if (WeaponClassesEx[pick_type]) then
			local has_this_gun;
			local has_hands;
			local wpns_count=0;
			local wsl = guy.cnt:GetWeaponsSlots();
			if (not wsl) then return end;
			for i,val in wsl do 
				if(val~=0) then 
				wpns_count=wpns_count+1;
					if (val.name==pick_type) then has_this_gun=val; break; end
					if (val.name=="Hands") then has_hands = 1; wpns_count=wpns_count-1;
					elseif (val.name=="EngineerTool") then has_hands = 2; wpns_count=wpns_count-1; end
				end
			end
			
			-- take weapon first
			if (wpns_count < 4) and (has_this_gun == nil) then
			
				-- get rid of hands/engineer tool
				if (has_hands) then
					if (wpns_count==3) then
						if (guy.cnt.weapon) and (guy.cnt.weapon.name=="Hands") then
							guy.cnt:SetCurrWeapon();
							--guy.do_pp_choose = 1;
						elseif (guy.cnt.weapon) and (guy.cnt.weapon.name=="EngineerTool") then
							guy.cnt:SetCurrWeapon();
							--guy.do_pp_choose = 1;
						end
						guy.cnt:MakeWeaponAvailable(9,0);
						guy.cnt:MakeWeaponAvailable(27,0);
					elseif (wpns_count<3) and (guy.cnt.weapon) and (guy.cnt.weapon.name=="Hands") then
							guy.cnt:SetCurrWeapon();
					end
				end

				guy.cnt:MakeWeaponAvailable(WeaponClassesEx[pick_type].id);
				self:SetPos({x=0.01,y=0.01,z=0.01});
				BroadcastEvent(self, "Remove");
				pick_id = 1;
				serverSlot = Server:GetServerSlotByEntityId(guy.id);
				if (serverSlot) then
					serverSlot:SendCommand("HUD W "..WeaponClassesEx[pick_type].id);
				end
				
			end
			
			-- add weapon clips content, take needed amount from clips to pockets
			local ammo_type = 0;
			local max_ammo = 0;
			local sum_ammo = self.Properties.Animation.fAmmo_Primary + self.Properties.Animation.fAmmo_Secondary;
			
			-- 1. primary ammo
			ammo_type = self.Properties.Animation.sAmmotype_Primary;
			max_ammo = MaxAmmo[ammo_type];
			if (max_ammo) then
				self.Properties.Animation.fAmmo_Primary = self:PhysPickTopPocketAndClips(guy, pick_type, ammo_type, self.Properties.Animation.fAmmo_Primary, max_ammo, pick_id, wpns_count);
			end
			
			-- 2. secondary ammo
			ammo_type = self.Properties.Animation.sAmmotype_Secondary;
			max_ammo = MaxAmmo[ammo_type];
			if (max_ammo) then
				self.Properties.Animation.fAmmo_Secondary = self:PhysPickTopPocketAndClips(guy, pick_type, ammo_type, self.Properties.Animation.fAmmo_Secondary, max_ammo, pick_id, wpns_count);
			end
			
			-- check if something is picked from this item:
			if (self.Properties.Animation.fAmmo_Primary + self.Properties.Animation.fAmmo_Secondary ~= sum_ammo) and (pick_id ~= 1) then
				pick_id = 2;
			end
			
			-- play pickup sound
			if (pick_id > 0) and (self.pp_sound) then
				local ppsound = Sound:Load3DSound(self.pp_sound);
				if (ppsound) then
					if (pick_id == 1) and (guy.cnt.weapon == nil) then
					else
						Sound:SetSoundVolume(ppsound,239);
						local pppos = guy:GetPos();
						pppos.z = pppos.z + 0.6;
						Sound:SetSoundPosition(ppsound,pppos);
						Sound:PlaySound(ppsound,1);
					end
				end
			end
			
			-- remove weapon pickup if picked
			if (pick_id == 1) then
				if (guy.cnt.weapon == nil) then
					guy.cnt:SetCurrWeapon(WeaponClassesEx[pick_type].id);
				end
				Server:RemoveEntity(self.id);
			end

		else
			Hud:AddMessage("$2WEAPON: "..pick_type.." IS NOT PRESENT IN WEAPONS CLASSES!");
		end
	end
	end
-----------------------------------------------------------------------
end