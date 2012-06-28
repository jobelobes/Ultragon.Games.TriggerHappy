local KOTH_BOARD_IMAGE_WIDTH = 256
local KOTH_BOARD_IMAGE_HEIGHT = 134
local KOTH_BOARD_WIDTH = 256
local KOTH_BOARD_HEIGHT = 134

local TIME_NOTE_IMAGE_WIDTH = 512
local TIME_NOTE_IMAGE_HEIGHT = 297
local TIME_NOTE_WIDTH = 64
local TIME_NOTE_HEIGHT = 37
local TIME_NOTE_ANCHOR_BLUE = KOTH_BOARD_WIDTH * 0.16
local TIME_NOTE_Y = KOTH_BOARD_HEIGHT * .62
local TIME_NOTE_ANCHOR_RED = KOTH_BOARD_WIDTH * .59

local SCORE_ANCHOR_BLUE = 0.26 * KOTH_BOARD_WIDTH
local SCORE_ANCHOR_RED = 0.68 * KOTH_BOARD_WIDTH
local SCORE_Y = KOTH_BOARD_HEIGHT * 0.33
local SCORE_HEIGHT = 20

local TIME_HEIGHT = 20
local TIME_Y = TIME_NOTE_HEIGHT * 0.27
local TIME_SECONDS_ANCHOR = TIME_NOTE_WIDTH * 0.25


KotHDisplay = {}
KotHDisplay.Enabled = false

KotHDisplay.Build = function(parent, offset)

	--Main Frame
	KotHDisplay.Frame = Singularity.Gui.Panel:new("KotH Panel")
	KotHDisplay.Frame:Set_Visible(false)
	KotHDisplay.Frame:Set_Size(Vector2:new(KOTH_BOARD_WIDTH, KOTH_BOARD_HEIGHT*2))
	KotHDisplay.Frame:Set_Position(Vector2:new(offset.x - KOTH_BOARD_WIDTH*0.5, offset.y))
	parent:AddControl(KotHDisplay.Frame)
	
	local tex = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\KotHBoard.png")
	local ninepatch = Singularity.Gui.NinePatch:new(tex, Vector2:new(KOTH_BOARD_IMAGE_WIDTH, KOTH_BOARD_IMAGE_HEIGHT), Vector4:new(0, 0, 0, 0))
	
	--Background image
	KotHDisplay.Board = Singularity.Gui.Image:new("KotH BG")
	KotHDisplay.Board:Set_Texture(ninepatch)
	KotHDisplay.Board:Set_Visible(true)
	KotHDisplay.Board:Set_Size(Vector2:new(KOTH_BOARD_WIDTH, KOTH_BOARD_HEIGHT))
	KotHDisplay.Board:Set_Position(Vector2:new(0, 0))
	KotHDisplay.Frame:AddControl(KotHDisplay.Board)	
	
	--Blue Team Score Text
	KotHDisplay.BlueScore = Singularity.Gui.Label:new("Blue Score", "0")
	KotHDisplay.BlueScore:Set_Font(Singularity.Gui.Font:Get_Font("Bauhaus24 Regular"))
	KotHDisplay.BlueScore:Set_Visible(true)
	local width = Singularity.Gui.Font:GetStringWidth(KotHDisplay.BlueScore:Get_Font(), KotHDisplay.BlueScore:Get_Text())
	KotHDisplay.BlueScore:Set_Size(Vector2:new(width, SCORE_HEIGHT))
	KotHDisplay.BlueScore:Set_Position(Vector2:new(SCORE_ANCHOR_BLUE, SCORE_Y))
	KotHDisplay.Frame:AddControl(KotHDisplay.BlueScore)
	
	--Red Team Score Text
	KotHDisplay.RedScore = Singularity.Gui.Label:new("Red Score", "0")
	KotHDisplay.RedScore:Set_Font(Singularity.Gui.Font:Get_Font("Bauhaus24 Regular"))
	KotHDisplay.RedScore:Set_Visible(true)
	local width = Singularity.Gui.Font:GetStringWidth(KotHDisplay.RedScore:Get_Font(), KotHDisplay.RedScore:Get_Text())
	KotHDisplay.RedScore:Set_Size(Vector2:new(width, SCORE_HEIGHT))
	KotHDisplay.RedScore:Set_Position(Vector2:new(SCORE_ANCHOR_RED, SCORE_Y))
	KotHDisplay.Frame:AddControl(KotHDisplay.RedScore)
	
	--Frame for the time display
	KotHDisplay.TimeNoteFrame = Singularity.Gui.Panel:new("Time Note Panel")
	KotHDisplay.TimeNoteFrame:Set_Visible(false)
	KotHDisplay.TimeNoteFrame:Set_Size(Vector2:new(TIME_NOTE_WIDTH, TIME_NOTE_HEIGHT))
	KotHDisplay.TimeNoteFrame:Set_Position(Vector2:new(TIME_NOTE_ANCHOR_BLUE, TIME_NOTE_Y))
	KotHDisplay.Frame:AddControl(KotHDisplay.TimeNoteFrame)
	
	tex = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\TimeNote.png")
	ninepatch = Singularity.Gui.NinePatch:new(tex, Vector2:new(TIME_NOTE_IMAGE_WIDTH, TIME_NOTE_IMAGE_HEIGHT), Vector4:new(0, 0, 0, 0))
	
	--BG for the time display
	KotHDisplay.TimeNote = Singularity.Gui.Image:new("Time Note BG")
	KotHDisplay.TimeNote:Set_Texture(ninepatch)
	KotHDisplay.TimeNote:Set_Visible(true)
	KotHDisplay.TimeNote:Set_Size(Vector2:new(TIME_NOTE_WIDTH, TIME_NOTE_HEIGHT))
	KotHDisplay.TimeNote:Set_Position(Vector2:new(0, 0))
	KotHDisplay.TimeNoteFrame:AddControl(KotHDisplay.TimeNote)
	
	--Time Label
	KotHDisplay.TimeSeconds = Singularity.Gui.Label:new("Time Seconds", "09")
	KotHDisplay.TimeSeconds:Set_Font(Singularity.Gui.Font:Get_Font("Bauhaus24 Regular"))
	KotHDisplay.TimeSeconds:Set_Visible(true)
	local width = Singularity.Gui.Font:GetStringWidth(KotHDisplay.TimeSeconds:Get_Font(), KotHDisplay.TimeSeconds:Get_Text())
	KotHDisplay.TimeSeconds:Set_Size(Vector2:new(width, TIME_HEIGHT))
	KotHDisplay.TimeSeconds:Set_Position(Vector2:new(TIME_SECONDS_ANCHOR, TIME_Y))
	KotHDisplay.TimeNoteFrame:AddControl(KotHDisplay.TimeSeconds)	

end

KotHDisplay.Enable = function()

	KotHDisplay.Enabled = true
	KotHDisplay.Frame:Set_Visible(true)

end

KotHDisplay.Disable = function()

	KotHDisplay.Enabled = false
	KotHDisplay.Frame:Set_Visible(false)

end

KotHDisplay.UpdateTimer = function(timer)

	--format the time
	if(timer < 0) then
		KotHDisplay.TimeSeconds:Set_Text("00")
	elseif(timer < 10) then
		KotHDisplay.TimeSeconds:Set_Text("0"..timer)
	else
		KotHDisplay.TimeSeconds:Set_Text(tostring(timer))
	end	

end

KotHDisplay.Update = function(elapsed)

	if(KotHDisplay.Enabled) then
		
		KotHDisplay.BlueScore:Set_Text(tostring(KotH.Scores[PLAYER_TEAM_BLUE]))
		KotHDisplay.RedScore:Set_Text(tostring(KotH.Scores[PLAYER_TEAM_RED]))
		
		if(KotH.ControllingTeam == 0) then
			KotHDisplay.TimeNoteFrame:Set_Visible(false)
		elseif(KotH.ControllingTeam == PLAYER_TEAM_BLUE) then
			--shift the frame to the blue side of the scoreboard
			KotHDisplay.TimeNoteFrame:Set_Position(Vector2:new(TIME_NOTE_ANCHOR_BLUE, TIME_NOTE_Y))
			KotHDisplay.TimeNoteFrame:Set_Visible(true)
			local timer = math.floor(KotH.Timer)
			KotHDisplay.UpdateTimer(timer)			
		else
			--shift the frame to the red side of the scoreboard
			KotHDisplay.TimeNoteFrame:Set_Position(Vector2:new(TIME_NOTE_ANCHOR_RED, TIME_NOTE_Y))
			KotHDisplay.TimeNoteFrame:Set_Visible(true)
			local timer = math.floor(KotH.Timer)
			KotHDisplay.UpdateTimer(timer)
		end
	end
	
end
