# 7-1 点阵屏

## 功能

用 **8×8 LED 点阵** 显示一幅固定图案，同时复用 `3-3` 的代码：按 K1 启停 P2 口的流水灯。

## 硬件连接

| 信号 | 引脚 | 作用 |
| --- | --- | --- |
| `SER` | P3.4 | 74HC595 串行数据输入 |
| `SRCK` | P3.6 | 移位时钟：上升沿把 SER 上的 1 位移进移位寄存器 |
| `RCK` | P3.5 | 锁存时钟：上升沿把 8 位移位寄存器并行送到输出端 |
| `P0` | P0 | 点阵列线（低电平选通） |

点阵用 **74HC595 串转并** 驱动行选，省下 8 个 IO：只需要 3 根线就能控制 8 路。

## 代码要点

**1. 向 595 写一个字节**

```c
void write_74HC595(unsigned char Byte){
    for(i=0;i<8;i++){
        SER  = (Byte >> i) & 0x01;   // 从最低位开始送
        SRCK = 1; SRCK = 0;          // 上升沿入队
    }
    RCK = 1; RCK = 0;                // 8 位凑齐后一次性输出
}
```

**2. 动态扫描 —— 点阵能显示的原理**

```c
void show_MatrixLED(unsigned char row, unsigned char col){
    write_74HC595( 0x80>>row );   // 选中第 row 行
    P0 = ~mirror_bits(col);       // 送出该行的 8 位列数据
    DelayXms(1);                  // 只亮 1ms
    P0 = 0XFF;                    // 消隐，防止拖影
}
```

主循环里 8 行轮流各显示 1ms，一帧约 8ms（>100Hz），人眼的**视觉暂留**把它合成一整幅图。

**3. `mirror_bits()` 修正镜像**

```c
unsigned char mirror_bits(unsigned char b){
    unsigned char r = 0, i;
    for (i = 0; i < 8; i++){
        r = (r << 1) | (b & 0x01);   // 摘 b 的最低位塞进 r 的最低位
        b = b >> 1;
    }
    return r;
}
```

因为 `write_74HC595` 是**低位先送**，图案左右会镜像，这个函数把 8 位翻转过来，让显示方向正过来。

## 遇到过的坑（记录在源码注释里）

- **蜂鸣器会跟着响**：动态扫描每 1ms 给列线一个大电流脉冲，经共用电源/引脚耦合进蜂鸣器。源码里那句 `//P2_5=1;//关闭蜂鸣器` 就是当时的尝试。

## 工程格式（EIDE）

VSCode + EIDE 插件打开 `p7_1.code-workspace` → 构建 → `build/Debug/p7_1.hex`。
换电脑记得改 `.eide/eide.yml` 里的 Keil 路径和串口（默认 `COM3`）。
