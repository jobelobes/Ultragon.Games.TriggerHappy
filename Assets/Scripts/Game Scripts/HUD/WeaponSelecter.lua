local ICON_SIZE = 96
local IMAGE_SIZE = 96
local ICON_SPACING = 8
local TIME_TO_CLOSE = 1
local ANIMATION_TIME = 0.3

local ARROW_IMAGE_SIZE = 64
local ARROW_SIZE = 32

WeaponSelecter = {}

WeaponSelecter.IconNinePatches = {}

WeaponSelecter.Icons = {}

WeaponSelecter.Enabled = false

WeaponSelecter.BuildNinePatch = function(path)
	local tex = Singularity.Graphics.Texture2D:LoadTextureFromFile(path)
	local ninepatch = Singularity.Gui.NinePatch:new(tex, Vector2:new(IMAGE_SIZE, IMAGE_SIZE), Vector4:new(0, 0, 0, 0))
	
	return ninepatch
end

--Weapon Icons
WeaponSelecter.IconNinePatches.AssaultRifle = WeaponSelecter.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Weapon Icons\\AssaultRifle.png")
WeaponSelecter.IconNinePatches.CannonGun = WeaponSelecter.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Weapon Icons\\CannonGun.png")
WeaponSelecter.IconNinePatches.FrictionlessModifierLauncher = WeaponSelecter.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Weapon Icons\\FrictionlessModifierLauncher.png")
WeaponSelecter.IconNinePatches.Grenade = WeaponSelecter.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Weapon Icons\\Grenade.png")
WeaponSelecter.IconNinePatches.GrowModifierLauncher = WeaponSelecter.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Weapon Icons\\GrowModifierLauncher.png")
WeaponSelecter.IconNinePatches.IllusionModifierLauncher = WeaponSelecter.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Weapon Icons\\IllusionModifierLauncher.png")
WeaponSelecter.IconNinePatches.IncreaseGravityModifierLauncher = WeaponSelecter.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Weapon Icons\\FeatherLightModifierLauncher.png")
WeaponSelecter.IconNinePatches.InvertGravityModifierLauncher = WeaponSelecter.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Weapon Icons\\InvertGravityModifierLauncher.png")
WeaponSelecter.IconNinePatches.KnockbackModifierLauncher = WeaponSelecter.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Weapon Icons\\KnockbackModifierLauncher.png")
WeaponSelecter.IconNinePatches.Pistol = WeaponSelecter.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Weapon Icons\\Pistol.png")
WeaponSelecter.IconNinePatches.Shotgun = WeaponSelecter.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Weapon Icons\\Shotgun.png")
WeaponSelecter.IconNinePatches.ShrinkModifierLauncher = WeaponSelecter.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Weapon Icons\\ShrinkModifierLauncher.png")
WeaponSelecter.IconNinePatches.WallModifierLauncher = WeaponSelecter.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Weapon Icons\\WallModifierLauncher.png")
WeaponSelecter.IconNinePatches.SniperRifle = WeaponSelecter.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Weapon Icons\\SniperRifle.png")

WeaponSelecter.ArrowNinePatch = Singularity.Gui.NinePatch:new(Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\Weapon Icons\\Selection Arrow.png"), Vector2:new(ARROW_IMAGE_SIZE, ARROW_IMAGE_SIZE), Vector4:new(0, 0, 0, 0))

WeaponSelecter.Build = function(parent, offset, maxWeapons)

	--Frame
	WeaponSelecter.Frame = Singularity.Gui.Panel:new("Weapons Panel")
	WeaponSelecter.Frame:Set_Visible(false)
	WeaponSelecter.Frame:Set_Size(Vector2:new(ICON_SIZE + ARROW_SIZE, (ICON_SIZE+ICON_SPACING)*maxWeapons))
	WeaponSelecter.Frame:Set_Position(Vector2:new(offset.x, offset.y))
	parent:AddControl(WeaponSelecter.Frame)
	
	--Frame Status
	WeaponSelecter.State = "Closed"
	WeaponSelecter.LeftKeyDown = false
	WeaponSelecter.RightKeyDown = false
	WeaponSelecter.NumberKeyDown = false
	WeaponSelecter.OpenTween = Tween.Tween.MakeLinearTween(ANIMATION_TIME,0,-ICON_SIZE-ARROW_SIZE)
	WeaponSelecter.CloseTween = Tween.Tween.MakeLinearTween(ANIMATION_TIME,0,ICON_SIZE+ARROW_SIZE)
	WeaponSelecter.Index = 1
	WeaponSelecter.RootPosition = offset
	WeaponSelecter.MaxWeapons = maxWeapons

	--Build Weapon icons
	for i = 1,maxWeapons do		
		
		local icon = Singularity.Gui.Image:new("Weapon Icon "..i)
		icon:Set_Texture(WeaponSelecter.IconNinePatches.AssaultRifle)
		icon:Set_Visible(true)
		icon:Set_Size(Vector2:new(ICON_SIZE, ICON_SIZE))
		icon:Set_Position(Vector2:new(ARROW_SIZE, (ICON_SIZE + ICON_SPACING) * (i-1)))
		WeaponSelecter.Frame:AddControl(icon)
		
		table.insert(WeaponSelecter.Icons, icon)
	end
	
	--Arrow pointing to current selection
	WeaponSelecter.Arrow = Singularity.Gui.Image:new("Weapon Selecter Arrow")
	WeaponSelecter.Arrow:Set_Texture(WeaponSelecter.ArrowNinePatch)
	WeaponSelecter.Arrow:Set_Visible(true)
	WeaponSelecter.Arrow:Set_Size(Vector2:new(ARROW_SIZE, ARROW_SIZE))
	WeaponSelecter.Arrow:Set_Position(Vector2:new(0, 0))
	WeaponSelecter.Frame:AddControl(WeaponSelecter.Arrow)
end

WeaponSelecter.Enable = function()
	WeaponSelecter.Enabled = true
	WeaponSelecter.Frame:Set_Visible(true)	
end

WeaponSelecter.Disable = function()
	WeaponSelecter.Enabled = false
	WeaponSelecter.Frame:Set_Visible(false)
end

--Tween functions
WeaponSelecter.GetX = function(self)
	return WeaponSelecter.Frame:Get_Position().x
end

WeaponSelecter.SetX = function(self, newX)
	local old = WeaponSelecter.Frame:Get_Position()
	old.x = newX
	WeaponSelecter.Frame:Set_Position(old)
end

local Input = Singularity.Inputs.Input

WeaponSelecter.Open = function()
	--Change state
	WeaponSelecter.State = "Opening"
	--Play opening tween
	local set = Tween.TweenSet.MakeTweenSet()
	set:Bind(WeaponSelecter.OpenTween, 0, "GetX", "SetX")
	set:SetTarget(WeaponSelecter)
	Tween.Tweener.Play(set)
end

WeaponSelecter.Close = function()
	--Change State
	WeaponSelecter.State = "Closing"
	--Play closing tween
	local set = Tween.TweenSet.MakeTweenSet()
	set:Bind(WeaponSelecter.CloseTween, 0, "GetX", "SetX")
	set:SetTarget(WeaponSelecter)
	Tween.Tweener.Play(set)
end

WeaponSelecter.RotateWeapons = function(index)

	--update arrow to new index if in range
	if(index < 1 or index > #Player.Client.Weapons) then
		return
	end
	
	WeaponSelecter.Index = index
	
	WeaponSelecter.Arrow:Set_Position(Vector2:new(0, (index-1) * (ICON_SIZE + ICON_SPACING) + ICON_SIZE * 0.5 - ARROW_SIZE*0.5))
	
end

--get the next weapon index
WeaponSelecter.GetNextIndex = function(dir)
	return ((WeaponSelecter.Index + dir - 1) % #Player.Client.Weapons) + 1
end

WeaponSelecter.Update = function(elapsed)

	if(WeaponSelecter.Enabled) then
		--Icons
		local client = Player.Client
		if(not client) then return end
		local weapons = client.Weapons
		if(not weapons) then return end
		
		--Update textures based on weapon set
		for i = 1, WeaponSelecter.MaxWeapons do
			if(i <= #weapons) then
				WeaponSelecter.Icons[i]:Set_Visible(true)
				WeaponSelecter.Icons[i]:Set_Texture(WeaponSelecter.IconNinePatches[weapons[i].Type])
			else
				WeaponSelecter.Icons[i]:Set_Visible(false)
			end
		end
		
		--Input

		local LBracket = false

		if(Input:IsKeyDown(DIK_LBRACKET) and not WeaponSelecter.LeftKeyDown) then
			LBracket = true
			WeaponSelecter.LeftKeyDown = true
		elseif(Input:IsKeyUp(DIK_LBRACKET)) then
			WeaponSelecter.LeftKeyDown = false
		end
		
		local RBracket = false

		if(Input:IsKeyDown(DIK_RBRACKET) and not WeaponSelecter.RightKeyDown) then
			RBracket = true
			WeaponSelecter.RightKeyDown = true
		elseif(Input:IsKeyUp(DIK_RBRACKET)) then
			WeaponSelecter.RightKeyDown = false
		end
		
		local NumberKey = -1
		
		if(Input:IsKeyDown(DIK_1)) then
			NumberKey = 1
		elseif(Input:IsKeyDown(DIK_2)) then
			NumberKey = 2
		elseif(Input:IsKeyDown(DIK_3)) then
			NumberKey = 3
		elseif(Input:IsKeyDown(DIK_4)) then
			NumberKey = 4
		elseif(Input:IsKeyDown(DIK_5)) then
			NumberKey = 5
		elseif(Input:IsKeyDown(DIK_6)) then
			NumberKey = 6
		elseif(Input:IsKeyDown(DIK_7)) then
			NumberKey = 7
		elseif(Input:IsKeyDown(DIK_8)) then
			NumberKey = 8
		elseif(Input:IsKeyDown(DIK_9)) then
			NumberKey = 9
		elseif(Input:IsKeyDown(DIK_0)) then
			NumberKey = 10
		end
		
		if (NumberKey >= 0 and not WeaponSelecter.NumberKeyDown) then
			WeaponSelecter.NumberKeyDown = true
		elseif(NumberKey < 0) then
			WeaponSelecter.NumberKeyDown = false
		end
		
			
			

        --States
		if(WeaponSelecter.State == "Open") then
			--If it's been sitting idle, close it
			WeaponSelecter.Elapsed = WeaponSelecter.Elapsed + elapsed
			if(WeaponSelecter.Elapsed > TIME_TO_CLOSE) then
				WeaponSelecter.Elapsed = 0
				WeaponSelecter.Close()
				--select the weapon it was on
				if(WeaponSelecter.Index ~= client.CurrentWeaponIndex) then
					client:SelectWeapon(WeaponSelecter.Index)
				end
			end

			--move the arrow
			if(LBracket) then
				WeaponSelecter.Elapsed = 0
				WeaponSelecter.RotateWeapons(WeaponSelecter.GetNextIndex(-1))
			elseif(RBracket) then
				WeaponSelecter.Elapsed = 0
				WeaponSelecter.RotateWeapons(WeaponSelecter.GetNextIndex(1))
			elseif(NumberKey > 0) then
				WeaponSelecter.Elapsed = 0
				WeaponSelecter.RotateWeapons(NumberKey)
			end
			
		elseif(WeaponSelecter.State == "Opening") then
		
			WeaponSelecter.Elapsed = WeaponSelecter.Elapsed + elapsed
			if(WeaponSelecter.Elapsed > ANIMATION_TIME + 0.1) then
				WeaponSelecter.State = "Open"
			end
		
		elseif(WeaponSelecter.State == "Closing") then
		
			WeaponSelecter.Elapsed = WeaponSelecter.Elapsed + elapsed
			if(WeaponSelecter.Elapsed > ANIMATION_TIME + 0.1) then
				WeaponSelecter.State = "Closed"
			end
		
		else
		    --Open the menu and set the arrow to the current weapon
			if(LBracket or RBracket or (NumberKey > 0)) then
				WeaponSelecter.RotateWeapons(client.CurrentWeaponIndex)
				WeaponSelecter.Open()
				WeaponSelecter.Elapsed = 0
			end
		
		end
	end

end
