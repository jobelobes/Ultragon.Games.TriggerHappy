float4x4 World;
float4x4 View;
float4x4 Projection;

float3 lightDirection;
float3 lightColor;
float3 cameraPosition;

float specularIntensity = 0.8f;
float specularPower = 0.5f;

float2 halfPixel;

float4x4 InverseViewProjection;

texture colorMap;
texture normalMap;
texture depthMap;

sampler ColorSampler = sampler_state
{
    Texture = (colorMap);
    AddressU = CLAMP;
    AddressV = CLAMP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};

sampler NormalSampler = sampler_state
{
    Texture = (normalMap);
    AddressU = CLAMP;
    AddressV = CLAMP;
    MAGFILTER = POINT;
    MINFILTER = POINT;
    MIPFILTER = POINT;
};

sampler DepthSampler = sampler_state
{
    Texture = (depthMap);
    AddressU = CLAMP;
    AddressV = CLAMP;
    MAGFILTER = POINT;
    MINFILTER = POINT;
    MIPFILTER = POINT;
};

struct VertexShaderInput
{
    float3 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;

};

struct VertexShaderOutput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;

};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;

    float4x4 wvp = mul( mul (View, World), Projection);

    //output.Position = mul(input.Position, wvp);
    output.Position = float4(input.Position, 1);
    output.TexCoord = input.TexCoord - halfPixel;
    return output;
}

float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
    //get normal data from normal map
    float4 normalData = tex2D(NormalSampler, input.TexCoord);
    
    //transform normal back into [-1, 1] range
    float3 normal = 2.0f * normalData.xyz - 1.0f;
   
    //get specular power, and get it into [0, 255] range
    float specularPower = normalData.a * 255;

    //get specular intensity from the color map
    float specularIntensity = tex2D(ColorSampler, input.TexCoord).a;

    //read depth from texture
    float depthVal = tex2D(DepthSampler, input.TexCoord).r;

    //compute screen-space position
    float4 position;
    position.x = input.TexCoord.x * 2.0f - 1.0f;
    position.y = -(input.TexCoord.y * 2.0f - 1.0f);
    position.z = depthVal;
    position.w = 1.0f;

    //transform to world space
    position = mul(position, InverseViewProjection);
    position /= position.w;

    //light vector
    float3 lightVector = -normalize(lightDirection);

    //compute diffuse light
    float NdL = max(0, dot(normal, lightVector));
    float3 diffuseLight = NdL * lightColor.rgb;

    //reflection vector
    float3 reflectionVector = normalize(reflect(-lightVector, normal));
    
    //camera to surface vector
    float3 directionToCamera = normalize(cameraPosition - position);
    //compute specular light
    float specularLight = specularIntensity * pow(saturate(dot(reflectionVector, directionToCamera)), specularPower);
    
    return float4(diffuseLight.rgb, specularLight);
    
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
