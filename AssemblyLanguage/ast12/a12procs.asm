; *****************************************************************
;  Name: Thien Nguyen
;  NSHE ID: 
;  Section: 1004
;  Assignment: 12
;  Description: Write an ASM program that count the mathematicall
;  Perfect nmumber, Abundant number, and Deficient number.

; -----
;  Function - getParameters()
;	Read, parse, and check command line arguments.

;  Function - numberTypeCounter()
;	Thread function to counts of find perfect, abundant,
;	and deficient numbers

;  Function - aBin2intn()
;	Convert a ASCII/binary string to integer, NULL terminated.


; ***************************************************************

section	.data

; -----
;  Define standard constants.

LF			equ	10			; line feed
NULL		equ	0			; end of string
ESC			equ	27			; escape key

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; Successful operation
NOSUCCESS	equ	1			; Unsuccessful operation

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

; -----
;  Globals (used by thread function)

currentIndex	dq	1
myLock			dq	0


root			dq	0

; -----
;  Local variables for thread function.

msgThread1	db	" ...Thread starting...", LF, NULL

; -----
;  Local variables for getParameters function

LIMITMIN	equ	100
LIMITMAX	equ	4000000000

errUsage	db	"Usgae: ./numCounter -th <1|2|3|4> ",
			db	"-lm <binaryNumber>", LF, NULL

errOptions	db	"Error, invalid command line options."
			db	LF, NULL

errTHspec	db	"Error, invalid thread count specifier."
			db	LF, NULL

errTHvalue	db	"Error, invalid thread count value."
			db	LF, NULL

errLSpec	db	"Error, invalid limit value specifier."
			db	LF, NULL

errLValue	db	"Error, invalid limit value."
			db	LF, NULL


; -----
;  Local variables for aBin2int function (if any)


; ***************************************************************

section	.text

; -----
; External statements for thread functions.

extern	pthread_create, pthread_join

; ******************************************************************
;  Function getParams()
;	Get, check, convert, verify range, and return the
;	thread count and limit value.

;  Example HLL call:
;	TODO stat = getParameters(argc, argv, &threadCount, &limitValue)

;  This routine performs all error checking, conversion of ASCII/binary
;  to integer, verifies legal range of each value.
;  For errors, applicable message is displayed and FALSE is returned.
;  For good data, all values are returned via addresses with TRUE returned.

;  Command line format (fixed order):
;*	-th <1|2|3|4> -lm <binaryNumber>

; ----- 
;  Arguments:
;*	1. rdi || ARGC, value
;*	2. rsi || ARGV, address
;*	3. rdx || thread count (dword), address
;*	4. rcx || limit value (qword), address

global getParameters
getParameters:

	push rbx
	push r12
	push r13
	push r14
	push r15

	mov r12, rsi					; r12 = Argyuments Vector
	mov r13, rdx					; r13 = thread count, address
	mov r14, rcx					; r14 = limit value, address

; CHECK Arguements Count
	cmp rdi, 1
	je _errUsage

	cmp rdi, 5
	ja _errOptions

	cmp rdi, 5
	jb _errOptions

; CHECK Argv[1] -- Thread Count Specifier

	mov rbx, qword[r12+8]			; rbx = Arguement[1]
	
	mov al, byte[rbx]				; al = the first character of Arguement[1]
	cmp al, "-"						; check if the first character is '-'
	jne _errTHspec

	mov al, byte[rbx+1]				; al = the second character of Arguement[1]
	cmp al, "t"						; check if the second character is 't'
	jne _errTHspec

	mov al, byte[rbx+2]				; al = the third character of Arguement[1]
	cmp al, "h"						; check if the third character is 'h'
	jne _errTHspec

	mov al, byte[rbx+3]				; al = the fourth character of Arguement[1]
	cmp al, NULL					; check if is NULL terminated
	jne _errTHspec

; CHECK Argv[2] -- Thread Count Value
	mov rbx, qword[r12+16]			; rbx = Arguement[2]

	mov al, byte[rbx]				; al = the first character of Arguement[2]
	sub al, 0x30					; convert to integer

	; VERIFY RANGE
	cmp al, 1
	jb 	_errTHValue

	cmp al, 4
	ja 	_errTHValue

	mov dword[r13], eax				; save the thread count

; CHECK Argv[3] -- Limit Value Specifier
	mov rbx, qword[r12+24]			; rbx = Arguement[3]

	mov al, byte[rbx]				; al = the first character of Arguement[3]
	cmp al, "-"						; check if the first character is '-'
	jne _errLSpec

	mov al, byte[rbx+1]				; al = the second character of Arguement[3]
	cmp al, "l"						; check if the second character is 'l'
	jne _errLSpec

	mov al, byte[rbx+2]				; al = the third character of Arguement[3]
	cmp al, "m"						; check if the third character is 'm'
	jne _errLSpec

	mov al, byte[rbx+3]				; al = the fourth character of Arguement[3]
	cmp al, NULL					; check if is NULL terminated
	jne _errLSpec

; CHECK Argv[4] -- Limit Value
	mov rdi, qword[r12+32]			; rdi = Arguement[4]
	mov rsi, r14					; rsi = limit value, address
	call abin2int

	cmp rax, FALSE
	jb _errLValue

	cmp qword[r14], LIMITMIN
	jb _errLValue

	cmp qword[r14], LIMITMAX
	ja _errLValue

; --- SUCCESFUL INPUTS   --------------------------------------------------
Yes:
	mov rax, TRUE
	jmp Donezo

; --- ALL ERROR MESSAGES --------------------------------------------------

_errUsage:
	mov rdi, errUsage
	jmp print

_errOptions:
	mov rdi, errOptions
	jmp print

_errTHspec:
	mov rdi, errTHspec
	jmp print

_errTHValue:
	mov rdi, errTHvalue
	jmp print

_errLSpec:
	mov rdi, errLSpec
	jmp print

_errLValue:
	mov rdi, errLValue
	jmp print

print:
	call printString
	mov rax, FALSE

Donezo:

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
ret


; ******************************************************************
;  Thread function, numberTypeCounter()
;	Detemrine the type (abundent, deficient, perfect) of
;	numbers between 1 and limitValue (gloabally available)

common	limitValue		1:8				; limit value
common	perfectCount	1:8
common	abundantCount	1:8
common	deficientCount	1:8

; ----- ; TODO  numberTypeCounter()
;*  Arguments:
;*	N/A (global variable accessed)
;*  Returns:
;*	N/A (global variable accessed)

global numberTypeCounter
numberTypeCounter:

	push rbx
	push r12
	push r13
	push r14
	push r15

	mov rdi, msgThread1
	call printString

	mov r15, qword[limitValue]			; r15 = limit value

loopTrue:								; loop to sum divisors
	call spinLock						; get #N to work on 
	mov rbx, qword[currentIndex]		; rbx = limit value
	inc qword[currentIndex]				; increment cur	rentIndex
	call spinUnlock						; release #N

	cmp rbx, r15						; if N > limit  --> exit function
	ja ended

	mov r9, 2							; r9 = counter = start from 2
	mov r10, 1							; r10 = sum of divisor
										; we don t tale 1, and it own N
forLoop:
	mov rax, r9							;* if (index^2 > N)
	mul rax								;*		break
	cmp rax, rbx						;* Because its math
	ja forLoopEnd

	mov rax, rbx						;* rax = N (current number)
	mov rdx, 0
	div r9								;* rax = N / counter, this will be repeated

	cmp edx, 0							;* if (n % i == 0)
	jne sumDone							;* if so, add counter to sum

	add r10, r9							;* sum = sum + i;
	cmp r9, rax
	je sumDone

	add r10d, eax						; add itslef, since all N divisble by 1

sumDone:
	inc r9								;* counter++
	jmp forLoop					

forLoopEnd:

	cmp r10d, ebx						; check if sum of divisors == N
	je perfectNum						; if so, increment perfectCount

	cmp r10d, ebx						; check if sum of divisors > N
	jg abundantNum						; if so, increment abundantCount

	cmp r10d, ebx						; check if sum of divisors < N
	jl deficientNum						; if so, increment deficientCount

	jmp loopTrue

perfectNum:
	lock 	inc qword[perfectCount]		; increment perfectCount
	jmp loopTrue

abundantNum:
	lock 	inc	qword[abundantCount]	; increment abundantCount
	jmp loopTrue

deficientNum:
	lock 	inc	qword[deficientCount]	; increment deficientCount
	jmp loopTrue

ended:

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
ret


; ******************************************************************
;*  Mutex lock
;*	checks lock (shared gloabl variable)
;*		if unlocked, sets lock
;*		if locked, lops to recheck until lock is free

global	spinLock
spinLock:
	mov	rax, 1			; Set the EAX register to 1.

lock	xchg	rax, qword [myLock]	; Atomically swap the RAX register with
									; the lock variable.
									; This will always store 1 to the lock, leaving
									; the previous value in the RAX register.

	test	rax, rax	       	 	; Test RAX with itself. Among other things, this will
									; set the processor's Zero Flag if RAX is 0.
									; If RAX is 0, then the lock was unlocked and
									; we just locked it.
									; Otherwise, RAX is 1 and we didn't acquire the lock.

	jnz	spinLock					; Jump back to the MOV instruction if the Zero Flag is
									; not set; the lock was previously locked, and so
									; we need to spin until it becomes unlocked.
	ret

; ******************************************************************
;  Mutex unlock
;	unlock the lock (shared global variable)

global	spinUnlock
spinUnlock:
	mov	rax, 0					; Set the RAX register to 0.

	xchg	rax, qword [myLock]	; Atomically swap the RAX register with
								;  the lock variable.
	ret

; ******************************************************************
;  Generic procedure to display a string to the screen.
;  String must be NULL terminated.
;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

;*  Arguments:
;*	1) address, string
;*  Returns:
;*	nothing

global	printString
printString:

; -----
; Count characters to write.

	mov	rdx, 0
strCountLoop:
	cmp	byte [rdi+rdx], NULL
	je	strCountLoopDone
	inc	rdx
	jmp	strCountLoop
strCountLoopDone:
	cmp	rdx, 0
	je	printStringDone

; -----
;  Call OS to output string.

	mov	rax, SYS_write				; system code for write()
	mov	rsi, rdi					; address of characters to write
	mov	rdi, STDOUT					; file descriptor for standard in
									; rdx=count to write, set above
	syscall							; system call

; -----
;  String printed, return to calling routine.

printStringDone:
	ret

; ******************************************************************
;  Function: Check and convert ASCII/binary to integer

;  Example HLL Call:
; TODO	stat = abin2int(qStr, &num); 
; TODO	bool = abin2int(qStr, &num); 

;  Returns 
;*	1. rsi || integer value (via passed address)
;*	2. rax || bool, TRUE if valid conversion, FALSE for error

global	abin2int
abin2int:
;	YOUR CODE GOES HERE
	push r12					
	push r13					
	push r14					

	mov r12, rdi
	mov r13, 0
	mov eax, 0

nextChar:
	mov rcx, 0
	mov cl, byte[r12+r13]

	cmp cl, NULL
	je	nextCharDone

	sub cl, 0x30
	cmp cl, 1
	ja binaryError

	mov r14d, 2
	mul r14d
	add rax, rcx

	inc r13
	jmp nextChar

nextCharDone:
	cmp r13, 0
	je binaryError

	mov qword[rsi], rax
	mov rax, TRUE
	jmp done

binaryError:
	mov rax, FALSE

done:
	pop r14
	pop r13
	pop r12
ret




; ******************************************************************

