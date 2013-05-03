M = {
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
	
	
	
	o.level = level:new{file = "level0"}
	o.player = o.level:getPlayer()
	
	o.levelActive = false
	love.graphics.setBackgroundColor(255,255,255,255)
	return o
end

function M:update(dt)		

	
	
	self.level:update(dt)
	
	if (self.level:getState() == "finished") then
		if self.level.levelData.nextLevel then	
			local nextLevel = self.level.levelData.nextLevel
			local oldLevel = self.level
			self.level = nil
			
			oldLevel:destroy()
			
			self.level = level:new{file = nextLevel}
			self.player = self.level:getPlayer()
			print("new level")
		end
		
	end
	
	
end

function M:draw()
	
	self.level:draw()
	
end

function M:keypressed(key, unicode)
	self.level:keypressed(key, unicode)
end

function M:keyreleased(key, unicode)
	self.level:keyreleased(key, unicode)
end

function M:mousepressed(x, y, button)	
	self.level:mousepressed(x, y, button)
end

function M:mousereleased(x, y, button)	
	self.level:mousereleased(x, y, button)
end


return M