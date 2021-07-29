shader_type canvas_item;

uniform float noise_size = 5.0;
uniform int octaves: hint_range(0,8,1);
uniform float octave_scaling = 2.0;
uniform float octave_contribution : hint_range(0.01, 1.0);


float rand2d (vec2 st) 
{
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}


float noise(vec2 st)
{
	vec2 i = floor(st);
	vec2 f = fract(st);
	
	//4 corners. takes the integer part to get the tile
	float a = rand2d(i);
	float b = rand2d(i + vec2(1.0, 0.0));
	float c = rand2d(i + vec2(0.0, 1.0));
	float d = rand2d(i + vec2(1.0, 1.0));
	
	vec2 t = smoothstep(0.0, 1.0, f);
	
	float topmix = mix(a,b, t.x);
	float botmix = mix(c,d, t.x);
	float totmix = mix(topmix, botmix, t.y);
	
	return totmix;
	
}

float octavesValueNoise(vec2 coord)
{
	float totVal = 0.0;
	float scale = 0.5;
	float col_normalize_val = 0.0;
	
	for(int i = 0; i < octaves; i++)
	{
		totVal += noise(coord) * scale;
		col_normalize_val += scale;
		coord *= octave_scaling;
		scale *= octave_contribution;
		
	}
	
	return totVal / col_normalize_val;
}

void fragment()
{
	vec2 coord = UV * noise_size;
	
	COLOR = vec4(vec3(octavesValueNoise(coord)),1.0);
	
	
}

