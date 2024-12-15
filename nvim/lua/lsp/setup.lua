-- local lsp_installer = require("nvim-lsp-installer")
require("nvim-lsp-installer").setup({
  -- 自动安装 Language Servers
  automatic_installation = true,
})
local lspconfig = require("lspconfig")

-- 安装列表
-- { key: 服务器名， value: 配置文件 }
-- key 必须为下列网址列出的 server name，不可以随便写
-- https://github.com/williamboman/nvim-lsp-installer#available-lsps
local servers = {
  ccls = require("lsp.config.ccls"), -- lua/lsp/config/ccls.lua
  jdtls = require("lsp.config.jdtls"),
  kotlin_language_server = require("lsp.config.kotlin_language_server"),
  -- remark_ls = require("lsp.config.markdown"),
}

for name, config in pairs(servers) do
  if config ~= nil and type(config) == "table" then
    -- 自定义初始化配置文件必须实现on_setup 方法
    config.on_setup(lspconfig[name])
  else
    -- 使用默认参数
    lspconfig[name].setup({})
  end
end



vim.api.nvim_set_keymap("n", "<leader>lo", ":lua vim.lsp.buf.document_symbol()<CR>", {noremap = true, silent = true, desc = "file outline"})
vim.api.nvim_set_keymap("n", "<leader>ll", ":cclose<CR>", {noremap = true, silent = true, desc = "file close"})
