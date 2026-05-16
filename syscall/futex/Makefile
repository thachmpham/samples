CC = gcc
CFLAGS = -g
LDFLAGS = -pthread

TARGETS = futex_wait futex_wake deadlock_abba deadlock_self_relock

all: $(TARGETS)

%: %.c
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS)

clean:
	rm -f $(TARGETS)

.PHONY: all clean
