Tween = {}

Tween.Tween =
{
	--Base constructor
	MakeTween = function(duration)
		local ret =
		{
			Duration = duration,
		}
		
		return ret
	end,
	--Tween evaluation functions. Return incremental values.
	LinearFunction = function(self, timeSoFar)
		local oldLast = self.LastValue		
		self.LastValue = (timeSoFar/self.Duration) * (self.FinalValue - self.InitialValue) + self.InitialValue
		self.TotalAdded = self.TotalAdded + (self.LastValue - oldLast)
		return self.LastValue - oldLast
	end,
	SinFunction = function(self, timeSoFar)
		local oldLast = self.LastValue
		self.LastValue = math.sin((2*math.pi*timeSoFar)/(self.Period))*self.Amplitude
		self.TotalAdded = self.TotalAdded + (self.LastValue - oldLast)
		return self.LastValue - oldLast
	end,
	CosFunction = function(self, timeSoFar)
		local oldLast = self.LastValue
		self.LastValue = math.cos((2*math.pi*timeSoFar)/(self.Period))*self.Amplitude
		self.TotalAdded = self.TotalAdded + (self.LastValue - oldLast)
		return self.LastValue - oldLast
	end,
	--Specific tween type constructors
	MakeLinearTween = function(duration, initalVal, finalVal)
		local ret = Tween.Tween.MakeTween(duration)
		ret.InitialValue = initalVal
		ret.FinalValue = finalVal
		ret.Evaluate = Tween.Tween.LinearFunction;
		ret.EndValue = finalVal
		return ret
	end,
	MakeSinTween = function(duration, amplitude, period)
		local ret = Tween.Tween.MakeTween(duration)
		ret.Amplitude = amplitude
		ret.Period = period
		ret.Evaluate = Tween.Tween.SinFunction;
		ret.EndValue = math.sin((2*math.pi*duration)/(period))*amplitude
		return ret
	end,
	MakeCosTween = function(duration, amplitude, period)
		local ret = Tween.Tween.MakeTween(duration)
		ret.Amplitude = amplitude
		ret.Period = period
		ret.Evaluate = Tween.Tween.CosFunction;
		ret.EndValue = math.cos((2*math.pi*duration)/(period))*amplitude
		return ret
	end,
	--Duplicates a tween
	CopyTween = function(tween)
		return Util.ShallowTableCopy(tween)
	end
}

--Modifier functions
Tween.TweenGetSet = 
{
	Scale =
	{
		GetScale = function(self)
			return self:Get_Transform():Get_Scale().x
		end,
		SetScale = function(self, newScale)
			self:Get_Transform():Set_Scale(Vector3:new(newScale, newScale, newScale))
		end,
	}
}

Tween.GrantScaleFunctionality = function(obj)
	obj.GetScale = Tween.TweenGetSet.Scale.GetScale
	obj.SetScale = Tween.TweenGetSet.Scale.SetScale
	
	return obj
end

Tween.TweenSet =
{
	--makes an empty tween set
	MakeTweenSet = function()
		local ret = Util.ShallowTableCopy(Tween.TweenSet.Functions)
		ret.Tweens = {}
		ret.Start = 9999999
		ret.Finish = 0
		ret.Loop = 1
		return ret
	end,
	LoopInfinite = -1,
	Functions =
	{
		Bind = function(self, tween, offset, arg1, arg2)
			local newEntry =
			{
				Tween = tween,
				Offset = offset,
				Active = false,
				InitialValue = 0,
			}
			--if there's one arg, its a property name
			if(arg2 == nil) then
				newEntry.Property = arg1
			--otw its a getter and setter
			else
				newEntry.Get = arg1
				newEntry.Set = arg2
			end
			
			table.insert(self.Tweens, newEntry)
			
			--update the tween set start and end times
			if(tween.Duration + offset > self.Finish) then
				self.Finish = tween.Duration + offset
			end
			if(offset < self.Start) then
				self.Start = offset
			end
		end,
		SetTarget = function(self, target)
			self.Target = target
		end,
		SetLoopCount = function(self, amount)
			self.Loop = amount
		end
	}
}

Tween.Tweener =
{
	ActiveTweenSets = {},
	Play = function(set)
		local playing = false
		--cant play the same set twice at the same time
		for k,v in pairs(Tween.Tweener.ActiveTweenSets) do
			if(set == v) then
				playing = true
				break
			end
		end
		if(not playing) then
			table.insert(Tween.Tweener.ActiveTweenSets, set)
		end
		--init
		set.TimeSoFar = 0
		set.Initialized = false
		set.LoopCurrent = set.Loop
		for k,v in pairs(set.Tweens) do
			v.Active = false
		end
	end,
	Pause = function(set)
		set.Paused = true
	end,
	Resume = function(set)
		set.Paused = false
	end,
	Stop = function(set)
		for i=1, #Tween.Tweener.ActiveTweenSets do
			--delete the tween
			if(Tween.Tweener.ActiveTweenSets[i] == set) then
				table.remove(Tween.Tweener.ActiveTweenSets, i)
				return
			end
		end
	end,
	Update = function(elapsed)
		local i = 1
		while i <= #Tween.Tweener.ActiveTweenSets do
			local set = Tween.Tweener.ActiveTweenSets[i]
			if(not set.Paused) then
				--count time
				set.TimeSoFar = set.TimeSoFar + elapsed
				--set expired?
				if(set.TimeSoFar > set.Finish) then
					--for each tween in the set
					for k,v in pairs(set.Tweens) do
						if(v.Active) then
							--finish out
							if(v.Property ~= nil) then
								set.Target[v.Property] = set.Target[v.Property] - v.Tween.TotalAdded + v.Tween.EndValue
							elseif(v.Set ~= nil) then
								set.Target[v.Set](set.Target, set.Target[v.Get](set.Target) - v.Tween.TotalAdded + v.Tween.EndValue)
							end
						elseif(not set.Initialized) then
							--never got to tween, just jump to final values
							if(v.Property ~= nil) then
								set.Target[v.Property] = set.Target[v.Property] + v.Tween.EndValue
							elseif(v.Set ~= nil) then
								set.Target[v.Set](set.Target, set.Target[v.Get](set.Target) + v.Tween.EndValue)
							end	
						end
					end
				
					if(set.Loop ~= Tween.TweenSet.LoopInfinite) then
						set.LoopCurrent = set.LoopCurrent - 1
					end
					
					--set is done looping, remove it
					if(set.LoopCurrent == 0) then
						table.remove(Tween.Tweener.ActiveTweenSets, i)
						i = i - 1
					else
						--otw, reset it and go again
						set.TimeSoFar = 0
						for k,v in pairs(set.Tweens) do
							v.Active = false
						end
					end				
				--running	
				elseif(set.TimeSoFar > set.Start) then
					set.Initialized = true
					if(set.Target ~= nil) then
						for k,v in pairs(set.Tweens) do
							--in tween's time range
							if(set.TimeSoFar > v.Offset and set.TimeSoFar < (v.Offset + v.Tween.Duration)) then
								--do initialization
								if(not v.Active) then
									--property, not get/set
									if(v.Property ~= nil) then
										v.Tween.LastValue = 0		
										v.Tween.TotalAdded = 0
									elseif(v.Get ~= nil) then
										v.Tween.LastValue = 0
										v.Tween.TotalAdded = 0
									end
									v.Active = true
								end								
								
								--update
								if(v.Property ~= nil) then
									local nextVal = set.Target[v.Property]
									nextVal = nextVal + v.Tween:Evaluate(set.TimeSoFar - v.Offset)
									set.Target[v.Property] = nextVal
								elseif(v.Set ~= nil) then
									local nextVal = set.Target[v.Get](set.Target)
									nextVal = nextVal + v.Tween:Evaluate(set.TimeSoFar - v.Offset)
									set.Target[v.Set](set.Target, nextVal)
								end	
							--exited the tween's range, finish it
							elseif(set.TimeSoFar > v.Offset and v.Active) then
								v.Active = false
								if(v.Property ~= nil) then
									set.Target[v.Property] = set.Target[v.Property] - v.Tween.TotalAdded + v.Tween.EndValue
								elseif(v.Set ~= nil) then
									set.Target[v.Set](set.Target, set.Target[v.Get](set.Target) - v.Tween.TotalAdded + v.Tween.EndValue)
								end	
							end				
						end
					end
				end
				i = i + 1
			end
		end
	end
}
print("Tween System Loaded.")