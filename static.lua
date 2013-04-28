M = {
	x = 0,
	y = 0,
	width = 200,
	height = 10,
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

	
	ground = love.physics.newBody(world, 0, 0, "static")
	
	
	if o.scale then
		o.x = o.x * o.scale
		o.y = o.y * o.scale
		o.width = o.width * o.scale
		o.height = o.height * o.scale
	end
	
	o.shape = love.physics.newRectangleShape(o.x, o.y, o.width, o.height, o.angle)
	o.fixture = love.physics.newFixture(ground, o.shape)
	o.fixture:setSensor(o.sensor or false)
	o.fixture:setUserData(o.owner)
	
	return o
end

function M:getGround()
	return ground
end

function M:draw()

	if not self.image then
		if (self.sensor) then
			love.graphics.setColor(0,155,155,255)
		else
			love.graphics.setColor(0,255,0,255)
		end
		
		--love.graphics.polygon("line", self.shape:getPoints())	
		love.graphics.setColor(255,255,255,255)
	end
	
	
end

return M