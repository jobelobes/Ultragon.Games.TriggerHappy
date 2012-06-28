#include "shader.inc"

struct VertexFont
{
	float3 Position			: POSITION0;
	float2 Scale			: TEXCOORD0;
	float2 TextureOffset	: TEXCOORD1;
	float2 TextureSize		: TEXCOORD2;
};

SamplerState FontSampler
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};

struct GeometryFont
{
	float2 MinPosition			: POSITION0;
	float2 MaxPosition			: POSITION1;
	float2 MinTexture			: POSITION2;
	float2 MaxTexture			: POSITION3;
	float4 Color				: COLOR0;
	float ZOrder				: COLOR1;
};

struct VertexShaderOutput
{
	float4 Position		: SV_POSITION;
	float4 Color 		: COLOR0;
	float2 TexCoord		: TEXCOORD0;
};

GeometryFont VertexShaderFunction(VertexFont input)
{
	uint texWidth, texHeight;
	_MainTex.GetDimensions(texWidth, texHeight);
	
	float2 viewport = _Camera.Size * 0.5;
	
	GeometryFont output;
	output.MinPosition = input.Position.xy / viewport - 1;
	output.MaxPosition = (input.Position.xy + input.TextureSize) / viewport - 1;
	output.MinTexture = input.TextureOffset / float2(texWidth, texHeight);
	output.MaxTexture = (input.TextureOffset + input.TextureSize) / float2(texWidth, texHeight);
	output.Color = _Material.Color;
	output.ZOrder = input.Position.z;
	return output; 
} 

[maxvertexcount(4)]
void GeometryShaderFunction(point GeometryFont input[1], inout TriangleStream<VertexShaderOutput> stream)
{
	int x, y;
	VertexShaderOutput output;

	// vert 1
	output.Position = float4(input[0].MinPosition.x, -input[0].MinPosition.y, input[0].ZOrder, 1);
	output.TexCoord = float2(input[0].MinTexture.x, input[0].MinTexture.y);
	output.Color = input[0].Color;
	stream.Append(output);
	
	// vert 2
	output.Position = float4(input[0].MaxPosition.x, -input[0].MinPosition.y, input[0].ZOrder, 1);
	output.TexCoord = float2(input[0].MaxTexture.x, input[0].MinTexture.y);
	output.Color = input[0].Color;
	stream.Append(output);
	
	// vert 3
	output.Position = float4(input[0].MinPosition.x, -input[0].MaxPosition.y, input[0].ZOrder, 1);
	output.TexCoord = float2(input[0].MinTexture.x, input[0].MaxTexture.y);
	output.Color = input[0].Color;
	stream.Append(output);
	
	// vert 4
	output.Position = float4(input[0].MaxPosition.x, -input[0].MaxPosition.y, input[0].ZOrder, 1);
	output.TexCoord = float2(input[0].MaxTexture.x, input[0].MaxTexture.y);
	output.Color = input[0].Color;
	stream.Append(output);

	// next strip
	stream.RestartStrip();
}

float4 PixelShaderFunction(VertexShaderOutput input) : SV_TARGET
{
	return _MainTex.Sample(FontSampler, input.TexCoord) * input.Color;
}
 
technique10 Technique1
{
    pass P0
    {
        SetVertexShader( CompileShader( vs_4_0, VertexShaderFunction() ) );
        SetGeometryShader( CompileShader( gs_4_0, GeometryShaderFunction() ) );
        SetPixelShader( CompileShader( ps_4_0, PixelShaderFunction() ) );
    }
}