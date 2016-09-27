#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <stdint.h>
#include "cube.h"

volatile uint8_t canary = 0;

void *
canary_thread(void *arg)
{
	uint8_t running = 0;

	sleep(5);

	for (;;)
	{
		delay(500);

		__atomic_load(&exiting, &running, __ATOMIC_RELAXED);
		if (running)
			break;

		__atomic_load(&canary, &running, __ATOMIC_RELAXED);

		if (!running)
		{
			printf("Canary not singing!\n");
			cube_off();
			exit(0);
		}

		running = 0;
		__atomic_store(&canary, &running, __ATOMIC_RELAXED);
	}
}

