###########################################################################
#  Name: Thien Nguyen
#  NSHE ID:
#  Section: 1004
#  Assignment: MIPS #3
#  Description: Multi-Dimension_array

#  MIPS assembly language program to check for
#  a magic square.


###########################################################
#  data segment

.data

hdr:		.asciiz	"\nProgram to check a Magic Square. \n\n"

# -----
#  Possible Magic Square #1

msq1:		.word	2, 7, 6
			.word	9, 5, 1
			.word	4, 3, 8

ord1:		.word	3

# -----
#  Possible Magic Square #2

msq2:		.word	16,  3,  2, 13
			.word	 5, 10, 11,  8
			.word	 9,  6,  7, 12
			.word	 4, 15, 14,  1

ord2:		.word	4

# -----
#  Possible Magic Square #3

msq3:		.word	16,  3,  2, 13
			.word	 5, 10, 11,  8
			.word	 9,  5,  7, 12
			.word	 4, 15, 14,  1

ord3:		.word	4

# -----
#  Possible Magic Square #4

msq4:		.word	21,  2,  8, 14, 15
			.word	13, 19, 20,  1,  7
			.word	 0,  6, 12, 18, 24
			.word	17, 23,  4,  5, 11
			.word	 9, 10, 16, 22,  3

ord4:		.word	5

# -----
#  Possible Magic Square #5

msq5:		.word	64, 12, 23, 61, 60, 35, 17, 57
			.word	19, 55, 54, 12, 13, 51, 55, 16
			.word	17, 47, 46, 21, 20, 43, 42, 24
			.word	41, 26, 27, 37, 36, 31, 30, 33
			.word	32, 34, 35, 29, 28, 38, 39, 25
			.word	40, 23, 22, 44, 45, 19, 18, 48
			.word	49, 15, 14, 52, 53, 11, 10, 56
			.word	18, 58, 59, 46, 24, 62, 63, 11

ord5:		.word	8

# -----
#  Possible Magic Square #6

msq6:		.word	 9,  6,  3, 16
			.word	 4, 15, 10,  5
			.word	14, 1,  8, 11
			.word	 7, 12, 13, 1

ord6:		.word	4

# -----
#  Possible Magic Square #7

msq7:		.word	64,  2,  3, 61, 60,  6,  7, 57
			.word	 9, 55, 54, 12, 13, 51, 50, 16
			.word	17, 47, 46, 20, 21, 43, 42, 24
			.word	40, 26, 27, 37, 36, 30, 31, 33
			.word	32, 34, 35, 29, 28, 38, 39, 25
			.word	41, 23, 22, 44, 45, 19, 18, 48
			.word	49, 15, 14, 52, 53, 11, 10, 56
			.word	 8, 58, 59,  5,  4, 62, 63,  1

ord7:		.word	8


# -----
#  Local variables for print header routine.

ds_hdr:		.ascii	"\n-----------------------------------------------------"
			.asciiz	"\nPossible Magic Square #"

nlines:		.asciiz	"\n\n"


# -----
#  Local variables for check magic square.

TRUE = 1
FALSE = 0

rw_msg:		.asciiz	"    Row  #"
cl_msg:		.asciiz	"    Col  #"
d_msg:		.asciiz	"    Diag #"

no_msg:		.asciiz	"\nNOT a Magic Square.\n"
is_msg:		.asciiz	"\nIS a Magic Square.\n"


# -----
#  Local variables for prt_sum routine.

sm_msg:		.asciiz	"   Sum: "


# -----
#  Local variables for prt_matrix function.

newLine:	.asciiz	"\n"

blnks1:		.asciiz	" "
blnks2:		.asciiz	" "
blnks3:		.asciiz	"  "
blnks4:		.asciiz	"   "
blnks5:		.asciiz	"    "
blnks6:		.asciiz	"     "


###########################################################
#  text/code segment

.text

.globl main
.ent main
main:

# -----
#  Display main program header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

# -----
#  Set data set counter.

	li	$s0, 0

# -----
#  Check Magic Square #1

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq1
	lw	$a1, ord1
	jal	prtSquare

	la	$a0, msq1
	lw	$a1, ord1
	jal	chkMagicSqr

# -----
#  Check Magic Square #2

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq2
	lw	$a1, ord2
	jal	prtSquare

	la	$a0, msq2
	lw	$a1, ord2
	jal	chkMagicSqr

# -----
#  Check Magic Square #3

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq3
	lw	$a1, ord3
	jal	prtSquare

	la	$a0, msq3
	lw	$a1, ord3
	jal	chkMagicSqr

# -----
#  Check Magic Square #4

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq4
	lw	$a1, ord4
	jal	prtSquare

	la	$a0, msq4
	lw	$a1, ord4
	jal	chkMagicSqr

# -----
#  Check Magic Square #5

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq5
	lw	$a1, ord5
	jal	prtSquare

	la	$a0, msq5
	lw	$a1, ord5
	jal	chkMagicSqr

# -----
#  Check Magic Square #6

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq6
	lw	$a1, ord6
	jal	prtSquare

	la	$a0, msq6
	lw	$a1, ord6
	jal	chkMagicSqr

# -----
#  Check Magic Square #7

	addu	$s0, $s0, 1
	move	$a0, $s0
	jal	prtHeader

	la	$a0, msq7
	lw	$a1, ord7
	jal	prtSquare

	la	$a0, msq7
	lw	$a1, ord7
	jal	chkMagicSqr

# -----
#  Done, terminate program.

	li	$v0, 10
	syscall

.end main

# -------------------------------------------------------
#  Function to check if a two-dimensional array
#  is a magic square.

#  Algorithm: 
#	Find sum for first row

#	Check sum of each row (n row's)
#	  if any sum not equal initial sum, set NOT magic square.
#	Check sum of each column (n col's)
#	  if any sum not equal initial sum, set NOT magic square.
#	Check sum of main diagonal 1
#	  if sum not equal initial sum, set NOT magic square.
#	Check sum of main diagonal 2
#	  if sum not equal initial sum, set NOT magic square.

# -----
#  Formula for multiple dimension array indexing:
#	addr(row,col) = base_address + (rowindex * col_size 
#							+ colindex) * element_size

# ----- # TODO chkMagicSqr(arr, order)
#*  Arguments:
#*	$a0 - address of two-dimension two-dimension array
#*	$a1 - order/size of two-dimension array


#	YOUR CODE GOES HERE

.globl chkMagicSqr
.ent chkMagicSqr
chkMagicSqr:

	subu $sp, $sp, 24	
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)

	# set fp pointing to first arg on stack (array)
	addu $fp, $sp, 24 

	move $s0, $a0						#* $s0 = array address
	move $s1, $a1						#* $s1 = column size 
	li $t9, TRUE						#* $t9 = whether or not it's a magic square

# ----
# Calculating the sum of the first row, 
# r = 0 (fixed), c = index 0 --> s1

	li $t0, 0    						# t0 = first row = r (fixed)
	li $t1, 0    						# t1 = column_index -- will index
	li $s2, 0							# s2 = sum = 0

sumFirstRow:
	mul $t2, $t0, $s1					#* t2 = first row * column_size -- (1)
	add $t2, $t2, $t1 					#* t2 = (1) + column_index  -- (2)
	mul $t2, $t2, 4						#* t2 = (2) * data_size  -- (3)
	add $t2, $t2, $s0					#* t2 = (3) + base_a  -- (4)

	lw $t3, ($t2)						# t3 = value at that index
	add $s2, $s2, $t3  					# s2 = sum + t3

	addu $t1, $t1, 1					# t1 = ++column_index
	blt $t1, $s1, sumFirstRow			# until we get the first row sum

	la $a0, rw_msg
	move $a1, $t0
	move $a2, $s2
	jal prtMsg

# ----
# Check the sum of each row 
# r = 1 --> s1, c = 0 --> s1

	li $t1, 0    						# t1 = column_index -- index first
	li $t0, 1    						# t0 = second row   -- index second
	li $s3, 0							# s3 = sum = 0

sumEachRow:
	mul $t2, $t0, $s1 					#* t2 = row * column_size   -- (1)
	add $t2, $t2, $t1 					#* t2 = (1) + column_index  -- (2)
	mul $t2, $t2, 4						#* t2 = (2) * data_size     -- (3)
	add $t2, $t2, $s0					#* t2 = (3) + base_adress   -- (4)

	lw $t3, ($t2)						# t3 = value at that index
	add $s3, $s3, $t3  					# s3 = sum + t3

	addu $t1, $t1, 1					# t1 = ++column_index
	blt $t1, $s1, sumEachRow			# until we get to the end of size

	la $a0, rw_msg						# $a0 = address of message
	move $a1, $t0						# $a1 = current row
	move $a2, $s3						# $a2 = sum of that row
	jal prtMsg

	beq $s2, $s3, nevermind				# if sum not equal, not magic square
	li $t9, FALSE

nevermind:
	li $s3, 0							# s3 = sum = 0, reset it
	li $t1, 0    						# t1 = column_index -- will index, reset
	addu $t0, $t0, 1 					# t0 = ++row_index
	blt $t0, $s1, sumEachRow			# until we get the sum of each row

# -----
# Check sum of each column (n col's)
# r = 0 --> s1, c = 0 --> s1

	li $t0, 0    						# t0 = row_index    -- index first
	li $t1, 0    						# t1 = column_index -- index second
	li $s3, 0							# s3 = sum = 0

sumEachColumn:

	mul $t2, $t0, $s1 					#* t2 = row * column_size   -- (1)
	add $t2, $t2, $t1 					#* t2 = (1) + column_index  -- (2)
	mul $t2, $t2, 4						#* t2 = (2) * data_size     -- (3)
	add $t2, $t2, $s0					#* t2 = (3) + base_a        -- (4)

	lw $t3, ($t2)						# t3 = value at that index
	add $s3, $s3, $t3  					# s3 = sum + t3

	addu $t0, $t0, 1 	       			# ++row
	blt $t0, $s1, sumEachColumn			# until we get the sum of each column

	la $a0, cl_msg						# $a0 = address of message
	move $a1, $t1						# $a1 = current column
	move $a2, $s3						# $a2 = sum of that column
	jal prtMsg

	beq $s2, $s3, nevermind2			# if sum not equal, not magic square
	li $t9, FALSE

nevermind2:
	li $s3, 0							# s3 = sum = 0, reset it
	li $t0, 0    						# t0 = row --> index first, reset it
	addu $t1, $t1, 1 					# t1 = ++column_index
	blt $t1, $s1, sumEachColumn			# until we get the sum of each column

# -----
# Check sum of first diagonal from top-left -> bottom-right
# addr(row,col) = base_address + (rowindex * col_size + rowindex) * 4
# r = c = 0 --> s1

	li $t0, 0    						# t0 = row --> index first
	li $t1, 1
	li $s3, 0							# s3 = sum = 0

sum1Diagonal:

	mul $t2, $t0, $s1 					#* t2 = row * column_size -- (1)
	add $t2, $t2, $t0 					#* t2 = (1) + rowindex    -- (2)
	mul $t2, $t2, 4						#* t2 = (2) * data_size   -- (3)
	add $t2, $t2, $s0					#* t2 = (3) + base_a      -- (4)

	lw $t3, ($t2)						# t3 = value at that index
	add $s3, $s3, $t3  					# s3 = sum + t3

	addu $t0, $t0, 1 	       			# ++row
	blt $t0, $s1, sum1Diagonal			# until we get the sum of first diagonal

	la $a0, d_msg						# $a0 = address of message
	move $a1, $t1  						# $a1 = diag 1
	move $a2, $s3						# $a2 = sum of that diag
	jal prtMsg

	beq $s2, $s3, nevermind3			# if sum not equal, not magic square
	li $t9, FALSE

# -----
# Check sum of first diagonal from top-right -> bottom-left (special)
# addr(row,col) = base_address + (rowindex * col_size + (size - 1 - rowindex)) * 4
# r = 0 --> s1, c = s1 - 1 - 0 --> s1

nevermind3:

	li $t0, 0    						# t0 = row --> index first
	subu $t1, $s1, 1,					# t1 = column --> s1 - 1 - t0
	subu $t1, $t1, $t0					
	li $s3, 0							# s3 = sum = 0
	li $t4, 2

sum2Diagonal:

	mul $t2, $t0, $s1 					#* t2 = row * column_size -- (1)
	add $t2, $t2, $t1 					#* t2 = (1) + (special)   -- (2)
	mul $t2, $t2, 4						#* t2 = (2) * data_size   -- (3)
	add $t2, $t2, $s0					#* t2 = (3) + base_a      -- (4)

	lw $t3, ($t2)						# t3 = value at that index
	add $s3, $s3, $t3  					# s3 = sum + t3

	addu $t0, $t0, 1 	       			# ++row
	subu $t1, $s1, 1,					# t1 = column --> s1 - 1 - t0
	subu $t1, $t1, $t0
	blt $t0, $s1, sum2Diagonal			# until we get the sum of first diagonal

	la $a0, d_msg						# $a0 = address of message
	move $a1, $t4							# $a1 = diag 1
	move $a2, $s3						# $a2 = sum of that diag
	jal prtMsg

	beq $s2, $s3, nevermind4			# if sum not equal, not magic square
	li $t9, FALSE

# TODO NOTE: SEE IF CAN SIMPLIFY THE CODE 

nevermind4:
	beq $t9, FALSE, notMagicSquare

	li, $v0,  4							
	la $a0, newLine						#* $a0 = newLine
	syscall

	li, $v0, 4
	la $a0, is_msg
	syscall

	b ended

notMagicSquare:

	li, $v0,  4							
	la $a0, newLine						#* $a0 = newLine
	syscall

	li, $v0, 4
	la $a0, no_msg
	syscall	

ended:

	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addu $sp, $sp, 24	
	jr $ra

.end chkMagicSqr

# -------------------------------------------------------
#  Function to display sum message.

# ----- # TODO prtMsg(str, num, sum)
#*  Arguments: 
#*	$a0 - message (address)
#*	$a1 - row/col/diag number (value)
#*	$a2 - sum

.globl prtMsg
.ent prtMsg
prtMsg:

	subu $sp, $sp, 16	
	sw $s2, 12($sp)
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)

# set fp pointing to first arg on stack (array)
	addu $fp, $sp, 16 

	move $s0, $a0						#* $s0 = msg address
	move $s1, $a1						#* $s1 = number of where we at
	move $s2, $a2						#* $s2 = sum

printSum:

	li, $v0,  4							
	la $a0, newLine						#* $a0 = newLine
	syscall

	li $v0, 4	
	la $a0, blnks2						#* $a0 = "    "
	syscall

	li $v0, 4
	la $a0, ($s0)						#* $a0 = msg address
	syscall

	li $v0, 1
	la $a0, ($s1)						#* $0 = number of where we at
	syscall

	li $v0, 4
	la $a0, blnks2						#* $a0 = "    "
	syscall

	li $v0, 4
	la $a0, sm_msg						#* $a0 = sum msg
	syscall

	li $v0, 1
	la $a0, ($s2)						#* $a0 = sum
	syscall

	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addu $sp, $sp, 16	
	jr $ra

	jr $ra
.end prtMsg

# ---------------------------------------------------------
#  Print magic square.
#  Note, a magic square is an N x N array.

# ---- # TODO prtSquare(arr, order)
#*  Arguments: 
#*	$a0 - starting address of square to ptint
#*	$a1 - order (size) of the square

.globl prtSquare
.ent prtSquare
prtSquare:

	subu $sp, $sp, 24	
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)

	# set fp pointing to first arg on stack (array)
	addu $fp, $sp, 24 

	move $s0, $a0						#* $s0 = array address
	move $s1, $a1						#* $s1 = n 

# index and print the value of it, since we go from left to right
# then print from top to bottom

	li $t1, 0    						# t1 = column_index -- index first
	li $t0, 0    						# t0 = secondt row -- index second

printing:

	li $v0, 4	
	la $a0, blnks5
	syscall

	mul $t2, $t0, $s1 					#* t2 = row * column_size   -- (1)
	add $t2, $t2, $t1 					#* t2 = (1) + column_index  -- (2)
	mul $t2, $t2, 4						#* t2 = (2) * data_size     -- (3)
	add $t2, $t2, $s0					#* t2 = (3) + base_adress   -- (4)

	li $v0, 1							# call code to sys-write
	lw $a0, ($t2)						# a0 = value at that index						
	syscall

	addu $t1, $t1, 1					# t1 = ++column_index
	blt $t1, $s1, printing				# until we get to the end of size

	rem $s2, $t1, $s1 
	bnez $s2, nuhUh

	li, $v0, 4							# print newline
	la $a0, newLine
	syscall

nuhUh:

	li $s3, 0							# s3 = sum = 0, reset it
	li $t1, 0    						# t1 = column_index -- will index, reset
	addu $t0, $t0, 1 					# t0 = ++row_index
	blt $t0, $s1, printing				# until we get the sum of each row

	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addu $sp, $sp, 24	
	jr $ra
.end prtSquare

# ---------------------------------------------------------
#  Display simple header for data set (as per asst spec's).

.globl	prtHeader
.ent	prtHeader
prtHeader:
	subu	$sp, $sp, 4
	sw	$s0, ($sp)

	move	$s0, $a0

	la	$a0, ds_hdr
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, nlines
	li	$v0, 4
	syscall

	lw	$s0, ($sp)
	addu	$sp, $sp, 4

	jr	$ra
.end	prtHeader







