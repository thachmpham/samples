#include <pthread.h>

int main(int argc, char* argv)
{
    pthread_mutex_t mutex_a;
    pthread_mutex_init(&mutex_a, NULL);
    pthread_mutex_lock(&mutex_a);
    pthread_mutex_lock(&mutex_a);
}