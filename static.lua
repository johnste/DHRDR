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

	if not M.ground then
		M.ground = love.physics.newBody(world, 0, 0, "static")
	end
	
	o.shape = love.physics.newRectangleShape(o.x, o.y, o.width, o.height, o.angle)
	love.physics.newFixture(M.ground, o.shape)
	return o
end

function M:draw()

	if not self.image then
		love.graphics.polygon("line", self.shape:getPoints())
	else
		love.graphics.draw(self.image, self.x, self.y, self.angle, self.width/self.image:getWidth(), self.height/self.image:getHeight(), self.image:getWidth()/2, self.image:getHeight()/2)
	end
	
	
end

return M