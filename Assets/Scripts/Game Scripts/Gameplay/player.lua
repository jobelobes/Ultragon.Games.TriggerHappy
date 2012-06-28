--Constants
PLAYER_TEAM_RED = 1
PLAYER_TEAM_BLUE = 2
PLAYER_TEAM_ALL = 3

--Anim States
PLAYER_STATE_IDLE = 1
PLAYER_STATE_DEAD = 2
PLAYER_STATE_JUMPING = 3
PLAYER_STATE_TAUNTING = 4
PLAYER_STATE_DYING = 5
PLAYER_STATE_FORWARD = 6
PLAYER_STATE_BACKWARD = 7
PLAYER_STATE_LEFT = 8
PLAYER_STATE_RIGHT = 9

--Anim Actions
PLAYER_ACTION_LEFT = 1
PLAYER_ACTION_RIGHT = 2
PLAYER_ACTION_FORWARD = 3
PLAYER_ACTION_BACKWARD = 4
PLAYER_ACTION_JUMP = 5
PLAYER_ACTION_DIE = 6
PLAYER_ACTION_IDLE = 7
PLAYER_ACTION_SLIDE = 8

--Weapon Holding Positions
WEAPON_HOLD_TYPE_ONE = 1
WEAPON_HOLD_TYPE_TWO = 2
WEAPON_HOLD_TYPE_HIGH = 3

PLAYER_MAX_BUFFS = 2
PLAYER_MAX_HP = 100
PLAYER_MAX_ENERGY = 100
PLAYER_FRICTIONLESS_SPEEDUP = 1.5
PLAYER_HEIGHT = 35 --0.06
PLAYER_RADIUS = 1 --0.001
PLAYER_REMOTE_RADIUS = 20
PLAYER_HP_TICK_WINDOW = 10
PLAYER_REGEN_AMOUNT = 10

PLAYER_JUMP = 200000
PLAYER_MASS = 1000
PLAYER_GRAVITY = 980

--Input
local Input = Singularity.Inputs.Input

--Player System
Player = {
	Enabled = false,
}

--Player Object Data
Player.DynamicData = {
	WalkRate = 20000, --30.0,
	Kills = 0,
	Deaths = 0,
	State = PLAYER_STATE_DEAD,
	CurrentWeaponIndex = 0,
	HP = 0,
	Energy = 0,
}

Player.StaticData = {
	Animations = {
		[PLAYER_STATE_JUMPING] = {
			Start = 100,
			End = 230,
		},
		[PLAYER_STATE_IDLE] =
		{
			[WEAPON_HOLD_TYPE_ONE] = {
				Start = 50,
				End = 90,
			},
            [WEAPON_HOLD_TYPE_TWO] = {
				Start = 50,
				End = 90,
			},
			[WEAPON_HOLD_TYPE_HIGH] = {
				Start = 50,
				End = 90,
			},   
		}
	}
}

--Player Model
Player.StaticData.Mesh, Player.StaticData.Material = Util.GetMeshAndMaterial(Main.AssetDirectory.."\\Models\\Character.smurf")

--Shared Functions
Player.Functions = {
	--Called by network
	SetWeapons = function(self, weapons)
		self.Weapons = {}
		--rebuild weapons list by selecting from the cache
		for i,v in ipairs(weapons) do
			self.Weapons[i] = self.WeaponCache[v.Type]
			self.Weapons[i].Ammo = v.Ammo
			self.Weapons[i].Clip = v.Clip
		end
	end,
	--Called by network
	SetModifiers = function(self, modifiers)
		local added = {}
		local deleted = {}

		--find destroyed modifiers
		for _,existingModifier in ipairs(self.Modifiers) do
			local stillThere = false
			for _,newModifier in ipairs(modifiers) do
				if(existingModifier.ID == newModifier.ID) then
					stillThere = true
					break
				end
			end
			if(not stillThere) then
				table.insert(deleted, existingModifier)
			end
		end
		
		--find added modifiers
		for _,newModifier in ipairs(modifiers) do
			local newHere = true
			for _,existingModifier in ipairs(self.Modifiers) do
				if(newModifier.ID == existingModifier.ID) then
					newHere = false
				end
			end
			if(newHere) then
				table.insert(added, newModifier)
			end
		end
		
		--handle case where our modifier list is empty
		if(#self.Modifiers == 0) then
			for _,v in ipairs(modifiers) do
				local newMod = Modifier.Create(v.Type, Vector3:new(v.Position.x, v.Position.y, v.Position.z), Quaternion:new(v.Orientation.x, v.Orientation.y, v.Orientation.z, v.Orientation.w), v.ID, v.OwnerID)
				self:AddModifier(newMod)
			end
		end
	
		--destroy deleted ones
		for _,v in ipairs(deleted) do
			self:RemoveModifier(v)
			Modifier.Destroy(v)
		end

		--add added ones
		for _,v in ipairs(added) do
			local newMod = Modifier.Create(v.Type, Vector3:new(v.Position.x, v.Position.y, v.Position.z), Quaternion:new(v.Orientation.x, v.Orientation.y, v.Orientation.z, v.Orientation.w), v.ID, v.OwnerID)
			self:AddModifier(newMod)
		end
		
	end,
	--Changes animation state
	ChangeState = function(self, state)
		self.State = state

		--Debug printing
		for k,v in pairs(_G) do
        	if(v == state) then
				if(type(k) == "string" and string.sub(k, 1,12) == "PLAYER_STATE") then
                	--Util.Debug(k)
				end
			end
		end

		--Change Animation
		if(not Player.StaticData.Animations[state]) then
			return
		end

		if(Player.StaticData.Animations[state].Start) then
        	--Animation doesnt depend on weapon
        	--Play start and end
		else
			local root =  Player.StaticData.Animations[state]
			if(root) then
				local anim = root[Weapon.StaticData[self:CurrentWeapon().Type].HoldType]
				--Play Anim start and end
			end
		end
	end,
	CurrentWeapon = function(self)
		return self.Weapons[self.CurrentWeaponIndex]
	end,
	GetWeaponByType = function(self, typeOf)
		for _,v in ipairs(self.Weapons) do
			if(v.Type == typeOf) then
				return v
			end
		end
	end,
	--Changes the player's current weapon
	SelectWeapon = function(player,index)
		local isClient = (player.ID == Player.Client.ID)

		--dont bother if the index is out of bounds or the same
		if(index > #player.Weapons or index == player.CurrentWeaponIndex or index < 1) then
			return
		end
		
		--if the player hasn't chosen a weapon yet
		if(player.CurrentWeaponIndex < 1) then
			--do it instantly
			player:ToggleWeapon(index)
			player.CurrentWeaponIndex = index
		--if they're remote
		elseif(not isClient) then
			--also do it instantly
			player:ToggleWeapon(player.CurrentWeaponIndex)
			player:ToggleWeapon(index)
			player.CurrentWeaponIndex = index
		else
			if(isClient) then
				--if weapon changing isn't cooling down
				if(Player.WeaponStates.State == Player.WeaponStates.Active) then
					Player.WeaponStates.NextWeaponIndex = index

					--initiate the change
					Player.WeaponStates.ChangeState(Player.WeaponStates.ChangeDown)
					local comp = tolua.cast (player.Weapons[player.CurrentWeaponIndex].WeaponModel:GetComponent("Singularity.Audio.AudioEmitter"), "Singularity::Audio::AudioEmitter")
					comp:Play(2)
				end
			end
		end
	end,
	--Flip the visibility of a weapon model
	ToggleWeapon = function(player, index)
		player.Weapons[index].WeaponModel:Set_IsActive(not player.Weapons[index].WeaponModel:Get_IsActive())
	end,
	AddModifier = function(self, modifier)
		table.insert(self.Modifiers, modifier)
	end,
	RemoveModifier = function(self,modifier)
		for i = 1,#self.Modifiers do
			if(self.Modifiers[i].ID == modifier.ID) then
				table.remove(self.Modifiers, i)
				return
			end
		end
	end,
	GetModifierByID = function(self, id)
		for i = 1,#self.Modifiers do
			if(self.Modifiers[i].ID == id) then
				return self.Modifiers[i]
			end
		end
		return nil
	end
}

--Client only functions
Player.ClientFunctions = {
	AddBuff = function(self,buff)
		table.insert(Player.Buffs, buff)
	end,
	--returns true if the player isn't maxed on buffs
	CanAddBuff = function(self)
		return self:CountModifierBuffs() < PLAYER_MAX_BUFFS
	end,
	GetBuff = function(player, buff)
		for _,v in ipairs(Player.Buffs) do
			if(v.Name == buff.Name) then
				return v
			end
		end
		return nil
	end,
	CountModifierBuffs = function(player)
		local cnt = 0
		for k,v in pairs(Player.Buffs) do
			local pre = v.Name:sub(1,5)
			--filter out the achievement buffs and the control point buff
			if(pre ~= "Speed" and pre ~= "Healt" and pre ~= "Contr") then
				cnt = cnt + 1
			end
		end
		return cnt
	end,
	TakeDamage = function(self, damage, attacker)
		self.HP = self.HP - damage
		--stop regenerating hp
		Player.RegenElapsed = 0
		if(self.HP <= 0) then
			--take a death
			self.Deaths = self.Deaths + 1
			Player.Animation.HandleAction(PLAYER_ACTION_DIE)
			--notify others
			local msg = {
				ID = Player.Client.ID,
				AttackerID = attacker.ID,
			}
			Network.SendReliable(Player.Network.PlayerDeadType, msg)
		end
	end,
	HasBuffType = function(self, buff)
		for _,v in ipairs(Player.Buffs) do
			if(v.Name == buff.Name) then
				return true
			end
		end
		return false
	end,
	RemoveBuff = function(self, buff)
		for i,v in ipairs(Player.Buffs) do
			if(v.Name == buff.Name) then
				table.remove(Player.Buffs, i)
				return
			end
		end
	end,
	AddWeapon = function(self, typeOf)
		for i,v in ipairs(self.Weapons) do
			--dont add two of the same weapons
			if(v.Type == typeOf) then
				return
			end
		end
		--reset the weapon ammo
		self.WeaponCache[typeOf]:Reset()
		--add it
		table.insert(self.Weapons, self.WeaponCache[typeOf])
	end,
	GetWeapons = function(self)
		return self.Weapons
	end,
	RemoveAllWeapons = function(self)
		for k,v in pairs(self.Weapons) do
			v.WeaponModel:Set_IsActive(false)
			self.CurrentWeaponIndex = -1
		end
		self.Weapons = {}
	end,
	Restore = function(self)
		local position = Player.Client.CameraNode:Get_Transform():Get_Position()
		Util.Debug("new position: "..position.x..", "..position.y..", "..position.z)
		--generating a random index within the spawn points bounds then passing the position to the player to be set
		local positionIndex = math.random(#Match.SpawnPoints)
		
		--checking to make sure the spawn point is for the correct team. 
		while((Match.SpawnPoints[positionIndex].Team ~= self.Team) and Match.SpawnPoints[positionIndex].Team ~= PLAYER_TEAM_ALL) do
			positionIndex = math.random(#Match.SpawnPoints)
		end
		
		position = Match.SpawnPoints[positionIndex].Position
		
		self.HP = PLAYER_MAX_HP
		self.Energy = PLAYER_MAX_ENERGY
		self.State = PLAYER_STATE_IDLE
		Util.Debug("Spawn position: "..positionIndex)
		Util.Debug("new position: "..position.x..", "..position.y..", "..position.z)
		--Player.Client.CameraNode:Get_Transform():Set_Position(Match.SpawnPoints[positionIndex].Position)	--setting the spawn location of the player
		local controller = tolua.cast(Player.Client.Root:GetComponent("Singularity.Physics.CharacterController"), "Singularity::Physics::CharacterController")
		controller:Set_Position(position)
		Player.Client.CameraNode:Get_Transform():Set_Position(position)
		position = Player.Client.CameraNode:Get_Transform():Get_Position()
		Util.Debug("new position: "..position.x..", "..position.y..", "..position.z)
		Player.Animation.StateTable = Player.Animation.States[PLAYER_STATE_IDLE]

		Player.Client.IsDeadFromFalling = false
		
		--reset all weapons
		for k,v in pairs(self.Weapons) do
			v:Reset()
		end
	end,
}

--Remote Player Constructor
Player.Create = function(ID, Name, Team, Position, Direction)
	local ret = Player.InitGeneral(ID, Name, Team, Position, Direction)
	Main.GamePlay.Players[ID] = ret
	
	--Make Model with Mesh
	ret.BodyNode = Singularity.Components.GameObject:Create("Player Node", Main.Root)
	ret.BodyNode:Get_Transform():Set_Position(Position)
	local comp = Singularity.Graphics.MeshRenderer:new(Player.StaticData.Mesh:Clone(), Player.StaticData.Material:Clone())
	ret.BodyNode:AddComponent(comp)

	--Make Collision Volume
	ret.CapsuleCollider = Singularity.Physics.CapsuleCollider(tostring(ID).."-Collider", Position, PLAYER_REMOTE_RADIUS, PLAYER_HEIGHT)
	ret.BodyNode:AddComponent(ret.CapsuleCollider)
	
	--Make Weapons
	ret.WeaponCache = Weapon.CreateAllWeapons(ret, false)

	return ret
end

--Shared Constructor
Player.InitGeneral = function(ID, Name, Team, Position, Direction)
	--init the object
	local ret = Util.JoinTables(Util.ShallowTableCopy(Player.DynamicData), Util.ShallowTableCopy(Player.Functions))
		
	--save important data
	ret.ID = ID
	ret.Name = Name
	ret.Team = Team
	ret.Weapons = {}
	ret.Modifiers = {}
	
	--Player Root
	ret.Root = Singularity.Components.GameObject:Create("Player Node", Main.Root)
	ret.Root:Get_Transform():Translate(Position.x, Position.y, Position.z)
		
	--Player Audio
	local comp = Audio.Manager:GetNewEmitter("Player")
	comp:AddCue(Audio.Manager:CreateCue("player_FootstepsHard"))
	ret.Root:AddComponent(comp)	
	
	return ret
end

--Client Constructor
Player.CreateClient = function(ID, Name, Team, Position, Direction)
	Player.Client = Player.InitGeneral(ID, Name, Team, Position, Direction)
	--add in client only functions
	Player.Client = Util.JoinTables(Player.Client, Util.ShallowTableCopy(Player.ClientFunctions))
		
	--Client gets a camera
	Player.Client.CameraNode = Singularity.Components.GameObject:Create("Camera Node", Main.Root)
	Player.Client.CameraNode:Get_Transform():Translate(0, PLAYER_HEIGHT * 0.9, 0)
	Player.Client.CameraNode:Get_Transform():LookAt(Vector3:new(Direction.x, Direction.y, Direction.z))
	Player.Client.CameraNode:AddComponent(Player.Camera.Component)
	Player.Camera.PreviousMouseState = Singularity.Inputs.Input:GetMouseState()
	
	--Client gets listener
	Player.Client.Root:AddComponent(Singularity.Audio.AudioManager:Instantiate():GetSingleListener())
	
	--Client gets Update
	Player.Client.Root:AddComponent(binder)	

	--Client gets additional positioning nodes
	Player.Client.BodyNode = Singularity.Components.GameObject:Create("Body Node", Main.Root)
	Player.Client.FootNode = Singularity.Components.GameObject:Create("Body Node", Player.Client.Root)
	Player.Client.FootNode:Get_Transform():Set_LocalPosition(Vector3:new(0, -PLAYER_HEIGHT, 0))
	
	--Weapons
	Player.Client.WeaponCache = Weapon.CreateAllWeapons(Player.Client, true)
	
	--On Ground
	Player.Client.OnGround = true
	
	--Dead From Falling
	Player.Client.IsDeadFromFalling = false

	--Client get Physics component
	Player.Client.CharacterController = Singularity.Physics.CharacterController:new(ID.."-Collider")
	Player.Client.CharacterController:Set_Height(PLAYER_HEIGHT)  -- current player height since we can't rip it off the mesh
	Player.Client.CharacterController:Set_Radius(PLAYER_RADIUS) -- roughly 1/3
	Player.Client.Root:AddComponent(Player.Client.CharacterController)
	Player.Client.CharacterController:Set_Mass(PLAYER_MASS) -- ...
	Player.Client.CharacterController:Set_Gravity(-PLAYER_GRAVITY) -- everything is *100 right now
	
	--Reset buff list
	Player.Buffs = {}
	
	--Set Regen Timers
	Player.RegenElapsed = 0
	Player.WeaponRegenPrevious = 0
	Player.WeaponRegen = 0
	
	--Store player
	Main.GamePlay.Players[ID] = Player.Client
	
	--Debug
	Util.Debug("Player: "..Main.GamePlay.Players[ID].Name)
	Util.Debug("Number of players: "..table.getn(Main.GamePlay.Players))

	return Player.Client
end

--Animation
Player.Animation = {
    First = true,
	ChangeState = function(state)
		Player.Client:ChangeState(state)
		Player.Animation.StateTable = Player.Animation.States[state]
		if(Player.Animation.StateTable.Activate) then
			Player.Animation.StateTable:Activate()
		end
	end,
	--Responds to a game action
	HandleAction = function(action)
		--let the state handle it, or if it doesn't want to, do the default
		if(Player.Animation.StateTable.HandleAction) then
        	Player.Animation.StateTable:HandleAction(action)
		else
            Player.Animation.DefaultActionHandler(action)
		end
	end,
	Update = function(elapsed)
		if(Player.Animation.StateTable.Process) then
            Player.Animation.StateTable:Process(elapsed)
		end
	end,
	--Standard action responses
	DefaultActionHandler = function(action)
		if(action == PLAYER_ACTION_IDLE) then
            if(Player.Client.State ~= PLAYER_STATE_IDLE) then
        		Player.Animation.ChangeState(PLAYER_STATE_IDLE)
        	end
		elseif(action == PLAYER_ACTION_LEFT) then
			if(Player.Client.State ~= PLAYER_STATE_LEFT) then
        		Player.Animation.ChangeState(PLAYER_STATE_LEFT)
        	end
		elseif(action == PLAYER_ACTION_RIGHT) then
			if(Player.Client.State ~= PLAYER_STATE_RIGHT) then
            	Player.Animation.ChangeState(PLAYER_STATE_RIGHT)
            end
		elseif(action == PLAYER_ACTION_FORWARD) then
			if(Player.Client.State ~= PLAYER_STATE_FORWARD) then
            	Player.Animation.ChangeState(PLAYER_STATE_FORWARD)
            end
		elseif(action == PLAYER_ACTION_BACKWARD) then
			if(Player.Client.State ~= PLAYER_STATE_BACKWARD) then
		    	Player.Animation.ChangeState(PLAYER_STATE_BACKWARD)
		    end
		elseif(action == PLAYER_ACTION_JUMP) then
			if(Player.Client.State ~= PLAYER_STATE_JUMPING) then
            	Player.Animation.ChangeState(PLAYER_STATE_JUMPING)
            end
        elseif(action == PLAYER_ACTION_SLIDE) then
            if(Player.Client.State ~= PLAYER_STATE_IDLE) then
        		Player.Animation.ChangeState(PLAYER_STATE_IDLE)
        	end
        elseif(action == PLAYER_ACTION_DIE) then
            if(Player.Client.State ~= PLAYER_STATE_DYING) then
        		Player.Animation.ChangeState(PLAYER_STATE_DYING)
        	end
		end
	end,
	NullActionHandler = function(self, action)
		return
	end,
}

Player.Animation.States =
{
	--Empty tables indicate default behavior
	[PLAYER_STATE_IDLE] = {},
	[PLAYER_STATE_LEFT] = {},
	[PLAYER_STATE_RIGHT] = {},
	[PLAYER_STATE_FORWARD] = {},
	[PLAYER_STATE_BACKWARD] = {},
	[PLAYER_STATE_JUMPING] = {
		HandleAction = function(self, action)
			if(action == PLAYER_ACTION_DIE) then
				if(Player.Client.OnGround) then
                    Player.Animation.DefaultActionHandler(PLAYER_ACTION_DIE)
                    return
                --if we're falling and dead, wait till we hit the ground to go into the dying state
				else
                    self.Died = true
				end
			end
			if(Player.Client.OnGround) then
				--handle deferred death
				if(self.Died) then
                     Player.Animation.DefaultActionHandler(PLAYER_ACTION_DIE)
                     self.Died = false
				end
				Player.Animation.DefaultActionHandler(action)
			end
		end,
	},
	[PLAYER_STATE_DEAD] = {
        HandleAction = Player.Animation.NullActionHandler,
	},
	[PLAYER_STATE_DYING] = {
		DYING_DURATION = 0.5,
        HandleAction = Player.Animation.NullActionHandler,
        Activate = function(self)
        	self.Timer = 0
        end,
        Process = function(self,elapsed)
        	self.Timer = self.Timer + elapsed
        	--when the death animation is done, die for real
        	if(self.Timer > self.DYING_DURATION) then
        		self.Timer = 0
                Player.Animation.ChangeState(PLAYER_STATE_DEAD)
			end
        end,
	},
	[PLAYER_STATE_TAUNTING] = {
		HandleAction = Player.Animation.NullActionHandler,
	},
}

--We start off dead
Player.Animation.StateTable = Player.Animation.States[PLAYER_STATE_DEAD]
--End

--Weapon State
Player.HandleWeaponChange = function(elapsed)
	local nextWepIndex = -1
	--check number keys 1-9
	for i=2,10 do
		if(Input:IsKeyDown(i)) then
			nextWepIndex = i-1
			break
		end
	end

	if(nextWepIndex > -1) then
		Player.Client:SelectWeapon(nextWepIndex)
	end
end	

Player.WeaponStates =
{
	First = true,
	ChangeState = function(state)
		Player.WeaponStates.State = state
		Player.WeaponStates.First = true
	end,
	--State machine runner
	Update = function(elapsed)
		if(Player.WeaponStates.First) then
			Player.WeaponStates.First = false
			Player.WeaponStates.State.Process(elapsed, true)
		else
			Player.WeaponStates.State.Process(elapsed)
		end
	end,
	ChangeDownTime = 0.25,
	ChangeUpTime = 0.25,
	ChangeElapsed = 0,
	NextWeaponIndex = 0,
	OldWeaponIndex = 0,
	Active =
	{
		Process = function(elapsed, first)
		end
	},
	ChangeDown =
	{
		--Handle moving old gun out of view
		Process = function(elapsed, first)
			if(first) then
				Player.WeaponStates.ChangeElapsed = 0
				--Start Hands down animation
			else
				Player.WeaponStates.ChangeElapsed = Player.WeaponStates.ChangeElapsed + elapsed
			end
			
			if(Player.WeaponStates.ChangeElapsed > Player.WeaponStates.ChangeDownTime) then
				Player.WeaponStates.ChangeState(Player.WeaponStates.ChangeUp)
			end
		end
	},
	ChangeUp =
	{

		Process = function(elapsed, first)
			if(first) then
				Player.WeaponStates.ChangeElapsed = 0

				local client = Player.Client
				--Swap weapon
				client:ToggleWeapon(client.CurrentWeaponIndex)
				client:ToggleWeapon(Player.WeaponStates.NextWeaponIndex)
			else
				Player.WeaponStates.ChangeElapsed = Player.WeaponStates.ChangeElapsed + elapsed
			end
			
			--Handle moving weapon back up
			if(Player.WeaponStates.ChangeElapsed > Player.WeaponStates.ChangeUpTime) then
				Player.Client.CurrentWeaponIndex = Player.WeaponStates.NextWeaponIndex
				Player.WeaponStates.ChangeState(Player.WeaponStates.Active)
			end
		end
	},
}
--End

--Camera
Player.Camera = {
	Enabled = true,
	Rotation = Vector3:new(0,0,0),
	Height = 0,
	Component = Singularity.Graphics.Camera:new("FPS Camera"),
	
	Activate = function(self)
		Util.Debug("Enabling Player Camera")
		Player.Camera.Enabled = true
	end,
	Deactivate = function(self)
		Util.Debug("Disabling Player Camera")
		Player.Camera.Enabled = false
	end
}

Player.Camera.Update = function(sender, elapsedtime)

	if(not Player.Camera.Enabled) then
		return
	end
	
	--Grab inputs
	mouseState = Singularity.Inputs.Input:GetMouseState()
	keyboardState = Singularity.Inputs.Input:GetKeyboardState()

	if(Player.Camera.PreviousMouseState ~= state) then
	
		local emitter = Player.Client.Root:GetComponent("Singularity.Audio.AudioEmitter")
		emitter = tolua.cast(emitter, "Singularity::Audio::AudioEmitter")
	
		local forward = Player.Camera.Component:Get_Forward()
		local right = Player.Camera.Component:Get_Right()
		local transform = Player.Client.CameraNode:Get_Transform()
		local playerTransform = Player.Client.Root:Get_Transform()
		local bodyTransform = Player.Client.BodyNode:Get_Transform()
		local x, y, width, height = Singularity.Graphics.Screen:GetSize(0, 0, 0, 0)
		local mousePos = mouseState:GetMousePosition()
		local action = PLAYER_ACTION_IDLE
		
		--Update camera using mouse. Handle possible camera inversion
		if(not Player.Camera.Inverted) then
			Player.Camera.Rotation.x = Player.Camera.Rotation.x + math.pi * ((mousePos.y / height) * 2 - 1) * 0.5
			Player.Camera.Rotation.x = math.min(math.pi * 0.25, math.max(-math.pi * 0.5, Player.Camera.Rotation.x))
			Player.Camera.Rotation.y = Player.Camera.Rotation.y + math.pi * ((mousePos.x / width) * 2 - 1) * 0.5
		else
			Player.Camera.Rotation.x = Player.Camera.Rotation.x + math.pi * ((mousePos.y / height) * 2 - 1) * 0.5
			Player.Camera.Rotation.x = math.min(math.pi * 1.25, math.max(math.pi * 0.5, Player.Camera.Rotation.x))
			Player.Camera.Rotation.y = Player.Camera.Rotation.y - math.pi * ((mousePos.x / width) * 2 - 1) * 0.5
		end
		
		--Y Rot Quat
		q1 = Singularity.Components.Transform:EulerToRotation(Vector3:new(0,Player.Camera.Rotation.y, 0))
		--X Rot Quat
		q2 = Singularity.Components.Transform:EulerToRotation(Vector3:new(Player.Camera.Rotation.x,0, 0))
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
		bodyTransform:Set_Rotation(product)
		position = transform:Get_Position()

		-- Translations. 
		
		--Only move on the XZ plane
		forward.y = 0
		Util.Normalize(forward)

		--Check if we need to get a sliding direction for Frictionless
		local grabSlide = false
		if(Player.Client:HasBuffType(Modifier.ModifierBehavior.Frictionless.Buff)) then
			if(not Player.Sliding) then
				grabSlide = true
			end
		elseif(Player.Sliding) then
			Player.Sliding = false
		end

		--If we do
		if(grabSlide) then
			Player.SlideDirection = Vector3:new(0,0,0)
			Player.SlideDirection.y = 0
			
			grabbed = false
			--Can slide in the four cardinal directions
			if(keyboardState:IsKeyDown(DIK_S)) then
				grabbed = true
				Player.SlideDirection.x = forward.x
				Player.SlideDirection.z = -forward.z
			elseif(keyboardState:IsKeyDown(DIK_W)) then
				grabbed = true
				Player.SlideDirection.x = forward.x
				Player.SlideDirection.z = forward.z
			elseif(keyboardState:IsKeyDown(DIK_A)) then
				grabbed = true
				Player.SlideDirection.x = -right.x
				Player.SlideDirection.z = -right.z
			elseif(keyboardState:IsKeyDown(DIK_D)) then
				grabbed = true
				Player.SlideDirection.x = right.x
				Player.SlideDirection.z = right.z
			end
			
			--Save it
			if(grabbed) then
				Player.Sliding = true				
				Player.SlideDirection = Util.Normalize(Player.SlideDirection)
			end
		end
		
		local controller = tolua.cast(Player.Client.Root:GetComponent("Singularity.Physics.CharacterController"), "Singularity::Physics::CharacterController")

		if(Player.Sliding) then
			action = PLAYER_ACTION_SLIDING
			controller:Move(Player.SlideDirection, (elapsedtime * Player.Client.WalkRate * PLAYER_FRICTIONLESS_SPEEDUP))
		else
			local direction = Vector3:new(0,0,0)
			local speed = 0
			
			--Process keys to see how we're moving
			if(keyboardState:IsKeyDown(DIK_S)) then
				action = PLAYER_ACTION_BACKWARD
				direction = Util.Vector3Add(direction, Util.Vector3Negate(forward))
				speed = elapsedtime * Player.Client.WalkRate
			elseif(keyboardState:IsKeyDown(DIK_W)) then
				action = PLAYER_ACTION_FORWARD
				direction = Util.Vector3Add(direction, forward)
				speed = elapsedtime * Player.Client.WalkRate					
			end	

			if(keyboardState:IsKeyDown(DIK_A)) then
				action = PLAYER_ACTION_LEFT
				direction = Util.Vector3Add(direction, Util.Vector3Negate(right))
				speed = elapsedtime * Player.Client.WalkRate
			elseif(keyboardState:IsKeyDown(DIK_D)) then
				action = PLAYER_ACTION_RIGHT
				direction = Util.Vector3Add(direction, right)
				speed = elapsedtime * Player.Client.WalkRate
			end

			--Jump overrides the move actions
			if(keyboardState:IsKeyDown(DIK_SPACE) and not Player.Client.JumpKeyDown) then
				--flip the jump force if we're inverted
				controller:Jump(Player.Camera.Inverted and -PLAYER_JUMP or PLAYER_JUMP)
				action = PLAYER_ACTION_JUMP
				Player.Client.JumpKeyDown = true
				Player.Client.OnGround = false
			elseif(not keyboardState:IsKeyDown(DIK_SPACE)) then
				Player.Client.JumpKeyDown = false
				Player.Client.OnGround = true
			end

			--move
			controller:Move(direction, speed)

			--Play walking sound
			if (speed ~= 0) then
				if(emitter:Get_IsPlaying(0) == false) then
					emitter:Play(0)
				end
			end
				
			fcp = Player.Camera.Component:Get_FarClippingPlane()
			if(keyboardState:IsKeyDown(DIK_Z)) then
				Player.Camera.Component:Set_FarClippingPlane(fcp + 10 * elapsedtime)
			elseif(keyboardState:IsKeyDown(DIK_X)) then
				Player.Camera.Component:Set_FarClippingPlane(math.max(10, fcp - 10 * elapsedtime))
			end					
		
		end
		
		--Handle the animation action
		Player.Animation.HandleAction(action)
		
		--Reset inputs
		Player.Camera.PreviousMouseState = mouseState
		Singularity.Inputs.Input:ResetMousePosition()

		--Set final positions
		local cameraFinal = Player.Client.Root:Get_Transform():Get_Position()
		cameraFinal.y = cameraFinal.y + Player.Camera.Height
		
		bodyTransform:Set_Position(cameraFinal)
		transform:Set_Position(cameraFinal)
			
			
		-- Check and see if the player is dead from falling too far. (Should probably be a distance from drop...)
		--local pos = Player.Client.CameraNode:Get_Transform():Get_Position()
		if(cameraFinal.y < -1000 and not Player.Client.IsDeadFromFalling) then --hacky, but works for now; this will have to be tweaked
			Player.Client:TakeDamage(999, Player.Client)
			Player.Client.IsDeadFromFalling = true
		end
			
	end
end
--End

Player.Camera.Invert = function()
	Player.Camera.Inverted = not Player.Camera.Inverted
	Player.Camera.Rotation.x = math.mod(Player.Camera.Rotation.x + math.pi, math.pi*2)
	Player.Camera.Rotation.y = math.mod(Player.Camera.Rotation.y + math.pi, math.pi*2)
end

--Player System Functions
Player.Enable = function()
	Player.Enabled = true
	Network.Register(Player.Network.SlowInfoType, Player.Network.SlowInfoMsg)
	Network.Register(Player.Network.FastInfoType, Player.Network.FastInfoMsg)
	Network.Register(Player.Network.WeaponInfoType, Player.Network.WeaponInfoMsg)
	Network.Register(Player.Network.ModifierInfoType, Player.Network.ModifierInfoMsg)
	Network.Register(Player.Network.PlayerDeadType, Player.Network.PlayerDeadMsg)
	
	Weapon.Enable()
	Projectile.Enable()
	Modifier.Enable()
end

Player.Disable = function()
	Player.Enabled = false
	Network.Unregister(Player.Network.SlowInfoType, Player.Network.SlowInfoMsg)
	Network.Unregister(Player.Network.FastInfoType, Player.Network.FastInfoMsg)
	Network.Unregister(Player.Network.WeaponInfoType, Player.Network.WeaponInfoMsg)
	Network.Unregister(Player.Network.ModifierInfoType, Player.Network.ModifierInfoMsg)
	Network.Unregister(Player.Network.PlayerDeadType, Player.Network.PlayerDeadMsg)
	
	Weapon.Disable()
	Projectile.Disable()
	Modifier.Disable()
end

Player.Initialize = function()       
	Util.Debug("Initializing Player.")

	binder = Singularity.Scripting.LuaBinder:new("Player.Update")
	binder:Set_FunctionName("Player.Update")	
	
	Util.Debug("Initializing Player Complete.")
end

Player.Update = function(sender, elapsed)
	
	if(Player.Enabled) then
	
		if(Player.Client) then
			--Call subsystem updates
			Player.Camera.Update(sender, elapsed)
			Player.Network:Update(elapsed)
			Player.HandleWeaponChange(elapsed)
			Player.WeaponStates.Update(elapsed)
			Player.Animation.Update(elapsed)
			Weapon.Update(elapsed)
			Projectile.Update(elapsed)
			Modifier.Update(elapsed)
			Achievement.Update(elapsed)
			
			--if we're idle, print the position
			if(Player.Client.State == PLAYER_STATE_IDLE) then
				local position = Player.Client.CameraNode:Get_Transform():Get_Position()
				Util.Debug("Player Position: "..position.x..", "..position.y..", "..position.z)
			end
			
			local position = Player.Client.CameraNode:Get_Transform():Get_Position()
			--Regen HP if we've been out of combat long enough
			if(Player.RegenElapsed > PLAYER_HP_TICK_WINDOW) then
				Player.RegenElapsed = 0
				Player.Client.HP = math.min(Player.Client.HP + PLAYER_REGEN_AMOUNT, 100)
			end			
			
			--Regen Ammo
			Player.WeaponRegenPrevious = Player.WeaponRegen
			Player.WeaponRegen = Player.WeaponRegen + elapsed
			for k,v in pairs(Player.Client.Weapons) do
				local typeOf = v.Type
				local period = Weapon.StaticData[typeOf].RegenPeriod
				if(period) then
					--if we've completed a period, add a unit of ammo
					local prev = Player.WeaponRegenPrevious/period
					local cur = Player.WeaponRegen/period
					if(math.modf(prev) ~= math.modf(cur)) then
						v:AddAmmo(1)
					end
				end
			end
		end
	
	end
end
--End

--Network Update
Player.Network =
{
	SlowElapsed = 0,
	FastElapsed = 0,
	WeaponElapsed = 0,
	ModifierElapsed = 0,
	--Message Timers
	SlowTime = 1,
	FastTime = 0.03,
	WeaponTime = 1,
	ModifierTime = 0.5,
	--Message Types
	FastInfoType = "P1",
	SlowInfoType = "P2",
	WeaponInfoType = "P3",
	ModifierInfoType = "P4",
	PlayerDeadType = "P5",
	Update = function(self, elapsed)
		--Send off messages at their specific rates
		self.SlowElapsed = self.SlowElapsed + elapsed
		if(self.SlowElapsed > self.SlowTime) then
			self.SlowElapsed = 0
			Network.Send(self.SlowInfoType, self.BuildSlowInfoTable())
		end
		
		self.FastElapsed = self.FastElapsed + elapsed
		if(self.FastElapsed > self.FastTime) then
			self.FastElapsed = 0
			Network.Send(self.FastInfoType, self.BuildFastInfoTable())
		end
		
		self.WeaponElapsed = self.WeaponElapsed + elapsed
		if(self.WeaponElapsed > self.WeaponTime) then
			self.WeaponElapsed = 0
			Network.Send(self.WeaponInfoType, self.BuildWeaponInfoTable())
		end
		
		self.ModifierElapsed = self.ModifierElapsed + elapsed
		if(self.ModifierElapsed > self.ModifierTime) then
			self.ModifierElapsed = 0
			Network.Send(self.ModifierInfoType, self.BuildModifierInfoTable())
		end
	end,
	BuildSlowInfoTable = function()
		--Everything but state and weapons
		local ret = Util.ShallowTableCopy(Player.Client)
		ret.State = nil
		ret.Weapons = nil
		Util.JoinTables(ret, Player.Network.BuildFastInfoTable())
		return ret
	end,	
	BuildFastInfoTable = function()
		--ID, client Pos, client Rot, State, Current Weapon Index
		local ret = { ID = Player.Client.ID }
		local clientPos = Player.Client.FootNode:Get_Transform():Get_Position()
		local clientRot = Player.Client.BodyNode:Get_Transform():Get_Rotation()
		clientRot = Singularity.Components.Transform:RotationToEuler(clientRot)
		clientRot.x = 0
		clientRot.z = 0
		clientRot = Singularity.Components.Transform:EulerToRotation(clientRot)
		ret.Position = {x = clientPos.x, y = clientPos.y, z = clientPos.z}
		ret.Orientation = {x = clientRot.x, y = clientRot.y, z = clientRot.z, w = clientRot.w}
		ret.State = Player.Client.State
		ret.CurrentWeaponIndex = Player.Client.CurrentWeaponIndex
		return ret
	end,
	BuildWeaponInfoTable = function()
		local ret = { ID = Player.Client.ID }
		ret.Weapons = Util.ShallowTableCopy(Player.Client.Weapons)
		return ret
	end,
	BuildModifierInfoTable = function()
		local ret = { ID = Player.Client.ID }
		ret.Modifiers = {}
		for i = 1,#Player.Client.Modifiers do
			local entry = {}
			local modifier = Player.Client.Modifiers[i]	
			--Type, ID, Position, Orientation, Owner
			entry.Type = Player.Client.Modifiers[i].Type
			entry.ID = Player.Client.Modifiers[i].ID
			entry.Position = {x = modifier.Position.x, y = modifier.Position.y, z = modifier.Position.z}
			entry.Orientation = {x = modifier.Orientation.x, y = modifier.Orientation.y, z = modifier.Orientation.z, w = modifier.Orientation.w}
			entry.OwnerID = Player.Client.ID
			ret.Modifiers[i] = entry
		end
		
		return ret
	end,
	--Message Handles
	SlowInfoMsg = function(value)
		if(value.ID ~= Player.Client.ID) then
			local v = Main.GamePlay.Players[value.ID]			
			if(v) then
				--update stats
				v.Kills = value.Kills
				v.Deaths = value.Deaths
				v.State = value.State
				v.WalkRate = value.WalkRate	
			else
				--This is a new player in the game, build New Remote Player
				local player = Player.Create(value.ID, value.Name, value.Team, Vector3:new(value.Position.x, value.Position.y, value.Position.z), Quaternion:new(value.Orientation.x,value.Orientation.y,value.Orientation.z,value.Orientation.w))
			end
		end
	end,
	FastInfoMsg = function(value)
		if(value.ID ~= Player.Client.ID) then
			local v = Main.GamePlay.Players[value.ID]
			if(v) then
				--update position, weapon, and state
				v.BodyNode:Get_Transform():Set_Position(Vector3:new(value.Position.x,value.Position.y,value.Position.z))
				v.BodyNode:Get_Transform():Set_Rotation(Quaternion:new(value.Orientation.x,value.Orientation.y,value.Orientation.z,value.Orientation.w))
				if(v.CurrentWeaponIndex ~= value.CurrentWeaponIndex) then
					v:SelectWeapon(value.CurrentWeaponIndex)
				end
				if(v.State ~= value.State) then
					v:ChangeState(value.State)
				end
			end
		end
	end,
	WeaponInfoMsg = function(value)
		--update weapon loadout
		if(value.ID ~= Player.Client.ID) then
			local v = Main.GamePlay.Players[value.ID]
			v:SetWeapons(value.Weapons)
		end
	end,
	ModifierInfoMsg = function(value)
		--update active modifiers
		if(value.ID ~= Player.Client.ID) then
			local v = Main.GamePlay.Players[value.ID]
			v:SetModifiers(value.Modifiers)
		end
	end,
	PlayerDeadMsg = function(value)
		local attackerID = value.AttackerID
		
		--If I killed them
		if(attackerID == Player.Client.ID) then
			--Record a kill
			if (value.AttackerID ~= value.ID) then
				-- if it's a suicide, don't give a kill...
				Player.Client.Kills = Player.Client.Kills + 1
			end

			if(not Achievement.Goal) then
				return
			end
		
			--Achievement Handling
			if(Achievement.Goal.Type == Achievement.Goals.Kill.Type) then
				Achievement.Goal.Kills = 1
			elseif(Achievement.Goal.Type == Achievement.Goals.HighGround.Type) then
				if(Player.Client:HasBuffType(Modifier.ModifierBehavior.InvertGravity.Buff)) then
					local target = Main.GamePlay.Players[value.ID]
					if(not Modifier.FindActiveEffectByTypeAndTarget(Modifier.ModifierBehavior.InvertGravity.Type, target)) then
						Achievement.Goal.Kills = 1
					end
				end
			elseif(Achievement.Goal.Type == Achievement.Goals.Switch.Type) then
				if(Achievement.Goal.IllusionHit and value.ID == Achievement.Goal.Victim) then
					Achievement.Goal.Kills = 1
				end
			elseif(Achievement.Goal.Type == Achievement.Goals.Science.Type) then
				if(Player.Client:CountModifierBuffs() > 0) then
					Achievement.Goal.Kills = 1
				end
			elseif(Achievement.Goal.Type == Achievement.Goals.MadScience.Type) then
				if(Player.Client:CountModifierBuffs() > 1) then
					Achievement.Goal.Kills = 1
				end
			elseif(Achievement.Goal.Type == Achievement.Goals.Survival.Type) then
				if(Player.Client:HasBuffType(Modifier.ModifierBehavior.Grow.Buff)) then
					local target = Main.GamePlay.Players[value.ID]
					if(target) then
						if(Modifier.FindActiveEffectByTypeAndTarget(Modifier.ModifierBehavior.Shrink.Type, target)) then
							Achievement.Goal.Kills = 1
						end
					end
				end
			end
		end

		--strip effects off dead guy
		Modifier.RemoveEffectsByTarget(Main.GamePlay.Players[value.ID])
	end
}
--End

--Init
Player.WeaponStates.State = Player.WeaponStates.Active

Util.Debug("Player Loaded.")