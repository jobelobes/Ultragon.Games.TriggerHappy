Screens.Spawn = {}

Screens.Spawn.Window = nil

Screens.Spawn.Initialize = function()
	
	width, height = Singularity.Graphics.Screen:GetResolution(0, 0)
	
	spawningBackground = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\SpawnScreenBackground.png")
	ninepatch = Singularity.Gui.NinePatch:new(spawningBackground, Vector2:new(spawningBackground:Get_Width(), spawningBackground:Get_Height()), Vector4:new(0, 0, 0, 0))

	Screens.Spawn.Window = Singularity.Gui.Window:new("Game Loading window")
	Screens.Spawn.Window:Set_Texture(ninepatch)
	Screens.Spawn.Window:Set_Size(Vector2:new(width , height))
	Screens.Spawn.Window:Set_Position(Vector2:new(0, 0))
	Screens.Spawn.Window:Set_Draggable(false)
	Screens.Spawn.Window:Set_Enabled(false)
	Screens.Spawn.Window:Set_Visible(false)
	Player.HUD.GuiScreen:AddWindow(Screens.Spawn.Window)
	--Screen grab image of the map that shows up when the player is in the spawning state

	--[[
	spawningImage = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\SpawningImagePH.png")
	ninepatch = Singularity.Gui.NinePatch:new(spawningImage, Vector2:new(spawningImage:Get_Width()  /  Screens.AspectRatio, spawningImage:Get_Height()  / Screens.AspectRatio) , Vector4:new(0, 0, 0, 0))

	image = Singularity.Gui.Image:new("Spawning Image")
	image:Set_Texture(ninepatch)
	image:Set_Position(Vector2:new((Screens.Spawn.Window:Get_Size().x / 2) - (ninepatch:Get_Width() / 2), Screens.Spawn.Window:Get_Size().y * 0.035))
	image:Set_Size(Vector2:new(ninepatch:Get_Width(), ninepatch:Get_Height() * 0.85))
	Screens.Spawn.Window:AddControl(image)]]--

	--Adding the Respawn button
	respawnButton = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\RespawnButton1.png")
	ninepatch = Singularity.Gui.NinePatch:new(respawnButton, Vector2:new(99, 42) , Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Respawn Button", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(139, 59))
	button:Set_Position(Vector2:new(Screens.Spawn.Window:Get_Size().x  - (Screens.Spawn.Window:Get_Size().x * 0.15) - (ninepatch:Get_Width()), Screens.Spawn.Window:Get_Size().y * 0.90))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.Spawn.Respawn), "Singularity::IDelegate"))
	Screens.Spawn.Window:AddControl(button)

	--Adding the Loadout Selection button
	loadoutButton = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\SelectLoadoutButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(loadoutButton, Vector2:new(99, 42) , Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Loadout Selection Button", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(139, 59))
	button:Set_Position(Vector2:new(Screens.Spawn.Window:Get_Size().x - (Screens.Spawn.Window:Get_Size().x - (image:Get_Position().x + image:Get_Size().x)) - ((button:Get_Size().x)), Screens.Spawn.Window:Get_Size().y * 0.9))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.Spawn.Loadout), "Singularity::IDelegate"))
	Screens.Spawn.Window:AddControl(button)
	
	Util.Debug("Screens[\"Spawn Screens\"] loaded")
end

Screens.Spawn.Activate = function()
	if(Screens.Spawn.Window ~= nil) then
		Screens.Spawn.Window:Set_Visible(true)
		Util.Debug("Activating Spawn Screens")
	end
end

Screens.Spawn.Deactivate = function()
	if(Screens.Spawn.Window ~= nil) then
		Screens.Spawn.Window:Set_Visible(false)
	end
end

Screens.Spawn.Loadout = function()
	Util.Debug("Loadout Clicked")
	
	Screens.WeaponSelection.Activate()
	Screens.Spawn.Deactivate()
end

Screens.Spawn.Respawn = function()
	Util.Debug("Respawn Clicked")
	
	Util.Debug("Selecting weapon")
	Player.Client:SelectWeapon(1)
	
	Util.Debug("Changing Game play state to: Alive")
	Main.GamePlay.ChangeState(Main.GamePlay.States.Alive)
	
	Util.Debug("Deactivating Spawn")
	Screens.Spawn.Deactivate()
end

