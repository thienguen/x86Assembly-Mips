
; *****************************************************************
;  Static Data Declarations (initialized)

section	.data

; -----
;  Define standard constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Initialized Static Data Declarations.

;	Place data declarations here...


; TODO PLACE DATA HERE





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


; TODO START HERE







; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rdi, EXIT_SUCCESS	; return code of 0 (no error)
	syscall

; ----------------------------------------------
; lst    dw  2, -5, 7, -9, 11, 8, -13, 4, -2

;     mov ax, word[lst+4]
;     mov bx, word[lst+8]
;     cwd

;     mov rcx,2
;     mov rsi, rcx
;     idiv cx
; loop2:
;     add ax, word[lst+rsi*2]
;     add rsi, 2
;     loop loop2
;     add bx, word[lst+rsi*2]


; ax: 0x0015
; bx: Error, isn't out of bound
; dx: 0x0001


; ----------------------------------------------
; list   db  6, 4, 3, -1, 2, -3 ,5, 7

;     mov rbx, list
;     mov rsi, 2
;     mov rax, 4
;     mov dl, byte[list+3]

;     mov rcx, 2
;     cmp al, byte[list+2]
;     je loop1
;     mov byte[list+3], 6

; loop1:
;     add al, byte[list+rsi]
;     add rsi, 2
;     loop loop1
;     imul byte[rbx+4]
;     inc ax
;     idiv byte[rbx+2]

; al: 0x06
; ah: 0x01
; dl: 0xff


; ----------------------------------------------
; list3  dd  6, 5, 4, 3, 2, 1, 0

;     mov rbx, list3
;     mov rdx, 12
;     mov rsi, 4
    
;     mov rax, 1
;     mov rcx, 2
;     mov dword[list3+4], 3

; loop3:
;     add eax, dword[rbx+rsi*4]
;     inc rsi
;     loop loop3
;     imul dword[list3+4]
;     mov r12d, eax
;     add eax, 2
;     idiv dword[rbx+12]

; eax:  0x00000004
; edx:  0x00000002
; esi:  0x00000006
; r12d: 0x00000012


; ----------------------------------------------
; wLst dw 3, 2, 5, 4, 7, 13, 9, 8, 6, 10, 13

; loop1:
;     imul byte[wlst+rsi]
;     div byte[wlst]
;     add rsi, 2
;     loop loop1

;     mov ax, word[wLst+10]
;     mov rcx, 0

;     mov cx, word[wLst+4]
;     mov rsi, 2
;     mov dx, 0

;     div word[wLst+rsi*2]
;     push rcx
;     sub rcx, 3

; loop2:

;     sub ax, word[wLst+rsi*2]
;     inc rsi
;     loop loop2
;     mov bx, ax
;     pop rax

; ----------------------------------------------
; list   db   6, 4, 3, -1, 2, -3, 5, 7

;     mov   rbx, list
;     mov   rsi, 2
;     mov   rax, 4
;     mov   rcx, 2
;     mov   rdx, 17
;     cmp   al, byte [list+2]
;     jne   lp
;     mov   byte [list+4], 6
; lp:
;     add   al, byte [list+rsi]
;     add   rsi, 2
;     loop  lp
;     imul  byte [rbx+4]
;     inc   ax
;     idiv  byte [rbx+2]
;     mov   bx, word [list]


    ; ax: 0x0106
    ; dx: 0x0011
    ; bx: 0x0406

; ----------------------------------------------
; list   dw   2, 2, 4, 2, 1

;     mov   rsi, 0
;     mov   rax, 1
;     mov   rdx, -1
;     mov   rcx, 2
;     mov   word [list+2], 3
;     inc   ax
; lp:
;     add   ax, word [list+rsi*2]
;     inc   rsi
;     loop  lp
;     cmp   cx, word [list+2]
;     je    noMult
;     mul   word [list+2]
; noMult:

    ; ax: 0x0015
    ; dx: 0x0000

; ----------------------------------------------
; list   dd   2, 2, 4, 2, 1

;     mov   rsi, 0
;     mov   rax, 1
;     mov   rdx, -1
;     mov   rcx, 2
;     mov   dword [list+4], 3
;     inc   eax
; lp:
;     add   eax, dword [list+rsi*4]
;     inc   rsi
;     loop  lp
;     cmp   ecx, dword [list]
;     je    noMult
;     mul   dword [list+4]
; noMult:

    ; eax: 0x00000015
    ; edx: 0x00000000

; ----------------------------------------------
; mov eax, 0x12345678
; mov ebx, eax
; mov ecx, eax
; ror ebx, 16
; shl ecx, 16
; and eax, 0x0000ffff

    ; eax: 0x00005678
    ; ebx: 0x56781234
    ; ecx: 0x56780000


; ----------------------------------------------
; list   dd   6, 5, 4, 3, 2, 1, 0

;     mov   rbx, list
;     mov   rsi, 4
;     mov   rax, 1
;     mov   rcx, 2
;     mov   dword [list+4], 3
;     lp:
;     add   eax, dword [rbx+rsi*4]
;     inc   rsi
;     loop  lp
;     imul  dword [list+4]
;     idiv  dword [rbx+12]

    ; eax: 0x00000004
    ; edx: 0x00000000
    ; rsi: 0x0000000000000006

; ----------------------------------------------

; list db 3, 2, 1, 3, 5, 4, 2, 1, 5

;     mov rbx, list
;     mov rsi, 5
;     mov rdx, 0
;     mov rcx, 3
;     inc rsi

;     mov byte[list+4], 3

; lp: mov al, byte[rbx+rsi]
;     mul al
;     add dx, ax
;     sub rsi, 2
;     loop lp

; ax: 0x0001
; dx: 0x000E

; ----------------------------------------------

    ; list dd 6, 5, 4, 3, 2, 1, 0    

    ; mov rbx, list
    ; mov rsi, 3
    ; mov rax, 0
    ; mov rcx, 2

    ; mov dword [list+4], 2
    ; lp:
    ; add eax, dword [rbx+rsi*4]
    ; inc rsi
    ; loop lp
    ; imul dword [list+4]
    ; idiv dword [rbx+12]


; ----------------------------------------------


