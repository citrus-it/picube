
enum textmode {
	TEXTMODE_TWOWALLS = 0,
	TEXTMODE_FOURWALLS,
	TEXTMODE_THROUGHX,
	TEXTMODE_THROUGHY,
	TEXTMODE_THROUGHZ
};

void text_scroll(char *, uint8_t, uint8_t, uint8_t, enum textmode);
void text_getchar(char, uint8_t (*)[8][8][3], uint8_t, uint8_t, uint8_t);

void scrollThruX(char *, uint8_t, uint8_t, uint8_t);
void scrollThruY(char *, uint8_t, uint8_t, uint8_t);

