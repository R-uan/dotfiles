-- colors/bunny_green.lua
-- Neovim theme with green & purple harmony palette

local palette = {
  -- Core greens
  darkGreen = "#2a3424",
  middGreen = "#7fb069",
  lighGreen = "#a8c69f",
  brightGreen = "#8fc277",

  -- Core purples
  darkPurple = "#32233d",
  middPurple = "#6b4d82",
  lighPurple = "#b692d4",
  lavender = "#d4b5e8",

  -- Accent colors
  accent = "#7fb069",       -- sage green (primary)
  accent_dark = "#556b47",  -- forest green
  accent_soft = "#a8c69f",  -- light sage
  accent_purple = "#b692d4", -- soft purple

  -- UI backgrounds
  bg0 = "#070707",
  bg1 = "#1a1a1a",
  bg2 = "#2a2a2a",
  bg3 = "#3a3a3a",

  -- Foreground
  fg = "#a8c69f",
  fg_muted = "#7fb069",

  -- UI elements
  border = "#2a2a2a",
  grey = "#808080",
  highlight = "#8fc277",

  -- Status / feedback
  warning = "#d4b5e8",
  success = "#8fc277",
  error = "#D46A8C",

  -- Convenience aliases
  complementary = "#b692d4",     -- purple as complement
  complementary_soft = "#d4b5e8", -- lavender
}

vim.cmd "hi clear"
if vim.fn.exists "syntax_on" then
  vim.cmd "syntax reset"
end
vim.o.background = "dark"
vim.g.colors_name = "bunny_green"

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- UI
hi("Normal", { fg = palette.fg, bg = palette.bg0 })
hi("Cursor", { fg = palette.bg0, bg = palette.fg })
hi("CursorLine", { bg = palette.bg1 })
hi("CursorColumn", { bg = palette.bg1 })
hi("LineNr", { fg = palette.grey })
hi("CursorLineNr", { fg = palette.accent })
hi("StatusLine", { fg = palette.fg, bg = palette.bg2 })
hi("StatusLineNC", { fg = palette.fg_muted, bg = palette.bg1 })
hi("StatusLineNormal", { fg = palette.bg0, bg = palette.accent })
hi("StatusLineInsert", { fg = palette.bg0, bg = palette.highlight })
hi("StatusLineSelect", { fg = palette.bg0, bg = palette.complementary })
hi("Pmenu", { fg = palette.fg, bg = palette.bg2 })
hi("PmenuSel", { fg = palette.bg0, bg = palette.accent })
hi("Visual", { bg = palette.bg2 })
hi("VertSplit", { fg = palette.border, bg = palette.bg0 })
hi("WinSeparator", { fg = palette.border })
hi("SignColumn", { bg = palette.bg0 })
hi("FloatBorder", { fg = palette.border, bg = palette.bg0 })
hi("Folded", { bg = palette.bg1, italic = true })

-- Syntax
-- Green as primary, purple as accent
hi("Type", { fg = palette.accent })
hi("Structure", { fg = palette.accent })
hi("Enum", { fg = palette.accent })
hi("Class", { fg = palette.accent })
hi("Interface", { fg = palette.accent })
hi("Function", { fg = palette.highlight })
hi("Constant", { fg = palette.complementary })
hi("Number", { fg = palette.middGreen })
hi("String", { fg = palette.lighGreen })
hi("Character", { fg = palette.lighGreen })
hi("Comment", { fg = palette.grey, italic = false })
hi("Variable", { fg = palette.fg })
hi("Identifier", { fg = palette.fg })
hi("Keyword", { fg = palette.accent_purple })
hi("Operator", { fg = palette.fg_muted })
hi("Tag", { fg = palette.accent })
hi("Namespace", { fg = palette.accent_purple })
hi("Attribute", { fg = palette.highlight })

hi("@comment", { fg = palette.grey, italic = false })
hi("@constant", { fg = palette.complementary })
hi("@constant.builtin", { fg = palette.complementary })
hi("@string", { fg = palette.lighGreen })
hi("@number", { fg = palette.middGreen })
hi("@boolean", { fg = palette.middGreen })
hi("@function", { fg = palette.highlight })
hi("@function.call", { fg = palette.highlight })
hi("@method", { fg = palette.highlight })
hi("@constructor", { fg = palette.accent })
hi("@type", { fg = palette.accent })
hi("@type.builtin", { fg = palette.accent })
hi("@variable", { fg = palette.fg })
hi("@variable.builtin", { fg = palette.accent_soft })
hi("@parameter", { fg = palette.complementary })
hi("@property", { fg = palette.fg })
hi("@keyword", { fg = palette.accent_purple })
hi("@operator", { fg = palette.fg_muted })
hi("@tag", { fg = palette.accent })
hi("@namespace", { fg = palette.accent_purple })
hi("@attribute", { fg = palette.highlight })
hi("@module", { fg = palette.accent_purple })
hi("@label", { fg = palette.lighGreen })
hi("@punctuation", { fg = palette.grey })

-- Markup / Markdown
hi("markdownH1", { fg = palette.accent })
hi("markdownH2", { fg = palette.highlight })
hi("markdownH3", { fg = palette.complementary })
hi("markdownH4", { fg = palette.accent_soft })
hi("markdownH5", { fg = palette.complementary_soft })
hi("markdownH6", { fg = palette.fg })
hi("markdownListMarker", { fg = palette.accent })
hi("markdownBold", { bold = true })
hi("markdownItalic", { italic = true })
hi("markdownUrl", { fg = palette.complementary, underline = true })
hi("markdownLinkText", { fg = palette.accent_soft })
hi("markdownQuote", { fg = palette.fg_muted })
hi("markdownCode", { fg = palette.lighGreen })

-- Diff
hi("DiffAdd", { fg = palette.success })
hi("DiffChange", { fg = palette.complementary_soft })
hi("DiffDelete", { fg = palette.error })

-- Diagnostics
hi("DiagnosticHint", { sp = palette.accent_soft, undercurl = true })
hi("DiagnosticInfo", { sp = palette.complementary, undercurl = true })
hi("DiagnosticWarn", { sp = palette.warning, undercurl = true })
hi("DiagnosticError", { sp = palette.error, undercurl = true })

-- Git
hi("DiffAdded", { fg = palette.success })
hi("DiffRemoved", { fg = palette.error })
hi("DiffChanged", { fg = palette.complementary_soft })

-- Extra UI accents
hi("Whitespace", { fg = palette.bg3 })
hi("IndentBlanklineChar", { fg = palette.bg3 })
hi("ColorColumn", { bg = palette.bg3 })
hi("MatchParen", { bg = palette.accent, fg = palette.bg0 })

-- End
