math.tau = math.pi * 2

function dobody(body, def)
	local newBody = {}
	--[[ 
	for k, v in ipairs(def) do
		for n, w in pairs(v) do
			body.fixtures[k][n] = w
		end
	end	
	--]]
	
	for k, v in pairs(body) do
		newBody[k] = v
	end
	
	for k, v in pairs(def) do
		newBody[k] = v
	end
	
	return newBody
end

function mirror(body)
	local newBody = {}	
	
	for k, v in pairs(body) do
		newBody[k] = v
	end
	
	newBody.fixtures = {}		
	for k, v in ipairs(body.fixtures) do
		
		newBody.fixtures[k] = {}
		for n, f in pairs(v) do
			newBody.fixtures[k][n] = f
		end		
		
		if newBody.fixtures[k].x then
			newBody.fixtures[k].x = -newBody.fixtures[k].x
		end
	end
	
	return newBody
end