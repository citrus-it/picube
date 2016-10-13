
#define MSEC_PER_SEC		1000
#define USEC_PER_SEC		1000000
#define NSEC_PER_SEC		1000000000

extern unsigned pi_model, pi_revision;
extern char *pi_modelname, *pi_modelcode;

void delay(int);
int get_lock(char *);
void start_thread(int, pthread_t *, void *(*)(void *));
void pi_hardware_revision(void);

