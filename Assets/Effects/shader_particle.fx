//INCLUDES ---
#include "shader.inc"
#include "common_particle.inc"

#include "directional_particle.inc"
#include "linear_particle.inc"
#include "explosion_particle.inc"
#include "fountain_particle.inc"
#include "orbital_particle.inc"
#include "spiral_particle.inc"
#include "sphere_particle.inc"
#include "radial_particle.inc"

//Emitter constants
float4	_Orientation;
float3	_ControlPoint;
float	_ElapsedTime;
float	_StartTime;

int		_Repeats;
// -----------------

//Textures
//Textures must be set at run time depending on what type of emitter is being loaded. Some emitters won't used secondary or tertiary textures
//But others such as the explosion emitter require a fire texture and a smoke texture
//The main texture is included from "shader.inc"

Texture2D _SecondaryTex;
Texture2D _TertiaryTex;

//STRUCTS ----------------
struct VertexShaderInput
{
	float4	Position			: POSITION;
	float4	Color	 			: COLOR0;
	float3	Velocity			: TEXCOORD0;
	float3	Acceleration		: TEXCOORD1;
	float	Size				: PSIZE0;
	float	Timestamp			: TEXCOORD2;
	float	LifeTime			: TEXCOORD3;
	float	Rotation			: TEXCOORD4;
	float	Type				: TEXCOORD5;
};

struct VertexShaderOutput
{
	float4	Position			: POSITION0;
	float	Size				: PSIZE;
	float4	Color 				: COLOR0;
	float4	Rotation			: COLOR1;
	float4	Data				: COLOR2;
	float3	AgeRelAgeActive		: TEXCOORD0;
	float	Type				: TEXCOORD1;
	float	Index				: TEXCOORD2;
};

struct PixelShaderInput
{
	float4	Position			: SV_POSITION;
	float4	Color				: COLOR0;
	float4	Rotation			: COLOR1;
	float2	TexCoord			: TEXCOORD0;
	float4	AgeRelAgeActiveSize	: TEXCOORD1;
	float	Type				: TEXCOORD2;	
	float	Index				: TEXCOORD3;
};

// ------------------------

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
	float4x4 wvp = mul( mul( _World, _Camera.View ) , _Camera.Projection );
	
	float particleStartOffset = input.Timestamp;
	float elapsedTime = _ElapsedTime - _StartTime;
	
	float totalAge = max(elapsedTime - particleStartOffset, 0);
	float cycleAge = fmod(totalAge, input.LifeTime); //CalculateAge(_StartTime, _ElapsedTime, input.LifeTime, input.Timestamp);
	int currentIteration = floor(totalAge / input.LifeTime);	
	float relAge = saturate(cycleAge / input.LifeTime);
	int active = ((elapsedTime - particleStartOffset) > 0 && (currentIteration < _Repeats || _Repeats == -1)) ? 1 : 0;
		
	VertexShaderOutput output;
	output.Position = input.Position;
	output.Size = input.Size;
	output.Color = input.Color;
	output.Data = float4(_ElapsedTime, _StartTime, currentIteration, _Repeats);
	
	output.Index = 0;
		
	[flatten] switch (input.Type)
	{
		case 0:			//Explosion
		{
			//when the particle reaches a certain age, force it to travel upwards
			float interval = 0.5f;
			//if(relAge > 0.5)
			//{
				//input.Velocity.xz -= (relAge / 10.0f);
				input.Velocity.y = (abs(input.Velocity.y) + cycleAge);
				interval = max(interval - (1 - cycleAge / 10.0f), 0);
			//}
			output.Position = OutputExplosionPosition(input.Position, input.Velocity, input.Acceleration, cycleAge, interval,  _ControlPoint);
			
			break;
		}
		case 1:			//Directional
		{
			float interval = 0.5f;
			output.Position = OutputDirectionalPosition(input.Position, input.Velocity, input.Acceleration, cycleAge, interval, _ControlPoint);
			break;
		}
		case 2:			//Linear
		{
			input.Velocity = input.Velocity + _Orientation.xyz;
			input.Velocity.y = input.Velocity.y - cycleAge * 0.5f;
			output.Position = OutputLinearPosition(input.Position, input.Velocity, cycleAge);
			break;
		}
		case 3:			//Fountain
		{
			//input.Velocity.xz = input.Velocity.xz + _Orientation.xz;
			input.Velocity.y =  input.Velocity.y - cycleAge * 0.2f;
			output.Position = OutputFountainPosition(input.Position, input.Velocity, cycleAge);
			break;
		}
		case 4:			//Orbital
		{
			float degree = relAge * 45;
			output.Position = OutputOrbitalPosition(input.Position, input.Velocity, input.Acceleration.r, cycleAge, degree, input.Acceleration.g, input.Acceleration.b);
			output.Index = input.Acceleration.r;
			break;
		}
		case 5:			//Spiral
		{
			output.Position = OutputSpiralPosition(input.Position, input.Velocity, input.Acceleration, _ControlPoint, cycleAge);
			break;
		}
		case 6:			//Sphere
		{
			output.Position = OutputSpherePosition(input.Position, input.Velocity,input.Acceleration, cycleAge, 0.5f, _ControlPoint);	
			break;
		}
		case 7:			//Radial
		{
			output.Position = OutputRadialPosition(input.Position, input.Velocity, cycleAge);
			break;
		}
		case 8:			//QuadStretch
		{
			//No position needs to be set, the quad just needs to be stretched
			break;
		}
		
	}

	output.Position = mul(output.Position, wvp);
	output.AgeRelAgeActive = float3(cycleAge, relAge, active);
	output.Type = input.Type;
	output.Rotation = ComputeParticleRotation(relAge, input.Rotation, -1, 1);
	return output; 
}

[maxvertexcount(4)]
void GeometryShaderFunction(point VertexShaderOutput input[1], inout TriangleStream<PixelShaderInput> stream)
{
	int x, y;
	float4 position;
	float2x2 rotationMatrix = input[0].Rotation * 2.0f - 1.0f;
	float halfSize;
	if(input[0].Index == 0)
		halfSize = input[0].Size / 2;
	else
		halfSize = input[0].Size / 6;
	
	PixelShaderInput output;

	//Data that doesn't change per vert
	output.Color = input[0].Color;
	output.Rotation = input[0].Rotation;
	output.AgeRelAgeActiveSize = float4(input[0].AgeRelAgeActive.xyz, input[0].Size);
	output.Type = input[0].Type;
	output.Index = input[0].Index;
	
	
	// vert 1
	position = float4(0, 0, 0, 0);
	position = float4(position.xy - halfSize, position.zw);
	position.xy = mul(position.xy, rotationMatrix);
	position += input[0].Position;
	
	output.Position = position;
	output.TexCoord = float2(0, 0);
	stream.Append(output);
	
	// vert 2
	position = float4(0, 0, 0, 0);
	position = float4(position.x + halfSize, position.y - halfSize, position.zw);
	position.xy = mul(position.xy, rotationMatrix);
	position += input[0].Position;
	
	output.Position = position;
	output.TexCoord =float2(1, 0);
	stream.Append(output);
	
	
	// vert 3
	position = float4(0, 0, 0, 0);
	position = float4(position.x - halfSize, position.y + halfSize, position.zw);
	position.xy = mul(position.xy, rotationMatrix);
	position += input[0].Position;
	
	output.Position = position;
	output.TexCoord = float2(0, 1);
	stream.Append(output);
	
	// vert 4
	position = float4(0, 0, 0, 0);
	position = float4(position.xy + halfSize, position.zw);
	position.xy = mul(position.xy, rotationMatrix);
	position += input[0].Position;
	
	output.Position = position;
	output.TexCoord = float2(1, 1);
	stream.Append(output);

	// next strip
	stream.RestartStrip();
}

[maxvertexcount(4)]
void QuadStretchGS(point VertexShaderOutput input[1], inout TriangleStream<PixelShaderInput> stream)
{
	int x, y;
	float4 position;
	float2x2 rotationMatrix = input[0].Rotation * 2.0f - 1.0f;
	float halfSize;
	if(input[0].Index == 0)
		halfSize = input[0].Size / 2;
	else
		halfSize = input[0].Size / 6;
	
	PixelShaderInput output;

	output.Color = input[0].Color;
	output.Rotation = input[0].Rotation;
	output.AgeRelAgeActiveSize = float4(input[0].AgeRelAgeActive.xyz, input[0].Size);
	output.Type = input[0].Type;
	output.Index = input[0].Index;
	
	// vert 1
	position = float4(0, 0, 0, 0);
	position = float4(position.xy - (input[0].Size * input[0].AgeRelAgeActive.x / 2), position.zw);
	position.xy = mul(position.xy, rotationMatrix);
	position += input[0].Position;
	
	output.Position = position;
	output.TexCoord = float2(0, 0);
	stream.Append(output);
	
	// vert 2
	position = float4(0, 0, 0, 0);
	position = float4(position.x + (halfSize * input[0].AgeRelAgeActive.x / 2), position.y - (halfSize * input[0].AgeRelAgeActive.x / 2), position.zw);
	position.xy = mul(position.xy, rotationMatrix);
	position += input[0].Position;
	
	output.Position = position;
	output.TexCoord = float2(1, 0);
	stream.Append(output);
	
	// vert 3
	position = input[0].Position;
	position = float4(position.x - (halfSize * input[0].AgeRelAgeActive.x / 2),position.y + (halfSize * input[0].AgeRelAgeActive.x / 2), position.zw);
	position.xy = mul(position.xy, rotationMatrix);
	
	output.Position = position;
	output.TexCoord = float2(0, 1);
	stream.Append(output);
	
	// vert 4
	position = input[0].Position;	
	position = float4(position.xy + (halfSize * input[0].AgeRelAgeActive.x / 2), position.zw);
	position.xy = mul(position.xy, rotationMatrix);
	
	output.Position = position;
	output.TexCoord = float2(1, 1);
	stream.Append(output);

	// next strip
	stream.RestartStrip();
}

float4 PixelShaderFunction(PixelShaderInput input) : SV_TARGET
{
	float4 color;
	
	if(input.AgeRelAgeActiveSize.z > 0)
	{	
		[flatten] switch (input.Type)
		{
			case 0:			//Explosion
			{
				if(input.AgeRelAgeActiveSize.y > input.Color.r)
					color = _SecondaryTex.Sample(TextureSampler, input.TexCoord);
				else
					color = _MainTex.Sample(TextureSampler, input.TexCoord);
					
				break;
			}
			case 1:			//Directional
			{
				color = _MainTex.Sample(TextureSampler, input.TexCoord) * input.Color;
				break;
			}
			case 2:			//Linear
			{
				//color = _MainTex.Sample(TextureSampler, input.TexCoord) * input.Color;
				break;
			}
			case 3:			//Fountain
			{
				color = _MainTex.Sample(TextureSampler, input.TexCoord) * input.Color;
				break;
			}
			case 4:			//Orbital
			{
				if(input.Index > 0)
					color = _SecondaryTex.Sample(TextureSampler, input.TexCoord) * input.Color;
				else
					color = _MainTex.Sample(TextureSampler, input.TexCoord) * input.Color;
					
				break;
			}
			case 5:			//Spiral
			{
				color = _MainTex.Sample(TextureSampler, input.TexCoord) * input.Color;
				break;
			}
			case 6:			//Sphere
			{
				//color = _MainTex.Sample(TextureSampler, input.TexCoord) * input.Color;
				break;
			}
			case 7:			//Radial
			{
				color = _MainTex.Sample(TextureSampler, input.TexCoord) * input.Color;
				break;
			}
			case 8:			//QuadStretch
			{
				color = _MainTex.Sample(TextureSampler, input.TexCoord);
				break;
			}
			
		}
	}
	else
		color = float4(0, 0, 0, 0);
	
    return color;
}

DepthStencilState NoDepthWrites
{
	DepthEnable = TRUE;
	DepthWriteMask = ZERO;
};

BlendState SrcAlphaBlend
{
	//AlphaToCoverageEnable		= TRUE;
	BlendEnable[0]				= TRUE;
	SrcBlend					= SRC_ALPHA;
	DestBlend					= ONE;
	BlendOp						= ADD;
	SrcBlendAlpha			    = ZERO;
	DestBlendAlpha				= ONE;
	BlendOpAlpha				= ADD;
	//RenderTargetWriteMask[0]	= 0x0F;
};

technique10 DefaultBlend
{
    pass P0
    {
		SetBlendState( SrcAlphaBlend, float4(0.0f, 0.0f, 0.0f, 0.0f), 0xFFFFFFFF);
		SetDepthStencilState(NoDepthWrites, 0);
		
        SetVertexShader( CompileShader( vs_4_0, VertexShaderFunction() ) );
        SetGeometryShader( CompileShader( gs_4_0, GeometryShaderFunction() ) );
        SetPixelShader( CompileShader( ps_4_0, PixelShaderFunction() ) );
    }

    pass P1		//Quad Stretch Run
    {
		SetBlendState( SrcAlphaBlend, float4(0.0f, 0.0f, 0.0f, 0.0f), 0xFFFFFFFF);
		SetDepthStencilState(NoDepthWrites, 0);
		
        SetVertexShader( CompileShader( vs_4_0, VertexShaderFunction() ) );
        SetGeometryShader( CompileShader( gs_4_0, QuadStretchGS() ) );
        SetPixelShader( CompileShader( ps_4_0, PixelShaderFunction() ) );
    }
}