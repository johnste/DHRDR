
local level = {
	scale = 1.7,
	images = {
		background = "level1.001.png",
		middleground = "level1.002.png",
		foreground = "level1.003.png",
	},
	gravity = {0, 300},
	scorePos = {x = 502, y = 0},
	nextLevel = "level2",	
	imageOffset = { x = 0, y = 0 },
	walls =  {
		
		{x = -263, y = -65, width = 135, height = 30, angle = 0.05},
		
		{x = -101, y = -204, width = 18, height = 20, angle = 0.05},
		
		{x = 32, y = -16, width = 120, height = 30, angle = 0.05},
		
		{x = 387, y = 256, width = 60, height = 300},
		
		target = {x = 352, y = 30, height = 60, width = 150, sensor = true},
		world = {x = 0, y = 0, width = 1200, height = 1500, sensor = true}
	},
	bodies = {
		prefab(prefabs.milk, {x = 283, y = 35}),		
		prefab(prefabs.milk, {x = 283, y = 15}),
		prefab(prefabs.milk, {x = 283, y = -15}),
		prefab(prefabs.chair, {x = 387, y = 66}),
		
		
	},
	player = {
		x = -270, y = -110,
		--x =35, 
	}
}

return level