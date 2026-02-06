-- colors/bunny_green.lua
-- Neovim theme with green & purple harmony palette

local palette = {
  -- Monochromatic green palette - soft and muted
  green_darker = "#2d3a2e",
  green_dark = "#3d4a3e",
  green_mid = "#6b7c6e",
  green_base = "#8a9d8f",
  green_light = "#a8b9aa",
  green_lighter = "#c5d3c6",
  green_accent = "#7a9b7f",

  -- Very subtle variation for accents
  green_warm = "#8d9e88",
  green_cool = "#84a089",

  -- UI grays with green tint
  bg0 = "NONE", -- transparent
  bg1 = "#1a1f1a",
  bg2 = "#232823",
  bg3 = "#2d322d",

  -- Foreground
  fg = "#a8b9aa",
  fg_muted = "#8a9d8f",
  fg_dim = "#6b7c6e",

  -- UI elements
  border = "#2d322d",
  grey = "#5a6a5a",

  -- Status (subtle green variations)
  success = "#7a9b7f",
  warning = "#9da88d",
  error = "#9d8a8a",
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
hi("Cursor", { fg = palette.bg1, bg = palette.fg })
hi("CursorLine", { bg = palette.bg1 })
hi("CursorColumn", { bg = palette.bg1 })
hi("LineNr", { fg = palette.grey })
hi("CursorLineNr", { fg = palette.green_accent })
hi("StatusLine", { fg = palette.fg, bg = palette.bg2 })
hi("StatusLineNC", { fg = palette.fg_muted, bg = palette.bg1 })
hi("StatusLineNormal", { fg = palette.bg1, bg = palette.green_accent })
hi("StatusLineInsert", { fg = palette.bg1, bg = palette.green_light })
hi("StatusLineSelect", { fg = palette.bg1, bg = palette.green_base })
hi("Pmenu", { fg = palette.fg, bg = palette.bg2 })
hi("PmenuSel", { fg = palette.bg1, bg = palette.green_accent })
hi("Visual", { bg = palette.bg2 })
hi("VertSplit", { fg = palette.border, bg = palette.bg0 })
hi("WinSeparator", { fg = palette.border })
hi("SignColumn", { bg = palette.bg0 })
hi("Folded", { bg = palette.bg1, fg = palette.fg_dim, italic = true })

-- Syntax - Monochromatic green variations
hi("Type", { fg = palette.green_accent })
hi("Structure", { fg = palette.green_accent })
hi("Enum", { fg = palette.green_accent })
hi("Class", { fg = palette.green_accent })
hi("Interface", { fg = palette.green_accent })
hi("Function", { fg = palette.green_light })
hi("Constant", { fg = palette.green_base })
hi("Number", { fg = palette.green_mid })
hi("String", { fg = palette.green_lighter })
hi("Character", { fg = palette.green_lighter })
hi("Comment", { fg = palette.grey, italic = false })
hi("Variable", { fg = palette.fg })
hi("Identifier", { fg = palette.fg })
hi("Keyword", { fg = palette.green_warm })
hi("Operator", { fg = palette.fg_muted })
hi("Tag", { fg = palette.green_accent })
hi("Namespace", { fg = palette.green_cool })
hi("Attribute", { fg = palette.green_light })

hi("@comment", { fg = palette.grey, italic = false })
hi("@constant", { fg = palette.green_base })
hi("@constant.builtin", { fg = palette.green_base })
hi("@string", { fg = palette.green_lighter })
hi("@number", { fg = palette.green_mid })
hi("@boolean", { fg = palette.green_mid })
hi("@function", { fg = palette.green_light })
hi("@function.call", { fg = palette.green_light })
hi("@method", { fg = palette.green_light })
hi("@constructor", { fg = palette.green_accent })
hi("@type", { fg = palette.green_accent })
hi("@type.builtin", { fg = palette.green_accent })
hi("@variable", { fg = palette.fg })
hi("@variable.builtin", { fg = palette.green_base })
hi("@parameter", { fg = palette.green_base })
hi("@property", { fg = palette.fg })
hi("@keyword", { fg = palette.green_warm })
hi("@operator", { fg = palette.fg_muted })
hi("@tag", { fg = palette.green_accent })
hi("@namespace", { fg = palette.green_cool })
hi("@attribute", { fg = palette.green_light })
hi("@module", { fg = palette.green_cool })
hi("@label", { fg = palette.green_lighter })
hi("@punctuation", { fg = palette.grey })

-- Markup / Markdown
hi("markdownH1", { fg = palette.green_accent, bold = true })
hi("markdownH2", { fg = palette.green_light })
hi("markdownH3", { fg = palette.green_base })
hi("markdownH4", { fg = palette.green_warm })
hi("markdownH5", { fg = palette.fg })
hi("markdownH6", { fg = palette.fg_muted })
hi("markdownListMarker", { fg = palette.green_accent })
hi("markdownBold", { bold = true })
hi("markdownItalic", { italic = true })
hi("markdownUrl", { fg = palette.green_cool, underline = true })
hi("markdownLinkText", { fg = palette.green_base })
hi("markdownQuote", { fg = palette.fg_muted })
hi("markdownCode", { fg = palette.green_lighter })

-- Diff
hi("DiffAdd", { fg = palette.success })
hi("DiffChange", { fg = palette.green_warm })
hi("DiffDelete", { fg = palette.error })

-- Diagnostics
hi("DiagnosticHint", { sp = palette.green_base, undercurl = true })
hi("DiagnosticInfo", { sp = palette.green_cool, undercurl = true })
hi("DiagnosticWarn", { sp = palette.warning, undercurl = true })
hi("DiagnosticError", { sp = palette.error, undercurl = true })

-- Git
hi("DiffAdded", { fg = palette.success })
hi("DiffRemoved", { fg = palette.error })
hi("DiffChanged", { fg = palette.green_warm })

-- Extra UI accents
hi("Whitespace", { fg = palette.bg3 })
hi("IndentBlanklineChar", { fg = palette.bg3 })
hi("ColorColumn", { bg = palette.bg3 })
hi("MatchParen", { bg = palette.green_accent, fg = palette.bg1 })

hi("BlinkCmpMenu", { fg = palette.fg, bg = palette.bg2 })
hi("BlinkCmpMenuBorder", { fg = palette.border, bg = palette.bg2 })
hi("BlinkCmpMenuSelection", { bg = palette.bg3, fg = palette.success })
hi("BlinkCmpScrollBarThumb", { bg = palette.green_mid })
hi("BlinkCmpScrollBarGutter", { bg = palette.bg3 })
hi("BlinkCmpLabel", { fg = palette.fg })
hi("BlinkCmpLabelDeprecated", { fg = palette.grey, strikethrough = true })
hi("BlinkCmpLabelMatch", { fg = palette.success, bold = true })
hi("BlinkCmpLabelDetail", { fg = palette.fg_muted })
hi("BlinkCmpLabelDescription", { fg = palette.fg_dim })
hi("BlinkCmpKind", { fg = palette.success })
hi("BlinkCmpSource", { fg = palette.fg_dim })
hi("BlinkCmpGhostText", { fg = palette.grey })
hi("BlinkCmpDoc", { fg = palette.fg, bg = palette.bg1 })
hi("BlinkCmpDocBorder", { fg = palette.border, bg = nil })
hi("BlinkCmpDocSeparator", { fg = palette.border })
hi("BlinkCmpDocCursorLine", { bg = palette.bg2 })
hi("BlinkCmpSignatureHelp", { fg = palette.fg, bg = palette.bg1 })
hi("BlinkCmpSignatureHelpBorder", { fg = palette.border, bg = palette.bg1 })
hi("BlinkCmpSignatureHelpActiveParameter", { fg = palette.success, bold = true })
hi("BlinkCmpKindText", { fg = palette.green_lighter })
hi("BlinkCmpKindMethod", { fg = palette.green_light })
hi("BlinkCmpKindFunction", { fg = palette.green_light })
hi("BlinkCmpKindConstructor", { fg = palette.success })
hi("BlinkCmpKindField", { fg = palette.green_base })
hi("BlinkCmpKindVariable", { fg = palette.fg })
hi("BlinkCmpKindClass", { fg = palette.success })
hi("BlinkCmpKindInterface", { fg = palette.success })
hi("BlinkCmpKindModule", { fg = palette.green_cool })
hi("BlinkCmpKindProperty", { fg = palette.green_base })
hi("BlinkCmpKindKeyword", { fg = palette.green_warm })
hi("BlinkCmpKindSnippet", { fg = palette.green_lighter })
hi("BlinkCmpKindConstant", { fg = palette.green_base })
hi("BlinkCmpKindEnum", { fg = palette.success })
hi("BlinkCmpKindStruct", { fg = palette.success })

hi("NormalFloat", { fg = palette.fg, bg = palette.bg1 })
hi("FloatBorder", { fg = palette.border, bg = palette.bg1 })
hi("FloatTitle", { fg = palette.success, bg = palette.bg1, bold = true })
hi("FloatFooter", { fg = palette.fg_dim, bg = palette.bg1 })
