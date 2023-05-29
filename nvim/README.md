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
        |-- autopairs.lua # 自动补充括号
        |-- bufferline.lua # 打开文件的缓存栏
        |-- cmp.lua # 自动补全
        |-- comment.lua # 注释
        |-- gitsigns.lua # 左则git提示
        |-- lsp.lua # 语法提示
        |-- lualine.lua # 状态栏
        |-- nvim-tree.lua # 目录树
        |-- plugins-setup.lua # 插件启动
        |-- telescope.lua # 文件查找
        |-- treesitter.lua # 语法高亮
```
