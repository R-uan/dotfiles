-- bunny purple
--

local palette = {
  -- Monochromatic purples (dark to light)
  purple_darkest = "#1a0f24",
  purple_darker = "#2d1b3d",
  purple_dark = "#3d2651",
  purple_mid = "#5a3d7a",
  purple_bright = "#7d5ba6",
  purple_light = "#a084c9",
  purple_lighter = "#c4b3dc",
  purple_lightest = "#e0d5f0",

  -- Accent purples
  accent = "#7d5ba6",        -- main purple
  accent_dark = "#5a3d7a",   -- darker purple
  accent_soft = "#a084c9",   -- light purple
  accent_bright = "#9470bd", -- bright purple

  -- UI backgrounds (transparent)
  bg0 = "NONE",
  bg1 = "NONE",
  bg2 = "#1a0f24",
  bg3 = "#2d1b3d",

  -- Foreground
  fg = "#c4b3dc",
  fg_muted = "#a084c9",

  -- UI elements
  border = "#3d2651",
  grey = "#6a5580",
  highlight = "#9470bd",

  -- Status / feedback
  warning = "#e0d5f0",
  success = "#a084c9",
  error = "#d47ba6",
}

vim.cmd "hi clear"
if vim.fn.exists "syntax_on" then
  vim.cmd "syntax reset"
end
vim.o.background = "dark"
vim.g.colors_name = "bunny_purple"

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
hi("StatusLineNormal", { fg = palette.purple_darkest, bg = palette.accent })
hi("StatusLineInsert", { fg = palette.purple_darkest, bg = palette.highlight })
hi("StatusLineSelect", { fg = palette.purple_darkest, bg = palette.accent_soft })
hi("Pmenu", { fg = palette.fg, bg = palette.bg2 })
hi("PmenuSel", { fg = palette.purple_darkest, bg = palette.accent })
hi("Visual", { bg = palette.bg2 })
hi("VertSplit", { fg = palette.border, bg = palette.bg0 })
hi("WinSeparator", { fg = palette.border })
hi("SignColumn", { bg = palette.bg0 })
hi("FloatBorder", { fg = palette.border, bg = palette.bg0 })
hi("Folded", { bg = palette.bg1, italic = true })

-- Syntax
hi("Type", { fg = palette.accent })
hi("Structure", { fg = palette.accent })
hi("Enum", { fg = palette.accent })
hi("Class", { fg = palette.accent })
hi("Interface", { fg = palette.accent })
hi("Function", { fg = palette.highlight })
hi("Constant", { fg = palette.accent_soft })
hi("Number", { fg = palette.purple_mid })
hi("String", { fg = palette.purple_light })
hi("Character", { fg = palette.purple_light })
hi("Comment", { fg = palette.grey, italic = false })
hi("Variable", { fg = palette.fg })
hi("Identifier", { fg = palette.fg })
hi("Keyword", { fg = palette.accent_bright })
hi("Operator", { fg = palette.fg_muted })
hi("Tag", { fg = palette.accent })
hi("Namespace", { fg = palette.accent_bright })
hi("Attribute", { fg = palette.highlight })

hi("@comment", { fg = palette.grey, italic = false })
hi("@constant", { fg = palette.accent_soft })
hi("@constant.builtin", { fg = palette.accent_soft })
hi("@string", { fg = palette.purple_light })
hi("@number", { fg = palette.purple_mid })
hi("@boolean", { fg = palette.purple_mid })
hi("@function", { fg = palette.highlight })
hi("@function.call", { fg = palette.highlight })
hi("@method", { fg = palette.highlight })
hi("@constructor", { fg = palette.accent })
hi("@type", { fg = palette.accent })
hi("@type.builtin", { fg = palette.accent })
hi("@variable", { fg = palette.fg })
hi("@variable.builtin", { fg = palette.accent_soft })
hi("@parameter", { fg = palette.purple_lighter })
hi("@property", { fg = palette.fg })
hi("@keyword", { fg = palette.accent_bright })
hi("@operator", { fg = palette.fg_muted })
hi("@tag", { fg = palette.accent })
hi("@namespace", { fg = palette.accent_bright })
hi("@attribute", { fg = palette.highlight })
hi("@module", { fg = palette.accent_bright })
hi("@label", { fg = palette.purple_light })
hi("@punctuation", { fg = palette.grey })

-- Markup / Markdown
hi("markdownH1", { fg = palette.accent })
hi("markdownH2", { fg = palette.highlight })
hi("markdownH3", { fg = palette.accent_soft })
hi("markdownH4", { fg = palette.purple_light })
hi("markdownH5", { fg = palette.purple_lighter })
hi("markdownH6", { fg = palette.fg })
hi("markdownListMarker", { fg = palette.accent })
hi("markdownBold", { bold = true })
hi("markdownItalic", { italic = true })
hi("markdownUrl", { fg = palette.accent_soft, underline = true })
hi("markdownLinkText", { fg = palette.purple_light })
hi("markdownQuote", { fg = palette.fg_muted })
hi("markdownCode", { fg = palette.purple_light })

-- Diff
hi("DiffAdd", { fg = palette.success })
hi("DiffChange", { fg = palette.purple_lighter })
hi("DiffDelete", { fg = palette.error })

-- Diagnostics
hi("DiagnosticHint", { sp = palette.accent_soft, undercurl = true })
hi("DiagnosticInfo", { sp = palette.purple_light, undercurl = true })
hi("DiagnosticWarn", { sp = palette.warning, undercurl = true })
hi("DiagnosticError", { sp = palette.error, undercurl = true })

-- Git
hi("DiffAdded", { fg = palette.success })
hi("DiffRemoved", { fg = palette.error })
hi("DiffChanged", { fg = palette.purple_lighter })

-- Extra UI accents
hi("Whitespace", { fg = palette.bg3 })
hi("IndentBlanklineChar", { fg = palette.bg3 })
hi("ColorColumn", { bg = palette.bg3 })
hi("MatchParen", { bg = palette.accent, fg = palette.purple_darkest })

-- End
