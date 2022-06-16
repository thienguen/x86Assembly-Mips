# CS 218 Assignment #7
# Simple make file for asst #7

OBJS	= ast07.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: ast07

ast07.o: ast07.asm 
	$(ASM) ast07.asm -l ast07.lst

ast07: ast07.o
	$(LD) -o ast07 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
	rm  ast07.lst
