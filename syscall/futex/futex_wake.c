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

void* do_wake(void*)
{
    sleep(10);
    
    // wake at most 1 waiter thread
    syscall(SYS_futex, pInt, FUTEX_WAKE_PRIVATE, 1, NULL, NULL, 0);
}

int main(int argc, char** argv)
{
    pthread_t t1, t2;

    pInt = malloc(sizeof(int));
    *pInt = 5;

    pthread_create(&t1, NULL, do_wait, NULL);
    pthread_create(&t2, NULL, do_wake, NULL);

    sleep(20);
}