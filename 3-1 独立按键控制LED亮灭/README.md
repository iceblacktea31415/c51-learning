# 3-1 独立按键控制 LED 亮灭

## 功能

**按住** K1（接 P3.1）→ D1 亮；**松开** → D1 灭。

## 代码要点

```c
while(1){
    if( P3_1==0 ){
        P2=0XFE;    // 按下：D1 亮（低电平点亮）
    }
    else{
        P2=0xFF;    // 松开：全灭
    }
}
```

- `P3_1` 是 `<regx52.h>` 里定义的**位变量**，可以直接当 `0/1` 读，不用再 `P3 & 0x02` 手动掩码。
- 按键接法一般是**按下接地**，所以按下读到 `0`、松开读到 `1`。
- 无限循环里不停轮询，属于最简单的"**查询方式**"，没用到中断。

## 这一版的问题

1. **没有消抖**。机械按键按下/松开的几毫秒内电平会抖动，偶尔会误判。
2. `DelayXms()` 写好了却没用上，`int i, flag=0;` 也没用上——是练习过程留下的痕迹。

下一节 `3-2` 用「延时 10ms + 等松手」解决了这两点。

## 工程格式（EIDE）

```
3-1 独立按键控制LED亮灭/
├── src/main.c              # 源码
├── .eide/eide.yml          # 工程配置（toolchain: Keil_C51）
├── p3_1.code-workspace     # VSCode 工作区
├── tools/stcflash.py       # 命令行下载脚本
└── build/Debug/            # 编译输出（被 .gitignore 忽略）
```

VSCode + EIDE 插件打开 `p3_1.code-workspace` → 构建 → `build/Debug/p3_1.hex`。

⚠️ 换电脑要改两处：`.eide/eide.yml` 里 include 路径 `../../Keil5/C51/INC`（假设 Keil C51 装在 `D:\Keil5\C51`）、烧录配置里的串口（默认 `COM3`）。
