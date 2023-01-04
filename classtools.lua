-- Some class tool functions

-- Checks the object is class and its affiliation for the specified class.
---@param instance (class instance): the class instance which should be checked.
---@param class (class, optional): the class which should bechecked. If this parameter omited, the function will check the given instance for any class affiliation.
---@return (boolean)true if the class instance is either a class or specified class, false - otherwise
function isclass(instance, class)
	local instMeta = getmetatable(instance)
	local clsMeta = getmetatable(class) or nil
	if type(instMeta) == "table" and type(clsMeta) == "table" then
		if instMeta.__name and clsMeta.__name then
			if instMeta.__id and clsMeta.__id then
				return instMeta.__id == clsMeta.__id
			end
		end
	elseif type(instMeta) == "table" and not clsMeta then
		if instMeta.__name then
			return (instMeta.__name == "class_instance" or instMeta.__name == "class") and instMeta.__id ~= nil
		end
	end
	return false
end

-- Creates a getter/setter property
---@param template (table, optional): a table which must contain the following keys:
	-- get (function, optional): getter function which will be called when the property index attempts
	-- set (function, optional): the setter function which will be called when a program attempts to assign something
-- When template argument omited, function creates an empty property which get/set fields might assigned later. Please note that new property can be set only these two keys and no one more else! Other fields will be ignored.
---@return new property which class insttance will be indexed as usual field.
function property(template)
	template = template or {}
	local newProperty = {}
	if template.get then
		newProperty.get = template.get
		newProperty.__hasgetter = true
	end
	if template.set then
		newProperty.set = template.set
		newProperty.__hassetter = true
	end
	local propertyMT = {}
	function propertyMT:__newindex(key, value)
		if key == "get" then
			rawset(self, "get", value)
			rawset(self, "__hasgetter", true)
		elseif key == "set" then
			rawset(self, "set", value)
			rawset(self, "__hassetter", true)
		end
	end
	setmetatable(newProperty, propertyMT)
	return newProperty
end
