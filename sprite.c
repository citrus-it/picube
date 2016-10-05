/*
 * This code contains a port of the sprite class from:
 *
 * 8 x 8 x 8 Cube Application Template, Version 7.0  © 2014 by Doug Domke
 * Downloads of this template and upcoming versions, along with detailed
 * instructions, are available at: http://d2-webdesign.com/cube
 *
 * Many of the functions have been rewritten or optimised in the process.
 * 
 */

#include <stdio.h>
#include <sys/types.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <errno.h>
#include "cube.h"
#include "sprite.h"

extern uint8_t myred, mygreen, myblue;
#define getColor(c, i) cube_colour((c), &myred, &mygreen, &myblue, (i) + 1)

void
sprite_colorIt(sprite s, int colour)
{
	int x, y, z;

	for (x = 0; x < s->myX; x++)
	  for (y = 0; y < s->myY; y++)
	    for (z = 0; z < s->myZ; z++)
		s->description[x][y][z] = colour;
}

void
sprite_outline(sprite s, int colour)
{
	int x, y, z;

	sprite_colorIt(s, Black);

	for (x = 0; x < s->myX; x++)
	  for (y = 0; y < s->myY; y++)
	    for (z = 0; z < s->myZ; z++)
	    {
		if (x == 0 || x == s->myX-1 || y == 0 || y == s->myY-1 ||
		    z == 0 || z == s->myZ-1)
			s->description[x][y][z] = colour;
	    }
}

void
sprite_place(sprite s, int x, int y, int z)
{
	s->place[0] = x;
	s->place[1] = y;
	s->place[2] = z;
}

void
sprite_placeX(sprite s, int x, int val)
{
	s->place[x] = val;
}

void
sprite_motion(sprite s, int x, int y, int z)
{
	s->motion[0] = x;
	s->motion[1] = y;
	s->motion[2] = z;
}

void
sprite_setIt(sprite s)
{
	int x, y, z;

	for (x = 0; x < s->myX; x++)
	  for (y = 0; y < s->myY; y++)
	    for (z = 0; z < s->myZ; z++)
	    {
		if (x + s->place[0] > -1 && x + s->place[0] < 8 &&
		    y + s->place[1] > -1 && y + s->place[1] < 8 &&
		    z + s->place[2] > -1 && z + s->place[2] < 8)
		{
			getColor(s->description[z][x][y], s->intensity);
			LED(x + s->place[0],
			    y + s->place[1],
			    s->myZ - 1 - z + s->place[2],
			    myred, mygreen, myblue);
		}
	    }
}

void
sprite_clearIt(sprite s)
{
	int x, y, z;

	for (x = 0; x < s->myX; x++)
	  for (y = 0; y < s->myY; y++)
	    for (z = 0; z < s->myZ; z++)
			LED(x + s->place[0],
			    y + s->place[1],
			    s->myZ - 1 - z + s->place[2],
			    0, 0, 0);
}

void
sprite_moveIt(sprite s)
{
	sprite_clearIt(s);
	s->place[0] += s->motion[0];
	s->place[1] += s->motion[1];
	s->place[2] += s->motion[2];
	sprite_setIt(s);
}

void
sprite_bounceIt(sprite s)
{
	sprite_moveIt(s);
	if (s->place[0] < 1 && s->motion[0] < 0)
		s->motion[0] = -s->motion[0];
	if (s->place[1] < 1 && s->motion[1] < 0)
		s->motion[1] = -s->motion[1];
	if (s->place[2] < 1 && s->motion[2] < 0)
		s->motion[2] = -s->motion[2];
	if (s->place[0] > 7 - s->myX && s->motion[0] > 0)
		s->motion[0] = -s->motion[0];
	if (s->place[1] > 7 - s->myY && s->motion[1] > 0)
		s->motion[1] = -s->motion[1];
	if (s->place[2] > 7 - s->myZ && s->motion[2] > 0)
		s->motion[2] = -s->motion[2];
}

void
sprite_sphere(sprite s, int colour)
{
	float polar;
	float centreX = s->myX / 2;
	float centreY = s->myY / 2;
	float centreZ = s->myZ / 2;
	int x, y, z;

	for (x = 0; x < s->myX; x++)
	{
	  for (y = 0; y < s->myY; y++)
	  {
	    for (z = 0; z < s->myZ; z++)
	    {
		polar = sqrt(
		    (x-centreX)*(x-centreX) +
		    (y-centreY)*(y-centreY) +
		    (z-centreZ)*(z-centreZ)); // Calculate the distance
		if (polar < centreX)
			s->description[x][y][z] = colour;
		else
			s->description[x][y][z] = Black;
	    }
	  }
	}
}

void
sprite_ChgIntensity(sprite s, int i)
{
	s->intensity = i;
}

void
sprite_description(sprite s, byte d[6][6][6])
{
	int x, y, z;

	for (x = 0; x < 6; x++)
	  for (y = 0; y < 6; y++)
	    for (z = 0; z < 6; z++)
		s->description[x][y][z] = d[x][y][z];
}

void
sprite_copyBack(sprite s)
{
	int x, y, z;

	for (x = 0; x < 6; x++)
	  for (y = 0; y < 6; y++)
	    for (z = 0; z < 6; z++)
		s->description[x][y][z] = s->buffer[x][y][z];
}

void
sprite_rollX(sprite s, int dir)
{
	int lock = 0;
	if (dir == 0)
	{
		if (s->motion[0] == 0 && s->motion[1] == 0 && s->motion[2] == -1)
		{
			lock = 1;
			if (s->place[2] < 1)
			{
				s->motion[0] = 0;
				s->motion[1] = -1;
				s->motion[2] = 0;
			}
		}
		if (s->motion[0] == 0 && s->motion[1] == -1 && s->motion[2] == 0)
		{
			lock = 1;
			if (s->place[1] < 1)
			{
				s->motion[0] = 0;
				s->motion[1] = 0;
				s->motion[2] = 1;
			}
		}
		if (s->motion[0] == 0 && s->motion[1] == 0 && s->motion[2] == 1)
		{
			lock = 1;
			if (s->place[2] > 7 - s->myZ)
			{
				s->motion[0] = 0;
				s->motion[1] = 1;
				s->motion[2] = 0;
			}
		}
		if (s->motion[0] == 0 && s->motion[1] == 1 && s->motion[2] == 0)
		{
			lock = 1;
			if (s->place[1] > 7 - s->myY)
			{
				s->motion[0] = 0;
				s->motion[1] = 0;
				s->motion[2] = -1;
			}
		}
		if (lock < 1 && s->place[0] < 7 - s->myZ)
		{
			s->motion[0] = 0;
			s->motion[1] = 0;
			s->motion[2] = -1;
		}
		if (lock < 1 && s->place[0] == 7 - s->myZ)
		{
			s->motion[0] = 0;
			s->motion[1] = -1;
			s->motion[2] = 0;
		}
	}
	else
	{
		if (s->motion[0] == 0 && s->motion[1] == 0 && s->motion[2] == 1)
		{
			lock = 1;
			if (s->place[2] > 7 - s->myZ)
			{
				s->motion[0] = 0;
				s->motion[1] = -1;
				s->motion[2] = 0;
			}
		}
		if (s->motion[0] == 0 && s->motion[1] == 1 && s->motion[2] == 0)
		{
			lock = 1;
			if (s->place[1] > 7 - s->myY)
			{
				s->motion[0] = 0;
				s->motion[1] = 0;
				s->motion[2] = 1;
			}
		}
		if (s->motion[0] == 0 && s->motion[1] == 0 && s->motion[2] == -1)
		{
			lock = 1;
			if (s->place[2] < 1)
			{
				s->motion[0] = 0;
				s->motion[1] = 1;
				s->motion[2] = 0;
			}
		}
		if (s->motion[0] == 0 && s->motion[1] == -1 && s->motion[2] == 0)
		{
			lock = 1;
			if (s->place[1] < 1)
			{
				s->motion[0] = 0;
				s->motion[1] = 0;
				s->motion[2] = -1;
			}
		}
		if (lock < 1 && s->place[2] < 7 - s->myZ)
		{
			s->motion[0] = 0;
			s->motion[1] = 0;
			s->motion[2] = 1;
		}
		if (lock < 1 && s->place[2] == 7 - s->myZ)
		{
			s->motion[0] = 0;
			s->motion[1] = 1;
			s->motion[2] = 0;
		}
	}
	sprite_moveIt(s);
}

void
sprite_rollY(sprite s, int dir)
{
	int lock = 0;
	if (dir == 0)
	{
		if (s->motion[0] == 1 && s->motion[1] == 0 && s->motion[2] == 0)
		{
			lock = 1;
			if (s->place[0] > 7 - s->myX)
			{
				s->motion[0] = 0;
				s->motion[1] = 0;
				s->motion[2] = -1;
			}
		}
		if (s->motion[0] == 0 && s->motion[1] == 0 && s->motion[2] == 1)
		{
			lock = 1;
			if (s->place[2] > 7 - s->myZ)
			{
				s->motion[0] = 1;
				s->motion[1] = 0;
				s->motion[2] = 0;
			}
		}
		if (s->motion[0] == -1 && s->motion[1] == 0 && s->motion[2] == 0)
		{
			lock = 1;
			if (s->place[0] < 1)
			{
				s->motion[0] = 0;
				s->motion[1] = 0;
				s->motion[2] = 1;
			}
		}
		if (s->motion[0] == 0 && s->motion[1] == 0 && s->motion[2] == -1)
		{
			lock = 1;
			if (s->place[2] < 1)
			{
				s->motion[0] = -1;
				s->motion[1] = 0;
				s->motion[2] = 0;
			}
		}
		if (lock < 1 && s->place[0] < 7 - s->myX)
		{		// used to be >1 which I think is a mistake  Changed to be consistent
			s->motion[0] = -1;
			s->motion[1] = 0;
			s->motion[2] = 0;
		}
		if (lock < 1 && s->place[0] == 7 - s->myX)
		{		// used to be ==0
			s->motion[0] = 0;
			s->motion[1] = 0;
			s->motion[2] = -1;
		}
	}
	else
	{
		if (s->motion[0] == 1 && s->motion[1] == 0 && s->motion[2] == 0)
		{
			lock = 1;
			if (s->place[0] > 7 - s->myX)
			{
				s->motion[0] = 0;
				s->motion[1] = 0;
				s->motion[2] = 1;
			}
		}
		if (s->motion[0] == 0 && s->motion[1] == 0 && s->motion[2] == 1)
		{
			lock = 1;
			if (s->place[2] > 7 - s->myZ)
			{
				s->motion[0] = -1;
				s->motion[1] = 0;
				s->motion[2] = 0;
			}
		}
		if (s->motion[0] == -1 && s->motion[1] == 0 && s->motion[2] == 0)
		{
			lock = 1;
			if (s->place[0] < 1)
			{
				s->motion[0] = 0;
				s->motion[1] = 0;
				s->motion[2] = -1;
			}
		}
		if (s->motion[0] == 0 && s->motion[1] == 0 && s->motion[2] == -1)
		{
			lock = 1;
			if (s->place[2] < 1)
			{
				s->motion[0] = 1;
				s->motion[1] = 0;
				s->motion[2] = 0;
			}
		}
		if (lock < 1 && s->place[0] < 7 - s->myX)
		{
			s->motion[0] = 1;
			s->motion[1] = 0;
			s->motion[2] = 0;
		}
		if (lock < 1 && s->place[0] == 7 - s->myX)
		{
			s->motion[0] = 0;
			s->motion[1] = 0;
			s->motion[2] = 1;
		}
	}
	sprite_moveIt(s);
}

void
sprite_rollZ(sprite s, int dir)
{
	int lock = 0;
	if (dir == 0)
	{
		if (s->motion[0] == 1 && s->motion[1] == 0 && s->motion[2] == 0)
		{
			lock = 1;
			if (s->place[0] > 7 - s->myX)
			{
				s->motion[0] = 0;
				s->motion[1] = -1;
				s->motion[2] = 0;
			}
		}
		if (s->motion[0] == 0 && s->motion[1] == 1 && s->motion[2] == 0)
		{
			lock = 1;
			if (s->place[1] > 7 - s->myY)
			{
				s->motion[0] = 1;
				s->motion[1] = 0;
				s->motion[2] = 0;
			}
		}
		if (s->motion[0] == -1 && s->motion[1] == 0 && s->motion[2] == 0)
		{
			lock = 1;
			if (s->place[0] < 1)
			{
				s->motion[0] = 0;
				s->motion[1] = 1;
				s->motion[2] = 0;
			}
		}
		if (s->motion[0] == 0 && s->motion[1] == -1 && s->motion[2] == 0)
		{
			lock = 1;
			if (s->place[1] < 1)
			{
				s->motion[0] = -1;
				s->motion[1] = 0;
				s->motion[2] = 0;
			}
		}
		if (lock < 1 && s->place[0] < 7 - s->myX)
		{
			s->motion[0] = 1;
			s->motion[1] = 0;
			s->motion[2] = 0;
		}
		if (lock < 1 && s->place[0] == 7 - s->myX)
		{
			s->motion[0] = 0;
			s->motion[1] = 1;
			s->motion[2] = 0;
		}
	}
	else
	{
		if (s->motion[0] == -1 && s->motion[1] == 0 && s->motion[2] == 0)
		{
			lock = 1;
			if (s->place[0] < 1)
			{
				s->motion[0] = 0;
				s->motion[1] = -1;
				s->motion[2] = 0;
			}
		}
		if (s->motion[0] == 0 && s->motion[1] == -1 && s->motion[2] == 0)
		{
			lock = 1;
			if (s->place[1] < 1)
			{
				s->motion[0] = 1;
				s->motion[1] = 0;
				s->motion[2] = 0;
			}
		}
		if (s->motion[0] == 1 && s->motion[1] == 0 && s->motion[2] == 0)
		{
			lock = 1;
			if (s->place[0] > 7 - s->myX)
			{
				s->motion[0] = 0;
				s->motion[1] = 1;
				s->motion[2] = 0;
			}
		}
		if (s->motion[0] == 0 && s->motion[1] == 1 && s->motion[2] == 0)
		{
			lock = 1;
			if (s->place[1] > 7 - s->myY)
			{
				s->motion[0] = -1;
				s->motion[1] = 0;
				s->motion[2] = 0;
			}
		}
		if (lock < 1 && s->place[0] < 7 - s->myX)
		{
			s->motion[0] = -1;
			s->motion[1] = 0;
			s->motion[2] = 0;
		}
		if (lock < 1 && s->place[0] == 7 - s->myX)
		{
			s->motion[0] = 0;
			s->motion[1] = -1;
			s->motion[2] = 0;
		}
	}
	sprite_moveIt(s);
}

void
sprite_rotateX(sprite s, int dir)
{
	int x, y, z;

	for (x = 0; x < 6; x++)
	  for (y = 0; y < s->myY; y++)
	    for (z = 0; z < s->myZ; z++)
	    {
		if (dir == 0)
			s->buffer[y][x][s->myZ-1-z] = s->description[z][x][y];
		else
			s->buffer[s->myY-1-y][x][z] = s->description[z][x][y];
	    }
	sprite_copyBack(s);
	sprite_setIt(s);
}

void
sprite_rotateY(sprite s, int dir)
{
	int x, y, z;

	for (x = 0; x < s->myX; x++)
	  for (y = 0; y < 6; y++)
	    for (z = 0; z < s->myZ; z++)
	    {
		if (dir == 0)
			s->buffer[x][s->myZ-1-z][y] = s->description[z][x][y];
		else
			s->buffer[s->myX-1-x][z][y] = s->description[z][x][y];
	    }
	sprite_copyBack(s);
	sprite_setIt(s);
}

void
sprite_rotateZ(sprite s, int dir)
{
	int x, y, z;

	for (x = 0; x < s->myX; x++)
	  for (y = 0; y < s->myY; y++)
	    for (z = 0; z < 6; z++)
	    {
		if (dir == 0)
			s->buffer[z][y][s->myX-1-x] = s->description[z][x][y];
		else
			s->buffer[z][s->myY-1-y][x] = s->description[z][x][y];
	    }
	sprite_copyBack(s);
	sprite_setIt(s);
}

void
sprite_delete(sprite s)
{
	free(s);
}

sprite
sprite_create(int x, int y, int z)
{
	sprite s = malloc(sizeof(*s));

	s->myX = x;
	s->myY = y;
	s->myZ = z;
	s->intensity = 4;

	return s;
}

