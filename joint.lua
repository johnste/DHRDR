M = {
	x = 0,
	y = 0,
	motor = false,
	limits = nil,
	speed = 0,
	torque = 0,
	force = 0,
	jointType = "revolute",
	bodies = {}
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

	if o.scale then
		o.x = o.x * o.scale
		o.y = o.y * o.scale				
		o.x2 = o.x2 and o.x2 * o.scale
		o.y2 = o.y2 and o.y2 * o.scale				
	end

	if (o.jointType == "revolute") then
		o.joint = love.physics.newRevoluteJoint(o.bodies[1], o.bodies[2], o.x, o.y)
		if (o.limits) then
			o.joint:setLimits(o.limits[1], o.limits[2])
			o.joint:enableLimit(true)
		end
		
		
		o.joint:enableMotor(o.motor)
		if (o.motor) then
			o.joint:setMaxMotorTorque(o.torque or 100)
			o.joint:setMotorSpeed(o.speed or math.tau)
		end
		
		
	elseif (o.jointType == "rope") then
		--o.joint = love.physics.newRopeJoint(o.bodies[1].body, o.bodies[2].body, o.x, o.y, o.x2, o.y2, o.maxLength, o.collide)
		--o.joint = love.physics.newDistanceJoint(o.bodies[1].body, o.bodies[2].body, o.x, o.y, o.x2, o.y2, o.maxLength, o.collide)
		o.joint = love.physics.newRopeJoint(o.bodies[1], o.bodies[2], o.x * love.physics.getMeter(), o.y * love.physics.getMeter(), o.x2 * love.physics.getMeter(), o.y2 * love.physics.getMeter(), o.maxLength, o.collide)
	end
	
	
	return o
end

return M