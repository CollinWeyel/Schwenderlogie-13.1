;-------------------------------------------------------------------------------
; PROJEKT: DREHREGLER
; erstellt von Collin Weyel und Noah Graetz
;-------------------------------------------------------------------------------
.INCLUDE "m8def.inc"
.CSEG
.ORG		0x0000

RESET:
	RJMP	INIT
.ORG   	INT_VECTORS_SIZE

INIT:
	LDI		R16, HIGH(RAMEND)
	OUT		SPH, R16
	LDI		R16, LOW(RAMEND)
	OUT		SPL, R16

INIT_REGISTER:
	IN		R16, DDRD						; PORTD2 und PORTD3
	ANDI	R16, 0b11110011			; -> INPUT
	OUT		DDRD, R16
	IN		R16, PORTD					; PORTD2 und PORTD3
	ORI		R16, 0b00001100			; -> PULLUP
	OUT		PORTD, R16

	IN		R16, DDRB						; PORTB0, PORTB1 und PORTB2
	ORI		R16, 0b00000111			; -> OUTPUT
	OUT		DDRB, R16

	LDI		R16, 0b00000000
	SBI		PORTB, 2

MAIN:
	MOV		R18, R16
	IN		R16, PIND
	ANDI	R16, 0b00000100
	CP		R16, R18
	BREQ	MAIN
	CPI		R16, 0b00000100
	BREQ	MAIN

	IN		R18, PIND
	ANDI	R18, 0b00001000
	CPI		R18, 0b00000000

	IN		R18, PORTB
	CBI		PORTB, 0
	CBI		PORTB, 1
	CBI		PORTB, 2

	BREQ	CLOCKWISE

ANTICLOCKWISE:							; RED -> GREEN -> YELLOW -> ...
	SBRC	R18, 0
	SBI		PORTB, 2
	SBRC	R18, 1
	SBI		PORTB, 0
	SBRC	R18, 2
	SBI		PORTB, 1
	RJMP	MAIN

CLOCKWISE:									; RED -> YELLOW -> GREEN -> ...
	SBRC	R18, 0
	SBI		PORTB, 1
	SBRC	R18, 1
	SBI		PORTB, 2
	SBRC	R18, 2
	SBI		PORTB, 0
	RJMP	MAIN
	
.EXIT
