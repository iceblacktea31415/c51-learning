# 新工程样本（复制重命名后拖入脚本）

## 用途

新建一个练习项目时，**复制这个文件夹**当模板，省掉每次手建 EIDE 工程的麻烦。

## 使用步骤

1. 复制整个文件夹，把文件夹名改成新项目名（比如 `4-1 定时器`）；
2. 打开里面的 `src/main.c` 写代码；
3. 把新文件夹**拖到仓库根目录的 `新建工程改名.bat` 上**，脚本会读文件夹名，把 EIDE 工程内部的工程名一起改掉；
4. VSCode + EIDE 插件打开 `*.code-workspace` 构建。

> 这一步的意义：EIDE 的工程名存在 `.eide/eide.yml` 和 `build/Debug/` 里，光改文件夹名不会改工程名，编译出来的 `xxx.hex` 还是旧名字，容易拿错文件去烧录。

## 模板里有什么

```
新工程样本/
├── src/main.c              # 空的 main 骨架
├── .eide/eide.yml          # 工程配置（type: C51, 输出到 build/）
├── .eide/files.options.yml
├── .vscode/tasks.json      # 构建任务
├── example.code-workspace  # VSCode 工作区
├── tools/stcflash.py       # 命令行下载脚本
└── .gitignore              # 忽略 build/
```

⚠️ 模板里的 `.eide/eide.yml` 同样是跟本机绑定的：include 路径假设 Keil C51 装在 `D:\Keil5\C51`，烧录用 `stcflash.py` + `COM3`。换电脑要改。
