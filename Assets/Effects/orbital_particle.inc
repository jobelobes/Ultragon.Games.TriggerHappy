float4 OutputOrbitalPosition(float3 position, float3 velocity, float index, float age, float degree, float radius, float radius2)
{
	//orbital emitter takes two types of particles. One large particle that represents a "planet"
	//and the rest are smaller particles
	float3 outPosition = position;
	
	//if the incoming particle index is greater than one, we'll compute a trail for the particles that follows the "planet"
	if(index > 0)
		degree - (1 * age);
	
	outPosition.x = ((position.x + radius) * cos(degree)) - ((position.z + radius2) * sin(degree));
	outPosition.z = ((position.z + radius2) * cos(degree)) + ((position.x + radius) * sin(degree));
	
	return float4(outPosition, 1.0f);
}