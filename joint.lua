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

	if (o.jointType == "revolute") then
		o.joint = love.physics.newRevoluteJoint(o.bodies[1].body, o.bodies[2].body, o.x, o.y)
	end
	
	if (o.limits) then
		o.joint:setLimits(o.limits[1], o.limits[2])
		o.joint:enableLimit(true)
	end
	
	o.joint:enableMotor(o.motor)
	o.joint:setMaxMotorTorque(o.torque or 100)
	o.joint:setMotorSpeed(o.speed or math.tau)
	
	return o
end

return M