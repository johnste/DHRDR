M = {
	x = 0,
	y = 0,
	width = nil,
	height = nil,
	angle = 0,
	image = nil,
}

function M:new(data)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	
	if data then
		for k, v in pairs(data) do
			o[k] = v
		end		
	end	

	o.body = body:new{
		owner = o, x = o.x, y = o.y,
		fixtures = {
			{width = 50, height = 25, group = {1}, image = "robotbody"}
		}
	}
	
	o.wheel1 = body:new{
		owner = o, x = o.x - 15, y = o.y + 8,
		fixtures = {
			{shape = "circle", radius = 10, image = "robotwheel"}
		}
	}
	
	o.wheel2 = body:new{
		owner = o, x = o.x + 15, y = o.y + 8,
		fixtures = {
			{shape = "circle", radius = 10, image = "robotwheel"}
		}
	}
	
	o.joint = joint:new{		
		bodies = {o.body, o.wheel1},
		x = o.x - 15, y = o.y + 8,
		torque = 2000,	motor = true, 
	}
	
	o.joint = joint:new{
		bodies = {o.body, o.wheel2},
		x = o.x + 15, y = o.y + 8,
		torque = 2000,	motor = true, 	
	}
	
	return o
end

function M:draw()
	self.body:draw()
	self.wheel1:draw()
	self.wheel2:draw()
end

function M:collide(myFixture, theirFixture, contact)
end


return M