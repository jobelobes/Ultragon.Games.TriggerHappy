Sandbox = {}
Sandbox.Started = false

-------------------------------------------------------------------------------
-- Initialize
-------------------------------------------------------------------------------
Sandbox.Initialize = function()	

	-- Load Debug File
	dofile(Main.AssetDirectory.."\\Scripts\\Game Scripts\\Util.lua")
	Util.DebugEnabled = true;
	Util.Debug("Initializing Sandbox...")	
	
	-- Setup View
	Singularity.Graphics.Screen:SetResolution(1440, 900, false)
	Singularity.Graphics.Screen:SetSize(50, 50, 1440, 900)
	
	-- Load Libraries
	Sandbox.LoadLibraries()
	
	-- Initialize Simulation
	Sandbox.Simulation.Initialize()
	
	-- Binder
	local binder = Singularity.Scripting.LuaBinder:new("Sandbox Update")
	binder:Set_FunctionName("Sandbox.Update")
	Main.Root:AddComponent(binder)
	
	Util.Debug("Sandbox Initialized.")
end

-------------------------------------------------------------------------------
-- LoadLibraries
-------------------------------------------------------------------------------
Sandbox.LoadLibraries = function()
	Util.Debug("Loading Libraries...")
	
	-- Load General Scripts
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\memory.lua")
	
	-- Load Specific Environment Scripts
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Sandbox\\Sandbox.Simulation.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Sandbox\\Sandbox.Player.lua")
	
	Util.Debug("Libraries Loaded.")
end

-------------------------------------------------------------------------------
-- Update
-------------------------------------------------------------------------------
Sandbox.Update = function(sender, elapsedTime)
	
	-- Update Systems
	Memory.Update(elapsedTime)	
	
	-- Begin Simulation
	if(not Sandbox.Started) then
		Sandbox.Started = true	
		Sandbox.Simulation.Start()
	end
end

-------------------------------------------------------------------------------
Sandbox.Initialize()