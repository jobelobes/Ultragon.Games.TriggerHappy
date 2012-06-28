Screens.Credits = {}

Screens.Credits.Window = nil
Screens.Credits.Images = {}

Screens.Credits.Initialize = function()
	
	width, height = Singularity.Graphics.Screen:GetResolution(0, 0)
	--Initializing the team intro window
	creditsTex = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\CreditsPH.png")
	ninepatch = Singularity.Gui.NinePatch:new(creditsTex, Vector2:new(creditsTex:Get_Width(), creditsTex:Get_Height()), Vector4:new(0, 0, 0, 0))

	Screens.Credits.Window = Singularity.Gui.Window:new("Credits Screen Window")
	Screens.Credits.Window:Set_Texture(ninepatch)
	Screens.Credits.Window:Set_Size(Vector2:new(width, height))
	Screens.Credits.Window:Set_Position(Vector2:new(0, 0))
	Screens.Credits.Window:Set_Draggable(false)
	Screens.Credits.Window:Set_Visible(false)
	Screens.GuiScreen:AddWindow(Screens.Credits.Window)

	--Initializing the engine icon window
	teamIntroTex = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\TeamLogo.png")
	ninepatch = Singularity.Gui.NinePatch:new(teamIntroTex, Vector2:new(teamIntroTex:Get_Width(), teamIntroTex:Get_Height()), Vector4:new(0, 0, 0, 0))

	Screens.Credits.Images[0] = Singularity.Gui.Image:new("Team Credits Image")
	Screens.Credits.Images[0]:Set_Texture(ninepatch)
	Screens.Credits.Images[0]:Set_Size(Vector2:new(width, height))
	Screens.Credits.Images[0]:Set_Position(Vector2:new(0, 0))
	Screens.Credits.Window:AddControl(Screens.Credits.Images[0])

	--Initializing the engine icon window
	singularityLogoTex = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Singularity_logo.png")
	ninepatch = Singularity.Gui.NinePatch:new(singularityLogoTex, Vector2:new(singularityLogoTex:Get_Width(), singularityLogoTex:Get_Height()), Vector4:new(0, 0, 0, 0))

	Screens.Credits.Images[1] = Singularity.Gui.Image:new("Singularity Credits Image")
	Screens.Credits.Images[1]:Set_Texture(ninepatch)
	Screens.Credits.Images[1]:Set_Size(Vector2:new(ninepatch:Get_Width(), ninepatch:Get_Height()))
	Screens.Credits.Images[1]:Set_Position(Vector2:new((Screens.Credits.Window:Get_Size().x / 2) - (ninepatch:Get_Width() / 2), (Screens.Credits.Window:Get_Size().y / 2) - (ninepatch:Get_Height() / 2) ))
	Screens.Credits.Window:AddControl(Screens.Credits.Images[1])

	--Initializing the Legal  window
	legalTex = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\LegalScreen.png")
	ninepatch = Singularity.Gui.NinePatch:new(legalTex, Vector2:new(legalTex:Get_Width(), legalTex:Get_Height()), Vector4:new(0, 0, 0, 0))

	Screens.Credits.Images[2] = Singularity.Gui.Image:new("Legal Credits Image")
	Screens.Credits.Images[2]:Set_Texture(ninepatch)
	Screens.Credits.Images[2]:Set_Size(Vector2:new(width, height))
	Screens.Credits.Images[2]:Set_Position(Vector2:new(0, 0))
	Screens.Credits.Window:AddControl(Screens.Credits.Images[2])

	--OK Button
	button = Singularity.Gui.Button:new("Credits Screen Cycle Button", "")
	button:Set_Texture(ninepatch)
	button:Set_Position(Screens.Credits.Window:Get_Position())
	button:Set_Size(Screens.Credits.Window:Get_Size())
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.Credits.Continue), "Singularity::IDelegate"))
	button:Set_Visible(true)
	Screens.Credits.Window:AddControl(button)
end

Screens.Credits.Activate = function()
	if(Screens.Credits.Window ~= nil) then
		Screens.Credits.Window:Set_Visible(true)
		
		Screens.Credits.Images[0]:Set_Visible(true)
		Screens.Credits.Images[1]:Set_Visible(false)
		Screens.Credits.Images[2]:Set_Visible(false)
		Util.Debug("Activating Credits Screens")
	end
end

Screens.Credits.Deactivate = function()
	if(Screens.Credits.Window ~= nil) then
		Screens.Credits.Window:Set_Visible(false)
	end
end

Screens.Credits.Continue = function()
	Util.Debug("Continue Clicked")
	
	if(Screens.Credits.Images[0]:Get_Visible()) then
		Screens.Credits.Images[1]:Set_Visible(true)
		Screens.Credits.Images[0]:Set_Visible(false)
	elseif (Screens.Credits.Images[1]:Get_Visible()) then
		Screens.Credits.Images[2]:Set_Visible(true)
		Screens.Credits.Images[1]:Set_Visible(false)
	elseif (Screens.Credits.Images[2]:Get_Visible()) then
		Screens.TitleScreen.Activate()
		Screens.Credits.Deactivate()
	end
	
end
