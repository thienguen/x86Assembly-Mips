; *****************************************************************
;  Name: Marcos Villanueva Abreu
;  NSHE ID: 5006480097
;  Section: 1003
;  Assignment: 6
;  Description:	Simple assembly language program to calculate 
;		the diameters if a circle for a series of circles.
;		The circle radii lengths are provided as septenary values
;		represented as ASCII characters and must be converted into
;		integer in order to perform the calculations.

; =====================================================================
;  STEP #2
;  Macro to convert ASCII/septenary value into an integer.
;  Reads <string>, convert to integer and place in <integer>
;  Assumes valid data, no error checking is performed.

;  Arguments:
;	%1 -> <string>, register -> string address
;	%2 -> <integer>, register -> result

;  Macro usgae
;	aSept2int  <string>, <integer>

;  Example usage:
;	aSept2int	rbx, tmpInteger

;  For example, to get address into a local register:
;		mov	rsi, %1

;  Note, the register used for the macro call (rbx in this example)
;  must not be altered before the address is copied into
;  another register (if desired).

%macro	aSept2int	2

;	STEP #2
mov r10, 0
mov rcx, 0


mov eax, 0
mov ecx, 0
mov r11, 0
mov r9, 0 ; i=0

%%skpBlanks:
	; get char, char = str[i]
	mov cl, byte [%1 + r9]
	; if char != blank : goto getSign
	cmp cl, " "
	jne %%getSign
	inc r9 ; i++
	jmp %%skpBlanks
%%getSign:
	; r10 = sign = 1
	mov r10, 1
	inc r9
	cmp cl, "-" ; if(char == '-') r10 = -1
	jne %%nextChar
	mov r10, -1 
%%nextChar:
	; get char, char = str[i]
	mov ecx, 0
	mov cl, byte [%1 + r9]
	; if(char == NULL) goto charLpDone
	cmp cl, NULL
	je %%charLpDone
	; convert char to int
	sub cl, "0"
	; rSum = (rSum * 7) + int
	mov r11d, 7
	mul r11d
	add eax, ecx
	inc r9
	jmp %%nextChar
%%charLpDone:
	; length = length * sign
	imul r10d
	mov dword [%2], eax

%endmacro

; =====================================================================
;  Macro to convert integer to septenary value in ASCII format.
;  Reads <integer>, converts to ASCII/septenary string including
;	NULL into <string>

;  Note, the macro is calling using RSI, so the macro itself should
;	 NOT use the RSI register until is saved elsewhere.

;  Arguments:
;	%1 -> <integer>, value
;	%2 -> <string>, string address

;  Macro usgae
;	int2aSept	<integer-value>, <string-address>

;  Example usage:
;	int2aSept	dword [diamsArrays+rsi*4], tempString

;  For example, to get value into a local register:
;		mov	eax, %1

%macro	int2aSept	2

;	STEP #5
mov r13, 0
; mov r12, 0
; mov rcx, 0
; mov r11, 0
; mov rax, 0
; mov rbx, 0
; mov rsi, 0

    mov r10, 0 ; count = 0
    movsxd rax, %1
    mov ebx, eax ; getting absolute value of eax
    neg eax
    cmovl eax, ebx
    mov r11, 7

    ; repeat until ans = 0
%%stackPushLp:
	mov edx, 0
	div r11d ; divide by 7
	push rdx ; pushing remainder to stack
	inc r10 ; increment count

	cmp eax, 0
	jne %%stackPushLp

    mov rsi, STR_LENGTH ; rsi = 12
    dec rsi ; rsi = 11
    sub rsi, r10 ; rsi = 11 - count
    mov rcx, 0
    dec rsi
%%addBlank:
	mov byte[%2 + rcx], SPACE
	inc ecx
	cmp ecx, esi ; if (i == rsi) break
	jne %%addBlank

    ; adding sign
    mov ebx, %1
    cmp ebx, 0
    jge %%makePositive
    mov byte [%2 + rcx], "-"
    jmp %%signAdded
%%makePositive:
	mov byte [%2 + rcx], "+"

%%signAdded:
	inc ecx

%%stackPopLp:
	pop r12
	add r12b, "0" ; convert integer to char
	mov byte [%2 + rcx], r12b ; store in string
	inc ecx ; i++
	dec r10
	cmp r10, 0
	jne %%stackPopLp

mov dword [%2 + cx], NULL ; add NULL to end of string

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
	push	rax			; save altered registers (cautionary)
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

	mov	rax, SYS_write		; system call for write (SYS_write)
	mov	rdi, STDOUT		; standard output
	lea	rsi, [%1]		; address of the string
	syscall				; call the kernel

	pop	rcx			; restore registers to original values
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

EXIT_SUCCESS	equ	0			; successful operation
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

NUMS_PER_LINE	equ	4


; -----
;  Assignment #6 Provided Data

STR_LENGTH	equ	12			; chars in string, with NULL

septRadii	db	"         +5", NULL, "        +10", NULL, "        +16", NULL
		db	"        +24", NULL, "        +35", NULL, "        +46", NULL
		db	"        +55", NULL, "        +63", NULL, "       +106", NULL
		db	"       +143", NULL, "       +144", NULL, "       +155", NULL
		db	"      -2542", NULL, "      -1610", NULL, "      -1361", NULL
		db	"       +266", NULL, "       +330", NULL, "       +421", NULL
		db	"       +502", NULL, "       +516", NULL, "       +642", NULL
		db	"      +1161", NULL, "      +1135", NULL, "      +1246", NULL
		db	"      -1116", NULL, "      -1000", NULL, "       -136", NULL
		db	"      +1540", NULL, "      +1651", NULL, "      +2151", NULL
		db	"      +2161", NULL, "     +10063", NULL, "     -11341", NULL
		db	"     +12224", NULL
aSeptLength	db	"        +46", NULL
length		dd	0

diamSum		dd	0
diamAve		dd	0
diamMin		dd	0
diamMax		dd	0

; -----
;  Misc. variables for main.

hdr		db	"-----------------------------------------------------"
		db	LF, ESC, "[1m", "CS 218 - Assignment #6", ESC, "[0m", LF
		db	"Diameter Calculations", LF, LF
		db	"Diameters:", LF, NULL
shdr		db	LF, "Diameters Sum:  ", NULL
avhdr		db	LF, "Diameters Ave:  ", NULL
minhdr		db	LF, "Diameters Min:  ", NULL
maxhdr		db	LF, "Diameters Max:  ", NULL

newLine		db	LF, NULL
spaces		db	"   ", NULL

ddTwo		dd	2

; =====================================================================
;  Uninitialized variables

section	.bss

tmpInteger	resd	1				; temporaty value

diamsArray	resd	34

lenString	resb	STR_LENGTH
tempString	resb	STR_LENGTH			; bytes

diamSumString	resb	STR_LENGTH
diamAveString	resb	STR_LENGTH
diamMinString	resb	STR_LENGTH
diamMaxString	resb	STR_LENGTH

; **************************************************************

section	.text
global	_start
_start:

; -----
;  Display assignment initial headers.

	printString	hdr

; -----
;  STEP #1
;	Convert integer length, in ASCII septenary format to integer.
;	Do not use macro here...
;	Read string aSeptLength1, convert to integer, and store in length

mov r8, aSeptLength ; addr of string
mov r9, 0 ; i=0

skpBlanks:
	; get char, char = str[i]
	mov cl, byte [r8 + r9]
	; if char != blank : goto getSign
	cmp cl, " "
	jne getSign
	inc r9 ; i++
	jmp skpBlanks
getSign:
	; r10 = sign = 1
	mov r10, 1
	inc r9
	cmp cl, "-" ; if(char == '-') r10 = -1
	jne nextChar
	mov r10, -1 
nextChar:
	; get char, char = str[i]
	mov ecx, 0
	mov cl, byte [r8 + r9]
	; if(char == NULL) goto charLpDone
	cmp cl, NULL
	je charLpDone
	; convert char to int
	sub cl, "0"
	; rSum = (rSum * 7) + int
	mov r11d, 7
	mul r11d
	add eax, ecx
	inc r9
	jmp nextChar
charLpDone:
	; length = length * sign
	imul r10d
	mov dword [length], eax

; -----
;  Convert radii from ASCII/septenary format to integer.
;  STEP #2 must complete before this code.

	mov	ecx, dword [length]
	mov	rdi, 0					; index for radii
	mov	rbx, septRadii
cvtLoop:
	push	rbx					; safety push's
	push	rcx
	push	rdi
	aSept2int	rbx, tmpInteger
	pop	rdi
	pop	rcx
	pop	rbx

	mov	eax, dword [tmpInteger]
	mul	dword [ddTwo]				; diam = radius * 2
	mov	dword [diamsArray+rdi*4], eax
	add	rbx, STR_LENGTH

	inc	rdi
	dec	ecx
	cmp	ecx, 0
	jne	cvtLoop

; -----
;  Display each the diamsArray (four per line).

	mov	ecx, dword [length]
	mov	rsi, 0
	mov	r12, 0
printLoop:
	push	rcx					; safety push's
	push	rsi
	push	r12

	mov	eax, dword [diamsArray+rsi*4]
	int2aSept	eax, tempString

	printString	tempString
	printString	spaces

	pop	r12
	pop	rsi
	pop	rcx

	inc	r12
	cmp	r12, 4
	jne	skipNewline
	mov	r12, 0
	printString	newLine
skipNewline:
	inc	rsi

	dec	ecx
	cmp	ecx, 0
	jne	printLoop
	printString	newLine

; -----
;  STEP #3
;	Find diamaters array stats (sum, min, max, and average).
;	Reads data from diamsArray (set above).

;	YOUR CODE GOES HERE
mov rdx, diamsArray
mov rsi, 0
mov ecx, dword [length]
mov r14d, dword [rdx + rsi * 4]
mov dword [diamMin], r14d ; setting first item as min

diamMinLp:
	mov r14d, dword [rdx + rsi * 4]
	cmp dword [diamMin], r14d
	jle minNotFound
	mov dword [diamMin], r14d
minNotFound:
	inc rsi
	dec ecx
	cmp ecx, 0
	jne diamMinLp

mov rdx, diamsArray
mov rsi, 0
mov ecx, dword [length]
mov r14d, dword [rdx + rsi * 4]
mov dword [diamMax], r14d ; setting first item as max
mov rax, 0

diamMaxLp:
	mov r14d, dword [rdx + rsi * 4]
	cmp dword [diamMax], r14d
	jge maxNotFound
	mov dword [diamMax], r14d
maxNotFound:
	add eax, r14d ; sum
	inc rsi
	dec ecx
	cmp ecx, 0
	jne diamMaxLp

mov dword [diamSum], eax
; average
mov edx, 0
mov ecx, dword [length]
div ecx
mov dword [diamAve], eax

; -----
;  STEP #4
;	Convert sum to ASCII/septenary for printing.
;	Do not use macro here...
	printString	shdr

;	Read diamsArray sum inetger (set above), convert to
;		ASCII/septenary and store in diamSumString.

mov r10, 0 ; count = 0
movsxd rax, dword [diamSum]
mov ebx, eax ; getting absolute value of eax
neg eax
cmovl eax, ebx
mov r11, 7
; repeat until ans = 0
stackPushLp:
	cdq
	div r11d ; divide by 7
	push rdx ; pushing remainder to stack
	inc r10 ; increment count
	cmp eax, 0
	jne stackPushLp

mov rsi, STR_LENGTH ; rsi = 12
dec rsi ; rsi = 11
sub rsi, r10 ; rsi = 11 - count
mov rcx, 0
dec rsi
addBlank:
	mov byte[diamSumString + ecx], SPACE
	inc ecx
	cmp ecx, esi ; if (i == rsi) break
	jne addBlank

; adding sign
mov r13d, dword [diamSum]
cmp r13d, 0
jle makeNegative
mov byte [diamSumString + ecx], "+"
jmp signAdded
makeNegative:
	mov byte [diamSumString + ecx], "-"
signAdded:
	inc ecx

stackPopLp:
	pop r12
	add r12b, "0" ; convert integer to char
	mov byte [diamSumString + ecx], r12b ; store in string
	inc ecx ; i++
	dec r10
	cmp r10, 0
	jne stackPopLp

mov dword [diamSumString + ecx], NULL ; add NULL to end of string


;	print the diamSumString (set above).
	printString	diamSumString

; -----
;  Convert average, min, and max integers to ASCII/septenary for printing.
;  STEP #5 must complete before this code.

	printString	avhdr
	int2aSept	dword [diamAve], diamAveString
	printString	diamAveString

	printString	minhdr
	int2aSept	dword [diamMin], diamMinString
	printString	diamMinString

	printString	maxhdr
	int2aSept	dword [diamMax], diamMaxString
	printString	diamMaxString

	printString	newLine
	printString	newLine

	; mov r9, 11
	; int2aSept dword [diamsArray + r9 * 4], diamAveString
	; inc r9
	; int2aSept dword [diamsArray + r9 * 4], diamMinString
	; inc r9
	; int2aSept dword [diamsArray + r9 * 4], diamMaxString


; *****************************************************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rdi, EXIT_SUCCESS
	syscall

