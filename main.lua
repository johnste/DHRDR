dofile("utils.lua")

files = {
	body = "body.lua", 
	item = "item.lua", 
	menustate = "menustate.lua", 
	playstate = "playstate.lua",
	robot = "robot.lua", 
	static = "static.lua",
	camera = "camera.lua",	
	level = "level.lua",
	joint = "joint.lua",
	"main.lua",	
	"utils.lua",
}

local levelFiles = love.filesystem.enumerate("level")
for k, file in ipairs(levelFiles) do
	table.insert(files, "level/" .. file)
end


modtime = {}
states = {}
currentState = nil

for n, f in pairs(files) do	
	if (n ~= tonumber(n)) then
		rawset(_G, n, dofile(f))
	end
end

function love.load()
	if arg[#arg] == "-debug" then require("mobdebug").start() end
	
	for n, f in pairs(files) do
		modtime[n] = love.filesystem.getLastModified(f)
	end	
		
	-- Load all images
	images = {}	
	local files = love.filesystem.enumerate("image")
	for k, file in ipairs(files) do
		images[string.sub(file, 0, string.find(file, "%.") - 1)] = love.graphics.newImage("image/" .. file)				
	end
	
	states.play = playstate:new()
	
	currentState = states.play
	--states.menu = menustate:new()
end

function love.update(dt)
	for n, f in pairs(files) do
		
		local modified = love.filesystem.getLastModified(f)
		if (modified ~= modtime[n]) then
			print(":> File \""..f.."\" was modified, reloading")
			io.flush()
			love.filesystem.load(f)()
			love.filesystem.load("main.lua")()
			love.load()
		end
			
	end	
	
	currentState:update(dt)
end

function love.draw()
	love.graphics.setPixelEffect(robotVisionShader)
	currentState:draw()
	love.graphics.setPixelEffect(nil)
end

function love.keypressed(key, unicode)
	if (key == "escape" or key == "f4") then
        love.event.quit()
    end
	
	if key == "r" then
		print(":> Force reload of all source files")
		io.flush()
		for n, f in pairs(files) do
			love.filesystem.load(f)()
		end
		love.load()
	end
	
	currentState:keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
	currentState:keyreleased(key, unicode)
end

function love.mousepressed(x, y, button)
	currentState:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	currentState:mousereleased(x, y, button)
end

