;  Name: Thien Nguyen
;  NSHE ID: 
;  Section: Summer : 1004
;  Assignment: 1
;  Description: Become familiar with the tool chain, and get 
; comfortable with the use of the debugger, code grade, and asm in general

;   No name, asst, section -> no points!

; *****************************************************************
;  Data Declarations
;	Note, all data is declared statically (for now).

section	.data

; -----
;  Standard constants.

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Byte (8-bit) variable declarations

num1		db	17
num2		db	9

res1		db	0
res2		db	0
res3		dw	0
res4		db	0
rem4		db	0

; -----
;  Word (16-bit) variable declarations

num3		dw	5003
num4		dw	7

res5		dw	0
res6		dw	0
res7		dd	0
res8		dw	0
rem8		dw	0

; -----
;  Double-word (32-bit) variable declarations

num5		dd	100007
num6		dd	1501

res9		dd	0
res10		dd	0
res11		dq	0
res12		dd	0
rem12		dd	0

; -----
;  Quadword (64-bit) variable declarations

num7		dq	12342314
num8		dq	14541

res13		dq	0
res14		dq	0
res15		ddq	0
res16		dq	0
rem16		dq	0


; *****************************************************************
;  Code Section
;  Example calculation for later reference.

section	.text
global _start
_start:

; ----------
;  Byte variables examples (signed data)

;	res1 = num1 + num2

	mov	al, byte [num1]
	add	al, byte [num2]
	mov	byte [res1], al

;	res2 = num1 - num2
	mov	al, byte [num1]
	sub	al, byte [num2]
	mov	byte [res2], al

;	res3 = num1 * num2
	mov	al, byte [num1]
	mul	byte [num2]
	mov	word [res3], ax

;	res4 = num1 / num2
;	rem4 = modulus(num1/num2)
	mov	al, byte [num1]
	cbw
	div	byte [num2]
	mov	byte [res4], al
	mov	byte [rem4], ah

; ----------
;  Word variables examples (signed data)

;	res5 = num3 + num4
	mov	ax, word [num3]
	add	ax, word [num4]
	mov	word [res5], ax

;	res6 = num3 - num4
	mov	ax, word [num3]
	sub	ax, word [num4]
	mov	word [res6], ax

;	res7 = num3 * num4
	mov	ax, word [num3]
	mul	word [num4]
	mov	dword [res7], eax

;	res8 = num3 / num4
;	rem8 = modulus(num3/num4)
	mov	ax, word [num3]
	cwd
	div	word [num4]
	mov	word [res8], ax
	mov	word [rem8], dx

; ----------
;  Double-word variables examples (signed data)

;	res9 = num5 + num6
	mov	eax, dword [num5]
	add	eax, dword [num6]
	mov	dword [res9], eax

;	res10 = num5 - num6
	mov	eax, dword [num5]
	sub	eax, dword [num6]
	mov	dword [res10], eax

;	res11 = num5 * num6
	mov	eax, dword [num5]
	mul	dword [num6]
	mov	dword [res11], eax
	mov	dword [res11+4], edx

;	res12 = num5 / num6
;	rem12 = modulus(num5/num6)
	mov	eax, dword [num5]
	cdq
	div	dword [num6]
	mov	dword [res12], eax
	mov	dword [rem12], edx

; ----------
;  Quadword variables examples (signed data)

;	res13 = num7 + num8
	mov	rax, qword [num7]
	add	rax, qword [num8]
	mov	qword [res13], rax

;	res14 = num7 - num8
	mov	rax, qword [num7]
	sub	rax, qword [num8]
	mov	qword [res14], rax

;	res15 = num7 * num8
	mov	rax, qword [num7]
	mul	qword [num8]
	mov	qword [res15], rax
	mov	qword [res15+8], rdx

;	res16 = num7 / num8
;	rem16 = modulus(num7/num8)
	mov	rax, qword [num7]
	cqo
	div	qword [num8]
	mov	[res16], rax
	mov	[rem16], rdx

; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rdi, EXIT_SUCCESS
	syscall
