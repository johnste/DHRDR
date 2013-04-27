M = {}

function M:new(data)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	
	if data then
		for k, v in pairs(data) do
			o[k] = v
		end		
	end	
	
	o.world = love.physics.newWorld(0, 50)
	o.world:setCallbacks(o.collisionStart, o.collisionStop)
	o.cam = camera:new{
	}

	return o
end

function M:update(dt)
end

function M:draw()
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