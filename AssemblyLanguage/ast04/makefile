# CS 218 Assignment #4
# Simple make file for asst #4

OBJS	= ast04.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: ast04

ast04.o: ast04.asm 
	$(ASM) ast04.asm -l ast04.lst

ast04: ast04.o
	$(LD) -o ast04 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
	rm	ast04.lst