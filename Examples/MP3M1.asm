SIOA_D		.EQU	$00
SIOA_C		.EQU	$02
SIOB_D		.EQU	$01
SIOB_C		.EQU	$03

KEY         .EQU    $60

lcd_comm_port .equ $50
lcd_data_port .equ $51

.org 100h

    CALL INIT_LCD
    CALL INIT_CONSOLE

MAIN:
    in A, (KEY)
    bit 0, A
    JP  Z, PAUSE

    bit 1, A
    JP  Z, V_MAIS

    bit 2, A
    JP  Z, NEXT

    bit 3, A
    JP  Z, V_MENOS

    bit 4, A
    JP  Z, PREV

    bit 5, A
    JP  Z, PLAY

    bit 6, A
    JP  Z, REPEAT_ALL

    bit 7, A
    JP  Z, STOP_ALL

; -----------------------------------------------------
; Console input
; -----------------------------------------------------
    ld  c, 0Bh ; read status serial
    CALL 0005h
    cp  0
    JP  Z, MAIN

    ld  c, 01h ; read serial, while(read != nil)
    CALL 0005h

    cp  '1'
    JP  Z, PLAY

    cp  '2'
    JP  Z, PAUSE

    cp  '3'
    JP  Z, NEXT

    cp  '4'
    JP  Z, PREV

    cp  '5'
    JP  Z, V_MAIS

    cp  '6'
    JP  Z, V_MENOS

    cp  '7'
    JP  Z, REPEAT_ALL

    cp  '9'
    JP  Z, STOP_ALL

    JP MAIN


EXIT:
    CALL delay
    CALL delay
    CALL delay
    CALL delay
    CALL delay

    ld a,lcd_cls
	call lcd_send_command
    JP  0

; -----------------------------------------------------
; Local console
; -----------------------------------------------------
INIT_CONSOLE:
    ld  c, 09h
    ld  de, INFO
    CALL    0005h
    

    ret

INFO:   
        .DB      12
        .DB      "MP3 Player - "
        .DB      "DIEGO CRUZ 10/2021", 13, 10
        .DB      "Modulo: FN-M16P-MP3", 13, 10
        .DB      13, 10
        .DB      "1 - Play", 13, 10
        .DB      "2 - Pause", 13, 10
        .DB      "3 - Next", 13, 10
        .DB      "4 - Prev", 13, 10
        .DB      "5 - Vol +", 13, 10
        .DB      "6 - Vol -", 13, 10
        .DB      "7 - Repeat all", 13, 10
        .DB      "8 - N/D", 13, 10
        .DB      "9 - Stop / Exit", 13, 10, '$'









STOP_ALL:
    ld hl, S_STOP
    CALL    LCD_SEND
    ld  c, $16 ; stop
    CALL SEND_COMMAND
    JP  EXIT


REPEAT_ALL:
    ld hl, S_REPETE
    CALL    LCD_SEND
    ld  c, $11 ; REPET ALL
    CALL SEND_COMMAND_P1
    JP  MAIN

PLAY:
    ld hl, S_PLAY
    CALL    LCD_SEND
    ld  C, $0D          ; command play
    CALL SEND_COMMAND
    JP  MAIN

PAUSE:
    ld hl, S_PAUSE
    CALL    LCD_SEND
    ld  C, $0E          ; command pause
    CALL SEND_COMMAND
    JP  MAIN

NEXT:
    ld hl, S_NEXT
    CALL    LCD_SEND
    ld  C, $01          ; command next
    CALL SEND_COMMAND
    JP  MAIN

PREV:
    ld hl, S_PREV
    CALL    LCD_SEND
    ld  C, $02          ; command prev
    CALL SEND_COMMAND
    JP  MAIN

V_MAIS:
    ld hl, S_VOL_MAIS
    CALL    LCD_SEND
    ld  C, $04          ; command volume mais
    CALL SEND_COMMAND
    JP  MAIN

V_MENOS:
    ld hl, S_VOL_MENOS
    CALL    LCD_SEND
    ld  C, $05          ; command volume menos
    CALL SEND_COMMAND
    JP  MAIN

; COMMAND IN C
SEND_COMMAND_P1:

    ; calc checksum, return in HL
    ld  b, $0
    ld  hl, $106

    ; soma comando com a constant in hl
    add hl, bc

    ; FFFF - HL
    ld  A, $FF
    sub H
    ld  h, A

    ld  A, $FF
    sub L
    ld  L, A

    ; hl + 1
    ld  d, $0
    ld  e, $1
    add hl, de
    ; ----------------------------------


    ld  A, $7E          ; start
    CALL conoutB

    ld  A, $FF          ; version
    CALL conoutB

    ld  A, $06          ; len
    CALL conoutB

    ld  A, C          ; command in C
    CALL conoutB

    ld  A, $00          ; feedback
    CALL conoutB

    ld  A, $00          ; 
    CALL conoutB

    ld  A, $01          ; 
    CALL conoutB

    ld  A, H          ; checksum
    CALL conoutB

    ld  A, L          ; checksum
    CALL conoutB

    ld  A, $EF          ; end
    CALL conoutB
    JP  RET_MAIN


; COMMAND IN C
SEND_COMMAND:

    ; calc checksum, return in HL
    ld  b, $0
    ld  hl, $105

    ; soma comando com a constant in hl
    add hl, bc

    ; FFFF - HL
    ld  A, $FF
    sub H
    ld  h, A

    ld  A, $FF
    sub L
    ld  L, A

    ; hl + 1
    ld  d, $0
    ld  e, $1
    add hl, de
    ; ----------------------------------


    ld  A, $7E          ; start
    CALL conoutB

    ld  A, $FF          ; version
    CALL conoutB

    ld  A, $06          ; len
    CALL conoutB

    ld  A, C          ; command in C
    CALL conoutB

    ld  A, $00          ; feedback
    CALL conoutB

    ld  A, $00          ; 
    CALL conoutB

    ld  A, $00          ; 
    CALL conoutB

    ld  A, H          ; checksum
    CALL conoutB

    ld  A, L          ; checksum
    CALL conoutB

    ld  A, $EF          ; end
    CALL conoutB
    JP  RET_MAIN




RET_MAIN:
    call    delay
    call    delay
    call    delay
    call    delay
    call    delay
    ld hl, S_EMPTY
    CALL    LCD_SEND
    CALL    INIT_CONSOLE
    RET




; ===================================================================
; DISPLAY LCD
; ===================================================================
lcd_set_8bit        .EQU    $3f	; 8-bit port, 2-line display
lcd_cursor_on       .EQU    $0f	; Turn cursors on
lcd_cls             .EQU    $01 ; Clear the display
lcd_line2           .EQU    $C0 ; Force cursor to beginning (2nd line)
lcd_dispOnCurOff    .EQU    $0C ; Display On, Cursor Off

LCD_SEND:
    PUSH    AF
    ld a, lcd_line2
	call lcd_send_command
    POP     AF
	call lcd_send_asciiz
    RET

	
INIT_LCD:
	;Initialisation
	ld a,lcd_set_8bit
	call lcd_send_command
	
	ld a,lcd_cursor_on
	call lcd_send_command
	
	ld a,lcd_cls
	call lcd_send_command

    ld a, lcd_dispOnCurOff
	call lcd_send_command
	
	;Send a string
	ld hl, hello
	call lcd_send_asciiz
	
	ret
	
hello:
	.db "   MP3 Player   ", 0

S_EMPTY:
    .db "                ", 0

S_PLAY:
	.db "      Play      ", 0

S_PAUSE:
    .db "      Pause     ", 0

S_NEXT:
    .db "      Next      ", 0

S_PREV:
    .db "      Prev      ", 0

S_VOL_MAIS:
    .db "      Vol +     ", 0

S_VOL_MENOS:
    .db "      Vol -     ", 0

S_STOP:
    .db " Stop, See you! ", 0

S_REPETE:
    .db "   Repeat all   ", 0
	
	
;******************
;Send a command byte to the LCD
;Entry: A= command byte
;Exit: All preserved
;******************
lcd_send_command:
	push bc				;Preserve
	ld c,lcd_comm_port	;Command port
	
lcd_command_wait_loop:	;Busy wait
	in b,(c)			;Read status byte
	rl b				;Shift busy bit into carry flag
	jr c,lcd_command_wait_loop	;While busy
	
	out (c),a			;Send command
	pop bc				;Restore
	ret
	
;******************
;Send a data byte to the LCD
;Entry: A= data byte
;Exit: All preserved
;******************
lcd_send_data:
	push bc				;Preserve
	ld c,lcd_comm_port	;Command port
	
lcd_data_wait_loop:	;Busy wait
	in b,(c)			;Read status byte
	rl b				;Shift busy bit into carry flag
	jr c,lcd_data_wait_loop	;While busy
	
	ld c,lcd_data_port	;Data port
	out (c),a			;Send data
	pop bc				;Restore
	ret
	
;******************
;Send an asciiz string to the LCD
;Entry: HL=address of string
;Exit: HL=address of ending zero of the string. All others preserved
;******************
lcd_send_asciiz:
	push af
	push bc				;Preserve
lcd_asciiz_char_loop
	ld c,lcd_comm_port	;Command port
	
lcd_asciiz_wait_loop:	;Busy wait
	in a,(c)			;Read status byte
	rlca				;Shift busy bit into carry flag
	jr c,lcd_asciiz_wait_loop	;While busy
	
	ld a,(hl)			;Get character
	and a				;Is it zero?
	jr z,lcd_asciiz_done	;If so, we're done
	
	ld c,lcd_data_port	;Data port
	out (c),a			;Send data
	inc hl				;Next char
	jr lcd_asciiz_char_loop
	
lcd_asciiz_done:
	pop bc				;Restore
	pop af
	ret
.end 

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

; ===================================================================
; SERIAL B
; ===================================================================
conoutB:
		PUSH	AF

conoutB1:	CALL	CKSIOB		; See if SIO channel B is finished transmitting
		JR	Z,conoutB1	; Loop until SIO flag signals ready
		POP	AF		; RETrieve character
		OUT	(SIOB_D),A	; OUTput the character
		RET


CKSIOB
		SUB	A
		OUT 	(SIOB_C),A
		IN   	A,(SIOB_C)	; Status byte D2=TX Buff Empty, D0=RX char ready	
		RRCA			; Rotates RX status into Carry Flag,	
		BIT  	1,A		; Set Zero flag if still transmitting character	
        	RET

.end 
