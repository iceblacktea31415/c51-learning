#include<regx52.h>
#include<INTRINS.H>

void DelayXms(unsigned int x)		//@11.0592MHz
{
	unsigned char i, j;
	while(x--){
		_nop_();
		i = 2;
		j = 199;
		do
		{
			while (--j);
		} while (--i);
	}
	
}

void main(){
    //P2=0xFE;
    int i,flag=0;
    while(1){
        if( P3_1==0 ){
            P2=0XFE;
        }
        else{
            P2=0xFF;
        }
    }
}