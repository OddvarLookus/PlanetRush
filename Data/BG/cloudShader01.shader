shader_type canvas_item;

//uniform vec4 baseCol : hint_color;

uniform float pixelateFactor = 100.0;

uniform bool quantize = true;
uniform float quantizeFactor = 18.06;
uniform float quantizePow = 0.94;

uniform float cutAlphaHeight : hint_range(0.0, 0.5) = 0.25;
uniform float minAlpha : hint_range(0.0, 1.0) = 0.0;
uniform float maxAlpha : hint_range(0.0, 1.0) = 0.7;
uniform float cutAlphaStrength : hint_range(0.0, 10.0) = 3.5;

uniform float AlphaCenterMultiplier : hint_range(0.0, 4.0) = 1.0;

uniform float scale = 1.0;
uniform vec2 direction = vec2(1.0, 0.0);
uniform float speed = 0.08;

uniform vec2 octaveDirection = vec2(1.0, 0.0);
uniform float octaveScale = 3.0;
uniform float octaveSpeed = 0.12;
uniform float octaveContribution : hint_range(0.0, 1.0) = 0.5;

uniform sampler2D noisetex;
uniform vec4 color : hint_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float shapeVal = 1.0;
uniform float latSpeed = 1.0;


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

float calculateCloudFalloff(vec2 _center, vec2 _coord)
{
	float dist = distance(_coord, _center);
	float falloff = dist * shapeVal;
	falloff = clamp(falloff, 0.0, 1.0);
	return pow((1.0 - falloff), 3.4);
}

void fragment()
{
	vec2 dir = normalize(direction);
	dir = dir * TIME * speed;
	vec2 octaveDir = normalize(octaveDirection);
	octaveDir = octaveDir * TIME * octaveSpeed;
	
	vec2 realCoord = round(UV * pixelateFactor) / pixelateFactor;
	
	float c1 = texture(noisetex, (realCoord * scale) + dir).r;
	float c2 = texture(noisetex, (realCoord * octaveScale) + octaveDir).r;
	float compositeCol = mix(c1, c2, octaveContribution);
	
	float alpha = cutAlpha(UV, compositeCol);
	
	alpha = clamp(alpha, minAlpha, maxAlpha);
	vec4 finalCol = vec4(compositeCol, compositeCol, compositeCol, alpha);
	finalCol.a = cutAlphaCenter(finalCol.r, finalCol.a);
	
	
	
	
	
	finalCol.rgb = mix(finalCol.rgb , color.rgb, 0.5);
	
	if(quantize)
	{
		finalCol = clamp(finalCol, vec4(0.0), vec4(1.0));
		finalCol = pow(finalCol, vec4(quantizePow));
		finalCol = round(finalCol * quantizeFactor) / quantizeFactor;
		finalCol = pow(finalCol, vec4(1.0/quantizePow));
	}
	
	vec2 offset = vec2(TIME * latSpeed, 0.0);
	vec2 cloudCenter = mod(vec2(0.5, 0.5) + offset, vec2(1.0, 1.0));
	vec2 cloudCenter2 = cloudCenter + vec2(1.0, 0.0);
	vec2 cloudCenter3 = cloudCenter + vec2(-1.0, 0.0);
	float totCloudShape = calculateCloudFalloff(cloudCenter, UV) + calculateCloudFalloff(cloudCenter2, UV) + calculateCloudFalloff(cloudCenter3, UV);
	finalCol.a = finalCol.a * totCloudShape;
	
	COLOR = finalCol;
}
