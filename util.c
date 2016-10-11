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

unsigned pi_model, pi_revision;
char *pi_modelname, *pi_modelcode;

void
pi_hardware_revision(void)
{
	FILE *fp;
	char buf[512];
	char term;
	int chars = 4;

	pi_model = 0;
	pi_revision = 0;

	if ((fp = fopen ("/proc/cpuinfo", "r")) != NULL)
	{
		while (fgets(buf, sizeof(buf), fp) != NULL)
		{
			if (pi_model == 0)
			{
				if (!strncasecmp("model name", buf, 10))
				{
					if (strstr(buf, "ARMv6") != NULL)
					{
						pi_model = 1;
						chars = 4;
					}
					else if (strstr(buf, "ARMv7") != NULL)
					{
						pi_model = 2;
						chars = 6;
					}
					else if (strstr(buf, "ARMv8") != NULL)
					{
						pi_model = 2;
						chars = 6;
					}
				}
			}

			if (!strncasecmp("revision", buf, 8))
			{
				if (sscanf(buf + strlen(buf) - chars - 1,
				    "%x%c", &pi_revision, &term) == 2)
					if (term != '\n')
						pi_revision = 0;
			}
		}
		fclose(fp);
	}

	// Remove any over-volt flag
	pi_revision &= ~0x10000000;

	if (!pi_revision)
	{
		pi_modelname = "Unknown";
		pi_modelcode = "U";
	}
	else if (pi_revision < 4)
	{
		pi_modelname = "Pi 1 Model B Revision 1, 256MiB";
		pi_modelcode = "1B1";
	}
	else if (pi_revision < 7)
	{
		pi_modelname = "Pi 1 Model B Revision 2, 256MiB";
		pi_modelcode = "1B2";
	}
	else if (pi_revision < 0xd)
	{
		pi_modelname = "Pi 1 Model A, 256MiB";
		pi_modelcode = "1A";
	}
	else if (pi_revision < 0x10)
	{
		pi_modelname = "Pi 1 Model B Revision 2, 512MiB";
		pi_modelcode = "1B2";
	}
	else if (pi_revision < 0x11)
	{
		pi_modelname = "Pi Compute Module, 512MiB";
		pi_modelcode = "1C";
	}
	else if (pi_revision < 0x13)
	{
		pi_modelname = "Pi 1 Model A+, 256MB";
		pi_modelcode = "1A+";
	}
	else if (pi_revision < 0x14)
	{
		pi_modelname = "Pi 1 Model B+, 256MB";
		pi_modelcode = "1B+";
	}
	else if (pi_revision < 0x15)
	{
		pi_modelname = "Pi Compute Module, 512MiB";
		pi_modelcode = "1C";
	}
	else if (pi_revision < 0x16)
	{
		pi_modelname = "Pi 1 Model A+, 512MiB";
		pi_modelcode = "1A+";
	}
	else if (pi_revision < 0x900093)
	{
		pi_modelname = "Pi Zero, 512MiB";
		pi_modelcode = "Z";
	}
	else if (pi_revision < 0xa02083)
	{
		pi_modelname = "Pi 3 Model B, 1GiB";
		pi_modelcode = "3B";
	}
	else if (pi_revision < 0xa22043)
	{
		pi_modelname = "Pi 2 Model B, 1GiB";
		pi_modelcode = "2B";
	}
	else if (pi_revision < 0xa22083)
	{
		pi_modelname = "Pi 3 Model B, 1GiB";
		pi_modelcode = "3B";
	}
	else
	{
		pi_modelname = "Unknown";
		pi_modelcode = "U";
	}
}

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

