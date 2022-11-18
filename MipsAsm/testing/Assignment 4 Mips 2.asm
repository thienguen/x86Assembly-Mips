#  Example program to display 

###########################################################
# TODO data segment

.data

# DATA GOES HERE
var1: .word 50
var2: .word 60
ans1: .word 0
ans2: .word 0
ans3: .word 0

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

# Load the register with the address of the var
	lw $t7, var1
	lw $t8, var2

	beq $t7, $zero, equaleq0
	j ifnotzero
equaleq0:
	beq $t7, $t8, equaleq
	
ifnotzero:
	mul $t9, $t7, $t8
	sub $t7, $t7, $t8
	add $t8, $t9, $t7
	sub $t8, $t8, $t9
	or $t7, $t8, $t9
	sllv $t7, $t8, $t7
	lw $t9, ans1
	div $t9, $t7
	lw $t7, ans2
	div $t9, $t7
	lw $t8, ans3
	div $t8, $t7

# -----
#  Done, terminate program.

	li	$v0, 10
	syscall					# all done!

.end main




