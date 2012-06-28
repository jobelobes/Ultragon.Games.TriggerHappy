Main.GamePlay = {}

local Input = Singularity.Inputs.Input

Main.GamePlay.PauseKeyDown = false
Main.GamePlay.KillKeyDown = false
Main.GamePlay.LevelLoaded = false

--match details
Match = {}
Match.SpawnPoints = {}	--loaded from current match type's predefined spawn points at the start of the match
Match.ControlPoints = {}
Match.CurrentControlPoint = nil
Match.CurrentControlPointIndex = 0

Main.GamePlay.States =
{
	PreGame = {
		Activate = function(self)
			Util.Debug("Pregame State")
			
			
			Util.Debug("Build Level")
			if (not Main.GamePlay.LevelLoaded) then
				Main.GamePlay.BuildLevel()
				Main.GamePlay.LevelLoaded = true
			end
			
			Util.Debug("Build Client Player")
			--Player.CreateClient(2, "Chip", PLAYER_TEAM_RED, Vector3:new(0,0,0), Vector3:new(1, 0, 1))
			Player.CreateClient(Main.GamePlay.ClientID, Screens.WaitingRoom.Client.Name, Main.GamePlay.Team, Vector3:new(0,0,0), Vector3:new(1, 0, 1))
			
			--Util.Debug("Restoring Client")
			Player.Client:Restore()
			Util.Debug("Setting up Network IDs")			
			--Setup Reliable sequence numbers
			local id = 1
			Util.Debug(Main.GamePlay.ClientID)
			--Network.SetIDs(0*10000, 0*10000 + 9999)
			Network.SetIDs(Main.GamePlay.ClientID*10000, Main.GamePlay.ClientID*10000 + 9999)
			
			Player.Enable()
							
			--Enable HUD
			Util.Debug("Enable HUD")
			Player.HUD.HPBar:SetSource(Player.Client)
			Player.HUD.EnergyBar:SetSource(Player.Client)

			Util.Debug("Number of players: "..table.getn(Main.GamePlay.Players))
			if(Main.GamePlay.GameType == "KotH") then
				Util.Debug("Running KotH")
				KotH.Running = true
			elseif(Main.GamePlay.GameType == "Assault") then
				Util.Debug("Running Assault")
				Assault.Running = true
			elseif(Main.GamePlay.GameType == "Deathmatch") then
				Util.Debug("Running Deathmatch")
				Deathmatch.Running = true
			end
			
			Main.GamePlay.ChangeState(Main.GamePlay.States.StartGame)
		end,
		Process = function(self, elapsed)
		end,
	},
	StartGame = { 
		Activate = function(self)
			Util.Debug("StartGame State")
			Player.Camera.Deactivate()
			Player.HUD.Disable()
			Weapon.Disable()
			Projectile.Disable()
			Modifier.Disable()
			--Pop Up Weapon/Mod Chooser
			Screens.GameLoading.Deactivate()
			Screens.WeaponSelection.Activate()
		end,
		
		Process = function(self, elapsed)
	
		end,
	},
	Alive = {
		Activate = function(self)
			Util.Debug("Alive State")
			
			Player.Client:Restore()
						
			Player.Camera.Activate()
			Player.HUD.Enable()
			Weapon.Enable()
			Projectile.Enable()
			Modifier.Enable()
			Achievement.Enable()
		end,
		Process = function(self, elapsed)
			if(Player.Client.State == PLAYER_STATE_DEAD) then
				Main.GamePlay.ChangeState(Main.GamePlay.States.Dead)
			end
		end,
	},
	Dead = {
		Activate = function(self)
			Util.Debug("Dead State")
			
			Player.Camera.Deactivate()
			Player.HUD.Disable()
			Weapon.Disable()
			Projectile.Disable()
			Modifier.Disable()
			Achievement.Disable()
			
			--Pop Up Weapon/Mod Chooser
			Screens.Spawn.Activate()
		end,
		Process = function(self, elapsed)			
		end,
	},
	PostGame = {
		Activate = function(self)
			Player.Camera.Deactivate()
			Player.HUD.Disable()
			Weapon.Disable()
			Projectile.Disable()
			Modifier.Disable()
			Achievement.Disable()
			
			--Disabling any additional screens so only the win screen is shown
			Screens.WeaponSelection.Deactivate()
			Screens.ModifierSelection.Deactivate()
			Screens.PauseMenu.Deactivate()
			Screens.GameLoading.Deactivate()
			Screens.Spawn.Deactivate()
			Screens.WinScreen.Activate()
		end,
		Process = function(self, elapsed)
		end,
	},
	Pause = {
		Activate = function(self)
			Player.Camera.Deactivate()
			Player.HUD.Disable()
			Weapon.Disable()
			Projectile.Disable()
			Modifier.Disable()
		end,
		Process = function(self, elapsed)
		end,
	}
}

--General Functions
----------------------
Main.GamePlay.Initialize = function()

	Util.Debug("Initializing Gameplay")
	
	Player.Initialize()
	Player.HUD.Initialize()
	
	--Binder
	local binder = Singularity.Scripting.LuaBinder:new("Gameplay Update")
	binder:Set_FunctionName("Main.GamePlay.Update")
	Main.Root:AddComponent(binder)
	
	Main.GamePlay.State = nil
	
	Util.Debug("Initializating GamePlay Complete.")
end

Main.GamePlay.StartGame = function(host, ID, team, gameType, gameParameters)
	
	Main.Started = true
	
	Screens.Deactivate()
	
	--Are we the host?
	Main.GamePlay.Host = host
	Main.GamePlay.Team = team
	Main.GamePlay.GameStarted = true	
	Main.GamePlay.ClientID = ID
	Main.GamePlay.GameType = gameType
	
	--Defaults
	Main.GamePlay.Players = {}
	Main.GamePlay.Lights = {}
	Main.GamePlay.GameStarted = true
	Main.GamePlay.State = nil
	Main.GamePlay.GameType = gameType
	
	if(Main.GamePlay.GameType == "KotH") then
		Util.Debug("King of the Hill time!")
		KotH.Start(Main.GamePlay.GameOver, host, (host and gameParameters.WinningScore or nil))
	elseif(Main.GamePlay.GameType == "Assault") then
		Util.Debug("Assault time!")
		Assault.Start(Main.GamePlay.GameOver, host, (host and gameParameters.WinningScore or nil))
	elseif(Main.GamePlay.GameType == "Deathmatch") then
		Util.Debug("Deathmatch time!")
		Deathmatch.Start(Main.GamePlay.GameOver, host, (host and gameParameters.WinningScore or nil))
	else
		Util.Debug("Invalid game type passed in")
	end
			
	Util.Debug("Main.GamePlay changing to PreGames state")
	
	Main.GamePlay.ChangeState(Main.GamePlay.States.PreGame)
	
	Util.Debug("Main.GamePlay.StartGame complete")
end

Main.GamePlay.GameOver = function(winningTeam)
	Screens.WinScreen.SetWinningTeam(winningTeam)
	Main.GamePlay.ChangeState(Main.GamePlay.States.PostGame)   
end

Main.GamePlay.EndGame = function()
	
	Player.Disable()
	Player.Camera.Deactivate()
	Player.HUD.Disable()
	Weapon.Disable()
	Projectile.Disable()
	Modifier.Disable()
	
	--Singularity.Networking.Network:LeaveGame()

	Main.GamePlay.State = nil
	Screens.Activate()
	Screens.TitleScreen.Activate()
	
	Main.Started = false
	Main.GamePlay.Players = {}
	Main.GamePlay.Lights = {}
	Main.GamePlay.GameStarted = false
	
end

Main.GamePlay.ChangeState = function(state)
	Main.GamePlay.State = state
	state:Activate()
end

Main.GamePlay.Update = function(sender, elapsed)
	if(Main.GamePlay.GameStarted) then
		if(Main.GamePlay.State) then
			Main.GamePlay.State:Process(elapsed)
		end
	end
	Main.GamePlay.UpdateNetwork()
	if(Main.GamePlay.GameType == "KotH") then
		KotH.Update(elapsed)
	elseif(Main.GamePlay.GameType == "Assault") then
		Assault.Update(elapsed)
	elseif(Main.GamePlay.GameType == "Deathmatch") then
		Deathmatch.Update(elapsed)
	end
	Main.GamePlay.Level.Update(sender, elapsed)
	
	if (Singularity.Inputs.Input:IsKeyDown(DIK_P)) then
		if(Main.Started and not Main.GamePlay.PauseKeyDown) then
			if (not Screens.PauseMenu.Window:Get_Visible()) then
				-- make sure we're not on modifier selection, weapon selection, or spawn
				if (not Screens.ModifierSelection.Window:Get_Visible() and not Screens.WeaponSelection.Window:Get_Visible() and not Screens.Spawn.Window:Get_Visible()) then
					Screens.PauseMenu.Activate()
					Player.Camera.Deactivate()
					Weapon.Disable()
				end
			else
				Screens.PauseMenu.Deactivate()
				Player.Camera.Activate()
				Weapon.Enable()
			end
		end
		Main.GamePlay.PauseKeyDown = true
	else
		Main.GamePlay.PauseKeyDown = false
	end	
	
	if (Singularity.Inputs.Input:IsKeyDown(DIK_K)) then
		if(Main.Started and not Main.GamePlay.KillKeyDown) then
			Player.Client:TakeDamage(999, Player.Client)
		end
		Main.GamePlay.KillKeyDown = true
	else
		Main.GamePlay.KillKeyDown = false
	end	
	
end

Main.GamePlay.UpdateNetwork = function()
	
end
--------------End

--Pregame Functions-------
-------------------------------
Main.GamePlay.Level = 
{
	AnimationTest = 
	{
		GameObject = nil,		
		RadiusSqr = 0.1,
		Initialize = function(importer)
			Main.GamePlay.Level.AnimationTest.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\AnimBox.smurf", importer)
			Main.GamePlay.Level.AnimationTest.GameObject:Set_IsActive(false)
			
			--Main.GamePlay.Level.AnimationTest.GameObject:Get_Transform():Set_Position(Vector3:new(0, -20.0, 0))
		end
	},
	SortingRoom = 
	{
		GameObject = nil,
		Position = Vector3:new(0,0,0),
		RadiusSqr = 2.0,
		Initialize = function(importer)
			Main.GamePlay.Level.SortingRoom.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\Environment\\SRArch.smurf", importer)
			Main.GamePlay.Level.SortingRoom.GameObject:Set_IsActive(false)
			Main.GamePlay.Level.SortingRoom.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\Environment\\SRObjs.smurf", importer)
			Main.GamePlay.Level.SortingRoom.GameObject:Set_IsActive(false)
			
			-- Thin wall for collision testing.
			
			--Main.GamePlay.Level.SortingRoom.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\TestBox.smurf", importer)
			--Main.GamePlay.Level.SortingRoom.GameObject:Set_IsActive(false)			
		end
	},
	Warehouse = 
	{
		GameObject = nil,
		Position = Vector3:new(10,0,10),
		RadiusSqr = 0.1,
		Initialize = function(importer)
			Main.GamePlay.Level.Warehouse.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\Environment\\WHArch.smurf", importer)
			Main.GamePlay.Level.Warehouse.GameObject:Set_IsActive(false)
			Main.GamePlay.Level.Warehouse.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\Environment\\WHObjs.smurf", importer)
			Main.GamePlay.Level.Warehouse.GameObject:Set_IsActive(false)
		end
	},
	WarRoom = 
	{
		GameObject = nil,
		Position = Vector3:new(10,0,10),
		RadiusSqr = 0.1,
		Initialize = function(importer)
			Main.GamePlay.Level.WarRoom.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\Environment\\WRArch.smurf", importer)
			Main.GamePlay.Level.WarRoom.GameObject:Set_IsActive(false)
		end
	},
	Arena = 
	{
		GameObject = nil,
		Position = Vector3:new(10,0,10),
		RadiusSqr = 0.1,
		Initialize = function(importer)
			Main.GamePlay.Level.Arena.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\Environment\\ARArch.smurf", importer)
			Main.GamePlay.Level.Arena.GameObject:Set_IsActive(false)
			Main.GamePlay.Level.Arena.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\Environment\\ARObjs.smurf", importer)
			Main.GamePlay.Level.Arena.GameObject:Set_IsActive(false)
		end
	},
	ClassRoom = 
	{
		GameObject = nil,
		Position = Vector3:new(10,0,10),
		RadiusSqr = 0.1,
		Initialize = function(importer)
			Main.GamePlay.Level.ClassRoom.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\Environment\\CRArch.smurf", importer)
			Main.GamePlay.Level.ClassRoom.GameObject:Set_IsActive(false)
		end
	},
	EmergencyRoom = 
	{
		GameObject = nil,
		Position = Vector3:new(10,0,10),
		RadiusSqr = 0.1,
		Initialize = function(importer)
			Main.GamePlay.Level.EmergencyRoom.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\Environment\\ERArch.smurf", importer)
			Main.GamePlay.Level.EmergencyRoom.GameObject:Set_IsActive(false)
			Main.GamePlay.Level.EmergencyRoom.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\Environment\\ERObjs.smurf", importer)
			Main.GamePlay.Level.EmergencyRoom.GameObject:Set_IsActive(false)
		end
	},
	Lobby = 
	{
		GameObject = nil,
		Position = Vector3:new(10,0,10),
		RadiusSqr = 0.1,
		Initialize = function(importer)
			Main.GamePlay.Level.Lobby.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\Environment\\LBArch.smurf", importer)
			Main.GamePlay.Level.Lobby.GameObject:Set_IsActive(false)
		end
	},
	Museum = 
	{
		GameObject = nil,
		Position = Vector3:new(10,0,10),
		RadiusSqr = 0.1,
		Initialize = function(importer)
			Main.GamePlay.Level.Museum.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\Environment\\MSArch.smurf", importer)
			Main.GamePlay.Level.Museum.GameObject:Set_IsActive(false)
			Main.GamePlay.Level.Museum.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\Environment\\MSObjs.smurf", importer)
			Main.GamePlay.Level.Museum.GameObject:Set_IsActive(false)
		end
	},
	Store = 
	{
		GameObject = nil,
		Position = Vector3:new(10,0,10),
		RadiusSqr = 0.1,
		Initialize = function(importer)
			Main.GamePlay.Level.Store.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\Environment\\STArch.smurf", importer)
			Main.GamePlay.Level.Store.GameObject:Set_IsActive(false)
			Main.GamePlay.Level.Store.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\Environment\\STObjs.smurf", importer)
			Main.GamePlay.Level.Store.GameObject:Set_IsActive(false)
		end
	},
	Update = function(sender, elapsedTime)	
		--[[
		local animObject = Main.GamePlay.Level.AnimationTest.GameObject
		if(animObject == nil) then
			return
		end				
		local position = animObject:Get_Transform():Get_Position()
		Util.Debug("Position: "..position.x..", "..position.y..", "..position.z)		
		]]--
			
		-- distance = Util.Vector3Subtract(position, Main.GamePlay.Level.SortingRoom.Position)
		-- Util.Debug("Distance:", Util.Vector3LengthSquared(distance))
		-- if(Util.Vector3LengthSquared(distance) < Main.GamePlay.Level.SortingRoom.RadiusSqr and not Main.GamePlay.Level.SortingRoom.GameObject:Get_IsActive()) then
			-- --Main.GamePlay.Level.SortingRoom.GameObject:Set_IsActive(true)
			-- Util.Debug("Enabling SortingRoom")
		-- elseif(Util.Vector3LengthSquared(distance) > Main.GamePlay.Level.SortingRoom.RadiusSqr and Main.GamePlay.Level.SortingRoom.GameObject:Get_IsActive()) then
			-- Main.GamePlay.Level.SortingRoom.GameObject:Set_IsActive(false)
			-- Util.Debug("Disabling SortingRoom")
		-- end
		
		-- distance = Util.Vector3Subtract(position, Main.GamePlay.Level.Warehouse.Position)
		-- if(Util.Vector3LengthSquared(distance) < Main.GamePlay.Level.Warehouse.RadiusSqr and not Main.GamePlay.Level.Warehouse.GameObject:Get_IsActive()) then
			-- Main.GamePlay.Level.Warehouse.GameObject:Set_IsActive(true)
			-- Util.Debug("Enabling Warehouse")
		-- end
		
		-- distance = Util.Vector3Subtract(position, Main.GamePlay.Level.WarRoom.Position)
		-- if(Util.Vector3LengthSquared(distance) < Main.GamePlay.Level.WarRoom.RadiusSqr and not Main.GamePlay.Level.WarRoom.GameObject:Get_IsActive()) then
			-- Main.GamePlay.Level.WarRoom.GameObject:Set_IsActive(true)
			-- Util.Debug("Enabling WarRoom")
		-- end
		
		-- distance = Util.Vector3Subtract(position, Main.GamePlay.Level.ARoom.Position)
		-- if(Util.Vector3LengthSquared(distance) < Main.GamePlay.Level.ARoom.RadiusSqr and not Main.GamePlay.Level.ARoom.GameObject:Get_IsActive()) then
			-- Main.GamePlay.Level.ARoom.GameObject:Set_IsActive(true)
			-- Util.Debug("Enabling ARoom")
		-- end
		
		-- distance = Util.Vector3Subtract(position, Main.GamePlay.Level.CRoom.Position)
		-- if(Util.Vector3LengthSquared(distance) < Main.GamePlay.Level.CRoom.RadiusSqr and not Main.GamePlay.Level.CRoom.GameObject:Get_IsActive()) then
			-- Main.GamePlay.Level.CRoom.GameObject:Set_IsActive(true)
			-- Util.Debug("Enabling CRoom")
		-- end
		
		-- distance = Util.Vector3Subtract(position, Main.GamePlay.Level.EmergencyRoom.Position)
		-- if(Util.Vector3LengthSquared(distance) < Main.GamePlay.Level.EmergencyRoom.RadiusSqr and not Main.GamePlay.Level.EmergencyRoom.GameObject:Get_IsActive()) then
			-- Main.GamePlay.Level.EmergencyRoom.GameObject:Set_IsActive(true)
			-- Util.Debug("Enabling EmergencyRoom")
		-- end
		
		-- distance = Util.Vector3Subtract(position, Main.GamePlay.Level.Library.Position)
		-- if(Util.Vector3LengthSquared(distance) < Main.GamePlay.Level.Library.RadiusSqr and not Main.GamePlay.Level.Library.GameObject:Get_IsActive()) then
			-- Main.GamePlay.Level.Library.GameObject:Set_IsActive(true)
			-- Util.Debug("Enabling Library")
		-- end
		
		-- distance = Util.Vector3Subtract(position, Main.GamePlay.Level.ST.Position)
		-- if(Util.Vector3LengthSquared(distance) < Main.GamePlay.Level.ST.RadiusSqr and not Main.GamePlay.Level.ST.GameObject:Get_IsActive()) then
			-- Main.GamePlay.Level.ST.GameObject:Set_IsActive(true)
			-- Util.Debug("Enabling ST")
		-- end
	end
}

Main.GamePlay.BuildLevel = function()

	Util.Debug("Light!")
	light = Singularity.Graphics.Light:new("Light1")
	light:Set_Falloff(0.0025)
	light:Set_Range(10000)
	Util.Debug("Light added.")
	table.insert(Main.GamePlay.Lights, light)
	
	Util.Debug("Light node.")
	object = Singularity.Components.GameObject:Create("Light node", Main.Root, nil)
	object:Get_Transform():Translate(0, 0.5, 0)
	Util.Debug("Light node added.")
	object:AddComponent(light)

	--local importer = Singularity.Content.SmurfModelImporter:new("P:\\gdd_capstone\\")
	local importer = Singularity.Content.SmurfModelImporter:new("C:\\Users\\IGMAdmin\\Desktop\\gdd_capstone\\")
	--local importer = Singularity.Content.SmurfModelImporter:new("C:\\Users\\infinitemonkey\\Documents\\Visual Studio 2008\\Projects\\gdd_capstone\\")
	--local importer = Singularity.Content.SmurfModelImporter:new("D:\\Schoolwork\\Capstone\\gdd_capstone\\")
	Main.GamePlay.Level.SortingRoom.Initialize(importer)
	Main.GamePlay.Level.Warehouse.Initialize(importer)
	Main.GamePlay.Level.WarRoom.Initialize(importer)
	Main.GamePlay.Level.Arena.Initialize(importer)
	Main.GamePlay.Level.ClassRoom.Initialize(importer)
	Main.GamePlay.Level.EmergencyRoom.Initialize(importer)
	Main.GamePlay.Level.Lobby.Initialize(importer)
	Main.GamePlay.Level.Museum.Initialize(importer)
	Main.GamePlay.Level.Store.Initialize(importer)
	--Main.GamePlay.Level.AnimationTest.Initialize(importer)
end
---------------------------------------
Util.Debug("Gameplay Loaded.")