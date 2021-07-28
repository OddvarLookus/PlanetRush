shader_type canvas_item;

uniform float noise_scale;


float rand2d (in vec2 pos) 
{
    return fract(sin(dot(pos, vec2(12.9898, 78.233))) * 43758.5453123);
}

vec2 rand2dvec2(in vec2 pos)
{
	return fract(sin( vec2(dot(pos, vec2(127.1, 311.7)), dot(pos, vec2(269.5, 183.3)))));
}

float cellularNoise(in vec2 coord)
{
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	float min_dist = 1.5;
	for(float x = -1.0; x <= 1.0; x++)
	{
		for(float y = -1.0; y <= 1.0; y++)
		{
			vec2 point = rand2dvec2(i + vec2(x,y)) + vec2(x,y);
			float dist = distance(f, point);
			
			
			min_dist = min(min_dist, dist);
			
		}
	}
	
	return min_dist;
}



void fragment()
{
	vec2 coord = UV * noise_scale;
	COLOR = vec4(vec3(cellularNoise(coord)), 1.0);
}
