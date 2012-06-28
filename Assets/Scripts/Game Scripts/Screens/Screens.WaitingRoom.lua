Screens.WaitingRoom = {}

Screens.WaitingRoom.Window = nil

Screens.WaitingRoom.CurrentBroadcastId = 2

Screens.WaitingRoom.Host = false

Screens.WaitingRoom.Binder = nil

Screens.WaitingRoom.Timer = 0

Screens.WaitingRoom.TimerEnabled = true

Screens.WaitingRoom.Match = 
{
	MatchName = "",
	MatchType = "Deathmatch", -- or "King of the Hill"
	StartGame = false,
	Condition = 
	{
		WinningScore = 5,
	},
	Teams = 
	{
		RedTeam = {},
		BlueTeam = {},
		NeutralTeam = {},
	},

}

Screens.WaitingRoom.CreatePlayer = function(id, player, ready, host)

	local ret =
	{

	}

	return ret
	
end

Screens.WaitingRoom.Client = 
{
	Name = "",
	Ready = false,
	Id = -1,
	Host = false,	
}

Screens.WaitingRoom.Initialize = function()

	width, height = Singularity.Graphics.Screen:GetResolution(0, 0)
	
	--Initializing the Window
	local windowBackground = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\WaitingRoomScreen.jpg")
	local ninepatch = Singularity.Gui.NinePatch:new(windowBackground, Vector2:new(windowBackground:Get_Width(), windowBackground:Get_Height()), Vector4:new(0, 0, 0, 0))

	local position = Vector2:new((width / 2) - (ninepatch:Get_Width() / 2), (height / 2) - (ninepatch:Get_Height() / 2 * 1.33))

	Screens.WaitingRoom.Window = Singularity.Gui.Window:new("Waiting Room window")
	Screens.WaitingRoom.Window:Set_Texture(ninepatch)
	Screens.WaitingRoom.Window:Set_Position(position)
	Screens.WaitingRoom.Window:Set_Size(Vector2:new(ninepatch:Get_Width(), ninepatch:Get_Height()))
	Screens.WaitingRoom.Window:Set_Draggable(true)
	Screens.WaitingRoom.Window:Set_Enabled(false)
	Screens.WaitingRoom.Window:Set_Visible(false)
	Screens.GuiScreen:AddWindow(Screens.WaitingRoom.Window)

	
	--Ready Button
	local readyButton = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\ReadyButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(readyButton, Vector2:new(99,42), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Ready Button", "")
	button:Set_Texture(ninepatch)
	button:Set_Position(Vector2:new((Screens.WaitingRoom.Window:Get_Size().x * 0.62) - (ninepatch:Get_Width() / 2), (Screens.WaitingRoom.Window:Get_Size().y * 0.90)))
	button:Set_Size(Vector2:new(99,42))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.WaitingRoom.Ready), "Singularity::IDelegate"))
	Screens.WaitingRoom.Window:AddControl(button)


	--Start Game Button
	local startButton = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\StartMatchButton.png") -- this needs to be changed
	ninepatch = Singularity.Gui.NinePatch:new(startButton, Vector2:new(99,42), Vector4:new(0, 0, 0, 0))
	
	button = Singularity.Gui.Button:new("Start Button", "")
	button:Set_Texture(ninepatch)
	button:Set_Position(Vector2:new((Screens.WaitingRoom.Window:Get_Size().x * 0.82) - (ninepatch:Get_Width() / 2), (Screens.WaitingRoom.Window:Get_Size().y * 0.90)))
	button:Set_Size(Vector2:new(99,42))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.WaitingRoom.GoToGame), "Singularity::IDelegate"))
	button:Set_Visible(false)
	Screens.WaitingRoom.Window:AddControl(button)

	
	
	--Game information Label
	local label = Singularity.Gui.Label:new("Game Name Label - Waiting Room", "Test Name")		--will eventually pull in name of the server that was created
	label:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic11 Bold"))
	label:Set_FontColor(Color:new(0.2,0.2,0.2,1))
	label:Set_Position(Vector2:new(Screens.WaitingRoom.Window:Get_Size().x * 0.07, Screens.WaitingRoom.Window:Get_Size().y * 0.05))
	label:Set_Size(Vector2:new(Screens.WaitingRoom.Window:Get_Size().x * 0.9, 30))
	Screens.WaitingRoom.Window:AddControl(label)
	
	--Game Type Label
	label = Singularity.Gui.Label:new("Match Type Label - Waiting Room", "Match Type")		--will eventually pull in name of the server that was created
	label:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic11 Bold"))
	label:Set_Position(Vector2:new((Screens.WaitingRoom.Window:Get_Size().x * 0.07), Screens.WaitingRoom.Window:Get_Size().y * 0.1))
	label:Set_Size(Vector2:new(label:Get_TextCenter() * 2, 30))
	label:Set_FontColor(Color:new(0.75,0.75,0.75,1))
	Screens.WaitingRoom.Window:AddControl(label)

	
	--Game Type Definition Label
	label = Singularity.Gui.Label:new("Game Name Definition Label - Waiting Room", "King of the Hill")		--will eventually pull in name of the server that was created
	label:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic11 Bold"))
	label:Set_Position(Vector2:new((Screens.WaitingRoom.Window:Get_Size().x * 0.25), Screens.WaitingRoom.Window:Get_Size().y * 0.1))
	label:Set_Size(Vector2:new(label:Get_TextCenter() * 2, 30))
	label:Set_FontColor(Color:new(0.5,0.5,0.5,1))
	Screens.WaitingRoom.Window:AddControl(label)

	--Win Condition Label
	label = Singularity.Gui.Label:new("Win Condition Label - Waiting Room", "Capture Limit")		--will eventually pull in name of the server that was created
	label:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic11 Bold"))
	label:Set_Position(Vector2:new(Screens.WaitingRoom.Window:Get_Size().x * 0.55, Screens.WaitingRoom.Window:Get_Size().y * 0.1))
	label:Set_Size(Vector2:new(label:Get_TextCenter() * 2, 30))
	label:Set_FontColor(Color:new(0.75,0.75,0.75,1))
	Screens.WaitingRoom.Window:AddControl(label)

	
	--Win Condition Definition Label
	label = Singularity.Gui.Label:new("Win Conditions Definition Label - Waiting Room", "4")		--will eventually pull in name of the server that was created
	label:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic11 Bold"))
	label:Set_Position(Vector2:new(Screens.WaitingRoom.Window:Get_Size().x * 0.8, Screens.WaitingRoom.Window:Get_Size().y * 0.1))
	label:Set_Size(Vector2:new(label:Get_TextCenter() * 4, 30))
	label:Set_FontColor(Color:new(0.5,0.5,0.5,1))
	Screens.WaitingRoom.Window:AddControl(label)
	
	--Neutral players container
	local controlBackground = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\ControlBackground.png")
	ninepatch = Singularity.Gui.NinePatch:new(controlBackground, Vector2:new(controlBackground:Get_Width(), controlBackground:Get_Height()), Vector4:new(0, 0, 0, 0))

	local panel = Singularity.Gui.Panel:new("Neutral Players Container Panel")
	panel:Set_Texture(ninepatch)
	panel:Set_Position(Vector2:new(Screens.WaitingRoom.Window:Get_Size().x * 0.07, Screens.WaitingRoom.Window:Get_Size().y * 0.18))
	panel:Set_Size(Vector2:new(Screens.WaitingRoom.Window:Get_Size().x * 0.37, Screens.WaitingRoom.Window:Get_Size().y * 0.7))
	Screens.WaitingRoom.Window:AddControl(panel)
	
	for i = 1, 16 do
		label = Singularity.Gui.Label:new("NeutralPlayer"..i)
		label:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic11 Bold"))
		label:Set_FontColor(Color:new(0,0,0,1))
		label:Set_Position(Vector2:new(0, panel:Get_Size().y * (0.0625*(i-1))))
		label:Set_Size(Vector2:new(panel:Get_Size().x, panel:Get_Size().y * 0.05))
		panel:AddControl(label)
	end
	
	
	--Blue Team Container
	local blueTeamBackground = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\BlueTeamBackground.png")
	ninepatch = Singularity.Gui.NinePatch:new(blueTeamBackground, Vector2:new(blueTeamBackground:Get_Width(), blueTeamBackground:Get_Height()), Vector4:new(0, 0, 0, 0))

	panel = Singularity.Gui.Panel:new("Blue Team Container Panel")
	panel:Set_Texture(ninepatch)
	panel:Set_Position(Vector2:new(Screens.WaitingRoom.Window:Get_Size().x * 0.555, Screens.WaitingRoom.Window:Get_Size().y * 0.18))
	panel:Set_Size(Vector2:new(Screens.WaitingRoom.Window:Get_Size().x * 0.375, Screens.WaitingRoom.Window:Get_Size().y * 0.33))
	Screens.WaitingRoom.Window:AddControl(panel)

	local playerReady = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\PlayerReady.png")
	local playerReadyNinepatch = Singularity.Gui.NinePatch:new(playerReady, Vector2:new(playerReady:Get_Width(), playerReady:Get_Height()), Vector4:new(0, 0, 0, 0))
	

	for i = 1, 8 do
		label = Singularity.Gui.Label:new("BluePlayer"..i)
		label:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic11 Bold"))
		label:Set_FontColor(Color:new(0,0,0,1))
		label:Set_Position(Vector2:new(0, panel:Get_Size().y * (0.125*(i-1))))
		label:Set_Size(Vector2:new(panel:Get_Size().x, panel:Get_Size().y * 0.05))
		panel:AddControl(label)
		
		image = Singularity.Gui.Image:new("BluePlayerReady"..i)
		image:Set_Texture(playerReadyNinepatch)
		image:Set_Position(Vector2:new(label:Get_Position().x + label:Get_Size().x, label:Get_Position().y))
		image:Set_Size(Vector2:new(30, 30))
		image:Set_Visible(false)
		panel:AddControl(image)
	end
	
	--Button for the arrow allowing players to move from container to container
	local blueArrowButton = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\BlueArrowButton.png")
	
	--Button for the arrow allowing players to move from container to container
	ninepatch = Singularity.Gui.NinePatch:new(blueArrowButton, Vector2:new(64, 64), Vector4:new(0, 0, 0, 0))

	local button = Singularity.Gui.Button:new("Select Blue Team Button","")
	button:Set_Texture(ninepatch)
	button:Set_Position(Vector2:new(Screens.WaitingRoom.Window:Get_Size().x * 0.45, (Screens.WaitingRoom.Window:Get_Size().y * 0.3)))
	button:Set_Size(Vector2:new(64, 64))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.WaitingRoom.MoveToBlue), "Singularity::IDelegate"))
	Screens.WaitingRoom.Window:AddControl(button)
	
	--Red Team Container
	local redTeamBackground = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\RedTeamBackground.png")
	ninepatch = Singularity.Gui.NinePatch:new(redTeamBackground, Vector2:new(redTeamBackground:Get_Width(), redTeamBackground:Get_Height()), Vector4:new(0, 0, 0, 0))

	panel = Singularity.Gui.Panel:new("Red Team Container Panel")
	panel:Set_Texture(ninepatch)
	panel:Set_Position(Vector2:new(Screens.WaitingRoom.Window:Get_Size().x * 0.555, Screens.WaitingRoom.Window:Get_Size().y * 0.545))
	panel:Set_Size(Vector2:new(Screens.WaitingRoom.Window:Get_Size().x * 0.375, Screens.WaitingRoom.Window:Get_Size().y * 0.33))
	Screens.WaitingRoom.Window:AddControl(panel)
	

	
	for i = 1, 8 do
		label = Singularity.Gui.Label:new("RedPlayer"..i)
		label:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic11 Bold"))
		label:Set_FontColor(Color:new(0,0,0,1))
		label:Set_Position(Vector2:new(0, panel:Get_Size().y * (0.125*(i-1))))
		label:Set_Size(Vector2:new(panel:Get_Size().x, panel:Get_Size().y * 0.05))
		panel:AddControl(label)
		
		
		
		image = Singularity.Gui.Image:new("RedPlayerReady"..i)
		image:Set_Texture(playerReadyNinepatch)
		image:Set_Position(Vector2:new(label:Get_Position().x + label:Get_Size().x, label:Get_Position().y))
		image:Set_Size(Vector2:new(30, 30))
		image:Set_Visible(false)
		panel:AddControl(image)
	end

	--Button for the arrow allowing players to move from container to container
	local redArrowButton = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\RedArrowButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(redArrowButton, Vector2:new(redArrowButton:Get_Width(), redArrowButton:Get_Height()), Vector4:new(0, 0, 0, 0))
	button = Singularity.Gui.Button:new("Select Red Team Button","")
	button:Set_Texture(ninepatch)
	button:Set_Position(Vector2:new(Screens.WaitingRoom.Window:Get_Size().x * 0.45, (Screens.WaitingRoom.Window:Get_Size().y * 0.65)))
	button:Set_Size(Vector2:new(64,64))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.WaitingRoom.MoveToRed), "Singularity::IDelegate"))
	Screens.WaitingRoom.Window:AddControl(button)


	--Close Button
	local closeButton = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\CloseWindowMenuButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(closeButton, Vector2:new(closeButton:Get_Width() * 0.2, closeButton:Get_Height() * 0.2), Vector4:new(0, 0, 0, 0))
	button = Singularity.Gui.Button:new("Close Button - Waiting Room", "")
	button:Set_Texture(ninepatch)
	button:Set_Position(Vector2:new((Screens.WaitingRoom.Window:Get_Size().x * 0.98) - (ninepatch:Get_Width() / 2), (Screens.WaitingRoom.Window:Get_Size().y * 0.01)))
	button:Set_Size(Vector2:new(ninepatch:Get_Width(), ninepatch:Get_Height()))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.WaitingRoom.Close), "Singularity::IDelegate"))
	Screens.WaitingRoom.Window:AddControl(button)
	
	Network.Register(Screens.WaitingRoom.Network.NextIdType, Screens.WaitingRoom.Network.NextIdMsg)
	Network.Register(Screens.WaitingRoom.Network.AcceptIdType, Screens.WaitingRoom.Network.AcceptIdMsg)
	Network.Register(Screens.WaitingRoom.Network.UpdateMatchInfoType, Screens.WaitingRoom.Network.UpdateMatchInfoMsg)
	Network.Register(Screens.WaitingRoom.Network.JoinTeamRequestType, Screens.WaitingRoom.Network.JoinTeamRequestMsg)
	Network.Register(Screens.WaitingRoom.Network.ReadyRequestType, Screens.WaitingRoom.Network.ReadyRequestMsg)

	Util.Debug("Screens[\"Waiting Room\"] loaded")
end

-- End Initialize











-- WaitingRoom Functions
Screens.WaitingRoom.UpdateMatchInformation = function(match)

	Screens.WaitingRoom.Match = match
	
	if (Screens.WaitingRoom.Match.StartGame == true and not Screens.WaitingRoom.Client.Host) then
		Screens.WaitingRoom.GoToGame()
	end
	
	local control = tolua.cast (Screens.GuiScreen:GetControl("Game Name Label - Waiting Room"), "Singularity::Gui::Label")
	control:Set_Text(Screens.WaitingRoom.Match.MatchName)
	control = tolua.cast (Screens.GuiScreen:GetControl("Game Name Definition Label - Waiting Room"), "Singularity::Gui::Label")
	control:Set_Text(Screens.WaitingRoom.Match.MatchType)
	control = tolua.cast (Screens.GuiScreen:GetControl("Win Condition Label - Waiting Room"), "Singularity::Gui::Label")
	if (matchtype == "Assault") then
		control:Set_Text("Time Limit")
	elseif (matchtype == "King of the Hill") then
		control:Set_Text("Capture Limit")
	elseif (matchtype == "Deathmatch") then
		control:Set_Text("Kills")
	end
	control = tolua.cast (Screens.GuiScreen:GetControl("Win Conditions Definition Label - Waiting Room"), "Singularity::Gui::Label")
	control:Set_Text(Screens.WaitingRoom.Match.Condition.WinningScore)
	
end

Screens.WaitingRoom.CreateMatch = function(matchname, matchtype, matchvalue, hostname, host) -- can be called via join or create
	

	--Screens.WaitingRoom.Client = Screens.WaitingRoom.CreatePlayer(playerid, playername, false, host)
		
	-- SEND ID # AS WELL (given at Join or Create)

	--Screens.WaitingRoom.MyID = playerid
	
	Util.Debug(matchvalue)
	
	Util.Debug(matchname)
	Util.Debug(matchtype)
	Util.Debug(matchvalue)
	
	Screens.WaitingRoom.Match.MatchName = matchname
	Screens.WaitingRoom.Match.MatchType = matchtype
	Screens.WaitingRoom.Match.Condition.WinningScore = matchvalue
	
	--Screens.WaitingRoom.Match.MatchType = "Assault"
	--Screens.WaitingRoom.Match.Condition.WinningScore = 60	--Time Limit
	

	--Util.Debug(playerid) -- playerid will get assigned later
	
	Screens.WaitingRoom.Client.Host = host
	
	--Screens.WaitingRoom.Client = Singularity.Networking.Network:CurrentPlayer()
	if (host) then
		--Screens.WaitingRoom.Client.Name = playername
		Screens.WaitingRoom.Client.Id = 1
		Singularity.Networking.Network:Set_CurrentPlayerName(hostname)
		Singularity.Networking.Network:Set_CurrentPlayerId(1)
		Screens.WaitingRoom.AddPlayerToGame(Screens.WaitingRoom.Client) -- for hosts
	end
	
	Screens.WaitingRoom.UpdateMatchInformation(Screens.WaitingRoom.Match) -- redundant send :/

	--Screens.WaitingRoom.UpdateTeamLists()
	
end

Screens.WaitingRoom.Activate = function()
	if(Screens.WaitingRoom.Window ~= nil) then
		Screens.WaitingRoom.Window:Set_Visible(true)
		Util.Debug("Activating Waiting Room")
		
		if(Screens.WaitingRoom.Binder == nil and Screens.WaitingRoom.Client.Host) then
			Screens.WaitingRoom.Binder = Singularity.Scripting.LuaBinder:new("Screens.WaitingRoom.Update")
			Screens.WaitingRoom.Binder:Set_FunctionName("Screens.WaitingRoom.Update")
			Main.Root:AddComponent(Screens.WaitingRoom.Binder)
		end
		
		Screens.WaitingRoom.Client.Name = Singularity.Networking.Network:CurrentPlayer().Name
		
	end
	

end

Screens.WaitingRoom.Deactivate = function()
	if(Screens.WaitingRoom.Window ~= nil) then
		Screens.WaitingRoom.Window:Set_Visible(false)
	end
end

Screens.WaitingRoom.Ready = function()
	Util.Debug("Waiting Room Ready Clicked")
	Audio.MenuEmitter:Play(1)
	if (not Network.NetworkGame) then
		Util.Debug("No game found.")
		return
	end
	
	--Screens.Spawn.Activate()
	
	if (Screens.WaitingRoom.Client.Host) then
		for k,team in pairs(Screens.WaitingRoom.Match.Teams) do -- each team
			for k2,player in pairs(team) do
				if (player.Id == Screens.WaitingRoom.Client.Id) then
					player.Ready = not player.Ready
				end
			end
		end
		Screens.WaitingRoom.UpdateTeamControls()
	else
		Network.SendReliable(Screens.WaitingRoom.Network.ReadyRequestType, { Id = Screens.WaitingRoom.Client.Id })
	end
	
	
	
	--TEMPORARY
	Util.Debug(Screens.WaitingRoom.Host)
	Util.Debug(Screens.WaitingRoom.Client.Id)

	
end

Screens.WaitingRoom.GoToGame = function()

	local control = Screens.GuiScreen:GetControl("Start Button")
	control = tolua.cast (control, "Singularity::Gui::Button")

	if(not control:Get_Visible() and not Screens.WaitingRoom.Match.StartGame) then -- if they just clicked it, ignore them and don't start the game
		return
	end

	if (Screens.WaitingRoom.Client.Host) then
		Screens.WaitingRoom.Match.StartGame = true
		Screens.WaitingRoom.TimerEnabled = false
		Util.Debug("SEND")
		Network.SendReliable(Screens.WaitingRoom.Network.UpdateMatchInfoType, Screens.WaitingRoom.Match)
		Screens.WaitingRoom.UpdateMatchInformation(Screens.WaitingRoom.Match)
	end
	
	Screens.GameLoading.Activate()

	--Check to see if any of the other windows are active
	if(Screens.FindServer.Window:Get_Visible()) then
		Screens.FindServer.Deactivate()
	end
	
	if(Screens.CreateServer.Window:Get_Visible()) then
		Screens.CreateServer.Deactivate()
	end
	
	if(Screens.Options.Window:Get_Visible()) then
		Screens.Options.Deactivate()
	end
	
	if(Screens.TitleScreen.Window:Get_Visible()) then
		Screens.TitleScreen.Deactivate()
	end
	
	if(Screens.Credits.Window:Get_Visible()) then
		Screens.Credits.Deactivate()
	end
	
	if(Screens.Intro.Window:Get_Visible()) then
		Screens.Intro.Deactivate()
	end
	
	
	
	local teamid = nil
	
	for k,team in pairs(Screens.WaitingRoom.Match.Teams) do -- each team
	
		for teamnum,luaplayer in pairs(team) do -- each player in team v
			if (luaplayer.Id == Screens.WaitingRoom.Client.Id) then
				if(team == Screens.WaitingRoom.Match.Teams.RedTeam) then
					teamid = PLAYER_TEAM_RED
				elseif (team == Screens.WaitingRoom.Match.Teams.BlueTeam) then
					teamid = PLAYER_TEAM_BLUE
				end
			end
		end
	end
	
	Screens.WaitingRoom.Deactivate()
	Main.GamePlay.StartGame(Screens.WaitingRoom.Client.Host, Screens.WaitingRoom.Client.Id, teamid, Screens.WaitingRoom.Match.MatchType, Screens.WaitingRoom.Match.Condition)
	
end

Screens.WaitingRoom.AddPlayerToGame = function(player) -- for hosts

	if (Screens.WaitingRoom.Client.Host) then -- nobody can add but the host. haHA!
		--Util.Debug("Adding")
		Screens.WaitingRoom.MovePlayer(player, Screens.WaitingRoom.Match.Teams.NeutralTeam) -- what about their ip?
	end
	

end

Screens.WaitingRoom.MovePlayer = function(player, teamTo) -- for hosts



	if (#teamTo < 8) then
	
		-- still need to check the team size first
		if (teamTo == Screens.WaitingRoom.NeutralTeam) then 
			table.insert(teamTo, player)
			return
		end
	
		player.Ready = false
		for k,team in pairs(Screens.WaitingRoom.Match.Teams) do -- each team
		
			for teamnum,luaplayer in pairs(team) do -- each player in team v
				if (luaplayer.Id == player.Id) then
					Screens.WaitingRoom.RemovePlayer(teamnum, team)
				end
			end
			
		end
		
		table.insert(teamTo, player)
		--Util.Debug("Added")
	end

end

Screens.WaitingRoom.RemovePlayer = function(position, teamFrom) -- for hosts

		table.remove(teamFrom, position)

end

Screens.WaitingRoom.MoveToBlue = function() -- for clients
	Util.Debug("Moved to Blue")
	Audio.MenuEmitter:Play(2)
	--test
	if (Screens.WaitingRoom.Client.Host) then
		Screens.WaitingRoom.MovePlayer(Screens.WaitingRoom.Client, Screens.WaitingRoom.Match.Teams.BlueTeam)
		Screens.WaitingRoom.UpdateTeamLists()
	else
		Network.SendReliable(Screens.WaitingRoom.Network.JoinTeamRequestType, Screens.WaitingRoom.Network.BuildJoinTeamRequestTable("Blue"))
	end
	--test

	
	-- move myID to blue if it's free
	-- tell the host I moved

end

Screens.WaitingRoom.MoveToRed = function() -- for clients
	Util.Debug("Moved to Red")
	Audio.MenuEmitter:Play(2)
	if (Screens.WaitingRoom.Client.Host) then
		Screens.WaitingRoom.MovePlayer(Screens.WaitingRoom.Client, Screens.WaitingRoom.Match.Teams.RedTeam)
		Screens.WaitingRoom.UpdateTeamLists()
	else
		Network.SendReliable(Screens.WaitingRoom.Network.JoinTeamRequestType, Screens.WaitingRoom.Network.BuildJoinTeamRequestTable("Red"))
	end
	
	--Network.SendReliable(Screens.WaitingRoom.JoinTeamRequestType, Screens.WaitingRoom.BuildJoinTeamRequestTable("Red")
	-- move myID to red if it's free
	-- tell the host I moved
end

Screens.WaitingRoom.Close = function()
	Util.Debug("Close Clicked")
	-- leave the room and tell everybody / host that you're leaving
	Audio.MenuEmitter:Play(1)
	Screens.WaitingRoom.Deactivate()
	
end

Screens.WaitingRoom.Update = function(sender, elapsed)
	-- here we need to tell people that we have started a game if we're the host
	-- we also need to update the lists

	Network.Send(Screens.WaitingRoom.Network.NextIdType, { UserId = Screens.WaitingRoom.CurrentBroadcastId })
	
	if (Screens.WaitingRoom.TimerEnabled) then
		Screens.WaitingRoom.Timer = Screens.WaitingRoom.Timer + elapsed
	end
	if (Screens.WaitingRoom.Timer > 0.1) then -- ms
		Network.SendReliable(Screens.WaitingRoom.Network.UpdateMatchInfoType, Screens.WaitingRoom.Match)
		Screens.WaitingRoom.Timer = 0
		Screens.WaitingRoom.UpdateTeamLists()
		
		if(#Screens.WaitingRoom.Match.Teams.NeutralTeam == 0) then
			local allready = true
			for k,team in pairs(Screens.WaitingRoom.Match.Teams) do -- each team
				for k2,player in pairs(team) do
					if (not player.Ready) then
						allready = false
					end
				end
			end
			
			local control = Screens.GuiScreen:GetControl("Start Button")
			control = tolua.cast (control, "Singularity::Gui::Button")
			
			if (allready and Screens.WaitingRoom.Client.Host) then
				control:Set_Visible(true)
			else
				control:Set_Visible(false)
			end
		end

		Util.Debug("Ping. Ping.")
	end

end

Screens.WaitingRoom.UpdateTeamLists = function()
	
	
	numberplayers, players = Network.NetworkGame:GetPlayers(0)
	--Util.Debug (numberplayers)
	--Util.DumpTable(players)
	
	-- Clean out any players that don't actually exist anymore.
	local playerexists = false
	
	-- bad sela. try again.
	
	-- logic for this: we need to parse through the list of actual players and see if they're in the network. much cleaner.
	
	for k, team in pairs(Screens.WaitingRoom.Match.Teams) do
		for teamnum, luaplayer in pairs(team) do
			playerexists = false
			for networkplayers, networkplayer in pairs(players) do
				Util.Debug(networkplayer.PlayerId)
				if (luaplayer.Id == networkplayer.PlayerId) then
					playerexists = true
				end
			end
			if (not playerexists) then
				Util.Debug("Goodbye, "..luaplayer.Id)
				Screens.WaitingRoom.RemovePlayer(teamnum, team)
			end
		end
	end
	
	
	--[[
	for players, networkplayer in pairs(players) do
		playerexists = false -- default assumption
		for teamList, team in pairs(Screens.WaitingRoom.Match.Teams) do
			for luaPlayerRepresentation, luaplayer in pairs(team) do
				if (luaplayer.Id == networkplayer.Id) then
					Util.Debug("found player: "..networkplayer.Id)
					playerexists = true
				end
			end
		end
		-- if we don't have it, remove it
		if (not playerexists) then
			for k,team in pairs(Screens.WaitingRoom.Match.Teams) do -- each team
				for teamnum,luaplayer in pairs(team) do -- each player in team v
					if (luaplayer.Id == player.Id) then
						Screens.WaitingRoom.RemovePlayer(teamnum, team)
					end
				end
			
			end
		end
	end
	
	--]]
	

	
	--[[
	
	local playerexists = false
	
	Util.Debug("Number of players: "..numberplayers)
	for k,networkplayer in pairs(players) do
		playerexists = false -- each player
		Util.Debug(networkplayer.PlayerId)
		Util.Debug(Screens.WaitingRoom.Client.Id)
		if (networkplayer.PlayerId == Screens.WaitingRoom.Client.Id) then
			Util.Debug("found player: "..networkplayer.PlayerId)
			playerexists = true
		end
		--Util.Debug (v.Id)
		for k2,team in pairs(Screens.WaitingRoom.Match.Teams) do -- each team
			for k3,luaplayer in pairs(team) do -- not as inefficient as it looks; essentially we're just looking at all the players we have in the game once 
				-- each player in team
				if (luaplayer.Id == networkplayer.Id) then
					Util.Debug("found player: "..networkplayer.Id)
					playerexists = true
				end
			end
		end
		if (not playerexists) then
			Util.Debug("didn't find player")
			--Screens.WaitingRoom.AddPlayerToGame(networkplayer)
		end
	end
	--]]
	Screens.WaitingRoom.UpdateTeamControls()
	
end

Screens.WaitingRoom.UpdateTeamControls = function()

	Util.Debug("Updating team lists.")
	local control
	local readycontrol
	for i = 1, 8 do
	
		-- Red team
		control = Screens.GuiScreen:GetControl("RedPlayer"..i)
		control = tolua.cast (control, "Singularity::Gui::Label")
		
		readycontrol = Screens.GuiScreen:GetControl("RedPlayerReady"..i)
		readycontrol = tolua.cast (readycontrol, "Singularity::Gui::Image")
		
		if (Screens.WaitingRoom.Match.Teams.RedTeam[i] ~= nil) then
			--Util.Debug("Red Added.")
			control:Set_Text(Screens.WaitingRoom.Match.Teams.RedTeam[i].Name)
			if (Screens.WaitingRoom.Match.Teams.RedTeam[i].Ready) then
				readycontrol:Set_Visible(true)
			else
				readycontrol:Set_Visible(false)
			end
		else
			control:Set_Text("")
			readycontrol:Set_Visible(false)
		end
		
		-- Blue team
		control = Screens.GuiScreen:GetControl("BluePlayer"..i)
		control = tolua.cast (control, "Singularity::Gui::Label")
		
		readycontrol = Screens.GuiScreen:GetControl("BluePlayerReady"..i)
		readycontrol = tolua.cast (readycontrol, "Singularity::Gui::Image")

		if (Screens.WaitingRoom.Match.Teams.BlueTeam[i] ~= nil) then
			control:Set_Text(Screens.WaitingRoom.Match.Teams.BlueTeam[i].Name)
			--Util.Debug("Blue Added.")
			if (Screens.WaitingRoom.Match.Teams.BlueTeam[i].Ready) then
				readycontrol:Set_Visible(true)
			else
				readycontrol:Set_Visible(false)
			end
		else
			control:Set_Text("")
			readycontrol:Set_Visible(false)
		end
	end
	
	-- Neutral update
	
	for i = 1, 16 do
		control = Screens.GuiScreen:GetControl("NeutralPlayer"..i)
		control = tolua.cast (control, "Singularity::Gui::Label")
		if (Screens.WaitingRoom.Match.Teams.NeutralTeam[i] ~= nil) then
			--Util.Debug("Neutral Added.")
			control:Set_Text(Screens.WaitingRoom.Match.Teams.NeutralTeam[i].Name)
		else
			control:Set_Text("")
		end
	end
end

Screens.WaitingRoom.Network =
{
	
	-- Players in the network will be found locally. The host needs to manage the teams, player ready states, and the match position.
	-- We'll start as soon as everybody clicks "ready". We need a signifier.
	
	NextIdType = "W1",
	AcceptIdType = "W2",
	UpdateMatchInfoType = "W3",
	JoinTeamRequestType = "W4",
	ReadyRequestType = "W5",
	NextIdMsg = function(value)
	
	if (not Screens.WaitingRoom.Client.Host) then
		--Util.Debug("NextIdMsg")
		if (Screens.WaitingRoom.Client.Id == -1) then
			Singularity.Networking.Network:Set_CurrentPlayerId(value.UserId)
			local player = Singularity.Networking.Network:CurrentPlayer()
			Screens.WaitingRoom.Client.Id = player.PlayerId
			Screens.WaitingRoom.Client.Name = player.Name
			Network.SendReliable(Screens.WaitingRoom.Network.AcceptIdType, Screens.WaitingRoom.Client)
		end		
	end
		
	end,
	AcceptIdMsg = function(value) -- takes in the player
	
		Util.Debug("AcceptIdMsg")
		Util.DumpTable(value)
		if (Screens.WaitingRoom.Client.Host) then
			Screens.WaitingRoom.AddPlayerToGame(value)
			Screens.WaitingRoom.CurrentBroadcastId = Screens.WaitingRoom.CurrentBroadcastId + 1
			Network.SendReliable(Screens.WaitingRoom.Network.UpdateMatchInfoType, Screens.WaitingRoom.Match)
		end
		
	end,
	UpdateMatchInfoMsg = function(value)
		if (not Screens.WaitingRoom.Client.Host) then
			Screens.WaitingRoom.UpdateMatchInformation(value)
			Screens.WaitingRoom.UpdateTeamControls()
		end
		-- tell the non-hosts that they need to update match information (type, conditions, name)
	end,
	JoinTeamRequestMsg = function(value)
	
		Util.Debug("JoinTeamRequestMsg")
		Util.DumpTable(value)
		if (Screens.WaitingRoom.Client.Host) then
			for k,team in pairs(Screens.WaitingRoom.Match.Teams) do
				for k2,player in pairs(team) do
					if (player.Id == value.Id) then
						Util.Debug("found")
						if (value.Team == "Red") then
							Util.Debug("Red.")
							Screens.WaitingRoom.MovePlayer(player, Screens.WaitingRoom.Match.Teams.RedTeam)
						elseif (value.Team == "Blue") then
							Util.Debug("Blue.")
							Screens.WaitingRoom.MovePlayer(player, Screens.WaitingRoom.Match.Teams.BlueTeam)
						end
					end
				end
			end
			Network.SendReliable(Screens.WaitingRoom.Network.UpdateMatchInfoType, Screens.WaitingRoom.Match)
		end
		--send update team
		-- tell the host I want to join a certain team
	end,
	ReadyRequestMsg = function(value)
		Util.Debug("ReadyRequestMsg")
		if (Screens.WaitingRoom.Client.Host) then
			for k,team in pairs(Screens.WaitingRoom.Match.Teams) do
				for k2,player in pairs(team) do
					if (player.Id == value.Id) then
						player.Ready = not player.Ready
					end
				end
			end			
			Network.SendReliable(Screens.WaitingRoom.Network.UpdateMatchInfoType, Screens.WaitingRoom.Match)
		end
		--Network.SendReliable(Screens.WaitingRoom.UpdateMatchInfoType, Screens.WaitingRoom.Match)
		-- tell the host that I'm ready!
	end,
	BuildUpdateTeamTable = function()
	
		local ret
		ret = Screens.WaitingRoom.Match.Teams
		return ret
		-- send call to update all players.
	end,
	BuildNextIdTable = function()
	
		local ret =
		{
			UserId = Screens.WaitingRoom.CurrentBroadcastId 
		}
		return ret
		-- send id and ready state
		-- should be acquired through the teams list
	end,
	BuildUpdateMatchTable = function()
	
		--local ret
		--ret = Screens.WaitingRoom.MatchInfo
		--return ret
		-- send match information
	end,
	BuildJoinTeamRequestTable = function(team) -- "Red" "Blue"
	
		local ret
		ret = 
		{
			Id = Screens.WaitingRoom.Client.Id,
			Team = team,
		}
		return ret
		-- send call to move a player
	end,
	BuildReadyRequestType = function()
	
		local ret
		ret = 
		{
			--Ready = Screens.WaitingRoom.Client.Ready
			Id = Screens.WaitingRoom.Client.Id,
		}
	end
}