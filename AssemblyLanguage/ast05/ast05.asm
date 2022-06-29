; *****************************************************************
;  Name: Thien Nguyen
;  NSHE ID:
;  Section: 1004
;  Assignment: 5
;  Description: Write a simple assembly language program to calculate 
;  the some geometric information for a series of cubes; areas and volumes.
;  The information for the cubes are stored in an array.  
;  Once the areas and volumes are computed, the program should find the 
;  minimum, maximum, middle value, sum, and average for the areas and volumes.


; *****************************************************************
;  Static Data Declarations (initialized)

section	.data
	
; -----
;  Define constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Initialized Static Data Declarations.

;	Place data declarations here...

sides	dw	 10,  14,  13,  37,  54 
		dw	 14,  29,  64,  67,  34 
		dw	 31,  13,  20,  61,  36 
		dw	 14,  53,  44,  19,  42 
		dw	 44,  52,  31,  42,  56 
		dw	 15,  24,  36,  75,  46 
		dw	 27,  41,  53,  62,  10 
		dw	 33,   4,  73,  31,  15 
		dw	  5,  11,  22,  33,  70 
		dw	 15,  23,  15,  63,  26 
		dw	 16,  13,  64,  53,  65 
		dw	 26,  12,  57,  67,  34 
		dw	 24,  33,  10,  61,  15 
		dw	 38,  73,  29,  17,  93 
		dw	 64,  73,  74,  23,  56 
		dw	  9,   8,   4,  10,  15 
		dw	 13,  23,  53,  67,  35 
		dw	 14,  34,  13,  71,  81 
		dw	 17,  14,  17,  25,  53 
		dw	 23,  73,  15,   6,  13 

length	dd	100 

caMin		dw	0 
caMid		dw	0 
caMax		dw	0 
caSum		dd	0 
caAve		dw	0 

cvMin		dd	0 
cvMid		dd	0 
cvMax		dd	0 
cvSum		dd	0 
cvAve		dd	0 

; -----
; Additional variables (if any)

; ----------------------------------------------
;  Uninitialized Static Data Declarations.

section	.bss

;	Place data declarations for uninitialized data here...
;	(i.e., large arrays that are not initialized)

cubeAreas   resw  100
cubeVolumes resd  100


; *****************************************************************

section	.text
global _start
_start:

; -----
;	YOUR CODE GOES HERE...

; cubeAreas[i]   = side[i]^2 * 6
; cubeVolumes[i] = side[i]^3
; convert sides to dwords


; --- CUBEAREAS     --------------------------------
; --- CUBEAREAS SUM --------------------------------

	mov ecx, dword[length]	           ; counter, as many times we loop
	mov word[caSum], 0                 ; initialize sum to 0
	mov rsi, 0					       ; indexes, bytes we move up in the array

areasLoop:
	movzx eax, word[sides+rsi*2]       ; movzf will clear the upper bits for eax
	mul eax  	                       ; multiply by itself --> ^2
	mov r9d, 6       				   
	mul r9d 	                       ; multiply by 6
	mov word[cubeAreas+rsi*2], ax      ; store the word size of the multiplication
	add dword[caSum], eax              ; cubeAreas is dw --> eax
	inc rsi        					   ; increment the index
	loop areasLoop

; --- CUBEAREAS MAX --------------------------------
; --- CUBEAREAS MIN --------------------------------

	mov ax, word[cubeAreas]		       ; first element of array 
	mov word[caMax], ax	               ; set the max to first element
	mov word[caMin], ax		           ; set the first element to min
	mov rsi, 0					       ; index within the list
	mov ecx, dword[length]		       ; lenght of list, how many time we will loop

startLoop2:
	mov ax, word[cubeAreas+rsi*2]	   ; get the next element
	cmp ax, word[caMax]		  		   ; compare it to the current max
	jbe maxDone2
	mov word[caMax], ax		  		   ; if it greater than the current max, update new max

maxDone2:
	cmp ax, word[caMin]		  		   ; compare it to the min
	jae minDone2
	mov word[caMin], ax		  		   ; if it is greater than the max, update new max

minDone2:
	inc rsi        					   ; increment the index
	loop startLoop2					   ; loop until we reach the end


; --- CUBEAREAS MID --------------------------------
	mov eax, dword[length]
	mov r8d, 2
	mov edx, 0						   ; initialize the upper bits to 0 (unsgined)
	div r8d							   ; divide by 2
	mov rsi, 0						   ; initialize register 64 bits to 0
	mov esi, eax					   ; then get the exact middle element

	mov ax, word[cubeAreas+rsi*2]	   ; get the 50th element
	dec rsi
	add ax, word[cubeAreas+rsi*2]	   ; add the 49th element
	mov edx, 0						   ; initialize the upper bits to 0 (unsgined)
	div r8d							   ; divide by 2
	mov word[caMid], ax				   ; store the middle element

; --- CUBEAREAS AVERAGE ----------------------------
	mov eax, dword[caSum]	           ; get the sum of cubeAreas
	mov edx, 0 					   	   
	div dword[length]				   ; divide by the length of the array
	mov word[caAve], ax			       ; store the average in caAve

; ----------------------------------------------------

; --- CUBEVOLUMES     --------------------------------
; --- CUBEVOLUMES SUM --------------------------------

	mov ecx, dword[length]	           ; counter, as many times we loop
	mov dword[cvSum], 0                ; initialize sum to 0
	mov rsi, 0					       ; indexes, bytes we move up in the array

volumesLoop:
	movzx eax, word[sides+rsi*2]   
	mul eax  	                       ; multiply by itself --> ^2
	movzx r9d, word[sides+rsi*2]       ; get the next side 
	mul r9d 	                       ; multiply by itself

	mov dword[cubeVolumes+rsi*4], eax  ; store it in dw of cubeVoumes array
	add dword[cvSum], eax              ; add it to the sum of cubeVolumes
	inc rsi        					   ; increment the index
	loop volumesLoop

; --- CUBEVOLUMES MAX ------------------------------
; --- CUBEVOLUMES MIN ------------------------------

	mov eax, dword[cubeVolumes]	       ; first element of array
	mov dword[cvMax], eax	           ; set the max to first element
	mov dword[cvMin], eax		       ; set the first element to min
	mov rsi, 0					       ; index within the list
	mov ecx, dword[length]		       ; lenght of list, how many time we will loop

startLoop1:
	mov eax, dword[cubeVolumes+rsi*4]  ; get the next element
	cmp eax, dword[cvMax]		  	   ; compare it to the max
	jbe maxDone1
	mov dword[cvMax], eax	  		   ; if it is less than the min, update new min

maxDone1:
	cmp eax, dword[cvMin]	  		   ; compare it to the min
	jae minDone1					   ; if it is greater than the max, if not, jump
	mov dword[cvMin], eax	  		   ; update new max

minDone1:
	inc rsi        					   ; increment the index
	loop startLoop1 				   ; loop until we reach the end

; --- CUBEVOLUMES MID ------------------------------
	mov eax, dword[length]
	mov r8d, 2
	mov edx, 0						   ; initialize the upper bits to 0 (unsgined)
	div r8d							   ; divide by 2
	mov rsi, 0						   ; initialize register 64 bits to 0
	mov esi, eax					   ; then get the exact middle element

	mov eax, dword[cubeVolumes+rsi*4]  ; get the 50th element
	dec rsi
	add eax, dword[cubeVolumes+rsi*4]  ; add the 49th element
	mov edx, 0						   ; initialize the upper bits to 0 (unsgined)
	div r8d							   ; divide by 2
	mov dword[cvMid], eax			   ; store the middle element

; --- CUBEVOLUMES AVERAGE --------------------------
	mov eax, dword[cvSum]	           ; get the sum of cubeVolumes
	mov edx, 0
	div dword[length]				   ; divide by the length of the array
	mov dword[cvAve], eax			   ; store the average in cvAve
; ----------------------------------------------------


; **********************	*******************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call code for exit (SYS_exit)
	mov	rdi, EXIT_SUCCESS
	syscall
