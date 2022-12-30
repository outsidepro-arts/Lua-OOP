require "oop"

-- Basic class

Person = class()

-- Class initialization
function Person:init(firstname, lastname)
	-- Fill out the self-fields
	self.firstname = firstname
	self.lastname = lastname
end

-- Class method
function Person:print()
	print(string.format("Hello world! My name is %s %s!", self.firstname, self.lastname))
end

-- Initializing the class instance
bob = Person("Bob", "Katz")

-- Calling the class method
bob:print()
