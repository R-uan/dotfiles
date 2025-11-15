require("config.options")
require("config.lazy")
require("config.lsp")
require("config.keymaps")

-- set color theme
vim.cmd("colorscheme bunny_dark")

-- show the diagnostic on cursor hover
vim.api.nvim_create_autocmd("CursorHold", {
	pattern = "*",
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
	end,
})

vim.diagnostic.config({
	virtual_text = {
		prefix = "",
		spacing = 1,
	}, -- inline error messages
	signs = false, -- gutter signs
	underline = false, -- underline problem
	float = { border = "rounded" },
})

vim.cmd([[
  highlight DiagnosticVirtualTextError guifg=#D46A8C guibg=NONE gui=italic
  highlight DiagnosticVirtualTextWarn  guifg=#D46A8C guibg=NONE gui=italic
  highlight DiagnosticVirtualTextInfo  guifg=#A4CE70 guibg=NONE gui=italic
  highlight DiagnosticVirtualTextHint  guifg=#A4CE70 guibg=NONE gui=italic
]])
