# FUTEX
```c
int futex(int *uaddr, int op, int val,
                const struct timespec *timeout,
                int *uaddr2, int val3);
```

# FUTEX_WAIT
## Description
```text
futex(uaddr, FUTEX_WAIT, val, timeout, _)

if *uaddr == val
    sleeps awaiting FUTEX_WAKE on uaddr
else
    not wait, return EAGAIN
```

## Test
### Case *uaddr == val
```sh
$ strace -tt -e futex -f ./futex_wait 5
strace: Process 7143 attached
[pid  7143] 11:21:05.931247 futex(0x3bc2e2a0, FUTEX_WAIT_PRIVATE, 5, NULL) = ?
[pid  7143] 11:21:15.931846 +++ exited with 0 +++
```
- 11:21:05, futex wait, *uaddr == val, so sleep await.
- 11:21:15, process exits, thread exits.

### Case *uaddr != val
```sh
$ strace -tt -e futex -f ./futex_wait 4
strace: Process 7068 attached
[pid  7068] 11:18:39.094043 futex(0x289302a0, FUTEX_WAIT_PRIVATE, 5, NULL) = -1 EAGAIN (Resource temporarily unavailable)
[pid  7068] 11:18:39.096230 +++ exited with 0 +++

```
- 11:18:39, futex wait, *uaddr == val, so don't wait, futex returns EAGAIN immediately. Thread continues.
- 11:18:39, thread exits after complete entry function.

# FUTEX_WAKE
## Description
```text
futex(uaddr, FUTEX_WAKE, val, _)

Wakes at most val processes waiting on uaddr.
```

## Test
```sh
>>> strace -tt -e futex -f ./futex_wake
strace: Process 7313 attached
[pid  7313] 11:26:02.068129 futex(0x2b9752a0, FUTEX_WAIT_PRIVATE, 5, NULL <unfinished ...>
strace: Process 7314 attached
[pid  7314] 11:26:12.074906 futex(0x2b9752a0, FUTEX_WAKE_PRIVATE, 1) = 1
[pid  7313] 11:26:12.075414 <... futex resumed>) = 0
[pid  7313] 11:26:12.077728 +++ exited with 0 +++
[pid  7314] 11:26:12.078209 +++ exited with 0 +++
```

- 11:26:02, thread 7313 sleeps await on 0x2b9752a0.
- 11:26:12, thread 7314 send wake-up notification to 0x2b9752a0.
- 11:26:12, thread 7313 wakes up and resumes.


# C pthread Mutex
## ABBA Deadlock
Thread A waits for the mutex which is locked by thread B.
Thread B waits for the mutex which is locked by thread A.
Both threads sleep await for each other. Both hang.

Reproduce deadlock.
```sh
$ while true; do ./deadlock_abba; done
done
done
done
# hang when deadlock occurs
```

Detect deadlock.
```sh
$ strace -e futex -f -p `pidof deadlock_abba`
strace: Process 5263 attached with 3 threads
[pid  5263] futex(0xffffa256f270, FUTEX_WAIT_BITSET|FUTEX_CLOCK_REALTIME, 5264, NULL, FUTEX_BITSET_MATCH_ANY <unfinished ...>
[pid  5264] futex(0x420088, FUTEX_WAIT_PRIVATE, 2, NULL <unfinished ...>
[pid  5265] futex(0x420058, FUTEX_WAIT_PRIVATE, 2, NULL
```
- Thread 5264 waits for mutex 0x420088.
- Thread 5265 waits for mutex 0x420058.

```sh
$ gdb -batch -p `pidof deadlock_abba` -ex 'p *(pthread_mutex_t*)0x420088'
$1 = {__data = {__lock = 2, __count = 0, __owner = 5265, __nusers = 1, __kind = 0, __spins = 0, __list = {__prev = 0x0, __next = 0x0}}, __size = "\002\000\000\000\000\000\000\000\221\024\000\000\001", '\000' <repeats 34 times>, __align = 2}

$ gdb -batch -p `pidof deadlock_abba` -ex 'p *(pthread_mutex_t*)0x420058'
$1 = {__data = {__lock = 2, __count = 0, __owner = 5264, __nusers = 1, __kind = 0, __spins = 0, __list = {__prev = 0x0, __next = 0x0}}, __size = "\002\000\000\000\000\000\000\000\220\024\000\000\001", '\000' <repeats 34 times>, __align = 2}
```
- Mutex 0x420088 is owned by thread 5265.
- Mutex 0x420058 is owned by thread 5264.

So,
- Thread 5264 waits for mutex 0x420088 which is owned by 5265.
- Thread 5265 waits for mutex 0x420058 which is owned by 5264.
- The two threads waits for mutexes owned by each other.

Workaround to solve deadlock.
- Thread 5264 owned mutex 0x420058. So, unlock the mutex from this thread.
```sh
$ gdb -batch -p `pidof deadlock_abba` -ex 'thread find 5264'
Thread 2 has target id 'Thread _ (LWP 5264)'

$ gdb -batch -p `pidof deadlock_abba` -ex 'thread apply 2 call (int) pthread_mutex_unlock((pthread_mutex_t*)0x420088)'
```
- After the mutex unlocked, deadlock solved, program can continue.


## Self Deadlock - Relock
Reproduce
```sh
$ ./deadlock_self_relock
# process hangs
```

Detect self deadlock.
```sh
$ strace -e futex -f -p `pidof deadlock_self_relock`
strace: Process 9526 attached
futex(0xffffe8f67ea0, FUTEX_WAIT_PRIVATE, 2, NULL
```
- Thread 9526 waits for mutex 0xffffe8f67ea0.

```sh
$ gdb -batch -p `pidof deadlock_self_relock` -ex 'p *(pthread_mutex_t*)0xffffe8f67ea0'
$1 = {__data = {__lock = 2, __count = 0, __owner = 9526, __nusers = 1, __kind = 0, __spins = 0, __list = {__prev = 0x0, __next = 0x0}}, __size = "\002\000\000\000\000\000\000\0006%\000\000\001", '\000' <repeats 34 times>, __align = 2}
```
- Mutex 0xffffe8f67ea0 is owned by thread 9526.

So, thead 9526 waits for the mutex which is owned by the thread itself.

Workaround.
```sh
$ gdb -batch -p `pidof deadlock_self_relock` -ex 'thread find 9526'
Thread 1 has target id 'Thread 0xffffa08c9e40 (LWP 9526)'

$ gdb -batch -p `pidof deadlock_self_relock` -ex 'thread apply 1 call (int) pthread_mutex_unlock((pthread_mutex_t*)0xffffe8f67ea0)'
[Inferior 1 (process 9526) detached]
```

After unlock, the thread wakes up, the program continues.

Solution: PTHREAD_MUTEX_RECURSIVE.


