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

static volatile uint32_t *gpioReg = MAP_FAILED;
unsigned piModel, piRev;

void
gpioSetMode(unsigned gpio, unsigned mode)
{
	int reg, shift;

	reg   =  gpio/10;
	shift = (gpio % 10) * 3;

	gpioReg[reg] = (gpioReg[reg] & ~(7 << shift)) | (mode << shift);
}

inline void
gpioWrite(unsigned gpio, unsigned level)
{
	if (level == 0)
		*(gpioReg + GPCLR0 + PI_BANK(gpio)) = PI_BIT(gpio);
	else
		*(gpioReg + GPSET0 + PI_BANK(gpio)) = PI_BIT(gpio);
}

inline void
gpioToggleHigh(unsigned gpio)
{
		*(gpioReg + GPSET0 + PI_BANK(gpio)) = PI_BIT(gpio);
		*(gpioReg + GPCLR0 + PI_BANK(gpio)) = PI_BIT(gpio);
}

inline void
gpioClearBank0(unsigned bits)
{
	*(gpioReg + GPCLR0) = bits;
}

// Only works for pins in bank 0
inline void
gpioSetBank0(unsigned bits)
{
	*(gpioReg + GPSET0) = bits;
}

unsigned
gpioHardwareRevision(void)
{
	FILE *fp;
	char buf[512];
	char term;
	int chars = 4;
	static unsigned rev = 0;

	if (rev)
		return rev;

	piModel = 0;

	if ((fp = fopen ("/proc/cpuinfo", "r")) != NULL)
	{
		while (fgets(buf, sizeof(buf), fp) != NULL)
		{
			if (piModel == 0)
			{
				if (!strncasecmp("model name", buf, 10))
				{
					if (strstr (buf, "ARMv6") != NULL)
					{
						piModel = 1;
						chars = 4;
					}
					else if (strstr (buf, "ARMv7") != NULL)
					{
						piModel = 2;
						chars = 6;
					}
					else if (strstr (buf, "ARMv8") != NULL)
					{
						piModel = 2;
						chars = 6;
					}
				}
			}

			if (!strncasecmp("revision", buf, 8))
			{
				if (sscanf(buf + strlen(buf) - chars - 1,
				    "%x%c", &rev, &term) == 2)
				{
					if (term != '\n') rev = 0;
				}
			}
		}
		fclose(fp);
	}

	return rev;
}

int
gpioInitialise(void)
{
	int fd;

	piRev = gpioHardwareRevision();

	//printf("Detected PI model: %dr%x\n", piModel, piRev);

	fd = open("/dev/gpiomem", O_RDWR | O_SYNC) ;

	if (fd < 0)
	{
		fprintf(stderr, "failed to open /dev/gpiomem\n");
		return -1;
	}

	gpioReg = (uint32_t *)mmap(NULL, 0xB4,
	    PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);

	close(fd);

	if (gpioReg == MAP_FAILED)
	{
		fprintf(stderr, "Bad, mmap failed\n");
		return -1;
	}
	return 0;
}

