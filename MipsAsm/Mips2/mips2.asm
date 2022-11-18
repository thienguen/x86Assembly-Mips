###########################################################################
#  Name: Thien Nguyen
#  NSHE ID:
#  Section: 1004 
#  Assignment: MIPS #2
#  Description: Become familia with Mips, and wrote 5 function()

#  CSC 218, MIPS Assignment #2

#  MIPS assembly language main program and functions:

#  * MIPS assembly language function, surfaceAreas(), 
#    to calculate the surface areas for each of the rectangular
#    parallelepipeds in a set of rectangular parallelepipeds.

#  * Write a MIPS assembly language function, printAreas(), to
#    display the array of surfaceAreas.  The numbers should be
#    printed 5 per line (see example).

#  * Write a MIPS assembly language function, bubbleSort(), to sort
#    an array of surface areas into ascending order (small to large).

#  * Write a MIPS assembly language function, surfaceAreasStats(), that will
#    find the minimum, median, maximum, sum, and floating point average.
#    You should find the minimum, median, and maximum after the list is
#    sorted.  The average should be calculated as a floating point value.

#  * Write a MIPS assembly language function, printStats(), to print the
#    statistical information (minimum, maximum, median, sum, average) in
#    the format shown in the example.

#####################################################################
#  data segment

.data

# -----
#  Data declarations for main.

aSides1:		.word	19, 17, 15, 13, 11, 19, 17, 15, 13, 11
				.word	10,  3, 12, 14, 16, 18, 10, 21, 2, 190
bSides1:		.word	34, 32, 31, 35, 34, 33, 32, 37, 38, 39
				.word	32,  5, 80, 30, 36, 38, 30, 29, 4, 130
cSides1:		.word	51, 52, 51, 55, 54, 53, 52, 57, 58, 59
				.word	52,  9, 90, 50, 56, 58, 52, 49, 6, 210

len1:			.word	20

surfaceAreas1:	.space	80
min1:			.word	0
med1:			.word	0
max1:			.word	0
sum1:			.word	0
ave1:			.float	0.0

aSides2:		.word	125, 125, 133, 144, 158, 159, 132, 156, 149, 121
				.word	137, 121, 137, 141, 157, 137, 147, 151, 151, 149
				.word	132, 139, 135, 129, 123, 125, 131, 142, 144, 149
				.word	136, 132, 122, 131, 146, 150, 154, 138, 158, 152
				.word	157, 147, 159, 124, 123, 134, 135, 136, 135, 134
				.word	151, 153, 136, 159, 131, 142, 150, 158, 141, 149
				.word	159, 134, 147, 149, 152, 154, 136, 148, 152, 153
				.word	132, 151, 156, 157, 130, 140, 141

bSides2:		.word	242, 271, 276, 257, 230, 240, 241, 253, 232, 245
				.word	244, 252, 234, 276, 257, 224, 236, 240, 236, 253
				.word	252, 253, 232, 269, 244, 251, 261, 278, 246, 237
				.word	253, 235, 251, 269, 248, 259, 262, 274, 250, 241
				.word	230, 244, 236, 257, 254, 255, 236, 239, 248, 252
				.word	241, 233, 234, 256, 240, 256, 275, 257, 250, 256
				.word	232, 255, 257, 242, 237, 247, 267, 279, 248, 244
				.word	230, 231, 243, 232, 245, 250, 251

cSides2:		.word	332, 351, 376, 337, 340, 330, 341, 323, 332, 345
				.word	334, 352, 374, 346, 357, 334, 346, 330, 336, 353
				.word	332, 333, 332, 339, 344, 351, 361, 378, 346, 357
				.word	333, 335, 331, 349, 348, 349, 362, 374, 330, 341
				.word	330, 324, 336, 337, 324, 325, 326, 359, 348, 362
				.word	331, 333, 344, 346, 340, 356, 375, 337, 330, 346
				.word	352, 345, 347, 342, 347, 347, 367, 349, 358, 344
				.word	330, 331, 333, 332, 345, 350, 352

len2:			.word	77

surfaceAreas2:	.space	308
min2:			.word	0
med2:			.word	0
max2:			.word	0
sum2:			.word	0
ave2:			.float	0.0

aSides3:		.word	110, 113, 112, 119, 117, 114, 116, 111, 115, 118
				.word	133, 142, 131, 131, 131, 134, 142, 146, 158, 133
				.word	132, 149, 145, 129, 131, 155, 139, 142, 144, 149
				.word	140, 144, 146, 157, 144, 135, 126, 129, 148, 142
				.word	141, 143, 146, 149, 151, 152, 154, 258, 161, 165
				.word	169, 174, 177, 179, 152, 141, 144, 156, 142, 193
				.word	141, 153, 154, 136, 140, 156, 175, 167, 150, 546
				.word	154, 125, 145, 162, 132, 131, 132, 136, 136, 123
				.word	168, 159, 151, 142, 133, 141, 176, 131, 149, 156
				.word	146, 179, 149, 137, 146  134, 134, 156, 164, 142

bSides3:		.word	201, 209, 203, 207, 202, 208, 200, 204, 206, 205
				.word	271, 248, 235, 243, 252, 240, 258, 271, 224, 252
				.word	235, 262, 276, 252, 223, 239, 236, 242, 238, 241
				.word	232, 245, 246, 247, 245, 234, 246, 230, 236, 253
				.word	253, 242, 231, 231, 231, 234, 242, 246, 258, 233
				.word	212, 259, 245, 229, 231, 235, 239, 242, 244, 249
				.word	250, 244, 246, 277, 224, 225, 226, 229, 248, 262
				.word	241, 243, 246, 249, 251, 252, 254, 258, 241, 265
				.word	269, 274, 239, 252, 277, 244, 246, 251, 252, 253
				.word	241, 253, 234, 236, 240, 256, 275, 247, 240, 246

cSides3:		.word	309, 319, 300, 317, 303, 311, 315, 309, 301, 313
				.word	371, 373, 374, 356, 350, 356, 375, 387, 390, 396
				.word	354, 365, 385, 362, 372, 381, 362, 376, 376, 373
				.word	398, 399, 391, 362, 373, 391, 376, 381, 369, 356
				.word	356, 389, 379, 357, 386  384, 374, 356, 364, 362
				.word	371, 378, 395, 363, 392, 370, 358, 371, 354, 392
				.word	365, 362, 376, 392, 383, 369, 396, 362, 388, 391
				.word	382, 355, 376, 387, 385, 384, 386, 380, 366, 353
				.word	373, 382, 381, 381, 371, 374, 362, 376, 358, 383
				.word	352, 379, 365, 369, 361, 365, 359, 362, 384, 379

len3:			.word	100

surfaceAreas3:	.space	400
min3:			.word	0
med3:			.word	0
max3:			.word	0
sum3:			.word	0
ave3:			.float	0.0

aSides4:		.word	112, 119, 125, 129, 131, 135, 139, 142, 144, 149
				.word	182, 195, 107, 112, 127, 147, 167, 179, 188, 194
				.word	 99, 104, 106, 107, 124, 125, 126, 129, 148, 192
				.word	241, 243, 146, 249, 151, 252, 154, 158, 161, 165
				.word	199, 213, 124, 136, 140, 156, 175, 187, 115, 126
				.word	132, 151, 176, 187, 190, 100, 111, 123, 132, 145
				.word	147, 123, 153, 140, 165, 131, 154, 128, 113, 122
				.word	101, 113, 124, 136, 140, 156, 175, 187, 190, 196
				.word	134, 152, 174, 186, 197, 104, 116, 120, 136, 153
				.word	134, 152, 174, 186, 197, 104, 116, 120, 136, 153
				.word	182, 195, 107, 112, 127, 147, 167, 179, 188, 194
				.word	209, 111, 129, 131, 249, 251, 169, 171, 189, 291
				.word	103, 113, 123, 130, 135, 139, 143, 148, 153, 155
				.word	151, 155, 157, 163, 166, 168, 171, 177, 194, 196
				.word	112, 119, 125, 129, 131, 135, 139, 142, 144, 149
				.word	241, 143, 246, 149, 251, 252, 154, 158, 161, 165
				.word	112, 129, 115, 219, 121, 125, 129, 132, 134, 139
				.word	152, 154, 158, 161, 165

bSides4:		.word	169, 174, 177, 179, 182, 184, 186, 188, 192, 193
				.word	 69, 174, 177, 179, 182, 184, 186, 188, 192, 193
				.word	169, 174, 177, 179, 182, 184, 186, 188, 192, 193
				.word	100, 104, 106, 107, 124, 125, 126, 129, 148, 192
				.word	145, 175, 115, 122, 117, 115, 110, 129, 112, 134
				.word	100, 111, 124, 139, 140, 155, 161, 174, 188, 193
				.word	101, 113, 124, 136, 140, 156, 175, 187, 190, 196
				.word	194, 124, 114, 143, 176, 134, 126, 122, 156, 163
				.word	127, 164, 110, 172, 124, 125, 116, 162, 138, 192
				.word	105, 112, 126, 135, 140, 157, 163, 179, 182, 194
				.word	206, 112, 122, 131, 146, 150, 154, 178, 188, 192
				.word	107, 117, 127, 137, 147, 157, 167, 177, 187, 197
				.word	157, 187, 199, 101, 123, 124, 125, 126, 175, 194
				.word	134, 152, 174, 186, 197, 104, 116, 120, 136, 153
				.word	134, 152, 174, 186, 197, 104, 116, 120, 136, 153
				.word	182, 195, 107, 112, 127, 147, 167, 179, 188, 194
				.word	109, 111, 129, 131, 149, 151, 169, 171, 189, 191
				.word	 41,  43, 146, 149, 151

cSides4:		.word	132, 151, 136, 187, 190, 100, 111, 123, 132, 145
				.word	157, 187, 199, 101, 123, 124, 125, 126, 175, 194
				.word	149, 126, 162, 131, 127, 177, 199, 197, 175, 114
				.word	164, 141, 142, 133, 166, 134, 146, 123, 156, 163
				.word	121, 118, 177, 143, 178, 112, 111, 110, 135, 110
				.word	127, 144, 110, 172, 124, 125, 116, 162, 128, 192
				.word	123, 132, 246, 176, 111, 116, 164, 165, 295, 156
				.word	137, 123, 123, 140, 115, 111, 154, 128, 113, 122
				.word	169, 174, 177, 179, 182, 184, 186, 188, 192, 193
				.word	169, 126, 162, 127, 127, 127, 159, 177, 175, 114
				.word	181, 125, 115, 112, 117, 135, 110, 129, 112, 134
				.word	161, 122, 151, 122, 171, 119, 114, 122, 215, 131
				.word	123, 122, 146, 176, 110, 126, 164, 165, 155, 156
				.word	171, 147, 110, 127, 174, 165, 121, 167, 181, 129
				.word	123, 212, 146, 136, 110, 116, 164, 156, 115, 132
				.word	111, 183, 133, 150, 125, 189, 115, 118, 113, 115
				.word	164, 141, 142, 133, 166, 134, 146, 123, 156, 163
				.word	127, 164, 110, 172, 124

len4:			.word	175

surfaceAreas4:	.space	700
min4:			.word	0
med4:			.word	0
max4:			.word	0
sum4:			.word	0
ave4:			.float	0.0

aSides5:		.word	145, 134, 123, 117, 123, 134, 134, 156, 164, 142
				.word	206, 212, 122, 131, 246, 150, 154, 178, 188, 192
				.word	182, 195, 107, 112, 127, 147, 167, 179, 188, 194
				.word	132, 151, 136, 187, 190, 100, 111, 123, 132, 145
				.word	157, 187, 199, 101, 123, 124, 125, 126, 175, 194
				.word	149, 126, 162, 131, 127, 177, 199, 197, 175, 114
				.word	164, 141, 142, 133, 166, 134, 146, 123, 156, 163
				.word	121, 118, 177, 143, 178, 112, 111, 110, 135, 110
				.word	127, 144, 110, 172, 124, 125, 116, 162, 128, 192
				.word	123, 132, 246, 176, 111, 116, 164, 165, 295, 156
				.word	137, 123, 123, 140, 115, 111, 154, 128, 113, 122
				.word	169, 126, 162, 127, 127, 127, 159, 177, 175, 114
				.word	181, 125, 115, 112, 117, 135, 110, 129, 112, 134
				.word	161, 122, 151, 122, 171, 119, 114, 122, 215, 131

bSides5:		.word	123, 122, 146, 176, 110, 126, 164, 165, 155, 156
				.word	171, 147, 110, 127, 174, 165, 121, 167, 181, 129
				.word	123, 212, 146, 136, 110, 116, 164, 156, 115, 132
				.word	111, 183, 133, 150, 125, 189, 115, 118, 113, 115
				.word	164, 141, 142, 133, 166, 134, 146, 123, 156, 163
				.word	111, 183, 133, 130, 127, 111, 115, 158, 113, 115
				.word	117, 126, 162, 117, 227, 177, 199, 177, 175, 114
				.word	194, 124, 112, 143, 176, 134, 126, 132, 156, 163
				.word	124, 119, 122, 183, 110, 191, 192, 129, 129, 122
				.word	135, 126, 162, 137, 127, 127, 159, 177, 175, 144
				.word	179, 153, 136, 140, 235, 112, 154, 128, 113, 132
				.word	161, 192, 151, 213, 126, 169, 114, 122, 115, 131
				.word	194, 124, 114, 143, 176, 134, 126, 122, 156, 163
				.word	149, 144, 114, 134, 167, 143, 129, 161, 165, 136

cSides5:		.word	103, 113, 123, 130, 135, 139, 143, 148, 153, 155
				.word	151, 155, 157, 163, 166, 168, 171, 177, 194, 196
				.word	112, 119, 125, 129, 131, 135, 139, 142, 144, 149
				.word	241, 143, 246, 149, 251, 252, 154, 158, 161, 165
				.word	112, 129, 115, 219, 121, 125, 129, 132, 134, 139
				.word	152, 154, 158, 161, 165, 121, 112, 212, 171, 119
				.word	169, 174, 177, 179, 182, 184, 186, 188, 192, 193
				.word	 69, 174, 177, 179, 182, 184, 186, 188, 192, 193
				.word	100, 104, 106, 107, 124, 125, 126, 129, 148, 192
				.word	145, 175, 115, 122, 117, 115, 110, 129, 112, 134
				.word	100, 111, 124, 139, 140, 155, 161, 174, 188, 193
				.word	101, 113, 124, 136, 140, 156, 175, 187, 190, 196
				.word	194, 124, 114, 143, 176, 134, 126, 122, 156, 163
				.word	105, 112, 126, 135, 140, 157, 163, 179, 182, 194

len5:			.word	140

surfaceAreas5:	.space	560
min5:			.word	0
med5:			.word	0
max5:			.word	0
sum5:			.word	0
ave5:			.float	0.0

# -----
#  Variables for main

hdr:	.ascii	"\nAssignment #2\n"
		.asciiz	"Surface Areas Program\n\n"

hdr_nm:	.ascii	"\n---------------------------"
		.asciiz	"\nData Set #"

hdr_ln:	.asciiz	"\nLength: "
hdr_un:	.asciiz	"\n\n Unsorted Surface Areas: \n\n"
hdr_sr:	.asciiz	"\n Sorted Surface Areas: \n\n"


# ----- # TODO
#  Variables/constants for surfaceAreas() function (if any).



# -----
#  Variables/constants for bubbleSort() function (if any).

TRUE = 1
FALSE = 0


# -----
#  Variables/constants for surfaceAreasStats() function (if any).



# -----
#  Variables/constants for printAreas() function (if any).

spc:	.asciiz	"     "
tab:	.asciiz	"\t"

NUMS_PER_ROW = 5


# -----
#  Variables for printStats() function (if any).

new_ln:	.asciiz	"\n"

str1:	.asciiz	"\n Surface Areas Min = "
str2:	.asciiz	"\n Surface Areas Med = "
str3:	.asciiz	"\n Surface Areas Max = "
str4:	.asciiz "\n Surface Areas Sum = "
str5:	.asciiz	"\n Surface Areas Ave = "



#####################################################################
#  text/code segment

.text
.globl	main
main:

# -----
#  Display Program Header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

	li	$s0, 1				# counter, data set number

# -----
#  Basic flow:
#	display headers

#	for each data set:
#		* find surface areas
#		* display unsorted surface areas
#		* sort surface areas
#		* find surface areas stats (min, max, med, sum, and average)
#		* display sorted surface areass
#		* display surface areas stats  (min, max, med, sum, and average)

# ----------------------------
#  Data Set #1

	la	$a0, hdr_nm
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, hdr_ln
	li	$v0, 4
	syscall

	lw	$a0, len1
	li	$v0, 1
	syscall

	add	$s0, $s0, 1

#  find surface areas
#	surfaceAreas(aSides, bSides, cSides, len, surfaceAreas)

	la	$a0, aSides1
	la	$a1, bSides1
	la	$a2, cSides1
	lw	$a3, len1
	la	$t0, surfaceAreas1
	sub	$sp, $sp, 4
	sw	$t0, ($sp)
	jal	surfaceAreas
	add	$sp, $sp, 4

#  Display unsorted surface areas
#	printAreas(surfaceAreas, len)

	la	$a0, hdr_un
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas1
	lw	$a1, len1
	jal	printAreas

#  Sort surfaceAreas
#	bubbleSort(surfaceAreas, len)

	la	$a0, surfaceAreas1
	lw	$a1, len1
	jal	bubbleSort

#  Generate surface areas stats
#	surfaceAreasStats(surfaceAreas, len, min, med, max, sum, ave)

	la	$a0, surfaceAreas1		# arg #1
	lw	$a1, len1			# arg #2
	la	$a2, min1			# arg #3
	la	$a3, med1			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max1
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum1
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, ave1
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	surfaceAreasStats

	addu	$sp, $sp, 12			# clear stack

#  Display surface areas
#	printArea(surfaceAreas, len)

	la	$a0, hdr_sr
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas1
	lw	$a1, len1
	jal	printAreas

#  Display surface areas stats
#	printStats(min, med, max, sum, ave)

	lw	$a0, min1
	lw	$a1, med1
	lw	$a2, max1
	lw	$a3, sum1
	subu	$sp, $sp, 4
	lw	$t0, ave1
	sw	$t0, ($sp)
	jal	printStats

	addu	$sp, $sp, 4

# ----------------------------
#  Data Set #2

	la	$a0, hdr_nm
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, hdr_ln
	li	$v0, 4
	syscall

	lw	$a0, len2
	li	$v0, 1
	syscall

	add	$s0, $s0, 1

#  find surface areas
#	surfaceAreas(aSides, bSides, cSides, len, surfaceAreas)

	la	$a0, aSides2
	la	$a1, bSides2
	la	$a2, cSides2
	lw	$a3, len2
	la	$t0, surfaceAreas2
	sub	$sp, $sp, 4
	sw	$t0, ($sp)
	jal	surfaceAreas
	add	$sp, $sp, 4

#  Display unsorted surface areas
#	printAreas(surfaceAreas, len)

	la	$a0, hdr_un
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas2
	lw	$a1, len2
	jal	printAreas

#  Sort surface areas
#	bubbleSort(surfaceAreas, len)

	la	$a0, surfaceAreas2
	lw	$a1, len2
	jal	bubbleSort

#  Generate surface areas stats
#	surfaceAreasStats(surfaceAreas, len, min, med, max, sum, ave)

	la	$a0, surfaceAreas2		# arg #1
	lw	$a1, len2			# arg #2
	la	$a2, min2			# arg #3
	la	$a3, med2			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max2
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum2
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, ave2
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	surfaceAreasStats

	addu	$sp, $sp, 12			# clear stack

#  Display surface areas
#	printAreas(surfaceAreas, len)

	la	$a0, hdr_sr
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas2
	lw	$a1, len2
	jal	printAreas

#  Display surface areas stats
#	printStats(min, med, max, sum, ave)

	lw	$a0, min2
	lw	$a1, med2
	lw	$a2, max2
	lw	$a3, sum2
	subu	$sp, $sp, 4
	lw	$t0, ave2
	sw	$t0, ($sp)
	jal	printStats

	addu	$sp, $sp, 4

# ----------------------------
#  Data Set #3

	la	$a0, hdr_nm
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, hdr_ln
	li	$v0, 4
	syscall

	lw	$a0, len3
	li	$v0, 1
	syscall

	add	$s0, $s0, 1

#  find surface areas
#	surfaceAreas(aSides, bSides, cSides, len, surfaceAreas)

	la	$a0, aSides3
	la	$a1, bSides3
	la	$a2, cSides3
	lw	$a3, len3
	la	$t0, surfaceAreas3
	sub	$sp, $sp, 4
	sw	$t0, ($sp)
	jal	surfaceAreas
	add	$sp, $sp, 4

#  Display unsorted surface areas
#	printAreas(surfaceAreas, len)

	la	$a0, hdr_un
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas3
	lw	$a1, len3
	jal	printAreas

#  Sort surface areas
#	bubbleSort(surfaceAreas, len)

	la	$a0, surfaceAreas3
	lw	$a1, len3
	jal	bubbleSort

#  Generate surface areas stats
#	surfaceAreasStats(surfaceAreas, len, min, med, max, sum, ave)

	la	$a0, surfaceAreas3		# arg #1
	lw	$a1, len3				# arg #2
	la	$a2, min3				# arg #3
	la	$a3, med3				# arg #4
	subu	$sp, $sp, 12
	la	$t0, max3
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum3
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, ave3
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	surfaceAreasStats

	addu	$sp, $sp, 12			# clear stack

#  Display surface areas
#	printAreas(surfaceAreas, len)

	la	$a0, hdr_sr
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas3
	lw	$a1, len3
	jal	printAreas

#  Display surface areas stats
#	printStats(min, med, max, sum, ave)

	lw	$a0, min3
	lw	$a1, med3
	lw	$a2, max3
	lw	$a3, sum3
	subu	$sp, $sp, 4
	lw	$t0, ave3
	sw	$t0, ($sp)
	jal	printStats

	addu	$sp, $sp, 4

# ----------------------------
#  Data Set #4

	la	$a0, hdr_nm
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, hdr_ln
	li	$v0, 4
	syscall

	lw	$a0, len4
	li	$v0, 1
	syscall

	add	$s0, $s0, 1

#  find surface areas
#	surfaceAreas(aSides, bSides, cSides, len, surfaceAreas)

	la	$a0, aSides4
	la	$a1, bSides4
	la	$a2, cSides4
	lw	$a3, len4
	la	$t0, surfaceAreas4
	sub	$sp, $sp, 4
	sw	$t0, ($sp)
	jal	surfaceAreas
	add	$sp, $sp, 4

#  Display unsorted surface areas
#	printArray(surfaceAreas, len)

	la	$a0, hdr_un
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas4
	lw	$a1, len4
	jal	printAreas

#  Sort surface areas
#	bubbleSort(surfaceAreas, len)

	la	$a0, surfaceAreas4
	lw	$a1, len4
	jal	bubbleSort

#  Generate surface areas stats
#	surfaceAreasStats(surfaceAreas, len, min, med, max, sum, ave)

	la	$a0, surfaceAreas4		# arg #1
	lw	$a1, len4			# arg #2
	la	$a2, min4			# arg #3
	la	$a3, med4			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max4
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum4
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, ave4
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	surfaceAreasStats

	addu	$sp, $sp, 12			# clear stack

#  Display surface areas
#	printAreas(surfaceAreas, len)

	la	$a0, hdr_sr
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas4
	lw	$a1, len4
	jal	printAreas

#  Display surface areas stats
#	printStats(min, med, max, sum, ave)

	lw	$a0, min4
	lw	$a1, med4
	lw	$a2, max4
	lw	$a3, sum4
	subu	$sp, $sp, 4
	lw	$t0, ave4
	sw	$t0, ($sp)
	jal	printStats

	addu	$sp, $sp, 4

# ----------------------------
#  Data Set #5

	la	$a0, hdr_nm
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, hdr_ln
	li	$v0, 4
	syscall

	lw	$a0, len5
	li	$v0, 1
	syscall

	add	$s0, $s0, 1

#  find surface areas
#	surfaceAreas(aSides, bSides, cSides, len, surfaceAreas)

	la	$a0, aSides5
	la	$a1, bSides5
	la	$a2, cSides5
	lw	$a3, len5
	la	$t0, surfaceAreas5
	sub	$sp, $sp, 4
	sw	$t0, ($sp)
	jal	surfaceAreas
	add	$sp, $sp, 4

#  Display unsorted surface areas
#	printAreas(surfaceAreas, len)

	la	$a0, hdr_un
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas5
	lw	$a1, len5
	jal	printAreas

#  Sort surface areas
#	bubbleSort(surfaceAreas, len)

	la	$a0, surfaceAreas5
	lw	$a1, len5
	jal	bubbleSort

#  Generate surface areas stats
#	surfaceAreasStats(surfaceAreas, len, min, med, max, sum, ave)

	la	$a0, surfaceAreas5	# arg #1
	lw	$a1, len5			# arg #2
	la	$a2, min5			# arg #3
	la	$a3, med5			# arg #4
	subu	$sp, $sp, 12
	la	$t0, max5
	sw	$t0, ($sp)			# arg #5, on stack
	la	$t0, sum5
	sw	$t0, 4($sp)			# arg #6, on stack
	la	$t0, ave5
	sw	$t0, 8($sp)			# arg #7, on stack
	jal	surfaceAreasStats

	addu	$sp, $sp, 12	# clear stack

#  Display surface areas
#	printArray(surfaceAreas, len)

	la	$a0, hdr_sr
	li	$v0, 4
	syscall

	la	$a0, surfaceAreas5
	lw	$a1, len5
	jal	printAreas

#  Display surface areas stats
#	printStats(min, med, max, sum, ave)

	lw	$a0, min5
	lw	$a1, med5
	lw	$a2, max5
	lw	$a3, sum5
	subu	$sp, $sp, 4
	lw	$t0, ave5
	sw	$t0, ($sp)
	jal	printStats

	addu	$sp, $sp, 4

# -----
#  Done, terminate program.

	li	$v0, 10
	syscall					# au revoir...
.end main

#####################################################################
#  Find surface areas
#	surfaceAreas[n] = 2 [ asides(n)*bsides(n) + asides(n)*csides(n)
#				+ bsides(n)*csides(n) ]

# ----- # TODO
#  HLL Call:
#	surfaceAreas(aSides, bSides, cSides, len, surfaceAreas)

# * Arguments:
# *	$a0   - starting address of the aSides array
# *	$a1   - starting address of the bSides array
# *	$a2   - starting address of the cSides array
# *	$a3   - length
# *	($fp) - starting address of the surfaceAreas array

#    Returns:
#	surfaceAreas[] array via passed address

.globl surfaceAreas
.ent surfaceAreas
surfaceAreas:
	subu $sp, $sp, 32 					# preserve registers
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $fp, 24($sp)
	sw $ra, 28($sp)

	# set fp pointing to first arg on stack (array)
	addu $fp, $sp, 32 

#*	surfaceAreas[n] = 2 * [ asides(n)*bsides(n) + asides(n)*csides(n)
#*				+ bsides(n)*csides(n) ]
	move $s0, $a0 						# | address of aSides
	move $s1, $a1 						# | address of bSides
	move $s2, $a2 						# | address of cSides
	move $s3, $a3 						# | length

	lw $s4, ($fp)						# surfaceAreas array

areasLoop:
	# get values from the arrays
	lw $t0, ($s0) 						# | a[i]
	lw $t1, ($s1) 						# | b[i]
	lw $t2, ($s2) 						# | c[i]
	lw $t3, ($s4) 						# | surfaceAreas[i]

	# calculate surface area
	mul $t4, $t0, $t1 					# a[i] * b[i] -- (1)
	mul $t5, $t0, $t2 					# a[i] * c[i] -- (2)
	mul $t6, $t1, $t2 					# b[i] * c[i] -- (3)

	add $t3, $t4, $t5 					# (1) + (2)
	add $t3, $t3, $t6 					# (1) + (2) + (3)

	mul $t3, $t3, 2 					# 2 * (1) + (2) + (3)

	# store result in the array
	sw $t3, ($s4)

	addu $s0, $s0, 4 					# increment aSides pointer
	addu $s1, $s1, 4 					# increment bSides pointer
	addu $s2, $s2, 4 					# increment cSides pointer
	addu $s4, $s4, 4 					# increment surfaceAreas pointer

	subu $s3, $s3, 1 					# decrement length

	bnez $s3, areasLoop

	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $fp, 24($sp)
	lw $ra, 28($sp)
	addu $sp, $sp, 32

	jr	$ra
.end surfaceAreas


#####################################################################
#  Sort surface areas using bubble sort.

# ----- # TODO
#    Arguments: ASSUME THIS IS CORRECT SO FAR GRRRRR
#*	$a0 - starting address of the surface areas array
#*	$a1 - list length

#*   Returns:
#*	sorted surface areas (via passed address)

#* for ( i = (len-1) to 0 ) {
#*      swapped = false
#*      for ( j = 0 to i-1 )
#*          if ( lst(j) > lst(j+1) ) {
#*              tmp = lst(j)
#*              lst(j) = lst(j+1)
#*              lst(j+1) = tmp
#*              swapped = true
#*          }
#*      if ( swapped = false ) exit
#* }

.globl bubbleSort
.ent bubbleSort
bubbleSort:

	move $t0, $a0						# save address of surfaceAreas
	move $t1, $a1						# save length of surfaceAreas

	li $t3, 0							# i = 0

for1Continue:							#* for ( i = (len-1) to 0 )

	sub $t1, $t1, 1						#* (len-1) to 0
	blt $t1, 0, for1Break				#* if ( len == 0 ) exit

	# before inner loop
	li $t9, FALSE						#* swapped = false
	li $t4, 0							# j = 0

for2Continue:							#* for ( j = 0 to i-1 )

	move $t3, $t1						# current t3 = i
	sub $t3, $t3, 1						# t3 = t3 - 1 = i - 1
	bgt $t4, $t3, for2Break				#* if ( j > i-1 ) exit

	#* if swap statemetns
	mul $t5, $t4, 4						# offet of j in array
	add $t6, $t0, $t5					# address of [j]
	lw $t7, ($t6)						#* t7 = [j]
	
	addu $t4, $t4, 1					# increment j toward i - 1, cause we start at 0

	addu $t6, $t6, 4					# offset of j + 1 in array
	lw $t8, ($t6)						#* t8 = [j + 1]

	blt $t7, $t8, for2Continue			#* if ( [j] > [j + 1] ) swap it

	#* swap executions					# t6 is currently at [j + 1]
	sw $t7, ($t6)						# [j] = [j + 1]
	subu $t6, $t6, 4					# current addrress is [j]
	sw $t8, ($t6)						# [j + 1] = [j]

	li $t9, TRUE						#* swapped = true
	j for2Continue						

for2Break:

	beq $t9, FALSE, for1Break			#* swapped = false
	j for1Continue						#* continue outer loop if swap still TRUE

for1Break:

	jr $ra

.end bubbleSort

#####################################################################
#  MIPS assembly language function, surfaceAreasStats, that
#    will find the minimum, median, maximum, sum, and average 
#    of the surface areas array.

#    Finds the maximum after the array is sorted
#    (i.e, max=list(len-1)).
#    The average is calculated as floating point value.

# ----- # TODO surfaceAreasStats(array[], len, min, med, max, sum, ave)
# * Arguments: 
# *	$a0 	- starting address of the surface areas array
# *	$a1 	- list length
# *	$a2 	- addr of min
# *	$a3 	- addr of med
# *	($fp) 	- addr of max
# *	4($fp) 	- addr of sum
# *	8($fp) 	- addr of ave (float)

# *  Returns (via addresses):
# *	$a2 	- min
# *	$a3 	- med
# *	($fp) 	- max
# *	4($fp) 	- sum
# *	8($fp) 	- ave (float)

#	YOUR CODE GOES HERE

.globl surfaceAreasStats
.ent surfaceAreasStats
surfaceAreasStats:

	subu $sp, $sp, 32 					# preserve registers
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $fp, 24($sp)
	sw $ra, 28($sp)

	# set fp pointing to first arg on stack (array)
	addu $fp, $sp, 32 

	# load addreses - 7 Args
	move $s0, $a0 	
	move $s1, $a1	
	move $s2, $a2	
	move $s3, $a3	
	lw $s4, ($fp)						
	lw $s5, 4($fp)
	lw $s6, 8($fp)

# ----
# Min, Max
	lw $t0, ($s0)						# load first element of array
	sw $t0, ($s2)						# that's min baby

	move $t1, $a1 						# t1 = len
	mul $t1, $t1, 4 					# offset
	sub $t1, $t1, 4 					# last element offset

	add $t2, $s0, $t1					# ^^ address of that element 
	lw $t3, ($t2)						# load last element of array
	sw $t3, ($s4)

# ----
# Sum, Average

	move $t6, $s0						# t6 = s0 = array address
	move $t4, $a1						# counter till len
	li $t5, 0							# sum

sumLoop:
	lw $t0, ($t6)						# load first element of array
	add $t5, $t5, $t0					# sum += element

	addu $t6, $t6, 4					# increment address of array
	subu $t4, $t4, 1					# increment counter

	bnez $t4 sumLoop
	sw $t5, ($s5)

calculateAve:
	move $t4, $a1						# counter till len -- useless

	mtc1 $t5, $f3						# copy over a float register the sum
	cvt.s.w $f3, $f3					# convert to float using that same register

	mtc1 $a1, $f4						# copy over a float register the len	
	cvt.s.w $f4, $f4					# convert to float using that same register

	div.s $f0, $f3, $f4					# divide sum / len

	s.s $f0, ($s6)						# 平均のアドレスにフロートを格納します

# ----
# Median
	move $t4, $a1						# getssu lento あ
	div $t5, $t4, 2						# t4 = len / 2 (integer)
	mul $t6, $t5, 4						# offset -- value

	add $t7, $a0, $t6					# t7 = array[len / 2] -- address
	lw $t8, ($t7)						# t8 = array[len / 2] -- value (1)

	rem $t9, $t4, 2
	bnez $t9, oddArray

	sub $t7, $t7, 4						# t7 = array[len / 2 - 1] -- address
	lw $t1, ($t7) 						# t1 = array[len / 2 - 1] -- value (2)

	add $t8, $t8, $t1					# t8 = (1) + (2)
	div $t8, $t8, 2						# t8 = (1) + (2) / 2

oddArray:
	sw $t8, ($s3)

# ----
# Epilouge

	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $fp, 24($sp)
	lw $ra, 28($sp)
	addu $sp, $sp, 32

	jr $ra

.end surfaceAreasStats

#####################################################################
#  MIPS assembly language function, printAreas(), to display
#   a surface areas array.  The surface areas should be printed
#   5 per line (as per example).

#   The numbers are left justified (i.e., lined up on left
#   side).

#  Note, due to the system calls, the saved registers must
#        be used.  As such, push/pop saved registers altered.

# ----- # TODO
#    Arguments:
#*	$a0 - starting address of the surface areas array
#*	$a1 - list length

#*  Returns:
#*	N/A

.globl printAreas
.ent printAreas
printAreas:
#	YOUR CODE GOES HERE
	subu $sp, $sp, 8 
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)

	# set frame pointer
	# set fp pointing to first arg on stack (length)
	addu $fp, $sp, 8 

	move $s0, $a0						# save address of surfaceAreas
	move $s1, $a1						# load length of surfaceAreas
	li $s2, 0							# counter = 0

	# li $v0, 4	
	# la $a0, tab
	# syscall

printAreasLoop:

	li $v0, 4	
	la $a0, spc
	syscall

	li $v0, 1							# print Areas[i]
	lw $a0, ($s0)						# load Areas[i]
	syscall

	addu $s0, $s0, 4					# increment i
	addu $s2, $s2, 1					# increment counter toward len

	rem $t0, $s2, 5						# t0 = counter % 5

	bnez $t0, nuhUh

	li, $v0, 4							# print newline
	la $a0, new_ln
	syscall

	# li $v0, 4	
	# la $a0, tab
	# syscall

nuhUh:
	bne $s1, $s2, printAreasLoop		# if counter != len, continue loop

	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addu $sp, $sp, 8

	jr $ra
.end printAreas

#####################################################################
#  MIPS assembly language function, printStats(), to display
#   the final surface areas array.
#   Prints the maximum, median, sum, and average.

# ----- # TODO
#*  Arguments:
#*	$a0 - min
#*	$a1 - med
#*	$a2 - max
#*	$a3 - sum1
#*	($fp) - average

#    Returns:
#	n/a

.globl	printStats
.ent	printStats
printStats:

# -----
#  Save registers.

	subu	$sp, $sp, 20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$fp, ($sp)

	addu	$fp, $sp, 20

# -----
#  Save arguments to saved registers
#   (since system calls change arg registers).

	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
	move	$s3, $a3

# -----
#  Print message followed by result.

	la	$a0, str1
	li	$v0, 4
	syscall					# print "min = "

	move	$a0, $s0
	li	$v0, 1
	syscall					# print min

# -----
#  Print message followed by result.

	la	$a0, str2
	li	$v0, 4
	syscall					# print "med = "

	move	$a0, $s1
	li	$v0, 1
	syscall					# print med

# -----
#  Print message followed by result.

	la	$a0, str3
	li	$v0, 4
	syscall					# print "max = "

	move	$a0, $s2
	li	$v0, 1
	syscall					# print max

# -----
#  Print message followed by result.

	la	$a0, str4
	li	$v0, 4
	syscall					# print "sum = "

	move	$a0, $s3
	li	$v0, 1
	syscall					# print sum

# -----
#  Print message followed by result.

	la	$a0, str5
	li	$v0, 4
	syscall					# print "ave = "

	lw	$t0, ($fp)
	mtc1	$t0, $f12
	li	$v0, 2
	syscall					# print average

	la	$a0, new_ln			# print a newline
	li	$v0, 4
	syscall

	la	$a0, new_ln			# print a newline
	li	$v0, 4
	syscall

# -----
#  Restore registers.

	lw	$s0, 16($sp)
	lw	$s1, 12($sp)
	lw	$s2, 8($sp)
	lw	$s3, 4($sp)
	lw	$fp, ($sp)
	addu	$sp, $sp, 20

# -----
#  Done, return.

	jr	$ra
.end	printStats

#####################################################################

	