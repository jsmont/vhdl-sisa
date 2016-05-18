CC=ghdl
FFLAGS=-e --ieee=synopsys
CFLAGS=-r
LFLAGS=-a --ieee=synopsys
OBJECTS=package_*.vhd async_*.vhd alu.vhd control_l.vhd datapath.vhd MemoryController.vhd multi.vhd proc.vhd regfile.vhd sisa.vhd SRAMController.vhd test_sisa.vhd unidad_control.vhd	
GRAPHL=gtkwave
ROOTF=test_sisa
TIME=1500ns
CINCLUDE=--vcd=$(ROOTF).vcd --stop-time=$(TIME)
CLEAN =*.o *.cf *.vcd

all: graph

test: precompile
	$(CC) $(FFLAGS) $(ROOTF)
	$(CC) $(CFLAGS) $(ROOTF) $(CINCLUDE)

precompile:
	$(CC) $(LFLAGS) $(OBJECTS)

graph: test
	$(GRAPHL) $(ROOTF).vcd

clean:
	rm -f $(CLEAN) $(ROOTF):x

