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
	
	if o.scale then
		o.x = o.x * o.scale
		o.y = o.y * o.scale		
		o.groundOffset = o.groundOffset and o.groundOffset * o.scale
	end
	
	o.body = love.physics.newBody(world, o.x, o.y - (o.groundOffset or 0), "dynamic")
	
	for k, f in pairs(o.fixtures) do
		f.x, f.y = f.x or 0, f.y or 0
		
		if o.scale then
			f.x = f.x * o.scale
			f.y = f.y * o.scale
			f.width = f.width and f.width * o.scale
			f.height = f.height and f.height * o.scale
			f.radius = f.radius and f.radius * o.scale			
		end
	
		if f.shape == "circle" then
			f.shapeDef = love.physics.newCircleShape(f.x, f.y, f.radius)
		else
			f.shapeDef = love.physics.newRectangleShape(f.x, f.y, f.width, f.height)			
		end
		
		f.fixture = love.physics.newFixture(o.body, f.shapeDef)
		f.fixture:setDensity(f.density or o.density or 1)
		f.fixture:setFriction(f.friction or o.friction or 1)
		f.fixture:setRestitution(f.restitution or o.restitution or 0)
		f.fixture:setUserData(o.owner or o)		
		if (f.group) then
			for n, g in ipairs(f.group) do
				f.fixture:setGroupIndex(g)
			end
		end
		
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
		if f.shape == "circle" then
			if f.image and type(f.image) == "userdata" then			
				love.graphics.draw(f.image, -f.radius + f.x, -f.radius + f.y, 0, 2*f.radius/f.image:getWidth(),2*f.radius/f.image:getHeight())			
			else
				love.graphics.circle("line", f.x, f.y, f.radius)	
				love.graphics.line( f.x - f.radius, f.y, f.x + f.radius, f.y)
			end
				
		else
			if f.image and type(f.image) == "userdata" then			
				love.graphics.draw(f.image, -f.width/2 + f.x, -f.height/2 + f.y, 0, f.width/f.image:getWidth(), f.height/f.image:getHeight())			
			else
				love.graphics.setColor(0,0,255,255)
				love.graphics.rectangle("line", -f.width/2 + f.x, -f.height/2 + f.y, f.width, f.height)			
				love.graphics.setColor(255,255,255,255)
			end
		end
		
	end
	love.graphics.pop()
end
	
function M:collide(active, myFixture, theirFixture, contact, theirOwner)
	
end


return M