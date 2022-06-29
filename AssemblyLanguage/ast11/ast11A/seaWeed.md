Assignment 11 Notes: SeaWeed

---
`getArguments():` Really similar to getIterations() from AS10.

Basic Algorithm (Can be done in basically any order, just check that argc is between 4 and 7 (5 or 6)

`QUICK NOTE:` You will make syscalls of at most 1 arg, so preserve your registers as necessary. If you're clever enough not necessary, but it's safe to do so.

`Step 1/2 : Must be done first in order to avoid segfaulting`

- Check if argc == 1. If so, print usageMsg and return FALSE. Exit function

- If argc!=1, check that arg>4 but that it's also <7 . If not print out errFew (<4) or errMany (>7) and return FALSE. Then exit function.

- If here, we know argc is in proper range so user passed acceptable amount of arguments. Check each argument and make sure they're correct.

---
`Step 3: Checking command line arguments.`

Can be checked in any order. 

- Checking '-i' and '-o'. Very straightforward. Follow checking '-it' and '-rs' from AS10

- Checking inFileName and outFileName: Open the file using the correct argv. If an error is encountered while opening, display appropriate message and exit function returning false in rax

    - errOpenIn for rax < 0 when opening input file
    - errOpenOut for rax < 0 when opening output file
    - In either case, make sure to set the inputFileDescriptor (originally rdx) or the outputFileDescriptor (originally rcx)
            
- Checking -d :
    - First check if argc is 5 (no -d) or 6 (yes -d). If argc == 6, check for "-d" on argv[5]. If argc == 5, then no -d was specified.
    - In either case make sure to set the boolean for display to screen as appropriate. This is originally passed as r8.
---
`Step 4: `

If here the user correctly used the command line to pass their arguments and the appropriate files have been opened and their descriptors set. 

At this point the function has done what was asked of it and it is ready to exit. Proceed with your epilogue popping your preserved registers and base pointer (if applicable).
After that, simply pop rip back via ret and you are done!

---
---
`countDigits():`

Basically read into our buffer, from rdFileDesc, BUFFSIZE amount of chars to parse and go through.

ONLY CALLED ONCE IN benford.cpp SO MAKE SURE TO HANDLE ENTIRE FILE IN JUST ONE FUNCTION CALL

Start of pseudocode/algorithm:

General Notes:
  - We will read from an input file. If in this function, we will ONLY be reading from the opened inputFile.

Very Basic Algorithm:

- Start by reading BUFFSIZE amount of chars from the inputFile into the buffer

  -  Check if rax returned <0 (error) and jmp to errorMsg if true. If rax>0, then check if rax BUFFSIZE
    
  - If rax < BUFFSIZE, that means we're at EOF so set wasEOF to true.

- We will now check to see if we must skip lines. Can do so in many ways. I would just check if skipLineCount == SKIP_LINES

  - This will be handled in below's logic

- There will first be SKIP_LINES (5) lines that we must skip. We can do so by just reading 5 linefeeds (LF).

  - None of these lines will be parsed or stored for interpretation by our program. Literally just skip them
  - Refer to skipping the ' ' char in AS9 or skipping chars when buffer was full in AS9.

- After skipping those SKIP_LINES amount of lines (by checking LFs), we will now be at the point in which we will have to parse each data line.

  - To do so, start by skipping SKIP_CHARS (6) amount of chars. Similar to SKIP_LINES logic but now no checking of LF.
  - Legit just ignore SKIP_CHARS amount of characters. 

- After that you must check each following char as we no longer have to skip chars in the line (until an LF is hit, then repeat above step and continue through)

  - Just check each char until you hit one that is NOT a whitespace ' '
  - Once that's true, convert that char to a digit (-0x30) and increment that index of the count array.
  
  - Also make sure to set gotDigit to true so that you enter a block of code in which you just skip until the next LF

  - When that next LF is hit, set gotDigit to false again as well as setting skipCharCount to 0 again.            

- Repeat the above steps until the buffer is no longer full (curr>= BUFFSIZE), in which case simply refill the buffer by reading from file into the buffer again.

- Should be the bulk of this function.

---
---
`writeString():`

- Refer to printString code as they are really similar

- Main difference is the output stream to which we are writing. 
      
- While printString used STDOUT we will be using the wrFileDesc.

- Not really all too much to it. Just refer to printString from past assignments.

- Only other extra tidbit is that if we run into an error while writing to a file, exit after printing an error message.

    - Check after calling SYS_write if rax < 0. If so there was an error while writing to the outputFile so display appropriate message and exit function. No returning of true or false necessary in this function.

    - If there was no error, then just continue with the function as 
normal. Has a lot to do with just looking at printString and adapting it appropriately.

`ARGUMENTS:`
  - rdi : File descriptor, value. To be set as rdi when making SYS_write syscalls.

  - rsi : Address of the string to be written. To be set as rsi when calling SYS_write syscalls.

---
`int2aBin(): `DONE!
Basically just store, from right to left, the remaining 'bit' from dividing the passed integer by 2 over and over (32 times total, to be exact).
     
Before doing that just make the 33rd char a NULL char. That would be rsi + 32 which should just be rsi+r10 assuming I init r10 to 32.
      Very simple function.


The input files will be specially formatted.  **The first 5 lines will be header information, and the first 7 characters of each line will be title characters (that mustbe skipped).**  Each number wil lbe of different size.  You need only check for the first digit.You do not have to handle files that do not conform.  You will be provided a series of example files for testing.  Additionally, the output graph should follow the provide example (with thebinary counts)

---
`Read / Check parameters (file names) from the Command Line:`

- Must display errror messages
- All error msgs provided!
- A pringString(str) function is proviced
- Erorr check file name? : 
  - **Attempt** to open it: 
    - if succesful --> its okay
    - if fasle     --> error
- If open --> Return the file descriptor
-  Check for -d specifier

---
---
FROM THIS ONWARD IS STUFF I GOT FROM THE LECTURE - DREAMS

;  *` Function - getArguments()` 

if argc = 1 -> jmp usageMsg

if argc != 5 ||6 jmp error

if argv[1] != '-i', NULL --> iErorr

if argv[2] != open --> openError

if argv[3] != '-o', NULL --> openCreateError

if argv[4] != open --> oError

if argc == 6 --> jmp check argv[5]: 

if argv[5] != '-d', NULL --> dError

ASSUME EVERYTHING WENT WELL --> set displayToScreen == TRUE

ELSE, ERROR MSGS PORTION --> SET TO FALSE

---
; ` * Function - countDigits()`

Algorithm:

```x86asm
        header = true
    hdrLinecnt = 0
        ChrCnt = 0

         found = false
       currIdx = BUFFSIZE
       buffMax = BUFFSIZE

getNextChr:
    if (currIdx >= buffMax) 
    {   `// as soon as bufferMax is reached
         // read the file, then we set the currIdx back to the beginner
         // of the buffer`

        read file
        currIdx = 0
    }
    char = buffer[currIdx]
    currIdx+

    if (header) 
    {   `// header will execute 1 since we ignore
         // first 5 lines, 7 chars`
        
        if (char == LF) { hedLineCnt++ }

        if (hdrLinecnt == SKIP-LINES) { header = false}

        jmp getNextChr
    }

    if (ChrCnt < SKIP_CHARS) 
    {   `// character count is higher than SKIP_CHARS
         // Can't process bad data, oopsie
         // until it become FALSE, it won't be execute 
         // anymore, like header`

        ChrCnt++ 
        
        if (char == LF) --> error

        jmp getNextChr
    }

    if (!gotDigit)
    {
        if (chr == SPACE)
        {
            if (chr == LF) { error = TRUE }
            
            jmp getNextChr
        }

        if (char digit ("0" ... "9"))
        {   
            int = chr - "0"         mov r11, 0
            count[int]++            mov r11b, chr
            gotDigit = true            sub r11b, "0"
            jmp getNextChr          mov dword[r15+r11*4]
        }
            

        if (chr == LF)
        {
            gotDigit = false
            ChrCnt = 0
        }

        jmp getNextChr 
    }

```

---
BUFFERRED INPUT: SECOND READ
```x86asm
           eof = false
        header = true
    hdrLinecnt = 0
        ChrCnt = 0

         found = false
       currIdx = BUFFSIZE
       buffMax = BUFFSIZE

getNextChr:
    if (currIdx >= BUFFSIZE)
    {
        if (eof) { return }
        
        read file (BUFFSIZE chrs)

        if (read errors)
        {
            display error msgs
            return
        }

        if (actualRd < requestRd)
        {
            eof = true
            buffMax = actualRd
        }

        currIdx = 0
    }

```