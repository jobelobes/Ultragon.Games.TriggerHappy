Screens.Options = {}

Screens.Options.Window = nil

Screens.Options.Initialize = function()
	
	width, height = Singularity.Graphics.Screen:GetResolution(0, 0)
	
	--Initializing the Options Screen
	windowBackground = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\WindowBackground.png")
	ninepatch = Singularity.Gui.NinePatch:new(windowBackground, Vector2:new(400, 500), Vector4:new(0, 0, 0, 0))

	position = Vector2:new((width / 2) - (ninepatch:Get_Width() / 2), (height / 2) - (ninepatch:Get_Height() / 2))

	Screens.Options.Window = Singularity.Gui.Window:new("Game Options Window")
	Screens.Options.Window:Set_Texture(ninepatch)
	Screens.Options.Window:Set_Size(Vector2:new(ninepatch:Get_Width(), ninepatch:Get_Height()))
	Screens.Options.Window:Set_Position(position)
	Screens.Options.Window:Set_Draggable(true)
	Screens.Options.Window:Set_Enabled(false)
	Screens.Options.Window:Set_Visible(false)
	Screens.GuiScreen:AddWindow(Screens.Options.Window)

	--Accept Changes Button for Options Screen
	acceptChangesButtonBlue = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\AcceptChangesButton2.png")
	ninepatch = Singularity.Gui.NinePatch:new(acceptChangesButtonBlue, Vector2:new(acceptChangesButtonBlue:Get_Width() , acceptChangesButtonBlue:Get_Height()), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Accept Changes Button", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(99, 42))
	button:Set_Position(Vector2:new((Screens.Options.Window:Get_Size().x / 2) - (button:Get_Size().x / 2), Screens.Options.Window:Get_Size().y - button:Get_Size().y - (Screens.Options.Window:Get_Size().y * 0.05)))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.Options.AcceptChanges), "Singularity::IDelegate"))
	Screens.Options.Window:AddControl(button)

	--Close Button
	closeButton = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\CloseWindowMenuButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(closeButton, Vector2:new(closeButton:Get_Width(), closeButton:Get_Height()), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Close Button - Options Screen", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(ninepatch:Get_Width() * 0.1, ninepatch:Get_Height() * 0.1))
	button:Set_Position(Vector2:new((Screens.Options.Window:Get_Size().x * 0.98) - (button:Get_Size().x / 2), (Screens.Options.Window:Get_Size().y * 0.01)))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.Options.Close), "Singularity::IDelegate"))
	Screens.Options.Window:AddControl(button)
	Util.Debug("Screens[\"Options Screens\"] loaded")
end

Screens.Options.Activate = function()
	if(Screens.Options.Window ~= nil) then
		Screens.Options.Window:Set_Visible(true)
		Util.Debug("Activating Options Screens")
	end
end

Screens.Options.Deactivate = function()
	if(Screens.Options.Window ~= nil) then
		Screens.Options.Window:Set_Visible(false)
	end
end

Screens.Options.AcceptChanges = function()
	Util.Debug("Accept Changes Clicked")
	Screens.Options.Deactivate()
end

Screens.Options.Close = function()
	Util.Debug("Close clicked")
	
	Screens.Options.Deactivate()
end


