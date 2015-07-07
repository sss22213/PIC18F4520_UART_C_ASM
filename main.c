#include<pic18.h>
#include<math.h>
#include<stdlib.h>
//#include<stdio.h>
volatile int RX=0;
volatile int RX_H=0;
volatile int RX_L=0;
volatile int data[]="0x00","0x01";
int HCF(int,int);


#pragma code UART = 0x08
static void interrupt UART (void)
{

	RX=0;
	RCREG=0;
	RX=RCREG;
	if(RX>0x80)
	{	
		//指令碼 與 操作碼 分析
		RX_H=RX & 0xF0;
		RX_L=RX	& 0x0F;
		PORTB=RX_H;

	}
	TXREG=0;
	TXREG=RX;

	
	
	TXIF=0;
	RCIF=0;
}
void rsa_decode(void)
{
	int	p=0;
	int q=0;
	p=(rand() % 10)+1;
	q=(rand() % 10)+1;
	//HCF=1
	if(p==q)
	{
		rsa_decode();
	}
	
	if(HCF(p,q)!=1)
	{
		rsa_decode();
	}
}
int HCF(int p,int q)
{
	int temp;
   	while(p%q)
      {
         temp=p;
         p=q;
         q=temp%p;
      }
  	 return q;
}
#pragma code main = 0x00
void main(void)
{
	//init_UART

	TRISC=0b10111111;
	TXSTA=0b00100000;
	RCSTA=0b10010100;
	SPBRG=25; 
	//init_interrupt
	TXIF=0;
	TXIE=0;
	RCIP=1;
	RCIF=0;
	RCIE=1;
	IPEN=1;
	GIEH=1;
	//init_MOTO
	TRISB=0x00;
	PORTB=0x00;
	
	while(1)
	{
		
	}
}


