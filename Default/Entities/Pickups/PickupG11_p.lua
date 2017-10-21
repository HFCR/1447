Script:ReloadScript( "Scripts/Default/Entities/Pickups/PickupPhysCommon.lua" );
	local phys_item = new(BasicEntity);
	----
	---- EDIT HERE: weapon_name   examples: weapon_P90 weapon_M4 etc...
	phys_item.Properties.Animation.Animation = "weapon_G11";
	phys_item.Properties.Animation.fAmmo_Primary = 45;
	phys_item.Properties.Animation.sAmmotype_Primary="Caseless47";
	phys_item.Properties.Animation.fAmmo_Secondary = 0;
	phys_item.Properties.Animation.sAmmotype_Secondary="";
	phys_item.pp_sound = "Sounds/Weapons/M4/m4weapact.wav";
	----
	----
	phys_item.Properties.object_Model = "Objects/weapons/hk_g11/hkg11_bind.cgf";
	phys_item.Properties.Physics.damping = 0.02;
	phys_item.Properties.Physics.Mass = 27;
	phys_item.Properties.Physics.Type = "machete";
	phys_item.Properties.Physics.bRigidBody=1;
	phys_item.Properties.Physics.LowSpec.bRigidBody=1;
	phys_item.Properties.Physics.LowSpec.Mass = 27;
	phys_item.physpickup = 1; -- used in basicplayer to indicate it is pickup
PickupG11_p = phys_item;

function PickupG11_p:OnSave(stm)
	-- store ammo amounts of clips
	stm:WriteInt(self.Properties.Animation.fAmmo_Primary);
end

function PickupG11_p:OnLoad(stm)
	-- load ammo amounts of clips
	self.Properties.Animation.fAmmo_Primary=stm:ReadInt();
end
