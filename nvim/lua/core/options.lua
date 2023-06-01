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

-- 禁止在注释行换行后，自动添加注释符
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*",
  callback = function()
      -- 如果只写这个，重新打开文件后还是会自动添加
      vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
  end,    
})
