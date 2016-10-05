#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <stdint.h>
#include "jimtcl/jim.h"
#include "cube.h"
#include "text.h"
#include "tables.h"
#include "jim.h"
#include "util.h"
#include "help.h"

#define COLOUR_VARIABLE "cube.pencolour"
extern int scroll_rate;

static int transaction = 0;

/*
 * Interface to delay() function implemented using nanosleep.
 * In many cases, Jim's native sleep will suffice but this is more accurate.
 */
static int
jim_delay(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	long msec;

	if (argc != 2)
	{
		Jim_WrongNumArgs(j, 1, argv, "milliseconds");
		return JIM_ERR;
	}

	Jim_GetLong(j, argv[1], &msec);
	delay(msec);
	return JIM_OK;
}

/*
 * Interface to animations ported across from Doug Domke's Super Big
 * Show - see http://d2-webdesign.com/cube
 *
 * Individual animation files are in the anim/ directory.
 */

extern struct anim anims[];

static int
jim_cube_anim(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	const char *cmd;
	int i;

	if (argc == 1)
	{
		/* Display list of animations. */
		printf("Available animations:\n");
		for (i = 0; anims[i].name; i++)
		{
			printf("  %s %s\n", anims[i].name,
			    anims[i].descr ? anims[i].descr : "");
		}
		return JIM_OK;
	}

	cmd = Jim_GetString(argv[1], NULL);

	for (i = 0; anims[i].name; i++)
	{
		if (!strcasecmp(anims[i].name, cmd))
		{
			if (argc != anims[i].args + 2)
			{
				char msg[0x100];

				sprintf(msg, "%s %s", anims[i].name,
				    anims[i].descr ? anims[i].descr : "");
				Jim_WrongNumArgs(j, 1, argv, msg);
				return JIM_ERR;
			}
			switch (anims[i].args)
			{
			    case 0:
			    {
				void (*func)(void) = anims[i].func;
				func();
				return JIM_OK;
			    }
			    case 1:
			    {
				long arg;

				Jim_GetLong(j, argv[2], &arg);
				void (*func)(int) = anims[i].func;
				func(arg);
				return JIM_OK;
			    }
			    case 2:
			    {
				long arg1, arg2;

				Jim_GetLong(j, argv[2], &arg1);
				Jim_GetLong(j, argv[3], &arg2);
				void (*func)(int, int) = anims[i].func;
				func(arg1, arg2);
				return JIM_OK;
			    }
			    case 3:
			    {
				long arg1, arg2, arg3;

				Jim_GetLong(j, argv[2], &arg1);
				Jim_GetLong(j, argv[3], &arg2);
				Jim_GetLong(j, argv[4], &arg3);
				void (*func)(int, int, int) = anims[i].func;
				func(arg1, arg2, arg3);
				return JIM_OK;
			    }
			    default:
				Jim_SetResultString(j,
				    "unhandled number of arguments", -1);
				return JIM_ERR;
			}
		}
	}
	Jim_SetResultString(j, "unknown animation", -1);
	return JIM_ERR;
}

void
JimSetArgv(Jim_Interp *jim, int argc, char *const argv[])
{
	int n;
	Jim_Obj *listObj = Jim_NewListObj(jim, NULL, 0);

	for (n = 0; n < argc; n++)
	{
		Jim_Obj *obj = Jim_NewStringObj(jim, argv[n], -1);
		Jim_ListAppendElement(jim, listObj, obj);
	}

	Jim_SetVariableStr(jim, "argv", listObj);
	Jim_SetVariableStr(jim, "argc", Jim_NewIntObj(jim, argc));
}

static void
jim_load_colour(Jim_Interp *jim, long *red, long *green, long *blue)
{
	Jim_Obj *colours = Jim_GetGlobalVariableStr(jim,
	    COLOUR_VARIABLE, JIM_ERRMSG);
	Jim_Obj *colour;

	*red = *green = *blue = 0;

	if (!colours)
		return;

	if (Jim_ListIndex(jim, colours, 0, &colour, JIM_ERRMSG) == JIM_OK)
		Jim_GetLong(jim, colour, red);
	if (Jim_ListIndex(jim, colours, 1, &colour, JIM_ERRMSG) == JIM_OK)
		Jim_GetLong(jim, colour, green);
	if (Jim_ListIndex(jim, colours, 2, &colour, JIM_ERRMSG) == JIM_OK)
		Jim_GetLong(jim, colour, blue);
}

#define HANDLE_COLOUR(args) \
    long red, green, blue; \
    do { \
	if (argc == args) \
	{ \
		Jim_GetLong(j, argv[args - 3], &red); \
		Jim_GetLong(j, argv[args - 2], &green); \
		Jim_GetLong(j, argv[args - 1], &blue); \
		if (red > 63) red = 63; \
		if (green > 63) green = 63; \
		if (blue > 63) blue = 63; \
	} \
	else \
	{ \
		red = green = blue = 0; \
		jim_load_colour(j, &red, &green, &blue); \
	} \
    } while (0)

#define NOARGS \
    do { \
	if (argc != 1) \
	{ \
		Jim_WrongNumArgs(j, 1, argv, ""); \
		return JIM_ERR; \
	} \
    } while (0)


#undef SYNTAX
#define SYNTAX "[-get] [-intensity n] [<colour number> | <colour name> | <red green blue>]"
static int
jim_cube_colour(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	Jim_Obj *colour;
	const char *arg;
	long intensity = 5;
	int set = 1;

	if (argc == 2 && Jim_CompareStringImmediate(j, argv[1], "-commands"))
	{
		Jim_SetResultString(j, "-get -intensity", -1);
		return JIM_OK;
	}

	if (argc > 2)
	{
		arg = Jim_GetString(argv[1], NULL);

		if (!strcmp(arg, "-get"))
		{
			set = 0;
			argc -= 1, argv += 1;
		}
	}

	if (argc > 3)
	{
		arg = Jim_GetString(argv[1], NULL);

		if (!strncmp(arg, "-int", 4))
		{
			Jim_GetLong(j, argv[2], &intensity);
			argc -= 2, argv += 2;
		}
	}

	if (argc != 1 && argc != 2 && argc != 4)
	{
		Jim_WrongNumArgs(j, 1, argv, SYNTAX);
		return JIM_ERR;
	}

	if (intensity < 1 || intensity > 5)
	{
		Jim_SetResultString(j, "Bad colour intensity.", -1);
		return JIM_ERR;
	}

	HANDLE_COLOUR(4);

	if (argc == 2)
	{
		const char *cname;
		uint8_t r, g, b;
		jim_wide c;

		cname = Jim_GetString(argv[1], NULL);

		if (!cname)
		{
			Jim_WrongNumArgs(j, 1, argv, SYNTAX);
			return JIM_ERR;
		}

		if (Jim_StringToWide(cname, &c, 0) != JIM_OK)
		{
			if (!strcasecmp(cname, "red"))
				c = Red;
			else if (!strcasecmp(cname, "green"))
				c = Green;
			else if (!strcasecmp(cname, "blue"))
				c = Blue;
			else if (!strcasecmp(cname, "black"))
				c = Black;
			else if (!strcasecmp(cname, "white"))
				c = White;
			else if (!strcasecmp(cname, "orange"))
				c = Orange;
			else if (!strcasecmp(cname, "yellow"))
				c = Yellow;
			else if (!strcasecmp(cname, "aqua"))
				c = Aqua;
			else if (!strcasecmp(cname, "violet"))
				c = Violet;
			else if (!strcasecmp(cname, "purple"))
				c = Purple;
			else
			{
				Jim_SetResultString(j, "unknown colour", -1);
				return JIM_ERR;
			}
		}
		cube_colour(c, &r, &g, &b, intensity);
		red = r, green = g, blue = b;
		// The colour will be set as well as returned.
		argc = 4;
	}
	else while (intensity++ < 5)
	{
		red >>= 1;
		green >>= 1;
		blue >>= 1;
	}

	colour = Jim_NewListObj(j, NULL, 0);
	Jim_ListAppendElement(j, colour, Jim_NewIntObj(j, red));
	Jim_ListAppendElement(j, colour, Jim_NewIntObj(j, green));
	Jim_ListAppendElement(j, colour, Jim_NewIntObj(j, blue));

	if (set && argc == 4)
		Jim_SetGlobalVariableStr(j, COLOUR_VARIABLE, colour);
	
	Jim_SetResult(j, colour);
	return JIM_OK;
}

static int
jim_cube_begin(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	const char *arg;

	if (argc == 2 && Jim_CompareStringImmediate(j, argv[1], "-commands"))
	{
		Jim_SetResultString(j, "-copy -preserve", -1);
		return JIM_OK;
	}

	if (argc > 2)
	{
		Jim_WrongNumArgs(j, 1, argv, "[-copy|-preserve]");
		return JIM_ERR;
	}

	if (transaction)
	{
		Jim_SetResultString(j,
		    "Cube transaction already in progress.\n", -1);
		return JIM_ERR;
	}

	if (argc == 1)
		cube_buffer_clear();
	else
	{
		arg = Jim_GetString(argv[1], NULL);
		if (!strcmp(arg, "-copy"))
			cube_buffer();
		else if (!strcmp(arg, "-preserve"))
			;
		else
		{
			Jim_WrongNumArgs(j, 1, argv, "[-copy|-preserve]");
			return JIM_ERR;
		}
	}

	transaction = 1;

	return JIM_OK;
}

static int
jim_cube_commit(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	const char *arg;
	int copy = 1;

	if (argc == 2 && Jim_CompareStringImmediate(j, argv[1], "-commands"))
	{
		Jim_SetResultString(j, "-nocopy", -1);
		return JIM_OK;
	}

	if (argc != 1 && argc != 2)
	{
		Jim_WrongNumArgs(j, 1, argv, "[-nocopy]");
		return JIM_ERR;
	}

	if (argc == 2)
	{
		arg = Jim_GetString(argv[1], NULL);

		if (!strcmp(arg, "-nocopy"))
			copy = 0;
		else
		{
			Jim_WrongNumArgs(j, 1, argv, "[-nocopy]");
			return JIM_ERR;
		}
	}

	if (!transaction)
	{
		Jim_SetResultString(j,
		    "No cube transaction in progress.\n", -1);
		return JIM_ERR;
	}

	if (copy)
		cube_from_buffer();
	transaction = 0;

	return JIM_OK;
}

static int
jim_cube_scrollrate(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	Jim_Obj *colour;

	if (argc > 2)
	{
		Jim_WrongNumArgs(j, 1, argv, "[<scroll rate>]");
		return JIM_ERR;
	}

	if (argc == 2)
	{
		long c;

		Jim_GetLong(j, argv[1], &c);

		scroll_rate = c;
	}
	Jim_SetResult(j, Jim_NewIntObj(j, scroll_rate));
	return JIM_OK;
}

static int
jim_cube_get(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	Jim_Obj *cube, *x, *y, *z;
	int p, l, c;

	NOARGS;

	cube = Jim_NewListObj(j, NULL, 0);

	for (c = 0; c < 8; c++)
	{
		z = Jim_NewListObj(j, NULL, 0);
		for (p = 0; p < 8; p++)
		{
			y = Jim_NewListObj(j, NULL, 0);
			for (l = 0; l < 8; l++)
			{
				Jim_Obj *led = Jim_NewListObj(j, NULL, 0);

				Jim_ListAppendElement(j, led,
				    Jim_NewIntObj(j, xLED(c, p, l, RED)));
				Jim_ListAppendElement(j, led,
				    Jim_NewIntObj(j, xLED(c, p, l, GREEN)));
				Jim_ListAppendElement(j, led,
				    Jim_NewIntObj(j, xLED(c, p, l, BLUE)));

				Jim_ListAppendElement(j, y, led);
			}
			Jim_ListAppendElement(j, z, y);
		}
		Jim_ListAppendElement(j, cube, z);
	}

	Jim_SetResult(j, cube);
	return JIM_OK;
}

static int
jim_cube_clear(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	NOARGS;
	cube_clear(transaction);
	return JIM_OK;
}

static int
jim_cube_fill(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	if (argc != 1 && argc != 4)
	{
		Jim_WrongNumArgs(j, 1, argv, "[red green blue]");
		return JIM_ERR;
	}

	HANDLE_COLOUR(4);

	cube_fill(transaction, red, green, blue);

	return JIM_OK;
}

static int
jim_cube_getled(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	Jim_Obj *led;
	long c, p, l;

	if (argc != 4)
	{
		Jim_WrongNumArgs(j, 1, argv, "column panel layer");
		return JIM_ERR;
	}

	Jim_GetLong(j, argv[1], &c);
	Jim_GetLong(j, argv[2], &p);
	Jim_GetLong(j, argv[3], &l);

	led = Jim_NewListObj(j, NULL, 0);

	Jim_ListAppendElement(j, led,
	    Jim_NewIntObj(j, xLED(c, p, l, RED)));
	Jim_ListAppendElement(j, led,
	    Jim_NewIntObj(j, xLED(c, p, l, GREEN)));
	Jim_ListAppendElement(j, led,
	    Jim_NewIntObj(j, xLED(c, p, l, BLUE)));

	Jim_SetResult(j, led);

	return JIM_OK;
}

static int
jim_cube_led(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	long x, y, z;

	if (argc != 4 && argc != 7)
	{
		Jim_WrongNumArgs(j, 1, argv,
		    "column panel layer [red green blue]");
		return JIM_ERR;
	}

	HANDLE_COLOUR(7);

	Jim_GetLong(j, argv[1], &x);
	Jim_GetLong(j, argv[2], &y);
	Jim_GetLong(j, argv[3], &z);

	if (transaction)
		buffer_LED(x, y, z, red, green, blue);
	else
		LED(x, y, z, red, green, blue);

	return JIM_OK;
}

static int
jim_cube_panel(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	long panel;

	if (argc != 2 && argc != 5)
	{
		Jim_WrongNumArgs(j, 1, argv,
		    "panel [red green blue]");
		return JIM_ERR;
	}

	HANDLE_COLOUR(5);

	Jim_GetLong(j, argv[1], &panel);

	cube_panel(panel, transaction, red, green, blue);

	return JIM_OK;
}

static int
jim_cube_layer(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	long layer;

	if (argc != 2 && argc != 5)
	{
		Jim_WrongNumArgs(j, 1, argv,
		    "layer [red green blue]");
		return JIM_ERR;
	}

	HANDLE_COLOUR(5);

	Jim_GetLong(j, argv[1], &layer);

	cube_layer(layer, transaction, red, green, blue);

	return JIM_OK;
}

static int
jim_cube_slice(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	long column;

	if (argc != 2 && argc != 5)
	{
		Jim_WrongNumArgs(j, 1, argv,
		    "column [red green blue]");
		return JIM_ERR;
	}

	HANDLE_COLOUR(5);

	Jim_GetLong(j, argv[1], &column);

	cube_slice(column, transaction, red, green, blue);

	return JIM_OK;
}

static int
jim_cube_column(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	long panel, column;

	if (argc != 3 && argc != 6)
	{
		Jim_WrongNumArgs(j, 1, argv,
		    "panel column [red green blue]");
		return JIM_ERR;
	}

	HANDLE_COLOUR(6);

	Jim_GetLong(j, argv[1], &panel);
	Jim_GetLong(j, argv[2], &column);

	cube_column(panel, column, transaction, red, green, blue);

	return JIM_OK;
}

static int
jim_cube_textchar(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	uint8_t grid[8][8][3];
	const char *str;
	Jim_Obj *data;
	int x, y;

	if (argc != 2 && argc != 5)
	{
		Jim_WrongNumArgs(j, 1, argv,
		    "<character> [red green blue]");
		return JIM_ERR;
	}

	str = Jim_GetString(argv[1], NULL);
	if (!str)
	{
		Jim_SetResultString(j, "Invalid argument.", -1);
		return JIM_ERR;
	}

	HANDLE_COLOUR(5);

	text_getchar(*str, &grid, red, green, blue);

	data = Jim_NewListObj(j, NULL, 0);
	for (y = 0; y < 8; y++)
	{
	    Jim_Obj *row = Jim_NewListObj(j, NULL, 0);
	    for (x = 0; x < 8; x++)
	    {
		Jim_Obj *led = Jim_NewListObj(j, NULL, 0);

		Jim_ListAppendElement(j, led,
		    Jim_NewIntObj(j, grid[x][y][RED]));
		Jim_ListAppendElement(j, led,
		    Jim_NewIntObj(j, grid[x][y][GREEN]));
		Jim_ListAppendElement(j, led,
		    Jim_NewIntObj(j, grid[x][y][BLUE]));

		Jim_ListAppendElement(j, row, led);
	    }
	    Jim_ListAppendElement(j, data, row);
	}

	Jim_SetResult(j, data);
	return JIM_OK;
}

static int
jim_cube_plane(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	uint8_t grid[8][8][3];
	enum planes plane;
	long index;
	int x, y, z;
	const char *cmd;

	if (argc == 2 && Jim_CompareStringImmediate(j, argv[1], "-commands"))
	{
		Jim_SetResultString(j, "-layer -panel -slice", -1);
		return JIM_OK;
	}

	if (argc != 3 && argc != 4)
	{
		Jim_WrongNumArgs(j, 1, argv,
		    "<-panel|-layer|-slice> <number> [data]");
		return JIM_ERR;
	}

	cmd = Jim_GetString(argv[1], NULL);

	if (!cmd)
	{
		Jim_SetResultString(j, "Invalid argument.", -1);
		return JIM_ERR;
	}

	if (!strncmp(cmd, "-p", 2))
		plane = PLANE_PANEL;
	else if (!strncmp(cmd, "-l", 2))
		plane = PLANE_LAYER;
	else if (!strncmp(cmd, "-s", 2))
		plane = PLANE_SLICE;
	else
	{
		Jim_SetResultFormatted(j, "Unknown mode, '%s'", cmd);
		return JIM_ERR;
	}

	Jim_GetLong(j, argv[2], &index);
	if (index < 0 || index > 7)
	{
		Jim_SetResultFormatted(j, "Invalid index, %d. (Range is 0-7)",
		    index);
		return JIM_ERR;
	}

	if (argc == 3)
	{
		// Get
		Jim_Obj *data = Jim_NewListObj(j, NULL, 0);
		Jim_Obj *led, *set;

		switch (plane)
		{
		    case PLANE_PANEL:
			for (x = 0; x < 8; x++)
			{
			    set = Jim_NewListObj(j, NULL, 0);
			    for (z = 7; z >= 0; z--)
			    {
				led = Jim_NewListObj(j, NULL, 0);

				Jim_ListAppendElement(j, led,
				    Jim_NewIntObj(j, xLED(x, index, z, RED)));
				Jim_ListAppendElement(j, led,
				    Jim_NewIntObj(j, xLED(x, index, z, GREEN)));
				Jim_ListAppendElement(j, led,
				    Jim_NewIntObj(j, xLED(x, index, z, BLUE)));

				Jim_ListAppendElement(j, set, led);
			    }
			    Jim_ListAppendElement(j, data, set);
			}
			break;

		    case PLANE_SLICE:
			for (y = 0; y < 8; y++)
			{
			    set = Jim_NewListObj(j, NULL, 0);
			    for (z = 7; z >= 0; z--)
			    {
				led = Jim_NewListObj(j, NULL, 0);

				Jim_ListAppendElement(j, led,
				    Jim_NewIntObj(j, xLED(index, y, z, RED)));
				Jim_ListAppendElement(j, led,
				    Jim_NewIntObj(j, xLED(index, y, z, GREEN)));
				Jim_ListAppendElement(j, led,
				    Jim_NewIntObj(j, xLED(index, y, z, BLUE)));

				Jim_ListAppendElement(j, set, led);
			    }
			    Jim_ListAppendElement(j, data, set);
			}

			break;

		    case PLANE_LAYER:
			for (x = 0; x < 8; x++)
			{
			    set = Jim_NewListObj(j, NULL, 0);
			    for (y = 7; y >= 0; y--)
			    {
				led = Jim_NewListObj(j, NULL, 0);

				Jim_ListAppendElement(j, led,
				    Jim_NewIntObj(j, xLED(x, y, index, RED)));
				Jim_ListAppendElement(j, led,
				    Jim_NewIntObj(j, xLED(x, y, index, GREEN)));
				Jim_ListAppendElement(j, led,
				    Jim_NewIntObj(j, xLED(x, y, index, BLUE)));

				Jim_ListAppendElement(j, set, led);
			    }
			    Jim_ListAppendElement(j, data, set);
			}
			break;
		}

		Jim_SetResult(j, data);
		return JIM_OK;
	}

	// Set

	if (Jim_ListLength(j, argv[3]) != 8)
	{
		Jim_SetResultString(j, "Data is not a list of 8 elements.", -1);
		return JIM_ERR;
	}

	memset(grid, '\0', sizeof(grid));
	
	for (x = 0; x < 8; x++)
	{
		Jim_Obj *o;

		if (Jim_ListIndex(j, argv[3], x, &o, JIM_ERRMSG) != JIM_OK)
			return JIM_ERR;

		// o points to a column's worth of data.
		if (Jim_ListLength(j, o) != 8)
		{
			Jim_SetResultFormatted(j,
			    "Column %d is not a list of 8 elements.", x);
			return JIM_ERR;
		}

		for (y = 0; y < 8; y++)
		{
			Jim_Obj *led, *colour;
			long r, g, b;

			if (Jim_ListIndex(j, o, y, &led, JIM_ERRMSG)
			    != JIM_OK)
				return JIM_ERR;

			if (Jim_ListLength(j, led) != 3)
			{
				Jim_SetResultFormatted(j,
				    "LED(%d, %d) is not a list of 3 elements.",
				    x, y);
				return JIM_ERR;
			}
			r = g = b = 0;
			if (Jim_ListIndex(j, led, 0, &colour, JIM_ERRMSG)
			    == JIM_OK)
				Jim_GetLong(j, colour, &r);
			if (Jim_ListIndex(j, led, 1, &colour, JIM_ERRMSG)
			    == JIM_OK)
				Jim_GetLong(j, colour, &g);
			if (Jim_ListIndex(j, led, 2, &colour, JIM_ERRMSG)
			    == JIM_OK)
				Jim_GetLong(j, colour, &b);

			grid[x][y][RED] = r;
			grid[x][y][GREEN] = g;
			grid[x][y][BLUE] = b;
		}
	}

	cube_plane(index, plane, transaction, &grid);

	return JIM_OK;
}

static int
jim_cube_row(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	long panel, layer;

	if (argc != 3 && argc != 6)
	{
		Jim_WrongNumArgs(j, 1, argv,
		    "panel layer [red green blue]");
		return JIM_ERR;
	}

	HANDLE_COLOUR(6);

	Jim_GetLong(j, argv[1], &panel);
	Jim_GetLong(j, argv[2], &layer);

	cube_row(panel, layer, transaction, red, green, blue);

	return JIM_OK;
}

static int
jim_cube_translate(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	long x, y, z;

	if (argc != 4)
	{
		Jim_WrongNumArgs(j, 1, argv, "columns panels layers");
		return JIM_ERR;
	}

	Jim_GetLong(j, argv[1], &x);
	Jim_GetLong(j, argv[2], &y);
	Jim_GetLong(j, argv[3], &z);

	cube_translate(x, y, z);

	return JIM_OK;
}

static int
jim_cube_rotate(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	const char *arg;
	long degrees;
	int buffer = 0;

	if (argc != 2 && argc != 3)
	{
		Jim_WrongNumArgs(j, 1, argv, "[-buffer] <degrees>");
		return JIM_ERR;
	}

	if (argc == 3)
	{
		arg = Jim_GetString(argv[1], NULL);

		if (!strncmp(arg, "-buf", 4))
			buffer = 1;
		else
		{
			Jim_WrongNumArgs(j, 1, argv, "[-buffer] <degrees>");
			return JIM_ERR;
		}
		Jim_GetLong(j, argv[2], &degrees);
	}
	else
		Jim_GetLong(j, argv[1], &degrees);

	cube_rotate((float)degrees * .0174532, buffer);

	return JIM_OK;
}

static int
jim_cube_text(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	enum textmode mode;
	long r, g, b;
	char buf[0x100];
	const char *cmd;

	if (argc == 2 && Jim_CompareStringImmediate(j, argv[1], "-commands"))
	{
		Jim_SetResultString(j, "-foursides -twosides -x -y -z", -1);
		return JIM_OK;
	}

	if (argc < 2)
	{
		Jim_WrongNumArgs(j, 1, argv,
		    "[-twosides|-foursides|-x|-y|-z] <text>");
		return JIM_ERR;
	}

	cmd = Jim_GetString(argv[1], NULL);

	if (*cmd == '-')
	{
		if (!strncmp(cmd, "-two", 4))
			mode = TEXTMODE_TWOWALLS;
		else if (!strncmp(cmd, "-four", 5))
			mode = TEXTMODE_FOURWALLS;
		else if (!strcmp(cmd, "-x"))
			mode = TEXTMODE_THROUGHX;
		else if (!strcmp(cmd, "-y"))
			mode = TEXTMODE_THROUGHY;
		else if (!strcmp(cmd, "-z"))
			mode = TEXTMODE_THROUGHZ;
		else
		{
			Jim_SetResultString(j, "unknown text mode", -1);
			return JIM_ERR;
		}
		argc--, argv++;
	}

	// Build the string buffer.
	*buf = '\0';
	for (; argc > 1; argc--, argv++)
	{
		if (*buf)
			strncat(buf, " ", sizeof(buf) - strlen(buf) - 1);
		cmd = Jim_GetString(argv[1], NULL);
		strncat(buf, cmd, sizeof(buf) - strlen(buf) - 1);
	}

	// Fetch the current colour.
	jim_load_colour(j, &r, &g, &b);

	// Invoke the correct string function.
	text_scroll(buf, r, g, b, mode);

	return JIM_OK;
}

static int
jim_cube_lookup(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	const char *table;
	long x, y;
	float val = 0;

	if (argc == 2 && Jim_CompareStringImmediate(j, argv[1], "-commands"))
	{
		Jim_SetResultString(j, "-angle -diagonal -distance", -1);
		return JIM_OK;
	}

	if (argc != 4)
	{
		Jim_WrongNumArgs(j, 1, argv,
		    "<-distance|-angle|-diagonal> <x> <y>");
		return JIM_ERR;
	}

	table = Jim_GetString(argv[1], NULL);
	Jim_GetLong(j, argv[2], &x);
	Jim_GetLong(j, argv[3], &y);

	if (x < 0 || x > 7 || y < 0 || y > 7)
	{
		Jim_SetResultString(j, "Index out of range", -1);
		return JIM_ERR;
	}

	if (!table)
		return JIM_ERR;
	if (!strncmp(table, "-dist", 5))
		val = distance[x][y];
	else if (!strncmp(table, "-ang", 4))
		val = angle[x][y];
	else if (!strncmp(table, "-diag", 5))
		val = diagonal[x][y];
	else
	{
		Jim_WrongNumArgs(j, 1, argv,
		    "<-distance|-angle|-diagonal> <x> <y>");
		return JIM_ERR;
	}

	Jim_SetResult(j, Jim_NewDoubleObj(j, val));
	return JIM_OK;
}

static int
jim_cube_hwdebug(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	const char *cmd;

	if (argc < 2)
		return JIM_ERR;

	cmd = Jim_GetString(argv[1], NULL);

	if (argc == 2 && !strcmp(cmd, "-stop"))
	{
		printf("Stopping cube...\n");
		cube_stop();
	}
	else if (argc == 2 && !strcmp(cmd, "-start"))
	{
		printf("Starting cube...\n");
		cube_start();
	}
	else if (argc == 4 && !strcmp(cmd, "-layer"))
	{
		long layer, mode;

		Jim_GetLong(j, argv[2], &layer);
		Jim_GetLong(j, argv[3], &mode);

		printf("Changing layer %d state to %d\n", layer, mode);
		cube_layer_control(layer, mode);
	}
	else if (argc == 3 && !strcmp(cmd, "-loadlayer"))
	{
		long layer;

		Jim_GetLong(j, argv[2], &layer);

		printf("Activating columns for layer %d\n", layer);
		cube_load_layer(layer);
	}
	else
		return JIM_ERR;

	return JIM_OK;
}

static int
jim_cube_help(Jim_Interp *j, int argc, Jim_Obj *const *argv)
{
	if (argc != 1 && argc != 2)
	{
		Jim_WrongNumArgs(j, 1, argv, "[command]");
		return JIM_ERR;

	}

	if (argc == 2)
	{
		const char *cmd;
		int i;

		cmd = Jim_GetString(argv[1], NULL);

		for (i = 0; helps[i].cmd; i++)
		{
			if (cmd && !strcasecmp(cmd, helps[i].cmd))
			{
				printf("%s\n", helps[i].text);
				break;
			}
		}
		return JIM_OK;
	}

	printf(
"Cube commands. Use 'help <command>' for more detail.\n"
"\n"
"Basics:\n"
"  cube.colour      - Set/get the working colour.\n"
"  cube.scrollrate  - Set/get the current scroll-rate.\n"
"  cube.clear       - Clear the cube (all LEDs off).\n"
"  cube.fill        - Fill the cube (all LEDs on).\n"
"  cube.column      - Fill an entire column.\n"
"  cube.layer       - Fill an entire layer.\n"
"  cube.panel       - Fill an entire panel.\n"
"  cube.slice       - Fill an entire slice (columns across panels).\n"
"  cube.row         - Fill an entire row.\n"
"\n"
"LEDs:\n"
"  cube.led         - Set an individual LED.\n"
"  cube.getled      - Return the colour of a specific LED.\n"
"  cube.get         - Return the current cube data as TCL list.\n"
"\n"
"Operations:\n"
"  cube.translate   - Translate (shift) the cube contents.\n"
"  cube.rotate      - Rotate the cube contents.\n"
"  cube.plane       - Set/get a plane of the cube in one go.\n"
"\n"
"Animations:\n"
"  cube.anim        - Run built-in animation by name.\n"
"  cube.text        - Scroll text.\n"
"\n"
"Other:\n"
"  cube.begin       - Start building a cube.\n"
"  cube.commit      - Finish building a cube.\n"
"\n"
"Utilities:\n"
"  pprint           - Pretty print a grid.\n"
"  delay            - Pause for a number of milliseconds.\n"
	);
	return JIM_OK;
}

static void
Jim_SetGlobalVariableStrWithStr(Jim_Interp *j, char *var, char *val)
{
	Jim_SetGlobalVariableStr(j, var, Jim_NewStringObj(j, val, -1));
}

extern int Jim_initjimshInit(Jim_Interp *interp);

// Initialise the Jim interpreter.
Jim_Interp *
jim_init()
{
	Jim_Interp *j;

	j = Jim_CreateInterp();
	Jim_RegisterCoreCommands(j);
	Jim_InitStaticExtensions(j);

	// Register Jim variables.
	Jim_SetGlobalVariableStrWithStr(j, COLOUR_VARIABLE, "63 0 0");
	Jim_SetGlobalVariableStrWithStr(j, "pi.model", pi_modelname);
	Jim_SetGlobalVariableStrWithStr(j, "pi.code", pi_modelcode);
	Jim_SetGlobalVariableStr(j, "pi.revision",
	    Jim_NewIntObj(j, pi_revision));

	// Register Jim commands.
	//     cmd, function, privdata, delProc
	Jim_CreateCommand(j, "help", jim_cube_help, NULL, NULL);
	Jim_CreateCommand(j, "delay", jim_delay, NULL, NULL);
	Jim_CreateCommand(j, "cube.begin", jim_cube_begin, NULL, NULL);
	Jim_CreateCommand(j, "cube.commit", jim_cube_commit, NULL, NULL);
	Jim_CreateCommand(j, "cube.get", jim_cube_get, NULL, NULL);
	Jim_CreateCommand(j, "cube.getled", jim_cube_getled, NULL, NULL);
	Jim_CreateCommand(j, "cube.clear", jim_cube_clear, NULL, NULL);
	Jim_CreateCommand(j, "cube.fill", jim_cube_fill, NULL, NULL);
	Jim_CreateCommand(j, "cube.led", jim_cube_led, NULL, NULL);
	Jim_CreateCommand(j, "cube.panel", jim_cube_panel, NULL, NULL);
	Jim_CreateCommand(j, "cube.layer", jim_cube_layer, NULL, NULL);
	Jim_CreateCommand(j, "cube.slice", jim_cube_slice, NULL, NULL);
	Jim_CreateCommand(j, "cube.row", jim_cube_row, NULL, NULL);
	Jim_CreateCommand(j, "cube.column", jim_cube_column, NULL, NULL);
	Jim_CreateCommand(j, "cube.plane", jim_cube_plane, NULL, NULL);
	Jim_CreateCommand(j, "cube.colour", jim_cube_colour, NULL, NULL);
	Jim_CreateCommand(j, "cube.scrollrate", jim_cube_scrollrate, NULL,NULL);
	Jim_CreateCommand(j, "cube.anim", jim_cube_anim, NULL, NULL);
	Jim_CreateCommand(j, "cube.text", jim_cube_text, NULL, NULL);
	Jim_CreateCommand(j, "cube.textchar", jim_cube_textchar, NULL, NULL);
	Jim_CreateCommand(j, "cube.translate", jim_cube_translate, NULL, NULL);
	Jim_CreateCommand(j, "cube.rotate", jim_cube_rotate, NULL, NULL);
	Jim_CreateCommand(j, "cube.hw.debug", jim_cube_hwdebug, NULL, NULL);
	Jim_CreateCommand(j, "cube.lookup", jim_cube_lookup, NULL, NULL);
	Jim_EvalSource(j, NULL, 1, "\n"
		"signal handle SIGINT\n"
	);

	Jim_initjimshInit(j);

	// TBD - need to determine best way to do this.
	j->signal_level = 99;

#include "ext.h"

	return j;
}

