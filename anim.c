#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>
#include <math.h>
#include "cube.h"
#include "tables.h"
#include "sprite.h"
#include "util.h"
#include "jim.h"

/*
 * This code contains a port of the utility functions from:
 *
 * 8 x 8 x 8 Cube Application Template, Version 7.0  © 2014 by Doug Domke
 * Downloads of this template and upcoming versions, along with detailed
 * instructions, are available at: http://d2-webdesign.com/cube
 *
 * Specifically the x_Subroutines and z_Behind_the_Scenes tabs.
 *
 * Many of the functions have been rewritten or optimised in the process.
 */

uint8_t myred, myblue, mygreen, mycolor;

/*
 * ChipKit code compatible version of cube_colour (complete with US spelling)
 * that uses global variables for the result.
 * Convert intensities 0-4 to 0-5
 */
#define getColor(c, i) cube_colour((c), &myred, &mygreen, &myblue, (i) + 1)

#define clearCube() cube_clear(0)
#define fillCube() cube_fill(0)
#define clearBufferCube cube_buffer_clear
#define rotateAll(a) cube_rotate((a), 1)

static void
chgColor(int amt)
{
	mycolor += amt;
	if (mycolor > 189)
		mycolor = 0;
}

static void
rnd_std_color()
{
	switch (random() % 8)
	{
	    case 0: getColor(Red, 4); break;
	    case 1: getColor(Yellow, 4); break;
	    case 2: getColor(Green, 4); break;
	    case 3: getColor(Blue, 4); break;
	    case 4: getColor(Purple, 4); break;
	    case 5: getColor(Violet, 4); break;
	    case 6: getColor(Orange, 4); break;
	    case 7: getColor(Aqua, 4); break;
	    default: getColor(Black, 0); break;
	}
}

// make a "wall" at position X, Y high
static void
wall(int x, int y, uint8_t r, uint8_t g, uint8_t b)
{
	int w, z;

	for (z = 0; z < y; z++)
		for (w = 0; w < 8; w++)
			LED(w, x, z, r, g, b);
}

//draw a pillar at x,y with height z, colour R,G,B
static void
fourSquare(int x, int y, int z, uint8_t r, uint8_t g, uint8_t b)
{
	int xx, yy, zz;

	if (z <= 0)
		return;

	if (x > 4) x = 4;
	if (y > 4) y = 4;
	if (r > 64) r = 63;
	if (g > 63) g = 63;
	if (b > 63) b = 63;

	for (zz = 0; zz < z; zz++)
	    for (xx = 0; xx < 4; xx++)
		for (yy = 0; yy < 4; yy++)
			LED(x+xx, y+yy, zz, r, g, b);
}

static void
fourSquare2(int x, int y, int z, uint8_t r, uint8_t g, uint8_t b)
{
	int xx, yy;

	if (x > 4) x = 4;
	if (y > 4) y = 4;
	if (r > 64) r = 63;
	if (g > 63) g = 63;
	if (b > 63) b = 63;

	for (xx = 0; xx < 4; xx++)
	    for (yy = 0; yy < 4; yy++)
		LED(x+xx, y+yy, z-1, r, g, b);
}

static void
twoSquare(int x, int y, int z, uint8_t r, uint8_t g, uint8_t b)
{
	int xx, yy, zz;

	if (z <= 0)
		return;

	if (x > 4) x = 4;
	if (y > 4) y = 4;
	if (r > 64) r = 63;
	if (g > 63) g = 63;
	if (b > 63) b = 63;

	for (zz = 0; zz < z; zz++)
	    for (xx = 0; xx < 2; xx++)
		for (yy = 0; yy < 2; yy++)
			LED(x+xx, y+yy, zz, r, g, b);
}

static void
xback(int times)
{
	cube_translate(-times, 0, 0);
}

static void
zdown(int times)
{
	cube_translate(0, 0, -times);
}

static void
elasticPlane(int pwidth, int pheight, uint8_t r, uint8_t g, uint8_t b)
{
	int xx, yy;

	for (xx = 4-pwidth; xx < 4+pwidth; xx++)
	    for (yy = 4-pwidth; yy < 4+pwidth; yy++)
		LED(xx, yy, pheight, r, g, b);
}

static void
elasticPlane2(int pwidth, int pheight, uint8_t r, uint8_t g, uint8_t b)
{
	int xx, yy;

	for (xx = 0; xx < 8; xx++)
	    for (yy = 0; yy < 8; yy++)
		if (distance[xx][yy] < pwidth)
			LED(xx, yy, pheight, r, g, b);
}

static void
rotateCube(int times, int stepAngle)
{
	float rotation = stepAngle * .0174532; // convert to radians
	int steps = ((6.28318/abs(rotation))*times)+1;
	float myangle = 0;
	int x;

	for (x = 0; x < steps; x++)
	{
		myangle += rotation;

		if (rotation > 0 && myangle > 6.28318)
			myangle = 0;
		if (rotation < 0 && myangle <= 0)
			myangle = 6.28318;
		cube_rotate(myangle, 1);
	}
	cube_clear(0);
}

/*
 * Include animations from the anim/ directory.
 * These are taken from 
 *
 * 8 x 8 x 8 Cube Application Template, Version 7.0  © 2014 by Doug Domke
 * Downloads of this template and upcoming versions, along with detailed
 * instructions, are available at: http://d2-webdesign.com/cube
 *
 * Wherever possible the animation code is untouched from the original
 * ChipKit version but any local modifications required to support the Pi
 * cube software are bracketed within #ifdef PICUBE
 */

#include "include/atom.h"

#include "anim/common.pde"
#include "anim.h"

#if 0
// Original Big Show.
#include "anim/Mysterious.pde"
#include "anim/DiamondWave.pde"
#include "anim/RandomFall.pde"
#include "anim/Elevators.pde"
#include "anim/GlitterRibbon.pde"
#include "anim/Hula.pde"
#include "anim/Sparkle.pde"
#include "anim/Chaos.pde"
#include "anim/PulsingSphere.pde"
#include "anim/SineWave.pde"
#include "anim/Cyclone.pde"
#include "anim/Rain.pde"
#include "anim/WildMouse.pde"
#include "anim/Fireworks.pde"
#include "anim/Donut.pde"
#include "anim/Tornado.pde"
#include "anim/Rotor.pde"
#include "anim/RandomRotation.pde"
#include "anim/GameOfLife.pde"
#include "anim/CubeInCube.pde"
#include "anim/Cosine.pde"
#include "anim/RollingBall.pde"
#include "anim/TheOrnament.pde"
#include "anim/Eyes.pde"
#include "anim/FlyingBoxes.pde"
#include "anim/MultiSwirl.pde"
#include "anim/SingleSwirl.pde"
#include "anim/BasketballDribble.pde"
#include "anim/FlipAndRoll.pde"
#include "anim/Helicopter.pde"

// Another Big Show.
#include "anim/Angled.pde"
#include "anim/Angled2.pde"
#include "anim/Atom.pde"
#include "anim/AtomSmasher.pde"
#include "anim/Colors.pde"
#include "anim/Dish.pde"
#include "anim/Grower.pde"
#include "anim/MazeMice.pde"
#include "anim/Neutrinos.pde"
#include "anim/Paddles.pde"
#include "anim/RandomLights.pde"
#include "anim/Saddle.pde"
#include "anim/Saddle2.pde"
#include "anim/Swings.pde"
#include "anim/WhatThe.pde"
#include "anim/MiniCubes.pde"
#include "anim/Bouncer.pde"

// Super Big Show
#include "anim/Fireworks2.pde"
#endif

struct anim anims[] = {
 {
	.name = "angled2",
	.args = 0,
	.func = angled2,
},
{
	.name = "angled",
	.args = 0,
	.func = angled,
},
{
	.name = "atom",
	.args = 0,
	.func = atom,
},
{
	.name = "atomSmasher",
	.args = 0,
	.func = atomSmasher,
},
{
	.name = "basketballDribble",
	.args = 0,
	.func = Basketball_Dribble,
},
{
	.name = "bouncer",
	.args = 0,
	.func = bouncer,
},
{
	.name = "chaos",
	.args = 0,
	.func = Chaos,
},
{
	.name = "colors",
	.args = 0,
	.func = colors,
},
{
	.name = "cosine",
	.args = 1,
	.func = Cosine,
	.descr = "<repeat>",
},
{
	.name = "cubeInCube",
	.args = 0,
	.func = CubeInCube,
},
{
	.name = "cyclone",
	.args = 0,
	.func = Cyclone,
},
{
	.name = "diamondWave",
	.args = 0,
	.func = DiamondWave,
},
{
	.name = "dish",
	.args = 0,
	.func= dish,
},
{
	.name = "donut",
	.args = 1,
	.func = Donut,
	.descr = "<number of repetitions>",
},
{
	.name = "elevators",
	.args = 0,
	.func = Elevators,
},
{
	.name = "eyes",
	.args = 0,
	.func = Eyes,
},
{
	.name = "fireworks2",
	.args = 3,
	.func = fireworks2,
	.descr = "<iterations> <number of particles> <delay>",
},
{
	.name = "fireworks",
	.args = 0,
	.func = Fireworks,
},
{
	.name = "flipAndRoll",
	.args = 0,
	.func = Flip_and_Roll,
},
{
	.name = "flyingBoxes",
	.args = 0,
	.func = FlyingBoxes,
},
{
	.name = "gameOfLife",
	.args = 0,
	.func = GameOfLife,
},
{
	.name = "glitterRibbon",
	.args = 0,
	.func = Glitter_ribbon,
},
{
	.name = "grower",
	.args = 0,
	.func = grower,
},
{
	.name = "helicopter",
	.args = 0,
	.func = Helicopter,
},
{
	.name = "Hula",
	.args = 0,
	.func = Hula,
},
{
	.name = "mazeMice",
	.args = 0,
	.func = mazemice,
},
{
	.name = "miniCubes",
	.args = 0,
	.func = miniCubes,
},
{
	.name = "multiSwirl",
	.args = 0,
	.func = Multi_Swirl,
},
{
	.name = "mysterious",
	.args = 0,
	.func = Mysterious,
},
{
	.name = "neutrinos",
	.args = 0,
	.func = neutrinos,
},
{
	.name = "paddles",
	.args = 0,
	.func = paddles,
},
{
	.name = "pulsingSphere",
	.args = 1,
	.func = Pulsing_Sphere,
	.descr = "<repeat>",
},
{
	.name = "rain",
	.args = 1,
	.func = Rain,
	.descr = "<times>",
},
{
	.name = "randomFall",
	.args = 0,
	.func = RandomFall,
},
{
	.name = "randomLights",
	.args = 0,
	.func = randomLights
},
{
	.name = "randomRotation",
	.args = 1,
	.func = RandomRotation,
	.descr = "<speed>",
},
{
	.name = "rollingBall",
	.args = 0,
	.func = RollingBall,
},
{
	.name = "rotor",
	.args = 2,
	.func = Rotor,
	.descr = "<reps> <speed>",
},
{
	.name = "saddle",
	.args = 0,
	.func = saddle,
},
{
	.name = "saddle2",
	.args = 0,
	.func = saddle2,
},
{
	.name = "sinewave",
	.args = 1,
	.func = Sinewave,
	.descr = "<repeat>",
},
{
	.name = "singleSwirl",
	.args = 0,
	.func = Single_Swirl,
},
{
	.name = "sparkle",
	.args = 0,
	.func = Sparkle,
},
{
	.name = "swings",
	.args = 0,
	.func = swings,
},
{
	.name = "theOrnament",
	.args = 0,
	.func = TheOrnament,
},
{
	.name = "tornado",
	.args = 0,
	.func = Tornado,
},
{
	.name = "whatThe",
	.args = 0,
	.func = whatThe,
},
{
	.name = "wildMouse",
	.args = 0,
	.func = Mouse1,
},
{
	.name = NULL,
}
};

