local telescope = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "LSP Rename" })
vim.keymap.set("i", "<C-CR>", "<Esc>o", opts)
-- Alt+k = Move line up
-- Alt+j = Move line down
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", opts)
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", opts)
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)

-- Ctrl+Space = Trigger completion
vim.keymap.set("i", "<C-Space>", function()
	if vim.fn.pumvisible() == 0 then
		vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, true, true), "n")
	end
end, opts)
