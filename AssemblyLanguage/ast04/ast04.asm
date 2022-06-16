; *****************************************************************
;  Name: Thien Nguyen
;  NSHE ID: 2001904928
;  Section: 1004
;  Assignment: 4
;  Description: Write a simple assembly language program to find the minimum,
;  middle value, maximum, sum, and integer average of a list of numbers. 
;  Additionally, the program should also find the sum, count, and integer 
;  average for the even numbers. The program should also find the sum, count,
;  and integer average for the numbers that are evenly divisible by 5.

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

lst		dd	 1246,  1116,  1542,  1240,  1677
		dd	 1635,  2426,  1820,  1246, -2333
		dd	 2317, -1115,  2726,  2140,  2565
		dd	 2871,  1614,  2418,  2513,  1422
		dd	-2119,  1215, -1525, -1712,  1441
		dd	-3622,  -731, -1729,  1615,  1724
		dd	 1217, -1224,  1580,  1147,  2324
		dd	 1425,  1816,  1262, -2718,  2192
        dd	-1432,  1235,  2764, -1615,  1310
		dd	 1765,  1954,  -967,  1515,  3556
		dd	 1342,  7321,  1556,  2727,  1227
		dd	-1927,  1382,  1465,  3955,  1435
		dd	-1225, -2419, -2534, -1345,  2467
		dd	 1315,  1961,  1335,  2856,  2553
		dd	-1032,  1835,  1464,  1915, -1810
		dd	 1465,  1554, -1267,  1615,  1656
		dd	 2192, -1825,  1925,  2312,  1725
		dd	-2517,  1498, -1677,  1475,  2034
		dd	 1223,  1883, -1173,  1350,  1415
		dd	  335,  1125,  1118,  1713,  3025
		
len		dd	100

lstMin		dd	0
lstMid		dd	0
lstMax		dd	0
lstSum		dd	0
lstAve		dd	0

evenCnt		dd	0
evenSum		dd	0
evenAve		dd	0

fiveCnt		dd	0
fiveSum		dd	0
fiveAve		dd	0

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


; --- MAXIUM VALUE      ---
; --- MINIMUM VALUE     ---
; --- SUMAMATTION VALUE ---

	mov eax, dword[lst]			  ; first element of list 
	mov dword[lstMin], eax		  ; is the first element to min
	mov dword[lstMax], eax	      ; set the max to first element
	mov rsi, 0					  ; index within the list
	mov ecx, dword[len]			  ; lenght of list, how many time we will loop
	mov r8d, 0					  ; sum = 0, could be different

startLoop:
	mov eax, dword[lst+(rsi*4)]
	add r8d, eax				  ; sum += eax

	cmp eax, dword[lstMax]		  ; if eax > dword[lstMax]
	jle maxDone
	mov dword[lstMax], eax		  ; update the new max
maxDone:
	cmp eax, dword[lstMin]		  ; if eax < dword[lstMin]
	jge minDone	    		      ; if not, goto MinDone
	mov dword[lstMin], eax	      ; if so, update new minimum

minDone:
	inc rsi						  ; increment index, until loop end
	loop startLoop		 		  ; loop would handle ecx
	mov dword[lstSum], r8d        ; the sum along the way

; --- MIDDLE VALUE ---
	mov eax, dword[len]
	mov r8d, 2					  ; dividend
	cqo
	idiv r8d 			          ; divide by 2
	mov rsi, 0
	mov esi, eax                  ; rdi = len / 2, 32 bits == 

	mov eax, dword[lst+rsi*4]	  ; 50th value
	dec rsi
	add eax, dword[lst+rsi*4]	  ; 51th value
	cqo
	mov r8d, 2
	idiv r8d			          ; divide by 2
	mov dword[lstMid], eax		  ; final middle value of even list

; --- AVERAGE VALUE ---
	mov eax, dword[lstSum]		  ; using the sum we computed above
	cdq 						  ; sign extend eax to edx
	idiv dword[len]  			  ; divide by lenght of list
	mov dword[lstAve], eax		  ; final average value of even list

; --- EVEN VALUE     ---
; --- EVEN SUMMATION ---

	mov eax, dword[lst]			  ; first element of list 
	mov r9d, eax				  ; set the first element to r9d
	mov rsi, 0					  ; index within the list
	mov ecx, dword[len]			  ; lenght of list, how many time we will loop

evenLoop:
	mov r8d, 2
	cdq		
	idiv r8d			          ; divide by 2
	cmp edx, 0                    ; compare the remainder to 0
	jne evenDone   				  ; if not, we dont do anything
	add dword[evenCnt], 1		  ; we have an even number
	add dword[evenSum], r9d		  ; sum += r9d

evenDone:
	inc rsi						  ; increment index, until loop end
	mov eax, dword[lst+(rsi*4)]   ; 
	mov r9d, eax				  ; save the new r9d
	loop evenLoop		 		  ; loop would handle ecx

; --- EVEN AVERAGE ---
	mov eax, dword[evenSum]		  ; using the sum we computed above
	cdq 						  ; sign extend eax to edx
	idiv dword[evenCnt]  		  ; divide by lenght of list
	mov dword[evenAve], eax		  ; final average value of even list

; --- FIVE VALUE     ---
; --- FIVE SUMMATION ---

	mov eax, dword[lst]			  ; first element of list 
	mov r9d, eax				  ; set the first element to r9d
	mov rsi, 0					  ; index within the list
	mov ecx, dword[len]			  ; lenght of list, how many time we will loop

by5Loop:
	mov r8d, 5
	cdq
	idiv r8d			          ; divide by 5
	cmp edx, 0                    ; compare the remainder to 0
	jne divBy5   				  ; if not, we dont do anything
	add dword[fiveCnt], 1		  ; we have an even number
	add dword[fiveSum], r9d		  ; sum += r9d

divBy5:
	inc rsi						  ; increment index, until loop end
	mov eax, dword[lst+(rsi*4)]   ;
	mov r9d, eax				  ; save the new r9d
	loop by5Loop		 		  ; loop would handle ecx

; --- FIVE AVERAGE ---
	mov eax, dword[fiveSum]		  ; using the sum we computed above
	cdq 						  ; sign extend eax to edx
	idiv dword[fiveCnt]  		  ; divide by lenght of list
	mov dword[fiveAve], eax		  ; final average value of even list

; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call code for exit (SYS_exit)
	mov	rdi, EXIT_SUCCESS
	syscall


