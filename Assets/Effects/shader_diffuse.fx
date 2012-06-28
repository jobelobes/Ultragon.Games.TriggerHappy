#include "shader.inc"

struct VertexShaderOutput
{
	float4 Position			: SV_POSITION;
	float3 WorldPosition	: POSITION0;
	float4 Color 			: COLOR0;
	float3 Normal			: NORMAL0;
	float2 TexCoord			: TEXCOORD0;
};

VertexShaderOutput VertexShaderFunction(VertexPositionNormalTexture input)
{
	float4x4 wvp = mul( mul( _World, _Camera.View ) , _Camera.Projection );
	
	VertexShaderOutput output;
	output.Position = mul(float4(input.Position.xyz, 1), wvp);
	output.WorldPosition = mul(float4(input.Position.xyz, 1), _World).xyz;
	output.Color = _Material.Color;
	output.Normal = mul(float4(input.Normal.xyz, 1), _World).xyz;
	output.TexCoord = input.TexCoord;
	return output; 
} 

float4 PixelShaderFunction(VertexShaderOutput input) : SV_TARGET
{       
    return input.Color * CalculateLighting(_Camera.Position.xyz, input.WorldPosition.xyz, input.Normal.xyz, _Material, _Lights);
}
 
technique10 Technique1
{
    pass P0
    {
        SetVertexShader( CompileShader( vs_4_0, VertexShaderFunction() ) );
        SetGeometryShader( NULL );
        SetPixelShader( CompileShader( ps_4_0, PixelShaderFunction() ) );
    }
}