AchievementDisplay = {}

local STAMP_IMAGE_WIDTH = 150
local STAMP_IMAGE_HEIGHT = 150
local STAMP_WIDTH = 150
local STAMP_HEIGHT = 150

AchievementDisplay.Enabled = false

AchievementDisplay.Build = function(parent, offset)

	--Main Frame
	AchievementDisplay.Frame = Singularity.Gui.Panel:new("Achievement Panel")
	AchievementDisplay.Frame:Set_Visible(false)
	AchievementDisplay.Frame:Set_Size(Vector2:new(STAMP_WIDTH, STAMP_HEIGHT))
	AchievementDisplay.Frame:Set_Position(Vector2:new(offset.x, offset.y))
	parent:AddControl(AchievementDisplay.Frame)
	
	local tex = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\SuccessStamp.jpg")
	AchievementDisplay.SuccessNinepatch = Singularity.Gui.NinePatch:new(tex, Vector2:new(STAMP_IMAGE_WIDTH, STAMP_IMAGE_HEIGHT), Vector4:new(0, 0, 0, 0))
	
	--Image showing the goal
	AchievementDisplay.Stamp = Singularity.Gui.Image:new("Text Stamp")
	AchievementDisplay.Stamp:Set_Texture(AchievementDisplay.SuccessNinepatch)
	AchievementDisplay.Stamp:Set_Visible(true)
	AchievementDisplay.Stamp:Set_Size(Vector2:new(STAMP_WIDTH, STAMP_HEIGHT))
	AchievementDisplay.Stamp:Set_Position(Vector2:new(0, 0))
	AchievementDisplay.Frame:AddControl(AchievementDisplay.Stamp)
	
end

AchievementDisplay.Disable = function()
	AchievementDisplay.Enabled = false	
	AchievementDisplay.Frame:Set_Visible(false)
end

AchievementDisplay.Enable = function()
	AchievementDisplay.Enabled = true	
	AchievementDisplay.Frame:Set_Visible(true)
end

AchievementDisplay.Update = function(elapsed)

	if(AchievementDisplay.Enabled) then
		if(not Achievement) then
			return
		end
		
		--show the success image
		if(Achievement.Success) then			
			AchievementDisplay.Stamp:Set_Texture(AchievementDisplay.SuccessNinepatch)
		else
			--show the goal image
			if(Achievement and Achievement.Goal) then
				AchievementDisplay.Stamp:Set_Texture(Achievement.Goal.Ninepatch)
			end
		end
	end
end