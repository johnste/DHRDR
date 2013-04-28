M = {
	x = 0,
	y = 0,
	width = nil,
	height = nil,
	angle = 0,
	image = nil,
	particleSystem = nil,
	weld = false,
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
		owner = o, x = o.x, y = o.y, scale = o.scale or 1,
		fixtures = {
			{width = 50, height = 20, group = {-1}, image = "robotbody", density = 5}
		}
	}
	
	local spread = 25
	
	o.wheel1 = body:new{
		owner = o, x = o.x - spread, y = o.y + 5, scale = o.scale or 1,
		fixtures = {
			{shape = "circle", radius = 17, group = {-1}, image = "robotwheel", friction = 2}
		}
	}
	
	o.wheel2 = body:new{
		owner = o, x = o.x + spread, y = o.y +5 , scale = o.scale or 1,
		fixtures = {
			{shape = "circle", radius = 17, group = {-1}, image = "robotwheel", friction = 2}
		}
	}
	

	
	o.joint = joint:new{		
		bodies = {o.body, o.wheel1}, scale = o.scale or 1,
		x = o.x - spread, y = o.y+5,
		torque = 9000,	motor = true, 
	}
	
	o.joint2 = joint:new{
		bodies = {o.body, o.wheel2}, scale = o.scale or 1,
		x = o.x + spread, y = o.y+5,
		torque = 9000,	motor = true, 	
	}
	
	
	o.sponge = body:new{
		owner = o, x = o.x, y = o.y - 16, scale = o.scale or 1,
		fixtures = {
			sponge = {shape = "circle", radius = 7, group = {-1}, image = "egg", friction = 2}
		}
	}
	
	o.sponge.body:setLinearDamping(0.2)
	
	o.spongeJoint = joint:new{		
		jointType = "rope",
		bodies = {o.body, o.sponge}, scale = o.scale or 1,
		x = o.x, y = o.y-10/love.physics.getMeter(),
		x2 = o.x, y2 = o.y-16,
		maxLength = 380,
		collide = false, 		
	}
	
	o.particleSystem = love.graphics.newParticleSystem(images['thrust'], 1000)
	o.particleSystem:setEmissionRate(100)
	o.particleSystem:setSpeed(10, 100)
	o.particleSystem:setGravity(500)
	o.particleSystem:setSizes(1, 1)	
	o.particleSystem:setPosition(400, 300)
	o.particleSystem:setLifetime(0)
	o.particleSystem:setParticleLife(0.1)
	o.particleSystem:setDirection(math.tau + math.pi/10)
	o.particleSystem:setSpread(math.pi/5)
	o.particleSystem:setRadialAcceleration(0)
	o.particleSystem:setTangentialAcceleration(0)
	

	o.particleSystem:stop()
	o.particleSystem:setPosition(0,0)
	
	return o
end

function M:draw()
	self.body:draw()
	self.wheel1:draw()
	self.wheel2:draw()

	
	if(self.weld) then
		love.graphics.draw(self.particleSystem, 0, 0)		
	end
	self.sponge:draw()	
	
	---[[
	local x1,y1,x2,y2 = self.spongeJoint.joint:getAnchors() 
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.setLineWidth(7)
	love.graphics.line(x1,y1,x2,y2)
	love.graphics.setColor(247, 119, 26, 255)
	love.graphics.setLineWidth(3)
	love.graphics.line(x1,y1,x2,y2)
	love.graphics.setColor(255, 255, 255, 255)	
	--]]

	
	
end

function M:update(dt)
	if (love.keyboard.isDown("left") or love.keyboard.isDown"a") then
		self.joint.joint:setMotorSpeed(-math.tau * 3)
		self.joint2.joint:setMotorSpeed(-math.tau * 3)
		--love.audio.rewind(sounds.engine)
		love.audio.play(sounds.engine)
	end

	if (love.keyboard.isDown("right") or love.keyboard.isDown("d")) then
		self.joint.joint:setMotorSpeed(math.tau * 3)
		self.joint2.joint:setMotorSpeed(math.tau * 3)
		--love.audio.rewind(sounds.engine)
		love.audio.play(sounds.engine)
	end

	
	if (not (love.keyboard.isDown("right") or love.keyboard.isDown("d") or love.keyboard.isDown("left") or love.keyboard.isDown("a"))) then
		self.joint.joint:setMotorSpeed(0)
		self.joint2.joint:setMotorSpeed(0)
		love.audio.stop(sounds.engine)
	end
	
	if not love.graphics.hasFocus() then
		self.joint.joint:setMotorSpeed(math.tau * 0.1)
		self.joint2.joint:setMotorSpeed(math.tau * 0.1)
	end
	
	self.particleSystem:update(dt)
	
	--[[
	print("anc", self.spongeJoint.joint:getAnchors())
	print("bdy", self.body.body:getPosition())
	print("spg", self.sponge.body:getPosition())
	print("-------------------------------------------------------------")
	io.flush()
	--]]
	
	
	local dir = {
		x = self.body.body:getX() - self.sponge.body:getX() - 100 * math.cos(self.body.body:getAngle() + math.tau/4),
		y = self.body.body:getY() - self.sponge.body:getY() - 100 * math.abs(math.sin(self.body.body:getAngle() + math.tau/4))
	}
	local length = math.sqrt(dir.x * dir.x + dir.y * dir.y)	
	dir.x = dir.x / length
	dir.y = dir.y / length
	
	if self.weld and self.testJoint then
		if(self.weldedBody and self.weldedBody:getType() == "dynamic") then
			self.body.body:applyForce(dir.x * -1000 * length/1000, dir.y * -1000* length/1000)		
			self.sponge.body:applyForce(dir.x * 600* length/800, dir.y * 600* length/500)
		else
			self.body.body:applyForce(dir.x * -3800 * length/700, dir.y * -3800* length/700)		
		end
	else
		self.sponge.body:applyForce(dir.x * 100, dir.y * 100)
	end
	
	
	
	if self.createWeld and self.weld then
		self.testJoint = love.physics.newWeldJoint(
			self.sponge.body, self.createWeld:getBody(), 
			self.sponge.body:getX(), 
			self.sponge.body:getY(), 
			false)
		self.weldedBody = self.createWeld:getBody()
		self.createWeld = false
		love.audio.rewind(sounds.sponge)
		love.audio.play(sounds.sponge)
	end
	
	if not self.weld and self.testJoint then		
		self.testJoint:destroy()
		self.testJoint = nil
	end
	
	if self.weld then
		self.particleSystem:setPosition(self.sponge.body:getX(), 
			self.sponge.body:getY())
		self.particleSystem:start()
	end

end

function M:keypressed(key, unicode)
	
end

function M:keyreleased(key, unicode)
	
end

function M:mousepressed(cx, cy, button)
	
	if button == "l" then
		local x1, y1 = self.body.body:getPosition()
		--self.sponge.body:setPosition(x1,y1 - 16)
		
		local dir = {
			x = cx - self.sponge.body:getX(),
			y = cy - self.sponge.body:getY()
		}
		local length = math.sqrt(dir.x * dir.x + dir.y * dir.y)		
		dir.x = dir.x / length
		dir.y = dir.y / length
		
		if (self.weldedBody and self.weldedBody:getType() == "dynamic" and self.testJoint) then
			self.sponge.body:applyLinearImpulse(dir.x * 150, dir.y * 150)
		else
			self.sponge.body:applyLinearImpulse(dir.x * 50, dir.y * 50)
		end
		self.weld = true
		love.audio.rewind(sounds.fire)
		love.audio.play(sounds.fire)
		
		self.createWeld = false
	elseif button == "r" then
		self.weld = false		
	end
	
end

function M:mousereleased(x, y, button)
	if button == "r" then
		self.weld = false
		self.createWeld = false		
	end
end

function M:collide(active, myFixture, theirFixture, contact, theirOwner)
	if (active and not theirFixture:isSensor() and myFixture == self.sponge.fixtures.sponge.fixture and theirOwner ~= self and not self.testJoint) then
		self.createWeld = theirFixture		
	end
	
end


return M