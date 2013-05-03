M = {
	walls = {},
	bodies = {},
	levelData = nil,
	file = nil,
	score = 0,
	timeFinished = nil,
	state = "play",	
	accumulator = 0,
	name = "static",
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
	
	o.bodies = {}
	o.walls = {}
	
	self.resetLevel(o)
	
	return o
end

function M:resetLevel()
	self.state = "init"
	
	self:destroy()
	self.score = 0
	
	self.levelData = love.filesystem.load("level/".. self.file ..".lua")()
	
	self.world = love.physics.newWorld(self.levelData.gravity[1], self.levelData.gravity[2])
	love.physics.setMeter(100)

	
	self.world:setCallbacks(self.collisionStart, self.collisionStop)
	
	self.camera = camera:new{}	
	
	
		
	-- load all walls
	for k, v in pairs(self.levelData.walls) do
		if v.image then
			if images[v.image] and type(v.image) == "string" then
				v.image = images[v.image]
			else
				v.image = nil
			end		
		end		
		
		v.scale = self.levelData.scale or 1
		v.world = self.world
		self.walls[k] = static:new(v)
	end
	
	if(self.walls['target']) then
		self.target = self.walls['target']
		self.target.fixture:setUserData(self)
	end
	
	if(self.walls['world']) then
		self.worldbox = self.walls['world']
		self.worldbox.fixture:setUserData(self)
	end
	
	settings = { world = self.world, scale = self.levelData.scale or 1 }

	self.maxClutter = 0 
	-- load all bodies	
	for k, b in pairs(self.levelData.bodies) do	
		table.insert(self.bodies, body:new(b, settings))			
		for m, bods in pairs(b.bodies) do
			self.maxClutter = self.maxClutter + table.getn(bods.fixtures) * b.score
		end
		
	end
	
	
	self.levelData.player.scale = self.levelData.scale or 1
	self.levelData.player.world = self.world
	self.player = robot:new(self.levelData.player)
	
	self.camera:follow(self.player)
	
	self.images = {}
	if self.levelData.images then
		for k, v in pairs(self.levelData.images) do
			self.images[k] = love.graphics.newImage("level/" .. v)
		end		
	end
	self.state = "play"
	
	self.clutterBarQuad = love.graphics.newQuad(0, 0, 185, 48, 185, 96)
	self.clutterScoreBarQuad = love.graphics.newQuad(0, 48, 185, 48, 185, 96)
end


function M:draw()	
	self.camera:set()	
	
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
	
	self.camera:unset()
	
		
	love.graphics.setPixelEffect(clutterBarShader)	
	love.graphics.drawq(images.bar, self.clutterScoreBarQuad, love.graphics.getWidth()/2 - 185/2, 10,  0, 1, 1)		
	love.graphics.setPixelEffect(nil)
	--love.graphics.rectangle("fill", love.graphics.getWidth()/2 - (185/2) +  185 * (self.score/self.maxClutter), 10, 185* (1- self.score/self.maxClutter), 48)	
	
	love.graphics.drawq(images.bar, self.clutterBarQuad, (love.graphics.getWidth()/2 - 185/2), 10)
	
	love.graphics.setColor(0,0,0,255)
	if self.score > 0 then
		--love.graphics.print("Clutter: " .. math.floor(100*self.score/self.maxClutter) .. "%", 0,0)
	elseif self.timeFinished then
		
		local left = 3 - (love.timer.getTime() - self.timeFinished)
		love.graphics.print(tostring(math.floor(left)+1), (love.graphics.getWidth()/2 - 5) + 5, 25)
		if left <= 0 then
			self.timeFinished = nil
		end
		self.state = "countdown"
	elseif self.state == "countdown" then
		self.state = "finished"
		--love.graphics.print("You won!",0, 0)
	else
		--love.graphics.print("Wut?", 0, 0)
	end
	
	
	love.graphics.setColor(255,255,255,255)
	
end

function M:update(dt)
	
	self.accumulator = self.accumulator + dt
	while self.accumulator > 0.016 do
		self.world:update(0.016)		
		self.accumulator = self.accumulator - 0.016
	end
	
	
	if self.state == "resetLevel" then				
		self:resetLevel()
		love.audio.rewind(sounds.die)
		love.audio.play(sounds.die)
	end
	
	for k, v in ipairs(self.bodies) do
		if v.toDelete then
			v:destroy()
			table.remove(self.bodies, k)
		end		
	end
	
	
	
	self.player:update(dt)
end

function M:getPlayer()
	return self.player
end

function M:keypressed(key, unicode)	
	if key == "r" then		
		self.state = "resetLevel"
	end
		
	self.player:keypressed(key, unicode)
end

function M:keyreleased(key, unicode)
	self.player:keyreleased(key, unicode)
end

function M:mousepressed(x, y, button)	
	
	x, y = self.camera:mousePosition(x, y)	
	self.player:mousepressed(x, y, button)
end

function M:mousereleased(x, y, button)
	x, y = self.camera:mousePosition(x, y)	
	self.player:mousereleased(x, y, button)
end


function M:collide(active, myFixture, theirFixture, contact, theirOwner)	
	if myFixture == self.target.fixture then
		
		if theirOwner.score then
			if active then
				self.score = self.score + (theirOwner.score or 0)
			else
				self.score = self.score - (theirOwner.score or 0)
				love.audio.rewind(sounds.points)
				love.audio.play(sounds.points)
				if (self.score <= 0) then
					self.timeFinished = love.timer.getTime()
				end			
			end
			clutterBarShader:send("ratio", self.score/self.maxClutter)
		end
		
		
	elseif myFixture == self.worldbox.fixture and not active then				
		if theirOwner == self.player and (self.state == "play" or self.state == "countdown") then
			self.state = "resetLevel"	
		end
		
		if theirOwner ~= self.player then
			theirOwner.toDelete = true
		end
		
	end	
end

function M:getState()
	return self.state
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
	
function M:destroy()	
	if self.world then
		for k, v in pairs(self.walls) do
			v:destroy()
		end
		self.walls = {}
		
		for k, v in ipairs(self.bodies) do
			v:destroy()
		end
		self.bodies = {}		
		
		self.player:destroy()
		self.player = nil
		
		self.world:destroy()
		self.world = nil
	end
end



return M