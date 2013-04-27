
local level = {
	walls =  {
		{width = 400, height = 10, y = 5, image = "wall" },
		{width = 200, height = 10, x = -290, y = 24, angle = math.tau*7.5/16, image = "wall"},
		{width = 200, height = 10, x = -200, y = -250, angle = math.tau/4, image = "wall"},
		{width = 30, height = 10, x = 195, y = -10, angle = math.tau/4, image = "wall"},
		{width = 30, height = 10, x = 205, y = -20, angle = math.tau, image = "wall"},
		{width = 30, height = 10, x = 215, y = -30, angle = math.tau/4, image = "wall"},
		{width = 30, height = 10, x = 225, y = -40, angle = math.tau, image = "wall"},
	},
	bodies = {
		dobody(level.obj.milk, {x = 25, y = -75}),
		dobody(level.obj.chair, {x = -50, y = 0}),
		mirror(dobody(level.obj.chair, {x = 50, y = 0})),		
		dobody(level.obj.table, {y = 0})
	},
	player = {
		x = -300, y = -20
	}
}

return level