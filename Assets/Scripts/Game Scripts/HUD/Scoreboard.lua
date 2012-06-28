local BOARD_WIDTH = 550
local BOARD_HEIGHT = 550

local BOARD_IMAGE_WIDTH = 1024
local BOARD_IMAGE_HEIGHT = 1024

local ROW_HEIGHT = 30
local ROW_SPACING = 10

local NAME_COL_WIDTH = BOARD_WIDTH * 0.24
local KILL_COL_WIDTH = BOARD_WIDTH * 0.05
local DEATH_COL_WIDTH = BOARD_WIDTH * 0.05

local FONT = Singularity.Gui.Font:Get_Font("Franklin Gothic11 Bold")
local UPDATE_TIME = 1

local Input = Singularity.Inputs.Input

Scoreboard = {}

Scoreboard.RedTeam = {}
Scoreboard.BlueTeam = {}
--Force first update
Scoreboard.Elapsed = UPDATE_TIME
Scoreboard.Enabled = false

Scoreboard.BackgroundNinePatch = Singularity.Gui.NinePatch:new(Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\Scoreboard.png"), Vector2:new(BOARD_IMAGE_WIDTH, BOARD_IMAGE_HEIGHT), Vector4:new(0, 0, 0, 0))

Scoreboard.Build = function(parent, dim, maxPlayersPerTeam)

	BOARD_WIDTH = dim
	BOARD_HEIGHT = dim

	local parentSize = parent:Get_Size()
	Scoreboard.RootPosition = Vector2:new(parentSize.x*0.5 - BOARD_WIDTH*0.5, parentSize.y*0.5 - BOARD_HEIGHT*0.5)
	Scoreboard.MaxPlayersPerTeam = maxPlayersPerTeam
	
	--Frame
	Scoreboard.Frame = Singularity.Gui.Panel:new("Score Panel")
	Scoreboard.Frame:Set_Visible(false)
	Scoreboard.Frame:Set_Size(Vector2:new(BOARD_WIDTH, BOARD_HEIGHT))
	Scoreboard.Frame:Set_Position(Scoreboard.RootPosition)
	Scoreboard.Frame:Set_Texture(Scoreboard.BackgroundNinePatch)
	parent:AddControl(Scoreboard.Frame)
	
	--Positioning anchors
	Scoreboard.RedNameRoot = Vector2:new(BOARD_WIDTH *0.06, BOARD_HEIGHT * 0.25)
	Scoreboard.RedKillRoot = Vector2:new(BOARD_WIDTH *0.33, BOARD_HEIGHT * 0.25)
	Scoreboard.RedDeathRoot = Vector2:new(BOARD_WIDTH *0.4, BOARD_HEIGHT * 0.25)
	Scoreboard.BlueNameRoot = Vector2:new(BOARD_WIDTH *0.56, BOARD_HEIGHT * 0.25)
	Scoreboard.BlueKillRoot = Vector2:new(BOARD_WIDTH *0.82, BOARD_HEIGHT * 0.25)
	Scoreboard.BlueDeathRoot = Vector2:new(BOARD_WIDTH *0.89, BOARD_HEIGHT * 0.25)
	
	--Red
	for i = 1,maxPlayersPerTeam do	
		table.insert(Scoreboard.RedTeam, Scoreboard.BuildRow(Scoreboard.Frame, i, "Red"))		
	end
	
	--Blue
	for i = 1,maxPlayersPerTeam do	
		table.insert(Scoreboard.BlueTeam, Scoreboard.BuildRow(Scoreboard.Frame, i, "Blue"))		
	end
	
end

Scoreboard.Enable = function()
	Scoreboard.Enabled = true
	Scoreboard.Frame:Set_Visible(true)
end

Scoreboard.Disable = function()
	Scoreboard.Enabled = false
	Scoreboard.Frame:Set_Visible(false)
end

--Build a row in the scoreboard
Scoreboard.BuildRow = function(frame, index, team)

	local row = {}

	local nameRoot = Scoreboard[team.."NameRoot"]
	local killRoot = Scoreboard[team.."KillRoot"]
	local deathRoot = Scoreboard[team.."DeathRoot"]
	
	--Name Label
	local label = Singularity.Gui.Label:new("Player Name", "Boo")
	label:Set_Font(FONT)
	label:Set_Size(Vector2:new(NAME_COL_WIDTH, ROW_HEIGHT))
	label:Set_Position(Vector2:new(nameRoot.x, nameRoot.y + (index-1)*(ROW_HEIGHT + ROW_SPACING)))
	
	frame:AddControl(label)
	row.Name = label
	
	--Kills Label
	label = Singularity.Gui.Label:new("Player Kills", "12")
	label:Set_Font(FONT)
	label:Set_Size(Vector2:new(NAME_COL_WIDTH, ROW_HEIGHT))
	label:Set_Position(Vector2:new(killRoot.x, killRoot.y + (index-1)*(ROW_HEIGHT + ROW_SPACING)))
	
	frame:AddControl(label)
	row.Kills = label
	
	--Deaths Label
	label = Singularity.Gui.Label:new("Player Deaths", "12")
	label:Set_Font(FONT)
	label:Set_Size(Vector2:new(NAME_COL_WIDTH, ROW_HEIGHT))
	label:Set_Position(Vector2:new(deathRoot.x, deathRoot.y + (index-1)*(ROW_HEIGHT + ROW_SPACING)))
	
	frame:AddControl(label)
	row.Deaths = label
	
	return row

end

Scoreboard.Update = function(elapsed)

	if(Scoreboard.Enabled) then	
		--display on tab
		local tabDown = Input:IsKeyDown(DIK_TAB)
		Scoreboard.Frame:Set_Visible(tabDown)
		Scoreboard.Frame:Set_Depth(0.05)
		
		Scoreboard.Elapsed = Scoreboard.Elapsed + elapsed
			
		--only update every so often
		if(Scoreboard.Elapsed > UPDATE_TIME) then	
		
			Scoreboard.Elapsed = 0
		
			local redIndex = 1
			local blueIndex = 1
			local row
			
			local players = {}
			for k,v in pairs(Main.GamePlay.Players) do
				table.insert(players, v)
			end
			
			local sortOrder = {}
			for i = 1,#players do
				sortOrder[i] = i
			end			
			
			--sort on top of the array
			for i = 1,#players do
				for j = i+1,#Main.GamePlay.Players do
					if players[sortOrder[j]].Kills > players[sortOrder[i]].Kills then
						local temp = sortOrder[i]
						sortOrder[i] = sortOrder[j]
						sortOrder[j] = temp
					end
				end
			end

			for i = 1, #players do
				--get the players in descending order of kills
				local player = players[sortOrder[i]]
				--place the player on their team's side
				if(player.Team == PLAYER_TEAM_RED) then
					row = Scoreboard.RedTeam[redIndex]
					redIndex = redIndex + 1
				else
					row = Scoreboard.BlueTeam[blueIndex]
					blueIndex = blueIndex + 1
				end
				
				--update and show the row
				row.Name:Set_Visible(true)
				row.Name:Set_Text(player.Name)
				row.Kills:Set_Visible(true)
				row.Kills:Set_Text(player.Kills)
				row.Deaths:Set_Visible(true)
				row.Deaths:Set_Text(player.Deaths)
			end
			
			--hide all remaining rows
			for i = redIndex, Scoreboard.MaxPlayersPerTeam do
				row = Scoreboard.RedTeam[i]
				row.Name:Set_Visible(false)
				row.Kills:Set_Visible(false)
				row.Deaths:Set_Visible(false)
			end
			
			for i = blueIndex, Scoreboard.MaxPlayersPerTeam do
				row = Scoreboard.BlueTeam[i]
				row.Name:Set_Visible(false)
				row.Kills:Set_Visible(false)
				row.Deaths:Set_Visible(false)
			end
		end
	end
end