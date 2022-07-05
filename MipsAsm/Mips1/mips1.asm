#  CS 218, MIPS Assignment #1
#  Provided Template

#  Name: Thien Nguyen
#  NSHE ID: 
#  Section: 1004
#  Assignment: Mips 1
#  Description: Write a simple assembly language program to calculate the some
#  geometric information for each rectangular parallelepiped in a series of
#  rectangular parallelepiped


###########################################################
#  data segment

.data

aSides:		.word	   31,    21,    15,    28,    37
			.word	   10,    14,    13,    37,    54
			.word	  -31,   -13,   -20,   -61,   -36
			.word	   14,    53,    44,    19,    42
			.word	  -27,   -41,   -53,   -62,   -10
			.word	   19,    28,    24,    10,    15
			.word	  -15,   -11,   -22,   -33,   -70
			.word	   15,    23,    15,    63,    26
			.word	  -24,   -33,   -10,   -61,   -15
			.word	   14,    34,    13,    71,    81
			.word	  -38,    73,    29,    17,    93

bSides:		.word	  101,   132,   111,   121,   142
			.word	  133,   114,   173,   131,   115
			.word	 -164,  -173,  -174,  -123,  -156
			.word	  144,   152,   131,   142,   156
			.word	 -115,  -124,  -136,  -175,  -146
			.word	  113,   123,   153,   167,   135
			.word	 -114,  -129,  -164,  -167,  -134
			.word	  116,   113,   164,   153,   165
			.word	 -126,  -112,  -157,  -167,  -134
			.word	  117,   114,   117,   125,   153
			.word	 -123,   173,   115,   106,   113

cSides:		.word	 1234,  1111,  1313,  1897,  1321
			.word	 1145,  1135,  1123,  1123,  1123
			.word	-1254, -1454, -1152, -1164, -1542
			.word	 1353,  1457,   182,  1142,  1354
			.word	-1364, -1134, -1154, -1344, -1142
			.word	 1173,  1543,  1151,  1352,  1434
			.word	-1355, -1037,  -123, -1024, -1453
			.word	 1134,  2134,  1156,  1134,  1142
			.word	-1267, -1104, -1134, -1246, -1123
			.word	 1134,  1161,  1176,  1157,  1142
			.word	-1153,  1193,  1184,  1142,  2034

volumes:	.space	220

len:		.word	55

vMin:		.word	0
vMid:		.word	0
vMax:		.word	0
vSum:		.word	0
vAve:		.word	0

# -----

hdr:		.ascii	"MIPS Assignment #1 \n"
			.ascii	"  Program to calculate the volume of each rectangular \n"
			.ascii	"  parallelepiped in a series of rectangular parallelepipeds.\n"
			.ascii	"  Also finds min, mid, max, sum, and average for volumes.\n"
			.asciiz	"\n"

sHdr:		.asciiz	"  Volumes: \n"

newLine:	.asciiz	"\n"
blnks:		.asciiz	"     "

minMsg:		.asciiz	"  Volumes Min = "
midMsg:		.asciiz	"  Volumes Mid = "
maxMsg:		.asciiz	"  Volumes Max = "
sumMsg:		.asciiz	"  Volumes Sum = "
aveMsg:		.asciiz	"  Volumes Ave = "


###########################################################
#  text/code segment

.text
.globl main
.ent main
main:

# -----
#  Display header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

# -----

# Once the values are computed, the program should find
# the minimum, maximum, middle value,
# and average for the volumes


# TODO YOUR CODE GOES HERE
# load addres of aSides, bSides, cSides,
	la $t0, volumes						# | So we got the address 
	la $t1, aSides						# | of first element
	la $t2, bSides						# | in the array in each var memory
	la $t3, cSides						# | into register destination

	lw $s0, len							# Load the length of word

	li $t9, 0							# SUM of volumes

	lw $s2, ($t0)						# set min, $s2 
	lw $s3, ($t0)						# set max, $s3 

# ----- 
# Volumes Loop, Sum, Min, Max
volumesLoop:

	lw $t4, ($t0)						# Load Volumes[n]
	lw $t5, ($t1)						# Load aSides[n]
	lw $t6, ($t2)						# Load bSides[n]
	lw $t7, ($t3)						# Load cSides[n]

# volumes[n] = aSides[n] ∗ bSides[n] ∗ cSides[n]

	mulo $t4, $t5, $t6					# volumes[n] = aSides[n] ∗ bSides[n]
	mulo $t4, $t4, $t7					# volumes[n] = aSides[n] ∗ bSides[n] ∗ cSides[n]
	add $t9, $t9, $t4					# SUM of volumes
	sw  $t4, ($t0)						# Store volumes[n]

# Sum of Volumes

# Min of Volumes
	bge	$t4, $s2, isNewMin				# is new min?
	move	$s2, $t4					# set new min

# Max of Volumes
isNewMin:	
	ble	$t4, $s3, isNewMax				# is new max?
	move	$s3, $t4					# set new max

isNewMax:
# Update the loop,
# increment address by a word
	addu $t0, $t0, 4					# volumes
	addu $t1, $t1, 4					# aSides
	addu $t2, $t2, 4 					# bSides
	addu $t3, $t3, 4					# cSides

	sub $s0, $s0, 1						# len = len - 1
	bnez $s0, volumesLoop				# loop if len > 0

# save sum
	sw $t9, vSum

# save Min and Max
	sw $s2, vMin
	sw $s3, vMax

# -----
# Median Value of even List

	la $t0, volumes						# address of volumes
	lw $t1, len							# length of volumes

	div $t2, $t1, 2						# $t2 = len / 2
	mul $t3, $t2, 4						# $t3 = $t2 * 4 --> offset
	add $t4, $t0, $t3					# $t4 = volumes[offset] in address

# volumes[len / 2]
	lw $t5, ($t4)						# $t5 = load volumes[len/2]

# save median
	sw $t5, vMid

# ----
# The Average = sum / len
	lw $t0, vSum
	lw $t1, len
	div $t2, $t0, $t1 
	sw $t2, vAve

# -----
# Display the Volum to console window

	la $s0, volumes						# first element of volumes
	lw $s1, len							# length of volumes
	la $s2, 0							# counter = index = 0

	la	$a0, sHdr
	li	$v0, 4
	syscall								# print Volumes \n

volumesDisplay:
	li $v0, 4	
	la $a0, blnks
	syscall

	li $v0, 1							# print Volumes[index]
	lw $a0, ($s0)						# load Volumes[index]
	syscall

	add $s0, $s0, 4						# volumes[i + 4] in address
	add $s2, $s2, 1						# counter = index = counter + 1

	rem $t0, $s2, 6						# $t0 = counter % 6

	# div $t0, $s2, 6					# $t0 = counter % 6
	# mfhi $t0

	bnez $t0, notYet					# if counter % 6 = 0, go to a new line

	li $v0, 4 							# | print new Line
	la $a0, newLine						# | but this won't be excecute
	syscall								# | unless counter % 6 = 0

notYet:
	bne $s2, $s1, volumesDisplay 

##########################################################
#  Display results.

	la	$a0, newLine			# print a newline
	li	$v0, 4
	syscall
	la	$a0, newLine			# print a newline
	li	$v0, 4
	syscall

# -----
#  Print min message followed by result.

	la	$a0, minMsg
	li	$v0, 4
	syscall						# print "min = "

	lw	$a0, vMin
	li	$v0, 1
	syscall						# print min

	la	$a0, newLine			# print a newline
	li	$v0, 4
	syscall

# -----
#  Print med message followed by result.

	la	$a0, midMsg
	li	$v0, 4
	syscall						# print "mid = "

	lw	$a0, vMid
	li	$v0, 1
	syscall						# print mid

	la	$a0, newLine			# print a newline
	li	$v0, 4
	syscall

# -----
#  Print max message followed by result.

	la	$a0, maxMsg
	li	$v0, 4
	syscall						# print "max = "

	lw	$a0, vMax
	li	$v0, 1
	syscall						# print max

	la	$a0, newLine			# print a newline
	li	$v0, 4
	syscall

# -----
#  Print sum message followed by result.

	la	$a0, sumMsg
	li	$v0, 4
	syscall						# print "sum = "

	lw	$a0, vSum
	li	$v0, 1
	syscall						# print sum

	la	$a0, newLine			# print a newline
	li	$v0, 4
	syscall

# -----
#  Print ave message followed by result.

	la	$a0, aveMsg
	li	$v0, 4
	syscall						# print "ave = "

	lw	$a0, vAve
	li	$v0, 1
	syscall						# print ave

	la	$a0, newLine			# print a newline
	li	$v0, 4
	syscall

# -----
#  Done, terminate program.

endit:
	la	$a0, newLine			# print a newline
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall						# all done!

.end main

