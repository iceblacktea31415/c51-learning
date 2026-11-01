# 2-4 LED 流水灯 Plus

## 功能

8 颗 LED 依次点亮，顺序是 **D8 → D1**（和 2-3 相反），每颗 500ms，循环。

## 代码要点

**1. 延时改成参数化**

```c
void DelayXms(unsigned int x)		//@11.0592MHz
{
	unsigned char i, j;
	while(x--)
	{
		_nop_();
		i = 2;   j = 199;
		do { while (--j); } while (--i);
	}
}
```

- 只保留两层循环，单次约 **1ms**，然后用 `while(x--)` 重复 x 次 → **`DelayXms(500)` 就是 500ms**。
- `unsigned int` 最大 65535，所以最长能等约 65 秒。
- 注释 `//@11.0592MHz`：这一版是按开发板实际的 **11.0592MHz** 晶振算的参数（对比 2-2/2-3 是按 12MHz 算的）。

**2. 流水方向反过来**

```c
P2=0x7F;  DelayXms(500);   // 0111 1111  → D8
P2=0xBF;  ...              // 1011 1111  → D7
...
P2=0xFE;  ...              // 1111 1110  → D1
```

那个 `0` 从最低位往最高位挪，所以是 D8 先亮、D1 后亮。

## 可以自己试

把 `DelayXms(500)` 改成 `DelayXms(100)`，流水立刻变快；改成 `DelayXms(20)` 几乎就是拖影效果。

## 编译下载

Keil uVision 打开 `2-4 LED流水灯Plus.uvproj` → `F7` → `Objects/2-4 LED流水灯Plus.hex` → STC-ISP 下载。
