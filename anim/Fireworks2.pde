/*
 * This code is adapted from:
 *
 * 8 x 8 x 8 Cube Application Template, Version 7.0  © 2014 by Doug Domke
 * Downloads of this template and upcoming versions, along with detailed
 * instructions, are available at: http://d2-webdesign.com/cube
 *
 * Local modifications required to support the Pi cube software are
 * bracketed within #ifdef PICUBE
 */


// This is the Fireworks animation created by SuperTech-IT
void fireworks2 (byte iterations,byte n,int delayx) {
 
byte i,f,e;

	float origin_x = 3;
	float origin_y = 3;
	float origin_z = 3;

	int rand_y, rand_x, rand_z;

	float slowrate, gravity;

	// Particles and their position, x,y,z and their movement, dx, dy, dz
	float particles[n][6];
        float lastpart[n][3];

	for (i=0; i<iterations; i++)
	{

		origin_x = rand()%4;
		origin_y = rand()%4;
		origin_z = rand()%2;
		origin_z +=5;
        origin_x +=2;
        origin_y +=2;

		// shoot a particle up in the air
		for (e=0;e<origin_z;e++)
		{
			LED (origin_x,origin_y,e,(random(16)),(random(16)),(random(16)));
			x=(50*e);
                        delay(delayx*2);
			clearCube();
		}

		// Fill particle array
		for (f=0; f<n; f++)
		{
			// Position
			particles[f][0] = origin_x;
			particles[f][1] = origin_y;
			particles[f][2] = origin_z;
			
			rand_x = rand()%200;
			rand_y = rand()%200;
			rand_z = rand()%200;

			// Movement
			particles[f][3] = 1-(float)rand_x/100; // dx
			particles[f][4] = 1-(float)rand_y/100; // dy
			particles[f][5] = 1-(float)rand_z/100; // dz
		}

		// explode
		for (e=0; e<30; e++)
		{
			slowrate = 1+tan((e+0.1)/20)*20;
			
			gravity = tan((e+0.1)/20)/2;
// clearCube();

			for (f=0; f<n; f++)
			{
				// x=(random(16));
                                particles[f][0] += particles[f][3]/slowrate;
				particles[f][1] += particles[f][4]/slowrate;
				particles[f][2] += particles[f][5]/slowrate;
				if ((particles[f][2]) > 0) {particles[f][2] -= gravity;}
                                // clearCube();
				
                                LED (particles[f][0],particles[f][1],particles[f][2],random(64),random(64),random(64));
                                if ((particles[f][2]) < 0) {LED (particles[f][0],particles[f][1],particles[f][2],0,0,0);}
                                lastpart[f][0]=particles[f][0];
                                lastpart[f][1]=particles[f][1];
                                lastpart[f][2]=particles[f][2];

			}

		delay(delayx);
                  for (f=0; f<n; f++)
            {
        LED (lastpart[f][0],lastpart[f][1],lastpart[f][2],0,0,0);      
		}


	}

}
//
// delay (1000);
}
