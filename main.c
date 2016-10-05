#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <limits.h>
#include <signal.h>
#include <sys/mman.h>
#include "jim.h"
#include "cube.h"

#ifdef BENCHMARK
extern uint16_t cyclems;

void *
bench_thread(void *x)
{
	uint16_t ms;

	for (;;)
	{
		sleep(1);

		__atomic_load(&cyclems, &ms, __ATOMIC_RELAXED);

		printf("Cycle time: %ldms\n", ms);
	}
}
#endif

void
signal_handler(int sig)
{
	uint8_t true = 1;

	if (sig == SIGINT)
		__atomic_store(&exiting, &true, __ATOMIC_RELAXED);
	else
	{

		//write(STDERR_FILENO, "Caught signal ", 14);
		write(STDERR_FILENO,
		    sys_siglist[sig], strlen(sys_siglist[sig]));
		write(STDERR_FILENO, "\n", 1);

		__atomic_store(&exiting, &true, __ATOMIC_RELAXED);
		cube_off();
		sleep(1);
		cube_off();
		abort();
	}
}

static void
catch_signal(int sig)
{
	if (signal(sig, signal_handler) == SIG_ERR)
		printf("Can't catch %s.\n", sys_siglist[sig]);
//	else
//		printf("Catching %s.\n", sys_siglist[sig]);
}

void
usage(const char *exe)
{
	printf(
		"PI RGB LED Cube\n"
		"Usage:\n"
		"  cube                    - start interactive shell.\n"
		"  cube <filename> [args]  - run script in file.\n"
		"  cube -e <cmd> [args]    - execute command directly.\n"
	);
}

int
main(int argc, char **argv)
{
	Jim_Interp *jim;

	if (argc > 1 &&
	    (!strncmp(argv[1], "-h", 2) || !strncmp(argv[1], "--h", 3)))
	{
		usage(argv[0]);
		return 0;
	}

	/* Lock memory - requires root permission. */
	if (mlockall(MCL_CURRENT|MCL_FUTURE) == -1)
	{
		printf("Could not lock memory, must be run as root.\n");
		return -1;
	}

	/* In the event of a program crash, we want to do our best to
	 * leave the cube turned off to avoid the risk of blowing an LED.
	 */
	catch_signal(SIGBUS);
	catch_signal(SIGSEGV);
	catch_signal(SIGQUIT);

	pi_hardware_revision();

	if (cube_init())
	{
		cube_start();
#ifdef BENCHMARK
		pthread_t t_bench;
		start_thread(10, &t_bench, bench_thread);
#endif
	}
//	else
//		printf("No cube, demo mode.\n");

	jim = jim_init();

	/*
	 * Handle command-line arguments.
	 */

	if (argc == 1)
	{
		// No arguments, start interactive shell.
		Jim_SetVariableStrWithStr(jim, "interactive", "1");
		Jim_InteractivePrompt(jim);
	}
	else if (argc > 2 && !strcmp(argv[1], "-e"))
	{
		// -e "script"
		JimSetArgv(jim, argc - 3, argv + 3);
		Jim_SetVariableStrWithStr(jim, "interactive", "0");
		if (Jim_Eval(jim, argv[2]) == JIM_ERR)
			printf("%s\n", Jim_String(Jim_GetResult(jim)));
	}
	else if (argc >= 2)
	{
		// Filename
		Jim_SetVariableStr(jim, "argv0",
		    Jim_NewStringObj(jim, argv[1], -1));
		JimSetArgv(jim, argc - 2, argv + 2);
		Jim_SetVariableStrWithStr(jim, "interactive", "0");
		if (Jim_EvalFile(jim, argv[1]) == JIM_ERR)
		{
			Jim_MakeErrorMessage(jim);
			printf("%s\n", Jim_String(Jim_GetResult(jim)));
		}
	}

	printf("Exiting...\n");
	cube_stop();
	Jim_FreeInterp(jim);

	return 0;
}

