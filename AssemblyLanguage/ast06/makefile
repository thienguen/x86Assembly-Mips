# CS 218 Assignment #6
# Simple make file for asst #6

OBJS	= ast06.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: ast06

ast06.o: ast06.asm 
	$(ASM) ast06.asm -l ast06.lst

ast06: ast06.o
	$(LD) -o ast06 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
	rm	ast06.lst