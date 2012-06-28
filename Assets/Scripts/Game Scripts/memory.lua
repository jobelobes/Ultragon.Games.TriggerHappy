Memory = {}

--Run GC often for short periods
collectgarbage("setpause", 0)
collectgarbage("setstepmul", 100)
collectgarbage("stop")

Memory.Update = function(elapsed)

	collectgarbage("collect")

end

print("Memory Loaded")
