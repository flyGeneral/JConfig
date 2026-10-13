require'nvim-treesitter.configs'.setup {
    -- 按日常使用的语言维护：C/C++/Java/Python/Markdown/Makefile 及常见工程文件
    ensure_installed = {
        "c", "cpp", "java", "python",               -- 主力语言
        "markdown", "markdown_inline",               -- Markdown（markdown_inline 覆盖代码块内嵌内容）
        "make", "cmake",                             -- 构建脚本
        "json", "yaml", "toml", "xml",               -- 工程/配置文件（xml 覆盖 pom.xml 等）
        "bash", "vim", "lua", "query", "comment",    -- 工具链与 nvim 自身
    },

    highlight = {
        enable = true,
    },

    indent = {
        enable = true
    },

    -- 彩虹括号已迁移到 rainbow-delimiters.nvim（见 plugins-setup.lua）
  }
