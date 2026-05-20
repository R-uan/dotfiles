-- forest_dark.nvim
-- A muted forest-green theme with transparent background
-- Generated from the forest-dark design palette

local M = {}

vim.g.colors_name = "forestdark"

local palette = {
  -- Base scale
  colour0   = "#1a2a1c",
  colour1   = "#263328",
  colour2   = "#374a39",
  colour3   = "#5c7060",
  colour4   = "#83977f",
  colour5   = "#8d9e82",
  colour6   = "#a3b89e",
  colour7   = "#c2d4bc",

  -- Semantic
  success   = "#7a9e78",
  warning   = "#a8a87a",
  error     = "#a07a7a",
  muted     = "#536655",

  -- Primary
  primary0  = "#83977f",
  primary1  = "#8d9e82",
  primary2  = "#263328",
  primary3  = "#5c7060",
  primary0h = "#9aad96", -- hover
  primary2h = "#374a39", -- hover

  -- Backgrounds
  bg0       = "NONE", -- transparent
  bg1       = "#1c231e",
  bg2       = "#263328",
  border    = "#1c231e",

  -- Foregrounds
  fg0       = "#D3C6AA",
  fg1       = "#e8e0cd",

  -- Extras
  none      = "NONE",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

function M.setup()
  vim.cmd "highlight clear"
  if vim.fn.exists "syntax_on" then
    vim.cmd "syntax reset"
  end
  vim.o.background = "dark"
  vim.g.colors_name = "forest_dark"

  local p = palette

  -- ─── Editor ──────────────────────────────────────────────────────────────
  hi("Normal", { fg = p.fg0, bg = p.none })
  hi("NormalNC", { fg = p.fg0, bg = p.none })
  hi("NormalFloat", { fg = p.fg0, bg = p.bg1 })
  hi("FloatBorder", { fg = p.border, bg = p.bg1 })
  hi("FloatTitle", { fg = p.primary0, bg = p.bg1, bold = true })

  hi("Cursor", { fg = p.bg0, bg = p.fg0 })
  hi("CursorLine", { bg = p.bg1 })
  hi("CursorLineNr", { fg = p.primary0, bg = p.none, bold = true })
  hi("CursorColumn", { bg = p.bg1 })
  hi("ColorColumn", { bg = p.bg1 })

  hi("LineNr", { fg = p.muted, bg = p.none })
  hi("SignColumn", { fg = p.muted, bg = p.none })
  hi("FoldColumn", { fg = p.muted, bg = p.none })
  hi("Folded", { fg = p.colour4, bg = p.bg1 })

  hi("VertSplit", { fg = p.border, bg = p.none })
  hi("WinSeparator", { fg = p.border, bg = p.none })
  hi("StatusLine", { fg = p.fg0, bg = p.bg1 })
  hi("StatusLineNC", { fg = p.muted, bg = p.bg1 })

  hi("TabLine", { fg = p.muted, bg = p.bg1 })
  hi("TabLineFill", { fg = p.none, bg = p.bg1 })
  hi("TabLineSel", { fg = p.fg1, bg = p.bg2, bold = true })

  hi("Pmenu", { fg = p.fg0, bg = p.bg1 })
  hi("PmenuSel", { fg = p.fg1, bg = p.colour2, bold = true })
  hi("PmenuSbar", { bg = p.bg1 })
  hi("PmenuThumb", { bg = p.colour3 })
  hi("PmenuExtra", { fg = p.muted, bg = p.bg1 })
  hi("PmenuExtraSel", { fg = p.colour6, bg = p.colour2 })

  hi("Visual", { bg = p.colour2 })
  hi("VisualNOS", { bg = p.colour2 })

  hi("Search", { fg = p.colour0, bg = p.warning })
  hi("IncSearch", { fg = p.colour0, bg = p.primary0h, bold = true })
  hi("CurSearch", { fg = p.colour0, bg = p.primary0h, bold = true })
  hi("Substitute", { fg = p.colour0, bg = p.success })

  hi("MatchParen", { fg = p.fg1, bg = p.colour2, bold = true })

  hi("WildMenu", { fg = p.fg1, bg = p.colour2 })
  hi("QuickFixLine", { fg = p.fg1, bg = p.colour2, bold = true })

  hi("NonText", { fg = p.colour3 })
  hi("SpecialKey", { fg = p.colour3 })
  hi("Whitespace", { fg = p.colour2 })
  hi("EndOfBuffer", { fg = p.colour2 })
  hi("Conceal", { fg = p.muted })

  hi("Directory", { fg = p.primary0, bold = true })
  hi("Title", { fg = p.primary0, bold = true })
  hi("Question", { fg = p.success })
  hi("MoreMsg", { fg = p.success })
  hi("ModeMsg", { fg = p.fg1 })
  hi("MsgArea", { fg = p.fg0, bg = p.none })
  hi("MsgSeparator", { fg = p.border, bg = p.bg1 })

  hi("ErrorMsg", { fg = p.error, bold = true })
  hi("WarningMsg", { fg = p.warning, bold = true })

  hi("SpellBad", { sp = p.error, undercurl = true })
  hi("SpellCap", { sp = p.warning, undercurl = true })
  hi("SpellRare", { sp = p.primary0, undercurl = true })
  hi("SpellLocal", { sp = p.success, undercurl = true })

  -- ─── Syntax ──────────────────────────────────────────────────────────────
  hi("Comment", { fg = p.muted, italic = true })
  hi("SpecialComment", { fg = p.colour4, italic = true })

  hi("Constant", { fg = p.colour6 })
  hi("String", { fg = p.colour7 })
  hi("Character", { fg = p.colour7 })
  hi("Number", { fg = p.colour6 })
  hi("Boolean", { fg = p.colour5, bold = true })
  hi("Float", { fg = p.colour6 })

  hi("Identifier", { fg = p.fg0 })
  hi("Function", { fg = p.primary1, bold = true })

  hi("Statement", { fg = p.primary0 })
  hi("Conditional", { fg = p.primary0 })
  hi("Repeat", { fg = p.primary0 })
  hi("Label", { fg = p.primary0 })
  hi("Operator", { fg = p.colour5 })
  hi("Keyword", { fg = p.primary0, bold = true })
  hi("Exception", { fg = p.error })

  hi("PreProc", { fg = p.colour5 })
  hi("Include", { fg = p.colour5 })
  hi("Define", { fg = p.colour5 })
  hi("Macro", { fg = p.colour5 })
  hi("PreCondit", { fg = p.colour5 })

  hi("Type", { fg = p.colour6 })
  hi("StorageClass", { fg = p.colour6 })
  hi("Structure", { fg = p.colour6 })
  hi("Typedef", { fg = p.colour6 })

  hi("Special", { fg = p.colour5 })
  hi("SpecialChar", { fg = p.colour5 })
  hi("Tag", { fg = p.primary0 })
  hi("Delimiter", { fg = p.colour4 })

  hi("Underlined", { fg = p.primary0h, underline = true })
  hi("Bold", { bold = true })
  hi("Italic", { italic = true })

  hi("Error", { fg = p.error, bold = true })
  hi("Todo", { fg = p.colour0, bg = p.warning, bold = true })

  -- ─── Diff ─────────────────────────────────────────────────────────────────
  hi("DiffAdd", { fg = p.success, bg = "#1e2e1e" })
  hi("DiffChange", { fg = p.warning, bg = "#2a2a1a" })
  hi("DiffDelete", { fg = p.error, bg = "#2a1a1a" })
  hi("DiffText", { fg = p.fg1, bg = "#2a2a1a", bold = true })
  hi("Added", { fg = p.success })
  hi("Changed", { fg = p.warning })
  hi("Removed", { fg = p.error })

  -- ─── Diagnostics ─────────────────────────────────────────────────────────
  hi("DiagnosticError", { fg = p.error })
  hi("DiagnosticWarn", { fg = p.warning })
  hi("DiagnosticInfo", { fg = p.primary0 })
  hi("DiagnosticHint", { fg = p.colour5 })
  hi("DiagnosticOk", { fg = p.success })

  hi("DiagnosticUnderlineError", { sp = p.error, undercurl = true })
  hi("DiagnosticUnderlineWarn", { sp = p.warning, undercurl = true })
  hi("DiagnosticUnderlineInfo", { sp = p.primary0, undercurl = true })
  hi("DiagnosticUnderlineHint", { sp = p.colour5, undercurl = true })

  hi("DiagnosticVirtualTextError", { fg = p.error, bg = "#2a1a1a", italic = true })
  hi("DiagnosticVirtualTextWarn", { fg = p.warning, bg = "#2a2a1a", italic = true })
  hi("DiagnosticVirtualTextInfo", { fg = p.primary0, bg = p.bg1, italic = true })
  hi("DiagnosticVirtualTextHint", { fg = p.colour5, bg = p.bg1, italic = true })

  hi("DiagnosticSignError", { fg = p.error })
  hi("DiagnosticSignWarn", { fg = p.warning })
  hi("DiagnosticSignInfo", { fg = p.primary0 })
  hi("DiagnosticSignHint", { fg = p.colour5 })

  -- ─── LSP ──────────────────────────────────────────────────────────────────
  hi("LspReferenceText", { bg = p.colour2 })
  hi("LspReferenceRead", { bg = p.colour2 })
  hi("LspReferenceWrite", { bg = p.colour2, bold = true })
  hi("LspSignatureActiveParameter", { fg = p.fg1, bg = p.colour2, bold = true })
  hi("LspInlayHint", { fg = p.muted, bg = p.bg1, italic = true })
  hi("LspCodeLens", { fg = p.muted, italic = true })
  hi("LspCodeLensSeparator", { fg = p.colour3 })

  -- ─── Treesitter ───────────────────────────────────────────────────────────
  -- Identifiers
  hi("@variable", { fg = p.fg0 })
  hi("@variable.builtin", { fg = p.colour5, italic = true })
  hi("@variable.parameter", { fg = p.fg0, italic = true })
  hi("@variable.member", { fg = p.colour6 })
  hi("@constant", { fg = p.colour6 })
  hi("@constant.builtin", { fg = p.colour6, bold = true })
  hi("@constant.macro", { fg = p.colour5 })

  -- Literals
  hi("@string", { fg = p.colour7 })
  hi("@string.escape", { fg = p.colour5 })
  hi("@string.special", { fg = p.colour5 })
  hi("@string.regexp", { fg = p.colour5, italic = true })
  hi("@character", { fg = p.colour7 })
  hi("@number", { fg = p.colour6 })
  hi("@number.float", { fg = p.colour6 })
  hi("@boolean", { fg = p.colour5, bold = true })

  -- Functions
  hi("@function", { fg = p.primary1, bold = true })
  hi("@function.builtin", { fg = p.primary0h, bold = true })
  hi("@function.macro", { fg = p.colour5 })
  hi("@function.call", { fg = p.primary1 })
  hi("@function.method", { fg = p.primary1, bold = true })
  hi("@function.method.call", { fg = p.primary1 })
  hi("@constructor", { fg = p.colour6 })

  -- Keywords
  hi("@keyword", { fg = p.primary0, bold = true })
  hi("@keyword.function", { fg = p.primary0, bold = true })
  hi("@keyword.operator", { fg = p.colour5 })
  hi("@keyword.import", { fg = p.colour5 })
  hi("@keyword.return", { fg = p.primary0 })
  hi("@keyword.exception", { fg = p.error })
  hi("@keyword.conditional", { fg = p.primary0 })
  hi("@keyword.repeat", { fg = p.primary0 })
  hi("@keyword.modifier", { fg = p.colour5 })

  -- Types
  hi("@type", { fg = p.colour6 })
  hi("@type.builtin", { fg = p.colour6, bold = true })
  hi("@type.definition", { fg = p.colour6 })
  hi("@attribute", { fg = p.colour5 })
  hi("@property", { fg = p.colour6 })

  -- Operators / punctuation
  hi("@operator", { fg = p.colour5 })
  hi("@punctuation.delimiter", { fg = p.colour4 })
  hi("@punctuation.bracket", { fg = p.colour4 })
  hi("@punctuation.special", { fg = p.colour5 })

  -- Markup
  hi("@markup.heading", { fg = p.primary0, bold = true })
  hi("@markup.heading.1", { fg = p.fg1, bold = true })
  hi("@markup.heading.2", { fg = p.primary0h, bold = true })
  hi("@markup.heading.3", { fg = p.primary0, bold = true })
  hi("@markup.heading.4", { fg = p.colour6, bold = true })
  hi("@markup.heading.5", { fg = p.colour5, bold = true })
  hi("@markup.heading.6", { fg = p.colour4, bold = true })
  hi("@markup.strong", { fg = p.fg1, bold = true })
  hi("@markup.italic", { fg = p.fg0, italic = true })
  hi("@markup.strikethrough", { fg = p.muted, strikethrough = true })
  hi("@markup.underline", { underline = true })
  hi("@markup.quote", { fg = p.colour6, italic = true })
  hi("@markup.math", { fg = p.colour5 })
  hi("@markup.link", { fg = p.primary0h, underline = true })
  hi("@markup.link.label", { fg = p.primary0 })
  hi("@markup.link.url", { fg = p.muted, underline = true })
  hi("@markup.raw", { fg = p.colour7, bg = p.bg1 })
  hi("@markup.raw.block", { fg = p.colour7, bg = p.bg1 })
  hi("@markup.list", { fg = p.colour5 })
  hi("@markup.list.checked", { fg = p.success })
  hi("@markup.list.unchecked", { fg = p.muted })

  -- Comments / docs
  hi("@comment", { fg = p.muted, italic = true })
  hi("@comment.documentation", { fg = p.colour4, italic = true })
  hi("@comment.error", { fg = p.error, bold = true })
  hi("@comment.warning", { fg = p.warning, bold = true })
  hi("@comment.todo", { fg = p.colour0, bg = p.warning, bold = true })
  hi("@comment.note", { fg = p.colour0, bg = p.primary0, bold = true })

  -- Tag (HTML/JSX/TSX)
  hi("@tag", { fg = p.primary0 })
  hi("@tag.builtin", { fg = p.primary0, bold = true })
  hi("@tag.attribute", { fg = p.colour6, italic = true })
  hi("@tag.delimiter", { fg = p.colour4 })

  -- Namespace
  hi("@module", { fg = p.colour5 })
  hi("@module.builtin", { fg = p.colour5, bold = true })
  hi("@label", { fg = p.primary0 })

  -- ─── Telescope ────────────────────────────────────────────────────────────
  -- Semi-transparent bg: requires a terminal with true-color + compositor support.
  -- Set vim.o.winblend / telescope's winblend opt to taste (e.g. 10-20).
  local tele_bg = "#171919"
  hi("TelescopeNormal", { fg = p.fg0, bg = tele_bg })
  hi("TelescopeBorder", { fg = "#2a2e2b", bg = tele_bg })
  hi("TelescopeTitle", { fg = p.primary0, bg = tele_bg, bold = true })
  hi("TelescopePromptNormal", { fg = p.fg1, bg = "#1e2420" })
  hi("TelescopePromptBorder", { fg = "#2a2e2b", bg = "#1e2420" })
  hi("TelescopePromptTitle", { fg = p.fg1, bg = "#1e2420", bold = true })
  hi("TelescopePromptPrefix", { fg = p.primary0, bg = "#1e2420" })
  hi("TelescopePromptCounter", { fg = p.muted, bg = "#1e2420" })
  hi("TelescopeResultsNormal", { fg = p.fg0, bg = tele_bg })
  hi("TelescopeResultsBorder", { fg = "#2a2e2b", bg = tele_bg })
  hi("TelescopeResultsTitle", { fg = p.muted, bg = tele_bg })
  hi("TelescopePreviewNormal", { fg = p.fg0, bg = tele_bg })
  hi("TelescopePreviewBorder", { fg = "#2a2e2b", bg = tele_bg })
  hi("TelescopePreviewTitle", { fg = p.colour6, bg = tele_bg, bold = true })
  hi("TelescopeSelection", { fg = p.fg1, bg = p.colour2 })
  hi("TelescopeSelectionCaret", { fg = p.primary0, bg = p.colour2 })
  hi("TelescopeMatching", { fg = p.primary0h, bold = true })
  hi("TelescopeMultiSelection", { fg = p.colour6, bg = p.colour2 })
  -- For actual transparency, add to your telescope config:
  --   defaults = { winblend = 10 }

  -- ─── nvim-tree / neo-tree ─────────────────────────────────────────────────
  hi("NvimTreeNormal", { fg = p.fg0, bg = p.none })
  hi("NvimTreeNormalNC", { fg = p.fg0, bg = p.none })
  hi("NvimTreeRootFolder", { fg = p.primary0, bold = true })
  hi("NvimTreeFolderName", { fg = p.colour6 })
  hi("NvimTreeFolderIcon", { fg = p.primary0 })
  hi("NvimTreeOpenedFolderName", { fg = p.primary0h, bold = true })
  hi("NvimTreeEmptyFolderName", { fg = p.muted })
  hi("NvimTreeFileName", { fg = p.fg0 })
  hi("NvimTreeOpenedFile", { fg = p.fg1, bold = true })
  hi("NvimTreeModifiedFile", { fg = p.warning })
  hi("NvimTreeExecFile", { fg = p.success, bold = true })
  hi("NvimTreeSpecialFile", { fg = p.colour5 })
  hi("NvimTreeSymlink", { fg = p.colour5 })
  hi("NvimTreeIndentMarker", { fg = p.colour2 })
  hi("NvimTreeGitDirty", { fg = p.warning })
  hi("NvimTreeGitStaged", { fg = p.success })
  hi("NvimTreeGitNew", { fg = p.success })
  hi("NvimTreeGitDeleted", { fg = p.error })
  hi("NvimTreeWinSeparator", { fg = p.border })

  -- ─── Which-key ────────────────────────────────────────────────────────────
  hi("WhichKey", { fg = p.primary0 })
  hi("WhichKeyGroup", { fg = p.colour6, bold = true })
  hi("WhichKeyDesc", { fg = p.fg0 })
  hi("WhichKeySeparator", { fg = p.muted })
  hi("WhichKeyFloat", { bg = p.bg1 })
  hi("WhichKeyBorder", { fg = p.border, bg = p.bg1 })
  hi("WhichKeyValue", { fg = p.muted })

  -- ─── GitSigns ─────────────────────────────────────────────────────────────
  hi("GitSignsAdd", { fg = p.success })
  hi("GitSignsChange", { fg = p.warning })
  hi("GitSignsDelete", { fg = p.error })
  hi("GitSignsAddNr", { fg = p.success })
  hi("GitSignsChangeNr", { fg = p.warning })
  hi("GitSignsDeleteNr", { fg = p.error })
  hi("GitSignsAddLn", { bg = "#1e2e1e" })
  hi("GitSignsChangeLn", { bg = "#2a2a1a" })
  hi("GitSignsAddPreview", { fg = p.success, bg = "#1e2e1e" })
  hi("GitSignsDeletePreview", { fg = p.error, bg = "#2a1a1a" })

  -- ─── Indent-blankline ─────────────────────────────────────────────────────
  hi("IblIndent", { fg = p.colour2 })
  hi("IblScope", { fg = p.colour3 })
  hi("IndentBlanklineChar", { fg = p.colour2 })
  hi("IndentBlanklineContextChar", { fg = p.colour3 })

  -- ─── Mini.nvim / misc popular ─────────────────────────────────────────────
  hi("MiniCursorword", { bg = p.colour2 })
  hi("MiniCursorwordCurrent", { bg = p.colour2 })
  hi("MiniStatuslineModeNormal", { fg = p.colour0, bg = p.primary0, bold = true })
  hi("MiniStatuslineModeInsert", { fg = p.colour0, bg = p.success, bold = true })
  hi("MiniStatuslineModeVisual", { fg = p.colour0, bg = p.colour6, bold = true })
  hi("MiniStatuslineModeReplace", { fg = p.colour0, bg = p.error, bold = true })
  hi("MiniStatuslineModeCommand", { fg = p.colour0, bg = p.warning, bold = true })
  hi("MiniStatuslineFilename", { fg = p.fg0, bg = p.bg1 })
  hi("MiniStatuslineFileinfo", { fg = p.muted, bg = p.bg1 })
  hi("MiniStatuslineDevinfo", { fg = p.colour5, bg = p.bg1 })
  hi("MiniTablineTabpagesection", { fg = p.colour0, bg = p.primary0, bold = true })

  hi("NotifyERRORBorder", { fg = p.error })
  hi("NotifyWARNBorder", { fg = p.warning })
  hi("NotifyINFOBorder", { fg = p.primary0 })
  hi("NotifyDEBUGBorder", { fg = p.muted })
  hi("NotifyTRACEBorder", { fg = p.colour5 })
  hi("NotifyERRORIcon", { fg = p.error })
  hi("NotifyWARNIcon", { fg = p.warning })
  hi("NotifyINFOIcon", { fg = p.primary0 })
  hi("NotifyERRORTitle", { fg = p.error, bold = true })
  hi("NotifyWARNTitle", { fg = p.warning, bold = true })
  hi("NotifyINFOTitle", { fg = p.primary0, bold = true })
  hi("NotifyERRORBody", { fg = p.fg0 })
  hi("NotifyWARNBody", { fg = p.fg0 })
  hi("NotifyINFOBody", { fg = p.fg0 })

  -- ─── Noice ────────────────────────────────────────────────────────────────
  hi("NoicePopup", { fg = p.fg0, bg = p.bg1 })
  hi("NoicePopupBorder", { fg = p.border, bg = p.bg1 })
  hi("NoiceCmdlinePopup", { fg = p.fg0, bg = p.bg2 })
  hi("NoiceCmdlinePopupBorder", { fg = p.colour2, bg = p.bg2 })
  hi("NoiceCmdlineIcon", { fg = p.primary0, bg = p.bg2 })
  hi("NoiceConfirm", { fg = p.fg0, bg = p.bg1 })
  hi("NoiceConfirmBorder", { fg = p.border, bg = p.bg1 })

  -- ─── Cmp ──────────────────────────────────────────────────────────────────
  hi("CmpItemAbbr", { fg = p.fg0 })
  hi("CmpItemAbbrMatch", { fg = p.primary0h, bold = true })
  hi("CmpItemAbbrMatchFuzzy", { fg = p.primary0, bold = true })
  hi("CmpItemAbbrDeprecated", { fg = p.muted, strikethrough = true })
  hi("CmpItemKind", { fg = p.colour5 })
  hi("CmpItemKindFunction", { fg = p.primary1 })
  hi("CmpItemKindMethod", { fg = p.primary1 })
  hi("CmpItemKindConstructor", { fg = p.colour6 })
  hi("CmpItemKindClass", { fg = p.colour6 })
  hi("CmpItemKindVariable", { fg = p.fg0 })
  hi("CmpItemKindField", { fg = p.colour6 })
  hi("CmpItemKindKeyword", { fg = p.primary0 })
  hi("CmpItemKindSnippet", { fg = p.warning })
  hi("CmpItemKindText", { fg = p.fg0 })
  hi("CmpItemMenu", { fg = p.muted, italic = true })
  hi("CmpNormal", { bg = p.bg1 })
  hi("CmpBorder", { fg = p.border, bg = p.bg1 })
  hi("CmpDocNormal", { bg = p.bg1 })
  hi("CmpDocBorder", { fg = p.border, bg = p.bg1 })
  hi("CmpGhostText", { fg = p.muted, italic = true })
  hi("CmpSel", { bg = p.colour2, bold = true })

  -- ─── Lazy.nvim ────────────────────────────────────────────────────────────
  hi("LazyNormal", { fg = p.fg0, bg = p.bg1 })
  hi("LazyBorder", { fg = p.border, bg = p.bg1 })
  hi("LazyButton", { fg = p.fg0, bg = p.colour2 })
  hi("LazyButtonActive", { fg = p.fg1, bg = p.primary0, bold = true })
  hi("LazyH1", { fg = p.primary0, bold = true })
  hi("LazyH2", { fg = p.colour6, bold = true })
  hi("LazySpecial", { fg = p.primary0 })
  hi("LazyCommit", { fg = p.colour6 })
  hi("LazyCommitIssue", { fg = p.warning })
  hi("LazyCommitType", { fg = p.colour5 })
  hi("LazyCommitScope", { fg = p.muted, italic = true })
  hi("LazyReasonPlugin", { fg = p.colour5 })
  hi("LazyReasonKeys", { fg = p.primary0 })
  hi("LazyReasonStart", { fg = p.success })
  hi("LazyReasonSource", { fg = p.colour6 })
  hi("LazyReasonFt", { fg = p.warning })
  hi("LazyReasonCmd", { fg = p.colour5 })
  hi("LazyReasonEvent", { fg = p.colour4 })
  hi("LazyReasonRuntime", { fg = p.muted })
  hi("LazyProgressDone", { fg = p.success })
  hi("LazyProgressTodo", { fg = p.muted })
  hi("LazyDimmed", { fg = p.muted })
  hi("LazyProp", { fg = p.colour6 })
  hi("LazyValue", { fg = p.fg0 })
  hi("LazyUrl", { fg = p.primary0h, underline = true })
  hi("LazyDir", { fg = p.colour6 })
  hi("LazyLocal", { fg = p.success })
  hi("LazyTaskOutput", { fg = p.fg0 })
  hi("LazyTaskError", { fg = p.error })

  -- ─── Mason ────────────────────────────────────────────────────────────────
  hi("MasonNormal", { fg = p.fg0, bg = p.bg1 })
  hi("MasonHeader", { fg = p.fg1, bg = p.primary0, bold = true })
  hi("MasonHeaderSecondary", { fg = p.fg1, bg = p.colour3, bold = true })
  hi("MasonHighlight", { fg = p.primary0 })
  hi("MasonHighlightBlock", { fg = p.colour0, bg = p.primary0 })
  hi("MasonHighlightBlockBold", { fg = p.colour0, bg = p.primary0, bold = true })
  hi("MasonHighlightSecondary", { fg = p.colour6 })
  hi("MasonHighlightBlockSecondary", { fg = p.colour0, bg = p.colour3 })
  hi("MasonHighlightBlockBoldSecondary", { fg = p.colour0, bg = p.colour3, bold = true })
  hi("MasonMuted", { fg = p.muted })
  hi("MasonMutedBlock", { fg = p.fg0, bg = p.colour2 })
  hi("MasonMutedBlockBold", { fg = p.fg1, bg = p.colour2, bold = true })
  hi("MasonError", { fg = p.error })
  hi("MasonWarning", { fg = p.warning })
  hi("MasonLink", { fg = p.primary0h, underline = true })

  -- ─── snacks.nvim (LazyVim core: dashboard, notifier, indent, input) ─────────
  hi("SnacksDashboardNormal", { fg = p.fg0, bg = p.none })
  hi("SnacksDashboardHeader", { fg = p.primary0, bold = true })
  hi("SnacksDashboardTitle", { fg = p.primary0h, bold = true })
  hi("SnacksDashboardDesc", { fg = p.fg0 })
  hi("SnacksDashboardKey", { fg = p.primary0, bold = true })
  hi("SnacksDashboardIcon", { fg = p.colour5 })
  hi("SnacksDashboardFooter", { fg = p.muted, italic = true })
  hi("SnacksDashboardSpecial", { fg = p.colour5 })
  hi("SnacksDashboardDir", { fg = p.colour6 })
  hi("SnacksNotifierBorderError", { fg = p.error })
  hi("SnacksNotifierBorderWarn", { fg = p.warning })
  hi("SnacksNotifierBorderInfo", { fg = p.primary0 })
  hi("SnacksNotifierBorderDebug", { fg = p.muted })
  hi("SnacksNotifierBorderTrace", { fg = p.colour5 })
  hi("SnacksNotifierIconError", { fg = p.error })
  hi("SnacksNotifierIconWarn", { fg = p.warning })
  hi("SnacksNotifierIconInfo", { fg = p.primary0 })
  hi("SnacksNotifierIconDebug", { fg = p.muted })
  hi("SnacksNotifierIconTrace", { fg = p.colour5 })
  hi("SnacksNotifierTitleError", { fg = p.error, bold = true })
  hi("SnacksNotifierTitleWarn", { fg = p.warning, bold = true })
  hi("SnacksNotifierTitleInfo", { fg = p.primary0, bold = true })
  hi("SnacksNotifierTitleDebug", { fg = p.muted, bold = true })
  hi("SnacksNotifierTitleTrace", { fg = p.colour5, bold = true })
  hi("SnacksIndent", { fg = p.colour2 })
  hi("SnacksIndentScope", { fg = p.colour3 })
  hi("SnacksInput", { fg = p.fg0, bg = p.bg2 })
  hi("SnacksInputBorder", { fg = p.colour2, bg = p.bg2 })
  hi("SnacksInputTitle", { fg = p.fg1, bg = p.bg2, bold = true })
  hi("SnacksInputPrompt", { fg = p.primary0, bg = p.bg2 })
  hi("SnacksPickerNormal", { fg = p.fg0, bg = p.bg1 })
  hi("SnacksPickerBorder", { fg = p.border, bg = p.bg1 })
  hi("SnacksPickerTitle", { fg = p.primary0, bg = p.bg1, bold = true })
  hi("SnacksPickerMatch", { fg = p.primary0h, bold = true })
  hi("SnacksPickerSelected", { fg = p.fg1, bg = p.colour2 })
  hi("SnacksPickerCursor", { fg = p.primary0, bg = p.colour2 })
  hi("SnacksPickerPrompt", { fg = p.primary0, bg = p.bg2 })
  hi("SnacksPickerPromptBorder", { fg = p.colour2, bg = p.bg2 })
  hi("SnacksPickerPreview", { fg = p.fg0, bg = p.bg1 })
  hi("SnacksPickerPreviewBorder", { fg = p.border, bg = p.bg1 })
  hi("SnacksScroll", { fg = p.colour3, bg = p.bg1 })
  hi("SnacksWords", { bg = p.colour2 })
  hi("SnacksZenIcon", { fg = p.primary0 })
  hi("SnacksProfilerBadge", { fg = p.colour0, bg = p.primary0 })

  -- ─── bufferline.nvim ──────────────────────────────────────────────────────
  hi("BufferLineBackground", { fg = p.muted, bg = p.bg1 })
  hi("BufferLineFill", { bg = p.none })
  hi("BufferLineBufferSelected", { fg = p.fg1, bg = p.none, bold = true })
  hi("BufferLineBufferVisible", { fg = p.colour5, bg = p.bg1 })
  hi("BufferLineCloseButton", { fg = p.muted, bg = p.bg1 })
  hi("BufferLineCloseButtonSelected", { fg = p.error, bg = p.none })
  hi("BufferLineCloseButtonVisible", { fg = p.muted, bg = p.bg1 })
  hi("BufferLineSeparator", { fg = p.border, bg = p.bg1 })
  hi("BufferLineSeparatorSelected", { fg = p.border, bg = p.none })
  hi("BufferLineSeparatorVisible", { fg = p.border, bg = p.bg1 })
  hi("BufferLineIndicatorSelected", { fg = p.primary0, bg = p.none })
  hi("BufferLineIndicatorVisible", { fg = p.colour3, bg = p.bg1 })
  hi("BufferLineModified", { fg = p.warning, bg = p.bg1 })
  hi("BufferLineModifiedSelected", { fg = p.warning, bg = p.none })
  hi("BufferLineModifiedVisible", { fg = p.warning, bg = p.bg1 })
  hi("BufferLineError", { fg = p.error, bg = p.bg1 })
  hi("BufferLineErrorSelected", { fg = p.error, bg = p.none, bold = true })
  hi("BufferLineErrorVisible", { fg = p.error, bg = p.bg1 })
  hi("BufferLineWarning", { fg = p.warning, bg = p.bg1 })
  hi("BufferLineWarningSelected", { fg = p.warning, bg = p.none, bold = true })
  hi("BufferLineWarningVisible", { fg = p.warning, bg = p.bg1 })
  hi("BufferLineInfo", { fg = p.primary0, bg = p.bg1 })
  hi("BufferLineInfoSelected", { fg = p.primary0, bg = p.none, bold = true })
  hi("BufferLineInfoVisible", { fg = p.primary0, bg = p.bg1 })
  hi("BufferLineHint", { fg = p.colour5, bg = p.bg1 })
  hi("BufferLineHintSelected", { fg = p.colour5, bg = p.none, bold = true })
  hi("BufferLineHintVisible", { fg = p.colour5, bg = p.bg1 })
  hi("BufferLineDiagnostic", { fg = p.muted, bg = p.bg1 })
  hi("BufferLineDiagnosticSelected", { fg = p.muted, bg = p.none })
  hi("BufferLineTab", { fg = p.muted, bg = p.bg1 })
  hi("BufferLineTabSelected", { fg = p.fg1, bg = p.none, bold = true })
  hi("BufferLineTabSeparator", { fg = p.border, bg = p.none })
  hi("BufferLineTabSeparatorSelected", { fg = p.border, bg = p.none })
  hi("BufferLineNumbers", { fg = p.muted, bg = p.bg1 })
  hi("BufferLineNumbersSelected", { fg = p.fg1, bg = p.none, bold = true })
  hi("BufferLineNumbersVisible", { fg = p.colour5, bg = p.bg1 })
  hi("BufferLineGroupLabel", { fg = p.colour0, bg = p.primary0, bold = true })
  hi("BufferLineGroupSeparator", { fg = p.colour3, bg = p.bg1 })
  hi("BufferLineTruncMarker", { fg = p.muted, bg = p.bg1 })
  hi("BufferLineOffsetSeparator", { fg = p.border, bg = p.bg1 })
  hi("BufferLinePickSelected", { fg = p.error, bg = p.none, bold = true, italic = true })
  hi("BufferLinePickVisible", { fg = p.error, bg = p.bg1, bold = true, italic = true })
  hi("BufferLinePick", { fg = p.error, bg = p.bg1, bold = true, italic = true })

  -- ─── neo-tree.nvim ────────────────────────────────────────────────────────
  hi("NeoTreeNormal", { fg = p.fg0, bg = p.none })
  hi("NeoTreeNormalNC", { fg = p.fg0, bg = p.none })
  hi("NeoTreeWinSeparator", { fg = p.border, bg = p.none })
  hi("NeoTreeEndOfBuffer", { bg = p.none })
  hi("NeoTreeRootName", { fg = p.primary0, bold = true })
  hi("NeoTreeDirectoryName", { fg = p.colour6 })
  hi("NeoTreeDirectoryIcon", { fg = p.primary0 })
  hi("NeoTreeFileIcon", { fg = p.colour5 })
  hi("NeoTreeFileName", { fg = p.fg0 })
  hi("NeoTreeFileNameOpened", { fg = p.fg1, bold = true })
  hi("NeoTreeIndentMarker", { fg = p.colour2 })
  hi("NeoTreeExpander", { fg = p.colour3 })
  hi("NeoTreeSymbolicLinkTarget", { fg = p.colour5 })
  hi("NeoTreeFloatBorder", { fg = p.border, bg = p.bg1 })
  hi("NeoTreeFloatTitle", { fg = p.primary0, bg = p.bg1, bold = true })
  hi("NeoTreeTitleBar", { fg = p.fg1, bg = p.primary0, bold = true })
  hi("NeoTreeCursorLine", { bg = p.bg1 })
  hi("NeoTreeDimText", { fg = p.muted })
  hi("NeoTreeFilterTerm", { fg = p.primary0h, bold = true })
  hi("NeoTreeModified", { fg = p.warning })
  hi("NeoTreeMessage", { fg = p.muted, italic = true })
  hi("NeoTreeGitAdded", { fg = p.success })
  hi("NeoTreeGitConflict", { fg = p.error, bold = true })
  hi("NeoTreeGitDeleted", { fg = p.error })
  hi("NeoTreeGitIgnored", { fg = p.muted })
  hi("NeoTreeGitModified", { fg = p.warning })
  hi("NeoTreeGitUnstaged", { fg = p.warning })
  hi("NeoTreeGitUntracked", { fg = p.success, italic = true })
  hi("NeoTreeGitStaged", { fg = p.success })
  hi("NeoTreeTabActive", { fg = p.fg1, bg = p.none, bold = true })
  hi("NeoTreeTabInactive", { fg = p.muted, bg = p.bg1 })
  hi("NeoTreeTabSeparatorActive", { fg = p.border, bg = p.none })
  hi("NeoTreeTabSeparatorInactive", { fg = p.border, bg = p.bg1 })

  -- ─── flash.nvim ───────────────────────────────────────────────────────────
  hi("FlashBackdrop", { fg = p.muted })
  hi("FlashMatch", { fg = p.fg0, bg = p.colour2 })
  hi("FlashCurrent", { fg = p.colour0, bg = p.primary0, bold = true })
  hi("FlashLabel", { fg = p.colour0, bg = p.error, bold = true })
  hi("FlashPrompt", { fg = p.fg0, bg = p.bg2 })
  hi("FlashPromptIcon", { fg = p.primary0, bg = p.bg2 })
  hi("FlashCursor", { reverse = true })

  -- ─── trouble.nvim ─────────────────────────────────────────────────────────
  hi("TroubleNormal", { fg = p.fg0, bg = p.none })
  hi("TroubleNormalNC", { fg = p.fg0, bg = p.none })
  hi("TroubleText", { fg = p.fg0 })
  hi("TroubleCount", { fg = p.primary0, bg = p.colour2, bold = true })
  hi("TroubleError", { fg = p.error })
  hi("TroubleWarning", { fg = p.warning })
  hi("TroubleHint", { fg = p.colour5 })
  hi("TroubleInformation", { fg = p.primary0 })
  hi("TroubleLocation", { fg = p.muted })
  hi("TroubleCode", { fg = p.muted })
  hi("TroubleFoldIcon", { fg = p.colour3 })
  hi("TroubleIndent", { fg = p.colour2 })
  hi("TroubleSignError", { fg = p.error })
  hi("TroubleSignWarning", { fg = p.warning })
  hi("TroubleSignHint", { fg = p.colour5 })
  hi("TroubleSignInformation", { fg = p.primary0 })
  hi("TroubleSource", { fg = p.muted, italic = true })
  hi("TroublePreview", { bg = p.colour2 })

  -- ─── todo-comments.nvim ───────────────────────────────────────────────────
  hi("TodoBgTODO", { fg = p.colour0, bg = p.warning, bold = true })
  hi("TodoFgTODO", { fg = p.warning })
  hi("TodoSignTODO", { fg = p.warning })
  hi("TodoBgFIX", { fg = p.colour0, bg = p.error, bold = true })
  hi("TodoFgFIX", { fg = p.error })
  hi("TodoSignFIX", { fg = p.error })
  hi("TodoBgHACK", { fg = p.colour0, bg = p.warning, bold = true })
  hi("TodoFgHACK", { fg = p.warning })
  hi("TodoSignHACK", { fg = p.warning })
  hi("TodoBgNOTE", { fg = p.colour0, bg = p.primary0, bold = true })
  hi("TodoFgNOTE", { fg = p.primary0 })
  hi("TodoSignNOTE", { fg = p.primary0 })
  hi("TodoBgPERF", { fg = p.colour0, bg = p.colour5, bold = true })
  hi("TodoFgPERF", { fg = p.colour5 })
  hi("TodoSignPERF", { fg = p.colour5 })
  hi("TodoBgWARN", { fg = p.colour0, bg = p.warning, bold = true })
  hi("TodoFgWARN", { fg = p.warning })
  hi("TodoSignWARN", { fg = p.warning })
  hi("TodoBgTEST", { fg = p.colour0, bg = p.colour6, bold = true })
  hi("TodoFgTEST", { fg = p.colour6 })
  hi("TodoSignTEST", { fg = p.colour6 })

  -- ─── blink.cmp (LazyVim default completion engine) ───────────────────────
  hi("BlinkCmpMenu", { fg = p.fg0, bg = p.bg1 })
  hi("BlinkCmpMenuBorder", { fg = p.border, bg = p.bg1 })
  hi("BlinkCmpMenuSelection", { fg = p.fg1, bg = p.colour2, bold = true })
  hi("BlinkCmpScrollBarThumb", { bg = p.colour3 })
  hi("BlinkCmpScrollBarGutter", { bg = p.bg1 })
  hi("BlinkCmpLabel", { fg = p.fg0 })
  hi("BlinkCmpLabelDeprecated", { fg = p.muted, strikethrough = true })
  hi("BlinkCmpLabelMatch", { fg = p.primary0h, bold = true })
  hi("BlinkCmpLabelDetail", { fg = p.muted })
  hi("BlinkCmpLabelDescription", { fg = p.muted, italic = true })
  hi("BlinkCmpKind", { fg = p.colour5 })
  hi("BlinkCmpKindFunction", { fg = p.primary1 })
  hi("BlinkCmpKindMethod", { fg = p.primary1 })
  hi("BlinkCmpKindConstructor", { fg = p.colour6 })
  hi("BlinkCmpKindClass", { fg = p.colour6 })
  hi("BlinkCmpKindInterface", { fg = p.colour6 })
  hi("BlinkCmpKindStruct", { fg = p.colour6 })
  hi("BlinkCmpKindVariable", { fg = p.fg0 })
  hi("BlinkCmpKindField", { fg = p.colour6 })
  hi("BlinkCmpKindProperty", { fg = p.colour6 })
  hi("BlinkCmpKindKeyword", { fg = p.primary0 })
  hi("BlinkCmpKindSnippet", { fg = p.warning })
  hi("BlinkCmpKindText", { fg = p.fg0 })
  hi("BlinkCmpKindModule", { fg = p.colour5 })
  hi("BlinkCmpKindEnum", { fg = p.colour6 })
  hi("BlinkCmpKindEnumMember", { fg = p.colour6 })
  hi("BlinkCmpKindConstant", { fg = p.colour6 })
  hi("BlinkCmpKindTypeParameter", { fg = p.colour6 })
  hi("BlinkCmpKindUnit", { fg = p.colour5 })
  hi("BlinkCmpKindValue", { fg = p.colour6 })
  hi("BlinkCmpKindEvent", { fg = p.colour5 })
  hi("BlinkCmpKindOperator", { fg = p.colour5 })
  hi("BlinkCmpKindReference", { fg = p.colour5 })
  hi("BlinkCmpKindColor", { fg = p.colour6 })
  hi("BlinkCmpKindFile", { fg = p.colour6 })
  hi("BlinkCmpKindFolder", { fg = p.primary0 })
  hi("BlinkCmpDoc", { fg = p.fg0, bg = p.bg1 })
  hi("BlinkCmpDocBorder", { fg = p.border, bg = p.bg1 })
  hi("BlinkCmpDocCursorLine", { bg = p.colour2 })
  hi("BlinkCmpDocSeparator", { fg = p.colour3, bg = p.bg1 })
  hi("BlinkCmpSignatureHelp", { fg = p.fg0, bg = p.bg1 })
  hi("BlinkCmpSignatureHelpBorder", { fg = p.border, bg = p.bg1 })
  hi("BlinkCmpSignatureHelpActiveParameter", { fg = p.fg1, bg = p.colour2, bold = true })
  hi("BlinkCmpGhostText", { fg = p.muted, italic = true })

  -- ─── grug-far.nvim ────────────────────────────────────────────────────────
  hi("GrugFarNormal", { fg = p.fg0, bg = p.none })
  hi("GrugFarInputLabel", { fg = p.primary0, bold = true })
  hi("GrugFarInputPlaceholder", { fg = p.muted, italic = true })
  hi("GrugFarResultsHeader", { fg = p.fg1, bold = true })
  hi("GrugFarResultsLineCol", { fg = p.muted })
  hi("GrugFarResultsMatch", { fg = p.colour0, bg = p.warning })
  hi("GrugFarResultsMatchAdded", { fg = p.colour0, bg = p.success })
  hi("GrugFarResultsMatchRemoved", { fg = p.colour0, bg = p.error })
  hi("GrugFarResultsChangeIndicator", { fg = p.warning })
  hi("GrugFarResultsAddedIndicator", { fg = p.success })
  hi("GrugFarResultsRemovedIndicator", { fg = p.error })
  hi("GrugFarResultsStats", { fg = p.muted, italic = true })
  hi("GrugFarHelpHeader", { fg = p.colour6, bold = true })
  hi("GrugFarHelpWinHeader", { fg = p.fg1, bg = p.primary0, bold = true })

  -- ─── fzf-lua ──────────────────────────────────────────────────────────────
  hi("FzfLuaNormal", { fg = p.fg0, bg = p.bg1 })
  hi("FzfLuaBorder", { fg = p.border, bg = p.bg1 })
  hi("FzfLuaTitle", { fg = p.primary0, bg = p.bg1, bold = true })
  hi("FzfLuaPreviewNormal", { fg = p.fg0, bg = p.bg1 })
  hi("FzfLuaPreviewBorder", { fg = p.border, bg = p.bg1 })
  hi("FzfLuaPreviewTitle", { fg = p.colour6, bg = p.bg1, bold = true })
  hi("FzfLuaCursorLine", { bg = p.colour2 })
  hi("FzfLuaCursorLineNr", { fg = p.primary0, bg = p.colour2 })
  hi("FzfLuaSearch", { fg = p.colour0, bg = p.warning })
  hi("FzfLuaBufName", { fg = p.colour5 })
  hi("FzfLuaBufNr", { fg = p.muted })
  hi("FzfLuaBufLineNr", { fg = p.muted })
  hi("FzfLuaBufFlagCur", { fg = p.primary0 })
  hi("FzfLuaTabTitle", { fg = p.fg1, bold = true })
  hi("FzfLuaTabMarker", { fg = p.primary0 })
  hi("FzfLuaHeaderBind", { fg = p.primary0 })
  hi("FzfLuaHeaderText", { fg = p.colour6 })
  hi("FzfLuaDirIcon", { fg = p.primary0 })
  hi("FzfLuaLiveSym", { fg = p.primary0h, bold = true })
  hi("FzfLuaScrollBorderEmpty", { fg = p.border })
  hi("FzfLuaScrollBorderFull", { fg = p.primary0 })

  -- ─── mini.icons ───────────────────────────────────────────────────────────
  hi("MiniIconsAzure", { fg = "#7aacb8" })
  hi("MiniIconsBlue", { fg = "#7a92b8" })
  hi("MiniIconsCyan", { fg = "#7ab8b8" })
  hi("MiniIconsGreen", { fg = p.success })
  hi("MiniIconsGrey", { fg = p.colour5 })
  hi("MiniIconsOrange", { fg = "#b89a7a" })
  hi("MiniIconsPurple", { fg = "#9a7ab8" })
  hi("MiniIconsRed", { fg = p.error })
  hi("MiniIconsYellow", { fg = p.warning })
  hi("MiniIconsWhite", { fg = p.fg1 })

  -- ─── Lualine (theme exposed as a table) ───────────────────────────────────
  -- You can use this in your lualine config:
  --   require('lualine').setup { options = { theme = require('forest_dark').lualine } }
  M.lualine = {
    normal = {
      a = { fg = p.colour0, bg = p.primary0, gui = "bold" },
      b = { fg = p.fg0, bg = p.bg1 },
      c = { fg = p.muted, bg = p.none },
    },
    insert = {
      a = { fg = p.colour0, bg = p.success, gui = "bold" },
      b = { fg = p.fg0, bg = p.bg1 },
      c = { fg = p.muted, bg = p.none },
    },
    visual = {
      a = { fg = p.colour0, bg = p.colour6, gui = "bold" },
      b = { fg = p.fg0, bg = p.bg1 },
      c = { fg = p.muted, bg = p.none },
    },
    replace = {
      a = { fg = p.colour0, bg = p.error, gui = "bold" },
      b = { fg = p.fg0, bg = p.bg1 },
      c = { fg = p.muted, bg = p.none },
    },
    command = {
      a = { fg = p.colour0, bg = p.warning, gui = "bold" },
      b = { fg = p.fg0, bg = p.bg1 },
      c = { fg = p.muted, bg = p.none },
    },
    inactive = {
      a = { fg = p.muted, bg = p.none },
      b = { fg = p.muted, bg = p.none },
      c = { fg = p.muted, bg = p.none },
    },
  }
end

M.setup()

return M
