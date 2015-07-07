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

	;TX�]�w
	BCF	PIR1,TXIF
	BCF	PIE1,TXIE

	;RX�]�w�����u�����_
	BSF	IPR1,RCIP

	;�M�����_�X��
	BCF	PIR1,RCIF

	
	;�}�Ҷǿ�
	BSF	PIE1,RCIE

	;�}�Ҥ��_�u������
	BSF	RCON,IPEN

	;�}�Ұ��u�����_
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