#include "shader.inc"

//Normal map is the main texture set
Texture2D _DepthMap;

float2 _HalfPixel;

float4x4 _InverseViewProjection;

struct VertexInput
{
	float3 Position	: POSITION0;
	float2 TexCoord	: TEXCOORD0;
};

struct VertexOutput
{
	float4 Position 		: SV_POSITION;
	float2 TexCoord 		: TEXCOORD0;
};

VertexOutput VertexShaderFunction(VertexInput input)
{
    VertexOutput output;

    float4x4 wvp = mul( mul( _World, _Camera.View ) , _Camera.Projection );

    //output.Position = mul(input.Position, wvp);
    output.Position = float4(input.Position, 1);
    output.TexCoord = input.TexCoord - _HalfPixel;
    return output;
}

float4 PixelShaderFunction(VertexOutput input) : SV_TARGET
{
	float4 color;
	
	//Grabbing the normals
	float4 normalData = _MainTex.Sample(TextureSamplerClamp, input.TexCoord);
	
	//transform normal back into [-1, 1] range
    float3 normal = 2.0f * normalData.xyz - 1.0f;
	
	//read depth from texture
    float depthVal = _DepthMap.Sample(TextureSamplerClamp, input.TexCoord).r;

  
	//compute screen-space position
    float4 position;
    position.x = input.TexCoord.x * 2.0f - 1.0f;
    position.y = -(input.TexCoord.y * 2.0f - 1.0f);
    position.z = depthVal;
    position.w = 1.0f;

    //transform to world space
    position = mul(position, _InverseViewProjection);
    position /= position.w;
	
	//calculating the lighting based on input normals 
	//return CalculateLighting(_Camera.Position.xyz, position.xyz, normal, _Material, _Lights);
	return float4(1, 0, 0, 1);
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