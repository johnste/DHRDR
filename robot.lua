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
	
	
	
	return o
end

function M:draw()
	self.body:draw()
end

function M:collide(myFixture, theirFixture, contact)
end


return M