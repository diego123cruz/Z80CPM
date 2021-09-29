;*********************************************************
; begin.asm  -a skeletal program to handle stacks, program
;   startup, stack cleanup before exit, with some
;   utilatarian basic built-in functions.
; use: rmac begin <cr> -if ok,then- link begin <cr> 
; if your using the cp/m emulator 22NICE on your DOS
; machine, don't forget the next step -
; GENCOM begin DIS=VT-52.
;  ASEG directive at org needed for rmac to assemble 
;  correctly for link.
;  ref. "cp/m techniques" by Ken Barbier 1984 
; Steve Dubrovich sjdubrovich@internetni.com 9/1/97
;  8080 coding
;*********************************************************

; ASCII CHARACTERS

CR      EQU      0Dh      ; CARRIAGE RETURN
LF      EQU      0Ah      ; LINE FEED
CTRLZ   EQU      1Ah      ; OPERATOR INTERRUPT

; CP/M FUNCTIONS AND ADDRESSES

RCONF   EQU      1        ; READ CON: INTO (A)
WCONF   EQU      2        ; WRITE (A) TO CON:
CSTAF   EQU      11       ; CHECK CON: STATUS
PSTR    EQU      9        ; PRINT STRING WITH $ TERMINATOR
;
DRIVE   EQU      4        ; CURRENT DRIVE NUMBER {V2.2}
LDRIV   EQU      50h      ; [v3.0] LAST LOGGED DRIVE
SYSFN   EQU      5        ; SYSTEM CALL ENTRY (BDOS)
TBUFF   EQU      80h      ; TRANSIENT DEFAULT BUFFER

ASEG                    ; this directive req'd for RMAC
	ORG      100h     ; START OF TRANS. PROGRAM AREA

BEGIN:  LXI      H,0      ; SAVE CP/M STACK 
	DAD      SP
	SHLD     CPMSP
	LXI      SP,STAK  ; SET UP LOCAL STACK
	LDA      DRIVE    ; SAVE CURRENT DISK
	STA      DRSAV
	MVI      C,CSTAF  ; CHECK CONSOLE STATUS
	CALL     SYSFN    ; FOR ANY INPUT
	ORA      A
	JZ       BEGIN1   ; CONTINUE IF NONE
	MVI      C,RCONF  ; READ AND IGNORE CON:
	CALL     SYSFN    ; (DEBOUNCE KEYS)
BEGIN1: CALL     CCRLF
	CALL     SPMSG    ; SIGN-ON MESSAGE
	DB       'BEGINING vers. .ALPHA ',0
	CALL     CCRLF
	JMP      START    ; RUN THE PROGRAM

; COMMON SUBROUTINES

; MESSAGE POINTED TO BY STACK OUT TO CONSOLE
;  note: this function requires a null to 
;  end the string [as above]
SPMSG:  XTHL              ; GET "RETURN ADDRESS" TO HL
	XRA      A        ; CLEAR FLAGS AND ACCUMULATOR
	ADD      M        ; GET ONE MESSAGE CHARACTER
	INX      H        ; POINT TO NEXT
	XTHL              ; RESTORE STACK FOR
	RZ                ; RETURN IF DONE
	CALL     CO       ; ELSE DISPLAY CHARACTER
	JMP      SPMSG    ; AND DO ANOTHER

; CARRIAGE RETURN, LINE FEED TO CONSOLE
TWOCR:  CALL     CCRLF
CCRLF:  MVI      A,CR
	CALL     CO
	MVI      A,LF
; FALL THROUGH INTO CO: [SINGLE CHARACTER OUTPUT]

CO:     PUSH     B        ; SAVE REGISTERS
	PUSH     D
	PUSH     H
	MVI      C,WCONF  ; SELECT FUNCTION
	MOV      E,A      ; CHARACTER TO E
	CALL     SYSFN    ; OUTPUT BY CP/M
	POP      H
	POP      D
	POP      B
	RET

; SHOW SPACES = CONTENTS OF A

SPACES: PUSH     B        ; SAVE TEMPORARY REGISTER
	MOV      C,A      ; FOR COUNT
	ORA      A        ; TEST FOR NONE
	JZ       SPACE2   ; QUIT IF DONE
SPACE1: MVI      A,' '    ; SHOW A SPACE
	CALL     CO
	DCR      C        ; COUNT DOWN
	JNZ      SPACE1   ; SHOW MORE TIL ZERO
SPACE2: POP      B        ; RESTORE
	RET               ; and return

; CONSOLE OPERATOR INTERRUPT

OPINT:  MVI      C,CSTAF  ; CHECK FOR OPERATOR
	CALL     SYSFN    ; INTERRUPT = CTRL Z
	ORA      A
	RZ                ; RETURN IF DONE
	MVI      C,RCONF  ; CHARACTER AVAILABLE
	CALL     SYSFN    ; READ IT IN
	CPI      CTRLZ    ; ABORT PROGRAM IF
	RNZ               ; ELSE RETURN TO PROGRAM

; FALL THROUGH TO END-OF-PROGRAM ROUTINE

; END OF PROGRAM EXECUTION

DONE:   LDA      DRSAV    ; RESTORE "CURRENT" DISK
	STA      DRIVE
	LHLD     CPMSP    ; RESTORE CP/M STACK
	SPHL
	RET               ; RETURN TO CP/M

; LOCAL STORAGE

DRSAV   DB       0        ; CURRENT DRIVE NUMBER
CPMSP   DW       0        ; CP/M STACK POINTER
	ORG      200h
STAK:                     ; LOCAL STACK TOP
;-------------------------
; BEGIN USER PROGRAM AREA - Your coding section,
; START:                    ; PROGRAM FOLLOWS HERE
;  this stuff is just my example to show the output
;  string function.  If you add additional functions
;  to this program skeleton (above), watch that the
;  program stack area has enough room leftover.
;
; LOCAL DATA string for fn 9 -_$_ is str terminator 
MSGA    DB      'This is a test of PSTR using BDOS FN 9 $'
; LOCAL CODE 
START:                    ; PROGRAM FOLLOWS HERE
	CALL    TWOCR     ; advance print line
	LXI     D,MSGA    ; DE gets addr of our msg
	MVI     C,PSTR    ; for fn call, C gets fn number
	CALL    SYSFN     ; call BDOS print str fn
	CALL    CCRLF
;
;
;
;
; END USER PROGRAM AREA - end of your code
;-------------------------
EXIT:           ;       RET THRU JP DONE:
	JP      DONE
;
; compiler directive -
	END     0100h           ; Load Addr Required
;EOF
