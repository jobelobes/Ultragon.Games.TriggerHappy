Screens.FindServer = {}

Screens.FindServer.Window = nil
--Screens.FindServer.ServerListWindow = nil

Screens.FindServer.Servers = { }

Screens.FindServer.AddServer = function(matchname, matchtype, wincondition)
	ret = 
	{
		MatchName = matchname,
		MatchType = matchtype,
		WinCondition = wincondition,
	}
	
	return ret
end

Screens.FindServer.Initialize = function()

	--Initializing the Find Server windowBackground
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\WindowBackground.png")
	ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(600, 400), Vector4:new(0, 0, 0, 0))

	position = Vector2:new((width / 2) - (ninepatch:Get_Width() / 2), (height / 2) - (ninepatch:Get_Height() / 2))

	Screens.FindServer.Window = Singularity.Gui.Window:new("Find Servers Window")
	Screens.FindServer.Window:Set_Texture(ninepatch)
	Screens.FindServer.Window:Set_Size(Vector2:new(ninepatch:Get_Width(), ninepatch:Get_Height()))
	Screens.FindServer.Window:Set_Position(position)
	Screens.FindServer.Window:Set_Draggable(true)
	Screens.FindServer.Window:Set_Enabled(false)
	Screens.FindServer.Window:Set_Visible(false)
	Screens.GuiScreen:AddWindow(Screens.FindServer.Window)
	
	--Initializing The Server List Ninepatch
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\ControlBackground.png")
	ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(Screens.FindServer.Window:Get_Size().x, Screens.FindServer.Window:Get_Size().y), Vector4:new(0, 0, 0, 0))
	
	Screens.FindServer.ServerListWindow = Singularity.Gui.ListBox:new("Find Servers List")
	Screens.FindServer.ServerListWindow:Set_Texture(ninepatch)
	--Screens.FindServer.ServerListWindow:Set_Size(Vector2:new(ninepatch:Get_Width()  - (Screens.FindServer.Window:Get_Size().x * 0.05), ninepatch:Get_Height()  - (Screens.FindServer.Window:Get_Size().y * 0.2)))
	Screens.FindServer.ServerListWindow:Set_Size(Vector2:new(ninepatch:Get_Width()  - (Screens.FindServer.Window:Get_Size().x * 0.15), 30))
	--Screens.FindServer.ServerListWindow:Set_Position(Vector2:new(Screens.FindServer.Window:Get_Size().x * 0.025, Screens.FindServer.Window:Get_Size().y * 0.05))
	Screens.FindServer.ServerListWindow:Set_Position(Vector2:new(Screens.FindServer.Window:Get_Size().x * 0.075, Screens.FindServer.Window:Get_Size().y * 0.05))
	Screens.FindServer.ServerListWindow:Set_FontColor(Color:new(0,0,0,1))
	Screens.FindServer.ServerListWindow:InitializeListBox()
	Screens.FindServer.Window:AddControl(Screens.FindServer.ServerListWindow)

	--Initializing Join Server Button
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\JoinServerButton2.png")
	ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(99,42), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Join Server Button", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(99, 42))
	button:Set_Position(Vector2:new(Screens.FindServer.Window:Get_Size().x * 0.1, Screens.FindServer.Window:Get_Size().y * 0.95 - button:Get_Size().y))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.FindServer.JoinServer), "Singularity::IDelegate"))
	Screens.FindServer.Window:AddControl(button)

	----Initializing Create Server Button
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\CreateServerButton2.png")
	ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(99,42), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Create Server Button - Find Server", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(99, 42))
	button:Set_Position(Vector2:new((Screens.FindServer.Window:Get_Size().x * 0.435 - button:Get_Size().x), Screens.FindServer.Window:Get_Size().y * 0.95 - button:Get_Size().y))

	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.FindServer.CreateServer), "Singularity::IDelegate"))
	Screens.FindServer.Window:AddControl(button)
	
	--Number of Players Label
	label = Singularity.Gui.Label:new("Player Name Label", "Name:")
	label:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic11 Bold"))
	label:Set_FontColor(Color:new(0,0,0,1))
	label:Set_Size(Vector2:new(Singularity.Gui.Font:GetStringWidth(label:Get_Font(), label:Get_Text()), 25))
	label:Set_Position(Vector2:new(Screens.FindServer.Window:Get_Size().x * 0.27 - button:Get_Size().x, Screens.FindServer.Window:Get_Size().y * 0.86 - button:Get_Size().y))
	Screens.FindServer.Window:AddControl(label)
	
	local textboxBackground = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\ControlBackground.png")
	ninepatch = Singularity.Gui.NinePatch:new(textboxBackground, Vector2:new(textboxBackground:Get_Width(), textboxBackground:Get_Height()), Vector4:new(0, 0, 0, 0))

	textbox = Singularity.Gui.TextBox:new("Player Name Textbox", "")
	textbox:Set_Texture(ninepatch)
	textbox:Set_Size(Vector2:new(200, 25))
	textbox:Set_Text("Player")
	textbox:Set_FontColor(Color:new(0,0,0,1))
	textbox:Set_Position(Vector2:new((Screens.FindServer.Window:Get_Size().x * 0.385 - button:Get_Size().x), Screens.FindServer.Window:Get_Size().y * 0.86 - button:Get_Size().y))
	Screens.FindServer.Window:AddControl(textbox)
	
	--Initializing Refresh Button
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\RefreshButton2.png")
	ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(99, 42), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Refresh Button", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(99, 42))
	button:Set_Position(Vector2:new((Screens.FindServer.Window:Get_Size().x * 0.935 - button:Get_Size().x), Screens.FindServer.Window:Get_Size().y * 0.95 - button:Get_Size().y))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.FindServer.Refresh), "Singularity::IDelegate"))
	Screens.FindServer.Window:AddControl(button)
		
	--Close Button
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\CloseWindowMenuButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(texture:Get_Width(), texture:Get_Height()), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Close Button", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(ninepatch:Get_Width()  * 0.15, ninepatch:Get_Height()  * 0.15))
	button:Set_Position(Vector2:new((Screens.FindServer.Window:Get_Size().x * 0.98) - (button:Get_Size().y / 2), (Screens.FindServer.Window:Get_Size().y * 0.01)))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.FindServer.Close), "Singularity::IDelegate"))
	Screens.FindServer.Window:AddControl(button)
	
	Util.Debug("Screens[\"Find Server Screens\"] loaded")
end

Screens.FindServer.Activate = function()
	if(Screens.FindServer.Window ~= nil) then
		Screens.FindServer.Window:Set_Visible(true)
		Util.Debug("Activating Find Server Screens")
		Screens.FindServer.Refresh()
	end
end

Screens.FindServer.Deactivate = function()
	if(Screens.FindServer.Window ~= nil) then
		Screens.FindServer.Window:Set_Visible(false)
	end
end

Screens.FindServer.JoinServer = function()
	Util.Debug("Join Server Clicked")
	local control = tolua.cast (Screens.GuiScreen:GetControl("Find Servers List"), "Singularity::Gui::ListBox")
	count, games = Singularity.Networking.Network:FindGames()
	for k,v in pairs(Screens.FindServer.Servers) do
		Util.Debug(v.Name)
		Util.Debug(control:Get_Text())
		if (v.Name == control:Get_Text()) then
			Util.Debug("Joining")
			Audio.MenuEmitter:Play(0)
			Network.SetNetwork(Singularity.Networking.Network:JoinGame(v))
		else
			return
		end
	end
	

	if (Network.NetworkGame) then
	
		Network.SetNetwork(Singularity.Networking.Network:CreateGame(Screens.CreateServer.MatchName)) -- now other people can join us!
		control = tolua.cast (Screens.GuiScreen:GetControl("Player Name Textbox"), "Singularity::Gui::TextBox")
		Singularity.Networking.Network:Set_CurrentPlayerName(control:Get_Text())
		
		Screens.WaitingRoom.Activate()
		Screens.FindServer.Deactivate()
		
	end
end

Screens.FindServer.CreateServer = function()
	Util.Debug("Create Server Clicked")
	Audio.MenuEmitter:Play(0)
	Screens.CreateServer.Activate()
end

Screens.FindServer.Refresh = function()
	Util.Debug("Refresh Clicked")
	Audio.MenuEmitter:Play(2)
	-- we want all of these games in a table
	count, games = Singularity.Networking.Network:FindGames()
	Util.Debug(count)
	Util.DumpTable(games)
	Screens.FindServer.Servers = games
	--Util.Debug(games[1].CurrentParticipants)
	Util.Debug("clearing")
	local control = tolua.cast (Screens.GuiScreen:GetControl("Find Servers List"), "Singularity::Gui::ListBox")
	control:Clear()
	Util.Debug("cleared")
	--if we don't have them, we can do this:
	if (count == 0) then
		control:Set_Text("No servers found") -- this will be a special case
	else
		Util.Debug("forloopstart")
		for k,v in pairs(Screens.FindServer.Servers) do
			Util.Debug("adding")
			control:AddOption(v.Name)
			Util.Debug("added")
		end
		--control:AddOption("Servers found") -- for now we'll just say we found something
	end
	Util.Debug("Refreshed.")
	
	-- display them in "Find Servers List" control
	--control:AddOption( --we need to add each of the MATCHNAMES of the games we find...if we have any.
	--ipairs?
	-- Main.Player.UUID
	-- table.insert(Screens.FindServer.Servers,each item)
end

Screens.FindServer.Close = function()
	Util.Debug("Close Button Clicked")
	Audio.MenuEmitter:Play(1)
	Screens.FindServer.Deactivate()
end
