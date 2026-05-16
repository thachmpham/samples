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
