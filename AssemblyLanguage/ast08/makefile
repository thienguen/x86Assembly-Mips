# CS 218 Assignment #8
# Simple make file for asst #8

OBJS	= ast8main.o ast8procs.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: ast8main

ast8main.o: ast8main.asm
	$(ASM) ast8main.asm -l ast8main.lst

ast8procs.o: ast8procs.asm 
	$(ASM) ast8procs.asm -l ast8procs.lst

ast8main: $(OBJS)
	$(LD) -o ast8main $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
	rm  ast8main.lst
	rm  ast8procs.lst