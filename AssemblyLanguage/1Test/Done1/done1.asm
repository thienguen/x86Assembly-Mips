
; points x, y, z, pnt1, pnt2, pnt3, p3rm

; pnt1 = ( z(x + y) ) / (z + 5) ; z is word
; pnt2 = ( x/2 + y/2 )^2 / (x + y + z)
; pnt3 = ( x + y + z ) / (x^2 / 2)
; p3rm = ( x + y + z ) % (x^2 / 2) ; modulo

; x = 2, y = 4, z = 5

%macro  points 7

	push	rax						; save altered registers, used
	push	rdi	
	push	rsi
	push	rdx						; used, for operation
	push	rcx

; ----
; pnt1 = ( z(x + y) ) / (z + 5) ; z is word --> 3
	mov di, word[%3]
	add di, 5						; di = z + 5, rdi used

	mov eax, dword[%1]				; x+y
	add eax, dword[%2]

	mov esi, eax					; store eax result in esi
									; because the value after imul would be overwwrite

	imul word[%3]					; z*(x+y)
	mov dword[%4], eax				; even if it's signed, as destination is the result
	mov dword[%4+4], eax			; still do it for a full size answer, 

	cqo
	idiv di
	mov dword[%4], eax				; pnt1

; ----
; pnt2 = ( x/2 + y/2 )^2 / (x + y + z) --> 1
	mov rdi, 2

	mov eax, 0						; clear eax	
	mov eax, dword[%1]				; x
	cqo 
	idiv rdi						; x/2
	mov dword[%5], eax				; pnt2

	mov r10d, dword[%5]				; r10d = x/2

	mov eax, dword[%2]
	cqo 
	idiv rdi						; y/2
	mov dword[%5], eax				; pnt2
	
	add dword[%5], r10d				; pnt2 = x/2 + y/2 -- so far
	imul dword[%5]					; ^2
	mov dword[%5], eax				; pnt2
	mov dword[%5+4], edx			; pnt2 for the full answer

	mov eax, 0
	mov eax, dword[%1]				; x+y+z
	add eax, dword[%2]				 
	add eax, dword[%3]

	mov ecx, dword[%5]
	cqo
	idiv eax
	mov dword[%5], eax				; pnt2

; ----
; pnt3 = ( x + y + z ) / (x^2 / 2) --> 5
; p3rm = ( x + y + z ) % (x^2 / 2) ; modulo --> 1

	mov eax, 0
	mov eax, dword[%1]
	imul eax
	mov dword[%6], eax				
	mov dword[%6+4], edx				

	cqo
	idiv rdi						; x^2 / 2
	mov dword[%6], eax				; pnt3

	mov eax, 0
	mov eax, dword[%1]				; x+y+z
	add eax, dword[%2]				 
	add ax, word[%3]

	cdq
	idiv dword[%6]					; (x+y+z) / (x^2 / 2)
	mov dword[%6], eax				; pnt3
	mov dword[%7], edx				; p3rm for the remainder

	pop	rcx							; restore registers to original values
	pop	rdx
	pop	rsi
	pop	rdi
	pop	rax

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

z 		dw  5

x 		dd  2
y 		dd  4
pnt1 	dd 	0
pnt2 	dd 	0
pnt3 	dd 	0

p3rm 	dd  0


; -----
;  Misc. data definitions (if any).

swapped		db	TRUE

; -----

section	.bss

; =====================================================================

section	.text
global	_start
_start:

; -----

; pnt1 = ( z(x + y) ) / (z + 5) ; z is word
; pnt2 = ( x/2 + y/2 )^2 / (x + y + z)
; pnt3 = ( x + y + z ) / (x^2 / 2)
; p3rm = ( x + y + z ) % (x^2 / 2) ; modulo

	points x, y, z, pnt1, pnt2, pnt3, p3rm

	mov r15, 0

; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rdi, EXIT_SUCCESS	; return code of 0 (no error)
	syscall
