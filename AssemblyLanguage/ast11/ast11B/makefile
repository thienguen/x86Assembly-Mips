# CS 218 Assignment #11
# Simple make file for asst #11

OBJS_SM	= benford.o a11procsSM.o
OBJS_LG	= benford.o a11procsLG.o
ASM	= yasm -g dwarf2 -f elf64
CC	= g++ -g -std=c++11

all:	 benfordLG	benfordSM
# all:	sed benfordLG	benfordSM

# sed:
# 	@sed -e "s/BUFFSIZE\tequ\t500000/BUFFSIZE\tequ\t2/" \
# 				a11procs.asm > a11procsSM.asm

benford.o: benford.cpp
	$(CC) -c benford.cpp

a11procsSM.o: a11procsSM.asm
	$(ASM) a11procsSM.asm -l a11procsSM.lst -o a11procsSM.o

a11procsLG.o: a11procs.asm
	$(ASM) a11procs.asm -l a11procs.lst -o a11procsLG.o

benfordSM: $(OBJS_SM)
	$(CC) -no-pie -o benfordSM $(OBJS_SM)

benfordLG: $(OBJS_LG)
	$(CC) -no-pie -o benfordLG $(OBJS_LG)

# -----
# clean by removing object files and list files.

clean:
	@rm	-f $(OBJS_LG)
	@rm	-f $(OBJS_SM)
	@rm	-f a11procs.lst
	@rm	-f a11procsSM.lst
