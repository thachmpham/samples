#include <linux/futex.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <pthread.h>
#include <stdlib.h>

int* pInt = NULL;

void* do_wait(void*)
{
    // wait only if *pInt == 5
    syscall(SYS_futex, pInt, FUTEX_WAIT_PRIVATE, 5, NULL, NULL, 0);
}

int main(int argc, char** argv)
{
    pthread_t t1;

    pInt = malloc(sizeof(int));
    *pInt = atoi(argv[1]);

    pthread_create(&t1, NULL, do_wait, NULL);

    sleep(10);
}