      .include "utils.inc"
      .include "lcd.inc"
      .include "core.inc"
      .include "acia.inc"
      .include "syscalls.inc"

      .export init_basic

.segment "CODE"
; ISCNTC:
;         jmp     MONISCNTC
;         nop
;         nop
;         nop
;         nop
;         lsr     a
;         bcc     RET2
;         jsr     GETLN
;         cmp     #$03
ISCNTC:
          jmp MONISCNTC
;!!! *used*to* run into "STOP"

init_basic:

      ldx #$ff
      txs

      jsr _system_init

      write_lcd #ms_basic
      ldx #$00
      ldy #$01
      jsr lcd_set_position
      ;write_lcd #ms_copyright
      ;ldx #$00
      ;ldy #$03
      ;jsr lcd_set_position
      write_lcd #my_copyright

      lda #(TTY_CONFIG_INPUT_SERIAL | TTY_CONFIG_OUTPUT_SERIAL)
      jsr _tty_init

      ; lda #(ACIA_PARITY_DISABLE | ACIA_ECHO_DISABLE | ACIA_TX_INT_DISABLE_RTS_LOW | ACIA_RX_INT_DISABLE | ACIA_DTR_LOW)
      ; sta ACIA_COMMAND
      ; lda #(ACIA_STOP_BITS_1 | ACIA_DATA_BITS_8 | ACIA_CLOCK_INT | ACIA_BAUD_19200)
      ; sta ACIA_CONTROL

; Display startup message
ShowStartMsg:
      writeln_tty #StartupMessage
	; LDA	StartupMessage,Y
	; BEQ	WaitForKeypress
	; JSR	MONCOUT
	; INY
	; BNE	ShowStartMsg

; Wait for a cold/warm start selection
WaitForKeypress:
      JSR	MONRDKEY
      BCC	WaitForKeypress

      AND	#$DF			; Make upper case
      CMP	#'W'			; compare with [W]arm start
      BEQ	WarmStart
      CMP	#'C'			; compare with [C]old start
      BNE	ShowStartMsg
      JMP	COLD_START	; BASIC cold start

WarmStart:
     	JMP	RESTART		; BASIC warm start

MONCOUT:
;	PHA
; SerialOutWait:
; 	LDA	ACIA_STATUS
; 	AND	#ACIA_STATUS_TX_EMPTY
; 	BEQ	SerialOutWait
; 	PLA
; 	STA	ACIA_DATA
    jsr _tty_send_character
	RTS

MONRDKEY:
; 	LDA	ACIA_STATUS
; 	AND	#ACIA_STATUS_RX_FULL
; 	BEQ	NoDataIn
; 	LDA	ACIA_DATA
; 	SEC		; Carry set if key available
; 	RTS
; NoDataIn:
; 	CLC		; Carry clear if no key pressed
  jsr _acia_is_data_available
  ; skip, no data available at this point
  cmp #(ACIA_NO_DATA_AVAILABLE)
  beq NoDataIn
  jsr _acia_read_byte
  sec
  rts
NoDataIn:
  clc
	RTS

MONISCNTC:
	JSR	MONRDKEY
	BCC	NotCTRLC ; If no key pressed then exit
	CMP	#3
	BNE	NotCTRLC ; if CTRL-C not pressed then exit
	SEC		; Carry set if control C pressed
	RTS
NotCTRLC:
	CLC		; Carry clear if control C not pressed
	RTS

; SEND_BACKSPACE:
;   PHA
;   PHX
;   LDX #$FF
; BackspaceLoop:
;   INX
;   LDA Backspace,X
;   BEQ BackspaceLoopEnd
;   JSR MONCOUT
;   BNE BackspaceLoop
; BackspaceLoopEnd:
;   PLX
;   PLA
;   RTS

StartupMessage:
	.byte	$0C,"Cold [C] or Warm [W] start?",$0D,$0A,$00

Backspace:
  .byte $1B,"[D ",$1B,"[D",$00

ms_basic:
  .asciiz "65C02 BASIC V1.2"

ms_copyright:
  .asciiz "(c) 1977 Microsoft"

my_copyright:
  .asciiz "(c) 2023 RProuse"

not_implemented:
  .asciiz "NOT IMPLEMENTED"

; TODO: Figure out how to implement these commands
LOAD:
  writeln_tty #not_implemented
  rts

SAVE:
  writeln_tty #not_implemented
  rts

SYS:
  jsr     FRMNUM      ; Convert EXP1 to 16-bit number into LINNUM
  jsr     GETADR
  jmp     (LINNUM)

.ifdef SPARK64
BYE:
  jmp init_os

.else ; SPARK64
.segment "VECTORS"

.word   $0000
.word   init_basic
.word   _interrupt_handler
.endif