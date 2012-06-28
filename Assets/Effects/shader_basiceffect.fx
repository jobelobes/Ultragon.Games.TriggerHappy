#include "shader.inc"

struct VertexShaderOutput
{
	float4 Position			: SV_POSITION;
	float3 WorldPosition	: POSITION0;
	float4 Color 			: COLOR0;
	float3 Normal			: NORMAL0;
	float2 TexCoord			: TEXCOORD0;
};

VertexShaderOutput VertexShaderFunction0(VertexPositionNormalTexture input)
{
	float4x4 wvp = mul( mul( _World, _Camera.View ) , _Camera.Projection );
	
	VertexShaderOutput output;
	output.Position = mul(float4(input.Position.xyz, 1), wvp);
	output.WorldPosition = mul(float4(input.Position.xyz, 1), _World).xyz;
	output.Color = _Material.Color;
	output.Normal = input.Normal;
	output.TexCoord = input.TexCoord;
	return output; 
} 

VertexShaderOutput VertexShaderFunction1(VertexPositionColor input)
{
	float4x4 wvp = mul( mul( _World, _Camera.View ) , _Camera.Projection );
	
	VertexShaderOutput output;
	output.Position = mul(float4(input.Position.xyz, 1), wvp);
	output.WorldPosition = mul(float4(input.Position.xyz, 1), _World).xyz;
	output.Color = input.Color * _Material.Color;
	output.Normal = float3(0, 1, 0);
	output.TexCoord = float2(0, 0);
	return output; 
} 

float4 PixelShaderFunction0(VertexShaderOutput input) : SV_TARGET
{
    return input.Color * _MainTex.Sample(TextureSampler, input.TexCoord) * CalculateLighting(_Camera.Position.xyz, input.WorldPosition.xyz, input.Normal.xyz, _Material, _Lights);
}

float4 PixelShaderFunction1(VertexShaderOutput input) : SV_TARGET
{
    return input.Color;
}
 
technique10 Technique1
{   
    pass P1
    {
        SetVertexShader( CompileShader( vs_4_0, VertexShaderFunction0() ) );
        SetGeometryShader( NULL );
        SetPixelShader( CompileShader( ps_4_0, PixelShaderFunction0() ) );
    }
    
    pass P2
    {
        SetVertexShader( CompileShader( vs_4_0, VertexShaderFunction1() ) );
        SetGeometryShader( NULL );
        SetPixelShader( CompileShader( ps_4_0, PixelShaderFunction1() ) );
    }
}