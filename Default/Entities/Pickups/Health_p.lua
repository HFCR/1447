Script:ReloadScript( "Scripts/Default/Entities/Pickups/PickupPhysCommon.lua" );
	local phys_item = new(BasicEntity);
	----
	phys_item.is_health = 1; -- it is health
	phys_item.Properties.Animation.fAmount = 50;
	phys_item.Properties.object_Model = "Objects/Pickups/health/cis_medkit_p.cgf";
	phys_item.Properties.Physics.damping = 0.04;
	phys_item.Properties.Physics.Mass = 34;
	phys_item.Properties.Physics.Type = "cola";
	phys_item.Properties.Physics.LowSpec.Mass = 34;
	phys_item.Properties.Physics.LowSpec.bRigidBody=1;
	phys_item.Properties.Physics.bRigidBody=1;
	phys_item.pp_sound = "sounds/items/generic_pickup.wav";
	phys_item.physpickup = 1; -- used in basicplayer to indicate it is pickup

Health_p = phys_item;

function Health_p:OnSave(stm)
	-- store ammo amounts of clips
	stm:WriteInt(self.Properties.Animation.fAmount);
end

function Health_p:OnLoad(stm)
	-- load ammo amounts of clips
	self.Properties.Animation.fAmount=stm:ReadInt();
end
