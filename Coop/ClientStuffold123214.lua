Script:LoadScript("scripts/FFA/ClientStuff.lua");

ClientStuff.cl_survival = 2;
function ClientStuff:ModeDesc()
	return "COOP";
end

function ClientStuff:OnSpawnEntity(entity)
	entity:EnableUpdate(1);
	if (entity.type == "Player") then
		entity:SetViewDistRatio(255);
		entity:RenderShadow(1);
		Hud:ResetRadar(entity);
		if (entity.ai) then
			local clsname = strsub(entity.classname,1,4);
			if (clsname == "Grun") or (clsname == "Merc") then
				if (not Game:IsServer()) or (entity.classname == "MercRear") then -- Mixer: because mercrear.lua is tweaked to CIS alien demolisher by default
					entity.deathSounds = {
						{"LANGUAGES/voicepacks/voiceA/death_1_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_2_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_3_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_4_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_5_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_6_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_7_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_8_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_9_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_10_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_11_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_12_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_13_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_14_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_15_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_16_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_17_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_18_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_19_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/death_20_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_1_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_2_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_3_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_4_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_5_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_6_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_7_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_8_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_9_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_10_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_11_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_12_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_13_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_14_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_15_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_16_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_17_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_18_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_19_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/death_20_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_1_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_2_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_3_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_4_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_5_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_6_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_7_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_8_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_9_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_10_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_11_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_12_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_13_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_14_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_15_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_16_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_17_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_18_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_19_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/death_20_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_1_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_2_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_3_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_4_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_5_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_6_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_7_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_8_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_9_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_10_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_11_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_12_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_13_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_14_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_15_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_16_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_17_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_18_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_19_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/death_20_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
					};
					entity.painSounds = {
						{"LANGUAGES/voicepacks/voiceA/pain_1_VoiceA.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/pain_3_VoiceA.wav.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/pain_4_VoiceA.wav.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/pain_5_VoiceA.wav.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/pain_6_VoiceA.wav.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/pain_7_VoiceA.wav.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/pain_8_VoiceA.wav.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/pain_9_VoiceA.wav.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/pain_10_VoiceA.wav.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/pain_11_VoiceA.wav.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/pain_12_VoiceA.wav.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/pain_13_VoiceA.wav.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/pain_14_VoiceA.wav.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceA/pain_15_VoiceA.wav.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/pain_1_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/pain_2_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/pain_3_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/pain_4_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/pain_5_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/pain_6_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/pain_7_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/pain_8_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/pain_9_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/pain_10_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/pain_11_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/pain_12_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/pain_13_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/pain_14_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceB/pain_15_VoiceB.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/pain_1_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/pain_2_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/pain_3_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/pain_4_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/pain_5_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/pain_6_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/pain_7_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/pain_8_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/pain_9_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/pain_10_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/pain_11_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/pain_12_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/pain_13_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/pain_14_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceC/pain_15_VoiceC.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/pain_1_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/pain_2_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/pain_3_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/pain_4_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/pain_5_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/pain_6_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/pain_7_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/pain_8_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/pain_9_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/pain_10_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/pain_11_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/pain_12_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/pain_13_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/pain_14_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
						{"LANGUAGES/voicepacks/voiceD/pain_15_VoiceD.wav",SOUND_UNSCALABLE,255,12,200},
					};
					entity.SoundEvents={
						{"srunfwd",		7  },
						{"srunfwd",		19 },
						{"srunback",		5  },
						{"srunback",		14 },

						{"swalkback", 		0  },
						{"swalkback", 		16 },
						{"swalkfwd",  		2  },
						{"swalkfwd",  		19 },

						{"xwalkfwd", 		2  },
						{"xwalkfwd", 		26 },
						{"xwalkback", 		0  },
						{"xwalkback", 		23 },

						{"cwalkback",		9  },
						{"cwalkback",		33 },
						{"cwalkfwd",		12 },
						{"cwalkfwd",		31 },

						{"pwalkfwd",		3  },
						{"pwalkback",		3  },

						{"arunback",		6  },
						{"arunback", 		15 },
						{"arunfwd", 		7  },
						{"arunfwd", 		19 },
							
						{"awalkback", 		1  },
						{"awalkback", 		17 },
						{"awalkfwd", 		1  },
						{"awalkfwd", 		20 },
							
						{"draw01", 		14, KEYFRAME_HOLD_GUN },
						{"draw02", 		9, KEYFRAME_HOLD_GUN },
						{"draw03", 		12, KEYFRAME_HOLD_GUN },
						{"draw04", 		14, KEYFRAME_HOLD_GUN },
						{"holster01", 		25, KEYFRAME_HOLSTER_GUN },
						{"holster02", 		35, KEYFRAME_HOLSTER_GUN },
						{"_fixfence_loop",	8,	Sound:Load3DSound("SOUNDS/items/ratchet.wav",SOUND_UNSCALABLE,100,5,30)},
					};
				end
			end
			if (Mission) and (Mission.OnCoopSpawn) and (not entity.coop_clset) then
				Mission:OnCoopSpawn(entity);
				entity.coop_clset = 1;
			end
			if (not Game:IsServer()) then
				entity.ai = nil;
			end
		elseif (not Game:IsServer()) then
			entity.cnt.max_health=220;
			entity.cnt.max_armor=100;
		end
	end
	if (entity.type == "Synched2DTable") then
		ClientStuff.idScoreboard=entity.id;
	end
end

ClientStuff.ServerCommandTable["PVID"]=function(String,toktable)
	if (UI) and (toktable[2]) then
		UI:PlayCutScene(toktable[2]);
	end
end;

ClientStuff.ServerCommandTable["PSEQ"]=function(String,toktable)
	if (Movie) and (toktable[2]) then
		Movie:PlaySequence(toktable[2]);
	end
end;

ClientStuff.ServerCommandTable["TCS"]=function(String,toktable)
	if (toktable[2]) then
		if (Mission) and (Mission.OnCoopGetMission) then
			local mget = {};
			local mget_id = 1;
			while toktable[mget_id+1] do
				mget[mget_id] = toktable[mget_id+1];
				mget_id = mget_id + 1;
			end
			Mission:OnCoopGetMission(mget);
		end
	end
end;

ClientStuff.ServerCommandTable["MMD"]=function(String,toktable)
	if (toktable[2]) then
		if (toktable[2]=="1") then
			Sound:SetMusicMood("Combat");
		elseif (toktable[2]=="0") then
			Sound:SetMusicMood("Sneaking");
		end
	end
end;

ClientStuff.ServerCommandTable["SSP"]=function(String,toktable)
	if (Hud) and (Hud.checkpointreachedsnd) then
		Sound:SetSoundVolume(Hud.checkpointreachedsnd,200);
		Sound:PlaySound(Hud.checkpointreachedsnd);
	end
	if (toktable[2]) then
		local vic = System:GetEntity(toktable[2]);
		if (vic) then
			Hud:AddMessage(vic:GetName().." @cis_ReachEnd");
		end
	else
		Hud:AddMessage("$1                                         @GameSaved");
	end
end;

ClientStuff.ServerCommandTable["RDB"]=function(String,toktable)
	if (not Game:IsServer()) and (toktable[6]) then
		local ent = System:GetEntity(toktable[2]);
		if (ent) and (ent.cnt) then
			if (ent.painSound) and (Sound:IsPlaying(ent.painSound)) then
			else
				local coopsaid = {
					{toktable[3]..".wav",SOUND_RADIUS,tonumber(toktable[6]),tonumber(toktable[4]),tonumber(toktable[5])},
				};
				ent.painSound = BasicPlayer.PlayOneSound(ent,coopsaid,101);
			end
		end
	end
end;