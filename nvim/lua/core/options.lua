local opt = vim.opt

-- 行号
opt.number = true

-- 缩进
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- 防止包裹
opt.wrap = false

-- 光标行
opt.cursorline = true

-- 启用鼠标
opt.mouse:append('a')

-- 系统剪切板
opt.clipboard:append('unnamedplus')

-- 默认新窗口右和下
opt.splitright = true
opt.splitbelow = true

-- 搜索
opt.ignorecase = true -- 忽略大小写
opt.smartcase = true -- 如果搜索的是大写，则只搜索大写

-- 外观
opt.termguicolors = true
opt.signcolumn = 'yes' -- 左侧多一列，对debug和插件提示都有用
vim.cmd[[colorscheme tokyonight-night]] -- night主题
