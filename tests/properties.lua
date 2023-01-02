require "oop"

-- A class which will represent a database item.
StarshipPerson = class()

function StarshipPerson:init(lcConnection, id)
	self.connection = lcConnection
	self.id = id
end

-- The database speaking methods
function StarshipPerson:request(key)
	return self.connection[self.id][key]
end

function StarshipPerson:send(key, value)
	if key == "job" then
		return false, "The job title can be changed only captain."
	elseif key == "cabin" then
		return false, "The cabin can be changed only by steward."
	else
		self.connection[self.id][key] = value
		return true
	end
end

-- Create a properties which will  address to a database for getting requested item
-- First creation method:
StarshipPerson.firstname = property{
-- Getter:
	get = function(self) -- Note that here is one argument. Our class will pass the class instance there.
		print("Requesting firstname...")
		return self:request("firstname")
	end,
	-- Setter:
	set = function(self, value) -- Here is two arguments: first is our class instance and second is new value which will set to.
		print("Sending request to firstname change...")
		local retval, errorMessage = self:send("firstname", value)
		if retval then
			print("Successfully changed to", value)
		else
			print("Access denied:", errorMessage)
		end
	end
}
-- And another one:
StarshipPerson.lastname = property{
	get = function(self)
		print("Requesting lastname...")
		return self:request("lastname")
	end,
	set = function(self, value)
		print("Sending request to lastname change...")
		local retval, errorMessage = self:send("lastname", value)
		if retval then
			print("Successfully changed to", value)
		else
			print("Access denied:", errorMessage)
		end
	end
}

-- Second creation method:
StarshipPerson.job = property()
function StarshipPerson.job.get(instance) -- Yeah this is correct as codestyle dictates us because it is not a method.
	print("Requesting job...")
	return instance:request("job")
end
function StarshipPerson.job:set(value) -- Representation of this setter as method is correct too at this code place
	print("Sending request to job change...")
	local retval, errorMessage = self:send("job", value)
	if retval then
		print("Successfully changed to", value)
	else
		print("Access denied:", errorMessage)
	end
end

-- Another one:
StarshipPerson.cabin = property()
function StarshipPerson.cabin:get()
	print("Requesting cabin...")
	return self:request("cabin")
end
function StarshipPerson.cabin:set(value)
	print("Sending request to cabin change...")
	local retval, errorMessage = self:send("cabin", value)
	if retval then
		print("Successfully changed to", value)
	else
		print("Access denied:", errorMessage)
	end
end


-- An abstract  database
db = {
	{ firstname = "Yury", lastname = "Gagarin", job = "Captain", cabin = 1 },
	{ firstname = "Bob", lastname = "Katz", job = "Steward", cabin = 33 },
	{ firstname = "Olyvia", lastname = "Quiet", job = "Onboard psychologist", cabin = 20 },
	{ firstname = "Foo", lastname = "Bar", job = "Passenger", cabin = 50 }
}

-- So lets collect all crew personal data as class instances
local crew = {}
for id in ipairs(db) do
	table.insert(crew, StarshipPerson(db, id))
end

-- Lets print out all crew personal and find a passenger
passenger = nil
for _, crewItem in ipairs(crew) do
	print(string.format("%s %s: %s in %u cabin.", crewItem.firstname, crewItem.lastname, crewItem.job, crewItem.cabin))
	if crewItem.job == "Passenger" then
		passenger = crewItem
	end
end

if passenger then
	-- Lets check a setter, changing passenger's some data
	passenger.lastname = "Bas"
	passenger.cabin = 12
	-- Check our passenger's cabin
	print(string.format("Now the passenger's name is %s %s. They are living in %u cabin.", passenger.firstname, passenger.lastname, passenger.cabin))
end