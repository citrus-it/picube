
#define MSEC_PER_SEC		1000
#define USEC_PER_SEC		1000000
#define NSEC_PER_SEC		1000000000

void delay(int);
void start_thread(int, pthread_t *, void *(*)(void *));

