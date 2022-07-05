
; *****************************************************************
;  Static Data Declarations (initialized)

section	.data

; -----
;  Define standard constants.

NULL		    equ	0			; end of string

TRUE		    equ	1
FALSE		    equ	0

EXIT_SUCCESS	equ	0			; Successful operation
SYS_exit	    equ	60			; call code for terminate

; -----
;  Initialized Static Data Declarations.

;	Place data declarations here...

aVals	dw	 11,  15,  19,  27,  44 
		dw	 54,  69,  74,  87 

bVals 	dw	 25,  31,  43,  50,  61  
		dw	 74,  83,  94,  99

cVals   dd   1,   2,   3,   4,   5
        dd   6,   7,   8,   9 

len     dd   9

min     dd   0
max     dd   0
sum     dd   0
med     dd   0
average dd   0


; -----
;  Misc. data definitions (if any).

swapped		db	TRUE

; -----

section	.bss

;	Place data declarations for uninitialized data here...
;	(i.e., large arrays that are not initialized)

pVals       resd  9

cSquare     resd  9


; =====================================================================

section	.text
global	_start
_start:

; -----

; Additionally, find the minimum, median, maximum, and average for the pVals[] 
; array.  The provided aVals[] and bVals[] arrays are word sized.  
; The provided cVals[] array and the provided length variable are double-word 
; sized.  The pVals[] array, min, med, max, and ave are double-word sized
; variables of where to store the appropriate results.  All data is unsigned.
; You may assume data is sorted (small to large) and that the length 
; is always odd.

; pVals[i] = (aVals[i]^2 + bVals[i]^2) / cVals[i]^2

    mov ecx, dword[len]                ; counter
    mov rsi, 0

pythagoLoop:
    movzx eax, word[aVals+rsi*2]       ; load aVals[i], because it's word, so we clear the upper bits
    mul eax                            ; avals[i]^2
    mul eax                            ; avals[i]^2
    add dword[pVals+rsi*4], eax
    ; mov dword[pVals+rsi*4+4], edx

    movzx eax, word[bVals+rsi*2]       ; load bVals[i], because it's word, so we clear the upper bits
    mul eax                            ; bVals[i]^2
    add dword[pVals+rsi*4], eax        ; add in pVals[i]
    ; mov dword[pVals+rsi*4+4], edx

    mov eax, dword[cVals+rsi*4]        ; load cVals[i], this is double word
    mul eax                            ; cVals[i]^2
    mov dword[cSquare+rsi*4], eax      ; but. we store it in cSquare[i]
    mov dword[cSquare+rsi*4+4], edx    ; so we need to store the upper bits lol

    mov eax, dword[pVals+rsi*4]         
    div dword[cSquare+rsi*4]
    mov dword[pVals+rsi*4], eax

    inc rsi
    loop pythagoLoop

; --- pVals MIN -------------------------------------------------------
; --- pVals MAX -------------------------------------------------------
; --- pVals SUM -------------------------------------------------------

    mov eax, dword[pVals]
    mov dword[min], eax
    mov dword[max], eax
    mov rsi, 0
    mov ecx, dword[len]

startLoop:
    mov eax, dword[pVals+rsi*4]
    add dword[sum], eax
    cmp eax, dword[max]
    jbe maxDone
    mov dword[max], eax

maxDone:
    cmp eax, dword[min]
    jae minDone
    mov dword[min], eax

minDone:
    inc rsi
    loop startLoop

; --- pVals MED ------------------------------
    mov eax, dword[len]
    mov edx, 0
    mov r8d, 2
    div r8d
    mov rsi, 0
    mov esi, eax

    mov eax, dword[pVals+rsi*4]
    mov dword[med], eax

; --- pVals AVE ------------------------------
    mov eax, dword[sum]
    mov edx, 0
    div dword[len]
    mov dword[average], eax

;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rdi, EXIT_SUCCESS	; return code of 0 (no error)
	syscall
