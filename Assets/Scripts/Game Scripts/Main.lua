Main = {}

print("Trigger Happy Main started")

--Main.AssetDirectory = "C:\\Users\\infinitemonkey\\Documents\\Visual Studio 2008\\Projects\\gdd_capstone\\Assets\\"
--Main.AssetDirectory = "D:\\Schoolwork\\Capstone\\gdd_capstone\\Assets\\"
Main.AssetDirectory = "..\\..\\..\\Assets\\"

Main.Root = Singularity.Components.GameObject:Create("Scene root", nil, nil)

Main.Host = Singularity.Networking.IPAddress:new("224.0.0.1")

Main.Port = 3245

Main.Player = Singularity.Networking.Network:CurrentPlayer()

Main.Started = false

Main.Initialize = function()
	
	dofile(Main.AssetDirectory.."\\Scripts\\Game Scripts\\Util.lua")
	
	--Enable debugging
	Util.DebugEnabled = true
	Util.Debug("Initializing Main...")
	
	--Setup View
	--Singularity.Graphics.Screen:SetResolution(1280, 800, false)
	--Singularity.Graphics.Screen:SetSize(50, 50, 1280, 800)	
	Singularity.Graphics.Screen:SetResolution(1440, 900, false)
	Singularity.Graphics.Screen:SetSize(50, 50, 1440, 900)

		--Screens
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Screens\\Screens.lua")
	Screens.Initialize()
	Util.Debug("Turn on the screens!")
	Screens.Activate()
	
	Main.LoadFonts()
	Main.LoadLibraries()
	Main.InitializeSystems()
	
	--Update Binding
	local binder = Singularity.Scripting.LuaBinder:new("General Update")
	binder:Set_FunctionName("Main.Update")
	Main.Root:AddComponent(binder)
	
	Main.Network = Singularity.Networking.Network:ConnectTo(Main.Host, Main.Port)
	
	--Start Screens
	Util.Debug("Initializing Main Complete.")
end

Main.LoadLibraries = function()
	
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Audio.lua")	
	
	--General
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\tween.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\memory.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Network.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\ColliderSmoother.lua")
	
	if(Util.DebugEnabled) then
		Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Console.lua")
	end
		
	--Gameplay
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Gameplay\\Main.GamePlay.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Gameplay\\Player.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Gameplay\\Projectile.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Gameplay\\Weapons.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Gameplay\\Buffs.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Gameplay\\Modifiers.lua")	
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Gameplay\\Achievement.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Gameplay\\KotH.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Gameplay\\Assault.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\Gameplay\\Deathmatch.lua")
	
	--HUD Components
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\HUD\\Player.HUD.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\HUD\\RulerMeter.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\HUD\\WeaponSelecter.lua")	
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\HUD\\BuffDisplay.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\HUD\\AmmoDisplay.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\HUD\\Scoreboard.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\HUD\\AchievementDisplay.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\HUD\\KotHDisplay.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\HUD\\AssaultDisplay.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\HUD\\DeathmatchDisplay.lua")
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\HUD\\Scope.lua")	
	Util.LoadFile(Main.AssetDirectory.."Scripts\\Game Scripts\\HUD\\ModifierTargets.lua")	
end

Main.LoadFonts = function()

	local Font = Singularity.Gui.Font
	Font:Create("Bauhaus24 Regular", Main.AssetDirectory.."\\Fonts\\Bauhaus24.bmp")
	Font:Create("Comic Sans 11 Regular", Main.AssetDirectory.."\\Fonts\\ComicSans11.bmp")
	Font:Create("Franklin Gothic8 Bold",Main.AssetDirectory.."\\Fonts\\FranklinGothicBold8.bmp")
	Font:Create("Franklin Gothic11 Bold",Main.AssetDirectory.."\\Fonts\\FranklinGothicBold11.bmp")
	Font:Create("Franklin Gothic24 Bold", Main.AssetDirectory.."\\Fonts\\FranklinGothicBold24.bmp")
	Font:Create("Arial12 Regular", Main.AssetDirectory.."\\Fonts\\Arial12.bmp")
	Font:Get_Font("Comic Sans 11 Regular"):Set_Kerning(2)
	Font:Get_Font("Arial12 Regular"):Set_Kerning(2)
	Font:Get_Font("Franklin Gothic11 Bold"):Set_Kerning(2)
end

Main.InitializeSystems = function()
	Util.Debug("Initialize Subsystems.")
	Audio.Initialize()
	Audio.LoadMenuAssets()
	Audio.LoadLevelAssets()
	Main.GamePlay.Initialize()
	Screens.InitAll()
	Util.Debug("Initializing Subsystems Complete.")
end

Main.Update = function(sender,elapsed)
	Memory.Update(elapsed)
	Tween.Tweener.Update(elapsed)
	Network.Update(elapsed)
	ColliderSmoother.Update(elapsed)
	
	if(Util.DebugEnabled) then
		Console.Update(elapsed)
	end		

	if(Singularity.Inputs.Input:IsKeyDown(DIK_W) and not Main.Started) then
		Main.Started = true
		
		Screens.DebugHideAll()
		--Screens.Deactivate()

		Main.GamePlay.StartGame(true, 1, PLAYER_TEAM_RED, "KotH", {WinningScore = 5})
		--Main.GamePlay.StartGame(true, 1, PLAYER_TEAM_BLUE, "Assault", {WinningScore = 300})
	end		
end

-------------------------------------------------------------------------------
-- InitializeSandbox
-------------------------------------------------------------------------------
Main.InitializeSandbox = function()
	dofile(Main.AssetDirectory.."Scripts\\Game Scripts\\Sandbox\\Sandbox.lua")		
end

-------------------------------------------------------------------------------
Main.Initialize()
--Main.InitializeSandbox()