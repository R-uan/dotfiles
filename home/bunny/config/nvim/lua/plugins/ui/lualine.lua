return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      component_separators = { left = "", right = "" },
    },
    sections = {
      lualine_y = { "lsp_status" },
    },
  },
}
