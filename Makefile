CFLAGS += -fPIC
LDFLAGS += -static
TARGETS = ctak atak

all: $(TARGETS)

clean:
	rm -f *.o $(TARGETS) *.core

ctak: tak.c
	$(CC) -o $@ $(CFLAGS) $(LDFLAGS) tak.c

atak: tak.S
	$(CC) -o $@ $(ASMFLAGS) $(LDFLAGS) tak.S

.PHONY: all clean
