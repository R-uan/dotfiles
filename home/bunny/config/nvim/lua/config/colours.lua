vim.cmd("colorscheme bunny_dark")

vim.api.nvim_set_hl(0, "BlinkCmpMenu", {
  bg = "#070707",      -- black
  fg = "#a8c69f",      -- lgreen
})

-- border
vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", {
  bg = "#070707",
  fg = "#1d1c21",      -- border
})

-- selected item
vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", {
  bg = "#2a3424",      -- dgreenAlt
  fg = "#a8c69f",
  bold = true,
})

-- label text
vim.api.nvim_set_hl(0, "BlinkCmpLabel", {
  fg = "#a8c69f",
})

-- matched characters (primary accent)
vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", {
  fg = "#6BB9A7",      -- highlight (teal-green)
  bold = true,
})

-- deprecated items
vim.api.nvim_set_hl(0, "BlinkCmpLabelDeprecated", {
  fg = "#556b47",      -- greenAlt
  strikethrough = true,
})

-- kind icons / text (secondary accent)
vim.api.nvim_set_hl(0, "BlinkCmpKind", {
  fg = "#b692d4",      -- purple
})

-- warnings / errors
vim.api.nvim_set_hl(0, "BlinkCmpLabelDetail", {
  fg = "#D46A8C",      -- rose
})
