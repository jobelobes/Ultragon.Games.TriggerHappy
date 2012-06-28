float4x4 World;
float4x4 View;
float4x4 Projection;

float2 halfPixel;

float3 lightPosition;
float3 lightColor;
float3 lightRadius;
float lightIntensity = 1.0f;

float3 cameraPosition;
float4x4 InverseViewProjection;

Texture diffuseMap;
Texture normalMap;
Texture depthMap;

sampler DiffuseSampler = sampler_state
{
    Texture = (diffuseMap);
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
    AddressU = CLAMP;
    AddressV = CLAMP;
};
sampler NormalSampler = sampler_state
{
    Texture = (normalMap);
    MAGFILTER = POINT;
    MINFILTER = POINT;
    MIPFILTER = POINT;
    AddressU = CLAMP;
    AddressV = CLAMP;
};
sampler DepthSampler = sampler_state
{
    Texture = (depthMap);
    MAGFILTER = POINT;
    MINFILTER = POINT;
    MIPFILTER = POINT;
    AddressU = CLAMP;
    AddressV = CLAMP;
};
struct VertexShaderInput
{
    float3 Position : POSITION0;
};

struct VertexShaderOutput
{
    float4 Position : POSITION0;
    float4 ScreenPosition : TEXCOORD0;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;

    //processing geometry coordinates
    float4 worldPosition = mul(float4(input.Position,1), World);
    float4 viewPosition = mul(worldPosition, View);
    output.Position = mul(viewPosition, Projection);
    output.ScreenPosition = output.Position;
	
    return output;
}

float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
	//obtaining screen position
	input.ScreenPosition.xy /= input.ScreenPosition.w;
	
	//obtain texture coordinates corresponding to the current pixel
	//the screen coordinates are in [-1, 1] * [1, -1]
	//texture coordinates need to be in [0, 1] * [0, 1]
	float2 texCoord = 0.5f * (float2(input.ScreenPosition.x, -input.ScreenPosition.y) + 1);
	
	//align texels to pixels
	texCoord -= halfPixel;
	
	//get normal data from the normal map
	float4 normalData = tex2D(NormalSampler, texCoord);
	
	//transform normal back to [-1, 1]
	float3 normal = 2.0f * normalData.xyz - 1.0f;
	
	//get specular power
	float specularPower = normalData.a * 255;
	
	//get specular intensity from the colorMap
	float specularIntensity = tex2D(DiffuseSampler, texCoord).a;
	
	//read depth
	float depthVal = tex2D(DepthSampler, texCoord).r;
	
	//compute the screen space position
	float4 position;
	position.xy = input.ScreenPosition.xy;
	position.z = depthVal;
	position.w = 1.0f;
	
	//tranform to world space
	position = mul(position, InverseViewProjection);
	position /= position.w;
	
	//surface to light vector
	float3 lightVector = lightPosition - position;
	
	//compute attenuation based on distance - linear attenuation
	float attenuation = saturate(1.0f - length(lightVector) / lightRadius);
	
	//normalize light vector
	lightVector = normalize(lightVector);
	
	//compute diffuse light
	float NdL = max(0, dot(normal, lightVector));
	float3 diffuseLight = NdL * lightColor.rgb;
	
	//reflection vector
	float3 reflectionVector = normalize(reflect(-lightVector, normal));
	
	//camera to surface vector
	float3 directionToCamera = normalize(cameraPosition - position);
	
	//compute specular light
	float specularLight = specularIntensity * pow(saturate(dot(reflectionVector, directionToCamera)), specularPower);
	
	return attenuation * lightIntensity * float4(diffuseLight.rgb, specularLight);

}

technique Technique1
{
    pass Pass1
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}
