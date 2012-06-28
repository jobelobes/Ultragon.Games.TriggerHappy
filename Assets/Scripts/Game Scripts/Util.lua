--Constants
DIK_Z = 0x2C
DIK_X = 0x2D
DIK_A = 0x1E
DIK_S = 0x1F
DIK_D = 0x20
DIK_W = 0x11
LEFT = 0
RIGHT = 1
DIK_F = 33
DIK_R = 19
DIK_E = 0x12
DIK_Q = 0x10
DIK_P = 0x19
DIK_K = 0x25

-- 02 - 0B
DIK_1 = 0x02
DIK_2 = 0x03
DIK_3 = 0x04
DIK_4 = 0x05
DIK_5 = 0x06
DIK_6 = 0x07
DIK_7 = 0x08
DIK_8 = 0x09
DIK_9 = 0x0A
DIK_0 = 0x0B

DIK_SPACE = 0x39
DIK_LSHIFT = 0x2A
DIK_LBRACKET = 0x1A
DIK_RBRACKET = 0x1B
DIK_TAB = 0x0F
DIK_F1 = 0x3B

Util = {}

--Does not copy subtables
Util.ShallowTableCopy = function(table)
	local ret = {}
	for k,v in pairs(table) do
		ret[k] = v
	end
	
	return ret
end

--merges tables
Util.JoinTables = function(t1, t2)
	for k,v in pairs(t2) do
		t1[k] = v
	end
	return t1
end

--formats and prints a table
Util.DumpTable = function(intable, indent)
	indent = indent or 0
	
	for k,v in pairs(intable) do

		local line = ""
		for i = 1,indent do
			line = line .. " "
		end
		line = line..k
		if(type(v) ~= "table") then
        	print(line.." = "..tostring(v))
		else
			print(line)
			Util.DumpTable(v,indent + 1)
		end
	end
end

Util.GetMeshAndMaterial = function(path)
	--local importer = Singularity.Content.SmurfModelImporter:new("P:\\gdd_capstone\\")
	local importer = Singularity.Content.SmurfModelImporter:new("C:\\Users\\IGMAdmin\\Desktop\\gdd_capstone\\")
	--local importer = Singularity.Content.SmurfModelImporter:new("D:\\Schoolwork\\Capstone\\gdd_capstone\\")
	local mesh = Singularity.Content.ModelLoader:LoadMesh(path, 0, importer)
	
	local material = Singularity.Content.ModelLoader:LoadMaterial(path, 0, importer)
	return mesh,material
end

--compiles a Lua file and reports errors if there are any
Util.LoadFile = function(file)
	local fileFunc, err = loadfile(file)
	if(fileFunc) then
		fileFunc()
	else
		Util.Debug(err)
	end
end

--Vector manipulation functions
Util.Normalize = function(vec)

	local mag = math.sqrt(vec.x*vec.x + vec.y*vec.y + vec.z*vec.z)
	
	if(mag > 0) then
		vec.x = vec.x / mag
		vec.y = vec.y / mag
		vec.z = vec.z / mag
	end
	
	return vec

end

Util.Vector3Add = function(vec1, vec2)
	local vec = Vector3:new(0,0,0)
	vec.x = vec1.x + vec2.x
	vec.y = vec1.y + vec2.y
	vec.z = vec1.z + vec2.z
	
	return vec
end

Util.Vector3Subtract = function(vec1, vec2)
	local vec = Vector3:new(0,0,0)
	vec.x = vec1.x - vec2.x
	vec.y = vec1.y - vec2.y
	vec.z = vec1.z - vec2.z
	
	return vec
end

Util.Vector3Negate = function(vec)
	vec.x = vec.x * -1
	vec.y = vec.y * -1
	vec.z = vec.z * -1
	
	return vec
end

Util.Vector3CrossProduct = function(v1, v2)
	local result = Vector3:new()
	result.x = v1.y*v2.z - v1.z*v2.y
	result.y = v1.z*v2.x - v1.x*v2.z
	result.z = v1.x*v2.y - v1.y*v2.x
	
	return result
end

Util.Vector3LengthSquared = function(vec)
	return (vec.x*vec.x + vec.y*vec.y + vec.z*vec.z)
end

Util.QuaternionMultiply = function(q1, q2)
	product = Quaternion:new(0,0,0,0)
	product.w = (q2.w * q1.w) - (q2.x * q1.x) - (q2.y * q1.y) - (q2.z * q1.z);
	product.x = (q2.w * q1.x) + (q2.x * q1.w) + (q2.y * q1.z) - (q2.z * q1.y);
	product.y = (q2.w * q1.y) - (q2.x * q1.z) + (q2.y * q1.w) + (q2.x * q1.x);
	product.z = (q2.w * q1.z) + (q2.x * q1.y) - (q2.y * q1.x) + (q2.z * q1.w);
	return product
end

Util.Switch = function(t)
	t.case = function (self, x)
		local f = self[x] or self.default
		if f then
			if type(f) == "function" then
				f(x, self)
			else
				Util.Debug("case " ..tostring(x).." not a function")
			end
		end
	end
	
	return t
end

--Verifies that a component label is of a certain type
--[[Util.VerifyLabel = function(label, typeOf)
	local start = string.find(label, "-", 1)
	if(not start) then
		Util.Debug("returning false")
		return false
	end
	
	local FullLabel = label:sub(start+1)
	
	Util.Debug(FullLabel == typeOf)
	return (FullLabel == typeOf)
end
--]]
Util.VerifyLabel = function(label, typeOf)
	local result = string.find(label, typeOf)
	
	return result
end

--Extracts IDs from a label
Util.ExtractID = function(label)
	Util.Debug("incoming collider label: "..label)
	local start = string.find(label, "-", 1)
	
	if(start) then
	
		-- First we look in front of the dash.
	
		local FullID = label:sub(1,start-1)
		local point = string.find(FullID, "%.")
		
		Util.Debug("Before the -")
		if(point == nil) then
			local result = tonumber(FullID)
			if (result ~= nil) then -- this means it's after the dash
				Util.Debug("Found "..FullID)
				return tonumber(FullID)
			end
		else
			local ID1 = FullID:sub(1,point)
			local ID2 = FullID:sub(point+2)
			Util.Debug("Found two: "..ID1.." "..ID2)
			return tonumber(ID1), tonumber(ID2)
		end		
		
		-- Now we look afterwards.
		
		FullID = label:sub(start+1, -1) -- after the dash
		point = string.find(FullID, "%.")
		
		Util.Debug("After the -")
		if(point == nil) then
			local result = tonumber(FullID)
			if (result ~= nil) then -- this means something is wrong
				Util.Debug("Found "..FullID)
				return tonumber(FullID)
			end
		else
			local ID1 = FullID:sub(1,point)
			local ID2 = FullID:sub(point+2)
			Util.Debug("Found two: "..ID1.." "..ID2)
			return tonumber(ID1), tonumber(ID2)
		end	
		
		-- Nothing. Fail.
		return -1
	else
		return -1
	end
end

--[[Util.ExtractID = function(label)

end--]]

Util.Debug = function(...)
	
	if(Util.DebugEnabled) then
		print(...)
	end
	
	--[[if(Util.DebugEnabled) then
		local msg, tabC = ...		
		local tabs = ""
		
		if tabC ~= nil then
			for t=0,tabC do
				tabs = tabs.."\t"
			end
		end		
		print(tabs..msg)				
	end]]--
end