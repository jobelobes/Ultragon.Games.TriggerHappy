Modifier = {
	Enabled = false,
	NextID = 1,
	NextEffectID = 1,
}

local MODIFIER_COOLDOWN = 1
local MODIFIER_FOOTPRINT = 3 --0.03
local MODIFIER_SCREEN_RADIUS_SQ_MIN = 0.5
local MODIFIER_SCREEN_RADIUS_SQ_MAX = 1
local MODIFIER_MAX_HP = 5
MODIFIER_AOE_RANGE = 200 --0.22
MODIFIER_SCREEN_MAX_DIST = 30
MODIFIER_KNOCKBACK_RADIUS = 10000

Modifier.ActiveEffects = {}
Modifier.ClientCooldowns = {}

--Dynamic Modifier Information for network
Modifier.DynamicData =
{
	Shrink = { Type = "Shrink" },
	Grow = { Type = "Grow" },
	InvertGravity = { Type = "InvertGravity" },
	Knockback = { Type = "Knockback" },
	Frictionless = { Type = "Frictionless" },
	Illusion = { Type = "Illusion" },
	IncreaseGravity = { Type = "IncreaseGravity" },
	Wall = { Type = "Wall" },	
}

--Static modifier information
Modifier.StaticData =
{
	Shrink =
	{
		NickName = "Shrink",
		ProximityCue = "modifier_ShrinkProximity",
		TriggerCue = "modifier_ShrinkTrigger",
		ShotCue = "modifier_Shot",
		DestroyCue = "modifier_Destroy",
		Cost = 10,
	},
	Grow =
	{
		NickName = "Grow",
		ProximityCue = "modifier_GrowProximity",
		TriggerCue = "modifier_GrowTrigger",
		ShotCue = "modifier_Shot",
		DestroyCue = "modifier_Destroy",
		Cost = 10,
	},
	InvertGravity =
	{
		NickName = "Invert Gravity",
		ProximityCue = "modifier_InverseProximity",
		TriggerCue = "modifier_InverseTrigger",
		ShotCue = "modifier_Shot",
		DestroyCue = "modifier_Destroy",
		Cost = 10,
	},
	Knockback =
	{
		NickName = "Knockback",
		ProximityCue = "modifier_KnockbackProximity",
		TriggerCue = "modifier_KnockbackTrigger",
		ShotCue = "modifier_Shot",
		DestroyCue = "modifier_Destroy",
		Cost = 10,
	},
	Frictionless =
	{
		NickName = "Frictionless",
		ProximityCue = "modifier_AcceleratorProximity",
		TriggerCue = "modifier_AcceleratorTrigger",
		ShotCue = "modifier_Shot",
		DestroyCue = "modifier_Destroy",
		Cost = 10,
	},
	Illusion =
	{
		NickName = "Illusion",
		ProximityCue = "modifier_IllusionProximity",
		TriggerCue = "modifier_IllusionTrigger",
		ShotCue = "modifier_Shot",
		DestroyCue = "modifier_Destroy",
		Cost = 10,
	},
	IncreaseGravity =
	{
		NickName = "Increase Gravity",
		ProximityCue = "modifier_IncreaseProximity",
		TriggerCue = "modifier_IncreaseTrigger",
		ShotCue = "modifier_Shot",
		DestroyCue = "modifier_Destroy",
		Cost = 10,
	},
	Wall = 
	{
		NickName = "Wall",
		ProximityCue = "modifier_BarrierProximity",
		TriggerCue = "modifier_BarrierTrigger",
		ShotCue = "modifier_Shot",
		DestroyCue = "modifier_Destroy",
		Cost = 10,
	}
}

--Init Meshes and Materials
Modifier.MarkerMesh, Modifier.MarkerMaterial = Util.GetMeshAndMaterial(Main.AssetDirectory.."Models\\ModifierMarker.smurf")
Modifier.StaticData.Shrink.DinosaurFootMesh, Modifier.StaticData.Shrink.DinosaurFootMaterial = Util.GetMeshAndMaterial(Main.AssetDirectory.."Models\\DinosaurFoot.smurf")
Modifier.StaticData.Shrink.PortalMesh, Modifier.StaticData.Shrink.PortalMaterial = Util.GetMeshAndMaterial(Main.AssetDirectory.."Models\\Portal.smurf")
Modifier.StaticData.Grow.RadiationMesh, Modifier.StaticData.Grow.RadiationMaterial = Util.GetMeshAndMaterial(Main.AssetDirectory.."Models\\Radiation.smurf")
Modifier.StaticData.Frictionless.IceBlockMesh, Modifier.StaticData.Frictionless.IceBlockMaterial = Util.GetMeshAndMaterial(Main.AssetDirectory.."Models\\IceBlock.smurf")
Modifier.StaticData.Wall.WallMesh, Modifier.StaticData.Wall.WallMaterial = Util.GetMeshAndMaterial(Main.AssetDirectory.."Models\\Wall.smurf")
Modifier.StaticData.Illusion.IllusionMesh, Modifier.StaticData.Illusion.IllusionMaterial = Util.GetMeshAndMaterial(Main.AssetDirectory.."Models\\Character.smurf")

Modifier.ClientFunctions =
{
	TakeDamage = function(self, dmg)
		self.HP = self.HP - dmg
		if(self.HP <= 0) then
			Modifier.Destroy(self)
			Util.Debug("Modifier Killed")
		end
	end
}

-- Remote client's version of the modifier.
Modifier.Create = function(typeOf, position, orientation, ID, OwnerID)
	local ret = Modifier.InitGeneral(typeOf, position, orientation, ID, OwnerID)

	return ret
end


-- Local client's version of the modifier.
Modifier.CreateClient = function(typeOf, position, orientation)

	local ID = Modifier.NextID
	Modifier.NextID = Modifier.NextID + 1
	local OwnerID = Player.Client.ID

	local ret = Modifier.InitGeneral(typeOf, position, orientation, ID, OwnerID)	
	ret = Util.JoinTables(ret, Util.ShallowTableCopy(Modifier.ClientFunctions))
	
	ret.HP = MODIFIER_MAX_HP
	
	--Pay for it
	Player.Client.Energy = Player.Client.Energy - Modifier.StaticData[typeOf].Cost
	
	Modifier.ClientCooldowns[ret] = Modifier.MakeCooldownBehavior(5)
	
	return ret
end

-- General modifier initialization. Shared between local and remote modifiers.
Modifier.InitGeneral = function(typeOf, position, orientation, ID, OwnerID)
	
	--make the modifier object
	local newMod = Util.ShallowTableCopy(Modifier.DynamicData[typeOf])
	newMod.Position = position
	newMod.Orientation = orientation
	newMod.ID = ID
	newMod.OwnerID = OwnerID
		
	--make the game object that we'll hang everything on
	local obj = Singularity.Components.GameObject:Create(typeOf.."Modifier", nil, nil)
	obj:Get_Transform():Set_Position(position)
	obj:Get_Transform():Set_Rotation(orientation)
	
	--Setup the marker mesh to do a grow tween
	obj:Get_Transform():Set_Scale(Vector3:new(0,0,0))
	Tween.GrantScaleFunctionality(obj)
	local set = Tween.TweenSet.MakeTweenSet()
	set:Bind(Tween.Tween.CopyTween(Modifier.Tween.MarkerTween), 0, "GetScale", "SetScale")
	set:SetTarget(obj)
	Tween.Tweener.Play(set)
	
	--Give it a mesh
	local comp = Singularity.Graphics.MeshRenderer:new(Modifier.MarkerMesh:Clone(), Modifier.MarkerMaterial:Clone())
	obj:AddComponent(comp)
	
	newMod.ModifierModel = obj
	
	--Give it a collider
	local size = Vector3:new(MODIFIER_FOOTPRINT, MODIFIER_FOOTPRINT, MODIFIER_FOOTPRINT)
	comp = Singularity.Physics.BoxCollider(OwnerID.."."..ID.."-ModifierCollider", position, size)
	obj:AddComponent(comp)
	
	--load sound cues
	if (Modifier.StaticData[typeOf].TriggerCue) then		
		comp = Audio.Manager:GetNewEmitter(typeOf)
		comp:AddCue(Audio.Manager:CreateCue(Modifier.StaticData[typeOf].TriggerCue))
		comp:AddCue(Audio.Manager:CreateCue(Modifier.StaticData[typeOf].ProximityCue))
		comp:AddCue(Audio.Manager:CreateCue(Modifier.StaticData[typeOf].ShotCue))
		comp:AddCue(Audio.Manager:CreateCue(Modifier.StaticData[typeOf].DestroyCue))
		obj:AddComponent(comp)
	end
		
	return newMod
end

Modifier.Destroy = function(modifier)
	--play destruction sound
	local comp = tolua.cast (modifier.ModifierModel:GetComponent("Singularity.Audio.AudioEmitter"), "Singularity::Audio::AudioEmitter")
	comp:Play(3)
	
	Modifier.ClientCooldowns[modifier] = nil
	
	--Play Particle Effect
	
	--Kill it
	modifier.ModifierModel:Destroy()
	
	if(modifier.OwnerID == Player.Client.ID) then
		--Restore Energy
		Player.Client.Energy = Player.Client.Energy + Modifier.StaticData[modifier.Type].Cost
	end
end

--Modifier Tween Information
Modifier.Tween =
{	
	--Modifier
	MarkerTween = Tween.Tween.MakeLinearTween(1, 0, 1),
	
	--Shrink
	DinosaurFootUpTween = Tween.Tween.MakeLinearTween(0.3,0,-1),
	DinosaurFootDownTween = Tween.Tween.MakeLinearTween(0.3,0,1),
	DinosaurPortalOpenTween = Tween.Tween.MakeLinearTween(0.2,0,math.pi*1.5),
	DinosaurPortalCloseTween = Tween.Tween.MakeLinearTween(0.2,0,-math.pi*1.5),
	ShrinkTween = Tween.Tween.MakeLinearTween(0.5, 0, -0.5),	
	LowerCameraTween =  Tween.Tween.MakeLinearTween(0.5, 0, -0.03),
	
	--Grow
	RadiationGrow = Tween.Tween.MakeLinearTween(0.5,0,1),
	GrowTween = Tween.Tween.MakeLinearTween(1,0,0.5),
	RaiseCameraTween = Tween.Tween.MakeLinearTween(0.5, 0, 0.03),
	
	--Wall
	WallRise = Tween.Tween.MakeLinearTween(0.8,0,1),
	WallDecline = Tween.Tween.MakeLinearTween(2,0,-1),
	WallRumble = Tween.Tween.MakeSinTween(2,0.05,0.075),
	WallBoxRise = Tween.Tween.MakeLinearTween(0.8,0,0.8),
	WallBoxDecline = Tween.Tween.MakeLinearTween(2,0,-0.8),
	
	--Invert Gravity
	PlayerFlip = Tween.Tween.MakeLinearTween(1,0, math.pi),
	
	--Tween Modifier Functions	
	GetYScale = function(self)
		return self:Get_Transform():Get_Scale().y
	end,
	SetYScale = function(self, newScale)
		local oldScale = self:Get_Transform():Get_Scale()
		oldScale.y = newScale
		self:Get_Transform():Set_Scale(oldScale)
	end,
	GetYRot = function(self)
		return Singularity.Components.Transform:RotationToEuler(self:Get_Transform():Get_LocalRotation()).y
	end,
	SetYRot = function(self, newRot)
		local oldRot = Singularity.Components.Transform:RotationToEuler(self:Get_Transform():Get_LocalRotation())
		oldRot.y = newRot
		self:Get_Transform():Set_LocalRotation(Singularity.Components.Transform:EulerToRotation(oldRot))
	end,
	GetXPos  = function(self)
		return self:Get_Transform():Get_Position().x
	end,
	SetXPos = function(self, newX)
		local oldPos = self:Get_Transform():Get_Position()
		oldPos.x = newX
		self:Get_Transform():Set_Position(oldPos)
	end,
	GetYPos  = function(self)
		return self:Get_Transform():Get_Position().y
	end,
	SetYPos = function(self, newY)
		local oldPos = self:Get_Transform():Get_Position()
		oldPos.y = newY
		self:Get_Transform():Set_Position(oldPos)
	end,
	GetXRot = function(self)
		return Singularity.Components.Transform:RotationToEuler(self:Get_Transform():Get_LocalRotation()).x
	end,
	SetXRot = function(self, newRot)
		local oldRot = Singularity.Components.Transform:RotationToEuler(self:Get_Transform():Get_LocalRotation())
		oldRot.x = newRot
		self:Get_Transform():Set_LocalRotation(Singularity.Components.Transform:EulerToRotation(oldRot))
	end,
	GetZRot = function(self)
		return Singularity.Components.Transform:RotationToEuler(self:Get_Transform():Get_LocalRotation()).z
	end,
	SetZRot = function(self, newRot)
		local oldRot = Singularity.Components.Transform:RotationToEuler(self:Get_Transform():Get_LocalRotation())
		oldRot.z = newRot
		self:Get_Transform():Set_LocalRotation(Singularity.Components.Transform:EulerToRotation(oldRot))
	end,
	GetYSize = function(self)
		return self:Get_Size().y
	end,
	SetYSize = function(self, newY)
		local size = self:Get_Size()
		Util.Debug(newY)
		size.y = newY
		self:Set_Size(size)
	end
}

--returns a table that can monitor a modifier cooldown
Modifier.MakeCooldownBehavior = function(cooldown)
	local ret =
	{
		Ready = true,
		Cooldown = cooldown,
     	CooldownElapsed = 0,
		Process = function(self, elapsed)
			if(not self.Ready) then
				self.CooldownElapsed = self.CooldownElapsed + elapsed
				
				if(self.CooldownElapsed > self.Cooldown) then
					self.Ready = true
					self.CooldownElapsed = 0
				end
			end
		end
	}
	return ret
end

--Modifier Trigger Behaviors - Handle what happens when a client triggers their modifier
Modifier.TriggerBehavior =
{
	-- for any modifier that affects an area
	AoEPoll = function(center, radius)
		Util.Debug(center.x, center.y, center.z)
		local colliders, count = Singularity.Physics.Collider.SphereCast(center, radius)
		if(count == 0) then
			return
		else
			local targets = {}
			Util.Debug("targets")
			Util.Debug(count)
			for _,v in pairs(colliders) do
				if(v ~= nil) then
					print(v:Get_Name())
				end
				if(Util.VerifyLabel(v:Get_Name(), "Collider")) then
					local ID = Util.ExtractID(v:Get_Name())
					Util.Debug(ID)
					table.insert(targets, Main.GamePlay.Players[ID])
				end
			end
			
			--Util.DumpTable(targets)
			return targets
		end
	end,
	Shrink = function(modifier)	
		--poll targets
		local targets = Modifier.TriggerBehavior.AoEPoll(modifier.ModifierModel:Get_Transform():Get_Position(), MODIFIER_AOE_RANGE)
		if(not targets) then
			return
		end
	
		--if (modifier.OwnerID == Player.Client.ID) then
			--Modifier.SendModifierTriggerMessage(Modifier.ModifierBehavior.Shrink.Type, modifier)
		--end
	
		for _,v in ipairs(targets) do	
			Util.Debug("IDs for Shrink:")
			Util.Debug(v.ID)
			Util.Debug(Player.Client.ID)
			if(v.ID == Player.Client.ID) then
				if(not v:HasBuffType(Modifier.ModifierBehavior.Shrink.Buff)) then
					Modifier.HandleModifierHitMe(Modifier.ModifierBehavior.Shrink.Type, modifier)
				end
			else
				Modifier.HandleModifierHitOther(Modifier.ModifierBehavior.Shrink.Type, modifier, v)
			end
		end
	end,
	Grow = function(modifier)	
		--poll targets
		local targets = Modifier.TriggerBehavior.AoEPoll(modifier.ModifierModel:Get_Transform():Get_Position(), MODIFIER_AOE_RANGE)
		if(not targets) then
			return
		end
	
		for _,v in ipairs(targets) do
			if(v == Player.Client) then
				if(not v:HasBuffType(Modifier.ModifierBehavior.Grow.Buff)) then
					Modifier.HandleModifierHitMe(Modifier.ModifierBehavior.Grow.Type, modifier)
				end
			else
				Modifier.HandleModifierHitOther(Modifier.ModifierBehavior.Grow.Type, modifier, v)
			end
		end
	end,
	InvertGravity = function(modifier)	
		--poll targets
		local targets = Modifier.TriggerBehavior.AoEPoll(modifier.ModifierModel:Get_Transform():Get_Position(), MODIFIER_AOE_RANGE)
		if(not targets) then
			return
		end
	
		for _,v in ipairs(targets) do			
			if(v == Player.Client) then
				Modifier.HandleModifierHitMe(Modifier.ModifierBehavior.InvertGravity.Type, modifier)
			else
				Modifier.HandleModifierHitOther(Modifier.ModifierBehavior.InvertGravity.Type, modifier, v)
			end			
		end	
	end,
	Wall = function(modifier)
		Modifier.HandleModifierHitMe(Modifier.ModifierBehavior.Wall.Type, modifier)
	end,
	Knockback = function(modifier, position)
		--poll targets
		local targets = Modifier.TriggerBehavior.AoEPoll(modifier.ModifierModel:Get_Transform():Get_Position(), MODIFIER_AOE_RANGE)
		if(not targets) then
			return
		end
	
		for _,v in ipairs(targets) do			
			if(v == Player.Client) then
				Modifier.HandleModifierHitMe(Modifier.ModifierBehavior.Knockback.Type, modifier)
			else
				Modifier.HandleModifierHitOther(Modifier.ModifierBehavior.Knockback.Type, modifier, v)
			end			
		end	
	end,
	Frictionless = function(modifier)
		--poll targets
		local targets = Modifier.TriggerBehavior.AoEPoll(modifier.ModifierModel:Get_Transform():Get_Position(), MODIFIER_AOE_RANGE)
		if(not targets) then
			return
		end
	
		for _,v in ipairs(targets) do				
			if(v == Player.Client) then
				if(not v:HasBuffType(Modifier.ModifierBehavior.Frictionless.Buff) and v:CanAddBuff()) then
					Modifier.HandleModifierHitMe(Modifier.ModifierBehavior.Frictionless.Type, modifier)
				end
			else
				Modifier.HandleModifierHitOther(Modifier.ModifierBehavior.Frictionless.Type, modifier, v)
			end						
		end	
	end,
	Illusion = function(modifier, position)
		Modifier.HandleModifierHitMe(Modifier.ModifierBehavior.Illusion.Type, modifier, v)
	end,
	IncreaseGravity = function(modifier)
		--poll targets
		local targets = Modifier.TriggerBehavior.AoEPoll(modifier.ModifierModel:Get_Transform():Get_Position(), MODIFIER_AOE_RANGE)
		if(not targets) then
			return
		end
	
		for _,v in ipairs(targets) do			
			if(v == Player.Client) then
				if(not v:HasBuffType(Modifier.ModifierBehavior.IncreaseGravity.Buff) and v:CanAddBuff()) then
					Modifier.HandleModifierHitMe(Modifier.ModifierBehavior.IncreaseGravity.Type, modifier)
				end
			else
				Modifier.HandleModifierHitOther(Modifier.ModifierBehavior.IncreaseGravity.Type, modifier, v)
			end					
		end	
	end,
}

-- if a modifier hit me
Modifier.HandleModifierHitMe = function(typeOf, modifier)
	--Util.Debug("HIT ME")
	--Util.DumpTable(modifier)
	Modifier.ModifierBehavior.SpawnEffect(typeOf, modifier, Player.Client)
end

local testID = 1
-- if a modifier hit somebody else
Modifier.HandleModifierHitOther = function(typeOf, modifier, target)
	--Util.Debug("HIT OTHER")
	--Util.DumpTable(modifier)
	Modifier.ModifierBehavior.SpawnEffect(typeOf, modifier, target, target.ID.."-"..testID)
	testID = testID + 1

end

-- send out a message that I was hit by a modifier
Modifier.AlertHitMe = function(effect)
	--Send
	if (effect.Spawner.TargetID == Player.Client.ID) then
		local msg =
		{
			Type = effect.Type,
			ModifierID = effect.Spawner.ID,
			OwnerID = effect.Spawner.OwnerID,
			TargetID = Player.Client.ID,
			EffectID = effect.ID
		}
		Network.SendReliable(Modifier.Network.ModifierHitType, msg)
	end
end

-- send out a message that somebody else was hit by a modifier
Modifier.AlertHitOther = function(effect)
	--Send
	if (effect.Spawner.OwnerID == Player.Client.ID) then
		local msg =
		{
			Type = effect.Type,
			ModifierID = effect.Spawner.ID,
			OwnerID = Player.Client.ID,
			TargetID = effect.Target.ID,
			EffectID = effect.ID
		}
		Network.SendReliable(Modifier.Network.ModifierHitType, msg)
	end
end

-- send out a messages that I have removed the modifier I own
Modifier.AlertRemovedFromMe = function(effect)
	-- with unique ID
	local msg =
	{
		EffectID = effect.ID,
		TargetID = effect.Target.ID,
	}
	Network.SendReliable(Modifier.Network.ModifierRemoveType, msg)
end

Modifier.ModifierBehavior =
{
	-- Creates the effect.
	SpawnEffect = function(typeOf, modifier, target, id)
		local effect = Util.ShallowTableCopy(Modifier.ModifierBehavior[typeOf])
		effect.Spawner = modifier
		effect.Target = target
		if(id) then
			effect.ID = id
		else
			effect.ID = Player.Client.ID.."."..Modifier.NextEffectID
			Modifier.NextEffectID = Modifier.NextEffectID + 1
		end

		--Util.DumpTable(effect.Spawner)
		Util.Debug("SPAWNING EFFECT")
		effect:Activate()
	end,
	-- ends the effect
	KillEffect = function(effect)
		Util.DumpTable(effect)
		if(effect.Target == Player.Client) then
			Modifier.AlertRemovedFromMe(effect)
			if(effect.Buff) then
				Player.Client:RemoveBuff(effect.Buff)
			end
		end
		effect:Deactivate()
	end,
	Shrink =
	{
		--Effect Status
		Duration = 10,
		VisualDuration = 0.8,
		VisualRemoved = false,
		DurationElapsed = 0,
		Type = "Shrink",
		State = "Active",
		Buff = Buff.CreateBuff("Shrink", "Reduces Player Size.", nil),
		
		Activate = function(self)
			
			if(self.Target.ID == Player.Client.ID) then	
				Util.Debug("self")
				-- Hit the local player.		
				if(Player.Client:HasBuffType(Modifier.ModifierBehavior.Grow.Buff)) then					
					Modifier.ModifierBehavior.KillEffect(Modifier.FindClientEffectByType(Modifier.ModifierBehavior.Grow.Type))
				elseif(Player.Client:CanAddBuff()) then
					self:ApplyShrink()
					Modifier.AlertHitMe(self)
				end
			else
				-- Hit somebody else.
				self:ApplyShrink()
				Modifier.AlertHitOther(self)
			end
			
		end,
		
		ApplyShrink = function(self)
			
			local shrinkInfo = Modifier.StaticData.Shrink
			
			--Init Vars
			self.DurationElapsed = 0
			self.VisualRemoved = false
			self.State = "Active"
			
			--local root = self.Target.Root
			local root = self.Target.BodyNode
			self.Foot = Singularity.Components.GameObject:Create("DinosaurFoot", nil, nil)
			local pos = root:Get_Transform():Get_Position()
			local set = Tween.TweenSet.MakeTweenSet()
			
			--Check Orientation
			if(Modifier.FindActiveEffectByTypeAndTarget(Modifier.ModifierBehavior.InvertGravity.Type, self.Target) ~= nil) then
				pos.y = pos.y - 0.13
				set:Bind(Tween.Tween.CopyTween(Modifier.Tween.DinosaurFootUpTween), 0, "GetYScale", "SetYScale")
				set:Bind(Tween.Tween.CopyTween(Modifier.Tween.DinosaurFootDownTween), 0.4, "GetYScale", "SetYScale")
			else
				pos.y = pos.y + 0.13
				set:Bind(Tween.Tween.CopyTween(Modifier.Tween.DinosaurFootDownTween), 0, "GetYScale", "SetYScale")
				set:Bind(Tween.Tween.CopyTween(Modifier.Tween.DinosaurFootUpTween), 0.4, "GetYScale", "SetYScale")
			end
			
			--trigger dinosaur foot			
			self.Foot:Get_Transform():Set_Position(pos)
			self.Foot:Get_Transform():Set_Scale(Vector3:new(1,0,1))
			self.Foot.GetYScale = Modifier.Tween.GetYScale
			self.Foot.SetYScale = Modifier.Tween.SetYScale			
			set:SetTarget(self.Foot)
			Tween.Tweener.Play(set)
			local renderComp = Singularity.Graphics.MeshRenderer:new(shrinkInfo.DinosaurFootMesh:Clone(), shrinkInfo.DinosaurFootMaterial:Clone())
			self.Foot:AddComponent(renderComp)
			
			--trigger portal
			self.Portal =  Singularity.Components.GameObject:Create("Portal", nil, nil)
			self.Portal:Get_Transform():Set_Position(pos)
			self.Portal.GetYRot = Modifier.Tween.GetYRot
			self.Portal.SetYRot = Modifier.Tween.SetYRot
			set = Tween.TweenSet.MakeTweenSet()
			set:Bind(Tween.Tween.CopyTween(Modifier.Tween.DinosaurPortalOpenTween), 0, "GetYRot", "SetYRot")
			set:Bind(Tween.Tween.CopyTween(Modifier.Tween.DinosaurPortalCloseTween), 0.4, "GetYRot", "SetYRot")
			set:SetTarget(self.Portal)
			Tween.Tweener.Play(set)
			renderComp = Singularity.Graphics.MeshRenderer:new(shrinkInfo.PortalMesh:Clone(), shrinkInfo.PortalMaterial:Clone())
			self.Portal:AddComponent(renderComp)
			
			--trigger shrink tween or camera move
			if(self.Target == Player.Client) then
				set = Tween.TweenSet.MakeTweenSet()
				local tween
				
				--lower the camera when facing normally, otw, "raise" it
				if(Player.Client:HasBuffType(Modifier.ModifierBehavior.InvertGravity.Buff)) then
					tween = Tween.Tween.CopyTween(Modifier.Tween.RaiseCameraTween)
				else
					tween = Tween.Tween.CopyTween(Modifier.Tween.LowerCameraTween)
				end
				set:Bind(Tween.Tween.CopyTween(tween), 0, "Height")
				set:SetTarget(Player.Camera)
				Tween.Tweener.Play(set)
				
				--shrink the collision volume
				Util.Debug("SHRINKING! "..PLAYER_HEIGHT)
				Util.Debug("BEFOREHEIGHT: "..Player.Client.CharacterController:Get_Height())
				Player.Client.CharacterController:Set_Height(PLAYER_HEIGHT * 0.5)
				
				-- MAKE THIS INTO A TWEEN. AND THEN UNTWEEN IT LATER.
				
				Player.Client.CharacterController:Set_Scale(Vector3:new(0.5, 0.5, 0.5))
				Player.Client.CharacterController:Jump(1) -- triggers gravity
				Util.Debug("AFTERHEIGHT: "..Player.Client.CharacterController:Get_Height())
				Player.Client.CharacterController:Set_Radius(PLAYER_RADIUS * 0.5)
				
				--apply shrink buffs
				Player.Client:AddBuff(Modifier.ModifierBehavior.Shrink.Buff)
			else
				Tween.GrantScaleFunctionality(self.Target.BodyNode)
				set = Tween.TweenSet.MakeTweenSet()
				set:Bind(Tween.Tween.CopyTween(Modifier.Tween.ShrinkTween), 0, "GetScale", "SetScale")
				set:SetTarget(self.Target.BodyNode)
				Util.Debug("SETTING SHRINK ON: "..self.Target.ID)
				Tween.Tweener.Play(set)
				
				--shrink the collision volume
				self.Target.CapsuleCollider:Set_Height(PLAYER_HEIGHT * 0.5)
				self.Target.CapsuleCollider:Set_Radius(PLAYER_RADIUS * 0.5)
			end						
			
			--append to active list
			Modifier.AddActiveEffect(self)
			
			--play audio
			local comp = tolua.cast (self.Spawner.ModifierModel:GetComponent("Singularity.Audio.AudioEmitter"), "Singularity::Audio::AudioEmitter")
			comp:Play(0)
			
		end,
		
		Process = function(self,elapsed)
			self.DurationElapsed = self.DurationElapsed + elapsed

			if(self.State == "Active") then
				if(self.DurationElapsed > self.VisualDuration and not self.VisualRemoved) then
					self.VisualRemoved = true
					self.Portal:Set_IsActive(false)
					self.Foot:Set_IsActive(false)
				end
				if(self.DurationElapsed > self.Duration) then
					self.State = "Deactivating"
				end
			--Deactivate
			else			
				self:Deactivate()
			end			
		end,
		
		Deactivate = function(self)
			if(not self.VisualRemoved) then
				self.VisualRemoved = true
				self.Portal:Set_IsActive(false)
				self.Foot:Set_IsActive(false)
			end
			
			--Remove buff from target
			if(self.Target == Player.Client) then
				
				--raise the camera when facing normally, otw, "lower" it
				local tween
				set = Tween.TweenSet.MakeTweenSet()
				if(Player.Client:HasBuffType(Modifier.ModifierBehavior.InvertGravity.Buff)) then
					tween = Modifier.Tween.LowerCameraTween
				else
					tween = Modifier.Tween.RaiseCameraTween
				end
				set:Bind(Tween.Tween.CopyTween(tween), 0, "Height")
				set:SetTarget(Player.Camera)
				Tween.Tweener.Play(set)
				
				--restore the collision volume
				Player.Client.CharacterController:Set_Height(PLAYER_HEIGHT)
				Player.Client.CharacterController:Set_Radius(PLAYER_RADIUS)
				
				Player.Client.CharacterController:Set_Scale(Vector3:new(1, 1, 1))
				
				--remove the buff
				Player.Client:RemoveBuff(Modifier.ModifierBehavior.Shrink.Buff)
			else
				--trigger grow tween
				local model = self.Target.BodyNode
				local set = Tween.TweenSet.MakeTweenSet()
				set:Bind(Tween.Tween.CopyTween(Modifier.Tween.GrowTween), 0, "GetScale", "SetScale")
				set:SetTarget(model)
				Util.Debug("SETTING GROW ON: "..self.Target.ID)
				Tween.Tweener.Play(set)				

				--restore collision volume
				self.Target.CapsuleCollider:Set_Height(PLAYER_HEIGHT)
				self.Target.CapsuleCollider:Set_Radius(PLAYER_RADIUS)
			end

			--Remove self from ActiveEffects
			Modifier.RemoveActiveEffect(self)
		end
	},
	Grow =
	{
		Duration = 10,
		VisualDuration = 1.2,
		VisualRemoved = false,
		DurationElapsed = 0,
		Type = "Grow",
		Buff = Buff.CreateBuff("Grow", "Increases Player Size.", nil),
		
		Activate = function(self)
			
			if(self.Target == Player.Client) then						
				--Check for opposites		
				if(Player.Client:HasBuffType(Modifier.ModifierBehavior.Shrink.Buff)) then
					Modifier.ModifierBehavior.KillEffect(Modifier.FindClientEffectByType(Modifier.ModifierBehavior.Shrink.Type))
				elseif(Player.Client:CanAddBuff()) then
					self:ApplyGrow()
					Modifier.AlertHitMe(self)
				end
			else
				self:ApplyGrow()
				Modifier.AlertHitOther(self)
			end			
			
		end,
		
		ApplyGrow = function(self)
			
			local growInfo = Modifier.StaticData.Grow
			
			--Initialize info
			self.DurationElapsed = 0
			self.VisualRemoved = false
			
			local Inverted = Player.Client:HasBuffType(Modifier.ModifierBehavior.InvertGravity.Buff)
			
			--Trigger radiation animation
			--local root =self.Target.Root
			local root =self.Target.BodyNode
			self.Radiation = Singularity.Components.GameObject:Create("Radiation", nil, nil)
			local pos = root:Get_Transform():Get_Position()
			if(Inverted) then
				pos. y = pos.y - 0.001
			else
				pos. y = pos.y + 0.001
			end
			
			self.Radiation:Get_Transform():Set_Position(pos)
			self.Radiation:Get_Transform():Set_Scale(Vector3:new(0,0,0))
			Tween.GrantScaleFunctionality(self.Radiation)
			local set = Tween.TweenSet.MakeTweenSet()
			set:Bind(Tween.Tween.CopyTween(Modifier.Tween.RadiationGrow), 0, "GetScale", "SetScale")
			set:SetTarget(self.Radiation)
			Tween.Tweener.Play(set)
			local renderComp = Singularity.Graphics.MeshRenderer:new(growInfo.RadiationMesh:Clone(), growInfo.RadiationMaterial:Clone())
			self.Radiation:AddComponent(renderComp)
			
			if(self.Target == Player.Client) then
				local tween
				set = Tween.TweenSet.MakeTweenSet()
				if(Inverted) then
					tween = Modifier.Tween.LowerCameraTween
				else
					tween = Modifier.Tween.RaiseCameraTween
				end
				set:Bind(Tween.Tween.CopyTween(tween), 0, "Height")
				set:SetTarget(Player.Camera)
				Tween.Tweener.Play(set)
				
				--grow collision box
				Player.Client.CharacterController:Set_Height(PLAYER_HEIGHT * 1.5)
				Player.Client.CharacterController:Set_Radius(PLAYER_RADIUS * 1.5)
				
				Player.Client.CharacterController:Set_Scale(Vector3:new(1.5, 1.5, 1.5))
				
				--apply grow buff
				Player.Client:AddBuff(Modifier.ModifierBehavior.Grow.Buff)				
			else
				--trigger grow tween (stop on collide)
				Tween.GrantScaleFunctionality(self.Target.BodyNode)
				local set = Tween.TweenSet.MakeTweenSet()
				set:Bind(Tween.Tween.CopyTween(Modifier.Tween.GrowTween), 0.2, "GetScale", "SetScale")
				set:SetTarget(self.Target.BodyNode)
				Tween.Tweener.Play(set)
				
				self.Target.CapsuleCollider:Set_Height(PLAYER_HEIGHT * 1.5)
				self.Target.CapsuleCollider:Set_Radius(PLAYER_RADIUS * 1.5)
			end		
			
			--append to active list
			Modifier.AddActiveEffect(self)
			
			--play sound
			local comp = tolua.cast (self.Spawner.ModifierModel:GetComponent("Singularity.Audio.AudioEmitter"), "Singularity::Audio::AudioEmitter")
			comp:Play(0)
		end,
		
		Process = function(self,elapsed)
			self.DurationElapsed = self.DurationElapsed + elapsed

			if(self.DurationElapsed > self.VisualDuration and not self.VisualRemoved) then
				self.VisualRemoved = true
				self.Radiation:Set_IsActive(false)
			end
			
			if(self.DurationElapsed > self.Duration) then
				self:Deactivate()
			end
		end,
		
		Deactivate = function(self)
		
			if(self.Target == Player.Client) then		
				set = Tween.TweenSet.MakeTweenSet()
				local tween
				--lower the camera when facing normally, otw, "raise" it
				if(Player.Client:HasBuffType(Modifier.ModifierBehavior.InvertGravity.Buff)) then
					tween = Modifier.Tween.RaiseCameraTween
				else
					tween = Modifier.Tween.LowerCameraTween
				end
				set:Bind(Tween.Tween.CopyTween(tween), 0, "Height")
				set:SetTarget(Player.Camera)
				Tween.Tweener.Play(set)
				
				--restore collider
				Player.Client.CharacterController:Set_Height(PLAYER_HEIGHT)
				Player.Client.CharacterController:Set_Radius(PLAYER_RADIUS)
				Player.Client.CharacterController:Set_Scale(Vector3:new(1, 1, 1))
				Player.Client.CharacterController:Jump(1) -- triggers gravity
				
				--Remove buff from targets
				Player.Client:RemoveBuff(Modifier.ModifierBehavior.Grow.Buff)				
			else
				--trigger shrink tween
				local model = self.Target.BodyNode
				local set = Tween.TweenSet.MakeTweenSet()
				set:Bind(Tween.Tween.CopyTween(Modifier.Tween.ShrinkTween), 0, "GetScale", "SetScale")
				set:SetTarget(model)
				Tween.Tweener.Play(set)
				
				--restore collider
				self.Target.CapsuleCollider:Set_Height(PLAYER_HEIGHT)
				self.Target.CapsuleCollider:Set_Radius(PLAYER_RADIUS)
			end		
			
			--Remove self from ActiveEffects
			Modifier.RemoveActiveEffect(self)
		end
	},
	InvertGravity =
	{
		Duration = 10,
		DurationElapsed = 0,
		Type = "InvertGravity",
		Buff = Buff.CreateBuff("Invert Gravity", "Player can walk on the ceiling.", nil),
		
		Activate = function(self)
			
			if(Player.Client == self.Target) then				
				if(Player.Client:HasBuffType(Modifier.ModifierBehavior.InvertGravity.Buff)) then
					Modifier.ModifierBehavior.KillEffect(Modifier.FindClientEffectByType(Modifier.ModifierBehavior.InvertGravity.Type))
				elseif(Player.Client:CanAddBuff()) then
					self:ApplyInvertGravity()
					Modifier.AlertHitMe(self)
				end
			else
				self:ApplyInvertGravity()
				Modifier.AlertHitOther(self)
			end			
							
		end,
		
		ApplyInvertGravity = function(self)
			
			if(self.Target == Player.Client) then
				--Init
				self.DurationElapsed = 0
						
				--Flip Gravity
				self.FlipPlayer()
				
				--Add Buff
				Player.Client:AddBuff(Modifier.ModifierBehavior.InvertGravity.Buff)
				
				--Add Effect
				Modifier.AddActiveEffect(self)
			end
			
			--Play sound
			local comp = tolua.cast (self.Spawner.ModifierModel:GetComponent("Singularity.Audio.AudioEmitter"), "Singularity::Audio::AudioEmitter")
			comp:Play(0)
		end,
		
		FlipPlayer = function()
			
			--Flip gravity
			if(Player.Camera.Inverted) then
				Player.Client.CharacterController:Set_Gravity(-PLAYER_GRAVITY)
			else
				Player.Client.CharacterController:Set_Gravity(PLAYER_GRAVITY)
			end
			
			--Invert Camera
			Player.Camera.Invert()
			
		end,
		
		Process = function(self, elapsed)
			self.DurationElapsed = self.DurationElapsed + elapsed

			if(self.DurationElapsed > self.Duration) then
				self:Deactivate()
			end
		end,
		
		Deactivate = function(self)
			--Remove buff from targets
			Player.Client:RemoveBuff(Modifier.ModifierBehavior.InvertGravity.Buff)
									
			--Reorient
			self.FlipPlayer()
			
			--Remove self from ActiveEffects
			Modifier.RemoveActiveEffect(self)
		end
	},
	Knockback =
	{
		Type = "Knockback",
		Activate = function(self)			
			if(self.Target == Player.Client) then			
				--Notify
				Modifier.AlertHitMe(self)
				
				--Apply force to client
				Player.Client.CharacterController:AddExplosiveForce(100, self.Spawner.ModifierModel:Get_Transform():Get_Position(), MODIFIER_KNOCKBACK_RADIUS)									
			else
				--self:ApplyFrictionless()
				Modifier.AlertHitOther(self)
			end
			
			--Create particles	
			
			--Play Sound
			local comp = tolua.cast (self.Spawner.ModifierModel:GetComponent("Singularity.Audio.AudioEmitter"), "Singularity::Audio::AudioEmitter")
			comp:Play(0)
		end
	},	
	Frictionless =
	{
		Type = "Frictionless",
		Buff = Buff.CreateBuff("Frictionless", "Player moves faster, but can't change direction while moving.", nil),
		Duration = 5,
		DurationElapsed = 0,
		
		Activate = function(self)
			
			if(Player.Client == self.Target) then
				self:ApplyFrictionless()
				Modifier.AlertHitMe(self)
			else
				self:ApplyFrictionless()
				Modifier.AlertHitOther(self)
			end
			
		end,
		
		ApplyFrictionless = function(self)
			--init
			self.DurationElapsed = 0			
			
			if(self.Target == Player.Client) then
				--apply frictionless buff
				Player.Client:AddBuff(Modifier.ModifierBehavior.Frictionless.Buff)
			else
				--Add ice block to model
				local frictionlessInfo = Modifier.StaticData.Frictionless
				local target = self.Target
				local pos = Vector3:new(0,0,0)
				self.Ice = Singularity.Components.GameObject:Create("Ice", target.BodyNode, nil)
				self.Ice:Get_Transform():Set_LocalPosition(pos)			
				local renderComp = Singularity.Graphics.MeshRenderer:new(frictionlessInfo.IceBlockMesh:Clone(), frictionlessInfo.IceBlockMaterial:Clone())
				self.Ice:AddComponent(renderComp)
			end
			
			--append to active list
			Modifier.AddActiveEffect(self)
			local comp = tolua.cast (self.Spawner.ModifierModel:GetComponent("Singularity.Audio.AudioEmitter"), "Singularity::Audio::AudioEmitter")
			comp:Play(0)
		end,
		
		Process = function(self, elapsed)
			self.DurationElapsed = self.DurationElapsed + elapsed

			if(self.DurationElapsed > self.Duration) then
				self:Deactivate()
			end
		end,
		
		Deactivate = function(self)
			if(self.Target == Player.Client) then
				--Remove buff from targets
				Player.Client:RemoveBuff(Modifier.ModifierBehavior.Frictionless.Buff)
			else
				--Remove ice blocks
				self.Ice:Set_IsActive(false)
			end			
			
			--Remove self from ActiveEffects
			Modifier.RemoveActiveEffect(self)
		end,
	},
	Illusion =
	{
		Type = "Illusion",
		Duration = 20,
		DurationElapsed = 0,
		
		Activate = function(self)
			
			if(self.Target == Player.Client) then
				local existingIllusion = Modifier.FindActiveEffectByTypeAndSpawner("Illusion", self.Spawner)				
				if(existingIllusion) then
					Modifier.ModifierBehavior.KillEffect(existingIllusion)					
				else
					Util.Debug("I'm my own target")
					--Util.DumpTable(self)
					self:ApplyIllusion()
					Modifier.AlertHitOther(self) -- let the others know
				end	
			else
				Util.Debug("I'm somebody else's target")
				--Util.DumpTable(self)
				self:ApplyIllusion()
				--Modifier.AlertHitOther(self)
			end
			
		end,
		
		ApplyIllusion = function(self)
		
			Util.DumpTable(self)
			Util.Debug("spawner")
			Util.DumpTable(self.Spawner)
			--init
			self.DurationElapsed = 0
			--Spawn Player Model 
			local illusionInfo = Modifier.StaticData.Illusion
			local pos = self.Spawner.ModifierModel:Get_Transform():Get_Position()
			
			--Hide X
			self.Spawner.ModifierModel:Set_IsActive(false)
			
			--spin 180
			local rot = self.Spawner.ModifierModel:Get_Transform():Get_Rotation()
			
			self.Illusion = Singularity.Components.GameObject:Create("Illusion", nil, nil)
			self.Illusion:Get_Transform():Set_Position(pos)		
			self.Illusion:Get_Transform():Set_Rotation(rot)	
			local renderComp = Singularity.Graphics.MeshRenderer:new(illusionInfo.IllusionMesh:Clone(), illusionInfo.IllusionMaterial:Clone())
			self.Illusion:AddComponent(renderComp)
			
			Modifier.AddActiveEffect(self)
			local comp = tolua.cast (self.Spawner.ModifierModel:GetComponent("Singularity.Audio.AudioEmitter"), "Singularity::Audio::AudioEmitter")
			comp:Play(0)
		
		end,
		
		Process = function(self, elapsed)
			self.DurationElapsed = self.DurationElapsed + elapsed

			if(self.DurationElapsed > self.Duration) then
				--Remove player model
				self:Deactivate()
				
				--Remove self from ActiveEffects
				Modifier.RemoveActiveEffect(self)
			end
		end,
		
		Deactivate = function(self)
			self.Illusion:Destroy()
			
			--restore X
			self.Spawner.ModifierModel:Set_IsActive(true)
		end
	},
	IncreaseGravity = -- Feather Light
	{
		--Now Feather Light
		Type = "IncreaseGravity",
		Buff = Buff.CreateBuff("Increase Gravity", "Player falls faster and jumps lower.", nil),
		Duration = 10,
		DurationElapsed = 0,
		
		Activate = function(self)
			
			if(self.Target == Player.Client) then
					self:ApplyGravity()
					Modifier.AlertHitMe(self)	
			else
				self:ApplyGravity()
				Modifier.AlertHitOther(self)
			end
			
		end,
		
		ApplyGravity = function(self)
			self.DurationElapsed = 0
			
			
			if(self.Target == Player.Client) then
				--apply buff
				Player.Client:AddBuff(Modifier.ModifierBehavior.IncreaseGravity.Buff)
				--reduce weight				
				Player.Client.CharacterController:Set_Mass(350);
			end			
			
			--append to active list
			Modifier.AddActiveEffect(self)
			local comp = tolua.cast (self.Spawner.ModifierModel:GetComponent("Singularity.Audio.AudioEmitter"), "Singularity::Audio::AudioEmitter")
			comp:Play(0)
		end,
		
		Process = function(self, elapsed)
			self.DurationElapsed = self.DurationElapsed + elapsed

			if(self.DurationElapsed > self.Duration) then
				self:Deactivate()
			end
		end,
		
		Deactivate = function(self)
		
			if(self.Target == Player.Client) then
				--Remove buff from targets
				Player.Client:RemoveBuff(Modifier.ModifierBehavior.IncreaseGravity.Buff)
				--Reset weight
				Player.Client.CharacterController:Set_Mass(1000);
			end			
			
			--Remove planets						
			
			--Remove self from ActiveEffects
			Modifier.RemoveActiveEffect(self)
		
		end
	},
	Wall =
	{
		DeclineTime = 2,
		DurationElapsed = 0,
		WallDecline = 7.9,
		Type = "Wall",
		Toggle = true,
		State = "Active",
		
		Activate = function(self)
			
			if(self.Target == Player.Client) then
				local existingWall = Modifier.FindActiveEffectByTypeAndSpawner("Wall", self.Spawner)
				
				if(existingWall) then
					Modifier.ModifierBehavior.KillEffect(existingWall)	
					Util.Debug("existing")
				else
					self:SummonWall()
					Util.Debug("summoned")
					Util.DumpTable(self)
					Modifier.AlertHitOther(self) -- let the others know
				end
			else
				--Modifier.AlertHitOther(self)
				self:SummonWall()
			end
			
		end,
		
		SummonWall = function(self)
			self.DurationElapsed = 0	
			self.State = "Active"
			local wallInfo = Modifier.StaticData.Wall
			
			--Summon Wall
			local modifier = self.Spawner.ModifierModel
			self.Wall = Singularity.Components.GameObject:Create("Wall", nil, nil)
			local pos = modifier:Get_Transform():Get_Position()
			self.Wall:Get_Transform():Set_Position(pos)
			self.Wall:Get_Transform():Set_Rotation(modifier:Get_Transform():Get_Rotation())
			self.Wall:Get_Transform():Set_Scale(Vector3:new(1,0,1))
			local set = Tween.TweenSet.MakeTweenSet()
			self.Wall.GetYScale = Modifier.Tween.GetYScale
			self.Wall.SetYScale = Modifier.Tween.SetYScale
			set:Bind(Tween.Tween.CopyTween(Modifier.Tween.WallRise), 0, "GetYScale", "SetYScale")
			set:SetTarget(self.Wall)
			Tween.Tweener.Play(set)
			local renderComp = Singularity.Graphics.MeshRenderer:new(wallInfo.WallMesh:Clone(), wallInfo.WallMaterial:Clone())
			self.Wall:AddComponent(renderComp)
			
			--Give it a collider
			local size = Vector3:new(0.14, 0.8, 0.08)
			self.WallCollider = Singularity.Physics.BoxCollider(self.Spawner.OwnerID.."."..self.ID.."-WallCollider", pos, size)
			--[[self.WallCollider.GetYSize = Modifier.Tween.GetYSize
			self.WallCollider.SetYSize = Modifier.Tween.SetYSize
			set = Tween.TweenSet.MakeTweenSet()
			set:Bind(Tween.Tween.CopyTween(Modifier.Tween.WallBoxRise), 0, "GetYSize", "SetYSize")
			set:SetTarget(self.WallCollider)
			Tween.Tweener.Play(set)]]--			
			self.Wall:AddComponent(self.WallCollider)
						
			Modifier.AddActiveEffect(self)
			local comp = tolua.cast (self.Spawner.ModifierModel:GetComponent("Singularity.Audio.AudioEmitter"), "Singularity::Audio::AudioEmitter")
			comp:Play(0)
		end,
		
		Process = function(self, elapsed)
			self.DurationElapsed = self.DurationElapsed + elapsed

			if(self.State == "Active") then
				if(self.DurationElapsed > self.WallDecline) then
					self:Deactivate()
				end
			else
				if(self.DurationElapsed > self.DeclineTime) then
					self.Wall:Destroy()
					Modifier.RemoveActiveEffect(self)
				end
			end			
		end,
		
		Deactivate = function(self)
			local set = Tween.TweenSet.MakeTweenSet()
			set:Bind(Tween.Tween.CopyTween(Modifier.Tween.WallDecline), 0, "GetYScale", "SetYScale")
			set:SetTarget(self.Wall)
			Tween.Tweener.Play(set)
			self.DurationElapsed = 0
			self.State = "Deactivating"
		end,
	}	
}

--Spawn an effect on a player
Modifier.AddActiveEffect = function(effect)
	table.insert(Modifier.ActiveEffects, effect)
end

--Removes a player effect
Modifier.RemoveActiveEffect = function(effect)
    for i = 1, #Modifier.ActiveEffects do
		if(Modifier.ActiveEffects[i] == effect) then
			table.remove(Modifier.ActiveEffects,i)
			return
		end
	end
end

Modifier.FindClientEffectByType = function(typeOf)
	for _,v in ipairs(Modifier.ActiveEffects) do
		if(v.Target == Player.Client and v.Type == typeOf) then
			return v
		end
	end
end

Modifier.FindActiveEffectByID = function(ID)
	for k,v in pairs(Modifier.ActiveEffects) do
		if(v.ID == ID) then
			return v
		end
	end
	
	return nil
end

Modifier.FindActiveEffectByTypeAndSpawner = function(type, spawner)
	for k,v in pairs(Modifier.ActiveEffects) do
		if(v.Type == type and v.Spawner == spawner) then
			return v
		end
	end
	return nil
end

Modifier.FindActiveEffectByTypeAndTarget = function(type, target)
	for k,v in pairs(Modifier.ActiveEffects) do
		if(v.Type == type and v.Target == target) then
			return v
		end
	end
	return nil
end

Modifier.RemoveEffectsByTarget = function(target)
	local effects = {}
	for k,v in pairs(Modifier.ActiveEffects) do
		if(v.Target == target) then
			table.insert(effects, v)
		end
	end
	
	for _,v in ipairs(effects) do
		if(v.Target == Player.Client) then
			if(v.Buff) then
				Player.Client:RemoveBuff(effect.Buff)
			end
		end
		v:Deactivate()
	end
end

-- enable network and update
Modifier.Enable = function()
	Modifier.Enabled = true
	Network.Register(Modifier.Network.ModifierTargetType, Modifier.Network.ModifierTargetMsg)
	Network.Register(Modifier.Network.ModifierHitType, Modifier.Network.ModifierHitMsg)
	Network.Register(Modifier.Network.ModifierRemoveType, Modifier.Network.ModifierRemoveMsg)	
end

-- disable network and update
Modifier.Disable = function()
	Modifier.Enabled = false
	Network.Unregister(Modifier.Network.ModifierTargetType, Modifier.Network.ModifierTargetMsg)
	Network.Unregister(Modifier.Network.ModifierHitType, Modifier.Network.ModifierHitMsg)
	Network.Unregister(Modifier.Network.ModifierRemoveType, Modifier.Network.ModifierRemoveMsg)	
end

Modifier.Update = function(elapsed)
	--Handle Modifiers
	if(Modifier.Enabled) then
		for _,v in pairs(Modifier.ClientCooldowns) do
			v:Process(elapsed)
		end
	end	
	--Handle Modifier Effects
	for _,v in ipairs(Modifier.ActiveEffects) do
		if(v.Process ~= nil) then
			v.Process(v, elapsed)
		end
	end
end

Modifier.Network =
{
	ModifierTargetType = "M1",
	ModifierHitType = "M2",
	ModifierRemoveType = "M3",
	ModifierTargetMsg = function(value)
		--If I didnt do it  and its targeting me
		--Util.DumpTable(value)
		if(value.OwnerID ~= Player.ClientID) then
			local modifier = Player.Client:GetModifierByID(value.ModifierID)
			Modifier.ModifierBehavior.SpawnEffect(value.Type, modifier, Player.Client)
		end
	end,
	ModifierHitMsg = function(value)
		
		if(value.OwnerID ~= Player.Client.ID) then -- already handled it
			Util.Debug("hitmsg")
			--Util.DumpTable(value)
			Util.Debug(value.OwnerID)
			--Util.DumpTable(modifier)
			local target = Main.GamePlay.Players[value.TargetID]
			local owner = Main.GamePlay.Players[value.OwnerID]
			--Util.DumpTable(Main.GamePlay.Players)
			if(owner) then
				Util.Debug("targetted")
				local modifier = owner:GetModifierByID(value.ModifierID)
				if (target) then
					Modifier.ModifierBehavior.SpawnEffect(value.Type, modifier, target, value.EffectID)
				end
			end
		end
	end,
	ModifierRemoveMsg = function(value)
		Util.Debug("removemsg")
		Util.DumpTable(value)
		if(value.TargetID ~= Player.Client.ID) then
			Modifier.ModifierBehavior.KillEffect( Modifier.FindActiveEffectByID(value.EffectID) )
		end
	end,
}

print("Modifier Loaded.")