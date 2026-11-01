#include<regx52.h>
#include<INTRINS.H>

void DelayXms(unsigned x)	//@11.0592MHz
{
	unsigned char data i, j;

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
    unsigned int tick=0,i=0;
    bit flag=0;
    while(1){
        if( P3_1==0 ){
            DelayXms(10);
            while( P3_1==0 );
            DelayXms(10);
            if( flag==0 ){//没在跑
                flag=1;
                
            }
            else{
                flag=0;
                P2=0xFF;
            }
        }
    
        if(flag==1){
            tick = tick + 8;
            //DelayXms(10);
            if (tick >= 500){
                tick = 0;
                P2 = ~(1 << i);          /* 只有第 i 个 LED 亮 */
                i++;
                if (i >= 8){
                    i = 0;               /* 走完回到 D1，循环 */
                }
            }
        }
    }
}