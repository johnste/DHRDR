-- Objects!
M = {}
M.egg = {name = "egg", score = 25, groundOffset = 10, bodies = { body = {fixtures = {
				{ shape = "circle", density = 1, radius = 5, image = "egg" },
}}}}
M.milk = {name = "milk", score = 45, groundOffset = 10, bodies = { body = { fixtures = {
				{ density = 1, width = 10, height = 20, image = "milk" },
}}}}

M.chair = {name = "chair", score = 27, groundOffset = 20, bodies = { body = { fixtures = {
		{ width = 5, height = 45, image = "thinuprect", x = -13, density = 2},
		{ width = 5, height = 20, image = "thinuprect", x = 12, y = 12.5, density = 2},
		{ width = 30, height = 7, image = "siderect", density = 2, y = 5},		
}}}}
M.table = {name = "table", score = 45, groundOffset = 20, bodies = { body = { fixtures = {		
		{ width = 70, height = 10, image = "siderect", y = -35/2 },
		{ width = 10, height = 35, image = "uprect"},
		{ width = 40, height = 5, image = "siderect", y = 35/2},
}}}}

local humanscale = 1.6
M.human = {name = "human", score = 15, groundOffset = 120, bodies = {		
		head = { fixtures = {{ width = 25/humanscale, height = 33/humanscale, image = "head", y = (-33-15)/humanscale }}},
		body = {fixtures = {{ width = 30/humanscale, height = 66/humanscale, image = "torso"}}},
		overarm = {fixtures = {{ width = 15/humanscale, height = 30/humanscale, image = "overarm", y = - 15/humanscale}}},
		lowerarm = {fixtures = {{ width = 15/humanscale, height = 30/humanscale, image = "lowerarm", y = 15/humanscale}}},
		hand = {fixtures = {{ width = 15/humanscale, height = 15/humanscale, image = "hand", y = 36/humanscale}}},
		overleg = {fixtures = {{ width = 15/humanscale, height = 30/humanscale, image = "overleg", y = 40/humanscale, x = 3/humanscale}}},
		lowerleg = {fixtures = {{ width = 15/humanscale, height = 30/humanscale, image = "lowerleg", y = 67/humanscale, x = 1/humanscale}}},
		foot = {fixtures = {{ width = 25/humanscale, height = 12/humanscale, image = "foot", y = 83/humanscale, x = -5/humanscale}}},		
}, joints = {
		neck = { y = -33/humanscale, bodies = {"head", "body"}, limits = { -math.pi/3, math.pi/3} },
		shoulder = { y = -22/humanscale, bodies = {"overarm", "body"} },
		elbow = { y = 0, bodies = {"overarm", "lowerarm"} , limits = { -math.pi/8, math.pi}},
		wrist = { y = 30/humanscale, bodies = {"hand", "lowerarm"}, limits = { -math.pi/3, math.pi/3} },
		hip = { y = 25/humanscale, x = 3/humanscale, bodies = {"body", "overleg"} , limits = { -math.pi/3, math.pi/3}},
		knee = { y = 55/humanscale, x = 2/humanscale, bodies = {"lowerleg", "overleg"}, limits = { -math.pi*0, math.pi/1.3} },
		ankle = { y = 80/humanscale, x = 1/humanscale, bodies = {"lowerleg", "foot"}, limits = { -math.pi/4, math.pi/4} },
} }


prefabId = 1000
function prefab(body, def)
	body = deepcopy(body)
	
	if def then 
		for k, v in pairs(def) do
			body[k] = v
		end	
	end
	prefabId = prefabId + 1
	body.group = {-prefabId}
	
	return body
end

function mirror(body, def)
	
	body = prefab(body, def)
			
	for l, b in pairs(body.bodies) do	
		for k, v in pairs(b.fixtures) do			
			if b.fixtures[k].x then
				b.fixtures[k].x = -b.fixtures[k].x
			end
		end
	end
	
	return body
end


return M