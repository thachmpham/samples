#include <pthread.h>
#include <stdio.h>

pthread_mutex_t mutex_a, mutex_b;

void* do_lock_ab(void*)
{
    pthread_mutex_lock(&mutex_a);
    pthread_mutex_lock(&mutex_b);

    pthread_mutex_unlock(&mutex_b);
    pthread_mutex_unlock(&mutex_a);
}

void* do_lock_ba(void*)
{
    pthread_mutex_lock(&mutex_b);
    pthread_mutex_lock(&mutex_a);

    pthread_mutex_unlock(&mutex_a);
    pthread_mutex_unlock(&mutex_b);
}

int main(int argc, char* argv)
{
    pthread_t t1, t2;
    pthread_mutex_init(&mutex_a, NULL);
    pthread_mutex_init(&mutex_b, NULL);

    pthread_create(&t1, NULL, do_lock_ab, NULL);
    pthread_create(&t2, NULL, do_lock_ba, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    printf("done\n");
}