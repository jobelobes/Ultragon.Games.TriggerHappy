Audio = {}

Audio.Manager = nil
Audio.MusicManager = nil
Audio.MenuEmitter = nil --for convenience

Audio.Initialize = function()

	Util.Debug("Initalizing Audio.")

	Audio.Manager = Singularity.Audio.AudioManager:Instantiate()
	--Audio.MusicManager = Singularity.Audio.AdaptiveMusicManager:Instantiate()

	Audio.Manager:Initialize()
	Audio.Manager:CreateEngine(Main.AssetDirectory.."Audio\\Win\\TriggerHappy.xgs")
	
	Util.Debug("Audio initialized.");

end

Audio.LoadMenuAssets = function()

	Util.Debug("Loading menu audio assets.")

	Audio.Manager:LoadWaveBank(Main.AssetDirectory.."Audio\\Win\\MenuEffects.xwb")
	Audio.Manager:LoadSoundBank(Main.AssetDirectory.."Audio\\Win\\MenuEffects.xsb")
	
	Audio.Manager:LoadWaveBank(Main.AssetDirectory.."Audio\\Win\\LinearMusic.xwb")
	Audio.Manager:LoadSoundBank(Main.AssetDirectory.."Audio\\Win\\LinearMusic.xsb")
	
	Util.Debug("Menu effects loaded.")
	
	Audio.MenuEmitter = Audio.Manager:GetNewEmitter("MenuEmitter") -- do I have to hook this up to something?
	Audio.MenuEmitter:AddCue(Audio.Manager:CreateCue("music_Theme")) --3 -- why are you 3?
	Audio.MenuEmitter:AddCue(Audio.Manager:CreateCue("menu_Select")) --0
	Audio.MenuEmitter:AddCue(Audio.Manager:CreateCue("menu_Cancel")) --1
	Audio.MenuEmitter:AddCue(Audio.Manager:CreateCue("menu_Move")) --2
	
	Util.Debug("Audio assets loaded.")

end

Audio.LoadLevelAssets = function()

	Util.Debug("Loading level audio assets.")

	Audio.Manager:LoadWaveBank(Main.AssetDirectory.."Audio\\Win\\PlayerEffects.xwb")
	Audio.Manager:LoadSoundBank(Main.AssetDirectory.."Audio\\Win\\PlayerEffects.xsb")

	Audio.Manager:LoadWaveBank(Main.AssetDirectory.."Audio\\Win\\WeaponEffects.xwb")
	Audio.Manager:LoadSoundBank(Main.AssetDirectory.."Audio\\Win\\WeaponEffects.xsb")

	Audio.Manager:LoadWaveBank(Main.AssetDirectory.."Audio\\Win\\ModifierEffects.xwb")
	Audio.Manager:LoadSoundBank(Main.AssetDirectory.."Audio\\Win\\ModifierEffects.xsb")
	
	-- Loads in the environment and sets it to current.
	--Audio.MusicManager:CreateEnvironment(Main.AssetDirectory.."Audio\\Win\\TriggerHappyLevelMusic.xml")

	Util.Debug("Audio assets loaded.")
	
end

Audio.Update = function(elapsed)

	-- Update the adaptive audio system by setting the values of categories.
	-- The AudioTask will update the actual engine.
	
end

print("Audio loaded.")