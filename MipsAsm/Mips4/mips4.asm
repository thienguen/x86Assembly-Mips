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

entNpmt:	.asciiz	"\n\n\nEnter N (3-45, 0 to terminate): "

n:		.word	0
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

	move	$s0, $zero
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

	add	$s0, $s0, 1			# next loop?
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










	jr $ra

.end getNumber

#####################################################################
#  Display fibonacci sequence.

# ----- # TODO fibonacci(num)
#    Arguments:
#	$a0 - n

#    Returns:
#	fibonacci(n)

.globl fibonacci
.ent fibonacci
fibonacci:















	jr $ra

.end fibonacci

#####################################################################
#  Display perrin sequence.

# ----- # TODO perrin()
#    Arguments:
#	$a0 - n

#    Returns:
#	perrin(n)

.globl perrin
.ent perrin
perrin:



















	jr $ra

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
#  Arguments:
#	$a0 - N number (value)
#	$a1 - fibonacci number (value)
#	$a2 - perrin number (value)

.globl prtLine
.ent prtLine
prtLine:














	jr $ra
.end prtLine

#####################################################################
#  Print an appropriate number of blanks based on
#  size of the number.

# ----- # TODO prtBlnks()
#  Arguments:
#	$a0 - number (value)
#	$a1 - max number of digits for number (value)

.globl prtBlnks
.ent prtBlnks
prtBlnks:










	jr $ra
.end prtBlnks

#####################################################################
