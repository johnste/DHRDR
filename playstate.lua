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
	
	world = love.physics.newWorld(0, 300)
	love.physics.setMeter(100)
	world:setCallbacks(o.collisionStart, o.collisionStop)
	o.cam = camera:new{}	
	o.level = level:new{file = "level2", camera = o.cam}
	o.player = o.level:getPlayer()
	o.levelActive = false
	love.graphics.setBackgroundColor(255,255,255,255)
	return o
end

function M:update(dt)	
	world:update(dt)
	self.level:update(dt)
	
	if (self.level:getScore() == 0) then
		if self.level.levelData.nextLevel then
			world = love.physics.newWorld(0, 300)
			world:setCallbacks(self.collisionStart, self.collisionStop)
			self.cam = camera:new{}	
			self.level = level:new{file = self.level.levelData.nextLevel, camera = self.cam}
			self.player = self.level:getPlayer()
			self.levelActive = false
		else
			
		end
		
	else 
		self.levelActive = true
	end
	
	
end

function M:draw()
	self.cam:set()
	self.level:draw()
	self.cam:unset()
	
end

function M:keypressed(...)
	self.level:keypressed(arg)
end

function M:keyreleased(...)
	self.level:keyreleased(arg)
end

function M:mousepressed(x, y, button)
	x, y = self.cam:mousePosition(x, y)	
	self.level:mousepressed(x, y, button)
end

function M:mousereleased(x, y, button)
	x, y = self.cam:mousePosition(x, y)
	self.level:mousereleased(x, y, button)
end

function M.collisionStart(fixture1, fixture2, contact)
	local userData1, userData2 = fixture1:getUserData(), fixture2:getUserData()
	
	if userData1 then
		userData1:collide(true, fixture1, fixture2, contact, userData2)
	end
	
	if userData2 then
		userData2:collide(true, fixture2, fixture1, contact, userData1)
	end
end

function M.collisionStop(fixture1, fixture2, contact)
	local userData1, userData2 = fixture1:getUserData(), fixture2:getUserData()
	
	if userData1 then
		userData1:collide(false, fixture1, fixture2, contact, userData2)
	end
	
	if userData2 then
		userData2:collide(false, fixture2, fixture1, contact, userData1)
	end
end


return M