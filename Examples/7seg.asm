C_PIO_A     =       71h
D_PIO_A     =       70h
C_PIO_B     =       73h
D_PIO_B     =       72h

.org 8000h
    ld      SP, $

    ; --------------------- output mode PIO --------------
    ld      A, 0Fh
    out     (C_PIO_A), A

    ld      A, 0Fh
    out     (C_PIO_B), A
    
;;  --------------------------------------------------------
;;      MAIN
;;  --------------------------------------------------------
    

main:
    ld      hl, digitos
    ld      b, 255
    call    beep
    call    beep
    call    beep
    call    beep
next
    ld      a, (hl)
    cp      0
    JP      z, main
    ld      b, 5
    call    beep
    out     (D_PIO_A), a
    out     (D_PIO_B), a
    call    delay
    call    delay
    call    delay
    call    delay
    inc     hl
    JP      next




digitos:
    .db $3F, $06, $5B, $4F, $66, $6D, $7D, $07, $7F, $6F ; 0 - 9
    .db $77, $7C, $39, $5E, $79, $71, 0 ; A - F


;;  --------------------------------------------------------
;;      BEEP duracao in B
;;  --------------------------------------------------------
beep:
    push    af
    push    bc
    ld  a,  b
beep_loop:
    dec     a
    cp      0
    JP      z, beep_end

    ld      c, D_PIO_A
    ld      b, $80   
    out     (c), b
    ld      c, D_PIO_B
    out     (c), b

    call    delay_beep

    ld      c, D_PIO_A
    ld      b, $00
    out     (c), b
    ld      c, D_PIO_B
    out     (c), b
    call    delay_beep
    JP      beep_loop

beep_end:
    pop     bc
    pop     af
    ret


; ===================================================================
; DELAY BEEP
; ===================================================================
delay_beep:
	push bc
    ld b, 1
delay_loop_b_beep:
	ld c, 50
delay_loop_beep:
	dec c
    jp nz, delay_loop_beep
    dec b
    jp nz, delay_loop_b_beep
    pop bc
    ret


; ===================================================================
; DELAY
; ===================================================================
delay:
	push bc
    ld b, 255
delay_loop_b:
	ld c, 255
delay_loop:
	dec c
    jp nz, delay_loop
    dec b
    jp nz, delay_loop_b
    pop bc
    ret


.end 
