#  Example program to display 

###########################################################
# TODO data segment

.data

# DATA GOES HERE
var1: .word 10
var2: .word 20
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

	lw $t5, var1
	lw $t6, var2

	bne $t5, $t6, setTwo
	setOne:	lw $t7, var1
		j setFive
	setTwo:	lw $t7, var2
		setThree:	beq $t5, $t6, setFour
			jr $ra
		setFour:	add $t7, $t7, $t6
			j setFive
		setFive:	lw	$t3, ans3
			beq $0, $t3, setSix
			jr $ra
		li $v0, 4 # print string
		la $a0, ans1
		syscall

	move $v0,$zero    # exit

		jr $ra
	#out_message: .asciiz "string to print

# -----
#  Done, terminate program.

	li	$v0, 10
	syscall					# all done!

.end main




