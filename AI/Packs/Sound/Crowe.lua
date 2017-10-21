-- FLASH VOICEPACK BY MIXER 2007 STARRING K. STARKHOV
SOUNDPACK.Crowe = {

	SPECIAL_GOT_TO_WAYPOINT = {
	-- Nag to player when leading him
	{
	PROBABILITY = 250,
	soundFile = "sounds/ai/npc_flash/fl_lead_nag1.mp3",
	-- Move, move!
	Volume = 255,
	min = 7,
	max = 150,
	sound_unscalable = 0,
	},
	{
	PROBABILITY = 250,
	soundFile = "sounds/ai/npc_flash/fl_lead_nag2.mp3",
	-- Hurry up!
	Volume = 255,
	min = 7,
	max = 150,
	sound_unscalable = 0,
	},
	},

	IDLE_TO_THREATENED = {
	-- Flash was threatened
	{
	PROBABILITY = 140,
	soundFile = "sounds/ai/npc_flash/fl_threaten1.mp3",
	Volume = 255,
	min = 7,
	max = 150,
	sound_unscalable = 0,
	},
	},
	DESTROY_HIM = {
	-- Original Crowe improvement
	{
	PROBABILITY = 80,
	soundFile = "languages/missiontalk/ruins/templeruins_specific_D_1.wav",
	Volume = 255,
	min = 7,
	max = 150,
	sound_unscalable = 0,
	},
	{
	PROBABILITY = 80,
	soundFile = "languages/missiontalk/ruins/templeruins_specific_D_2.wav",
	Volume = 255,
	min = 7,
	max = 150,
	sound_unscalable = 0,
	},
	{
	PROBABILITY = 80,
	soundFile = "languages/missiontalk/ruins/templeruins_specific_D_3.wav",
	Volume = 255,
	min = 7,
	max = 150,
	sound_unscalable = 0,
	},
	{
	PROBABILITY = 80,
	soundFile = "languages/missiontalk/ruins/templeruins_specific_D_4.wav",
	Volume = 255,
	min = 7,
	max = 150,
	sound_unscalable = 0,
	},
	{
	PROBABILITY = 80,
	soundFile = "languages/missiontalk/ruins/templeruins_specific_D_5.wav",
	Volume = 255,
	min = 7,
	max = 150,
	sound_unscalable = 0,
	},
	{
	PROBABILITY = 80,
	soundFile = "languages/missiontalk/ruins/templeruins_specific_D_6.wav",
	Volume = 255,
	min = 7,
	max = 150,
	sound_unscalable = 0,
	},
	{
	PROBABILITY = 80,
	soundFile = "languages/missiontalk/ruins/templeruins_specific_D_7.wav",
	Volume = 255,
	min = 7,
	max = 150,
	sound_unscalable = 0,
	},
	{
	PROBABILITY = 80,
	soundFile = "languages/missiontalk/ruins/templeruins_specific_D_8.wav",
	Volume = 255,
	min = 7,
	max = 150,
	sound_unscalable = 0,
	},
	},
	HURT_INSULT = {
	-- Original Crowe improvement
	{
	PROBABILITY = 400,
	soundFile = "languages/missiontalk/ruins/templeruins_specific_D_9.wav",
	Volume = 255,
	min = 7,
	max = 150,
	sound_unscalable = 0,
	},
	{
	PROBABILITY = 400,
	soundFile = "languages/missiontalk/ruins/templeruins_specific_D_10.wav",
	Volume = 222,
	min = 7,
	max = 150,
	sound_unscalable = 0,
	},
	},
}