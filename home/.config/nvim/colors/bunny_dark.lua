-- colors/bunny_dark.lua
-- Neovim theme ported from Helix theme "bunny_dark"
-- Author: Bunny (updated)

local palette = {
	darkPurple = "#17131A",
	middPurple = "#5E4870",
	lighPurple = "#B7A1D3",
	darkGreen = "#536e50",
	middGreen = "#749e77",
	lighGreen = "#E6FFE6",
	rose = "#D46A8C",
	gray = "#CFC6C2",
	peach = "#FFD6BA",
	lavender = "#D9C3FF",

	accent = "#8B6FB4",
	accent_dark = "#6E5898",
	accent_soft = "#B7A1D3",
	accent_pink = "#C6A5BC",

	-- UI
	bg0 = "#17131A",
	bg1 = "#221B26",
	bg2 = "#312936",
	bg3 = "#4B4354",

	fg = "#E6FFE6",
	fg_muted = "#b1dab1",

	border = "#4B4354",
	grey = "#A89DB2",
	highlight = "#B7A1D3",

	-- status / feedback
	warning = "#D46A8C",
	success = "#A4CE70",
	muted_blue = "#6B85C1",

	-- convenience aliases used in the theme (keeps purple first, green as accent)
	complementary = "#749e77", -- middGreen
	complementary_soft = "#E6FFE6", -- lighGreen
}

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end
vim.o.background = "dark"
vim.g.colors_name = "bunny_dark"

local function hi(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

-- UI
hi("Normal", { fg = palette.fg, bg = palette.bg0 })
hi("Cursor", { fg = palette.bg0, bg = palette.fg })
hi("CursorLine", { bg = palette.bg1 })
hi("CursorColumn", { bg = palette.bg1 })
hi("LineNr", { fg = palette.grey })
hi("CursorLineNr", { fg = palette.fg })
hi("StatusLine", { fg = palette.fg, bg = palette.bg2 })
hi("StatusLineNC", { fg = palette.fg_muted, bg = palette.bg1 })
hi("StatusLineNormal", { fg = palette.bg0, bg = palette.accent_soft })
hi("StatusLineInsert", { fg = palette.bg0, bg = palette.highlight })
hi("StatusLineSelect", { fg = palette.bg0, bg = palette.accent_pink })
hi("Pmenu", { fg = palette.fg, bg = palette.bg2 })
hi("PmenuSel", { fg = palette.bg0, bg = palette.accent_soft })
hi("Visual", { bg = palette.bg2 })
hi("VertSplit", { fg = palette.border, bg = palette.bg0 })
hi("WinSeparator", { fg = palette.border })
hi("SignColumn", { bg = palette.bg0 })
hi("FloatBorder", { fg = palette.border, bg = palette.bg0 })
hi("Folded", { bg = palette.bg1, italic = true })

-- Syntax
-- keep purple as the primary language color, green used as a supportive hint for literals/numbers
hi("Type", { fg = palette.middPurple })
hi("Structure", { fg = palette.accent })
hi("Enum", { fg = palette.accent })
hi("Class", { fg = palette.accent })
hi("Interface", { fg = palette.accent })
hi("Function", { fg = palette.highlight })
hi("Constant", { fg = palette.accent_pink })
hi("Number", { fg = palette.complementary })
hi("String", { fg = palette.complementary_soft })
hi("Character", { fg = palette.complementary_soft })
hi("Comment", { fg = palette.grey, italic = false })
hi("Variable", { fg = palette.fg })
hi("Identifier", { fg = palette.fg })
hi("Keyword", { fg = palette.accent })
hi("Operator", { fg = palette.fg_muted })
hi("Tag", { fg = palette.accent_soft })
hi("Namespace", { fg = palette.accent })
hi("Attribute", { fg = palette.highlight })

hi("@comment", { fg = palette.grey, italic = false })
hi("@constant", { fg = palette.complementary })
hi("@constant.builtin", { fg = palette.complementary })
hi("@string", { fg = palette.complementary_soft })
hi("@number", { fg = palette.complementary })
hi("@boolean", { fg = palette.complementary })
hi("@function", { fg = palette.highlight })
hi("@function.call", { fg = palette.highlight })
hi("@method", { fg = palette.highlight })
hi("@constructor", { fg = palette.accent_soft })
hi("@type", { fg = palette.accent_soft })
hi("@type.builtin", { fg = palette.accent_soft })
hi("@variable", { fg = palette.fg })
hi("@variable.builtin", { fg = palette.accent_soft })
hi("@parameter", { fg = palette.accent_pink })
hi("@property", { fg = palette.fg })
hi("@keyword", { fg = palette.accent })
hi("@operator", { fg = palette.fg_muted })
hi("@tag", { fg = palette.accent_soft })
hi("@namespace", { fg = palette.accent })
hi("@attribute", { fg = palette.highlight })
hi("@module", { fg = palette.accent })
hi("@label", { fg = palette.complementary_soft })
hi("@punctuation", { fg = palette.grey })

-- Markup / Markdown
hi("markdownH1", { fg = palette.accent })
hi("markdownH2", { fg = palette.accent_dark })
hi("markdownH3", { fg = palette.accent_pink })
hi("markdownH4", { fg = palette.accent_soft })
hi("markdownH5", { fg = palette.complementary })
hi("markdownH6", { fg = palette.fg })
hi("markdownListMarker", { fg = palette.accent_pink })
hi("markdownBold", { bold = true })
hi("markdownItalic", { italic = true })
hi("markdownUrl", { fg = palette.highlight, underline = true })
hi("markdownLinkText", { fg = palette.accent_soft })
hi("markdownQuote", { fg = palette.fg_muted })
hi("markdownCode", { fg = palette.complementary_soft })

-- Diff
hi("DiffAdd", { fg = palette.success })
hi("DiffChange", { fg = palette.complementary_soft })
hi("DiffDelete", { fg = palette.warning })

-- Diagnostics
hi("DiagnosticHint", { sp = palette.accent_soft, undercurl = true })
hi("DiagnosticInfo", { sp = palette.complementary_soft, undercurl = true })
hi("DiagnosticWarn", { sp = palette.warning, undercurl = true })
hi("DiagnosticError", { sp = palette.rose, undercurl = true })

-- Git
hi("DiffAdded", { fg = palette.success })
hi("DiffRemoved", { fg = palette.warning })
hi("DiffChanged", { fg = palette.complementary_soft })

-- Extra UI accents
hi("Whitespace", { fg = palette.bg3 })
hi("IndentBlanklineChar", { fg = palette.bg3 })
hi("ColorColumn", { bg = palette.bg3 })
hi("MatchParen", { bg = palette.complementary_soft, fg = palette.bg0 })

-- End
