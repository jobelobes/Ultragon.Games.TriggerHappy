Sandbox.Simulation = {}
Sandbox.Simulation.Started = false
Sandbox.Simulation.PauseKeyDown = false

-------------------------------------------------------------------------------
-- Initialize
-------------------------------------------------------------------------------
Sandbox.Simulation.Initialize = function()
	Util.Debug("Initializing Sandbox Simulation...")
	
	-- Binder
	local binder = Singularity.Scripting.LuaBinder:new("Sandbox Update")
	binder:Set_FunctionName("Sandbox.Simulation.Update")
	Main.Root:AddComponent(binder)
	
	Util.Debug("Sandbox Simulation Initialized.")
end

-------------------------------------------------------------------------------
-- Start
-------------------------------------------------------------------------------
Sandbox.Simulation.Start = function()
	Util.Debug("Starting Simulation...")
	
	Sandbox.Simulation.Started = true

	Sandbox.Simulation.Lights = {}
	
	-- Build the Environment
	if(not Sandbox.Simulation.Loaded) then
		Sandbox.Simulation.BuildLevel()
		Sandbox.Simulation.LevelBuilt = true
	end	
	
	-- Create a Player (our camera)
	Sandbox.Player.Initialize()
	Sandbox.Player.Client = Sandbox.Player.Create(Vector3:new(60,28,60), Vector3:new(0,0,1))
	Sandbox.Player.Enable()
	Sandbox.Player.Camera.Activate()
	
	Util.Debug("Simulation Started.")
end

-------------------------------------------------------------------------------
-- Update
-------------------------------------------------------------------------------
Sandbox.Simulation.Update = function(sender, elapsedTime)
	
	if(Sandbox.Simulation.Started) then
		Sandbox.Simulation.Level.Update(sender, elapsedTime)

		if(Singularity.Inputs.Input:IsKeyDown(DIK_P)) then
			if(not Sandbox.Simulation.PauseKeyDown) then
				Sandbox.Player.Camera.Deactivate()		
				Sandbox.Simulation.PauseKeyDown = true
			else
				Sandbox.Player.Camera.Activate()		
				Sandbox.Simulation.PauseKeyDown = false
			end
		end
	end		
end


--=============================================================================
-- Level
--=============================================================================
Sandbox.Simulation.LevelBuilt = false

Sandbox.Simulation.Level = 
{
	AnimationTest = 
	{
		GameObject = nil,
		Initialize = function(importer)
			Sandbox.Simulation.Level.AnimationTest.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\AnimCharacter.smurf", importer)
			Sandbox.Simulation.Level.AnimationTest.GameObject:Set_IsActive(false)			
			Sandbox.Simulation.Level.AnimationTest.GameObject:Get_Transform():Set_Position(Vector3:new(0, 0, 0))
		end
	},	
	SortingRoom = 
	{
		GameObject = nil,				
		Initialize = function(importer)
			Sandbox.Simulation.Level.SortingRoom.GameObject = Singularity.Content.ModelLoader:LoadModel(Main.AssetDirectory .. "Models\\Environment\\SRArch.smurf", importer)
			Sandbox.Simulation.Level.SortingRoom.GameObject:Set_IsActive(false)
		end
	},
	
	Update = function(sender, elapsedTime)
	end
}

-------------------------------------------------------------------------------
-- BuildLevel
-------------------------------------------------------------------------------
Sandbox.Simulation.BuildLevel = function()
	Util.Debug("Building Level...")
		
		-- Create and Add a Light
		local light = Singularity.Graphics.Light:new("Light1")
		light:Set_Falloff(0.25)
		light:Set_Range(10000)
		table.insert(Sandbox.Simulation.Lights, light)
		
		local object = Singularity.Components.GameObject:Create("Light Node", Main.Root, nil)
		object:Get_Transform():Translate(0, 10, 0)
		object:AddComponent(light)
		

		-- Create and Add Environment Models
		local importer = Singularity.Content.SmurfModelImporter:new("P:\\gdd_capstone\\")
		Sandbox.Simulation.Level.SortingRoom.Initialize(importer)
		Sandbox.Simulation.Level.AnimationTest.Initialize(importer)		
	
	Util.Debug("Level Built.")
end