-- Class realisation

-- Function of class declaration
---@param extends The class which new class should be inherits (optional, if omited the new empty class will be defined)
---@return not initialized class definition.
function class(extends)
	local function generateClassID()
		local result = {}
		local base = "abcdefghijklmnopqrstuvwxyz1234567890"
		for i = 1, 128 do
			local charIndex = math.random(#base)
			table.insert(result, ({ [1] = base:sub(charIndex, charIndex):lower(), [2] = base:sub(charIndex, charIndex):upper() })[math.random(1, 2)])
		end
		return table.concat(result, "")
	end
	local object = {}
	local ourMT = {}
	ourMT.__name = "class"
	ourMT.__id = generateClassID()
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
				})
			end
		end
		instance.fromClass = cls
		if not cls.init then
			if not extends then
				error("The class initialization method is not provided", 2)
			end
		end
		cls.init(instance, ...)
		local hiddenData = {}
		for key, value in pairs(instance) do
			if type(value) == "table" then
				if value.__hasgetter or value.__hassetter then
					hiddenData[key] = value
					instance[key] = nil
				end
			end
		end
		setmetatable(instance, {
		__name = "class",
		__id = getmetatable(cls).__id,
			__index = function (self, key)
				local maybeValue = hiddenData[key] or cls[key] or rawget(self, key)
				if type(maybeValue) == "table" and maybeValue.__hasgetter then
					return maybeValue.get(self)
				end
				return maybeValue
			end,
			__newindex = function (self, key, value)
				local maybeObject = hiddenData[key] or cls[key] or self[key]
				if type(maybeObject) == "table" and maybeObject.__hassetter then
					maybeObject.set(self, value)
					return
				end
				rawset(self, key, value)
			end,
			-- The class destructor when GC performs
			__gc = cls.destroy,
			-- Assign the metamethods using class methods
			-- To re-define your class methods just declare their namesake method  of metamethods
			__call = cls.__call,
			__tostring = cls.__tostring,
			__len = cls.__len,
			__pairs = cls.__pairs,
			__ipairs = cls.__ipairs,
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
			__bshr = __bshr,
		})
		return instance
	end
	if extends then
		ourMT.__index = extends
	end
	setmetatable(object, ourMT)
	return object
end
