float4x4 World;
float4x4 View;
float4x4 Projection;

Texture DiffuseMap;
Texture LightMap;

float2 halfPixel;

sampler DiffuseSampler = sampler_state
{
	Texture = (DiffuseMap);
	AddressU = CLAMP;
	AddressV = CLAMP;
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
};

sampler LightSampler = sampler_state
{
	Texture = (LightMap);
	AddressU = CLAMP;
	AddressV = CLAMP;
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
};

struct VertexShaderInput
{
    float3 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};

struct VertexShaderOutput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;
	
	output.Position = float4(input.Position, 1);
	output.TexCoord = input.TexCoord - halfPixel;
    return output;
}

float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
	float3 diffuseColor = tex2D(DiffuseSampler, input.TexCoord).rgb;
	float4 light = tex2D(LightSampler, input.TexCoord);
	float3 diffuseLight = light.rgb;
	float specularLight = light.a;
	
    return float4((diffuseColor * diffuseLight + specularLight), 1);
}

technique Technique1
{
    pass Pass1
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}
