HudSigns = {
	Properties = {		
		bEnabled = 1,
		texture_Sign="",
		LocationX = 400,
	        LocationY = 20,
	        Width = 256,
	        Height = 256,
	        Blend=0,
	        Color = {r=1,g=1,b=1,t=1},
	    --   Transparency = 1,
        },
	
	Editor={
		Model="Objects/Editor/T.cgf",
	},
}
-------------------------------------------------------------------------------
function HudSigns:OnPropertyChange()
	self:OnReset();
end
-------------------------------------------------------------------------------
function HudSigns:OnInit()
	self:OnReset();
end
-------------------------------------------------------------------------------
function HudSigns:OnShutDown()
end
-------------------------------------------------------------------------------
function HudSigns:OnSave(stm)
end
-------------------------------------------------------------------------------
function HudSigns:OnLoad(stm)
end
-------------------------------------------------------------------------------
function HudSigns:OnReset()
	Hud:EnableCustomHud(0);
	self.sign_texture = System:LoadTexture(self.Properties.texture_Sign);
end
-------------------------------------------------------------------------------
function HudSigns:OnUpdateCustomHud()
	if ( self.Properties.bEnabled == 0 ) then
		return;
	end
	System:DrawImageColor(self.sign_texture,
                              self.Properties.LocationX,
                              self.Properties.LocationY,
                              self.Properties.Width,
                              self.Properties.Height,
                              self.Properties.Blend,
                              self.Properties.Color.r,
                              self.Properties.Color.g,
                              self.Properties.Color.b,
                              self.Properties.Color.t
                      --       self.Properties.Transparency
        );
end
------------------------------------------------------------------------------- 
function HudSigns:Event_Activate()
	BroadcastEvent(self, "Activate");
	Hud:EnableCustomHud(1);
end
-------------------------------------------------------------------------------
function HudSigns:Event_Deactivate()
	BroadcastEvent(self, "Deactivate");
	Hud:EnableCustomHud(0);
        self:OnReset();
end
-------------------------------------------------------------------------------
function HudSigns:Event_Enable( sender )
	self.Properties.bEnabled = 1;
	BroadcastEvent( self,"Enable" );
end

----------------------------------------------------------------------------
function HudSigns:Event_Disable()
	self.bEnabled = 0;
	self.Width = 0;
	self.Height = 0;
        self.LocationX = 0;
        self.LocationY = 0;
        self.Blend = 0;

end
-------------------------------------------------------------------------------