# CS 218 Assignment #9
# Simple make file for asst #9

OBJS	= main.o ast9procs.o
ASM		= yasm -g dwarf2 -f elf64
CC		= g++ -g -std=c++11

all: main

main.o: main.cpp
	$(CC) -c main.cpp

ast9procs.o: ast9procs.asm 
	$(ASM) ast9procs.asm -l ast9procs.lst

main: $(OBJS)
	$(CC) -no-pie -o main $(OBJS)

# -----
# clean by removing object files.

clean:
	rm  $(OBJS)
	rm  ast9procs.lst
