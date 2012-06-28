local ASSAULT_BOARD_IMAGE_WIDTH = 256
local ASSAULT_BOARD_IMAGE_HEIGHT = 134
local ASSAULT_BOARD_WIDTH = 256
local ASSAULT_BOARD_HEIGHT = 134

local TIME_NOTE_IMAGE_WIDTH = 512
local TIME_NOTE_IMAGE_HEIGHT = 297
local TIME_NOTE_WIDTH = 64
local TIME_NOTE_HEIGHT = 37
local TIME_NOTE_Y = ASSAULT_BOARD_HEIGHT * .62

local TIME_HEIGHT = 50
local TIME_Y = TIME_NOTE_HEIGHT * 0.37

AssaultDisplay = {}
AssaultDisplay.Enabled = false

AssaultDisplay.Build = function(parent, offset)

	--Main Frame
	AssaultDisplay.Frame = Singularity.Gui.Panel:new("Assault Panel")
	AssaultDisplay.Frame:Set_Visible(false)
	AssaultDisplay.Frame:Set_Size(Vector2:new(ASSAULT_BOARD_WIDTH, ASSAULT_BOARD_HEIGHT*2))
	AssaultDisplay.Frame:Set_Position(Vector2:new(offset.x - ASSAULT_BOARD_WIDTH*0.5, offset.y))
	parent:AddControl(AssaultDisplay.Frame)
	
	local tex = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\AssaultBoard.png")
	local ninepatch = Singularity.Gui.NinePatch:new(tex, Vector2:new(tex:Get_Width(), tex:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	--Background image
	AssaultDisplay.Board = Singularity.Gui.Image:new("Assault BG")
	AssaultDisplay.Board:Set_Texture(ninepatch)
	AssaultDisplay.Board:Set_Visible(true)
	AssaultDisplay.Board:Set_Size(Vector2:new(ASSAULT_BOARD_WIDTH, ASSAULT_BOARD_HEIGHT))
	AssaultDisplay.Board:Set_Position(Vector2:new(0, 0))
	AssaultDisplay.Frame:AddControl(AssaultDisplay.Board)	
	

	--Time Label
	AssaultDisplay.TimeSeconds = Singularity.Gui.Label:new("Time Seconds", "00:00")
	AssaultDisplay.TimeSeconds:Set_Font(Singularity.Gui.Font:Get_Font("Bauhaus24 Regular"))
	AssaultDisplay.TimeSeconds:Set_Visible(true)
	local textwidth = Singularity.Gui.Font:GetStringWidth(AssaultDisplay.TimeSeconds:Get_Font(), AssaultDisplay.TimeSeconds:Get_Text())
	textwidth = (AssaultDisplay.Frame:Get_Size().x / 2) - (textwidth / 2)
	AssaultDisplay.TimeSeconds:Set_Size(Vector2:new(width, TIME_HEIGHT))
	AssaultDisplay.TimeSeconds:Set_Position(Vector2:new(textwidth, TIME_Y))
	AssaultDisplay.TimeSeconds:Set_FontColor(Color:new(1, 0, 0, 1))
	AssaultDisplay.Frame:AddControl(AssaultDisplay.TimeSeconds)	

end

AssaultDisplay.Enable = function()

	Util.Debug("Enabling assault hud")
	AssaultDisplay.Enabled = true
	AssaultDisplay.Frame:Set_Visible(true)

end

AssaultDisplay.Disable = function()

	AssaultDisplay.Enabled = false
	AssaultDisplay.Frame:Set_Visible(false)

end

AssaultDisplay.UpdateTimer = function(timer)
	--format the time
	local minutes = math.floor(timer / 60)
	local seconds = math.floor(timer % 60)
	
	if(seconds <= 0) then
		seconds = "00"
	elseif(seconds < 10) then
		seconds = "0"..seconds
	end
	
	if(minutes < 10) then
		minutes = "0"..minutes
	end
	
	local timeString = tostring(minutes..":"..seconds)

	AssaultDisplay.TimeSeconds:Set_Text(timeString)
	

end

AssaultDisplay.Update = function(elapsed)
	if(AssaultDisplay.Enabled) then
		local timer = math.floor(Assault.Timer)
		AssaultDisplay.UpdateTimer(timer)
	end
	
end
