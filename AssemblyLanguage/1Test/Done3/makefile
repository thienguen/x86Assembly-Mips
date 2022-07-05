# CS 218 Assignment #2
# Simple make file for asst #2

OBJS	= done3.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: done3

done3.o: done3.asm 
	$(ASM) done3.asm -l done3.lst

done3: done3.o
	$(LD) -o done3 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
	rm  done3.lst
