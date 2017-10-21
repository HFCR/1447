-- Console interaction trigger. v2.1 +CLIENT/SERVER BUY alpha
-- by Mixer (combination with cis's HUDcommon.lua).
-- Bundle text/answers/actions are taking from mission scripts
-- array "Mission.NPCtexts.yournpctextbundle"

NpcDialogText = {
	type = "Trigger",

	Properties = {
		DimX = 1,
		DimY = 1,
		DimZ = 1,
		bEnabled=1,
		nStateID=1,
		nZAngle=0,
		sTextBundle="insert text",
	},
	
	Editor={
	Model="Objects/Editor/T.cgf",
	},
}

function NpcDialogText:OnPropertyChange()
	self:OnReset();
end

function NpcDialogText:OnInit()
	self.compsnd = Sound:LoadSound("sounds/menu/click.wav");
	self:EnableUpdate(0);
	self:SetUpdateType( eUT_Physics );
	self:TrackColliders(1);
	self.Who = nil;
	self.Entered = 0;
	self:RegisterState("Inactive");
	self:RegisterState("Empty");
	self:RegisterState("OccupiedUse");
	self:OnReset();
end

function NpcDialogText:OnShutDown()
end

function NpcDialogText:OnSave(stm)
	stm:WriteInt(self.idstatus);
end


function NpcDialogText:OnLoad(stm)
	self.idstatus = stm:ReadInt();
end

function NpcDialogText:OnLoadRELEASE(stm)
	self.idstatus = stm:ReadInt();
end


function NpcDialogText:OnReset()
	local Min = { x=-self.Properties.DimX/2, y=-self.Properties.DimY/2, z=-self.Properties.DimZ/2 };
	local Max = { x=self.Properties.DimX/2, y=self.Properties.DimY/2, z=self.Properties.DimZ/2 };
	self.idstatus = self.Properties.nStateID;
	self:SetBBox( Min, Max );
	self.Who = nil;
	self.Entered = 0;
	if (self.Properties.bEnabled==1) then
		self:GotoState( "Empty" );
	else
		self:GotoState( "Inactive" );
	end
end

function NpcDialogText:AddBuyServerStuff()
	if (not GameRules.ClientCommandTable) then
		GameRules.ClientCommandTable = {};
	end
	if (GameRules.ClientCommandTable["BUY"]==nil) then
	---
	GameRules.ClientCommandTable["BUY"]=function(String,server_slot,toktable)
		if (count(toktable) > 3) then
			server_slot:SendText("$1YOUR VERSION OF MOD MISMATCHES SERVER VERSION, PLEASE UPDATE!");
			return;
		end
		local customer = System:GetEntity(server_slot:GetPlayerId());
		if (customer) then
		--- ANTI-CHEAT PROTECTION
		if (GameRules.SurvivalManager) then
			-- LET'S measure distance between traders and customer, and item availability of serverside item table for trader
			local max_dist = 999;
			local g_ents = System:GetEntities();
			local customerpos = customer:GetPos();
			for i,entity in g_ents do
				if (entity.isvillager) and (entity.istrader) then
					if (entity.cnt) and (entity.cnt.health > 0) then
						local ent_dist = entity:GetDistanceFromPoint(customerpos);
						if (ent_dist < max_dist) then
							local entname = entity:GetName();
							if (Mission) and (Mission[entname]) then
								local itm_id = 1;
								while Mission[entname][itm_id] do
									if (Mission[entname][itm_id][2] == toktable[2]) then
										max_dist = ent_dist;
										break;
									end
									itm_id = itm_id + 1;
								end
							end
						end
					end
				end
			end
			if (max_dist > 3) then
				return;
			end
		end
		--- ANTI-CHEAT PROTECTION
		local customertest = customer.cnt.score * 1;
		if (WeaponClassesEx[toktable[2]]) then
			local wsl = customer.cnt:GetWeaponsSlots();
			if (wsl) then
				local has_this_gun;
				local wpns_count=0;
				local has_hands;
				for i,val in wsl do 
					if(val~=0) then 
						wpns_count=wpns_count+1;
						if (val.name==toktable[2]) then
							has_this_gun=1;
							return;
						end
						if (val.name=="Hands") or (val.name=="EngineerTool") then
							wpns_count=wpns_count-1;
							if (val.name=="Hands") then
								has_hands=9;
							else
								has_hands=27;
							end
						end
						
					end
				end
				local wcost = WeaponClassesEx[toktable[2]].price;
				local countcost = customer.cnt.score * 12 - wcost;
				if countcost < 0 and (wpns_count < 4) then
				elseif (wpns_count < 4) then
					customer.cnt.score = floor(countcost/12);
					if (wpns_count == 3) and (has_hands) then
						customer.cnt:MakeWeaponAvailable(has_hands,0);
						if (has_hands==27) then
							customer.items.wrenchtool = 1;
						end
					end
					customer.cnt:MakeWeaponAvailable(WeaponClassesEx[toktable[2]].id);
					local wclass = Game:GetWeaponClassIDByName(toktable[2]);
					local psl = Server:GetServerSlotByEntityId(customer.id);
					if (wclass) and (psl) then
						psl:SendCommand("HUD W "..wclass);
					end
				end
			end
		elseif (toktable[2]=="Armor") then
			local countcost = customer.cnt.score * 12 - WeaponClassesEx.Hands.armorprice;
			if (countcost < 0) then
			elseif (customer.cnt.armor < customer.cnt.max_armor) then
				customer.cnt.score = floor(countcost/12);
				customer.cnt.armor = customer.cnt.max_armor;
			end
		elseif (MaxAmmo[toktable[2]]) and (WeaponClassesEx.Hands[toktable[2]]) then
			local countcost = customer.cnt.score * 12 - WeaponClassesEx.Hands[toktable[2]][1];
			if (countcost < 0) then
			elseif (customer:GetAmmoAmount(toktable[2])<MaxAmmo[toktable[2]]) then
				customer.cnt.score = floor(countcost/12);
				customer:AddAmmo(toktable[2],WeaponClassesEx.Hands[toktable[2]][2]);
				if (customer:GetAmmoAmount(toktable[2])>MaxAmmo[toktable[2]]) then
					customer.Ammo[toktable[2]] = MaxAmmo[toktable[2]] * 1;
				end
			end
		end
		if (GameRules.SurvivalManager) and (customertest > customer.cnt.score) then
			Server:BroadcastCommand("SUBY "..customer.id);
		end
		if (GameRules.ScoreboardUpd) then
			GameRules:ScoreboardUpd();
		end
		-- prev weapon return
		if (toktable[3]) then
			customer.cnt:SetCurrWeapon(tonumber(toktable[3]));
		end
		end -- if customer
	end -- buy func
	----

	end -- if has buy
end

function NpcDialogText:Event_Enter( sender )
	if (self:GetState( ) == "Inactive") then return end
	BroadcastEvent( self,"Enter" );
end

function NpcDialogText:Event_Leave( sender )
	if (self:GetState( ) == "Inactive") then return end
	BroadcastEvent( self,"Leave" );
end

function NpcDialogText:Event_Enable( sender )
	self:GotoState("Empty")
	BroadcastEvent( self,"Enable" );
end

function NpcDialogText:Event_Disable( sender )
	self:GotoState( "Inactive" );
	BroadcastEvent( self,"Disable" );
end

-- pair of functions for easy calling of various events
function NpcDialogText:Event_DoSomething1( sender )
	BroadcastEvent( self,"DoSomething1" );
end
function NpcDialogText:Event_DoSomething2( sender )
	BroadcastEvent( self,"DoSomething2" );
end

-- Check if source entity is valid for triggering.
function NpcDialogText:IsValidSource( entity )
	-- Ignore if not player.
	if (entity ~= _localplayer) then
		return 0;
	end

	if (entity.theVehicle) then
		return 0;
	end

	if (entity.cnt.health <= 0) then 
		return 0;
	end

	return 1;
end

-- Inactive State ---

NpcDialogText.Inactive =
{
	OnBeginState = function( self )
	end,
	OnEndState = function( self )
	end,
}
-- Empty State ----------------------------------------------------------------
NpcDialogText.Empty =
{
	-------------------------------------------------------------------------------
	OnBeginState = function( self )
		self.Who = nil;
		self.Entered = 0;
	end,

	-------------------------------------------------------------------------------
	OnEnterArea = function( self,entity,areaId )
		if (Mission) and (Mission.NPCtexts) and (Mission.NPCtexts[self.Properties.sTextBundle]) then
		else
			self:AddBuyServerStuff();
		end
		if (self:IsValidSource(entity) == 0) then
			return
		end
		self.Who = entity;
		self:GotoState( "OccupiedUse" );
		self:Event_Enter();
	end,


}

-- OccupiedText State ----------

NpcDialogText.OccupiedUse =
{
	---------
	OnBeginState = function( self )
		if (not Mission) then Mission = {}; end
		self:EnableUpdate(1);
		Mission.thisdialog = self; -- store it here for easier outer callback
		if (Mission.NPCtexts) and (Mission.NPCtexts[self.Properties.sTextBundle]) then
		else
		self:AddBuyServerStuff();
self.i_am_a_buyzone={
	{
	npctext = "nil",
	answers = "nil",
	o1 = "Mission.thisdialog.idstatus = 2",
	o2 = "Mission.thisdialog.idstatus = 3",
	o3 = "Mission.thisdialog.idstatus = 4",
	o4 = "Mission.thisdialog.idstatus = 5",
	o5 = "Mission.thisdialog.idstatus = 6",
},
{
	npctext = "Pistol",
	answers = "1. @Falcon \n2. @Machete \n3. @Shocker \n0. @buy_back",
	o1 = "Client:SendCommand('BUY Falcon')",
	o2 = "Client:SendCommand('BUY Machete')",
	o3 = "Client:SendCommand('BUY Shocker')",
	o0 = "Mission.thisdialog.idstatus = 1",
},
{
	npctext = "Shotgun",
	answers = "1. @Shotgun \n0. @buy_back",
	o1 = "Client:SendCommand('BUY Shotgun')",
	o0 = "Mission.thisdialog.idstatus = 1",
},
{
	npctext = "SMG",
	answers = "1. @MP5 \n2. @P90 \n0. @buy_back",
	o1 = "Client:SendCommand('BUY MP5')",
	o2 = "Client:SendCommand('BUY P90')",
	o0 = "Mission.thisdialog.idstatus = 1",
},
{
	npctext = "Assault",
	answers = "1. @M4 \n2. @G11 \n3. @AG36 \n4. @OICW \n5. @SniperRifle \n0. @buy_back",
	o1 = "Client:SendCommand('BUY M4')",
	o2 = "Client:SendCommand('BUY G11')",
	o3 = "Client:SendCommand('BUY AG36')",
	o4 = "Client:SendCommand('BUY OICW')",
	o5 = "Client:SendCommand('BUY SniperRifle')",
	o0 = "Mission.thisdialog.idstatus = 1",
},
{
	npctext = "buy_heavy",
	answers = "1. @M249 \n2. @RL \n0. @buy_back",
	o1 = "Client:SendCommand('BUY M249')",
	o2 = "Client:SendCommand('BUY RL')",
	o0 = "Mission.thisdialog.idstatus = 1",
},
};
			if (Mission.NPCtexts==nil) then Mission.NPCtexts={}; end
			Mission.NPCtexts[self.Properties.sTextBundle]=self.i_am_a_buyzone;
		end
	end,
	---------
	OnEndState = function( self )
		self:EnableUpdate(0);
		local npccache = Mission.NPCtexts[self.Properties.sTextBundle][self.idstatus];
		if (npccache["exit"]) then
			dostring(npccache["exit"]);
		end
		self:Event_Leave();
		Mission.thisdialog = nil;
	end,
	---------
	OnUpdate = function( self )
	-- PLACE IT HERE!!!
	if (_localplayer) and (_localplayer.cnt) and (_localplayer.cnt.health > 0) then
		local viewerangles = _localplayer:GetAngles();
		-- check player angles to limit angle to display
		if (self.Properties.nZAngle ~= 0) then
			if (viewerangles.z > self.Properties.nZAngle + 25) or (viewerangles.z < self.Properties.nZAngle - 25) then
				return
			end
		end
		Hud.npcdialogdata = {};
		if (self.i_am_a_buyzone) then
		Hud.npcdialogdata.npcname = "buy_menu";
		else
		Hud.npcdialogdata.npcname = self:GetName();
		end
		local npccache = Mission.NPCtexts[self.Properties.sTextBundle][self.idstatus];
		Hud.npcdialogdata.npctext = npccache.npctext;
		if (npccache.answers) then
			Hud.npcdialogdata.answers = npccache.answers;
		end
		Hud.npcdialogtimer = _time;
		local PressedKey = Input:GetXKeyPressedName();
		if (PressedKey) then
			local np_token = strfind(PressedKey,"numpad");
			if (np_token) then
				PressedKey = strsub(PressedKey,7);
			end
			local option = "o"..PressedKey;
			if (npccache[option]) then
				dostring(npccache[option]);
				if (self.compsnd) then
					Sound:PlaySound(self.compsnd);
				end
			end
		end
	else
		self:GotoState( "Empty" );
	end
	end,
	-----
	OnLeaveArea = function( self,entity,areaId )
		if (self.Who == entity) then
			self:GotoState( "Empty" );
		end
	end,
}