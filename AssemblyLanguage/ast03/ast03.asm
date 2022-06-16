; *****************************************************************
;  Name: Thien Nguyen
;  NSHE ID: 2001904928
;  Section: 1004
;  Assignment: 3
;  Description: Assembly language arithmetic operations.
;		Formulas provided on assignment.
;		Focus on learning basic arithmetic operations
;		(add, subtract, multiply, and divide).
;		Ensure understanding of sign and unsigned operations.

; *****************************************************************
;  Data Declarations (provided).

section	.data

; -----
;  Define constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0		; Successful operation

SYS_exit	equ	60			; call code for terminate

; -----
;  Assignment #3 data declarations

; byte data
bNum1		db	34
bNum2		db	21
bNum3		db	19
bNum4		db	15
bNum5		db	-46
bNum6		db	-69
bAns1		db	0
bAns2		db	0
bAns3		db	0
bAns4		db	0
bAns5		db	0
bAns6		db	0
bAns7		db	0
bAns8		db	0
bAns9		db	0
bAns10		db	0
wAns11		dw	0
wAns12		dw	0
wAns13		dw	0
wAns14		dw	0
wAns15		dw	0
bAns16		db	0
bAns17		db	0
bAns18		db	0
bRem18		db	0
bAns19		db	0
bAns20		db	0
bAns21		db	0
bRem21		db	0

; word data
wNum1		dw	2356
wNum2		dw	1953
wNum3		dw	821
wNum4		dw	319
wNum5		dw	-1753
wNum6		dw	-1276
wAns1		dw	0
wAns2		dw	0
wAns3		dw	0
wAns4		dw	0
wAns5		dw	0
wAns6		dw	0
wAns7		dw	0
wAns8		dw	0
wAns9		dw	0
wAns10		dw	0
dAns11		dd	0
dAns12		dd	0
dAns13		dd	0
dAns14		dd	0
dAns15		dd	0
wAns16		dw	0
wAns17		dw	0
wAns18		dw	0
wRem18		dw	0
wAns19		dw	0
wAns20		dw	0
wAns21		dw	0
wRem21		dw	0

; double-word data
dNum1		dd	4365870
dNum2		dd	132451
dNum3		dd	18671
dNum4		dd	8473
dNum5		dd	-217982
dNum6		dd	-215358
dAns1		dd	0
dAns2		dd	0
dAns3		dd	0
dAns4		dd	0
dAns5		dd	0
dAns6		dd	0
dAns7		dd	0
dAns8		dd	0
dAns9		dd	0
dAns10		dd	0
qAns11		dq	0
qAns12		dq	0
qAns13		dq	0
qAns14		dq	0
qAns15		dq	0
dAns16		dd	0
dAns17		dd	0
dAns18		dd	0
dRem18		dd	0
dAns19		dd	0
dAns20		dd	0
dAns21		dd	0
dRem21		dd	0

; quadword data
qNum1		dq	1204623
qNum2		dq	1043819
qNum3		dq	415331
qNum4		dq	251197
qNum5		dq	-921028
qNum6		dq	-281647
qAns1		dq	0
qAns2		dq	0
qAns3		dq	0
qAns4		dq	0
qAns5		dq	0
qAns6		dq	0
qAns7		dq	0
qAns8		dq	0
qAns9		dq	0
qAns10		dq	0
dqAns11		ddq	0
dqAns12		ddq	0
dqAns13		ddq	0
dqAns14		ddq	0
dqAns15		ddq	0
qAns16		dq	0
qAns17		dq	0
qAns18		dq	0
qRem18		dq	0
qAns19		dq	0
qAns20		dq	0
qAns21		dq	0
qRem21		dq	0

; *****************************************************************

section	.text
global _start
_start:

; ----------------------------------------------
;  BYTE Operations

; -----
;  unsigned byte additions
;	bAns1 = bNum1 + bNum3
;	bAns2 = bNum2 + bNum4
;	bAns3 = bNum3 + bNum2

	mov al, byte[bNum1]
	add al, byte[bNum3]
	mov byte[bAns1], al

	mov al, byte[bNum2]
	add al, byte[bNum4]
	mov byte[bAns2], al

	mov al, byte[bNum3]
	add al, byte[bNum2]
	mov byte[bAns3], al

; -----
;  signed byte additions
;	bAns4 = bNum6 + bNum4
;	bAns5 = bNum6 + bNum3

	mov al, byte[bNum6]
	add al, byte[bNum4]
	mov byte[bAns4], al

	mov al, byte[bNum6]
	add al, byte[bNum3]
	mov byte[bAns5], al

; -----
;  unsigned byte subtractions
;	bAns6 = bNum1 - bNum2
;	bAns7 = bNum2 - bNum3
;   bAns8 = bNum2 - bNum4

	mov al, byte[bNum1]
	sub al, byte[bNum2]
	mov byte[bAns6], al

	mov al, byte[bNum2]
	sub al, byte[bNum3]
	mov byte[bAns7], al

	mov al, byte[bNum2]
	sub al, byte[bNum4]
	mov byte[bAns8], al

; -----
;  signed byte subtraction
;	bAns9 = bNum6 - bNum4
;	bAns10 = bNum6 - bNum5

	mov al, byte[bNum6]
	sub al, byte[bNum4]
	mov byte[bAns9], al

	mov al, byte[bNum6]
	sub al, byte[bNum5]
	mov byte[bAns10], al

; -----
;  unsigned byte multiplication
;	wAns11 = bNum1 * bNum3
;	wAns12 = bNum2 * bNum3
;	wAns13 = bNum2 * bNum4

	mov al, byte[bNum1]
	mul byte[bNum3]
	mov word[wAns11], ax

	mov al, byte[bNum2]
	mul byte[bNum3]
	mov word[wAns12], ax

	mov al, byte[bNum2]
	mul byte[bNum4]
	mov word[wAns13], ax

; -----
;  signed byte multiplication
;	wAns14 = bNum5 * bNum2
;	wAns15 = bNum6 * bNum3
;   Just need to mov the bits to the higher register for bytes

	mov al, byte[bNum5]
	imul byte[bNum2]
	mov word[wAns14], ax

	mov al, byte[bNum6]
	imul byte[bNum3]
	mov word[wAns15], ax

; -----
;  unsigned byte division
;	bAns16 = bNum1 / bNum2
;	bAns17 = bNum1 / bNum3 
;	bAns18 = wNum2 / bNum4 
;	bRem18 = modulus (wNum2 / bNum4)

	mov al, byte[bNum1]
	mov ah, 0
	div byte[bNum2]
	mov byte[bAns16], al

	mov al, byte[bNum1]
	mov ah, 0
	div byte[bNum3]
	mov byte[bAns17], al

;   This need to be in the upper 1 byte, Line 441
	mov al, byte[wNum2]
	mov ah, byte[wNum2+1]
	div byte[bNum4]
	mov byte[bAns18], al
	mov byte[bRem18], ah

; -----
;  signed byte division
;	bAns19 = bNum5 / bNum3
;	bAns20 = bNum6 / bNum5
;	bAns21 = wNum4 / bNum1
;	bRem21 = modulus (wNum4 / bNum1)

	mov al, byte[bNum5]
	cbw
	idiv byte[bNum3]
	mov byte[bAns19], al

	mov al, byte[bNum6]
	cbw
	idiv byte[bNum5]
	mov byte[bAns20], al

	mov al, byte[wNum4]
	mov ah, byte[wNum4+1]
	idiv byte[bNum1]
	mov byte[bAns21], al
	mov byte[bRem21], ah

; *****************************************
;  WORD Operations

; -----
;  unsigned word additions
;	wAns1 = wNum1 + wNum2
;	wAns2 = wNum2 + wNum4
;	wAns3 = wNum3 + wNum4

	mov ax, word[wNum1]
	add ax, word[wNum2]
	mov word[wAns1], ax

	mov ax, word[wNum2]
	add ax, word[wNum4]
	mov word[wAns2], ax

	mov ax, word[wNum3]
	add ax, word[wNum4]
	mov word[wAns3], ax

; -----
;  signed word additions
;	wAns4 = wNum5 + wNum3
;	wAns5 = wNum6 + wNum1

	mov ax, word[wNum5]
	add ax, word[wNum3]
	mov word[wAns4], ax

	mov ax, word[wNum6]
	add ax, word[wNum1]
	mov word[wAns5], ax

; -----
;  unsigned word subtractions
;	wAns6 = wNum1 - wNum2
;	wAns7 = wNum2 - wNum3
;	wAns8 = wNum3 - wNum4

	mov ax, word[wNum1]
	sub ax, word[wNum2]
	mov word[wAns6], ax

	mov ax, word[wNum2]
	sub ax, word[wNum3]
	mov word[wAns7], ax

	mov ax, word[wNum3]
	sub ax, word[wNum4]
	mov word[wAns8], ax

; -----
;  signed word subtraction
;	wAns9 = wNum5 - wNum2
;	wAns10 = wNum6 - wNum3

	mov ax, word[wNum5]
	sub ax, word[wNum2]
	mov word[wAns9], ax

	mov ax, word[wNum6]
	sub ax, word[wNum3]
	mov word[wAns10], ax

; -----
;  unsigned word multiplication
;	dAns11 = wNum1 * wNum2
;	dAns12 = wNum2 * wNum3
;	dAns13 = wNum3 * wNum4
;   A higher oder bits, to contain the full answer

	mov ax, word[wNum1]
	mul word[wNum2]
	mov word[dAns11], ax
	mov word[dAns11+2], dx

	mov ax, word[wNum2]
	mul word[wNum3]
	mov word[dAns12], ax
	mov word[dAns12+2], dx

	mov ax, word[wNum3]
	mul word[wNum4]
	mov word[dAns13], ax
	mov word[dAns13+2], dx

; -----
;  signed word multiplication
;	dAns14 = wNum5 * wNum1
;	dAns15 = wNum6 * wNum2
;   Same but we ust imul, that is the only different

	mov ax, word[wNum5]
	imul word[wNum1]
	mov word[dAns14], ax
	mov word[dAns14+2], dx

	mov ax, word[wNum6]
	imul word[wNum2]
	mov word[dAns15], ax
	mov word[dAns15+2], dx

; -----
;  unsigned word division
;	wAns16 = wNum1 / wNum2
;	wAns17 = wNum2 / wNum3
;	wAns18 = dNum3 / wNum4 
;	wRem18 = modulus (dNum3 / wNum4) 
;   Need to assign later half to 0, so we wont get garbage value

	mov ax, word[wNum1]
	mov dx, 0
	div word[wNum2]
	mov word[wAns16], ax

	mov ax, word[wNum2]
	mov dx, 0
	div word[wNum3]
	mov word[wAns17], ax

	mov ax, word[dNum3]
	mov dx, word[dNum3+2]
	div word[wNum4]
	mov word[wAns18], ax
	mov word[wRem18], dx

; -----
;  signed word division
;	wAns19 = wNum5 / wNum3
;	wAns20 = wNum6 / wNum4
;	wAns21 = dNum1 / wNum2
;	wRem21 = modulus (dNum1 / wNum2)
;   Signed conversion instruction do the 0 and convert 0 and 1 for us

	mov ax, word[wNum5]
	cwd
	idiv word[wNum3]
	mov word[wAns19], ax

	mov ax, word[wNum6]
	cwd
	idiv word[wNum4]
	mov word[wAns20], ax

;   This need to be inspect, Line 270
	mov ax, word[dNum1]
	mov dx, word[dNum1+2]
	idiv word[wNum2]
	mov word[wAns21], ax
	mov word[wRem21], dx

; *****************************************
;  DOUBLEWORD Operations

; -----
;  unsigned double word additions
;	dAns1 = dNum1 + dNum2
;	dAns2 = dNum2 + dNum3
;	dAns3 = dNum3 + dNum4

	mov eax, dword[dNum1]
	add eax, dword[dNum2]
	mov dword[dAns1], eax

	mov eax, dword[dNum2]
	add eax, dword[dNum3]
	mov dword[dAns2], eax

	mov eax, dword[dNum3]
	add eax, dword[dNum4]
	mov dword[dAns3], eax

; -----
;  signed double word additions
;	dAns4 = dNum5 + dNum3
;	dAns5 = dNum6 + dNum4

	mov eax, dword[dNum5]
	add eax, dword[dNum3]
	mov dword[dAns4], eax

	mov eax, dword[dNum6]
	add eax, dword[dNum4]
	mov dword[dAns5], eax

; -----
;  unsigned double word subtractions
;	dAns6 = dNum1 - dNum2
;	dAns7 = dNum2 - dNum3
;	dAns8 = dNum3 - dNum4

	mov eax, dword[dNum1]
	sub eax, dword[dNum2]
	mov dword[dAns6], eax

	mov eax, dword[dNum2]
	sub eax, dword[dNum3]
	mov dword[dAns7], eax

	mov eax, dword[dNum3]
	sub eax, dword[dNum4]
	mov dword[dAns8], eax

; -----
;  signed double word subtraction
;	dAns9 = dNum5 - dNum2
;	dAns10 = dNum6 - dNum3 

	mov eax, dword[dNum5]
	sub eax, dword[dNum2]
	mov dword[dAns9], eax

	mov eax, dword[dNum6]
	sub eax, dword[dNum3]
	mov dword[dAns10], eax

; -----
;  unsigned double word multiplication
;	qAns11 = dNum1 * dNum2
;	qAns12 = dNum2 * dNum3
;	qAns13 = dNum3 * dNum4

	mov eax, dword[dNum1]
	mul dword[dNum2]
	mov dword[qAns11], eax
	mov dword[qAns11+4], edx

	mov eax, dword[dNum2]
	mul dword[dNum3]
	mov dword[qAns12], eax
	mov dword[qAns12+4], edx

	mov eax, dword[dNum3]
	mul dword[dNum4]
	mov dword[qAns13], eax
	mov dword[qAns13+4], edx

; -----
;  signed double word multiplication
;	qAns14 = dNum5 * dNum1
;	qAns15 = dNum6 * dNum2

	mov eax, dword[dNum5]
	imul dword[dNum1]
	mov dword[qAns14], eax
	mov dword[qAns14+4], edx

	mov eax, dword[dNum6]
	imul dword[dNum2]
	mov dword[qAns15], eax
	mov dword[qAns15+4], edx

; -----
;  unsigned double word division
;	dAns16 = dNum2 / dNum3
;	dAns17 = dNum3 / dNum4
;	dAns18 = qAns13 / dNum2
;	dRem18 = modulus (qAns13 / dNum2)

	mov eax, dword[dNum2]
	mov edx, 0
	div dword[dNum3]
	mov dword[dAns16], eax

	mov eax, dword[dNum3]
	mov edx, 0
	div dword[dNum4]
	mov dword[dAns17], eax

	mov eax, dword[qAns13]
	mov edx, dword[qAns13+4]
	div dword[dNum2]
	mov dword[dAns18], eax
	mov dword[dRem18], edx

; -----
;  signed double word division
;	dAns19 = dNum5 / dNum2
;	dAns20 = dNum6 / dNum3
;	dAns21 = qAns12 / dNum4
;	dRem21 = modulus (qAns12 / dNum4)

	mov eax, dword[dNum5]
	cdq
	idiv dword[dNum2]
	mov dword[dAns19], eax

	mov eax, dword[dNum6]
	cdq
	idiv dword[dNum3]
	mov dword[dAns20], eax

	mov eax, dword[qAns12]
	mov edx, dword[qAns12+4]
	idiv dword[dNum4]
	mov dword[dAns21], eax
	mov dword[dRem21], edx


; *****************************************
;  QUADWORD Operations

; -----
;  unsigned quadword additions
;	qAns1  = qNum1 + qNum2
;	qAns2  = qNum2 + qNum3
;	qAns3  = qNum3 + qNum4

	mov rax, qword[qNum1]
	add rax, qword[qNum2]
	mov qword[qAns1], rax

	mov rax, qword[qNum2]
	add rax, qword[qNum3]
	mov qword[qAns2], rax

	mov rax, qword[qNum3]
	add rax, qword[qNum4]
	mov qword[qAns3], rax

; -----
;  signed quadword additions
;	qAns4  = qNum5 + qNum1
;	qAns5  = qNum6 + qNum2

	mov rax, qword[qNum5]
	add rax, qword[qNum1]
	mov qword[qAns4], rax

	mov rax, qword[qNum6]
	add rax, qword[qNum2]
	mov qword[qAns5], rax

; -----
;  unsigned quadword subtractions
;	qAns6  = qNum1 - qNum2
;	qAns7  = qNum2 - qNum3
;	qAns8  = qNum3 - qNum4

	mov rax, qword[qNum1]
	sub rax, qword[qNum2]
	mov qword[qAns6], rax

	mov rax, qword[qNum2]
	sub rax, qword[qNum3]
	mov qword[qAns7], rax

	mov rax, qword[qNum3]
	sub rax, qword[qNum4]
	mov qword[qAns8], rax

; -----
;  signed quadword subtraction
;	qAns9  = qNum5 - qNum3
;	qAns10 = qNum6 - qNum4

	mov rax, qword[qNum5]
	sub rax, qword[qNum3]
	mov qword[qAns9], rax

	mov rax, qword[qNum6]
	sub rax, qword[qNum4]
	mov qword[qAns10], rax

; -----
;  unsigned quadword multiplication
;	dqAns11  = qNum1 * qNum2
;	dqAns12  = qNum2 * qNum3
;	dqAns13  = qNum3 * qNum4

	mov rax, qword[qNum1]
	mul qword[qNum2]
	mov qword[dqAns11], rax
	mov qword[dqAns11+8], rdx

	mov rax, qword[qNum2]
	mul qword[qNum3]
	mov qword[dqAns12], rax
	mov qword[dqAns12+8], rdx

	mov rax, qword[qNum3]
	mul qword[qNum4]
	mov qword[dqAns13], rax
	mov qword[dqAns13+8], rdx

; -----
;  signed quadword multiplication
;	dqAns14  = qNum5 * qNum3
;	dqAns15  = qNum6 * qNum4

	mov rax, qword[qNum5]
	imul qword[qNum3]
	mov qword[dqAns14], rax
	mov qword[dqAns14+8], rdx

	mov rax, qword[qNum6]
	imul qword[qNum4]
	mov qword[dqAns15], rax
	mov qword[dqAns15+8], rdx

; -----
;  unsigned quadword division
;	qAns16 = qNum1 / qNum2
;	qAns17 = qNum2 / qNum3
;	qAns18 = dqAns13 / qNum2
;	qRem18 = dqAns13 % qNum2

	mov rax, qword[qNum1]
	mov rdx, 0
	div qword[qNum2]
	mov qword[qAns16], rax

	mov rax, qword[qNum2]
	mov rdx, 0
	div qword[qNum3]
	mov qword[qAns17], rax

	mov rax, qword[dqAns13]
	mov rdx, qword[dqAns13+8]
	div qword[qNum2]
	mov qword[qAns18], rax
	mov qword[qRem18], rdx

; -----
;  signed quadword division
;	qAns19 = qNum5 / qNum3
;	qAns20 = qNum6 / qNum4
;	qAns21 = dqAns12 / qNum6
;	qRem21 = dqAns12 % qNum6

	mov rax, qword[qNum5]
	cqo
	idiv qword[qNum3]
	mov qword[qAns19], rax

	mov rax, qword[qNum6]
	cqo
	idiv qword[qNum4]
	mov qword[qAns20], rax

	mov rax, qword[dqAns12]
	mov rdx, qword[dqAns12+8]
	idiv qword[qNum6]
	mov qword[qAns21], rax
	mov qword[qRem21], rdx

; *****************************************************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit		; call code for exit (SYS_exit)
	mov	rdi, EXIT_SUCCESS
	syscall

