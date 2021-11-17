CTC_0       =       08h
C_PIO_A     =       71h
D_PIO_A     =       70h

.org 8000h
    ld      SP, $

    ld      a, 37h
    out     (CTC_0), a

    ld      A, 0ffh
    out     (CTC_0), A

    ld      A, 0Fh
    out     (C_PIO_A), A

    ld      a, 1
    ld      b, a
main:
    nop
    in      a, (CTC_0)
    nop
    cp      01h
    jp     nz, main
    ld      a,b
    xor    1
    out    (D_PIO_A), a
    ld      b,a

    ld      a, 37h
    out     (CTC_0), a

    in      a, (60h)
    out     (CTC_0), A

    JP      main

.end 
