; =================================================
;					Delay
;	A program which toggles a LED on and off once
; 	every 1 second.
; =================================================

; Load the constants defined for this architecture
.INCLUDE "../resources/m328Pdef.inc"

; At origin 0x00, hook in our calls to our program
; something else should be done here later
.ORG 0x0000
	jmp main

; registers are used to quickly create bitmasks
; which will correctly configure the ports and
.DEF input_config_bitmask_register = R17
.DEF port_config_bitmask_register = R16
.DEF delay_reg1 = R20
.DEF delay_reg2 = R21
.DEF delay_reg3 = R22

main: 
	; Use PortB pin 5 and pin 3 as output (which should have the 13 and 11 ID on the arduino)
	; pulls up all resistors and sets the output to high
	LDI port_config_bitmask_register, (1<<DDB5) | (1<<DDB3)
	OUT DDRB, port_config_bitmask_register
	CBI DDRB, 4 ; set pin 4 to 0 = input
	CBI PORTB, 5
	CBI PORTB, 3

program_loop:
	CBI PORTB, 3
	SBIS PINB, 4 ; If input to pin 4 is 1, run loop, else, go to beginning
	RJMP program_loop	

	SBI PORTB, 3
	
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
