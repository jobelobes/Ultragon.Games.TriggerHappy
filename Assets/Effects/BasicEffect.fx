// MUST BE HERE ---
float4x4 World;
float4x4 View;
float4x4 Projection;
// MUST BE HERE ---

struct VertexShaderInput
{
	float4 Position		: POSITION;
	float4 Normal		: NORMAL0;
	float4 TextureCoord	: TEXCOORD0;
};

struct VertexShaderOutput
{
	float4 Position	: SV_POSITION;
	float4 Color 	: COLOR0;
};


VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
	float4x4 wvp = mul( mul( World, View ) , Projection );
	
	VertexShaderOutput output;
	output.Position = mul(input.Position, wvp);
	output.Color = float4(1.0,0.0,0.0,1.0);
	return output; 
} 

float4 PixelShaderFunction(VertexShaderOutput input) : SV_TARGET
{
    return input.Color;
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