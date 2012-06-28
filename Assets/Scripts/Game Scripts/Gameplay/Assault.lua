local MAX_CONTROL_POINT_TIMER = 3
local UPDATE_TICK = 0.5
local NO_TEAM = -1

local ASSAULT_ATTACKING_TEAM = PLAYER_TEAM_BLUE
local ASSAULT_DEFENDING_TEAM = PLAYER_TEAM_RED

Assault = {
	Running = false,
	Buff = Buff.CreateBuff("ControlPoint","On a control point", nil)
}

Assault.ControlPoints = {
	{Position = Vector3:new(-288, 87, 17), RadiusSq = 5.0, Team = PLAYER_TEAM_RED},
	{Position = Vector3:new(1741, 31, -109), RadiusSq = 5.0, Team = PLAYER_TEAM_RED},
	{Position = Vector3:new(836, 18, 557), RadiusSq = 5.0, Team = PLAYER_TEAM_RED},
	{Position = Vector3:new(1556, 76, 834), RadiusSq = 5.0, Team = PLAYER_TEAM_RED},
}

Assault.SpawnPoints = {
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

Assault.Start = function(winningCallback, isHost, timeLimit)
	
	Match.SpawnPoints = Util.ShallowTableCopy(Assault.SpawnPoints)
	Match.ControlPoints = Util.ShallowTableCopy(Assault.ControlPoints)
	
	Assault.IsHost = isHost
	Assault.DefendingTeam = ASSAULT_DEFENDING_TEAM
	Assault.AttackingTeam = ASSAULT_ATTACKING_TEAM
	Assault.ControlPointTimer = 0
	Match.CurrentControlPointIndex = 0	--notes which control point to start at
	
	Util.Debug("Time Limit: ", timeLimit)
	Util.Debug("IsHost"..tostring(Assault.IsHost))
	
	Assault.WinningCallback = winningCallback
	
	--Setting the parameters and registering the packet messages with the network
	if(isHost) then
		Assault.Elapsed = 0
		Assault.Timer = timeLimit
		Assault.PrepareNext()	--prepares the first control point
	else
		--Register any network messages that assault will need to keep track of. 
		Network.Register(Assault.Network.GameInfoType, Assault.Network.GameInfoMsg)
		Network.Register(Assault.Network.GameWinType, Assault.Network.GameWinMsg)
		Network.Register(Assault.Network.GameScoreType, Assault.Network.GameScoreMsg)
	end
end

--Called at the end of the match
Assault.End = function(value)
	
	if(not Assault.IsHost) then
		Network.Unregister(Assault.Network.GameInfoType, Assault.Network.GameInfoMsg)
		Network.Unregister(Assault.Network.GameWinType, Assault.Network.GameWinMsg)
		Network.Unregister(Assault.Network.GameScoreType, Assault.Network.GameScoreMsg)
	end
	Assault.Running = false
	Util.Debug("Winning team: "..value)

    if(Assault.WinningCallback) then
    	Assault.WinningCallback(value)
	end
end

--Called when the game begins or a scoring scenario for the attacking team has been reached
Assault.PrepareNext = function()                                      
	
	--checking to see if the current control point index is the max count on the control point list. if it is before we update the control point, it means the attacking team has won the match
	if(Match.CurrentControlPointIndex == #Match.ControlPoints) then
		local msg = 
		{
			Winner = ASSAULT_ATTACKING_TEAM
		}
		
		Network.SendReliable(Assault.Network.GameWinType, msg)
		Assault.End(ASSAULT_ATTACKING_TEAM)
	else
		--updating the control point index
		if(Match.CurrentControlPointIndex < #Match.ControlPoints) then
			Match.CurrentControlPointIndex = Match.CurrentControlPointIndex + 1
			
		end
		
		Assault.ControlPointTimer = MAX_CONTROL_POINT_TIMER
		Match.CurrentControlPoint = Match.ControlPoints[Match.CurrentControlPointIndex]
		Util.Debug("Assault Current Control Point Index"..Match.CurrentControlPointIndex)
		
		local msg = 
		{
			ControlPointIndex = Match.CurrentControlPointIndex
		}
		
		Network.SendReliable(Assault.Network.GameScoreType, msg)
	end
end

Assault.CheckWinCondition = function()
	--Check for win conditions before proceeding to update the control point

	if(Assault.Timer < 0) then
		--defending team has won the match
	
		local msg = 
		{
			Winner = ASSAULT_DEFENDING_TEAM
		}
		
		Network.SendReliable(Assault.Network.GameWinType, msg)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
		Assault.End(ASSAULT_DEFENDING_TEAM)
	end
	
	return false
end

--Hook into the Singularity Engine which syncs with the update loop
Assault.Update = function(elapsed)
	if(Assault.Running) then
		if(Assault.IsHost) then
			
			--if we have not reached a win condition, continue with the update
			if(not Assault.CheckWinCondition()) then
				--Util.Debug("Control PointTimer: "..math.floor(Assault.ControlPointTimer))
				Assault.Elapsed = Assault.Elapsed + elapsed
				Assault.Timer = Assault.Timer - elapsed
				if(Assault.Elapsed > UPDATE_TICK) then
					Assault.Elapsed = 0
					local msg =
					{
						ControlPointTimer = Assault.ControlPointTimer,
						Timer = Assault.Timer,
					}
					Network.Send(Assault.Network.GameInfoType, msg)
				end
				
				Assault.UpdateControlPoint(elapsed)
			end	
		end
		
		if(Match.CurrentControlPointIndex > 0) then
			Assault.UpdateBuff()
		end
	end
end

--Host calls UpdateControlPoint which handles whether the attacking team has entered
Assault.UpdateControlPoint = function(elapsed)
	
	local attacking = false
	local defending = false
	--looping through all the players to see if any are within range of the control point's radius
	for k,v in pairs(Main.GamePlay.Players) do
		local pos = v.Root:Get_Transform():Get_Position()
		if(Assault.IsInControlPoint(pos, Match.CurrentControlPoint)) then
			if(v.Team == ASSAULT_ATTACKING_TEAM) then
				attacking = true
			elseif(v.Team == ASSAULT_DEFENDING_TEAM) then
				defending = true
			end
		end
	end
	
	--using the flags we checked above, we'll determine whether to count down the control point timer
	if(attacking and not defending) then
		Assault.ControlPointTimer = Assault.ControlPointTimer - elapsed
	end
	
	--check to see if the timer has reached 0, if so we have entered a scoring scenario for the attacking team and the next control point needs to be set
	if(Assault.ControlPointTimer <= 0) then
		Assault.PrepareNext()
	end
end

--Called when a player has entered the control point whether to attack or defend
Assault.UpdateBuff = function()
	if(Assault.IsInControlPoint(Player.Client.Root:Get_Transform():Get_Position(),Match.ControlPoints[Match.CurrentControlPointIndex])) then
		if(not Player.Client:HasBuffType(Assault.Buff)) then
			Player.Client:AddBuff(Assault.Buff)
		end
	else
		if(Player.Client:HasBuffType(Assault.Buff)) then
			Player.Client:RemoveBuff(Assault.Buff)
		end
	end
end


--Called when a scoring scenario has been reached. Spawns particle emitters at the control point's location
Assault.OnScore = function(value)

end

--Function to check if the passed in position is within the control point's radius
Assault.IsInControlPoint = function(pos, point)
	local diffX = pos.x - point.Position.x
	local diffZ = pos.z - point.Position.z
	local magSq = diffX*diffX + diffZ*diffZ
	
	return magSq < point.RadiusSq
end

--Network table for the Assault game mode
Assault.Network = 
{
	GameInfoType = "A1",	-- Sent often to players with game information
	GameWinType = "A2", -- Sent when a team has been declared the victor
	GameScoreType = "A3", -- Sent when a control point has fallen to the attacking team
	
	GameInfoMsg = function(value)
		Assault.ControlPointTimer = value.ControlPointTimer
		Assault.Timer = value.Timer
	end,
	GameWinMsg = function(value)
		Assault.End(value.Winner)
	end,
	GameScoreMsg = function(value)
		Match.CurrentControlPointIndex = value.ControlPointIndex
	end,
	
}

