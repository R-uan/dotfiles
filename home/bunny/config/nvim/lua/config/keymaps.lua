local telescope = require "telescope.builtin"

-- ── Leader ────────────────────────────────────────────────────────────────────
vim.g.mapleader = " "

-- ── Multi-cursor (vim-visual-multi) ───────────────────────────────────────────
vim.schedule(function()
  pcall(vim.keymap.del, "n", "<C-d>")
end)
vim.g.VM_maps = {
  ["Find Under"] = "<C-d>",
  ["Find Subword Under"] = "<C-d>",
}

-- ── File picker / search ───────────────────────────────────────────────────────
vim.keymap.set("n", "<C-p>", telescope.find_files, { desc = "Find files" })
vim.keymap.set("n", "<C-f>", telescope.current_buffer_fuzzy_find, { desc = "Search current file" })
vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Live grep" })

-- ── Find & replace (Spectre) ───────────────────────────────────────────────────
vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = "Search current word" })
vim.keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = "Search current word" })
vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = "Search in current file" })

-- ── LSP ────────────────────────────────────────────────────────────────────────
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>gr", "<cmd>Telescope lsp_references<CR>", { desc = "References" })
vim.keymap.set("n", "<leader>ss", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set({ "n", "x" }, "<leader>ca", function()
  require("tiny-code-action").code_action()
end, { noremap = true, silent = true, desc = "Code action" })
vim.keymap.set("n", "<leader>nb", "<cmd>Navbuddy<cr>", { desc = "Navbuddy" })

-- ── Completion ─────────────────────────────────────────────────────────────────
vim.keymap.set("i", "<C-Space>", function()
  if vim.fn.pumvisible() == 0 then
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, true, true), "n")
  end
end, { desc = "Trigger completion" })
vim.keymap.set("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true, desc = "Next completion / indent" })

-- ── Editing ────────────────────────────────────────────────────────────────────
vim.keymap.set("i", "<C-CR>", "<Esc>o", { desc = "New line below" })
vim.keymap.set("n", "gcc", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })

-- ── Indentation ────────────────────────────────────────────────────────────────
vim.keymap.set("n", "<Tab>", ">>", { desc = "Indent" })
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Unindent" })
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })
vim.keymap.set("i", "<S-Tab>", "<C-d>", { desc = "Unindent" })

-- ── Move lines ─────────────────────────────────────────────────────────────────
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

-- ── UI ─────────────────────────────────────────────────────────────────────────
vim.keymap.set("n", "<C-b>", function()
  local manager = require "neo-tree.sources.manager"
  local state = manager.get_state "filesystem"
  if state and state.winid and vim.api.nvim_win_is_valid(state.winid) then
    vim.cmd "Neotree close"
  else
    vim.cmd "Neotree show"
  end
end, { silent = true, desc = "Toggle Neo-tree" })
vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd>w<cr>", { silent = true, desc = "Save" })

-- ── Git ────────────────────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
vim.keymap.set("v", "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
