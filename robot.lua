M = {
	x = 0,
	y = 0,
	width = nil,
	height = nil,
	angle = 0,
	image = nil,
	particleSystem = nil,
	weld = false,
	name = "robot",
	lastShot = nil
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
	
	local spread = 25
	
	o.objects = body:new({		
		bodies = {
			body = {
				name = "robot body", x = o.x, y = o.y,
				fixtures = {
					{width = 50, height = 20, group = {-1}, image = "robotbody", density = 5}
				}
			},
			wheel1 = {
				name = "robot wheel 1", x = o.x - spread, y = o.y,
				fixtures = {
					{shape = "circle", radius = 20, group = {-1}, image = "robotwheel", friction = 2}
				}
			},
			wheel2 = {
				name = "robot wheel 2", x = o.x + spread, y = o.y,
				fixtures = {
					{shape = "circle", radius = 20, group = {-1}, image = "robotwheel", friction = 2}
				}
			},
			sponge = {
				name = "robot sponge", x = o.x, y = o.y - 16,
				fixtures = {
					sponge = {shape = "circle", radius = 7, group = {-1}, image = "egg", friction = 2}
				}
			}
		}		
	}, {
		world = o.world, scale = o.scale or 1, owner = o,
	})
		
	o.joint = joint:new{		
		bodies = {o:getBody('body'), o:getBody('wheel1')}, scale = o.scale or 1,
		x = o.x - spread, y = o.y,
		torque = 7750,	motor = true, 
	}
	
	
	
	o.joint2 = joint:new{
		bodies = {o:getBody('body'), o:getBody('wheel2')}, scale = o.scale or 1,
		x = o.x + spread, y = o.y,
		torque = 7750,	motor = true, 	
	}
	
	o:getBody('sponge'):setLinearDamping(0.6)	
	
	o.spongeJoint = joint:new{		
		jointType = "rope",
		bodies = {o:getBody('body'), o:getBody('sponge')}, scale = o.scale or 1,
		x = o.x, y = o.y,
		x2 = o.x, y2 = o.y-16,
		maxLength = 370,
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
	self.objects:draw()

	
	if(self.weld) then
		love.graphics.draw(self.particleSystem, 0, 0)		
	end
	
	
	
	local x1,y1,x2,y2 = self.spongeJoint.joint:getAnchors() 	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.setLineWidth(7)
	love.graphics.line(x1,y1,x2,y2)
	love.graphics.setColor(247, 119, 26, 255)
	love.graphics.setLineWidth(3)
	love.graphics.line(x1,y1,x2,y2)
	love.graphics.setColor(255, 255, 255, 255)	
	
	

	
	
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
	
	
	
	local dir = {
		x = self.objects.bodies.body.body:getX() - self.objects.bodies.sponge.body:getX() - 100 * math.cos(self.objects.bodies.body.body:getAngle() + math.tau/4),
		y = self.objects.bodies.body.body:getY() - self.objects.bodies.sponge.body:getY() - 100 * math.abs(math.sin(self.objects.bodies.body.body:getAngle() + math.tau/4))
	}
	local length = math.sqrt(dir.x * dir.x + dir.y * dir.y)	
	dir.x = dir.x / length
	dir.y = dir.y / length
	
	if self.weld and self.testJoint then
		if(self.weldedBody and self.weldedBody:getType() == "dynamic") then
			self.objects.bodies.body.body:applyForce(dir.x * -1000 * length/1000, dir.y * -1000* length/1000)		
			self.objects.bodies.sponge.body:applyForce(dir.x * 600* length/800, dir.y * 600* length/500)
		else
			self.objects.bodies.body.body:applyForce(dir.x * -4800 * length/700, dir.y * -4800* length/700)		
		end
	else
		self.objects.bodies.sponge.body:applyForce(dir.x * 100, dir.y * 100 )
	end
	
	
	
	if self.createWeld and self.weld then
		self.testJoint = love.physics.newWeldJoint(
			self:getBody('sponge'), self.createWeld:getBody(), 
			self:getBody('sponge'):getX(), 
			self:getBody('sponge'):getY(), 
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
		self.particleSystem:setPosition(self.objects.bodies.sponge.body:getX(), 
			self.objects.bodies.sponge.body:getY())
		self.particleSystem:start()
	end
	
end

function M:keypressed(key, unicode)
	
end

function M:keyreleased(key, unicode)
	
end

function M:mousepressed(cx, cy, button)
	
	if button == "l" and ((not self.lastShot) or love.timer.getTime() - self.lastShot > 0.5) then
		self.lastShot = love.timer.getTime()
		local x1, y1 = self.objects.bodies.body.body:getPosition()
		--self.sponge.body:setPosition(x1,y1 - 16)
		
		local dir = {
			x = cx - self.objects.bodies.sponge.body:getX(),
			y = cy - self.objects.bodies.sponge.body:getY()
		}
		local length = math.sqrt(dir.x * dir.x + dir.y * dir.y)		
		dir.x = dir.x / length
		dir.y = dir.y / length
		
		if (self.testJoint and self.weldedBody and self.weldedBody:getType() == "dynamic") then
			self.objects.bodies.sponge.body:applyLinearImpulse(dir.x * 150, dir.y * 150)
		else
			self.objects.bodies.sponge.body:applyLinearImpulse(dir.x * 50, dir.y * 50)
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
	if (active and not theirFixture:isSensor() and myFixture == self:getFixture('sponge','sponge') and theirOwner ~= self and not self.testJoint) then
		self.createWeld = theirFixture		
	end
	
end

function M:destroy()
	self.objects:destroy()


end

function M:getBody(body)
	return self.objects:getBody(body)
end

function M:getFixture(body, fixture)
	return self.objects:getFixture(body, fixture)
end

return M