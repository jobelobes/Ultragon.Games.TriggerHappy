Screens.CreateServer = {}

Screens.CreateServer.Window = nil
Screens.CreateServer.ServerListWindow = nil
Screens.CreateServer.MatchName = nil
Screens.CreateServer.MatchType = nil
Screens.CreateServer.Condition = nil

Screens.CreateServer.Initialize = function()

	width, height = Singularity.Graphics.Screen:GetResolution(0, 0)
	
	--Load the texture and create the ninepatch for the window
	local texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\WindowBackground.png")
	local ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(400, 300), Vector4:new(0, 0, 0, 0))

	local position = Vector2:new((width / 2) - (ninepatch:Get_Width() / 2), (height / 2) - (ninepatch:Get_Height() / 2))

	Screens.CreateServer.Window = Singularity.Gui.Window:new("Create Server Window")
	Screens.CreateServer.Window:Set_Texture(ninepatch)
	Screens.CreateServer.Window:Set_Size(Vector2:new(ninepatch:Get_Width(), ninepatch:Get_Height()))
	Screens.CreateServer.Window:Set_Position(position)
	Screens.CreateServer.Window:Set_Draggable(true)
	Screens.CreateServer.Window:Set_Enabled(false)
	Screens.CreateServer.Window:Set_Visible(false)
	Screens.GuiScreen:AddWindow(Screens.CreateServer.Window)

	--Text box for game name
	local textboxBackground = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\ControlBackground.png")
	ninepatch = Singularity.Gui.NinePatch:new(textboxBackground, Vector2:new(textboxBackground:Get_Width(), textboxBackground:Get_Height()), Vector4:new(0, 0, 0, 0))

	local textbox = Singularity.Gui.TextBox:new("Match Name Textbox", "")
	textbox:Set_Texture(ninepatch)
	textbox:Set_Size(Vector2:new(Screens.CreateServer.Window:Get_Size().x - (Screens.CreateServer.Window:Get_Size().x * 0.15), ninepatch:Get_Height() * 0.05))
	textbox:Set_Position(Vector2:new((Screens.CreateServer.Window:Get_Size().x * 0.05), (Screens.CreateServer.Window:Get_Size().y * 0.17)))
	textbox:Set_FontColor(Color:new(0,0,0,1))
	Screens.CreateServer.Window:AddControl(textbox)

	--ordering swapped here for transparency stuff
	
	--Initializing Game Name Label and Text Field
	local label = Singularity.Gui.Label:new("Game Name Label", "Match Name")
	label:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic11 Bold"))
	label:Set_Size(Vector2:new(Singularity.Gui.Font:GetStringWidth(label:Get_Font(), label:Get_Text()), 30))
	label:Set_FontColor(Color:new(0,0,0,1))
	label:Set_Position(Vector2:new((Screens.CreateServer.Window:Get_Size().x / 2) - (Singularity.Gui.Font:GetStringWidth(label:Get_Font(), label:Get_Text()) / 2), Screens.CreateServer.Window:Get_Size().y * 0.05))
	Screens.CreateServer.Window:AddControl(label)
	
	--Match Type Label
	label = Singularity.Gui.Label:new("Match Type Label", "Match Type")
	label:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic11 Bold"))
	label:Set_FontColor(Color:new(0,0,0,1))
	label:Set_Size(Vector2:new(Singularity.Gui.Font:GetStringWidth(label:Get_Font(), label:Get_Text()), 25))
	label:Set_Position(Vector2:new(Screens.CreateServer.Window:Get_Size().x * 0.05, Screens.CreateServer.Window:Get_Size().y * 0.30))
	Screens.CreateServer.Window:AddControl(label)

	
	--Match Type List box (converted to list box when its finished
	local dropdownBackground = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\ControlBackground.png")
	local dropdownBackgroundElement = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\ControlBackground.png")
	ninepatch = Singularity.Gui.NinePatch:new(dropdownBackground, Vector2:new(dropdownBackground:Get_Width(), dropdownBackground:Get_Height()), Vector4:new(0, 0, 0, 0))

	local listbox = Singularity.Gui.ListBox:new("Match Type Listbox")
	listbox:Set_Texture(ninepatch)
	ninepatch = Singularity.Gui.NinePatch:new(dropdownBackgroundElement, Vector2:new(dropdownBackgroundElement:Get_Width(), dropdownBackgroundElement:Get_Height()), Vector4:new(0, 0, 0, 0))
	listbox:Set_OptionTexture(ninepatch)
	listbox:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic11 Bold"))
	listbox:Set_Size(Vector2:new(Screens.CreateServer.Window:Get_Size().x * 0.4, label:Get_Size().y))
	listbox:Set_Position(Vector2:new(label:Get_Size().x + (Screens.CreateServer.Window:Get_Size().x * 0.10), label:Get_Position().y))
	listbox:Set_OptionFontColor(Color:new(0,0,0,1))
	listbox:InitializeListBox()
	listbox:AddOption("KotH")
	listbox:AddOption("Assault")
	listbox:AddOption("Deathmatch")
	listbox:Set_FontColor(Color:new(0,0,0,1))
	listbox.Select:Add(tolua.cast(Singularity.Scripting.LuaListBoxDelegate:new(Screens.CreateServer.UpdateMatchInformation), "Singularity::IDelegate"))
	Screens.CreateServer.Window:AddControl(listbox)

	--Number of Players Label
	label = Singularity.Gui.Label:new("Player Name Label", "Player Name")
	label:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic11 Bold"))
	label:Set_Size(Vector2:new(Singularity.Gui.Font:GetStringWidth(label:Get_Font(), label:Get_Text()), 25))
	label:Set_Position(Vector2:new(Screens.CreateServer.Window:Get_Size().x * 0.05, Screens.CreateServer.Window:Get_Size().y * 0.50))
	label:Set_FontColor(Color:new(0,0,0,1))
	Screens.CreateServer.Window:AddControl(label)

	--Max Players Text box
	ninepatch = Singularity.Gui.NinePatch:new(textboxBackground, Vector2:new(textboxBackground:Get_Width(), textboxBackground:Get_Height()), Vector4:new(0, 0, 0, 0))

	textbox = Singularity.Gui.TextBox:new("Player Name Textbox", "")
	textbox:Set_Texture(ninepatch)
	textbox:Set_Size(Vector2:new(200, 30))
	textbox:Set_Text("Player")
	textbox:Set_FontColor(Color:new(0,0,0,1))
	textbox:Set_Position(Vector2:new(Screens.GuiScreen:GetControl("Match Type Listbox"):Get_Position().x, label:Get_Position().y))
	Screens.CreateServer.Window:AddControl(textbox)

	--Number of Players Label
	label = Singularity.Gui.Label:new("Win Condition Label", "Points")
	label:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic11 Bold"))
	label:Set_FontColor(Color:new(0,0,0,1))
	label:Set_Size(Vector2:new(Singularity.Gui.Font:GetStringWidth(label:Get_Font(), label:Get_Text()), 25))
	label:Set_Position(Vector2:new(Screens.CreateServer.Window:Get_Size().x * 0.05, Screens.CreateServer.Window:Get_Size().y * 0.70))
	Screens.CreateServer.Window:AddControl(label)
	
	--Win Conditions Placeholder
	ninepatch = Singularity.Gui.NinePatch:new(dropdownBackground, Vector2:new(dropdownBackground:Get_Width(), dropdownBackground:Get_Height()), Vector4:new(0, 0, 0, 0))

	-- Assault
	
	listbox = Singularity.Gui.ListBox:new("Win Conditions Assault ListBox")	
	listbox:Set_Texture(ninepatch)
	ninepatch = Singularity.Gui.NinePatch:new(dropdownBackgroundElement, Vector2:new(dropdownBackgroundElement:Get_Width(), dropdownBackgroundElement:Get_Height()), Vector4:new(0, 0, 0, 0))
	listbox:Set_OptionTexture(ninepatch)
	listbox:Set_Size(Vector2:new(Screens.CreateServer.Window:Get_Size().x * 0.4, label:Get_Size().y))
	listbox:Set_Position(Vector2:new(Screens.GuiScreen:GetControl("Match Type Listbox"):Get_Position().x, label:Get_Position().y))
	listbox:Set_FontColor(Color:new(0,0,0,1))
	listbox:Set_OptionFontColor(Color:new(0,0,0,1))
	listbox:InitializeListBox()
	listbox:AddOption("5 minutes")
	listbox:AddOption("10 minutes")
	listbox:AddOption("15 minutes")
	listbox:AddOption("20 minutes")
	listbox:AddOption("25 minutes")
	listbox.Select:Add(tolua.cast(Singularity.Scripting.LuaListBoxDelegate:new(Screens.CreateServer.UpdateAssaultWinConditions), "Singularity::IDelegate"))
	Screens.CreateServer.Window:AddControl(listbox)
	
	listbox:Set_Visible(false)

	--Deathmatch
	
	listbox = Singularity.Gui.ListBox:new("Win Conditions Deathmatch ListBox")	
	listbox:Set_Texture(ninepatch)
	ninepatch = Singularity.Gui.NinePatch:new(dropdownBackgroundElement, Vector2:new(dropdownBackgroundElement:Get_Width(), dropdownBackgroundElement:Get_Height()), Vector4:new(0, 0, 0, 0))
	listbox:Set_OptionTexture(ninepatch)
	listbox:Set_Size(Vector2:new(Screens.CreateServer.Window:Get_Size().x * 0.4, label:Get_Size().y))
	listbox:Set_Position(Vector2:new(Screens.GuiScreen:GetControl("Match Type Listbox"):Get_Position().x, label:Get_Position().y))
	listbox:Set_FontColor(Color:new(0,0,0,1))
	listbox:Set_OptionFontColor(Color:new(0,0,0,1))
	listbox:InitializeListBox()
	listbox:AddOption("5 kills")
	listbox:AddOption("10 kills")
	listbox:AddOption("15 kills")
	listbox:AddOption("25 kills")
	listbox:AddOption("50 kills")
	listbox.Select:Add(tolua.cast(Singularity.Scripting.LuaListBoxDelegate:new(Screens.CreateServer.UpdateDeathmatchWinConditions), "Singularity::IDelegate"))
	Screens.CreateServer.Window:AddControl(listbox)
	
	listbox:Set_Visible(false)
	
	-- KotH
	
	listbox = Singularity.Gui.ListBox:new("Win Conditions KotH ListBox")	
	ninepatch = Singularity.Gui.NinePatch:new(dropdownBackground, Vector2:new(dropdownBackground:Get_Width(), dropdownBackground:Get_Height()), Vector4:new(0, 0, 0, 0))
	listbox:Set_Texture(ninepatch)
	ninepatch = Singularity.Gui.NinePatch:new(dropdownBackgroundElement, Vector2:new(dropdownBackgroundElement:Get_Width(), dropdownBackgroundElement:Get_Height()), Vector4:new(0, 0, 0, 0))
	listbox:Set_OptionTexture(ninepatch)
	listbox:Set_Size(Vector2:new(Screens.CreateServer.Window:Get_Size().x * 0.4, label:Get_Size().y))
	listbox:Set_Position(Vector2:new(Screens.GuiScreen:GetControl("Match Type Listbox"):Get_Position().x, label:Get_Position().y))
	listbox:Set_FontColor(Color:new(0,0,0,1))
	listbox:Set_OptionFontColor(Color:new(0,0,0,1))
	listbox:InitializeListBox()
	listbox:AddOption("5 points")
	listbox:AddOption("6 points")
	listbox:AddOption("7 points")
	listbox:AddOption("8 points")
	listbox:AddOption("9 points")
	listbox:AddOption("10 points")
	listbox.Select:Add(tolua.cast(Singularity.Scripting.LuaListBoxDelegate:new(Screens.CreateServer.UpdateKOTHWinConditions), "Singularity::IDelegate"))
	Screens.CreateServer.Window:AddControl(listbox)
	
	--listbox:Set_Visible(false)
	
	--Initializing Create Server Button
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\CreateServerButton2.png")
	ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(99,42), Vector4:new(0, 0, 0, 0))

	local button = Singularity.Gui.Button:new("Create Server Button - Create Server", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(99,42))
	button:Set_Position(Vector2:new((Screens.CreateServer.Window:Get_Size().x * 0.85) - (button:Get_Size().x / 2), (Screens.CreateServer.Window:Get_Size().y * 0.96) - button:Get_Size().y))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.CreateServer.CreateServer), "Singularity::IDelegate"))
	Screens.CreateServer.Window:AddControl(button)

	--Close Window Button
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\CloseWindowMenuButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(texture:Get_Width() , texture:Get_Height()), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Close Button - Find Server", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(ninepatch:Get_Width() * 0.15, ninepatch:Get_Height() * 0.15))
	button:Set_Position(Vector2:new((Screens.CreateServer.Window:Get_Size().x * 0.98) - (button:Get_Size().x / 2), (Screens.CreateServer.Window:Get_Size().y * 0.01)))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.CreateServer.Close), "Singularity::IDelegate"))
	Screens.CreateServer.Window:AddControl(button)
	
	Screens.CreateServer.UpdateKOTHWinConditions() -- set the conditions based upon whatever we have up there
	--Screens.CreateServer.UpdateAssaultWinConditions() -- set the conditions based upon whatever we have up there
	--Screens.CreateServer.UpdateDeathmatchWinConditions() -- set the conditions based upon whatever we have up there
	
	Util.Debug("Screens[\"Create Server\"] loaded")
end

Screens.CreateServer.Activate = function()
	if(Screens.CreateServer.Window ~= nil) then
		Screens.CreateServer.Window:Set_Visible(true)
		Util.Debug("Activating Create Server Screens")
	end
end

Screens.CreateServer.Deactivate = function()
	if(Screens.CreateServer.Window ~= nil) then
		Screens.CreateServer.Window:Set_Visible(false)
	end
end

Screens.CreateServer.CreateServer = function()
	Util.Debug("Create Server Clicked")
	Audio.MenuEmitter:Play(0)
	local control = tolua.cast (Screens.GuiScreen:GetControl("Match Name Textbox"), "Singularity::Gui::TextBox")
	Screens.CreateServer.MatchName = control:Get_Text()
	Network.SetNetwork(Singularity.Networking.Network:CreateGame(Screens.CreateServer.MatchName)) -- now other people can join us!
	control = tolua.cast (Screens.GuiScreen:GetControl("Player Name Textbox"), "Singularity::Gui::TextBox")
	--Singularity.Networking.Network:Set_CurrentPlayerName(control:Get_Text()) -- it would be lovely to set this here, but the game needs time to load
	Screens.WaitingRoom.CreateMatch(Screens.CreateServer.MatchName, Screens.CreateServer.MatchType, Screens.CreateServer.Condition, control:Get_Text(), true)

	-- Main.Player.UUID should replace the above 0
	Screens.WaitingRoom.Activate()
	Screens.CreateServer.Deactivate()
end

Screens.CreateServer.Close = function()
	Util.Debug("Close Clicked")
	Audio.MenuEmitter:Play(1)
	Screens.CreateServer.Deactivate()
end

Screens.CreateServer.UpdateMatchInformation = function()
	Audio.MenuEmitter:Play(2)
	Util.Debug("Updating match information.")
	-- things that need to be updated when we change the match type:
	-- match type label name
	-- win condition
	local control = tolua.cast (Screens.GuiScreen:GetControl("Match Type Listbox"), "Singularity::Gui::ListBox")
	Util.Debug(control:Get_Text())
	if (control:Get_Text() == "KotH") then
		--Util.Debug("KOTH")
		control = tolua.cast (Screens.GuiScreen:GetControl("Win Conditions KotH ListBox"), "Singularity::Gui::ListBox")
		control:Set_Visible(true)
		control = tolua.cast (Screens.GuiScreen:GetControl("Win Conditions Assault ListBox"), "Singularity::Gui::ListBox")
		control:Set_Visible(false)		
		control = tolua.cast (Screens.GuiScreen:GetControl("Win Conditions Deathmatch ListBox"), "Singularity::Gui::ListBox")
		control:Set_Visible(false)
		control = tolua.cast (Screens.GuiScreen:GetControl("Win Condition Label"), "Singularity::Gui::Label")
		control:Set_Text("Points")
		Screens.CreateServer.UpdateKOTHWinConditions()
	elseif (control:Get_Text() == "Assault") then
		--Util.Debug("Assault")
		control = tolua.cast (Screens.GuiScreen:GetControl("Win Conditions Assault ListBox"), "Singularity::Gui::ListBox")
		control:Set_Visible(true)
		control = tolua.cast (Screens.GuiScreen:GetControl("Win Conditions KotH ListBox"), "Singularity::Gui::ListBox")
		control:Set_Visible(false)
		control = tolua.cast (Screens.GuiScreen:GetControl("Win Conditions Deathmatch ListBox"), "Singularity::Gui::ListBox")
		control:Set_Visible(false)
		control = tolua.cast (Screens.GuiScreen:GetControl("Win Condition Label"), "Singularity::Gui::Label")
		control:Set_Text("Time Limit")
		Screens.CreateServer.UpdateAssaultWinConditions()
	elseif (control:Get_Text() == "Deathmatch") then
		--Util.Debug("Deathmatch")
		control = tolua.cast (Screens.GuiScreen:GetControl("Win Conditions Assault ListBox"), "Singularity::Gui::ListBox")
		control:Set_Visible(false)
		control = tolua.cast (Screens.GuiScreen:GetControl("Win Conditions KotH ListBox"), "Singularity::Gui::ListBox")
		control:Set_Visible(false)
		control = tolua.cast (Screens.GuiScreen:GetControl("Win Conditions Deathmatch ListBox"), "Singularity::Gui::ListBox")
		control:Set_Visible(true)
		control = tolua.cast (Screens.GuiScreen:GetControl("Win Condition Label"), "Singularity::Gui::Label")
		control:Set_Text("Kills")
		Screens.CreateServer.UpdateDeathmatchWinConditions()
	end

end

Screens.CreateServer.UpdateAssaultWinConditions = function()
	Audio.MenuEmitter:Play(2)
	Util.Debug("Updating Assault win conditions.")
	
	local control = tolua.cast (Screens.GuiScreen:GetControl("Win Conditions Assault ListBox"), "Singularity::Gui::ListBox")
	if control:Get_Text() == "5 minutes" then 
		Screens.CreateServer.Condition = 300
		Util.Debug("5min")
	elseif control:Get_Text() == "10 minutes" then 
		Screens.CreateServer.Condition = 600
		Util.Debug("10min")
	elseif control:Get_Text() == "15 minutes" then 
		Screens.CreateServer.Condition = 900
		Util.Debug("15min")
	elseif control:Get_Text() == "20 minutes" then 
		Screens.CreateServer.Condition = 1200
		Util.Debug("20min")
	elseif control:Get_Text() == "25 minutes" then 
		Screens.CreateServer.Condition = 1500
		Util.Debug("25min")
	end
	
	Screens.CreateServer.MatchType = "Assault"
end

Screens.CreateServer.UpdateDeathmatchWinConditions = function()
	Audio.MenuEmitter:Play(2)
	Util.Debug("Updating Deathmatch win conditions.")
	
	local control = tolua.cast (Screens.GuiScreen:GetControl("Win Conditions Deathmatch ListBox"), "Singularity::Gui::ListBox")
	if control:Get_Text() == "5 kills" then 
		Screens.CreateServer.Condition = 5
		Util.Debug("5 kills")
	elseif control:Get_Text() == "10 kills" then 
		Screens.CreateServer.Condition = 10
		Util.Debug("10 kills")
	elseif control:Get_Text() == "15 kills" then 
		Screens.CreateServer.Condition = 15
		Util.Debug("15 kills")
	elseif control:Get_Text() == "25 kills" then 
		Screens.CreateServer.Condition = 25
		Util.Debug("25 kills")
	elseif control:Get_Text() == "50 kills" then 
		Screens.CreateServer.Condition = 50
		Util.Debug("50 kills")
	end
	
	Screens.CreateServer.MatchType = "Deathmatch"
end

Screens.CreateServer.UpdateKOTHWinConditions = function()
	Util.Debug("Updating KOTH win conditions.")
	
	local control = tolua.cast (Screens.GuiScreen:GetControl("Win Conditions KotH ListBox"), "Singularity::Gui::ListBox")

	if control:Get_Text() == "5 points" then 
		Screens.CreateServer.Condition = 5
		Util.Debug("5 points")
	elseif control:Get_Text() == "6 points" then 
		Screens.CreateServer.Condition = 6
		Util.Debug("6 points")
	elseif control:Get_Text() == "7 points" then 
		Screens.CreateServer.Condition = 7
		Util.Debug("7 points")
	elseif control:Get_Text() == "8 points" then 
		Screens.CreateServer.Condition = 8
		Util.Debug("8 points")
	elseif control:Get_Text() == "9 points" then 
		Screens.CreateServer.Condition = 9
		Util.Debug("9 points")
	elseif control:Get_Text() == "10 points" then 
		Screens.CreateServer.Condition = 10	
		Util.Debug("10 points")
	end
	
	--Screens.CreateServer.MatchType = "King of the Hill"
	Screens.CreateServer.MatchType = "KotH"
end		