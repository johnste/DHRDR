love.filesystem.load("utils.lua")()

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
	prefabs = "prefabs.lua",
	"main.lua",	
	"utils.lua",
}

local levelFiles = love.filesystem.enumerate("level")
for k, file in ipairs(levelFiles) do
	if string.find(file, ".lua") then
		table.insert(files, "level/" .. file)
	end
end


modtime = {}
states = {}
currentState = nil

for n, f in pairs(files) do	
	if (n ~= tonumber(n)) then
		rawset(_G, n, love.filesystem.load(f)())
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
	
	-- Load all sounds
	sounds = {}	
	files = love.filesystem.enumerate("sound")
	for k, file in ipairs(files) do
		sounds[string.sub(file, 0, string.find(file, "%.") - 1)] = love.audio.newSource("sound/" .. file, "static")				
		sounds[string.sub(file, 0, string.find(file, "%.") - 1)]:setVolume(0.7)
	end
	sounds.engine:setLooping(true)
	sounds.engine:setVolume(0.2)
	
	sounds.music:setLooping(true)
	sounds.music:setVolume(0.2)
	
	local font = love.graphics.newFont(18)
	love.graphics.setFont(font)
	
	states.menu = menustate:new()	
	currentState = states.menu
	states.play = playstate:new()
	--currentState = states.play
	
	
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
	currentState:draw()	
	
end

function love.keypressed(key, unicode)
	if (key == "escape" or key == "f4") then
        love.event.quit()
    end
	
	---[[
	if key == "f3" then
		print(":> Force reload of all source files")
		io.flush()
		for n, f in pairs(files) do
			love.filesystem.load(f)()
		end
		love.load()
	end
	--]]
	
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

