shader_type canvas_item;

//uniform vec4 baseCol : hint_color;

uniform float cutAlphaHeight : hint_range(0.0, 0.5);
uniform float alphaGradientStrenght : hint_range(0.0, 4.0);
uniform float min_alpha : hint_range(0.0, 1.0);
uniform float max_alpha : hint_range(0.0, 1.0);
uniform float top_zoom : hint_range(0.0, 10.0);
uniform float bottom_zoom : hint_range(0.0, 10.0);
uniform float skew_pow : hint_range(0.001, 4.0);

uniform vec2 direction;
uniform float speed;

uniform vec2 octaveDirection;
uniform float octaveScale;
uniform float octaveSpeed;
uniform float octaveContribution : hint_range(0.0, 1.0);

uniform sampler2D noisetex;

//return alpha
float cutAlpha(float uvcoord_y, in float col)
{
	float c = col;
	float ydist = abs(uvcoord_y - 0.5);
	
	
	float t =  1.0 - (ydist - (0.5 - cutAlphaHeight)) / (cutAlphaHeight); // (0.5 - cutAlphaHeight);
	//returnCol = vec4(t,t,t, 1.0);
	c = pow(t, alphaGradientStrenght);
	
	return c;
}

void fragment()
{
	vec2 dir = normalize(direction);
	dir = dir * TIME * speed;
	vec2 octaveDir = normalize(octaveDirection);
	octaveDir = octaveDir * TIME * octaveSpeed;
	
	float yPow = pow(UV.y, skew_pow);
	float yRemap = mix(top_zoom, bottom_zoom, yPow);
	
	vec2 skewCoord = vec2((yRemap) * (UV.x - 0.5) + 0.5, UV.y);
	//skewCoord *= 2.0;
	
	float c1 = texture(noisetex, skewCoord + dir).r;
	float c2 = texture(noisetex, (skewCoord * octaveScale) + octaveDir).r;
	float compositeCol = mix(c1, c2, octaveContribution);
	
	
	
	float alpha = cutAlpha(pow(skewCoord.y,1.0/skew_pow * 2.0) , compositeCol);
	alpha = mix(min_alpha, max_alpha, alpha);
	COLOR = vec4(compositeCol, compositeCol, compositeCol, alpha);
	
}