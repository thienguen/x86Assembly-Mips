# CS 218 Assignment #2
# Simple make file for asst #2

OBJS	= done1.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: done1

done1.o: done1.asm 
	$(ASM) done1.asm -l done1.lst

done1: done1.o
	$(LD) -o done1 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
	rm  done1.lst
