-- HIGHLY OPTIMIZED HUDCOMMON v1.7cis_cis_ind BY MIXER www.verysoft.narod.ru

Hud={
color={r=0.66,g=0.8,b=0.8},
color_top={r=0.66,g=1.0,b=1.0},
color_red={1, 0.0, 0.0,1}, --color_red={1, 0.3, 0.3,1}, previous red..
color_blue={0.1 ,0.6,0.75,1},
color_yellow={1,1,0,1},
color_white={1,1,1,1},
dmgindicator=0,
dmgfront=0,
dmgback=0,
dmgleft=0,
dmgright=0,
sound_scale=1,
hit=0,
hdadjust=0,
hdadjusty=0,
hd_sc_mult=1,
cis_sneakval=0,
cis_lastkey="",

messages={},
kill_messages={},
tSubtitles={},
fSubtlCurrY=0.0,
fSubtlCurrDelay=0.0,
f_value=1,
hd_width = 0.1,
deafness_fadeout_time=5, -- lennert
breathlevel=-1, -- marco
staminalevel=0.45, -- tiago, Mixer: (0.45 to prevent heavy breath on level start)
blindingFade = 1, -- kirill

-- Tiago: added
radar_transparency = 0.0,        
stamina_level = 64.5,
breath_level = 64.5,

radarObjective = nil,-- current radar objective tag point e.g. {x=1,y=2,z=3}
meleeDamageType=nil,-- [tiago] melee damage type

DisplayControl = {
bShowRadar = 1,
bBlinkRadar = 0,
fBlinkUpdateRadar = 0,

bShowProjectiles = 1,
bBlinkProjectiles = 0,
fBlinkUpdateProjectiles = 0,

bShowBreathOM = 1,
bBlinkBreathOM = 0,
fBlinkUpdateBreathOM = 0,

bShowWeapons = 1,
bBlinkWeapons = 0,
fBlinkUpdateWeapons = 0,

bShowAmmo = 1,
bBlinkAmmo = 0,
fBlinkUpdateAmmo = 0,

bShowStance = 1,
bBlinkStance = 0,
fBlinkUpdateStance = 0,

bShowEnergyMeter =1,
bBlinkEnergyMeter =0,
fBlinkUpdateEnergyMeter=0,
},

idShowMissionObject=nil,-- used to identify the one active Message entity, nil for non

-- progress indicators
Progress=
{
Player=-- player progress indicator
{
LocalToken=nil,-- nil if there is no progress to show e.g. "build progress"
ValueX=nil,-- 0..100 e.g. 50, nil if unused
ValueY=nil,-- 0..100 e.g. 50, nil if unused
ValueZ=nil,-- 0..100 e.g. 50, nil if unused
EndTime=nil,-- time when the indicator should disapper (nil if not used)
Seconds=1.0,-- amount of seconds this indicator should stay (nil=forever)
Draw=nil,-- draw function ... specified below
},

AssaultState=-- progress indicator for showing the state of the Assault game (captured checkpoints)
{
LocalToken=nil,-- nil if there is no progress to show e.g. 
ValueX=nil,-- 0..100 e.g. 50, nil if unused
ValueY=nil,-- 0..100 e.g. 50, nil if unused
ValueZ=nil,-- 0..100 e.g. 50, nil if unused
EndTime=nil,-- time when the indicator should disapper (nil if not used)
Seconds=nil,-- amount of seconds this indicator should stay (nil=forever)
Draw=nil,-- draw function ... specified below
},
},

-- Create Table for players.
tblPlayers = {},

pViewLayersTbl= {},
bActivateLayers=0,
}

function Hud:DrawRightAlignedString(text_size, text_print, sizex, sizey, r, g, b, a, y, spacing)
local w, h = Game:GetHudStringSize(text_size, sizex, sizey);
local x = 800 - spacing - w;

Game:WriteHudString(x, y, text_print, r, g, b, a, sizex, sizey);
end

-- clamp value into specified range..

function Hud:ClampToRange(val, minval, maxval) 
if(val<minval) then
val=minval;
elseif(val>maxval)then
val=maxval;
end
return val;
end

-- draw function for 'player' progress indicator

Hud.Progress.Player.Draw = function(hud)
%Game:SetHUDFont("hud", "ammo");
local PTable = Hud.Progress.Player;
local text=PTable.LocalToken;
local strsizex,strsizey = Game:GetHudStringSize(text, 26, 26);
local strwidth = strsizex;
local size=(strwidth+10)/200;

-- text box
local ypos=300-10;

local fStep=42/70;
hud:DrawScoreBoard(400-(strwidth*0.5)-10, ypos, size, fStep, 100, hud.tmpscoreboard.bar_score, 1, 1, 1, 1, 0, 0);
ypos=ypos+42;
hud:DrawScoreBoard(400-(strwidth*0.5)-10, ypos, size, 1, 100, hud.tmpscoreboard.bar_bottom, 1, 1, 1, 1, 0, 0);

if(PTable.ValueX)then-- progress was given
local r=0;
local g=0;
local b=0;
local progressStep=(PTable.ValueX/100);
g = 1.0 + (g-1.0) * progressStep;
if(g>=1) then g=1; end;
r = r + (1.0-r) * progressStep;
if(r>=1) then r=1; end;

hud:DrawBar(400-(strwidth*0.5)-5, 320, progressStep*strwidth*1.28 ,32, 35, g, r, 0, 0.8);

else-- no progress was given (e.g. cannot build because construction are is blocked)

hud:DrawElement(395, ypos-10, hud.pickups[19],  1, 1, 1, 0.9);

end

Game:WriteHudString(400-(strwidth*0.5)+10, 300, text,  1, 1, 1, 1, 26, 26);    -- information text 
end

-- draw function for 'AssaultState' progress indicator

Hud.Progress.AssaultState.Draw = function(hud)
local PTable = Hud.Progress.AssaultState;
local iItemCount=PTable.ValueZ;-- e.g. 5 for 5 ASSAULTCheckpoints
local iItemCurrent=0;
local xStep=50; -- icon size is 50
local x, y=35, 35; 

local FrameTime=_frametime;

while  iItemCurrent < iItemCount do
if(iItemCurrent== tonumber(PTable.ValueX)) then

local iCurrState=tonumber(PTable.ValueY);

-- default and max scale
local itemScale, itemMaxScale=0.66,0.85;

-- state has changed ?
if(hud.ProgressStateTime~=0.0) then
hud.ProgressStateTime=hud.ProgressStateTime-FrameTime*2;

-- scale item (using bezier..)
local scaleSqrAmount=hud.ProgressStateTime*hud.ProgressStateTime;
local invScaleAmount=1-hud.ProgressStateTime;
local invSqrScaleAmount=invScaleAmount*invScaleAmount;
itemScale=0.66*(invSqrScaleAmount+scaleSqrAmount)+2*itemMaxScale*invScaleAmount*hud.ProgressStateTime;

-- reset animation
if(hud.ProgressStateTime<0.0) then
hud.ProgressStateTime=0.0;
itemScale=0.66;
end
end
-- state changed ? activate scaling
if(hud.ProgressPreviousState~=iCurrState and hud.ProgressPreviousState~=-1 and iCurrState>0) then
hud.ProgressStateTime=1.0;
end
if(iCurrState==0) then
hud:DrawQuadMP(x, y, 0.66*Hud.hd_sc_mult, 0.66, 100, hud.tmultiplayerhud.progressi_changing, 1, 1, 1, 1, 0, 0);
elseif(iCurrState==1) then
hud:DrawQuadMP(x, y, itemScale*Hud.hd_sc_mult, itemScale, 100, hud.tmultiplayerhud.progressi_current, 1, 1, 1, 1, 0, 0);
elseif(iCurrState==2) then
hud:DrawQuadMP(x, y, itemScale*Hud.hd_sc_mult, itemScale, 100, hud.tmultiplayerhud.progressi_01, 1, 1, 1, 1, 0, 0);
elseif(iCurrState==3) then
hud:DrawQuadMP(x, y, itemScale*Hud.hd_sc_mult, itemScale, 100, hud.tmultiplayerhud.progressi_02, 1, 1, 1, 1, 0, 0);
elseif(iCurrState==4) then
hud:DrawQuadMP(x, y, itemScale*Hud.hd_sc_mult, itemScale, 100, hud.tmultiplayerhud.progressi_03, 1, 1, 1, 1, 0, 0);
elseif(iCurrState==5) then
hud:DrawQuadMP(x, y, itemScale*Hud.hd_sc_mult, itemScale, 100, hud.tmultiplayerhud.progressi_04, 1, 1, 1, 1, 0, 0);
end

-- save current state
hud.ProgressPreviousState= iCurrState;
elseif( iItemCurrent < tonumber(PTable.ValueX)) then
hud:DrawQuadMP(x, y, 0.66*Hud.hd_sc_mult, 0.66, 100, hud.tmultiplayerhud.progressi_done, 1, 1, 1, 1, 0, 0);
else
hud:DrawQuadMP(x, y, 0.66*Hud.hd_sc_mult, 0.66, 100, hud.tmultiplayerhud.progressi_unavailable, 1, 1, 1, 1, 0, 0);
end

-- increment position
x=x+xStep;

-- increment item count...
iItemCurrent= iItemCurrent + 1;
end

-- render..
hud.mp_rend:Draw(hud.tx_multiplayerhud);
end

-- set radar objective

function Hud:SetRadarObjective(tagPointName)
Hud:SetRadarObjectivePos( Game:GetTagPoint(tagPointName) );
self.bBlinkObjective=1;
end

-- set radar objective to xyz position e.g. {x=1,y=2,z=3}

function Hud:SetRadarObjectivePos(Pos)
Hud.radarObjective=new(Pos);    
end

-- Callback for sorting messages

function message_compare(a,b)
if(a and b) then
if(a.lifetime>b.lifetime)then 
return 1
end
end
end

-----------------------------------------------------------------------------
-- Process messages box, message list
-----------------------------------------------------------------------------

function Hud:ProcessAddMessage(tMsgList, text, lifetime, beep, killmsg) 

-- check for same timed messages, increase recent ones timming for correct sorting
if(tMsgList and tMsgList[count(tMsgList)] and  tMsgList[1].lifetime) then
if(tMsgList[1].lifetime>=6) then
lifetime=tMsgList[1].lifetime+0.01; 
end
end

local isOnTop=0;
if(not killmsg) then
isOnTop=1;
end

tMsgList[count(tMsgList)+1]= {
killmsg = killmsg,
time=_time,
text=text,
lifetime=lifetime, 
curr_ypos=0, 
isTop=isOnTop,
};

-- only necessary for non-killmsg's
if (not killmsg) then
local i=1;
local k=count(tMsgList);
while(i<k) do
tMsgList[i].isTop=0;
i=i+1;
end
end

-- sort table items by lifetime
sort(tMsgList,%message_compare);

-- remove old messages
while (count(tMsgList)>4) do
tMsgList[count(tMsgList)]=nil;
end

if(cl_msg_notification=="1" and (not Game:IsMultiplayer()) and beep and beep==1) then
Sound:PlaySound(self.NewMessageSnd);
end
end

-- add new messages to messages box

function Hud:AddMessage(text,_lifetime, beep, killmsg)
-- need to process also kill messages in mp game
-- NOTE: must have constant time (requested, don't change!)
if(Game:IsMultiplayer() and killmsg and killmsg==1) then
self:ProcessAddMessage(self.kill_messages, text, 6, beep, 1);
else
self:ProcessAddMessage(self.messages, text, 6, beep);
end
end

-----------------------------------------------------------------------------
-- Set current screen center message
-----------------------------------------------------------------------------

function Hud:AddCenterMessage(text,time)
self.centermessage=text;
if(time)then
self.centermessagetime=time;
else
self.centermessagetime=1;
end
end

-----------------------------------------------------------------------------
-- Initialize sp hud texture, texture coordinates offsets
-----------------------------------------------------------------------------

function Hud:InitTexTable(tt)
local tw,th=511,255;
for i,val in tt do
val.size={}
val.size.w=val[3];
val.size.h=val[4];
val[1]=val[1]/tw;
val[2]=val[2]/th;
val[3]=val[1]+(val[3]/tw);
val[4]=val[2]+(val[4]/th);
end
end

-----------------------------------------------------------------------------
-- merge tables
-----------------------------------------------------------------------------

function merge_no_copy(dest,source)
for i,val in source do
if(type(dest[i])==type(val))then
if(type(dest[i])~="table")then
dest[i]=val;
else
merge_no_copy(dest[i],val);
end
end
end
end

function Hud:GetKeyHint(actionname)
	local ActionList = Game:GetActions();
	for i, Action in ActionList do
		if (Action.desc == actionname) then
			local zt = Input:GetBinding(Action.actionmaps[1], Action.id);
			if (zt) and (zt[1]) and (zt[1].key_id) then
				return("@control"..zt[1].key_id);
			end
		end
	end
	return " ";
end

-----------------------------------------------------------------------------
-- save hud mission data
-----------------------------------------------------------------------------

function Hud:OnSave(stm)

-- save radar objective
if (self.radarObjective==nil) then
stm:WriteBool(0);
else
stm:WriteBool(1);
WriteToStream(stm, self.radarObjective);
end

-- save mission objective
if(self.objectives==nil) then
stm:WriteBool(0);
else
stm:WriteBool(1);
WriteToStream(stm, self.objectives);
end

-- save hud messages
if(Hud.messages==nil) then
stm:WriteBool(0);
else
stm:WriteBool(1);
WriteToStream(stm, Hud.messages);
end

-- save hit damage data
if(not self.hitdamagecounter) then
stm:WriteBool(0);
else
stm:WriteBool(1);
stm:WriteFloat(self.hitdamagecounter);
end

stm:WriteFloat(self.dmgfront);
stm:WriteFloat(self.dmgback);
stm:WriteFloat(self.dmgleft);
stm:WriteFloat(self.dmgright);

-- save hud state
if(self.DisplayControl==nil) then
stm:WriteBool(0);
else
stm:WriteBool(1);
WriteToStream(stm, self.DisplayControl);
end
    
  -- save flashbang state
  local bFlashBangActive=System:GetScreenFx("FlashBang");
  if(bFlashBangActive and bFlashBangActive==1) then
  stm:WriteBool(1);  
  local fFlashBangTimeScale = System:GetScreenFxParamFloat("FlashBang", "FlashBangTimeScale");
stm:WriteFloat(fFlashBangTimeScale);  

  local fFlashBangTimeOut = System:GetScreenFxParamFloat("FlashBang", "FlashBangTimeOut");
stm:WriteFloat(fFlashBangTimeOut);  

  local fFlashBangFlashPosX=  System:GetScreenFxParamFloat("FlashBang", "FlashBangFlashPosX");
stm:WriteFloat(fFlashBangFlashPosX);  
  
  local fFlashBangFlashPosY=  System:GetScreenFxParamFloat("FlashBang", "FlashBangFlashPosY");  
stm:WriteFloat(fFlashBangFlashPosY);  
  
  local fFlashBangFlashSizeX=  System:GetScreenFxParamFloat("FlashBang", "FlashBangFlashSizeX");
stm:WriteFloat(fFlashBangFlashSizeX);  
  
  local fFlashBangFlashSizeY=  System:GetScreenFxParamFloat("FlashBang", "FlashBangFlashSizeY");    
stm:WriteFloat(fFlashBangFlashSizeY);  
  else
  stm:WriteBool(0);  
  end

-- save deafness
if (Hud.initial_deaftime==nil) then
stm:WriteBool(0);
else
stm:WriteBool(1);
stm:WriteFloat(Hud.initial_deaftime);
end

if (Hud.deaf_time==nil) then
stm:WriteBool(0);
else
stm:WriteBool(1);
stm:WriteFloat(Hud.deaf_time);
end
    
end

-----------------------------------------------------------------------------
-- load old hud mission data (to maintain saves games compatibility..)
-----------------------------------------------------------------------------

function Hud:OnLoadOld(stm)

-- load radar objective
local bObj=stm:ReadBool();
if (bObj) then
self.radarObjective=ReadFromStream(stm);
end

-- load mission objective
bObj=stm:ReadBool();
if (bObj) then
self.objectives=ReadFromStream(stm);
end

-- load hud state..
bObj=stm:ReadBool();
if(bObj) then
self.DisplayControl=ReadFromStream(stm);
end

end

-----------------------------------------------------------------------------
-- load hud mission data
-----------------------------------------------------------------------------

function Hud:OnLoad(stm)

-- load radar objective
local bObj=stm:ReadBool();
if (bObj) then
self.radarObjective=ReadFromStream(stm);
end

-- load mission objective
bObj=stm:ReadBool();
if (bObj) then
self.objectives=ReadFromStream(stm);
end

-- load messages
bObj=stm:ReadBool();
if(bObj) then
Hud.messages=ReadFromStream(stm);
end

-- load hit damage data
bObj=stm:ReadBool();
if(bObj) then
self.hitdamagecounter=stm:ReadFloat();
end

self.dmgfront=stm:ReadFloat();
self.dmgback=stm:ReadFloat();
self.dmgleft=stm:ReadFloat();
self.dmgright=stm:ReadFloat();

-- load hud state
bObj=stm:ReadBool();
if(bObj) then
self.DisplayControl=ReadFromStream(stm);
end

-- load flashbang state
bObj=stm:ReadBool();
if(bObj) then
  local fFlashBangTimeScale=stm:ReadFloat();  
  System:SetScreenFxParamFloat("FlashBang", "FlashBangTimeScale", fFlashBangTimeScale);

  local fFlashBangTimeOut=stm:ReadFloat();  
  System:SetScreenFxParamFloat("FlashBang", "FlashBangTimeOut", fFlashBangTimeOut);
  
  local fFlashBangFlashPosX= stm:ReadFloat();  
  System:SetScreenFxParamFloat("FlashBang", "FlashBangFlashPosX", fFlashBangFlashPosX);
  
  local fFlashBangFlashPosY= stm:ReadFloat();  
  System:SetScreenFxParamFloat("FlashBang", "FlashBangFlashPosY", fFlashBangFlashPosY);  
  
  local fFlashBangFlashSizeX= stm:ReadFloat();  
  System:SetScreenFxParamFloat("FlashBang", "FlashBangFlashSizeX", fFlashBangFlashSizeX);
  
  local fFlashBangFlashSizeY= stm:ReadFloat();   
  System:SetScreenFxParamFloat("FlashBang", "FlashBangFlashSizeY", fFlashBangFlashSizeY);    
  
  -- activate it
  System:SetScreenFx("FlashBang", 1);      
  System:SetScreenFxParamFloat("FlashBang", "FlashBangForce", 1);    
end

-- load deafness
bObj=stm:ReadBool();
if (bObj) then
  Hud.initial_deaftime=stm:ReadFloat();
end

bObj=stm:ReadBool();
if (bObj) then
Hud.deaf_time=stm:ReadFloat();
end


end

-- Initialize all data

function Hud:CommonInit()

Language:LoadStringTable("HUD.xml");


Game:CreateVariable("hud_damageindicator",1);

Game:CreateVariable("tds_ScreenBlur",1);
Game:CreateVariable("tds_ScreenBlurAmount",0.01);
Game:CreateVariable("tds_ScreenBlurColorRed",1);
Game:CreateVariable("tds_ScreenBlurColorGreen",1);
Game:CreateVariable("tds_ScreenBlurColorBlue",1);


Game:CreateVariable("r_hd_screen",0); -- for scope lens shader!
Game:CreateVariable("hud_damageindicator",1);
-- hud textures

if (not Game.cis_SpOptionKey) then
	local sSpOptKey = "5";
	if (UI) then
		sSpOptKey = UI:Ecfg("bin32/rc.ini","SpOptionKey");
		if (not sSpOptKey) then
			sSpOptKey = "5";
			UI:Ecfg("bin32/rc.ini","SpOptionKey",sSpOptKey);
		end
	end
	Game.cis_SpOptionKey = strlower(sSpOptKey);
	if (Game.AddCommand) then
		Game:AddCommand("cis_special","Hud:SwitchCisSpecial();","cis_special");
	end
	Input:BindCommandToKey("\\cis_special",Game.cis_SpOptionKey,1);
	Input:BindCommandToKey("\\cis_special",strupper(Game.cis_SpOptionKey),1);
end
--------
if (not Game.cis_KnifeKey) then
	local sSpOptKey = "capslock";
	if (UI) then
		sSpOptKey = UI:Ecfg("bin32/rc.ini","KnifeMash");
		if (not sSpOptKey) then
			sSpOptKey = "capslock";
			UI:Ecfg("bin32/rc.ini","KnifeMash",sSpOptKey);
		end
	end
	Game.cis_KnifeKey = strlower(sSpOptKey);
	if (Game.AddCommand) then
		Game:AddCommand("cl_knifemash","ClientStuff:KnifeMash();","cl_knifemash");
	end
	Input:BindCommandToKey("\\cl_knifemash",Game.cis_KnifeKey,1);
	Input:BindCommandToKey("\\cl_knifemash",strupper(Game.cis_KnifeKey),1);
end
---------

-- cis energy bg
self.cis_energy_bg=System:LoadImage("Textures/hud/cis_energy_bg.dds");
self.cis_use_hint=System:LoadImage("Textures/hud/use_hint");

if (getglobal("g_language")) == "russian" then
	self.cis_carry_hint=System:LoadImage("Textures/hud/carry_hint_ru");
else
	self.cis_carry_hint=System:LoadImage("Textures/hud/carry_hint_en");
end

self.keycodee = System:LoadImage("Textures/hud/typecodeenter");

-- damage indicator icons
self.damage_icon_lr=System:LoadImage("Textures/hud/damage_gradL.dds");
self.damage_icon_ud=System:LoadImage("Textures/hud/damage_gradT.dds");

-- mission textures
self.missioncheckbox=System:LoadImage("Textures/Hud/new/MissionBoxCheckbox.tga");
self.missioncheckboxcomp=System:LoadImage("Textures/Hud/new/MissionCheckboxComp.tga");
-- [Michael G.], texture not used???
-- self.missionboxframe=System:LoadImage("Textures/Hud/new/MissionBoxFrame.tga");
self.radimessageicon=System:LoadImage("Textures/Hud/new/RadiomessageIcon");

-- general use textures
self.white_dot=System:LoadImage("Textures/hud/white_dot.tga");
self.black_dot=System:LoadImage("Textures/hud/black_dot.tga");
self.blue=System:LoadImage("Textures/hud/blue.dds");

--self.flashlight_blinding=System:LoadImage("Textures/flight");
self.flashlight_blinding=System:LoadImage("Textures/fl");

-- keycard icons
self.KeyItem= {
System:LoadImage("Textures/hud/keyItem_red.dds"),
System:LoadImage("Textures/hud/keyItem_green.dds"),
System:LoadImage("Textures/hud/keyItem_blue.dds"),
System:LoadImage("Textures/hud/keyItem_yellow.dds"),
}

-- object icons
self.ObjectItem= {
System:LoadImage("Textures/hud/ExpItem.dds"),
System:LoadImage("Textures/hud/PDAItem.dds"),
System:LoadImage("Textures/hud/BombfuseItem.dds"),
System:LoadImage("Textures/hud/scouttool_item.dds"),
}

self.underbreathvalue=1;

  -- radar textures
self.Radar=System:LoadImage("Textures/hud/compass.dds");
self.RadarMask=System:LoadImage("Textures/hud/compass_mask.dds");
self.RadarPlayerIcon=System:LoadImage("Textures/hud/RadarPlayer.dds");
self.RadarEnemyInRangeIcon=System:LoadImage("Textures/hud/RadarEnemyInRange.dds");
self.RadarEnemyOutRangeIcon=System:LoadImage("Textures/hud/RadarEnemyOutRange.dds");
self.RadarSoundIcon=System:LoadImage("Textures/hud/RadarSound.dds");
self.RadarObjectiveIcon=System:LoadImage("Textures/hud/RadarPlayer.dds");

--NEW HUD

local path="Textures/hud/";
self.rend=Game:CreateRenderer();

-- hud main texture
self.tx_hud=System:LoadImage(path.."hud.dds");

-- temporary vars..
self.curr_stamina=100;
self.curr_armor=0;
self.curr_health=0;
self.curr_healthAlpha=1;
self.curr_vehicledamage=0;
self.curr_vehicledamageAlpha=1;
self.curr_stealth=0;
self.curr_motiontrackerAlpha=1;

-- hud main texture, position/offsets
-- position(x,y), size(width,height)
self.txi={
shape_bar={ 113, 40, 75, 27},
white_dot={1, 1, 2, 2},
health_bar={230, 204, 172, 51},
ammo_bar={404, 205, 109, 51},
health_inside={389, 11, 115, 10},
stamina_inside = { 376, 26, 116, 10},
armor_inside={ 366, 41, 116, 10},
oxygen_frame={484,83,18,86},
shape_stealth_left = { 427, 135, 38, 67},
sealth_inside_left = { 429,  62, 33, 63},
shape_stealth_right = { 466, 134, 39, 68},
sealth_inside_right = { 469,  61, 33, 63},
shape_googles_energy = { 345, 146, 71, 21},
googles_energy_inside = {349, 182, 64, 13},
flashlight_on = {212, 170, 32, 32},
motiontracker_border = { 341, 6, 30, 24 },
motiontracker_signal = { 345, 31, 14, 14 },
}

self.tnum={
[0]={ 7, 16, 8, 13},
[1]={15, 16, 8, 13},
[2]={25, 16, 8, 13},
[3]={35, 16, 8, 13},
[4]={47, 16, 8, 13},
[5]={57, 16, 8, 13},
[6]={68, 16, 8, 13},
[7]={78, 16, 8, 13},
[8]={88, 16, 8, 13},
[9]={99, 16, 8, 13},
}

self.tnum_small={
[0]={ 7, 36, 7, 10},
[1]={14, 36, 7, 10},
[2]={21, 36, 7, 10},
[3]={29, 36, 7, 10},
[4]={38, 36, 7, 10},
[5]={46, 36, 7, 10},
[6]={54, 36, 7, 10},
[7]={62, 36, 7, 10},
[8]={70, 36, 7, 10},
[9]={78, 36, 7, 10},
}

self.mpKills={

KnifeDummy={ 3, 88,  51,  16},--knifedummy
A2000={ 56, 164,  56,  23},--A2000
Vector={375,35,62,25},
M1911={32,196,33,21},
Hands={  1, 52,	53,  18}, -- Hands
Shocker={  2,  71,  53,  18},  -- Shocker
Machete={  3, 88,  51,  16}, -- Machete
MacheteFly={439,37,48,17}, -- flying machete
SniperRifle={  2, 105,  54,  14}, -- SniperRifle

M4={  0, 162,  57,  25}, -- M4
Sopmod={  0, 162,  57,  25}, -- M4

Falcon={ 0, 195,  32,  22}, -- Falcon

Glock17={252,203,24,20},--glock17
walther={61,139,53,19},--walther
mp5_k={  66,165,45,21}, -- mp5k
DUALMP7={223,225,41,27},--dualmp7
P99={214,202,36,21}, -- p99
M3={117,25,54,10},--m3

MP5={ 56, 164,  56,  23}, -- MP5
AG36={  0, 226,  58,  21}, -- AG36
AG36Grenade ={  0, 226,  58,  21}, -- AG36
Shotgun={144, 195,  51,  18}, -- Shotgun

P90={145, 162,  52,  24}, -- P90

OICW={144, 130,52,  24}, -- OICW
OICWGrenade = {144, 130,52,  24}, -- OICW
RL={145,  99,53,  26}, -- RL
G11={111, 1, 62, 22}, -- G11
Chaingun={  53, 50, 58,  18}, -- Chaingun
MutantShotgun={110,21,65,15},
Plasmaball={110,21,65,15},
Steyr={4,142,51,19},
Rocket={145,  99,53,  26}, -- RL/Rocket
M249={144,  71,54,  20}, -- M249
Claws={116,118,27,25}, -- Claws
ADT10={306,215,33,44}, -- survival turret
EngineerTool={61,97,55,16}, -- EngineerTool (duplicated ?)
MedicTool={ 68, 193,25,  25}, --MedicTool
ScoutTool={ 56, 221, 50, 24}, -- ScoutTool
Suicided= { 110, 193, 24, 24},  -- Suicided
Headshot = { 401, 229, 23, 26},  -- Suicided
Bleed = { 399, 198, 30, 27},  -- Bleeding
StickyExplosive = { 56, 221, 50, 24},
HandGrenade={167, 219, 22, 31},-- grenade damage
HandMga={167, 219, 22, 31}, --mga
BaseHandGrenade={167, 219, 22, 31},-- grenade damage
VehicleMountedAutoMG = { 59, 112, 55, 23 },-- mounted weapons
MountedMiniGun= { 59, 112, 55, 23 },-- mounted weapons
VehicleMountedMG = { 59, 112, 55, 23 },-- mounted weapons
VehicleMountedRocketMG = { 59, 112, 55, 23 },
VehicleRocket = { 59, 112, 55, 23 },
VehicleMountedRocket = { 59, 112, 55, 23 },
MountedWeaponVehicle = { 59, 112, 55, 23 },
MountedWeaponBase =  { 59, 112, 55, 23 },
MortarShell = { 59, 112, 55, 23 },
Mounted= {59, 112, 55, 23 },
MG = { 59, 112, 55, 23 },
MutantMG = { 59, 112, 55, 23 },
MountedWeaponMG  = { 59, 112, 55, 23 },
MortarMountedWeapon = { 59, 112, 55, 23 },
HoverMG = { 432, 210, 73, 25 },
Player = { 433, 234, 72, 23 },
COVERRL = {208, 204,74,  19},
Mortar = { 60, 133, 51, 21 },
Vehicle = { 345, 63, 76, 34 }, -- vehicle damage	
Boat = { 260, 142, 81, 32 }, -- vehicle damage
Bow = {14, 0,73, 16},
Meat = {489,36,22,25}, -- siskasosiska
De_gold={ 0, 195,  32,  22},
Crowbar = {17,1,62,15},
BasicEntity = {307, 102, 32, 32},
Piece = {307, 102, 32, 32},
}

self.tweapons={
[9]={  1, 52,	53,  18}, -- Hands
[10]={ 0, 195,  32,  22}, -- Falcon
[11]={  0, 226,  58,  21}, -- AG36
[12]={ 56, 164,  56,  23}, -- MP5
[13]={  3, 88,  51,  16}, -- Machete
[14]={144, 195,  51,  18}, -- Shotgun
[15]={  2, 105,  54,  14}, -- SniperRifle
[16]={144, 130,52,  24}, -- OICW
[17]={  53, 50, 58,  18}, -- Chaingun
[18]={145,  99,53,  26}, -- RL
[19]={145, 162,  52,  24}, -- P90
[20]={  0, 162,  57,  25}, -- M4
[21]={  2,  71,  53,  18},  -- Shocker
[22]={144,  71,54,  20}, -- M249
[24]={208, 204,74,  19}, -- AlienRL
[26]={110,23,65,13}, -- Alien Shotgun
[27]={ 61,97,55,16}, -- EngineerTool (duplicated ?)
[28]={ 68, 193,25,  25}, -- MedicTool
[29]={116,118,27,25}, -- Claws
[30]={ 56, 221, 50, 24}, -- ScoutTool
[36]={111, 1,62, 22}, -- G11
[37]={214,202,36,21}, -- p99
[38]={0, 162,  57,  25}, -- sopmod
[39]={4,142,51,19}, -- steyr
[41]={117,25,54,10},--m3
[42]={61,139,53,19},--walther
[43]={223,225,41,27},--dualmp7
[44]={252,203,24,20},--glock17
[45]={ 3, 88,  51,  16},--knifedummy
[46]={ 56, 164,  56,  23},--A2000
[47] = {14, 0,73, 16},--bow --another
[48] = {375,35,62,25},--vector
[51]={ 348, 202, 41,  24},--Salo
[52]={ 338, 227, 60,  21},--Vodka
[53]={280,200,17,25},--Yoghurt
[54]={32,196,33,21},--m1911
[58]={489,36,22,25}, --meatebaniy
}

self.tgrenades={
	Rock={109, 218, 22, 31},
	HandGrenade={167, 219, 22, 31},
	SmokeGrenade={193, 219, 22, 31},
	HandMga={167, 219, 22, 31}, --mga
	FlashbangGrenade={142, 219, 22, 31},
	Def_Sentry={306,215,33,44},
	Bandage={489,36,22,25},
}

self.wicons={
melee={120, 116, 23, 27},
auto={120, 94, 23, 22},
single={120, 72, 23, 22},
grenade={120, 143, 23, 21},
rocket={120, 167, 23, 24},
}

self.scoreboard={
background={159, 50, 2, 2},
corner ={123, 1, 33, 33},
}

self.mischolders={
car_damage_frame= { 345, 63, 76, 34 },
car_damage_inside= { 350, 107, 67, 24 },
boat_damage_frame= { 260, 142, 81, 32 },
boat_damage_inside= { 265, 174, 68, 26 },
ahover_damage_frame= { 432, 209, 73, 25 },
ahover_damage_inside= { 433, 233, 72, 23 },
googles_energy_frame= { 1, 1, 1, 1 },
googles_energy_inside= { 1, 1, 1, 1 },
money_bag = {338,199,62,54},
plasma_trail = {211,171,21,20},
}

self.pickups= {
{ 64, 189, 32, 32}, -- health, 1
{ 242, 6, 32, 32}, -- assault, 2
{ 274, 6, 32, 32}, -- smg, 3
{ 307, 6, 32, 32}, -- sniper, 4
{ 210, 38, 32, 32}, -- pistol, 5
{ 242, 38, 32, 32}, -- shotgun, 6
{ 274, 38, 32, 32}, -- flashbang grenade, 7
{ 307, 38, 32, 32}, -- smoke grenade, 8
{ 210, 70, 32, 32}, -- rocket, 9
{ 242, 70, 32, 32}, -- ag36 grenade, 10
{ 274, 70, 32, 32}, -- oicw grenade, 11
{ 307, 70, 32, 32}, -- grenade, 12
{ 210, 102, 32, 32}, -- cryvision googles, 13
{ 242, 102, 32, 32}, -- armor, 14
{ 274, 102, 32, 32}, -- binoculars, 15
{ 307, 102, 32, 32}, -- rock, 16
{ 210, 6, 32, 32}, -- flashlight, 17
{ 177, 2, 32, 32}, -- universal ammo - 18
{ 211, 137, 32, 32 }, -- red cross, 19
{306,215,33,44}, -- adt, 20
{271,225,35,31}, -- scuba, 21
{489,36,22,25}, -- bandage,22
{ 348, 202, 38,  24},--Salo,23
{ 338, 227, 60,  21},--vodka,24
{212,199,15,16}, --silencer25
{ 307, 102, 32, 32}, -- x850 26
{280,200,17,25},--Yoghurt 27
{489,36,22,25}, --meat 
{167, 219, 22, 31}, --mga
}

self.ammoPickupsConversionTbl= {
Pistol= 4,
Assault= 1,
SMG= 2,
OICWGrenade= 10,
Shotgun= 5,
Rocket= 8,
Sniper= 3,
Arrows=3,
AG36Grenade= 9,
HandGrenade=11,
FlashbangGrenade=6,
SmokeGrenade=7,
Minigun=17,
Caseless47=4,
RailStick=15,
Def_Sentry=19,
Bandage=21,
Salo=22,
Vodka=23,
Yoghurt=26,
X850=25,
X850Grenade=15,
Meat=22,
}

self.genericPickupsConversionTbl= {
13, -- armor
 0, -- health
15, -- rock
11, -- grenade
 6, -- flashbang grenade
 7, -- smoke grenade
16, -- flashlight
17, -- universal ammo
20, -- scuba
21, -- bandage
24,--silencer
}

self.tempUV={};

self.bars={
}

self:InitTexTable(self.txi);
self:InitTexTable(self.tnum);
self:InitTexTable(self.tnum_small);
self:InitTexTable(self.tweapons);
self:InitTexTable(self.wicons);
self:InitTexTable(self.tgrenades);
self:InitTexTable(self.scoreboard);
self:InitTexTable(self.mischolders);
self:InitTexTable(self.pickups);
self:InitTexTable(self.mpKills);

self.temp_txinfo=new(self.txi.health_inside);
self.weapons_alpha=0;

self.new_weapon=1;
self.curr_weapon=1;

self.currnew_weapon=1;
self.currpl_weapon=1;

self.currCrossAirScale=1.0;
self.bBlinkEnergy=0;
self.fBlinkEnergyUpdate=0;
self.bBlinkArmor=0;
self.fBlinkArmorUpdate=0;

self.bBlinkObjective=0;
self.fBlinkObjectiveUpdate=0;

-- mp progress indicator
self.mp_rend=Game:CreateRenderer(); -- note: optimization would be putting all mp textures on one here..
self.mp_scoreboardrend=Game:CreateRenderer(); -- note: optimization would be putting all mp textures on one here..
self.tx_multiplayerhud = System:LoadImage("textures/hud/multiplayer/captureflag_all.dds");
self.tx_mpscoreboard = System:LoadImage("textures/hud/multiplayer/scoreboard.dds");

self.ProgressIndicatorSound=Sound:LoadSound("sounds/items/capture_siren.wav"); -- items/capture_siren |  dong.wav
self.ProgressCapturedSound=Sound:LoadSound("sounds/explosions/mp_flare_horn.wav");
--self.Hero_Fatigued_Brth=Sound:LoadSound("SOUNDS/player/heavy_breathing_loop.wav");

self.PlayCapturedSound=0;
Sound:SetSoundLoop(self.ProgressCapturedSound, 0);
Sound:SetSoundLoop(self.ProgressIndicatorSound, 0);
--Sound:SetSoundLoop(self.Hero_Fatigued_Brth, 0);

self.ProgressPreviousState= -1;
self.ProgressStateTime= 0;
self.ProgressCurrentState= -1;
self.ProgressCurrentStateItem= -1;


self.tmultiplayerhud={
progressi_done={  1, 65, 62, 62},  -- done
progressi_unavailable={ 64, 65, 62, 62},  -- unavailable
progressi_current={129, 65, 62, 62},  -- current
progressi_changing={193, 65, 62, 62},  -- changing
progressi_01={  1,  1, 62, 62},  -- progress 1 
progressi_02={ 65,  1, 62, 62},-- progress 2
progressi_03={129,  1, 62, 62},-- progress 3
progressi_04={193,  1, 62, 62},-- progress 4 
}

self.tmpscoreboard = {
bar_score  = {0, 0, 256, 70}, 
bar_info   = {0, 49, 256, 21}, 
bar_player = {0, 76, 256, 21}, 
bar_bottom = {0, 102, 256, 26}, 
}

self:InitTexTableMP(self.tmultiplayerhud);
self:InitTexTableMP(self.tmpscoreboard);

-- NEW HUD (end..)

self.blindnessvalue=-1;-- to make the player blind when a lightning strikes
self.hitdamagecounter=0; -- [tiago] used to count hit damage for screen fx..
Game:CreateVariable("hud_screendamagefx",1);
Game:CreateVariable("hud_disableradar", 0);
Game:CreateVariable("hud_fadeamount",1);

self.blinding = 0;

--System:Log("self.damage_icon_lr="..type(self.damage_icon_lr));
Game:CreateVariable("hud_panoramic",0);
Game:CreateVariable("hud_panoramic_height",100);
Game:CreateVariable("hud_crosshair",1);

self.EarRinging=Sound:LoadSound("Sounds/Player/deafnessLP.wav");
Sound:SetSoundLoop(self.EarRinging, 1);
Sound:RemoveFromScaleGroup(self.EarRinging, SOUNDSCALE_DEAFNESS);

local sx=5;
local sy=395;
local sw=108;
local sh=108/2;
local s={
{x=sx+1,y=sy,u=0,v=0},
{x=sx+1,y=sy+sh,u=0,v=1},
{x=sx+sw/2,y=sy,u=0.5,v=0},
{x=sx+sw/2,y=sy+sh,u=0.5,v=1},
{x=sx+sw-1,y=sy,u=1,v=0},
{x=sx+sw-1,y=sy+sh,u=1,v=1},
}
local h={
{x=11+1,y=525,u=0,v=0},
{x=10+1,y=557,u=0,v=0.5},
{x=42,y=525,u=0.5,v=0},
{x=42,y=557,u=0.5,v=0.5},
{x=74-1,y=525,u=1,v=0},
{x=74-1,y=557,u=1,v=0.5},
}
local a={
{x=10+1,y=557,u=0,v=0.5},
{x=10+1,y=589,u=0,v=1},
{x=42,y=557,u=0.5,v=0.5},
{x=42,y=589,u=0.5,v=1},
{x=74-1,y=557,u=1,v=0.5},
{x=74-1,y=589,u=1,v=1},
}

-- tiago: initialize 
self.radar_transparency = 1.0;
self.stamina_level = 64.5;
self.breath_level =64.5;
self.radarObjective = nil;

ScoreBoardManager.SetVisible(0);

-- create radar stuff...
Game:CreateVariable("g_RadarRange",200);
Game:CreateVariable("g_RadarRangeOutdoor", 200);
Game:CreateVariable("g_RadarRangeIndoor",50);
Game:CreateVariable("g_RadarRangeChangeSpeed",3);
Game:CreateVariable("g_SuspenseRange",50);
Game:CreateVariable("g_NearSuspenseRangeFactor",0.25);
Game:CreateVariable("g_ShowConcentrationStats",0);
Game:CreateVariable("g_ConcentrationAmbientVolume",0.7);
Game:CreateVariable("g_ConcentrationMissionVolume",1.0);
Game:CreateVariable("g_ConcentrationNormalVolume",0.9);
Game:CreateVariable("g_ConcentrationFadeInTime",3);
Game:CreateVariable("g_ConcentrationFadeOutTime",5);

self.ProgressPreviousState=-1;
self.ProgressStateTime=0;
self.ProgressCurrentState=-1;
self.ProgressCurrentStateItem= -1;

self.NewMessageSnd=Sound:LoadSound("sounds/items/lock.wav");

-- MIXER: CLIENT SIDE ON-LEVEL-LOAD VARIABLES CONFIGURATION
local level_path = "";
for i, val in Game:GetModsList() do
	if (val.CurrentMod) then
		level_path = val.Folder.."/";
		break;
	end
end

-- set default settings:
setglobal("e_detail_texture_min_fov",0.7);

-- now try to override it with cfg vars
local level_cfg = openfile(level_path.."Levels/"..Game:GetLevelName().."/level.cfg", "r");

if (level_cfg) then
	local cfgline = "";
	while(cfgline) do
		cfgline = read(level_cfg, "*l");
		if (cfgline) then
			--- do some
			local cfgpos = strfind(cfgline,"//");
			if (cfgpos) then
				-- ignore comments
			else
				cfgpos = strfind(cfgline," ");
				if (cfgpos) then
					local cfgline2 = strsub(cfgline,cfgpos+1);
					cfgline = strsub(cfgline,1,cfgpos-1);
					if (cfgline) and (cfgline2) then
						setglobal(cfgline,cfgline2);
					end
				end
			end
		end
	end
	closefile(level_cfg);
end
---

self.pPickupsTbl={};
self.pPickupsCount=0;

self.vColor= { r=0, g=0, b=0, a=0 };

self.labeltime = nil;

self.sGameType=strupper(getglobal("g_GameType"));
if (self.sGameType=="FFAPRO") then self.sGameType="FFA" end;

end

-----
-- plays some mp specific sound
-----
function Hud:PlayMultiplayerHitSound()
end
----
-- Render hud texture icon
----
function Hud:DrawElement(x,y,element,r,g,b,a)
if (element) then
if (self.f_value ~= 1) then
self.rend:PushQuad(x,y,element.size.w*self.hd_sc_mult,element.size.h,element,r,g,b,self.f_value);
else
self.rend:PushQuad(x,y,element.size.w*self.hd_sc_mult,element.size.h,element,r,g,b, a);
end
end
end

---
-- multiplayer hud specific
---

-- InitTexTableMP: initialize mp hud texture, texture coordinates offsets

function Hud:InitTexTableMP(tt)
local tw,th=256,128;
local offsetU, offsetV=2/256.0, 2/128.0;

for i,val in tt do
val.size={}
val.size.w=val[3];
val.size.h=val[4];
val[1]=val[1]/tw+offsetU;
val[2]=val[2]/th+offsetV;
val[3]=val[1]+(val[3]/tw)-offsetU;
val[4]=val[2]+(val[4]/th)-offsetV;
end
end

-- DrawQuadMP: renders element/quad from texture (mp only)

function Hud:DrawQuadMP(x, y, scalex, scaley, val, texi, r, g, b, a, flipu, flipv)
local t=new(texi);

merge_no_copy(t,texi);
texi=t;

local scale=(val/100);
if(scale>100)then scale=100; end
local diff=1-scale;

if(diff~=0 and flipu~=1) then
local uoffs=abs(texi[3]-texi[1])*diff;
texi[1]=texi[1]+uoffs;
local worig=texi.size.w;
texi.size.w=(worig*scale);
x=x+(worig*diff);
end

if(diff~=0 and flipu==1)then
local uoffs=abs(texi[3]-texi[1])*diff;
texi[3]=texi[3]-uoffs;
local worig=texi.size.w;
texi.size.w=(worig*scale);
end

if(flipv==1)then  
texi[2],texi[4]=texi[4],texi[2];
end

if(flipu==1)then
  texi[1],texi[3]=texi[3],texi[1];
end

-- always center scaling..
if(self.f_value < 1.0) then
self.mp_rend:PushQuad(x-texi.size.w*scalex*0.5,y-texi.size.h*scaley*0.5,texi.size.w*scalex,texi.size.h*scaley,texi,r,g,b,self.f_value);
else
self.mp_rend:PushQuad(x-texi.size.w*scalex*0.5,y-texi.size.h*scaley*0.5,texi.size.w*scalex,texi.size.h*scaley,texi,r,g,b, a);
end
end

-- DrawScoreBoard: renders element/quad from texture (mp only)

function Hud:DrawScoreBoard(x, y, scalex, scaley, val, texi, r, g, b, a, flipu, flipv)
-- make sure all ok..
if(not texi or not self.mp_scoreboardrend or not self.tx_mpscoreboard) then
return;
end

local t=new(texi);

merge_no_copy(t, texi);
texi=t;

local scale=(val/100);
if(scale>100)then scale=100; end
local diff=1-scale;

if(diff~=0 and flipu~=1) then
local uoffs=abs(texi[3]-texi[1])*diff;
texi[1]=texi[1]+uoffs;
local worig=texi.size.w;
texi.size.w=(worig*scale);
x=x+(worig*diff);
end

if(diff~=0 and flipu==1)then
local uoffs=abs(texi[3]-texi[1])*diff;
texi[3]=texi[3]-uoffs;
local worig=texi.size.w;
texi.size.w=(worig*scale);
end

if(flipv==1)then  
texi[2],texi[4]=texi[4],texi[2];
end

if(flipu==1)then
  texi[1],texi[3]=texi[3],texi[1];
end

self.mp_scoreboardrend:PushQuad(x, y, texi.size.w*scalex, texi.size.h*scaley, texi, r, g, b, a);
self.mp_scoreboardrend:Draw(self.tx_mpscoreboard);
end

-- Callback for sorting pickup items

function pickup_compare(a,b)
if(a and b) then
if(a.Lifetime>b.Lifetime)then 
return 1
end
end
end

-- Add a pickup to hud pickup list

function Hud:AddPickup( pick_type, pick_amount)
local lifetime=1.0;
-- check for same timed messages, increase recent ones timming for correct sorting
if(self.pPickupsTbl and self.pPickupsTbl[count(self.pPickupsTbl)] and self.pPickupsTbl[1].Lifetime) then
if(self.pPickupsTbl[1].Lifetime>=1.0) then
lifetime=self.pPickupsTbl[1].Lifetime+0.01; 
end
end

-- then add pickup to list
self.pPickupsTbl[count(self.pPickupsTbl)+1]={ 
Type= pick_type, 
Amount= pick_amount, 
Position= 0,
Lifetime= lifetime,
};

if(pick_amount~=-1) then
-- scale crossair
self.currCrossAirScale=5.0;

-- blink energy
if(pick_type==0) then
self.bBlinkEnergy=1
end

-- blink armor
if(pick_type==13) then
self.bBlinkArmor=1;
end
end

-- sort table items by lifetime
sort(self.pPickupsTbl,%pickup_compare);

-- remove old pickups
while (count(self.pPickupsTbl)>4) do
self.pPickupsTbl[count(self.pPickupsTbl)]=nil;
end
end

-- Convert from ammo type string, into apropriate hud icon id

function Hud:AmmoPickupsConversion(ammo_type)
local retVal=0;
if(ammo_type) then
retVal=self.ammoPickupsConversionTbl[ammo_type];
end

return retVal;
end

-- Convert from pickup type value, into apropriate hud icon id

function Hud:GenericPickupsConversion(pick_type)
local retVal=0;
if(pick_type) then
retVal=self.genericPickupsConversionTbl[pick_type];
end

return retVal;
end

-- Process and render all pickups

function Hud:DrawPickups()
local fPos=0;
-- check for same type pickups
if(self.pPickupsTbl and type(self.pPickupsTbl)=="table") then
for i, Pickup in self.pPickupsTbl do
if(Pickup.Lifetime>0.0) then
local lerp=_frametime*20;
if(lerp>1.0) then
lerp=1;
end

local fLifetime=10*Pickup.Lifetime*Pickup.Lifetime;
if(fLifetime>1.0) then
fLifetime=1.0;
end

Pickup.Position=Pickup.Position+(fPos-Pickup.Position)*lerp;
if self.pPickupsTbl[i].Type then
self:DrawElement(720-Pickup.Position, 500, self.pickups[self.pPickupsTbl[i].Type+1],  1, 1, 1,fLifetime);
end

if(Pickup.Amount==-1) then
-- not available
self:DrawElement(720-Pickup.Position, 500, self.pickups[19],  1, 1, 1, fLifetime*0.9);
elseif(Pickup.Amount>1) then
   -- item count
self:DrawNumber(0, 3,730-Pickup.Position, 500+17, Pickup.Amount, 1,1,1, fLifetime);
else
-- just one item
self:DrawNumber(0, 3,730-Pickup.Position, 500+17, 1, 1,1,1, fLifetime);
end

Pickup.Lifetime=Pickup.Lifetime-_frametime*0.25;

-- clamp 
if(Pickup.Lifetime<0.0) then
Pickup.Lifetime=0.0;
end

fPos=fPos+40;

else
-- remove old pickups
local j=i;
local k=count(self.pPickupsTbl);

while (j <= k) do
self.pPickupsTbl[j]=self.pPickupsTbl[j+1];
j=j+1;
end
end
end
end

-- display flashlight
if (_localplayer.FlashLightActive==1) then
	self:DrawElement(765, 501, self.txi.flashlight_on);
end
end

-- Display picked up icons

function Hud:DrawItems(player)
local x=400;
local y=510;

local itemCount=0;

-- count total item numbers
for i,val in player.keycards do
if (val>=1 and val<=4) then
itemCount=itemCount+1;
end
end

for i,val in player.explosives do
if (val==1) then
itemCount=itemCount+1;
end
end

for i, val in player.objects do
if(val==1) then
itemCount=itemCount+1;
end
end

-- always center items..
x=x-itemCount*20;

-- render keycards
for i,val in player.keycards do
if (val==1) then
%System:DrawImageColor(self.KeyItem[i], x, y, 40, 20, 4,1,1,1, self.f_value);
x=x+40;
end
end

-- render object items
for i,val in player.objects do
if (val==1) then
-- items are: 1: pda, 2:bombfuse 3: pda batery, 4:undefined, etc..
x=x+8;
%System:DrawImageColor(self.ObjectItem[i+1], x, y-6, 32, 32, 4,1,1,1,self.f_value);
x=x+40;
end
end

-- render explosives
for i,val in player.explosives do
if (val==1) then
%System:DrawImageColor(self.ObjectItem[1], x, y, 40, 20, 4,1,1,1,self.f_value);
x=x+40;
end
end

end

-- Display labels

function Hud:DrawLabel()
	if (self.label) then
		if (self.label == "use_hint") and (self.cis_use_hint) then
			local f_sze = 32 - 20 * abs(mod(_time,1)-0.5);
			%System:DrawImageColor(Hud.cis_use_hint, 400-f_sze*0.5, 351-f_sze*0.5, f_sze, f_sze, 4,1,1,1,Hud.f_value);
		elseif (self.label == "carry_hint") and (self.cis_carry_hint) then
			local f_sze = 200 - 10 * abs(mod(_time,1)-0.5);
			local f_szy = 32 - 7 * abs(mod(_time,1)-0.5);
			if (_localplayer) and (_localplayer.items) and (_localplayer.items.gr_item_picktime) then
				if (_time - _localplayer.items.gr_item_picktime < 0.4) then
					f_sze = f_sze * (_time - _localplayer.items.gr_item_picktime) * 2.5;
					f_szy = f_szy * (_time - _localplayer.items.gr_item_picktime) * 2.5;
				end
			end
			%System:DrawImageColor(Hud.cis_carry_hint, 400-f_sze*0.5, 560-f_szy*0.5, f_sze, f_szy, 4,1,1,1,Hud.f_value);
		else
			%Game:SetHUDFont("default", "default");
			local strsizex,strsizey = Game:GetHudStringSize(self.label, 12, 12);
			%Game:WriteHudString(400-strsizex*0.5, 350, self.label, self.color.r, self.color.g, self.color.b, 1, 12, 12, 0);
		end
	end

	--if labeltime is specified dont remove immediately the label, but wait for the time specified.
	if (self.labeltime and self.labeltime>0) then
		self.labeltime = self.labeltime - _frametime;
	else
		self.label=nil;
		self.labeltime=nil;
	end
end

-- Display a number

function Hud:DrawNumber(font, ndigits,x,y,number,r,g,b,a)
if(number>999) then number=999; end
local t=mod(number,100);
local unit=mod(number,10);
local hun=(number-t)/100;
local dec=(t-unit)/10;
if(ndigits>=3)then
if(font==1) then 
self:DrawElement(x, y,self.tnum[hun],r,g,b,a);
x=x+9;
else
if(hun>0) then
self:DrawElement(x, y,self.tnum_small[hun],r,g,b,a);
end
x=x+5;
end
end
if(ndigits>=2)then
if(font==1) then
self:DrawElement(x, y,self.tnum[dec],r,g,b,a);
x=x+9;
else
self:DrawElement(x, y,self.tnum_small[dec],r,g,b,a);
x=x+5;
end
end

if(font==1) then
self:DrawElement(x, y,self.tnum[unit],r,g,b,a);
else
self:DrawElement(x, y,self.tnum_small[unit],r,g,b,a);
end
end

-- Get Nearest INT by Romochka
function Hud:GetNearestInt(value)
	local nINT = floor(value);
	local fRazn = value - nINT;
	if (fRazn >= 0.5) then
		return nINT+1;
	else
		return nINT;
	end
end

-- Display energy/armor bars: OPTIMIZED NOW!

function Hud:DrawEnergy(player)
if (player.entity_type ~="spectator") then
local health=player.cnt.health/player.cnt.max_health*100;
local armor=player.cnt.armor/player.cnt.max_armor*100;
local stamina=self.staminalevel*100;
local scuba_gear;

if (player.cnt.underwater > 0) and (player.items.scubagear) and (player.items.scubagear > 0) then
	stamina = self:ClampToRange(player.items.scubagear,0,100);
	scuba_gear = 1;
end

-- interpolate values
self.curr_health=self:ClampToRange(self.curr_health + (health-self.curr_health)*_frametime*4,1,100);
self.curr_armor=self:ClampToRange(self.curr_armor+(armor-self.curr_armor)*_frametime*4,0,100);
self.curr_stamina=self:ClampToRange(self.curr_stamina+(stamina-self.curr_stamina)*_frametime*4,0,100);

-- update energy blinking
if(self.bBlinkEnergy>=1) then
self.fBlinkEnergyUpdate = self.fBlinkEnergyUpdate + 5*_frametime;
if(self.fBlinkEnergyUpdate>1) then
self.fBlinkEnergyUpdate=0;
self.bBlinkEnergy=self.bBlinkEnergy+1;
if(self.bBlinkEnergy>12) then
self.bBlinkEnergy=0;
end
end
else
self.fBlinkEnergyUpdate=0;
end
--local hadjf = self.hdadjust*0.432; --unused i think

if (self.curr_stamina>0.01) then
	if (scuba_gear) then
		self:DrawGauge(574+self.hdadjust*0.48,567, self.curr_stamina, 70, self.txi.health_inside, 0.9, 0.9, 1, 1, 0, 0);
	else
		self:DrawGauge(574+self.hdadjust*0.48,567, self.curr_stamina, 70, self.txi.health_inside, 0.258, 0.49, 0.807, 1, 0, 0);
		-- Mixer: Fatigued Breath Feature
		--if (stamina < 45) and (self.Hero_Fatigued_Brth) then
		--	if (Sound:IsPlaying(self.Hero_Fatigued_Brth)==nil) then
		--		if (player.cnt.underwater > 0) then
		--		else
		--			Sound:PlaySound(self.Hero_Fatigued_Brth);
		--		end
		--	end
		--	if (self.curr_stamina~=stamina) then
		--		Sound:SetSoundVolume(self.Hero_Fatigued_Brth,(45-stamina)*1.7);
		--	end
		--end
	end
end

-- mixer: cis hud: bars holder
%System:DrawImageColor(self.cis_energy_bg, 561+self.hdadjust*0.55,538, 238*self.hd_sc_mult, 49, 4,1,1,1, self.f_value);

if (player.cnt.health>0) then
-- display energy bars
if(health<30) then
self.curr_healthAlpha=self.curr_healthAlpha+_frametime*2;
if(self.curr_healthAlpha>1.0) then
self.curr_healthAlpha=0;
end
else
self.curr_healthAlpha=1;
end

self.vColor.r=0.709+self.fBlinkEnergyUpdate;
self.vColor.g=0.219+self.fBlinkEnergyUpdate;
self.vColor.b=0.233+self.fBlinkEnergyUpdate;

-- clamp color to 1
if (self.vColor.r>1.0) then self.vColor.r=1; end
if (self.vColor.g>1.0) then self.vColor.g=1; end
if (self.vColor.b>1.0) then self.vColor.b=1; end

-- cis hud:

Game:SetHUDFont("radiosta", "binozoom");
health = Hud:GetNearestInt(self.curr_health);
local st_txt_x, st_txt_y = Game:GetHudStringSize(health, 22*self.hd_sc_mult, 22);
%Game:WriteHudString(602-st_txt_x/2+(self.hdadjust*0.43), 546, health, self.vColor.r, self.vColor.g,  self.vColor.b, 1*self.curr_healthAlpha, 22*self.hd_sc_mult, 22);
--end
-- update armor blinking
if(self.bBlinkArmor>=1) then
self.fBlinkArmorUpdate = self.fBlinkArmorUpdate + 5*_frametime;
if(self.fBlinkArmorUpdate>1) then
self.fBlinkArmorUpdate=0;

self.bBlinkArmor=self.bBlinkArmor+1;
if (self.bBlinkArmor>12) then
self.bBlinkArmor=0;
end
end
else
self.fBlinkArmorUpdate=0;
end

if (self.curr_armor>0.01) then

if (_localplayer.items.kevlarhelmet) then
	self.vColor.g=0.7+self.fBlinkArmorUpdate;
	self.vColor.r=0.2;
	self.vColor.b=0.2;
else
	self.vColor.r=0.776+self.fBlinkArmorUpdate;
	self.vColor.g=0.541+self.fBlinkArmorUpdate;
	self.vColor.b=0.258+self.fBlinkArmorUpdate;

	-- clamp color to 1
	if(self.vColor.r>1.0) then self.vColor.r=1; end
	if(self.vColor.b>1.0) then self.vColor.b=1; end
end
if(self.vColor.g>1.0) then self.vColor.g=1; end

armor = Hud:GetNearestInt(self.curr_armor);
local st_txt_x, st_txt_y = Game:GetHudStringSize(armor, 26*self.hd_sc_mult, 26);
%Game:WriteHudString(678-st_txt_x/2+(self.hdadjust*0.15), 546,armor,self.vColor.r, self.vColor.g,  self.vColor.b, 1, 22*self.hd_sc_mult, 22);

end
end -- don't show armor if cnt health is 0!

end end

-- Display ammo 
-------

function Hud:DrawAmmo(player)

-- display ammo bar holder
--self:DrawElement(696, 541, self.txi.ammo_bar);

local amx = 733 - self.hdadjust * 0.2;

-- display ammo amount
if (player.fireparams) then
	if (player.fireparams.AmmoType~="Unlimited") then
		if (player.fireparams.railed) and (player.fireparams.railed==2) then
			-- do nothing at now
		elseif (player.fireparams.bullets_per_clip) and (player.cnt.ammo_in_clip<=player.fireparams.bullets_per_clip*0.3) then
			if (player.fireparams.vehicleWeapon == nil) then
				self:DrawNumber(1, 3,amx,551,player.cnt.ammo_in_clip,1,0,0,1);
				self:DrawNumber(1, 3,amx,564,player.cnt.ammo);
			else
				self:DrawNumber(1, 3,amx,557,player.cnt.ammo_in_clip,1,0,0,1);
			end
		else
			if (player.fireparams.vehicleWeapon == nil) then
				self:DrawNumber(1, 3,amx,551,player.cnt.ammo_in_clip);
				self:DrawNumber(1, 3,amx,564,player.cnt.ammo,1,1,1,0.65);
			else
				self:DrawNumber(1, 3,amx,557,player.cnt.ammo_in_clip);
			end
		end
	end
end

-- display firemode
if (player.fireparams and player.fireparams.hud_icon) then
	self:DrawElement(711-self.hdadjusty*0.8,558,self.wicons[player.fireparams.hud_icon]);
	if (player.fireparams.burst) then
		%Game:WriteHudString(712-self.hdadjusty*0.8, 560,player.fireparams.burst,0.2,1,0.2, 1, 18*self.hd_sc_mult, 18);
	end
end

-- display grenades slot
if (self.DisplayControl.bShowProjectiles == 1) then
local ngrenades;
if (player.cnt.grenadetype>1) then
	ngrenades=player.cnt.numofgrenades;
end
local class=GrenadesClasses[player.cnt.grenadetype];
self:DrawGrenadeSlot(player,764-self.hdadjust*0.26,547,ngrenades,class);
end
end

-- Set current radar range

function Hud:SetRadarRange(Range)
self.DestinationRadarRange=Range;
end

-- Set current radar player item color

function Hud:SetPlayerColor( player,r,g,b,a )
if (player.Color == nil) then
player.Color = {};
end
player.Color.r = r;
player.Color.g = g;
player.Color.b = b;
player.Color.a = a;
end

-- Resets radar enemies state

function Hud:ResetRadar(player)
if(Game:IsMultiplayer() and player and Hud.tblPlayers) then

local LocalPlayer=_localplayer;
if(LocalPlayer and LocalPlayer.GetPos) then

-- empty table
for i, Player in Hud.tblPlayers do
Hud.tblPlayers[i] = nil;
end
-- enemy data..
local LocalPlayerPos=LocalPlayer:GetPos();
Game:GetPlayerEntitiesInRadius(LocalPlayerPos, 9999999999999999, Hud.tblPlayers );

if(player==LocalPlayer) then
-- if is local player, then reset entire list
for i, Player in Hud.tblPlayers do
if(Player.pEntity and Player.pEntity.id) then
local pEntity=System:GetEntity(Player.pEntity.id);
if(pEntity) then
pEntity.bShowOnRadar=nil;
end
end
end

else
-- reset guy that suicided/killed
for i, Player in Hud.tblPlayers do
if(Player.pEntity and Player.pEntity.id and player.id == Player.pEntity.id) then
local pEntity=System:GetEntity(Player.pEntity.id);
if(pEntity) then
pEntity.bShowOnRadar=nil;
end
end
end
end

end

end

end

-- Display radar

function Hud:DrawRadar(x,y,w,h)
	if (ClientStuff.vlayers:IsActive("WeaponScope")) and (not _localplayer.cnt.weapon.AimMode) then return; end
	if (hud_disableradar == "1") then return; end

	local LocalPlayerPos=_localplayer:GetPos();
	local FrameTime=_frametime;

	if (System:IsPointIndoors(LocalPlayerPos)) then
		Hud:SetRadarRange(tonumber(g_RadarRangeIndoor));
	else
		Hud:SetRadarRange(tonumber(g_RadarRangeOutdoor));
	end

	local grrange_tmp = tonumber(g_RadarRange);

	-- adjust range
	if (self.DestinationRadarRange and (tonumber(self.DestinationRadarRange)~=grrange_tmp) and (FrameTime<1) and (tonumber(g_RadarRangeChangeSpeed)>0)) then
		g_RadarRange=grrange_tmp+(tonumber(self.DestinationRadarRange)-grrange_tmp)*FrameTime*tonumber(g_RadarRangeChangeSpeed);
		g_SuspenseRange=g_RadarRange;
	end

	Hud.tblPlayers = {};
	Hud.cis_specop = nil;

	-- enemy data..
	Game:GetPlayerEntitiesInRadius(LocalPlayerPos, grrange_tmp*1.2, Hud.tblPlayers);

-- Used for setting moods in DynamicMusic.
self.EnemyInSuspense = 0;
self.EnemyInNearSuspense = 0;
self.EnemyAlerted = 0;
local SuspenseRange2=tonumber(g_SuspenseRange)*tonumber(g_SuspenseRange);
local NearSuspenseRange2=SuspenseRange2*tonumber(g_NearSuspenseRangeFactor)*tonumber(g_NearSuspenseRangeFactor);

-- radar fade in/out                        
local alpha_step=0.5;
Hud.radar_transparency = Hud.radar_transparency - alpha_step*FrameTime;          
if(Hud.radar_transparency<0.0) then
Hud.radar_transparency=0.0;
end

if (Hud.tblPlayers and type(Hud.tblPlayers)=="table") then
for i, Player in Hud.tblPlayers do
if (Player.pEntity==_localplayer) then -- is player ? 
Hud:SetPlayerColor( Player,0,0.9,0.8,Hud.radar_transparency );

elseif ( Player.pEntity.Properties.species==_localplayer.Properties.species) then--is enemy of friend ?
  -- radar fade in
          local alpha_step=1.0;                                             
          Hud.radar_transparency = Hud.radar_transparency + alpha_step*_frametime;                  
          if(Hud.radar_transparency>1.0) then
            Hud.radar_transparency=1.0;
          end

-- check if in mp mode..
if (Game:IsMultiplayer()) then
local LocalPlayerTeam=Game:GetEntityTeam(_localplayer.id);
local team=Game:GetEntityTeam(Player.pEntity.id);

if (team and LocalPlayerTeam) and (self.sGameType~="FFA") then

if (team=="red") then
Hud:SetPlayerColor( Player,1,0,0, Hud.radar_transparency);
elseif (team=="blue") then
Hud:SetPlayerColor( Player,0,0,1, Hud.radar_transparency);
else
Hud:SetPlayerColor( Player, 1, 1, 1, Hud.radar_transparency);
end

-- not from same team, then only display entities tagged by motion tracker
if(LocalPlayerTeam~=team and (not Player.pEntity.bShowOnRadar)) then
Hud.tblPlayers[i]=nil;
end
else
-- then only display entities tagged by motion tracker
if (Player.pEntity.bShowOnRadar) then

if (Player.pEntity.isvillager) then
	Hud:SetPlayerColor( Player,0,1,0, Hud.radar_transparency);
	if (Player.pEntity.i_am_atrader) then
		if (Player.fDistance2 <= 9) then -- 9 is 3*3 (3 is range between player and trader)
			if (not Hud.cis_specop) then
				Hud.cis_specop = 999;
				if (Hud.buysign_top > 59) then
					Hud.buysign_top = Hud.buysign_top - _frametime * 640;
					if (Hud.buysign_top < 59) then
						Hud.buysign_top = 59;
					end
				end
				if (not Hud.cis_known_buy) then
					%Game:SetHUDFont("hud", "ammo");
					local ns_x,ns_y = %Game:GetHudStringSize("@su_villtmsg O, @su_villtmsg2", 20, 20);
					ns_x=400-(ns_x*0.5);
					%Game:WriteHudString(ns_x,494,"@su_villtmsg "..strupper(Game.cis_SpOptionKey)..", @su_villtmsg2", 1, 1, 1, 1, 20,20);
				end
				self:DrawElement(727+Hud.hdadjusty*1.5, Hud.buysign_top, self.mischolders.money_bag); -- 59
			end
			if (Player.fDistance2 < Hud.cis_specop) then
				-- choose the nearest of nearby traders
				Hud.cis_specop = Player.fDistance2 * 1;
				Hud.trdname = Player.pEntity:GetName();
			end
		end
	end
else
	Hud:SetPlayerColor( Player,1,0,0, Hud.radar_transparency);
end

else
Hud.tblPlayers[i]=nil;
end
end
else
Hud:SetPlayerColor( Player, 1.0, 0.8, 1.0, Hud.radar_transparency);
end

elseif (Player.pEntity.Properties.bAffectSOM==1) then          
-- only display entities tagged by motion tracker
if (Player.pEntity.bShowOnRadar) then

if (Player.fDistance2<SuspenseRange2) then
	self.EnemyInSuspense=1;
end
if (Player.fDistance2<NearSuspenseRange2) then
	self.EnemyInNearSuspense=1;
end

        -- radar fade in
        local alpha_step=1.0;                                             
        Hud.radar_transparency = Hud.radar_transparency + alpha_step*FrameTime;                  
        if(Hud.radar_transparency>1.0) then
            Hud.radar_transparency=1.0;
        end
        
    Hud:SetPlayerColor( Player,0,1,0,Hud.radar_transparency ); -- default is idle.

-- if saw player, then always in combat mode
if(Player.pEntity.bEnemyInCombat==1) then
Hud:SetPlayerColor( Player,1,0,0,Hud.radar_transparency );
else
local Target=AI:GetAttentionTargetOf(Player.pEntity.id);
local TargetType=type(Target);
Player.pEntity.bEnemyInCombat = 0;-- set default

if ((TargetType=="table") and (Target==_localplayer)) then
Hud:SetPlayerColor( Player,1,0,0,Hud.radar_transparency ); -- combat
self.EnemyAlerted = 1;
Player.pEntity.bEnemyInCombat = 1; -- enemy saw player
elseif(TargetType=="number") then
 
 if(Target==AIOBJECT_DUMMY) then
 
 if(Player.pEntity.Behaviour.JOB==nil) then
Hud:SetPlayerColor( Player,1,0.5,0,Hud.radar_transparency );-- threatened
self.EnemyAlerted = 1;
  else
  Hud:SetPlayerColor( Player,0,1,0,Hud.radar_transparency );-- doing something
  end
  
elseif(Target==AIOBJECT_NONE) then
Hud:SetPlayerColor( Player,0,1,0,Hud.radar_transparency );-- doing something
end

else
-- no target ?
if(Player.pEntity.Behaviour.JOB==nil) then
Hud:SetPlayerColor( Player,1,1,0,Hud.radar_transparency ); -- heared something
else
Hud:SetPlayerColor( Player,0,1,0,Hud.radar_transparency ); -- doing something
end
end
end

else
Hud.tblPlayers[i]=nil;
end

else
Hud.tblPlayers[i]=nil;
end
end

    -- get/set radar objective    
local RadarPosition= "NoObjective";

-- update objective blinking
if(self.bBlinkObjective>=1) then
self.fBlinkObjectiveUpdate = self.fBlinkObjectiveUpdate + 5*_frametime;
if(self.fBlinkObjectiveUpdate>1) then
self.fBlinkObjectiveUpdate=0;
self.bBlinkObjective=self.bBlinkObjective+1;
if(self.bBlinkObjective>18) then
self.bBlinkObjective=0;
end
end
else
self.fBlinkObjectiveUpdate=0;
end

-- render radar

if (Hud.cis_mp_talker) then
	local t_ent = System:GetEntity(Hud.cis_mp_talker.p_id);
	if (t_ent) and (t_ent.GetPos) then
		Hud.cis_mp_talker.pos = t_ent:GetPos();
	end
	RadarPosition= format("%g %g %g", Hud.cis_mp_talker.pos.x, Hud.cis_mp_talker.pos.y,Hud.cis_mp_talker.pos.z);
	if (Game.AddCommand) then
		Game:DrawRadar(x+self.hdadjusty*2,y-self.hdadjusty,w,h,grrange_tmp,self.Radar,self.RadarMask,self.RadarPlayerIcon,self.RadarEnemyInRangeIcon,self.RadarEnemyOutRangeIcon,self.RadarSoundIcon,self.missioncheckboxcomp,Hud.tblPlayers,RadarPosition);
	else
		Game:DrawRadar(x+self.hdadjusty*2,y-self.hdadjusty,w,h,grrange_tmp,self.Radar,self.RadarMask,self.RadarPlayerIcon,self.RadarEnemyInRangeIcon,self.RadarEnemyOutRangeIcon,self.RadarSoundIcon,Hud.tblPlayers,RadarPosition);
	end
	if (Hud.cis_mp_talker.tme < _time) then
		Hud.cis_mp_talker = nil;
	end
else
	if (Hud.radarObjective~=nil and (self.bBlinkObjective==0 or self.fBlinkObjectiveUpdate>0.5)) then
		RadarPosition= format("%g %g %g", Hud.radarObjective.x, Hud.radarObjective.y,Hud.radarObjective.z);
	end
	if (Game.AddCommand) then
		Game:DrawRadar(x+self.hdadjusty*2,y-self.hdadjusty,w,h,grrange_tmp,self.Radar,self.RadarMask,self.RadarPlayerIcon,self.RadarEnemyInRangeIcon,self.RadarEnemyOutRangeIcon,self.RadarSoundIcon,self.RadarObjectiveIcon,Hud.tblPlayers,RadarPosition);
	else
		Game:DrawRadar(x+self.hdadjusty*2,y-self.hdadjusty,w,h,grrange_tmp,self.Radar,self.RadarMask,self.RadarPlayerIcon,self.RadarEnemyInRangeIcon,self.RadarEnemyOutRangeIcon,self.RadarSoundIcon,Hud.tblPlayers,RadarPosition);
	end
end

end
end

-- Display stealthmeter

function Hud:DrawStealthMeter(x,y)
if(self.DisplayControl.bShowEnergyMeter==0 or self.DisplayControl.fBlinkUpdateRadar>0.5) then
return;
end
                
local color=self.color_blue;

if (Hud.cis_sneakval<5) then
Hud.cis_sneakval=Hud.cis_sneakval*10;
elseif (Hud.cis_sneakval<10) then
Hud.cis_sneakval=((Hud.cis_sneakval-5)/5)*25+50;
color=self.color_yellow;
elseif (Hud.cis_sneakval>110) then
Hud.cis_sneakval=100;
color=self.color_red;
else
Hud.cis_sneakval=75;
color=self.color_red;
end

local hud_adj = self.hdadjusty*2;
-- interpolate values
self.curr_stealth=self:ClampToRange(self.curr_stealth+(Hud.cis_sneakval-self.curr_stealth)*_frametime*4,0,100);
self:DrawElement(5+hud_adj, 516, self.txi.shape_stealth_left, 1, 1, 1, 0.9);
if self.DisplayControl.bShowRadar ~= 0 then
self:DrawElement(91.5+hud_adj*1.4, 516, self.txi.shape_stealth_right,1, 1, 1, 0.9);  end
if(self.curr_stealth>0.01) then
self:DrawGauge(5+hud_adj*1.12,517,100,self.curr_stealth,self.txi.sealth_inside_left, 1, 1, 1, 0.75, 0, 0);
if self.DisplayControl.bShowRadar ~= 0 then
self:DrawGauge(94.5+hud_adj*1.4,517,100,self.curr_stealth,self.txi.sealth_inside_right, 1, 1, 1, 0.75, 0, 0); end
end
end

-- Display an icon

function Hud:DrawGauge(x,y,hval, vval, texi,r,g,b,a,flipu, flipv)
local t=self.temp_txinfo;
merge_no_copy(t,texi);
texi=t;
local hscale=(hval/100);
local vscale=(vval/100);
if(hscale>100)then hscale=100; end
if(vscale>100)then vscale=100; end
local diff=1-hscale;
local vdiff=1-vscale;

if((diff~=0 or vdiff~=0) and flipu~=1) then
local uoffs=abs(texi[3]-texi[1])*diff;
texi[1]=texi[1]+uoffs;

local voffs=abs(texi[4]-texi[2])*vdiff;
texi[2]=texi[2]+voffs;

local worig=texi.size.w;
local horig=texi.size.h;

texi.size.w=(worig*hscale);
texi.size.h=(horig*vscale);

x=x+(worig*diff*self.hd_sc_mult);
y=y+(horig*vdiff);
end
  
    if((diff~=0 or vdiff~=0) and flipu==1)then
local uoffs=abs(texi[3]-texi[1])*diff;
local voffs=abs(texi[4]-texi[2])*vdiff;

texi[3]=texi[3]-uoffs;
texi[4]=texi[4]-voffs;

local worig=texi.size.w;
local horig=texi.size.h;

texi.size.w=(worig*hscale);
texi.size.h=(horig*vscale); 
    end

if(flipv==1)then  
texi[2],texi[4]=texi[4],texi[2];
end
if(flipu==1)then
  texi[1],texi[3]=texi[3],texi[1];
end

self:DrawElement(x,y,texi,r,g,b,a);
end

-- Display a single color bar

function Hud:DrawBar(x,y,w,h,val,r,g,b,a)
local realh=h*(val/100);
local realy=y+(h-realh);

if(self.f_value < 1.0) then
self.rend:PushQuad(x,realy,w,realh,self.txi.white_dot,r,g,b,self.f_value);
else
self.rend:PushQuad(x,realy,w,realh,self.txi.white_dot,r,g,b, a);
end
end

-- Display cross-air and damage direction indicators

function Hud:DrawCrosshair(player)
if (hud_damageindicator ~= "0") then

if(self.dmgindicator)then
if ( band( self.dmgindicator, 16 ) > 0 ) then
self.dmgfront=1;
self.dmgback=1;
self.dmgleft=1;
self.dmgright=1;
else
if ( band( self.dmgindicator, 4 ) > 0 ) then
self.dmgfront=1;
end
if ( band( self.dmgindicator, 8 ) > 0 ) then
self.dmgback=1;
end
if ( band( self.dmgindicator, 1 ) > 0 ) then
self.dmgleft=1;
end
if ( band( self.dmgindicator, 2 ) > 0 ) then
self.dmgright=1;
end
end
end

local FrameTime=self:ClampToRange(_frametime,0.002,0.5);

FrameTime=FrameTime*0.75;
local fTexOffset=0.5/256;

if(self.dmgfront>0)then
%System:DrawImageColorCoords(self.damage_icon_ud, 0, 0, 800, 90, 4, 0.45, 0.1, 0,  self.dmgfront, 1+fTexOffset, 1+fTexOffset, fTexOffset, fTexOffset);
self.dmgfront=self.dmgfront-FrameTime;
if(self.dmgfront<0) then self.dmgfront=0 end
end

if(self.dmgback>0)then
%System:DrawImageColorCoords(self.damage_icon_ud, 0, 600-90, 800, 90, 4, 0.45, 0.1, 0, self.dmgback, fTexOffset, fTexOffset, 1+fTexOffset, 1+fTexOffset);
self.dmgback=self.dmgback-FrameTime;
if(self.dmgback<0) then self.dmgback=0 end
end

if(self.dmgleft>0)then
%System:DrawImageColorCoords(self.damage_icon_lr, 0, 0, 90, 600, 4, 0.45, 0.1, 0, self.dmgleft, fTexOffset, fTexOffset, 1-fTexOffset, 1-fTexOffset);
self.dmgleft=self.dmgleft-FrameTime;
if(self.dmgleft<0) then self.dmgleft=0 end
end

if (self.dmgright>0) then
%System:DrawImageColorCoords(self.damage_icon_lr, 800-90, 0, 90, 600, 4, 0.45, 0.1, 0, self.dmgright, 1-fTexOffset, 1-fTexOffset, fTexOffset, fTexOffset);
self.dmgright=self.dmgright-FrameTime;
if(self.dmgright<0) then self.dmgright=0 end
end

self.dmgindicator=0;
local w=player.cnt.weapon;

if (_localplayer.entity_type == "spectator") then
if (_localplayer.cnt.GetHost ) then
local myhost = System:GetEntity(_localplayer.cnt:GetHost());
if (myhost ~=nil) then
w = myhost.cnt.weapon;
end end end

if (w) then
w.Client.OnEnhanceHUD(w, self.currCrossAirScale, Hud.hit);
-- mixer: hud hit var leak fix
if (Hud.hit > 0 ) then
	Hud.hit=Hud.hit-20*_frametime;
end
end


self.currCrossAirScale=self.currCrossAirScale-_frametime*10;
if(self.currCrossAirScale<1.0) then
self.currCrossAirScale=1.0;
end
end
end

-----------------------------------------------------------------------------
-- SetProgressIndicator() is removing the progress indicator
-- /param Name e.g. "Player" or "AssaultState" key in the table Hud.Progress
-- /param text e.g. "Build Percentage"
-- /param valuex 0..100
-- /param valuey nil if not used, otherwise 0..100
-- /param valuez nil if not used, otherwise 0..100
-----------------------------------------------------------------------------

function Hud:SetProgressIndicator(Name,localtoken,valuex,valuey,valuez)

local PTable=self.Progress[Name];
local CurrTime=_time;

assert(PTable);

PTable.LocalToken=localtoken;
PTable.ValueX=valuex;
PTable.ValueY=valuey;
PTable.ValueZ=valuez;

if PTable.Seconds then
PTable.EndTime = CurrTime + PTable.Seconds;-- indicator disappears after 1 sec
else 
PTable.EndTime = nil;
end


-- play progress sounds
if(PTable==Hud.Progress.AssaultState) then
local iItemCurrent=tonumber(PTable.ValueX);
if(self.ProgressCurrentStateItem==iItemCurrent or self.ProgressCurrentStateItem==-1) then
local iCurrState=tonumber(PTable.ValueY);
-- state changed ? activate sound
if(self.ProgressCurrentState~=iCurrState and self.ProgressCurrentState~=-1 and (iCurrState>0 and iCurrState<=5)) then
-- play sound..
Sound:PlaySound(self.ProgressIndicatorSound);
end
-- save current state
self.ProgressCurrentState= iCurrState;
elseif( self.ProgressCurrentStateItem<iItemCurrent) then
-- captured
Sound:PlaySound(self.ProgressCapturedSound);
end
self.ProgressCurrentStateItem=iItemCurrent;
end
end

-- Display current progress indicator (mp only)
-- /param name "Player" "AssaultState" (entry int the Hud:Progress Table)

function Hud:DrawProgressIndicator(Name)

local PTable=self.Progress[Name];

assert(PTable);

if PTable.LocalToken then-- is activated?

local CurrTime=_time;
if PTable.EndTime==nil or CurrTime<PTable.EndTime then-- no end time or end time not reached
if (PTable.Draw) then
PTable.Draw(self);
end
else
PTable.LocalToken=nil;-- end time reached - deactivate
end
end
end

-- Display current vehicle damage count

function Hud:DrawVehicleBar(vehicle, health)
if(health~=0 and (vehicle.IsCar or vehicle.IsBoat)) then
local LocalPlayer=_localplayer;
local r, g, b=1, 1, 1;
local healthStep=health;

-- change color to warn player of serious vehicle damage
if(healthStep<45) then
r=1; g=0; b=0;
elseif(healthStep<75) then
r=1; g=1; b=0.5;
end

local FrameTime=_frametime;
-- interpolate values
self.curr_vehicledamage=self.curr_vehicledamage+(healthStep-self.curr_vehicledamage)*FrameTime*2;
self.curr_vehicledamage=self:ClampToRange(self.curr_vehicledamage, 0, 100);

if(healthStep<45) then
self.curr_vehicledamageAlpha=self.curr_vehicledamageAlpha+FrameTime*2;
if(self.curr_vehicledamageAlpha>1.0) then
self.curr_vehicledamageAlpha=0;
end
else
self.curr_vehicledamageAlpha=1;
end

local x, y=135+self.hdadjust,530;
if (LocalPlayer.items and not LocalPlayer.items.heatvisiongoggles) then
	y=545;
end

-- only cars/boats will display icon
if (vehicle.IsCar) then
	-- display energy bar holder
	self:DrawElement(x, y, self.mischolders.car_damage_frame);
	-- display energy bar
	self:DrawGauge(x+5, y+5, self.curr_vehicledamage, 100, self.mischolders.car_damage_inside, r, g, b, self.curr_vehicledamageAlpha, 0, 0);
elseif(vehicle.InitCommonAircraft) then
	if (not Hud.cis_gfxmsg) then
		if (vehicle.boat_params) and (vehicle.boat_params.DownRate) and (vehicle.boat_params.DownRate <= 0) then
			self:DrawElement(x-16-(mod(_time,0.12)*7), y+17, Hud.mischolders.plasma_trail); -- :P
		end
		self:DrawElement(x, y+10, self.mischolders.ahover_damage_frame);
		self:DrawGauge(x+1, y+12, self.curr_vehicledamage, 100, self.mischolders.ahover_damage_inside, r, g, b, self.curr_vehicledamageAlpha, 0, 0);
	end
elseif(vehicle.IsBoat) then
	-- display energy bar holder
	self:DrawElement(x, y, self.mischolders.boat_damage_frame);
	-- display energy bar
	self:DrawGauge(x+3, y+3, self.curr_vehicledamage, 100, self.mischolders.boat_damage_inside, r, g, b, self.curr_vehicledamageAlpha, 0, 0);
end
end
end

-- Display current mission box

function Hud:MissionBox()
-- [marco] make it very big so all messages will always fit

local w = 600;
local h = 320;
local boxx = (800-w)*0.5;
local boxy = 100;
local textspacing = 15;
local y = boxy + textspacing;

%System:DrawImageColor(Hud.white_dot, boxx, boxy, w, h, 4, 0.1, 0.1, 0.2, 0.8);

%Game:SetHUDFont("default", "default");

if (_localplayer.items.p_karma) then
	%Game:WriteHudString(100, 79,"@p_karma ".._localplayer.items.p_karma, 0.8, 1, 0.8, 1, 20,20);
end

-- top edge 
local r, g, b;
r=47.0/255;
g=66.0/255;
b=53.0/255;

%System:DrawImageColor(self.white_dot, boxx-1, boxy-1, w+2, 1, 4, r, g, b, 1);
-- bottom edge
%System:DrawImageColor(self.white_dot, boxx-1, boxy+h, w+2, 1, 4, r, g, b, 1);
-- left edge
%System:DrawImageColor(self.white_dot, boxx-1, boxy-1, 1, h+2, 4,  r, g, b, 1);
-- right edge
%System:DrawImageColor(self.white_dot, boxx+w, boxy-1, 1, h+2, 4,  r, g, b, 1);

-- main box
%System:DrawImageColor(nil, boxx, boxy, w, h, 4,1,1,1,1);

for i,val in self.objectives do
if(not val.completed)then
%System:DrawImageColor(self.missioncheckbox, boxx+textspacing, y, 16, 16, 4,1,1,1,1);
%Game:WriteHudString(boxx+textspacing+20, y-3, val.text, self.color.r, self.color.g, self.color.b, 1, 20,20);
else
%System:DrawImageColor(self.missioncheckboxcomp, boxx+textspacing, y, 16, 16, 4,0.35,0.35,0.39,1);
%Game:WriteHudString(boxx+textspacing+20, y-3, val.text, 0.35, 0.35, 0.39, 1, 20,20);
end
y=y+30;
end
end

-- Display frame box

function Hud:DrawFrameBox(x,y,w,h,a)
local uv=self.tempUV;
local bkx,bky,bkw,bkh=x, y, w, h;
local ouv=self.scoreboard.corner;
local cw,ch=self.scoreboard.corner.size.w,self.scoreboard.corner.size.h;
local ctickness=6;

if(not a) then
self.rend:PushQuad(bkx,bky,bkw,bkh ,self.scoreboard.background);
else
self.rend:PushQuad(bkx,bky,bkw,bkh ,self.scoreboard.background, 1, 1, 1, a);
end
end

-- Display kill icon (mp only)

function Hud:DrawKillIcon(x, y, name, alpha)
if(not name and not self.mpKills[name]) then 
return 0;
end

local pTex=self.mpKills[name];

-- render mirrowed icons
if(pTex)then
local t=self.temp_txinfo;
merge_no_copy(t,pTex);
pTex=t;

-- swap coordinates
    pTex[1],pTex[3]=pTex[3],pTex[1];

local sx=pTex.size.w;
local sy=pTex.size.h;
if (name=="SniperRifle") or (name=="Machete") or (name=="MutantShotgun") or (name=="Plasmaball") then
	self.rend:PushQuad(x, y, sx*(13/sy), 13 , pTex, 1, 1, 1, alpha);
else
	self.rend:PushQuad(x, y, sx*(14/sy), 14 , pTex, 1, 1, 1, alpha);
end
end

return 1; 
end

-- Display messages box

function Hud:DrawMessagesBox(tMsgList, xpos, ypos, killmsg) 

local fTime=self:ClampToRange(_frametime,0.002,0.5);

local n=count(tMsgList);
if(n>0)then
local y=0;
for i,msg in tMsgList do
if(msg.lifetime>0.0) then
-- lerp messages position
local lerp=fTime*10;

if(lerp>1.0) then
lerp=1;
end
msg.curr_ypos=msg.curr_ypos+(y-msg.curr_ypos)*lerp;

-- fade out old msg's
local textalpha=self:ClampToRange((4*msg.lifetime*msg.lifetime*msg.lifetime)/6.0,0.0,1.0);

textalpha=textalpha*self.f_value;

if (killmsg) then
local trg = msg.text.target;
local src = msg.text.shooter;
local wpn = nil;
local sit = msg.text.situation;
local txtKiller, txtKilled, txt;

if (sit == "1") then -- 0 = normal kill, 1 = suicide, 2 = teamkill 3 = headshot
msg.text.s_teamid = msg.text.t_teamid;
txtKiller = trg;
wpn = "Suicided";
txtKilled= nil;
txt = trg.." killed self";
elseif (sit == "3") then
	txtKiller = src;
	wpn= msg.text.weapon;
	txtKilled = trg;
	txt = src.." killed "..trg.." with a headshot from "..wpn;
else
txtKiller = src;
wpn= msg.text.weapon;
txtKilled = trg;
txt = src.." killed "..trg.." with "..wpn;
end

local strsizex,strsizey = Game:GetHudStringSize(txtKiller, 12, 12);
local currColor=nil;
local dmsgx = 10;

if(msg.isTop==1) then
currColor=self.color_top;
else
currColor=self.color;
end
if (msg.text.s_teamid == 1) then
Game:WriteHudString(xpos, ypos-msg.curr_ypos, txtKiller, 1, 0.6, 0.6, textalpha, 12, 12, 0);
elseif (msg.text.s_teamid == 2) then
Game:WriteHudString(xpos, ypos-msg.curr_ypos, txtKiller, 0.6, 0.6, 1, textalpha, 12, 12, 0);
elseif (msg.text.s_teamid == 3) then
Game:WriteHudString(xpos, ypos-msg.curr_ypos, txtKiller, 0.6, 1, 0.6, textalpha, 12, 12, 0);
else
Game:WriteHudString(xpos, ypos-msg.curr_ypos, txtKiller, currColor.r, currColor.g, currColor.b, textalpha, 12, 12, 0);
end
self:DrawKillIcon(xpos+strsizex+10, ypos-msg.curr_ypos+1, wpn, textalpha);

if(txtKilled) then
local sx,sy=0, 0;
if(wpn and self.mpKills[wpn]) then
sy=self.mpKills[wpn].size.h;
sx=self.mpKills[wpn].size.w*(14/sy);
end

if (sit=="3") then
	self:DrawKillIcon(xpos+strsizex+10+sx+3, ypos-msg.curr_ypos+1,"Headshot", textalpha);
	dmsgx = 27;
end
if (msg.text.t_teamid == 1) then
Game:WriteHudString(xpos+strsizex+10+sx+dmsgx, ypos-msg.curr_ypos, txtKilled, 1, 0.6, 0.6, textalpha, 12, 12, 0);
elseif (msg.text.t_teamid == 2) then
Game:WriteHudString(xpos+strsizex+10+sx+dmsgx, ypos-msg.curr_ypos, txtKilled, 0.6, 0.6, 1, textalpha, 12, 12, 0);
elseif (msg.text.t_teamid == 3) then
Game:WriteHudString(xpos+strsizex+10+sx+dmsgx, ypos-msg.curr_ypos, txtKilled, 0.6, 1, 0.6, textalpha, 12, 12, 0);
else
Game:WriteHudString(xpos+strsizex+10+sx+dmsgx, ypos-msg.curr_ypos, txtKilled, currColor.r, currColor.g, currColor.b, textalpha, 12, 12, 0);
end
end

--if (not msg.logged) then
	--msg.logged = 1;
	--System:Log("\001"..txt);
--end

else
-- output text
if(msg.isTop==1) then
Game:WriteHudString(xpos+self.hdadjust, ypos-msg.curr_ypos, msg.text, self.color_top.r, self.color_top.g, self.color_top.b, textalpha, 12, 12, 0);
else
Game:WriteHudString(xpos+self.hdadjust, ypos-msg.curr_ypos, msg.text, self.color.r, self.color.g, self.color.b, textalpha, 12, 12, 0);
end
end

y=y+20;

msg.lifetime=msg.lifetime-fTime;
else
-- remove old messages
local j=i;
local k=count(tMsgList);

while (j <= k) do
tMsgList[j]=tMsgList[j+1];
j=j+1;
end
end
end
end
end

-- Process all messages

function Hud:MessagesBox()
%Game:SetHUDFont("default", "default");
if(Game:IsMultiplayer()) then
self:DrawMessagesBox(self.kill_messages, 20, 15+80+80, 1);
end

self:DrawMessagesBox(self.messages,  140, 440+4*20);
end


function Hud:ResetSubtitles()
for i, subtl in Hud.tSubtitles do
Hud.tSubtitles[i] = nil;
end

Hud.fSubtlCurrY=0.0;
Hud.fSubtlCurrDelay=0.0;
end

-- add new messages to subtitles box

function Hud:AddSubtitle(text, _lifetime)
if(text) then
local life=6;
if(_lifetime) then
life=_lifetime;
end

-- clamp minimum amount of time that subtitle displays
if(life<2) then
life=2;
end
 
self:ProcessAddSubtitle(self.tSubtitles, text, life);

-- used for debugging
--self:ProcessAddMessage(self.messages, format("subtime= %f",_lifetime), 6);
end
end

-- Process subtitles box

function Hud:ProcessAddSubtitle(tSubtList, text, lifetime) 

-- create new subtitle
tSubtList[count(tSubtList)+1]= {
time=_time,
text=text,
lifetime=lifetime, 
};

-- remove old subtitles
local k=count(tSubtList);
if(k>5) then
local j=1;
while (j <= 6) do
tSubtList[j]=tSubtList[j+1];
j=j+1;
end
end


local maxFrameBoxSize=700;
local fSizex,fMaxBoxSizey = Game:GetHudStringSize("test", 14, 14, maxFrameBoxSize);
fmaxBoxSizey=(fMaxBoxSizey+8)*4;

-- count total lines for box to cover
local boxHeight=0;
for i,msg in tSubtList do
-- output centered text
local strsizex,strsizey = Game:GetHudStringSize(msg.text, 14, 14, maxFrameBoxSize);
boxHeight=boxHeight+strsizey+8;
end

local fFinalBoxHeight=boxHeight;
-- need to activate scrooling
if(fFinalBoxHeight>fmaxBoxSizey) then
Hud.fSubtlCurrDelay=_time;
end

end

-- Display subtitles box

function Hud:DrawSubtitlesBox(tMsgList, xpos, ypos)
local n=count(tMsgList);
if(n>0)then
local maxFrameBoxSize=700;

local fSizex,fMaxBoxSizey = Game:GetHudStringSize("test", 14, 14, maxFrameBoxSize);
fmaxBoxSizey=(fMaxBoxSizey+8)*4;

-- count total lines for box to cover
local boxHeight=0;
for i,msg in tMsgList do
-- output centered text
local strsizex,strsizey = Game:GetHudStringSize(msg.text, 14, 14, maxFrameBoxSize);
boxHeight=boxHeight+strsizey+8;
end

local fFinalBoxHeight=boxHeight;
-- need to activate scrooling
if(fFinalBoxHeight>fmaxBoxSizey) then
fFinalBoxHeight=fmaxBoxSizey;
end

-- render subtitle box
--self:DrawFrameBox(20, 20-9-4, 800-40, fFinalBoxHeight);
self:FlushCommon();

-- set scissoring area
--System:SetScissor(20, 20-9, 800-40, fFinalBoxHeight-8);

local currTime=_time;

local y=0;
for i,msg in tMsgList do
if(msg) then
if(currTime-msg.time<msg.lifetime) then
--if(msg.lifetime>0.0) then
local lifetime=msg.lifetime/_time-msg.time;
-- fade out old msg's
local textalpha=1; ---(30*lifetime*lifetime*lifetime);

if(textalpha>1.0) then
textalpha=1;
end
if(textalpha<0.0) then
textalpha=0;
end

-- output centered text
local strsizex,strsizey = Game:GetHudStringSize(msg.text, 14, 14, maxFrameBoxSize);

-- just write text
Game:WriteHudString(400-strsizex*0.5, ypos+y-Hud.fSubtlCurrY, msg.text, 0, 0.75, 1, textalpha, 14, 14, 0, maxFrameBoxSize);
y= y + strsizey+8;

else
-- remove old messages
local j=i;
local k=count(tMsgList);

while (j <= k) do
tMsgList[j]=tMsgList[j+1];
j=j+1;
end
end

end
end

-- need to activate scrolling
if(boxHeight-fmaxBoxSizey>0) then
-- activate fake delay..
if(Hud.fSubtlCurrDelay>0 and _time-Hud.fSubtlCurrDelay>1.0) then
    if(boxHeight-fmaxBoxSizey>Hud.fSubtlCurrY) then
Hud.fSubtlCurrY=Hud.fSubtlCurrY+3.0*_frametime;
else
Hud.fSubtlCurrY=boxHeight-fmaxBoxSizey;
end

end

else
Hud.fSubtlCurrY=0;
Hud.fSubtlCurrDelay=0.0;
end

-- reset scissoring
--System:SetScissor(0, 0, 0, 0);
end
end

-- Process subtitles

function Hud:SubtitlesBox()
%Game:SetHUDFont("default", "default");

local subCount= count(self.tSubtitles);

if(subCount>=1) then
self:DrawSubtitlesBox(self.tSubtitles,  100, 440); --20-9);
end

end

-- Display all weapon slots

function Hud:DrawWeaponSlots(player)

-- main weapon slots
if (Hud.weapons_alpha>0.0) then
local weapons=player.cnt:GetWeaponsSlots();
local x,y=220+self.hdadjust * 0.5,548;
local alpha_scale=Hud.weapons_alpha;

self.curr_newweapon=self.new_weapon;

-- save current weapon
if(Hud.weapons_alpha==1.0) then
local tmp=self.new_weapon;

if(self.currnew_weapon~=self.new_weapon) then
self.curr_weapon=self.new_weapon;
else
self.curr_weapon=player.cnt:GetCurrWeaponId();
end

if(self.currpl_weapon~=player.cnt:GetCurrWeaponId()) then
self.curr_weapon=player.cnt:GetCurrWeaponId();
end

self.currnew_weapon=self.new_weapon;
self.currpl_weapon=player.cnt:GetCurrWeaponId();
end

-- draw each slot
for i,val in weapons do
if(val and type(val)=="table") then
local currId=Game:GetWeaponClassIDByName(val.name);

if(currId~=self.curr_weapon) then
self:DrawWeapon(x, y, currId, 0.4*alpha_scale);
else
alpha_scale=alpha_scale*2;
if(alpha_scale>1.0) then
alpha_scale=1.0;
end
self:DrawWeapon(x, y, currId, alpha_scale);
end

x=x+84-self.hdadjust*0.3;
else
self:DrawWeapon(x, y, 0, 0.4*alpha_scale);
x=x+84-self.hdadjust*0.3;
end
end

Hud.weapons_alpha=Hud.weapons_alpha-(_frametime*0.25);
if (Hud.weapons_alpha<0) then
 Hud.weapons_alpha=0;
end
end
end

-- Display a weapon slot

function Hud:DrawWeapon(x,y,w,alpha)
if (alpha<=0.0) then return end;

self:DrawElement(x, y,self.txi.shape_bar,1,1,1,0.5*alpha);
if(w and w and self.tweapons[w] )then
local txi=self.txi.shape_bar;
local weapon_txi=self.tweapons[w];
local offsetX, offsetY= txi.size.w*0.5,txi.size.h*0.5;

offsetX=offsetX-weapon_txi.size.w*0.5;
offsetY=offsetY-weapon_txi.size.h*0.5;

self:DrawElement(x+offsetX, y+offsetY, weapon_txi, 1, 1, 1, alpha);
end
end

-- Display grenate slots

function Hud:DrawGrenadeSlot(player,x,y,num,grenade)
if (grenade) and (self.tgrenades[grenade]) then
	if (player.cnt.grenadetype == 7) then
		x = x-6;
		y= y-7;
	end
	self:DrawElement(x, y,self.tgrenades[grenade],1,1,1,1);

	if (num) then
		self:DrawNumber(2, 1,x+10,y+12,num);
	end
end
end

-- Todo: check if this is still used

function Hud:OnLightning()
	--if (ClientStuff.vlayers:IsActive("NightVision")) then
		--NightVision:OnLightning();
	--end
end

-- Set melee damage type

function Hud:OnMeleeDamage(damage_type)
--System:LogToConsole("client damage "..damage_type);
if(damage_type) then
Hud.meleeDamageType=damage_type;
else
Hud.meleeDamageType=nil;
end    
end

-- Reset screen damage effect

function Hud:ResetDamage()
self.hitdamagecounter=0;
System:SetScreenFx("ScreenBlur", 0);
System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurAmount", 0);
end

-- Increment screen damage effect hit counter

function Hud:OnMiscDamage(fDamageAmount)
if(fDamageAmount>0.0) then
self.hitdamagecounter=self.hitdamagecounter+fDamageAmount;

-- clamp hit max
if(self.hitdamagecounter>10) then
self.hitdamagecounter=10;
end
end
end

-- Set current screen damage effect color

function Hud:SetScreenDamageColor(r, g, b) 
System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorRed", r);
System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorGreen", g);
System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorBlue", b);
end

--Garbitos
function Hud:GS_speedBlur(amount, red, green, blue, inScale, inRate, outRate)

	if (not ClientStuff.vlayers:IsActive("SmokeBlur")) then
		ClientStuff.vlayers:ActivateLayer("SmokeBlur");
	end

	local layer = ClientStuff.vlayers:GetActivateLayer("SmokeBlur");
	if (layer) then
		layer.blurAmount = amount*1.5;
		layer.Red = red;
		layer.Green = green;
		layer.Blue = blue;
		layer.fadeInScale = inScale;
		layer.fadeInRate = inRate;
		layer.fadeOutRate = outRate;
	end

end

-- Display googles energy meter/batery time

function Hud:DrawGooglesOMeter(x1,y1)

if (_localplayer.items.heatvisiongoggles) then
if (_localplayer.Energy~=0) then
local x, y= 136+self.hdadjust, 553;

if (_localplayer.theVehicle) then
	y=570;
end

self:DrawGauge(x+4, y+4, _localplayer.Energy, 100, self.txi.googles_energy_inside, 1, 1, 1, 0.9, 0, 0);
self:DrawElement(x, y, self.txi.shape_googles_energy);
end
end
end

-- Render all stuff in hud stack

function Hud:FlushCommon()
self.rend:Draw(self.tx_hud);
end

function Hud:SetHDfov()
if (getglobal("r_Width") / getglobal("r_Height")) > 1.34 then
	setglobal("r_hd_screen",1);
	ClientStuff.HD_Fov = 1.970798373222351;
	Hud.hd_sc_mult=0.81;
	Hud.hdadjusty = 6;
	Hud.hdadjust = 50;
else
	setglobal("r_hd_screen",0);
	ClientStuff.HD_Fov = 108 * 3.1415962 / 180;
	Hud.hd_sc_mult=1;
	Hud.hdadjusty = 0;
	Hud.hdadjust = 0;
end
if (ZoomView) then
	ZoomView.NoZoom = ClientStuff.HD_Fov;
end
Game:SetCameraFov(ClientStuff.HD_Fov);
end

function Hud:SwitchCisSpecial()
	if (UI) then
		local mmchk = UI:IsScreenActive("MessageModeScreen");
		if (self.npcdialogdata) and (not Hud.cis_spopt) then
			mmchk = 1;
		end
		if (mmchk) and (mmchk~=0) then
		else --if (not Hud.bConsoledown) then
			if (not Game:IsMultiplayer()) then
				if (Hud.cis_spopt) then
					if (Hud.cis_SkipSpOption==nil) then
						Hud.cis_spopt = 0;
					end
				else
					Hud.cis_SkipSpOption=nil;
					Hud.cis_spopt = 1;
					Hud.npcdialogtimer = 1;
					BasicPlayer.PlayInteractSound(_localplayer,"Sounds/items/seek.wav");
				end
			else
				if (Hud.cis_mpopt) then
					if (Hud.cis_SkipSpOption==nil) then
						Hud.cis_mpopt = 0; -- perform mode specific menu turn-off
					end
				else
					Hud.cis_SkipSpOption=nil;
					Hud.cis_mpopt = 1;
					BasicPlayer.PlayInteractSound(_localplayer,"Sounds/items/seek.wav");
					if (_localplayer.cnt) and (_localplayer.cnt.weapon) then
						Hud.cis_lastwpn = _localplayer.cnt.weapon.classid * 1;
					end
				end
			end
		end
	end
end

-- Update common (mp/sp) hud elements

function Hud:OnUpdateCommonHudElements()

-------------pvcf----------------------shows for 7 seconds a image---------------------
					if not Hud.picturewassown then										
						local showingtime = 7; --in seconds
						if not Hud.pictimer then Hud.pictimer = 0; end
						Hud.pictimer = Hud.pictimer + _frametime;
							if not self.test then
								self.test=System:LoadImage("Textures/welcome.dds");
							else
								local alpha = 1;
								local x = 100;
								local y = 100;
								local sizex= 50;
								local sizey= 50;
								%System:DrawImageColor(self.test, x, y, sizex, sizey, 4,1,1,1,alpha);  
							end	
						if Hud.pictimer > showingtime then								
								Hud.picturewassown = 1;								
							Hud.pictimer = nil;
						end --if Hud.pictimer > 0.04 then							
					end --if not Hud.picturewassown then
-------------pvcf----------------------shows for 7 seconds a image---------------------					

System:SetScreenFx("ScreenBlur", getglobal("tds_ScreenBlur"));
System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurAmount", getglobal("tds_ScreenBlurAmount"));
System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorRed", getglobal("tds_ScreenBlurColorRed"));
System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorGreen", getglobal("tds_ScreenBlurColorGreen"));
System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorBlue", getglobal("tds_ScreenBlurColorBlue"));


local player=_localplayer;

------- ### Mixer: Interaction stuff begins here (part 3 of 3: get key and fadeamount) ### --------------
self.f_value = tonumber(hud_fadeamount);
self.cis_lastkey = Input:GetXKeyPressedName();
------- ### Mixer: Interaction stuff ENDS here (part 3 of 3: get key and fadeamount) ### --------------

self:DrawCrosshair(player);
	
if (self.hd_width) ~= getglobal("r_Width") then
	Hud:SetHDfov();
	self.hd_width = getglobal("r_Width");
end

-- perform custom update of level stuff thru mission-script function Mission:OnMapupdate() if present:
if (Mission) and (Mission.OnMapUpdate) then
	Mission:OnMapUpdate();
end
-- L_A_G_G_E_R
local Logo = System:LoadImage("Textures/Logo.dds")
%System:DrawImageColor(Logo, 10,10, 170, 70, 4,1,1,1, self.f_value)

if (ClientStuff.votenow) then
	%System:DrawImageColor(Hud.white_dot, 70, 65, 660, 26, 4, 0, 0, 0, 0.6);
	local voteendtime = ceil(ClientStuff.votenow.time - _time);
	local nsx,nsy = %Game:GetHudStringSize(ClientStuff.votenow.param1.." ("..voteendtime..")", 20, 20);
	nsx = 400-nsx*0.5;
	%Game:WriteHudString(nsx,68,ClientStuff.votenow.param1.." ("..voteendtime..")", 0.8, 1, 0.8, 0.86, 20, 20);
	if (ClientStuff.votenow.desc) then
		nsx,nsy = %Game:GetHudStringSize(ClientStuff.votenow.desc, 18, 18);
		nsx = 400-nsx*0.5;
		%Game:WriteHudString(nsx,90,ClientStuff.votenow.desc, 1, 1, 1, 0.86, 18, 18);
	end
	if (voteendtime <= 0) then
		ClientStuff.votenow = nil;
	end
end

if (player.entity_type == "spectator") then
	-- improved spectator stuff
	if (player.cnt.GetHost) then
		local myhost = System:GetEntity(player.cnt:GetHost());
		if (myhost) and (myhost.type) and (myhost.type == "Player") and (myhost.GetName) then
			if (Hud.spect_freeroam) and (Hud.spect_freeroam < 0) then
			else
				Hud.spect_pawn = myhost:GetName();
				Hud.spect_pawntime = _time + 0.2;
				Hud.spect_freeroam = nil;
				local Binding = Input:GetBinding("default", 45); -- get zoom toggle key
				if (Binding[1]) and (Binding[1].key) then
					if (self.cis_lastkey == Binding[1].key) then
						-- return to free roam spectate mode (stop spectating someone)
						Hud.spect_freeroam = -1;
						Client:SendCommand("VBSPE -1");
					end
				end
			end
		elseif (Hud.spect_pawn) then
			if (Hud.spect_pawntime) then
				if (Hud.spect_freeroam) then
					Hud.spect_freeroam = 0;
					Hud.spect_pawn = nil;
					Hud.spect_pawntime = nil;
				elseif (Hud.spect_pawntime < _time) and (player.GetCameraPosition) then
					Hud.spect_pawntime = _time + 1;
					local tblPlayers = {};
					local cpos = player:GetCameraPosition();
					Game:GetPlayerEntitiesInRadius(cpos,999999,tblPlayers,1);
					if (tblPlayers and type(tblPlayers)=="table") then
						for i, player in tblPlayers do		
							if (tblPlayers[i].pEntity) and (tblPlayers[i].pEntity.GetName) then
								if (Hud.spect_pawn == tblPlayers[i].pEntity:GetName()) then
									Client:SendCommand("VBSPE "..tblPlayers[i].pEntity.id);
								end
							end
						end
					end
				end
			end
		end
	end
else

if (self.cis_lastkey == "`") then
	if (Hud.cis_spopt) then
		Hud.cis_spopt = 0;
	end
	if (Hud.cis_mpopt) then
		Hud.cis_mpopt = 0; -- perform mode specific menu turn-off
	end
end

-- alien suit fx

if (player.items.invis_active) then
	if (not self.cis_pwrup_invis) then
		self.cis_pwrup_invis = System:LoadImage("Textures/promode/cis_powerup_invisibility.dds");
	else
		local invis_tme = player.items.invis_active * 1;
		if (Game:IsServer() == nil) then
			invis_tme = invis_tme - _time;
		end
		if (invis_tme > 0) then
			local cis_invico_alpha = invis_tme * 1;
			if (cis_invico_alpha > 1) then
				cis_invico_alpha = 1;
			end
			invis_tme = floor(invis_tme);
			local strsizex,strsizey = Game:GetHudStringSize(invis_tme,18,18);
			Game:WriteHudString(400-(strsizex/2),45,invis_tme,1,1,1,1,18,18);
			%System:DrawImageColor(self.cis_pwrup_invis,385,15,30,30,4,1,1,1,cis_invico_alpha);
		end
	end
elseif (player.items.aliensuit) and (player.cnt.first_person) then
	if (not self.cis_asuitfx) then
		self.cis_asuitfx = System:LoadImage("Textures/hud/aliensuitmask.dds");
	else
		%System:DrawImageColor(self.cis_asuitfx, -1, 0, 129, 600, 4, 0, 0, 0, 0.5);
		%System:DrawImageColor(self.cis_asuitfx, 801, 0, -129, 600, 4, 0, 0, 0, 0.5);
	end
end

if (player.bleed_timer) and (player.bleed_timer > _time-0.5) then
	if (not self.cis_bleedfx) then
		self.cis_bleedfx = System:LoadImage("Textures/hud/bleeding");
	else
		if (self.cis_bleed_val) then
			local blval = self.cis_bleed_val*5;
			if (blval > 100) then blval = 100; end
			%System:DrawImageColor(self.cis_bleedfx,670-blval*0.5,31-blval*0.5,blval*Hud.hd_sc_mult,blval,4,1,1,1,0.86);
		end
	end
end
if (player.bodun_timer) and (player.bodun_timer > _time-0.5) then
	if (not self.cis_bodunfx) then
		self.cis_bodunfx = System:LoadImage("Textures/hud/bodun");
	else
		if (self.cis_bodun_val) then
			local blval = self.cis_bodun_val*2;
			if player.theVehicle then
				local bangl = player:GetAngles(0);
				bangl.a = random(1,2);
				bangl.b = floor(_time);
				bangl.c = bangl.b * 0.8;
				if mod(bangl.b,2) == 0 then
					bangl.b = 2;
				else
					bangl.b = -2;
				end
				if mod(bangl.c,2) == 0 then
					bangl.x = bangl.x+_frametime*(blval*bangl.b);
				end
				bangl.z = bangl.z+_frametime*(blval*bangl.b);
				player:SetAngles(bangl);
			end
			if (blval > 200) then blval = 200; end
			%System:DrawImageColor(self.cis_bodunfx,670-blval*0.5,31-blval*0.5,blval*Hud.hd_sc_mult,blval,4,1,1,1,0.86);
		end
	end
end
-- show current gamestyle

if (player.currgamestyle) and (player.currgamestyle ~= "0") then
	local g_stl = tonumber(player.currgamestyle);
	if (GameStyler.playermoves[g_stl]) then
		if (GameStyler.playermoves[g_stl].crazyState) and (not ClientStuff.vlayers:IsActive("HeatVision")) then
			-- Mixer/Garbitos: fail-safe reapply CrazyCry
			GameStyler:ApplyGameStyle(player,g_stl,player.Properties.bIsBot);
		end
		g_stl = GameStyler.playermoves[g_stl].name;
		local sz_x,sz_y = Game:GetHudStringSize(g_stl, 13, 13);
		sz_x = 400-sz_x*0.5;
		%Game:WriteHudString(sz_x,2,g_stl, 1, 1, 1, 0.8, 13, 13);
	end
end

-- eatfood gt
if Hud.eating_meat then
	if (not self.eating_mask) then
		self.eating_mask=System:LoadImage("Textures/hud/AngryJack.dds");
	else
		%System:DrawImageColor(self.eating_mask, 0, 0, 800, 600, 4, 1, 1, 1, 1);
	end
end

-- underwater / scuba gear

if player.cnt.underwater>0.06 then
	if self.hitdamagecounter < 6.5 then
		Hud:SetScreenDamageColor(0.5, 0.5, 0.6);
		self.hitdamagecounter = 6.5;
	end
	if (player.items.scubagear) and (player.cnt.underwater > 0.9) then
		if (not self.cis_scuba_mask) then
			self.cis_scuba_mask=System:LoadImage("Textures/hud/cis_scuba_mask");
			self.cis_scuba_scale = 6.5;
			self.scuba_breath_time = nil;
		end
		self.cis_scuba_scale = self.cis_scuba_scale - _frametime * 12;
		if (self.cis_scuba_scale < 1) then
			self.cis_scuba_scale = 1;
		end
		local scubamask_alpha = (6.7-self.cis_scuba_scale)/6;
		%System:DrawImageColor(self.cis_scuba_mask, 1, 0, 401*self.cis_scuba_scale, 600*self.cis_scuba_scale, 4, 1, 1, 1, scubamask_alpha);
		%System:DrawImageColor(self.cis_scuba_mask, 800, 0, -400*self.cis_scuba_scale, 600*self.cis_scuba_scale, 4, 1, 1, 1, scubamask_alpha);
	end
else
	self.cis_scuba_mask = nil;
end
---HUNTER_FC: Underwater rendering texture---
if player.cnt.underwater>0.061 then
	if self.hitdamagecounter < 6.5 then
		Hud:SetScreenDamageColor(0.5, 0.5, 0.6);
		self.hitdamagecounter = 6.5;
		end
		if (player) and (player.cnt.underwater > 0.9) then
		self.player=System:LoadImage("Textures/hud/underwater_gui");
		self.player_scale = 6.5;
		end
		end 

------- ### Hunter_FC: Interaction stuff begins here (part 2 of 3: render functions) ### --------------

if (self.npcdialogtimer) then
	if (self.cis_spopt) then
		Hud:ManageSpOptions();
	---------
	elseif (_localplayer.grb_candidate) then
		local obj=_localplayer.cnt:GetViewIntersection();
		if (obj) and (obj.id) and (_localplayer.grb_candidate == obj.id) then
			Hud.label = "use_hint";
			if (_localplayer.cnt.use_pressed) then
				if (Game:IsMultiplayer()) then
					Client:SendCommand('VB_GV 0 '.._localplayer.grb_candidate);
				else
					_localplayer:CarryPhysItem(80,_localplayer.grb_candidate);
				end
				_localplayer.grb_candidate = nil;
			end
			if (obj.len > WeaponsParams.Hands.Std[1].distance) then
				_localplayer.grb_candidate = nil;
			end
		else
			_localplayer.grb_candidate = nil;
		end
		if (_localplayer.grb_candidate == nil) then
			self.npcdialogtimer = nil;
		end
	else
		if (self.npcdialogent) then
			local npct = System:GetEntity(self.npcdialogent);
			if (npct) and (npct.GetPos) then
				local npcname = npct:GetName();
				local npccache = Mission.NPCtexts[npcname][npct.MaxEnergy];
				local staring_at = _localplayer.cnt:GetViewIntersection();
				Mission.thisdialog = npct; -- store it here for easier outer callback
				AI:EnablePuppetMovement(npct.id,0,1);

				if (Hud.npcdialogent) or ((staring_at) and (staring_at.id) and (staring_at.id==npct.id)) then
					local dist = _localplayer:GetDistanceFromPoint(npct:GetPos());
					if dist > 1.4 then
						npct:StopDialog();
						Hud.npcdialogent = nil;
					else
						Hud.npcdialogtimer = _time;
						Hud.npcdialogent = npct.id * 1;
					end
				else
					Hud.npcdialogent = nil;
				end

				if (npct.cnt.health <= 0) then
					Hud.npcdialogent = nil;
				end
				
				if (not npccache) then
					--local say_snd = Sound:LoadStreamSound("Sounds/misc/missing_dialog.wav");
					Hud.npcdialogent = nil;
					--if (say_snd) then
					--	Sound:PlaySound(say_snd);
					--end
					Hud:AddMessage("MISSING DIALOG ITEM NUMBER "..npct.MaxEnergy.." FOR "..npct:GetName());
					System:Warning("MISSING DIALOG ITEM NUMBER "..npct.MaxEnergy.." FOR "..npct:GetName());
					return;
				end

				if (npccache["speak"]) and (npct.cnt.health > 0) then
					if (npccache["player"]) then
						npct.listening_player = 1;
						local say_snd = Sound:LoadStreamSound(npccache["speak"]);
						if (say_snd == nil) then
							npct.stop_my_talk = 0;
						else
							npct.stop_my_talk = (_time + Sound:GetSoundLength(say_snd) + 0.4); -- 0.4 is for pause between question and answer
							Sound:PlaySound(say_snd);
						end
					else
						npct.SaySomething = {};
						npct.SaySomething.soundFile = npccache["speak"];
						npct.SaySomething.Volume = 200;
						npct.SaySomething.min = 2;
						npct.SaySomething.max = 41;
						npct:Say(npct.SaySomething);
						if (not npct.cnt.moving) and (not npccache["noanim"]) then
							local say_snd = Sound:LoadStreamSound(npccache["speak"]);
							if (say_snd == nil) then
								npct.stop_my_talk = 0;
							else
								local rnd = random(1,3);
								rnd = "_talk0"..rnd;
								npct.stop_my_talk = (_time + Sound:GetSoundLength(say_snd));
								npct:StartAnimation(0,rnd,4);
							end
						end
					end
					npct.MaxEnergy = npct.MaxEnergy + 1;
					Hud.npcdialogent = nil;
				end
				
				if (not npccache["noanim"]) then
					local mypos = new(_localplayer:GetPos());
					local destdir = new(npct:GetPos());
					local angl = ({x=0,y=0,z=0});
					destdir = DifferenceVectors(mypos,destdir);
					ConvertVectorToCameraAngles(angl,destdir);
					npct:SetAngles(angl);
				end

				if (not Hud.npcdialogent) then
					Hud.npcdialogtimer = 0;
					Hud.npcdialogdata = nil;
						if (npccache["exit"]) then
							local NPCdialogNum = tonumber(npccache["exit"]);
							if (NPCdialogNum) then
								Mission.thisdialog.MaxEnergy = floor(NPCdialogNum);
							else
								dostring(npccache["exit"]);
							end
						end
					Mission.thisdialog = nil;
				else
					Hud.npcdialogdata = {};
					if (npccache.npctext) then
						Hud.npcdialogdata.npcname = npcname;
						Hud.npcdialogdata.npctext = npccache.npctext;
					end
					if (npccache.answers) then
						Hud.npcdialogdata.answers = npccache.answers;
					end
					Hud.npcdialogtimer = _time;

					if (Hud.cis_lastkey) then
						if (Hud.prvious_pressd_key) and (Hud.prvious_pressd_key == Hud.cis_lastkey) then
							Hud.prvious_pressd_key = nil;
							return;
						end
						local np_token = strfind(Hud.cis_lastkey,"numpad");
						if (np_token) then
							Hud.cis_lastkey = strsub(Hud.cis_lastkey,7);
						end
						local option = "o"..Hud.cis_lastkey;
						if (npccache[option]) then
							local NPCdialogNum = tonumber(npccache[option]);
							if (NPCdialogNum) then
								Mission.thisdialog.MaxEnergy = floor(NPCdialogNum);
							else
								dostring(npccache[option]);
							end
							Hud.prvious_pressd_key = Hud.cis_lastkey.."";
						end
					else
						Hud.prvious_pressd_key = nil;
					end
					Mission.thisdialog = nil;
				end
			end
		end
		if (self.npcdialogdata) then
			if (self.npcdialogdata.typingcode) then
				if (self.keycodee) then
					%System:DrawImageColor(Hud.keycodee, 250, 289, 300, 65, 4, 0.3, 0.3, 0.3, 0.7);
				else
					%System:DrawImageColor(Hud.white_dot, 150, 289, 500, 65, 4, 0.3, 0.3, 0.3, 0.7);
					%System:DrawImageColor(Hud.white_dot, 153,292, 494, 28, 4, 0.2, 0.5, 0.2, 0.9);
				end
				self.npcdialogdata.w, self.npcdialogdata.h = Game:GetHudStringSize(self.npcdialogdata.triggrname, 22, 22);
				Game:WriteHudString(400-self.npcdialogdata.w*0.5,295,self.npcdialogdata.triggrname, 1, 1, 1, 1, 22, 22);
				self.npcdialogdata.w, self.npcdialogdata.h = Game:GetHudStringSize(self.npcdialogdata.typingcode, 20, 20);
				%Game:WriteHudString(400-self.npcdialogdata.w*0.5,322,self.npcdialogdata.typingcode, 0.8, 0.8, 0.3, 1, 20,20);
			else
				if (self.npcdialogdata.npctext) then
					%System:DrawImageColor(Hud.white_dot, 100, 50, 600, 500, 4, 0.3, 0.3, 0.3, 0.7);
					%System:DrawImageColor(Hud.white_dot, 103, 53, 594, 28, 4, 0.2, 0.2, 0.5, 0.9);
					 ----- Mixer: remove this if localisation of npc name is not needed
					if (strfind(self.npcdialogdata.npcname," ")==nil) and (strfind(self.npcdialogdata.npcname,"@")==nil) then
						self.npcdialogdata.npcname = "@"..self.npcdialogdata.npcname;
					end
					------------
					Game:WriteHudString(110,56,self.npcdialogdata.npcname, 1, 1, 1, 1, 22, 22);
				else
					%System:DrawImageColor(Hud.white_dot, 100, 289, 600, 500-239, 4, 0.3, 0.3, 0.3, 0.7);
				end
				if (self.npcdialogdata.answers) then
					if (_localplayer.cnt.weapon) and (not _localplayer.current_mounted_weapon) then
						_localplayer.dlgholstered_gun = _localplayer.cnt:GetCurrWeaponId();
						_localplayer.cnt:SetCurrWeapon();
						_localplayer.cnt.lock_weapon=1;
					end
					%System:DrawImageColor(Hud.white_dot, 103,292, 594, 28, 4, 0.2, 0.5, 0.2, 0.9);
					Game:WriteHudString(110,295,player:GetName(), 1, 1, 1, 1, 22, 22);
				end
				%Game:SetHUDFont("default","default");
				if (self.npcdialogdata.npctext) then
					if (strfind(self.npcdialogdata.npctext," ")==nil) and (strfind(self.npcdialogdata.npctext,"@")==nil) then
						self.npcdialogdata.npctext = "@"..self.npcdialogdata.npctext;
					end
					%Game:WriteHudString(116,83,self.npcdialogdata.npctext, 0.2, 0.9, 0.2, 1, 20,20);
				end
				if (self.npcdialogdata.answers) then
					if (strfind(self.npcdialogdata.answers," ")==nil) and (strfind(self.npcdialogdata.answers,"@")==nil) then
						self.npcdialogdata.answers = "@"..self.npcdialogdata.answers;
					end
					%Game:WriteHudString(116,322,self.npcdialogdata.answers, 0.8, 0.8, 0.3, 1, 20,20);
				end
			end
		end -- if npcdialogdata
		if (self.npcdialogtimer + 0.1 < _time) or (_localplayer.cnt.use_pressed) then
			self.npcdialogtimer = nil;
			self.npcdialogdata = nil;
			if (_localplayer.fakeactionmapvehicle) then
				_localplayer.fakeactionmapvehicle = nil;
				if (_localplayer.theVehicle==nil) then
					Input:SetActionMap("default");
				end
			else
				_localplayer.cnt.use_pressed = nil;
			end
			if (_localplayer.dlgholstered_gun) then
				if (_localplayer.cnt.lock_weapon) and (not _localplayer.current_mounted_weapon) then
					_localplayer.cnt.lock_weapon=nil;
				end
				local cntladder = -1;
				if (_localplayer.ladder) then
					if (_localplayer.ladder.id) then
						cntladder = floor(_localplayer.ladder.id);
					end
					_localplayer.cnt:UseLadder(0);
				end
				_localplayer.silentstuff1 = nil;
				_localplayer.cnt:SetCurrWeapon(_localplayer.dlgholstered_gun);
				if (_localplayer.cnt.weapon == nil) then
					_localplayer.cnt:SelectFirstWeapon();
				end
				if (cntladder ~= -1) then
					cntladder = System:GetEntity(cntladder);
					if (cntladder) then
						_localplayer.cnt:UseLadder(1,cntladder.climbspeed,cntladder:GetPos());
					end
				end
				_localplayer.dlgholstered_gun = nil;
			end
		end
	end
else
	if (Mission) and (Mission.NPCtexts) then
		Hud.staringat=_localplayer.cnt:GetViewIntersection();
		if (Hud.staringat) and (Hud.staringat.id) then
			Hud.staringat.entity = System:GetEntity(Hud.staringat.id);
			if (Hud.staringat.entity) and (Hud.staringat.entity.POTSHOTS) and (Hud.staringat.entity.cnt) and (Hud.staringat.entity.cnt.health > 0) then
				local npc_name = Hud.staringat.entity:GetName();
				if (Mission.NPCtexts[npc_name]) then
					if (Hud.staringat.len < 14) then
						local strsizex,strsizey = Game:GetHudStringSize("@"..npc_name, 16, 16);
						Game:WriteHudString(400-(strsizex/2),316,"@"..npc_name, 1, 1, 1,1-(Hud.staringat.len/14), 16, 16);
						if (Hud.staringat.len < 1.3) then
							if (not Hud.cis_chaticon) then
								Hud.cis_chaticon = System:LoadImage("Textures/hud/cis_chat_balloon.dds");
							end
							if (Hud.staringat.entity.MaxEnergy == 100) then Hud.staringat.entity.MaxEnergy = 1; end
							if (Hud.staringat.entity.MaxEnergy > 0) and (Mission.NPCtexts[npc_name][Hud.staringat.entity.MaxEnergy]) then
								%System:DrawImageColor(Hud.cis_chaticon, 368,309, 64, 52, 4,1,1,1, self.f_value);
								if (_localplayer.cnt.use_pressed) and (Hud.staringat.entity.stop_my_talk==nil) then
									_localplayer.cnt.use_pressed = nil;
									Hud.npcdialogtimer = _time;
									Hud.npcdialogent = Hud.staringat.entity.id * 1;
								end
								Hud.staringat.entity.pl_putwpndown = 1;
								if (not Hud.put_wpn_down) then
									Hud.put_wpn_down = 0;
								end
							end
						end
					end
				end
			end
		end
	end
	if Hud.put_wpn_down then
		if Hud.staringat and Hud.staringat.entity and Hud.staringat.entity.pl_putwpndown then
			Hud.staringat.entity.pl_putwpndown = nil;
			Hud.put_wpn_down = Hud.put_wpn_down - _frametime;
			if Hud.put_wpn_down < -0.2 then
				Hud.put_wpn_down = -0.2;
			end
		elseif _localplayer.imrunsprinting then
			Hud.put_wpn_down = Hud.put_wpn_down - _frametime * 0.48;
			if Hud.put_wpn_down < -0.2 then
				Hud.put_wpn_down = -0.2;
			end
		else
			Hud.put_wpn_down = Hud.put_wpn_down + _frametime;
			if Hud.put_wpn_down > 0 then
				Hud.put_wpn_down = 0;
			end
		end
		if _localplayer.cnt.weapon and _localplayer.cnt.weapon.noputdown==nil then
			if _localplayer.cnt.weapon.putdown_val and Hud.put_wpn_down < -_localplayer.cnt.weapon.putdown_val then
				Hud.put_wpn_down = -_localplayer.cnt.weapon.putdown_val;
			end
			_localplayer.cnt.weapon:SetFirstPersonWeaponPos({x=0,y=0,z=Hud.put_wpn_down}, g_Vectors.v000);
		end
		if Hud.put_wpn_down == 0 then
			Hud.put_wpn_down = nil;
		end
	end
end

------- ### Mixer: Interaction stuff ends here (part 2 of 3: render functions) ### --------------
-- display energy meter

self:DrawGooglesOMeter(136, 570);

------- Mixer: sustainfps stuff TEST raw alpha tool
--local susfps = tonumber(getglobal("r_sustain_fps"));
--if (susfps > 0) and (ClientStuff.originalviewdist) then
--	local maxvd = System:ViewDistanceGet();
--	if (_frametime > 1/susfps) then
--		System:ViewDistanceSet(maxvd-1);
--	elseif (maxvd < ClientStuff.originalviewdist) then
--		System:ViewDistanceSet(maxvd+1);
--	end
--end
--------------------------------------------

-- blink energy bars

if (self.DisplayControl.bBlinkEnergyMeter>=1) then
	self.DisplayControl.fBlinkUpdateEnergyMeter = self.DisplayControl.fBlinkUpdateEnergyMeter + 3*_frametime;
	if (self.DisplayControl.fBlinkUpdateEnergyMeter>1) then
		self.DisplayControl.fBlinkUpdateEnergyMeter=0;
		self.DisplayControl.bBlinkEnergyMeter=self.DisplayControl.bBlinkEnergyMeter+1;
		if (self.DisplayControl.bBlinkEnergyMeter>18) then
			self.DisplayControl.bBlinkEnergyMeter=0;
		end
	end
else
	self.DisplayControl.fBlinkUpdateEnergyMeter=0;
end

-- render energy bars

if (self.DisplayControl.bShowEnergyMeter==1) then
	if (self.DisplayControl.bBlinkEnergyMeter==0 or self.DisplayControl.fBlinkUpdateEnergyMeter>0.5) then 
		Hud:DrawEnergy(player);
	end
end

-- blink ammo bars

if(self.DisplayControl.bBlinkAmmo>=1) then
self.DisplayControl.fBlinkUpdateAmmo = self.DisplayControl.fBlinkUpdateAmmo + 3*_frametime;
if(self.DisplayControl.fBlinkUpdateAmmo>1) then
self.DisplayControl.fBlinkUpdateAmmo=0;

self.DisplayControl.bBlinkAmmo=self.DisplayControl.bBlinkAmmo+1;
if(self.DisplayControl.bBlinkAmmo>18) then
self.DisplayControl.bBlinkAmmo=0;
end
end
else
self.DisplayControl.fBlinkUpdateAmmo=0;
end

-- render ammo bars

if (self.DisplayControl.bShowAmmo == 1) then
if(self.DisplayControl.bBlinkAmmo==0 or self.DisplayControl.fBlinkUpdateAmmo>0.5) then
self:DrawAmmo(player);
end
end

-- render weapons slots (blinking not used here)
if(self.DisplayControl.bShowWeapons  == 1) then
self:DrawWeaponSlots(player);
end

self:DrawLabel();
self:DrawProgressIndicator("Player");

if (player.theVehicle) then
	self:DrawVehicleBar(player.theVehicle, player.theVehicle.cnt.engineHealthReadOnly);
end

self:FlushCommon();

-- blink radar

if(self.DisplayControl.bBlinkRadar>=1) then
self.DisplayControl.fBlinkUpdateRadar = self.DisplayControl.fBlinkUpdateRadar + 3*_frametime;
if(self.DisplayControl.fBlinkUpdateRadar>1) then
self.DisplayControl.fBlinkUpdateRadar=0;

self.DisplayControl.bBlinkRadar=self.DisplayControl.bBlinkRadar+1;
if(self.DisplayControl.bBlinkRadar>6*3) then
self.DisplayControl.bBlinkRadar=0;
end
end
else
self.DisplayControl.fBlinkUpdateRadar=0;
end

-- render radar

if (self.DisplayControl.bShowRadar == 1) then
if(self.DisplayControl.bBlinkRadar==0 or self.DisplayControl.fBlinkUpdateRadar>0.5) then
	self:DrawRadar(15, 480, 104, 102);
end
end

-- render pickups

if(cl_hud_pickup_icons=="1") then
Hud:DrawPickups();
end

-- binoculars motion tracker

if (ClientStuff.vlayers:IsActive("Binoculars")) then
if (tonumber(getglobal("cl_motiontracker"))==1) then
self.curr_motiontrackerAlpha=self.curr_motiontrackerAlpha+_frametime*2;
if(self.curr_motiontrackerAlpha>1.0) then
self.curr_motiontrackerAlpha=0;
end

self:DrawElement(765, 470, self.txi.motiontracker_border, 1, 1, 1, 1);
self:DrawElement(765+(30-14)*0.5, 470+(24-14)*0.5, self.txi.motiontracker_signal, 1, 1, 1, self.curr_motiontrackerAlpha);
end
end
end
end
