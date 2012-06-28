ModifierTargets = {Enabled = false}

ModifierTargets.IconNinePatches = {}

local TARGET_IMAGE_SIZE = 128
local TARGET_MAX_SIZE = 96
local TARGET_MIN_SIZE = 32
local TARGET_MAX_OPACITY = 0.5
local TARGET_MIN_OPACITY = 0.3
local TARGET_MAX_DISTANCE = 3000 --30
local TARGET_MIN_DISTANCE = 50 --0.5

ModifierTargets.BuildNinePatch = function(path)
	local tex = Singularity.Graphics.Texture2D:LoadTextureFromFile(path)
	local ninepatch = Singularity.Gui.NinePatch:new(tex, Vector2:new(TARGET_IMAGE_SIZE, TARGET_IMAGE_SIZE), Vector4:new(0, 0, 0, 0))
	
	return ninepatch
end

--World Icon images
ModifierTargets.IconNinePatches.Grow = ModifierTargets.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Modifier Icons\\Grow.png")
ModifierTargets.IconNinePatches.Shrink = ModifierTargets.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Modifier Icons\\Shrink.png")
ModifierTargets.IconNinePatches.InvertGravity = ModifierTargets.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Modifier Icons\\InvertGravity.png")
ModifierTargets.IconNinePatches.Knockback = ModifierTargets.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Modifier Icons\\Knockback.png")
ModifierTargets.IconNinePatches.IncreaseGravity = ModifierTargets.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Modifier Icons\\FeatherLight.png")
ModifierTargets.IconNinePatches.Wall = ModifierTargets.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Modifier Icons\\Wall.png")
ModifierTargets.IconNinePatches.Illusion = ModifierTargets.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Modifier Icons\\Illusion.png")
ModifierTargets.IconNinePatches.Frictionless = ModifierTargets.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\Modifier Icons\\Frictionless.png")

--Control point icon image
ModifierTargets.IconNinePatches.ControlPoint = ModifierTargets.BuildNinePatch(Main.AssetDirectory.."\\Textures\\HUD\\ControlPointIcon.png")

ModifierTargets.Targets = {}

ModifierTargets.Build = function(parent, maxTargets, width, height)
	
	ModifierTargets.MaxTargets = maxTargets
	ModifierTargets.Width = width
	ModifierTargets.Height = height
	
	--make control point image
	ModifierTargets.ControlPointTarget = Singularity.Gui.Image:new("Control Point Icon")
	ModifierTargets.ControlPointTarget:Set_Texture(ModifierTargets.IconNinePatches.ControlPoint)
	ModifierTargets.ControlPointTarget:Set_Visible(false)
	ModifierTargets.ControlPointTarget:Set_Size(Vector2:new(TARGET_IMAGE_SIZE, TARGET_IMAGE_SIZE))
	ModifierTargets.ControlPointTarget:Set_Position(Vector2:new(100,0))
	parent:AddControl(ModifierTargets.ControlPointTarget)
	
	--build modifier icon images
	for i = 1,maxTargets-1 do
		local img = Singularity.Gui.Image:new("Target Icon "..i)
		img:Set_Texture(ModifierTargets.IconNinePatches.Shrink)
		img:Set_Visible(false)
		img:Set_Size(Vector2:new(TARGET_IMAGE_SIZE, TARGET_IMAGE_SIZE))
		img:Set_Position(Vector2:new(100,0))
		img.Cull = true
		parent:AddControl(img)
		
		table.insert(ModifierTargets.Targets, img)
	end
	
end

ModifierTargets.Enable = function()
	ModifierTargets.Enabled = true
end

ModifierTargets.Disable = function()
	ModifierTargets.Enabled = false
end

Modifier.CameraDepth = function(targetWorldPos)

	--returns depth along the camera forward
	local playerPos = Player.Client.Root:Get_Transform():Get_Position()
	local targetDir = Util.Vector3Subtract(targetWorldPos, playerPos)
	targetDir = Util.Normalize(targetDir)
	local cameraDir = Player.Camera.Component:Get_Forward()
	
	local dot = targetDir.x * cameraDir.x + targetDir.y * cameraDir.y + targetDir.z * cameraDir.z

	return dot	
end

ModifierTargets.PlaceTarget = function(target, targetWorldPos)
	
	local depth = Modifier.CameraDepth(targetWorldPos)
	
	--cull it if it's behind us
	if(depth < 0) then
		return false
	end
	
	local playerPos = Player.Client.Root:Get_Transform():Get_Position()
	local diffX = playerPos.x - targetWorldPos.x
	local diffY = playerPos.y - targetWorldPos.y
	local diffZ = playerPos.z - targetWorldPos.z
	local dist = math.sqrt(diffX*diffX + diffY*diffY + diffZ*diffZ)
	
	--bound the distance
	local boundDist = dist
	if(boundDist > TARGET_MAX_DISTANCE) then
		boundDist = TARGET_MAX_DISTANCE
	elseif(boundDist < TARGET_MIN_DISTANCE) then
		boundDist = TARGET_MIN_DISTANCE
	end
	
	--find out how far along the range we are
	local perc = (boundDist - TARGET_MIN_DISTANCE)  / (TARGET_MAX_DISTANCE - TARGET_MIN_DISTANCE)
	
	--fade out the farther away it is
	local opacity = (1-perc)*TARGET_MAX_OPACITY + perc*TARGET_MIN_OPACITY
	target:Set_Color(Color:new(1,1,1,opacity))
	
	--make smaller the farther away it is
	local size = (1-perc) * TARGET_MAX_SIZE + perc * TARGET_MIN_SIZE
	size = size / dist
	if(size > TARGET_MAX_SIZE) then
		size = TARGET_MAX_SIZE
	elseif(size < TARGET_MIN_SIZE) then
		size = TARGET_MIN_SIZE
	end
	
	local pos = targetWorldPos:Project(Player.Camera.Component)
			
	--contain to the frame
	local culled = false
	if(pos.x < 0) then
		pos.x = 0
		culled = true
	elseif(pos.x > ModifierTargets.Width) then
		pos.x = ModifierTargets.Width
		culled = true
	end
	
	if(pos.y < 0) then
		pos.y = 0
		culled = true
	elseif(pos.y > ModifierTargets.Height) then
		pos.y = ModifierTargets.Height
		culled = true
	end
	
	--if the Cull option is set and it's not in the frame, fail
	if(target.Cull and culled) then
		return false
	end
	
	--center it
	pos.x = pos.x - size*0.5
	pos.y = pos.y - size*0.5
	
	target:Set_Size(Vector2:new(size, size))
	target:Set_Position(Vector2:new(pos.x, pos.y))
	
	target:Set_Visible(true)	
	return true
end

ModifierTargets.FindModifier = function()
	--reticule is always at the screen center
	local reticuleX = ModifierTargets.Width * 0.5
	local reticuleY = ModifierTargets.Height * 0.5
	
	local target = nil
	local size = 0
	local modPos = nil
	for i,v in ipairs(ModifierTargets.Targets) do
		if(v:Get_Visible()) then
			modPos = v:Get_Position()
			size = v:Get_Size().x
			--is the reticule in the icon's bounding box?
			if(reticuleX > modPos.x and reticuleX < modPos.x + size and reticuleY > modPos.y and reticuleY < modPos.y + size) then
				--if there's already a target
				if(target) then
					--if this one is closer, use it instead
					if(size > target.Size) then
						target.Target = v
						target.Size = size
					end
				else
					target = { Target = v, Size = size }
				end
			end
		end
	end
	
	--if we found an icon, return its associated modifier
	if(target) then
		return target.Target.Modifier
	else
		return nil
	end
end

ModifierTargets.Update = function(elapsed)
	if(ModifierTargets.Enabled) then
		
		local nextAvailable = 1
		local playerPos = Player.Client.Root:Get_Transform():Get_Position()
		
		--if there's a control point, show the control point icon
		if(#Match.ControlPoints > 0) then
			if(Match.CurrentControlPointIndex > 0) then			
				local point = Match.ControlPoints[Match.CurrentControlPointIndex]			
				ModifierTargets.PlaceTarget(ModifierTargets.ControlPointTarget, point.Position)							
			end
		end
		
		if(Player.Client and Player.Client.Modifiers) then
			local mods = Player.Client.Modifiers
			for i = 1, #mods do
				--quit if we run out of spots
				if(nextAvailable > ModifierTargets.MaxTargets-1) then
					break
				end
				
				--if this mod is on screen, show its icon
				if(ModifierTargets.PlaceTarget(ModifierTargets.Targets[nextAvailable], mods[i].ModifierModel:Get_Transform():Get_Position())) then
					ModifierTargets.Targets[nextAvailable]:Set_Texture(ModifierTargets.IconNinePatches[mods[i].Type])
					ModifierTargets.Targets[nextAvailable].Modifier = mods[i]
					nextAvailable = nextAvailable + 1	
				end
			end
		end

       	--hide all non-associated modifier icon images
		for i = nextAvailable, ModifierTargets.MaxTargets-1 do
			ModifierTargets.Targets[i]:Set_Visible(false)
		end
	end
end
