# CS 218 Assignment #2
# Simple make file for asst #2

OBJS	= ast02.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: ast02

ast02.o: ast02.asm 
	$(ASM) ast02.asm -l ast02.lst

ast02: ast02.o
	$(LD) -o ast02 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
	rm  ast02.lst
