-- colors/green_purple.lua
-- Neovim theme with green & purple harmony

local palette = {
	-- Greens
	darkGreen = "#3d4a34",
	middGreen = "#7fb069",
	lighGreen = "#a8c69f",
	brightGreen = "#8fc277",
	
	-- Purples
	darkPurple = "#4a3358",
	middPurple = "#6b4d82",
	lighPurple = "#b692d4",
	lavender = "#d4b5e8",
	softPurple = "#c4a3e0",
	
	-- Neutrals
	bg0 = "#070707",
	bg1 = "#202020",
	bg2 = "#2a2a2a",
	bg3 = "#3a3a3a",
	
	fg = "#a8c69f",
	fg_muted = "#7fb069",
	fg_bright = "#b8d6af",
	
	-- UI elements
	border = "#2a2a2a",
	grey = "#888888",
	
	-- Status / feedback
	warning = "#d4b5e8",
	success = "#8fc277",
	error = "#b692d4",
	info = "#7fb069",
	
	-- Accent colors
	accent = "#7fb069",        -- main green
	accent_light = "#a8c69f",  -- light sage
	accent_purple = "#b692d4", -- soft purple
	accent_dark = "#556b47",   -- forest green
}

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end
vim.o.background = "dark"
vim.g.colors_name = "green_purple"

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
hi("StatusLineInsert", { fg = palette.bg0, bg = palette.brightGreen })
hi("StatusLineSelect", { fg = palette.bg0, bg = palette.accent_purple })
hi("Pmenu", { fg = palette.fg, bg = palette.bg2 })
hi("PmenuSel", { fg = palette.bg0, bg = palette.accent })
hi("Visual", { bg = palette.bg2 })
hi("VertSplit", { fg = palette.border, bg = palette.bg0 })
hi("WinSeparator", { fg = palette.border })
hi("SignColumn", { bg = palette.bg0 })
hi("FloatBorder", { fg = palette.border, bg = palette.bg0 })
hi("Folded", { bg = palette.bg1, italic = true })

-- Syntax - Green primary with purple accents
hi("Type", { fg = palette.accent })
hi("Structure", { fg = palette.accent })
hi("Enum", { fg = palette.accent })
hi("Class", { fg = palette.accent })
hi("Interface", { fg = palette.accent })
hi("Function", { fg = palette.accent_light })
hi("Constant", { fg = palette.accent_purple })
hi("Number", { fg = palette.brightGreen })
hi("String", { fg = palette.fg_bright })
hi("Character", { fg = palette.fg_bright })
hi("Comment", { fg = palette.grey, italic = false })
hi("Variable", { fg = palette.fg })
hi("Identifier", { fg = palette.fg })
hi("Keyword", { fg = palette.accent_purple })
hi("Operator", { fg = palette.fg_muted })
hi("Tag", { fg = palette.accent })
hi("Namespace", { fg = palette.accent_purple })
hi("Attribute", { fg = palette.lighPurple })

-- Treesitter
hi("@comment", { fg = palette.grey, italic = false })
hi("@constant", { fg = palette.accent_purple })
hi("@constant.builtin", { fg = palette.accent_purple })
hi("@string", { fg = palette.fg_bright })
hi("@number", { fg = palette.brightGreen })
hi("@boolean", { fg = palette.brightGreen })
hi("@function", { fg = palette.accent_light })
hi("@function.call", { fg = palette.accent_light })
hi("@method", { fg = palette.accent_light })
hi("@constructor", { fg = palette.accent })
hi("@type", { fg = palette.accent })
hi("@type.builtin", { fg = palette.accent })
hi("@variable", { fg = palette.fg })
hi("@variable.builtin", { fg = palette.accent_purple })
hi("@parameter", { fg = palette.lighPurple })
hi("@property", { fg = palette.fg })
hi("@keyword", { fg = palette.accent_purple })
hi("@operator", { fg = palette.fg_muted })
hi("@tag", { fg = palette.accent })
hi("@namespace", { fg = palette.accent_purple })
hi("@attribute", { fg = palette.lighPurple })
hi("@module", { fg = palette.accent_purple })
hi("@label", { fg = palette.brightGreen })
hi("@punctuation", { fg = palette.grey })

-- Markup / Markdown
hi("markdownH1", { fg = palette.accent })
hi("markdownH2", { fg = palette.accent_light })
hi("markdownH3", { fg = palette.accent_purple })
hi("markdownH4", { fg = palette.lighPurple })
hi("markdownH5", { fg = palette.brightGreen })
hi("markdownH6", { fg = palette.fg })
hi("markdownListMarker", { fg = palette.accent })
hi("markdownBold", { bold = true })
hi("markdownItalic", { italic = true })
hi("markdownUrl", { fg = palette.accent_purple, underline = true })
hi("markdownLinkText", { fg = palette.accent_light })
hi("markdownQuote", { fg = palette.fg_muted })
hi("markdownCode", { fg = palette.fg_bright })

-- Diff
hi("DiffAdd", { fg = palette.success })
hi("DiffChange", { fg = palette.brightGreen })
hi("DiffDelete", { fg = palette.warning })

-- Diagnostics
hi("DiagnosticHint", { sp = palette.accent_light, undercurl = true })
hi("DiagnosticInfo", { sp = palette.info, undercurl = true })
hi("DiagnosticWarn", { sp = palette.warning, undercurl = true })
hi("DiagnosticError", { sp = palette.error, undercurl = true })

-- Git
hi("DiffAdded", { fg = palette.success })
hi("DiffRemoved", { fg = palette.warning })
hi("DiffChanged", { fg = palette.brightGreen })

-- Extra UI accents
hi("Whitespace", { fg = palette.bg3 })
hi("IndentBlanklineChar", { fg = palette.bg3 })
hi("ColorColumn", { bg = palette.bg3 })
hi("MatchParen", { bg = palette.accent, fg = palette.bg0 })

-- Search
hi("Search", { fg = palette.bg0, bg = palette.accent })
hi("IncSearch", { fg = palette.bg0, bg = palette.brightGreen })

-- Telescope (if using)
hi("TelescopeBorder", { fg = palette.border })
hi("TelescopePromptBorder", { fg = palette.accent })
hi("TelescopeSelection", { fg = palette.bg0, bg = palette.accent })
hi("TelescopeMatching", { fg = palette.brightGreen })

-- End