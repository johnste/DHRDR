
local level = {
	scale = 1.7,
	images = {
		background = "level2.001.png",
		middleground = "level2.002.png",
		foreground = "level2.003.png",
	},	
	gravity = {0, 300},
	scorePos = {x = 100, y = 200},
	imageOffset = { x = 0, y = 0 },
	walls =  {
		{x = -402, y = 194, width = 70, angle = math.tau/4},
		{x = -243, y = 144, width = 300},
		{x = -395, y = 157, width = 40, angle = math.tau*3/8},
		{x = -268, y = 140, width = 40, angle = math.tau*3/8},
		{x = -243, y = 129, width = 45},
		{x = -208, y = 137, width = 40, angle = math.tau*4.5/8},
		{x = -75, y = 147, width = 40, angle = math.tau*4.2/8},
		{x = -35, y = 146, width = 60, angle = math.tau*3.7/8},
		{x = 2, y = 128, width = 20},
		{x = 14, y = 118, width = 20},
		{x = 26, y = 108, width = 20},
		{x = 41, y = 104, width = 14},
		{x = 41, y = -15, width = 13, height = 50},
		{x = 27, y = -140, width = 15, height = 200},
		{x = 141, y = 110, width = 220},
		{x = 238, y = 106, width = 40, angle = -0.1},
		
		{x = 264, y = 97, width = 20},
		{x = 274, y = 88, width = 20},
		{x = 286, y = 82, width = 20},
		{x = 294, y = 73, width = 14},
		{x = 397, y = 55, height = 15},
		{x = 507, y = -65, height = 300, width = 15},
		
		target = {x = 275, y = -50, height = 300, width = 500, sensor = true},		
		world = {x = 0, y = 0, width = 1200, height = 1500, sensor = true}
		
	},
	bodies = {

		prefab(prefabs.milk, {x = 136, y = 35}),
		prefab(prefabs.milk, {x = 156, y = 35}),
		prefab(prefabs.milk, {x = 176, y = 35}),
		prefab(prefabs.chair, {x = 120, y = 90}),
		mirror(prefabs.chair, {x = 192, y = 90}),
		prefab(prefabs.table, {x = 156, y = 90}),
		
		prefab(prefabs.egg, {x = 130, y = 40}),
		prefab(prefabs.egg, {x = 35, y = 40}),
		
		--prefab(prefabs.table, {x = 390, y = 40}),
		mirror(prefabs.chair, {x = 348, y = 40}),
		mirror(prefabs.chair, {x = 390, y = 40}),
		mirror(prefabs.chair, {x = 432, y = 40}),
		
		prefab(prefabs.human, {x = 416, y = -20}),
		
		
		
	},
	player = {
		x = -370, y = 100,
		--x = 0, y = 100,
		--ddddx = 340, y = -0
	}
}

return level