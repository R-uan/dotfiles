vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.fillchars = "eob: "

-- Set tab width and behavior
vim.opt.tabstop = 2 -- number of spaces a <Tab> counts for
vim.opt.shiftwidth = 2 -- spaces used for autoindent (>> and <<)
vim.opt.softtabstop = 2 -- how many spaces <Tab> inserts while editing
vim.opt.expandtab = true -- convert tabs to spaces

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99 -- Open all folds by default

vim.opt.whichwrap:append("<,>,h,l,[,]")
vim.opt.scrolloff = 10
