require "oop"

-- Basic class

Person = class()

-- Class initialization
function Person:__init(firstname, lastname)
	-- Fill out the self-fields
	self.firstname = firstname
	self.lastname = lastname
end

-- Class method
function Person:print()
	print(string.format("Hello world! My name is %s %s!", self.firstname, self.lastname))
end


-- Inherit class
Employee = class(Person)

function Employee:__init(firstname, lastname, company, job)
	-- Initializing the superclass
	self:super()(firstname, lastname)
	-- Fill next the extended fields
	self.company = company
	self.job = job
end

-- Class method
function Employee:print()
	-- Calling the same superclass  method
	self:super():print()
	-- Print next the extended fields
	print(string.format("I am working in %s and I am %s here.", self.company, self.job))
end

-- Initializing the inherit class instance
catherine = Employee("Catherine", "Ivanova", "Queen Mary University of London", "Sound engineering teacher")

-- Calling our new class instance method
catherine:print()
