Network = {}
Network.Callbacks = {}
Network.ID = 1
Network.Low = 1
Network.High = 9999
Network.ReliablePackets = {}
Network.RecentReliable = {}

Network.Debug = false

--reliable resend params
local NETWORK_MAX_TRIES = 3
local NETWORK_BETWEEN_TRIES = 0.1
local NETWORK_HOLD_TIME = 2

Network.SetNetwork = function(game)
	Network.NetworkGame = game
	Network.NetworkSession = tolua.cast(game, "Singularity::Networking::NetworkSession")
	--set callback on net traffic
	Network.NetworkGame.ProcessPacket:Add(tolua.cast(Singularity.Scripting.LuaNetworkDelegate:new(Network.Receive), "Singularity::IDelegate"))
end

--Serialize data for network
Network.Serialize = function(typeOf, val)

	Network.Serialized = {}
	table.insert(Network.Serialized, "Network.Type = ")
	table.insert(Network.Serialized, string.format("%q", typeOf))
	if(val) then
		table.insert(Network.Serialized, "\nNetwork.Value =\n")  
		Network.SerializeHelper(val)
	end
	return table.concat(Network.Serialized)
end

--Convert values to strings
Network.SerializeHelper = function(val)
	if type(val) == "number" then
		table.insert(Network.Serialized, val)
	elseif type(val) == "string" then
		table.insert(Network.Serialized, string.format("%q", val))
	elseif type(val) == "boolean" then
		table.insert(Network.Serialized, val and "true" or "false")
	elseif type(val) == "table" then
		table.insert(Network.Serialized, "{\n")
		for k,v in pairs(val) do		
			if(type(v) ~= "function" and type(v) ~= "userdata") then
				table.insert(Network.Serialized, "  [")
				Network.SerializeHelper(k)
				table.insert(Network.Serialized, "] = ")
				Network.SerializeHelper(v)
				table.insert(Network.Serialized, ",\n")
			end
		end
		table.insert(Network.Serialized, "}\n")
	end
end

--Compile the serialized message to extract its type and value
Network.Deserialize = function(val)
	local f, err = loadstring(val)
	if(err) then
		Util.Debug(val)
		Util.Debug(err)
	end
	f()
	return Network.Type, Network.Value
end

Network.Register = function(typeOf, func)
	--add the callback to the type's list
	if(not Network.Callbacks[typeOf]) then
		Network.Callbacks[typeOf] = {}
	end
	table.insert(Network.Callbacks[typeOf], func)
end

Network.Unregister = function(typeOf, func)
	--remove the callback from the type's list
	if(not Network.Callbacks[typeOf]) then
		return
	end
	local callbacks = Network.Callbacks[typeOf]
	for i = 1,#callbacks do
		if(callbacks[i] == func) then
			table.remove(callbacks, i)
		end
	end
end

--debug printing
Network.Dump = function(value)
	if(type(value) == "table") then
		Util.DumpTable(value)
	else
		Util.Debug(value)
	end
end

Network.Send = function(typeOf, val)
	if(not Network.NetworkGame and not Network.Debug) then
		return
	end
	--serialize data
	local serialized = Network.Serialize(typeOf, val)
	
	if(Network.Debug) then
		--Send calls receieve in debug
		Network.Receive(serialized)
	else
		--Call to C++ to send
		Network.NetworkSession:SendPacket(Singularity.Networking.LuaNetworkPacket:Create(serialized))
	end
end

Network.Resend = function(serialized)
	if(not Network.NetworkGame and not Network.Debug) then
		return
	end
	
	if(Network.Debug) then
		Network.Receive(serialized)
	else
		Network.NetworkSession:SendPacket(Singularity.Networking.LuaNetworkPacket:Create(serialized))
	end
end 

Network.SendReliable = function(typeOf, val)
	if(not Network.NetworkGame and not Network.Debug) then
		return
	end
	--give the message an ID
	val.SendID = Network.ID
	Network.ID = (Network.ID) % (Network.High) + 1
	local serialized = Network.Serialize(typeOf, val)
	--save packet for possible resend
	Network.ReliablePackets[val.SendID] = {Elapsed = 0, Data = serialized, Tries = NETWORK_MAX_TRIES}
	
	if(Network.Debug) then
		Network.Receive(serialized)
	else
		Network.NetworkSession:SendPacket(Singularity.Networking.LuaNetworkPacket:Create(serialized))
	end
end

Network.SetIDs = function(low, high)
	Network.ID = low
	Network.Low = low
	Network.High = high
end

Network.Receive = function(serialized)
	
	--Util.Debug(serialized)
	local typeOf, val = Network.Deserialize(serialized)
	
	--if we get an ack, nil out the resend entry
	if(typeOf:sub(1,3) == "Ack") then
		Network.ReliablePackets[tonumber(typeOf:sub(4))] = nil
		return
	end
	
	if(val.SendID) then		
		--prevent duplicates of reliable packets
		if(Network.RecentReliable[val.SendID]) then
			return
		else
			Network.RecentReliable[val.SendID] = 0
		end
		
		--Ack this packet
		Network.Send("Ack"..val.SendID)
		val.SendID = nil
	end
	
	--notify callbacks
	local callbacks = Network.Callbacks[typeOf]
	if(callbacks) then
		for _,v in ipairs(callbacks) do
			v(val)
		end
	end
end

Network.Update = function(elapsed)

		local deletion = {}

		for k,v in pairs(Network.ReliablePackets) do
			v.Elapsed = v.Elapsed + elapsed
			--try to resend
			if(v.Elapsed > NETWORK_BETWEEN_TRIES) then
				Network.ReliablePackets[tonumber(k)].Tries = v.Tries - 1
				Network.ReliablePackets[tonumber(k)].Elapsed = 0
				v.Elapsed = 0
				--resend
				Network.Resend(v.Data)
				if(v.Tries == 0) then
					--give up
					table.insert(deletion, k)					
				end
			end
		end

		--delete all packets that ran out of tries
		for _,v in pairs(deletion) do
			Network.ReliablePackets[v] = nil
		end

		for k,v in pairs(Network.RecentReliable) do
			Network.RecentReliable[k] = Network.RecentReliable[k] + elapsed
			--stop remembering packets after a while
			if(Network.RecentReliable[k] > NETWORK_HOLD_TIME) then
				Network.RecentReliable[k] = nil
			end
		end		
end

--Helper for sending position info
Network.AppendLocation = function(tab, obj)
	local xform = obj:Get_Transform()
	local pos = xform:Get_Position()
	local orient = xform:Get_Rotation()
	tab.Position = { x = pos.x, y = pos.y, z = pos.z }
	tab.Orientation = {x = orient.x, y = orient.y, z = orient.z, w = orient.w }
end

Util.Debug("Network Loaded.")