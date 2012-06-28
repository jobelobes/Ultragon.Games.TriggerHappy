#include "shader.inc"

struct GeometryAxis
{
	float4 XAxis		: POSITION0;
	float4 YAxis		: POSITION1;
	float4 ZAxis		: POSITION2;
	float4 CenterPoint	: POSITION3;
};

struct VertexShaderOutput
{
	float4 Position		: SV_POSITION;
	float4 Color 		: COLOR0;
};

GeometryAxis VertexShaderFunction(VertexPositionColor input)
{
	float4x4 view =  _Camera.View;
	
	//strip out the translation; since we only want the orientation
	view._41 = 0;
	view._42 = 0;
	view._43 = 1;
	
	float4x4 wvp = mul(view , _Camera.Projection);
	float4 centerpoint = float4(0.8, -0.8, 0, 1); // move to the bottom right hand corner
	
	GeometryAxis output;
	output.XAxis = float4(centerpoint.xy + mul(float4(0.05,0,0,1), wvp).xy, 0, 1);
	output.YAxis = float4(centerpoint.xy + mul(float4(0,0.05,0,1), wvp).xy, 0, 1);
	output.ZAxis = float4(centerpoint.xy + mul(float4(0,0,0.05,1), wvp).xy, 0, 1);
	output.CenterPoint = centerpoint;
	return output; 
} 

[maxvertexcount(6)]
void GeometryShaderFunction(point GeometryAxis input[1], inout LineStream<VertexShaderOutput> stream)
{
	VertexShaderOutput output;
	
	// x axis
	output.Position = input[0].XAxis;
	output.Color = float4(1, 0, 0, 1);
	stream.Append(output);
	
	output.Position = input[0].CenterPoint;
	output.Color = float4(1, 0, 0, 1);
	stream.Append(output);
	
	stream.RestartStrip();
	
	// y axis
	output.Position = input[0].YAxis;
	output.Color = float4(0, 1, 0, 1);
	stream.Append(output);
	
	output.Position = input[0].CenterPoint;
	output.Color = float4(0, 1, 0, 1);
	stream.Append(output);
	
	stream.RestartStrip();
	
	// x axis
	output.Position = input[0].ZAxis;
	output.Color = float4(0, 0, 1, 1);
	stream.Append(output);
	
	output.Position = input[0].CenterPoint;
	output.Color = float4(0, 0, 1, 1);
	stream.Append(output);
	
	stream.RestartStrip();
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
        SetGeometryShader( CompileShader( gs_4_0, GeometryShaderFunction() ) );
        SetPixelShader( CompileShader( ps_4_0, PixelShaderFunction() ) );
    }
}