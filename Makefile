CC=ghdl
FFLAGS=-e --ieee=synopsys
CFLAGS=-r
LFLAGS=-a --ieee=synopsys
OBJECTS=*.vhd
GRAPHL=gtkwave
ROOTF=test_sisa
TIME=1000ns
CINCLUDE=--vcd=$(ROOTF).vcd --stop-time=$(TIME)
CLEAN =*.o *.cf *.vcd

all: graph

test_sisa: precompile
	$(CC) $(FFLAGS) $(ROOTF)
	$(CC) $(CFLAGS) $(ROOTF) $(CINCLUDE)

precompile:
	$(CC) $(LFLAGS) $(OBJECTS)

graph: test_sisa
	$(GRAPHL) $(ROOTF).vcd

clean:
	rm -f $(CLEAN) $(ROOTF)
