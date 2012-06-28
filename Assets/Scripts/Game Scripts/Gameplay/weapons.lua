--Input
local Input = Singularity.Inputs.Input

Weapon = {
	Enabled = false,
}

--networked weapon info
Weapon.DynamicData = 
{
	Trigger = {
	},
	
	Pistol = {
		Type = "Pistol",
		Ammo = 0,
	},
	CannonGun = {
		Type = "CannonGun",
		Ammo = 0,
	},
	SniperRifle = {	
		Type = "SniperRifle",
		Ammo = 0,
	},
	AssaultRifle = {	
		Type = "AssaultRifle",
		Clip = 0,
		Ammo = 0,	
	},
	Shotgun = {
		Type = "Shotgun",
		Ammo = 0,
		Clip = 0,
	},
	Grenade = {
		Type = "Grenade",
		Ammo = 0,
	}
}

--projectile meshes
local fist, fistMaterial = Util.GetMeshAndMaterial(Main.AssetDirectory.."Models\\Fist.smurf")
local cannonBall, cannonBallMaterial = Util.GetMeshAndMaterial(Main.AssetDirectory.."Models\\CannonBall.smurf")

--main weapon info
Weapon.StaticData =
{
	Trigger = {
		FireCooldown = 0.5,
		HitParticles = {
		},
		FireCue = "weapon_NullifierFire",
	},

	Pistol = {
		Damage = 5,
		Type = "Pistol",
		NickName = "Little Bang",
		MaxChargeTime = 2.5,
		MaxChargeDamage = 45,
		FireCooldown = 0.3,
		MaxAmmo = 48,
		RegenPeriod = 2,
		MyScale = 1,
		TheirScale = 1,
		Mesh = Singularity.Graphics.Mesh:CreatePrimitive(0),
		Material = Singularity.Graphics.Material:CreateBasicMaterial(),
		FireCue = "weapon_PistolFire",
		ReloadCue = "weapon_PistolReload",
		SwitchCue = "weapon_PistolSwitch",
		EmptyCue = "weapon_EmptyClip",
		HitParticles = {
			MainTexture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Particles\\RedSmoke.png"),
			ParticleCount = 30,
			ParticleSize = 0.05,
			Type = Singularity.Particles.Explosion,
			Duration = 0.1,
			Radius = 0.1,
			Direction = Vector3:new(0.1, 0.1, 0.1),
		},
		FireParticles = {
			MainTexture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Particles\\Smoke.png"),
			ParticleCount = 10,
			Type = Singularity.Particles.Explosion,
			Duration, 0.05,
			Radius = 0.1,
			Direction = Vector3(0, 0.1, 0.1),
		},
		HoldType = WEAPON_HOLD_TYPE_ONE,

	},
	CannonGun = {
		Type = "Cannon",
		NickName = "Cannon Gun",
		FireCooldown = 1.5,
		MaxAmmo = 8,
		RegenPeriod = 10,
		MyScale = 1,
		TheirScale = 1,
		Mesh = Singularity.Graphics.Mesh:CreatePrimitive(1),
		Material = Singularity.Graphics.Material:CreateBasicMaterial(),
		Projectile = Projectile.MakeAoEProjectileType(	"CannonBall", 
														80,
														100, 
														2,
														false,
														nil,
														2.3,
														cannonBall,
														cannonBallMaterial,
														1),
		FireCue = "weapon_RocketFire",
		ReloadCue = "weapon_RocketReload",
		SwitchCue = "weapon_RocketSwitch",
		EmptyCue = "weapon_EmptyClip",
		HitParticles = {
			MainTexture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Particles\\RedSmoke.png"),
			ParticleCount = 30,
			ParticleSize = 0.05,
			Type = Singularity.Particles.Explosion,
			Duration = 0.1,
			Radius = 0.1,
			Direction = Vector3:new(0.1, 0.1, 0.1),
		},
		FireParticles = {
			MainTexture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Particles\\Smoke.png"),
			ParticleCount = 10,
			Type = Singularity.Particles.Explosion,
			Duration, 0.05,
			Radius = 0.1,
			Direction = Vector3(0, 0.1, 0.1),
		},
		HoldType = WEAPON_HOLD_TYPE_TWO,
	},
	SniperRifle = {
		Damage = 70,
		Type = "Sniper Rifle",
		NickName = "Long Shot",
		FireCooldown = 1.5,
		MaxAmmo = 12,
		RegenPeriod = 10,
		MyScale = 1,
		TheirScale = 1,
		Mesh = Singularity.Graphics.Mesh:CreatePrimitive(2),
		Material = Singularity.Graphics.Material:CreateBasicMaterial(),
		FireCue = "weapon_SniperFire",
		ReloadCue = "weapon_SniperReload",
		SwitchCue = "weapon_SniperSwitch",
		EmptyCue = "weapon_EmptyClip",
		ZoomInTween = Tween.Tween.MakeLinearTween(0.5, 0,-math.pi*0.15),
		ZoomOutTween = Tween.Tween.MakeLinearTween(0.5, 0,math.pi*0.15),
		HitParticles = {
			MainTexture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Particles\\RedSmoke.png"),
			ParticleCount = 30,
			ParticleSize = 0.05,
			Type = Singularity.Particles.Explosion,
			Duration = 0.1,
			Radius = 0.1,
			Direction = Vector3:new(0.1, 0.1, 0.1),
		},
		FireParticles = {
			MainTexture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Particles\\Smoke.png"),
			ParticleCount = 10,
			Type = Singularity.Particles.Explosion,
			Duration, 0.05,
			Radius = 0.1,
			Direction = Vector3(0, 0.1, 0.1),
		},
		HoldType = WEAPON_HOLD_TYPE_HIGH,
	},
	AssaultRifle = {
		Type = "Assault Rifle",
		NickName = "\"Assault\" Rifle",
		ClipReloadCooldown = 1,
		FireCooldown = 0.1,
		MaxClip = 30,
		MaxAmmo = 200,
		RegenPeriod = 3,
		MyScale = 1,
		TheirScale = 1,
		Mesh = Singularity.Graphics.Mesh:CreatePrimitive(3),
		Material = Singularity.Graphics.Material:CreateBasicMaterial(),
		Projectile = Projectile.MakeSingleProjectileType(	"Fist", 
														4,
														200, 
														false, 
														nil, 
														1.2, 
														fist, 
														fistMaterial,
														1),
		FireCue = "weapon_AssaultFire",
		ReloadCue = "weapon_AssaultReload",
		SwitchCue = "weapon_AssaultSwitch",
		EmptyCue = "weapon_EmptyClip",
		HitParticles = {
			MainTexture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Particles\\RedSmoke.png"),
			ParticleCount = 30,
			ParticleSize = 0.05,
			Type = Singularity.Particles.Explosion,
			Duration = 0.1,
			Radius = 0.1,
			Direction = Vector3:new(0.1, 0.1, 0.1),
		},
		FireParticles = {
			MainTexture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Particles\\Smoke.png"),
			ParticleCount = 10,
			Type = Singularity.Particles.Explosion,
			Duration, 0.05,
			Radius = 0.1,
			Direction = Vector3(0, 0.1, 0.1),
		},
		HoldType = WEAPON_HOLD_TYPE_TWO,
	},
	Shotgun = {
		Damage = 40,
		Type = "Shotgun",
		NickName = "Multi-Shot",
		ClipReloadCooldown = 2.5,
		FireCooldown = 0.75,
		MaxAmmo = 35,
		RegenPeriod = 8,
		MaxClip = 8,
		MyScale = 1,
		TheirScale = 1,
		Mesh = Singularity.Graphics.Mesh:CreatePrimitive(0),
		Material = Singularity.Graphics.Material:CreateBasicMaterial(),
		FireCue = "weapon_ShotgunFire",
		ReloadCue = "weapon_ShotgunReload",
		SwitchCue = "weapon_ShotgunSwitch",
		EmptyCue = "weapon_EmptyClip",
		HitParticles = {
			MainTexture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Particles\\RedSmoke.png"),
			ParticleCount = 30,
			ParticleSize = 0.05,
			Type = Singularity.Particles.Explosion,
			Duration = 0.1,
			Radius = 0.1,
			Direction = Vector3:new(0.1, 0.1, 0.1),
		},
		FireParticles = {
			MainTexture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Particles\\Smoke.png"),
			ParticleCount = 10,
			Type = Singularity.Particles.Explosion,
			Duration, 0.05,
			Radius = 0.1,
			Direction = Vector3(0, 0.1, 0.1),
		},
		HoldType = WEAPON_HOLD_TYPE_TWO,
	},
	Grenade = {
		Type = "Grenade",
		NickName = "Pop Can",
		MaxVelocity = 20,
		MaxVelocityHoldDuration = 2,
		ArmCockingTime = 0.5,
		ThrowTime = 0.5,
		MaxAmmo = 3,
		RegenPeriod = 10,
		ReleaseElevation = 1,
		MyScale = 1,
		TheirScale = 1,
		Mesh = Singularity.Graphics.Mesh:CreatePrimitive(1),
		Material = Singularity.Graphics.Material:CreateBasicMaterial(),
		Projectile = Projectile.MakeAoEProjectileType(	"Grenade", 
														1,
														5, 
														10, 
														true, 
														nil, 
														0.01,
														Singularity.Graphics.Mesh:CreatePrimitive(3), 
														Singularity.Graphics.Material:CreateBasicMaterial()	),
		FireCue = "weapon_GrenadeFire",
		ReloadCue = "weapon_GrenadeReload",
		SwitchCue = "weapon_GrenadeSwitch",
		EmptyCue = "weapon_EmptyClip",
	}
}

--Init Meshes and Materials
Weapon.InitMeshesAndMaterials = function()
	Weapon.StaticData.Pistol.Mesh, Weapon.StaticData.Pistol.Material = Util.GetMeshAndMaterial(Main.AssetDirectory.."Models\\Pistol.smurf")
	Weapon.StaticData.CannonGun.Mesh, Weapon.StaticData.CannonGun.Material = Util.GetMeshAndMaterial(Main.AssetDirectory.."Models\\CannonGun.smurf")
	Weapon.StaticData.SniperRifle.Mesh, Weapon.StaticData.SniperRifle.Material = Util.GetMeshAndMaterial(Main.AssetDirectory.."Models\\SniperRifle.smurf")
	Weapon.StaticData.AssaultRifle.Mesh, Weapon.StaticData.AssaultRifle.Material = Util.GetMeshAndMaterial(Main.AssetDirectory.."Models\\AssaultRifle.smurf")
	Weapon.StaticData.Grenade.Mesh, Weapon.StaticData.Grenade.Material = Util.GetMeshAndMaterial(Main.AssetDirectory.."Models\\Grenade.smurf")
	Weapon.StaticData.Shotgun.Mesh, Weapon.StaticData.Shotgun.Material = Util.GetMeshAndMaterial(Main.AssetDirectory.."Models\\Shotgun.smurf")
	Weapon.StaticData.SniperRifle.Mesh, Weapon.StaticData.SniperRifle.Material = Util.GetMeshAndMaterial(Main.AssetDirectory.."Models\\SniperRifle.smurf")
	
	Weapon.ModifierMesh, Weapon.ModifierMaterial = Util.GetMeshAndMaterial(Main.AssetDirectory.."Models\\ModifierLauncher.smurf")
end

Weapon.InitMeshesAndMaterials()

Weapon.CreateAllWeapons = function(owner, client)

	local ret = {}

	--creating projectiles for client
	if(client) then
		Util.Debug("Creating projectiles")
		Projectile.Functions.InitializeProjectiles(fist, fistMaterial)
	end
	
	--build a weapon of each type and return
	for k,v in pairs(Weapon.StaticData) do
		local wep
		if(client) then
			wep = Weapon.CreateClient(k,owner)
			wep:Reset()
		else
			wep = Weapon.Create(k,owner)
		end
		
		ret[k] = wep
	end
	
	return ret
end

Weapon.GetWeaponTypeByProjectileType = function(typeOf)
	for k,v in pairs(Weapon.StaticData) do
		if(v.Projectile and v.Projectile.Type == typeOf) then
			return k
		end
	end
end

Weapon.Functions =
{
	GetAmmo = function(weapon)
		return weapon.Ammo
	end,
}

Weapon.ClientFunctions = 
{	
	AddAmmo = function(weapon, amount)
		if(weapon.Ammo) then
			--cap at max ammo
			weapon.Ammo = math.min(weapon.Ammo + amount, Weapon.StaticData[weapon.Type].MaxAmmo)
		end
	end,
	Reset = function(weapon)
		--reset clip and ammo
		if(weapon.Ammo) then
			weapon.Ammo = Weapon.StaticData[weapon.Type].MaxAmmo
		end
		if(weapon.Clip) then
			weapon.Clip = Weapon.StaticData[weapon.Type].MaxClip
		end
	end
}

--Remote Create
Weapon.Create = function(typeOf, owner)

	local ret = Weapon.InitGeneral(typeOf, owner)
	
	--place on model
	ret.WeaponModel:Get_Transform():Translate(0.01, 0.04, 0)
	
	--scale it
	if(Weapon.StaticData[typeOf].TheirScale) then
		ret.WeaponModel:Get_Transform():Set_Scale(Vector3:new(Weapon.StaticData[typeOf].TheirScale,Weapon.StaticData[typeOf].TheirScale,Weapon.StaticData[typeOf].TheirScale))
	end

	return ret	
end

--Client Create
Weapon.CreateClient = function(typeOf, owner)

	local ret = Weapon.InitGeneral(typeOf, owner)
	ret = Util.JoinTables(ret, Util.ShallowTableCopy(Weapon.ClientFunctions))
	
	--place on model
	ret.WeaponModel:Get_Transform():Set_LocalPosition(Vector3:new(8.0,-5.0,-12.0))
	
	--scale it
	if(Weapon.StaticData[typeOf].MyScale) then
		ret.WeaponModel:Get_Transform():Set_Scale(Vector3:new(Weapon.StaticData[typeOf].MyScale,Weapon.StaticData[typeOf].MyScale,Weapon.StaticData[typeOf].MyScale))
	end

	return ret	
end

Weapon.InitGeneral = function(typeOf, owner)

	local ret = Util.JoinTables(Util.ShallowTableCopy(Weapon.DynamicData[typeOf]), Util.ShallowTableCopy(Weapon.Functions))	
	
	--make weapon model
	ret.WeaponModel = Singularity.Components.GameObject:Create(typeOf.."Weapon", owner.BodyNode)

	--if we have the mesh, add it to the model node
	if(Weapon.StaticData[typeOf].Mesh and Weapon.StaticData[typeOf].Material) then
		local comp = Singularity.Graphics.MeshRenderer:new(Weapon.StaticData[typeOf].Mesh:Clone(), Weapon.StaticData[typeOf].Material:Clone())
		comp:Set_IsTiedToCamera(true)
		ret.WeaponModel:AddComponent(comp)
		ret.WeaponModel:Set_IsActive(false)
	end
	
	--add audio cues
	if (Weapon.StaticData[typeOf].FireCue) then
		comp = Singularity.Audio.AudioManager:Instantiate():GetNewEmitter(typeOf.."Emitter")
		if(Weapon.StaticData[typeOf].FireCue) then
			comp:AddCue(Singularity.Audio.AudioManager:Instantiate():CreateCue(Weapon.StaticData[typeOf].FireCue))
		end
		if(Weapon.StaticData[typeOf].ReloadCue) then
			comp:AddCue(Singularity.Audio.AudioManager:Instantiate():CreateCue(Weapon.StaticData[typeOf].ReloadCue))
		end
		if(Weapon.StaticData[typeOf].SwitchCue) then
			comp:AddCue(Singularity.Audio.AudioManager:Instantiate():CreateCue(Weapon.StaticData[typeOf].SwitchCue))
		end
		if(Weapon.StaticData[typeOf].EmptyCue) then
			comp:AddCue(Singularity.Audio.AudioManager:Instantiate():CreateCue(Weapon.StaticData[typeOf].EmptyCue))
		end
		ret.WeaponModel:AddComponent(comp)
	end
	
	return ret

end

Weapon.GotoIdleOrNoAmmo = function()
	local curWeapon = Weapon.WeaponBehavior.CurrentWeapon
	if(curWeapon.Ammo == nil or curWeapon.Ammo > 0) then
		Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior[curWeapon.Type].Idle)
	else
		Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior.General.NoAmmo)
	end
end

Weapon.HandleNoAmmo = function()
	Util.Debug("Don't got no ammo, partner.")

	-- Get the audio emitter and play the empty clip sound.
	local wepModel = Weapon.WeaponBehavior.CurrentWeapon.WeaponModel
	local comp = tolua.cast (wepModel:GetComponent("Singularity.Audio.AudioEmitter"), "Singularity::Audio::AudioEmitter")
	comp:Play(3)
end

--Client Weapon Behavior
Weapon.WeaponBehavior =
{
	--Data
	CurrentState = nil,
	TriggerCurrentState = nil,
	FirstTime = false,
	TriggerFirstTime = false,
	CurrentWeapon = nil,
	--Functions
	GetDirection = function()
		local playerDir = Player.Camera.Component:Get_Forward()
		return playerDir
	end,
	--General
	General =
	{
		MouseDown = false,
		NoAmmo = 
		{
			Process = function (elapsed, first)
				if(first) then
					MouseDown = false
				end
				
				--goto idle if we get some ammo
				if(Weapon.WeaponBehavior.CurrentWeapon.Ammo > 0) then
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior[Weapon.WeaponBehavior.CurrentWeapon.Type].Idle)
					return
				end
				
				if(Input:GetMouseButton(LEFT)) then
					if(not MouseDown) then	
						MouseDown = true
						--do no ammo effect
						Weapon.HandleNoAmmo()
					end	
				else
					MouseDown = false
				end					
			end
		}
	},
	--Trigger
	Trigger =
	{
		FireCooldownElapsed = 0,
		Idle =
		{
			Process = function(elapsed, first)
				if(first) then
					Util.Debug("Trigger Ready")
				end
				
				if(Input:GetMouseButton(RIGHT)) then
					Weapon.WeaponBehavior.ChangeTriggerState(Weapon.WeaponBehavior.Trigger.ModifierTriggerFire)
				end
			end		
		},
		ModifierTriggerFire =
		{
			Process = function(elapsed, first)
				Util.Debug("Trigger Fire")
				local wepModel = Weapon.WeaponBehavior.CurrentWeapon.WeaponModel
				local wepPos = wepModel:Get_Transform():Get_Position()
				local playerDir = Weapon.WeaponBehavior.GetDirection()
				--fire trigger
				Projectile.DoTrigger(wepPos, playerDir)
				Weapon.WeaponBehavior.ChangeTriggerState(Weapon.WeaponBehavior.Trigger.ModifierTriggerShotDelay)
			end			
		},
		ModifierTriggerShotDelay =
		{
			Process = function(elapsed, first)
				
				if(first) then
					Util.Debug("Trigger Cooling Down")
					Weapon.WeaponBehavior.Trigger.FireCooldownElapsed = 0
				else
					Weapon.WeaponBehavior.Trigger.FireCooldownElapsed = Weapon.WeaponBehavior.Trigger.FireCooldownElapsed + elapsed
				end
				
				if(Weapon.WeaponBehavior.Trigger.FireCooldownElapsed > Weapon.StaticData.Trigger.FireCooldown) then
					Weapon.WeaponBehavior.ChangeTriggerState(Weapon.WeaponBehavior.Trigger.Idle)
				end
			end		
		}
	},
	--Pistol
	Pistol =
	{
		MaxChargeElapsed = 0,
		FireCooldownElapsed = 0,
		Idle = 
		{
			Process = function (elapsed, first)
				if(first) then
					Util.Debug("Pistol Ready")
				end
				
				if(Input:GetMouseButton(LEFT)) then				
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior.Pistol.BarrelExtend)				
				end			
			end
		},
		BarrelExtend =
		{
			Process = function(elapsed, first)
				--count charging time
				if(first) then
					Util.Debug("Pistol Barrel Extend")
					Weapon.WeaponBehavior.Pistol.MaxChargeElapsed = 0
				else
					Weapon.WeaponBehavior.Pistol.MaxChargeElapsed = Weapon.WeaponBehavior.Pistol.MaxChargeElapsed + elapsed
				end			
				
				--on button release
				if(Input:GetMouseButton(LEFT) == false) then
					--start retracting the barrel
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior.Pistol.BarrelRetract)
					return
				end
				
				--extend a flag on max charge
				if(Weapon.WeaponBehavior.Pistol.MaxChargeElapsed > Weapon.StaticData.Pistol.MaxChargeTime) then
					Util.Debug("Pistol Full Charge")
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior.Pistol.FlagExtend)
				end
			end
		},
		FlagExtend =
		{
			Process = function(elapsed, first)
				if(first) then
					Util.Debug("Pistol Flag Extend")
				end
				
				if(Input:GetMouseButton(LEFT) == false) then
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior.Pistol.FlagRetract)
				end
			end
		},
		FlagRetract = 
		{
			Process = function(elapsed, first)
				if(first) then
					Util.Debug("Pistol Flag Retract")
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior.Pistol.BarrelRetract)
				end
			end
		},
		BarrelRetract =
		{
			Process = function(elapsed, first)
				if(first) then
					Util.Debug("Pistol Barrel Retract")
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior.Pistol.Fire)
				end
			end
		},
		Fire =
		{
			Process = function(elapsed, first)
				if(first) then
					Util.Debug("Pistol Bang")
					Weapon.WeaponBehavior.CurrentWeapon.Ammo = Weapon.WeaponBehavior.CurrentWeapon.Ammo - 1
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior.Pistol.ShotDelay)
					
					local wepModel = Weapon.WeaponBehavior.CurrentWeapon.WeaponModel
					local wepPos = wepModel:Get_Transform():Get_Position()
					local playerDir = Weapon.WeaponBehavior.GetDirection()
					
					--calculate charging bonus damage
					local perc = math.min(1, Weapon.WeaponBehavior.Pistol.MaxChargeElapsed / Weapon.StaticData.Pistol.MaxChargeTime)		
					
					Projectile.DoInstantSingle(Weapon.StaticData.Pistol.Damage + perc * Weapon.StaticData.Pistol.MaxChargeDamage, wepPos, playerDir, "Pistol")
				end
			end
		},
		ShotDelay =
		{
			Process = function(elapsed, first)
				if(first) then
					Util.Debug("Pistol Cooling Down")
					Weapon.WeaponBehavior.Pistol.FireCooldownElapsed = 0
				else
					Weapon.WeaponBehavior.Pistol.FireCooldownElapsed = Weapon.WeaponBehavior.Pistol.FireCooldownElapsed + elapsed
				end
				
				if(Weapon.WeaponBehavior.Pistol.FireCooldownElapsed > Weapon.StaticData.Pistol.FireCooldown) then
					Weapon.GotoIdleOrNoAmmo()
				end
			end
		}
	},
	-- CannonGun
	CannonGun =
	{
		FireCooldownElapsed = 0,
		Idle =
		{
			Process = function(elapsed, first)
				if(first) then
					Util.Debug("Cannon Gun Ready")
				end
				
				if(Input:GetMouseButton(LEFT)) then
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior.CannonGun.Fire)
				end
			end
		},
		Fire =
		{
			Process = function(elapsed, first)
				if(first) then
					Util.Debug("Cannon Gun Bang")
					Util.Debug("Cannon Gun Character Recoil")
					Util.Debug("Cannon Gun Recoil")
				end
				
				local wepModel = Weapon.WeaponBehavior.CurrentWeapon.WeaponModel
				local wepPos = wepModel:Get_Transform():Get_Position()
				local playerDir = Weapon.WeaponBehavior.GetDirection()
				
				--spawn the cannon gun projectile
				Weapon.StaticData.CannonGun.Projectile:SpawnClient(Player.Client, wepPos, playerDir)
				
				Weapon.WeaponBehavior.CurrentWeapon.Ammo = Weapon.WeaponBehavior.CurrentWeapon.Ammo - 1
				Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior.CannonGun.ShotDelay)
				
			end
		},
		ShotDelay =
		{
			Process = function(elapsed, first)
				if(first) then
					Util.Debug("Cannon Gun Cooling Down")
					Weapon.StaticData.CannonGun.FireCooldownElapsed = 0
				else
					Weapon.StaticData.CannonGun.FireCooldownElapsed = Weapon.StaticData.CannonGun.FireCooldownElapsed + elapsed
				end
				
				if(Weapon.StaticData.CannonGun.FireCooldownElapsed > Weapon.StaticData.CannonGun.FireCooldown) then
					Weapon.GotoIdleOrNoAmmo()
				end
			end
		}
	},
	--SniperRifle
	SniperRifle =
	{
		FireCooldownElapsed = 0,
		Zoomed = false,
		ZoomKeyDown = false,
		HandleZoom = function()
			--handle zooming with the scope
			if(Input:IsKeyDown(DIK_F)) then
				ZoomKeyDown = true
			else
				if(ZoomKeyDown) then
					ZoomKeyDown = false
					--Toggle Zoom
					Weapon.WeaponBehavior.SniperRifle.Zoomed = not Weapon.WeaponBehavior.SniperRifle.Zoomed
					--Stop a progressing zoom animation if we're not complete yet
					if(Weapon.StaticData.SniperRifle.Set) then
						Tween.Tweener.Stop(Weapon.StaticData.SniperRifle.Set)
					end

					Weapon.StaticData.SniperRifle.Set = Tween.TweenSet.MakeTweenSet()
					if(Weapon.WeaponBehavior.SniperRifle.Zoomed) then
						--Show scope image
						Scope.Enable()
						--Tween FoV
						Weapon.StaticData.SniperRifle.Set:Bind(Weapon.StaticData.SniperRifle.ZoomInTween, 0, "Get_FieldOfView", "Set_FieldOfView")
						Weapon.StaticData.SniperRifle.Set:SetTarget(Player.Camera.Component)
						Tween.Tweener.Play(Weapon.StaticData.SniperRifle.Set)
					else
						--Hide scope image
						Scope.Disable()
						--Tween FoV
						Weapon.StaticData.SniperRifle.Set:Bind(Weapon.StaticData.SniperRifle.ZoomOutTween, 0, "Get_FieldOfView", "Set_FieldOfView")
						Weapon.StaticData.SniperRifle.Set:SetTarget(Player.Camera.Component)
						Tween.Tweener.Play(Weapon.StaticData.SniperRifle.Set)
					end
				end
			end
		end,
		Continuous =
		{
			Process = function(elapsed,first)
				Weapon.WeaponBehavior.SniperRifle.HandleZoom()
			end
		},
		Idle =
		{
			Process = function(elapsed, first)
				if(first) then
					Util.Debug("Sniper Rifle Ready")
				end
				
				if(Input:GetMouseButton(LEFT)) then
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior.SniperRifle.Fire)
				end
			end
		},
		Fire =
		{
			Process = function(elapsed,first)
				if(first) then
					Util.Debug("Sniper Rifle Bang")
					Util.Debug("Sniper Rifle Character Head Recoil")
				end
				
				Weapon.WeaponBehavior.CurrentWeapon.Ammo = Weapon.WeaponBehavior.CurrentWeapon.Ammo - 1
				local wepModel = Weapon.WeaponBehavior.CurrentWeapon.WeaponModel
				local wepPos = wepModel:Get_Transform():Get_Position()
				local playerDir = Weapon.WeaponBehavior.GetDirection()
				
				--Fire
				Projectile.DoInstantSingle(Weapon.StaticData.SniperRifle.Damage,wepPos, playerDir, "SniperRifle")
				Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior.SniperRifle.ShotDelay)	

			end
		},
		ShotDelay =
		{
			Process = function(elapsed,first)
				if(first) then
					Util.Debug("Sniper Rifle Cooling Down")
					Weapon.WeaponBehavior.SniperRifle.FireCooldownElapsed = 0
				else
					Weapon.WeaponBehavior.SniperRifle.FireCooldownElapsed =Weapon.WeaponBehavior.SniperRifle.FireCooldownElapsed + elapsed
				end
				
				if(Weapon.WeaponBehavior.SniperRifle.FireCooldownElapsed > Weapon.StaticData.SniperRifle.FireCooldown) then
					Weapon.GotoIdleOrNoAmmo()
				end
			end
		}
	},
	--Grenade (Not Implemented)
	Grenade =
	{
		HeldTime = 0,
		ArmCockingElapsed = 0,
		ThrowTimeElapsed = 0,
		Idle = 
		{
			Process = function(elapsed, first)
				if(first) then
					Util.Debug("Grenade Ready")
				end
				
				if(Input:GetMouseButton(LEFT)) then
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior.Grenade.CockArm)
					return
				end			
			end
		},	
		CockArm =
		{
			Process = function(elapsed, first)
				if(first) then
					Util.Debug("Grenade Cock Arm")
					Weapon.WeaponBehavior.Grenade.ArmCockingElapsed = 0
				else
					Weapon.WeaponBehavior.Grenade.ArmCockingElapsed = Weapon.WeaponBehavior.Grenade.ArmCockingElapsed + elapsed
				end
				
				if(Weapon.WeaponBehavior.Grenade.ArmCockingElapsed > Weapon.StaticData.Grenade.ArmCockingTime) then
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior.Grenade.Hold)
				end
			end
		},
		Hold =
		{
			Process = function(elapsed, first)
				if(first) then
					Util.Debug("Grenade Hold")			
				end			
				
				if(not Input:GetMouseButton(LEFT)) then
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior.Grenade.Throw)
				end
			end
		},
		Throw =
		{
			Process = function(elapsed, first)
				if(first) then
					Util.Debug("Grenade Throw")
					Weapon.WeaponBehavior.Grenade.ThrowTimeElapsed = 0
				else
					Weapon.WeaponBehavior.Grenade.ThrowTimeElapsed = Weapon.WeaponBehavior.Grenade.ThrowTimeElapsed + elapsed
				end
				
				if(Weapon.WeaponBehavior.Grenade.ThrowTimeElapsed > Weapon.StaticData.Grenade.ThrowTime) then
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior.Grenade.Fire)
				end			
			end
		},
		Fire =
		{
			Process = function(elapsed,first)
				if(first) then
					Util.Debug("Grenade Fire")
					Util.Debug("Grenade Restore Arm Position")
				end
				
				Weapon.WeaponBehavior.CurrentWeapon.Ammo = Weapon.WeaponBehavior.CurrentWeapon.Ammo - 1
				local wepModel = Weapon.WeaponBehavior.CurrentWeapon.WeaponModel
				local wepPos = wepModel:Get_Transform():Get_Position()				
				
				local playerDir = Weapon.WeaponBehavior.GetDirection()
				--Angle the throw upwards
				playerDir.y = Weapon.StaticData.Grenade.ReleaseElevation
				Weapon.StaticData.Grenade.Projectile:SpawnClient(Player.Client, wepPos, playerDir)
								
				Weapon.GotoIdleOrNoAmmo()
			end
		}
	}
}

--Generate Clip Weapon States
function Weapon.WeaponBehavior.GenerateClipWeaponStates(weaponInfo, fireFunc)
local ret =
{
	ClipReloadCooldownElapsed = 0,
	FireCooldownElapsed = 0,
	ReloadClip = function()		
		local wep = Weapon.WeaponBehavior.CurrentWeapon
		--calc space remaining in clip
		local space = weaponInfo.MaxClip - wep.Clip
		--fill clip from ammo if we can
		if(space < wep.Ammo) then
			wep.Ammo = wep.Ammo - space
			wep.Clip = weaponInfo.MaxClip
		--otw, fill as muc as we can
		else
			wep.Clip = wep.Ammo
			wep.Ammo = 0			
		end		
	end,
	Idle = 
	{
		Process = function(elapsed,first)
			if(first) then
				Util.Debug(weaponInfo.NickName.." Ready")
			end
			
			if(Input:GetMouseButton(LEFT)) then
				Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior[Weapon.WeaponBehavior.CurrentWeapon.Type].Fire)
				return
			end
			
			local staticInfo = Weapon.StaticData[Weapon.WeaponBehavior.CurrentWeapon.Type]
			local dynamicInfo = Weapon.WeaponBehavior.CurrentWeapon
			
			--reload on R if the clip isnt full
			if(Input:IsKeyDown(DIK_R) and dynamicInfo.Clip < staticInfo.MaxClip) then
				Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior[dynamicInfo.Type].ClipReload)
				return
			end
		end
	},
	Fire =
	{
		Process = function(elapsed,first)
			local wep = Weapon.WeaponBehavior.CurrentWeapon
			if(wep.Clip <= 0) then				
				Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior[Weapon.WeaponBehavior.CurrentWeapon.Type].ClipReload)
				return
			end
			
			Util.Debug(weaponInfo.NickName.." Fire")
			
			wep.Clip = wep.Clip - 1
			--call firefunc to do the damage
			fireFunc()
			Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior[Weapon.WeaponBehavior.CurrentWeapon.Type].ShotDelay)
		end
	},	
	ShotDelay =
	{
		Process = function(elapsed,first)
			if(first) then
				Util.Debug(weaponInfo.NickName.." Cooling Down")
				FireCooldownElapsed = 0
			else
				FireCooldownElapsed = FireCooldownElapsed + elapsed
			end
			
			if(FireCooldownElapsed > weaponInfo.FireCooldown) then
				if(Input:GetMouseButton(LEFT)) then
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior[Weapon.WeaponBehavior.CurrentWeapon.Type].Fire)
					return
				else
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior[Weapon.WeaponBehavior.CurrentWeapon.Type].Idle)
					return
				end
			end
		end
	},
	ClipReload =
	{
		Process = function(elapsed,first)
			local wepModel = Weapon.WeaponBehavior.CurrentWeapon.WeaponModel
			local wep = Weapon.WeaponBehavior.CurrentWeapon
			local state = Weapon.WeaponBehavior[Weapon.WeaponBehavior.CurrentWeapon.Type]
			if(first) then
				Util.Debug(weaponInfo.NickName.." Clip Reload")
				--if we have no ammo, goto no ammo
				if(wep.Ammo == 0) then
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior.General.NoAmmo)
					return
				else
					state.ClipReloadCooldownElapsed = 0
					--reload
					state.ReloadClip()
					Util.Debug("Reloadin' my audio clip")
					local comp = tolua.cast (wepModel:GetComponent("Singularity.Audio.AudioEmitter"), "Singularity::Audio::AudioEmitter")
					comp:Play(1)
				end
			else
				state.ClipReloadCooldownElapsed = state.ClipReloadCooldownElapsed + elapsed
			end
			
			--wait for a bit as the gun reloads
			if(state.ClipReloadCooldownElapsed > weaponInfo.ClipReloadCooldown) then
				if(Input:GetMouseButton(LEFT)) then
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior[Weapon.WeaponBehavior.CurrentWeapon.Type].Fire)
					return
				else
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior[Weapon.WeaponBehavior.CurrentWeapon.Type].Idle)
					return
				end
			end
		end
	}
}

return ret
end

--Make the clip weapon behaviors
Weapon.WeaponBehavior.AssaultRifleFire = function()
	local wepModel = Weapon.WeaponBehavior.CurrentWeapon.WeaponModel
	local wepPos = wepModel:Get_Transform():Get_Position()
	local playerDir = Weapon.WeaponBehavior.GetDirection()

	Weapon.StaticData.AssaultRifle.Projectile:SpawnClient(Player.Client, Vector3:new((10 * playerDir.x) + wepPos.x, (10 * playerDir.y) + wepPos.y, (10 * playerDir.z) + wepPos.z), playerDir)

end

Weapon.WeaponBehavior.ShotgunFire = function()
	local wepModel = Weapon.WeaponBehavior.CurrentWeapon.WeaponModel
	local wepPos = wepModel:Get_Transform():Get_Position()
	local playerDir = Weapon.WeaponBehavior.GetDirection()
	Projectile.DoShotgun(Weapon.StaticData.Shotgun.Damage,wepPos, playerDir, nil)	
end

Weapon.WeaponBehavior.AssaultRifle = Weapon.WeaponBehavior.GenerateClipWeaponStates(Weapon.StaticData.AssaultRifle, Weapon.WeaponBehavior.AssaultRifleFire)
Weapon.WeaponBehavior.Shotgun = Weapon.WeaponBehavior.GenerateClipWeaponStates(Weapon.StaticData.Shotgun, Weapon.WeaponBehavior.ShotgunFire)

-- Modifier Launcher Generator
function Weapon.WeaponBehavior.GenerateModifierWeapon(modifierType, modifierName)
	local wepName = modifierType.."ModifierLauncher"
	modifierName = modifierName or modifierType
	
	Weapon.StaticData[wepName] =
	{
		DoesntTrigger = true,
		Type = "Modifier Launcher",
		ModifierType = modifierType,
		NickName = modifierName,
		FireCooldown = 1,
		MyScale = 1,
		TheirScale= 1,
		Mesh = Weapon.ModifierMesh or Singularity.Graphics.Mesh:CreatePrimitive(3),
		Material = Weapon.ModifierMaterial or Singularity.Graphics.Material:CreateBasicMaterial(),		
		FireCue = "modifier_Deploy",
		ReloadCue = "weapon_PistolReload",
		SwitchCue = "weapon_PistolSwitch",
		EmptyCue = "weapon_EmptyClip",
		HoldType = WEAPON_HOLD_TYPE_ONE,
	}
	
	Weapon.DynamicData[wepName] =
	{
		Type = wepName
	}
	
	Weapon.WeaponBehavior[wepName] =
	{
		Idle =
		{
			Process = function(elapsed, first)
				if(first) then
					Util.Debug(modifierType.." Ready")
				end
				
				--Spawn on Left
				if(Input:GetMouseButton(LEFT)) then
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior[Weapon.WeaponBehavior.CurrentWeapon.Type].Fire)
					return
				end
				
				--Destroy on Right
				if(Input:GetMouseButton(RIGHT)) then
					Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior[Weapon.WeaponBehavior.CurrentWeapon.Type].Destroy)
				end
			end
		},
		Fire =
		{
			Process = function(elapsed,first)
				if(first) then
					Util.Debug(modifierType.." Launch")
				end
				
				local wep = Weapon.WeaponBehavior.CurrentWeapon
				local wepInfo = Weapon.StaticData[wep.Type]
				local wepModel = wep.WeaponModel
				local wepPos = wepModel:Get_Transform():Get_Position()
				local playerDir = Weapon.WeaponBehavior.GetDirection()
				
				--Make a modifier
				Projectile.DoSpawnModifier(wepPos, playerDir, Weapon.StaticData[Weapon.WeaponBehavior.CurrentWeapon.Type].ModifierType)
				
				--Play sound locally (since modifier shots arent shown on the network)
				local comp = tolua.cast (wepModel:GetComponent("Singularity.Audio.AudioEmitter"), "Singularity::Audio::AudioEmitter")
				comp:Play(0)
				
				Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior[Weapon.WeaponBehavior.CurrentWeapon.Type].ShotDelay)
			end
		},
		Destroy =
		{
			Process = function(elapsed,first)
				if(first) then
					Util.Debug("Modifier Destroy")
				end
				
				local wep = Weapon.WeaponBehavior.CurrentWeapon
				local wepInfo = Weapon.StaticData[wep.Type]
				local wepModel = wep.WeaponModel
				local wepPos = wepModel:Get_Transform():Get_Position()
				local playerDir = Weapon.WeaponBehavior.GetDirection()
				
				--Destroy the modifier
				Projectile.DoDestroyModifier(wepPos, playerDir)
				
				Weapon.WeaponBehavior.ChangeState(Weapon.WeaponBehavior[Weapon.WeaponBehavior.CurrentWeapon.Type].ShotDelay)
			end
		},
		ShotDelay =
		{
			Process = function(elapsed,first)
				local state = Weapon.WeaponBehavior.CurrentState
				if(first) then
					Util.Debug(modifierType.." Cooling Down")
					state.FireCooldownElapsed = 0
				else
					state.FireCooldownElapsed = state.FireCooldownElapsed + elapsed
				end
				
				if(state.FireCooldownElapsed > Weapon.StaticData[Weapon.WeaponBehavior.CurrentWeapon.Type].FireCooldown) then
					Weapon.GotoIdleOrNoAmmo()
				end
			end
		}
	}
end

--Specific Launchers
Weapon.WeaponBehavior.GenerateModifierWeapon("Shrink")
Weapon.WeaponBehavior.GenerateModifierWeapon("Grow")
Weapon.WeaponBehavior.GenerateModifierWeapon("InvertGravity", "Invert Gravity")
Weapon.WeaponBehavior.GenerateModifierWeapon("Knockback")
Weapon.WeaponBehavior.GenerateModifierWeapon("Frictionless")
Weapon.WeaponBehavior.GenerateModifierWeapon("Wall")
Weapon.WeaponBehavior.GenerateModifierWeapon("Illusion")
Weapon.WeaponBehavior.GenerateModifierWeapon("IncreaseGravity","Increase Gravity")

-- General State functions
Weapon.WeaponBehavior.ChangeState = function(state)
	Weapon.WeaponBehavior.CurrentState = state
	Weapon.WeaponBehavior.FirstTime = true
end

Weapon.WeaponBehavior.ChangeTriggerState = function(state)
	Weapon.WeaponBehavior.TriggerCurrentState = state
	Weapon.WeaponBehavior.TriggerFirstTime = true
end

Weapon.Enable = function()
	Weapon.Enabled = true
	Weapon.WeaponBehavior.ChangeTriggerState(Weapon.WeaponBehavior.Trigger.Idle)
end

Weapon.Disable = function()
	Weapon.Enabled = false
end

--Main weapon update loop
Weapon.Update = function(elapsed)
	if(Weapon.Enabled) then
		local curWeapon = Player.Client:CurrentWeapon()
		
		--weapon was changed
		if(Weapon.WeaponBehavior.CurrentWeapon ~= curWeapon) then
			if(Weapon.WeaponBehavior.CurrentWeapon) then
				--Have to zoom out of the sniper before we can change
				if(Weapon.WeaponBehavior.CurrentWeapon.Type == "SniperRifle" and Weapon.WeaponBehavior.SniperRifle.Zoomed) then
					--Zoom Out
					if(Weapon.StaticData.SniperRifle.Set) then
						Tween.Tweener.Stop(Weapon.StaticData.SniperRifle.Set)
					end
					Weapon.WeaponBehavior.SniperRifle.Zoomed = false
					Weapon.StaticData.SniperRifle.Set = Tween.TweenSet.MakeTweenSet()				
					Scope.Disable()
					Weapon.StaticData.SniperRifle.Set:Bind(Weapon.StaticData.SniperRifle.ZoomOutTween, 0, "Get_FieldOfView", "Set_FieldOfView")
					Weapon.StaticData.SniperRifle.Set:SetTarget(Player.Camera.Component)
					Tween.Tweener.Play(Weapon.StaticData.SniperRifle.Set)					
				end				
			end
			Weapon.WeaponBehavior.CurrentWeapon = curWeapon
			Weapon.GotoIdleOrNoAmmo()
		end
		
		--handle weapon behavior
		if(Weapon.WeaponBehavior.CurrentState ~= nil) then
			if(Weapon.WeaponBehavior.FirstTime) then
				Weapon.WeaponBehavior.FirstTime = false
				if(Weapon.WeaponBehavior[curWeapon.Type].Continuous ~= nil) then
					Weapon.WeaponBehavior[curWeapon.Type].Continuous.Process(elapsed,true)
				end
				Weapon.WeaponBehavior.CurrentState.Process(elapsed,true)			
			else
				if(Weapon.WeaponBehavior[curWeapon.Type].Continuous ~= nil) then
					Weapon.WeaponBehavior[curWeapon.Type].Continuous.Process(elapsed)
				end
				Weapon.WeaponBehavior.CurrentState.Process(elapsed)	
			end	
		end
		
		--handle trigger laser behavior
		if(Weapon.WeaponBehavior.TriggerCurrentState ~= nil and (curWeapon == nil or (not Weapon.StaticData[curWeapon.Type].DoesntTrigger))) then
			if(Weapon.WeaponBehavior.TriggerFirstTime) then
				Weapon.WeaponBehavior.TriggerFirstTime = false
				Weapon.WeaponBehavior.TriggerCurrentState.Process(elapsed,true)
			else
				Weapon.WeaponBehavior.TriggerCurrentState.Process(elapsed)
			end
		end
	end
end

Util.Debug("Weapon Loaded.")