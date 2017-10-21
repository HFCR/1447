--Script:LoadScript("SCRIPTS/Default/Entities/Weapons/WeaponsParams.lua");

WeaponClassesEx = {
	Hands = { 
		id			= 9,
		script	= "Weapons/Hands.lua",
		armorprice = 1008,
		Def_Sentry = {5200,1}, -- first number is price of ammo/grenade, second is amount per buy
		HandGrenade = {200,1},
		Assault = {180,100},
		Sniper = {350,10},
		SMG = {120,100},
		Pistol = {140,80},
		Caseless47 = {220,90},
		Minigun = {380,200},
		Shotgun = {130,10},
		Rocket = {190,1},
		OICWGrenade = {180,1},
		AG36Grenade = {160,1},
		RailStick = {370,10},
		HealthPack = {460,1},
		Bandage = {15,1},
	},

	Falcon = { 
		id			= 10,
		script	= "Weapons/Falcon.lua",
	},
	AG36 = { 
		id			= 11,
		script	= "Weapons/AG36.lua",
	},
	MP5 = { 
		id			= 12,
		script	= "Weapons/MP5.lua",
	},
	Machete = { 
		id			= 13,
		script	= "Weapons/Machete.lua",
	},
	Shotgun = { 
		id			= 14,
		script	= "Weapons/Shotgun.lua",
	},
	SniperRifle = { 
		id			= 15,
		script	= "Weapons/SniperRifle.lua",
	},
	OICW = { 
		id			= 16,
		script	= "Weapons/OICW.lua",
	},
	--NTW20 = { 
	--	id			= 101,
	--	script	= "Weapons/NTW20.lua",
	--},
	RL = { 
		id			= 18,
		script	= "Weapons/RL.lua",
	},
	P90 = { 
		id			= 19,
		script	= "Weapons/P90.lua",
	},
	M4 = { 
		id			= 20,
		script	= "Weapons/M4.lua",
	},
	Shocker = { 
		id			= 21,
		script	= "Weapons/Shocker.lua",
	},
	M249 = { 
		id			= 22,
		script	= "Weapons/M249.lua",
	},
	Mortar = { 
		id			= 23,
		script	= "Weapons/Mortar.lua",
	},
	COVERRL = { 
		id			= 24,
		script	= "Weapons/COVERRL.lua",
	},
	MG = { 
		id			= 25,
		script	= "Weapons/MG.lua",
	},
	MutantShotgun = { 
		id			= 26,
		script	= "Weapons/MutantShotgun.lua",
	},
	EngineerTool = { 
		id			= 27,
		script	= "Weapons/EngineerTool.lua",
	},
	MedicTool = { 
		id			= 28,
		script	= "Weapons/MedicTool.lua",
	},
	Wrench = { 
		id			= 29,
		script	= "Weapons/Wrench.lua",
	},
	ScoutTool = { 
		id			= 30,
		script	= "Weapons/ScoutTool.lua",
	},
	VehicleMountedMG = {
		id			= 31,
		script	= "Weapons/VehicleMountedMG.lua",
	},
	VehicleMountedRocketMG = {
		id			= 32,
		script	= "Weapons/VehicleMountedRocketMG.lua",
	},
	VehicleMountedRocket = {
		id			= 33,
		script	= "Weapons/VehicleMountedRocket.lua",
	},
	VehicleMountedAutoMG = {
		id			= 34,
		script	= "Weapons/VehicleMountedAutoMG.lua",
	},
	MutantMG = {
		id			= 35,
		script	= "Weapons/MutantMG.lua",
},
	Steyr = { 
		id			= 39,
		script	= "Weapons/Steyr.lua",
	},
	P99 = { 
		id			= 37,
		script	= "Weapons/P99.lua",
	},
	Sopmod = { 
		id			= 38,
		script	= "Weapons/Sopmod.lua",
	},
	M3 = { 
		id			= 41,
		script	= "Weapons/M3.lua",
	},
	Glock17 = { 
		id			= 42,
		script	= "Weapons/Glock17.lua",
	},
	KnifeDummy = {
		id = 43,
		script = "Weapons/KnifeDummy.lua",
	},
	A2000 = {
		id = 44,
		script = "Weapons/A2000.lua",
	},
	DUALMP7 = { 
		id			= 45,
		script	= "Weapons/DUALMP7.lua",
	},
	Vector = {
		id = 46,
		script = "Weapons/Vector.lua",
	},
	Salo = {
		id = 47,
		script = "Weapons/Salo.lua",
		food = 1,
	},
	Vodka = {
		id = 48,
		script = "Weapons/Vodka.lua",
		food = 1,
	},
	Yoghurt = {
		id = 49,
		script = "Weapons/Yoghurt.lua",
		food = 1,
	},
	M1911 = {
		id = 50,
		script = "Weapons/M1911.lua",
	},
	RPG7 = { 
		id			= 51,
		script	= "Weapons/RPG7.lua",
	},
	Meat = { 
		id			= 52,   
		script	= "Weapons/Meat.lua",
	},
	Colt = { 
		id			= 53,   
		script	= "Weapons/Colt.lua",
	},
	Katana = { 
		id			= 54,   
		script	= "Weapons/Katana.lua",
	},
	FAMAS = { 
		id			= 55,   
		script	= "Weapons/Famas.lua",
	},
	M79 = { 
		id			= 56,
		script	= "Weapons/M79.lua",
	},
	ShotgunDB = { 
		id			= 57,
		script	= "Weapons/ShotgunDB.lua",
	},
	ShotgunDBN = { 
		id			= 59,
		script	= "Weapons/ShotgunDBN.lua",
	},
	AK74 = {
		id			= 58,
		script	= "Weapons/AK74.lua",
	},
}


Projectiles={
	Rocket={
		model="objects/weapons/Rockets/rocket.cgf",
	},
	Grenade={
		model="objects/weapons/Rockets/rocket.cgf",
	},
	OICWGrenade={
		model="objects/weapons/Rockets/rocket.cgf",
	},
	SmokeGrenade={
		model="objects/weapons/Grenades/Grenade.cgf",
	},
	HandGrenade={
		model="objects/weapons/Grenades/Grenade.cgf",
	},
	FlareGrenade={
		model="objects/weapons/Grenades/Grenade.cgf",
	},
	FlashbangGrenade={
		model="objects/weapons/Grenades/Grenade.cgf",
	},
	GlowStick={
		model="objects/weapons/Grenades/Grenade.cgf",
	},
	PlasmaBall={
		model="Objects/weapons/bow/trail_bow_r.cgf",
	},
 	Rock={
		model="objects/natural/rocks/throwrock.cgf",
	},
 	MutantRocket={
		model="objects/natural/rocks/throwrock.cgf",
	},
	MortarShell={
		model="objects/weapons/Rockets/rocket.cgf",
	},
	AG36Grenade={
		model="objects/weapons/Rockets/rocket.cgf",
	},
	StickyExplosive={
		model="Objects/Pickups/explosive/explosive_nocount.cgf",  -- not used
	},
	VehicleRocket={
		model="objects/weapons/Rockets/rocket.cgf",
	},
	ThrowMachete={
		model="Objects/Weapons/machete/machete_bind.cgf",
	},

};

-- 
GrenadesClasses = {
	"Rock",
	"Bandage",
	"HandGrenade",
	"HandMga",
	"SmokeGrenade",
	"FlareGrenade",
	"FlashbangGrenade",
	"Def_Sentry",
	"GlowStick",
};


-- Names of weapons which are loaded, filled by AddAndSpawnWeapon()
WeaponsLoaded = { };


-- Equipment packs
MainPlayerEquipPack = nil;
if (EquipPacks == nil) then
	EquipPacks = { };
end