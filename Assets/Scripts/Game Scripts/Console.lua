Console = {}

Console.Path = Main.AssetDirectory.."Scripts\\Game Scripts\\Console.txt"
Console.Key = DIK_F1
Console.KeyDown = false

Console.Update = function(elapsed)

	if(Singularity.Inputs.Input:IsKeyDown(Console.Key) and not Console.KeyDown) then
		Console.KeyDown = true
		Util.LoadFile(Console.Path)
	elseif(not Singularity.Inputs.Input:IsKeyDown(Console.Key)) then
		Console.KeyDown = false
	end

end