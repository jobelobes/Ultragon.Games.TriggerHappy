Screens.PauseMenu = { }

Screens.PauseMenu.Window = nil

Screens.PauseMenu.ResumeGameNP = nil
Screens.PauseMenu.ReturnTitleScreenNP = nil
Screens.PauseMenu.QuitGameNP = nil

Screens.PauseMenu.ResumeGame = nil
Screens.PauseMenu.ReturnTitleScreen = nil
Screens.PauseMenu.QuitGame = nil

Screens.PauseMenu.Initialize = function()
		
	width, height = Singularity.Graphics.Screen:GetResolution(0, 0)
	
	--Initializing the window
	windowBackground = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory .. "Textures\\Menus\\PauseMenuScreen.png")
	Screens.PauseMenu.WindowNinepatch = Singularity.Gui.NinePatch:new(windowBackground, Vector2:new(windowBackground:Get_Width(), windowBackground:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	Screens.PauseMenu.Window = Singularity.Gui.Window:new("Pause Menu window")
	Screens.PauseMenu.Window:Set_Texture(Screens.PauseMenu.WindowNinepatch)
	Screens.PauseMenu.Window:Set_Size(Vector2:new(width, height))
	Screens.PauseMenu.Window:Set_Position(Vector2:new(0, 0))
	Screens.PauseMenu.Window:Set_Draggable(false)
	Screens.PauseMenu.Window:Set_Enabled(false)
	Screens.PauseMenu.Window:Set_Visible(false)
	--Screens.GuiScreen:AddWindow(Screens.PauseMenu.Window)
	Player.HUD.GuiScreen:AddWindow(Screens.PauseMenu.Window)
	
	--Resume Game Button
	resumeGameButton = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory .. "Textures\\Menus\\ResumeGameButton.png")
	Screens.PauseMenu.ResumeGameNP = Singularity.Gui.NinePatch:new(resumeGameButton, Vector2:new(resumeGameButton:Get_Width(), resumeGameButton:Get_Height()), Vector4:new(0, 0, 0, 0))

	Screens.PauseMenu.ResumeGame = Singularity.Gui.Button:new("Resume Game Button", "")
	Screens.PauseMenu.ResumeGame:Set_Texture(Screens.PauseMenu.ResumeGameNP)
	Screens.PauseMenu.ResumeGame:Set_Size(Vector2:new(139,59))
	Screens.PauseMenu.ResumeGame:Set_Position(Vector2:new((Screens.PauseMenu.Window:Get_Size().x / 2) - (Screens.PauseMenu.ResumeGame:Get_Size().x / 2), Screens.PauseMenu.Window:Get_Size().y * 0.36))
	Screens.PauseMenu.ResumeGame.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.PauseMenu.ResumeGameClick), "Singularity::IDelegate"))
	Screens.PauseMenu.Window:AddControl(Screens.PauseMenu.ResumeGame)

	--Return to Title Screen Button
	returnTitleScreenButton = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory .. "Textures\\Menus\\ReturntoTitleScreenButtonBlue.png")
	Screens.PauseMenu.ReturnTitleScreenNP = Singularity.Gui.NinePatch:new(returnTitleScreenButton, Vector2:new(returnTitleScreenButton:Get_Width(), returnTitleScreenButton:Get_Height()), Vector4:new(0, 0, 0, 0))

	Screens.PauseMenu.ReturnTitleScreen = Singularity.Gui.Button:new("Return to Title Button", "")
	Screens.PauseMenu.ReturnTitleScreen:Set_Texture(Screens.PauseMenu.ReturnTitleScreenNP)
	Screens.PauseMenu.ReturnTitleScreen:Set_Size(Vector2:new(139,59))
	Screens.PauseMenu.ReturnTitleScreen:Set_Position(Vector2:new((Screens.PauseMenu.Window:Get_Size().x / 2) - (Screens.PauseMenu.ReturnTitleScreen:Get_Size().x / 2), Screens.PauseMenu.Window:Get_Size().y * 0.45))
	Screens.PauseMenu.ReturnTitleScreen.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.PauseMenu.ReturnToTitleScreenClick), "Singularity::IDelegate"))
	Screens.PauseMenu.Window:AddControl(Screens.PauseMenu.ReturnTitleScreen)
	
	--Quit Game Button
	quitGameButton = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory .. "Textures\\Menus\\QuitGameButtonBlue.png")
	Screens.PauseMenu.QuitGameNP = Singularity.Gui.NinePatch:new(quitGameButton, Vector2:new(quitGameButton:Get_Width(), quitGameButton:Get_Height()), Vector4:new(0, 0, 0, 0))

	Screens.PauseMenu.QuitGame = Singularity.Gui.Button:new("Quit Game Button", "")
	Screens.PauseMenu.QuitGame:Set_Texture(Screens.PauseMenu.QuitGameNP)
	Screens.PauseMenu.QuitGame:Set_Size(Vector2:new(139,59))
	Screens.PauseMenu.QuitGame:Set_Position(Vector2:new((Screens.PauseMenu.Window:Get_Size().x / 2) - (Screens.PauseMenu.QuitGame:Get_Size().x / 2), Screens.PauseMenu.Window:Get_Size().y * 0.54))
	Screens.PauseMenu.QuitGame.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.PauseMenu.QuitGameClick), "Singularity::IDelegate"))
	Screens.PauseMenu.Window:AddControl(Screens.PauseMenu.QuitGame)

	Util.Debug("Screens[\"Pause Menu\"] loaded")
end

Screens.PauseMenu.Activate = function()
	if(Screens.PauseMenu.Window ~= nil) then
		Screens.PauseMenu.Window:Set_Visible(true)
		Util.Debug("Activating Pause menu Screens")
	end
end

Screens.PauseMenu.Deactivate = function()
	if(Screens.PauseMenu.Window ~= nil) then
		Screens.PauseMenu.Window:Set_Visible(false)
		Singularity.Inputs.Input:ResetMousePosition()
	end
end

Screens.PauseMenu.ResumeGameClick = function()
	Util.Debug("Resume Game clicked")
	Audio.MenuEmitter:Play(2)
	Player.Camera.Activate()
	Weapon.Enable()
	Screens.PauseMenu.Deactivate()

end

Screens.PauseMenu.ReturnToTitleScreenClick = function()
	Util.Debug("Return to Title Screen clicked. But it's not hooked up :/")
	Audio.MenuEmitter:Play(1)
	Player.Client.HP = -5
	--Main.GamePlay.EndGame()
	
end

Screens.PauseMenu.QuitGameClick = function()
	Audio.MenuEmitter:Play(1)
	Util.Debug("Quit Game clicked")
	Singularity.Game:Exit()
end