Scope = { Enabled = false }

local SCOPE_IMAGE_WIDTH = 820
local SCOPE_IMAGE_HEIGHT = 512

Scope.Build = function(parent, parentWidth, parentHeight)

	--Scope Frame
	Scope.Frame = Singularity.Gui.Panel:new("Scope Panel")
	Scope.Frame:Set_Visible(false)
	Scope.Frame:Set_Size(Vector2:new(parentWidth, parentHeight))
	Scope.Frame:Set_Position(Vector2:new(0,0))
	Scope.Frame:Set_Depth(0.5)
	parent:AddControl(Scope.Frame)
	
	local tex = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\Scope.png")
	local ninepatch = Singularity.Gui.NinePatch:new(tex, Vector2:new(SCOPE_IMAGE_WIDTH, SCOPE_IMAGE_HEIGHT), Vector4:new(0, 0, 0, 0))
	
	--Scope Image
	Scope.Board = Singularity.Gui.Image:new("Scope Image")
	Scope.Board:Set_Texture(ninepatch)
	Scope.Board:Set_Visible(true)
	Scope.Board:Set_Size(Vector2:new(parentWidth, parentHeight))
	Scope.Board:Set_Position(Vector2:new(0, 0))
	Scope.Frame:AddControl(Scope.Board)

end

Scope.Enable = function()
	Scope.Enabled = true
	Scope.Frame:Set_Visible(true)
end


Scope.Disable = function()
	Scope.Enabled = false
	Scope.Frame:Set_Visible(false)
end