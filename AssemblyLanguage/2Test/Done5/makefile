# CS 218 Assignment #2
# Simple make file for asst #2

OBJS	= done5.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: done5

done5.o: done5.asm 
	$(ASM) done5.asm -l done5.lst

done5: done5.o
	$(LD) -o done5 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
	rm  done5.lst
