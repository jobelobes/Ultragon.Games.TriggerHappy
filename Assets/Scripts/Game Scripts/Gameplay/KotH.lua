--consts
local MAX_CONTROL_POINT_TIMER = 10
local UPDATE_TICK = 0.5
local NO_TEAM = -1

KotH = {
	Running = false,
	Buff = Buff.CreateBuff("ControlPoint","On a control point", nil)
}

KotH.ControlPoints = {
	{Position = Vector3:new(-288, 87, 17), RadiusSq = 5.0},
	{Position = Vector3:new(1741, 31, -109), RadiusSq = 5.0},
	{Position = Vector3:new(836, 18, 557), RadiusSq = 5.0},
	{Position = Vector3:new(1556, 76, 834), RadiusSq = 5.0},
}

KotH.SpawnPoints = {
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

KotH.SmokeTexture = Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."Textures\\Particles\\Smoke.png")

--Begins a game
KotH.Start = function(winningCallback, isHost, winningScore)

	Match.SpawnPoints = Util.ShallowTableCopy(KotH.SpawnPoints)
	Match.ControlPoints = Util.ShallowTableCopy(KotH.ControlPoints)

	KotH.IsHost = isHost
	KotH.ControllingTeam = NO_TEAM
	KotH.Scores = {0,0}
	KotH.Timers = {0,0}
	KotH.Timer = 0
	Match.CurrentControlPointIndex = -1
	
	Util.Debug("Winning score:", winningScore)
	
	--Called when the game is won
	KotH.WinningCallback = winningCallback
	
	if(isHost) then
		--Host preps the game
		KotH.Elapsed = 0
		KotH.WinningScore = winningScore
		KotH.PrepareNext()
	else
		--Others register for net updates
		Network.Register(KotH.Network.GameInfoType, KotH.Network.GameInfoMsg)
		Network.Register(KotH.Network.GameWinType, KotH.Network.GameWinMsg)
		Network.Register(KotH.Network.GameScoreType, KotH.Network.GameScoreMsg)
	end   
end

--Readies the next control point when the game starts or a scoring scenario has been reached
KotH.PrepareNext = function()
	Util.Debug("PRESCORE")
	for i = 1,2 do
		if(KotH.Scores[i] >= KotH.WinningScore) then
			-- send the final score
			Util.Debug("SENDMSG")
			local msg =
			{
				ControllingTeam = KotH.ControllingTeam,
				Timer = KotH.Timer,
			}
			Network.Send(KotH.Network.GameInfoType, msg)
			
			-- send the winning callback
			Util.Debug("SENDWIN")
			local msg = 
			{
				Winner = i,
			}
			Network.SendReliable(KotH.Network.GameWinType, msg)
			
			KotH.End(i)
			
		end
		Util.Debug("POSTSCORE")
	end
	
	Util.Debug("Blue Score: "..KotH.Scores[PLAYER_TEAM_BLUE])
	Util.Debug("Red Score: "..KotH.Scores[PLAYER_TEAM_RED])
			
	KotH.Timers[PLAYER_TEAM_RED] = MAX_CONTROL_POINT_TIMER
	KotH.Timers[PLAYER_TEAM_BLUE] = MAX_CONTROL_POINT_TIMER
	KotH.Timer = 0
	
	--cycling through the control points and picking a new random one. Also checking to make sure the new control point isn't the same as the last one
	local newCurrIndex = math.random(#Match.ControlPoints)
	Util.Debug("newCurrIndex before check: "..newCurrIndex)
	while((newCurrIndex == Match.CurrentControlPointIndex) and (#Match.ControlPoints > 1)) do
		Util.Debug("newCurrIndex: "..newCurrIndex, "Match.CurrentControlPointIndex: "..Match.CurrentControlPointIndex)
		newCurrIndex = math.random(#Match.ControlPoints)
	end
	
	--setting the current control point index to the newly generated index
	Match.CurrentControlPointIndex = newCurrIndex
	Match.CurrentControlPoint = Match.ControlPoints[Match.CurrentControlPointIndex]
	Util.Debug("Current control point index: "..Match.CurrentControlPointIndex)
	
	--building the network message
	local msg =
	{
		Red = KotH.Scores[1],
		Blue = KotH.Scores[2],
		ControlPointIndex = Match.CurrentControlPointIndex,
	}
	Network.SendReliable(KotH.Network.GameScoreType, msg)
	KotH.OnScore(NO_TEAM)
	
end

--Update function that is synced with the Singularity Engine's update loop
KotH.Update = function(elapsed)
	
	if(KotH.Running) then
		if(KotH.IsHost) then
			KotH.Elapsed = KotH.Elapsed + elapsed
			if(KotH.Elapsed > UPDATE_TICK) then
				KotH.Elapsed = 0
				local msg =
				{
					--Scores = KotH.Scores,
					--Red = KotH.Scores[1],
					--Blue = KotH.Scores[2],
					ControllingTeam = KotH.ControllingTeam,
					Timer = KotH.Timer,
				}
				Network.Send(KotH.Network.GameInfoType, msg)
			end
			
			KotH.UpdateControlPoint(elapsed)
		end
		
		if(Match.CurrentControlPointIndex > 0) then
			KotH.UpdateBuff()
		end
	end
end

--Host calls this function that cycles through the player list to see if any of them are within range of the control point
KotH.UpdateControlPoint = function(elapsed)
	if(KotH.ControllingTeam == NO_TEAM) then
		--Util.Debug("Should be NO Controlling Team: ")
		for k,v in pairs(Main.GamePlay.Players) do
			if(v.State ~= PLAYER_STATE_DEAD) then
				local pos = v.Root:Get_Transform():Get_Position()
				if(KotH.IsInControlPoint(pos, Match.CurrentControlPoint)) then -- first one in the list to get it wins if they arrive at the same time
					--Util.Debug("Setting controlling team to: "..v.Team)
					KotH.ControllingTeam = v.Team
					KotH.Timer = KotH.Timers[v.Team]
					break
				end
			end
		end
	else
		local us = false
		local them = false
		local updateTimer = false
		for k,v in pairs(Main.GamePlay.Players) do
			if(v.State ~= PLAYER_STATE_DEAD) then			
				local pos = v.BodyNode:Get_Transform():Get_Position()
				if(KotH.IsInControlPoint(pos, Match.CurrentControlPoint)) then
					if(v.Team == Player.Client.Team) then
						us = true
					else
						them = true
					end
					if(us and them) then
						return -- one of each team is present; nobody will update
					end
				end
			end
		end
		
		--Util.Debug("Controlling Team Before Update: "..KotH.ControllingTeam)

		if(not us and not them) then
			--Util.Debug("Setting to no team")
			KotH.ControllingTeam = NO_TEAM -- we can just return here.
			KotH.OnScore(NO_TEAM)
			return
		elseif(us and not them) then
			--Util.Debug("My team is the sole owner.")
			KotH.ControllingTeam = Player.Client.Team
			
		elseif(them and not us) then
			--Util.Debug("My enemy is the sole owner.")
			if (Player.Client.Team == PLAYER_TEAM_RED) then
				--Util.Debug("Blue enemy.")
				KotH.ControllingTeam = PLAYER_TEAM_BLUE
				KotH.OnScore(KotH.ControllingTeam)
			elseif (Player.Client.Team == PLAYER_TEAM_BLUE) then
				--Util.Debug("Red enemy.")
				KotH.ControllingTeam = PLAYER_TEAM_RED
				KotH.OnScore(KotH.ControllingTeam)
			end
		end
		
		KotH.Timers[KotH.ControllingTeam] = KotH.Timers[KotH.ControllingTeam] - elapsed
		KotH.Timer = KotH.Timers[KotH.ControllingTeam]
		
		--Util.Debug("Controlling Team After Update: "..KotH.ControllingTeam)
		
		if(KotH.Timers[KotH.ControllingTeam] <= 0) then
			KotH.Scores[KotH.ControllingTeam] = KotH.Scores[KotH.ControllingTeam] + 1
			KotH.PrepareNext()
		end
	end
end

--Updates the icon on the screen for where the control point in relation to the player
KotH.UpdateBuff = function()
	if(KotH.IsInControlPoint(Player.Client.Root:Get_Transform():Get_Position(),Match.ControlPoints[Match.CurrentControlPointIndex]) and Player.Client.State ~= PLAYER_STATE_DEAD) then
		if(not Player.Client:HasBuffType(KotH.Buff)) then
			Player.Client:AddBuff(KotH.Buff)
		end
	else
		if(Player.Client:HasBuffType(KotH.Buff)) then
			Player.Client:RemoveBuff(KotH.Buff)
		end
	end
end

--Checks to see if the position from a given player is within range of the control point
KotH.IsInControlPoint = function(pos, point)
	local diffX = pos.x - point.Position.x
	local diffZ = pos.z - point.Position.z
	local magSq = diffX*diffX + diffZ*diffZ
	
	return magSq < point.RadiusSq
end

--Called at the end of the match
KotH.End = function(value)
	
	if(not KotH.IsHost) then
		Network.Unregister(KotH.Network.GameInfoType, KotH.Network.GameInfoMsg)
		Network.Unregister(KotH.Network.GameWinType, KotH.Network.GameWinMsg)
		Network.Unregister(KotH.Network.GameScoreType, KotH.Network.GameScoreMsg)
	end
	KotH.Running = false
	Util.Debug("Winning team: "..value)

    if(KotH.WinningCallback) then
    	KotH.WinningCallback(value)
	end
end

--Effects that occur when a scoring scenario is reached
KotH.OnScore = function(team)
	--[[
	--Creating new particle emitter based on where the control point is
	Util.Debug("Creating Particle Emitter")
	particleEmitter = Singularity.Particles.ParticleEmitter:new(Singularity.Particles.Radial, 1.0)

	Util.Debug("1")
	--particleEmitter:Set_EmitterRepeats(-1)
	particleEmitter:Set_ParticleCount(300)
	Util.Debug("1")
	particleEmitter:Set_ParticleRepeats(-1)
	Util.Debug("1")
	particleEmitter:Set_MainTexture(KotH.SmokeTexture)
	Util.Debug("1")
	particleEmitter:Set_Direction(Vector3:new(0.5, 1, 0.5))
	Util.Debug("1")
	particleEmitter:Set_PositionOffset(Match.ControlPoints[Match.CurrentControlPointIndex].Position)
	Util.Debug("1")
	particleEmitter:Set_Radius(Match.ControlPoints[Match.CurrentControlPointIndex].RadiusSq)
	Util.Debug("1")
	
	--setting the color
	if(team == PLAYER_TEAM_RED) then
		particleEmitter:Set_ColorLimit(Color:new(1, 0, 0, 1))
	elseif(team == PLAYER_TEAM_BLUE) then
		particleEmitter:Set_ColorLimit(Color:new(0, 0, 1, 1))
	else
		particleEmitter:Set_ColorLimit(Color:new(0.94, 0.94, 0.94, 1))
	end
	
	Util.Debug("1")
	Main.Root:AddComponent(particleEmitter)
	Util.Debug("1")
	--]]
end

--Network structs and functions 
KotH.Network =
{
	GameInfoType = "K1", -- Sent often to with game information
	GameWinType = "K2", -- Sent when a team has been declared the victor
	GameScoreType = "K3", -- Sent when somebody scores a point. Should use SendReliable.
	GameInfoMsg = function(value)
		KotH.ControllingTeam = value.ControllingTeam
		KotH.Timer = value.Timer
	end,
	GameWinMsg = function(value)
		--KotH.WinningCallback(value.Winner)
		KotH.End(value.Winner)
	end,
	GameScoreMsg = function(value)
		KotH.Scores[PLAYER_TEAM_RED] = value.Red
		KotH.Scores[PLAYER_TEAM_BLUE] = value.Blue
		Match.CurrentControlPointIndex = value.ControlPointIndex
		-- Put all updates on score in here or in an OnScore() function
		
		KotH.OnScore()
	end,
}