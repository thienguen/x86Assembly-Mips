# CS 218 Assignment #2
# Simple make file for asst #2

OBJS	= done4.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: done4

done4.o: done4.asm 
	$(ASM) done4.asm -l done4.lst

done4: done4.o
	$(LD) -o done4 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
	rm  done4.lst
