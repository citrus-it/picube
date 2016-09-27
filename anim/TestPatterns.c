
/*
 * Various test patterns for testing individual panels.
 */

void
_fast_column_scanner(int panel, int red, int green, int blue)
{
	int column;
	for (column = 0; column < 8; column++)
	{
		_column(panel, column, red, green, blue);
		delay(100);
		_column(panel, column, 0, 0, 0);
	}
	for (column = 7; column >= 0; column--)
	{
		_column(panel, column, red, green, blue);
		delay(100);
		_column(panel, column, 0, 0, 0);
	}
}

void
fast_column_scanner(byte panel)
{
	_fast_column_scanner(panel, 255, 0, 0);
	_fast_column_scanner(panel, 0, 255, 0);
	_fast_column_scanner(panel, 0, 0, 255);
	_fast_column_scanner(panel, 255, 255, 255);
}

void
column_by_column(byte panel)
{
	byte column;
	for (column = 0; column < 8; column++)
	{
		_column(panel, column, 255, 0, 0);
		delay(500);
		_column(panel, column, 0, 255, 0);
		delay(500);
		_column(panel, column, 0, 0, 255);
		delay(500);
		_column(panel, column, 255, 255, 255);
		delay(500);
		_column(panel, column, 0, 0, 0);
	}
}

void
row_by_row(byte panel)
{
	byte row;
	for (row = 0; row < 8; row++)
	{
		_row(panel, row, 255, 0, 0);
		delay(500);
		_row(panel, row, 0, 255, 0);
		delay(500);
		_row(panel, row, 0, 0, 255);
		delay(500);
		_row(panel, row, 255, 255, 255);
		delay(500);
		_row(panel, row, 0, 0, 0);
	}
}

void
snake_one_by_one(byte panel)
{
	int column, layer;
	byte colour;

	for (colour = 0; colour < 4; colour++)
	{
		int red, green, blue, i;

		red = colour == 0 ? 255 : 0;
		green = colour == 1 ? 255 : 0;
		blue = colour == 2 ? 255 : 0;
		if (colour == 3)
			red = green = blue = 255;

		// Flash first LED
		for (i = 0; i < 3; i++)
		{
			LED(0, panel, 0, red, green, blue);
			delay(100);
			LED(0, panel, 0, 0, 0, 0);
			delay(100);
		}

		for (layer=0; layer<8; layer++)
		{
			if (layer % 2 == 0)
			{
				// Forwards
				for (column=0; column<8; column++)
				{
					LED(column,panel,layer,red,green,blue);
					delay(100);
					LED(column,panel,layer,0,0,0);
				}
			}
			else
			{
				// Backwards
				for (column=7; column>=0; column--)
				{
					LED(column,panel,layer,red,green,blue);
					delay(100);
					LED(column,panel,layer,0,0,0);
				}
			}
		}

		// Run back down the column.
		for (layer = 6; layer >= 0; layer--)
		{
			LED(0, panel, layer, red, green, blue);
			delay(100);
			LED(0, panel, layer, 0, 0, 0);
		}
	}
}

void
whole_panel(byte panel)
{
	_panel(panel, 255, 0, 0);
	delay(5000);
	_panel(panel, 0, 255, 0);
	delay(5000);
	_panel(panel, 0, 0, 255);
	delay(5000);
	_panel(panel, 255, 255, 255);
	delay(5000);
	clearCube();
}

void
bam_test(byte panel)
{
	for (int colour = 0; colour < 3; colour++)
	{
		int red, green, blue, i;
		int *bright;

		red = green = blue = 0;

		switch (colour)
		{
		    case 0:	bright = &red; break;
		    case 1:	bright = &green; break;
		    case 2:	bright = &blue; break;
		}

		for (int layer = 7; layer >= 0; layer--)
		{
			for (int column=0; column < 8; column++)
			{
				LED(column, panel, layer, red, green, blue);
				(*bright)++;
			}
		}
		delay(5000);
	}
	clearCube();
}

void colour_fade(int panel)
{
	uint8_t red, green, blue;

	for (int colour = 0; colour < 190; colour++)
	{
		getColour(colour, &red, &green, &blue);
		_panel(panel, red, green, blue);
		delay(100);
	}
	clearCube();
}

