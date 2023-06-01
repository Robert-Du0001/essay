vim.g.mapleader = " " -- 设置主键为空格

local keymap = vim.keymap

-- 视觉模式
keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- ---------- 正常模式 ---------- ---
-- 窗口
keymap.set("n", "<leader>sv", "<C-w>v") -- 水平新增窗口 
keymap.set("n", "<leader>sh", "<C-w>s") -- 垂直新增窗口

-- 取消高亮
-- 搜索模式下，用主键+nh，来代替取消高亮
keymap.set('n', '<leader>nh', ':nohl<CR>')

-- 切换buffer
keymap.set("n", "<C-l>", ":bnext<CR>")
keymap.set("n", "<C-h>", ":bprevious<CR>")

-- 插件
-- nvim-tree
keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
