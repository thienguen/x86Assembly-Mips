; *****************************************************************
;  Name: Thien Nguyen
;  NSHE ID:
;  Section: 1004
;  Assignment: 6
;  Description:	Simple assembly language program to calculate 
;		the cube areas for a series of cubes.
;		The cube side lengths are provided as binary values
;		represented as ASCII characters (0's and 1's) and must
;		be converted into integer in order to perform the
;		calculations.

; =====================================================================
;  Macro to convert ASCII/Binary value into an integer.
;  Reads <string>, convert to integer and place in <integer>
;  Assumes valid data, no error checking is performed.
;  Note, macro should preserve any registers that the macro alters.

;  Arguments:
;	%1 -> <string>, register -> string address
;	%2 -> <integer>, register -> result

;  Macro usgae
;	aBin2int	<string>, <integer>

;  Example usage:
;	aBin2int	rbx, tmpInteger

;  For example, to get address into a local register:
;		mov	rsi, %1

;  Note, the register used for the macro call (rbx in this example)
;  must not be altered before the address is copied into
;  another register (if desired).

%macro    aBin2int    2

;    TODO STEP #2
;    YOUR CODE GOES HERE
    mov r8, %1
    mov r9, 0
    mov eax, 0

%%nextChar:
    mov ecx, 0
    mov cl, byte[r8+r9]

    cmp cl, NULL
    je    %%nextCharDone
    
    sub cl, 0x30
    mov r11d, 2
    mul r11d
    add eax, ecx

    inc r9
    jmp %%nextChar

%%nextCharDone:
    mov dword[%2], eax

%endmacro

; =====================================================================
;  Macro to convert integer to hex value in ASCII format.
;  Reads <integer>, converts to ASCII/binary string including
;	NULL into <string>
;  Note, macro should preserve any registers that the macro alters.

;  Arguments:
;	%1 -> <integer>, value
;	%2 -> <string>, string address

;  Macro usgae
;	int2aBin    <integer-value>, <string-address>

;  Example usage:
;	int2aBin	dword [cubeAreas+rsi*4], tempString

;  For example, to get value into a local register:
;		mov	eax, %1

%macro	int2aBin	2

;	STEP #5
;	TODO YOUR CODE GOES HERE

	push	rax			; save altered registers
	push	rdi
	push	rsi
	push	rdx
	push	rcx

	mov eax, %1
	mov rcx, 0
	mov ebx, 2

%%divideLoop:
	mov edx, 0
	div ebx

	push rdx
	inc rcx

	cmp rcx, STRLENGTH
	jne %%divideLoop

	mov rbx, %2
	mov rdi, 0

%%popLoop:
	pop rax
	add al, "0"

	mov byte[rbx+rdi], al
	inc rdi
	loop %%popLoop

	mov byte[rbx+rdi], NULL
	
	pop	rcx			    ; restore registers to original values
	pop	rdx
	pop	rsi
	pop	rdi
	pop	rax

%endmacro

; =====================================================================
;  Simple macro to display a string to the console.
;  Count characters (excluding NULL).
;  Display string starting at address <stringAddr>

;  Macro usage:
;	printString  <stringAddr>

;  Arguments:
;	%1 -> <stringAddr>, string address

%macro	printString	1
	push	rax			; save altered registers
	push	rdi
	push	rsi
	push	rdx
	push	rcx

	lea	rdi, [%1]		; get address
	mov	rdx, 0			; character count
%%countLoop:
	cmp	byte [rdi], NULL
	je	%%countLoopDone
	inc	rdi
	inc	rdx
	jmp	%%countLoop
%%countLoopDone:

	mov	rax, SYS_write	; system call for write (SYS_write)
	mov	rdi, STDOUT		; standard output
	lea	rsi, [%1]		; address of the string
	syscall				; call the kernel

	pop	rcx			    ; restore registers to original values
	pop	rdx
	pop	rsi
	pop	rdi
	pop	rax
%endmacro

; =====================================================================
;  Initialized variables.

section	.data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0		; successful operation
NOSUCCESS	equ	1			; unsuccessful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; system call code for read
SYS_write	equ	1			; system call code for write
SYS_open	equ	2			; system call code for file open
SYS_close	equ	3			; system call code for file close
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

NUMS_PER_LINE	equ	2


; -----
;  Assignment #6 Provided Data

STRLENGTH	equ	32

cSides	db	"00000000000000000000000010101001", NULL
		db	"00000000000000000000000001010101", NULL
		db	"00000000000000000000000101011001", NULL
		db	"00000000000000000000000000101010", NULL
		db	"00000000000000000000010101101011", NULL
		db	"00000000000000000001010100101101", NULL
		db	"00000000000000000000000101101101", NULL
		db	"00000000000000000000101011111000", NULL
		db	"00000000000000000000111100111001", NULL
		db	"00000000000000000001001111001101", NULL
		db	"00000000000000000001110001111101", NULL
		db	"00000000000000000000101111100000", NULL
		db	"00000000000000000000110011111001", NULL
		db	"00000000000000000011101001000101", NULL
		db	"00000000000000000000011101011101", NULL
		db	"00000000000000000010110011111000", NULL
		db	"00000000000000000001110101111101", NULL
		db	"00000000000000000001010001111101", NULL
		db	"00000000000000000011110001111101", NULL
		db	"00000000000000000001010001101101", NULL
		db	"00000000000000000001100001111101", NULL

aLength	db	"00000000000000000000000000010101", NULL

length	dd	0

cubeAreasSum	dd	0
cubeAreasAve	dd	0
cubeAreasMin	dd	0
cubeAreasMax	dd	0

; -----
;  Misc. variables for main.

hdr			db	"-----------------------------------------------------"
			db	LF, ESC, "[1m", "CS 218 - Assignment #6", ESC, "[0m", LF
			db	"Cube Area Information", LF, LF
			db	"Cube Sides's:", LF, NULL

shdr		db	LF, "Cube Area's Sum:   ", NULL
avhdr		db	LF, "Cube Areas's Ave:  ", NULL
minhdr		db	LF, "Cube Areas's Min:  ", NULL
maxhdr		db	LF, "Cube Areas's Max:  ", NULL

tmpInteger	dd	0
newLine		db	LF, NULL
spaces		db	"   ", NULL

; =====================================================================
;  Uninitialized variables

section	.bss

cubeAreas		resd	21		; double-words
tempString		resb	33		; bytes

areasSumString	resb	33
areasAveString	resb	33
areasMinString	resb	33
areasMaxString	resb	33


; **************************************************************

section	.text
global	_start
_start:

; -----
;  Display assignment initial headers.

	mov	edx, 0
	printString	hdr

; -----
;  Convert integer length, in ASCII binaary format

;  STEP #1
;	TODO YOUR CODE GOES HERE
;	Convert ASCII/binary format length to integer (no macro)
;	Do not use macro here...
;	Read string aLength, convert to inteter, and store in length

	mov r8, aLength			        ; r8 --> address of string aLength
	mov r9, 0						; r9 --> i = 0
	mov eax, 0						; eax --> rSum = 0

nextChar:
	mov ecx, 0						; counter loop
	mov cl, byte[r8+r9]				; char = str[i]

	cmp cl, NULL					; if char is NULL
	je	nextCharDone				; jump to nextCharDone

	sub cl, 0x30					; convert char to integer, ecx to integer
	mov r11d, 2
	mul r11d						;  ecx = rSum * 2
	add eax, ecx					; rSum = rSum + ecx

	inc r9							; i++
	jmp nextChar					; jump to nextChar

nextCharDone:
	mov dword[length], eax			; length = rSum

; -----
;  Convert cube sides from ASCII/binary to integer

	mov	esi, dword[length]
	mov	rdi, 0					; index for cube areas
	mov	rbx, cSides
	mov dword[cubeAreasSum], 0

cvtLoop:
	aBin2int rbx, tmpInteger

	mov	eax, dword[tmpInteger]
	mul	eax
	mov	r10d, 6
	mul	r10d
	mov	dword [cubeAreas+rdi*4], eax
	add	ebx, (STRLENGTH+1)

	inc	rdi
	dec	esi
	cmp	esi, 0
	jne	cvtLoop

; -----
;  Display each the cube area (two per line).

	mov	ecx, dword [length]
	mov	rsi, 0
printLoop:
	int2aBin	dword [cubeAreas+rsi*4], tempString
	printString	tempString
	printString	spaces

	test	rsi, 1				; even/odd check
	je	skipNewline
	printString	newLine
skipNewline:
	inc	rsi

	dec	ecx
	cmp	ecx, 0
	jne	printLoop
	printString	newLine

; -----
;  Find sum, min, max and compute average.
;  STEP #3
;	TODO YOUR CODE GOES HERE
;	Find cube stats (sum, min, max, and average).
;	Reads data from cubeAreas array (set above).

; --- CUBEAREAS SUM
; --- CUBEAREAS MIN  --------------------------------
; --- CUBEAREAS MAX  --------------------------------

	mov dword[cubeAreasSum], 0
	mov eax, dword[cubeAreas]				; grasp the first element
	mov dword[cubeAreasMin], eax			; store it in cubeAreasMin
	mov dword[cubeAreasMax], eax			; first elemtn would be temp max
	mov rsi, 0
	mov ecx, dword[length]

startLoop:
	mov eax, dword[cubeAreas+rsi*4]			; grab the next element
	add dword[cubeAreasSum], eax			; add it to the sum
	cmp eax, dword[cubeAreasMax]			; compare to max
	jbe maxDone
	mov dword[cubeAreasMax], eax			; if greater, that's new max, store it

maxDone:
	cmp eax, dword[cubeAreasMin]			; compare to min
	jae minDone
	mov dword[cubeAreasMin], eax			; if lower, that's new min, store it

minDone:
	inc rsi									; increment index
	loop startLoop							; loop handle ecx, counter loop

; --- CUBEVOLUMES AVERAGE --------------------------
	mov eax, dword[cubeAreasSum]			; grab the first element
	mov edx, 0								; unsinged division, we don't want garbo value at the upper bits
	div dword[length]						; divide by length
	mov dword[cubeAreasAve], eax			; store it in cubeAreasAve

; -----
;  Convert sum to ASCII/binary for printing.

	printString	shdr

;  STEP #4
;	TODO YOUR CODE GOES HERE
;	Convert the integer sum to ASCII/Binary (no macro)
;	Do not use macro here...
;	Read cubeAreasSum (set above), convert to ASCII/binary
;		and store in areasSumString.

	mov eax, dword[cubeAreasSum]			
	mov rcx, 0								; 
	mov ebx, 2								; divide by 2, to get remainder

divideLoop:
	mov edx, 0								; reset remainder = 0, actually we divide the eax
	div ebx									; divide by 2

	push rdx								; store remainder in stack
	inc rcx									; increment cause we going to get stringlength+1

	cmp rcx, STRLENGTH						; if eax is 0, we're done
	jne divideLoop

	mov rbx, areasSumString					; rbx --> address of areasSumString
	mov rdi, 0								; index = 0

popLoop:
	pop rax									; grab remainder from stack
	add al, "0"								; char = int +"0"

	mov byte[rbx+rdi], al					; store char in address areasSumString
	inc rdi									; increment index
	loop popLoop
	
	mov byte[rbx+rdi], NULL					; NULL terminate string

	printString	areasSumString

; -----
;  Convert average, min, and max integers to ASCII/binary for printing.

	printString	avhdr
	int2aBin	dword [cubeAreasAve], areasAveString
	printString	areasAveString

	printString	minhdr
	int2aBin	dword [cubeAreasMin], areasMinString
	printString	areasMinString

	printString	maxhdr
	int2aBin	dword [cubeAreasMax], areasMaxString
	printString	areasMaxString

	printString	newLine
	printString	newLine


; *****************************************************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rdi, EXIT_SUCCESS
	syscall

