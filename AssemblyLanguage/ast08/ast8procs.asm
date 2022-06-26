; *****************************************************************
;  Name: Thien Nguyen
;  NSHE ID: 2001904928
;  Section: 1004
;  Assignment: 8
;  Description:	Write four simple assembly language functions to
;  provide some statistical operations as described below.
;  You will be provided a main function that calls the
;  following functions (for each set of data).

; --------------------------------------------------------------------
;  Write assembly language functions.

;  The function, bubbleSort(), sorts the numbers into descending
;  order (large to small).  Uses the bubble sort algorithm from
;  assignment #7 (modified to sort in descending order).

;  The function, simpleStats(), finds the minimum, median, and maximum
;  count of even values, and count of values evenly divisible by 5
;  for a list of numbers.

;  The function, iAvergae(), computes the integer average for a
;  list of numbers.

;  The function, lstStats(), to compute the variance and
;	standard deviation for a list of numbers.

;  Note, all data is signed!

; ********************************************************************************

section	.data

; -----
;  Define standard constants

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation

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
NULL		equ	0
ESC		equ	27

; -----
;  Local variables for bubbleSort() function (if any)

swapped		db	FALSE


; -----
;  Local variables for simpleStats() function (if any)


; -----
;  Local variables for iAverage() function (if any)



; -----
;  Local variables for lstStats() function (if any)

tmpVar		dq	0


; ********************************************************************************

section	.text

; ********************************************************************
;  Function to implement bubble sort for an integer array.
;	Note, sorts in desending order

; -----
;  HLL Call:
;	bubbleSort(list, len)

;  Arguments Passed:
;	1. list, addr
;	2. length, value

;  Returns:
;	sorted list (list passed by reference)

global bubbleSort

bubbleSort:
	push rbx
	push r12

	mov r10, rdi					; r10 = list
	mov rcx, 0
	mov ecx, esi					; ecx = length = i
	mov r11, 0						;

for1Continue:

	dec rcx							; ecx = length - 1
	cmp rcx, 0						; if length = 0, exit for1Continue
	jl for1Break

	; Before inner loop
	mov byte[swapped], FALSE		; Swapped = FALSE
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
	jg for2Continue

	; Swap excecution
	mov dword[r10+r9*4], r8d		; list[j+1] = list[j]
	mov dword[r10+r11*4], r12d		; list[j] = list[j+1]

	mov byte[swapped], TRUE			; Swapped = TRUE
	jmp for2Continue

for2Break:
	; After inner loop
	cmp byte[swapped], FALSE		; if Swapped = FALSE, exit for1Continue
	je for1Break					; if not, we continue the outer loop

	jmp for1Continue				; Loop till i == 0, the outer loop done
for1Break:

	pop r12
	pop rbx
ret

; ********************************************************************
;  Find simple statistical information of an integer array:
;	minimum, median, maximum, count of even values, and
;	count of values evenly divisible by 5

;  Note, for an odd number of items, the median value is defined as
;  the middle value.  For an even number of values, it is the integer
;  average of the two middle values.

;  Note, you may assume the list is already sorted.

; -----
;  HLL Call:
;	simpleStats(list, len, min, max, med, evenCnt, fiveCnt)

;  Arguments Passed:
;	1. list,    addr
;	2. length,  value
;	3. minimum, addr
;	4. maximum, addr
;	5. median,  addr
;	6. evenCnt, addr
;	7. fiveCnt, addr

;  Returns:
;	minimum, median, maximum, evenCnt, fiveCnt
;	via pass-by-reference

global simpleStats
simpleStats:
	push rbp
	mov  rbp, rsp
	push rbx
	push r12
	push r13
	push r14

; MAX, rcx
	mov eax, dword[rdi]					; eax = list
	mov dword[rcx], eax					; max = list, the first item after sorted

; MIN, rdx
	mov r10, 0							; r10 = 0, refresh value
	mov r10d, esi						; r10 = len
	dec r10								; r10 = len - 1, the last value index
	mov eax, dword[rdi + r10*4]			; eax = list[len - 1]
	mov dword[rdx], eax					; min = eax

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
	div r10d								; r10 = (list[len / 2] + list[len - 1 / 2]) / 2

isOdd:
	mov dword[r8], eax					; eax has the answers

; EVENCNT, r9
	mov rcx, rsi						; rcx = len
	mov r13, 0
	mov eax, dword[rdi]					; eax = list, first element

evenLoop:
	mov r8d, 2							; r8 = 2
	cdq
	idiv r8d
	cmp edx, 0							; if edx = 0, evenCnt++
	jne evenDone
	add dword[r9], 1					; evenCnt++

evenDone:
	inc r13								; r13 = r13 + 1
	mov eax, dword[rdi + r13*4]			; eax = list[r13]
	loop evenLoop

; FIVECNT, rax
	mov r10, 0
	mov rcx, rsi						; rcx = len
	mov r14, 0
	mov eax, dword[rdi]					; eax = list, first element

fiveLoop:
	mov r8d, 5							; r8 = 5
	cdq
	idiv r8d
	cmp edx, 0							; if edx = 0, fiveCnt++
	jne fiveDone
	add r10, 1

fiveDone:
	inc r14								; r14 = r14 + 1
	mov eax, dword[rdi + r14*4]			; eax = list[r14]
	loop fiveLoop

	mov rbx, qword[rbp+16]				; rbx = address of where we push fiveCnt
	mov qword[rbx], r10					; fiveCnt = r10

	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
ret

; ********************************************************************
;  Function to calculate the integer average of an integer array.

; -----
;  Call:
;	ave = iAverage(list, len)

;  Arguments Passed:
;	1. list, addr - 8
;	2. length, value - 12

;  Returns:
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



; ********************************************************************
;  Function to calculate the variance and standard deviation
;  of an integer array.
;  Must use iAverage() function to find average.
;  Must use the stdDev() function to find the standard deviation.
;	Note, stdDev() is a real function, which returns values in xmm0.

;  Must use MOVSD to store result from XMM0 to a memory location.
;  For example:
;	movsd	qword [someVar], xmm0

; -----
;  Call:
;	lstStats(list, len, &var, &std)

;  Arguments Passed:
;	1. list,     addr
;	2. length,   value
;	3. variance, addr
;	4. standard deviation, addr

;  Returns:
;	variance - value (quad)

global lstStats

lstStats:

	push rbx
	push r12
	push r13
	push r14

	mov rbx, rdi					; rbx = list
	movzx r12, si					; r12 = len
	mov r13, rdx					; r13 = variance
	mov r14, rcx					; r14 = standard deviation

	call iAverage					; rdi, and esi already set
	mov r11d, eax					; r11 = average, since function return value in eax

	mov qword[tmpVar], 0			; tmpVar = 0, quad-word
	mov rcx, r12					; rcx = len, counter to loop the sumLoop
	mov r10, 0						; r10 = index in our array

sumLoop1:
	mov eax, dword[rdi+r10*4]		; eax = list[i]
	sub eax, r11d					; eax = list[i] - average
	
	imul eax						; eax = (list[i] - average) ^ 2
	add dword[tmpVar], eax			; tmpVar = tmpVar + (list[i] - average) ^ 2
	adc dword[tmpVar+4], edx		; add the MSQ, since we are using 64-bit integers
	
	inc r10
	loop sumLoop1					; counter--, sumLoop1

	mov rdx, qword[tmpVar]			; rdx = tmpVar
	mov qword[r13], rdx

	mov rdi, qword[tmpVar]			; rdi = tmpVar
	mov rsi, r12					; rsi = len
	call stdDeviation				; rdi, rsi, already set
	movsd qword[r14], xmm0			; r14 = variance, quad-word

	pop r14
	pop r13
	pop r12
	pop rbx
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
;	1. variance, value
;	2. length, value

;  Returns:
;	standard deviation in xmm0

global	stdDeviation
stdDeviation:

	; convert integers to floats
	cvtsi2sd	xmm0, rdi
	cvtsi2sd	xmm1, rsi

	divsd		xmm0, xmm1
	sqrtsd		xmm0, xmm0

	ret

; ********************************************************************

