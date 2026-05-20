local telescope = require "telescope.builtin"
vim.g.mapleader = " "

vim.schedule(function()
  pcall(vim.keymap.del, "n", "<C-d>")
end)

vim.g.VM_maps = {
  ["Find Under"] = "<C-d>",
  ["Find Subword Under"] = "<C-d>",
}

-- File Explorer/Picker
vim.keymap.set("n", "<C-p>", telescope.find_files, { desc = "Find files" })
vim.keymap.set("n", "<C-f>", telescope.current_buffer_fuzzy_find, { desc = "Search current file" })
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

vim.keymap.set({ "n", "x" }, "<leader>ca", function()
  require "tiny-code-action".code_action()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
  desc = "Toggle Spectre",
})

vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
  desc = "Search current word",
})

vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
  desc = "Search current word",
})

vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
  desc = "Search on current file",
})

--navbuddy
vim.keymap.set("n", "<leader>nb", "<cmd>Navbuddy<cr>")

vim.keymap.set("n", "<C-b>", function()
  local manager = require "neo-tree.sources.manager"
  local state = manager.get_state "filesystem"

  if state and state.winid and vim.api.nvim_win_is_valid(state.winid) then
    vim.cmd "Neotree close"
  else
    vim.cmd "Neotree show"
  end
end, { silent = true, desc = "Toggle Neo-tree" })

-- Tabs
vim.keymap.set("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true })

vim.keymap.set("i", "<S-Tab>", "<C-d>")

vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")

vim.keymap.set("n", "<Tab>", ">>")
vim.keymap.set("n", "<S-Tab>", "<<")

-- Comment
vim.keymap.set("n", "gcc", function()
  require "Comment.api".toggle.linewise.current()
end)


vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd>w<cr>", { silent = true })
vim.keymap.set("i", "<C-s>", "<Esc><cmd>w<cr>a")

-- git
vim.keymap.set("n", "<leader>hs", ":Gitsigns stage_hunk<CR>")
vim.keymap.set("v", "<leader>hs", ":Gitsigns stage_hunk<CR>")
vim.keymap.set("n", "<leader>hr", ":Gitsigns reset_hunk<CR>")
