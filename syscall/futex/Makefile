CC = gcc
CFLAGS = -g
LDFLAGS = -pthread

TARGETS = futex_wait futex_wake mutex_deadlock

all: $(TARGETS)

%: %.c
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS)

clean:
	rm -f $(TARGETS)

.PHONY: all clean
