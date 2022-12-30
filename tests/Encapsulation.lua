require "oop"

-- Encapsulation is not provided here. But if you really need this, you may use specific method's scope.
EarthHuman = class()

function EarthHuman:init(firstName, lastName, birthDate)
	-- Public scope
	self.firstName = firstName
	self.lastName = lastName
	-- Initializing the private fields
	local private.birthDate = birthDate
	-- Declare the method which will address to the private fields
	function self:getAge()
		local curDate = os.date("*t")
		return curDate.year - private.birthDate.year
	end
end

-- Usual class method which will address to the public class method
function EarthHuman:print()
	print(string.format("Hello, I am mr. %s %s, I am %u years old.", self.firstName, self.lastName, self:getAge()))
end

-- Instance
mike = EarthHuman("Mike", "Wagner", {
	year = 1988,
	month = 5,
	day = 22
})

mike:print()

-- Let check the private fields. It is just for fun, because who knows Lua, also knows about scopes here and does not wait to get of something.
if mike.birthDate then
print(mike.birthDate.day)
end
-- This line didn't appear in the console!

-- Okay, lets check the private table in class definition scope:
if private then
print(private.birthDate.day)
end
-- This line didn't appear in the console too!


-- Conclusion: we can use scopes to hide out some class specific fields. Why not?
