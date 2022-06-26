; *****************************************************************
;  Name: Thien Nguyen
;  NSHE ID: 2001904928	
;  Section: 1004
;  Assignment: 9
;  Description: Write a simple assembly language program to plot a
;  series of points on the screen using the provided algorithm.
;  The number of points to plot must be read from command line 
;  (as binary).

; -----
;  Function getIterations()
;	Gets, checks, converts, and returns iteration
;	count and rotation speed from the command line.

;  Function drawChaos()
;	Calculates and plots Chaos algorithm

;  Function aBin2int()
;	Convert ASCII/binary to integer

; ---------------------------------------------------------

;	MACROS (if any) GO HERE

; ---------------------------------------------------------

section  .data

; -----
;  Define standard constants.

TRUE			equ	1
FALSE			equ	0

EXIT_SUCCESS	equ	0			; successful operation
EXIT_NOSUCCESS	equ	1

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; code for read
SYS_write	equ	1			; code for write
SYS_open	equ	2			; code for file open
SYS_close	equ	3			; code for file close
SYS_fork	equ	57			; code for fork
SYS_exit	equ	60			; code for terminate
SYS_creat	equ	85			; code for file open/create
SYS_time	equ	201			; code for get time

LF			equ	10
SPACE		equ	" "
NULL		equ	0
ESC			equ	27

; -----
;  OpenGL constants

GL_COLOR_BUFFER_BIT	equ	16384
GL_POINTS			equ	0
GL_POLYGON			equ	9
GL_PROJECTION		equ	5889

GLUT_RGB		equ	0
GLUT_SINGLE		equ	0

; -----
;  Define program constants.

IT_MIN		equ	255
IT_MAX		equ	65535
RS_MAX		equ	1023

; -----
;  Local variables for getIterations() function.

errUsage	db	"Usage: chaos -it <binaryNumber> -rs <binaryNumber>"
			db	LF, NULL

errBadCL	db	"Error, invalid or incomplete command line argument."
			db	LF, NULL

errITsp		db	"Error, iterations specifier incorrect."
			db	LF, NULL

errITvalue	db	"Error, invalid iterations value."
			db	LF, NULL

errITrange	db	"Error, iterations value must be between "
			db	"11111111 (2) and 1111111111111111 (2)."
			db	LF, NULL

errRSsp		db	"Error, rotation speed specifier incorrect."
			db	LF, NULL

errRSvalue	db	"Error, invalid rotation speed value."
			db	LF, NULL

errRSrange	db	"Error, rotation speed value must be between "
			db	"0 (2) and 1111111111 (2)."
			db	LF, NULL

; -----
;  Local variables for plotChaos() funcction.

red			dd	0					; 0-255
green		dd	0					; 0-255
blue		dd	0					; 0-255

pi			dq	3.14159265358979	; constant
oneEighty	dq	180.0
tmp			dq	0.0

dStep		dq	120.0				; t step
scale		dq	500.0				; scale factor

rScale		dq	100.0				; rotation speed scale factor
rStep		dq	0.1					; rotation step value
rSpeed		dq	0.0					; scaled rotation speed

initX		dq	0.0, 0.0, 0.0		; array of x values
initY		dq	0.0, 0.0, 0.0		; array of y values

x			dq	0.0
y			dq	0.0

seed		dq	987123
qThree		dq	3
fTwo		dq	2.0

A_VALUE		equ	9421				; must be prime
B_VALUE		equ	1


; ------------------------------------------------------------

section  .text

; -----
; Open GL routines.

extern glutInit, glutInitDisplayMode, glutInitWindowSize
extern glutInitWindowPosition
extern glutCreateWindow, glutMainLoop
extern glutDisplayFunc, glutIdleFunc, glutReshapeFunc, glutKeyboardFunc
extern glutSwapBuffers
extern gluPerspective
extern glClearColor, glClearDepth, glDepthFunc, glEnable, glShadeModel
extern glClear, glLoadIdentity, glMatrixMode, glViewport
extern glTranslatef, glRotatef, glBegin, glEnd, glVertex3f, glColor3f
extern glVertex2f, glVertex2i, glColor3ub, glOrtho, glFlush, glVertex2d
extern glutPostRedisplay

; -----
;  c math library funcitons

extern	cos, sin, tan, cosh, sinh, tanh


; ******************************************************************
;  Generic function to display a string to the screen.
;  String must be NULL terminated.
;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

;  Arguments:
;	1) address, string
;  Returns:
;	nothing

global	printString
printString:
	push	rbx

; -----
;  Count characters in string.

	mov	rbx, rdi			; str addr
	mov	rdx, 0
strCountLoop:
	cmp	byte [rbx], NULL
	je	strCountDone
	inc	rbx
	inc	rdx
	jmp	strCountLoop
strCountDone:

	cmp	rdx, 0
	je	prtDone

; -----
;  Call OS to output string.

	mov	rax, SYS_write			; system code for write()
	mov	rsi, rdi				; address of characters to write
	mov	rdi, STDOUT				; file descriptor for standard in
								; RDX=count to write, set above
	syscall						; system call

; -----
;  String printed, return to calling routine.

prtDone:
	pop	rbx
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

; ----- ; TODO aBin2int
;  Returns 
;	1) integer value (via passed address)
;	2) bool, TRUE if valid conversion, FALSE for error

global	aBin2int
aBin2int:
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
;  Function getIterations()
;	Performs error checking, converts ASCII/binary to integer.
;	Command line format (fixed order):
;	  "-it <binaryNumber> -rs <binaryNumber>"

; ----- ; TODO getIterations()
;  Arguments: 
;	1. rdi ARGC, double-word, value --> rdi
;	2. rsi ARGV, double-word, address --> rsi
;	3. rdx Iterations count, double-word, address --> rdx
;	4. rcx Rotate spped, double-word, address --> rcx

global	getIterations
getIterations:

	push rbx						; save registers
	push r12
	push r13
	push r14
	push r15

	mov r12, rsi 					; ARGV vector address
	mov r13, rdi					; ARGC count

	mov r14, rdx					; iterations count address
	mov r15, rcx					; rotate speed address

	; IF ARGC = 1
	cmp r13, 1						; if user only did ./chaos
	je	usageMsg

	; IF ARGC < 5
	cmp r13, 5						; if user did ./chaos <dummy>
	jne	badCommandMsg

	; CHECK 1 ARGUMENT
	mov rbx, qword[r12+8]			; get address of first argument

	mov al, byte[rbx]				; get first character of first argument
	cmp al, "-"						; check for '-'
	jne	iterSpecMsg					; if not '-', then error

	mov al, byte[rbx+1]				; get second character of first argument
	cmp al, "i"						; check for 'i'
	jne	iterSpecMsg					; if not 'i', then error

	mov al, byte[rbx+2]				; get third character of first argument
	cmp al, "t"						; check for 't'
	jne	iterSpecMsg					; if not 't', then iterSpecMsg

	mov al, byte[rbx+3]				
	cmp al, NULL					; check for 'NULL'
	jne	iterSpecMsg					; if NULL, then error

	; CHECK 2 ARGUMENT
	; VERIFY RANGE
	mov rdi, qword[r12+16]			; get address of second argument
	mov rsi, r14					; get address of iterations count
	call aBin2int					; convert to integer
	cmp rax, TRUE					; if equal 0, FALSE	
	jne	iterValueMsg				

	cmp dword[r14], IT_MAX			; if > IT_MAX
	ja	iterRangeMsg				

	cmp dword[r14], IT_MIN			; if < IT_MIN
	jb	iterRangeMsg				

	; CHECK 3 ARGUMENT
	mov rbx, qword[r12+24]			; get address of third argument

	mov al, byte[rbx]				; get first character of third argument
	cmp al, "-"						; check for '-'
	jne	rotationSpecMsg				

	mov al, byte[rbx+1]				; get second character of third argument
	cmp al, "r"						; check for 'r'
	jne	rotationSpecMsg				

	mov al, byte[rbx+2]				; get third character of third argument
	cmp al, "s"						; check for 's'
	jne	rotationSpecMsg				

	mov al, byte[rbx+3]				; get fourth character of third argument
	cmp al, NULL					; check for 'NULL'
	jne	rotationSpecMsg

	; CHECK 4 ARGUMENT
	; VERIFY RANGE
	mov rdi, qword[r12+32]			; get address of fourth argument
	mov rsi, r15
	call aBin2int					; convert to integer
	cmp rax, TRUE
	jne	rotationValueMsg			; if equal 0, FALSE

	cmp dword[r15], RS_MAX
	ja	rotationRangeMsg			; if > ROT_MAX, then error

	cmp dword[r15], 0				; if < 0
	jb	rotationRangeMsg			; if < 0, then error
	
	; mov r15d, dword[rsi]

; --- SUCCESFUL INPUTS   --------------------------------------------------
	jmp exitFunction

; --- ALL ERROR MESSAGES --------------------------------------------------
usageMsg:							; Dumb users
	mov rdi, errUsage				
	jmp print

badCommandMsg:						; Dumb users
	mov rdi, errBadCL			
	jmp print

iterSpecMsg:						; ARGUMENT 1
	mov rdi, errITsp				
	jmp print

iterValueMsg:						; ARGUMENT 2
	mov rdi, errITvalue	
	jmp print

iterRangeMsg:						; ARGUMENT 2
	mov rdi, errITrange
	jmp print

rotationSpecMsg:					; ARGUMENT 3
	mov rdi, errRSsp				
	jmp print

rotationValueMsg:					; ARGUMENT 4
	mov rdi, errRSvalue				
	jmp print

rotationRangeMsg:					; ARGUMENT 4
	mov rdi, errRSrange				
	jmp print

print:							
	call printString
	mov rax, FALSE

exitFunction:

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	ret

; ******************************************************************
;  Function to draw chaos algorithm.

;  Chaos point calculation algorithm:
;	seed = random large prime (pre-set)
;	for  i := 1 to iterations do
;		s = rand(seed)
;		n = s mod 3
;		x = x + ( (init_x(n) - x) / 2 )
;		y = y + ( (init_y(n) - y) / 2 )
;		color = n
;		plot (x, y, color)
;		seed = s
;	end_for

	; TODO DRAW CHAOS
; -----
;  Global variables (from main) accessed.

common	drawColor	1:4			; draw color
common	degree		1:4			; initial degrees
common	iterations	1:4			; iteration count
common	rotateSpeed	1:4			; rotation speed

; -----
global drawChaos
drawChaos:
	push rbx
	push r12
	push r13
; -----
;  Save registers...

	mov r13, 0

; -----
;  Prepare for drawing
	; glClear(GL_COLOR_BUFFER_BIT);

	mov	rdi, GL_COLOR_BUFFER_BIT
	call	glClear

; ----- 
;  Set rotation speed step value.
;	rStep = rotateSpeed / scale
	cvtsi2sd xmm0, dword[rotateSpeed]
	divsd xmm0, qword[rScale]
	movsd qword[rStep], xmm0

; ----- 
;  Calculate and plot initial points.
;  initX[i] = sin((rSpeed + (i * dStep)) * temp) * scale
;  initY[i] = cos((rSpeed + (i * dStep)) * temp) * scale
;  tmp = pi / 180.0

	movsd xmm0, qword[pi]
	divsd xmm0, qword[oneEighty]
	movsd qword[tmp], xmm0

; -----
;  Plot initial points.
	; glBegin();
	mov	rdi, GL_POINTS
	call	glBegin

; ----- 
	; INITX, INITY
	mov rbx, 0

; extern	cos, sin, tan, cosh, sinh, tanh

initLoop:
	; x[i]
	movsd xmm0, qword[rSpeed]
	cvtsi2sd xmm1, rbx
	mulsd xmm1, qword[dStep]
	addsd xmm0, xmm1
	mulsd xmm0, qword[tmp]
	call sin
	mulsd xmm0, qword[scale]
	movsd qword[initX+rbx*8], xmm0

	; y[i]
	movsd xmm0, qword[rSpeed]
	cvtsi2sd xmm1, rbx
	mulsd xmm1, qword[dStep]
	addsd xmm0, xmm1
	mulsd xmm0, qword[tmp]
	call cos
	mulsd xmm0, qword[scale]
	movsd qword[initY+rbx*8], xmm0

	movsd xmm0, qword[initX+rbx*8]
	movsd xmm1, qword[initY+rbx*8]
	call glVertex2d

	inc rbx
	cmp rbx, 4
	jb initLoop

; -----
;  Main plot loop.
mainPlotLoop:

; ----- 
;  Generate pseudo random number, via linear congruential generator 
;	s = (A × seed + B) mod 2^16
;	n = s mod 3
;  Note, A and B are constants.

	mov rax, qword[seed]			; rax = seed
	mov r8, A_VALUE					; r8 = A
	mul r8							; rax = A * seed
	add rax, B_VALUE				; rax = A * rax + B
	mov qword[seed], 0				; reset seed
	mov word[seed], ax				; seed = A * rax + B 16 bits
	cqo
	idiv dword[qThree]				; seed = seed / 3

	; edx = n = s mod 3 = 0, 1 or 2 for the remainder
	; used for color selection

; ----- 
;  Generate next (x,y) point.
; x and y initialized to 0.0 before the loop
; x and y updated after each iteration of loop
;	x = x + ( (initX[n] - x) / 2 )
;	y = y + ( (initY[n] - y) / 2 )

	mov r12, 0
	mov r12, rdx					; r12 = n, remainder above

	; x = x + ( (initX[n] - x) / 2 )
	movsd xmm0, qword[initX+rdx*8]	; xmm0 = initX[n]
	subsd xmm0, qword[x]			; xmm0 = initX[n] - x
	divsd xmm0, qword[fTwo]			; xmm0 = (initX[n] - x) / 2
	addsd xmm0, qword[x]			; xmm0 = x + ( (initX[n] - x) / 2 )
	movsd qword[x], xmm0			; x = xmm0

	; y = y + ( (initY[n] - y) / 2 )
	movsd xmm0, qword[initY+rdx*8]	; xmm0 = initY[n]
	subsd xmm0, qword[y]			; xmm0 = initY[n] - y
	divsd xmm0, qword[fTwo]			; xmm0 = (initY[n] - y) / 2
	addsd xmm0, qword[y]			; xmm0 = y + ( (initY[n] - y) / 2 )
	movsd qword[y], xmm0			; y = xmm0

;  Set draw color (based on n)
;	0 => red
;	1 => blue
;	2 => green

	cmp r12d, 0
	je redColor

	cmp r12d, 1
	je blueColor
	
	cmp r12d, 2
	je greenColor

redColor:
	mov dword[red], 255
	mov dword[green], 255
	mov dword[blue], 40
	jmp afterChoosingColor

blueColor:
	mov dword[red], 255
	mov dword[green], 0
	mov dword[blue], 255
	jmp afterChoosingColor

greenColor:
	mov dword[red], 0
	mov dword[green], 255
	mov dword[blue], 255
	jmp afterChoosingColor

; -----
afterChoosingColor:

	mov rdi, 0
	mov rsi, 0
	mov rdx, 0

	mov edi, dword[red]
	mov esi, dword[green]
	mov edx, dword[blue]
	call glColor3ub

	; Plot points
	movsd xmm0, qword[x]			; xmm1 = x
	movsd xmm1, qword[y]			; xmm0 = y
	call glVertex2d

	; Loop control
	inc r13
	cmp r13d, dword[iterations]
	jbe mainPlotLoop

	call glEnd
	call glFlush

; -----
;  Update rotation speed.
;  Then tell OpenGL to re-draw with new rSpeed value.
;	rSpeed = rSpeed + rStep
	movsd xmm0, qword[rSpeed]
	addsd xmm0, qword[rStep]
	movsd qword[rSpeed], xmm0
	
	call glutPostRedisplay

	pop r13
	pop	r12
	pop rbx
ret

; ******************************************************************

