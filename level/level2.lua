
local level = {
	scale = 1.7,
	images = {
		background = "level2.001.png",
		middleground = "level2.002.png",
		foreground = "level2.003.png",
	},
	scorePos = {x = 502, y = 0},
	nextLevel = "level1",	
	imageOffset = { x = 0, y = 0 },
	walls =  {
		
		
		{x = -463, y = 0, width = 250, angle = math.tau/4, height = 30},
		{x = -450, y = -134, width = 250, angle = math.tau/8*3, height = 30},
		
		{x = -337, y = -2, width = 250, height = 30},
		{x = -301, y = -5, width = 50, height = 30},
		{x = -251, y = -12, width = 50, height = 30},
		{x = -230, y = -22, width = 70, height = 30},
		
		{x = -130, y = 24, width = 170, angle = math.tau/8*4.75, height = 30},
		
		
		{x = -38, y = 78, width = 150, height = 30},
		
		{x = 55, y = 103, width = 80, height = 30, angle = math.tau/8*5},
		
		{x = 85, y = -94, width = 35, height = 26},
		
		{x = 105, y = 103, width = 80, height = 30, angle = math.tau/8*3},
		
		{x = 204, y = 78, width = 165, height = 30},
		
		{x = 283, y = 66, width = 13, height = 30},
		
		{x = 387, y = 206, width = 60, height = 300},
		
		target = {x = 352, y = 30, height = 60, width = 150, sensor = true},
		
		
	},
	bodies = {
		prefab(level.obj.milk, {x = 283, y = 35}),
		prefab(level.obj.chair, {x = 387, y = 66}),
	},
	player = {
		x = -370, y = -50,
		--x = 200, y = 20,
	}
}

return level