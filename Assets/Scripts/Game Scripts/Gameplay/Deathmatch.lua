--consts
local MAX_CONTROL_POINT_TIMER = 10
local UPDATE_TICK = 0.5
local NO_TEAM = -1

Deathmatch = {
	Running = false,
}

Deathmatch.SpawnPoints = {
	{Position = Vector3:new(651, 19, 390), Team = PLAYER_TEAM_ALL},
	{Position = Vector3:new(1292, 21, 868), Team = PLAYER_TEAM_ALL},
	{Position = Vector3:new(1265, 75, 435), Team = PLAYER_TEAM_ALL},
	{Position = Vector3:new(1883, 75, 714), Team = PLAYER_TEAM_ALL},
	{Position = Vector3:new(1900, 18, 720), Team = PLAYER_TEAM_ALL},
	{Position = Vector3:new(-71, 32, 452), Team = PLAYER_TEAM_ALL},
	{Position = Vector3:new(620, 17, -140), Team = PLAYER_TEAM_ALL},
	{Position = Vector3:new(514, 17, -224), Team = PLAYER_TEAM_ALL},
	{Position = Vector3:new(2080, 33, 379), Team = PLAYER_TEAM_ALL},
	
}

--Begins a game
Deathmatch.Start = function(winningCallback, isHost, winningScore)

	Match.SpawnPoints = Util.ShallowTableCopy(KotH.SpawnPoints)
	Match.ControlPoints = {} -- explicitly empty it; we should never need these

	Deathmatch.IsHost = isHost
	Deathmatch.Scores = {0,0} -- the added amount of kills per team
	Deathmatch.Timer = 0 -- we'll just send an update every n milliseconds
	
	Util.Debug("Winning score:", winningScore)
	
	--Called when the game is won
	Deathmatch.WinningCallback = winningCallback
	
	if(isHost) then
		--Host preps the game
		Deathmatch.Elapsed = 0
		Deathmatch.WinningScore = winningScore
	else
		--Others register for net updates
		Network.Register(Deathmatch.Network.GameWinType, Deathmatch.Network.GameWinMsg)
		Network.Register(Deathmatch.Network.GameScoreType, Deathmatch.Network.GameScoreMsg)
	end   
	
	Deathmatch.Running = true
end

--Update function that is synced with the Singularity Engine's update loop
Deathmatch.Update = function(elapsed)

	if(Deathmatch.Running) then
		if(Deathmatch.IsHost) then
			Deathmatch.Elapsed = Deathmatch.Elapsed + elapsed
			if(Deathmatch.Elapsed > UPDATE_TICK) then
				Deathmatch.Elapsed = 0
				
				for i = 1,2 do
					print("RECALC")
					local score = 0
				
					for k,player in pairs(Main.GamePlay.Players) do
						if (player.Team == i) then
							score = score + player.Kills
						end
					end
					Deathmatch.Scores[i] = score
				
					if(Deathmatch.Scores[i] >= Deathmatch.WinningScore) then
		
						-- send the winning callback
						local msg = 
						{
							Winner = i,
						}
						Network.SendReliable(Deathmatch.Network.GameWinType, msg)
			
						Deathmatch.End(i)
			
					end
				end

			
				-- Insert any announcements regarding scoring, etc.
				Util.Debug("Blue Score: "..Deathmatch.Scores[PLAYER_TEAM_BLUE])
				Util.Debug("Red Score: "..Deathmatch.Scores[PLAYER_TEAM_RED])
				
				-- Send the current scores
				local msg =
				{
					Red = Deathmatch.Scores[1],
					Blue = Deathmatch.Scores[2],
				}
				Network.SendReliable(Deathmatch.Network.GameScoreType, msg)
				
			end
			
		end
		
	end
end

--Called at the end of the match
Deathmatch.End = function(value)
	
	if(not Deathmatch.IsHost) then
		Network.Unregister(Deathmatch.Network.GameScoreType, Deathmatch.Network.GameScoreMsg)
		Network.Unregister(Deathmatch.Network.GameWinType, Deathmatch.Network.GameWinMsg)
	end
	Deathmatch.Running = false
	Util.Debug("Winning team: "..value)

    if(Deathmatch.WinningCallback) then
    	Deathmatch.WinningCallback(value)
	end
end

--Network structs and functions 
Deathmatch.Network =
{
	GameScoreType = "DM1", -- Sent when somebody scores a kill.
	GameWinType = "DM2", -- Sent when somebody wins. Should use SendReliable.
	GameScoreMsg = function(value)
		Deathmatch.Scores[PLAYER_TEAM_RED] = value.Red
		Deathmatch.Scores[PLAYER_TEAM_BLUE] = value.Blue
	end,
	GameWinMsg = function(value)
		--Deathmatch.WinningCallback(value.Winner)
		Deathmatch.End(value.Winner)
	end,
}