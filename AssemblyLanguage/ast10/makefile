# CS 218 Assignment #10
# Simple make file for asst #10

OBJS	= chaos.o a10procs.o
ASM		= yasm -g dwarf2 -f elf64
CC		= g++ -g -std=c++11 

all: chaos

chaos.o: chaos.cpp
	$(CC) -c chaos.cpp

a10procs.o: a10procs.asm 
	$(ASM) a10procs.asm -l a10procs.lst

chaos: $(OBJS)
	$(CC) -no-pie -o chaos $(OBJS) -lglut -lGLU -lGL -lm

# -----
# clean by removing object files.

clean:
	rm  $(OBJS)
	rm  a10procs.lst
