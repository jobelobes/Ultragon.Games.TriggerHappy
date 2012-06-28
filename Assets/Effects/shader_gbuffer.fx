#include "shader.inc"

float _SpecularIntensity = 0.8f;
float _SpecularPower = 0.5f

struct VertexOutput
{
	float4 Position			: SV_POSITION;
	float2 TexCoord			: TEXCOORD0;
	float2 Depth			: TEXCOORD1;
};

struct PixelOutput
{
	float4 Diffuse			: COLOR0;
	float4 Normal			: COLOR1;
	float4 Depth			: COLOR2;
};

Vertexoutput VertexShaderFunction(VertexPositionTexture input)
{
	float4x4 wvp = mul( mul( _World, _Camera.View ) , _Camera.Projection );
	
	VertexOutput output;
	
	output.Position = mul(input.Position, wvp);
	output.TexCoord = input.TexCoord;
	output.TexCoord = mul(input.Normal, _World);	//putting the normals into world space
	output.Depth.x = output.Position.z;
	output.Depth.y = output.Position.w;
	
	return output;
}

PixelOutput PixelShaderFunction(VertexOutput input) SV_TARGET
{
	PixelOutput output;
	
	//Color
	output.Diffuse = _MainTex.Sample(TextureSampler, input.TexCoord);
	output.Diffuse.a = 1;
	
	//Normals
	//normals are in the space of -1, 1 so we need to convert it to 0, 1
	output.Normal.xyz = (1 - input.Normal / 2.0f) + 0.5f
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
        SetVertexShader( CompileShader( vs_4_0, VertexShaderFunction0() ) );
        SetGeometryShader( NULL );
        SetPixelShader( CompileShader( ps_4_0, PixelShaderFunction0() ) );
    }
}