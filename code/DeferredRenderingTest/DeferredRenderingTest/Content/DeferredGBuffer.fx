float4x4 World;
float4x4 View;
float4x4 Projection;

float specularIntensity = 0.8f;
float specularPower = 0.5f;

texture Texture;
texture NormalMap;
texture SpecularMap;

sampler DiffuseSampler = sampler_state
{
    Texture = (Texture);
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};

sampler NormalSampler = sampler_state
{
	Texture = (NormalMap);
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
	AddressU = Wrap;
	AddressV = Wrap;
};

sampler SpecularSampler = sampler_state
{
	Texture = (SpecularMap);
	MAGFILTER = LINEAR;
	MINFILTER = LINEAR;
	MIPFILTER = LINEAR;
	AddressU = Wrap;
	AddressV = Wrap;
};

struct VertexShaderInput
{
    float4 Position : POSITION0;
    float3 Normal   : NORMAL0;
    float2 TexCoord : TEXCOORD0;
	float3 Binormal : BINORMAL0;
	float3 Tangent	: TANGENT0;
};

struct VertexShaderOutput
{
    float4 Position				: POSITION0;
    float2 TexCoord				: TEXCOORD0;
    float2 Depth				: TEXCOORD1;
	float3x3 TangentToWorld		: TEXCOORD2;
};

struct PixelShaderOutput
{
    half4 Color    : COLOR0;
    half4 Normal   : COLOR1;
    half4 Depth    : COLOR2;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;

    float4x4 wvp = mul( mul (View, World), Projection);
    
    output.Position = mul(input.Position, wvp);
    output.TexCoord = input.TexCoord;
    output.Depth.x = output.Position.z;
    output.Depth.y = output.Position.w;

	//Calculate tangent space to world space matrix using the world space tangent,
	//Binormal, and normal as basis vectors
	output.TangentToWorld[0] = mul(input.Tangent, World);
	output.TangentToWorld[1] = mul(input.Binormal, World);
	output.TangentToWorld[2] = mul(input.Normal, World);
    return output;
}

PixelShaderOutput PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
	PixelShaderOutput output;
    output.Color = tex2D(DiffuseSampler, input.TexCoord);
    
    float4 specularAttributes = tex2D(SpecularSampler, input.TexCoord);
    
    //specular intensity;
    output.Color.a = specularAttributes.r;
    
    //read the normal from the normal map
    float3 normalFromMap = tex2D(NormalSampler, input.TexCoord);
    
    //transform to [-1, 1]
    normalFromMap = 2.0f * normalFromMap - 1.0f;
    
    //transform to world space
	normalFromMap = mul(normalFromMap, input.TangentToWorld);
    
    //normalize normal coords
    normalFromMap = normalize(normalFromMap);
    
    //convert to [0, 1]
    output.Normal.rgb = 0.5f * (normalFromMap + 1.0f);
    
    //specular power
    output.Normal.a = specularAttributes.a;
    output.Depth = input.Depth.x / input.Depth.y;

    return output;
}

technique Technique1
{
    pass Pass1
    {
        // TODO: set renderstates here.

        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}
