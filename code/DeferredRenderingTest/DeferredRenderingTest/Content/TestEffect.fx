float4x4 World;
float4x4 View;
float4x4 Projection;


struct VertexShaderInput
{
    float4 Position : POSITION0;


};

struct VertexShaderOutput
{
    float4 Position : POSITION0;

};

struct PixelShaderOutput
{
    float4 Color    : COLOR0;
    float4 Color1   : COLOR1;
    float4 Color2   : COLOR2;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;

    float4 worldPosition = mul(input.Position, World);
    float4 viewPosition = mul(worldPosition, View);
    output.Position = mul(viewPosition, Projection);


    return output;
}

PixelShaderOutput PixelShaderFunction(VertexShaderOutput input)
{
    PixelShaderOutput output;
    output.Color = float4(1, 0, 0, 1);
    output.Color1 = float4(0, 1, 0, 1);
    output.Color2 = float4(0, 0, 1, 1);
    
    return output;
}

technique Technique1
{
    pass Pass1
    {
        // TODO: set renderstates here.

        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}
