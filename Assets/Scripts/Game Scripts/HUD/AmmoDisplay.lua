AmmoDisplay = {}

local AMMO_IMAGE_WIDTH = 108
local AMMO_IMAGE_HEIGHT = 100
local AMMO_WIDTH = 108
local AMMO_HEIGHT = 100

AmmoDisplay.Enabled = false

AmmoDisplay.Build = function(parent, offset)

	local tex = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\DuctTapeAmmo.png")
	local ninepatch = Singularity.Gui.NinePatch:new(tex, Vector2:new(AMMO_IMAGE_WIDTH, AMMO_IMAGE_HEIGHT), Vector4:new(0, 0, 0, 0))
	
	offset.x = offset.x - AMMO_WIDTH * 0.5
	
	--Duct Tape image background
	AmmoDisplay.Tape = Singularity.Gui.Image:new("Ammo Display")
	AmmoDisplay.Tape:Set_Texture(ninepatch)
	AmmoDisplay.Tape:Set_Visible(false)
	AmmoDisplay.Tape:Set_Size(Vector2:new(AMMO_WIDTH, AMMO_HEIGHT))
	AmmoDisplay.Tape:Set_Position(Vector2:new(offset.x, offset.y - AMMO_HEIGHT))
	parent:AddControl(AmmoDisplay.Tape)
	
	AmmoDisplay.Offset = offset
	
	--Current Ammo
	AmmoDisplay.Current = Singularity.Gui.Label:new("Current Ammo Label", "0")
	AmmoDisplay.Current:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic11 Bold"))
	AmmoDisplay.Current:Set_Visible(false)
	parent:AddControl(AmmoDisplay.Current)
	
	--Total Ammo
	AmmoDisplay.Max = Singularity.Gui.Label:new("Max Ammo Label", "0")
	AmmoDisplay.Max:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic11 Bold"))
	AmmoDisplay.Max:Set_Visible(false)
	parent:AddControl(AmmoDisplay.Max)
	
	AmmoDisplay.PositionLabels()
	
end

AmmoDisplay.Enable = function()
	AmmoDisplay.Enabled = true
	AmmoDisplay.Current:Set_Visible(true)
	AmmoDisplay.Max:Set_Visible(true)
	AmmoDisplay.Tape:Set_Visible(true)
end

AmmoDisplay.Disable = function()
	AmmoDisplay.Enabled = false
	AmmoDisplay.Current:Set_Visible(false)
	AmmoDisplay.Max:Set_Visible(false)
	AmmoDisplay.Tape:Set_Visible(false)
end

AmmoDisplay.PositionLabels = function()
              
	--recalculate text width and center it on BG
	local width = Singularity.Gui.Font:GetStringWidth(AmmoDisplay.Current:Get_Font(), AmmoDisplay.Current:Get_Text())
	local height = 20
	AmmoDisplay.Current:Set_Size(Vector2:new(width, height))
	AmmoDisplay.Current:Set_Position(Vector2:new(AmmoDisplay.Offset.x + AMMO_WIDTH*0.4 - width*0.5, AmmoDisplay.Offset.y - AMMO_HEIGHT + AMMO_HEIGHT*0.45))

	width = Singularity.Gui.Font:GetStringWidth(AmmoDisplay.Max:Get_Font(), AmmoDisplay.Max:Get_Text())
	height = 20
	AmmoDisplay.Max:Set_Size(Vector2:new(width, height))
	AmmoDisplay.Max:Set_Position(Vector2:new(AmmoDisplay.Offset.x + AMMO_WIDTH*0.6 - width*0.5, AmmoDisplay.Offset.y - AMMO_HEIGHT + AMMO_HEIGHT*0.75))

end

AmmoDisplay.Update = function(elapsed)

	if(AmmoDisplay.Enabled) then
		local client = Player.Client
		if(not client) then return end
		local weapon = client:CurrentWeapon()
		if(not weapon) then return end
		
		--fill fields based on type
		if(weapon.Type == "Pistol" or weapon.Type == "CannonGun" or weapon.Type == "SniperRifle" or weapon.Type == "Grenade") then
			--these have no clip
			AmmoDisplay.Current:Set_Text(tostring(weapon.Ammo))
			AmmoDisplay.Max:Set_Text(tostring(weapon.Ammo))
		elseif(weapon.Type == "Shotgun" or weapon.Type == "AssaultRifle") then
			--these have clips
			AmmoDisplay.Current:Set_Text(tostring(weapon.Clip))
			AmmoDisplay.Max:Set_Text(tostring(weapon.Ammo))
		else
			--these have no ammo
			AmmoDisplay.Current:Set_Text("1")
			AmmoDisplay.Max:Set_Text("Inf")
		end
		
  		AmmoDisplay.PositionLabels()
	end
	
end
