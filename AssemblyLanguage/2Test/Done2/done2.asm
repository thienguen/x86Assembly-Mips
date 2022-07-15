
; TODO MACRO< FUNCTION

;* Q2:  Write a function, writeEncStr(), to accept a string passed from the main, encrypt the string, 
;* and write the string to a file. The function must call the encryptStr() function to perform the encryption
;* and obtain the applicable counts. The function should open/create a file, write the string 
;* (after the call to encryptStr()), return the results, and close the file. If the file open 
;* or file write operations fail, the function should return FALSE. An error message is not needed. 
;* If the I/O operations are successful, the function should return all applicable results (via reference) and return TRUE.
;* You may assume the standard constants are already defined (i.e., SYS_open, SYS_write, SYS_close, TRUE, and FALSE). 
;* The main calls the function as follows:

; TODO stat = writeEncStr(fileName, inStr, &ltrCnt, &digitCnt, &strLen);

;* Where fileName and inStr are addresses of NULL terminated strings, and ltrCnt, digitCnt, and strLen are the addresses
;* of where to return the appropriate unsigned double-word results. Your function must use the standard calling 
;* convention to access the arguments and save/restore only the appropriate registers used. The function must use a 
;* stack dynamic local for storing the file descriptor. You must define and show any additional data declarations that 
;* are used (if any). Points will be deducted for especially poor or inefficient solutions.


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

; TODO PLACE DATA HERE





; -----
;  Misc. data definitions (if any).

swapped		db	TRUE

; -----

section	.bss

;	Place data declarations for uninitialized data here...
;	(i.e., large arrays that are not initialized)











; =====================================================================

section	.text
global	_start
_start:

; -----

; TODO START HERE






last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rdi, EXIT_SUCCESS	; return code of 0 (no error)
	syscall
