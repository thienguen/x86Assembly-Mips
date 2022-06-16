# CS 218 Assignment #1
# Simple make file for asst #1

OBJS	= ast01.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: ast01

ast01.o: ast01.asm 
	$(ASM) ast01.asm -l ast01.lst

ast01: ast01.o
	$(LD) -o ast01 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
