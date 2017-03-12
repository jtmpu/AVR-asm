; =================================================
;					Delay
;	A program which toggles a LED on and off once
; 	every 1 second.
; =================================================

; Load the constants defined for this architecture
.INCLUDE "../../extra_avra_includes/m328Pdef.inc"

; At origin 0x00, hook in our calls to our program
; something else should be done here later
.ORG 0x0000
	jmp main

; registers are used to quickly create bitmasks
; which will correctly configure the ports and
.DEF port_config_bitmask_register = R16
.DEF delay_reg1 = R20
.DEF delay_reg2 = R21
.DEF delay_reg3 = R22

main: 
	; Use PortB pin 4 as output (which should have the 13 ID on the arduino)
	; pulls up all resistors and sets the output to high
	;sbi DDRB, 4
	;sbi PORTB, 4; Sets pin 4 high
	ldi port_config_bitmask_register, (1<<DDB5)
	out DDRB, port_config_bitmask_register
	ldi R18, (1<<DDB5)
	out PORTB, R18

program_loop:
	SBI PORTB, 5
	CALL delay_start
	CBI PORTB, 5
	CALL delay_start
	rjmp program_loop	

; Delay 1 second, 16MHz processor speed
; 1 instruction per cycle
; 16 000 000 instructions per second
; we need to wase 16 000 000 instructions
; 3 nested loops
; 250 * 4 = 1000 cycles
; 250 * 1000 = 250 000 cycles
; 250 000 * 64 = 16 000 000 cycles
; three nested loops perform 16M cycles
delay_start:	
	LDI delay_reg1, 64
delay_l1:
	LDI delay_reg2, 250
delay_l2:
	LDI delay_reg3, 250
delay_l3:
	DEC delay_reg3 	; one clock cycle
	NOP				; one clock cycle	
	BRNE delay_l3	; Two clock cycles

	DEC delay_reg2
	BRNE delay_l2

	DEC delay_reg1
	BRNE delay_l1
	
	RET

; A program must never terminate, jst keep looping forever.
idle_loop:
	rjmp idle_loop
