#include "shader_material.inc"
#include "shader_lighting.inc"

struct Camera
{
	float3 Position;
	float2 Size;
	float4x4 Projection;
    float4x4 View;
};

cbuffer cbScene
{
    Camera		_Camera;
    Light		_Lights[MAX_LIGHTS];
};

cbuffer cbObject
{
    float4x4	_World;
    Material	_Material;
};

struct VertexPositionNormalTexture
{
	float3 Position	: POSITION0;
	float3 Normal	: NORMAL0;
	float2 TexCoord	: TEXCOORD0;
};

struct VertexPositionColor
{
	float3 Position	: POSITION0;
	float4 Color	: COLOR0;
};

SamplerState TextureSampler
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};

SamplerState TextureSamplerClamp
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Clamp;
    AddressV = Clamp;
};

Texture2D	_MainTex;