Screens.Intro = {}

Screens.Intro.ElapsedTime = 0

Screens.Intro.State = 0

Screens.Intro.Window = nil

Screens.Intro.Binder = nil

Screens.Intro.DebugStop = false

Screens.Intro.Textures = {}

Screens.Intro.Initialize = function()	
	--Initializing the Team Intro Screen
	
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\BlackBackground.png")
	Screens.Intro.Textures[1] = Singularity.Gui.NinePatch:new(texture, Vector2:new(texture:Get_Width(), texture:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\TeamLogo.png")
	Screens.Intro.Textures[2] = Singularity.Gui.NinePatch(texture, Vector2:new(texture:Get_Width(), texture:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Screens\\Engine_screen.png")
	Screens.Intro.Textures[3] = Singularity.Gui.NinePatch:new(texture, Vector2:new(texture:Get_Width(), texture:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\LegalCreditsScreen.png")
	Screens.Intro.Textures[4] = Singularity.Gui.NinePatch:new(texture, Vector2:new(texture:Get_Width(), texture:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	Screens.Intro.Window = Singularity.Gui.Window:new("Screens.Intro.Window")
	Screens.Intro.Window:Set_Texture(Screens.Intro.Textures[1])
	Screens.Intro.Window:Set_Position(Vector2:new(0, 0))
	Screens.Intro.Window:Set_Size(Screens.ScreenSize)
	Screens.Intro.Window:Set_Draggable(false)
	Screens.Intro.Window:Set_Enabled(false)
	Screens.Intro.Window:Set_Visible(false)
	Screens.GuiScreen:AddWindow(Screens.Intro.Window)

	Util.Debug("Screens[\"Intro screen\"] loaded")
end

Screens.Intro.Activate = function()
	if (Screens.Intro.Window ~= nil) then
		Screens.Intro.ElapsedTime = 0
		Screens.Intro.State = 1
		Screens.Intro.Window:Set_Visible(true)
		
		if(Screens.Intro.Binder == nil) then
			Screens.Intro.Binder = Singularity.Scripting.LuaBinder:new("Screens.Intro.OnUpdate")
			Screens.Intro.Binder:Set_FunctionName("Screens.Intro.OnUpdate")
			Main.Root:AddComponent(Screens.Intro.Binder)
		end
		
		Util.Debug("Activating Intro screen")
	end
end

Screens.Intro.Deactivate = function()
	if (Screens.Intro.Window ~= nil) then
		Screens.Intro.Window:Set_Visible(false)
		
		if(Screens.Intro.Binder ~= nil) then
			Screens.Intro.Binder:Set_Enabled(false)
		end
	end
end

Screens.Intro.OnUpdate = function(sender, elapsedTime)
	Screens.Intro.ElapsedTime = Screens.Intro.ElapsedTime + elapsedTime
	
	-- if (Screens.Intro.ElapsedTime < 3 and Screens.Intro.State == 1) then
		-- Screens.TitleScreen.Initialize()
	-- end
	
	if(Screens.Intro.ElapsedTime > 0.5 and not Screens.Intro.DebugStop) then
		if(Screens.Intro.State < 4 ) then
			Screens.Intro.ElapsedTime = 0
			Screens.Intro.State = Screens.Intro.State + 1
			Screens.Intro.Window:Set_Texture(Screens.Intro.Textures[Screens.Intro.State])
			Util.Debug("Changing to next screen[", Screens.Intro.State, "]")
		else
			if (not Screens.Intro.DebugStop) then
				Screens.TitleScreen.Activate()
			end
			Screens.Intro.Deactivate()
		end
	end
end