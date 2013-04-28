math.tau = math.pi * 2

function prefab(body, def)
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
	
	newBody.fixtures = {}		
	for k, v in ipairs(body.fixtures) do
		
		newBody.fixtures[k] = {}
		for n, f in pairs(v) do
			newBody.fixtures[k][n] = f
		end		
	
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

robotVisionShader=love.graphics.newPixelEffect[[

    vec4 effect(vec4 color, sampler2D tex, vec2 st, vec2 pixel_coords) {
      float pi = 3.14159216;
	  float x = 450;
	  float y = 240;
	  vec2 orig = vec2(pixel_coords.x - x, pixel_coords.y - y);
      float dist = length(orig);
	  vec4 tex2 = Texel(tex, st);
      float r = tex2.r;
      float g = tex2.g;
      float b = tex2.b;		
	  float a = tex2.a * dist*dist/7000;  
	  if (dist*dist >= 7000) 
		a = tex2.a ;  
	  
      
      return vec4(r,g,b,a);
    }
]]