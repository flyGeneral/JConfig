-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {   "folke/tokyonight.nvim" },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {"nvim-tree/nvim-web-devicons", opt = true},
    },
    {
        -- 上游已归档（只读维护），功能仍正常；日后如需替换可考虑 oil.nvim
        "nvim-tree/nvim-tree.lua",
        dependencies = "nvim-tree/nvim-web-devicons",
    },
    {
        "christoomey/vim-tmux-navigator"
    },
    {
        "nvim-treesitter/nvim-treesitter",
        -- master 分支是传统实现（ensure_installed 等旧式配置 API），
        -- main 分支是重写版（API 不兼容）。本配置使用旧式 API，固定 master。
        branch = "master",
        build = ":TSUpdate",
    },
    {
        -- nvim-ts-rainbow 已归档，这是同一作者维护中的继任者
        "HiPhish/rainbow-delimiters.nvim",
        config = function()
            require("rainbow-delimiters.setup").setup({})
        end,
    },

    {
        'stevearc/aerial.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
    },

    {
        "akinsho/bufferline.nvim", version = "*",
        dependencies = "nvim-tree/nvim-web-devicons"
    },

    {
        "windwp/nvim-autopairs",
        event = "VeryLazy",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },

    -- lsp 代码补全
    {
        event = "VeryLazy",
        "hrsh7th/nvim-cmp",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
        },
    },

    {
        event = "VeryLazy",
        -- 仓库已从 williamboman 迁移到 mason-org
        "mason-org/mason.nvim",
        build = ":MasonUpdate", -- :MasonUpdate updates registry contents
    },

    {
        event = "VeryLazy",
        "neovim/nvim-lspconfig",
    },

    {
        -- 官方已废弃（功能并入 nvim 0.11+ 原生 LSP），但仍是
        -- "mason 自动安装 + 自动 vim.lsp.enable" 的最简方案
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
    },

    -- Java: eclipse.jdt.ls 客户端（官方推荐替代 lspconfig.jdtls），
    -- 首次打开 java 文件时启动，见 lua/lsp/java.lua
    {
        "mfussenegger/nvim-jdtls",
        ft = { "java" },
    },

    -- Markdown 阅读增强：终端内渲染标题/表格/代码块
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        opts = {},
    },

    {
        cmd = "Telescope",
        'nvim-telescope/telescope.nvim',
        -- 版本由 lazy-lock.json 锁定 commit，保证可复现；更新时用 :Lazy sync
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    -- 注释使用 nvim 0.10+ 内置的 gc/gcc，不再需要 Comment.nvim

    -- git plugin
    {
        event = "VeryLazy",
        "lewis6991/gitsigns.nvim",
    },
    {
        event = "VeryLazy",
        "tpope/vim-fugitive",
        cmd = "Git",
        config = function()
            -- convert
            vim.cmd.cnoreabbrev([[git Git]])
            vim.cmd.cnoreabbrev([[gp Git push]])
        end,
    },
    {
        "sindrets/diffview.nvim",
    },
    {
        "kdheepak/lazygit.nvim",
        cmd = {
          "LazyGit",
          "LazyGitConfig",
          "LazyGitCurrentFile",
          "LazyGitFilter",
          "LazyGitFilterCurrentFile",
        },
        -- 可选，用于浮动窗口边框装饰
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        -- 建议设置 'keys' 以在首次运行命令时加载插件
        keys = {
          { "<leader>lg", "<cmd>LazyGit<cr>", desc = "启动 LazyGit" }
        }
    },
    -- quick move
    {
        -- leap 官方仓库已迁至 Codeberg（GitHub 原仓库已被作者清空）
        url = "https://codeberg.org/andyg/leap.nvim.git",
        dependencies = { "tpope/vim-repeat" },
        config = function()
            local leap = require('leap')
            if leap.create_default_mappings then
                leap.create_default_mappings()
            else
                leap.add_default_mappings()
            end
        end,
    },
})

-- 状态栏插件
require("plugins.lualine");
-- bufferline
require("plugins.bufferline")
-- nvim-tree
require("plugins.nvim-tree")
-- Telescope
require("plugins.Telescope")
-- vim-tmux-navigator 默认键位即可，无需 Lua 配置
-- nvim-treesitter
require("plugins.nvim-treesitter")
-- aerial
require("plugins.aerial")
-- gitsigns
require("plugins.gitsigns")
-- lsp mason
require("lsp-mason.lsp_config")
require("lsp-mason.cmp")
