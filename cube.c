#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>
#include <errno.h>
#include "gpio.h"
#include "cube.h"
#include "tables.h"
#include "util.h"
#include "include/angle.h"
#include "include/diagonal.h"
#include "include/distance.h"
#include "include/sincos.h"

/*  The cube matrix below stores the status of each LED in the cube.
 *  [col 0-7] [panel 0-7] [layer 0-7] [red, green, blue colour components]
 */
static uint8_t cube[8][8][8][3];
static uint8_t buffer_cube[8][8][8][3];
static uint8_t layers[] = {
	GPIO_LAYER0, GPIO_LAYER1, GPIO_LAYER2, GPIO_LAYER3,
	GPIO_LAYER4, GPIO_LAYER5, GPIO_LAYER6, GPIO_LAYER7
};

static pthread_t t_refresh, t_canary;
static uint8_t cube_detected = 0, cube_running = 0;
uint8_t exiting = 0;
#ifdef BENCHMARK
uint16_t cyclems = 0;
#endif

/****************************************************************************
 * Core cube routines.
 */

// Set a specific single LED to a colour.
inline void
LED(int col, int panel, int layer, uint8_t red, uint8_t green, uint8_t blue)
{
	if (col > 7 || col < 0) return;
	if (panel > 7 || panel < 0) return;
	if (layer > 7 || layer < 0) return;

	if (red > 63) red = 63;
	if (green > 63) green = 63;
	if (blue > 63) blue = 63;

	__atomic_store(&cube[col][panel][layer][RED],
	    &red, __ATOMIC_RELAXED);
	__atomic_store(&cube[col][panel][layer][GREEN],
	    &green, __ATOMIC_RELAXED);
	__atomic_store(&cube[col][panel][layer][BLUE],
	    &blue, __ATOMIC_RELAXED);
}

// Set a colour component of a specific LED.
inline void
cLED(int col, int panel, int layer, enum colours colour, uint8_t val)
{
	if (col > 7 || col < 0) return;
	if (panel > 7 || panel < 0) return;
	if (layer > 7 || layer < 0) return;

	if (val > 63) val = 63;

	__atomic_store(&cube[col][panel][layer][colour],
	    &val, __ATOMIC_RELAXED);
}

// Retrieve a colour component of a specific LED.
inline uint8_t
xLED(int col, int panel, int layer, enum colours colour)
{
	uint8_t ret;
	__atomic_load(&cube[col][panel][layer][colour], &ret,
	    __ATOMIC_RELAXED);
	return ret;
}

// Copy the colour of one LED to another.
inline void
copyLED(int fx, int fy, int fz, int tx, int ty, int tz)
{
	// Destination LED off-grid => nop.
	if (tx < 0 || tx > 7 || ty < 0 || ty > 7 || tz < 0 || tz > 7)
		return;

	// Source LED off-grid => blank destination.
	if (fx < 0 || fx > 7 || fy < 0 || fy > 7 || fz < 0 || fz > 7)
		LED(tx, ty, tz, 0, 0, 0);
	else
		LED(tx, ty, tz,
		   xLED(fx, fy, fz, RED),
		   xLED(fx, fy, fz, GREEN),
		   xLED(fx, fy, fz, BLUE));
}

/****************************************************************************
 * Buffer cube routines.
 */

// Copy the current cube to the buffer cube.
void
cube_buffer()
{
	memcpy(buffer_cube, cube, sizeof(cube));
}

// Copy the buffer cube to the current cube (WITHOUT locking)
void
cube_from_buffer()
{
	memcpy(cube, buffer_cube, sizeof(buffer_cube));
}

// Clear the buffer cube.
void
cube_buffer_clear()
{
	memset(buffer_cube, '\0', sizeof(buffer_cube));
}

// Set a specific single bufferLED to a colour.
// Memory barriers are not used since the buffer will only be accessed
// from a single thread.
inline void
buffer_LED(int col, int panel, int layer,
    uint8_t red, uint8_t green, uint8_t blue)
{
	if (col > 7 || col < 0) return;
	if (panel > 7 || panel < 0) return;
	if (layer > 7 || layer < 0) return;

	if (red > 63) red = 63;
	if (green > 63) green = 63;
	if (blue > 63) blue = 63;

	buffer_cube[col][panel][layer][RED] = red;
	buffer_cube[col][panel][layer][GREEN] = green;
	buffer_cube[col][panel][layer][BLUE] = blue;
}

// Set a colour component of a specific LED.
inline void
buffer_cLED(int col, int panel, int layer, enum colours colour, uint8_t val)
{
	if (col > 7 || col < 0) return;
	if (panel > 7 || panel < 0) return;
	if (layer > 7 || layer < 0) return;

	if (val > 63) val = 63;

	buffer_cube[col][panel][layer][colour] = val;
}

// Retrieve a colour component of a specific LED.
inline uint8_t
buffer_xLED(int col, int panel, int layer, enum colours colour)
{
	return buffer_cube[col][panel][layer][colour];
}


// Copy an LED from the buffer to the cube.
inline void
buffer_copyLED(int fx, int fy, int fz, int tx, int ty, int tz)
{
	// Destination LED off-grid => nop.
	if (tx < 0 || tx > 7 || ty < 0 || ty > 7 || tz < 0 || tz > 7)
		return;

	// Source LED off-grid => blank destination.
	if (fx < 0 || fx > 7 || fy < 0 || fy > 7 || fz < 0 || fz > 7)
		LED(tx, ty, tz, 0, 0, 0);
	else
		LED(tx, ty, tz,
		   buffer_cube[fx][fy][fz][RED],
		   buffer_cube[fx][fy][fz][GREEN],
		   buffer_cube[fx][fy][fz][BLUE]);
}

/****************************************************************************
 * Cube routines.
 */

void
cube_colour(int colour, uint8_t *r, uint8_t *g, uint8_t *b, int intensity)
{
	if (colour < 64)
	{
		*g = colour;
		*r = 63 - *g;
		*b = 0;
	}
	else if (colour < 127)
	{
		*b = colour - 63;
		*g = 63 - *b;
		*r = 0;
	}
	else if (colour < 190)
	{
		*r = colour - 127;
		*b = 63 - *r;
		*g = 0;
	}
	else if (colour == 190)
		*r = *g = *b = 63;
	else
		*r = *g = *b = 0;

	while (intensity++ < 5)
	{
		*r >>= 1;
		*g >>= 1;
		*b >>= 1;
	}
}


/****************************************************************************
 * Routines to manage sections of the cube.
 */

// Clear the cube.
void
cube_clear(int buffer)
{
	int panel;
        for (panel = 0; panel < 8; panel++)
                cube_panel(panel, buffer, 0, 0, 0);
}

// Fill the cube
void
cube_fill(int buffer, uint8_t r, uint8_t g, uint8_t b)
{
	int panel;
	for (panel = 0; panel < 8; panel++)
		cube_panel(panel, buffer, r, g, b);
}

// Set an entire row.
void
cube_row(int panel, int layer, int buffer,
    uint8_t red, uint8_t green, uint8_t blue)
{
	int col;
        for (col = 0; col < 8; col++)
		if (buffer)
			buffer_LED(col, panel, layer, red, green, blue);
		else
			LED(col, panel, layer, red, green, blue);
}

// Set an entire column.
void
cube_column(int panel, int col, int buffer,
    uint8_t red, uint8_t green, uint8_t blue)
{
	int layer;
        for (layer = 0; layer < 8; layer++)
		if (buffer)
			buffer_LED(col, panel, layer, red, green, blue);
		else
			LED(col, panel, layer, red, green, blue);
}

// Set an entire panel.
void
cube_panel(int panel, int buffer, uint8_t red, uint8_t green, uint8_t blue)
{
	int col;
        for (col = 0; col < 8; col++)
                cube_column(panel, col, buffer, red, green, blue);
}

// Set an entire layer.
void
cube_layer(int layer, int buffer, uint8_t red, uint8_t green, uint8_t blue)
{
	int panel;
        for (panel = 0; panel < 8; panel++)
                cube_row(panel, layer, buffer, red, green, blue);
}

// Set an entire slice (across the panels).
void
cube_slice(int col, int buffer,  uint8_t red, uint8_t green, uint8_t blue)
{
	int panel;
        for (panel = 0; panel < 8; panel++)
                cube_column(panel, col, buffer, red, green, blue);
}

// Set an entire cube plane based on passed buffer.
void
cube_plane(int index, enum planes plane, int buffer, uint8_t (*buf)[8][8][3])
{
	void (*setled)(int, int, int, uint8_t, uint8_t, uint8_t);
	int x, y, z;

	setled = buffer ? buffer_LED : LED;

	switch (plane)
	{
	    case PLANE_PANEL:
		for (x = 0; x < 8; x++)
		    for (z = 0; z < 8; z++)
			setled(x, index, 7-z,
			    (*buf)[x][z][RED],
			    (*buf)[x][z][GREEN],
			    (*buf)[x][z][BLUE]);
		break;
	    
	    case PLANE_SLICE:
		for (y = 0; y < 8; y++)
		    for (z = 0; z < 8; z++)
			setled(index, y, 7-z,
			    (*buf)[y][z][RED],
			    (*buf)[y][z][GREEN],
			    (*buf)[y][z][BLUE]);
		break;

	    case PLANE_LAYER:
		for (y = 0; y < 8; y++)
		    for (x = 0; x < 8; x++)
			setled(x, 7-y, index,
			    (*buf)[x][y][RED],
			    (*buf)[x][y][GREEN],
			    (*buf)[x][y][BLUE]);
		break;
	}
}

// Translate (shift) the cube contents
void
cube_translate(int x, int y, int z)
{
        int column, panel, layer;

	// X axis - across the columns
	if (x)
	{
	  cube_buffer();
	  for (column = 0; column < 8; column++)
	    for (panel = 0; panel < 8; panel++)
	      for (layer = 0; layer < 8; layer++)
		buffer_copyLED(column - x, panel, layer, column, panel, layer);
	}

	// Y axis - across the panels
	if (y)
	{
	  cube_buffer();
	  for (column = 0; column < 8; column++)
	    for (panel = 0; panel < 8; panel++)
	      for (layer = 0; layer < 8; layer++)
		buffer_copyLED(column, panel - y, layer, column, panel, layer);
	}

	// Z axis - up the layers
	if (z)
	{
	  cube_buffer();
	  for (column = 0; column < 8; column++)
	    for (panel = 0; panel < 8; panel++)
	      for (layer = 0; layer < 8; layer++)
		buffer_copyLED(column, panel, layer - z, column, panel, layer);
	}
}

// Rotate a cube layer
// Straight port of Doug Domke's code using his lookup tables.
static void
cube_rotate_layer(float a, int layer)
{
	int column, panel;

	cube_layer(layer, 0, 0, 0, 0);

	for (column = 0; column < 8; column++)
	{
	    for (panel = 0; panel < 8; panel++)
	    {
		float d = distance[column][panel];
		float newangle = angle[column][panel] + a;
		int anglelookup, newcolumn, newpanel;

		if (newangle > 6.28318)
			newangle -= 6.28318;

		anglelookup = newangle * 20 + .5;
		newcolumn = 4 + sin_cos[anglelookup][0] * d;
		newpanel = 4 + sin_cos[anglelookup][1] * d;

		buffer_copyLED(column, panel, layer,
		    newcolumn, newpanel, layer);
	    }
	}
}

// Rotate the cube through a specified angle.
void
cube_rotate(float angle, int use_existing_buffer)
{
	int layer;

	if (!use_existing_buffer)
		cube_buffer();

	for (layer = 0; layer < 8; layer++)
		cube_rotate_layer(angle, layer);
}


/****************************************************************************
 * Cube initialisation and refresh.
 */

// Initialise the cube and GPIO interface.
int
cube_init()
{
	int i;

	if (gpioInitialise())
		return 0;

	cube_detected = 1;

	// Initialise the cube data.
	cube_clear(0);

	// Set PIN modes.
	gpioSetMode(GPIO_CLOCK,  PI_OUTPUT);
	gpioSetMode(GPIO_LATCH,  PI_OUTPUT);
	gpioSetMode(GPIO_RED,    PI_OUTPUT);
	gpioSetMode(GPIO_GREEN,  PI_OUTPUT);
	gpioSetMode(GPIO_BLUE,   PI_OUTPUT);
	gpioSetMode(GPIO_LAYER0, PI_OUTPUT);
	gpioSetMode(GPIO_LAYER1, PI_OUTPUT);
	gpioSetMode(GPIO_LAYER2, PI_OUTPUT);
	gpioSetMode(GPIO_LAYER3, PI_OUTPUT);
	gpioSetMode(GPIO_LAYER4, PI_OUTPUT);
	gpioSetMode(GPIO_LAYER5, PI_OUTPUT);
	gpioSetMode(GPIO_LAYER6, PI_OUTPUT);
	gpioSetMode(GPIO_LAYER7, PI_OUTPUT);

	gpioWrite(GPIO_LATCH, LOW);
	gpioWrite(GPIO_CLOCK, LOW);

	cube_off();

	return 1;
}

// Turn the cube off. Used when an error occurs or the program crashes.
void
cube_off(void)
{
	int i;

	// Set all layer pins to high.
	for (i = 0; i < 8; i++)
		gpioWrite(layers[i], HIGH);
}

// The cube refresh thread.
//
// In one pass it cycles through the layers 6 times setting the LED columns
// and then turning each layer on for a short time. The layer on-time doubles
// with each pass, starting at 10us and ending at 320us. An LED column is
// enabled if the right bit for that pass is set in its brightness value;
// this is 6-bit bit-angle-moduluation (BAM).
//
// Theoretical cycle time is:
//	<layers> * (<sum of on times> + <time to set columns>)
// 8 * (10us + 20us + 40us + 80us + 160us + 320us + ?) = 5ms + ?
//
// On a Raspberry Pi 1, revision 1, ? is around 3ms resulting in a cycle
// time of around 8ms. On newer models this is lower so there is a delay at
// then end of the pass to wait until 8ms after the pass start. A brighter
// cube can be obtained on newer models by reducing or removing this delay.
static void *
cube_refresh(void *x)
{
	struct timespec tp, ns;
	int layer, col, panel, bam;
	uint8_t red, green, blue;
	const uint8_t true = 1;
	uint8_t ex;
	uint16_t elapsedms;

	for (;;)
	{
		clock_gettime(CLOCK_REALTIME, &tp);

		// Check if the program is exiting.
		__atomic_load(&exiting, &ex, __ATOMIC_RELAXED);
		if (ex)
			break;
		
		// Make the canary sing.
		__atomic_store(&canary, &true, __ATOMIC_RELAXED);
		
		for (bam = 1; bam < 0x40; bam <<= 1)
		{
			for (layer = 0; layer < 8; layer++)
			{
			    for (col = 0; col < 8; col++)
			    {
				for (panel = 7; panel >= 0; panel--)
				{
					red = xLED(col, panel, layer, RED);
					green = xLED(col, panel, layer, GREEN);
					blue = xLED(col, panel, layer, BLUE);

					gpioWrite(GPIO_RED,
					    (red & bam) ? HIGH : LOW);
					gpioWrite(GPIO_GREEN,
					    (green & bam) ? HIGH : LOW);
					gpioWrite(GPIO_BLUE,
					    (blue & bam) ? HIGH : LOW);
					// Clock the bits in.
					gpioToggleHigh(GPIO_CLOCK);
				}
			    }

			    // Latch the data in.
			    gpioToggleHigh(GPIO_LATCH);

			    // Turn the layer on for the BAM interval.
			    // Starts at 10us and ends at 320us.
			    gpioWrite(layers[layer], LOW);

			    clock_gettime(CLOCK_REALTIME, &ns);
			    ns.tv_nsec += bam * 10 * 1000;
			    while (ns.tv_nsec >= NSEC_PER_SEC)
			    {
				ns.tv_nsec -= NSEC_PER_SEC;
				ns.tv_sec++;
			    }
			    clock_nanosleep(CLOCK_REALTIME, TIMER_ABSTIME,
				&ns, NULL);

			    gpioWrite(layers[layer], HIGH);
			}
		}

#ifdef BENCHMARK
		clock_gettime(CLOCK_REALTIME, &ns);

		elapsedms = (ns.tv_sec - tp.tv_sec) * MSEC_PER_SEC +
		    (ns.tv_nsec - tp.tv_nsec) / 1000000;
		__atomic_store(&cyclems, &elapsedms, __ATOMIC_RELAXED);
#endif

		// Delay until 8ms after this run started.
		tp.tv_nsec += 8000000;
		// Handle overflow.
		while (tp.tv_nsec >= NSEC_PER_SEC)
		{
			tp.tv_nsec -= NSEC_PER_SEC;
			tp.tv_sec++;
		}
		clock_nanosleep(CLOCK_REALTIME, TIMER_ABSTIME, &tp, NULL);
	}
}

void
cube_load_layer(int layer)
{
	uint8_t red, green, blue;
	int col, panel;

	if (cube_running)
	{
		fprintf(stderr, "Cube already running.\n");
		return;
	}
	if (!cube_detected)
	{
		fprintf(stderr, "No cube detected.\n");
		return;
	}

	for (col = 0; col < 8; col++)
	{
		for (panel = 7; panel >= 0; panel--)
		{
			red = xLED(col, panel, layer, RED);
			green = xLED(col, panel, layer, GREEN);
			blue = xLED(col, panel, layer, BLUE);

			gpioWrite(GPIO_RED, red ? HIGH : LOW);
			gpioWrite(GPIO_GREEN, green ? HIGH : LOW);
			gpioWrite(GPIO_BLUE, blue ? HIGH : LOW);
			// Clock the bits in.
			gpioWrite(GPIO_CLOCK, HIGH);
			gpioWrite(GPIO_CLOCK, LOW);
		}
	}

	// Latch the data in.
	gpioWrite(GPIO_LATCH, HIGH);
	gpioWrite(GPIO_LATCH, LOW);
}

void
cube_stop()
{
	const uint8_t true = 1;

	if (!cube_running)
	{
		fprintf(stderr, "Cube not running.\n");
		return;
	}

	cube_running = 0;

	// Setting the global exiting variable to true will cause the
	// refresh and canary threads to exit.
	__atomic_store(&exiting, &true, __ATOMIC_RELAXED);

	pthread_join(t_refresh, NULL);

	// The refresh thread has exited. Turn the cube off and
	// wait for the canary.
	cube_off();
	pthread_join(t_canary, NULL);
}

void
cube_start()
{
	const uint8_t false = 0;

	if (cube_running)
	{
		fprintf(stderr, "Cube already running.\n");
		return;
	}
	if (!cube_detected)
	{
		fprintf(stderr, "No cube detected.\n");
		return;
	}

	cube_running = 1;
	__atomic_store(&exiting, &false, __ATOMIC_RELAXED);
	start_thread(80, &t_refresh, cube_refresh);
	start_thread(99, &t_canary, canary_thread);
}

void
cube_layer_control(int layer, int mode)
{
	if (layer < 0 || layer > 7)
		return;

	if (!cube_detected)
	{
		fprintf(stderr, "No cube detected.\n");
		return;
	}

	gpioWrite(layers[layer], mode ? LOW : HIGH);
}

