//INCLUDES ---
#include "CommonFunctions.inc"
#include "ExplosionFunctions.inc"
#include "ModifierFunctions.inc"

#include "AcceleratorFunctions.inc"
#include "BarrierFunctions.inc"
#include "GrowFunctions.inc"
#include "IllusionFunctions.inc"
#include "IncreaseGravityFunctions.inc"
#include "InverseGravityFunctions.inc"
#include "KnockbackFunctions.inc"
#include "ShrinkFunctions.inc"

// -----------

// MUST BE HERE ---
float4x4	World;
float4x4	View;
float4x4	Projection;
// MUST BE HERE ---

//EMITTER PARAMETERS
float	ElapsedTime;
float	StartTime;
float3	ControlPoint;
// -----------------

//STRUCTS ----------------
struct VertexShaderInput
{
	float4	Position			: POSITION;
	float4	Color	 			: COLOR0;
	float3	Velocity			: TEXCOORD0;
	float3	Acceleration		: TEXCOORD1;
	float	Timestamp			: TEXCOORD2;
	float	LifeTime			: TEXCOORD3;
	float	Type				: TEXCOORD4;
};

struct VertexShaderOutput
{
	float4	Position			: SV_POSITION;
	float	Size				: PSIZE;
	float4	Color 				: COLOR0;
	float	Age					: COLOR1;
};
// ------------------------

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
	float4x4 wvp = mul ( mul (World, View) , Projection);
	float age = CalculateAge(StartTime, ElapsedTime, input.LifeTime, input.Timestamp);
	
	VertexShaderOutput output;
	output.Position = input.Position;
	output.Size = 10;
	output.Color = input.Color;
	
	
	[flatten] switch (input.Type)
	{
		case 0:			//Explosion
		{
			output.Position = OutputExplosionPosition(input.Position, input.Velocity,input.Acceleration, age, 0.5f, ControlPoint);	
			break;
		}
		case 1:			//Modifier Trigger
		{
			break;
		}
		case 2:			//Acclerator
		{
			break;
		}
		case 3:			//Barrier
		{
			output.Position = OutputBarrierPosition(input.Position, input.Velocity,input.Acceleration, age, 0.5f, ControlPoint);
			break;
		}
		case 4:			//Grow
		{
			break;
		}
		case 5:			//Illusion
		{
			break;
		}
		case 6:			//Increase Gravity
		{
			break;
		}
		case 7:			//Inverse Gravity
		{
			break;
		}
		case 8:			//Knockback
		{
			break;
		}
		case 9:			//Knockback
		{
			break;
		}
		case 10:		//Shrink
		{
			break;
		}
	}
	
	output.Age = age;
	return output; 
} 

float4 PixelShaderFunction(VertexShaderOutput input) : SV_TARGET
{
    return float4(1.0f, 1.0f, 1.0f, 1.0f);
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