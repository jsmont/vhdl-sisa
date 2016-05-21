# Paremeters

ROOTF=test_sisa
OBJECTS=package_*.vhd async_*.vhd alu.vhd control_l.vhd datapath.vhd MemoryController.vhd multi.vhd proc.vhd regfile.vhd sisa.vhd SRAMController.vhd test_sisa.vhd unidad_control.vhd	
TIME=1500ns
MEMFILE=contingut.memoria.hexa16.rom
TESTF=tests

# Libs

CC=ghdl
GRAPHL=gtkwave

# Options

FFLAGS=-e --ieee=synopsys
CFLAGS=-r
LFLAGS=-a --ieee=synopsys
CINCLUDE=--vcd=$(ROOTF).vcd --stop-time=$(TIME)
CLEAN =*.o *.cf *.vcd

# Nasty shit

all: setmem graph

test: precompile
	$(CC) $(FFLAGS) $(ROOTF)
	$(CC) $(CFLAGS) $(ROOTF) $(CINCLUDE)

precompile:
	$(CC) $(LFLAGS) $(OBJECTS)

graph: test
	$(GRAPHL) $(ROOTF).vcd

setmem:
	rm -f contingut.memoria.hexa16.rom package_*.vhd test_sisa.vhd async*.vhd
	ln -s $(TESTF)/$(MEMFILE) ./contingut.memoria.hexa16.rom
	ln -s $(TESTF)/*.vhd ./ 

clean:
	rm -f $(CLEAN) $(ROOTF)
	rm -f contingut.memoria.hexa16.rom package_*.vhd test_sisa.vhd async*.vhd
