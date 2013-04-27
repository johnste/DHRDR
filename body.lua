M = {
	x = 0,
	y = 0,
	fixtures = {},
	owner = nil,
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
	
	o.body = love.physics.newBody(world, o.x, o.y - (o.groundOffset or 0), "dynamic")
	
	for k, f in pairs(o.fixtures) do
		f.x, f.y = f.x or 0, f.y or 0
		f.shapeDef = love.physics.newRectangleShape(f.x, f.y, f.width, f.height)
		f.fixture = love.physics.newFixture(o.body, f.shapeDef)
		f.fixture:setDensity(f.density or o.density or 1)
		f.fixture:setFriction(f.friction or o.friction or 1)
		f.fixture:setRestitution(f.restitution or o.restitution or 0)
		f.fixture:setUserData(o.owner)					
		if f.image then				
			if images[f.image] and type(f.image) == "string" then
				f.image = images[f.image]
			elseif type(f.image) == "string" then
				f.image = nil
			end		
		end
	
	end
		
	o.body:resetMassData()
		
	return o
end

function M:draw()
	love.graphics.push()
	love.graphics.translate(self.body:getX(), self.body:getY())	
	love.graphics.rotate(self.body:getAngle())
	for n, f in pairs(self.fixtures) do
		
		if f.image and type(f.image) == "userdata" then			
			love.graphics.draw(f.image, -f.width/2 + f.x, -f.height/2 + f.y, 0, f.width/f.image:getWidth(), f.height/f.image:getHeight())
		else
			love.graphics.rectangle("line", -f.width/2 + f.x, -f.height/2 + f.y, f.width, f.height)			
		end
	end
	love.graphics.pop()
end
	

return M