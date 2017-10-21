Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self,collider)
	local bamount = MaxAmmo["Vodka"] - collider:GetAmmoAmount("Vodka");
	if bamount > 0 then
		if bamount > self.Properties.Amount then
			bamount = self.Properties.Amount*1;
		end
		local serverSlot = Server:GetServerSlotByEntityId(collider.id);
		collider:AddAmmo("Vodka", bamount);
		collider.cnt:MakeWeaponAvailable(WeaponClassesEx["Vodka"].id);
		if (collider.cnt.weapon) and (collider.cnt.weapon.name~="Hands") then
		else
			collider.cnt:SetCurrWeapon(WeaponClassesEx["Vodka"].id);
		end
		if (serverSlot) then
			serverSlot:SendCommand("HUD A Salo "..bamount);
		end
		return 1;
	end
end

local params={
	func=funcPick,
	model="Objects/weapons/salo/vodka_pickup.cgf",
	default_amount=1,
	sound="Sounds/items/health.wav",
	modelchoosable=nil,
	soundchoosable=nil,
}

PickupSalo=CreateCustomPickup(params);
