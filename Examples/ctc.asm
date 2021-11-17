CTC_0      =       08h

.org 8000h

    ld      A, 55h
    out     (CTC_0), A

    ld      A, 06h
    out     (CTC_0), A

main:

    JP      main

.end 
