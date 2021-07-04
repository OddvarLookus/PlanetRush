shader_type canvas_item;

//render_mode blend_mix;

void fragment()
{
	vec4 pix_col = texture(TEXTURE, UV);
	
	if(pix_col.a > 0.4f)
	{
		pix_col.a = 1f;
	}
	else
	{
		pix_col.a = 0f;
	}
	
	COLOR = pix_col;
}