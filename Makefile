CFLAGS += -fPIC
ASMFLAGS += -g -O0 -static
LDFLAGS += -g -O0 -static
TARGETS = ctakeuchi atakeuchi

all: $(TARGETS)

clean:
	rm -f *.o $(TARGETS) *.core

ctakeuchi: takeuchi.c
	$(CC) -o $@ $(CFLAGS) $(LDFLAGS) takeuchi.c

atakeuchi: takeuchi.S
	$(CC) -o $@ $(ASMFLAGS) $(LDFLAGS) takeuchi.S

.PHONY: all clean
