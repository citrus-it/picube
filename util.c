/* Utility functions.
 * It also includes emulation for a few functions from the ChipKit environment.
 * 
 */
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <limits.h>
#include <sys/mman.h>
#include <time.h>
#include <errno.h>
#include "util.h"

void
delay(int msecs)
{
	struct timespec ns;

	ns.tv_sec = msecs / MSEC_PER_SEC;
	ns.tv_nsec = (msecs % MSEC_PER_SEC) * 1000000;

	while (nanosleep(&ns, &ns) == -1 && errno == EINTR)
		;
}

void
start_thread(int priority, pthread_t *thread, void *(*handler)(void *))
{
	struct sched_param param;
	pthread_attr_t attr;
	void *stack;
	int ret;

	/* Create thread stack - locked in memory */
	stack = mmap(NULL, PTHREAD_STACK_MIN, PROT_READ | PROT_WRITE,
	    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (stack == MAP_FAILED)
	{
		printf("mmap failed: %m\n");
		exit(-1);
	}
	memset(stack, 0, PTHREAD_STACK_MIN);

	/* Initialize pthread attributes (default values) */
	ret = pthread_attr_init(&attr);
	if (ret)
	{
		printf("init pthread attributes failed\n");
		exit(-1);
	}

	/* Set pthread stack */
	ret = pthread_attr_setstack(&attr, stack, PTHREAD_STACK_MIN);
	if (ret)
	{
		printf("pthread setstack failed\n");
		exit(-1);
	}

	/* Set scheduler policy and priority of pthread */
	ret = pthread_attr_setschedpolicy(&attr, SCHED_FIFO);
	if (ret)
	{
		printf("pthread setschedpolicy failed\n");
		exit(-1);
	}
	param.sched_priority = priority;
	ret = pthread_attr_setschedparam(&attr, &param);
	if (ret)
	{
		printf("pthread setschedparam failed\n");
		exit(-1);
	}

	/* Use scheduling parameters of attr */
	ret = pthread_attr_setinheritsched(&attr, PTHREAD_EXPLICIT_SCHED);
	if (ret)
	{
		printf("pthread setinheritsched failed\n");
		exit(-1);
	}

	/* Create a pthread with specified attributes */
	ret = pthread_create(thread, &attr, handler, NULL);
	if (ret)
	{
		printf("create pthread failed\n");
		exit(-1);
	}
}

