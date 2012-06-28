float4 OutputDirectionalPosition(float3 position, float3 velocity, float3 acceleration, float age, float interval, float3 controlPoint)
{
	float segments = 20;
	float iteration = age / segments;
	
	for(int i = 0; i < segments; i++)
	{
		position = position + velocity * iteration + interval * acceleration * pow(iteration, 2);
		velocity = velocity + acceleration * (interval * 2);
		acceleration = acceleration  * (position - controlPoint);
	}
	
	
	return float4(position, 1.0f);
}