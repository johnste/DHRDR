M = {
	x = 0,
	y = 0,
	width = nil,
	height = nil,
	angle = 0,
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

function M:draw()
	love.graphics.push()
	love.graphics.pop()	
end

return M