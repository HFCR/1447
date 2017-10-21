	-----------------------------------------------------------------------------------------------
--pvcfmod operation clearing www.reflex-studio.com 
--
--creature generator, can spawn AI with set up properties
--can run outside of opcl clearing or based devkid but ClearingSpawnTimer wont work
--fixed -- activated self:onreset because of not registered species

ClearingCreatureGenerator = {


	currcreatures=0,
	update = 0,


	Properties = {
		bActive = 1,
		CreatureType = "Grunt", --Grunt, MercRear,MercScout, NPC, MercSniper,MutantBezerker,MutantCover,MutantRear,MutantScout,Pig,Shark,Worm
		maxCreatures=100,
		bSaveable = 0,     --spawned entity can be saved
		bShowDebug = 0,
		bCreatureKnowsPlayerPos = 0,
         
    ClearingSpawnTimer   = {         
        -- bSpawnEveryHour = 0,
        -- HourCount = 4,    
         bSpawnEveryDay = 0,
         nDayTime = 14, -- 0-23
         
		},   -- ClearingTimerSpawn



	Clearing = {
			bReachableByAMedic = 1,
         	bIsCivilian=0, --pvcf
         	IsCivilMeleeWpnReaction="stunned",
         	IsCivilBulletWpnReaction="stunned",
         	fIsCivilianTimer = 0.8,
			bIsMedic=0, --pvcf
			bNoBloodSpawn= 0,         --pvcf		
			nWoundedAnimationSwellHealth = 5,     --if AI Health is below this value the next animation will be done
			WoundedAnimation = "scientist_table_prone",			
			},   --	Clearing
				

     
     AIPropertiesInstance = {
     	name = "John Bravo",
		sightrange = 35,
		soundrange = 20,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		aibehavior_behaviour = "Job_StandIdle",
		groupid = 154,
		fileHelmetModel = "",
		bHelmetOnStart = 0,
		specialInfo= "",
		bHasLight = 0,
		bGunReady = 0,
		MaterialName = "",
		},   --AIPropertiesInstance

	AIProperties = {
		equipEquipment = "m4",
		equipDropPack = "m4",		
		SOUND_TABLE = "GRUNT",
		bAffectSOM = 1,
		bSleepOnSpawn = 1,
		
		bTakeProximityDamage = 1,

		bHasArmor = 1,

		special = 0,
--		bHasLight = 0,
		aggression = 0.3,	-- 0 = passive, 1 = total aggression
		commrange = 30.0,
--		cohesion = 5,
		attackrange = 70,
		horizontal_fov = 160,
		eye_height = 2.1,
		forward_speed = 1.27,
		back_speed = 1.27,
		max_health = 120,
		accuracy = 0.6,
		responsiveness = 7,
		species = 1,
		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,

		AnimPack = "Basic",
		SoundPack = "dialog_template",		
		aicharacter_character = "Cover",
		pathname = "none",
		pathsteps = 0,
		pathstart = 0,
		ReinforcePoint = "none",
		--fileModel = "Objects/characters/mercenaries/Merc_rear/merc_rear.cgf",
		bTrackable=1,
			},    --AIProperties
		
	},

	Editor={
		Model="Objects/Editor/mtlbox.cgf",
	},

}



function ClearingCreatureGenerator:OnUpdate()

  if self.Properties.bActive == 1 then 
  	--Hud.label="update creature generator";

	if self.currcreatures >= self.Properties.maxCreatures then self.update = 0; end

				if self.Properties.bShowDebug == 1 then
					Hud.label=(self:GetName().." onupdate ");
				end		  	
  	
	if clearingtime then
		if clearingtime == self.Properties.ClearingSpawnTimer.nDayTime then
         	if not self.bWasspawnedtoday then    --to prevent countless spawnings during the whole hour
 	     		if self.Properties.bShowDebug == 1 then 
         			Hud:AddMessage("AI spawn allowed and event is called",1);    		
         		end
         		self:Event_OnSpawn(sender);
         		self.bWasspawnedtoday = 1;       
         	end	         	
       	end
		
		-----we reset here a hour later so the AI can be spawned next day again
		if self.bWasspawnedtoday and clearingtime == self.Properties.ClearingSpawnTimer.nDayTime + 1 and clearingtime < 24 and clearingtime > 0 then
			self.bWasspawnedtoday = nil;
			if self.Properties.bShowDebug == 1 then
				Hud:AddMessage("dayspawncounter resetted",1);
			end
		end
		
		if self.bWasspawnedtoday and clearingtime == self.Properties.ClearingSpawnTimer.nDayTime - 1 and clearingtime < 24 and clearingtime > 0 then
			self.bWasspawnedtoday = nil;
			if self.Properties.bShowDebug == 1 then
				Hud:AddMessage("dayspawncounter resetted",1);
			end
		end		
		
	else		
			if self.Properties.bShowDebug == 1 then
				Hud:AddMessage("no clearingtime found! place a $6ClearingDayNightTrigger to generate time!",1);
			end		
	end    --if clearingtime then
  end --if self.Properties.bActive == 1 then 	
  
end


function ClearingCreatureGenerator:OnReset()
	self.currcreatures=0;
	
	if opcl_hudstyle then   --we ask here if its running inside operation clearing or a opcldevkid based game
	    if self.Properties.ClearingSpawnTimer.bSpawnEveryDay ~= 0 and self.Properties.ClearingSpawnTimer.nDayTime <= 24 then
	    		self.update = 1;
	    	elseif self.Properties.ClearingSpawnTimer.nDayTime > 24 then
	    		self.update = 0;
	    		System:Warning( self:GetName().." could not spawn entity because a daytime > 24 o clock was given!");
				if self.Properties.bShowDebug == 1 then
					Hud:AddMessage(self:GetName().." could not spawn entity because a daytime > 24 o clock was given!",1);
				end			    		
	    	else
	    		self.update = 0;
				if self.Properties.bShowDebug == 1 then
					Hud:AddMessage(" no opcl or opcldevkid based mod found",1);
				end			    			    		
	    end

     end     --if opcl_hudstyle then   --we ask here if its running inside operation clearing or a opcldevkid based game


	local _entity = System:GetEntityByName(self.Properties.AIPropertiesInstance.name); 
	if _entity then
		Server:RemoveEntity(_entity.id);
				if self.Properties.bShowDebug == 1 then
					Hud:AddMessage(self:GetName().." child found and removed",1);
				end				
	else
				if self.Properties.bShowDebug == 1 then
					Hud:AddMessage(self:GetName().." no child to remove found ",1);
				end				
	end

	
end


function ClearingCreatureGenerator:OnInit()
	self:OnReset();	
end


function ClearingCreatureGenerator:OnSave(stm)

	WriteToStream(stm,self.Properties);	
	if not self.currcreatures then self.currcreatures = 0; end	
	stm:WriteInt(self.currcreatures);

end

function ClearingCreatureGenerator:OnLoad(stm)

	self.Properties=ReadFromStream(stm);
	self.currcreatures=stm:ReadInt();
	if not self.currcreatures then self.currcreatures = 0; end
	
		if opcl_hudstyle then   --we ask here if its running inside operation clearing or a opcldevkid based game
	    if self.Properties.ClearingSpawnTimer.bSpawnEveryDay ~= 0 and self.Properties.ClearingSpawnTimer.nDayTime <= 24 then
	    		self.update = 1;
	    	elseif self.Properties.ClearingSpawnTimer.nDayTime > 24 then
	    		self.update = 0;
	    		System:Warning( self:GetName().." could not spawn entity because a daytime > 24 o clock was given!");
				if self.Properties.bShowDebug == 1 then
					Hud:AddMessage(self:GetName().." could not spawn entity because a daytime > 24 o clock was given!",1);
				end			    		
	    	else
	    		self.update = 0;
				if self.Properties.bShowDebug == 1 then
					Hud:AddMessage(" no opcl or opcldevkid based mod found",1);
				end			    			    		
	    end

     end     --if opcl_hudstyle then   --we ask here if its running inside operation clearing or a opcldevkid based game


	local _entity = System:GetEntityByName(self.Properties.AIPropertiesInstance.name); 
	if _entity then
		Server:RemoveEntity(_entity.id);
				if self.Properties.bShowDebug == 1 then
					Hud:AddMessage(self:GetName().." child found and removed",1);
				end				
	else
				if self.Properties.bShowDebug == 1 then
					Hud:AddMessage(self:GetName().." no child to remove found ",1);
				end				
	end
	
end


function ClearingCreatureGenerator:Event_OnResetCreatureCounter(sender)
	self.currcreatures = 0;
	BroadcastEvent( self,"OnResetCreatureCounter" );
end


function ClearingCreatureGenerator:Event_OnDeActivate(sender)
	self.Properties.bActive = 0;
	self.update = 0;
	BroadcastEvent( self,"OnDeActivate" );
end

function ClearingCreatureGenerator:Event_OnActivate(sender)
	self.Properties.bActive = 1;
	BroadcastEvent( self,"OnActivate" );

	if opcl_hudstyle then   --we ask here if its running inside operation clearing or a opcldevkid based game
	    if self.Properties.ClearingSpawnTimer.bSpawnEveryDay ~= 0 and self.Properties.ClearingSpawnTimer.nDayTime <= 24 then
	    		self.update = 1;
	    	elseif self.Properties.ClearingSpawnTimer.nDayTime > 24 then
	    		self.update = 0;
	    		System:Warning( self:GetName().." could not spawn entity because a daytime > 24 o clock was given!");
				if self.Properties.bShowDebug == 1 then
					Hud:AddMessage(self:GetName().." could not spawn entity because a daytime > 24 o clock was given!",1);
				end			    		
	    	else
	    		self.update = 0;
				if self.Properties.bShowDebug == 1 then
					Hud:AddMessage(" no opcl or opcldevkid based mod found",1);
				end			    			    		
	    end

     end     --if opcl_hudstyle then   --we ask here if its running inside operation clearing or a opcldevkid based game	
	
end

function ClearingCreatureGenerator:Event_OnSpawn(sender)
	
	if self.Properties.bActive == 1 then 
	
		
		if self.currcreatures < self.Properties.maxCreatures then
			local newentity;
			newentity = Server:SpawnEntity(self.Properties.CreatureType);
			if (newentity) then
				
				BroadcastEvent( self,"OnSpawn" )
				newentity:EnableSave(self.Properties.bSaveable);
				newentity:SetPos(self:GetPos());
				newentity:SetAngles(self:GetAngles());
				newentity:SetName( self.Properties.AIPropertiesInstance.name);
	
				----------------------------------------propertiesinstance settings--------------------------------------
				newentity.PropertiesInstance.sightrange = self.Properties.AIPropertiesInstance.sightrange;
				newentity.PropertiesInstance.soundrange = self.Properties.AIPropertiesInstance.soundrange;
				newentity.PropertiesInstance.aibehavior_behaviour = self.Properties.AIPropertiesInstance.aibehavior_behaviour;
				newentity.PropertiesInstance.groupid = self.Properties.AIPropertiesInstance.groupid;
				newentity.PropertiesInstance.fileHelmetModel = self.Properties.AIPropertiesInstance.fileHelmetModel;
				newentity.PropertiesInstance.bHelmetOnStart = self.Properties.AIPropertiesInstance.bHelmetOnStart;
				newentity.PropertiesInstance.specialInfo = self.Properties.AIPropertiesInstance.specialInfo;
				newentity.PropertiesInstance.bHasLight = self.Properties.AIPropertiesInstance.bHasLight;
				newentity.PropertiesInstance.bGunReady = self.Properties.AIPropertiesInstance.bGunReady;
				
				if self.Properties.AIPropertiesInstance.MaterialName  ~= "" then
					newentity:SetMaterial(self.Properties.AIPropertiesInstance.MaterialName);
				end
				
				----------------------------------------AIproperties settings--------------------------------------
				

				newentity.Properties.SOUND_TABLE = self.Properties.AIProperties.SOUND_TABLE;
				newentity.Properties.bAffectSOM = 	self.Properties.AIProperties.bAffectSOM;
				newentity.Properties.bSleepOnSpawn = self.Properties.AIProperties.bSleepOnSpawn;
				newentity.Properties.bTakeProximityDamage = self.Properties.AIProperties.bTakeProximityDamage;
				newentity.Properties.bHasArmor = self.Properties.AIProperties.bHasArmor;
				newentity.Properties.special =	self.Properties.AIProperties.special;
				newentity.Properties.aggression = self.Properties.AIProperties.aggression;
				newentity.Properties.commrange = self.Properties.AIProperties.commrange; 
				newentity.Properties.attackrange =self.Properties.AIProperties.attackrange; 
				newentity.Properties.horizontal_fov = self.Properties.AIProperties.horizontal_fov;
				newentity.Properties.eye_height =self.Properties.AIProperties.eye_height; 
				newentity.Properties.forward_speed = self.Properties.AIProperties.forward_speed; 
				newentity.Properties.back_speed = self.Properties.AIProperties.back_speed;
				newentity.Properties.max_health = self.Properties.AIProperties.max_health;
				newentity.Properties.accuracy = self.Properties.AIProperties.accuracy;
				newentity.Properties.responsiveness =self.Properties.AIProperties.responsiveness;
				newentity.Properties.species =self.Properties.AIProperties.species; 
				newentity.Properties.fSpeciesHostility = self.Properties.AIProperties.fSpeciesHostility; 
				newentity.Properties.fGroupHostility = self.Properties.AIProperties.fGroupHostility; 
				newentity.Properties.fPersistence = self.Properties.AIProperties.fPersistence; 
				newentity.Properties.equipEquipment = self.Properties.AIProperties.equipEquipment; 
				newentity.Properties.equipDropPack = self.Properties.AIProperties.equipDropPack;
				newentity.Properties.AnimPack = 	self.Properties.AIProperties.AnimPack;
				newentity.Properties.SoundPack = self.Properties.AIProperties.SoundPack;
				newentity.Properties.aicharacter_character = self.Properties.AIProperties.aicharacter_character; 
				newentity.Properties.pathname =self.Properties.AIProperties.pathname; 
				newentity.Properties.pathsteps =self.Properties.AIProperties.pathsteps; 
				newentity.Properties.pathstart =self.Properties.AIProperties.pathstart; 
				newentity.Properties.ReinforcePoint = self.Properties.AIProperties.ReinforcePoint; 
				--newentity.Properties.fileModel = self.Properties.AIProperties.fileModel;
				newentity.Properties.bTrackable=self.Properties.AIProperties.bTrackable;				
				
				----------------------------------------AIproperties clearing settings--------------------------------------
				
            	if opcl_hudstyle and newentity.Properties.Clearing then   --we ask here if its running inside operation clearing or a opcldevkid based game
				newentity.Properties.Clearing.bReachableByAMedic = self.Properties.Clearing.bReachableByAMedic ;
     	    		newentity.Properties.Clearing.bIsCivilian= self.Properties.Clearing.bIsCivilian ;
         		newentity.Properties.Clearing.IsCivilMeleeWpnReaction= self.Properties.Clearing.IsCivilMeleeWpnReaction ;
	         	newentity.Properties.Clearing.IsCivilBulletWpnReaction= self.Properties.Clearing.IsCivilBulletWpnReaction ;
     	    		newentity.Properties.Clearing.fIsCivilianTimer =  self.Properties.Clearing.fIsCivilianTimer ;
				newentity.Properties.Clearing.bIsMedic= self.Properties.Clearing.bIsMedic ;
				newentity.Properties.Clearing.bNoBloodSpawn=  self.Properties.Clearing.bNoBloodSpawn ;
				newentity.Properties.Clearing.nWoundedAnimationSwellHealth =  self.Properties.Clearing.nWoundedAnimationSwellHealth ;
				newentity.Properties.Clearing.WoundedAnimation =  self.Properties.Clearing.WoundedAnimation ;
			end
			


				newentity:OnReset();
				--newentity:InitAllWeapons(1);
				BasicPlayer.InitAllWeapons(newentity);
				if self.Properties.bCreatureKnowsPlayerPos == 1 then    --we tell the creature where the player is
					
						
						-- let's do it, making alert event right now:
						if _localplayer and _localplayer.cnt then
							--AI:RegisterWithAI(myent.id, AIOBJECT_ATTRIBUTE);
							AI:SoundEvent(_localplayer.id,_localplayer:GetPos(),900, 0, 1, _localplayer.id);
						end
								
				end
				
	local WeaponPackName = newentity.Properties.equipEquipment;

	if (WeaponPackName) then		
		local PlayerPack = EquipPacks[WeaponPackName];
		if (PlayerPack ~= nil) then
			if self.Properties.bShowDebug == 1 then
				self.lastselected = newentity.cnt:GetCurrWeaponId();
					Hud:AddMessage("weaponplayerpack found :"..newentity:GetName()..".  wpnpackage ID:"..self.lastselected ,1);
			end			
			--for iIdx, CurPackWeapon in PlayerPack do0
				--if (CurPackWeapon.Type == "Weapon" and CurPackWeapon.Name == wName) then
				--	newentity.cnt:MakeWeaponAvailable(CurWeaponClsID, 1);
					--System:LogToConsole(" --> Name: "..wName);
				--end
			--end
		end
	else
				if self.Properties.bShowDebug == 1 then
					Hud:AddMessage("AI spawned and tried to set up properties :"..newentity:GetName()..".  $4 NO $1wpnpackage found" ,1);
			end	
	end				
		
			else
				System:Warning( "[AI] ClearingCreatureGenerator could not spawn entity of type "..self.Properties.CreatureType);
				if self.Properties.bShowDebug == 1 then
					Hud:AddMessage("[AI] ClearingCreatureGenerator could not spawn entity of type "..self.Properties.CreatureType,1);
				end						
			end
			self.currcreatures=self.currcreatures+1;
		else
			self.update = 0;			
		 	     if self.Properties.bShowDebug == 1 then 
         			Hud:AddMessage(self:GetName().." have reached his maximum number of allowed AI spawns.",1);    		
         		end
		end	--if self.currcreatures <= self.Properties.maxCreatures then
		
	else--if self.Properties.bActive == 1 then 
				if self.Properties.bShowDebug == 1 then
					Hud:AddMessage(self:GetName().." was called but is deactivated",1);
				end					
	end --if self.Properties.bActive == 1 then 
end

function ClearingCreatureGenerator:OnShutDown()
end


		
		