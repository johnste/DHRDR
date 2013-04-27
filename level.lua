M = {
	walls = {},
	bodies = {},
	levelData = nil,
	file = nil,
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
	
	o.levelData = dofile("level/".. o.file ..".lua")
		
	-- load all walls
	for k, v in ipairs(o.levelData.walls) do
		if v.image then
			if images[v.image] and type(v.image) == "string" then
				v.image = images[v.image]
			else
				v.image = nil
			end		
		end		
		table.insert(o.walls, static:new(v))
	end
	
	-- load all bodies
	for k, b in ipairs(o.levelData.bodies) do
		table.insert(o.bodies, body:new(b))
	end
	
	o.player = robot:new(o.levelData.player)
	
	o.camera:follow(o.player)
	
	return o
end

function M:draw()
	for k, v in ipairs(self.walls) do
		v:draw()
	end
	
	for k, v in ipairs(self.bodies) do
		v:draw()
	end
	
	self.player:draw()
end

-- Objects!
M.obj = {}
M.obj.milk = {groundOffset = 10, fixtures = {{ density = 1, width = 10, height = 20, image = "milk" }}}
M.obj.chair = {groundOffset = 50, fixtures = {
		{ width = 5, height = 90, image = "wood", x = -20, density = 2},
		{ width = 40, height = 10, image = "wood", density = 2, y = 5},
		{ width = 5, height = 45, image = "wood", x = 20, y = 22.5, density = 2},
}}
M.obj.table = {groundOffset = 75/2, fixtures = {		
		{ width = 100, height = 10, image = "wood", y = -75/2 },
		{ width = 10, height = 75, image = "wood"},
		{ width = 40, height = 5, image = "wood", y = 35},
}}

return M