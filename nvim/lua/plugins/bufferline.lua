local status, bufferline = pcall(require, "bufferline")
if (not status) then
  return
end

vim.opt.termguicolors = true
bufferline.setup{
    options = {
        numbers = "ordinal", -- id
        mode = "buffer",
        -- icons
        modified_icon = "●",
        max_name_length = 15,
        max_prefix_length = 12, -- prefix used when a buffer is de-duplicated
        tab_size = 15,
        color_icons = true,
		offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left"
            }
        }
    },
}

-- -- 快速在buffer间跳转
-- vim.api.nvim_set_keymap("n", "<leader>b1", ":BufferLineGoToBuffer 1<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<leader>b2", ":BufferLineGoToBuffer 2<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<leader>b3", ":BufferLineGoToBuffer 3<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<leader>b4", ":BufferLineGoToBuffer 4<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<leader>b5", ":BufferLineGoToBuffer 5<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<leader>b6", ":BufferLineGoToBuffer 6<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<leader>b7", ":BufferLineGoToBuffer 7<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<leader>b8", ":BufferLineGoToBuffer 8<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<leader>b9", ":BufferLineGoToBuffer 9<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<leader>bg", ":BufferLinePick", {noremap = true, silent = true})

-- vim.api.nvim_set_keymap("n", "bn", ":BufferLineCycleNext<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "bp", ":BufferLineCyclePrev<CR>", {noremap = true, silent = true})

-- --- 关闭当前 buffer
-- vim.api.nvim_set_keymap("n", "<leader>bc", ":bdelete %<CR>", {noremap = true, silent = true})
-- --- 关闭指定 buffer
-- vim.api.nvim_set_keymap("n", "<leader>bp", ":BufferLinePickClose<CR>", {noremap = true, silent = true})
-- --- 关闭除当前buffer外的所有buffer
-- vim.api.nvim_set_keymap("n", "<leader>bo", ":BufferLineCloseLeft<CR>:BufferLineCloseRight<CR>", {noremap = true, silent = true})