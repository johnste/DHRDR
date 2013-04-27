files = {
	body = "body.lua", 
	item = "item.lua", 
	menustate = "menustate.lua", 
	playstate = "playstate.lua",
	robot = "robot.lua", 
	static = "static.lua",
	camera = "camera.lua",
	"main.lua",
}

modtime = {}
states = {}
currentState = nil

for n, f in pairs(files) do	
	if (n ~= tonumber(n)) then
		rawset(_G, n, dofile(f))
	end
end

function love.load()
	for n, f in pairs(files) do
		modtime[n] = love.filesystem.getLastModified(f)
	end	
	
	states.play = playstate:new()
	
	currentState = states.play
	--states.menu = menustate:new()
end

function love.update()
	for n, f in pairs(files) do
		
		local modified = love.filesystem.getLastModified(f)
		if (modified ~= modtime[n]) then
			print("\""..f.."\" was modified, reloading")
			io.flush()
			love.filesystem.load("main.lua")
			love.load()
		end
			
	end	
	
	currentState:update(dt)
end

function love.draw()
	currentState:draw()
end
