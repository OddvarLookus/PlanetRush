shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D palette;
uniform vec2 worldPos;
uniform float max_height;
uniform float window_height;

void fragment()
{
	
	float cam_height = -worldPos.y + 256.0/2.0;
	//vec4 col = vec4(cam_height / 1000.0, 0, 0, 1);
	
	float normalized_height = cam_height / max_height;
	float uv_window = (1.0 - UV.y) * (1.0 / 16.0) * window_height;
	vec4 real_col = texture(palette, vec2(((1.0/16.0) * normalized_height) + (1.0/32.0) + uv_window,0.5));
	
	COLOR = real_col;
}
