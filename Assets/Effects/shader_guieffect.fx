#include "shader.inc"

struct VertexGui
{
	float3 Position				: POSITION0;
	float2 Size					: TEXCOORD0;
	float4 ExpandingRegion		: POSITION1;
};

SamplerState GuiSampler
{
    Filter = ANISOTROPIC;
    AddressU = Wrap;
    AddressV = Wrap;
};

struct GeometryNinePatch
{
	vector<float, 4> HPositions			: POSITION0;
	vector<float, 4> VPositions			: POSITION1;
	vector<float, 4> TextureHPositions	: POSITION2;
	vector<float, 4> TextureVPositions	: POSITION3;
	float4 Color						: COLOR0;
	float ZOrder						: COLOR1;
};

struct VertexShaderOutput
{
	float4 Position		: SV_POSITION;
	float4 Color 		: COLOR0;
	float2 TexCoord		: TEXCOORD0;
};

GeometryNinePatch VertexShaderFunction(VertexGui input)
{
	uint texWidth, texHeight;
	_MainTex.GetDimensions(texWidth, texHeight);
	
	float2 viewport = _Camera.Size * 0.5;
	
	GeometryNinePatch output;
	output.HPositions[0] = input.Position.x / viewport.x - 1;
	output.HPositions[1] = (input.Position.x + input.ExpandingRegion.x) / viewport.x - 1;
	output.HPositions[2] = (input.Position.x + input.Size.x - input.ExpandingRegion.z) / viewport.x - 1;
	output.HPositions[3] = (input.Position.x + input.Size.x) / viewport.x - 1;
	
	output.VPositions[0] = input.Position.y / viewport.y - 1;
	output.VPositions[1] = (input.Position.y + input.ExpandingRegion.y) / viewport.y - 1;
	output.VPositions[2] = (input.Position.y + input.Size.y - input.ExpandingRegion.w) / viewport.y - 1;
	output.VPositions[3] = (input.Position.y + input.Size.y) / viewport.y - 1;
	
	output.TextureHPositions[0] = 0;
	output.TextureHPositions[1] = input.ExpandingRegion.x / texWidth;
	output.TextureHPositions[2] = (texWidth - input.ExpandingRegion.z) / texWidth;
	output.TextureHPositions[3] = 1;
	
	output.TextureVPositions[0] = 0;
	output.TextureVPositions[1] = input.ExpandingRegion.y / texHeight;
	output.TextureVPositions[2] = (texHeight - input.ExpandingRegion.w) / texHeight;
	output.TextureVPositions[3] = 1;
	
	output.Color = _Material.Color;
	output.ZOrder = input.Position.z;
	return output; 
} 

[maxvertexcount(24)]
void GeometryShaderFunction(point GeometryNinePatch input[1], inout TriangleStream<VertexShaderOutput> stream)
{
	int x, y;
	VertexShaderOutput output;
	
	for(x = 0; x < 3; x++)
	{
		for(y = 0; y < 4; y++)
		{
			// vert 2
			output.Position = float4(input[0].HPositions[x], -input[0].VPositions[y], input[0].ZOrder, 1);
			output.TexCoord = float2(input[0].TextureHPositions[x], input[0].TextureVPositions[y]);
			output.Color = input[0].Color;
			stream.Append(output);
			
			// vert 3
			output.Position = float4(input[0].HPositions[x + 1], -input[0].VPositions[y], input[0].ZOrder, 1);
			output.TexCoord = float2(input[0].TextureHPositions[x + 1], input[0].TextureVPositions[y]);
			output.Color = input[0].Color;
			stream.Append(output);
		}
		
		// next strip
		stream.RestartStrip();
	}
}

float4 PixelShaderFunction(VertexShaderOutput input) : SV_TARGET
{
	return input.Color * _MainTex.Sample(GuiSampler, input.TexCoord);
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