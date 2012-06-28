Sandbox.Player = 
{
	Enabled = false
}

-- Input
local Input = Singularity.Inputs.Input

-- Anim States
PLAYER_STATE_IDLE = 1
PLAYER_STATE_DEAD = 2
PLAYER_STATE_JUMPING = 3
PLAYER_STATE_TAUNTING = 4
PLAYER_STATE_DYING = 5
PLAYER_STATE_FORWARD = 6
PLAYER_STATE_BACKWARD = 7
PLAYER_STATE_LEFT = 8
PLAYER_STATE_RIGHT = 9

-- Anim Actions
PLAYER_ACTION_LEFT = 1
PLAYER_ACTION_RIGHT = 2
PLAYER_ACTION_FORWARD = 3
PLAYER_ACTION_BACKWARD = 4
PLAYER_ACTION_JUMP = 5
PLAYER_ACTION_DIE = 6
PLAYER_ACTION_IDLE = 7
PLAYER_ACTION_SLIDE = 8

--
PLAYER_HEIGHT = 66

-- Object Data
Sandbox.Player.DynamicData =
{
	WalkRate = 10000
}

-- Shared Functions
Sandbox.Player.Functions =
{
	---------------------------------------------------------------------------
	-- ChangeState
	---------------------------------------------------------------------------
	ChangeState = function(self, state)
		self.State = state		
	end
}

-------------------------------------------------------------------------------
-- Initialize
-------------------------------------------------------------------------------
Sandbox.Player.Initialize = function()       
	Util.Debug("Initializing Sandbox Player...")

	-- Binder
	-- (global binder needed in Player.Create)
	binder = Singularity.Scripting.LuaBinder:new("Player Update")
	binder:Set_FunctionName("Sandbox.Player.Update")
	Main.Root:AddComponent(binder)
	
	Util.Debug("Sandbox Player Initialized.")
end

-------------------------------------------------------------------------------
-- Create
-------------------------------------------------------------------------------
Sandbox.Player.Create = function(Position, Direction)
	Util.Debug("Creating Sandbox Player...")
	
	local ret = Util.JoinTables(Util.ShallowTableCopy(Sandbox.Player.DynamicData), Util.ShallowTableCopy(Sandbox.Player.Functions))	
	ret.Root = Singularity.Components.GameObject:Create("Player Node", Main.Root)
	ret.Root:Get_Transform():Translate(Position.x, Position.y, Position.z)
	
	-- Add a Camera
	ret.CameraNode = Singularity.Components.GameObject:Create("Camera Node", Main.Root)
	ret.CameraNode:Get_Transform():Translate(0, PLAYER_HEIGHT * 0.9, 0)
	ret.CameraNode:Get_Transform():LookAt(Vector3:new(Direction.x, Direction.y, Direction.z))
	ret.CameraNode:AddComponent(Sandbox.Player.Camera.Component)	
	Sandbox.Player.Camera.PreviousMouseState = Singularity.Inputs.Input:GetMouseState()
	
	-- Register Update
	ret.Root:AddComponent(binder)
	
	--Sandbox.Player.Animation.StateTable = Sandbox.Player.Animation.States[PLAYER_STATE_IDLE]
	
	Util.Debug("Sandbox Player Created.")
	return ret
end

-------------------------------------------------------------------------------
-- Enable
-------------------------------------------------------------------------------
Sandbox.Player.Enable = function()
	
	Sandbox.Player.Enabled = true
end

-------------------------------------------------------------------------------
-- Update
-------------------------------------------------------------------------------
Sandbox.Player.Update = function(sender, elapsedTime)
	
	if(Sandbox.Player.Enabled) then
		Sandbox.Player.Camera.Update(sender, elapsedTime)
		--Sandbox.Player.Animation.Update(sender, elapsedTime)
	end
end


--=============================================================================
-- Camera
--=============================================================================
Sandbox.Player.Camera = 
{
	Enabled = false,
	Rotation = Vector3:new(0,0,0),
	Height = 0,
	Component = Singularity.Graphics.Camera:new("FPS Camera"),
	
	Activate = function(self)
		Util.Debug("Enabling Player Camera....")
		Sandbox.Player.Camera.Enabled = true
	end,
	Deactivate = function(self)
		Util.Debug("Disabling Player Camera....")
		Sandbox.Player.Camera.Enabled = false
	end
}

-------------------------------------------------------------------------------
-- Camera Update
-------------------------------------------------------------------------------
Sandbox.Player.Camera.Update = function(sender, elapsedTime)
	
	if(not Sandbox.Player.Camera.Enabled) then
		return
	end
	
	-- Retrieve Current Inputs States
	local mouseState = Singularity.Inputs.Input:GetMouseState()
	local keyboardState = Singularity.Inputs.Input:GetKeyboardState()
	
	if(Sandbox.Player.Camera.PreviousMouseState ~= state) then		
		local forward				= Sandbox.Player.Camera.Component:Get_Forward()
		local right 				= Sandbox.Player.Camera.Component:Get_Right()
		local transform 			= Sandbox.Player.Client.CameraNode:Get_Transform()
		local playerTransform 		= Sandbox.Player.Client.Root:Get_Transform()
		
		local x, y, width, height 	= Singularity.Graphics.Screen:GetSize(0, 0, 0, 0)
		local mousePos 				= mouseState:GetMousePosition()
		--local action 				= PLAYER_ACTION_IDLE
		
		-- Update camera using mouse. Handle possible camera inversion:
		--if(not Player.Camera.Inverted) then
			Sandbox.Player.Camera.Rotation.x = Sandbox.Player.Camera.Rotation.x + math.pi * ((mousePos.y / height) * 2 - 1) * 0.5
			Sandbox.Player.Camera.Rotation.x = math.min(math.pi * 0.25, math.max(-math.pi * 0.5, Sandbox.Player.Camera.Rotation.x))
			Sandbox.Player.Camera.Rotation.y = Sandbox.Player.Camera.Rotation.y + math.pi * ((mousePos.x / width) * 2 - 1) * 0.5
		--else
		--	Sandbox.Player.Camera.Rotation.x = Sandbox.Player.Camera.Rotation.x + math.pi * ((mousePos.y / height) * 2 - 1) * 0.5
		--	Sandbox.Player.Camera.Rotation.x = math.min(math.pi * 1.25, math.max(math.pi * 0.5, Sandbox.Player.Camera.Rotation.x))
		--	Sandbox.Player.Camera.Rotation.y = Sandbox.Player.Camera.Rotation.y - math.pi * ((mousePos.x / width) * 2 - 1) * 0.5
		--end
		
		--Y Rot Quat
		q1 = Singularity.Components.Transform:EulerToRotation(Vector3:new(0,Sandbox.Player.Camera.Rotation.y, 0))
		--X Rot Quat
		q2 = Singularity.Components.Transform:EulerToRotation(Vector3:new(Sandbox.Player.Camera.Rotation.x,0, 0))
		--Composition
		product = Util.QuaternionMultiply(q1, q2)
		
		--Player only does Y Rot
		playerTransform:Set_Rotation(q1)
		--Camera does both
		transform:Set_Rotation(product)
		
		--Body uses a quaternion with an inverted axis to correct a difference between the camera and body
		product.x = -product.x 
		product.y = -product.y 
		product.z = -product.z 
		--bodyTransform:Set_Rotation(product)
		position = transform:Get_Position()
		
		--Only move on the XZ plane
		forward.y = 0
		Util.Normalize(forward)
		
		--Reset inputs
		Sandbox.Player.Camera.PreviousMouseState = mouseState
		Singularity.Inputs.Input:ResetMousePosition()
		
		--Set final positions
		local cameraFinal = Sandbox.Player.Client.Root:Get_Transform():Get_Position()
		cameraFinal.y = cameraFinal.y + Sandbox.Player.Camera.Height
		transform:Set_Position(cameraFinal)	
	end	
end





















