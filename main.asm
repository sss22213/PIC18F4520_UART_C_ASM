	list p=18F4520
	#include "P18F4520.inc"
	CBLOCK	0x20
	RX01
	CounterA
	CounterB
	CounterC
	RX02
	ENDC

	ORG	0
	BRA	init
	ORG	0x08
	BRA	RX_TX
	
	ORG	0x2A
init

	MOVLW	0x00
	MOVWF	RX01

	BANKSEL	TRISB
	MOVLW	b'00000000'
	MOVWF	TRISB
	MOVLW	0x00
	MOVWF	PORTB
	
	BANKSEL	TRISC
	MOVLW	b'10111111'
	MOVWF	TRISC

	MOVLW	b'00100000'
	MOVWF	TXSTA

	MOVLW	b'10010100'
	MOVWF	RCSTA
	
	MOVLW	.25  	;about 9600bps
	MOVWF	SPBRG

	;TX設定
	BCF	PIR1,TXIF
	BCF	PIE1,TXIE

	;RX設定為高優先中斷
	BSF	IPR1,RCIP

	;清除中斷旗標
	BCF	PIR1,RCIF

	
	;開啟傳輸
	BSF	PIE1,RCIE

	;開啟中斷優先順序
	BSF	RCON,IPEN

	;開啟高優先中斷
	BSF	INTCON,GIEH
main
	
	GOTO	main

RX_TX
	CLRF	RX01
	MOVFF	RCREG,RX01
	CLRF	RCREG
	CLRF	TXREG
	MOVFF	RX01,TXREG
	NOP
	BTFSS	PIR1,TXIF
	BRA	$-4
	BCF	PIR1,TXIF
	BCF	PIR1,RCIF
	RETFIE	

Delay  
	movlw 0x15
 	movwf CounterC
 	movlw 0xD5
 	movwf CounterB
 	movlw 0xFF
 	movwf CounterA
loop 
	decfsz CounterA,1 
	goto loop         
	decfsz CounterB,1 
	goto loop         
	decfsz CounterC,1 
	goto loop         
	RETURN



	END