BuffDisplay = {}

BuffDisplay.IconNinePatches = {}

BuffDisplay.Icons = {}

local ICON_SIZE = 64
local ICON_SPACING = 8
local IMAGE_SIZE = 64

--Utility function to build a texture
BuffDisplay.BuildNinePatch = function(path)
	local tex = Singularity.Graphics.Texture2D:LoadTextureFromFile(path)
	local ninepatch = Singularity.Gui.NinePatch:new(tex, Vector2:new(IMAGE_SIZE, IMAGE_SIZE), Vector4:new(0, 0, 0, 0))
	
	return ninepatch
end

--Load Textures
--Mods
BuffDisplay.IconNinePatches.Shrink = BuffDisplay.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Buff Icons\\Shrink.png")
BuffDisplay.IconNinePatches.Grow = BuffDisplay.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Buff Icons\\Grow.png")
BuffDisplay.IconNinePatches.Frictionless = BuffDisplay.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Buff Icons\\Frictionless.png")
BuffDisplay.IconNinePatches["Increase Gravity"] = BuffDisplay.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Buff Icons\\FeatherLight.png")
BuffDisplay.IconNinePatches["Invert Gravity"] = BuffDisplay.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Buff Icons\\Gravity Invert.png")

--Rewards
BuffDisplay.IconNinePatches.SpeedMinor = BuffDisplay.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\SpeedMinor.png")
BuffDisplay.IconNinePatches.SpeedMid = BuffDisplay.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\SpeedMid.png")
BuffDisplay.IconNinePatches.SpeedMajor = BuffDisplay.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\SpeedMajor.png")
BuffDisplay.IconNinePatches.HealthMinor = BuffDisplay.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\HealthMinor.png")
BuffDisplay.IconNinePatches.HealthMid = BuffDisplay.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\HealthMid.png")
BuffDisplay.IconNinePatches.HealthMajor = BuffDisplay.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\HealthMajor.png")

--Control Point
BuffDisplay.IconNinePatches.ControlPoint = BuffDisplay.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\ControlPoint.png")

BuffDisplay.Enabled = false

BuffDisplay.Build = function(parent, offset, numIcons)

	for i = 1,numIcons do		
		
		--build the buff icon images
		local icon = Singularity.Gui.Image:new("Buff Icon "..i)
		icon:Set_Texture(BuffDisplay.IconNinePatches.Shrink)
		icon:Set_Visible(false)
		icon:Set_Size(Vector2:new(ICON_SIZE, ICON_SIZE))
		--tile them vertically down the screen
		icon:Set_Position(Vector2:new(offset.x, offset.y + (ICON_SIZE + ICON_SPACING) * (i-1)))
		parent:AddControl(icon)
		
		--save the control in a list
		table.insert(BuffDisplay.Icons, icon)
	end	

end

BuffDisplay.Enable = function()
	BuffDisplay.Enabled = true
end

BuffDisplay.Disable = function()
	BuffDisplay.Enabled = false
end

BuffDisplay.Update = function(elapsed)

	if(BuffDisplay.Enabled) then
		local buffs = Player.Buffs
		if(not buffs) then return end
		for i=1,#BuffDisplay.Icons do
			if(i <= #buffs) then
				--set this icon to represent the buff
				local buffName = buffs[i].Name
				BuffDisplay.Icons[i]:Set_Texture(BuffDisplay.IconNinePatches[buffName])
				BuffDisplay.Icons[i]:Set_Visible(true)
			else
				--hide the icon
				BuffDisplay.Icons[i]:Set_Visible(false)
			end
		end
	end

end