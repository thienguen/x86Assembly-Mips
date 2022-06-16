# CS 218 Assignment #5
# Simple make file for asst #5

OBJS	= ast05.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: ast05

ast05.o: ast05.asm 
	$(ASM) ast05.asm -l ast05.lst

ast05: ast05.o
	$(LD) -o ast05 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
	rm  ast05.lst
