; *****************************************************************
;  Name: Thien Nguyen
;  NSHE ID: 2001904928
;  Section: 1004
;  Assignment: 11
;  Description: Write an assembly language program that will read a data source file,
;  count the leading digits, and output a formatted text-based graph of the results.
;  The graph will be written to the file and, optionally displayed to the screen.
;  The program should read the screen display option (true or false) and both file 
;  names (input and output) from the command line.  An example command line is:

; -----
;  * Function - getArguments()
;	Read, parse, and check command line arguments.

;  * Function - countDigits()
;	Check the leading digit for each number and count 
;	each 0, 1, 2, etc...
;	All file buffering handled within this procedure.

;  * Function - int2aBin()
;	Convert an integer to a ASCII/binary string, NULL terminated.

;  * Function - writeString()
;	Create graph as per required format and ouput.


; ****************************************************************************

section	.data

; -----
;  Define standard constants.

LF			equ	10			; line feed
NULL		equ	0			; end of string
SPACE		equ	0x20		; space

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

O_CREAT		equ	0x40
O_TRUNC		equ	0x200
O_APPEND	equ	0x400

O_RDONLY	equ	000000q			; file permission - read only
O_WRONLY	equ	000001q			; file permission - write only
O_RDWR		equ	000002q			; file permission - read and write

S_IRUSR		equ	00400q
S_IWUSR		equ	00200q
S_IXUSR		equ	00100q
	
; -----
;  Variables for getArguments()

usageMsg	db	"Usage: ./benford -i <inputFileName> "
			db	"-o <outputFileName> [-d]", LF, NULL

errMany		db	"Error, too many characters on the "
			db	"command line.", LF, NULL

errFew		db	"Error, too few characters on the "
			db	"command line.", LF, NULL

errDSpec	db	"Error, invalid output display specifier."
			db	LF, NULL

errISpec	db	"Error, invalid input file specifier."
			db	LF, NULL

errOSpec	db	"Error, invalid output file specifier."
			db	LF, NULL

errOpenIn	db	"Error, can not open input file."
			db	LF, NULL

errOpenOut	db	"Error, can not open output file."
			db	LF, NULL

; ----- TODO:
;  Variables for countDigits()

BUFFSIZE		equ	500000

SKIP_LINES		equ	5				; skip first 5 lines
SKIP_CHARS		equ	6

nextCharIsFirst	db	TRUE
skipLineCount	dd	0				; count of lines to skip
skipCharCount	dd	0				; count of chars to skip
gotDigit		db	FALSE

bfMax			dq	BUFFSIZE
curr			dq	BUFFSIZE

wasEOF			db	FALSE

errFileRead		db	"Error reading input file."
				db	"Program terminated."
				db	LF, NULL

firstThing		db  0

; -----
;  Variables for writeString()

errFileWrite	db	"Error writting output file."
				db	LF, NULL

; -------------------------------------------------------

section	.bss

buff		resb	BUFFSIZE+1

; ****************************************************************************

section	.text

; ======================================================================
; Read, parse, and check command line paraemetrs.

; -----
;  Assignment #11 requires options for:
;	input file name
;	output file name

;  Assignment #11 allows an optional argument for:
;	display results to screen (T/F)

;  For Example:
;	./benford -i <inputFileName> -o <outputFileName> [-d]

; -----
;  Example high-level language call:

; TODO status = getArguments(ARGC, ARGV, rdFileDesc, wrFileDesc, displayToScreen)

;*  -----
;*  Arguments passed: 
;*	1. rdi || argc
;*	2. rsi || argv
;*	3. rdx || address of file descriptor, input file
;*	4. rcx || address of file descriptor, output file
;*	5. r8  || address of boolean for display to screen

global getArguments
getArguments:

	push rbx						; save registers
	push r12
	push r13
	push r14
	push r15

	mov r12, rsi					; r12 = argv
	mov r13, rdx					; r13 = input file descriptor
	mov r14, rcx					; r14 = output file descriptor
	mov r15, rdi					

; CHECK ARGC
	cmp rdi, 1						; if argc = 1, jmp errorNoArgs
	je _usageMsg

	cmp rdi, 5						; if argc < 5, jmp errorTwoFew
	jl _errFew

	cmp rdi, 6
	jg _errMany						; if argc > 6, jmp errorTwoMany

; CHECK ARGV[1] != '-i', NULL
	mov rbx, qword[r12+8]			; rbx = address of argv[1]

	mov al, byte[rbx]				; al = first character of argv[1]
	cmp al, "-"						; if first character is "-"
	jne _errISpec					; if not, jmp errorISpec

	mov al, byte[rbx+1]				; al = second character of argv[1]	
	cmp al, "i"						; if second character is "i"
	jne _errISpec					; if not, jmp errorISpec

	mov al, byte[rbx+2]				; al = third character of argv[1]
	cmp al, NULL					; if third character is NULL, jmp errorISpec
	jne _errISpec					; if not, jmp errorISpec

; CHECK ARGV[2] != open
	mov rax, SYS_open
	mov rdi, qword[r12+16]			; rdi = address of arvg[2]
	mov rsi, O_RDONLY				; rsi = permission read only
	syscall							; system services verify the permisson
	cmp rax, 0						; fail mean rax would be < 0
	jl _errOpenIn
	mov qword[r13], rax				; SUCCESSFUL

; CHECK ARGV[3] != '-o', NULL
	mov rbx, qword[r12+24]			; rbx = address of argv[3]

	mov al, byte[rbx]				; al = first character of argv[3]
	cmp al, "-"						; if first character is "-"
	jne _errOSpec					; if not, jmp errOSpec

	mov al, byte[rbx+1]				; al = second character of argv[3]	
	cmp al, "o"						; if second character is "i"
	jne _errOSpec					; if not, jmp errOSpec

	mov al, byte[rbx+2]				; al = third character of argv[3]
	cmp al, NULL					; if third character is NULL, jmp errOSpec
	jne _errOSpec					; if not, jmp errOSpec

; CHECK ARGV[4] != open
	mov rax, SYS_creat
	mov rdi, qword[r12+32]			; rdi = address of arvg[2]
	mov rsi, S_IRUSR|S_IWUSR		; rsi = permission read / write
	syscall							; system services verify the permisson
	cmp rax, 0						; fail mean rax would be < 0
	jl _errOpenOut
	mov qword[r14], rax				; SUCCESSFUL

; CHECK ARGC = 6
	cmp r15, 6						; if argc > 5
	je  check6
	mov byte[r8], FALSE
	jmp Yes

check6:
	mov rbx, qword[r12+40]			; rbx = address of argv[5]

	mov al, byte[rbx]
	cmp al, "-"						; if first character is "-"
	jne _errDSpec					; if not, jmp errorDSpec

	mov al, byte[rbx+1]				; al = second character of argv[3]	
	cmp al, "d"						; if second character is "d"
	jne _errDSpec					; if not, jmp errOSpec

	mov al, byte[rbx+2]				; al = third character of argv[3]
	cmp al, NULL					; if third character is NULL, jmp errOSpec
	jne _errDSpec					; if not, jmp errOSpec
	mov byte[r8], TRUE
	
; --- SUCCESFUL INPUTS   --------------------------------------------------
Yes:
	mov rax, TRUE
	jmp exitFunction

; --- ALL ERROR MESSAGES --------------------------------------------------

_usageMsg:
	mov rdi, usageMsg
	jmp print

_errMany:
	mov rdi, errMany
	jmp print

_errFew:
	mov rdi, errFew
	jmp print

_errDSpec:
	mov rdi, errDSpec
	jmp print

_errISpec:
	mov rdi, errISpec
	jmp print

_errOSpec:
	mov rdi, errOSpec
	jmp print

_errOpenIn:
	mov rdi, errOpenIn
	jmp print

_errOpenOut:
	mov rdi, errOpenOut
	jmp print

print:
	call printString
	mov rax, FALSE

exitFunction:

	pop r15							; restore registers
	pop r14
	pop r13
	pop r12
	pop rbx
ret



; ======================================================================
;  Simple function to convert an integer to a NULL terminated
;	ASCII/binary string.  Expects a 33 character string
;	(32 characters and NULL).

; -----
;  HLL Call

;	TODO int2aBin(int, &str);

;*  -----
;*  Arguments passed:
;*	1. rdi || integer value
;*	2. rsi || string, address

;*  -----
;*  Returns
;*	1. rsi || string (via passed address)

global int2aBin
int2aBin:

	push rbx						; save altered registers

	mov eax, edi					; copy integer value to eax
	mov rcx, 0
	mov ebx, 2						; set ebx to 2, Binary system

divideLoop:
	mov edx, 0						; unsigned division
	div ebx

	push rdx 						; push the remainder
	inc rcx							; increment the count stringlen
	
	cmp rcx, 32				; control flow
	jne divideLoop

	mov rbx, rsi					; set rbx to starting address of string
	mov r8, 0						; idx = 0

popLoop:
	pop rax							; pop Binary number
	add al, 0x30					; convert to ASCII string

	mov byte[rbx+r8], al			; store the ASCII string in string via address
	inc r8
	loop popLoop					; loop as the rcx goes back to 0

	mov byte[rbx+r8], NULL			; Null termniated

	pop rbx
	ret


;*  ======================================================================
;*  Count leading digits....
;*	Check the leading digit for each number and count 
;*	each 0, 1, 2, etc...
;*	The counts (0-9) are stored in an array.

; -----
;  High level language call:

;	TODO countDigits (rdFileDesc, digitCounts)

; ----- 
;  Arguments passed:
;	rdi || value for input file descriptor
;	rsi || address for digits array

global countDigits
countDigits:

	push rbx						; save registers
	push r12
	push r13
	push r14
	push r15

; --- START --------------------------------------------------------------
	mov r12, rdi					; r12 = input file descriptor
	mov r13, rsi					; r13 = address of digit counts array count[int]

	mov r9d, dword[skipLineCount]	; r9 = header Line Count = 0
	mov r10d, dword[skipCharCount]	; r10 = chars count = 0

	mov byte[nextCharIsFirst], TRUE	; r8 = header = true
	
	mov r14, qword[curr]			; r14 = currentIdx
	mov r15, qword[bfMax]			; r15 = BUFFSIZE

; --- IF -----------------------------------------------------------------
getNextChar:
	cmp r14, qword[bfMax]			;* if (currIdx >= buffMax)
	jge	readFile					

readFileDone:
	xor rbx, rbx
	mov bl, byte[buff+r14]			; char = buffer[currIdx] 
	inc r14							; currIdx++

	cmp byte[nextCharIsFirst], TRUE	;* if (header)
	je headerExecute				

skipCharsAgain:
	cmp r10d, SKIP_CHARS			;* if (ChrCnt < SKIP_CHARS)
	jb skipChars

gotDigitDone:						
	cmp byte[gotDigit], FALSE		;* if (!gotDigit)
	je gotDigitExecute	

; --- SUCCESSFUL ---------------------------------------------------------

	jmp endCountDigits

; --- END IF -------------------------------------------------------------
;* if (currIdx >= buffMax) body
readFile:
	cmp byte[wasEOF], TRUE			; EOF, what the read
	je ended

	mov rax, SYS_read
	mov rdi, r12					; rdi = input file = file descriptor
	mov rsi, buff					; rsi = buff array
	mov rdx, BUFFSIZE
	syscall

	cmp rax, 0						; check read errros
	jb errorOnRead

	cmp rax, BUFFSIZE				;* if (actualRd < requestRd)
	jb fixReadFile
	jmp endReadFile

fixReadFile:
	mov byte[wasEOF], TRUE			; set EOF flag
	mov qword[bfMax], rax			; buffMax = actualRd

endReadFile:
	mov r14, 0						; currIdx = 0
	jmp readFileDone

;* if (header) body
headerExecute:
	cmp bl, LF						; if char is LF
	je header1						
	jmp header1Done					; if not, ignore it

header1:	
	inc r9d							; increment headerLineCount

header1Done:
	cmp r9d, SKIP_LINES				; cmp headerLine to SKIP_LINES
	je header2						; if equal, done
	jmp header2Done					; if not, ignore it

header2:
	mov byte[nextCharIsFirst], FALSE; header = false	

header2Done:
	jmp getNextChar

; * if (ChrCnt < SKIP_CHARS) body
skipChars:
	inc r10d						; increment chars count

	cmp bl, LF						; char is LF --> BAD DATA, NO NO
	je ended						; error!, 

skipCharsDone:
	jmp getNextChar					; if not, continue, nothing happen

;* if (!gotDigit)
gotDigitExecute:
	cmp bl, LF
	je gotDigit3

	cmp bl, SPACE 					;* if (char == SPACE)
	je gotDigit1					; if space, inspect it
	jmp gotDigit2					; if not, ignore it

gotDigit1:
	cmp bl, LF						; inpsec if its LF
	je ended						; if it is, error
	jmp getNextChar					; if not, nothing happen, continue

gotDigit2:
	cmp byte[firstThing], 1
	je notDigit						; if not, nothing happen, continue

	cmp bl, "0" 					; *if (char digit ("0" ... "9"))
	jb notDigit

	cmp bl, "9" 
	ja notDigit

	sub bl, "0"						; convert to int
	inc dword[r13+rbx*4]			; count[int]++
	inc byte[firstThing]
	jmp getNextChar	

notDigit:
	cmp bl, LF						;* if (char == LF)
	je gotDigit3
	jmp getNextChar

gotDigit3:
	mov byte[gotDigit], FALSE		; found = false
	mov r10d, 0
	mov byte[firstThing], 0
	jmp getNextChar

; --- END  ---------------------------------------------------------------

ended:
	jmp endCountDigits

errorOnRead:
	mov rdi, errFileRead
	call printString

endCountDigits:

	pop r15							; restore registers
	pop r14
	pop r13
	pop r12
	pop rbx

ret

; ======================================================================
;  Generic function to write a string to an already opened file.
;  Similar to printString(), but must handle possible file write error.
;  String must be NULL terminated.

;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters to file

; TODO writeString() 

;*  Arguments:
;*	1. rdi || file descriptor, value,
;*	2. rsi || address, string, buffer
;*  Returns:
;*	nothing

global writeString
writeString:
; -----


	xor	rdx, rdx					; Count characters to write
w_strCountLoop:
	cmp	byte [rsi+rdx], NULL		; if 1, jmp out			
	je	w_strCountLoopDone			; if not, jmp to next char
	inc	rdx							; increment count
	jmp	w_strCountLoop				
w_strCountLoopDone:	
	cmp	rdx, 0						; if count is 0, nothing to write
	je	w_exitWriteString

; -----
;  Call OS to output string.
	mov	rax, SYS_write				; system code for write()
	syscall							; system call
	
	cmp	rax, 0						; if error, no no
	jb	_errFileWrite				

	jmp w_exitWriteString

; -----
;  String printed, return to calling routine.

_errFileWrite:
	mov rdi, errFileWrite
	call printString

w_exitWriteString:	

	ret





; ======================================================================
;  Generic function to display a string to the screen.
;  String must be NULL terminated.

;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

; -----
;  HLL Call:
;	printString(stringAddr);

;*  Arguments:
;*	1. address, string
;*  Returns:
;*	nothing

global	printString
printString:

; -----
;  Count characters to write.

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

	mov	rax, SYS_write			; system code for write()
	mov	rsi, rdi				; address of char to write
	mov	rdi, STDOUT				; file descriptor for std in
								; rdx=count to write, set above
	syscall						; system call

; -----
;  String printed, return to calling routine.

printStringDone:
	ret

; ******************************************************************

