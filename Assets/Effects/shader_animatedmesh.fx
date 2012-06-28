#include "shader.inc"

//If the character mesh has more or less bones in the skeleton, then this value needs to change
#define MaxBones 206		

cbuffer cbAnimation
{
    float4x4	_Bones[MaxBones];
};

float testValue;

// Vertex shader input structure.
struct VS_INPUT
{
    float4	Position			: POSITION0;
    float3	Normal				: NORMAL0;
    float2	TexCoord			: TEXCOORD0;
    uint	BlendIndex0			: BLENDINDICES0;
    uint	BlendIndex1			: BLENDINDICES1;
    uint	BlendIndex2			: BLENDINDICES2;
    uint	BlendIndex3			: BLENDINDICES3;
    uint	BlendIndex4			: BLENDINDICES4;
    float	BlendWeight0		: BLENDWEIGHT0;
    float	BlendWeight1		: BLENDWEIGHT1;
    float	BlendWeight2		: BLENDWEIGHT2;
    float	BlendWeight3		: BLENDWEIGHT3;
    float	BlendWeight4		: BLENDWEIGHT4;
};

// Vertex shader output structure.
struct PS_INPUT
{
    float4 Position : SV_POSITION;
    float2 TexCoord : TEXCOORD0;
};

// Vertex shader program.
PS_INPUT VertexShaderFunction(VS_INPUT input)
{
	//-------------------------------------------------------------------------
	// PS_INPUT output;	
    // float4 position = 0;//input.Position;
         
    // //Blend between the weighted bone matrices.
    // if(input.BlendWeight0 > 0)
		// position += mul(input.Position, _Bones[input.BlendIndex0]) * input.BlendWeight0;		
	// if(input.BlendWeight1 > 0)
		// position += mul(input.Position, _Bones[input.BlendIndex1]) * input.BlendWeight1;    
    // if(input.BlendWeight2 > 0)
		// position += mul(input.Position, _Bones[input.BlendIndex2]) * input.BlendWeight2;	
	// if(input.BlendWeight3 > 0)
		// position += mul(input.Position, _Bones[input.BlendIndex3]) * input.BlendWeight3;		
	// if(input.BlendWeight4 > 0)
		// position += mul(input.Position, _Bones[input.BlendIndex4]) * input.BlendWeight4;
	
    // //Skin the vertex position.
	// //float4x4 wvp = mul(mul(_World, _Camera.View ), _Camera.Projection);    
	// output.Position = mul(mul(float4(position.xyz, 1), _Camera.View), _Camera.Projection);
	// output.TexCoord = input.TexCoord;

	// return output;
	
	
	//-------------------------------------------------------------------------
    PS_INPUT output;
    
	float4 inPos = input.Position;
	float4 interPos = 0;	
	// if(input.BlendWeight0 > 0)
		// interPos += mul(mul(input.BlendWeight0, inPos), _Bones[input.BlendIndex0]);
	// if(input.BlendWeight1 > 0)
		// interPos += mul(mul(input.BlendWeight1, inPos), _Bones[input.BlendIndex1]);
	// if(input.BlendWeight2 > 0)
		// interPos += mul(mul(input.BlendWeight2, inPos), _Bones[input.BlendIndex2]);
	// if(input.BlendWeight3 > 0)
		// interPos += mul(mul(input.BlendWeight3, inPos), _Bones[input.BlendIndex3]);
	// if(input.BlendWeight4 > 0)
		// interPos += mul(mul(input.BlendWeight4, inPos), _Bones[input.BlendIndex4]);

	// if(input.BlendWeight0 > 0)
		// interPos += mul(_Bones[input.BlendIndex0], mul(input.BlendWeight0, inPos));
	// if(input.BlendWeight1 > 0)
		// interPos += mul(_Bones[input.BlendIndex1], mul(input.BlendWeight1, inPos));
	// if(input.BlendWeight2 > 0)
		// interPos += mul(_Bones[input.BlendIndex2], mul(input.BlendWeight2, inPos));
	// if(input.BlendWeight3 > 0)
		// interPos += mul(_Bones[input.BlendIndex3], mul(input.BlendWeight3, inPos));
	// if(input.BlendWeight4 > 0)
		// interPos += mul(_Bones[input.BlendIndex4], mul(input.BlendWeight4, inPos));	

	if(input.BlendWeight0 > 0)
		interPos += mul(_Bones[input.BlendIndex0], inPos) * input.BlendWeight0;
	if(input.BlendWeight1 > 0)
		interPos += mul(_Bones[input.BlendIndex1], inPos) * input.BlendWeight1;
	if(input.BlendWeight2 > 0)
		interPos += mul(_Bones[input.BlendIndex2], inPos) * input.BlendWeight2;
	if(input.BlendWeight3 > 0)
		interPos += mul(_Bones[input.BlendIndex3], inPos) * input.BlendWeight3;
	if(input.BlendWeight4 > 0)
		interPos += mul(_Bones[input.BlendIndex4], inPos) * input.BlendWeight4;	
	
	// float4x4 view;
	// float4x4 proj;
	// for(uint r = 0; r < 4; ++r)
	// {
		// for(uint c = 0; c < 4; ++c)
		// {
			// view[r][c] = _Camera.View[c][r];
			// proj[r][c] = _Camera.Projection[c][r];
		// }
	// }
		
	//output.Position = mul(mul(proj, view), interPos);	
	output.Position = mul(mul(interPos, _Camera.View), _Camera.Projection);	
	output.TexCoord = input.TexCoord;
	
	return output;
	
	
	//-------------------------------------------------------------------------
	// PS_INPUT output;
	
	// float4x4 skinTransform = 0;
	// if(input.BlendWeight0 > 0)
		// skinTransform += mul(input.BlendWeight0, _Bones[input.BlendIndex0]);
	// if(input.BlendWeight1 > 0)
		// skinTransform += mul(input.BlendWeight1, _Bones[input.BlendIndex1]);
	// if(input.BlendWeight2 > 0)
		// skinTransform += mul(input.BlendWeight2, _Bones[input.BlendIndex2]);
	// if(input.BlendWeight3 > 0)
		// skinTransform += mul(input.BlendWeight3, _Bones[input.BlendIndex3]);
	// if(input.BlendWeight4 > 0)
		// skinTransform += mul(input.BlendWeight4, _Bones[input.BlendIndex4]);

	// output.Position = mul(mul(mul(input.Position, skinTransform), _Camera.View), _Camera.Projection);	
	// output.TexCoord = input.TexCoord;
	
	// return output;
}

// Pixel shader program.
float4 PixelShaderFunction(PS_INPUT input) : SV_TARGET
{   
    return float4(0.5f, 0.5f, 0.5f, 1.0f);
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
