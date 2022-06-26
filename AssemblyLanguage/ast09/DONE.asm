; *****************************************************************
;  Name: Thien Nguyen
;  NSHE ID: 2001904928
;  Section: 1004
;  Assignment: 9
;  Description: Write the assembly language functions described
;	below.  You will be provided a C++ main
;	program that calls the following functions.


; --------------------------------------------------------------------
;  Write the following assembly language functions.

;  Value returning function readBinaryNumber(), reads a binary number
;  in ASCII format from the user and convert to an integer.
;  Returns a status code.

;  The function, bubbleSort(), sorts the numbers into ascending
;  order (small to large).  Uses the bubble sort algorithm from
;  assignment #7 (modified to sort in ascending order).

;  The function, simpleStats(), finds the minimum, median, and maximum
;  for a list of numbers.

;  The function, iAvergae(), computes the integer average for a
;  list of numbers.

;  The function, lstStats(), to compute the variance and
;	standard deviation for a list of numbers.


; ************************************************************************************
; -----
;  Define standard constants

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; Successful operation
NOSUCCESS	equ	1

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

LF			equ	10
NULL		equ	0
ESC			equ	27

; -----
;  Program specific constants.

MAXNUM		equ	10000000
BUFFSIZE	equ	50			; 49 chars plus NULL

; -----
;  NO STATIC LOCAL VARIABLES
;  LOCALS MUST BE DEFINED ON THE STACK!!


; ********************************************************************************

section	.text

; --------------------------------------------------------------------------------
;  Simple function to read a ternary number in ASCII format
;  from the user and call rotuine to convert to an integer.
;  Returns a status code (SUCCESS or NOSUCCESS).

; -----
;  HLL Call
;	status = readBinaryNumber(&number);

; -----
;  Arguments passed:
;	1) integer, address - 8

; -----
;  Returns TODO:
;	1) integer - value (via passed address)
;	2) status code - value (via EAX)

;	1. input buffer (50)
;	2. char 		(1)
;	3. Error msg 	(19)
;	4. ddTwo 		(4)
;	-------------------
;					(74)

global	readBinaryNumber
readBinaryNumber:
	push rbp							; save stack pointer
	mov  rbp, rsp						; prologue
	sub  rsp, 74
	push rbx
	push r12
	push r13
	push r14
	push r15

; -----
;  Set error message -> "Error, re-enter: ", LF, NULL
;  Note, can use printString() function to display.
	lea rbx, byte[rbp-70]

	mov	dword [rbx], "Erro"
	mov	dword [rbx+4], "r, r"
	mov	dword [rbx+8], "e-en"
	mov	dword [rbx+12], "ter:"
	mov	byte  [rbx+16], " "
	mov	byte  [rbx+17], NULL

	; ----- SET UP
	;	YOUR CODE GOES HERE

	mov dword[rbp-74], 2
	mov r12, rdi						; r12 = address of the integer passed in
										; we also make a copy of it, so we can freely use rdi

Rset:
	; mov rbx, rbp						
	; sub rbx, 50						; rbx = address of buffer
	lea rbx, byte[rbp-50]				
	mov r13, 0							; r13 = i = 0 = number of chars read
	mov r14, 0

; ----- getChar() (until buffer is full)
getChar:
	mov rax, SYS_read					; read character from user
	mov rdi, STDIN						
	lea rsi, byte[rbp-51]				; rsi = address of char
	mov rdx, 1							; rdx = number of chars TO read
	syscall

	mov al, byte[rbp-51]				; if char = LF

	cmp al, LF							; why take it? run
	je inputDone

	cmp al, 0x20						; if char is a space, no no
	je getChar

	inc r14
	cmp r13, BUFFSIZE - 1				; if we have read enough BUFFSIZE chars, if more, ignore it
	ja buffDone							; will keep getting until inputDone
	mov byte[rbx+r13], al				; otherwise, add char to buffer
	inc r13								; i++, 

buffDone:
	jmp getChar							; until there is no more, we shall rise !

; ----- inputDone
inputDone:

	; LF, user want to exit
	cmp r13, 0
	je exitError

	mov byte[rbx+r13], NULL 			; add NULL terminated to buffer

	cmp r14, BUFFSIZE - 1				; if user input is longer than BUFFSIZE
	jae erorrMsg

	cmp r13, BUFFSIZE					; 
	jbe checkInput						; we will print the error message, 
										; but not, then check the validity of it

erorrMsg:
	lea rdi, byte[rbp-70]				; rdi = address of error msg
	call printString					; rdi is set for printString()
	mov rax, NOSUCCESS					; set status code to NOSUCCESS
	jmp Rset

exitError:
	; ----- print error message
	mov rax, NOSUCCESS
	jmp readFuncdone					; goto done; EXIT ERROR

; ----- Loop to convert + check input
checkInput:

	lea rdi, byte[rbp-50]				; rsi = address of buffer
	lea rsi, byte[rbp+16]				; rsi = 0
	call aBin2int

	; USELESS 
	cmp dword[rdi], NULL
	je readFuncdone	

	; if FAILED CONVERSION
	cmp rax, NOSUCCESS					; if conversion failed
	je erorrMsg							; print error message and exit

	; VERIFY RANGE
	cmp dword[rsi], MAXNUM				; if number is too big
	jae erorrMsg						; print error message and exit

	; if SUCCESSFUL CONVERSION
	mov rdi, r12
	mov r12d, dword[rsi] 
	mov dword[rdi], r12d				; rdi = address of buffer
	mov rax, SUCCESS					; set status code to SUCCESS

readFuncdone:

	pop r15
	pop r14
	pop r13								; epilogue
	pop r12
	pop rbx
	mov rsp, rbp
	pop rbp
	ret

; *******************************************************************************
;  Simple function to convert binary string to integer.
;	Reads string and converts to intger

; -----
;  HLL Call
;	bool = aBin2int(&str, &int);

; -----
;  Arguments passed:
;	1) string, address
;	2) integer, address

; -----
;  Returns TODO:
;	1) integer value (via passed address)
;	2) bool, TRUE if valid conversion, FALSE for error

global	aBin2int
aBin2int:
;	YOUR CODE GOES HERE
	push r12					; save r12 --> 8
	push r13					; save r13 --> 9
	push r14					; save r14 --> 11

	; mov qword[r12], rdi
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
	mov rax, SUCCESS
	jmp done

binaryError:
	mov rax, NOSUCCESS

done:
	pop r14
	pop r13
	pop r12
ret



; *******************************************************************************
;  Function to perform bubble sort.
;	Note, sorts in asending order

; -----
;  HLL Call:
;	bubbleSort(list, len);

;  Arguments Passed:
;	1) list, addr
;	2) length, value

;  Returns: TODO:
;	sorted list (list passed by reference)

global bubbleSort
bubbleSort:
	push rbx
	push r12
	push r13

	mov r10, rdi					; r10 = list
	mov rcx, 0
	mov ecx, esi					; ecx = length = i
	mov r11, 0						;

for1Continue:

	dec rcx							; ecx = length - 1
	cmp rcx, 0						; if length = 0, exit for1Continue
	jl for1Break

	; Before inner loop
	mov byte[r13], FALSE			; r13 = FALSE
	mov r9, 0						; r9 = j = 0	

for2Continue:
	; Condition of inner loop to break
	mov rbx, rcx					; rbx = i
	dec rbx							; rbx = i - 1
	cmp r9, rbx		        	    ; if j = length - 1, exit for2Continue
	jg for2Break
	mov r11, r9						; r11 = j
	inc r9

	; swap statement
	mov r8d, dword[r10+r11*4]		; r8d = list[j]
	mov r12d, dword[r10+r9*4]		; list[j] = list[j+1]

	cmp r8d, r12d                   ; if list[j] > list[j+1], swap
	jl for2Continue

	; Swap excecution
	mov dword[r10+r9*4], r8d		; list[j+1] = list[j]
	mov dword[r10+r11*4], r12d		; list[j] = list[j+1]

	mov byte[r13], TRUE				; r13 = TRUE
	jmp for2Continue

for2Break:
	; After inner loop
	cmp byte[r13], FALSE			; if r13 = FALSE, exit for1Continue
	je for1Break					; if not, we continue the outer loop

	jmp for1Continue				; Loop till i == 0, the outer loop done
for1Break:

	pop r13
	pop r12
	pop rbx
ret


; *******************************************************************************
;  Function to compute and return simple stats for list:
;	minimum, maximum, median

;   Note, assumes the list is ALREADY sorted.

;   Note, for an odd number of items, the median value is defined as
;   the middle value.  For an even number of values, it is the integer
;   average of the two middle values.
;   The median must be determined after the list is sorted.

; -----
;  HLL Call:
;	simpleStats(list, len, &min, &max, &med);

; -----
;  Arguments Passed:
;	1) list, addr
;	2) length, value
;	3) minimum, addr
;	5) median, addr
;	4) maximum, addr

;  Returns TODO:
;	results via passed addresses


global simpleStats
simpleStats:
	push rbp
	push rbx

; MIN, rdx
	mov eax, dword[rdi]					; eax = list
	mov dword[rdx], eax					; max = list, the first item after sorted

; MAX, rcx
	mov r10, 0							; r10 = 0, refresh value
	mov r10d, esi						; r10 = len
	dec r10								; r10 = len - 1, the last value index
	mov eax, dword[rdi + r10*4]			; eax = list[len - 1]
	mov dword[rcx], eax					; min = eax

; MEDIAN, r8
	mov eax, esi						; eax = len
	mov edx, 0
	mov r10d, 2
	div r10d							; r10 = len / 2, the middle value index
	mov r11d, eax

	mov eax, dword[rdi + r11*4]			; eax = list[len / 2]
	mov r10d, 1
	and r10d, esi						; Check even / odd
	cmp r10d, 1
	je isOdd

	dec r11								; r11 = (len / 2 ) - 1 , 
	add eax, dword[rdi + r11*4]			; list[len / 2] + list[len / 2] - 1
	mov edx, 0
	mov r10d, 2
	div r10d							; r10 = (list[len / 2] + list[len - 1 / 2]) / 2

isOdd:
	mov dword[r8], eax					; eax has the answers, we passed it in r8

	pop rbx
	pop rbp
ret




; *******************************************************************************
;  Function to compute and return integer average for a list of numbers.

; -----
;  HLL Call:
;	ave = iAverage(list, len);

; -----
;  Arguments Passed:
;	1) list, addr - 8
;	2) length, value - 12

;  Returns TODO:
;	integer average - value (in eax)

global iAverage
iAverage:

	mov rcx, 0
	mov ecx, esi 						; ecx = len
	mov r9, 0							; r9 = i
	mov eax, 0							; r10 = sum

sumLoop:
	add eax, dword[rdi+r9*4]			; sum = sum + list[i]
	inc r9
	loop sumLoop						; i++, sumLoop, but ecx will --> 0
	cdq
	idiv esi							; eax = sum / len, since loop handle ecx --> 0

ret

; *******************************************************************************
;  Function to compute and return the variance of a list.
;	Note, uses iaverage to find the average for the calculations.

; -----
;  HLL Call:
;	var = lstStats(list, len, &var, &std)

; ----
;  Arguments Passed:
;	1) list, addr
;	2) length, value
;	3) variance, addr
;	4) standard deviation, addr

;  Returns: TODO:
;	n/a

global lstStats
lstStats:
	push rbp
	mov rbp, rsp
	sub rsp, 8
	push rbx
	push r12
	push r13
	push r14
	push r15

	; MOV THE ADDRESS OF PRESERVED REGISTERS
	; INTO THE DEST OPERANDS, RESULTING MAKING A COPY OF IT
	; LATER ON DEREFERENCING IT ALLOW US TO PARSE ACTUAL IN

	mov rbx, rdi					; rbx = list address
	movzx r12, si					; r12 = len address
	mov r13, rdx					; r13 = variance address
	mov r14, rcx					; r14 = standard deviation address
	lea r15, qword[rbp-8]			; r15 = temp

	call iAverage					; rdi, and esi already set
	mov r11d, eax					; r11 = average, since function return value in eax

	mov qword[r15], 0				; r15 = 0, quad-word
	mov rcx, r12					; rcx = len, counter to loop the sumLoop
	mov r10, 0						; r10 = index in our array

sumLoop1:
	mov eax, dword[rdi+r10*4]		; eax = list[i]
	sub eax, r11d					; eax = list[i] - average
	
	imul eax						; eax = (list[i] - average) ^ 2
	add dword[r15], eax				; r15 = r15 + (list[i] - average) ^ 2
	adc dword[r15+4], edx			; add the MSQ, since we are using 64-bit integers

	inc r10
	loop sumLoop1					; counter--, sumLoop1

	mov rdx, qword[r15]				; rdx = r15 = tempVar
	mov qword[r13], rdx				; secure the variance

	mov rdi, qword[r15]				; rdi = r15 = variance
	mov rsi, r12					; rsi = len
	call stdDeviation				; rdi, rsi, already set to call stdDeviation
	movsd qword[r14], xmm0			; r14 = stdDeviation, quad-word

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	mov rsp, rbp
	pop rbp
ret


; ********************************************************************
;  Function to compute standard deviation as a real value.
;  Uses floating point instructions.
;  Returns result in xmm0

;  Algorithm:
;	std = sqrt(var/n)

; -----
;  HLL Call:
;	stdDev(var, len)

;  Arguments:
;	1) variance, value
;	2) length, value

;  Returns: 
;	standard deviation in xmm0

global	stdDeviation
stdDeviation:

	cvtsi2sd	xmm0, rdi
	cvtsi2sd	xmm1, rsi
	divsd		xmm0, xmm1
	sqrtsd		xmm0, xmm0

	ret

; ********************************************************************
;  Generic function to display a string to the screen.
;  String must be NULL terminated.

;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

; -----
;  HLL Call:
;	printString(stringAddr);

;  Arguments:
;	1) address, string
;  Returns: 
;	nothing

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

