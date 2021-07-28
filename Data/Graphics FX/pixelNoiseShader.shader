shader_type canvas_item;

uniform float noise_size = 5.0;


float random2d (vec2 st) 
{
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 st)
{
	vec2 i = floor(st);
	vec2 f = fract(st);
	
	//4 corners. takes the integer part to get the tile
	float a = random2d(i);
	float b = random2d(i + vec2(1.0, 0.0));
	float c = random2d(i + vec2(0.0, 1.0));
	float d = random2d(i + vec2(1.0, 1.0));
	
	vec2 t = smoothstep(0.0, 1.0, f);
	
	float topmix = mix(a,b, t.x);
	float botmix = mix(c,d, t.x);
	float totmix = mix(topmix, botmix, t.y);
	
	return totmix;
	
}

void fragment()
{
	vec2 realCoord = UV * noise_size;
	
	float col = noise(realCoord);
	COLOR = vec4(vec3(col), 1.0);
	//COLOR = vec4(floor(realCoord).x / resolution, floor(realCoord.y) / resolution, 0.0f, 1.0f);
	
}