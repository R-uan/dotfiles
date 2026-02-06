vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.fillchars = "eob: "

-- Set tab width and behavior
vim.opt.tabstop = 2      -- number of spaces a <Tab> counts for
vim.opt.shiftwidth = 2   -- spaces used for autoindent (>> and <<)
vim.opt.softtabstop = 2  -- how many spaces <Tab> inserts while editing
vim.opt.expandtab = true -- convert tabs to spaces

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99 -- Open all folds by default

vim.opt.whichwrap:append "<,>,h,l,[,]"
vim.opt.scrolloff = 10

vim.g.rust_recommended_style = 0
vim.g.python_recommended_style = 0

vim.cmd [[
  highlight DiagnosticVirtualTextError guifg=#D46A8C guibg=NONE gui=italic
  highlight DiagnosticVirtualTextWarn  guifg=#D46A8C guibg=NONE gui=italic
  highlight DiagnosticVirtualTextInfo  guifg=#A4CE70 guibg=NONE gui=italic
  highlight DiagnosticVirtualTextHint  guifg=#A4CE70 guibg=NONE gui=italic
]]

vim.diagnostic.config {
  virtual_text = {
    prefix = "",
    spacing = 1,
  },                -- inline error messages
  signs = false,    -- gutter signs
  underline = true, -- underline problem
  float = { border = "rounded" },
}

-- necessary for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
