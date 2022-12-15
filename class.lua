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
		-- Create new getter
		---@param (string): the name of newgetter
		---@param lambda (function): the lambda which it will be called when this getter will   indexing by
		-- This function should not expect any parameters but should return a  value.
		---@return (table): returns the table with simplified newsetter function for sequent  call
		-- Please note: after second sequent chain part no value return!
		function instance:getter(name, lambda)
			if not self.__getters then
				self.__getters = {}
			end
			self.__getters[name] = lambda
			-- Allow to build sequent call
			return {setter = function(lambda) self.setter(self, name, lambda) end}
		end
		-- Create new setter
		---@param (string): the name of new setter
		---@param lambda (function): the lambda which it will be called when this setter will   indexing by
		-- This function should  expect new value in one parameter  and return nil.
		---@return (table): returns the table with simplified newsetter function for sequent  call
		-- Please note: after second sequent chain part no value return!
		function instance:setter(name, lambda)
			if not self.__setters then
				self.__setters = {}
			end
			self.__setters[name] = lambda
			return {getter = function(lambda) self.getter(self, name, lambda) end}
		end
		if not cls.init then
			if not extends then
				error("The class initialization method is not provided", 2)
			end
		else
			cls.init(instance, ...)
		end
		local gettersData, settersData = {}, {}
		if instance.__getters then
			for key, getter in pairs(instance.__getters) do
				gettersData[key] = getter
			end
			instance.__getters = nil
		end
		if instance.__setters then
			for key, setter in pairs(instance.__setters) do
				settersData[key] = setter
			end
			instance.__setters = nil
		end
		-- Free the names for class developer's purposes
		instance.__getters, instance.__setters = nil, nil
		setmetatable(instance, {
		__name = "class",
		__id = getmetatable(cls).__id,
			__index = function (self, key)
				if gettersData[key] then
					return gettersData[key]()
				end
				return rawget(cls, key)
			end,
			__newindex = function (self, key, value)
				if settersData[key] then
					settersData[key](value)
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
