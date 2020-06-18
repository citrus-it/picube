#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <stdint.h>
#include <unistd.h>
#include "cube.h"
#include "util.h"

volatile uint8_t canary = 0;

void *
canary_thread(void *arg)
{
	uint8_t x = 0;

	sleep(5);

	for (;;)
	{
		delay(500);

		__atomic_load(&exiting, &x, __ATOMIC_RELAXED);
		if (x)
			break;

		__atomic_load(&canary, &x, __ATOMIC_RELAXED);

		if (!x)
		{
			printf("Canary not singing!\n");
			cube_off();
			exit(0);
		}

		x = 0;
		__atomic_store(&canary, &x, __ATOMIC_RELAXED);
	}
}

