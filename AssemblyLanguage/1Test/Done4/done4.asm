
; tstPoints x, y, zw, pt1, pt2

; pnt1 = (x+y+zW) / (x^2 / 2)
; pnt1 = (x+y+zW) % (x^2 / 2)

%macro tstPoints 5

	push	rax						; save altered registers, used
	push	rdi	
	push	rsi
	push	rdx						; used, for operation
	push	rcx

    mov rdi, 2
    mov eax, 0
    mov eax, dword[%1]              ; we get x^2
    imul eax
    mov dword[%4], eax
    mov dword[%4+4], edx            ; singed data, get the full result

    cqo
    idiv rdi                        ; singed extend
    mov dword[%4], eax              ; x(^2) / 2 is store in pt1, temorary

    cmp word[%3], 0                 ; working on the absolute value of %3
    jge %%doneAbs
    neg word[%3]

%%doneAbs:

    mov eax, 0
	mov eax, dword[%1]				; x+y+z
	add eax, dword[%2]				 
	add ax, word[%3]

    cdq                             ; divive (x+y+z) / x(^2) / 2
    idiv dword[%4]
    mov dword[%4], eax              ; the result store in eax, put in pt1
    mov dword[%5], edx              ; the remainder store in edx, put in pt2    

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

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Initialized Static Data Declarations.

;	Place data declarations here...



zW 		dw  5

x 		dd  2
y 		dd  4
pt1 	dd 	0
pt2 	dd 	0


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

    tstPoints x, y, zW, pt1, pt2

;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rdi, EXIT_SUCCESS	; return code of 0 (no error)
	syscall
