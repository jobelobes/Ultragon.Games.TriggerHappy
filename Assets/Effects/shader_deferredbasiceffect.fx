#include "shader.inc"

struct VertexOutput
{
	float4 Position			: SV_POSITION;
	float3 WorldPosition	: POSITION0;
	float4 Color 			: COLOR0;
	float3 Normal			: NORMAL0;
	float2 Depth			: TEXCOORD0;
	float2 TexCoord			: TEXCOORD1;
};

struct PixelOutput
{
	float4 Diffuse			: SV_TARGET0;
	float4 Normal			: SV_TARGET1;
	float4 Depth			: SV_TARGET2;
};

VertexOutput VertexShaderFunction(VertexPositionNormalTexture input)
{
	float4x4 wvp = mul( mul( _World, _Camera.View ) , _Camera.Projection );
	
	VertexOutput output;
	output.Position = mul(float4(input.Position.xyz, 1), wvp);
	output.WorldPosition = mul(float4(input.Position.xyz, 1), _World).xyz;
	output.Color = _Material.Color;
	output.Normal = input.Normal;
	output.Depth = float2(output.Position.z, output.Position.w);
	output.TexCoord = input.TexCoord;
	
	return output; 
	
} 

PixelOutput PixelShaderFunction(VertexOutput input) : SV_TARGET
{  
    PixelOutput output;
	
	//Color
	output.Diffuse = _MainTex.Sample(TextureSampler, input.TexCoord);
	output.Diffuse.a = 1;
	
	//Normals
	//normals are in the space of -1, 1 so we need to convert it to 0, 1
	output.Normal.xyz = (1 - input.Normal / 2.0f) + 0.5f;
	output.Normal.a = 1;
	
	//Depth
	//mulitply depth
	output.Depth = input.Depth.x / input.Depth.y;
	
	return output;
}

 
technique10 Technique1
{   
    pass P1
    {
        SetVertexShader( CompileShader( vs_4_0, VertexShaderFunction() ) );
        SetGeometryShader( NULL );
        SetPixelShader( CompileShader( ps_4_0, PixelShaderFunction() ) );
    }
}