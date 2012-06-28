include "shader.inc"

Texture2D Gradient;

int Player;

float Opacity = 0.5;

struct VertexShaderInput
{
	float4 Position		: POSITION;
	float4 Color 		: COLOR0;
	float2 TextureUV	: TEXCOORD0;
};

struct VertexShaderOutput
{
	float4 Position		: SV_POSITION;
	float4 Color 		: COLOR0;
	float2 TextureUV	: TEXCOORD0;
};


float4 GetHudColor(int player)
{
	float4 outColor = float4(1,1,1,Opacity);
	
	if(player == 1)
	{
		outColor = float4(1, 0, 0,Opacity);
	}
	if(player == 2)
	{
		outColor = float4(0, 0, 1,Opacity);
	}

	return outColor;
}
VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
	float4x4 wvp = mul( mul( World, View ) , Projection );
	
	VertexShaderOutput output;
	output.Position = mul(input.Position, wvp);
	output.TextureUV = input.TextureUV;
	output.Color = input.Color;
	return output;
}

float4 AlphaPixel(VertexShaderOutput input) : SV_Target
{
	float2 texCoord = float2(input.TextureUV.x, input.TextureUV.y);
	float4 gradientCoord = GradientTexture.Sample(LinearSampler, texCoord);
	
	if(gradientCoord.r <= (StationHealth / 100.0))
		return InputTexture.Sample(LinearSampler, input.TextureUV) * GetHudColor(player);
	
    return float4(0, 0, 0, 0);
}

float4 StandardPixel(VertexShaderOutput input) : SV_Target
{
	return InputTexture.Sample(LinearSampler, input.TextureUV) * GetHudColor(StationType);
}
technique10 AlphaHud
{
    pass P0
    {
        SetVertexShader( CompileShader( vs_4_0, VertexShaderFunction() ) );
        SetGeometryShader( NULL );
        SetPixelShader( CompileShader( ps_4_0, AlphaPixel() ) );
    }
}

technique10 StandardHud
{
	pass P0
    {
        SetVertexShader( CompileShader( vs_4_0, VertexShaderFunction() ) );
        SetGeometryShader( NULL );
        SetPixelShader( CompileShader( ps_4_0, StandardPixel() ) );
    }
}

