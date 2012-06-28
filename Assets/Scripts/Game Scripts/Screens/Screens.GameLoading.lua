Screens.GameLoading = {}

Screens.GameLoading.Window = nil

Screens.GameLoading.Initialize = function()
	
	width, height = Singularity.Graphics.Screen:GetResolution(0, 0)
	
	gameLoadingTex = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\LoadingScreen.jpg")
	ninepatch = Singularity.Gui.NinePatch:new(gameLoadingTex, Vector2:new(gameLoadingTex:Get_Width(), gameLoadingTex:Get_Height()), Vector4:new(0, 0, 0, 0))

	Screens.GameLoading.Window = Singularity.Gui.Window:new("Game Loading window")
	Screens.GameLoading.Window:Set_Texture(ninepatch)
	Screens.GameLoading.Window:Set_Size(Vector2:new(width , height))
	Screens.GameLoading.Window:Set_Position(Vector2:new(0, 0))
	Screens.GameLoading.Window:Set_Draggable(false)
	Screens.GameLoading.Window:Set_Enabled(false)
	Screens.GameLoading.Window:Set_Visible(false)
	Screens.GuiScreen:AddWindow(Screens.GameLoading.Window)
	Util.Debug("Screens[\"Game Loading Screens\"] loaded")
end

Screens.GameLoading.Activate = function()
	if(Screens.GameLoading.Window ~= nil) then
		Screens.GameLoading.Window:Set_Visible(true)
		Util.Debug("Activating GameLoading Screens")
	end
end

Screens.GameLoading.Deactivate = function()
	if(Screens.GameLoading.Window ~= nil) then
		Screens.GameLoading.Window:Set_Visible(false)
	end
end

