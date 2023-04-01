vim.g.mapleader = " " -- 设置主键为空格

local keymap = vim.keymap

-- 取消高亮
-- 搜索模式下，用主键+nh，来代替取消高亮
keymap.set('n', '<leader>nh', ':nohl<CR>')
