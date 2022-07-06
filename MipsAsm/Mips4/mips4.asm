#  CS 218, MIPS Assignment #4

#  Name: Thien Nguyen
#  NSHE ID:
#  Section: 1004
#  Assignment: MIPS #4
#  Description: Recursion

#  Write a simple assembly language program to
#  compute the Fibonacci and Perrin Sequences.


#####################################################################
#  data segment

.data

# -----
#  Local variables for main.

hdr:		.ascii	"\nMIPS Assignment #4\n"
			.asciiz	"Fibonacci and Perrin Numbers Program"

entNpmt:	.asciiz	"\n\n\nEnter N (3-45, 0 to terminate):\n "

n:			.word	0
newLine:	.asciiz	"\n"
doneMsg:	.asciiz	"\n\nGame Over, thank you for playing.\n"

# -----
#  Local variables for getNumber() function.

msg0:		.asciiz	"\nThis should be quick.\n"
msg1:		.asciiz	"\nThis is going to take a while (n>20).\n"
msg2:		.asciiz	"\nThis is going to take a long time (n>30).\n"
msg3:		.asciiz	"\nThis going to take a really long time (n>35).\n"
msg4:		.asciiz	"\nThis is going to take a very long time (> 30 minutes).\n"
errMsg:		.asciiz	"\nError, value of range.  Please re-enter.\n"

# -----
#  Local variables for prtNumber() function.

nMsg:		.asciiz	"\nnum = "
fMsg:		.asciiz	"   fibonacci = "
pMsg:		.asciiz	"   perrin = "

# -----
#  Local variables for prtBlanks() routine.

space:		.asciiz	" "

#####################################################################
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
#  Read N (including error checking and display of message).

doAgain:
	jal	getNumber
	sw	$v0, n

	beqz	$v0, allDone

# -----
#  Main loop to generate and display fibonacci and perrin numbers.

	move $s0, $zero
	lw	$s1, n

loop:
	move	$a0, $s0			# get fibonacci(n)
	jal	fibonacci
	move	$s2, $v0

	move	$a0, $s0			# get perrin(n)
	jal	perrin
	move	$s3, $v0

	move	$a0, $s0			# print output line
	move	$a1, $s2
	move	$a2, $s3
	jal	prtLine

	add	$s0, $s0, 1				# next loop?
	ble	$s0, $s1, loop

	j	doAgain

# -----
#  Done, terminate program.

allDone:
	la	$a0, doneMsg
	li	$v0, 4
	syscall					# print header

	li	$v0, 10
	syscall					# au revoir...

.end main

#####################################################################
#  Get the N value from the user.
#  Peform appropriate error checking and display status message.

# ----- # TODO getNumber()
#    Arguments:
#	none

#    Returns:
#	N value ($v0)

.globl getNumber
.ent getNumber
getNumber:

# ----
#  Prolouge
	subu $sp, $sp, 4
	sw $s0, 0($sp)

userInput:
	li	$v0, 4
	la	$a0, entNpmt 					# Enter N (3-45, 0 to terminate):
	syscall

	li $v0, 5							# read user input
	syscall

	move $s0, $v0

	beqz $v0, sayNoMore					# if user entered 0, terminate program
	blt $v0, 3, invalid					# n < 3  ? invalid : continue
	bgt $v0, 45, invalid				# n > 45 ? invalid : continue

	ble $v0, 25, printMsg0				#  3 < n <= 25 print message
	ble $v0, 30, printMsg1				# 25 < n <= 30 print message
	ble $v0, 35, printMsg2				# 30 < n <= 35 print message
	ble $v0, 45, printMsg3				# 35 < n <= 45 print message

# ----
# Epilouge
sayNoMore:
	move $v0, $s0
	lw $s0, 0($sp)						# restore $s0
	add	$sp, $sp, 4						# pop $s0
	jr $ra								# return

invalid:								# Error, value of range.  Please re-enter
	li	$v0, 4
	la	$a0, errMsg
	syscall
	j userInput

printMsg0:								# This should be quick.
	li	$v0, 4
	la	$a0, msg0
	syscall
	j sayNoMore

printMsg1:								# This is going to take a while (n>20).
	li	$v0, 4
	la	$a0, msg1
	syscall
	j sayNoMore

printMsg2:								# This is going to take a long time (n>30).
	li	$v0, 4
	la	$a0, msg2
	syscall
	j sayNoMore

printMsg3:								# This going to take a really long time (n>35).
	li	$v0, 4
	la	$a0, msg3
	syscall
	j sayNoMore

printMsg4:								# This is going to take a very long time (> 30 minutes).
	li	$v0, 4
	la	$a0, msg4
	syscall
	j sayNoMore

.end getNumber							# the whole function

#####################################################################
#  Display fibonacci sequence.

# ----- # TODO fibonacci(num)
#    Arguments:
#*	$a0 - n

#    Returns:
#*  $v0 - fibonacci(n)

#* if (n <= 1)
#*     return n;
#* return fib(n-1) + fib(n-2);

.globl fibonacci
.ent fibonacci
fibonacci:

	subu $sp, $sp, 8
	sw $s0, ($sp)
	sw $ra, 4($sp)

	move $v0, $a0						# v0 = a0 = n
	ble $a0, 1, fibDone					#* if n <= 1, return 1

	move $s0, $a0						# s0 = a0 = n, save a copy of n

	sub $a0, $a0, 2						# a0 = n - 2, calculate
	jal fibonacci						# v0 = fibonacci(n-2)

	sub $a0, $s0, 1						# a0 = n - 1, calculate
	move $s0, $v0						# s0 = fibonacci(n-2)
	jal fibonacci						# v0 = fibonacci(n-1)

	add $v0, $v0, $s0					#* v0 = fibonacci(n-1) + fibonacci(n-2)
										#* v0 = s0 + v0, return
fibDone:

	lw $s0, ($sp)
	lw $ra, 4($sp)
	add $sp, $sp, 8
	jr $ra

.end fibonacci

#####################################################################
#  Display perrin sequence.

# ----- # TODO perrin()
#    Arguments:
#*	$a0 - n

#    Returns:
#*	perrin(n) - $v0

#*  if (n == 0)
#*      return 3;
#*  if (n == 1)
#*      return 0;
#*  if (n == 2)
#*      return 2;
#*  return per(n - 2) + per(n - 3);

#*							    per(8)  
#*					   /                      \     
#*				   per(6)                    per(5)   
#*				/         \                /        \
#*		 per(4)          per(3)         per(3)    per(2)
#*		/     \        /       \        /    \       
#*	per(2) per(1) | per(1)  per(0) | per(1)  per(0)

.globl perrin
.ent perrin
perrin:
	subu $sp, $sp, 8
	sw $s0, ($sp)
	sw $ra, 4($sp)
	move $s0, $a0						# s0 = a0 = n

	beq $a0, 0, return0 				#* if n == 0, return 3
	beq $a0, 1, return1 				#* if n == 1, return 0
	beq $a0, 2, return2 				#* if n == 2, return 2

	move $s0, $a0						# s0 = a0 = n, save a copy of n

	sub $a0, $a0, 2						# a0 = n - 2, calculate
	jal perrin							# v0 = perrin(n - 2)

	sub $a0, $s0, 3						# a0 = n - 3, calculate
	move $s0, $v0						# s0 = perrin(n - 2)
	jal perrin							# v0 = perrin(n - 3)

	add $v0, $v0, $s0					#* v0 = perrin(n - 2) + perrin(n - 3)
										#* v0 = s0 + v0, return

perrinDone:
	lw $s0, ($sp)
	lw $ra, 4($sp)
	add $sp, $sp, 8
	jr $ra

return0:
    li $v0, 3
    j perrinDone

return1:     
    li $v0, 0
    j perrinDone

return2:     
    li $v0, 2
    j perrinDone

.end perrin



#####################################################################
#  Print a line as per asst #4 specificiations.

# ----- # TODO prtLine()
# Line should look like:
#	num =  0   fibonacci =          0   perrin = 3

# Format:
#	numB=BnnBBBfibonacciB=BffffffffffBBBperrinB=Bppppppp

#	where	B = blank space
#		f = actual fibonacci number (123...)
#		p = actual perrin number (123...)

# Note,	num will always be 1-2 digits.
#	fibonacci will always b 1-10 digits.
#	perrin will always be 1-7 digits.

# -----
#   Arguments:
#*	$a0 - N number (value)
#*	$a1 - fibonacci number (value)
#*	$a2 - perrin number (value)

#   nn = a0 = N (value)
#  numB=B|nn|BBBfibonacciB=B|ffffffffff|BBBperrinB=B|ppppppp
#   2 spaces total for N = a0
#  10 spaces total for f  
#   7 spaces total for p

# nMsg:		.asciiz	"\nnum = "
# fMsg:		.asciiz	"   fibonacci = "
# pMsg:		.asciiz	"   perrin = "

.globl prtLine
.ent prtLine
prtLine:

	subu $sp, $sp, 24	
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)

	# set fp pointing to first arg on stack (array)
	addu $fp, $sp, 24 

	move $s0, $a0						# s0 = a0 = N
	move $s1, $a1						# s1 = a1 = fibonacci
	move $s2, $a2						# s2 = a2 = perrin

	li $v0, 4							# v0 = 4, call code
	la $a0, nMsg						# a0 = nMsg
	syscall								#* print numB=B

	move $a0, $s0						# a0 = N
	li $a1, 2							# a1 = 2 (max digits)
	jal prtBlnks						#* print nn

	li $v0, 1							# v0 = 1,
	move $a0, $s0						# a0 = nn
	syscall								#* print nn

	li $v0, 4							# v0 = 3, print BBB
	la $a0, fMsg						# a0 = fMsg
	syscall								#* print BBBfibonacciB=B

	move $a0, $s1						# a0 = fibonacci
	li $a1, 10							# a1 = 10 (max digits)
	jal prtBlnks						#* print fffffffffff

	li $v0, 1							# v0 = 1, call code
	move $a0, $s1						# a0 = s1 = fibonacci 
	syscall								#* print ffffffffff

	li $v0, 4							# v0 = 4, call code
	la $a0, pMsg						# a0 = pMsg
	syscall								#* print BBBperrinB=B

	move $a0, $s2						# a0 = perrin
	li $a1, 7							# a1 = 7 (max digits)
	jal prtBlnks						#* print ppppppp

	li $v0, 1							# v0 = 1, call code
	move $a0, $s2						# a0 = s2 = perrin
	syscall								#* print ppppppp

	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addu $sp, $sp, 24	
	jr $ra
.end prtLine

#####################################################################
#  Print an appropriate number of blanks based on
#  size of the number.

# ----- # TODO prtBlnks()
#   Arguments:
#* 	$a0 - number (value)
#*	$a1 - max number of digits for number (value)

# we divide by 10 to get the number of digits
# loop ( i = 0; a0 < 0; ++i )
# 		a0 / 10
# 		if ( a0 < 0 ) exit loop
#		keep looping
# after exit the loop, we got i, as how many digits
# pass it in printSpace loop, the space would be 
# (a1 - i) = actual spaces, use it as counter for printing each space

# eg, if max was 2, number was 1, minus that we got the space of 1

.globl prtBlnks
.ent prtBlnks
prtBlnks:

	move $t0, $a0						# t0 = a0 = number
	move $t1, $a1						# t1 = a1 = max number of digits
	li $t2, 0							# t2 = digits count = 1

digitsCount:
	div $t0, $t0, 10					# t0 = t0 / 10
	add $t2, $t2, 1						# t2 = t2 + 1
	bgt $t0, $zero, digitsCount			# if t0 > 0, continue

	sub $t1, $t1, $t2					# t1 = t1 - t2, the actual spaces
	beqz $t1, doneSpace     			# if t0 == 0, exit

printSpaces:
	li $v0, 4
	la $a0, space
	syscall

	sub $t1, $t1, 1						# t1 = t1 - 1
	bnez $t1, printSpaces		# if t1 != 0, keep printing

doneSpace:
	jr $ra
.end prtBlnks

#####################################################################

# algo for fibonacci:
# digits is < 10       then 9 spaces
# digits is < 100      then 8 spaces
# digits is < 1000     then 7 spaces
# digits is < 10000    then 6 spaces
# digits is < 100000   then 5 spaces
# digits is < 1000000  then 4 spaces
# digits is < 10000000 then 3 spaces

# algo for perrin
# digits is < 10       then 6 spaces
# digits is < 100      then 5 spaces
# digits is < 1000     then 4 spaces
# digits is < 10000    then 3 spaces