shader_type canvas_item;

uniform float noise_scale = 5.0;

float rand2d (in vec2 pos) 
{
    return fract(sin(dot(pos, vec2(12.9898, 78.233))) * 43758.5453123);
}

vec2 rot(in vec2 vectr, in float angl)
{
	float x = (cos(angl) * vectr.x) - (sin(angl) * vectr.y);
	float y = (sin(angl) * vectr.x) + (cos(angl) * vectr.y);
	return vec2(x,y);
}

float perlinNoise(in vec2 pos)
{
	vec2 i = floor(pos);
	vec2 f = fract(pos);
	
	float tl_rot = rand2d(i) * 6.28318;
	float tr_rot = rand2d(i + vec2(1.0, 0.0)) * 6.28318;
	float bl_rot = rand2d(i + vec2(0.0, 1.0)) * 6.28318;
	float br_rot = rand2d(i + vec2(1.0, 1.0)) * 6.28318;
	
	vec2 tl_vec = rot(vec2(1.0,0.0), tl_rot);
	vec2 tr_vec = rot(vec2(1.0,0.0), tr_rot);
	vec2 bl_vec = rot(vec2(1.0,0.0), bl_rot);
	vec2 br_vec = rot(vec2(1.0,0.0), br_rot);
	
	float tl_dot = dot(tl_vec, f);
	float tr_dot = dot(tr_vec, f - vec2(1.0,0.0));
	float bl_dot = dot(bl_vec, f - vec2(0.0,1.0));
	float br_dot = dot(br_vec, f - vec2(1.0, 1.0));
	
	//vec2 cubic_t = pow(f, vec2(2.0, 2.0)) * (3.0 - 2.0 * f);
	vec2 cubic_t = 3.0 * pow(f, vec2(2.0, 2.0)) - 2.0 * pow(f, vec2(3.0, 3.0));
	float top_mix = mix(tl_dot, tr_dot, cubic_t.x);
	float bot_mix = mix(bl_dot, br_dot, cubic_t.x);
	float tot_mix = mix(top_mix, bot_mix, cubic_t.y);
	return(tot_mix + 0.5);
	
}

void fragment()
{
	vec2 scaled_uv = UV * noise_scale;
	
	float col = perlinNoise(scaled_uv);
	COLOR = vec4(vec3(col), 1.0);
	
}
