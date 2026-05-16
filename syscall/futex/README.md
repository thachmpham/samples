# FUTEX
```c
int futex(int *uaddr, int op, int val,
                const struct timespec *timeout,
                int *uaddr2, int val3);
```

# FUTEX_WAIT
## Description
```text
if *uaddr == val
    sleeps awaiting FUTEX_WAKE on uaddr
else
    not wait, return EAGAIN
```

## Testcases
```sh
# Case: *uaddr == val

$ strace -r -e futex -f ./futex_wait 5
strace: Process 7617 attached
[pid  7617]      0.000000 futex(0x55558fde22a0, FUTEX_WAIT_PRIVATE, 5, NULL) = ?
[pid  7617]     10.011689 +++ exited with 0 +++     

# *uaddr == val
# syscall futex lets thread 7617 sleeps await
# 10s later, process exists -> thread exits
```

- Case: *uaddr != val
```sh
# Case: *uaddr != val

$ strace -r -e futex -f ./futex_wait 4
strace: Process 7686 attached
[pid  7686]      0.000000 futex(0x5620a1d792a0, FUTEX_WAIT_PRIVATE, 5, NULL) = -1 EAGAIN (Resource temporarily unavailable)
[pid  7686]      0.004046 +++ exited with 0 +++

# *uaddr != val
# syscall futex returns EAGAIN immediately
# thread 7688 continues
```