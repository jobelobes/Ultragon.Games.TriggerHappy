ColliderSmoother = {
	Colliders = {},
	Create = function(collider, time, enter, stay, exit)
		local obj = {
			Colliding = false,
			Collider = collider,
			Time = time,
			CurrentTime = 0,
			Enter = enter,
			Stay = stay,
			Exit = exit,
		}
		ColliderSmoother.AddEnterCallback(collider, obj)
        ColliderSmoother.AddStayCallback(collider, obj)
        
        table.insert(ColliderSmoother.Colliders, obj)
	end,
	AddEnterCallback = function(collider, smootherObj)
		local enterFunc = function(col, tar)
			if(not smootherObj.Colliding) then
				smootherObj.Colliding = true
				if(smootherObj.Enter) then
					local ret = smootherObj.Enter(col, tar)
					if(not ret) then
						ColliderSmoother.Destroy(smootherObj)
					end
				end
			end
			
			smootherObj.CurrentTime = 0
		end
		collider.CollisionEnter:Add(tolua.cast(Singularity.Scripting.LuaCollisionDelegate:new(enterFunc), "Singularity::IDelegate"))
	end,
	AddStayCallback = function(collider, smootherObj)
		local stayFunc = function(col, tar)
			if(smootherObj.Stay) then
				local ret = smootherObj.Stay(col, targ)
				if(not ret) then
					ColliderSmoother.Destroy(smootherObj)
				end
			end
			smootherObj.CurrentTime = 0
		end
		collider.CollisionStay:Add(tolua.cast(Singularity.Scripting.LuaCollisionDelegate:new(stayFunc), "Singularity::IDelegate"))
	end,
	Destroy = function(smootherObj)
	end,
	Update = function(elapsed)
		local i = 1
		while i <= #ColliderSmoother.Colliders do
			local v = ColliderSmoother.Colliders[i]
        	if(v.Colliding) then
        		v.CurrentTime = v.CurrentTime + elapsed
        		if(v.CurrentTime > v.Time) then
        			v.Colliding = false
        			v.CurrentTime = 0
        			if(v.Exit) then
        				local ret = v.Exit()
        				if(not ret) then
                            ColliderSmoother.Destroy(smootherObj)
							i = i - 1
						end
					end
				end
			end
			i = i + 1
		end
	end
}

Util.Debug("Collider Smoother Loaded")