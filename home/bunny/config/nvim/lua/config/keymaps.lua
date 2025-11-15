local telescope = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "LSP Rename" })

local set = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ===== INSERT MODE =====
-- Ctrl+Space = Trigger completion
set("i", "<C-Space>", function()
	if vim.fn.pumvisible() == 0 then
		vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, true, true), "n")
	end
end, opts)

-- Ctrl+Enter = exit insert and open new line below
set("i", "<C-CR>", "<Esc>o", opts)

-- ===== NORMAL MODE =====
-- Alt+k = Move line up
set("n", "<A-k>", ":m .-2<CR>==", opts)
-- Alt+j = Move line down
set("n", "<A-j>", ":m .+1<CR>==", opts)

-- ===== VISUAL (SELECT) MODE =====
-- Alt+k = Move selection up
set("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
-- Alt+j = Move selection down
set("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
