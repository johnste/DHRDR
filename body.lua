M = {
	x = 0,
	y = 0,
	fixtures = {},
	owner = nil,
	world = nil,	
}

function M:new(data, settings)
	local o = {}
	setmetatable(o, self)
	self.__index = self	
	
	if data then
		for k, v in pairs(data) do
			o[k] = v
		end		
	end	
	
		
	if settings.scale then
		o.x = o.x * settings.scale
		o.y = o.y * settings.scale		
		settings.groundOffset = settings.groundOffset and settings.groundOffset * settings.scale
	end
	
	for l, b in pairs(o.bodies) do
		if settings.scale then
			if b.x then
				b.x = b.x * settings.scale
			end
			if b.y then
				b.y = b.y * settings.scale		
			end			
		end	
		
		b.x, b.y = b.x or o.x, b.y or o.y
		
		b.body = love.physics.newBody(settings.world, b.x, b.y - (settings.groundOffset or 0), "dynamic")
		
		for k, f in pairs(b.fixtures) do
			f.x, f.y = f.x or 0, f.y or 0
			
			if settings.scale then
				f.x = f.x * settings.scale
				f.y = f.y * settings.scale
				f.width = f.width and f.width * settings.scale
				f.height = f.height and f.height * settings.scale
				f.radius = f.radius and f.radius * settings.scale			
			end			
		
			if f.shape == "circle" then
				f.shapeDef = love.physics.newCircleShape(f.x, f.y, f.radius)
			else
				f.shapeDef = love.physics.newRectangleShape(f.x, f.y, f.width, f.height)			
			end
			
			f.fixture = love.physics.newFixture(b.body, f.shapeDef)
			f.fixture:setDensity(f.density or o.density or 1)
			f.fixture:setFriction(f.friction or o.friction or 1)
			f.fixture:setRestitution(f.restitution or o.restitution or 0)
			f.fixture:setUserData(settings.owner or o)		
			if (f.group or o.group) then
				for n, g in ipairs(f.group or o.group) do
					f.fixture:setGroupIndex(g)
				end
			end
			
			if f.image then				
				if images[f.image] and type(f.image) == "string" then
					f.image = images[f.image]
				elseif type(f.image) == "string" then
					f.image = nil
				end		
			end
		
		end
	
		b.body:resetMassData()
	end

	if o.joints then
		for k, f in pairs(o.joints) do
			f.x, f.y = f.x or 0, f.y or 0
			
			if settings.scale then
				f.x = f.x * settings.scale
				f.y = f.y * settings.scale			
			end

			f.joint = joint:new{
				bodies = { o:getBody(f.bodies[1]), o:getBody(f.bodies[2]) }, scale = 1,
				x = f.x + o.x, y = f.y + o.y, limits = f.limits
			}
		end
	end			

		
	return o
end

function M:getBody(body)
	if not self.bodies[body] then
		print (self.name, body, self.bodies)
		io.flush()
	end
	
	return self.bodies[body].body
end

function M:getFixture(body, fixture)
	return self.bodies[body].fixtures[fixture].fixture
end

function M:getJoint(joint)
	return self.joints[joint].joint.joint
end


function M:draw()
	--[[if self.joints then
		for k, f in pairs(self.joints) do
		local x1, y1 = self:getJoint(k):getAnchors()
			love.graphics.setColor(255, 0, 255, 255)
			love.graphics.circle("fill", x1, y1, 10)		
			love.graphics.setColor(255, 255,255, 255)
		end
	end
	--]]
	for l, b in pairs(self.bodies) do
		local body = self:getBody(l)
		
		love.graphics.push()
		love.graphics.translate(body:getX(), body:getY())	
		love.graphics.rotate(body:getAngle())
		
		for n, f in pairs(b.fixtures) do
			if f.shape == "circle" then
				if f.image and type(f.image) == "userdata" then			
					love.graphics.draw(f.image, -f.radius + f.x, -f.radius + f.y, 0, 2*f.radius/f.image:getWidth(),2*f.radius/f.image:getHeight())			
				else
					love.graphics.circle("line", f.x, f.y, f.radius)	
					love.graphics.line( f.x - f.radius, f.y, f.x + f.radius, f.y)
				end
					
			else
				if f.image and type(f.image) == "userdata" then			
					love.graphics.draw(f.image, -f.width/2 + f.x, -f.height/2 + f.y, 0, f.width/f.image:getWidth(), f.height/f.image:getHeight())			
				else
					love.graphics.setLineWidth(1)
					love.graphics.setColor(0,0,255,55)
					love.graphics.rectangle("line", -f.width/2 + f.x, -f.height/2 + f.y, f.width, f.height)			
					love.graphics.setColor(255,255,255,255)
				end
			end
			
		end
		love.graphics.pop()
	end
end

function M:destroy()
	for l, b in pairs(self.bodies) do
		local body = self:getBody(l)
		body:destroy()		
	end
end
	
	
function M:collide(active, myFixture, theirFixture, contact, theirOwner)
	
end


return M