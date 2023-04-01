# 简介
Neovim的常用配置文件

# 目录结构

```sh
|-- init.lua # 初始化配置
|-- lua # 可以在此文件夹下进行模块化配置
    |-- core # 核心配置文件夹
        |-- options.lua # 配置选项功能
        |-- keymaps.lua # 修改快捷键
    |-- plugins # 核心配置文件夹
        |-- plugins-setup.lua # 插件启动
```