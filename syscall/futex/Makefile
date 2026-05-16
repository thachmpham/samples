CC = gcc
CFLAGS = -g
LDFLAGS = -pthread

TARGETS = futex_wait

all: $(TARGETS)

%: %.c
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS)

clean:
	rm -f $(TARGETS)

.PHONY: all clean
