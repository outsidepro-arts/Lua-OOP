-- Class realisation

-- Function of class declaration
---@param extends The class which new class should be inherits (optional, if omited the new empty class will be defined)
---@return not initialized class definition.
function class(extends)
	local object = {}
	local ourMT = {}
	ourMT.__name = "class"
	ourMT.__id = math.random(1, 1000000000)
	-- Declare new class instance
	--@param ... The initialization parameters which was been declared in attached 'init' method
	--@return New class instance
	ourMT.__call = function (cls, ...)
		local instance = {}
		if extends then
			function instance.super(invoker, ...)
				return setmetatable({}, {
					__index = function(self, key)
						if type(extends[key]) == "function" then
							return function(_, ...) return extends[key](invoker, ...) end
						end
						return extends[key]
					end,
					__call = function(_, ...)
						extends.__init(invoker, ...)
					end
				})
			end
		end
		instance.fromClass = cls
		if not cls.__init then
			if not extends then
				error("The class initialization method is not provided", 2)
			end
		end
		cls.__init(instance, ...)
		local hiddenData = {}
		for key, value in pairs(instance) do
			if type(value) == "table" then
				if value.__hasgetter or value.__hassetter then
					hiddenData[key] = value
					instance[key] = nil
				end
			else
				if key:find("^static_") then
					hiddenData[key] = value
					instance[key] = nil
				end
			end
		end
		setmetatable(instance, {
		__name = "class_instance",
		__id = getmetatable(cls).__id,
			__index = function (self, key)
				if rawget(self, "__index") then return rawget(self, "__index")(self, key) end
				if rawget(cls, "__index") then return rawget(cls, "__index")(self, key) end
				local maybeValue = hiddenData[key] or cls[key] or hiddenData[string.format("static_%s", key)] or cls[string.format("static_%s", key)]
				if type(maybeValue) == "table" and maybeValue.__hasgetter then
					return maybeValue.get(self)
				end
				return maybeValue
			end,
			__newindex = function (self, key, value)
				if rawget(self, "__newindex") then  rawget(self, "__newindex")(self, key, value) return end
				if cls.__newindex then cls.__newindex(self, key, value) return end
				local maybeObject, maybeStaticObject = hiddenData[key] or cls[key], hiddenData[string.format("static__%s", key)] or cls[string.format("static_", key)]
				if type(maybeObject) == "table" and maybeObject.__hassetter then
					maybeObject.set(self, value)
					return
				end
				if maybeObject and not maybeStaticObject then
					rawset(self, key, value)
				end
			end,
			-- The class destructor when GC performs
			__gc = cls.__destroy,
			-- Assign the metamethods using class methods
			-- To re-define your class methods just declare their namesake method  of metamethods
			__call = cls.__call,
			__tostring = cls.__tostring,
			__len = cls.__len,
			__pairs = cls.__pairs,
			__ipairs = cls.__ipairs,
			__close = cls.__close, -- Lua 5.4 to-be-closed variables support
			__unm = cls.__unm,
			__add = cls.__add,
			__sub = cls.__sub,
			__mul = cls.__mul,
			__div = cls.__div,
			__mod = cls.__mod,
			__pow = cls.__pow,
			__concat = cls.__concat,
			__idiv = cls.__idiv,
			__eq = cls.__eq,
			__lt = cls.__lt,
			__le = cls.__le,
			__band = cls.__band,
			__bor = cls.__bor,
			__bxor = cls.__bxor,
			__bnot = cls.__bnot,
			__bshl = cls.__bshl,
			__bshr = cls.__bshr,
		})
		return instance
	end
	if extends then
		ourMT.__index = extends
	end
	setmetatable(object, ourMT)
	return object
end
