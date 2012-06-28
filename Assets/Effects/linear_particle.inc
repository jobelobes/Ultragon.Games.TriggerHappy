//All functionality and structs pertaining to the linear modifier go in this file

float4 OutputLinearPosition(float3 position, float3 velocity, float age)
{
	position = position  + velocity * age;
	
	return float4(position, 1.0f);
}