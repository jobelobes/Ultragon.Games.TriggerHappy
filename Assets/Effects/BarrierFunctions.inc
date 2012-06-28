//All functionality and structs pertaining to the barrier modifier go in this file

float4 OutputBarrierPosition(float3 position, float3 velocity, float3 acceleration, float age, float interval, float3 controlPoint)
{
	position = position + velocity * age;
	
	return float4(position, 1.0f);
}