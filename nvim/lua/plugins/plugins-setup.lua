-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
        "nvim-tree/nvim-tree.lua",
        dependencies = "nvim-tree/nvim-web-devicons",
    },
    {
        "christoomey/vim-tmux-navigator"
    },
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "p00f/nvim-ts-rainbow"
        },
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
        "williamboman/mason.nvim",
        build = ":MasonUpdate", -- :MasonUpdate updates registry contents
    },

    {
        event = "VeryLazy",
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason-lspconfig.nvim" },
    },

    {
        cmd = "Telescope",
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        -- or                          , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    {   
        "numToStr/Comment.nvim",
        event = "VeryLazy",
    },
    -- git plugin
    {
        event = "VeryLazy",
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
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
        "ggandor/leap.nvim",
        config = function()
            require('leap').add_default_mappings()
        end,
    },
})

require("mason").setup()
require("mason-lspconfig").setup()

-- 状态栏插件
require("plugins.lualine");
-- bufferline
require("plugins.bufferline")
-- nvim-tree
require("plugins.nvim-tree")
-- Telescope
require("plugins.Telescope")
-- vim-tmux-navigator
require("plugins.vim-tmux-navigator")
-- comment
require("plugins.Comment")
-- nvim-treesitter
require("plugins.nvim-treesitter")
-- aerial
require("plugins.aerial")
-- gitsigns
require("plugins.gitsigns")
-- lsp mason
require("lsp-mason.lsp_config")
require("lsp-mason.cmp")

