#define MAX_LIGHTS 8
 
struct Light
{
	float3	Position;
	float3	Direction;
	float4	Color;
	int		Type;
	float	Falloff;
    float	Range;
    float	Intensity;
};

//This function calculates the diffuse and specular effect of a single light
//on a pixel given the world position, normal, and material properties
float4 CalculatePhongLighting(float3 cameraPosition, float3 position, float3 normal, Material mat, Light light)
{
	float4 lColor;
	float3 lView;
	float3 lDirection;
	float3 lReflection;
	float lBaseIntensity;
	float lIntensity;
	float lDistance;
	
	lView = normalize(-position);
	lDirection = light.Position - position;
	lDistance = length(lDirection);
	lDirection = normalize(lDirection);
	lBaseIntensity = light.Intensity * pow(saturate((light.Range - lDistance) / light.Range), light.Falloff);
		
	lColor = light.Color * mat.Ambient;
	
	if(mat.Illumination > 0)
	{
		lIntensity = saturate(dot(lDirection, normal));
		lColor +=  lIntensity * light.Color * mat.Diffuse;
	}
	
	if(mat.Illumination > 1)
	{
		lReflection = normalize(reflect(normal, lDirection));
		lIntensity = pow(saturate(dot(lReflection, lView)), mat.Shininess);
		lColor += lIntensity * light.Color * mat.Specular;
	}
	return float4(lBaseIntensity * lColor.xyz, 1);
}


//This function calculates the diffuse and specular effect of a single light
//on a pixel given the world position, normal, and material properties
float4 CalculateLighting(float3 cameraPosition, float3 position, float3 normal, Material mat, Light lights[MAX_LIGHTS])
{
	float4 lColor;	
	
	lColor = float4(0,0,0,0);
	for(int i = 0; i < MAX_LIGHTS; ++i)
	{
		if(lights[i].Intensity > 0)
			lColor += CalculatePhongLighting(cameraPosition, position, normal, mat, lights[i]);
	}
	return float4(lColor.xyz, 1);
}