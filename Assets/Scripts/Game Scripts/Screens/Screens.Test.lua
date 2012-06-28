Screens = {}

Screens.AspectRatio = nil

Screens.ScreenSize = nil

Screens.Fonts = {}

Screens.GuiScreen = nil

Screens.Activate = function()
	if(not Screens.Camera:Get_Enabled()) then
		Screens.Camera:Set_Enabled(true)
	end
end

Screens.Deactivate = function()
	if(Screens.Camera:Get_Enabled()) then
		Screens.Camera:Set_Enabled(false)
	end
end

Screens.DebugHideAll = function()

	if(Screens.TitleScreen.Window:Get_Visible()) then
		Screens.TitleScreen.Deactivate()
	end

end

Screens.Initialize = function()
	Util.Debug("Initializing Screens")
	width, height = Singularity.Graphics.Screen:GetResolution(0, 0)
	
	Screens.ScreenSize = Vector2:new(width, height)
	Screens.AspectRatio = width/height
	
	Screens.Camera = Singularity.Graphics.Camera:new("Screen Camera")
	Screens.GameObject = Singularity.Components.GameObject:Create("Camera node", Main.Root)
	Screens.GameObject:AddComponent(Screens.Camera)
	

	
	Screens.GuiScreen = Singularity.Gui.GuiScreen:new("Gui Screen")
	

	
	-- initialize the screens


	
	Screens.GameObject:AddComponent(Screens.GuiScreen)


	--Screens.Camera:Deactivate()
	Util.Debug("Screens Initialized")
	
	-- activate the initial screen
	

end

Screens.InitAll = function()

	-- Attach audio
	Audio.MenuEmitter = Audio.Manager:GetNewEmitter("Menu")
	Audio.MenuEmitter:AddCue(Audio.Manager:CreateCue("menu_Select"))
	Audio.MenuEmitter:AddCue(Audio.Manager:CreateCue("menu_Cancel"))
	Audio.MenuEmitter:AddCue(Audio.Manager:CreateCue("menu_Move"))
	Audio.MenuEmitter:AddCue(Audio.Manager:CreateCue("music_Theme"))

	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Screens\\Screens.TitleScreen.lua")
	
	
	Screens.TitleScreen.Initialize()

	Screens.GameObject:AddComponent(Audio.MenuEmitter)
	Util.Debug("Screens initialize")
	
	Screens.TitleScreen.Activate()
	
end

print("Screens loaded")