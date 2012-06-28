Screens.ModifierSelection = {}

Screens.ModifierSelection.Window = nil

--modifier controls
Screens.ModifierSelection.InvertGravity = { }
Screens.ModifierSelection.InvertGravity.Control = nil
Screens.ModifierSelection.InvertGravity.Selected = false
Screens.ModifierSelection.InvertGravity.RegularNinepatch = nil
Screens.ModifierSelection.InvertGravity.SelectedNinepatch = nil
Screens.ModifierSelection.InvertGravity.WideNinepatch = nil
Screens.ModifierSelection.InvertGravity.SelectedContainer = 0

Screens.ModifierSelection.Featherlight = { }
Screens.ModifierSelection.Featherlight.Control = nil
Screens.ModifierSelection.Featherlight.Selected = false
Screens.ModifierSelection.Featherlight.RegularNinepatch = nil
Screens.ModifierSelection.Featherlight.SelectedNinepatch = nil
Screens.ModifierSelection.Featherlight.WideNinepatch = nil
Screens.ModifierSelection.Featherlight.SelectedContainer = 0

Screens.ModifierSelection.Grow = { }
Screens.ModifierSelection.Grow.Control = nil
Screens.ModifierSelection.Grow.Selected = false
Screens.ModifierSelection.Grow.RegularNinepatch = nil
Screens.ModifierSelection.Grow.SelectedNinepatch = nil
Screens.ModifierSelection.Grow.WideNinepatch = nil
Screens.ModifierSelection.Grow.SelectedContainer = 0

Screens.ModifierSelection.Shrink = { }
Screens.ModifierSelection.Shrink.Control = nil
Screens.ModifierSelection.Shrink.Selected = false
Screens.ModifierSelection.Shrink.RegularNinepatch = nil
Screens.ModifierSelection.Shrink.SelectedNinepatch = nil
Screens.ModifierSelection.Shrink.WideNinepatch = nil
Screens.ModifierSelection.Shrink.SelectedContainer = 0

Screens.ModifierSelection.Wall = { }
Screens.ModifierSelection.Wall.Control = nil
Screens.ModifierSelection.Wall.Selected = false
Screens.ModifierSelection.Wall.RegularNinepatch = nil
Screens.ModifierSelection.Wall.SelectedNinepatch = nil
Screens.ModifierSelection.Wall.WideNinepatch = nil
Screens.ModifierSelection.Wall.SelectedContainer = 0

Screens.ModifierSelection.Illusion = { }
Screens.ModifierSelection.Illusion.Control = nil
Screens.ModifierSelection.Illusion.Selected = false
Screens.ModifierSelection.Illusion.RegularNinepatch = nil
Screens.ModifierSelection.Illusion.SelectedNinepatch = nil
Screens.ModifierSelection.Illusion.WideNinepatch = nil
Screens.ModifierSelection.Illusion.SelectedContainer = 0

Screens.ModifierSelection.Knockback = { }
Screens.ModifierSelection.Knockback.Control = nil
Screens.ModifierSelection.Knockback.Selected = false
Screens.ModifierSelection.Knockback.RegularNinepatch = nil
Screens.ModifierSelection.Knockback.SelectedNinepatch = nil
Screens.ModifierSelection.Knockback.WideNinepatch = nil
Screens.ModifierSelection.Knockback.SelectedContainer = 0

Screens.ModifierSelection.Frictionless = { }
Screens.ModifierSelection.Frictionless.Control = nil
Screens.ModifierSelection.Frictionless.Selected = false
Screens.ModifierSelection.Frictionless.RegularNinepatch = nil
Screens.ModifierSelection.Frictionless.SelectedNinepatch = nil
Screens.ModifierSelection.Frictionless.WideNinepatch = nil
Screens.ModifierSelection.Frictionless.SelectedContainer = 0
--Current Modifier Containers

Screens.ModifierSelection.ModContainer1 = { }
Screens.ModifierSelection.ModContainer1.Control = nil
Screens.ModifierSelection.ModContainer1.Value = 0

Screens.ModifierSelection.ModContainer2 = { }
Screens.ModifierSelection.ModContainer2.Control = nil
Screens.ModifierSelection.ModContainer2.Value = 0

Screens.ModifierSelection.ModContainer3 = { }
Screens.ModifierSelection.ModContainer3.Control = nil
Screens.ModifierSelection.ModContainer3.Value = 0

local ModifierLookup = {
	[1] = "InvertGravityModifierLauncher",
	[2] = "IncreaseGravityModifierLauncher",
	[3] = "FrictionlessModifierLauncher",
	[4] = "GrowModifierLauncher",
	[5] = "ShrinkModifierLauncher",
	[6] = "KnockbackModifierLauncher",
	[7] = "WallModifierLauncher",
	[8] = "IllusionModifierLauncher",
	
}

Screens.ModifierSelection.Initialize = function()

	width, height = Singularity.Graphics.Screen:GetResolution(0, 0)
	
	--loading the regular icons
	inverseGravityIcon = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\InvertGravityLauncher.png")
	Screens.ModifierSelection.InvertGravity.RegularNinepatch = Singularity.Gui.NinePatch:new(inverseGravityIcon, Vector2:new(inverseGravityIcon:Get_Width(), inverseGravityIcon:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	FeatherlightIcon = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\FeatherLightModifierLauncher.png")
	Screens.ModifierSelection.Featherlight.RegularNinepatch = Singularity.Gui.NinePatch:new(FeatherlightIcon, Vector2:new(FeatherlightIcon:Get_Width() , FeatherlightIcon:Get_Height() ), Vector4:new(0, 0, 0, 0))

	frictionIcon = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\FrictionlessModifierLauncher.png")
	Screens.ModifierSelection.Frictionless.RegularNinepatch = Singularity.Gui.NinePatch:new(frictionIcon, Vector2:new(frictionIcon:Get_Width() , frictionIcon:Get_Height()), Vector4:new(0, 0, 0, 0))

	growIcon = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\GrowModifierLauncher.png")
	Screens.ModifierSelection.Grow.RegularNinepatch = Singularity.Gui.NinePatch:new(growIcon, Vector2:new(growIcon:Get_Width(), growIcon:Get_Height()), Vector4:new(0, 0, 0, 0))

	illusionIcon = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\IllusionModifierLauncher.png")
	Screens.ModifierSelection.Illusion.RegularNinepatch = Singularity.Gui.NinePatch:new(illusionIcon, Vector2:new(illusionIcon:Get_Width(), illusionIcon:Get_Height()), Vector4:new(0, 0, 0, 0))

	knockbackIcon = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\KnockbackModifierLauncher.png")
	Screens.ModifierSelection.Knockback.RegularNinepatch = Singularity.Gui.NinePatch:new(knockbackIcon, Vector2:new(knockbackIcon:Get_Width(), knockbackIcon:Get_Height()), Vector4:new(0, 0, 0, 0))

	shrinkIcon = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\ShrinkModifierLauncher.png")
	Screens.ModifierSelection.Shrink.RegularNinepatch = Singularity.Gui.NinePatch:new(shrinkIcon, Vector2:new(shrinkIcon:Get_Width(), shrinkIcon:Get_Height()), Vector4:new(0, 0, 0, 0))

	wallIcon = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\WallModifierLauncher.png")
	Screens.ModifierSelection.Wall.RegularNinepatch = Singularity.Gui.NinePatch:new(wallIcon, Vector2:new(wallIcon:Get_Width(), wallIcon:Get_Height()), Vector4:new(0, 0, 0, 0))

	
	--loading the selected icon ninepatches
	invertGravitySelected = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\InvertGravityIconSelected.png")
	Screens.ModifierSelection.InvertGravity.SelectedNinepatch = Singularity.Gui.NinePatch:new(invertGravitySelected, Vector2:new(invertGravitySelected:Get_Width(), invertGravitySelected:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	FeatherlightSelected = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\FeatherLightIconSelected.png")
	Screens.ModifierSelection.Featherlight.SelectedNinepatch = Singularity.Gui.NinePatch:new(FeatherlightSelected, Vector2:new(FeatherlightSelected:Get_Width(), FeatherlightSelected:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	growSelected = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\GrowIconSelected.png")
	Screens.ModifierSelection.Grow.SelectedNinepatch = Singularity.Gui.NinePatch:new(growSelected, Vector2:new(growSelected:Get_Width(), growSelected:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	frictionlessSelected = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\FrictionlessIconSelected.png")
	Screens.ModifierSelection.Frictionless.SelectedNinepatch = Singularity.Gui.NinePatch:new(frictionlessSelected, Vector2:new(frictionlessSelected:Get_Width(), frictionlessSelected:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	shrinkSelected = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\ShrinkIconSelected.png")
	Screens.ModifierSelection.Shrink.SelectedNinepatch = Singularity.Gui.NinePatch:new(shrinkSelected, Vector2:new(shrinkSelected:Get_Width(), shrinkSelected:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	illusionSelected = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\IllusionIconSelected.png")
	Screens.ModifierSelection.Illusion.SelectedNinepatch = Singularity.Gui.NinePatch:new(illusionSelected, Vector2:new(illusionSelected:Get_Width(), illusionSelected:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	knockbackSelected = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\KnockbackIconSelected.png")
	Screens.ModifierSelection.Knockback.SelectedNinepatch = Singularity.Gui.NinePatch:new(knockbackSelected, Vector2:new(knockbackSelected:Get_Width(), knockbackSelected:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	wallSelected = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\WallIconSelected.png")
	Screens.ModifierSelection.Wall.SelectedNinepatch = Singularity.Gui.NinePatch:new(wallSelected, Vector2:new(wallSelected:Get_Width(), wallSelected:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	--Loading the wide ninepatches
	invertGravityWide = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\InvertGravityWide.png")
	Screens.ModifierSelection.InvertGravity.WideNinepatch = Singularity.Gui.NinePatch:new(invertGravityWide, Vector2:new(invertGravityWide:Get_Width(), invertGravityWide:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	featherlightWide = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\FeatherlightWide.png")
	Screens.ModifierSelection.Featherlight.WideNinepatch = Singularity.Gui.NinePatch:new(featherlightWide, Vector2:new(featherlightWide:Get_Width(), featherlightWide:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	frictionlessWide = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\FrictionlessWide.png")
	Screens.ModifierSelection.Frictionless.WideNinepatch = Singularity.Gui.NinePatch:new(frictionlessWide, Vector2:new(frictionlessWide:Get_Width(), frictionlessWide:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	growWide = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\GrowWide.png")
	Screens.ModifierSelection.Grow.WideNinepatch = Singularity.Gui.NinePatch:new(growWide, Vector2:new(growWide:Get_Width(), growWide:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	shrinkWide = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\ShrinkWide.png")
	Screens.ModifierSelection.Shrink.WideNinepatch = Singularity.Gui.NinePatch:new(shrinkWide, Vector2:new(shrinkWide:Get_Width(), shrinkWide:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	knockbackWide = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\KnockbackWide.png")
	Screens.ModifierSelection.Knockback.WideNinepatch = Singularity.Gui.NinePatch:new(knockbackWide, Vector2:new(knockbackWide:Get_Width(), knockbackWide:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	wallWide = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\WallWide.png")
	Screens.ModifierSelection.Wall.WideNinepatch = Singularity.Gui.NinePatch:new(wallWide, Vector2:new(wallWide:Get_Width(), wallWide:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	illusionWide = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\Modifier Icons\\IllusionWide.png")
	Screens.ModifierSelection.Illusion.WideNinepatch = Singularity.Gui.NinePatch:new(illusionWide, Vector2:new(illusionWide:Get_Width(), illusionWide:Get_Height()), Vector4:new(0, 0, 0, 0))
	
	--Initializing the team intro panel
	windowBackground = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\WindowBackgroundWide.png")
	ninepatch = Singularity.Gui.NinePatch:new(windowBackground, Vector2:new(windowBackground:Get_Width(), windowBackground:Get_Height()), Vector4:new(0, 0, 0, 0))

	Screens.ModifierSelection.Window = Singularity.Gui.Window:new("Modifier Selection Screen Panel")
	Screens.ModifierSelection.Window:Set_Texture(ninepatch)
	Screens.ModifierSelection.Window:Set_Size(Vector2:new(width, height))
	Screens.ModifierSelection.Window:Set_Position(Vector2:new(0, 0))
	Screens.ModifierSelection.Window:Set_Draggable(false)
	Screens.ModifierSelection.Window:Set_Enabled(false)
	Screens.ModifierSelection.Window:Set_Visible(false)
	Player.HUD.GuiScreen:AddWindow(Screens.ModifierSelection.Window)

	
	--Initializing the Modifier Buttons
	--Inverse Gravity
	Screens.ModifierSelection.InvertGravity.Control = Singularity.Gui.Button:new("Inverse Gravity Button", "")
	Screens.ModifierSelection.InvertGravity.Control:Set_Texture(Screens.ModifierSelection.InvertGravity.RegularNinepatch)
	Screens.ModifierSelection.InvertGravity.Control:Set_Size(Vector2:new(Screens.ModifierSelection.InvertGravity.RegularNinepatch:Get_Width()  * 0.25, Screens.ModifierSelection.InvertGravity.RegularNinepatch:Get_Height() * 0.25))
	Screens.ModifierSelection.InvertGravity.Control:Set_Position(Vector2:new(Screens.ModifierSelection.Window:Get_Size().x * 0.08, Screens.ModifierSelection.Window:Get_Size().y * 0.02))
	Screens.ModifierSelection.InvertGravity.Control.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.ModifierSelection.InverseGravityClick), "Singularity::IDelegate"))
	Screens.ModifierSelection.InvertGravity.SelectedContainer = 0
	Screens.ModifierSelection.Window:AddControl(Screens.ModifierSelection.InvertGravity.Control)

	--Increase Gravity
	Screens.ModifierSelection.Featherlight.Control = Singularity.Gui.Button:new("Increase Gravity Button", "")
	Screens.ModifierSelection.Featherlight.Control:Set_Texture(Screens.ModifierSelection.Featherlight.RegularNinepatch)
	Screens.ModifierSelection.Featherlight.Control:Set_Size(Vector2:new(Screens.ModifierSelection.Featherlight.RegularNinepatch:Get_Width() * 0.25, Screens.ModifierSelection.Featherlight.RegularNinepatch:Get_Height() * 0.25))
	Screens.ModifierSelection.Featherlight.Control:Set_Position(Vector2:new((Screens.ModifierSelection.Window:Get_Size().x * 0.10) + Screens.ModifierSelection.Featherlight.Control:Get_Size().x, Screens.ModifierSelection.Window:Get_Size().y * 0.02))
	Screens.ModifierSelection.Featherlight.Control.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.ModifierSelection.FeatherlightClick), "Singularity::IDelegate"))
	Screens.ModifierSelection.Featherlight.SelectedContainer = 0
	Screens.ModifierSelection.Window:AddControl(Screens.ModifierSelection.Featherlight.Control)

	--Frictionless
	Screens.ModifierSelection.Frictionless.Control = Singularity.Gui.Button:new("Friction Button", "")
	Screens.ModifierSelection.Frictionless.Control:Set_Texture(Screens.ModifierSelection.Frictionless.RegularNinepatch)
	Screens.ModifierSelection.Frictionless.Control:Set_Size(Vector2:new(Screens.ModifierSelection.Frictionless.RegularNinepatch:Get_Width() * 0.25, Screens.ModifierSelection.Frictionless.RegularNinepatch:Get_Height() * 0.25))
	Screens.ModifierSelection.Frictionless.Control:Set_Position(Vector2:new((Screens.ModifierSelection.Window:Get_Size().x * 0.12) + (Screens.ModifierSelection.Frictionless.Control:Get_Size().x * 2), Screens.ModifierSelection.Window:Get_Size().y * 0.02))
	Screens.ModifierSelection.Frictionless.Control.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.ModifierSelection.FrictionlessClick), "Singularity::IDelegate"))
	Screens.ModifierSelection.Frictionless.SelectedContainer = 0
	Screens.ModifierSelection.Window:AddControl(Screens.ModifierSelection.Frictionless.Control)

	--Grow
	Screens.ModifierSelection.Grow.Control = Singularity.Gui.Button:new("Grow Modifier Button", "")
	Screens.ModifierSelection.Grow.Control:Set_Texture(Screens.ModifierSelection.Grow.RegularNinepatch)
	Screens.ModifierSelection.Grow.Control:Set_Size(Vector2:new(Screens.ModifierSelection.Grow.RegularNinepatch:Get_Width() * 0.25, Screens.ModifierSelection.Grow.RegularNinepatch:Get_Height() * 0.25))
	Screens.ModifierSelection.Grow.Control:Set_Position(Vector2:new((Screens.ModifierSelection.Window:Get_Size().x * 0.14) + (Screens.ModifierSelection.Grow.Control:Get_Size().x * 3), Screens.ModifierSelection.Window:Get_Size().y * 0.02))
	Screens.ModifierSelection.Grow.Control.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.ModifierSelection.GrowClick), "Singularity::IDelegate"))
	Screens.ModifierSelection.Grow.SelectedContainer = 0
	Screens.ModifierSelection.Window:AddControl(Screens.ModifierSelection.Grow.Control)

	--Shrink
	Screens.ModifierSelection.Shrink.Control = Singularity.Gui.Button:new("Shrink Modifier Button", "")
	Screens.ModifierSelection.Shrink.Control:Set_Texture(Screens.ModifierSelection.Shrink.RegularNinepatch)
	Screens.ModifierSelection.Shrink.Control:Set_Size(Vector2:new(Screens.ModifierSelection.Shrink.RegularNinepatch:Get_Width() * 0.25, Screens.ModifierSelection.Shrink.RegularNinepatch:Get_Height() * 0.25))
	Screens.ModifierSelection.Shrink.Control:Set_Position(Vector2:new((Screens.ModifierSelection.Window:Get_Size().x * 0.16) + (Screens.ModifierSelection.Shrink.Control:Get_Size().x * 4), Screens.ModifierSelection.Window:Get_Size().y * 0.02))
	Screens.ModifierSelection.Shrink.Control.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.ModifierSelection.ShrinkClick), "Singularity::IDelegate"))
	Screens.ModifierSelection.Shrink.SelectedContainer = 0
	Screens.ModifierSelection.Window:AddControl(Screens.ModifierSelection.Shrink.Control)
	
	--Knockback
	Screens.ModifierSelection.Knockback.Control = Singularity.Gui.Button:new("Knockback Modifier Button", "")
	Screens.ModifierSelection.Knockback.Control:Set_Texture(Screens.ModifierSelection.Knockback.RegularNinepatch)
	Screens.ModifierSelection.Knockback.Control:Set_Size(Vector2:new(Screens.ModifierSelection.Knockback.RegularNinepatch:Get_Width() * 0.25, Screens.ModifierSelection.Knockback.RegularNinepatch:Get_Height() * 0.25))
	Screens.ModifierSelection.Knockback.Control:Set_Position(Vector2:new((Screens.ModifierSelection.Window:Get_Size().x * 0.18) + (Screens.ModifierSelection.Knockback.Control:Get_Size().x * 5), Screens.ModifierSelection.Window:Get_Size().y * 0.02))
	Screens.ModifierSelection.Knockback.Control.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.ModifierSelection.KnockbackClick), "Singularity::IDelegate"))
	Screens.ModifierSelection.Knockback.SelectedContainer = 0
	Screens.ModifierSelection.Window:AddControl(Screens.ModifierSelection.Knockback.Control)

	--Wall
	Screens.ModifierSelection.Wall.Control = Singularity.Gui.Button:new("Wall Modifier Button", "")
	Screens.ModifierSelection.Wall.Control:Set_Texture(Screens.ModifierSelection.Wall.RegularNinepatch)
	Screens.ModifierSelection.Wall.Control:Set_Size(Vector2:new(Screens.ModifierSelection.Wall.RegularNinepatch:Get_Width() * 0.25, Screens.ModifierSelection.Wall.RegularNinepatch:Get_Height() * 0.25))
	Screens.ModifierSelection.Wall.Control:Set_Position(Vector2:new((Screens.ModifierSelection.Window:Get_Size().x * 0.20) + (Screens.ModifierSelection.Wall.Control:Get_Size().x * 6), Screens.ModifierSelection.Window:Get_Size().y * 0.02))
	Screens.ModifierSelection.Wall.Control.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.ModifierSelection.WallClick), "Singularity::IDelegate"))
	Screens.ModifierSelection.Wall.SelectedContainer = 0
	Screens.ModifierSelection.Window:AddControl(Screens.ModifierSelection.Wall.Control)

	--Illusion
	Screens.ModifierSelection.Illusion.Control = Singularity.Gui.Button:new("Illusion Modifier Button", "")
	Screens.ModifierSelection.Illusion.Control:Set_Texture(Screens.ModifierSelection.Illusion.RegularNinepatch)
	Screens.ModifierSelection.Illusion.Control:Set_Size(Vector2:new(Screens.ModifierSelection.Illusion.RegularNinepatch:Get_Width() * 0.25, Screens.ModifierSelection.Illusion.RegularNinepatch:Get_Height() * 0.25))
	Screens.ModifierSelection.Illusion.Control:Set_Position(Vector2:new((Screens.ModifierSelection.Window:Get_Size().x * 0.22) + (Screens.ModifierSelection.Illusion.Control:Get_Size().x * 7), Screens.ModifierSelection.Window:Get_Size().y * 0.02))
	Screens.ModifierSelection.Illusion.Control.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.ModifierSelection.IllusionClick), "Singularity::IDelegate"))
	Screens.ModifierSelection.Illusion.SelectedContainer = 0
	Screens.ModifierSelection.Window:AddControl(Screens.ModifierSelection.Illusion.Control)
		
	--"Current Modifier Combination" Label
	label = Singularity.Gui.Label:new("Weapon Combination Label", "Current Modifier Combination")
	label:Set_Font(Singularity.Gui.Font:Get_Font("Franklin Gothic24 Bold"))
	label:Set_Color(Color(0, 0, 0, 1))
	label:Set_Size(Vector2:new(Singularity.Gui.Font:GetStringWidth(label:Get_Font(), label:Get_Text()), 30))
	label:Set_Position(Vector2:new(Screens.ModifierSelection.Window:Get_Size().x / 2 - (Singularity.Gui.Font:GetStringWidth(label:Get_Font(), label:Get_Text()) / 2),Screens.ModifierSelection.Window:Get_Size().y * 0.25))
	Screens.ModifierSelection.Window:AddControl(label)
	
	--Current Modifier Slot images
	blankLoadout = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\WeaponCombinationPH.png")
	Screens.ModifierSelection.BlankLoadoutNP = Singularity.Gui.NinePatch:new(blankLoadout, Vector2:new(blankLoadout:Get_Width(), blankLoadout:Get_Height()), Vector4:new(0, 0, 0, 0))

	Screens.ModifierSelection.ModContainer1.Control = Singularity.Gui.Image:new("Modifier Container 1")
	Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
	Screens.ModifierSelection.ModContainer1.Control:Set_Size(Vector2:new(Screens.ModifierSelection.BlankLoadoutNP:Get_Width() * 0.5, Screens.ModifierSelection.BlankLoadoutNP:Get_Height() * 0.35))
	Screens.ModifierSelection.ModContainer1.Control:Set_Position(Vector2:new((Screens.ModifierSelection.Window:Get_Size().x * 0.22) + (0 * (Screens.ModifierSelection.ModContainer1.Control:Get_Size().x + 20.0)), Screens.ModifierSelection.Window:Get_Size().y * 0.45))
	Screens.ModifierSelection.ModContainer1.SelectedValue = 0
	Screens.ModifierSelection.Window:AddControl(Screens.ModifierSelection.ModContainer1.Control)

	Screens.ModifierSelection.ModContainer2.Control = Singularity.Gui.Image:new("Modifier Container 2")
	Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
	Screens.ModifierSelection.ModContainer2.Control:Set_Size(Vector2:new(Screens.ModifierSelection.BlankLoadoutNP:Get_Width() * 0.5, Screens.ModifierSelection.BlankLoadoutNP:Get_Height() * 0.35))
	Screens.ModifierSelection.ModContainer2.Control:Set_Position(Vector2:new((Screens.ModifierSelection.Window:Get_Size().x * 0.22) + (1 * (Screens.ModifierSelection.ModContainer2.Control:Get_Size().x + 20.0)), Screens.ModifierSelection.Window:Get_Size().y * 0.45))
	Screens.ModifierSelection.ModContainer2.SelectedValue = 0
	Screens.ModifierSelection.Window:AddControl(Screens.ModifierSelection.ModContainer2.Control)
	
	Screens.ModifierSelection.ModContainer3.Control = Singularity.Gui.Image:new("Modifier Container 3")
	Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
	Screens.ModifierSelection.ModContainer3.Control:Set_Size(Vector2:new(Screens.ModifierSelection.BlankLoadoutNP:Get_Width() * 0.5, Screens.ModifierSelection.BlankLoadoutNP:Get_Height() * 0.35))
	Screens.ModifierSelection.ModContainer3.Control:Set_Position(Vector2:new((Screens.ModifierSelection.Window:Get_Size().x * 0.22) + (2 * (Screens.ModifierSelection.ModContainer3.Control:Get_Size().x + 20.0)), Screens.ModifierSelection.Window:Get_Size().y * 0.45))
	Screens.ModifierSelection.ModContainer3.SelectedValue = 0
	Screens.ModifierSelection.Window:AddControl(Screens.ModifierSelection.ModContainer3.Control)
	
	--Switching Selection screen buttons
	modifierSelection = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\ModifierSwitchButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(modifierSelection, Vector2:new(modifierSelection:Get_Width(), modifierSelection:Get_Height()), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Weapon Selection Button", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(ninepatch:Get_Width() * 0.3, ninepatch:Get_Height() * 0.3))
	button:Set_Position(Vector2:new(Screens.ModifierSelection.Window:Get_Size().x * 0.05, Screens.ModifierSelection.Window:Get_Size().y * 0.80))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.ModifierSelection.Switch), "Singularity::IDelegate"))
	Screens.ModifierSelection.Window:AddControl(button)

	--Reset Button
	resetButton = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\ResetButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(resetButton, Vector2:new(resetButton:Get_Width(), resetButton:Get_Height()), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Reset Button - Modifier Selection", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(139,59))
	button:Set_Position(Vector2:new(Screens.ModifierSelection.Window:Get_Size().x * 0.60, Screens.ModifierSelection.Window:Get_Size().y * 0.90))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.ModifierSelection.Reset), "Singularity::IDelegate"))
	Screens.ModifierSelection.Window:AddControl(button)

	--Cancel Buttons
	cancelButton = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\CancelButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(cancelButton, Vector2:new(cancelButton:Get_Width(), cancelButton:Get_Height()), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Cancel Changes Button - Weapon Selection", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(139,59))
	button:Set_Position(Vector2:new(Screens.ModifierSelection.Window:Get_Size().x * 0.72, Screens.ModifierSelection.Window:Get_Size().y * 0.90))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.ModifierSelection.Cancel), "Singularity::IDelegate"))
	Screens.ModifierSelection.Window:AddControl(button)

	--Accept Button
	okButton = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Menus\\AcceptButton.png")
	ninepatch = Singularity.Gui.NinePatch:new(okButton, Vector2:new(okButton:Get_Width(), okButton:Get_Height()), Vector4:new(0, 0, 0, 0))

	button = Singularity.Gui.Button:new("Accept Changes Button - Modifier Selection", "")
	button:Set_Texture(ninepatch)
	button:Set_Size(Vector2:new(139,59))
	button:Set_Position(Vector2:new(Screens.ModifierSelection.Window:Get_Size().x * 0.84, Screens.ModifierSelection.Window:Get_Size().y * 0.90))
	button.Click:Add(tolua.cast(Singularity.Scripting.LuaControlMouseDelegate:new(Screens.ModifierSelection.AcceptChanges), "Singularity::IDelegate"))
	Screens.ModifierSelection.Window:AddControl(button)

	Util.Debug("Screens[\"Modifier Selection Screens\"] loaded")
end

Screens.ModifierSelection.Reset = function()
	Util.Debug("Reset clicked")
	
	Audio.MenuEmitter:Play(2)
	
	--Reseting takes player's choices and blanks them
	--Reseting the buttons
	if(Screens.ModifierSelection.ModContainer1.SelectedValue == 1 or Screens.ModifierSelection.ModContainer2.SelectedValue == 1 or Screens.ModifierSelection.ModContainer3.SelectedValue == 1) then
		Screens.ModifierSelection.InvertGravity.Selected = false
		Screens.ModifierSelection.InvertGravity.SelectedContainer = 0
		Screens.ModifierSelection.InvertGravity.Control:Set_Texture(Screens.ModifierSelection.InvertGravity.RegularNinepatch)
	end
	
	if(Screens.ModifierSelection.ModContainer1.SelectedValue == 2 or Screens.ModifierSelection.ModContainer2.SelectedValue == 2 or Screens.ModifierSelection.ModContainer3.SelectedValue == 2) then
		Screens.ModifierSelection.Featherlight.Selected = false
		Screens.ModifierSelection.Featherlight.SelectedContainer = 0
		Screens.ModifierSelection.Featherlight.Control:Set_Texture(Screens.ModifierSelection.Featherlight.RegularNinepatch)
	end
	
	if(Screens.ModifierSelection.ModContainer1.SelectedValue == 3 or Screens.ModifierSelection.ModContainer2.SelectedValue == 3 or Screens.ModifierSelection.ModContainer3.SelectedValue == 3) then
		Screens.ModifierSelection.Frictionless.Selected = false
		Screens.ModifierSelection.Frictionless.SelectedContainer = 0
		Screens.ModifierSelection.Frictionless.Control:Set_Texture(Screens.ModifierSelection.Frictionless.RegularNinepatch)
	end
	
	if(Screens.ModifierSelection.ModContainer1.SelectedValue == 4 or Screens.ModifierSelection.ModContainer2.SelectedValue == 4 or Screens.ModifierSelection.ModContainer3.SelectedValue == 4) then
		Screens.ModifierSelection.Grow.Selected = false
		Screens.ModifierSelection.Grow.SelectedContainer = 0
		Screens.ModifierSelection.Grow.Control:Set_Texture(Screens.ModifierSelection.Grow.RegularNinepatch)
	end
	
	if(Screens.ModifierSelection.ModContainer1.SelectedValue == 5 or Screens.ModifierSelection.ModContainer2.SelectedValue == 5 or Screens.ModifierSelection.ModContainer3.SelectedValue == 5) then
		Screens.ModifierSelection.Shrink.Selected = false
		Screens.ModifierSelection.Shrink.SelectedContainer = 0
		Screens.ModifierSelection.Shrink.Control:Set_Texture(Screens.ModifierSelection.Shrink.RegularNinepatch)
	end
	
	if(Screens.ModifierSelection.ModContainer1.SelectedValue == 6 or Screens.ModifierSelection.ModContainer2.SelectedValue == 6 or Screens.ModifierSelection.ModContainer3.SelectedValue == 6) then
		Screens.ModifierSelection.Knockback.Selected = false
		Screens.ModifierSelection.Knockback.SelectedContainer = 0
		Screens.ModifierSelection.Knockback.Control:Set_Texture(Screens.ModifierSelection.Knockback.RegularNinepatch)
	end
	
	if(Screens.ModifierSelection.ModContainer1.SelectedValue == 7 or Screens.ModifierSelection.ModContainer2.SelectedValue == 7 or Screens.ModifierSelection.ModContainer3.SelectedValue == 7) then
		Screens.ModifierSelection.Wall.Selected = false
		Screens.ModifierSelection.Wall.SelectedContainer = 0
		Screens.ModifierSelection.Wall.Control:Set_Texture(Screens.ModifierSelection.Wall.RegularNinepatch)
	end
	
	if(Screens.ModifierSelection.ModContainer1.SelectedValue == 8 or Screens.ModifierSelection.ModContainer2.SelectedValue == 8 or Screens.ModifierSelection.ModContainer3.SelectedValue == 8) then
		Screens.ModifierSelection.Illusion.Selected = false
		Screens.ModifierSelection.Illusion.SelectedContainer = 0
		Screens.ModifierSelection.Illusion.Control:Set_Texture(Screens.ModifierSelection.Illusion.RegularNinepatch)
	end
	
	--Resetting the choice containers
	Screens.ModifierSelection.ModContainer1.SelectedValue = 0
	Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
	
	Screens.ModifierSelection.ModContainer2.SelectedValue = 0
	Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
	
	Screens.ModifierSelection.ModContainer3.SelectedValue = 0
	Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
	
end

Screens.ModifierSelection.InverseGravityClick = function()
	Util.Debug("Inverse Gravity clicked")
	
	Audio.MenuEmitter:Play(2)
	
	if(Screens.ModifierSelection.InvertGravity.Selected == false) then
		
		--Figuring out which container to put it in
		if(Screens.ModifierSelection.ModContainer1.SelectedValue == 0 and Screens.ModifierSelection.InvertGravity.SelectedContainer == 0) then
			Screens.ModifierSelection.InvertGravity.SelectedContainer = 1
			Screens.ModifierSelection.ModContainer1.SelectedValue = 1
			Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.InvertGravity.WideNinepatch)
			Screens.ModifierSelection.InvertGravity.Selected = true
			Screens.ModifierSelection.InvertGravity.Control:Set_Texture(Screens.ModifierSelection.InvertGravity.SelectedNinepatch)
		elseif(Screens.ModifierSelection.ModContainer2.SelectedValue == 0 and Screens.ModifierSelection.InvertGravity.SelectedContainer == 0) then
			Screens.ModifierSelection.InvertGravity.SelectedContainer = 2
			Screens.ModifierSelection.ModContainer2.SelectedValue = 1
			Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.InvertGravity.WideNinepatch)
			Screens.ModifierSelection.InvertGravity.Selected = true
			Screens.ModifierSelection.InvertGravity.Control:Set_Texture(Screens.ModifierSelection.InvertGravity.SelectedNinepatch)
		elseif(Screens.ModifierSelection.ModContainer3.SelectedValue == 0 and Screens.ModifierSelection.InvertGravity.SelectedContainer == 0) then
			Screens.ModifierSelection.InvertGravity.SelectedContainer = 3
			Screens.ModifierSelection.ModContainer3.SelectedValue = 1
			Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.InvertGravity.WideNinepatch)
			Screens.ModifierSelection.InvertGravity.Selected = true
			Screens.ModifierSelection.InvertGravity.Control:Set_Texture(Screens.ModifierSelection.InvertGravity.SelectedNinepatch)
		end
		
	else
		Screens.ModifierSelection.InvertGravity.Selected = false
		Screens.ModifierSelection.InvertGravity.Control:Set_Texture(Screens.ModifierSelection.InvertGravity.RegularNinepatch)
		
		if(Screens.ModifierSelection.InvertGravity.SelectedContainer == 1) then
			Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.InvertGravity.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer1.SelectedValue = 0
		elseif(Screens.ModifierSelection.InvertGravity.SelectedContainer == 2) then
			Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.InvertGravity.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer2.SelectedValue = 0
		elseif(Screens.ModifierSelection.InvertGravity.SelectedContainer == 3) then
			Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.InvertGravity.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer3.SelectedValue = 0
		end
	end

end

Screens.ModifierSelection.FeatherlightClick = function()
	Util.Debug("Increase Gravity clicked")
	Audio.MenuEmitter:Play(2)
	if(Screens.ModifierSelection.Featherlight.Selected == false) then
		--Figuring out which container to put it in
		if(Screens.ModifierSelection.ModContainer1.SelectedValue == 0 and Screens.ModifierSelection.Featherlight.SelectedContainer == 0) then
			Screens.ModifierSelection.Featherlight.SelectedContainer = 1
			Screens.ModifierSelection.ModContainer1.SelectedValue = 2
			Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.Featherlight.WideNinepatch)
			Screens.ModifierSelection.Featherlight.Selected = true		
			Screens.ModifierSelection.Featherlight.Control:Set_Texture(Screens.ModifierSelection.Featherlight.SelectedNinepatch)		
		elseif(Screens.ModifierSelection.ModContainer2.SelectedValue == 0 and Screens.ModifierSelection.Featherlight.SelectedContainer == 0) then
			Screens.ModifierSelection.Featherlight.SelectedContainer = 2
			Screens.ModifierSelection.ModContainer2.SelectedValue = 2
			Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.Featherlight.WideNinepatch)
			Screens.ModifierSelection.Featherlight.Selected = true		
			Screens.ModifierSelection.Featherlight.Control:Set_Texture(Screens.ModifierSelection.Featherlight.SelectedNinepatch)		
		elseif(Screens.ModifierSelection.ModContainer3.SelectedValue == 0 and Screens.ModifierSelection.Featherlight.SelectedContainer == 0) then
			Screens.ModifierSelection.Featherlight.SelectedContainer = 3
			Screens.ModifierSelection.ModContainer3.SelectedValue = 2
			Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.Featherlight.WideNinepatch)
			Screens.ModifierSelection.Featherlight.Selected = true		
			Screens.ModifierSelection.Featherlight.Control:Set_Texture(Screens.ModifierSelection.Featherlight.SelectedNinepatch)		
		end
		
	else
		Screens.ModifierSelection.Featherlight.Selected = false
		Screens.ModifierSelection.Featherlight.Control:Set_Texture(Screens.ModifierSelection.Featherlight.RegularNinepatch)
		
		if(Screens.ModifierSelection.Featherlight.SelectedContainer == 1) then
			Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Featherlight.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer1.SelectedValue = 0
		elseif(Screens.ModifierSelection.Featherlight.SelectedContainer == 2) then
			Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Featherlight.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer2.SelectedValue = 0
		elseif(Screens.ModifierSelection.Featherlight.SelectedContainer == 3) then
			Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Featherlight.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer3.SelectedValue = 0
		end
	end
end

Screens.ModifierSelection.FrictionlessClick = function()
	Util.Debug("Frictionless clicked")
	Audio.MenuEmitter:Play(2)
	if(Screens.ModifierSelection.Frictionless.Selected == false) then
		--Figuring out which container to put it in
		if(Screens.ModifierSelection.ModContainer1.SelectedValue == 0 and Screens.ModifierSelection.Frictionless.SelectedContainer == 0) then
			Screens.ModifierSelection.Frictionless.SelectedContainer = 1
			Screens.ModifierSelection.ModContainer1.SelectedValue = 3
			Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.Frictionless.WideNinepatch)
			Screens.ModifierSelection.Frictionless.Selected = true
			Screens.ModifierSelection.Frictionless.Control:Set_Texture(Screens.ModifierSelection.Frictionless.SelectedNinepatch)
		elseif(Screens.ModifierSelection.ModContainer2.SelectedValue == 0 and Screens.ModifierSelection.Frictionless.SelectedContainer == 0) then
			Screens.ModifierSelection.Frictionless.SelectedContainer = 2
			Screens.ModifierSelection.ModContainer2.SelectedValue = 3
			Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.Frictionless.WideNinepatch)
			Screens.ModifierSelection.Frictionless.Selected = true
			Screens.ModifierSelection.Frictionless.Control:Set_Texture(Screens.ModifierSelection.Frictionless.SelectedNinepatch)
		elseif(Screens.ModifierSelection.ModContainer3.SelectedValue == 0 and Screens.ModifierSelection.Frictionless.SelectedContainer == 0) then
			Screens.ModifierSelection.Frictionless.SelectedContainer = 3
			Screens.ModifierSelection.ModContainer3.SelectedValue = 3
			Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.Frictionless.RegularNinepatch)
			Screens.ModifierSelection.Frictionless.Selected = true
			Screens.ModifierSelection.Frictionless.Control:Set_Texture(Screens.ModifierSelection.Frictionless.SelectedNinepatch)
		end
		
	else
		Screens.ModifierSelection.Frictionless.Selected = false
		Screens.ModifierSelection.Frictionless.Control:Set_Texture(Screens.ModifierSelection.Frictionless.RegularNinepatch)
		
		if(Screens.ModifierSelection.Frictionless.SelectedContainer == 1) then
			Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Frictionless.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer1.SelectedValue = 0
		elseif(Screens.ModifierSelection.Frictionless.SelectedContainer == 2) then
			Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Frictionless.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer2.SelectedValue = 0
		elseif(Screens.ModifierSelection.Frictionless.SelectedContainer == 3) then
			Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Frictionless.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer3.SelectedValue = 0
		end
	end
end

Screens.ModifierSelection.GrowClick = function()
	Util.Debug("Grow clicked")
	Audio.MenuEmitter:Play(2)
	if(Screens.ModifierSelection.Grow.Selected == false) then		
		--Figuring out which container to put it in
		if(Screens.ModifierSelection.ModContainer1.SelectedValue == 0 and Screens.ModifierSelection.Grow.SelectedContainer == 0) then
			Screens.ModifierSelection.Grow.SelectedContainer = 1
			Screens.ModifierSelection.ModContainer1.SelectedValue = 4
			Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.Grow.WideNinepatch)
			Screens.ModifierSelection.Grow.Selected = true
			Screens.ModifierSelection.Grow.Control:Set_Texture(Screens.ModifierSelection.Grow.SelectedNinepatch)
		elseif(Screens.ModifierSelection.ModContainer2.SelectedValue == 0 and Screens.ModifierSelection.Grow.SelectedContainer == 0) then
			Screens.ModifierSelection.Grow.SelectedContainer = 2
			Screens.ModifierSelection.ModContainer2.SelectedValue = 4
			Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.Grow.WideNinepatch)
			Screens.ModifierSelection.Grow.Selected = true
			Screens.ModifierSelection.Grow.Control:Set_Texture(Screens.ModifierSelection.Grow.SelectedNinepatch)
		elseif(Screens.ModifierSelection.ModContainer3.SelectedValue == 0 and Screens.ModifierSelection.Grow.SelectedContainer == 0) then
			Screens.ModifierSelection.Grow.SelectedContainer = 3
			Screens.ModifierSelection.ModContainer3.SelectedValue = 4
			Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.Grow.WideNinepatch)
			Screens.ModifierSelection.Grow.Selected = true
			Screens.ModifierSelection.Grow.Control:Set_Texture(Screens.ModifierSelection.Grow.SelectedNinepatch)
		end
		
	else
		Screens.ModifierSelection.Grow.Selected = false
		Screens.ModifierSelection.Grow.Control:Set_Texture(Screens.ModifierSelection.Grow.RegularNinepatch)
		
		if(Screens.ModifierSelection.Grow.SelectedContainer == 1) then
			Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Grow.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer1.SelectedValue = 0
		elseif(Screens.ModifierSelection.Grow.SelectedContainer == 2) then
			Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Grow.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer2.SelectedValue = 0
		elseif(Screens.ModifierSelection.Grow.SelectedContainer == 3) then
			Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Grow.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer3.SelectedValue = 0
		end
	end
end

Screens.ModifierSelection.ShrinkClick = function()
	Util.Debug("Shrink clicked")
	Audio.MenuEmitter:Play(2)
	if(Screens.ModifierSelection.Shrink.Selected == false) then
		--Figuring out which container to put it in
		if(Screens.ModifierSelection.ModContainer1.SelectedValue == 0 and Screens.ModifierSelection.Shrink.SelectedContainer == 0) then
			Screens.ModifierSelection.Shrink.SelectedContainer = 1
			Screens.ModifierSelection.ModContainer1.SelectedValue = 5
			Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.Shrink.WideNinepatch)
			Screens.ModifierSelection.Shrink.Selected = true
			Screens.ModifierSelection.Shrink.Control:Set_Texture(Screens.ModifierSelection.Shrink.SelectedNinepatch)
		elseif(Screens.ModifierSelection.ModContainer2.SelectedValue == 0 and Screens.ModifierSelection.Shrink.SelectedContainer == 0) then
			Screens.ModifierSelection.Shrink.SelectedContainer = 2
			Screens.ModifierSelection.ModContainer2.SelectedValue = 5
			Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.Shrink.WideNinepatch)
			Screens.ModifierSelection.Shrink.Selected = true
			Screens.ModifierSelection.Shrink.Control:Set_Texture(Screens.ModifierSelection.Shrink.SelectedNinepatch)
		elseif(Screens.ModifierSelection.ModContainer3.SelectedValue == 0 and Screens.ModifierSelection.Shrink.SelectedContainer == 0) then
			Screens.ModifierSelection.Shrink.SelectedContainer = 3
			Screens.ModifierSelection.ModContainer3.SelectedValue = 5
			Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.Shrink.WideNinepatch)
			Screens.ModifierSelection.Shrink.Selected = true
			Screens.ModifierSelection.Shrink.Control:Set_Texture(Screens.ModifierSelection.Shrink.SelectedNinepatch)
		end
		
	else
		Screens.ModifierSelection.Shrink.Selected = false
		Screens.ModifierSelection.Shrink.Control:Set_Texture(Screens.ModifierSelection.Shrink.RegularNinepatch)
		
		if(Screens.ModifierSelection.Shrink.SelectedContainer == 1) then
			Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Shrink.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer1.SelectedValue = 0
		elseif(Screens.ModifierSelection.Shrink.SelectedContainer == 2) then
			Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Shrink.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer2.SelectedValue = 0
		elseif(Screens.ModifierSelection.Shrink.SelectedContainer == 3) then
			Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Shrink.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer3.SelectedValue = 0
		end
	end
end

Screens.ModifierSelection.KnockbackClick = function()
	Util.Debug("Knockback clicked")
	Audio.MenuEmitter:Play(2)
	if(Screens.ModifierSelection.Knockback.Selected == false) then
		--Figuring out which container to put it in
		if(Screens.ModifierSelection.ModContainer1.SelectedValue == 0 and Screens.ModifierSelection.Knockback.SelectedContainer == 0) then
			Screens.ModifierSelection.Knockback.SelectedContainer = 1
			Screens.ModifierSelection.ModContainer1.SelectedValue = 6
			Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.Knockback.WideNinepatch)
			Screens.ModifierSelection.Knockback.Selected = true
			Screens.ModifierSelection.Knockback.Control:Set_Texture(Screens.ModifierSelection.Knockback.SelectedNinepatch)
		elseif(Screens.ModifierSelection.ModContainer2.SelectedValue == 0 and Screens.ModifierSelection.Knockback.SelectedContainer == 0) then
			Screens.ModifierSelection.Knockback.SelectedContainer = 2
			Screens.ModifierSelection.ModContainer2.SelectedValue = 6
			Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.Knockback.WideNinepatch)
			Screens.ModifierSelection.Knockback.Selected = true
			Screens.ModifierSelection.Knockback.Control:Set_Texture(Screens.ModifierSelection.Knockback.SelectedNinepatch)
		elseif(Screens.ModifierSelection.ModContainer3.SelectedValue == 0 and Screens.ModifierSelection.Knockback.SelectedContainer == 0) then
			Screens.ModifierSelection.Knockback.SelectedContainer = 3
			Screens.ModifierSelection.ModContainer3.SelectedValue = 6
			Screens.ModifierSelection.Knockback.Selected = true
			Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.Knockback.WideNinepatch)
			Screens.ModifierSelection.Knockback.Control:Set_Texture(Screens.ModifierSelection.Knockback.SelectedNinepatch)
		end
		
	else
		Screens.ModifierSelection.Knockback.Selected = false
		Screens.ModifierSelection.Knockback.Control:Set_Texture(Screens.ModifierSelection.Knockback.RegularNinepatch)
		
		if(Screens.ModifierSelection.Knockback.SelectedContainer == 1) then
			Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Knockback.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer1.SelectedValue = 0
		elseif(Screens.ModifierSelection.Knockback.SelectedContainer == 2) then
			Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Knockback.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer2.SelectedValue = 0
		elseif(Screens.ModifierSelection.Knockback.SelectedContainer == 3) then
			Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Knockback.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer3.SelectedValue = 0
		end
	end
end

Screens.ModifierSelection.WallClick = function()
	Util.Debug("Wall clicked")
	Audio.MenuEmitter:Play(2)
	if(Screens.ModifierSelection.Wall.Selected == false) then
		--Figuring out which container to put it in
		if(Screens.ModifierSelection.ModContainer1.SelectedValue == 0 and Screens.ModifierSelection.Wall.SelectedContainer == 0) then
			Screens.ModifierSelection.Wall.SelectedContainer = 1
			Screens.ModifierSelection.ModContainer1.SelectedValue = 7
			Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.Wall.WideNinepatch)
			Screens.ModifierSelection.Wall.Selected = true
			Screens.ModifierSelection.Wall.Control:Set_Texture(Screens.ModifierSelection.Wall.SelectedNinepatch)
		elseif(Screens.ModifierSelection.ModContainer2.SelectedValue == 0 and Screens.ModifierSelection.Wall.SelectedContainer == 0) then
			Screens.ModifierSelection.Wall.SelectedContainer = 2
			Screens.ModifierSelection.ModContainer2.SelectedValue = 7
			Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.Wall.WideNinepatch)
			Screens.ModifierSelection.Wall.Selected = true
			Screens.ModifierSelection.Wall.Control:Set_Texture(Screens.ModifierSelection.Wall.SelectedNinepatch)
		elseif(Screens.ModifierSelection.ModContainer3.SelectedValue == 0 and Screens.ModifierSelection.Wall.SelectedContainer == 0) then
			Screens.ModifierSelection.Wall.SelectedContainer = 3
			Screens.ModifierSelection.ModContainer3.SelectedValue = 7
			Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.Wall.WideNinepatch)
			Screens.ModifierSelection.Wall.Selected = true
			Screens.ModifierSelection.Wall.Control:Set_Texture(Screens.ModifierSelection.Wall.SelectedNinepatch)
		end
		
	else
		Screens.ModifierSelection.Wall.Selected = false
		Screens.ModifierSelection.Wall.Control:Set_Texture(Screens.ModifierSelection.Wall.RegularNinepatch)
		
		if(Screens.ModifierSelection.Wall.SelectedContainer == 1) then
			Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Wall.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer1.SelectedValue = 0
		elseif(Screens.ModifierSelection.Wall.SelectedContainer == 2) then
			Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Wall.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer2.SelectedValue = 0
		elseif(Screens.ModifierSelection.Wall.SelectedContainer == 3) then
			Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Wall.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer3.SelectedValue = 0
		end
	end
end

Screens.ModifierSelection.IllusionClick = function()
	Util.Debug("Illusion clicked")
	Audio.MenuEmitter:Play(2)
	if(Screens.ModifierSelection.Illusion.Selected == false) then
		--Figuring out which container to put it in
		if(Screens.ModifierSelection.ModContainer1.SelectedValue == 0 and Screens.ModifierSelection.Illusion.SelectedContainer == 0) then
			Screens.ModifierSelection.Illusion.SelectedContainer = 1
			Screens.ModifierSelection.ModContainer1.SelectedValue = 8
			Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.Illusion.WideNinepatch)
			Screens.ModifierSelection.Illusion.Selected = true
			Screens.ModifierSelection.Illusion.Control:Set_Texture(Screens.ModifierSelection.Illusion.SelectedNinepatch)
		elseif(Screens.ModifierSelection.ModContainer2.SelectedValue == 0 and Screens.ModifierSelection.Illusion.SelectedContainer == 0) then
			Screens.ModifierSelection.Illusion.SelectedContainer = 2
			Screens.ModifierSelection.ModContainer2.SelectedValue = 8
			Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.Illusion.WideNinepatch)
			Screens.ModifierSelection.Illusion.Selected = true
			Screens.ModifierSelection.Illusion.Control:Set_Texture(Screens.ModifierSelection.Illusion.SelectedNinepatch)
		elseif(Screens.ModifierSelection.ModContainer3.SelectedValue == 0 and Screens.ModifierSelection.Illusion.SelectedContainer == 0) then
			Screens.ModifierSelection.Illusion.SelectedContainer = 3
			Screens.ModifierSelection.ModContainer3.SelectedValue = 8
			Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.Illusion.WideNinepatch)
			Screens.ModifierSelection.Illusion.Selected = true
			Screens.ModifierSelection.Illusion.Control:Set_Texture(Screens.ModifierSelection.Illusion.SelectedNinepatch)
		end
		
	else
		Screens.ModifierSelection.Illusion.Selected = false
		Screens.ModifierSelection.Illusion.Control:Set_Texture(Screens.ModifierSelection.Illusion.RegularNinepatch)
		
		if(Screens.ModifierSelection.Illusion.SelectedContainer == 1) then
			Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Illusion.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer1.SelectedValue = 0
		elseif(Screens.ModifierSelection.Illusion.SelectedContainer == 2) then
			Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Illusion.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer2.SelectedValue = 0
		elseif(Screens.ModifierSelection.Illusion.SelectedContainer == 3) then
			Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
			Screens.ModifierSelection.Illusion.SelectedContainer = 0
			Screens.ModifierSelection.ModContainer3.SelectedValue = 0
		end
	end
end

--Checks the controls every time the screen is made visible
Screens.ModifierSelection.CheckControls = function()

	local incomingMods = { }
	local modIndexes = { }
	
	Util.Debug("Weapons list size"..table.getn(Player.Client:GetWeapons()))
	
	for i, v in ipairs(Player.Client:GetWeapons()) do
		if(string.find(v.Type, "ModifierLauncher")) then
			table.insert(incomingMods, v.Type)
		end
	end
	
	--determining the lookup values
	for i, v in ipairs(incomingMods) do
		for j, u in ipairs(ModifierLookup) do
			if(u == v) then
				table.insert(modIndexes, j)
			end
		end
	end
	
	if(modIndexes[1] == 1) then
		Screens.ModifierSelection.ModContainer1.SelectedValue = 1
		Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.InvertGravity.WideNinepatch)
		Screens.ModifierSelection.InvertGravity.Control:Set_Texture(Screens.ModifierSelection.InvertGravity.SelectedNinepatch)
		Screens.ModifierSelection.InvertGravity.Selected = true
		Screens.ModifierSelection.InvertGravity.SelectedContainer = 1
	elseif(modIndexes[1] == 2) then
		Screens.ModifierSelection.ModContainer1.SelectedValue = 2
		Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.Featherlight.WideNinepatch)
		Screens.ModifierSelection.Featherlight.Control:Set_Texture(Screens.ModifierSelection.Featherlight.SelectedNinepatch)
		Screens.ModifierSelection.Featherlight.Selected = true
		Screens.ModifierSelection.Featherlight.SelectedContainer = 1
	elseif(modIndexes[1] == 3) then
		Screens.ModifierSelection.ModContainer1.SelectedValue = 3
		Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.Frictionless.WideNinepatch)
		Screens.ModifierSelection.Frictionless.Control:Set_Texture(Screens.ModifierSelection.Frictionless.SelectedNinepatch)
		Screens.ModifierSelection.Frictionless.Selected = true
		Screens.ModifierSelection.Frictionless.SelectedContainer = 1
	elseif(modIndexes[1] == 4) then
		Screens.ModifierSelection.ModContainer1.SelectedValue = 4
		Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.Grow.WideNinepatch)
		Screens.ModifierSelection.Grow.Control:Set_Texture(Screens.ModifierSelection.Grow.SelectedNinepatch)
		Screens.ModifierSelection.Grow.Selected = true
		Screens.ModifierSelection.Grow.SelectedContainer = 1
	elseif(modIndexes[1] == 5) then
		Screens.ModifierSelection.ModContainer1.SelectedValue = 5
		Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.Shrink.WideNinepatch)
		Screens.ModifierSelection.Shrink.Control:Set_Texture(Screens.ModifierSelection.Shrink.SelectedNinepatch)
		Screens.ModifierSelection.Shrink.Selected = true
		Screens.ModifierSelection.Shrink.SelectedContainer = 1
	elseif(modIndexes[1] == 6) then
		Screens.ModifierSelection.ModContainer1.SelectedValue = 6
		Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.Knockback.WideNinepatch)
		Screens.ModifierSelection.Knockback.Control:Set_Texture(Screens.ModifierSelection.Knockback.SelectedNinepatch)
		Screens.ModifierSelection.Knockback.Selected = true
		Screens.ModifierSelection.Knockback.SelectedContainer = 1
	elseif(modIndexes[1] == 7) then
		Screens.ModifierSelection.ModContainer1.SelectedValue = 7
		Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.Wall.WideNinepatch)
		Screens.ModifierSelection.Wall.Control:Set_Texture(Screens.ModifierSelection.Wall.SelectedNinepatch)
		Screens.ModifierSelection.Wall.Selected = true
		Screens.ModifierSelection.Wall.SelectedContainer = 1
	elseif(modIndexes[1] == 8) then
		Screens.ModifierSelection.ModContainer1.SelectedValue = 8
		Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.Illusion.WideNinepatch)
		Screens.ModifierSelection.Illusion.Control:Set_Texture(Screens.ModifierSelection.Illusion.SelectedNinepatch)
		Screens.ModifierSelection.Illusion.Selected = true
		Screens.ModifierSelection.Illusion.SelectedContainer = 1
	else
		Screens.ModifierSelection.ModContainer1.SelectedValue = 0
		Screens.ModifierSelection.ModContainer1.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
	end
	
	if(modIndexes[2] == 1) then
		Screens.ModifierSelection.ModContainer2.SelectedValue = 1
		Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.InvertGravity.WideNinepatch)
		Screens.ModifierSelection.InvertGravity.Control:Set_Texture(Screens.ModifierSelection.InvertGravity.SelectedNinepatch)
		Screens.ModifierSelection.InvertGravity.Selected = true
		Screens.ModifierSelection.InvertGravity.SelectedContainer = 2
	elseif(modIndexes[2] == 2) then
		Screens.ModifierSelection.ModContainer2.SelectedValue = 2
		Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.Featherlight.WideNinepatch)
		Screens.ModifierSelection.Featherlight.Control:Set_Texture(Screens.ModifierSelection.Featherlight.SelectedNinepatch)
		Screens.ModifierSelection.Featherlight.Selected = true
		Screens.ModifierSelection.Featherlight.SelectedContainer = 2
	elseif(modIndexes[2] == 3) then
		Screens.ModifierSelection.ModContainer2.SelectedValue = 3
		Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.Frictionless.WideNinepatch)
		Screens.ModifierSelection.Frictionless.Control:Set_Texture(Screens.ModifierSelection.Frictionless.SelectedNinepatch)
		Screens.ModifierSelection.Frictionless.Selected = true
		Screens.ModifierSelection.Frictionless.SelectedContainer = 2
	elseif(modIndexes[2] == 4) then
		Screens.ModifierSelection.ModContainer2.SelectedValue = 4
		Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.Grow.WideNinepatch)
		Screens.ModifierSelection.Grow.Control:Set_Texture(Screens.ModifierSelection.Grow.SelectedNinepatch)
		Screens.ModifierSelection.Grow.Selected = true
		Screens.ModifierSelection.Grow.SelectedContainer = 2
	elseif(modIndexes[2] == 5) then
		Screens.ModifierSelection.ModContainer2.SelectedValue = 5
		Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.Shrink.WideNinepatch)
		Screens.ModifierSelection.Shrink.Control:Set_Texture(Screens.ModifierSelection.Shrink.SelectedNinepatch)
		Screens.ModifierSelection.Shrink.Selected = true
		Screens.ModifierSelection.Shrink.SelectedContainer = 2
	elseif(modIndexes[2] == 6) then
		Screens.ModifierSelection.ModContainer2.SelectedValue = 6
		Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.Knockback.WideNinepatch)
		Screens.ModifierSelection.Knockback.Control:Set_Texture(Screens.ModifierSelection.Knockback.SelectedNinepatch)
		Screens.ModifierSelection.Knockback.Selected = true
		Screens.ModifierSelection.Knockback.SelectedContainer = 2
	elseif(modIndexes[2] == 7) then
		Screens.ModifierSelection.ModContainer2.SelectedValue = 7
		Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.Wall.WideNinepatch)
		Screens.ModifierSelection.Wall.Control:Set_Texture(Screens.ModifierSelection.Wall.SelectedNinepatch)
		Screens.ModifierSelection.Wall.Selected = true
		Screens.ModifierSelection.Wall.SelectedContainer = 2
	elseif(modIndexes[2] == 8) then
		Screens.ModifierSelection.ModContainer2.SelectedValue = 8
		Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.Illusion.WideNinepatch)
		Screens.ModifierSelection.Illusion.Control:Set_Texture(Screens.ModifierSelection.Illusion.SelectedNinepatch)
		Screens.ModifierSelection.Illusion.Selected = true
		Screens.ModifierSelection.Illusion.SelectedContainer = 2
	else
		Screens.ModifierSelection.ModContainer2.SelectedValue = 0
		Screens.ModifierSelection.ModContainer2.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
	end
	
	if(modIndexes[3] == 1) then
		Screens.ModifierSelection.ModContainer3.SelectedValue = 1
		Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.InvertGravity.WideNinepatch)
		Screens.ModifierSelection.InvertGravity.Control:Set_Texture(Screens.ModifierSelection.InvertGravity.SelectedNinepatch)
		Screens.ModifierSelection.InvertGravity.Selected = true
		Screens.ModifierSelection.InvertGravity.SelectedContainer = 3
	elseif(modIndexes[3] == 2) then
		Screens.ModifierSelection.ModContainer3.SelectedValue = 2
		Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.Featherlight.WideNinepatch)
		Screens.ModifierSelection.Featherlight.Control:Set_Texture(Screens.ModifierSelection.Featherlight.SelectedNinepatch)
		Screens.ModifierSelection.Featherlight.Selected = true
		Screens.ModifierSelection.Featherlight.SelectedContainer = 3
	elseif(modIndexes[3] == 3) then
		Screens.ModifierSelection.ModContainer3.SelectedValue = 3
		Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.Frictionless.WideNinepatch)
		Screens.ModifierSelection.Frictionless.Control:Set_Texture(Screens.ModifierSelection.Frictionless.SelectedNinepatch)
		Screens.ModifierSelection.Frictionless.Selected = true
		Screens.ModifierSelection.Frictionless.SelectedContainer = 3
	elseif(modIndexes[3] == 4) then
		Screens.ModifierSelection.ModContainer3.SelectedValue = 4
		Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.Grow.WideNinepatch)
		Screens.ModifierSelection.Grow.Control:Set_Texture(Screens.ModifierSelection.Grow.SelectedNinepatch)
		Screens.ModifierSelection.Grow.Selected = true
		Screens.ModifierSelection.Grow.SelectedContainer = 3
	elseif(modIndexes[3] == 5) then
		Screens.ModifierSelection.ModContainer3.SelectedValue = 5
		Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.Shrink.WideNinepatch)
		Screens.ModifierSelection.Shrink.Control:Set_Texture(Screens.ModifierSelection.Shrink.SelectedNinepatch)
		Screens.ModifierSelection.Shrink.Selected = true
		Screens.ModifierSelection.Shrink.SelectedContainer = 3
	elseif(modIndexes[3] == 6) then
		Screens.ModifierSelection.ModContainer3.SelectedValue = 6
		Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.Knockback.WideNinepatch)
		Screens.ModifierSelection.Knockback.Control:Set_Texture(Screens.ModifierSelection.Knockback.SelectedNinepatch)
		Screens.ModifierSelection.Knockback.Selected = true
		Screens.ModifierSelection.Knockback.SelectedContainer = 3
	elseif(modIndexes[3] == 7) then
		Screens.ModifierSelection.ModContainer3.SelectedValue = 7
		Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.Wall.WideNinepatch)
		Screens.ModifierSelection.Wall.Control:Set_Texture(Screens.ModifierSelection.Wall.SelectedNinepatch)
		Screens.ModifierSelection.Wall.Selected = true
		Screens.ModifierSelection.Wall.SelectedContainer = 3
	elseif(modIndexes[3] == 8) then
		Screens.ModifierSelection.ModContainer3.SelectedValue = 8
		Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.Illusion.WideNinepatch)
		Screens.ModifierSelection.Illusion.Control:Set_Texture(Screens.ModifierSelection.Illusion.SelectedNinepatch)
		Screens.ModifierSelection.Illusion.Selected = true
		Screens.ModifierSelection.Illusion.SelectedContainer = 3
	else
		Screens.ModifierSelection.ModContainer3.SelectedValue = 0
		Screens.ModifierSelection.ModContainer3.Control:Set_Texture(Screens.ModifierSelection.BlankLoadoutNP)
	end

end

Screens.ModifierSelection.Activate = function()
	if(Screens.ModifierSelection.Window ~= nil) then
		Screens.ModifierSelection.CheckControls()
		Screens.ModifierSelection.Window:Set_Visible(true)
		Util.Debug("Activating Title Screens")
	end
end

Screens.ModifierSelection.Deactivate = function()
	if(Screens.ModifierSelection.Window ~= nil) then
		Screens.ModifierSelection.Window:Set_Visible(false)
	end
end

Screens.ModifierSelection.Switch = function()
	Util.Debug("==================Switch Screens Clicked======================")
	Audio.MenuEmitter:Play(0)
	Util.Debug("Container 1 Selected Value: ", Screens.ModifierSelection.ModContainer1.SelectedValue)
	Util.Debug("Container 2 Selected Value: ", Screens.ModifierSelection.ModContainer2.SelectedValue)
	Util.Debug("Container 3 Selected Value: ", Screens.ModifierSelection.ModContainer3.SelectedValue)
	--Any changes made in WeaponSelection and WeaponSelection need to be made permanent for the player

	local newWeapons = { }
	local tempWeaponsTable = Player.Client:GetWeapons()
	
	--Retrieving the modifiers from the list so we can preserve them
	for i, v in ipairs(tempWeaponsTable) do
		if(string.find(v.Type, "ModifierLauncher") == nil) then
			Util.Debug("Extracting: ", v.Type)
			table.insert(newWeapons, v)
		end
	end
	
	Util.Debug("Removing current weapons")
	--Clearing the current weapons out
	Player.Client:RemoveAllWeapons()
	
	for i, v in ipairs(newWeapons) do
		Util.Debug("Adding modifier: " , v.Type)
		Player.Client:AddWeapon(v.Type)
	end
	
	--Adding the weapons to the player list
	if(Screens.ModifierSelection.ModContainer1.SelectedValue > 0) then
		Util.Debug("Adding Weaon from Container 1", ModifierLookup[Screens.ModifierSelection.ModContainer1.SelectedValue])
		Player.Client:AddWeapon(ModifierLookup[Screens.ModifierSelection.ModContainer1.SelectedValue])
	end
	
	if(Screens.ModifierSelection.ModContainer2.SelectedValue > 0) then
		Util.Debug("Adding Weapon from Container 2", ModifierLookup[Screens.ModifierSelection.ModContainer2.SelectedValue])
		Player.Client:AddWeapon(ModifierLookup[Screens.ModifierSelection.ModContainer2.SelectedValue])
	end

	if(Screens.ModifierSelection.ModContainer3.SelectedValue > 0) then
		Util.Debug("Adding Weapn from Container 3", ModifierLookup[Screens.ModifierSelection.ModContainer3.SelectedValue])
		Player.Client:AddWeapon(ModifierLookup[Screens.ModifierSelection.ModContainer3.SelectedValue])
	end
	
	tempWeaponsTable = Player.Client:GetWeapons()
	
	Util.Debug("===========New Weapons List=============")
	for i, v in ipairs(tempWeaponsTable) do
		Util.Debug(i, v.Type)
	end
	
	Screens.WeaponSelection.Activate()
	Screens.ModifierSelection.Deactivate()
end

Screens.ModifierSelection.Cancel = function()
	Util.Debug("Cancel clicked")
	Audio.MenuEmitter:Play(1)
	--No changes to loadout are made
	
	Screens.Spawn.Activate()
	Screens.ModifierSelection.Deactivate()
end

Screens.ModifierSelection.AcceptChanges = function()
	Util.Debug("==================Accept Changes Clicked======================")
	Audio.MenuEmitter:Play(0)
	Util.Debug("Container 1 Selected Value: ", Screens.ModifierSelection.ModContainer1.SelectedValue)
	Util.Debug("Container 2 Selected Value: ", Screens.ModifierSelection.ModContainer2.SelectedValue)
	Util.Debug("Container 3 Selected Value: ", Screens.ModifierSelection.ModContainer3.SelectedValue)
	--Any changes made in WeaponSelection and WeaponSelection need to be made permanent for the player

	local newWeapons = { }
	local tempWeaponsTable = Player.Client:GetWeapons()
	
	--Retrieving the modifiers from the list so we can preserve them
	for i, v in ipairs(tempWeaponsTable) do
		if(string.find(v.Type, "ModifierLauncher") == nil) then
			Util.Debug("Extracting: ", v.Type)
			table.insert(newWeapons, v)
		end
	end
	
	Util.Debug("Removing current weapons")
	--Clearing the current weapons out
	Player.Client:RemoveAllWeapons()
	
	for i, v in ipairs(newWeapons) do
		Util.Debug("Adding Weapon: " , v.Type)
		Player.Client:AddWeapon(v.Type)
	end
	
	--Adding the weapons to the player list
	if(Screens.ModifierSelection.ModContainer1.SelectedValue > 0) then
		Util.Debug("Adding Weapon from Container 1", ModifierLookup[Screens.ModifierSelection.ModContainer1.SelectedValue])
		Player.Client:AddWeapon(ModifierLookup[Screens.ModifierSelection.ModContainer1.SelectedValue])
	end
	
	if(Screens.ModifierSelection.ModContainer2.SelectedValue > 0) then
		Util.Debug("Adding Weapon from Container 2", ModifierLookup[Screens.ModifierSelection.ModContainer2.SelectedValue])
		Player.Client:AddWeapon(ModifierLookup[Screens.ModifierSelection.ModContainer2.SelectedValue])
	end

	if(Screens.ModifierSelection.ModContainer3.SelectedValue > 0) then
		Util.Debug("Adding Weapn from Container 3", ModifierLookup[Screens.ModifierSelection.ModContainer3.SelectedValue])
		Player.Client:AddWeapon(ModifierLookup[Screens.ModifierSelection.ModContainer3.SelectedValue])
	end

	tempWeaponsTable = Player.Client:GetWeapons()
	
	Util.Debug("===========New Weapons List=============")
	for i, v in ipairs(tempWeaponsTable) do
		Util.Debug(i, v.Type)
	end
	
	Screens.Spawn.Activate()
	Screens.ModifierSelection.Deactivate()

end