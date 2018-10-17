package.path = package.path .. ";./?/init.lua" .. ";./?.lua"

math.round = function(n)
	if n % 1 >= 0.5 then
		return math.ceil(n)
	else
		return math.floor(n)
	end
end

math.sign = function(n)
	if n == 0 then return 0
	else return n / math.abs(n)
	end
end

table.print = function(self, i, tables)
	local i = i or 1
	local tables = tables or {[self] = true}
	
	if i == 1 then
		print(tostring(self))
	end
	for key, value in pairs(self) do
		io.write(string.rep(" ", i) .. tostring(key) .. ": ")
		if type(value) == "table" and not tables[value] then
			tables[value] = true
			io.write("\n")
			table.print(value, i+1, tables)
		else
			print(value)
		end
	end
end

string.trim = function(self)
	return self:match("^%s*(.-)%s*$")
end

string.split = function(self, divider, notPlain)
	local position = 0
	local output = {}
	
	for endchar, startchar in function() return self:find(divider, position, not notPlain) end do
		table.insert(output, self:sub(position, endchar - 1))
		position = startchar + 1
	end
	table.insert(output, self:sub(position))
	
	return output
end

table.export = function(object)
	local object = object or {}
	local out = {}
	table.insert(out, "{")
	for key, value in pairs(object) do
		local key = key
		if type(key) == "number" then
			key = "[" .. key .. "]"
		end
		if type(value) == "string" then
			table.insert(out, key .. " = " .. string.format("%q", value) .. ", ")
		elseif type(value) == "number" then
			table.insert(out, key .. " = " .. value .. ", ")
		end
	end
	table.insert(out, "}")
	
	return table.concat(out)
end

table.leftequal = function(object1, object2)
	if type(object1) ~= "table" or type(object2) ~= "table" then
		return
	end
	
	for key in pairs(object1) do
		if object1[key] ~= object2[key] then
			return
		end
	end
	
	return true
end

table.equal = function(object1, object2)
	return table.leftequal(object1, object2) and table.leftequal(object2, object1)
end

local search = function(key, parents)
	for i = 1, #parents do
		local value = parents[i][key]
		if value then return value end
	end
end
createClass = function(...)
	local class = {}
	local parents = {...}
	
	setmetatable(class, {
		__index = function(object, key)
			local value = search(key, parents)
			object[key] = value
			return value
		end
	})
	
	class.__index = class
	class.new = function(self, object)
		local object = object or {}
		setmetatable(object, class)
		
		return object
	end
	
	return class
end

belong = function(...)
	local args = {...}
	
	for i = 1, #args / 3 do
		local x, sx, ex = args[3*(i - 1) + 1], args[3*(i - 1) + 2], args[3*(i - 1) + 3]
		if x < sx or x > ex then
			return false
		end
	end
	
	return true
end

map = function(value, x1, x2, x3, x4)
	return (value - x1) * (x4 - x3) / (x2 - x1) + x3
end

table.clone = function(object)
	local newObject = {}
	
	for key, value in pairs(object) do
		newObject[key] = value
	end
	
	return newObject
end

table.copy = function(object1, offset1, object2, offset2, size)
	for i = 1, size do
		object2[offset2 + i] = object1[offset1 + i]
	end
end

string.mirror = function(s)
	local out = {}
	for i = 1, #s do
		table.insert(out, 1, s:sub(i, i))
	end
	return table.concat(out)
end

trycatch = function(try, catch)
	local status, result = pcall(try)
	if not status then catch(result) end
	return result
end