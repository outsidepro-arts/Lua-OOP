require "oop"

-- Basic class

Person = class()

-- Class initialization
function Person:init(firstname, lastname)
	-- Fill out the self-fields
	self.firstname = firstname
	self.lastname = lastname
end

-- Protected (static) class method
function Person:static_print()
	print(string.format("Hello world! My name is %s %s!", self.firstname, self.lastname))
end

-- Initializing the class instance
bob = Person("Bob", "Katz")

-- Calling the class method
bob:print()
-- Attempt to replace the static class method
function bob:print()
	print("I wouldn't want to inform you my private data.")
end

-- Checking it again
bob:print()