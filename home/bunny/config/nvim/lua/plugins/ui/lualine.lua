local function lsp_name()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return "No LSP" end
  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  return " " .. table.concat(names, ", ")
end

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      theme = "auto",
      options = {
        component_separators = { left = "", right = "" },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { lsp_name },
        lualine_z = { 'location' }
      },
    },
  }
}
