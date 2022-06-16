# CS 218 Assignment #3
# Simple make file for asst #3

OBJS	= ast03.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: ast03

ast03.o: ast03.asm 
	$(ASM) ast03.asm -l ast03.lst

ast03: ast03.o
	$(LD) -o ast03 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
