Script:ReloadScript( "Scripts/Default/Entities/Pickups/PickupPhysCommon.lua" );
	local phys_item = new(BasicEntity);
	----
	---- EDIT HERE: weapon_name   examples: weapon_P90 weapon_M4 etc...
	phys_item.Properties.Animation.Animation = "weapon_Falcon";
	phys_item.Properties.Animation.fAmmo_Primary = 8;
	phys_item.Properties.Animation.sAmmotype_Primary="Pistol";
	phys_item.Properties.Animation.fAmmo_Secondary = 0;
	phys_item.Properties.Animation.sAmmotype_Secondary="";
	phys_item.pp_sound = "sounds/weapons/DE/deweapact.wav";
	----
	----
	phys_item.Properties.object_Model = "Objects/Weapons/de/de_bind.cgf";
	phys_item.Properties.Physics.damping = 0.01;
	phys_item.Properties.Physics.Mass = 17;
	phys_item.Properties.Physics.Type = "smisc";
	phys_item.Properties.Physics.bRigidBody=1;
	phys_item.Properties.Physics.LowSpec.bRigidBody=1;
	phys_item.Properties.Physics.LowSpec.Mass = 17;
	phys_item.physpickup = 1; -- used in basicplayer to indicate it is pickup

PickupFalcon_p = phys_item;

function PickupFalcon_p:OnSave(stm)
	-- store ammo amounts of clips
	stm:WriteInt(self.Properties.Animation.fAmmo_Primary);
end

function PickupFalcon_p:OnLoad(stm)
	-- load ammo amounts of clips
	self.Properties.Animation.fAmmo_Primary=stm:ReadInt();
end
