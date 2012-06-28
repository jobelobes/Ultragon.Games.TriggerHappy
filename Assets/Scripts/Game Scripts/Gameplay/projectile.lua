local PROJECTILE_RAY_DEPTH = 10000
local PROJECTILE_DEFAULT_DEPTH = 100
local PROJECTILE_MAX_DURATION = 3
local PROJECTILE_MAX_OBJECTS = 100

Projectile =
{
	Enabled = false,
	Projectiles = {},
	
	--Physical object we see in the world
	Objects = {	},
	
	--Table capable of spawning AoE projectiles
	MakeAoEProjectileType = function(typeOf, damage, aoeRange, speed, gravity, particlesAtCollide, radius, mesh, material, scale)
		local props = {
			Type = typeOf,
			Damage = damage,
			AoERange = aoeRange,
			Speed = speed,
			Gravity = gravity,
			Particles = particlesAtCollide,
			Radius = radius,
			Mesh = mesh,
			Material = material,
			Scale = scale,
			MakeClosure = Projectile.MakeAoEClosure
		}
		Projectile.Projectiles[typeOf] = props
		
		return Util.JoinTables(props, Util.ShallowTableCopy(Projectile.Functions))
	end,
	--Table capable of spawning single target projectiles
	MakeSingleProjectileType = function(typeOf, damage, speed, gravity, particlesAtCollide, radius, mesh, material, scale)
		local props = {
			Type = typeOf,
			Damage = damage,
			Speed = speed,
			Gravity = gravity,
			Particles = particlesAtCollide,
			Radius = radius,
			Mesh = mesh,
			Material = material,
			Scale = scale,
			MakeClosure = Projectile.MakeSingleClosure,
		}
		Projectile.Projectiles[typeOf] = props
		
		return Util.JoinTables(props, Util.ShallowTableCopy(Projectile.Functions))
	end,	
	Functions =
	{
		--Generalized projectile building function
		InitGeneral = function(self, owner, position, direction, speed, damage)
			--check to see if there are any projectiles in the dead pool, if there are, return that object, otherwise create a new one
			
			--find the first dead projectile 
			local projInstance = Projectile.Functions.FindDeadProjectile()
			local obj = projInstance.GameObj
			
			--Scale
			if(self.Scale) then
				obj:Get_Transform():Set_Scale(Vector3:new(self.Scale,self.Scale,self.Scale))
			end
			
			--Position
			obj:Get_Transform():Set_Position(position)
			obj:Get_Transform():Set_Rotation(owner.BodyNode:Get_Transform():Get_Rotation())
			
			--Add Physical Body
			--local body = Singularity.Physics.RigidBody:new("Projectile_RigidBody")
			
			--Get Collider
			--obj.Collider = Singularity.Physics.BoxCollider:new("Projectile_Collider", Vector3:new(0,0,0), Vector3:new(self.Radius*2,self.Radius*2,self.Radius*2))
			
			--Retrieve the mesh renderer component from the game object and set the mesh and material
			local meshrenderer = tolua.cast(obj:GetComponent("Singularity.Graphics.MeshRenderer"), "Singularity::Graphics::MeshRenderer")
			meshrenderer:Set_Mesh(self.Mesh:Clone())
			meshrenderer:Set_Material(self.Material:Clone())

			--Retrieve the box collider component from the game object and set the size
			local collider = tolua.cast (obj:GetComponent("Singularity.Physics.BoxCollider"), "Singularity::Physics::BoxCollider")
			collider:Set_Size(Vector3:new(self.Radius*2, self.Radius*2, self.Radius*2))
			Util.Debug("Position: "..position.x..", "..position.y..", "..position.z)
			collider:Set_Position(position)
			collider:Set_Enabled(true)
			
			obj.Collider = collider
			
			--Retrieve the physics body component
			local body = tolua.cast (obj:GetComponent("Singularity.Physics.RigidBody"), "Singularity::Physics::RigidBody")
			body:Set_Enabled(true)
			
			--Set Grav, speed, and add a force
			body:Set_IgnoreGravity((not self.Gravity) or false)
			body:StopAllMovement() -- reset it
			speed = speed or self.Speed
			body:AddForce(Vector3:new(direction.x*speed, direction.y*speed, direction.z*speed),3) 		
			
			--Do Muzzle Flash
			if(self.MuzzleParticle) then
				--Particle Effect
			end
			
			--Do SFX
			local wepType = Weapon.GetWeaponTypeByProjectileType(self.Type)
			local wepModel = owner:GetWeaponByType(wepType).WeaponModel
			local comp = tolua.cast (wepModel:GetComponent("Singularity.Audio.AudioEmitter"), "Singularity::Audio::AudioEmitter")				
			comp:Play(0)		

			--Save it to kill it if it hangs around too long
			obj.Elapsed = 0

			projInstance.IsAlive = true
			table.insert(Projectile.Detritus, projInstance)
				
			Util.DumpTable(Projectile.Detritus, 0)
			return obj
		end,
		
		FindDeadProjectile = function()
			for i = 1, PROJECTILE_MAX_OBJECTS do
				if(Projectile.Objects[i].IsAlive == false) then
					return Projectile.Objects[i]
				end
			end
			
			return nil
		end,
		
		InitializeProjectiles = function(fist, fistMaterial)
			--do 500 times, insert into object table
			for i = 1, PROJECTILE_MAX_OBJECTS do
				local projInstance = {
					IsAlive = false,
					GameObj = Singularity.Components.GameObject:Create("Particle", nil, nil),
				}
				
				--Util.Debug("setting position"..i)
				--Position
				projInstance.GameObj:Get_Transform():Set_Position(Vector3:new(0, -100, 0))
		
				--Add Mesh
				local meshrenderer = Singularity.Graphics.MeshRenderer:new(fist, fistMaterial)
				projInstance.GameObj:AddComponent(meshrenderer)
				
				--Add Physical Body
				local body = Singularity.Physics.RigidBody:new("Projectile_RigidBody")
				projInstance.GameObj:AddComponent(body)
				body:Set_Enabled(false)
				
				--Add Collider
				--local collider = Singularity.Physics.BoxCollider:new("Projectile_Collider", Vector3:new(0,0,0), Vector3:new(0,0,0))
				local collider = Singularity.Physics.BoxCollider:new("Projectile_Collider", Vector3:new(0,0,0), Vector3:new(2,2,2))
				projInstance.GameObj:AddComponent(collider)
				collider:Set_Enabled(false)
				
				--Set Grav
				body:Set_IgnoreGravity(false)
				
				--set enabled and visible to false
				
				table.insert(Projectile.Objects, projInstance)				
			end
			Util.Debug("End of projectile creation")
		end,
		
		KillProjectile = function(obj)
			--Set the position off the world
			obj:Get_Transform():Set_Position(Vector3:new(0, -100, 0))
			
			--Retrieve the box collider component from the game object and set the size
			local collider = tolua.cast (obj:GetComponent("Singularity.Physics.BoxCollider"), "Singularity::Physics::BoxCollider")
			collider:Set_Enabled(false)
			
			--Retrieve the physics body component
			local body = tolua.cast (obj:GetComponent("Singularity.Physics.RigidBody"), "Singularity::Physics::RigidBody")
			body:Set_Enabled(false)
		end,
		
		--Remote spawn
		Spawn = function(self, owner, position, direction, speed, damage)

			self:InitGeneral(owner, position, direction, speed, damage)

			return obj
		end,
		--Client spawn
		SpawnClient = function(self, owner, position, direction, speed, damage)

			local collider, targetPosition = Projectile.DoRayQuery(Player.Client.CameraNode:Get_Transform():Get_Position(), direction, PROJECTILE_RAY_DEPTH)
						
			--find the vector to the target so we know the shooting direction
			local shotVector = Util.Vector3Subtract(targetPosition, position)
			shotVector = Util.Normalize( shotVector )
			
			--Debug Target Drawing
			--[[
			local obj = Singularity.Components.GameObject:Create("Particle", nil, nil)
			obj:Get_Transform():Set_Scale(Vector3:new(0.1,0.1,0.1))
			--Position
			obj:Get_Transform():Set_Position(targetPosition)			
			--Add Mesh
			obj:AddComponent(Singularity.Graphics.MeshRenderer:new(Singularity.Graphics.Mesh:CreatePrimitive(3), Singularity.Graphics.Material:CreateBasicMaterial()))			
			]]--
			
			self.ProjectileObject = self:InitGeneral(owner, position, shotVector, speed or self.Speed, damage or self.Damage)
            --Add Collision Callback
			self.ProjectileObject.CollisionClosure = self:MakeClosure(damage or self.Damage)
			--projObj.Collider.CollisionEnter:Add(tolua.cast(Singularity.Scripting.LuaCollisionDelegate:new(projObj.CollisionClosure), "Singularity::IDelegate"))
            ColliderSmoother.Create(self.ProjectileObject.Collider, 0.5, self.ProjectileObject.CollisionClosure, nil, nil)

			--Notify
			local shotDesc =
			{
				ID = Player.Client.ID,
				Type = self.Type,
				Position = {x = position.x, y = position.y, z = position.z},
				Direction = {x = shotVector.x, y = shotVector.y, z = shotVector.z},
			}
			Network.SendReliable(Projectile.Network.FireType, shotDesc)

		end,		
	},
	MakeAoEClosure = function(self, damage)
		local dmg = damage or self.Damage
		ret = function(collider, target)

			if(target) then

				--dont hit ourself
				if(Util.VerifyLabel(target:Get_Name(), "Collider")) then
					local ID = Util.ExtractID(target:Get_Name())
					--dont take damage from your own bullet
					if(ID == Player.Client.ID) then
						return true
					end
				end

            	--sphere query
            	local center = self.ProjectileObject:Get_Transform():Get_Position()
				local colliders, count = Singularity.Physics.Collider.SphereCast(center, self.Radius)
				if(count > 0) then
					local targets = {}
					for _,v in pairs(colliders) do
						if(Util.VerifyLabel(v:Get_Name(), "Collider")) then
							local ID = Util.ExtractID(v:Get_Name())

							--Do Dmg
							Util.Debug("Boom for "..dmg)
						--check wall and illusion hits
						end
					end

				end

				--Blow it up
				Util.Debug("AoE Boom")
				--spawn particles
				--self:Destroy()
				--Projectile.Functions.KillProjectile(self.GameObj)
				self.GameObj.Elapsed = PROJECTILE_MAX_DURATION + 1
				
				return false

			end
			
			return true
		end
		return ret
	end,
	MakeSingleClosure = function(self, damage)
		local dmg = damage or self.Damage
		ret = function(collider)
			--get target
			if(target) then
				--See if we hit a player
				if(Util.VerifyLabel(target:Get_Name(), "Collider")) then
					local ID = Util.ExtractID(target:Get_Name())
					--dont take damage from your own bullet
					if(ID == Player.Client.ID) then
						return true
					else
						--deal damage
						Util.Debug("Boom for "..dmg)
					end
				--check for walls
				end
				
				--Blow it up
				Util.Debug("Single Boom")
				--spawn particles
				--self:Destroy()
				--Projectile.Functions.KillProjectile(self.GameObj)
				self.GameObj.Elapsed = PROJECTILE_MAX_DURATION + 1
				
				return false
			end
			
			return true
		end
		return ret
	end,
}

Projectile.Detritus = {}

Projectile.DoRayQuery = function(start, direction, range)

	--ray query
	local rayLength = Vector3:new(direction.x * range, direction.y * range, direction.z * range)
	local rayTo = Util.Vector3Add(start, rayLength)
	local collider, depth = Singularity.Physics.Collider:Raycast(start, rayTo, 0)
	
	--if it doesnt hit, use max depth
	if(depth == 0) then
		depth = 1
	end

	--calc the collision position
	local targetOffset = Vector3:new(direction.x * depth * range, direction.y * depth * range, direction.z * depth * range)
	local targetPosition = Util.Vector3Add(start, targetOffset)
	
	return collider, targetPosition, depth

end

Projectile.DoInstantSingle = function(damage, position, direction, typeOf)
	Util.Debug("Imma doin a single target instant.")
	
	--ray query
	local collider, targetPosition = Projectile.DoRayQuery(Player.Client.CameraNode:Get_Transform():Get_Position(), direction, PROJECTILE_RAY_DEPTH)
		
	--Debug Sphere
	--[[
	local obj = Singularity.Components.GameObject:Create("Particle", nil, nil)
	obj:Get_Transform():Set_Scale(Vector3:new(0.1,0.1,0.1))
	obj:Get_Transform():Set_Position(targetPosition)			
	obj:AddComponent(Singularity.Graphics.MeshRenderer:new(Singularity.Graphics.Mesh:CreatePrimitive(3), Singularity.Graphics.Material:CreateBasicMaterial()))
	]]--
	--Test
	
	--damage first
	if(collider) then
		--Verify that it's a -Collider tag
		if(Util.VerifyLabel(collider:Get_Name(), "Collider")) then
		
			--Util.Debug("verified collider")
			local ID = Util.ExtractID(collider:Get_Name())
			if(ID >= 0) then
				--notify applied dmg
				local hitMsg = {
					Weapon = typeOf,
					Targets = {
						[1] = {
							ID = ID,
							Damage = damage,
							AttackerID = Player.Client.ID,
						}
					}
				}
				Network.SendReliable(Projectile.Network.HitType, hitMsg)			
			end
		elseif(Util.VerifyLabel(collider:Get_Name(), "WallCollider")) then
			--Send wall hit message for achievement
            local OwnerID, EffectID = Util.ExtractID(collider:Get_Name())
			Network.SendReliable(Projectile.Network.ObjectType, {Object = "Wall", OwnerID = OwnerID, AttackerID = Player.Client.ID})
		elseif(Util.VerifyLabel(collider:Get_Name(), "IllusionCollider")) then
			--Send Illusion Hit Msg
		end
		
		--notfy of where it hit
		local rayHitMsg = {
			Weapon = typeOf,
			Targets = {
				[1] = {
					Position = {x = targetPosition.x, y = targetPosition.y, z = targetPosition.z},
				}
			}
		}
		--Util.Debug("Target Position: "..targetPosition.x..", "..targetPosition.y..", "..targetPosition.z.."   Name of Collider: "..collider:Get_Name().."  Weapon Type: "..typeOf)
		--Projectile.HandleRayHitEffect(typeOf, targetPosition)

		Network.SendReliable(Projectile.Network.RayHitType, rayHitMsg)
	end
	
	--notify that it fired
	local fireMsg =
	{
		Weapon = typeOf,
		ID = Player.Client.ID
	}
	Network.SendReliable(Projectile.Network.RayFireType, fireMsg)
end

Projectile.DoShotgun = function(damage, position, direction, particlesAtCollide)
	Util.Debug("It does shotgun")
	
	--cone query params
	local dx = 0.035
	local dy = 0.035
	local depth = 2
	local numberOfRays = 4

	local reticlePosition = Player.Client.CameraNode:Get_Transform():Get_Position()
	local _, aimSpot = Projectile.DoRayQuery(reticlePosition, direction, PROJECTILE_RAY_DEPTH)
	local originDirection = Util.Vector3Subtract(aimSpot, reticlePosition)
	originDirection = Util.Normalize(originDirection)
	local origin = Util.Vector3Add(reticlePosition, Vector3:new(originDirection.x*depth, originDirection.y*depth, originDirection.z*depth))
	--basis vectors of the shotgun plane
	local planeX = Util.Vector3CrossProduct(originDirection, Vector3:new(0,1,0))
	local planeY = Util.Vector3CrossProduct(originDirection, planeX)

	local targets = {}
	local wallTargets = {}
	local illusionTargets = {}

	--iterate over a grid
	for x = -(numberOfRays*0.5),(numberOfRays*0.5) do
		for y = -(numberOfRays*0.5), (numberOfRays*0.5) do

		--calc ray
			local offsetX = Vector3:new(planeX.x * x * dx, planeX.y * x * dx, planeX.z * x * dx)
			local offsetY = Vector3:new(planeY.x * y * dy, planeY.y * y * dy, planeY.z * y * dy)
			local rayTo = Util.Vector3Add(offsetX, offsetY)
			rayTo = Util.Vector3Add(rayTo, origin)

			--spawn test spheres
			--[[
			local obj = Singularity.Components.GameObject:Create("Particle", nil, nil)
			obj:Get_Transform():Set_Scale(Vector3:new(0.01,0.01,0.01))
			obj:Get_Transform():Set_Position(rayTo)
			obj:AddComponent(Singularity.Graphics.MeshRenderer:new(Singularity.Graphics.Mesh:CreatePrimitive(3), Singularity.Graphics.Material:CreateBasicMaterial()))
			]]--
			--Test

			--do query
			local collider, targetPosition, targetDepth = Projectile.DoRayQuery(Player.Client.CameraNode:Get_Transform():Get_Position(), rayTo, depth)
			if(collider) then
				--if the target is of the -Collider tag
				if(Util.VerifyLabel(collider:Get_Name(), "Collider")) then
					local ID = Util.ExtractID(collider:Get_Name())
					Util.Debug("Collider ID: "..ID)
					if(ID >= 0) then
						--save the shortest ray hitting this ID (shorter ray = most dmg)
						if(not targets[ID]) then
							targets[ID] = {ID = ID, Depth = targetDepth, Position = targetPosition}
						else					
							if(targets[ID].Depth > targetDepth) then
								targets[ID].Depth = targetDepth
								targets[ID].Position = targetPosition
							end
						end
					end
				elseif(Util.VerifyLabel(collider:Get_Name(), "WallCollider")) then
					local OwnerID, EffectID = Util.ExtractID(collider:Get_Name())
					table.insert(wallTargets, {Object = "Wall", OwnerID = OwnerID, AttackerID = Player.Client.ID})
				elseif(Util.VerifyLabel(collider:Get_Name(), "IllusionCollider")) then
					--Save Illusion Target
				else
					Util.Debug("not verified")
				end
			end
		end
	end
	
	local fireMsg =
	{
		Weapon = "Shotgun",
		ID = Player.Client.ID
	}
	
	local hitMsg = {
		Weapon = "Shotgun",
		Targets = {}
	}
	
	local rayHitMsg = {
		Weapon = "Shotgun",
		Targets = {}
	}
	
	--calc the dmg for each target
	Util.Debug("Size of table: "..#targets)
	for k,v in pairs(targets) do
		Util.Debug("in targets")
		local dmg = damage * (1-v.Depth) + (damage * 0.25 * v.Depth)
		table.insert(hitMsg.Targets, { ID = v.ID, Damage = dmg, AttackerID = Player.Client.ID,})		
		table.insert(rayHitMsg.Targets, { Position = { x = v.Position.x, y = v.Position.y, z = v.Position.z } })
		Util.Debug("Target Position: "..targetPosition.x..", "..targetPosition.y..", "..targetPosition.z.."   Name of Collider: "..collider:Get_Name())
		--Projectile.HandleRayHitEffect("Shotgun", v.Position)
	end
	
	--Send shot data
	Network.SendReliable(Projectile.Network.RayFireType, fireMsg)
	Network.SendReliable(Projectile.Network.HitType, hitMsg)
	Network.SendReliable(Projectile.Network.RayHitType, rayHitMsg)
	
	--Send object data
	for _,v in ipairs(wallTargets) do
        Network.SendReliable(Projectile.Network.ObjectType, v)
	end
end

Projectile.DoTrigger = function(position, direction)

	--Try to trigger ours
	local modifier = ModifierTargets.FindModifier()
	
	--if we hit ours and its not cooling down
	if(modifier and Modifier.ClientCooldowns[modifier].Ready) then

		Util.Debug("Triggered "..modifier.Type)

		Modifier.ClientCooldowns[modifier].Ready = false
		--Trigger
		Modifier.TriggerBehavior[modifier.Type](modifier)
		
		--play sound for us
		local wep = Player.Client.WeaponCache["Trigger"]
		if(wep) then
			local wepModel = wep.WeaponModel
			local comp = tolua.cast (wepModel:GetComponent("Singularity.Audio.AudioEmitter"), "Singularity::Audio::AudioEmitter")				
			if(comp) then
				comp:Play(0)
			end
		end		
		
		return
	end

	
	--If failed to trigger ours, find enemy mod target
	local collider, targetPosition = Projectile.DoRayQuery(Player.Client.CameraNode:Get_Transform():Get_Position(), direction, PROJECTILE_RAY_DEPTH)
	
	if(collider) then
		if(Util.VerifyLabel(collider:Get_Name(), "ModifierCollider")) then
			--get owner and modifier ID
			local OwnerID, ID = Util.ExtractID(collider:Get_Name())
			
			--dont blow up our own modifier
			if(OwnerID ~= Player.Client.ID) then
				local msg = {
					OwnerID = OwnerID,
					ID = ID,
					Damage = 1,
				}
				Network.SendReliable(Projectile.Network.ModifierHitType, msg)
			end		
		end
	
		local rayHitMsg = {
			Weapon = "Trigger",
			Targets = {
				[1] = {
					Position = {x = targetPosition.x, y = targetPosition.y, z = targetPosition.z},
				}
			}
		}	
		Network.SendReliable(Projectile.Network.RayHitType, rayHitMsg)
	end
	
	local fireMsg =
	{
		Weapon = "Trigger",
		ID = Player.Client.ID
	}
	Network.SendReliable(Projectile.Network.RayFireType, fireMsg)
	
	--If both failed, do nothing

end

Projectile.DoSpawnModifier = function(position, direction, typeOf)

	local collider, targetPosition = Projectile.DoRayQuery(Player.Client.CameraNode:Get_Transform():Get_Position(), direction, PROJECTILE_RAY_DEPTH)
	
	--Not a player
	if(collider and collider:Get_Name():sub(1,8) == "Collider") then
		--if we can afford it
		if(Player.Client.Energy >= Modifier.StaticData[typeOf].Cost) then
			--spawn it with the player y rot
			local rot = Player.Client.BodyNode:Get_Transform():Get_Rotation()
			rot = Singularity.Components.Transform:RotationToEuler(rot)
			rot.x = 0
			rot.z = 0
			rot = Singularity.Components.Transform:EulerToRotation(rot)
			Util.Debug("Making modifier")
			Player.Client:AddModifier(Modifier.CreateClient(typeOf, targetPosition, rot))
		end
	end

end

Projectile.DoDestroyModifier = function(position, direction)

	--Try to destroy ours
	local modifier = ModifierTargets.FindModifier()
	if(modifier) then
		Util.Debug("Destroyed "..modifier.Type)
		Player.Client:RemoveModifier(modifier)
		Modifier.Destroy(modifier)
		return
	end

end

Projectile.HandleRayHitEffect = function(typeOf, position)
	Util.Debug("Weapon for effect: "..typeOf)
	if(Weapon.StaticData[typeOf].HitParticles) then
		--do particles for explosion
		local hitParticles = Weapon.StaticData[typeOf].HitParticles
		
		particleEmitter = Singularity.Particles.ParticleEmitter:new(hitParticles.Type, hitParticles.Duration)
		particleEmitter:Set_MainTexture(hitParticles.MainTexture)
		particleEmitter:Set_ParticleSize(hitParticles.ParticleSize)
		particleEmitter:Set_ParticleCount(hitParticles.ParticleCount)
		
		if(hitParticles.Type == Singularity.Particles.Explosion) then
			particleEmitter:Set_SecondaryTexture(hitParticles.SecondaryTexture or hitParticles.MainTexture)
			particleEmitter:Set_Radius(hitParticles.Radius)
			particleEmitter:Set_Direction(hitParticles.Direction)
			
			Util.Debug("Created explosion particles")
		end
		
		--do particles for foutain
		if(hitParticles.Type == Singularity.Particles.Fountain) then
			particleEmitter:Set_Radius(hitParticles.Radius)
			particleEmitter:Set_Radius2(hitParticles.Radius2 or hitParticles.Radius)
			Util.Debug("Created fountain particles")
		end
		
		--do particles for directional
		if(hitParticles.Type == Singularity.Particles.Directional) then
			particleEmitter:Set_SecondaryTexture(hitParticles.SecondaryTexture or hitParticles.MainTexture)
			particleEmitter:Set_Direction(hitParticles.Direction)
			Util.Debug("Created directional particles")
		end
		
		--do particles for linear
		if(hitParticles.Type == Singularity.Particles.Linear) then
			particleEmitter:Set_SecondaryTexture(hitParticles.SecondaryTexture or hitParticles.MainTexture)
			particleEmitter:Set_Radius(hitParticles.Radius)
			particleEmitter:Set_Direction(hitParticles.Direction)
			Util.Debug("Created linear particles")
		end
		
		--do particles for spiral
		if(hitParticles.Type == Singularity.Particles.Spiral) then
			particleEmitter:Set_SecondaryTexture(hitParticles.SecondaryTexture or hitParticles.MainTexture)
			particleEmitter:Set_Radius(hitParticles.Radius)
			particleEmitter:Set_Direction(hitParticles.Direction)
			Util.Debug("Created spiral particles")
		end
		
		--do particles for quad stretch
		if(hitParticles.Type == Singularity.Particles.QaudStretch) then
			particleEmitter:Set_Radius(hitParticles.Radius)
			particleEmitter:Set_Direction(hitParticles.Direction)
			Util.Debug("Created quad stretch particles")
		end
		
		--do particles for radial
		if(hitParticles.Type == Singularity.Particles.Radial) then
			particleEmitter:Set_SecondaryTexture(hitParticles.SecondaryTexture or hitParticles.MainTexture)
			particleEmitter:Set_Radius(hitParticles.Radius)
			particleEmitter:Set_Direction(hitParticles.Direction)
			Util.Debug("Created radial particles")
		end
		
		local obj = Singularity.Components.GameObject:Create("Particle System", nil, nil)
		obj:Get_Transform():Set_Position(position)
		obj:AddComponent(particleEmitter)
	end
end

Projectile.HandleRayFireEffect = function(typeOf, shooterID, position, direction)

	local shooter = Main.GamePlay.Players[shooterID]
	Util.Debug(shooter.Name.." shot a "..typeOf..".")
	
	--Do SFX
	local wep
	if(typeOf == "Trigger") then
		wep = shooter.WeaponCache["Trigger"]
	else
		wep = shooter:GetWeaponByType(typeOf)
	end

	if(wep) then
		local wepModel = wep.WeaponModel
		local comp = tolua.cast (wepModel:GetComponent("Singularity.Audio.AudioEmitter"), "Singularity::Audio::AudioEmitter")				
		if(comp) then
			comp:Play(0)
		end
	end
	
	--Do particles
	if(Weapon.StaticData[typeOf].HitParticles) then
		--do particles for explosion
		local hitParticles = Weapon.StaticData[typeOf].HitParticles
		
		particleEmitter = Singularity.Particles.ParticleEmitter:new(hitParticles.Type, hitParticles.Duration)
		particleEmitter:Set_MainTexture(hitParticles.MainTexture)
		particleEmitter:Set_ParticleSize(hitParticles.ParticleSize)
		particleEmitter:Set_ParticleCount(hitParticles.ParticleCount)
		
		if(hitParticles.Type == Singularity.Particles.Explosion) then
			particleEmitter:Set_SecondaryTexture(hitParticles.SecondaryTexture or hitParticles.MainTexture)
			particleEmitter:Set_Radius(hitParticles.Radius)
			particleEmitter:Set_Direction(hitParticles.Direction)
			
			Util.Debug("Created explosion particles")
		end
		
		--do particles for foutain
		if(hitParticles.Type == Singularity.Particles.Fountain) then
			particleEmitter:Set_Radius(hitParticles.Radius)
			particleEmitter:Set_Radius2(hitParticles.Radius2 or hitParticles.Radius)
			Util.Debug("Created fountain particles")
		end
		
		--do particles for directional
		if(hitParticles.Type == Singularity.Particles.Directional) then
			particleEmitter:Set_SecondaryTexture(hitParticles.SecondaryTexture or hitParticles.MainTexture)
			particleEmitter:Set_Direction(hitParticles.Direction)
			Util.Debug("Created directional particles")
		end
		
		--do particles for linear
		if(hitParticles.Type == Singularity.Particles.Linear) then
			particleEmitter:Set_SecondaryTexture(hitParticles.SecondaryTexture or hitParticles.MainTexture)
			particleEmitter:Set_Radius(hitParticles.Radius)
			particleEmitter:Set_Direction(hitParticles.Direction)
			Util.Debug("Created linear particles")
		end
		
		--do particles for spiral
		if(hitParticles.Type == Singularity.Particles.Spiral) then
			particleEmitter:Set_SecondaryTexture(hitParticles.SecondaryTexture or hitParticles.MainTexture)
			particleEmitter:Set_Radius(hitParticles.Radius)
			particleEmitter:Set_Direction(hitParticles.Direction)
			Util.Debug("Created spiral particles")
		end
		
		--do particles for quad stretch
		if(hitParticles.Type == Singularity.Particles.QaudStretch) then
			particleEmitter:Set_Radius(hitParticles.Radius)
			particleEmitter:Set_Direction(hitParticles.Direction)
			Util.Debug("Created quad stretch particles")
		end
		
		--do particles for radial
		if(hitParticles.Type == Singularity.Particles.Radial) then
			particleEmitter:Set_SecondaryTexture(hitParticles.SecondaryTexture or hitParticles.MainTexture)
			particleEmitter:Set_Radius(hitParticles.Radius)
			particleEmitter:Set_Direction(hitParticles.Direction)
			Util.Debug("Created radial particles")
		end
		
		local obj = Singularity.Components.GameObject:Create("Particle System", nil, nil)
		obj:Get_Transform():Set_Position(position)
		obj:AddComponent(particleEmitter)
	end

end

Projectile.Enable = function()
	Projectile.Enabled = true
	Network.Register(Projectile.Network.FireType, Projectile.Network.FireInfoMsg)
	Network.Register(Projectile.Network.HitType, Projectile.Network.HitInfoMsg)
	Network.Register(Projectile.Network.RayHitType, Projectile.Network.RayHitInfoMsg)
	Network.Register(Projectile.Network.ModifierHitType, Projectile.Network.ModifierHitInfoMsg)
	Network.Register(Projectile.Network.RayFireType, Projectile.Network.RayFireInfoMsg)
	Network.Register(Projectile.Network.ObjectType, Projectile.Network.ObjectInfoMsg)
end

Projectile.Disable = function()
	Projectile.Enabled = false
	Network.Unregister(Projectile.Network.FireType, Projectile.Network.FireInfoMsg)
	Network.Unregister(Projectile.Network.HitType, Projectile.Network.HitInfoMsg)
	Network.Unregister(Projectile.Network.RayHitType, Projectile.Network.RayHitInfoMsg)
	Network.Unregister(Projectile.Network.ModifierHitType, Projectile.Network.ModifierHitInfoMsg)
	Network.Unregister(Projectile.Network.RayFireType, Projectile.Network.RayFireInfoMsg)
	Network.Unregister(Projectile.Network.ObjectType, Projectile.Network.ObjectInfoMsg)
end

Projectile.Network =
{
	--Types
	FireType = "F1",
	HitType = "F2",
	RayHitType = "F3",
	ModifierHitType = "F4",
	RayFireType = "F5",
	ObjectType = "F6",
	IllusionType = "F7",
	--Handlers
	FireInfoMsg = function(value)
		if(value.ID ~= Player.Client.ID) then
			--spawn remote projectile
			local owner = Main.GamePlay.Players[value.ID]
			Projectile.Projectiles[value.Type]:Spawn(owner, Vector3:new(value.Position.x, value.Position.y, value.Position.z),Vector3:new(value.Direction.x, value.Direction.y, value.Direction.z))
		end
	end,
	HitInfoMsg = function(value)		
		for i,v in ipairs(value.Targets) do
			local attacker = Main.GamePlay.Players[v.AttackerID]
			local target = Main.GamePlay.Players[v.ID]
			Util.Debug(attacker.Name.." hit "..target.Name.." with "..value.Weapon.." for "..v.Damage)
			--take damage if we're hit
			if(target == Player.Client) then
				Player.Client:TakeDamage(v.Damage, attacker)
			end			
		end
	end,
	RayHitInfoMsg = function(value)
		for i,v in ipairs(value.Targets) do
			--draw the hit effect on each target
			Util.Debug("hit at "..v.Position.x..", "..v.Position.y..", "..v.Position.z)
			--Projectile.HandleRayHitEffect(value.Weapon, Vector3:new(v.Position.x, v.Position.y, v.Position.z))
		end
	end,
	ModifierHitInfoMsg = function(value)
		if(value.Owner == Player.Client.Owner) then
			local modifier = Player.Client:GetModifierByID(value.ID)
			--if my modifier is hit, apply dmg to it
			if(modifier) then
				modifier:TakeDamage(value.Damage)
			end
		end
	end,
	RayFireInfoMsg = function(value)
		--handle weapon firing
		--Projectile.HandleRayFireEffect(value.Weapon, value.ID)
	end,
	ObjectInfoMsg = function(value)
		--handle wall being hit for achievement
		if(Achievement.Goal.Type == Achievement.Goals.Reduce.Type) then
        	if(value.OwnerID == Player.Client.ID and value.Object == "Wall") then
				local shooter = Main.GamePlay.Players[value.AttackerID]
				if(shooter) then
					if(shooter.Team ~= Player.Client.Team) then
	                    Achievement.Goal.WallBlocks = Achievement.Goal.WallBlocks + 1
					end
				end
			end
		end
	end
}

Projectile.Update = function(elapsed)


	if(Projectile.Enabled) then
		local i = 1
		--kill off projectiles that have been around a while
		while i <= #Projectile.Detritus do
			local proj = Projectile.Detritus[i].GameObj
			proj.Elapsed = proj.Elapsed + elapsed
			if(proj.Elapsed > PROJECTILE_MAX_DURATION) then
				Projectile.Detritus[i].IsAlive = false
				Projectile.Functions.KillProjectile(proj)
				
				Util.Debug("removing projectile")
				table.remove(Projectile.Detritus, i)
				i = i - 1
			end
			i = i+1
		end
	end
	
	--[[
	if(Projectile.Enabled) then
		for i = 1, PROJECTILES_MAX_OBJECTS do
			if(Projectiles.Objects[i].IsAlive) then
				local proj = Projectile.Objects[i].GameObj
				proj.Elapsed = proj.Elapsed + elapsed
				
				if(proj.Elapsed > PROJECTILE_MAX_DURATION) then
					Projectile.IsAlive = false
					Projectile.KillProjectile(proj)
				end
			end
		end
	end
	--]]
end

Util.Debug("Projectiles Loaded.")

--[[
cannonball - z 44.136
fist - 2.734, 1.543, 52.082
--]]