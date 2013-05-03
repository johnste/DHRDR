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
	
	love.graphics.setBackgroundColor(255,255,255,255)
	
	o.playRect = {
		x = love.graphics.getWidth()/2 - 60, 
		y = 325, 
		width = 120, 
		height = 60,
	}
	
	o.exitRect = {
		x = love.graphics.getWidth()/2 - 60, 
		y = 405, 
		width = 120, 
		height = 60,
	}
	
	love.audio.play(sounds.music)
	return o
end

function M:update(dt)	

end

function M:draw()

	love.graphics.draw(images.menu, 
		love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, 1,1,
		images.menu:getWidth()/2,  images.menu:getHeight()/2)
	
	--[[
	love.graphics.setColor(255, 0,0,255)
	love.graphics.rectangle("line", love.graphics.getWidth()/2 - 60, 325, 120, 60)
	love.graphics.rectangle("line", love.graphics.getWidth()/2 - 60, 405, 120, 60)
	love.graphics.setColor(255, 255,255,255)
	--]]
end

function M:keypressed(...)
	
end

function M:keyreleased(...)

end

function M:mousepressed(x, y, button)
	if self:pointInRect(x, y, self.playRect) then
		states.play = playstate:new()
		currentState = states.play
	elseif self:pointInRect(x, y, self.exitRect) then
		 love.event.quit()
	end	
end

function M:mousereleased(x, y, button)

end

function M:pointInRect(x, y, rect)
	 return x > rect.x and y > rect.y and x < rect.x + rect.width and y < rect.y + rect.height
end




return M