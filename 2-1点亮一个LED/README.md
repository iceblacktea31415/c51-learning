# 2-1 点亮一个 LED

## 功能

上电后点亮 P2.0 口接的那颗 LED（D1），其余保持熄灭。

## 代码要点

```c
#include <REGX52.H>

void main(){
	P2=0xFE;   // 1111 1110
	while(1){
	}
}
```

- `P2 = 0xFE` 是二进制 `1111 1110`，只有 **P2.0 输出低电平**，其余 7 位都是高电平。
- 开发板上的 LED 是**低电平点亮**（阳极接 VCC，阴极接单片机 IO），所以写 `0` 才亮。
- 最后那个 `while(1){}` 是必须的：8051 的 `main` 返回后会从头重新执行，空死循环把程序停在这里。

## 编译下载

Keil uVision 打开 `led_test.uvproj` → `F7` 编译 → 生成 `Objects/led_test.hex` → 用 STC-ISP 下载到板子。

> `Objects/`、`Listings/` 是编译产物，已被 `.gitignore` 忽略，不会进仓库。
