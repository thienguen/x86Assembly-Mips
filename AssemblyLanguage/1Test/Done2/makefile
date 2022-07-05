# CS 218 Assignment #2
# Simple make file for asst #2

OBJS	= done2.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: done2

done2.o: done2.asm 
	$(ASM) done2.asm -l done2.lst

done2: done2.o
	$(LD) -o done2 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
	rm  done2.lst
