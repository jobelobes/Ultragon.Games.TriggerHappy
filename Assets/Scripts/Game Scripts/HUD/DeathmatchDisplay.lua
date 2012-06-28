local DEATHMATCH_BOARD_IMAGE_WIDTH = 256
local DEATHMATCH_BOARD_IMAGE_HEIGHT = 134
local DEATHMATCH_BOARD_WIDTH = 256
local DEATHMATCH_BOARD_HEIGHT = 134

local SCORE_ANCHOR_BLUE = 0.26 * DEATHMATCH_BOARD_WIDTH
local SCORE_ANCHOR_RED = 0.68 * DEATHMATCH_BOARD_WIDTH
local SCORE_Y = DEATHMATCH_BOARD_HEIGHT * 0.33
local SCORE_HEIGHT = 20


DeathmatchDisplay = {}
DeathmatchDisplay.Enabled = false

DeathmatchDisplay.Build = function(parent, offset)

	--Main Frame
	DeathmatchDisplay.Frame = Singularity.Gui.Panel:new("Deathmatch Panel")
	DeathmatchDisplay.Frame:Set_Visible(false)
	DeathmatchDisplay.Frame:Set_Size(Vector2:new(DEATHMATCH_BOARD_WIDTH, DEATHMATCH_BOARD_HEIGHT*2))
	DeathmatchDisplay.Frame:Set_Position(Vector2:new(offset.x - DEATHMATCH_BOARD_WIDTH*0.5, offset.y))
	parent:AddControl(DeathmatchDisplay.Frame)
	
	local tex = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\DeathmatchBoard.png")
	local ninepatch = Singularity.Gui.NinePatch:new(tex, Vector2:new(DEATHMATCH_BOARD_IMAGE_WIDTH, DEATHMATCH_BOARD_IMAGE_HEIGHT), Vector4:new(0, 0, 0, 0))
	
	--Background image
	DeathmatchDisplay.Board = Singularity.Gui.Image:new("Deathmatch BG")
	DeathmatchDisplay.Board:Set_Texture(ninepatch)
	DeathmatchDisplay.Board:Set_Visible(true)
	DeathmatchDisplay.Board:Set_Size(Vector2:new(DEATHMATCH_BOARD_WIDTH, DEATHMATCH_BOARD_HEIGHT))
	DeathmatchDisplay.Board:Set_Position(Vector2:new(0, 0))
	DeathmatchDisplay.Frame:AddControl(DeathmatchDisplay.Board)	
	
	--Blue Team Score Text
	DeathmatchDisplay.BlueScore = Singularity.Gui.Label:new("Blue Score", "0")
	DeathmatchDisplay.BlueScore:Set_Font(Singularity.Gui.Font:Get_Font("Bauhaus24 Regular"))
	DeathmatchDisplay.BlueScore:Set_Visible(true)
	local width = Singularity.Gui.Font:GetStringWidth(DeathmatchDisplay.BlueScore:Get_Font(), DeathmatchDisplay.BlueScore:Get_Text())
	DeathmatchDisplay.BlueScore:Set_Size(Vector2:new(width, SCORE_HEIGHT))
	DeathmatchDisplay.BlueScore:Set_Position(Vector2:new(SCORE_ANCHOR_BLUE, SCORE_Y))
	DeathmatchDisplay.Frame:AddControl(DeathmatchDisplay.BlueScore)
	
	--Red Team Score Text
	DeathmatchDisplay.RedScore = Singularity.Gui.Label:new("Red Score", "0")
	DeathmatchDisplay.RedScore:Set_Font(Singularity.Gui.Font:Get_Font("Bauhaus24 Regular"))
	DeathmatchDisplay.RedScore:Set_Visible(true)
	local width = Singularity.Gui.Font:GetStringWidth(DeathmatchDisplay.RedScore:Get_Font(), DeathmatchDisplay.RedScore:Get_Text())
	DeathmatchDisplay.RedScore:Set_Size(Vector2:new(width, SCORE_HEIGHT))
	DeathmatchDisplay.RedScore:Set_Position(Vector2:new(SCORE_ANCHOR_RED, SCORE_Y))
	DeathmatchDisplay.Frame:AddControl(DeathmatchDisplay.RedScore)

end

DeathmatchDisplay.Enable = function()

	DeathmatchDisplay.Enabled = true
	DeathmatchDisplay.Frame:Set_Visible(true)

end

DeathmatchDisplay.Disable = function()

	DeathmatchDisplay.Enabled = false
	DeathmatchDisplay.Frame:Set_Visible(false)

end

DeathmatchDisplay.Update = function(elapsed)

	if(DeathmatchDisplay.Enabled) then
		DeathmatchDisplay.BlueScore:Set_Text(tostring(Deathmatch.Scores[PLAYER_TEAM_BLUE]))
		DeathmatchDisplay.RedScore:Set_Text(tostring(Deathmatch.Scores[PLAYER_TEAM_RED]))
		
	end
	
end
