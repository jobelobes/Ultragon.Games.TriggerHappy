//Variable initialization
float4x4 World;
float4x4 View;
float4x4 Projection;

Texture2D Texture;

//Sampler state. This is what we use to sample against textures at pixel coordinates
SamplerState TextureSampler
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Wrap;
	AddressV = Wrap;
};

//input structs MUST match the incoming vertex declaration you intend to use
struct VertexShaderInput
{
	float4 Position : POSITION0;
	float2 TexCoord : TEXCOORD0;
};

struct VertexShaderOutput
{
	float4 Position : SV_POSITION;
	float2 TexCoord : TEXCOORD0;
};

//basic vertex shader that pulls in a VertexShaderInput struct (which we recieve from the CPU side
//using the VertexPositionTexture declaration
VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
	VertexShaderOutput output;
	
	//here we create our WorldViewProjection (wvp) matrix to multiply our incoming vertex position to convert it to homogeneous world space
	float4x4 wvp = mul ( mul (World, View) , Projection);
	
	output.Position = mul(input.Position, wvp);
	output.TexCoord = input.TexCoord;
}

//basic pixel shader that samples from a texture
float4 PixelShaderOutput(VertexShaderInput input) : SV_TARGET
{
	//this line calls the texture sampler we created above. It takes in a sample state and the texture coordinates for that pixel from the input. It returns a float4 (vector4 in non-HLSL land) which represents our color
	return Texture.Sample(TextureSampler, input.TexCoord);
}

//This sets up the techniques. Here you can specify the technique name, as well as what functions to use for your vertex, geometry, and pixel shaders
technique10 Technique1
{
    pass P0
    {
        SetVertexShader( CompileShader( vs_4_0, VertexShaderFunction() ) );
        SetGeometryShader( NULL );
        SetPixelShader( CompileShader( ps_4_0, PixelShaderFunction() ) );
    }
}