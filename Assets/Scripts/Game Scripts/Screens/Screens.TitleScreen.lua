Screens.TitleScreen = {}

Screens.TitleScreen.Window = nil

Screens.TitleScreen.Initialize = function()

	--Initializing the Background Screens.TitleScreen.Window
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory .. "Textures\\Menus\\TitleBackground.png")
	ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(texture:Get_Width(), texture:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	Screens.TitleScreen.Window = Singularity.Gui.Window:new("Screens.TitleScreen.Window")
	Screens.TitleScreen.Window:Set_Position(Vector2:new(0, 0))
	Screens.TitleScreen.Window:Set_Size(Screens.ScreenSize)
	Screens.TitleScreen.Window:Set_Texture(ninepatch)
	Screens.TitleScreen.Window:Set_Draggable(false)
	Screens.TitleScreen.Window:Set_Enabled(false)
	Screens.TitleScreen.Window:Set_Visible(false)
	Screens.GuiScreen:AddWindow(Screens.TitleScreen.Window)
	
	-- load them in the opposite order for transparency stuff
	
	--Initializing the Trigger Happy logo image control
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\LogoImage.png")
	ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(texture:Get_Width(), texture:Get_Height()), Vector4:new(0, 0, 0, 0))

	image = Singularity.Gui.Image:new("Logo Image")
	image:Set_Texture(ninepatch)
	image:Set_Position(Vector2:new((Screens.ScreenSize.x * 0.2) * Screens.AspectRatio, (Screens.ScreenSize.y * 0.05) * Screens.AspectRatio))
	image:Set_Size(Vector2:new(ninepatch:Get_Width(), ninepatch:Get_Height()))
	Screens.TitleScreen.Window:AddControl(image)
	
		--Quit Button
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\QuitButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(texture:Get_Width(), texture:Get_Height()), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Quit Button", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(ninepatch:Get_Width() * Screens.AspectRatio, ninepatch:Get_Height() * Screens.AspectRatio))
	button:Set_Position(Vector2:new(Screens.ScreenSize.x * 0.1, Screens.ScreenSize.y * 0.63 + ninepatch:Get_Height() * 5))
	Util.Debug("before loading click")
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.TitleScreen.Quit), "Singularity::IDelegate"))
	Util.Debug("after loading click")
	Screens.TitleScreen.Window:AddControl(button)

		--Credits Button
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\CreditsButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(texture:Get_Width(), texture:Get_Height()), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Credits Button", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(ninepatch:Get_Width() * Screens.AspectRatio, ninepatch:Get_Height() * Screens.AspectRatio))
	button:Set_Position(Vector2:new(Screens.ScreenSize.x * 0.1, Screens.ScreenSize.y * 0.63 + ninepatch:Get_Height() * 4))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.TitleScreen.Credits), "Singularity::IDelegate"))
	Screens.TitleScreen.Window:AddControl(button)
	
		--Loading Options Button
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\OptionsButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(texture:Get_Width(), texture:Get_Height()), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Options Button", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(ninepatch:Get_Width() * Screens.AspectRatio, ninepatch:Get_Height() * Screens.AspectRatio))
	button:Set_Position(Vector2:new(Screens.ScreenSize.x * 0.1, Screens.ScreenSize.y * 0.60 + ninepatch:Get_Height() * 3))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.TitleScreen.Options), "Singularity::IDelegate"))
	Screens.TitleScreen.Window:AddControl(button)
	
		--Loading Create Server Button
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\CreateServerButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(texture:Get_Width(), texture:Get_Height()), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Create Server Button", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(ninepatch:Get_Width() * Screens.AspectRatio, ninepatch:Get_Height() * Screens.AspectRatio))
	button:Set_Position(Vector2:new(Screens.ScreenSize.x * 0.1, Screens.ScreenSize.y * 0.61 + ninepatch:Get_Height() * 2))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.TitleScreen.CreateServer), "Singularity::IDelegate"))
	Screens.TitleScreen.Window:AddControl(button)
	
	--Loading the Find Server Button
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\FindServerButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(texture:Get_Width(), texture:Get_Height()), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Find Server Button", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(ninepatch:Get_Width() * Screens.AspectRatio, ninepatch:Get_Height() * Screens.AspectRatio))
	button:Set_Position(Vector2:new(Screens.ScreenSize.x * 0.1, Screens.ScreenSize.y * 0.6 + ninepatch:Get_Height()))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.TitleScreen.FindServer), "Singularity::IDelegate"))
	Screens.TitleScreen.Window:AddControl(button)
	

	
	Util.Debug("Screens[\"Title Screens\"] loaded")
end

Screens.TitleScreen.Activate = function()
	if(Screens.TitleScreen.Window ~= nil) then
		Screens.TitleScreen.Window:Set_Visible(true)
		--Audio.MenuEmitter:Play(0)
		--Audio.MenuEmitter:Play(1)
		--Audio.MenuEmitter:Play(2)
		Audio.MenuEmitter:Play(3)
		Util.Debug("Activating Title Screens")
	end
end

Screens.TitleScreen.Deactivate = function()
	if(Screens.TitleScreen.Window ~= nil) then
		Screens.TitleScreen.Window:Set_Visible(false)
		Audio.MenuEmitter:Stop(3)
	end
end

Screens.TitleScreen.FindServer = function()
	Util.Debug("Find Server Clicked")
	
	--Main.GamePlay.Initialize()
	--Main.GamePlay.StartGame()
	Audio.MenuEmitter:Play(0)
	
	Screens.FindServer.Activate()
end

Screens.TitleScreen.CreateServer = function()
	Util.Debug("Create Server Clicked")
	Audio.MenuEmitter:Play(0)
	Screens.CreateServer.Activate()
end

Screens.TitleScreen.Options = function()
	Util.Debug("Options Clicked")
	Audio.MenuEmitter:Play(0)
	Screens.Options.Activate()
end

Screens.TitleScreen.Credits = function()
	Util.Debug("Credits Clicked")
	Audio.MenuEmitter:Play(0)
	Screens.Credits.Activate()
	Screens.TitleScreen.Deactivate()
end

Screens.TitleScreen.Quit = function()
	Util.Debug("Quit Clicked")
	Audio.MenuEmitter:Play(1)
	Singularity.Game:Exit()
end