float4 OutputFountainPosition(float3 position, float3 velocity, float age)
{
	position = position  + velocity * age;
	
	return float4(position, 1.0f);
}