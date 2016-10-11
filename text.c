/*
 * This code contains a port of the text management functions from:
 *
 * 8 x 8 x 8 Cube Application Template, Version 7.0  © 2014 by Doug Domke
 * Downloads of this template and upcoming versions, along with detailed
 * instructions, are available at: http://d2-webdesign.com/cube
 *
 * Many of the functions have been rewritten or optimised in the process.
 * 
 */

#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>
#include <errno.h>
#include "cube.h"
#include "tables.h"
#include "text.h"
#include "include/font.h"

// 46 columns (30 around the cube,
//    0-7 are for the character which has just left,
//    37-45 are for a character yet to come on,
// 8 rows
static char text_buffer[46][8];
int scroll_rate = 800;

void
text_getchar(char c, uint8_t (*grid)[8][8][3],
    uint8_t red, uint8_t green, uint8_t blue)
{
	int offset, x, y;

	memset(*grid, '\0', sizeof(*grid));

	if (c < ' ' || c > 127)
		return;

	offset = (c - ' ') * 8;

	// Place the character in the grid.

	for (x = 0; x < 8; x++)
	{
	    for (y = 0; y < 8; y++)
	    {
		if (myfont[offset+x][y])
		{
			(*grid)[x][7-y][RED] = red;
			(*grid)[x][7-y][GREEN] = green;
			(*grid)[x][7-y][BLUE] = blue;
		}
	    }
	}
}

static void
text_scroll_character(uint8_t red, uint8_t green, uint8_t blue, int mode)
{
	int shift, col, row;

	// 8 columns to scroll across for one character.
	for (shift = 0; shift < 8; shift++)
	{
		// Shift the text buffer down by one column.
		for (col = 0; col < 45; col++)
		    for (row = 0; row < 8; row++)
			text_buffer[col][row] = text_buffer[col+1][row];

		// Draw the new walls.
		for (col = 0; col < 8; col++)
		{
		    for (row = 0; row < 8; row++)
		    {
			if (text_buffer[col+22][row])
				LED(7, col, row, red, green, blue);
			if (text_buffer[col+15][row])
				LED(col, 0, row, red, green, blue);
			if (mode == 4)
			{
				if (text_buffer[col+29][row])
					LED(7-col, 7, row, red, green, blue);
				if (text_buffer[col+8][row])
					LED(0, 7-col, row, red, green, blue);
			}
		    }
		}

		delay(scroll_rate / 8);

		// Clear all four walls.
		cube_slice(0, 0, 0, 0, 0);
		cube_slice(7, 0, 0, 0, 0);
		cube_panel(0, 0, 0, 0, 0);
		cube_panel(7, 0, 0, 0, 0);
	}
}

/* This subroutine scrolls text around the outside walls of the cube.
 * You first specify a string of text.
 * Then specify its color as red, green, blue components.
 * Finally specify Mode, which is 2 for scolling on only 2 walls of the
 * or 4 for scrolling on all 4 walls.
 */
static void
text_scroll_walls(char *str, uint8_t red, uint8_t green, uint8_t blue, int mode)
{
	int col, row, count;

	for (; *str; str++)
	{
		// Get font code.
		int offset = (*str - ' ') * 8;
		for (col = 0; col < 8; col++)
		{
			for (row = 0; row < 8; row++)
			{
				if (myfont[offset+col][row])
					text_buffer[col + 37][row] = 1;
			}
		}
		text_scroll_character(red, green, blue, mode);
	}

	// Last character, four walls.
	for (count = 0; count < 4; count++)
		text_scroll_character(red, green, blue, mode);

	delay(1000);

	// Clear the text buffer
	memset(text_buffer, '\0', sizeof(text_buffer));
}

enum textscrolldir {X, Y, Z};

static void
text_scroll_through(char *str, uint8_t red, uint8_t green, uint8_t blue,
    enum textscrolldir dir)
{
	uint8_t grid[8][8][3];
	int x, y, sx, sy, sz;

	sx = sy = sz = 0;
	switch (dir)
	{
	    case X:	sx = 1;  break;
	    case Y:	sy = 1;  break;
	    case Z:	sz = -1; break;
	}

	for (; *str; str++)
	{
		// Place the character in the grid.
		text_getchar(*str, &grid, red, green, blue);

		// Place the character grid on the correct cube face
		// and scroll it through.
		switch (dir)
		{
		    case X:
			cube_plane(0, PLANE_SLICE, 0, &grid);
			break;
		    case Y:
			cube_plane(0, PLANE_PANEL, 0, &grid);
			break;
		    case Z:
			cube_plane(7, PLANE_LAYER, 0, &grid);
			break;
		}

		for (x = 0; x < 5; x++)
		{
			delay(scroll_rate / 8);
			cube_translate(sx, sy, sz);
		}
	}

	// Last character
	for (x = 0; x < 4; x++)
	{
		delay(scroll_rate / 8);
		cube_translate(sx, sy, sz);
	}

	delay(1000);
}

void
text_scroll(char *str, uint8_t red, uint8_t green, uint8_t blue,
    enum textmode mode)
{
	memset(text_buffer, '\0', sizeof(text_buffer));
	switch (mode)
	{
	    case TEXTMODE_TWOWALLS:
		text_scroll_walls(str, red, green, blue, 2);
		break;
	    case TEXTMODE_FOURWALLS:
		text_scroll_walls(str, red, green, blue, 4);
		break;
	    case TEXTMODE_THROUGHX:
		text_scroll_through(str, red, green, blue, X);
		break;
	    case TEXTMODE_THROUGHY:
		text_scroll_through(str, red, green, blue, Y);
		break;
	    case TEXTMODE_THROUGHZ:
		text_scroll_through(str, red, green, blue, Z);
		break;
	}
}

#if 0
void
rotate(char *str, uint8_t red, uint8_t green, uint8_t blue, int num)
{
	int col, row, panel, rotation;

	for (; *str; str++)
	{
		int offset = (*str - ' ') * 8;

		// Populate text buffer
		for (col = 0; col < 46; col++)
		    for (row = 0; row < 8; row++)
			if (myfont[offset+col][row])
				text_buffer[col][row] = 1;
			else
				text_buffer[col][row] = 0;

		for (rotation = 0; rotation < num; rotation++)
		{
			// Display in first position
			for (panel = 0; panel < 8; panel++)
			{
			    for (row = 0; row < 8; row++)
			    {
				if (!text_buffer[panel][row])
					continue;
				LED(3, panel+1, row, red, green, blue);
				LED(4, panel+1, row, red, green, blue);
			    }
			}

			delay(scroll_rate / 4);
			clearCube();

			// Rotate 45 degrees
			for (panel = 0; panel < 7; panel++)
			{
			    float mypanel = 1 + (float)panel / 1.414;
			    int panelx = mypanel;
			    for (row = 0; row < 8; row++)
			    {
				if (!text_buffer[panel][row])
					continue;
				LED(panelx+1, panelx+1, row, red, green, blue);
			    }
			}

			delay(scroll_rate / 4);
			clearCube();

			// Rotate 90 degrees
			for (panel = 0; panel < 7; panel++)
			{
			    for (row = 0; row < 8; row++)
			    {
				if (!text_buffer[panel][row])
					continue;
				LED(panel+1, 3, row, red, green, blue);
				LED(panel+1, 4, row, red, green, blue);
			    }
			}

			delay(scroll_rate / 4);
			clearCube();

			// Rotate 135 degrees
			for (panel = 0; panel < 7; panel++)
			{
			    float mypanel = 1 + (float)panel / 1.414;
			    int panelx = mypanel;
			    for (row = 0; row < 8; row++)
			    {
				if (!text_buffer[panel][row])
					continue;
				LED(panelx+1, 6-panelx, row, red, green, blue);
			    }
			}

			delay(scroll_rate / 4);
			clearCube();

			// Rotate 180 degrees
			for (panel = 0; panel < 7; panel++)
			{
			    for (row = 0; row < 8; row++)
			    {
				if (!text_buffer[panel][row])
					continue;
				LED(3, 6 - panel, row, red, green, blue);
				LED(4, 6 - panel, row, red, green, blue);
			    }
			}

			delay(scroll_rate / 4);
			clearCube();

			// Rotate 225 degrees
			for (panel = 0; panel < 7; panel++)
			{
			    float mypanel = 1 + (float)panel / 1.414;
			    int panelx = mypanel;
			    for (row = 0; row < 8; row++)
			    {
				if (!text_buffer[panel][row])
					continue;
				LED(6-panelx, 6-panelx, row, red, green, blue);
			    }
			}

			delay(scroll_rate / 4);
			clearCube();

			// Rotate 270 degrees
			for (panel = 0; panel < 7; panel++)
			{
			    for (row = 0; row < 8; row++)
			    {
				if (!text_buffer[panel][row])
					continue;
				LED(6-panel, 3, row, red, green, blue);
				LED(6-panel, 4, row, red, green, blue);
			    }
			}

			delay(scroll_rate / 4);
			clearCube();

			// Rotate 315 degrees
			for (panel = 0; panel < 7; panel++)
			{
			    float mypanel = 1 + (float)panel / 1.414;
			    int panelx = mypanel;
			    for (row = 0; row < 8; row++)
			    {
				if (!text_buffer[panel][row])
					continue;
				LED(6-panelx, panelx+1, row, red, green, blue);
			    }
			}

			delay(scroll_rate / 4);
			clearCube();

			// and back in its original position
			for (panel = 0; panel < 8; panel++)
			{
			    for (row = 0; row < 8; row++)
			    {
				if (!text_buffer[panel][row])
					continue;
				LED(3, panel+1, row, red, green, blue);
				LED(4, panel+1, row, red, green, blue);
			    }
			}

			delay(scroll_rate / 4);
			clearCube();
			delay(500);
		}
	}

	// Last character
	delay(1000);
}
#endif

