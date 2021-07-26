shader_type canvas_item;

uniform float resolution;

float random (vec2 st)
{
    return fract(sin(dot(st.xy,vec2(12.9898,78.233)))*43758.5453123);
}

void fragment()
{
	vec2 st = UV * resolution;
	vec2 ipos = floor(st);
	
	float rnd = random(ipos);
	
	COLOR = vec4(rnd, rnd, rnd, 1.0);
}