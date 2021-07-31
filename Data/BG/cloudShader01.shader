shader_type canvas_item;

//uniform vec4 baseCol : hint_color;

uniform float cutAlphaHeight : hint_range(0.0, 0.5);
uniform float minAlpha : hint_range(0.0, 1.0);
uniform float maxAlpha : hint_range(0.0, 1.0);
uniform float cutAlphaStrength : hint_range(0.0, 10.0);

uniform float AlphaCenterMultiplier : hint_range(0.0, 4.0);

uniform float scale;
uniform vec2 direction;
uniform float speed;

uniform vec2 octaveDirection;
uniform float octaveScale;
uniform float octaveSpeed;
uniform float octaveContribution : hint_range(0.0, 1.0);

uniform sampler2D noisetex;
uniform vec4 color : hint_color;

float cutAlpha(vec2 uvcoord, in float col)
{
	float c = col;
	float ydist = abs(uvcoord.y - 0.5);
	
	
	float t =  1.0 - (ydist - (0.5 - cutAlphaHeight)) / (cutAlphaHeight);
	c = c * t;
	c = pow(c, cutAlphaStrength);
	
	return c;
}


float cutAlphaCenter(in float rChannel, in float aChannel)
{
	float alpha = aChannel;
	
	alpha = smoothstep(0.0, 1.0, rChannel * aChannel * AlphaCenterMultiplier);
	
	return alpha;
}


void fragment()
{
	vec2 dir = normalize(direction);
	dir = dir * TIME * speed;
	vec2 octaveDir = normalize(octaveDirection);
	octaveDir = octaveDir * TIME * octaveSpeed;
	
	float c1 = texture(noisetex, (UV * scale) + dir).r;
	float c2 = texture(noisetex, (UV * octaveScale) + octaveDir).r;
	float compositeCol = mix(c1, c2, octaveContribution);
	
	float alpha = cutAlpha(UV, compositeCol);
	
	alpha = clamp(alpha, minAlpha, maxAlpha);
	vec4 finalCol = vec4(compositeCol, compositeCol, compositeCol, alpha);
	finalCol.a = cutAlphaCenter(finalCol.r, finalCol.a);
	
	finalCol.rgb = mix(finalCol.rgb , color.rgb, 0.5);
	COLOR = finalCol;
}
