-- 使用相对行号
vim.opt.number = true
vim.opt.relativenumber = true

-- 缩进4个空格等于一个Tab
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- 禁止折行，包裹
vim.wo.wrap = true

-- 高亮所在行
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- 鼠标支持
vim.o.mouse = "a"

-- 配置剪切板
vim.opt.clipboard = "unnamedplus"

-- split window 从下边和右边出现
vim.opt.splitbelow = true
vim.opt.splitright = true

-- 搜索大小写不敏感，除非包含大写
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 样式
vim.opt.termguicolors = true
-- 显示左侧图标指示列
vim.opt.signcolumn = "yes"



-- utf8
-- vim.g.encoding = "UTF-8"
-- vim.o.fileencoding = "utf-8"
-- jkhl 移动时光标周围保留8行
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8


-- 右侧参考线，超过表示代码太长了，考虑换行
-- vim.wo.colorcolumn = "80"

vim.o.softtabstop = 4
vim.o.shiftround = true
-- 新行对齐当前行
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true

-- 搜索不要高亮
vim.o.hlsearch = false
-- 边输入边搜索
vim.o.incsearch = true
-- 命令行高为2，提供足够的显示空间
vim.o.cmdheight = 1
-- 当文件被外部程序修改时，自动加载
vim.o.autoread = true
vim.bo.autoread = true

-- 光标在行首尾时<Left><Right>可以跳到下一行
vim.o.whichwrap = "<,>,[,]"
-- 允许隐藏被修改过的buffer
vim.o.hidden = true

-- 禁止创建备份文件
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
-- smaller updatetime
vim.o.updatetime = 300
-- 设置 timeoutlen 为等待键盘快捷键连击时间500毫秒，可根据需要设置
-- 遇到问题详见：https://github.com/nshen/learn-neovim-lua/issues/1
vim.o.timeoutlen = 500

-- 自动补全不自动选中
vim.g.completeopt = "menu,menuone,noselect,noinsert"
-- 样式
vim.o.termguicolors = true
vim.opt.termguicolors = true
-- 是否显示不可见字符
vim.o.list = false
-- 不可见字符的显示，这里只把空格显示为一个点
vim.o.listchars = "space:·,tab:··"
-- 补全增强
vim.o.wildmenu = true
-- Dont' pass messages to |ins-completin menu|
vim.o.shortmess = vim.o.shortmess .. "c"
-- 补全最多显示10行
vim.o.pumheight = 10
-- 永远显示 tabline
vim.o.showtabline = 2
-- 使用增强状态栏插件后不再需要 vim 的模式提示
vim.o.showmode = false


-- start theme
vim.cmd[[colorscheme tokyonight]]

-- nvim 0.9 发现把宏定义也识别成注释，Google 配置解决
vim.api.nvim_set_hl(0, '@lsp.type.comment.cpp', {})

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("UserHighlightYank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual" })
    end,
})

-- go to last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("UserLastLoc", { clear = true }),
    callback = function(event)
      local exclude = { "gitcommit" }
      local buf = event.buf
      if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].user_last_loc then
        return
      end
      vim.b[buf].user_last_loc = true
      local mark = vim.api.nvim_buf_get_mark(buf, '"')
      if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(buf) then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
})