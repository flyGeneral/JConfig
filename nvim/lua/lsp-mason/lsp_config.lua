-- LSP 配置（补全见 lsp-mason/cmp.lua）
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup()
require("mason-lspconfig").setup({
    -- mason 包名；安装后自动 vim.lsp.enable（v2 默认行为）
    ensure_installed = {
        "clangd",               -- C / C++
        "jdtls",                -- Java：只装二进制，启动由 nvim-jdtls 接管（见 lua/lsp/java.lua）
        "pyright",              -- Python 类型检查
        "ruff",                 -- Python lint + format（与 pyright 各司其职，可共存）
        "marksman",             -- Markdown 大纲/链接/补全
        "lua-language-server",  -- nvim 配置开发
    },
    automatic_enable = function(server)
        -- jdtls 由 nvim-jdtls 管理，避免被重复启动
        return server ~= "jdtls"
    end,
})

-- 各 server 的能力/行为微调（vim.lsp.enable 是 nvim 0.11+ 标准写法）
vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim", "hs" },
            },
            workspace = {
                checkThirdParty = false,
                -- Make the server aware of Neovim runtime files
                library = {
                    -- vim.api.nvim_get_runtime_file("", true),
                },
            },
            completion = {
                callSnippet = "Replace",
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})

vim.lsp.config("clangd", { capabilities = capabilities })
vim.lsp.config("pyright", { capabilities = capabilities })
vim.lsp.config("ruff", { capabilities = capabilities })
vim.lsp.config("marksman", { capabilities = capabilities })

-- 显式启用（enable 幂等，同时兜底 automatic_enable 未覆盖的场景）
vim.lsp.enable({ "lua_ls", "clangd", "pyright", "ruff", "marksman" })

-- Java 由 nvim-jdtls 接管（依赖 JDK 17+，未安装时会给出提示）
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    group = vim.api.nvim_create_augroup("UserJavaLsp", { clear = true }),
    callback = function()
        require("lsp.java").start()
    end,
})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- 注意: <leader>e 已被 nvim-tree 占用，这里用 <leader>df
vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float)
-- goto_prev/goto_next 在 0.11+ 已废弃，改用 jump
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end)
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		--	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<A-f>", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})
