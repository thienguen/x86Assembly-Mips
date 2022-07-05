# CS 218 Assignment #2
# Simple make file for asst #2

OBJS	= done7.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: done7

done7.o: done7.asm 
	$(ASM) done7.asm -l done7.lst

done7: done7.o
	$(LD) -o done7 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
	rm  done7.lst
