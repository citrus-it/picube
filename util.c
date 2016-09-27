/* Utility functions.
 * It also includes emulation for a few functions from the ChipKit environment.
 * 
 */

#include <stdio.h>
#include <sys/types.h>
#include <stdint.h>
#include <stdlib.h>
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

