Screens.WinScreen = {}

Screens.WinScreen.Window = nil

Screens.WinScreen.Initialize = function()

	--Getting the width and height of the screen so we can create 
	width, height = Singularity.Graphics.Screen:GetResolution(0, 0)

	--loading the outcome of the match texture / ninepatch
	drawMatch = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\DrawWinScreen.png")
	Screens.WinScreen.DrawNP = Singularity.Gui.NinePatch:new(drawMatch, Vector2:new(drawMatch:Get_Width(), drawMatch:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	--Screens.WinScreen.DrawWinImage = 
	
	blueWin = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\BlueTeamWinScreens.png")
	Screens.WinScreen.BlueWinNP = Singularity.Gui.NinePatch:new(blueWin, Vector2:new(blueWin:Get_Width(), blueWin:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	--Screens.WinScreen.BlueWinImage = 
	
	redWin = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\RedTeamWinScreens.png")
	Screens.WinScreen.RedWinNP = Singularity.Gui.NinePatch:new(redWin, Vector2:new(redWin:Get_Width(), redWin:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	--Screens.WinScreen.RedWinImage = 
	
	-- we want score in here as well
	
	--Creating the window
	Screens.WinScreen.Window = Singularity.Gui.Window:new("Win Screen Window")
	Screens.WinScreen.Window:Set_Texture(Screens.WinScreen.DrawNP)
	Screens.WinScreen.Window:Set_Size(Vector2:new(width, height))
	Screens.WinScreen.Window:Set_Position(Vector2:new(0, 0))
	Screens.WinScreen.Window:Set_Draggable(false)
	Screens.WinScreen.Window:Set_Enabled(false)
	Screens.WinScreen.Window:Set_Visible(false)
	Player.HUD.GuiScreen:AddWindow(Screens.WinScreen.Window)
	
	
	
	
end

Screens.WinScreen.Activate = function()
	if(Screens.WinScreen.Window ~= nil) then
		Util.Debug("Activating Win Screen")
		Screens.WinScreen.Window:Set_Visible(true)
	end
end

Screens.WinScreen.Deactivate = function()
	if(Screens.WinScreen.Window ~= nil) then
		Screens.WinScreen.Window:Set_Visible(false)
	end
end

Screens.WinScreen.SetWinningTeam = function(team)
	if (team == PLAYER_TEAM_RED) then
		Screens.WinScreen.Window:Set_Texture(Screens.WinScreen.RedWinNP)
	elseif (team == PLAYER_TEAM_BLUE) then
		Screens.WinScreen.Window:Set_Texture(Screens.WinScreen.BlueWinNP)
	else
		Screens.WinScreen.Window:Set_Texture(Screens.WinScreen.DrawNP)
	end
end