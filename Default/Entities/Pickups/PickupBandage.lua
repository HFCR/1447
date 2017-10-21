Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self,collider)
	if (collider.items.bleed_range == nil) then
		local serverSlot = Server:GetServerSlotByEntityId(collider.id);
		if (MaxAmmo["Bandage"]) and (collider:GetAmmoAmount("Bandage") < MaxAmmo["Bandage"]) then
			collider:AddAmmo("Bandage", 1);
			if (serverSlot) then
				serverSlot:SendCommand("HUD P 10 1");
			end
			return 1;
		else
			if (serverSlot) then
				serverSlot:SendCommand("HUD P 10 -1");
			end
			return nil;
		end
	else
		collider.items.bleed_range = nil;
		local serverSlot = Server:GetServerSlotByEntityId(collider.id);
		if (serverSlot) then
			serverSlot:SendCommand("HUD W 8");
		end
		return 1;
	end
end

local params={
	func=funcPick,
	model="Objects/Pickups/Health/tourniquette.cgf",
	default_amount=1,
	sound="sounds/items/generic_pickup.wav",
	modelchoosable=nil,
	soundchoosable=nil,
	floating_icon="Objects/Pickups/binoculars/health_icon.cga",
}

PickupBandage=CreateCustomPickup(params);

PickupBandage._OnInit=PickupBandage.Client.OnInit;
function PickupBandage.Client:OnInit()
	self:_OnInit();
	self:SetViewDistRatio(255);
end


PickupBandage.PhysParam = {
	mass = 10,
	size = 0.15,
	heading = {x=0,y=0,z=-1},
	initial_velocity = 6,
	k_air_resistance = 0,
	acc_thrust = 0,
	acc_lift = 0,
	--high friction material
	surface_idx = Game:GetMaterialIDByName("mat_pickup"),
	gravity = {x=0, y=0, z=-9.8 },
	collider_to_ignore = nil,
	flags = bor(particle_constant_orientation,particle_no_path_alignment, particle_no_roll, particle_traceable),
}

function PickupBandage:Launch( weapon, shooter, pos, angles, dir, target )

	self:SetPhysicParams( PHYSICPARAM_PARTICLE, self.PhysParam );
	self.autodelete = 1;
	self.deleteOnGameReset = 1;
	self:EnableSave(1);
	self:GotoState("Dropped");
	-- fade away after 15 seconds

	local direction = g_Vectors.temp_v1;
	local dest = g_Vectors.temp_v2;
		
	CopyVector(direction,dir);
		
	dest.x = pos.x + direction.x * 1.5;
	dest.y = pos.y + direction.y * 1.5;
	dest.z = pos.z + direction.z * 1.5;
		
	local hits = System:RayWorldIntersection(pos,dest,1,ent_terrain+ent_static+ent_rigid+ent_sleeping_rigid,shooter.id);
		
	if (hits and getn(hits)>0) then
			
		local temp = hits[1].pos;
		
		dest.x = temp.x - direction.x * 0.15;
		dest.y = temp.y - direction.y * 0.15;
		dest.z = temp.z - direction.z * 0.15;
	end
	
	shooter:AwakeEnvironment();

	self:SetPos( dest );--pos );
	self:NetPresent(1);
end