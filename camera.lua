M = {
	target = nil,
	x = 0,
	y = 0,
	offset = { 
		x = love.graphics.getWidth()/2,
		y = love.graphics.getHeight()/2 + 100,
	}
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
	
	return o
end

function M:set()
	love.graphics.push()
	love.graphics.translate(self.offset.x, self.offset.y)
	love.graphics.scale(1, 1)
	if self.target then
		self.x = -self.target.body.body:getX()
		self.y = -self.target.body.body:getY()
	end
	
	love.graphics.translate(self.x, self.y)
end

function M:unset()
	love.graphics.pop()
end

function M:follow(obj)
	self.target = obj
end

function M:mousePosition(x, y)
	return x - self.x - self.offset.x, y - self.y - self.offset.y
end


return M