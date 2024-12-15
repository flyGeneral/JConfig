-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- leader key 为空
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap

-- --------- 插入模式 ---------


-- --------- 视觉模式 ---------
-- 单行或多行移动
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '>-2<CR>gv=gv")

-- --------- 正常模式 ---------
-- nvim split screen
keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>s")

-- nvim split screen
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- 插件
-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

keymap.set("n", "<leader>f", ":Telescope find_files<CR>")
keymap.set("n", "<leader>g", ":Telescope live_grep<CR>")
keymap.set("n", "<leader>rs", ":Telescope resume<CR>")
keymap.set("n", "<leader>o", ":Telescope oldfiles<CR>")

-- 快速在buffer间跳转
keymap.set("n", "<leader>b1", ":BufferLineGoToBuffer 1<CR>" )
keymap.set("n", "<leader>b2", ":BufferLineGoToBuffer 2<CR>" )
keymap.set("n", "<leader>b3", ":BufferLineGoToBuffer 3<CR>" )
keymap.set("n", "<leader>b4", ":BufferLineGoToBuffer 4<CR>" )
keymap.set("n", "<leader>b5", ":BufferLineGoToBuffer 5<CR>" )
keymap.set("n", "<leader>b6", ":BufferLineGoToBuffer 6<CR>" )
keymap.set("n", "<leader>b7", ":BufferLineGoToBuffer 7<CR>" )
keymap.set("n", "<leader>b8", ":BufferLineGoToBuffer 8<CR>" )
keymap.set("n", "<leader>b9", ":BufferLineGoToBuffer 9<CR>" )
keymap.set("n", "<leader>bg", ":BufferLinePick" )

keymap.set("n", "bn", ":BufferLineCycleNext<CR>" )
keymap.set("n", "bp", ":BufferLineCyclePrev<CR>" )

--- 关闭当前 buffer
keymap.set("n", "<leader>bc", ":bdelete %<CR>" )
--- 关闭指定 buffer
keymap.set("n", "<leader>bp", ":BufferLinePickClose<CR>" )
--- 关闭除当前buffer外的所有buffer
keymap.set("n", "<leader>bo", ":BufferLineCloseLeft<CR>:BufferLineCloseRight<CR>" )