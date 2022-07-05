


; TODO MACRO< FUNCTION


;* Q1:  Write a void function, encryptStr(), that will encrypt a string. To encrypted the string, simply
;* add one to each alphabetic (upper and lower case letters) character. All non-alphabetic characters 
;* (numbers, punctuation, spaces, etc.) are unchanged. Thus “Hello Zoo 12” becomes “Ifmmp [pp 12”. 
;* The string is NULL terminated. The function should return 1) total count of all letters, 2) 
;* the count of ASCII digits ("0"-"9"), and 3) the total string length. The function is called as follows:

; TODO encryptStr(inStr, &ltrCnt, &digitCnt, &strLen);

;* Where inStr is the input string ltrCnt, digitCnt, and strLen are the addresses of the unsigned double-word 
;* variables of where to return the appropriate values (note, passed variables not initialized to zero). 
;* Your function must use the standard calling convention to access the arguments and 
;* save/restore only the appropriate registers used. You must define and show any additional data declarations
;* that are used (if any). Points will be deducted for especially poor or inefficient solutions.

; *****************************************************************
;  Static Data Declarations (initialized)

section	.data

; -----
;  Define standard constants.

NULL			equ	0			; end of string

TRUE			equ	1
FALSE			equ	0

EXIT_SUCCESS	equ	0			; Successful operation
SYS_exit		equ	60			; call code for terminate

; -----
;  Initialized Static Data Declarations.

;	Place data declarations here...

; TODO PLACE DATA HERE








; -----
;  Misc. data definitions (if any).

swapped		db	TRUE

; -----

section	.bss

; =====================================================================

section	.text
global	_start
_start:

; -----

; TODO START HERE




; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rdi, EXIT_SUCCESS	; return code of 0 (no error)
	syscall
