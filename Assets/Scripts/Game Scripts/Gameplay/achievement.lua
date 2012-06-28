--System
Achievement = { Enabled = false}
Achievement.Goal = nil
Achievement.Reward = nil
Achievement.ActiveEffects = {}

local BETWEEN_GOAL_COOLDOWN = 5
local GOAL_NOTE_SIZE = 120
Achievement.Elapsed = 0
Achievement.Success = false

--Goals
Achievement.Goals =
{
	--Done.Tested.
	HealthCare = {
		Time = 30,
		Type = "HealthCare",
		Ninepatch = Singularity.Gui.NinePatch:new(Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\HealthCare.jpg"), Vector2:new(GOAL_NOTE_SIZE, GOAL_NOTE_SIZE), Vector4:new(0, 0, 0, 0)),
		Elapsed = 0,
		Activate = function(self)
			self.Elapsed = 0
		end,
		Process = function(self,elapsed)
			--after the time has elapsed, reward them
			self.Elapsed = self.Elapsed + elapsed
			if(self.Elapsed > self.Time) then
				Achievement.ApplyReward()
			end
		end,
	},
	--Done. Tested.
	Reduce = {
		Ninepatch = Singularity.Gui.NinePatch:new(Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\Reduce.jpg"), Vector2:new(GOAL_NOTE_SIZE, GOAL_NOTE_SIZE), Vector4:new(0, 0, 0, 0)),
		WallBlocks = 0,
		Type = "Reduce",
		Activate = function(self)
			self.WallBlocks = 0
		end,
		Process = function(self,elapsed)
			if(self.WallBlocks == 3) then
				Achievement.ApplyReward()
			end
		end,
	},
	Conservation = {
		Ninepatch = Singularity.Gui.NinePatch:new(Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\Conservation.jpg"), Vector2:new(GOAL_NOTE_SIZE, GOAL_NOTE_SIZE), Vector4:new(0, 0, 0, 0)),
		Type = "Conservation",
		ModifierHits = 0,
		Activate = function(self)
			self.ModifierHits = 0
		end,
		Process = function(self,elapsed)
			if(self.ModifierHits == 5) then
				Achievement.ApplyReward()
			end
		end,
	},
	--Done.Tested.
	Kill ={
		Ninepatch = Singularity.Gui.NinePatch:new(Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\One.jpg"), Vector2:new(GOAL_NOTE_SIZE, GOAL_NOTE_SIZE), Vector4:new(0, 0, 0, 0)),
		Type = "Kill",
		Kills = 0,
		Activate = function(self)
			self.Kills = 0
		end,
		Process = function(self,elapsed)
			if(self.Kills == 1) then
				Achievement.ApplyReward()
			end
		end,
	},
	--Done.Tested.
	HighGround = {
		Ninepatch = Singularity.Gui.NinePatch:new(Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\HighGround.jpg"), Vector2:new(GOAL_NOTE_SIZE, GOAL_NOTE_SIZE), Vector4:new(0, 0, 0, 0)),
		Type = "HighGround",
		Kills = 0,
		Activate = function(self)
			self.Kills = 0
		end,
		Process = function(self,elapsed)
			if(self.Kills == 1) then
				Achievement.ApplyReward()
			end
		end,
	},
	Switch = {
		Ninepatch = Singularity.Gui.NinePatch:new(Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\Switch.jpg"), Vector2:new(GOAL_NOTE_SIZE, GOAL_NOTE_SIZE), Vector4:new(0, 0, 0, 0)),
		Type = "Switch",
		Kills = 0,
		Victim = nil,
		IllusionHit = false,
		Elapsed = -1,
		TimeFrame = 10,
		Activate = function(self)
			self.Kills = 0
		end,
		Process = function(self,elapsed)
			if(self.IllusionHit and self.Kills == 1) then
				Achievement.ApplyReward()
			elseif(self.IllusionHit) then
				if(self.Elapsed < 0) then
					self.Elapsed = 0
				elseif(self.Elapsed > self.TimeFrame) then
					self.Elapsed = -1
					self.IllusionHit = false
				else
					self.Elapsed = self.Elapsed + elapsed
				end
			end
		end,
	},	
	--Done. Tested.
	Science =
	{
		Ninepatch = Singularity.Gui.NinePatch:new(Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\Science.jpg"), Vector2:new(GOAL_NOTE_SIZE, GOAL_NOTE_SIZE), Vector4:new(0, 0, 0, 0)),
		Type = "Science",
		Kills = 0,		
		Activate = function(self)
			self.Kills = 0
		end,
		Process = function(self,elapsed)
			if(self.Kills == 1) then
				Achievement.ApplyReward()
			end
		end,
	},
	--Done. Tested.
	MadScience = {
		Ninepatch = Singularity.Gui.NinePatch:new(Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\MadScience.jpg"), Vector2:new(GOAL_NOTE_SIZE, GOAL_NOTE_SIZE), Vector4:new(0, 0, 0, 0)),
		Kills = 0,
		Type = "MadScience",
		Activate = function(self)
			self.Kills = 0
		end,
		Process = function(self,elapsed)
			if(self.Kills == 1) then
				Achievement.ApplyReward()
			end
		end,
	},
	--Done. Tested.
	Survival =
	{
		Ninepatch = Singularity.Gui.NinePatch:new(Singularity.Graphics.Texture2D:LoadTextureFromFile(Main.AssetDirectory.."\\Textures\\HUD\\Survival.jpg"), Vector2:new(GOAL_NOTE_SIZE, GOAL_NOTE_SIZE), Vector4:new(0, 0, 0, 0)),
		Kills = 0,
		Type = "Survival",
		Activate = function(self)
			self.Kills = 0
		end,
		Process = function(self,elapsed)
			if(self.Kills == 1) then
				Achievement.ApplyReward()
			end
		end,
	}
}

--Tables grouping goals by difficulty and faction
Achievement.Goals.Easy = {Achievement.Goals.HealthCare, Achievement.Goals.Kill, Achievement.Goals.Science}
Achievement.Goals.Medium = {Achievement.Goals.Reduce, Achievement.Goals.HighGround, Achievement.Goals.MadScience}
Achievement.Goals.Hard = {Achievement.Goals.Conservation, Achievement.Goals.Switch, Achievement.Goals.Survival}

Achievement.Goals.Conservation = {Achievement.Goals.HealthCare, Achievement.Goals.Reduce, Achievement.Goals.Conservation}
Achievement.Goals.Tactical = {Achievement.Goals.Kill, Achievement.Goals.HighGround, Achievement.Goals.Switch}
Achievement.Goals.Modifiers = {Achievement.Goals.Science, Achievement.Goals.MadScience, Achievement.Goals.Survival}

Achievement.Rewards =
{
	Weak = {
		--Minor Speed (5)
		{
			Buff = Buff.CreateBuff("SpeedMinor", "Increases Speed by 5.", nil),
			Duration = 20,
			Activate = function(self)
				Player.Client.WalkRate = Player.Client.WalkRate + 5
			end,
			Deactivate = function(self)
				Player.Client.WalkRate = Player.Client.WalkRate - 5
			end,
		},
		--Minor Heal (1)
		{
			Duration = 20,
			TickTime = 1,
			Elapsed = 0,
			HPTick = 1,
			Buff = Buff.CreateBuff("HealthMinor", "Increases Regen by 1.", nil),
			Activate = function(self)
			end,
			Process = function(self, elapsed)
				self.Elapsed = self.Elapsed + elapsed
				if(self.Elapsed > self.TickTime) then
					self.Elapsed = 0
					--cap at 100 hp
					Player.Client.HP = math.min(100, Player.Client.HP + self.HPTick)
				end
			end,
			Deactivate = function(self)
			end,
		}
	},
	Medium = {
		--Medium Speed (15)
		{
			Buff = Buff.CreateBuff("SpeedMid", "Increases Speed by 15.", nil),
			Duration = 20,
			Activate = function(self)
				Player.Client.WalkRate = Player.Client.WalkRate + 15
			end,
			Deactivate = function(self)
				Player.Client.WalkRate = Player.Client.WalkRate - 15
			end,
		},
		--Medium Heal (3)
		{
			Duration = 20,
			TickTime = 1,
			Elapsed = 0,
			HPTick = 3,
			Buff = Buff.CreateBuff("HealthMid", "Increases Regen by 3.", nil),
			Activate = function(self)
			end,
			Process = function(self, elapsed)
				self.Elapsed = self.Elapsed + elapsed
				if(self.Elapsed > self.TickTime) then
					self.Elapsed = 0
					Player.Client.HP = math.min(100, Player.Client.HP + self.HPTick)
				end
			end,
			Deactivate = function(self)
			end,
		}
	},
	Strong = {
		--Major Speed (25)
		{
			Buff = Buff.CreateBuff("SpeedMajor", "Increases Speed by 25.", nil),
			Duration = 10,
			Activate = function(self)
				Player.Client.WalkRate = Player.Client.WalkRate + 25
			end,
			Deactivate = function(self)
				Player.Client.WalkRate = Player.Client.WalkRate - 25
			end,
		},
		--Major Heal (5)
		{
			Duration = 20,
			TickTime = 1,
			Elapsed = 0,
			HPTick = 5,
			Buff = Buff.CreateBuff("HealthMajor", "Increases Regen by 5.", nil),
			Activate = function(self)
			end,
			Process = function(self, elapsed)
				self.Elapsed = self.Elapsed + elapsed
				if(self.Elapsed > self.TickTime) then
					self.Elapsed = 0
					Player.Client.HP = math.min(100, Player.Client.HP + self.HPTick)
				end
			end,
			Deactivate = function(self)
			end,
		}
	}
}

Achievement.ApplyReward = function()
	--make a copy of the reward to store in the active list
	local rewardState =
	{
		Reward = Util.ShallowTableCopy(Achievement.Reward),
		Elapsed = 0,
	}
	
	--Apply reward
	Player.Client:AddBuff(Achievement.Reward.Buff)
	Achievement.Reward:Activate()
	table.insert(Achievement.ActiveEffects, rewardState)

	--Reset for next goal
	Achievement.Reward = nil
	Achievement.Goal = nil
	Achievement.Success = true
	Achievement.Elapsed = 0
end

Achievement.ProcessEffects = function(elapsed)
	
	local i = 1
	while i <= #Achievement.ActiveEffects do
		local rewardState = Achievement.ActiveEffects[i]
		rewardState.Elapsed =  rewardState.Elapsed + elapsed
		if(rewardState.Reward.Process) then
			rewardState.Reward:Process(elapsed)
		end
		if(rewardState.Elapsed > rewardState.Reward.Duration) then
			--kill the reward if it's done
			Player.Client:RemoveBuff(rewardState.Reward.Buff)
			rewardState.Reward:Deactivate()
			table.remove(Achievement.ActiveEffects, i)
			i = i - 1
		end
		i = i +1
	end
	
end

--Generate a goal based on how well the player is doing
Achievement.SelectGoal = function()
    Achievement.Goal = Achievement.Goals.Reduce
	Achievement.Reward = Achievement.Rewards.Medium[2]

	--[[
	local client = Player.Client
	local totalDiff = 0
	local cnt = 0
	--Calc kill-death differential for other team
	for k,v in pairs(Main.GamePlay.Players) do
		if(v.Team ~= client.Team) then
			cnt = cnt + 1
			totalDiff = totalDiff + (v.Kills - v.Deaths)
		end
	end

	--calc how im doing compared to them
	local est
	if(cnt > 0) then
		local avgDiff = totalDiff/cnt
		est = (client.Kills - client.Deaths) - avgDiff
	else
		est = (client.Kills - client.Deaths)
	end
	
	--based on how im doing, select an appropriate goal and reward set
	if(est > 6) then
		Achievement.Goal = Achievement.ChooseRandom(Achievement.Goals.Hard)
		Achievement.Reward = Achievement.ChooseRandom(Achievement.Rewards.Medium)
	elseif(est > 2) then
		Achievement.Goal = Achievement.ChooseRandom(Achievement.Goals.Medium)
		Achievement.Reward = Achievement.ChooseRandom(Achievement.Rewards.Weak)
	elseif(est > -3) then
		Achievement.Goal = Achievement.ChooseRandom(Achievement.Goals.Medium)
		Achievement.Reward = Achievement.ChooseRandom(Achievement.Rewards.Medium)
	elseif(est > -7) then
		Achievement.Goal = Achievement.ChooseRandom(Achievement.Goals.Medium)
		Achievement.Reward = Achievement.ChooseRandom(Achievement.Rewards.Strong)
	else
		Achievement.Goal = Achievement.ChooseRandom(Achievement.Goals.Easy)
		Achievement.Reward = Achievement.ChooseRandom(Achievement.Rewards.Strong)
	end     
	]]--
end

Achievement.ChooseRandom = function(arr)
	if(#arr > 0) then
		return arr[math.random(#arr)]
	else
		return nil
	end
end

Achievement.Enable = function()
	Achievement.Enabled = true
end

Achievement.Disable = function()
	Achievement.Enabled = false
	Achievement.Goal = nil
	Achievement.Reward = nil
end


Achievement.Update = function(elapsed)
	if(Achievement.Enabled) then
		if(Achievement.Goal == nil) then
			--if its time for a new goal
			if(not Achievement.Success or Achievement.Elapsed > BETWEEN_GOAL_COOLDOWN) then
				--make the goal
				Achievement.Success = false
				Achievement.SelectGoal()
				--prep it
				if(Achievement.Goal) then
					Achievement.Goal:Activate()
				end
			else
				Achievement.Elapsed = Achievement.Elapsed + elapsed
			end
		end
		if(Achievement.Goal) then
			Achievement.Goal:Process(elapsed)
		end
		Achievement.ProcessEffects(elapsed)
	end
end

print("Achievement System Loaded.\n")