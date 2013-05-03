math.tau = math.pi * 2

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

robotVisionShader=love.graphics.newPixelEffect[[

    vec4 effect(vec4 color, sampler2D tex, vec2 st, vec2 pixel_coords) {
      float pi = 3.14159216;
	  float x = 450;
	  float y = 240;
	  vec2 orig = vec2(pixel_coords.x - x, pixel_coords.y - y);
      float dist = length(orig);
	  vec2 t = vec2(st.x, st.y);
	  
	  vec4 tex2 = Texel(tex, t);
      float a = tex2.a;
      float g = tex2.g * dist*dist/80000;  
      float b = tex2.b * dist*dist/80000;  
	  float r = tex2.r * dist*dist/80000;  
	  
      return vec4(r,g,b,a);
    }
]]


clutterBarShader=love.graphics.newPixelEffect[[
	extern number ratio;
	
    vec4 effect(vec4 color, sampler2D tex, vec2 st, vec2 pixel_coords) {
      float pi = 3.14159216;
	  float x = 450;
	  float y = 240;
	 

	  vec4 tex2 = Texel(tex, st);	 
      float a = tex2.a;
	  
	  if (st.x > ratio){
		a = 0;  
	  }
	 
      float g = tex2.g;
      float b = tex2.b;		
	  float r = tex2.r;  
 
	  
      
      return vec4(r,g,b,a);
    }
]]

