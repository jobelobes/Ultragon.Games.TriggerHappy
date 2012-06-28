//Functions and structs that all particle systems will use go here. Ex: calculating age

//METHODS ----------------
float CalculateEndlessAge(float startTime, float elapsedTime, float lifeTime, float timestamp)
{
	float age = elapsedTime - startTime;
	if(age > timestamp)
		age = (age - timestamp) % lifeTime;
	else if(age > lifeTime)
		age = 0;
	else	
		age = 0;
		
	return age;
}

float CalculateAge(float startTime, float elapsedTime, float lifeTime, float timestamp)
{
	float age = elapsedTime - startTime;
	age = (age - timestamp) % lifeTime;
		
	return age;
}

float4 ComputeParticleRotation(float age, float randomSpeed, float minRot, float maxRot)
{
	float rotSpeed = lerp(minRot, maxRot, randomSpeed);
	float rotation = rotSpeed * age;
	
	//2x2 matrix
	float c = cos(rotation);
	float s = sin(rotation);
	
	float4 rotationMatrix = float4(c, -s, s, c);
	
	rotationMatrix *= 0.5;
	rotationMatrix += 0.5;
	
	return rotationMatrix;
}

float QuadraticBezierCurve(float p0, float p1, float p2, float t)
{
       return (1-t) * (1-t) * p0 + 2 * t * (1-t) * p1 + t * t * p2;
}

float4 CalculateBezierColor(float4 start, float4 mid, float4 end, float t)
{
       return float4(  QuadraticBezierCurve( start.r, mid.r, end.r, t ),
                                       QuadraticBezierCurve( start.g, mid.g, end.g, t ),
                                       QuadraticBezierCurve( start.b, mid.b, end.b, t ),
                                       QuadraticBezierCurve( start.a, mid.a, end.a, t ) );
}

float3 CalculateBezierPosition( float3 start, float3 mid, float3 end, float t)
{
       return float3(  QuadraticBezierCurve( start.x, mid.x, end.x, t ),
                                       QuadraticBezierCurve( start.y, mid.y, end.y, t ),
                                       QuadraticBezierCurve( start.z, mid.z, end.z, t ) );
}