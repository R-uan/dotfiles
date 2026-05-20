vim.cmd "colorscheme forestdark" -- set theme

vim.opt.number = true            -- leftside line counter
vim.opt.relativenumber = false   -- relative number to where cursor is
vim.opt.fillchars = "eob: "      -- idk

-- diagnostic
vim.cmd [[
  highlight DiagnosticVirtualTextError guifg=#D46A8C guibg=NONE gui=italic
  highlight DiagnosticVirtualTextWarn  guifg=#D46A8C guibg=NONE gui=italic
  highlight DiagnosticVirtualTextInfo  guifg=#A4CE70 guibg=NONE gui=italic
  highlight DiagnosticVirtualTextHint  guifg=#A4CE70 guibg=NONE gui=italic
]]

-- block folding
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- tabs
vim.opt.tabstop = 2      -- number of spaces a <Tab> counts for
vim.opt.shiftwidth = 2   -- spaces used for autoindent (>> and <<)
vim.opt.softtabstop = 2  -- how many spaces <Tab> inserts while editing
vim.opt.expandtab = true -- convert tabs to spaces


-- bufferline
vim.api.nvim_set_hl(0, "CokelineFill", { bg = "NONE" })
vim.api.nvim_set_hl(0, "CokelineBackground", { bg = "NONE" })
vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })

vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE" })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
vim.api.nvim_set_hl(0, "TabLineSel", { bg = "NONE" })

-- line number
vim.opt.winbar = " "
vim.opt.numberwidth = 5
vim.opt.statuscolumn = "%=%l    "


-- Telescope
vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopePromptCounter", { bg = "NONE", ctermbg = "NONE" })

-- Lua line
vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
vim.api.nvim_set_hl(0, 'lualine_b_filetype_normal', { bg = 'NONE' })
local sections = { 'a', 'b', 'c', 'x', 'y', 'z' }
local modes = { 'normal', 'insert', 'visual', 'replace', 'command', 'inactive' }

for _, mode in ipairs(modes) do
  for _, section in ipairs(sections) do
    local hl_name = string.format('lualine_%s_%s', section, mode)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = hl_name })
    if ok and hl then
      hl.bg = nil  -- removes background
      vim.api.nvim_set_hl(0, hl_name, hl)
    end
  end
end

local separators = {
  'lualine_transitional_lualine_a_normal_to_lualine_b_normal',
  'lualine_transitional_lualine_b_normal_to_lualine_c_normal',
  'lualine_transitional_lualine_c_normal_to_lualine_x_normal',
  'lualine_transitional_lualine_x_normal_to_lualine_y_normal',
  'lualine_transitional_lualine_y_normal_to_lualine_z_normal',
}

for _, hl_name in ipairs(separators) do
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = hl_name })
  if ok and hl then
    hl.bg = nil
    vim.api.nvim_set_hl(0, hl_name, hl)
  end
end