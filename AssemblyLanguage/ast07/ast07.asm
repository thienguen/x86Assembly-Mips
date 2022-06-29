; *****************************************************************
;  Name: Thien Nguyen
;  NSHE ID: 
;  Section: 4
;  Assignment: 7
;  Description: Write a simple assembly language program to 
;	sort a list of signed integer numbers into 
;	ascending (small to large) order.  Additionally, 
;	find the minimum, median, maximum, sum, and 
;	average of the list.  You can find the minimum 
;	and maximum after the list is sorted

; =====================================================================
;  Macro to convert integer to hex value in ASCII format.
;  Reads <integer>, converts to ASCII/binary string including
;	NULL into <string>
;  Note, macro should preserve any registers that the macro alters.

;  Arguments:
;	%1 -> <integer>, value
;	%2 -> <string>, string address

;  Macro usgae
;	int2aBin	<integer-value>, <string-address>

;  Example usage:
;	int2aBin	dword [cubeAreas+rsi*4], tempString

;  For example, to get value into a local register:
;		mov	eax, %1

%macro	int2aBin	2

	push	rdi
	push	rsi
	push	rdx

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
	
	pop	rdx
	pop	rsi
	pop	rdi

%endmacro

; =====================================================================
;  Simple macro to display a string.
;	Call:	printString  <stringAddress>

;	Arguments:
;		%1 -> <string>, string address

;  Algorithm:
;	Count characters (excluding NULL).
;	Use system service to display string at address <string>

%macro	printString	1
	push	rax				; save altered registers
	push	rdi
	push	rsi
	push	rdx
	push	rcx

	mov	rdx, 0
	mov	rdi, %1
%%countLoop:
	cmp	byte [rdi], NULL
	je	%%countLoopDone
	inc	rdi
	inc	rdx
	jmp	%%countLoop
%%countLoopDone:

	mov	rax, SYS_write		; system call for write (SYS_write)
	mov	rdi, STDOUT			; standard output
	mov	rsi, %1				; address of the string
	syscall					; call the kernel

	pop	rcx					; restore registers to original values
	pop	rdx
	pop	rsi
	pop	rdi
	pop	rax
%endmacro

; =====================================================================

section	.data

; -----
;  Define standard constants

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0		; Successful operation

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
NULL		equ	0
ESC		equ	27

; -----
;  Misc. constants

MAX_STR_SIZE	equ	33

; -----
;  String definitions

newLine		db	LF, NULL
spaces		db	"   ", NULL

hdr		db	"**********************************"
		db	LF, "CS 218 - Assignment #7", LF
		db	LF, "List Statistics:"
		db	LF, LF, NULL

lstMin		db	"List Minimum: ", NULL
lstMed		db	"List Median:  ", NULL
lstMax		db	"List Maximum: ", NULL
lstSum		db	"List Sum:     ", NULL
lstAve		db	"List Average: ", NULL

; -----
;  Provided data.

STRLENGTH	equ	32

lst		dd	 6759,  6326,   171,   147, -5628
		dd	 7527,  7569,  1177,  6785,  3514
		dd	-1001,   128,  1133,  1105, -3327
		dd	 1107,  6103,  1245,  6440,  1465
		dd	 2311,   254,  4528,  1913,  6722
		dd	-1149,  2126,  5671,  4647,  4628
		dd	 -327, -2390,  1177,  8275,  5614
		dd	 3121,   415,  -615,   122,  7217
		dd	-1221, -2234,  6151,   432,   114
		dd	 1629,   114,   522,  2413,   131
		dd	 5639,   126,  1162,   441,   127
		dd	 -877,   199,  5679, -1101,  3414
		dd	-2101,   133,  1133,  2450,  4532
		dd	 8619,   115,  1618,  1113,  -115
		dd	 1219,  3116,  -612,   217,   127
		dd	 6787,  4569,   679, -5675,  4314
		dd	 1104,  6825,  1184,  2143,  1176
		dd	  134, -4626,   100,  4566,  2346
		dd	 1214,  6786,  1617,   183, -3512
		dd	 7881, -8320,  3467,  4559, -1190
		dd	 2137,  2113, -1647,   114,   115
		dd	-6571, -7624,   128,   113,  3112
		dd	 1724,  6316,  1217,  2183, -4352
		dd	-9125,   116,  1122,   117,   127
		dd	 5677,   101,  3727, -1125,  3184
		dd	 1897,  6374,  1190,     0,  1224
		dd	  125,   116,  8126,  6784, -2329
		dd	 1104,   124,  1112,   143,   176
		dd	 7534,  2126,  6112,   156,  1103
		dd	  156,   164,   165,  -155,  5156
		dd	  894,  6325,  1184,   143,   276
		dd	 7525,  5616,  5662,  6328,  2342
		dd	 6581,  3625,  6315,     1,  -617
		dd	 7855,  6737,   129,  4512,  1134
		dd	 6561,  1283,  1133,  1150,   135
		dd	 5631, -8185,   178, -1197,  1185
		dd	 5649,  6366,  1162,  1167,   167
		dd	-1177,   169,  1177,   175,  1169
		dd	 5684,  2179,  1117,  3183,   190
		dd	 1100, -4611,  1123,  3122,  -131

len		dd	200

min		dd	0
med		dd	0
max		dd	0
sum		dd	0
avg		dd	0

; -----
;  Misc. data definitions (if any).

swapped		db	TRUE

iterator    dd  0

; -----

section	.bss
tempString	resb	MAX_STR_SIZE


; =====================================================================

section	.text
global	_start
_start:

; -----
; To sort the numbers, use the following bubble sort algorithm:
; for ( i = (len-1) to 0 ) {
;     swapped = false
;     for ( j = 0 to i-1 )
;         if ( lst(j) > lst(j+1) ) {
;             tmp      = lst(j)
;             lst(j)   = lst(j+1)
;             lst(j+1) = tmp
;             
;              swapped  = true
;         }
;     if ( swapped = false ) exit
; }

	mov r8d, dword[len]				; r8 is i = len

for1Continue:
	; Condition of outer loop to break
	dec r8							; i = i - 1
	cmp r8, 0 						; if ( i < 0 ) exit for1Continue
	jl for1Break					; outer loop done if ( i < 0 )

	; Before inner loop
	mov byte[swapped], FALSE        ; swapped = false
	mov r9, 0						; r9 is j = 0

for2Continue:
	; Condition of inner loop to break
	mov rbx, r8 					; r8  is i
	dec rbx							; rbx is i - 1
	cmp r9, rbx 					; r9  is j
	jg for2Break					; if ( j == i - 1 ) exit for2Continue
	mov r12, r9
	inc r9							; r9  is j = j + 1 --> toward i - 1
	
	; if swap statement
	mov r10d, dword[lst+r12*4]	    ; r10d = lst(j)
	mov r11d, dword[lst+r9*4]	    ; r11d = lst(j+1)
	cmp r10d, r11d					; if ( lst(j) > lst(j+1) )
	jl for2Continue	     		    ; if not, we continue the inner loop

	; Swap execution
	mov dword[lst+r9*4], r10d	    ; swapped
	mov dword[lst+r12*4], r11d	    ; swapped

	mov byte[swapped], TRUE			; swapped = true
	jmp for2Continue				; continue the inner loop

for2Break:

	; After inner loop
	cmp byte[swapped], FALSE		; if ( swapped = false ) exit for1Continue
	je for1Break				    ; if not, we continue the outer loop

	; Go to the next outer loop
	jmp for1Continue				; loop till i == 0, the inner loop done

for1Break:

; --- MAX ------------------------------
; --- MIN ------------------------------
; --- SUM ------------------------------

	mov eax, dword[lst]
	mov dword[min], eax

	mov ecx, dword[len]
	mov rsi, 0

	mov eax, dword[lst+(rcx-1)*4]
	mov dword[max], eax
	
startLoop:
	mov eax, dword[lst+rsi*4]
	add dword[sum], eax
	inc rsi
	loop startLoop

; --- AVG ------------------------------
	mov eax, dword[sum]
	cdq
	idiv dword[len]
	mov dword[avg], eax

; --- MED ------------------------------
	mov eax, dword[len]
	mov r8d, 2
	cqo
	idiv r8d
	mov rsi, 0
	mov esi, eax

	mov eax, dword[lst+rsi*4]
	dec rsi	
	add eax, dword[lst+rsi*4]
	mov r8d, 2
	cqo
	idiv r8d
	mov dword[med], eax

; -----
;  Output results to console.
;	Convert each result into a string
;	Display header and then ASCII/octal string

	printString	hdr

	printString	lstMin
	int2aBin	dword [min], tempString
	printString	tempString
	printString	newLine

	printString	lstMed
	int2aBin	dword [med], tempString
	printString	tempString
	printString	newLine

	printString	lstMax
	int2aBin	dword [max], tempString
	printString	tempString
	printString	newLine

	printString	lstSum
	int2aBin	dword [sum], tempString
	printString	tempString
	printString	newLine

	printString	lstAve
	int2aBin	dword [avg], tempString
	printString	tempString
	printString	newLine

	printString	newLine

; -----
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rdi, EXIT_SUCCESS
	syscall

