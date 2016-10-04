#undef BENCHMARK

enum colours {RED = 0, GREEN, BLUE};
enum planes {PLANE_PANEL, PLANE_SLICE, PLANE_LAYER};

void LED(int, int, int, uint8_t, uint8_t, uint8_t);
void cLED(int, int, int, enum colours, uint8_t);
uint8_t xLED(int, int, int, enum colours);
void copyLED(int, int, int, int, int, int);

void cube_buffer(void);
void cube_from_buffer(void);
void cube_buffer_clear(void);
void buffer_LED(int, int, int, uint8_t, uint8_t, uint8_t);
void buffer_cLED(int, int, int, enum colours, uint8_t);
uint8_t buffer_xLED(int, int, int, enum colours);
void buffer_copyLED(int, int, int, int, int, int);

void cube_colour(int, uint8_t *, uint8_t *, uint8_t *, int);

void cube_clear(int);
void cube_fill(int, uint8_t, uint8_t, uint8_t);
void cube_row(int, int, int, uint8_t, uint8_t, uint8_t);
void cube_column(int, int, int, uint8_t, uint8_t, uint8_t);
void cube_panel(int, int, uint8_t, uint8_t, uint8_t);
void cube_layer(int, int, uint8_t, uint8_t, uint8_t);
void cube_slice(int, int, uint8_t, uint8_t, uint8_t);

void cube_plane(int, enum planes, int, uint8_t (*)[8][8][3]);
void cube_rotate(float, int);
void cube_translate(int, int, int);

int cube_init(void);
void cube_start(void);
void cube_stop(void);
void cube_off(void);
void cube_layer_control(int, int);
void cube_load_layer(int);
void *canary_thread(void *);

extern volatile uint8_t canary;
extern uint8_t exiting;

typedef uint8_t byte;

#define GPIO_CLOCK		4
#define GPIO_LATCH		18
#define GPIO_RED		17
#define GPIO_GREEN1		21	/* Pi 1, early revisions */
#define GPIO_GREEN2		27	/* All other boards */
#define GPIO_BLUE		22
#define GPIO_LAYER0		10
#define GPIO_LAYER1		9
#define GPIO_LAYER2		11
#define GPIO_LAYER3		23
#define GPIO_LAYER4		24
#define GPIO_LAYER5		25
#define GPIO_LAYER6		8
#define GPIO_LAYER7		7

#define GPIO_GREEN (pi_revision < 4 ? GPIO_GREEN1 : GPIO_GREEN2)

#define Black	191
#define Red	0
#define Orange	21
#define Yellow	40
#define Green	63
#define Aqua	85
#define Blue	127
#define Violet	148
#define Purple	169
#define White	190
#define Rainbow	999

