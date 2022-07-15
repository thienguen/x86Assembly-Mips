#  CS 218, MIPS Assignment #0

#  Example program to display a list of
#  numbers and find the mimimum and maximum.

###########################################################
# TODO data segment

.data

aSides1:		.word	19, 17, 15, 13, 11, 19, 17, 15, 13, 11
                .word	10,  3, 12, 14, 16, 18, 10, 21, 2, 190

len1:			.word	20

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





    la $a0, aSides1
    lw $a1, len1
    jal median


    li $a0, 84
    jal divideBy

    move $t5, $v0 











# -----
#  Done, terminate program.

	li	$v0, 10
	syscall					# all done!

.end main





#####################################################################
# ---- # TODO
#  MIPS assembly language function  that
#*   $a0 -- address of list
#*   $a1 -- len

.globl median
.ent median
median:

    subu $sp, $sp, 12 					# preserve registers
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	# set fp pointing to first arg on stack (array)
	addu $fp, $sp, 12 

    move $s0, $a0                       # $s0 = address of list
    move $s1, $a1                       # $s1 = len

    div $t1, $s1, 2                     # t1 = len / 2
    mul $t2, $t1, 4                     # t2 = index * 4 = offset

    add $t3, $s0, $t2                   # t3 = address of middle element
    lw $t4, ($t3)                       # t4 = value 

    rem $t5, $s1, 2
    bnez $t5, oddArray

    sub $t3, $t3, 4                     # t3 = address of previous         
    lw $t6, ($t3)                       # t6 = value

    add $t4, $t4, $t6                   # t4 = t4 + t6
    div $t4, $t4, 2

oddArray:
    move $v0, $t4

	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addu $sp, $sp, 12

    jr $ra
.end median

#####################################################################
# ---- # TODO baselen[i] = 2 * sqrt(slantlens[i]^2 - heights[i]^2)
#  MIPS assembly language function  that
#*   $a0      -- address slantlens
#*   $a1      -- heights
#*   $a2      -- address len
#*   $a3      -- address baselen

#*  Return value via address:

#*   $($fp)   -- address bMin
#*   $4($fp)  -- address bMed
#*   $8($fp)  -- address bMax
#*   $12($fp) -- address bAve

# calcBases(slantLens, heights, len, baseLens, bMin, bMed, bMax, bAve)
.globl calcBases
.ent calcBases
calcBases:
	subu $sp, $sp, 40 					# preserve registers
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
    sw $s6, 24($sp)
    sw $s7, 28($sp)
	sw $fp, 32($sp)
	sw $ra, 36($sp)

	# set fp pointing to first arg on stack (array)
	addu $fp, $sp, 40 

	move $s0, $a0 						# | address of slantlens[i] 
	move $s1, $a1 						# | address of heights[i]
	move $s2, $a2 						# | len
	move $s3, $a3 						# | baselens[i]

	lw $s4, ($fp)						# | address of bMin
	lw $s5, 4($fp)                      # | address of bMed
	lw $s6, 8($fp)                      # | address of bMax
    lw $s7, 12($fp)                     # | address of bAve

# ----
# Calculate the algo
    move $t2, $s2                       # t2 = len

baseLoop:
    mul $t0, $s0, $s0                   # t0 = slantlens[i]^2
    mul $t1, $s1, $s1                   # t1 = heights[i]^2
    sub $t0, $t0, $t1                   # t0 = t0 - t1

    move $a0, $t0                       # a0 = t0
    jal iSqrt                           # v0 = sqrt(a0)

    move $t0, $v0                       # t0 = v0
    mul $t0, $t0, 2                     # t0 = t0 * 2

    sw $t0, ($s4)                       # bMin = t0

    addu $s0, $s0, 4                    # s0 + 4 in address 
    addu $s1, $s1, 4                    # s1 + 4 in address
    addu $s3, $s3, 4                    # s3 + 4 in address

    subu $t2, $t2, 1                    # loop control len
    bnez $t2, baseLoop

# ----
# Min, Max 
    lw $t0, ($s3)                       # t0 = baselens[i]
    sw $t0, ($s4)                       # bMin = t0

    move $t2, $s2                       # t2 = len
    mul $t1, $t1, 4                     # address offset
    sub $t1, $t1, 4                     # last element offset

    add $t0, $s3, $t1                   # t0 = address of last element
    lw $t1, ($t0)                       # t1 = baselens[len - 1]
    sw $t1, ($s6)                       # bMax = t1

# ----
# Sum, Ave

    move $t0, $s3                       # t0 = address of baselens[i]
    move $t2, $s2                       # t2 = len
    li $t3, 0                           # t3 = sum

sumLoop:

    lw $t1, ($t0)                       # t1 = baselens[i]
    add $t3, $t3, $t1                   # t3 = t3 + t1

    addu $t0, $t0, 4                    # t0 + 4 in address
    subu $t2, $t2, 1                    # loop control len

    bnez $t2, sumLoop

    div $t3, $t3, $s2                   # t3 = t3 / len
    sw $t3, ($s7)                       # bAve = t3

# ----
# Median

    move $t2, $s2                       # t2 = len
    move $t3, $s3                       # t3 = address of baselens[i]

    div $t2, $s2, 2                     # t2 = len / 2
    mul $t4, $t2, 4                     # t4 = index * 4 = offset

    add $t5, $s3, $t4                   # t5 = address of middle element
    lw $t6, ($t5)                       # t6 = value 

    rem $t4, $s2, 2
    bnez $t4, oddMedian

    sub $t5, $t5, 4                     # t5 = address of previous         
    lw $t7, ($t5)                       # t6 = value

    add $t6, $t6, $t7                   # t6 = t6 + t7
    div $t6, $t6, 2

oddMedian:
    sw $t6, ($s5)                       # bMed = t6

    lw $s0, ($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
    lw $s6, 24($sp)
    lw $s7, 28($sp)
	lw $fp, 32($sp)
	lw $ra, 36($sp)
	addu $sp, $sp, 40

    jr $ra
.end calcBases

#####################################################################
# ---- # TODO int iSqrt(int num) 
#  MIPS assembly language function  that
#  int isqrt(int num) {
#    int ret = 0;
# The second-to-top bit is set
#    int bit = 1 << 30;
#
# "bit" starts at the highest power of four <= the argument.
#     while (num < bit) {
#         bit >>= 2;
#     }
# 
#     while (bit != 0) {
#         if (num < ret + bit) {
#         ret >>= 1;
#         } else {
#         num -= ret + bit;
#         ret = (ret >> 1) + bit;
#         }
#         bit >>= 2;
#     }
#     return ret;
# }

iSqrt:
    move  $v0, $zero        # initalize return
    move  $t1, $a0          # move a0 to t1

    addi  $t0, $zero, 1
    sll   $t0, $t0, 30      # shift to second-to-top bit

isqrt_bit:
    slt   $t2, $t1, $t0     # num < bit
    beq   $t2, $zero, isqrt_loop

    srl   $t0, $t0, 2       # bit >> 2
    j     isqrt_bit

isqrt_loop:
    beq   $t0, $zero, isqrt_return

    add   $t3, $v0, $t0     # t3 = return + bit
    slt   $t2, $t1, $t3
    beq   $t2, $zero, isqrt_else

    srl   $v0, $v0, 1       # return >> 1
    j     isqrt_loop_end

isqrt_else:
    sub   $t1, $t1, $t3     # num -= return + bit
    srl   $v0, $v0, 1       # return >> 1
    add   $v0, $v0, $t0     # return + bit

isqrt_loop_end:
    srl   $t0, $t0, 2       # bit >> 2
    j     isqrt_loop

isqrt_return:
    jr  $ra
.end iSqrt

#####################################################################
# ---- # TODO diviveByPnum / stackbase_variables

.globl divideBy
.ent divideBy
divideBy:
    subu  $sp, $sp, 16
    sw    $ra, 12($sp)
    sw    $fp, 8($sp)
    sw    $s0, 4($sp)

    addu $fp, $sp, 16

    move $s0, $a0

    li $t0, 42
    sw $t0, 0($sp)

    lw $t1, 0($sp)
    div $t2, $s0, $t1

    move $v0, $t2

    lw    $s0, 4($sp)
    lw    $fp, 8($sp)
    lw    $ra, 12($sp)
    addiu $sp, $sp, 16

    jr $ra
.end divideBy

