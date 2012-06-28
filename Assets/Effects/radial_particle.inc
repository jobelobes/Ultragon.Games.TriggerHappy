float4 OutputRadialPosition(float3 position, float3 velocity, float age)
{
	float3 outPosition = position;
	
	outPosition.y = position.y + (velocity.y * age);
	return float4(outPosition, 1.0f);
}