
	; TODO
	; a1 = [ |j| / k - i / 5 ] / j
	; a2 = [ |j| / k - i / 5 ] % j
%macro tstCalc 5

	mov rdi, 5
	mov r10d, dword[%2]
	cmp dword[%2], 0
	jge %%doneAbs
	neg dword[%2]

%%doneAbs:

	mov eax, 0
	mov eax, dword[%2]				; |j|
	cdq
	idiv dword[%3]					; |j| / k
	mov dword[%4], eax				; a1 = [ |j| / k ]

	mov eax, dword[%1]				; i
	sub eax, rdi					; i - 5
	mov dword[iMinus5], eax			; hold the value

	mov eax, 0
	mov eax, dword[%4]				
	sub eax, dword[iMinus5]			; [ |j| / k - i / 5 ]

	mov eax, dword[%4]				; get that bracket
	cdq								; signed shit
	idiv r10d						; [ |j| / k - i / 5 ] / j
	mov dword[%4], eax				; a1 = [ |j| / k - i / 5 ] / j
	mov dword[%5], edx				; a5 = [ |j| / k - i / 5 ] / j

%endmacro


	; TODO volume[i] = ( aSides[i] * 2 * base[i] ) / 2
	; TODO  aSides, bases, len, volumes, min, med, max, ave

%macro tstMacro 8

	mov ecx, dword[%3]				; len = counter for our loop
	mov rsi, 0
	mov rdi, 2

volumesLoop:

	mov eax, dword[%2]
	imul rdi
	mov dword[baseTime2+rsi*4]

	mov eax, 0
	movsx eax, byte[%1+rsi]
	mov dword[%4+rsi*4], eax

	cqo
	idiv rdi
	mov dword[%4+rsi*4], eax

	inc rsi
	loop volumesLoop

; Sum, min, max
; Sum, min, max
; Sum, min, max
	mov eax, dword[%4]
	mov dword[%5], eax
	mov dword[%6], eax

	mov rsi, 0
	mov ecx, dword[len]
	mov rsi, 0
	mov ecx, dword[len]

startLoop:
	mov eax, dword[%4+rsi*4]
	add dword[sum], eax
	cmp eax, dword[&7]
	jle maxDone
	mov dword[%7], eax

maxDone:
	cmp eax, dword[%5]
	jge minDone
	mov dword[%5], eax

minDone:
	inc rsi
	loop startLoop

; med, ave
; med, ave
	mov eax, dword[%3]
	mov edx, 0
	mov r8d, 2
	cdq
	idiv r8d
	mov rsi, 0
	mov esi, eax

	mov eax, dword[%4+rsi*4]
	dec rsi
	add eax, dword[%4+rsi*4]
	cdq
	idiv r8d
	mov dword[%6], eax

	mov eax, dword[sum]
	cdq
	idiv dword[%3]
	mov dword[%8], eax

%endmacro


; *****************************************************************
;  Static Data Declarations (initialized)

section	.data

; -----
;  Define standard constants.

NULL			equ	0			; end of string

TRUE			equ	1
FALSE			equ	0

EXIT_SUCCESS	equ	0			; Successful operation
SYS_exit		equ	60			; call code for terminate

; -----
;  Initialized Static Data Declarations.

;	Place data declarations here...

i 			dd  5
j 			dd  2
k 			dd  4
a1 			dd 	0
a2 			dd 	0
sum			dd  0
iMinus5  	dd  0

; -----
;  Misc. data definitions (if any).

swapped		db	TRUE

; -----

section	.bss


baseTime2      	 	resd    100			; len

; =====================================================================

section	.text
global	_start
_start:

; -----

	; TODO
	; a1 = [ |j| / k - i / 5 ] / j
	; a2 = [ |j| / k - i / 5 ] % j

	; tstscalc i, j , k a1, a2

	; tstMacro aSides, bases, len, volumes, min, med, max, ave

; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rdi, EXIT_SUCCESS	; return code of 0 (no error)
	syscall
