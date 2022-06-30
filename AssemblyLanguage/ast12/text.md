
---
`numberTypeCounter()`

```cpp
numberTypeCounter(){
    // print thread start msg

    while (true) {
        // get #N to work on 
        //  if N > limit  --> exit function
        //  loop to sum divisors

        if (sum < N) 
            deficient++

        if (sum < N)
            abundant++

        if (sum = N)
            perfect++

    } 
}

```
---

X86Assemnly Code

```cpp

    ; copy to local variable/ register
    ; increment global
    mov rbx, qword[currentIdx]
    inc qword[currentIdx]

    ; Use lock, mutex lock
    call spinLock
    mov rbx, qword[currentIdx]
    inc qword[currentIdx]
    call spinUnlock

    ; For counters, even easier
    ; lock --> prefix for a few instruction
    lock inc qword[perfectCount]
    lock inc qword[abundantCount]
    lock inc qword[deficitCount]


```