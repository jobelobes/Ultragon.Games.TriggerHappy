Player.HUD = { Enabled = false }

Player.HUD.GameObject = Singularity.Components.GameObject:Create("HUD Node", Main.Root)

Player.HUD.Initialize = function()

	local Texture = Singularity.Graphics.Texture2D

	Util.Debug("Initialzing HUD.")
	
	--Update Binding
	local binder = Singularity.Scripting.LuaBinder:new("HUD Update")
	binder:Set_FunctionName("Player.HUD.Update")
	Player.HUD.GameObject:AddComponent(binder)
	
	--Components
	width, height = Singularity.Graphics.Screen:GetResolution(0, 0)

	Player.HUD.GuiScreen = Singularity.Gui.GuiScreen:new("Gui Screen")
	Player.HUD.Window = Singularity.Gui.Window:new("Player.HUD.Window")
	Player.HUD.Window:Set_Position(Vector2:new(0, 0))
	Player.HUD.Window:Set_Size(Vector2:new(width, height))
	Player.HUD.Window:Set_Draggable(false)
	Player.HUD.Window:Set_Visible(false)
	Player.HUD.GuiScreen:AddWindow(Player.HUD.Window)
	
	--Modifier Targets
	Util.Debug("Loading Modifier Targets")
	ModifierTargets.Build(Player.HUD.Window, 8, width, height)
	
	--Reticule
	Util.Debug("Loading Target Reticle")
	local texture = Texture:LoadTextureFromFile(Main.AssetDirectory .. "\\Textures\\HUD\\TargetReticle.png")
	local ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(47, 28), Vector4:new(0, 0, 0, 0))

	--Scope
	Util.Debug("Loading Scope Display")
	Scope.Build(Player.HUD.Window, width, height)
	
	--Reticle
	Player.Reticle = Singularity.Gui.Image:new("Target Reticle")
	Player.Reticle:Set_Texture(ninepatch)
	Player.Reticle:Set_Size(Vector2:new(ninepatch:Get_Width(), ninepatch:Get_Height()))
	Player.Reticle:Set_Position(Vector2:new((width / 2) - (ninepatch:Get_Width() / 2), (height / 2) - (ninepatch:Get_Height() / 2)))
	Player.HUD.Window:AddControl(Player.Reticle)		
	
	--HP Bar
	Util.Debug("Loading Health Bar")	
	texture = Texture:LoadTextureFromFile(Main.AssetDirectory .. "\\Textures\\HUD\\RulerHP.jpg")
	ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(690, 128), Vector4:new(0, 0, 0, 0))
	Player.HUD.HPBar = RulerMeter.Build(Player.HUD.Window, Vector2:new(0, height), nil, "HP", 100, 1.1, ninepatch)
	
	--Energy Bar
	Util.Debug("Loading Energy Bar")
	texture = Texture:LoadTextureFromFile(Main.AssetDirectory .. "\\Textures\\HUD\\RulerEnergy.jpg")
	ninepatch = Singularity.Gui.NinePatch:new(texture, Vector2:new(690, 128), Vector4:new(0, 0, 0, 0))
	Player.HUD.EnergyBar = RulerMeter.Build(Player.HUD.Window, Vector2:new(width, height), nil, "Energy", 100, 1.1, ninepatch, true)
		
	--Weapon Selecter
	Util.Debug("Loading Weapon Selecter")
	WeaponSelecter.Build(Player.HUD.Window, Vector2:new(width, 100), 7)
		
	--Buff Display
	Util.Debug("Loading Buff Display")
	BuffDisplay.Build(Player.HUD.Window, Vector2:new(10,200), 4)
		
	--Ammo Display
	Util.Debug("Loading Ammo Display")
	AmmoDisplay.Build(Player.HUD.Window, Vector2:new(width * 0.5, height))	
	
	--Achievement 
	Util.Debug("Loading Achievement Display")
	AchievementDisplay.Build(Player.HUD.Window, Vector2:new(0,0))
	
	--KotH Display
	Util.Debug("Loading KotH Display")
	KotHDisplay.Build(Player.HUD.Window, Vector2:new(width*0.5, 0))
	
	--Assault Display
	Util.Debug("Loading Assault Display")
	AssaultDisplay.Build(Player.HUD.Window, Vector2:new(width*0.5, 0))
	
	--Deathmatch Display
	Util.Debug("Loading Deathmatch Display")
	DeathmatchDisplay.Build(Player.HUD.Window, Vector2:new(width*0.5, 0))
	
	--Scoreboard
	Util.Debug("Loading Scoreboard Display")
	Scoreboard.Build(Player.HUD.Window, height*0.9, 8)		

	Player.HUD.GameObject:AddComponent(Player.HUD.GuiScreen)

	Util.Debug("Initialize HUD Complete.")
end

Player.HUD.Update = function(sender, elapsed)
	RulerMeter.Update(elapsed)
	WeaponSelecter.Update(elapsed)
	BuffDisplay.Update(elapsed)
	Scoreboard.Update(elapsed)
	AchievementDisplay.Update(elapsed)
	if(Main.GamePlay.GameType == "KotH") then
		KotHDisplay.Update(elapsed)
	elseif(Main.GamePlay.GameType == "Assault") then
		AssaultDisplay.Update(elapsed)
	elseif(Main.GamePlay.GameType == "Deathmatch") then
		DeathmatchDisplay.Update(elapsed)
	end
	AmmoDisplay.Update(elapsed)
	ModifierTargets.Update(elapsed)
end

Player.HUD.Enable= function()
	if(not Player.HUD.Enabled) then
		Player.HUD.Enabled = true
		Player.HUD.Window:Set_Visible(true)
		Player.HUD.HPBar:Enable()
		Player.HUD.EnergyBar:Enable()
		WeaponSelecter.Enable()
		BuffDisplay.Enable()
		AmmoDisplay.Enable()
		Scoreboard.Enable()
		AchievementDisplay.Enable()
		Util.Debug("Game type is: "..Main.GamePlay.GameType)
		if(Main.GamePlay.GameType == "KotH") then
			KotHDisplay.Enable()
		elseif(Main.GamePlay.GameType == "Assault") then
			AssaultDisplay.Enable()
		elseif(Main.GamePlay.GameType == "Deathmatch") then
			DeathmatchDisplay.Enable()
		end
		ModifierTargets.Enable()
	end
end

Player.HUD.Disable = function()
	if(Player.HUD.Enabled) then
		Player.HUD.Enabled = false
		Player.HUD.Window:Set_Visible(false)
		Player.HUD.HPBar:Disable()
		Player.HUD.EnergyBar:Disable()
		WeaponSelecter.Disable()
		BuffDisplay.Disable()
		AmmoDisplay.Disable()
		Scoreboard.Disable()
		AchievementDisplay.Disable()
		if(Main.GamePlay.GameType == "KotH") then
			KotHDisplay.Disable()
		elseif(Main.GamePlay.GameType == "Assault") then
			AssaultDisplay.Disable()
		elseif(Main.GamePlay.GameType == "Deathmatch") then
			DeathmatchDisplay.Disable()
		end
		ModifierTargets.Disable()
	end
end

Util.Debug("HUD Loaded.")