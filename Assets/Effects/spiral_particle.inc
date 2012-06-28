//All functionality and structs pertaining to the barrier modifier go in this file
float4 OutputSpiralPosition(float3 position, float3 velocity, float3 acceleration, float3 controlPoint, float age)
{
	float3 outPosition = position;
	
	//Increase the radius and based on the particle's age
	float radius = age * 0.1f;
	float angle = 0.0 + (age % 360);
	
	outPosition.x = (position.x + (acceleration.x * velocity.x) + radius) * cos(angle);
	outPosition.y = position.y + (acceleration.y * velocity.y);// + (age / 20.0f);
	outPosition.z = (position.z + (acceleration.z * velocity.z) + radius) * sin(angle);
	
	//particle needs to travel upward (relative to velocity)
	return float4(outPosition, 1.0f);
}