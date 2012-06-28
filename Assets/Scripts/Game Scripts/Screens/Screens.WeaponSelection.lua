MAX_RESOURCES = 3

Screens.WeaponSelection = {}

Screens.WeaponSelection.AvailableResources = MAX_RESOURCES
Screens.WeaponSelection.Window = nil

--Screen weapon objects
--Nullifier Gun
Screens.WeaponSelection.NullifierGun = { }
Screens.WeaponSelection.NullifierGun.Control = nil
Screens.WeaponSelection.NullifierGun.Selected = false
Screens.WeaponSelection.NullifierGun.RegularNinepatch = nil
Screens.WeaponSelection.NullifierGun.SelectedNinepatch = nil
Screens.WeaponSelection.NullifierGun.SelectedContainer = 0
Screens.WeaponSelection.NullifierGun.Resource = 1

--Pistol
Screens.WeaponSelection.Pistol = { }
Screens.WeaponSelection.Pistol.Control = nil
Screens.WeaponSelection.Pistol.Selected = false
Screens.WeaponSelection.Pistol.RegularNinepatch = nil
Screens.WeaponSelection.Pistol.SelectedNinepatch = nil
Screens.WeaponSelection.Pistol.WideNinepatch = nil
Screens.WeaponSelection.Pistol.SelectedContainer = 0
Screens.WeaponSelection.Pistol.Resource = 1

--Shotgun
Screens.WeaponSelection.Shotgun = { }
Screens.WeaponSelection.Shotgun.Control = nil
Screens.WeaponSelection.Shotgun.Selected = false
Screens.WeaponSelection.Shotgun.RegularNinepatch = nil
Screens.WeaponSelection.Shotgun.SelectedNinepatch = nil
Screens.WeaponSelection.Shotgun.WideNinepatch = nil
Screens.WeaponSelection.Shotgun.SelectedContainer = 0
Screens.WeaponSelection.Shotgun.Resource = 1

--Assault Rifle
Screens.WeaponSelection.AssaultRifle = { }
Screens.WeaponSelection.AssaultRifle.Control = nil
Screens.WeaponSelection.AssaultRifle.Selected = false
Screens.WeaponSelection.AssaultRifle.RegularNinepatch = nil
Screens.WeaponSelection.AssaultRifle.SelectedNinepatch = nil
Screens.WeaponSelection.AssaultRifle.WideNinepatch = nil
Screens.WeaponSelection.AssaultRifle.SelectedContainer = 0
Screens.WeaponSelection.AssaultRifle.Resource = 1

--Sniper Rifle
Screens.WeaponSelection.SniperRifle = { }
Screens.WeaponSelection.SniperRifle.Control = nil
Screens.WeaponSelection.SniperRifle.Selected = false
Screens.WeaponSelection.SniperRifle.RegularNinepatch = nil
Screens.WeaponSelection.SniperRifle.SelectedNinepatch = nil
Screens.WeaponSelection.SniperRifle.WideNinepatch = nil
Screens.WeaponSelection.SniperRifle.SelectedContainer = 0
Screens.WeaponSelection.SniperRifle.Resource = 2

--Cannon Gun
Screens.WeaponSelection.Cannon = { }
Screens.WeaponSelection.Cannon.Control = nil
Screens.WeaponSelection.Cannon.Selected = false
Screens.WeaponSelection.Cannon.RegularNinepatch = nil
Screens.WeaponSelection.Cannon.SelectedNinepatch = nil
Screens.WeaponSelection.Cannon.WideNinepatch = nil
Screens.WeaponSelection.Cannon.SelectedContainer = 0
Screens.WeaponSelection.Cannon.Resource = 2

--Current Weapon Containers
Screens.WeaponSelection.WeapContainer1 = { }
Screens.WeaponSelection.WeapContainer1.Control = nil
Screens.WeaponSelection.WeapContainer1.Value = 0

Screens.WeaponSelection.WeapContainer2 = { }
Screens.WeaponSelection.WeapContainer2.Control = nil
Screens.WeaponSelection.WeapContainer2.Value = 0

Screens.WeaponSelection.WeapContainer3 = { }
Screens.WeaponSelection.WeapContainer3.Control = nil
Screens.WeaponSelection.WeapContainer3.Value = 0

--Resource Controls
Screens.WeaponSelection.ResourceRegNinepatch = nil
Screens.WeaponSelection.ResourceTakenNinepatch = nil

Screens.WeaponSelection.Resource1 = { }
Screens.WeaponSelection.Resource1.Control = nil
Screens.WeaponSelection.Resource1.IsTaken = false

Screens.WeaponSelection.Resource2 = { }
Screens.WeaponSelection.Resource2.Control = nil
Screens.WeaponSelection.Resource2.IsTaken = false

Screens.WeaponSelection.Resource3 = { }
Screens.WeaponSelection.Resource3.Control = nil
Screens.WeaponSelection.Resource3.IsTaken = false

local WeaponLookup = { 
	[1] = "NullifierGun",
	[2] = "Pistol",
	[3] = "Shotgun",
	[4] = "AssaultRifle",
	[5] = "SniperRifle",
	[6] = "CannonGun",
}

Screens.WeaponSelection.Initialize = function()

	width, height = Singularity.Graphics.Screen:GetResolution(0, 0)

	--Loading all the ninepatches first
	--Regular Ninepatches
	nullifierIcon = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Weapon Icons\\NullifierGun.png")
	Screens.WeaponSelection.NullifierGun.RegularNinepatch = Singularity.Gui.NinePatch:new(nullifierIcon, Vector2:new(nullifierIcon:Get_Width(), nullifierIcon:Get_Height()), Vector4:new(0, 0, 0, 0))

	pistolIcon = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Weapon Icons\\Pistol.png")
	Screens.WeaponSelection.Pistol.RegularNinepatch = Singularity.Gui.NinePatch:new(pistolIcon, Vector2:new(pistolIcon:Get_Width(), pistolIcon:Get_Height()), Vector4:new(0, 0, 0, 0))

	shotgunIcon = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Weapon Icons\\Shotgun.png")
	Screens.WeaponSelection.Shotgun.RegularNinepatch = Singularity.Gui.NinePatch:new(shotgunIcon, Vector2:new(shotgunIcon:Get_Width(), shotgunIcon:Get_Height()), Vector4:new(0, 0, 0, 0))

	assaultRifleIcon = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Weapon Icons\\AssaultRifle.png")
	Screens.WeaponSelection.AssaultRifle.RegularNinepatch = Singularity.Gui.NinePatch:new(assaultRifleIcon, Vector2:new(assaultRifleIcon:Get_Width(), assaultRifleIcon:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	sniperRifleIcon = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Weapon Icons\\SniperRifle.png")
	Screens.WeaponSelection.SniperRifle.RegularNinepatch = Singularity.Gui.NinePatch:new(sniperRifleIcon, Vector2:new(sniperRifleIcon:Get_Width(), sniperRifleIcon:Get_Height()), Vector4:new(0, 0, 0, 0))

	cannonIcon = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Weapon Icons\\CannonGun.png")
	Screens.WeaponSelection.Cannon.RegularNinepatch = Singularity.Gui.NinePatch:new(cannonIcon, Vector2:new(cannonIcon:Get_Width(), cannonIcon:Get_Height()), Vector4:new(0, 0, 0, 0))

	--Selected Ninepatches
	nullifierIconSelected = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Weapon Icons\\NullifierGunIconSelected.png")
	Screens.WeaponSelection.NullifierGun.SelectedNinepatch = Singularity.Gui.NinePatch:new(nullifierIconSelected, Vector2:new(nullifierIconSelected:Get_Width(), nullifierIconSelected:Get_Height()), Vector4:new(0, 0, 0, 0))

	pistolIconSelected = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Weapon Icons\\PistolIconSelected.png")
	Screens.WeaponSelection.Pistol.SelectedNinepatch = Singularity.Gui.NinePatch:new(pistolIconSelected, Vector2:new(pistolIconSelected:Get_Width(), pistolIconSelected:Get_Height()), Vector4:new(0, 0, 0, 0))

	shotgunIconSelected = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Weapon Icons\\ShotgunIconSelected.png")
	Screens.WeaponSelection.Shotgun.SelectedNinepatch = Singularity.Gui.NinePatch:new(shotgunIconSelected, Vector2:new(shotgunIconSelected:Get_Width(), shotgunIconSelected:Get_Height()), Vector4:new(0, 0, 0, 0))

	assaultRifleIconSelected = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Weapon Icons\\AssaultRifleIconSelected.png")
	Screens.WeaponSelection.AssaultRifle.SelectedNinepatch = Singularity.Gui.NinePatch:new(assaultRifleIconSelected, Vector2:new(assaultRifleIconSelected:Get_Width(), assaultRifleIconSelected:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	sniperRifleIconSelected = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Weapon Icons\\SniperRifleIconSelected.png")
	Screens.WeaponSelection.SniperRifle.SelectedNinepatch = Singularity.Gui.NinePatch:new(sniperRifleIconSelected, Vector2:new(sniperRifleIconSelected:Get_Width(), sniperRifleIconSelected:Get_Height()), Vector4:new(0, 0, 0, 0))

	cannonIconSelected = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Weapon Icons\\CannonIconSelected.png")
	Screens.WeaponSelection.Cannon.SelectedNinepatch = Singularity.Gui.NinePatch:new(cannonIconSelected, Vector2:new(cannonIconSelected:Get_Width(), cannonIconSelected:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	--Wide Ninepatches
	pistolWide = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Weapon Icons\\PistolWide.png")
	Screens.WeaponSelection.Pistol.WideNinepatch = Singularity.Gui.NinePatch:new(pistolWide, Vector2:new(pistolWide:Get_Width(), pistolWide:Get_Height()), Vector4:new(0, 0, 0, 0))

	shotgunWide = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Weapon Icons\\ShotgunWide.png")
	Screens.WeaponSelection.Shotgun.WideNinepatch = Singularity.Gui.NinePatch:new(shotgunWide, Vector2:new(shotgunWide:Get_Width(), shotgunWide:Get_Height()), Vector4:new(0, 0, 0, 0))

	assaultRifleWide = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Weapon Icons\\AssaultRifleWide.png")
	Screens.WeaponSelection.AssaultRifle.WideNinepatch = Singularity.Gui.NinePatch:new(assaultRifleWide, Vector2:new(assaultRifleWide:Get_Width(), assaultRifleWide:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	sniperRifleWide = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Weapon Icons\\SniperRifleWide.png")
	Screens.WeaponSelection.SniperRifle.WideNinepatch = Singularity.Gui.NinePatch:new(sniperRifleWide, Vector2:new(sniperRifleWide:Get_Width(), sniperRifleWide:Get_Height()), Vector4:new(0, 0, 0, 0))

	cannonWide = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Weapon Icons\\CannonGunWide.png")
	Screens.WeaponSelection.Cannon.WideNinepatch = Singularity.Gui.NinePatch:new(cannonWide, Vector2:new(cannonWide:Get_Width(), cannonWide:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	--Resource Ninepatchs
	resourceIcon = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\ResourcePH.png")
	Screens.WeaponSelection.ResourceRegNinepatch = Singularity.Gui.NinePatch:new(resourceIcon, Vector2:new(resourceIcon:Get_Width(), resourceIcon:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	resourceTakenIcon = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\ResourceTakenPH.png")
	Screens.WeaponSelection.ResourceTakenNinepatch = Singularity.Gui.NinePatch:new(resourceTakenIcon, Vector2:new(resourceTakenIcon:Get_Width(), resourceTakenIcon:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	--Initializing the team intro panel
	windowBackground = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\WindowBackgroundWide.png")
	ninepatch = Singularity.Gui.NinePatch:new(windowBackground, Vector2:new(windowBackground:Get_Width(), windowBackground:Get_Height()), Vector4:new(0, 0, 0, 0))

	Screens.WeaponSelection.Window = Singularity.Gui.Window:new("Weapon Selection Window")
	Screens.WeaponSelection.Window:Set_Texture(ninepatch)
	Screens.WeaponSelection.Window:Set_Size(Vector2:new(width, height))
	Screens.WeaponSelection.Window:Set_Position(Vector2:new(0, 0))
	Screens.WeaponSelection.Window:Set_Draggable(false)
	Screens.WeaponSelection.Window:Set_Enabled(false)
	Screens.WeaponSelection.Window:Set_Visible(false)
	Player.HUD.GuiScreen:AddWindow(Screens.WeaponSelection.Window)

	--Initializing the Weapon buttons
	--Nullifier Gun
	Screens.WeaponSelection.NullifierGun.Control = Singularity.Gui.Button:new("Nullifier Gun Button", "")
	Screens.WeaponSelection.NullifierGun.Control:Set_Texture(Screens.WeaponSelection.NullifierGun.RegularNinepatch)
	Screens.WeaponSelection.NullifierGun.Control:Set_Size(Vector2:new(Screens.WeaponSelection.NullifierGun.RegularNinepatch:Get_Width() * 0.4, Screens.WeaponSelection.NullifierGun.RegularNinepatch:Get_Height() * 0.35))
	Screens.WeaponSelection.NullifierGun.Control:Set_Position(Vector2:new(Screens.WeaponSelection.Window:Get_Size().x * 0.08, Screens.WeaponSelection.Window:Get_Size().y * 0.02))
	Screens.WeaponSelection.NullifierGun.Control.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.WeaponSelection.NullifierGunClick), "Singularity::IDelegate"))
	Screens.WeaponSelection.NullifierGun.SelectedContainer = 0
	--Screens.WeaponSelection.Window:AddControl(Screens.WeaponSelection.NullifierGun.Control)

	--Pistol
	Screens.WeaponSelection.Pistol.Control = Singularity.Gui.Button:new("Pistol Button", "")
	Screens.WeaponSelection.Pistol.Control:Set_Texture(Screens.WeaponSelection.Pistol.RegularNinepatch)
	Screens.WeaponSelection.Pistol.Control:Set_Size(Vector2:new(Screens.WeaponSelection.Pistol.RegularNinepatch:Get_Width() * 0.4, Screens.WeaponSelection.Pistol.RegularNinepatch:Get_Height() * 0.35))
	Screens.WeaponSelection.Pistol.Control:Set_Position(Vector2:new(Screens.WeaponSelection.Window:Get_Size().x * 0.1, Screens.WeaponSelection.Window:Get_Size().y * 0.02))
	Screens.WeaponSelection.Pistol.Control.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.WeaponSelection.PistolClick), "Singularity::IDelegate"))
	Screens.WeaponSelection.Pistol.SelectedContainer = 0
	Screens.WeaponSelection.Window:AddControl(Screens.WeaponSelection.Pistol.Control)

	--Shotgun
	Screens.WeaponSelection.Shotgun.Control = Singularity.Gui.Button:new("Shotgun Button", "")
	Screens.WeaponSelection.Shotgun.Control:Set_Texture(Screens.WeaponSelection.Shotgun.RegularNinepatch)
	Screens.WeaponSelection.Shotgun.Control:Set_Size(Vector2:new(Screens.WeaponSelection.Shotgun.RegularNinepatch:Get_Width() * 0.4, Screens.WeaponSelection.Shotgun.RegularNinepatch:Get_Height() * 0.35))
	Screens.WeaponSelection.Shotgun.Control:Set_Position(Vector2:new(Screens.WeaponSelection.Window:Get_Size().x * 0.12 + (Screens.WeaponSelection.Shotgun.Control:Get_Size().x ), Screens.WeaponSelection.Window:Get_Size().y * 0.02))
	Screens.WeaponSelection.Shotgun.Control.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.WeaponSelection.ShotgunClick), "Singularity::IDelegate"))
	Screens.WeaponSelection.Shotgun.SelectedContainer = 0
	Screens.WeaponSelection.Window:AddControl(Screens.WeaponSelection.Shotgun.Control)
		
	--Assault Rifle
	Screens.WeaponSelection.AssaultRifle.Control = Singularity.Gui.Button:new("Assault Rifle Button", "")
	Screens.WeaponSelection.AssaultRifle.Control:Set_Texture(Screens.WeaponSelection.AssaultRifle.RegularNinepatch)
	Screens.WeaponSelection.AssaultRifle.Control:Set_Size(Vector2:new(Screens.WeaponSelection.AssaultRifle.RegularNinepatch:Get_Width() * 0.4, Screens.WeaponSelection.AssaultRifle.RegularNinepatch:Get_Height() * 0.35))
	Screens.WeaponSelection.AssaultRifle.Control:Set_Position(Vector2:new(Screens.WeaponSelection.Window:Get_Size().x * 0.14 + (Screens.WeaponSelection.AssaultRifle.Control:Get_Size().x * 2), Screens.WeaponSelection.Window:Get_Size().y * 0.02))
	Screens.WeaponSelection.AssaultRifle.Control.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.WeaponSelection.AssaultRifleClick), "Singularity::IDelegate"))
	Screens.WeaponSelection.AssaultRifle.SelectedContainer = 0
	Screens.WeaponSelection.Window:AddControl(Screens.WeaponSelection.AssaultRifle.Control)

	--Sniper Rifle
	Screens.WeaponSelection.SniperRifle.Control = Singularity.Gui.Button:new("Sniper Rifle Button", "")
	Screens.WeaponSelection.SniperRifle.Control:Set_Texture(Screens.WeaponSelection.SniperRifle.RegularNinepatch)
	Screens.WeaponSelection.SniperRifle.Control:Set_Size(Vector2:new(Screens.WeaponSelection.SniperRifle.RegularNinepatch:Get_Width() * 0.4, Screens.WeaponSelection.SniperRifle.RegularNinepatch:Get_Height() * 0.35))
	Screens.WeaponSelection.SniperRifle.Control:Set_Position(Vector2:new(Screens.WeaponSelection.Window:Get_Size().x * 0.16 + (Screens.WeaponSelection.SniperRifle.Control:Get_Size().x * 3), Screens.WeaponSelection.Window:Get_Size().y * 0.02))
	Screens.WeaponSelection.SniperRifle.Control.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.WeaponSelection.SniperRifleClick), "Singularity::IDelegate"))
	Screens.WeaponSelection.SniperRifle.SelectedContainer = 0
	Screens.WeaponSelection.Window:AddControl(Screens.WeaponSelection.SniperRifle.Control)

	--Cannon
	Screens.WeaponSelection.Cannon.Control = Singularity.Gui.Button:new("Hand Cannon Button", "")
	Screens.WeaponSelection.Cannon.Control:Set_Texture(Screens.WeaponSelection.Cannon.RegularNinepatch)
	Screens.WeaponSelection.Cannon.Control:Set_Size(Vector2:new(Screens.WeaponSelection.Cannon.RegularNinepatch:Get_Width() * 0.4, Screens.WeaponSelection.Cannon.RegularNinepatch:Get_Height() * 0.35))
	Screens.WeaponSelection.Cannon.Control:Set_Position(Vector2:new(Screens.WeaponSelection.Window:Get_Size().x * 0.18 + (Screens.WeaponSelection.Cannon.Control:Get_Size().x * 4), Screens.WeaponSelection.Window:Get_Size().y * 0.02))
	Screens.WeaponSelection.Cannon.Control.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.WeaponSelection.CannonClick), "Singularity::IDelegate"))
	Screens.WeaponSelection.Cannon.SelectedContainer = 0
	Screens.WeaponSelection.Window:AddControl(Screens.WeaponSelection.Cannon.Control)

	--Resource Point allocation
	label = Singularity.Gui.Label:new("Resources Label", "Weapon Combination Points")
	label:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic24 Bold"))
	label:Set_Position(Vector2:new(Screens.WeaponSelection.Window:Get_Size().x / 2 - (Singularity.Gui.Font:GetStringWidth(label:Get_Font(), label:Get_Text()) / 2), Screens.WeaponSelection.Window:Get_Size().y * 0.25))
	label:Set_Size(Vector2:new(Singularity.Gui.Font:GetStringWidth(label:Get_Font(), label:Get_Text()), 30))
	Screens.WeaponSelection.Window:AddControl(label)
	

	--Container Image
	texture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\TextboxBackground.png")
	ninepatch = Singularity.Gui.NinePatch(texture, Vector2:new(texture:Get_Width(), texture:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	image = Singularity.Gui.Image:new("Resources Container")
	image:Set_Texture(ninepatch)
	image:Set_Size(Vector2:new(ninepatch:Get_Width() * 0.20, ninepatch:Get_Height() * 0.35))
	image:Set_Position(Vector2:new(Screens.WeaponSelection.Window:Get_Size().x / 2 - (image:Get_Size().x / 2), Screens.WeaponSelection.Window:Get_Size().y * 0.3))
	--added below

	--Resource Icons
	
	Screens.WeaponSelection.Resource1.Control = Singularity.Gui.Image:new("Weapon Resource 1")
	Screens.WeaponSelection.Resource1.Control:Set_Texture(Screens.WeaponSelection.ResourceRegNinepatch)
	Screens.WeaponSelection.Resource1.Control:Set_Size(Vector2:new(Screens.WeaponSelection.ResourceRegNinepatch:Get_Width() * 0.3, Screens.WeaponSelection.ResourceRegNinepatch:Get_Width() * 0.3))
	Screens.WeaponSelection.Resource1.Control:Set_Position(Vector2:new(image:Get_Position().x + (image:Get_Size().x * 0.25) - (Screens.WeaponSelection.Resource1.Control:Get_Size().x / 2), image:Get_Position().y + ((image:Get_Size().y / 2) - (Screens.WeaponSelection.Resource1.Control:Get_Size().y / 2))))
	Screens.WeaponSelection.Resource1.IsTaken = false
	Screens.WeaponSelection.Window:AddControl(Screens.WeaponSelection.Resource1.Control)

	Screens.WeaponSelection.Resource2.Control = Singularity.Gui.Image:new("Weapon Resource 1")
	Screens.WeaponSelection.Resource2.Control:Set_Texture(Screens.WeaponSelection.ResourceRegNinepatch)
	Screens.WeaponSelection.Resource2.Control:Set_Size(Vector2:new(Screens.WeaponSelection.ResourceRegNinepatch:Get_Width() * 0.3, Screens.WeaponSelection.ResourceRegNinepatch:Get_Width() * 0.3))
	Screens.WeaponSelection.Resource2.Control:Set_Position(Vector2:new(image:Get_Position().x + (image:Get_Size().x * 0.5) - (Screens.WeaponSelection.Resource2.Control:Get_Size().x / 2), image:Get_Position().y + ((image:Get_Size().y / 2) - (Screens.WeaponSelection.Resource2.Control:Get_Size().y / 2))))
	Screens.WeaponSelection.Resource2.IsTaken = false
	Screens.WeaponSelection.Window:AddControl(Screens.WeaponSelection.Resource2.Control)
	
	Screens.WeaponSelection.Resource3.Control = Singularity.Gui.Image:new("Weapon Resource 1")
	Screens.WeaponSelection.Resource3.Control:Set_Texture(Screens.WeaponSelection.ResourceRegNinepatch)
	Screens.WeaponSelection.Resource3.Control:Set_Size(Vector2:new(Screens.WeaponSelection.ResourceRegNinepatch:Get_Width() * 0.3, Screens.WeaponSelection.ResourceRegNinepatch:Get_Width() * 0.3))
	Screens.WeaponSelection.Resource3.Control:Set_Position(Vector2:new(image:Get_Position().x + (image:Get_Size().x * 0.75) - (Screens.WeaponSelection.Resource3.Control:Get_Size().x / 2), image:Get_Position().y + ((image:Get_Size().y / 2) - (Screens.WeaponSelection.Resource3.Control:Get_Size().y / 2))))
	Screens.WeaponSelection.Resource3.IsTaken = false
	Screens.WeaponSelection.Window:AddControl(Screens.WeaponSelection.Resource3.Control)
	
	--container image add
	Screens.WeaponSelection.Window:AddControl(image)

	--"Current Weapon Combination" Label
	label = Singularity.Gui.Label:new("Weapon Combination Label", "Current Weapon Combination")
	label:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic24 Bold"))
	label:Set_Position(Vector2:new(Screens.WeaponSelection.Window:Get_Size().x / 2 - (Singularity.Gui.Font:GetStringWidth(label:Get_Font(), label:Get_Text()) / 2), Screens.WeaponSelection.Window:Get_Size().y * 0.40))
	label:Set_Size(Vector2:new(Singularity.Gui.Font:GetStringWidth(label:Get_Font(), label:Get_Text()), 30))
	Screens.WeaponSelection.Window:AddControl(label)

		
	--Current Weapon Slot images
	blankLoadout = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\WeaponCombinationPH.png")
	Screens.WeaponSelection.BlankLoadoutNP = Singularity.Gui.NinePatch:new(blankLoadout, Vector2:new(blankLoadout:Get_Width(), blankLoadout:Get_Height()), Vector4:new(0, 0, 0, 0))

	blankTakenLoadout = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\WeaponCombinationTakenPH.png")
	Screens.WeaponSelection.BlankTakenLoadoutNP = Singularity.Gui.NinePatch:new(blankTakenLoadout, Vector2:new(blankTakenLoadout:Get_Width(), blankTakenLoadout:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	Screens.WeaponSelection.WeapContainer1.Control = Singularity.Gui.Image:new("Weapon Container 1")
	Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
	Screens.WeaponSelection.WeapContainer1.Control:Set_Size(Vector2:new(Screens.WeaponSelection.BlankLoadoutNP:Get_Width() * 0.5, Screens.WeaponSelection.BlankLoadoutNP:Get_Height() * 0.35))
	Screens.WeaponSelection.WeapContainer1.Control:Set_Position(Vector2:new((Screens.WeaponSelection.Window:Get_Size().x * 0.22) + (0 * (Screens.WeaponSelection.WeapContainer1.Control:Get_Size().x + 20.0)), Screens.WeaponSelection.Window:Get_Size().y * 0.45))
	Screens.WeaponSelection.WeapContainer1.SelectedValue = 0
	Screens.WeaponSelection.Window:AddControl(Screens.WeaponSelection.WeapContainer1.Control)

	Screens.WeaponSelection.WeapContainer2.Control = Singularity.Gui.Image:new("Weapon Container 2")
	Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
	Screens.WeaponSelection.WeapContainer2.Control:Set_Size(Vector2:new(Screens.WeaponSelection.BlankLoadoutNP:Get_Width() * 0.5, Screens.WeaponSelection.BlankLoadoutNP:Get_Height() * 0.35))
	Screens.WeaponSelection.WeapContainer2.Control:Set_Position(Vector2:new((Screens.WeaponSelection.Window:Get_Size().x * 0.22) + (1 * (Screens.WeaponSelection.WeapContainer2.Control:Get_Size().x + 20.0)), Screens.WeaponSelection.Window:Get_Size().y * 0.45))
	Screens.WeaponSelection.WeapContainer2.SelectedValue = 0
	Screens.WeaponSelection.Window:AddControl(Screens.WeaponSelection.WeapContainer2.Control)
	
	Screens.WeaponSelection.WeapContainer3.Control = Singularity.Gui.Image:new("Weapon Container 3")
	Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
	Screens.WeaponSelection.WeapContainer3.Control:Set_Size(Vector2:new(Screens.WeaponSelection.BlankLoadoutNP:Get_Width() * 0.5, Screens.WeaponSelection.BlankLoadoutNP:Get_Height() * 0.35))
	Screens.WeaponSelection.WeapContainer3.Control:Set_Position(Vector2:new((Screens.WeaponSelection.Window:Get_Size().x * 0.22) + (2 * (Screens.WeaponSelection.WeapContainer3.Control:Get_Size().x + 20.0)), Screens.WeaponSelection.Window:Get_Size().y * 0.45))
	Screens.WeaponSelection.WeapContainer3.SelectedValue = 0
	Screens.WeaponSelection.Window:AddControl(Screens.WeaponSelection.WeapContainer3.Control)

	--Switching Selection screen buttons
	weaponSelection = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\WeaponSwitchButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(weaponSelection, Vector2:new(weaponSelection:Get_Width(), weaponSelection:Get_Height()), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Modifier Selection Button", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(ninepatch:Get_Width() * 0.3, ninepatch:Get_Height() * 0.3))
	button:Set_Position(Vector2:new(Screens.WeaponSelection.Window:Get_Size().x * 0.05, Screens.WeaponSelection.Window:Get_Size().y * 0.80))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.WeaponSelection.Switch), "Singularity::IDelegate"))
	Screens.WeaponSelection.Window:AddControl(button)

	--Reset Button
	resetButton = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\ResetButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(resetButton, Vector2:new(resetButton:Get_Width(), resetButton:Get_Height()), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Reset Button - Weapon Selection", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(139,59))
	button:Set_Position(Vector2:new(Screens.WeaponSelection.Window:Get_Size().x * 0.60, Screens.WeaponSelection.Window:Get_Size().y * 0.90))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.WeaponSelection.Reset), "Singularity::IDelegate"))
	Screens.WeaponSelection.Window:AddControl(button)

	
	--Cancel Button
	cancelButton = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\CancelButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(cancelButton, Vector2:new(cancelButton:Get_Width(), cancelButton:Get_Height()), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Cancel Changes Button - Weapon Selection", "")
	button:Set_Texture(ninepatch)
	button:Set_Position(Vector2:new(Screens.WeaponSelection.Window:Get_Size().x * 0.72, Screens.WeaponSelection.Window:Get_Size().y * 0.90))
	button:Set_Size(Vector2:new(139,59))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.WeaponSelection.Cancel), "Singularity::IDelegate"))
	Screens.WeaponSelection.Window:AddControl(button)

	--Accept Button
	okButton = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\AcceptButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(okButton, Vector2:new(okButton:Get_Width(), okButton:Get_Height()), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Accept Changes Button - Weapon Selection", "")
	button:Set_Texture(ninepatch)
	button:Set_Position(Vector2:new(Screens.WeaponSelection.Window:Get_Size().x * 0.84, Screens.WeaponSelection.Window:Get_Size().y * 0.90))
	button:Set_Size(Vector2:new(139,59))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.WeaponSelection.AcceptChanges), "Singularity::IDelegate"))
	Screens.WeaponSelection.Window:AddControl(button)

	Util.Debug("Screens[\"Weapon Selection Screens\"] loaded")
end

Screens.WeaponSelection.CheckControls = function()

	if(Screens.WeaponSelection.InvertGravity.Selected == false) then
		Screens.WeaponSelection.InvertGravity.Selected = true
		Screens.WeaponSelection.InvertedGravity:Set_Texture(Screens.WeaponSelection.InvertedGravity.SelectedNinepatch)
		
		--checking the containers
		if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer1.Selectedvalue = 1
		elseif(Screens.WeaponSelection.WeapContainer2SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 1
		elseif(Screens.WeaponSelection.WeapContainer3.SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 1
		end
		
	else
		Screens.WeaponSelection.InvertGravity.Selected = false
		Screens.WeaponSelection.InvertGravity:Set_Texture(Screens.WeaponSelection.InvertGravity.RegularNinepatch)
	end
	
	if(Screens.WeaponSelection.IncreaseGravity.Selected == false) then
		Screens.WeaponSelection.IncreaseGravity.Selected = true
		Screens.WeaponSelection.IncreaseGravity:Set_Texture(Screens.WeaponSelection.IncreaseGravity.SelectedNinepatch)
		
		--checking the containers
		if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer1.Selectedvalue = 2
		elseif(Screens.WeaponSelection.WeapContainer2SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 2
		elseif(Screens.WeaponSelection.WeapContainer3.SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 2
		end
	else
		Screens.WeaponSelection.IncreaseGravity.Selected = false
		Screens.WeaponSelection.IncreaseGravity:Set_Texture(Screens.WeaponSelection.IncreaseGravity.RegularNinepatch)
		
		--checking the containers
		if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer1.Selectedvalue = 3
		elseif(Screens.WeaponSelection.WeapContainer2SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 3
		elseif(Screens.WeaponSelection.WeapContainer3.SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 3
		end
	end
	
	if(Screens.WeaponSelection.Frictionless.Selected == false) then
		Screens.WeaponSelection.Frictionless.Selected = true
		Screens.WeaponSelection.Frictionless:Set_Texture(Screens.WeaponSelection.Frictionless.SelectedNinepatch)
		
		--checking the containers
		if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer1.Selectedvalue = 4
		elseif(Screens.WeaponSelection.WeapContainer2SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 4
		elseif(Screens.WeaponSelection.WeapContainer3.SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 4
		end
	else
		Screens.WeaponSelection.Frictionless.Selected = false
		Screens.WeaponSelection.Frictionless:Set_Texture(Screens.WeaponSelection.Frictionless.RegularNinepatch)
	end
	
	if(Screens.WeaponSelection.Grow.Selected == false) then
		Screens.WeaponSelection.Grow.Selected = true
		Screens.WeaponSelection.Grow:Set_Texture(Screens.WeaponSelection.Grow.SelectedNinepatch)
		
		--checking the containers
		if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer1.Selectedvalue = 5
		elseif(Screens.WeaponSelection.WeapContainer2SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 5
		elseif(Screens.WeaponSelection.WeapContainer3.SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 5
		end
	else
		Screens.WeaponSelection.Grow.Selected = false
		Screens.WeaponSelection.Grow:Set_Texture(Screens.WeaponSelection.Grow.RegularNinepatch)
	end
	
	if(Screens.WeaponSelection.Shrink.Selected == false) then
		Screens.WeaponSelection.Shrink.Selected = true
		Screens.WeaponSelection.Shrink:Set_Texture(Screens.WeaponSelection.Shrink.SelectedNinepatch)
	else
		Screens.WeaponSelection.Shrink.Selected = false
		Screens.WeaponSelection.Shrink:Set_Texture(Screens.WeaponSelection.Shrink.RegularNinepatch)
		
		--checking the containers
		if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer1.Selectedvalue = 6
		elseif(Screens.WeaponSelection.WeapContainer2SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 6
		elseif(Screens.WeaponSelection.WeapContainer3.SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 6
		end
	end
	
	if(Screens.WeaponSelection.Knockback.Selected == false) then
		Screens.WeaponSelection.Knockback.Selected = true
		Screens.WeaponSelection.Knockback:Set_Texture(Screens.WeaponSelection.Knockback.SelectedNinepatch)
		
		--checking the containers
		if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer1.Selectedvalue = 7
		elseif(Screens.WeaponSelection.WeapContainer2SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 7
		elseif(Screens.WeaponSelection.WeapContainer3.SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 7
		end
	else
		Screens.WeaponSelection.Knockback.Selected = false
		Screens.WeaponSelection.Knockback:Set_Texture(Screens.WeaponSelection.Knockback.RegularNinepatch)
	end
	
	if(Screens.WeaponSelection.Barrier.Selected == false) then
		Screens.WeaponSelection.Barrier.Selected = true
		Screens.WeaponSelection.Barrier:Set_Texture(Screens.WeaponSelection.Barrier.SelectedNinepatch)
		
		--checking the containers
		if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 0) then
			Screens.WeaponSelection.WeapContainer1.Selectedvalue = 8
		elseif(Screens.WeaponSelection.WeapContainer2SelectedValue == 0) then 
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 8
		elseif(Screens.WeaponSelection.WeapContainer3.SelectedValue == 0) then 
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 8
		end
	else
		Screens.WeaponSelection.Barrier.Selected = false
		Screens.WeaponSelection.Barrier:Set_Texture(Screens.WeaponSelection.Barrier.RegularNinepatch)
	end

end

Screens.WeaponSelection.Reset = function()
	Util.Debug("Reset clicked")
	Audio.MenuEmitter:Play(2)
	--Reseting takes player's choices and blanks them
	--Reseting the buttons
	if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 1 or Screens.WeaponSelection.WeapContainer2.SelectedValue == 1 
		or Screens.WeaponSelection.WeapContainer3.SelectedValue == 1) then
		Screens.WeaponSelection.NullifierGun.Selected = false
		Screens.WeaponSelection.NullifierGun.SelectedContainer = 0
		Screens.WeaponSelection.NullifierGun.Control:Set_Texture(Screens.WeaponSelection.NullifierGun.RegularNinepatch)
	end
	
	--Reseting the buttons
	if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 2 or Screens.WeaponSelection.WeapContainer2.SelectedValue == 2 
		or Screens.WeaponSelection.WeapContainer3.SelectedValue == 2) then
		Screens.WeaponSelection.Pistol.Selected = false
		Screens.WeaponSelection.Pistol.SelectedContainer = 0
		Screens.WeaponSelection.Pistol.Control:Set_Texture(Screens.WeaponSelection.Pistol.RegularNinepatch)
	end
	
	--Reseting the buttons
	if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 3 or Screens.WeaponSelection.WeapContainer2.SelectedValue == 3 
		or Screens.WeaponSelection.WeapContainer3.SelectedValue == 3) then
		Screens.WeaponSelection.Shotgun.Selected = false
		Screens.WeaponSelection.Shotgun.SelectedContainer = 0
		Screens.WeaponSelection.Shotgun.Control:Set_Texture(Screens.WeaponSelection.Shotgun.RegularNinepatch)
	end
	
	--Reseting the buttons
	if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 4 or Screens.WeaponSelection.WeapContainer2.SelectedValue == 4 
		or Screens.WeaponSelection.WeapContainer3.SelectedValue == 4) then
		Screens.WeaponSelection.AssaultRifle.Selected = false
		Screens.WeaponSelection.AssaultRifle.SelectedContainer = 0
		Screens.WeaponSelection.AssaultRifle.Control:Set_Texture(Screens.WeaponSelection.AssaultRifle.RegularNinepatch)
	end
	
	--Reseting the buttons
	if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 5 or Screens.WeaponSelection.WeapContainer2.SelectedValue == 5 
		or Screens.WeaponSelection.WeapContainer3.SelectedValue == 5) then
		Screens.WeaponSelection.SniperRifle.Selected = false
		Screens.WeaponSelection.SniperRifle.SelectedContainer = 0
		Screens.WeaponSelection.SniperRifle.Control:Set_Texture(Screens.WeaponSelection.SniperRifle.RegularNinepatch)
	end
	
	--Reseting the buttons
	if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 6 or Screens.WeaponSelection.WeapContainer2.SelectedValue == 6 
		or Screens.WeaponSelection.WeapContainer3.SelectedValue == 6) then
		Screens.WeaponSelection.Cannon.Selected = false
		Screens.WeaponSelection.Cannon.SelectedContainer = 0
		Screens.WeaponSelection.Cannon.Control:Set_Texture(Screens.WeaponSelection.Cannon.RegularNinepatch)
	end
	
	--Resetting the choice containers
	Screens.WeaponSelection.WeapContainer1.SelectedValue = 0
	Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
	
	Screens.WeaponSelection.WeapContainer2.SelectedValue = 0
	Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
	
	Screens.WeaponSelection.WeapContainer3.SelectedValue = 0
	Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
	
	Screens.WeaponSelection.AvailableResources = MAX_RESOURCES
	Screens.WeaponSelection.UpdateResourceIcons()
end

--updates the resource icons based on the amount of resource points left to choose combinations
Screens.WeaponSelection.UpdateResourceIcons = function()
	
	Util.Debug("Resource Count: " , Screens.WeaponSelection.AvailableResources)
	--counting down from 5	
	if(Screens.WeaponSelection.AvailableResources < 3) then
		Screens.WeaponSelection.Resource3.Control:Set_Texture(Screens.WeaponSelection.ResourceTakenNinepatch)
	else
		Screens.WeaponSelection.Resource3.Control:Set_Texture(Screens.WeaponSelection.ResourceRegNinepatch)
	end
	
	if(Screens.WeaponSelection.AvailableResources < 2) then
		Screens.WeaponSelection.Resource2.Control:Set_Texture(Screens.WeaponSelection.ResourceTakenNinepatch)
	else
		Screens.WeaponSelection.Resource2.Control:Set_Texture(Screens.WeaponSelection.ResourceRegNinepatch)
	end
	
	if(Screens.WeaponSelection.AvailableResources < 1) then
		Screens.WeaponSelection.Resource1.Control:Set_Texture(Screens.WeaponSelection.ResourceTakenNinepatch)
	else
		Screens.WeaponSelection.Resource1.Control:Set_Texture(Screens.WeaponSelection.ResourceRegNinepatch)
	end
	
end

Screens.WeaponSelection.NullifierGunClick = function()
	Util.Debug("Nullifier Gun clicked")
	Audio.MenuEmitter:Play(2)
	if(Screens.WeaponSelection.NullifierGun.Selected == false and Screens.WeaponSelection.AvailableResources >= Screens.WeaponSelection.NullifierGun.Resource) then
		
		--Figuring out which container to put it in
		if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 0 and Screens.WeaponSelection.NullifierGun.SelectedContainer == 0) then
			Screens.WeaponSelection.NullifierGun.SelectedContainer = 1
			Screens.WeaponSelection.WeapContainer1.SelectedValue = 1
			Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.NullifierGun.WideNinepatch)
			
			Screens.WeaponSelection.NullifierGun.Selected = true
			Screens.WeaponSelection.NullifierGun.Control:Set_Texture(Screens.WeaponSelection.NullifierGun.SelectedNinepatch)
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.NullifierGun.Resource, 0)
			
		elseif(Screens.WeaponSelection.WeapContainer2.SelectedValue == 0 and Screens.WeaponSelection.NullifierGun.SelectedContainer == 0) then
			Screens.WeaponSelection.NullifierGun.SelectedContainer = 2
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 1
			Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.NullifierGun.WideNinepatch)
			
			Screens.WeaponSelection.NullifierGun.Selected = true
			Screens.WeaponSelection.NullifierGun.Control:Set_Texture(Screens.WeaponSelection.NullifierGun.SelectedNinepatch)
			
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.NullifierGun.Resource, 0)
		
		elseif(Screens.WeaponSelection.WeapContainer3.SelectedValue == 0 and Screens.WeaponSelection.NullifierGun.SelectedContainer == 0) then
			Screens.WeaponSelection.NullifierGun.SelectedContainer = 3
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 1
			Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.NullifierGun.WideNinepatch)
			
			Screens.WeaponSelection.NullifierGun.Selected = true
			Screens.WeaponSelection.NullifierGun.Control:Set_Texture(Screens.WeaponSelection.NullifierGun.SelectedNinepatch)
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.NullifierGun.Resource, 0)
		end
		
	else
		Screens.WeaponSelection.NullifierGun.Selected = false
		Screens.WeaponSelection.NullifierGun.Control:Set_Texture(Screens.WeaponSelection.NullifierGun.RegularNinepatch)
		
		if(Screens.WeaponSelection.NullifierGun.SelectedContainer == 1) then
			Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.NullifierGun.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer1.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.NullifierGun.Resource, MAX_RESOURCES)
		
		elseif(Screens.WeaponSelection.NullifierGun.SelectedContainer == 2) then
			Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.NullifierGun.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.NullifierGun.Resource, MAX_RESOURCES)
		
		elseif(Screens.WeaponSelection.NullifierGun.SelectedContainer == 3) then
			Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.NullifierGun.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.NullifierGun.Resource, MAX_RESOURCES)
		end
	end
	
	Screens.WeaponSelection.UpdateResourceIcons()
end

Screens.WeaponSelection.PistolClick = function()
	Util.Debug("Pistol clicked")
	Audio.MenuEmitter:Play(2)
	if(Screens.WeaponSelection.Pistol.Selected == false and Screens.WeaponSelection.AvailableResources >= Screens.WeaponSelection.Pistol.Resource) then
		
		--Figuring out which container to put it in
		if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 0 and Screens.WeaponSelection.Pistol.SelectedContainer == 0) then
			Screens.WeaponSelection.Pistol.SelectedContainer = 1
			Screens.WeaponSelection.WeapContainer1.SelectedValue = 2
			Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.Pistol.WideNinepatch)
			
			Screens.WeaponSelection.Pistol.Selected = true
			Screens.WeaponSelection.Pistol.Control:Set_Texture(Screens.WeaponSelection.Pistol.SelectedNinepatch)
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Pistol.Resource, 0)
			
		elseif(Screens.WeaponSelection.WeapContainer2.SelectedValue == 0 and Screens.WeaponSelection.Pistol.SelectedContainer == 0) then
			Screens.WeaponSelection.Pistol.SelectedContainer = 2
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 2
			Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.Pistol.WideNinepatch)
			
			Screens.WeaponSelection.Pistol.Selected = true
			Screens.WeaponSelection.Pistol.Control:Set_Texture(Screens.WeaponSelection.Pistol.SelectedNinepatch)
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Pistol.Resource, 0)
			
		elseif(Screens.WeaponSelection.WeapContainer3.SelectedValue == 0 and Screens.WeaponSelection.Pistol.SelectedContainer == 0) then
			Screens.WeaponSelection.Pistol.SelectedContainer = 3
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 2
			Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.Pistol.WideNinepatch)
			
			Screens.WeaponSelection.Pistol.Selected = true
			Screens.WeaponSelection.Pistol.Control:Set_Texture(Screens.WeaponSelection.Pistol.SelectedNinepatch)
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Pistol.Resource, 0)
		end
		
	else
		Screens.WeaponSelection.Pistol.Selected = false
		Screens.WeaponSelection.Pistol.Control:Set_Texture(Screens.WeaponSelection.Pistol.RegularNinepatch)
		
		if(Screens.WeaponSelection.Pistol.SelectedContainer == 1) then
			Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.Pistol.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer1.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.Pistol.Resource, MAX_RESOURCES)
		
		elseif(Screens.WeaponSelection.Pistol.SelectedContainer == 2) then
			Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.Pistol.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.Pistol.Resource, MAX_RESOURCES)
		
		elseif(Screens.WeaponSelection.Pistol.SelectedContainer == 3) then
			Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.Pistol.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.Pistol.Resource, MAX_RESOURCES)
		end
	end
	
	Screens.WeaponSelection.UpdateResourceIcons()
end

Screens.WeaponSelection.ShotgunClick = function()
	Util.Debug("Shotgun clicked")
	Audio.MenuEmitter:Play(2)
	if(Screens.WeaponSelection.Shotgun.Selected == false and Screens.WeaponSelection.AvailableResources >= Screens.WeaponSelection.Shotgun.Resource) then
		
		--Figuring out which container to put it in
		if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 0 and Screens.WeaponSelection.Shotgun.SelectedContainer == 0) then
			Screens.WeaponSelection.Shotgun.SelectedContainer = 1
			Screens.WeaponSelection.WeapContainer1.SelectedValue = 3
			Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.Shotgun.WideNinepatch)
			
			Screens.WeaponSelection.Shotgun.Selected = true
			Screens.WeaponSelection.Shotgun.Control:Set_Texture(Screens.WeaponSelection.Shotgun.SelectedNinepatch)
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Shotgun.Resource, 0)
			
		elseif(Screens.WeaponSelection.WeapContainer2.SelectedValue == 0 and Screens.WeaponSelection.Shotgun.SelectedContainer == 0) then
			Screens.WeaponSelection.Shotgun.SelectedContainer = 2
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 3
			Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.Shotgun.WideNinepatch)
			
			Screens.WeaponSelection.Shotgun.Selected = true
			Screens.WeaponSelection.Shotgun.Control:Set_Texture(Screens.WeaponSelection.Shotgun.SelectedNinepatch)
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Shotgun.Resource, 0)
			
		elseif(Screens.WeaponSelection.WeapContainer3.SelectedValue == 0 and Screens.WeaponSelection.Shotgun.SelectedContainer == 0) then
			Screens.WeaponSelection.Shotgun.SelectedContainer = 3
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 3
			Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.Shotgun.WideNinepatch)
			
			Screens.WeaponSelection.Shotgun.Selected = true
			Screens.WeaponSelection.Shotgun.Control:Set_Texture(Screens.WeaponSelection.Shotgun.SelectedNinepatch)
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Shotgun.Resource, 0)
		end
		
	else
		Screens.WeaponSelection.Shotgun.Selected = false
		Screens.WeaponSelection.Shotgun.Control:Set_Texture(Screens.WeaponSelection.Shotgun.RegularNinepatch)
		
		if(Screens.WeaponSelection.Shotgun.SelectedContainer == 1) then
			Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.Shotgun.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer1.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.Shotgun.Resource, MAX_RESOURCES)
		
		elseif(Screens.WeaponSelection.Shotgun.SelectedContainer == 2) then
			Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.Shotgun.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.Shotgun.Resource, MAX_RESOURCES)
		
		elseif(Screens.WeaponSelection.Shotgun.SelectedContainer == 3) then
			Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.Shotgun.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.Shotgun.Resource, MAX_RESOURCES)
		end
	end
	
	Screens.WeaponSelection.UpdateResourceIcons()
end

Screens.WeaponSelection.AssaultRifleClick = function()
	Util.Debug("Assault Rifle clicked")
	Audio.MenuEmitter:Play(2)
	if(Screens.WeaponSelection.AssaultRifle.Selected == false and Screens.WeaponSelection.AvailableResources >= Screens.WeaponSelection.AssaultRifle.Resource) then
		
		--Figuring out which container to put it in
		if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 0 and Screens.WeaponSelection.AssaultRifle.SelectedContainer == 0) then
			Screens.WeaponSelection.AssaultRifle.SelectedContainer = 1
			Screens.WeaponSelection.WeapContainer1.SelectedValue = 4
			Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.AssaultRifle.WideNinepatch)
			
			Screens.WeaponSelection.AssaultRifle.Selected = true
			Screens.WeaponSelection.AssaultRifle.Control:Set_Texture(Screens.WeaponSelection.AssaultRifle.SelectedNinepatch)
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.AssaultRifle.Resource, 0)
			
		elseif(Screens.WeaponSelection.WeapContainer2.SelectedValue == 0 and Screens.WeaponSelection.AssaultRifle.SelectedContainer == 0) then
			Screens.WeaponSelection.AssaultRifle.SelectedContainer = 2
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 4
			Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.AssaultRifle.WideNinepatch)
			
			Screens.WeaponSelection.AssaultRifle.Selected = true
			Screens.WeaponSelection.AssaultRifle.Control:Set_Texture(Screens.WeaponSelection.AssaultRifle.SelectedNinepatch)
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.AssaultRifle.Resource, 0)
			
		elseif(Screens.WeaponSelection.WeapContainer3.SelectedValue == 0 and Screens.WeaponSelection.AssaultRifle.SelectedContainer == 0) then
			Screens.WeaponSelection.AssaultRifle.SelectedContainer = 3
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 4
			Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.AssaultRifle.WideNinepatch)
			
			Screens.WeaponSelection.AssaultRifle.Selected = true
			Screens.WeaponSelection.AssaultRifle.Control:Set_Texture(Screens.WeaponSelection.AssaultRifle.SelectedNinepatch)
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.AssaultRifle.Resource, 0)
		end
		
	else
		Screens.WeaponSelection.AssaultRifle.Selected = false
		Screens.WeaponSelection.AssaultRifle.Control:Set_Texture(Screens.WeaponSelection.AssaultRifle.RegularNinepatch)
		
		if(Screens.WeaponSelection.AssaultRifle.SelectedContainer == 1) then
			Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.AssaultRifle.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer1.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.AssaultRifle.Resource, MAX_RESOURCES)
		
		elseif(Screens.WeaponSelection.AssaultRifle.SelectedContainer == 2) then
			Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.AssaultRifle.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.AssaultRifle.Resource, MAX_RESOURCES)
		
		elseif(Screens.WeaponSelection.AssaultRifle.SelectedContainer == 3) then
			Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.AssaultRifle.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.AssaultRifle.Resource, MAX_RESOURCES)
		end
	end
	
	Screens.WeaponSelection.UpdateResourceIcons()
end

Screens.WeaponSelection.SniperRifleClick = function()
	Util.Debug("Sniper Rifle clicked")
	Audio.MenuEmitter:Play(2)
	if(Screens.WeaponSelection.SniperRifle.Selected == false and Screens.WeaponSelection.AvailableResources >= Screens.WeaponSelection.SniperRifle.Resource) then
		--Figuring out which container to put it in
		if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 0 and Screens.WeaponSelection.SniperRifle.SelectedContainer == 0) then
			Screens.WeaponSelection.SniperRifle.SelectedContainer = 1
			Screens.WeaponSelection.WeapContainer1.SelectedValue = 5
			Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.SniperRifle.WideNinepatch)
			
			Screens.WeaponSelection.SniperRifle.Selected = true
			Screens.WeaponSelection.SniperRifle.Control:Set_Texture(Screens.WeaponSelection.SniperRifle.SelectedNinepatch)
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.SniperRifle.Resource, 0)
			
		elseif(Screens.WeaponSelection.WeapContainer2.SelectedValue == 0 and Screens.WeaponSelection.SniperRifle.SelectedContainer == 0) then
			Screens.WeaponSelection.SniperRifle.SelectedContainer = 2
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 5
			Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.SniperRifle.WideNinepatch)
			
			Screens.WeaponSelection.SniperRifle.Selected = true
			Screens.WeaponSelection.SniperRifle.Control:Set_Texture(Screens.WeaponSelection.SniperRifle.SelectedNinepatch)
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.SniperRifle.Resource, 0)
			
		elseif(Screens.WeaponSelection.WeapContainer3.SelectedValue == 0 and Screens.WeaponSelection.SniperRifle.SelectedContainer == 0) then
			Screens.WeaponSelection.SniperRifle.SelectedContainer = 3
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 5
			Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.SniperRifle.WideNinepatch)
			
			Screens.WeaponSelection.SniperRifle.Selected = true
			Screens.WeaponSelection.SniperRifle.Control:Set_Texture(Screens.WeaponSelection.SniperRifle.SelectedNinepatch)
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.SniperRifle.Resource, 0)
		end
	else
		Screens.WeaponSelection.SniperRifle.Selected = false
		Screens.WeaponSelection.SniperRifle.Control:Set_Texture(Screens.WeaponSelection.SniperRifle.RegularNinepatch)
		
		if(Screens.WeaponSelection.SniperRifle.SelectedContainer == 1) then
			Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.SniperRifle.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer1.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.SniperRifle.Resource, MAX_RESOURCES)
		
		elseif(Screens.WeaponSelection.SniperRifle.SelectedContainer == 2) then
			Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.SniperRifle.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.SniperRifle.Resource, MAX_RESOURCES)
		
		elseif(Screens.WeaponSelection.SniperRifle.SelectedContainer == 3) then
			Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.SniperRifle.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.SniperRifle.Resource, MAX_RESOURCES)
		end
	end
	
	Screens.WeaponSelection.UpdateResourceIcons()
end

Screens.WeaponSelection.CannonClick = function()
	Util.Debug("Cannon clicked")
	Audio.MenuEmitter:Play(2)
	if(Screens.WeaponSelection.Cannon.Selected == false and Screens.WeaponSelection.AvailableResources >= Screens.WeaponSelection.Cannon.Resource) then
		--Figuring out which container to put it in
		if(Screens.WeaponSelection.WeapContainer1.SelectedValue == 0 and Screens.WeaponSelection.Cannon.SelectedContainer == 0) then
			Screens.WeaponSelection.Cannon.SelectedContainer = 1
			Screens.WeaponSelection.WeapContainer1.SelectedValue = 6
			Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.Cannon.WideNinepatch)
			
			Screens.WeaponSelection.Cannon.Selected = true
			Screens.WeaponSelection.Cannon.Control:Set_Texture(Screens.WeaponSelection.Cannon.SelectedNinepatch)
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Cannon.Resource, 0)
			
		elseif(Screens.WeaponSelection.WeapContainer2.SelectedValue == 0 and Screens.WeaponSelection.Cannon.SelectedContainer == 0) then
			Screens.WeaponSelection.Cannon.SelectedContainer = 2
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 6
			Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.Cannon.WideNinepatch)
			
			Screens.WeaponSelection.Cannon.Selected = true
			Screens.WeaponSelection.Cannon.Control:Set_Texture(Screens.WeaponSelection.Cannon.SelectedNinepatch)
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Cannon.Resource, 0)
			
		elseif(Screens.WeaponSelection.WeapContainer3.SelectedValue == 0 and Screens.WeaponSelection.Cannon.SelectedContainer == 0) then
			Screens.WeaponSelection.Cannon.SelectedContainer = 3
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 6
			Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.Cannon.WideNinepatch)
			
			Screens.WeaponSelection.Cannon.Selected = true
			Screens.WeaponSelection.Cannon.Control:Set_Texture(Screens.WeaponSelection.Cannon.SelectedNinepatch)
			Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Cannon.Resource, 0)
		end
		
	else
		Screens.WeaponSelection.Cannon.Selected = false
		Screens.WeaponSelection.Cannon.Control:Set_Texture(Screens.WeaponSelection.Cannon.RegularNinepatch)
		
		if(Screens.WeaponSelection.Cannon.SelectedContainer == 1) then
			Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.Cannon.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer1.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.Cannon.Resource, MAX_RESOURCES)
		
		elseif(Screens.WeaponSelection.Cannon.SelectedContainer == 2) then
			Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.Cannon.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer2.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.Cannon.Resource, MAX_RESOURCES)
		
		elseif(Screens.WeaponSelection.Cannon.SelectedContainer == 3) then
			Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
			Screens.WeaponSelection.Cannon.SelectedContainer = 0
			Screens.WeaponSelection.WeapContainer3.SelectedValue = 0
			Screens.WeaponSelection.AvailableResources = math.min(Screens.WeaponSelection.AvailableResources + Screens.WeaponSelection.Cannon.Resource, MAX_RESOURCES)
		end
	end
	
	Screens.WeaponSelection.UpdateResourceIcons()
end

Screens.WeaponSelection.CheckResources = function()

	local incomingMods = { }
	local modIndexes = { }
	
	Util.Debug("Weapons list size"..table.getn(Player.Client:GetWeapons()))
	
	for i, v in ipairs(Player.Client:GetWeapons()) do
		if(string.find(v.Type, "ModifierLauncher") == nil) then
			table.insert(incomingMods, v.Type)
		end
	end
	
	--determining the lookup values
	for i, v in ipairs(incomingMods) do
		for j, u in ipairs(WeaponLookup) do
			if(u == v) then
				table.insert(modIndexes, j)
			end
		end
	end
	Util.Debug("Testing containers")
	
	--Checking the weapons
	if(modIndexes[1] == 1) then
		Screens.WeaponSelection.WeapContainer1.SelectedValue = 1
		Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.NullifierGun.WideNinepatch)
		Screens.WeaponSelection.NullifierGun.Control:Set_Texture(Screens.WeaponSelection.NullifierGun.SelectedNinepatch)
		Screens.WeaponSelection.NullifierGun.Selected = true
		Screens.WeaponSelection.NullifierGun.SelectedContainer = 1
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.NullifierGun.Resource, 0)
	elseif(modIndexes[1] == 2) then
		Screens.WeaponSelection.WeapContainer1.SelectedValue = 2
		Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.Pistol.WideNinepatch)
		Screens.WeaponSelection.Pistol.Control:Set_Texture(Screens.WeaponSelection.Pistol.SelectedNinepatch)
		Screens.WeaponSelection.Pistol.Selected = true
		Screens.WeaponSelection.Pistol.SelectedContainer = 1
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Pistol.Resource, 0)
	elseif(modIndexes[1] == 3) then
		Screens.WeaponSelection.WeapContainer1.SelectedValue = 3
		Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.Shotgun.WideNinepatch)
		Screens.WeaponSelection.Shotgun.Control:Set_Texture(Screens.WeaponSelection.Shotgun.SelectedNinepatch)
		Screens.WeaponSelection.Shotgun.Selected = true
		Screens.WeaponSelection.Shotgun.SelectedContainer = 1
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Shotgun.Resource, 0)
	elseif(modIndexes[1] == 4) then
		Screens.WeaponSelection.WeapContainer1.SelectedValue = 4
		Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.AssaultRifle.WideNinepatch)
		Screens.WeaponSelection.AssaultRifle.Control:Set_Texture(Screens.WeaponSelection.AssaultRifle.SelectedNinepatch)
		Screens.WeaponSelection.AssaultRifle.Selected = true
		Screens.WeaponSelection.AssaultRifle.SelectedContainer = 1
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.AssaultRifle.Resource, 0)
	elseif(modIndexes[1] == 5) then
		Screens.WeaponSelection.WeapContainer1.SelectedValue = 5
		Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.SniperRifle.WideNinepatch)
		Screens.WeaponSelection.SniperRifle.Control:Set_Texture(Screens.WeaponSelection.SniperRifle.SelectedNinepatch)
		Screens.WeaponSelection.SniperRifle.Selected = true
		Screens.WeaponSelection.SniperRifle.SelectedContainer = 1
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.SniperRifle.Resource, 0)
	elseif(modIndexes[1] == 6) then
		Screens.WeaponSelection.WeapContainer1.SelectedValue = 6
		Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.Cannon.WideNinepatch)
		Screens.WeaponSelection.Cannon.Control:Set_Texture(Screens.WeaponSelection.Cannon.SelectedNinepatch)
		Screens.WeaponSelection.Cannon.Selected = true
		Screens.WeaponSelection.Cannon.SelectedContainer = 1
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Cannon.Resource, 0)
	else
		Screens.WeaponSelection.WeapContainer1.SelectedValue = 0
		Screens.WeaponSelection.WeapContainer1.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
	end
	
	if(modIndexes[2] == 1) then
		Screens.WeaponSelection.WeapContainer2.SelectedValue = 1
		Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.NullifierGun.WideNinepatch)
		Screens.WeaponSelection.NullifierGun.Control:Set_Texture(Screens.WeaponSelection.NullifierGun.SelectedNinepatch)
		Screens.WeaponSelection.NullifierGun.Selected = true
		Screens.WeaponSelection.NullifierGun.SelectedContainer = 2
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.NullifierGun.Resource, 0)
	elseif(modIndexes[2] == 2) then
		Screens.WeaponSelection.WeapContainer2.SelectedValue = 2
		Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.Pistol.WideNinepatch)
		Screens.WeaponSelection.Pistol.Control:Set_Texture(Screens.WeaponSelection.Pistol.SelectedNinepatch)
		Screens.WeaponSelection.Pistol.Selected = true
		Screens.WeaponSelection.Pistol.SelectedContainer = 2
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Pistol.Resource, 0)
	elseif(modIndexes[2] == 3) then
		Screens.WeaponSelection.WeapContainer2.SelectedValue = 3
		Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.Shotgun.WideNinepatch)
		Screens.WeaponSelection.Shotgun.Control:Set_Texture(Screens.WeaponSelection.Shotgun.SelectedNinepatch)
		Screens.WeaponSelection.Shotgun.Selected = true
		Screens.WeaponSelection.Shotgun.SelectedContainer = 2
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Shotgun.Resource, 0)
	elseif(modIndexes[2] == 4) then
		Screens.WeaponSelection.WeapContainer2.SelectedValue = 4
		Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.AssaultRifle.WideNinepatch)
		Screens.WeaponSelection.AssaultRifle.Control:Set_Texture(Screens.WeaponSelection.AssaultRifle.SelectedNinepatch)
		Screens.WeaponSelection.AssaultRifle.Selected = true
		Screens.WeaponSelection.AssaultRifle.SelectedContainer = 2
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.AssaultRifle.Resource, 0)
	elseif(modIndexes[2] == 5) then
		Screens.WeaponSelection.WeapContainer2.SelectedValue = 5
		Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.SniperRifle.WideNinepatch)
		Screens.WeaponSelection.SniperRifle.Control:Set_Texture(Screens.WeaponSelection.SniperRifle.SelectedNinepatch)
		Screens.WeaponSelection.SniperRifle.Selected = true
		Screens.WeaponSelection.SniperRifle.SelectedContainer = 2
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.SniperRifle.Resource, 0)
	elseif(modIndexes[2] == 6) then
		Screens.WeaponSelection.WeapContainer2.SelectedValue = 6
		Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.Cannon.WideNinepatch)
		Screens.WeaponSelection.Cannon.Control:Set_Texture(Screens.WeaponSelection.Cannon.SelectedNinepatch)
		Screens.WeaponSelection.Cannon.Selected = true
		Screens.WeaponSelection.Cannon.SelectedContainer = 2
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Cannon.Resource, 0)
	else
		Screens.WeaponSelection.WeapContainer2.SelectedValue = 0
		Screens.WeaponSelection.WeapContainer2.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
	end
	
	if(modIndexes[3] == 1) then
		Screens.WeaponSelection.WeapContainer3.SelectedValue = 1
		Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.NullifierGun.WideNinepatch)
		Screens.WeaponSelection.NullifierGun.Control:Set_Texture(Screens.WeaponSelection.NullifierGun.SelectedNinepatch)
		Screens.WeaponSelection.NullifierGun.Selected = true
		Screens.WeaponSelection.NullifierGun.SelectedContainer = 3
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.NullifierGun.Resource, 0)
	elseif(modIndexes[3] == 2) then
		Screens.WeaponSelection.WeapContainer3.SelectedValue = 2
		Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.Pistol.WideNinepatch)
		Screens.WeaponSelection.Pistol.Control:Set_Texture(Screens.WeaponSelection.Pistol.SelectedNinepatch)
		Screens.WeaponSelection.Pistol.Selected = true
		Screens.WeaponSelection.Pistol.SelectedContainer = 3
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Pistol.Resource, 0)
	elseif(modIndexes[3] == 3) then
		Screens.WeaponSelection.WeapContainer3.SelectedValue = 3
		Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.Shotgun.WideNinepatch)
		Screens.WeaponSelection.Shotgun.Control:Set_Texture(Screens.WeaponSelection.Shotgun.SelectedNinepatch)
		Screens.WeaponSelection.Shotgun.Selected = true
		Screens.WeaponSelection.Shotgun.SelectedContainer = 3
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Shotgun.Resource, 0)
	elseif(modIndexes[3] == 4) then
		Screens.WeaponSelection.WeapContainer3.SelectedValue = 4
		Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.AssaultRifle.WideNinepatch)
		Screens.WeaponSelection.AssaultRifle.Control:Set_Texture(Screens.WeaponSelection.AssaultRifle.SelectedNinepatch)
		Screens.WeaponSelection.AssaultRifle.Selected = true
		Screens.WeaponSelection.AssaultRifle.SelectedContainer = 3
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.AssaultRifle.Resource, 0)
	elseif(modIndexes[3] == 5) then
		Screens.WeaponSelection.WeapContainer3.SelectedValue = 5
		Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.SniperRifle.WideNinepatch)
		Screens.WeaponSelection.SniperRifle.Control:Set_Texture(Screens.WeaponSelection.SniperRifle.SelectedNinepatch)
		Screens.WeaponSelection.SniperRifle.Selected = true
		Screens.WeaponSelection.SniperRifle.SelectedContainer = 3
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.SniperRifle.Resource, 0)
	elseif(modIndexes[3] == 6) then
		Screens.WeaponSelection.WeapContainer3.SelectedValue = 6
		Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.Cannon.WideNinepatch)
		Screens.WeaponSelection.Cannon.Control:Set_Texture(Screens.WeaponSelection.Cannon.SelectedNinepatch)
		Screens.WeaponSelection.Cannon.Selected = true
		Screens.WeaponSelection.Cannon.SelectedContainer = 3
		Screens.WeaponSelection.AvailableResources = math.max(Screens.WeaponSelection.AvailableResources - Screens.WeaponSelection.Cannon.Resource, 0)
	else
		Screens.WeaponSelection.WeapContainer3.SelectedValue = 0
		Screens.WeaponSelection.WeapContainer3.Control:Set_Texture(Screens.WeaponSelection.BlankLoadoutNP)
	end
	
	Screens.WeaponSelection.UpdateResourceIcons()
end

Screens.WeaponSelection.Activate = function()
	if(Screens.WeaponSelection.Window ~= nil) then
		Util.Debug("Activating Weapon Selection Screen")
		Screens.WeaponSelection.AvailableResources = MAX_RESOURCES
		Screens.WeaponSelection.CheckResources()
		Screens.WeaponSelection.Window:Set_Visible(true)
	end
end

Screens.WeaponSelection.Deactivate = function()
	if(Screens.WeaponSelection.Window ~= nil) then
		Screens.WeaponSelection.Window:Set_Visible(false)
	end
end

Screens.WeaponSelection.Switch = function()
	Util.Debug("==================Switching Screen Clicked======================")
	
	Util.Debug("Container 1 Selected Value: ", Screens.WeaponSelection.WeapContainer1.SelectedValue)
	Util.Debug("Container 2 Selected Value: ", Screens.WeaponSelection.WeapContainer2.SelectedValue)
	Util.Debug("Container 3 Selected Value: ", Screens.WeaponSelection.WeapContainer3.SelectedValue)
	--Any changes made in WeaponSelection and WeaponSelection need to be made permanent for the player

	local newWeapons = { }
	local tempWeaponsTable = Player.Client:GetWeapons()
	local hasWeapons = false
	
	--Retrieving the modifiers from the list so we can preserve them
	for i, v in ipairs(tempWeaponsTable) do
		if(string.find(v.Type, "ModifierLauncher") ~= nil) then
			Util.Debug("Extracting: ", v.Type)
			table.insert(newWeapons, v)
			hasWeapons = true
		end
	end
	
	Util.Debug("Removing current weapons")
	--Clearing the current weapons out
	Player.Client:RemoveAllWeapons()
	
	--Adding the weapons to the player list
	if(Screens.WeaponSelection.WeapContainer1.SelectedValue > 0) then
		Util.Debug("Adding Weaon from Container 1", WeaponLookup[Screens.WeaponSelection.WeapContainer1.SelectedValue])
		Player.Client:AddWeapon(WeaponLookup[Screens.WeaponSelection.WeapContainer1.SelectedValue])
		hasWeapons = true
	end
	
	if(Screens.WeaponSelection.WeapContainer2.SelectedValue > 0) then
		Util.Debug("Adding Weapon from Container 2", WeaponLookup[Screens.WeaponSelection.WeapContainer2.SelectedValue])
		Player.Client:AddWeapon(WeaponLookup[Screens.WeaponSelection.WeapContainer2.SelectedValue])
		hasWeapons = true
	end

	if(Screens.WeaponSelection.WeapContainer3.SelectedValue > 0) then
		Util.Debug("Adding Weapn from Container 3", WeaponLookup[Screens.WeaponSelection.WeapContainer3.SelectedValue])
		Player.Client:AddWeapon(WeaponLookup[Screens.WeaponSelection.WeapContainer3.SelectedValue])
		hasWeapons = true
	end
	
	if(table.getn(newWeapons) > 0) then
		for i, v in ipairs(newWeapons) do
			Util.Debug("Adding modifier: " , v.Type)
			Player.Client:AddWeapon(v.Type)
		end
	end
	
	--if the player has not selected any weapons, then we default them to the pistol
	if(not hasWeapons) then
		Util.Debug("No weapons were chosen, adding Pistol as a default")
		Player.Client:AddWeapon(WeaponLookup[2])
	end
	
	tempWeaponsTable = Player.Client:GetWeapons()
	
	Util.Debug("===========New Weapons List=============")
	for i, v in ipairs(tempWeaponsTable) do
		Util.Debug(i, v.Type)
	end
	
	Screens.ModifierSelection.Activate()
	Screens.WeaponSelection.Deactivate()
end


Screens.WeaponSelection.Cancel = function()
	Util.Debug("Cancel clicked")
	Audio.MenuEmitter:Play(1)
	--No changes to loadout are made
	
	Screens.Spawn.Activate()
	Screens.WeaponSelection.Deactivate()
end

Screens.WeaponSelection.AcceptChanges = function()
	Util.Debug("==================Accept Changes Clicked======================")
	Audio.MenuEmitter:Play(0)
	Util.Debug("Container 1 Selected Value: ", Screens.WeaponSelection.WeapContainer1.SelectedValue)
	Util.Debug("Container 2 Selected Value: ", Screens.WeaponSelection.WeapContainer2.SelectedValue)
	Util.Debug("Container 3 Selected Value: ", Screens.WeaponSelection.WeapContainer3.SelectedValue)
	--Any changes made in WeaponSelection and WeaponSelection need to be made permanent for the player

	local newWeapons = { }
	local tempWeaponsTable = Player.Client:GetWeapons()
	local hasWeapons = false
	
	--Retrieving the modifiers from the list so we can preserve them
	for i, v in ipairs(tempWeaponsTable) do
		if(string.find(v.Type, "ModifierLauncher") ~= nil) then
			Util.Debug("Extracting: ", v.Type)
			table.insert(newWeapons, v)
			hasWeapons = true
		end
	end
	
	Util.Debug("Removing current weapons")
	--Clearing the current weapons out
	Player.Client:RemoveAllWeapons()
	
	--Adding the weapons to the player list
	if(Screens.WeaponSelection.WeapContainer1.SelectedValue > 0) then
		Util.Debug("Adding Weaon from Container 1", WeaponLookup[Screens.WeaponSelection.WeapContainer1.SelectedValue])
		Player.Client:AddWeapon(WeaponLookup[Screens.WeaponSelection.WeapContainer1.SelectedValue])
		hasWeapons = true
	end
	
	if(Screens.WeaponSelection.WeapContainer2.SelectedValue > 0) then
		Util.Debug("Adding Weapon from Container 2", WeaponLookup[Screens.WeaponSelection.WeapContainer2.SelectedValue])
		Player.Client:AddWeapon(WeaponLookup[Screens.WeaponSelection.WeapContainer2.SelectedValue])
		hasWeapons = true
	end

	if(Screens.WeaponSelection.WeapContainer3.SelectedValue > 0) then
		Util.Debug("Adding Weapn from Container 3", WeaponLookup[Screens.WeaponSelection.WeapContainer3.SelectedValue])
		Player.Client:AddWeapon(WeaponLookup[Screens.WeaponSelection.WeapContainer3.SelectedValue])
		hasWeapons = true
	end
	
	if(table.getn(newWeapons) > 0) then
		for i, v in ipairs(newWeapons) do
			Util.Debug("Adding modifier: " , v.Type)
			Player.Client:AddWeapon(v.Type)
		end
	end
	
	--if the player has not selected any weapons, then we default them to the pistol
	if(not hasWeapons) then
		Player.Client:AddWeapon(WeaponLookup[2])
	end
	
	Player.Client:SelectWeapon(1)
	
	tempWeaponsTable = Player.Client:GetWeapons()
	
	Util.Debug("===========New Weapons List=============")
	for i, v in ipairs(tempWeaponsTable) do
		Util.Debug(i, v.Type)
	end
	
	Screens.Spawn.Activate()
	Screens.WeaponSelection.Deactivate()
end