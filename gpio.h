
#define LOW	0
#define HIGH	1

#define GPSET0 7
#define GPSET1 8

#define GPCLR0 10
#define GPCLR1 11

#define GPLEV0 13
#define GPLEV1 14

#define GPPUD     37
#define GPPUDCLK0 38
#define GPPUDCLK1 39

#define PI_BANK(gpio) ((gpio) >> 5)
#define PI_BIT(gpio)  (1 << ((gpio) & 0x1f))

/* gpio modes. */

#define PI_INPUT  0
#define PI_OUTPUT 1
#define PI_ALT0   4
#define PI_ALT1   5
#define PI_ALT2   6
#define PI_ALT3   7
#define PI_ALT4   3
#define PI_ALT5   2

/* Values for pull-ups/downs off, pull-down and pull-up. */

#define PI_PUD_OFF  0
#define PI_PUD_DOWN 1
#define PI_PUD_UP   2

int gpio_init(void);
void gpio_set_mode(unsigned, unsigned);
void gpio_toggle_high(unsigned);
void gpio_write(unsigned, unsigned);
void gpio_clear_bank0(unsigned bits);
void gpio_set_bank0(unsigned bits);

