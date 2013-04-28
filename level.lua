M = {
	walls = {},
	bodies = {},
	levelData = nil,
	file = nil,
	score = 0,
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
	
	o.levelData = love.filesystem.load("level/".. o.file ..".lua")()
		
	-- load all walls
	for k, v in pairs(o.levelData.walls) do
		if v.image then
			if images[v.image] and type(v.image) == "string" then
				v.image = images[v.image]
			else
				v.image = nil
			end		
		end		
		
		v.scale = o.levelData.scale or 1
		o.walls[k] = static:new(v)
	end
	
	if(o.walls['target']) then
		o.target = o.walls['target']
		o.target.fixture:setUserData(o)
	end
	

	-- load all bodies
	for k, b in ipairs(o.levelData.bodies) do
		b.scale = o.levelData.scale or 1			
		table.insert(o.bodies, body:new(b))		
	end
	
	o.levelData.player.scale = o.levelData.scale or 1
	o.player = robot:new(o.levelData.player)
	
	o.camera:follow(o.player)
	
	o.images = {}
	if o.levelData.images then
		for k, v in pairs(o.levelData.images) do
			o.images[k] = love.graphics.newImage("level/" .. v)
		end		
	end
	
	
	
	
	return o
end

function M:draw()
	
	
	if self.images.background then
		love.graphics.setPixelEffect(robotVisionShader)
		love.graphics.draw(self.images.background, 0, 0, 0, 1, 1, 
			self.images.background:getWidth()/2 - self.levelData.imageOffset.x, 
			self.images.background:getHeight()/2 - self.levelData.imageOffset.y)
		love.graphics.setPixelEffect(nil)
	end
	
	if self.images.middleground then
		love.graphics.draw(self.images.middleground, 0, 0, 0, 1, 1, 
			self.images.middleground:getWidth()/2 - self.levelData.imageOffset.x, 
			self.images.middleground:getHeight()/2 - self.levelData.imageOffset.y)
	end
		
	for k, v in pairs(self.walls) do
		v:draw()
	end
	
	for k, v in ipairs(self.bodies) do
		v:draw()
	end
	
	self.player:draw()
	
	if self.images.foreground then
		love.graphics.draw(self.images.foreground, 0.5, 0.5, 0, 1, 1, 
			self.images.foreground:getWidth()/2 - self.levelData.imageOffset.x, 
			self.images.foreground:getHeight()/2 - self.levelData.imageOffset.y)
	end
	
	love.graphics.setColor(0,0,0,255)
	if self.score > 0 then
		love.graphics.print("Clutter left: " .. self.score, self.levelData.scorePos.x, self.levelData.scorePos.y)
	else
		love.graphics.print("You won!", self.levelData.scorePos.x, self.levelData.scorePos.y)
	end
	
	love.graphics.setColor(255,255,255,255)
end

function M:update(dt)
	self.player:update(dt)
end

function M:getPlayer()
	return self.player
end

function M:keypressed(key, unicode)
	self.player:keypressed(key, unicode)
end

function M:keyreleased(key, unicode)
	self.player:keyreleased(key, unicode)
end

function M:mousepressed(x, y, button)	
	
	for k, v in ipairs(self.bodies) do
			
	end

	self.player:mousepressed(x, y, button)
end

function M:mousereleased(x, y, button)
	self.player:mousereleased(x, y, button)
end


function M:collide(active, myFixture, theirFixture, contact, theirOwner)
	
	if active and theirOwner.score then
		self.score = self.score + (theirOwner.score or 0)
	elseif theirOwner.score then
		self.score = self.score - (theirOwner.score or 0)
		love.audio.rewind(sounds.points)
		love.audio.play(sounds.points)
	end
	
end

function M:getScore()
	return self.score
end
	

-- Objects!
M.obj = {}
M.obj.egg = {name = "egg", score = 25, groundOffset = 10, fixtures = {{ shape = "circle", density = 1, radius = 5, image = "egg" }}}
M.obj.milk = {name = "milk", score = 45, groundOffset = 10, fixtures = {{ density = 1, width = 10, height = 20, image = "milk" }}}

M.obj.chair = {name = "chair", score = 85, groundOffset = 20, fixtures = {
		{ width = 5, height = 45, image = "thinuprect", x = -13, density = 2},
		{ width = 5, height = 20, image = "thinuprect", x = 12, y = 12.5, density = 2},
		{ width = 30, height = 7, image = "siderect", density = 2, y = 5},
		
}}
M.obj.table = {name = "table", score = 115, groundOffset = 20, fixtures = {		
		{ width = 70, height = 10, image = "siderect", y = -35/2 },
		{ width = 10, height = 35, image = "uprect"},
		{ width = 40, height = 5, image = "siderect", y = 35/2},
}}

return M