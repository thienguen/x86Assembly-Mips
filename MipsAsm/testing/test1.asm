#  CS 218, MIPS Assignment #0

#  Example program to display a list of
#  numbers and find the mimimum and maximum.

###########################################################
# TODO data segment

.data

# lst:	 .word 1, 3, 5, 7, 9, 7, 3, 5, 7, 9

lst:  .word 2, 3, 4, 5, 6, 7, 14, 16, 18, 20, 22




# DATA GOES HERE




###########################################################
#  text/code segment


.text

.globl main
.ent main
main:

# -----
#  Display header
#  Uses print string system call


# ----- # TODO Start here










	la $t0, lst
	add $t0, $t0, 4
	li $t2, 3
	li $t3, 10

lp:
	lw $t4, ($t0)
	add $t3, $t3, $t4
	add $t0, $t0, 4
	sub $t2, $t2, 1
	bnez $t2, lp
	srl $t3, $t3, 1
	lw $t5, 4($t0)
	add $t1, $t5, $t3

	#  t1 = 0x0000000E





# -----
#  Done, terminate program.

	li	$v0, 10
	syscall					# all done!

.end main

# list:   .word   10, 8, 6, 4, 2

#     la    $t0, list
#     li    $t2, 3
# lp:  lw    $t3, ($t0)
#     add   $t0, $t0, 4
#     sub   $t2, $t2, 1
#     bnez  $t2, lp
#     lw    $t5, list

	# $t2: 0x00000000
	# $t3: 0x00000006
	# $t5: 0x0000000A

#######################################################

# lst2:   .word   1, 3, 5, 7, 9, 11, 13, 15, 17, 19

#     la    $s0, lst2
#     add   $s0, $s0, 4
#     li    $s1, 3
#     li    $t5, 0
# lp2: lw    $t7, ($s0)
#     add   $t5, $t5, $t7
#     sub   $s1, $s1, 1
#     add   $s0, $s0, 4
#     bnez  $s1, lp2
#     lw    $t3, ($s0)

#######################################################

	# li $t1, 10
	# li $t2, 4
	# li $t3, 5
	# add $t5, $t2, $t3
	# sub $t2, $t2, 1
	# mul $t3, $t2, $t3
	# div $t2, $t3, 6

	# $t1 : 0x0000000a
	# $t2 : 0x00000002
	# $t3 : 0x0000000f
	# $t5 : 0x00000009

#######################################################
	
	# li $t1, 10
	# li $t2, 3
	# move $t3, $t2
	# add $t3, $t3, 3
	# add $t5, $t2, $t3
	# sub $t2, $t2, 1
	# mul $t3, $t2, $t3
	# div $t2, $t3, 7

	# $t2 : 0x00000001
	# $t3 : 0x0000000c
	# $t5 : 0x00000009

#######################################################

	# list:      .word 	2, 4, 6, 8, 10

	# len:       .word 	3

	# 	la $t0, list
	# 	add $t0, $t0, 4
	# 	lw $t2, len
	# 	move $t3, $zero

# lp:
	# 	lw $t4, ($t0)
	# 	add $t3, $t3, $t4
	# 	add $t0, $t0, 4
	# 	sub $t2, $t2, 1
	# 	bnez $t2, lp
	# 	lw $t5, list

	# $t3 : 0x00000012
	# $t4 : 0x00000008
	# $t5 : 0x00000002

#######################################################

# lst2: 	   .word	1, 3, 5, 7, 9, 11, 13, 15, 17, 19

# 	la    $s0, lst2
# 	li    $s1, 3
# 	li    $t5, 5
# lp2: lw    $t7, ($s0)
# 	add   $t5, $t5, $t7
# 	sub   $s1, $s1, 1
# 	add   $s0, $s0, 8
# 	bnez  $s1, lp2
# 	lw    $t3, ($s0)

#######################################################

# lst:	 .word 1, 3, 5, 7, 9, 7, 3, 5, 7, 9

# 	la $s0, lst
# 	li $s1, 3
# 	li $t5, 5

# lp:
# 	lw $t7, ($s0)
# 	add $t5, $t5, $t7
# 	sub $s1, $s1, 1
# 	add $s0, $s0, 8
# 	bnez $s1, lp
# 	lw $t3, ($s0)
	# add $t5, $t5, $t3

	# t5 = 0x000000017

#######################################################

# lst:  .word 2, 3, 4, 5, 6, 7, 14, 16, 18, 20, 22

# 	la $t0, lst
# 	li $s1, 3
# 	li $t3, 1

# lp:
# 	lw $t7, ($t0)
# 	mul $t3, $t3, $t7
# 	add $t0, $t0, 4
# 	sub $s1, $s1, 1
# 	bnez $s1, lp
# 	div $t3, $t3, 5
# 	lw $t5, 4($t0)
# 	add $t1, $t5, $t3

	# t1 - 0x0000000A

#######################################################

# lst: .word 6, 7, 3, 5, 8, 2, 9, 1, 10

# 	la $t0, lst
# 	add $t0, $t0, 4
# 	li $t2, 3
# 	li $t3, 10

# lp:
# 	lw $t4, ($t0)
# 	add $t3, $t3, $t4
# 	add $t0, $t0, 4
# 	sub $t2, $t2, 1
# 	bnez $t2, lp
# 	srl $t3, $t3, 1
# 	lw $t5, 4($t0)
# 	add $t1, $t5, $t3

	#  t1 = 0x0000000E

#######################################################










