#include <REGX52.H>
#include <intrins.h>

void DelayXms(unsigned int x)		//@11.0592MHz
{
	unsigned char i, j;
	while(x--)
	{
			_nop_();
		i = 2;
		j = 199;
		do
		{
			while (--j);
		} while (--i);
	}
	
}


void main()
{
	while(1)
	{	
		P2=0x7F;
		DelayXms(500);
		P2=0xBF;
		DelayXms(500);
		P2=0xDF;
		DelayXms(500);
		P2=0xEF;
		DelayXms(500);
		P2=0xF7;
		DelayXms(500);
		P2=0xFB;
		DelayXms(500);
		P2=0xFD;
		DelayXms(500);
		P2=0xFE;
		DelayXms(500);
		
	}
}