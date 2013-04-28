
local level = {
	scale = 1.7,
	images = {
		background = "level1.001.png",
		middleground = "level1.002.png",
		foreground = "level1.003.png",
	},	
	scorePos = {x = 100, y = 200},
	imageOffset = { x = 0, y = 0 },
	walls =  {
		{x = -413, y = 194, width = 70, angle = math.tau/4},
		{x = -243, y = 134, width = 300},
		{x = -400, y = 147, width = 40, angle = math.tau*3/8},
		{x = -275, y = 132, width = 40, angle = math.tau*3/8},
		{x = -243, y = 119, width = 45},
		{x = -205, y = 127, width = 40, angle = math.tau*4.5/8},
		{x = -75, y = 137, width = 40, angle = math.tau*4.2/8},
		{x = -35, y = 133, width = 60, angle = math.tau*3.7/8},
		{x = 2, y = 118, width = 20},
		{x = 14, y = 108, width = 20},
		{x = 26, y = 98, width = 20},
		{x = 41, y = 94, width = 14},
		{x = 41, y = -15, width = 13, height = 50},
		{x = 27, y = -140, width = 15, height = 200},
		{x = 141, y = 100, width = 220},
		{x = 238, y = 96, width = 40, angle = -0.1},
		
		{x = 264, y = 87, width = 20},
		{x = 274, y = 78, width = 20},
		{x = 286, y = 72, width = 20},
		{x = 294, y = 63, width = 14},
		{x = 397, y = 53, height = 15},
		{x = 507, y = -65, height = 300, width = 15},
		
		target = {x = 250, y = -50, height = 300, width = 450, sensor = true},
		
		
	},
	bodies = {
		prefab(level.obj.milk, {x = 136, y = 35}),
		prefab(level.obj.milk, {x = 156, y = 35}),
		prefab(level.obj.milk, {x = 176, y = 35}),
		prefab(level.obj.chair, {x = 120, y = 90}),
		mirror(prefab(level.obj.chair, {x = 192, y = 90})),
		prefab(level.obj.table, {x = 156, y = 90}),
		prefab(level.obj.egg, {x = 130, y = 40}),
		prefab(level.obj.egg, {x = 35, y = 40}),
		
		prefab(level.obj.table, {x = 390, y = 40}),
		prefab(level.obj.chair, {x = 350, y = 40}),
		mirror(prefab(level.obj.chair, {x = 432, y = 40})),
	},
	player = {
		x = -370, y = 100,
		--x = 340, y = -0
	}
}

return level