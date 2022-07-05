; TODO ans = calc(n1, n2, n3);
;  Inputs: n1, n2, n3
;  Outputs: ans
;  Description: This function will perform a simple arithmetic operation.
;  It will take three numbers and perform the following operation:

global cal
cal:
    push rbx

    mov ebx, edx

    mov r10d, 4             ; 4
    add r10d, esi           ; n2 + 4
    mov eax, r10d           ; eax = n2 + 4
    mov edx, 0
    div dword[rbx]          ; n2 + 4 / n3

    mul edi                 ; n1 * ((n2+4) / n3)
                            ; ans would be store in eax
    pop rbx
ret


; TODO ans = diviveBy(num) (num / stackDynamicLocal)

global diveiBy
divideBy:

    push rbp
    mov rbp, rsp
    sub rsp, 4
    push rbx

    lea rbx, byte[rbp-4]

    mov dword[rbp-4], 42

    mov rax, rdi                ; get the first argument into rax
    cdq
    idiv dword[rbx]


    pop rbx
    mov rsp, rbp
    pop rbp
ret

; TODO ans = calcFunc(x, y) ans = (x*x) + (y*y)

global calcFun
calcFun:
mulsd xmm0, xmm0
mulsd xmm1, xmm1
addsd xmm0, xmm1
ret

; TODO ans = calcFunc(x, y) ans = (x+x) * (y+y)

global calcFun
calcFun:
addsd xmm0, xmm0
addsd xmm1, xmm1
mulsd xmm0, xmm1
ret

; TODO ./prog -n <intNumberString>
; TODO bool = getArgs(argc, &argv, &intNum) [bool = str2int(str, &ans)]
global getArgs
getArg:

	; CHECK ARGUMENTS COUNT
	cmp rdi, 3
	jne error

	; CHECK argu[1]
	mov r10, qword[rsi+8]
	cmp byte[r10], '-'
	jne error
	cmp byte[r10+1], 'n'
	jne error
	cmp byte[r10+2], NULL
	jne error

	; CHECK argu[2]
	mov rdi,  qword[rsi+16]
	mov rsi,  rdx
	call str2int

	cmp rax,  TRUE
	jne error
	
	mov rax, TRUE
	jmp esc

error:
	mov rax, false
esc:

ret


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


; TODO PLACE DATA HERE


; ----------------------------------------------
;  Uninitialized Static Data Declarations.

section	.bss

;	Place data declarations for uninitialized data here...
;	(i.e., large arrays that are not initialized)


; *****************************************************************

section	.text
global _start
_start:


; -----
;	YOUR CODE GOES HERE...

;	The general form of the move instruction is:
;	mov <dest>, <src>


; TODO START HERE


; TODO aveAll = getStasts(a, b, c, d, &sumAll, &sumAB, &sumABC)
; TODO write the code to call the function

    mov edi, dword[a]
    mov esi, dword[b]
    mov edx, dword[c]
    mov ecx, dword[d]
    mov r8, sumAll
    mov r9, sumAB
    mov r10, sumABC
    push r10
    call getStasts
    mov dword[aveAll], eax
    add rsp, 8





; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rdi, EXIT_SUCCESS	; return code of 0 (no error)
	syscall
