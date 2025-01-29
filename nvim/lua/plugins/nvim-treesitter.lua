require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = { "vim", "bash", "c", "cpp", "javascript", "java",
        "json", "lua", "python", "query" },

    highlight = {
        enable = true,
    },

    indent = {
        enable = true
    },

    -- 不同括号颜色区分
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
    }
  }
