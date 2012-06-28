Screens = {}

Screens.AspectRatio = nil

Screens.ScreenSize = nil

Screens.Fonts = {}

Screens.GuiScreen = nil

Screens.Activate = function()
	Util.Debug("Activating screens...")
	if(not Screens.Camera:Get_Enabled()) then
		Screens.Camera:Set_Enabled(true)
	end
	Util.Debug("Activating screens complete.")
end

Screens.Deactivate = function()
	if(Screens.Camera:Get_Enabled()) then
		Screens.Camera:Set_Enabled(false)
	end
end

Screens.DebugHideAll = function()
	if(Screens.Intro.Window:Get_Visible()) then
		Screens.Intro.Window:Set_Visible(false)
		Screens.Intro.DebugStop = true
		--Screens.Intro.Deactivate()
	end
	if(Screens.TitleScreen.Window:Get_Visible()) then
		Screens.TitleScreen.Deactivate()
	end
	if(Screens.FindServer.Window:Get_Visible()) then
		Screens.FindServer.Deactivate()
	end
	if(Screens.CreateServer.Window:Get_Visible()) then
		Screens.CreateServer.Deactivate()
	end
	if(Screens.WaitingRoom.Window:Get_Visible()) then
		Screens.WaitingRoom.Deactivate()
	end
	if(Screens.Credits.Window:Get_Visible()) then
		Screens.Credits.Deactivate()
	end
	if(Screens.Options.Window:Get_Visible()) then
		Screens.Options.Deactivate()
	end
	if(Screens.GameLoading.Window:Get_Visible()) then
		Screens.GameLoading.Deactivate()
	end
	if(Screens.Spawn.Window:Get_Visible()) then
		Screens.Spawn.Deactivate()
	end
	if(Screens.ModifierSelection.Window:Get_Visible()) then
		Screens.ModifierSelection.Deactivate()
	end
	if(Screens.WeaponSelection.Window:Get_Visible()) then
		Screens.WeaponSelection.Deactivate()
	end
	if(Screens.WinScreen.Window:Get_Visible()) then
		Screens.WinScreen.Deactivate()
	end
end

Screens.Initialize = function()
	Util.Debug("Initializing Screens...")
	width, height = Singularity.Graphics.Screen:GetResolution(0, 0)
	
	Screens.ScreenSize = Vector2:new(width, height)
	Screens.AspectRatio = width/height
	
	Screens.Camera = Singularity.Graphics.Camera:new("Screen Camera")
	Screens.GameObject = Singularity.Components.GameObject:Create("Camera node", Main.Root)
	Screens.GameObject:AddComponent(Screens.Camera)
	
	Util.Debug("Intro Screen...")	
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Screens\\Screens.Intro.lua")
	Util.Debug("Intro Screen Loaded.")
	
	Screens.GuiScreen = Singularity.Gui.GuiScreen:new("Gui Screen")
		
	-- initialize the screens
	Screens.Intro.Initialize()	
	Screens.GameObject:AddComponent(Screens.GuiScreen)
	--Screens.Camera:Deactivate()
	
	Util.Debug("Screens Initialized.")
	
	-- activate the initial screen
	Screens.Intro.Activate()
end

Screens.InitAll = function()

	-- Attach audio
	Audio.MenuEmitter = Audio.Manager:GetNewEmitter("Menu")
	Audio.MenuEmitter:AddCue(Audio.Manager:CreateCue("menu_Select"))
	Audio.MenuEmitter:AddCue(Audio.Manager:CreateCue("menu_Cancel"))
	Audio.MenuEmitter:AddCue(Audio.Manager:CreateCue("menu_Move"))
	Audio.MenuEmitter:AddCue(Audio.Manager:CreateCue("music_Theme"))

	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Screens\\Screens.TitleScreen.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Screens\\Screens.FindServer.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Screens\\Screens.CreateServer.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Screens\\Screens.WaitingRoom.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Screens\\Screens.Credits.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Screens\\Screens.Options.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Screens\\Screens.GameLoading.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Screens\\Screens.Spawn.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Screens\\Screens.ModifierSelection.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Screens\\Screens.WeaponSelection.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Screens\\Screens.PauseMenu.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Screens\\Screens.WinScreen.lua")
	
	Screens.TitleScreen.Initialize()
	Screens.FindServer.Initialize()
	Screens.CreateServer.Initialize()
	Screens.WaitingRoom.Initialize()
	Screens.Credits.Initialize()
	Screens.Options.Initialize()
	Screens.GameLoading.Initialize()
	Screens.Spawn.Initialize()
	Screens.ModifierSelection.Initialize()
	Screens.WeaponSelection.Initialize()
	Screens.PauseMenu.Initialize()
	Screens.WinScreen.Initialize()
	Screens.GameObject:AddComponent(Audio.MenuEmitter)
	Util.Debug("Screens Initialized.")
	
end

print("Screens Loaded.")