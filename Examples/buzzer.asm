C_PIO_A     =       71h
D_PIO_A     =       70h
C_PIO_B     =       73h
D_PIO_B     =       72h

.org 8000h
    ld      SP, $

    ; --------------------- output mode PIO-B --------------
    ld      A, 0Fh
    out     (C_PIO_B), A

    ld      A, 0Fh
    out     (C_PIO_A), A
    
;;  --------------------------------------------------------
;;      MAIN
;;  --------------------------------------------------------
    
main:
    ld      A, $ff   
    out     (D_PIO_A), A
    call    delay
    ld      A, $00
    out     (D_PIO_A), A
    call    delay
    JP      main

; ===================================================================
; DELAY
; ===================================================================
delay:
	push bc
    ld b, 1
delay_loop_b:
	ld c, 100
delay_loop:
	dec c
    jp nz, delay_loop
    dec b
    jp nz, delay_loop_b
    pop bc
    ret


.end 
