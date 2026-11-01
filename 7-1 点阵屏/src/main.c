#include<REGX52.H>
#include<INTRINS.H>

sbit RCK=P3^5;
sbit SRCK=P3^6;
sbit SER=P3^4;


unsigned char mirror_bits(unsigned char b)//翻转列
{
    unsigned char r = 0,i;
    for (i = 0; i < 8; i++)
    {
        r = (r << 1) | (b & 0x01);   /* 取 b 的最低位，塞进 r 的最低位 */
        b = b >> 1;                  /* b 右移，把下一位露出来 */
    }
    return r;
}

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

void write_74HC595(unsigned char Byte){//写入LED矩阵行数据
    unsigned char i;
    for(i=0;i<8;i++){
        SER= (Byte >> i) & 0x01;
        SRCK=1;//入队
        SRCK=0;
    } 
    RCK=1;
    RCK=0;
}

void show_MatrixLED(unsigned char row,unsigned char col){
    write_74HC595( 0x80>>row );
    P0=~mirror_bits(col);
    DelayXms(1);
    P0=0XFF;
} 

void main(){
    unsigned char i=0;
    unsigned int tick=0;
    bit flag=0;
    bit key_last=1;
    ///P2_5=1;//关闭蜂鸣器 蜂鸣器响的原因：LED扫描施加了一个脉冲电流
    SRCK=0;
    RCK=0;
    while(1){
        //LED点阵
        show_MatrixLED(0,0XFF);
        show_MatrixLED(1,0X83);
        show_MatrixLED(2,0XA5);
        show_MatrixLED(3,0X89);
        show_MatrixLED(4,0X91);
        show_MatrixLED(5,0XA5);
        show_MatrixLED(6,0XC1);
        show_MatrixLED(7,0XFF);

        //按键控制流水灯
        if( P3_1==0 && key_last==1 ){
            DelayXms(10);
            if( flag==0 ){//没在跑
                flag=1;
                
            }
            else{
                flag=0;
                P2=0xFF;
            }
        }
        key_last=P3_1;
    
        if(flag==1){
            tick = tick + 10;
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