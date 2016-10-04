#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <string.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include "cube.h"
#include "gpio.h"

static volatile uint32_t *gpio_region = MAP_FAILED;
unsigned pi_model, pi_rev;

void
gpio_set_mode(unsigned gpio, unsigned mode)
{
	int reg, shift;

	reg   =  gpio/10;
	shift = (gpio % 10) * 3;

	gpio_region[reg] = (gpio_region[reg] & ~(7 << shift)) | (mode << shift);
}

#if 0
inline void
gpio_write(unsigned gpio, unsigned level)
{
	if (level == 0)
		*(gpio_region + GPCLR0 + PI_BANK(gpio)) = PI_BIT(gpio);
	else
		*(gpio_region + GPSET0 + PI_BANK(gpio)) = PI_BIT(gpio);
}

inline void
gpio_toggle_high(unsigned gpio)
{
		*(gpio_region + GPSET0 + PI_BANK(gpio)) = PI_BIT(gpio);
		*(gpio_region + GPCLR0 + PI_BANK(gpio)) = PI_BIT(gpio);
}
#else
inline void
gpio_write(unsigned gpio, unsigned level)
{
	if (level == 0)
		*(gpio_region + GPCLR0) = PI_BIT(gpio);
	else
		*(gpio_region + GPSET0) = PI_BIT(gpio);
}

inline void
gpio_toggle_high(unsigned gpio)
{
		*(gpio_region + GPSET0) = PI_BIT(gpio);
		*(gpio_region + GPCLR0) = PI_BIT(gpio);
}
#endif

inline void
gpio_clear_bank0(unsigned bits)
{
	*(gpio_region + GPCLR0) = bits;
}

// Only works for pins in bank 0
inline void
gpio_set_bank0(unsigned bits)
{
	*(gpio_region + GPSET0) = bits;
}

int
gpio_init(void)
{
	int fd;

	fd = open("/dev/gpiomem", O_RDWR | O_SYNC) ;

	if (fd < 0)
	{
		fprintf(stderr, "failed to open /dev/gpiomem\n");
		return -1;
	}

	gpio_region = (uint32_t *)mmap(NULL, 0xB4,
	    PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);

	close(fd);

	if (gpio_region == MAP_FAILED)
	{
		fprintf(stderr, "Bad, mmap failed\n");
		return -1;
	}
	return 0;
}

